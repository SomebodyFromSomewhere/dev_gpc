{
***************************************************************************
*                 cDialogs.pas
*  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements a (slightly) BP-compatible oDialogs unit
*  for GNU Pascal for Win32.
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     To provide Pascal objects for creating Windows dialogs and windowed controls
*
*    Objects:
*           TDialog
*           TDlgWindow
*           TCommonFileDialog
*           TFileOpenDialog
*           TFileSaveAsDialog
*           TEditDialog
*           TCommonDialog
*           TFontDialog
*           TColorDialog
*           TPrinterDialog
*           TFindDialog
*           TControl
*           TButton
*           TBitBtn
*           TPanel
*           TProgressBar
*           TGroupBox
*           TRadioGroup
*           TCheckBox
*           TRadioButton
*           TStatic
*           TIconBox
*           TImageBox
*           TLabel
*           TUrl
*           TEdit
*           TMemo
*           TRichEdit
*           TMenu
*           TListBox
*           TComboBox
*           TScrollBar
**
*  The functionality is based almost entirely on Win32 API routines,
*  and so it is not portable, except perhaps via WINE.
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal, and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 22 July 2004
*  Version: 1.01
*  Licence: Shareware
*  NOTES: this unit is work-in-progress; some things need more work !
*
***************************************************************************
}

{$i cwindows.inc}  { defines or undefines "IS_UNIT", sChar, etc }

{$ifdef IS_UNIT}
UNIT cDialogs;

INTERFACE
{$i-}

USES
{$ifdef __GPC__}
GPC,
System,
{$endif}
Sysutils,
Messages,
Windows,
RichEdit,
CommDlg,
commctrl,
cClasses,
cWindows;
{$endif} {IS_UNIT}

{$ifdef __GPC__}
  {$W-}
  {$X+}
{$endif}

TYPE
TDialogString = String [255];
String64k = String {$ifdef __GPC__} ( 1024 * 64 ) {$endif};

PDialog = ^TDialog;
TDialog = OBJECT ( TWindowsObject )
  StartDimensions : TRect;
  aReturn  : WinInteger;
  Template : pDlgTemplate;
  IsModal  : Boolean;
  UseTemplate : Boolean;
  {
  CentredInParent,   // should the dialog be centered relative to its parent window?
  Centred : Boolean; // should the dialog be centered relative to display?
  }

  { Init using resource: Borland should have called this "InitResource" ! }
  CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );

  { Init using a memory template, with supplied caption and dimensions
    !!!NOTE: if you use this, you must override this constructor in your
             descendant object, and MUST assign a handler to either ID_OK
             or ID_CANCEL, or to both of them
             - otherwise, the Dialog will not stay alive!!!!
  }
  CONSTRUCTOR InitTemplate ( Owner : pWindowsObject; CONST aCaption : pChar; x, y, w, h : WinInteger );
  DESTRUCTOR  Done;VIRTUAL;

  FUNCTION    Execute : WinInteger;VIRTUAL;
  PROCEDURE   Show ( ShowCmd : Integer ); VIRTUAL;
  FUNCTION    CreateWnd : Boolean;VIRTUAL;
  PROCEDURE   SetName ( CONST aName : pChar );VIRTUAL;

  PROCEDURE   Ok ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   Cancel ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmClose ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WMCommand ( VAR Msg : TMessage ); VIRTUAL;
  PROCEDURE   WMInitDialog ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WMSETCURSOR ( VAR Msg : TMessage );VIRTUAL;
  FUNCTION    ChildWithHWnd ( aWnd : hWnd ) : pWindowsObject;VIRTUAL;

  FUNCTION    SendDlgItemMsg ( DlgItemID : WinInteger; AMsg : UINT; WParam : WParam32; LParam : LParam32 ) : WinInteger;
  PROCEDURE   DisableControl ( CONST ID : WinInteger );VIRTUAL;
  PROCEDURE   EnableControl ( CONST ID : WinInteger );VIRTUAL;
  FUNCTION    GetItemWnd    ( CONST ID : WinInteger ) : HWnd;VIRTUAL;
  FUNCTION    GetItemText   ( CONST ID : WinInteger;xBuffer : PChar;CONST Count : WinInteger ) :
                             WinInteger;VIRTUAL;
  FUNCTION    SetItemText   ( CONST ID : WinInteger;nText : pChar ) : Boolean;VIRTUAL;
  FUNCTION    SetControlText ( CONST ConTrol : hWnd;nText : pChar ) : Boolean;VIRTUAL;
END;

{*************************************}
pDlgWindow = ^TDlgWindow;
TDlgWindow = OBJECT ( TDialog )
    CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aName : pChar );
END;
{*************************************}
TYPE
 pCommonFileDialog = ^TCommonFileDialog;
 TCommonFileDialog = OBJECT ( TDialog )
     {Private}
       OFN : TOpenFileName;
       FileName,
       Description,
       FileSpecs,
       Filter,
       sCaption : TDialogString;
       FileFlags   : WinInteger;

     {public}
     CONSTRUCTOR Init ( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
     DESTRUCTOR Done;  VIRTUAL;
     FUNCTION   CreateWnd : Boolean; VIRTUAL;
     FUNCTION   Execute : WinInteger; VIRTUAL;
     FUNCTION   CDExecute : Boolean; VIRTUAL;
     PROCEDURE  OK ( VAR Msg : TMessage );VIRTUAL;
     PROCEDURE  Cancel ( VAR Msg : TMessage );VIRTUAL;
     PROCEDURE  SetTitle ( CONST aCaption : String );VIRTUAL;
     PROCEDURE  SetDescription ( CONST aCaption : String );VIRTUAL;
     PROCEDURE  SetFileSpecs ( CONST aCaption : String );VIRTUAL;
     PROCEDURE  SetFilter;VIRTUAL;
     PROCEDURE  SetFlags ( CONST aFlag : WinInteger );VIRTUAL;
     PROCEDURE  UpdateAll;VIRTUAL;
     FUNCTION   GetFileName : TDialogString; VIRTUAL;{calls CDExecute, and then returns the selected file}
   END;

{*************************************}
 PFileOpenDialog = ^TFileOpenDialog;
 TFileOpenDialog = OBJECT ( TCommonFileDialog )
     CONSTRUCTOR Init ( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
 END;

{*************************************}
 PFileSaveAsDialog = ^TFileSaveAsDialog;
 TFileSaveAsDialog = OBJECT ( TFileOpenDialog )
     CONSTRUCTOR Init ( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
     FUNCTION CDExecute : Boolean; VIRTUAL;
 END;
{*************************************}
TYPE
pControl = ^TControl;
TControl = OBJECT ( TBitmapWindow )
  Cursor : THandle;
  ReadOnly : Boolean;
  aText    : TString;

{Public}
  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  CONSTRUCTOR InitResource ( Owner : pWindowsObject; ResourceID : WinInteger );
  PROCEDURE   SetupWindow; VIRTUAL;
  PROCEDURE   WMMOUSEMOVE ( VAR Msg : TMessage );VIRTUAL;
  FUNCTION    GetId : WinInteger; VIRTUAL;
  FUNCTION    GetClassName : pChar; VIRTUAL;
  FUNCTION    Text : TString;VIRTUAL;
  FUNCTION    TextpChar : pChar;VIRTUAL;
  PROCEDURE   SetText ( Txt : pChar );VIRTUAL;
  PROCEDURE   SetReadOnly ( Action : Boolean );VIRTUAL;
  PROCEDURE   HideMe; VIRTUAL;
  PROCEDURE   CloseMe; VIRTUAL;
END;
{*************************************}
TYPE
pButton = ^TButton;
TButton = OBJECT ( TControl )
    Default : Boolean;
    CONSTRUCTOR InitResource ( Owner : pWindowsObject; ResourceID : WinInteger );
    CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
    FUNCTION    GetClassName : pChar; VIRTUAL;
    PROCEDURE   Click;VIRTUAL;
END;
{*************************************}
TYPE
pBitBtn = ^TBitBtn;
TBitBtn = OBJECT ( TButton )
    CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle, aBitmap : PChar; X, Y, W, H : WinInteger );
    FUNCTION  CreateWnd : Boolean; VIRTUAL;
END;
{*************************************}
TYPE
pPanel = ^TPanel;
TPanel = OBJECT ( TButton )
   AlignBottom : Boolean;
   CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; HH, Alignment : WinInteger );
END;
{*************************************}
TYPE
pGroupBox = ^TGroupBox;
TGroupBox = OBJECT ( TButton )
    CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;
{*************************************}
TYPE
pRadioGroup = ^TRadioGroup;
TRadioGroup = OBJECT ( TGroupBox )
   Items : TStrings;       // list OF captions TO add radiobuttons FOR
   Columns,
   ItemIndex : WinInteger; // specifies button TO check
   CONSTRUCTOR Init ( Owner : pWindowsObject; AnId : WinInteger; ATitle : PChar;
                      X, Y, W, H : WinInteger );
   DESTRUCTOR Done; VIRTUAL;
   FUNCTION CreateWnd : Boolean; VIRTUAL;

   // new
   FUNCTION GetSelectedString : TString; VIRTUAL;
   FUNCTION GetItemIndex : WinInteger; VIRTUAL; // returns index OF selected
   FUNCTION SetItemIndex ( index : WinInteger ) : Boolean; VIRTUAL; // checks selected
END;
{*************************************}
TYPE
pCheckBox = ^TCheckBox;
TCheckBox = OBJECT ( TButton )
  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  FUNCTION    Checked : Boolean;VIRTUAL;
  PROCEDURE   Check;VIRTUAL;
  PROCEDURE   UnCheck;VIRTUAL;
END;
{*************************************}
TYPE
pRadioButton = ^TRadioButton;
TRadioButton = OBJECT ( TCheckBox )
  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;
{*************************************}
TYPE
pStatic = ^TStatic;
TStatic = OBJECT ( TControl )
   CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
    FUNCTION  GetClassName : pChar; VIRTUAL;
END;

pIconBox = ^TIconBox;
TIconBox = OBJECT ( TStatic )
   CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;

pImageBox = ^TImageBox;
TImageBox = OBJECT ( TStatic )
   CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;


{*************************************}
pLabel = ^TLabel;
TLabel = TStatic;

{*************************************}
TYPE
pURL = ^TUrl;
TUrl = OBJECT ( TLabel )
   Link : TControlStr;
   CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;

{*************************************}
TYPE
pProgressBar = ^TProgressBar;
TProgressBar = OBJECT ( TWndParent )
  CurrentPos,
  Min,
  Max,
  Step : Integer;
  StaticControl : pStatic;
  CONSTRUCTOR Init
  ( Owner : pWindowsObject; AnId : WinInteger; X, Y, W, H : WinInteger );
  FUNCTION  GetClassName : pChar; VIRTUAL;
  PROCEDURE SetupWindow; VIRTUAL;
  PROCEDURE StepBy ( Delta : Integer ); VIRTUAL;
  PROCEDURE Position ( Moveto : Integer ); VIRTUAL;
  PROCEDURE StepIt; VIRTUAL;
  PROCEDURE Update; VIRTUAL;
END;

{*************************************}

TYPE
pEdit = ^TEdit;
TEdit = OBJECT ( TControl )
  PassWordChar : Char;
  OnKeyDown,
  OnKeyUp : TEventHandler;
  MultiLine,
  WordWrap : Boolean;

  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  FUNCTION    CreateWnd : Boolean; VIRTUAL;
  FUNCTION    GetClassName : pChar; VIRTUAL;
  PROCEDURE   SetupWindow;VIRTUAL;
  FUNCTION    Modified : Boolean;VIRTUAL;
  PROCEDURE   SetModify ( CONST Modify : Boolean );VIRTUAL;
  PROCEDURE   SetPassWordChar ( aChar : Char );VIRTUAL;
  PROCEDURE   Undo;VIRTUAL;
  PROCEDURE   Redo;VIRTUAL;
  FUNCTION    CanUndo : Boolean; VIRTUAL;
  FUNCTION    CanPaste : Boolean; VIRTUAL;

  PROCEDURE   SetBackGroundColor ( aColor : WinInteger );VIRTUAL;
  PROCEDURE   ReplaceSelection ( NewText : pChar );VIRTUAL;
  FUNCTION    GetLineText ( Line : WinInteger ) : TString;VIRTUAL;
  FUNCTION    GetCurrentLine : WinInteger; VIRTUAL;
  FUNCTION    GetCurrentColumn : WinInteger; VIRTUAL;

  FUNCTION    SelStart : WinInteger; VIRTUAL;
  FUNCTION    SelEnd : WinInteger; VIRTUAL;
  FUNCTION    SelLength : WinInteger; VIRTUAL;
  FUNCTION    SelText : String64k; VIRTUAL;
  FUNCTION    SetSelection ( Start, Stop : WinInteger ) : WinInteger; VIRTUAL;

  PROCEDURE   Copy;VIRTUAL;
  PROCEDURE   Cut;VIRTUAL;
  PROCEDURE   Paste;VIRTUAL;
END;
{*************************************}
TYPE
pMemo = ^TMemo;
pMemoStrings = ^TMemoStrings;
TMemoStrings = OBJECT ( TStrings )
   Memo : pMemo;
   CONSTRUCTOR Create ( Owner : pMemo );
   DESTRUCTOR Done; VIRTUAL;
   FUNCTION   LoadFromFile ( CONST FName : String ) : WinInteger; VIRTUAL;
END;

TMemo = OBJECT ( TEdit )
  Buffer : pChar;
  BufferHandle : hGlobal;
  FileName : TDialogString;
  Lines : TMemoStrings;
  RightMargin : DWord;
  PlainText    : Boolean;

  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  DESTRUCTOR  Done;VIRTUAL;
  PROCEDURE   SetupWindow; VIRTUAL;
  FUNCTION    Contents : pChar;VIRTUAL;
  FUNCTION    ReadFromFile ( CONST FName : String ) : WinInteger;VIRTUAL;
  FUNCTION    WriteToFile ( CONST FName : String ) : WinInteger;VIRTUAL;
  FUNCTION    LineCount : WinInteger;VIRTUAL;
  FUNCTION    LineDown : WinInteger;VIRTUAL;
  FUNCTION    LineUp : WinInteger;VIRTUAL;
  FUNCTION    PageDown : WinInteger;VIRTUAL;
  FUNCTION    PageUp : WinInteger;VIRTUAL;
  FUNCTION    GetTextBuffer : pChar;VIRTUAL;
  FUNCTION    GetBufferHandle : DWord; VIRTUAL;
  PROCEDURE   ScrollBy ( horz, vert : WinInteger ); VIRTUAL;
  PROCEDURE   ClearBuffer;VIRTUAL;
  PROCEDURE   AllocateLines; VIRTUAL;
  PROCEDURE   WmChange ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmEnter ( VAR Msg : TMessage );VIRTUAL;
  FUNCTION    GetTextLimit : DWord;VIRTUAL;
  PROCEDURE   SetTextLimit ( aLimit : DWord );VIRTUAL;
  PROCEDURE   SetRightMargin ( i : DWord ); VIRTUAL;


  { !!! you must call FreeBufferHandle after calling GetTextBufferFromHandle
        and *before* any subsequent call to GetTextBufferFromHandle
  !!! }
  FUNCTION    GetTextBufferFromHandle : pChar;VIRTUAL;
  PROCEDURE   FreeBufferHandle; VIRTUAL;

END;

{*************************************}
CONST
RTF_Code = '{\rtf1\';  // kludge TO test FOR RTF FILE

TYPE
pRichEdit = ^TRichEdit;
TRichEdit = OBJECT ( TMemo )
  DllHandle : THandle;
  SaveIt : TEditStream;
  FileHandle : WinInteger;
  FileIn : FILE OF Char;

  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  FUNCTION    GetClassName : pChar; VIRTUAL;
  DESTRUCTOR  Done;VIRTUAL;
  FUNCTION    ReadFromFile ( CONST FName : String ) : WinInteger;VIRTUAL;
  FUNCTION    WriteToFile ( CONST FName : String ) : WinInteger;VIRTUAL;
  FUNCTION    SearchFor ( s : String ) : WinInteger; VIRTUAL;
  FUNCTION    IsRtfFile ( CONST FName : String ) : Boolean;VIRTUAL;
  PROCEDURE   SetTextLimit ( aLimit : DWord );VIRTUAL;

END;

{*************************************}

TYPE
pEditDialog  = ^TEditDialog;
TEditDialog = OBJECT ( TDialog )
  OkBtn,
  CancelBtn : TButton;
  Edit : TEdit;
  lStatic : TStatic;
  Selection : TString;
  CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aCaption, aPrompt, aDefault : pChar );
  PROCEDURE   SetupWindow;VIRTUAL;
  PROCEDURE   OK ( VAR Msg : TMessage );VIRTUAL;
