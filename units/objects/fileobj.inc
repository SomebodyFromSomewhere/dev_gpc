{---------------------------------------------------------------------------}
{  FileClose -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Feb97 LdB         }
{---------------------------------------------------------------------------}
FUNCTION FileClose (Handle: Word): Boolean;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   MOV BX, Handle;                                    { DOS file handle }
   MOV AH, $3E;                                       { Close function }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Close the file }
   POP BP;                                            { Reload register }
   MOV AL, True;                                      { Preset true }
   JNC @@Exit1;                                       { Return success }
   MOV AL, False;                                     { Return failure }
 @@Exit1:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT CODE }
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT CODE }
   If (_lclose(Handle) = 0) Then FileClose := True    { Close the file }
     Else FileClose := False;                         { Closure failed }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT CODE }
   FileClose := CloseHandle(Handle);                  { Close the file }
   {$ENDIF}
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
BEGIN
   If (DosClose(Handle) = 0) Then FileClose := True   { Try to close file }
     Else FileClose := False;                         { Closure failed }
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  FileOpen -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Feb97 LdB          }
{---------------------------------------------------------------------------}
FUNCTION FileOpen (Var FileName: AsciiZ; Mode: Word): Word;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   MOV AX, Mode;                                      { Mode to open file }
   XOR CX, CX;                                        { No attributes set }
   PUSH DS;                                           { Save segment }
   LDS DX, FileName;                                  { Filename to open }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Open/create file }
   POP BP;                                            { Restore register }
   POP DS;                                            { Restore segment }
   JNC @@Exit2;                                       { Check for error }
   XOR AX, AX;                                        { Open fail return 0 }
@@Exit2:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT CODE }
VAR
Hnd: Integer; ShareMode, OpenFlags: Sw_Word;
OpenMode : Longint;
   {$IFDEF BIT_16} Buf: TOfStruct; {$ENDIF}
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT CODE }
   If (Mode = stCreate) Then OpenMode := of_Create    { Set create mask bit }
     Else OpenMode := Mode AND $00FF;                 { Set open mask bits }
   Hnd := OpenFile(FileName, Buf, OpenMode);          { Open the file }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT CODE }
   ShareMode := 0;                                    { Zero share masks }
   If (Mode = stCreate) Then Begin                    { Create file }
     OpenMode := Generic_Read OR Generic_Write;       { Set access mask bit }
     OpenFlags := Create_Always;                      { Create always mask }
   End Else Begin                                     { Open the file }
     OpenMode := Generic_Read;                        { Read only access set }
     If (Mode AND $0001 <> 0) Then                    { Check write flag }
       OpenMode := OpenMode AND NOT Generic_Read;     { Write only access set }
     If (Mode AND $0002 <> 0) Then                    { Check read/write flag }
       OpenMode := OpenMode OR Generic_Write;         { Read/Write access }
     Case Mode AND $0070 Of
       $20: ShareMode := file_Share_Read;             { Deny write flag set }
       $30: ShareMode := file_Share_Write;            { Deny read flag set }
       $40: ShareMode := file_Share_Read OR
         file_Share_Write;                            { Deny none flag set }
     End;
     OpenFlags := Open_Existing;                      { Open existing mask }
   End;
   Hnd := CreateFile(FileName, OpenMode, ShareMode,
    Nil, OpenFlags, File_Attribute_Normal, 0);        { Open the file }
   {$ENDIF}
   If (Hnd <> -1) Then FileOpen := Hnd Else           { Return handle }
     FileOpen := 0;                                   { Return error }
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
VAR OpenFlags, OpenMode: Word; Handle, ActionTaken: Sw_Word;
BEGIN
   If (Mode = stCreate) Then Begin                    { Create file }
     OpenMode := Open_Flags_NoInherit OR
       Open_Share_DenyNone OR
       Open_Access_ReadWrite;                         { Open mode }
     OpenFlags := OPEN_ACTION_CREATE_IF_NEW OR
        OPEN_ACTION_REPLACE_IF_EXISTS;                { Open flags }
   End Else Begin
     OpenMode := Mode AND $00FF OR
       Open_Share_DenyNone;                           { Set open mode bits }
     OpenFlags := OPEN_ACTION_OPEN_IF_EXISTS;         { Set open flags }
   End;
   {$IFDEF PPC_BPOS2}                                 { C'T patched COMPILER }
   If (DosOpen(@FileName, Handle, ActionTaken, 0, 0,
     OpenFlags, OpenMode, 0) = 0) Then
       FileOpen := Handle Else FileOpen := 0;         { Return handle/fail }
   {$ELSE}                                            { OTHER OS2 COMPILERS }
   If (DosOpen(FileName, Handle, ActionTaken, 0, 0,
     OpenFlags, OpenMode, Nil) = 0) Then
       FileOpen := Handle Else FileOpen := 0;         { Return handle/fail }
   {$ENDIF}
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  FileRead -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Feb97 LdB          }
{---------------------------------------------------------------------------}
FUNCTION FileRead (Handle: Word; Var Buf; Count: Sw_Word; Var Actual: dw_DWord): Word;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   XOR AX, AX;                                        { Zero register }
   LES DI, Actual;                                    { Actual var address }
   MOV ES:[DI], AX;                                   { Zero actual var }
   PUSH DS;                                           { Save segment }
   LDS DX, Buf;                                       { Data destination }
   MOV CX, Count;                                     { Amount to read }
   MOV BX, Handle;                                    { Load file handle }
   MOV AX, $3F00;                                     { Load function id }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Read from file }
   POP BP;                                            { Reload register }
   POP DS;                                            { Restore segment }
   JC @@Exit4;                                        { Check for error }
   LES DI, Actual;                                    { Actual var address }
   MOV ES:[DI], AX;                                   { Update bytes moved }
   XOR AX, AX;                                        { Return success }
