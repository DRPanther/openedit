         ��������������������                   ��������������������
        ���           Open!EDIT Spellchecker Dictionary           ���
        �               Version 1.02a � Documentation               �

  �����������������������������������������������������������������������Ŀ
  � ����� �                Dictionary Installation                � ����� �
  �������������������������������������������������������������������������

    To install the dictionary:

      � Make a directory called DICT in your Open!EDIT directory.
      � Move the files OE_DIC.DAT and OE_DIC.IDX into this new directory.
      � Run OESetup.
      � Select Tags/Checker.
      � Press 'D' to set  Spellchecking to YES  (force spellchecking)  or
        ASK (ask the user if he'd like to spellcheck).
      � Press 'E' and type the full path to the dictionary files (which
        would be your main Open!EDIT directory + \DICT).

    The spellchecker will now be installed and ready to run.

  �����������������������������������������������������������������������Ŀ
  � ����� �                   Dictionary Editor                   � ����� �
  �������������������������������������������������������������������������

    Open!EDIT has  a full dictionary editor.  This  editor
    allows the SysOp to  add words to, delete words from, and  edit words
    in the dictionary.

    This dictionary editor should  have been packaged with  the Open!EDIT
    dictionary file (OEDIC???.EXE), along with this documentation.

    The editor displays a list of words, and then presents the SysOp with
    the following options:

    �� Scroll Down                                                   Down
       ������������������������������������������������������������������
       Scrolls down one word in the list.

    �� Scroll Up                                                       Up
       ������������������������������������������������������������������
       Scrolls up one word in the list.

    �� Edit Word                                                    ENTER
       ������������������������������������������������������������������
       Allows you to edit the hilighted word.                           *

    �� Add Word                                                    INSert
       ������������������������������������������������������������������
       Allows you to add a word to the dictionary.                      *

    �� Remove Word                                                 DELete
       ������������������������������������������������������������������
       Allows you to erase a word from the dictionary.                  *

    �� Select Dictionary Section                            A to Z, and !
       ������������������������������������������������������������������
       In DictEdit, the dictionary is only shown one letter of the alpha-
       bet at a time.  To switch to another letter, press the correspond-
       ing key.  If there are words appended to the end of the dictionary
       (indicating that  your dictionary  needs  packing with  DICTSORT),
       pressing ! will access them.

    �� Personal Dictionaries                                         HOME
       ������������������������������������������������������������������
       Allows you to access your users' personal dictionaries.  If a user
       decides to add an unrecognized word to the spellchecker dictionary
       during a Open!EDIT session,  the word will be placed in that users
       OWN personal dictionary.

       This feature allows  you to browse the  words that the  users have
       adopted, and, optionally, import them into the master dictionary.

        �� Add word to main dictionary                               PGUP
           ��������������������������������������������������������������
           This option  is available while  editing a user's  dictionary.
           This allows you to copy  a word from the user's personal  dic-
           tionary into t he master  dictionary,  so that TurboEDIT  will
           recognize the word in *all* messages.

  �����������������������������������������������������������������������Ŀ
  � ����� �                    Dictionary Sort                    � ����� �
  �������������������������������������������������������������������������

    After making any major changes to the dictionary (i.e.  addition, re-
    moval, or editing of  more than a  dozen or so words) the  dictionary
    should be sorted to organize and pack it.

    This can be  accomplished by running DICTSORT.EXE.  This program will
    chunk, sort,  and recompile the  dictionary, removing any blank (del-
    eted) entries.

    This process may take awhile to run, however, so  use discretion when
    running DICTSORT.

  �����������������������������������������������������������������������Ŀ
  � ����� �                         -End-                         � ����� �
  �������������������������������������������������������������������������
