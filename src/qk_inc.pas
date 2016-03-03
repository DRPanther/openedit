Type
  QKFlagType = array[1..4] of Byte;
  { Configuration Information ********************************************** }

  TypeMsgs  = (Standard,QKNetmail,FMail,QKEchoMail);
  KindMsgs  = (QKBoth,QKPrivate,QKPublic,QKROnly);

  QKAskType   = (QKNo, QKMaybe, QKYes);
  ProtocolEnableType = (Never, MNP_Only, Always);

  SecurityRecord = Record { part of main config record }
    Security : Word;
    Flags    : QKFlagType;
  End;

  BoardRecord = record (* MSGCFG.DAT *)
                  Name            : String[40];
                  Typ             : TypeMsgs;
                  Kinds           : KindMsgs;
                  Combined        : Boolean;
                  Aliases         : QKAskType;
                  Aka             : Byte;
                  OriginLine      : String[58];
                  AllowDelete     : Boolean;
                  KeepCnt,                (* Max # of Msgs to keep *)
                  KillRcvd,               (* Kill received msgs after this many days *)
                  KillOld         : Word; (* Kill msgs after this many days *)
                  ReadSec         : SecurityRecord;
                  WriteSec        : SecurityRecord;
                  TemplateSec     : SecurityRecord;
                  SysopSec        : SecurityRecord;
                  FileArea        : Integer;  (* for Fmail *)
                  Group           : Byte;
                  Spare           : Array[4..12] of Byte;
                end;

   FileKLimitRecord = record { For limit records }
                        Baud  : Word;
                        Limit : Integer;
                      end;

   ModemTranslationRecord = Record { for main config record }
                   TranslateFrom : String[25];
                   TranslateTo   : Word;
                 End;

   Key4Type = Array[1..4] of Word;

   NodeConfigRecord = record
                        Node      : Byte;
                                  (* Node #, can be overriden by -Nxx CmdLine *)

                       (*  Modem Parameters  *)

                        CommPort      : Integer;
                        InitBaud      : Word;
                        ModemDelay    : Word;
                        InitTimes,
                        AnswerWait    : Integer;
                        ModemInitStr,
                        ModemBusyStr  : String[70];
                        ModemInitResp,
                        ModemBusyResp : String[40];

                        ModemConnectResp : Array[1..20] of ModemTranslationRecord;

                        CBV_CallbackDelay,
                        CBV_WakeupDelay : Word;

                        ARQ_String      : String[8];
                        SendATA         : Boolean;

                        NetPath,
                        NodelistPath,
                        MsgPath,
                        SwapPath,
                        OverlayPath     : String[66];
                        EditorCmdStr,
                        UserEditor      : String[70];
                        OriginLine      : String[58];
                        MinBaud,
                        GraphicsBaud,
                        XferBaud        : Integer;

                       (* Callback verifier *)
                       VerifierInit    : string[35];
                       DialString      : string[15];
                       DialSuffix      : string[15];

                       (*  Default Information for New Users  *)
                       DefaultSec      : SecurityRecord;
                       MinimumSec      : SecurityRecord;
                       DefaultCredit   : Integer;
                       FastLogon       : Boolean;
                       ExtraSpace      : array[2..200] of byte;
                End;

   QKConfigRecord = record  (* QUICKCFG.DAT *)

                   VersionID : Word;

                   WasNodeInfo : Array[1..481] of Byte;
                   (*  System Paths  *)
                   WasEditorCmdStr    : String[70];
                   Stat6Line1,
                   Stat6Line2,
                   WasNetPath,
                   WasNodelistPath    : String[66];  
                   
                   (* Do Not Touch, for v2.81 BlueWave Compt *)
                   WasMsgPath         : String[66];  

                                (* You Can Touch *)
                   WasSwapPath,
                   WasOverlayPath     : String[66];

                   OldPrompts : Array[1..213] of Byte;

                   (* System misc strings *)
                   OldOriginLine      : String[58];
                   QuoteStr        : String[3];

                   (*  User Restrictions *)
                   LowBaudStart,
                   LowBaudEnd,
                   DownloadStart,
                   DownloadEnd     : LongInt;
                   MaxPageTimes,
                   PageBellLen     : Integer;
                   PagingStart,
                   PagingEnd       : LongInt;
                   OldBaudStuff    : Array[1..6] of Byte;

                   (*  Matrix Information  *)
                   MatrixZone,
                   MatrixNet,
                   MatrixNode,
                   MatrixPoint     : array[0..10] of Integer;
                   NetMailBoard    : Integer;

                   OldNewUserInfo : Array[1..14] of Byte;

                   (*  Sysop Security Etc. *)
                   SysopSecurity   : SecurityRecord;
                   SysopName       : String[35];
                   SystemName      : String[40];
                   RegKey          : LongInt;

                   (*  Misc System Parameters  *)

                   TextFileShells,
                   AltJswap,
                   Editorswap,
                   AutoLogonChar        : Boolean;

                   DeleteAttachs        : Boolean;
                   (* Delete Attach's is contained in the Old position for
                      FastLogon.  Fastlogon is now in Nodecfg *)
                   
                   UseLastRead,
                   MonoMode,
                   DirectWrite,
                   SnowCheck,
                   NetEchoExit,
                   OneWordNames,
                   CheckMail,
                   AskHomePhone,
                   AskDataPhone,
                   AskBirthday,
                   AskSex,
                   Use_Xmodem,
                   Use_Xmodem1k,
                   Use_Ymodem      : Boolean;
                   Use_YmodemG     : ProtocolEnableType;
                   Use_Kermit,
                   Use_Zmodem,
                   Inp_Fields,
                   GraphicsAvail,
                   ForceUS_Phone   : Boolean;
                   InactiveTimeOut : Integer;
                   LogonTime       : Integer;
                   DefFgColor      : Integer;
                   DefBgColor      : Integer;
                   PasswordTries   : Integer;
                   EntFldColor     : Byte; (* Color for entry fields *)
                   BorderColor     : Byte; (* Color for menu borders *)
                   WindowColor     : Byte;
                   StatusBarColor  : Byte;
                   UploadCredit    : Integer;
                   ScreenBlank     : Byte;

                   (* Callback verifier *)
                   CBV_Spare       : Array[1..68] of Byte;
                   DupeCheck       : Boolean;
                   NewUserSec,
                   MemberSec       : Word;
                   MemberFlags     : Array[1..4,1..8] of Char;
                   LDcost          : Word;
                   LDenable,
                   ResumeLocal,
                   ResumeLD        : Boolean;
                   LDstart,
                   LDend           : Longint;

                   ForgotPwdBoard  : Byte;
                   WasSendATA      : Boolean;

                   Location        : String[60];

                   ArchiveNetMail  : Boolean;

                   IEMSI,
                   IEMSI_New,
                   AutoAnsi,
                   MultiNode,
                   AutoLogChat     : Boolean;
                   WasUserEditor      : String[70];

                   FileAreaCols,
                   MsgAreaCols     : Byte;

                   NewUserExpiry   : Word;

                   PasswordLength  : Byte;

                   ShowIdle        : Boolean;

                   LocalRipExt     : String[3];

                   Key4            : Key4Type;

                   ExtraSpace      : Array[159..400] of Byte;

                 end;

  GosubDataType = array[1..20] of String[8];

  QKSysInfoRecord = record { SYSINFO.BBS }
                    CallCount        : LongInt;
                    LastCallerName   : String[35];
                    LastCallerAlias  : String[35];
                    ExtraSpace : array[1..92] of Byte;
                  end;

  QKTimeLogRecord = record { TIMELOG.BBS }
                    StartDate   : String[8];
                    BusyPerHour : array[0..23] of Integer;
                    BusyPerDay  : array[0..6] of Integer;
                  end;

  QKUserRecord = record { USERS.BBS or USERS.DAT }
                 Name        : String[35];
                 City        : String[25];
                 ReservedZero: Byte; { Reserved, should always be 0 }
                 Language    : Byte;
                 PwdCrc      : Longint;
                 PwdChangeDate,
                 ExpireDate  : Word; { Number of days since 1/1/1900 }
{$IFDEF GOLDBASE}
                 HighMsgRead : LongInt;
{$ELSE}
                 UnusedSpace : LongInt;
{$ENDIF}
                 Attrib2     : Byte;   
                 ExtraSpace  : Byte;
                 DataPhone,
                 HomePhone   : String[12];
                 LastTime    : String[5];
                 LastDate    : String[8];
                 Attrib      : Byte;
                 Flags       : QKFlagType;
                 Credit,
                 Pending,
{$IFDEF GOLDBASE}
                 TimesPosted : Word;
                 ObsoleteField,
{$ELSE}
                 TimesPosted,
                 HighMsgRead,
{$ENDIF}
                 SecLvl,
                 Times,
                 Ups,
                 Downs,
                 UpK,
                 DownK       : Word;
                 TodayK      : Integer;
                 Elapsed,
                 Len         : Integer;
                 CombinedPtr : Word; (* Record number in COMBINED.BBS *)
                                        (* Note:  0 signifies no combined record assigned *)

                 AliasPtr    : Word; (* Record number in ALIAS.BBS *)
                                      (* Note:  0 signifies no alias record assigned *)
                 Birthday    : Longint; { Number of days since 1/1/1900 }
               end;


(* Attrib:
      Bit 1: Deleted
      Bit 2: Screen Clear Codes
      Bit 3: More Prompt
      Bit 4: ANSI
      Bit 5: No-Kill
      Bit 6: Ignore Download Hours
      Bit 7: ANSI Full Screen Editor
      Bit 8: Sex (0=male, 1=female)
*)
(* Attrib2:
      Bit 1: Guest Account              (No Password Needed)
      Bit 2: SSR Configured On/Off      (False/0 = Unused., True/1 = Activated)
      Bit 3: Not Defined Yet (Should be False/0)
      Bit 4: Not Defined Yet (Should be False/0)
      Bit 5: Not Defined Yet (Should be False/0)
      Bit 6: Not Defined Yet (Should be False/0)
      Bit 7: Not Defined Yet (Should be False/0)
      Bit 8: User "Dirty" Flag (If False, User Logged off correctly.
                                If True, User Failed to Logoff Correctly)
                                ({Not Yet Used }
*)

   EventStat = (Deleted, Enabled, Disabled);
   
   QKEventRecord = record (* EVENTCFG.DAT *)
                  Status      : EventStat;
                  RunTime     : LongInt;
                  ErrorLevel  : Byte;
                  Days        : Byte;
                  Forced      : Boolean;
                  LastTimeRun : LongInt;
                  Spare       : Array[1..7] of Byte;
                end;

  QKExitRecord = record (* EXITINFO.BBS *)
                 BaudRate        : Integer;
                 SysInfo         : QKSysInfoRecord;
                 TimeLogInfo     : QKTimeLogRecord;
                 UserInfo        : QKUserRecord;
                 EventInfo       : QKEventRecord;
                 NetMailEntered  : Boolean;
                 EchoMailEntered : Boolean;
                 LoginTime       : String[5];
                 LoginDate       : String[8];
                 TmLimit         : Integer;
                 LoginSec        : LongInt;
                 Credit          : LongInt;
                 UserRecNum      : Integer;
                 ReadThru        : Word;
                 PageTimes       : Integer;
                 DownLimit       : Integer;
                 WantChat        : Boolean;
                 GosubLevel      : Byte;
                 GosubData       : GosubDataType;
                 Menu            : String[8];
                 ScreenClear     : Boolean;
                 MorePrompts     : Boolean;
                 GraphicsMode    : Boolean;
                 ExternEdit      : Boolean;
                 ScreenLength    : Integer;
                 MNP_Connect     : Boolean;
                 ChatReason      : String[48];
                 ExternLogoff    : Boolean;
                 ANSI_Capable    : Boolean;
                 CurrentLanguage : Byte;
                 RIP_Active      : Boolean;
                 ExtraSpace      : Array[2..200] of Byte;
               end;
