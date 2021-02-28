WINAPI IMPORT UNITS FOR GPC
---------------------------

This package represents the current state of play in providing
GPC versions of the Delphi(tm) Messages and Windows units. These
can be used with the Win32 ports of GPC (Mingw and Cygwin), but
it may also be possible to use them with WINE under unix/linux.
In this effort I have tried to follow the Delphi(tm) 1.0 and Borland 
Pascal for Windows conventions of naming the units - so I have
produced 3 proper UNITs;

	MESSAGES

	WINTYPES \
                  ----- WINDOWS
	WINPROCS /

plus a few dummy units and some partially completed units.

Delphi 2.0 and subsequent versions of Delphi merge "Wintypes" and
"Winprocs" into a single "Windows" unit. I have also followed that 
convention, with a "Windows" unit that is basically a wrapper for 
the Wintypes and Winprocs units.

At present, there are a number of ways of using the sources in your programs;

1. By putting each of them in the USES clause - e.g.,
      Program Test1;
      USES Messages, Wintypes, Winprocs;
      Begin
        {blah blah}
      End.

2. By USEing just the Messages and Windows units - e.g.,
      Program Test2;
      USES Messages, Windows;
      Begin
        {blah blah}
      End.

3. By INCLUDEing "windows.inc" in your program - e.g.,
      Program Test3;
      {$include windows.inc}
      Begin
        {blah blah}
      End.


The code is based mainly on *very old* GCC Win32 API headers, which
have been translated by me into Pascal.

The MESSAGES and WINTYPES units should be usable with other 
Windows Pascal compilers with little modification. The 
WINPROCS unit on the other hand uses more GPC-specific features
(for example, the declarations of imported functions only needs
to happen once - in the INTERFACE section). It will require
some work to make the unit compile if using other Pascal 
compilers. This should be achievable by the use of IFDEFs, so
that a single source code base can be maintained.

FILE LIST
---------
1. messages.pas    	- Win32 messages
2. wintypes.pas		- Win32 type definitions
3. winprocs.pas		- Win32 API imports
4. win32.inc		- some generic definitions
4A. windows.inc		- for INCLUDEing the Winapi sources instead of USEing them
5. windows.pas		- Unified "wintypes" and "winprocs" units
6. moretype.inc		- Extra Win32 types (from Virtual Pascal)
7. wingui.pas		- Simple GUI test program, using Win32 API calls
8. RichEdit.pas		- Dummy unit for compatibility
9. commctrl.pas		- Dummy unit for compatibility
10. commdlg.pas		- Dummy unit for compatibility
11. shellapi.pas	- partial shellapi unit 
12. ole2.pas		- Dummy unit for compatibility
13. shlobj.pas		- partial shlobj unit 
14. activex.pas		- partial activex unit 
15. winsock.pas		- GPC port of the FreePascal (FPC) winsock unit
16. readme.txt		- this file
17. copying		- Licence terms for some of the files
18. copying.fpc		- FPC Licensing terms for winsock.pas


LICENCE
-------
As is obvious from the comments in the sources, the original 
GCC headers for the MESSAGES, WINTYPES and WINPROCS units were 
released under the LGPL (the GNU Library General Public License). 
These three units are hereby released under a modified version
of the new LGPL (version 2.1), now called the GNU Lesser General 
Public License. A copy of this licence is in the file "COPYING" 
which is part of this package.

The "winsock" unit is based on FreePascal code, and is released
under the LGPL (on the same terms as other FreePascal units - see
the file "copying.fpc").

The "moretype.inc" file is derived from source code for the
Virtual Pascal WINDOWS unit. Virtual Pascal is a freeware Pascal
compiler for Win32 and OS/2. It is copyrighted by Allan Mertner
(vpascal@vpascal.com). The Virtual Pascal code has been amended 
by me and is used herein with the kind permission of Allan Mertner. 

Moretype.inc is released as freeware, as is any other file that is
so marked in the file itself and any file that does not specify its
licensing terms.

-------------------
August 2007,
Prof.   Abimbola A Olowofoyeku (The African Chief)
Email:  chiefsoft at bigfoot dot com
WWW:    http://www.greatchief.plus.com
