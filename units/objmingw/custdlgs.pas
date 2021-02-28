{
***************************************************************************
*                 CustDlgs.pas
*  (c) Copyright 2003-2004, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements a Custom Dialogs unit for GNU Pascal for Win32.
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     To provide ready-made custom dialog objects
*
*    Objects:
*           TCustomDialog   (abstract parent)
*           TMemoDialog     (a dialog with a TextWindow control)
*           TListBoxDialog  (a dialog with a listbox/combobox control)
*           TProgressDialog (a dialog box with a progress bar, etc.)
*
*  It compiles under GNU Pascal, FreePascal, and Delphi 4.0 and higher.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 28 May 2004
*  Version: 1.01
*  Licence: Shareware
*
*  NOTES: this unit is work-in-progress; some things need more work !
***************************************************************************
}
UNIT CustDlgs;

INTERFACE
{$i cwindows.inc}

USES
Messages,
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs;

TYPE
pCustomDialog = ^TCustomDialog;
TCustomDialog = OBJECT ( TDialog ) // this IS an abstract parent - DO NOT use directly
   OkBtnCaption, CancelBtnCaption : ARRAY [0..32] OF Char; // captions FOR buttons
   FileName,          // any FileName TO be opened AND displayed
   Prompt : TString;  // any message TO display?
   PROCEDURE   SetupWindow;VIRTUAL;

   Private
     Static : TStatic;  // FOR displaying the prompt
     OkBtn, CancelBtn : TButton;   // OK AND Cancel buttons
END;

pMemoDialog = ^TMemoDialog;
TMemoDialog = OBJECT ( TCustomDialog )
   TextWindow : TRichEdit;
   ReadOnly : Boolean;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aCaption : pChar );
   CONSTRUCTOR InitWithFileName ( Owner : pWindowsObject; CONST aCaption : pChar; CONST FName : String );
   PROCEDURE   SetupWindow; VIRTUAL;
END;

pListBoxDialog = ^TListBoxDialog;
TListBoxDialog = OBJECT ( TCustomDialog )
   ListBox : pComboBox;
   Items : TStrings;
   Selected : TString;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aCaption : pChar; UseCombo : Boolean );
   PROCEDURE   SetupWindow; VIRTUAL;
   PROCEDURE   OK ( VAR Msg : TMessage );VIRTUAL;
   DESTRUCTOR  Done; VIRTUAL;

   Private
     lb : TListBox;
     cb : TComboBox;
END;

TYPE
pProgressDialog = ^TProgressDialog;
TProgressDialog = OBJECT ( TDialog )
  CancelButton,
  HelpButton : TButton;
  ProgressBar : TProgressBar;
  CONSTRUCTOR Init ( Owner : pWindowsObject; aCaption : pChar );
  PROCEDURE   Step; VIRTUAL;
  PROCEDURE   StepBy ( Delta : Integer ); VIRTUAL;
  PROCEDURE   MoveBarTo ( Destination : Integer ); VIRTUAL;
  PROCEDURE   SetPosition ( Destination : Integer ); VIRTUAL;
  PROCEDURE   SetMessage ( Line : Integer; CONST Msg : String ); VIRTUAL;
  FUNCTION    Position : Integer; VIRTUAL;

  Private
    Percent,
    Message1,
    Message2,
    Message3,
    Message4 : TStatic;
END;

IMPLEMENTATION

{********************************************************}
PROCEDURE TCustomDialog.SetupWindow;
BEGIN
   INHERITED SetupWindow;
   IF Prompt <> '' THEN Static.SetText ( sChar ( Prompt ) );
   IF Caption <> '' THEN SetCaption ( sChar ( Caption ) );
   IF Strlen ( OkBtnCaption ) > 0 THEN OkBtn.SetText ( OkBtnCaption );
   IF Strlen ( CancelBtnCaption ) > 0 THEN CancelBtn.SetText ( CancelBtnCaption );
END;
{********************************************************}
CONSTRUCTOR TMemoDialog.InitWithFileName ( Owner : pWindowsObject; CONST aCaption : pChar; CONST FName : String );
BEGIN
   Init ( Owner, aCaption );
   FileName := FName;
END;

CONSTRUCTOR TMemoDialog.Init;
VAR
x, y, w, h : Integer;
BEGIN
  x := 1;
  y := 1;
  w := 600;
  h := 400;
  InitTemplate ( Owner, aCaption, x, y, w, h );
  StrCopy ( OkBtnCaption, '' );
  StrCopy ( CancelBtnCaption, '' );
  Prompt := '';
  FileName := '';
  ReadOnly := False;
  Centred := False;        // don't centre on screen
  CentredInParent := True; // default to a centered within parent window
  Static.Init ( SelfPtr, 0, '',  7, 4, 200, 25 );
  OkBtn.Init ( SelfPtr, id_OK, '&Ok', (w div 2) - 160,  h - 30, 150, 25 );
  CancelBtn.Init ( SelfPtr, id_Cancel, 'C&ancel', (w div 2) + 10, h - 30,  150, 25 );
  TextWindow.Init ( SelfPtr, 0, '',  5, 30, w - 10, h - 80 );
  With TextWindow
  do begin
     WordWrap := False;
     Attr.Style := Attr.Style or WS_VScroll or WS_HSCroll;
  end;
  Name := 'TMemoDialog';
