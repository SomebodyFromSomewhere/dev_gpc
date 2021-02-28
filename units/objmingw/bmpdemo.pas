{
***************************************************************************
*                 bmpdemo.pas
*
*  (c) Copyright 2003-2004, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This is a sample application showing how to use The Chief's
*  ObjectMingw object/class library
*
*  It compiles under GNU Pascal, FreePascal, and Delphi 4.0 and higher.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 7 May 2004
*  Version: 1.01
*  Licence: Shareware
*
***************************************************************************
}
PROGRAM bmpdemo;
{$X+}
{#apptype gui}

USES
Messages,
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs;

{$r bmpdemo.res}

TYPE
PNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TBitmapWindow )
    Button : TBitBtn;
    CONSTRUCTOR Init ( Owner : pWindowsObject; aTitle : pChar );
    FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
    PROCEDURE   Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;
    PROCEDURE   SetupWindow; VIRTUAL;
END;

PROCEDURE  TNewWindow.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
   INHERITED Paint ( aDC, Info );
   // make sure bitmap button always stays at bottom left
   Button.GotoXY ( 1, Height - ( Button.Height ) * 3 );
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
   INHERITED Init ( Owner, aTitle );
   WITH attr
   DO BEGIN
      x := 1;
      y := 1;
      w := 600;
      h := 400;
   END;
   LoadBitmapFromResource := True;
   BitmapResource := 'bitmap_1';
   Button.Init ( @Self, CM_FileExit, 'E&xit', 'exitbmp', 1, 310, 100, 30 );
END;

FUNCTION TNewWindow.ProcessCommands;
VAR
CommonDlg : TCommonFileDialog;
BEGIN
  Result := 0;
  CASE ID OF
      CM_FileOpen :
      BEGIN
         CommonDlg.Init ( SelfPtr, '*.bmp;*.rle', 255 );
         WITH CommonDlg
         DO BEGIN
            SetDescription ( 'Windows bitmaps files' );
            SetTitle ( 'Choose a bitmap file' );
            IF Execute = id_Ok
            THEN BEGIN
               IF Bitmap <> 0 THEN DeleteObject ( Bitmap );
               Stretched := True;
               LoadBitmapFromResource := False;
               LoadBitmapFile ( FileName );
               RepaintWindow; // force repaint OF window
            END;
            Done;
          END;
      END;
      CM_HelpAbout : ShowMessage ( 'This is a simple ObjectMingw Bitmap Demo Program' );
  ELSE
   Result := INHERITED ProcessCommands ( Msg, Id );
  END; // CASE
END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   INHERITED SetupWindow;
   WITH sMenu
   DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, '&Open ...', CM_FileOpen, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
END;

{*****}
TYPE
TNewApplication = OBJECT ( TApplication )
  PROCEDURE InitMainWindow; VIRTUAL;
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
  MainWindow := New ( PNewWindow, Init ( NIL, 'Bitmap Demo Application' ) );
END;

VAR
MyApp : TNewApplication;
BEGIN
  MyApp.Init ( '' );
  MyApp.Run;
  MyApp.Done;
END.

