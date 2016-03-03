{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{                                                                   Rev. 017 }
{ Utility Pack                                                               }
{ Miscellaneous Turbo Pascal v7.0 Utilities                                  }
{ By Steve Blinch of Mikerosoft Productions                                  }
{                                                                            }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

{$DEFINE SysInfo}
{$DEFINE Useless}

Unit UtilPack;

{$O+}
{$F+}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  Interface
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Uses DOS;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ File Information                                                           }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function FileExists(FN: String): Boolean;       {             Does FN exist? }
Function FileOpen(Var F): Boolean;              {                 Is F open? }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ String Manipulation                                                        }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function Capitalize(S: String): String;         {   StRiNg bBs => String BBS }
Function LCase(UpString: String): String;       {           sTRINg => string }
Function UCase(UpString: String): String;       {           StrinG => STRING }
Function LoCase(C: Char): Char;                 {       Opposite of UpCase() }
                                                { -------------------------- }
Function FPad(St: String; I: Integer): String;  { Make St I spcs, add 2 head }
Function Pad(St: String; I: Integer): String;   { Make St I spcs, add 2 tail }
Function LTrim(WhatStr: String): String;        {     Removes spaces to LEFT }
Function RTrim(WhatStr: String): String;        {    Removes spaces to RIGHT }
Function Copy1(S: String; Len: Byte): String;   {        FAST Copy(S,1,Len); }
                                                { -------------------------- }
Function Zero(I: LongInt; Z: Byte): String;     { Preceed I w/Z-Len(I) "0"'s }
Function ZeroS(S: String; Z: Byte): String;     { Preceed S w/Z-Len(S) "0"'s }
Function LeadingZero(W: Word): String;          {   Pad W to 2 digits ("01") }
                                                { -------------------------- }
Function Backwards(Forwards: String): String;   {          Reverses a string }
Function CommaFmt(Value: LongInt): String;      {  Insert "," every 3 digits }
Function MakeStr(Len: Byte; MCh: Char): String; {     Makes str of Len chars }
                                                { -------------------------- }
Function RemoveWildcard(St: String): String;    {        D:\XX\*.* => D:\XX\ }
Function Strip(WhatName: String): String;       {     D:\XX\XX.XXX => XX.XXX }
Function Extension(Filename: String): String;   {        FILENAME.EXT => EXT }
                                                { -------------------------- }
Procedure Read_Str(VAR Return: String;          {    Read string into Return }
                   Max: Integer; Default: String);

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Date/Time Routines                                                         }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function FormatTime(Rl: Real): String;          {   Format to ##:##:## style }
Function Timer: Real;                           {   Returns secs since 00:00 }
Procedure CDelay(D: Word);                      {        Uses clock to delay }
Procedure RTC_Delay(Microsecs: Longint);        {  1000000 microsecs = 1 sec }
Function Gregorian(Julian: LongInt): String;
Function Julian(DT: String): Longint;           {    MM/DD/YY -> Julian Date }
Function FormatDate(L: LongInt; UseCInfo: Boolean): String; {    Format date }
Function UnpackedDT(L: LongInt): String;        { UnpackTime, convenient :-) }
Function PackedDT(MMDDYYHHMMSS: String;         {   PackTime, convenient :-) }
         DT: DateTime; UseDT: Boolean): LongInt;
Function CurrentDT: LongInt;                    { PackTime'd  time/date  NOW }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Screen Routines                                                            }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure CursorOff;                            {           Turns cursor off }
Procedure CursorOn;                             {            Turns cursor on }
Procedure SmallCursor;                          {    Makes underscore cursor }
Procedure BigCursor;                            {         Makes block cursor }
                                                { -------------------------- }
Procedure Save_Screen;                          {       Saves copy of screen }
Procedure Save_Screen2;                         {     Saves copy of screen 2 }
Procedure Restore_Screen;                       {     Restore copy of screen }
Procedure Restore_Screen2;                      {   Restore copy of screen 2 }
Procedure SaveScreen(Idx: Byte);                {   Up to 10 saves available }
Procedure RestoreScreen(Idx: Byte);             { Restore SaveScreen screens }
                                                { -------------------------- }
Function GetAttr: Byte;                         { Return attr @WhereX,WhereY }
Function GetChar: Char;                         { Return char @WhereX,WhereY }
Procedure FillScr(C: Char; A: Byte);            {  Fill screen w/C, w/attr A }
Procedure ZWrite(C: Char);                      {   Direct write, ^G=no beep }
                                                { -------------------------- }
Procedure HighIntensity(SetHi: Boolean);        {  Toggle hi-intensity/blink }
Procedure Set25Lines;                           {    Set 25 line screen mode }
                                                { -------------------------- }
Function SetOutput(FileName: String): Boolean;  {     Redirect EXEC() output }
Procedure CancelOutput;                         {         Cancel redirection }
Function VSeg: Word;                            {  Return Video Segment Addr }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Hardware/Low Level Routines                                                }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure ColdBoot;                             {       Cold boot the system }
Procedure WarmBoot;                             {       Warm boot the system }
                                                { -------------------------- }
Procedure Drive_Light_Off(Drive: Char);         {   Turn drive A/B light OFF }
Procedure Drive_Light_On(Drive: Char);          {    Turn drive A/B light ON }
Procedure SetCLk(Assert: Boolean);              {      Turn on/off Caps Lock }
Procedure SetSLk(Assert: Boolean);              {    Turn on/off Scroll Lock }
Procedure SetNLk(Assert: Boolean);              {    Turn on/off Number Lock }
Procedure SetPrtScr(Assert: Boolean);           {   Turn on/off Print Screen }
                                                { -------------------------- }
Procedure StuffKey(W: Word);                    {  Inserts W into kbd buffer }
Function PeekKey: Char;                         {   Check next key in buffer }
Procedure SetIns(Assert: Boolean);              {          Set Insert status }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Numeric Routines                                                           }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function IntVal(ChrStr: String): Integer;       {   Cvt ChrStr to an Integer }
Function LIntVal(ChrStr: String): LongInt;      {    Cvt ChrStr to a LongInt }
Function StrVal(IntNum: LongInt): String;       {       Cvt IntNum to String }
                                                { -------------------------- }
Function Hex(L: LongInt): String;               { Return L in Hex (8 digits) }
Function HexW(I: Word): String;                 { Return I in Hex (4 digits) }
Function HexZ(L: LongInt): String;              {     Hex() w/o zero padding }
Function HexPtr(P: Pointer): String;            {  Return P in ssss:oooo fmt }
                                                { -------------------------- }
Procedure Read_Int(VAR WhatInt: LongInt;        {  Read integer into WhatInt }
                   Maximum,Default: LongInt);

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Miscellaneous Routines                                                     }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure CallProc(UserProc: Pointer);          {              Call UserProc }
Function InsStat: Boolean;                      {         Is Insert Mode on? }

{$IFDEF Useless}
Function CvtToByte(IntToRound: Integer): Byte;  {             Max out at 255 }
Function CvtToInt(RealToRound: Real): Integer;  {           Max out at 32767 }
Function CvtToLInt(RealToRound: Real): LongInt; {      Max out at 2147483647 }
Function CvtToReal(LngInt: LongInt): Real;      {               -- No use -- }
Function CvtToWord(RealToRound: Real): Word;    {           Max out at 65535 }
Function WordToInt(WordToRound: Word): Integer; {           Max out at 32767 }
Function WordVal(ChrStr: String): Word;         {       Cvt ChrStr to a Word }
Function RoundOff(RealToRound: Real): Real;     {               -- No use -- }

Procedure MoveLong(FromP,ToP: Pointer;          {   Fast, large block Move() }
                   Len: longint);
Procedure RAMShot(FN: String);                  {      Copy 640K RAM to disk }
Function ReadChar(Pattern: Integer): Char;      { ReadKey/ Flash NLk/Cap/SLk }
Procedure Init_Box(Text1,Text2,Text3: String);  {      Center TextX in a box }
Procedure Copy_File(Source, Dest: String;       {        Copy source to dest }
                    Display: Boolean; VAR Success: Boolean);
Function ExecWin(ProgName,Params: String;       {           Exec in a window }
                 LeftCol,TopLine,RightCol,BottomLine: Word): Word;
Function ExecWin2(ProgName,Params: String;
                 LeftCol,TopLine,RightCol,BottomLine: Word): Word;
{$ENDIF}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ System Information                                                         }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

{$IFDEF SysInfo}
Function AnsiSysLoaded : Boolean;               {        Is ANSI.SYS loaded? }
Function DblLoaded: Boolean;                    {     Is DoubleSpace loaded? }
Function DVLoaded: Boolean;                     {        Is DESQview loaded? }
Function WinLoaded: Boolean;                    {         Is Windows loaded? }
Function OS2Loaded: Boolean;                    {            Is OS/2 loaded? }
Function x4DOSLoaded: Boolean;                  {            Is 4DOS loaded? }
Function ShareLoaded: Boolean;                  {           Is Share loaded? }
                                                { -------------------------- }
Function CapsLock: Boolean;                     {           Is Caps Lock on? }
Function NumLock: Boolean;                      {         Is Number Lock on? }
Function ScrollLock: Boolean;                   {         Is Scroll Lock on? }
Function EnhKbd: Boolean;                       {         Enhanced keyboard? }
                                                { -------------------------- }
Function InitialVideoMode: Integer;             {  Return initial video mode }
Function OpModeCheck: Integer;                  { 0=DOS,1=WStd,2=WEnh,3=DESQ }
                                                { -------------------------- }
