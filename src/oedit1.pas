{$DEFINE CompileExtra}

Program OpenEDIT;
{$M 40000,0,360000}
{$I DEFINES.INC}

(*
        Open!EDIT by Shawn Highfield
        Last Modify date: April 11, 2011 / May 15 2013 (2 small changes)

Todo:
      - Rename yet again for opensource and because SD is a baby you can not disagree with
      - Taglines:The taglines come out weird; it repeats three of the
        same taglines then picks the next line (using a setting of 10).
      - Remove the "TimeLeft" from the footer to try to clean up display
      - Alt-[FUNCTION] Keys are not working for runningexternal programs.

Done:
     - Compiles
     - Change name from SabreEDIT to CheepEDIT
     - Back version number to 0.99x series so we are ready for a 1.0 release
     - Change Copyright date / name
     - Trapping on launch / see error.log
     - Compiled version no longer trapping
     - Remove all checks for reg code / remove all limits if not reg
     - Remove all HackPrevent shit
     - Taglines not working
     - Remove encryption for version number
     - When replying message on Ezycom it is instead putting in a ;registered sabreedit
       Has to do with the textheda / textfoot
     - Remove the texthead / textfoot feature.  NO need to brand and one less hassle for me
     - Add missing /I and /E function
     - If aborting the /I or /E function cedit now cleans up that line.
     - Adding a word to the dictionary aborts the message.
     - Fix Footer display.
     - Cheap n' Ezy now works all commandline based.
     - REmove reg key shit ***Use FreeKey for now*** / Features all work even if unregistered
     - Remove display's of unregistered or registered user as features will work no matter what
     - Now able to turn off tearline advertising.
     - Remove the routines to encrypt the config.
     - Update the setup program so it no longer traps or screws up when reloading.
     - Re-write the .MAK file for cesetup help.
     - Remove the Help system
     - Remove all ezycom support and use ezyfse instead?
     - Move source files to a new directory - include the BS below so I can package up source

Copyright (c) 2013, Shawn Highfield
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following
conditions are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
Neither the name of the Open!Edit nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*)


Uses
  CRT,
  TurboCOM,
  SE_Util,
  Utilpack,
  Dos,
  RCRC32,
  DESUnit
{$IFDEF CompileExtra}
  ,SEdit_Reg,
  SEUserEdit,
  ExecSwap;
{$ENDIF}

Label ReMsgEdit;

Var
 Key            : LongInt;
{$IFDEF CompileExtra}
 EStr           : Array[1..8,1..2] Of ^Str35;
 ExtraExpand    : Array[1..256,1..2] Of ^Str20;
 ExtraExpands   : Word;
{$ENDIF}
 CRC            : LongInt;
 PCnt           : Byte;
 LFs            : Byte;

Procedure kBumpDecode(MSeg,MOfs,Size: Word);
Var
  TmpW: Word;
  Adjust,
  E,
  K,
  O: Byte;
Begin
  Mem[MSeg:MOfs+Size-1]:=Mem[MSeg:MOfs+Size-1]-192;
  For TmpW:=1 To Size Do
  Begin
    E:=Mem[MSeg:MOfs+TmpW-1]; K:=Mem[Seg(Key):Ofs(Key)+TmpW Mod 4]; O:=E xor K;
    Mem[MSeg:MOfs+TmpW-1]:=O;
  End;
  For TmpW:=Size DownTo 1 Do
  Begin
    If TmpW<>Size Then Mem[MSeg:MOfs+TmpW-1]:=CW(Mem[MSeg:MOfs+TmpW-1],-Mem[MSeg:MOfs+TmpW]);
  End;
End;

Procedure kBumpEncode(MSeg,MOfs,Size: Word);
Var
  TmpW: Word;
  Adjust,
  O,
  E,
  K: Byte;
Begin
  For TmpW:=1 To Size Do
  Begin
    If TmpW<>Size Then Mem[MSeg:MOfs+TmpW-1]:=CW(Mem[MSeg:MOfs+TmpW-1],Mem[MSeg:MOfs+TmpW]);
  End;
  For TmpW:=1 To Size Do
  Begin
    O:=Mem[MSeg:MOfs+TmpW-1]; K:=Mem[Seg(Key):Ofs(Key)+TmpW Mod 4]; E:=O xor K;
    Mem[MSeg:MOfs+TmpW-1]:=E;
  End;
  Mem[MSeg:MOfs+Size-1]:=Mem[MSeg:MOfs+Size-1]+192;
End;

Function Line_Boundry: Boolean;
Begin
  Line_Boundry:=(CCol=1) Or (CCol>CurLength);
End;

Function Delimiter: Boolean;
Begin
  Case CurChar Of
    '0'..'9','a'..'z','A'..'Z','_': Delimiter:=False;
  Else Delimiter:=True;
  End;
End;

Function LastChar: Char;
Begin
  If CurLength=0 Then LastChar:=' ' Else LastChar:=MText[CLine]^[CurLength];
End;

Procedure Cursor_Begline;
Begin
  CCol:=1; Reposition;
End;

Procedure Cursor_WordRight;
Begin
{$IFDEF CompileExtra}
  If Delimiter Then
  Begin
    Repeat
      Cursor_Right; If Line_Boundry Then Exit;
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Until Not Delimiter;
   End
   Else
   Begin { Find next blank right }
     Repeat Cursor_Right; If Line_Boundry Then Exit;
   Until Delimiter;
   Cursor_WordRight; { Then move to a word start (recursive) }
  End;
{$ENDIF}
End;

Procedure Cursor_WordLeft;
Begin
{$IFDEF CompileExtra}
  If Delimiter Then
  Begin
    Repeat
      Cursor_Left; If Line_Boundry Then Exit;
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Until Not Delimiter;
    Repeat
      Cursor_Left;
      If Line_Boundry Then Exit;
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Until Delimiter;
    Cursor_Right;
  End
  Else
  Begin { Find next blank left }
    Repeat
      Cursor_left; If Line_Boundry Then Exit;
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Until Delimiter;
    Cursor_WordLeft; { And then move a word left (recursive) }
  End;
{$ENDIF}
End;

Procedure Reformat_Paragraph;     { Paragraph reformat, starting at current }
Begin                      { line and Ending at any empty or indented line; }
{$IFDEF CompileExtra}
  Remove_Trailing;                 { leaves Cursor after last line formatted }
  CCol:=CurLength;
  While CurChar<>' ' Do                     { For each line of the paragraph }
  Begin
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Repeat            { Determine length of first word on the following line }
      Inc(CLine); Remove_Trailing;
      CCol:=1; While CurChar<>' ' Do Inc(CCol);
      Dec(CLine);       { Hoist a word from the following line if it will fit }
      If (CCol>1) And (CCol+CurLength<WWrap) Then
      Begin
        If CurLength > 0 Then
        Begin
          Case Lastchar Of '.','?','!': Append_Space;
        End;
      Append_Space;
    End;
      MText[CLine]^:=MText[CLine]^+Copy(MText[CLine+1]^,1,CCol-1);
      Inc(CLine); While (CurChar=' ') And (CCol<=CurLength) Do Inc(CCol);
      Delete(MText[CLine]^,1,CCol-1);
      If CurLength=0 Then Delete_Line; Dec(CLine);
     End
     Else
      CCol:=0;
   Until CCol=0; { No more lines fit - time for next line, or EOParagraph }
   Inc(CLine); CCol:=1; Remove_Trailing;
  End;
{$ENDIF}
End;

Procedure Msg_Reformat;                { Reformat paragraph, update display }
Var
  Pline: Integer;
Begin
{$IFDEF CompileExtra}
  PLine := CLine; Reformat_Paragraph;
  While (CurLength=0) And (CLine<=LineCnt) Do Inc(CLine);
  While CLine-TopLine>Scrlines-2 do { Find top of screen for redisplay }
  Begin
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    Inc(TopLine,Config^.ScrollSiz); PLine:=TopLine;
  End;
  Refresh_screen;
{$ENDIF}
End;

Procedure Delete_WordRight;
Begin
{$IFDEF CompileExtra}
  If CurChar=' ' Then { Skip blanks right }
  Repeat
    Delete_Char;
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
  Until (CurChar<>' ') Or (CCol > CurLength)
  Else { Find next blank right }
  Repeat
    Delete_Char;
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
  Until Delimiter;
{$ENDIF}
End;

Procedure Cursor_Tab;
Begin
  Repeat
    Insert_Char(' ');
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
  Until (CCol Mod Config^.TabStop) = 0;
End;

Procedure Page_Down;
Begin
  If CLine+ScrLines>=Max_Msg_Lines Then Exit;
  If TopLine+ScrLines<Max_Msg_Lines Then
  Begin
    If TopLine+ScrLines<LineCnt Then
    Begin
      Inc(CLine,PageUpDnSiz); Scroll_Screen(PageUpDnSiz);
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    End
    Else
    Begin
      CLine:=LineCnt+1;
      Scroll_Screen(0);
      If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
    End;
  End;
End;

Procedure Page_Up;
Begin
  If TopLine>1 Then
  Begin
    Dec(CLine,PageUpDnSiz); If CLine < 1 Then CLine := 1;
    Scroll_Screen(-PageUpDnSiz);
    If (LastSlice+Slicing<=Timer) Then ReleaseSlice;
  End;
End;

Procedure Msg_Insert_Line;              { Open a blank line, update display }
Begin
  Insert_Line('');
  If CLine-TopLine>Scrlines-2 Then Scroll_Screen(Config^.ScrollSiz) Else Refresh_Screen;
End;

Procedure Msg_Delete_Line;  { Delete the line at the cursor, update display }
Begin
  Delete_Line;
  Refresh_Screen;
End;

Procedure Redisplay;
Begin
  TopLine:=CLine-ScrLines Div 2;
  Prepare_Screen;
End;

Procedure WoW;
Begin
  SWrite('[0m[1;30m'+GetChar+'[1;34;44m');
End;

Function GetQuoteLine(I: LongInt): String;
Var
  S: String;
Begin
  GetQuoteLine:='';
  Assign(Qfile,SysPath+'OEDIT.QUO');
  Reset(Qfile);
  If I>FileSize(Qfile) Then
  Begin
    Close(Qfile);
    Exit;
  End;
  Seek(Qfile,I-1);
  Read(Qfile,Qtext);
  Close(QFile);
  S:=Ltrim(QText);
  If Copy(S,1,15)=Config^.RepStr Then
  QText:=' '+S
  Else
  Begin
    QText:=' '+ToInitials+'> '+S;
    If QText=' '+ToInitials+'> ' Then QText:='';
  End;
  If Config^.Censor Then QText:=Censor(QText);
  GetQuoteLine:=Qtext;
End;

{$IFDEF CompileExtra}
Procedure Expand;
Const
  ExpandUtils    = 2;
  ExpandUtil     : Array[1..ExpandUtils,1..2] Of String[10] = (
                  ('THANG',    'TinysHANG' ),
                  ('OEDIT',    'Open!EDIT' )
                                           );
  ExpandWords    = 2;
  ExpandWord     : Array[1..ExpandWords,1..2] Of String[35] = (
                  ('@SMILEY@',             ':) =) :] =] :> :-) |-) =-) =-> };^)'),
                  ('@TINYSBBS@',           'www.tinysbbs.com')
                                                                   );
Var
  Cnt,
  Tmp: Word;
  KeyPhrase: String;
  LastChar: Char;
  Abort: Boolean;
  Back: Byte;
