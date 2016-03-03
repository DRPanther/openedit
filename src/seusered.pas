Unit SEUserEdit;
{$I DEFINES.INC}
Interface

Procedure EditUser;

Implementation

Uses Utilpack,TurboCOM,SE_Util,Crt;

Var
 Modified: Boolean;

Procedure WP(S: String; W: Byte);
Begin
 TextAttr:=$1F; Write(Pad(S,W));
 TextAttr:=$0F;
End;

Procedure FWP(S: String; W: Byte);
Begin
 TextAttr:=$1F; Write(FPad(S,W));
 TextAttr:=$0F;
End;

Function GetDate(W: Word): String;
Var D,M,Y: Word;
Begin
 D:=0; M:=0; Y:=0;
{00} If W And (1 shl 0) <> 0 Then D:=D+(1 shl 0);
{01} If W And (1 shl 1) <> 0 Then D:=D+(1 shl 1);
{02} If W And (1 shl 2) <> 0 Then D:=D+(1 shl 2);
{03} If W And (1 shl 3) <> 0 Then D:=D+(1 shl 3);
{04} If W And (1 shl 4) <> 0 Then D:=D+(1 shl 4);

{05} If W And (1 shl 5) <> 0 Then M:=M+(1 shl 0);
{06} If W And (1 shl 6) <> 0 Then M:=M+(1 shl 1);
{07} If W And (1 shl 7) <> 0 Then M:=M+(1 shl 2);
{08} If W And (1 shl 8) <> 0 Then M:=M+(1 shl 3);

{09} If W And (1 shl 09) <> 0 Then Y:=Y+(1 shl 0);
{10} If W And (1 shl 10) <> 0 Then Y:=Y+(1 shl 1);
{11} If W And (1 shl 11) <> 0 Then Y:=Y+(1 shl 2);
{12} If W And (1 shl 12) <> 0 Then Y:=Y+(1 shl 3);
{13} If W And (1 shl 13) <> 0 Then Y:=Y+(1 shl 4);
{14} If W And (1 shl 14) <> 0 Then Y:=Y+(1 shl 5);
{15} If W And (1 shl 15) <> 0 Then Y:=Y+(1 shl 6);

 GetDate:=LeadingZero(M)+'-'+LeadingZero(D)+'-'+LeadingZero(Y);
End;

Procedure Box(X,Y,Wid,Len: Byte);
Const BA = $01;
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
   TextAttr:=$08; Write(GetChar); Write(GetChar);
  End;
 TextAttr:=BA;
 GotoXY(X,Y+Len+1); Write('À'+MakeStr(Wid-2,'Ä')+'Ù');
 TextAttr:=$08; Write(GetChar); Write(GetChar);
 GotoXY(X+2,Y+Len+2); For Tmp:=1 To Wid Do Write(GetChar);
End;


Procedure RAEditAttr;
Const
 Attrs: Array[1..16] Of String[17] = (
   'Deleted','Clear Screen','More Prompt','ANSI Support',
   'No-Kill','Xfer Priority','FS Msg Editor','Do Not Disturb','Hotkey Support',
   'Avatar','FS Msg Viewer','UserList Hide','Page Priority',
   'No Echo Scan','Guest Account','Post Bill');
Var
 OrigAttr,OrigAttr2: LongInt;
 Hil: Byte;
 Tmp: Byte;
 C: Char;
Begin
 OrigAttr:=RAExitInfo.UserInfo.Attribute;
 OrigAttr2:=RAExitInfo.UserInfo.Attribute2;
 SaveScreen(8);
 CursorOff;
 Box(27,4,26,16);
 TextAttr:=$0F;
 For Tmp:=1 To 16 Do
  Begin
   GotoXY(29,4+Tmp);
   TextAttr:=$0F; Write(Attrs[Tmp]);
   GotoXY(48,4+Tmp);
   TextAttr:=$03; Write('['); TextAttr:=$0B;
   If Tmp<=8 Then
    Begin If RAExitInfo.UserInfo.Attribute And (1 shl (Tmp-1)) <> 0 Then Write('þ') Else Write('ú'); End
   Else
    Begin If RAExitInfo.UserInfo.Attribute2 And (1 shl (Tmp-8-1)) <> 0 Then Write('þ') Else Write('ú'); End;
   TextAttr:=$03; Write(']');
  End;
 Hil:=1;
 Repeat
  GotoXY(28,4+Hil); TextAttr:=$1F; Write(' ',Pad(Attrs[Hil],18));

  C:=ReadKey;

  GotoXY(28,4+Hil); TextAttr:=$0F; Write(' ',Pad(Attrs[Hil],18));

  Case C Of
    #13: Begin
          If Hil<=8 Then
           Begin
            If RAExitInfo.UserInfo.Attribute And (1 shl (Hil-1)) <> 0 Then
             RAExitInfo.UserInfo.Attribute:=RAExitInfo.UserInfo.Attribute-(1 shl (Hil-1))
            Else
             RAExitInfo.UserInfo.Attribute:=RAExitInfo.UserInfo.Attribute+(1 shl (Hil-1))
           End
          Else
           Begin
            If RAExitInfo.UserInfo.Attribute2 And (1 shl (Hil-8-1)) <> 0 Then
             RAExitInfo.UserInfo.Attribute2:=RAExitInfo.UserInfo.Attribute2-(1 shl (Hil-8-1))
            Else
             RAExitInfo.UserInfo.Attribute2:=RAExitInfo.UserInfo.Attribute2+(1 shl (Hil-8-1))
           End;

          GotoXY(49,4+Hil);
          TextAttr:=$0B;
          If Hil<=8 Then
           Begin If RAExitInfo.UserInfo.Attribute And (1 shl (Hil-1)) <> 0 Then Write('þ') Else Write('ú'); End
          Else
           Begin If RAExitInfo.UserInfo.Attribute2 And (1 shl (Hil-8-1)) <> 0 Then Write('þ') Else Write('ú'); End
         End;
    #00: Case ReadKey Of
           'H': If Hil<>1 Then Dec(Hil);
           'P': If Hil<>16 Then Inc(Hil);
          End;
   End;
 Until C=#27;
 CursorOn;
 RestoreScreen(8);
 If Not Modified Then Modified:=(OrigAttr<>RAExitInfo.UserInfo.Attribute);
 If Not Modified Then Modified:=(OrigAttr2<>RAExitInfo.UserInfo.Attribute2);
