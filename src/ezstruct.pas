(* ***********************************************************************
*                                                                        *
*    Ezycom Structures V1.48g0                                           *
*    Copyright (C) Peter Davies 1992-1996.  All Rights Reserved.         *
*                                                                        *
*    Date: 29/11/96                                                      *
*                                                                        *
*********************************************************************** *)

(*  Pascal to C

     All Strings require one extra character.
     The first field of a string [0] is the length of the string *)

(*   Turbo Pascal defines

     DateTime = Record
        Year,
        Month,
        Day,
        Hour,
        Min,
        Sec   : word;
     end; *)

{$IFNDEF OS2}
   type
      smallint       = integer;
      smallword      = word;

   const
      {$IFDEF DPMI}
          OSTYPE = 'DPMI16';
      {$ELSE}
          OSTYPE = 'DOS16';
      {$ENDIF}

{$ELSE}
   const
      OSTYPE = 'OS2';

  {$AlignRec-}  (* Make sure we use Byte Alignment for records *)
{$ENDIF}


const
    version       = '1.48g0';
    versionhigh   = 1;
    versionlow    = 48;
    productname   = 'Ezycom';
    copyright     = 'Peter Davies';
    copyrightyear = '1992-1996';
    maxfree       = 1275;
    userfree      = 121;
    constantfilefreespace = 439;
    maxnodes     = 256;
    maxaka       = 32;
    maxmessall   = 1536;
    maxmess      = maxmessall;
    maxbaudrec   = 22;
    maxmenus       = 101;
    maxglobalmenus = 20;

    (* Message Types *)

    localmail = 0;
    netmail   = 1;
    echomail  = 2;
    passthru  = 3;
    waitthru  = 4;
    allmail   = 5;
    mtLocal     = 0;
    mtNetmail   = 1;
    mtEchomail  = 2;
    mtPassThru  = 3;
    mtWaitThru  = 4;
    mtAllMail   = 5;
    mtInternet  = 6;
    mtNews      = 7;
    mtFax       = 8;

    (* Ask Types *)

    askyes    = 0;
    askno     = 1;
    askask    = 2;
    askaskyes = 2;   (* extended ask defaults to yes *)
    askaskno  = 3;   (* extended ask defaults to no *)

    (* Phone Types *)

    business  = 0;
    data      = 1;
    nophone   = 2;

    (* File Size Types *)

    nosize    = 0;
    sizebytes = 1;
    sizekilobytes = 2;

    (* Message Kinds Type *)

    public        = 0;
    private       = 1;
    privatepublic = 2;

    (* Swapping Types *)

    SwapwithNone   = 0;
    SwapwithEMS    = 1;
    SwapwithXMS    = 2;
    SwapwithDISK   = 3;
    SwapwithEMSXMS = 4;
    SwapwithXMSEMS = 5;

    (* User Attributes *)

    usr1deleted          = 0;
    usr1clrscr           = 1;
    usr1moreprompt       = 2;
    usr1ansicapable      = 3;
    usr1nokill           = 4;
    usr1filepointignore  = 5;
    usr1fullscreened     = 6;
    usr1quietmode        = 7;
    usr2ignorefileratios = 0;
    usr2ibmextended      = 1;
    usr2dateformat       = 2;
    usr2ignorepaging     = 3;
    usr2excludeuser      = 4;
    usr2avatarcapable    = 5;
    usr2ignoretime       = 6;
    usr2ignoremessratio  = 7;
    usr3nopagesound      = 0;
    usr3pageatlogon      = 1;
    usr3holdmailbox      = 2;
    usr3combinedmailbox  = 3;
    usr3femaleuser       = 4;
    usr3guestaccount     = 5;

    (* Constant ScanTossAttr *)

    stdupedetection       = 0;
    stkillnullnetmail     = 1;
    stkeepechoarea        = 2;
    stimportmsgssysop     = 3;
    stbinkleysupport      = 4;
    stkillbadarchives     = 5;
    starcmailcompat       = 6;
    stbinkley5dsupport    = 7;
    stgencrashholdmail    = 8;
    sterasenetmailfattach = 9;

    (* Constant ConstantAttr *)

    casysopaliasinchat       = 0;
    caautocapturechat        = 1;
    cadisplayfullmessage     = 2;
    canodelmailbundle        = 3;
    carealnamekludge         = 4;
    cawritemessagetoself     = 5;
    caqwkpostingtouser       = 6;
    cashowsysopinonline      = 7;
    caallowtaglinesinbw      = 8;
    cashowcolourinfileareas  = 9;
    cacopyfilescd            = 10;
    calocalupdnonlyfd        = 11;
    caKeepBatchHistory       = 12;
    caNoDupeCheck            = 13;
    caNoFileIDExtract        = 14;
    caConvertFileIDPCBColour = 15;

    (* File Line Attributes *)

    flchecked            = 0;
    flnokill             = 1;
    floffline            = 2;
    flprivate            = 4;
    fldeleted            = 5;

    (* Config ConfigAttr *)

    comovelocaluploads   = 0;

    (* Language Attribute *)

    laDefault            = 0;

