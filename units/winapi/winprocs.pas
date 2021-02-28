{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                         WINPROCS.PAS                                     }
{                                                                          }
{                   WIN32 API IMPORT UNIT FOR GPC                          }
{                                                                          }
{ Copyright (C) 1998-2007 Free Software Foundation, Inc.                   }
{                                                                          }
{ Author: Prof. Abimbola Olowofoyeku <chiefsoft at bigfoot dot com>        }
{                                                                          }
{    This library is released as part of the GNU Pascal project.           }
{                                                                          }
{ This library is free software; you can redistribute it and/or            }
{ modify it under the terms of the GNU Lesser General Public               }
{ License as published by the Free Software Foundation; either             }
{ version 2.1 of the License, or (at your option) any later version.       }
{                                                                          }
{ This library is distributed in the hope that it will be useful,          }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        }
{ Lesser General Public License for more details.                          }
{                                                                          }
{ You should have received a copy of the GNU Lesser General Public         }
{ License along with this library; if not, write to the Free Software      }
{ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA }
{                                                                          }
{    As a special exception, if you link this file with files compiled     }
{    with a GNU compiler to produce an executable, this does not cause     }
{    the resulting executable to be covered by the GNU Library General     }
{    Public License. This exception does not however invalidate any other  }
{    reasons why the executable file might be covered by the GNU Library   }
{    General Public License.                                               }
{                                                                          }
{                                                                          }
{  v1.01, Dec.  2002 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                      http://www.bigfoot.com/~African_Chief/              }
{  v1.02, April 2003 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{  v1.03, May   2003 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{  v1.04, Oct.  2003 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{  v1.05, Aug.  2007 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}
{$R-}

{$ifndef WINPROCS_PAS}
{$ifdef WINDOWS_UNIT}
  {$undef IS_UNIT}
  {$define WINPROCS_PAS}

{$else}
{$ifndef Windows_Inc}  // * * * * * *
   {$define IS_UNIT}

UNIT WINPROCS;

INTERFACE

USES wintypes;
{$endif}
{$endif Windows_Inc}  // * * * * * *

  {$define Stdcall attribute(stdcall)}
  {$define WINAPI(X) external name X; Stdcall}
  {.$define WINAPI(X) asmname X; Stdcall}
  {$X+}
  {$W-}


{ /// asciif.pas ///}
{+// }
{-ASCIIFunctions.h }

{-Declarations for all the Win32 ASCII Functions }

{-Copyright (C) 1996 Free Software Foundation, Inc. }

{-Author: Scott Christley <scottc@net-community.com> }

{-This file is part of the Windows32 API Library. }

{-This library is free software; you can redistribute it and/or }
{-modify it under the terms of the GNU Library General Public }
{-License as published by the Free Software Foundation; either }
{-version 2 of the License, or (at your option) any later version. }

{-This library is distributed in the hope that it will be useful, }
{-but WITHOUT ANY WARRANTY; without even the implied warranty of }
{-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU }
{-Library General Public License for more details. }

{-If you are interested in a warranty or support for this source code, }
{-contact Scott Christley <scottc@net-community.com> for more information. }

{-You should have received a copy of the GNU Library General Public }
{-License along with this library; see the file COPYING.LIB. }
{-If not, write to the Free Software Foundation, }
{-59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. }
{= }

FUNCTION GetBinaryType ( lpApplicationName : PChar;
                        VAR lpBinaryType : DWord ) : WINBOOL; WINAPI ( 'GetBinaryTypeA' );


FUNCTION GetShortPathName ( lpszLongPath : PChar;
                           lpszShortPath : PChar;
                           cchBuffer : DWord ) : DWord; WINAPI ( 'GetShortPathNameA' );


FUNCTION GetEnvironmentStrings : PChar; WINAPI ( 'GetEnvironmentStringsA' );

FUNCTION FreeEnvironmentStrings ( _1 : PChar ) : WINBOOL; WINAPI ( 'FreeEnvironmentStringsA' );

FUNCTION FormatMessage ( dwFlags : DWord;
                        lpSource : POINTER;
                        dwMessageId : DWord;
                        dwLanguageId : DWord;
                        lpBuffer : PChar;
                        nSize : DWord;
                        Arguments : PVA_LIST ) : DWord; WINAPI ( 'FormatMessageA' );


FUNCTION CreateMailslot ( lpName : PChar;
                         nMaxMessageSize : DWord;
                         lReadTimeout : DWord;
                         lpSecurityAttributes : PSECURITY_ATTRIBUTES ) : THandle; WINAPI ( 'CreateMailslotA' );

FUNCTION lstrcmp ( lpString1 : PChar;
                  lpString2 : PChar ) : Integer; WINAPI ( 'lstrcmpA' );


FUNCTION lstrcmpi ( lpString1 : PChar;
                   lpString2 : PChar ) : Integer; WINAPI ( 'lstrcmpiA' );


FUNCTION lstrcpyn ( lpString1 : PChar;
                   lpString2 : PChar;
                   iMaxLength : Integer ) : PChar; WINAPI ( 'lstrcpynA' );


FUNCTION lstrcpy ( lpString1 : PChar;
                  lpString2 : PChar ) : PChar; WINAPI ( 'lstrcpyA' );

FUNCTION lstrcat ( lpString1 : PChar;
                  lpString2 : PChar ) : PChar; WINAPI ( 'lstrcatA' );


FUNCTION lstrlen ( lpString : PChar ) : Integer; WINAPI ( 'lstrlenA' );


FUNCTION CreateMutex ( lpMutexAttributes : PSECURITY_ATTRIBUTES;
                      bInitialOwner : WINBOOL;
                      lpName : PChar ) : THandle; WINAPI ( 'CreateMutexA' );


FUNCTION OpenMutex ( dwDesiredAccess : DWord;
                    bInheritHandle : WINBOOL;
                    lpName : PChar ) : THandle; WINAPI ( 'OpenMutexA' );


FUNCTION CreateEvent ( lpEventAttributes : PSECURITY_ATTRIBUTES;
                      bManualReset : WINBOOL;
                      bInitialState : WINBOOL;
                      lpName : PChar ) : THandle; WINAPI ( 'CreateEventA' );

FUNCTION OpenEvent ( dwDesiredAccess : DWord;
                    bInheritHandle : WINBOOL;
                    lpName : PChar ) : THandle; WINAPI ( 'OpenEventA' );


FUNCTION CreateSemaphore ( lpSemaphoreAttributes : PSECURITY_ATTRIBUTES;
                          lInitialCount : LongInt;
                          lMaximumCount : LongInt;
                          lpName : PChar ) : THandle; WINAPI ( 'CreateSemaphoreA' );


FUNCTION OpenSemaphore ( dwDesiredAccess : DWord;
                        bInheritHandle : WINBOOL;
                        lpName : PChar ) : THandle; WINAPI ( 'OpenSemaphoreA' );


FUNCTION CreateFileMapping ( hFile : THandle;
                            lpFileMappingAttributes : PSECURITY_ATTRIBUTES;
                            flProtect : DWord;
                            dwMaximumSizeHigh : DWord;
                            dwMaximumSizeLow : DWord;
                            lpName : PChar ) : THandle; WINAPI ( 'CreateFileMappingA' );


FUNCTION OpenFileMapping ( dwDesiredAccess : DWord;
                          bInheritHandle : WINBOOL;
                          lpName : PChar ) : THandle; WINAPI ( 'OpenFileMappingA' );


FUNCTION GetLogicalDriveStrings ( nBufferLength : DWord;
                                 lpBuffer : PChar ) : DWord; WINAPI ( 'GetLogicalDriveStringsA' );


FUNCTION LoadLibrary ( lpLibFileName : PChar ) : THANDLE; WINAPI ( 'LoadLibraryA' );


FUNCTION LoadLibraryEx ( lpLibFileName : PChar;
                        hFile : THandle;
                        dwFlags : DWord ) : THANDLE; WINAPI ( 'LoadLibraryExA' );


FUNCTION GetModuleFileName ( hModule : THANDLE;
                            lpFilename : PChar;
                            nSize : DWord ) : DWord; WINAPI ( 'GetModuleFileNameA' );


FUNCTION GetModuleHandle ( lpModuleName : PChar ) : HMODULE; WINAPI ( 'GetModuleHandleA' );


PROCEDURE  FatalAppExit ( uAction : Word;
                       lpMessageText : PChar ); WINAPI ( 'FatalAppExitA' );


FUNCTION GetCommandLine : PChar; WINAPI ( 'GetCommandLineA' );


FUNCTION GetEnvironmentVariable ( lpName : PChar;
                                 lpBuffer : PChar;
                                 nSize : DWord ) : DWord; WINAPI ( 'GetEnvironmentVariableA' );


FUNCTION SetEnvironmentVariable ( lpName : PChar;
                                 lpValue : PChar ) : WINBOOL; WINAPI ( 'SetEnvironmentVariableA' );


FUNCTION ExpandEnvironmentStrings ( lpSrc : PChar;
                                   lpDst : PChar;
                                   nSize : DWord ) : DWord; WINAPI ( 'ExpandEnvironmentStringsA' );


PROCEDURE  OutputDebugString ( lpOutputString : PChar ); WINAPI ( 'OutputDebugStringA' );


FUNCTION FindResource ( hModule : THANDLE;
                       lpName : PChar;
                       lpType : PChar ) : HRSRC; WINAPI ( 'FindResourceA' );


FUNCTION FindResourceEx ( hModule : THANDLE;
                         lpType : PChar;
                         lpName : PChar;
                         wLanguage : Word ) : HRSRC; WINAPI ( 'FindResourceExA' );


FUNCTION EnumResourceTypes ( hModule : THANDLE;
                            lpEnumFunc : ENUMRESTYPEPROC;
                            lParam : LongInt ) : WINBOOL; WINAPI ( 'EnumResourceTypesA' );


FUNCTION EnumResourceNames ( hModule : THANDLE;
                            lpType : PChar;
                            lpEnumFunc : ENUMRESNAMEPROC;
                            lParam : LongInt ) : WINBOOL; WINAPI ( 'EnumResourceNamesA' );


FUNCTION EnumResourceLanguages ( hModule : THANDLE;
                                lpType : PChar;
                                lpName : PChar;
                                lpEnumFunc : ENUMRESLANGPROC;
                                lParam : LongInt ) : WINBOOL; WINAPI ( 'EnumResourceLanguagesA' );


FUNCTION BeginUpdateResource ( pFileName : PChar;
                              bDeleteExistingResources : WINBOOL ) : THandle; WINAPI ( 'BeginUpdateResourceA' );


FUNCTION UpdateResource ( hUpdate : THandle;
                         lpType : PChar;
                         lpName : PChar;
                         wLanguage : Word;
                         VAR lpData;
                         cbData : DWord ) : WINBOOL; WINAPI ( 'UpdateResourceA' );


FUNCTION EndUpdateResource ( hUpdate : THandle;
                            fDiscard : WINBOOL ) : WINBOOL; WINAPI ( 'EndUpdateResourceA' );


FUNCTION GlobalAddAtom ( lpString : PChar ) : TAtom; WINAPI ( 'GlobalAddAtomA' );


FUNCTION GlobalFindAtom ( lpString : PChar ) : TAtom; WINAPI ( 'GlobalFindAtomA' );


FUNCTION GlobalGetAtomName ( nAtom : TAtom;
                            lpBuffer : PChar;
                            nSize : Integer ) : Word; WINAPI ( 'GlobalGetAtomNameA' );

FUNCTION AddAtom ( lpString : PChar ) : TAtom; WINAPI ( 'AddAtomA' );


FUNCTION FindAtom ( lpString : PChar ) : TAtom; WINAPI ( 'FindAtomA' );


FUNCTION GetAtomName ( nAtom : TAtom;
                      lpBuffer : PChar;
                      nSize : Integer ) : Word; WINAPI ( 'GetAtomNameA' );


FUNCTION GetProfileInt ( lpAppName : PChar;
                        lpKeyName : PChar;
                        nDefault : Integer ) : Word; WINAPI ( 'GetProfileIntA' );


FUNCTION GetProfileString ( lpAppName : PChar;
                           lpKeyName : PChar;
                           lpDefault : PChar;
                           lpReturnedString : PChar;
                           nSize : DWord ) : DWord; WINAPI ( 'GetProfileStringA' );


FUNCTION WriteProfileString ( lpAppName : PChar;
                             lpKeyName : PChar;
                             lpString : PChar ) : WINBOOL; WINAPI ( 'WriteProfileStringA' );


FUNCTION GetProfileSection ( lpAppName : PChar;
                            lpReturnedString : PChar;
                            nSize : DWord ) : DWord; WINAPI ( 'GetProfileSectionA' );


FUNCTION WriteProfileSection ( lpAppName : PChar;
                              lpString : PChar ) : WINBOOL; WINAPI ( 'WriteProfileSectionA' );


FUNCTION GetPrivateProfileInt ( lpAppName : PChar;
                               lpKeyName : PChar;
                               nDefault : Integer;
                               lpFileName : PChar ) : Word; WINAPI ( 'GetPrivateProfileIntA' );


FUNCTION GetPrivateProfileString ( lpAppName : PChar;
                                  lpKeyName : PChar;
                                  lpDefault : PChar;
                                  lpReturnedString : PChar;
                                  nSize : DWord;
                                  lpFileName : PChar ) : DWord; WINAPI ( 'GetPrivateProfileStringA' );


FUNCTION WritePrivateProfileString ( lpAppName : PChar;
                                    lpKeyName : PChar;
                                    lpString : PChar;
                                    lpFileName : PChar ) : WINBOOL; WINAPI ( 'WritePrivateProfileStringA' );


FUNCTION GetPrivateProfileSection ( lpAppName : PChar;
                                   lpReturnedString : PChar;
                                   nSize : DWord;
                                   lpFileName : PChar ) : DWord; WINAPI ( 'GetPrivateProfileSectionA' );


FUNCTION WritePrivateProfileSection ( lpAppName : PChar;
                                     lpString : PChar;
                                     lpFileName : PChar ) : WINBOOL; WINAPI ( 'WritePrivateProfileSectionA' );


FUNCTION GetDriveType ( lpRootPathName : PChar ) : Word; WINAPI ( 'GetDriveTypeA' );


FUNCTION GetSystemDirectory ( lpBuffer : PChar;
                             uSize : Word ) : Word; WINAPI ( 'GetSystemDirectoryA' );


FUNCTION GetTempPath ( nBufferLength : DWord;
                      lpBuffer : PChar ) : DWord; WINAPI ( 'GetTempPathA' );


FUNCTION GetTempFileName ( lpPathName : PChar;
                          lpPrefixString : PChar;
                          uUnique : Word;
                          lpTempFileName : PChar ) : Word; WINAPI ( 'GetTempFileNameA' );


FUNCTION GetWindowsDirectory ( lpBuffer : PChar;
                              uSize : Word ) : Word; WINAPI ( 'GetWindowsDirectoryA' );


FUNCTION SetCurrentDirectory ( lpPathName : PChar ) : WINBOOL; WINAPI ( 'SetCurrentDirectoryA' );


FUNCTION GetCurrentDirectory ( nBufferLength : DWord;
                              lpBuffer : PChar ) : DWord; WINAPI ( 'GetCurrentDirectoryA' );


FUNCTION GetDiskFreeSpace ( lpRootPathName : PChar;
                           VAR lpSectorsPerCluster,
                           lpBytesPerSector,
                           lpNumberOfFreeClusters,
                           lpTotalNumberOfClusters : DWord ) : WINBOOL; WINAPI ( 'GetDiskFreeSpaceA' );


FUNCTION CreateDirectory ( lpPathName : PChar;
                          lpSecurityAttributes : PSECURITY_ATTRIBUTES ) : WINBOOL; WINAPI ( 'CreateDirectoryA' );


FUNCTION CreateDirectoryEx ( lpTemplateDirectory : PChar;
                            lpNewDirectory : PChar;
                            lpSecurityAttributes : PSECURITY_ATTRIBUTES ) : WINBOOL; WINAPI ( 'CreateDirectoryExA' );

FUNCTION RemoveDirectory ( lpPathName : PChar ) : WINBOOL; WINAPI ( 'RemoveDirectoryA' );


FUNCTION GetFullPathName ( lpFileName : PChar;
                          nBufferLength : DWord;
                          lpBuffer : PChar;
                          lpFilePart : PPChar ) : DWord; WINAPI ( 'GetFullPathNameA' );

FUNCTION DefineDosDevice ( dwFlags : DWord;
                          lpDeviceName : PChar;
                          lpTargetPath : PChar ) : WINBOOL; WINAPI ( 'DefineDosDeviceA' );

FUNCTION QueryDosDevice ( lpDeviceName : PChar;
                         lpTargetPath : PChar;
                         ucchMax : DWord ) : DWord; WINAPI ( 'QueryDosDeviceA' );

FUNCTION CreateFile ( lpFileName : PChar;
                     dwDesiredAccess : DWord;
                     dwShareMode : DWord;
                     lpSecurityAttributes : PSECURITY_ATTRIBUTES;
                     dwCreationDisposition : DWord;
                     dwFlagsAndAttributes : DWord;
                     hTemplateFile : THandle ) : THandle; WINAPI ( 'CreateFileA' );


FUNCTION SetFileAttributes ( lpFileName : PChar;
                            dwFileAttributes : DWord ) : WINBOOL; WINAPI ( 'SetFileAttributesA' );


FUNCTION GetFileAttributes ( lpFileName : PChar ) : DWord; WINAPI ( 'GetFileAttributesA' );


FUNCTION GetCompressedFileSize ( lpFileName : PChar;
                                VAR lpFileSizeHigh : DWord ) : DWord; WINAPI ( 'GetCompressedFileSizeA' );


FUNCTION DeleteFile ( lpFileName : PChar ) : WINBOOL; WINAPI ( 'DeleteFileA' );


FUNCTION SearchPath ( lpPath : PChar;
                     lpFileName : PChar;
                     lpExtension : PChar;
                     nBufferLength : DWord;
                     lpBuffer : PChar;
                     lpFilePart : PPChar ) : DWord; WINAPI ( 'SearchPathA' );


FUNCTION CopyFile ( lpExistingFileName : PChar;
                   lpNewFileName : PChar;
                   bFailIfExists : WINBOOL ) : WINBOOL; WINAPI ( 'CopyFileA' );


FUNCTION MoveFile ( lpExistingFileName : PChar;
                   lpNewFileName : PChar ) : WINBOOL; WINAPI ( 'MoveFileA' );


FUNCTION MoveFileEx ( lpExistingFileName : PChar;
                     lpNewFileName : PChar;
                     dwFlags : DWord ) : WINBOOL; WINAPI ( 'MoveFileExA' );


FUNCTION CreateNamedPipe ( lpName : PChar;
                          dwOpenMode : DWord;
                          dwPipeMode : DWord;
                          nMaxInstances : DWord;
                          nOutBufferSize : DWord;
                          nInBufferSize : DWord;
                          nDefaultTimeOut : DWord;
                          lpSecurityAttributes : PSECURITY_ATTRIBUTES ) : THandle; WINAPI ( 'CreateNamedPipeA' );


FUNCTION GetNamedPipeHandleState ( hNamedPipe : THandle;
                                  VAR lpState,
                                  lpCurInstances,
                                  lpMaxCollectionCount,
                                  lpCollectDataTimeout : DWord;
                                  lpUserName : PChar;
                                  nMaxUserNameSize : DWord ) : WINBOOL; WINAPI ( 'GetNamedPipeHandleStateA' );


FUNCTION CallNamedPipe ( lpNamedPipeName : PChar;
                        lpInBuffer : POINTER;
                        nInBufferSize : DWord;
                        VAR lpOutBuffer;
                        nOutBufferSize : DWord;
                        VAR lpBytesRead : DWord;
                        nTimeOut : DWord ) : WINBOOL; WINAPI ( 'CallNamedPipeA' );


FUNCTION WaitNamedPipe ( lpNamedPipeName : PChar;
                        nTimeOut : DWord ) : WINBOOL; WINAPI ( 'WaitNamedPipeA' );


FUNCTION SetVolumeLabel ( lpRootPathName : PChar;
                         lpVolumeName : PChar ) : WINBOOL; WINAPI ( 'SetVolumeLabelA' );


FUNCTION GetVolumeInformation ( lpRootPathName : PChar;
                               lpVolumeNameBuffer : PChar;
                               nVolumeNameSize : DWord;
                               VAR lpVolumeSerialNumber,
                               lpMaximumComponentLength,
                               lpFileSystemFlags : DWord;
                               lpFileSystemNameBuffer : PChar;
                               nFileSystemNameSize : DWord ) : WINBOOL; WINAPI ( 'GetVolumeInformationA' );

FUNCTION ClearEventLog ( hEventLog : THandle;
                        lpBackupFileName : PChar ) : WINBOOL; WINAPI ( 'ClearEventLogA' );

FUNCTION TrackMouseEvent ( VAR anEvent : TTRACKMOUSEEVENT ) : WINBOOL; WINAPI ( 'TrackMouseEvent' );

FUNCTION BackupEventLog ( hEventLog : THandle;
                         lpBackupFileName : PChar ) : WINBOOL; WINAPI ( 'BackupEventLogA' );


FUNCTION OpenEventLog ( lpUNCServerName : PChar;
                       lpSourceName : PChar ) : THandle; WINAPI ( 'OpenEventLogA' );


FUNCTION RegisterEventSource ( lpUNCServerName : PChar;
                              lpSourceName : PChar ) : THandle; WINAPI ( 'RegisterEventSourceA' );


FUNCTION OpenBackupEventLog ( lpUNCServerName : PChar;
                             lpFileName : PChar ) : THandle; WINAPI ( 'OpenBackupEventLogA' );

FUNCTION ReadEventLog ( hEventLog : THandle;
                       dwReadFlags : DWord;
                       dwRecordOffset : DWord;
                       VAR lpBuffer;
                       nNumberOfBytesToRead : DWord;
                       VAR pnBytesRead,
                       pnMinNumberOfBytesNeeded : DWord ) : WINBOOL; WINAPI ( 'ReadEventLogA' );

FUNCTION ReportEvent ( hEventLog : THandle;
                      wType : Word;
                      wCategory : Word;
                      dwEventID : DWord;
                      lpUserSid : PSID;
                      wNumStrings : Word;
                      dwDataSize : DWord;
                      lpStrings : PPCHAR;
                      lpRawData : POINTER ) : WINBOOL; WINAPI ( 'ReportEventA' );


FUNCTION AccessCheckAndAuditAlarm ( SubsystemName : PChar;
                                   HandleId : POINTER;
                                   ObjectTypeName : PChar;
                                   ObjectName : PChar;
                                   VAR SecurityDescriptor : TSECURITY_DESCRIPTOR;
                                   DesiredAccess : DWord;
                                   VAR GenericMapping : TGENERIC_MAPPING;
                                   ObjectCreation : WINBOOL;
                                   VAR GrantedAccess : DWord;
                                   hAccessStatus : WinBool;
                                   VAR pfGenerateOnClose : WinBool
                                   ) : WINBOOL; WINAPI ( 'AccessCheckAndAuditAlarmA' );

FUNCTION ObjectOpenAuditAlarm ( SubsystemName : PChar;
                               HandleId : POINTER;
                               ObjectTypeName : PChar;
                               ObjectName : PChar;
                               VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                               ClientToken : THandle;
                               DesiredAccess : DWord;
                               GrantedAccess : DWord;
                               VAR Privileges : TPRIVILEGE_SET;
                               ObjectCreation, AccessGranted : WinBool;
                               VAR GenerateOnClose : WinBool
                               ) : WINBOOL; WINAPI ( 'ObjectOpenAuditAlarmA' );

FUNCTION ObjectPrivilegeAuditAlarm ( SubsystemName : PChar;
                                    HandleId : POINTER;
                                    ClientToken : THandle;
                                    DesiredAccess : DWord;
                                    VAR Privileges : TPRIVILEGE_SET;
                                    AccessGranted : WINBOOL ) : WINBOOL; WINAPI ( 'ObjectPrivilegeAuditAlarmA' );


FUNCTION ObjectCloseAuditAlarm ( SubsystemName : PChar;
                                HandleId : POINTER;
                                GenerateOnClose : WINBOOL ) : WINBOOL; WINAPI ( 'ObjectCloseAuditAlarmA' );

FUNCTION PrivilegedServiceAuditAlarm ( SubsystemName : PChar;
                                      ServiceName : PChar;
                                      ClientToken : THandle;
                                      Privileges : PPRIVILEGE_SET;
                                      AccessGranted : WINBOOL ) : WINBOOL; WINAPI ( 'PrivilegedServiceAuditAlarmA' );

FUNCTION SetFileSecurity ( lpFileName : PChar;
                          SecurityInformation : SECURITY_INFORMATION;
                          VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'SetFileSecurityA' );

FUNCTION GetFileSecurity ( lpFileName : PChar;
                          RequestedInformation : SECURITY_INFORMATION;
                          VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                          nLength : DWord;
                          VAR lpnLengthNeeded : DWord ) : WINBOOL; WINAPI ( 'GetFileSecurityA' );

FUNCTION FindFirstChangeNotification ( lpPathName : PChar;
                                      bWatchSubtree : WINBOOL;
                                      dwNotifyFilter : DWord ) : THandle; WINAPI ( 'FindFirstChangeNotificationA' );

FUNCTION IsBadStringPtr ( lpsz : PChar;
                         ucchMax : Word ) : WINBOOL; WINAPI ( 'IsBadStringPtrA' );


FUNCTION LookupAccountSid ( lpSystemName : PChar;
                           VAR Sid : SID;
                           Name : PChar;
                           VAR cbName : DWord;
                           ReferencedDomainName : PChar;
                           VAR cbReferencedDomainName : DWord;
                           VAR peUse : TSID_NAME_USE ) : WINBOOL; WINAPI ( 'LookupAccountSidA' );

FUNCTION LookupAccountName ( lpSystemName : PChar;
                            lpAccountName : PChar;
                            VAR Sid : SID;
                            VAR cbSid : DWord;
                            ReferencedDomainName : PChar;
                            VAR cbReferencedDomainName : DWord;
                            VAR peUse : TSID_NAME_USE ) : WINBOOL; WINAPI ( 'LookupAccountNameA' );

FUNCTION LookupPrivilegeValue ( lpSystemName : PChar;
                               lpName : PChar;
                               lpLuid : PLUID ) : WINBOOL; WINAPI ( 'LookupPrivilegeValueA' );


FUNCTION LookupPrivilegeName ( lpSystemName : PChar;
                              lpLuid : PLUID;
                              lpName : PChar;
                              VAR cbName : DWord ) : WINBOOL; WINAPI ( 'LookupPrivilegeNameA' );

FUNCTION LookupPrivilegeDisplayName ( lpSystemName : PChar;
                                     lpName : PChar;
                                     lpDisplayName : PChar;
                                     VAR cbDisplayName,
                                     lpLanguageId : DWord ) : WINBOOL; WINAPI ( 'LookupPrivilegeDisplayNameA' );

FUNCTION BuildCommDCB ( lpDef : PChar;
                       VAR lpDCB : TDCB ) : WINBOOL; WINAPI ( 'BuildCommDCBA' );

FUNCTION BuildCommDCBAndTimeouts ( lpDef : PChar;
                                  VAR lpDCB : TDCB;
                                  VAR lpCommTimeouts : TCOMMTIMEOUTS ) : WINBOOL; WINAPI ( 'BuildCommDCBAndTimeoutsA' );

FUNCTION CommConfigDialog ( lpszName : PChar;
                           Wnd : HWND;
                           VAR lpCC : TCOMMCONFIG ) : WINBOOL; WINAPI ( 'CommConfigDialogA' );

FUNCTION GetDefaultCommConfig ( lpszName : PChar;
                               VAR lpCC : TCOMMCONFIG;
                               VAR lpdwSize : DWord ) : WINBOOL; WINAPI ( 'GetDefaultCommConfigA' );

FUNCTION SetDefaultCommConfig ( lpszName : PChar;
                               VAR lpCC : TCOMMCONFIG;
                               dwSize : DWord ) : WINBOOL; WINAPI ( 'SetDefaultCommConfigA' );

FUNCTION GetComputerName ( lpBuffer : PChar;
                          VAR nSize : DWord ) : WINBOOL; WINAPI ( 'GetComputerNameA' );

FUNCTION SetComputerName ( lpComputerName : PChar ) : WINBOOL; WINAPI ( 'SetComputerNameA' );


FUNCTION GetUserName ( lpBuffer : PChar;
                      VAR nSize : DWord ) : WINBOOL; WINAPI ( 'GetUserNameA' );

FUNCTION wvsprintf ( _1 : PChar;
                    _2 : PChar;
                    arglist : VA_LIST ) : Integer; WINAPI ( 'wvsprintfA' );

FUNCTION wsprintf ( _1 : PChar;
                   _2 : PChar;
                   _3 : pchar ) : Integer; WINAPI ( 'wsprintfA' );


FUNCTION LoadKeyboardLayout ( pwszKLID : PChar;
                             Flags : Word ) : HKL; WINAPI ( 'LoadKeyboardLayoutA' );


FUNCTION GetKeyboardLayoutName ( pwszKLID : PChar ) : WINBOOL; WINAPI ( 'GetKeyboardLayoutNameA' );


FUNCTION CreateDesktop ( lpszDesktop : PChar;
                        lpszDevice : PChar;
                        pDevmode : PDEVMODE;
                        dwFlags : DWord;
                        dwDesiredAccess : DWord;
                        lpsa : PSECURITY_ATTRIBUTES ) : HDESK; WINAPI ( 'CreateDesktopA' );

FUNCTION OpenDesktop ( lpszDesktop : PChar;
                      dwFlags : DWord;
                      fInherit : WINBOOL;
                      dwDesiredAccess : DWord ) : HDESK; WINAPI ( 'OpenDesktopA' );

FUNCTION EnumDesktops ( winsta : HWINSTA;
                       lpEnumFunc : DESKTOPENUMPROC;
                       lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumDesktopsA' );


FUNCTION CreateWindowStation ( lpwinsta : PChar;
                              dwReserved : DWord;
                              dwDesiredAccess : DWord;
                              lpsa : PSECURITY_ATTRIBUTES ) : HWINSTA; WINAPI ( 'CreateWindowStationA' );

FUNCTION OpenWindowStation ( lpszWinSta : PChar;
                            fInherit : WINBOOL;
                            dwDesiredAccess : DWord ) : HWINSTA; WINAPI ( 'OpenWindowStationA' );


FUNCTION EnumWindowStations ( lpEnumFunc : ENUMWINDOWSTATIONPROC;
                             lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumWindowStationsA' );

FUNCTION GetUserObjectInformation ( hObj : THandle;
                                   nIndex : Integer;
                                   VAR pvInfo;
                                   nLength : DWord;
                                   VAR lpnLengthNeeded : DWord ) : WINBOOL; WINAPI ( 'GetUserObjectInformationA' );

FUNCTION SetUserObjectInformation ( hObj : THandle;
                                   nIndex : Integer;
                                   VAR pvInfo;
                                   nLength : DWord ) : WINBOOL; WINAPI ( 'SetUserObjectInformationA' );

FUNCTION RegisterWindowMessage ( lpString : PChar ) : Word; WINAPI ( 'RegisterWindowMessageA' );

FUNCTION GetMessage ( VAR lpMsg : TMSG;
                     Wnd : HWND;
                     wMsgFilterMin : Word;
                     wMsgFilterMax : Word ) : WINBOOL; WINAPI ( 'GetMessageA' );


FUNCTION DispatchMessage ( CONST lpMsg :  MSG ) : LongInt; WINAPI ( 'DispatchMessageA' );


FUNCTION PeekMessage ( VAR lpMsg : TMSG;
                      Wnd : HWND;
                      wMsgFilterMin : Word;
                      wMsgFilterMax : Word;
                      wRemoveMsg : Word ) : WINBOOL; WINAPI ( 'PeekMessageA' );


FUNCTION SendMessage ( Wnd : HWND;
                      Msg : Word;
                      wParam : UINT;
                      lParam : LPARAM32 ) : LRESULT; WINAPI ( 'SendMessageA' );


FUNCTION SendMessageTimeout ( Wnd : HWND;
                             Msg : Word;
                             wParam : UINT;
                             lParam : LPARAM32;
                             fuFlags : Word;
                             uTimeout : Word;
                             VAR lpdwResult : DWord ) : LRESULT; WINAPI ( 'SendMessageTimeoutA' );

FUNCTION SendNotifyMessage ( Wnd : HWND;
                            Msg : Word;
                            wParam : UINT;
                            lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'SendNotifyMessageA' );

FUNCTION SendMessageCallback ( Wnd : HWND;
                              Msg : Word;
                              wParam : UINT;
                              lParam : LPARAM32;
                              lpResultCallBack : SENDASYNCPROC;
                              dwData : DWord ) : WINBOOL; WINAPI ( 'SendMessageCallbackA' );

FUNCTION PostMessage ( Wnd : HWND;
                      Msg : Word;
                      wParam : UINT;
                      lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'PostMessageA' );

FUNCTION PostThreadMessage ( idThread : DWord;
                            Msg : Word;
                            wParam : UINT;
                            lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'PostThreadMessageA' );

FUNCTION DefWindowProc ( Wnd : HWND;
                         Msg : UINT;
                         wParam : Wparam32;
                         lParam : LPARAM32 ) : LRESULT; WINAPI ( 'DefWindowProcA' );

FUNCTION CallWindowProc ( lpPrevWndFunc : WNDPROC;
                          Wnd : HWND;
                          Msg : UINT;
                          wParam : WParam32;
                          lParam : LPARAM32 ) : LRESULT; WINAPI ( 'CallWindowProcA' );


FUNCTION RegisterClass ( CONST lpWndClass :  WNDCLASS ) : TAtom; WINAPI ( 'RegisterClassA' );

FUNCTION RegisterClassEx ( CONST lpWndClass :  WNDCLASSEx ) : TAtom; WINAPI ( 'RegisterClassExA' );


FUNCTION UnregisterClass ( lpClassName : PChar;
                          xInstance : THANDLE ) : WINBOOL; WINAPI ( 'UnregisterClassA' );

FUNCTION GetClassInfo ( xInstance : THANDLE;
                       lpClassName : PChar;
                       VAR lpWndClass : TWNDCLASS ) : WINBOOL; WINAPI ( 'GetClassInfoA' );

FUNCTION GetClassInfoEx ( _1 : THANDLE;
                         _2 : PChar;
                         _3 : PWNDCLASSEX ) : WINBOOL; WINAPI ( 'GetClassInfoExA' );


FUNCTION CreateWindowEx ( dwExStyle : DWord;
                         lpClassName : PChar;
                         lpWindowName : PChar;
                         dwStyle : DWord;
                         X : Integer;
                         Y : Integer;
                         nWidth : Integer;
                         nHeight : Integer;
                         hWndParent : HWND;
                         hMenu : HMENU;
                         xInstance : THANDLE;
                         lpParam : POINTER ) : HWND; WINAPI ( 'CreateWindowExA' );

{$if defined(IS_UNIT) or defined(WINDOWS_UNIT)}
PROCEDURE ZeroMemory ( Destination : Pointer;
                    Length : DWord );

FUNCTION CreateWindow ( lpClassName : PChar; lpWindowName : PChar;
  dwStyle : DWord; X, Y, nWidth, nHeight : DWord; hWndParent : hWnd;
  hMenu : hMenu; xInstance : THandle; lpParam : Pointer ) : hWnd;

FUNCTION DialogBox ( xInstance : THANDLE;
                     lpTemplateName : PChar;
                     hWndParent : HWND;
                     lpDialogFunc : DLGPROC ) : Integer;


FUNCTION hInstance : THandle;  { extra: mimics Delphi's System.hInstance }
FUNCTION MainInstance : THandle;  { extra: mimics FreePascal's System.hInstance }
PROCEDURE FreeProcInstance ( Proc : TFarProc );
FUNCTION  MakeProcInstance ( TProc : TFARPROC; Instance : THandle ) : TFARPROC;
FUNCTION  FreeModule ( h : THandle ) : WinBool;

FUNCTION Declare_Handle ( CONST s ) : THandle;
FUNCTION GetBvalue ( i : integer ) : byte;
FUNCTION GetGvalue ( i : integer ) : byte;
FUNCTION GetRvalue ( i : integer ) : byte;
FUNCTION RGB ( r, g, b : byte ) : dword;
FUNCTION HiByte ( w : word ) : byte;
FUNCTION LoByte ( w : word ) : byte;
FUNCTION HiWord ( l : dword ) : word;
FUNCTION LoWord ( l : dword ) : word;
FUNCTION MakeLong ( a, b : Word ) : dword;
FUNCTION MakeWord ( a, b : byte ) : Word;
FUNCTION MakeLParam ( a, b : Word ) : LParam32;
FUNCTION MakeWParam ( a, b : Word ) : WParam32;
FUNCTION MakeLResult ( a, b : Word ) : LResult;
FUNCTION MakeRop4 ( fore, back : integer ) : dword;
FUNCTION INDEXTOOVERLAYMASK ( i : integer ) : integer;
FUNCTION INDEXTOSTATEIMAGEMASK ( i : integer ) : integer;
FUNCTION MAKEINTATOM ( i : integer ) : pChar;
FUNCTION MAKELANGID ( p, s : word ) : word;
FUNCTION PRIMARYLANGID ( algid : lgid ) : word ;
FUNCTION SUBLANGID ( algid : lgid ) : word;
FUNCTION LANGIDFROMLCID ( alcid : lcid ) : word;
FUNCTION SORTIDFROMLCID ( alcid : lcid ) : word;
FUNCTION MAKELCID ( algid, asrtid : lgid ) : dword;
FUNCTION SEXT_HIWORD ( l : integer ) : integer;
FUNCTION ZEXT_HIWORD ( l : word ) : integer;
FUNCTION SEXT_LOWORD ( l : SmallInt ) : integer;

{$endif}{IS_UNIT || windows_unit}

FUNCTION CreateDialogParam ( xInstance : THANDLE;
                            lpTemplateName : PChar;
                            hWndParent : HWND;
                            lpDialogFunc : DLGPROC;
                            dwInitParam : LPARAM32 ) : HWND; WINAPI ( 'CreateDialogParamA' );


FUNCTION CreateDialogIndirectParam ( xInstance : THANDLE;
                                    VAR lpTemplate : DLGTEMPLATE;
                                    hWndParent : HWND;
                                    lpDialogFunc : DLGPROC;
                                    dwInitParam : LPARAM32 ) : HWND; WINAPI ( 'CreateDialogIndirectParamA' );


FUNCTION DialogBoxParam ( xInstance : THANDLE;
                         lpTemplateName : PChar;
                         hWndParent : HWND;
                         lpDialogFunc : DLGPROC;
                         dwInitParam : LPARAM32 ) : Integer; WINAPI ( 'DialogBoxParamA' );


FUNCTION DialogBoxIndirectParam ( xInstance : THANDLE;
                                 VAR hDialogTemplate : DLGTEMPLATE;
                                 hWndParent : HWND;
                                 lpDialogFunc : DLGPROC;
                                 dwInitParam : LPARAM32 ) : Integer; WINAPI ( 'DialogBoxIndirectParamA' );


FUNCTION SetDlgItemText ( hDlg : HWND;
                         nIDDlgItem : Integer;
                         lpString : PChar ) : WINBOOL; WINAPI ( 'SetDlgItemTextA' );

FUNCTION GetDlgItemText ( hDlg : HWND;
                         nIDDlgItem : Integer;
                         lpString : PChar;
                         nMaxCount : Integer ) : Word; WINAPI ( 'GetDlgItemTextA' );

FUNCTION SendDlgItemMessage ( hDlg : HWND;
                             nIDDlgItem : Integer;
                             Msg : UINT;
                             wParam : WPARAM32;
                             lParam : LPARAM32 ) : LongInt; WINAPI ( 'SendDlgItemMessageA' );

FUNCTION DefDlgProc ( hDlg : HWND;
                      Msg  : UINT;
                      wParam : WPARAM32;
                      lParam : LPARAM32 ) : LRESULT; WINAPI ( 'DefDlgProcA' );

FUNCTION CallMsgFilter ( VAR Msg : TMSG;
                        nCode : Integer ) : WINBOOL; WINAPI ( 'CallMsgFilterA' );


FUNCTION RegisterClipboardFormat ( lpszFormat : PChar ) : Word; WINAPI ( 'RegisterClipboardFormatA' );

FUNCTION GetClipboardFormatName ( format : Word;
                                 lpszFormatName : PChar;
                                 cchMaxCount : Integer ) : Integer; WINAPI ( 'GetClipboardFormatNameA' );

FUNCTION CharToOem ( lpszSrc : PChar;
                    lpszDst : PChar ) : WINBOOL; WINAPI ( 'CharToOemA' );

FUNCTION OemToChar ( lpszSrc : PChar;
                    lpszDst : PChar ) : WINBOOL; WINAPI ( 'OemToCharA' );

FUNCTION CharToOemBuff ( lpszSrc : PChar;
                        lpszDst : PChar;
                        cchDstLength : DWord ) : WINBOOL; WINAPI ( 'CharToOemBuffA' );

FUNCTION OemToCharBuff ( lpszSrc : PChar;
                        lpszDst : PChar;
                        cchDstLength : DWord ) : WINBOOL; WINAPI ( 'OemToCharBuffA' );


FUNCTION CharUpper ( lpsz : PChar ) : PChar; WINAPI ( 'CharUpperA' );
FUNCTION AnsiUpper ( lpsz : PChar ) : PChar; WINAPI ( 'CharUpperA' );

FUNCTION CharUpperBuff ( lpsz : PChar;
                        cchLength : DWord ) : DWord; WINAPI ( 'CharUpperBuffA' );
FUNCTION AnsiUpperBuff ( lpsz : PChar;
                        cchLength : DWord ) : DWord; WINAPI ( 'CharUpperBuffA' );

FUNCTION CharLower ( lpsz : PChar ) : PChar; WINAPI ( 'CharLowerA' );
FUNCTION AnsiLower ( lpsz : PChar ) : PChar; WINAPI ( 'CharLowerA' );

FUNCTION CharLowerBuff ( lpsz : PChar;
                        cchLength : DWord ) : DWord; WINAPI ( 'CharLowerBuffA' );
FUNCTION AnsiLowerBuff ( lpsz : PChar;
                        cchLength : DWord ) : DWord; WINAPI ( 'CharLowerBuffA' );

FUNCTION CharNext ( lpsz : PChar ) : PChar; WINAPI ( 'CharNextA' );

FUNCTION CharPrev ( lpszStart : PChar;
                   lpszCurrent : PChar ) : PChar; WINAPI ( 'CharPrevA' );

FUNCTION IsCharAlpha ( ch : Char ) : WINBOOL; WINAPI ( 'IsCharAlphaA' );

FUNCTION IsCharAlphaNumeric ( ch : Char ) : WINBOOL; WINAPI ( 'IsCharAlphaNumericA' );

FUNCTION IsCharUpper ( ch : Char ) : WINBOOL; WINAPI ( 'IsCharUpperA' );

FUNCTION IsCharLower ( ch : Char ) : WINBOOL; WINAPI ( 'IsCharLowerA' );

FUNCTION GetKeyNameText ( lParam : LongInt;
                         lpString : PChar;
                         nSize : Integer ) : Integer; WINAPI ( 'GetKeyNameTextA' );

FUNCTION VkKeyScan ( ch : Char ) : SmallInt; WINAPI ( 'VkKeyScanA' );

FUNCTION VkKeyScanEx ( ch : Char;
                      dwhkl : HKL ) : SmallInt; WINAPI ( 'VkKeyScanExA' );


FUNCTION MapVirtualKey ( uCode : Word;
                        uMapType : Word ) : Word; WINAPI ( 'MapVirtualKeyA' );


FUNCTION MapVirtualKeyEx ( uCode : Word;
                          uMapType : Word;
                          dwhkl : HKL ) : Word; WINAPI ( 'MapVirtualKeyExA' );

FUNCTION LoadAccelerators ( xInstance : THANDLE;
                           lpTableName : PChar ) : HACCEL; WINAPI ( 'LoadAcceleratorsA' );

FUNCTION CreateAcceleratorTable ( _1 : PACCEL;
                                 _2 : Integer ) : HACCEL; WINAPI ( 'CreateAcceleratorTableA' );

FUNCTION CopyAcceleratorTable ( hAccelSrc : HACCEL;
                               lpAccelDst : PACCEL;
                               cAccelEntries : Integer ) : Integer; WINAPI ( 'CopyAcceleratorTableA' );

FUNCTION TranslateAccelerator ( Wnd : HWND;
                               hAccTable : HACCEL;
                               VAR lpMsg : TMSG ) : Integer; WINAPI ( 'TranslateAcceleratorA' );


FUNCTION LoadMenu ( xInstance : THANDLE;
                   lpMenuName : PChar ) : HMENU; WINAPI ( 'LoadMenuA' );

FUNCTION LoadMenuIndirect ( CONST lpMenuTemplate :  MENUTEMPLATE ) : HMENU; WINAPI ( 'LoadMenuIndirectA' );


FUNCTION ChangeMenu ( Menu : HMENU;
                     cmd : Word;
                     lpszNewItem : PChar;
                     cmdInsert : Word;
                     flags : Word ) : WINBOOL; WINAPI ( 'ChangeMenuA' );

FUNCTION GetMenuString ( Menu : HMENU;
                        uIDItem : Word;
                        lpString : PChar;
                        nMaxCount : Integer;
                        uFlag : Word ) : Integer; WINAPI ( 'GetMenuStringA' );

FUNCTION InsertMenu ( Menu : HMENU;
                     uPosition : Word;
                     uFlags : Word;
                     uIDNewItem : Word;
                     lpNewItem : PChar ) : WINBOOL; WINAPI ( 'InsertMenuA' );


FUNCTION AppendMenu ( Menu : HMENU;
                     uFlags : UINT;
                     uIDNewItem : UINT;
                     lpNewItem : PChar ) : WINBOOL; WINAPI ( 'AppendMenuA' );


FUNCTION ModifyMenu ( hMnu : HMENU;
                     uPosition : Word;
                     uFlags : Word;
                     uIDNewItem : Word;
                     lpNewItem : PChar ) : WINBOOL; WINAPI ( 'ModifyMenuA' );


FUNCTION InsertMenuItem ( _1 : HMENU;
                         _2 : Word;
                         _3 : WINBOOL;
                         _4 : LPMENUITEMINFO ) : WINBOOL; WINAPI ( 'InsertMenuItemA' );


FUNCTION GetMenuItemInfo ( _1 : HMENU;
                          _2 : Word;
                          _3 : WINBOOL;
                          VAR _4 : TMENUITEMINFO ) : WINBOOL; WINAPI ( 'GetMenuItemInfoA' );


FUNCTION SetMenuItemInfo ( _1 : HMENU;
                          _2 : Word;
                          _3 : WINBOOL;
                          VAR _4 : TMENUITEMINFO ) : WINBOOL; WINAPI ( 'SetMenuItemInfoA' );


FUNCTION DrawText ( hDC : HDC;
                   lpString : PChar;
                   nCount : Integer;
                   VAR lpRect : RECT;
                   uFormat : Word ) : Integer; WINAPI ( 'DrawTextA' );


FUNCTION DrawTextEx ( _1 : HDC;
                     _2 : PChar;
                     _3 : Integer;
                     VAR _4 : RECT;
                     _5 : Word;
                     _6 : LPDRAWTEXTPARAMS ) : Integer; WINAPI ( 'DrawTextExA' );


FUNCTION GrayString ( hDC : HDC;
                     hBrush : HBRUSH;
                     lpOutputFunc : GRAYSTRINGPROC;
                     lpData : LPARAM32;
                     nCount : Integer;
                     X : Integer;
                     Y : Integer;
                     nWidth : Integer;
                     nHeight : Integer ) : WINBOOL; WINAPI ( 'GrayStringA' );


FUNCTION DrawState ( _1 : HDC;
                    _2 : HBRUSH;
                    _3 : DRAWSTATEPROC;
                    _4 : LPARAM32;
                    _5 : UINT;
                    _6 : Integer;
                    _7 : Integer;
                    _8 : Integer;
                    _9 : Integer;
                    _10 : Word ) : WINBOOL; WINAPI ( 'DrawStateA' );


FUNCTION TabbedTextOut ( hDC : HDC;
                        X : Integer;
                        Y : Integer;
                        lpString : PChar;
                        nCount : Integer;
                        nTabPositions : Integer;
                        VAR lpnTabStopPositions : Integer;
                        nTabOrigin : Integer ) : LongInt; WINAPI ( 'TabbedTextOutA' );


FUNCTION GetTabbedTextExtent ( hDC : HDC;
                              lpString : PChar;
                              nCount : Integer;
                              nTabPositions : Integer;
                              VAR lpnTabStopPositions : Integer ) : DWord; WINAPI ( 'GetTabbedTextExtentA' );


FUNCTION SetProp ( Wnd : HWND;
                  lpString : PChar;
                  hData : THandle ) : WINBOOL; WINAPI ( 'SetPropA' );


FUNCTION GetProp ( Wnd : HWND;
                  lpString : PChar ) : THandle; WINAPI ( 'GetPropA' );


FUNCTION RemoveProp ( Wnd : HWND;
                     lpString : PChar ) : THandle; WINAPI ( 'RemovePropA' );


FUNCTION EnumPropsEx ( Wnd : HWND;
                      lpEnumFunc : PROPENUMPROCEX;
                      lParam : LPARAM32 ) : Integer; WINAPI ( 'EnumPropsExA' );


FUNCTION EnumProps ( Wnd : HWND;
                    lpEnumFunc : PROPENUMPROC ) : Integer; WINAPI ( 'EnumPropsA' );


FUNCTION SetWindowText ( Wnd : HWND;
                        lpString : PChar ) : WINBOOL; WINAPI ( 'SetWindowTextA' );


FUNCTION GetWindowText ( Wnd : HWND;
                        lpString : PChar;
                        nMaxCount : Integer ) : Integer; WINAPI ( 'GetWindowTextA' );


FUNCTION GetWindowTextLength ( Wnd : HWND ) : Integer; WINAPI ( 'GetWindowTextLengthA' );


FUNCTION MessageBox ( Wnd : HWND;
                     lpText : PChar;
                     lpCaption : PChar;
                     uType : Word ) : Integer; WINAPI ( 'MessageBoxA' );


FUNCTION MessageBoxEx ( Wnd : HWND;
                       lpText : PChar;
                       lpCaption : PChar;
                       uType : Word;
                       wLanguageId : Word ) : Integer; WINAPI ( 'MessageBoxExA' );


FUNCTION MessageBoxIndirect ( _1 : PMSGBOXPARAMS ) : Integer; WINAPI ( 'MessageBoxIndirectA' );


FUNCTION GetWindowLong ( Wnd : HWND;
                        nIndex : Integer ) : LongInt; WINAPI ( 'GetWindowLongA' );


FUNCTION SetWindowLong ( Wnd : HWND;
                        nIndex : Integer;
                        dwNewLong : LongInt ) : LongInt; WINAPI ( 'SetWindowLongA' );


FUNCTION GetClassLong ( Wnd : HWND;
                       nIndex : Integer ) : DWord; WINAPI ( 'GetClassLongA' );


FUNCTION SetClassLong ( Wnd : HWND;
                       nIndex : Integer;
                       dwNewLong : LongInt ) : DWord; WINAPI ( 'SetClassLongA' );

FUNCTION FindWindow ( lpClassName : PChar;
                     lpWindowName : PChar ) : HWND; WINAPI ( 'FindWindowA' );


FUNCTION FindWindowEx ( _1 : HWND;
                       _2 : HWND;
                       _3 : PChar;
                       _4 : PChar ) : HWND; WINAPI ( 'FindWindowExA' );


FUNCTION GetClassName ( Wnd : HWND;
                       lpClassName : PChar;
                       nMaxCount : Integer ) : Integer; WINAPI ( 'GetClassNameA' );

FUNCTION SetWindowsHookEx ( idHook : Integer;
                           lpfn : THookProc;
                           hmod : THANDLE;
                           dwThreadId : DWord ) : HHOOK; WINAPI ( 'SetWindowsHookExA' );

FUNCTION LoadBitmap ( xInstance : THANDLE;
                     lpBitmapName : PChar ) : HBITMAP; WINAPI ( 'LoadBitmapA' );


FUNCTION LoadCursor ( xInstance : THANDLE;
                     lpCursorName : PChar ) : HCURSOR; WINAPI ( 'LoadCursorA' );


FUNCTION LoadCursorFromFile ( lpFileName : PChar ) : HCURSOR; WINAPI ( 'LoadCursorFromFileA' );

FUNCTION LoadIcon ( xInstance : THANDLE;
                   lpIconName : PChar ) : HICON; WINAPI ( 'LoadIconA' );


FUNCTION LoadImage ( _1 : THANDLE;
                    _2 : PChar;
                    _3 : Word;
                    _4 : Integer;
                    _5 : Integer;
                    _6 : Word ) : THandle; WINAPI ( 'LoadImageA' );


FUNCTION LoadString ( xInstance : THANDLE;
                     uID : Word;
                     lpBuffer : PChar;
                     nBufferMax : Integer ) : Integer; WINAPI ( 'LoadStringA' );


FUNCTION IsDialogMessage ( hDlg : HWND;
                          VAR lpMsg : TMSG ) : WINBOOL; WINAPI ( 'IsDialogMessageA' );


FUNCTION SHBrowseForFolder ( VAR lpbi : TBrowseInfo ) : PItemIDList; WINAPI ( 'SHBrowseForFolder' );

FUNCTION SHGetPathFromIDList ( pidl : PItemIDList; pszPath : pChar ) : WinBool;
WINAPI ( 'SHGetPathFromIDList' );

FUNCTION DlgDirList ( hDlg : HWND;
                     lpPathSpec : PChar;
                     nIDListBox : Integer;
                     nIDStaticPath : Integer;
                     uFileType : Word ) : Integer; WINAPI ( 'DlgDirListA' );


FUNCTION DlgDirSelectEx ( hDlg : HWND;
                         lpString : PChar;
                         nCount : Integer;
                         nIDListBox : Integer ) : WINBOOL; WINAPI ( 'DlgDirSelectExA' );

FUNCTION DlgDirListComboBox ( hDlg : HWND;
                             lpPathSpec : PChar;
                             nIDComboBox : Integer;
                             nIDStaticPath : Integer;
                             uFiletype : Word ) : Integer; WINAPI ( 'DlgDirListComboBoxA' );

FUNCTION DlgDirSelectComboBoxEx ( hDlg : HWND;
                                 lpString : PChar;
                                 nCount : Integer;
                                 nIDComboBox : Integer ) : WINBOOL; WINAPI ( 'DlgDirSelectComboBoxExA' );

FUNCTION DefFrameProc ( Wnd : HWND;
                       hWndMDIClient : HWND;
                       uMsg : Word;
                       aParam : UINT;
                       bParam : LPARAM32 ) : LRESULT; WINAPI ( 'DefFrameProcA' );


FUNCTION DefMDIChildProc ( Wnd : HWND;
                          uMsg : Word;
                          wParam : UINT;
                          lParam : LPARAM32 ) : LRESULT; WINAPI ( 'DefMDIChildProcA' );

FUNCTION CreateMDIWindow ( lpClassName : PChar;
                          lpWindowName : PChar;
                          dwStyle : DWord;
                          X : Integer;
                          Y : Integer;
                          nWidth : Integer;
                          nHeight : Integer;
                          hWndParent : HWND;
                          xInstance : THANDLE;
                          lParam : LPARAM32 ) : HWND; WINAPI ( 'CreateMDIWindowA' );


FUNCTION WinHelp ( hWndMain : HWND;
                  lpszHelp : PChar;
                  uCommand : Word;
                  dwData : DWord ) : WINBOOL; WINAPI ( 'WinHelpA' );


FUNCTION ChangeDisplaySettings ( lpDevMode : PDEVMODE;
                                dwFlags : DWord ) : LongInt; WINAPI ( 'ChangeDisplaySettingsA' );


FUNCTION EnumDisplaySettings ( lpszDeviceName : PChar;
                              iModeNum : DWord;
                              lpDevMode : PDEVMODE ) : WINBOOL; WINAPI ( 'EnumDisplaySettingsA' );


FUNCTION SystemParametersInfo ( uiAction : Word;
                               uiParam : Word;
                               VAR pvParam;
                               fWinIni : Word ) : WINBOOL; WINAPI ( 'SystemParametersInfoA' );


FUNCTION AddFontResource ( _1 : PChar ) : Integer; WINAPI ( 'AddFontResourceA' );


FUNCTION CopyMetaFile ( _1 : HMETAFILE;
                       _2 : PChar ) : HMETAFILE; WINAPI ( 'CopyMetaFileA' );

FUNCTION CreateFontIndirect ( CONST L : LOGFONT ) : HFONT; WINAPI ( 'CreateFontIndirectA' );


FUNCTION CreateIC ( _1 : PChar;
                   _2 : PChar;
                   _3 : PChar;
                    D : pDEVMODE ) : HDC; WINAPI ( 'CreateICA' );

FUNCTION CreateMetaFile ( _1 : PChar ) : HDC; WINAPI ( 'CreateMetaFileA' );


FUNCTION CreateScalableFontResource ( _1 : DWord;
                                     _2 : PChar;
                                     _3 : PChar;
                                     _4 : PChar ) : WINBOOL; WINAPI ( 'CreateScalableFontResourceA' );


FUNCTION DeviceCapabilities ( _1 : PChar;
                             _2 : PChar;
                             _3 : Word;
                             _4 : PChar;
                              p : pDevMode ) : Integer; WINAPI ( 'DeviceCapabilitiesA' );


FUNCTION EnumFontFamiliesEx ( _1 : HDC;
                             _2 : PLOGFONT;
                             _3 : FONTENUMEXPROC;
                             _4 : LPARAM32;
                             _5 : DWord ) : Integer; WINAPI ( 'EnumFontFamiliesExA' );


FUNCTION EnumFontFamilies ( _1 : HDC;
                           _2 : PChar;
                           _3 : FONTENUMPROC;
                           _4 : LPARAM32 ) : Integer; WINAPI ( 'EnumFontFamiliesA' );


FUNCTION EnumFonts ( _1 : HDC;
                    _2 : PChar;
                    _3 : ENUMFONTSPROC;
                    _4 : LPARAM32 ) : Integer; WINAPI ( 'EnumFontsA' );


FUNCTION GetCharWidth ( _1 : HDC;
                       _2 : Word;
                       _3 : Word;
                       VAR _4 : Integer ) : WINBOOL; WINAPI ( 'GetCharWidthA' );


FUNCTION GetCharWidth32 ( _1 : HDC;
                         _2 : Word;
                         _3 : Word;
                         VAR _4 : Integer ) : WINBOOL; WINAPI ( 'GetCharWidth32A' );

FUNCTION GetCharWidthFloat ( _1 : HDC;
                            _2 : Word;
                            _3 : Word;
                            VAR _4 : Single ) : WINBOOL; WINAPI ( 'GetCharWidthFloatA' );


FUNCTION GetCharABCWidths ( _1 : HDC;
                           _2 : Word;
                           _3 : Word;
                           VAR _4 : TABC ) : WINBOOL; WINAPI ( 'GetCharABCWidthsA' );


FUNCTION GetCharABCWidthsFloat ( _1 : HDC;
                                _2 : Word;
                                _3 : Word;
                                VAR _4 : TABCFLOAT ) : WINBOOL; WINAPI ( 'GetCharABCWidthsFloatA' );

FUNCTION GetGlyphOutline ( _1 : HDC;
                          _2 : Word;
                          _3 : Word;
                          _4 : PGLYPHMETRICS;
                          _5 : DWord;
                          _6 : POINTER;
                           CONST M : MAT2 ) : DWord; WINAPI ( 'GetGlyphOutlineA' );


FUNCTION GetMetaFile ( _1 : PChar ) : HMETAFILE; WINAPI ( 'GetMetaFileA' );


FUNCTION GetOutlineTextMetrics ( _1 : HDC;
                                _2 : Word;
                                _3 : POUTLINETEXTMETRIC ) : Word; WINAPI ( 'GetOutlineTextMetricsA' );


FUNCTION GetTextExtentPoint ( _1 : HDC;
                             _2 : PChar;
                             _3 : Integer;
                             _4 : PSIZE ) : WINBOOL; WINAPI ( 'GetTextExtentPointA' );


FUNCTION GetTextExtentPoint32 ( _1 : HDC;
                               _2 : PChar;
                               _3 : Integer;
                               _4 : PSIZE ) : WINBOOL; WINAPI ( 'GetTextExtentPoint32A' );


FUNCTION GetTextExtentExPoint ( _1 : HDC;
                               _2 : PChar;
                               _3 : Integer;
                               _4 : Integer;
                               VAR _5,
                               _6 : Integer;
                               VAR _7 : TSIZE ) : WINBOOL; WINAPI ( 'GetTextExtentExPointA' );


FUNCTION GetCharacterPlacement ( _1 : HDC;
                                _2 : PChar;
                                _3 : Integer;
                                _4 : Integer;
                                _5 : PGCP_RESULTS;
                                _6 : DWord ) : DWord; WINAPI ( 'GetCharacterPlacementA' );


FUNCTION ResetDC ( _1 : HDC;
                   CONST D : DEVMODE ) : HDC; WINAPI ( 'ResetDCA' );


FUNCTION RemoveFontResource ( _1 : PChar ) : WINBOOL; WINAPI ( 'RemoveFontResourceA' );


FUNCTION CopyEnhMetaFile ( _1 : HENHMETAFILE;
                          _2 : PChar ) : HENHMETAFILE; WINAPI ( 'CopyEnhMetaFileA' );


FUNCTION CreateEnhMetaFile ( _1 : HDC;
                            _2 : PChar;
                            CONST R : RECT;
                            _4 : PChar ) : HDC; WINAPI ( 'CreateEnhMetaFileA' );


FUNCTION GetEnhMetaFile ( _1 : PChar ) : HENHMETAFILE; WINAPI ( 'GetEnhMetaFileA' );


FUNCTION GetEnhMetaFileDescription ( _1 : HENHMETAFILE;
                                    _2 : Word;
                                    _3 : PChar ) : Word; WINAPI ( 'GetEnhMetaFileDescriptionA' );


FUNCTION GetTextMetrics ( _1 : HDC;
                         _2 : PTEXTMETRIC ) : WINBOOL; WINAPI ( 'GetTextMetricsA' );


FUNCTION StartDoc ( _1 : HDC;
                    CONST D : DOCINFO ) : Integer; WINAPI ( 'StartDocA' );


FUNCTION GetObject ( _1 : HGDIOBJ;
                    _2 : Integer;
                    _3 : POINTER ) : Integer; WINAPI ( 'GetObjectA' );


FUNCTION TextOut ( _1 : HDC;
                  _2 : Integer;
                  _3 : Integer;
                  _4 : PChar;
                  _5 : Integer ) : WINBOOL; WINAPI ( 'TextOutA' );


FUNCTION ExtTextOut ( _1 : HDC;
                     _2 : Integer;
                     _3 : Integer;
                     _4 : Word;
                     CONST R : RECT;
                     _6 : PChar;
                     _7 : Word;
                     CONST I : INTEGER ) : WINBOOL; WINAPI ( 'ExtTextOutA' );


FUNCTION PolyTextOut ( _1 : HDC;
                      CONST P : POLYTEXT;
                      _3 : Integer ) : WINBOOL; WINAPI ( 'PolyTextOutA' );


FUNCTION GetTextFace ( _1 : HDC;
                      _2 : Integer;
                      _3 : PChar ) : Integer; WINAPI ( 'GetTextFaceA' );


FUNCTION GetKerningPairs ( _1 : HDC;
                          _2 : DWord;
                          _3 : PKERNINGPAIR ) : DWord; WINAPI ( 'GetKerningPairsA' );


FUNCTION CreateColorSpace ( _1 : PLOGCOLORSPACE ) : HCOLORSPACE; WINAPI ( 'CreateColorSpaceA' );


FUNCTION GetLogColorSpace ( _1 : HCOLORSPACE;
                           _2 : PLOGCOLORSPACE;
                           _3 : DWord ) : WINBOOL; WINAPI ( 'GetLogColorSpaceA' );


FUNCTION GetICMProfile ( _1 : HDC;
                        _2 : DWord;
                        _3 : PChar ) : WINBOOL; WINAPI ( 'GetICMProfileA' );


FUNCTION SetICMProfile ( _1 : HDC;
                        _2 : PChar ) : WINBOOL; WINAPI ( 'SetICMProfileA' );


FUNCTION UpdateICMRegKey ( _1 : DWord;
                          _2 : DWord;
                          _3 : PChar;
                          _4 : Word ) : WINBOOL; WINAPI ( 'UpdateICMRegKeyA' );


FUNCTION EnumICMProfiles ( _1 : HDC;
                          _2 : ICMENUMPROC;
                          _3 : LPARAM32 ) : Integer; WINAPI ( 'EnumICMProfilesA' );


FUNCTION PropertySheet ( lppsph : PCPROPSHEETHEADER ) : Integer; WINAPI ( 'PropertySheetA' );


FUNCTION ImageList_LoadImage ( hi : THANDLE;
                              lpbmp : PChar;
                              cx : Integer;
                              cGrow : Integer;
                              crMask : TColorRef;
                              uType : Word;
                              uFlags : Word ) : HIMAGELIST; WINAPI ( 'ImageList_LoadImageA' );


FUNCTION CreateStatusWindow ( style : LongInt;
                             lpszText : PChar;
                             hwndParent : HWND;
                             wID : Word ) : HWND; WINAPI ( 'CreateStatusWindowA' );


PROCEDURE  DrawStatusText ( hDC : HDC;
                         lprc : PRECT;
                         pszText : PChar;
                         uFlags : Word ); WINAPI ( 'DrawStatusTextA' );


FUNCTION GetOpenFileName ( VAR OFN : TOPENFILENAME ) : WINBOOL; WINAPI ( 'GetOpenFileNameA' );


FUNCTION GetSaveFileName ( VAR OFN : TOPENFILENAME ) : WINBOOL; WINAPI ( 'GetSaveFileNameA' );


FUNCTION GetFileTitle ( _1 : PChar;
                       _2 : PChar;
                       _3 : Word ) : SmallInt; WINAPI ( 'GetFileTitleA' );


FUNCTION ChooseColor ( VAR _1 : TCHOOSECOLOR ) : WINBOOL; WINAPI ( 'ChooseColorA' );


FUNCTION FindText ( VAR _1 : TFINDREPLACE ) : HWND; WINAPI ( 'FindTextA' );


FUNCTION ReplaceText ( VAR _1 : TFINDREPLACE ) : HWND; WINAPI ( 'ReplaceTextA' );


FUNCTION ChooseFont ( VAR _1 : TCHOOSEFONT ) : WINBOOL; WINAPI ( 'ChooseFontA' );


FUNCTION PrintDlg ( VAR _1 : TPRINTDLG ) : WINBOOL; WINAPI ( 'PrintDlgA' );


FUNCTION PageSetupDlg ( VAR _1 : TPAGESETUPDLG ) : WINBOOL; WINAPI ( 'PageSetupDlgA' );


FUNCTION CreateProcess ( lpApplicationName : PChar;
                        lpCommandLine : PChar;
                        lpProcessAttributes : PSECURITY_ATTRIBUTES;
                        lpThreadAttributes : PSECURITY_ATTRIBUTES;
                        bInheritHandles : WINBOOL;
                        dwCreationFlags : DWord;
                        lpEnvironment : POINTER;
                        lpCurrentDirectory : PChar;
                        VAR StartupInfo : TSTARTUPINFO;
                        VAR ProcessInformation : TPROCESS_INFORMATION
                        ) : WINBOOL; WINAPI ( 'CreateProcessA' );

PROCEDURE  GetStartupInfo ( VAR lpStartupInfo : TSTARTUPINFO ); WINAPI ( 'GetStartupInfoA' );


FUNCTION FindFirstFile ( lpFileName : PChar;
                        VAR lpFindFileData : TWIN32_FIND_DATA ) : THandle; WINAPI ( 'FindFirstFileA' );


FUNCTION FindNextFile ( hFindFile : THandle;
                       VAR lpFindFileData : TWIN32_FIND_DATA ) : WINBOOL; WINAPI ( 'FindNextFileA' );


FUNCTION GetVersionEx ( VAR lpVersionInformation : TOSVERSIONINFO ) : WINBOOL; WINAPI ( 'GetVersionExA' );

FUNCTION CreateDC ( _1 : PChar;
                   _2 : PChar;
                   _3 : PChar;
                   D : pDEVMODE ) : HDC; WINAPI ( 'CreateDCA' );


FUNCTION VerInstallFile ( uFlags : DWord;
                         szSrcFileName : PChar;
                         szDestFileName : PChar;
                         szSrcDir : PChar;
                         szDestDir : PChar;
                         szCurDir : PChar;
                         szTmpFile : PChar;
                         VAR lpuTmpFileLen : Word ) : DWord; WINAPI ( 'VerInstallFileA' );


FUNCTION GetFileVersionInfoSize ( lptstrFilename : PChar;
                                 VAR lpdwHandle : DWord ) : DWord; WINAPI ( 'GetFileVersionInfoSizeA' );

FUNCTION GetFileVersionInfo ( lptstrFilename : PChar;
                             dwHandle : DWord;
                             dwLen : DWord;
                             lpData : POINTER ) : WINBOOL; WINAPI ( 'GetFileVersionInfoA' );

FUNCTION VerLanguageName ( wLang : DWord;
                          szLang : PChar;
                          nSize : DWord ) : DWord; WINAPI ( 'VerLanguageNameA' );


FUNCTION VerQueryValue ( CONST pBlock : POINTER;
                        lpSubBlock : PChar;
                        VAR lplpBuffer;
                        VAR puLen : Word ) : WINBOOL; WINAPI ( 'VerQueryValueA' );


FUNCTION VerFindFile ( uFlags : DWord;
                      szFileName : PChar;
                      szWinDir : PChar;
                      szAppDir : PChar;
                      szCurDir : PChar;
                      VAR lpuCurDirLen : Word;
                      szDestDir : PChar;
                      VAR lpuDestDirLen : Word ) : DWord; WINAPI ( 'VerFindFileA' );


FUNCTION RegConnectRegistry ( lpMachineName : PChar;
                             Key : HKEY;
                             VAR phkResult : HKEY ) : LongInt; WINAPI ( 'RegConnectRegistryA' );


FUNCTION RegCreateKey ( Key : HKEY;
                       lpSubKey : PChar;
                       VAR phkResult : HKEY ) : LongInt; WINAPI ( 'RegCreateKeyA' );


FUNCTION RegCreateKeyEx ( Key : HKEY;
                         lpSubKey : PChar;
                         Reserved : DWord;
                         lpClass : PChar;
                         dwOptions : DWord;
                         samDesired : REGSAM;
                         lpSecurityAttributes : PSECURITY_ATTRIBUTES;
                         VAR phkResult : HKEY;
                         lpdwDisposition : PDWord ) : LongInt; WINAPI ( 'RegCreateKeyExA' );


FUNCTION RegDeleteKey ( Key : HKEY;
                       lpSubKey : PChar ) : LongInt; WINAPI ( 'RegDeleteKeyA' );


FUNCTION RegDeleteValue ( Key : HKEY;
                         lpValueName : PChar ) : LongInt; WINAPI ( 'RegDeleteValueA' );


FUNCTION RegEnumKey ( Key : HKEY;
                     dwIndex : DWord;
                     lpName : PChar;
                     cbName : DWord ) : LongInt; WINAPI ( 'RegEnumKeyA' );


FUNCTION RegEnumKeyEx ( Key : HKEY;
                       dwIndex : DWord;
                       lpName : PChar;
                       VAR lpcbName,
                       lpReserved : DWord;
                       lpClass : PChar;
                       VAR lpcbClass : DWord;
                       VAR lpftLastWriteTime : TFILETIME ) : LongInt; WINAPI ( 'RegEnumKeyExA' );


FUNCTION RegEnumValue ( Key : HKEY;
                       dwIndex : DWord;
                       lpValueName : PChar;
                       VAR lpcbValueName : DWord;
                       lpReserved,
                       lpType : pDWord;
                       lpData : Pointer;
                       lpcbData : pDWord ) : LongInt; WINAPI ( 'RegEnumValueA' );


FUNCTION RegLoadKey ( Key : HKEY;
                     lpSubKey : PChar;
                     lpFile : PChar ) : LongInt; WINAPI ( 'RegLoadKeyA' );


FUNCTION RegOpenKey ( Key : HKEY;
                     lpSubKey : PChar;
                     VAR phkResult : HKEY ) : LongInt; WINAPI ( 'RegOpenKeyA' );


FUNCTION RegOpenKeyEx ( Key : HKEY;
                       lpSubKey : PChar;
                       ulOptions : DWord;
                       samDesired : REGSAM;
                       VAR phkResult : HKEY ) : LongInt; WINAPI ( 'RegOpenKeyExA' );


FUNCTION RegQueryInfoKey ( Key : HKEY;
                          lpClass : PChar;
                          lpcbClass,
                          lpReserved,
                          lpcSubKeys,
                          lpcbMaxSubKeyLen,
                          lpcbMaxClassLen,
                          lpcValues,
                          lpcbMaxValueNameLen,
                          lpcbMaxValueLen,
                          lpcbSecurityDescriptor : PDWORD;
                          lpftLastWriteTime : PFILETIME
                          ) : LongInt; WINAPI ( 'RegQueryInfoKeyA' );

FUNCTION RegQueryValue ( Key : HKEY;
                        lpSubKey : PChar;
                        lpValue : PChar;
                        VAR lpcbValue : LongInt ) : LongInt; WINAPI ( 'RegQueryValueA' );


FUNCTION RegQueryMultipleValues ( Key : HKEY;
                                 val_list : PVALENT;
                                 num_vals : DWord;
                                 lpValueBuf : PChar;
                                 VAR ldwTotsize : DWord ) : LongInt; WINAPI ( 'RegQueryMultipleValuesA' );


FUNCTION RegQueryValueEx ( Key : HKEY;
                          lpValueName : PChar;
                          lpReserved : Pointer;
                          lpType : pDWord;
                          lpData : Pointer;
                          lpcbData : pDWord ) : LongInt; WINAPI ( 'RegQueryValueExA' );


FUNCTION RegReplaceKey ( Key : HKEY;
                        lpSubKey : PChar;
                        lpNewFile : PChar;
                        lpOldFile : PChar ) : LongInt; WINAPI ( 'RegReplaceKeyA' );


FUNCTION RegRestoreKey ( Key : HKEY;
                        lpFile : PChar;
                        dwFlags : DWord ) : LongInt; WINAPI ( 'RegRestoreKeyA' );


FUNCTION RegSaveKey ( Key : HKEY;
                     lpFile : PChar;
                     lpSecurityAttributes : pSECURITY_ATTRIBUTES ) : LongInt; WINAPI ( 'RegSaveKeyA' );


FUNCTION RegSetValue ( Key : HKEY;
                      lpSubKey : PChar;
                      dwType : DWord;
                      lpData : PChar;
                      cbData : DWord ) : LongInt; WINAPI ( 'RegSetValueA' );


FUNCTION RegSetValueEx ( Key : HKEY;
                        lpValueName : PChar;
                        Reserved : DWord;
                        dwType : DWord;
                        lpData : Pointer;
                        cbData : DWord ) : LongInt; WINAPI ( 'RegSetValueExA' );

FUNCTION RegUnLoadKey ( Key : HKEY;
                       lpSubKey : PChar ) : LongInt; WINAPI ( 'RegUnLoadKeyA' );


FUNCTION InitiateSystemShutdown ( lpMachineName : PChar;
                                 lpMessage : PChar;
                                 dwTimeout : DWord;
                                 bForceAppsClosed : WINBOOL;
                                 bRebootAfterShutdown : WINBOOL ) : WINBOOL; WINAPI ( 'InitiateSystemShutdownA' );

FUNCTION AbortSystemShutdown ( lpMachineName : PChar ) : WINBOOL; WINAPI ( 'AbortSystemShutdownA' );


FUNCTION CompareString ( Locale : LCID;
                        dwCmpFlags : DWord;
                        lpString1 : PChar;
                        cchCount1 : Integer;
                        lpString2 : PChar;
                        cchCount2 : Integer ) : Integer; WINAPI ( 'CompareStringA' );

FUNCTION LCMapString ( Locale : LCID;
                      dwMapFlags : DWord;
                      lpSrcStr : PChar;
                      cchSrc : Integer;
                      lpDestStr : PChar;
                      cchDest : Integer ) : Integer; WINAPI ( 'LCMapStringA' );


FUNCTION GetLocaleInfo ( Locale : LCID;
                        LCType : LCTYPE;
                        lpLCData : PChar;
                        cchData : Integer ) : Integer; WINAPI ( 'GetLocaleInfoA' );


FUNCTION SetLocaleInfo ( Locale : LCID;
                        LCType : LCTYPE;
                        lpLCData : PChar ) : WINBOOL; WINAPI ( 'SetLocaleInfoA' );


FUNCTION GetTimeFormat ( Locale : LCID;
                        dwFlags : DWord;
                        CONST lpTime :  TSYSTEMTIME;
                        lpFormat : PChar;
                        lpTimeStr : PChar;
                        cchTime : Integer ) : Integer; WINAPI ( 'GetTimeFormatA' );


FUNCTION GetDateFormat ( Locale : LCID;
                        dwFlags : DWord;
                        CONST lpDate :  TSYSTEMTIME;
                        lpFormat : PChar;
                        lpDateStr : PChar;
                        cchDate : Integer ) : Integer; WINAPI ( 'GetDateFormatA' );


FUNCTION GetNumberFormat ( Locale : LCID;
                          dwFlags : DWord;
                          lpValue : PChar;
                          CONST lpFormat :  NUMBERFMT;
                          lpNumberStr : PChar;
                          cchNumber : Integer ) : Integer; WINAPI ( 'GetNumberFormatA' );


FUNCTION GetCurrencyFormat ( Locale : LCID;
                            dwFlags : DWord;
                            lpValue : PChar;
                            CONST lpFormat :  CURRENCYFMT;
                            lpCurrencyStr : PChar;
                            cchCurrency : Integer ) : Integer; WINAPI ( 'GetCurrencyFormatA' );


FUNCTION EnumCalendarInfo ( lpCalInfoEnumProc : CALINFO_ENUMPROC;
                           Locale : LCID;
                           Calendar : CALID;
                           xCalType : CALTYPE ) : WINBOOL; WINAPI ( 'EnumCalendarInfoA' );

FUNCTION EnumTimeFormats ( lpTimeFmtEnumProc : TIMEFMT_ENUMPROC;
                          Locale : LCID;
                          dwFlags : DWord ) : WINBOOL; WINAPI ( 'EnumTimeFormatsA' );

FUNCTION EnumDateFormats ( lpDateFmtEnumProc : DATEFMT_ENUMPROC;
                          Locale : LCID;
                          dwFlags : DWord ) : WINBOOL; WINAPI ( 'EnumDateFormatsA' );

FUNCTION GetStringTypeEx ( Locale : LCID;
                          dwInfoType : DWord;
                          lpSrcStr : PChar;
                          cchSrc : Integer;
                          VAR lpCharType : Word ) : WINBOOL; WINAPI ( 'GetStringTypeExA' );

FUNCTION GetStringType ( Locale : LCID;
                        dwInfoType : DWord;
                        lpSrcStr : PChar;
                        cchSrc : Integer;
                        VAR lpCharType : Word ) : WINBOOL; WINAPI ( 'GetStringTypeA' );

FUNCTION FoldString ( dwMapFlags : DWord;
                     lpSrcStr : PChar;
                     cchSrc : Integer;
                     lpDestStr : PChar;
                     cchDest : Integer ) : Integer; WINAPI ( 'FoldStringA' );

FUNCTION EnumSystemLocales ( lpLocaleEnumProc : LOCALE_ENUMPROC;
                            dwFlags : DWord ) : WINBOOL; WINAPI ( 'EnumSystemLocalesA' );

FUNCTION EnumSystemCodePages ( lpCodePageEnumProc : CODEPAGE_ENUMPROC;
                              dwFlags : DWord ) : WINBOOL; WINAPI ( 'EnumSystemCodePagesA' );

FUNCTION PeekConsoleInput ( hConsoleInput : Integer;
                           VAR lpBuffer : TINPUTRECORD;
                           nLength : DWord;
                           VAR lpNumberOfEventsRead : DWord ) : WINBOOL; WINAPI ( 'PeekConsoleInputA' );

FUNCTION ReadConsoleInput ( hConsoleInput : Integer;
                           VAR lpBuffer : TINPUTRECORD;
                           nLength : DWord;
                           VAR lpNumberOfEventsRead : DWord ) : WINBOOL; WINAPI ( 'ReadConsoleInputA' );

FUNCTION WriteConsoleInput ( hConsoleInput : Integer;
                            CONST lpBuffer :  TINPUTRECORD;
                            nLength : DWord;
                            VAR lpNumberOfEventsWritten : DWord ) : WINBOOL; WINAPI ( 'WriteConsoleInputA' );

FUNCTION ReadConsoleOutput ( hConsoleOutput : Integer;
                            lpBuffer : PCHAR_INFO;
                            dwBufferSize : COORD;
                            dwBufferCoord : COORD;
                            VAR lpReadRegion : TSMALL_RECT ) : WINBOOL; WINAPI ( 'ReadConsoleOutputA' );

FUNCTION WriteConsoleOutput ( hConsoleOutput : Integer;
                             CONST lpBuffer :  CHAR_INFO;
                             dwBufferSize : COORD;
                             dwBufferCoord : COORD;
                             VAR lpWriteRegion : TSMALL_RECT ) : WINBOOL; WINAPI ( 'WriteConsoleOutputA' );


FUNCTION ReadConsoleOutputCharacter ( hConsoleOutput : Integer;
                                     lpCharacter : PChar;
                                     nLength : DWord;
                                     dwReadCoord : COORD;
                                     VAR lpNumberOfCharsRead : DWord ) : WINBOOL; WINAPI ( 'ReadConsoleOutputCharacterA' );


FUNCTION WriteConsoleOutputCharacter ( hConsoleOutput : Integer;
                                      lpCharacter : PChar;
                                      nLength : DWord;
                                      dwWriteCoord : COORD;
                                      VAR lpNumberOfCharsWritten : DWord ) : WINBOOL; WINAPI ( 'WriteConsoleOutputCharacterA' );


FUNCTION FillConsoleOutputCharacter ( hConsoleOutput : Integer;
                                     cCharacter : Char;
                                     nLength : DWord;
                                     dwWriteCoord : COORD;
                                     VAR lpNumberOfCharsWritten : DWord ) : WINBOOL; WINAPI ( 'FillConsoleOutputCharacterA' );


FUNCTION ScrollConsoleScreenBuffer ( hConsoleOutput : Integer;
                                    CONST lpScrollRectangle :  SMALL_RECT;
                                    CONST lpClipRectangle :  SMALL_RECT;
                                    dwDestinationOrigin : COORD;
                                    CONST lpFill :  CHAR_INFO ) : WINBOOL; WINAPI ( 'ScrollConsoleScreenBufferA' );


FUNCTION GetConsoleTitle ( lpConsoleTitle : PChar;
                          nSize : DWord ) : DWord; WINAPI ( 'GetConsoleTitleA' );


FUNCTION SetConsoleTitle ( lpConsoleTitle : PChar ) : WINBOOL; WINAPI ( 'SetConsoleTitleA' );


FUNCTION ReadConsole ( hConsoleInput : Integer;
                      lpBuffer : POINTER;
                      nNumberOfCharsToRead : DWord;
                      VAR lpNumberOfCharsRead : DWord;
                      lpReserved : POINTER ) : WINBOOL; WINAPI ( 'ReadConsoleA' );


FUNCTION WriteConsole ( hConsoleOutput : Integer;
                       CONST lpBuffer;
                       nNumberOfCharsToWrite : DWord;
                       VAR lpNumberOfCharsWritten : DWord;
                       lpReserved : POINTER ) : WINBOOL; WINAPI ( 'WriteConsoleA' );


FUNCTION WNetAddConnection ( lpRemoteName : PChar;
                            lpPassword : PChar;
                            lpLocalName : PChar ) : DWord; WINAPI ( 'WNetAddConnectionA' );


FUNCTION WNetAddConnection2 ( VAR lpNetResource : TNETRESOURCE;
                             lpPassword : PChar;
                             lpUserName : PChar;
                             dwFlags : DWord ) : DWord; WINAPI ( 'WNetAddConnection2A' );


FUNCTION WNetAddConnection3 ( hwndOwner : HWND;
                             VAR lpNetResource : TNETRESOURCE;
                             lpPassword : PChar;
                             lpUserName : PChar;
                             dwFlags : DWord ) : DWord; WINAPI ( 'WNetAddConnection3A' );


FUNCTION WNetCancelConnection ( lpName : PChar;
                               fForce : WINBOOL ) : DWord; WINAPI ( 'WNetCancelConnectionA' );


FUNCTION WNetCancelConnection2 ( lpName : PChar;
                                dwFlags : DWord;
                                fForce : WINBOOL ) : DWord; WINAPI ( 'WNetCancelConnection2A' );


FUNCTION WNetGetConnection ( lpLocalName : PChar;
                            lpRemoteName : PChar;
                            VAR lpnLength : DWord ) : DWord; WINAPI ( 'WNetGetConnectionA' );


FUNCTION WNetUseConnection ( hwndOwner : HWND;
                            VAR lpNetResource : TNETRESOURCE;
                            lpUserID : PChar;
                            lpPassword : PChar;
                            dwFlags : DWord;
                            lpAccessName : PChar;
                            VAR lpBufferSize : DWord;
                            VAR lpResult : DWord ) : DWord; WINAPI ( 'WNetUseConnectionA' );


FUNCTION WNetSetConnection ( lpName : PChar;
                            dwProperties : DWord;
                            pvValues : POINTER ) : DWord; WINAPI ( 'WNetSetConnectionA' );


FUNCTION WNetConnectionDialog1 ( lpConnDlgStruct : PCONNECTDLGSTRUCT ) : DWord; WINAPI ( 'WNetConnectionDialog1A' );

FUNCTION WNetDisconnectDialog1 ( lpConnDlgStruct : PDISCDLGSTRUCT ) : DWord; WINAPI ( 'WNetDisconnectDialog1A' );

FUNCTION WNetOpenEnum ( dwScope : DWord;
                       dwType : DWord;
                       dwUsage : DWord;
                       lpNetResource : PNETRESOURCE;
                       lphEnum : PHANDLE ) : DWord; WINAPI ( 'WNetOpenEnumA' );


FUNCTION WNetEnumResource ( hEnum : THandle;
                           VAR lpcCount : DWord;
                           lpBuffer : POINTER;
                           VAR lpBufferSize : DWord ) : DWord; WINAPI ( 'WNetEnumResourceA' );


FUNCTION WNetGetUniversalName ( lpLocalPath : PChar;
                               dwInfoLevel : DWord;
                               lpBuffer : POINTER;
                               VAR lpBufferSize : DWord ) : DWord; WINAPI ( 'WNetGetUniversalNameA' );


FUNCTION WNetGetUser ( lpName : PChar;
                      lpUserName : PChar;
                      VAR lpnLength : DWord ) : DWord; WINAPI ( 'WNetGetUserA' );


FUNCTION WNetGetProviderName ( dwNetType : DWord;
                              lpProviderName : PChar;
                              VAR lpBufferSize : DWord ) : DWord; WINAPI ( 'WNetGetProviderNameA' );


FUNCTION WNetGetNetworkInformation ( lpProvider : PChar;
                                    lpNetInfoStruct : PNETINFOSTRUCT ) : DWord; WINAPI ( 'WNetGetNetworkInformationA' );


FUNCTION WNetGetLastError ( VAR lpError : PDWord;
                           lpErrorBuf : PChar;
                           nErrorBufSize : DWord;
                           lpNameBuf : PChar;
                           nNameBufSize : DWord ) : DWord; WINAPI ( 'WNetGetLastErrorA' );


FUNCTION MultinetGetConnectionPerformance ( lpNetResource : PNETRESOURCE;
                                           lpNetConnectInfoStruct : PNETCONNECTINFOSTRUCT ) : DWord; WINAPI ( 'MultinetGetConnectionPerformanceA' );


FUNCTION ChangeServiceConfig ( hService : SC_HANDLE;
                              dwServiceType : DWord;
                              dwStartType : DWord;
                              dwErrorControl : DWord;
                              lpBinaryPathName : PChar;
                              lpLoadOrderGroup : PChar;
                              VAR lpdwTagId : DWord;
                              lpDependencies : PChar;
                              lpServiceStartName : PChar;
                              lpPassword,
                              lpDisplayName : pChar
                              ) : WINBOOL; WINAPI ( 'ChangeServiceConfigA' );

FUNCTION CreateService ( hSCManager : SC_HANDLE;
                        lpServiceName : PChar;
                        lpDisplayName : PChar;
                        dwDesiredAccess : DWord;
                        dwServiceType : DWord;
                        dwStartType : DWord;
                        dwErrorControl : DWord;
                        lpBinaryPathName : PChar;
                        lpLoadOrderGroup : PChar;
                        lpdwTagId : LPDWORD;
                        lpDependencies,
                        lpServiceStartName,
                        lpPassword : PChar
                        ) : SC_HANDLE; WINAPI ( 'CreateServiceA' );

FUNCTION EnumDependentServices ( hService : SC_HANDLE;
                                dwServiceState : DWord;
                                lpServices : PENUM_SERVICE_STATUS;
                                cbBufSize : DWord;
                                VAR pcbBytesNeeded : DWord;
                                VAR lpServicesReturned : DWord ) : WINBOOL; WINAPI ( 'EnumDependentServicesA' );


FUNCTION EnumServicesStatus ( hSCManager : SC_HANDLE;
                             dwServiceType : DWord;
                             dwServiceState : DWord;
                             lpServices : PENUM_SERVICE_STATUS;
                             cbBufSize : DWord;
                             VAR pcbBytesNeeded,
                             lpServicesReturned,
                             lpResumeHandle : DWord ) : WINBOOL; WINAPI ( 'EnumServicesStatusA' );


FUNCTION GetServiceKeyName ( hSCManager : SC_HANDLE;
                            lpDisplayName : PChar;
                            lpServiceName : PChar;
                            VAR lpcchBuffer : DWord ) : WINBOOL; WINAPI ( 'GetServiceKeyNameA' );


FUNCTION GetServiceDisplayName ( hSCManager : SC_HANDLE;
                                lpServiceName : PChar;
                                lpDisplayName : PChar;
                                VAR lpcchBuffer : DWord ) : WINBOOL; WINAPI ( 'GetServiceDisplayNameA' );


FUNCTION OpenSCManager ( lpMachineName : PChar;
                        lpDatabaseName : PChar;
                        dwDesiredAccess : DWord ) : SC_HANDLE; WINAPI ( 'OpenSCManagerA' );


FUNCTION OpenService ( hSCManager : SC_HANDLE;
                      lpServiceName : PChar;
                      dwDesiredAccess : DWord ) : SC_HANDLE; WINAPI ( 'OpenServiceA' );


FUNCTION QueryServiceConfig ( hService : SC_HANDLE;
                             lpServiceConfig : PQUERY_SERVICE_CONFIG;
                             cbBufSize : DWord;
                             VAR pcbBytesNeeded : DWord ) : WINBOOL; WINAPI ( 'QueryServiceConfigA' );


FUNCTION QueryServiceLockStatus ( hSCManager : SC_HANDLE;
                                 lpLockStatus : PQUERY_SERVICE_LOCK_STATUS;
                                 cbBufSize : DWord;
                                 VAR pcbBytesNeeded : DWord ) : WINBOOL; WINAPI ( 'QueryServiceLockStatusA' );


FUNCTION RegisterServiceCtrlHandler ( lpServiceName : PChar;
                                     lpHandlerProc : PHANDLER_FUNCTION ) : SERVICE_STATUS_HANDLE; WINAPI ( 'RegisterServiceCtrlHandlerA' );


FUNCTION StartServiceCtrlDispatcher ( lpServiceStartTable : PSERVICE_TABLE_ENTRY ) : WINBOOL; WINAPI ( 'StartServiceCtrlDispatcherA' );


FUNCTION StartService ( hService : SC_HANDLE;
                       dwNumServiceArgs : DWord;
                       lpServiceArgVectors : PPCHAR ) : WINBOOL; WINAPI ( 'StartServiceA' );

{+// Extensions to OpenGL */ }


FUNCTION wglUseFontBitmaps ( _1 : HDC;
                            _2 : DWord;
                            _3 : DWord;
                            _4 : DWord ) : WINBOOL; WINAPI ( 'wglUseFontBitmapsA' );


FUNCTION wglUseFontOutlines ( _1 : HDC;
                             _2 : DWord;
                             _3 : DWord;
                             _4 : DWord;
                             _5 : Single;
                             _6 : Single;
                             _7 : Integer;
                             _8 : PGLYPHMETRICSFLOAT ) : WINBOOL; WINAPI ( 'wglUseFontOutlinesA' );

{+// ------------------------------------- */ }
{+// From shellapi.h in old Cygnus headers */ }


FUNCTION DragQueryFile ( _1 : HDROP;
                        int : Word;
                        P : PChar;
                        xint : Word ) : Word; WINAPI ( 'DragQueryFileA' );


FUNCTION ExtractAssociatedIcon ( _1 : THANDLE;
                               P : PChar;
                                VAR pw : Word ) : HICON; WINAPI ( 'ExtractAssociatedIconA' );


FUNCTION ExtractIcon ( _1 : THANDLE;
                      CONST P : PChar;
                      xint : Word ) : HICON; WINAPI ( 'ExtractIconA' );


FUNCTION FindExecutable ( P1 : PChar;
                        P2 : PChar;
                        P : PChar ) : THANDLE; WINAPI ( 'FindExecutableA' );


FUNCTION ShellAbout ( _1 : HWND;
                     CONST P1 : PChar;
                     CONST P2 : PChar;
                     _4 : HICON ) : Integer; WINAPI ( 'ShellAboutA' );


FUNCTION ShellExecute ( _1 : HWND;
                       P1 : PChar;
                       P2 : PChar;
                       P3 : PChar;
                       P4 : PChar;
                       _6 : Integer ) : THANDLE; WINAPI ( 'ShellExecuteA' );

{+// end of stuff from shellapi.h in old Cygnus headers */ }
{+// -------------------------------------------------- */ }
{+// From ddeml.h in old Cygnus headers */ }


FUNCTION DdeCreateStringHandle ( _1 : DWord;
                                VAR P : PChar;
                                _3 : Integer ) : HSZ; WINAPI ( 'DdeCreateStringHandleA' );


FUNCTION DdeInitialize ( VAR _1 : DWord;
                        _2 : CALLB;
                        _3 : DWord;
                        _4 : DWord ) : Word; WINAPI ( 'DdeInitializeA' );


FUNCTION DdeQueryString ( _1 : DWord;
                         _2 : HSZ;
                         VAR P : PChar;
                         _4 : DWord;
                         _5 : Integer ) : DWord; WINAPI ( 'DdeQueryStringA' );

{+// end of stuff from ddeml.h in old Cygnus headers */ }
{+// ----------------------------------------------- */ }


FUNCTION LogonUser ( _1 : PChar;
                    _2 : PChar;
                    _3 : PChar;
                    _4 : DWord;
                    _5 : DWord;
                    P : PHANDLE ) : WINBOOL; WINAPI ( 'LogonUserA' );

FUNCTION CreateProcessAsUser ( _1 : THandle;
                              _2 : pAnsiChar;
                              _3 : PTSTR;
                              P1 : PSECURITY_ATTRIBUTES;
                              P2 : PSECURITY_ATTRIBUTES;
                              _6 : WINBOOL;
                              _7 : DWord;
                              _8 : POINTER;
                              _9 : pAnsiChar;
                              P3 : PSTARTUPINFO;
                              P4 : PPROCESS_INFORMATION ) : WINBOOL; WINAPI ( 'CreateProcessAsUserA' );

{/// functs.pas ///}

{+// }
{-Functions.h }

{-Declarations for all the Windows32 API Functions }

{-Copyright (C) 1996 Free Software Foundation, Inc. }

{-Author: Scott Christley <scottc@net-community.com> }

{- Functions.Pas }
{-Translated to GNU Pascal: Prof. Abimbola Olowofoyeku <African_Chief@bigfoot.com> }

{-This file is part of the Windows32 API Library. }

{-This library is free software; you can redistribute it and/or }
{-modify it under the terms of the GNU Library General Public }
{-License as published by the Free Software Foundation; either }
{-version 2 of the License, or (at your option) any later version. }

{-This library is distributed in the hope that it will be useful, }
{-but WITHOUT ANY WARRANTY; without even the implied warranty of }
{-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU }
{-Library General Public License for more details. }

{-If you are interested in a warranty or support for this source code, }
{-contact Scott Christley <scottc@net-community.com> for more information. }

{-You should have received a copy of the GNU Library General Public }
{-License along with this library; see the file COPYING.LIB. }
{-If not, write to the Free Software Foundation, }
{-59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. }
{= }

{+// These functions were a real pain, having to figure out which }
{=had Unicode/Ascii versions and which did not }

{$IFNDEF UNICODE_ONLY}
{.$INCLUDE <Windows32/UnicodeFunctions.h>}
{$ENDIF /* !UNICODE_ONLY */}

{$IFNDEF ANSI_ONLY}
{.$INCLUDE <Windows32/ASCIIFunctions.h>}
{$ENDIF /* !ANSI_ONLY */}

FUNCTION AbnormalTermination : WINBOOL; WINAPI ( 'AbnormalTermination' );

FUNCTION AbortDoc ( _1 : HDC ) : Integer; WINAPI ( 'AbortDoc' );

FUNCTION AbortPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'AbortPath' );

FUNCTION AbortPrinter ( _1 : THandle ) : WINBOOL; WINAPI ( 'AbortPrinter' );

FUNCTION AbortProc ( _1 : HDC;
                   _2 : Integer ) : WINBOOL; WINAPI ( 'AbortProc' );

FUNCTION InterlockedIncrement ( VAR lpAddend : LongInt ) : LongInt; WINAPI ( 'InterlockedIncrement' );


FUNCTION InterlockedDecrement ( VAR lpAddend : LongInt ) : LongInt; WINAPI ( 'InterlockedDecrement' );


FUNCTION InterlockedExchange ( VAR Target : LongInt;
                             Value : LongInt ) : LongInt; WINAPI ( 'InterlockedExchange' );


FUNCTION FreeResource ( hResData : HGLOBAL ) : WINBOOL; WINAPI ( 'FreeResource' );


FUNCTION LockResource ( hResData : HGLOBAL ) : POINTER; WINAPI ( 'LockResource' );


FUNCTION WinMain ( Instance : THANDLE;
                 hPrevInstance : THANDLE;
                 lpCmdLine : PChar;
                 nShowCmd : Integer ) : Integer; WINAPI ( 'WinMain' );


FUNCTION FreeLibrary ( hLibModule : THANDLE ) : WINBOOL; WINAPI ( 'FreeLibrary' );



PROCEDURE FreeLibraryAndExitThread ( hLibModule : HMODULE;
                                  dwExitCode : DWord ); WINAPI ( 'FreeLibraryAndExitThread' );


FUNCTION DisableThreadLibraryCalls ( hLibModule : HMODULE ) : WINBOOL; WINAPI ( 'DisableThreadLibraryCalls' );


FUNCTION GetProcAddress ( hModule : THANDLE;
                        lpProcName : PChar ) : TFarProc; WINAPI ( 'GetProcAddress' );


FUNCTION GetVersion : DWord; WINAPI ( 'GetVersion' );


{function SendMessage(Wnd: HWND; Msg: UINT; xwParam: UINT; xlParam: LPARAM32): LRESULT; WINAPI('SendMessage');}

FUNCTION GlobalAlloc ( uFlags : Word;
                     dwBytes : DWord ) : HGLOBAL; WINAPI ( 'GlobalAlloc' );


FUNCTION GlobalDiscard ( hglbMem : HGLOBAL ) : HGLOBAL; WINAPI ( 'GlobalDiscard' );


FUNCTION GlobalReAlloc ( hMem : HGLOBAL;
                       dwBytes : DWord;
                       uFlags : Word ) : HGLOBAL; WINAPI ( 'GlobalReAlloc' );


FUNCTION GlobalSize ( hMem : HGLOBAL ) : DWord; WINAPI ( 'GlobalSize' );


FUNCTION GlobalFlags ( hMem : HGLOBAL ) : Word; WINAPI ( 'GlobalFlags' );



FUNCTION GlobalLock ( hMem : HGLOBAL ) : POINTER; WINAPI ( 'GlobalLock' );


FUNCTION GlobalHandle ( pMem : POINTER ) : HGLOBAL; WINAPI ( 'GlobalHandle' );



FUNCTION GlobalUnlock ( hMem : HGLOBAL ) : WINBOOL; WINAPI ( 'GlobalUnlock' );



FUNCTION GlobalFree ( hMem : HGLOBAL ) : HGLOBAL; WINAPI ( 'GlobalFree' );


FUNCTION GlobalCompact ( dwMinFree : DWord ) : Word; WINAPI ( 'GlobalCompact' );



PROCEDURE GlobalFix ( hMem : HGLOBAL ); WINAPI ( 'GlobalFix' );



PROCEDURE GlobalUnfix ( hMem : HGLOBAL ); WINAPI ( 'GlobalUnfix' );



FUNCTION GlobalWire ( hMem : HGLOBAL ) : POINTER; WINAPI ( 'GlobalWire' );



FUNCTION GlobalUnWire ( hMem : HGLOBAL ) : WINBOOL; WINAPI ( 'GlobalUnWire' );



PROCEDURE GlobalMemoryStatus ( lpBuffer : PMEMORYSTATUS ); WINAPI ( 'GlobalMemoryStatus' );



FUNCTION LocalAlloc ( uFlags : Word;
                    uBytes : Word ) : HLOCAL; WINAPI ( 'LocalAlloc' );


FUNCTION LocalDiscard ( hlocMem : HLOCAL ) : HLOCAL; WINAPI ( 'LocalDiscard' );


FUNCTION LocalReAlloc ( hMem : HLOCAL;
                      uBytes : Word;
                      uFlags : Word ) : HLOCAL; WINAPI ( 'LocalReAlloc' );



FUNCTION LocalLock ( hMem : HLOCAL ) : POINTER; WINAPI ( 'LocalLock' );



FUNCTION LocalHandle ( pMem : POINTER ) : HLOCAL; WINAPI ( 'LocalHandle' );



FUNCTION LocalUnlock ( hMem : HLOCAL ) : WINBOOL; WINAPI ( 'LocalUnlock' );



FUNCTION LocalSize ( hMem : HLOCAL ) : Word; WINAPI ( 'LocalSize' );



FUNCTION LocalFlags ( hMem : HLOCAL ) : Word; WINAPI ( 'LocalFlags' );



FUNCTION LocalFree ( hMem : HLOCAL ) : HLOCAL; WINAPI ( 'LocalFree' );



FUNCTION LocalShrink ( hMem : HLOCAL;
                     cbNewSize : Word ) : Word; WINAPI ( 'LocalShrink' );



FUNCTION LocalCompact ( uMinFree : Word ) : Word; WINAPI ( 'LocalCompact' );



FUNCTION FlushInstructionCache ( hProcess : THandle;
                               lpBaseAddress : POINTER;
                               dwSize : DWord ) : WINBOOL; WINAPI ( 'FlushInstructionCache' );



FUNCTION VirtualAlloc ( lpAddress : POINTER;
                      dwSize : DWord;
                      flAllocationType : DWord;
                      flProtect : DWord ) : POINTER; WINAPI ( 'VirtualAlloc' );



FUNCTION VirtualFree ( lpAddress : POINTER;
                     dwSize : DWord;
                     dwFreeType : DWord ) : WINBOOL; WINAPI ( 'VirtualFree' );



FUNCTION VirtualProtect ( lpAddress : POINTER;
                        dwSize : DWord;
                        flNewProtect : DWord;
                        VAR lpflOldProtect : DWord ) : WINBOOL; WINAPI ( 'VirtualProtect' );



FUNCTION VirtualQuery ( lpAddress : POINTER;
                      lpBuffer : PMEMORY_BASIC_INFORMATION;
                      dwLength : DWord ) : DWord; WINAPI ( 'VirtualQuery' );



FUNCTION VirtualProtectEx ( hProcess : THandle;
                          lpAddress : POINTER;
                          dwSize : DWord;
                          flNewProtect : DWord;
                          VAR lpflOldProtect : DWord ) : WINBOOL; WINAPI ( 'VirtualProtectEx' );



FUNCTION VirtualQueryEx ( hProcess : THandle;
                        lpAddress : POINTER;
                        VAR lpBuffer : TMEMORY_BASIC_INFORMATION;
                        dwLength : DWord ) : DWord; WINAPI ( 'VirtualQueryEx' );



FUNCTION HeapCreate ( flOptions : DWord;
                    dwInitialSize : DWord;
                    dwMaximumSize : DWord ) : THandle; WINAPI ( 'HeapCreate' );


FUNCTION HeapDestroy ( hHeap : THandle ) : WINBOOL; WINAPI ( 'HeapDestroy' );


FUNCTION HeapAlloc ( hHeap : THandle;
                   dwFlags : DWord;
                   dwBytes : DWord ) : POINTER; WINAPI ( 'HeapAlloc' );


FUNCTION HeapReAlloc ( hHeap : THandle;
                     dwFlags : DWord;
                     lpMem : POINTER;
                     dwBytes : DWord ) : POINTER; WINAPI ( 'HeapReAlloc' );


FUNCTION HeapFree ( hHeap : THandle;
                  dwFlags : DWord;
                  lpMem : POINTER ) : WINBOOL; WINAPI ( 'HeapFree' );


FUNCTION HeapSize ( hHeap : THandle;
                  dwFlags : DWord;
                  lpMem : POINTER ) : DWord; WINAPI ( 'HeapSize' );


FUNCTION HeapValidate ( hHeap : THandle;
                      dwFlags : DWord;
                      lpMem : POINTER ) : WINBOOL; WINAPI ( 'HeapValidate' );


FUNCTION HeapCompact ( hHeap : THandle;
                     dwFlags : DWord ) : Word; WINAPI ( 'HeapCompact' );


FUNCTION GetProcessHeap : THandle; WINAPI ( 'GetProcessHeap' );


FUNCTION GetProcessHeaps ( NumberOfHeaps : DWord;
                         ProcessHeaps : PHANDLE ) : DWord; WINAPI ( 'GetProcessHeaps' );


FUNCTION HeapLock ( hHeap : THandle ) : WINBOOL; WINAPI ( 'HeapLock' );


FUNCTION HeapUnlock ( hHeap : THandle ) : WINBOOL; WINAPI ( 'HeapUnlock' );


FUNCTION HeapWalk ( hHeap : THandle;
                  lpEntry : PPROCESS_HEAP_ENTRY ) : WINBOOL; WINAPI ( 'HeapWalk' );


FUNCTION GetProcessAffinityMask ( hProcess : THandle;
                                VAR lpProcessAffinityMask,
                                lpSystemAffinityMask : DWord ) : WINBOOL; WINAPI ( 'GetProcessAffinityMask' );


FUNCTION GetProcessTimes ( hProcess : THandle;
                         VAR lpCreationTime : TFILETIME;
                         VAR lpExitTime : TFILETIME;
                         VAR lpKernelTime : TFILETIME;
                         VAR lpUserTime : TFILETIME ) : WINBOOL; WINAPI ( 'GetProcessTimes' );


FUNCTION GetProcessWorkingSetSize ( hProcess : THandle;
                                  VAR lpMinimumWorkingSetSize,
                                  lpMaximumWorkingSetSize : DWord ) : WINBOOL; WINAPI ( 'GetProcessWorkingSetSize' );


FUNCTION SetProcessWorkingSetSize ( hProcess : THandle;
                                  dwMinimumWorkingSetSize : DWord;
                                  dwMaximumWorkingSetSize : DWord ) : WINBOOL; WINAPI ( 'SetProcessWorkingSetSize' );


FUNCTION OpenProcess ( dwDesiredAccess : DWord;
                     bInheritHandle : WINBOOL;
                     dwProcessId : DWord ) : THandle; WINAPI ( 'OpenProcess' );


FUNCTION GetCurrentProcess : THandle; WINAPI ( 'GetCurrentProcess' );


FUNCTION GetCurrentProcessId : DWord; WINAPI ( 'GetCurrentProcessId' );


PROCEDURE ExitProcess ( uExitCode : Word ); WINAPI ( 'ExitProcess' );


FUNCTION TerminateProcess ( hProcess : THandle;
                          uExitCode : Word ) : WINBOOL; WINAPI ( 'TerminateProcess' );


FUNCTION GetExitCodeProcess ( hProcess : THandle;
                            VAR lpExitCode : DWord ) : WINBOOL; WINAPI ( 'GetExitCodeProcess' );


PROCEDURE FatalExit ( ExitCode : Integer ); WINAPI ( 'FatalExit' );


PROCEDURE RaiseException ( dwExceptionCode : DWord;
                        dwExceptionFlags : DWord;
                        nNumberOfArguments : DWord;
                        CONST lpArguments : DWord ); WINAPI ( 'RaiseException' );


FUNCTION UnhandledExceptionFilter ( ExceptionInfo : PEXCEPTION_POINTERS ) : LongInt; WINAPI ( 'UnhandledExceptionFilter' );


FUNCTION CreateThread ( lpThreadAttributes : PSECURITY_ATTRIBUTES;
                      dwStackSize : DWord;
                      lpStartAddress : Pointer{PTHREAD_START_ROUTINE};
                      lpParameter : POINTER;
                      dwCreationFlags : DWord;
                      VAR lpThreadId : DWord ) : THandle; WINAPI ( 'CreateThread' );



FUNCTION CreateRemoteThread ( hProcess : THandle;
                            lpThreadAttributes : PSECURITY_ATTRIBUTES;
                            dwStackSize : DWord;
                            lpStartAddress : PTHREAD_START_ROUTINE;
                            lpParameter : POINTER;
                            dwCreationFlags : DWord;
                            VAR lpThreadId : DWord ) : THandle; WINAPI ( 'CreateRemoteThread' );



FUNCTION GetCurrentThread : THandle; WINAPI ( 'GetCurrentThread' );



FUNCTION GetCurrentThreadId : DWord; WINAPI ( 'GetCurrentThreadId' );



FUNCTION SetThreadAffinityMask ( hThread : THandle;
                               dwThreadAffinityMask : DWord ) : DWord; WINAPI ( 'SetThreadAffinityMask' );



FUNCTION SetThreadPriority ( hThread : THandle;
                           nPriority : Integer ) : WINBOOL; WINAPI ( 'SetThreadPriority' );



FUNCTION GetThreadPriority ( hThread : THandle ) : Integer; WINAPI ( 'GetThreadPriority' );



FUNCTION GetThreadTimes ( hThread : THandle;
                        lpCreationTime : PFILETIME;
                        lpExitTime : PFILETIME;
                        lpKernelTime : PFILETIME;
                        lpUserTime : PFILETIME ) : WINBOOL; WINAPI ( 'GetThreadTimes' );



PROCEDURE ExitThread ( dwExitCode : DWord ); WINAPI ( 'ExitThread' );



FUNCTION TerminateThread ( hThread : THandle;
                         dwExitCode : DWord ) : WINBOOL; WINAPI ( 'TerminateThread' );



FUNCTION GetExitCodeThread ( hThread : THandle;
                           VAR lpExitCode : DWord ) : WINBOOL; WINAPI ( 'GetExitCodeThread' );


FUNCTION GetThreadSelectorEntry ( hThread : THandle;
                                dwSelector : DWord;
                                VAR lpSelectorEntry : TLDT_ENTRY ) : WINBOOL; WINAPI ( 'GetThreadSelectorEntry' );



FUNCTION GetLastError : DWord; WINAPI ( 'GetLastError' );



PROCEDURE SetLastError ( dwErrCode : DWord ); WINAPI ( 'SetLastError' );



FUNCTION GetOverlappedResult ( hFile : THandle;
                             lpOverlapped : POVERLAPPED;
                             VAR lpNumberOfBytesTransferred : DWord;
                             bWait : WINBOOL ) : WINBOOL; WINAPI ( 'GetOverlappedResult' );



FUNCTION CreateIoCompletionPort ( FileHandle : THandle;
                                ExistingCompletionPort : THandle;
                                CompletionKey : DWord;
                                NumberOfConcurrentThreads : DWord ) : THandle; WINAPI ( 'CreateIoCompletionPort' );



FUNCTION GetQueuedCompletionStatus ( CompletionPort : THandle;
                                   VAR lpNumberOfBytesTransferred : DWord;
                                   VAR lpCompletionKey : DWord;
                                   VAR lpOverlapped : TOVERLAPPED;
                                   dwMilliseconds : DWord ) : WINBOOL; WINAPI ( 'GetQueuedCompletionStatus' );


FUNCTION SetErrorMode ( uMode : Word ) : Word; WINAPI ( 'SetErrorMode' );



FUNCTION ReadProcessMemory ( hProcess : THandle;
                           lpBaseAddress : POINTER;
                           lpBuffer : POINTER;
                           nSize : DWord;
                           VAR lpNumberOfBytesRead : DWord ) : WINBOOL; WINAPI ( 'ReadProcessMemory' );



FUNCTION WriteProcessMemory ( hProcess : THandle;
                            lpBaseAddress : POINTER;
                            lpBuffer : POINTER;
                            nSize : DWord;
                           VAR  lpNumberOfBytesWritten : DWord ) : WINBOOL; WINAPI ( 'WriteProcessMemory' );



FUNCTION GetThreadContext ( hThread : THandle;
                          VAR lpContext : TCONTEXT ) : WINBOOL; WINAPI ( 'GetThreadContext' );



FUNCTION SetThreadContext ( hThread : THandle;
                          CONST lpContext : TCONTEXT ) : WINBOOL; WINAPI ( 'SetThreadContext' );



FUNCTION SuspendThread ( hThread : THandle ) : DWord; WINAPI ( 'SuspendThread' );



FUNCTION ResumeThread ( hThread : THandle ) : DWord; WINAPI ( 'ResumeThread' );



PROCEDURE DebugBreak; WINAPI ( 'DebugBreak' );



FUNCTION WaitForDebugEvent ( lpDebugEvent : PDEBUG_EVENT;
                           dwMilliseconds : DWord ) : WINBOOL; WINAPI ( 'WaitForDebugEvent' );



FUNCTION ContinueDebugEvent ( dwProcessId : DWord;
                            dwThreadId : DWord;
                            dwContinueStatus : DWord ) : WINBOOL; WINAPI ( 'ContinueDebugEvent' );



FUNCTION DebugActiveProcess ( dwProcessId : DWord ) : WINBOOL; WINAPI ( 'DebugActiveProcess' );



PROCEDURE InitializeCriticalSection ( VAR lpCriticalSection : TCRITICAL_SECTION ); WINAPI ( 'InitializeCriticalSection' );



PROCEDURE EnterCriticalSection ( VAR lpCriticalSection : TCRITICAL_SECTION ); WINAPI ( 'EnterCriticalSection' );



PROCEDURE LeaveCriticalSection ( VAR lpCriticalSection : TCRITICAL_SECTION ); WINAPI ( 'LeaveCriticalSection' );



PROCEDURE DeleteCriticalSection ( VAR lpCriticalSection : TCRITICAL_SECTION ); WINAPI ( 'DeleteCriticalSection' );



FUNCTION SetEvent ( hEvent : THandle ) : WINBOOL; WINAPI ( 'SetEvent' );



FUNCTION ResetEvent ( hEvent : THandle ) : WINBOOL; WINAPI ( 'ResetEvent' );



FUNCTION PulseEvent ( hEvent : THandle ) : WINBOOL; WINAPI ( 'PulseEvent' );



FUNCTION ReleaseSemaphore ( hSemaphore : THandle;
                          lReleaseCount : LongInt;
                          VAR lpPreviousCount : LongInt ) : WINBOOL; WINAPI ( 'ReleaseSemaphore' );



FUNCTION ReleaseMutex ( hMutex : THandle ) : WINBOOL; WINAPI ( 'ReleaseMutex' );



FUNCTION WaitForSingleObject ( hHandle : Integer;
                             dwMilliseconds : DWord ) : DWord; WINAPI ( 'WaitForSingleObject' );



FUNCTION WaitForMultipleObjects ( nCount : DWord;
                                CONST lpHandles : THandle;
                                bWaitAll : WINBOOL;
                                dwMilliseconds : DWord ) : DWord; WINAPI ( 'WaitForMultipleObjects' );



PROCEDURE Sleep ( dwMilliseconds : DWord ); WINAPI ( 'Sleep' );



FUNCTION LoadResource ( hModule : THANDLE;
                      hResInfo : HRSRC ) : HGLOBAL; WINAPI ( 'LoadResource' );



FUNCTION SizeofResource ( hModule : THANDLE;
                        hResInfo : HRSRC ) : DWord; WINAPI ( 'SizeofResource' );




FUNCTION GlobalDeleteAtom ( nAtom : TAtom ) : TAtom; WINAPI ( 'GlobalDeleteAtom' );



FUNCTION InitAtomTable ( nSize : DWord ) : WINBOOL; WINAPI ( 'InitAtomTable' );



FUNCTION DeleteAtom ( nAtom : TAtom ) : TAtom; WINAPI ( 'DeleteAtom' );



FUNCTION SetHandleCount ( uNumber : Word ) : Word; WINAPI ( 'SetHandleCount' );



FUNCTION GetLogicalDrives : DWord; WINAPI ( 'GetLogicalDrives' );



FUNCTION LockFile ( hFile : THandle;
                  dwFileOffsetLow : DWord;
                  dwFileOffsetHigh : DWord;
                  nNumberOfBytesToLockLow : DWord;
                  nNumberOfBytesToLockHigh : DWord ) : WINBOOL; WINAPI ( 'LockFile' );



FUNCTION UnlockFile ( hFile : THandle;
                    dwFileOffsetLow : DWord;
                    dwFileOffsetHigh : DWord;
                    nNumberOfBytesToUnlockLow : DWord;
                    nNumberOfBytesToUnlockHigh : DWord ) : WINBOOL; WINAPI ( 'UnlockFile' );



FUNCTION LockFileEx ( hFile : THandle;
                    dwFlags : DWord;
                    dwReserved : DWord;
                    nNumberOfBytesToLockLow : DWord;
                    nNumberOfBytesToLockHigh : DWord;
                    lpOverlapped : POVERLAPPED ) : WINBOOL; WINAPI ( 'LockFileEx' );


FUNCTION UnlockFileEx ( hFile : THandle;
                      dwReserved : DWord;
                      nNumberOfBytesToUnlockLow : DWord;
                      nNumberOfBytesToUnlockHigh : DWord;
                      lpOverlapped : POVERLAPPED ) : WINBOOL; WINAPI ( 'UnlockFileEx' );


FUNCTION GetFileInformationByHandle ( hFile : THandle;
                                    VAR lpFileInformation : TBY_HANDLE_FILE_INFORMATION ) : WINBOOL; WINAPI ( 'GetFileInformationByHandle' );



FUNCTION GetFileType ( hFile : THandle ) : DWord; WINAPI ( 'GetFileType' );



FUNCTION GetFileSize ( hFile : THandle;
                     lpFileSizeHigh : pDWord ) : DWord; WINAPI ( 'GetFileSize' );



FUNCTION GetStdHandle ( nStdHandle : Integer ) : THandle; WINAPI ( 'GetStdHandle' );



FUNCTION SetStdHandle ( nStdHandle : Integer;
                      hHandle : THandle ) : WINBOOL; WINAPI ( 'SetStdHandle' );



FUNCTION WriteFile ( hFile : THandle;
                   CONST lpBuffer;
                   nNumberOfBytesToWrite : DWord;
                   VAR lpNumberOfBytesWritten : DWord;
                   lpOverlapped : POVERLAPPED ) : WINBOOL; WINAPI ( 'WriteFile' );



FUNCTION ReadFile ( hFile : THandle;
                  VAR lpBuffer;
                  nNumberOfBytesToRead : DWord;
                  VAR lpNumberOfBytesRead : DWord;
                  lpOverlapped : POVERLAPPED ) : WINBOOL; WINAPI ( 'ReadFile' );



FUNCTION FlushFileBuffers ( hFile : THandle ) : WINBOOL; WINAPI ( 'FlushFileBuffers' );



FUNCTION DeviceIoControl ( hDevice : THandle;
                         dwIoControlCode : DWord;
                         lpInBuffer : POINTER;
                         nInBufferSize : DWord;
                         lpOutBuffer : POINTER;
                         nOutBufferSize : DWord;
                         VAR lpBytesReturned : DWord;
                         VAR lpOverlapped : TOVERLAPPED ) : WINBOOL; WINAPI ( 'DeviceIoControl' );



FUNCTION SetEndOfFile ( hFile : THandle ) : WINBOOL; WINAPI ( 'SetEndOfFile' );



FUNCTION SetFilePointer ( hFile : THandle;
                        lDistanceToMove : LongInt;
                        VAR lpDistanceToMoveHigh : LongInt;
                        dwMoveMethod : DWord ) : DWord; WINAPI ( 'SetFilePointer' );



FUNCTION FindClose ( hFindFile : THandle ) : WINBOOL; WINAPI ( 'FindClose' );



FUNCTION GetFileTime ( hFile : THandle;
                     VAR lpCreationTime : TFILETIME;
                     VAR lpLastAccessTime : TFILETIME;
                     VAR lpLastWriteTime : TFILETIME ) : WINBOOL; WINAPI ( 'GetFileTime' );



FUNCTION SetFileTime ( hFile : THandle;
                     CONST lpCreationTime : TFILETIME;
                     CONST lpLastAccessTime : TFILETIME;
                     CONST lpLastWriteTime : TFILETIME ) : WINBOOL; WINAPI ( 'SetFileTime' );



FUNCTION CloseHandle ( hObject : THandle ) : WINBOOL; WINAPI ( 'CloseHandle' );



FUNCTION DuplicateHandle ( hSourceProcessHandle : THandle;
                         hSourceHandle : THandle;
                         hTargetProcessHandle : THandle;
                         lpTargetHandle : PHandle;
                         dwDesiredAccess : DWord;
                         bInheritHandle : WINBOOL;
                         dwOptions : DWord ) : WINBOOL; WINAPI ( 'DuplicateHandle' );



FUNCTION GetHandleInformation ( hObject : THandle;
                              VAR lpdwFlags : DWord ) : WINBOOL; WINAPI ( 'GetHandleInformation' );



FUNCTION SetHandleInformation ( hObject : THandle;
                              dwMask : DWord;
                              dwFlags : DWord ) : WINBOOL; WINAPI ( 'SetHandleInformation' );


FUNCTION LoadModule ( lpModuleName : PChar;
                    lpParameterBlock : POINTER ) : DWord; WINAPI ( 'LoadModule' );


FUNCTION WinExec ( lpCmdLine : PChar;
                 uCmdShow : Word ) : Word; WINAPI ( 'WinExec' );

FUNCTION ClearCommBreak ( hFile : THandle ) : WINBOOL; WINAPI ( 'ClearCommBreak' );

FUNCTION ClearCommError ( hFile : THandle;
                        VAR lpErrors : DWord;
                        VAR lpStat : TCOMSTAT ) : WINBOOL; WINAPI ( 'ClearCommError' );



FUNCTION SetupComm ( hFile : THandle;
                   dwInQueue : DWord;
                   dwOutQueue : DWord ) : WINBOOL; WINAPI ( 'SetupComm' );



FUNCTION EscapeCommFunction ( hFile : THandle;
                            dwFunc : DWord ) : WINBOOL; WINAPI ( 'EscapeCommFunction' );



FUNCTION GetCommConfig ( hCommDev : THandle;
                       VAR lpCC : TCOMMCONFIG;
                       VAR lpdwSize : DWord ) : WINBOOL; WINAPI ( 'GetCommConfig' );



FUNCTION GetCommMask ( hFile : THandle;
                     VAR lpEvtMask : DWord ) : WINBOOL; WINAPI ( 'GetCommMask' );



FUNCTION GetCommProperties ( hFile : THandle;
                           VAR lpCommProp : TCOMMPROP ) : WINBOOL; WINAPI ( 'GetCommProperties' );



FUNCTION GetCommModemStatus ( hFile : THandle;
                            VAR lpModemStat : DWord ) : WINBOOL; WINAPI ( 'GetCommModemStatus' );



FUNCTION GetCommState ( hFile : THandle;
                      VAR lpDCB : TDCB ) : WINBOOL; WINAPI ( 'GetCommState' );



FUNCTION GetCommTimeouts ( hFile : THandle;
                         lpCommTimeouts : PCOMMTIMEOUTS ) : WINBOOL; WINAPI ( 'GetCommTimeouts' );



FUNCTION PurgeComm ( hFile : THandle;
                   dwFlags : DWord ) : WINBOOL; WINAPI ( 'PurgeComm' );



FUNCTION SetCommBreak ( hFile : THandle ) : WINBOOL; WINAPI ( 'SetCommBreak' );



FUNCTION SetCommConfig ( hCommDev : THandle;
                       lpCC : PCOMMCONFIG;
                       dwSize : DWord ) : WINBOOL; WINAPI ( 'SetCommConfig' );



FUNCTION SetCommMask ( hFile : THandle;
                     dwEvtMask : DWord ) : WINBOOL; WINAPI ( 'SetCommMask' );



FUNCTION SetCommState ( hFile : THandle;
                      VAR lpDCB : TDCB ) : WINBOOL; WINAPI ( 'SetCommState' );



FUNCTION SetCommTimeouts ( hFile : THandle;
                         lpCommTimeouts : PCOMMTIMEOUTS ) : WINBOOL; WINAPI ( 'SetCommTimeouts' );



FUNCTION TransmitCommChar ( hFile : THandle;
                          cChar : Char ) : WINBOOL; WINAPI ( 'TransmitCommChar' );



FUNCTION WaitCommEvent ( hFile : THandle;
                       VAR lpEvtMask : DWord;
                       VAR lpOverlapped : TOVERLAPPED ) : WINBOOL; WINAPI ( 'WaitCommEvent' );




FUNCTION SetTapePosition ( hDevice : THandle;
                         dwPositionMethod : DWord;
                         dwPartition : DWord;
                         dwOffsetLow : DWord;
                         dwOffsetHigh : DWord;
                         bImmediate : WINBOOL ) : DWord; WINAPI ( 'SetTapePosition' );



FUNCTION GetTapePosition ( hDevice : THandle;
                         dwPositionType : DWord;
                         VAR lpdwPartition,
                         lpdwOffsetLow,
                         lpdwOffsetHigh : DWord ) : DWord; WINAPI ( 'GetTapePosition' );



FUNCTION PrepareTape ( hDevice : THandle;
                     dwOperation : DWord;
                     bImmediate : WINBOOL ) : DWord; WINAPI ( 'PrepareTape' );



FUNCTION EraseTape ( hDevice : THandle;
                   dwEraseType : DWord;
                   bImmediate : WINBOOL ) : DWord; WINAPI ( 'EraseTape' );



FUNCTION CreateTapePartition ( hDevice : THandle;
                             dwPartitionMethod : DWord;
                             dwCount : DWord;
                             dwSize : DWord ) : DWord; WINAPI ( 'CreateTapePartition' );



FUNCTION WriteTapemark ( hDevice : THandle;
                       dwTapemarkType : DWord;
                       dwTapemarkCount : DWord;
                       bImmediate : WINBOOL ) : DWord; WINAPI ( 'WriteTapemark' );



FUNCTION GetTapeStatus ( hDevice : THandle ) : DWord; WINAPI ( 'GetTapeStatus' );



FUNCTION GetTapeParameters ( hDevice : THandle;
                           dwOperation : DWord;
                           VAR lpdwSize : DWord;
                           lpTapeInformation : POINTER ) : DWord; WINAPI ( 'GetTapeParameters' );


FUNCTION SetTapeParameters ( hDevice : THandle;
                           dwOperation : DWord;
                           lpTapeInformation : POINTER ) : DWord; WINAPI ( 'SetTapeParameters' );


FUNCTION Beep ( dwFreq : DWord;
              dwDuration : DWord ) : WINBOOL; WINAPI ( 'Beep' );



PROCEDURE OpenSound; WINAPI ( 'OpenSound' );



PROCEDURE CloseSound; WINAPI ( 'CloseSound' );



PROCEDURE StartSound; WINAPI ( 'StartSound' );



PROCEDURE StopSound; WINAPI ( 'StopSound' );



FUNCTION WaitSoundState ( nState : DWord ) : DWord; WINAPI ( 'WaitSoundState' );



FUNCTION SyncAllVoices : DWord; WINAPI ( 'SyncAllVoices' );



FUNCTION CountVoiceNotes ( nVoice : DWord ) : DWord; WINAPI ( 'CountVoiceNotes' );



FUNCTION GetThresholdEvent : PDWord; WINAPI ( 'GetThresholdEvent' );



FUNCTION GetThresholdStatus : DWord; WINAPI ( 'GetThresholdStatus' );



FUNCTION SetSoundNoise ( nSource : DWord;
                       nDuration : DWord ) : DWord; WINAPI ( 'SetSoundNoise' );



FUNCTION SetVoiceAccent ( nVoice : DWord;
                        nTempo : DWord;
                        nVolume : DWord;
                        nMode : DWord;
                        nPitch : DWord ) : DWord; WINAPI ( 'SetVoiceAccent' );



FUNCTION SetVoiceEnvelope ( nVoice : DWord;
                          nShape : DWord;
                          nRepeat : DWord ) : DWord; WINAPI ( 'SetVoiceEnvelope' );



FUNCTION SetVoiceNote ( nVoice : DWord;
                      nValue : DWord;
                      nLength : DWord;
                      nCdots : DWord ) : DWord; WINAPI ( 'SetVoiceNote' );



FUNCTION SetVoiceQueueSize ( nVoice : DWord;
                           nBytes : DWord ) : DWord; WINAPI ( 'SetVoiceQueueSize' );



FUNCTION SetVoiceSound ( nVoice : DWord;
                       Frequency : DWord;
                       nDuration : DWord ) : DWord; WINAPI ( 'SetVoiceSound' );



FUNCTION SetVoiceThreshold ( nVoice : DWord;
                           nNotes : DWord ) : DWord; WINAPI ( 'SetVoiceThreshold' );



FUNCTION MulDiv ( nNumber : Integer;
                nNumerator : Integer;
                nDenominator : Integer ) : Integer; WINAPI ( 'MulDiv' );



PROCEDURE GetSystemTime ( VAR lpSystemTime : TSYSTEMTIME ); WINAPI ( 'GetSystemTime' );


PROCEDURE GetSystemTimeAsFileTime ( VAR lpSystemTimeAsFileTime : TFILETIME ); WINAPI ( 'GetSystemTimeAsFileTime' );


FUNCTION SetSystemTime ( CONST lpSystemTime : TSYSTEMTIME ) : WINBOOL; WINAPI ( 'SetSystemTime' );



PROCEDURE GetLocalTime ( VAR lpSystemTime : TSYSTEMTIME ); WINAPI ( 'GetLocalTime' );



FUNCTION SetLocalTime ( CONST lpSystemTime : TSYSTEMTIME ) : WINBOOL; WINAPI ( 'SetLocalTime' );



PROCEDURE GetSystemInfo ( VAR lpSystemInfo : TSYSTEM_INFO ); WINAPI ( 'GetSystemInfo' );


FUNCTION SystemTimeToTzSpecificLocalTime ( VAR lpTimeZoneInformation : TTIME_ZONE_INFORMATION;
                                         VAR lpUniversalTime : TSYSTEMTIME;
                                         VAR lpLocalTime : TSYSTEMTIME ) : WINBOOL; WINAPI ( 'SystemTimeToTzSpecificLocalTime' );



FUNCTION GetTimeZoneInformation ( VAR lpTimeZoneInformation : TIME_ZONE_INFORMATION ) : DWord; WINAPI ( 'GetTimeZoneInformation' );



FUNCTION SetTimeZoneInformation ( CONST lpTimeZoneInformation : TIME_ZONE_INFORMATION ) : WINBOOL; WINAPI ( 'SetTimeZoneInformation' );


FUNCTION SystemTimeToFileTime ( CONST lpSystemTime : TSYSTEMTIME;
                              VAR lpFileTime : TFILETIME ) : WINBOOL; WINAPI ( 'SystemTimeToFileTime' );



FUNCTION FileTimeToLocalFileTime ( CONST lpFileTime : TFILETIME;
                                 VAR lpLocalFileTime : TFILETIME ) : WINBOOL; WINAPI ( 'FileTimeToLocalFileTime' );



FUNCTION LocalFileTimeToFileTime ( CONST lpLocalFileTime : TFILETIME;
                                 VAR lpFileTime : TFILETIME ) : WINBOOL; WINAPI ( 'LocalFileTimeToFileTime' );



FUNCTION FileTimeToSystemTime ( CONST lpFileTime : TFILETIME;
                              VAR lpSystemTime : TSYSTEMTIME ) : WINBOOL; WINAPI ( 'FileTimeToSystemTime' );



FUNCTION CompareFileTime ( CONST lpFileTime1 : TFILETIME;
                         CONST lpFileTime2 : TFILETIME ) : LongInt; WINAPI ( 'CompareFileTime' );



FUNCTION FileTimeToDosDateTime ( CONST lpFileTime : TFILETIME;
                               VAR lpFatDate : Word;
                               VAR lpFatTime : Word ) : WINBOOL; WINAPI ( 'FileTimeToDosDateTime' );



FUNCTION DosDateTimeToFileTime ( wFatDate : Word;
                               wFatTime : Word;
                               VAR lpFileTime : TFILETIME ) : WINBOOL; WINAPI ( 'DosDateTimeToFileTime' );



FUNCTION GetTickCount : DWord; WINAPI ( 'GetTickCount' );

FUNCTION SetSystemTimeAdjustment ( dwTimeAdjustment : DWord;
                                 bTimeAdjustmentDisabled : WINBOOL ) : WINBOOL; WINAPI ( 'SetSystemTimeAdjustment' );

FUNCTION GetSystemTimeAdjustment ( VAR lpTimeAdjustment,
                                 lpTimeIncrement : DWord;
                                 VAR lpTimeAdjustmentDisabled : WINBOOL ) : WINBOOL; WINAPI ( 'GetSystemTimeAdjustment' );



FUNCTION CreatePipe ( VAR hReadPipe : THandle;
                    VAR hWritePipe : THandle;
                    lpPipeAttributes : PSECURITY_ATTRIBUTES;
                    nSize : DWord ) : WINBOOL; WINAPI ( 'CreatePipe' );



FUNCTION ConnectNamedPipe ( hNamedPipe : THandle;
                          VAR lpOverlapped : TOVERLAPPED ) : WINBOOL; WINAPI ( 'ConnectNamedPipe' );



FUNCTION DisconnectNamedPipe ( hNamedPipe : THandle ) : WINBOOL; WINAPI ( 'DisconnectNamedPipe' );



FUNCTION SetNamedPipeHandleState ( hNamedPipe : THandle;
                                 VAR lpMode,
                                 lpMaxCollectionCount,
                                 lpCollectDataTimeout : DWord ) : WINBOOL; WINAPI ( 'SetNamedPipeHandleState' );



FUNCTION GetNamedPipeInfo ( hNamedPipe : THandle;
                          VAR lpFlags,
                          lpOutBufferSize,
                          lpInBufferSize,
                          lpMaxInstances : DWord ) : WINBOOL; WINAPI ( 'GetNamedPipeInfo' );



FUNCTION PeekNamedPipe ( hNamedPipe : THandle;
                       VAR lpBuffer;
                       nBufferSize : DWord;
                       VAR lpBytesRead,
                       lpTotalBytesAvail,
                       lpBytesLeftThisMessage : DWord ) : WINBOOL; WINAPI ( 'PeekNamedPipe' );



FUNCTION TransactNamedPipe ( hNamedPipe : THandle;
                           VAR lpInBuffer;
                           nInBufferSize : DWord;
                           VAR lpOutBuffer;
                           nOutBufferSize : DWord;
                           VAR lpBytesRead : DWord;
                           VAR lpOverlapped : TOVERLAPPED ) : WINBOOL; WINAPI ( 'TransactNamedPipe' );




FUNCTION GetMailslotInfo ( hMailslot : THandle;
                         VAR lpMaxMessageSize,
                         lpNextSize,
                         lpMessageCount,
                         lpReadTimeout : DWord ) : WINBOOL; WINAPI ( 'GetMailslotInfo' );



FUNCTION SetMailslotInfo ( hMailslot : THandle;
                         lReadTimeout : DWord ) : WINBOOL; WINAPI ( 'SetMailslotInfo' );



FUNCTION MapViewOfFile ( hFileMappingObject : THandle;
                       dwDesiredAccess : DWord;
                       dwFileOffsetHigh : DWord;
                       dwFileOffsetLow : DWord;
                       dwNumberOfBytesToMap : DWord ) : POINTER; WINAPI ( 'MapViewOfFile' );



FUNCTION FlushViewOfFile ( lpBaseAddress : POINTER;
                         dwNumberOfBytesToFlush : DWord ) : WINBOOL; WINAPI ( 'FlushViewOfFile' );



FUNCTION UnmapViewOfFile ( lpBaseAddress : POINTER ) : WINBOOL; WINAPI ( 'UnmapViewOfFile' );


FUNCTION OpenFile ( lpFileName : PChar;
                  VAR lpReOpenBuff : TOFSTRUCT;
                  uStyle : Word ) : HFILE; WINAPI ( 'OpenFile' );


FUNCTION _lopen ( lpPathName : PChar;
                iReadWrite : Integer ) : HFILE; WINAPI ( '_lopen' );


FUNCTION _lcreat ( lpPathName : PChar;
                 iAttribute : Integer ) : HFILE; WINAPI ( '_lcreat' );


FUNCTION _lread ( _hFile : HFILE;
                VAR lpBuffer;
                uBytes : Word ) : Word; WINAPI ( '_lread' );



FUNCTION _lwrite ( _hFile : HFILE;
                 VAR lpBuffer;
                 uBytes : Word ) : Word; WINAPI ( '_lwrite' );



FUNCTION _hread ( _hFile : HFILE;
                VAR lpBuffer;
                lBytes : LongInt ) : LongInt; WINAPI ( '_hread' );



FUNCTION _hwrite ( _hFile : HFILE;
                 VAR lpBuffer;
                 lBytes : LongInt ) : LongInt; WINAPI ( '_hwrite' );


FUNCTION _lclose ( _hFile : HFILE ) : HFILE; WINAPI ( '_lclose' );


FUNCTION _llseek ( _hFile : HFILE;
                 lOffset : LongInt;
                 iOrigin : Integer ) : LongInt; WINAPI ( '_llseek' );



FUNCTION IsTextUnicode ( VAR lpBuffer;
                       cb : Integer;
                       VAR lpi : Integer ) : WINBOOL; WINAPI ( 'IsTextUnicode' );



FUNCTION TlsAlloc : DWord; WINAPI ( 'TlsAlloc' );


FUNCTION TlsGetValue ( dwTlsIndex : DWord ) : POINTER; WINAPI ( 'TlsGetValue' );



FUNCTION TlsSetValue ( dwTlsIndex : DWord;
                     lpTlsValue : POINTER ) : WINBOOL; WINAPI ( 'TlsSetValue' );



FUNCTION TlsFree ( dwTlsIndex : DWord ) : WINBOOL; WINAPI ( 'TlsFree' );


FUNCTION SleepEx ( dwMilliseconds : DWord;
                 bAlertable : WINBOOL ) : DWord; WINAPI ( 'SleepEx' );



FUNCTION WaitForSingleObjectEx ( hHandle : THandle;
                               dwMilliseconds : DWord;
                               bAlertable : WINBOOL ) : DWord; WINAPI ( 'WaitForSingleObjectEx' );



FUNCTION WaitForMultipleObjectsEx ( nCount : DWord;
                                  CONST lpHandles : THandle;
                                  bWaitAll : WINBOOL;
                                  dwMilliseconds : DWord;
                                  bAlertable : WINBOOL ) : DWord; WINAPI ( 'WaitForMultipleObjectsEx' );



FUNCTION ReadFileEx ( hFile : THandle;
                    VAR lpBuffer;
                    nNumberOfBytesToRead : DWord;
                    VAR lpOverlapped : TOVERLAPPED;
                    lpCompletionRoutine : POVERLAPPED_COMPLETION_ROUTINE ) : WINBOOL; WINAPI ( 'ReadFileEx' );



FUNCTION WriteFileEx ( hFile : THandle;
                     VAR lpBuffer;
                     nNumberOfBytesToWrite : DWord;
                     VAR lpOverlapped : TOVERLAPPED;
                     lpCompletionRoutine : POVERLAPPED_COMPLETION_ROUTINE ) : WINBOOL; WINAPI ( 'WriteFileEx' );



FUNCTION BackupRead ( hFile : THandle;
                    VAR lpBuffer;
                    nNumberOfBytesToRead : DWord;
                    VAR lpNumberOfBytesRead : DWord;
                    bAbort : WINBOOL;
                    bProcessSecurity : WINBOOL;
                    VAR lpContext ) : WINBOOL; WINAPI ( 'BackupRead' );



FUNCTION BackupSeek ( hFile : THandle;
                    dwLowBytesToSeek : DWord;
                    dwHighBytesToSeek : DWord;
                    VAR lpdwLowByteSeeked,
                    lpdwHighByteSeeked : DWord;
                    VAR lpContext ) : WINBOOL; WINAPI ( 'BackupSeek' );



FUNCTION BackupWrite ( hFile : THandle;
                     VAR lpBuffer;
                     nNumberOfBytesToWrite : DWord;
                     VAR lpNumberOfBytesWritten : DWord;
                     bAbort : WINBOOL;
                     bProcessSecurity : WINBOOL;
                     VAR lpContext ) : WINBOOL; WINAPI ( 'BackupWrite' );


FUNCTION SetProcessShutdownParameters ( dwLevel : DWord;
                                      dwFlags : DWord ) : WINBOOL; WINAPI ( 'SetProcessShutdownParameters' );



FUNCTION GetProcessShutdownParameters ( VAR lpdwLevel,
                                      lpdwFlags : DWord ) : WINBOOL; WINAPI ( 'GetProcessShutdownParameters' );



PROCEDURE SetFileApisToOEM; WINAPI ( 'SetFileApisToOEM' );



PROCEDURE SetFileApisToANSI; WINAPI ( 'SetFileApisToANSI' );



FUNCTION AreFileApisANSI : WINBOOL; WINAPI ( 'AreFileApisANSI' );


FUNCTION CloseEventLog ( hEventLog : THandle ) : WINBOOL; WINAPI ( 'CloseEventLog' );



FUNCTION DeregisterEventSource ( hEventLog : THandle ) : WINBOOL; WINAPI ( 'DeregisterEventSource' );



FUNCTION NotifyChangeEventLog ( hEventLog : THandle;
                              hEvent : THandle ) : WINBOOL; WINAPI ( 'NotifyChangeEventLog' );



FUNCTION GetNumberOfEventLogRecords ( hEventLog : THandle;
                                    VAR NumberOfRecords : DWord ) : WINBOOL; WINAPI ( 'GetNumberOfEventLogRecords' );



FUNCTION GetOldestEventLogRecord ( hEventLog : THandle;
                                 VAR OldestRecord : DWord ) : WINBOOL; WINAPI ( 'GetOldestEventLogRecord' );


FUNCTION DuplicateToken ( ExistingTokenHandle : THandle;
                        ImpersonationLevel : SECURITY_IMPERSONATION_LEVEL;
                        VAR DuplicateTokenHandle : THandle ) : WINBOOL; WINAPI ( 'DuplicateToken' );


FUNCTION GetKernelObjectSecurity ( THandle : THandle;
                                 RequestedInformation : SECURITY_INFORMATION;
                                 VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                 nLength : DWord;
                                 VAR lpnLengthNeeded : DWord ) : WINBOOL; WINAPI ( 'GetKernelObjectSecurity' );


FUNCTION ImpersonateNamedPipeClient ( hNamedPipe : THandle ) : WINBOOL; WINAPI ( 'ImpersonateNamedPipeClient' );


FUNCTION ImpersonateSelf ( ImpersonationLevel : SECURITY_IMPERSONATION_LEVEL ) : WINBOOL; WINAPI ( 'ImpersonateSelf' );


FUNCTION RevertToSelf : WINBOOL; WINAPI ( 'RevertToSelf' );


FUNCTION SetThreadToken ( Thread : PHANDLE;
                        Token : THandle ) : WINBOOL; WINAPI ( 'SetThreadToken' );


FUNCTION AccessCheck ( pSecurityDescriptor : PSECURITY_DESCRIPTOR;
                     ClientToken : THandle;
                     DesiredAccess : DWord;
                     GenericMapping : PGENERIC_MAPPING;
                     PrivilegeSet : PPRIVILEGE_SET;
                     VAR PrivilegeSetLength,
                     GrantedAccess : DWord;
                     VAR AccessStatus : WinBool ) : WINBOOL; WINAPI ( 'AccessCheck' );


FUNCTION OpenProcessToken ( ProcessHandle : THandle;
                          DesiredAccess : DWord;
                          VAR TokenHandle : THandle ) : WINBOOL; WINAPI ( 'OpenProcessToken' );


FUNCTION OpenThreadToken ( ThreadHandle : THandle;
                         DesiredAccess : DWord;
                         OpenAsSelf : WINBOOL;
                         VAR TokenHandle : THandle ) : WINBOOL; WINAPI ( 'OpenThreadToken' );


FUNCTION GetTokenInformation ( TokenHandle : THandle;
                             TokenInformationClass : TOKEN_INFORMATION_CLASS;
                             TokenInformation : POINTER;
                             TokenInformationLength : DWord;
                             VAR ReturnLength : DWord ) : WINBOOL; WINAPI ( 'GetTokenInformation' );


FUNCTION SetTokenInformation ( TokenHandle : THandle;
                             TokenInformationClass : TOKEN_INFORMATION_CLASS;
                             TokenInformation : POINTER;
                             TokenInformationLength : DWord ) : WINBOOL; WINAPI ( 'SetTokenInformation' );


FUNCTION AdjustTokenPrivileges ( TokenHandle : THandle;
                               DisableAllPrivileges : WINBOOL;
                               VAR NewState : TTOKEN_PRIVILEGES;
                               BufferLength : DWord;
                               VAR PreviousState : TTOKEN_PRIVILEGES;
                               VAR ReturnLength : DWord ) : WINBOOL; WINAPI ( 'AdjustTokenPrivileges' );


FUNCTION AdjustTokenGroups ( TokenHandle : THandle;
                           ResetToDefault : WINBOOL;
                           VAR NewState : TTOKEN_GROUPS;
                           BufferLength : DWord;
                           VAR PreviousState : TTOKEN_GROUPS;
                           VAR ReturnLength : DWord ) : WINBOOL; WINAPI ( 'AdjustTokenGroups' );


FUNCTION PrivilegeCheck ( ClientToken : THandle;
                        VAR RequiredPrivileges : TPRIVILEGE_SET;
                        VAR pfResult : WinBool ) : WINBOOL; WINAPI ( 'PrivilegeCheck' );


FUNCTION IsValidSid ( VAR pSid : SID ) : WINBOOL; WINAPI ( 'IsValidSid' );


FUNCTION EqualSid ( VAR pSid1 : SID;
                  VAR pSid2 : SID ) : WINBOOL; WINAPI ( 'EqualSid' );


FUNCTION EqualPrefixSid ( VAR pSid1 : SID;
                        VAR pSid2 : SID ) : WINBOOL; WINAPI ( 'EqualPrefixSid' );


FUNCTION GetSidLengthRequired ( nSubAuthorityCount : Byte ) : DWord; WINAPI ( 'GetSidLengthRequired' );


                                   {
function AllocateAndInitializeSid(pIdentifierAuthority: PSID_IDENTIFIER_AUTHORITY;
                                  nSubAuthorityCount: BYTE;
                                  nSubAuthority0: DWord;
                                  nSubAuthority1: DWord;
                                  nSubAuthority2: DWord;
                                  nSubAuthority3: DWord;
                                  nSubAuthority4: DWord;
                                  n: DWord;
                                  D: D): WINBOOL; WINAPI('AllocateAndInitializeSid');
                                  }

FUNCTION FreeSid ( VAR pSid : SID ) : Pointer; WINAPI ( 'FreeSid' );


FUNCTION InitializeSid ( VAR pSid : SID;
                       VAR pIdentifierAuthority : TSID_IDENTIFIER_AUTHORITY;
                       nSubAuthorityCount : BYTE ) : WINBOOL; WINAPI ( 'InitializeSid' );


FUNCTION GetSidIdentifierAuthority ( VAR pSid : SID ) : PSID_IDENTIFIER_AUTHORITY; WINAPI ( 'GetSidIdentifierAuthority' );


FUNCTION GetSidSubAuthority ( VAR pSid : SID;
                            nSubAuthority : DWord ) : PDWord; WINAPI ( 'GetSidSubAuthority' );


FUNCTION GetSidSubAuthorityCount ( VAR pSid : SID ) : PUCHAR; WINAPI ( 'GetSidSubAuthorityCount' );


FUNCTION GetLengthSid ( VAR pSid : SID ) : DWord; WINAPI ( 'GetLengthSid' );



FUNCTION CopySid ( nDestinationSidLength : DWord;
                 VAR pDestinationSid : SID;
                 CONST pSourceSid : SID ) : WINBOOL; WINAPI ( 'CopySid' );


FUNCTION AreAllAccessesGranted ( GrantedAccess : DWord;
                               DesiredAccess : DWord ) : WINBOOL; WINAPI ( 'AreAllAccessesGranted' );


FUNCTION AreAnyAccessesGranted ( GrantedAccess : DWord;
                               DesiredAccess : DWord ) : WINBOOL; WINAPI ( 'AreAnyAccessesGranted' );


PROCEDURE MapGenericMask ( VAR AccessMask : DWord;
                        VAR GenericMapping : TGENERIC_MAPPING ); WINAPI ( 'MapGenericMask' );


FUNCTION IsValidAcl ( VAR pAcl : ACL ) : WINBOOL; WINAPI ( 'IsValidAcl' );


FUNCTION InitializeAcl ( VAR pAcl : ACL;
                       nAclLength : DWord;
                       dwAclRevision : DWord ) : WINBOOL; WINAPI ( 'InitializeAcl' );


FUNCTION GetAclInformation ( VAR pAcl : ACL;
                           pAclInformation : POINTER;
                           nAclInformationLength : DWord;
                           dwAclInformationClass : ACL_INFORMATION_CLASS ) : WINBOOL; WINAPI ( 'GetAclInformation' );


FUNCTION SetAclInformation ( VAR pAcl : ACL;
                           pAclInformation : POINTER;
                           nAclInformationLength : DWord;
                           dwAclInformationClass : ACL_INFORMATION_CLASS ) : WINBOOL; WINAPI ( 'SetAclInformation' );


FUNCTION AddAce ( VAR pAcl : ACL;
                dwAceRevision : DWord;
                dwStartingAceIndex : DWord;
                pAceList : POINTER;
                nAceListLength : DWord ) : WINBOOL; WINAPI ( 'AddAce' );



FUNCTION DeleteAce ( VAR pAcl : ACL;
                   dwAceIndex : DWord ) : WINBOOL; WINAPI ( 'DeleteAce' );



FUNCTION GetAce ( VAR pAcl : ACL;
                dwAceIndex : DWord;
                VAR pAce ) : WINBOOL; WINAPI ( 'GetAce' );


FUNCTION AddAccessAllowedAce ( VAR pAcl : ACL;
                             dwAceRevision : DWord;
                             AccessMask : DWord;
                             VAR pSid : TSID ) : WINBOOL; WINAPI ( 'AddAccessAllowedAce' );


FUNCTION AddAccessDeniedAce ( VAR pAcl : ACL;
                            dwAceRevision : DWord;
                            AccessMask : DWord;
                            VAR pSid : TSID ) : WINBOOL; WINAPI ( 'AddAccessDeniedAce' );


FUNCTION AddAuditAccessAce ( VAR pAcl : ACL;
                           dwAceRevision : DWord;
                           dwAccessMask : DWord;
                           VAR pSid : TSID;
                           bAuditSuccess : WINBOOL;
                           bAuditFailure : WINBOOL ) : WINBOOL; WINAPI ( 'AddAuditAccessAce' );


FUNCTION FindFirstFreeAce ( VAR pAcl : ACL;
                          VAR pAce ) : WINBOOL; WINAPI ( 'FindFirstFreeAce' );


FUNCTION InitializeSecurityDescriptor ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                      dwRevision : DWord ) : WINBOOL; WINAPI ( 'InitializeSecurityDescriptor' );


FUNCTION IsValidSecurityDescriptor ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'IsValidSecurityDescriptor' );


FUNCTION GetSecurityDescriptorLength ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR ) : DWord; WINAPI ( 'GetSecurityDescriptorLength' );


FUNCTION GetSecurityDescriptorControl ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                      VAR pControl : TSECURITY_DESCRIPTOR_CONTROL;
                                      VAR lpdwRevision : DWord ) : WINBOOL; WINAPI ( 'GetSecurityDescriptorControl' );


FUNCTION SetSecurityDescriptorDacl ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                   bDaclPresent : WINBOOL;
                                   VAR pDacl : ACL;
                                   bDaclDefaulted : WINBOOL ) : WINBOOL; WINAPI ( 'SetSecurityDescriptorDacl' );


FUNCTION GetSecurityDescriptorDacl ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                   VAR lpbDaclPresent : WinBool;
                                   VAR pDacl : ACL;
                                   VAR lpbDaclDefaulted : WinBool ) : WINBOOL; WINAPI ( 'GetSecurityDescriptorDacl' );


FUNCTION SetSecurityDescriptorSacl ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                   bSaclPresent : WINBOOL;
                                   VAR pSacl : ACL;
                                   bSaclDefaulted : WINBOOL ) : WINBOOL; WINAPI ( 'SetSecurityDescriptorSacl' );


FUNCTION GetSecurityDescriptorSacl ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                   VAR lpbSaclPresent : WinBool;
                                   VAR pSacl : ACL;
                                   VAR lpbSaclDefaulted : WinBool ) : WINBOOL; WINAPI ( 'GetSecurityDescriptorSacl' );


FUNCTION SetSecurityDescriptorOwner ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                    VAR pOwner : SID;
                                    bOwnerDefaulted : WINBOOL ) : WINBOOL; WINAPI ( 'SetSecurityDescriptorOwner' );


FUNCTION GetSecurityDescriptorOwner ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                    VAR pOwner : SID;
                                    VAR lpbOwnerDefaulted : WinBool ) : WINBOOL; WINAPI ( 'GetSecurityDescriptorOwner' );


FUNCTION SetSecurityDescriptorGroup ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                    VAR pGroup : SID;
                                    bGroupDefaulted : WINBOOL ) : WINBOOL; WINAPI ( 'SetSecurityDescriptorGroup' );


FUNCTION GetSecurityDescriptorGroup ( VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                    VAR pGroup : SID;
                                    VAR lpbGroupDefaulted : WinBool ) : WINBOOL; WINAPI ( 'GetSecurityDescriptorGroup' );



FUNCTION CreatePrivateObjectSecurity ( VAR ParentDescriptor : TSECURITY_DESCRIPTOR;
                                     VAR CreatorDescriptor : TSECURITY_DESCRIPTOR;
                                     VAR NewDescriptor : TSECURITY_DESCRIPTOR;
                                     IsDirectoryObject : WINBOOL;
                                     Token : THandle;
                                     VAR GenericMapping : TGENERIC_MAPPING ) : WINBOOL; WINAPI ( 'CreatePrivateObjectSecurity' );



FUNCTION SetPrivateObjectSecurity ( SecurityInformation : SECURITY_INFORMATION;
                                  VAR ModificationDescriptor : TSECURITY_DESCRIPTOR;
                                  VAR ObjectsSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                  VAR GenericMapping : TGENERIC_MAPPING;
                                  Token : THandle ) : WINBOOL; WINAPI ( 'SetPrivateObjectSecurity' );


FUNCTION GetPrivateObjectSecurity ( VAR ObjectDescriptor : TSECURITY_DESCRIPTOR;
                                  SecurityInformation : SECURITY_INFORMATION;
                                  VAR ResultantDescriptor : TSECURITY_DESCRIPTOR;
                                  DescriptorLength : DWord;
                                  VAR ReturnLength : DWord ) : WINBOOL; WINAPI ( 'GetPrivateObjectSecurity' );


FUNCTION DestroyPrivateObjectSecurity ( VAR ObjectDescriptor : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'DestroyPrivateObjectSecurity' );


FUNCTION MakeSelfRelativeSD ( VAR pAbsoluteSecurityDescriptor : TSECURITY_DESCRIPTOR;
                            VAR pSelfRelativeSecurityDescriptor : TSECURITY_DESCRIPTOR;
                            VAR lpdwBufferLength : DWord ) : WINBOOL; WINAPI ( 'MakeSelfRelativeSD' );


FUNCTION MakeAbsoluteSD ( VAR pSelfRelativeSecurityDescriptor : TSecurity_Descriptor;
                        VAR pAbsoluteSecurityDescriptor : TSecurity_Descriptor;
                        VAR lpdwAbsoluteSecurityDescriptorSi : DWORD;
                        VAR pDacl : TACL;
                        VAR lpdwDaclSize : DWORD;
                        VAR pSacl : TACL;
                        VAR lpdwSaclSize : DWORD;
                        VAR pOwner : SID;
                        VAR lpdwOwnerSize : DWORD;
                        pPrimaryGroup : Pointer;
                        VAR lpdwPrimaryGroupSize : DWORD ) : WINBOOL;WINAPI ( 'MakeAbsoluteSD' );


FUNCTION SetKernelObjectSecurity ( _Handle : THandle;
                                 SecurityInformation : SECURITY_INFORMATION;
                                 VAR SecurityDescriptor : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'SetKernelObjectSecurity' );



FUNCTION FindNextChangeNotification ( hChangeHandle : THandle ) : WINBOOL; WINAPI ( 'FindNextChangeNotification' );



FUNCTION FindCloseChangeNotification ( hChangeHandle : THandle ) : WINBOOL; WINAPI ( 'FindCloseChangeNotification' );



FUNCTION VirtualLock ( lpAddress : POINTER;
                     dwSize : DWord ) : WINBOOL; WINAPI ( 'VirtualLock' );



FUNCTION VirtualUnlock ( lpAddress : POINTER;
                       dwSize : DWord ) : WINBOOL; WINAPI ( 'VirtualUnlock' );



FUNCTION MapViewOfFileEx ( hFileMappingObject : THandle;
                         dwDesiredAccess : DWord;
                         dwFileOffsetHigh : DWord;
                         dwFileOffsetLow : DWord;
                         dwNumberOfBytesToMap : DWord;
                         lpBaseAddress : POINTER ) : POINTER; WINAPI ( 'MapViewOfFileEx' );



FUNCTION SetPriorityClass ( hProcess : THandle;
                          dwPriorityClass : DWord ) : WINBOOL; WINAPI ( 'SetPriorityClass' );



FUNCTION GetPriorityClass ( hProcess : THandle ) : DWord; WINAPI ( 'GetPriorityClass' );



FUNCTION IsBadReadPtr ( lp : pointer;
                      ucb : Word ) : WINBOOL; WINAPI ( 'IsBadReadPtr' );


FUNCTION IsBadWritePtr ( lp : POINTER;
                       ucb : Word ) : WINBOOL; WINAPI ( 'IsBadWritePtr' );


FUNCTION IsBadHugeReadPtr ( lp : pointer;
                          ucb : Word ) : WINBOOL; WINAPI ( 'IsBadHugeReadPtr' );



FUNCTION IsBadHugeWritePtr ( lp : POINTER;
                           ucb : Word ) : WINBOOL; WINAPI ( 'IsBadHugeWritePtr' );



FUNCTION IsBadCodePtr ( lpfn : TFarProc ) : WINBOOL; WINAPI ( 'IsBadCodePtr' );


FUNCTION AllocateLocallyUniqueId ( Luid : PLUID ) : WINBOOL; WINAPI ( 'AllocateLocallyUniqueId' );


FUNCTION QueryPerformanceCounter ( VAR lpPerformanceCount : LARGE_INTEGER ) : WINBOOL; WINAPI ( 'QueryPerformanceCounter' );



FUNCTION QueryPerformanceFrequency ( VAR lpFrequency : LARGE_INTEGER ) : WINBOOL; WINAPI ( 'QueryPerformanceFrequency' );


PROCEDURE MoveMemory ( Destination : Pointer;
                    CONST Source;
                    Length : DWord ); WINAPI ( 'MoveMemory' );


PROCEDURE FillMemory ( Destination : Pointer;
                    Length : DWord;
                    Fill : BYTE ); WINAPI ( 'FillMemory' );


{$IFDEF WIN95}

FUNCTION ActivateKeyboardLayout ( kl : HKL;
                                Flags : Word ) : HKL; WINAPI ( 'ActivateKeyboardLayout' );
{$ELSE}

FUNCTION ActivateKeyboardLayout ( kl : HKL;
                                Flags : Word ) : WINBOOL; WINAPI ( 'ActivateKeyboardLayout' );
{$ENDIF /* WIN95 */}



FUNCTION ToUnicodeEx ( wVirtKey : Word;
                     wScanCode : Word;
                     lpKeyState : PBYTE;
                     pwszBuff : PWIDECHAR;
                     cchBuff : Integer;
                     wFlags : Word;
                     dwhkl : HKL ) : Integer; WINAPI ( 'ToUnicodeEx' );



FUNCTION UnloadKeyboardLayout ( hkl : HKL ) : WINBOOL; WINAPI ( 'UnloadKeyboardLayout' );



FUNCTION GetKeyboardLayoutList ( nBuff : Integer;
                               lpList : PHKL ) : Integer; WINAPI ( 'GetKeyboardLayoutList' );



FUNCTION GetKeyboardLayout ( dwLayout : DWord ) : HKL; WINAPI ( 'GetKeyboardLayout' );



FUNCTION OpenInputDesktop ( dwFlags : DWord;
                          fInherit : WINBOOL;
                          dwDesiredAccess : DWord ) : HDESK; WINAPI ( 'OpenInputDesktop' );


FUNCTION EnumDesktopWindows ( hDesktop : HDESK;
                            lpfn : ENUMWINDOWSPROC;
                            lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumDesktopWindows' );



FUNCTION SwitchDesktop ( hDesktop : HDESK ) : WINBOOL; WINAPI ( 'SwitchDesktop' );



FUNCTION SetThreadDesktop ( hDesktop : HDESK ) : WINBOOL; WINAPI ( 'SetThreadDesktop' );



FUNCTION CloseDesktop ( hDesktop : HDESK ) : WINBOOL; WINAPI ( 'CloseDesktop' );



FUNCTION GetThreadDesktop ( dwThreadId : DWord ) : HDESK; WINAPI ( 'GetThreadDesktop' );



FUNCTION CloseWindowStation ( WinSta : HWINSTA ) : WINBOOL; WINAPI ( 'CloseWindowStation' );



FUNCTION SetProcessWindowStation ( WinSta : HWINSTA ) : WINBOOL; WINAPI ( 'SetProcessWindowStation' );



FUNCTION GetProcessWindowStation : HWINSTA; WINAPI ( 'GetProcessWindowStation' );



FUNCTION SetUserObjectSecurity ( hObj : THandle;
                               VAR pSIRequested : TSECURITY_INFORMATION;
                               VAR pSID : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'SetUserObjectSecurity' );



FUNCTION GetUserObjectSecurity ( hObj : THandle;
                               VAR pSIRequested : TSECURITY_INFORMATION;
                               VAR pSID : TSECURITY_DESCRIPTOR;
                               nLength : DWord;
                               VAR lpnLengthNeeded : DWord ) : WINBOOL; WINAPI ( 'GetUserObjectSecurity' );



FUNCTION TranslateMessage ( CONST lpMsg : MSG ) : WINBOOL; WINAPI ( 'TranslateMessage' );


FUNCTION SetMessageQueue ( cMessagesMax : Integer ) : WINBOOL; WINAPI ( 'SetMessageQueue' );


FUNCTION RegisterHotKey ( Wnd : HWND;
                        anID : Integer;
                        fsModifiers : Word;
                        vk : Word ) : WINBOOL; WINAPI ( 'RegisterHotKey' );



FUNCTION UnregisterHotKey ( Wnd : HWND;
                          anID : Integer ) : WINBOOL; WINAPI ( 'UnregisterHotKey' );



FUNCTION ExitWindowsEx ( uFlags : Word;
                       dwReserved : DWord ) : WINBOOL; WINAPI ( 'ExitWindowsEx' );



FUNCTION SwapMouseButton ( fSwap : WINBOOL ) : WINBOOL; WINAPI ( 'SwapMouseButton' );



FUNCTION GetMessagePos : DWord; WINAPI ( 'GetMessagePos' );



FUNCTION GetMessageTime : LongInt; WINAPI ( 'GetMessageTime' );



FUNCTION GetMessageExtraInfo : LongInt; WINAPI ( 'GetMessageExtraInfo' );



FUNCTION SetMessageExtraInfo ( lParam : LPARAM32 ) : LPARAM32; WINAPI ( 'SetMessageExtraInfo' );



FUNCTION BroadcastSystemMessage ( _1 : DWord;
                               VAR _2 : DWord;
                               _3 : Word;
                               _4 : UINT;
                               _5 : LPARAM32 ) : LPARAM32; WINAPI ( 'BroadcastSystemMessage' );


FUNCTION AttachThreadInput ( idAttach : DWord;
                           idAttachTo : DWord;
                           fAttach : WINBOOL ) : WINBOOL; WINAPI ( 'AttachThreadInput' );



FUNCTION ReplyMessage ( xResult : LRESULT ) : WINBOOL; WINAPI ( 'ReplyMessage' );



FUNCTION WaitMessage : WINBOOL; WINAPI ( 'WaitMessage' );



FUNCTION WaitForInputIdle ( hProcess : THandle;
                          dwMilliseconds : DWord ) : DWord; WINAPI ( 'WaitForInputIdle' );


PROCEDURE PostQuitMessage ( nExitCode : Integer ); WINAPI ( 'PostQuitMessage' );


FUNCTION InSendMessage : WINBOOL; WINAPI ( 'InSendMessage' );


FUNCTION GetDoubleClickTime : Word; WINAPI ( 'GetDoubleClickTime' );



FUNCTION SetDoubleClickTime ( _1 : Word ) : WINBOOL; WINAPI ( 'SetDoubleClickTime' );



FUNCTION IsWindow ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsWindow' );



FUNCTION IsMenu ( Menu : HMENU ) : WINBOOL; WINAPI ( 'IsMenu' );



FUNCTION IsChild ( hWndParent : HWND;
                 Wnd : HWND ) : WINBOOL; WINAPI ( 'IsChild' );


FUNCTION DestroyWindow ( Wnd : HWND ) : WINBOOL; WINAPI ( 'DestroyWindow' );


FUNCTION ShowWindow ( Wnd : HWND;
                    nCmdShow : Integer ) : WINBOOL; WINAPI ( 'ShowWindow' );

FUNCTION ShowWindowAsync ( Wnd : HWND;
                         nCmdShow : Integer ) : WINBOOL; WINAPI ( 'ShowWindowAsync' );

FUNCTION FlashWindow ( Wnd : HWND;
                     bInvert : WINBOOL ) : WINBOOL; WINAPI ( 'FlashWindow' );



FUNCTION ShowOwnedPopups ( Wnd : HWND;
                         fShow : WINBOOL ) : WINBOOL; WINAPI ( 'ShowOwnedPopups' );



FUNCTION OpenIcon ( Wnd : HWND ) : WINBOOL; WINAPI ( 'OpenIcon' );



FUNCTION CloseWindow ( Wnd : HWND ) : WINBOOL; WINAPI ( 'CloseWindow' );



FUNCTION MoveWindow ( Wnd : HWND;
                    X : Integer;
                    Y : Integer;
                    nWidth : Integer;
                    nHeight : Integer;
                    bRepaint : WINBOOL ) : WINBOOL; WINAPI ( 'MoveWindow' );



FUNCTION SetWindowPos ( Wnd : HWND;
                      hWndInsertAfter : HWND;
                      X : Integer;
                      Y : Integer;
                      cx : Integer;
                      cy : Integer;
                      uFlags : Word ) : WINBOOL; WINAPI ( 'SetWindowPos' );


FUNCTION GetWindowPlacement ( Wnd : HWND;
                            VAR lpwndpl : TWINDOWPLACEMENT ) : WINBOOL; WINAPI ( 'GetWindowPlacement' );


FUNCTION SetWindowPlacement ( Wnd : HWND;
                            CONST lpwndpl : WINDOWPLACEMENT ) : WINBOOL; WINAPI ( 'SetWindowPlacement' );


FUNCTION BeginDeferWindowPos ( nNumWindows : Integer ) : HDWP; WINAPI ( 'BeginDeferWindowPos' );


FUNCTION DeferWindowPos ( hWinPosInfo : HDWP;
                        Wnd : HWND;
                        hWndInsertAfter : HWND;
                        x : Integer;
                        y : Integer;
                        cx : Integer;
                        cy : Integer;
                        uFlags : Word ) : HDWP; WINAPI ( 'DeferWindowPos' );


FUNCTION EndDeferWindowPos ( hWinPosInfo : HDWP ) : WINBOOL; WINAPI ( 'EndDeferWindowPos' );


FUNCTION IsWindowVisible ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsWindowVisible' );


FUNCTION IsIconic ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsIconic' );


FUNCTION AnyPopup : WINBOOL; WINAPI ( 'AnyPopup' );


FUNCTION BringWindowToTop ( Wnd : HWND ) : WINBOOL; WINAPI ( 'BringWindowToTop' );


FUNCTION IsZoomed ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsZoomed' );


FUNCTION EndDialog ( hDlg : HWND;
                   nResult : Integer ) : WINBOOL; WINAPI ( 'EndDialog' );


FUNCTION GetDlgItem ( hDlg : HWND;
                    nIDDlgItem : Integer ) : HWND; WINAPI ( 'GetDlgItem' );


FUNCTION SetDlgItemInt ( hDlg : HWND;
                       nIDDlgItem : Integer;
                       uValue : Word;
                       bSigned : WINBOOL ) : WINBOOL; WINAPI ( 'SetDlgItemInt' );


FUNCTION GetDlgItemInt ( hDlg : HWND;
                       nIDDlgItem : Integer;
                       VAR lpTranslated : WINBOOL;
                       bSigned : WINBOOL ) : Word; WINAPI ( 'GetDlgItemInt' );


FUNCTION CheckDlgButton ( hDlg : HWND;
                        nIDButton : Integer;
                        uCheck : Word ) : WINBOOL; WINAPI ( 'CheckDlgButton' );


FUNCTION CheckRadioButton ( hDlg : HWND;
                          nIDFirstButton : Integer;
                          nIDLastButton : Integer;
                          nIDCheckButton : Integer ) : WINBOOL; WINAPI ( 'CheckRadioButton' );


FUNCTION IsDlgButtonChecked ( hDlg : HWND;
                            nIDButton : Integer ) : Word; WINAPI ( 'IsDlgButtonChecked' );


FUNCTION GetNextDlgGroupItem ( hDlg : HWND;
                             hCtl : HWND;
                             bPrevious : WINBOOL ) : HWND; WINAPI ( 'GetNextDlgGroupItem' );


FUNCTION GetNextDlgTabItem ( hDlg : HWND;
                           hCtl : HWND;
                           bPrevious : WINBOOL ) : HWND; WINAPI ( 'GetNextDlgTabItem' );


FUNCTION GetDlgCtrlID ( Wnd : HWND ) : Integer; WINAPI ( 'GetDlgCtrlID' );


FUNCTION GetDialogBaseUnits : LongInt; WINAPI ( 'GetDialogBaseUnits' );


FUNCTION OpenClipboard ( hWndNewOwner : HWND ) : WINBOOL; WINAPI ( 'OpenClipboard' );


FUNCTION CloseClipboard : WINBOOL; WINAPI ( 'CloseClipboard' );


FUNCTION GetClipboardOwner : HWND; WINAPI ( 'GetClipboardOwner' );


FUNCTION SetClipboardViewer ( hWndNewViewer : HWND ) : HWND; WINAPI ( 'SetClipboardViewer' );


FUNCTION GetClipboardViewer : HWND; WINAPI ( 'GetClipboardViewer' );


FUNCTION ChangeClipboardChain ( hWndRemove : HWND;
                              hWndNewNext : HWND ) : WINBOOL; WINAPI ( 'ChangeClipboardChain' );


FUNCTION SetClipboardData ( uFormat : Word;
                          hMem : THandle ) : THandle; WINAPI ( 'SetClipboardData' );


FUNCTION GetClipboardData ( uFormat : Word ) : THandle; WINAPI ( 'GetClipboardData' );


FUNCTION CountClipboardFormats : Integer; WINAPI ( 'CountClipboardFormats' );


FUNCTION EnumClipboardFormats ( format : Word ) : Word; WINAPI ( 'EnumClipboardFormats' );


FUNCTION EmptyClipboard : WINBOOL; WINAPI ( 'EmptyClipboard' );


FUNCTION IsClipboardFormatAvailable ( format : Word ) : WINBOOL; WINAPI ( 'IsClipboardFormatAvailable' );


FUNCTION GetPriorityClipboardFormat ( VAR paFormatPriorityList : Word;
                                    cFormats : Integer ) : Integer; WINAPI ( 'GetPriorityClipboardFormat' );


FUNCTION GetOpenClipboardWindow : HWND; WINAPI ( 'GetOpenClipboardWindow' );


{+// Despite the A these are ASCII functions! */ }

FUNCTION CharNextExA ( CodePage : Word;
                     lpCurrentChar : PChar;
                     dwFlags : DWord ) : PChar; WINAPI ( 'CharNextExA' );
{ ShortCut }
FUNCTION CharNextEx ( CodePage : Word;
                     lpCurrentChar : PChar;
                     dwFlags : DWord ) : PChar; WINAPI ( 'CharNextExA' );



FUNCTION CharPrevExA ( CodePage : Word;
                     lpStart : PChar;
                     lpCurrentChar : PChar;
                     dwFlags : DWord ) : PChar; WINAPI ( 'CharPrevExA' );
{ ShortCut }
FUNCTION CharPrevEx ( CodePage : Word;
                     lpStart : PChar;
                     lpCurrentChar : PChar;
                     dwFlags : DWord ) : PChar; WINAPI ( 'CharPrevExA' );


FUNCTION SetFocus ( Wnd : HWND ) : HWND; WINAPI ( 'SetFocus' );


FUNCTION GetActiveWindow : HWND; WINAPI ( 'GetActiveWindow' );


FUNCTION GetFocus : HWND; WINAPI ( 'GetFocus' );



FUNCTION GetKBCodePage : Word; WINAPI ( 'GetKBCodePage' );


FUNCTION GetKeyState ( nVirtKey : Integer ) : SmallInt; WINAPI ( 'GetKeyState' );


FUNCTION GetAsyncKeyState ( vKey : Integer ) : SmallInt; WINAPI ( 'GetAsyncKeyState' );


FUNCTION GetKeyboardState ( VAR lpKeyState ) : WINBOOL; WINAPI ( 'GetKeyboardState' );


FUNCTION SetKeyboardState ( VAR lpKeyState ) : WINBOOL; WINAPI ( 'SetKeyboardState' );


FUNCTION GetKeyboardType ( nTypeFlag : Integer ) : Integer; WINAPI ( 'GetKeyboardType' );


FUNCTION ToAscii ( uVirtKey : Word;
                 uScanCode : Word;
                 VAR lpKeyState;
                 VAR lpChar : Word;
                 uFlags : Word ) : Integer; WINAPI ( 'ToAscii' );


FUNCTION ToAsciiEx ( uVirtKey : Word;
                   uScanCode : Word;
                   VAR lpKeyState;
                   VAR lpChar : Word;
                   uFlags : Word;
                   dwhkl : HKL ) : Integer; WINAPI ( 'ToAsciiEx' );


FUNCTION ToUnicode ( wVirtKey : Word;
                   wScanCode : Word;
                   VAR lpKeyState;
                   pwszBuff : PWIDECHAR;
                   cchBuff : Integer;
                   wFlags : Word ) : Integer; WINAPI ( 'ToUnicode' );


FUNCTION OemKeyScan ( wOemChar : Word ) : DWord; WINAPI ( 'OemKeyScan' );


PROCEDURE keybd_event ( bVk : BYTE;
                     bScan : BYTE;
                     dwFlags : DWord;
                     dwExtraInfo : DWord ); WINAPI ( 'keybd_event' );


PROCEDURE mouse_event ( dwFlags : DWord;
                     dx : DWord;
                     dy : DWord;
                     cButtons : DWord;
                     dwExtraInfo : DWord ); WINAPI ( 'mouse_event' );

FUNCTION GetInputState : WINBOOL; WINAPI ( 'GetInputState' );


FUNCTION GetQueueStatus ( flags : Word ) : DWord; WINAPI ( 'GetQueueStatus' );


FUNCTION GetCapture : HWND; WINAPI ( 'GetCapture' );


FUNCTION SetCapture ( Wnd : HWND ) : HWND; WINAPI ( 'SetCapture' );


FUNCTION ReleaseCapture : WINBOOL; WINAPI ( 'ReleaseCapture' );


FUNCTION MsgWaitForMultipleObjects ( nCount : DWord;
                                   pHandles : PHANDLE;
                                   fWaitAll : WINBOOL;
                                   dwMilliseconds : DWord;
                                   dwWakeMask : DWord ) : DWord; WINAPI ( 'MsgWaitForMultipleObjects' );


FUNCTION SetTimer ( Wnd : HWND;
                  nIDEvent : Word;
                  uElapse : Word;
                  lpTimerFunc : TIMERPROC ) : Word; WINAPI ( 'SetTimer' );


FUNCTION KillTimer ( Wnd : HWND;
                   uIDEvent : Word ) : WINBOOL; WINAPI ( 'KillTimer' );


FUNCTION IsWindowUnicode ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsWindowUnicode' );


FUNCTION EnableWindow ( Wnd : HWND;
                      bEnable : WINBOOL ) : WINBOOL; WINAPI ( 'EnableWindow' );


FUNCTION IsWindowEnabled ( Wnd : HWND ) : WINBOOL; WINAPI ( 'IsWindowEnabled' );


FUNCTION DestroyAcceleratorTable ( hAccel : HACCEL ) : WINBOOL; WINAPI ( 'DestroyAcceleratorTable' );


FUNCTION GetSystemMetrics ( nIndex : Integer ) : Integer; WINAPI ( 'GetSystemMetrics' );


FUNCTION GetMenu ( Wnd : HWND ) : HMENU; WINAPI ( 'GetMenu' );


FUNCTION SetMenu ( Wnd : HWND;
                 Menu : HMENU ) : WINBOOL; WINAPI ( 'SetMenu' );


FUNCTION HiliteMenuItem ( Wnd : HWND;
                        Menu : HMENU;
                        uIDHiliteItem : Word;
                        uHilite : Word ) : WINBOOL; WINAPI ( 'HiliteMenuItem' );

FUNCTION GetMenuState ( Menu : HMENU;
                      uId : Word;
                      uFlags : Word ) : Word; WINAPI ( 'GetMenuState' );

FUNCTION DrawMenuBar ( Wnd : HWND ) : WINBOOL; WINAPI ( 'DrawMenuBar' );

FUNCTION GetSystemMenu ( Wnd : HWND;
                       bRevert : WINBOOL ) : HMENU; WINAPI ( 'GetSystemMenu' );

FUNCTION CreateMenu : HMENU; WINAPI ( 'CreateMenu' );


FUNCTION CreatePopupMenu : HMENU; WINAPI ( 'CreatePopupMenu' );

FUNCTION DestroyMenu ( Menu : HMENU ) : WINBOOL; WINAPI ( 'DestroyMenu' );

FUNCTION CheckMenuItem ( Menu : HMENU;
                       uIDCheckItem : Word;
                       uCheck : Word ) : DWord; WINAPI ( 'CheckMenuItem' );


FUNCTION EnableMenuItem ( Menu : HMENU;
                        uIDEnableItem : Word;
                        uEnable : Word ) : WINBOOL; WINAPI ( 'EnableMenuItem' );


FUNCTION GetSubMenu ( Menu : HMENU;
                    nPos : Integer ) : HMENU; WINAPI ( 'GetSubMenu' );


FUNCTION GetMenuItemID ( Menu : HMENU;
                       nPos : Integer ) : Word; WINAPI ( 'GetMenuItemID' );


FUNCTION GetMenuItemCount ( Menu : HMENU ) : Integer; WINAPI ( 'GetMenuItemCount' );


FUNCTION RemoveMenu ( Menu : HMENU;
                    uPosition : Word;
                    uFlags : Word ) : WINBOOL; WINAPI ( 'RemoveMenu' );


FUNCTION DeleteMenu ( Menu : HMENU;
                    uPosition : Word;
                    uFlags : Word ) : WINBOOL; WINAPI ( 'DeleteMenu' );


FUNCTION SetMenuItemBitmaps ( Menu : HMENU;
                            uPosition : Word;
                            uFlags : Word;
                            hBitmapUnchecked : HBITMAP;
                            hBitmapChecked : HBITMAP ) : WINBOOL; WINAPI ( 'SetMenuItemBitmaps' );


FUNCTION GetMenuCheckMarkDimensions : LongInt; WINAPI ( 'GetMenuCheckMarkDimensions' );


FUNCTION TrackPopupMenu ( Menu : HMENU;
                        uFlags : Word;
                        x : Integer;
                        y : Integer;
                        nReserved : Integer;
                        Wnd : HWND;
                        CONST prcRect : RECT ) : WINBOOL; WINAPI ( 'TrackPopupMenu' );


FUNCTION GetMenuDefaultItem ( Menu : HMENU;
                            fByPos : Word;
                            gmdiFlags : Word ) : Word; WINAPI ( 'GetMenuDefaultItem' );


FUNCTION SetMenuDefaultItem ( Menu : HMENU;
                            uItem : Word;
                            fByPos : Word ) : WINBOOL; WINAPI ( 'SetMenuDefaultItem' );


FUNCTION GetMenuItemRect ( Wnd : HWND;
                         Menu : HMENU;
                         uItem : Word;
                         VAR lprcItem : RECT ) : WINBOOL; WINAPI ( 'GetMenuItemRect' );


FUNCTION MenuItemFromPoint ( Wnd : HWND;
                           Menu : HMENU;
                           ptScreen : POINT ) : Integer; WINAPI ( 'MenuItemFromPoint' );


FUNCTION DragObject ( _1 : HWND;
                    _2 : HWND;
                    _3 : Word;
                    _4 : DWord;
                    _5 : HCURSOR ) : DWord; WINAPI ( 'DragObject' );


FUNCTION DragDetect ( wnd : HWND;
                    pt : POINT ) : WINBOOL; WINAPI ( 'DragDetect' );


FUNCTION DrawIcon ( DC : HDC;
                  X : Integer;
                  Y : Integer;
                  Icon : HICON ) : WINBOOL; WINAPI ( 'DrawIcon' );

FUNCTION UpdateWindow ( Wnd : HWND ) : WINBOOL; WINAPI ( 'UpdateWindow' );


FUNCTION SetActiveWindow ( Wnd : HWND ) : HWND; WINAPI ( 'SetActiveWindow' );


FUNCTION GetForegroundWindow : HWND; WINAPI ( 'GetForegroundWindow' );


FUNCTION PaintDesktop ( dc : HDC ) : WINBOOL; WINAPI ( 'PaintDesktop' );


FUNCTION SetForegroundWindow ( Wnd : HWND ) : WINBOOL; WINAPI ( 'SetForegroundWindow' );


FUNCTION WindowFromDC ( DC : HDC ) : HWND; WINAPI ( 'WindowFromDC' );


FUNCTION GetDC ( Wnd : HWND ) : HDC; WINAPI ( 'GetDC' );


FUNCTION GetDCEx ( Wnd : HWND;
                 hrgnClip : HRGN;
                 flags : DWord ) : HDC; WINAPI ( 'GetDCEx' );


FUNCTION GetWindowDC ( Wnd : HWND ) : HDC; WINAPI ( 'GetWindowDC' );


FUNCTION ReleaseDC ( Wnd : HWND;
                   DC : HDC ) : Integer; WINAPI ( 'ReleaseDC' );


FUNCTION BeginPaint ( Wnd : HWND;
                    VAR lpPaint : TPAINTSTRUCT ) : HDC; WINAPI ( 'BeginPaint' );


FUNCTION EndPaint ( Wnd : HWND;
                  CONST lpPaint : PAINTSTRUCT ) : WINBOOL; WINAPI ( 'EndPaint' );


FUNCTION GetUpdateRect ( Wnd : HWND;
                       VAR lpRect : RECT;
                       bErase : WINBOOL ) : WINBOOL; WINAPI ( 'GetUpdateRect' );


FUNCTION GetUpdateRgn ( Wnd : HWND;
                      Rgn : HRGN;
                      bErase : WINBOOL ) : Integer; WINAPI ( 'GetUpdateRgn' );


FUNCTION SetWindowRgn ( Wnd : HWND;
                      Rgn : HRGN;
                      bRedraw : WINBOOL ) : Integer; WINAPI ( 'SetWindowRgn' );


FUNCTION GetWindowRgn ( Wnd : HWND;
                      Rgn : HRGN ) : Integer; WINAPI ( 'GetWindowRgn' );


FUNCTION ExcludeUpdateRgn ( DC : HDC;
                          Wnd : HWND ) : Integer; WINAPI ( 'ExcludeUpdateRgn' );


FUNCTION InvalidateRect ( Wnd : HWND;
                        lpRect : pRECT;
                        bErase : WINBOOL ) : WINBOOL; WINAPI ( 'InvalidateRect' );


FUNCTION ValidateRect ( Wnd : HWND;
                      lpRect : pRECT ) : WINBOOL; WINAPI ( 'ValidateRect' );


FUNCTION InvalidateRgn ( Wnd : HWND;
                       Rgn : HRGN;
                       bErase : WINBOOL ) : WINBOOL; WINAPI ( 'InvalidateRgn' );


FUNCTION ValidateRgn ( Wnd : HWND;
                     Rgn : HRGN ) : WINBOOL; WINAPI ( 'ValidateRgn' );


FUNCTION RedrawWindow ( Wnd : HWND;
                      CONST lprcUpdate : RECT;
                      hrgnUpdate : HRGN;
                      flags : Word ) : WINBOOL; WINAPI ( 'RedrawWindow' );


FUNCTION LockWindowUpdate ( hWndLock : HWND ) : WINBOOL; WINAPI ( 'LockWindowUpdate' );


FUNCTION ScrollWindow ( Wnd : HWND;
                      XAmount : Integer;
                      YAmount : Integer;
                      CONST lpRect : RECT;
                      CONST lpClipRect : RECT ) : WINBOOL; WINAPI ( 'ScrollWindow' );


FUNCTION ScrollDC ( hDC : HDC;
                  dx : Integer;
                  dy : Integer;
                  CONST lprcScroll : RECT;
                  CONST lprcClip : RECT;
                  hrgnUpdate : HRGN;
                  VAR lprcUpdate : RECT ) : WINBOOL; WINAPI ( 'ScrollDC' );


FUNCTION ScrollWindowEx ( Wnd : HWND;
                        dx : Integer;
                        dy : Integer;
                        CONST prcScroll : RECT;
                        CONST prcClip : RECT;
                        hrgnUpdate : HRGN;
                        VAR prcUpdate : RECT;
                        flags : Word ) : Integer; WINAPI ( 'ScrollWindowEx' );


FUNCTION SetScrollPos ( Wnd : HWND;
                      nBar : Integer;
                      nPos : Integer;
                      bRedraw : WINBOOL ) : Integer; WINAPI ( 'SetScrollPos' );


FUNCTION GetScrollPos ( Wnd : HWND;
                      nBar : Integer ) : Integer; WINAPI ( 'GetScrollPos' );


FUNCTION SetScrollRange ( Wnd : HWND;
                        nBar : Integer;
                        nMinPos : Integer;
                        nMaxPos : Integer;
                        bRedraw : WINBOOL ) : WINBOOL; WINAPI ( 'SetScrollRange' );


FUNCTION GetScrollRange ( Wnd : HWND;
                        nBar : Integer;
                        VAR lpMinPos,
                        lpMaxPos : Integer ) : WINBOOL; WINAPI ( 'GetScrollRange' );


FUNCTION ShowScrollBar ( Wnd : HWND;
                       wBar : Integer;
                       bShow : WINBOOL ) : WINBOOL; WINAPI ( 'ShowScrollBar' );


FUNCTION EnableScrollBar ( Wnd : HWND;
                         wSBflags : Word;
                         wArrows : Word ) : WINBOOL; WINAPI ( 'EnableScrollBar' );


FUNCTION GetClientRect ( Wnd : HWND;
                       VAR lpRect : RECT ) : WINBOOL; WINAPI ( 'GetClientRect' );


FUNCTION GetWindowRect ( Wnd : HWND;
                       VAR lpRect : RECT ) : WINBOOL; WINAPI ( 'GetWindowRect' );


FUNCTION AdjustWindowRect ( VAR lpRect : RECT;
                          dwStyle : DWord;
                          bMenu : WINBOOL ) : WINBOOL; WINAPI ( 'AdjustWindowRect' );


FUNCTION AdjustWindowRectEx ( VAR lpRect : RECT;
                            dwStyle : DWord;
                            bMenu : WINBOOL;
                            dwExStyle : DWord ) : WINBOOL; WINAPI ( 'AdjustWindowRectEx' );


FUNCTION SetWindowContextHelpId ( _1 : HWND;
                                _2 : DWord ) : WINBOOL; WINAPI ( 'SetWindowContextHelpId' );


FUNCTION GetWindowContextHelpId ( _1 : HWND ) : DWord; WINAPI ( 'GetWindowContextHelpId' );


FUNCTION SetMenuContextHelpId ( _1 : HMENU;
                              _2 : DWord ) : WINBOOL; WINAPI ( 'SetMenuContextHelpId' );


FUNCTION GetMenuContextHelpId ( _1 : HMENU ) : DWord; WINAPI ( 'GetMenuContextHelpId' );


FUNCTION MessageBeep ( uType : Word ) : WINBOOL; WINAPI ( 'MessageBeep' );


FUNCTION ShowCursor ( bShow : WINBOOL ) : Integer; WINAPI ( 'ShowCursor' );


FUNCTION SetCursorPos ( X : Integer;
                      Y : Integer ) : WINBOOL; WINAPI ( 'SetCursorPos' );


FUNCTION SetCursor ( hCursor : HCURSOR ) : HCURSOR; WINAPI ( 'SetCursor' );


FUNCTION GetCursorPos ( VAR lpPoint : POINT ) : WINBOOL; WINAPI ( 'GetCursorPos' );


FUNCTION ClipCursor ( CONST lpRect : RECT ) : WINBOOL; WINAPI ( 'ClipCursor' );


FUNCTION GetClipCursor ( VAR lpRect : RECT ) : WINBOOL; WINAPI ( 'GetClipCursor' );


FUNCTION GetCursor : HCURSOR; WINAPI ( 'GetCursor' );


FUNCTION CreateCaret ( Wnd : HWND;
                     hBitmap : HBITMAP;
                     nWidth : Integer;
                     nHeight : Integer ) : WINBOOL; WINAPI ( 'CreateCaret' );


FUNCTION GetCaretBlinkTime : Word; WINAPI ( 'GetCaretBlinkTime' );


FUNCTION SetCaretBlinkTime ( uMSeconds : Word ) : WINBOOL; WINAPI ( 'SetCaretBlinkTime' );


FUNCTION DestroyCaret : WINBOOL; WINAPI ( 'DestroyCaret' );


FUNCTION HideCaret ( Wnd : HWND ) : WINBOOL; WINAPI ( 'HideCaret' );


FUNCTION ShowCaret ( Wnd : HWND ) : WINBOOL; WINAPI ( 'ShowCaret' );


FUNCTION SetCaretPos ( X : Integer;
                     Y : Integer ) : WINBOOL; WINAPI ( 'SetCaretPos' );


FUNCTION GetCaretPos ( VAR lpPoint : POINT ) : WINBOOL; WINAPI ( 'GetCaretPos' );


FUNCTION ClientToScreen ( Wnd : HWND;
                        VAR lpPoint : POINT ) : WINBOOL; WINAPI ( 'ClientToScreen' );


FUNCTION ScreenToClient ( Wnd : HWND;
                        VAR lpPoint : POINT ) : WINBOOL; WINAPI ( 'ScreenToClient' );


FUNCTION MapWindowPoints ( hWndFrom : HWND;
                         hWndTo : HWND;
                         VAR lpPoints : POINT;
                         cPoints : Word ) : Integer; WINAPI ( 'MapWindowPoints' );


FUNCTION WindowFromPoint ( Point : TPOINT ) : HWND; WINAPI ( 'WindowFromPoint' );



FUNCTION ChildWindowFromPoint ( hWndParent : HWND;
                              Point : TPOINT ) : HWND; WINAPI ( 'ChildWindowFromPoint' );



FUNCTION GetSysColor ( nIndex : Integer ) : DWord; WINAPI ( 'GetSysColor' );



FUNCTION GetSysColorBrush ( nIndex : Integer ) : HBRUSH; WINAPI ( 'GetSysColorBrush' );



FUNCTION SetSysColors ( cElements : Integer;
                      CONST lpaElements : INTEGER;
                      lpaRgbValues :  TColorRef ) : WINBOOL; WINAPI ( 'SetSysColors' );



FUNCTION DrawFocusRect ( DC : HDC;
                       CONST lprc : RECT ) : WINBOOL; WINAPI ( 'DrawFocusRect' );



FUNCTION FillRect ( DC : HDC;
                  CONST lprc : RECT;
                  hbr : HBRUSH ) : Integer; WINAPI ( 'FillRect' );



FUNCTION FrameRect ( DC : HDC;
                   CONST lprc : RECT;
                   hbr : HBRUSH ) : Integer; WINAPI ( 'FrameRect' );



FUNCTION InvertRect ( DC : HDC;
                    CONST lprc : RECT ) : WINBOOL; WINAPI ( 'InvertRect' );



FUNCTION SetRect ( VAR lprc : RECT;
                 xLeft : Integer;
                 yTop : Integer;
                 xRight : Integer;
                 yBottom : Integer ) : WINBOOL; WINAPI ( 'SetRect' );


FUNCTION SetRectEmpty ( VAR lprc : RECT ) : WINBOOL; WINAPI ( 'SetRectEmpty' );


FUNCTION CopyRect ( VAR lprcDst : RECT;
                  CONST lprcSrc : RECT ) : WINBOOL; WINAPI ( 'CopyRect' );


FUNCTION InflateRect ( VAR lprc : RECT;
                     dx : Integer;
                     dy : Integer ) : WINBOOL; WINAPI ( 'InflateRect' );


FUNCTION IntersectRect ( VAR lprcDst : RECT;
                       CONST lprcSrc1 : RECT;
                       CONST lprcSrc2 : RECT ) : WINBOOL; WINAPI ( 'IntersectRect' );


FUNCTION UnionRect ( VAR lprcDst : RECT;
                   CONST lprcSrc1 :  RECT;
                   CONST lprcSrc2 :  RECT ) : WINBOOL; WINAPI ( 'UnionRect' );


FUNCTION SubtractRect ( VAR lprcDst : RECT;
                      CONST lprcSrc1 :  RECT;
                      CONST lprcSrc2 :  RECT ) : WINBOOL; WINAPI ( 'SubtractRect' );


FUNCTION OffsetRect ( VAR lprc : RECT;
                    dx : Integer;
                    dy : Integer ) : WINBOOL; WINAPI ( 'OffsetRect' );


FUNCTION IsRectEmpty ( CONST lprc :  RECT ) : WINBOOL; WINAPI ( 'IsRectEmpty' );


FUNCTION EqualRect ( CONST lprc1 :  RECT;
                   CONST lprc2 :  RECT ) : WINBOOL; WINAPI ( 'EqualRect' );


FUNCTION PtInRect ( CONST lprc :  RECT;
                  pt : POINT ) : WINBOOL; WINAPI ( 'PtInRect' );


FUNCTION GetWindowWord ( Wnd : HWND;
                       nIndex : Integer ) : Word; WINAPI ( 'GetWindowWord' );


FUNCTION SetWindowWord ( Wnd : HWND;
                       nIndex : Integer;
                       wNewWord : Word ) : Word; WINAPI ( 'SetWindowWord' );


FUNCTION GetClassWord ( Wnd : HWND;
                      nIndex : Integer ) : Word; WINAPI ( 'GetClassWord' );


FUNCTION SetClassWord ( Wnd : HWND;
                      nIndex : Integer;
                      wNewWord : Word ) : Word; WINAPI ( 'SetClassWord' );


FUNCTION GetDesktopWindow : HWND; WINAPI ( 'GetDesktopWindow' );


FUNCTION GetParent ( Wnd : HWND ) : HWND; WINAPI ( 'GetParent' );


FUNCTION SetParent ( hWndChild : HWND;
                   hWndNewParent : HWND ) : HWND; WINAPI ( 'SetParent' );


FUNCTION EnumChildWindows ( hWndParent : HWND;
                          lpEnumFunc : ENUMWINDOWSPROC;
                          lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumChildWindows' );


FUNCTION EnumWindows ( lpEnumFunc : ENUMWINDOWSPROC;
                     lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumWindows' );


FUNCTION EnumThreadWindows ( dwThreadId : DWord;
                           lpfn : ENUMWINDOWSPROC;
                           lParam : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumThreadWindows' );


FUNCTION GetTopWindow ( Wnd : HWND ) : HWND; WINAPI ( 'GetTopWindow' );


FUNCTION GetWindowThreadProcessId ( Wnd : HWND;
                                  VAR lpdwProcessId : DWord ) : DWord; WINAPI ( 'GetWindowThreadProcessId' );


FUNCTION GetLastActivePopup ( Wnd : HWND ) : HWND; WINAPI ( 'GetLastActivePopup' );


FUNCTION GetWindow ( Wnd : HWND;
                   uCmd : Word ) : HWND; WINAPI ( 'GetWindow' );


FUNCTION UnhookWindowsHook ( nCode : Integer;
                           pfnFilterProc : THookProc ) : WINBOOL; WINAPI ( 'UnhookWindowsHook' );


FUNCTION UnhookWindowsHookEx ( hhk : HHOOK ) : WINBOOL; WINAPI ( 'UnhookWindowsHookEx' );


FUNCTION CallNextHookEx ( hhk : HHOOK;
                        nCode : Integer;
                        xwParam : UINT;
                        xlParam : LPARAM32 ) : LRESULT; WINAPI ( 'CallNextHookEx' );


FUNCTION CheckMenuRadioItem ( _1 : HMENU;
                            _2 : Word;
                            _3 : Word;
                            _4 : Word;
                            _5 : Word ) : WINBOOL; WINAPI ( 'CheckMenuRadioItem' );


FUNCTION CreateCursor ( hInst : THANDLE;
                      xHotSpot : Integer;
                      yHotSpot : Integer;
                      nWidth : Integer;
                      nHeight : Integer;
                      CONST pvANDPlane;
                      CONST pvXORPlane ) : HCURSOR; WINAPI ( 'CreateCursor' );


FUNCTION DestroyCursor ( hCur : HCURSOR ) : WINBOOL; WINAPI ( 'DestroyCursor' );


FUNCTION SetSystemCursor ( hcur : HCURSOR;
                         anID : DWord ) : WINBOOL; WINAPI ( 'SetSystemCursor' );


FUNCTION CreateIcon ( xInstance : THANDLE;
                    nWidth : Integer;
                    nHeight : Integer;
                    cPlanes : BYTE;
                    cBitsPixel : BYTE;
                    CONST lpbANDbits :  BYTE;
                    CONST lpbXORbits :  BYTE ) : HICON; WINAPI ( 'CreateIcon' );


FUNCTION DestroyIcon ( hIcon : HICON ) : WINBOOL; WINAPI ( 'DestroyIcon' );


FUNCTION LookupIconIdFromDirectory ( VAR presbits;
                                   fIcon : WINBOOL ) : Integer; WINAPI ( 'LookupIconIdFromDirectory' );


FUNCTION LookupIconIdFromDirectoryEx ( VAR presbits;
                                     fIcon : WINBOOL;
                                     cxDesired : Integer;
                                     cyDesired : Integer;
                                     Flags : Word ) : Integer; WINAPI ( 'LookupIconIdFromDirectoryEx' );


FUNCTION CreateIconFromResource ( VAR presbits;
                                dwResSize : DWord;
                                fIcon : WINBOOL;
                                dwVer : DWord ) : HICON; WINAPI ( 'CreateIconFromResource' );


FUNCTION CreateIconFromResourceEx ( VAR presbits;
                                  dwResSize : DWord;
                                  fIcon : WINBOOL;
                                  dwVer : DWord;
                                  cxDesired : Integer;
                                  cyDesired : Integer;
                                  Flags : Word ) : HICON; WINAPI ( 'CreateIconFromResourceEx' );


FUNCTION CopyImage ( _1 : THandle;
                   _2 : Word;
                   _3 : Integer;
                   _4 : Integer;
                   _5 : Word ) : HICON; WINAPI ( 'CopyImage' );


FUNCTION CreateIconIndirect ( VAR piconinfo : TICONINFO ) : HICON; WINAPI ( 'CreateIconIndirect' );


FUNCTION CopyIcon ( hIcon : HICON ) : HICON; WINAPI ( 'CopyIcon' );


FUNCTION GetIconInfo ( hIcon : HICON;
                     VAR piconinfo : TICONINFO ) : WINBOOL; WINAPI ( 'GetIconInfo' );


FUNCTION MapDialogRect ( hDlg : HWND;
                       VAR lpRect : RECT ) : WINBOOL; WINAPI ( 'MapDialogRect' );


FUNCTION SetScrollInfo ( _1 : HWND;
                       _2 : Integer;
                       CONST _3 : TSCROLLINFO;
                       _4 : WINBOOL ) : Integer; WINAPI ( 'SetScrollInfo' );


FUNCTION GetScrollInfo ( _1 : HWND;
                       _2 : Integer;
                       VAR _3 : TSCROLLINFO ) : WINBOOL; WINAPI ( 'GetScrollInfo' );


FUNCTION TranslateMDISysAccel ( hWndClient : HWND;
                              lpMsg : TMSG ) : WINBOOL; WINAPI ( 'TranslateMDISysAccel' );


FUNCTION ArrangeIconicWindows ( Wnd : HWND ) : Word; WINAPI ( 'ArrangeIconicWindows' );


FUNCTION TileWindows ( hwndParent : HWND;
                     wHow : Word;
                     CONST lpRect :  RECT;
                     cKids : Word;
                     CONST lpKids : HWND ) : Word; WINAPI ( 'TileWindows' );


FUNCTION CascadeWindows ( hwndParent : HWND;
                        wHow : Word;
                        CONST lpRect :  RECT;
                        cKids : Word;
                        CONST lpKids : PHWND ) : Word; WINAPI ( 'CascadeWindows' );



PROCEDURE SetLastErrorEx ( dwErrCode : DWord;
                        dwType : DWord ); WINAPI ( 'SetLastErrorEx' );



PROCEDURE SetDebugErrorLevel ( dwLevel : DWord ); WINAPI ( 'SetDebugErrorLevel' );


FUNCTION DrawEdge ( hdc : HDC;
                  VAR qrc : RECT;
                  edge : Word;
                  grfFlags : Word ) : WINBOOL; WINAPI ( 'DrawEdge' );


FUNCTION DrawFrameControl ( _1 : HDC;
                          VAR _2 : RECT;
                          _3 : Word;
                          _4 : Word ) : WINBOOL; WINAPI ( 'DrawFrameControl' );


FUNCTION DrawCaption ( _1 : HWND;
                     _2 : HDC;
                     CONST R : RECT;
                     _4 : Word ) : WINBOOL; WINAPI ( 'DrawCaption' );


FUNCTION DrawAnimatedRects ( wnd : HWND;
                           idAni : Integer;
                           CONST lprcFrom :  RECT;
                           CONST lprcTo :  RECT ) : WINBOOL; WINAPI ( 'DrawAnimatedRects' );


FUNCTION TrackPopupMenuEx ( _1 : HMENU;
                          _2 : Word;
                          _3 : Integer;
                          _4 : Integer;
                          _5 : HWND;
                          _6 : PTPMPARAMS ) : WINBOOL; WINAPI ( 'TrackPopupMenuEx' );


FUNCTION ChildWindowFromPointEx ( _1 : HWND;
                                _2 : POINT;
                                _3 : Word ) : HWND; WINAPI ( 'ChildWindowFromPointEx' );


FUNCTION DrawIconEx ( hdc : HDC;
                    xLeft : Integer;
                    yTop : Integer;
                    hIcon : HICON;
                    cxWidth : Integer;
                    cyWidth : Integer;
                    istepIfAniCur : Word;
                    hbrFlickerFreeDraw : HBRUSH;
                    diFlags : Word ) : WINBOOL; WINAPI ( 'DrawIconEx' );


FUNCTION AnimatePalette ( _1 : HPALETTE;
                        _2 : Word;
                        _3 : Word;
                        CONST P : PALETTEENTRY ) : WINBOOL; WINAPI ( 'AnimatePalette' );


FUNCTION Arc ( _1 : HDC;
             _2 : Integer;
             _3 : Integer;
             _4 : Integer;
             _5 : Integer;
             _6 : Integer;
             _7 : Integer;
             _8 : Integer;
             _9 : Integer ) : WINBOOL; WINAPI ( 'Arc' );


FUNCTION BitBlt ( _1 : HDC;
                _2 : Integer;
                _3 : Integer;
                _4 : Integer;
                _5 : Integer;
                _6 : HDC;
                _7 : Integer;
                _8 : Integer;
                _9 : DWord ) : WINBOOL; WINAPI ( 'BitBlt' );


FUNCTION CancelDC ( _1 : HDC ) : WINBOOL; WINAPI ( 'CancelDC' );


FUNCTION Chord ( _1 : HDC;
               _2 : Integer;
               _3 : Integer;
               _4 : Integer;
               _5 : Integer;
               _6 : Integer;
               _7 : Integer;
               _8 : Integer;
               _9 : Integer ) : WINBOOL; WINAPI ( 'Chord' );


FUNCTION CloseMetaFile ( _1 : HDC ) : HMETAFILE; WINAPI ( 'CloseMetaFile' );


FUNCTION CombineRgn ( _1 : HRGN;
                    _2 : HRGN;
                    _3 : HRGN;
                    _4 : Integer ) : Integer; WINAPI ( 'CombineRgn' );


FUNCTION CreateBitmap ( _1 : Integer;
                      _2 : Integer;
                      _3 : Word;
                      _4 : Word;
                      CONST  P ) : HBITMAP; WINAPI ( 'CreateBitmap' );


FUNCTION CreateBitmapIndirect ( CONST  B : BITMAP ) : HBITMAP; WINAPI ( 'CreateBitmapIndirect' );


FUNCTION CreateBrushIndirect ( CONST L : LOGBRUSH ) : HBRUSH; WINAPI ( 'CreateBrushIndirect' );


FUNCTION CreateCompatibleBitmap ( _1 : HDC;
                                _2 : Integer;
                                _3 : Integer ) : HBITMAP; WINAPI ( 'CreateCompatibleBitmap' );


FUNCTION CreateDiscardableBitmap ( _1 : HDC;
                                 _2 : Integer;
                                 _3 : Integer ) : HBITMAP; WINAPI ( 'CreateDiscardableBitmap' );


FUNCTION CreateCompatibleDC ( _1 : HDC ) : HDC; WINAPI ( 'CreateCompatibleDC' );


FUNCTION CreateDIBitmap ( _1 : HDC;
                        VAR B : BITMAPINFOHEADER;
                        _3 : Cardinal;
                        V : pChar;
                        VAR B2 : BITMAPINFO;
                        _6 : Cardinal ) : HBITMAP; WINAPI ( 'CreateDIBitmap' );


FUNCTION CreateDIBPatternBrush ( _1 : HGLOBAL;
                               _2 : Word ) : HBRUSH; WINAPI ( 'CreateDIBPatternBrush' );


FUNCTION CreateDIBPatternBrushPt ( CONST V;
                                 _2 : Word ) : HBRUSH; WINAPI ( 'CreateDIBPatternBrushPt' );


FUNCTION CreateEllipticRgn ( _1 : Integer;
                           _2 : Integer;
                           _3 : Integer;
                           _4 : Integer ) : HRGN; WINAPI ( 'CreateEllipticRgn' );


FUNCTION CreateEllipticRgnIndirect ( CONST R : RECT ) : HRGN; WINAPI ( 'CreateEllipticRgnIndirect' );


FUNCTION CreateHatchBrush ( _1 : Integer;
                          _2 : TColorRef ) : HBRUSH; WINAPI ( 'CreateHatchBrush' );


FUNCTION CreatePalette ( CONST L : LOGPALETTE ) : HPALETTE; WINAPI ( 'CreatePalette' );


FUNCTION CreatePen ( _1 : Integer;
                   _2 : Integer;
                   _3 : TColorRef ) : HPEN; WINAPI ( 'CreatePen' );


FUNCTION CreatePenIndirect ( CONST L : LOGPEN ) : HPEN; WINAPI ( 'CreatePenIndirect' );


FUNCTION CreatePolyPolygonRgn ( CONST P : POINT;
                              CONST I : INTEGER;
                              _3 : Integer;
                              _4 : Integer ) : HRGN; WINAPI ( 'CreatePolyPolygonRgn' );


FUNCTION CreatePatternBrush ( _1 : HBITMAP ) : HBRUSH; WINAPI ( 'CreatePatternBrush' );


FUNCTION CreateRectRgn ( _1 : Integer;
                       _2 : Integer;
                       _3 : Integer;
                       _4 : Integer ) : HRGN; WINAPI ( 'CreateRectRgn' );


FUNCTION CreateRectRgnIndirect ( CONST R : RECT ) : HRGN; WINAPI ( 'CreateRectRgnIndirect' );


FUNCTION CreateRoundRectRgn ( _1 : Integer;
                            _2 : Integer;
                            _3 : Integer;
                            _4 : Integer;
                            _5 : Integer;
                            _6 : Integer ) : HRGN; WINAPI ( 'CreateRoundRectRgn' );


FUNCTION CreateSolidBrush ( _1 : TColorRef ) : HBRUSH; WINAPI ( 'CreateSolidBrush' );


FUNCTION DeleteDC ( _1 : HDC ) : WINBOOL; WINAPI ( 'DeleteDC' );


FUNCTION DeleteMetaFile ( _1 : HMETAFILE ) : WINBOOL; WINAPI ( 'DeleteMetaFile' );


FUNCTION DeleteObject ( _1 : HGDIOBJ ) : WINBOOL; WINAPI ( 'DeleteObject' );


FUNCTION DrawEscape ( _1 : HDC;
                    _2 : Integer;
                    _3 : Integer;
                    _4 : PChar ) : Integer; WINAPI ( 'DrawEscape' );


FUNCTION Ellipse ( _1 : HDC;
                 _2 : Integer;
                 _3 : Integer;
                 _4 : Integer;
                 _5 : Integer ) : WINBOOL; WINAPI ( 'Ellipse' );


FUNCTION EnumObjects ( _1 : HDC;
                     _2 : Integer;
                     _3 : ENUMOBJECTSPROC;
                     _4 : LPARAM32 ) : Integer; WINAPI ( 'EnumObjects' );


FUNCTION EqualRgn ( _1 : HRGN;
                  _2 : HRGN ) : WINBOOL; WINAPI ( 'EqualRgn' );


FUNCTION Escape ( _1 : HDC;
                _2 : Integer;
                _3 : Integer;
                _4 : PChar;
                _5 : POINTER ) : Integer; WINAPI ( 'Escape' );


FUNCTION ExtEscape ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer;
                   _4 : PChar;
                   _5 : Integer;
                   _6 : PChar ) : Integer; WINAPI ( 'ExtEscape' );


FUNCTION ExcludeClipRect ( _1 : HDC;
                         _2 : Integer;
                         _3 : Integer;
                         _4 : Integer;
                         _5 : Integer ) : Integer; WINAPI ( 'ExcludeClipRect' );


FUNCTION ExtCreateRegion ( CONST X : XFORM;
                         _2 : DWord;
                          CONST R : RGNDATA ) : HRGN; WINAPI ( 'ExtCreateRegion' );


FUNCTION ExtFloodFill ( _1 : HDC;
                      _2 : Integer;
                      _3 : Integer;
                      _4 : TColorRef;
                      _5 : Word ) : WINBOOL; WINAPI ( 'ExtFloodFill' );


FUNCTION FillRgn ( _1 : HDC;
                 _2 : HRGN;
                 _3 : HBRUSH ) : WINBOOL; WINAPI ( 'FillRgn' );


FUNCTION FloodFill ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer;
                   _4 : TColorRef ) : WINBOOL; WINAPI ( 'FloodFill' );


FUNCTION FrameRgn ( _1 : HDC;
                  _2 : HRGN;
                  _3 : HBRUSH;
                  _4 : Integer;
                  _5 : Integer ) : WINBOOL; WINAPI ( 'FrameRgn' );


FUNCTION GetROP2 ( _1 : HDC ) : Integer; WINAPI ( 'GetROP2' );


FUNCTION GetAspectRatioFilterEx ( _1 : HDC;
                                VAR _2 : TSIZE ) : WINBOOL; WINAPI ( 'GetAspectRatioFilterEx' );


FUNCTION GetBkColor ( _1 : HDC ) : TColorRef; WINAPI ( 'GetBkColor' );


FUNCTION GetBkMode ( _1 : HDC ) : Integer; WINAPI ( 'GetBkMode' );


FUNCTION GetBitmapBits ( _1 : HBITMAP;
                       _2 : LongInt;
                       _3 : POINTER ) : LongInt; WINAPI ( 'GetBitmapBits' );


FUNCTION GetBitmapDimensionEx ( _1 : HBITMAP;
                              VAR _2 : TSIZE ) : WINBOOL; WINAPI ( 'GetBitmapDimensionEx' );


FUNCTION GetBoundsRect ( _1 : HDC;
                       VAR _2 : RECT;
                       _3 : Word ) : Word; WINAPI ( 'GetBoundsRect' );


FUNCTION GetBrushOrgEx ( _1 : HDC;
                       VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'GetBrushOrgEx' );


FUNCTION GetClipBox ( _1 : HDC;
                    VAR _2 : RECT ) : Integer; WINAPI ( 'GetClipBox' );


FUNCTION GetClipRgn ( _1 : HDC;
                    _2 : HRGN ) : Integer; WINAPI ( 'GetClipRgn' );


FUNCTION GetMetaRgn ( _1 : HDC;
                    _2 : HRGN ) : Integer; WINAPI ( 'GetMetaRgn' );


FUNCTION GetCurrentObject ( _1 : HDC;
                          _2 : Word ) : HGDIOBJ; WINAPI ( 'GetCurrentObject' );


FUNCTION GetCurrentPositionEx ( _1 : HDC;
                              VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'GetCurrentPositionEx' );


FUNCTION GetDeviceCaps ( _1 : HDC;
                       _2 : Integer ) : Integer; WINAPI ( 'GetDeviceCaps' );


FUNCTION GetDIBits ( _1 : HDC;
                   _2 : HBITMAP;
                   _3 : Word;
                   _4 : Word;
                   _5 : POINTER;
                   VAR _6 : TBITMAPINFO;
                   _7 : Word ) : Integer; WINAPI ( 'GetDIBits' );


FUNCTION GetFontData ( _1 : HDC;
                     _2 : DWord;
                     _3 : DWord;
                     _4 : POINTER;
                     _5 : DWord ) : DWord; WINAPI ( 'GetFontData' );


FUNCTION GetGraphicsMode ( _1 : HDC ) : Integer; WINAPI ( 'GetGraphicsMode' );


FUNCTION GetMapMode ( _1 : HDC ) : Integer; WINAPI ( 'GetMapMode' );


FUNCTION GetMetaFileBitsEx ( _1 : HMETAFILE;
                           _2 : Word;
                           _3 : POINTER ) : Word; WINAPI ( 'GetMetaFileBitsEx' );


FUNCTION GetNearestColor ( _1 : HDC;
                         _2 : TColorRef ) : TColorRef; WINAPI ( 'GetNearestColor' );


FUNCTION GetNearestPaletteIndex ( _1 : HPALETTE;
                                _2 : TColorRef ) : Word; WINAPI ( 'GetNearestPaletteIndex' );


FUNCTION GetObjectType ( h : HGDIOBJ ) : DWord; WINAPI ( 'GetObjectType' );


FUNCTION GetPaletteEntries ( _1 : HPALETTE;
                           _2 : Word;
                           _3 : Word;
                           VAR _4 : TPALETTEENTRY ) : Word; WINAPI ( 'GetPaletteEntries' );


FUNCTION GetPixel ( _1 : HDC;
                  _2 : Integer;
                  _3 : Integer ) : TColorRef; WINAPI ( 'GetPixel' );


FUNCTION GetPixelFormat ( _1 : HDC ) : Integer; WINAPI ( 'GetPixelFormat' );


FUNCTION GetPolyFillMode ( _1 : HDC ) : Integer; WINAPI ( 'GetPolyFillMode' );


FUNCTION GetRasterizerCaps ( VAR _1 : TRASTERIZER_STATUS;
                           _2 : Word ) : WINBOOL; WINAPI ( 'GetRasterizerCaps' );


FUNCTION GetRegionData ( _1 : HRGN;
                       _2 : DWord;
                       VAR _3 : TRGNDATA ) : DWord; WINAPI ( 'GetRegionData' );


FUNCTION GetRgnBox ( _1 : HRGN;
                   VAR _2 : RECT ) : Integer; WINAPI ( 'GetRgnBox' );


FUNCTION GetStockObject ( vle : Integer ) : HGDIOBJ; WINAPI ( 'GetStockObject' );


FUNCTION GetStretchBltMode ( _1 : HDC ) : Integer; WINAPI ( 'GetStretchBltMode' );


FUNCTION GetSystemPaletteEntries ( _1 : HDC;
                                 _2 : Word;
                                 _3 : Word;
                                 VAR _4{ : TPALETTEENTRY} ) : Word; WINAPI ( 'GetSystemPaletteEntries' );


FUNCTION GetSystemPaletteUse ( _1 : HDC ) : Word; WINAPI ( 'GetSystemPaletteUse' );


FUNCTION GetTextCharacterExtra ( _1 : HDC ) : Integer; WINAPI ( 'GetTextCharacterExtra' );


FUNCTION GetTextAlign ( _1 : HDC ) : Word; WINAPI ( 'GetTextAlign' );


FUNCTION GetTextColor ( _1 : HDC ) : TColorRef; WINAPI ( 'GetTextColor' );


FUNCTION GetTextCharset ( hdc : HDC ) : Integer; WINAPI ( 'GetTextCharset' );


FUNCTION GetTextCharsetInfo ( hdc : HDC;
                            VAR lpSig : TFONTSIGNATURE;
                            dwFlags : DWord ) : Integer; WINAPI ( 'GetTextCharsetInfo' );


FUNCTION TranslateCharsetInfo ( VAR lpSrc : DWord;
                              VAR lpCs : TCHARSETINFO;
                              dwFlags : DWord ) : WINBOOL; WINAPI ( 'TranslateCharsetInfo' );


FUNCTION GetFontLanguageInfo ( _1 : HDC ) : DWord; WINAPI ( 'GetFontLanguageInfo' );


FUNCTION GetViewportExtEx ( _1 : HDC;
                          VAR _2 : TSIZE ) : WINBOOL; WINAPI ( 'GetViewportExtEx' );


FUNCTION GetViewportOrgEx ( _1 : HDC;
                          VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'GetViewportOrgEx' );


FUNCTION GetWindowExtEx ( _1 : HDC;
                        VAR _2 : TSIZE ) : WINBOOL; WINAPI ( 'GetWindowExtEx' );


FUNCTION GetWindowOrgEx ( _1 : HDC;
                        VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'GetWindowOrgEx' );


FUNCTION IntersectClipRect ( _1 : HDC;
                           _2 : Integer;
                           _3 : Integer;
                           _4 : Integer;
                           _5 : Integer ) : Integer; WINAPI ( 'IntersectClipRect' );


FUNCTION InvertRgn ( _1 : HDC;
                   _2 : HRGN ) : WINBOOL; WINAPI ( 'InvertRgn' );


FUNCTION LineDDA ( _1 : Integer;
                 _2 : Integer;
                 _3 : Integer;
                 _4 : Integer;
                 _5 : LINEDDAPROC;
                 _6 : LPARAM32 ) : WINBOOL; WINAPI ( 'LineDDA' );
{ ShortCut }
FUNCTION LineDD ( _1 : Integer;
                 _2 : Integer;
                 _3 : Integer;
                 _4 : Integer;
                 _5 : LINEDDAPROC;
                 _6 : LPARAM32 ) : WINBOOL; WINAPI ( 'LineDDA' );


FUNCTION LineTo ( _1 : HDC;
                _2 : Integer;
                _3 : Integer ) : WINBOOL; WINAPI ( 'LineTo' );


FUNCTION MaskBlt ( _1 : HDC;
                 _2 : Integer;
                 _3 : Integer;
                 _4 : Integer;
                 _5 : Integer;
                 _6 : HDC;
                 _7 : Integer;
                 _8 : Integer;
                 _9 : HBITMAP;
                 _10 : Integer;
                 _11 : Integer;
                 _12 : DWord ) : WINBOOL; WINAPI ( 'MaskBlt' );


FUNCTION PlgBlt ( _1 : HDC;
                CONST P : POINT;
                _3 : HDC;
                _4 : Integer;
                _5 : Integer;
                _6 : Integer;
                _7 : Integer;
                _8 : HBITMAP;
                _9 : Integer;
                _10 : Integer ) : WINBOOL; WINAPI ( 'PlgBlt' );


FUNCTION OffsetClipRgn ( _1 : HDC;
                       _2 : Integer;
                       _3 : Integer ) : Integer; WINAPI ( 'OffsetClipRgn' );


FUNCTION OffsetRgn ( _1 : HRGN;
                   _2 : Integer;
                   _3 : Integer ) : Integer; WINAPI ( 'OffsetRgn' );


FUNCTION PatBlt ( _1 : HDC;
               _2 : Integer;
               _3 : Integer;
               _4 : Integer;
               _5 : Integer;
               _6 : DWord ) : WinBool; WINAPI ( 'PatBlt' );


FUNCTION Pie ( _1 : HDC;
             _2 : Integer;
             _3 : Integer;
             _4 : Integer;
             _5 : Integer;
             _6 : Integer;
             _7 : Integer;
             _8 : Integer;
             _9 : Integer ) : WINBOOL; WINAPI ( 'Pie' );


FUNCTION PlayMetaFile ( _1 : HDC;
                      _2 : HMETAFILE ) : WINBOOL; WINAPI ( 'PlayMetaFile' );


FUNCTION PaintRgn ( _1 : HDC;
                  _2 : HRGN ) : WINBOOL; WINAPI ( 'PaintRgn' );


FUNCTION PolyPolygon ( _1 : HDC;
                     CONST P : POINT;
                     CONST I : INTEGER;
                     _4 : Integer ) : WINBOOL; WINAPI ( 'PolyPolygon' );


FUNCTION PtInRegion ( _1 : HRGN;
                    _2 : Integer;
                    _3 : Integer ) : WINBOOL; WINAPI ( 'PtInRegion' );


FUNCTION PtVisible ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer ) : WINBOOL; WINAPI ( 'PtVisible' );


FUNCTION RectInRegion ( _1 : HRGN;
                       CONST R : RECT ) : WINBOOL; WINAPI ( 'RectInRegion' );


FUNCTION RectVisible ( _1 : HDC;
                      CONST R : RECT ) : WINBOOL; WINAPI ( 'RectVisible' );


FUNCTION Rectangle ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer;
                   _4 : Integer;
                   _5 : Integer ) : WINBOOL; WINAPI ( 'Rectangle' );


FUNCTION RestoreDC ( _1 : HDC;
                   _2 : Integer ) : WINBOOL; WINAPI ( 'RestoreDC' );


FUNCTION RealizePalette ( _1 : HDC ) : Word; WINAPI ( 'RealizePalette' );


FUNCTION RoundRect ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer;
                   _4 : Integer;
                   _5 : Integer;
                   _6 : Integer;
                   _7 : Integer ) : WINBOOL; WINAPI ( 'RoundRect' );


FUNCTION ResizePalette ( _1 : HPALETTE;
                       _2 : Word ) : WINBOOL; WINAPI ( 'ResizePalette' );


FUNCTION SaveDC ( _1 : HDC ) : Integer; WINAPI ( 'SaveDC' );


FUNCTION SelectClipRgn ( _1 : HDC;
                       _2 : HRGN ) : Integer; WINAPI ( 'SelectClipRgn' );


FUNCTION ExtSelectClipRgn ( _1 : HDC;
                          _2 : HRGN;
                          _3 : Integer ) : Integer; WINAPI ( 'ExtSelectClipRgn' );


FUNCTION SetMetaRgn ( _1 : HDC ) : Integer; WINAPI ( 'SetMetaRgn' );


FUNCTION SelectObject ( _1 : HDC;
                      _2 : HGDIOBJ ) : HGDIOBJ; WINAPI ( 'SelectObject' );


FUNCTION SelectPalette ( _1 : HDC;
                       _2 : HPALETTE;
                       _3 : WINBOOL ) : HPALETTE; WINAPI ( 'SelectPalette' );


FUNCTION SetBkColor ( _1 : HDC;
                    _2 : TColorRef ) : TColorRef; WINAPI ( 'SetBkColor' );


FUNCTION SetBkMode ( _1 : HDC;
                   _2 : Integer ) : Integer; WINAPI ( 'SetBkMode' );


FUNCTION SetBitmapBits ( _1 : HBITMAP;
                       _2 : DWord;
                       CONST V ) : LongInt; WINAPI ( 'SetBitmapBits' );


FUNCTION SetBoundsRect ( _1 : HDC;
                       CONST R : RECT;
                       _3 : Word ) : Word; WINAPI ( 'SetBoundsRect' );


FUNCTION SetDIBits ( _1 : HDC;
                   _2 : HBITMAP;
                   _3 : Word;
                   _4 : Word;
                   CONST V;
                   CONST B : BITMAPINFO;
                   _7 : Word ) : Integer; WINAPI ( 'SetDIBits' );


FUNCTION SetDIBitsToDevice ( _1 : HDC;
                           _2 : Integer;
                           _3 : Integer;
                           _4 : DWord;
                           _5 : DWord;
                           _6 : Integer;
                           _7 : Integer;
                           _8 : Word;
                           _9 : Word;
                           CONST V;
                           CONST B : BITMAPINFO;
                           _12 : Word ) : Integer; WINAPI ( 'SetDIBitsToDevice' );


FUNCTION SetMapperFlags ( _1 : HDC;
                        _2 : DWord ) : DWord; WINAPI ( 'SetMapperFlags' );


FUNCTION SetGraphicsMode ( hdc : HDC;
                         iMode : Integer ) : Integer; WINAPI ( 'SetGraphicsMode' );


FUNCTION SetMapMode ( _1 : HDC;
                    _2 : Integer ) : Integer; WINAPI ( 'SetMapMode' );


FUNCTION SetMetaFileBitsEx ( _1 : Word;
                            CONST B : BYTE ) : HMETAFILE; WINAPI ( 'SetMetaFileBitsEx' );


FUNCTION SetPaletteEntries ( _1 : HPALETTE;
                           _2 : Word;
                           _3 : Word;
                           CONST P : PALETTEENTRY ) : Word; WINAPI ( 'SetPaletteEntries' );


FUNCTION SetPixel ( _1 : HDC;
                  _2 : Integer;
                  _3 : Integer;
                  _4 : TColorRef ) : TColorRef; WINAPI ( 'SetPixel' );


FUNCTION SetPixelV ( _1 : HDC;
                   _2 : Integer;
                   _3 : Integer;
                   _4 : TColorRef ) : WINBOOL; WINAPI ( 'SetPixelV' );


FUNCTION SetPolyFillMode ( _1 : HDC;
                         _2 : Integer ) : Integer; WINAPI ( 'SetPolyFillMode' );


FUNCTION StretchBlt ( _1 : HDC;
                    _2 : Integer;
                    _3 : Integer;
                    _4 : Integer;
                    _5 : Integer;
                    _6 : HDC;
                    _7 : Integer;
                    _8 : Integer;
                    _9 : Integer;
                    _10 : Integer;
                    _11 : DWord ) : WINBOOL; WINAPI ( 'StretchBlt' );


FUNCTION SetRectRgn ( _1 : HRGN;
                    _2 : Integer;
                    _3 : Integer;
                    _4 : Integer;
                    _5 : Integer ) : WINBOOL; WINAPI ( 'SetRectRgn' );

FUNCTION StretchDIBits ( _1 : HDC;
                       _2 : Integer;
                       _3 : Integer;
                       _4 : Integer;
                       _5 : Integer;
                       _6 : Integer;
                       _7 : Integer;
                       _8 : Integer;
                       _9 : Integer;
                       CONST V;
                       CONST B : BITMAPINFO;
                       _12 : Word;
                       _13 : DWord ) : Integer; WINAPI ( 'StretchDIBits' );


FUNCTION SetROP2 ( _1 : HDC;
                 _2 : Integer ) : Integer; WINAPI ( 'SetROP2' );


FUNCTION SetStretchBltMode ( _1 : HDC;
                           _2 : Integer ) : Integer; WINAPI ( 'SetStretchBltMode' );


FUNCTION SetSystemPaletteUse ( _1 : HDC;
                             _2 : Word ) : Word; WINAPI ( 'SetSystemPaletteUse' );


FUNCTION SetTextCharacterExtra ( _1 : HDC;
                               _2 : Integer ) : Integer; WINAPI ( 'SetTextCharacterExtra' );


FUNCTION SetTextColor ( _1 : HDC;
                      _2 : TColorRef ) : TColorRef; WINAPI ( 'SetTextColor' );


FUNCTION SetTextAlign ( _1 : HDC;
                      _2 : Word ) : Word; WINAPI ( 'SetTextAlign' );


FUNCTION SetTextJustification ( _1 : HDC;
                              _2 : Integer;
                              _3 : Integer ) : WINBOOL; WINAPI ( 'SetTextJustification' );


FUNCTION UpdateColors ( _1 : HDC ) : WINBOOL; WINAPI ( 'UpdateColors' );


FUNCTION PlayMetaFileRecord ( _1 : HDC;
                            VAR _2 : THANDLETABLE;
                            VAR _3 : TMETARECORD;
                            _4 : Word ) : WINBOOL; WINAPI ( 'PlayMetaFileRecord' );


FUNCTION EnumMetaFile ( _1 : HDC;
                      _2 : HMETAFILE;
                      _3 : ENUMMETAFILEPROC;
                      _4 : LPARAM32 ) : WINBOOL; WINAPI ( 'EnumMetaFile' );


FUNCTION CloseEnhMetaFile ( _1 : HDC ) : HENHMETAFILE; WINAPI ( 'CloseEnhMetaFile' );


FUNCTION DeleteEnhMetaFile ( _1 : HENHMETAFILE ) : WINBOOL; WINAPI ( 'DeleteEnhMetaFile' );


FUNCTION EnumEnhMetaFile ( _1 : HDC;
                         _2 : HENHMETAFILE;
                         _3 : ENHMETAFILEPROC;
                         _4 : POINTER;
                          CONST R : RECT ) : WINBOOL; WINAPI ( 'EnumEnhMetaFile' );


FUNCTION GetEnhMetaFileHeader ( _1 : HENHMETAFILE;
                              _2 : Word;
                              VAR _3 : TENHMETAHEADER ) : Word; WINAPI ( 'GetEnhMetaFileHeader' );


FUNCTION GetEnhMetaFilePaletteEntries ( _1 : HENHMETAFILE;
                                      _2 : Word;
                                      VAR _3 : TPALETTEENTRY ) : Word; WINAPI ( 'GetEnhMetaFilePaletteEntries' );


FUNCTION GetWinMetaFileBits ( _1 : HENHMETAFILE;
                            _2 : Word;
                            VAR Buf;
                            _4 : Integer;
                            _5 : HDC ) : Word; WINAPI ( 'GetWinMetaFileBits' );


FUNCTION PlayEnhMetaFile ( _1 : HDC;
                         _2 : HENHMETAFILE;
                         CONST R : RECT ) : WINBOOL; WINAPI ( 'PlayEnhMetaFile' );


FUNCTION PlayEnhMetaFileRecord ( _1 : HDC;
                               VAR _2 : THANDLETABLE;
                               CONST E : ENHMETARECORD;
                               _4 : Word ) : WINBOOL; WINAPI ( 'PlayEnhMetaFileRecord' );


FUNCTION SetEnhMetaFileBits ( _1 : Word;
                             CONST B : BYTE ) : HENHMETAFILE; WINAPI ( 'SetEnhMetaFileBits' );


FUNCTION SetWinMetaFileBits ( _1 : Word;
                            CONST B : BYTE;
                            _3 : HDC;
                            CONST M : METAFILEPICT ) : HENHMETAFILE; WINAPI ( 'SetWinMetaFileBits' );


FUNCTION GdiComment ( _1 : HDC;
                    _2 : Word;
                     CONST B : Byte ) : WINBOOL; WINAPI ( 'GdiComment' );


FUNCTION AngleArc ( _1 : HDC;
                  _2 : Integer;
                  _3 : Integer;
                  _4 : DWord;
                  _5 : Single;
                  _6 : Single ) : WINBOOL; WINAPI ( 'AngleArc' );


FUNCTION PolyPolyline ( _1 : HDC;
                      CONST P : POINT;
                      CONST D : DWord;
                      _4 : DWord ) : WINBOOL; WINAPI ( 'PolyPolyline' );


FUNCTION GetWorldTransform ( _1 : HDC;
                           VAR _2 : XFORM ) : WINBOOL; WINAPI ( 'GetWorldTransform' );


FUNCTION SetWorldTransform ( _1 : HDC;
CONST X : XFORM ) : WINBOOL; WINAPI ( 'SetWorldTransform' );


FUNCTION ModifyWorldTransform ( _1 : HDC;
                              CONST X : XFORM;
                              _3 : DWord ) : WINBOOL; WINAPI ( 'ModifyWorldTransform' );


FUNCTION CombineTransform ( _1 : PXFORM;
                          CONST X : XFORM;
                          CONST X2 : XFORM ) : WINBOOL; WINAPI ( 'CombineTransform' );


FUNCTION CreateDIBSection ( _1 : HDC;
                          CONST B : BITMAPINFO;
                          _3 : Word;
                          VAR V;
                          _5 : THandle;
                          _6 : DWord ) : HBITMAP; WINAPI ( 'CreateDIBSection' );


FUNCTION GetDIBColorTable ( _1 : HDC;
                          _2 : Word;
                          _3 : Word;
                          VAR _4 : TRGBQUAD ) : Word; WINAPI ( 'GetDIBColorTable' );


FUNCTION SetDIBColorTable ( _1 : HDC;
                          _2 : Word;
                          _3 : Word;
                          CONST R : RGBQUAD ) : Word; WINAPI ( 'SetDIBColorTable' );


FUNCTION SetColorAdjustment ( _1 : HDC;
                            CONST C : COLORADJUSTMENT ) : WINBOOL; WINAPI ( 'SetColorAdjustment' );


FUNCTION GetColorAdjustment ( _1 : HDC;
                            VAR _2 : COLORADJUSTMENT ) : WINBOOL; WINAPI ( 'GetColorAdjustment' );


FUNCTION CreateHalftonePalette ( _1 : HDC ) : HPALETTE; WINAPI ( 'CreateHalftonePalette' );


FUNCTION EndDoc ( _1 : HDC ) : Integer; WINAPI ( 'EndDoc' );


FUNCTION StartPage ( _1 : HDC ) : Integer; WINAPI ( 'StartPage' );


FUNCTION EndPage ( _1 : HDC ) : Integer; WINAPI ( 'EndPage' );


FUNCTION SetAbortProc ( _1 : HDC;
                      _2 : TABORTPROC ) : Integer; WINAPI ( 'SetAbortProc' );


FUNCTION ArcTo ( _1 : HDC;
               _2 : Integer;
               _3 : Integer;
               _4 : Integer;
               _5 : Integer;
               _6 : Integer;
               _7 : Integer;
               _8 : Integer;
               _9 : Integer ) : WINBOOL; WINAPI ( 'ArcTo' );


FUNCTION BeginPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'BeginPath' );


FUNCTION CloseFigure ( _1 : HDC ) : WINBOOL; WINAPI ( 'CloseFigure' );


FUNCTION EndPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'EndPath' );


FUNCTION FillPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'FillPath' );


FUNCTION FlattenPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'FlattenPath' );


FUNCTION GetPath ( _1 : HDC;
                 VAR _2 : TPOINT;
                 VAR Buf;
                 _4 : Integer ) : Integer; WINAPI ( 'GetPath' );


FUNCTION PathToRegion ( _1 : HDC ) : HRGN; WINAPI ( 'PathToRegion' );


FUNCTION PolyDraw ( _1 : HDC;
                  CONST P : POINT;
                  CONST B;
                  _4 : Integer ) : WINBOOL; WINAPI ( 'PolyDraw' );


FUNCTION SelectClipPath ( _1 : HDC;
                        _2 : Integer ) : WINBOOL; WINAPI ( 'SelectClipPath' );


FUNCTION SetArcDirection ( _1 : HDC;
                         _2 : Integer ) : Integer; WINAPI ( 'SetArcDirection' );


FUNCTION SetMiterLimit ( _1 : HDC;
                       _2 : Single;
                       VAR _3 : Single ) : WINBOOL; WINAPI ( 'SetMiterLimit' );


FUNCTION StrokeAndFillPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'StrokeAndFillPath' );


FUNCTION StrokePath ( _1 : HDC ) : WINBOOL; WINAPI ( 'StrokePath' );


FUNCTION WidenPath ( _1 : HDC ) : WINBOOL; WINAPI ( 'WidenPath' );


FUNCTION ExtCreatePen ( _1 : DWord;
                      _2 : DWord;
                      CONST L : LOGBRUSH;
                      _4 : DWord;
                       CONST D : DWord ) : HPEN; WINAPI ( 'ExtCreatePen' );


FUNCTION GetMiterLimit ( _1 : HDC;
                       VAR _2 : Single ) : WINBOOL; WINAPI ( 'GetMiterLimit' );


FUNCTION GetArcDirection ( _1 : HDC ) : Integer; WINAPI ( 'GetArcDirection' );


FUNCTION MoveToEx ( _1 : HDC;
                  _2 : Integer;
                  _3 : Integer;
                  _4 : PPOINT ) : WINBOOL; WINAPI ( 'MoveToEx' );


FUNCTION CreatePolygonRgn ( CONST P : POINT;
                          _2 : Integer;
                          _3 : Integer ) : HRGN; WINAPI ( 'CreatePolygonRgn' );


FUNCTION DPtoLP ( _1 : HDC;
                VAR _2 : TPOINT;
                _3 : Integer ) : WINBOOL; WINAPI ( 'DPtoLP' );


FUNCTION LPtoDP ( _1 : HDC;
                VAR _2 : TPOINT;
                _3 : Integer ) : WINBOOL; WINAPI ( 'LPtoDP' );


FUNCTION Polygon ( _1 : HDC;
                 CONST P : POINT;
                 _3 : Integer ) : WINBOOL; WINAPI ( 'Polygon' );


FUNCTION Polyline ( _1 : HDC;
                  CONST P : POINT;
                  _3 : Integer ) : WINBOOL; WINAPI ( 'Polyline' );


FUNCTION PolyBezier ( _1 : HDC;
                    CONST P : POINT;
                    _3 : DWord ) : WINBOOL; WINAPI ( 'PolyBezier' );


FUNCTION PolyBezierTo ( _1 : HDC;
                      CONST P : POINT;
                      _3 : DWord ) : WINBOOL; WINAPI ( 'PolyBezierTo' );


FUNCTION PolylineTo ( _1 : HDC;
                    CONST P : POINT;
                    _3 : DWord ) : WINBOOL; WINAPI ( 'PolylineTo' );


FUNCTION SetViewportExtEx ( _1 : HDC;
                          _2 : Integer;
                          _3 : Integer;
                          VAR _4 : TSIZE ) : WINBOOL; WINAPI ( 'SetViewportExtEx' );


FUNCTION SetViewportOrgEx ( _1 : HDC;
                          _2 : Integer;
                          _3 : Integer;
                          VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'SetViewportOrgEx' );


FUNCTION SetWindowExtEx ( _1 : HDC;
                        _2 : Integer;
                        _3 : Integer;
                        VAR _4 : TSIZE ) : WINBOOL; WINAPI ( 'SetWindowExtEx' );


FUNCTION SetWindowOrgEx ( _1 : HDC;
                        _2 : Integer;
                        _3 : Integer;
                        VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'SetWindowOrgEx' );


FUNCTION OffsetViewportOrgEx ( _1 : HDC;
                             _2 : Integer;
                             _3 : Integer;
                             VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'OffsetViewportOrgEx' );


FUNCTION OffsetWindowOrgEx ( _1 : HDC;
                           _2 : Integer;
                           _3 : Integer;
                           VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'OffsetWindowOrgEx' );


FUNCTION ScaleViewportExtEx ( _1 : HDC;
                            _2 : Integer;
                            _3 : Integer;
                            _4 : Integer;
                            _5 : Integer;
                            VAR _6 : TSIZE ) : WINBOOL; WINAPI ( 'ScaleViewportExtEx' );


FUNCTION ScaleWindowExtEx ( _1 : HDC;
                          _2 : Integer;
                          _3 : Integer;
                          _4 : Integer;
                          _5 : Integer;
                          VAR _6 : TSIZE ) : WINBOOL; WINAPI ( 'ScaleWindowExtEx' );


FUNCTION SetBitmapDimensionEx ( _1 : HBITMAP;
                              _2 : Integer;
                              _3 : Integer;
                              VAR _4 : TSIZE ) : WINBOOL; WINAPI ( 'SetBitmapDimensionEx' );


FUNCTION SetBrushOrgEx ( _1 : HDC;
                       _2 : Integer;
                       _3 : Integer;
                       VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'SetBrushOrgEx' );


FUNCTION GetDCOrgEx ( _1 : HDC;
                    VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'GetDCOrgEx' );


FUNCTION FixBrushOrgEx ( _1 : HDC;
                       _2 : Integer;
                       _3 : Integer;
                       VAR _4 : TPOINT ) : WINBOOL; WINAPI ( 'FixBrushOrgEx' );


FUNCTION UnrealizeObject ( _1 : HGDIOBJ ) : WINBOOL; WINAPI ( 'UnrealizeObject' );


FUNCTION GdiFlush : WINBOOL; WINAPI ( 'GdiFlush' );


FUNCTION GdiSetBatchLimit ( _1 : DWord ) : DWord; WINAPI ( 'GdiSetBatchLimit' );


FUNCTION GdiGetBatchLimit : DWord; WINAPI ( 'GdiGetBatchLimit' );


FUNCTION SetICMMode ( _1 : HDC;
                    _2 : Integer ) : Integer; WINAPI ( 'SetICMMode' );


FUNCTION CheckColorsInGamut ( _1 : HDC;
                            _2 : POINTER;
                            _3 : POINTER;
                            _4 : DWord ) : WINBOOL; WINAPI ( 'CheckColorsInGamut' );


FUNCTION GetColorSpace ( _1 : HDC ) : THandle; WINAPI ( 'GetColorSpace' );


FUNCTION SetColorSpace ( _1 : HDC;
                       _2 : HCOLORSPACE ) : WINBOOL; WINAPI ( 'SetColorSpace' );


FUNCTION DeleteColorSpace ( _1 : HCOLORSPACE ) : WINBOOL; WINAPI ( 'DeleteColorSpace' );


FUNCTION GetDeviceGammaRamp ( _1 : HDC;
                            _2 : POINTER ) : WINBOOL; WINAPI ( 'GetDeviceGammaRamp' );


FUNCTION SetDeviceGammaRamp ( _1 : HDC;
                            _2 : POINTER ) : WINBOOL; WINAPI ( 'SetDeviceGammaRamp' );


FUNCTION ColorMatchToTarget ( _1 : HDC;
                            _2 : HDC;
                            _3 : DWord ) : WINBOOL; WINAPI ( 'ColorMatchToTarget' );


FUNCTION CreatePropertySheetPageA ( lppsp : PCPROPSHEETPAGE ) : HPROPSHEETPAGE; WINAPI ( 'CreatePropertySheetPageA' );
{ ShortCut }
FUNCTION CreatePropertySheetPage ( lppsp : PCPROPSHEETPAGE ) : HPROPSHEETPAGE; WINAPI ( 'CreatePropertySheetPageA' );


FUNCTION DestroyPropertySheetPage ( hPSPage : HPROPSHEETPAGE ) : WINBOOL; WINAPI ( 'DestroyPropertySheetPage' );


PROCEDURE InitCommonControls; WINAPI ( 'InitCommonControls' );

{
Const ImageList_AddIcon(himl, = hicon) ImageList_ReplaceIcon(himl, -1, hicon);WINAPI('ImageList_AddIcon');

}
FUNCTION ImageList_Create ( cx : Integer;
                          cy : Integer;
                          flags : Word;
                          cInitial : Integer;
                          cGrow : Integer ) : HIMAGELIST; WINAPI ( 'ImageList_Create' );


FUNCTION ImageList_Destroy ( himl : HIMAGELIST ) : WINBOOL; WINAPI ( 'ImageList_Destroy' );


FUNCTION ImageList_GetImageCount ( himl : HIMAGELIST ) : Integer; WINAPI ( 'ImageList_GetImageCount' );


FUNCTION ImageList_Add ( himl : HIMAGELIST;
                       hbmImage : HBITMAP;
                       hbmMask : HBITMAP ) : Integer; WINAPI ( 'ImageList_Add' );


FUNCTION ImageList_ReplaceIcon ( himl : HIMAGELIST;
                               i : Integer;
                               hicon : HICON ) : Integer; WINAPI ( 'ImageList_ReplaceIcon' );


FUNCTION ImageList_SetBkColor ( himl : HIMAGELIST;
                              clrBk : TColorRef ) : TColorRef; WINAPI ( 'ImageList_SetBkColor' );


FUNCTION ImageList_GetBkColor ( himl : HIMAGELIST ) : TColorRef; WINAPI ( 'ImageList_GetBkColor' );


FUNCTION ImageList_SetOverlayImage ( himl : HIMAGELIST;
                                   iImage : Integer;
                                   iOverlay : Integer ) : WINBOOL; WINAPI ( 'ImageList_SetOverlayImage' );


FUNCTION ImageList_Draw ( himl : HIMAGELIST;
                        i : Integer;
                        hdcDst : HDC;
                        x : Integer;
                        y : Integer;
                        fStyle : Word ) : WINBOOL; WINAPI ( 'ImageList_Draw' );


FUNCTION ImageList_Replace ( himl : HIMAGELIST;
                           i : Integer;
                           hbmImage : HBITMAP;
                           hbmMask : HBITMAP ) : WINBOOL; WINAPI ( 'ImageList_Replace' );


FUNCTION ImageList_AddMasked ( himl : HIMAGELIST;
                             hbmImage : HBITMAP;
                             crMask : TColorRef ) : Integer; WINAPI ( 'ImageList_AddMasked' );


FUNCTION ImageList_DrawEx ( himl : HIMAGELIST;
                          i : Integer;
                          hdcDst : HDC;
                          x : Integer;
                          y : Integer;
                          dx : Integer;
                          dy : Integer;
                          rgbBk : TColorRef;
                          rgbFg : TColorRef;
                          fStyle : Word ) : WINBOOL; WINAPI ( 'ImageList_DrawEx' );


FUNCTION ImageList_Remove ( himl : HIMAGELIST;
                          i : Integer ) : WINBOOL; WINAPI ( 'ImageList_Remove' );


FUNCTION ImageList_GetIcon ( himl : HIMAGELIST;
                           i : Integer;
                           flags : Word ) : HICON; WINAPI ( 'ImageList_GetIcon' );


FUNCTION ImageList_BeginDrag ( himlTrack : HIMAGELIST;
                             iTrack : Integer;
                             dxHotspot : Integer;
                             dyHotspot : Integer ) : WINBOOL; WINAPI ( 'ImageList_BeginDrag' );


PROCEDURE ImageList_EndDrag; WINAPI ( 'ImageList_EndDrag' );


FUNCTION ImageList_DragEnter ( hwndLock : HWND;
                             x : Integer;
                             y : Integer ) : WINBOOL; WINAPI ( 'ImageList_DragEnter' );


FUNCTION ImageList_DragLeave ( hwndLock : HWND ) : WINBOOL; WINAPI ( 'ImageList_DragLeave' );


FUNCTION ImageList_DragMove ( x : Integer;
                            y : Integer ) : WINBOOL; WINAPI ( 'ImageList_DragMove' );


FUNCTION ImageList_SetDragCursorImage ( himlDrag : HIMAGELIST;
                                      iDrag : Integer;
                                      dxHotspot : Integer;
                                      dyHotspot : Integer ) : WINBOOL; WINAPI ( 'ImageList_SetDragCursorImage' );


FUNCTION ImageList_DragShowNolock ( fShow : WINBOOL ) : WINBOOL; WINAPI ( 'ImageList_DragShowNolock' );


FUNCTION ImageList_GetDragImage ( VAR ppt : TPOINT;
                                VAR pptHotspot : TPOINT ) : HIMAGELIST; WINAPI ( 'ImageList_GetDragImage' );


FUNCTION ImageList_GetIconSize ( himl : HIMAGELIST;
                               VAR cx,
                               cy : Integer ) : WINBOOL; WINAPI ( 'ImageList_GetIconSize' );


FUNCTION ImageList_SetIconSize ( himl : HIMAGELIST;
                               cx : Integer;
                               cy : Integer ) : WINBOOL; WINAPI ( 'ImageList_SetIconSize' );


FUNCTION ImageList_GetImageInfo ( himl : HIMAGELIST;
                                i : Integer;
                                VAR pImageInfo : TIMAGEINFO ) : WINBOOL; WINAPI ( 'ImageList_GetImageInfo' );


FUNCTION ImageList_Merge ( himl1 : HIMAGELIST;
                         i1 : Integer;
                         himl2 : HIMAGELIST;
                         i2 : Integer;
                         dx : Integer;
                         dy : Integer ) : HIMAGELIST; WINAPI ( 'ImageList_Merge' );


FUNCTION CreateToolbarEx ( hwnd : HWND;
                         ws : DWord;
                         wID : Word;
                         nBitmaps : Integer;
                         hBMInst : THANDLE;
                         wBMID : Word;
                         VAR lpButtons : TBBUTTON;
                         iNumButtons : Integer;
                         dxButton : Integer;
                         dyButton : Integer;
                         dxBitmap : Integer;
                         dyBitmap : Integer;
                         uStructSize : Word ) : HWND; WINAPI ( 'CreateToolbarEx' );


FUNCTION CreateMappedBitmap ( xInstance : THANDLE;
                            idBitmap : Integer;
                            wFlags : Word;
                            VAR lpColorMap : TCOLORMAP;
                            iNumMaps : Integer ) : HBITMAP; WINAPI ( 'CreateMappedBitmap' );



PROCEDURE MenuHelp ( uMsg : Word;
                  wParam : UINT;
                  lParam : LPARAM32;
                  hMainMenu : HMENU;
                  hInst : THANDLE;
                  hwndStatus : HWND;
                  VAR lpwIDs : Word ); WINAPI ( 'MenuHelp' );


FUNCTION ShowHideMenuCtl ( Wnd : HWND;
                         uFlags : Word;
                         VAR lpInfo : Integer ) : WINBOOL; WINAPI ( 'ShowHideMenuCtl' );


PROCEDURE GetEffectiveClientRect ( Wnd : HWND;
                                VAR lprc : RECT;
                                VAR lpInfo : Integer ); WINAPI ( 'GetEffectiveClientRect' );


FUNCTION MakeDragList ( hLB : HWND ) : WINBOOL; WINAPI ( 'MakeDragList' );


PROCEDURE DrawInsert ( handParent : HWND;
                    hLB : HWND;
                    nItem : Integer ); WINAPI ( 'DrawInsert' );


FUNCTION LBItemFromPt ( hLB : HWND;
                      pt : TPOINT;
                      bAutoScroll : WINBOOL ) : Integer; WINAPI ( 'LBItemFromPt' );


FUNCTION CreateUpDownControl ( dwStyle : DWord;
                             x : Integer;
                             y : Integer;
                             cx : Integer;
                             cy : Integer;
                             hParent : HWND;
                             nID : Integer;
                             hInst : THANDLE;
                             hBuddy : HWND;
                             nUpper : Integer;
                             nLower : Integer;
                             nPos : Integer ) : HWND; WINAPI ( 'CreateUpDownControl' );


FUNCTION CommDlgExtendedError : DWord; WINAPI ( 'CommDlgExtendedError' );

FUNCTION RegCloseKey ( hKey : HKEY ) : LongInt; WINAPI ( 'RegCloseKey' );


FUNCTION RegSetKeySecurity ( hKey : HKEY;
                           SecurityInformation : SECURITY_INFORMATION;
                           VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR ) : LongInt; WINAPI ( 'RegSetKeySecurity' );


FUNCTION RegFlushKey ( hKey : HKEY ) : LongInt; WINAPI ( 'RegFlushKey' );


FUNCTION RegGetKeySecurity ( hKey : HKEY;
                           SecurityInformation : SECURITY_INFORMATION;
                           VAR pSecurityDescriptor : TSECURITY_DESCRIPTOR;
                           VAR lpcbSecurityDescriptor : DWord ) : LongInt; WINAPI ( 'RegGetKeySecurity' );


FUNCTION RegNotifyChangeKeyValue ( hKey : HKEY;
                                 bWatchSubtree : WINBOOL;
                                 dwNotifyFilter : DWord;
                                 hEvent : THandle;
                                 fAsynchronus : WINBOOL ) : LongInt; WINAPI ( 'RegNotifyChangeKeyValue' );

FUNCTION IsValidCodePage ( CodePage : Word ) : WINBOOL; WINAPI ( 'IsValidCodePage' );


FUNCTION GetACP : Word; WINAPI ( 'GetACP' );


FUNCTION GetOEMCP : Word; WINAPI ( 'GetOEMCP' );


FUNCTION GetCPInfo ( _1 : Word;
                   VAR _2 : TCPINFO ) : WINBOOL; WINAPI ( 'GetCPInfo' );


FUNCTION IsDBCSLeadByte ( TestChar : BYTE ) : WINBOOL; WINAPI ( 'IsDBCSLeadByte' );


FUNCTION IsDBCSLeadByteEx ( CodePage : Word;
                          TestChar : BYTE ) : WINBOOL; WINAPI ( 'IsDBCSLeadByteEx' );


FUNCTION MultiByteToWideChar ( CodePage : Word;
                             dwFlags : DWord;
                             lpMultiByteStr : PChar;
                             cchMultiByte : Integer;
                             lpWideCharStr : PWIDECHAR;
                             cchWideChar : Integer ) : Integer; WINAPI ( 'MultiByteToWideChar' );


FUNCTION WideCharToMultiByte ( CodePage : Word;
                             dwFlags : DWord;
                             lpWideCharStr : PWIDECHAR;
                             cchWideChar : Integer;
                             lpMultiByteStr : PChar;
                             cchMultiByte : Integer;
                             lpDefaultChar : PChar;
                             VAR lpUsedDefaultChar : WinBool ) : Integer; WINAPI ( 'WideCharToMultiByte' );


FUNCTION IsValidLocale ( Locale : LCID;
                       dwFlags : DWord ) : WINBOOL; WINAPI ( 'IsValidLocale' );


FUNCTION ConvertDefaultLocale ( Locale : LCID ) : LCID; WINAPI ( 'ConvertDefaultLocale' );


FUNCTION GetThreadLocale : LCID; WINAPI ( 'GetThreadLocale' );


FUNCTION SetThreadLocale ( Locale : LCID ) : WINBOOL; WINAPI ( 'SetThreadLocale' );


FUNCTION GetSystemDefaultLangID : LANGID; WINAPI ( 'GetSystemDefaultLangID' );


FUNCTION GetUserDefaultLangID : LANGID; WINAPI ( 'GetUserDefaultLangID' );


FUNCTION GetSystemDefaultLCID : LCID; WINAPI ( 'GetSystemDefaultLCID' );


FUNCTION GetUserDefaultLCID : LCID; WINAPI ( 'GetUserDefaultLCID' );


FUNCTION ReadConsoleOutputAttribute ( hConsoleOutput : Integer;
                                    lpAttribute : Pointer;
                                    nLength : DWord;
                                    dwReadCoord : COORD;
                                    VAR lpNumberOfAttrsRead : DWord ) : WINBOOL; WINAPI ( 'ReadConsoleOutputAttribute' );


FUNCTION WriteConsoleOutputAttribute ( hConsoleOutput : Integer;
                                     lpAttribute :  Pointer;
                                     nLength : DWord;
                                     dwWriteCoord : COORD;
                                     VAR lpNumberOfAttrsWritten : DWord ) : WINBOOL; WINAPI ( 'WriteConsoleOutputAttribute' );


FUNCTION FillConsoleOutputAttribute ( hConsoleOutput : Integer;
                                    wAttribute : Word;
                                    nLength : DWord;
                                    dwWriteCoord : COORD;
                                    VAR lpNumberOfAttrsWritten : DWord ) : WINBOOL; WINAPI ( 'FillConsoleOutputAttribute' );


FUNCTION GetConsoleMode ( hConsoleHandle : Integer;
                        VAR lpMode : DWord ) : WINBOOL; WINAPI ( 'GetConsoleMode' );


FUNCTION GetNumberOfConsoleInputEvents ( hConsoleInput : Integer;
                                       VAR lpNumberOfEvents : DWord ) : WINBOOL; WINAPI ( 'GetNumberOfConsoleInputEvents' );



FUNCTION GetConsoleScreenBufferInfo ( hConsoleOutput : Integer;
                                    VAR lpConsoleScreenBufferInfo : TCONSOLE_SCREEN_BUFFER_INFO ) : WINBOOL; WINAPI ( 'GetConsoleScreenBufferInfo' );


FUNCTION GetLargestConsoleWindowSize ( hConsoleOutput : Integer ) : COORD; WINAPI ( 'GetLargestConsoleWindowSize' );


FUNCTION GetConsoleCursorInfo ( hConsoleOutput : Integer;
                              VAR lpConsoleCursorInfo : TCONSOLE_CURSOR_INFO ) : WINBOOL; WINAPI ( 'GetConsoleCursorInfo' );


FUNCTION GetNumberOfConsoleMouseButtons ( VAR lpNumberOfMouseButtons : DWord ) : WINBOOL; WINAPI ( 'GetNumberOfConsoleMouseButtons' );


FUNCTION SetConsoleMode ( hConsoleHandle : Integer;
                        dwMode : DWord ) : WINBOOL; WINAPI ( 'SetConsoleMode' );


FUNCTION SetConsoleDisplayMode ( hConsoleOutput : THandle;
                                 dwFlags : DWORD;
                                 lpNewScreenBufferDimensions : PCoord )
                                 : WINBOOL; WINAPI ( 'SetConsoleDisplayMode' );


FUNCTION SetConsoleActiveScreenBuffer ( hConsoleOutput : Integer ) : WINBOOL; WINAPI ( 'SetConsoleActiveScreenBuffer' );


FUNCTION FlushConsoleInputBuffer ( hConsoleInput : Integer ) : WINBOOL; WINAPI ( 'FlushConsoleInputBuffer' );


FUNCTION SetConsoleScreenBufferSize ( hConsoleOutput : Integer;
                                    dwSize : COORD ) : WINBOOL; WINAPI ( 'SetConsoleScreenBufferSize' );


FUNCTION SetConsoleCursorPosition ( hConsoleOutput : Integer;
                                  dwCursorPosition : COORD ) : WINBOOL; WINAPI ( 'SetConsoleCursorPosition' );


FUNCTION SetConsoleCursorInfo ( hConsoleOutput : Integer;
                              CONST lpConsoleCursorInfo :  CONSOLE_CURSOR_INFO ) : WINBOOL; WINAPI ( 'SetConsoleCursorInfo' );


FUNCTION SetConsoleWindowInfo ( hConsoleOutput : Integer;
                              bAbsolute : WINBOOL;
                              CONST lpConsoleWindow :  SMALL_RECT ) : WINBOOL; WINAPI ( 'SetConsoleWindowInfo' );


FUNCTION SetConsoleTextAttribute ( hConsoleOutput : Integer;
                                 wAttributes : Word ) : WINBOOL; WINAPI ( 'SetConsoleTextAttribute' );


FUNCTION SetConsoleCtrlHandler ( HandlerRoutine : PHANDLER_ROUTINE;
                               Add : WINBOOL ) : WINBOOL; WINAPI ( 'SetConsoleCtrlHandler' );


FUNCTION GenerateConsoleCtrlEvent ( dwCtrlEvent : DWord;
                                  dwProcessGroupId : DWord ) : WINBOOL; WINAPI ( 'GenerateConsoleCtrlEvent' );


FUNCTION AllocConsole : WINBOOL; WINAPI ( 'AllocConsole' );


FUNCTION FreeConsole : WINBOOL; WINAPI ( 'FreeConsole' );


FUNCTION CreateConsoleScreenBuffer ( dwDesiredAccess : DWord;
                                   dwShareMode : DWord;
                                   CONST lpSecurityAttributes :  SECURITY_ATTRIBUTES;
                                   dwFlags : DWord;
                                   lpScreenBufferData : POINTER ) : THandle; WINAPI ( 'CreateConsoleScreenBuffer' );


FUNCTION GetConsoleCP : Word; WINAPI ( 'GetConsoleCP' );


FUNCTION SetConsoleCP ( wCodePageID : Word ) : WINBOOL; WINAPI ( 'SetConsoleCP' );


FUNCTION GetConsoleOutputCP : Word; WINAPI ( 'GetConsoleOutputCP' );


FUNCTION SetConsoleOutputCP ( wCodePageID : Word ) : WINBOOL; WINAPI ( 'SetConsoleOutputCP' );


FUNCTION WNetConnectionDialog ( wnd : HWND;
                              dwType : DWord ) : DWord; WINAPI ( 'WNetConnectionDialog' );


FUNCTION WNetDisconnectDialog ( wnd : HWND;
                              dwType : DWord ) : DWord; WINAPI ( 'WNetDisconnectDialog' );


FUNCTION WNetCloseEnum ( hEnum : THandle ) : DWord; WINAPI ( 'WNetCloseEnum' );


FUNCTION CloseServiceHandle ( hSCObject : SC_HANDLE ) : WINBOOL; WINAPI ( 'CloseServiceHandle' );


FUNCTION ControlService ( hService : SC_HANDLE;
                        dwControl : DWord;
                        lpServiceStatus : PSERVICE_STATUS ) : WINBOOL; WINAPI ( 'ControlService' );


FUNCTION DeleteService ( hService : SC_HANDLE ) : WINBOOL; WINAPI ( 'DeleteService' );


FUNCTION LockServiceDatabase ( hSCManager : SC_HANDLE ) : SC_LOCK; WINAPI ( 'LockServiceDatabase' );


FUNCTION NotifyBootConfigStatus ( BootAcceptable : WINBOOL ) : WINBOOL; WINAPI ( 'NotifyBootConfigStatus' );


FUNCTION QueryServiceObjectSecurity ( hService : SC_HANDLE;
                                    dwSecurityInformation : SECURITY_INFORMATION;
                                    VAR lpSecurityDescriptor : TSECURITY_DESCRIPTOR;
                                    cbBufSize : DWord;
                                    VAR pcbBytesNeeded : DWord ) : WINBOOL; WINAPI ( 'QueryServiceObjectSecurity' );


FUNCTION QueryServiceStatus ( hService : SC_HANDLE;
                            VAR lpServiceStatus : TSERVICE_STATUS ) : WINBOOL; WINAPI ( 'QueryServiceStatus' );


FUNCTION SetServiceObjectSecurity ( hService : SC_HANDLE;
                                  dwSecurityInformation : SECURITY_INFORMATION;
                                  VAR lpSecurityDescriptor : TSECURITY_DESCRIPTOR ) : WINBOOL; WINAPI ( 'SetServiceObjectSecurity' );



FUNCTION SetServiceStatus ( hServiceStatus : SERVICE_STATUS_HANDLE;
                          VAR lpServiceStatus : TSERVICE_STATUS ) : WINBOOL; WINAPI ( 'SetServiceStatus' );


FUNCTION UnlockServiceDatabase ( ScLock : SC_LOCK ) : WINBOOL; WINAPI ( 'UnlockServiceDatabase' );

{+// Extensions to OpenGL */ }


FUNCTION ChoosePixelFormat ( _1 : HDC;
                            CONST P : PIXELFORMATDESCRIPTOR ) : Integer; WINAPI ( 'ChoosePixelFormat' );


FUNCTION DescribePixelFormat ( _1 : HDC;
                             _2 : Integer;
                             _3 : Word;
                             VAR _4 : TPIXELFORMATDESCRIPTOR ) : Integer; WINAPI ( 'DescribePixelFormat' );


FUNCTION GetEnhMetaFilePixelFormat ( _1 : HENHMETAFILE;
                                   _2 : DWord;
                                   CONST P : PIXELFORMATDESCRIPTOR ) : Word; WINAPI ( 'GetEnhMetaFilePixelFormat' );


FUNCTION SetPixelFormat ( _1 : HDC;
                        _2 : Integer;
                         CONST P : PIXELFORMATDESCRIPTOR ) : WINBOOL; WINAPI ( 'SetPixelFormat' );


FUNCTION SwapBuffers ( _1 : HDC ) : WINBOOL; WINAPI ( 'SwapBuffers' );


FUNCTION wglCreateContext ( _1 : HDC ) : HGLRC; WINAPI ( 'wglCreateContext' );


FUNCTION wglCreateLayerContext ( _1 : HDC;
                               _2 : Integer ) : HGLRC; WINAPI ( 'wglCreateLayerContext' );


FUNCTION wglCopyContext ( _1 : HGLRC;
                        _2 : HGLRC;
                        _3 : Word ) : WINBOOL; WINAPI ( 'wglCopyContext' );


FUNCTION wglDeleteContext ( _1 : HGLRC ) : WINBOOL; WINAPI ( 'wglDeleteContext' );


FUNCTION wglDescribeLayerPlane ( _1 : HDC;
                               _2 : Integer;
                               _3 : Integer;
                               _4 : Word;
                               VAR _5 : TLAYERPLANEDESCRIPTOR ) : WINBOOL; WINAPI ( 'wglDescribeLayerPlane' );


FUNCTION wglGetCurrentContext : HGLRC; WINAPI ( 'wglGetCurrentContext' );


FUNCTION wglGetCurrentDC : HDC; WINAPI ( 'wglGetCurrentDC' );


FUNCTION wglGetLayerPaletteEntries ( _1 : HDC;
                                   _2 : Integer;
                                   _3 : Integer;
                                   _4 : Integer;
                                   CONST C : TColorRef ) : Integer; WINAPI ( 'wglGetLayerPaletteEntries' );


FUNCTION wglGetProcAddress ( _1 : PChar ) : PROC; WINAPI ( 'wglGetProcAddress' );


FUNCTION wglMakeCurrent ( _1 : HDC;
                        _2 : HGLRC ) : WINBOOL; WINAPI ( 'wglMakeCurrent' );


FUNCTION wglRealizeLayerPalette ( _1 : HDC;
                                _2 : Integer;
                                _3 : WINBOOL ) : WINBOOL; WINAPI ( 'wglRealizeLayerPalette' );


FUNCTION wglSetLayerPaletteEntries ( _1 : HDC;
                                   _2 : Integer;
                                   _3 : Integer;
                                   _4 : Integer;
                                   CONST  C : TColorRef ) : Integer; WINAPI ( 'wglSetLayerPaletteEntries' );


FUNCTION wglShareLists ( _1 : HGLRC;
                       _2 : HGLRC ) : WINBOOL; WINAPI ( 'wglShareLists' );


FUNCTION wglSwapLayerBuffers ( _1 : HDC;
                             _2 : Word ) : WINBOOL; WINAPI ( 'wglSwapLayerBuffers' );

{+// }
{-Why are these different between ANSI and UNICODE? }
{-There doesn't seem to be any difference. }
{= }

{$IFDEF UNICODE}
{
Const wglUseFontBitmaps = wglUseFontBitmapsW;
Const wglUseFontOutlines = wglUseFontOutlinesW;
}
{$ELSE}
{
Const wglUseFontBitmaps = wglUseFontBitmapsA;
Const wglUseFontOutlines = wglUseFontOutlinesA;
}
{$ENDIF /* !UNICODE */}

{+// ------------------------------------- */ }
{+// From shellapi.h in old Cygnus headers */ }


FUNCTION DragQueryPoint ( _1 : HDROP;
                        VAR _2 : TPOINT ) : WINBOOL; WINAPI ( 'DragQueryPoint' );


PROCEDURE DragFinish ( _1 : HDROP ); WINAPI ( 'DragFinish' );


PROCEDURE DragAcceptFiles ( _1 : HWND;
                          _2 : WINBOOL ); WINAPI ( 'DragAcceptFiles' );


FUNCTION DuplicateIcon ( _1 : THANDLE;
                       _2 : HICON ) : HICON; WINAPI ( 'DuplicateIcon' );

{+// end of stuff from shellapi.h in old Cygnus headers */ }
{+// -------------------------------------------------- */ }
{+// From ddeml.h in old Cygnus headers */ }


FUNCTION DdeConnect ( _1 : DWord;
                    _2 : HSZ;
                    _3 : HSZ;
                    VAR _4 : TCONVCONTEXT ) : HCONV; WINAPI ( 'DdeConnect' );

FUNCTION DdeDisconnect ( _1 : HCONV ) : WINBOOL; WINAPI ( 'DdeDisconnect' );

FUNCTION DdeFreeDataHandle ( _1 : HDDEDATA ) : WINBOOL; WINAPI ( 'DdeFreeDataHandle' );

FUNCTION DdeGetData ( _1 : HDDEDATA;
                    VAR B;
                    _3 : DWord;
                    _4 : DWord
                    ) :
                    DWord; WINAPI ( 'DdeGetData' );

FUNCTION DdeGetLastError ( _1 : DWord ) : Word; WINAPI ( 'DdeGetLastError' );

FUNCTION DdeNameService ( _1 : DWord;
                        _2 : HSZ;
                        _3 : HSZ;
                        _4 : Word ) : HDDEDATA; WINAPI ( 'DdeNameService' );

FUNCTION DdePostAdvise ( _1 : DWord;
                       _2 : HSZ;
                       _3 : HSZ ) : WINBOOL; WINAPI ( 'DdePostAdvise' );

FUNCTION DdeReconnect ( _1 : HCONV ) : HCONV; WINAPI ( 'DdeReconnect' );

FUNCTION DdeUninitialize ( _1 : DWord ) : WINBOOL; WINAPI ( 'DdeUninitialize' );

{+// end of stuff from ddeml.h in old Cygnus headers */ }
{+// ----------------------------------------------- */ }


FUNCTION NetUserEnum ( _1 : PWIDECHAR;
                     _2 : DWord;
                     _3 : DWord;
                     VAR B;
                     _5 : DWord;
                     VAR _6,
                     _7,
                     _8 : DWord ) : DWord; WINAPI ( 'NetUserEnum' );

FUNCTION NetApiBufferFree ( _1 : POINTER ) : DWord; WINAPI ( 'NetApiBufferFree' );

FUNCTION NetUserGetInfo ( _1 : PWIDECHAR;
                        _2 : PWIDECHAR;
                        _3 : DWord;
                        VAR B ) : DWord; WINAPI ( 'NetUserGetInfo' );

FUNCTION NetGetDCName ( _1 : PWIDECHAR;
                      _2 : PWIDECHAR;
                      VAR B ) : DWord; WINAPI ( 'NetGetDCName' );

FUNCTION NetGroupEnum ( _1 : PWIDECHAR;
                      _2 : DWord;
                      VAR B;
                      _4 : DWord;
                      VAR _5,
                      _6,
                      _7 : DWord ) : DWord; WINAPI ( 'NetGroupEnum' );


FUNCTION NetLocalGroupEnum ( _1 : PWIDECHAR;
                           _2 : DWord;
                           VAR B;
                           _4 : DWord;
                           VAR _5 : DWORD;
                           VAR _6 : DWORD;
                           VAR _7 : DWORD ) : DWord; WINAPI ( 'NetLocalGroupEnum' );


{///////////////////////////////////////}
{///////////////////////////////////////}


{$ifndef Windows_Inc}  // * * * * * *
{$if defined(IS_UNIT) or defined(WINDOWS_UNIT)}
IMPLEMENTATION
{$endif}{IS_UNIT}
{$endif Windows_Inc}  // * * * * * *

{///////////////////////////////////////}
{///////////////////////////////////////}

{ /// base.pas /// }
FUNCTION Declare_Handle ( CONST s ) : THandle;
BEGIN
   Declare_Handle := THandle ( s );
END;

FUNCTION GetBvalue ( i : integer ) : byte;
BEGIN
   GetBvalue := i SHR 16;
END;

FUNCTION GetGvalue ( i : integer ) : byte;
BEGIN
   GetGvalue := i SHR 8;
END;

FUNCTION GetRvalue ( i : integer ) : byte;
BEGIN
   GetRvalue := Byte ( i );
END;

FUNCTION RGB ( r, g, b : byte ) : dword;
BEGIN
   RGB := ( r OR g SHL 8 OR b SHL 16 );
END;

FUNCTION HiByte ( w : word ) : byte;
BEGIN
  HiByte := ( w SHR 8 ) AND $FF;
END;

FUNCTION LoByte ( w : word ) : byte;
BEGIN
  LoByte := Byte ( w );
END;

FUNCTION HiWord ( l : dword ) : word;
BEGIN
  HiWord := ( l SHR 16 ) AND $FFFF;
END;

FUNCTION LoWord ( l : dword ) : word;
BEGIN
  LoWord := Word ( l );
END;

FUNCTION MakeLong ( a, b : Word ) : dword;
BEGIN
   MakeLong := a OR b SHL 16;
END;

FUNCTION MakeWord ( a, b : byte ) : Word;
BEGIN
   MakeWord := a OR b SHL 8;
END;

FUNCTION MakeLParam ( a, b : Word ) : LParam32;
BEGIN
   MakeLParam := MakeLong ( a, b );
END;

FUNCTION MakeWParam ( a, b : Word ) : WParam32;
BEGIN
   MakeWParam := MakeLong ( a, b );
END;

FUNCTION MakeLResult ( a, b : Word ) : LResult;
BEGIN
   MakeLResult := MakeLong ( a, b );
END;

FUNCTION MakeRop4 ( fore, back : integer ) : dword;
BEGIN
  MakeRop4 := ( back SHL 8 ) AND $FF000000 OR fore;
END;

FUNCTION INDEXTOOVERLAYMASK ( i : integer ) : integer;
BEGIN
   INDEXTOOVERLAYMASK := i SHL 8;
END;

FUNCTION INDEXTOSTATEIMAGEMASK ( i : integer ) : integer;
BEGIN
   INDEXTOSTATEIMAGEMASK := i SHL 12;
END;

FUNCTION MAKEINTATOM ( i : integer ) : pChar;
BEGIN
   MAKEINTATOM := pChar ( i );
END;

FUNCTION MAKELANGID ( p, s : word ) : word;
BEGIN
  MAKELANGID := s SHL 10 OR p;
END;

FUNCTION PRIMARYLANGID ( algid : lgid ) : word ;
BEGIN
  PRIMARYLANGID := algid AND $3FF;
END;

FUNCTION SUBLANGID ( algid : lgid ) : word;
BEGIN
  SUBLANGID := algid SHR 10;
END;

FUNCTION LANGIDFROMLCID ( alcid : lcid ) : word;
BEGIN
   LANGIDFROMLCID := word ( alcid );
END;

FUNCTION SORTIDFROMLCID ( alcid : lcid ) : word;
BEGIN
  SORTIDFROMLCID := alcid AND $000FFFF SHR 16;
END;

FUNCTION MAKELCID ( algid, asrtid : lgid ) : dword;
BEGIN
   MAKELCID := ( asrtid SHL 16 ) OR algid;
END;

FUNCTION SEXT_HIWORD ( l : integer ) : integer;
BEGIN
  SEXT_HIWORD := l SHR 16;
END;

FUNCTION ZEXT_HIWORD ( l : word ) : integer;
BEGIN
  ZEXT_HIWORD := l SHR 16;
END;

FUNCTION SEXT_LOWORD ( l : SmallInt ) : integer;
BEGIN
  SEXT_LOWORD := integer ( l );
END;

{ // defines.pas //}
FUNCTION  _FreeLibrary ( h : THandle ) : WinBool; WINAPI ( 'FreeLibrary' );

FUNCTION FreeModule ( h : THandle ) : WinBool;
BEGIN
   FreeModule := _FreeLibrary ( h );
END;

FUNCTION MakeProcInstance ( TProc : TFARPROC; Instance : THandle ) : TFARPROC;
BEGIN
   MakeProcInstance := TProc;
END;

PROCEDURE FreeProcInstance ( Proc : TFarProc );
BEGIN
END;

FUNCTION CreateWindow ( lpClassName : PChar; lpWindowName : PChar;
  dwStyle : DWord; X, Y, nWidth, nHeight : DWord; hWndParent : hWnd;
  hMenu : hMenu; xInstance : THandle; lpParam : Pointer ) : hWnd;
BEGIN
  CreateWindow := CreateWindowEx ( 0, lpClassName, lpWindowName, dwStyle, X, Y,
    nWidth, nHeight, hWndParent, hMenu, xInstance, lpParam );
END;

FUNCTION DialogBox ( xInstance : THANDLE;
                     lpTemplateName : PChar;
                     hWndParent : HWND;
                     lpDialogFunc : DLGPROC ) : Integer;

BEGIN
   DialogBox := DialogBoxParam ( xInstance, lpTemplateName, hWndParent, lpDialogFunc, 0 );
END;

FUNCTION hInstance : THandle;
BEGIN
  hInstance := GetModuleHandle ( NIL );
END;

FUNCTION MainInstance : THandle;
BEGIN
  MainInstance := hInstance;
END;

PROCEDURE ZeroMemory ( Destination : Pointer; Length : DWord );
BEGIN
  FillChar ( pchar ( Destination ) ^, Length, 0 );
END;

{///////////////////////////////////////}
{///////////////////////////////////////}

{
!!! link these libraries -
      else you might have to link them manually in your programs
!!!
}

  {$l gdi32}
  {$l comctl32}
  {$l comdlg32}

{ other libs that can be linked }
(*
{$ifndef IS_UNIT}
{$l cap}
{$l ctl3d32}
{$l dlcapi}
{$l glaux}
{$l glu32}
{$l history}
{$l icmp}
{$l imm32}
{$l largeint}
{$l lz32}
{$l mapi32}
{$l mgmtapi}
{$l mpr}
{$l msacm32}
{$l nddeapi}
{$l netapi32}
{$l odbc32}
{$l odbccp32}
{$l ole32}
{$l oleaut32}
{$l oledlg}
{$l olepro32}

{$ifndef Ansi_GPC__}
FUNTION GetActiveWindow : HWND; WINAPI ( 'GetActiveWindow' );
FUNCTION GetFocus : HWND; WINAPI ( 'GetFocus' );
FUNCTION GetKBCodePage : Word; WINAPI ( 'GetKBCodePage' );
FUNCTION GetKeyState ( nVirtKey : Integer ) : SmallInt; WINAPI ( 'GetKeyState' );
{$l opengl32}
{$endif}{IS_UNIT}
*)

{$ifndef Windows_Inc}
{$if defined(IS_UNIT) or defined(WINDOWS_UNIT)}
END.
{$endif}{IS_UNIT, etc.}
{$endif Windows_Inc}

{///////////////////////////////////////}
{///////////////////////////////////////}
{$endif WINPROCS_PAS}

