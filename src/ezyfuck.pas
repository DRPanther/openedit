{$O+,F+,R-,S-,Q-,V+,P+}

Program EzyFuck;
	{ 	This program will convert Ezy's fucked up non standard
                msginfo.x nonsense, to a normal old msginf file placed in
		a node directory of the editor as Ezy also deletes the
		node directory for some unknown insane reason that no one
		but a wack job could dream up.
         }
uses
  Dos,
  strings,
  crt;

{$I EZYCOM.INC}

var
  WrongOne: File of FSERecord;
  Rightone: Text;
  s	  : String;
  Node    : String;

(*
Function StoI;
Function ItoS;
*)

Procedure Dothework;
var
  TieFrom,
  TieTo,
  TieSubject,
  TieMsgNumber,
  TieMsgArea,
  TiePrivate: String;			{=YES / NO}
  Size: Longint;
  i: Integer;
  b: Byte;
begin
  Assign(Wrongone, 'c:\ezy\msginfo.' + node);
  Reset(WrongOne);
  Seek(Wrongone,size);
  i := size -1;
  Close(WrongOne);
  Reset(WrongOne);
  While not EOF(Wrongone) do
  begin
    Read(Wrongone, fserecord(b));
    with fserecord do
    begin
      TieFrom:= Whofrom;
      TieTo:= WhoTo;
      TieSubject := Subject;
      TieMsgNumber := '1';
      TieMsgArea := 'Unknown Message Area';
      TiePrivate := 'NO';
    end;
    Close(WrongOne);
  end;

{Write out the correct format msginf}
  Assign(RightOne, 'c:\ezy\iedit\node' + node);
  ReWrite(RightOne);
  WriteLn(RightOne, TieFrom);
  WriteLn(RightOne, TieTo);
  WriteLn(RightOne, TieSubject);
  WriteLn(RightOne, TieMsgNumber);
  WriteLn(RightOne, TieMsgArea);
  WriteLn(RightOne, TiePrivate);
  Close(RightOne);
end;


begin
  node := Paramstr(1);
end.
