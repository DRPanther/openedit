
(* EZYINC V1.10 - An Ezycom General Purpose TP Unit

   Copyright (C) Peter Davies 1995.  All Rights Reserved.

   This source may be freely used as long as due credit is given.
   That means, in your documentation, you MUST acknowledge that
      "EZYINC Copyright (C) Peter Davies 1995" was used.

   EZYINC is a general purpose unit for Ezycom Utilities
   Simply add EZYINC to your uses statement

   Features: General Purpose Procedures
	     Automatic Reading of CONFIG.EZY into configrec
	     Automatic Reading of CONSTANT.EZY into constant
	     -N<node> and/or TASK aware (node number stored in "node")
	     Inline Assembly on highly used routines *)

{$I EDEFINE.INC}

unit ezyinc;

{$F+,R-,S-,V+,P+,O-,A+,B-,Q-,I+,T-}

Interface

Uses
{$IFDEF WinCompat}
   wincrt, windos, strings;

type
   datetime = tDateTime;  (* Remap for WinDos *)
   pathstr  = string[fspathname];
   dirstr   = string[fsdirectory];
   namestr  = string[fsfilename];
   extstr   = string[fsextension];

const
   chr254 = '*';
   Hex : Array[$0..$F] Of Char = '0123456789abcdef';

{$ELSE}
   Crt, dos
{$IFDEF OS2}
   ,Use32
{$ENDIF}
   ;

const
   Hex : Array[$0..$F] Of Char = '0123456789abcdef';
   chr254 = chr(254);

{$ENDIF}

{$I struct}
{$I compiled}

const
   archivetype : array[1..maxarchives] of string[3] = ('ZIP','LZH','ARJ','PAK','ARC','ZOO','SQZ','RAR');

var
   filemaint : file;
   logpath   : pathstr;

procedure setbit(position, value : byte; var changebyte : byte);

procedure setbitbyte(position : byte;value : boolean;var changebyte : byte);
   (* Set a Bit at Position <0-7> to On=1 or Off=0 *)

procedure NotBitByte(Position : byte;var ChangeByte : Byte);


procedure setbitword(position : byte;value : boolean; var changeword : smallword);
   (* Set a Bit at Position <0-15> to Value *)

function biton(position : byte;testword : smallword) : boolean;
   (* Test if Bit Position <0-15> is on in TestWord
      Note: Also works on Bytes *)

function itospadspace(x : longint;padout : byte) : str12;
   (* Returns a String from a Number, padded with spaces *)

function itospad(x : longint;padout : byte) : str12;
   (* Returns a String from a Number, padded with leading 0s padout size *)

function itos(x : longint) : str12;
   (* Returns a String from a Number *)

function dig2(s : smallword) : str2;
   (* Return a 2 Digit String ranging 00 to 99 *)

function low2up(line : maxstr) : maxstr;
   (* Convert Lowercase to Uppercase *)

function find(path : maxstr) : boolean;
   (* Returns True if PATH exists *)

{$IFNDEF OS2}
{$IFDEF wincompat}
procedure FindClose(SRec : TSearchRec);
   (* closes the search file handle *)
{$ELSE}
procedure FindClose(SRec : SearchRec);
{$ENDIF}
{$ENDIF}

function findsize(path : maxstr;sizewanted : longint) : boolean;
   (* Returns True if PATH Exists & FileSize Matches *)

function findw(s : maxstr) : maxstr;
   (* Returns the Path and filename of a Configuration File(s) *)

function parfind(line : maxstr) : boolean;
   (* Returns true if it finds LINE in the parameters *)

function getparam(line : maxstr) : string;
   (* Returns the remaining portion of LINE in paramaters *)

function getcommand(findstr : string;s : string) : string;
   (* Returns the firstword after findstr in s *)

function st_trail(s : maxstr) : maxstr;
   (* Strips Trailing Spaces *)

function addslash(line : maxstr) : maxstr;
   (* Adds a Slash if not there to LINE *)

function remslash(line : maxstr) : maxstr;
   (* Removes the Slash if there in LINE *)

procedure replace(findstr , replacestr : string;var data : string);
   (* Replaces FindStr with ReplaceStr in Data *)

procedure startlog(title : str3; util : str8);
   (* Creates & opens a new log file *)

procedure log(s : maxstr);
   (* Writes to open log file *)