Function CoProcessorExist: Boolean;             { Is there a numeric co-pro? }
Function CPUType: LongInt;                      {  Return 8088 or 80?86 or 0 }
Function PrinterOnline: Boolean;                {     Is the printer online? }
Function SBDetected: Word;                      {  Return SBlaster port or 0 }
Function AdlibCard: Boolean;                    { Is an Adlib/cmptble there? }
Function GameIOAttached: Boolean;               {  Is game IO card attached? }
Function NumDisketteDrives: Integer;            {    Return # of disk drives }
Function NumPrinters: Word;                     {  Return number of printers }
                                                { -------------------------- }
Function LPTAddr(LPTX: Byte): Word;             {   Return base addr of LPTX }
Function BaseAddr(ComX: Byte): Word;            {   Return base addr of ComX }
Function NumSerialPorts: Integer;               {   Return # of serial ports }
Function PortInfo(ComX: Byte;                   {   Get info about port ComX }
                  Var DataBits,StopBits,Parity: Byte): Boolean;
Function PortRate(ComPort: Word;                {       Get baudrate of ComX }
                  Var Baud: LongInt): Boolean;
Function UART(ComX: Byte): String;              {   Return UART type on ComX }
                                                { -------------------------- }
Function DriveInfo(Var FAT,SerNo: LongInt): Boolean; { Drive Ser# & FAT Type }
Procedure CD_ROMData(Var DrvCount: Word;        {   Get info on CDROM/MSCDEX }
                     Var FirstDrv: Char;
                     Var IsMSCDEX, IsCDROM: Boolean);
Function NetworkDrive(Drive: Char;              {  Is Drive a network drive? }
                      Var DOSErrorCode: Word): Boolean;
                                                { -------------------------- }
Function TrueDosVer: Word;                      {           TRUE DOS version }
Function ResolvePath(Var S: String): Boolean;   {   Subst drive => Full path }
Function CountryData(Var Currency,              {           Get country info }
                         DateFormat: String;
                     Var Thousands,Decimal,DateSep,TimeSep,DataSep: Char;
                     Var CurrencyPlaces,TimeFormat: Byte): Boolean;

{$ENDIF}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Save Screen Records                                                        }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Type
 SaveScrRec = Record
   X,Y,TxtAttr: Byte;
   WndMin,WndMax: Word;
   Screen     : Array[1..4000] Of Byte;
  End;
Var
 Saved: Array[1..12] Of ^SaveScrRec;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ BIOS & CMOS Routines/Data                                                  }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Const
 FT12Hour   : Boolean = False;          { Make FormatTime return 12hour time }
 Read_StrLF : Boolean = True;           { Move down one line after Read_Str? }
 Read_StrMask: Boolean = False;         { Mask Read_Str input with *'s?      }
 RSMaskChar : Char = '*';               { Char to mask Read_Str input with   }
 Read_StrBG : Char = #32;               { Background char for Read_Str field }

 ThinCursor = $0707; { Thin cursor }
 OvrCursor  = $0307; { Overwrite cursor }
 InsCursor  = $0607; { Insert cursor (default) }
 BarCursor  = $000D; { Bar cursor }

Var
 CursorShape: Word;
 BiosDate : Array[0..7] of Char Absolute $F000:$FFF5; {     Date of the BIOS }
 EquipFlag: Word Absolute $0000:$0410;          { Equipment flag, used below }
 CompID   : Byte Absolute $F000:$FFFE;          {    Computer ID, used below }
 BiosSeg: Record                                                 { Absolute }
   ComBase               : Array[1..4] of Word;
   LptBase               : Array[1..4] of Word;
   InstalledHardware     : Array[1..2] of Byte;
   POST_Status           : Byte;                         { Convertible only }
   MemorySize            : Word;
   _RESERVED1            : Word;
   KeyboardControl       : Array[1..2] of Byte;
   AlternateKeypadEntry  : Byte;
   KeyboardBufferHeadPtr : Word;
   KeyboardBufferTailPtr : Word;
   KeyboardBuffer        : Array[1..16] of Word;
   FloppyRecalStatus     : Byte;
   FloppyMotorStatus     : Byte;
   FloppyMotorOffCounter : Byte;
   FloppyPrevOpStatus    : Byte;
   FloppyControllerStatus: Array[1..7] of Byte;
   DisplayMode           : Byte;
   NumberOfColumns       : Word;
   RegenBufferLength     : Word;
   RegenBufferAddress    : Word;
   CursorPosition        : Array[1..8] of Word;
   CursorType            : Word;
   CurrentDisplayPage    : Byte;
   VidControllerBaseAddr : Word;
   Current3x8Register    : Byte;
   Current3x9Register    : Byte;
   PointerToResetCode    : Pointer;           { PS/2 only - except model 30 }
   _RESERVED2            : Byte;
   TimerCounter          : Longint;
   TimerOverflowFlag     : Byte;     { non-zero means timer passed 24 hours }
   BreakKeyState         : Byte;
   ResetFlag             : Word;               { $1234: Bypass mem test     }
                                               { $4321: Preserve mem (PS/2) }
                                               { $5678: System supended*    }
                                               { $9ABC: Manufacturing test *}
                                               { $ABCD: System POST loop  **}
                                               { *=(Convertible), **=(only) }
   FixedDiskPrevOpStatus : Byte;
   NumberOfFixedDrives   : Byte;
   FixedDiskDriveControl : Byte;                                  { XT only }
   FixedDiskCntrllerPort : Byte;                                  { XT only }
   LptTimeOut            : Array[1..4] of Byte;  { [4] = PC, XT and AT only }
   ComTimeOut            : Array[1..4] of Byte;
   KbdBufferStartPtr     : Word;
   KbdBufferEndPtr       : Word;
   VideoRows             : Byte;
   CharacterHeight       : Word;                      { Bytes per character }
   VideoControlStates    : Array[1..2] of Byte;
   _RESERVED3            : Word;
   MediaControl          : Byte;
   FixedDiskCntrllerStat : Byte;          { AT, XT after 1/10/85, PS/2 only }
   FixedDiskCntrlrErrStat: Byte;          { AT, XT after 1/10/85, PS/2 only }
   FixedDiskInterruptCtrl: Byte;          { AT, XT after 1/10/85, PS/2 only }
   _RESERVED4            : Byte;
   DriveMediaState       : Array[0..1] of Byte;
   _RESERVED5            : Word;
   DriveCurrentCylinder  : Array[0..1] of Byte;
   KeyboardModeState     : Byte;
   KeyboardLEDflags      : Byte;
   UsrWaitCmpleteFlagAddr: Pointer;
   UserWaitCount         : Longint;                         { micro-seconds }
   WaitActiveFlag        : Byte;
   _RESERVED6            : Array[1..7] of Byte;
   VideoParameterTable   : Pointer;                     { EGA and PS/2 only }
   DynamicSaveArea       : Pointer;                     { EGA and PS/2 only }
   AlphaModeAuxCharGnrtor: Pointer;                     { EGA and PS/2 only }
   GfxModeAuxCharGnrator : Pointer;                     { EGA and PS/2 only }
   SecondarySaveArea     : Pointer;              { PS/2 only (not Model 30) }
   _RESERVED7            : Array[1..4] of Byte;
   _RESERVED8            : Array[1..64] of Byte;
   PrintScreenStatus     : Byte;
  End Absolute $0040:$0000;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  Implementation
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


Uses Crt;

Const
 OutRedir: Boolean = False;

Var
 Reg           : Registers;
 OldIntVect29  : Pointer;

Procedure CursorOn;
Begin
  Reg.Ax := 1 Shl 8;
  Reg.Cx := 6 Shl 8 + 7;
  Intr($10,Reg);
End;

Procedure CursorOff;
Begin
  Reg.Ax := 1 Shl 8;
  Reg.Cx := 14 Shl 8;
  Intr($10,Reg);
End;

Procedure Save_Screen;
Begin
 If Saved[11]<>Nil Then
  Begin
   GotoXY(19,12);
   TextAttr:=$07;
   Write(' Save_Screen ptr 11 not nil, cannot save! ');
   Halt;
  End;
 New(Saved[11]);
 With Saved[11]^ Do
  Begin
   X:=WhereX;
   Y:=WhereY;
   TxtAttr:=TextAttr;
   WndMin:=WindMin;
   WndMax:=WindMax;
   If (Mem[0000:$0449] = $7) Then
    Move(Mem[$b000:0000],Screen,SizeOf(Screen))
   Else
    Move(Mem[$b800:0000],Screen,SizeOf(Screen));
  End;
End;

Procedure Restore_Screen;
Begin
 If Saved[11]=Nil Then
  Begin
   GotoXY(18,12);
   TextAttr:=$07;
   Write(' Restore_Screen ptr 11 nil, cannot restore! ');
   Halt;
  End;
 With Saved[11]^ Do
  Begin
   If (Mem[0000:$0449] = $7) Then
    Move(Screen,Mem[$b000:0000],SizeOf(Screen))
   Else
    Move(Screen,Mem[$b800:0000],SizeOf(Screen));
   WindMin:=WndMin;
   WindMax:=WndMax;
   GotoXY(X,Y);
   TextAttr:=TxtAttr;
  End;
 Dispose(Saved[11]); Saved[11]:=Nil;
End;

Procedure Save_Screen2;
Begin
 If Saved[12]<>Nil Then
  Begin
   GotoXY(19,12);
   TextAttr:=$07;
   Write(' Save_Screen2 ptr 12 not nil, cannot save! ');
   Halt;
  End;
 New(Saved[12]);
 With Saved[12]^ Do
  Begin
   X:=WhereX;
   Y:=WhereY;
   TxtAttr:=TextAttr;
   WndMin:=WindMin;
   WndMax:=WindMax;
   If (Mem[0000:$0449] = $7) Then
    Move(Mem[$b000:0000],Screen,SizeOf(Screen))
   Else
    Move(Mem[$b800:0000],Screen,SizeOf(Screen));
  End;
End;

Procedure Restore_Screen2;
Begin
 If Saved[12]=Nil Then
  Begin
   GotoXY(18,12);
   TextAttr:=$07;
   Write(' Restore_Screen ptr 12 nil, cannot restore! ');
   Halt;
  End;
 With Saved[12]^ Do
  Begin
   If (Mem[0000:$0449] = $7) Then
    Move(Screen,Mem[$b000:0000],SizeOf(Screen))
   Else
    Move(Screen,Mem[$b800:0000],SizeOf(Screen));
   WindMin:=WndMin;
   WindMax:=WndMax;
   GotoXY(X,Y);
   TextAttr:=TxtAttr;
  End;
 Dispose(Saved[12]); Saved[12]:=Nil;
End;

Procedure SaveScreen(Idx: Byte);
Begin
 If (Idx>10) Or (Idx=0) {Or (Saved[Idx]<>Nil)} Then
  Begin
   GotoXY(19,12);
   TextAttr:=$07;
   Write(' Save_Screen ptr ',Idx,' out of range, cannot save! ');
   Halt;
  End;
 New(Saved[Idx]);
 With Saved[Idx]^ Do
  Begin
   X:=WhereX;
   Y:=WhereY;
   TxtAttr:=TextAttr;
   WndMin:=WindMin;
   WndMax:=WindMax;
   If (Mem[0000:$0449] = $7) Then
    Move(Mem[$b000:0000],Screen,SizeOf(Screen))
   Else
    Move(Mem[$b800:0000],Screen,SizeOf(Screen));
  End;
End;

Procedure RestoreScreen(Idx: Byte);
Begin
 If (Idx>10) Or (Idx=0) {Or (Saved[Idx]=Nil)} Then
  Begin
   GotoXY(18,12);
   TextAttr:=$07;
   Write(' Restore_Screen ptr ',Idx,' out of range, cannot restore! ');
   Halt;
  End;
 With Saved[Idx]^ Do
  Begin
   If (Mem[0000:$0449] = $7) Then
    Move(Screen,Mem[$b000:0000],SizeOf(Screen))
   Else
    Move(Screen,Mem[$b800:0000],SizeOf(Screen));
   WindMin:=WndMin;
   WindMax:=WndMax;
   GotoXY(X,Y);
   TextAttr:=TxtAttr;
  End;
 DIspose(Saved[Idx]); Saved[Idx]:=Nil;
End;

Procedure BigCursor; Assembler;
asm
    mov     ah,1
    mov     ch,1
    mov     cl,5
    int     10h
end;

Procedure SmallCursor; Assembler;
asm
    mov     ah,1
    mov     ch,4
    mov     cl,5
    int     10h
End;

Function InsStat: Boolean;
Begin
 InsStat:=(Mem[$0040:$0017] And 128 <> 0);
{
 CapsStat:=(Mem[$0040:$0017] And 64 <> 0);
 NumStat:=(Mem[$0040:$0017] And 32 <> 0);
 SlkStat:=(Mem[$0040:$0017] And 16 <> 0);
}
End;

Procedure SetIns(Assert: Boolean);
Begin
 { InsStat means non-block cursor }
 If Assert Then
   Mem[$0040:$0017]:=(Mem[$0040:$0017] Or 128);
 If (Not Assert) Then
   Mem[$0040:$0017]:=(Mem[$0040:$0017] And (Not 128));
End;

Procedure Read_Str(VAR Return: String; Max: Integer; Default: String);
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
     Write(MakeStr(Max,Read_StrBG));
     GotoXY(WhereX-Max,WhereY);
     StartPos:=WhereX;
     GotStr:=Default;
     If Read_StrMask Then Write(MakeStr(Length(Default),RSMaskChar)) Else Write(Default);
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
              Write(Copy(GotStr,Tmp-StartPos,255),Read_StrBG);
              GotoXY(Tmp-1,WhereY);
             End;
           End
           Else
           Begin
            Write(#8,Read_StrBG,#8);
            Delete(GotStr,Length(GotStr),1);
           End;
         End;
        If Ch=#25 Then
         Begin
          GotStr:='';
          GotoXY(StartPos,WhereY);
          For CharCount:=1 To Max Do
           Write(Read_StrBG);
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
                   Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),RSMaskChar))
                  Else
                   Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End
                 Else
                 Begin
                  Tmp:=WhereX+1;
                  GotStr[Tmp-StartPos]:=Ch;
                  If Read_StrMask Then
                   Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),RSMaskChar))
                  Else
                  Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End;
               End
               Else
               Begin
                If Read_StrMask Then Write(RSMaskChar) Else Write(Ch);
                GotStr:=GotStr+Ch;
               End;
             End;
           End;
         End;
        If Ch=#0 Then
         Begin
          Ch:=ReadKey;
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
               Write(MakeStr(Length(Copy(GotStr,Tmp-StartPos,255)),RSMaskChar))
              Else
               Write(Copy(GotStr,Tmp-StartPos,255),Read_StrBG);
              GotoXY(Tmp,WhereY);
             End
             Else
             Begin
              Tmp:=WhereX;
              Delete(GotStr,1,1);
              Write(GotStr,Read_StrBG);
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
     Return:=GotStr;
     If Read_StrLF Then WriteLn;
     Read_StrLF:=True;
     Read_StrMask:=False;
     SmallCursor;
