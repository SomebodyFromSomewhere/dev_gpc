{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{        Portable DELPHI(tm) Compatible SYSUTILS UNIT FOR GPC              }
{                       !! INCOMPLETE !!                                   }
{                                                                          }
{    Copyright (C) 1997-2007 Free Software Foundation, Inc.                }
{                                                                          }
{    This file part of GNU Pascal.                                         }
{                                                                          }
{    Authors:                                                              }
{       Prof Abimbola A Olowofoyeku <chiefsoft at bigfoot dot com>         }
{       Frank Heckenbach <frank@pascal.gnu.de>                             }
{                                                                          }
{    NOTE - SOME OF THE ROUTINES IN THIS UNIT MAY NOT WORK CORRECTLY,      }
{    AND THERE ARE FUDGES: SO TEST EACH ROUTINE CAREFULLY !!!              }
{    Some things are missing, and there are some extras!                   }
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
{    Updated: 10 August 2007, Prof. A Olowofoyeku (The African Chief)      }
{                                                                          }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}

{$if __GPC_RELEASE__ < 20050331}
{$error This unit requires GPC release 20050331 or newer.}
{$endif}

UNIT sysutils;

Interface
{$R-}
{$implicit-result}

Uses
GPC,
System;

{  * @@
   * under Cygwin/Mingw, if you don't want to use WinAPI routines but
   * you rather want to use the same routines as the other GPC versions,
   * then UNdefine "UseW32API" below
   * @@
}
{$ifdef _WIN32}
     {$define UseW32API}  { @@ defined by default under Cygwin/Mingw32 }
{$endif}

{$X+}
{$I-}
{$B-}
{$W-}

