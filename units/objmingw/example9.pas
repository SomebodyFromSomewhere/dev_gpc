{
***************************************************************************
*                 example9.pas
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
PROGRAM example9;
{#apptype gui}
{$i cwindows.inc}

USES
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs;

{$R example9.res}

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow )
   Url : TUrl;
   Radio,
   Radio2 : TRadioButton;
   Check : TCheckBox;
   Static,
   Static2 : TStatic;
   Edit : TEdit;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

// event handler FOR when static control IS clicked
PROCEDURE StaticClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
   WITH pStatic ( Sender ) ^
   DO
   Messagebox ( ParentHandle, sChar ( Caption ), sChar ( Name ), 0 );
END;

// event handler FOR when static2 control IS clicked
PROCEDURE ExitStaticClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
   Sender^.Parent^.CloseMe;
END;

// event handler FOR when checkbox IS clicked
PROCEDURE CheckBoxClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
  WITH pCheckBox ( Sender ) ^
  DO BEGIN
     IF Checked THEN
       Messagebox ( ParentHandle, 'I have been checked!', Attr.Title, 0 )
     ELSE
       Messagebox ( ParentHandle, 'I am not checked at all', Attr.Title, 0 )
  END;
END;

// event handler FOR when radio button IS clicked
PROCEDURE RadioClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
  WITH pRadioButton ( Sender ) ^
  DO BEGIN
     IF Tag = 100 THEN
       Messagebox ( ParentHandle, 'The first is checked', Attr.Title, 0 )
     ELSE
       Messagebox ( ParentHandle, 'The second is checked', Attr.Title, 0 )
  END;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
  INHERITED Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 450;
  Attr.H := 350;

  // some controls
  Check.Init ( SelfPtr, 0, 'This is a Check Box ', 5, 5, 200, 25 );
  Check.OnClick := CheckBoxClick;

  Radio.Init ( SelfPtr, 0, 'This is Radio Button #1 ', 5, 45, 200, 25 );
  Radio.Tag := 100;
  Radio.OnClick := RadioClick;

  Radio2.Init ( SelfPtr, 0, 'This is Radio Button #2 ', 205, 45, 200, 25 );
  Radio2.Tag := 200;
  Radio2.OnClick := RadioClick;

  URL.Init ( SelfPtr, 0, 'Clickable Link (explorer) ', 5, 85, 200, 25 );
  Url.Link := 'explorer.exe';

  Static.Init  ( SelfPtr, 0, 'This is a Static control ', 5, 125, 200, 25 );
  WITH Static
   DO BEGIN
      Use3D := True;
      OnClick := StaticClick;
      Attr.Style := Attr.Style OR ss_simple;
      Cursor := LoadCursor ( _hInstance, 'hand3' );
      WITH Font
      DO BEGIN
         Strcopy ( Name, 'Times New Roman' );
         Size := 14;
         Style := [fsItalic];
         Color := ColorRed;
      END;
   END;

  Static2.Init  ( SelfPtr, 0, 'Click here to Exit ', 5, 165, 200, 25 );
  WITH Static2
   DO BEGIN
      Use3D := True;
      OnClick := ExitStaticClick;
      Attr.Style := Attr.Style OR ss_simple;
      Cursor := LoadCursor ( _hInstance, 'hand' );
      WITH Font
      DO BEGIN
         StrCopy ( Name, 'Arial' );
         Size := 10;
         Style := [fsUnderline];
         Color := ColorBlue;
      END;
   END;

   Edit.Init ( SelfPtr, 0, ' This is an Edit control ', 5, 205, 200, 25 );
   WITH Edit.Font
   DO BEGIN
      Color := ColorRed;
      BackGround := ColorYellow;
   END;

END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   INHERITED SetupWindow;
   SetCaption ( 'Application with various controls' );

   WITH sMenu DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
   END;
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, 'example9' ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp DO BEGIN
     Init ( 'example9' );
     Run;
     Done;
  END;
END.

