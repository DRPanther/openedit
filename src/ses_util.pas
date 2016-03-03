Unit SES_Util; {SESETUP.EXE}
{$DEFINE CompileF1}
{$DEFINE CompileHelp}

Interface

Procedure XWrite(S: String);
Procedure Box(X,Y,Wid,Len: Byte);
Procedure Read_Int(Var X: LongInt; Max,Def: LongInt);
Procedure Read_Str(Var S: String; Max: Byte; Def: String);
Function LowInt(B: Byte): Byte;
Procedure InitHelp;
Procedure FancyClear;
Function SearchDir(Path: String; FN: String; Exclude: String): String;
Function FFind(Path: String; FN: String; Exclude: String): String;
Procedure RemInputBgColors;
Function HackPrevent(S: String): String;
Procedure v160New;
Procedure v160BetaNew;
Procedure PreviewDeluxe;
Procedure PreviewRegular;
Procedure DoScr(S: String);
Procedure ScreenConfig;
Function  DeleteRecs(Var AFile; From: LongInt; Count: LongInt; BufSize: Word): Integer;
Function UN(S: String): String;
Function HexB(B: Byte): String;
Procedure DumpColors;
Procedure ChangeColor(Var Attr: Byte; BG: Boolean; Max: Byte);
Procedure Help(HNum,HSet: Byte);
Function ReadKey(Topic: String): Char;
Procedure CSHelp(Var Topic: String);

{$I SEDIT.INC}

Type
 HelpRec = Record
   Topic: String[15];
   DataPtr: LongInt;
   DataLines: LongInt;
  End;
Const
 USE_EMS   = $01;
 USE_XMS   = $02;
 USE_FILE  = $04;
 EMS_FIRST = $00;
 XMS_FIRST = $10;
 HIDE_FILE = $40;
 BarColor      = $01;
 LightBarColor = $1F;
 LBCS          = '1';
 HelpStart: LongInt = -1;

Var
 TopHalf,BotHalf: Word;
 HomePath: String;
 Config: ConfigRec;
 ConfigFile: File Of ConfigRec;
 User: UserRec;
 NewConfig: Boolean;
 CfgTmp: Byte;
 OldSigFile: File Of OldSigType;
 SigFile: File Of SigType;
 OldSig: OldSigType;
 Sig: SigType;
 xCfgVerFile: File;
 xCfgVer: String[5];

Implementation

Uses Crt,Utilpack,DOS;

