;
; CheepEDIT Bad User Control File
; Copyright (c) 2010, By Shawn Highfield
;
; This control file allows you to prohibit certain users from posting
; messages in selected message groups (i.e. If a user is locked out of
; a specific message network, you can stop him from posting in that net
; using this control file).
;
; You *MUST* be using RemoteAccess or Concord to use this feature!
;
; Usage:
;
; UserName / Group#[,Group#,Group#,Group#,...]
;
; Examples:
;
; Bob Jones / 1,4,7
; would stop Bob Jones from posting in message groups 1, 4, and 7.
;
; John Smith / 5
; would stop John Smith from posting in message group 5.
;
; Ima Badone / ALL
; would stop Ima Badone from writing in ANY group.
;
; Tom Smith / ALL EXCEPT 1,5
; would stop Tom Smith from writing in ANY group, EXCEPT groups 1 and 5.
;
; With the EXCEPT keyword, you can prohibit access to all groups EXCEPT
; a select few.  For example, if you wanted the user to be locked out of
; your echomail areas, but still have access to the local areas, you could
; use ALL EXCEPT 1 (or whichever group is your local group).
;

Bad User / 1,2,3,4,5
