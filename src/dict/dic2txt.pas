Var
 DicFile: File;
 NR: Word;
 TxtFile: Text;
 S: String;

Procedure AddWord(S: String);
Var
 NR: Word;
Begin
 Seek(DicFile,FileSize(DicFile));
 BlockWrite(DicFile,S[0],1,NR);
 BlockWrite(DicFile,S[1],Ord(S[0]),NR);
End;


Begin
 WriteLn('Processing dictionary...');
 Assign(DicFile,'CE_DIC.DAT');
 Reset(DicFile,1);
 Seek(DicFile,$100);
 Assign(TxtFile,'CE_DIC.TXT');
 ReWrite(TxtFile);
 Repeat
  BlockRead(DicFile,S,1,NR);
  BlockRead(DicFile,Mem[Seg(S):Ofs(S)+1],Ord(S[0]),NR);
  WriteLn(TxtFile,S);
 Until NR=0;
 Close(TxtFile);
 Close(DicFile);
End.
Procedure AddWord(S: String);
Var
 NR: Word;
Begin
 Seek(DatFile,FileSize(DatFile));
 BlockWrite(DatFile,S[0],1,NR);
 BlockWrite(DatFile,S[1],Ord(S[0]),NR);
End;
