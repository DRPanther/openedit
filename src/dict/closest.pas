Program TE_SpellChecker;
Uses Crt,Utilpack,DOS;
Var
 Possible: Array[1..128] Of String[25];
 PosNum: Byte;

 SkipWord: Array[1..255] Of String[25];
 SkipWords: Byte;
 NR: Word;
 Idx: LongInt;
 IdxFile: File Of LongInt;
 DatFile: File;
 First2: Array[1..3] Of Char;
 IdxFS: LongInt;
 Changes: Byte;
 WLen: Byte;

Label LemmeOut;

Procedure xDel(Var S: String; Start: Byte; Rep: Byte);
Begin
 If (Start>Ord(S[0])) Or (Start=0) Then Exit;
 If Start+Rep-1>Ord(S[0]) Then Rep:=Ord(S[0])-Start+1;
 Move(S[Start+Rep],S[Start],Ord(S[0])-Start-Rep+1);
 S[0]:=Chr(Ord(S[0])-Rep);
End;

Function LookUp(SearchWord: String): Boolean;
Var
 Compare,
 S: String;
 ShouldBePos: LongInt;
 LenByte: Char;
Label SmallOne;
Begin
 If SearchWord[0]<#3 Then Goto SmallOne;
 Move(Mem[Seg(SearchWord):Ofs(SearchWord)+1],First2,3);
 Move(Mem[Seg(SearchWord):Ofs(SearchWord)],Compare,4); Compare[0]:=#3;

 ShouldBePos:=((ord(First2[1])-Ord('A'))*26*26)+((ord(First2[2])-Ord('A'))*26)+(ord(First2[3])-Ord('A'));
 If (ShouldBePos>=IdxFS) Or (ShouldBePos<0) Then
  Begin
   LookUp:=False;
   Exit;
  End;
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

 SmallOne:
 If SearchWord[0]=#1 Then Begin LookUp:=True; Exit; End;
 Seek(DatFile,440061+256);
 Repeat
  BlockRead(DatFile,S[0],1,NR);
  BlockRead(DatFile,Mem[Seg(S):Ofs(S)+1],Ord(S[0]),NR);
  If SearchWord=S Then Begin LookUp:=True; Exit; End;
 Until (NR=0);
 LookUp:=False;
End;

Procedure Swap(C1,C2: Byte; Var S: String);
Var C: Char;
Begin
 C:=S[C1];
 S[C1]:=S[C2];
 S[C2]:=C;
End;

Procedure Yup(S: String);
Var
 Tmp: Byte;
 Found: Boolean;
Begin
 Found:=False;
 For Tmp:=1 To PosNum Do If Possible[Tmp]=S Then Begin Found:=True; Break; End;
 If (Not Found) And (Changes / WLen < 0.5) Then
  Begin
   Inc(PosNum); Possible[PosNum]:=S;
  End;
End;

Procedure AnyCombo(BadWord,ChekWord: String);
Var
 BWH: String;
 Hold: String;
 Hold2: String;
 Tmp: Byte;
 Tmp2: Byte;
 Tmp3: Byte;
 Hold3: String;