End;

Procedure Read_Int(VAR WhatInt: LongInt; Maximum,Default: LongInt);
Var
 Ch: Char;
 RCount: Integer;
 WhatStr: String;
Begin
 WhatInt:=Default;
 WhatStr:=StrVal(WhatInt);
 Write(WhatStr);
 Repeat;
  Ch:=ReadKey;
  If (Ch=#8) And (WhatStr<>'') Then
   Begin
    GotoXY(WhereX-1,WhereY); Write(' '); GotoXY(WhereX-1,WhereY);
    Delete(WhatStr,Length(WhatStr),1);
   End;
  If (Ch<>#0) And (Ch<>#8) And (Ch<>#25) And (Ch<>#13) And
     (LIntVal(WhatStr+Ch)<=Maximum) And (Pos(Ch,'1234567890')>0) And (Not ((WhatStr='0') And (Ch='0'))) Then
   Begin
    Write(Ch);
    WhatStr:=WhatStr+Ch;
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
    WhatStr:=StrVal(Default);
    Ch:=#13;
   End;
  If Ch=#0 Then Ch:=ReadKey;
 Until Ch=#13;
 WhatInt:=LIntVal(WhatStr);
End;

Function Strip(WhatName: String): String;
Begin
 While Pos('\',WhatName)>0 Do
  Delete(WhatName,1,Pos('\',WhatName));
 Strip:=WhatName;
End;

Function RemoveWildcard(St: String): String;
Begin
 While (St[Length(St)]<>'\') And (St<>'') Do
  Delete(St,Length(St),1);
 RemoveWildcard:=St;
End;

Function FileExists(FN: String): Boolean;
var
 F: file;
begin
 Assign(F,FN);
 {$I-} Reset(F); Close(F); {$I+}
 FileExists := (IOResult = 0) and (FN <> '');
end;

Function Capitalize(S: String): String;
Var Tmp: Byte;
Begin
 For Tmp:=1 To Length(S) Do
  If Not (S[Tmp] in ['A'..'Z','a'..'z','''',#128..#165]) Then
   S[Tmp+1]:=UpCase(S[Tmp+1])
  Else
   S[Tmp+1]:=LoCase(S[Tmp+1]);
 If Pos('BBS',UCase(S))>0 Then
  Begin
   S[Pos('BBS',UCase(S))+0]:='B';
   S[Pos('BBS',UCase(S))+1]:='B';
   S[Pos('BBS',UCase(S))+2]:='S';
  End;
 S[1]:=UpCase(S[1]);
 Capitalize:=S;
End;

Function StrVal(IntNum: LongInt): String;
Var TS: String;
Begin
 Str(IntNum,TS);
 StrVal:=TS;
End;

Function IntVal(ChrStr: String): Integer;
Var TI: Integer;
    Code: Word;
Begin
 Val(ChrStr,TI,Code);
 If Code<>0 Then TI:=-1;
 IntVal:=TI;
End;

Function LIntVal(ChrStr: String): LongInt;
Var TI: LongInt;
    Code: Word;
Begin
 Val(ChrStr,TI,Code);
 If Code<>0 Then TI:=-1;
 LIntVal:=TI;
End;

Function LeadingZero(W: Word): String;
Var S: String;
Begin
 Str(W:0,S);
 If Length(S)=1 then S:='0'+S;
 LeadingZero:=S;
End;

Function Extension(Filename: String): String;
Begin
 If Pos('.',Filename) >0 Then
  Delete(Filename,1,Pos('.',Filename))
 Else
  FileName:='';
 Extension:=Filename;
End;

Function UCase(UpString: String): String;
Var LtrNum: Integer;
Begin
 LtrNum:=0;
 For LtrNum:=1 To Length(UpString) do
  UpString[LtrNum]:=UpCase(UpString[LtrNum]);
 UCase:=UpString;
End;

Function LoCase(C: Char): Char;
Begin
 If C in ['A'..'Z'] Then C:=Chr(Ord(C)+32);
 LoCase:=C;
End;

Function LCase(UpString: String): String;
Var LtrNum: Integer;
Begin
 LtrNum:=0;
 For LtrNum:=1 To Length(UpString) do
  UpString[LtrNum]:=LoCase(UpString[LtrNum]);
 LCase:=UpString;
End;

Function Backwards(Forwards: String): String;
Var
 OutStr: String;
 Count : Integer;
Begin
 OutStr:='';
 For Count:=Length(Forwards) DownTo 1 Do
  OutStr:=OutStr+Forwards[Count];
 Backwards:=OutStr;
End;

Function Pad(St: String; I: Integer): String;
Var C: Integer;
Begin
 For C:=1 To I-Length(St) Do St:=St+' ';
 Pad:=St;
End;

Function FPad(St: String; I: Integer): String;
Var C: Integer;
Begin
 For C:=1 To I-Length(St) Do St:=' '+St;
 FPad:=St;
End;

Function LTrim(WhatStr: String): String;
Begin
 While (WhatStr[1]=' ') And (WhatStr<>'') Do
  Delete(WhatStr,1,1);
 LTrim:=WhatStr;
End;

Function Copy1(S: String; Len: Byte): String;
Begin
 If Len<Length(S) Then S[0]:=Chr(Len);
 Copy1:=S;
End;

Function RTrim(WhatStr: String): String;
Begin
 While (WhatStr[Length(WhatStr)]=' ') And (WhatStr<>'') Do
  Delete(WhatStr,Length(WhatStr),1);
 RTrim:=WhatStr;
End;

Function Timer: Real;
Begin
 Timer:=MemL[$0040:$006C]/18.2065;
End;

Procedure CDelay(D: Word);
Var CTime: Real;
Begin
 CTime:=Timer+(D / 1000);
 Repeat Until Timer>=CTime;
End;

Procedure SetCLk(Assert: Boolean);
Begin
 If Assert Then
  Mem[$0000:$0417]:=Mem[$0000:$0417] Or 64
 Else
  Mem[$0000:$0417]:=Mem[$0000:$0417] And Not 64
End;

Procedure SetSLk(Assert: Boolean);
Begin
 If Assert Then
  Mem[$0000:$0417]:=Mem[$0000:$0417] Or 16
 Else
  Mem[$0000:$0417]:=Mem[$0000:$0417] And Not 16
End;

Procedure SetNLk(Assert: Boolean);
Begin
 If Assert Then
  Mem[$0000:$0417]:=Mem[$0000:$0417] Or 32
 Else
  Mem[$0000:$0417]:=Mem[$0000:$0417] And Not 32
End;

Function FormatTime(Rl:Real):String;
Var H,M,S:String;

Function Tch(I:String):String;
Begin
  If Length(I)>2 Then I:=Copy(I,Length(I)-1,2) Else
    If Length(I)=1 Then I:='0'+I;
  Tch:=I;
End;

Function Cstr(I:Longint):String;
Var C:String;
Begin
  Str(I,C); Cstr:=C;
End;

Begin
  S:=Tch(Cstr(Trunc(Rl-Int(Rl/60.0)*60.0)));
  M:=Tch(Cstr(Trunc(Int(Rl/60.0)-Int(Rl/3600.0)*60.0)));
  H:=Tch(Cstr(Trunc(Rl/3600.0)));
  If FT12Hour Then
   Begin
    If IntVal(H)>12 Then
     Begin H:=StrVal(IntVal(H)-12); S:=S+'p'; End
    Else
    Begin
     If IntVal(H)=0 Then H:='12';
     S:=S+'a';
    End;
    FT12Hour:=False;
   End;
  If Length(H)=1 Then H:='0'+H;
  FormatTime:=H+':'+M+':'+S;
End;

Function MakeStr(Len: Byte; MCh: Char): String;
Var MC: Integer;
    Out: String;
Begin
 FillChar(Out,SizeOf(Out),MCh);
 Out[0]:=Chr(Len);
 MakeStr:=Out;
End;

Procedure RTC_Delay(microsecs:longint); { 1000000 microsecs = 1 second}
var r : registers;
begin
 r.ah := $86;                           {RTC function number}
 r.cx := microsecs shr 16;              {cx:dx = # of microseconds}
 r.dx := microsecs and $FFFF;
 intr($15,r);                           {call INT 15h (RTC)}
end;

Function CommaFmt(Value: LongInt): String;
const
  s: byte = 0;
var
  TS: String;
  W: string[20];
  i: byte;
  d: byte;
  N: Boolean;
begin
  TS:=StrVal(Value);
  W:=TS;
  N:=False;
  if W[1] = '-' then Begin Delete(W,1,1); N:=True; End;
  d := Length(W);
  for i := 3 to (d-1-s) do
    if i mod 3 = 0 then
      Insert(',',W,(d-I+1+s));
 IF N Then W:='-'+W;
 TS:=W;
 CommaFmt:=TS;
end;

Function Zero(I: LongInt; Z: Byte): String;
Var S: String;
Begin
 S:=StrVal(I);
 While Length(S)<Z Do S:='0'+S;
 Zero:=S;
End;

Function ZeroS(S: String; Z: Byte): String;
Begin
 While Length(S)<Z Do S:='0'+S;
 ZeroS:=S;
End;

Procedure ZWrite(C: Char); Assembler;
Asm
    mov     bh,0
    mov     bl,TextAttr
    mov     cx,1
    mov     al,C
    mov     ah,9
    int     10h
End;

Function HexW(I: Word): String;
Const
  hc : Array[0..15] of Char = '0123456789ABCDEF';
Var
  Out1,Out2,Out3,Out4: Byte;
Begin
 Out1:=0; Out2:=0; Out3:=0; Out4:=0;
 Asm
     mov     ax,I
     mov     bx,ax

     shr     ah,04h
     mov     out1,ah

     mov     ax,bx
     and     ah,0Fh
     mov     out2,ah

     shr     al,04h
     mov     out3,al

     mov     ax,bx
     and     al,0Fh
     mov     out4,al
   End;
  HexW:=hc[Out1]+hc[Out2]+hc[Out3]+hc[Out4];
End {Hex} ;

Function Hex(L:LongInt):String;
Const
 HexDigits : ARRAY[0..16] OF Char = '0123456789ABCDEF';
Var T: String[8];
Begin
 T:=HexDigits[(L SHR 28) AND $F];
 T:=T+HexDigits[(L SHR 24) AND $F];
 T:=T+HexDigits[(L SHR 20) AND $F];
 T:=T+HexDigits[(L SHR 16) AND $F];
 T:=T+HexDigits[(L SHR 12) AND $F];
 T:=T+HexDigits[(L SHR 08) AND $F];
 T:=T+HexDigits[(L SHR 04) AND $F];
 T:=T+HexDigits[L AND $F];
 Hex:=T;
End;

Function HexZ(L:LongInt):String;
Const
 HexDigits : ARRAY[0..16] OF Char = '0123456789ABCDEF';
Var T: String[8];
Begin
 T:=HexDigits[(L SHR 28) AND $F];
 T:=T+HexDigits[(L SHR 24) AND $F];
 T:=T+HexDigits[(L SHR 20) AND $F];
 T:=T+HexDigits[(L SHR 16) AND $F];
 T:=T+HexDigits[(L SHR 12) AND $F];
 T:=T+HexDigits[(L SHR 08) AND $F];
 T:=T+HexDigits[(L SHR 04) AND $F];
 T:=T+HexDigits[L AND $F];
 While (T[1]='0') And (Length(T)>0) Do Delete(T,1,1);
 HexZ:=T;
End;

Function GetChar: Char; Assembler;
Asm
    mov     ah,8
    mov     bh,0
    int     10h
End;

Function GetAttr: Byte; Assembler;
Asm
    mov     ah,8
    mov     bh,0
    int     10h
    mov     al,ah
End;

  procedure StuffKey(W : Word);
    {-Stuff one key into the keyboard buffer}
  const
    KbdStart = $1E;
    KbdEnd = $3C;
  var
    SaveKbdTail : Word;
    KbdHead : Word absolute $40 : $1A;
    KbdTail : Word absolute $40 : $1C;
  begin
    SaveKbdTail := KbdTail;
    if KbdTail = KbdEnd then
      KbdTail := KbdStart
    else
      Inc(KbdTail, 2);
    if KbdTail = KbdHead then
      KbdTail := SaveKbdTail
    else
      MemW[$40:SaveKbdTail] := W;
  end;

Procedure FillScr(C: Char; A: Byte);
Type
  Scr = Array[1..2000] Of Record
          Character: Char;
          Attribute: Byte;
         End;
Var
 ScrBuff: ^Scr;
 WorkScr: ^Scr;
 Tmp: Word;
Begin
  If (Mem[0000:$0449] = $7) Then
   ScrBuff := Ptr($B000,0000)
  Else
   ScrBuff := Ptr($B800,0000);
  New(WorkScr);
  For Tmp:=1 To 2000 Do
   Begin WorkScr^[Tmp].Character:=C; WorkScr^[Tmp].Attribute:=A; End;
  Move(WorkScr^,ScrBuff^,SizeOf(WorkScr^));
  Dispose(WorkScr);
End;

Procedure CallProc(UserProc: Pointer);
Begin
 InLine($FF/$1E/UserProc);
End;

Procedure Set25Lines;
Var
 Regs: Registers;
Begin
 Regs.AX:=$1111;
 Regs.BX:=0;
 Intr($10,Regs);
 Mem[$0040:$0087]:=Mem[$0040:$0087] Or $01;
 Regs.AX:=$0100;
 Regs.BX:=0;
 Regs.CX:=$0C00;
 Intr($10,Regs);
End;

Procedure WarmBoot;
Begin
 Inline(
        $FB/                  { STI                                  }
        $B8/00/00/            { MOV   AX,0000                        }
        $8E/$D8/              { MOV   DS,AX                          }
        $B8/$34/$12/          { MOV   AX,1234                        }
        $A3/$72/$04/          { MOV   [0472],AX                      }
        $EA/$00/$00/$FF/$FF); { JMP   FFFF:0000                      }
End;

Procedure ColdBoot;
Begin
 Inline(
        $FB/                  { STI                                  }
        $B8/01/00/            { MOV   AX,0001                        }
        $8E/$D8/              { MOV   DS,AX                          }
        $B8/$34/$12/          { MOV   AX,1234                        }
        $A3/$72/$04/          { MOV   [0472],AX                      }
        $EA/$00/$00/$FF/$FF); { JMP   FFFF:0000                      }
End;

Procedure Drive_Light_On(Drive: Char);
Begin { Remember to wait about a half second before trying to read! }
 If UpCase(Drive) in ['A','B'] Then Port[$3F2]:=12+(Ord(Drive)-65)+1 SHL (4+(Ord(Drive)-65));
End;

Procedure Drive_Light_Off(Drive: Char);
Begin
 If UpCase(Drive) in ['A','B'] Then Port[$3F2]:=12+(Ord(Drive)-65);
End;

Procedure HighIntensity(SetHi: Boolean);
Var Regs: Registers;
Begin
 Regs.AX:=$1003;
 Regs.BX:=Byte(Not SetHi);
 Intr($10,Regs);
End;

Function PeekKey: Char;
Var Head: Word ABSOLUTE $0040:$001A;
Begin
 PeekKey:=Char(Mem[$40:Head]);
End;

Procedure SetPrtScr(Assert: Boolean);
Begin If Assert Then Mem[$0050:0000] := 0 Else  Mem[$0050:0000] := 1; End;

Function SetOutput(FileName: String): Boolean;
Begin
 FileName:=FileName+#0;
 SetOutput:=False;
 Asm
     push  ds
     mov   ax, ss
     mov   ds, ax
     lea   dx, FileName[1]
     mov   ah, 3Ch
     int   21h
     pop   ds
     jnc   @@1
     ret
@@1:
     push  ax
     mov   bx, ax
     mov   cx, Output.FileRec.Handle
     mov   ah, 46h
     int   21h
     mov   ah, 3Eh
     pop   bx
     jnc   @@2
     ret
@@2:
     int   21h
  End;
 OutRedir:=True;
 SetOutput:=True;
End;

Procedure CancelOutput;
Var
 FileName: String[4];
Begin
 If not OutRedir Then Exit;
 FileName:='CON'#0;
 Asm
     push  ds
     mov   ax, ss
     mov   ds, ax
     lea   dx, FileName[1]
     mov   ax, 3D01h
     int   21h
     pop   ds
     jnc   @@1
     ret
@@1:
     push  ax
     mov   bx, ax
     mov   cx, Output.FileRec.Handle
     mov   ah, 46h
     int   21h
     mov   ah, 3Eh
     pop   bx
     int   21h
  End;
 OutRedir:=False;
End;

Function FormatDate(L: LongInt; UseCInfo: Boolean): String;
Var DT: DateTime;
    S: String; C: Char; B: Byte;
    DFmt: String;
Begin
 UnpackTime(L,DT);
{$IFDEF SysInfo}
 If Not UseCInfo Then
  DFmt:='mm/dd/yy'  {mm/dd/yy}
 Else
 Begin
  If Not CountryData(S,DFmt,C,C,C,C,C,B,B) Then DFmt:='mm/dd/yy';
 End;
{$ELSE}
  DFmt:='mm/dd/yy';
{$ENDIF}
 B:=Pos('mm',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Month),DFmt,B);
 B:=Pos('dd',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Day),DFmt,B);
 B:=Pos('yy',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Year-1900),DFmt,B);
 Delete(DFmt,7,1);
 FormatDate:=DFmt;
End;

(*
Function FormatDate(L: LongInt; UseCInfo: Boolean): String;
Var DT: DateTime;
    S: String; C: Char; B: Byte;
    DFmt: String;
Begin
 UnpackTime(L,DT);
{$IFDEF SysInfo}
 If Not UseCInfo Then
  DFmt:='mm/dd/yy'
 Else
 Begin
  If Not CountryData(S,DFmt,C,C,C,C,C,B,B) Then DFmt:='mm/dd/yy';
 End;
{$ELSE}
  DFmt:='mm/dd/yy';
{$ENDIF}
 B:=Pos('mm',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Month),DFmt,B);
 B:=Pos('dd',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Day),DFmt,B);
 B:=Pos('yy',DFmt); Delete(DFmt,B,2); Insert(LeadingZero(DT.Year-1900),DFmt,B);
 FormatDate:=DFmt;
End;
*)

Function HexPtr(P : Pointer) : String;
  {-Return hex string for pointer}
Type
 OS=Record
     O,S: Word;
    End;

Begin
  HexPtr := HexW(OS(P).S)+':'+HexW(OS(P).O);
End;

Function FileOpen(Var F): Boolean;
Var FileInfo: FileRec Absolute F;
Begin
 FileOpen:=FileInfo.Mode And FMClosed <> 0;
End;

Function Gregorian(Julian: LongInt): String;
Var
 Temp,XYear: LongInt;
 YYear,YMonth,YDay: Integer;
Begin
 Temp:=(((Julian-1721119) Shl 2)-1);
 XYear:=(Temp Mod 146097) Or 3;
 Julian:=Temp Div 146097;
 YYear:=(XYear Div 1461);
 Temp:=((((XYear Mod 1461)+4) Shr 2)*5)-3;
 YMonth:=Temp Div 153;
 If YMonth>=10 Then Begin Inc(YYear); Dec(YMonth,12); End;
 Inc(YMonth,3);
 YDay:=Temp Mod 153;
 YDay:=(YDay+5) Div 5;
 Gregorian:=LeadingZero(YMonth)+'/'+LeadingZero(YDay)+'/'+LeadingZero(YYear);
End;

Function Julian(DT: String): Longint;             { MM/DD/YY -> Julian Date }
Var
 Temp,Y,M,D: Longint;
 Code: Word;
Begin
 Val(Copy(DT,7,2),Y,Code);
 Val(Copy(DT,1,2),M,Code);
 Val(Copy(DT,4,2),D,Code);
 If (Y<0) Or (Not (M in [1..12])) Or (Not (D in [1..31])) Then
  Begin
   Julian:=-1;
   Exit;
  End;
 Y:=Y+1900;
 Temp:=(M-14) Div 12;
 Julian:=D-32075+(1461*(Y+4800+Temp) Div 4)+(367*(M-2-Temp*12) Div 12)-
         (3*((Y+4900+Temp) Div 100) Div 4);
End;


Function PackedDT(MMDDYYHHMMSS: String; DT: DateTime; UseDT: Boolean): LongInt;
Var L: LongInt;
Begin
 If Not UseDT Then
  Begin
   DT.Month:=IntVal(Copy(MMDDYYHHMMSS,1,2)); Delete(MMDDYYHHMMSS,1,3);
   DT.Day:=IntVal(Copy(MMDDYYHHMMSS,1,2)); Delete(MMDDYYHHMMSS,1,3);
   DT.Year:=IntVal(Copy(MMDDYYHHMMSS,1,2)); Delete(MMDDYYHHMMSS,1,3);
   DT.Hour:=IntVal(Copy(MMDDYYHHMMSS,1,2)); Delete(MMDDYYHHMMSS,1,3);
   DT.Min:=IntVal(Copy(MMDDYYHHMMSS,1,2)); Delete(MMDDYYHHMMSS,1,3);
   DT.Sec:=IntVal(Copy(MMDDYYHHMMSS,1,2));
  End;
 PackTime(DT,L);
 PackedDT:=L;
End;

Function UnpackedDT(L: LongInt): String;
Var DT: DateTime;
Begin
 UnPackTime(L,DT);
 UnpackedDT:=LeadingZero(DT.Month)+'/'+LeadingZero(DT.Day)+'/'+LeadingZero(DT.Year-1900)+
            ' '+LeadingZero(DT.Hour)+':'+LeadingZero(DT.Min)+':'+LeadingZero(DT.Sec);
End;

Function CurrentDT: LongInt;
Var DT: DateTime;
    W: Word;
    L: LongInt;
Begin
 GetDate(DT.Year,DT.Month,DT.Day,W);
 GetTime(DT.Hour,DT.Min,DT.Sec,W);
 PackTime(DT,L);
 CurrentDT:=L;
End;

Procedure SetCursor(CursorFlag: Boolean); assembler;
Asm
    cmp CursorFlag,True
    jne @@2
    cmp byte ptr [LastMode],Mono
    je  @@1
    mov cx,CursorShape  { Switch on cursor using the default shape }
    jmp @@4
@@1:
    mov cx,0B0Ch  { Switch on mono cursor }
    jmp @@4
@@2:
    cmp byte ptr [LastMode],Mono
    je  @@3
    mov cx,2000h  { Switch off cursor }
    jmp @@4
@@3:
    xor cx,cx     { Switch off mono cursor }
@@4:
    mov ah,01h
    xor bh,bh
    int 10h
End;

Function GetCursorType: Word;
Begin
 GetCursorType:=MemW[Seg0040:$0060]
End;

Function SetCursorType(Shape: Word): Word; Assembler;
Asm
    mov ax,CursorShape { save old value }
    mov bx,Shape
    cmp byte ptr [LastMode],Mono
    jne @@1
    xor bx,bx { Switch off mono cursor }
@@1:
    mov CursorShape,BX
End;

Function VSeg: Word;
Begin
 If (Mem[0000:$0449] = $7) Then VSeg:=$B000 Else VSeg:=$B800;
End;


{$IFDEF SysInfo}
Function AnsiSysLoaded: Boolean;
Var
 _AX : Word;
 Regs: Registers;
Begin
 Regs.AX:=$1a00;
 Intr($2f,Regs);
 _Ax:=Regs.AX;
 ANSISysLoaded:=(Lo(_AX)=$FF);
End;

Function DblLoaded: Boolean;
Var R: Registers;
Begin
 With R Do
  Begin
   AX:=$4A11;
   BX:=$0000;
  End;
 Intr($2F,R);
 DblLoaded:=(R.BX=$444D);
End;

Function x4DOSLoaded: Boolean;
Var R: Registers;
Begin
 With R Do
  Begin
   AX:=$D44D;
   BX:=$0000;
  End;
 Intr($2F,R);
 x4DOSLoaded:=(R.AX=$44DD);
End;

Function ShareLoaded: Boolean;
Var R: Registers;
Begin
 With R Do
  Begin
   AH:=$5C;
   AL:=$01;
  End;
 Intr($21,R);
 ShareLoaded:=((R.Flags And FCarry)=FCarry) And (R.AX<>$01);
End;

Function EnhKbd: Boolean; Assembler;
Asm
    push ds
    mov  ax,40h
    mov  ds,ax
    mov  ah,byte ptr [96h]
    pop ds
    and  ah,16
    mov  al,1
    cmp  ah,16
    je   @@1
    mov  al,0
@@1:
End;

Function NumLock: Boolean; Assembler;
Asm
    push ds
    mov  ax,40h
    mov  ds,ax
    mov  al,byte ptr [17h]
    pop ds
    and  al,32
End;

Function ScrollLock: Boolean; Assembler;
Asm
    push ds
    mov  ax,40h
    mov  ds,ax
    mov  al,byte ptr [17h]
    pop ds
    and  al,16
End;

Function CapsLock: Boolean; Assembler;
Asm
    push ds
    mov  ax,40h
    mov  ds,ax
    mov  al,byte ptr [17h]
    pop ds
    and  al,64
End;

Function SBDetected: Word;
Var xbyte1, xbyte2, xbyte3, xbyte4: Byte;
  xword, xword1, xword2, temp, sbport: Word;
  sbfound, portok: Boolean;
Begin
  sbfound:=False;
  xbyte1:=1;
  While (xbyte1 < 7) And (Not sbfound) Do
  Begin
    sbport:=$200 + ($10 * xbyte1);
    xword1:=0;
    portok:=False;
    While (xword1 < $201) And (Not portok) Do
    Begin
      If (Port[sbport + $0C] And $80) = 0 Then
        portok:=True;
      Inc(xword1)
    End;
    If portok Then
    Begin
      xbyte3:=Port[sbport + $0C];
      Port[sbport + $0C]:=$D3;
      For xword2:=1 To $1000 Do {nothing};
      xbyte4:=Port[sbport + 6];
      Port[sbport + 6]:=1;
      xbyte2:=Port[sbport + 6];
      xbyte2:=Port[sbport + 6];
      xbyte2:=Port[sbport + 6];
      xbyte2:=Port[sbport + 6];
      Port[sbport + 6]:=0;
      xbyte2:=0;
      Repeat
        xword1:=0;
        portok:=False;
        While (xword1 < $201) And (Not portok) Do
        Begin
          If (Port[sbport + $0E] And $80) = $80 Then
            portok:=True;
          Inc(xword1)
        End;
        If portok Then
          If Port[sbport + $0A] = $AA Then
            sbfound:=True;
        Inc(xbyte2);
      Until (xbyte2 = $10) Or (portok);
      If Not portok Then
      Begin
        Port[sbport + $0C]:=xbyte3;
        Port[sbport + 6]:=xbyte4;
      End;
    End;
    If sbfound Then
    Begin
    End
    Else
      Inc(xbyte1);
  End;
 If SBFound Then SBDetected:=SBPort Else SBDetected:=0;
End;

{  For CPU Detection...  }

Const CPU_8088    =  8088;
      CPU_80186   = 80186;
      CPU_80286   = 80286;
      CPU_80386   = 80386;
      CPU_80486   = 80486;
      CPU_UNKNOWN =     0;

Var
 CPU: LongInt;
 OldIntr6Handler: Procedure;
 Valid_Op_Code: Boolean;

 Procedure Intr6Handler; Interrupt;
 Begin
  Valid_Op_Code:=False;
  asm
    add word ptr ss:[bp + 18], 3
  end;
 End;

 Function Isa8088: Boolean;
 Var sp1, sp2 : word;
 Begin
  asm
    mov sp1, sp
    push sp
    pop sp2
  end;
  If sp1<>sp2 Then
   Isa8088:=True
  Else
   Isa8088:=False;
 End;

 Function Isa80186: Boolean;
 Begin
  if Isa8088 Then
   Isa80186:=False
  Else
  Begin
   Valid_Op_Code:=True;
   GetIntVec(6, @OldIntr6Handler);
   SetIntVec(6, Addr(Intr6Handler));
   inline($C1/$E2/$05);  { shl dx, 5 }
   SetIntVec(6, @OldIntr6Handler);
   Isa80186:=Valid_Op_Code;
  End;
 End;

 Function Isa80286: Boolean;
 Begin
  If Isa8088 Then
   Isa80286:=False
  Else
  Begin
   Valid_Op_Code:=True;
   GetIntVec(6, @OldIntr6Handler);
   SetIntVec(6, Addr(Intr6Handler));
   inline($0F/$01/$E2);  { smsw dx }
   SetIntVec(6, @OldIntr6Handler);
   Isa80286:=Valid_Op_Code;
  End;
 End;

 Function Isa80386: Boolean;
 Begin
  If Isa8088 Then
   Isa80386:=False
  Else
  Begin
   Valid_Op_Code:=True;
   GetIntVec(6, @OldIntr6Handler);
   SetIntVec(6, Addr(Intr6Handler));
   inline($0F/$20/$C2);  { mov edx, cr0 }
   SetIntVec(6, @OldIntr6Handler);
   Isa80386:=Valid_Op_Code;
  End;
 End;

 Function Isa80486: Boolean;
 Begin
  If Isa8088 Then
   Isa80486:=False
  Else
  Begin
   Valid_Op_Code:=True;
   GetIntVec(6, @OldIntr6Handler);
   SetIntVec(6, Addr(Intr6Handler));
   inline($0F/$C1/$D2);  { xadd dx, dx }
   SetIntVec(6, @OldIntr6Handler);
   Isa80486:=Valid_Op_Code;
  End;
 End;


Function CPUType: LongInt;
Begin
 If Isa8088 Then
  CPU:=CPU_8088
 Else If Isa80486 Then
  CPU:=CPU_80486
 Else If Isa80386 Then
  CPU:=CPU_80386
 Else If Isa80286 Then
  CPU:=CPU_80286
 Else If Isa80186 Then
  CPU:=CPU_80186
 Else
  CPU:=CPU_UNKNOWN;
 CPUType:=CPU;
End;

Function DVLoaded: Boolean;
Var
  R : Registers;
  VersionMj, VersionMn : byte;
  installed : boolean;

Begin
  installed := false;
  With R do
  Begin
    ah := $2B;
    cx := $4445; {'DE'}
    dx := $5351; {'SQ'}
    al := $01;   {sub func for get version}
    MsDos(R);
    if al = $FF then installed := False
    else
      begin
        installed := true;
        VersionMj := bh; VersionMn := bl
      end
  end;
  DVLoaded:=Installed;
End;

Function WinLoaded: Boolean;
Var
  R : Registers;
  StatusAL: Byte;
Begin
  R.ax:=$1600;
  Intr($2F,r);
  statusAL := r.al;
  WinLoaded:=(StatusAL<>0);
End;

Function OS2Loaded: Boolean;
Var R: Registers;
    Tmp: Integer;
    St: String;
Begin
 With R Do
  Begin
   ah:=$64;
   dx:=$8;
   cx:=$636C;
   bx:=$0;
  End;
 Intr($21,R);
 St:='';
 For Tmp:=1 To 8 Do
  St:=St+Chr(Mem[R.DS:R.DX+Tmp-1]);
 OS2Loaded:=(St='Loading.');
End;

Function CountryData(Var Currency,DateFormat: String;                     {|}
                     Var Thousands,Decimal,DateSep,TimeSep,DataSep: Char; {|}
                     Var CurrencyPlaces,TimeFormat: Byte): Boolean;       {|}
                                                                          {|}
Const                                                                     {|}
 Date_USA    = 0; { mm+dd+yy }                                            {|}
 Date_Europe = 1; { dd+mm+yy }                                            {|}
 Date_Japan  = 2; { yy+mm+dd }                                            {|}
 Time_12Hour = 0;                                                         {|}
 Time_24Hour = 1;                                                         {|}
                                                                          {|}
Type                                                                      {|}
 CountryInfo = Record                                                     {|}
        ciDateFormat    : Word;                                           {|}
        ciCurrency      : Array [1..5] Of Char;                           {|}
        ciThousands     : Char;                                           {|}
        ciASCIIZ_1      : Byte;                                           {|}
        ciDecimal       : Char;                                           {|}
        ciASCIIZ_2      : Byte;                                           {|}
        ciDateSep       : Char;                                           {|}
        ciASCIIZ_3      : Byte;                                           {|}
        ciTimeSep       : Char;                                           {|}
        ciASCIIZ_4      : Byte;                                           {|}
        ciBitField      : Byte;                                           {|}
        ciCurrencyPlaces: Byte;                                           {|}
        ciTimeFormat    : Byte;                                           {|}
        ciCaseMap       : Procedure;                                      {|}
        ciDataSep       : Char;                                           {|}
        ciASCIIZ_5      : Byte;                                           {|}
        ciReserved      : Array [1..10] Of Byte                           {|}
       End;                                                               {|}
Var                                                                       {|}
 Country: CountryInfo;                                                    {|}
                                                                          {|}
Function GetCountryInfo(Buf: Pointer): Boolean; Assembler;                {|}
Asm                                                                       {|}
    mov  ax, 3800h                                                        {|}
    push ds                                                               {|}
    lds  dx, Buf                                                          {|}
    int  21h                                                              {|}
    mov  al, TRUE                                                         {|}
    jnc  @@1                                                              {|}
    xor  al, al                                                           {|}
@@1:                                                                      {|}
    pop  ds                                                               {|}
End;                                                                      {|}
                                                                          {|}
Begin                                                                     {|}
 If Not GetCountryInfo (@Country) Then                                    {|}
  Begin                                                                   {|}
   Country.ciDateFormat:=DATE_USA;                                        {|}
   Country.ciDateSep:='-';                                                {|}
   Country.ciTimeFormat:=TIME_12HOUR;                                     {|}
   Country.ciTimeSep:=':';                                                {|}
   CountryData:=False;                                                    {|}
  End;                                                                    {|}
 Currency:=Country.ciCurrency[1]+Country.ciCurrency[2]+                   {|}
           Country.ciCurrency[3]+Country.ciCurrency[4]+                   {|}
           Country.ciCurrency[5];                                         {|}
 Thousands:=Country.ciThousands;                                          {|}
 Decimal:=Country.ciDecimal;                                              {|}
 DateSep:=Country.ciDateSep;                                              {|}
 TimeSep:=Country.ciTimeSep;                                              {|}
 DataSep:=Country.ciDataSep;                                              {|}
                                                                          {|}
 Case Country.ciDateFormat Of                                             {|}
   Date_USA   : DateFormat:='mm'+DateSep+'dd'+DateSep+'yy';               {|}
   Date_Europe: DateFormat:='dd'+DateSep+'mm'+DateSep+'yy';               {|}
   Date_Japan : DateFormat:='yy'+DateSep+'mm'+DateSep+'dd';               {|}
  End;                                                                    {|}
 Case Country.ciTimeFormat Of                                             {|}
   Time_12Hour: TimeFormat:=12;                                           {|}
   Time_24Hour: TimeFormat:=24;                                           {|}
  End;                                                                    {|}
 CurrencyPlaces:=Country.ciCurrencyPlaces;                                {|}
 CountryData:=True;                                                       {|}
End;                                                                      {|}

Function ResolvePath(Var S: String): Boolean;
Var
  R: Registers;
  X: Byte;
Begin
 ResolvePath:=False;
 S:=S+#0;
 R.DS:=Seg(S);
 R.SI:=Ofs(S)+1;
 R.ES:=Seg(S);
 R.DI:=Ofs(S)+1;
 R.AH:=$60;
 Intr($21,R);
 If R.Flags And 1 = 1 Then
  Exit; { If ZF set then error }
 ResolvePath:=True;
 X:=0;
 While (s[x+1]<>#0) And (x<128) Do
  Inc(X);
 S[0]:=Chr(X);
End;

Function DriveInfo(Var FAT,SerNo: LongInt): Boolean;
Var
 Regs     : Registers;
 LabelInfo: Record
       InfoLevel      : Word;
       SerialNum      : LongInt;
       VolumeLabel    : Array [1..11] of Char;
       FileSystemType : Array [1..8] of Char;
     end;
Begin
 If Lo(DosVersion)<4 Then Begin DriveInfo:=False; Exit; End;
 LabelInfo.InfoLevel := 0;
 With Regs do
  Begin
   AX:=$6900;           { Function $69 With 0 in AL gets, With 1 in AL sets}
   BL:=0;               { Drive, 0 For default, 1 For A:, 2 For B:, ...    }
   DS:=Seg(LabelInfo);  { DS:DX points at structure                        }
   DX:=Ofs(LabelInfo);
   ES:=0;               { Do not have garbage in segment Registers         }
   Flags:=0;            { or in flags                                      }
   MsDos(Regs);
   If Odd(Flags) Then Begin DriveInfo:=False; Exit; End;
  End;
 FAT:=IntVal(Copy(LabelInfo.FileSystemType,4,2));
 SerNo:=LabelInfo.SerialNum;
End;

Procedure CD_ROMData(Var DrvCount: Word; Var FirstDrv: Char;
                     Var IsMSCDEX, IsCDROM: Boolean);
Var Reg : Registers;
Begin
 FirstDrv  := #0;
 IsMSCDEX  := FALSE;
 IsCDROM   := FALSE;
 Reg.AX := $1500;
 Reg.BX := 0;
 Intr ($2F, Reg);                { invoke MSCDEX               }
 DrvCount := Reg.BX;
 IF (DrvCount = 0) THEN EXIT;
 FirstDrv := CHR (Reg.CX + 65);  { first drive IN ['A'..'Z']   }
 Reg.AX := $150B;                { fn: CD-ROM drive check      }
 Reg.BX := 0;                    { Reg.CX already has drive #  }
 Intr ($2F, Reg);
 IF (Reg.BX <> $ADAD) THEN EXIT; { MSCDEX isn't installed      }
 IsMSCDEX := TRUE;
 IF (Reg.AX = 0) THEN EXIT;      { ext. drive isn't a CD-ROM   }
 IsCDROM := TRUE;
End;

Function CoProcessorExist: Boolean;
Begin CoProcessorExist:=(EquipFlag And 2)=2; End;

Function NumPrinters: Word;
Begin NumPrinters:=EquipFlag Shr 14; End;

Function GameIOAttached: Boolean;
Begin GameIOAttached:=(EquipFlag And $1000)=1; End;

Function NumSerialPorts: Integer;
Begin NumSerialPorts:=(EquipFlag Shr 9) And $07; End;

Function NumDisketteDrives: Integer;
Begin NumDisketteDrives := ((EquipFlag And 1) * (1+(EquipFlag Shr 6) And $03)); End;

Function InitialVideoMode: Integer;
Begin InitialVideoMode:=(EquipFlag Shr 4) And $03; End;

Function PrinterOnline: Boolean;
Begin
 If (Port[$379] And 16)<>16 Then
  PrinterOnline:=False
 Else
  PrinterOnline:=True;
End;

Function AdlibCard: Boolean;
Var Val1,Val2: Byte;
Begin
 Port[$388]:=4; Delay(3); Port[$389]:=$60; Delay(23); Port[$388]:=4; Delay(3);
 Port[$389]:=$80; Delay(23); Val1:=Port[$388]; Port[$388]:=2; Delay(3);
 Port[$389]:=$FF; Delay(23); Port[$388]:=4; Delay(3); Port[$389]:=$21; Delay(85);
 Val2:=Port[$388]; Port[$388]:=4; Delay(3); Port[$389]:=$60; Delay(23);
 Port[$388]:=4; Delay(3); Port[$389]:=$80;
 If ((Val1 And $E0)=0) And ((Val2 And $E0)=$C0) Then
  AdlibCard:=True
 Else
  AdlibCard:=False;
End;

Function TrueDosVer: Word; Assembler;
Asm
    mov     ax,3306h
    int     21h
    mov     ax,bx
End;

Function NetworkDrive(Drive: Char; Var DOSErrorCode: Word): Boolean;
Var Reg: Registers;
Begin
 Drive:=UpCase (Drive);
 If (Drive In ['A'..'Z']) Then
  Begin
   Reg.BL:=ORD(Drive) - 64;
   Reg.AX:=$4409;
   MsDos (Reg);
   If Odd(Reg.Flags) Then
    DosErrorCode:=Reg.AX
   Else
   Begin
    DosErrorCode:=0;
    If Odd(Reg.DX SHR 12) Then
     NetworkDrive:=True
    Else
     NetworkDrive:=False;
   End;
  End;
End;

Function OpModeCheck: Integer;
Begin
 asm
   mov  ax,   $4680
   int  $2f
   mov  dl,   $1
   or   ax,   ax
   jz   @finished
   mov  ax,   $1600
   int  $2f
   mov  dl,   $2
   or   al,   al
   jz   @Not_Win
   cmp  al,   $80
   jne  @finished
  @Not_Win:
   mov  ax,   $1022
   mov  bx,   $0
   int  $15
   mov  dl,   $3
   cmp  bx,   $0a01
   je   @finished
   xor  dl,   dl
  @finished:
   xor  ah,   ah
   mov  al,   dl
   mov  @Result, ax
 End;
End;

Function UART(ComX: Byte): String;
Const
 ComPortText: Array[0..4] of String[11] =
         ('N/A',
          '8250/8250B',
          '8250A/16450',
          '16550A',
          '16550N');
 IIR     = 2;
 SCRATCH = 7;

Var
 PortAdr    : Array[1..4] of Word absolute $40:0;
 ComPortType: Byte;
Begin
 ComPortType:=0;
 If (PortAdr[ComX] =0) Or (Port[PortAdr[ComX]+ IIR ] And $30 <> 0) Then
  Begin
   UART:=ComPortText[ComPortType];                   {No comport!}
   Exit;
  End;
 Port[PortAdr[ComX]+IIR]:=1;                         {Test: enable FIFO}
 If (Port[PortAdr[ComX]+IIR] And $C0) = $C0 Then     {enabled?}
  ComPortType:=3 Else
 If (Port[PortAdr[ComX]+IIR] and $80) = $80 Then     {16550, old version}
  ComPortType:=4 Else
 Begin
  Port[Portadr[ComX]+SCRATCH]:=$AA;
  If Port [Portadr[ComX]+SCRATCH]=$AA Then           {w/scratch reg. ?}
   ComPortType:=2
  Else
   ComPortType:=1;
 End;
 UART:=ComPortText[ComPortType];
End;

Function LPTAddr(LPTX: Byte): Word;
Begin
 If LPTX in [1..3] Then
  LPTAddr:=MemW[$40:6+(LPTX*2)]
 Else
  LPTAddr:=0;
End;

Function BaseAddr(ComX: Byte): Word;
Begin
 If ComX in [1..4] Then
  BaseAddr:=MemW[$40:(ComX-1) SHL 1]
 Else
  BaseAddr:=0;
End;

Function PortRate(ComPort: Word; Var Baud: LongInt): Boolean;
Const
 DLAB = $80;                       { divisor latch access bit    }
Var
 BaseIO,                           { COM base i/o port address   }
 BRGdiv,                           { baud rate generator divisor }
 regDLL,                           { BRG divisor, latched LSB    }
 regDLM,                           { BRG divisor, latched MSB    }
 regLCR: Word;                     { line control register       }
Begin
 Baud:=0;                                  { assume nothing      }
 If (ComPort In [1..4]) Then               { must be 1..4        }
  Begin
   BaseIO:=MemW[$40:(ComPort-1) SHL 1];    { fetch base i/o port }
   If (BaseIO <> 0) Then                   { has BIOS seen it?   }
    Begin
     regDLL:=BaseIO;                       { BRGdiv, latched LSB }
     regDLM:=BaseIO+1;                     { BRGdiv, latched MSB }
     regLCR:=BaseIO+3;                     { line control reg    }
     Port[regLCR]:=Port[regLCR] Or DLAB;           { set DLAB    }
     BRGdiv:=WORD(Port[regDLL]);                   { BRGdiv LSB  }
     BRGdiv:=BRGdiv Or WORD(Port[regDLM]) SHL 8;   { BRGdiv MSB  }
     Port[regLCR]:=Port[regLCR] And Not DLAB;      { reset DLAB  }
     If (BRGdiv <> 0) Then
      Baud:=1843200 Div (LONGINT(BRGdiv) SHL 4);     { calc bps  }
    End;
  End;
 PortRate:=(Baud<>0);
End;

Function PortInfo(ComX: Byte; Var DataBits,StopBits,Parity: Byte): Boolean;
Var
 B,S,CO: Integer;
 ComList: Array[1..4] Of Word ABSOLUTE $0000:$0400;
Begin
 CO:=ComList[ComX];
 If CO=0 Then
  PortInfo:=False
 Else
  PortInfo:=True;
 S:=Port[CO+3];
 If (S And 3)=3 Then
  B:=8 Else
 If (S And 2)=2 Then
  B:=7 Else
 If (S And 1)=1 Then
  B:=6 Else B:=5;
 DataBits:=B;
 If (S And 4)=4 Then
  B:=2
 Else
  B:=1;
 StopBits:=B;
 If (S And 24)=24 Then
  Parity:=2 Else { Even }
 If (S And 8)=8 Then
  Parity:=1 Else { Odd }
 Parity:=0;      { None}
End;

{$ENDIF}

{$IFDEF Useless}
Function ReadChar(Pattern: Integer): Char;
Const
 NumLock = 32;
 CapsLock = 64;
 ScrlLock = 16;
var
 Status : byte;
 i: Integer;
begin
    Status := (Mem[$0000:$0417] and 176);
    I:=1;
    If Pattern=1 Then
     Begin
      Repeat;
       If I=1 Then Mem[$0000:$0417] := NumLock;
       If I=2 Then Mem[$0000:$0417] := CapsLock;
       If I=3 Then Mem[$0000:$0417] := ScrlLock;
       Inc(I);
       If I=4 then I:=1;
       CDelay(500);
      Until (keypressed);
     End;
    If Pattern=2 Then
     Begin
      Repeat;
       If I=3 Then Mem[$0000:$0417] := NumLock;
       If I=2 Then Mem[$0000:$0417] := CapsLock;
       If I=1 Then Mem[$0000:$0417] := ScrlLock;
       Inc(I);
       If I=4 then I:=1;
       CDelay(500);
      Until (keypressed);
     End;
    If Pattern=3 Then
     Begin
      Repeat;
       If I=1 Then Mem[$0000:$0417] := NumLock+ScrlLock;
       If I=2 Then Mem[$0000:$0417] := CapsLock;
       Inc(I);
       If I=3 then I:=1;
       CDelay(500);
      Until (keypressed);
     End;
    If Pattern=4 Then
     Begin
      Repeat;
       If I=1 Then Mem[$0000:$0417] := NumLock+ScrlLock+CapsLock;
       If I=2 Then Mem[$0000:$0417] := 0;
       Inc(I);
       If I=3 then I:=1;
       CDelay(500);
      Until (Keypressed);
     End;
    Mem[$0000:$0417] := Status;           { restore old Locks               }
    ReadChar:=ReadKey;
End;

Procedure MoveLong(FromP: Pointer; ToP: pointer; Len: longint);
type
   longtype        = array[1 .. 63 * 1024] of char;
   longtypeptr     = ^ longtype;
   ptrrec          = record
      ofs, seg     : word; end;
const
   longtypelen     = sizeof(longtype);
begin
   { fix the pointers: offsets between 0 and 15 }
   inc(ptrrec(fromp).seg, ptrrec(fromp).ofs div 16);
   ptrrec(fromp).ofs := ptrrec(fromp).ofs and 15;
   inc(ptrrec(top).seg, ptrrec(top).ofs div 16);
   ptrrec(top).ofs := ptrrec(top).ofs and 15;

   { move pieces }
   while len > sizeof(longtype) do begin
      { faster than: move(fromp^, top^, sizeof(longtype)); }
      asm
         push    ds
         lds     si,fromp
         les     di,top
         mov     cx,(longtypelen / 2)
         cld
         rep     movsw
         pop     ds
      end;
      dec(len, sizeof(longtype));
      inc(ptrrec(fromp).seg, sizeof(longtype) div 16);
      inc(ptrrec(top).seg, sizeof(longtype) div 16);
   end;
   if len <> 0 then
      { faster than: move(fromp^, top^, len); }
      asm
         push    ds
         lds     si,fromp
         les     di,top
         mov     cx,word(len)
         shr     cx, 1
         cld
         jnc     @wordmove
         movsb
      @wordmove:
         rep     movsw
         pop     ds
      end;
end;

Procedure RAMShot(FN: String);
Const
 TotalRAM = 640;
Var
 Index    : Word;
 PhotoFile: File;
Begin
 Index := 0;
 Assign(PhotoFile,FN);
 ReWrite(PhotoFile,1);
 For Index:=0 To ((TotalRAM DIV $40) - $1) Do
  Begin
   BlockWrite(PhotoFile,Ptr(Index,$0000)^,$8000);
   BlockWrite(PhotoFile,Ptr(Index,$8000)^,$8000)
  End;
 Close(PhotoFile)
End;

Procedure Init_Box(Text1, Text2, Text3: String);
Var
 Text_Buf: Array[1..3] Of String[60];
 MaxLen: Integer;
 Spaces: Integer;
 Count: Integer;
 Lines: Integer;
 Count2: Integer;
Begin
 Text_Buf[1]:=Text1;
 Text_Buf[2]:=Text2;
 Text_Buf[3]:=Text3;
 If Odd(Length(Text_Buf[1])) Then Text_Buf[1]:=Text_Buf[1]+' ';
 If Odd(Length(Text_Buf[2])) Then Text_Buf[2]:=Text_Buf[2]+' ';
 If Odd(Length(Text_Buf[3])) Then Text_Buf[3]:=Text_Buf[3]+' ';
 MaxLen:=Length(Text_Buf[1]);
 If Length(Text_Buf[2])>MaxLen Then MaxLen:=Length(Text_Buf[2]);
 If Length(Text_Buf[3])>MaxLen Then MaxLen:=Length(Text_Buf[3]);
 Lines:=0;
 If Text_Buf[1]='' Then Exit;
 Inc(Lines);
 If Text_Buf[2]<>'' Then Inc(Lines);
 If Text_Buf[3]<>'' Then Inc(Lines);
 MaxLen:=MaxLen+2;
 Spaces:=40-(MaxLen DIV 2);
 GotoXY(Spaces,10-Lines);
 TextColor(1);
 Write('Ú'); For Count:=1 To MaxLen Do Write('Ä'); Write('¿');
 GotoXY(Spaces,11-Lines);
 For Count:=1 To Lines Do
  Begin
   Write('³');
   TextColor(15);
   For Count2:=1 To (MaxLen-Length(Text_Buf[Count])) DIV 2 Do Write(' ');
   Write(Text_Buf[Count]);
   For Count2:=1 To (MaxLen-Length(Text_Buf[Count])) DIV 2 Do Write(' ');
   TextColor(1);
   Write('³');
   GotoXY(Spaces,11-Lines+Count);
  End;
 Write('À'); For Count:=1 To MaxLen Do Write('Ä'); Write('Ù');
End;

Procedure Copy_File(Source, Dest: String; Display: Boolean; VAR Success: Boolean);
Var
  Buf: Array[1..2048] of Char;
  FromF, ToF: file;
  NumRead, NumWritten: Word;
Begin
  If Display=True Then Save_Screen;
  If Display=True Then Init_Box('Copying File:',Source+' => '+Dest,'Please wait...');
  Assign(FromF,Source);
  {$I-} Reset(FromF, 1); {$I+}
  If IOResult<>0 Then
   Begin
    If Display=True Then
     Begin
      Restore_Screen;
      Save_Screen;
      Init_Box('Error opening file:',Source,'Copy aborted.');
      CDelay(5000);
      Restore_Screen;
     End;
    Success:=False;
    Exit;
   End;
  Assign(ToF, Dest);
  {$I-} Rewrite(ToF, 1); {$I+}
  If IOResult<>0 Then
   Begin
    If Display=True Then
     Begin
      Restore_Screen;
      Save_Screen;
      Init_Box('Error creating destination file:',Dest,'Copy aborted.');
      CDelay(5000);
      Restore_Screen;
     End;
    Success:=False;
    Exit;
   End;
  Repeat
    BlockRead(FromF,buf,
              SizeOf(buf),NumRead);
    BlockWrite(ToF,buf,NumRead,NumWritten);
  Until (NumRead = 0) or
        (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
  Success:=True;
  If Display=True Then Restore_Screen;
End;

{ For ExecWin below }
Procedure Int29Handler(AX,BX,CX,DX,SI,DI,DS,ES,BP: Word); Interrupt;
Var Dummy: Byte; Begin Write(Chr(Lo(AX))); Asm Sti; End; End;


Function ExecWin(ProgName,Params: String;
                 LeftCol,TopLine,RightCol,BottomLine: Word): Word;
Var A: Word;
Begin
 GotoXY(LeftCol, TopLine);
 Write(Chr(201));
 For A:=1 To (RightCol-LeftCol)-1 Do Write(Chr(205));
 Write(Chr(187));
 For A:=1 To (BottomLine-TopLine)-1 Do
  Begin
   GotoXY(LeftCol,TopLine+A);
   Write(Chr(186));
   GotoXY(RightCol,TopLine+A);
   Write(Chr(186));
  End;
 GotoXY(LeftCol,BottomLine); Write(Chr(200));
 For A:=1 To (RightCol-LeftCol)-1 Do Write(Chr(205));
 Write(Chr(188));
 Window(LeftCol+1,TopLine+1,RightCol-1, BottomLine-1);
 ClrScr;
 GotoXY(1,1);
 GetIntVec($29,OldIntVect29);
 SetIntVec($29,@Int29Handler);
 {.$M 10000,0,0}
 SwapVectors; Exec(ProgName,Params); SwapVectors;
 ExecWin:=DOSExitCode;
 SetIntVec($29,OldIntVect29);
 Window(LeftCol,TopLine,RightCol,BottomLine); ClrScr; Window(1, 1, 80, 25);
End;

Function ExecWin2(ProgName,Params: String;
                 LeftCol,TopLine,RightCol,BottomLine: Word): Word;
Var A: Word;
    OldAttr: Byte;
Begin
 OldAttr:=TextAttr;
 Window(LeftCol,TopLine,RightCol, BottomLine);
 ClrScr;
 GotoXY(1,1);
 GetIntVec($29,OldIntVect29);
 SetIntVec($29,@Int29Handler);
 {.$M 10000,0,0}
 SwapVectors; Exec(ProgName,Params); SwapVectors;
 ExecWin2:=DOSExitCode;
 SetIntVec($29,OldIntVect29);
 TextAttr:=OldAttr;
 Window(LeftCol,TopLine,RightCol,BottomLine); ClrScr; Window(1, 1, 80, 25);
End;

Function CvtToReal(LngInt: LongInt): Real;
Begin
 CvtToReal:=LngInt;
End;

Function CvtToWord(RealToRound: Real): Word;
Begin
 If RealToRound>65535 Then RealToRound:=65535;
 CvtToWord:=Trunc(RealToRound);
End;

Function CvtToInt(RealToRound: Real): Integer;
Begin
 If RealToRound>32767 Then RealToRound:=32767;
 CvtToInt:=Trunc(RealToRound);
End;

Function CvtToLInt(RealToRound: Real): LongInt;
Begin
 If RealToRound>2147483647 Then RealToRound:=2147483647;
 CvtToLInt:=Trunc(RealToRound);
End;

Function CvtToByte(IntToRound: Integer): Byte;
Begin
 If IntToRound>255 Then IntToRound:=255;
 CvtToByte:=IntToRound;
End;

Function WordToInt(WordToRound: Word): Integer;
Begin
 If WordToRound>32767 Then WordToRound:=32767;
 WordToInt:=WordToRound;
End;

Function RoundOff(RealToRound: Real): Real;
Begin
 RoundOff:=Int(RealToRound);
End;

Function WordVal(ChrStr: String): Word;
Var TW: Integer;
    Code: Word;
Begin
 Val(ChrStr,TW,Code);
 If Code<>0 Then TW:=-1;
 WordVal:=TW;
End;

{$ENDIF}

End.

