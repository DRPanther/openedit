(*****************************************************************************)
(*                                                                           *)
(*                   G E N E R A L   D A T A   T Y P E S                     *)
(*                                                                           *)
(*****************************************************************************)

  (* All files should be opened in Filemode 66 (Read/Write, DenyNone) mode *)
  (* unless wanted to reserve them for the duration of certain processes.  *)

       const

 SOFTWARE_NAME    = 'Concord';               (* Software name .............. *)
 SOFTWARE_COPYRIGHT = 'Copyright ' +         (* Copyright notice of software *)
   '(c) 1993,96 by Pasi Talliniemi';
 ID_VER           = $00001A9E;               (* Concord data file ID ....... *)
 CURRVERNUM       = 2;                       (* Version number in number fmt *)
 SOFTWARE_VERSION = 'O.O1 Gamma-4';          (* Version number in string fmt *)
 DEF_TEARLINE     = 'OO1C4';             (* Tear line; x+OS2,P+x+DOS,R+x+DOS *)

         MAX_FLAG     = 10;
         MAX_LIMITBPS =  7;
         MAX_GOSUB    = 20;

         USER_DELETED      = $00000001; (* Bit  0 - User deleted             *)
         USER_MAILCHK      = $00000002; (* Bit  1 - Mail check               *)
         USER_FILECHK      = $00000004; (* Bit  2 - New files check          *)
         USER_NORATIO      = $00000008; (* Bit  3 - No DL ratios             *)
         USER_FEMALE       = $00000010; (* Bit  4 - Female                   *)
         USER_CLRSCR       = $00000020; (* Bit  5 - Clear screen             *)
         USER_MORE         = $00000040; (* Bit  6 - More prompts             *)
         USER_NOKILL       = $00000080; (* Bit  7 - User cannot be removed   *)
         USER_COLORS       = $00000100; (* Bit  8 - Colors                   *)
         USER_NODISTURB    = $00000200; (* Bit  9 - Do not disturb           *)
         USER_HOTKEYS      = $00000400; (* Bit 10 - Hot keys                 *)
         USER_IGNDLHOURS   = $00000800; (* Bit 11 - Ignore download hours    *)
         USER_DELAFTERVIEW = $00001000; (* Bit 12 - Delete file after viewed *)
         USER_VIEWED       = $00002000; (* Bit 13 - File viewed              *)
         USER_VIEWONLYONCE = $00004000; (* Bit 14 - View file only once      *)
         USER_SYSOP        = $00008000; (* Bit 15 - Added BBS to BBS list    *)
         USER_VIP          = $00010000; (* Bit 16 - VIP member               *)
         USER_BULLETCHK    = $00020000; (* Bit 17 - New bulletins check      *)
         USER_WSCURSORS    = $00040000; (* Bit 18 - Use Wordstar cursor keys *)
         USER_DL_FILEDESC  = $00080000; (* Bit 19 - Download file descs      *)
         USER_FILEDESC_FMT = $00100000; (* Bit 20 - 0=FILES.BBS, 1=DESCRIPT.ION *)

       type

         ErrorType    = LongInt;                  (* 0 = OK, 1-65535 = ERROR *)

         SmallInt     = System.Integer;               (* 16-bit   signed int *)
         SmallWord    = System.Word;                  (* 16-bit unsigned int *)

         PathStr      = String [79];
         DirStr       = String [67];
         ExtStr       = String [04];

         ANameStr     = String [60];
         NameStr      = String [35];
         CityStr      = String [25];
         PhoneStr     = String [20];
         PassStr      = String [15];
         DefStr       = String [15];
         QWKStr       = String [12];
         OpenStr      = String [11];
         MenuStr      = String [08];
         GroupStr     = String [03];

         DateRec      = SmallWord;                    (* Packed DOS format   *)
                                                      (* Bits 0 - 4  : Day   *)
                                                      (* Bits 5 - 8  : Month *)
                                                      (* Bits 9 - 15 : Year  *)

         TimeRec      = SmallWord;                    (* Minutes after 00:00 *)
         DateTimeRec  = LongInt;                      (* UNIX time stamp     *)

         CRC32        = LongInt;

         CCFlagType   = Array [1..MAX_FLAG] of Byte;     (* Flags, bitmapped *)

         LimitBpsType = Array [1..MAX_LIMITBPS] of SmallWord;

         Security     = Record
           Bpsrate  : SmallWord;                 (* Current BPS rate div 100 *)
           Age      : Byte;                      (* Age  . . . . . . . . . . *)
           SecLvl   : SmallWord;                 (* Security Level . . . . . *)
           Flags    : CCFlagType;                (* Flags ON . . . . . . . . *)
           NotFlags : CCFlagType;                (* Flags OFF  . . . . . . . *)
         end;                                    (* Size 25 bytes  . . . . . *)

         AddrRec      = Record
           Zone  : SmallWord;                                       (* Zone  *)
           Net   : SmallWord;                                       (* Net   *)
           Node  : SmallWord;                                       (* Node  *)
           Point : SmallWord;                                       (* Point *)
         end;

         NetRec       = Record
           NetName : DefStr;                       (* Name of current net    *)
           NetAddr : AddrRec;                      (* Address of current net *)
         end;

         FileMaskType = Array [1..11] of Char;

       const

         LimitBpsrates : LimitBpsType = (
           12, 24, 96, 144, 192, 288, 1152
         );