End;

(* ************************** temporarily removed **************************

Procedure QKEditAttr;
Const
 Attrs1: Array[1..8] Of String[17] = (
   'Deleted','Clear Screen','More Prompt','ANSI Support',
   'No-Kill','Xfer Priority','FS Msg Editor','Female');
 Attrs2: Array[1..8] Of String[17] = (
   'Guest','SSR Active','Reserved','Reserved',
   'Reserved','Reserved','Reserved','Reserved');
Var
 OrigAttr,OrigAttr2: LongInt;
 Hil: Byte;
 Tmp: Byte;
 C: Char;
Begin
 OrigAttr:=QKExitInfo.UserInfo.Attrib;
 OrigAttr2:=QKExitInfo.UserInfo.Attrib2;
 SaveScreen(8);
 CursorOff;
 Box(27,4,26,16);
 TextAttr:=$0F;
 For Tmp:=1 To 16 Do
  Begin
   GotoXY(29,4+Tmp);
   TextAttr:=$0F; Write(Attrs1[Tmp]);
   GotoXY(48,4+Tmp);
   TextAttr:=$03; Write('['); TextAttr:=$0B;
   If Tmp<=8 Then
    Begin If QKExitInfo.UserInfo.Attrib And (1 shl (Tmp-1)) <> 0 Then Write('þ') Else Write('ú'); End
   Else
    Begin If QKExitInfo.UserInfo.Attrib2 And (1 shl (Tmp-8-1)) <> 0 Then Write('þ') Else Write('ú'); End;
   TextAttr:=$03; Write(']');
  End;

 Hil:=1;
 Repeat
  GotoXY(28,4+Hil); TextAttr:=$1F;
  If Hil<=8 Then Write(' ',Pad(Attrs1[Hil],18)) Else Write(' ',Pad(Attrs1[Hil-8],18));

  C:=ReadKey;

  GotoXY(28,4+Hil); TextAttr:=$0F;
  If Hil<=8 Then Write(' ',Pad(Attrs1[Hil],18)) Else Write(' ',Pad(Attrs1[Hil-8],18));

  Case C Of
    #13: Begin
          If Hil<=8 Then
           Begin
            If QKExitInfo.UserInfo.Attrib And (1 shl (Hil-1)) <> 0 Then
             QKExitInfo.UserInfo.Attrib:=QKExitInfo.UserInfo.Attrib-(1 shl (Hil-1))
            Else
             QKExitInfo.UserInfo.Attrib:=QKExitInfo.UserInfo.Attrib+(1 shl (Hil-1))
           End
          Else
           Begin
            If QKExitInfo.UserInfo.Attrib2 And (1 shl (Hil-8-1)) <> 0 Then
             QKExitInfo.UserInfo.Attrib2:=QKExitInfo.UserInfo.Attrib2-(1 shl (Hil-8-1))
            Else
             QKExitInfo.UserInfo.Attrib2:=QKExitInfo.UserInfo.Attrib2+(1 shl (Hil-8-1))
           End;

          GotoXY(49,4+Hil);
          TextAttr:=$0B;
          If Hil<=8 Then
           Begin If QKExitInfo.UserInfo.Attrib And (1 shl (Hil-1)) <> 0 Then Write('þ') Else Write('ú'); End
          Else
           Begin If QKExitInfo.UserInfo.Attrib2 And (1 shl (Hil-8-1)) <> 0 Then Write('þ') Else Write('ú'); End
         End;
    #00: Case ReadKey Of
           'H': If Hil<>1 Then Dec(Hil);
           'P': If Hil<>16 Then Inc(Hil);
          End;
   End;
 Until C=#27;
 CursorOn;
 RestoreScreen(8);
 If Not Modified Then Modified:=(OrigAttr<>QKExitInfo.UserInfo.Attrib);
 If Not Modified Then Modified:=(OrigAttr2<>QKExitInfo.UserInfo.Attrib2);
End;

 ************************** temporarily removed ************************** *)

Procedure CCEditAttr;
Const
 Attrs: Array[1..21] Of String[17] = (
   'VIP Member','No D/L Ratio','Ignore D/L Hours','Do Not Delete',
   'Do Not Disturb','Female','Deleted','Added to BBS List','Mail Check',
   'File Check','Screen Clears','More Prompts','Supports Color',
   'Supports Hotkeys','Use Wordstar Keys','New Bulletin Chk','D/L File Descs',
   'File Desc Format','Viewed File','View Only Once','KillFileAfterView');

 AttrVal: Array[1..21] Of LongInt = (
   $00010000, $00000008, $00000800, $00000080, $00000200, $00000010,
   $00000001, $00008000, $00000002, $00000004, $00000020, $00000040,
   $00000100, $00000400, $00040000, $00020000, $00080000, $00100000,
   $00002000, $00004000, $00001000);