CONST
SysError = - 1;
SingleQuote = '''';
DoubleQuote = '"';


{ data types }
TYPE
Word16 = Cardinal attribute ( Size=16 );
Word32 = Cardinal attribute ( Size=32 );
{
Int64  = Integer  attribute ( Size=64 );
}
Word64 = Cardinal attribute ( Size=64 );

Int16  = Integer  attribute ( Size=16 );
Int32  = Integer  attribute ( Size=32 );

Byte8  = Cardinal attribute ( Size=8 );

TDosAttr = {$ifdef UseW32API}Int32{$else}Word{$endif};

GPC_AnyFile = {Internal_GPC_}AnyFile; { in order to have AnyFile parameters, while
                           AnyFile is redefined below }

TProcedure = PROCEDURE;

CONST
{ invalid file handle }
  NoFileHandle = SysError;
  BadFileHandle = NoFileHandle;

{ Days between 1/1/0001 and 12/31/1899 }
  DateDelta = 693594;

{ 1/1/0001 is the last "good" date - any earlier date is "bad" }
  LastGoodDate = - 693593;

{ Days from 1900-01-01 to 1970-01-01 }
  DateTimeUnixTimeDelta = 25569;

{ Seconds and milliseconds per min/hour/day }
  SecsPerMin  = 60;
  SecsPerHour = SecsPerMin * 60;
  SecsPerDay  = SecsPerHour * 24;
  MSecsPerSec = 1000;
  MSecsPerMin = SecsPerMin * MSecsPerSec;
  MSecsPerDay = SecsPerDay * MSecsPerSec;

{ pointer to empty string }
  EmptyStr = '';
  NullStr : PString = @EmptyStr;

{ for comparing values }
  LessThanValue = - 1;
  EqualsValue = 0;
  GreaterThanValue = 1;

{ for comparing values }
TYPE
TValueRelationship = LessThanValue .. GreaterThanValue;

{ Date/Time formatting variables }
TYPE
DTFormatStr = String [128];  { arbitrary length - should be long enough }

VAR
DateSeparator : Char = '/';          { separates different parts of date }
TimeSeparator : Char = ':';          { separates different parts of time }
TimeAMString  : DTFormatStr = 'am';
TimePMString  : DTFormatStr = 'pm';

LongTimeFormat  : DTFormatStr = 'hh:mm:ss';
ShortTimeFormat : DTFormatStr = 'h:mm';

ShortDateFormat : DTFormatStr = 'dd/mm/yy';
LongDateFormat  : DTFormatStr = 'dddd, dd MMMM yyyy';

ShortMonthNames : ARRAY [1..12] OF DTFormatStr =
( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' );

LongMonthNames : ARRAY [1..12] OF DTFormatStr =
( 'January', 'February', 'March', 'April', 'May', 'June', 'July',
'August', 'September', 'October', 'November', 'December' );

ShortDayNames : ARRAY [1..7] OF DTFormatStr =
( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' );

LongDayNames : ARRAY [1..7] OF DTFormatStr =
( 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' );

{++++++++++++ borrowed from FPC ++++++++++++++++++++++++}
{* these next two should be locale-specific *}
DecimalSeparator : Char = '.';

ThousandSeparator : Char = ',';

{
  All the variables presented here must be set by the InitInternational
  routine. They must be set to match the 'local' settings, although
  most have an initial value.

  These routines are OS-dependent.
}

  { Number of decimals to use when formatting a currency.  }
  CurrencyDecimals : Byte = 2;

  { Format to use when formatting currency :
    0 = $1
    1 = 1$
    2 = $ 1
    3 = 1 $
    4 = Currency string replaces decimal indicator. e.g. 1$50
   }
  CurrencyFormat : Byte = 1;

  { Same as above, only for negative currencies:
    0 = ($1)
    1 = -$1
    2 = $-1
    3 = $1-
    4 = (1$)
    5 = -1$
    6 = 1-$
    7 = 1$-
    8 = -1 $
    9 = -$ 1
    10 = $ 1-
   }
  NegCurrFormat : Byte = 5;

  { Currency notation. Default is $ for dollars. }
  CurrencyString : String[7] = '$';
{++++++++++++ end: borrowed from FPC ++++++++++++++++++++++++}

{ Date and time record }
TYPE
TTimeStamp = RECORD
    Time : Int32;      { Number of milliseconds since midnight }
    Date : Int32;      { One plus number of days since 1/1/0001 }
END;{ TTimeStamp }

TYPE
TFileHandle = PtrInt; { Integer of the same size as a pointer }
HandleFType = File;
PFile       = ^HandleFType;
TSysCharSet = Set OF Char;

LongRec = PACKED RECORD
{$ifdef __BYTES_BIG_ENDIAN__}
  Hi, Lo : Word16;
{$else}
  Lo, Hi : Word16;
{$endif}
END { LongRec };

WordRec = PACKED RECORD
{$ifdef __BYTES_BIG_ENDIAN__}
  Hi, Lo : Byte;
{$else}
  Lo, Hi : Byte;
{$endif}
END { WordRec };

{  date / time stuff  }
TDateTime = Double;

{ @@ not in Delphi }
TDateTimeRec = RECORD
   Date,
   Time : TDateTime;
END;

{$ifdef __OS_DOS__}
   {.$define __BP_TYPE_SIZES__} { dos platforms: affects sizes of things }
{$endif}

TFileName = {$ifdef __BP_TYPE_SIZES__}String ( 260 ) {$else}TString{$endif};

TFloatFormat = ( ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency );
TFloatValue  = ( fvExtended, fvCurrency );

TFileRec = RECORD
  Handle,
  Mode     : Integer;
  RecSize  : Word32;
  wPRIVATE : ARRAY [1..28] OF Byte;    { @@ 'private' in BP, Delphi, etc }
  UserData : ARRAY [1..32] OF Byte;
  Name     : ARRAY [0..259] OF Char;
END{ TFileRec };

TFloatRec = RECORD
  Exponent : Int16;
  Negative : Boolean;
  Digits   : ARRAY [0..20] OF Char;
END{ TFloatRec };

THeapStatus = RECORD
   TotalAddrSpace,
   TotalUncommitted,
   TotalCommitted,
   TotalAllocated,
   TotalFree,
   FreeSmall,
   FreeBig,
   Unused,
   Overhead,
   HeapErrorCode : Word32;
END { THeapStatus };

TMethod = RECORD
  Code,
  Data : Pointer;
END{ TMethod };


TYPE TSYSTEMTIME = RECORD
     wYear,
     wMonth,
     wDayOfWeek,
     wDay,
     wHour,
     wMinute,
     wSecond,
     wMilliseconds : Word16;
END { TSYSTEMTIME };

TYPE TFILETIME = RECORD
     dwLowDateTime,
     dwHighDateTime : Int32;
END { TFILETIME };
PFILETIME = ^TFILETIME;

TYPE
  { Search record used by FindFirst and FindNext }
  SearchRecFill = PACKED ARRAY [1..21] OF Byte8;
  SearchRec = {$ifdef __BP_TYPE_SIZES__} PACKED {$endif} RECORD
                Fill : SearchRecFill;
                Attr : Byte8;
                Time : Int32;
                {$ifdef __BP_TYPE_SIZES__}
                Size : Int32;
                Name : String [12]
                {$else}
                Size : LongInt;
                Name : TString;
                {$endif}
  END; { SearchRec }

{ @@ Date and time record used by PackFileDate and UnPackFileDate;
 * Use to unpack dates from FindFirst/FindNext }
DateTime = RECORD
  Year, Month, Day, Hour, Min, Sec : Word16
END; { DateTime }


{ WIN32 platform: valid values start from zero }
VAR Win32Platform : Integer = {$ifdef UseW32API} 0 {$else} SysError {$endif};

TYPE TWin32FindData = RECORD
     dwFileAttributes : Int32;
     ftCreationTime,
     ftLastAccessTime,
     ftLastWriteTime : TFILETIME;
     nFileSizeHigh,
     nFileSizeLow,
     dwReserved0,
     dwReserved1 : Int32;
     CFILENAME :  {$ifdef __BP_TYPE_SIZES__}ARRAY [0..259] OF CHAR {$else} TStringBuf {$endif};
     CALTERNATEFILENAME : {$ifdef __OS_DOS__}ARRAY [0..13] OF CHAR {$else} TStringBuf {$endif};
END { TWin32FindData };

{ @@ our very own unique TSearchRec fudge @@  }
TSearchRec = RECORD
  Time : Int32;
  Size : Int32;
  Attr : Int32;
  Name : TFileName;
  ExcludeAttr,                  { @@ Delphi compatibility @@ }
  FindHandle : Int32;           {  -- ditto -- }
  FindData   : TWin32FindData;  {  -- ditto -- }
  DosData    : SearchRec;       { @@ private (unique to GPC) field @@ }
END { TSearchRec };

{ ********* File/Directory searching routines ********* }

{ name clashes with DOS unit }
FUNCTION  FindFirst ( CONST Path : string; Attr : Integer; VAR SR : TSearchRec ) : Integer;

FUNCTION  FindNext ( VAR SR : TSearchRec ) : Integer;

PROCEDURE FindClose ( VAR SR : TSearchRec );

{ ********* date/time routines ********* }

{ current date and time }
FUNCTION  Now : TDateTime;
{$ifdef UseW32API}
FUNCTION Now2 : TDateTime;
{$endif}

{ current date }
FUNCTION  Date : TDateTime;

{ current time }
FUNCTION  Time : TDateTime;

{ day of week: 1 = Sunday; 7 = Saturday }
FUNCTION  DayOfWeek ( Date : TDateTime ) : Integer;

{ encoding/decoding dates/times }
PROCEDURE DecodeTime ( Time : TDateTime; VAR Hour, Min, Sec, MSec : Word16 );
FUNCTION  EncodeTime ( Hour, Min, Sec, MSec : Word ) : TDateTime;
PROCEDURE DecodeDate ( Date : TDateTime; VAR Year, Month, Day : Word16 );
FUNCTION  EncodeDate ( Year, Month, Day : Word ) : TDateTime;

{ converting dates and times }
FUNCTION  DateTimeToTimeStamp ( DateTime : TDateTime ) : TTimeStamp;
FUNCTION  TimeStampToDateTime ( CONST TimeStamp : TTimeStamp ) : TDateTime;
FUNCTION  MSecsToTimeStamp ( MSecs : Comp ) : TTimeStamp;
FUNCTION  TimeStampToMSecs ( CONST TimeStamp : TTimeStamp ) : Comp;

FUNCTION  FileDateToDateTime ( DosDateTime : Longint ) : TDateTime;
FUNCTION  DateTimeToFileDate ( MyDateTime : TDateTime ) : Int32;

{ not in Delphi v2 }
FUNCTION  SystemTimeToDateTime ( CONST SystemTime : TSystemTime ) : TDateTime;

{ not in Delphi v2 }
PROCEDURE DateTimeToSystemTime ( DateTime : TDateTime; VAR STime : TSystemTime );

{ not in Delphi }
FUNCTION TDateTimeToUnixTime ( DateTime : TDateTime ) : UnixTimeType;

{ not in Delphi }
FUNCTION UnixTimeToTDateTime ( DateTime : UnixTimeType ) : TDateTime;

{ @@ unpack a Dos file date/time into its component parts : not in Delphi!! }
PROCEDURE UnPackFileDate ( P : Longint; VAR T : DateTime );

{ @@ pack date/time components into a Dos filetime }
PROCEDURE PackFileDate ( CONST T : DateTime; VAR P : Longint );

{ @@ encode a packed dos time into two TDateTimes - Date + Time }
FUNCTION  LongtoDateTimeRec ( i : Longint ) : TDateTimeRec;

{ @@ decode and pack two TDateTimes into a dos time format }
FUNCTION  DateTimeRecToLong ( DT : TDateTimeRec ) : Integer;

{ @@ convert a filedate to a string, using the current values of
  the date/time formatting variables }
FUNCTION  FileDateToStr ( FTime : Longint ) : TString;

FUNCTION CompareDateTime ( CONST A, B : TDateTime ) : TValueRelationship;

FUNCTION CompareDate ( CONST A, B : TDateTime ) : TValueRelationship;

FUNCTION CompareTime ( CONST A, B : TDateTime ) : TValueRelationship;

FUNCTION SameDate ( CONST A, B : TDateTime ) : Boolean;

FUNCTION SameTime ( CONST A, B : TDateTime ) : Boolean;

FUNCTION SameDateTime ( CONST A, B : TDateTime ) : Boolean;

FUNCTION LastDelimiter ( CONST Delimiters, S : string ) : Integer;

FUNCTION IsPathDelimiter ( CONST S : string; Index : Integer ) : Boolean;

FUNCTION IsDelimiter ( CONST Delimiters, S : string; Index : Integer ) : Boolean;


{ converting and formatting dates/times to strings }
FUNCTION  TimeToStr ( Time : TDateTime ) : TString;
FUNCTION  DateToStr ( Date : TDateTime ) : TString;
FUNCTION  DateTimeToStr ( DateTime : TDateTime ) : TString;
FUNCTION  FormatDateTime ( CONST Format : string; DateTime : TDateTime ) : TString;
FUNCTION  FormatDate ( Format : String; Date : TDateTime ) : TString;
function  StrToTime ( const S: string ): TDateTime;
function  StrToDateTime ( const S: string ): TDateTime;
function  StrToDate ( const S: string ): TDateTime;
FUNCTION  FormatTime ( Format : String; Time : TDateTime ) : TString;

{@@ String pointer array functions @@}
Function  TokenizeString ( Const Source : String; VAR Dest : TPStrings; Tokens : CharSet ) : Integer;
Procedure AssignPPStrings ( Var p : TPStrings; Size : Longint );
Procedure ClearPPStrings ( Var p : TPStrings );
Procedure FreePPStrings ( Var p : TPStrings );


{ other stuff }

TYPE
TTextBuf = ARRAY [0..128] OF Char;
TTextRec = RECORD
  Handle,
  Mode : Int32;
  BufSize,
  BufPos,
  BufEnd : Word32;
  BufPtr : PChar;
  OpenFunc,
  InOutFunc,
  FlushFunc,
  CloseFunc : Pointer;
  UserData : ARRAY [1..32] OF Byte;
  Name : ARRAY [0..259] OF Char;
  Buffer : TTextBuf;
END { TTextRec };

{ file attribute constants }
CONST
faNormal      = $00;
faReadOnly    = $01;
faHidden      = $02;
faSysFile     = $04;
faVolumeID    = $08;
faDirectory   = $10;
faArchive     = $20;
faAnyFile     = $3F;

{ file access modes }
CONST
fmOpenRead       = $0000;
fmOpenWrite      = $0001;
fmOpenReadWrite  = $0002;
fmShareCompat    = $0000;
fmShareExclusive = $0010;
fmShareDenyWrite = $0020;
fmShareDenyRead  = $0030;
fmShareDenyNone  = $0040;


{ ******* string routines ********* }
{ is the string "S" a valid Pascal identifier? }
FUNCTION IsValidIdent ( CONST s : string ) : Boolean;

{ adjust all line breaks in "S" to true CR/LF sequences }
FUNCTION AdjustLinesBreaks ( CONST S : string ) : Tstring;

{ ******* Pascal string routines ******* }

{ Add single quote to beginning and end of S and repeat any single
  quote found within S }
FUNCTION QuotedStr ( S : string ) : TString;

{ Return whether the specified string was passed at the command line.
  * SwitchChars identifies valid argument-delimiter characters.
  * IgnoreCase specifies whether a case-sensitive or case-insensitive
    search is performed.
}
FUNCTION FindCmdLineSwitch ( CONST Switch : String; SwitchChars :
TSysCharSet; IgnoreCase : Boolean ) : Boolean;

{ @@ name clashes with GPC.PAS }
{ return a string stripped of leading spaces }
{@@}FUNCTION  wTrimLeft ( CONST s : String ) : TString;

{ return a string stripped of trailing spaces }
{@@}FUNCTION  wTrimRight ( CONST s : String ) : TString;

{ return a string stripped of leading and trailing spaces }
FUNCTION  Trim ( CONST s : String ) : TString;

{ allocate memory for a string pointer and assign a value to it}
PROCEDURE AssignStr ( VAR Result : PString; CONST Value : String );

{ append a string }
PROCEDURE AppendStr ( VAR Result : String; CONST Src : String );

{ dynamically allocate a string }
FUNCTION  NewStr ( CONST S : string ) : PString; external name ('_p_NewString');

{ dispose of a dynamically allocated string }
PROCEDURE DisposeStr ( P : PString ); external name (  '_p_Dispose');

{ case insensitive string comparison}
FUNCTION  CompareText ( CONST S1, S2 : string ) : Integer;
attribute (name ='_p_comparetext');

{ case sensitive string comparison}
FUNCTION  CompareStr ( CONST S1, S2 : string ) : Integer;
attribute (name = '_p_comparestr');

{ supposed to use language driver, but here, it doesn't }
FUNCTION  AnsiCompareText ( CONST S1, S2 : string ) : Integer;
external name (  '_p_comparetext');

{ supposed to use language driver, but here, it doesn't }
FUNCTION  AnsiCompareStr ( CONST S1, S2 : string ) : Integer;
external name (  '_p_comparestr');

{ convert a string to uppercase }
FUNCTION  UpperCase ( CONST c : string ) : TString;
external name (  '_p_UpCaseStr');

{ convert a string to lowercase }
FUNCTION  LowerCase ( CONST c : string ) : TString;
external name (  '_p_LoCaseStr');

{ convert a string to uppercase }
FUNCTION  AnsiUpperCase ( CONST S : string ) : Tstring;
external name (  '_p_UpCaseStr');

{ convert a string to lowercase }
FUNCTION  AnsiLowerCase ( CONST S : string ) : Tstring;
external name (  '_p_LoCaseStr');

{ case insensitive comparison = are they the same? }
FUNCTION AnsiSameText ( CONST S1, S2 : string ) : Boolean;

{ case sensitive comparison = are they the same? }
FUNCTION AnsiSameStr ( CONST S1, S2 : string ) : Boolean;


{ * string and number conversions * }

{ convert an integer to a string }
FUNCTION IntToStr ( i : longestint ) : TString;

{ convert a floating point number to a string }
FUNCTION FloatToStr ( Value : Extended ) : TString;


//*************************** FPC borrowed **********************
{** The code for these two next routines are taken from FPC sources **}

{ converts a floating point value to a string, using a specified Format, Precision, and Digits }
Function FloatToStrF ( Value: Extended; format: TFloatFormat; Precision, Digits: Integer ) : TString;

{ convert a floating-point value to an unterminated character string, using a specified Format, Precision and Digits }
Function FloatToText ( Buffer: PChar; Value: Extended; format: TFloatFormat; Precision, Digits: Integer ) : Longint;
//************************* end FPC borrowed **********************


{ convert a string to an integer }
FUNCTION StrToInt ( CONST s : String ) : longestint;
attribute (name = '_p_strtoint');

FUNCTION StrToInt64 ( CONST s : String ) : longestint; { same as above }
external name ( '_p_strtoint');

{ convert a string to an integer, returning "Default" in cases of error }
FUNCTION StrToIntDef ( CONST S : string; Default : longestint ) : longestint;
attribute (name = '_p_strtointdef');

FUNCTION StrToInt64Def ( CONST S : string; Default : longestint ) : longestint;
external name (  '_p_strtointdef');

{ convert a string to floating point }
FUNCTION StrToFloat ( CONST S : string ) : Extended;

{ @@ not in Delphi: convert a string to a set of char }
FUNCTION StringtoCharset ( CONST S : string; VAR c : TSysCharSet ) : Boolean;

{ convert an integer to Hex; dummydigits does nothing !!!}
FUNCTION IntToHex ( L, DummyDigits : Longint ) : TString;

{ ******* null terminated (C) string routines ******* }
FUNCTION  StrLen          ( Src : CString ) : SizeType;
external name (  '_p_CStringLength');

FUNCTION  StrEnd          ( Src : CString ) : CString;
external name (  '_p_CStringEnd');

FUNCTION  StrComp         ( s1, s2 : CString ) : Integer;
external name (  '_p_CStringComp');

FUNCTION  StrLComp        ( s1, s2 : CString; MaxLen : SizeType ) : Integer;
external name (  '_p_CStringLComp');

FUNCTION  StrIComp        ( s1, s2 : CString ) : Integer;
external name (  '_p_CStringCaseComp');

         {@@ supposed to use Windows locale }
FUNCTION  AnsiStrIComp        ( s1, s2 : CString ) : Integer;
external name (  '_p_CStringCaseComp');

FUNCTION  StrLIComp       ( s1, s2 : CString; MaxLen : SizeType ) : Integer;
external name (  '_p_CStringLCaseComp');

FUNCTION  StrCopy         ( Dest, Source : CString ) : CString;
external name (  '_p_CStringCopy');

FUNCTION  StrPCopy   ( Dest : CString; CONST Source : String ) : CString;
external name (  '_p_CStringCopyString');

FUNCTION  StrECopy        ( Dest, Source : CString ) : CString;
external name (  '_p_CStringCopyEnd');

FUNCTION  StrLCopy        ( Dest, Source : CString; MaxLen : SizeType ) : CString;
external name (  '_p_CStringLCopy');
                                {! source should actually be a Pascal string here!  }
FUNCTION  StrPLCopy        ( Dest, Source : CString; MaxLen : SizeType ) : CString;
external name (  '_p_CStringLCopy');

FUNCTION  StrMove         ( Dest, Source : CString; Count : SizeType ) : CString;
external name (  '_p_CStringMove');

FUNCTION  StrCat          ( Dest, Source : CString ) : CString;
external name (  '_p_CStringCat');

FUNCTION  StrLCat         ( Dest, Source : CString; MaxLen : SizeType ) : CString;
external name (  '_p_CStringLCat');

FUNCTION  StrScan         ( Src : CString; Ch : Char ) : CString;
external name (  '_p_CStringChPos');

FUNCTION  StrRScan        ( Src : CString; Ch : Char ) : CString;
external name (  '_p_CStringLastChPos');

FUNCTION  StrPos          ( Str, SubStr : CString ) : CString;
external name (  '_p_CStringPos');

FUNCTION  StrUpper        ( s : CString ) : CString;
external name (  '_p_CStringUpCase');

FUNCTION  StrLower        ( s : CString ) : CString;
external name (  '_p_CStringLoCase');

{ @@ supposed to use Windows locale }
FUNCTION  AnsiStrUpper        ( s : CString ) : CString;
external name (  '_p_CStringUpCase');

{ @@ supposed to use Windows locale }
FUNCTION  AnsiStrLower        ( s : CString ) : CString;
external name (  '_p_CStringLoCase');

FUNCTION  StrNew          ( Src : CString ) : CString;
external name (  '_p_CStringNew');

PROCEDURE StrDispose      ( s : CString );
external name (  '_p_Dispose');

FUNCTION StrPas ( Src : pChar ) : TString;
{asmname (  '_p_strpas';}

{ return a pointer to next string }
FUNCTION  StrNext  ( Str : pChar ) : pChar;

{ return a pointer to previous string }
FUNCTION  StrPrev  ( Str : pChar ) : pChar;

{ **** file and directory routines ***** }

{ return S with trailing slash if none already exists, else return S }
FUNCTION IncludeTrailingBackslash ( CONST S : string ) : TString;
external name (  '_p_ForceAddDirSeparator');

{ -- ditto -- }
FUNCTION IncludeTrailingDelimiter ( CONST S : string ) : TString;
external name (  '_p_ForceAddDirSeparator');

{ return just the extension }
FUNCTION  ExtractFileExt ( CONST s : string ) : TString;
external name (  '_p_ExtFromPath');

{ return just the path name part }
FUNCTION  ExtractFileDir ( CONST s : string ) : TString;

{ return just the file name part }
FUNCTION  ExtractFileName ( s : string ) : TString;
{asmname (  '_p_name_from_path';}

{ return the path + trailing slash }
FUNCTION  ExtractFilePath ( CONST s : string ) : TString;

{ return the drive name only }
FUNCTION  ExtractFileDrive ( CONST s : string ) : Tstring;

{ change the extension of a file }
FUNCTION  ChangeFileExt ( s, Ext : string ) : TString;

{ set an exit procedure }
PROCEDURE AddExitProc ( Proc : TProcedure ); external name '_p_AtExit';

{ return the full path name }
FUNCTION  ExpandFileName ( CONST s : string ) : TString; external name ( '_p_FExpand' );

{ does a file exist ?}
FUNCTION  FileExists ( CONST s : string ) : Boolean; external name ( '_p_FileExists' );

{ does a directory exist? }
FUNCTION  DirectoryExists ( CONST DirName : String ) : Boolean; external name ( '_p_DirectoryExists' );

{ return the current directory }
FUNCTION  GetCurrentDirectory : TString; external name '_p_GetCurrentDirectory';

FUNCTION  FileSearch ( CONST FileName, DirList : String ) : TString; external name ( '_p_FSearch' );

{ name clash with DOS unit }
{@@}FUNCTION DiskSize ( Drive : Byte ) : Longint;

{@@}FUNCTION DiskFree ( Drive : Byte ) : Longint;

{ *****  misc ****** }

{@@ name clash with GPC unit}
FUNCTION  wIsLeapYear ( Year : Integer ) : Boolean;
external name '_p_IsLeapYear';

{ create a directory - return whether successful }
FUNCTION CreateDir ( CONST s : String ) : Boolean;

{ remove a directory - return whether successful }
FUNCTION RemoveDir ( CONST s : String ) : Boolean;

{ change to a directory - return whether successful }
FUNCTION SetCurrentDir ( CONST s : String ) : Boolean;

{ return the current directory }
FUNCTION  GetCurrentDir : TString;
external name '_p_GetCurrentDirectory';


{ make a noise }
PROCEDURE Beep;

{ ******* file routines: using string parameters ***** }
{ rename a file }
FUNCTION  RenameFile ( CONST OldName, NewName : string ) : Boolean;

{ delete a file }
FUNCTION  DeleteFile ( CONST FileName : string ) : Boolean;

{ return the date of a file }
FUNCTION  FileAge ( CONST FileName : String ) : Longint;

{ set the file attribute }
FUNCTION  FileSetAttr ( CONST FileName : String; Attr : TDosAttr )  : integer;

{ get the file attribute }
FUNCTION  FileGetAttr ( CONST FileName : String ) : TDosAttr;

{ @@ set the date/time of a file: not in Delphi @@ }
FUNCTION  FileSetTime ( CONST FileName : String; aTime : integer ) : Integer;

{ ********* file routines: using file handles ******* }

{** handle-returning and conversion routines ** }

{ !! return the sysutils internal file handle for a file !!
  * the returned handle is only compatible with the sysutils file routines
    that take numeric handles (see below)
  * note: do not use the returned handle for libc file functions or
          OS API file functions.
  *       for libc-compatible or API-compatible file handles, use the
          conversion routines below ...
  *       note: you might need to amend "GetOSFileHandle" for your OS.
}
FUNCTION  SysUtilsFileHandle ( VAR f : File ) : TFileHandle;

{ !! return an operating system API-compatible file handle !!
  * under WIN32:  returns a handle that is compatible with WinAPI file routines only
  * under others: returns a handle that is compatible with libc file routines
}
FUNCTION  GetOSFileHandle ( VAR f ) : Integer;

{ !! convert a sysutils file handle to a libc file handle !! }
FUNCTION  SysUtilsFileHandle2LibcFileHandle ( Handle : TFileHandle ) : Integer;

{ !! convert a sysutils file handle to an API-compatible file handle !! }
FUNCTION  SysUtilsFileHandle2OSFileHandle ( Handle : TFileHandle ) : Integer;

{ ** routines that use SysUtils file handles ** }
{ write to a file }
FUNCTION FileWrite  ( Handle : TFileHandle; CONST Buf; Count : integer ) : integer;

{ read from a file }
FUNCTION FileRead   ( Handle : TFileHandle; VAR Buf; Count : integer ) : integer;

{ open a file }
FUNCTION FileOpen   ( CONST Fname : string; Mode : integer ) : TFileHandle;

{ create a file and return its handle }
FUNCTION FileCreate ( CONST Fname : string ) : TFileHandle;

{ position the file pointer to "offset" }
FUNCTION FileSeek ( Handle : TFileHandle; offset : Integer; origin : Integer ) : Integer;

{ close a file }
PROCEDURE FileClose  ( Handle : TFileHandle );

{ return the date of a file }
FUNCTION  FileGetDate ( handle : TFileHandle ) : Longint;

{ set the date of a file }
PROCEDURE FileSetDate ( handle : TFileHandle; aDate : Integer );

{ the name of the currently running program (paramstr(0) }
FUNCTION CurrentExecutable : TString;

{ ********* memory routines *********** }
{ allocate a memory block on the heap and return pointer to it }
FUNCTION AllocMem ( Size :  Cardinal ) : Pointer;

{ @@ other utility functions: not in Delphi @@ }
FUNCTION  MakeWord64 ( aLow, aHi : Int32 ) : Word64;
FUNCTION  MakeInt64 ( aLow, aHi : Int32 ) : Int64;
FUNCTION  MakeInt32 ( A, B : Word16 ) : Int32;
FUNCTION  MakeWord16 ( A, B : Byte ) : Word16;

FUNCTION  LoLong ( L : Int64 ) : Int32;
FUNCTION  HiLong ( L : Int64 ) : Int32;

FUNCTION  HiWord32 ( L : Int64 ) : Word32;
FUNCTION  LoWord32 ( L : Int64 ) : Word32;

FUNCTION  HiWord16 ( L : Int32 ) : Word16;
FUNCTION  LoWord16 ( L : Int32 ) : Word16;

FUNCTION  HiByte8 ( W : Word16 ) : Byte8;
FUNCTION  LoByte8 ( W : Word16 ) : Byte8;

type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase, rfWholeWords);

{ find all occurrences of "theold" and replace with "thenew" }
FUNCTION  FindAndReplace ( CONST Src, TheOld, TheNew : String; IgnoreCase, WholeWords : Boolean ) : TString;

function StringReplaceWhole (const S, OldPattern, NewPattern: string;
Flags: TReplaceFlags): Tstring;

function StringReplace (const S, OldPattern, NewPattern: string;
Flags: TReplaceFlags): Tstring;

function StringReplaceInPlace (Var Src_Dest : String; const OldPattern, NewPattern: string;
Flags: TReplaceFlags): Integer;

function wholepos (const sub, str : String; ignorecase : boolean) : Cardinal;

function ExtendedPos (const sub, str : String; wholewords, ignorecase : boolean) : Cardinal;

function iPosFrom (const sub, str : String; from : Cardinal) : Cardinal;

Implementation

{ copy certain parts of Dos unit for all platforms }
{$i fromdos.inc}

{ constants, types
  GetDate
  GetTime
  GetFattr
  PackTime
  UnpackTime
  GetFTime
  SetFTime
  DiskSize
  DiskFree
  (we can use amended versions of FindFirst/FindNext - except under Windows
   where we need the FindData field of TSearchRec - hence need to use API)
}

{ @@ platform-specific stuff:
      for FindFirst/FindNext/FindClose
      and file attributes stuff
  @@
}

{$ifdef UseW32API}
  {$i win.inc}
{$else}
  {$i others.inc}
{$endif}{ UseW32API }

FUNCTION  wTrimLeft ( CONST s : String ) : TString;
VAR i : Integer;
BEGIN
  i := 1;
  Result := s;
  WHILE ( i <= Length ( Result ) ) AND ( Result [i] <= ' ' ) DO Inc ( i );
  Delete ( Result, 1, Pred ( i ) );
END;{* TrimLeft *}

FUNCTION wTrimRight ( CONST s : String ) : TString;
VAR i : Integer;
BEGIN
  i := Length ( Result );
  WHILE ( i > 0 ) AND ( Result [i] <= ' ' ) DO Dec ( i );
  Delete ( Result, Succ ( i ), Length ( Result ) - i );
END;{* TrimRight *}

FUNCTION Trim ( CONST s : String ) : TString;
VAR i : Integer;
BEGIN
  i := 1;
  Result := s;
  WHILE ( i <= Length ( Result ) ) AND ( Result [i] <= ' ' ) DO Inc ( i );
  Delete ( Result, 1, Pred ( i ) );

  i := Length ( Result );
  WHILE ( i > 0 ) AND ( Result [i] <= ' ' ) DO Dec ( i );
  Delete ( Result, Succ ( i ), Length ( Result ) - i );
END;{* Trim *}

PROCEDURE AssignStr ( VAR Result : PString; CONST Value : String );
BEGIN
  DisposeStr ( Result );
  Result := NewStr ( Value );
END;{* AssignStr *}

PROCEDURE AppendStr ( VAR Result : String; CONST Src : String );
BEGIN
  Result := Concat ( Result, Src );
END;{* AppendStr *}

PROCEDURE UnPackFileDate ( P : Longint; VAR T : DateTime );
BEGIN
  UnpackTime ( p, t );
END;{* UnPackFileDate *}

PROCEDURE PackFileDate ( CONST T : DateTime; VAR P : Longint );
BEGIN
  PackTime ( t, p );
END;{* PackFileDate *}

FUNCTION Date : TDateTime;
VAR
Year, Month, Day,
DayOfWeek : Word;
BEGIN
  GetDate ( Year, Month, Day, DayOfWeek );
  Result := EncodeDate ( Year, Month, Day );
END;{* Date *}

FUNCTION Time : TDateTime;
VAR
Hour, Minute,
Second, Sec100 : Word;
{$ifdef UseW32API}
T : TSystemTime;
{$endif}
BEGIN
{$ifdef UseW32API}
  GetLocalTime (T);
  With T do
  Result := EncodeTime ( wHour, wMinute, wSecond, wMilliSeconds );
{$else}
  GetTime ( Hour, Minute, Second, Sec100 );
  Result := EncodeTime ( Hour, Minute, Second, Sec100 );
{$endif}
END;{* Time *}

FUNCTION Now : TDateTime;
VAR
T : TDateTime;
BEGIN
    T := Time;
    Result := Date + T;
END;{* Now *}

{$ifdef UseW32API}
FUNCTION Now2 : TDateTime;
VAR
T : TSystemTime;
BEGIN
  GetLocalTime (T);
  With T do
  Result :=
  EncodeDate ( wYear, wMonth, wDay ) +
  EncodeTime ( wHour, wMinute, wSecond, wMilliSeconds );
END;{* Now2 *}
{$endif}

FUNCTION  ChangeFileExt ( s, Ext : string ) : TString;
VAR
i : integer;
BEGIN

   { see if 's' already has an extension }
   i  := Lastpos ( '.', s );

   IF ( i = 1 ) { some unix filenames begin with dot ! }
   THEN BEGIN
      i  := pos ( '.', Copy ( s, 2, Length ( s ) ) );
   END
   ELSE
   IF ( ( i > 1 ) and ( s [i-1] in ['/', '\'] ) )
   then begin
      i := Length ( s ) + 1;
   end;

   { remove the extension }
   IF i > 1 THEN s := Copy ( s, 1, pred ( i ) );

   IF Ext = '' THEN Result := s
   ELSE BEGIN
      IF ( Ext [1] <> '.' )
      THEN Result := s + '.' + Ext
      ELSE Result := s + Ext;
   END;
END;{*  ChangeFileExt *}

FUNCTION  StrNext  ( Str : pChar ) : pChar;
BEGIN
  Result := Succ ( Str );
END; {* StrNext *}

FUNCTION  StrPrev  ( Str : pChar ) : pChar;
BEGIN
   Result := Pred ( Str );
END; {* StrPrev *}

FUNCTION StrPas ( Src : pChar ) : TString;
BEGIN
  StrPas := CString2String ( Src )
END; {* StrPas *}

FUNCTION RenameFile ( CONST OldName, NewName : string ) : Boolean;
VAR
f : file;
BEGIN
   Assign ( f, OldName );
   Rename ( f, NewName );
   Result := IoResult = 0;
END; {* RenameFile *}

FUNCTION DeleteFile ( CONST FileName : string ) : Boolean;
VAR
f : file;
BEGIN
   Assign ( f, FileName );
   Erase ( f );
   Result := IoResult = 0;
END; {* DeleteFile *}

FUNCTION SysUtilsFileHandle;
BEGIN
  Result := TFileHandle ( @f );
END; {* SysUtilsFileHandle *}

FUNCTION  GetOSFileHandle;
BEGIN
 Result := {$ifdef UseW32API}cfHandle2osfHandle{$endif} ( FileHandle ( f ) );
END; {* GetOSFileHandle *}

FUNCTION  SysUtilsFileHandle2OSFileHandle ( Handle : TFileHandle ) : Integer;
VAR
p : PFile;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      Result := GetOSFileHandle ( p^ );
  END;
END; {* SysUtilsFileHandle2OSFileHandle *}

FUNCTION  SysUtilsFileHandle2LibcFileHandle ( Handle : TFileHandle ) : Integer;
VAR
p : PFile;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      Result := FileHandle ( GPC_AnyFile ( p^ ) );
  END;
END; {* SysUtilsFileHandle2LibcFileHandle *}

FUNCTION sys_fCreate ( CONST Fname : String; isNew : Boolean; Mode : integer ) : TFileHandle;
VAR
f   : pFile;
old : integer;
BEGIN
  New ( f );
  Assign ( f^, FName );
  IF IsNew THEN BEGIN
     ReWrite ( f^, 1 );
  END ELSE BEGIN
      old := FileMode;
      FileMode := Mode;
      Reset ( f^, 1 );
      FileMode := Old;
  END;

  IF IOResult <> 0
  THEN BEGIN
     Dispose ( f );
     Result := NoFileHandle
  END ELSE Result := SysUtilsFileHandle ( f^ );
END;{ * sys_fCreate *}

FUNCTION FileCreate ( CONST Fname : string ) : TFileHandle;
BEGIN
    Result := sys_fCreate ( FName, TRUE, 2 );
END;{* FileCreate *}

FUNCTION FileOpen   ( CONST Fname : string; Mode : integer ) : TFileHandle;
BEGIN
    Result := sys_fCreate ( FName, False, Mode );
END;{* FileOpen *}

PROCEDURE FileClose ( Handle : TFileHandle );
VAR p : PFile;
BEGIN
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      Close ( p^ );
      IF IoResult <> 0 THEN begin end;
      Dispose ( p );
    END;
END;{* FileClose *}

FUNCTION FileWrite  ( Handle : TFileHandle; CONST Buf; Count : integer ) : integer;
VAR
p : PFile;
i : Integer;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      BlockWrite ( p^, Buf, Count, i );
      IF IoResult = 0 THEN Result := i;
  END;
END;{* FileWrite *}

FUNCTION FileRead   ( Handle : TFileHandle; VAR Buf; Count : integer ) : integer;
VAR
p : PFile;
i : Integer;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      BlockRead ( p^, Buf, Count, i );
      IF IoResult = 0 THEN Result := i;
  END;
END;{* FileRead *}

FUNCTION FileSeek ( Handle : TFileHandle; offset : Integer; origin : Integer ) : Integer;
VAR
p : PFile;
l : integer;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      l := Offset;
      CASE origin OF
         0 : { do nothing - seek from beginning of file };
         1 : l := FilePos ( p^ ) + Offset;  { from current position }
         2 : l := FileSize ( p^ ) + Offset; { from end of file }
      END;
      Seek ( p^, l );
      IF IoResult = 0 THEN Result := FilePos ( p^ );
  END;
END;{* FileSeek *}

FUNCTION  FileGetAttr;
VAR
Attr : TDosAttr;
f : File;
BEGIN
  {$ifdef UseW32API}
   Attr := GetFileAttributes ( FileName );
  {$else}
   Assign ( f, FileName );
   GetFattr ( f, Attr );
  {$endif}
   Result := Attr;
END;{* FileGetAttr *}

FUNCTION  FileSetAttr;
VAR
f : File;
BEGIN
  {$ifdef UseW32API}
   DosError := Ord ( SetFileAttributes ( FileName, Attr ) );
  {$else}
   Assign ( f, FileName );
   SetFattr ( f, Attr );
  {$endif}
   Result := DosError;
END;{* FileSetAttr *}

FUNCTION  FileAge ( CONST FileName : String ) : Longint;
VAR
F : File;
L : Longint;
BEGIN
   Result := SysError;
   Assign ( F, FileName );
   GetFTime ( F, L );
   IF DosError = 0 THEN Result := L;
END;{* FileAge *}

FUNCTION  FileGetDate ( Handle : TFileHandle ) : Longint;
VAR
p : PFile;
BEGIN
  Result := NoFileHandle;
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      Result := FileAge ( FileName ( GPC_AnyFile ( p^ ) ) );
  END;
END;{* FileGetDate *}

PROCEDURE FileSetDate ( handle : TFileHandle; aDate : Integer );
VAR
p : PFile;
BEGIN
  IF Handle <> NoFileHandle
  THEN BEGIN
      p := PFile ( Handle );
      SetFTime ( GPC_AnyFile ( p^ ), aDate );
  END;
END;{* FileSetDate *}

FUNCTION  FileSetTime ( CONST FileName : String; aTime : integer ) : Integer;
VAR
f : File;
BEGIN
  Result := SysError;
  Assign ( f, FileName );
  Reset ( f, 1 );
  IF Ioresult = 0
  THEN BEGIN
     SetFTime ( f, aTime );
     Result := DosError;
     Close ( f );
  END;
END;{* FileSetTime *}

FUNCTION  GetEnvVar ( CONST EnvVar : String ) : TString;
external name (  '_p_GetEnv');

FUNCTION CurrentExecutable : TString;
VAR
p : ARRAY [ 0 .. 259 ] OF char;
BEGIN
{$ifdef __OS_DOS__}
  {$ifdef UseW32API}
    GetModuleFileName ( 0, p, 259 );
    Result := CString2String ( p );
  {$else}
    Result := FExpand ( ChangeFileExt ( ParamStr ( 0 ), '.exe' ) );
  {$endif}
{$else}
    Result := FExpand ( FSearch ( ParamStr ( 0 ), GetEnvVar ( PathEnvVar ) ) );
{$endif}
END; {* CurrentExecutable *}

FUNCTION AllocMem ( Size :  Cardinal ) : Pointer;
VAR
p : Pointer;
BEGIN
   GetMem ( p, Size );
   FillChar ( pchar (p)^, Size, #0 );
   Result := p;
END;{* AllocMem *}

{$W-}
FUNCTION IntToStr ( i : longestint ) : TString;
BEGIN
  Str ( i, Result );
END; {* IntToStr  *}

FUNCTION FloatToStr ( Value : Extended ) : TString;
BEGIN
  Str ( Value, Result );
END; {* FloatToStr  *}
{$W+}

Function CHex2PasHex ( s : String ): TString;
begin
   Result := s;
   If Pos ( '0x', s ) > 0
   then begin
      Delete ( s, 1, 2 );
      Result := '$' + s;
   end;
end;

FUNCTION StrToInt ( CONST s : String ) : longestint;
VAR
Code : Integer;
BEGIN
    Val ( CHex2PasHex ( s ), Result, Code );
    IF Code <> 0 THEN IOError ( EConvertError, False );
END; {* StrToInt *}

FUNCTION StrToIntDef;
VAR
Code : Integer;
BEGIN
    Val ( CHex2PasHex ( s ), Result, Code );
    IF Code <> 0 THEN Result := Default;
END; {* StrToIntDef *}

FUNCTION  ExtractFileDir ( CONST s : string ) : TString;
BEGIN
   Result := RemoveDirSeparator ( DirFromPath ( s ) );
END; {* ExtractFileDir *}

FUNCTION  ExtractFilePath ( CONST s : string ) : TString;
BEGIN
   Result := ForceAddDirSeparator ( DirFromPath ( s ) );
END; {* ExtractFilePath *}

FUNCTION  ExtractFileName ( s : string ) : TString;
VAR
i : Word;
BEGIN
  FOR i := length ( s ) DOWNTO 1
  DO BEGIN
      IF s [i] IN [':', DirSeparator]
      THEN BEGIN
         Delete ( s, 1, i );
         Break;
      END;
  END;
  Result := s;
END;  {* ExtractFileName *}

FUNCTION ExtractFileDrive ( CONST s : string ) : Tstring;
BEGIN
  Result := GetMountPoint ( s );
END; {* ExtractFileDrive *}

{ case insensitive compare }
FUNCTION CompareText ( CONST S1, S2 : string ) : Integer;
BEGIN
   Result := StrIComp ( s1, s2 );
END {* CompareText *};

{ case sensitive compare }
FUNCTION CompareStr ( CONST S1, S2 : string ) : Integer;
BEGIN
   Result := StrComp ( s1, s2 );
END {*  CompareStr *};

FUNCTION  SetCurrentDir ( CONST s : String ) : Boolean;
BEGIN
    ChDir ( s );
    Result := IoResult = 0;
END; {* SetCurrentDir *}

FUNCTION  CreateDir ( CONST s : String ) : Boolean;
BEGIN
    MkDir ( s );
    Result := IOResult = 0;
END; {* CreateDir *}

FUNCTION  RemoveDir ( CONST s : String ) : Boolean;
BEGIN
    RmDir ( s );
    Result := IOResult = 0;
END; {* RemoveDir *}

PROCEDURE Beep;
BEGIN
   Write ( #7 );
END; {* Beep *}


TYPE
LRec = RECORD
{$ifdef __BYTES_BIG_ENDIAN__}
  HW, LW : Word16;
{$else}
  LW, HW : Word16;
 {$endif}
END;

TYPE
String4 = String [4];

FUNCTION HexW ( W : Word16 ) : String4;
CONST
Digits : ARRAY [0..$F] OF Char = '0123456789ABCDEF';
BEGIN
    Result := '1234'; { length of 4 }
    Result [1] := Digits [hi ( W ) SHR 4];
    Result [2] := Digits [hi ( W ) AND $F];
    Result [3] := Digits [lo ( W ) SHR 4];
    Result [4] := Digits [lo ( W ) AND $F];
END;

{$local W-}
FUNCTION IntToHex ( L, DummyDigits : Longint ) : TString;
BEGIN
    WITH LRec ( L ) DO Result := HexW ( HW ) + HexW ( LW );
END; {* IntToHex *}
{$endlocal}

FUNCTION AdjustLinesBreaks ( CONST S : string ) : TString;
CONST
Cr = #13;
Lf = #10;
VAR
i, j : integer;
Ch, Ch2 : Char;
BEGIN
   Result := '';
   j := Length ( s );
   FOR i := 1 TO j
   DO BEGIN
      ch := s [i];
      IF i = 1 THEN Ch2 := #0 ELSE ch2 := s [ Pred ( i ) ];
      IF ( Ch = Lf ) AND ( Ch2 <> Cr ) { Lf not preceded by Cr }
      OR ( Ch2 = Cr ) AND ( Ch <> Lf ) { Cr not followed by Lf }
      THEN BEGIN
           Result := Result + Cr + Lf;
      END
      ELSE Result := Result + Ch;
   END;
END; {* AdjustLinesBreaks *}

FUNCTION IsValidIdent ( CONST s : string ) : Boolean;
VAR
b : boolean;
i : integer;
BEGIN
    b := True;
    FOR i := 1 TO length ( s ) DO BEGIN
        IF s [i] IN ['A'..'Z', 'a'..'z', '_', '0'..'9'] THEN {valid chars}
        ELSE BEGIN
           b := False;
           Break;
        END;
    END;
    Result := ( b = true ) AND ( s [1] IN ['A'..'Z', 'a'..'z', '_'] );
END; {* IsValidIdent *}

FUNCTION StrToFloat ( CONST S : string ) : Extended;
VAR
Code : Integer;
BEGIN
  Val ( s, Result, Code );
  IF Code <> 0 THEN IOError ( EConvertError, False );
END; {* StrToFloat *}

FUNCTION MakeWord64 ( aLow, aHi : Int32 ) : Word64;
BEGIN
  Result := Word64 ( Word64 ( aLow ) OR Word64 ( aHi ) SHL BitSizeOf ( Int32 ) );
END; {* MakeWord64 *}

FUNCTION MakeInt64 ( aLow, aHi : Int32 ) : Int64;
BEGIN
  Result := Int64 ( Word64 ( Word32 ( aLow ) ) OR Word64 ( Word32 ( aHi ) ) SHL BitSizeOf ( Int32 ) )
END; {* MakeInt64 *}

FUNCTION HiLong ( L : Int64 ) : Int32;
BEGIN
  Result := Int32 ( L SHR BitSizeOf ( Int32 ) );
END; {* HiLong *}

FUNCTION LoLong ( L : Int64 ) : Int32;
BEGIN
  Result := Int32 ( L AND $FFFFFFFF );
END; {* LoLong *}

FUNCTION HiWord32 ( L : Int64 ) : Word32;
BEGIN
  Result := Word32 ( L SHR BitSizeOf ( Word32 ) );
END; {* HiWord32 *}

FUNCTION LoWord32 ( L : Int64 ) : Word32;
BEGIN
  Result := Word32 ( L AND $FFFFFFFF );
END; {* LoWord32 *}

FUNCTION MakeWord16 ( A, B : Byte ) : Word16;
BEGIN
  Result := Word16 ( A OR B SHL BitSizeOf ( Byte ) );
END; {* MakeWord16 *}

FUNCTION MakeInt32 ( A, B : Word16 ) : Int32;
BEGIN
  Result := Int32 ( A OR B SHL BitSizeOf ( Word16 ) );
END; {* MakeInt32 *}

FUNCTION HiWord16 ( L : Int32 ) : Word16;
BEGIN
  Result := Word16 ( Word32 ( L ) SHR BitSizeOf ( Word16 ) );
END; {* HiWord16 *}

FUNCTION LoWord16 ( L : Int32 ) : Word16;
BEGIN
  Result := Word16 ( L AND $FFFF );
END; {* LoWord16 *}

FUNCTION HiByte8 ( W : Word16 ) : Byte8;
BEGIN
  Result := Byte8 ( W SHR BitSizeOf ( Byte8 ) );
END;{* HiByte8 *}

FUNCTION LoByte8 ( W : Word16 ) : Byte8;
BEGIN
  Result := Byte8 ( W AND $FF );
END; {* LoByte8 *}

FUNCTION AnsiSameText ( CONST S1, S2 : string ) : Boolean;
BEGIN
   Result := AnsiCompareText ( s1, s2 ) = 0;
END;{* AnsiSameText *}

FUNCTION AnsiSameStr ( CONST S1, S2 : string ) : Boolean;
BEGIN
   Result := AnsiCompareStr ( s1, s2 ) = 0;
END;{* AnsiSameStr *}

FUNCTION QuotedStr;
VAR
i : Word;
BEGIN
   IF Pos ( SingleQuote, s ) = 0
   THEN BEGIN
      Result := SingleQuote + s + SingleQuote;
      Exit;
   END;
   Result := s;
   FOR i := Length ( Result ) DOWNTO 1
   DO BEGIN
     IF Result [i] = SingleQuote THEN Insert ( SingleQuote, Result, i );
   END;
   Result := SingleQuote + Result + SingleQuote;
END;{* QuotedStr *}

FUNCTION FindCmdLineSwitch;
VAR
s : TString;
i : Word;
BEGIN
   Result := False;
   IF ParamCount = 0 THEN Exit;
   FOR i := 1 TO ParamCount
   DO BEGIN
       s := ParamStr ( i );
       IF s [1] IN SwitchChars
       THEN BEGIN
           CASE IgnoreCase OF
             True :  Result := CompareText ( Switch, s ) = 0;
             False :  Result := CompareStr ( Switch, s ) = 0;
           END;{Case}
           IF Result THEN Exit;
       END;
   END;
END;{* FindCmdLineSwitch *}

FUNCTION DateTimeToTimeStamp ( DateTime : TDateTime ) : TTimeStamp;
VAR Tmp : Comp;
BEGIN
  Tmp := {Trunc}Round ( DateTime * MSecsPerDay );
  Result.Date := Tmp DIV ( MSecsPerDay + DateDelta );
  Result.Time := Abs ( Tmp ) MOD MSecsPerDay
END;{* DateTimeToTimeStamp *}

FUNCTION TimeStampToDateTime ( CONST TimeStamp : TTimeStamp ) : TDateTime;
VAR Tmp : Comp;
BEGIN
  Tmp := ( TimeStamp.Date - DateDelta ) * MSecsPerDay;
  IF Tmp > 0
    THEN Inc ( Tmp, TimeStamp.Time )
    ELSE Dec ( Tmp, TimeStamp.Time );
  TimeStampToDateTime := Tmp / MSecsPerDay
END;{* TimeStampToDateTime *}

FUNCTION MSecsToTimeStamp ( MSecs : Comp ) : TTimeStamp;
BEGIN
  Result.Date := MSecs DIV MSecsPerDay;
  Result.Time := MSecs MOD MSecsPerDay
END;{* MSecsToTimeStamp *}

FUNCTION TimeStampToMSecs ( CONST TimeStamp : TTimeStamp ) : Comp;
BEGIN
  TimeStampToMSecs := Comp ( TimeStamp.Date ) * MSecsPerDay + TimeStamp.Time
END;{* TimeStampToMSecs *}

FUNCTION EncodeTime ( Hour, Min, Sec, MSec : Word ) : TDateTime;
BEGIN
  IF ( Hour < 24 ) AND ( Min < 60 ) AND ( Sec < 60 ) AND ( MSec < 1000 )
  THEN Result := ( Hour * 3600000 + Min * 60000 + Sec * 1000 + MSec ) / MSecsPerDay
  ELSE Result := SysError;
END;{* EncodeTime *}

PROCEDURE DecodeTime ( Time : TDateTime; VAR Hour, Min, Sec, MSec : Word16 );
PROCEDURE Modulate ( Dividend : Int32; Divisor : Word16; VAR Res, Remainder : Word16 );
BEGIN
  Res := Dividend DIV Divisor;
  Remainder := Dividend MOD Divisor;
END;

VAR
I, J : Word16;
TS : TTimeStamp;
BEGIN
  TS := DateTimeToTimeStamp ( Time );
  Modulate ( TS.Time, MSecsPerMin, I, J );
  Modulate ( I, SecsPerMin, Hour, Min );
  Modulate ( J, MSecsPerSec, Sec, MSec );
END;{* DecodeTime *}

FUNCTION EncodeDate ( Year, Month, Day : Word ) : TDateTime;
CONST MonthOffset : ARRAY [1 .. 12] OF Integer
= (  - 94, - 63, - 400, - 369, - 339, - 308, - 278, - 247, - 216, - 186, - 155, - 125 );
BEGIN
  IF ( Year < 1 ) OR ( Year > 9999 ) OR ( Month < 1 ) OR ( Month > 12 ) OR ( Day < 1 ) OR
     ( Day > MonthLength ( Month, Year ) +
     Ord ( ( Month = 2 )
     AND IsLeapYear ( Year ) ) ) THEN { Problem ! ... }
     begin
        Result := SysError;
        Exit;
     end;
  IF Month <= 2 THEN Dec ( Year );
  EncodeDate := Day + MonthOffset [Month] + ( Year - 1900 ) * 365 + Year DIV 4 - Year DIV 100 + Year DIV 400
END;{* EncodeDate *}

PROCEDURE DecodeDate ( Date : TDateTime; VAR Year, Month, Day : Word16 );
VAR
IntDate, Tmp1, Tmp2, Tmp3, Tmp4, Tmp5, Tmp6 : Integer;
BEGIN
  IntDate := Trunc ( Date );
  IF IntDate < LastGoodDate
  THEN BEGIN
      Year := 0;
      Month := 0;
      Day := 0;
      Exit;
  END;

  Inc ( IntDate, 693899 );
  Tmp1 := 30 * ( IntDate DIV 1460970 );
  Tmp2 := IntDate MOD 1460970;
  Tmp1 := Tmp1 + 3 * ( Tmp2 DIV 146097 );
  Tmp2 := Tmp2 MOD 146097;
  IF Tmp2 = 146096 THEN Inc ( Tmp1, 3 ) ELSE Inc ( Tmp1, Tmp2 DIV 36524 );
  Tmp3 := IntDate + ( Tmp1 - 2 ) + 1722644;
  Tmp5 := ( 20 * Tmp3 - 2442 ) DIV 7305;
  Tmp4 := Tmp3 - ( 1461 * Tmp5 ) DIV 4;
  Tmp6 := ( 10000 * Tmp4 ) DIV 306001;
  Day := Tmp4 - ( 306001 * Tmp6 ) DIV 10000;
  Month := Pred ( Tmp6 );
  Year := Tmp5 - 4716;

  IF Month > 12
  THEN BEGIN
      Dec ( Month, 12 );
      Inc ( Year );
  END;

END;{* DecodeDate *}

FUNCTION LongToDateTimeRec ( i : Longint ) : TDateTimeRec;
VAR
MSec : Word16;
D : DateTime;
BEGIN
  UnpackTime ( i, D );
  WITH D DO BEGIN
     MSec := 0;
     Result.Date := EncodeDate ( Year, Month, Day );
     Result.Time := EncodeTime ( Hour, Min, Sec, MSec );
  END;
END;{* LongToDateTimeRec  *}

FUNCTION FileDateToDateTime ( DosDateTime : Longint ) : TDateTime;
VAR
DT : TDateTimeRec;
BEGIN
  DT := LongToDateTimeRec ( DosDateTime );
  Result := DT.Date + DT.Time;
END;{* FileDateToDateTime *}

FUNCTION DateTimeRecToLong ( DT : TDateTimeRec ) : Integer;
VAR
D : DateTime;
MSec,
L, H : Word16;
BEGIN
   Result := 0;
   WITH D DO BEGIN
      DecodeDate ( DT.Date, Year, Month, Day );
      DecodeTime ( DT.Time, Hour, Min, Sec, MSec );
      IF ( Year < 1980 ) OR ( Year > 2099 )
      THEN  { return 0 }
      ELSE BEGIN
        L := ( Sec DIV 2 ) OR ( Min * 32 ) OR ( Hour * 2048 );
        H := Day OR ( Month * 32 ) OR ( ( Year - 1980 ) * 512 );
        Result := MakeInt32 ( L, H );
      END;
   END;
END;{* DateTimeRecToLong *}

FUNCTION DateTimeToFileDate ( MyDateTime : TDateTime ) : Int32;
VAR
DT : TDateTimeRec;
BEGIN
  DT.Date := MyDateTime;
  DT.Time := MyDateTime;
  Result := DateTimeRecToLong ( DT );
END;{* DateTimeToFileDate *}

FUNCTION SystemTimeToDateTime ( CONST SystemTime : TSystemTime ) : TDateTime;
BEGIN
   WITH SystemTime
   DO BEGIN
        Result := EncodeDate ( wYear, wMonth, wDay ) +
                  EncodeTime ( wHour, wMinute, wSecond, wMilliseconds );
   END;
END;{* SystemTimeToDateTime *}

PROCEDURE DateTimeToSystemTime ( DateTime : TDateTime; VAR STime : TSystemTime );
BEGIN
   WITH STime DO BEGIN
      DecodeDate ( DateTime, wYear, wMonth, wDay );
      DecodeTime ( DateTime, wHour, wMinute, wSecond, wMilliSeconds );
   END;
END;{* DateTimeToSystemTime *}

FUNCTION TDateTimeToUnixTime ( DateTime : TDateTime ) : UnixTimeType;
VAR
st : TSystemTime;
BEGIN
   DateTimeToSystemTime ( DateTime, st );
   WITH st DO BEGIN
      Result := TimeToUnixTime ( wYear, wMonth, wDay, wHour, wMinute, wSecond );
   END;
END; {* TDateTimeToUnixTime *}

FUNCTION UnixTimeToTDateTime ( DateTime : UnixTimeType ) : TDateTime;
VAR
y, mo, d, h, m, s : Cinteger;
BEGIN
   UnixTimeToTime ( DateTime, y, mo, d, h, m, s, NULL, NULL, NULL, NULL );
   Result := EncodeDate ( y, mo, d ) + EncodeTime ( h, m, s, 100 );
END; {* UnixTimeToTDateTime *}


{ utility functions for seek/replace functions }
FUNCTION IsMarked ( i : Integer; s2 : String ) : Boolean;
BEGIN
    Result :=
    ( ( i = 1 ) OR ( NOT IsAlphaNumUnderscore ( s2 [Pred ( i ) ] ) ) )
   AND
    ( ( i >= Length ( s2 ) ) OR ( NOT IsAlphaNumUnderscore ( s2 [Succ ( i ) ] ) ) );
END;

FUNCTION IsMarkedEx ( i, z : Integer; s2 : String ) : Boolean;
BEGIN
    Result :=
        ( ( i = 1 ) OR ( NOT IsAlphaNumUnderscore ( s2 [pred ( i ) ] ) ) )
      AND
        ( ( i + z >= Length ( s2 ) ) OR ( NOT IsAlphaNumUnderscore ( s2 [i + z] ) ) );
END;

FUNCTION FindAndReplace ( CONST Src, TheOld, TheNew : String; IgnoreCase, WholeWords : Boolean ) : TString;
{ generic find/replace function }
VAR
Dest : TString;
i : Cardinal;
BEGIN
    FindAndReplace := Src;
    IF ( TheOld = '' ) OR ( Src = '' ) OR (theOld = theNew) THEN exit;
    Dest := Src;
    i := ExtendedPos ( theOld, Dest, wholewords, IgnoreCase );
    While i > 0 do begin
      Delete ( Dest, i, Length ( theOld ) );
      Insert ( TheNew, Dest, i );
      i := ExtendedPos ( theOld, Dest, wholewords, IgnoreCase );
    end;
    FindAndReplace := Dest;
END;{ * FindAndReplace *}

FUNCTION HasQuotes ( CONST s : String; VAR start, stop : word ) : Word;
{ return the number of quotation marks in a string - and also
  report the location of the first, and the last quote character
}
VAR
i : Word;
BEGIN
   Result := 0;
   start := 0;
   stop := 0;
   FOR i := 1 TO length ( s )
   DO BEGIN
       IF s [i] IN [DoubleQuote, SingleQuote]
       THEN BEGIN
          IF start = 0 THEN start := i;
          stop := i;
          inc ( Result );
       END;
   END;
END;

FUNCTION RemoveQuotes ( s : String ) : TString;
{ remove all quote characters from a string }
VAR
i : Word;
BEGIN
   FOR i := length ( s ) DOWNTO 1
     DO IF s [i] IN [DoubleQuote, SingleQuote]
       THEN Delete ( s, i, 1 );
   Result := s;
END;

FUNCTION WithinQuotes ( CONST s2 : String; CONST i : Word ) : Boolean;
{ return whether the character at index i is within quotation marks }
VAR
stt, stp : Word;
BEGIN
  Result := False;
  IF HasQuotes ( s2, stt, stp ) > 1
    THEN Result := ( stt < i ) AND ( stp > i );
END;

FUNCTION SeekReplace
         ( CONST Src, TheOld, TheNew : String;
         IgnoreCase, WholeWords : Boolean ) : TString;
{ specialised find/replace function for formatting TDateTime stuff }
VAR
b : Boolean;
s1, s2, Dest : String [255];
Loc : ARRAY [1..255] OF Byte;
k, i, j, z : Word;

BEGIN
    Result := Src;
    Dest := Src;
    IF ( TheOld = '' ) OR ( Dest = '' ) THEN exit;
    s1 := TheOld;
    s2 := Dest;
    IF ignorecase THEN s1 := uppercase ( s1 );
    IF ignorecase THEN s2 := uppercase ( s2 );
    IF Pos ( s1, s2 ) = 0 THEN exit;

    z := length ( TheOld );
    k := 0;
    j := 0;
    IF ( Not WholeWords )
    THEN BEGIN
       IF z = 1  { single char }
       THEN BEGIN
          FOR i := length ( Dest ) DOWNTO 1
          DO BEGIN
              b := s2 [i] = s1 [1];
              IF b THEN IF Not WithinQuotes ( s2, i )
              THEN BEGIN
                 Delete ( s2, i, 1 );
                 Insert ( TheNew, s2, i );
                 Delete ( Dest, i, 1 );
                 Insert ( TheNew, Dest, i );
              END;
          END;
          Result := Dest;
          exit;
       END ELSE
       WHILE 0 = 0 DO BEGIN
         i := pos ( s1, s2 );
         IF ( i = 0 ) OR ( j >= length ( s2 ) ) THEN break;
         inc ( j );
         IF WithinQuotes ( s2, i )
         THEN BEGIN
           insert ( #3, s2, succ ( i ) );
           insert ( #3, dest, succ ( i ) );
         END
         ELSE BEGIN
           Delete ( s2, i, z ); {remove old}
           Insert ( TheNew, s2, i );
           Delete ( Dest, i, z ); {remove old}
           Insert ( TheNew, Dest, i );
         END;
       END;

       FOR i := Length ( Dest ) downto 1 DO IF dest [i] = #3 THEN Delete ( dest, i, 1 );

       Result := Dest;
       exit;
    END; {WholeWords=False}

    k := 0;
    j := 0;
    Fillchar ( Loc, Sizeof ( Loc ), 0 );
    { WholeWords=True }
      IF z = 1  { single char }
      THEN BEGIN
          FOR i := length ( Dest ) DOWNTO 1
          DO BEGIN
              IF  ( s2 [i] = s1 [1] ) AND ( IsMarked ( i, s2 ) )
              THEN BEGIN
                 IF Not WithinQuotes ( s2, i )
                 THEN BEGIN
                    Delete ( s2, i, 1 );
                    Insert ( TheNew, s2, i );
                    Delete ( Dest, i, 1 );
                    Insert ( TheNew, Dest, i );
                 END;
              END;
          END;
          Result := Dest;
          exit;
     END ELSE
     WHILE 0 = 0 DO BEGIN
         i := pos ( s1, s2 );
         IF i = 0 THEN break;
         b := IsMarkedEx ( i, z, s2 );
         IF ( b ) AND ( WithinQuotes ( s2, i ) )
         THEN BEGIN
            b := false;
            inc ( j );
            loc [j] := succ ( i );
            Insert ( #3, s2, Loc [j] );
            Insert ( #3, dest, Loc [j] );
         END;

         IF b THEN BEGIN
            inc ( k );
            Delete ( s2, i, z ); {remove old}
            Insert ( TheNew, s2, i );
            Delete ( Dest, i, z ); {remove old}
            Insert ( TheNew, Dest, i );
         END ELSE BEGIN
            inc ( j );
            Loc [j] := succ ( i );  {insert #3 after i to break word}
            Insert ( #3, s2, Loc [j] );
            Insert ( #3, Dest, Loc [j] );
         END;
     END;

     IF j > 0
     THEN FOR i := j DOWNTO 1
     DO BEGIN
         Delete ( Dest, Loc [i], 1 );
     END;
     Result := Dest;
END;

FUNCTION  FormatTime ( Format : String; Time : TDateTime ) : TString;
VAR
Hour, Min, Sec, MSec : Word16;
h, m, s, ms : String [5];
s2 : String [32];
s3 : String [128];
BEGIN
  DecodeTime ( Time, Hour, Min, Sec, MSec );
  s2 := '';
  s3 := Format;

  IF pos ( 'am/pm', LowerCase ( Format ) ) > 0
  THEN BEGIN
     s2 := 'am';
     IF Hour > 11
     THEN BEGIN
        IF Hour > 12 THEN Dec ( Hour, 12 );
        IF Pos ( '/PM', Format ) > 0 THEN s2 := 'PM' ELSE s2 := 'pm';
     END ELSE IF Pos ( 'AM/', Format ) > 0 THEN s2 := 'AM';
     s3 := SeekReplace ( s3, 'AM/PM', s2, true, false );
  END ELSE
  IF pos ( 'a/p', LowerCase ( Format ) ) > 0
  THEN BEGIN
     s2 := 'a';
     IF Hour > 11
     THEN BEGIN
        IF Hour > 12 THEN Dec ( Hour, 12 );
        IF Pos ( '/P', Format ) > 0 THEN s2 := 'P' ELSE s2 := 'p';
     END ELSE IF Pos ( 'A/', Format ) > 0 THEN s2 := 'A';
     s3 := SeekReplace ( s3, 'a/m', s2, false, false );
     s3 := SeekReplace ( s3, 'A/M', s2, false, false );
  END ELSE
  IF pos ( 'ampm', Format ) > 0
  THEN BEGIN
     s2 := TimeAMString;
     IF Hour > 11
     THEN BEGIN
        IF Hour > 12 THEN Dec ( Hour, 12 );
        s2 := TimePMString;
     END;
     s3 := SeekReplace ( s3, 'ampm', s2, false, false );
  END;

  { convert time to string }
  h := IntToStr ( Hour );
  m := IntToStr ( Min );
  s := IntToStr ( Sec );
  ms := IntToStr ( MSec );

  { format }
  IF length ( h ) = 1 THEN IF pos ( 'hh', Format ) > 0 THEN h := '0' + h;
  IF length ( m ) = 1 THEN IF pos ( 'nn', Format ) > 0 THEN m := '0' + m;
  IF length ( m ) = 1 THEN IF pos ( 'mm', Format ) > 0 THEN m := '0' + m;
  IF length ( s ) = 1 THEN IF pos ( 'ss', Format ) > 0 THEN s := '0' + s;
  IF length ( ms ) = 1 THEN IF pos ( 'zzz', Format ) > 0 THEN ms := '000' + ms;

  s3 := SeekReplace ( s3, 'hh', h, true, false );
  s3 := SeekReplace ( s3, 'h', h, false, true );

  s3 := SeekReplace ( s3, 'nn', m, true, false );
  s3 := SeekReplace ( s3, 'n', m, false, true );

  s3 := SeekReplace ( s3, 'mm', m, true, false );
  s3 := SeekReplace ( s3, 'm', m, false, true );

  s3 := SeekReplace ( s3, 'ss', s, true, false );
  s3 := SeekReplace ( s3, 's', s, false, true );

  { - msecs not implemented
  s3 := SeekReplace ( s3, 'zzz', ms, true, false );
  s3 := SeekReplace ( s3, 'z', ms, false, true );
  }

  IF ( Pos ( ':', s3 ) > 0 ) AND ( TimeSeparator <> ':' )
   THEN s3 := SeekReplace ( s3, ':', TimeSeparator, false, false );

  Result := s3;
END;{* FormatTime *}

FUNCTION TimeToStr ( Time : TDateTime ) : TString;
{ use the format specified in: LongTimeFormat }
BEGIN
    Result := FormatTime ( LongTimeFormat, Time );
END;{* TimeToStr *}

FUNCTION  FileDateToStr ( FTime : Longint ) : TString;
BEGIN
   Result := DateTimeToStr ( FileDateToDateTime ( FTime ) );
END;{* FileDateToStr *}

FUNCTION FormatDate ( Format : String; Date : TDateTime ) : TString;
VAR
Year, Month, Day : Word16;
d, m, y : String [8];
s : String [255];
s1 : String [2];

BEGIN
  DecodeDate ( Date, Year, Month, Day );
  s := Format;

  d := IntToStr ( Day );
  m := IntToStr ( Month );
  y := IntToStr ( Year );

  { format }
  IF length ( d ) = 1 THEN IF pos ( 'dd', Format ) > 0 THEN d := '0' + d;
  IF length ( m ) = 1 THEN IF pos ( 'mm', Format ) > 0 THEN m := '0' + m;
  IF pos ( 'yyyy', Format ) = 0 THEN Delete ( y, 1, 2 );

  { days }
  IF Pos ( 'dddd', lowercase ( s ) ) > 0
  THEN BEGIN
    s := SeekReplace ( s, 'dddd', LongDayNames [DayOfWeek ( Date ) ], true, false );
  END;

  IF Pos ( 'ddd', lowercase ( s ) ) > 0
  THEN s := SeekReplace ( s, 'ddd', ShortDayNames [DayOfWeek ( Date ) ], true, false );

  { months }
  IF Pos ( 'mmmm', lowercase ( s ) ) > 0
  THEN s := SeekReplace ( s, 'mmmm', LongMonthNames [Month], true, false );

  IF Pos ( 'mmm', lowercase ( s ) ) > 0
  THEN s := SeekReplace ( s, 'mmm', LongMonthNames [Month], true, false );

  { others }
  s := SeekReplace ( s, 'dd', d, true, false );
  s := SeekReplace ( s, 'd', d, true, true );

  s := SeekReplace ( s, 'mm', m, true, false );
  s := SeekReplace ( s, 'm', m, true, true );

  s := SeekReplace ( s, 'yyyy', y, true, false );
  s := SeekReplace ( s, 'yy', y, true, false );

    { slash }
  IF ( Pos ( '/', s ) > 0 ) AND ( DateSeparator <> '/' )
  THEN s := SeekReplace ( s, '/', DateSeparator, false, false );
  { end format }
  Result := s;
END;{* FormatDate *}

FUNCTION DateToStr ( Date : TDateTime ) : TString;
{ use the format specified in: ShortDateFormat }
BEGIN
   Result := FormatDate ( ShortDateFormat, Date );
END;{* DateToStr *}

FUNCTION DateTimeToStr ( DateTime : TDateTime ) : TString;
BEGIN
   Result := DateToStr ( DateTime ) + ' ' + TimeToStr ( DateTime );
END;{* DateTimeToStr *}

function StrToDate (const S: string): TDateTime;
Var
mon, day, year : Word16;
t, t2 : TPStrings (4);
j, j2 : Integer;
k1, k2 : Word;
Begin
   Result := SysError;
   If (Pos (DateSeparator, s) = 0) then Exit;

   AssignPPStrings (t, 64);
   j := TokenizeString (s, t, [DateSeparator]);
   if j < 3
   then begin
      FreePPStrings (t);
      Exit;
   end;

   AssignPPStrings (t2, 64);
   j2 := TokenizeString (ShortDateFormat, t2, [DateSeparator]);
   if j2 < 3
   then begin
      FreePPStrings (t);
      FreePPStrings (t2);
      Exit;
   end;

   {dd/mm/yy; yy/mm/dd mm/dd/yy}
   k1 := Pos ('M', Uppercase (t2 [1]^));
   k2 := Pos ('M', Uppercase (t2 [2]^));

   // assume dd/mm/yy
   Day := StrToInt (t [1]^);
   Mon := StrToInt (t [2]^);
   Year:= StrToInt (t [3]^);

   If k1 > 0 // mm/dd/yy
   then begin
      Mon := StrToInt (t [1]^);
      Day := StrToInt (t [2]^);
      Year:= StrToInt (t [3]^);
   end else
   If k2 > 0 // dd/mm/yy or yy/mm/dd
   then begin
      If Pos ('D', Uppercase (t2 [1]^)) > 0 // dd/mm/yy
      then begin
         // do nothing
      end
      else begin // assume yy/mm/dd
         Year:= StrToInt (t [1]^);
         Mon := StrToInt (t [2]^);
         Day := StrToInt (t [3]^);
      end;
   end;

   // check for shortened year //
   If Year < 1000 then Year := Year + 2000;

   If (Mon > 12) or (Day > 31) then {error}
   else begin
      Result := EncodeDate (year, mon, day);
   end;
//   DisposePPStrings (@t);
//   DisposePPStrings (@t2);
   FreePPStrings (t);
   FreePPStrings (t2);
End; {* StrToDate *}

function StrToTime (const S: string): TDateTime;
Var
dt, tm : String [128];
i : Cardinal;
hour, min, sec : Word16;
Begin
   Result := SysError;
   If (Pos (TimeSeparator, s) = 0)
   then begin
      Exit;
   end;

   tm := s;

   {hour}
   i := Pos (TimeSeparator, tm);
   hour := StrToInt (Copy (tm, 1, Pred (i)));
   Delete (tm, 1, i);

   {min}
   i := Pos (TimeSeparator, tm);
   min := StrToInt (Copy (tm, 1, Pred (i)));
   Delete (tm, 1, i);

   {sec}
   sec := StrToInt (Trim(tm));

   {}
   If (Hour > 24) or (Min > 60) or (Sec > 60)
   Then //IOError ( EConvertError, False )
   else Result := EncodeTime (hour, min, sec, 500);
End;{* StrToTime *}

function StrToDateTime (const S: string): TDateTime;
Var
d, t: TDateTime;
dt, tm : String [128];
i : integer;
Begin
   dt := s;
   tm := s;
   i := Pos (' ', dt);
   Delete (dt, i, 128);
   Delete (tm, 1, i);


   d := StrToDate (dt);
   t := StrToTime (tm);

   Result := d + t;
  {
  if d >= 0
  then
    Result := d + t
    else Result := d - t;
   }
End;{* StrToDateTime *}

FUNCTION FormatDateTime ( CONST Format : string; DateTime : TDateTime ) : TString;
VAR
s1,
s, s3 : String [255];
i, j, k : byte;
tmp : String [1];
BEGIN
   s := '';
   tmp := '';
   s3 := Format;
   s3 := SeekReplace ( s3, 'dddddd', LongDateFormat, false, false );
   s3 := SeekReplace ( s3, 'ddddd', ShortDateFormat, false, false );
   s3 := SeekReplace ( s3, 'tt', LongTimeFormat, false, true );
   s3 := SeekReplace ( s3, 't', ShortTimeFormat, false, true );
   {}
   i := pos ( 'hh', s3 );
   IF i > 0 THEN BEGIN
      j := i;
      k := 0;
      FOR j := i TO length ( s3 )
      DO BEGIN
          inc ( k );
          s := s + s3 [j];
          IF s3 [j] = #32 THEN break;
      END;
      Delete ( s3, i, k );
   END;

   { ampm, am/pm, a/p: @@ very crude !! @@ }
   s1 := 'am/pm';
   i := pos ( s1, lowercase ( s3 ) );
   IF i > 0 THEN BEGIN
      IF s3 [pred ( i ) ] <> #32 THEN tmp := ' ';
      s := s + tmp + copy ( s3, i, length ( s1 ) );
      Delete ( s3, i, length ( s1 ) );
   END;

   s1 := 'ampm';
   i := pos ( s1, lowercase ( s3 ) );
   IF i > 0 THEN BEGIN
      IF s3 [pred ( i ) ] <> #32 THEN tmp := ' ';
      s := s + tmp + copy ( s3, i, length ( s1 ) );
      Delete ( s3, i, length ( s1 ) );
   END;

   s1 := 'a/p';
   i := pos ( s1, lowercase ( s3 ) );
   IF i > 0 THEN BEGIN
      IF s3 [pred ( i ) ] <> #32 THEN tmp := ' ';
      s := s + tmp + copy ( s3, i, length ( s1 ) );
      Delete ( s3, i, length ( s1 ) );
   END;

   Result := RemoveQuotes ( FormatDate ( s3, DateTime ) + '' + FormatTime ( s, DateTime ) );
END;{* FormatDateTime *}

FUNCTION DayOfWeek ( Date : TDateTime ) : Integer;
VAR
Day, Month, Year : Word16;
BEGIN
   DecodeDate ( Date, Year, Month, Day );
   Result := Succ ( GetDayOfWeek ( Day, Month, Year ) );
END;{* DayOfWeek *}

FUNCTION SameTime ( CONST A, B : TDateTime ) : Boolean;
VAR
aa, bb : TSystemTime;
BEGIN
  DateTimeToSystemTime ( A, aa );
  DateTimeToSystemTime ( B, bb );
  Result :=
        ( aa.wHour = bb.wHour )
  AND   ( aa.wMinute = bb.wMinute )
  AND   ( aa.wSecond = bb.wSecond )
  AND   ( aa.wMilliseconds = bb.wMilliSeconds )

END;{* SameTime *}

FUNCTION SameDate ( CONST A, B : TDateTime ) : Boolean;
VAR
aa, bb : TSystemTime;
BEGIN
  DateTimeToSystemTime ( A, aa );
  DateTimeToSystemTime ( B, bb );
  Result :=
        ( aa.wYear = bb.wYear )
  AND   ( aa.wMonth = bb.wMonth )
  AND   ( aa.wDay = bb.wDay )
END;{* SameDate *}

FUNCTION SameDateTime ( CONST A, B : TDateTime ) : Boolean;
BEGIN
   Result := ( SameDate ( A, B ) ) AND ( SameTime ( A, B ) );
END;{* SameDateTime *}

FUNCTION CompareTime ( CONST A, B : TDateTime ) : TValueRelationship;
VAR
aa, bb : TSystemTime;
BEGIN
  Result := EqualsValue;
  DateTimeToSystemTime ( A, aa );
  DateTimeToSystemTime ( B, bb );
  IF    ( aa.wHour = bb.wHour )
  AND   ( aa.wMinute = bb.wMinute )
  AND   ( aa.wSecond = bb.wSecond )
  AND   ( aa.wMilliseconds = bb.wMilliSeconds )
  THEN {}
  ELSE
  IF    ( aa.wHour > bb.wHour ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wHour < bb.wHour ) THEN Result := LessThanValue
  ELSE
  IF    ( aa.wMinute > bb.wMinute ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wMinute < bb.wMinute ) THEN Result := LessThanValue
  ELSE
  IF    ( aa.wSecond > bb.wSecond ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wSecond < bb.wSecond ) THEN Result := LessThanValue
  ELSE
  IF    ( aa.wMilliseconds > bb.wMilliSeconds ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wMilliseconds < bb.wMilliSeconds ) THEN Result := LessThanValue
END;{* CompareTime *}

FUNCTION CompareDate ( CONST A, B : TDateTime ) : TValueRelationship;
VAR
aa, bb : TSystemTime;
BEGIN
  Result := EqualsValue;
  DateTimeToSystemTime ( A, aa );
  DateTimeToSystemTime ( B, bb );
  IF    ( aa.wYear = bb.wYear )
  AND   ( aa.wMonth = bb.wMonth )
  AND   ( aa.wDay = bb.wDay )
  THEN {}
  ELSE
  IF    ( aa.wYear > bb.wYear ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wYear < bb.wYear ) THEN Result := LessThanValue
  ELSE
  IF    ( aa.wMonth > bb.wMonth ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wMonth < bb.wMonth ) THEN Result := LessThanValue
  ELSE
  IF    ( aa.wDay > bb.wDay ) THEN Result := GreaterThanValue
  ELSE
  IF    ( aa.wDay < bb.wDay ) THEN Result := LessThanValue
END;{* CompareDate *}

FUNCTION CompareDateTime ( CONST A, B : TDateTime ) : TValueRelationship;
VAR
D : TValueRelationship;
BEGIN
  D := CompareDate ( A, B );
  CASE D OF
    GreaterThanValue, LessThanValue :  Result := D;
      ELSE Result := CompareTime ( A, B );
  END; { case }
END;{* CompareDateTime *}

FUNCTION StringtoCharset ( CONST S : string; VAR c : TSysCharSet ) : Boolean;
VAR
i : Integer;
BEGIN
  c := [];
  FOR i := 1 TO Length ( s ) DO Include ( c, s [i] );
  Result := Length ( s ) > 0;
END;{* StringtoCharset *}

FUNCTION IsDelimiter ( CONST Delimiters, S : string; Index : Integer ) : Boolean;
VAR c : TSysCharSet;
BEGIN
  StringtoCharset ( Delimiters, c );
  Result := s [Succ ( Index ) ] IN c;
END;{* IsDelimiter *}

FUNCTION IsPathDelimiter ( CONST S : string; Index : Integer ) : Boolean;
BEGIN
  Result := s [Succ ( Index ) ] = DirSeparator;
END;{* IsPathDelimiter *}

FUNCTION LastDelimiter ( CONST Delimiters, S : string ) : Integer;
VAR
c : TSysCharSet;
i : Integer;
BEGIN
  Result := 0;
  StringtoCharset ( Delimiters, c );
  FOR i := Length ( s ) DOWNTO 1
  DO IF s [i] IN c
  THEN BEGIN
      Result := i;
      Exit;
  END;
END;{* LastDelimiter *}

Procedure FreePPStrings ( Var p : TPStrings );
Var i : Cardinal;
Begin
  For i := 1 to p.Count
  Do begin
      Dispose (p [i]);
      p [i] := Nil;
  End;
End; {* FreePPStrings *}

Procedure AssignPPStrings ( Var p : TPStrings; Size : Longint );
Var i : Cardinal;
Begin
  For i := 1 to p.Count
  Do begin
      New (p [i], Size);
      p [i]^ := '';
  End;
End; {* AssignPPStrings *}

Procedure ClearPPStrings ( Var p : TPStrings );
Var i : Cardinal;
Begin
  For i := 1 to p.Count do p [i]^ := '';
End; {* ClearPPStrings *}

Function TokenizeString ( Const Source : String; VAR Dest : TPStrings; Tokens : CharSet ) : Integer;
Var
i, Cnt, Len : Cardinal;
Ch : Char;
S : TString;
Begin
   Result := -1;
   Len := Length (Source);
   If Len = 0 then Exit;
   ClearPPStrings (Dest);

   Cnt := 0;
   i := 0;
   s := '';
   for Cnt := 1 to Len + 1
   do begin
       If (Source [Cnt] in Tokens) or (Cnt = Len)
       then begin
           If (Cnt = Len) and NOT (Source [Cnt] in Tokens) then s := s + Source [Cnt];
           Inc (i);
           Dest [i]^ := s;
           If i = Dest.Count then Break;
           s := '';
       end else s := s + Source [Cnt];
   end; { while }
   Result := i;
End; {* TokenizeStrings *}
{**********************************************************************}
function iPosFrom (const sub, str : String; from : Cardinal) : Cardinal;
begin
    iPosFrom := PosFrom (uppercase (sub), uppercase (str), from);
end;

function ExtendedPos (const sub, str : String; wholewords, ignorecase : boolean) : Cardinal;
const
nSeparators = ['a'..'z', 'A'..'Z', '_', '0'..'9'];
Markers = [#1..#47, #91..#94, #96, #123..#160, #161..#191];

Var
i, j : cardinal;

procedure findem (from : Cardinal);
Var
x, y : cardinal;
a, b : boolean;
begin
  if ignorecase
    then i := iPosFrom (sub, str, from)
      else i := PosFrom (sub, str, from);

   { found something - parse for wholewords }
   If (WholeWords) and (i <> 0) then begin
      x := i - 1;
      y := i + length (sub);

      { either end of string, or next char is a separator }
      b := (y >= length (str)) or (str [y] in Markers);

      { either start of string, or prev char is a separator }
      a := (x < 1) or (str [x] in Markers);
      if (NOT a) or (NOT b) then i := 0;
   end;
end;

begin
   ExtendedPos := 0;
   If (sub = '') or (str = '') then Exit;
   findem (1);

   { any match? check for whole words? }
   ExtendedPos := i;
end;

function wholepos (const sub, str : String; ignorecase : boolean) : Cardinal;
begin
   wholepos := ExtendedPos (sub, str, true, ignorecase);
end;

function StringReplaceInPlace (Var Src_Dest : String; const OldPattern, NewPattern: string;
Flags: TReplaceFlags): Integer;
VAR i, j : Cardinal;
BEGIN
    StringReplaceInPlace := 0; { nothing replaced }
    IF ( OldPattern = '' ) OR ( Src_Dest = '' ) OR (OldPattern = NewPattern)
    THEN exit;

    j := 0;
    i := ExtendedPos ( OldPattern, Src_Dest, rfWholeWords in Flags, rfIgnoreCase in Flags );

    While i > 0
    do begin
       Inc (j);
       Delete ( Src_Dest, i, Length ( OldPattern ) );
       Insert ( NewPattern, Src_Dest, i );

       if NOT (rfReplaceAll in Flags)
       then Break
       Else i := ExtendedPos ( OldPattern, Src_Dest, rfWholeWords in Flags, rfIgnoreCase in Flags );
    end;

    StringReplaceInPlace := j; { the number of replacements }
END;{ * StringReplaceInPlace *}


function StringReplace (const S, OldPattern, NewPattern: string;
Flags: TReplaceFlags): Tstring;
VAR
Dest : TString;
i : Cardinal;
BEGIN
    StringReplace := S;
    IF ( OldPattern = '' ) OR ( S = '' ) OR (OldPattern = NewPattern)
    THEN exit;

    Dest := S;
    i := ExtendedPos ( OldPattern, Dest, false, rfIgnoreCase in Flags );

    While i > 0
    do begin
      Delete ( Dest, i, Length ( OldPattern ) );
      Insert ( NewPattern, Dest, i );

      if NOT (rfReplaceAll in Flags)
      then Break
      Else i := ExtendedPos ( OldPattern, Dest, false, rfIgnoreCase in Flags );
    end;

    StringReplace := Dest;
END;{ * StringReplace *}

function StringReplaceWhole (const S, OldPattern, NewPattern: string;
Flags: TReplaceFlags): Tstring;
VAR
Dest : TString;
i : Cardinal;
BEGIN
    StringReplaceWhole := S;
    IF ( OldPattern = '' ) OR ( S = '' ) OR (OldPattern = NewPattern)
    THEN exit;

    Dest := S;
    i := ExtendedPos ( OldPattern, Dest, True, rfIgnoreCase in Flags );

    While i > 0
    do begin
      Delete ( Dest, i, Length ( OldPattern ) );
      Insert ( NewPattern, Dest, i );

      if NOT (rfReplaceAll in Flags)
      then Break
      Else i := ExtendedPos ( OldPattern, Dest, True, rfIgnoreCase in Flags );
    end;

    StringReplaceWhole := Dest;
END;{ * StringReplaceWhole *}

{**********************************************************************}
{++++++++++++ borrowed from FPC ++++++++++++++++++++++++}
Function FloatToStrF ( Value: Extended; format: TFloatFormat; Precision, Digits: Integer ) : TString;
Var
  P: Integer;
  Negative, TooSmall, TooLarge: Boolean;

Begin
  Case format Of

    ffGeneral:

      Begin
        If (Precision = -1) Or (Precision > 15) Then Precision := 15;
        TooSmall := (Abs(Value) < 0.00001) and (Value>0.0);
        If Not TooSmall Then
        Begin
          Str(Value:0:999, Result);
          P := Pos('.', Result);
          Result[P] := DecimalSeparator;
          TooLarge := P > Precision + 1;
        End;

        If TooSmall Or TooLarge Then
          begin
          Result := FloatToStrF(Value, ffExponent, Precision, Digits);
          // Strip unneeded zeroes.
          P:=Pos('E',result)-1;
          If P<>-1 then
             While (P>1) and (Result[P]='0') do
               begin
               Delete(Result,P,1);
               Dec(P);
               end;
          end
        else
          begin
          P := Length(Result);
          While Result[P] = '0' Do Dec(P);
          If Result[P] = DecimalSeparator Then Dec(P);
          SetLength(Result, P);
          end;
      End;

    ffExponent:

      Begin
        If (Precision = -1) Or (Precision > 15) Then Precision := 15;
        Str(Value:Precision + 8, Result);
        Result[3] := DecimalSeparator;
        P:=4;
        While (P>0) and (Digits < P) And (Result[Precision + 5] = '0') do
          Begin
          If P<>1 then
            Delete(Result, Precision + 5, 1)
          else
            Delete(Result, Precision + 3, 3);
          Dec(P);
          end;
        If Result[1] = ' ' Then
          Delete(Result, 1, 1);
      End;

    ffFixed:

      Begin
        If Digits = -1 Then Digits := 2
        Else If Digits > 15 Then Digits := 15;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then
          Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
      End;

    ffNumber:

      Begin
        If Digits = -1 Then Digits := 2
        Else If Digits > 15 Then Digits := 15;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
        Dec(P, 3);
        While (P > 1) Do
        Begin
          If Result[P - 1] <> '-' Then Insert(ThousandSeparator, Result, P);
          Dec(P, 3);
        End;
      End;

    ffCurrency:

      Begin
        If Value < 0 Then
        Begin
          Negative := True;
          Value := -Value;
        End
        Else Negative := False;

        If Digits = -1 Then Digits := CurrencyDecimals
        Else If Digits > 18 Then Digits := 18;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
        Dec(P, 3);
        While (P > 1) Do
        Begin
          Insert(ThousandSeparator, Result, P);
          Dec(P, 3);
        End;

        If Not Negative Then
        Begin
          Case CurrencyFormat Of
            0: Result := CurrencyString + Result;
            1: Result := Result + CurrencyString;
            2: Result := CurrencyString + ' ' + Result;
            3: Result := Result + ' ' + CurrencyString;
          End
        End
        Else
        Begin
          Case NegCurrFormat Of
            0: Result := '(' + CurrencyString + Result + ')';
            1: Result := '-' + CurrencyString + Result;
            2: Result := CurrencyString + '-' + Result;
            3: Result := CurrencyString + Result + '-';
            4: Result := '(' + Result + CurrencyString + ')';
            5: Result := '-' + Result + CurrencyString;
            6: Result := Result + '-' + CurrencyString;
            7: Result := Result + CurrencyString + '-';
            8: Result := '-' + Result + ' ' + CurrencyString;
            9: Result := '-' + CurrencyString + ' ' + Result;
            10: Result := CurrencyString + ' ' + Result + '-';
          End;
        End;
      End;
  End;
End; {* FloatToStrF *}

Function FloatToText ( Buffer: PChar; Value: Extended; format: TFloatFormat; Precision, Digits: Integer ) : Longint;
Var
  Tmp : String [40];
Begin
  Tmp := FloatToStrF (Value, format, Precision, Digits);
  Result := Length (Tmp);
  Move (Tmp[1], Buffer[0], Result);
End; {* FloatToText *}
{++++++++++++ end: borrowed from FPC ++++++++++++++++++++++++}
{**********************************************************************}
{**********************************************************************}

{ (initialization) }
TO BEGIN DO BEGIN
 {$ifdef UseW32API}    { get the correct Win32 version (Delphi) }
  WITH VerInfo
  DO BEGIN
     dwOSVersionInfoSize := Sizeof ( VerInfo );
     GetVersionEx ( VerInfo );
     Win32Platform := dwPlatformId;
  END;
 {$endif}
END;{ to begin do }

{ (finalization) }
TO END DO BEGIN
  { from Dos Unit }
  {$ifndef UseW32API}
  WHILE FindList <> nil
  DO BEGIN
      VAR i : Integer = IOResult;
      CloseFind ( @FindList );
      InOutRes := i
  END;
  {$endif}
END;{ to end do }

END.