Begin
 WLen:=Length(BadWord);
 Changes:=0;
 For Tmp:=1 To Length(ChekWord)-1 Do { Chek for letter reversal (TMEP->TEMP) }
  Begin
   Inc(Changes);
   Hold:=ChekWord;
   Swap(Tmp,Tmp+1,Hold);
   If Hold=BadWord Then Yup(ChekWord);

   For Tmp2:=1 To Length(Hold) Do    { Chek for letter insertion (TTEMP->TEMP) }
    Begin
     Inc(Changes);
     Hold2:=Hold;
     xDel(Hold2,Tmp2,1);
     If Hold2=BadWord Then Yup(ChekWord);

     For Tmp3:=1 To Length(Hold2) Do    { Chek for letter insertion (TTEMP->TEMP) }
      Begin
       Inc(Changes);
       Hold3:=Hold2;
       Hold3[Tmp3]:=BadWord[Tmp3];
       If Hold3=BadWord Then Yup(ChekWord);
       Dec(Changes);
      End;

     Dec(Changes);
    End;

   For Tmp2:=1 To Length(BadWord) Do    { Chek for letter insertion (TTEMP->TEMP) }
    Begin
     Inc(Changes);
     BWH:=BadWord;
     xDel(BWH,Tmp2,1);
     If BWH=Hold Then Yup(ChekWord);
     Dec(Changes);
    End;

   Dec(Changes);
  End;

 For Tmp2:=1 To Length(ChekWord) Do    { Chek for letter insertion (TTEMP->TEMP) }
  Begin
   Inc(Changes);
   Hold2:=ChekWord;
   xDel(Hold2,Tmp2,1);
   If Hold2=BadWord Then Yup(ChekWord);
   Dec(Changes);
  End;

 For Tmp2:=1 To Length(BadWord) Do    { Chek for letter insertion (TTEMP->TEMP) }
  Begin
   Inc(Changes);
   BWH:=BadWord;
   xDel(BWH,Tmp2,1);
   If BWH=ChekWord Then Yup(ChekWord);
   Dec(Changes);
  End;

  For Tmp2:=1 To Length(ChekWord) Do    { Chek for letter insertion (TTEMP->TEMP) }
   Begin
    Inc(Changes);
    Hold2:=ChekWord;
    Hold2[Tmp2]:=BadWord[Tmp2];
    If Hold2=BadWord Then Yup(ChekWord);
    Dec(Changes);
   End;

End;


