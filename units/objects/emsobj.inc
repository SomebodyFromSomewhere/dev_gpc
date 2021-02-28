{---------------------------------------------------------------------------}
{                     STANDARD EMS ERROR STATE CONSTANTS                    }
{---------------------------------------------------------------------------}
   EMSInternalError = $80;                            { Internal error }
   EMSHardwareFail  = $81;                            { Hardware failure }
   EMSInvalidFunc   = $84;                            { Invalid EMS funtion }
   EMSNoEMSHandles  = $85;                            { No EMS handles left }
   EMSBeyondMax     = $87;                            { Req > EMS max size }
   EMSToManyPages   = $88;                            { Fewer pages free }
   EMSZeroPageReq   = $89;                            { Req zero page alloc }
   EMSNotPresent    = $FF;                            { No EMS driver found }

{---------------------------------------------------------------------------}
{                    INITIALIZED EMS PRIVATE VARIABLES                      }
{---------------------------------------------------------------------------}
CONST
   EMSPresent  : Boolean = False;                     { EMS present state }
   EMSInit     : Boolean = False;                     { EMS ready flag }
   EMSFrame    : Word = $FFFF;                        { EMS page frame }

{---------------------------------------------------------------------------}
{  InitializeEMS -> Platforms DOS - Checked 28Jan97 LdB                     }
{---------------------------------------------------------------------------}
PROCEDURE InitializeEMS; ASSEMBLER;
CONST EMSCheck: String[8] = 'EMMXXXX0';               { EMS check string }
ASM
   MOV AX, 3567H;
   INT 21H;                                           { Get EMS vector }
   CLD;
   MOV DI, 000AH;
   LEA SI, EMSCheck;                                  { Check string }
   INC SI;
   MOV CX, 0008;
   REPZ CMPSB;                                        { Loop on equal }
   OR CX, CX;
   JNZ @@NoEMS;                                       { Do strings equal }
   MOV AH, 41H;
   INT 67H;                                           { Get frame page }
   OR AH, AH;
   JNZ @@NoEMS;                                       { Check for error }
   MOV WORD PTR [EMSFrame], BX;
   MOV BYTE PTR [EMSPresent], True;                   { EMS present true }
@@NoEMS:
   MOV BYTE PTR [EMSInit], True;                      { EMS initialized }
END;

{---------------------------------------------------------------------------}
{  IsEMSPresent -> Platforms DOS - Checked 28Jan97 LdB                      }
{---------------------------------------------------------------------------}
FUNCTION IsEMSPresent: Boolean; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   MOV AL, [EMSPresent];                              { Return result }
END;

