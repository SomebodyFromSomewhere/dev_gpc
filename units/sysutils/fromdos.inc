{                                                                          }
{    General imports from the GPC Dos unit for the Sysutils unit           }
{                                                                          }
{    Copyright (C) 1997-2001 Free Software Foundation, Inc.                }
{                                                                          }
{    Author:                                                               }
{       Frank Heckenbach <frank@g-n-u.de>                                  }
{                                                                          }
{    This file is part of GNU Pascal.                                      }
{
     Routines imported from the Dos unit
         UnpackTime
         PackTime
         GetDate
         GetTime
         DiskFree
         DiskSize
         GetFAttr
         SetFAttr
         GetFTime
         SetFtime
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

{$B-,I-}

VAR
  { Error status variable }
  DosError : Integer = 0;

CONST
  { File attribute constants }
  ReadOnly      = $01;
  Hidden        = $02; { set for dot files except '.' and '..' }
  SysFile       = $04; { not supported }
  VolumeID      = $08; { not supported }
  Directory     = $10;
  Archive       = $20; { means: not executable }
//  {$local W-} AnyFile = $3F; {$endlocal}


  { DosError codes }
  DosError_FileNotFound = 2;
  DosError_PathNotFound = 3;
  DosError_AccessDenied = 5;
  DosError_InvalidMem   = 9;
  DosErorr_InvalidEnv   = 10;
  DosError_NoMoreFiles  = 18;
  DosError_IOError      = 29;
  DosError_ReadFault    = 30;

TYPE
  PLongInt = ^LongInt;

VAR
  DosExitCodeVar : Word = 0;
  TimeDelta : MicroSecondTimeType = 0;

procedure UnpackTime (P : LongInt; var T : DateTime); forward;
procedure PackTime (const T : DateTime; var P : LongInt); forward;

{///////////////////////////////}
procedure GetDate (var Year, Month, Day, DayOfWeek : Word);
var
  t : MicroSecondTimeType;
  ts : TimeStamp;
begin
  t := GetMicroSecondTime + TimeDelta;
  UnixTimeToTimeStamp (t div 1000000, ts);
  Year      := ts.Year;
  Month     := ts.Month;
  Day       := ts.Day;
  DayOfWeek := ts.DayOfWeek
end;

procedure GetTime (var Hour, Minute, Second, Sec100 : Word);
var
  t : MicroSecondTimeType;
  ts : TimeStamp;
begin
  t := GetMicroSecondTime + TimeDelta;
  UnixTimeToTimeStamp (t div 1000000, ts);
  Hour   := ts.Hour;
  Minute := ts.Minute;
  Second := ts.Second;
  Sec100 := (t mod 1000000) div 10000
end;

function DiskFree (Drive : Byte) : LongInt;
var
  Path : String (2);
  Buf : StatFSBuffer;
begin
  DiskFree := 0;  { @@ spurious gcc-2.95 warning on m68k, S390 }
  if Drive = 0 then
    Path := DirSelf
  else
    Path := Succ ('a', Drive - 1) + ':';
  StatFS (Path, Buf);
  if IOResult = 0 then
    DiskFree := Buf.BlockSize * Buf.BlocksFree
  else
    begin
      DosError := DosError_AccessDenied;
      DiskFree := - 1
    end
end;

function DiskSize (Drive : Byte) : LongInt;
var
  Path : String (2);
  Buf : StatFSBuffer;
begin
  DiskSize := 0;  { @@ spurious gcc-2.95 warning on m68k }
  if Drive = 0 then
    Path := DirSelf
  else
    Path := Succ ('a', Drive - 1) + ':';
  StatFS (Path, Buf);
  if IOResult = 0 then
    DiskSize := Buf.BlockSize * Buf.BlocksTotal
  else
    begin
      DosError := DosError_AccessDenied;
      DiskSize := - 1
    end
end;

procedure GetFAttr (var F : GPC_AnyFile; var Attr : TDosAttr);
var
  b : BindingType;
  s : TString;
  d : OrigInt;
begin
  b := Binding (F);
  Attr := 0;
  if not (b.Bound and (b.Existing or b.Directory or b.Special)) then
    DosError := DosError_FileNotFound
  else
    begin
      DosError := 0;
      if b.Directory      then Attr := Attr or Directory;
      if not b.Writable   then Attr := Attr or ReadOnly;
      if not b.Executable then Attr := Attr or Archive;
      d := Length (b.Name);
      while (d > 0) and not (b.Name [d] in DirSeparators) do Dec (d);
      if (Length (b.Name) > d + 1) and (b.Name [d + 1] =  '.') and
        ((Length (b.Name) > d + 2) or  (b.Name [d + 2] <> '.')) then
        Attr := Attr or Hidden
    end
end;

procedure SetFAttr (var F : GPC_AnyFile; Attr : TDosAttr);
var b : BindingType;
begin
  b := Binding (F);
  if not b.Bound then
    begin
      DosError := DosError_FileNotFound;
      Exit
    end;
  if Attr and ReadOnly = 0
    then or  (b.Mode, fm_UserWritable) { Set only user write permissions, for reasons of safety! }
    else and (b.Mode, not (fm_UserWritable or fm_GroupWritable or fm_OthersWritable));
  if Attr and Archive = 0
    then or  (b.Mode, fm_UserExecutable or fm_GroupExecutable or fm_OthersExecutable)
    else and (b.Mode, not (fm_UserExecutable or fm_GroupExecutable or fm_OthersExecutable));
  ChMod (F, b.Mode);
  if IOResult <> 0 then DosError := DosError_AccessDenied
end;

procedure GetFTime (var F : GPC_AnyFile; var aTime : LongInt);
var
  b : BindingType;
  Year, Month, Day, Hour, Minute, Second : CInteger;
  dt : DateTime;
begin
  b := Binding (F);
  if not (b.Bound and (b.Existing or b.Directory or b.Special)) then
    DosError := DosError_FileNotFound
  else
    begin
      if b.ModificationTime >= 0 then
        begin
          UnixTimeToTime (b.ModificationTime, Year, Month, Day, Hour, Minute, Second, NULL, NULL, NULL, NULL);
          dt.Year  := Year;
          dt.Month := Month;
          dt.Day   := Day;
          dt.Hour  := Hour;
          dt.Min   := Minute;
          dt.Sec   := Second;
          PackTime (dt, aTime)
        end
      else
        aTime := 0;
      DosError := 0
    end
end;

procedure SetFTime (var F : GPC_AnyFile; aTime : LongInt);
var
  dt : DateTime;
  ut: UnixTimeType;
begin
  UnpackTime (aTime, dt);
  with dt do ut := TimeToUnixTime (Year, Month, Day, Hour, Min, Sec);
  DosError := DosError_AccessDenied;
  if ut >= 0 then
    begin
      SetFileTime (F, ut, ut);
      if IOResult = 0 then DosError := 0
    end
end;

procedure UnpackTime (P : LongInt; var T : DateTime);
begin
  T.Year  := (P shr 25) and $7f + 1980;
  T.Month := (P shr 21) and $f;
  T.Day   := (P shr 16) and $1f;
  T.Hour  := (P shr 11) and $1f;
  T.Min   := (P shr 5) and $3f;
  T.Sec   := 2 * (P and $1f)
end;

procedure PackTime (const T : DateTime; var P : LongInt);
begin
  P := (LongInt (T.Year) - 1980) shl 25 + LongInt (T.Month) shl 21 + LongInt (T.Day) shl 16
       + T.Hour shl 11 + T.Min shl 5 + T.Sec div 2
end;


