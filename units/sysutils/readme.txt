
GPC (PARTIAL) PORT OF DELPHI SYSUTILS UNIT
------------------------------------------

This package contains the latest public snapshot of the ongoing
project of  providing GPC with a Delphi(tm)-compatible "Sysutils"
unit. The unit is not (yet) complete, and all the routines have
not been exhaustively tested. 

The unit is portable and should compile on all recent GPC 
snapshots. It has been built and tested under Cygwin, Mingw, 
and Linux.

A small test program is included.

Please contact me if you do (or are willing to do) any of the 
following;
  [a] find bugs
  [b] write a test suite
  [c] contribute new routines
  [d] optimise or improve any of the existing routines


File List
---------
sysutils.pas		- the main sysutils unit sources
fromdos.inc		- routines borrowed from the GPC Dos unit
win.inc			- Win32-specific include file
others.inc		- non-Win32 stuff
testsys.pas		- small test program for sysutils unit
readme.txt		- this file
filectrl.pas		- beginnings of a GPC port of the Delphi filectrl unit



------------
Prof. Abimbola A Olowofoyeku (The African Chief)
Email: 	chiefsoft at bigfoot dot com
Web:	http:/www.greatchief.plus.com
