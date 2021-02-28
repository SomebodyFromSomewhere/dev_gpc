{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                         TIMING.PAS                                       }
{                                                                          }
{                   ROUGH TIMING UNIT FOR GPC-WIN32                        }
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

UNIT timing;

INTERFACE

TYPE
TimingWord =
{$ifdef __GPC__}Cardinal attribute ( size = 64 ) {$else}LongWord{$endif};

TimingLong =
{$ifdef __GPC__}Integer attribute ( size = 64 ) {$else}Int64{$endif};

FUNCTION OneMicroSecond : TimingWord;
FUNCTION OneMilliSecond : TimingWord;
FUNCTION OneSecond : TimingWord;
FUNCTION OneMinute : TimingWord;
FUNCTION OneHour : TimingWord;

FUNCTION GetTimingCounter : TimingLong;

FUNCTION GetTimingMicroSecond : TimingLong;
FUNCTION GetTimingMilliSecond : TimingLong;
FUNCTION GetTimingSecond : TimingLong;

FUNCTION ToMicroSecond ( CONST Freq : TimingLong ) : TimingWord;
FUNCTION ToMilliSecond ( CONST Freq : TimingLong ) : TimingWord;
FUNCTION ToSecond ( CONST Freq : TimingLong ) : TimingWord;

{ floats }
FUNCTION FGetTimingMicroSecond : Double;
FUNCTION FGetTimingMilliSecond : Double;
FUNCTION FGetTimingSecond : Double;

IMPLEMENTATION

USES
Windows, MMSystem;

VAR Frequency : Large_Integer;

FUNCTION OneSecond : TimingWord;
BEGIN
   Result := Frequency.QuadPart;
END;

FUNCTION OneMilliSecond : TimingWord;
BEGIN
   Result := OneSecond Div 1000;
END;

FUNCTION OneMicroSecond : TimingWord;
BEGIN
   Result := OneMilliSecond Div 1000;
END;

FUNCTION OneMinute : TimingWord;
BEGIN
   Result := OneSecond * 60;
END;

FUNCTION OneHour : TimingWord;
BEGIN
   Result := OneMinute * 60;
END;

FUNCTION ToMicroSecond ( CONST Freq : TimingLong ) : TimingWord;
BEGIN
   Result := Freq Div OneMicroSecond;
END;

FUNCTION ToMilliSecond ( CONST Freq : TimingLong ) : TimingWord;
BEGIN
   Result := Freq Div OneMilliSecond;
END;

FUNCTION ToSecond ( CONST Freq : TimingLong ) : TimingWord;
BEGIN
   Result := Freq Div OneSecond;
END;

FUNCTION GetTimingCounter : TimingLong;
VAR
LG : Large_integer;
BEGIN
  IF QueryPerformanceCounter ( LG ) THEN ;
  Result := LG.QuadPart;
END;

FUNCTION GetTimingMicroSecond : TimingLong;
BEGIN
  Result := GetTimingCounter Div OneMicroSecond;
END;

FUNCTION GetTimingMilliSecond : TimingLong;
BEGIN
  Result := GetTimingCounter Div OneMilliSecond;
END;

FUNCTION GetTimingSecond : TimingLong;
BEGIN
  Result := GetTimingCounter Div OneSecond;
END;

{ floats }
FUNCTION FGetTimingMicroSecond; // : TimingLong;
BEGIN
  Result := GetTimingCounter / OneMicroSecond;
END;

FUNCTION FGetTimingMilliSecond; // : TimingLong;
BEGIN
  Result := GetTimingCounter / OneMilliSecond;
END;

FUNCTION FGetTimingSecond; // : TimingLong;
BEGIN
  Result := GetTimingCounter / OneSecond;
END;


Initialization
  IF QueryPerformanceFrequency ( Frequency ) THEN {};
END.

