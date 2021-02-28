{
***************************************************************************
*                 dlgdemo.pas
*
*  (c) Copyright 2003-2004, Professor Abimbola A Olowofoyeku (The African Chief)
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
*  Last modified: 28 May 2004
*  Version: 1.01
*  Licence: Shareware
*
***************************************************************************
}
PROGRAM dlgdemo;
{$X+}
{#apptype gui}

USES
Messages,
Sysutils,
Windows,
cClasses,
cWindows,
cDialogs;

CONST
MaxButtons = 5;
id_Edit    = 4000;
id_RadioGroup = 4001;
id_EditBox = 4002;
Id_Dialog  = 4003;
Id_Combo   = 4004;
AppName = 'Demo showing use of dialogs';

VAR
Buttons : ARRAY [1..MaxButtons] OF TButton;

VAR
Captions : ARRAY [1..MaxButtons] OF pChar =
( 'Group ...', 'Edit box ...', 'Dialog ...', 'About ...', 'Exit' );

CommandTags : ARRAY [1..MaxButtons] OF Integer =
( id_RadioGroup, id_EditBox, Id_Dialog, CM_HelpAbout, Cm_FileExit );

CONST
MaxColors = 8;

VAR
MyColors : ARRAY [0..MaxColors] OF TColorRef = (
  ColorRed,
  ColorGreen,
  ColorYellow,
  ColorCyan,
  ColorBlue,
  ColorLightGray,
  ColorButton,
  ColorPurple,
  ColorMagenta
  );

ColorNames : ARRAY [0..MaxColors] OF pChar = (
  'Red',
  'Green',
  'Yellow',
  'Cyan',
  'Blue',
  'Light Gray',
  'Button Face',
  'Purple',
  'Magenta'
  );

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TDialogWindow )
   Loc : Integer;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
   PROCEDURE   RadioGroupDialog;
END;

TYPE
pNewDialogWindow = ^TNewDialogWindow;
TNewDialogWindow = OBJECT ( TDialogWindow )
   OkBtn,
   CancelBtn : TButton;
   Static : TStatic;
   Edit : TEdit;
   Combo : TComboBox;
   CONSTRUCTOR InitParams ( Owner : pWindowsObject; CONST aTitle : pChar; x, y, w, h : Integer );
   PROCEDURE SetupWindow; VIRTUAL;
   FUNCTION ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
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

PROCEDURE OkButtonClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
   WITH pNewDialogWindow ( Sender^.Parent ) ^
   DO BEGIN
      Messagebox ( Handle, Edit.TextpChar, Sender^.Attr.Title, 0 );
   END;
END;

PROCEDURE CancelButtonClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
   WITH pNewDialogWindow ( Sender^.Parent ) ^
   DO BEGIN
      ShowMessage ( 'You chose the colour ' + Combo.Text );
      CloseMe;
   END;
END;

CONSTRUCTOR TNewDialogWindow.InitParams;
BEGIN
   // create from memory template
   INHERITED InitParams ( Owner, aTitle, x, y, w, h );

   // ok button
   OkBtn.Init ( SelfPtr, id_Ok, 'Ok', ( Attr.W Div 2 ) - 110,
              Attr.h - 60,  100, 25 );
   OkBtn.OnClick := OkButtonClick; // assign event handler

   // cancel button
   CancelBtn.Init ( SelfPtr, id_Cancel, 'Cancel', ( Attr.W Div 2 ),
                  Attr.h - 60,  100, 25 );
   CancelBtn.OnClick := CancelButtonClick; // assign event handler

   // static control
   Static.Init ( SelfPtr, 0,
   'This dialog box has been created programmatically (i.e., no dialog resource!).'^M^M'(c)2004 Prof. A Olowofoyeku',
   20, 20,  350, 100 );

   // let's do some crazy things with the font!
   Static.Use3D := False;
   WITH Static.Font
   DO BEGIN
      StrCopy ( Name, 'MS Sans Serif' );
      Size := 12;
      Color := ColorCyan;
      BackGround := ColorBlack;
      Brush := CreateSolidBrush (ColorPurple);  // purple brush!
   END;

   // edit box
   Edit.Init (SelfPtr, id_Edit,
             'Professor A. Olowofoyeku is the African Chief!',
             20, 110, 400, 25);
   Edit.WindowColor := ColorYellow;

   // create combo box
   Combo.Init (SelfPtr, id_Combo, 'Red', 20, 150, 400, 120);