Procedure XWrite(S: String);
Begin
 TextAttr:=$07;
 While Pos('^\',S)>0 Do
  Begin
   Write(Copy(S,1,Pos('^\',S)-1));
   Delete(S,1,Pos('^\',S)+1);
   Case S[1] Of
     'S': Begin
           Delete(S,1,1);
           Write(Pad('',IntVal(Copy(S,1,2))));
           Delete(S,1,2);
          End;
     Else Begin
           TextAttr:=LIntVal('$'+Copy(S,1,2));
           Delete(S,1,2);
          End;
    End;
  End;
 Write(S);
End;

Function LowInt(B: Byte): Byte;
Begin
 If B>7 Then Dec(B,8);
 LowInt:=B;
End;

Procedure Read_Str(Var S: String; Max: Byte; Def: String);
Var cX: Byte;
Begin
 cX:=TextAttr;
 TextAttr:=LightBarColor;
 Write(MakeStr(Max,#32),MakeStr(Max,#8));
 UtilPack.Read_Str(S,Max,Def);
 TextAttr:=cX;
End;

Procedure Read_Int(Var X: LongInt; Max,Def: LongInt);
Var cX: Byte;
Begin
 cX:=TextAttr;
 TextAttr:=LightBarColor;
 Write(MakeStr(Length(StrVal(Max)),#32),MakeStr(Length(StrVal(Max)),#8));
 UtilPack.Read_Int(X,Max,Def);
 TextAttr:=cX;
End;

Procedure Box(X,Y,Wid,Len: Byte);
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
   TextAttr:=$08; Write(GetChar); Write(GetChar);
  End;
 TextAttr:=BA;
 GotoXY(X,Y+Len+1); Write('À'+MakeStr(Wid-2,'Ä')+'Ù');
 TextAttr:=$08; Write(GetChar); Write(GetChar);
 GotoXY(X+2,Y+Len+2); For Tmp:=1 To Wid Do Write(GetChar);
End;

Procedure InitHelp;
Var
 HelpFile: File;
 Hdr: String[32];
 Help: HelpRec;
 L: LongInt;
 Tmp,
 B: Byte;
 S: String[81];
Begin
 Assign(HelpFile,HomePath+'CESETUP.HLP');
 {$I-} Reset(HelpFile,1); {$I+}
 If IOResult<>0 Then
  Begin
   Assign(HelpFile,'CESETUP.HLP');
   {$I-} Reset(HelpFile,1); {$I+}
  End;
 If IOResult<>0 Then Exit;
 BlockRead(HelpFile,Hdr,SizeOf(Hdr));
 BlockRead(HelpFile,L,SizeOf(L));
 Seek(HelpFile,FilePos(HelpFile)+SizeOf(HelpRec)*(L-1));
 BlockRead(HelpFile,Help,SizeOf(Help));
 Seek(HelpFile,Help.DataPtr+4+33);
 For Tmp:=1 To Help.DataLines Do
  Begin
   BlockRead(HelpFile,B,SizeOf(B)); BlockRead(HelpFile,S,B);
  End;
 HelpStart:=FilePos(HelpFile);
 Close(HelpFile);
End;

Procedure FancyClear;
Var R: Real; Tmp: Byte;
Begin
 TopHalf:=2160; BotHalf:=2000;
 Repeat

  { Move up upper screen }
  Move(Mem[VSeg:160],Mem[VSeg:0],TopHalf-160);
  GotoXY(1,TopHalf Div 160); ClrEol;
  Dec(TopHalf,160);

  { Move down lower screen }
  Move(Mem[VSeg:BotHalf],Mem[VSeg:BotHalf+160],2000-(BotHalf-2000));
  GotoXY(1,BotHalf Div 160+2); ClrEol;
  Inc(BotHalf,160);

 Until (TopHalf=80) And (BotHalf=4080);
End;

Function SearchDir(Path: String; FN: String; Exclude: String): String;
Var SR: SearchRec; SD: String[80];
Begin
 FN:=UCase(FN); SearchDir:=''; ChDir(Path);
 FindFirst(Path+'\*.*',AnyFile,SR);
 While DOSError=0 Do
  Begin
   If (SR.Name=FN) And (Path+'\'+SR.Name<>Exclude) Then Begin SearchDir:=Path+'\'+SR.Name; Exit; End;
   If (SR.Name='.') Or (SR.Name='..') Then Begin FindNext(SR); Continue; End;
   If (SR.Attr And Directory<>0) Then
    Begin
     SD:=SearchDir(Path+'\'+SR.Name,FN,Exclude);
     If SD<>'' Then Begin SearchDir:=SD; Exit; End;
    End;
   FindNext(SR);
  End;
End;

Function FFind(Path: String; FN: String; Exclude: String): String;
Var S: String; Begin GetDir(0,S); FFind:=SearchDir(Path,FN,Exclude); ChDir(S); End;

Procedure RemInputBgColors;
Var
 UserFile: File Of UserRec;
 User: UserRec;
Begin
 While Config.IC>=$10 Do Dec(Config.IC,$10);
 While Config.IL>=$10 Do Dec(Config.IL,$10);
 While Config.ID>=$10 Do Dec(Config.ID,$10);
 While Config.IS>=$10 Do Dec(Config.IS,$10);

 Assign(UserFile,'OEDITUSR.CFG');
 {$I-} Reset(UserFile); {$I+}
 If IOResult<>0 Then Exit;
 While Not Eof(UserFile) Do
  Begin
   Read(UserFile,User);
   While User.IC>=$10 Do Dec(User.IC,$10);
   While User.IL>=$10 Do Dec(User.IL,$10);
   While User.ID>=$10 Do Dec(User.ID,$10);
   While User.IS>=$10 Do Dec(User.IS,$10);
   Seek(UserFile,FilePos(UserFile)-1);
   Write(UserFile,User);
  End;
 Close(UserFile);
End;

Function HackPrevent(S: String): String;
Var Tmp: Byte;
Begin
 For Tmp:=1 To Length(S) Do
  S[Tmp]:=Chr(Ord(S[Tmp])-Ord(S[0]));
 HackPrevent:=S;
End;

Procedure ConvertConfig;
Var
 OConfig: OldConfigRec;
 OConfigFile: File Of OldConfigRec;
Begin
 Assign(OConfigFile,'OEDIT.CFG');
 Reset(OConfigFile);
 Read(OConfigFile,OConfig);
 Close(OConfigFile);
 Assign(ConfigFile,'OEDIT.CF$');
 ReWrite(ConfigFile);
 FillChar(Config,SizeOf(Config),#0);
 With Config Do
  Begin
   CfgHeader:='Open!EDIT v'+Ver+' Configuration File';
   Move(OConfig.ExpandWord,ExpandWord,SizeOf(ExpandWord));
   NC:=OConfig.NC;
   HC:=OConfig.HC;
   BC:=OConfig.BC;
   PC:=OConfig.PC;
   FZ:=OConfig.FZ;
   FC:=OConfig.FC;
   FL:=OConfig.FL;
   FS:=OConfig.FS;
   FD:=OConfig.FD;
   IC:=OConfig.IC;
   ID:=OConfig.ID;
   IL:=OConfig.IL;
   IS:=OConfig.IS;
   TagFileName:=OConfig.TagFileName;
   TabStop:=OConfig.TabStop;
   CensorChar:=OConfig.CensorChar;
   BBSPath:=OConfig.RAPath;
   If OConfig.UsingRA Then BBSProg:=bbs_RA Else BBSProg:=bbs_XX;
   DataUEC:=OConfig.DataUEC;
   TearLine:=OConfig.TearLine;
   RegName:=OConfig.RegName;
   MaxQuotePct:=OConfig.MaxQuotePct;
   ForceLessQuote:=OConfig.ForceLessQuote;
   VowelCensorOnly:=OConfig.VowelCensorOnly;
   RandomSymbolCensor:=OConfig.RandomSymbolCensor;
   AbsMaxMsgLines:=OConfig.AbsMaxMsgLines;
   DOSSwap:=OConfig.DOSSwap;
   ForceCtlW:=OConfig.ForceCtlW;
   SpellCheck:=OConfig.SpellCheck;
   DictionaryPath:=OConfig.DictionaryPath;
   QuoteWinSize:=OConfig.QuoteWinSize;
   RA250:=OConfig.RA250;
   Move(OConfig.AltF1to10,AltF1to10,SizeOf(AltF1to10));
   ImportSecurity:=OConfig.ImportSecurity;
   ExportSecurity:=OConfig.ExportSecurity;
   ScrollSiz:=OConfig.ScrollSiz;
   Move(OConfig.CensorWords,CensorWords,SizeOf(CensorWords));
   TimeOutDelay:=OConfig.TimeOutDelay;
   ExtendedChars:=OConfig.ExtendedChars;
   NumTaglines:=OConfig.NumTaglines;
   UseTaglines:=OConfig.UseTaglines;
   UseExpand:=OConfig.UseExpand;
   UseKeywords:=OConfig.UseKeywords;
   Censor:=OConfig.Censor;
   UseSigs:=True;
   Move(OConfig.OKTagArea,OKTagArea,SizeOf(OKTagArea));
   Move(OConfig.OKExpandArea,OKExpandArea,SizeOf(OKExpandArea));
   Move(OConfig.OKKeywordArea,OKKeywordArea,SizeOf(OKKeywordArea));
   Move(OConfig.OKCensorArea,OKCensorArea,SizeOf(OKCensorArea));
   FillChar(Config.OKSigArea,SizeOf(Config.OKSigArea),True);
   Config.ExtendedChars:=0;
   Config.NumTaglines:=5;
   Config.StartDate:=Julian(Copy(UnpackedDT(CurrentDT),1,8));
  End;
 Write(ConfigFile,Config);
 Close(ConfigFile);
 Erase(OConfigFile);
 Rename(ConfigFile,'OEDIT.CFG');
End;

(*Procedure UpdateConfig;
Var
 Config: OldConfigRec;
 ConfigFile: File Of OldConfigRec;
Begin
 Assign(ConfigFile,'OEDIT.CFG');
 Reset(ConfigFile);
 Read(ConfigFile,Config);

   If Config.CfgVer<'1.30a' Then
    Begin
     With Config Do
      Begin
       TearLine:=2;
       ForceCtlW:=False;

       AbsMaxMsgLines:=4000;

       DOSSwap:=USE_EMS Or USE_XMS Or USE_FILE Or HIDE_FILE;

       SpellCheck:=2;
       DictionaryPath:='';

       QuoteWinSize:=5;

       RA250:=False;
  {     AltF1to10}

       ImportSecurity:=999999;
       ExportSecurity:=999999;
      End;
    End;
   If Config.CfgVer<='1.30a' Then
    Begin
     For CfgTmp:=1 To 10 Do Config.AltF1to10[CfgTmp].CmdType:=0;
     Move(Config.Extra,Config.CensorWords,SizeOf(Config.Extra));
     Config.ScrollSiz:=8;
     Config.TimeOutDelay:=120;
     FillChar(Config.Extra,SizeOf(Config.Extra),#0);
    End;
   If Config.CfgVer<'1.40' Then
    Begin
     Assign(OldSigFile,'OEDIT.SIG');
     {$I-} Reset(OldSigFile); {$I+}
     If IOResult=0 Then
      Begin
       Assign(SigFile,'OEDIT.$IG');
       ReWrite(SigFile);
       While Not Eof(OldSigFile) Do
        Begin
         Read(OldSigFile,OldSig);
         FillChar(Sig,SizeOf(Sig),#0);
         Move(OldSig,Sig,SizeOf(OldSig));
         Write(SigFile,Sig);
        End;
       Close(SigFile);
       Close(OldSigFile);
       Erase(OldSigFile);
       Rename(SigFile,'OEDIT.SIG');
      End;
     Config.DictionaryPath:=RemoveWildCard(Config.DictionaryPath);
     If Config.DictionaryPath='CE_DIC' Then Config.DictionaryPath:='';
    End;

 Seek(ConfigFile,0);
 Write(ConfigFile,Config);
 Close(ConfigFile);
End;

Procedure v150New;
Begin
 Assign(ConfigFile,'OEDIT.CFG');
 {$I-} Reset(ConfigFile); {$I+}
 If IOresult=0 Then
  Begin
   Read(ConfigFile,Config);

   Config.DateFormat:=0;
   Config.TimeFormat:=0;
   Config.RepStr:=' * In a message';
   Config.AutoSave:=True;
   RemInputBgColors;

   Seek(ConfigFile,0);
   Write(ConfigFile,Config);
   Close(ConfigFile);
  End;
End;
*)
Procedure v160BetaNew;
Type XType = Array[1..83] Of Char;
Var
 F: File of XType;
 X: XType;
 S: String;
 SR: SearchRec;
 User: UserRec;
 Userfile: File Of UserRec;
Begin
 Assign(ConfigFile,'OEDIT.CFG');
 {$I-} Reset(ConfigFile); {$I+}
 If IOresult=0 Then
  Begin
   Read(ConfigFile,Config);

   Config.FieldColor:=LowInt(Config.BC);

   FindFirst('*.LNG',AnyFile,SR);
   While DOSError=0 Do
    Begin
     If SR.Attr And Directory <> 0 Then Begin FindNext(SR); Continue; End;
     Assign(F,SR.Name);
     Reset(F);
     If FileSize(F)=102 Then
      Begin
       Seek(F,FileSize(F));
       S:='Field Color';
       FillChar(X,SizeOf(X),#0); Move(S[1],X[6],Length(S)); Write(F,X);
      End;
     Close(F);
     FindNext(SR);
    End;

   Seek(ConfigFile,0);
   Write(ConfigFile,Config);
   Close(ConfigFile);
  End;
 Assign(UserFile,'OEDITUSR.CFG');
 {$I-} Reset(UserFile); {$I+}
 If IOResult<>0 Then Exit;
 While Not Eof(UserFile) Do
  Begin
   Read(UserFile,User);
   User.FieldColor:=LowInt(User.BC);
   Seek(UserFile,FilePos(UserFile)-1);
   Write(UserFile,User);
  End;
 Close(UserFile);
End;

Procedure v160New;
Type XType = Array[1..83] Of Char;
Var
 F: File of XType;
 X: XType;
 S: String;
 SR: SearchRec;
Begin
 Assign(ConfigFile,'OEDIT.CFG');
 {$I-} Reset(ConfigFile); {$I+}
 If IOresult=0 Then
  Begin
   Read(ConfigFile,Config);

   Config.OKSigHiBit:=False;

   Config.LanguageFile:='ENGLISH';

   FindFirst('*.LNG',AnyFile,SR);
   While DOSError=0 Do
    Begin
     If SR.Attr And Directory <> 0 Then Begin FindNext(SR); Continue; End;
     Assign(F,SR.Name);
     Reset(F);
     If FileSize(F)=99 Then
      Begin
       Seek(F,FileSize(F));
       S:='Welcome to';
       FillChar(X,SizeOf(X),#0); Move(S[1],X[6],Length(S)); Write(F,X);
       S:='Please select a language';
       FillChar(X,SizeOf(X),#0); Move(S[1],X[6],Length(S)); Write(F,X);
       S:='Change Language';
       FillChar(X,SizeOf(X),#0); Move(S[1],X[6],Length(S)); Write(F,X);
      End;
     Close(F);
     FindNext(SR);
    End;

   Seek(ConfigFile,0);
   Write(ConfigFile,Config);
   Close(ConfigFile);
  End;
 v160BetaNew;
End;

Procedure PreviewDeluxe;
Begin
 SaveScreen(3);
 TextAttr:=$07; ClrScr;
 GotoXY(1,1); XWrite('^\0FÚ^\0BÄÄ^\09ÄÄ^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
 GotoXY(1,2); XWrite('^\0B³^\09Û²±° ^\0FF^\07rom^\09: ^\1B S^\1Fhawn ^\1BH^\1Fighfield       ^\07       ^\0FM^\07sg^\0FD'+
                      '^\07ate^\09: ^\1B 30^\19-^\1FM^\17ar^\19-^\1B97 12^\19:^\1B00^\17pm ^\07    ^\09°^\01³');
 GotoXY(1,3); XWrite('^\09³^\09²±°  ^\0FT^\07o  ^\09: ^\1B J^\1Foe ^\1BU^\1Fser                ^\07       ^\0FM^\07sg^\0FN'+
                      '^\07um ^\09: ^\1B 00000 ^\07 ^\0FP^\07riv^\09: ^\1B Y^\1Fes ^\07   ^\09°±^\01³');
 GotoXY(1,4); XWrite('^\01³^\09±°   ^\0FA^\07rea^\09: ^\1B G^\1Feneral ^\1BC^\1Fhatter         ^\07                       '+
                      '              ^\09°±²^\09³');
 GotoXY(1,5); XWrite('^\01³^\09°    ^\0FS^\07ubj^\09: ^\1B C^\1Fheep^\1BEDIT C^\1Fonfiguration                            '+
                      '        ^\07 ^\09°±²Û^\0B³');
 GotoXY(1,6); XWrite('^\01ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ^\09ÄÄ^\0BÄÄ^\0FÙ');

 GotoXY(1,23); XWrite('^\0FÚ^\0BÄÄ^\09ÄÄ^\01ÄÄ^\09[^\0B12^\09:^\0B00^\07p^\09]^\01Ä^\09[^\0B060 ^\0FM^\07ins^\0'+
                      '9]^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ^\09ÄÄ^\0BÄ¿');
 GotoXY(1,24); XWrite('^\0BÀÄ^\09ÄÄ^\01ÄÄ ^\0FC^\07heep^\0FEDIT ^\07v^\0B'+Ver[1]+'^\09.^\0B'+Ver[3]+Ver[4]+'^\07a ^\01ÄÄÄ'+
                      'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ^\09ÄÄ^\0BÄÄ^\0FÙ');
 GotoXY(1,8); XWrite('^\0FP^\07ress any key to continue^\09.');
 Crt.ReadKey;
 RestoreScreen(3);
End;

Procedure PreviewRegular;
Begin
 SaveScreen(3);
 TextAttr:=$07; ClrScr;
 GotoXY(1,1); TextAttr:=$17; ClrEol; XWrite('^\17 From: ^\1FShawn Highfield            ^\17Date: ^\1F30-Mar-97 12:00pm    '+
                                            '      ^\17Msg#: ^\1F00000');
 GotoXY(1,2); TextAttr:=$17; ClrEol; XWrite('^\17 To  : ^\1FJoe User                   ^\17Area: ^\1FGeneral Chatter      '+
                                            '      ^\17Priv: ^\1FYes');
 GotoXY(1,3); TextAttr:=$17; ClrEol; XWrite('^\17 Subj: ^\1FOpen!EDIT Configuration');
 GotoXY(1,4); XWrite('^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 GotoXY(1,6); XWrite('^\07Press any key to continue.');

 GotoXY(1,23); XWrite('^\01ÄÄÄÄÄÄÄ^\09[^\0F12:00p^\09]^\01Ä^\09[^\0F060 Mins^\09]^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'+
                      'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 GotoXY(1,24); XWrite('^\0E Open!EDIT v'+Ver);
 Crt.ReadKey;
 RestoreScreen(3);
End;

Procedure DoScr(S: String);
Var
 Fin,Fout: File;
 NR: Word;
 B: Array[1..1024] Of Byte;
Begin

 If FileExists(HomePath+'HEADER.CTL') Then
  Begin
   If FileExists(HomePath+'HEADER.BAK') Then Begin Assign(Fin,HomePath+'HEADER.BAK'); Erase(Fin); End;
   Assign(Fin,HomePath+'HEADER.CTL');
   Rename(Fin,HomePath+'HEADER.BAK');
  End;

 If FileExists(HomePath+'FOOTER.CTL') Then
  Begin
   If FileExists(HomePath+'FOOTER.BAK') Then Begin Assign(Fin,HomePath+'FOOTER.BAK'); Erase(Fin); End;
   Assign(Fin,HomePath+'FOOTER.CTL');
   Rename(Fin,HomePath+'FOOTER.BAK');
  End;

 Assign(Fin,HomePath+'HEADER.'+S);
 Reset(Fin,1);
 Assign(Fout,HomePath+'HEADER.CTL');
 ReWrite(Fout,1);
 Repeat
  BlockRead(Fin,B,SizeOf(B),NR);
  BlockWrite(Fout,B,NR);
 Until NR=0;
 Close(Fin);
 Close(Fout);

 Assign(Fin,HomePath+'FOOTER.'+S);
 Reset(Fin,1);
 Assign(Fout,HomePath+'FOOTER.CTL');
 ReWrite(Fout,1);
 Repeat
  BlockRead(Fin,B,SizeOf(B),NR);
  BlockWrite(Fout,B,NR);
 Until NR=0;
 Close(Fin);
 Close(Fout);
End;

Procedure ScreenConfig;
Var
 C: Char;
 Up: Boolean;
 Left: Boolean;
Begin
 If Not
   (FileExists(HomePath+'HEADER.001') And FileExists(HomePath+'FOOTER.001') And
    FileExists(HomePath+'HEADER.002') And FileExists(HomePath+'FOOTER.002')) Then
     Exit;
 SaveScreen(4);
 Box(10,5,60,15);
 TextAttr:=$0F;
 GotoXY(42,25); Write('Use '#26'/'#27'/'#24'/'#25' to move, <enter> to select');
 TextAttr:=$07;
 GotoXY(12,06); Write('Welcome to Open!EDIT v'+Ver+'.  Before proceeding any fur-');
 GotoXY(12,07); Write('ther, you must choose which screen style you wish to use.');
 GotoXY(12,09); XWrite('^\07 [Deluxe]                              [Deluxe Preview] ');
 GotoXY(12,10); XWrite('^\0FÚ^\0BÄÄ^\09ÄÄ^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 GotoXY(12,11); XWrite('^\0B³^\09Û²±° ^\0FF^\07rom^\09: ^\1F Shawn Highfield         ^\0F       ^\'+
                       '0FM^\07sg^\0FD^\07ate^\09: ^\1F 30');
 GotoXY(12,12); XWrite('^\09³^\09²±°  ^\0FT^\07o  ^\09: ^\1F Joe User                ^\0F       ^\'+
                       '0FM^\07sg^\0FN^\07um ^\09: ^\1F 00');
 GotoXY(12,13); XWrite('^\01³^\09±°   ^\0FA^\07rea^\09: ^\1F General Chatter         ^\0F                   ');
 GotoXY(12,14); XWrite('^\01³^\09°    ^\0FS^\07ubj^\09: ^\1F Open!EDIT Configuration                    ^\0F');
 GotoXY(12,16); XWrite('^\07 [Regular]                            [Regular Preview] ');
 GotoXY(12,17); XWrite('^\17 From:^\1F Shawn Highfield            ^\17Date: ^\1F 25-Feb-10 03:44');
 GotoXY(12,18); XWrite('^\17 To  :^\1F Joe User                   ^\17Area: ^\1F General Chatter');
 GotoXY(12,19); XWrite('^\17 Subj:^\1F Open!EDIT Configuration                          ');
 GotoXY(12,20); XWrite('^\01ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 Left:=True; Up:=True;
 Repeat
  TextAttr:=$1F;
  If Up And Left Then             Begin GotoXY(12,09); Write(' [Deluxe] '); End;
  If Up And (Not Left) Then       Begin GotoXY(50,09); Write(' [Deluxe Preview] '); End;
  If (Not Up) And Left Then       Begin GotoXY(12,16); Write(' [Regular] '); End;
  If (Not Up) And (Not Left) Then Begin GotoXY(49,16); Write(' [Regular Preview] '); End;

  C:=Crt.ReadKey;

  TextAttr:=$07;
  If Up And Left Then             Begin GotoXY(12,09); Write(' [Deluxe] '); End;
  If Up And (Not Left) Then       Begin GotoXY(50,09); Write(' [Deluxe Preview] '); End;
  If (Not Up) And Left Then       Begin GotoXY(12,16); Write(' [Regular] '); End;
  If (Not Up) And (Not Left) Then Begin GotoXY(49,16); Write(' [Regular Preview] '); End;
  Case C Of
    #13: If Not Left Then
          Begin
           If Up Then PreviewDeluxe Else PreviewRegular;
           C:=#255;
          End;
    #0: Case Crt.ReadKey Of
          'H': Up:=True;
          'P': Up:=False;
          'K': Left:=True;
          'M': Left:=False;
         End;
   End;
 Until C=#13;

 If Up Then DoScr('001') Else DoScr('002');

 RestoreScreen(4);
End;

Function  DeleteRecs(    Var AFile ;
                         From      : LongInt ;
                         Count     : LongInt ;
                         BufSize   : Word) : Integer ;

Var  Buffer    : Pointer ;              { pointer to buffer                }
     Src       : LongInt ;              { source record pointer            }
     Cnt       : LongInt ;              { scratch                          }
     Last      : LongInt ;              { last record to move              }
     f         : File Absolute AFile ;  { file we're going to work on      }
     Err       : Integer ;              { error code                       }

Label
     Sortie ;

Begin
     Last:=FileSize(f) ;
     Src:=From+Count ;
     If Count>(Last-From) Then Count:=Last-From ;

     { check BufSize against FileRec(f).RecSize }
     If (BufSize<FileRec(f).RecSize) Or
        (MaxAvail<BufSize) Then
     Begin
          DeleteRecs:=1 ; { error }
          Exit ;
     End ;

     GetMem(Buffer, BufSize) ;

     While Src<Last Do
     Begin
          Cnt:=BufSize Div FileRec(f).RecSize ;
          If (Src+Cnt)>Last Then Cnt:=Last-Src ;
          Seek(f, Src) ;
          BlockRead(f, Buffer^, Cnt) ;
          { error check }
          Err:=IOResult ;
          If Err<>0 Then GoTo Sortie ;
          Seek(f, From) ;
          BlockWrite(f, Buffer^, Cnt) ;
          { error check }
          Err:=IOResult ;
          If Err<>0 Then GoTo Sortie ;
          Inc(Src, Cnt) ;
          Inc(From, Cnt) ;
     End ;

     Seek(f, Last-Count) ;
     Truncate(f) ;
Sortie:
     DeleteRecs:=Err ;
     FreeMem(Buffer, BufSize) ;
End;

Function UN(S: String): String;
Begin
 If S='' Then S:='<unknown name>';
 S:=' '+Pad(S,45);
 UN:=S;
End;

Function HexB(B: Byte): String;
Var S: String;
Begin
 S:=HexW(B);
 Delete(S,1,2);
 HexB:=S;
End;

Procedure DumpColors;
Var
 F: Text;
 Y: Boolean;
Begin
 Randomize;
 Assign(F,'COLOR.FIL');
 {$I-} Append(F); {$I+}
 Y:=False;
 If IOresult<>0 Then Begin ReWrite(F); Y:=True; End;
 WriteLn(F,'{ Open!EDIT ColorSetup Dumped '+UnpackedDT(CurrentDT)+'}');
 WriteLn(F,'');
 If Y Then WriteLn(F,'Const');
 Write(F,' Color'+HexW(Random($FFFF))+': Array[1..13] Of Byte = ($');
 Write(F,HexB(Config.NC)+',$');
 Write(F,HexB(Config.HC)+',$');
 Write(F,HexB(Config.BC)+',$');
 Write(F,HexB(Config.PC)+',$');
 Write(F,HexB(Config.FZ)+',$');
 Write(F,HexB(Config.FC)+',$');
 Write(F,HexB(Config.FL)+',$');
 Write(F,HexB(Config.FS)+',$');
 Write(F,HexB(Config.FD)+',$');
 Write(F,HexB(Config.IC)+',$');
 Write(F,HexB(Config.ID)+',$');
 Write(F,HexB(Config.IL)+',$');
 Write(F,HexB(Config.IS)+',$');
 WriteLn(F,HexB(Config.FieldColor)+');');
 WriteLn(F,'');
 Close(F);
End;

Procedure ChangeColor(Var Attr: Byte; BG: Boolean; Max: Byte);
Var
 Len,
 Tmp,
 Bk,
 Clr: Byte;
 C: Char;
Begin
 Len:=3; If BG Then Len:=10;
 SaveScreen(3);
 Box(58,11,6+Max,Len);
 Len:=1; If BG Then Len:=8;
 For Tmp:=1 To Len Do
  Begin
   GotoXY(61,12+Tmp); TextAttr:=$70; Write('ş'); For Clr:=1 To Max Do Begin TextAttr:=Clr+((Tmp-1)*$10); Write('ş'); End;
  End;
 TextAttr:=$0F;
 Tmp:=0; Clr:=Attr; While Clr>=$10 Do Begin Dec(Clr,$10); Inc(Tmp); End;
 Repeat
  GotoXY(59,13+Tmp); Write('Ä'+#26);
  GotoXY(61+Clr,12); Write(#25);
  Help(0,9);
  C:=UpCase(ReadKey('COLORCHG'));
  GotoXY(59,13+Tmp); Write('  ');
  GotoXY(61+Clr,12); Write(' ');
  Case C Of
    #00: Case Crt.ReadKey Of
           'M': If Clr<>Max Then Inc(Clr);
           'K': If Clr<>0 Then Dec(Clr);
           'H': If Tmp<>0 Then Dec(Tmp);
           'P': If Tmp<>Len-1 Then Inc(Tmp);
          End;
   End;
 Until (C=#13) Or (C=#27);
 If C=#13 Then Attr:=Clr+(Tmp*$10);
 RestoreScreen(3);
End;

Procedure Help(HNum,HSet: Byte);
Var
 X,Y,A,x1,x2: Word;
 HelpFile: File;
 S: String[80];
Begin
{$IFDEF CompileHelp}
 If HelpStart=-1 Then Exit;

 Assign(HelpFile,HomePath+'CESETUP.HLP');
 {$I-} Reset(HelpFile,1); {$I+}
 If IOResult<>0 Then
  Begin
   Assign(HelpFile,'CESETUP.HLP');
   {$I-} Reset(HelpFile,1); {$I+}
  End;
 If IOResult<>0 Then Exit;
 Seek(HelpFile,HelpStart+81*(HNum*10+HSet-1));
 BlockRead(HelpFile,S,81);
 Close(HelpFile);
 X:=WhereX; Y:=WhereY; A:=TextAttr;
 x1:=WindMin;
 x2:=WindMax;
 Window(1,1,80,25);
 GotoXY(2,1); TextAttr:=$0F; ClrEol; Write(S);
 WindMin:=x1;
 WindMax:=x2;
 GotoXY(X,Y); TextAttr:=A;
{$ENDIF}
End;

{$IFDEF CompileF1}
Procedure CSHelp(Var Topic: String);
Type
 Str127 = String[127];
Const
 PageSize = 15;
Var
 Found: Boolean;
 HelpFile: File;
 Help: HelpRec;
 TextBuf: Array[1..128] Of ^Str127;
 B: Byte;
 Lines: Byte;
 Cnt,Cnt2,
 L: LongInt;
 Top: LongInt;
 Max: LongInt;
 C: Char;
 NewCnt: Byte;
 Tmp,Tmp2: Byte;
 X,Y: Byte;
 Hdr: String[32];
Begin
 Assign(HelpFile,HomePath+'CESETUP.HLP');
 {$I-} Reset(HelpFile,1); {$I+}
 If IOResult<>0 Then
  Begin
   Assign(HelpFile,'CESETUP.HLP');
   {$I-} Reset(HelpFile,1); {$I+}
  End;
 If IOResult<>0 Then
  Begin
   Lines:=2;
   For NewCnt:=1 To Lines Do New(TextBuf[NewCnt]);
   TextBuf[1]^:='Canneot locate help file,';
   TextBuf[2]^:=HomePath+'CESETUP.HLP';
  End
  Else
  Begin
   BlockRead(HelpFile,Hdr,SizeOf(Hdr));
   Found:=False;
   BlockRead(Helpfile,L,SizeOf(L));
   For Cnt:=1 To L Do
    Begin
     BlockRead(HelpFile,Help,SizeOf(HelpRec));
     If UCase(Help.Topic)=UCase(Topic) Then
      Begin
       Seek(HelpFile,Help.DataPtr+4+33);
       For Cnt2:=1 To Help.DataLines Do
        Begin
         BlockRead(HelpFile,B,SizeOf(B));
         New(TextBuf[Cnt2]);
         BlockRead(HelpFile,Mem[Seg(TextBuf[Cnt2]^):Ofs(TextBuf[Cnt2]^)+1],B);
         TextBuf[Cnt2]^[0]:=Chr(B);
        End;
       Lines:=Help.DataLines;
       Found:=True;
       Break;
      End;
    End;
   If Not Found Then
    Begin
     Lines:=2;
     For NewCnt:=1 To Lines Do New(TextBuf[NewCnt]);
     TextBuf[1]^:='Cannot locate help topic,';
     TextBuf[2]^:='help file possibly corrupt.';
    End;
  End;
 SaveScreen(9);
 Window(1,1,80,25);
 TextAttr:=$01;
 GotoXY(10,5); Write('É'+MakeStr(60,#205)+'»');
 For Cnt:=1 To PageSize Do
  Begin
   GotoXY(10,5+Cnt); Write('º'+Pad('',60)+'º');
  End;
 GotoXY(10,5+Cnt+1);
 If Lines>PageSize Then
  Begin
   Write('È'+MakeStr(45,#205));
   Write('µ');
   TextAttr:=$1F;
   Write(' '#24'/'#25' Scroll ');
   TextAttr:=$01;
   Write('ÆÍ¼');
  End Else Write('È'+MakeStr(60,#205)+'¼');
 Window(12,6,69,5+PageSize);
 TextAttr:=$07;
 Top:=1;
 Max:=PageSize; If Max>Lines Then Max:=Lines;
 For Cnt:=1 To Max Do Begin GotoXY(1,Cnt); XWrite(TextBuf[Cnt]^); End;
 Repeat
  C:=UpCase(Crt.ReadKey);
  Case C Of
    #0: Case Crt.ReadKey Of
          'P': If Top+PageSize<=Lines Then
                Begin
                 Inc(Top);
                 GotoXY(1,1); DelLine; TextAttr:=$07;
                 GotoXY(1,PageSize); XWrite(TextBuf[Top+PageSize-1]^);
                End;
          'H': If Top<>1 Then
                Begin
                 Dec(Top); TextAttr:=$07;
                 GotoXY(1,1); InsLine; XWrite(TextBuf[Top]^);
                End;
         End;
   End;
 Until C=#27;
 For NewCnt:=1 To Lines Do Dispose(TextBuf[NewCnt]);
 Window(1,1,80,25);
 RestoreScreen(9);
 {$I-} Close(HelpFile); {$I+} If IOResult<>0 Then ;
End;
{$ENDIF}

Function ReadKey(Topic: String): Char;
Var
 C: Char;
 OK: Boolean;
Begin
 OK:=False;
 Repeat
  C:=Crt.ReadKey;
 {$IFDEF CompileF1}
  If C=#0 Then
   Begin
    C:=Crt.ReadKey;
    If C=';' Then CSHelp(Topic) Else
    Begin StuffKey(Ord(C)); C:=#0; OK:=True; End;
   End
   Else
{$ENDIF}
    OK:=True;
 Until OK;
 ReadKey:=C;
End;

End.
