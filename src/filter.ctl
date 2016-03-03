;
; SabreEDIT High ASCII Filter Control File
; Copyright (c) 1997-1998, By Darrell Harder of SabreTech Software.
;
; Translates high ASCII characters into low ASCII.
;

; This control file allows you to translate specific high ASCII codes into
; predefined regular ASCII codes.  Any text under the [translate] header
; MUST be in the following format:
;
; <highasciicode> <lowasciicode>
;
; Where <highasciicode> is the original high ASCII code or character, and
; <lowasciicode) is the low ASCII code or character you wish to convert it
; to, i.e.
;
; 179 124
; 205 61
;
; or
;
; � |
; � =
;
; Any character not specified in this file will simply have its 8th bit
; removed.
;
; Note: Do NOT use the semicolon (;) in any of your translations, as it is
;       reserved to mark the beginning of a comment.

� C
� u
� e
� a
� a
� a
� a
� c
� e
� e
� e
� i
� i
� i
� A
� A
� E
� o
� o
� o
� u
� u
� y
� O
� U
� c
� L
� Y
� P
� f
� a
� i
� o
� u
� n
� N
� a
� o
� ?
� !
� <
� >
� |
� |
� |
� |
� +
� +
� |
� |
� +
� +
� +
� +
� +
� +
� -
� -
� |
� -
� |
� |
� |
� +
� +
� -
� -
� |
� -
� |
� -
� -
� -
� -
� +
� +
� +
� +
� |
� |
� +
� +
� O
� .
� .
� n
� 2
� *
