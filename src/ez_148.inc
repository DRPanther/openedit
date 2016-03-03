Const
    EZlocalmail = 0;
    EZnetmail   = 1;
    EZechomail  = 2;
    EZpassthru  = 3;
    EZwaitthru  = 4;
    EZallmail   = 5;
    EZmtLocal     = 0;
    EZmtNetmail   = 1;
    EZmtEchomail  = 2;
    EZmtPassThru  = 3;
    EZmtWaitThru  = 4;
    EZmtAllMail   = 5;
    EZmtInternet  = 6;
    EZmtNews      = 7;
    EZmtFax       = 8;


    userfree      = 121;
    maxaka        = 32;
    maxnodes     = 256;
    maxfree       = 1275;
    maxbaudrec   = 22;

Type
     domainstr      = string[20];  (* domain string *)
     showfilesizetype = byte;
     EZasktype        = byte;
     userstring     = string[35];
     EZflagtype       = array[1..4] of byte;
     grouptype      = array[1..4] of byte;
     str8           = string[8];
     areatagstr     = string[75];
     EZmsgtype        = byte;
     EZmsgkindstype   = byte;

     securitytype  = record
        security    : word;
        onflags,
        offflags    : EZflagtype;
     end;

     netrecord      = record
        zone,
        net,
        node,
        point   : word;
     end;

     daterecord     = record
        year        : word;
        month       : byte;
        day         : byte;
     end;

    (* **********************************************************

       Filename:     <systempath>MESSAGES.EZY

       Description:  Used by Ezycom to store message areas

       Size:         2048 records

       ********************************************************** *)

        EZmessagerecord  = record
           name           : string[30];
           areatag        : areatagstr;
           qwkname        : string[12];
           typ            : EZmsgtype;
           msgkinds       : EZmsgkindstype;
           attribute,
           (* Bit 0 : Allow Aliases
                  1 : Use Alias
                  2 : Use Alias, Ask for Aliases
                  3 : [Reserved]
                  4 : Combined Area Access
                  5 : Local File attaches
                  6 : Keep Private Bit on Incoming EchoMail
                  7 : Security *)
           attribute2,
           (* Bit 0 : Show Seenby Lines
                  1 : Forced Mail Check
                  2 : Tiny Seenbys
                  3-4 [Reserved]
                  5 : Areafix Info Visible
                  6 : Initial Combined Area Access
                  7 : Do Not Use in Template *)
           attribute3     : byte;
           dayskill,
           recvkill       : byte;
           countkill,
           kilobytekill   : word;
           readsecurity,
           writesecurity,
           sysopsecurity  : securitytype;
           minimumage     : byte;
           originline     : string[50];
           originaddress  : byte;
           seenby         : array[1..maxaka div 8] of byte;
           areagroup      : char;
           messgroup      : byte;
           altgroups      : array[1..3] of byte;
           echomailfeed   : byte; (* 0=No Uplink *)
           destnodes      : array[1..maxnodes div 8] of byte;
           (* Nodes  1 to  8 - DestNode[1]
              Nodes  9 to 16 - DestNode[2]
              Nodes 17 to 24 - DestNode[3]
              etc *)
           MsgIdxPos      : smallword; (* Position in Messages.Idx 0=No Record 1=Record 1*)
           ArrivalKill    : byte;
           freespace      : array[1..13] of char;
        end;

    (* **********************************************************

       Filename:    <configrec.userbasepath>USERS.BBS

       Description: Users File
                    Records in parrallel with USERSEXT.BBS
                    Records in parrallel with LASTCOMB.BBS

       Limitations: 65000 records (users) maximum

       Sharing:     Open in DenyNone + ReadWrite
                    When appending a new user,
                    Record 0 of USERS.BBS should be locked
                    LASTCOMB.BBS should be written
                    USERSEXT.BBS should be written
                    USERS.BBS should be written
                    Record 0 of USERS.BBS should be unlocked

       ********************************************************** *)

        EZusersrecord    = record
           name           : userstring;
           alias          : userstring;
           password       : string[15];
           security       : word;
           attribute,
              (* Bit 0 : Deleted
                     1 : Clear Screen
                     2 : More Prompt
                     3 : Ansi Capable
                     4 : Don't Kill User
                     5 : File Points Ignore
                     6 : Full Screen Ed
                     7 : Quiet Mode        *)
           attribute2,
              (* Bit 0 : Ignore File Ratios
                     1 : Extended IBM Characters
                     2 : On = MMDDYY Off = DDMMYY
                     3 : Ignore Paging Hours
                     4 : Exclude User
                     5 : Avatar Capable
                     6 : Ignore Menu Time Restrictions
                     7 : Ignore Message Ratios         *)
           attribute3,
              (* Bit 0 : Do Not Sound Page
                     1 : Page on Logon
                     2 : Hold Mailbox
                     3 : Use Combined Mailbox
                     4 : Gender (false = Male, true = Female)
                     5 : Guest Account
                   6-7 : [Reserved] *)
           attribute4  : byte;
              (* Bit 0-7 [Reserved] *)
           flags       : EZFlagType;
           dataphone,
           voicephone  : String[14];
     end;

    (* **********************************************************

       Filename:    <configrec.userbasepath>USERSEXT.BBS

       Description: Extended Users Information
                    Records in parrallel with USERS.BBS

       ********************************************************** *)


        EZusersextrarecord = record
           location       : string[25];
           lasttimedate   : longint;
              (* DOS Packed Date/Time *)
           credit,
              (* Users netmail credit *)
           pending        : word;
              (* Netmail cost pending export *)
           msgsposted,
           nocalls,
           uploads,
           todayk,
           timeused,
           downloads      : word;
           uploadsk,
           downloadsk     : longint;
           screenlength   : byte;
           lastpwdchange  : byte;
           timebanked,
           ksbanked,
           filepoints     : word;
           qwkcompression : byte;
           qwkdaysold     : byte;
           comment        : string[40]; (* Sysop/User Comment *)
           colour1_2,  (* To retrieve the first colour AND 15
                          To retrieve the second colour SHR 4  *)
           colour3_4,
           colour5_6,
           colour7_8,
           bkcolour        : byte;
           sessionfailures : byte; (* Number of Session Failures since last
                                      successful logon *)
           topmenu         : str8; (* User's Top Menu *)
           filepointsgiven : word;
              (* Number of Filepoints credited since last logon *)
           dateofbirth     : daterecord;
           groups          : grouptype; (* user's group setting (compressed) *)
           regodate,                    (* Start of Registration *)
           firstdate,                   (* Date of First Logon *)
           lastfiledate    : word; (* Last Time a New Files Search was done *)
           defprotocol     : char; (* Blank means no default protocol *)
           timeleft        : word; (* Users remaining time for today *)
           filearea        : word; (* Last file area user used *)
           messarea        : word; (* Last message area user used *)
           qwkmaxmsgs      : word;
           qwkmaxmsgsperarea : word;
           todaybankwk     : integer; (* Kilobytes Withdrawn from Bank Today
                                        Negative Numbers indicate Deposited *)
           forwardto       : userstring; (* forward local mail to *)
           todaycalls      : byte;    (* Times the user has called today *)
           todaybankwt     : integer; (* Time Withdrawn from Bank Today
                                         Negative Numbers indicate Deposited *)
           language        : byte;    (* users language *)
           endregodate     : word;    (* End Registration Date *)
           tottimeused     : longint; (* Total Time Used by the User
                                         since the last time this field was
                                         reset.  Normally first logon *)
           lastbwpkt       : string[3];
           extraspace      : array[1..userfree] of byte;
        end;


    (* **********************************************************

       Filename:    <systempath>EXITINFO.<node>

       Description: Used by Ezycom in Type 15 exits to return
                    Used by Ezycom in Type 7 exits for door
                       information

       Last Revised : 16/1/94(pwd)

       ********************************************************** *)

       EZexitinforecord = record
          oldbaud,
          oldlockedbaud  : word;
          comport        : byte; (* Comport 1 = Com1, etc *)
          efficiency     : word; (* Baud Rate efficiency *)
          userrecord     : word; (* User Record Number (0=User1) *)
          userinfo       : EZusersrecord;
          userextra      : EZusersextrarecord;
          sysopname,             (* Sysop's Name *)
          sysopalias     : userstring;
          system         : string[40];
          downloadlimit  : word; (* Maximum Download Limit *)
          timelimit      : word; (* Daily Time Limit *)
          timetakenevent : word;
             (* Number of Minutes Taken from User for Event *)
          timecreated    : longint;
             (* Number of Seconds since Midnight *)
          timeofnextevent   : longint;
             (* Number of Seconds since Midnight *)
          timetillnextevent : longint;
             (* Number of Seconds after Time Created *)
          dayofnextevent : byte;
             (* 0 = Sunday
                ..........
                6 = Saturday
                7 = NOEVENT *)
          errorlevelofnextevent : byte;
             (* Errorlevel to return from next event *)
          ratio          : byte; (* File Ratio *)
          credit         : word; (* File Ratio Credit *)
          ratiok         : byte; (* Kilobyte Ratio *)
          creditk        : word; (* Kilobyte Ratio Credit *)
          regodays       : word; (* Registration Days *)
          creditmess     : word; (* Post Call Ratio Credit *)
          mess           : word; (* Post Call Ratio *)
          logintimedate  : datetime; (* Login Datetime *)
          stack          : array[1..20] of str8; (* Menu Stack *)
          stackpos       : byte; (* Menu Stack Position (0 = No Stack) *)
          curmenu        : str8; (* Current Menu *)
          oldpassword    : string[15];
          limitrecnum    : word; (* Limits Record Being Used *)
          baudrecnum     : byte; (* BaudRate Record Being Used *)
          ripactive      : boolean;
          maxpages       : byte; (* Maximum Pages *)
          pagedsysop     : byte; (* Number of Times User has Paged Sysop *)
          wantchat       : boolean;
          pagestart,
          pageend        : longint; (* Number of Seconds since Midnight *)
          pagelength     : byte;    (* Page Length *)
          echoentered,
          netentered,
          nextsysop      : boolean;
          inactivitytime : word;    (* Seconds *)
          protrecnum     : byte;
             (* Default Protocol Record Number 0=NoDefault *)
          protname       : string[15]; (* Default Protocol Name *)
          didwhat        : byte;       (* Didwhat flag for Todays Callers *)
          pagereason     : string[60];
          mtasker        : byte;
            (*  Time Slice Routine to use
                0 = No Multitasker
                1 = [Reserved]
                2 = Desqview
                3 = Double DOS
                4 = OS/2 or Windows
                5 = MultiDOS Plus
                6 = TASKview
                7 = TOPview
                9 = PCMOS
           10..255 = [Reserved] *)
          iemsi_session  : boolean;
          iemsi_req1,
             (* Bit 0 = News
                    1 = Mail
                    2 = File
                    3 = Clrscr
                    4 = Quiet
                    5 = More
                    6 = FSE
                    7 = [Reserved] *)
          iemsi_req2,
             (* Bit 0-7 = [Reserved] *)
          iemsi_scrlen   : byte;
             (* Screen Length for current session
                If NOIEMSI session, this is set to the
                   users screen length *)
          iemsi_prot,
             (* Bit 0 = ZModem
                    1 = SEAlink
                    2 = Kermit
                    3 = ZedZap *)
          iemsi_crt,
             (* 0 = TTY
                1 = ANSI
                2 = AVT0+
                3 = VT100
                4 = VT52 *)
          iemsi_cap      : byte;
             (* Bit 0 = CHT
                    1 = MNU
                    2 = TAB
                    3 = ASCII8 *)
          pagesound      : boolean;
          timeconnect    : longint; (* time connected this call *)
          screenon       : boolean; (* whether ezycom is displaying the
                                       screen locally or not *)
          baud           : longint; (* Speed between Modem/Modem *)
          lockedbaud     : longint; (* Speed between Computer/Modem *)
          freespace      : array[1..86] of byte;
       end;

       EZsysinforecord = record
          callcount      : longint;
          lastcaller     : userstring;
          filessizek     : longint; (* Updated by EzyIDX -BUILD *)
          newusers,
          newfiles,
          newmessages    : word;    (* Does NOT include Inbound Echomail *)
          lastalias      : userstring;
          laststarttime  : word;    (* The start of the last session by a user *)
          extraspace     : array[1..80] of byte;
       end;

    (* **********************************************************

       Filename:    CONSTANT.EZY

       Description: Constant Configuration Information

       ********************************************************** *)

        constantrecord    = record
           version         : string[8];
           system          : string[40];
           sysopname,
           sysopalias      : userstring;
           systemlocation  : string[35];
           multiline       : boolean; (* multiline operation *)
           maxmess,                   (* maximum usable message areas *)
           maxfile,                   (* maximum usable file areas *)
           watchmess,                 (* watchdog message area *)
           pagemessboard,             (* paging message board *)
           badpwdmsgboard  : word;    (* bad logon message board *)
           mintimeforcall  : byte;    (* minimum time to register call today *)
           DupeTableMsgs   : longint; (* number of messages in ezymail dupe table *)
           MaxCDCopyK      : smallword;    (* Maximum Kilobytes to copy for CD copy for batch *)
           FPDispChars,
           UpldrDispChars,
           DnCntDispChars  : Byte;
           ExpireWarning   : smallword;
           scantossattr,              (* ezymail scan/toss info *)
              (* Bit 0 : Dupe Detection
                     1 : Kill Null Netmail
                     2 : Keep EchoArea Node Receipts
                     3 : Import Messages to Sysop
                     4 : Binkley Support
                     5 : Kill Bad Archives
                     6 : ArcMail 0.6 Compatability
                     7 : Binkley 5D Support
                     8 : Generate Crash Hold Mail
                     9 : Erase Netmail File Attach Files too the System
                   10-15 [Reserved] *)
           constantattr,
              (* Bit 0 : Sysop Alias in Chat
                     1 : Auto Log Chat
                     2 : Display Full Message to User
                     3 : Do not delete outbound mail bundles with no .MSG
                     4 : On means do not use real name kludge line
                     5 : User can write messages to user of same name
                     6 : Users receive their OWN QWK Mail postings back
                     7 : Show Sysop in Who's Online List
                     8 : Allow Taglines in BlueWave
                     9 : Show Colour in filebases
                    10 : Copy files from CD before download
                    11 : Local Uploads/Downloads only allowed from/to Floppy Disk
                    12 : Keep Batch History
                    13 : Do not Check for Duplicate Uploads
                    14 : Do not extract FileIDs on Upload
                    15 : Convert Uploaded FileIDs PCB Colour to Ezycom  *)
           maxmsgsrescan   : word;    (* Maximum msgs to rescan (0=disable) *)
           qwkfilename     : str8;    (* Unique QWK Mail filename *)
           qwkmaxmail      : word;    (* Maximum Msgs for QWK archive *)
           qwkmsgboard     : word;    (* Bad QWK Message Board *)
           UserFileDisplay,
           SysopFileDisplay : String[100];
           MaxDaysOldUpload : word;
           MaxFileGroups   : word;
           MaxOldNewFileCheck : byte;
           CallTermTime    : byte;      (* number of seconds for call terminator *)
           quotestring     : string[5]; (* quote messsage string *)
           swaponezymail   : byte;      (* ezymail swapping information *)
           unknownarea     : byte;      (* unknown new area tag action *)
              (* 0 : Kill Messages
                 1 : Make a New EchoMail Area
                 2 : Make a New PassThru Area *)
           swaponfeditview : byte;      (* FEdit swapping information *)
           swaponarchive   : byte;      (* Ezymaint swapping information *)
           minspaceupload  : word;      (* minimum space to upload *)
           textinputcolour : byte;      (* default text input colour *)
           badmsgboard     : word;      (* Bad echomail msg board *)
           netaddress      : array[1..maxaka] of netrecord;
           domain          : array[1..maxaka] of domainstr;
           netmailboard    : array[1..maxaka] of word;
           newareagroup    : array[1..maxaka] of char;
           newareastmess   : array[1..maxaka] of word;
           newareatemplate : array[1..maxaka] of word;
           SysopPwd        : String[15];
           ExitWaitCallPwd : String[15];
           MaxMsgGroups    : word;
        end;

    (* **********************************************************

       Filename     : CONFIG.EZY

       Description  : Configuration Record

       Size         : 1 record (6144 bytes)

       Last Revised : 25/12/92(pwd)

       ********************************************************** *)

     EZconfigrecord = record
                     version      : str8;
   (* unused *)      freespace01  : array[1..77] of byte;
                     logpath,
   (* unused *)      atextpath,
   (* unused *)      amenupath,
   (* unused *)      amnurampath,
                     netmailpath,
                     nodelistpath,
                     msgpath,
                     filepath,
   (* unused *)      freespace02,
                     binkleyoutpath,
                     temppath,
                     userbasepath,
   (* unused *)      aavatarpath,
   (* unused *)      aascpath,
   (* unused *)      aasclowpath,
                     filemaint,
                     fileattachpath,
                     soundpath,
                     fastindexpath : string[60];
                     systempwd,                 (* Password to Logon System *)
                     freespace02a,
                     newuserpwd   : string[15]; (* Password for Newuser *)
                     newtopmenu   : str8;       (* NewUser TopMenu *)
                     newusergroups : array[1..4] of byte;
                     inboundmail,
                     outboundmail,
                     uploadpath,
                     swapfile,
                     multipath    : string[60];
                     brackets     : string[2];
                     inactivitytime,
                     minmesscheck,
                     maxlogintime : byte;
   (* unused *)      freespace03  : smallword;
                     shellswap,
                     highbit,
                     disppass,
                     asklocalpass,
                     fastlogon,
                     sysopremote,
                     printerlog,
                     phone1ask,
                     colourask,
                     aliasask,
                     dobask,
                     phoneforce,
                     direct_video,
                     snow_check   : boolean;
   (* unused *)      freespace04  : byte;
                     screen_blank : byte;
                     oneword      : boolean;
                     checkmail,
                     checkfile,
                     ansiask,
                     fullscreenask,
                     clearask,
                     moreask,
                     avatarask,
                     extendask,
                     usdateask    : EZasktype;
                     phone2ask    : boolean;
                     phoneformat  : string[14];
                     freespace04a,
                     freespace04b,
                     shellprompt,
                     shell2prompt,
                     enterprompt,
                     chatprompt,
                     listprompt   : string[60];
                     f7keylinetop,
                     f7keylinebot : string[79];
   (* unused *)      freespace05  : array[1..84] of byte;
                     chat2prompt,
   (* unused *)      freespace05a,
   (* unused *)      freespace05b,
   (* unused *)      freespace05c,
   (* unused *)      freespace05d,
                     loadprompt,
   (* unused *)      freespace05e,
   (* unused *)      freespace05f  : string[60];
                     security,
                     logonsecurity : smallword;
                     flags         : EZflagtype;
                     minpasslength,
   (* constant *)    dispfwind,                (* Status Bar Colour *)
   (* constant *)    dispbwind,                (* Status Bar Colour *)
   (* constant *)    disppopupf,               (* Popup Forground  *)
   (* constant *)    disppopupborder,          (* Popup Border     *)
   (* constant *)    disppopupb,               (* Popup Background *)
   (* constant *)    dispf        : byte;      (* Foreground Colour *)
   (* unused *)      freespace06  : smallword;
                     passlogons   : byte;
                     doblogon     : byte;
                     printerport,
                        (* 0 : LPT1
                           1 : LPT2
                           2 : LPT3
                           3 : COM1
                           4 : COM2
                           5 : COM3
                           6 : COM4  *)
                     passtries      : byte;
                     topmenu        : string[8];
                     IncomingCallStart,          (* start of bell sound *)
                     IncomingCallEnd : smallword;     (* end of bell sound *)
   (* constant *)    watchmess,
   (* constant *)    netmailcredit  : smallword;
                     ansiminbaud    : longint;
                     slowbaud,
                     minloginbaud   : smallword;
                     lowsecuritystart,
                     lowsecurityend,
                     slowstart,
                     slowend        : smallword;
                     quotestring    : string[5];
   (* unused *)      freespace09    : smallword;
                     forcecrashmail,
                     optioncrashmail,
                     netmailfileattach : smallword;
   (* Constant *)    popuphighlight    : byte;     (* Popup Highlight Colour *)
                     GenderAsk         : boolean;
                     maxpages,
                     maxpagefiles,
                     pagelength     : byte;
                     pagestart      : array[0..6] of smallword;
   (* unused *)      freespace50,
                     localfattachsec,
                     sectouploadmess,
                     sectoupdateusers,
                     readsecnewecho,
                     writesecnewecho,
                     sysopsecnewecho,
                     secreplyvianetmail : smallword;
                     netmailkillsent    : EZasktype;
                     swaponarchive      : byte;

   (* unused *)      freespace11    : array[1..9] of byte;

   (* Constant *)    popuptext      : byte;           (* Popup Text Colour *)
                     pageend        : array[0..6] of smallword;
                     StartPeriod    : smallword;
   (* unused *)      freespace12    : array[1..24] of byte;

                     fp_upload      : smallword; (* File Points Upload Credit *)

                     altf           : array[1..10] of string[60];
                     ctrlf          : array[1..10] of string[40];
   (* unused *)      freespace13    : array[1..4] of byte;
                     fp_credit      : smallword; (* Newuser Filepoints *)
                     ks_per_fp,             (* Number of Kilobytes per FP *)
   (* unused *)      freespace14,
                     rego_warn_1,
                     rego_warn_2    : byte;
   (* unused *)      freespace15    : array[1..2] of byte;
   (* constant *)    min_space_1    : smallword;
   (* unused *)      freespace14b   : smallword;
                     scrheight      : boolean; (* 43/50 line mode *)
                     msgtmptype     : boolean;
                        (* True  = MSGTMP
                           False = MSGTMP.<node> *)
                     swapupload     : boolean;
                     phonelogon     : byte;
                     carrierdetect  : byte; (* Carrier Detect (Default=$80) *)
                     newfileshighlight : boolean;
                     max_descrip    : byte;
                     min_descrip    : byte;
                     requestreceipt : smallword;

                     freespace16    : array[1..16] of byte;

                     fp_percent      : smallword; (* Download Filepoints Credit *)
                     autodetect      : byte;
                        (* Bit 0 : Auto Detect ANSI
                               1 : ANSI Detect for NewUser
                               2 : Auto Detect IEMSI
                               3 : IEMSI Detect for NewUser
                               4 : Auto Detect RIP
                               5-7 [Reserved] *)
                     dispsecurityfile,
                     askforpagereason,
                     delincompletefiles : boolean;
   (* unused *)      freespace18      : byte;
   (* constant *)    swaponfeditview  : byte;

   (* unused *)      freespace19      : smallword;

                     passchar        : char;
                     localinactivity : boolean;
   (* unused *)      freespace20     : byte;
                     leftbracket     : string[1];
                     rightbracket    : string[1];
                     ignorefp        : smallword; (* Min Security to Ignore FPs *)
                     menuminage      : byte; (* Minimum Age for Age Checks *)
   (* unused *)      freespace22     : array[1..231] of byte;
                     configattr      : smallword;
                        (* Bit  0 : Move Local Uploads
                               1-15 [Reserved] *)
                     usercol1_2,
                     usercol3_4,
                     usercol5_6,
                     usercol7_8,
                     userbkcol       : byte;
                     newusercol2     : byte;
                     chstatcol       : byte;
                     getentercol     : byte;
                     usdateforsysop  : boolean;
                     ezyovrpath      : string[60];
                     DefaultUploader : UserString;
                     ovremsxms       : byte;
                        (* 0 = None
                           1 = XMS
                           2 = EMS
                           3 = XMS/EMS *)
                     swapezy         : byte;
                     filesecpath     : string[60];
   (* unused *)      freespace24     : byte;
                     multitasker     : byte;
                     (*  0 = Do Not Detect or Use Any MultiTasker
                         1 = Auto-Detect
                         2 = Desqview
                         3 = Double DOS
                         4 = OS/2
                         5 = MultiDOS Plus
                         6 = Taskview
                         7 = Topview
                         8 = Windows Enhanced Mode
                         9 = PCMOS
                         10..255 [Reserved] *)
   (* unused *)      freespace24b    : array[1..3] of byte;
                     filereqsec      : smallword;
   (* unused *)      freespace24c    : array[1..255] of char;
                     externaleditor  : string[60];
                     defaultorigin   : string[50];
   (* unused *)      freespace25     : array[1..32] of byte;
                     uploadcredit    : smallword;
                        (* Upload Credit Percentage *)
                     freespace       : array[1..maxfree] of byte;
                  end;
