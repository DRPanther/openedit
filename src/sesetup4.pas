Program SESetup;
{$I DEFINES.INC}
Uses
  Crt,
  Utilpack,
  DOS,
  SEdit_Reg,
  DESUnit,
  RCRC32,
  SES_Util;
{$DEFINE CompileColorCfg}
{$DEFINE CompileEditor}
{$UNDEF PreRelease}

{.I RA.200}
{$I RA_INC.PAS}
{$I CC_INC.PAS}
{$I QK_INC.PAS}

Const
  Key      : LongInt = $00000000;
  PWDCRC   : LongInt = 1234654356; { CONSUMER }
  ColorA17C: Array[1..14] Of Byte = ($0F,$0B,$01,$09,$09,$0F,$07,$09,$0B,$0B,$0B,$0F,$09,$01); { Cool }
  Color3998: Array[1..14] Of Byte = ($0F,$0E,$04,$0C,$04,$0F,$07,$0E,$0C,$0C,$0C,$0F,$0E,$04); { Hot  }
  ColorF639: Array[1..14] Of Byte = ($0F,$0E,$02,$0A,$0A,$0F,$07,$0E,$0A,$0A,$0A,$0F,$0E,$02); { Mint }
  Color4B64: Array[1..14] Of Byte = ($0F,$0E,$05,$0D,$0D,$0F,$07,$0E,$0C,$0D,$0D,$0F,$0E,$05); { Pink }
  ColorTemp: Array[1..14] Of Byte = ($00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00); { Nil  }

  YN: Array[False..True] Of String[3]=(' No','Yes');
  YNA: Array[0..2] Of String[3]=(' No','Yes','Ask');
  Menu: Array[1..5] Of String[15] = (
                                     'General Setup', '   Toggles   ',
                                     ' Color Setup ', 'Tags/SpellChk',
                                     ' Extra Setup '
                                    );
Var
  Restart: Boolean;
  DecryptKey: String;
  C: Char;
  Hil: Byte;
  DoneBeta: Boolean;

Label LoadUp;

Procedure MainMenu(Displacement: ShortInt);
Begin
  Box(31+Displacement,13,19,7);
  TextAttr:=$07;
  GotoXY(34+Displacement,15); Write(Menu[1]);
  GotoXY(34+Displacement,16); Write(Menu[2]);
  GotoXY(34+Displacement,17); Write(Menu[3]);
  GotoXY(34+Displacement,18); Write(Menu[4]);
  GotoXY(34+Displacement,19); Write(Menu[5]);
End;

Procedure SwapSetup;
Const
  Order: Array[False..True] Of String[12] = ('EMS/XMS/Disk','XMS/EMS/Disk');
Var
  C: Char;
  Hil: Byte;
Begin
  Config.DOSSwap:=Config.DOSSwap And Not HIDE_FILE;
  SaveScreen(5);
  Box(25,9,30,6);
  Hil:=1;
  Repeat
    If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    GotoXY(27,11);
    Write(' Use EMS              '+YN[Config.DOSSwap And USE_EMS <> 0],' ');
    If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    GotoXY(27,12);
    Write(' Use XMS              '+YN[Config.DOSSwap And USE_XMS <> 0],' ');
    If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    GotoXY(27,13); Write(' Use Disk             '+YN[Config.DOSSwap And USE_FILE <> 0],' ');
    If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    GotoXY(27,14); Write(' Swap Order  '+Order[Config.DOSSwap And XMS_FIRST <> 0],' ');
    Help(1,Hil);
    C:=UpCase(ReadKey('SWAPSETUP'));
    Case C Of
      #00: Case Crt.ReadKey Of
           'P': Begin Inc(Hil); If Hil=5 Then Hil:=4; End;
           'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
           End;
      #13: Case Hil Of
           1: Config.DOSSwap:=Config.DOSSwap Xor USE_EMS;
           2: Config.DOSSwap:=Config.DOSSwap Xor USE_XMS;
           3: Config.DOSSwap:=Config.DOSSwap Xor USE_FILE;
           4: Config.DOSSwap:=Config.DOSSwap Xor XMS_FIRST;
           End;
   End;
  Until C=#27;
  RestoreScreen(5);
  If Config.DOSSwap And USE_FILE<>0 Then
  Config.DOSSwap:=Config.DOSSwap Or HIDE_FILE;
End;

Procedure Quoting;
Const
  QK: Array[False..True] Of String[5] = ('Ctl+Q','Ctl+W');
  LQ     : Array[False..True] Of String[32] =
          ('Inform user he is over the limit',
           'Force user to remove quoted text');
Var
  C: Char;
  Hil: Byte;
  IV: LongInt;
  S: String;
  R: Real;
  W: Word;