END;

Procedure TNewDialogWindow.SetupWindow;
Var
i : Byte;
Begin
   Inherited SetupWindow;
   // fill the combo box
   With Combo
   do begin
      For i := 0 to MaxColors Do AddString (ColorNames [i]);
      SetSelIndex (0);
   end;
End;

FUNCTION TNewDialogWindow.ProcessCommands;
BEGIN
  Result := 0;
  // process the combo box messages here
  CASE ID OF
     id_Combo :
        Case Combo.GetClickParam (Msg) of
           CBN_SELCHANGE :
           begin
             ShowMessage ( 'Changed colour to ' + Combo.Text );
             Edit.SetBackGroundColor ( MyColors [Combo.ItemIndex] );
           end;
        End;
  ELSE
   Result := Inherited ProcessCommands ( Msg, Id );
  END; // Case ID
END;

// event handler to return the item chosen from a radiogroup
PROCEDURE RadioDlgClick ( Sender : pWindowsObject; VAR Msg : TMessage );
Var
p : pRadioGroup;
i : Integer;
BEGIN
   WITH pDialog ( Sender^.Parent ) ^
   DO BEGIN
      p := pRadioGroup (ActiveControl);
      if p^.Name = 'TRadioGroup'
      then begin
         i := p^.GetItemIndex;
         ShowMessage ('You selected item number : ' + InttoStr (i));
         ShowMessage ('I bet you you really like "' + p^.GetSelectedString + '"');
      end;
   END;
END;

Procedure   TNewWindow.RadioGroupDialog;
Var
Group : TRadioGroup;
Dialog : TDialog;
p : pButton;
Begin
  // create a dialog
  Dialog.InitTemplate(SelfPtr, 'Dialog with radio group', 1, 1, 450, 250);
  Dialog.CentredInParent := True;

  // create a radiogroup within it
  Group.Init   ( Dialog.SelfPtr, 0, ' Which OF these do you like? ', 5, 25, 440, 125 );
  With Group.Items
  do begin
      Add ('Eggs');
      Add ('Chesse');
      Add ('Butter');
      Add ('Bread');
      Add ('Apples');
      Add ('Oranges');
      Add ('Kiwi fruit');
      Add ('Lychees');
  End;
  Group.Columns := 3;
  Group.ItemIndex := 3;

  // create some buttons on the dialog
  p := New (pButton, Init (Dialog.SelfPtr, id_Cancel, 'C&ancel', 240, 200, 100, 25 ) );
  p := New (pButton, Init (Dialog.SelfPtr, 0, 'Select ...', 120, 200, 100, 25 ) );

  // assign an event handler to return the item selected
  p^.OnClick := RadioDlgClick;

  // execute the dialog
  Dialog.ActiveControl := Group.SelfPtr;
  Dialog.Execute;
  Dialog.Done;
End;

FUNCTION TNewWindow.ProcessCommands;
Var
Dialog : TNewDialogWindow;
EditBox : TEditDialog;
BEGIN
  Result := 0;
  CASE ID OF
      CM_HelpAbout : ShowMessage ( 'Object Mingw dialog demo program.' );
      id_RadioGroup : RadioGroupDialog;
      id_EditBox :
      BEGIN
          WITH EditBox
          DO BEGIN
              Init ( @Self,
                  'Information Entry',
                  'Please enter your full name here. Is that okay with you?',
                  'The Great African Chief' );
              IF Execute = id_ok
                THEN ShowMessage ( 'Your full name is ' + Selection );
              Done;
          END;
       END;

      Id_Dialog :
      WITH Dialog
      DO BEGIN
        InitParams ( @Self, 'Another dialog created programmatically!',
                      50, 20, 450, 350 );
        Execute;
        Done;
      END;
  ELSE
   Result := Inherited ProcessCommands ( Msg, Id );
  END;
END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 sMenu : TMenu;
BEGIN
   Inherited SetupWindow;
   SetCaption ( AppName );
   WITH sMenu DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );
       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
END;

{****************************}
TYPE
TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;


PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( Nil, AppName ) );
END;

VAR
MyApp : TNewApplication;

BEGIN
 WITH MyApp DO BEGIN
     Init ( AppName );
     Run;
     Done;
  END;
END.