type
     filestr        = string[12];  (* max length of a filename *)
     domainstr      = string[20];  (* domain string *)
     areatagstr     = string[75];
     asktype        = byte;
     phonetype      = byte;
     msgtype        = byte;
     msgkindstype   = byte;
     showfilesizetype = byte;
     maxstr         = string[255];
     userstring     = string[35];
     date           = string[8];
     str2           = string[2];
     str3           = string[3];
     str4           = string[4];
     str8           = string[8];
     str12          = string[12];
     str23          = string[23];
     str30          = string[30];
     str72          = string[72];
     str128         = string[128];
     flagtype       = array[1..4] of byte;
     grouptype      = array[1..4] of byte;

     securitytype  = record
        security    : smallword;
        onflags,
        offflags    : flagtype;
     end;

     daterecord     = record
        year        : smallword;
        month       : byte;
        day         : byte;
     end;

     netrecord      = record
        zone,
        net,
        node,
        point   : smallword;
     end;

     net5drecord    = record
        zone,
        net,
        node,
        point   : smallword;
        domain  : domainstr;
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

        usersrecord    = record
           name           : userstring;
           alias          : userstring;
           password       : string[15];
           security       : smallword;
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
           flags       : FlagType;
           dataphone,
           voicephone  : String[14];
        end;


    (* **********************************************************

       Filename:    <configrec.userbasepath>USERSEXT.BBS

       Description: Extended Users Information
                    Records in parrallel with USERS.BBS

       ********************************************************** *)


        usersextrarecord = record
           location       : string[25];
           lasttimedate   : longint;
              (* DOS Packed Date/Time *)
           credit,
              (* Users netmail credit *)
           pending        : smallword;
              (* Netmail cost pending export *)
           msgsposted,
           nocalls,
           uploads,
           todayk,
           timeused,
           downloads      : smallword;
           uploadsk,
           downloadsk     : longint;
           screenlength   : byte;
           lastpwdchange  : byte;
           timebanked,
           ksbanked,
           filepoints     : smallword;
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
           filepointsgiven : smallword;
              (* Number of Filepoints credited since last logon *)
           dateofbirth     : daterecord;
           groups          : grouptype; (* user's group setting (compressed) *)
           regodate,                    (* Start of Registration *)
           firstdate,                   (* Date of First Logon *)
           lastfiledate    : smallword; (* Last Time a New Files Search was done *)
           defprotocol     : char; (* Blank means no default protocol *)
           timeleft        : smallword; (* Users remaining time for today *)
           filearea        : smallword; (* Last file area user used *)
           messarea        : smallword; (* Last message area user used *)
           qwkmaxmsgs      : smallword;
           qwkmaxmsgsperarea : smallword;
           todaybankwk     : smallint; (* Kilobytes Withdrawn from Bank Today
                                        Negative Numbers indicate Deposited *)
           forwardto       : userstring; (* forward local mail to *)
           todaycalls      : byte;    (* Times the user has called today *)
           todaybankwt     : smallint; (* Time Withdrawn from Bank Today
                                         Negative Numbers indicate Deposited *)
           language        : byte;    (* users language *)
           endregodate     : smallword;    (* End Registration Date *)
           tottimeused     : longint; (* Total Time Used by the User
                                         since the last time this field was
                                         reset.  Normally first logon *)
           lastbwpkt       : string[3];
           extraspace      : array[1..userfree] of byte;
        end;

    (* **********************************************************

       Filename:     <userbasepath>LASTCOMB.BBS

       Description:  Used be Ezycom for lastread & combined info

       Note:         This record adjusts when the number of
                     conferences change (in steps of 16).
                     IE: 16 conferences takes up HALF of the
                          diskspace of 32 conferences

       ********************************************************** *)

        userslastrecord = record (* LASTCOMB.BBS *)
           combinedinfo    : smallword;
           lastreadinfo    : array[0..15] of smallword;
        end;


    (* **********************************************************

       Filename:    <configrec.menupath>????????.MNU

       Description: Menu Structure
                    Record 0 has a different record structure

       Mimimum    : 1 record
       Maximum    : 101 records


       Record 0 Structure

       typ      = HiLight Colour
       display  = Menu Prompt
       colour   = Menu Prompt Colour

       all others are undefined

       ********************************************************** *)


        menurecord      = record (* *.MNU *)
           typ            : smallword;
           security       : securitytype;
           maxsecurity    : smallword;
           display        : string[90];
           hotkey         : char;
           miscdata       : string[90];
           colour         : byte;
           timeonline,
           timeleft       : byte;
           timestart,
           timeend        : smallword;
              (* Hours is "* 100" *)
           minbaudrate,
           maxbaudrate    : longint;
           filepoints     : smallword;
           age            : byte;
           attribute      : smallword;
              (* bit 0 : Test Ratio K           / Record 0 : Enter Redraws
                     1 : Test Message/Call Ratio
                     2 : Automatic Option
                     3 : Test Ratio Files
                     4 : Local Keyboard Only
                     5 : Remote Only
                  6-15 : [Reserved] *)
            Node           : array[1..32] of byte;
            GenderAccess   : char;
               (* M=Male F=Female B=Both *)
            PadTo384Bytes  : array[1..134] of byte;
         end;

    (* **********************************************************

       Filename:    PROTOCOL.EZY

       Description: Protocol Record Structure

       Size       : 60 records

       ********************************************************** *)


        protocolrecord = record (* PROTOCOL.EZY *)
           name             : string[15];
           activekey        : char;
           attribute        : byte;
              (* bit 0 = enable/disable
                     1 = batch protocol
                     2 = [ Reserved ]
                     3 = both directions
                     4 = up/down
                     5 = bidirectional
                     6-7 [ Reserved ] *)
           logfilename,
           ctlfilename,
           dnctlstring      : string[60];
           dncmdstring,
           upcmdstring      : string[100];
           uplogkeyword,
           dnlogkeyword,
           uperrkeyword,
           dnerrkeyword,
           uperr2keyword,
           dnerr2keyword    : string[10];
           xfernamewordnum  : Byte;
           xfercpswordnum   : byte;
           security         : smallword;
           flags            : flagtype;
           efficiency       : byte;
        end;

    (* **********************************************************

       Filename     : CONFIG.EZY

       Description  : Configuration Record

       Size         : 1 record (6144 bytes)

       Last Revised : 25/12/92(pwd)

       ********************************************************** *)

     configrecord = record
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
                     usdateask    : asktype;
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
                     flags         : flagtype;
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
                     netmailkillsent    : asktype;
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
           badpwdmsgboard  : smallword;    (* bad logon message board *)
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
           maxmsgsrescan   : smallword;    (* Maximum msgs to rescan (0=disable) *)
           qwkfilename     : str8;    (* Unique QWK Mail filename *)
           qwkmaxmail      : smallword;    (* Maximum Msgs for QWK archive *)
           qwkmsgboard     : smallword;    (* Bad QWK Message Board *)
           UserFileDisplay,
           SysopFileDisplay : String[100];
           MaxDaysOldUpload : smallword;
           MaxFileGroups   : smallword;
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
           minspaceupload  : smallword;      (* minimum space to upload *)
           textinputcolour : byte;      (* default text input colour *)
           badmsgboard     : smallword;      (* Bad echomail msg board *)
           netaddress      : array[1..maxaka] of netrecord;
           domain          : array[1..maxaka] of domainstr;
           netmailboard    : array[1..maxaka] of smallword;
           newareagroup    : array[1..maxaka] of char;
           newareastmess   : array[1..maxaka] of smallword;
           newareatemplate : array[1..maxaka] of smallword;
           SysopPwd        : String[15];
           ExitWaitCallPwd : String[15];
           MaxMsgGroups    : smallword;
        end;

        compressrecord = record
           echounarccmd    : array[0..9] of String[12];
           echounarcpar    : array[0..9] of String[18];
           echoarccmd      : array[0..9] of String[12];
           echoarcpar      : array[0..9] of String[18];
        end;

        constantfilefreespacetype = array[1..constantfilefreespace] of byte;

const   (* the following constants are the starting positions in
           CONSTANT.EZY of where to find these structures *)

        startofcompress = sizeof(constantrecord) + sizeof(constantfilefreespacetype);

type
        constantfilerecord = record
           constant  : constantrecord;
           freespace : constantfilefreespacetype;
           compress  : compressrecord;
        end;

    (* **********************************************************

       Filename:     MODEM.EZY

       Description:  Holds Modem Configuration Information

                     Sequence of Reading
                        System>Modem.<node>
                        Current>Modem.Ezy
                        System>Modem.Ezy

       Records:      1

       Last Revised: 2/8/94

       ********************************************************** *)

       ModemRecord = record
           Description     : String[20];
           ComPort         : smallword;
           MaxBaud         : longint;
           LockedPort      : boolean;
           ExtendedFossil  : boolean;
           AutoAnswer      : boolean;
           InitResponse    : string[10];
           RingString      : string[10];
           InitTries       : byte;
           InitString1     : string[60];
           InitString2     : string[60];
           BusyString      : string[20];
           AnswerString    : string[20];
           NoCarrierString : string[20];
           ConnectFax      : string[15];
           ModemStart      : smallword;
           ModemEnd        : smallword;
           ModemDelay      : byte;
           AnswerDelay     : byte;
           SendBreak       : boolean;
           OffHook         : boolean;
           ModemBusy       : boolean; (* Toggle DTR or ATH1 *)
           ModemEfficiency : array[1..MaxBaudRec] of smallword;
           ModemBaud       : array[1..MaxBaudRec] of longint;
           ModemConnect    : array[1..MaxBaudRec] of String[20];
           FreeSpace       : array[1..167] of char;
        end;


    (* **********************************************************

       Filename:    LIMITS.EZY

       Description: User Security Limits Information

       ********************************************************** *)

        limitsrecord = record
           comment      : Array[0..20] of Char; (* Security Comment (ZStr) *)
           security     : smallword; (* Security level *)
           time         : smallword; (* Time limit per day *)
           limit        : array[1..maxbaudrec] of smallword;
           ratio        : byte; (* File Ratio *)
           credit       : smallword; (* File Ratio Credit *)
           ratiok       : byte; (* Kilobyte Ratio *)
           creditk      : smallword; (* Kilobyte Ratio Credit *)
           regodays     : smallword; (* Registration in Days *)
           creditmess   : smallword; (* PCR Credit *)
           mess         : smallword; (* PCR (%) *)
           timepercall  : smallword; (* Time limit per call   0=Disabled *)
           callsperday  : byte; (* Maximum Calls Per Day 0=Disabled *)
           maxbankwk,           (* Maximum Withdraw Kilobytes Bank *)
           maxbankwt,           (* Maximum Withdraw Time Bank *)
           maxbankdk,           (* Maximum Deposit Kilobytes Bank *)
           maxbankdt,           (* Maximum Deposit Time Bank *)
           maxkbank,            (* Maximum Allowable Kilobytes in Bank *)
           maxtbank     : smallword; (* Maximum Allowable Time in Bank *)
           freespace    : array[1..32] of byte;
        end;

    (* **********************************************************

        Filename     : FILES.EZY

        Description  : Stores file area information

        Last Revised : 25/2/92(pwd)

        Records      : 1..65000

        Note         : FILEPATH.EZY must have the same amount
                       of records.

       ********************************************************** *)

        filesezyrecord = record
           name         : string[30];
           attribute,
              (* bit 0  : keep files offline
                     1  : offline allowed
                     2  : sortby date
                     3  : sortby alpha
                     4  : show in online master list
                     5  : show in new files check
                     6  : No Descriptions asked after Upload
                     7  : show in ezymast master list *)
           attribute2,
              (* bit 0-7 [Reserved] *)
           convert      : byte;
              (* 0      = none
                 1      = zip
                 2      = lzh
                 3      = arj
                 4      = pak
                 5      = arc
                 6      = zoo
                 7      = sqz
                 8      = rar
                 9-255  = [ Reserved ] *)
           filegroup    : byte;
           altgroups    : array[1..3] of byte;
           minimumage   : byte;
           upfilearea,
           areapath     : smallword;  (* relates to FILEPATH.EZY *)
           listsecurity,
           upsecurity,
           syssecurity  : securitytype;
           numdaystodel        : smallword;
           numarrivaldaystodel : smallword;
           numdayslastdownload : smallword;
           FileIdxPos   : smallword; (* Position in Files.Idx 0=No Record 1=Record 1*)
           freespace    : array[1..47] of byte;
        end;

    (* **********************************************************

       Filename:     <systempath>FILES.IDX

       Description:  Used by Ezycom as an index into the
                     file areas.  Only used areas are stored
                     in here.  CRCs are calculated the same
                     as that for the fast message record.  Later
                     on, it is planned to provide serveral linked
                     lists, so you can traverse the index in
                     sorted orders.

                     The first Record is intentionally left
                     blank.  You should start reading from
                     the second record.

       Size:         1 -> ??? records

       ********************************************************** *)

        fileidxrecord = record
           recnum         : smallword;    (* 1 = Record 0 *)
           namecrc        : longint;
           listsecurity   : securitytype;
           minimumage     : byte;
           filegroup      : byte;
           altgroups      : array[1..3] of byte;
           attribute,
           attribute2     : byte;
           PadTo32Bytes   : array[1..9] of char;
        end;

    (* **********************************************************

       Filename:     <systempath>FILEGRP.BBS

       Description:  Used by Ezycom as to store group information.

                     The first Record is intentionally left
                     blank.  You should start reading from
                     the second record.

       Size:         1 -> ??? records

       ********************************************************** *)

        filegrouprecord = record
           name           : array[0..30] of char; (* C String *)
           accesssecurity : securitytype;
           minimumage     : byte;
           freespace      : array[1..6] of char;
        end;

    (* **********************************************************

        Filename     : FILEPATH.EZY

        Description  : Stores information about where to get
                       the files

        Records      : 1..65000

        Note         : FILES.EZY must have the same amount
                       of records.

        Last Revised : 26/12/94(pwd)

       ********************************************************** *)

        filepathrecord = record
           filepath    : string[60];
           filesbbs    : string[60];
           ksperfp     : byte;
           security    : securitytype;
           uploadarea  : smallword;
           password    : string[8];
           minimumage  : byte;
           attribute   : byte;
              (* Bit 0 : CD Rom Path
                     1 : File Displayed as Not Enough Security
                     2 : Free Downloads
                     3 : Auto Adopt Files?
                     4-7 [Reserved] *)
           CDRomStack  : Byte;
           freespace   : array[1..109] of byte;
        end;

    (* **********************************************************

        Filename     : FILESEC.EZY

        Description  : Stores individual (wildcard) file security

        Records      : 1->infinite  (sorted)

        Last Revised : 25/2/92(pwd)

       ********************************************************** *)

        filesecrecord = record (* FILESEC.EZY *)
           filename    : string[12];
           security    : securitytype;
           password    : string[8];
           minimumage  : byte;
           attribute   : byte;
             (*  Bit 0 : [Reserved]
                     1 : File Displayed as Not Enough Security
                     2 : Free Download
                     3-7 [Reserved] *)
        end;

    (* **********************************************************

        Filename     : filebase path\FLCOUNT.BBS

        Description  : Stores number of files in each file area
                       (does not include comment lines)

        Records      : 1..65000
                       Always the same as FILES.EZY + FILEPATH.EZY

        Last Revised : 25/2/92(pwd)

        Sharing      : Always use DENYNONE + READWRITE

       ********************************************************** *)

        (*  Each record contains a word (2 bytes) which stores the
            amount of files in each file area.

            When reading the information, just seek to the
            appropriate record and read the 2 bytes

            When updating the count, lock the 2 bytes, then read
            it, then increase/decrease the amount, then write it
            back, and then release the lock. *)


    (* **********************************************************

        Filename     : FLHXXXXX.BBS

        Description  : Stores file list information

        Last Revised : 25/2/92(pwd)

        Sharing      : Always use DENYNONE + READWRITE

       ********************************************************** *)

        filelinerecord = record (* FLHXXXXX.BBS *)
           fltstart     : longint;  (* start of info in FLTXXXXX.BBS *)
           fltlength    : smallword;     (* length including null termiantor *)
           attribute    : byte;
               (* Bit 0 : checked
                      1 : nokill
                      2 : offline
                      3 : [Reserved]
                      4 : private
                      5 : deleted
                      6-7 [Reserved] *)

              (* if the length of filename is 0, then it is a comment *)
           filename     : string[12];
           filepath     : smallword;    (* pointer to filepath.ezy for path of file
                                      0= do not know where the file is *)
           fsize        : longint; (* size of the actual file *)
           fdate,                  (* date of the actual file *)
           arrivaldate,            (* date the file arrived on the system *)
           downloads    : smallword;
           downloaddate : smallword;    (* last time the file was downloaded
                                      if (downloads = 0) then
                                         this field is invalid *)
           attribute2   : byte;
               (* bit 0-7 [Reserved] *)
           uploader     : userstring;
           freespace    : array[1..57] of byte;
        end;

    (* **********************************************************

        Filename     : FLTXXXXX.BBS

        Description  : Stores file list description information

        Last Revised : 25/2/92(pwd)

       ********************************************************** *)

const
          fltmaxsize    = 2048;  (* maximum size of a description *)


     (* The FLTXXXXX.BBS has contains a null terminated string.

        It is either a comment, or a file description.  The description
        or comment can be upto fltmaxsize in length.

        A comment maybe only 1 line long, and may NOT contain line feeds
        or carriage returns.

        A description can be any number of lines long, and may contain
        carriage returns, but may NOT contain line feeds (waste space)

        When writing to the description file, the file MUST be opened
        in DENYWRITE + READWRITE.  When reading from it, it MUST
        be opened in DENYNONE + READONLY *)


type

    (* **********************************************************

        Filename     : EZYDOWN.<node>

        Description  : Stores Batch Download Information

        Last Revised : 20/3/93(pwd)

       ********************************************************** *)

        predownloadrecord = record
           filename      : string[12];
           locationfile  : string[64];  (* path to file *)
           fsize         : longint; (* KiloBytes *)
           freedown      : boolean;
           timetodown    : longint; (* Seconds *)
           cdromfile     : boolean;
           CDStack       : Byte;
           deleted       : boolean;
           PadTo128Bytes : array[1..38] of byte;
        end;

    (* **********************************************************

        Filename     : EZYUP.<node>

        Description  : Stores Pre Upload Descriptions

        Last Revised : 25/2/92(pwd)

       ********************************************************** *)

        preuploadrecord = record  (* EZYUP.<node> *)
           filename      : string[12];
           description   : array[0..fltmaxsize] of char;
        end;

    (* **********************************************************

        Filename     : <configrec.userbasepath>MAINTDN.BBS

        Description  : Stores Information for download counts
                       and file points credit.

                       MAINTDN.BBS is created by Ezycom for
                       processing by EzyFile

        Last Revised : 29/11/95(pwd)

       ********************************************************** *)

        maintenancerecord = record
           filename        : string[12];
           filesize        : longint;
           filepoint       : smallword;
           downloadercrc32 : longint;
        end;

    (* **********************************************************

        Filename     : <configrec.userbasepath>MAINTUSR.BBS

        Description  : Stores Information for file points credit.

                       MAINTUSR.BBS is created by EzyFile for
                       processing by UserComp

        Last Revised : 29/11/95(pwd)

       ********************************************************** *)


        FilePointsMaintenanceRecord = record
           FilePoints    : smallword;
           Uploader      : userstring;
        end;

    (* **********************************************************

        Filename     : FFPTR.BBS

        Description  : Index Pointer File for the Fast Find Index

        Last Revised : 25/2/92(pwd)

        Format       : Files with First Character #0 through to #64
                       start at Position 0 in FFIDX.BBS

                       [730] is all new files after the last sort
                       [729] is all files with a first letter after
                             'Z' (besides new files)
                       [1..728] is files that start with A#0 through
                                to Z#255
                       eg: AA is 2, AB is 3, ZZ is 727, ZY is 726

                       A value of 0x0FFFFFFFF (-1) in any position
                       indicates no files are present for that
                       position.

       ********************************************************** *)

        fastpointerrecord = array[1..730] of longint;

    (* **********************************************************

        Filename     : FFIDX.BBS

        Description  : Index File of all files available for download

        Last Revised : 1/2/94 (pwd)

        Records      : 0..Infinite

        To add a file to the fast find index, just add an extra
        record to the end of this file.  File sharing should be
        DENYNONE + READWRITE

       ********************************************************** *)

        fastindexrecord = record
           name       : filestr;
           filepath   : smallword;    (* FILEPATH.EZY 1 -> *)
           attribute  : byte;
              (* Bit 0 : Deleted
                     1-7 [Reserved] *)
           filesize   : longint;
        end;

    (* **********************************************************

       Filename      : <multipath>ONLINE.BBS

       Description   : Used by Ezycom to store online information

       Minimum Size  : 1 Record
       Maximum Size  : 250 Records

       Last Revised  : 1/2/94 (pwd)

       Notes         : While in a door, it is possible to give
                       Ezycom more information about the door.
                       This can be done by creating a file called
                       <systempath>USERDOES.<node>.

                       When Ezycom is waiting for a call from a
                       particular node, information can be displayed
                       in the who's online list.  By making a simple
                       1 line text file in <systempath>NODEINFO.<node>

       ********************************************************** *)

        onlinerecord   = record
           name            : userstring;
           alias           : userstring;
           status          : byte;
           (* 0 - Active
              1 - [Reserved]
              2 - Downloading
              3 - Uploading
              4 - [Reserved]
              5 - Message Browsing
              6 - Door
              7 - Chat with Sysop
              8 - Chat with Other Users Channel 000
              ...................................
            207 - Chat with Other Users Channel 199 (200 channels)
            208 - 252 [Reserved]
            253 - Node Not Active in Any Way
            254 - User Logging On
            255 - Waiting for Caller *)
           attribute : byte;
           (* Bit 0 - Quiet Do Not Disturb
                  1-7 [Reserved] *)
           baud            : longint;
           location        : string[25];
           lasttimeupdated : longint;
              (* This field should always be updated when the record is
                 modified in ANY way by the user online. *)
           freespace       : array[1..20] of char;
        end;

    (* **********************************************************

       Filename:     <multipath>MESSNODE.<node>

       Description:  Used by Ezycom for conferencing

       Minimum Size: 0 Records (Maybe not present!)
       Maximum Size: Unlimited

       Sharing:
            Writing: Denynone + WriteOnly
            Reading: Denyall + ReadWrite (Truncate after read)

       ********************************************************** *)

        multimessagerecord = record
            from           : userstring;
            fromnode       : smallword;
            message        : string[80];
            privatemsg     : boolean;
        end;

    (* **********************************************************

       Filename:     <userbase>BESTSTAT.BBS

       Description:  Used by Ezycom to store best user stats

       Minimum Size: 0 Records (Maybe not present!)
       Maximum Size: 200 Records

       ********************************************************** *)

        bestuserrecord     = record
           bestname       : array[1..7] of userstring;
           (* BestName[1] is for BestMessages
              BestName[2] is for BestCalls
              .....
              BestName[7] is for BestDownK *)
           bestmessages,
           bestcalls,
           bestups,
           bestdns,
           bestfps        : smallword;
           bestupk,
           bestdownk      : longint;
        end;

    (* **********************************************************

       Filename:     <msgpath>\AREA<(<area>-1)/100+1>\MH<area>.BBS
                     eg: \ezy\msgbase\area1\mh00001.bbs     for area 1
                     eg: \ezy\msgbase\area10\mh01001.bbs    for area 1001
                     eg: \ezy\msgbase\area100\mh10001.bbs   for area 10001

       Description:  Used by Ezycom to store message header

       ********************************************************** *)

        msghdrrecord   = record
           prevreply,
           nextreply      : smallword;
              (* 0 = No Reply Chain *)
           startposition,
              (* Physical Start Position in MSGT???.BBS *)
           messagelength  : longint;
             (* Message Length including Null Terminator *)
           destnet,
           orignet        : netrecord;
           cost           : smallword;
           msgattr,
              (*  Bit 0 : Deleted
                      1 : Netmail pending export
                      2 : [Reserved]
                      3 : Private
                      4 : Received
                      5 : Echomail pending export
                      6 : Locally generated msg
                      7 : Do not kill message *)
           netattr,
              (*  Bit 0 : Kill/sent
                      1 : Sent
                      2 : File Attach (netmail or local file attach)
                      3 : Crash
                      4 : File Req
                      5 : Request Receipt
                      6 : Audit Request
                      7 : Is a Return Receipt *)
           extattr   : byte;
              (*  Bit 0-7 [Reserved] *)
           posttimedate : longint;
              (* DOS Format Packed DateTime *)
           recvtimedate : longint;
              (* DOS Format Packed DateTime *)
           whoto,
           whofrom        : userstring;
           subject        : string[72];
        end;

    (* **********************************************************

       Filename:     <msgpath>\AREA<<area-1>/100+1>\MT<area>.BBS
                     eg: \ezy\msgbase\area1\mt00001.bbs     for area 1
                     eg: \ezy\msgbase\area10\mt01001.bbs    for area 1001
                     eg: \ezy\msgbase\area100\mt10001.bbs   for area 10001

       Description:  Used by Ezycom to store message text

       ********************************************************** *)

        (* Message Text

                Each text part of the message starts at 'startposition',
           and continues on until a NULL terminator is found, or end
           of file is reached (shouldn't happen, but just in case).
           Each message is contained of plain text, with 0x08D
           terminators for wrapped lines or 0x0D terminators for hard
           carriage returns.  No line of text should exceed 79 characters
           excluding the terminator *)

    (* **********************************************************

       Filename:     <msgpath>MSGFAST.BBS

       Description:  Used by Ezycom for mail checks

       ********************************************************** *)

        msgfastrecord  = record
           whoto     : longint;
              (* standard 32 Bit CRC on whoto in MH???.BBS
                 Username is CRCd in UPPERCASE, and does not
                 include null terminator or length byte *)
           msgboard  : smallword;
           msgnumber : smallword;
        end;

    (* **********************************************************

       Filename:     <msgpath>MSGEXPRT.BBS

       Description:  Used by Ezycom to tell EzyNet/EzyMail whether
                     an area needs scanning or not

       ********************************************************** *)

        needscanrecord = array[1..maxmess] of boolean;

    (* **********************************************************

       Filename:     <msgpath>MSGREPLY.BBS

       Description:  Used by MsgComp/EzyLink to tell it which
                     conference(s) need reply chain
                     linking

       ********************************************************** *)

        needreplytype   = array[1..maxmess] of boolean;

    (* **********************************************************

       Filename:     <msgpath>MSGCOUNT.BBS

       Description:  Used by Ezycom and Utilities for
                     message area counting.
                     Reading the number of records of
                     MHxxx.BBS gives the same effect as
                     reading the conferences count.

       ********************************************************** *)

        msgareacounttype = array[1..maxmess] of smallword;


    (* **********************************************************

       Filename:     <msgpath>MSGDLTD.BBS

       Description:  May or may not exist
                     Lists all the deleted messages on the
                     system.  MSGCOMP deletes the file since
                     it packs all the deleted messages.

       ********************************************************** *)

        msgdeletedrecord  = record
           msgboard  : smallword;
           msgnumber : smallword;
        end;

    (* **********************************************************

       Filename:     <systempath>MESSAGES.EZY

       Description:  Used by Ezycom to store message areas

       Size:         1536 records

       ********************************************************** *)

        messagerecord  = record
           name           : string[30];
           areatag        : areatagstr;
           qwkname        : string[12];
           typ            : msgtype;
           msgkinds       : msgkindstype;
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
           kilobytekill   : smallword;
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

       Filename:     <systempath>MESSAGES.IDX

       Description:  Used by Ezycom as an index into the
                     message areas.  Only used areas are stored
                     in here.  CRCs are calculated the same
                     as that for the fast message record.  Later
                     on, it is planned to provide serveral linked
                     lists, so you can traverse the index in
                     sorted orders.

                     The first Record is intentionally left
                     blank.  You should start reading from
                     the second record.

       Size:         1 -> ??? records

       ********************************************************** *)

        messageidxrecord = record
           recnum         : smallword;    (* 1 = Record 0 *)
           namecrc,
           areatagcrc,
           qwknamecrc     : longint;
           typ            : msgtype;
           readsecurity,
           writesecurity  : securitytype;
           minimumage     : byte;
           areagroup      : char;
           messgroup      : byte;
           altgroups      : array[1..3] of byte;
           attribute,
           attribute2,
           attribute3     : byte;
           PadTo64Bytes   : array[1..20] of char;
        end;

    (* **********************************************************

       Filename:     <systempath>MSGGRP.BBS

       Description:  Used by Ezycom as to store group information.

                     The first Record is intentionally left
                     blank.  You should start reading from
                     the second record.

       Size:         1 -> ??? records

       ********************************************************** *)

        messagegrouprecord = record
           name           : array[0..30] of char; (* C String *)
           accesssecurity : securitytype;
           minimumage     : byte;
           freespace      : array[1..6] of char;
        end;


    (* **********************************************************

       Filename:     <systempath>ECHOMGR.EZY

       Description:  Used by Ezycom to store node information

       Last Updated: 1/2/94

       Size:         256 records

       ********************************************************** *)

        echomgrrecord = record
           destnet     : netrecord;
           domain      : domainstr;
           redirectto  : smallword;
           groups      : grouptype; (* compressed groups A thru Z *)
           compress    : byte;
           (* 0 : Compress to ZIP
              1 : Compress to LZH
              2 : Compress to ARJ
              3 : Compress to ARC
              4 : Compress to PAK
              5 : Compress to ZOO
              6 : Compress to SQZ
              7 : Compress to RAR *)
           attribute   : byte;
           (* Bit 0 : Node Active
                  1 : Crash Mail
                  2 : Hold Mail
                  3 : Can Create New Echos
                  4 : Add to Export on New Echo
                  5 : Can Delete/Rename Areas
                  6 : Direct Mail (Off=Routed Mail)
                  7 : Allow 2D Security *)
           passwordto,
           passwordfr  : string[20];
           dayshold,
           sendpkttype : byte;
           (* 0 : Type 2
              1 : Type 2+
            2-255 [Reserved] *)
           maxpktsize,
           maxarcksize : smallword;
           arealist    : array[0..64] of char;
           pktpassword : array[0..8] of char;
           lastext     : array[0..3] of char;
           freespace   : array[1..29] of char;
        end;


    (* **********************************************************

       Filename:     EVENTS.EZY (multinode file)

       Description:  Used by Ezycom to store event information

       Minimum Size: 1 record
       Maximum Size: 65000 records

       ********************************************************** *)


        eventrecord = record
           attribute   : byte;
              (* Bit 0 = Enabled *)
           starttime   : smallword;
              (* Hi  Bit = Hour
                 Low Bit = Min *)
           errorlevel  : byte;
           days        : byte;
              (* Bit 0 : Sunday
                     1 : Monday
                         ...
                     6 : Saturday
                     7 : [ Reserved ] *)
           lasttimerun : smallword;
        end;

    (* **********************************************************

       Filename:    <systempath>TODAY.BBS
                    <systempath>YESTER.BBS

       Last Update: 1/2/94

       Description: Used by Ezycom to today's/yesterday's callers

       ********************************************************** *)

       ontodayrecord = record
          line        : byte;
          name        : userstring;
          alias       : userstring;
          location    : string[25];
          baudrate    : longint;
          logontime   : smallword;
          logofftime  : smallword;
          didwhat     : byte;
          (* Bit 0 : (N) NewUser
                 1 : (U) Upload
                 2 : (D) Download
                 3 : (R) Read Mail
                 4 : (S) Sent Mail
                 5 : (O) Outside
                 6 : (C) Chat to Sysop and/or User
                 7 : (P) Paged *)
          freespace   : array[1..20] of char;
       end;

    (* **********************************************************

       Filename:    <systempath>TIME<node>.BBS

       Description: Used by Ezycom to store usage information

       ********************************************************** *)

       useagerecord  = record
          startdate      : smallword;
          busyperhour    : array[0..23] of longint; (* Minutes Used *)
          busyperday     : array[0..6]  of longint; (* Minutes Used *)
       end;

    (* **********************************************************

       Filename:    <systempath>MSGINFO.<node>

       Description: Used by Ezycom and Tide to interface to
                    each other

       ********************************************************** *)

       fserecord      = record       (* MSGINFO.<node> *)
          whofrom      : userstring; (* User Who wrote message *)
          orignet      : netrecord;  (* From Net Address *)
          whoto        : userstring; (* User Who message is to *)
          destnet      : netrecord;  (* To Net Address *)
          subject      : string[72]; (* Subject of message *)
          returnstatus : byte;       (* Return Status *)
          (*   0 : FSE Record Not Used
               1 : Message Saved
               2 : Message Aborted
               3 : User  Inactivity
               4 : User  Hungup
               5 : Sysop Hungup
           6-255 : Reserved *)
          attribute    : byte;
          (*   Bit 0 : Can Change Subject
                   1 : Can Change Whoto
                   2 : Can Change Private
                   3 : Private Message
                   4 : Is Message Forwarded (False = Quoted)
                       (Providing MSGTMP.<node> exists)
                   5 : Netmail Message
                   6 : Avatar Capable (ANSI if not set)
                   7 : EchoMail Message *)
          baudrate,               (* Effective Baudrate *)
          lockedbaud   : longint; (* Locked Baudrate *)
          comport      : smallword;
          screenlength : byte;
          timeleft     : smallword;
       end;



    (* **********************************************************

       Filename:    <msgbasepath>MSGRSCAN.BBS

       Description: Used by EzyNet and EzyMail for Rescanning a
                    Message Area for a particular node

       ********************************************************** *)

       rescanrecord = record
          nodetorescan : smallword;
          msgboard     : smallword;
       end;

    (* **********************************************************

       Filename:    <msgbasepath>MSGSTATS.BBS

       Description: Written by EzyMail for echomail statistics

       ********************************************************** *)

       msgstatsrecord = record
          tossedboard  : array[1..maxmessall]  of smallword;
             (* Number of Messages Tossed to Msg Board *)
          scannedboard : array[1..maxmessall]  of smallword;
             (* Number of Messages Tossed to Msg Board *)
          tossednode   : array[1..maxnodes] of longint;
             (* Number of Messages Tossed to EchoArea Node *)
       end;

    (* **********************************************************

       Filename:    <systempath>EXITINFO.<node>

       Description: Used by Ezycom in Type 15 exits to return
                    Used by Ezycom in Type 7 exits for door
                       information

       Last Revised : 16/1/94(pwd)

       ********************************************************** *)

       exitinforecord = record
          oldbaud,
          oldlockedbaud  : smallword;
          comport        : byte; (* Comport 1 = Com1, etc *)
          efficiency     : smallword; (* Baud Rate efficiency *)
          userrecord     : smallword; (* User Record Number (0=User1) *)
          userinfo       : usersrecord;
          userextra      : usersextrarecord;
          sysopname,             (* Sysop's Name *)
          sysopalias     : userstring;
          system         : string[40];
          downloadlimit  : smallword; (* Maximum Download Limit *)
          timelimit      : smallword; (* Daily Time Limit *)
          timetakenevent : smallword;
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
          credit         : smallword; (* File Ratio Credit *)
          ratiok         : byte; (* Kilobyte Ratio *)
          creditk        : smallword; (* Kilobyte Ratio Credit *)
          regodays       : smallword; (* Registration Days *)
          creditmess     : smallword; (* Post Call Ratio Credit *)
          mess           : smallword; (* Post Call Ratio *)
          logintimedate  : datetime; (* Login Datetime *)
          stack          : array[1..20] of str8; (* Menu Stack *)
          stackpos       : byte; (* Menu Stack Position (0 = No Stack) *)
          curmenu        : str8; (* Current Menu *)
          oldpassword    : string[15];
          limitrecnum    : smallword; (* Limits Record Being Used *)
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
          inactivitytime : smallword;    (* Seconds *)
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

       sysinforecord = record
          callcount      : longint;
          lastcaller     : userstring;
          filessizek     : longint; (* Updated by EzyIDX -BUILD *)
          newusers,
          newfiles,
          newmessages    : smallword;    (* Does NOT include Inbound Echomail *)
          lastalias      : userstring;
          laststarttime  : smallword;    (* The start of the last session by a user *)
          extraspace     : array[1..80] of byte;
       end;

    (* **********************************************************

       Filename     : <nodelistpath>EZYINDEX.<nodelistnum>

       Description  : Stores Nodelist Information

       Min Size     : File Not Exist

       Max Size     : 65000 Records

       Last Revised : 3/1/94(pwd)

       Sharing      : Reading       - DenyNone + ReadOnly
                      Insert/Update - Never (EzyNode does it)

       ********************************************************** *)

       nodelistrecord = record
          nodelistfile  : byte;
          position      : longint;
          zone,
          net           : smallword;
       end;

    (* **********************************************************

       Filename     : <nodelistpath>EZYINDEX.00

       Description  : AkaIndex is a pointer to which EZYINDEX.<nodelist num>
                         is used for that Aka.
                      NodelistFileRecord holds information to a particular
                         nodelistfile.  (nodelistfile byte in nodelistrecord).

       Min Size     : AkaIndex + 1 NodelistFileRecord

       Max Size     : AkaIndex + 255 NodelistFileRecords

       Last Revised : 3/1/94(pwd)

       Sharing      : Reading       - DenyNone + ReadOnly
                      Insert/Update - Never (EzyNode does it)

       ********************************************************** *)


       AkaIndex = array[1..maxaka] of byte;

       nodelistfilerecord = record
          nodelistpath  : string[79];
          domain        : domainstr;
       end;

    (* **********************************************************

       Filename     : <nodelistpath>EZYINDEX.COS

       Description  : Lists all the phone number costing factors

       Min Size     : 1 Record (Default Cost)

       Max Size     : Unlimited

       Last Revised : 3/1/94(pwd)

       Sharing      : Reading       - DenyNone + ReadOnly
                      Insert/Update - Never (EzyNode does it)

       ********************************************************** *)

       costrecord = record
         phonenum : string[25];
         cost     : smallword;
       end;

       (* **********************************************************

       Filename     : <systempath>RUMOURS.BBS

       Description  : Stores Rumour Information

       Min Size     : File Not Exist

       Max Size     : 65000 Records

       Last Revised : 27/3/93(pwd)

       Sharing      : Reading       - DenyNone + ReadOnly
                      Insert/Update - DenyWrite + ReadWrite

       ********************************************************** *)

       rumourrecord = record
          userinput  : string[70];
          compiled   : string[100];
          username   : userstring;
          lastupdate : smallword;
          freespace  : array[1..46] of byte;
       end;

       (* **********************************************************

       Filename     : <systempath>LANGUAGE.EZY

       Description  : Language Information Setup

       Min Size     : 1 Record

       Max Size     : 250 Records

       Last Revised : 7/1/94(pwd)

       Sharing      : Reading       - DenyNone + ReadOnly
                      Insert/Update - DenyWrite + ReadWrite

       ********************************************************** *)

       languagerecord = record
          LangName    : array[0..8] of char;
          Description : array[0..60] of char;
          RipPath,
          AvtPath,
          AnsiPath,
          AscPath,
          AslPath,
          G1Path,
          G2Path,
          G3Path,
          MnuPath,
          Mnu2Path,
          QAPath      : array[0..60] of char;
          Security    : securitytype;
          Attribute   : smallword;
           (*  Bit  0 : Default Language
                 1-15 : [Reserved] *)
          FreeSpace   : array[1..271] of char;
       end;

       (* **********************************************************

       Filename     : <systempath>DNBATCH.EZY

       Description  : Stores Download Batch of Terminated Sessions

       Min Size     : 1 Record

       Max Size     : Infinite Records

       Last Revised : 10/2/95(pwd)

       Sharing      : Reading       - DenyNone + ReadWrite
                      Delete/Insert - DenyNone + ReadWrite
                                      Lock Record 0 then proceed

       Record 0     : ForwardLink is a pointer to the first free
                      record
                      BackwardLink is a pointer to the start of the
                      list

       ********************************************************** *)

       DownloadBatchHistoryRecord = record
          Username      : UserString;
          DateAdded     : smallword;
          BatchFile     : PreDownloadRecord;
          PadTo192Bytes : array[1..18] of byte;
          ForwardLink   : longint;
          BackwardLink  : longint;
       end;


const
    fnoinherit = 128;  {      No Interitence Flag }
    fdenyall   = 16;   {      These are MUTUALLY EXCLUSIVE!!!!   }
    fdenywrite = 32;   {      Only ONE of THESE SHOULD BE USED   }
    fdenynone  = 64;   {                                         }
    fdenyread  = 48;   {                                         }
    freadonly  = 0;               {     THESE ALSO!!!  }
    fwriteonly = 1;               {                    }
    freadwrite = 2;               {                    }