{---------------------------------------------------------------------------}
{  EMS_Version -> Platforms DOS - Checked 28Jan97 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION EMS_Version: Word; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   XOR AX, AX;                                        { Preset zero return }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 46H;                                       { Set EMS function id }
   INT 67H;                                           { Get EMS version }
   OR AH, AH;                                         { Check for error }
   JZ @@EMSVerOk;                                     { Jump if no error }
   XOR AX, AX;                                        { Return zero - error }
@@EMSVerOk:
   MOV CL, 4;                                         { Load shift count }
   SHL AX, CL;                                        { Shift to position }
@@Exit:
END;

{---------------------------------------------------------------------------}
{  EMS_MaxAvail -> Platforms DOS - Checked 28Jan97 LdB                      }
{---------------------------------------------------------------------------}
FUNCTION EMS_MaxAvail: LongInt; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   XOR AX, AX;                                        { Preset zero return }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 42H;                                       { Set EMS function id }
   INT 67H;                                           { Get EMS usage }
   MOV BX, DX;                                        { Transfer register }
   XOR DX, DX;                                        { Clear register }
   OR AH, AH;                                         { Check for error }
   JZ @@Exit;                                         { Jump if no error }
@@EMSError:
   XOR BX, BX;                                        { Return zero }
   MOV DX, BX;
@@Exit:                                               { DX:BX = Total pages }
   MOV AX, BX;                                        { Transfer register }
   MOV CX, 000EH;                                     { 1 SHL 14 = 16K }
   DB $0F; DB $A5; DB $C2;                            { SHL DX:AX, CL}
   SHL AX, CL;                                        { Roll lower word }
END;

{---------------------------------------------------------------------------}
{  EMS_MemAvail -> Platforms DOS - Checked 28Jan97 LdB                      }
{---------------------------------------------------------------------------}
FUNCTION EMS_MemAvail: LongInt; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   XOR AX, AX;                                        { Preset zero return }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 42H;                                       { Set EMS function id }
   INT 67H;                                           { Get EMS usage }
   XOR DX, DX;                                        { Clear register }
   OR AH, AH;                                         { Check for error }
   JZ @@Exit;                                         { Jump if no error }
@@EMSError:
   XOR BX, BX;                                        { Return zero }
   MOV DX, BX;
@@Exit:                                               { DX:BX = Avail pages }
   MOV AX, BX;                                        { Transfer register }
   MOV CX, 000EH;                                     { 1 SHL 14 = 16K }
   DB $0F; DB $A5; DB $C2;                            { SHL DX:AX, CL}
   SHL AX, CL;                                        { Roll lower word }
END;

{---------------------------------------------------------------------------}
{  EMS_GetMem -> Platforms DOS - Checked 28Feb97 LdB                        }
{---------------------------------------------------------------------------}
FUNCTION EMS_GetMem (Pages: Word): Word; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   XOR DX, DX;                                        { Preset no handle }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 43H;                                       { Set EMS function id }
   MOV BX, [Pages];                                   { Pages to allocate }
   INT 67H;                                           { Allocate EMS memory }
   OR AH, AH;                                         { Check register AX }
   JZ @@Exit;                                         { Zero means no error }
   XOR DX, DX;                                        { Clr handle on error }
@@Exit:
   MOV AX, DX;                                        { Return result }
END;

{---------------------------------------------------------------------------}
{  EMS_FreeMem -> Platforms DOS - Checked 28Feb97 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION EMS_FreeMem (Handle: Word): Boolean; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@EMSError;                                    { Error if no EMS }
   MOV AH, 45H;                                       { Set EMS function id }
   MOV DX, [Handle];                                  { Load handle }
   INT 67H;                                           { Release handle call }
   OR AH, AH;                                         { Check for error }
   JNZ @@EMSError;                                    { Jump if error }
   MOV AX, True;                                      { Function success }
   JMP @@Exit;                                        { Now exit }
@@EMSError:
   MOV AX, False;                                     { Function failed }
@@Exit:
END;

{---------------------------------------------------------------------------}
{  EMS_ResizeMem -> Platforms DOS - Checked 28Feb97 LdB                     }
{---------------------------------------------------------------------------}
FUNCTION EMS_ResizeMem (NewSize, Handle: Word): Integer;
ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   MOV AX, EMSNotPresent;                             { Preset return }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 51H;                                       { Set EMS function id }
   MOV BX, [NewSize];                                 { Load new size  }
   MOV DX, [Handle];                                  { Load handle }
   INT 67H;                                           { Reallocate memory }
   XCHG AH, AL;                                       { Exchange registers }
   XOR AH, AH;                                        { Clear high byte }
@@Exit:
END;

{---------------------------------------------------------------------------}
{  EMS_MapPage -> Platforms DOS - Checked 28Feb97 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION EMS_MapPage (Handle, LogPage: Word; PhyPage: Byte): Integer; ASSEMBLER;
ASM
   CMP BYTE PTR [EMSInit], True;                      { Chk EMS initialized }
   JZ @@EMSInitialized;                               { Jump if initialized }
   CALL InitializeEMS;                                { Initialize EMS }
@@EMSInitialized:
   MOV AX, EMSNotPresent;                             { Preset return }
   CMP EMSPresent, True;                              { Check EMS present }
   JNZ @@Exit;                                        { Exit if no EMS }
   MOV AH, 44H;                                       { Set EMS function id }
   MOV AL, [PhyPage];                                 { Physical EMS page }
   MOV BX, [LogPage];                                 { Logical EMS page }
   MOV DX, [Handle];                                  { Load handle }
   INT 67H;                                           { Remap memory call }
   XCHG AH, AL;                                       { Exchange registers }
   XOR AH, AH;                                        { Clear high byte }
@@Exit:
END;

{--TEmsStream---------------------------------------------------------------}
{  Done -> Platforms DOS - Updated 28Feb97 LdB                              }
{---------------------------------------------------------------------------}
DESTRUCTOR TEmsStream.Done;
BEGIN
   If (Handle <> 0) Then EMS_FreeMem(Handle);         { Release EMS blocks }
   Inherited Done;                                    { Call ancestor }
END;

{--TEmsStream---------------------------------------------------------------}
{  Truncate -> Platforms DOS - Updated 28Feb97 LdB                          }
{---------------------------------------------------------------------------}
PROCEDURE TEmsStream.Truncate;
VAR Success: Integer; W: Word;
BEGIN
   If (Status = stOk) Then Begin                      { Check status okay }
     If (Position = 0) Then W := 1 Else               { At least one page }
       W := (Position + 16383) DIV 16384;             { Pages to use }
     Success := 0;                                    { Preset success }
     If (W <> PageCount) Then                         { Sizes differ }
       If (EMS_ResizeMem(W, Handle)=0) Then           { Resize to this }
         PageCount := W Else Success := 401;          { Adjust blocks used }
     If (Success = 0) Then StreamSize := Position     { Adjust size }
       Else Error(stError, Success);                  { Identify error }
   End;
END;

{--TEmsStream---------------------------------------------------------------}
{  Read -> Platforms DOS - Updated 28Feb97 LdB                              }
{---------------------------------------------------------------------------}
PROCEDURE TEmsStream.Read (Var Buf; Count: Sw_Word);
VAR Success: Integer; EMSPage, EMSPos: Word; W: Sw_Word; P, Q: PByteArray;
BEGIN
   If (Position + Count > StreamSize) Then            { Insufficient data }
     Error(stReadError, 0);                           { Read beyond end!!! }
   If (Handle = 0) Then Error(stReadError, 403);      { EMS not available }
   P := @Buf;                                         { Transfer address }
   While (Count > 0) AND (Status = stOk) Do Begin     { Check status & count }
     EMSPage := (Position AND $FFFFC000) SHR 14;      { Current page }
     EMSPos := Position AND $00003FFF;                { Current position }
     Success := EMS_MapPage(Handle, EMSPage, 0);      { Map to page 0 }
     If (Success=0) AND (EMSPage+1 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+1, 1);  { Map to page 1 }
     If (Success=0) AND (EMSPage+2 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+2, 2);  { Map to page 2 }
     If (Success=0) AND (EMSPage+3 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+3, 3);  { Map to page 3 }
     If (Success=0) Then Begin                        { Mapping worked }
       W := $FFFF - EMSPos;                           { Current block space }
       If (W > Count) Then W := Count;                { Adjust read size }
       Q := Ptr(EMSFrame, EMSPos);                    { EMS memory addr }
       Move(Q^, P^, W);                               { Move data to buffer }
       Inc(Position, W);                              { Adjust position }
       P := Pointer(LongInt(P) + W);                  { Adjust buffer ptr }
       Dec(Count, W);                                 { Adjust count left }
     End Else Error(stReadError, Success);            { Mapping error }
   End;
   If (Count <> 0) Then FillChar(P^, Count, #0);      { Error clear buffer }
END;

{--TEmsStream---------------------------------------------------------------}
{  Write -> Platforms DOS - Updated 28Feb97 LdB                             }
{---------------------------------------------------------------------------}
PROCEDURE TEmsStream.Write (Var Buf; Count: Sw_Word);
VAR Success: Integer; EMSPage, EMSPos: Word; W: Sw_Word; P, Q: PByteArray;
BEGIN
   If (Position + Count > MemSize) Then Begin         { Expansion needed }
     If (Position + Count = 0) Then W := 1 Else       { At least one page }
       W := (Position+Count + 16383) DIV 16384;       { Pages needed }
     If (EMS_ResizeMem(W, Handle)=0) Then Begin       { Resize memory }
       PageCount := W;                                { Adjust page count }
       { * REMARK * - Do not shorten this, result can be > 64K }
       MemSize := PageCount;
       MemSize := MemSize * 1024;                     { New memory size }
       { * REMARK END * - Leon de Boer }
     End Else Error(stWriteError, 0);                 { We have an error }
   End;
   If (Handle = 0) Then Error(stWriteError, 403);     { EMS not available }
   P := @Buf;                                         { Transfer address }
   While (Count > 0) AND (Status = stOk) Do Begin     { Check status & count }
     EMSPage := (Position AND $FFFFC000) SHR 14;      { Current page }
     EMSPos := Position AND $00003FFF;                { Current position }
     Success := EMS_MapPage(Handle, EMSPage, 0);      { Map to page 0 }
     If (Success = 0) AND (EMSPage+1 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+1, 1);  { Map to page 1 }
     If (Success = 0) AND (EMSPage+2 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+2, 2);  { Map to page 2 }
     If (Success = 0) AND (EMSPage+3 < PageCount) Then
       Success := EMS_MapPage(Handle, EMSPage+3, 3);  { Map to page 3 }
     If (Success = 0) Then Begin                      { Mapping worked }
       W := $FFFF - EMSPos;                           { Current page space }
       If (W > Count) Then W := Count;                { Adjust read size }
       Q := Ptr(EMSFrame, EMSPos);                    { EMS memory addr }
       Move(P^, Q^, W);                               { Move data to buffer }
       Inc(Position, W);                              { Adjust position }
       P := Pointer(LongInt(P) + W);                  { Transfer address }
       Dec(Count, W);                                 { Adjust count left }
       If (Position > StreamSize) Then                { File expanded }
         StreamSize := Position;                      { Adjust stream size }
     End Else Error(stWriteError, Success);           { Mapping error }
   End;
END;