END;

{*************************************}
TYPE
pCommonDialog = ^TCommonDialog;
TCommonDialog = OBJECT ( TDialog )
  CONSTRUCTOR Init ( Owner : pWindowsObject );
  PROCEDURE   OK ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   Cancel ( VAR Msg : TMessage );VIRTUAL;
  FUNCTION    CreateWnd : Boolean;VIRTUAL;
END;
{*************************************}
TYPE
pFontDialog = ^TFontDialog;
TFontDialog = OBJECT ( TCommonDialog )
lf : TChooseFont;
tl : TLogFont;
  CONSTRUCTOR Init ( Owner : pWindowsObject );
  FUNCTION    Execute : WinInteger; VIRTUAL;
END;
{*************************************}
TYPE
pColorDialog = ^TColorDialog;
TColorDialog = OBJECT ( TCommonDialog )
ClrArray : ARRAY [0..15] OF WinInteger;
lf : TChooseColor;
  CONSTRUCTOR Init ( Owner : pWindowsObject );
  FUNCTION  Execute : WinInteger; VIRTUAL;
  FUNCTION Color : WinInteger; VIRTUAL; { calls execute and returns font.color }
END;
{*************************************}
TYPE
pPrinterDialog = ^TPrinterDialog;
TPrinterDialog = OBJECT ( TCommonDialog )
  Printer : TPRINTDLG;
  deviceMode : TDevMode;
  DInfo : TDocInfo;
  CONSTRUCTOR Init ( Owner : pWindowsObject );
  FUNCTION  Execute : WinInteger; VIRTUAL;
  FUNCTION  Print ( FileName : String; PrintSetup : Boolean ) : WinInteger; VIRTUAL;
  FUNCTION  SetupPrinter : WinInteger; VIRTUAL;
  FUNCTION  DC : hDC; VIRTUAL;
  FUNCTION  StartPrinter : Boolean; VIRTUAL;
  FUNCTION  StopPrinter : Boolean; VIRTUAL;
  FUNCTION  PrintData ( CONST Data; DataSize : DWord ) : Boolean; VIRTUAL;
  PROCEDURE SetDeviceMode ( CONST  aMode : TDevMode ); VIRTUAL;
END;
{*************************************}
TYPE
pFindDialog = ^TFindDialog;
TFindDialog = OBJECT ( TCommonDialog )
  FindRec : TFindReplace;
  FindText : TControlStr;
  ReplaceString : TControlStr;
  IsFound : TEventHandler;
  MatchCase,
  MatchWholeWords,
  SearchDown : Boolean;

  CONSTRUCTOR Init ( Owner : pWindowsObject );
  FUNCTION  Execute : WinInteger; VIRTUAL;
  FUNCTION  Find ( CONST s : String ) :   WinInteger; VIRTUAL;
  FUNCTION  Replace ( CONST theold, thenew : String ) : WinInteger; VIRTUAL;
END;

{*************************************}

TYPE
pMenu = ^TMenu;
TMenu = OBJECT ( TClass )
   Parent    : pWindowsObject;
   CONSTRUCTOR Init ( Owner : pWindowsObject );
   FUNCTION    AddSubMenu ( aCaption : String; BitmapID : WinInteger ) : hMenu; VIRTUAL;
   PROCEDURE   AddMenuItem ( ChildMenu : hMenu; aCaption : String; ID, BitmapID : WinInteger );VIRTUAL;
   PROCEDURE   AddMenuSeparator ( ChildMenu : hMenu ); VIRTUAL;
END;
{*************************************}
TYPE
pListBox = ^TListBox;
pListStrings = ^TListStrings;
TListStrings = OBJECT ( TStrings )
   fListBox : pListBox;
   FromParent : Boolean;
   CONSTRUCTOR Create ( Owner : pListBox );
   FUNCTION   Add ( CONST s : String ) : WinInteger; VIRTUAL;
   FUNCTION   AddP ( CONST s : pChar ) : WinInteger; VIRTUAL;
   PROCEDURE  DeleteP ( Index : Cardinal ); VIRTUAL;
   FUNCTION   LoadFromFile ( CONST FName : String ) : WinInteger; VIRTUAL;
END;

TListBox = OBJECT ( TControl )
  { private }
    IsCombo : Boolean;
    AddToLines : Boolean;
    Lines : TListStrings;
    MsgId : THandle;

  { public }
  Sorted : Boolean;
  CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
  FUNCTION   CreateWnd : Boolean; VIRTUAL;
  DESTRUCTOR Done; VIRTUAL;
  FUNCTION   GetClassName : pChar; VIRTUAL;

 { other stuff }
  PROCEDURE SetSorted ( ASorted : Boolean ); VIRTUAL;
  FUNCTION  GetClickParam ( VAR Msg : TMessage ) : WinInteger; VIRTUAL;
  FUNCTION  AddString ( aString : pChar ) : WinInteger;
  FUNCTION  AddStringEx ( aString : String ) : WinInteger;
  FUNCTION  InsertString ( aString : pChar; index : WinInteger ) : WinInteger;
  FUNCTION  StringExists ( aString : pChar ) : WinInteger;
  FUNCTION  StringPartlyExists ( aString : pChar ) : WinInteger;

  FUNCTION  GetSelIndex : WinInteger;
  FUNCTION  ItemIndex : WinInteger;  { Delphi }

  FUNCTION  ClearList : WinInteger;
  PROCEDURE Clear; { Delphi }
  FUNCTION  GetCount : WinInteger;

  FUNCTION  DeleteString ( index : WinInteger ) : WinInteger;
  FUNCTION  SetSelIndex ( index : WinInteger ) : WinInteger;
  FUNCTION  GetStringLen ( Index : WinInteger ) : WinInteger;

  FUNCTION  GetString ( aString : pChar;index : WinInteger ) : WinInteger;
  FUNCTION  GetSelString ( aString : pChar; MaxChars : WinInteger ) : WinInteger;
  FUNCTION  SetSelString ( aString : pChar; index : WinInteger ) : WinInteger;
  FUNCTION  Text : TString; VIRTUAL;
  // PROCEDURE WMMOUSEMOVE ( VAR Msg : TMessage );VIRTUAL;
END;
{*************************************}
TYPE
pComboBox = ^TComboBox;
TComboBox = OBJECT ( TListBox )
    FUNCTION  GetClassName : pChar; VIRTUAL;
    CONSTRUCTOR Init ( Owner : pWindowsObject;
                   AnId : WinInteger; ATitle : PChar; X, Y, W, H : WinInteger );
END;
{*************************************}
TYPE
pScrollBar = ^TScrollBar;
TScrollBar = OBJECT ( TControl )
    FUNCTION  GetClassName : pChar; VIRTUAL;