function checkdate(yy,mm,dd : smallword) : boolean;
   (* Checks for a Valid Date *)

function smallwordtodate(temp : smallword;var yy,mm,dd : smallword) : boolean;
   (* Converts a Word to Date Format *)

function wordtodate(temp : word;var yy,mm,dd : word) : boolean;
   (* Converts a Word to Date Format *)

function datetoword(yy,mm,dd : smallword) : smallword;
   (* Converts a Date to a Word Format *)

function st_lead(s : maxstr) : maxstr;
   (* Removes leading SPACES from a string *)

function retmessxxx(msgboard : word;t : byte) : maxstr;
   (* Returns the FULL path to a message area
      On entry if T = 1 then the Header Path is returned
	       if T = 2 then the Text	Path is returned *)

function retfilexxx(filearea : word;t : byte) : maxstr;
   (* Returns the FULL path to a file area
      On entry if T = 1 then the Header Path is returned
	       if T = 2 then the Text	Path is returned *)

function  addspace(s : string;l : byte) : string;
   (* Adds spaces to the end of the string
      if the string is too long, it cuts off the portion that is
      too long *)

function isarchive(fileextension : extstr) : boolean;
   (* Returns true if the file extension is an arhive *)

function isgif(fileextension : extstr) : boolean;
   (* Returns true if the file extension is a gif *)

function firstword(s : string) : string;
   (* Returns the firstword of string s *)
function  hexbyte(b : byte) : str2;
    (* Returns the Byte in Hexadecimal *)
function  hexword(w : smallword) : str4;
    (* Returns the Word in Hexadecimal *)
function  hexlong(ww : longint) : str8;
    (* Returns the Longint in Hexadecimal *)
function ConvertPipeColours(InpStr : String) : String;

procedure ConvertDateTime(var DT : DateTime;var DT2 : SDateTime;DTSource : boolean);

procedure SmallGetDate(var Year, Month, Day, Dow : SmallWord);

procedure SmallPackTime(var SDT : SDateTime;var PackedTime : Longint);

procedure SmallGetTime(var Hour, Min, Sec, Sec100 : SmallWord);


{$IFDEF wincompat}
function  fexpand(path : maxstr) : maxstr;
function  getenv(path : maxstr) : maxstr;
procedure fsplit(ps : pathstr;var ds : dirstr;var ns : namestr;var es : extstr);
{$ENDIF}

var
   systempath : maxstr; 	  { Path to System Files   }
   node       : byte;		  { Node Number -N<1..255> }
   configrec  : configrecord;	  { Configuration	   }
   constant   : constantrecord;   { Constant		   }

implementation

{$IFDEF OS2}

function biton(position : byte;testword : smallword) : boolean;

begin
   biton := (((TestWord shr Position) and 1) = 1);
end;

{$ELSE}

function biton(position : byte;testword : smallword) : boolean; assembler;

asm
   mov ax, 1;
   mov cl, position;
   shl ax, cl;
   and ax, testword;
   jnz @notbiton
   mov ax, false;
   jmp @finish;
   @notbiton :
      mov ax, true;
   @finish :
end;

{$ENDIF}

procedure setbitword(position : byte;value : boolean;var changeword : smallword);
   (* Set a Bit at Position <0-15> to Value *)

var
   wd : smallword;

begin
   wd := $01;
   wd := smallword(wd shl position);
   if value then
      changeword := changeword or wd else
      begin
	 wd := wd xor $ffff;
	 changeword := changeword and wd;
      end;
end;

procedure setbitbyte(position : byte;value : boolean;var changebyte : byte);
   (* Set a Bit at Position <0-7> to Value *)

var
   wd : byte;

begin
   wd := $01;
   wd := wd shl position;
   if value then
      changebyte := changebyte or wd else
      begin
	 wd := wd xor $ff;
	 changebyte := changebyte and wd;
      end;
end;


procedure setbit(position, value : byte; var changebyte : byte);

var
   bt : byte;

begin
   bt := $01;
   bt := bt shl position;
   if value = 1 then
      changebyte := changebyte or bt else
      begin
	 bt := bt xor $ff;
	 changebyte := changebyte and bt;
      end;
end;

procedure NotBitByte(Position : byte;var ChangeByte : Byte);

begin
   SetBitByte(Position,not biton(Position,ChangeByte),ChangeByte);
end;

function find(path : maxstr) : boolean;

