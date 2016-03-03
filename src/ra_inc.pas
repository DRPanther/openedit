Type
  MSGTOIDXrecord = String[35];
  COMBINEDrecord = array[1..200] of Word;
  Time           = String[5];
  Date           = String[8];
  MsgType        = (LocalMail, NetMail, EchoMail, Internet, Newsgroup);
  MsgKindsType   = (Both, Private, Public, ROnly, NoReply);
  FlagType       = array[1..4] of Byte;
  AskType        = (Yes, No, Ask, Only);
  VideoType      = (Auto, Short, Long);
  ARCrecord = record
                Extension : String[3];
                UnpackCmd,
                PackCmd   : String[60];
              end;
  NetAddress     = record
                     Zone,
                     Net,
                     Node,
                     Point          : Word;
                   end;

  MESSAGErecord  = record
                     Unused         : Array[1..4] of Byte;
                     Name           : String[40];
                     Typ            : MsgType;
                     MsgKinds       : MsgKindsType;
                     Attribute      : Byte;

                      { Bit 0 : Enable EchoInfo
                            1 : Combined access
                            2 : File attaches
                            3 : Allow aliases
                            4 : Use SoftCRs as characters
                            5 : Force handle
                            6 : Allow deletes 
                            7 : Is a JAM area }

                     DaysKill,    { Kill older than 'x' days }
                     RecvKill       : Byte; { Kill recv msgs, recv for more than 'x' days }
                     CountKill      : Word;

                     ReadSecurity   : Word;
                     ReadFlags,
                     ReadNotFlags   : FlagType;

                     WriteSecurity  : Word;
                     WriteFlags,
                     WriteNotFlags  : FlagType;

                     SysopSecurity  : Word;
                     SysopFlags,
                     SysopNotFlags  : FlagType;

                     OriginLine     : String[60];
                     AkaAddress     : Byte;

                     Age            : Byte;

                     JAMbase        : String[60];
                     Group          : Word;
                     AltGroup       : Array[1..3] of Word;

                     Attribute2     : Byte;

                      { Bit 0 : Include in all groups }

                     FreeSpace2     : Array[1..9] of Byte;
                   end;

  GROUPrecord    = record
                     AreaNum        : Word;
                     Name           : String[40];
                     Security       : Word;
                     Flags,
                     NotFlagsMask   : FlagType;
                     FreeSpace      : Array[1..100] of Byte;
                   end;

  MESSAGErecord250  = record
                     AreaNum,
                     Unused         : Word;
                     Name           : String[40];
                     Typ            : MsgType;
                     MsgKinds       : MsgKindsType;
                     Attribute      : Byte;

                      { Bit 0 : Enable EchoInfo
                            1 : Combined access
                            2 : File attaches
                            3 : Allow aliases
                            4 : Use SoftCRs as characters
                            5 : Force handle
                            6 : Allow deletes
                            7 : Is a JAM area }

                     DaysKill,    { Kill older than 'x' days }
                     RecvKill       : Byte; { Kill recv msgs, recv for more than 'x' days }
                     CountKill      : Word;

                     ReadSecurity   : Word;
                     ReadFlags,
                     ReadNotFlags   : FlagType;

                     WriteSecurity  : Word;
                     WriteFlags,
                     WriteNotFlags  : FlagType;

                     SysopSecurity  : Word;
                     SysopFlags,
                     SysopNotFlags  : FlagType;

                     OriginLine     : String[60];
                     AkaAddress     : Byte;
  
                     Age            : Byte;

                     JAMbase        : String[60];
                     Group          : Word;
                     AltGroup       : Array[1..3] of Word;

                     Attribute2     : Byte;

                      { Bit 0 : Include in all groups }

                     NetmailArea    : Word;
                     FreeSpace2     : Array[1..7] of Byte;
                   end;

  CONFIGrecord = record
    VersionID           : Word;
    xCommPort           : Byte;
    xBaud               : LongInt;
    xInitTries          : Byte;
    xInitStr,
    xBusyStr            : String[70];
    xInitResp,
    xBusyResp,
    xConnect300,
    xConnect1200,
    xConnect2400,
    xConnect4800,
    xConnect9600,
    xConnect19k,
    xConnect38k         : String[40];
    xAnswerPhone        : Boolean;
    xRing,
    xAnswerStr          : String[20];
    xFlushBuffer        : Boolean;
    xModemDelay         : Integer;

    MinimumBaud,
    GraphicsBaud,
    TransferBaud        : word;
    SlowBaudTimeStart,
    SlowBaudTimeEnd,
    DownloadTimeStart,
    DownloadTimeEnd     : Time;

    PageStart           : Array[0..6] of Time;
    PageEnd             : Array[0..6] of Time;

    SeriNum,
    CustNum             : String[22];
{}  FreeSpace1          : Array[1..24] of Byte;
    PwdExpiry           : Word;

    MenuPath,
    TextPath,
    AttachPath,
    NodelistPath,
    MsgBasePath,
    SysPath,
    ExternalEdCmd       : String[60];

    Address             : Array[0..9] of NetAddress;
    SystemName          : String[30];

    NewSecurity         : Word;
    NewCredit           : Word;
    NewFlags            : FlagType;

    OriginLine          : String[60];
    QuoteString         : String[15];
    Sysop               : String[35];
    LogFileName         : String[60];
    FastLogon,
    AllowSysRem,
    MonoMode,
    StrictPwdChecking,
    DirectWrite,
    SnowCheck           : Boolean;
    CreditFactor        : Integer;

    UserTimeOut,
    LogonTime,
    PasswordTries,
    MaxPage,
    PageLength          : Word;
    CheckForMultiLogon,
    ExcludeSysopFromList,
    OneWordNames        : Boolean;
    CheckMail           : AskType;
    AskVoicePhone,
    AskDataPhone,
    DoFullMailCheck,
    AllowFileShells,
    FixUploadDates,
    FreezeChat          : Boolean;
    ANSI,                       { ANSI: Yes, no, or ask new users     }
    ClearScreen,                { Clear:        "                     }
    MorePrompt          : AskType;    { More:         "                     }
    UploadMsgs          : Boolean;
    KillSent            : AskType;    { Kill/Sent     "                     }

    CrashAskSec         : Word;       { Min sec# to ask 'Crash Mail ?'      }
    CrashAskFlags       : FlagType;
    CrashSec            : Word;       { Min sec# to always send crash mail. }
    CrashFlags          : FlagType;
    FAttachSec          : Word;       {        "    ask 'File Attach ?'     }
    FAttachFlags        : FlagType;

    NormFore,
    NormBack,
    StatFore,
    StatBack,
    HiBack,
    HiFore,
    WindFore,
    WindBack,
    ExitLocal,
    Exit300,
    Exit1200,
    Exit2400,
    Exit4800,
    Exit9600,
    Exit19k,
    Exit38k             : Byte;

    MultiLine           : Boolean;
    MinPwdLen           : Byte;
    MinUpSpace          : Word;
    HotKeys             : AskType;
    BorderFore,
    BorderBack,
    BarFore,
    BarBack,
    LogStyle,
    MultiTasker,
    PwdBoard            : Byte;
    xBufferSize         : Word;
    FKeys               : Array[1..10] of String[60];

    WhyPage             : Boolean;
    LeaveMsg            : Byte;
    ShowMissingFiles,
    xLockModem          : Boolean;
{}  FreeSpace2          : Array[1..10] of Byte;
    AllowNetmailReplies : Boolean;
    LogonPrompt         : String[40];
    CheckNewFiles       : AskType;
    ReplyHeader         : String[60];
    BlankSecs           : byte;
    ProtocolAttrib      : Array[1..6] of Byte;
    xErrorFreeString    : String[15];
    xDefaultCombined    : array[1..25] of Byte;
    RenumThreshold      : Word;
    LeftBracket,
    RightBracket        : Char;
    AskForHandle        : Boolean;
    AskForBirthDate     : Boolean;

    GroupMailSec        : Word;

    ConfirmMsgDeletes   : Boolean;

    FreeSpace4          : Array[1..30] of byte;

    TempScanDir         : String[60];
    ScanNow             : AskType;
    xUnknownArcAction,
    xFailedUnpackAction,
    FailedScanAction    : Byte; {Bit 0:Mark deleted, 1:Mark unlisted, 2:Mark notavail}
    xUnknownArcArea,
    xFailedUnpackArea,
    FailedScanArea      : Word;
    ScanCmd             : String[60];
    xDeductIfUnknown    : Boolean;

    NewUserGroup        : Byte;
    AVATAR              : AskType;
    BadPwdArea          : Byte;
    Location            : String[40];
    DoAfterAction       : Byte; {0 = wait for CR, > 0 = wait for x seconds}
{}  OldFileLine         : String[40];
    CRfore,
    CRback              : Byte;
    LangHdr             : String[40];
    xSendBreak          : Boolean;
{}  ListPath            : String[60];
    FullMsgView         : AskType;
    EMSI_Enable         : AskType;
    EMSI_NewUser        : Boolean;

    EchoChar            : String[1];
    xConnect7200,
    xConnect12000,
    xConnect14400       : String[40];
    Exit7200,
    Exit12000,
    Exit14400           : Byte;
    ChatCommand         : String[60];
    ExtEd               : AskType;
    NewuserLanguage     : Byte;
    LanguagePrompt      : String[40];
    VideoMode           : VideoType;
    AutoDetectANSI      : Boolean;
    xOffHook            : Boolean;
    NewUserDateFormat   : Byte;
    KeyboardPwd         : String[15];
    CapLocation         : Boolean;
    NewuserSub          : Byte;
    PrinterName         : String[4];
    HilitePromptFore,
    HiLitePromptBack    : Byte;
    xInitStr2           : String[70];
    AltJSwap            : Boolean;
    SemPath             : String[60];
    AutoChatCapture     : Boolean;

    FileBasePath        : String[60];
    NewFileTag          : Boolean;
    IgnoreDupeExt       : Boolean;
    TempCDFilePath      : String[60];
    TagFore,
    TagBack             : Byte;
    xConnect16k         : String[40];
    Exit16k,
    FilePayback         : Byte;
    FileLine,
    FileMissingLine     : String[200];
    NewUserULCredit     : Byte;
    NewUserULCreditK    : Word;
    ArcInfo             : Array[1..10] of ARCrecord;
    RAMGRAltFKeys       : Array[1..5] of String[60];
    ArcViewCmd          : String[60];
    xConnectFax         : String[40];
    ExitFax             : Byte;
    UseXMS,
    UseEMS              : Boolean;
    CheckDOB            : Byte;
    EchoCheck           : AskType;
    ccSec,
    ReturnRecSec        : Word;
    HonourNetReq        : Boolean;
    DefaultCombined     : COMBINEDrecord;
    AskForSex,
    AskForAddress       : Boolean;
    DLdesc              : AskType;
    NewPhoneScan        : Boolean;
    FutureExpansion : Array[1..587] of Byte;
  end;

  SYSINFOrecord  = record
                     TotalCalls     : LongInt;
                     LastCaller     : MSGTOIDXrecord;
                     ExtraSpace     : array[1..128] of Byte;
                   end;

  TIMELOGrecord  = record
                     StartDate      : Date;
                     BusyPerHour    : array[0..23] of Word;
                     BusyPerDay     : array[0..6] of Word;
                   end;

  USERSrecord    = record
                     Name           : MSGTOIDXrecord;
                     Location       : String[25];
                     Organisation,
                     Address1,
                     Address2,
                     Address3       : String[50];
                     Handle         : String[35];
                     Comment        : String[80];
                     PasswordCRC    : LongInt;
                     DataPhone,
                     VoicePhone     : String[15];
                     LastTime       : Time;
                     LastDate       : Date;

                     Attribute,

                      { Bit 0 : Deleted
                            1 : Clear screen
                            2 : More prompt
                            3 : ANSI
                            4 : No-kill
                            5 : Xfer priority
                            6 : Full screen msg editor
                            7 : Quiet mode }

                     Attribute2     : Byte;

                      { Bit 0 : Hot-keys
                            1 : AVT/0
                            2 : Full screen message viewer
                            3 : Hidden from userlist 
                            4 : Page priority 
                            5 : No echomail in mailbox scan
                            6 : Guest account 
                            7 : Post bill enabled }

                     Flags          : FlagType;
                     Credit,
                     Pending        : LongInt;
                     MsgsPosted,
                     Security       : Word;
                     LastRead,
                     NoCalls,
                     Uploads,
                     Downloads,
                     UploadsK,
                     DownloadsK,
                     TodayK         : LongInt;
                     Elapsed        : Integer;
                     ScreenLength   : Word;
                     LastPwdChange  : Byte;
                     Group          : Word;
                     CombinedInfo   : COMBINEDrecord;
                     FirstDate,
                     BirthDate,
                     SubDate        : Date;
                     ScreenWidth,
                     Language,
                     DateFormat     : Byte;      
                     ForwardTo      : String[35];
                     MsgArea,
                     FileArea       : Word;
                     DefaultProtocol: Char;
                     FileGroup      : Word;
                     LastDOBCheck   : Byte;
                     Sex            : Byte;
                     XIrecord       : LongInt;
                     MsgGroup       : Word;
                     FreeSpace      : Array[1..48] of Byte;
                   end;

  EVENTrecord    = record
                     Status         : Byte; { 0=Deleted 1=Enabled 2=Disabled }
                     StartTime      : Time;
                     ErrorLevel     : Byte;
                     Days           : Byte;
                     Forced         : Boolean;
                     LastTimeRun    : Date;
                   end;

  USERSXIrecord  = record
                     FreeSpace      : Array[1..200] of Byte;
                   end;

  EXITINFOrecord = record
                     Baud             : Word;
                     SysInfo          : SYSINFOrecord;
                     TimeLogInfo      : TIMELOGrecord;
                     UserInfo         : USERSrecord;
                     EventInfo        : EVENTrecord;
                     NetMailEntered,
                     EchoMailEntered  : Boolean;
                     LoginTime        : Time;
                     LoginDate        : Date;
                     TimeLimit        : Word;
                     LoginSec         : LongInt;
                     UserRecord       : Integer;
                     ReadThru,
                     NumberPages,
                     DownloadLimit    : Word;
                     TimeOfCreation   : Time;
                     LogonPasswordCRC : LongInt;
                     WantChat         : Boolean;

                     DeductedTime     : Integer;
                     MenuStack        : Array[1..50] of String[8];
                     MenuStackPointer : Byte;
                     UserXIinfo       : USERSXIrecord;
                     ErrorFreeConnect,
                     SysopNext        : Boolean;

                     EMSI_Session     : Boolean;        { These fields hold  }
                     EMSI_Crtdef,                       { data related to an }
                     EMSI_Protocols,                    { EMSI session       }
                     EMSI_Capabilities,
                     EMSI_Requests,
                     EMSI_Software    : String[40];
                     Hold_Attr1,
                     Hold_Attr2,
                     Hold_Len         : Byte;

                     PageReason       : String[80];
                     StatusLine       : Byte;
                     LastCostMenu     : String[8];
                     MenuCostPerMin   : Word;

                     DoesAVT,
                     RIPmode          : Boolean;

                     ExtraSpace       : Array[1..86] of Byte;
                 end;
