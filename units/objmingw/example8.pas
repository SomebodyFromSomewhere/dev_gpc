{
***************************************************************************
*                 example8.pas
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
PROGRAM example8;
{#apptype gui}
{$X+}

USES
Messages,
Windows,
SysUtils,
cClasses,
cWindows,
cDialogs;

CONST
id_List  = ID_First + 300;  { list box }

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TWindow )
   List : TListBox;
   lStatic : TStatic;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
  INHERITED Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 550;
  Attr.H := 400;
  List.Init ( SelfPtr, id_List, 'ListBox', 2, 40, 400, 300 );
  // List.Sorted := True;

  lStatic.Init ( SelfPtr, 0, 'This is a Static control', 5, 1, 400, 25 );
  lStatic.Use3D := False;
  WITH lStatic.Font
  DO BEGIN
     StrCopy ( Name, 'Times New Roman' );
     Size := 14;
     Color := ColorRed{ColorCyan};
     // BackGround := ColorBlack;
     // Brush := GetStockObject ( LtGray_Brush );
  END;
END;

FUNCTION TNewWindow.ProcessCommands;
VAR
CommonDlg : TCommonFileDialog;
BEGIN
  Result := 0;
  CASE ID OF
      CM_FileOpen :
      BEGIN
         CommonDlg.Init ( SelfPtr, '*.lst', 255 );
         WITH CommonDlg
         DO BEGIN
            SetDescription ( 'Text files' );
            SetTitle ( 'Choose a file' );
            IF Execute = id_Ok
            THEN BEGIN
               List.Lines.LoadFromFile ( FileName );
               List.SetSelIndex ( 0 );
            END;
            Done;
          END;
      END;
      CM_FileExit : WMClose ( Msg );
      CM_HelpAbout : ShowMessage ( 'ObjectMingw Program with Listbox' );

      id_List :
      WITH Msg
      DO BEGIN
         CASE List.GetClickParam ( Msg ) OF // WParamhi
           LBN_DBLCLK :
           BEGIN
             ShowMessage ( List.Text );
             ShowMessage ( List.Lines.Text );
           END;
           LBN_KILLFOCUS : lStatic.SetText ( 'This is a Static control' );
            ELSE lStatic.SetText ( {$ifndef __GPC__}pChar{$endif} ( List.Text ) );
         END; // CASE
         Result := 0;
      END; // WITH Msg
  ELSE
   Result := INHERITED ProcessCommands ( Msg, Id );
  END; // CASE ID
END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   INHERITED SetupWindow;
   SetCaption ( 'Application with Listbox' );
   WITH sMenu DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, '&Open ...', CM_FileOpen, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );

       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&Help Topics ', CM_HelpTopics, 0 );
         AddMenuSeparator ( i );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;

   WITH List
   DO BEGIN
      AddString ( 'African' );
      AddString ( 'Chief' );
      Addstring ( 'Installer Pro' );
      Addstring ( 'Pascal Programming' );
      Addstring ( 'GNU Pascal' );
      Addstring ( 'Free Pascal' );
      Addstring ( 'Virtual Pascal' );
      Addstring ( 'Delphi Pascal' );
   END;

   lStatic.SetText ( 'This is a Static control: click on the listbox!' );
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, 'Hi there' ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp DO BEGIN
     Init ( 'Example 8' );
     Run;
     Done;
  END;
END.

