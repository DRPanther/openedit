Program LangEdit;
{$I DEFINES.INC}
Uses Crt,Utilpack,DESUnit,DOS;
{$I SEDIT.INC}
Const
 BarColor = 1;
 Default: Array[1..LangCnt] Of String[75] = (
'Quote Window               '                                               ,
'Quote Line       '                                                         ,
'Edit Message     '                                                         ,
'Abort message?             '                                               ,
'Menu   '                                                                   ,
'Save   '                                                                   ,
'User Signature       '                                                     ,
'You will have the option of appending your signature to each message you'  ,
'write.  When saving, you will be asked if you want to use the signature.'  ,
'User Configuration         '                                               ,
'Expand Text:               New Text:                '                      ,
'Use Taglines?'                                                             ,
'Use Expand?  '                                                             ,
'Use Keywords?'                                                             ,
'Ask Spellchk?'                                                             ,
'Auto Tagline?'                                                             ,
'Auto Sigs?   '                                                             ,
'Your Signature'                                                            ,
'Frame Colors        Text Colors        Input Colors       Tagline Kwds  '  ,
'Frame 1'                                                                   ,
'Capital'                                                                   ,
'Frame 2'                                                                   ,
'LowCase'                                                                   ,
'Frame 3'                                                                   ,
'Digits '                                                                   ,
'Frame 4'                                                                   ,
'Symbols'                                                                   ,
'Cannot save an empty message.               '                              ,
'Warning:    '                                                              ,
'of your message is quoted.      '                                          ,
'Please remove some quoting before saving.   '                              ,
'Return to edit & remove some quoting?       '                              ,
'Add your signature to this message?         '                              ,
'Save    '                                                                  ,
'Abort   '                                                                  ,
'Resume  '                                                                  ,
'Help    '                                                                  ,
'Aborting Message...        '                                               ,
'Sorry, you have been prohibited from posting messages in the current area:',
'Please use a different message group.                                     ',
'Returning to BBS...                                                       ',
'Spellcheck this message?           '                                       ,
'Spell Checker                      '                                       ,
'Spellchecking Message...              '                                    ,
'Word not found:          '                                                 ,
'[S] Skip  [A] Skip all  [D] Add to dict  [C] Change word  [Q] Quit    '    ,
'Enter new spelling:        '                                               ,
'Spellcheck complete                   '                                    ,
'Press [ESC] to return or [ENTER] to continue...           '                ,
'Taglines          '                                                        ,
'Commands          '                                                        ,
'Move              '                                                        ,
'IntelliTag        '                                                        ,
'Random            '                                                        ,
'Keyword           '                                                        ,
'Cancel            '                                                        ,
'Select            '                                                        ,
'Enter New         '                                                        ,
'New List          '                                                        ,
'No Tag            '                                                        ,
'Keyword           '                                                        ,
'Type your search keyword now:                                             ',
'Manual Entry      '                                                        ,
'Type your own tagline now:                                                ',
'Tagline           '                                                        ,
'Saving message...        '                                                 ,
'Overstrike        '                                                        ,
'Sorry, you must write at least        '                                    ,
'lines.   '                                                                 ,
'Sorry, this message may not be aborted.                '                   ,
'Import File             '                                                  ,
'Enter full path/filename of textfile to import:             '              ,
'[ENTER] to abort      '                                                    ,
'Export Message          '                                                  ,
'Enter full path/filename of textfile to export to:          '              ,
'SysOp dropping to DOS, please wait...          '                           ,
'Type EXIT to return to Open!EDIT...            '                           ,
'SysOp is using system, please wait...          '                           ,
'Executing program...                           '                           ,
'Select       '                                                             ,
'Time limit exceeded, exiting!                  '                           ,
'Quote       '                                                              ,
'Setup       '                                                              ,
'Help!       '                                                              ,
'20 Seconds Until Inactivity Timeout!                        '              ,
'Only 2 minutes remaining!          '                                       ,
'Only 1 minute remaining!           '                                       ,
'User Inactive, Disconnecting...    '                                       ,
'Tagline Selection Screen                '                                  ,
'Searching for taglines matching your keyword, please wait...            '  ,
'Searching for taglines related to the message subject, please wait...   '  ,
'Searching for taglines matching your keywords, please wait...           '  ,
'Sorry, no taglines match your tagline keyword!                          '  ,
'Sorry, could not find any taglines related to the message subject!      '  ,
'Sorry, no taglines match your tagline keywords!                         '  ,
'Scanning taglines, please wait...                                       '  ,
'Auto-appending tagline to message...                                    '  ,
'Choose a tagline to append to your message:                             '  ,
'Welcome to       '                                                         ,
'Please select a language                   '                               ,
'Change Language'                                                           ,
'Field Color    ',
'SysOp is editing your account, please wait...             '
);
Type
 LangType = Array[1..LangCnt] Of String[75];