Var
 OrigAttr: LongInt;
 Hil: Byte;
 Tmp: Byte;
 C: Char;
Begin
 OrigAttr:=CCExitInfo.UserInfo.Attrib1;
 SaveScreen(8);
 CursorOff;
 Box(27,1,26,21);
 TextAttr:=$0F;
 For Tmp:=1 To 21 Do
  Begin
   GotoXY(29,1+Tmp);
   TextAttr:=$0F; Write(Attrs[Tmp]);
   GotoXY(48,1+Tmp);
   TextAttr:=$03; Write('['); TextAttr:=$0B;
   If CCExitInfo.UserInfo.Attrib1 And AttrVal[Tmp] <> 0 Then
    Write('þ')
   Else
    Write('ú');
   TextAttr:=$03; Write(']');
  End;
 Hil:=1;
 Repeat
  GotoXY(28,1+Hil); TextAttr:=$1F; Write(' ',Pad(Attrs[Hil],18));

  C:=ReadKey;

  GotoXY(28,1+Hil); TextAttr:=$0F; Write(' ',Pad(Attrs[Hil],18));

  Case C Of
    #13: Begin
          If (CCExitInfo.UserInfo.Attrib1 And AttrVal[Hil]) <> 0 Then
           CCExitInfo.UserInfo.Attrib1:=CCExitInfo.UserInfo.Attrib1-AttrVal[Hil]
          Else
           CCExitInfo.UserInfo.Attrib1:=CCExitInfo.UserInfo.Attrib1+AttrVal[Hil];
          GotoXY(49,1+Hil);
          TextAttr:=$0B;
          If CCExitInfo.UserInfo.Attrib1 And AttrVal[Hil] <> 0 Then
           Write('þ')
          Else
           Write('ú');
         End;
    #00: Case ReadKey Of
           'H': If Hil<>1 Then Dec(Hil);
           'P': If Hil<>21 Then Inc(Hil);
          End;
   End;
 Until C=#27;
 CursorOn;
 RestoreScreen(8);
 If Not Modified Then Modified:=(OrigAttr<>CCExitInfo.UserInfo.Attrib1);
End;

Procedure Read_Str(VAR Return: String; Max: Integer; Default: String; Var Ret: ShortInt);
Var
   GotStr   : String;
   Ch       : Char;
   CharCount: Integer;
   StartPos : Integer;
   Tmp      : Integer;
   W        : Word;
   InsStat  : Boolean; { Override function }
Begin
     InsStat:=True;
     If InsStat Then SmallCursor Else BigCursor;
     Write(Pad('',Max));
     GotoXY(WhereX-Max,WhereY);
     StartPos:=WhereX;
     GotStr:=Default;
     If Read_StrMask Then Write(MakeStr(Length(Default),'*')) Else Write(Default);
      Ch:=' ';
     Repeat
      Ch:=' ';
      If KeyPressed Then
       Begin
        Ch:=ReadKey;
       If (Ch=#8) And (Length(GotStr)>0) Then
         Begin
          If WhereX-StartPos<=Length(GotStr) Then
           Begin
            If WhereX-StartPos>=1 Then
             Begin
              Tmp:=WhereX;
              Delete(GotStr,Tmp-StartPos,1);
              GotoXY(Tmp-1,WhereY);
              Write(Copy(GotStr,Tmp-StartPos,255),' ');
              GotoXY(Tmp-1,WhereY);
             End;
           End
           Else
           Begin
            Write(#8,' ',#8);
            Delete(GotStr,Length(GotStr),1);
           End;
         End;
        If Ch=#27 Then
         Begin Ret:=0; If Not Modified Then Modified:=(GotStr<>Default); Return:=GotStr;
         GotoXY(StartPos,WhereY); Write(Pad(Return,Max)); Exit; End;
        If Ch=#09 Then
         Begin Ret:=+1; If Not Modified Then Modified:=(GotStr<>Default); Return:=GotStr;
         GotoXY(StartPos,WhereY); Write(Pad(Return,Max)); Exit; End;

        If Ch=#25 Then
         Begin
          GotStr:='';
          GotoXY(StartPos,WhereY);
          For CharCount:=1 To Max Do
           Write(' ');
          GotoXY(StartPos,WhereY);
         End;
        If Ch<>#0 Then
         Begin
          If ((Length(GotStr)<Max) Or
              ((Not InsStat) And (WhereX-StartPos<Length (GotStr)))) Then
           Begin
            If Ord(Ch)>31 Then
             Begin
              If WhereX-StartPos<Length(GotStr) Then
               Begin
                If InsStat Then
                 Begin
                  Tmp:=WhereX+1;
                  Insert(Ch,GotStr,Tmp-StartPos);
                  If Read_StrMask Then
                   Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),'*'))
                  Else
                   Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End
                 Else
                 Begin
                  Tmp:=WhereX+1;
                  GotStr[Tmp-StartPos]:=Ch;
                  If Read_StrMask Then
                   Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),'*'))
                  Else
                  Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End;
               End
               Else
               Begin
                If Read_StrMask Then Write('*') Else Write(Ch);
                GotStr:=GotStr+Ch;
               End;
             End;
           End;
         End;
        If Ch=#0 Then
         Begin
          Ch:=ReadKey;
          If Ch=#15 Then
           Begin Ret:=-1; GotoXY(StartPos,WhereY); Write(Pad(Return,Max));
           If Not Modified Then Modified:=(GotStr<>Default); Return:=GotStr; Exit; End;
          If Ch='D' Then
           Begin
            If CCExitFound Then CCEditAttr;
            If RAExitFound Then RAEditAttr;