var
{$IFDEF Wincompat}
   srec  : tsearchrec;
   tpath : array[0..sizeof(maxstr)] of char;
{$ELSE}
   srec : searchrec;
{$ENDIF}

begin
{$IFDEF Wincompat}
   StrPCopy(tpath,path);
   findfirst(tpath,faanyfile,srec);
{$ELSE}
   findfirst(path,anyfile,srec);
{$ENDIF}
   find := (doserror = 0);
   findclose(srec);
end;

{$IFNDEF OS2}
{$IFDEF Wincompat}
procedure FindClose(SRec : TSearchRec);

begin

end;
{$ELSE}
procedure FindClose(SRec : SearchRec);

begin

end;
{$ENDIF}
{$ENDIF}

function findsize(path : maxstr;sizewanted : longint) : boolean;

var
{$IFDEF Wincompat}
   srec  : tsearchrec;
   tpath : array[0..sizeof(maxstr)] of char;
{$ELSE}
   srec : searchrec;
{$ENDIF}

begin
{$IFDEF Wincompat}
   StrPCopy(tpath,path);
   findfirst(tpath,faanyfile,srec);
{$ELSE}
   findfirst(path,anyfile,srec);
{$ENDIF}
   findsize := (doserror = 0) and (srec.size = sizewanted);
   findclose(srec);
end;

function itospadspace(x : longint;padout : byte) : str12;

var
   temp : str12;

begin
   str(x:padout,temp);
   itospadspace := temp;
end;

function itospad(x : longint;padout : byte) : str12;

var
   temp : str12;

begin
   str(x:padout,temp);
   for padout := 1 to length(temp) do
      if (temp[padout] = ' ') then
	 temp[padout] := '0';
   itospad := temp;
end;

function dig2(s : smallword) : str2;

begin
   dig2 := itospad(s,2);
end;

function itos(x : longint) : str12;

var
   temp : string[12];

begin
   str(x,temp);
   itos := temp;
end;

function low2up(line : maxstr) : maxstr;

{$IFDEF OS2}
var
   loop : integer;
{$ENDIF}

begin
{$IFDEF OS2}
   for loop := 1 to length(line) do
      line[loop] := upcase(line[loop]);
   low2up := line;
{$ELSE}
INLINE(
  $1E/
  $C5/$76/$06/
  $C4/$7E/$0A/
  $FC/
  $AC/
  $AA/
  $30/$ED/
  $88/$C1/
  $E3/$0E/
  $AC/
  $3C/$61/
  $72/$06/
  $3C/$7A/
  $77/$02/
  $2C/$20/
  $AA/
  $E2/$F2/
  $1F);
{$ENDIF}
end;

function findw(s : maxstr) : maxstr;

begin
   if find(systempath + s + '.' + itos(node)) then
      findw := systempath + s + '.' + itos(node) else
      if find(s + '.EZY') then
	 findw := s + '.EZY' else
	    findw := systempath + s + '.EZY';
end;

function getparam(line : maxstr) : string;

var
   loop     : integer;
   found    : boolean;
   posstart : byte;

begin
   loop := 1;
   found := false;
   while (loop <= paramcount) and (not found) do begin
      posstart := pos(line,low2up(paramstr(loop)));
      if (posstart = 1) then
         found := true else
         inc(loop);
   end;
   if found then
      getparam := copy(paramstr(loop),posstart+length(line),255) else
      getparam := '';
end;

function st_trail(s : maxstr) : maxstr;

{$IFDEF OS2}
var
   loop : integer;
   alpha : boolean;

{$ENDIF}

begin
{$IFDEF OS2}
   alpha := false;
   for loop := length(s) downto 1 do
	 if (s[loop] = ' ') and (not alpha) then
	    s[0] := chr(ord(s[0]) -1) else
	    alpha := true;
   st_trail := s;
{$ELSE}
INLINE(
  $1E/
  $C5/$76/$06/
  $FC/
  $AC/
  $3C/$00/
  $74/$21/
  $30/$ED/
  $88/$C1/
  $B0/$20/
  $C4/$7E/$06/
  $01/$CF/
  $FD/
  $F3/$AE/
  $74/$01/
  $41/
  $88/$C8/
  $C5/$76/$06/
  $46/
  $C4/$7E/$0A/
  $FC/
  $AA/
  $F2/$A4/
  $E9/$04/$00/
  $C4/$7E/$0A/
  $AA/
  $1F);
{$ENDIF}
end;

