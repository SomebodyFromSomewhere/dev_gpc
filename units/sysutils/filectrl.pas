{//////////////////////////////////////////////////////////////////////////}
{                                                                        //}
{               "DELPHI"(tm) Compatible FILECTRL UNIT FOR GPC            //}
{                                                                        //}
{             @@ Incomplete: missing the SelectDirectory function @@     //}
{             @@ and the file and directory combo boxes @@               //}
{                                                                        //}
{    Copyright (C) 1998-2005 Free Software Foundation, Inc.              //}
{                                                                        //}
{    Author:                                                             //}
{       Prof Abimbola A Olowofoyeku <chiefsoft at bigfoot dot com>         }
{                                                                        //}
{    This UNIT is released as part of the GNU Pascal project.            //}
{                                                                        //}
{    This library is a free library; you can redistribute and/or modify  //}
{    it under the terms of the GNU Library General Public License,       //}
{    version 2, as published by the Free Software Foundation.            //}
{                                                                        //}
{    This library is distributed in the hope that it will be useful,     //}
{    but WITHOUT ANY WARRANTY; without even the implied warranty of      //}
{    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       //}
{    GNU Library General Public License for more details.                //}
{                                                                        //}
{    You should have received a copy of the GNU Library General Public   //}
{    License along with this library (see the file COPYING.LIB);         //}
{    if not, write to the Free Software Foundation, Inc., 675 Mass Ave,  //}
{    Cambridge, MA 02139, USA.                                           //}
{                                                                        //}
{    As a special exception, if you link this file with files compiled     }
{    with a GNU compiler to produce an executable, this does not cause     }
{    the resulting executable to be covered by the GNU Library General     }
{    Public License. This exception does not however invalidate any other  }
{    reasons why the executable file might be covered by the GNU Library   }
{    General Public License.                                               }
{                                                                          }
{    Updated: 19 July 2005, Prof. A Olowofoyeku (The African Chief)        }
{                                                                          }
{                                                                        //}
{//////////////////////////////////////////////////////////////////////////}

UNIT FileCtrl;

INTERFACE
{$implicit-result}

{ for 'SelectDirectory', and other stuff, which are not yet
  implemented, and which cannot be implemented in a portable way
}
TYPE
TFileAttr      = ( ftReadonly, ftHidden, ftSystem, ftVolumeID, ftDirectory,
                  ftArchive, ftNormal );
TFileType      = set OF TFileAttr;
TTextCase      = ( tcLowerCase, tcUpperCase );

TSelectDirOpt  = ( sdAllowCreate, sdPerformCreate, sdPrompt );
TSelectDirOpts = set OF TSelectDirOpt;

{ iteratively create a directory path }
FUNCTION  ForceDirectories ( Path : String ) : Integer;

FUNCTION  DirectoryExists ( CONST Path : string ) : Boolean;
external name ('_p_directory_exists');

IMPLEMENTATION

{$I-}

USES gpc, dos;

CONST
DirSep = {$ifdef __OS_DOS__}'\'{$else}'/'{$endif};

FUNCTION ExpandFileName ( s : string ) : TString;
BEGIN
  ExpandFileName := s;
  s := FExpand ( s );
  IF s <> '' THEN ExpandFileName := s;
END;

FUNCTION  ForceDirectories ( Path : String ) : Integer;
VAR
  i  : Integer;
  NewDir : TString;
BEGIN
 Path := ExpandFileName ( Path );
 Result := 0;
 IF DirectoryExists ( Path ) THEN Exit;
 i := Pos ( DirSep, Path );
 Result := 0;
 REPEAT
    REPEAT
      Inc ( i )
    UNTIL ( i > Length ( Path ) ) OR ( Path [ i ] = DirSep );
    NewDir := Copy ( Path, 1, Pred ( i ) );

    IF NOT DirectoryExists ( NewDir )
    THEN BEGIN
        MkDir ( NewDir );
        IF IOResult <> 0
        THEN BEGIN
            Result := - 1;
            Exit
        END;
        Inc ( Result )
      END
  UNTIL i > Length ( Path );
END; {* ForceDirectories *}

END.

