{
***************************************************************************
*                 thrdemo.pas
*
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This is a sample application showing how to use The Chief's
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
PROGRAM thrdemo;
{$X+}

{$i cwindows.inc}

USES Windows, cClasses;
{$ifndef __GPC__}
   {$ifndef VirtualPascal}
      {$apptype console}
   {$endif}
{$endif}

TYPE TNewThread = OBJECT ( tthread )
   PROCEDURE execute; VIRTUAL;
END;

PROCEDURE TNewThread.execute;
BEGIN
   WHILE NOT terminated
   DO BEGIN
      WRITE ( 'A' );
   END;
END;

FUNCTION MyThreadHandler ( Sender : pThread ) : DWORD; STDCALL;
BEGIN
  WITH Sender^
  DO BEGIN
     WHILE NOT terminated
     DO BEGIN
        WRITE ( 'B' );
     END;
     Result := ReturnValue;
  END;
END;

FUNCTION MyThreadHandler2 ( Sender : pThread ) : DWORD; STDCALL;
BEGIN
  WITH Sender^
  DO BEGIN
     WHILE NOT terminated
     DO BEGIN
         WRITE ( 'C' );
     END;
     Result := ReturnValue;
  END;
END;

VAR
vT, vT2 : TThread;
vF : TNewThread;

BEGIN
  vF.Init ( False );
  vT.InitHandler ( False, @MyThreadHandler );
  vT2.InitHandler ( False, @MyThreadHandler2 );
  Readln;
  {vF.Done;
  vT.Done;
  vT2.Done;}
END.