(* ************************** temporarily removed **************************
            If QKExitFound Then QKEditAttr;
 ************************** temporarily removed ************************** *)
           End;
          If Ch=#71 Then GotoXY(StartPos,WhereY); { Home }
          If Ch=#79 Then GotoXY(StartPos+Length(GotStr),WhereY); { End }
          If Ch=#82 Then { Ins }
           Begin
            InsStat:=Not InsStat;
            If InsStat Then SmallCursor Else BigCursor;
           End;
          If Ch=#83 Then { Del }
           Begin
            If WhereX-StartPos>=1 Then
             Begin
              Tmp:=WhereX;
              Delete(GotStr,Tmp-StartPos+1,1);
              GotoXY(Tmp-1,WhereY);
              If Read_StrMask Then
               Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),'*'))
              Else
               Write(Copy(GotStr,Tmp-StartPos,255),' ');
              GotoXY(Tmp,WhereY);
             End
             Else
             Begin
              Tmp:=WhereX;
              Delete(GotStr,1,1);
              Write(GotStr,' ');
              GotoXY(Tmp,WhereY);
             End;
           End;
          If Ch='K' Then {RetnFlag:=Left;}
           Begin
            If WhereX>StartPos Then
             GotoXY(WhereX-1,WhereY);
           End;
          If Ch='M' Then {RetnFlag:=Right;}
           Begin
            If (WhereX<StartPos+Max) And (WhereX<StartPos+Length(GotStr)) Then
             GotoXY(WhereX+1,WhereY);
           End;
         End;
      End;
     Until Ch=#13;
     If Not Modified Then Modified:=(GotStr<>Default);
     Return:=GotStr;
     GotoXY(StartPos,WhereY); Write(Pad(Return,Max));
     If Read_StrLF Then WriteLn;
     Read_StrLF:=True;
     Read_StrMask:=False;
     SmallCursor;
     Ret:=+1;
End;

Procedure Read_Int(VAR WhatInt: LongInt; Maximum,Default: LongInt; Var Ret: ShortInt);
Var
 Ch: Char;
 RCount: Integer;
 WhatStr: String;
 X: Byte;
