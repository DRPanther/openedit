Program SE_SpellChecker;
{$I c:\bp\oedit\DEFINES.INC}
Uses Crt,Utilpack,DOS;
Var
 DicName,
 St: String;
 TimeStart: Real;
 Errors: LongInt;
 SkipWord: Array[1..255] Of String[25];
 SkipWords: Byte;

Procedure SpellCheck(FN2Chek: String);
Var
 AtoZ: Boolean;
 Y: Byte;
 NewWord,
 OrigWord,
 SearchWord,
 OrigS: String;
 Tmp,
 SpcPos,
 PtrPos,
 SepCnt: Byte;
 NewF,
 F: Text;
 NR: Word;
 C: Char;
 Idx: LongInt;
 IdxFile: File Of LongInt;
 DatFile: File;
 IdxFS: LongInt;
 S: String;
 StartTime: Real;
 First2: Array[1..3] Of Char;
Label LemmeOut;

Function LookUp(SearchWord: String): Boolean;
Var
 Compare,
 S: String;
 ShouldBePos: LongInt;
 LenByte: Char;
 MiscWordStart: LongInt;
 CheckWord: String[35];

Label SmallOne;
Begin                            {Do not check capitalized words}
{ If (OrigS[1]=UpCase(OrigS[1])) Then Begin LookUp:=True; Exit; End;}
{ If SearchWord[0]<#3 Then Goto SmallOne;}
 CheckWord:=SearchWord;
 While Length(CheckWord)<3 Do CheckWord:=CheckWord+'A';
 Move(Mem[Seg(CheckWord):Ofs(CheckWord)+1],First2,3);
 Move(Mem[Seg(CheckWord):Ofs(CheckWord)],Compare,4); Compare[0]:=#3;

 ShouldBePos:=((ord(First2[1])-Ord('A'))*26*26)+((ord(First2[2])-Ord('A'))*26)+(ord(First2[3])-Ord('A'));
 If (ShouldBePos>=IdxFS) Then
  Begin
   LookUp:=False;
   Exit;
  End;
 If (ShouldBePos<0) then Goto SmallOne;
 Seek(IdxFile,ShouldBePos);
 Read(IdxFile,Idx);
 If Idx<>-1 Then
  Begin
   Seek(DatFile,Idx+256);
   Repeat
    BlockRead(DatFile,S[0],1,NR);
    BlockRead(DatFile,Mem[Seg(S):Ofs(S)+1],Ord(S[0]),NR);
    If SearchWord=S Then Begin LookUp:=True; Exit; End;
   Until S[1]+S[2]+S[3]<>Compare;
  End;

 SmallOne: { <--- Not nececssarily a small one -- just an unsorted one }
 If SearchWord[0]=#1 Then Begin LookUp:=True; Exit; End;
 Seek(DatFile,252);
 BlockRead(DatFile,MiscWordStart,SizeOf(MiscWordStart),NR);
 If MiscWordStart=$1A0A0D73 Then MiscWordStart:=440061; { Old Dict Style }
 If MiscWordStart<>0 Then
  Begin
   Seek(DatFile,MiscWordStart+256);
   Repeat
    BlockRead(DatFile,S[0],1,NR);
    BlockRead(DatFile,Mem[Seg(S):Ofs(S)+1],Ord(S[0]),NR);
    If SearchWord=S Then Begin LookUp:=True; Exit; End;
   Until (NR=0);
  End;
 LookUp:=False;
End;

Procedure AddWord(S: String);
Begin
 Seek(DatFile,FileSize(DatFile));
 BlockWrite(DatFile,S,Length(S)+1);
End;

Function BadWord(S: String): Boolean;
Var Tmp: Byte;
Begin
 S:=UCase(S);
 BadWord:=False;
 For Tmp:=1 To SkipWords Do
  If S=SkipWord[Tmp] Then Begin BadWord:=True; Exit; End;
End;

Label RedoFromStart;
Begin
 SkipWords:=0;
 Assign(IdxFile,DicName+'.IDX');
 Reset(IdxFile);
 IdxFS:=FileSize(IdxFile);
 Assign(DatFile,DicName+'.DAT');
 Reset(DatFile,1);
 Assign(F,FN2Chek);
 Reset(F);
 Delete(FN2Chek,Pos('.',FN2Chek),255);
 FN2Chek:=FN2CHek+'.CHK';
 Assign(NewF,FN2Chek);
 ReWrite(NewF);
 Errors:=0;
 While Not Eof(F) Do
  Begin
   ReadLn(F,S);
   If S='' Then Continue;
   If WhereY=23 Then ClrScr;
   WriteLn(S);
   OrigS:=S;

   RedoFromStart:
   S:=UCase(S)+' ';
   While Pos('/',S)>0 Do S[Pos('/',S)]:=#32;
   PtrPos:=0;
   While S<>'' Do
    Begin
     If (S[1]=' ') Then Begin Inc(PtrPos); Delete(S,1,1); Continue; End;
     SpcPos:=Pos(' ',S)-1;
     Inc(PtrPos,SpcPos);
     SearchWord:=Copy(S,1,SpcPos);
     OrigWord:=SearchWord;
     Delete(S,1,SpcPos);
     AToZ:=False;
     For Tmp:=1 To Length(SearchWord) Do
      Begin
       If (SearchWord[Tmp]<>#39) And (SearchWord[Tmp]<>#45) And
          ((SearchWord[Tmp]<#65) Or (SearchWord[Tmp]>#90)) Then
          SearchWord[Tmp]:=#32;
       If Not (SearchWord[Tmp] in [#39,#45,#32]) Then AToZ:=True;
      End;
     While Pos(#32,SearchWord)>0 Do Delete(SearchWord,Pos(#32,SearchWord),1);
     If (SearchWord='') Or (Not AToZ) Then Continue;
     If Not BadWord(SearchWord) Then
     If (Not Lookup(SearchWord)) then
      Begin
       GotoXY(PtrPos-Length(OrigWord)+1,WhereY);
       Y:=WhereY;
       Write(MakeStr(Length(OrigWord),'^'));
       GotoXY(1,24); ClrEol;
       WriteLn(' Not found: ',SearchWord);
       Write  (' [A]dd, [C]hange, [S]kip all, [ENTER] to continue, [Q]uit');
       Inc(Errors);
       GotoXY(PtrPos,Y);
       Case UpCase(ReadKey) Of
         'S': Begin
               Inc(SkipWords);
               SkipWord[SkipWords]:=UCase(SearchWord);
              End;
         'C': Begin
               Y:=WhereY;
               GotoXY(1,24); Write(' Enter new spelling: ');
               Read_Str(NewWord,30,Copy(OrigS,PtrPos-Length(OrigWord)+1,Length(OrigWord)));
               Delete(OrigS,PtrPos-Length(OrigWord)+1,Length(OrigWord));
               Insert(NewWord,OrigS,PtrPos-Length(OrigWord)+1);
               GotoXY(1,Y-1);
               ClrEol; WriteLn(OrigS); S:=OrigS; ClrEol;
               PtrPos:=0;
               Goto RedoFromStart;
              End;
         'A': AddWord(SearchWord);
         'Q': Goto LemmeOut;
        End;
       GotoXY(1,WhereY); ClrEol;
      End;
     If S=' ' Then S:='';
    End;
   WriteLn(NewF,OrigS);
  End;

 LemmeOut:
 Close(DatFile);
 Close(IdxFile);
 Close(NewF);
 Close(F);
End;

Procedure Terminate(ExitVal: Byte);
Begin
 WriteLn(' ş Active for ',FormatTime(Timer-TimeStart),'.');
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 Halt(ExitVal);
End;

Begin
 DicName:='CE_DIC';
 TimeStart:=Timer;
 WriteLn(' CheepEDIT Textfile Spellchecker ş Copyright 2010, by Shawn Highfield     ');
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 If Not FileExists(DicName+'.DAT') Then
  Begin
   WriteLn('Dictionary datafile ',DicName,'.DAT does not exist in current directory!');
   Terminate(1);
  End;
 If Not FileExists(DicName+'.IDX') Then
  Begin
   WriteLn('Dictionary index ',DicName,'.IDX does not exist in current directory!');
   Terminate(1);
  End;
 If ParamCount=0 Then
  Begin
   WriteLn(' ş Filename to spellcheck must be specified.');
   Terminate(1);
  End;
 St:=UCase(FExpand(ParamStr(1)));
 if Not FileExists(St) Then
  Begin
   WriteLn(' ş '+St+' does not exist!');
   Terminate(1);
  End;

 SaveScreen(1);
 ClrScr;
 SpellCheck(St);
 RestoreScreen(1);
 WriteLn(' ş Found ',CommaFmt(Errors),' errors.');
 Terminate(0);
End.
