{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                         PSAPI.PAS                                        }
{                                                                          }
{                   WIN32 API IMPORT UNIT FOR GPC                          }
{                                                                          }
{ Copyright (C) 2005 Free Software Foundation, Inc.                        }
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
{  v1.00, Oct.  2005 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}
{$R-}

unit psapi;

interface
  {$define Stdcall attribute(stdcall)}
  {$define WINAPI(X) external name X; Stdcall}

uses
Windows;

{$W-}
{$X+}

{+// }
{-psapi.h - Include file for PSAPI.DLL APIs }

{-Written by Mumit Khan <khan@nanotech.wisc.edu> }

{-This file is part of a free library for the Win32 API. }

{-NOTE: This strictly does not belong in the Win32 API since it's }
{-really part of Platform SDK. However,GDB needs it and we might }
{-as well provide it here. }

{-This library is distributed in the hope that it will be useful, }
{-but WITHOUT ANY WARRANTY; without even the implied warranty of }
{-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. }

type
  TMODULEINFO = record
    lpBaseOfDll: Pointer;
    SizeOfImage: DWord;
    EntryPoint: Pointer;
  end {TMODULEINFO};
  LPMODULEINFO = ^TMODULEINFO;

type
  TPSAPI_WS_WATCH_INFORMATION = record
    FaultingPc: Pointer;
    FaultingVa: Pointer;
  end {TPSAPI_WS_WATCH_INFORMATION};
  PPSAPI_WS_WATCH_INFORMATION = ^TPSAPI_WS_WATCH_INFORMATION;

type
  TPROCESS_MEMORY_COUNTERS = record
    cb: DWord;
    PageFaultCount: DWord;
    PeakWorkingSetSize: DWord;
    WorkingSetSize: DWord;
    QuotaPeakPagedPoolUsage: DWord;
    QuotaPagedPoolUsage: DWord;
    QuotaPeakNonPagedPoolUsage: DWord;
    QuotaNonPagedPoolUsage: DWord;
    PagefileUsage: DWord;
    PeakPagefileUsage: DWord;
  end {TPROCESS_MEMORY_COUNTERS};
  PPROCESS_MEMORY_COUNTERS = ^TPROCESS_MEMORY_COUNTERS;

{+// Grouped by application,not in alphabetical order.*/ }

function EnumProcesses (var _1: DWord;
                       _2: DWord;
                       var _3: DWord): WinBool; WINAPI ( 'EnumProcesses' );

function EnumProcessModules (_1: THandle;
                            var _2: HMODULE;
                            _3: DWord;
                            var _4: DWord): WinBool; WINAPI ( 'EnumProcessModules' );

function GetModuleBaseNameA (_1: THandle;
                            _2: HMODULE;
                            _3: PChar;
                            _4: DWord): DWord; WINAPI ( 'GetModuleBaseNameA' );
function GetModuleBaseName (_1: THandle;
                            _2: HMODULE;
                            _3: PChar;
                            _4: DWord): DWord; WINAPI ( 'GetModuleBaseNameA' );

function GetModuleBaseNameW (_1: THandle;
                            _2: HMODULE;
                            var _3: WideChar;
                            _4: DWord): DWord; WINAPI ( 'GetModuleBaseNameW' );

function GetModuleFileNameExA (_1: THandle;
                              _2: HMODULE;
                              _3: PChar;
                              _4: DWord): DWord; WINAPI ( 'GetModuleFileNameExA' );
function GetModuleFileNameEx (_1: THandle;
                              _2: HMODULE;
                              _3: PChar;
                              _4: DWord): DWord; WINAPI ( 'GetModuleFileNameExA' );

function GetModuleFileNameExW (_1: THandle;
                              _2: HMODULE;
                              var _3: WideChar;
                              _4: DWord): DWord; WINAPI ( 'GetModuleFileNameExW' );

function GetModuleInformation (_1: THandle;
                              _2: HMODULE;
                              var _3: TMODULEINFO;
                              _4: DWord): WinBool; WINAPI ( 'GetModuleInformation' );

function EmptyWorkingSet (_1: THandle): WinBool; WINAPI ( 'EmptyWorkingSet' );

function QueryWorkingSet (_1: THandle;
                         _2: Pointer;
                         _3: DWord): WinBool; WINAPI ( 'QueryWorkingSet' );

function InitializeProcessForWsWatch (_1: THandle): WinBool; WINAPI ( 'InitializeProcessForWsWatch' );

function GetWsChanges (_1: THandle;
                      var _2: TPSAPI_WS_WATCH_INFORMATION;
                      _3: DWord): WinBool; WINAPI ( 'GetWsChanges' );

function GetMappedFileNameW (_1: THandle;
                            _2: Pointer;
                            var _3: WideChar;
                            _4: DWord): DWord; WINAPI ( 'GetMappedFileNameW' );

function GetMappedFileNameA (_1: THandle;
                            _2: Pointer;
                            _3: PChar;
                            _4: DWord): DWord; WINAPI ( 'GetMappedFileNameA' );
function GetMappedFileName (_1: THandle;
                            _2: Pointer;
                            _3: PChar;
                            _4: DWord): DWord; WINAPI ( 'GetMappedFileNameA' );

function EnumDeviceDrivers (_1: Pointer;
                           _2: DWord;
                           var _3: DWord): WinBool; WINAPI ( 'EnumDeviceDrivers' );

function GetDeviceDriverBaseNameA (_1: Pointer;
                                  _2: PChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverBaseNameA' );
function GetDeviceDriverBaseName (_1: Pointer;
                                  _2: PChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverBaseNameA' );

function GetDeviceDriverBaseNameW (_1: Pointer;
                                  var _2: WideChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverBaseNameW' );

function GetDeviceDriverFileNameA (_1: Pointer;
                                  _2: PChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverFileNameA' );
function GetDeviceDriverFileName (_1: Pointer;
                                  _2: PChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverFileNameA' );

function GetDeviceDriverFileNameW (_1: Pointer;
                                  var _2: WideChar;
                                  _3: DWord): DWord; WINAPI ( 'GetDeviceDriverFileNameW' );

function GetProcessMemoryInfo (_1: THandle;
                              var _2: TPROCESS_MEMORY_COUNTERS;
                              _3: DWord): WinBool; WINAPI ( 'GetProcessMemoryInfo' );

implementation
 {$l psapi}
end.