Begin
 WhatInt:=Default;
 WhatStr:=StrVal(WhatInt);

 X:=WhereX;
 Write(Pad('',Length(StrVal(Maximum))));
 GotoXY(WhereX-Length(StrVal(Maximum)),WhereY);

 Write(WhatStr);
 Repeat;
  Ch:=ReadKey;
  If (Ch=#8) And (WhatStr<>'') Then
   Begin
    GotoXY(WhereX-1,WhereY); Write(' '); GotoXY(WhereX-1,WhereY);
    Delete(WhatStr,Length(WhatStr),1);
   End;
  If (Ch<>#0) And (Ch<>#8) And (Ch<>#25) And (Ch<>#13) And
     (Length(WhatStr)+1<=Length(StrVal(Maximum))) And
     (LIntVal(WhatStr+Ch)<=Maximum) And (Pos(Ch,'1234567890')>0) And (Not ((WhatStr='0') And (Ch='0'))) Then
   Begin
    Write(Ch);
    WhatStr:=WhatStr+Ch;
   End;
  If Ch=#09 Then
   Begin
    Ret:=+1; WhatInt:=LIntVal(WhatStr); If WhatInt=-1 Then WhatInt:=Default;
    If Not Modified Then Modified:=(Default<>WhatInt);
    GotoXY(X,WhereY); Write(FPad(StrVal(WhatInt),Length(StrVal(Maximum)))); Exit;
   End;
  If Ch=#25 Then
   Begin
    GotoXY(WhereX-Length(WhatStr),WhereY);
    For RCount:=1 To Length(WhatStr) Do Write(' ');
    GotoXY(WhereX-Length(WhatStr),WhereY);
    WhatStr:='';
   End;
  If Ch=#27 Then
   Begin
    WhatInt:=LIntVal(WhatStr); If WhatInt=-1 Then WhatInt:=Default;
    If Not Modified Then Modified:=(Default<>WhatInt);
    GotoXY(X,WhereY); Write(FPad(StrVal(WhatInt),Length(StrVal(Maximum))));
    Ret:=0;
    Exit;
   End;
  If Ch=#0 Then
   Begin
    Ch:=ReadKey;
    If Ch='D' Then
     Begin
      If CCExitFound Then CCEditAttr;
      If RAExitFound Then RAEditAttr;
(* ************************** temporarily removed **************************
      If QKExitFound Then QKEditAttr;
 ************************** temporarily removed ************************** *)
     End;
    If Ch=#15 Then
     Begin
      Ret:=-1; WhatInt:=LIntVal(WhatStr); If WhatInt=-1 Then WhatInt:=Default;
      If Not Modified Then Modified:=(Default<>WhatInt);
      GotoXY(X,WhereY);
      Write(FPad(StrVal(WhatInt),Length(StrVal(Maximum)))); Exit;
     End;
   End;
 Until Ch=#13;
 WhatInt:=LIntVal(WhatStr); If WhatInt=-1 Then WhatInt:=Default;
 Ret:=+1;
 If Not Modified Then Modified:=(Default<>WhatInt);
 GotoXY(X,WhereY); Write(FPad(StrVal(WhatInt),Length(StrVal(Maximum))));
End;

Procedure EditUser;
Var
 Hil: Byte; Ret: ShortInt;
 L: LongInt;
 S: String[60];
 C: Char;
Begin
 If (Config^.BBSProg in [bbs_QK,bbs_EZ]) Then Exit;
 If Not (CCExitFound Or RAExitFound Or QKExitFound Or EZExitFound) Then Exit;
 SaveScreen(9);

  If CCExitFound Then
   Begin
    With CCExitInfo.UserInfo Do
     Begin
      Box(3,2,45,3);
      TextAttr:=$0F; GotoXY(05,03); Write('User Name: '); WP(Name,30);
      TextAttr:=$0F; GotoXY(05,04); Write('Alias    : '); WP(Alias,30);
      TextAttr:=$0F; GotoXY(05,05); Write('Location : '); WP(City,25);

      Box(3,9,45,4);
      TextAttr:=$0F; GotoXY(05,10); Write('Voice Ph#: '); WP(Voice,20);
      TextAttr:=$0F; GotoXY(05,11); Write('Data Ph# : '); WP(Data,20);
      TextAttr:=$0F; GotoXY(05,12); Write('Birthday : '); WP(GetDate(Birthday),8);
      TextAttr:=$0F; GotoXY(05,13); Write('Password : '); WP(MakeStr(Length(Password),'*'),15);

      Box(52,2,25,11);
      TextAttr:=$0F; GotoXY(54,03); Write('Security :      '); FWP(StrVal(Sec.SecLvl),5);
      TextAttr:=$0F; GotoXY(54,04); Write('U/L KB   : '); FWP(StrVal(UpK),10);
      TextAttr:=$0F; GotoXY(54,05); Write('D/L KB   : '); FWP(StrVal(DownK),10);
      TextAttr:=$0F; GotoXY(54,06); Write('U/L Times: '); FWP(StrVal(UpTimes),10);
      TextAttr:=$0F; GotoXY(54,07); Write('D/L Times: '); FWP(StrVal(DownTimes),10);
      TextAttr:=$0F; GotoXY(54,08); Write('Calls    : '); FWP(StrVal(TodayCalls),10);
      TextAttr:=$0F; GotoXY(54,09); Write(' À Today : '); FWP(StrVal(TimesCalled),10);
      TextAttr:=$0F; GotoXY(54,10); Write('Mins Used: '); FWP(StrVal(TotalMinutes),10);
      TextAttr:=$0F; GotoXY(54,11); Write('Time Left:      '); FWP(StrVal(CCExitInfo.TimeLeft),5);
      TextAttr:=$0F; GotoXY(54,12); Write('KB Left  : '); FWP(StrVal(CCExitInfo.LimitLeft),10);
      TextAttr:=$0F; GotoXY(54,13); Write('FilesLeft: '); FWP(StrVal(CCExitInfo.FilesLeft),10);
     End;
    With CCExitInfo Do
     Begin
      Box(3,17,75,3);

      TextAttr:=$0F; GotoXY(05,18); Write('# Pages  : '); FWP(StrVal(PageTimes),3);
      TextAttr:=$0F; GotoXY(05,19); Write(' À Reason: '); WP(PageReason,60);
      TextAttr:=$0F; GotoXY(05,20); Write('Comment  : '); WP(UserInfo.SysOpCmnt,60);
     End;
   End;

  If RAExitFound Then
   Begin
    With RAExitInfo.UserInfo Do
     Begin
      Box(3,2,45,3);
      TextAttr:=$0F; GotoXY(05,03); Write('User Name: '); WP(Name,30);
      TextAttr:=$0F; GotoXY(05,04); Write('Alias    : '); WP(Handle,30);
      TextAttr:=$0F; GotoXY(05,05); Write('Location : '); WP(Location,25);

      Box(3,9,45,4);
      TextAttr:=$0F; GotoXY(05,10); Write('Voice Ph#: '); WP(VoicePhone,15);
      TextAttr:=$0F; GotoXY(05,11); Write('Data Ph# : '); WP(DataPhone,15);
      TextAttr:=$0F; GotoXY(05,12); Write('Birthday : '); WP(BirthDate,8);
      TextAttr:=$08; GotoXY(05,13); Write('Password : ');

      Box(52,2,25,11);
      TextAttr:=$0F; GotoXY(54,03); Write('Security :      '); FWP(StrVal(Security),5);
      TextAttr:=$0F; GotoXY(54,04); Write('U/L KB   : '); FWP(StrVal(UploadsK),10);
      TextAttr:=$0F; GotoXY(54,05); Write('D/L KB   : '); FWP(StrVal(DownloadsK),10);
      TextAttr:=$0F; GotoXY(54,06); Write('U/L Times: '); FWP(StrVal(Uploads),10);
      TextAttr:=$0F; GotoXY(54,07); Write('D/L Times: '); FWP(StrVal(Downloads),10);
      TextAttr:=$0F; GotoXY(54,08); Write('Calls    : '); FWP(StrVal(NoCalls),10);
      TextAttr:=$08; GotoXY(54,09); Write(' À Today : ');
      TextAttr:=$0F; GotoXY(54,10); Write('Mins Used:      '); FWP(StrVal(Elapsed),5);
      TextAttr:=$0F; GotoXY(54,11); Write('Time Left:      '); FWP(StrVal(RAExitInfo.TimeLimit),5);
      TextAttr:=$0F; GotoXY(54,12); Write('KB Left  :      '); FWP(StrVal(RAExitInfo.DownloadLimit),5);
      TextAttr:=$08; GotoXY(54,13); Write('FilesLeft: ');
     End;
    With RAExitInfo Do
     Begin
      Box(3,17,75,3);

      TextAttr:=$0F; GotoXY(05,18); Write('# Pages  : '); FWP(StrVal(NumberPages),3);
      TextAttr:=$0F; GotoXY(05,19); Write(' À Reason: '); WP(PageReason,60);
      TextAttr:=$0F; GotoXY(05,20); Write('Comment  : '); WP(RAExitInfo.UserInfo.Comment,60);
     End;
   End;

(* ************************** temporarily removed **************************
  If QKExitFound Then
   Begin
    With QKExitInfo.UserInfo Do
     Begin
      Box(3,2,45,3);
      TextAttr:=$0F; GotoXY(05,03); Write('User Name: '); WP(Name,30);
      TextAttr:=$08; GotoXY(05,04); Write('Alias    : ');
      TextAttr:=$0F; GotoXY(05,05); Write('Location : '); WP(City,25);

      Box(3,9,45,4);
      TextAttr:=$0F; GotoXY(05,10); Write('Voice Ph#: '); WP(HomePhone,15);
      TextAttr:=$0F; GotoXY(05,11); Write('Data Ph# : '); WP(DataPhone,15);
      TextAttr:=$08; GotoXY(05,12); Write('Birthday : ');{ Gregorian(BirthDay,S); WP(S,8);}
      TextAttr:=$08; GotoXY(05,13); Write('Password : ');

      Box(52,2,25,11);
      TextAttr:=$0F; GotoXY(54,03); Write('Security :      '); FWP(StrVal(SecLvl),5);
      TextAttr:=$0F; GotoXY(54,04); Write('U/L KB   :      '); FWP(StrVal(UpK),5);
      TextAttr:=$0F; GotoXY(54,05); Write('D/L KB   :      '); FWP(StrVal(DownK),5);
      TextAttr:=$0F; GotoXY(54,06); Write('U/L Times:      '); FWP(StrVal(Ups),5);
      TextAttr:=$0F; GotoXY(54,07); Write('D/L Times:      '); FWP(StrVal(Downs),5);
      TextAttr:=$0F; GotoXY(54,08); Write('Calls    :      '); FWP(StrVal(Times),5);
      TextAttr:=$08; GotoXY(54,09); Write(' À Today : ');
      TextAttr:=$0F; GotoXY(54,10); Write('Mins Used:      '); FWP(StrVal(Elapsed),5);
      TextAttr:=$0F; GotoXY(54,11); Write('Time Left:      '); FWP(StrVal(QKExitInfo.TmLimit),5);
      TextAttr:=$0F; GotoXY(54,12); Write('KB Left  :      '); FWP(StrVal(QKExitInfo.DownLimit),5);
      TextAttr:=$08; GotoXY(54,13); Write('FilesLeft: ');
     End;
    With QKExitInfo Do
     Begin
      Box(3,17,75,3);

      TextAttr:=$0F; GotoXY(05,18); Write('# Pages  : '); FWP(StrVal(PageTimes),3);
      TextAttr:=$0F; GotoXY(05,19); Write(' À Reason: '); WP(ChatReason,60);
      TextAttr:=$08; GotoXY(05,20); Write('Comment  : ');
     End;
   End;
 ************************** temporarily removed ************************** *)


 GotoXY(38,21);
 TextAttr:=$01; Write(' [');
 TextAttr:=$09; Write('Tab');
 TextAttr:=$01; Write('/');
 TextAttr:=$09; Write('Sh+Tab');
 TextAttr:=$01; Write('] ');
 TextAttr:=$0F; Write('Move ');

 GotoXY(58,21);
 TextAttr:=$01; Write(' [');
 TextAttr:=$09; Write('F10');
 TextAttr:=$01; Write('] ');
 TextAttr:=$0F; Write('Attributes ');

 Hil:=1;
 Repeat
  TextAttr:=$1F;
  If Modified Then Begin CursorOff; TextAttr:=$01; GotoXY(5,21); Write('þ'); TextAttr:=$1F; CursorOn; End;
  If CCExitFound Then
   Begin
    With CCExitInfo Do
     Begin
      Case Hil Of
        01: Begin GotoXY(16,3);  Read_Str(UserInfo.Name,30,UserInfo.Name,Ret); End;
        02: Begin GotoXY(16,4);  Read_Str(UserInfo.Alias,30,UserInfo.Alias,Ret); End;
        03: Begin GotoXY(16,5);  Read_Str(UserInfo.City,25,UserInfo.City,Ret); End;
        04: Begin GotoXY(16,10); Read_Str(UserInfo.Voice,20,UserInfo.Voice,Ret); End;
        05: Begin GotoXY(16,11); Read_Str(UserInfo.Data,20,UserInfo.Data,Ret); End;
        06: Begin GotoXY(16,12); Read_Str(S,8,GetDate(UserInfo.Birthday),Ret); End;
        07: Begin GotoXY(16,13); Read_Str(UserInfo.Password,15,UserInfo.Password,Ret);
                  GotoXY(16,13); Write(MakeStr(Length(UserInfo.Password),'*')); End;
        08: Begin GotoXY(16,18); L:=PageTimes; Read_Int(L,255,L,Ret); PageTimes:=L; End;
        09: Begin GotoXY(16,19); Read_Str(PageReason,60,PageReason,Ret); End;
        10: Begin GotoXY(16,20); Read_Str(UserInfo.SysopCmnt,60,UserInfo.SysopCmnt,Ret); End;

        11: Begin GotoXY(70,03); L:=UserInfo.Sec.SecLvl; Read_Int(L,65535,L,Ret); UserInfo.Sec.SecLvl:=L; End;
        12: Begin GotoXY(65,04); Read_Int(UserInfo.UpK,2147483647,UserInfo.UpK,Ret); End;
        13: Begin GotoXY(65,05); Read_Int(UserInfo.DownK,2147483647,UserInfo.DownK,Ret); End;
        14: Begin GotoXY(65,06); Read_Int(UserInfo.UpTimes,2147483647,UserInfo.UpTimes,Ret); End;
        15: Begin GotoXY(65,07); Read_Int(UserInfo.DownTimes,2147483647,UserInfo.DownTimes,Ret); End;
        16: Begin GotoXY(72,08); L:=UserInfo.TodayCalls; Read_Int(L,255,L,Ret); UserInfo.TodayCalls:=L; End;
        17: Begin GotoXY(65,09); Read_Int(UserInfo.TimesCalled,2147483647,UserInfo.TimesCalled,Ret); End;
        18: Begin GotoXY(65,10); Read_Int(UserInfo.TotalMinutes,2147483647,UserInfo.TotalMinutes,Ret); End;
        19: Begin GotoXY(70,11); L:=CCExitInfo.TimeLeft; Read_Int(L,32767,L,Ret); L:=CCExitInfo.TimeLeft; End;
        20: Begin GotoXY(65,12); Read_Int(CCExitInfo.LimitLeft,2147483647,CCExitInfo.LimitLeft,Ret); End;
        21: Begin GotoXY(65,13); Read_Int(CCExitInfo.FilesLeft,2147483647,CCExitInfo.FilesLeft,Ret); End;
       End;
     End;
   End;

  If RAExitFound Then
   Begin
    With RAExitInfo Do
     Begin
      Case Hil Of
        01: Begin GotoXY(16,3);  Read_Str(UserInfo.Name,30,UserInfo.Name,Ret); End;
        02: Begin GotoXY(16,4);  Read_Str(UserInfo.Handle,30,UserInfo.Handle,Ret); End;
        03: Begin GotoXY(16,5);  Read_Str(UserInfo.Location,25,UserInfo.Location,Ret); End;
        04: Begin GotoXY(16,10); Read_Str(UserInfo.VoicePhone,15,UserInfo.VoicePhone,Ret); End;
        05: Begin GotoXY(16,11); Read_Str(UserInfo.DataPhone,15,UserInfo.DataPhone,Ret); End;
        06: Begin GotoXY(16,12); Read_Str(UserInfo.Birthdate,8,UserInfo.Birthdate,Ret); End;
        08: Begin GotoXY(16,18); L:=NumberPages; Read_Int(L,255,L,Ret); NumberPages:=L; End;
        09: Begin GotoXY(16,19); Read_Str(PageReason,60,PageReason,Ret); End;
        10: Begin GotoXY(16,20); Read_Str(UserInfo.Comment,60,UserInfo.Comment,Ret); End;
        11: Begin GotoXY(70,03); L:=UserInfo.Security; Read_Int(L,65535,L,Ret); UserInfo.Security:=L; End;
        12: Begin GotoXY(65,04); Read_Int(UserInfo.UploadsK,2147483647,UserInfo.UploadsK,Ret); End;
        13: Begin GotoXY(65,05); Read_Int(UserInfo.DownloadsK,2147483647,UserInfo.DownloadsK,Ret); End;
        14: Begin GotoXY(65,06); Read_Int(UserInfo.Uploads,2147483647,UserInfo.Uploads,Ret); End;
        15: Begin GotoXY(65,07); Read_Int(UserInfo.Downloads,2147483647,UserInfo.Downloads,Ret); End;
        17: Begin GotoXY(65,08); Read_Int(UserInfo.NoCalls,2147483647,UserInfo.NoCalls,Ret); End;
        18: Begin GotoXY(70,10); L:=UserInfo.Elapsed; Read_Int(L,32767,L,Ret); UserInfo.Elapsed:=L; End;
        19: Begin GotoXY(70,11); L:=TimeLimit; Read_Int(L,65535,L,Ret); L:=TimeLimit; End;
        20: Begin GotoXY(70,12); L:=DownloadLimit; Read_Int(L,65535,L,Ret); DownloadLimit:=L; End;
       End;
     End;
   End;

(* ************************** temporarily removed **************************
  If QKExitFound Then
   Begin
    With QKExitInfo Do
     Begin
      Case Hil Of
        01: Begin GotoXY(16,3);  Read_Str(UserInfo.Name,30,UserInfo.Name,Ret); End;
        03: Begin GotoXY(16,5);  Read_Str(UserInfo.City,25,UserInfo.City,Ret); End;
        04: Begin GotoXY(16,10); Read_Str(UserInfo.HomePhone,15,UserInfo.HomePhone,Ret); End;
        05: Begin GotoXY(16,11); Read_Str(UserInfo.DataPhone,15,UserInfo.DataPhone,Ret); End;
{        06: Begin GotoXY(16,12); Gregorian(UserInfo.BirthDay,S); Read_Str(S,8,S,Ret); UserInfo.Birthday:=Julian(S); End;}
        08: Begin GotoXY(16,18); L:=PageTimes; Read_Int(L,255,L,Ret); PageTimes:=L; End;
        09: Begin GotoXY(16,19); Read_Str(ChatReason,48,ChatReason,Ret); End;
        11: Begin GotoXY(70,03); L:=UserInfo.SecLvl; Read_Int(L,65535,L,Ret); UserInfo.SecLvl:=L; End;
        12: Begin GotoXY(70,04); L:=UserInfo.UpK; Read_Int(L,65535,L,Ret); UserInfo.UpK:=L; End;
        13: Begin GotoXY(70,05); L:=UserInfo.DownK; Read_Int(L,65535,L,Ret); UserInfo.DownK:=L; End;
        14: Begin GotoXY(70,06); L:=UserInfo.Ups; Read_Int(L,65535,L,Ret); UserInfo.Ups:=L; End;
        15: Begin GotoXY(70,07); L:=UserInfo.Downs; Read_Int(L,65535,L,Ret); UserInfo.Downs:=L; End;
        17: Begin GotoXY(70,08); L:=UserInfo.Times; Read_Int(L,65535,L,Ret); UserInfo.Times:=L; End;
        18: Begin GotoXY(70,10); L:=UserInfo.Elapsed; Read_Int(L,32767,L,Ret); UserInfo.Elapsed:=L; End;
        19: Begin GotoXY(70,11); L:=TmLimit; Read_Int(L,32767,L,Ret); L:=TmLimit; End;
        20: Begin GotoXY(70,12); L:=DownLimit; Read_Int(L,32767,L,Ret); DownLimit:=L; End;
       End;
     End;
   End;
 ************************** temporarily removed ************************** *)

  Hil:=Hil+Ret;
  If (RAExitFound) Then
   Begin
    If Hil=7 Then Hil:=Hil+Ret;
    If Hil=16 Then Hil:=Hil+Ret;
    If Hil=21 Then Hil:=Hil+Ret;
   End;
(* ************************** temporarily removed **************************
  If (QKExitFound) Then
   Begin
    If Hil=2 Then Hil:=Hil+Ret;
    If Hil=6 Then Hil:=Hil+Ret;
    If Hil=10 Then Hil:=Hil+Ret;
   End;
 ************************** temporarily removed ************************** *)
  If Hil=0 Then Hil:=21;
  If Hil>21 Then Hil:=1;

 Until Ret=0;

 If Modified Then
  Begin
   CursorOff;
   Box(28,9,23,3);
   GotoXY(30,11);
   TextAttr:=$0F; Write('Save Changes? '); TextAttr:=$01; Write('(');
   TextAttr:=$09; Write('Y');               TextAttr:=$01; Write('/');
   TextAttr:=$09; Write('n');               TextAttr:=$01; Write(')');
   Repeat C:=Upcase(ReadKey); If C=#13 Then C:='Y'; Until C in ['Y','N'];
   CursorOn;
  End
  Else
  Begin
   C:='N';
  End;
 RestoreScreen(9);

 If CCExitFound Then
  Begin
   Assign(CCExitFile,SysPath+'EXITINFO.DAT');
   {$I-} Reset(CCExitFile); {$I-}
   If IOresult<>0 Then
    Begin
     Assign(CCExitFile,'EXITINFO.DAT');
     {$I-} Reset(CCExitFile); {$I-}
    End;
   If IOResult<>0 Then Exit;
   Reset(CCExitFile);
   If C='Y' Then
    Write(CCExitFile,CCExitInfo)
   Else
    Read(CCExitFile,CCExitInfo);
   Close(CCExitFile);
  End;

 If RAExitFound Then
  Begin
   Assign(RAExitFile,SysPath+'EXITINFO.BBS');
   {$I-} Reset(RAExitFile); {$I-}
   If IOresult<>0 Then
    Begin
     Assign(RAExitFile,'EXITINFO.BBS');
     {$I-} Reset(RAExitFile); {$I-}
    End;
   If IOResult<>0 Then Exit;
   Reset(RAExitFile);
   If C='Y' Then
    Write(RAExitFile,RAExitInfo)
   Else
    Read(RAExitFile,RAExitInfo);
   Close(RAExitFile);
  End;

(* ************************** temporarily removed **************************
 If QKExitFound Then
  Begin
   Assign(QKExitFile,SysPath+'EXITINFO.BBS');
   {$I-} Reset(QKExitFile); {$I-}
   If IOresult<>0 Then
    Begin
     Assign(QKExitFile,'EXITINFO.BBS');
     {$I-} Reset(QKExitFile); {$I-}
    End;
   If IOResult<>0 Then Exit;
   Reset(QKExitFile);
   If C='Y' Then
    Write(QKExitFile,QKExitInfo)
   Else
    Read(QKExitFile,QKExitInfo);
   Close(QKExitFile);
  End;
 ************************** temporarily removed ************************** *)
End;


End.
