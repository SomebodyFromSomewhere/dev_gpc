{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{            SAMPLE PROGRAM TO TEST THE GPC SYSUTILS UNIT                  }
{                                                                          }
{   Copyright (C) 2001 Free Software Foundation, Inc.                      }
{                                                                          }
{   Author: Prof. Abimbola Olowofoyeku <African_Chief@bigfoot.com>         }
{                                                                          }
{   This program is free software; you can redistribute it and/or          }
{   modify it under the terms of the GNU General Public License as         }
{   published by the Free Software Foundation, version 2.                  }
{                                                                          }
{   This program is distributed in the hope that it will be useful,        }
{   but WITHOUT ANY WARRANTY; without even the implied warranty of         }
{   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          }
{   GNU General Public License for more details.                           }
{                                                                          }
{   You should have received a copy of the GNU General Public License      }
{   along with this program; see the file COPYING. If not, write to        }
{   the Free Software Foundation, Inc., 59 Temple Place - Suite 330,       }
{   Boston, MA 02111-1307, USA.                                            }
{                                                                          }
{   As a special exception, if you incorporate even large parts of the     }
{   code of this demo program into another program with substantially      }
{   different functionality, this does not cause the other program to      }
{   be covered by the GNU General Public License. This exception does      }
{   not however invalidate any other reasons why it might be covered       }
{   by the GNU General Public License.                                     }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}

PROGRAM testsysutils;
{$X+}

USES
{$ifndef __GPC__}Windows{$else}GPC {$endif}, SysUtils;

{$ifdef  __GPC__}
{$implicit-result}
{$else}
{$ifndef linux}{$define __OS_DOS__}{$endif}
FUNCTION FileDateToStr ( i : longint ) : String;
BEGIN
  Result := DateTimeToStr ( FileDateToDateTime ( i ) );
END;
{$endif}