@@Exit4:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT CODE }
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT CODE }
   Actual := _lread(Handle, Pointer(@Buf), Count);    { Read from file }
   If (Actual = Count) Then FileRead := 0 Else        { No read error }
     FileRead := 104;                                 { File read error }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT CODE }
   If ReadFile
   (Handle,
   Buf,
   Count,
   Actual,
     Nil) AND (Actual = Count) Then FileRead := 0     { No read error }
     Else FileRead := 104;                            { File read error }
   {$ENDIF}
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
BEGIN
   If (DosRead(Handle, Buf, Count, Actual) = 0) AND   { Read from file }
   (Actual = Count) Then FileRead := 0 Else           { No read error }
     FileRead := 104;                                 { File read error }
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  FileWrite -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Feb97 LdB         }
{---------------------------------------------------------------------------}
FUNCTION FileWrite (Handle: Word; Var Buf; Count: Sw_Word; Var Actual: dw_DWord): Word;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   XOR AX, AX;                                        { Zero register }
   LES DI, Actual;                                    { Actual var address }
   MOV ES:[DI], AX;                                   { Zero actual var }
   PUSH DS;                                           { Save segment }
   LDS DX, Buf;                                       { Data source buffer }
   MOV CX, Count;                                     { Amount to write }
   MOV BX, Handle;                                    { Load file handle }
   MOV AX, $4000;                                     { Load function id }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Write to file }
   POP BP;                                            { Reload register }
   POP DS;                                            { Restore segment }
   JC @@Exit5;                                        { Check for error }
   LES DI, Actual;                                    { Actual var address }
   MOV ES:[DI], AX;                                   { Update bytes moved }
   XOR AX, AX;                                        { Write successful }
@@Exit5:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT CODE }
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT WINDOWS CODE }
   Actual := _lwrite(Handle, Pointer(@Buf), Count);   { Write to file }
   If (Actual = Count) Then FileWrite := 0 Else       { No write error }
     FileWrite := 105;                                { File write error }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT WINDOWS CODE }
   If WriteFile(Handle, Buf, Count, Actual,
     Nil) AND (Actual = Count) Then FileWrite := 0    { No write error }
     Else FileWrite := 105;                           { File write error }
   {$ENDIF}
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
BEGIN
   If (DosWrite(Handle, Buf, Count, Actual) = 0) AND  { Write to file }
   (Actual = Count) Then FileWrite := 0 Else          { No write error }
     FileWrite := 105;                                { File write error }
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  SetFileSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 26Feb97 LdB       }
{---------------------------------------------------------------------------}
FUNCTION SetFileSize (Handle: Word; FileSize: LongInt): Word;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   MOV DX, FileSize.Word[0];                          { Load file position }
   MOV CX, FileSize.Word[2];
   MOV BX, Handle;                                    { Load file handle }
   MOV AX, $4200;                                     { Load function id }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Position the file }
   POP BP;                                            { Reload register }
   JC @@Exit3;                                        { Exit if error }
   XOR CX, CX;                                        { Force truncation }
   MOV BX, Handle;                                    { File handle }
   MOV AX, $4000;                                     { Load function id }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Truncate file }
   POP BP;                                            { Reload register }
   JC @@Exit3;                                        { Exit if error }
   XOR AX, AX;                                        { Return successful }
