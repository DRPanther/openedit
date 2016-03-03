|NC�|HC��|PC��|BC�����������������������������������������������������������������������Ŀ
|HC�|FZ۲�� |FCF|FLrom|FS: @FROM...................@       |FCM|FLsg|FCD|FLate|FS: @DATE.............@    |FZ�|BC�
|PC�|FZ���  |FCT|FLo  |FS: @TO.....................@       |FCM|FLsg|FCN|FLum |FS: @MSG..@ |FCP|FLriv|FS: @P..@   |FZ��|BC�
|BC�|FZ��   |FCA|FLrea|FS: @AREA...................@                                     |FZ���|PC�
|BC�|FZ�    |FCS|FLubj|FS: @SUBJ......................................................@ |FZ����|HC�
|BC�������������������������������������������������������������������������|PC��|HC��|NC�
%
; CheepEDIT Header Control File
; Copyright (c) 2010, By Shawn Highfield.
;
; Any line beginning with a semicolon (;) is ignored.
; Any line beginning with a percent (%) signifies the end of the header,
; and speeds up processing if included.
;
; The text & control codes in this file may not exceed 10 lines, and the
; actual text displayed on the screen may NOT exceed 6 lines (the header
; may ONLY be displayed in the top 6 lines of the screen).
;
; Control Code                                                      Returns
; �������������������������������������������������������������������������
; @FROM@                              The name of the sender of the message
; @TO@                             The name of the recipient of the message
; @AREA@                               The name of the area being posted in
; @SUBJ@                                         The subject of the message
; @DATE@                                              The current date/time
; @MSG@                                                  The message number
; @P@                                           Private: " Yes " or " No  "
; �������������������������������������������������������������������������
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
; �������������������������������������������������������������������������
;
; In most cases, you will want each control code to be justified in a field
; of a certain size.  For example, the second line of the default header:
;
; �۲�� From: @FROM...................@       Date: @DATE.............@  ��
;
; This would be displayed as:
;
; �۲�� From: _Shawn_Highfield_________       Date: _04-Mar-97_01:20am_  ��
;
; (the _'s above represent colored spaces.)
;
; The entire size of the control code, from opening @ to closing @, is the
; actual size of the field of data that will be displayed on the screen.
;
; Please note that this file is only read if CheepEDIT is registered.
