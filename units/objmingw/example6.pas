{
***************************************************************************
*                 example6.pas
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
PROGRAM example6;
{#apptype gui}
{$X+}

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
AppName = 'Application with Buttons and Menu';

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

DisplayMessage : String [255] = 'This is a "WriteText" message.';

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TWindow )
   LocalFont : TFont;
   FCol,
   Loc : Integer;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
   PROCEDURE   Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;
   PROCEDURE   WMEraseBackGround ( VAR Msg : TMessage ); VIRTUAL;
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
  Attr.W := 550;
  Attr.H := 400;
  FCol := ColorRed;

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

  // DO some fancy font stuff
  FillChar ( LocalFont, Sizeof ( LocalFont ), #0 );
  WITH LocalFont
  DO BEGIN
      StrCopy ( Name, 'Arial' );
      Size := 30;
  END;

  WITH LocalFont.lFont DO
  BEGIN
     StrCopy ( lfFaceName, LocalFont.Name );
     lfQuality := Proof_Quality;
     lfWeight := FW_Normal;
     lfPitchAndFamily := Variable_Pitch OR FF_Roman;
     lfHeight := MulDiv ( LocalFont.Size, GetDeviceCaps ( WindowDC, LogPixelsY ), 72 );
     lfWeight := FW_Bold;
     lfClipPrecision := Clip_Default_Precis;
     lfOutPrecision := OUT_TT_PRECIS;
  END;
  LocalFont.Handle := CreateFontIndirect ( {$ifdef FPC}@{$endif}LocalFont.lFont );
END;

PROCEDURE  TNewWindow.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
   INHERITED Paint ( aDC, Info );
   DeleteObject ( LocalFont.Handle );
   LocalFont.Handle := CreateFontIndirect ( {$ifdef FPC}@{$endif}LocalFont.lFont );
   PaintClientArea ( FCol, ColorBlack );
   WriteText ( @LocalFont, 1, ( Height div 2 ) - LocalFont.Size,
               ColorRed, ColorGreen, DisplayMessage );
END;

PROCEDURE  TNewWindow.WMEraseBackGround ( VAR Msg : TMessage );
BEGIN
    INHERITED WMEraseBackGround ( Msg );
  { return 1 to prevent Windows painting the
  background - and to avoid flashes }
    Msg.Result := 1;
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
            THEN BEGIN
              DisplayMessage := FileName;
              // ShowMessage ( 'You selected: ' + FileName );
            END;
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
              FCol := ColorDlg.Color;

              // repaint client area
              RepaintWindow;
            END;
            ColorDlg.Done;
        END;

      CM_SelectFont :
        BEGIN
            FontDlg.Init ( SelfPtr );
            IF FontDlg.Execute = id_OK
            THEN BEGIN
              LocalFont := FontDlg.Font;
              RepaintWindow;
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
   WITH sMenu
   DO BEGIN
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
   MainWindow := New ( pNewWindow, Init ( NIL, AppName ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp
 DO BEGIN
     Init ( AppName );
     Run;
     Done;
  END;
END.

