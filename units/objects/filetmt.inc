{////////////////////////////////////////////////////////////////////////////}
{//    FREEVISION FILE FUNCTIONS FOR TMT: 25Oct02 Prof. A A Olowofoyeku    //}
{//                                                                        //}
{//  This library is a freeware library                                    //}
{//                                                                        //}
{//  v1.00, 25 Oct 2002 - Prof. A Olowofoyeku <african_chief@bigfoot.com>  //}
{//                                                                        //}
{//  Homepage: http://www.bigfoot.com/~african_chief/                      //}
{////////////////////////////////////////////////////////////////////////////}
TYPE
StreamFType = File;
PFile       = ^StreamFType;

CONST
InvalidHandle = 0;

{---------------------------------------------------------------------------}
{  GetFileHandle -> Platforms - All TMT platforms - Updated 25Oct02 AAO     }
{---------------------------------------------------------------------------}
FUNCTION GetFileHandle ( VAR f : file ) : THandle;
BEGIN
  Result := TFileRec (f).Handle;
END;

{---------------------------------------------------------------------------}
{  GetFilePtr -> Platforms - All TMT platforms - Updated 25Oct02 AAO        }
{---------------------------------------------------------------------------}
Procedure GetFilePtr (Handle : THandle; Var F : File);
Begin
   TFileRec(F).Handle := Handle;
End;

{---------------------------------------------------------------------------}
{  FileClose -> Platforms - All TMT platforms - Updated 25Oct02 AAO         }
{---------------------------------------------------------------------------}
FUNCTION FileClose ( Handle : THandle ) : Boolean;
VAR p : File;
BEGIN
  Result := False;
  IF Handle <> InvalidHandle
  THEN BEGIN
      GetFilePtr ( Handle, p );
      Close ( p );
      Result := IoResult = 0;
  END;
END;

{---------------------------------------------------------------------------}
{  FileOpen -> Platforms - All TMT platforms - Updated 25Oct02 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileOpen ( VAR FileName : AsciiZ; Mode : Word16 ) : THandle;
VAR
f   : File;
old : integer;
BEGIN
  old := FileMode;
  Assign ( f, FileName );

  IF Mode = stCreate THEN Rewrite ( f, 1 )
  ELSE BEGIN
     FileMode := Mode;
     Reset ( f, 1 );
     FileMode := Old;
  END;

  IF IOResult <> 0
  THEN BEGIN
     Result := InvalidHandle;
  END
  ELSE Result := GetFileHandle ( f );
END;

{---------------------------------------------------------------------------}
{  FileRead -> Platforms - All TMT platforms - Updated 25Oct02 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileRead ( Handle : THandle; VAR Buf; Count : Sw_Word; VAR Actual : dw_DWord ) : Word16;
VAR
p : File;
BEGIN
  Result := 104;
  IF Handle <> InvalidHandle
  THEN BEGIN
      GetFilePtr ( Handle, p );
      BlockRead ( p, Buf, Count, Actual );
      IF ( Actual = Count ) and ( IoResult = 0 ) THEN Result := 0;
  END;
END;

{---------------------------------------------------------------------------}
{  FileWrite -> Platforms - All TMT platforms - Updated 25Oct02 AAO         }
{---------------------------------------------------------------------------}
FUNCTION FileWrite ( Handle : THandle; VAR Buf; Count : Sw_Word; VAR Actual : dw_DWord ) : Word16;
VAR
p : File;
BEGIN
  Result := 105;
  IF Handle <> InvalidHandle
  THEN BEGIN
      GetFilePtr ( Handle, p );
      BlockWrite ( p, Buf, Count, Actual );
      IF ( Actual = Count ) and ( IoResult = 0 ) THEN Result := 0;
  END;
END;

{---------------------------------------------------------------------------}
{  FileSeek -> Platforms - All TMT platforms - Updated 25Oct02 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileSeek ( Handle : THandle; offset : Integer; origin : Integer ) : Integer;
VAR
p : File;
j, k, l : integer;
BEGIN
  Result := - 1;
  IF Handle <> InvalidHandle
  THEN BEGIN
      GetFilePtr ( Handle, p );
      k := FilePos ( p );
      j := FileSize ( p );
      l := Offset;
      CASE origin OF
         0 : {do nothing - seek from beginning of file };
         1 : l := k + Offset; { from current position }
         2 : l := j - Offset; { from end of file }
      END;
      Seek ( p, l );
      IF IoResult = 0 THEN Result := FilePos ( p );
  END;
END;

{---------------------------------------------------------------------------}
{  SetFileSize -> Platforms - All TMT platforms - Updated 25Oct02 AAO       }
{---------------------------------------------------------------------------}
FUNCTION SetFileSize ( Handle : THandle; FileSize : LongInt ) : Word16;
VAR
Actual : Longint;
p : File;
BEGIN
   Result := 103;
   IF Handle <> InvalidHandle
   THEN BEGIN
      GetFilePtr ( Handle, p );
      Actual := FileSeek ( Handle, FileSize, 0 );           { Position file }
      IF ( Actual = FileSize ) THEN BEGIN                   { No position error }
         Truncate ( p );                                    { Truncate the file }
         IF IoResult = 0 THEN Result := 0;
      END;
   END;
END;

{---------------------------------------------------------------------------}
{  SetFilePos -> Platforms - All TMT platforms - Updated 25Oct02 AAO        }
{---------------------------------------------------------------------------}
FUNCTION SetFilePos ( Handle : THandle; Pos : LongInt; MoveType : Word16;
VAR Actual : LongInt ) : Word16;
BEGIN
   Actual := FileSeek ( Handle, Pos, MoveType );          { Position file }
   IF ( Actual <> - 1 ) THEN Result := 0 ELSE             { No position error }
     Result := 107;                                       { File position error }
END;


