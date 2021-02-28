{
***************************************************************************
*                 example3.pas
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
PROGRAM example3;
{#apptype gui}

USES
Windows,
cWindows,
cDialogs;

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow ) { we are using TDialogWindow instead of TWindow }
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
  INHERITED Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 450;
  Attr.H := 350;
END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   INHERITED SetupWindow;
   SetCaption ( 'Application with Dialog Window and Menu' );

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

