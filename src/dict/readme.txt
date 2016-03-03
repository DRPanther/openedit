         ÜÛÛßßßßßßßßßßßßßßßßß                   ßßßßßßßßßßßßßßßßßÛÛÜ
        ŞÛß           Open!EDIT Spellchecker Dictionary           ßÛİ
        Û               Version 1.02a ş Documentation               Û

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ °°°°° ³                Dictionary Installation                ³ °°°°° ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    To install the dictionary:

      ş Make a directory called DICT in your Open!EDIT directory.
      ş Move the files OE_DIC.DAT and OE_DIC.IDX into this new directory.
      ş Run OESetup.
      ş Select Tags/Checker.
      ş Press 'D' to set  Spellchecking to YES  (force spellchecking)  or
        ASK (ask the user if he'd like to spellcheck).
      ş Press 'E' and type the full path to the dictionary files (which
        would be your main Open!EDIT directory + \DICT).

    The spellchecker will now be installed and ready to run.

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ °°°°° ³                   Dictionary Editor                   ³ °°°°° ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    Open!EDIT has  a full dictionary editor.  This  editor
    allows the SysOp to  add words to, delete words from, and  edit words
    in the dictionary.

    This dictionary editor should  have been packaged with  the Open!EDIT
    dictionary file (OEDIC???.EXE), along with this documentation.

    The editor displays a list of words, and then presents the SysOp with
    the following options:

    ş¯ Scroll Down                                                   Down
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Scrolls down one word in the list.

    ş¯ Scroll Up                                                       Up
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Scrolls up one word in the list.

    ş¯ Edit Word                                                    ENTER
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Allows you to edit the hilighted word.                           *

    ş¯ Add Word                                                    INSert
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Allows you to add a word to the dictionary.                      *

    ş¯ Remove Word                                                 DELete
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Allows you to erase a word from the dictionary.                  *

    ş¯ Select Dictionary Section                            A to Z, and !
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       In DictEdit, the dictionary is only shown one letter of the alpha-
       bet at a time.  To switch to another letter, press the correspond-
       ing key.  If there are words appended to the end of the dictionary
       (indicating that  your dictionary  needs  packing with  DICTSORT),
       pressing ! will access them.

    ş¯ Personal Dictionaries                                         HOME
       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
       Allows you to access your users' personal dictionaries.  If a user
       decides to add an unrecognized word to the spellchecker dictionary
       during a Open!EDIT session,  the word will be placed in that users
       OWN personal dictionary.

       This feature allows  you to browse the  words that the  users have
       adopted, and, optionally, import them into the master dictionary.

        ù¯ Add word to main dictionary                               PGUP
           ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
           This option  is available while  editing a user's  dictionary.
           This allows you to copy  a word from the user's personal  dic-
           tionary into t he master  dictionary,  so that TurboEDIT  will
           recognize the word in *all* messages.

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ °°°°° ³                    Dictionary Sort                    ³ °°°°° ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    After making any major changes to the dictionary (i.e.  addition, re-
    moval, or editing of  more than a  dozen or so words) the  dictionary
    should be sorted to organize and pack it.

    This can be  accomplished by running DICTSORT.EXE.  This program will
    chunk, sort,  and recompile the  dictionary, removing any blank (del-
    eted) entries.

    This process may take awhile to run, however, so  use discretion when
    running DICTSORT.

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ °°°°° ³                         -End-                         ³ °°°°° ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
