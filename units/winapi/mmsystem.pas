{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                         MMYSYSTEM.PAS                                    }
{                                                                          }
{                   WIN32 API IMPORT UNIT FOR GPC                          }
{                                                                          }
{         *** This is just a beginning - most things are missing!!!! ***   }
{                                                                          }
{ Copyright (C) 2007 Free Software Foundation, Inc.                        }
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
{  v1.00, Feb.  2007 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}
{$R-}
{$X+}

UNIT mmsystem;

INTERFACE

USES wintypes;

  {$define Stdcall attribute(stdcall)}
  {$define WINAPI(X) external name X; Stdcall}
  {.$define WINAPI(X) asmname X; Stdcall}
  {$X+}
  {$W-}

TYPE
MMRESULT = UINT;

{ types for wType field in MMTIME struct }
CONST
  TIME_MS         = $0001;  { time in milliseconds }
  TIME_SAMPLES    = $0002;  { number of wave samples }
  TIME_BYTES      = $0004;  { current byte offset }
  TIME_SMPTE      = $0008;  { SMPTE time }
  TIME_MIDI       = $0010;  { MIDI time }
  TIME_TICKS      = $0020;  { Ticks within MIDI stream }

{ MMTIME data structure }
TYPE
  PMMTime = ^TMMTime;
  TMMTime = RECORD
    CASE wType : UINT OF        { indicates the contents of the variant record }
     TIME_MS :      ( ms : DWORD );
     TIME_SAMPLES : ( sample : DWORD );
     TIME_BYTES :   ( cb : DWORD );
     TIME_TICKS :   ( ticks : DWORD );
     TIME_SMPTE : ( 
        hour : Byte;
        min : Byte;
        sec : Byte;
        frame : Byte;
        fps : Byte;
        dummy : Byte;
        pad : ARRAY [0..1] OF Byte );
      TIME_MIDI : ( songptrpos : DWORD );
  END;

TYPE
  TFNTimeCallBack = PROCEDURE ( uTimerID, uMessage : UINT; dwUser, dw1, dw2 : DWORD );

{ timer device capabilities data structure }
TYPE
  PTimeCaps = ^TTimeCaps;
  TTimeCaps = RECORD
    wPeriodMin : UINT;     { minimum period supported  }
    wPeriodMax : UINT;     { maximum period supported  }
  END;

FUNCTION timeGetTime : DWord; WINAPI ( 'timeGetTime' );

FUNCTION timeGetSystemTime ( lpTime : PMMTime; uSize : Word ) : MMRESULT;
WINAPI ( 'timeGetSystemTime' );

FUNCTION timeSetEvent ( uDelay, uResolution : UINT;
  lpFunction : TFNTimeCallBack; dwUser : DWORD; uFlags : UINT ) : MMRESULT;
WINAPI ( 'timeSetEvent' );

FUNCTION timeKillEvent ( uTimerID : UINT ) : MMRESULT;
WINAPI ( 'timeKillEvent' );

FUNCTION timeGetDevCaps ( lpTimeCaps : PTimeCaps; uSize : UINT ) : MMRESULT;
WINAPI ( 'timeGetDevCaps' );

FUNCTION timeBeginPeriod ( uPeriod : UINT ) : MMRESULT;
WINAPI ( 'timeBeginPeriod' );

FUNCTION timeEndPeriod ( uPeriod : UINT ) : MMRESULT;
WINAPI ( 'timeEndPeriod' );

{ --------------------------------------------- }
FUNCTION sndPlaySoundA ( lpszSoundName : PAnsiChar; uFlags : UINT ) : BOOL;
WINAPI ( 'sndPlaySoundA' );

FUNCTION sndPlaySoundW ( lpszSoundName : PWideChar; uFlags : UINT ) : BOOL;
WINAPI ( 'sndPlaySoundW' );

FUNCTION sndPlaySound ( lpszSoundName : PChar; uFlags : UINT ) : BOOL;
WINAPI ( 'sndPlaySoundA' );

{ flag values for wFlags parameter }
CONST
  SND_SYNC            = $0000;  { play synchronously (default) }
  SND_ASYNC           = $0001;  { play asynchronously }
  SND_NODEFAULT       = $0002;  { don't use default sound }
  SND_MEMORY          = $0004;  { lpszSoundName points to a memory file }
  SND_LOOP            = $0008;  { loop the sound until next sndPlaySound }
  SND_NOSTOP          = $0010;  { don't stop any currently playing sound }

  SND_NOWAIT          = $00002000;  { don't wait if the driver is busy }
  SND_ALIAS           = $00010000;  { name is a registry alias }
  SND_ALIAS_ID        = $00110000;  { alias is a predefined ID }
  SND_FILENAME        = $00020000;  { name is file name }
  SND_RESOURCE        = $00040004;  { name is resource name or atom }
  SND_PURGE           = $0040;      { purge non-static events for task }
  SND_APPLICATION     = $0080;      { look for application specific association }

  SND_ALIAS_START     = 0;   { alias base }

  SND_ALIAS_SYSTEMASTERISK       = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( '*' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMQUESTION       = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( '?' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMHAND           = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( 'H' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMEXIT           = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( 'E' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMSTART          = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( 'S' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMWELCOME        = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( 'W' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMEXCLAMATION    = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( '!' ) ) SHL 8 ) );
  SND_ALIAS_SYSTEMDEFAULT        = SND_ALIAS_START + ( Longint ( Ord ( 'S' ) ) OR ( Longint ( Ord ( 'D' ) ) SHL 8 ) );

FUNCTION PlaySoundA ( pszSound : PAnsiChar; hmod : HMODULE; fdwSound : DWORD ) : BOOL;
WINAPI ( 'PlaySoundA' );

FUNCTION PlaySoundW ( pszSound : PWideChar; hmod : HMODULE; fdwSound : DWORD ) : BOOL;
WINAPI ( 'PlaySoundW' );

FUNCTION PlaySound ( pszSound : PChar; hmod : HMODULE; fdwSound : DWORD ) : BOOL;
WINAPI ( 'PlaySoundA' );

IMPLEMENTATION

  {$l winmm}

END.

