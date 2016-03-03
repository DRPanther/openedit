Program LangMake;
Uses Utilpack;
{$I SEDIT.INC}
Type
 LangType = Array[1..LangCnt] Of String[75];
Const
 Hdr: String[80] = 'Open!EDIT Language File:  English';
 LangFile = 'ENGLISH';
 Default: LangType = (
'Quote Window               '                                               ,
'Quote Line       '                                                         ,
'Edit Message     '                                                         ,
'Abort message?             '                                               ,
'Menu   '                                                                   ,
'Save   '                                                                   ,
'User Signature       '                                                     ,
'You will have the option of appending your signature to each message you'  ,
'write.  When saving, you will be asked if you want to use the signature.'  ,
'User Configuration         '                                               ,
'Expand Text:               New Text:                '                      ,
'Use Taglines?'                                                             ,
'Use Expand?  '                                                             ,
'Use Keywords?'                                                             ,
'Ask Spellchk?'                                                             ,
'Auto Tagline?'                                                             ,
'Auto Sigs?   '                                                             ,
'Your Signature'                                                            ,
'Frame Colors        Text Colors        Input Colors       Tagline Kwds  '  ,
'Frame 1'                                                                   ,
'Capital'                                                                   ,
'Frame 2'                                                                   ,
'LowCase'                                                                   ,
'Frame 3'                                                                   ,
'Digits '                                                                   ,
'Frame 4'                                                                   ,
'Symbols'                                                                   ,
'Cannot save an empty message.               '                              ,
'Warning:    '                                                              ,
'of your message is quoted.      '                                          ,
'Please remove some quoting before saving.   '                              ,
'Return to edit & remove some quoting?       '                              ,
'Add your signature to this message?         '                              ,
'Save    '                                                                  ,
'Abort   '                                                                  ,
'Resume  '                                                                  ,
'Help    '                                                                  ,
'Aborting Message...        '                                               ,
'Sorry, you have been prohibited from posting messages in the current area:',
'Please use a different message group.                                     ',
'Returning to BBS...                                                       ',
'Spellcheck this message?           '                                       ,
'Spell Checker                      '                                       ,
'Spellchecking Message...              '                                    ,
'Word not found:          '                                                 ,
'[S] Skip  [A] Skip all  [D] Add to dict  [C] Change word  [Q] Quit    '    ,
'Enter new spelling:        '                                               ,
'Spellcheck complete                   '                                    ,
'Press [ESC] to return or [ENTER] to continue...           '                ,
'Taglines          '                                                        ,
'Commands          '                                                        ,
'Move              '                                                        ,
'IntelliTag        '                                                        ,
'Random            '                                                        ,
'Keyword           '                                                        ,
'Cancel            '                                                        ,
'Select            '                                                        ,
'Enter New         '                                                        ,
'New List          '                                                        ,
'No Tag            '                                                        ,
'Keyword           '                                                        ,
'Type your search keyword now:                                             ',
'Manual Entry      '                                                        ,
'Type your own tagline now:                                                ',
'Tagline           '                                                        ,
'Saving message...        '                                                 ,
'Overstrike        '                                                        ,
'Sorry, you must write at least        '                                    ,
'lines.   '                                                                 ,
'Sorry, this message may not be aborted.                '                   ,
'Import File             '                                                  ,
'Enter full path/filename of textfile to import:             '              ,
'[ENTER] to abort      '                                                    ,
'Export Message          '                                                  ,
'Enter full path/filename of textfile to export to:          '              ,
'SysOp dropping to DOS, please wait...          '                           ,
'Type EXIT to return to Open!EDIT...            '                           ,
'SysOp is using system, please wait...          '                           ,
'Executing program...                           '                           ,
'Select       '                                                             ,
'Time limit exceeded, exiting!                  '                           ,
'Quote       '                                                              ,
'Setup       '                                                              ,
'Help!       '                                                              ,
'20 Seconds Until Inactivity Timeout!                        '              ,
'Only 2 minutes remaining!          '                                       ,
'Only 1 minute remaining!           '                                       ,
'User Inactive, Disconnecting...    '                                       ,
'Tagline Selection Screen                '                                  ,
'Searching for taglines matching your keyword, please wait...            '  ,
'Searching for taglines related to the message subject, please wait...   '  ,
'Searching for taglines matching your keywords, please wait...           '  ,
'Sorry, no taglines match your tagline keyword!                          '  ,
'Sorry, could not find any taglines related to the message subject!      '  ,
'Sorry, no taglines match your tagline keywords!                         '  ,
'Scanning taglines, please wait...                                       '  ,
'Auto-appending tagline to message...                                    '  ,
'Choose a tagline to append to your message:                             '  ,
'Welcome to       '                                                         ,
'Please select a language                   '                               ,
'Change Language'                                                           ,
'Field Color    ',
'SysOp is editing your account, please wait...             '
);

Procedure CreateDefault;
Type XType = Array[1..83] Of Char;
Var
 XF: File Of XType;
 X: XType;
 S: String;
 Cnt: Word;
Begin
 Cnt:=0;
 Assign(XF,LangFile+'.LNG');
 FileMode:=66;
 ReWrite(XF);
 FillChar(S,SizeOf(S),#0);
 S:=#0#0#0#0#0#13+Pad(Hdr,51)+#13#10#26;
 Move(S[1],X,SizeOf(X));
 Write(XF,X);
 For Cnt:=1 To LangCnt Do
  Begin
   S:=RTrim(Default[Cnt]);
   FillChar(X,SizeOf(X),#0);
   Move(S[1],X[6],Length(S));
   Write(XF,X);
  End;
 Close(XF);
End;

Begin
 CreateDefault;
End.
