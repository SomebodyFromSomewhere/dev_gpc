{
***************************************************************************
*                 custdemo.pas
*
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
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
*  Last modified: 08 January  2003
*  Version: 1.00
*  Licence: Shareware
*
***************************************************************************
}
PROGRAM custdemo;
{$X+}
{.$R-}
{#apptype gui}

USES
genutils,
Messages,
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs,
CustDlgs;

CONST
MaxButtons = 5;
id_ProgressDlg = 4001;
id_MemoDlg = 4002;
Id_ListDlg  = 4003;
AppName = 'Custom Dialog Demo';

VAR
Buttons : ARRAY [1..MaxButtons] OF TButton;

Captions : ARRAY [1..MaxButtons] OF pChar =
( 'Progress...', 'Memo ...', 'Listbox ...', 'About ...', 'Exit' );

CommandTags : ARRAY [1..MaxButtons] OF Integer =
( id_ProgressDlg, id_MemoDlg, Id_ListDlg, CM_HelpAbout, Cm_FileExit );

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow )
   ProgressDlg : TProgressDialog;
   ListDlg : TListBoxDialog;
   MemoDlg : TMemoDialog;
   Loc : Integer;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
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
      Buttons [i].Init ( SelfPtr, CommandTags [i], Captions [i], Loc, 2, 80, 25 );
  END;
END;

FUNCTION TNewWindow.ProcessCommands;
VAR
i : Byte;
BEGIN
  Result := 0;
  CASE ID OF
      CM_HelpAbout : ShowMessage ( 'Object Mingw custom dialog demo program.' );

      id_ProgressDlg :
      BEGIN
         ProgressDlg.Init ( SelfPtr, 'I am a Progress Dialog' );
         WITH ProgressDlg
         DO BEGIN
            {
            // let's show the hidden help button
            HelpButton.Visible := True;
            HelpButton.SetCaption ('Ok');
            }
            Execute; // same AS "Application^.MakeWindow ( @ProgressDlg ) "
            FOR i := 0 TO 100
            DO BEGIN
               // position the progress bar
               MoveBarTo ( i );

               // show stuff on each OF the message lines
               SetMessage ( 1, 'Message line 1. The current position is : ' + InttoStr ( Position ) );
               SetMessage ( 2, 'Message line 2. The current position is : ' + InttoStr ( Position ) );
               SetMessage ( 3, 'Message line 3. The current position is : ' + InttoStr ( Position ) );
               SetMessage ( 4, 'Message line 4. The current position is : ' + InttoStr ( Position ) );

               // delay a bit
               Delay ( 20 );
            END;
         END;
      END;

      id_MemoDlg :
      WITH MemoDlg
      DO BEGIN
         {
         Init ( @Self, 'Readme' );
         FileName := Application^.ExePath + 'overview.rtf';
         }
         InitWithFileName ( @Self, 'Readme', Application^.ExePath + 'overview.rtf' );
         Prompt := 'Here is some text for you!';
         Execute;
         Done;
      END;

      Id_ListDlg :
      WITH ListDlg
      DO BEGIN
         Init ( @Self, 'Dialog with listbox', False{True} );
         Prompt := 'Choose your favourite colour:';
         Strcopy ( OkBtnCaption, '&Yes' );
         Strcopy ( CancelBtnCaption, '&No' );
         Items.LoadFromStream
            ( 'Yellow,Blue,Black,Brown,White,Pink,Purple,Magenta,Cyan,Grey,Orange,Red,Green',
            [','] );
         IF Execute = ID_OK THEN ShowMessage ( 'Your favourite colour is ' + Selected );
         Done;
      END;
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
   WITH sMenu
   DO BEGIN
      Init ( SelfPtr );
      i := AddSubMenu ( '&File  ', 0 );
        AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
      i := AddSubMenu ( '&Help  ', 0 );
        AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
END;
{*********************************}
TYPE
TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
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

