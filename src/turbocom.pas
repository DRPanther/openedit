Unit TurboCOM;
{$I DEFINES.INC}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{                                                                   Rev. 016 }
{ TurboCOMM Communications Library                                           }
{ Turbo Pascal v7.0 Door Writing Utility                                     }
{ By Steve Blinch & Michael Helliker of Mikerosoft Productions               }
{                                                                            }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  Interface
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ General TurboCOMM Routines                                                 }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function Local: Boolean;                        {                Local mode? }
Function CarrierDetected: Boolean;              {    Carrier still detected? }
Function BlinkSet: Boolean;                     {     Is text in blink mode? }
Procedure FossilData(PNum: Word; Var MajVer,MinVer: Byte; Var FosID: String);
                                                { -------------------------- }
Procedure Ansi_Write(Ch: Char);                 {     Display w/ANSI support }
Procedure SWriteChar(C: Char);                  {    Remote/Local write char }
Procedure SWrite(S: String);                    {  Remote/Local write string }
Procedure SWriteLn(S: String);                  {  Remote/Local write str+CR }
Procedure Remote_Screen(S: String);             {   Remote only write string }
                                                { -------------------------- }
Procedure SClrScr;                              {  Remote/Local clear screen }
Procedure SClrEol;                              { Remote/Local clear endofln }
Procedure ChatMode; Far;                        {      Default far chat mode }
Procedure STextColor(C: Integer);               { Remote/Local foregnd color }
Procedure STextBackground(C: Integer);          { Remote/Local backgnd color }
Procedure SGotoXY(X,Y: Integer);                {      Remote/Local goto X,Y }
Procedure SColor(ForeC,BackC: Integer);         { Remote/Local fore/bk color }
Procedure SaveColors;                           {  Save current Fg/Bg colors }
Procedure RestoreColors;                        {       Restore saved colors }
                                                { -------------------------- }
Procedure Disconnect;                           {    Disconnect if not local }
Procedure DisconnectUser;                       {         Disconnect (SysOp) }
Procedure ExitToBBS;                            {  Return to the BBS (SysOp) }
Procedure LineNoise;                            {       Send fake line noise }
Procedure BeepUser;                             {    Send ^G (SysOp) & Tweet }
                                                { -------------------------- }
Function Remote_Keypressed: Boolean;            {        Remote key pressed? }
Function Local_Keypressed: Boolean;             {         Same as Keypressed }
Function SKeypressed: Boolean;                  {  Same as Remote_Keypressed }
Function SReadKey: Char;                        {       Remote/Local ReadKey }
Function ReceiveChar(PNum : Word) : Char;       {  Raw read from port PNum+1 }
                                                { -------------------------- }
Procedure SReadLn (Var S: String; Len: Byte;    {        Remote/Local ReadLn }
                       Default: String);        {             (Strings only) }
Procedure SRead   (Var S: String; Len: Byte;    {          Remote/Local Read }
                       Default: String);        {             (Strings only) }
Procedure SReadNum(Var S: String; Max,          {          Remote/Local Read }
                       Default: String);        {   (Positive longints only) }
