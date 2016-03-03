Const
 BlaBla: String[8] = '+++BLAHT';
{ EncVer: String[8] = 'Í<ÅºG'#236'z±'; {v1.72a  }
{ EncVer: String[8] = '0.99a        ';}
 Ver   : String[8] =  '0.99k        ';
 KeyVer: array[1..8] of Char = '§®NS†ç§ä';
 LangCnt           = 103;
 bbs_XX = 0;
 bbs_RA = 1;
 bbs_CC = 2;
 bbs_QK = 3;
 bbs_EZ = 4;

 BBSPrg: Array[0..4] Of String[12] = ('Generic','RemoteAccess','Concord','QuickBBS','EzyCom');

 RA_Areafile  = 'MESSAGES.RA';
 RA_Groupfile = 'MGROUPS.RA';

 CC_Areafile  = 'MAREAS.DAT';

 QK_AreaFile  = 'MSGCFG.DAT';

 EZ_AreaFile  = 'MESSAGES.EZY';

Type
 ExternalRec    = Record
   CmdData: String[59];
   CmdType: Byte;
  End;

 OldConfigRec      = Record                               { ** OLD ** }
   CfgHeader: String[35];                                 { ** OLD ** }
   UseTaglines,                                           { ** OLD ** }
   UseExpand,                                             { ** OLD ** }
   UseKeywords,                                           { ** OLD ** }
   CensorTags,                                            { ** OLD ** }
   Censor: Boolean;                                       { ** OLD ** }
   ExpandWord: Array[0..9,1..2] Of String[25];            { ** OLD ** }
   NC,HC,BC,PC,FZ,FC,FL,FS,FD,IC,ID,IL,IS: Byte;          { ** OLD ** }
   TagFileName: String[60];                               { ** OLD ** }
   TabStop: Byte;                                         { ** OLD ** }
   CensorChar: Char;                                      { ** OLD ** }
   Extra: Array[1..110] Of Byte;                          { ** OLD ** }
                                                          { ** OLD ** }
   OKTagArea,                                             { ** OLD ** }
   OKExpandArea,                                          { ** OLD ** }
   OKKeywordArea,                                         { ** OLD ** }
   OKTagCensorArea,                                       { ** OLD ** }
   OKCensorArea: Array[1..1024] Of Boolean;               { ** OLD ** }
                                                          { ** OLD ** }
   RAPath: String[60];                                    { ** OLD ** }         { RAPath }
   UsingRA: Boolean;                                      { ** OLD ** }         { True   }
                                                          { ** OLD ** }
   DataUEC: LongInt;                                      { ** OLD ** }
                                                          { ** OLD ** }
   TearLine: Byte;                                        { ** OLD ** }
                                                          { ** OLD ** }
   RegName: String[40];                                   { ** OLD ** }      { SysOpname }
                                                          { ** OLD ** }
   MaxQuotePct: Real;                                     { ** OLD ** }
   ForceLessQuote: Boolean;                               { ** OLD ** }
                                                          { ** OLD ** }
   VowelCensorOnly,                                       { ** OLD ** }
   RandomSymbolCensor: Boolean;                           { ** OLD ** }
                                                          { ** OLD ** }
   AbsMaxMsgLines: LongInt;                               { ** OLD ** }
                                                          { ** OLD ** }
   DOSSwap: Word;                                         { ** OLD ** }
                                                          { ** OLD ** }
   ForceCtlW: Boolean;                                    { ** OLD ** }
                                                          { ** OLD ** }
   SpellCheck: Byte; {0=No, 1=Yes, 2=Ask}                 { ** OLD ** }
   DictionaryPath: String[60];                            { ** OLD ** }
                                                          { ** OLD ** }
   QuoteWinSize: Byte;                                    { ** OLD ** }
                                                          { ** OLD ** }
   RA250: Boolean;                                        { ** OLD ** }        {VersionID}
                                                          { ** OLD ** }
   AltF1to10: Array[1..10] Of ExternalRec;                { ** OLD ** }
                                                          { ** OLD ** }
   ImportSecurity,                                        { ** OLD ** }
   ExportSecurity: LongInt;                               { ** OLD ** }
                                                          { ** OLD ** }
   ScrollSiz: Byte;                                       { ** OLD ** }
                                                          { ** OLD ** }
   CensorWords: Array[1..15] Of String[10];               { ** OLD ** }
                                                          { ** OLD ** }
   TimeOutDelay: Byte;                                    { ** OLD ** }
   ExtendedChars: Byte;                                   { ** OLD ** }
   NumTaglines: Byte;                                     { ** OLD ** }
                                                          { ** OLD ** }
   ExtraSpace: Array[1..1344] Of Byte;                    { ** OLD ** }
                                                          { ** OLD ** }
   CfgVer: String[5];                                     { ** OLD ** }
                                                          { ** OLD ** }
  End;                                                    { ** OLD ** }

 ConfigRec      = Record
   CfgHeader: String[35];
   ExpandWord: Array[0..9,1..2] Of String[25];
   NC,HC,BC,PC,FZ,FC,FL,FS,FD,IC,ID,IL,IS: Byte;
   TagFileName: String[60];
   TabStop: Byte;
   CensorChar: Char;

   BBSPath: String[60];                                  { Path to RA/CC/QK }
   BBSProg: Byte;                  { 0=Generic, 1=RA, 2=Concord, 3=QuickBBS }

   DataUEC: LongInt;

   TearLine: Byte;

   RegName: String[40];                                         { SysOpname }

   MaxQuotePct: Real;
   ForceLessQuote: Boolean;

   VowelCensorOnly,
   RandomSymbolCensor: Boolean;

   AbsMaxMsgLines: LongInt;

   DOSSwap: Word;                                    {AltJSwap,UseXMS,UseEMS}

   ForceCtlW: Boolean;

   SpellCheck: Byte; {0=No, 1=Yes, 2=Ask}
   DictionaryPath: String[60];

   QuoteWinSize: Byte;

   RA250: Boolean;                                                {VersionID}

   AltF1to10: Array[1..10] Of ExternalRec;

   ImportSecurity,
   ExportSecurity: LongInt;

   ScrollSiz: Byte;

   CensorWords: Array[1..15] Of String[10];

   TimeOutDelay: Byte;
   ExtendedChars: Byte;
   NumTaglines: Byte;

   UseTaglines,
   UseExpand,
   UseKeywords,
   UseExtra0,
   Censor,
   UseSigs,
   UseFilter,
   UseExtra1,
   UseExtra2,
   UseExtra3,
   UseExtra4,
   UseExtra5: Boolean;

   OKTagArea,
   OKExpandArea,
   OKKeywordArea,
   OKExtra1,
   OKCensorArea,
   OKSigArea,
   FilterArea: Array[1..1024] Of Boolean;

   DateFormat: Byte;   { 0=DD-Mmm-YY 1=DD-MM-YY 2=MM-DD-YY }
   TimeFormat: Byte;   { 0=01:00pm 1=13:00 }

   RepStr: String[15];

   AutoSave: Boolean;

   LanguageFile: String[8];
   OKSigHiBit: Boolean;

   FieldColor: Byte;

   WrapMargin: Byte;

   Extra: Array[1..6532] Of Byte;

   StartDate: LongInt;
   CfgVer: String[5];

  End;


 OldSigType     = Array[1..3] Of String[69];
 SigType        = Array[1..5] Of String[69];
 UserRec        = Record
   NameCRC      : LongInt;
   Expand       : Array[0..9,1..2] Of String[25];
   NC,HC,BC,PC,FZ,FC,FL,FS,FD,IC,ID,IL,IS: Byte;
   UseTagLines,
   UseExpand,
   UseKeywords  : Boolean;
   TagKeyword   : Array[1..4] Of String[10];
   ChgdColors   : Boolean;
   SigPtr       : LongInt;
   UseSpellChk  : Boolean;
   AutoTagline  : Boolean;
   AutoSigs     : Boolean;
   Name         : String[35];
   LangFile     : String[8];
   FieldColor   : Byte;
   Extra        : Array[1..82] Of Byte;
  End;

