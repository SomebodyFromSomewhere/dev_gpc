{////////////////////////////////////////////////////////////////////////// //}
{//    FREEVISION FILE FUNCTIONS FOR GPC: 14Feb99 Prof. A A Olowofoyeku     //}
{//                                                                         //}
{//  This library is a free library; you can redistribute and/or modify     //}
{//  it under the terms of the GNU Library General Public License,          //}
{//  version 2, as published by the Free Software Foundation.               //}
{//                                                                         //}
{//  This library is distributed in the hope that it will be useful,        //}
{//  but WITHOUT ANY WARRANTY; without even the implied warranty of         //}
{//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          //}
{//  GNU Library General Public License for more details.                   //}
{//                                                                         //}
{//  You should have received a copy of the GNU Library General Public      //}
{//  License along with this library (see the file COPYING.LIB);            //}
{//  if not, write to the Free Software Foundation, Inc., 675 Mass Ave,     //}
{//  Cambridge, MA 02139, USA.                                              //}
{//                                                                         //}
{//  v1.00, 14 Feb 1999 - Prof. A Olowofoyeku <chiefsoft at bigfoot dot com> //}
{//  Homepage: http://www.greatchief.plus.com/                              //}
{////////////////////////////////////////////////////////////////////////// //}
TYPE
StreamFType = File;
PFile       = ^StreamFType;

CONST
InvalidHandle = 0;

{---------------------------------------------------------------------------}
{  GetFileHandle -> Platforms - All GPC platforms - Updated 14Feb99 AAO     }
{---------------------------------------------------------------------------}
FUNCTION GetFileHandle ( VAR f : file ) : THandle;
BEGIN
  Result := THandle ( @f );
END;

{---------------------------------------------------------------------------}
{  FileClose -> Platforms - All GPC platforms - Updated 14Feb99 AAO         }
{---------------------------------------------------------------------------}
FUNCTION FileClose ( Handle : THandle ) : Boolean;
VAR p : PFile;
BEGIN
  Result := False;
  IF Handle <> InvalidHandle
  THEN BEGIN
      p := PFile ( Handle );
      Close ( p^ );
      Result := IoResult = 0;
      IF Result THEN Dispose ( p );
  END;
END;

{---------------------------------------------------------------------------}
{  FileOpen -> Platforms - All GPC platforms - Updated 14Feb99 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileOpen ( VAR FileName : AsciiZ; Mode : Word16 ) : THandle;
VAR
f   : pFile;
old : integer;
BEGIN
  old := FileMode;
  New ( f );
  Assign ( f^, FileName );
  IF Mode = stCreate THEN Rewrite ( f^, 1 )
  ELSE BEGIN
     FileMode := Mode;
     Reset ( f^, 1 );
     FileMode := Old;
  END;
  IF IOResult <> 0
  THEN BEGIN
     Dispose ( f );
     Result := InvalidHandle;
  END
  ELSE Result := GetFileHandle ( f^ );
END;

{---------------------------------------------------------------------------}
{  FileRead -> Platforms - All GPC platforms - Updated 14Feb99 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileRead ( Handle : THandle; VAR Buf; Count : Sw_Word; VAR Actual : Sw_Word ) : Word16;
VAR
p : PFile;
BEGIN
  Result := 104;
  IF Handle <> InvalidHandle
  THEN BEGIN
      p := PFile ( Handle );
      BlockRead ( p^, Buf, Count, Actual );
      IF ( Actual = Count ) and ( IoResult = 0 ) THEN Result := 0;
  END;
END;

{---------------------------------------------------------------------------}
{  FileWrite -> Platforms - All GPC platforms - Updated 14Feb99 AAO         }
{---------------------------------------------------------------------------}
FUNCTION FileWrite ( Handle : THandle; VAR Buf; Count : Sw_Word; VAR Actual : Sw_Word ) : Word16;
VAR
p : PFile;
BEGIN
  Result := 105;
  IF Handle <> InvalidHandle
  THEN BEGIN
      p := PFile ( Handle );
      BlockWrite ( p^, Buf, Count, Actual );
      IF ( Actual = Count ) and ( IoResult = 0 ) THEN Result := 0;
  END;
END;

{---------------------------------------------------------------------------}
{  FileSeek -> Platforms - All GPC platforms - Updated 14Feb99 AAO          }
{---------------------------------------------------------------------------}
FUNCTION FileSeek ( Handle : THandle; offset : Integer; origin : Integer ) : Integer;
VAR
p : PFile;
j, k, l : integer;
BEGIN
  Result := - 1;
  IF Handle <> InvalidHandle
  THEN BEGIN
      p := PFile ( Handle );
      k := FilePos ( p^ );
      j := FileSize ( p^ );
      l := Offset;
      CASE origin OF
         0 : {do nothing - seek from beginning of file };
         1 : l := k + Offset; { from current position }
         2 : l := j - Offset; { from end of file }
      END;
      Seek ( p^, l );
      IF IoResult = 0 THEN Result := FilePos ( p^ );
  END;
END;

{---------------------------------------------------------------------------}
{  SetFileSize -> Platforms - All GPC platforms - Updated 14Feb99 AAO       }
{---------------------------------------------------------------------------}
FUNCTION SetFileSize ( Handle : THandle; FileSize : LongInt ) : Word16;
VAR
Actual : Longint;
p : PFile;
BEGIN
   Result := 103;
   IF Handle <> InvalidHandle
   THEN BEGIN
      p := PFile ( Handle );
      Actual := FileSeek ( Handle, FileSize, 0 );           { Position file }
      IF ( Actual = FileSize ) THEN BEGIN                   { No position error }
         Truncate ( p^ );                                   { Truncate the file }
         IF IoResult = 0 THEN Result := 0;
      END;
   END;
END;

{---------------------------------------------------------------------------}
{  SetFilePos -> Platforms - All GPC platforms - Updated 14Feb99 AAO        }
{---------------------------------------------------------------------------}
FUNCTION SetFilePos ( Handle : THandle; Pos : LongInt; MoveType : Word16;
VAR Actual : LongInt ) : Word16;
BEGIN
   Actual := FileSeek ( Handle, Pos, MoveType );          { Position file }
   IF ( Actual <> - 1 ) THEN Result := 0 ELSE             { No position error }
     Result := 107;                                       { File position error }
END;