END;

{*************************************}
{*************************************}

 FUNCTION GetFileOpenName ( aParent : pWindowsObject;Flags : WinInteger;CONST aCaption, Desc, Specs : String ) : TControlStr;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

 FUNCTION GetFileSaveName ( aParent : pWindowsObject;Flags : WinInteger;CONST aCaption, Desc, Specs : String ) : TControlStr;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

IMPLEMENTATION

USES
{$ifndef __GPC__}
Shellapi,
{$endif}
genutils;

PROCEDURE AddNull ( VAR s : TDialogString );
BEGIN
   IF s [Length ( s ) ] <> #0 THEN s := s + #0;
END;

FUNCTION DefaultDialogProc ( Dialog : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : LResult;
STDCALL;
{$ifdef __GPC__}FORWARD;
FUNCTION DefaultDialogProc ( Dialog : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : LResult;
{$endif}
VAR
Msg : TMessage;
p   : pWindowsObject;
BEGIN
    Result := 0;
    Msg.Result   := 0;
    Msg.Receiver := Dialog;
    Msg.Message  := Message;
    Msg.WParam   := WParam;
    Msg.LParam   := LParam;
    Msg.Sender   := NIL;

    {init dialog message - set the object handle}
    IF ( Message = wm_InitDialog )
    THEN BEGIN
       p := pWindowsObject ( LParam );
    END
    ELSE p := InstanceFromHandle ( Dialog );

    {if an object is returned, call its default window procedure}
    IF Assigned ( p )
    THEN BEGIN
       Msg.Sender := p;
       p^.Handle := Dialog;
       p^.DefWndProc ( Msg );
       Result := Msg.Result;
    END;
END;
{///////////////////////////////////////////////////}
CONSTRUCTOR TDialog.Init;
BEGIN
    INHERITED Init ( Owner );
    Name := 'TDialog';
    Centred := False;
    ParentHandle := 0;
    IF aTitle <> NIL
    THEN BEGIN
      pChar2String ( aTitle, Caption );
      Attr.Title := StrNew ( aTitle );
    END;
    FillChar ( StartDimensions, Sizeof ( StartDimensions ), 0 );

    Attr.Style :=
                 (
                 DS_3DLOOK OR
                 WS_POPUP OR
                 // DS_CONTROL OR
                 WS_VISIBLE OR
                 WS_BORDER OR
                 WS_SYSMENU OR
                 WS_CAPTION )
                 ;
    IsModal := True;       { default to modal dialog }
    UseTemplate := False;  { we are not using a memory template }
    Template := NIL;       {  - so this must be NIL }

    IF Assigned ( Owner ) THEN ParentHandle := Owner^.Handle;
    IF ParentHandle <> 0 THEN ParentInstance := TFarProc ( GetWindowLong ( ParentHandle, GWL_WndProc ) );

    @WindowProc := @DefaultDialogProc;
END;

CONSTRUCTOR TDialog.InitTemplate;
BEGIN
   Init ( Owner, aCaption );

   // save initial dimensions
   WITH StartDimensions
   DO BEGIN
       Left := x;
       Top := y;
       Right := w;
       Bottom := h;
   END;

   // convert from screen pixels TO dialog units
   Attr.x := PixelsToDialogUnitsX ( x );
   Attr.y := PixelsToDialogUnitsY ( y );
   Attr.w := PixelsToDialogUnitsX ( w );
   Attr.h := PixelsToDialogUnitsY ( h );

   // we are using a template
   UseTemplate := True;
END;

DESTRUCTOR TDialog.Done;
BEGIN
   Template := NIL;
   UseTemplate := False;
   wCloseWindow;
   INHERITED Done;
END;

FUNCTION TDialog.CreateWnd;
{create modeless dialog}
VAR
hgbl : HGLOBAL;
BEGIN
   Result := False;
   IF Handle = 0
   THEN BEGIN
      IsModal := False;
      aReturn := - 1;
      IF UseTemplate
      THEN BEGIN
         hgbl := GlobalAlloc ( GMEM_ZEROINIT, 2048 );
         Template := PDLGTEMPLATE ( GlobalLock ( hgbl ) );
         WITH Template^
         DO BEGIN
            Style := Attr.Style;
            cDit := 0;
            x := Attr.x;
            y := Attr.y;
            cx := Attr.w;
            cy := Attr.h;
         END;

         GlobalUnlock ( hgbl );
         Handle :=
            CreateDialogIndirectParam
            ( _HInstance,
            Template^, ParentHandle, @WindowProc, WinInteger ( @Self ) );

         GlobalFree ( hgbl );
         Template := NIL;
      END ELSE BEGIN
          Handle := CreateDialogParam ( _HInstance, Attr.Title, ParentHandle,
                   @WindowProc, WinInteger ( @Self ) );
      END;
      IF Handle = 0
      THEN BEGIN
        MessageBox ( GetActiveWindow, 'Cannot Create Dialog: Error Code "-1"',
                   Attr.Title, mb_ok );
        exit;
      END;
      ShowWindow ( Handle, sw_Normal );
   END
   ELSE ShowWindow ( Handle, sw_Normal );
   Result := True;
END;

FUNCTION TDialog.Execute;
VAR
hgbl : HGLOBAL;
BEGIN
  IF NOT IsModal
  THEN BEGIN
   { create modeless dialog }
    aReturn := - 1;
    CreateWnd;
    // aReturn := Handle;
  END
  ELSE BEGIN
    { create modal dialog }
     Attr.Style := Attr.Style OR DS_MODALFRAME;
     IF ( UseTemplate )
     THEN BEGIN
         hgbl := GlobalAlloc ( GMEM_ZEROINIT, 1024 );
         Template := PDLGTEMPLATE ( GlobalLock ( hgbl ) );
         WITH Template^
         DO BEGIN
            Style := Attr.Style;
            cDit := 0;
            x := Attr.x;
            y := Attr.y;
            cx := Attr.w;
            cy := Attr.h;
         END;

         GlobalUnlock ( hgbl );
         aReturn :=
                   DialogBoxIndirectParam
                    ( _HInstance,
                    Template^,
                    ParentHandle,
                    @WindowProc,
                    WinInteger ( SelfPtr ) );
         GlobalFree ( hgbl );
         Template := NIL;
     END
     ELSE BEGIN
        aReturn := DialogBoxParam ( _HInstance, Attr.Title, ParentHandle,
                   @WindowProc, WinInteger ( SelfPtr ) );
     END;

     IF ( aReturn = - 1 )
     THEN BEGIN
        MessageBox ( GetActiveWindow,
                   'Cannot Create Dialog: Error Code "-1"',
                   Attr.Title, mb_ok );
     END;
  END;
  Result := aReturn;
END;

PROCEDURE TDialog.Ok;
BEGIN
   Msg.Result := 0;
   IF ( IsModal )
   THEN BEGIN
      IF CanClose THEN EndDialog ( Handle, ID_Ok )
   END
   ELSE BEGIN
      wCloseWindow;
   END;
END;

PROCEDURE TDialog.Cancel;
BEGIN
  Msg.Result := 0;
  IF IsModal
  THEN BEGIN
     EndDialog ( Handle, ID_Cancel );
  END ELSE wCloseWindow;
END;

PROCEDURE  TDialog.WMCommand;
VAR
p : pWindowsObject;
BEGIN
   WITH Msg
   DO BEGIN
      Result := 1;
      p := InstanceFromHandle ( hWnd ( LParam ) );
      IF Assigned ( p ) THEN Msg.Sender := p;
      CASE WParamLo OF
        id_Ok :
          BEGIN
            Ok ( Msg );
            Exit;
          END;

        id_Cancel :
          BEGIN
            Cancel ( Msg );
            Exit;
          END;
      END; { Case WParam }
   END;
   INHERITED WMCommand ( Msg );
END;

FUNCTION    TDialog.ChildWithHWnd;
VAR
p : pWindowsObject;
i : Cardinal;
BEGIN
   Result := NIL;
   IF HasChildren THEN
   FOR i := 0 TO ChildCount
   DO BEGIN
      p := pWindowsObject ( At ( i ) );
      IF LoWord ( p^.Handle ) = aWnd
      THEN BEGIN
         Result := p;
         Exit;
      END;
   END;
END;

PROCEDURE TDialog.WMSETCURSOR;
VAR
p : pWindowsObject;
BEGIN
  WITH Msg
  DO BEGIN
    Result := 0;  { default to no processing }
    CASE lParamHi OF
     wm_MouseMove : { trap wm_mousemove }
     BEGIN
       p := ChildWithHWnd ( WParamLo ); { find the relevant child window }
       IF Assigned ( p )
       THEN BEGIN
          Msg.Sender := p;
          p^.WMMouseMove ( Msg );      { call its wmMouseMove method }
       END
       ELSE BEGIN
          SendMessage ( WParamLo, lParamHi, 0, 0 );
       END;
     END; { wm_mousemove}
    END; { case }
  END; { with }
END;

PROCEDURE  TDialog.WMInitDialog;
BEGIN
   INHERITED WMInitDialog ( Msg );
   IF ( UseTemplate ) AND ( Assigned ( Attr.Title ) )
   THEN BEGIN
     SetWindowText ( Handle, Attr.Title );
   END;
   Msg.Result := 0;
   // SetupWindow;
END;

PROCEDURE TDialog.SetName;
BEGIN
   pChar2String ( aName, Name );
END;

PROCEDURE  TDialog.WMClose;
BEGIN
   IF IsModal THEN BEGIN
      Cancel ( Msg );
      INHERITED WMClose ( Msg );
   END ELSE BEGIN
       IF Assigned ( OnClose )
         THEN OnClose ( pWindowsObject ( @Self ), Msg ) ELSE Msg.Result := 0;
       DestroyWindow ( Handle );
       Handle := 0;
   END;
END;

PROCEDURE TDialog.Show;
BEGIN
   Execute;
END;

PROCEDURE TDialog.DisableControl;
BEGIN
   EnableWindow ( GetItemWnd ( ID ), False );
END;

PROCEDURE TDialog.EnableControl;
BEGIN
   EnableWindow ( GetItemWnd ( ID ), True );
END;

FUNCTION  TDialog.GetItemWnd;
BEGIN
   GetItemWnd := GetDlgItem ( Handle, ID );
END;

FUNCTION  TDialog.GetItemText;
BEGIN
   GetItemText :=
   GetDlgItemText ( Handle, ID, xBuffer, Count );
END;

FUNCTION  TDialog.SetItemText;
BEGIN
   Result := SetDlgItemText ( Handle, ID, nText );
END;

FUNCTION  TDialog.SetControlText;
BEGIN
   Result := SetWindowText ( Control, nText );
END;

FUNCTION    TDialog.SendDlgItemMsg;
BEGIN
   Result := SendDlgItemMessage ( Handle, DlgItemID, AMsg, WParam, LParam );
END;

{*************************************}
CONSTRUCTOR TDlgWindow.Init;
BEGIN
   INHERITED Init ( Owner, aName );
   Attr.Style := DS_MODALFRAME OR WS_POPUP OR WS_VISIBLE OR WS_CAPTION
   OR WS_SysMenu OR WS_MinimizeBox OR WS_MaximizeBox
   OR WS_DlgFrame OR WS_ThickFrame;
END;

{*************************************}
CONSTRUCTOR TProgressBar.Init;
BEGIN
   INHERITED Init ( Owner );
   Name := 'TProgressBar';
   Caption := '';
   Attr.Style := WS_Child OR WS_Visible;
   Attr.ID := AnId;
   Attr.X := X;
   Attr.Y := Y;
   Attr.W := W;
   Attr.H := H;
   Max := 100;
   Min := 0;
   CurrentPos := 0;
   Step := 1;
   StaticControl := NIL;
   InitCommonControls;
END;

FUNCTION TProgressBar.GetClassName : pChar;
BEGIN
   Result := 'msctls_progress32';
END;

PROCEDURE TProgressBar.Update;
BEGIN
   IF ( Assigned ( StaticControl ) ) AND ( IsWindow ( StaticControl^.Handle ) )
   THEN BEGIN
      StaticControl^.Caption := IntToStr ( CurrentPos ) + '%';
      StaticControl^.SetCaption ( sChar ( StaticControl^.Caption ) );
   END;
END;

PROCEDURE TProgressBar.StepBy ( Delta : Integer );
BEGIN
   IF ( CurrentPos + Delta ) > Max THEN Delta := Max - CurrentPos;
   IF Delta > 0
   THEN BEGIN
      SendMessage ( Handle, PBM_DELTAPOS, Delta, 0 );
      Inc ( CurrentPos, Delta );
      Update;
   END;
END;

PROCEDURE TProgressBar.Position ( Moveto : Integer );
BEGIN
   IF MoveTo > Max THEN MoveTo := Max;
   SendMessage ( Handle, PBM_SETPOS, MoveTo, 0 );
   CurrentPos := MoveTo;
   Update;
END;

PROCEDURE TProgressBar.StepIt;
BEGIN
   SendMessage ( Handle, PBM_SETRANGE, 0, MakeLParam ( Min, Max ) );
   IF CurrentPos < Max
   THEN BEGIN
      SendMessage ( Handle, PBM_SETSTEP, Step, 0 );
      SendMessage ( Handle, PBM_STEPIT, 0, 0 );
      Inc ( CurrentPos, Step );
      Update;
   END;
END;

PROCEDURE  TProgressBar.SetupWindow;
BEGIN
   INHERITED SetupWindow;
   SendMessage ( Handle, PBM_SETRANGE, 0, MakeLParam ( Min, Max ) );
   SendMessage ( Handle, PBM_SETSTEP, Step, 0 );
END;
{*************************************}
{*************************************}
{*************************************}
{*************************************}
{*************************************}

CONSTRUCTOR TControl.Init;
BEGIN
   INHERITED Init ( Owner, NIL );
   Name := 'TControl';
   ReadOnly := False;
   Attr.Style := WS_Child OR WS_TabStop OR WS_Visible;
   Attr.ID := AnId;
   Attr.X := X;
   Attr.Y := Y;
   Attr.W := W;
   Attr.H := H;
   Attr.Title := StrNew ( aTitle );
   pChar2String ( aTitle, Caption );
   Cursor := 0;
   WITH Font
   DO BEGIN
       StrCopy ( Name, 'Arial' );
       Size := 10;
   END;
END;

CONSTRUCTOR TControl.InitResource;
BEGIN
   INHERITED InitResource ( Owner, ResourceID );
   Name := 'TControl';
END;

PROCEDURE TControl.SetupWindow;
BEGIN
   INHERITED SetupWindow;
   IF ReadOnly THEN SetReadOnly ( True );
END;

PROCEDURE TControl.WMMouseMove;
BEGIN
  INHERITED WMMouseMove ( Msg );
  IF Cursor <> 0
  THEN BEGIN
     SetCursor ( Cursor );
     Msg.Result := 1;
  END ELSE Msg.Result := 0;
END;

FUNCTION    TControl.GetClassName : pChar;
BEGIN
   Result := 'tcontrol';
END;

FUNCTION    TControl.GetID;
BEGIN
   Result := Attr.ID;
END;

FUNCTION   TControl.TextpChar : pChar;
BEGIN
   aText := Text;
   Result := pChar ( @aText [1] );
END;

FUNCTION TControl.Text;
VAR
p : pchar;
BEGIN
  Getmem ( p, TStringLen );
  GetWindowText ( Handle, p, TStringLen );
  aText := StrPasEx ( p );
  Result := aText;
  Freemem ( p );
  aText := aText + #0;
END;

PROCEDURE TControl.SetText;
BEGIN
   aText := StrPasEx ( Txt ) + #0;
   SetWindowText ( Handle, Txt );
END;

PROCEDURE TControl.SetReadOnly;
BEGIN
  ReadOnly := Action;
  Perform ( em_SetReadOnly, Ord ( Action ), 0 );
END;

PROCEDURE TControl.HideMe;
BEGIN
  ShowWindow ( Handle, sw_Hide );
END;

PROCEDURE TControl.CloseMe;
BEGIN
  Perform ( wm_Close, 0, 0 );
END;
{*************************************}
CONSTRUCTOR TStatic.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   Attr.Style := Attr.Style OR SS_NOTIFY OR SS_LEFT;
   Use3D := True;
   Name := 'TStatic';
END;

FUNCTION    TStatic.GetClassName : pChar;
BEGIN
   Result := 'Static';
END;
{*************************************}

CONSTRUCTOR TImageBox.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   Attr.Style := Attr.Style OR ss_Bitmap;
   Name := 'TImageBox';
END;
{*************************************}

CONSTRUCTOR TIconBox.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   Attr.Style := Attr.Style OR ss_icon;
   Name := 'TIconBox';
END;

{*************************************}
PROCEDURE URLClick ( Sender : pWindowsObject; VAR Msg : TMessage );
VAR
p : pURL;
BEGIN
   p := pUrl ( Sender );
   WITH p^ DO BEGIN
       ShellExecute ( Handle, 'open', {$ifndef __GPC__}pChar{$endif} ( Link ),
       NIL, NIL, sw_Show );
    END;
END;

CONSTRUCTOR TUrl.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   pChar2String ( aTitle, Link );
   OnClick := URLClick;
   Attr.Style := Attr.Style OR ss_simple;
   Cursor := LoadCursor ( _hInstance, 'hand' );
   WITH Font DO BEGIN
        StrCopy ( Name, {:=} 'Arial' );
        Size := 10;
        Style := [fsUnderLine];
        Color := ColorBlue;
   END;
END;
{*************************************}
FUNCTION TEditWndProc ( Window : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : WinInteger;
STDCALL;
{$ifdef __GPC__}FORWARD;
FUNCTION TEditWndProc ( Window : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : WinInteger;
{$endif}
VAR
p : pWindowsObject;
Msg : TMessage;
BEGIN
   Result := 0;
   Msg.Receiver := Window;
   Msg.Message  := Message;
   Msg.WParam   := WParam;
   Msg.LParam   := LParam;
   Msg.Result   := 0;
   Msg.Sender   := NIL;

   p :=  InstanceFromHandle ( Window );

   IF Assigned ( p )
   THEN BEGIN
      Msg.Sender := p;
      WITH pEdit ( p ) ^
      DO BEGIN
         CASE Message OF
            wm_KeyDown :
            BEGIN
               IF Assigned ( OnKeyDown ) THEN OnKeyDown ( p, Msg );
               WmKeyDown ( Msg );
            END;
            wm_KeyUp :
            BEGIN
               IF Assigned ( OnKeyUp ) THEN OnKeyUp ( p, Msg );
               WmKeyUp ( Msg );
            END;
            {
             any other window message for the edit control
            }
         END; // CASE
         Result := CallWindowProc ( {$ifdef __GPC__}WndProc{$endif} ( p^.Instance ),
                   Window, Message, WParam, lParam );
      END; // WITH
   END;
END;


FUNCTION    TEdit.GetClassName : pChar;
BEGIN
  Result := 'Edit';
END;

CONSTRUCTOR TEdit.Init;
BEGIN
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
  MultiLine := False;
  WordWrap := False;
  Attr.Style := Attr.Style OR WS_Border OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL;
  Font.Brush := GetStockObject ( White_Brush );
  Name := 'TEdit';
  PassWordChar := #0;
  OnKeyDown := NIL;
  OnKeyUp := NIL;
END;

PROCEDURE TEdit.SetupWindow;
BEGIN
    INHERITED SetupWindow;
    IF PassWordChar <> #0 THEN SetPassWordChar ( PassWordChar );
    SetWindowLong ( Handle, GWL_WNDPROC, WinInteger ( @TEditWndProc ) );
END;

FUNCTION TEdit.Modified;
BEGIN
  Result := Perform ( em_GetModify, 0, 0 ) <> 0;
END;

PROCEDURE TEdit.SetModify;
BEGIN
  Perform ( em_SetModify, Ord ( Modify ), 0 );
END;

PROCEDURE TEdit.SetPassWordChar;
BEGIN
   PassWordChar := aChar;
   Perform ( em_SetPassWordChar, THandle ( aChar ), 0 )
END;

PROCEDURE TEdit.Undo;
BEGIN
  IF CanUndo THEN PostMessage ( Handle, em_Undo, 0, 0 );
END;

PROCEDURE TEdit.Redo;
BEGIN
  PostMessage ( Handle, em_Undo, 0, 0 );
END;

FUNCTION    TEdit.CanUndo : Boolean;
BEGIN
   Result := Perform ( EM_CANUNDO, 0, 0 ) <> 0;
END;

FUNCTION    TEdit.CanPaste : Boolean;
BEGIN
   Result := Perform ( EM_CANPASTE, 0, 0 ) <> 0;
END;


{$ifdef VirtualPascal}
CONST EM_SETBKGNDCOLOR = 1091;
{$endif}

PROCEDURE   TEdit.SetBackGroundColor;
BEGIN
   INHERITED SetBackGroundColor ( aColor );
   Perform ( EM_SETBKGNDCOLOR, 0, aColor );
END;

FUNCTION TEdit.GetCurrentLine;
BEGIN
   Result := Succ ( Perform ( EM_LINEFROMCHAR, SelStart, 0 ) );
END;

FUNCTION TEdit.GetCurrentColumn;
BEGIN
   Result := Succ ( SelStart - Perform ( EM_LINEINDEX, Pred ( GetCurrentLine ), 0 ) );
END;

FUNCTION TEdit.GetLineText;
TYPE o = RECORD
  x, y : Word;
END;

VAR
p : pChar;
BEGIN
   Getmem ( p, TStringLen );
   WITH o ( p ) DO x := TStringLen;
   Perform ( EM_GETLINE, Line, WinInteger ( p ) );
   pChar2String ( p, Result );
   Freemem ( p );
   p := NIL;
END;

PROCEDURE   TEdit.Copy;
BEGIN
   Perform ( WM_Copy, 0, 0 );
END;

PROCEDURE   TEdit.Cut;
BEGIN
   Perform ( WM_Cut, 0, 0 );
END;

PROCEDURE   TEdit.Paste;
BEGIN
   IF CanPaste THEN Perform ( WM_Paste, 0, 0 );
END;

FUNCTION    TEdit.SelStart;
VAR
i : WinInteger;
BEGIN
   i := Perform ( EM_GetSel, 0, 0 );
   Result := LoWord ( i );
END;

FUNCTION    TEdit.SelEnd;
VAR
i : WinInteger;
BEGIN
   i := Perform ( EM_GetSel, 0, 0 );
   Result := HiWord ( i );
END;

FUNCTION    TEdit.SelLength;
BEGIN
   Result := SelEnd - SelStart;
END;

FUNCTION    TEdit.SelText;
VAR
p : pChar;
i : WinInteger;
BEGIN
   Result := '';
   i := SelLength + 1;
   Getmem ( p, i );
   Perform ( EM_GetSelText, 0, WinInteger ( p ) );
   pChar2String ( p, Result );

   Freemem ( p );
END;

FUNCTION    TEdit.SetSelection;
BEGIN
   Result := Perform ( EM_SETSEL, Start, Stop );
   Perform ( EM_SCROLLCARET, 0, 0 );
   Focus;
END;

PROCEDURE   TEdit.ReplaceSelection;
BEGIN
   Perform ( EM_REPLACESEL, 1, WinInteger ( NewText ) );
END;

FUNCTION  TEdit.CreateWnd : Boolean;
BEGIN
   IF MultiLine THEN Attr.Style := Attr.Style OR ES_MultiLine;
   IF WordWrap THEN Attr.Style := Attr.Style AND NOT ES_AUTOHSCROLL OR ES_AUTOVSCROLL;
   Result := INHERITED CreateWnd;
END;
{*************************************}
CONST
MaxEditSize = ( ( 1024 * 1024 ) * 8 ); { 8mb richedit controls }

TYPE
EditCharArray = ARRAY [0..MaxEditSize + 4] OF Char;

CONSTRUCTOR TMemoStrings.Create ( Owner : pMemo );
BEGIN
    INHERITED Create;
    Memo := Owner;
END;

DESTRUCTOR TMemoStrings.Done;
BEGIN
    INHERITED Done;
END;

FUNCTION TMemoStrings.LoadFromFile ( CONST FName : String ) : WinInteger;
BEGIN
   IF Assigned ( Memo )
   THEN BEGIN
       Result := Memo^.ReadFromFile ( FName )
   END ELSE Result := INHERITED LoadFromFile ( FName );
END;

CONSTRUCTOR TMemo.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   MultiLine := True;
   WordWrap := True;
   RightMargin := 0;
   PlainText := True;
   Attr.Style := Attr.Style {OR ES_AutoVScroll }OR ES_WantReturn;
   Name := 'TMemo';
   Buffer := NIL;
   FileName := '';
   Lines.Create ( @Self );
   IF StrLen ( Atitle ) > 0 THEN Buffer := StrNew ( ATitle );
END;

PROCEDURE   TMemo.WmChange;
BEGIN
   INHERITED WMChange ( Msg );
   AllocateLines;
END;

PROCEDURE   TMemo.WmEnter;
BEGIN
   INHERITED WMEnter ( Msg );
   AllocateLines;
END;

DESTRUCTOR TMemo.Done;
BEGIN
   IF Assigned ( Buffer ) THEN StrDispose ( Buffer );
   Buffer := NIL;
   FileName := '';
   Lines.Done;
   INHERITED Done;
END;

FUNCTION TMemo.GetTextBuffer;
VAR
i : WinInteger;
BEGIN
  i := Succ ( GetTextLen );
  IF i > 1 THEN BEGIN
     IF Assigned ( Buffer ) THEN StrDispose ( Buffer );
     Getmem ( Buffer, i );
     GetTextBuf ( Buffer, i );
     Result := Buffer;
  END ELSE Result := NIL;
END;

FUNCTION TMemo.Contents;
BEGIN
   Result := GetTextBuffer;
END;

PROCEDURE   TMemo.ClearBuffer;
BEGIN
   IF Assigned ( Buffer ) THEN StrDispose ( Buffer );
   Buffer := NIL;
   SetWindowText ( Handle, '' );
   FileName := '';
END;

FUNCTION    TMemo.GetBufferHandle;
BEGIN
   Result := Perform ( EM_GETHANDLE, 0, 0 );
END;

FUNCTION    TMemo.GetTextBufferFromHandle;
VAR
p : pChar;
BEGIN
   BufferHandle := GetBufferHandle;
   p := GlobalLock ( BufferHandle );
   Result := p;
END;

PROCEDURE  TMemo.FreeBufferHandle;
BEGIN
   GlobalFree ( BufferHandle );
END;

FUNCTION    TMemo.GetTextLimit : DWord;
BEGIN
  Result := Perform ( em_GetLimitText, 0, 0 );
END;

PROCEDURE   TMemo.SetTextLimit ( aLimit : DWord );
BEGIN
  Perform ( em_SetLimitText, aLimit, 0 );
END;

PROCEDURE   TMemo.SetupWindow;
BEGIN
    INHERITED SetupWindow;
    IF RightMargin <> 0 THEN SetRightMargin ( RightMargin );
END;

PROCEDURE   TMemo.SetRightMargin ( i : DWord );
VAR
R : LTRect;
BEGIN
   Move ( ClientRect, R, Sizeof ( R ) );
   IF i <> 0
   THEN BEGIN
      R.Right := i;
      Perform ( EM_SetRect, 0, WinInteger ( @R ) );
      RightMargin := i;
   END;
END;

FUNCTION TMemo.LineCount;
BEGIN
  LineCount := Pred ( Perform ( em_GetLineCount, 0, 0 ) );
END;

FUNCTION    TMemo.LineDown;
BEGIN
   Perform ( EM_SCROLL, SB_LINEDOWN, 0 );
   Result := GetCurrentLine;
END;

FUNCTION    TMemo.LineUp;
BEGIN
   Perform ( EM_SCROLL, SB_LINEUP, 0 );
   Result := GetCurrentLine;
END;

FUNCTION    TMemo.PageDown;
BEGIN
   Perform ( EM_SCROLL, SB_PAGEDOWN, 0 );
   Result := GetCurrentLine;
END;

FUNCTION    TMemo.PageUp;
BEGIN
   Perform ( EM_SCROLL, SB_PAGEUP, 0 );
   Result := GetCurrentLine;
END;

PROCEDURE   TMemo.ScrollBy;
BEGIN
   Perform ( EM_LINESCROLL, horz, vert );
END;

PROCEDURE TMemo.AllocateLines;
BEGIN
   TokenisePChar ( GetTextBuffer, Lines, [#13{, #10}] );
END;

FUNCTION  TMemo.ReadFromFile;
VAR
l   : WinInteger;
i   : WinInteger;
MaxSize : Integer;
OurFile : FILE;
BEGIN
   Result := - 1;
   IF FName = '' THEN Exit;

   Assign ( OurFile, FName );
   IF Name = 'TRichEdit'
      THEN MaxSize := MaxEditSize
        ELSE MaxSize := 65500;

   Reset ( OurFile, 1 );
   IF Ioresult <> 0 THEN exit;

   FileName := FName;
   l := FileSize ( ourFile );
   IF l > ( MaxSize ) THEN l := ( MaxSize );
   ClearBuffer;
   Getmem ( Buffer, l + 1 );
   BlockRead ( OurFile, Buffer^, l, i );
   IF ioresult <> 0 THEN;
   Close ( OurFile ); IF ioresult <> 0 THEN;
   Result := i;
   IF i > 0
   THEN BEGIN
      SetWindowText ( Handle, '' );
      PostMessage ( Handle, 0, 0, 0 );
      SetWindowText ( Handle, Buffer );
      AllocateLines;
   END;
END;

FUNCTION  TMemo.WriteToFile;
VAR
p : pChar;
t : TextFile;
BEGIN
  WriteToFile := - 2;
  p := GetTextBuffer;
  IF ( p <> NIL )
  THEN BEGIN
     assign ( t, fname );
     rewrite ( t );
     IF ioresult = 0
     THEN BEGIN
       writeln ( t, p );
       Close ( t ); IF ioresult <> 0 THEN;
       Result := lStrLen ( p );
       FileName := FName;
     END;
 END;
END;
{*************************************}
FUNCTION RichEditReadCallback ( dwCookie : DWORD; Data : pByte{Var Data};
cb : WinInteger; VAR pcb : WinInteger ) : DWORD;
STDCALL;
{$ifdef  __GPC__}FORWARD;
FUNCTION RichEditReadCallback ( dwCookie : DWORD; Data : pByte;
cb : WinInteger; VAR pcb : WinInteger ) : DWORD;
{$endif}
BEGIN
  Result := 0;
  pcb := 0;
  IF CB > 0
  THEN BEGIN
      pcb := FileRead ( dwCookie, Data^, CB );
     // IF pcb = 0 THEN Result := 1;
  END;
END;

FUNCTION RichEditWriteCallback ( dwCookie : DWORD;
Data : pByte; cb : WinInteger; VAR pcb : WinInteger ) : DWORD;
STDCALL;
{$ifdef __GPC__}FORWARD;
FUNCTION RichEditWriteCallback ( dwCookie : DWORD; Data : pByte;
cb : WinInteger; VAR pcb : WinInteger ) : DWORD;
{$endif}
BEGIN
  Result := 0;
  pcb := 0;
  IF CB > 0
  THEN BEGIN
      pcb := FileWrite ( dwCookie, Data^, CB );
      // IF pcb = 0 THEN Result := 1;
  END;
END;

CONSTRUCTOR TRichEdit.Init;
BEGIN
  InitCommonControls;
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
   Attr.Style := Attr.Style
                 // OR CS_HREDRAW OR CS_VREDRAW
                 OR CS_DBLCLKS;
   PlainText := False;
   DllHandle := LoadLibrary ( 'RICHED32.DLL' );
   Name := 'TRichEdit';
END;

PROCEDURE   TRichEdit.SetTextLimit ( aLimit : DWord );
BEGIN
  Perform ( EM_EXLIMITTEXT, 0, aLimit );
END;

DESTRUCTOR TRichEdit.Done;
BEGIN
   FreeLibrary ( DllHandle );
   INHERITED Done;
END;

FUNCTION TRichEdit.GetClassName;
BEGIN
  Result := 'RichEdit';
END;

FUNCTION TRichEdit.IsRtfFile ( CONST FName : String ) : Boolean;
VAR
F : FILE;
p : ARRAY [0..7] OF Char;
i : WinInteger;
BEGIN
   Strcopy ( P, ' ' );
   Assign ( F, FName );
   Reset ( F, 1 );
   IF IOResult = 0
   THEN BEGIN
      BlockRead ( F, p, Sizeof ( p ), i );
      Close ( F );
   END;
   Result := Pos ( RTF_Code, StrPas ( p ) ) <> 0;
END;

FUNCTION FSize ( CONST FName : String ) : DWord;
VAR
F : FILE;
BEGIN
   Result := 0;
   Assign ( F, FName );
   Reset ( F, 1 );
   IF IOResult = 0
   THEN BEGIN
      Result := FileSize ( F );
      Close ( F );
   END;
END;

FUNCTION  TRichEdit.ReadFromFile;
VAR
i, w : DWord;
BEGIN
   Result := - 1;
   IF ( FName = '' ) OR ( NOT ( FileExists ( FName ) ) )
      THEN Exit;

   IF ( PlainText ) OR ( NOT IsRtfFile ( FName ) )
   THEN BEGIN
      w := SF_TEXT;
   END ELSE BEGIN
      w := SF_RTF;
      PlainText := False;
   END;

   i := FSize ( FName );
   IF i > GetTextLimit THEN SetTextLimit ( i + 16 );

   FileHandle := FileOpen ( FName, fmOpenRead );
   IF FileHandle = - 1 THEN Exit;
   FileName := FName;

   WITH SaveIt
   DO BEGIN
      dwCookie := FileHandle;
      dwError := 0;
      @pfnCallback := @RichEditReadCallback;
   END;

   Result := Perform ( EM_STREAMIN, w, WinInteger ( @SaveIt ) );

   FileClose ( FileHandle );

   AllocateLines;
END;

FUNCTION    TRichEdit.WriteToFile;
BEGIN
   Result := - 1;
   IF FName = '' THEN Exit;

   IF PlainText
   THEN BEGIN
      Result := INHERITED WritetoFile ( FName );
      Exit;
   END;

   FileHandle := FileCreate ( FName );
   IF FileHandle = - 1 THEN Exit;
   FileName := FName;

   WITH SaveIt
   DO BEGIN
      dwCookie := FileHandle;
      dwError := 0;
      @pfnCallback := @RichEditWriteCallback;
   END;

   Result := Perform ( EM_STREAMOUT, SF_RTF, WinInteger ( @SaveIt ) );
   FileClose ( FileHandle );
END;

FUNCTION    TRichEdit.SearchFor;
VAR
T : TFindText;
BEGIN
   WITH T DO BEGIN
       chrg.cpMin := - 1; {!!}
       chrg.cpMax := - 1;
       lpstrText := sChar ( s );
   END;
   Result := Perform ( EM_FINDTEXT, 0, lParam32 ( @T ) );
END;


{*************************************}
CONSTRUCTOR TCheckBox.Init;
BEGIN
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
  Name := 'TCheckBox';
  Attr.Style := Attr.Style OR BS_AUTOCHECKBOX;
END;

FUNCTION TCheckBox.Checked : Boolean;
BEGIN
    Result := Perform ( BM_GETCHECK, 0, 0 ) = 1;
END;

PROCEDURE TCheckBox.Check;
BEGIN
  PostMessage ( hWindow, BM_SetCheck, 1, 0 );
END;

PROCEDURE TCheckBox.UnCheck;
BEGIN
   PostMessage ( hWindow, BM_SetCheck, 0, 0 );
END;

{*************************************}
CONSTRUCTOR TRadioButton.Init;
BEGIN
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
  Name := 'TRadioButton';
  Attr.Style := WS_CHILD OR WS_VISIBLE
             OR BS_PUSHBUTTON OR BS_AUTORADIOBUTTON OR WS_TabStop;
  Default := FALSE;
END;

{*************************************}
CONSTRUCTOR TButton.Init;
BEGIN
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
  Name := 'TButton';
  Use3D := True;
  Attr.Style := Attr.Style OR BS_PUSHBUTTON;
END;

CONSTRUCTOR TButton.InitResource;
BEGIN
   INHERITED InitResource ( Owner, ResourceID );
   Name := 'TButton';
END;

FUNCTION    TButton.GetClassName : pChar;
BEGIN
   Result := 'button';
END;

PROCEDURE TButton.Click;
BEGIN
  PostMessage ( hWindow, wm_LButtonDown, 0, 0 );
  PostMessage ( hWindow, wm_LButtonUp,   0, 0 );
END;
{*************************************}
CONSTRUCTOR TBitBtn.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, x, y, w, h );
   Name := 'TBitBtn';
   BitmapResource := Strpas ( aBitmap );
   BitmapFile := Strpas ( aBitmap );
   WITH Attr DO BEGIN
       Style := Style OR BS_OWNERDRAW;
   END;
   TextAlignMent := AlignCenter;
END;

FUNCTION TBitBtn.CreateWnd : Boolean;
BEGIN
   CASE TextAlignment OF
      AlignLeft : Attr.Style := Attr.Style OR BS_Left;
      AlignCenter : Attr.Style := Attr.Style OR BS_Center OR BS_VCenter;
      AlignRight : Attr.Style := Attr.Style OR BS_Right;
   END;
   Result := INHERITED CreateWnd;
END;
{*************************************}
CONSTRUCTOR TGroupBox.Init;
BEGIN
  INHERITED Init ( Owner, AnID, aTitle, X, Y, W, H );
  Attr.Style := Attr.Style OR BS_GROUPBOX;
END;
{*************************************}
FUNCTION TRadioGroup.SetItemIndex ( index : WinInteger ) : Boolean;
BEGIN
   Result := PostMessage ( GetDlgItem ( Handle, Index ), BM_SetCheck, 1, 0 );
END;

FUNCTION TRadioGroup.GetItemIndex : WinInteger;
VAR
i : Integer;
BEGIN
   Result := - 1;
   FOR i := 0 TO Items.LoopCount
   DO BEGIN
       IF SendMessage ( GetDlgItem ( Handle, i ), BM_GETCHECK, 0, 0 ) = 1
       THEN BEGIN
          Result := i;
          Exit;
       END;
   END;
END;

FUNCTION TRadioGroup.GetSelectedString : TString;
VAR
i : Integer;
BEGIN
   Result := '';
   i := GetItemIndex;
   IF i >= 0 THEN Result := Items.Strings ( i );
END;

CONSTRUCTOR TRadioGroup.Init;
BEGIN
   INHERITED Init ( Owner, AnID, aTitle, x, y, w, h );
   // Attr.Style := Attr.Style OR WS_Group OR WS_TabStop;
   Columns := 1;      // 1 column
   ItemIndex := - 1;   // don't check anything to start with
   Name := 'TRadioGroup';
   Items.Create;
End;

Destructor TRadioGroup.Done;
Begin
   Items.Done;
   Inherited Done;
End;

Function TRadioGroup.CreateWnd : Boolean;
Var
Wid,ColumnCount,
ItemsPerColumn,
x1, y1, h1, i, j : integer;
p : pRadioButton;
Begin
  x1 := 10;
  h1 := 25;
  y1 := h1;
  j := 0;
  Wid := (Attr.W div Columns) - 5;
  ItemsPerColumn := Items.Count Div Columns;
  ColumnCount := 1;
  for i := 0 to Items.LoopCount
  do begin
    If  (Columns > 1)
    and ((y1 > (Attr.H - h1)) or (j > ItemsPerColumn))
    and (ColumnCount < Columns)
    then begin
       Inc (ColumnCount);
       x1 := x1 + Wid;
       y1 := h1;
       j := 0;
    end;
    Inc (j);
    p := New (pRadioButton, Init (SelfPtr, i, Items.pChars(i), x1, y1, Wid, h1 ) );
    inc (y1, h1);
  end;
  Result := Inherited CreateWnd;
  If ItemIndex >= 0 then SetItemIndex (ItemIndex);
End;
{*************************************}
CONSTRUCTOR TPanel.Init;
BEGIN
   Inherited Init ( Owner, AnID, ATitle, 1, 550, 200, HH );
   Attr.Style := Attr.Style OR BS_LEFT;
   Attr.ExStyle :=
                {WS_EX_CLIENTEDGE or WS_EX_DLGMODALFRAME or}
                WS_EX_STATICEDGE
                OR
                WS_EX_WINDOWEDGE;

   AlignBottom := Alignment = 1;
   WITH Attr DO BEGIN
       X := 1;
       W := Parent^.Attr.W - 1;
       IF AlignBottom THEN Y := ( Parent^.Attr.H - H ) ELSE Y := 1;
   END;
END;
{*************************************}
FUNCTION  TScrollBar.GetClassName;
BEGIN
   Result := 'ScrollBar';
END;

{*************************************}
CONSTRUCTOR TListStrings.Create ( Owner : pListBox );
BEGIN
   Inherited Create;
   fListBox := Owner;
   FromParent := False;
END;

FUNCTION  TListStrings.LoadFromFile ( CONST FName : String ) : WinInteger;
BEGIN
  IF Assigned ( fListBox ) THEN fListBox^.Clear;
  Result := Inherited LoadFromFile ( FName );
END;

FUNCTION TListStrings.AddP ( CONST s : pChar ) : WinInteger;
Begin
   Result := Add (Strpas (s));
End;

FUNCTION TListStrings.Add ( CONST s : String ) : WinInteger;
VAR
j : WinInteger;
b : Boolean;
BEGIN
   j := Inherited Add ( s );
   IF ( NOT FromParent ) and ( j > 0 ) AND ( Assigned ( fListBox ) )
   THEN
     WITH fListBox^
     DO BEGIN
       b := AddToLines;
       AddToLines := False;
       AddStringEx ( s );
       AddToLines := b;
    END;
   Result := j;
END;

PROCEDURE  TListStrings.DeleteP ( Index : Cardinal );
VAR
b : Boolean;
BEGIN
   Inherited DeleteP ( Index );
   IF ( NOT FromParent ) and ( Assigned ( fListBox ) )
   THEN
    WITH fListBox^
    DO BEGIN
       b := AddToLines;
       AddToLines := False;
       DeleteString ( Index );
       AddToLines := b;
    END;
END;

{*************************************}
FUNCTION  TListBox.GetClassName;
BEGIN
   Result := 'ListBox';
END;
{
PROCEDURE TListBox.WMMOUSEMOVE ( VAR Msg : TMessage );
Begin
   If (ShowHint) and (Hint <> '') then Writeln (Hint);
End;
}
CONSTRUCTOR TListBox.Init;
BEGIN
  Inherited Init ( Owner, AnID, aTitle, X, Y, W, H );
  Sorted := False;
  Attr.Style := Attr.Style OR LBS_STANDARD OR LBS_NOTIFY;
  IsCombo := False;
  Name := 'TListBox';
  AddToLines := True;
  Lines.Create ( @Self );
END;

DESTRUCTOR TListBox.Done;
BEGIN
  Lines.Done;
  Inherited Done;
END;

FUNCTION TListBox.CreateWnd : Boolean;
BEGIN
   IF NOT Sorted
   THEN BEGIN
      IF IsCombo
         THEN Attr.Style := Attr.Style AND NOT CBS_Sort
           ELSE Attr.Style := Attr.Style AND NOT LBS_Sort;
   END;
   Result := Inherited CreateWnd;
END;

PROCEDURE  TListBox.SetSorted ( ASorted : Boolean );
VAR
Code : WinInteger;
BEGIN
   Sorted := ASorted;
   IF IsCombo THEN Code := CBS_Sort ELSE Code := LBS_Sort;
   IF Sorted THEN Attr.Style := Attr.Style OR Code
             ELSE Attr.Style := Attr.Style AND NOT Code;
   SetWindowLong ( Handle, GWL_Style, Attr.Style );
END;

FUNCTION TListBox.GetClickParam ( VAR Msg : TMessage ) : WinInteger;
BEGIN
   Result := Msg.WParamHi;
END;

FUNCTION  TListBox.AddString;
BEGIN
  MsgID := lb_addString;
  IF IsCombo THEN MsgID := cb_addString;
  Result := Perform ( MsgID, 0, WinInteger ( aString ) );
  Lines.FromParent := True;
  IF ( Result >= 0 ) AND ( AddToLines ) THEN Lines.AddP ( aString );
  Lines.FromParent := False;
END;

FUNCTION  TListBox.AddStringEx;
BEGIN
  Result := AddString ( {$ifndef __GPC__}pChar{$endif} ( aString ) );
END;

FUNCTION  TListBox.InsertString;
BEGIN
  MsgID := lb_InsertString;
  IF IsCombo THEN MsgID := cb_InsertString;
  Result := Perform ( MsgID, Index, WinInteger ( aString ) );
  Lines.FromParent := True;
  IF ( Result >= 0 ) THEN Lines.InsertP ( Index, StrPas ( aString ) );
  Lines.FromParent := False;
END;

FUNCTION TListBox.DeleteString;
BEGIN
  MsgID := lb_DeleteString;
  IF IsCombo THEN MsgID := cb_DeleteString;
  Result := Perform ( MsgID, Index, 0 );
  Lines.FromParent := False;
  IF ( Result >= 0 ) AND ( AddToLines ) THEN Lines.DeleteP ( Index );
  Lines.FromParent := False;
END;

FUNCTION TListBox.GetSelIndex;
BEGIN
  MsgID := lb_GetCurSel;
  IF IsCombo THEN MsgID := cb_GetCurSel;
  Result := Perform ( MsgID, 0, 0 );
END;

FUNCTION  TListBox.ItemIndex;
BEGIN
    Result := GetSelIndex;
END;

FUNCTION TListBox.ClearList;
BEGIN
  MsgID := lb_ResetContent;
  IF IsCombo THEN MsgID := cb_ResetContent;
  Result := Perform ( MsgID, 0, 0 );
  Lines.Clear;
END;

PROCEDURE TListBox.Clear;
BEGIN
  IF ClearList = 0 THEN;
END;

FUNCTION TListBox.GetCount;
BEGIN
  MsgID := lb_GetCount;
  IF IsCombo THEN MsgID := cb_GetCount;
  Result := Perform ( MsgID, 0, 0 );
END;

FUNCTION TListBox.SetSelIndex;
BEGIN
  MsgID := lb_SetCurSel;
  IF IsCombo THEN MsgID := cb_SetCurSel;
  Result := Perform ( MsgID, Index, 0 );
END;

FUNCTION TListBox.GetStringLen;
BEGIN
  MsgID := lb_GetTextLen;
  IF IsCombo THEN MsgID := cb_GetLBTextLen;
  Result := Perform ( MsgID, Index, 0 );
END;

FUNCTION TListBox.GetString;
BEGIN
  MsgID := lb_GetText;
  IF IsCombo THEN MsgID := cb_GetLBText;
  Result := Perform ( MsgID, Index, WinInteger ( aString ) );
END;

FUNCTION TListBox.GetSelString;
VAR
i : integer;
j : integer;
p : pChar;

BEGIN
  Result := - 1;
  i := GetSelIndex;
  j := GetStringLen ( i );

  IF ( i >= 0 ) THEN IF ( MaxChars >= j )
  THEN BEGIN
    Result := GetString ( aString, i )
  END
  ELSE BEGIN
      Getmem ( p, Succ ( j ) );
      GetString ( p, i );
      lStrcpyn ( aString, p, MaxChars );
      FreeMem ( p );
      Result := MaxChars;
    END; {i>=0 and MAxchars>=j}
END;

FUNCTION TListBox.SetSelString;
BEGIN
  MsgID := lb_SelectString;
  IF IsCombo THEN MsgID := cb_SelectString;
  Result := Perform ( MsgID, Index, WinInteger ( aString ) );
END;

FUNCTION TListBox.Text;
VAR
p : pchar;
BEGIN
   Result := '';
   getmem ( p, TStringLen );
   IF GetSelString ( p, TStringLen ) > 0
   THEN BEGIN
     aText := StrPasEx ( p );
     Result := aText;
     aText := aText + #0;
   END;
   freemem ( p );
END;

FUNCTION  TListBox.StringExists;
BEGIN
   MsgID := lb_FindStringExact;
   IF IsCombo THEN MsgID := cb_FindStringExact;
   Result := Perform ( MsgID, 0, WinInteger ( aString ) );
END;

FUNCTION  TListBox.StringPartlyExists;
BEGIN
   MsgID := lb_FindString;
   IF IsCombo THEN MsgID := cb_FindString;
   Result := Perform ( MsgID, 0, WinInteger ( aString ) );
END;
{*************************************}
CONSTRUCTOR TComboBox.Init;
BEGIN
  Inherited Init ( Owner, AnID, aTitle, X, Y, W, H );
  Attr.Style := Attr.Style OR WS_VScroll OR CBS_Sort OR CBS_DropDown OR CBS_AutoHScroll;
  IsCombo := True;
  Name := 'TComboBox';
END;

FUNCTION  TComboBox.GetClassName;
BEGIN
   Result := 'ComboBox';
END;

{*************************************}
{*************************************}
{*************************************}
{*************************************}
CONSTRUCTOR TMenu.Init;
BEGIN
   Inherited Init ( Owner );
   Name   := 'TMenu';
   Parent := Owner;
   Handle    := Parent^.Attr.Menu;
   ParentHandle := Parent^.Handle;
   IF Handle = 0
   THEN BEGIN
      Handle := CreateMenu;
      Parent^.Attr.Menu := Handle;
   END;
   SetMenu ( ParentHandle, Handle );
END;

FUNCTION TMenu.AddSubMenu;
VAR
i : hMenu;
h : hBitmap;
BEGIN
   Result := 0;
   i := CreateMenu;
   h := mf_PopUp OR mf_Enabled;
   IF BitmapID <> 0
     THEN h := h OR mf_Bitmap
       ELSE h := h OR MF_STRING;

   IF i <> 0
   THEN BEGIN
      IF BitmapID <> 0
        THEN AppendMenu ( Handle, h, i, pChar ( BitmapID ) )
          ELSE
           AppendMenu ( Handle, h, i, sChar ( aCaption ) );
      Result := i;
   END;
   DrawMenuBar ( ParentHandle );
END;

PROCEDURE TMenu.AddMenuItem;
VAR
h : hBitmap;
BEGIN
   IF ChildMenu = 0 THEN ChildMenu := Handle;
   IF ( aCaption = '' ) OR ( aCaption = ' - ' )
   THEN AppendMenu ( ChildMenu, mf_Separator, 0, '' )
   ELSE BEGIN
      h := mf_Enabled OR MF_String;
      IF BitmapID <> 0
      THEN BEGIN
         h := h OR mf_Bitmap AND not MF_String;
         AppendMenu ( ChildMenu, h, ID, pChar ( BitmapID ) );
      END ELSE AppendMenu ( ChildMenu, h, ID, sChar ( aCaption ) );
   END;
   DrawMenuBar ( ParentHandle );
END;

PROCEDURE TMenu.AddMenuSeparator ( ChildMenu : hMenu );
BEGIN
   IF ChildMenu = 0 THEN ChildMenu := Handle;
   AppendMenu ( ChildMenu, mf_Separator, 0, '' );
   DrawMenuBar ( ParentHandle );
END;
{*************************************}
{*************************************}
CONSTRUCTOR TCommonDialog.Init;
BEGIN
   Inherited Init ( Owner, Nil );
   Name := 'TCommonDialog';
END;

PROCEDURE TCommonDialog.Ok;
BEGIN
  IF CanClose THEN Msg.Result := 0 ELSE Msg.Result := 1;
END;

PROCEDURE TCommonDialog.Cancel;
BEGIN
    Msg.Result := 0
END;

FUNCTION TCommonDialog.CreateWnd;
BEGIN
    Result := False;
END;
{*************************************}
CONSTRUCTOR TColorDialog.Init;
BEGIN
   Inherited Init ( Owner );
   FillChar ( lf, Sizeof ( lf ), 0 );
   FillChar ( ClrArray, Sizeof ( ClrArray ), $c0 );
   WITH lf DO BEGIN
       lStructSize := Sizeof ( lf );
       IF Assigned ( Owner ) THEN hwndOwner := Owner^.Handle;
       hInstance := _hInstance;
       lpTemplateName := Nil;
       @lpfnHook := Instance;
       rgbResult := $ffffff;
       lpCustColors := {$ifdef __GPC__}pColorRef{$endif} ( @ClrArray );
   END;
   Name := 'TColorDialog';
END;

FUNCTION TColorDialog.Execute;
BEGIN
   IF ChooseColor ( {$ifdef FPC}@{$endif}lf )
   THEN BEGIN
      Result := id_Ok;
      Font.Color := lf.rgbResult
   END ELSE Result := id_Cancel;
END;

FUNCTION TColorDialog.Color;
BEGIN
   Result := lf.rgbResult;
END;
{*************************************}
CONSTRUCTOR TFontDialog.Init;
BEGIN
   Inherited Init ( Owner );
   FillChar ( tl, Sizeof ( tl ), 0 );
   FillChar ( lf, Sizeof ( lf ), 0 );
   Name := 'TFontDialog';
   WITH lf DO BEGIN
       lStructSize := Sizeof ( lf );
       IF Assigned ( Owner ) THEN hwndOwner := Owner^.Handle;
       lpLogFont := @tl;
       Flags := CF_SCREENFONTS OR CF_EFFECTS;
       hDC := 0;
       lCustData := 0;
       @lpfnHook := Nil;
       hInstance := 0;
       lpszStyle := Nil;
   END;
END;

FUNCTION  TFontDialog.Execute;
BEGIN
   IF ChooseFont ( {$ifdef FPC}@{$endif}lf )
   THEN BEGIN
      Result := id_Ok;
      Font.lFont := tl;
      StrCopy (Font.Name, tl.lfFaceName );
      Font.Size := lf.iPointSize div 10;
      Font.Color := lf.rgbColors;
   END ELSE Result := id_Cancel;
END;
{*************************************}
CONSTRUCTOR TFindDialog.Init;
BEGIN
   Inherited Init ( Owner );
   FillChar ( FindRec, Sizeof ( FindRec ), 0 );
   WITH FindRec
   DO BEGIN
       lStructSize := Sizeof ( FindRec );
       IF Assigned ( Owner ) THEN hwndOwner := Owner^.Handle;
       hInstance := _hInstance;
       Flags := 0;
       lCustData := SelfID;
   END;
   FindText := '';
   ReplaceString := '';
   Name := 'TFindDialog';
   MatchCase := False;
   MatchWholeWords := False;
   SearchDown := True;
END;

// kludge to deal with empty strings - fill with blanks
Function fill_zero : TControlStr;
Var
i : WinInteger;
begin
   SetLength (Result, TControlStrlen - 2);
   for i := 1 to TControlStrLen - 2 do Result [i] := #0;
end;

FUNCTION TFindDialog.Execute;
VAR
p : pFindDialog;
BEGIN
   Parent^.FindMsg := RegisterWindowMessage ( FINDMSGSTRING );
   FindMsg := Parent^.FindMsg;
   FindText := FindText + #0;
   If FindText = #0 then FindText := fill_zero;

   WITH FindRec
   DO BEGIN
       lpstrFindWhat := @FindText [1];
       wFindWhatLen := Length ( FindText );
       wReplaceWithLen := Length ( ReplaceString );

       IF SearchDown THEN Flags := Flags OR FR_DOWN;
       IF MatchCase THEN Flags := Flags OR FR_MATCHCASE;
       IF MatchWholeWords THEN Flags := Flags OR FR_WHOLEWORD;

       Result := {$ifdef __GNU__}Windows{$else}Commdlg{$endif}.FindText
       ( {$ifdef FPC}@{$endif}FindRec ); {***}

       IF ISWindow ( Result )
       THEN BEGIN
          Handle := Result;
          p := New ( pFindDialog, Init ( Parent ) );
          p^ := Self;
          Handle := 0;
       END;
   END;
END;

FUNCTION TFindDialog.Find;
BEGIN
   FindText := s;
   Result := Execute;
END;

FUNCTION TFindDialog.Replace;
VAR
p : pFindDialog;
BEGIN
   Parent^.FindMsg := RegisterWindowMessage ( FINDMSGSTRING );
   FindMsg := Parent^.FindMsg;

   FindText := TheOld + #0;
   If FindText = #0 then FindText := fill_zero;

   ReplaceString := TheNew + #0;
   If ReplaceString = #0 then ReplaceString := fill_zero;

   WITH FindRec
   DO BEGIN
       lpstrFindWhat := @FindText [1];
       wFindWhatLen := Length ( FindText );

       lpstrReplaceWith := @ReplaceString [1];
       wReplaceWithLen := Length ( ReplaceString );

       IF SearchDown THEN Flags := Flags OR FR_DOWN;
       IF MatchCase THEN Flags := Flags OR FR_MATCHCASE;
       IF MatchWholeWords THEN Flags := Flags OR FR_WHOLEWORD;

       Result := ReplaceText ( {$ifdef FPC}@{$endif}FindRec );

       IF ISWindow ( Result )
       THEN BEGIN
          Handle := Result;
          p := New ( pFindDialog, Init ( Parent ) );
          p^ := Self;
          Handle := 0;
       END;
   END;
END;

{*************************************}
CONSTRUCTOR TPrinterDialog.Init;
BEGIN
   Inherited Init ( Owner );
   //deviceMode
   //DInfo
   FillChar ( Printer, Sizeof ( Printer ), 0 );
   Name := 'TPrinterDialog';
   FillChar ( Printer, Sizeof ( Printer ), 0 );
   WITH Printer
   DO BEGIN
       lStructSize := Sizeof ( Printer );
       IF Assigned ( Owner ) THEN hwndOwner := Owner^.Handle;
       hInstance := _hInstance;
       lpPrintTemplateName := Nil;
       lpSetupTemplateName := Nil;
       @lpfnPrintHook := Instance;
       Flags := PD_RETURNDC ;
       nCopies := 1;
   END;
END;

FUNCTION TPrinterDialog.Execute;
BEGIN
  IF PrintDlg ( {$ifdef FPC}@{$endif}Printer )
     THEN Result := id_OK
       ELSE Result := id_Cancel;
END;

FUNCTION TPrinterDialog.Print;
BEGIN
  With Printer
  do begin
     Flags := PD_RETURNDC OR PD_ALLPAGES OR PD_PAGENUMS;
     If NOT PrintSetup then Flags := Flags OR PD_RETURNDEFAULT ;
  end;
  Result := Execute;

  FileName := FileName + #0;
  With DInfo
  do begin
     cbSize := sizeof (TDOCINFO);
     lpszDocName := @FileName [1];
     lpszOutput := Nil;
  end;

  If Result = ID_Ok
  then begin
     StartDoc (DC, DInfo);
     StartPage (DC);
     Rectangle (DC,  10,  10, 400, 400);
     Rectangle (DC,  60,  60, 600, 600);
     Rectangle (DC, 110, 110, 600, 600);
     EndPage (DC);
     EndDoc (DC);
     DeleteDC (DC);
  end;
END;

Function  TPrinterDialog.DC : hDC;
Begin
   Result := Printer.hDC;
End;

Procedure TPrinterDialog.SetDeviceMode ( Const  aMode : TDevMode );
Begin
End;

Function  TPrinterDialog.StartPrinter : Boolean;
Begin
  With Printer
  do begin
     Flags := PD_RETURNDEFAULT OR PD_RETURNDC OR PD_ALLPAGES OR PD_PAGENUMS;
  end;

  With DInfo
  do begin
     cbSize := sizeof (TDOCINFO);
     lpszDocName := 'Hello';
     lpszOutput := Nil;
  end;
  Result := PrintDlg ( {$ifdef FPC}@{$endif}Printer );

  If Result
  then begin
     StartDoc (DC, DInfo);
   {
   // Set the printer up for landscape mode printing
   deviceMode = (DEVMODE *) GlobalLock (printer.hDevMode);
   deviceMode->dmOrientation = DMORIENT_LANDSCAPE;
   deviceMode->dmFields |= DM_ORIENTATION;

     ResetDC (DC, deviceMode);
     GlobalUnlock (printer.hDevMode);
  }
     StartPage (DC);
  end;
End;

Function  TPrinterDialog.StopPrinter : Boolean;
Begin
   EndPage (DC);
   EndDoc (DC);
   DeleteDC (DC);
   Result := True;
End;

Function  TPrinterDialog.PrintData ( Const Data; DataSize : DWord ) : Boolean;
Begin
  Rectangle (DC,  10,  10, 400, 400);
  Rectangle (DC,  60,  60, 600, 600);
  Rectangle (DC, 110, 110, 600, 600);
  Result := True;
End;

FUNCTION TPrinterDialog.SetupPrinter;
VAR
Old : DWord;
BEGIN
  WITH Printer DO BEGIN
      Old := Flags;
      Flags := PD_RETURNDC OR PD_PRINTSETUP;
  END;
  Result := Execute;
  Printer.Flags := Old;
END;

{*************************************}

PROCEDURE TEditDialog.SetupWindow;
BEGIN
   Inherited SetupWindow;
   Edit.Focus;
END;

CONSTRUCTOR TEditDialog.Init;
BEGIN
  InitTemplate   ( Owner, aCaption,     10, 20, 455, 150 );
  lStatic.Init   ( SelfPtr, 0, aPrompt,  20, 5, 400, 45 );
  Edit.Init      ( SelfPtr, 0, aDefault, 20, 75, 400, 25 );
  OkBtn.Init     ( SelfPtr, id_OK, '&Ok', 85, 120, 100, 25 );
  CancelBtn.Init ( SelfPtr, id_Cancel, 'C&ancel', 220, 120,  100, 25 );
  Selection := '';
  WITH lStatic.Font
  DO BEGIN
     StrCopy (Name, {:=} 'Times New Roman');
     Size := 11;
{//     Color := $FFFFFFF;}
  END;
  OkBtn.Font := lStatic.Font;
  CancelBtn.Font := lStatic.Font;
  Edit.Font := lStatic.Font;
  Name := 'TEditDialog';
END;

PROCEDURE TEditDialog.Ok;
BEGIN
    Selection := Edit.Text;
    inherited ok ( msg );
END;
{*************************************}

{*************************************}
PROCEDURE TCommonFileDialog.SetTitle ( CONST aCaption : String );
BEGIN
   sCaption := aCaption;
END;

PROCEDURE TCommonFileDialog.SetDescription ( CONST aCaption : String );
BEGIN
   Description := aCaption;
END;

PROCEDURE TCommonFileDialog.SetFileSpecs ( CONST aCaption : String );
BEGIN
   FileSpecs := aCaption;
END;

PROCEDURE TCommonFileDialog.SetFilter;
BEGIN
   IF Name = 'TFileSaveAsDialog'
     THEN Filter := FileSpecs + #0#0
       ELSE Filter := Description + ' ( ' + FileSpecs + ' ) ' + #0#0;
END;

PROCEDURE TCommonFileDialog.SetFlags ( CONST aFlag : WinInteger );
BEGIN
   FileFlags := aFlag;
END;

PROCEDURE TCommonFileDialog.UpdateAll;
BEGIN
   SetFilter;
   FileName := '';
   AddNull ( Description );
   AddNull ( sCaption );
   AddNull ( FileSpecs );
   WITH OFN
   DO BEGIN
     Flags       := FileFlags { or OFN_ENABLEHOOK};
     lpstrFilter := @Filter [1];
     lpstrTitle  := @sCaption [1];
     lpstrFile := @filespecs [1];
   END;
END;

CONSTRUCTOR TCommonFileDialog.Init
( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
BEGIN
   TDialog.Init ( AParent, nil );
   SetFlags ( ofn_Explorer );
   SetTitle ( '' );
   FileName := '';
   SetFileSpecs ( StrPas ( AFileName ) );
   SetDescription ( 'All files ' );
   SetFilter;
   Name := 'TCommonFileDialog';

   FillChar ( OFN, Sizeof ( OFN ), #0 );
   WITH OFN DO
   BEGIN
     lStructSize := SizeOf ( OFN );
     IF Assigned ( AParent )
       THEN hwndOwner := AParent^.Handle
         ELSE hwndOwner := 0;
     @lpfnHook := Instance;
     Flags     := FileFlags OR OFN_ENABLEHOOK;
     nMaxFile  := ANameLength;
     hInstance := _hInstance;
     lpstrFilter := @Filter [1];
     lpstrFile := @FileSpecs [1];
     lpstrFileTitle  := nil;
     nMaxFileTitle   := 0 ;
   END;
END;

DESTRUCTOR TCommonFileDialog.Done;
BEGIN
  TDialog.Done;
END;

FUNCTION    TCommonFileDialog.CreateWnd : Boolean;
BEGIN
  Result := False;  { Cannot create a non-modal File Open dialog }
END;

FUNCTION    TCommonFileDialog.Execute : WinInteger;
VAR
  CDError : WinInteger;
  OldKbHandler : PWindowsObject;
BEGIN
  IF Status = 0
  THEN BEGIN
    DisableAutoCreate;
    EnableKBHandler;
    IsModal := True;
    OldKbHandler := Application^.KBHandlerWnd;
    UpdateAll;
    IF CDExecute
    THEN BEGIN
       Result := id_ok
    END
    ELSE BEGIN
      CDError := CommDlgExtendedError;
      IF CDError = 0 THEN Result := id_Cancel
      ELSE BEGIN
         Status := - CdError;
         Result := Status;
      END;
    END;
    Application^.KBHandlerWnd := OldKbHandler;
    Handle := 0;
  END
  ELSE Result := Status;
END;

FUNCTION TCommonFileDialog.CDExecute : Boolean;
BEGIN
  UpdateAll;
  Result := GetOpenFileName ( {$ifdef FPC}@{$endif}OFN );
  IF Result
  THEN BEGIN
     IF OFN.lpstrFile <> Nil
        THEN FileName := StrPas ( OFN.lpstrFile );
  END;
END;

FUNCTION TCommonFileDialog.GetFileName : TDialogString;
BEGIN
  Result := '';
  IF CDExecute THEN Result := FileName;
END;

PROCEDURE   TCommonFileDialog.OK ( VAR Msg : TMessage );
BEGIN
  IF CanClose THEN Msg.Result := 0 ELSE Msg.Result := 1;
END;

PROCEDURE   TCommonFileDialog.Cancel ( VAR Msg : TMessage );
BEGIN
  Msg.Result := 0
END;

CONSTRUCTOR TFileOpenDialog.Init
     ( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
BEGIN
  inherited Init ( AParent, AFileName, ANameLength );
  Name := 'TFileOpenDialog';
  SetTitle ( 'File Open' );
  UpdateAll;
END;

CONSTRUCTOR TFileSaveAsDialog.Init
     ( AParent : PWindowsObject; AFileName : PChar; ANameLength : Word );
BEGIN
  inherited Init ( AParent, AFileName, ANameLength );
  Name := 'TFileSaveAsDialog';
  SetTitle ( 'File Save AS' );
  UpdateAll;
END;

FUNCTION TFileSaveAsDialog.CDExecute : Boolean;
BEGIN
  UpdateAll;
  Result := GetSaveFileName ( {$ifdef FPC}@{$endif}OFN );
  IF Result
  THEN BEGIN
     IF OFN.lpstrFile <> Nil THEN FileName := StrPas ( OFN.lpstrFile );
  END;
END;

{high level functin to retrieve a filename;
aParent: The OWL parent
Flags  : e.g., ofn_Explorer, etc
Desc   : the description of the file types (e.g., 'Pascal sources')
Specs  : the default file specifications (e.g., ' * .pas')
e.g.,
FName := GetFileOpenName
                (@Self,
                 ofn_Explorer,
                 'Select FILE',
                 'Pascal Source files (*.pas;*.dpr)',
                 '*.pas;*.dpr'
                 );
}
FUNCTION GetFileOpenName{
(aParent:pWindowsObject;
Flags:WinInteger;
Const aCaption,
Desc,
Specs:String):String};
VAR
T : pFileOpenDialog;
Temp : ARRAY [0..260] OF char;
BEGIN
   Strpcopy ( Temp, '' );
   New ( T );
   WITH T^ DO BEGIN
      Init ( aParent, Temp, SizeOf ( Temp ) );
      SetFlags ( Flags );
      SetDescription ( Desc );
      SetFileSpecs ( Specs );
      SetTitle ( aCaption );
      UpdateAll;
      Execute;
      Done;
   END;
   pChar2String ( Temp, Result );
   Dispose ( T );
END;

FUNCTION GetFileSaveName{
(aParent:pWindowsObject;Flags:WinInteger;Const aCaption,Desc,Specs:String):String};
VAR
T : pFileSaveAsDialog;
Temp : ARRAY [0..260] OF char;
BEGIN
   Strpcopy ( Temp, '' );
   New ( T );
   WITH T^ DO BEGIN
      Init ( aParent, Temp, SizeOf ( Temp ) );
      SetFlags ( Flags );
      SetDescription ( Desc );
      SetFileSpecs ( Specs );
      SetTitle ( aCaption );
      UpdateAll;
      If CDExecute then Strpcopy (Temp, FileName);
      Done;
   END;
   pChar2String ( Temp, Result );
   Dispose ( T );
END;

{*************************************}
{*************************************}
{*************************************}
{*************************************}
{*************************************}
END.