End;

Procedure TMemoDialog.SetupWindow;
Begin
   TextWindow.WordWrap := TextWindow.IsRtfFile (FileName);
   TextWindow.ReadOnly := ReadOnly;
   Inherited SetupWindow; { must be here }
   If FileName <> ''
   then begin
      TextWindow.ReadFromFile (FileName);
   end;
End;

{********************************************************}
Constructor TListBoxDialog.Init;
Var
x, y, w, h : Integer;
Begin
  x := 1;
  y := 1;
  w := 450;
  h := 300;
  InitTemplate ( Owner, aCaption, x, y, w, h );
  StrCopy ( OkBtnCaption, '' );
  StrCopy ( CancelBtnCaption, '' );
  Centred := False;        // don't centre on screen
  CentredInParent := True; // default TO a centered within parent window

  Static.Init ( SelfPtr, 0, '',  30, 4, w - 40, 45 );
  OkBtn.Init ( SelfPtr, id_OK, '&Ok', ( w div 2 ) - 140,  h - 30, 130, 25 );
  CancelBtn.Init ( SelfPtr, id_Cancel, 'C&ancel', ( w div 2 ) + 10, h - 30,  130, 25 );

  IF UseCombo // use a combo box instead OF a listbox
  THEN begin
     cb.Init ( SelfPtr, 0, aCaption, 30, 45, w - 60, h - 110 );
     ListBox := pComboBox ( cb.SelfPtr );
  end else begin
     lb.Init ( SelfPtr, 0, aCaption, 30, 45, w - 60, h - 110 );
     ListBox := pComboBox ( lb.SelfPtr );
  end;
  {
  IF UseCombo
  THEN
     ListBox := New ( pComboBox, Init ( SelfPtr, 0, aCaption, 30, 45, w - 60, h - 110 ) )
  ELSE
     ListBox := New ( pListBox, Init ( SelfPtr, 0, aCaption, 30, 45, w - 60, h - 110 ) );
  }
  Items.Create;
  Items.Sorted := False;

  Name := 'TListBoxDialog';
END;

PROCEDURE TListBoxDialog.OK ( VAR Msg : TMessage );
BEGIN
   Selected := ListBox^.Text;
   INHERITED Ok ( Msg );
END;

PROCEDURE TListBoxDialog.SetupWindow;
BEGIN
   INHERITED SetupWindow;
   IF Items.Count > 0
   THEN WITH ListBox^
   DO BEGIN
      Lines.AddStrings ( Items );
      SetSelIndex ( 0 );
   END;
END;

DESTRUCTOR  TListBoxDialog.Done;
BEGIN
   ListBox^.Done;
   Items.Done;
   INHERITED Done;
END;

{********************************************************}
PROCEDURE   TProgressDialog.Step;
BEGIN
  ProgressBar.StepIt;
END;

PROCEDURE   TProgressDialog.StepBy ( Delta : Integer );
BEGIN
  ProgressBar.StepBy ( Delta );
END;

PROCEDURE   TProgressDialog.MoveBarTo ( Destination : Integer );
BEGIN
  ProgressBar.Position ( Destination );
END;

PROCEDURE   TProgressDialog.SetPosition ( Destination : Integer );
BEGIN
  MoveBarTo ( Destination );
END;

FUNCTION TProgressDialog.Position : Integer;
BEGIN
   Result := ProgressBar.CurrentPos;
END;

PROCEDURE   TProgressDialog.SetMessage ( Line : Integer; CONST Msg : String );
VAR
p : pStatic;
BEGIN
  p := NIL;
  CASE Line OF
     1 : p := @Message1;
     2 : p := @Message2;
     3 : p := @Message3;
     4 : p := @Message4;
  END;

  IF Assigned ( p )
  THEN BEGIN
      p^.SetCaption ( sChar ( Msg ) );
  END;
END;

CONSTRUCTOR TProgressDialog.Init;
VAR
x1 : Integer;
BEGIN
  InitTemplate ( Owner, aCaption, 10, 20, 450, 220 );
  CentredInParent := True;
  IsModal := False;  // we want TO be a modeless dialog

  x1 := 20;

  // Buttons
  CancelButton.Init ( SelfPtr, id_Cancel, 'Cancel', 170, 180, 100, 25 );
  HelpButton.Init ( SelfPtr, id_Ok, 'Help', 330, 180, 100, 25 );
  HelpButton.Visible := False; // default TO hiding this button

  // progress bar
  ProgressBar.Init ( SelfPtr, 0, x1, 75, 380, 30 );
  Percent.Init     ( SelfPtr, 0, '0%', 405, 80, 45, 20 );
  ProgressBar.StaticControl := @Percent;

  // controls FOR messages
  Message1.Init ( SelfPtr, 0, 'Message1', x1, 10,  400, 25 );
  Message2.Init ( SelfPtr, 0, 'Message2', x1, 50,  400, 25 );
  Message3.Init ( SelfPtr, 0, 'Message3', x1, 110, 400, 25 );
  Message4.Init ( SelfPtr, 0, 'Message4', x1, 140, 400, 25 );

  // clear message boxes
  FOR x1 := 1 TO 4 DO SetMessage ( x1, ' ' );
END;

{********************************************************}
{********************************************************}
{********************************************************}
END.
