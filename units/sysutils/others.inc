{                                                                          }
{    Specific imports from the GPC Dos unit for the Sysutils unit          }
{                                                                          }
{    Copyright (C) 1997-2001 Free Software Foundation, Inc.                }
{                                                                          }
{    Authors:                                                              }
{       Frank Heckenbach <frank@g-n-u.de>                                  }
{       Prof Abimbola A Olowofoyeku <African_Chief@bigfoot.com>            }
{                                                                          }
{    This file is part of GNU Pascal.                                      }
{
     Routines imported from the Dos unit
         FindFirst,
         FindNext,
         FindClose
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

{ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ }
Procedure Do_SR (Var SR : TSearchRec);
BEGIN
  SR.Size := SR.DosData.Size;
  SR.Name := SR.DosData.Name;
  SR.Time := SR.DosData.Time;
  SR.Attr := SR.DosData.Attr;
  WITH SR.FindData
  DO BEGIN
     dwFileAttributes := SR.Attr;
     nFileSizeHigh    := SR.Size;
     nFileSizeLow     := SR.Size;
     StrPCopy ( CFILENAME, SR.Name );
     StrLCopy ( CALTERNATEFILENAME, CFILENAME, 14 );
     WITH ftLastWriteTime
     DO BEGIN
          dwLowDateTime := SR.Time;
          dwHighDateTime := 0;  { @@ crude @@ }
     END;
     ftCreationTime := ftLastWriteTime;
     ftLastAccessTime := ftLastWriteTime;
  END;
END;
{ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ }

{ Since there's no explicit closing of FindFirst/FindNext, FindList keeps
  tracks of all running searches so they can be closed automatically when
  necessary, and Magic indicates if a SearchRec is currently in use. }

const
  srOpened = $2424d00f;
  srDone   = $4242f00d;

type
  TSRFillInternal = packed record
    Magic: OrigInt;
    Unused: packed array [1 .. SizeOf (SearchRecFill) - SizeOf (OrigInt)] of Byte
  end;

  PPFindList = ^PFindList;
  PFindList  = ^TFindList;
  TFindList  = record
    Next: PFindList;
    SR  : ^SearchRec;
    Dir,
    BaseName,
    Ext : TString;
    Attr: TDosAttr;
    PDir: Pointer
  end;

var
  FindList: PFindList = nil;

procedure CloseFind (PTemp: PPFindList);
var Temp: PFindList;
begin
  Temp := PTemp^;
  CloseDir (Temp^.PDir);
  TSRFillInternal (Temp^.SR^.Fill).Magic := srDone;
  PTemp^ := Temp^.Next;
  Dispose (Temp)
end;

Function FindFirst{ (const Path: String; Attr: TDosAttr; var SR: SearchRec)};
var
  Temp: PFindList;
  PTemp: PPFindList;
begin
  Result := 0; { @ }

  { If SR was used before, close it first }
  PTemp := @FindList;
  while (PTemp^ <> nil) and (PTemp^^.SR <> @SR.DosData) do PTemp := @PTemp^^.Next;
  if PTemp^ <> nil then
    begin
      CloseFind (PTemp);
      if IOResult <> 0 then DosError := DosError_ReadFault
    end;
  Result := DosError; { @ }

  if (Attr and not (ReadOnly or Archive)) = VolumeID then
    begin
      DosError := DosError_NoMoreFiles;
      Result := DosError; { @ }
      Exit
    end;

  SetReturnAddress (ReturnAddress (0));
  New (Temp);
  RestoreReturnAddress;

  FSplit (Path, Temp^.Dir, Temp^.BaseName, Temp^.Ext);
  if Temp^.Dir = '' then Temp^.Dir := DirSelf + DirSeparator;
  if Temp^.Ext = '' then Temp^.Ext := ExtSeparator;
  Temp^.SR := @SR.DosData;
  Temp^.Attr := Attr;
  Temp^.PDir := OpenDir (Temp^.Dir);
  if IOResult <> 0 then
    begin
      TSRFillInternal (SR.DosData.Fill).Magic := srDone;
      Dispose (Temp);
      DosError := DosError_NoMoreFiles;
      Result := DosError; { @ }
      Exit
    end;
  TSRFillInternal (SR.DosData.Fill).Magic := srOpened;
  Temp^.Next := FindList;
  FindList := Temp;
  SetReturnAddress (ReturnAddress (0));
  Result := FindNext (SR);
  RestoreReturnAddress
end;

Function FindNext{ (var SR: SearchRec)};
var
  Temp: PFindList;
  PTemp: PPFindList;
  FileName, Dir, BaseName, Ext: TString;
  f: Text;
  TmpAttr: TDosAttr;
  TmpTime: LongInt;

  { Emulate Dos brain-damaged file name wildcard matching }
  function MatchPart (const aName, Mask: String): Boolean;
  var i: OrigInt;
  begin
    for i := 1 to Length (Mask) do
      case Mask[i] of
        '?': ;
        '*': Return True;
        else
          if (i > Length (aName)) or (FileNameLoCase (aName[i]) <> FileNameLoCase (Mask[i])) then Return False
      end;
    MatchPart := (Length (Mask) >= Length (aName))
  end;

begin
  DosError := 0;
  Result := DosError; { @ }

  { Check if SR is still valid }
  case TSRFillInternal (SR.DosData.Fill).Magic of
    srOpened: ;
    srDone: begin
              DosError := DosError_NoMoreFiles;
              Result := DosError; { @ }
              Exit
            end;
    else
      DosError := DosError_InvalidMem;
      Result := DosError; { @ }
      Exit
  end;
  PTemp := @FindList;
  while (PTemp^ <> nil) and (PTemp^^.SR <> @SR.DosData) do PTemp := @PTemp^^.Next;
  Temp := PTemp^;
  if Temp = nil then
    begin
      DosError := DosError_InvalidMem;
      Result := DosError; { @ }
      Exit
    end;
  repeat
    FileName := ReadDir (Temp^.PDir);
    if FileName = '' then
      begin
        CloseFind (PTemp);
        if IOResult = 0
          then DosError := DosError_NoMoreFiles
          else DosError := DosError_ReadFault;
        Result := DosError; { @ }
        Exit
      end;
    SetReturnAddress (ReturnAddress (0));
    Assign (f, Temp^.Dir + FileName);
    RestoreReturnAddress;
    GetFAttr (f, TmpAttr);
    SR.DosData.Attr := TmpAttr;
    FSplit (FileName, Dir, BaseName, Ext);
    if Ext = '' then Ext := ExtSeparator;
  until (MatchPart (BaseName, Temp^.BaseName)) and (MatchPart (Ext, Temp^.Ext))
  and
        { Emulate Dos brain-damaged file attribute matching }
        (((Temp^.Attr and (Hidden or SysFile)) <> 0) or ((TmpAttr and Hidden)    = 0))
  and
        (((Temp^.Attr and Directory)           <> 0) or ((TmpAttr and Directory) = 0));

  Result := DosError; { @ }
  if DosError <> 0 then Exit;
  SR.DosData.Name := FileName;
  GetFTime (f, TmpTime);
  SR.DosData.Time := TmpTime;
  if Binding (f).Existing then
    begin
      Reset (f);
      SR.DosData.Size := FileSize (f);
      Close (f)
    end
  else
    SR.DosData.Size := 0;

   {  @@ additional @@ }
   Do_SR ( SR );
end;

procedure FindClose{ (var SR: SearchRec)};
var PTemp: PPFindList;
begin
  PTemp := @FindList;
  while (PTemp^ <> nil) and (PTemp^^.SR <> @SR.DosData) do PTemp := @PTemp^^.Next;
  if PTemp^ <> nil then
    begin
      CloseFind (PTemp);
      if IOResult <> 0 then DosError := DosError_ReadFault
    end
end;
