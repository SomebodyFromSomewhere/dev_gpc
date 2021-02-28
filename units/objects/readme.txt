GPC and TMT PORT OF FREEVISION (FV) OBJECTS UNIT
------------------------------------------------

This package contains a port of a BP-compatible OBJECTS unit 
in the FreeVision libraries to GNU Pascal (GPC). The version of
the OBJECTS unit contained herein is an old version (i.e., it is
not the most up-to-date) and has been amended by me primarily
to cater for GPC and also Delphi 2 to 7, and TMT Pascal. 

I have included all the files from the original FV package 
that are necessary to compile the objects unit. For GPC and TMT, 
only three files are needed (see below).

For the other supported compilers, you will need most of the files
in this package.


Files needed to compile with GPC
--------------------------------
platform.inc		- FV conditional definitions file
filegpc.inc		- GPC version of 'fileobj.inc' and 'objinc.inc'
objects.pas		- main unit sources

Files needed to compile with TMT
--------------------------------
platform.inc		- FV conditional definitions file
filetmt.inc		- TMT (Dos32) version of 'fileobj.inc' and 'objinc.inc'
objects.pas		- main unit sources


Complete File List
------------------
platform.inc		- FV conditional definitions file
fileobj.inc		- FV file routines and stuff
objinc.inc		- ditto -
emsobj.inc		- FV ems stuff - not relevant to GPC/TMT
xmsobj.inc		- FV xms stuff - not relevant to GPC/TMT
filegpc.inc		- GPC version of 'fileobj.inc' and 'objinc.inc'
filetmt.inc		- TMT (Dos32) version of 'fileobj.inc' and 'objinc.inc'
objects.pas		- main unit sources
testobj.pas		- simple test program


Licence
-------
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This sourcecode is distributed "AS IS" without       }
{   warranty, express, implied or statutory, including     }
{   but not limited to any implied warranties of any       }
{   merchantability and fitness for a particular purpose.  }
{   In no event shall anyone involved with the creation    }
{   and production of this product be liable for indirect, }
{   special, or consequential damages, arising out of any  }
{   use thereof or breach of any warranty.                 }
{                                                          }
{**********************************************************}


Bugs
----
If you find any bugs, please report them to me. Better still,
please fix them and then send me the fixes ;)

Disclaimer
----------
As noted above, this package and the source code contained therein
are supplied WITHOUT ANY WARRANTIES WHATSOEVER. You use the code
ENTIRELY AT YOUR OWN RISK, AND I ACCEPT NO RESPONSIBILITY FOR ANY
LOSS OR DAMAGE SUFFERED AS A RESULT OF THE USE OR THE PURPORTED USE
OF ANYTHING IN THIS PACKAGE, FOR ANY PURPOSE WHATSOEVER.

IF YOU ARE UNABLE TO ACCEPT ALL THESE CONDITIONS OR ANY OF THEM,
THEN PERMISSION TO USE THIS PACKAGE OR THE CODE THEREIN CONTAINED
IS HEREBY WITHDRAWN FROM YOU, AND YOU ARE REQUESTED TO DELETE THIS 
PACKAGE AND ALL ITS FILES FROM YOUR DISKS IMMEDIATELY AND PERMANENTLY.


------------
Prof. Abimbola A Olowofoyeku (The African Chief)
    Web: http://www.bigfoot.com/~african_chief/
    Email: African_Chief [at] bigfoot.com

February 2004