(*****************************************************************************)
(*                                                                           *)
(*                     S Y S T E M   C O N F I G U R A T I O N               *)
(*                                                                           *)
(*****************************************************************************)

       const

         ID_CFG       = ID_VER or $00030000;
         ID_CFG_HDR   = ID_CFG or $01000000;
         ID_CFG_REC   = ID_CFG or $02000000;
         ID_CFG_DOOR  = ID_CFG or $03000000;
         ID_CFG_FAREA = ID_CFG or $04000000;
         ID_CFG_MAREA = ID_CFG or $05000000;
         ID_CFG_LIMIT = ID_CFG or $06000000;
         ID_CFG_EVENT = ID_CFG or $07000000;
         ID_CFG_PROTO = ID_CFG or $08000000;
         ID_CFG_ARC   = ID_CFG or $09000000;
         ID_CFG_EDIT  = ID_CFG or $0A000000;
         ID_CFG_VIEW  = ID_CFG or $0B000000;
         ID_CFG_CHSET = ID_CFG or $0C000000;

         MSG_LOCAL_CHECK_WHOTO = $01; (* Bit 0 - Local msgs, local userbase  *)
         MSG_QUICKSCAN_CURSOR  = $02; (* Bit 1 - Msg header needed in cursor *)
         MSG_QUICKSCAN_FASTEND = $04; (* Bit 2 - Fast jump to end of msgs    *)
         MSG_ALLOW_MACROS      = $08; (* Bit 3 - Allow macro strings in msgs *)

         OTHERS_DORINFONDEF    = $01; (* Bit 0 - Use node number in DORINFO? *)
         OTHERS_SCREENLEN      = $02; (* Bit 1 - Try to detect screen len    *)
         OTHERS_ERASEMULCHAT   = $04; (* Bit 2 - Erase MULCHAT.DAT after use *)
         OTHERS_FORCEANSI      = $08; (* Bit 3 - Force ANSI if ASCII detected*)
         OTHERS_NODETECTVIDEO  = $10; (* Bit 4 - Do not detect user termemul *)
         OTHERS_NOCHATLOG      = $20; (* Bit 5 - Do not keep CHAT.LOG        *)
         OTHERS_NOUSERCHATEXIT = $40; (* Bit 6 - User cannot exit chat       *)
         OTHERS_ENVVAR_PATHS   = $80; (* Bit 7 - Convert $ENVVAR in paths    *)

