|NCÚ|HCÄÄ|PCÄÄ|BCÄÄ|PC[@F@@TIME@@/F@|PC]|BC@TPÄ@Ä|PC[@F@@LEFT@ Mins@/F@|PC]|BCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|PCÄÄ|HCÄ¿
|HCÀÄ|PCÄÄ|BCÄÄ @f@CheepEDIT v@VER@@/F@ |BCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ|PCÄÄ|HCÄÄ|NCÙ@CT:09,22@@UT:18,22@
%
; CheepEDIT Header Control File
; Copyright (c) 2010, By Shawn Highfield
;
; Any line after line #2 is ignored.
; The footer differs from the header in that footer text MUST be contained
; on lines 1 and 2 of this file.  No comments may preceed the footer text.
;
; Please note that the  footer is used to display a wide variety of infor-
; mation in TurboEDIT.  For this  reason,  it is advised  that you  do not
; drastically change the layout of the footer -- i.e., do not display text
; where there is none by default.
;
; Control Code                                                      Returns
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; @TIME@                                            The current time of day
; @LEFT@                       The number of minutes the user has remaining
; @VER@                                The current CheepEDIT version number
; @F@                                  Turn on case-sensitive text coloring
; @/F@                                Turn off case-sensitive text coloring
; @TP<char>@                              Pads out 24-hour time (see below)
; @CT:xx,yy@      Sets the screen location for the current time (see below)
; @UT:xx,yy@  Sets the screen location for the user's time left (see below)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; |NC                                                         Frame Color 1
; |HC                                                         Frame Color 2
; |PC                                                         Frame Color 3
; |BC                                                         Frame Color 4
; |FZ                                                          "Fade" color
; |FC                                                  Capital Letter Color
; |FL                                                Lowercase Letter Color
; |FS                                                          Symbol Color
; |FD                                                           Digit Color
; |IC                                   Capital Letter Color (Input fields)
; |IL                                 Lowercase Letter Color (Input fields)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; 24 Hour Time Padding (@TP<char>@)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; The 24 hour time format (HH:MM) is one character shorter than the 12 hour
; time format (HH:MMa).  Due to  this length difference,  many footers will
; be misaligned if the SysOp  switches time  formats.  For this reason, the
; @TP<char>@ control code has been added.
;
; If the  SysOp is using the 12 hour time format, this control code will do
; nothing.  If,  however, he is  using the 24 hour  time format,  this code
; will insert <char> at the current screen location.
;
; Example: @TP=@               <- Would insert '=' if using 24 hour time.
;
; Current Time Screen Location (@CT:xx,yy@)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; TurboEDIT needs to know whereabouts  on the screen to display the current
; time when it needs to be updated.  This control code simply specifies the
; screen coordinates of the time.
;
; Example: @CT:10,20@                  <- Would display the time at (10,20)
;
; Remaining Time Screen Location (@UT:xx,yy@)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; This code does the same thing as the Current Time Screen Location, except
; that it sets the coordinates for the user's Remaining Time.
;
; Please note that this file is only read if CheepEDIT is registered.
