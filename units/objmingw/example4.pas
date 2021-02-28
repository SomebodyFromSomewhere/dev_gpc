{
***************************************************************************
*                 example4.pas
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
PROGRAM example4;
{#apptype gui}

USES
Windows,
cClasses,
cWindows,
cDialogs;

CONST
MaxButtons = 5;

VAR
Buttons : ARRAY [1..MaxButtons] OF TButton;

VAR
Captions : ARRAY [1..MaxButtons] OF pChar =
( 'Button 1', 'Button 2', 'Button 3', '&About ...', 'E&xit' );

CommandTags : ARRAY [1..MaxButtons] OF Integer =
( 0, 0, 0, CM_HelpAbout, Cm_FileExit );

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow )
   Loc : Integer;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

CONSTRUCTOR TNewWindow.Init;
VAR
 i : Integer;
BEGIN
  INHERITED Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 480;
  Attr.H := 350;
  FOR i := 1 TO MaxButtons
  DO BEGIN
      IF i = 1 THEN Loc := 1 ELSE Loc := Pred ( i ) * 90;
      Buttons [i].Init ( SelfPtr, CommandTags [i], Captions [i], Loc, 0, 80, 25 );
  END;
END;

FUNCTION TNewWindow.ProcessCommands;
BEGIN
  Result := 0;
  CASE ID OF
      CM_FileExit : WMClose ( Msg );
      CM_HelpAbout : ShowMessage ( 'This is a Simple ObjectMingw Program' );
  ELSE
   Result := INHERITED ProcessCommands ( Msg, Id );
  END;
END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   INHERITED SetupWindow;
   SetCaption ( 'Application with Buttons and Menu' );
   WITH sMenu DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, '&New', CM_FileNew, 0 );
         AddMenuItem ( i, '&Open ...', CM_FileOpen, 0 );
         AddMenuItem ( i, '&Save', CM_FileSave, 0 );
         AddMenuItem ( i, 'Save &As ...', CM_FileSaveAs, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, '&Print ...', CM_FilePrint, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
       i := AddSubMenu ( '&Edit  ', 0 );
         AddMenuItem ( i, '&Undo', CM_EditUndo, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'Cu&t', CM_EditCut, 0 );
         AddMenuItem ( i, '&Copy', CM_EditCopy, 0 );
         AddMenuItem ( i, '&Paste', CM_EditPaste, 0 );
         AddMenuItem ( i, 'De&lete', CM_EditDelete, 0 );
       i := AddSubMenu ( '&Search  ', 0 );
         AddMenuItem ( i, '&Find ...', CM_SearchFind, 0 );
         AddMenuItem ( i, 'Find &Next', CM_SearchFindNext, 0 );
         AddMenuItem ( i, '&Replace ...', CM_SearchReplace, 0 );
       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&Help Topics ', CM_HelpTopics, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, 'Hi there' ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp DO BEGIN
     Init ( 'Ha' );
     Run;
     Done;
  END;
END.