Begin
  SaveScreen(5);
  Box(10,9,60,7);
  Hil:=1;
  Repeat
    GotoXY(12,11);
    If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Max Quoted Text %   '+LeadingZero(Trunc(Int(Config.MaxQuotePct)))+'.'+
    StrVal(Trunc(Frac(Config.MaxQuotePct)*10))+'%',56));
    GotoXY(12,12); If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Quote % Handling    '+LQ[Config.ForceLessQuote],56));
    GotoXY(12,13); If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Quote Window Hotkey '+QK[Config.ForceCtlW],56));
    GotoXY(12,14); If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Quote Window Size   '+StrVal(Config.QuoteWinSize),56));
    GotoXY(12,15); If Hil=5 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Reply Header Text   '+Config.RepStr,56));
    Help(2,Hil);
    C:=UpCase(ReadKey('QUOTING'));
    Case C Of
      #00: Case Crt.ReadKey Of
           'P': Begin Inc(Hil); If Hil=6 Then Hil:=5; End;
           'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
           End;
    #13: Case Hil Of
           1: Begin
                GotoXY(12,11); TextAttr:=$07; Write(Pad(' Max Quoted Text %   '+
                LeadingZero(Trunc(Int(Config.MaxQuotePct)))+'.'+
                StrVal(Trunc(Frac(Config.MaxQuotePct)*10))+'%  (0.0 to disable)',56));
                S:=LeadingZero(Trunc(Int(Config.MaxQuotePct)))+'.'+
                StrVal(Trunc(Frac(Config.MaxQuotePct)*10));
                GotoXY(33,11);
                CursorOn;
                TextAttr:=LightBarColor;
                Read_Str(S,4,S);
                CursorOff;
                Val(S,R,W);
               If (W=0) And (R<=99.9) Then Config.MaxQuotePct:=R;
              End;
           2: Config.ForceLessQuote:=Not Config.ForceLessQuote;
           3: Config.ForceCtlW:=Not Config.ForceCtlW;
           4: Begin
                IV:=Config.QuoteWinSize;
                GotoXY(12,14); TextAttr:=$07; Write(Pad(' Quote Window Size   '+StrVal(Config.QuoteWinSize),56));
                TextAttr:=LightBarColor;
                GotoXY(33,14); CursorOn; Write('  '#8#8); Read_Int(IV,12,IV); CursorOff;
                Config.QuoteWinSize:=IV;
                GotoXY(12,14); TextAttr:=$07; Write(Pad(' Quote Window Size   '+StrVal(Config.QuoteWinSize),56));
               End;
           5: Begin
                GotoXY(12,15);
                TextAttr:=$07;
                Write(Pad(' Reply Header Text   '+Config.RepStr,56));
                TextAttr:=LightBarColor;
                GotoXY(33,15);
                CursorOn;
                Read_Str(Config.RepStr,15,Config.RepStr);
                CursorOff;
                GotoXY(12,15);
                TextAttr:=$07;
                Write(Pad(' Reply Header Text   '+Config.RepStr,56));
              End;
          End;
   End;
  Until C=#27;
  RestoreScreen(5);
End;

Procedure SecuritySetup;
Var
  C: Char;
  Hil: Byte;
  IV: LongInt;
  S: String;
  R: Real;
  W: Word;
Begin
  SaveScreen(5);
  Box(21,10,37,4);
  Hil:=1;
  Repeat
    GotoXY(23,12);
    If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Import Security          '+StrVal(Config.ImportSecurity),33));
    GotoXY(23,13);
    If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Export Security          '+StrVal(Config.ExportSecurity),33));
    Help(3,Hil);
    C:=UpCase(ReadKey('SECURITY'));
    GotoXY(23,12);
    TextAttr:=$07;
    Write(Pad(' Import Security          '+StrVal(Config.ImportSecurity),33));
    GotoXY(23,13); TextAttr:=$07;
    Write(Pad(' Export Security          '+StrVal(Config.ExportSecurity),33));
    Case C Of
    #00: Case Crt.ReadKey Of
           'P': Begin Inc(Hil); If Hil=3 Then Hil:=2; End;
           'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
         End;
    #13: Case Hil Of
           1: Begin
                TextAttr:=LightBarColor;
                GotoXY(49,12); Write('      '#8#8#8#8#8#8);
                CursorOn; Read_Int(Config.ImportSecurity,999999,Config.ImportSecurity); CursorOff;
              End;
           2: Begin
                TextAttr:=LightBarColor;
                GotoXY(49,13); Write('      '#8#8#8#8#8#8);
                CursorOn; Read_Int(Config.ExportSecurity,999999,Config.ExportSecurity); CursorOff;
              End;
          End;
   End;
  Until C=#27;
  RestoreScreen(5);
End;

Function MaxPad(St: String; I: Integer): String;
Var
  C: Integer;
Begin
  If I>Length(St) Then
  For C:=1 To I-Length(St) Do St:=St+' '
  Else
  Begin
    St[0]:=Chr(I);
    St[I]:='¯';
  End;
  MaxPad:=St;
End;

Function AltMenu(Mac: Byte; Var Cmd: Byte): Boolean;
Var
  Hil: Byte;
  C: Char;
Begin
  GotoXY(2,1); TextAttr:=$0F; ClrEol;
  Write(' What do you want Alt+F',Mac,' to do?');
  Box(23,10,37,5);
  TextAttr:=$07;
  Hil:=Cmd+1;
  Repeat
    If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07; GotoXY(25,12); Write(' Run an External Program         ');
    If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07; GotoXY(25,13); Write(' Insert Text String Into Message ');
    If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07; GotoXY(25,14); Write(' Import Text File Into Message   ');
    C:=ReadKey('ALTKEYSDO');
    Case C Of
    #00: Case Crt.ReadKey Of
           'P': Begin Inc(Hil); If Hil=4 Then Hil:=3; End;
           'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
         End;
    #13: Cmd:=Hil-1;
   End;
  Until (C=#13) Or (C=#27);
  If C=#27 Then AltMenu:=False Else AltMenu:=True;
End;

Procedure AltFKeyMacros;
Var
  SOfs: Byte;
  Hil: Byte;
  C: Char;
Begin
  SaveScreen(5);
  Box(3,6,73,12);
  TextAttr:=$07;
  For Hil:=1 To 10 Do
  Begin
    If Config.AltF1To10[Hil].CmdData='' Then Config.AltF1To10[Hil].CmdType:=1;
    TextAttr:=$07; GotoXY(5,7+Hil);
    Write(' Alt+F',Pad(StrVal(Hil),2),' ');
    Case Config.AltF1To10[Hil].CmdType Of
      0: XWrite('^\09[^\0FE^\07xec^\09] ');
      1: XWrite('^\09[^\0FT^\07ext^\09] ');
      2: XWrite('^\09[^\0FF^\07ile^\09] ');
    End; TextAttr:=$07;
    Write(MaxPad(Config.AltF1To10[Hil].CmdData,52)+' ');
   End;
  Hil:=1;
  Repeat
    GotoXY(2,1); TextAttr:=$0F; ClrEol;
    Write(' What to do when Alt+F',Hil,' is pressed.');
    TextAttr:=LightBarColor; GotoXY(5,7+Hil);
    Write(' Alt+F',Pad(StrVal(Hil),2),' ');
    Case Config.AltF1To10[Hil].CmdType Of
      0: XWrite('^\'+LBCS+'9[^\'+LBCS+'FE^\'+LBCS+'7xec^\'+LBCS+'9] ');
      1: XWrite('^\'+LBCS+'9[^\'+LBCS+'FT^\'+LBCS+'7ext^\'+LBCS+'9] ');
      2: XWrite('^\'+LBCS+'9[^\'+LBCS+'FF^\'+LBCS+'7ile^\'+LBCS+'9] ');
    End; TextAttr:=LightBarColor;
   Write(MaxPad(Config.AltF1To10[Hil].CmdData,52)+' ');
   C:=UpCase(ReadKey('ALTKEYS'));
   TextAttr:=$07; GotoXY(5,7+Hil);
   Write(' Alt+F',Pad(StrVal(Hil),2),' ');
   Case Config.AltF1To10[Hil].CmdType Of
     0: XWrite('^\09[^\0FE^\07xec^\09] ');
     1: XWrite('^\09[^\0FT^\07ext^\09] ');
     2: XWrite('^\09[^\0FF^\07ile^\09] ');
   End; TextAttr:=$07;
  Write(MaxPad(Config.AltF1To10[Hil].CmdData,52)+' ');
  Case C Of
    #00: Case Crt.ReadKey Of
           'P': Begin Inc(Hil); If Hil=11 Then Hil:=10; End;
           'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
         End;
    #13: Begin
           SaveScreen(6);
           If AltMenu(Hil,Config.AltF1To10[Hil].CmdType) Then
           Begin
             RestoreScreen(6);
             SaveScreen(6);
             TextAttr:=$0F; GotoXY(2,1); ClrEol;
             Case Config.AltF1To10[Hil].CmdType Of
               0,1: Begin
                      If Hil<=5 Then SOfs:=17 Else SOfs:=2;
                      If Config.AltF1To10[Hil].CmdType=0 Then
                    Begin
                      Write('Type the full path, filename, and parameters of the program to run');
                      Box(16,SOfs,48,6);
                    End
                    Else
                    Begin
                      Write('Type the text you would like inserted into the message when Alt+F'+StrVal(Hil)+' is pressed');
                      Box(16,SOfs,48,5);
                    End;
                  GotoXY(17,SOfs+2); TextAttr:=$0F; Write(' *P '); TextAttr:=$07; Write('Port  ');
                                 TextAttr:=$0F; Write(' *T '); TextAttr:=$07; Write('To FirstName ');
                                 TextAttr:=$0F; Write(' *F '); TextAttr:=$07; Write('From FirstName');
                  GotoXY(17,SOfs+3); TextAttr:=$0F; Write(' *B '); TextAttr:=$07; Write('Baud  ');
                                 TextAttr:=$0F; Write(' *O '); TextAttr:=$07; Write('To LastName  ');
                                 TextAttr:=$0F; Write(' *I '); TextAttr:=$07; Write('From LastName');
                  GotoXY(17,SOfs+4); TextAttr:=$0F; Write(' *N '); TextAttr:=$07; Write('Node# ');
                                 TextAttr:=$0F; Write(' *S '); TextAttr:=$07; Write('Subject      ');
                  If Config.AltF1To10[Hil].CmdType=0 Then
                   Begin
                    TextAttr:=$0F; Write(' *C '); TextAttr:=$07; Write('COMMAND.COM');
                    GotoXY(17,SOfs+5); TextAttr:=$0F; Write(' *X<filename> '); TextAttr:=$07; Write('Export Msg   ');
                    TextAttr:=$0F; Write(' *Y '); TextAttr:=$07; Write('Import Msg ');
                   End;
                  If Config.AltF1To10[Hil].CmdType=1 Then
                   Begin
                    TextAttr:=$0F; Write(' |  '); TextAttr:=$07; Write('Insert <CR>');
                   End;
                 End;
              2: Write('Type the full path and filename of the textfile to insert into the message');
             End;
            GotoXY(14,7+Hil); TextAttr:=LightBarColor;
            Read_Str(Config.AltF1To10[Hil].CmdData,59,Config.AltF1To10[Hil].CmdData); CursorOff;
           End;
          RestoreScreen(6);
          TextAttr:=$07; GotoXY(21,7+Hil); Write(MaxPad(Config.AltF1To10[Hil].CmdData,52)+' ');
         End;
   End;
 Until C=#27;
 RestoreScreen(5);
End;

Procedure RASetup;
Const
  SigType: Array[0..2] Of String[23] =
           ('None (disable tearline)',
            'Short (part of tagline)',
            'Long (on an extra line)');
  LowOK: Array[0..2] Of String[17] =
          ('No               ',
           'Yes              ',
           'Insert ^A Instead');
  DFmt: Array[0..2] Of String[9] =
          ('DD-Mmm-YY',
           'DD-MM-YY',
           'MM-DD-YY');
  TFmt: Array[0..1] Of String[7] =
          ('01:00pm',
           '13:00');

Var
  IV: LongInt;
  Hil: Byte;
  C: Char;
  R: Real;
  S: String;
  W: Word;
  Tmp,
  L: LongInt;
  EzyNow: Boolean;
Begin
  SaveScreen(4);
  Box(10,5,60,16);
  Hil:=1;
  Repeat
    TextAttr:=$07;
    GotoXY(12,07);
    If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    Write(Pad(' Open!EDIT Tearline  '+LTrim(SigType[Config.TearLine]),56));
    GotoXY(12,08);
    If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
    If Config.RA250 Then
      Write(Pad(' BBS Software        '+LTrim(BBSPrg[Config.BBSProg])+' [RA v2.50]',56))
    Else
      Write(Pad(' BBS Software        '+LTrim(BBSPrg[Config.BBSProg]),56));
      GotoXY(12,09); If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' BBS Path            '+Config.BBSPath,56));
      GotoXY(12,10);
      If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Registration UEC    '+StrVal(Config.DataUEC),56));
      GotoXY(12,11); If Hil=5 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Registration Name   '+Config.RegName,56));
      GotoXY(12,12); If Hil=6 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Max Message Lines   '+StrVal(Config.AbsMaxMsgLines),56));
      GotoXY(12,13); If Hil=7 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Screen Scroll Lines '+StrVal(Config.ScrollSiz),56));
      GotoXY(12,14); If Hil=8 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Inactivity Timeout  '+StrVal(Config.TimeOutDelay),56));
      GotoXY(12,15); If Hil=9 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Low ASCII OK? (^])  '+LowOK[Config.ExtendedChars],56));
      GotoXY(12,16); If Hil=10 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Date/Time Format    '+DFmt[Config.DateFormat]+' '+TFmt[Config.TimeFormat],56));
      GotoXY(12,17); If Hil=11 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' AutoSave?           '+LTrim(YN[Config.AutoSave]),56));
      GotoXY(12,18); If Hil=12 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' Language File       '+Pad(Config.LanguageFile,8)+'.LNG',56));
      GotoXY(12,19); If Hil=13 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' HighBit Signatures? '+LTrim(YN[Config.OKSigHiBit]),56));
      GotoXY(12,20); If Hil=14 Then TextAttr:=LightBarColor Else TextAttr:=$07;
      Write(Pad(' WordWrap Margin     '+LTrim(StrVal(Config.WrapMargin)),56));

   If Hil<=10 Then
    Help(4,Hil)
   Else
   Help(1,5+Hil-11);
   C:=UpCase(ReadKey('MISCSETUP'));
   Case C Of
     #0: Case Crt.ReadKey Of
         'P': Begin Inc(Hil); If Hil=15 Then Hil:=14; End;
         'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
         End;
    #13: Case Hil Of
           1: Begin
                Inc(Config.TearLine);
                If Config.TearLine=3 Then Config.TearLine:=0;
              End;
           2: Begin
                Inc(Config.BBSProg);
                If Config.BBSProg=4 Then Config.BBSProg:=0;
                GotoXY(12,08); TextAttr:=LightBarColor;
                Write(Pad(' BBS Software        '+LTrim(BBSPrg[Config.BBSProg]),56));
                Config.RA250:=False;
                If Config.BBSProg=bbs_RA Then
                Begin
                  SaveScreen(5);
                  Box(26,13,33,3);
                  TextAttr:=$07;
                  GotoXY(28,15); XWrite('^\07Are you using RA v2.50? ^\01(^\0FY^\01/^\0Fn^\01)');
                  Help(0,6);
                  Repeat C:=UpCase(ReadKey('RA250')); Until C in ['Y','N'];
                  RestoreScreen(5);
                  Config.RA250:=(C='Y');
                  If Config.RA250 Then
                  Begin
                    GotoXY(12,08); TextAttr:=LightBarColor;
                    Write(Pad(' BBS Software        '+LTrim(BBSPrg[Config.BBSProg])+' [RA v2.50]',56))
                  End;
                End;
              End;
           3: Begin
                GotoXY(12,09); TextAttr:=$07; Write(Pad(' BBS Path            '+Config.BBSPath,56));
                GotoXY(33,09); CursorOn; TextAttr:=LightBarColor;
                Read_Str(Config.BBSPath,34,Config.BBSPath); CursorOff;
              End;
           5: Begin
                GotoXY(12,11); TextAttr:=$07; Write(Pad(' Registration Name   '+Config.RegName,56));
                GotoXY(33,11); TextAttr:=LightBarColor;
                Read_Str(Config.RegName,34,Config.RegName); CursorOff;
              End;
            6: Begin
                GotoXY(12,12); TextAttr:=$07; Write(Pad(' Max Message Lines   '+StrVal(Config.AbsMaxMsgLines),56));
                GotoXY(33,12); CursorOn; Read_Int(Config.AbsMaxMsgLines,4000,Config.AbsMaxMsgLines); CursorOff;
                GotoXY(12,12); TextAttr:=$07; Write(Pad(' Max Message Lines   '+StrVal(Config.AbsMaxMsgLines),56));
               End;
            7: Begin
                L:=Config.ScrollSiz;
                GotoXY(12,13); TextAttr:=$07; Write(Pad(' Screen Scroll Lines '+StrVal(Config.ScrollSiz),56));
                GotoXY(33,13); CursorOn; Read_Int(L,14,L); CursorOff;
                Config.ScrollSiz:=L;
                GotoXY(12,13); TextAttr:=$07; Write(Pad(' Screen Scroll Lines '+StrVal(Config.ScrollSiz),56));
               End;
            8: Begin
                L:=Config.TimeOutDelay;
                GotoXY(12,14); TextAttr:=$07; Write(Pad(' Inactivity Timeout  '+Pad(StrVal(Config.TimeoutDelay),4)+
                                                    ' (in seconds, 0 to disable)',56));
                GotoXY(33,14); CursorOn; Read_Int(L,1800,L); CursorOff;
                Config.TimeOutDelay:=L;
                GotoXY(12,14); TextAttr:=$07; Write(Pad(' Screen Scroll Lines '+StrVal(Config.TimeoutDelay),56));
               End;
            9: Begin
                Inc(Config.ExtendedChars); If Config.ExtendedChars>2 Then Config.ExtendedChars:=0;
               End;
            10: Begin
                 Inc(Config.TimeFormat);
                 If Config.TimeFormat=2 Then Begin Inc(Config.DateFormat); Config.TimeFormat:=0; End;
                 If Config.DateFormat=3 Then Config.DateFormat:=0;
                End;
            11: Config.AutoSave:=Not Config.AutoSave;
            12: Begin
                 GotoXY(12,18);
                 TextAttr:=$07; Write(Pad(' Language File       '+Pad(Config.LanguageFile,8)+'.LNG',56));
                 GotoXY(33,18); CursorOn; TextAttr:=LightBarColor;
                 Read_Str(Config.LanguageFile,8,Config.LanguageFile); CursorOff;
                 Config.LanguageFile:=UCase(Config.LanguageFile);
                 For Tmp:=1 To Length(Config.LanguageFile) Do
                  If Not (Config.LanguageFile[Tmp] in ['A'..'Z','!'..')','0'..'9','}','{','['..'`']) Then
                   Config.LanguageFile[Tmp]:=#0;
                 While Pos(#0,Config.LanguageFile)>0 Do Delete(Config.LanguageFile,Pos(#0,Config.LanguageFile),1);
                End;
            13: Config.OKSigHiBit:=Not Config.OKSigHiBit;
            14: Begin
                 L:=Config.WrapMargin;
                 GotoXY(12,20); TextAttr:=$07; Write(Pad(' WordWrap Margin     '+LTrim(StrVal(Config.WrapMargin)),56));
                 GotoXY(33,20); CursorOn; Read_Int(L,78,L); CursorOff;
                 If L<40 Then L:=Config.WrapMargin; Config.WrapMargin:=L;
                 GotoXY(12,20); TextAttr:=$07; Write(Pad(' WordWrap Margin     '+LTrim(StrVal(Config.WrapMargin)),56));
                End;
          End;
   End;
 Until (C=#27) Or (Restart);
 RestoreScreen(4);
End;

Procedure LocalSetup;
Const
 Menu: Array[1..5] Of String[20] = (
                                    'BBS Name         ',
                                    'User Name        ',
                                    'User Location    ',
                                    'Security Level   ',
                                    'Time Limit       '
                                                       );
Var
 Update: Boolean;
 Hil: Byte;
 St: String;
 C: Char;
 NewF,
 F: Text;
 LocalDef: Record
             BBSName,
             UserName,
             UserLocation: String[35];
             SecLvl: LongInt;
             TimeLeft: LongInt;
            End;
Begin
 With LocalDef Do
  Begin
   BBSName     := 'Noname BBS';
   UserName    := 'Joe User';
   UserLocation:= 'Anytown, Canada';
   SecLvl      := 100;
   TimeLeft    := 60;
  End;
 Assign(F,'LOCAL.DEF');
 {$I-} Reset(F); {$I+}
 If IOResult=0 Then
  Begin
   ReadLn(F,LocalDef.BBSName);
   ReadLn(F,St);
   ReadLn(F,LocalDef.UserName);
   ReadLn(F,LocalDef.UserLocation);
   ReadLn(F,St); LocalDef.SecLvl:=IntVal(St); If LocalDef.SecLvl=-1 Then LocalDef.SecLvl:=100;
   ReadLn(F,St);
   ReadLn(F,St); LocalDef.TimeLeft:=IntVal(St); If LocalDef.TimeLeft=-1 Then LocalDef.TimeLeft:=100;
   Close(F);
  End;
 SaveScreen(4);
 Box(10,13,60,7);
 For Hil:=1 To 5 Do
  Begin
   TextAttr:=$07; GotoXY(12,14+Hil); Write(' '+Menu[Hil]+' ');
   Case Hil Of
     1: Write(LocalDef.BBSName);
     2: Write(LocalDef.UserName);
     3: Write(LocalDef.UserLocation);
     4: Write(LocalDef.SecLvl);
     5: Write(LocalDef.TimeLeft);
    End;
  End;

 Hil:=1;
 Repeat
  TextAttr:=LightBarColor; GotoXY(12,14+Hil); Write(' '+Menu[Hil]+' ');
  Case Hil Of
    1: Write(Pad(LocalDef.BBSName,37));
    2: Write(Pad(LocalDef.UserName,37));
    3: Write(Pad(LocalDef.UserLocation,37));
    4: Write(Pad(StrVal(LocalDef.SecLvl),37));
    5: Write(Pad(StrVal(LocalDef.TimeLeft),37));
   End;
  Help(5,Hil);
  C:=UpCase(ReadKey('LOCALSETUP'));
  TextAttr:=$07; GotoXY(12,14+Hil); Write(' '+Menu[Hil]+' ');
  Case Hil Of
    1: Write(Pad(LocalDef.BBSName,37));
    2: Write(Pad(LocalDef.UserName,37));
    3: Write(Pad(LocalDef.UserLocation,37));
    4: Write(Pad(StrVal(LocalDef.SecLvl),37));
    5: Write(Pad(StrVal(LocalDef.TimeLeft),37));
   End;
  GotoXY(31,14+Hil);
  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If Hil<>1 Then Dec(Hil);
           'P': If Hil<>5 Then Inc(Hil);
          End;
    #13: Begin
          Case Hil Of
            1: Begin CursorOn; Read_Str(LocalDef.BBSName,35,LocalDef.BBSName); CursorOff; End;
            2: Begin CursorOn; Read_Str(LocalDef.UserName,35,LocalDef.UserName); CursorOff; End;
            3: Begin CursorOn; Read_Str(LocalDef.UserLocation,35,LocalDef.UserLocation); CursorOff; End;
            4: Begin CursorOn; Read_Int(LocalDef.SecLvl,999999,LocalDef.SecLvl); CursorOff; End;
            5: Begin CursorOn; Read_Int(LocalDef.TimeLeft,9999,LocalDef.TimeLeft); CursorOff; End;
           End;
         End;
  End;
 Until C=#27;
 RestoreScreen(4);
 Assign(F,'LOCAL.DEF');
 {$I-} Reset(F); {$I+}
 If IOResult=0 Then Update:=True Else Update:=False;
 Assign(NewF,'LOCAL.DE$');
 ReWrite(NewF);
 WriteLn(NewF,LocalDef.BBSName);
 WriteLn(NewF,Config.RegName);
 WriteLn(NewF,LocalDef.UserName);
 WriteLn(NewF,LocalDef.UserLocation);
 WriteLn(NewF,LocalDef.SecLvl);
 WriteLn(NewF,'ON');
 WriteLn(NewF,LocalDef.TimeLeft);
 If Update Then
  Begin
   For Hil:=1 To 7 Do ReadLn(F,St);
   While Not Eof(F) Do
    Begin
     ReadLn(F,St);
     WriteLn(NewF,St);
    End;
   Close(F);
   Erase(F);
  End;
 Close(NewF);
 Rename(NewF,'LOCAL.DEF');
End;

Procedure GeneralSetup;
Const
 Menu: Array[1..6] Of String[21] = (
                                    'Miscellaneous Setups ',
                                    'Local Login Defaults ',
                                    'Reply Configuration  ',
                                    'Memory/Disk Swapping ',
                                    'Alt+Fx Key Macros    ',
                                    'Security Level Setups'
                                   );
Var
  Hil: Byte;
  C: Char;
Begin
  MainMenu(-27);
  Box(26,14,50,5);
  TextAttr:=$07; GotoXY(29,16); Write(Menu[1]);
  TextAttr:=$07; GotoXY(29,17); Write(Menu[2]);
  TextAttr:=$07; GotoXY(29,18); Write(Menu[3]);
  TextAttr:=$07; GotoXY(52,16); Write(Menu[4]);
  TextAttr:=$07; GotoXY(52,17); Write(Menu[5]);
  TextAttr:=$07; GotoXY(52,18); Write(Menu[6]);
  Hil:=1;
  Repeat
    TextAttr:=LightBarColor;
  If Hil<4 Then GotoXY(28,15+Hil) Else GotoXY(51,15+Hil-3); Write(' '+Menu[Hil]+' ');
  Help(6,Hil);
  C:=UpCase(ReadKey('GENERALSETUP'));
  TextAttr:=$07;
  If Hil<4 Then GotoXY(28,15+Hil) Else GotoXY(51,15+Hil-3); Write(' '+Menu[Hil]+' ');
  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If (Hil<>1) And (Hil<>4) Then Dec(Hil);
           'P': If (Hil<>6) And (Hil<>3) Then Inc(Hil);
           'M': If Hil+3<=6 Then Inc(Hil,3);
           'K': If Hil>3 Then Dec(Hil,3);
          End;
    #13: Begin
          Case Hil Of
            1: RASetup;
            2: LocalSetup;
            3: Quoting;
            4: SwapSetup;
            5: AltFKeyMacros;
            6: SecuritySetup;
           End;
         End;
   End;
 Until (C=#27) Or (Restart);
End;

Procedure SV(Var B: Byte; On: Byte; YesValue: Byte);
Begin
  If On=1 Then
  Begin
    If B And YesValue = 0 Then B:=B+YesValue;
  End
  Else
  Begin
    If B And YesValue <> 0 Then B:=B-YesValue;
  End;
End;

Procedure BooleanArea(_Seg,_Ofs: Word; YesValue: Byte; Hdr,FullHdr: String);
Var
  Hil,
  Tmp,
  Top: Integer;
  FilError: Boolean;
  BBSProg: Byte;
  C: Char;
  RAMFile: File Of MESSAGErecord250;
  M: MESSAGErecord250;
  RAGFile: File Of GROUPrecord;
  G: GROUPrecord;
  CCMFile: File Of MAreaRec;
  CCM: MAreaRec;
  QKMFile: File Of BoardRecord;
  QKM: BoardRecord;
  MGN: String[3];
  MG: LongInt;

Function xFileSizeMFile: LongInt;
Begin
  Case Config.BBSProg Of
    bbs_RA: xFileSizeMFile:=FileSize(RAMFile);
    bbs_CC: xFileSizeMFile:=FileSize(CCMFile);
    bbs_QK: xFileSizeMFile:=FileSize(QKMFile);
  End;
End;

Function xFilePosMFile: LongInt;
Begin
 Case Config.BBSProg Of
   bbs_RA: xFilePosMFile:=FilePos(RAMFile);
   bbs_CC: xFilePosMFile:=FilePos(CCMFile);
   bbs_QK: xFilePosMFile:=FilePos(QKMFile);
  End;
End;

Function xEofMFile: Boolean;
Begin
 Case Config.BBSProg Of
   bbs_RA: xEofMFile:=Eof(RAMFile);
   bbs_CC: xEofMFile:=Eof(CCMFile);
   bbs_QK: xEofMFile:=Eof(QKMFile);
  End;
End;

Procedure xSeekMFile(I: LongInt);
Begin
 Case Config.BBSProg Of
   bbs_RA: Seek(RAMFile,I);
   bbs_CC: Seek(CCMFile,I);
   bbs_QK: Seek(QKMFile,I);
  End;
End;

Procedure xReadMFile;
Begin
 Case Config.BBSProg Of
   bbs_RA: Read(RAMFile,M);
   bbs_CC: Read(CCMFile,CCM);
   bbs_QK: Read(QKMFile,QKM);
  End;
End;

Function AInfo(I: Integer; TrueAreaNo: Word): String;
Var S: String;
Begin
 If Config.RA250 Then
  S:=' '+Zero(TrueAreaNo,5)+'  '
 Else
  S:=' '+Zero(I,5)+'  ';
 If Config.BBSProg=bbs_XX Then
  S:=S+'[unknown area]    [unknown area]            '
 Else
 Begin
  If FilError Then
   Begin
    S:=S+'[Bad Path]        [Bad Path]                '
   End
   Else
   Begin
    If I<=xFileSizeMFile Then
     Begin
      xSeekMFile(I-1);
      xReadMFile;
      Case Config.BBSProg Of
        bbs_RA: If M.Name[0]>#25 Then M.Name[0]:=#25;
        bbs_CC: If CCM.Name[0]>#25 Then CCM.Name[0]:=#25;
        bbs_QK: If QKM.Name[0]>#25 Then QKM.Name[0]:=#25;
       End;
      If ((Config.BBSProg=bbs_RA) And (M.Group<>0)) Or
         ((Config.BBSProg=bbs_CC) And (CCM.Group<>'')) Or
         ((Config.BBSProg=bbs_QK) And (QKM.Group<>0)) Then
       Begin
        If Config.RA250 Then
         Begin
          Seek(RAGFile,0);
          While Not Eof(RAGFile) Do
           Begin
            Read(RAGFile,G);
            If M.Group=G.AreaNum Then Break;
            G.Name:='[RA Error]';
           End;
         End
         Else
         Begin
          Case Config.BBSProg Of
            bbs_RA: Begin
                     {$I-} Seek(RAGFile,M.Group-1); {$I+}
                     If IOResult=0 Then Read(RAGFile,G) Else G.Name:='[RA error]';
                     If G.Name[0]>#17 Then G.Name[0]:=#17;
                    End;
            bbs_CC: Begin
                    End;
            bbs_QK: Begin
                    End;
            bbs_EZ: Begin
                    End;
           End;
         End;
       End
       Else
        G.Name:='[no group]';
      Case Config.BBSProg Of
        bbs_RA: S:=S+Pad(G.Name,17)+' '+Pad(M.Name,25)+' ';
        bbs_CC: S:=S+Pad(CCM.Group,17)+' '+Pad(CCM.Name,25)+' ';
        bbs_QK: S:=S+Pad(StrVal(QKM.Group),17)+' '+Pad('Group#'+Strval(QKM.Group),25)+' ';
       End;
     End
     Else
     Begin
      S:=S+'[no area set]     [no area set]             '
     End;
   End;
 End;
 S:=S+YN[Mem[_Seg:_Ofs+I-1] And YesValue <> 0 ];
 AInfo:=S+' ';
End;

{check to see if this YesValue thing works}

Begin
 SaveScreen(4);
 BBSProg:=Config.BBSProg;
 FilError:=False;
 If Config.BBSProg<>bbs_XX Then
  Begin
   If Config.BBSPath[Length(Config.BBSPath)]<>'\' Then Config.BBSPath:=Config.BBSPath+'\';

   Case BBSProg Of
     bbs_RA: Begin
              Assign(RAMFile,Config.BBSPath+RA_Areafile);
              {$I-} Reset(RAMFile); {$I+} If IOResult<>0 Then FilError:=True;
              Assign(RAGFile,Config.BBSPath+RA_Groupfile);
              {$I-} Reset(RAGFile); {$I+} If IOResult<>0 Then FilError:=True;
             End;
     bbs_CC: Begin
              Assign(CCMFile,Config.BBSPath+CC_AreaFile);
              {$I-} Reset(CCMFile); {$I+} If IOResult<>0 Then FilError:=True;
             End;
     bbs_QK: Begin
              Assign(QKMFile,Config.BBSPath+QK_AreaFile);
              {$I-} Reset(QKMFile); {$I+} If IOResult<>0 Then FilError:=True;
             End;
    End

  End;
 Top:=1;

 If FilError Then
  Begin
   Box(20,10,40,4);
   TextAttr:=$07;
   Case Config.BBSProg Of
     bbs_RA: Begin
              GotoXY(22,12); Write('MESSAGES.RA and/or MGROUPS.RA could');
              GotoXY(22,13); Write('not be located in the BBS directory.');
             End;
     bbs_CC: Begin
              GotoXY(22,12); Write(' Concord datafile MAREAS.DAT could ');
              GotoXY(22,13); Write('not be located in the BBS directory.');
             End;
     bbs_QK: Begin
              GotoXY(22,12); Write(' QuickBBS datafile MSGCFG.DAT could ');
              GotoXY(22,13); Write('not be located in the BBS directory.');
             End;
     bbs_EZ: Begin
              GotoXY(22,12); Write(' EzyCom datafile MESSAGES.EZY could ');
              GotoXY(22,13); Write('not be located in the BBS directory.');
             End;
    End;
   ReadKey('RAFILENOTFOUND');
   RestoreScreen(4);
   Exit;
  End;

 Box(10,5,60,15);
 TextAttr:=$0F;
 GotoXY(13,6); Write('Area#  Group             AreaName               ',Hdr);
 TextAttr:=$01;
 GotoXY(12,7);  Write('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');

 GotoXY(12,18); Write('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$07; GotoXY(12,20); XWrite('^\07Global: ^\01[^\0FL^\01] ^\07Local  ^\01[^\0F'+
                                      'E^\01] ^\07Echomail  ^\01[^\0FN^\01] ^\07Netmail  ^\01[^\0FG^\01] ^\07Groups');
 Window(12,8,68,17); TextAttr:=$07;
 For Tmp:=Top To Top+10-1 Do
  Begin
   If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
   GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
  End;
 Hil:=1;
 Repeat
  TextAttr:=LightBarColor;
  GotoXY(1,Hil-Top+1);
  If Hil<=xFileSizeMFile Then Begin xSeekMFile(Hil-1); xReadMFile; End;
  Write(AInfo(Hil,M.AreaNum));
  Help(0,1);
  C:=UpCase(ReadKey('AREASELECT'));
  TextAttr:=$07;
  GotoXY(1,Hil-Top+1);
  Write(AInfo(Hil,M.AreaNum));
  Case C Of
{
L = Toggle Localmail
N = Toggle Netmail
E = Toggle Echomail
G = Toggle Group x
}
    'L': If Config.BBSProg<>bbs_XX Then
         Begin
          Window(1,1,80,25); SaveScreen(5); Box(19,8,42,4); TextAttr:=$07;
          GotoXY(20,10); Write(Pad('',20-(Length(FullHdr) Div 2))+FullHdr);
          GotoXY(20,11); XWrite(' All Local Areas: ^\01[^\09Y^\01]^\07es, ^\01[^\09N^\01]^\07o, ^\01[^\09C^\01]^\07ancel');
          Help(0,2);
          Repeat C:=UpCase(ReadKey('YNCAREA'));
          If C=#27 Then C:='C'; Until C in ['Y','N','C'];
          If C in ['Y','N'] Then
           Begin
            xSeekMFile(0);
            While Not xEofMFile Do
             Begin
              xReadMFile;
              Case Config.BBSProg Of
                bbs_RA: If M.Typ=Localmail Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_CC: If CCM.Typ=MAREATYPE_LOCAL Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_QK: If QKM.Typ=Standard Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
               End;
             End;
           End;
          RestoreScreen(5); Window(12,8,68,17); TextAttr:=$07;
          C:='N';
         End;
    'N': If Config.BBSProg<>bbs_XX Then
         Begin
          Window(1,1,80,25); SaveScreen(5); Box(18,8,44,4); TextAttr:=$07;
          GotoXY(20,10); Write(Pad('',20-(Length(FullHdr) Div 2))+FullHdr);
          GotoXY(20,11); XWrite('All Netmail Areas: ^\01[^\09Y^\01]^\07es, ^\01[^\09N^\01]^\07o, ^\01[^\09C^\01]^\07ancel');
          Help(0,3);
          Repeat C:=UpCase(ReadKey('YNCAREA'));
          If C=#27 Then C:='C'; Until C in ['Y','N','C'];
          If C in ['Y','N'] Then
           Begin
            xSeekMFile(0);
            While Not xEofMFile Do
             Begin
              xReadMFile;
              Case Config.BBSProg Of
                bbs_RA: If M.Typ=Netmail Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_CC: If CCM.Typ=MAREATYPE_NET Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_QK: If QKM.Typ=QKNetMail Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
               End;
             End;
           End;
          RestoreScreen(5); Window(12,8,68,17); TextAttr:=$07;
          C:='N';
         End;
    'E': If Config.BBSProg<>bbs_XX Then
         Begin
          Window(1,1,80,25); SaveScreen(5); Box(18,8,45,4); TextAttr:=$07;
          GotoXY(20,10); Write(Pad('',20-(Length(FullHdr) Div 2))+FullHdr);
          GotoXY(20,11); XWrite('All Echomail Areas: ^\01[^\09Y^\01]^\07es, ^\01[^\09N^\01]^\07o, ^\01[^\09C^\01]^\07ancel');
          Help(0,4);
          Repeat C:=UpCase(ReadKey('YNCAREA'));
          If C=#27 Then C:='C'; Until C in ['Y','N','C'];
          If C in ['Y','N'] Then
           Begin
            xSeekMFile(0);
            While Not xEofMFile Do
             Begin
              xReadMFile;
              Case Config.BBSProg Of
                bbs_RA: If M.Typ=Echomail Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_CC: If CCM.Typ=MAREATYPE_ECHO Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                bbs_QK: If QKM.Typ=QKEchomail Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
               End;
             End;
           End;
          RestoreScreen(5); Window(12,8,68,17); TextAttr:=$07;
          C:='E';
         End;
    'G': If Config.BBSProg<>bbs_XX Then
         Begin
          Window(1,1,80,25); SaveScreen(5); Box(18,8,45,3); TextAttr:=$07;
          GotoXY(20,10);
          If Config.BBSProg=bbs_CC Then
           Begin
            Write(' Enter group name to globally change: ');
            TextAttr:=LightBarColor;
            Write('   '#8#8#8);
            Read_Str(MGN,3,''); TextAttr:=$07;
           End
          Else
          If Config.BBSProg=bbs_EZ Then
           Begin
            Write(' Enter group letter to globally change: ');
            TextAttr:=LightBarColor;
            Write(' '#8);
            Read_Str(MGN,1,''); TextAttr:=$07;
           End
          Else
           Begin
            Write('Enter group number to globally change: ');
            TextAttr:=LightBarColor;
            Write('  '#8#8);
            Read_Int(MG,99,0); TextAttr:=$07;
           End;
          If ((Not (Config.BBSProg in [bbs_CC,bbs_EZ])) And (MG<>65535)) Or
             ((Config.BBSProg in [bbs_CC,bbs_EZ]) And (MGN<>'')) Then
           Begin
            Box(18,8,45,4); TextAttr:=$07;
            GotoXY(20,10); Write('                                       ');
            GotoXY(20,10); Write(Pad('',20-(Length(FullHdr) Div 2))+FullHdr);
            GotoXY(20,11);
            If Config.BBSProg in [bbs_CC,bbs_EZ] Then
              XWrite('    Group '+MGN+': ^\01[^\09Y^\01]^\07es, '+
                     '^\01[^\09N^\01]^\07o, ^\01[^\09C^\01]^\07ancel')
             Else
              XWrite('     Group '+LeadingZero(MG)+': ^\01[^\09Y^\01]^\07es, '+
                    '^\01[^\09N^\01]^\07o, ^\01[^\09C^\01]^\07ancel');
            Help(0,5);
            Repeat C:=UpCase(ReadKey('YNCAREA'));
            If C=#27 Then C:='C'; Until C in ['Y','N','C'];
            If C in ['Y','N'] Then
             Begin
              xSeekMFile(0);
              While Not xEofMFile Do
               Begin
                xReadMFile;
                Case Config.BBSProg Of
                  bbs_CC: If CCM.Group=MGN Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                  bbs_RA: If M.Group=MG Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                  bbs_QK: If QKM.Group=MG Then SV(Mem[_Seg:_Ofs+xFilePosMFile-1],BYTE(C='Y'),YesValue);
                 End;
               End;
             End;
           End;
          RestoreScreen(5); Window(12,8,68,17); TextAttr:=$07;
          C:='G';
         End;
    #32: SV(Mem[_Seg:_Ofs+Hil-1],BYTE(Not (Mem[_Seg:_Ofs+Hil-1] And Yesvalue<>0)),YesValue);
    #0: Case Crt.ReadKey Of
          'G': Begin
                Top:=1;
                Hil:=1;
                For Tmp:=Top To Top+10-1 Do
                 Begin
                  If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
                  GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
                 End;
               End;
          'O': Begin
                Top:=1024-9;
                Hil:=1024-9;
                For Tmp:=Top To Top+10-1 Do
                 Begin
                  If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
                  GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
                 End;
               End;
          'Q': If Top+10<1024-9 Then
                Begin
                 Inc(Top,10);
                 Inc(Hil,10);
                 For Tmp:=Top To Top+10-1 Do
                  Begin
                   If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
                   GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
                  End;
                End;
          'I': If Top-10>0 Then
                Begin
                 Dec(Top,10);
                 Dec(Hil,10);
                 For Tmp:=Top To Top+10-1 Do
                  Begin
                   If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
                   GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
                  End;
                End;
          'H': If Not ((Top=1) And (Hil=1)) Then
                Begin
                 Dec(Hil);
                 If Hil-Top+1=0 Then
                  Begin
                   Dec(Top); GotoXY(1,1); InsLine; GotoXY(1,1);
                   If Hil<=xFileSizeMFile Then Begin xSeekMFile(Hil-1); xReadMFile; End;
                   Write(AInfo(Hil,M.AreaNum));
                  End;
                End;
          'P': If (Hil<>1024) Then
                Begin
                 Inc(Hil);
                 If Hil-Top+1=11 Then
                  Begin
                   Inc(Top); GotoXY(1,1); DelLine; GotoXY(1,10);
                   If Hil<=xFileSizeMFile Then Begin xSeekMFile(Hil-1); xReadMFile; End;
                   Write(AInfo(Hil,M.AreaNum));
                  End;
                End;
         End;
   End;
  If C in ['L','N','E','G'] Then
   Begin
    TextAttr:=$07;
    For Tmp:=Top To Top+10-1 Do
     Begin
      If Tmp<=xFileSizeMFile Then Begin xSeekMFile(Tmp-1); xReadMFile; End;
      GotoXY(1,Tmp-Top+1); Write(AInfo(Tmp,M.AreaNum));
     End;
   End;
 Until (C in [#13,#27]);
 Window(1,1,80,25);
 If Not FilError Then
  Case Config.BBSProg Of
    bbs_RA: Begin
             Close(RAGFile);
             Close(RAMFile);
            End;
    bbs_CC: Close(CCMFile);
    bbs_QK: Close(QKMFile);
   End;
 RestoreScreen(4);
End;

Procedure Toggles;
Const
 Menu: Array[1..6] Of String[20] = (
                                    'Allow Taglines   ',
                                    'Phrase Expand    ',
                                    'User Signatures  ',
                                    'Tagline Keywords ',
                                    'Censor Messages  ',
                                    'High ASCII Filter'
                                   );

Var
 Hil: Byte;
 C: Char;
Begin
 MainMenu(-27);
 Box(26,14,50,5);

 Hil:=1;
 Repeat

  GotoXY(28,16); If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[1]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.UseTaglines]+' ') Else Write('     ');
  GotoXY(28,17); If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[2]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.UseExpand]+' ') Else Write('     ');
  GotoXY(28,18); If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[3]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.UseSigs]+' ') Else Write('     ');

  GotoXY(51,16); If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[4]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.UseKeywords]+' ') Else Write('     ');
  GotoXY(51,17); If Hil=5 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[5]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.Censor]+' ') Else Write('     ');
  GotoXY(51,18); If Hil=6 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[6]);
  If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
   Write(' '+YN[Config.UseFilter]+' ') Else Write('     ');

  Help(7,Hil);
  C:=UpCase(ReadKey('TOGGLES'));
  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If Not (Hil in [1,4]) Then Dec(Hil);
           'P': If Not (Hil in [3,6]) Then Inc(Hil);
           'M': If Hil+3<=6 Then Inc(Hil,3);
           'K': If Hil-3>0 Then Dec(Hil,3);
          End;
    #13: Begin
          If (UCase(DecryptKey)<>UCase(Config.RegName)) Or (Config.BBSProg=bbs_XX) Then
           Begin
            Case Hil Of
              1: Config.UseTaglines:=Not Config.UseTaglines;
              2: Config.UseExpand:=Not Config.UseExpand;
              3: Config.UseSigs:=Not Config.UseSigs;
              4: Config.UseKeywords:=Not Config.UseKeywords;
              5: Config.Censor:=Not Config.Censor;
              6: Config.UseFilter:=Not Config.UseFilter;
             End;
           End
           Else
           Begin
            Case Hil Of
              1: BooleanArea(Seg(Config.OKTagArea),Ofs(Config.OKTagArea),        1,'TagLns','Turn on Taglines for');
              2: BooleanArea(Seg(Config.OKExpandArea),Ofs(Config.OKExpandArea),  1,'Expand','Turn on Expansions for');
              3: BooleanArea(Seg(Config.OKSigArea),Ofs(Config.OKSigArea),        1,'  Sigs','Turn on Signatures for');
              4: BooleanArea(Seg(Config.OKKeywordArea),Ofs(Config.OKKeywordArea),1,'TagKwd','Turn on Tagline Keywords for');
              5: BooleanArea(Seg(Config.OKCensorArea),Ofs(Config.OKCensorArea),  1,'Censor','Turn on Censoring for');
              6: BooleanArea(Seg(Config.FilterArea),Ofs(Config.FilterArea),      1,'Filter','Turn on High ASCII Filter for');
             End;
           End;
         End;
   End;
 Until (C=#27) Or (Restart);
End;

Procedure Center(S: String; B: Byte);
Begin
 GotoXY(40-(Length(S) Div 2),B);
 Write(S);
End;

Procedure PhraseExpand(IsUser: Boolean; xSeg,xOfs: Word);
Var
 Tmp: Byte;
 C: Char;
 Hil: Byte;
 xTen: Byte;
 ExpWord: Array[0..9,1..2] Of String[25];
Label GetMKey;
Begin
 Move(Mem[xSeg:xOfs],ExpWord,SizeOf(ExpWord));
 If IsUser Then xTen:=10 Else xTen:=9;
 SaveScreen(5);
 Box(9,6,62,xTen+4);
 TextAttr:=$07;
 GotoXY(12,8); Write('   Original Typed Text        New Replacement Text');
 For Tmp:=0 To xTen-1 Do
  Begin
   GotoXY(11,10+Tmp); Write(' '+Strval(Tmp)+'. '+Pad(ExpWord[Tmp,1],27)+Pad(ExpWord[Tmp,2],25)+' ');
  End;
 Hil:=1;
 Repeat
  GotoXY(11,9+Hil); TextAttr:=LightBarColor;
  Write(' '+Strval(Hil-1)+'. '+Pad(ExpWord[Hil-1,1],27)+Pad(ExpWord[Hil-1,2],25)+' ');

  Help(0,8);
  C:=UpCase(ReadKey('PHRASEEXPAND'));

  GotoXY(11,9+Hil); TextAttr:=$07;
  Write(' '+Strval(Hil-1)+'. '+Pad(ExpWord[Hil-1,1],27)+Pad(ExpWord[Hil-1,2],25)+' ');

  GetMKey:
  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If (Hil<>1) Then Dec(Hil);
           'P': If (Hil<>xTen) Then Inc(Hil);
          End;
    #13: Begin
          C:=Chr(Hil+47); Goto GetMKey;
         End;
    '0'..'9': If IntVal(C)<=xTen-1 Then
               Begin
                Hil:=Ord(C)-47;
                Tmp:=Hil-1;
                CursorOn;
                TextAttr:=LightBarColor; GotoXY(15,10+Tmp); Read_Str(ExpWord[Tmp,1],25,ExpWord[Tmp,1]);
                ExpWord[Tmp,1]:=UCase(ExpWord[Tmp,1]);
                TextAttr:=$07; GotoXY(15,10+Tmp); Write(Pad(ExpWord[Tmp,1],25));
                TextAttr:=LightBarColor; GotoXY(15+27,10+Tmp); Read_Str(ExpWord[Tmp,2],25,ExpWord[Tmp,2]);
                TextAttr:=$07; GotoXY(15+27,10+Tmp); Write(Pad(ExpWord[Tmp,2],25));
                CursorOff;
               End;
   End;
 Until C=#27;
{   ExpandWord: Array[1..10,1..2] Of String[25];}
 RestoreScreen(5);
 Move(ExpWord,Mem[xSeg:xOfs],SizeOf(ExpWord));
End;

{$IFDEF CompileColorCfg}
Procedure ColorConfig;
Var C: Char;
    Hil: Byte;
    Label GetMKey;
Begin
 Hil:=1;
 MainMenu(-26);
 Box(27,13,48,7);
 TextAttr:=$07;
 Repeat
  If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(29,15); TextColor(15); Write(' A'); TextColor(7); Write('. Frame-1  ');
  If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(41,15); TextColor(15); Write(' B'); TextColor(7); Write('. Capital    ');
  If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(56,15); TextColor(15); Write(' C'); TextColor(7); Write('. Inp-Capital  ');
  If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(29,16); TextColor(15); Write(' D'); TextColor(7); Write('. Frame-2  ');
  If Hil=5 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(41,16); TextColor(15); Write(' E'); TextColor(7); Write('. Lowcase    ');
  If Hil=6 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(56,16); TextColor(15); Write(' F'); TextColor(7); Write('. Inp-Lowcase  ');
  If Hil=7 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(29,17); TextColor(15); Write(' G'); TextColor(7); Write('. Frame-3  ');
  If Hil=8 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(41,17); TextColor(15); Write(' H'); TextColor(7); Write('. Symbols    ');
  If Hil=9 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(56,17); TextColor(15); Write(' I'); TextColor(7); Write('. Inp-Symbols  ');

  If Hil=10 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(29,18); TextColor(15); Write(' J'); TextColor(7); Write('. Frame-4  ');
  If Hil=11 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(41,18); TextColor(15); Write(' K'); TextColor(7); Write('. Digits     ');
  If Hil=12 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(56,18); TextColor(15); Write(' L'); TextColor(7); Write('. Inp-Digits   ');

  If Hil=13 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(29,19); TextColor(15); Write(' M'); TextColor(7); Write('. Fade     ');
  If Hil=14 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(41,19); TextColor(15); Write(' N'); TextColor(7); Write('. InputField ');
  If Hil=15 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(56,19); TextColor(15); Write(' O'); TextColor(7); Write('. Reset Colors ');

  GotoXY(66,20);
  TextAttr:=Config.NC; Write('ÚÄ'); TextAttr:=Config.HC; Write('ÄÄ');
  TextAttr:=Config.PC; Write('ÄÄ'); TextAttr:=Config.BC; Write('ÄÄÄÄÄÄ¿');
  GotoXY(66,21); TextAttr:=Config.HC; Write('³'); TextAttr:=Config.FZ; Write('Û²±°  '); TextAttr:=Config.FC; Write('T');
                 TextAttr:=Config.FL; Write('ext'); TextAttr:=Config.BC; Write(' ³');
  GotoXY(66,22); TextAttr:=Config.PC; Write('³'); TextAttr:=Config.FZ; Write('²±°   '); TextAttr:=Config.FC; Write('T');
                 TextAttr:=Config.FL; Write('est'); TextAttr:=Config.BC; Write(' ³');
  GotoXY(66,23); TextAttr:=Config.BC; Write('³'); TextAttr:=Config.FZ; Write('±°  '); TextAttr:=Config.FC; Write('N');
                 TextAttr:=Config.FL; Write('orm'); TextAttr:=Config.FS; Write('/'); TextAttr:=Config.FD; Write('1');
                 TextAttr:=Config.PC; Write(' ³');
  GotoXY(66,24); TextAttr:=Config.BC; Write('³'); TextAttr:=Config.FZ; Write('°  ');
                 TextAttr:=Config.IC+($10*Config.FieldColor); Write('I'); TextAttr:=Config.IL+($10*Config.FieldColor);
                 Write('nput'); TextAttr:=Config.IS+($10*Config.FieldColor); Write('/');
                 TextAttr:=Config.ID+($10*Config.FieldColor); Write('1'); TextAttr:=Config.HC; Write(' ³');
  GotoXY(66,25); TextAttr:=Config.BC; Write('ÀÄÄÄÄÄÄ');
  TextAttr:=Config.PC; Write('ÄÄ'); TextAttr:=Config.HC; Write('ÄÄ'); TextAttr:=Config.NC; Write('ÄÙ');

  Help(0,10);
  C:=UpCase(ReadKey('SECOLOR'));
  GetMKey:
  Case C Of
    #13: Begin C:=Chr(Hil+64); Goto GetMKey; End;
    #00: Case Crt.ReadKey Of
           'P': If Hil+3<=15 Then Begin Inc(Hil,3); If Hil>15 Then Hil:=15; End;
           'H': If Hil-3>0 Then Dec(Hil,3);
           'M': If Not (Hil in [3,6,9,12]) And (Hil<>15) Then Inc(Hil);
           'K': If Not (Hil in [1,4,7,10,13]) And (Hil<>1) Then Dec(Hil);
          End;
    'P': DumpColors;
    'A': ChangeColor(Config.NC,False,15);
    'B': ChangeColor(Config.FC,False,15);
    'C': ChangeColor(Config.IC,False,15);
    'D': ChangeColor(Config.HC,False,15);
    'E': ChangeColor(Config.FL,False,15);
    'F': ChangeColor(Config.IL,False,15);
    'G': ChangeColor(Config.PC,False,15);
    'H': ChangeColor(Config.FS,False,15);
    'I': ChangeColor(Config.IS,False,15);
    'J': ChangeColor(Config.BC,False,15);
    'K': ChangeColor(Config.FD,False,15);
    'L': ChangeColor(Config.ID,False,15);
    'M': ChangeColor(Config.FZ,False,15);
    'N': ChangeColor(Config.FieldColor,False,7);
    'O': Begin
          SaveScreen(5);
          Box(33,11,18,7);
          TextAttr:=$07;
          GotoXY(35,13); XWrite('^\01[^\0F1^\01] ^\07Cool Blue ');
          GotoXY(35,14); XWrite('^\01[^\0F2^\01] ^\07Autumn    ');
          GotoXY(35,15); XWrite('^\01[^\0F3^\01] ^\07Mint      ');
          GotoXY(35,16); XWrite('^\01[^\0F4^\01] ^\07Pink      ');
          GotoXY(35,17); XWrite('^\01[^\0F0^\01] ^\07Cancel    ');
          Help(12,10);
          Repeat C:=UpCase(ReadKey('COLORSCHEME')); Until C in ['1','2','3','4','0'];
          RestoreScreen(5);
          Case C Of
            '1': Move(ColorA17C,ColorTemp,SizeOf(ColorTemp));
            '2': Move(Color3998,ColorTemp,SizeOf(ColorTemp));
            '3': Move(ColorF639,ColorTemp,SizeOf(ColorTemp));
            '4': Move(Color4B64,ColorTemp,SizeOf(ColorTemp));
           End;
          If C<>'0' Then
           Begin
            Config.NC:=ColorTemp[1];
            Config.HC:=ColorTemp[2];
            Config.BC:=ColorTemp[3];
            Config.PC:=ColorTemp[4];
            Config.FZ:=ColorTemp[5];
            Config.FC:=ColorTemp[6];
            Config.FL:=ColorTemp[7];
            Config.FS:=ColorTemp[8];
            Config.FD:=ColorTemp[9];
            Config.IC:=ColorTemp[10];
            Config.ID:=ColorTemp[11];
            Config.IL:=ColorTemp[12];
            Config.IS:=ColorTemp[13];
            Config.FieldColor:=ColorTemp[14];
           End;
         End;
   End;
 Until C=#27;
End;
{$ENDIF}

Procedure TaglineSetup;
Var C: Char;
    Hil: Byte;
    L: LongInt;
Label GetMKey;
Begin
 MainMenu(-27);
 Box(26,14,50,6);
 Hil:=1;
 Repeat
  GotoXY(1,1);
  TextAttr:=$0F; ClrEol;
  If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  TextColor(15); GotoXY(28,16); Write(' A'); TextColor(07);
  Write('. Tagline Datafile: '); Write(MaxPad(Config.TagFileName,23)+' ');

  If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  TextColor(15); GotoXY(28,17); Write(' B'); TextColor(07);
  Write('. # Tags On Screen: '+Pad(StrVal(Config.NumTaglines),24));

  If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  TextColor(15); GotoXY(28,18); Write(' C'); TextColor(07);
  Write('. Use Spellchecker: ['+YNA[Config.SpellCheck]+']'+Pad('',19));

  If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  TextColor(15); GotoXY(28,19); Write(' D'); TextColor(07);
  Write('. Dictionary Path : '+MaxPad(Config.DictionaryPath,23)+' ');

  Help(8,Hil);
  C:=UpCase(ReadKey('DICTTAG'));
  GetMKey:
  Case C Of
    #13: Begin C:=Chr(64+Hil); Goto GetMKey; End;
    #00: Case Crt.ReadKey Of
           'P': If Hil<>4 Then Inc(Hil);
           'H': If Hil<>1 Then Dec(Hil);
          End;
    'A': Begin
          SaveScreen(3);
          Box(5,10,70,4);

          TextAttr:=$0F; GotoXY(7,12);
          Write('Enter full path/filename to the tagline datafile:');
          CursorOn;
          TextAttr:=LightBarColor;
          GotoXY(7,13);
          Read_Str(Config.TagFileName,60,Config.TagFileName);
          RestoreScreen(3);
          CursorOff;

          TextAttr:=$07;
          GotoXY(45,16);
          Write(MaxPad(Config.TagFileName,23));
          CursorOff;
         End;
    'B': Begin
          TextAttr:=$0F; GotoXY(28,17); Write(' C'); TextColor(07);
          Write('. # Tags On Screen: '+Pad(StrVal(Config.NumTaglines),24));
          CursorOn;
          TextAttr:=LightBarColor;
          GotoXY(50,17);
          L:=Config.NumTaglines;
          Read_Int(L,10,L); If L<5 Then L:=5;
          Config.NumTaglines:=L;
          TextAttr:=$07;
          GotoXY(50,17);
          Write(Pad(StrVal(Config.NumTaglines),5));
          CursorOff;
         End;
    'C': Begin
          Inc(Config.Spellcheck); If Config.SpellCheck=3 Then Config.SpellCheck:=0;
         End;
    'D': Begin
          SaveScreen(3);
          Box(5,10,70,4);

          TextAttr:=$0F; GotoXY(7,12);
          Write('Enter full path (no filename!) to the dictionary files:');
          CursorOn; TextAttr:=LightBarColor; GotoXY(7,13); Read_Str(Config.DictionaryPath,60,Config.DictionaryPath);
          RestoreScreen(3);
          CursorOff;
          While Pos('.',Config.DictionaryPath)>0 Do
           Delete(Config.DictionaryPath,Pos('.',Config.DictionaryPath),255);
          TextAttr:=$07; GotoXY(46,19); Write(MaxPad(Config.DictionaryPath,23)); CursorOff;

         End;
   End;
 Until (C=#13) Or (C=#27);
End;

Procedure OverstrikeSetup;
Var
 Hil: Byte;
 C: Char;
Begin
 Hil:=1;
 SaveScreen(5);
 Box(22,9,37,5);
 TextAttr:=$07;
 Repeat
  If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(24,11); Write(' Censor Overstrike Char     ');
                 Write('   '+Config.CensorChar+' '); TextAttr:=$07;
  If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(24,12); Write(' Use Symbols Instead (!$@#) ');
                 Write(' '+YN[Config.RandomSymbolCensor]+' '); TextAttr:=$07;
  If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07;
  GotoXY(24,13); Write(' Only Overstrike Vowels     ');
                 Write(' '+YN[Config.VowelCensorOnly]+' '); TextAttr:=$07;
  Help(9,Hil);
  C:=UpCase(ReadKey('OVERSTRIKE'));
  Case C Of
    'H': Begin Dec(Hil); If Hil=0 Then Hil:=1; End;
    'P': Begin Inc(Hil); If Hil=4 Then Hil:=3; End;
    #13: Case Hil Of
           1: Begin
               TextAttr:=$07; GotoXY(24,11); Write(' Censor Overstrike Char     ');
               Write('   '+Config.CensorChar+' ');
               GotoXY(54,11); TextAttr:=LightBarColor+Blink; Write(' '+Config.CensorChar+' ');
               Help(10,1);
               Repeat C:=ReadKey('OVERSTRIKE'); Until C in [#33..#126,#13,#27];
               If Not (C in [#13,#27]) Then Config.CensorChar:=C;
               GotoXY(55,11); TextAttr:=$07; Write(Config.CensorChar);
               C:=#0;
              End;
           2: Config.RandomSymbolCensor:=Not Config.RandomSymbolCensor;
           3: Config.VowelCensorOnly:=Not Config.VowelCensorOnly;
          End;
   End;
 Until C=#27;
 RestoreScreen(5);
End;

Procedure CensorSetup;
Var
 C: Char;
 Hil: Byte;
Label GetMKey;
Begin
 SaveScreen(5);
 Box(15,8,51,9);
{ TagFileName: String[60];}
 TextAttr:=$07;
 GotoXY(17,10); Write('Words to Censor:');
 For Hil:=1 To 15 Do
  Begin
   GotoXY(16+(((Hil-1) Mod 3)*16),12+((Hil-1) Div 3));
   TextAttr:=$0F; Write('  '+Chr(64+Hil)); TextAttr:=$07; Write('. '+Pad(Config.CensorWords[Hil],10));
  End;
 Hil:=1;
 Repeat
  GotoXY(17+(((Hil-1) Mod 3)*16),12+((Hil-1) Div 3));
  TextAttr:=LightBarColor; TextColor(15); Write(' '+Chr(64+Hil));
  TextColor(7); Write('. '+Pad(Config.CensorWords[Hil],10)+' ');

  Help(10,2);
  C:=UpCase(ReadKey('CENSORSETUP'));

  GotoXY(17+(((Hil-1) Mod 3)*16),12+((Hil-1) Div 3));
  TextAttr:=$0F; Write(' '+Chr(64+Hil)); TextColor(7); Write('. '+Pad(Config.CensorWords[Hil],10)+' ');

  GetMKey:
  Case C Of
    #13: Begin C:=Chr(64+Hil); Goto GetMKey; End;
    #00: Case Crt.ReadKey Of
           'K': If Not (Hil in [1,4,7,10,13]) Then Dec(Hil);
           'M': If Not (Hil in [3,6,9,12,15]) Then Inc(Hil);
           'P': If Hil+3<=15 Then Inc(Hil,3);
           'H': If Hil>3 Then Dec(Hil,3);
          End;
    'A'..'O': Begin
               Hil:=Ord(C)-64;
               GotoXY(17+(((Hil-1) Mod 3)*16),12+((Hil-1) Div 3));
               TextAttr:=$0F; Write(' '+Chr(64+Hil)); TextColor(7); Write('. ');
               CursorOn;
               Read_Str(Config.CensorWords[Ord(C)-64],10,Config.CensorWords[Ord(C)-64]);
               CursorOff;
              End;
   End;
 Until (C=#13) Or (C=#27);
 RestoreScreen(5);
End;

{$IFDEF CompileEditor}

Procedure UserEdit;
Const YN: Array[False..True] Of String[3] = ('No ','Yes');
Var
 Userfile: File Of UserRec;
 Sig: SigType;
 SigFile: File Of SigType;
 Username: String[30];
 UCRC: LongInt;
 Found: Boolean;
 C: Char;
 Hil: Byte;
 AreSigs: Boolean;

Procedure ShowHil(X1,X2: Byte);
Begin
    Case Hil Of
      1 : Begin GotoXY(17,11); TextAttr:=X1; Write(' Expand..: '); TextAttr:=X2; Write(YN[User.UseExpand]+' '); End;
      2 : Begin GotoXY(17,12); TextAttr:=X1; Write(' Keywords: '); TextAttr:=X2; Write(YN[User.UseKeywords]+' '); End;
      3 : Begin GotoXY(17,14); TextAttr:=X1; Write(' TagKeyword 1: '); TextAttr:=X2; Write(Pad(User.TagKeyword[1],11)); End;
      4 : Begin GotoXY(17,15); TextAttr:=X1; Write(' TagKeyword 2: '); TextAttr:=X2; Write(Pad(User.TagKeyword[2],11)); End;
      5 : Begin GotoXY(17,16); TextAttr:=X1; Write(' TagKeyword 3: '); TextAttr:=X2; Write(Pad(User.TagKeyword[3],11)); End;
      6 : Begin GotoXY(17,17); TextAttr:=X1; Write(' TagKeyword 4: '); TextAttr:=X2; Write(Pad(User.TagKeyword[4],11)); End;
      7 : Begin GotoXY(17,19); TextAttr:=X1; Write(' Edit phrase expansions ');                   End;

      11: Begin GotoXY(34,11); TextAttr:=X1; Write(' Taglines: '); TextAttr:=X2; Write(YN[User.UseTaglines]+' ');       End;
      12: Begin GotoXY(34,12); TextAttr:=X1; Write(' SpellChk: '); TextAttr:=X2; Write(YN[Not User.UseSpellChk]+' ');   End;
      13: Begin GotoXY(43,14); TextAttr:=X1; Write(' Frame1 ');                                   End;
      14: Begin GotoXY(43,15); TextAttr:=X1; Write(' Frame2 ');                                   End;
      15: Begin GotoXY(43,16); TextAttr:=X1; Write(' Frame3 ');                                   End;
      16: Begin GotoXY(43,17); TextAttr:=X1; Write(' Frame4 ');                                   End;

      21: Begin GotoXY(50,11); TextAttr:=X1; Write(' AutoTag.: '); TextAttr:=X2; Write(YN[User.AutoTagline]+' ');       End;
      22: Begin GotoXY(50,12); TextAttr:=X1; Write(' AutoSig.: '); TextAttr:=X2; Write(YN[User.AutoSigs]+' ');          End;
      23: Begin GotoXY(51,14); TextAttr:=X1; Write(' Cap '); End;
      24: Begin GotoXY(51,15); TextAttr:=X1; Write(' Low '); End;
      25: Begin GotoXY(51,16); TextAttr:=X1; Write(' Dig '); End;
      26: Begin GotoXY(51,17); TextAttr:=X1; Write(' Sym '); End;

      27: Begin GotoXY(48,19); TextAttr:=X1; If Not AreSigs Then TextColor(8); Write(' Edit signature '); End;

      33: Begin GotoXY(56,14); TextAttr:=X1; Write(' InpCap '); End;
      34: Begin GotoXY(56,15); TextAttr:=X1; Write(' InpLow '); End;
      35: Begin GotoXY(56,16); TextAttr:=X1; Write(' InpDig '); End;
      36: Begin GotoXY(56,17); TextAttr:=X1; Write(' InpSym '); End;
     End;
End;

Procedure GetUserName(Var UName: String; Var UCRC: LongInt);
Var
 Max,Users,Tmp,Top,Hil: LongInt;
Label Start;
Begin
 Start:
 Window(1,1,80,25);
 Max:=FileSize(UserFile); Users:=Max; If Max>10 Then Max:=10;
 If Max=0 Then Exit;
 SaveScreen(9);
 Help(13,2);
 Box(15,7,50,10);
 Window(17,8,63,17);
 Top:=0; Hil:=1;
 TextAttr:=$07;
 Seek(UserFile,0);
 For Tmp:=1 To Max Do Begin GotoXY(1,Tmp); Read(UserFile,User); Write(UN(User.Name)); End;
 Repeat
  TextAttr:=$1F; GotoXY(1,Hil); Seek(UserFile,Top+Hil-1); Read(UserFile,User); Write(UN(User.Name));
  C:=ReadKey('USERNAME');
  TextAttr:=$07; GotoXY(1,Hil); Seek(UserFile,Top+Hil-1); Read(UserFile,User); Write(UN(User.Name));
  Case C Of
    #13: Begin
          Seek(UserFile,Top+Hil-1); Read(UserFile,User);
          UName:=User.Name; UCRC:=User.NameCRC;
          RestoreScreen(9); Exit;
         End;
    #00: Case Crt.ReadKey Of
          'S': Begin
                DeleteRecs(UserFile,Top+Hil-1,1,SizeOf(User));
                RestoreScreen(9);
                Goto Start;
               End;
          'R': Begin
                Seek(UserFile,FileSize(UserFile));
                Window(1,1,80,25);
                FillChar(User,SizeOf(User),#0);
                SaveScreen(3);
                Box(18,11,44,4);
                TextAttr:=$07;
                GotoXY(20,13);
                Write('Enter name of user to add to the list:');
                GotoXY(20,14);
                TextAttr:=$1F; Read_Str(User.Name,30,'');
                RestoreScreen(3);
                User.NameCRC:=CCRC32(User.Name);
                Write(UserFile,User);
                UName:=User.Name; UCRC:=User.NameCRC; RestoreScreen(9); Exit;
               End;
          'H': Begin
                Dec(Hil);
                If Hil=0 Then
                 Begin
                  Inc(Hil);
                  If Top>0 Then
                   Begin
                    Dec(Top);
                    GotoXY(1,1); InsLine;
                    Seek(UserFile,Top+Hil-1); Read(UserFile,User);
                    GotoXY(1,1); Write(UN(User.Name));
                   End;
                 End;
               End;
          'P': Begin
                If Hil+1<=Users Then Inc(Hil);
                If Hil=11 Then
                 Begin
                  Dec(Hil);
                  If Top+Hil+1<=Users Then
                   Begin
                    Inc(Top);
                    GotoXY(1,1); DelLine;
                    Seek(UserFile,Top+Hil-1); Read(UserFile,User);
                    GotoXY(1,10); Write(UN(User.Name));
                   End;
                 End;
               End;
          End;
   End;
 Until C=#27;
 RestoreScreen(9);
 UName:=''; UCRC:=0;
End;

Begin
 Found:=True;
 AreSigs:=False;
 Assign(UserFile,'OEDITUSR.CFG');
 {$I-} Reset(UserFile); {$I+}
 If IOResult<>0 Then Found:=False;
 If Found Then
  Begin
   SaveScreen(4);
   Box(18,11,44,4);
   Help(13,1);
   TextAttr:=$07;
   GotoXY(20,13);
   Write('Enter username to edit (ENTER for list):');
   GotoXY(20,14);
   TextAttr:=$1F; Read_Str(UserName,30,'');
   RestoreScreen(4);
   UCRC:=0;
   If UserName='' Then GetUserName(UserName,UCRC);
   If (UserName='') And (UCRC=0) Then
    Begin
     {$I-} Close(UserFile); {$I+} If IOResult<>0 Then ;
     Exit;
    End;
   Assign(SigFile,'OEDIT.SIG');
   {$I-} Reset(SigFile); {$I+}
   If IOResult<>0 Then AreSigs:=False Else AreSigs:=True;
   If UCRC=0 Then UCRC:=CCRC32(UCase(Username));
   Found:=False;
   Seek(UserFile,0);
   While Not Eof(UserFile) Do
    Begin
     Read(UserFile,User);
     If User.NameCRC=UCRC Then Begin Found:=True; Break; End;
    End;
  End;
 If Found Then
  Begin
   If AreSigs Then
    Begin
     FillChar(Sig,SizeOf(Sig),#0);
     If User.SigPtr<>0 Then
      Begin
       Seek(Sigfile,User.SigPtr-1);
       Read(SigFile,Sig);
      End;
    End;

   Help(11,4);
   If User.Name='' Then
    Begin
     SaveScreen(5);
     Window(1,1,80,25);
     Box(19,8,41,8);
     GotoXY(21,09); XWrite('^\0F               NOTICE:               ');
     GotoXY(21,11); XWrite('^\07Due to the old method of saving  pro-');
     GotoXY(21,12); XWrite('^\07files, this user''s name  is currently');
     GotoXY(21,13); XWrite('^\07unknown.  As  soon as this user  runs');
     GotoXY(21,14); XWrite('^\07Open!EDIT (or  you enter his  name at');
     GotoXY(21,15); XWrite('^\07the ''^\0BEnter username to edit:^\07'' prompt)');
     GotoXY(21,16); XWrite('^\07his name will be recognized.  ^\01[^\09ENTER^\01]');
     ReadKey('');
     RestoreScreen(5);
    End;
   SaveScreen(4);
   Box(15,8,51,11);
   TextAttr:=$07;
   GotoXY(18,09); Write('Name....:                                    ');

   GotoXY(18,11); Write('Expand..:        Taglines:       AutoTag.:   ');
   GotoXY(18,12); Write('Keywords:        SpellChk:       AutoSig.:   ');

   GotoXY(18,14); Write('TagKeyword 1:             Frame1  Cap  InpCap');
   GotoXY(18,15); Write('TagKeyword 2:             Frame2  Low  InpLow');
   GotoXY(18,16); Write('TagKeyword 3:             Frame3  Dig  InpDig');
   GotoXY(18,17); Write('TagKeyword 4:             Frame4  Sym  InpSym');

   GotoXY(18,19); Write('Edit phrase expansions         '); If Not AreSigs Then TextAttr:=$08; Write('Edit signature');

   GotoXY(47,20); XWrite('^\09[^\0BF10^\09=^\0FField Color^\09]');
   TextAttr:=$0F;
   GotoXY(28,09); If User.Name<>'' Then Write(User.Name) Else Write('<unknown>');
   GotoXY(28,11); Write(YN[User.UseExpand]);
   GotoXY(28,12); Write(YN[User.UseKeywords]);

   GotoXY(45,11); Write(YN[User.UseTaglines]);
   GotoXY(45,12); Write(YN[Not User.UseSpellChk]);

   GotoXY(61,11); Write(YN[User.AutoTagline]);
   GotoXY(61,12); Write(YN[User.AutoSigs]);

   GotoXY(32,14); Write(User.TagKeyword[1]);
   GotoXY(32,15); Write(User.TagKeyword[2]);
   GotoXY(32,16); Write(User.TagKeyword[3]);
   GotoXY(32,17); Write(User.TagKeyword[4]);

   Hil:=1;
   Repeat
    ShowHil($1F,$1F);
    C:=ReadKey('USERCONFIG');
    ShowHil($07,$0f);
    Case C Of
      #13: Case Hil Of
             01: User.UseExpand:=Not User.UseExpand;
             02: User.UseKeywords:=Not User.UseKeywords;
             03: Begin GotoXY(32,14); Read_Str(User.TagKeyword[1],10,User.TagKeyword[1]); End;
             04: Begin GotoXY(32,15); Read_Str(User.TagKeyword[2],10,User.TagKeyword[2]); End;
             05: Begin GotoXY(32,16); Read_Str(User.TagKeyword[3],10,User.TagKeyword[3]); End;
             06: Begin GotoXY(32,17); Read_Str(User.TagKeyword[4],10,User.TagKeyword[4]); End;
             07: PhraseExpand(False,Seg(User.Expand),Ofs(User.Expand));
             11: User.UseTaglines:=Not User.UseTaglines;
             12: User.UseSpellChk:=Not User.UseSpellChk;
             13: ChangeColor(User.NC,False,15);
             14: ChangeColor(User.HC,False,15);
             15: ChangeColor(User.BC,False,15);
             16: ChangeColor(User.PC,False,15);
             21: User.AutoTagline:=Not User.AutoTagline;
             22: User.AutoSigs:=Not User.AutoSigs;
             23: ChangeColor(User.FC,False,15);
             24: ChangeColor(User.FL,False,15);
             25: ChangeColor(User.FD,False,15);
             26: ChangeColor(User.FS,False,15);
             27: If AreSigs Then
                 Begin
                  SaveScreen(6);
                  Box(2,9,77,7);
                  GotoXY(4,11); XWrite('^\01[^\0F1^\01]^\07 '+Pad(Sig[1],69));
                  GotoXY(4,12); XWrite('^\01[^\0F2^\01]^\07 '+Pad(Sig[2],69));
                  GotoXY(4,13); XWrite('^\01[^\0F3^\01]^\07 '+Pad(Sig[3],69));
                  GotoXY(4,14); XWrite('^\01[^\0F4^\01]^\07 '+Pad(Sig[4],69));
                  GotoXY(4,15); XWrite('^\01[^\0F5^\01]^\07 '+Pad(Sig[5],69));
                  Repeat
                   C:=ReadKey('USERCONFIG');
                   If C in ['1'..'5'] Then
                    Begin
                     TextAttr:=$0F;
                     GotoXY(8,10+IntVal(C)); Read_Str(Sig[IntVal(C)],69,Sig[IntVal(C)]);
                     GotoXY(4,10+IntVal(C)); XWrite('^\01[^\0F'+C+'^\01]^\07 '+Pad(Sig[IntVal(C)],69));
                    End;
                  Until (C=#13) Or (C=#27);
                  RestoreScreen(6);
                  C:=#255;
                 End;
             33: ChangeColor(User.IC,False,15);
             34: ChangeColor(User.IL,False,15);
             35: ChangeColor(User.ID,False,15);
             36: ChangeColor(User.IS,False,15);
            End;
      #00: Case Crt.ReadKey Of
             'D': ChangeColor(User.FieldColor,False,7);
             'P': If Not (Hil in [7,16,27,36]) Then Inc(Hil);
             'H': If Not (Hil in [1,11,21,33]) Then Dec(Hil);
             'K': Begin
                   If Hil=27 Then Dec(Hil,10);
                   If Hil>=11 Then Dec(Hil,10);
                  End;
             'M': Begin
                   If Hil=7 Then Inc(Hil,10);
                   If (Hil<30) And (Not (Hil in [21,22])) Then Inc(Hil,10);
                  End;
            End;
     End;
   Until C=#27;
   Seek(UserFile,FilePos(UserFile)-1);
   Write(UserFile,User);
   If AreSigs Then
    Begin
     If (User.SigPtr=0) And ((Sig[1]<>'') Or (Sig[2]<>'') Or (Sig[3]<>'') Or (Sig[4]<>'') Or (Sig[5]<>'')) Then
      User.SigPtr:=FileSize(SigFile)+1;
     If User.SigPtr<>0 Then
      Begin
       Seek(SigFile,User.SigPtr-1);
       Write(SigFile,Sig);
      End;
    End;
  End
  Else
  Begin
   SaveScreen(4);
   Box(11,11,58,3);
   TextAttr:=$07;
   GotoXY(13,13);
   Write('User not found in database. Press any key to continue.');
   ReadKey('USERNOTFOUND');
  End;
 If AreSigs Then Close(SigFile);
 {$I-} Close(UserFile); {$I+} If IOResult<>0 Then ;

 RestoreScreen(4);
End;

{$ENDIF}

Procedure ExtraSetup;
Const
 Menu: Array[1..4] Of String[18] = (
                                    'Censor Setup      ',
                                    'Phrase Expand     ',
                                    'Overstrike Setup  ',
                                    'User Editor       '
                                   );
Var
 C: Char;
 Hil: Byte;
Begin
 MainMenu(-27);
 Box(26,14,50,4);

 Hil:=1;
 Repeat

  GotoXY(28,16); If Hil=1 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[1]);
  GotoXY(28,17); If Hil=2 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[2]);
  GotoXY(51,16); If Hil=3 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[3]);
  GotoXY(51,17); If Hil=4 Then TextAttr:=LightBarColor Else TextAttr:=$07; Write(' '+Menu[4]);

  Help(11,Hil);
  C:=ReadKey('EXTRASETUP');

  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If Not (Hil in [1,3]) Then Dec(Hil);
           'P': If Not (Hil in [2,4]) Then Inc(Hil);
           'M': If Hil+2<=4 Then Inc(Hil,2);
           'K': If Hil-2>0 Then Dec(Hil,2);
          End;
    #13: Case Hil Of
           1: CensorSetup;
           2: PhraseExpand(True,Seg(Config.ExpandWord),Ofs(Config.ExpandWord));
           3: OverstrikeSetup;
{$IFDEF CompileEditor}
           4: Begin UserEdit; CursorOff; End;
{$ENDIF}
          End;
   End;
 Until C=#27;
{CensorSetup}; {PhraseExpand}
End;

Procedure AutoInstall;
Var
 SuggEXE: String[80];
 S: String;
 Update: Boolean;
 NewF,F,BatchFile: Text;
 SEPath: String[100];
 RAPath: String[100];
 CCPath: String[100];
 EZPath: String[100];
 QKPath: String[100];

 RACBak,
 RAConfig: ^CONFIGrecord;
 RACfgFile: File Of CONFIGrecord;

 CCConfigHdr: ^ConfigHdr;
 CCConfig   : ^CCConfigRec;
 CCCBak     : ^CCConfigRec;
 CCCfgFile  : File;

 QKNodeCfg    : ^NodeConfigRecord;
 QKNodeCfgFile: File Of NodeConfigRecord;
 QKConfig     : ^QKConfigRecord;
 QKConfigFile : File Of QKConfigRecord;

 NodeDir,P: String[100];
 Tmp,I,PP: Byte;
 SR: SearchRec;
Begin
 RAPath:='';
 QKPath:='';
 EZPath:='';
 SEPath:=UCase(RemoveWildCard(ParamStr(0)));
 RAPath:=UCase(GetEnv('RA'));
 QKPath:=UCase(GetEnv('QUICK'));
 EZPath:=UCase(GetEnv('EZYCOM'));   EZPath:='\'; { UNSUPPORTED AS OF YET }
 CCPath:=UCase(GetEnv('CONCORD'));  CCPath:='\'; { UNSUPPORTED AS OF YET }

 If RAPath[Length(RAPath)]<>'\' Then RAPath:=RAPath+'\';
 If QKPath[Length(QKPath)]<>'\' Then QKPath:=QKPath+'\';
 If EZPath[Length(EZPath)]<>'\' Then EZPath:=EZPath+'\';

 If (RAPath='\') And
    (RAPath='\') And
    (EZPath='\') Then Exit;

 SaveScreen(1);

 Box(10,8,60,11);
 TextAttr:=$07;
 GotoXY(12,10); Write('Welcome to Open!EDIT Setup.  Since no configuration file');
 GotoXY(12,11); Write('could be found in the current  directory, it is  assumed');
 GotoXY(12,12); Write('that you are installing Open!EDIT for the first time.   ');
 GotoXY(12,14);
 If RAPath<>'\' Then
  Write('Open!EDIT has detected that you  are using RemoteAccess,')
 Else
 If QKPath<>'\' Then
  Write('Open!EDIT has  detected  that you  are  using  QuickBBS,')
 Else
 If EZPath<>'\' Then
  Write('Open!EDIT  has  detected  that  you  are  using  EzyCom,')
 Else
 If CCPath<>'\' Then
  Write('Open!EDIT  has  detected  that  you  are  using Concord,');

 GotoXY(12,15); Write('and  therefore can  automatically  detect  many of  your');
 GotoXY(12,16); Write('settings, then install and partially configure itself.  ');
 GotoXY(12,18); Write('Should Open!EDIT attempt to auto-configure itself? (y/n)');
 Help(10,3);
 Repeat C:=UpCase(Readkey('AUTOCONFIG')); Until C in ['Y','N'];
 RestoreScreen(1);
 If C='N' Then Exit;

 If RAPath<>'\' Then
  Begin
   Assign(RACfgFile,RAPath+'CONFIG.RA');
   {$I-} Reset(RACfgFile); {$I+}
   If IOResult<>0 Then Exit;
   New(RAConfig); New(RACBak);
   Read(RACfgFile,RAConfig^); Close(RACfgFile);
   RACBak^:=RAConfig^;
   If Lo(RAConfig^.VersionID)=50 Then Config.RA250:=True;
   Config.BBSPath:=RAPath;
   Config.BBSProg:=bbs_RA;
   Config.RegName:=RAConfig^.SysOp;
   Config.DOSSwap:=0;
   If RAConfig^.AltJSwap Then Config.DOSSwap:=USE_FILE+HIDE_FILE;
   If RAConfig^.UseEMS Then Config.DOSSwap:=USE_EMS+HIDE_FILE;
   If RAConfig^.UseXMS Then Config.DOSSwap:=USE_XMS+HIDE_FILE;
   Config.RepStr:=Copy(RAConfig^.ReplyHeader,1,15);
   If Not RAConfig^.MultiLine Then
    Begin
     NodeDir:=RAPath;
    End
    Else
    Begin
     NodeDir:=FFind(Copy(RAPath,1,Length(RAPath)-1),'TIMELOG.BBS',RAPath+'TIMELOG.BBS');
     If NodeDir='' Then
      NodeDir:=RAPath
     Else
      Begin
       NodeDir:=RemoveWildcard(NodeDir);
       PP:=0;
       I:=Length(NodeDir);
       Repeat
        If NodeDir[I] in ['0'..'9'] Then
         Begin PP:=I; Delete(NodeDir,PP,1); End
        Else If PP<>0 Then Break;
        Dec(I);
       Until I=1;
       If PP<>0 Then Insert('%1',NodeDir,PP);
      End;
     SaveScreen(1);
     Box(6,8,68,9);
     TextAttr:=$07;
     GotoXY(8,10); Write('Open!EDIT Setup has determined that you are running a multi-line');
     GotoXY(8,11); Write('system.  Please verify that the following is the correct path to');
     GotoXY(8,12); Write('your node directories.');
     GotoXY(8,16); Write('(change if not correct; replace node numbers with "%1")');
     TextAttr:=LightBarColor;
     GotoXY(8,14); Read_Str(NodeDir,64,NodeDir); CursorOff;
     RestoreScreen(1);
    End;
  End;

 If QKPath<>'\' Then
  Begin
   Assign(QKConfigFile,QKPath+'QUICKCFG.DAT');
   {$I-} Reset(QKConfigFile); {$I+}
   If IOResult<>0 Then Exit;
   New(QKConfig); New(QKNodeCfg);
   Read(QKConfigFile,QKConfig^); Close(QKConfigFile);

   Config.BBSPath:=QKPath;
   Config.BBSProg:=bbs_QK;
   Config.RegName:=QKConfig^.SysOpName;
   Config.DOSSwap:=0;
   If QKConfig^.AltJSwap Then Config.DOSSwap:=USE_FILE+HIDE_FILE+USE_EMS+USE_XMS;
   If Not QKConfig^.MultiNode Then
    Begin
     NodeDir:=QKPath;
    End
    Else
    Begin
     NodeDir:=FFind(Copy(QKPath,1,Length(QKPath)-1),'TIMELOG.BBS',QKPath+'TIMELOG.BBS');
     If NodeDir='' Then
      NodeDir:=QKPath
     Else
      Begin
       NodeDir:=RemoveWildcard(NodeDir);
       PP:=0;
       I:=Length(NodeDir);
       Repeat
        If NodeDir[I] in ['0'..'9'] Then
         Begin PP:=I; Delete(NodeDir,PP,1); End
        Else If PP<>0 Then Break;
        Dec(I);
       Until I=1;
       If PP<>0 Then Insert('%1',NodeDir,PP);
      End;
     SaveScreen(1);
     Box(6,8,68,9);
     TextAttr:=$07;
     GotoXY(8,10); Write('Open!EDIT Setup has determined that you are running a multi-line');
     GotoXY(8,11); Write('system.  Please verify that the following is the correct path to');
     GotoXY(8,12); Write('your node directories.');
     GotoXY(8,16); Write('(change if not correct; replace node numbers with "%1")');
     TextAttr:=LightBarColor;
     GotoXY(8,14); Read_Str(NodeDir,64,NodeDir); CursorOff;
     RestoreScreen(1);
    End;
  End;

 Assign(BatchFile,SEPath+'CE.BAT');
 ReWrite(BatchFile);
 WriteLn(BatchFile,'@ECHO OFF');
 S:=SEPath; Delete(S,1,2); Delete(S,Length(S),1);
 WriteLn(BatchFile,'CD'+S);
 WriteLn(BatchFile,'OEDIT.EXE -N%1 -P'+NodeDir+' -1');
 S:=NodeDir; Delete(S,1,2); Delete(S,Length(S),1);
 WriteLn(BatchFile,'CD'+S);
 Close(BatchFile);

 Case Config.BBSProg Of
   bbs_RA: SuggEXE:='*C /C '+SEPath+'OEDIT.BAT *N *M *UOpen!EDIT';
   bbs_CC: ;
   bbs_QK: SuggEXE:='*C /C '+SEPath+'OEDIT.BAT *N *M';
   bbs_EZ: SuggEXE:=SEPath+'OEDIT.EXE -P'+NodeDir+' -N*N *D1 *M';
  End;

 Assign(F,'LOCAL.DEF');
 {$I-} Reset(F); {$I+} If IOResult=0 Then Update:=True Else Update:=False;
 Assign(NewF,'LOCAL.DE$');
 ReWrite(NewF);
 Case Config.BBSProg Of
   bbs_RA: Begin
            WriteLn(NewF,RAConfig^.SystemName);
            WriteLn(NewF,RAConfig^.SysOp);
            WriteLn(NewF,RAConfig^.SysOp);
            WriteLn(NewF,RAConfig^.Location);
           End;
   bbs_CC: Begin
            WriteLn(NewF,CCConfig^.RegInfos.BBS);
            WriteLn(NewF,CCConfig^.RegInfos.SysOp);
            WriteLn(NewF,CCConfig^.RegInfos.SysOp);
            WriteLn(NewF,CCConfig^.RegInfos.Location);
           End;
   bbs_QK: Begin
            WriteLn(NewF,QKConfig^.SystemName);
            WriteLn(NewF,QKConfig^.SysOpName);
            WriteLn(NewF,QKConfig^.SysOpName);
            WriteLn(NewF,QKConfig^.Location);
           End;
  End;
 WriteLn(NewF,'100');
 WriteLn(NewF,'ON');
 WriteLn(NewF,'60');
 If Update Then
  Begin
   For Hil:=1 To 7 Do ReadLn(F,S);
   While Not Eof(F) Do
    Begin
     ReadLn(F,S);
     WriteLn(NewF,S);
    End;
   Close(F);
   Erase(F);
  End;
 Close(NewF);
 Rename(NewF,'LOCAL.DEF');

 SaveScreen(1);
 Box(6,10,68,5);
 TextAttr:=$07;
 GotoXY(8,12);
 Case Config.BBSProg Of
   bbs_RA: Write('Open!EDIT is now ready to update your RemoteAccess configuration');
   bbs_CC: Write('Open!EDIT  is now  ready to  update your  Concord  configuration');
   bbs_QK: Write('Open!EDIT  is now  ready to  update your  QuickBBS configuration');
   bbs_EZ: Write('Open!EDIT  is  now  ready to  update  your  EzyCom configuration');
  End;
 GotoXY(8,13); XWrite('^\07to make Open!EDIT your default  full-screen editor.  Hit ^\01<^\0Fenter^\01>');
 GotoXY(8,14); XWrite('^\07to continue, or ^\01<^\0Fescape^\01> ^\07to skip this step.');
 Help(10,4);
 Repeat C:=ReadKey('DEFAULTED'); Until C in [#13,#27];
 RestoreScreen(1);

 If C=#13 Then
  Begin
   SaveScreen(1);
   Box(6,10,68,7);
   TextAttr:=$07;
   GotoXY(8,12); XWrite('The suggested  commandline to  load Open!EDIT  from your  BBS is');
   GotoXY(8,13); XWrite('below.  If it is correct, simply press ^\01<^\0Fenter^\01>^\07;  if not,  please');
   GotoXY(8,14); XWrite('correct it and press ^\01<^\0Fenter^\01>^\07 to continue.');
   Help(10,5);
   GotoXY(8,16); Read_Str(SuggEXE,64,SuggEXE);
   RestoreScreen(1);

   Case Config.BBSProg Of
     bbs_RA: Begin
              RAConfig^.ExternalEdCmd:=SuggEXE;
              Assign(RACfgFile,RAPath+'CONFIG.TE');
              ReWrite(RACfgFile); Write(RACfgFile,RACBak^); Close(RACfgFile);
              Assign(RACfgFile,RAPath+'CONFIG.RA');
              Reset(RACfgFile); Write(RACfgFile,RAConfig^); Close(RACfgFile);
             End;

     bbs_QK: Begin
              Assign(QKNodeCfgFile,QKPath+'NODECFG.DAT');
              Reset(QKNodeCfgFile);
              Read(QKNodeCfgFile,QKNodeCfg^);
              Close(QKNodeCfgFile);

              Assign(QKNodeCfgFile,QKPath+'NODECFG.TE');
              ReWrite(QKNodeCfgFile); Write(QKNodeCfgFile,QKNodeCfg^); Close(QKNodeCfgFile);

              QKNodeCfg^.EditorCmdStr:=SuggEXE;
              Assign(QKNodeCfgFile,QKPath+'NODECFG.DAT');
              ReWrite(QKNodeCfgFile);
              Write(QKNodeCfgFile,QKNodeCfg^);
              Close(QKNodeCfgFile);

              If QKConfig^.Multinode Then
               Begin
                For Tmp:=1 To 255 Do
                 Begin
                  P:=NodeDir;
                  PP:=Pos('%1',P);
                  Delete(P,PP,2); Insert(StrVal(Tmp),P,PP);
                  If P[Length(P)]<>'\' Then P:=P+'\';
                  FindFirst(P+'NODECFG.DAT',AnyFile,SR);
                  If DOSError=0 Then
                   Begin
                    Assign(QKNodeCfgFile,P+'NODECFG.DAT');
                    Reset(QKNodeCfgFile);
                    Read(QKNodeCfgFile,QKNodeCfg^);
                    Close(QKNodeCfgFile);

                    Assign(QKNodeCfgFile,P+'NODECFG.TE');
                    ReWrite(QKNodeCfgFile); Write(QKNodeCfgFile,QKNodeCfg^); Close(QKNodeCfgFile);

                    QKNodeCfg^.EditorCmdStr:=SuggEXE;
                    Assign(QKNodeCfgFile,P+'NODECFG.DAT');
                    ReWrite(QKNodeCfgFile);
                    Write(QKNodeCfgFile,QKNodeCfg^);
                    Close(QKNodeCfgFile);
                   End;
                 End;
               End;
             End;
    End;
  End;

 SaveScreen(1);
 Box(6,10,68,5);
 TextAttr:=$07;
 GotoXY(8,12); Write('Open!EDIT auto-install  is complete.  Please  finish configuring');
 GotoXY(8,13); Write('the remaining setup options to suit your needs, prior to running');
 GotoXY(8,14); XWrite('^\07Open!EDIT.                              Hit ^\01<^\0Fenter^\01>^\07 to Continue.');
  Help(10,5);
 Repeat Until ReadKey('DONEINST')=#13;
 RestoreScreen(1);

 Case Config.BBSProg Of
   bbs_RA: Begin Dispose(RAConfig); Dispose(RACBak); End;
   bbs_QK: Begin Dispose(QKConfig); Dispose(QKNodeCfg); End;
  End;
End;

Procedure DoBeta;
Var Pwd: String;
Begin
 {$IFNDEF PreRelease} DoneBeta:=True; Exit; {$ENDIF}
 WriteLn('Open!EDIT Setup v'+Ver);
 WriteLn('This release intended for Open!ware beta team members only');
 WriteLn('Unauthorized access prohibited');
 WriteLn;
 Write('Password: ');
 Read_StrMask:=True;
 RSMaskChar:='.';
 Utilpack.Read_Str(Pwd,15,'');
 WriteLn;
 If CCRC32(UCase(Pwd))=PWDCRC Then
  Begin
   DoneBeta:=True;
   WriteLn('Password correct, please enjoy the new beta');
   WriteLn('If you encounter any difficulties, please contact Open!ware.');
   CDelay(1500);
  End
  Else
   Begin
    DoneBeta:=False;
    WriteLn('Invalid password');
    WriteLn('Please contact Open!ware for assistance');
    Halt;
   End;
End;

Procedure kBumpDecode(MSeg,MOfs,Size: Word);
Var
 TmpW: Word; Adjust,E,K,O: Byte;
Begin
 Mem[MSeg:MOfs+Size-1]:=Mem[MSeg:MOfs+Size-1]-192;
 For TmpW:=1 To Size Do
  Begin
   E:=Mem[MSeg:MOfs+TmpW-1]; K:=Mem[Seg(Key):Ofs(Key)+TmpW Mod 4]; O:=E xor K;
   Mem[MSeg:MOfs+TmpW-1]:=O;
  End;
 For TmpW:=Size DownTo 1 Do
  Begin If TmpW<>Size Then Mem[MSeg:MOfs+TmpW-1]:=CW(Mem[MSeg:MOfs+TmpW-1],-Mem[MSeg:MOfs+TmpW]); End;
End;

Procedure kBumpEncode(MSeg,MOfs,Size: Word);
Var
 TmpW: Word; Adjust,O,E,K: Byte;
Begin
 For TmpW:=1 To Size Do
  Begin If TmpW<>Size Then Mem[MSeg:MOfs+TmpW-1]:=CW(Mem[MSeg:MOfs+TmpW-1],Mem[MSeg:MOfs+TmpW]); End;
 For TmpW:=1 To Size Do
  Begin
   O:=Mem[MSeg:MOfs+TmpW-1]; K:=Mem[Seg(Key):Ofs(Key)+TmpW Mod 4]; E:=O xor K;
   Mem[MSeg:MOfs+TmpW-1]:=E;
  End;
 Mem[MSeg:MOfs+Size-1]:=Mem[MSeg:MOfs+Size-1]+192;
End;

Procedure v170New;
Type XType = Array[1..83] Of Char;
Var
  F: File of XType;
  X: XType;
  S: String;
  SR: SearchRec;
Begin
  ScreenConfig;
  If Not DoneBeta Then DoBeta;
  FindFirst('*.LNG',AnyFile,SR);
  While DOSError=0 Do
  Begin
    If SR.Attr And Directory <> 0 Then Begin FindNext(SR); Continue; End;
    Assign(F,SR.Name);
    Reset(F);
    If FileSize(F)=103 Then
    Begin
      Seek(F,FileSize(F));
      S:='SysOp is editing your account, please wait...';
      FillChar(X,SizeOf(X),#0); Move(S[1],X[6],Length(S)); Write(F,X);
    End;
    Close(F);
    FindNext(SR);
  End;
  Assign(ConfigFile,'OEDIT.CFG');
  {$I-} Reset(ConfigFile); {$I+}
  If IOresult=0 Then
  Begin
    Read(ConfigFile,Config);
    Config.WrapMargin:=78;
    Seek(ConfigFile,0);
    Write(ConfigFile,Config);
    Close(ConfigFile);
  End;
End;

Begin
  DoneBeta:=False;
  HomePath:=RemoveWildcard(ParamStr(0));
  Ver[0]:=#5;
  InitHelp;
  Loadup:
  Restart:=False;
  NewConfig:=False;
  Assign(xCfgVerFile,'OEDIT.CFG');
  {$I-} Reset(xCfgVerFile,1); {$I-}
  If IOResult=0 Then
  Begin
    Seek(xCfgVerFile,FileSize(xCfgVerFile)-6);
    BlockRead(xCfgVerFile,xCfgVer,SizeOf(xCfgVer));
    Close(xCfgVerFile);
{$IFDEF PreRelease}
    Write('[resetver= ]'#8#8); c:=upcase(Crt.Readkey); write(c); If c='Y' Then xCfgVer:='1.50a'; WriteLn;
{$ENDIF}
     End;
  V170New;
 Assign(ConfigFile,'OEDIT.CFG');
 {$I-} Reset(ConfigFile); {$I+}
 If IOResult<>0 Then
  Begin
    If Not DoneBeta Then DoBeta;
    NewConfig:=True;
    ReWrite(ConfigFile);
    FillChar(Config,SizeOf(Config),#0);
    Config.CfgHeader:='Open!EDIT v'+Ver+' Configuration File'+#26;
    Config.CfgHeader[0]:='S';
    With Config Do
    Begin
      NC:=$0F; HC:=$0B; BC:=$01; PC:=$09;   FZ:=9;
      FC:=$0F; FL:=$07; FS:=$09; FD:=$0B;
      IC:=$0B; ID:=$0B; IL:=$0F; IS:=$09;
      FieldColor:=$01;
      TagFileName:='TAGLINES.TAG';
      TabStop:=8;
      CensorChar:='*';
      BBSPath:='';
      BBSProg:=bbs_XX;
      DataUEC:=0;
      TearLine:=1;
      RegName:='';
      MaxQuotePct:=75.0;
      ForceLessQuote:=False;
      VowelCensorOnly:=False;
      RandomSymbolCensor:=False;
      AbsMaxMsgLines:=4000;
      DOSSwap:=USE_EMS Or USE_XMS Or USE_FILE Or HIDE_FILE;
      SpellCheck:=2;
      DictionaryPath:='';
      QuoteWinSize:=5;
      ImportSecurity:=999999;
      ExportSecurity:=999999;
      ScrollSiz:=8;
      UseTaglines:=True;
      UseExpand:=True;
      UseKeywords:=True;
      Censor:=False;
      FillChar(OKTagArea,SizeOf(OKTagArea),True);
      FillChar(OKExpandArea,SizeOf(OKExpandArea),True);
      FillChar(OKKeywordArea,SizeOf(OKKeywordArea),True);
      FillChar(OKCensorArea,SizeOf(OKCensorArea),False);
      DateFormat:=0;
      TimeFormat:=0;
      RepStr:=' * In a message';
      AutoSave:=True;
      LanguageFile:='ENGLISH';
      OKSigHiBit:=False;
      WrapMargin:=78;
      CfgVer:=Ver;
    End;
    Write(ConfigFile,Config);
    Seek(ConfigFile,0);
    ScreenConfig;
  End;
  Seek(ConfigFile,0);
  Read(ConfigFile,Config);
  Close(ConfigFile);
  If Config.Startdate=0 Then Config.StartDate:=Julian(Copy(UnpackedDT(CurrentDT),1,8));
  If Config.ScrollSiz>14 Then Config.ScrollSiz:=8;
  TextAttr:=$01; Write('['); TextAttr:=$09; Write('+'); TextAttr:=$0F; Write('Loading');
  TextAttr:=$09; Write('+'); TextAttr:=$01; Write(']'#13);
  If FileExists('OEDIT.REG') Then
    DecryptKey:=Decode(UCase(Config.RegName),Config.DataUEC,'OEDIT.REG')
  Else
  DecryptKey:=StrUnreg;
  DecryptKey:=Capitalize(DecryptKey);
  Config.RegName:=Capitalize(Config.RegName);
  CursorOff;
  FillScr(#176,$07);
  TextAttr:=$0F; GotoXY(1,1); ClrEol;
  TextAttr:=$01; GotoXY(1,2); Write(MakeStr(80,#196));
  TextAttr:=$01; GotoXY(1,24); Write(MakeStr(80,#196));
  TextAttr:=$0F; GotoXY(1,25); ClrEol;
  Write(' Open!EDIT v'+Ver+' Setup                         Press [F1] at any time for help');
  Box(4,4,72,5);
  TextAttr:=$07;
  Center('Open!EDIT v'+Ver+' Setup',6);
  Center('Copyright (C) 2011, By Shawn Highfield',7);
  Center('http://www.tinysbbs.com',8);
  If NewConfig Then AutoInstall;
  If Config.LanguageFile='' Then Config.LanguageFile:='ENGLISH';
  SaveScreen(1);
  Hil:=1;
  MainMenu(0);
  Repeat
    TextAttr:=LightBarColor; GotoXY(33,14+Hil); Write(' '+Menu[Hil]+' ');
    Help(12,Hil);
    C:=UpCase(ReadKey('MAINMENU'));
    TextAttr:=$07; GotoXY(33,14+Hil); Write(' '+Menu[Hil]+' ');
  Case C Of
    #00: Case Crt.ReadKey Of
           'H': If Hil<>1 Then Dec(Hil);
           'P': If Hil<>5 Then Inc(Hil);
          End;
    #13: Begin
          RestoreScreen(1);
          SaveScreen(1);
          Case Hil Of
            1: GeneralSetup;
            2: Toggles;
{$IFDEF CompileColorCfg}
            3: ColorConfig;
{$ENDIF}
            4: TaglineSetup;
            5: ExtraSetup;
           End;
          RestoreScreen(1);
          SaveScreen(1);
          MainMenu(0);
         End;
   End;
 Until (C=#27) Or (Restart);
 CursorOn;
 FancyClear;
 ReWrite(ConfigFile);
 Write(ConfigFile,Config);
 Close(ConfigFile);
 If Restart Then Goto LoadUp;
 TextAttr:=$01;
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$07;
 WriteLn('                            Open!EDIT v'+Ver+' Setup');
 Center('Copyright (C) 2011, By Shawn Highfield',3);
 Center('http://www.tinysbbs.com',4);
 GotoXY(1,5);
 TextAttr:=$01;
 WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$07;
 WriteLn;

End.