Procedure SReadNeg(Var S: String; Min, Max,     {          Remote/Local Read }
                       Default: String);        {     (Pos/Neg longints only }
Procedure ConcealedSReadLn(Var S: String; Len:  {          Remote/Local Read }
                       Byte; Default: String);  {   (Concealed strings only) }
                                                { -------------------------- }
Procedure DisplayFile(F: String);               {   Display text/ANSI File F }
Function DetectANSI: Boolean;                   {  Detect user's ANSI status }
Procedure ReleaseSlice;                         { Release time slice - Check }
                                                {  LastSlice+Slicing<=Timer! }
                                                { -------------------------- }
Function FormatTime(Rl: Real): String;          {   Format to 00:00:00 style }
Function Nsl: Real;                             {      Time left, in seconds }
                                                { -------------------------- }
Procedure StatusWrite(Bar: Byte; S: String);    {  Display S on StatBar #Bar }
Procedure StatusWriteXY(X,Y,A: Byte; S: String);{   Display S w/o win bounds }
Procedure UpdateStatus(Forced: Boolean);        {  Update status bar - Check }
                                                {  (LastUpdate+UpdateSeconds }
                                                {                  <=Timer)! }
                                                { -------------------------- }
Procedure InitTurboCOMM;                        {       Initialize TurboCOMM }
Procedure FUtility(B: Byte);                    {         Raw port utilities }
Function LockProgram(LockFile: String): Integer;{ Revoke other nodes' access }
Procedure UnlockProgram;                        {       Allow other nodes in }
                                                { -------------------------- }
Procedure DOSShell; Far;                        {      Default far DOS shell }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ Multitasker Control Routines                                               }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure BeginCrit;                            { Stop running other windows }
Procedure EndCrit;                              { Cont running other windows }
Procedure TimeOutReset;                         {    Reset LockRetry counter }
Function TimeOut: Boolean;                      {  Check 4 LockRetry timeout }
Procedure LockRecords(var F; Start, Records: LongInt); {   Lock file records }
Procedure UnLockRecords(var F; Start, Records: LongInt); {  Unlock file recs }
Procedure LockBytes(var F; Start, Bytes: LongInt); {         Lock file bytes }
Procedure UnLockBytes(var F; Start, Bytes: LongInt); {     Unlock file bytes }
Procedure LockFile(var F);                      {           Lock entire file }
Procedure UnLockFile(var F);                    {         Unlock entire file }
Function InDos: Boolean;                        {    Is DOS doing something? }
Procedure ResetFileMode;                        {   Reset fmode to ReadWrite }
Procedure SetFileMode(Mode : Word);             {       Set filemode to Mode }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM User Changeable Constants & Types                                }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Type
 NewProcType = Procedure;                       { To override existing procs }
Const
 HelpScrPrgName: String[20]   = 'TurboCOMM';    { Name shown in help screens }
 LocalTest     : Boolean      = False;          {    Local test, -L invoked? }
 EnableFlush   : Boolean      = False;          { Flush buffer after SWrites }
 ChatProcedure : NewProcType  = ChatMode;       {  Chat procedure identifier }
 ShellProcedure: NewProcType  = DOSShell;       { Shell procedure identifier }
 Detailed      : Boolean      = False;          {    Use detailed Init msgs? }
 UpdateSeconds : Byte         = 1;              { Update statbar every x sec }
 ShowSeconds   : Boolean      = True;           { Show secs left on statbar? }
 UseMaxKey     : Boolean      = False;          { Allow ">" key in SReadNum? }
 ANSDetectDelay: Word         = 1500;           {   Wait for detect response }
 ANSRetryDelay : Word         = 1000;           { Detect failed, retry delay }
 InputFore     : Integer      = 15;             {   SReadxx foreground color }
 InputBack     : Integer      = 1;              {   SReadxx background color }
 LimitExceeded : String[80]   = ' ş Time limit exceeded, exiting!';
 CarrierLoss   : String[50]   = ' ş Carrier lost, exiting!';
 MessageDelay  : Word         = 2000;           {   Delay after above 2 msgs }
 StartChat     : String[50]   = 'SysOp breaking in for chat...';
 EndChat       : String[50]   = 'SysOp chat mode ended...';
 StartShell    : String[50]   = 'SysOp dropping to DOS, please wait..';
 EndShell      : String[50]   = 'SysOp has returned...';
 TwentySec     : String[50]   = '20 Seconds to inactivity timeout!';
 InactiveExiting: String[50]  = 'User inactive, disconnecting...';
 HookErrorHandler: Boolean    = False;          {  Use ext'd error handling? }
 ErrorLog      : String[12]   = 'ERRORS.LOG';   { File to save error info to }
 ErrorSnapshot : String[12]   = 'ERRORS.DAT';   {     File to save screen to }
 SingleLineStat: Boolean      = False;          {     Use 1-line status bar? }
 SReadANSIKeys : Boolean      = True;           { Sim ANSI keys on local kbd }
 SReadHighBit  : Boolean      = False;          {  Allow highbit in SRead()? }
 SimCPS        : Word         = 0;              {          1/CPSRate*1000000 }
 ErrorExitCode : Word         = 0;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Global Constants & Types                                         }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Type
 Taskers       = (NoTasker, DesqView, DoubleDOS, Windows, OS2, NetWare);

Const
 OS2Secs       : Word = 1;
 DefaultSave   : Byte = 7;                      {   Default save screen slot }
 Off           : String[4] = '[0m';            {      Reset to TextAttr $07 }
 AnsiCode      : Array[0..47] Of String[7] =    {  ANSI codes, 40+ = BG attr }
        ('[0m',    '[0;34m', '[0;32m',
         '[0;36m', '[0;31m', '[0;35m',
         '[0;33m', '[0;37m', '[1;30m',
         '[1;34m', '[1;32m', '[1;36m',
         '[1;31m', '[1;35m', '[1;33m',
         '[1;37m', '','', '', '','', '',
         '','', '', '','', '', '','', '',
         '','', '', '','', '', '','', '',
         '[40m',   '[44m',   '[42m',
         '[46m',   '[41m',   '[45m',
         '[43m',   '[47m');

 MaxLockRetries: Byte = 10;                     {  Max retries for file lock }

 NormalMode    = $02; { ---- 0010 }             {        Normal (read/write) }
 ReadOnly      = $00; { ---- 0000 }             {          Deny write access }
 WriteOnly     = $01; { ---- 0001 }             {           Deny read access }
 ReadWrite     = $02; { ---- 0010 }             {        Normal (read/write) }
 DenyAll       = $10; { 0001 ---- }             {            Deny all access }
 DenyWrite     = $20; { 0010 ---- }             {          Deny write access }
 DenyRead      = $30; { 0011 ---- }             {           Deny read access }
 DenyNone      = $40; { 0100 ---- }             {           Allow all access }
 NoInherit     = $70; { 1000 ---- }             {             No inheritance }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Global Variables                                                 }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Var
 MultiTasking  : Boolean;                       {     Under any multitasker? }
 MultiTasker   : Taskers;                       {         Which multitasker? }
 MT            : String[50];                    { Actual name of multitasker }
 ForceTasker   : Char;                          {   Force this mtasker (-@x) }
 VideoSeg,                                      {          New video segment }
 VideoOfs      : Word;                          {           New video offset }
 IdleSlicing,                                   {       "Slicing" while idle }
 Slicing       : Real;                          {   Release slice this often }
 LastSlice     : Real;                          { Time of last slice release }
                                                { -------------------------- }
 CapitalizeON  : Boolean;                       {   Capitalize SReadxx text? }
                                                { -------------------------- }
 LastUpdate    : Real;                          {     Last status bar update }
 ProhibitStatus: Boolean;                       {  Do not display status bar }
 SFore,                                         {   StatBar foreground color }
 SBack,                                         {   StatBar background color }
 StatBar       : Integer;                       {       Current status bar # }
                                                { -------------------------- }
 ProgLocked,                                    { Revoke other nodes' access }
 ForceDoorSys,                                  {        Force DOOR.SYS (-!) }
 ForceDorInfo1 : Boolean;                       { Force DORINFO1 (not INFOx) }
 LockBaud,                                      {            Locked baudrate }
 NodeNum       : Integer;                       {  Current node number (-Nx) }
 SysPath       : String[50];                    {       System path (-Pxxxx) }
                                                { -------------------------- }
 ProgName      : String[62];                    {       Name of this program }
 CarrierCheck,                                  { Keep checking for carrier? }
 TimeCheck,                                     {  Keep checking inactivity? }
 LocalANSIKeys : Boolean;                       {  Chg Up/Dn/Lt/Rt to <[ABCD }
                                                { -------------------------- }
 ChatOK,                                        {     OK to enter chat mode? }
 InChat        : Boolean;                       {   Chat mode active? (USE!) }
                                                { -------------------------- }
 RemoteChar,                                    { Last char was from remote? }
 LocalChar,                                     {    Last char was from kbd? }
 ANSI          : Boolean;                       {  ANSI status from dropfile }
                                                { -------------------------- }
 BBSName,                                       { [DropFile]        BBS Name }
 SysopFirst,                                    {         SysOp's first name }
 SysOpLast,                                     {          SysOp's last name }
 UserFirst,                                     {          User's first name }
 UserLast,                                      {           User's last name }
 UserLocation,                                  {          User's city/state }
 SysOpName,                                     {   SysOpFirst+' '+SysOpLast }
 UserName      : String[50];                    {     UserFirst+' '+UserLast }
 BaudRate,                                      {            User's baudrate }
 Security      : Word;                          {            User's security }
 ComPort       : Integer;                       {            User's COM port }
 TimeLeft      : Real;                          {  User's time left, seconds }
                                                { -------------------------- }
 OldSlCount,                                    {              Old NSL count }
 TimeOutDelay,                                  {         Inactivity timeout }
 TimeOn        : Real;                          {     Time user entered door }
                                                { -------------------------- }
 ExitSave      : Pointer;                       {  New hooked exit procedure }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  Implementation
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Uses Crt,DOS;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Local Variables                                                  }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Type
 SaveScrRec = Record                            {   Saved screen record type }
   X,Y,TxtAttr : Byte;                          {                Screen info }
   WndMin,                                      {  Window minimum boundaries }
   WndMax      : Word;                          {  Window maximum boundaries }
   Screen      : Array[1..4000] Of Byte;        {          Video memory dump }
  End;

Const
  Scale        : Array[0..7] Of Integer =       {  Low intensity color scale }
                  (0,4,2,6,1,5,3,7);
  ScaleH       : Array[0..7] Of Integer =       { High intensity color scale }
                  (8,12,10,14,9,13,11,15);
  Initialized  : Boolean = False;               {      InitTurboCOMM called? }
Var
 Saved         : Array[1..12] Of ^SaveScrRec;   {         Saved screen array }
                                                { -------------------------- }
 BBB           : Boolean;                       {   Internal (ANSI Routines) }
 T             : Char;                          {   Internal (ANSI Routines) }
 RestX,RestY,                                   {   Internal (ANSI Routines) }
 CurColor      : Integer;                       {   Internal (ANSI Routines) }
 Escape,Blink,                                  {   Internal (ANSI Routines) }
 High,Norm,Any,                                 {   Internal (ANSI Routines) }
 Any2,FFlag,                                    {   Internal (ANSI Routines) }
 GFlag         : Boolean;                       {   Internal (ANSI Routines) }
 ANSI_String   : String;                        {   Internal (ANSI Routines) }
                                                { -------------------------- }
 Note_Octave   : Integer;                       {      Internal (ANSI Music) }
 Note_Fraction,                                 {      Internal (ANSI Music) }
 Note_Length,                                   {      Internal (ANSI Music) }
 Note_Quarter  : Real;                          {      Internal (ANSI Music) }
                                                { -------------------------- }
 Port_Num      : Integer;                       {     COMPort-1 (for FOSSIL) }
 LockFilename  : String[50];                    {     Internal (LockProgram) }
                                                { -------------------------- }
 InDosFlag     : ^Word;                         {     Internal (Multitasker) }
 LockRetry     : Byte;                          {     Internal (Multitasker) }

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Multitasker Routines                                             }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


Procedure GiveTimeSlice; Assembler;
Asm
  cmp   MultiTasker, DesqView
  je    @DVwait
  cmp   MultiTasker, DoubleDOS
  je    @DoubleDOSwait
  cmp   MultiTasker, Windows
  je    @WinOS2wait
  cmp   MultiTasker, OS2
  je    @OS221wait {WinOS2wait}
  cmp   MultiTasker, NetWare
  je    @Netwarewait
 @Doswait:
  int   $28
  jmp   @WaitDone
 @DVwait:
  mov   AX,$1000
  int   $15
  jmp   @WaitDone
 @DoubleDOSwait:
  mov   AX,$EE01
  int   $21
  jmp   @WaitDone
 @WinOS2wait:
  mov   AX,$1680
  int   $2F
  jmp   @WaitDone
 @OS221wait:
  push  dx
  xor   dx, dx      {; DX:AX = number of milliseconds to give up;}
  mov   ax, OS2Secs {; 0 = rest of current timeslice, allegedly, but doesn't seem to work in my tests.}
  sti               {; Ensure that interrupts are on (else we'll wait forever)}
  hlt               {; Call OS/2}
  db    035h, 0CAh  {; Signature to specify DosSleep to OS/2.}
  pop   dx
  jmp   @WaitDone
 @Netwarewait:
  mov   BX,$000A
  int   $7A
  jmp   @WaitDone
 @WaitDone:
End;

Procedure FLock(Handle: Word; Pos,Len: LongInt);
Inline(
  $B8/$00/$5C/    {  mov   AX,$5C00        ;DOS FLOCK, Lock subfunction}
  $8B/$5E/$04/    {  mov   BX,[BP + 04]    ;Place file handle in Bx register}
  $C4/$56/$06/    {  les   DX,[BP + 06]    ;Load position in ES:DX}
  $8C/$C1/        {  mov   CX,ES           ;Move ES pointer to CX register}
  $C4/$7E/$08/    {  les   DI,[BP + 08]    ;Load length in ES:DI}
  $8C/$C6/        {  mov   SI,ES           ;Move ES pointer to SI register}
  $CD/$21);       {  int   $21             ;Call DOS}

Procedure FUnlock(Handle: Word; Pos,Len: LongInt);
Inline(
  $B8/$01/$5C/    {  mov   AX,$5C01        ;DOS FLOCK, Unlock subfunction}
  $8B/$5E/$04/    {  mov   BX,[BP + 04]    ;Place file handle in Bx register}
  $C4/$56/$06/    {  les   DX,[BP + 06]    ;Load position in ES:DX}
  $8C/$C1/        {  mov   CX,ES           ;Move ES pointer to CX register}
  $C4/$7E/$08/    {  les   DI,[BP + 08]    ;Load length in ES:DI}
  $8C/$C6/        {  mov   SI,ES           ;Move ES pointer to SI register}
  $CD/$21);       {  int   $21             ;Call DOS}

Procedure SetFileMode(Mode: Word); {- Set filemode for typed/untyped files }
Begin
 FileMode:=Mode;
End;

Procedure ResetFileMode; {- Reset filemode to ReadWrite (02h) }
Begin
 FileMode:=NormalMode;
End;

Function InDos: Boolean; {- Is DOS busy? }
Begin
 InDos:=InDosFlag^>0;
End;

Procedure LockFile(var F); {- Lock file F }
Begin
 If Not MultiTasking Then Exit;
 FLock(FileRec(F).Handle,0,FileSize(File(F)));
End;

procedure UnLockFile(var F); {- Unlock file F }
Begin
 If Not MultiTasking Then Exit;
 FLock(FileRec(F).Handle,0,FileSize(File(F)));
End;

Procedure LockBytes(var F; Start,Bytes: LongInt);    {- Lock Bytes bytes of }
Begin                                               { file F, starting with }
 If Not MultiTasking Then Exit;                                     { Start }
 FLock(FileRec(F).Handle,Start,Bytes);
End;

Procedure UnLockBytes(var F; Start,Bytes: LongInt);   {- Unlock Bytes bytes }
Begin                                            { of file F, starting with }
 If Not MultiTasking Then Exit;                                     { Start }
 FLock(FileRec(F).Handle,Start,Bytes);
End;

Procedure LockRecords(var F; Start,Records: LongInt); {- Lock Records records }
Begin                                                 { of file F, starting }
 If Not MultiTasking Then Exit;                                { with Start }
 FLock(FileRec(F).Handle,Start*FileRec(F).RecSize,Records*FileRec(F).RecSize);
End;

Procedure UnLockRecords(var F;  Start, Records : LongInt); {- Unlock Records }
Begin                                                      { records of file }
 If Not Multitasking Then Exit;                            { F, starting with}
                                                                     { Start }
 FLock(FileRec(F).Handle,Start*FileRec(F).RecSize,Records*FileRec(F).RecSize);
End;

Function TimeOut: Boolean; {- Check for LockRetry timeout }
Begin
 GiveTimeSlice;
 TimeOut:=True;
 If MultiTasking And (LockRetry < MaxLockRetries) Then
  Begin
   TimeOut:=False;
   Inc(LockRetry);
  End;
End;

Procedure TimeOutReset; {- Reset internal LockRetry counter }
Begin
 LockRetry:=0;
End;

Procedure BeginCrit; Assembler; {- Enter critical region }
asm
  cmp   MultiTasker, DesqView
  je    @DVCrit
  cmp   MultiTasker, DoubleDOS
  je    @DoubleDOSCrit
  cmp   MultiTasker, Windows
  je    @WinCrit
  jmp   @EndCrit
 @DVCrit:
  mov   AX,$101B
  int   $15
  jmp   @EndCrit
 @DoubleDOSCrit:
  mov   AX,$EA00
  int   $21
  jmp   @EndCrit
 @WinCrit:
  mov   AX,$1681
  int   $2F
  jmp   @EndCrit
 @EndCrit:
End;

Procedure EndCrit; Assembler; {- End critical region }
asm
  cmp   MultiTasker, DesqView
  je    @DVCrit
  cmp   MultiTasker, DoubleDOS
  je    @DoubleDOSCrit
  cmp   MultiTasker, Windows
  je    @WinCrit
  jmp   @EndCrit
 @DVCrit:
  mov   AX,$101C
  int   $15
  jmp   @EndCrit
 @DoubleDOSCrit:
  mov   AX,$EB00
  int   $21
  jmp   @EndCrit
 @WinCrit:
  mov   AX,$1682
  int   $2F
  jmp   @EndCrit
 @EndCrit:
End;

Procedure SliceInit; {- Init }
Label CheckDone;
Begin
 LockRetry:= 0;
 If ForceTasker in ['D','2','W','O','N','X'] Then
  Begin
   Case ForceTasker Of
     'D': Multitasker:=DESQview;
     '2': Multitasker:=DoubleDOS;
     'W': Multitasker:=Windows;
     'O': Multitasker:=OS2;
     'N': Multitasker:=NetWare;
     'X': Begin Multitasker:=NoTasker; Multitasking:=False; End;
    End;
   Goto CheckDone;
  End
  Else
  Begin
   Asm
     @CheckOS2:
      mov   AX, $3001
      int   $21
      cmp   AL, $0A
      je    @InOS2
      cmp   AL, $14
      jne   @CheckDoubleDOS
     @InOS2:
      mov   MultiTasker, OS2
      jmp   CheckDone
     @CheckDoubleDOS:
      mov   AX, $E400
      int   $21
      cmp   AL, $00
      je    @CheckWindows
      mov   MultiTasker, DoubleDOS
      jmp   CheckDone
     @CheckWindows:
      mov   AX, $1600
      int   $2F
      cmp   AL, $00
      je    @CheckDV
      cmp   AL, $80
      je    @CheckDV
      mov   MultiTasker, Windows
      jmp   CheckDone
     @CheckDV:
      mov   AX, $2B01
      mov   CX, $4445
      mov   DX, $5351
      int   $21
      cmp   AL, $FF
      je    @CheckNetware
      mov   MultiTasker, DesqView
      jmp   CheckDone
     @CheckNetware:
      mov   AX,$7A00
      int   $2F
      cmp   AL,$FF
      jne   @NoTasker
      mov   MultiTasker, NetWare
      jmp   CheckDone
     @NoTasker:
      mov   MultiTasker, NoTasker
     CheckDone:
      {-Set MultiTasking }
      cmp   MultiTasker, NoTasker
      mov   VideoSeg, $B800
      mov   VideoOfs, $0000
      je    @NoMultiTasker
      mov   MultiTasking, $01
      {-Get video address }
      mov   AH, $FE
      les   DI, [$B8000000]
      int   $10
      mov   VideoSeg, ES
      mov   VideoOfs, DI
      jmp   @Done
     @NoMultiTasker:
      mov   MultiTasking, $00
     @Done:
      {-Get InDos flag }
      mov   AH, $34
      int   $21
      mov   WORD PTR InDosFlag, BX
      mov   WORD PTR InDosFlag + 2, ES
    End;
  End;
 Case Multitasker Of
   NoTasker : MT:='DOS';
   DesqView : MT:='DESQview';
   DoubleDOS: MT:='DoubleDOS';
   Windows  : MT:='Windows';
   OS2      : MT:='OS/2';
   NetWare  : MT:='NetWare';
   Else       MT:='Unknown';
  End;
End;

Function Timer: Real;
Begin
 Timer:=MemL[$0040:$006C]/18.2065;
End;

Procedure ReleaseSlice;
Begin
 LastSlice:=Timer;
 If Multitasking Then GiveTimeSlice;
End;

{$F-}

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM ANSI Driver Routines                                             }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure PibPlaySet; {- Reset ANSI music variables }
Begin
 Note_Octave  := 00004;
 Note_Fraction:= 0.875;
 Note_Length  := 00.25;
 Note_Quarter := 500.0;
End;

Procedure PibPlay(S: String); {- Play music string S }
Const
 Note_Offset   : Array['A'..'G'] Of Integer = (9,11,0,2,4,5,7);
 Note_Freqs    : Array[0..84] Of Integer =
(*    C    C#     D    D#     E     F    F#     G    G#     A    A#     B *)
(     0,
     65,   69,   73,   78,   82,   87,   92,   98,  104,  110,  116,  123,
    131,  139,  147,  156,  165,  175,  185,  196,  208,  220,  233,  247,
    262,  278,  294,  312,  330,  350,  370,  392,  416,  440,  466,  494,
    524,  556,  588,  624,  660,  700,  740,  784,  832,  880,  932,  988,
   1048, 1112, 1176, 1248, 1320, 1400, 1480, 1568, 1664, 1760, 1864, 1976,
   2096, 2224, 2352, 2496, 2640, 2800, 2960, 3136, 3328, 3520, 3728, 3952,
   4192, 4448, 4704, 4992, 5280, 5600, 5920, 6272, 6656, 7040, 7456, 7904  );

 Quarter_Note  = 0.25;

Var
 Play_Freq,
 Play_Duration,
 Rest_Duration,
 N,K,I         : Integer;
 C             : Char;
 Freq          : Array[0..6,0..11] Of Integer Absolute Note_Freqs;
 XN            : Real;

Function GetInt: Integer;
Var
 N: Integer;
Begin (* GetInt *)
 N:=0;
 While(S[I] In ['0'..'9']) Do
  Begin
   N:=N*10+Ord(S[I])-Ord('0');
   I:=I+1;
  End;
 I:=I-1;
 GetInt:=N;
End;

Begin
 S:=S+' ';
 I:=1;
 While(I<Length(S)) Do
  Begin
   C:=UpCase(S[I]);
   Case C Of
     'A'..'G': Begin
                N:=Note_Offset[C];
                Play_Freq:=Freq[Note_Octave,N];
                XN:=Note_Quarter*(Note_Length/Quarter_Note);
                Play_Duration:=Trunc(XN*Note_Fraction);
                Rest_Duration:=Trunc(XN*(1.0-Note_Fraction));
                If S[I+1] In ['#','+','-'] Then
                 Begin
                  I:=I+1;
                  Case S[I] Of
                    '#': Play_Freq:=Freq[Note_Octave,N+1];
                    '+': Play_Freq:=Freq[Note_Octave,N+1];
                    '-': Play_Freq:=Freq[Note_Octave,N-1];
                    Else ;
                   End;
                  End;
                If S[I+1] In ['0'..'9'] Then
                 Begin
                  I:=I+1;
                  N:=GetInt;
                  XN:=(1.0/N)/Quarter_Note;
                  Play_Duration:=Trunc(Note_Fraction*Note_Quarter*XN);
                  Rest_Duration:=Trunc((1.0-Note_Fraction)*Xn*Note_Quarter);
                 End;
                If S[I+1]='.' Then
                 Begin
                  XN:=1.0;
                  While(S[I+1]='.') Do
                   Begin
                    XN:=XN*1.5;
                    I:=I+1;
                   End;
                  Play_Duration:=Trunc(Play_Duration*XN);
                 End;
                Sound(Play_Freq);
                Delay(Play_Duration);
                NoSound;
                Delay(Rest_Duration);
               End;
            'M': Begin
                  I:=I+1;
                  C:=S[I];
                  Case C Of
                    'F' : ;
                    'B' : ;
                    'N' : Note_Fraction := 0.875;
                    'L' : Note_Fraction := 1.000;
                    'S' : Note_Fraction := 0.750;
                    Else ;
                   End;
                  End;
            'O': Begin
                  I:=I+1;
                  N:=Ord(S[I])-ORD('0');
                  If (N<0) Or (N>6) Then N := 4;
                   Note_Octave := N;
                 End;
            '<': Begin
                  If Note_Octave>0 Then Note_Octave:=Note_Octave-1;
                 End;
            '>': Begin
                  If Note_Octave<6 Then
                  Note_Octave:=Note_Octave+1;
                 End;
            'N': Begin
                  I:=I+1;
                  N:=GetInt;
                  If (N>0) And (N<=84) Then
                   Begin
                    Play_Freq:=Note_Freqs[N];
                    If Quarter_Note<>0 Then
                     XN:=Note_Quarter*(Note_Length/Quarter_Note);
                    Play_Duration:=Trunc(XN*Note_Fraction);
                    Rest_Duration:=Trunc(XN*(1.0-Note_Fraction));
                   End
                   Else
                    If (N=0) Then
                     Begin
                      Play_Freq:=0;
                      Play_Duration:=0;
                      If Quarter_Note<>0 Then
                       Rest_Duration:=Trunc(Note_Fraction*Note_Quarter*(Note_Length/Quarter_Note));
                     End;
                  Sound(Play_Freq);
                  Delay(Play_Duration);
                  NoSound;
                  Delay(Rest_Duration);
                 End;
            'L': Begin
                  I:=I+1;
                  N:=GetInt;
                  If N>0 Then Note_Length:=1.0/N;
                 End;
            'T': Begin
                  I:=I+1;
                  N:=GetInt;
                  Note_Quarter:=(1092.0/18.2/N)*1000.0;
                 End;
            'P': Begin
                  I:=I+1;
                  N:=GetInt;
                  If (N<1) Then
                   N:=1
                  Else
                   If (N>64) Then N:=64;
                  Play_Freq:=0;
                  Play_Duration:=0;
                  If Quarter_Note<>0 Then
                   Rest_Duration:=Trunc(((1.0/N)/Quarter_Note)*Note_Quarter);
                  Sound( Play_Freq );
                  Delay( Play_Duration );
                  NoSound;
                  Delay( Rest_Duration );
                 End;
         End;
        I:=I+1;
       End;
   NoSound;
End;


Procedure Change_Color(C: Integer);
Begin
 Case C of
   00: Begin; Any:=True; High:=False; Norm:=True; End;
   01: Begin; High:=True; End;
   02: Begin; Clrscr; Any:=True; End;
   05: Begin; Blink:=True; Any:=True; End;
  End;
 If (C>29) And (c<38) Then
  Begin
   Any:=True;
   Any2:=True;
   C:=C-30;
   Curcolor:=C;
   If (High=True) And (Blink=true) Then TextColor(ScaleH[C]+128);
   If (high=True) And (Blink=False) Then TextColor(ScaleH[C]);
   If (High=False) And (Blink=True) Then TextColor(Scale[C]+128);
   If (High=False) And (Blink=False) Then TextColor(Scale[C]);
   FFlag:=True;
  End;
 If (C>39) And (c<48) Then
  begin
   Any:=True;
   C:=C-40;
   TextBackground(Scale[C]);
   GFlag:=True;
  End;
End;

Procedure Eval_String(Var S: String);
Var
 CP: Integer;
 T: Char;
 JJ,TT,TTT,TTTT: Integer;
 Flag1: Boolean;
Begin;
 T:=S[Length(S)];
 CP:=2;
 Case T Of
  'k','K': ClrEol;
  'u'    : GotoXY(RestX,RestY);
  's'    : Begin
            RestX:=WhereX;
            RestY:=WhereY;
           End;
  'm','J': Begin
            If S= '[0m' Then Blink:=False;
            Repeat
             TT:=-1;
             Val(S[CP],TT,TTTT);
             If TTTT=0 Then
              Begin
               CP:=CP+1;
               Val(S[CP],TTT,TTTT);
               If TTTT=0 Then
                Begin
                 TT:=TT*10;
                 TT:=TT+TTT;
                End;
               Change_color(TT);
              End;
             CP:=CP+1;
            Until CP>=Length(S);
            If Norm=True Then
             Begin
              If (FFlag=False) And (GFlag=False) Then Begin TextColor(7); TextBackground(0); CurColor:=7; End;
              If (FFlag=False) And (GFlag=True) Then Begin TextColor(7); CurColor:=7; End;
              If (High=True) And (GFlag=False) Then TextColor(Scaleh[curcolor]);
              If (Blink=True) And (FFlag=False) Then TextColor(Scale[curcolor]+128);
              If (Blink=True) And (High=True) And (FFlag=False) Then TextColor(ScaleH[curcolor]+128);
              If (FFlag=True) And (GFlag=False) Then Begin TextBackground(0); End;
             End;
            If Any=False Then TextColor(ScaleH[CurColor]);
            If (high=true) And (Any2=False) Then TextColor(ScaleH[CurColor]);
            Any2:=False; Any:=False; FFlag:=false; GFlag:=False; Norm:=False;
           End;
  ^N     : Begin
            Delete(S,1,2);
            Delete(S,Length(S),1);
            PibPlay(S);
           End;
   'C'   : Begin;
            TT:=1;
            Val(S[CP],TT,TTTT);
            If TTTT=0 Then
             Begin
              CP:=CP+1;
              Val(S[CP],TTT,TTTT);
              If TTTT=0 then
               Begin
                TT:=TT*10;
                TT:=TT+TTT;
               End;
             End
             Else
              TT:=1;
            TTT:=WhereX;
            If TT+TTT<=80 Then GotoXY(TT+TTT,WhereY);
           End;
   'D'   : Begin
            TT:=1;
            Val(S[CP],TT,TTTT);
            If TTTT=0 Then
             Begin
              CP:=CP+1;
              Val(S[CP],TTT,TTTT);
              If TTTT=0 Then
               Begin
                TT:=TT*10;
                TT:=TT+TTT;
               End;
             End
             Else
              TT:=1;
            TTT:=WhereX;
            If TTT-TT>=1 Then GotoXY(TTT-TT,WhereY);
           End;
   'A'   : Begin
            TT:=1;
            Val(S[CP],TT,TTTT);
            If TTTT=0 Then
             Begin
              CP:=CP+1;
              Val(S[CP],TTT,TTTT);
              If TTTT=0 Then
               Begin
                TT:=TT*10;
                TT:=TT+TTT;
               End;
             End
             Else
              TT:=1;
            TTT:=WhereY;
            If TTT-TT>=1 Then GotoXY(WhereX,TTT-TT);
           End;
   'B'   : Begin;
            TT:=1;
            Val(S[CP],TT,TTTT);
            If TTTT=0 Then
             Begin
              CP:=CP+1;
              Val(S[CP],TTT,TTTT);
              If TTTT=0 Then
               Begin
                TT:=TT*10;
                TT:=TT+TTT;
               End;
             End
             Else
              TT:=1;
            TTT:=WhereY;
            If TTT+TT<=25 Then GotoXY(WhereX,TTT+TT);
           End;
  'f','H': Begin
            Flag1:=False;
            TT:=1;
            Val(S[CP],TT,TTTT);
            If TTTT=0 Then
             Begin
              CP:=CP+1;
              Val(S[CP],TTT,TTTT);
              If TTTT=0 Then
               Begin
                TT:=TT*10;
                TT:=TT+TTT;
                Flag1:=True;
               End;
             End
             Else
              TT:=1;
            JJ:=TT;
            If Flag1=False Then CP:=CP+1;
            If Flag1=True Then CP:=CP+2;
            If CP<Length(S) Then
             Begin
              TT:=1;
              Val(S[CP],TT,TTTT);
              If TTTT=0 Then
               Begin
                CP:=CP+1;
                Val(S[CP],TTT,TTTT);
                If TTTT=0 Then
                 Begin
                  TT:=TT*10;
                  TT:=TT+TTT;
                 End;
               End
               Else
                TT:=1;
             End
             Else
              TT:=1;
            GotoXY(tt,jj);
           End;
  Else    WriteLn(S);
 End;
End;

Procedure Ansi_Write(Ch: Char);
Begin
 Case Ch Of
   #12: Clrscr;
   #09: Repeat Write(' '); Until WhereX/8 = Wherex Div 8;
   #27: Begin Escape:=True; BBB:=True; End;
   Else Begin
         If Escape Then
          Begin
           If (BBB=True) And (Ch<>'[') Then
            Begin
             Blink:=False;
             High:=False;
             Escape:=False;
             Ansi_String:='';
             Write(#27);
            End
            Else
             BBB:=False;
         If Escape Then
          Begin
           ANSI_String:=ANSI_String+Ch;
           If Ch=#13 Then Escape:=False;
           If (Ch In ['u','s','A','B','C','D','H','m','J','f','K','k',#14]) Then
            Begin
             Escape:=False;
             Eval_String(ANSI_String);
             ANSI_String:='';
            End;
          End;
         End Else Write(Ch);
        End;
  End;
End;

Procedure ANSI_Write_Str(Var S: String);
Var
 A: Integer;
begin;
 For A:=1 To Length(S) Do
  Begin
   Case S[A] Of
     #12: ClrScr;
     #09: Repeat Write(' '); Until WhereX/8=WhereX Div 8;
     #27: Begin Escape:=True; BBB:=True; End;
     Else Begin
           If Escape Then
            Begin
             If (BBB=True) And (S[A]<>'[') Then
              Begin
               Blink:=False;
               High:=False;
               Escape:=False;
               ANSI_String:='';
               Write(#27);
              End
              Else
               BBB:=False;
             If Escape Then
              Begin
               ANSI_String:=ANSI_String+S[A];
               If S[A]=#13 Then Escape:=False;
               If (S[A] In ['u','s','A','B','C','D','H','m','J','f','K','k',#14]) Then
                Begin
                 Escape:=False;
                 Eval_String(ANSI_String);
                 ANSI_String:='';
                End;
              End;
            End
            Else
             Write(S[A]);
          End;
    End;
  End;
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM FOSSIL Routines                                                  }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure SetBaudRate(PNum: Word; A: LongInt);
Var Reg: Registers;
Begin
 With Reg Do
  Begin
   AH:=0;
   DX:=PNum;
   AL:=$63;
   If A=38400 Then
    AL:=$23
   Else
    Case A Of
      300  : AL:=$43;
      600  : AL:=$63;
      1200 : AL:=$83;
      2400 : AL:=$A3;
      4800 : AL:=$C3;
      9600 : AL:=$E3;
      19200: AL:=$03;
     End;
   Intr($14, Reg);
  End;
End;

Procedure TransmitChar(PNum: Word; A: Char); Assembler;
Asm
    mov     ah,1
    mov     dx,PNum
    mov     al,A
    int     14h
End;

Function TxCharNoWait(PNum: Word; A: Char): Boolean; Assembler;
Asm
    mov     ah,0Bh
    mov     dx,PNum
    int     14h
    cmp     ax,1
    mov     ah,0
    mov     al,1
    je      @@1
    mov     al,0
@@1:
END;

Function ReceiveChar(PNum: Word): Char; Assembler;
Asm
    mov     ah,2
    mov     dx,PNum
    int     14h
End;

Function SerialStatus(PNum: Word): Word; Assembler;
Asm
    mov     ah,3
    mov     dx,PNum
    int     14h
End;

Function OpenFossil(PNum: Word) : Boolean; Assembler;
Asm
    mov     ah,4
    mov     bx,0
    mov     dx,PNum
    int     14h
    cmp     ax,1954h
    mov     ax,1
    je      @@1
    mov     ax,0
@@1:
End;

Procedure CloseFossil(PNum: Word); Assembler;
Asm
    mov     ah,5
    mov     dx,PNum
    int     14h
End;

Procedure SetDTR(PNum: Word; A: Boolean); Assembler;
Asm
    mov     ah,6
    mov     dx,PNum
    mov     al,BYTE(A)
    int     14h
End;

Procedure FlushOutput(PNum: Word); Assembler;
Asm
    mov     ah,8
    mov     dx,PNum
    int     14h
End;

Procedure PurgeOutput(PNum: Word); Assembler;
Asm
    mov     ah,9
    mov     dx,PNum
    int     14h
End;

Procedure PurgeInput(PNum: Word); Assembler;
Asm
    mov     ah,0Ah
    mov     dx,PNum
    int     14h
End;

(*
Function CarrierDetect(PNum: Word): Boolean; Assembler;
Asm
    mov     ah,3          { Reg.AH:=3;                         }
    mov     dx,PNum       { Reg.DX:=PNum;                      }
    int     14h           { Intr($14,Reg);                     }
    and     al,80h        { CarrierDetect:=(Reg.AL AND $80)>0; }
End;
*)

Function CarrierDetect(PNum: Word): Boolean;
Var Reg: Registers;
Begin
 Reg.AH:=3;
 Reg.DX:=PNum;
 Intr($14,Reg);
 CarrierDetect:=(Reg.AL AND $80)>0;
End;

Function SerialInput(PNum: Word): Boolean; Assembler;
Asm
    mov     ah,3
    mov     dx,PNum
    int     14h
    and     ah,1
    cmp     ah,0
    mov     al,1
    jg      @@1
    mov     al,0
@@1:
End;

Procedure WriteChar(C: Char); Assembler;
Asm
    mov     ah,13h
    mov     al,C
    int     14h
End;

Procedure FlowControl(PNum: Word; A: Byte); Assembler;
Asm
    mov     ah,0Fh
    mov     dx,PNum
    mov     al,A
    int     14h
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Miscellaneous Routines                                           }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure StuffKey(W: Word); {-Stuff one key into the keyboard buffer}
Const
 KbdStart      = $1E;
 KbdEnd        = $3C;
Var
 SaveKbdTail   : Word;
 KbdHead       : Word Absolute $0040:$001A;
 KbdTail       : Word Absolute $0040:$001C;
Begin
 SaveKbdTail:=KbdTail;
 If KbdTail=KbdEnd Then
  KbdTail:=KbdStart
 Else
  Inc(KbdTail,2);
 If KbdTail=KbdHead Then
  KbdTail:=SaveKbdTail
 Else
  MemW[$0040:SaveKbdTail]:=W;
End;

Function FPad(Unpadded: String; NumOfSpaces: Integer): String;
Var C: Integer;
Begin
 For C:=1 To NumOfSpaces-Length(UnPadded) Do Unpadded:=' '+Unpadded;
 FPad:=UnPadded;
End;

Procedure CursorOn; Assembler;
Asm
    mov     ax,1
    shl     ax,8
    mov     cx,7
    shl     cx,8
    add     cx,7
    int     10h
End;

Procedure CursorOff; Assembler;
Asm
    mov     ax,1
    shl     ax,8
    mov     cx,14
    shl     cx,8
    int     10h
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

Function Pad(Unpadded: String; NumOfSpaces: Integer): String;
Var C: Integer;
Begin
 For C:=1 To NumOfSpaces-Length(UnPadded) Do Unpadded:=Unpadded+' ';
 Pad:=UnPadded;
End;

Function LoCase(C: Char): Char;
Begin
 If C in ['A'..'Z'] Then
  C:=Chr(Ord(C)+32);
 LoCase:=C;
End;

Function UCase(UpString: String): String;
Var
 LtrNum        : Integer;
Begin
     LtrNum:=0;
     For LtrNum:=1 To Length(UpString) do
      UpString[LtrNum]:=UpCase(UpString[LtrNum]);
     UCase:=UpString;
End;

Function Capitalize(S: String): String;
Var Tmp: Byte;
Begin
 For Tmp:=1 To Length(S) Do
  If Not (S[Tmp] in ['A'..'Z','a'..'z','''']) Then
   S[Tmp+1]:=UpCase(S[Tmp+1])
  Else
   S[Tmp+1]:=LoCase(S[Tmp+1]);
 If Pos('BBS',UCase(S))>0 Then
  Begin
   S[Pos('BBS',UCase(S))]:='B';
   S[Pos('BBS',UCase(S))+1]:='B';
   S[Pos('BBS',UCase(S))+2]:='S';
  End;
 S[1]:=UpCase(S[1]);
 Capitalize:=S;
End;

Function CvtToInt(RealToRound: Real): Integer;
Begin
 If RealToRound>32766 Then RealToRound:=32766;
 CvtToInt:=Trunc(RealToRound);
End;

Function StrVal(IntNum: LongInt): String;
Var TS: String;
Begin
 Str(IntNum,TS);
 StrVal:=TS;
End;

Procedure CDelay(D: Word);
Var CTime: Real;
Begin
 CTime:=Timer+(D / 1000);
 Repeat
  If (LastSlice+IdleSlicing<=Timer) Then ReleaseSlice;
 Until Timer>=CTime;
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{ TurboCOMM Functions & Procedures                                           }
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Function Local: Boolean;
Begin
 Local:=(ComPort=0);
End;

Procedure RTC_Delay(microsecs:longint); { 1000000 microsecs = 1 second}
var r : registers;
begin
 r.ah := $86;                           {RTC function number}
 r.cx := microsecs shr 16;              {cx:dx = # of microseconds}
 r.dx := microsecs and $FFFF;
 intr($15,r);                           {call INT 15h (RTC)}
end;

Procedure SWriteChar(C: Char);
Begin
 If SimCPS<>0 Then RTC_Delay(SimCPS);
{ If (LastSlice+Slicing<=Timer) Then ReleaseSlice;}
 If Not Local Then TransmitChar(Port_Num,C);
 If C<>#7 Then ANSI_Write(C);
End;

Procedure SWrite(S: String);
Var I: Integer;
Begin
 For I:=1 To Length(S) Do SWriteChar(S[I]);
 If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
 If (EnableFlush) And (ComPort<>0) Then FlushOutput(Port_Num);
End;

Procedure SWriteLn(S: String);
Var I: Integer;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 S:=S+#13+#10;
 For I:=1 To Length(S) Do SWriteChar(S[I]);
 If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
 If (EnableFlush) And (ComPort<>0) Then FlushOutput(Port_Num);
End;

Function Remote_Keypressed: Boolean;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 If Local Then
  Remote_Keypressed:=False
 Else
  Remote_Keypressed:=(SerialInput(Port_Num));
End;

Function Local_Keypressed: Boolean;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 Local_Keypressed:=Keypressed;
End;

Function SKeypressed: Boolean;
Begin
 SKeypressed:=Remote_Keypressed;
End;

Procedure Remote_Screen(S: String);
Var I: Integer;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 If Not Local Then
  For I:=1 To Length(S) Do TransmitChar(Port_Num,S[I]);
End;

Procedure Disconnect;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 If Not Local Then
  Begin
   CDelay(400);
   SetDtr(Port_Num,False);
   CDelay(400);
   SetDtr(Port_Num,True);
   CDelay(400);
  End;
End;

Procedure ExitToBBS;
Var S: Real;
    R: Real;
    Ch: Char;
Begin
 If Not SingleLineStat Then
  Begin
   StatusWrite(1,'User will be returned to BBS.');
   StatusWrite(2,'Please press Y to confirm [10]');
  End Else StatusWrite(1,'Please press Y to confirm [10] (user will be returned to BBS)');
 S:=Timer;
 R:=Timer;
 Repeat
  If (LastSlice+IdleSlicing<=Timer) Then ReleaseSlice;
  If Timer>=R+1 Then
   Begin
    R:=Timer;
    If Not SingleLineStat Then
     StatusWrite(2,'Please press Y to confirm ['+StrVal(10-CvtToInt(R-S))+']')
    Else
     StatusWrite(1,'Please press Y to confirm ['+StrVal(10-CvtToInt(R-S))+'] (user will be returned to BBS)');
   End;
 Until (Keypressed) Or (CvtToInt(R-S)=11);
 If Keypressed Then Begin Ch:=ReadKey; If UpCase(Ch)<>'Y' Then Exit; End;
 If CvtToInt(R-S)=11 Then Exit;
 If Not SingleLineStat Then
  Begin
   StatusWrite(1,'Program terminated by SysOp!');
   StatusWrite(2,'Returning to BBS...');
  End Else StatusWrite(1,'Program terminated by SysOp, returning to BBS');
 CDelay(1500);
 Halt;
End;

Procedure BeepUser;
Begin
 StatusWrite(1,'Beep!');
 If Not SingleLineStat Then StatusWrite(2,'');
 Sound(500); Delay(20); Sound(1000); Delay(20); Sound(500); Delay(20); NoSound;
 Remote_Screen(^G);
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
End;

Procedure DisconnectUser;
Var S: Real;
    R: Real;
    Ch: Char;
Begin
 If Not SingleLineStat Then
  Begin
   StatusWrite(1,'User will be terminated.');
   StatusWrite(2,'Please press Y to confirm [10]');
  End Else StatusWrite(1,'Please press Y to confirm [10] (user will be disconnected)');
 S:=Timer;
 R:=Timer;
 Repeat
  If (LastSlice+IdleSlicing<=Timer) Then ReleaseSlice;
  If Timer>=R+1 Then
   Begin
    R:=Timer;
    If Not SingleLineStat Then
     StatusWrite(2,'Please press Y to confirm ['+StrVal(10-CvtToInt(R-S))+']')
    Else
     StatusWrite(1,'Please press Y to confirm ['+StrVal(10-CvtToInt(R-S))+'] (user will be disconnected)');
   End;
 Until (Keypressed) Or (CvtToInt(R-S)=11);
 If Keypressed Then Begin Ch:=ReadKey; If UpCase(Ch)<>'Y' Then Exit; End;
 If CvtToInt(R-S)=11 Then Exit;
 Disconnect;
 Halt;
End;

Function Back: Integer;
Var I: Integer;
    B: Integer;
Begin
 I:=0;
 B:=TextAttr;
 While B>16 Do Begin Dec(B,16); Inc(I); End;
 Back:=I;
End;

Function Fore: Integer;
Var B: Integer;
Begin
 B:=TextAttr;
 While B>16 Do Dec(B,16);
 Fore:=B;
End;

Procedure LineNoise;
Var C: Char;
    NCount: Integer;
Begin
 Randomize;
 For NCount:=1 To Random(64) Do
  Begin
   C:=Chr(Random(256));
   If C<>#7 Then SWrite(C);
  End;
End;

Procedure SaveScreen(Idx: Byte);
Begin
 If (Idx>10) Or (Idx=0) Then
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
    Move(Mem[$B000:0000],Screen,SizeOf(Screen))
   Else
    Move(Mem[$B800:0000],Screen,SizeOf(Screen));
  End;
End;

Procedure RestoreScreen(Idx: Byte);
Begin
 If (Idx>10) Or (Idx=0) Then
  Begin
   GotoXY(18,12);
   TextAttr:=$07;
   Write(' Restore_Screen ptr ',Idx,' out of range, cannot restore! ');
   Halt;
  End;
 With Saved[Idx]^ Do
  Begin
   If (Mem[0000:$0449] = $7) Then
    Move(Screen,Mem[$B000:0000],SizeOf(Screen))
   Else
    Move(Screen,Mem[$B800:0000],SizeOf(Screen));
   WindMin:=WndMin;
   WindMax:=WndMax;
   GotoXY(X,Y);
   TextAttr:=TxtAttr;
  End;
 Dispose(Saved[Idx]);
End;

Procedure DOSShell;
Var D: Word;
Begin
 SWriteLn(ANSICode[15]+StartShell);
 SaveScreen(DefaultSave);
 SwapVectors;
 Exec(GetEnv('COMSPEC'),'');
 SwapVectors;
 D:=DOSError;
 RestoreScreen(DefaultSave);
 If D<>0 Then
  Write('DOS Error: ',D);
 SWriteLn(ANSICode[15]+EndShell);
End;

Procedure ChatMode;
Var
 Times,
 LineChars     : Integer;
 KeyPress,
 TempChar      : Char;
 NextLine,
 CurrLine      : String;
 LastLocal     : Boolean;

Begin
 If InChat Or (Not ChatOK) Then Exit;
 InChat:=True;
 LineChars:=0; LastLocal:=True;
 NextLine:=''; CurrLine:='';
 If ANSI Then SWrite(Off+ANSICode[15]);
 SWriteLn(''); SWriteLn(StartChat); SWriteLn('');
 If ANSI Then SWrite(ANSICode[9]);
 Repeat
  KeyPress:=SReadKey;
  If LocalChar Then
   Begin;
    If KeyPress=#8 Then
     Begin
      If LineChars>0 Then
       Begin
        SWrite(#8' '#8);
        LineChars:=LineChars-1;
        Delete(CurrLine,Length(CurrLine),1);
       End;
     End;
    If KeyPress=#13 Then
     Begin
      SWrite(#13#10);
      LineChars:=0;
      CurrLine:='';
      If NextLine<>'' Then
       Begin
        CurrLine:=NextLine;
        NextLine:='';
        LineChars:=Length(CurrLine);
        SWrite(CurrLine);
       End;
     End;
    If KeyPress<>#27 Then
     Begin
      If (KeyPress>=#32) And (KeyPress<=#126) Then
       Begin
        If (Not LastLocal) And (ANSI) Then SWrite(ANSICode[9]);
        SWrite(Keypress);
        LineChars:=LineChars+1;
        CurrLine:=CurrLine+KeyPress;
        If LineChars=79 Then
         Begin
          Repeat
           If Pos(' ',CurrLine)>0 Then
            Begin
             SWrite(#8' '#8);
             TempChar:=CurrLine[Length(CurrLine)];
             Delete(CurrLine,Length(CurrLine),1);
             NextLine:=TempChar+NextLine;
            End;
          Until CurrLine[Length(CurrLine)]=' ';
          LineChars:=0;
          CurrLine:='';
          CurrLine:=NextLine;
          NextLine:='';
          LineChars:=Length(CurrLine);
          SWrite(#13#10+CurrLine);
         End;
       End;
     End;
   End;
  If RemoteChar Then
   Begin
    If KeyPress=#8 Then
     Begin
      If LineChars>0 Then
       Begin
        SWrite(#8' '#8);
        LineChars:=LineChars-1;
        Delete(CurrLine, Length(CurrLine), 1);
       End;
     End;
    If KeyPress=#13 Then
     Begin
      SWrite(#13#10);
      LineChars:=0;
      CurrLine:='';
      If NextLine<>'' Then
       Begin
        CurrLine:=NextLine;
        NextLine:='';
        LineChars:=Length(CurrLine);
        SWrite(CurrLine);
       End;
     End;
    If (KeyPress>=#32) And (KeyPress<=#126) Then
     Begin
      If (LastLocal) And (ANSI) Then SWrite(ANSICode[9]);
      SWrite(Keypress);
      LineChars:=LineChars+1;
      CurrLine:=CurrLine+KeyPress;
      If LineChars = 79 Then
       Begin
        Repeat
         If Pos(' ',CurrLine) > 0 Then
          Begin
           SWrite(#8#32#8);
           TempChar:=CurrLine[Length(CurrLine)];
           Delete(CurrLine, Length(CurrLine), 1);
           NextLine:=TempChar+NextLine;
          End;
        Until CurrLine[Length(CurrLine)]=' ';
        LineChars:=0;
        CurrLine:='';
        CurrLine:=NextLine;
        NextLine:='';
        LineChars:=Length(CurrLine);
        SWrite(#13#10+CurrLine);
       End;
     End;
   End;
 Until (KeyPress=#27) And (LocalChar);
 If ANSI Then SWrite(ANSICode[15]);
 SWriteLn(''); SWriteLn(EndChat); SWriteLn('');
 InChat:=False;
End;

Function Zero(I: LongInt; Z: Byte): String;
Var S: String;
Begin
 S:=StrVal(I); While Length(S)<Z Do S:='0'+S; Zero:=S;
End;

Function SReadKey: Char;
Var
 StartTimer: Real;
 Beeped: Boolean;
 Ch1: Char;
 Tmp: Integer;
 Now: Real;
Label ReadStart,GetFnKey;
Begin
 ReadStart:
 Beeped:=False;
 Now:=Timer;
 StartTimer:=Now;
 Repeat
  Now:=Timer;
  If (LastSlice+IdleSlicing<=Now) Then ReleaseSlice;
  If (Now>=LastUpdate+UpdateSeconds) Then UpdateStatus(False);
  If (Now>=StartTimer+TimeoutDelay) And (TimeCheck) And (Not Beeped) Then
   Begin
    If ANSI Then SWrite(Off+ANSICode[12]);
    SWrite(#13+#7+TwentySec);
    Beeped:=True;
   End;
  If (Now>=StartTimer+TimeoutDelay+20) And (TimeCheck) Then
   Begin
    SWrite(#13+#7+InactiveExiting);
    Disconnect;
    Halt;
   End;
 Until (Remote_Keypressed) Or (Local_Keypressed);
 If Remote_Keypressed Then
  Begin
   Ch1:=ReceiveChar(Port_Num);
   SReadKey:=Ch1;
   RemoteChar:=True;
   LocalChar:=False;
  End
  Else
  Begin
   Ch1:=ReadKey;
   RemoteChar:=False;
   LocalChar:=True;
   If Ch1=#0 Then
    Begin
     GetFnKey:
     Ch1:=ReadKey;
     Case Ch1 Of
       'H': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('A')); End;
       'P': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('B')); End;
       'M': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('C')); End;
       'K': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('D')); End;
       'G': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('H')); End;
       'O': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('K')); End;
       'I': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('r')); End;
       'Q': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('q')); End;
       #59 { F1 }: Begin StatBar:=1; UpdateStatus(True); End;
       #60 { F2 }: Begin StatBar:=2; UpdateStatus(True); End;
       #61 { F3 }: Begin StatBar:=3; UpdateStatus(True); End;
       #62 { F4 }: ExitToBBS;
       #63 { F5 }: BeepUser;
       #64 { F6 }: DisconnectUser;
       #65 { F7 }: LineNoise;
       #66 { F8 }: ShellProcedure;
       #67 { F9 }: If Not SingleLineStat Then
                   Begin
                    Repeat
                     Case Multitasker Of
                       NoTasker: StatusWrite(1,'Tasker: [None] DESQview  DoubleDOS  Windows  OS/2  NetWare  ³ Z/X to change ');
                       DESQview: StatusWrite(1,'Tasker:  None [DESQview] DoubleDOS  Windows  OS/2  NetWare  ³ Z/X to change ');
                       DoubleDOS:StatusWrite(1,'Tasker:  None  DESQview [DoubleDOS] Windows  OS/2  NetWare  ³ Z/X to change ');
                       Windows:  StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS [Windows] OS/2  NetWare  ³ Z/X to change ');
                       OS2:      StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS  Windows [OS/2] NetWare  ³ Z/X to change ');
                       NetWare:  StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS  Windows  OS/2 [NetWare] ³ Z/X to change ');
                      End;
                     StatusWrite(2,'Slices: Released every '+Zero(CvtToInt(Slicing*100),3)+'/100 seconds       '+
                                   '[USER ON HOLD] ³ +/- to change');
                     StatusWriteXY(47,25,$9A,'USER ON HOLD');
                     Ch1:=UpCase(ReadKey);
                     Case Ch1 Of
                       '+': Begin Slicing:=Slicing+0.05; If Slicing>9.99 Then Slicing:=9.99; End;
                       '-': Begin Slicing:=Slicing-0.05; If Slicing<0.05 Then Slicing:=0.05; End;
                       'X': If Multitasker<>NetWare Then Inc(Multitasker);
                       'Z': If Multitasker<>NoTasker Then Dec(Multitasker);
                      End;
                    Until (Ch1=#13) Or (Ch1=#27) Or (Ch1=#00);
                    If Multitasker<>NoTasker Then Multitasking:=True Else Multitasking:=False;
                    If Ch1=#00 Then Goto GetFnKey;
                   End;
       #68 { F10 }: ChatProcedure;
      End;
     Goto ReadStart;
    End
    Else
    Begin
     SReadKey:=Ch1;
    End;
  End;
End;

Function Remote_ReadKey: Char;
Var
 StartTimer: Real;
 Beeped: Boolean;
 Ch1: Char;
 Tmp: Integer;
 Now: Real;
Label ReadStart,GetFnKey;
Begin
 ReadStart:
 Beeped:=False;
 Now:=Timer;
 StartTimer:=Now;
 Repeat
  Now:=Timer;
  If (LastSlice+IdleSlicing<=Now) Then ReleaseSlice;
  If (Now>=LastUpdate+UpdateSeconds) Then UpdateStatus(False);
  If (Now>=StartTimer+TimeoutDelay) And (TimeCheck) And (Not Beeped) Then
   Begin
    If ANSI Then SWrite(Off+ANSICode[12]);
    SWrite(#13+#7+TwentySec);
    Beeped:=True;
   End;
  If (Now>=StartTimer+TimeoutDelay+20) And (TimeCheck) Then
   Begin
    SWrite(#13+#7+InactiveExiting);
    Disconnect;
    Halt;
   End;
 Until (Remote_Keypressed) Or (Local_Keypressed);
 If Remote_Keypressed Then
  Begin
   Ch1:=ReceiveChar(Port_Num);
   Remote_ReadKey:=Ch1;
   RemoteChar:=True;
   LocalChar:=False;
  End
  Else
  Begin
   Ch1:=ReadKey;
   RemoteChar:=False;
   LocalChar:=True;
   If Ch1=#0 Then
    Begin
     GetFnKey:
     Ch1:=ReadKey;
     Case Ch1 Of
       'H': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('A')); End;
       'P': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('B')); End;
       'M': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('C')); End;
       'K': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('D')); End;
       'G': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('H')); End;
       'O': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('K')); End;
       'I': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('r')); End;
       'Q': If LocalANSIKeys Then Begin StuffKey(27); StuffKey(Ord('[')); StuffKey(Ord('q')); End;
       #59 { F1 }: Begin StatBar:=1; UpdateStatus(True); End;
       #60 { F2 }: Begin StatBar:=2; UpdateStatus(True); End;
       #61 { F3 }: Begin StatBar:=3; UpdateStatus(True); End;
       #62 { F4 }: ExitToBBS;
       #63 { F5 }: BeepUser;
       #64 { F6 }: DisconnectUser;
       #65 { F7 }: LineNoise;
       #66 { F8 }: ShellProcedure;
       #67 { F9 }: If Not SingleLineStat Then
                   Begin
                    Repeat
                     Case Multitasker Of
                       NoTasker: StatusWrite(1,'Tasker: [None] DESQview  DoubleDOS  Windows  OS/2  NetWare  ³ Z/X to change ');
                       DESQview: StatusWrite(1,'Tasker:  None [DESQview] DoubleDOS  Windows  OS/2  NetWare  ³ Z/X to change ');
                       DoubleDOS:StatusWrite(1,'Tasker:  None  DESQview [DoubleDOS] Windows  OS/2  NetWare  ³ Z/X to change ');
                       Windows:  StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS [Windows] OS/2  NetWare  ³ Z/X to change ');
                       OS2:      StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS  Windows [OS/2] NetWare  ³ Z/X to change ');
                       NetWare:  StatusWrite(1,'Tasker:  None  DESQview  DoubleDOS  Windows  OS/2 [NetWare] ³ Z/X to change ');
                      End;
                     StatusWrite(2,'Slices: Released every '+Zero(CvtToInt(Slicing*100),3)+'/100 seconds       '+
                                   '[USER ON HOLD] ³ +/- to change');
                     StatusWriteXY(47,25,$9A,'USER ON HOLD');
                     Ch1:=UpCase(ReadKey);
                     Case Ch1 Of
                       '+': Begin Slicing:=Slicing+0.05; If Slicing>9.99 Then Slicing:=9.99; End;
                       '-': Begin Slicing:=Slicing-0.05; If Slicing<0.05 Then Slicing:=0.05; End;
                       'X': If Multitasker<>NetWare Then Inc(Multitasker);
                       'Z': If Multitasker<>NoTasker Then Dec(Multitasker);
                      End;
                    Until (Ch1=#13) Or (Ch1=#27) Or (Ch1=#00);
                    If Multitasker<>NoTasker Then Multitasking:=True Else Multitasking:=False;
                    If Ch1=#00 Then Goto GetFnKey;
                   End;
       #68 { F10 }: ChatProcedure;
      End;
     Goto ReadStart;
    End
    Else
    Begin
     Goto ReadStart; { Don't return SysOp's characters }
    End;
  End;
End;

Procedure SClrScr;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 If ANSI Then SWrite('[2J') Else SWrite(#12);
End;

Procedure SaveColors;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 SFore:=Fore;
 SBack:=Back;
End;

Procedure RestoreColors;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 If ANSI Then
  Begin
   SWrite(ANSICode[SFore]+ANSICode[SBack+40]);
  End;
End;

Procedure STextColor(C: Integer);
Var
 A: Byte;
 O: Byte;
Begin
 O:=0;
 A:=TextAttr;
 While A>15 do Begin Dec(A,16); Inc(O); End;
 If ANSI Then Begin SWrite(ANSICode[C]); If O>0 Then SWrite(ANSICode[40+O]); End;
End;

Procedure STextBackground(C: Integer);
Begin
 If ANSI Then SWrite(ANSICode[40+C]);
End;

Procedure SColor(ForeC,BackC: Integer);
Begin
 STextColor(ForeC);
 STextBackground(BackC);
End;

Function StrNoZero(L: LongInt): String;
Var S: String;
Begin
 If L>0 Then S:=StrVal(L) Else S:='';
 StrNoZero:=S;
End;

Procedure SRead(Var S: String; Len: Byte; Default: String);
Var
 C: Char;
 I: Integer;
 InsertPos: Byte;
 Hold: String;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 SaveColors; S:=Default; If CapitalizeON Then S:=Capitalize(S);
 If ANSI Then Begin SColor(InputFore,InputBack); SWrite(Pad('',Len)+#27+'['+StrNoZero(Len)+'D'); End;
 InsertPos:=Length(S)+1;
 SWrite(S);
 Repeat;
  C:=SReadKey;
  Case C Of
    #27      : If SReadANSIKeys Then
                Begin
                 If Not (Remote_Keypressed Or Local_Keypressed) Then CDelay(200);
                 If (Local_Keypressed Or Remote_Keypressed) And (SReadKey='[') Then
                  Begin
                   Case SReadKey Of
                     'D': If InsertPos<>1 Then Begin Dec(InsertPos); SWrite(#8); End;
                     'C': If InsertPos<=Length(S) Then Begin Inc(InsertPos); SWrite('[C'); End;
                     'H': Begin
                           If InsertPos>1 Then SWrite('['+StrNoZero(InsertPos-1)+'D');
                           InsertPos:=1;
                          End;
                     'K',
                     'R': Begin
                           If InsertPos<>Length(S)+1 Then SWrite('['+StrNoZero(Length(S)-InsertPos+1)+'C');
                           InsertPos:=Length(S)+1;
                          End;
                    End;
                  End;
                End;
    #32..#126: Begin
                If ((S='') Or (S[Length(S)]=' ')) And (CapitalizeON) Then
                 C:=UpCase(C);
                If Length(S)<Len Then
                 Begin
                  Insert(C,S,InsertPos);
                  Hold:=Copy(S,InsertPos,255);
                  If Hold[0]>#1 Then
                   SWrite(Hold+'['+StrNoZero(Length(Hold)-1)+'D')
                  Else
                  If Hold[0]=#1 Then
                   SWrite(Hold);
                  Inc(InsertPos);
                 End;
                End;
    #127..#255: Begin
                If (Length(S)<Len) And (SReadHighBit) Then
                 Begin
                  Insert(C,S,InsertPos);
                  Hold:=Copy(S,InsertPos,255);
                  If Hold[0]>#1 Then
                   SWrite(Hold+'['+StrNoZero(Length(Hold)-1)+'D')
                  Else
                  If Hold[0]=#1 Then
                   SWrite(Hold);
                  Inc(InsertPos);
                 End;
               End;
    #8       : If (InsertPos>1) Then
                Begin
                 Dec(InsertPos);
                 Delete(S,InsertPos,1);
                 Hold:=Copy(S,InsertPos,255);
                 If Hold<>'' Then
                  SWrite(#8+Hold+' ['+StrNoZero(Length(Hold)+1)+'D')
                 Else
                  SWrite(#8#32#8);
                End;
    #25      : Begin
                Hold:=Copy(S,InsertPos,255);
                If Hold<>'' Then SWrite('['+StrNoZero(Length(Hold))+'C');
                For I:=1 To Length(S) Do SWrite(#8+' '+#8);
                S:=''; InsertPos:=1;
               End;
   End;
 Until C=#13;
 RestoreColors;
 SReadHighBit:=False;
End;

Procedure SReadLn(Var S: String; Len: Byte; Default: String);
Begin
 SRead(S,Len,Default);
 SWriteLn('');
End;

Procedure SReadNum(Var S: String; Max, Default: String);
Var
 C: Char;
 I: Integer;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 SaveColors;
 S:=Default;
 If CapitalizeON Then S:=Capitalize(S);
 If S='0' Then S:='';
 If ANSI Then
  Begin
   SWrite(ANSICode[InputBack+40]+ANSICode[InputFore]+Pad('',Length(Max)));
   SWrite(#27'['+StrVal(Length(Max))+'D');
  End;
 SWrite(S);
 Repeat;
  C:=SReadKey;
  Case C Of
    '0'..'9': If Not ((C='0') And ((S='0') or (S=''))) Then
               Begin
                If LIntVal(S+C)<=LIntVal(Max) Then
                 Begin S:=S+C; SWrite(C); End;
               End;
    #8      : If (Length(S)>0) Then
               Begin
                Delete(S,Length(S),1);
                SWrite(#8' '#8);
               End;
    #25     : Begin
               For I:=1 To Length(S) Do SWrite(#8+' '+#8);
               S:='';
              End;
    '>'     : If UseMaxKey Then
               Begin
                For I:=1 To Length(S) Do SWrite(#8+' '+#8);
                S:=Max;
                SWrite(S);
               End;
   End;
 Until C=#13;
 RestoreColors;
 If S='' Then S:='0';
End;

Procedure SReadNeg(Var S: String; Min, Max, Default: String);
Var
 C: Char;
 I: Integer;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 SaveColors;
 S:=Default;
 If CapitalizeON Then S:=Capitalize(S);
 If ANSI Then
  Begin
   SWrite(ANSICode[InputBack+40]+ANSICode[InputFore]+Pad('',Length(Max)));
   SWrite(#27'['+StrVal(Length(Max))+'D');
  End;
 SWrite(S);
 Repeat;
  C:=SReadKey;
  If Pos(C,'1234567890-')>0 Then
   Begin
    If (IntVal(S+C)<=IntVal(Max)) And (IntVal(S+C)>=IntVal(Min)) Then
     Begin S:=S+C; SWrite(C); End;
   End;
  If (C=#8) And (Length(S)>0) Then
   Begin
    Delete(S,Length(S),1);
    SWrite(#8+' '+#8);
   End;
  If C=#25 Then
   Begin
    For I:=1 To Length(S) Do SWrite(#8+' '+#8);
    S:='';
   End;
 Until C=#13;
 RestoreColors;
End;

Procedure ConcealedSReadLn(Var S: String; Len: Byte; Default: String);
Var
 C: Char;
 I: Integer;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 SaveColors; S:=Default; If CapitalizeON Then S:=Capitalize(S);
 If ANSI Then Begin SColor(InputFore,InputBack); SWrite(Pad('',Len)+#27+'['+StrVal(Len)+'D'); End;
 SWrite(S);
 Repeat;
  C:=SReadKey;
  Case C Of
    #32..#255: Begin
                If ((S='') Or (S[Length(S)]=' ')) And (CapitalizeON) Then
                 C:=UpCase(C);
                If Length(S)<Len Then Begin S:=S+C; SWrite('*'); End;
               End;
    #8       : If (Length(S)>0) Then
                Begin
                 Delete(S,Length(S),1);
                 SWrite(#8' '#8);
                End;
    #25      : Begin
                For I:=1 To Length(S) Do SWrite(#8+' '+#8);
                S:='';
               End;
   End;
 Until C=#13;
 SWriteLn(''); RestoreColors;
End;

Procedure SGotoXY(X,Y: Integer);
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 GotoXY(X,Y);
 Remote_Screen(#27+'['+StrVal(Y)+';'+StrVal(X)+'H');
End;

Procedure SClrEol;
Begin
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 ClrEol;
 Remote_Screen(#27+'[K');
End;

Procedure StatusWrite(Bar: Byte; S: String);
Var
 OX,OY,OC: Byte;
Begin
 CursorOff;
 OC:=TextAttr;
 OX:=WhereX; OY:=WhereY;
 TextColor(15); TextBackground(1);
 Window(1,1,80,25);
 If (Bar=1) Then
  Begin
   If Not SingleLineStat Then GotoXY(1,24) Else GotoXY(1,25);
   Write('                                                                               ');
   If Not SingleLineStat Then GotoXY(1,24) Else GotoXY(1,25);
   Write(S);
  End;
 If (Bar=2) And (Not SingleLineStat) Then
  Begin
   GotoXY(1,25);
   Write('                                                                               ');
   GotoXY(1,25);
   Write(S);
  End;
 If Not SingleLineStat Then
  Window(1,1,80,23)
 Else
  Window(1,1,80,24);
 CursorOn;
 TextAttr:=OC;
 GotoXY(OX,OY);
End;

Procedure StatusWriteXY(X,Y,A: Byte; S: String);
Var
 OX,OY,OC: Byte;
Begin
 CursorOff;
 OC:=TextAttr;
 OX:=WhereX; OY:=WhereY;
 Window(1,1,80,25);
 TextAttr:=A;
 GotoXY(X,Y); Write(S);
 If Not SingleLineStat Then
  Window(1,1,80,23)
 Else
  Window(1,1,80,24);
 CursorOn;
 TextAttr:=OC;
 GotoXY(OX,OY);
End;

(* Wierdo time calculation routines *)

Function LZ(I: LongInt): String;
Var Out: String;
Begin
 Out:=StrVal(I); If Length(Out)=1 Then Out:='0'+Out;
 If Length(Out)>2 Then Out[0]:=#2;
 LZ:=Out;
End;

Function FormatTime(Rl: Real): String;
Var H,M,S: String;
Begin
 S:=LZ(Trunc(Rl-Int(Rl/60.0)*60.0));
 M:=LZ(Trunc(Int(Rl/60.0)-Int(Rl/3600.0)*60.0));
 If Trunc(Rl/3600.0)>12 Then H:=LZ(Trunc(Rl/3600.0)-12)
 Else H:=LZ(Trunc(Rl/3600.0));
 FormatTime:=H+':'+M+':'+S;
End;

Function Nsl: Real;
Begin
 If Timer<Timeon Then
  Timeon:=Timeon-24.0*3600.0;
 Nsl:=Timeleft-(Timer-Timeon);
End;

Procedure DisplayFile(F: String);
Var T: Text;
Begin
 Assign(T,F);
 {$I-} Reset(T); {$I+}
 If IOresult<>0 Then
  Begin
   WriteLn('Cannot find file: ',F);
   Exit;
  End;
 While Not Eof(T) Do
  Begin
   ReadLn(T,F);
   SWriteLn(F);
  End;
 Close(T);
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

Function UnpackedDT(L: LongInt): String;
Var DT: DateTime;
Begin
 UnPackTime(L,DT);
 UnpackedDT:=LZ(DT.Month)+'/'+LZ(DT.Day)+'/'+LZ(DT.Year-1900)+
            ' '+LZ(DT.Hour)+':'+LZ(DT.Min)+':'+LZ(DT.Sec);
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

Procedure ErrorHandler;
Type SOType = Record wOfs,wSeg: Word; End;
Var
 NW,
 ErrCode: Word;
 ErrStr: String;
 ErrSeg,ErrOfs: Word;
 ErrLog: Text;
 SR: SearchRec;
 UDT: String[40];
 DumpFile: File;
 VidSeg: Word;
Begin
 ErrSeg:=SOType(ErrorAddr).wSeg;
 ErrOfs:=SOType(ErrorAddr).wOfs;
 If (ErrSeg=0) And (ErrOfs=0) Then Exit;
 ErrorAddr:=Nil;
 ErrCode:=ExitCode; ExitCode:=ErrorExitCode;
 Case ErrCode Of
   000: ErrStr:=('This shouldn''t happen');
   001: ErrStr:=('Invalid function number');
   002: ErrStr:=('File not found');
   003: ErrStr:=('Path not found');
   004: ErrStr:=('Too many open files');
   005: ErrStr:=('File access denied');
   006: ErrStr:=('Invalid file handle');
   012: ErrStr:=('Invalid file access code');
   015: ErrStr:=('Invalid drive number');
   016: ErrStr:=('Cannot remove current directory');
   017: ErrStr:=('Cannot rename across drives');
   018: ErrStr:=('No more files');
   100: ErrStr:=('Disk read error');
   101: ErrStr:=('Disk write error');
   102: ErrStr:=('File not assigned');
   103: ErrStr:=('File not open');
   104: ErrStr:=('File not open for input');
   105: ErrStr:=('File not open for output');
   106: ErrStr:=('Invalid numeric format');
   150: ErrStr:=('Disk is write-protected');
   151: ErrStr:=('Bad drive request struct length');
   152: ErrStr:=('Drive not ready');
   154: ErrStr:=('CRC error in data');
   156: ErrStr:=('Disk seek error');
   157: ErrStr:=('Unknown media type');
   158: ErrStr:=('Sector Not Found');
   159: ErrStr:=('Printer out of paper');
   160: ErrStr:=('Device write fault');
   161: ErrStr:=('Device read fault');
   162: ErrStr:=('Hardware failure');
   200: ErrStr:=('Division by zero');
   201: ErrStr:=('Range check error');
   202: ErrStr:=('Stack overflow error');
   203: ErrStr:=('Heap overflow error');
   204: ErrStr:=('Invalid pointer operation');
   205: ErrStr:=('Floating point overflow');
   206: ErrStr:=('Floating point underflow');
   207: ErrStr:=('Invalid floating point operation');
   208: ErrStr:=('Overlay manager not installed');
   209: ErrStr:=('Overlay file read error');
   210: ErrStr:=('Object not initialized');
   211: ErrStr:=('Call to abstract method');
   212: ErrStr:=('Stream registration error');
   213: ErrStr:=('Collection index out of range');
   214: ErrStr:=('Collection overflow error');
   215: ErrStr:=('Arithmetic overflow error');
   216: ErrStr:=('General Protection fault');
  End;
 UDT:=UnpackedDT(CurrentDT);
 If (Mem[0000:$0449] = $7) Then VidSeg:=$B000 Else VidSeg:=$B800;
 Assign(DumpFile,ErrorSnapshot);
 Assign(ErrLog,ErrorLog);
 {$I-}
 FindFirst(ErrorSnapshot,AnyFile,SR);
 If DOSError=0 Then Reset(DumpFile,1) Else ReWrite(DumpFile,1); If IOResult<>0 Then;
 Seek(DumpFile,FileSize(DumpFile)); If IOResult<>0 Then;
 BlockWrite(DumpFile,Mem[VidSeg:0000],4000,NW);
 FindFirst(ErrorLog,AnyFile,SR);
 If DOSError=0 Then Append(ErrLog) Else ReWrite(ErrLog); If IOResult<>0 Then;
 WriteLn(ErrLog,'Error Date: ',Copy(UDT,1,8)); If IOResult<>0 Then;
 WriteLn(ErrLog,'Error Time: ',Copy(UDT,10,255)); If IOResult<>0 Then;
 WriteLn(ErrLog,'Error Code: ',Zero(ErrCode,3)); If IOResult<>0 Then;
 WriteLn(ErrLog,'Error Addr: ',HexW(ErrSeg),':',HexW(ErrOfs)); If IOResult<>0 Then;
 WriteLn(ErrLog,'Error FPtr: ',FileSize(DumpFile) Div 4000 - 1);
 WriteLn(ErrLog,'Error Data: CX@',LZ(WhereX),'/CY@',LZ(WhereY),'/TA=',LZ(TextAttr));
 WriteLn(ErrLog,'--------------------------------------------------------------------------------'); If IOResult<>0 Then;
 Close(ErrLog); If IOResult<>0 Then;
 Close(DumpFile); If IOResult<>0 Then;
 {$I+}

 ClrScr;
 TextAttr:=$01; Write('ÄÄ'); TextAttr:=$09; Write('['); TextAttr:=$0F; Write('Runtime Error'); TextAttr:=$09; Write(']');
 TextAttr:=$01; WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 TextAttr:=$09; Write(' ş '); TextAttr:=$0F; Write('Error #'+Zero(ErrCode,3)+' at '+HexW(ErrSeg)+':'+HexW(ErrOfs)+' - ');
 WriteLn(ErrStr);
 TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Please report this to the author!');
 TextAttr:=$01; WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
End;

{$F+} Procedure TurboCOM_Terminate; {$F-}
Begin
 If HookErrorHandler Then ErrorHandler;
 If Not Local Then
  Begin
   FlushOutput(Port_Num);
   CloseFossil(Port_Num);
  End;
 If ProgLocked Then UnlockProgram;
 ExitProc:=ExitSave;
End;

Function CarrierDetected: Boolean;
Begin
 If Local Then
  CarrierDetected:=True
 Else
  CarrierDetected:=CarrierDetect(Port_Num);
End;

Procedure UpdateStatus(Forced: Boolean);
Var
 PN: String;
 OX,OY: Integer;
 I: Integer;
 H,M,S: Real;
 S1: String;
 Now,
 Elapsed: Real;
Begin
 If Not Initialized Then
  Begin
   WriteLn;
   WriteLn('TurboCOMM Error:');
   WriteLn;
   WriteLn('Please initialize program using InitTurboCOMM procedure.');
   WriteLn('TurboCOMM functions cannot be used until this procedure is called.');
   WriteLn;
   Halt;
  End;

 If Nsl<=0 Then
  Begin
   LimitExceeded:='[0m[1;31m'+#13+#10+LimitExceeded+#13+#10;
   If Not Local Then
    For I:=1 To Length(LimitExceeded) Do TransmitChar(Port_Num,LimitExceeded[I]);
   ANSI_Write_Str(LimitExceeded);
   CDelay(MessageDelay);
   Halt;
  End;

 If Nsl>(OldSlCount+2) Then OldSlCount:=Nsl;
 If (CarrierCheck) And (Not CarrierDetected) Then
  Begin
   If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
   If Not SingleLineStat Then
    Begin
     StatusWrite(1,CarrierLoss);
     StatusWrite(2,' ş Exiting...');
    End
    Else
     StatusWrite(1,CarrierLoss+', exiting...');
   CDelay(MessageDelay);
   Halt;
  End;
 If Not ProhibitStatus Then
  Begin
   If Not SingleLineStat Then
    Begin
     Case StatBar Of
       1: Begin
           If ShowSeconds Then
            StatusWrite(1,Pad(UserName,54)+'[F3=Help] Time: '+FormatTime(Nsl))
           Else
            StatusWrite(1,Pad(UserName,54)+'[F3=Help] Time:    '+Copy(FormatTime(Nsl),1,5));
           PN:=ProgName;
           If (PN<>'') Then PN:=PN+' (Node '+Strval(NodeNum)+')' Else PN:='Node: '+StrVal(NodeNum);
           StatusWrite(2,Pad(PN,61-Length(MT))+'['+MT+'] BPS : '+FPad(StrVal(BaudRate),8));
          End;
       2: Begin
           If ANSI Then S1:='On' Else S1:='Off';
           StatusWrite(1,'Location: '+Pad(UserLocation,54)+'ANSI: '+FPad(S1,8));
           If Not Local Then I:=ComPort+1 Else I:=ComPort;
           StatusWrite(2,'Security: '+Pad(StrVal(Security),54)+'Port: '+FPad(StrVal(I),8));
          End;
       3: Begin
           StatusWrite(1,' F1 Info Bar    F2 Info Bar 2  F3 Hotkeys     F4 Forced Exit   F5 Beep User');
           StatusWrite(2,' F6 Disconnect  F7 Line Noise  F8 DOS Shell   F9 Tasker Setup  F10 Chat Mode');
          End;
      End;
    End
    Else
    Begin
     Case StatBar Of
       1: Begin
           If ShowSeconds Then
            StatusWrite(1,Pad(' '+ProgName+': '+UserName+' (Node '+
                        StrVal(NodeNum)+')',71)+FormatTime(Nsl))
           Else
            StatusWrite(1,Pad(' '+ProgName+': '+UserName+' (Node '+
                        StrVal(NodeNum)+')',74)+Copy(FormatTime(Nsl),1,5));
          End;
       2: Begin
           If Not Local Then I:=ComPort+1 Else I:=ComPort;
           StatusWrite(1,'Location: '+Pad(UserLocation,49)+'Sec: '+Pad(StrVal(Security),5)+'  Port: '+StrVal(I));
          End;
       3: Begin
           StatusWrite(1,'FKey: 1=Info1 2=Info2 3=Help 4=Exit 5=Beep 6=Hangup 7=Noise 8=Shell 10=Chat');
          End;
      End;
    End;
  End;
 Now:=Timer;
 LastUpdate:=Now;
 If (LastSlice+Slicing<=Now) Then ReleaseSlice;
End;

Function LockProgram(LockFile: String): Integer;
Var F: Text;
    S: String;
    FTime: LongInt;
    CDT,FDT: DateTime;
    Tmp: Word;
Begin
 LockProgram:=0;
 LockFilename:=ParamStr(0);
 While LockFilename[Length(LockFilename)]<>'\' Do
  Delete(LockFilename,Length(LockFilename),1);
 LockFilename:=LockFilename+LockFile;
 Assign(F,LockFilename);
 {$I-} Reset(F); {$I+}
 If IOResult=0 Then
  Begin
   GetFTime(F,FTime);
   UnpackTime(FTime,FDT);
   GetTime(CDT.Hour,CDT.Min,CDT.Sec,Tmp);
   GetDate(CDT.Year,CDT.Month,CDT.Day,Tmp);
   If (FDT.Year=CDT.Year) And (FDT.Month=CDT.Month) And (FDT.Day=CDT.Day) Then
    Begin
     S:='';
     {$I-}
     ReadLn(F,S); InOutRes:=0;
     ReadLn(F,S); InOutRes:=0;
     ReadLn(F,S); InOutRes:=0;
     ReadLn(F,S); InOutRes:=0;
     ReadLn(F,S); InOutRes:=0;
     ReadLn(F,S); InOutRes:=0;
     {$I+}
     Close(F);
     If IntVal(S)>0 Then
      LockProgram:=IntVal(S)
     Else
      LockProgram:=255;
     Exit; { Got a lock on the program, dont enter it }
    End;
   Close(F);
  End;
 ReWrite(F);
 ProgLocked:=True;
 WriteLn(F,ProgName+' is in use on node '+StrVal(NodeNum)+'.');
 WriteLn(F,'This file has been placed to stop multiple copies of '+ProgName);
 WriteLn(F,'from being used at the same time.  If another copy of '+ProgName);
 WriteLn(F,'is not currently in use on the specified node, please erase this file');
 WriteLn(F,'immediately.  Otherwise, please do not alter or remove it.');
 WriteLn(F,NodeNum);
 Close(F);
End;

Procedure UnlockProgram;
Var F: Text;
    FTime: LongInt;
    CDT,FDT: DateTime;
    Tmp: Word;
Begin
 Assign(F,LockFilename);
 {$I-} Erase(F); {$I+}
 If IOresult<>0 Then ;
End;

Function CW(C: Char; Seed: ShortInt): Char;
Var I: LongInt;
Begin
 I:=Ord(C)+Seed;
 If (Seed>0) Then
  Begin
   If I<=255 Then C:=Chr(I) Else
    Begin While I>255 Do Dec(I,256); C:=Chr(I); End;
  End
 Else
  Begin If I>=0 Then C:=Chr(I) Else
   Begin While I<0 Do Inc(I,256); C:=Chr(I); End; End;
 CW:=C;
End;

Function StrDec(S: String): String;
Var Tmp,Key: Byte;
Begin
 Key:=SHORTINT(S[1]);
 Delete(S,1,1);
 For Tmp:=1 To Length(S) Do
  S[Tmp]:=CW(S[Tmp],-Key);
 For Tmp:=Length(S) DownTo 1 Do
  Begin
   If Tmp<>Length(S) Then
    S[Tmp]:=CW(S[Tmp],-Ord(S[Tmp+1]));
  End;
 StrDec:=S;
End;

Function FileExists(S: String): Boolean;
Var F: File; I: Integer;
Begin
 Assign(F,S); {$I-} Reset(F); Close(F); {$I+}
 FileExists:=(IOResult=0);
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
     Write(Pad('',Max));
     GotoXY(WhereX-Max,WhereY);
     StartPos:=WhereX;
     GotStr:=Default;
     Write(Default);
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
                  Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End
                 Else
                 Begin
                  Tmp:=WhereX+1;
                  GotStr[Tmp-StartPos]:=Ch;
                  Write(Copy(GotStr,Tmp-StartPos,255));
                  GotoXY(Tmp,WhereY);
                 End;
               End
               Else
               Begin
                Write(Ch);
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
           End;
          If Ch=#83 Then { Del }
           Begin
            If WhereX-StartPos>=1 Then
             Begin
              Tmp:=WhereX;
              Delete(GotStr,Tmp-StartPos+1,1);
              GotoXY(Tmp-1,WhereY);
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
     Return:=GotStr;
     WriteLn;
End;

Procedure InitTurboCOMM;
Var
 DropFile: Text;
 Str: String;
 Ad1,
 Ad2: String;
 PChk: Integer;
 DorInfoName: String;
 Tmp: String;
 Now: Real;
Begin
 ExitSave:=ExitProc;
 ExitProc:=@TurboCOM_Terminate;
 LocalTest:=False;
 ProgName:='';
 ChatOK:=True;
 Ad1           := 'd³İŞÚÖÒÊ…˜áŞİ‰uÊèÕÒ³“›ng–£§–m“âåêŞØÔÙ”—ÜØæİÙŞR`ac’‚c¼štÈÚÜÜ†c¯ÖØÒÌi';
 Ad2           := 'aÂ>D=.8óÎ518BCC6;õÑ#B4:98>9>ğ¢¡Ä.9íÎ518BCC6;õÃåöÔâ6õ©¿ÇÅ¾ª¹ÏËÂÆÊÈÇ‘';
 LocalANSIKeys := False;
 ProhibitStatus:= False;
 ComPort       := 0;
 NodeNum       := 1;
 Slicing       := 100;
 IdleSlicing   := 100;
 ForceDorInfo1 := False;
 ForceDoorSys  := False;
 ForceTasker   := #0;
 If (ParamCount=0) And (Detailed) And (Not FileExists('DORINFO1.DEF')) Then
  Begin
   ExitProc:=ExitSave; { Unhook exit procedure, no com shutdown necessary }
   TextAttr:=$09;
   WriteLn(' '+HelpScrPrgName+' Error: No parameters specified!');
   TextAttr:=$01;
   WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
   TextAttr:=$0F;
   WriteLn(' Basic '+HelpScrPrgName+' parameters (refer to doc file for more):');
   WriteLn;
   WriteLn('  -L        Local test mode');
   WriteLn('  -P        Specify path to your dropfiles (*MUST* be used!)');
   WriteLn('  -N<#>     Specify node, replace <#> with the number');
   WriteLn('  -1        Force DORINFO1.DEF (do not use DORINFO2.DEF for node 2, etc.)');
   WriteLn('  -!        Force DOOR.SYS usage');
   WriteLn('  -@<x>     Force multitasker, replace <x> with one of the following:');
   WriteLn('             D = DESQview       W = Windows     N = NetWare');
   WriteLn('             2 = DoubleDOS      O = OS/2        X = Force NO detection');
   WriteLn('            If you don''t use this parameter, the multitasker will be detected');
   WriteLn('  -%        Flush modem buffer after every modem write (usually NOT used)');
   WriteLn('  -S<###>   Releace timeslice every <###>/100ths of a second (default is');
   WriteLn('             100/100ths, or every 1 second.  If this door is running slow,');
   WriteLn('             play around with this (should speed it up).  Or use the F9 key.');
   WriteLn('  -I<###>   Same as above, used when program is idle (waiting for key, etc.)');
   TextAttr:=$01;
   WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
   Halt;
  End;
 For PChk:=1 To ParamCount Do
  Begin
   Str:=ParamStr(PChk);
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='L') Then LocalTest:=True;
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='N') Then NodeNum:=IntVal(Copy(ParamStr(PChk),3,1));
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='+') Then OS2Secs:=IntVal(Copy(ParamStr(PChk),3,1));
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='1') Then ForceDorInfo1:=True;
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='!') Then ForceDoorSys:=True;
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='@') Then ForceTasker:=UpCase(Str[3]);
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='%') Then EnableFlush:=True;
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='P') Then
    Begin
     SysPath:=ParamStr(PChk); Delete(SysPath,1,2);
     If SysPath[Length(SysPath)]<>'\' Then SysPath:=SysPath+'\';
    End;
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='S') Then
    Slicing:=LIntVal(Copy(Str,3,255));
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='=') Then
    SimCPS:=Trunc(1/LIntVal(Copy(Str,3,255))*1000000);
   If (Str[1] in ['-','/']) And (UpCase(Str[2])='I') Then
    IdleSlicing:=LIntVal(Copy(Str,3,255));
  End;
 Slicing:=Slicing / 100;
 IdleSlicing:=IdleSlicing / 100;
 SliceInit;
 If ForceDorInfo1 Then
  DorInfoName:='DORINFO1.DEF'
 Else
  DorInfoName:='DORINFO'+StrVal(NodeNum)+'.DEF';
 TimeCheck:=True;
 CarrierCheck:=True;
 If Not LocalTest Then
  Begin
   If (Not ForceDoorSys) Then
    Begin
     Assign(DropFile,SysPath+DorInfoName);
     {$I-} Reset(DropFile); {$I+}
     If IOResult<>0 Then
      Begin
       ExitProc:=ExitSave;
       If Detailed Then
        Begin
         TextAttr:=$09;
         WriteLn(' '+HelpScrPrgName+' Error: Dropfile not found');
         TextAttr:=$01;
         WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
         TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Cannot find '+SysPath+DorInfoName+'!');
         TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Please ensure that you specify the correct path with the -P'+
                                                             ' parameter');
         TextAttr:=$01;
         WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
        End
        Else
         WriteLn(' ş '+SysPath+DorInfoName+' not found!');
       Halt;
      End;
    End
    Else
    Begin
     Assign(DropFile,SysPath+'DOOR.SYS');
     {$I-} Reset(DropFile); {$I+}
     If IOResult<>0 Then
      Begin
       ExitProc:=ExitSave;
       If Detailed Then
        Begin
         TextAttr:=$09;
         WriteLn(' '+HelpScrPrgName+' Error: Dropfile not found');
         TextAttr:=$01;
         WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
         TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Cannot find '+SysPath+'DOOR.SYS!');
         TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Please ensure that you specify the correct path with the -P '+
                                                             'parameter');
         TextAttr:=$01;
         WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
        End
        Else
         WriteLn(' ş '+SysPath+'DOOR.SYS not found!');
       Halt;
      End;
    End;
  End;
 Now          := Timer;
 Initialized  := True;
 InChat       := False;
 TimeOn       := Now;
 TimeOutDelay := 120;
 LockBaud     := 0;
 CapitalizeOn := False;
 ProgLocked   := False;
 TimeLeft     := 60*60;
 LastUpdate   := Now;
 OldSlCount   := Now;
 StatBar      := 1;
 LastSlice    := Now;
 BBSName      := '';
 SysOpFirst   := '';
 SysOpLast    := '';
 UserFirst    := '';
 UserLast     := '';
 UserLocation := '';
 ANSI         := True;
 Security:=0;
 If (Not ForceDoorSys) Or (LocalTest) Then
  Begin
   If LocalTest Then
    Begin
     BBSName:='Local Mode';
     ComPort:=0;
     BaudRate:=0;
     UserFirst:='';
     UserLast:='';
     UserLocation:='Local Mode';
     ANSI:=True;
     Security:=0;
     TimeLeft:=60*60;
     If FileExists('LOCAL.DEF') Then
      Begin
       Assign(DropFile,'LOCAL.DEF');
       Reset(DropFile);
       ReadLn(DropFile,BBSName);
       ReadLn(DropFile,SysOpFirst);
       SysOpLast:=Copy(SysOpFirst,Pos(' ',SysOpFirst)+1,255); Delete(SysOpFirst,Pos(' ',SysOpFirst),255);
       ReadLn(DropFile,UserFirst);
       UserLast:=Copy(UserFirst,Pos(' ',UserFirst)+1,255); Delete(UserFirst,Pos(' ',UserFirst),255);
       ReadLn(DropFile,UserLocation);
       ReadLn(DropFile,Security);
       ReadLn(DropFile,Str); ANSI:=(UpCase(Str[2])='N');
       ReadLn(DropFile,TimeLeft); TimeLeft:=TimeLeft*60;
       Close(DropFile);
      End;
     TextAttr:=$09;
     ClrScr;
     WriteLn(' Local Mode');
     TextAttr:=$01;
     WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
     WriteLn;
     WriteLn;
     WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
     GotoXY(1,3); TextAttr:=$09; Write(' ş '); TextAttr:=$0F; Write('Please enter the SysOp''s name: ');
     GotoXY(1,4); TextAttr:=$09; Write(' ş '); TextAttr:=$0F; Write('Please enter your name: ');
     Str:=SysOpFirst+' '+SysOpLast;

     While Copy(Str,1,1)=' ' Do Delete(Str,1,1);
     While Copy(Str,Length(Str),1)=' ' Do Delete(Str,Length(Str),1);

     GotoXY(35,3); TextAttr:=$1F; Read_Str(SysOpFirst,40,Str);
     GotoXY(35,3); TextAttr:=$0F; Write(Pad(SysOpFirst,40));
     If Pos(' ',SysOpFirst)>0 Then
      Begin SysOpLast:=Copy(SysOpFirst,Pos(' ',SysOpFirst)+1,255); Delete(SysOpFirst,Pos(' ',SysOpFirst),255); End;

     UserFirst:=SysOpFirst; UserLast:=SysOpLast;
     GotoXY(28,4); TextAttr:=$1F; Read_Str(UserFirst,40,UserFirst+' '+UserLast); WriteLn;
     GotoXY(28,4); TextAttr:=$0F; Write(Pad(UserFirst,40));
     If Pos(' ',UserFirst)>0 Then
      Begin UserLast:=Copy(UserFirst,Pos(' ',UserFirst)+1,255); Delete(UserFirst,Pos(' ',UserFirst),255); End;
     TextAttr:=$01;
    End
    Else
    Begin
     ReadLn(DropFile,BBSName);
     ReadLn(DropFile,SysOpFirst);
     ReadLn(DropFile,SysOpLast);
     ReadLn(DropFile,Str); ComPort:=IntVal(Str[4]);
     ReadLn(DropFile,Str);
     Tmp:='';
     While Str[1] in ['0'..'9'] Do Begin Tmp:=Tmp+Str[1]; Delete(Str,1,1); End;
     BaudRate:=LIntVal(Tmp);
     ReadLn(DropFile,Str);
     ReadLn(DropFile,UserFirst);
     ReadLn(DropFile,UserLast);
     ReadLn(DropFile,UserLocation);
     ReadLn(DropFile,Str); If Str[1] In ['1','3'] Then ANSI:=True Else ANSI:=False;
     ReadLn(DropFile,Security);
     ReadLn(DropFile,TimeLeft); TimeLeft:=TimeLeft*60;
    End;
  End
  Else
  Begin
   ReadLn(DropFile,Str); ComPort:=IntVal(Str[4]);
   ReadLn(DropFile,Baudrate);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,UserName);
   ReadLn(DropFile,UserLocation);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Security);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,TimeLeft);
   ReadLn(DropFile,Str);
   ReadLn(DropFile,Str); ANSI:=(Str='GR');
  End;
 If Not LocalTest Then Close(DropFile);

 SysOpFirst   := Capitalize(SysOpFirst);
 SysOpLast    := Capitalize(SysOpLast);
 UserFirst    := Capitalize(UserFirst);
 UserLast     := Capitalize(UserLast);
 If Not ForceDoorSys Then
  Begin
   SysOpName    := SysOpFirst+' '+SysOpLast;
   UserName     := UserFirst+' '+UserLast;
  End Else
  Begin
   SysOpName    := Capitalize(SysOpName);
   UserName     := Capitalize(UserName);
  End;
 BBSName      := Capitalize(BBSName);
 UserLocation := Capitalize(UserLocation);

 PibPlaySet;

 Escape     := False;
 Ansi_String:= '';
 Blink      := False;
 High       := False;

 If Not Local Then
  Begin
   Port_Num:=ComPort-1;
   If Not OpenFossil(Port_Num) Then
    Begin
     If Detailed Then
      Begin
       TextAttr:=$09; WriteLn(' '+HelpScrPrgName+' Error: FOSSIL Initialization Failed');
       TextAttr:=$01; WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
       TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Cannot initialize your FOSSIL driver');
       TextAttr:=$09; Write(' ş '); TextAttr:=$0F; WriteLn('Please ensure that BNU, X00, or a compatible driver is installed');
       TextAttr:=$01; WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
      End
      Else
       WriteLn(' ş Fossil initialization error!');
     Halt;
    End;
   SetBaudRate(Port_Num,Baudrate);
  End;
 SWriteLn(' ');
 If (LastUpdate+UpdateSeconds<=Timer) Then UpdateStatus(False);
 TextColor(7); TextBackground(0);
 STextColor(7); STextBackground(0);
End;

Procedure FUtility(B: Byte);                    (* FOSSIL Utilities *)
Begin
 If Local Then Exit;
 If B=1 Then FlushOutput(Port_Num);
 If B=2 Then PurgeInput(Port_Num);
 If B=3 Then PurgeOutput(Port_Num);
 If B=4 Then
  Begin
   SetDTR(Port_Num,False);
   CDelay(2000);
   SetDTR(Port_Num,True);
  End;
End;

Function DetectANSI: Boolean;
Var
 ANSIDetected  : Boolean;
 ANSIData      : String;
 Tries         : Byte;
Label Retry;
Begin
 ANSIDetected := False;
 ANSIData     := '';
 Tries:=0;
 If (Not Local) then
  Begin
   Retry:
   Inc(Tries);
   FUtility(2); Remote_Screen(#27+'[6n'); FUtility(1); CDelay(1000);
   While Remote_Keypressed Do
    ANSIData:=ANSIData+ReceiveChar(Port_Num);
   If (Pos(#27,ANSIData)>0) And (Pos('[',ANSIData)>0) And (Pos('H',ANSIData)>0) Then
    ANSIDetected:=True;
   FUtility(2); FUtility(1);
   If (Not ANSIDetected) And (Tries<2) Then Begin CDelay(1000); Goto Retry; End;
  End
  Else
   ANSIDetected:=True;
 DetectANSI:=ANSIDetected;
End;

Function BlinkSet: Boolean;
Begin
 BlinkSet:=Blink;
End;

Procedure FossilData(PNum: Word; Var MajVer,MinVer: Byte; Var FosID: String);
Type
 FossilDataType = Record
   strsize: word;
   majver: byte;
   minver: byte;
   ident: pointer;
   ibufr: word;
   ifree: word;
   obufr: word;
   ofree: word;
   swidth: byte;
   sheight: byte;
   baud: byte;
  end;
 StrType = String[255];
 SO = Record XSeg,XOfs: Word; End;
Var
 FossilData: FossilDataType;
Begin
 Asm
   mov ah,1Bh
   mov cx,13h
   mov dx,PNum
   mov ax,seg(fossildata)
   mov es,ax
   mov di,OFFSET fossildata
   int 14h
  End;
 MajVer:=FossilData.MajVer;
 MinVer:=FossilData.MinVer;
 Move(Mem[SO(FossilData.Ident).XSeg:SO(FossilData.Ident).XOfs],Mem[Seg(FosID):Ofs(FosID)+1],255);
 FosID[0]:=Chr(FossilData.StrSize);
End;

End.
