{**************************************************************************}
{        System specific (Win32) include file for the Sysutils unit        }
{                                                                          }
{    Copyright (C) 1997-2003 Free Software Foundation, Inc.                }
{                                                                          }
{    Author:                                                               }
{       Prof Abimbola A Olowofoyeku <African_Chief@bigfoot.com>            }
{                                                                          }
{    This file is part of GNU Pascal.                                      }
{
   * caters for the following for Cygwin/Mingw32:
        * File Attributes
        * Current Directory
        * FindFirst/FindNext
        * Version information
        * Conversion of Windows time values to sensible ones
}
{                                                                          }
{                                                                          }
{    This library is a free library; you can redistribute and/or modify    }
{    it under the terms of the GNU Library General Public License,         }
{    version 2, as published by the Free Software Foundation.              }
{                                                                          }
{    This library is distributed in the hope that it will be useful,       }
{    but WITHOUT ANY WARRANTY; without even the implied warranty of        }
{    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         }
{    GNU Library General Public License for more details.                  }
{                                                                          }
{    You should have received a copy of the GNU Library General Public     }
{    License along with this library (see the file COPYING.LIB);           }
{    if not, write to the Free Software Foundation, Inc., 675 Mass Ave,    }
{    Cambridge, MA 02139, USA.                                             }
{                                                                          }
{    As a special exception, if you link this file with files compiled     }
{    with a GNU compiler to produce an executable, this does not cause     }
{    the resulting executable to be covered by the GNU Library General     }
{    Public License. This exception does not however invalidate any other  }
{    reasons why the executable file might be covered by the GNU Library   }
{    General Public License.                                               }
{                                                                          }
{    Updated: 17 April 2003, Prof. A Olowofoyeku (The African Chief)       }
{                                                                          }
{**************************************************************************}

{ WinAPI imports }

    {$if __GPC_RELEASE__ < 20030209}
       {$define WINAPI(X) asmname X; attribute(stdcall)}
    {$else}
       {$define WINAPI(X) external name X; attribute(stdcall)}
    {$endif}

FUNCTION GetModuleFileName ( hModule : Integer;
                            lpFilename : PChar;
                            nSize : Integer ) : Integer; WINAPI ( 'GetModuleFileNameA' );

{ convert a libC fd to a WinAPI file handle }
FUNCTION cfHandle2osfHandle ( c_handle : integer ) : integer; external name '_get_osfhandle';

{*  Version information  *}
TYPE TOSVERSIONINFO = RECORD
                        dwOSVersionInfoSize,
                        dwMajorVersion,
                        dwMinorVersion,
                        dwBuildNumber,
                        dwPlatformId : Integer;
                        SZCSDVERSION : ARRAY [0..127] OF CHAR ;
                      END { TOSVERSIONINFO };

VAR VerInfo : TOSVersionInfo;

FUNCTION GetVersionEx ( VAR lpVersionInformation : TOSVERSIONINFO ) : Boolean; WINAPI ( 'GetVersionExA' );

{* clock/time *}
PROCEDURE GetSystemTime ( VAR lpSystemTime : TSYSTEMTIME ); WINAPI ( 'GetSystemTime' );
PROCEDURE GetLocalTime ( VAR lpSystemTime : TSYSTEMTIME ); WINAPI ( 'GetLocalTime' );

{* file attributes *}
FUNCTION SetFileAttributes ( lpFileName : PChar;
                            dwFileAttributes : Integer ) : Boolean; WINAPI ( 'SetFileAttributesA' );

FUNCTION GetFileAttributes ( lpFileName : PChar ) : Integer; WINAPI ( 'GetFileAttributesA' );

{* time conversion *}
FUNCTION FileTimeToLocalFileTime ( CONST lpFileTime : TFileTime;
                                 VAR lpLocalFileTime : TFileTime ) : Boolean; WINAPI ( 'FileTimeToLocalFileTime' );

FUNCTION FileTimeToDosDateTime ( CONST lpFileTime : TFileTime;
                               VAR lpFatDate, lpFatTime : Word16 ) : Boolean; WINAPI ( 'FileTimeToDosDateTime' );

{* findfirst/findnext, etc. *}
FUNCTION FindFirstFile ( lpFileName : PChar;
                        VAR FindFileData : TWin32FindData ) : Word32;
                        WINAPI ( 'FindFirstFileA' );

FUNCTION FindNextFile ( hFindFile : Word32;
                       VAR FindFileData : TWin32FindData ) : Boolean;
                       WINAPI ( 'FindNextFileA' );