{ok}     MAREA_ACTIVE    = $0001;       (* Bit 0 - Active?                   *)
{ok}     MAREA_DELETE    = $0002;       (* Bit 1 - Allow deleting messages   *)
         MAREA_TAGLINE   = $0004;       (* Bit 2 - Allow tag lines           *)
         MAREA_FATTACH   = $0008;       (* Bit 3 - Allow file attaches       *)
         MAREA_SELECT    = $0010;       (* Bit 4 - Allow selecting from list *)
         MAREA_CTRLCHAR  = $0020;       (* Bit 5 - Allow control chars       *)
         MAREA_DEFAULT   = $0040;       (* Bit 6 - Tagged by default         *)
         MAREA_MAILCHK   = $0080;       (* Bit 7 - Force mail check          *)
         MAREA_ORIGIN    = $0100;       (* Bit 8 -                           *)
{ok}     MAREA_JUMP      = $0200;       (* Bit 9 - PathName = New area list! *)
         MAREA_FORCEQUOTECR = $0400;    (* Bit10 - ..temporal..              *)
         MAREA_FOLLOWAREA = $0800;      (* Bit11 - Force combined area       *)
         MAREA_RECEIPT   = $1000;       (* Bit12 - Ask if user wants receipt *)

         MAREAFMT_HMB    = $0000;                                 (* Hudson  *)
         MAREAFMT_JAM    = $0001;                                 (* JAM     *)
         MAREAFMT_MSG    = $0002;                                 (* .MSG    *)
         MAREAFMT_SQUISH = $0003;                                 (* Squish  *)

         MAREATYPE_LOCAL = $0000;                              (* Local area *)
         MAREATYPE_ECHO  = $0001;                              (* Echo area  *)
         MAREATYPE_NET   = $0002;                              (* Net mail   *)

         MAREAKIND_BOTH  = $0000;        (* Both public and private messages *)
         MAREAKIND_PRIV  = $0001;        (* Only private messages            *)
         MAREAKIND_PUB   = $0002;        (* Only public messages             *)
         MAREAKIND_RO    = $0003;        (* Read-only                        *)

         MAREAREPLY_BOTH = $0000;                   (* Net or normal replies *)
         MAREAREPLY_NET  = $0001;                   (* Only net replies      *)
         MAREAREPLY_NORM = $0002;                   (* Only normal replies   *)
         MAREAREPLY_NONE = $0003;                   (* No replies            *)

         MAREAALIAS_BOTH = $0000;                      (* Real name or alias *)
         MAREAALIAS_YES  = $0001;                      (* Only aliases       *)
         MAREAALIAS_NO   = $0002;                      (* Only real names    *)
         MAREAALIAS_ASK  = $0003;                      (* Ask for alias      *)

         LIMIT_ACTIVE    = $0001;                         (* Bit 0 - Active? *)

         EDITOR_ACTIVE   = $0001;                         (* Bit 0 - Active? *)

       type

         GosubRecord = Array [1..MAX_GOSUB] of MenuStr;   (* Gosub menu list *)

         ConfigHdr = Record      (* CONFIG.DAT - Config file - Main header   *)
           Id        : LongInt;  (* Always ID_CFG_HDR                        *)
           Version   : LongInt;  (* Version number                           *)
           CfgSize   : SmallWord;(* Size of config record in bytes           *)
           Cfg2Size  : SmallWord;(* Size of config record additions in bytes *)
           DoorSize  : SmallWord;(* Size of door record in bytes             *)
           FAreaSize : SmallWord;(* Size of file area record in bytes        *)
           MAreaSize : SmallWord;(* Size of message area record in bytes     *)
           LimitSize : SmallWord;(* Size of security limit record in bytes   *)
           EventSize : SmallWord;(* Size of event record in bytes            *)
           ProtoSize : SmallWord;(* Size of transfer protocol record in bytes*)
           ArcSize   : SmallWord;(* Size of archive record in bytes          *)
           EditSize  : SmallWord;(* Size of FS editor record in bytes        *)
           ChSetSize : SmallWord;(* Size of char set record                  *)
           Doors     : LongInt;  (* Number of doors in system                *) (* RESERVED *)
           FAreas    : LongInt;  (* Number of file areas in system           *) (* RESERVED *)
           MAreas    : LongInt;  (* Number of message areas in system        *) (* RESERVED *)
           Limits    : LongInt;  (* Number of security limits in system      *) (* RESERVED *)
           Events    : LongInt;  (* Number of events in system               *) (* RESERVED *)
           Protos    : LongInt;  (* Number of transfer protocols in system   *) (* RESERVED *)
           Archives  : LongInt;  (* Number of archivers in system            *) (* RESERVED *)
           Editors   : LongInt;  (* Number of FS editors in system           *) (* RESERVED *)
           CharSets  : LongInt;  (* Number of possible char sets             *) (* RESERVED *)
         end;

         NetAddrRec = Record
           Addr        : NetRec;
           NetmailArea : LongInt;
         end;

         RegInfoCfg = Record
           BBS         : NameStr;
           Sysop       : NameStr;
           Empty       : Array [1..8] of Byte;
           Location    : NameStr;                 (* BBS location            *)
           PhoneNumber : PhoneStr;                (* BBS phone number        *)
           BBSID       : String [8];              (* BBS ID - QWK file name  *)
           BBSID2      : String [2];              (* BBS ID - OMEN file name *)
         end;