Var
 Lang: ^LangType;
 LangFile: String[8];
 LangName: String[16];

 Top,Hil,Tmp: LongInt;
 C: Char;

Function LoadS: String;
Type XType = Array[1..83] Of Char;
Var
 XF: File Of XType;
 X: XType;
 S: String;
 Cnt: Word;
Begin
 Cnt:=0;
 Assign(XF,LangFile+'.LNG');
 FileMode:=66;
 {$I-} Reset(XF); {$I+}
 If IOresult<>0 Then
  Begin
   WriteLn('Cannot locate ',LangFile+'.LNG');
  End;
 Read(XF,X);
 While Not Eof(XF) Do
  Begin
   Read(XF,X);
   Move(X[6],S[1],75); S[0]:=#75; Delete(S,Pos(#0,S),255); S:=RTrim(S);
   Inc(Cnt);
   Lang^[Cnt]:=S;
  End;
 Close(XF);
End;

Function SaveS: String;
Type XType = Array[1..83] Of Char;
Var
 XF: File Of XType;
 X: XType;
 S: String;
 Cnt: Word;
Begin
 Cnt:=0;
 Assign(XF,LangFile+'.LNG');
 FileMode:=66;
 Reset(XF);
 Read(XF,X);
 While Not Eof(XF) Do
  Begin
   Inc(Cnt);
   S:=Lang^[Cnt];
   FillChar(X,SizeOf(X),#0);
   Move(S[1],X[6],Length(S));
   Write(XF,X);
  End;
 Close(XF);
End;

Procedure Box(X,Y,Wid,Len: Byte; Shadow: Boolean);
Const BA = BarColor;
Var Tmp: Byte;
Begin
 TextAttr:=BA;
 GotoXY(X,Y);
 Write('Ú'+MakeStr(Wid-2,'Ä')+'¿');
 For Tmp:=Y+1 To Y+Len Do
  Begin
   TextAttr:=BA;
   GotoXY(X,Tmp);
   Write('³'+MakeStr(Wid-2,' ')+'³');
   If Shadow Then Begin TextAttr:=$08; Write(GetChar); Write(GetChar); End;
  End;
 TextAttr:=BA;
 GotoXY(X,Y+Len+1); Write('À'+MakeStr(Wid-2,'Ä')+'Ù');
 If Shadow Then
  Begin
   TextAttr:=$08; Write(GetChar); Write(GetChar);
   GotoXY(X+2,Y+Len+2); For Tmp:=1 To Wid Do Write(GetChar);
  End;
End;

Procedure XWrite(S: String);
Begin
 TextAttr:=$07;
 While Pos('^\',S)>0 Do
  Begin
   Write(Copy(S,1,Pos('^\',S)-1));
   Delete(S,1,Pos('^\',S)+1);
   TextAttr:=LIntVal('$'+Copy(S,1,2));
   Delete(S,1,2);
  End;
 Write(S);
End;

Procedure Center(S: String; B: Byte);
Begin
 GotoXY(40-(Length(S) Div 2),B);
 Write(S);
End;

Function GetLangFile: String;
Var
 S: String;
 Hil,Top,Tmp,Max: Word;
 LFile: Array[1..45] Of String[30];
 LFs: Byte;
 SR: SearchRec;
 F: File;
 Buf: Array[1..16] Of Char;
Begin
 SaveScreen(3);
 Box(4,4,72,4,True);
 TextAttr:=$07;
 Center('Open!EDIT v'+Ver+' Language Editor',6);
 Center('Copyright (C) 2011, By Shawn Highfield of www.tinysbbs.com ',7);
 LFs:=0;
 FindFirst('*.LNG',AnyFile,SR);
 While DOSError=0 Do
  Begin
   If SR.Attr And Directory <> 0 Then Begin FindNext(SR); Continue; End;
   Inc(LFs);
   LFile[LFs]:=SR.Name;
   Assign(F,SR.Name);
   Reset(F,1);
   Seek(F,$20); BlockRead(F,Buf,SizeOf(Buf));
   Move(Buf,S[1],16);
   S[0]:=#16; S:=RTrim(S);
   If S='Use LANGEDIT.EXE' Then
    Begin
     S:='Unknown Language';
     Move(S[1],Buf,16);
     Seek(F,$20); BlockWrite(F,Buf,SizeOf(Buf));
     Seek(F,$20-3); Buf[1]:=':'; BlockWrite(F,Buf[1],1);
     Seek(F,$30); FillChar(Buf,SizeOf(Buf),#32); BlockWrite(F,Buf,9);
    End;
   Close(F);
   LFile[LFs]:=Pad(LFile[LFs],12)+FPad(S,18);
   FindNext(SR);
  End;
 If LFs=0 Then
  Begin
   Window(1,1,80,25);
   Box(20,12,38,6,True);
   GotoXY(22,14); XWrite('^\07Sorry, there are no language files');
   GotoXY(22,15); XWrite('^\07(*.LNG) the current directory.    ');
   GotoXY(22,17); XWrite('^\07                    Press any key.');
   ReadKey;
   TextAttr:=$07; Window(1,1,80,25); ClrScr; Halt;
  End;
 TextAttr:=$0F; GotoXY(2,1); ClrEol; Write('Please select a language file to edit');

 Box(22,12,36,8,True);
 Window(24,13,56,20);
 Hil:=1; Top:=0;
 TextAttr:=$07; ClrScr;
 Max:=8; If Max>LFs Then Max:=LFs;
 For Tmp:=1 To Max Do
  Begin
   GotoXY(1,Tmp); Write(' ',Pad(LFile[Tmp],31));
  End;
 Repeat
  GotoXY(1,Hil); TextAttr:=$1F; Write(' ',Pad(LFile[Top+Hil],31));
  C:=UpCase(ReadKey);
  GotoXY(1,Hil); TextAttr:=$07; Write(' ',Pad(LFile[Top+Hil],31));
  Case C Of
    #13: Begin
          GetLangFile:=Copy(LFile[Top+Hil],1,Pos('.',LFile[Top+Hil])-1);;
          Delete(LFile[Top+Hil],1,Pos(' ',LFile[Top+Hil]));
          LFile[Top+Hil]:=RTrim(LTrim(LFile[Top+Hil]));
          LangName:=LFile[Top+Hil];
          RestoreScreen(3);
          Exit;
         End;
    #00: Case ReadKey Of
          'H': Begin
                Dec(Hil);
                If Hil=0 Then
                 Begin
                  Inc(Hil);
                  If Top>0 Then
                   Begin
                    Dec(Top);
                    GotoXY(1,1); InsLine;
                    GotoXY(1,1); Write(' ',Pad(LFile[Top+Hil],31));
                   End;
                 End;
               End;
          'P': Begin
                If Hil+1<=LFs Then Inc(Hil);
                If Hil=9 Then
                 Begin
                  Dec(Hil);
                  If Top+Hil+1<=LFs Then
                   Begin
                    Inc(Top);
                    GotoXY(1,1); DelLine;
                    GotoXY(1,8); Write(' ',Pad(LFile[Top+Hil],31));
                   End;
                 End;
               End;
         End;
   End;
 Until C=#27;
 TextAttr:=$07; Window(1,1,80,25); ClrScr; Halt;
End;

Procedure ChangeName;
Var
 F: File;
 Buf: Array[1..16] Of Char;
 S: String[32];
Begin
 SaveScreen(8);

 Window(1,1,80,25);
 Assign(F,LangFile+'.LNG');
 Reset(F,1);
 Seek(F,$20); BlockRead(F,Buf,SizeOf(Buf));
 Move(Buf,S[1],16);
 S[0]:=#16; S:=Rtrim(S);

 Box(20,12,38,4,True);
 GotoXY(22,14); XWrite('^\07Enter new name for this language: ');
 GotoXY(22,15); TextAttr:=$1F; Read_Str(S,16,S);
 S:=Pad(S,16);
 Move(S[1],Buf,16);
 Seek(F,$20); BlockWrite(F,Buf,SizeOf(Buf));
 Close(F);

 LangName:=RTrim(S);

 RestoreScreen(8);
 TextAttr:=$01; GotoXY(2,11); Write(MakeStr(78,#196));
 TextAttr:=$09; Center(' '+LangName+' ',11);

End;

Begin
{---Shawn:
 DES(Mem[Seg(EncVer):Ofs(EncVer)+1],Mem[Seg(Ver):Ofs(Ver)+1],KeyVer,False);  { Decrypt version number }
 Ver[0]:=#5;
 New(Lang);

 ClrScr;
 CursorOff;
 FillScr(#176,$07);
 Top:=0;
 Hil:=1;
 TextAttr:=$0F; GotoXY(1,1); ClrEol;
 TextAttr:=$01; GotoXY(1,2); Write(MakeStr(80,#196));
 TextAttr:=$01; GotoXY(1,24); Write(MakeStr(80,#196));
 TextAttr:=$0F; GotoXY(1,25); ClrEol;
 Write(' Open!EDIT v'+Ver+' Language Editor     By Shawn Highfield                     ');

 LangFile:=GetLangFile;
 LoadS;

 TextAttr:=$0F; GotoXY(2,1); ClrEol;
 Write(' '#24'/'#25' = Scroll  ENTER = Edit  Alt+D = Reset to Default  Alt+N = Language Name');
 Box(1,4,80,4,False);
 Box(1,11,80,10,False);

 TextAttr:=$09;
 Center(' '+LangName+' ',11);

 TextAttr:=$07;
 For Tmp:=1 To 8 Do
  Begin
   GotoXY(3,12+Tmp); Write(Lang^[Tmp]);
  End;
 Repeat
  GotoXY(3,6); TextAttr:=$0F; Write(Pad(Default[Top+Hil],76));
  GotoXY(3,7); TextAttr:=$07; Write(Pad(Lang^[Top+Hil],76));
  GotoXY(2,12+Hil);
  TextAttr:=$1F;
  If Length(Lang^[Top+Hil])>Length(Default[Top+Hil]) Then Write('>') Else Write(' ');
  Write(Pad(Lang^[Top+Hil],76)+' ');
  C:=UpCase(ReadKey);
  GotoXY(2,12+Hil);
  TextAttr:=$07;
  If Length(Lang^[Top+Hil])>Length(Default[Top+Hil]) Then Write('>') Else Write(' ');
  Write(Pad(Lang^[Top+Hil],76)+' ');
  Case C Of
    #13: Begin
          TextAttr:=$0F; GotoXY(2,1); ClrEol; Write('Enter new text for this string');
          GotoXY(3,7); TextAttr:=$1F; Write(Pad(Lang^[Top+Hil],Length(Default[Top+Hil])));
          If Length(Lang^[Top+Hil])>Length(Default[Top+Hil]) Then
           Begin GotoXY(2,1); TextAttr:=$0F; ClrEol; Write(Lang^[Top+Hil]);
                 Lang^[Top+Hil][0]:=Chr(Length(Default[Top+Hil])); End;
          GotoXY(3,7);
          Read_Str(Lang^[Top+Hil],Length(Default[Top+Hil]),RTrim(Lang^[Top+Hil]));
          GotoXY(3,7); TextAttr:=$07; Write(Pad(Lang^[Top+Hil],Length(Default[Top+Hil])));
          Lang^[Top+Hil]:=Pad(Lang^[Top+Hil],Length(Default[Top+Hil]));
          TextAttr:=$0F; GotoXY(2,1); ClrEol;
          Write('  '#24'/'#25' = Scroll  ENTER = Edit  Alt+D = Reset to default  Alt+N = Change name');
         End;
    #0: Case ReadKey Of
          #32: Begin
                Lang^[Top+Hil]:=Default[Top+Hil];
               End;
          '1': ChangeName;
          'H': Begin
                Dec(Hil);
                If Hil=0 Then
                 Begin
                  Inc(Hil);
                  If Top>0 Then
                   Begin
                    Dec(Top);
                    Window(2,13,79,20);
                    InsLine;
                    Window(1,1,80,25);
                    GotoXY(2,13); Write(' '+Pad(Lang^[Top+Hil],76)+' ');
                   End;
                 End;
               End;
          'P': Begin
                Inc(Hil);
                If Hil=9 Then
                 Begin
                  Dec(Hil);
                  If Top+Hil+1<=LangCnt Then
                   Begin
                    Inc(Top);
                    Window(2,13,79,20);
                    DelLine;
                    Window(1,1,80,25);
                    GotoXY(2,20); Write(' '+Pad(Lang^[Top+Hil],76)+' ');
                   End;
                 End;
               End;
         End;
   End;
 Until C=#27;
 SaveS;
 Dispose(Lang);
 ClrScr;
 TextAttr:=$01;
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$07;
 WriteLn('                       Open!EDIT v'+Ver+' Language Editor');
 WriteLn('                     Copyright (C) 2011, By Shawn Highfield       ');
 TextAttr:=$01;
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$07;
 WriteLn;
 CursorOn;
End.