@@Exit3:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT CODE }
VAR {$IFDEF BIT_16} Buf, {$ENDIF} Actual: LongInt;
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT WINDOWS CODE }
   Actual := _llseek(Handle, FileSize, 0);            { Position file }
   If (Actual = FileSize) Then Begin                  { No position error }
     Actual := _lwrite(Handle, Pointer(@Buf), 0);     { Truncate the file }
     If (Actual <> -1) Then SetFileSize := 0 Else     { No truncate error }
       SetFileSize := 103;                            { File truncate error }
   End Else SetFileSize := 103;                       { File truncate error }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT WINDOWS CODE }
   Actual := SetFilePointer(Handle, FileSize, Nil, 0);{ Position file }
   If (Actual = FileSize) Then Begin                  { No position error }
     If SetEndOfFile(Handle) Then SetFileSize := 0    { No truncate error }
       Else SetFileSize := 103;                       { File truncate error }
   End Else SetFileSize := 103;                       { File truncate error }
   {$ENDIF}
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
BEGIN
   {$IFDEF PPC_BPOS2}                                 { C'T patched COMPILER }
   SetFileSize := DosNewSize(Handle, FileSize);       { Truncate the file }
   {$ELSE}                                            { OTHER OS2 COMPILERS }
   SetFileSize := DosSetFileSize(Handle, FileSize);   { Truncate the file }
   {$ENDIF}
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  SetFilePos -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Feb97 LdB        }
{---------------------------------------------------------------------------}
FUNCTION SetFilePos (Handle: Word; Pos: LongInt; MoveType: Word;
Var Actual: LongInt): Word;
{$IFDEF OS_DOS}                                       { DOS/DPMI CODE }
ASSEMBLER;
ASM
   MOV AX, MoveType;                                  { Load move type }
   MOV AH, $42;                                       { Load function id }
   MOV DX, Pos.Word[0];                               { Load file position }
   MOV CX, Pos.Word[2];
   MOV BX, Handle;                                    { Load file handle }
   PUSH BP;                                           { Store register }
   INT $21;                                           { Position the file }
   POP BP;                                            { Reload register }
   JC @@Exit6;
   LES DI, Actual;                                    { Actual var addr }
   MOV ES:[DI], AX;
   MOV ES:[DI+2], DX;                                 { Update actual }
   XOR AX, AX;                                        { Set was successful }
@@Exit6:
END;
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WINDOWS CODE }
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT WINDOWS CODE }
   Actual := _llseek(Handle, Pos, MoveType);          { Position file }
   If (Actual <> -1) Then SetFilePos := 0 Else        { No position error }
     SetFilePos := 107;                               { File position error }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT WINDOWS CODE }
   Actual := SetFilePointer(Handle, Pos, Nil, MoveType);{ Position file }
   If (Actual <> -1) Then SetFilePos := 0 Else        { No position error }
     SetFilePos := 107;                               { File position error }
   {$ENDIF}
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
BEGIN
   {$IFDEF PPC_BPOS2}
   If (DosChgFilePtr(Handle, Pos, MoveType, Actual)=0){ Set file position }
     Then SetFilePos := 0 Else SetFilePos := 107;     { File position error }
   {$ELSE}                                            { OTHER OS2 COMPILERS }
   If (DosSetFilePtr(Handle, Pos, MoveType, Actual)=0){ Set file position }
     Then SetFilePos := 0 Else SetFilePos := 107;     { File position error }
   {$ENDIF}
END;
{$ENDIF}
