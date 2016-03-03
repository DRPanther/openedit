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
; ³ |
; Í =
;
; Any character not specified in this file will simply have its 8th bit
; removed.
;
; Note: Do NOT use the semicolon (;) in any of your translations, as it is
;       reserved to mark the beginning of a comment.

€ C
 u
‚ e
ƒ a
„ a
… a
† a
‡ c
ˆ e
‰ e
Š e
‹ i
Œ i
 i
Ž A
 A
 E
“ o
” o
• o
– u
— u
˜ y
™ O
š U
› c
œ L
 Y
ž P
Ÿ f
  a
¡ i
¢ o
£ u
¤ n
¥ N
¦ a
§ o
¨ ?
­ !
® <
¯ >
³ |
´ |
µ |
¶ |
· +
¸ +
¹ |
º |
» +
¼ +
½ +
¾ +
¿ +
À +
Á -
Â -
Ã |
Ä -
Å |
Æ |
Ç |
È +
É +
Ê -
Ë -
Ì |
Í -
Î |
Ï -
Ð -
Ñ -
Ò -
Ó +
Ô +
Õ +
Ö +
× |
Ø |
Ù +
Ú +
é O
ù .
ú .
ü n
ý 2
þ *
