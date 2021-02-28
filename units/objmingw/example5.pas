{
***************************************************************************
*                 example5.pas
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
PROGRAM example5;
{#apptype gui}

USES
Windows,
SysUtils,
cClasses,
cWindows,
cDialogs;

CONST
MaxButtons = 5;
CM_SelectColor = 2000;
CM_SelectFont = 2001;

VAR
Buttons : ARRAY [1..MaxButtons] OF TButton;

Hints : ARRAY [1..MaxButtons] OF String [64] =
( 'File open dialog',
  'Colour dialog',
  'Font dialog',
  'Another tedious "About" message ',
  'Close this application' );

Captions : ARRAY [1..MaxButtons] OF pChar =
( 'Open ...', 'Colour ...', 'Font ...', 'About ...', 'Exit' );

CommandTags : ARRAY [1..MaxButtons] OF Integer =
( CM_FileOpen, CM_SelectColor, CM_SelectFont, CM_HelpAbout, Cm_FileExit );

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TWindow )
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

CONSTRUCTOR TNewWindow.Init;
VAR
 Loc,
 i : Integer;
BEGIN
  INHERITED Init ( Owner, aTitle );
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 480;
  Attr.H := 350;
  FOR i := 1 TO MaxButtons
  DO BEGIN
      IF i = 1 THEN Loc := 1 ELSE Loc := Pred ( i ) * 72;
      Buttons [i].Init ( SelfPtr, CommandTags [i], Captions [i], Loc, 0, 70, 25 );
      WITH Buttons [i]
      DO BEGIN
          ShowHint := True;
          Hint := Hints [i];
      END;
  END;
END;

FUNCTION TNewWindow.ProcessCommands;
VAR
CommonDlg : TCommonFileDialog;
ColorDlg : TColorDialog;
FontDlg : TFontDialog;
BEGIN
  Result := 0;
  CASE ID OF
      CM_FileOpen :
      BEGIN
         CommonDlg.Init ( SelfPtr, '*.*', 255 );
         WITH CommonDlg
         DO BEGIN
            SetDescription ( 'All files' );
            SetTitle ( 'Choose a file' );
            IF Execute = id_Ok
              THEN ShowMessage ( 'You selected: ' + FileName );
            Done;
          END;
      END;
      CM_FileExit : WMClose ( Msg );
      CM_HelpAbout : ShowMessage ( 'This is a Simple ObjectMingw Program' );
      CM_SelectColor :
        BEGIN
            ColorDlg.Init ( SelfPtr );
            IF ColorDlg.Execute = id_OK
            THEN BEGIN
              ShowMessage ( 'You chose this colour: ' + IntToStr ( ColorDlg.Font.Color ) );
            END;
            ColorDlg.Done;
        END;

      CM_SelectFont :
        BEGIN
            FontDlg.Init ( SelfPtr );
            IF FontDlg.Execute = id_OK
            THEN BEGIN
              ShowMessage ( 'You chose: ' + FontDlg.Font.Name +
              ', colour: ' + IntToStr ( FontDlg.Font.Color ) +
              ', size  : ' + IntToStr ( FontDlg.Font.Size ) + ' points.' );
              Buttons [3].AssignFont ( FontDlg.Font );
            END;
            FontDlg.Done;
        END;
  {****** Case ****}
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