Function Match3(Var s1:String; Var s2:String; case_sensitive:boolean):word;
{Uncle Ron's algorithm to compare two strings, returns percentage match}
{Case sensitive/not switch    Most versatile, speed comparison varies}
{Ron Nossaman Oct 29, 1994}
begin
   asm
      push ds
      les di,[s2]
      lds si,[s1]
      xor ax,ax
      SEGDS mov al,[si]
      cmp al,0
      je @nolength
      mov cx,ax        {cx= length of string1}
      SEGES mov al,[di]
      cmp al,0
      jne @docmp       {ax= length of string2}
@nolength:
      jmp @millertime        {BAIL}

@docmp:       { ;neither strings zero length, do it}
      cld
      mov dx,ax         {save length(s2)}
      add ax,di
      mov bx,ax         {bx= pointer last char s2}
      inc di            {di= pointer first char s2}
      mov ax,dx         {retreive length(s2)}
      add ax,cx         {+length(s1)}
      push ax           {save total length both strings until final scoring}
      mov ax,cx         {length(s1)}
      add ax,si         {ax=pointer last char s1}
      inc si            {si=pointer first char s1}
      Xor dx,dx         {zero score}


      {cast:}           {ax=lastchar s1}
                        {bx=lastchar s2}
                        {si=firstchar s1}
                        {di=firstchar s2}
                        {dx=accumulated score}
                        {cx=temporary position marker during compare}


      mov cx,0          {indicator flag of first pass through compare}
                   {cheap dodge, since you can't call & ret in T.P. asm}
      jmp @compare
@round2:
      les di,[s1]     {swap string beginnings}
      lds si,[s2]
      inc si
      inc di
      xchg ax,bx      {swap s1 and s2 end pointers}
                      {'total' still on stack}
      mov cx,1          {pass 2 indicator}

@compare:
      push cx     {save pass indicator}
      mov cx,di   {let keeper remember starting point}
@workloop:
      push ax       {save eos pointer to free up ax register}
      SEGDS mov al,[si]
      cmp case_sensitive,0
      jnz @CaseOK1
      cmp al,'Z'
      jg  @CaseOK1
      cmp al,'A'
      jl  @CaseOK1
      or al,$20
@CaseOK1:
      mov ah,al
      SEGES mov al,[di]
      cmp case_sensitive,0
      jnz @CaseOK2
      cmp al,'Z'
      jg  @CaseOK2
      cmp al,'A'
      jl  @CaseOK2
      or al,$20
@CaseOK2:
      cmp al,ah     {are chars equal?}
      jne @nomatch  {no, pass on}
      inc si        {yes, increment both string position pointers}
      inc di
      mov cx,di     {keeper remembers new starting position}
      inc dx        {score}
      jmp @progress
@nomatch:
      inc di    {no match, try next char in second string}
@progress:
      pop ax       {restore end of string pointer}
      cmp di,bx     {is string 2 used up without match?}
      jle @nofix    {nope, go on}
      mov di,cx     {restore last unmatched position}
      cmp di,bx     {is string 2 matched to the end?}
      jle @nofix2   {no, go try next letter of string1}
      mov si,ax     {yes, nothing left to compare, cancel further search}
@nofix2:
      inc si        {next char string1}
@nofix:
      cmp si,ax     {done yet?}
      jle @workloop {nope, hiho}
      pop cx        {retreive pass indicator}
      cmp cx,0      {0=pass1}
      je @round2    {go back for pass 2}
      mov ax,dx     {score}
      mov cx,100
      mul cx
      pop cx      {get 'total' characters}
      div cx
@millertime:
      mov @result,ax
      pop ds
   end;
end;

Procedure FindClosest(SearchWord: String);
Var
 Compare,
 S: String;
 ShouldBePos: LongInt;
 LenByte: Char;
 Round: Byte;
 C: Char;
 MinLen,MaxLen: Byte;

Label NextRound;
Begin
 PosNum:=0;

 If Length(SearchWord)<3 Then SearchWord:=SearchWord+MakeStr(3-Length(SearchWord),'A');

 Move(Mem[Seg(SearchWord):Ofs(SearchWord)+1],First2,3);
 Move(Mem[Seg(SearchWord):Ofs(SearchWord)],Compare,4); Compare[0]:=#3;

 Round:=1;
 NextRound:
(*
 First2[2]:='A';  { <- Comment this }
 First2[3]:='A';
*)
 ShouldBePos:=((ord(First2[1])-Ord('A'))*26*26)+((ord(First2[2])-Ord('A'))*26)+(ord(First2[3])-Ord('A'));

 If (ShouldBePos>=IdxFS) Or (ShouldBePos<0) Then
  Begin
   WriteLn('Can''t do it.');
   Exit;
  End;

 Seek(IdxFile,ShouldBePos);
 Idx:=-1;

 While (Idx=-1) And (Not Eof(IdxFile)) Do
  Read(IdxFile,Idx);

 MinLen:=Length(SearchWord)-System.Round(Length(SearchWord)*0.3);
 MaxLen:=Length(SearchWord)+System.Round(Length(SearchWord)*0.3);

 If Idx<>-1 Then
  Begin
   Seek(DatFile,Idx+256);
   Repeat
    BlockRead(DatFile,S[0],1,NR);
    BlockRead(DatFile,Mem[Seg(S):Ofs(S)+1],Ord(S[0]),NR);
{    AnyCombo(SearchWord,S);}
    If Length(S) in [MinLen..MaxLen] Then
     If (Match3(SearchWord,S,False)>65) Then
      Begin
       Inc(PosNum);
       Possible[PosNum]:=S;
      End;
   Until S[1]{+S[2]}<>First2[1]{+First2[2]};
   Exit;
  End;
 If (Round<>3) Then
  Begin
   Inc(Round);
   Move(Mem[Seg(SearchWord):Ofs(SearchWord)+1],First2,3);
   Move(Mem[Seg(SearchWord):Ofs(SearchWord)],Compare,4); Compare[0]:=#3;
   Case Round Of
     2: Begin
         Swap(1,2,Compare);
         C:=First2[1];
         First2[1]:=First2[2];
         First2[2]:=C;
         Goto NextRound;
        End;
     3: Begin
         Swap(2,3,Compare);
         C:=First2[2];
         First2[2]:=First2[3];
         First2[3]:=C;
         Goto NextRound;
        End;
    End;
  End;
End;

Procedure AddWord(S: String);
Begin
 Seek(DatFile,FileSize(DatFile));
 BlockWrite(DatFile,S,Length(S)+1);
End;

Begin
 SkipWords:=0;
 Assign(IdxFile,'TE_DIC.IDX');
 Reset(IdxFile);
 IdxFS:=FileSize(IdxFile);
 Assign(DatFile,'TE_DIC.DAT');
 Reset(DatFile,1);

 WriteLn('----------------');
 Write('Searching for possible matches...');
 FindClosest(UCase(ParamStr(1)));
 Write(#13); ClrEol;
 For NR:=1 To PosNum DO
  WriteLn(Possible[NR]);

 Close(DatFile);
 Close(IdxFile);
End.
