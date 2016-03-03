Unit SMacro;

Interface

Implementation

Uses Utilpack,TurboCOM,SE_Util,Crt;

Const
 keyUpArr = $FFFF;
 keyDnArr = $FFFE;
 keyEscap = $FFFD;
 keyHome  = $FFFC;
 keyPgUp  = $FFFB;
 keyLtArr = $FFFA;
 keyRtArr = $FFF9;
 keyEnd   = $FFF8;
 keyPgDn  = $FFF7;
 keyEnter = $FFF6;

Var
 X,Y,Wid,Len,YPos: Byte;
 OrigWMin,OrigWMax: Word;
 XLabel: Array[1..30] Of Word;
 UsrKey: Word;
 GLE: Byte;
 NextExecute: Boolean;
 F: Text;
 S: String;
 Cmd: String;
 Tmp,
 LineNo: Word;
 Key: Char;

Procedure DoWin(S: String);
Var TmpY: Byte;
Begin
 X:=IntVal(Copy(S,1,Pos(',',S)-1)); Delete(S,1,Pos(',',S));
 Y:=IntVal(Copy(S,1,Pos(',',S)-1)); Delete(S,1,Pos(',',S));
 Wid:=IntVal(Copy(S,1,Pos(',',S)-1)); Delete(S,1,Pos(',',S));
 Len:=IntVal(S);
 SaveWin(X,Y,Wid,Len);
 OrigWMin:=WindMin;
 OrigWMax:=WindMax;
 SGotoXY(X,Y);
 XSWrite('|ISÝ'+MakeStr((Wid-2) Div 2 - 3,'ß')+'|IL Help |IS'+MakeStr((Wid-2)-6-((Wid-2) Div 2 - 3),'ß')+'Þ');
 For TmpY:=Y+1 To Y+Len-2 Do
  Begin
   SGotoXY(X,TmpY);
   XSWrite('|ISÝ'+Pad('',Wid-2)+'Þ');
  End;
 SGotoXY(X,Y+Len-1);
 XSWrite('|ISÝ'+MakeStr(Wid-2,'Ü')+'Þ');
 SGotoXY(X+2,Y+YPos);
End;

Procedure DoLabel(S: String; Y: Word);
Begin
 XLabel[IntVal(S)]:=Y;
End;

Procedure Compare(S: String);
Var Val1,Val2: String;
Begin
 Val1:=UCase(Copy(S,1,Pos(',',S)-1));
 Delete(S,1,Pos(',',S));
 Val2:=UCase(S);
 If Val1='KEY' Then
  Begin
   If UsrKey<=255 Then Val1:=Chr(UsrKey) Else
    Begin
     If UsrKey = keyUpArr Then Val1:='UP' Else
     If UsrKey = keyDnArr Then Val1:='DOWN' Else
     If UsrKey = keyEscap Then Val1:='ESCAPE' Else
     If UsrKey = keyHome  Then Val1:='HOME' Else
     If UsrKey = keyPgUp  Then Val1:='PGUP' Else
     If UsrKey = keyLtArr Then Val1:='LEFT' Else
     If UsrKey = keyRtArr Then Val1:='RIGHT' Else
     If UsrKey = keyEnd   Then Val1:='END' Else
     If UsrKey = keyPgDn  Then Val1:='PGDN';
     If UsrKey = keyEnter Then Val1:='ENTER';
    End;
  End;
 If Val1>Val2 Then GLE:=1 Else
 If Val1<Val2 Then GLE:=2 Else
 If Val1=Val2 Then GLE:=3;
End;


Procedure Conditional(S: String);
Begin
 S:=UCase(S);
 If S='EQUAL' Then NextExecute:=(GLE=3) Else
 If S='NOTEQUAL' Then NextExecute:=(GLE<>3) Else
 If S='LESS' Then NextExecute:=(GLE=2) Else
 If S='GREATER' Then NextExecute:=(GLE=1);
End;

Procedure GotoLabel(S: String);
Var Dest: Word;
Begin
 Dest:=IntVal(S);
 Close(F);
 LineNo:=0;
 Reset(F);
 While (Not Eof(F)) And (LineNo<XLabel[Dest]) Do
  Begin ReadLn(F,S); Inc(LineNo); End;
End;

Procedure MoveXY(S: String);
Var nX,nY: Byte;
Begin
 nX:=IntVal(Copy(S,1,Pos(',',S)-1));
 Delete(S,1,Pos(',',S));
 nY:=IntVal(S);
 SGotoXY(X+nX+1,Y+nY);
 YPos:=nY;
End;


End.