VAR
t : TSearchRec;
i, j, k : Longint;
{$ifdef __GPC__}
dd : DateTime;
{$else}
BadFileHandle : integer = - 1;
{$endif}
s, s1 : String [255];
p : ARRAY [0..255] OF char;
tf : {$ifdef __GPC__}TFileHandle{$else}Longint{$endif};
dt : TDateTime;
tss : TSystemTime;
p2 : pString;
p3, p4, p5 : pChar;
{$ifdef __GPC__}
i64 : int64;
w64 : word64;
{$endif}
BEGIN

   { no parameters - show syntax }
   IF paramcount = 0
   THEN BEGIN
      Writeln ( 'Syntax = ', ExtractFileName ( ParamStr ( 0 ) ),
                ' <filespec> [filename] ' );
      Writeln ( '   * the program will (inter alia) list files matching "filespec";' );
      Writeln ( '   * it will also manipulate (read-access only) "filename" in various ways.' );
      Halt;
   END;

   { list matching files }
   Writeln ( '*** Now, let''s look at files matching "', ParamStr ( 1 ), '"' );
   i := FindFirst ( ParamStr ( 1 ), faAnyFile, t );
   IF i = 0
   THEN BEGIN
    WHILE i = 0
    DO BEGIN
     WITH t DO BEGIN
       IF attr AND faDirectory <> 0
       THEN Writeln ( '<DIR> ', name )
       ELSE BEGIN
          Write ( name : 20, '  ', size : 12, '   ', attr : 5, '==' );
          {$ifdef __GPC__}
          WITH dd DO BEGIN
             UnPackFileDate ( time, dd );
             Writeln ( day : 2, '/', month, '/', year, ' ', hour, ':', min, ':', sec );
          END;
          {$else}
          Writeln;
          {$endif}
       END;{if attr }
     END;{with t }
      i := FindNext ( t );
    END; { while i = 0 }
    FindClose ( t );
   END; {if i = 0 }

   { file and directory stuff }
   Writeln;
   s1 := paramstr ( 2 );                  { filename? }
   IF s1 = '' THEN s1 := ParamStr ( 0 );  { none, so use running program }
   s := ExpandFileName ( s1 );            { get a fully qualified name }

   Writeln ( '*** We are working with (', s1, '): expanded path = ', s );
   writeln ( 'Current Dir   = ', GetCurrentDir );
   Writeln ( 'The Directory = ', ExtractFileDir ( s ) );
   Writeln ( 'The Path      = ', ExtractFilePath ( s ) );
   Writeln ( 'The Drive     = ', ExtractFileDrive ( s ) );
   Writeln ( 'The Filename  = ', ExtractFileName ( s ) );
   Writeln ( 'The Extension = ', ExtractFileExt ( s ) );
   Writeln ( 'The Attribute = ', FileGetAttr ( s ) );
   Writeln ( 'OS platform   = ', Win32Platform );
   Writeln;

   { file management routines using file handles }
   Writeln ( '*** We will now try to create a file, "foo.txt". ' );
   tf := FileCreate ( 'foo.txt' );
   IF tf <> BadFileHandle
   THEN BEGIN
      Writeln ( 'OK' );
      Writeln ( 'The File Handle = ', tf );
      StrpCopy ( p, s );
      i := FileWrite ( tf, p, StrLen ( p ) );
      Writeln ( 'Bytes Written   = ', i );
      FileClose ( tf );
      tf := FileOpen ( 'foo.txt', fmOpenRead );
      k := FileGetDate ( tf );
      FileClose ( tf );

      Writeln;
      Writeln ( '*** Some info about "foo.txt".' );
      Writeln ( 'The File Date   = ', k, ' (English = ', FileDateToStr ( k ), ')' );
      Writeln ( 'The File Date 2 = ', FileAge ( 'foo.txt' ),
             ' (English = ', FileDateToStr ( FileAge ( 'foo.txt' ) ), ')' );
   END
   ELSE Writeln ( 'I could not create "foo.txt".' );

   { date and time routines }
   Writeln;
   Writeln ( '*** Now let us use some date and time routines!' );
   Writeln ( 'Today''s Date = ', DateToStr ( Date ), ' (', LongDayNames [DayofWeek ( Date ) ], ')' );
   Writeln ( 'Current Time = ', TimeToStr ( Time ) );
   Writeln ( 'Date + Time  = ', DateTimeToStr ( Now ) );

   { changing formatting of date and time routines }
   Writeln;
   Writeln ( '*** Some more formatting of date and time routines!' );
   ShortDateFormat := 'dd/mm/yy';
   Writeln ( 'Today''s Date = ', DateToStr ( Date ) );
   ShortDateFormat := 'mm/dd/yyyy';
   Writeln ( 'Today''s Date = ', DateToStr ( Date ) );

   DateSeparator := '-';
   TimeSeparator := '.';

   Writeln;
   ShortDateFormat := 'yyyy/mm/dd';
   Writeln ( 'Today''s Date = ', DateToStr ( Date ) );
   ShortDateFormat := 'yyyy/dd/mm';
   Writeln ( 'Today''s Date = ', DateToStr ( Date ) );

   s := 'dddddd, "(Quoted dddd string)" = dddd mm dd yyyy hh:nn am/pm';
   Writeln ( FormatDateTime ( s, Now ) );

   Writeln;

   { disk information }
   {$ifdef __OS_DOS__}
   Write ( '*** Disk info: please put a disk in the A: drive and press <ENTER>' );
   Readln;
   Writeln;
   {$endif}
   FOR i := 0 TO {$ifdef __OS_DOS__}3{$else}0{$endif}
     DO Writeln ( 'Disk #', i, ' Size=', DiskSize ( i ),
                               ' bytes: Free=', DiskFree ( i ), ' bytes.' );

   { strings }
   Writeln;
   Writeln ( '*** Now, some (Pascal) string stuff!' );
   Writeln ( 'Quoted string: ', QuotedStr ( 'Abimbola ''is a'' Great Chief' ) );
   Writeln;
   s := 'True, Abimbola is a Chief, a true Chief and A true Olowofoyeku. The true African Chief.';
   AssignStr ( p2, s );
   writeln ( p2^ );
{$ifdef __GPC__}
   Writeln;
   Writeln ( '*** All occurrences of "true" will change to "Cool".' );
   Writeln;
   Writeln ( FindAndReplace  ( p2^, 'true', 'Cool', True, True ) );
   DisposeStr ( p2 );

   { pchar stuff }
   Writeln;
   Writeln ( '*** Now, some null terminated string (pChar) stuff!' );
   p3 := 'Take me to the bridge!';
   p4 := StrNext ( p3 );
   p5 := StrPrev ( p4 );
   Writeln ( 'Orig = ', p3 );
   Writeln ( 'Next = ', p4, ':  StrComp ( Next, Orig ) = ', StrComp ( p4, p3 ) );
   Writeln ( 'Prev = ', p5, ': StrComp ( Prev, Orig ) = ', StrComp ( p5, p3 ) );

   { numbers: write 'TRUE' if successful }
   Writeln;
   Writeln ( '*** Okay, let''s do some numerical stuff!' );
   Writeln ( 'StrtoInt : ', StrtoInt ( '50000' ) = 50000 );

   i64 := MakeInt64 (  - 1, 500000 );
   w64 := MakeWord64 ( 55000000, 12364393 );

   Writeln ( 'MakeInt64  (', i64, '): ', HiLong ( i64 ) = 500000, ', ', LoLong ( i64 ) = - 1 );
   Writeln ( 'MakeWord64 (', w64, '): ', HiWord32 ( w64 ) = 12364393, ', ', LoWord32 ( w64 ) = 55000000 );
{$endif __GPC__}
END.