function st_lead(s : maxstr) : maxstr;

var
   loop : word;
   slength : byte absolute s;

begin
   loop := 1;
   while (loop <= slength) and (s[loop] = ' ') do
      inc(loop);
   dec(loop);
   if (loop > 0) then
      delete(s, 1, loop);
   st_lead := s;
end;

function addslash(line : maxstr) : maxstr;

var
   llen : byte absolute line;

begin
   line := st_trail(line);
   if (llen > 0) and (line[llen] <> '\') then
      begin
	 inc(llen);
	 line[llen] := '\';
      end;
   addslash := line;
end;

function remslash(line : maxstr) : maxstr;

var
   llen : byte absolute line;

begin
   if (length(line) > 0) and (line[length(line)] = '\') then
      dec(llen);
   remslash := line;
end;

function parfind(line : maxstr) : boolean;

var
   loop : integer;
   found : boolean;

begin
   loop := 1;
   found := false;
   while (loop <= paramcount) and (not found) do
      if (pos(line,low2up(paramstr(loop))) = 1) or (pos('?',low2up(paramstr(loop))) = 2) then
	 found := true else
	 inc(loop);
   parfind := found;
end;

function checkdate(yy,mm,dd : smallword) : boolean;

const
   daysinmonth : array[1..12] of word =
      (31,29,31,30,31,30,31,31,30,31,30,31);

begin
   checkdate := false;
   if (mm < 1) or (mm > 12) then
      exit;
   if (dd < 1) or (dd > daysinmonth[mm]) then
      exit;
   if not ((yy mod 4 <> 0) and (dd = 29) and (mm=2)) then
      checkdate := true;
end;


function datetoword(yy,mm,dd : smallword) : smallword;

begin
   datetoword := 65535;
   if (not checkdate(yy,mm,dd)) or (yy < 1980) or (yy > 2107) then
      exit;
   datetoword := (dd - 1) + ((mm - 1) shl 5) + ((yy - 1980) shl 9);
end;

function smallwordtodate(temp : smallword;var yy,mm,dd : smallword) : boolean;

begin
   if (temp = 65535) then
      begin
	 smallwordtodate := false;
	 exit;
      end else
	 smallwordtodate := true;
   dd	:= (temp and 31) + 1;
   mm	:= ((temp shr 5) and 15)  + 1;
   yy	:= ((temp shr 9) and 127) + 1980;
end;

function wordtodate(temp : word;var yy,mm,dd : word) : boolean;

begin
   if (temp = 65535) then
      begin
	 wordtodate := false;
	 exit;
      end else
	 wordtodate := true;
   dd	:= (temp and 31) + 1;
   mm	:= ((temp shr 5) and 15)  + 1;
   yy	:= ((temp shr 9) and 127) + 1980;
end;

function retmessxxx(msgboard : word;t : byte) : maxstr;

var
   AreaDir  : string[5];
   AreaName : String[5];
   HdrChar  : Char;

begin
   AreaDir := itos(((msgboard-1) div 100) + 1);
   AreaName := ItosPad(MsgBoard,5);
   if t = 1 then
      HdrChar := 'H'
   else
      HdrChar := 'T';
   RetMessxxx := configrec.msgpath + 'AREA' + AreaDir + '\M'+ HdrChar + AreaName + '.BBS'
end;

function retfilexxx(filearea : word;t : byte) : maxstr;

var
   temp  : string[5];
   temp2 : string[5];
   hdrchar : char;

begin
   if (t = 1) then
      hdrchar := 'H' else
      hdrchar := 'T';
   temp := itospad(filearea,5);
   str(((filearea-1) div 100) + 1,temp2);
   retfilexxx := configrec.filepath + 'AREA' + temp2 + '\FL' + hdrchar + temp + '.BBS';
end;

procedure replace(findstr , replacestr : string;var data : string);

var
   more : boolean;
   resultstr : maxstr;
   posstr : byte;

begin
   if (length(findstr) = 0) then
      exit;
   findstr := low2up(findstr);
   more := true;
   resultstr := '';
   while more do
      begin
	 posstr := pos(findstr,low2up(data));
	 if (posstr > 0) then
	    begin
	       resultstr := resultstr + copy(data,1,posstr-1) + replacestr;
	       data	 := copy(data,posstr+length(findstr),255);
	    end else
	    begin
	       more := false;
	       resultstr := resultstr + data;
	    end;
      end;
   data := resultstr;
end;

procedure log(s : maxstr{; finishlog:boolean});

var
   thh, tmm, tss, t100 : word;

begin
   gettime(thh,tmm,tss,t100);
   s:='> '+dig2(thh)+':'+dig2(tmm)+':'+dig2(tss)+'  '+s+#13+#10;
   blockwrite(filemaint,s[1],length(s));
{  if finishlog then begin
      close(filemaint);
      exit;
   end;}
end;

procedure startlog(title : str3; util : str8);

const
    smon : array[1..12] of string[3] = ('Jan','Feb','Mar','Apr','May','Jun',
				       'Jul','Aug','Sep','Oct','Nov','Dec');
var

   strlog  : string[100];
   year,month,day,t100 : word;
   ioerror : word;
{  ds	   : dirstr;
   ns	   : namestr;
   es	   : extstr;
}
Begin
   logpath := configrec.filemaint;
   replace('*N',itos(node),logpath);
   replace('*T',title,logpath);
{  if title = 'TMP' then begin
      fsplit(logpath,ds,ns,es);
      logpath := ds+'TMP'+itos(node)+es;
   end;
}  if not find(logpath) then begin
      if (doserror = 3) then begin
         writeln(chr254 + ' Invalid Log Path : '+logpath);
         halt(1);
      end;
      filemode := 66;
      assign(filemaint,logpath);
      rewrite(filemaint);
      close(filemaint);
   end;
   assign(filemaint,logpath);
   filemode := fdenywrite + fwriteonly;
   {$I-}
   repeat
      reset(filemaint,1);
      ioerror := ioresult;
      if (ioerror <> 0) and (ioerror <> 5) then
	 runerror(ioerror) else
      if (ioerror = 5) then
	 delay(100);
   until (ioerror = 0);
   {$I+}
   seek(filemaint,filesize(filemaint));
   strlog := #13 + #10;
   blockwrite(filemaint,strlog[1],length(strlog));
   getdate(year,month,day,t100);
   str(year,strlog);
   strlog := '----------  ' + dig2(day) + '-' + smon[month] + '-' + strlog + #13 + #10;
   blockwrite(filemaint,strlog[1],length(strlog));
   log(UTIL+' '+OSTYPE+' Activated');
end;

function  addspace(s : string;l : byte) : string;

var
   loop : byte;

begin
   if (length(s) >= l) then
      begin
	 addspace := copy(s,1,l);
	 exit;
      end;
   for loop := 1 to l - length(s) do
      s := s + ' ';
   addspace := s;
end;

function isarchive(fileextension : extstr) : boolean;

var
   loop : word;

begin
   isarchive := false;
   isarchive := (fileextension = '.ZIP') or
		(fileextension = '.ARJ') or
		(fileextension = '.LZH') or
		(fileextension = '.ARC') or
		(fileextension = '.PAK') or
		(fileextension = '.ZOO') or
		(fileextension = '.RAR') or
                (fileextension = '.ACE') or
		(fileextension = '.SQZ');
end;

function isgif(fileextension : extstr) : boolean;

begin
   isgif := (fileextension = '.GIF') or
	    (fileextension = '.JPG');
end;

function firstword(s : string) : string;

var
   loop  : word;
   found : boolean;

begin
   found := false;
   loop := 1;
   while (loop <= length(s)) and (not found) do
      begin
	 if (s[loop] <> ' ') then
	    inc(loop) else
	    found := true;
      end;
   if not found then
      firstword := s else
      firstword := copy(s,1,loop-1);
end;

function getcommand(findstr : string;s : string) : string;

var
   temp : string;
   spos : byte;

begin
   findstr    := low2up(findstr);
   spos       := pos(findstr,low2up(s));
   if (SPos > 0) then
      getcommand := firstword(copy(s,spos+length(findstr),255))
   else
      getcommand := '';
end;

function hexbyte(b : byte) : str2;
begin
  hexbyte := hex[b shr 4] + hex[b and $F];
end;

function hexword(w : smallword) : str4;
begin
  hexword := hexbyte(hi(w)) + hexbyte(lo(w));
end;

function hexlong(ww : longInt) : str8;
var
  w : array[1..2] of smallword absolute ww;
begin
  hexlong := hexword(w[2]) + hexword(w[1]);
end;


{$IFDEF Wincompat}

function fexpand(path : maxstr) : maxstr;

var
   inpath,
   outpath : array[0..sizeof(maxstr)] of char;

begin
   StrPCopy(inpath,path);
   fileexpand(outpath,inpath);
   fexpand := strpas(outpath);
end;

function getenv(path : maxstr) : maxstr;

var
    Name   : array[0..sizeof(path)] of char;
    tmpstr : pchar;

begin
   StrPCopy(Name,Path);
   tmpstr := getenvvar(name);
   getenv := strpas(addr(tmpstr));
end;

procedure fsplit(ps : pathstr;var ds : dirstr;var ns : namestr;var es : extstr);

var
   p : array[0..fspathname]  of char;
   d : array[0..fsdirectory] of char;
   n : array[0..fsfilename]  of char;
   e : array[0..fsextension] of char;

begin
   strpcopy(p,ps);
   filesplit(p,d,n,e);
   ds := strpas(d);
   ns := strpas(n);
   es := strpas(e);
end;

procedure delay(x : word);

begin
   (* delay code here *)
end;

{$ENDIF}

function ConvertPipeColours(InpStr : String) : String;

var
   TmpStr,
   OutSt   : String;
   Loop    : Word;
   PipePos : Word;
   Colour,
   Error   : Integer;
begin
   OutSt := '';
   loop := 1;
   while (loop <= length(InpStr)) do begin
      tmpstr  := copy(InpStr,loop,length(InpStr)-loop+1);
      pipepos := pos('|',tmpstr);
      if (pipepos = 0) then begin
	 OutSt := OutSt + TmpStr;
	 loop := length(InpStr)+1;
      end else begin
	 if (pipepos > 1) then begin
	    OutSt := OutSt + copy(tmpstr,1,pipepos-1);
	    TmpStr := copy(TmpStr,pipepos,length(tmpstr)-pipepos+1);
	    inc(loop,pipepos-1);
	 end;
	 if (length(tmpstr) > 1) then begin
	    if (tmpstr[2] = '|') then begin
	       OutSt := OutSt + '|';
	       inc(loop,2);
	    end else
	    if (tmpstr[2] >= '0') and (tmpstr[2] <= '9') and
	       (length(tmpstr) >= 2) then begin
	       val(tmpstr[2] + tmpstr[3],colour,error);
	       if (colour >= 0) and (colour <= 15) and (error = 0) then begin
		  OutSt := OutSt + 'b' + HexByte(colour);
	       end;
	       inc(loop,3);
	    end else begin
{	       if (UpCase(TmpStr[2]) >= 'A') and (UpCase(TmpStr[2]) <= 'Z') then begin}
	       if (UpCase(TmpStr[2]) in ['A'..'Z']) then begin
		  case tmpstr[2] of
		     'b' : OutSt := OutSt + 'b01';
		     'g' : OutSt := OutSt + 'b02';
		     'c' : OutSt := OutSt + 'b03';
		     'r' : OutSt := OutSt + 'b04';
		     'm','p' : OutSt := OutSt + 'b05';
		     'y' : OutSt := OutSt + 'b06';
		     'w','l' : OutSt := OutSt + 'b07';
		     'B' : OutSt := OutSt + 'b09';
		     'G' : OutSt := OutSt + 'b0A';
		     'C' : OutSt := OutSt + 'b0B';
		     'R' : OutSt := OutSt + 'b0C';
		     'M','P' : OutSt := OutSt + 'b0D';
		     'Y' : OutSt := OutSt + 'b0E';
		     'W','L' : OutSt := OutSt + 'b0F';
		  end;
		  inc(loop,2);
	       end else begin
		  OutSt := OutSt + '|';
		  inc(loop);
	       end;
	    end;
	 end else begin
	    loop  := length(InpStr) + 1;
	    OutSt := OutSt + '|';
	 end;
      end;
   end;
   ConvertPipeColours := OutSt;
end;

procedure ConvertDateTime(var DT : DateTime;var DT2 : SDateTime;DTSource : boolean);

begin
{$IFDEF OS2}
   if not DTSource then begin
      dt.year := dt2.year;
      dt.month := dt2.month;
      dt.day := dt2.day;
      dt.hour := dt2.hour;
      dt.min := dt2.min;
      dt.sec := dt2.sec;
   end else begin
      dt2.year := dt.year;
      dt2.month := dt.month;
      dt2.day := dt.day;
      dt2.hour := dt.hour;
      dt2.min := dt.min;
      dt2.sec := dt.sec;
   end;
{$ELSE}
   if (DTSource) then
      Dt2 := Dt
   else
      Dt := Dt2;
{$ENDIF}
end;

procedure SmallPackTime(var SDT : SDateTime;var PackedTime : Longint);

var
   DT : DateTime;

begin
   ConvertDateTime(DT,SDT,False);
   packtime(DT,PackedTime);
end;

procedure SmallGetDate(var Year, Month, Day, Dow : SmallWord);

var
   lYY, lMM, lDD, lDOW : Word;

begin
   GetDate(lYY,lMM,lDD,lDOW);
   Year := lYY;
   Month := lMM;
   Day := lDD;
   Dow := lDOW;
end;

procedure SmallGetTime(var Hour, Min, Sec, Sec100 : SmallWord);

var
   lHH, lMM, lSS, lS100 : Word;

begin
   GetTime(lHH,lMM,lSS,lS100);
   Hour := lHH;
   Min := lMM;
   Sec := lSS;
   Sec100 := lS100;
end;

procedure newsetup;

var
   tempfile   : file;
   tempstr    : maxstr;
   error      : integer;

begin
{  clrscr;}
   if (diskfree(0) < longint(256*1024)) and (diskfree(0) >= 0) then begin
      writeln(chr254 + ' Sorry, at least 256K of free disk space is needed to run '+paramstr(0));
      halt(1);
   end;
   checkbreak := false;
   systempath := getenv('EZY');
   if (length(systempath) = 0) then
      getdir(0,systempath);
   systempath := fexpand(addslash(low2up(systempath)));
   node := 1;
   tempstr := getenv('TASK');
   if (length(tempstr) > 0) then
      begin
	 val(tempstr,node,error);
	 if (error > 0) or (node = 0) then
	    node := 1 else
	 if (node > 255) then
	    node := 255;
      end;
{$IFDEF OS2}
   tempstr := getparam('-NODE');
{$ELSE}
   tempstr := getparam('-N');
{$ENDIF}
   if (length(tempstr) > 0) then
      begin
	 val(tempstr,node,error);
	 if (error > 0) or (node = 0) then
	    node := 1 else
	 if (node > 255) then
	    node := 255;
      end;
   tempstr := findw('CONFIG');
   if not find(tempstr) then
      begin
	 if (doserror = 3) then
	    begin
	       writeln(chr254 + ' System Path Invalid.');
	       writeln(chr254 + ' Please Change EZY Environment Variable.');
	       halt(1);
	    end;
	 writeln(chr254 + ' CONFIG.EZY not found');
	 writeln(chr254 + ' Use EZYCFG.EXE to Create it');
	 halt(1);
      end;
   if not find(systempath + 'CONSTANT.EZY') then
      begin
	 writeln(chr254 + ' CONSTANT.EZY not found');
	 writeln(chr254 + ' Use EZYCFG.EXE to Create it');
	 halt(1);
      end;
   filemode := fdenynone + freadonly;
   assign(tempfile,systempath + 'CONSTANT.EZY');
   {$I-}
   repeat
      reset(tempfile,sizeof(constantrecord));
      error := ioresult;
      if (error = 5) then
	 delay(500) else
      if (error <> 0) then
	 runerror(error);
   until (error = 0);
   {$I+}
   blockread(tempfile,constant,1);
   close(tempfile);
   filemode := fdenynone + freadonly;
   assign(tempfile,tempstr);
   {$I-}
   repeat
      reset(tempfile,sizeof(configrec));
      error := ioresult;
      if (error = 5) then
	 delay(500) else
      if (error <> 0) then
	 runerror(error);
   until (error = 0);
   {$I+}
   blockread(tempfile,configrec,1);
   close(tempfile);
{$IFNDEF Wincompat}
   checksnow   := configrec.snow_check;
{$ENDIF}
   if length(configrec.semaphorepath)= 0 then
      configrec.semaphorepath := systempath;
end;

BEGIN
{$IFNDEF Wincompat}
   if (LastMode <> CO80) and (LastMode <> BW80) and
      (LastMode <> Mono) then
      TextMode(CO80);
   directvideo := false;
   textattr    := 7;
{$ENDIF}
{$IFNDEF NoEzy}
   newsetup;
{$ENDIF}

END.