Begin
  If Expired Then Exit;
  EStr[1,1]^:='@DATE@';  EStr[1,2]^:=Copy(UnpackedDT(CurrentDT),1,8);
  EStr[2,1]^:='@TIME@';  EStr[2,2]^:=Copy(UnpackedDT(CurrentDT),10,8);
  Abort:=False;
  If (NOt User.UseExpand) then abort:=True;
  If Not Config^.UseExpand Then Abort:=True;
  If Abort Then Exit;
  KeyPhrase:='';
  {If LastWasCR Then}
  Tmp:=CCol-2;
  If LastWasCR Then Inc(Tmp);
  LastChar:=MText[CLine]^[CCol-1];
  While (Not (MText[CLine]^[Tmp] in DelimiterChars)) And (Tmp<>0) Do
  Begin
    KeyPhrase:=UpCase(MText[CLine]^[Tmp])+Keyphrase;
    Dec(Tmp);
  End;
  If KeyPhrase='' Then Exit;

  For Cnt:=0 To 9 Do
  If (Config^.ExpandWord[Cnt,1]<>'') And (KeyPhrase=Config^.ExpandWord[Cnt,1]) Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(Config^.ExpandWord[Cnt,2]) Do Insert_Char(Config^.ExpandWord[Cnt,2][Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;

  For Cnt:=1 To ExpandWords Do
  If KeyPhrase=ExpandWord[Cnt,1] Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(ExpandWord[Cnt,2]) Do Insert_Char(ExpandWord[Cnt,2][Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;

  For Cnt:=0 To 9 Do
  If KeyPhrase=User.Expand[Cnt,1] Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(User.Expand[Cnt,2]) Do Insert_Char(User.Expand[Cnt,2][Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;

  For Cnt:=1 To ExtraExpands Do
  If KeyPhrase=ExtraExpand[Cnt,1]^ Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(ExtraExpand[Cnt,2]^) Do Insert_Char(ExtraExpand[Cnt,2]^[Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;

  For Cnt:=1 To ExpandUtils Do
  If KeyPhrase=ExpandUtil[Cnt,1] Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(ExpandUtil[Cnt,2]) Do Insert_Char(ExpandUtil[Cnt,2][Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;

  For Cnt:=1 To 8 Do
  If KeyPhrase=EStr[Cnt,1]^ Then
  Begin
    Back:=Length(KeyPhrase)+1;
    If LastWasCR Then Dec(Back);
    For Tmp:=1 To Back Do
    Begin
      Cursor_Left;
      Delete_Char;
    End;
    For Tmp:=1 To Length(EStr[Cnt,2]^) Do Insert_Char(EStr[Cnt,2]^[Tmp]);
    If (Not LastWasCR) Then Insert_Char(LastChar);
    Exit;
   End;
End;
{$ENDIF}

Procedure QuoteWindow;
Var
  xSx: String;
  LeftStr: String[80];
  Key: Char;
  Tmp: Byte;
  OrigLines: Word;

  Procedure UpdateWin;
  Var
    Tmp: Word;
  Begin
    For Tmp:=1 To Config^.QuoteWinSize Do
    Begin
      SGotoXY(1,23-Config^.QuoteWinSize+Tmp-1); SClrEol; FunkyWrite(' '+GetQuoteLine(QuoteLineNum+Tmp-1));
    End;
  End;

Begin
  If QuoteLineCnt=0 Then Exit;
  OrigLines:=ScrLines;
  ScrLines:=ScrLines-Config^.QuoteWinSize;
  xSx:=LS(1);
  PF_overridepos:=23-Config^.QuoteWinSize-1; Plain_Footer(1);
  Plain_Footer(2);
  SGotoXY(39-(Length(' '+xSx+' ') Div 2),23-Config^.QuoteWinSize-1);
  FunkyWrite(' '+xSx+' ');
  For Tmp:=23-Config^.QuoteWinSize To 22 Do
  SWrite('['+StrVal(Tmp)+';1H[K');
  SGotoXY(57-Length(LS(2)+LS(3)),23);
  XSWrite(' |FS<|FCE|FLnter|FS> ');
  FunkyWrite(LS(2));
  XSWrite('  |FS<|FCE|FLsc|FS> ');
  FunkyWrite(LS(3)+' ');
  If QuoteHil<1 Then QuoteHil:=1;
  If QuoteLineNum<1 Then QuoteLineNum:=1;
  If QuoteLineNum>QuoteLineCnt Then QuoteLineNum:=QuoteLineCnt;
  UpdateWin;
  OKPageNum:=False;
  Repeat
    If QuoteHil<1 Then QuoteHil:=1;
    If QuoteLineNum<1 Then QuoteLineNum:=1;
    If QuoteLineNum>QuoteLineCnt Then QuoteLineNum:=QuoteLineCnt;
    If (QuoteHil=1) And (QuoteLineNum=0) Then QuoteLineNum:=1;
    If QuoteLineNum+QuoteHil-1>QuoteLineCnt Then QuoteLineNum:=(QuoteLineCnt-QuoteHil+1);
    SGotoXY(1,23-Config^.QuoteWinSize+QuoteHil-1); {SClrEol;}
    SWrite(ANSICode[User.NC]+' '+ANSICode[40+User.FieldColor]+GetQuoteLine(QuoteLineNum+QuoteHil-1)+'[K[0m');
    SGotoXY(79,23-Config^.QuoteWinSize+QuoteHil-1); SClrEol;
    Repeat
      Key:=Get_Key;
    Until Key in [^[,#0,'8','2','9','3','7','1',#13,^Q,^W,^E,^X,^R,^C];
    SGotoXY(1,23-Config^.QuoteWinSize+QuoteHil-1); {SClrEol;}
    FunkyWrite(' '+GetQuoteLine(QuoteLineNum+QuoteHil-1)); SWrite('[K');
    If (Key=#0) Then
    Begin
      Key:=Get_Key;
      Case Key Of
      'H': Key := ^E;     {UpArrow}
      'P': Key := ^X;     {DownArrow}
      'I': Key := ^R;     {PgUp}
      'Q': Key := ^C;     {PgDn}
      'G': Key := ^L;     {Home}
      'O': Key := ^P;     {End}
      Else Key := #0;
     End;
   End;
  If (Key=#27) Then
  Begin
    If Not (Keypressed or SKeypressed) Then KeyDelay(250);
    If (Keypressed Or SKeypressed) Then
    Begin
      Key:=Get_Key;
      If Key='[' Then Key:=Get_Key;
      If Key='O' Then Key:=Get_Key;
      Case Key Of
        'A': Key:=^E;     {UpArrow}
        'B': Key:=^X;     {DownArrow}
        'r': Key:=^R;     {PgUp}
        'q': Key:=^C;     {PgDn}
        'H': Key:=^L;     {Home}
        'K',              {End - PROCOMM+}
        'R': Key:=^P;     {End - GT}
        #27: Key:=^Q;
       End;
     End Else Key:=^Q;
   End;
  If Key=#13 Then
   Begin
     Insert_Line(GetQuoteLine(QuoteLineNum+QuoteHil-1));
     refresh_Screen;
     Key:='2';
     Cursor_Down(True);
   end;
   If Key in [^E,'8'] Then
   If Not ((QuoteLineNum=1) And (QuoteHil=1)) Then
   Begin
     Dec(QuoteHil);
     If QuoteHil=0 Then
     Begin
       QuoteHil:=1;
       Dec(QuoteLineNum);
       UpdateWin;
     End;
   End;
   If Key in [^X,'2'] Then
   If Not ((QuoteHil+QuoteLineNum-1)=QuoteLineCnt) Then
   Begin
     Inc(QuoteHil);
     If QuoteHil=Config^.QuoteWinSize+1 Then
     Begin
       QuoteHil:=Config^.QuoteWinSize;
       Inc(QuoteLineNum);
       UpdateWin;
     End;
   End;
   If Key in [^R,'9'] Then
   If QuoteLineNum>Config^.QuoteWinSize Then { Don't go TOO far up }
   Begin
     Dec(QuoteLineNum,Config^.QuoteWinSize);
     UpdateWin;
   End
   Else
     Key:='7';
   If Key in [^C,'3'] Then
   If QuoteLineNum+QuoteHil-1+Config^.QuoteWinSize<=QuoteLineCnt Then
   Begin
     Inc(QuoteLineNum,Config^.QuoteWinSize);
     UpdateWin;
   End Else
   Key:='1';
   If Key in [^L,'7'] Then Begin QuoteLineNum:=1; UpdateWin; End;
   If Key in [^P,'1'] Then
   Begin
     While QuoteLineNum+Config^.QuoteWinSize<QuoteLineCnt Do Inc(QuoteLineNum,Config^.QuoteWinSize);
     UpdateWin;
   End;
  Until (Key=^Q) Or (Key=^W);
  ScrLines:=OrigLines;
  OKPageNum:=True;
  Unquote_Screen;
  Reposition;
End;

Function ConfirmAbort: Boolean;
Var
  C: Char;
Begin
  If Expired Then ConfirmAbort:=True;
  Plain_Footer(2);
  SGotoXY(67-Length(LS(4)),23);
  FunkyWrite(' '+LS(4)+' (y/N) ');
  Repeat
    C:=UpCase(GetLow);
    If C=#13 Then C:='N';
  Until C in ['Y','N'];
  ConfirmAbort:=(C='Y');
  Display_Footer(2);
End;

{$IFDEF CompileExtra}
Procedure SigSetup;
Var
 Key,
 C: Char;
 Hil: Byte;
Begin
  If User.SigPtr<>0 Then
  Begin
    Assign(SigFile,CfgPath+'OEDIT.SIG');
    FileMode:=66; Reset(SigFile); FileMode:=2;
    Seek(SigFile,User.SigPtr-1);
    Read(SigFile,Sig);
    Close(SigFile);
  End;

  SGotoXY(3,08);
  XSWrite('|BCÚÄ ');
  FunkyWrite(LS(7));
  XSWrite(' |BC'+MakeStr(67-Length(LS(7)),#196)+'|PCÄÄ|HCÄÄ|NC¿');
  SGotoXY(3,09);
  XSWrite('|BC³ ');
  FunkyWrite(Pad(LS(8),72));
  XSWrite(' |HC³');
  SGotoXY(3,10);
  XSWrite('|BC³ ');
  FunkyWrite(Pad(LS(9),72));
  XSWrite(' |PC³');
  SGotoXY(3,11);
  XSWrite('|BC³                                                                          |BC³');
  SGotoXY(3,12);
  XSWrite('|BC³ |FD1|FS: ');
  FunkyWrite(Pad(Sig[1],69));
  XSWrite('[0m |BC³');
  SGotoXY(3,13);
  XSWrite('|BC³ |FD2|FS: ');
  FunkyWrite(Pad(Sig[2],69));
  XSWrite('[0m |BC³');
  SGotoXY(3,14);
  XSWrite('|BC³ |FD3|FS: ');
  FunkyWrite(Pad(Sig[3],69));
  XSWrite('[0m |BC³');
  SGotoXY(3,15);
  XSWrite('|PC³ |FD4|FS: ');
  FunkyWrite(Pad(Sig[4],69));
  XSWrite('[0m |BC³');
  SGotoXY(3,16);
  XSWrite('|HC³ |FD5|FS: ');
  FunkyWrite(Pad(Sig[5],69));
  XSWrite('[0m |BC³');
  SGotoXY(3,17);
  XSWrite('|NCÀ|HCÄÄ|PCÄÄ|BCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  Hil:=1;
  Repeat
    SGotoXY(4,11+Hil);
    XSWrite('|IC '+StrVal(Hil)+': '+Pad(Sig[Hil],69)+' [0m');
    Repeat
      Key:=Get_Key;
    Until Key in [^[,#0,'2','8',#13,^E,^X,'Q','q'];
    SGotoXY(4,11+Hil);
    XSWrite(' |FD'+StrVal(Hil)+'|FS: ');
    FunkyWrite(Pad(Sig[Hil],69)+' ');
    If (Key=#0) Then
    Begin
      Key:=Get_Key;
      Case Key Of
      'H': Key := ^E;     {UpArrow}
      'P': Key := ^X;     {DownArrow}
      Else Key := #0;
      End;
      End;
      If (Key=#27) Then
      Begin
        If Not (Keypressed or SKeypressed) Then KeyDelay(250);
        If (Keypressed Or SKeypressed) Then
        Begin
          Key:=Get_Key;
          If Key='[' Then Key:=Get_Key;
          If Key='O' Then Key:=Get_Key;
          Case Key Of
          'A': Key:=^E;     {UpArrow}
          'B': Key:=^X;     {DownArrow}
          Else Key:=#27;
          End;
        End Else Key:=#27;
      End;
      Case Key Of
      ^E,'8': If Hil<>1 Then Dec(Hil);
      ^X,'2': If Hil<>5 Then Inc(Hil);
      #13:
      Begin
        C:=Chr(48+Hil);
        SGotoXY(8,11+IntVal(C));
        If Config^.OKSigHiBit Then SReadHighBit:=True;
        SRead(Sig[IntVal(C)],69,Sig[IntVal(C)]);
        SGotoXY(8,11+IntVal(C));
        SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]+Sig[IntVal(C)]);
      End;
      End;
      Until (Key=#27) Or (UpCase(Key)='Q');
      Assign(SigFile,CfgPath+'OEDIT.SIG');
      FileMode:=66;
      {$I-}Reset(SigFile);{$I+}
      FileMode:=2;
      If IOResult<>0 Then ReWrite(SigFile);
      If User.SigPtr=0 Then
      User.SigPtr:=FileSize(SigFile)+1;
      Seek(SigFile,User.SigPtr-1);
      Write(SigFile,Sig);
      Close(SigFile);
End;

Procedure SelectLanguage;
Var
  S: String[80];
  Hil,Top,Tmp,Max: Word;
  LFile: Array[1..45] Of String[30];
  SR: SearchRec;
  F: File;
  Buf: Array[1..16] Of Char;
  Key: Char;

Procedure Center(S: String; B: Byte);
Begin
  SGotoXY(40-(Length(NoPipe(S)) Div 2),B);
  XSWrite(S);
End;

Function C(S: String; Wid: Byte): String;
Begin
  Delete(S,1,Pos(' ',S));
  S:=RTrim(LTrim(S));
  S:=MakeStr(Wid Div 2 - Length(S) Div 2,#32)+S;
  C:=Pad(S,Wid);
End;

Procedure ShowLang(xStart,xEnd: Word);
Var
  Tmp: Word;
Begin
  For Tmp:=xStart To xEnd Do
  Begin
    SGotoXY(31,11+Tmp-Top-1); FunkyWrite(' '+C(LFile[Tmp],16)+' ');
  End;
  While xEnd-xStart+1<4 Do
  Begin
    Inc(xEnd);
    SGotoXY(31,11+xEnd-Top-1); FunkyWrite(' '+C('',16)+' ');
  End;
End;

Begin
  User.LangFile:=Config^.LanguageFile;
  FindFirst(CfgPath+'*.LNG',AnyFile,SR);
  LFs:=0;
  While DOSError=0 Do
  Begin
    If SR.Attr And Directory <> 0 Then
    Begin
      FindNext(SR);
      Continue;
    End;
    Inc(LFs);
    LFile[LFs]:=SR.Name;
    Assign(F,CfgPath+SR.Name);
    Reset(F,1);
    Seek(F,$20); BlockRead(F,Buf,SizeOf(Buf));
    Move(Buf,S[1],16);
    S[0]:=#16;
    S:=Rtrim(S);
    If S='Use LANGEDIT.EXE' Then
    Begin
      S:='Unknown Language';
      Move(S[1],Buf,16);
      Seek(F,$20); BlockWrite(F,Buf,SizeOf(Buf));
      Seek(F,$20-3); Buf[1]:=':'; BlockWrite(F,Buf[1],1);
      Seek(F,$30); FillChar(Buf,SizeOf(Buf),#32); BlockWrite(F,Buf,9);
    End;
    Close(F);
    LFile[LFs]:=LFile[LFs]+FPad(S,18);
    FindNext(SR);
  End;
  If (User.LangFile<>'') And (FileExists(CfgPath+User.LangFile+'.LNG')) Then
  Begin
    LanguageFile:=User.LangFile;
    Exit;
  End;
  If LFs=1 Then
  Begin
    LanguageFile:=Copy(LFile[1],1,Pos('.',LFile[1])-1);
    Exit;
  End;
  Center('|NC'+LS(99)+' Open!EDIT v'+Ver+'!',9);
  SGotoXY(25,10); XSWrite('|NCÚ|HCÄÄ|PCÄÄ|BCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  SGotoXY(25,11); XSWrite('|HC³|FZÛ²±°                       |FZ°|BC³');
  SGotoXY(25,12); XSWrite('|PC³|FZ²±°                       |FZ°±|BC³');
  SGotoXY(25,13); XSWrite('|BC³|FZ±°                       |FZ°±²|PC³');
  SGotoXY(25,14); XSWrite('|BC³|FZ°                       |FZ°±²Û|HC³');
  SGotoXY(25,15); XSWrite('|BCÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|PCÄÄ|HCÄÄ|NCÙ');
  Center('|NC'+LS(100),16);
  Center('|BC(|PCUp|BC/|PCDn|BC) |NC'+LS(52)+'  |BC(|PCEnter|BC)|NC '+LS(57),17);
  Top:=0;
  Hil:=1;
  Max:=4;
  If Max>LFs Then Max:=LFs;
  ShowLang(Top+1,Top+Max);
  Repeat
    SGotoXY(31,10+Hil);
    XSWrite(Encode(C(LFile[Top+Hil],16),18)+'[0m');
    SGotoXY(1,1);
    SWrite('[0;30m '#8);
    Key:=Get_Key;
    SGotoXY(31,10+Hil);
    FunkyWrite(' '+C(LFile[Top+Hil],16)+' ');
    If (Key=#0) Then
    Begin
      Key:=Get_Key;
      Case Key Of
      'H': Key:=^E; { UpArrow }
      'P': Key:=^X; { DownArrow }
      Else
      Key := #0;
    End;
   End;
  If (Key=#27) Then
   Begin
    If Not (SKeypressed Or Keypressed) Then
    Begin
      KeyDelay(250);
      If Not (SKeypressed Or Keypressed) Then Key:=#27 Else Key:=Get_Key;
    End
    Else
    Key:=Get_Key;
    If Key='[' Then Key:=Get_Key;
    If Key='O' Then Key:=Get_Key;
    Case Key Of
    'A': Key:=^E;  { UpArrow }
    'B': Key:=^X;  { DownArrow }
    #00: key:=#27; { Timeout - escape key }
    #27: ;
     End;
   End;
  Case Key Of
    '8',^E: Begin { Up }
              Dec(Hil);
              If Hil=0 Then
              Begin
                Inc(Hil);
                If Top>0 Then
                Begin
                  Dec(Top);
                  Max:=4; ShowLang(Top+1,Top+Max);
                End;
              End;
            End;
    '2',^X: Begin { Down }
              If Hil+1<=LFs Then Inc(Hil);
              If Hil=5 Then
              Begin
                Dec(Hil);
                If Top+Hil+1<=LFs Then
                Begin
                  Inc(Top);
                  Max:=4; ShowLang(Top+1,Top+Max);
                End;
              End;
            End;
    ^M: Begin
          LanguageFile:=Copy(LFile[Top+Hil],1,Pos('.',LFile[Top+Hil])-1);
          SClrScr; StatusBar;
          User.LangFile:=LanguageFile;
          Assign(UserFile,CfgPath+'OEDITUSR.CFG');
          Reset(UserFile);
          Seek(UserFile,UIDX);
          Write(UserFile,User);
          Close(UserFile);
          Exit;
        End;
    ^[: ;
   End;
 Until False;
End;

Procedure UserConfig;
Const
  X: Array[1..15] Of String[4] = (
        'DBlu','DGrn','DCya','DRed','DMag','DBrn','DWhi','DGry',
        'LBlu','LGrn','LCya','LRed','LMag','Yelo','LWhi');
  YN: Array[False..True] Of Char = ('N','Y');
Var
  Tmp,
  Bk: Byte;
  S: String;
  C: Char;
  Label ShowOrigScreen;
Begin
  Bk:=0;
  While User.IC>=$10 Do Dec(User.IC,$10); { should never be, but just in case }
  While User.IL>=$10 Do Dec(User.IL,$10);
  While User.ID>=$10 Do Dec(User.ID,$10);
  While User.IS>=$10 Do Dec(User.IS,$10);
  InputFore:=User.IC; InputBack:=User.FieldColor;
  SigSetup;
  SWrite('[0m[2J');
  StatusBar;
  Display_Header;
  Display_Footer(3);
  Prepare_Screen; Reposition;
  FileMode:=66; Reset(UserFile); FileMode:=2; Seek(UserFile,UIDX); Write(UserFile,User); Close(UserFile);
  ShowOrigScreen:
  SWrite('[0m');
  SClrScr; StatusBar;
  XSWrite(' |BCÚÄ'); FunkyWrite(' '+LS(10)+' ');
  XSWriteLn('|BC'+MakeStr(69-Length(LS(10)),#196)+'|PCÄÄ|HCÄÄ|NC¿');
  XSWriteLn(' |BC³                                                                            |HC³');
  XSWrite(' |BC³    '); FunkyWrite(Pad(LS(11),52));
  XSWriteLn('                    |PC³');
  XSWriteLn(' |BC³    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                    |BC³');
  XSWrite(' |BC³ |FD1|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDA|FS. '); FunkyWrite(Pad(LS(12),13)); XSWriteLn(' |FC'+YN[User.UseTaglines]+' |BC³');
  XSWrite(' |BC³ |FD2|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDB|FS. '); FunkyWrite(Pad(LS(13),13)); XSWriteLn(' |FC'+YN[User.UseExpand]+' |BC³');
  XSWrite(' |BC³ |FD3|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDC|FS. '); FunkyWrite(Pad(LS(14),13)); XSWriteLn(' |FC'+YN[User.UseKeywords]+' |BC³');
  XSWrite(' |BC³ |FD4|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDD|FS. '); FunkyWrite(Pad(LS(15),13)); XSWriteLn(' |FC'+YN[Not User.UseSpellchk]+' |BC³');
  XSWrite(' |BC³ |FD5|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDE|FS. '); FunkyWrite(Pad(LS(16),13)); XSWriteLn(' |FC'+YN[User.AutoTagline]+' |BC³');
  XSWrite(' |BC³ |FD6|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDF|FS. '); FunkyWrite(Pad(LS(17),13)); XSWriteLn(' |FC'+YN[User.AutoSigs]+' |BC³');
  XSWrite(' |BC³ |FD7|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+
            '[0m |FDG|FS. '); FunkyWrite(Pad(LS(102),15)); XSWriteLn(' |BC³');
  XSWrite(' |BC³ |FD8|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+'[0m |FDH|FS. ');
  If LFs>1 Then FunkyWrite(Pad(LS(101),15)) Else SWrite('[1;30m'+Pad(LS(101),15));
  XSWriteLn(' |BC³');
  XSWrite(' |BC³ |FD9|FS. |IC'+Pad('',25)+'[0m  |IC'+Pad('',25)+'[0m |FDI|FS. '); FunkyWrite(Pad(LS(18),14));
  XSWriteLn('  |BC³');
  XSWriteLn(' |BC³                                                                            ³');
  XSWrite(' |BC³   '); FunkyWrite(Pad(LS(19),72));
  XSWriteLn(' |BC³');
  XSWriteLn(' |BC³  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ      ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ³');
  XSWrite(' |BC³  |FDJ|FS. ');       FunkyWrite(Pad(LS(20),7)); XSWrite(' |FS[þ]     |FDN|FS. '); FunkyWrite(Pad(LS(21),7));
  XSWrite(' |FS[þ]      |FDR|FS. '); FunkyWrite(Pad(LS(21),7));
  XSWriteLn(' |FS[þ]     |FDV|FS. |NC'+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[1],10)+'[0m|BC   ³');
  XSWrite(' |BC³  |FDK|FS. ');       FunkyWrite(Pad(LS(22),7)); XSWrite(' |FS[þ]     |FDO|FS. '); FunkyWrite(Pad(LS(23),7));
  XSWrite(' |FS[þ]      |FDS|FS. '); FunkyWrite(Pad(LS(23),7));
  XSWriteLn(' |FS[þ]     |FDW|FS. |NC'+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[2],10)+'[0m|BC   ³');
  XSWrite(' |BC³  |FDL|FS. ');       FunkyWrite(Pad(LS(24),7)); XSWrite(' |FS[þ]     |FDP|FS. '); FunkyWrite(Pad(LS(25),7));
  XSWrite(' |FS[þ]      |FDT|FS. '); FunkyWrite(Pad(LS(25),7));
  XSWriteLn(' |FS[þ]     |FDX|FS. |NC'+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[3],10)+'[0m|BC   ³');
  XSWrite(' |PC³  |FDM|FS. ');       FunkyWrite(Pad(LS(26),7)); XSWrite(' |FS[þ]     |FDQ|FS. '); FunkyWrite(Pad(LS(27),7));
  XSWrite(' |FS[þ]      |FDU|FS. '); FunkyWrite(Pad(LS(27),7));
  XSWriteLn(' |FS[þ]     |FDY|FS. |NC'+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[4],10)+'[0m|BC   ³');
  XSWriteLn(' |HC³                                                                            |BC³');
  XSWriteLn(' |NCÀ|HCÄÄ|PCÄÄ|BCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]);
  For Tmp:=0 To 8 Do
  Begin
    SGotoXY(7,5+Tmp); SWrite(User.Expand[Tmp,1]+'['+StrVal(27-Length(User.Expand[Tmp,1]))+'C'+User.Expand[Tmp,2]);
  End;
  Repeat
    SWrite('[0m');
    SGotoXY(17,17); SWrite(ANSICode[User.NC]); SWrite('þ');
    SGotoXY(17,18); SWrite(ANSICode[User.HC]); SWrite('þ');
    SGotoXY(17,19); SWrite(ANSICode[User.PC]); SWrite('þ');
    SGotoXY(17,20); SWrite(ANSICode[User.BC]); SWrite('þ');
    SGotoXY(36,17); SWrite(ANSICode[User.FC]); SWrite('þ');
    SGotoXY(36,18); SWrite(ANSICode[User.FL]); SWrite('þ');
    SGotoXY(36,19); SWrite(ANSICode[User.FD]); SWrite('þ');
    SGotoXY(36,20); SWrite(ANSICode[User.FS]); SWrite('þ');
    SGotoXY(56,17); SWrite(ANSICode[User.IC]+ANSICode[40+User.FieldColor]); SWrite('þ');
    SGotoXY(56,18); SWrite(ANSICode[User.IL]+ANSICode[40+User.FieldColor]); SWrite('þ');
    SGotoXY(56,19); SWrite(ANSICode[User.ID]+ANSICode[40+User.FieldColor]); SWrite('þ');
    SGotoXY(56,20); SWrite(ANSICode[User.IS]+ANSICode[40+User.FieldColor]); SWrite('þ');
    User.FZ:=User.PC;
    SGotoXY(1,23);
    SWrite('[0m');
    C:=UpCase(GetLow);
    Case C Of
    'A'     : Begin
                User.UseTaglines:=Not User.UseTaglines;
                SGotoXY(77,5);
                SWrite(ANSICode[User.FC]+YN[User.UseTaglines]);
              End;
    'B'     : Begin
                User.UseExpand:=Not User.UseExpand;
                SGotoXY(77,6);
                SWrite(ANSICode[User.FC]+YN[User.UseExpand]);
              End;
    'C'     : Begin
                User.UseKeywords:=Not User.UseKeywords; SGotoXY(77,7); SWrite(ANSICode[User.FC]+YN[User.UseKeywords]);
              End;
    'D'     : Begin
                User.UseSpellChk:=Not User.UseSpellChk; SGotoXY(77,8); SWrite(ANSICode[User.FC]+YN[Not User.UseSpellChk]);
              End;
    'E'     : Begin
                User.AutoTagline:=Not User.AutoTagline;
                SGotoXY(77,9);
                SWrite(ANSICode[User.FC]+YN[User.AutoTagline]);
              End;
    'F'     : Begin
                User.AutoSigs:=Not User.AutoSigs;
                SGotoXY(77,10);
                SWrite(ANSICode[User.FC]+YN[User.AutoSigs]);
              End;
    'G'     : Begin
                DInc2(User.FieldColor);
                User.ChgdColors:=True;
              End;
    'H'     : Begin
                User.LangFile:='';
                SWrite('[0m');
                SClrScr;
                StatusBar;
                SelectLanguage;
                If MemLang then
                Begin
                  Dispose(Lang);
                  MemLang:=False;
                End;
                If MaxAvail>LangCnt*76 Then
                Begin
                  MemLang:=True;
                  New(Lang);
                  LoadS;
                End;
                Goto ShowOrigScreen;
              End;
    'I'     : Begin
                SigSetup;
                Goto ShowOrigScreen;
              End;
    'J'     : Begin
                DInc(User.NC);
                User.ChgdColors:=True;
               End;
    'K'     : Begin
                DInc(User.HC); User.ChgdColors:=True;
              End;
    'L'     : Begin DInc(User.PC); User.ChgdColors:=True; End;
    'M'     : Begin DInc(User.BC); User.ChgdColors:=True; End;

    'N'     : Begin DInc(User.FC); User.ChgdColors:=True; End;
    'O'     : Begin DInc(User.FL); User.ChgdColors:=True; End;
    'P'     : Begin DInc(User.FD); User.ChgdColors:=True; End;
    'Q'     : Begin DInc(User.FS); User.ChgdColors:=True; End;

    'R'     : Begin DInc(User.IC); User.ChgdColors:=True; End;
    'S'     : Begin DInc(User.IL); User.ChgdColors:=True; End;
    'T'     : Begin DInc(User.ID); User.ChgdColors:=True; End;
    'U'     : Begin DInc(User.IS); User.ChgdColors:=True; End;
    'V'     : Begin
                SGotoXY(66,17); SRead(User.TagKeyword[1],10,User.TagKeyword[1]);
                SGotoXY(66,17); SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[1],10));
              End;
    'W'     : Begin
                SGotoXY(66,18); SRead(User.TagKeyword[2],10,User.TagKeyword[2]);
                SGotoXY(66,18); SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[2],10));
              End;
    'X'     : Begin
                SGotoXY(66,19); SRead(User.TagKeyword[3],10,User.TagKeyword[3]);
                SGotoXY(66,19); SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[3],10));
              End;
    'Y'     : Begin
                SGotoXY(66,20); SRead(User.TagKeyword[4],10,User.TagKeyword[4]);
                SGotoXY(66,20); SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]+Pad(User.TagKeyword[4],10));
              End;
    '1'..'9': Begin
                SGotoXY(7,4+(Ord(C)-Ord('0')));
                SRead(User.Expand[(Ord(C)-Ord('0'))-1,1],25,User.Expand[(Ord(C)-Ord('0'))-1,1]);
                User.Expand[(Ord(C)-Ord('0'))-1,1]:=UCase(User.Expand[(Ord(C)-Ord('0'))-1,1]);
                SGotoXY(34,4+(Ord(C)-Ord('0')));
                SRead(User.Expand[(Ord(C)-Ord('0'))-1,2],25,User.Expand[(Ord(C)-Ord('0'))-1,2]);
                SGotoXY(7,4+(Ord(C)-Ord('0'))); SWrite(ANSICode[User.NC]+ANSICode[40+User.FieldColor]);
                SWrite(User.Expand[+(Ord(C)-Ord('0'))-1,1]+
                      '['+StrVal(27-Length(User.Expand[(Ord(C)-Ord('0'))-1,1]))+'C'+
                User.Expand[(Ord(C)-Ord('0'))-1,2]);
               End;
   End;
  Until (C=#27) Or (C=#13);
  NC:=ANSICode[User.NC];
  HC:=ANSICode[User.HC];
  BC:=ANSICode[User.BC];
  PC:=ANSICode[User.PC];
  FZ:=ANSICode[User.FZ];
  FC:=ANSICode[User.NC];
  FL:=ANSICode[User.FL];
  FS:=ANSICode[User.FS];
  FD:=ANSICode[User.FD];
  IC:=ANSICode[User.IC]+ANSICode[40+User.FieldColor];
  ID:=ANSICode[User.ID]+ANSICode[40+User.FieldColor];
  IL:=ANSICode[User.IL]+ANSICode[40+User.FieldColor];
  IS:=ANSICode[User.IS]+ANSICode[40+User.FieldColor];
  SWrite('[0m[2J');
  StatusBar;
  Display_Header;
  Display_Footer(3);
  Prepare_Screen;
  Reposition;
  FileMode:=66;
  Reset(UserFile);
  FileMode:=2;
  Seek(UserFile,UIDX);
  Write(UserFile,User);
  Close(UserFile);
End;
{$ENDIF}

Function CheckQuoteRatio: Boolean;
Var
  Quotes,NonQuotes,Tmp: LongInt;
  QuotePct: Real;
  S: String[80];
  C: Char;
Begin
  CheckQuoteRatio:=True;
  Quotes:=0; NonQuotes:=0;
  For Tmp:=1 To LineCnt Do
  Begin
    If (Pos('>',MText[Tmp]^) in [1..5]) Then
    Inc(Quotes)
  Else
    If MText[Tmp]^<>'' Then Inc(NonQuotes);
  End;
  If (Quotes+NonQuotes=0) Then
  Begin
    Plain_Footer(2);
    SGotoXY(71-Length(LS(28)),23);
    FunkyWrite(' '+LS(28)+' ');
    CheckQuoteRatio:=False;
    CDelay(1000);
    If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
    If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
    If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
    If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
    If (Keypressed Or SKeypressed) Then GetLow;
    Display_Footer(3);
    Reposition;
   Exit;
  End;
  QuotePct:=Quotes*100/(Quotes+NonQuotes);
  S:=LeadingZero(Round(Int(QuotePct)))+'.'+StrVal(Round(Frac(QuotePct))*10)+'%';
  If (QuotePct>Config^.MaxQuotePct) And (Config^.MaxQuotePct>1) Then
  Begin
    Plain_Footer(3);
    SGotoXY(64-Length(LS(29)+LS(30)),22);
    SWrite(' ');
    FunkyWrite(LS(29)+' '+S+' '+LS(30)); SWrite(' ');
    If Config^.ForceLessQuote Then
    Begin
      SGotoXY(71-Length(LS(31)),23);
      FunkyWrite(' '+LS(31)+' ');
      CheckQuoteRatio:=False;
      CDelay(1000);
      If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
      If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
      If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
      If Not ((Keypressed) Or (SKeypressed)) Then CDelay(500);
      If (Keypressed Or SKeypressed) Then GetLow;
     End
     Else
     Begin
       SGotoXY(65-Length(LS(32)),23);
       FunkyWrite(' '+LS(32)+' (Y/n) ');
       Repeat C:=UpCase(GetLow);
         If C in [#13,#27] Then C:='Y';
       Until C in ['Y','N'];
      CheckQuoteRatio:=Not (C='Y');
     End;
   Display_Footer(3);
   Reposition;
  End
  Else
  Begin
   If User.SigPtr<>0 Then
    Begin
      Assign(SigFile,CfgPath+'OEDIT.SIG');
      FileMode:=66; Reset(SigFile); FileMode:=2;
      Seek(SigFile,User.SigPtr-1);
      Read(SigFile,Sig);
      Close(SigFile);
      If (Not ((Sig[1]='') And (Sig[2]='') And (Sig[3]='') And (Sig[4]='') And (Sig[5]='')))
      And (Config^.UseSigs) And (Not HasAddedSig) Then
      Begin
        If Not User.AutoSigs Then
        Begin
          Plain_Footer(2);
          SGotoXY(65-Length(LS(33)),23); FunkyWrite(' '+LS(33)+' (Y/n) ');
          Repeat
            C:=UpCase(GetLow);
            If C=#13 Then C:='Y';
          Until C in ['Y','N',#27];
          Display_Footer(2);
          If C=#27 Then
          Begin
            CheckQuoteRatio:=False;
            Reposition;
            Exit;
          End;
        End
        Else
        Begin
         C:='Y';
        End;
       If C='Y' Then
        Begin
         HasAddedSig:=True;
         Inc(LineCnt); MText[LineCnt]^:='';
         If Sig[1]<>'' Then Begin Inc(LineCnt); MText[LineCnt]^:=Sig[1]; End;
         If Sig[2]<>'' Then Begin Inc(LineCnt); MText[LineCnt]^:=Sig[2]; End;
         If Sig[3]<>'' Then Begin Inc(LineCnt); MText[LineCnt]^:=Sig[3]; End;
         If Sig[4]<>'' Then Begin Inc(LineCnt); MText[LineCnt]^:=Sig[4]; End;
         If Sig[5]<>'' Then Begin Inc(LineCnt); MText[LineCnt]^:=Sig[5]; End;
        End;
      End;
    End;
  End;
End;

Procedure Insert_Str(S: String);
Var
  Tmp: Byte;
Begin
  For Tmp:=1 To Length(S) Do Insert_Char(S[Tmp]);
  Cursor_NewLine;
End;

Procedure Insert_Str_No_Newline(S: String);
Var
  Tmp: Byte;
Begin
  For Tmp:=1 To Length(S) Do Insert_Char(S[Tmp]);
End;

{$IFDEF CompileExtra}
Procedure DoImport(FN: String);
Var
  F: Text;
  S: String[80];
  LineNo: Word;
  OrigLines: Word;
Begin
  If FN='' Then Exit;
  Cursor_NewLine;
  Assign(F,FN);
  FileMode:=66; {$I-} Reset(F); {$I+} FileMode:=2;
  If IOResult<>0 Then
  Begin
    Insert_Str('[Open!EDIT: File not found]');
    Exit;
  End;
  Count_Lines;
  LineNo:=0;
  SGotoXY(7,22);
  FunkyWrite(' (0000) ');
  OrigLines:=LineCnt;
  While Not Eof(F) Do
  Begin
    ReadLn(F,S); If S[0]>Chr(WWrap) Then S[0]:=Chr(WWrap);
    While Pos(#27,S)>0 Do
      Delete(S,Pos(#27,S),1);
      Insert_Line(S);
      Inc(CLine);
      Inc(LineNo);
    If LineNo Mod 15 = 0 Then
    Begin
      SGotoXY(9,22); FunkyWrite(Zero(LineNo,4));
    End;
    If LineCnt>=Max_Msg_Lines-5 Then
    Begin
      Insert_Str('[Open!EDIT: Too many lines, truncating]');
      CLine:=1; CCol:=1; TopLine:=1;
      Scroll_Screen(0);
      Close(F);
      Exit;
    End;
  End;
 Close(F);
 Plain_Footer(1);
 Redisplay;
End;

Procedure ImportFile;
Var
  FN: String[80];
Begin
  Box(60,2,True);
  SGotoXY(40-30-1+2-1,12-1);
  SWrite(PC); SWrite(' '+LS(71)+' ');
  SGotoXY(40-30-1+2-1,12-1+1);
  SWrite(NC); SWrite(LS(72));
  SGotoXY(40-30-1+2+60-18+16-Length(LS(73))-1,12-1+3);
  SWrite(PC);
  SWrite(' '+LS(73)+' ');
  SGotoXY(40-30-1+2-1,12-1+2);
  SWrite(IL); SRead(FN,60,'');
  SWrite('[0m');
  SGotoXY(1,11);
  SClrEol;
  SGotoXY(1,12);
  SClrEol;
  SGotoXY(1,13);
  SClrEol;
  SGotoXY(1,14);
  SClrEol;
  SGotoXY(1,15);
  SClrEol;
  Scroll_Screen(0);
  DoImport(FN);
End;

Procedure DoExport(FN: String);
Var
  F: Text;
  S: String[80];
  LineNo: Word;
Begin
  If FN='' Then Exit;
  Assign(F,FN);
  ReWrite(F);
  For LineNo:=1 To LineCnt Do
   WriteLn(F,MText[LineNo]^);
  Close(F);
End;

Procedure ExportFile;
Var
  FN: String[80];
Begin
  Box(60,2,True);
  SGotoXY(40-30-1+2-1,12-1);
  SWrite(PC);
  SWrite(' '+LS(74)+' ');
  SGotoXY(40-30-1+2-1,12-1+1);
  SWrite(NC); SWrite(LS(75));
  SGotoXY(40-30-1+2+60-18+16-Length(LS(73))-1,12-1+3);
  SWrite(PC);
  SWrite(LS(73));
  SGotoXY(40-30-1+2-1,12-1+2);
  SWrite(IL);
  SRead(FN,60,'');
  SWrite('[0m');
  SGotoXY(1,11);
  SClrEol;
  SGotoXY(1,12);
  SClrEol;
  SGotoXY(1,13);
  SClrEol;
  SGotoXY(1,14);
  SClrEol;
  SGotoXY(1,15);
  SClrEol;
  Scroll_Screen(0);
  DoExport(FN);
End;

Procedure Drop2DOS;
begin
  UseEmsIfAvailable := True;
  if not InitExecSwap(HeapPtr, '~SESWAP.$$$') then
    WriteLn('Unable to allocate swap space')
  else
  begin
    Plain_Footer(1);
    SGotoXY(74-Length(LS(76)),22);
    FunkyWrite(LS(76));
    SaveScreen(1);
    Window(1,1,80,25);
    TextAttr:=$07;
    ClrScr;
    sWriteLn(LS(77));
    SwapVectors;
    ExecWithSwap(GetEnv('COMSPEC'), '');
    ShutdownExecSwap;
    SwapVectors;
    RestoreScreen(1);
    Display_Footer(1);
    Reposition;
  end;
End;

Procedure ProcessStars(Var P: String);
Var
  DropMsgData: Boolean;
  MTmp: Word;
  FN,
  N: String;
  I: Byte;
  FromFirst,FromLast,
  ToFirst,ToLast,
  St: String;
  PretendSomethingsThere: Boolean;
Begin
  If Pos(' ',FromName)>0 Then FromFirst:=Copy(FromName,1,Pos(' ',FromName)-1) Else FromFirst:=FromName;
  If Pos(' ',FromName)>0 Then FromLast:=Copy(FromName,Pos(' ',FromName)+1,255) Else FromLast:='';
  If Pos(' ',ToName)>0 Then ToFirst:=Copy(ToName,1,Pos(' ',ToName)-1) Else ToFirst:=ToName;
  If Pos(' ',ToName)>0 Then ToLast:=Copy(ToName,Pos(' ',ToName)+1,255) Else ToLast:='';
  While Pos(#255,P)>0 Do P[Pos(#255,P)]:=#32;
  While Pos('*',P)>0 Do
  Begin
    PretendSomethingsThere:=False;
    I:=Pos('*',P);
    St:='';
  Case UpCase(P[I+1]) Of
     'B': Begin St:=StrVal(BaudRate); PretendSomethingsThere:=True; End;
     'F': Begin St:=NoPipe(FromFirst); PretendSomethingsThere:=True; End;
     'I': Begin St:=NoPipe(FromLast); PretendSomethingsThere:=True; End;
     'N': Begin St:=StrVal(NodeNum); PretendSomethingsThere:=True; End;
     'P': Begin St:=StrVal(ComPort); PretendSomethingsThere:=True; End;
     'S': Begin St:=NoPipe(Subject); PretendSomethingsThere:=True; End;
     'T': Begin St:=NoPipe(ToFirst); PretendSomethingsThere:=True; End;
     'O': Begin St:=NoPipe(ToLast); PretendSomethingsThere:=True; End;
  End;
  If (St<>'') Or (PretendSomethingsThere) Then
  Begin
    Delete(P,I,2);
    Insert(St,P,I);
  End
  Else
  Begin
     P[I]:=#255;
  End;
  End;
  While Pos(#255,P)>0 Do P[Pos(#255,P)]:='*';
End;

Procedure RunProg(P: String);
Var
  DropMsgData: Boolean;
  MTmp: Word;
  FN,
  N: String;
  I: Byte;
  St: String;
  F: Text;
  Ex: Boolean;
  ExportBefore: String;
  ImportAfter: Boolean;
Begin
  ExportBefore:='';
  ImportAfter:=False;
  DropMsgData:=False;
  While Pos(#255,P)>0 Do P[Pos(#255,P)]:=#32;
  ProcessStars(P);
  While Pos('*',P)>0 Do
  Begin
    I:=Pos('*',P);
    St:='';
    Ex:=False;
    Case UpCase(P[I+1]) Of
      '$': Begin
             DropMsgData:=True;
             Assign(F,'MSGDATA.TXT');
             ReWrite(F);
             For MTmp:=1 To LineCnt Do
             WriteLn(F,MText[MTmp]^);
             Close(F);
             Delete(P,I,2);
             Ex:=True;
           End;
       'X': Begin
              Delete(P,I,2);
              FN:='';
              While P[I]<>' ' Do
              Begin
                FN:=FN+P[I];
                Delete(P,I,1);
              End;
              Assign(F,FN);
              ReWrite(F);
              For MTmp:=1 To LineCnt Do
              WriteLn(F,MText[MTmp]^);
              Close(F);
              Ex:=True;
            End;
     'Y': ImportAfter:=True;
     'C': St:=GetEnv('COMSPEC');
    End;
    If St<>'' Then
    Begin
      Delete(P,I,2);
      Insert(St,P,I);
    End
    Else
    Begin
      If Not Ex Then P[I]:=#255;
    End;
  End;
  While Pos(#255,P)>0 Do P[Pos(#255,P)]:='*';
  P:=P+' ';
  N:=Copy(P,1,Pos(' ',P)-1);
  Delete(P,1,Pos(' ',P));
  If (DropMsgData) Or (ImportAfter And (ExportBefore<>'')) Then
  Begin
    If DropMsgData Then ExportBefore:='MSGDATA.TXT';
    LineCnt:=1;
    For MTmp:=1 To Max_Msg_Lines-1 Do MText[MTmp]^:='';
    Assign(F,ExportBefore);
    FileMode:=66; {$I-} Reset(F); {$I+} FileMode:=2;
    If IOResult<>0 Then Exit;
    Repeat
      ReadLn(F,MText[LineCnt]^);
      Inc(LineCnt);
    Until Eof(F);
    Close(F);
   If DropMsgData Then Erase(F);
  End;
End;

Procedure RunMacro(Num: Byte);
Var
  F: Text;
  S: String;
Begin
  Case Config^.AltF1To10[Num].CmdType Of
    0: RunProg(Config^.AltF1to10[Num].CmdData);
    1: Begin
         S:=Config^.AltF1to10[Num].CmdData;
         ProcessStars(S);
       While Pos('|',S)>0 Do
       Begin
         Insert_Str_No_Newline(Copy(S,1,Pos('|',S)-1));
         Delete(S,1,Pos('|',S));
         Cursor_Newline;
       End;
       Insert_Str_No_Newline(S);
       End;
   2: DoImport(Config^.AltF1to10[Num].CmdData);
  End;
End;
{$ENDIF}

Function Msg_Edit: Boolean;
Var
  Key: Char;
  I: Integer;
  SaveMsg,
  AbortMsg: Boolean;
  ImportMsg,
  ExportMsg: Boolean;
  A: Byte;

{$IFDEF CompileExtra}
  Procedure DoMenu;
  Var
    Hil: Byte;
    Pos1,
    Pos2,
    Pos3,
    Pos4: Byte;
    Label SkipBracket;
    Begin
      Hil:=1;
      If ForceMenu Then
      Begin
        ForceMenu:=False;
        Plain_Footer(2);
        SGotoXY(62-Length(LS(34)+LS(35)+LS(36)+LS(37)),22);
        Pos1:=WhereX; XSWrite('|BC['); FunkyWrite(LS(34));
        Pos2:=WhereX+2; XSWrite('|BC] |BC['); FunkyWrite(LS(35));
        Pos3:=WhereX+2; XSWrite('|BC] |BC['); FunkyWrite(LS(36));
        Pos4:=WhereX+2; XSWrite('|BC] |BC['); FunkyWrite(LS(37));
        XSWrite('|BC]');
        SGotoXY(49-Length(LS(80)),23);
        FunkyWrite(' '+LS(80)); XSWrite(' |BC(|PCS');
        XSWriteLn('|BC/|PCA|BC/|PCR|BC/|PCH|BC/|PCLeft|BC/|PCRight|BC)|FS: ');
      Repeat
        InputFunky:=True;
        Case Hil Of
        1: Begin
             SGotoXY(Pos1,22);
             XSWrite('|IS[');
             FunkyWrite(LS(34));
             XSWrite('|IS]');
           End;
       2: Begin
            SGotoXY(Pos2,22);
            XSWrite('|IS[');
            FunkyWrite(LS(35));
            XSWrite('|IS]');
          End;
       3: Begin
            SGotoXY(Pos3,22);
            XSWrite('|IS[');
            FunkyWrite(LS(36));
            XSWrite('|IS]');
          End;
       4: Begin
            SGotoXY(Pos4,22);
            XSWrite('|IS[');
            FunkyWrite(LS(37));
            XSWrite('|IS]');
          End;
          End;
          Key:=UpCase(Get_Key);
          Case Hil Of
           1: Begin SGotoXY(Pos1,22); XSWrite('|BC['); FunkyWrite(LS(34)); XSWrite('|BC]'); End;
           2: Begin SGotoXY(Pos2,22); XSWrite('|BC['); FunkyWrite(LS(35)); XSWrite('|BC]'); End;
           3: Begin SGotoXY(Pos3,22); XSWrite('|BC['); FunkyWrite(LS(36)); XSWrite('|BC]'); End;
           4: Begin SGotoXY(Pos4,22); XSWrite('|BC['); FunkyWrite(LS(37)); XSWrite('|BC]'); End;
          End;
     Case Key Of
       #00: Case Get_Key Of
              'K': If Hil<>1 Then Dec(Hil);
              'M': If Hil<>4 Then Inc(Hil);
             End;
       '4': If Hil<>1 Then Dec(Hil);
       '6': If Hil<>4 Then Inc(Hil);
       #27: Begin
             If Not (SKeypressed Or Keypressed) Then KeyDelay(250);
             If Not (SKeypressed Or Keypressed) Then Key:='R';
             If (SKeypressed Or Keypressed) Then
              Begin
               SkipBracket:
               Case Get_Key Of
                 '[': Goto SkipBracket;
                 'C': If Hil<>4 Then Inc(Hil);
                 'D': If Hil<>1 Then Dec(Hil);
                End;
              End;
            End;
       #13: Case Hil Of
              1: Key:='S';
              2: Key:='A';
              3: Key:='R';
              4: Key:='H';
              5: Key:='I';
              6: Key:='E';
             End;
      End;
    Until Key in ['A','S','R','Q','I','E'];
    If Key='A' Then AbortMsg:=True;
    If Key='S' Then SaveMsg:=True;
    If Key='I' Then ImportMsg:=True;
    If Key='E' Then ExportMsg:=True;
    If Key='R' Then Key:=#0;
    If Key='Q' Then QuoteWindow;
    If Key<>'S' Then
     Begin
      Display_Footer(3);
      Reposition;
     End;
   End
   Else
   Begin
    SaveMsg:=True;
   End;
  End;
{$ELSE}
  Procedure DoMenu; Begin End;
{$ENDIF}
  Procedure CleanUp;
  Var
    I: Byte;
  Begin
    SGotoXY(1,7);
    For I:=1 to ScrLines Do                   { Physical lines are now invalid }
    Begin
      PhyLine^[I]:='';
      SWriteLn('');
      SClrEol;
    End;
    Scroll_Screen(0);                                       { Causes redisplay }
    Display_Footer(3);
    Reposition;
  End;

Var
  OIM: Boolean;
Begin
  Display_Header;
  Display_Footer(3);
  StatusBar;
  SaveMsg:=False; AbortMsg:=False; ImportMsg:=False; ExportMsg:=False;
  If Not ReEditing Then
  Begin
    CLine:=LineCnt; CCol:=CurLength+1;
    If Replying Then
    Begin
      CLine:=1;
      CCol:=1;
    End;
    TopLine := 1; While (CLine-TopLine)>(Config^.ScrollSiz+3) Do Inc(TopLine,Config^.ScrollSiz);
  End;
  Prepare_Screen;
  Repeat
    OKUpdateFooter:=True;
    Key:=Get_Key;
    OKUpdateFooter:=False;
    If (Key=#0) Then
    Begin
      Key:=Get_Key;
      Case Key Of
      ';': If LocalKeypress Then {F1}
           Begin
             Inc(StatBar);
             StatusBar;
             Continue;
           End;
{$IFDEF CompileExtra}
      '<': If (LocalKeypress) And (Not Expired) Then Begin ExportFile; Continue; End;
      '=': If (LocalKeypress) And (Not Expired) Then Begin ImportFile; Cleanup; Continue; End;
      '>': If (LocalKeypress) And (Not Expired) Then Begin ForceExit; Continue; End;
{$ENDIF}
      '?': If (LocalKeypress) And (Not Expired) Then
           Begin
             Sound(500); Delay(20); Sound(1000); Delay(20); Sound(500); Delay(20); NoSound;
             Remote_Screen(^G);
             Continue;
           End;
      '@': If (LocalKeypress) And (Not Expired) Then Begin HangUpUser; Continue; End;
      'A': If (LocalKeypress) And (Not Expired) Then Begin TimeLeft:=TimeLeft+(5*60); Continue; End;
      'B': If (LocalKeypress) And (Not Expired) Then Begin TimeLeft:=TimeLeft-(5*60); Continue; End;
{$IFDEF CompileExtra}
      'C': If (LocalKeypress) And (Not Expired) Then
           Begin
             SGotoXY(8,22); FunkyWrite(' '+LS(103)+' ');
             EditUser;
             Display_Footer(1);
             Continue;
           End;
      'D': If (LocalKeypress) And (Not Expired) Then
           Begin
             Drop2DOS;
             Continue;
           End;
      'h'..'q': If (LocalKeypress) And (Not Expired) Then
                Begin
                  RunMacro(Ord(Key)-Ord('h')+1);
                  Continue;
                End;
{$ENDIF}
      'G': Key:=^L; { Home }
      'H': Key:=^E; { UpArrow }
      'I': Key:=^R; { PgUp }
      'K': Key:=^S; { LeftArrow }
      'M': Key:=^D; { RightArrow }
      'O': Key:=^P; { End }
      'P': Key:=^X; { DownArrow }
      'Q': Key:=^C; { PgDn }
      'R': Key:=^V; { Ins }
      'S': Key:=^G; { Del }
      's': Key:=^A; { Ctrl-Left }
      't': Key:=^F; { Ctlr-Right }
      Else
        Key := #0;
      End;
    End;
  { Translate VT102 / ANSI-BBS keyboard into WordStar keys }
  If (Key=#27) Then
  Begin
    If Not (SKeypressed Or Keypressed) Then
    Begin
      KeyDelay(250);
      If Not (SKeypressed Or Keypressed) Then Key:=#27 Else Key:=Get_Key;
    End
    Else
      Key:=Get_Key;
      If Key='[' Then Key:=Get_Key;
      If Key='O' Then Key:=Get_Key;
      Case Key Of
      'A': Key:=^E;  { UpArrow }
      'B': Key:=^X;  { DownArrow }
      'C': Key:=^D;  { RightArrow }
      'D': Key:=^S;  { LeftArrow }
      'H': Key:=^L;  { Home }
      'K',           { End - PROCOMM+ }
      'R': Key:=^P;  { End - GT }
      'r': Key:=^R;  { PgUp }
      'q': Key:=^C;  { PgDn }
      'n': Key:=^V;  { Ins }
      #00: key:=#27; { Timeout - escape key }
      #27: Begin key:=^Z; ForceMenu:=True; End;
     End;
   End;
  {process each character typed}
  Case Key Of
    ^A: Cursor_WordLeft;
    ^B: Msg_Reformat;
    ^C: Page_Down;
    ^D: Cursor_Right;
    ^E: Cursor_Up;
    ^F: Cursor_WordRight;
    ^G,#$7F: Delete_Char;
    ^H: Begin Cursor_Left; If Insert_Mode Then Delete_Char; End;
    ^I: Cursor_Tab;
    ^J: Join_Lines;
    ^K: {$IFDEF CompileExtra} If (Not Expired) Then UserConfig {$ENDIF} ;
    ^L: Cursor_BegLine;
    ^M: Begin
         OIM:=Insert_Mode; Insert_Mode:=True;
         LastWasCR:=True;
         {$IFDEF CompileExtra} If (Not Expired) THen Expand; {$ENDIF}
         Insert_Mode:=OIM;
         Cursor_NewLine;
        End;
    ^N: Begin
          Split_Line;
          Reposition;
        End;
    ^O: Redisplay;
    ^P: Cursor_EndLine;
    ^Q: QuoteWindow;
    ^R: Page_Up;
    ^S: Cursor_Left;
    ^T: Delete_Wordright;
    ^V: Begin Insert_Mode:=Not Insert_Mode; Display_Footer(1); Reposition; End;
    ^W: QuoteWindow;
    ^X: Cursor_Down(False);
    ^Y: Msg_Delete_Line;
    ^Z: DoMenu;
    ^]: If Not Expired THen
        Case Config^.ExtendedChars Of
           0: ;
           1: Begin
                Key:=Get_Key;
                If Not (Key in [#0,#7,#8,#9,#10,#13,#19,#25]) Then Insert_Char(Key);
                LastWasCR:=False;
              End;
           2: Begin
               Insert_Char(^A);
               LastWasCR:=False;
              End;
          End;
   #32.. #255: Begin
                 Insert_Char(Key); { All other characters are self-inserting }
                 LastWasCR:=False;
                 {$IFDEF CompileExtra}
                 If Not (Key in ['0'..'9','A'..'Z','a'..'z']) Then Expand;
                 {$ENDIF}
               End;
   End;
If ((MText[CLine]^[1]='/') And (UpCase(MText[CLine]^[2]) in ['A','S','Q','C','I','E']) And (CCol=3)) And (Not Expired)
Then
   Begin
    Case UpCase(MText[CLine]^[2]) Of { 'S' or 'A' + 1 }
      'Q': Begin
             Msg_Delete_Line;
             QuoteWindow;
           End;
      'C': Begin
             Msg_Delete_Line;
             UserConfig;
            End;
      'I': If TurboCOM.Security>=Config^.ImportSecurity Then
           Begin
             ImportFile;
             Cleanup;
             Msg_Delete_Line;
           End;
      'E': If TurboCOM.Security>=Config^.ExportSecurity Then
           begin
             ExportFile;
             Msg_Delete_Line;
           end;
      'A': Begin
             If ConfirmAbort Then
             AbortMsg:=True
             Else
             Begin
             Msg_Delete_Line;
             End;
           End;
      'S': Begin
             SaveMsg:=True;
             Msg_Delete_Line;
           End;
     End;
   End;
  If SaveMsg Then
  Begin
    Count_Lines;
    If (Force) And (LineCnt<ForceLines) Then
    Begin
      MinLinesNotMet;
      SaveMsg:=False;
    End
    Else
    SaveMsg:=(CheckQuoteRatio And SpellCheck);
    End;
    If (AbortMsg) And (Force) Then Begin AbortDisabled; AbortMsg:=False; End;
  Until (SaveMsg) Or (AbortMsg);
  If SaveMsg Then
  Begin
    Msg_Edit:=True;
  End
  Else
  Begin
    SGotoXY(8,22);
    FunkyWrite(' '+Pad(LS(38),19)+' ');
    Msg_Edit:=False;
    CDelay(1000);
    SGotoXY(1,24);
  End;
End;

{$F+}Procedure HookedExit;{$F-}
Var
  n: Integer;
  EE: Word;
Begin
  If ErrorAddr=Nil Then
  Begin
    If FileExists(CfgPath+'MATCHES.$%$') Then Begin Assign(QFile,CfgPath+'MATCHES.$%$'); Erase(QFile); End;
    If FileExists(SysPath+'OEDIT.QUO') Then Begin Assign(QFile,SysPath+'OEDIT.QUO'); Erase(QFile); End;
    If FileExists(CfgPath+'$OEDITMP.$~$') Then Begin Assign(QFile,CfgPath+'$OEDITMP.$~$'); Erase(QFile); End;
  End;
  For n:=1 to Max_Msg_Lines Do
  Dispose(MText[n]);
  Dispose(PhyLine);
  Dispose(Config);

{$IFDEF CompileExtra}
  For EE:=1 To ExtraExpands Do
  Begin
    Dispose(ExtraExpand[EE,1]);
    Dispose(ExtraExpand[EE,2]);
  End;
  For EE:=1 To 8 Do
  Begin
    Dispose(EStr[EE,1]);
    Dispose(EStr[EE,2]);
  End;
{$ENDIF}
  If MemLang Then Dispose(Lang); MemLang:=False;
  ExitProc:=ExitSave;
End;

Procedure LoadExtraExpands;
Var
  F: Text;
  S: String[100];
Begin
{$IFDEF CompileExtra}
  ExtraExpands:=0;
  Assign(F,CfgPath+'EXPAND.CTL');
  FileMode:=66;
  {$I-}Reset(F);{$I+}
  FileMode:=2;
  While Not Eof(F) Do
  Begin
    ReadLn(F,S); Delete(S,Pos(';',S),255); S:=RTrim(LTrim(S));
    If (S='') Then Continue;
    If Pos(' ',S)=0 Then Continue;
    Inc(ExtraExpands);
    New(ExtraExpand[ExtraExpands,1]); ExtraExpand[ExtraExpands,1]^:=UCase(Copy(S,1,Pos(' ',S)-1));
    Delete(S,1,Pos(' ',S));
    New(ExtraExpand[ExtraExpands,2]); ExtraExpand[ExtraExpands,2]^:=S;
   End;
  Close(F);
 {$ENDIF}
End;

Var
  OKHeadFoot: Boolean;
  Subval: BYte;
Begin
  OKHeadFoot:=True;
  Danger:=0;
  MemLang:=False;
  Randomize;
  If MaxAvail<Sizeof(ConfigRec)+256+SizeOf(PhysType) Then
  Begin
    WriteLn('Insufficient heap space for minimum required elements');
    WriteLn;
    WriteLn('Memory available: ',MaxAvail,' bytes');
    WriteLn('Minimum required: ',SizeOf(ConfigRec)+256+SizeOf(PhysType),' bytes');
    WriteLn;
    Halt(2);
  End;
  Ver[0]:=#5;
  New(Config);
 { -------------- Configuration block -------------- }
 { * Check for a OEDIT environment variable          }
  CfgPath:=GetEnv('OEDIT');
  If CfgPath[Length(CfgPath)]<>'\' Then CfgPath:=CfgPath+'\';
  CfgPath:=RemoveWildCard(ParamStr(0));
  Assign(ConfigFile,CfgPath+'OEDIT.CFG');
  FileMode:=66;
  {$I-}Reset(ConfigFile);{$I+}
  FileMode:=2;
  { * Check in current directory                      }
  If IOResult<>0 Then
  Begin
    CfgPath:='';
    Assign(ConfigFile,CfgPath+'OEDIT.CFG');
    FileMode:=66;
    {$I-}Reset(ConfigFile);{$I+}
    FileMode:=2;
  End;
 { * Check in execution path                         }
  If IOResult<>0 Then
  Begin
    CfgPath:=RemoveWildCard(ParamStr(0));
    Assign(ConfigFile,CfgPath+'OEDIT.CFG');
    FileMode:=66;
    {$I-}Reset(ConfigFile);{$I+}
    FileMode:=2;
  End;
  { * Can't find the damned thing                     }
  If IOResult<>0 Then
  Begin
   {$IFDEF CompileExtra}
   TextAttr:=$01;
   WriteLn('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
   WriteLn('³'+Pad('',72)+'³');
   Write('³  ');
   TextAttr:=$0B;
   Write(Pad('Open!EDIT v'+Ver,70));
   TextAttr:=$01; WriteLn('³');
   Write('³  ');
   TextAttr:=$0B;
   Write(Pad('Config file error',70));
   TextAttr:=$01;
   WriteLn('³');
   WriteLn('³'+Pad('',72)+'³');
   TextAttr:=$01;
   Write('³   ');
   TextAttr:=$09;
   Write('þ ');
   TextAttr:=$0F; Write('Open!EDIT cannot locate ' + Pad('OEDIT.CFG',43));
   TextAttr:=$01;
   WriteLn('³');
   Write('³   ');
   TextAttr:=$09;
   Write('þ ');
   TextAttr:=$0F;
   Write('Please run OESetup.EXE to create this configuration file');
   TextAttr:=$01;
   WriteLn('           ³');
   WriteLn('³'+Pad('',72)+'³');
   WriteLn('³ÄÄÄÄÄÄÄ                                                                 ³');
   Write('³ '); TextAttr:=$09; Write('STS97'); TextAttr:=$01;
   WriteLn(' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
   WriteLn('ÀÄÄÄÄÄÄÄÙ');
   {$ENDIF}
   Halt(2);
   End;
  Read(ConfigFile,Config^);
  (*ConfigDecrypt;*)
  Close(ConfigFile);

  If Config^.LanguageFile='' Then Config^.LanguageFile:='ENGLISH';
  If Not FileExists(CfgPath+Config^.LanguageFile+'.LNG') Then
  Begin
    WriteLn('Cannot open language file '+Config^.LanguageFile+'.LNG');
    Halt(2);
  End;
  LanguageFile:=Config^.LanguageFile;
  WWrap:=Config^.WrapMargin;
  MsgTxtFile:='';
  For PCnt:=1 To ParamCount Do
  Begin
    If (UCase(Copy(ParamStr(PCnt),1,2))='-T') Or (UCase(Copy(ParamStr(PCnt),1,2))='/T') Then
    MsgTxtFile:=Copy(ParamStr(PCnt),3,255);
    If (UCase(Copy(ParamStr(PCnt),1,2))='-M') Or (UCase(Copy(ParamStr(PCnt),1,2))='/M') Then
    Begin
      MailReader:=True;
      MsgTxtFile:=Copy(ParamStr(PCnt),3,255);
    End;
   If (UCase(Copy(ParamStr(PCnt),1,2))='-F') Or (UCase(Copy(ParamStr(PCnt),1,2))='/F') Then
   Begin
     Force:=True;
     ForceLines:=IntVal(Copy(ParamStr(PCnt),3,255));
    End;
  End;

  If Config^.QuoteWinSize<2 Then Config^.QuoteWinSize:=5;
  SingleLineStat:=True;
  Detailed:=True;
  HelpScrPrgName:='Open!EDIT';
  LastAutoSave:=Timer;
  If MailReader Then
  Begin
    Assign(MsgTmp,CfgPath+'LOCAL.DEF');
    FileMode:=66; {$I-} Reset(MsgTmp); {$I+} FileMode:=2;
  If IOResult<>0 THen
  Begin
     WriteLn('Please run OESetup and configure local mode defaults.');
     Halt(2);
  End;
  ReadLn(MsgTmp,BBSName);
  ReadLn(MsgTmp,SysOpName);
  SysOpFirst:=Copy(SysOpName,1,Pos(' ',SysOpName)-1);
  SysOpLast:=Copy(SysOpName,Pos(' ',SysOpName)+1,255);
  ReadLn(MsgTmp,UserName);
  UserFirst:=Copy(UserName,1,Pos(' ',UserName)-1);
  UserLast:=Copy(UserName,Pos(' ',UserName)+1,255);
  ReadLn(MsgTmp,UserLocation);
  ReadLn(MsgTmp,TurboCOM.Security);
  ReadLn(MsgTmp,Tmp);
  If Tmp[1] In ['1','3'] Then ANSI:=True Else ANSI:=False; ReadLn(MsgTmp,Tmp); Close(MsgTmp);
  Assign(MsgTmp,'DORINFO1.DEF');
  ReWrite(MsgTmp);
  WriteLn(MsgTmp,BBSName);
  WriteLn(MsgTmp,SysOpFirst);
  WriteLn(MsgTmp,SysOpLast);
  WriteLn(MsgTmp,'COM0');
  WriteLn(MsgTmp,'0 BAUD,N,8,1');
  WriteLn(MsgTmp,'1');
  WriteLn(MsgTmp,UserFirst);
  WriteLn(MsgTmp,UserLast);
  WriteLn(MsgTmp,UserLocation);
  If ANSI Then WriteLn(MsgTmp,'1') Else WriteLn(MsgTmp,'2');
  WriteLn(MsgTmp,TurboCOM.Security);
  WriteLn(MsgTmp,Tmp);
  Close(MsgTmp);
  End;

  ExitCode:=2;
  InitTurboCOMM;
 {$IFDEF CompileExtra}
  HookErrorHandler:=True;
 {$ENDIF}
  LimitExceeded:='[23;7H[0;1;31m '+LS(81)+' '+^G;
  ProhibitStatus:=True;
  ProgName:='Open!EDIT v'+Ver;
  UpdateStatus(True);
  ForceMenu:=False;
  LocalANSIKeys:=True;
  StatusBar;
  If Config^.TimeOutDelay=0 Then TimeCheck:=False;
  TimeOutDelay:=Config^.TimeoutDelay;

 If MsgTxtFile='' Then MsgTxtFile:=SysPath+'MSGTMP.';
 Window(1,1,80,25);
 ClrScr;
{$IFDEF CompileExtra}
 Case Config^.BBSProg Of
   bbs_CC: LoadCCInfo;
   bbs_RA: LoadRAInfo;
   bbs_QK: LoadQKInfo;
{   bbs_EZ: LoadEZInfo;}
  End;
{$ENDIF}

{$IFDEF CompileExtra}
 If FileExists(CfgPath+'OEDIT.REG') Then
   DecryptKey:=Decode(UCase(Config^.RegName),Config^.DataUEC,CfgPath+'OEDIT.REG')
  Else
  Begin
    DecryptKey:=StrUnreg;
  End;
{$ELSE}
   DecryptKey:=SysOpName;
{$ENDIF}
  DecryptKey:=Capitalize(DecryptKey);
  SysOpName:=RTrim(LTrim(Capitalize(Config^.RegName)));
  If SysOpName='' Then SysOpName:='[unknown]';
  If SysPath='' Then GetDir(0,SysPath);
  If SysPath[Length(SysPath)]<>'\' Then SysPath:=SysPath+'\';
  Case Config^.BBSProg Of
    bbs_CC: MSGINF:='MSGINF.';
    bbs_RA: MSGINF:='MSGINF.';
    bbs_EZ: MSGINF:='MSGINF.';
    bbs_QK: MSGINF:='MSG.INF';
  else    MSGINF:='MSGINF.';
  End;
  If (Not FileExists(SysPath+MSGINF)) And (Not MailReader) Then
  Begin
    If LocalTest THen
    Begin
      Assign(F,SysPath+MSGINF);
      ReWrite(F);
    Case Config^.BBSprog Of
       bbs_QK: Begin
                 WriteLn(F,UserName);
                 WriteLn(F,UserName);
                 WriteLn(F,'Open!EDIT local test mode');
                 WriteLn(F,'Open!EDIT Test Area');
                 WriteLn(F,'Private');
               End;
       Else    Begin
                 WriteLn(F,UserName);
                 WriteLn(F,UserName);
                 WriteLn(F,'Open!EDIT local test mode');
                 WriteLn(F,'1');
                 WriteLn(F,'Open!EDIT Test Area');
                 WriteLn(F,'Y');
               End;
      End;
     Close(F);
    End
    Else
    Begin
     {$IFDEF CompileExtra}
      TextAttr:=$01;
      WriteLn('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
      WriteLn('³'+Pad('',72)+'³');
      Write('³  '); TextAttr:=$0B; Write(Pad('Open!EDIT v'+Ver,70)); TextAttr:=$01; WriteLn('³');
      Write('³  '); TextAttr:=$0B; Write(Pad('Datafile error',70)); TextAttr:=$01; WriteLn('³');
      WriteLn('³'+Pad('',72)+'³');
      TextAttr:=$01;
      Write('³   '); TextAttr:=$09; Write('þ '); TextAttr:=$0F; Write('Open!EDIT cannot locate the datafile '+
      Pad(SysPath+MSGINF,30));
      TextAttr:=$01; WriteLn('³');
      Write('³   '); TextAttr:=$09; Write('þ '); TextAttr:=$0F;
      Write('Please use the -P<path_to_bbs> parameter to fix this problem');
      TextAttr:=$01; WriteLn('       ³');
      Write('³     '); TextAttr:=$0F; Write(Pad('i.e. OEDIT -PC:\BBS',67)); TextAttr:=$01; WriteLn('³');
      WriteLn('³'+Pad('',72)+'³');
      WriteLn('³ÄÄÄÄÄÄÄ                                                                 ³');
      Write('³ '); TextAttr:=$09; Write('STS97'); TextAttr:=$01;
      WriteLn(' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      WriteLn('ÀÄÄÄÄÄÄÄÙ');
     {$ENDIF}
      Halt(2);
    End;
  End;
{$IFDEF CompileExtra}
  NC:=ANSICode[Config^.NC];
  HC:=ANSICode[Config^.HC];
  BC:=ANSICode[Config^.BC];
  PC:=ANSICode[Config^.PC];
  FZ:=ANSICode[Config^.FZ];
  FC:=ANSICode[Config^.FC];
  FL:=ANSICode[Config^.FL];
  FS:=ANSICode[Config^.FS];
  FD:=ANSICode[Config^.FD];
  IC:=ANSICode[Config^.IC]+ANSICode[40+Config^.FieldColor];
  ID:=ANSICode[Config^.ID]+ANSICode[40+Config^.FieldColor];
  IL:=ANSICode[Config^.IL]+ANSICode[40+Config^.FieldColor];
  IS:=ANSICode[Config^.IS]+ANSICode[40+Config^.FieldColor];
{$ENDIF}
  YN[False]:='|IC N|ILo  [0m';
  YN[True ]:='|IC Y|ILes [0m';
  LoadUser;
  NC:=ANSICode[User.NC];
  HC:=ANSICode[User.HC];
  BC:=ANSICode[User.BC];
  PC:=ANSICode[User.PC];
  FZ:=ANSICode[User.FZ];
  FC:=ANSICode[User.NC];
  FL:=ANSICode[User.FL];
  FS:=ANSICode[User.FS];
  FD:=ANSICode[User.FD];
  IC:=ANSICode[User.IC]+ANSICode[40+User.FieldColor];
  ID:=ANSICode[User.ID]+ANSICode[40+User.FieldColor];
  IL:=ANSICode[User.IL]+ANSICode[40+User.FieldColor];
  IS:=ANSICode[User.IS]+ANSICode[40+User.FieldColor];
  ExtraExpands:=0;
  LoadExtraExpands;
  SClrScr;
  StatusBar;
{$IFDEF CompileExtra}
  SelectLanguage;
{$ENDIF}
  If MailReader Then
  Begin
    AreaName:='Offline Mail Reader';
    FromName:=Capitalize(UserFirst+' '+UserLast);
    ToName:='Recipient';
    MNum:=0;
    Subject:='Open!EDIT Offline Mail';
    Replying:=True;
   End
   Else
   Begin
    AreaName:='';
    FromName:=Capitalize(UserFirst+' '+UserLast); ToName:='';
    MNum:=0; Subject:=''; Replying:=False;
    Assign(F,SysPath+MSGINF);
    FileMode:=66; Reset(F); FileMode:=2;
    Case Config^.BBSProg Of
    bbs_QK: Begin
              MNum:=0;
              ReadLn(F,FromName); FromName:=Capitalize(FromName);
              ReadLn(F,ToName);   ToInitials:=Initials(ToName); ToName:=Capitalize(ToName);
              ReadLn(F,Subject);
              ReadLn(F,AreaName);
            {$IFDEF CompileExtra}
              MsgAreaPos:=GetAreaFPos(AreaName);
            {$ELSE}
              MsgAreaPos:=0;
            {$ENDIF}
              ReadLn(F,Tmp);
              PrivMsg:=(UCase(Tmp[2])='R');
            End;
     Else    Begin
               ReadLn(F,FromName); FromName:=Capitalize(FromName);
               ReadLn(F,ToName);   ToInitials:=Initials(ToName); ToName:=Capitalize(ToName);
               ReadLn(F,Subject);
               ReadLn(F,MNum);
               ReadLn(F,AreaName);
             {$IFDEF CompileExtra}
               MsgAreaPos:=GetAreaFPos(AreaName);
            {$ELSE}
               MsgAreaPos:=0;
            {$ENDIF}
               ReadLn(F,Tmp);
               PrivMsg:=(Tmp[1]='Y');
             End;
    End;
   Close(f);
  End;
  Str(MNum,MsgNum);
   If (MsgAreaPOS<>-1) then
   begin
{     Config^.UseTaglines:=Config^.OKTagArea[MsgAreaPos]; }
     Config^.UseExpand:=Config^.OKExpandArea[MsgAreaPos];
     Config^.UseKeywords:=Config^.OKKeywordArea[MsgAreaPos];
     Config^.Censor:=Config^.OKCensorArea[MsgAreaPos];
     Config^.UseSigs:=Config^.OKSigArea[MsgAreaPos];
     Config^.UseFilter:=Config^.FilterArea[MsgAreaPos];
   End;
{$IFDEF CompileExtra}
  For MNum:=1 To 8 Do
  Begin
    New(EStr[MNum,1]);
    New(EStr[MNum,2]);
  End;
  EStr[1,1]^:='@DATE@';  EStr[1,2]^:=Copy(UnpackedDT(CurrentDT),1,8);
  EStr[2,1]^:='@TIME@';  EStr[2,2]^:=Copy(UnpackedDT(CurrentDT),10,8);
  EStr[3,1]^:='@SYSOP@'; EStr[3,2]^:=SysOpName;
  EStr[4,1]^:='@BBS@';   EStr[4,2]^:=BBSName;
  EStr[5,1]^:='@TO@';    EStr[5,2]^:=ToName;
  EStr[6,1]^:='@RE@';    EStr[6,2]^:=Subject;
  EStr[7,1]^:='@VER@';   EStr[7,2]^:=Ver;
  EStr[8,1]^:='@FROM@';  EStr[8,2]^:=UserName;
{$ENDIF}
{---Shawn: Taglines starting here}
  If (Pos('\',Config^.TagFileName)=0) And (Config^.UseTaglines) Then
  Begin
    If (Config^.TagFileName='') Then
    TagError
    Else
    Begin
      Tmp:=FExpand(ParamStr(0));
      While Tmp[Length(Tmp)]<>'\' Do Delete(Tmp,Length(Tmp),1);
      Config^.TagFileName:=Tmp+Config^.TagFileName;
    End;
    If Not FileExists(Config^.TagFileName) Then TagError;
  End;
  CheckUserOK;
  New(PhyLine);
  Max_Msg_Lines:=((MaxAvail div 3)*2) div SizeOf(Str81);
  If Max_Msg_Lines>Config^.AbsMaxMsgLines Then Max_Msg_Lines:=Config^.AbsMaxMsgLines; Dec(Max_Msg_Lines);
  If Max_Msg_Lines>InternalLineLim Then Max_Msg_Lines:=InternalLineLim;
{$IFDEF CompileExtra}
  If Config^.AbsMaxMsgLines<50 Then
  Begin
    ClrScr;
    WriteLn('Insufficient number of available message text lines to load Open!EDIT');
    WriteLn;
    WriteLn('Minimum required lines : 50 lines');
    WriteLn('Lines allocated        : ',Config^.AbsMaxMsgLines,' lines');
    WriteLn;
    WriteLn('Use OESetup to increase this number');
    WriteLn;
    CDelay(4000);
    If FileExists(MsgTxtFile) Then
    Begin
      Assign(F,MsgTxtFile);
      Erase(F);
    End;
    Halt(2);
   End;
  If Max_Msg_Lines<30 Then
  Begin
    ClrScr;
    WriteLn('Insufficient memory to allocate message buffer');
    WriteLn;
    WriteLn('Memory available       : ',MaxAvail,' bytes');
    WriteLn('Maximum lines available: ',Max_Msg_Lines,' message lines');
    WriteLn('Minimum lines required : ',50,' message lines');
    WriteLn('Minimum memory required: ',50*SizeOf(Str81)+1024,' bytes');
    WriteLn('Additional mem required: ',(50*SizeOf(Str81))-(50*Max_Msg_Lines)+1024,' bytes');
    WriteLn;
    CDelay(4000);
    If FileExists(MsgTxtFile) Then
    Begin
      Assign(F,MsgTxtFile);
      Erase(F);
    End;
    Halt(2);
  End;
{$ENDIF}
  For N:=1 To Max_Msg_Lines Do
  Begin
    New(MText[n]);
    MText[n]^:='';
  End;
  MText[Max_Msg_Lines]^:=MakeStr(72,'-')+'-[max]-';
  ExitSave:=ExitProc;
  ExitProc:=@HookedExit;
  For N:=0 To 9 Do User.Expand[N,1]:=UCase(User.Expand[N,1]);
  If MaxAvail>LangCnt*76 Then
  Begin
    MemLang:=True;
    New(Lang);
    LoadS;
  End;
  N:=0;
  QuoteLineNum:=0;
  QuoteLineCnt:=0;
  QuoteHil:=0;
  If FileExists(MsgTxtFile) Then
  Begin
    FixChainsaw;
    Replying:=True;
    LoadQuoteData;
  End;
  Config^.TabStop:=8;
  CheckHeaderSize;
  If (SysOpName=SysopName) Then
  Begin
    If Replying Then
    Begin
      If Config^.ForceCtlW Then
      QuoteOrMenu:=' <^W> '+LS(82)+' '
    Else
    QuoteOrMenu:=' <^Q> '+LS(82)+' ';
End
   Else
    QuoteOrMenu:=' <^K> '+LS(83)+' '
  End
  Else
  Begin
  If Replying Then
  Begin
    If Config^.ForceCtlW Then
    QuoteOrMenu:=' <^W> '+LS(82)+' '
  Else
    QuoteOrMenu:=' <^Q> '+LS(82)+' ';
  End
  Else
   QuoteOrMenu:=' <^U> '+LS(84)+' '
 End;
  ReEditing:=False;
  ReMsgEdit:
  Count_Lines;
  If Not Msg_Edit Then
   Begin
     FancyClear;
     Assign(F,SysPath+'AUTOSAVE.SE!');
     {$I-}Erase(F);{$I+}
     If IOResult<>0 Then ;
     WriteLn('Message aborted');
     Halt(1);
   End;
  Count_Lines;
  Randomize;
  If Config^.Censor Then For A:=1 To LineCnt Do MText[a]^:=Censor(MText[a]^);
  If Config^.UseFilter Then FilterText;
  ReEditing:=False;
  Inc(LineCnt); MText[LineCnt]^:='';
  {$IFDEF CompileExtra}
  WasTag:=TagLine;
  {$ELSE}
  WasTag:=True;
  {$ENDIF}
  If ReEditing Then Goto ReMsgEdit;
  If (Config^.TearLine=2) Then
  Begin
    Inc(LineCnt);
    MText[LineCnt]^:='-*- Open!EDIT v' +Ver;
    MText[LineCnt]^:=MText[LineCnt]^+'+';
  End;
 If LineCnt<>0 Then
 Begin
   Count_Lines;
   Assign(F,MsgTxtFile);
   ReWrite(F);

   If (Config^.TearLine=2) Then SubVal:=1 Else SubVal:=0;
   If WasTag Then Inc(SubVal);
   For A:=1 To LineCnt-SubVal Do WriteLn(F,MText[A]^);

   For A:=LineCnt-SubVal+1 To LineCnt Do WriteLn(F,MText[A]^);
   If Config^.BBSProg=bbs_RA Then
   Begin
     WriteLn(F,StrVal(Round(Config^.DataUEC*263/120)));
   End;
   Close(F);
  End;
  CDelay(1000); {1000}
  FancyClear;
  WriteLn('Message saved');
  Assign(F,SysPath+'AUTOSAVE.SE!');
  {$I-}Erase(F);{$I+}
  If IOResult<>0 Then ;
  Halt(0);
End.