{#chgd#} ModemCfg = Record
           ModemPort    : Byte;
           InitRate     : SmallWord;
           InitTimes    : Byte;
{#ANameStr}InitStr      : String;   (* ATZ|~~~     *)
           OnHookStr    : DefStr;   (* ATH0|       *)
           OffhookStr   : DefStr;   (* ATH1|       *)
           ResetStr     : DefStr;   (* AT|         *)
           NoCarrierStr : DefStr;   (* NO CARRIER| *)
           OkStr        : MenuStr;  (* OK|         *)
           RingStr      : MenuStr;  (* RING|       *)
           EscapeCode   : MenuStr;  (* +++         *)
           Attrib       : Byte;
{#NameStr} AswStr       : String;   (* ATA|        *)
           InitDelay    : Byte;
           EscapeDelay  : Byte;
           DialTimes    : Byte;
           DialLength   : Byte;
           DialStr      : DefStr;
           HiSpeedRep   : Byte;     (* Wait n*0.1s after ANSI req (9600>) *)
           LoSpeedRep   : Byte;     (* Wait n*0.1s after ANSI req (9600<) *)
           AswTimeFrom  : TimeRec;
           AswTimeTo    : TimeRec;
           ResponseCnt  : Byte;
          {n x ModemResponseRec}
         end;

         ModemResponseRec = Record     (* 300, 1200, 2400, 4800, 7200, 9600, *)
           Speed    : SmallWord;       (* 12000, 14400, 16800, 19200, 21600, *)
           Response : ANameStr;        (* 24000, 26400, 28800, ..., 115200   *)
           ErrLvl   : Byte;            (* If nonzero, exit with this errlvl  *)
         end;

         PathCfg = Record
           Chat            : PathStr;        (* External chat utility        *)
           FileViewer      : PathStr;        (* External file viewer         *)
           VirusScanner    : PathStr;        (* External virus scanner       *)
           CommonPath      : DirStr;         (* Multinode common directory   *)
           SwapPath        : DirStr;         (* Swap directory               *)
           TempPath        : DirStr;         (* Temp directory               *)
           WorkPath        : DirStr;         (* Work directory               *)
           NodeListPath    : DirStr;         (* Nodelist directory           *)
           LocalAttachPath : DirStr;         (* Local file attach directory  *)
           FilebasePath    : DirStr;         (* Filebase directory           *)
          {SystemPath      : DirStr;}        (* SET BBS=                     *)
          {MenuPath        : DirStr;}        (* Language File                *)
          {TextPath        : DirStr;}        (* Language File                *)
         end;

         MsgCfg = Record
           QuoteStr : GroupStr;              (* "PT>"                        *)
           Attrib   : LongInt;               (* Msg configuration attributes *)
           GroupSec : SmallWord;             (* Sec to send group messages   *)
           BadMsgs  : LongInt;               (* Bad msgs board               *)
           MinSpace : SmallWord;             (* Min space to export msgs     *)
           DefOrigin: ANameStr;              (* Default origin line          *)
           MaxMsgs  : SmallWord;             (* Max msgs to export           *)
           MaxLines : SmallWord;             (* Max lines in offline msg     *)
           DupeSize : SmallWord;             (* Max size of dupe msg list    *)
           ReadMarg : Byte;                  (* 0=default marginal           *)
           QuoteMarg: Byte;                  (* 0=default marginal           *)
           OfflineSec : Security;            (* Min sec to pack msgs offline *)
           NetArea  : LongInt;               (* Net mail area number         *)
           Empty    : Array [1..394] of Byte;
         end;

         FileCfg = Record
           Attrib   : LongInt;              (* File configuration attributes *)
           CheckRatioFiles : Byte;          (* Start checking ratio after n downloaded files *)
           DLcounter: Byte;                 (* Bit 0,1: 00=(, 01=[, 10=<     *)
                                            (* Bit 2,3: counter length       *)
                                            (*     00=none, 01=2, 02=3, 03=4 *)
           FiledescLines: Byte;             (* Max num of file desc lines    *)
           NukedPath: DirStr;               (* Where to move unwanted files; empty=kill file *)
           MinSpace : SmallWord;            (* Min space to allow uploads    *)
           CheckRatioFiles2 : Byte;         (* Check after every n files if  *)
                                            (* user can still DL more files  *)
                                            (* in download menutype prompt   *)
           Empty    : Array [1..422] of Byte;
         end;

         UserCfg = Record
           FlagDesc   : Array [1..MAX_FLAG, 1..8] of String [40];
           Attrib     : LongInt;
           ExpireDays : SmallWord;
           VerifyCalls: Byte;
           PasswdTries: Byte;
           Empty      : Array [1..492] of Byte;
         end;

         ColorCfg = Record
           DefaultColor: Byte;
           ChatHeader:   Byte;
           ChatSysop:    Byte;
           ChatUser:     Byte;
           Bottomline:   Byte;
           Empty    : Array [1..499] of Byte;
         end;

         OtherCfg = Record
           LocalColors   : Boolean;    (* TRUE if colors are shown locally . *)
           SysopSecurity : Security;   (* To access Sysop filebase functions *)
           ShellToDos    : PathStr;    (* Cmd line to shell to DOS ......... *)
           YellDevice    : Byte;       (* Yelling device, 0=none ........... *)
           MaxYellTimes  : Byte;       (* Max yell times per day ........... *)
           MaxYellLen    : Byte;       (* Max yell sound length ............ *)
           YellStart     : Array [0..6] of SmallWord; (* Yell start time ... *)
           YellStop      : Array [0..6] of SmallWord; (* Yell stop time .... *)
           LocalPassword : PassStr;    (* Local keyboard password .......... *)
           FrontEndExec  : Array [1..10] of PathStr; (* Ctrl-F1..F10 execs . *)
           TimeOut       : SmallWord;  (* Keyboard time out in seconds ..... *)
           MaxLogInTime  : Byte;       (* Max login time in minutes ........ *)
           ScrBackSize   : SmallWord;  (* Scroll back buffer size in KB .... *)
           OnlineMsgChk  : Byte;       (* Check online msgs every n seconds  *)
           NodeNumber    : Byte;       (* Current node number .............. *)
           MinLastCaller : SmallWord;  (* Minimum size of LASTCALL.DAT ..... *)
           KeyboardMacro : Array [1..10] of ANameStr; (* Sh-F1..F10 macros . *)
           AsstSysopName : NameStr;
           VerifyBBSdays : SmallWord;  (* Verify BBS every n days .......... *)
           Attrib        : LongInt;
           JAMbasePath   : DirStr;     (* Where to hold ECHO/NETMAIL.JAM ... *)
           DefLocalMovePath: DirStr;
           LoginCharSet  : Byte;
           ChkMulchatTime: Byte; (* How often check MULCHAT.DAT, 0=when chgd *)
           HiddenChar    : Char;       (* Char used in hidden fields ("*")   *)
           AnsiStopChars : MenuStr;    (* Chars to abort displaying ANSI scr *)
           LngPath       : DirStr;
           CtlPath       : DirStr;
           Own_Com_Base  : SmallWord;
           Own_Com_Irq   : SmallInt;
           Own_Com_Int   : SmallInt;
           VotePath      : DirStr;
           CheckEventCounter: Byte;
           ModemANSIbufsize: SmallWord;
           StatusLine    : Array [1..6] of String [100];
           ModemResetCnt : Byte;
           ScrSaverCnt   : Byte;
           UserTagsPath  : DirStr;
           WaitAswTime   : Byte;       (* Secs to wait for CONNECT response  *)
           CommonSetup   : LongInt;    (* bitmapped, see COMMON_xxx          *)
           Empty         : Array [1..916] of Byte;
         end;

         CCConfigRec = Record                  (* CONFIG.DAT - Config record *)
           Id        : LongInt;                (* Always ID_CFG_REC          *)
           RegInfos  : RegInfoCfg;
           Modems    : ModemCfg;
           Paths     : PathCfg;
           Msgs      : MsgCfg;
           Files     : FileCfg;
           Users     : UserCfg;
           Colors    : ColorCfg;
           Others    : OtherCfg;
           NetCnt    : Byte;
          {n x NetAddrRec}             (* Size included in ConfigHdr.CfgSize *)
         end;

         LimitRecord = Record        (* CONFIG.DAT - Sec limit entry         *)
           Id        : LongInt;      (* Always ID_CFG_LIMIT                  *)
           Attrib    : Byte;         (* Limits attributes                    *)
           SecLvl    : SmallWord;    (* Current security level               *)
           Name      : ANameStr;     (* Security limit description           *)
           ValidFrom : TimeRec;      (* Starting time in minutes after 00:00 *)
           ValidTo   : TimeRec;      (* Ending time in minutes after 00:00   *)
           RatioK    : SmallWord;    (* Maximum DL/UL KB ratio               *)
           Ratio     : SmallWord;    (* Maximum DL/UL files ratio            *)
           TmLimit   : SmallWord;    (* Time limit in minutes                *)
           ClLimit   : Byte;         (* Call limit                           *)
           Downlimit : LimitBpsType; (* Download limit in kilobytes          *)
           Filelimit : LimitBpsType; (* Download limit in files              *)
         end;

         CCEventRecord = Record      (* CONFIG.DAT - Event entry             *)
           Id          : LongInt;    (* Always ID_CFG_EVENT                  *)
           Attrib      : Byte;       (* Event attributes                     *)
           Days        : Byte;       (* Days to run, bitmapped               *)
           RunTime     : TimeRec;    (* Running time in minutes after 00:00  *)
           ErrorLevel  : Byte;       (* Drop to DOS with error level         *)
           LastRun     : DateRec;    (* Last run time                        *)
         End;

{#chgd#} ProtocolRecord = Record         (* CONFIG.DAT - Protocol entry      *)
           Id           : LongInt;       (* Always ID_CFG_PROTO              *)
           Attrib       : Byte;          (* Protocol attributes              *)
           Name         : DefStr;        (* Short definition for protocol    *)
           Key          : Char;          (* Key to select protocol           *)
{#PathStr} DownloadCmd  : String;        (* Cmd line needed to transmit file *)
{#PathStr} UploadCmd    : String;        (* Cmd line needed to receive file  *)
           ListChar     : Char;          (* List indicator                   *)
           Efficiency   : Byte;          (* Transfer efficiency in percents  *)
           LogFileType  : Byte;          { 0=OTHER,1=ICOM,2=DSZ               }
           ProtocolType : Byte;          { 0=other,1=opus,2=BIMODEM           }
           LogFileName  : PathStr;
           CtlFileName  : PathStr;
           UpLogKeyword : DefStr;
           DnLogKeyword : DefStr;
           DescWordNr   : Byte;
           NameWordNr   : Byte;
           DnCtlString  : ANameStr;
           UpCtlString  : ANameStr;
         end;

         ArchiveRecord = Record          (* CONFIG.DAT - Archive entry       *)
           Id           : LongInt;       (* Always ID_CFG_ARC                *)
           Attrib       : Byte;          (* Archive attributes               *)
           Extension    : ExtStr;        (* File extension for this archive  *)
           Name         : DefStr;        (* Short definition for archive     *)
           Key          : Char;          (* Key to select this archive       *)
           Compress     : PathStr;       (* Cmd line to compress file        *)
           Uncompress   : PathStr;       (* Cmd line to uncompress file      *)
           ListChar     : Char;          (* List indicator                   *)
           Efficiency   : Byte;          (* (PackedSize/OrigSize) %          *)
           ArchiveId    : NameStr;       (* Archive ID                       *)
         end;

         EditorRecord = Record           (* CONFIG.DAT - FS Editor entry     *)
           Id           : LongInt;       (* Always ID_CFG_EDIT               *)
           Attrib       : Byte;          (* Editor attributes                *)
           Name         : DefStr;        (* Short definition for editor      *)
           Key          : Char;          (* Key to select this editor        *)
           CmdLine      : PathStr;       (* Cmd line to start editor         *)
         end;

         CharSetRecord = Record                   (* CONFIG.DAT - Char set   *)
           Id           : LongInt;                (* Always ID_CFG_CHSET     *)
           Attrib       : Byte;                   (* Char set attributes     *)
           Name         : DefStr;                 (* Short definition        *)
           Key          : Char;                   (* Key to select           *)
           Table        : Array [0..255] of Char; (* Char Convertion Table   *)
           KludgeLabel  : DefStr;                 (* Label to CHARSET kludge *)
         end;

         MAreaRec = Record            (* Message area entry                  *)
    {000}  Id           : LongInt;    (* Always ID_CFG_MAREA                 *)
    {004}  Attrib       : LongInt;    (* Area attributes, see below          *)
    {008}  Format       : Byte;       (* Message base format                 *)
    {009}  Pathname     : PathStr;    (* File path name w/o extension        *)
    {089}  Name         : ANameStr;   (* Message area name                   *)
    {150}  ShortName    : QWKStr;     (* Short message area name             *)
    {163}  Group        : GroupStr;   (* Message area group                  *)
    {167}  PassWord     : PassStr;    (* Password required to enter area     *)
    {183}  OwnBoard     : Byte;       (* Virtual area number in HMB system   *)
    {184}  Typ          : Byte;       (* Area type                           *)
    {185}  Kinds        : Byte;       (* Area status                         *)
    {186}  ReplyStatus  : Byte;       (* Reply status                        *)
    {187}  UseAlias     : Byte;       (* Use alias                           *)
    {188}  ReadRights   : Security;   (* Read rights                         *)
    {213}  WriteRights  : Security;   (* Write rights                        *)
    {238}  SysopRights  : Security;   (* Sysop rights                        *)
    {263}  DaysKill     : SmallWord;  (* Kill older than n days              *)
    {265}  ReceiveKill  : SmallWord;  (* Kill more than n days received msgs *)
    {267}  CountKill    : SmallWord;  (* Keep only n newest messages         *)
    {269}  SubDirNum    : SmallWord;  (* Current subdirectory number         *)
    {271}  UseAka       : Byte;       (* Which AKA to use                    *)
    {272}  CharTable    : Byte;       (* Which char convertion table to use  *)
    {273}  OriginLine   : ANameStr;   (* Origin line for echo areas          *)
    {334}  OpenFrom     : TimeRec;    (* Opening time in minutes after 00:00 *)
    {336}  OpenTo       : TimeRec;    (* Closing time in minutes after 00:00 *)
    {338}  JumpDirNum   : SmallWord;  (* If MAREA_JUMP, where to jump        *)
    {340} {CommentLen   : SmallWord;} (* If nonzero, area has a comment      *)
    {340}  ReplyArea    : LongInt;    (* If nonzero, move replies here       *)
         end;

       CCUserRec = Record                             (* USERINFO.DAT Record *)
         Id            : LongInt;               {  0} (* Always ID_USR_REC   *)
         Name          : NameStr;               {  4} (* Real name           *)
         Alias         : NameStr;               { 40} (* Alias               *)
         City          : CityStr;               { 76} (* City                *)
         Voice         : PhoneStr;              {102} (* Voice number        *)
         Data          : PhoneStr;              {123} (* Data number         *)
         Birthday      : DateRec;               {144} (* Birthday            *)
         Password      : PassStr;               {146} (* Password            *)
         Sec           : Security;              {162} (* Security            *)
         ScreenLen     : Byte;                  {187} (* Screen length       *)
         Attrib1       : LongInt;               {188} (* User attributes I   *)
         Attrib2       : LongInt;               {192} (* User attributes II  *)
         FirstTime     : DateTimeRec;           {196} (* First logon date    *)
         LastTime      : DateTimeRec;           {200} (* Last logon date     *)
         TimesCalled   : LongInt;               {204} (* Total times called  *)
         TotalMinutes  : LongInt;               {208} (* Total minutes used  *)
         Pages         : LongInt;               {212} (* Total times paged   *)
         PublicMsgs    : LongInt;               {216} (* Messages posted I   *)
         PrivateMsgs   : LongInt;               {220} (* Messages posted II  *)
         UpK           : LongInt;               {224} (* Upload kilobytes    *)
         UpTimes       : LongInt;               {228} (* Upload times        *)
         DownK         : LongInt;               {232} (* Download kilobytes  *)
         DownTimes     : LongInt;               {236} (* Download times      *)
         SysopCmnt     : ANameStr;              {240} (* Sysop comment       *)
         Protocol      : Byte;                  {301} (* Protocol number     *)
         Editor        : Byte;                  {302} (* Editor number       *)
         Viewer        : Byte;                  {303} (* Viewer number       *)
         Packer        : Byte;                  {304} (* Packer number       *)
         CharSet       : Byte;                  {305} (* Char set number     *)
         LastFileChk   : DateRec;               {306} (* Last new files chk  *)
         LastBullChk   : DateRec;               {308} (* Last new bullet chk *)
         Expiration    : DateRec;               {310} (* Expiration date     *)
         FirstMenu     : MenuStr;               {312} (* First menu to enter *)
         Language      : MenuStr;               {321} (* Language file       *)
         MessageArea   : LongInt;               {330} (* Msg area number     *)
         MAreaExt      : GroupStr;              {334} (* N/A                 *)
         FileArea      : LongInt;               {338} (* File area number    *)
         FAreaExt      : GroupStr;              {342} (* N/A                 *)
         Door          : LongInt;               {346} (* Door number         *)
         DoorExt       : GroupStr;              {350} (* N/A                 *)
         ChatChannel   : LongInt;               {354} (* Chat channel number *)
         TodayCalls    : Byte;                  {358} (* Today times called  *)
         TodayElapsed  : SmallInt;              {359} (* Today minutes used  *)
         TodayDownK    : LongInt;               {361} (* Today download kB   *)
         TodayDowns    : LongInt;               {365} (* Today DL times      *)
         TimeInBank    : LongInt;               {369} (* Total time in bank  *)
         DLLimitInBank : LongInt;               {373} (* Total limit in bank *)
         ViewFileName  : QWKStr;                {377} (* View file name      *)
         OfflineFmt    : Byte;                  {390} (* Offline packet fmt  *)
         OfflineDays   : Byte;                  {391} (* Automatic pack days *)
         OfflineAttrib : LongInt;               {392} (* Offline attributes  *)
         ReadMsgNum    : Byte;                  {396}
         FileListNum   : Byte;                  {397}
         TodayLastPkt  : Byte;                  {398} (* Today last pkt num  *)
         VerifyCalls   : Byte; (* Calls since last birthday verify, 255 = verify failed *)
         PasswordTries : Byte; (* Number of wrong passwords entered since last call *)
         OfflineMaxNum : SmallWord;             {401} (* Max msgs to pack *)
         FlexPos       : LongInt;               {403} (* Flex record number *)
         LastPktDl     : DateRec;               {407}
         BBSCRC        : LongInt;               {409}
         Emulation     : Byte;                  {413} (* 1=ANSI, 2=AVATAR, 4=ASCII *)
         TextFileType  : Byte;                  {414} (* 0=.ANS, 1->=others *)
         DateFormat    : Byte;                  {415} (* See later *)
         PasswordCRC   : LongInt;               {416} (* CRC password field *)
         UserDefNum    : Array [1..10] of LongInt;    (* User definable number variables *)
         LastVoteChk   : DateRec;               {460}
         TodayLastDesc : Byte;                  {462} (* Last DESCRIPT.xxx downloaded *)
         TimeUnits     : LongInt;                     (* 0=not used, -1=none left, >0=n units left *)
         KBUnits       : LongInt;                     (* 0=not used, -1=none left, >0=n units left *)
         Empty         : Array [1..29] of Byte; {463}
       end;

       (*

          Date format:

          Bits 0-1: 00 = MMDDYY
                    01 = DDMMYY
                    10 = YYMMDD

          Bits 2-3: 00 = "-"
                    01 = "."
                    10 = "/"
                    11 = " "

          Time format:

          Bit 4:     0 = ":"
                     1 = "."

          eg. 00000000 = MM-DD-YY HH:MM
              00010101 = DD.MM.YY HH.MM

       *)

       FlexUserIdxRec = Record (* USERINF2.IDX *)
         NameCRC32: LongInt;   (* CRC & FilePos -1 if record not used *)
         FilePos:   LongInt;
         AddrLen:   SmallWord;
         CmntLen:   SmallWord;
         MailLen:   SmallWord;
         MAreaCnt:  LongInt;
         FAreaCnt:  LongInt;
       end;

         StatisticRecord = Record
           Calls       : Array [1..MAX_LIMITBPS] of LongInt;
           Failed      : LongInt;
           NewUsers    : LongInt;
           PublicMsgs  : LongInt;
           PrivateMsgs : LongInt;
           UpK         : LongInt;
           UpTimes     : LongInt;
           DownK       : LongInt;
           DownTimes   : LongInt;
           Yells       : LongInt;
         end; (* 64 bytes *)


       ExitRecord = Record                  (* EXITINFO.DAT                  *)
         BpsRate     : SmallWord;           (* Bps rate div 100              *)
         COMport     : Byte;                (* COM port                      *)
         NodeNumber  : Byte;                (* Node number                   *)
         UserInfo    : CCUserRec;           (* User information              *)
         UserRecNum  : LongInt;             (* Record number in USERINFO.*   *)
         LogonTime   : DateTimeRec;         (* Current logon time            *)
         PageTimes   : Byte;                (* Times paged SysOp             *)
         PageReason  : ANameStr;            (* Page reason                   *)
         TimeLeft    : SmallInt;            (* Time left on this call        *)
         LimitLeft   : LongInt;             (* DL-limit left on this call    *)
         NextEvent   : CCEventRecord;       (* Time of next system event     *)
         NewNetmail  : Boolean;             (* User has entered new netmail  *)
         NewEchomail : Boolean;             (* User has entered new echomail *)
         LastMenu    : MenuStr;             (* Name of last menu entered     *)
         GosubLevel  : Byte;                (* Level of gosubs               *)
         GosubMenus  : GosubRecord;         (* Gosub menu name list          *)
         FlexInfo    : FlexUserIdxRec;      (* USERINF2.DAT index            *)
         LastInfo    : Byte;                (* Last caller attribute         *)
         CurrStat    : StatisticRecord;     (* Current call stats            *)
         LastTimeChk : SmallWord;           (* Last time check [internaluse] *)
         FilesLeft   : LongInt;             (* DL-files left on this call    *)
         EventRecNum : SmallWord;           (* NextEvent recnum, 0=misc.event*)
         GosubCursor : Array [1..MAX_GOSUB] of Byte; (* Gosub menu cursors   *)
         Empty: Array [1..407] of Byte;     (* Reserved for future expansion *)
       end;                                 (* USERINF2.DAT information      *)


(* MAJOR CHANGES :                                                       *)
(*                                                                       *)
(* Beta-7: Size of MAreaRec and DoorRec increased by 2 bytes             *)
(* Beta-8: String lengths expanded in ModemCfg and ProtocolRecord        *)
(* Beta-10: File database naming system from CRC-32 to sysop selectable, *)
(*          LimitRec expanded by FileLimit variable,                     *)
(*          EventRec expanded by LastRunTime variable                    *)
(* Beta-11: Script path to LanguageHeader                                *)
(*

CONFIG.DAT structure :

Place  Description               Appearance                        Definition

 1st - Configuration file header [1]                               (ConfigHdr)
 2nd - Main configuration record [1]                               (CCConfigRec)
 3rd - Modem response records    [0..CCConfigRec.Modems.ResponseCnt] (ModemResponseRec)
 4th - Net address records       [0..ConfigHdr.NetCnt]             (NetAddrRec)
 5th - User limit records        [0..ConfigHdr.Limits]             (LimitRecord)
 6th - System event records      [0..ConfigHdr.Events]             (EventRecord)
 7th - Transfer protocol records [0..ConfigHdr.Protos]             (ProtocolRecord)
 8th - Packer records            [0..ConfigHdr.Archives]           (ArchiveRecord)
 9th - Message editor records    [0..ConfigHdr.Editors]            (EditorRecord)
10th - Char set records          [0..ConfigHdr.CharSets]           (CharSetRecord)

Note: All records can be of fixed length. Record size fields in
      ConfigHdr should be used to read records correctly to memory.

Note: ConfigHdr.FAreaSize, ConfigHdr.MAreaSize and ConfigHdr.DoorSize
      record size fields are always read from CONFIG.DAT in system path.

*)