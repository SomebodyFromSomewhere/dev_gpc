{
***************************************************************************
*                 timedemo.pas
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
PROGRAM timedemo;
{$X+}
{#apptype gui}

{$i cwindows.inc}

USES
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs;

CONST AppName = 'Timer Demo';

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow )
   Static : TStatic;
   Timer : TTimer;
   s : TString;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   DESTRUCTOR Done; VIRTUAL;
   PROCEDURE  WmTimer ( VAR Msg : TMessage );VIRTUAL;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
  InitParams ( Owner, aTitle, 1, 1, 200, 90 );
  s := TimeToStr ( Time );
  Static.Init  ( SelfPtr, 0, sChar ( s ), 1, 1, 200, 90 );
  WITH Static
   DO BEGIN
      Use3D := False;
      Attr.Style := Attr.Style OR ss_simple;
      WITH Font
      DO BEGIN
         Strcopy ( Name, 'Times New Roman' );
         Size := 35;
         Style := [fsBold];
         Color := ColorGreen;
         BackGround := ColorBlack;
      END;
   END;
   Timer.Init ( @Self, 100, 1000 );
END;

DESTRUCTOR TNewWindow.Done;
BEGIN
  Timer.Done;
  INHERITED Done;
END;

PROCEDURE TNewWindow.WmTimer ( VAR Msg : TMessage );
BEGIN
  IF Timer.Enabled
  THEN BEGIN
     Application^.ProcessMessages;
     s := TimeToStr ( Time );
     Application^.ProcessMessages;
     Static.SetCaption ( sChar ( s ) );
     Application^.ProcessMessages;
  END;
END;


{*****************************************}
TYPE
TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow; VIRTUAL;
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, AppName ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp
 DO BEGIN
     Init ( AppName );
     SleepInterval := 1; // let's yield some time slices
     Run;
     Done;
  END;
END.