FUNCTION FindCloseFile ( hFindFile : Word32 ) : Boolean; WINAPI ( 'FindClose' );


{ routines, using the WinAPI imports }
FUNCTION FileTimeToLong ( CONST T : TFileTime ) : Int32;
VAR
  LocalFileTime : TFileTime;
  h, l : Word16;
BEGIN
    FileTimeToLocalFileTime ( T, LocalFileTime );
    FileTimeToDosDateTime ( LocalFileTime, h, l );
    Result := MakeInt32 ( l, h );
END;

{ Does the file supplied attribute "ToMatch" match the
  attribute masks in "TheAttr" ?
}
FUNCTION AttributesMatch ( CONST TheAttr, ToMatch : integer ) : boolean;
BEGIN
   Result :=
      ( ToMatch = faAnyFile )
   OR ( TheAttr AND ToMatch <> 0 )
   OR ( ( TheAttr = 0 ) AND ( ToMatch AND faArchive <> 0 ) ) { match 0 with archive }
   OR ( TheAttr AND faAnyFile = 0 )  { attribute is 128, etc }
END;

{ fill the record with relevant values }
PROCEDURE FillSR ( VAR SR : TSearchRec );
BEGIN
  WITH sR DO BEGIN
    Name := StrPas ( FindData.CFileName );
    Attr := FindData.dwFileAttributes;
    Size := ( FindData.nFileSizeHigh * High ( Integer ) ) + FindData.nFileSizeLow;
    Time := FileTimeToLong ( FindData.ftLastWriteTime );

    { @@ }
    DosData.Attr := Attr;
    DosData.Time := Time;
    DosData.Size := Size;
    DosData.Name := Name;
    { @@ }
  END;
END;

{ loop to search for matches }
FUNCTION FindLoop ( VAR sR : TSearchRec ) : boolean;
VAR
ismatch, ok : boolean;
BEGIN
  WITH sR DO BEGIN
    FindLoop := False;
    ismatch := false;
    WHILE NOT ismatch
    DO BEGIN
      {no file found}
      ok := FindNextFile ( sR.FindHandle, FindData );
      IF NOT ok THEN
      WITH sR DO BEGIN
         FindLoop := False;
         FindCloseFile ( FindHandle );
         FindHandle := - 1;
         exit;
      END;
      { attributes match }
      IF  AttributesMatch ( FindData.dwFileAttributes, ExcludeAttr )
      THEN BEGIN
          FillSR ( SR );
          FindLoop := true;
          exit;
      END;
   END; { while not ismatch }
  END;
END; {* FindLoop *}

FUNCTION FindFirst ( CONST Path : string; Attr : Integer; VAR SR : TSearchRec ) : Integer;
BEGIN
  WITH SR DO BEGIN
      FindHandle := FindFirstFile ( Path, FindData );
      IF ( FindHandle = - 1 ) THEN BEGIN
         DosError := DosError_NoMoreFiles;
         Result := DosError;
         Exit;
      END;

      { prepare for findloop, etc. }
      FillSR ( SR );

      IF AttributesMatch ( FindData.dwFileAttributes, Attr )
      THEN BEGIN
         Result := 0;
         DosError := 0;
         ExcludeAttr := Attr; { store the attrs to check for }
         Exit;
      END;

      IF FindLoop ( SR ) THEN { match found }
      BEGIN
          Result := 0;
          DosError := 0;
      END;

  END; { with }
END; {* FindFirst *}

FUNCTION FindNext ( VAR SR : TSearchRec ) : Integer;
BEGIN
   WITH SR
   DO BEGIN
      IF ( FindHandle = - 1 ) OR ( NOT FindNextFile ( FindHandle, FindData ) )
      THEN BEGIN
         DosError := DosError_NoMoreFiles;
         Result := DosError;
         Exit;
      END;

      { prepare for findloop, etc. }
      FillSR ( SR );

      IF AttributesMatch ( FindData.dwFileAttributes, ExcludeAttr )
      THEN BEGIN
         Result := 0;
         DosError := 0;
         Exit;
      END;

      IF FindLoop ( SR ) THEN { match found }
      BEGIN
          Result := 0;
          DosError := 0;
      END;

   END;
END; {* FindNext *}

PROCEDURE FindClose ( VAR SR : TSearchRec );
BEGIN
   FindCloseFile ( SR.FindHandle );
END; {* FindClose *}

