{
***************************************************************************
*                 example1.pas
*
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This is a sample application showing how NOT to use The Chief's
*  ObjectMingw object/class library
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal,
*  and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 08 January 2003
*  Version: 1.00
*  Licence: Shareware
*
***************************************************************************
}
PROGRAM Example1;
{#apptype gui}

USES
Windows,
cWindows;

{
  This cannot do anything really useful. To be useful, the TWindow
  object needs to be subclassed (see example2.pas)
}
VAR Win : TWindow;

BEGIN
  WITH Win
  DO BEGIN
     Init ( NIL, 'Hello World!' );
     WITH Attr
     DO BEGIN
        x := 1;
        y := 1;
        w := 450;
        h := 350;
     END;
     Show ( sw_Normal );
     Done;
  END;
END.

