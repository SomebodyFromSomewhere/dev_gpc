{
***************************************************************************
*                 cWindows.pas
*  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements a (slightly) BP-compatible oWindows unit
*  for GNU Pascal for Win32.
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     To provide Pascal objects for creating Windows GUI interfaces and widgets
*
*    Objects:
*           TWndParent        --> ancestor class: not to be instantiated
*           TWindowsObject
*           TWindow
*           THintWindow
*           TBitmapWindow
*           TDialogWindow
*           TTimer
*           TApplication
*
*  The functionality is based almost entirely on Win32 API routines,
*  and so it is not portable, except perhaps via WINE.
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal,
*  and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 01 Oct 2005
*  Version: 1.02
*  Licence: Shareware
*
*  NOTES: this unit is work-in-progress; some things need more work !
***************************************************************************
}

{///////////////////////////////////////}
{$i cwindows.inc}  { defines or undefines "IS_UNIT", sChar, etc }
{.$define Delphi}
{///////////////////////////////////////}
{$ifdef IS_UNIT}
UNIT cWindows;

INTERFACE
{$endif}
{///////////////////////////////////////}

{$ifdef IS_UNIT}
   USES
   {$ifdef __GPC__}System,{$endif}
   Objects,
   SysUtils,
   Messages,
   Windows,
   Commdlg,
   ShellApi,
   cClasses,
   cBitmaps;
{$else}
   USES
   Objects,
   cClasses;
   {$i windows.inc}
{$endif}
   {$X+}
   {$W-}
   {$i-}

CONST
WM_First = 0;     { start of Windows messages }
CM_First = $A000; { start of menu IDs }
ID_First = 32768; { start of child messages }
id_Separator = 0; { horizontal separator for menu items }

{ built-in menu tags }
CONST
CM_FileNew    = CM_First + 1;
CM_FileOpen   = CM_First + 2;
CM_FileSave   = CM_First + 3;
CM_FileSaveAs = CM_First + 4;
CM_FilePrint  = CM_First + 5;
CM_FileExit   = CM_First + 6;
CM_FileClose  = CM_First + 7;

CM_EditUndo   = CM_First + 20;
CM_EditCut    = CM_First + 21;
CM_EditCopy   = CM_First + 22;
CM_EditPaste  = CM_First + 23;
CM_EditDelete = CM_First + 24;

CM_SearchFind     = CM_First + 30;
CM_SearchFindNext = CM_First + 31;
CM_SearchReplace  = CM_First + 32;

CM_HelpTopics  = CM_First + 40;
CM_HelpAbout   = CM_First + 41;

{$ifdef FPC}
 ID_OK     = 1;
 ID_Cancel = 2;
 id_Abort  = 3;
 id_Retry  = 4;
 id_Ignore = 5;
 id_Yes    = 6;
 id_No     = 7;
{$endif}

{$ifdef __GPC__}
{$else}
TYPE
  {$ifndef VirtualPascal}SmallWord = Word;{$endif}
  WParam32  = Longint;
  LParam32  = Longint;
  LTRect    = Windows.TRect;
  FUNCTION StrNew ( Src : pChar ) : pChar;
  PROCEDURE StrDispose ( VAR p : pChar );
{$endif}

{  other stuff }
TYPE
TextFile    = Text;
TWindowProc = FUNCTION ( Window : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : LResult
{$ifndef __GPC__}{$ifndef __TMT__}STDCALL{$endif}{$endif};

TWindowAttr = PACKED RECORD
   Title : PChar;
   Style : Int64;
   ExStyle,
   X, Y, W, H : WinInteger;
   Param : Pointer;
   CASE WinInteger OF
    0 : ( Menu : HMenu );  { window menu's handle or... }
    1 : ( Id : LongWord );  { control's child identifier }
END;

{*************************************}

TYPE
TBorderStyle = ( bsNone, bsSingle, bsSizeable, bsDialog );
TFontStyle = ( fsBold, fsItalic, fsUnderline, fsStrikeOut );
TFontStyles = set OF TFontStyle;
TFontName = ARRAY [0..63] OF char; // String [ 64 ];
pFont = ^TFont;
TFont = {PACKED }RECORD
    Name  : TFontName;
    Style : TFontStyles;
    Brush,
    Handle : THandle;
    BackGround,
    Color  : TColorRef;
    Pitch,
    PixelsPerInch,
    Height,
    Size  : Integer;
    TransparentBackground : Boolean;
    lFont : Tlogfont;
END;
{*************************************}

TYPE
pWndParent   = ^TWndParent;
pWindowsObject = ^TWindowsObject;
pHintWindow = ^THintWindow;

TMessage = PACKED RECORD
   Sender  : pWindowsObject; { extra! : points to the object instance that caused the message to be sent }
   Receiver : HWnd;
   Message : SmallWord;
   CASE WinInteger OF
     0 : ( WParam   : WPARAM32;
           LParam   : LParam32;
           Result   : THandle );

     1 : ( WParamLo : SmallWord;
           WParamHi : SmallWord;
           LParamLo : SmallWord;
           LParamHi : SmallWord;
           ResultLo : SmallWord;
           ResultHi : SmallWord );
END;

// procedural TYPE FOR handling events
TEventHandler  = PROCEDURE ( Sender : pWindowsObject; VAR Msg : TMessage );

// ancestor OF all windowed objects - must be subclassed!!!
TWndParent   = OBJECT ( TClass )

{ Private }
  MouseCounter : DWord;
  ShowingHint,
  ShowHint : Boolean;
  Hint : TControlStr;
  HintWindow : pHintWindow;
  FindMsg : WinInteger;
  // MouseEvent : TTrackMouseEvent;
  WindowProc : TWindowProc;
  ClientRect,
  WindowRect    : LTRECT;
  ParentInstance,
  Instance   : TFarProc;
  MyWndClass : TWndClass;
  CentredInParent,   // should the window be centered relative TO its parent window?
  Centred : Boolean; // should the window be centered relative TO display?

  { Public }
  Show_Code : WinInteger;
  Visible,
  FromResource : Boolean;
  Parent : pWindowsObject;
  Children   : pObjectCollection;
  WindowColor : TColorRef;
  AboutPtr : pChar; // pointer TO "About" Message
  // TextFont : THandle;
  WindowHandleDC : HDC;
  Use3D : Boolean;
  BorderStyle : TBorderStyle;
  Font : TFont;
  Flags : Byte;
  Attr : TWindowAttr;
  ActiveControl : pWindowsObject;
  Status : WinInteger;
  DefaultProc : TFarProc;
  TransferBuffer : Pointer;

  { event handlers of sorts }
  OnClose,
  OnClick,
  OnDblClick,
  OnEnter,
  OnChange,
  OnUpdate,
  OnExit,
  OnTimer,
  OnActivate,
  OnCreate,     { @@@ doesn't seem to ever be activated! }
  OnDestroy,
  OnHelp,
  OnHide,
  OnResize,
  OnShow : TEventHandler;


  CONSTRUCTOR Init ( Owner : pWindowsObject );
  CONSTRUCTOR InitResource ( Owner : pWindowsObject; ResourceID : WinInteger );
  DESTRUCTOR  Done; VIRTUAL;
  FUNCTION    hWindow : HWnd;
  PROCEDURE   GotoXY ( X, Y : WinInteger ); VIRTUAL;
  PROCEDURE   SetWindow ( X, Y, W, H : WinInteger ); VIRTUAL;
  PROCEDURE   SetWindowCoords ( X, Y, W, H : WinInteger ); VIRTUAL;
  PROCEDURE   WindowCoords ( X, Y, W, H : WinInteger ); VIRTUAL;
  FUNCTION    GetClassName : pChar; VIRTUAL;
  FUNCTION    CreateWnd : Boolean;VIRTUAL;
  PROCEDURE   Show ( ShowCmd : Integer ); VIRTUAL;
  PROCEDURE   SetupWindow; VIRTUAL;
  PROCEDURE   GetCaption;VIRTUAL;
  PROCEDURE   SetCaption ( aCaption : pChar );VIRTUAL;
  FUNCTION    Register : Boolean; VIRTUAL;
  PROCEDURE   AddChild ( AChild : pWindowsObject );VIRTUAL;
  PROCEDURE   RemoveChild ( AChild : pWindowsObject );VIRTUAL;
  FUNCTION    CreateChildren : Boolean;VIRTUAL;
  FUNCTION    At ( I : WinInteger ) : pWindowsObject;VIRTUAL;
  FUNCTION    CanClose : Boolean; VIRTUAL;
  FUNCTION    ChildList : pWindowsObject; VIRTUAL;{ field in BP }
  FUNCTION    GetId : WinInteger; VIRTUAL;
  PROCEDURE   Focus; VIRTUAL;
  PROCEDURE   WmClose ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   CloseMe; VIRTUAL;
  PROCEDURE   DisplayHint; VIRTUAL;
  PROCEDURE   CloseHint; VIRTUAL;
  PROCEDURE   SetBackGroundColor ( aColor : WinInteger );VIRTUAL;

  FUNCTION    GetTextLen : WinInteger; VIRTUAL;{ Delphi }
  FUNCTION    GetTextBuf ( Buffer : PChar; BufSize : WinInteger ) : WinInteger;VIRTUAL;
  PROCEDURE   Hide;VIRTUAL;
  PROCEDURE   UpdateWinRect;VIRTUAL;
  FUNCTION    Perform ( Msg : UINT; WParam : WParam32; LParam : LParam32 ) : LResult ;VIRTUAL;

  { private }
  FUNCTION     SelfPtr : pWindowsObject; { pointer to the "Self" }
  FUNCTION     pSelf : pWindowsObject;   { same as SelfPtr }
  FUNCTION     MainWindowPtr : pWindowsObject;
  FUNCTION     IsMainWindow : Boolean;

  { extra }
  PROCEDURE   RepaintWindow; VIRTUAL;
  PROCEDURE   PaintClientArea ( ForeClr, BackClr : WinInteger );VIRTUAL;
  PROCEDURE   WriteText ( FontP : pFont; x, y, tCol, tBack : WinInteger; CONST aString : String ); VIRTUAL;

  PROCEDURE   PrepareFont;VIRTUAL;
  PROCEDURE   AssignFont ( CONST aFont : TFont );VIRTUAL;
  FUNCTION    Canvas   : HDC;VIRTUAL;
  FUNCTION    WindowDC : HDC;VIRTUAL;
  FUNCTION    ChildCount  : Int64;VIRTUAL;
  FUNCTION    HasChildren : Boolean; VIRTUAL;

  { pseudo event handlers; dummies - must be overridden }
  PROCEDURE   WmChange ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmUpdate ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmEnter ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmExit ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmDblClick ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   WmClick ( VAR Msg : TMessage );VIRTUAL;


  {$ifdef _Delphi_}
  PROPERTY    Color :       TColorRef READ Font.Color WRITE Font.Color;
  PROPERTY    BackGround :  TColorRef READ Font.BackGround WRITE Font.BackGround;
  PROPERTY    Style :       Int64 READ Attr.Style  WRITE Attr.Style ;
  PROPERTY    Left  :       WinInteger READ Attr.X  WRITE Attr.X ;
  PROPERTY    Top   :       WinInteger READ Attr.Y  WRITE Attr.Y ;
  PROPERTY    Width :       WinInteger READ Attr.W  WRITE Attr.W ;
  PROPERTY    Height :      WinInteger READ Attr.H  WRITE Attr.H ;
  PROPERTY    Menu   :      hMenu READ Attr.Menu  WRITE Attr.Menu ;
  PROPERTY    ControlID :   LongWord READ Attr.ID  WRITE Attr.ID ;
  PROPERTY    FontName  :   TFontName READ Font.Name WRITE Font.Name;
  PROPERTY    FontSize  :   Integer READ Font.Size WRITE Font.Size;
  PROPERTY    FontStyle :   TFontStyles READ Font.Style WRITE Font.Style;
  PROPERTY    Brush     :   THandle READ Font.Brush WRITE Font.Brush;
  {$else}
  FUNCTION    Style : Int64;
  FUNCTION    Left  : WinInteger;
  FUNCTION    Top   : WinInteger;
  FUNCTION    Right : WinInteger;
  FUNCTION    Bottom : WinInteger;
  FUNCTION    Width : WinInteger;
  FUNCTION    Height : WinInteger;
  FUNCTION    Menu  : hMenu;
  FUNCTION    ControlID : LongWord;

  FUNCTION    Color :       TColorRef;
  FUNCTION    BackGround :  TColorRef;
  FUNCTION    FontName  :   TControlStr{TFontName};
  FUNCTION    FontSize  :   Integer;
  FUNCTION    FontStyle :   TFontStyles;
  FUNCTION    Brush     :   THandle;
  {$endif}
END;
{*************************************}

TWindowsObject = OBJECT ( TWndParent )

 { command handler - must always be overridden! }
  FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;

 { the rest }
  CONSTRUCTOR Init ( Owner : pWindowsObject );
  CONSTRUCTOR InitResource ( Owner : pWindowsObject; ResourceID : WinInteger );
  FUNCTION    GetClassName : pChar; VIRTUAL;

  FUNCTION    Register : Boolean;VIRTUAL;
  PROCEDURE   GetWindowClass ( VAR AWndClass : TWndClass ); VIRTUAL;
  PROCEDURE   DefWndProc ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE   DefCommandProc ( VAR Msg : TMessage ); VIRTUAL;

  { dummies }
  PROCEDURE   EnableKBHandler;
  PROCEDURE   EnableAutoCreate;
  PROCEDURE   DisableAutoCreate;
  PROCEDURE   EnableTransfer;
  PROCEDURE   DisableTransfer;
  { end dummies }

  { return child from its ID }
  FUNCTION    ChildWithId ( Id : LongWord ) : pWindowsObject;VIRTUAL;

  { return child from its handle ( hWindow )}
  FUNCTION    ChildWithHWnd ( aWnd : hWnd ) : pWindowsObject;VIRTUAL;

 { other stufff }
   FUNCTION    CreateMemoryDC : HDC;VIRTUAL;
   FUNCTION    Enable : Boolean;VIRTUAL;
   FUNCTION    Disable : Boolean;VIRTUAL;
   PROCEDURE   CMExit ( VAR Msg : TMessage ); VIRTUAL;
   PROCEDURE   CMHelpAbout ( VAR Msg : TMessage ); VIRTUAL;
   PROCEDURE   wCloseWindow; VIRTUAL;

  { public }
  { FindDialog hooks }
  PROCEDURE    WMFindDialog ( VAR Msg : TMessage ); VIRTUAL;

 { messages handlers }
  PROCEDURE    WMInitDialog ( VAR Msg : TMessage ); VIRTUAL;
  PROCEDURE    WMEraseBackGround ( VAR Msg : TMessage ); VIRTUAL;
  PROCEDURE    WMDropFiles ( VAR Msg : TMessage ); VIRTUAL;
  PROCEDURE    WmPaint ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;

  PROCEDURE    WmGetMinMaxInfo ( VAR Msg : TMessage );VIRTUAL;

  PROCEDURE    WmKeyDown ( VAR Msg : TMessage );VIRTUAL;

  PROCEDURE    WmCreate ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WmSize ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WmMove ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WMActivate ( VAR Msg : TMessage );VIRTUAL ;

  PROCEDURE    WmTimer ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WmDestroy ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WmSetFocus ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WmNotify ( VAR Msg : TMessage );VIRTUAL;

  PROCEDURE    WMHScroll ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE    WMVScroll ( VAR Msg : TMessage );VIRTUAL;

  PROCEDURE    WMCommand ( VAR Msg : TMessage ); VIRTUAL;
  PROCEDURE    WMQueryEndSession ( VAR Msg : TMessage ); VIRTUAL;

{- automated starts -}
  PROCEDURE WMACTIVATEAPP ( VAR Msg : TMessage );VIRTUAL;{ 28}
  PROCEDURE WMASKCBFORMATNAME ( VAR Msg : TMessage );VIRTUAL;{ 780}
  PROCEDURE WMCANCELJOURNAL ( VAR Msg : TMessage );VIRTUAL;{ 75}
  PROCEDURE WMCANCELMODE ( VAR Msg : TMessage );VIRTUAL;{ 31}
  PROCEDURE WMCAPTURECHANGED ( VAR Msg : TMessage );VIRTUAL;{ 533}
  PROCEDURE WMCHANGECBCHAIN ( VAR Msg : TMessage );VIRTUAL;{ 781}
  PROCEDURE WMCHAR ( VAR Msg : TMessage );VIRTUAL;{ 258}
  PROCEDURE WMCHARTOITEM ( VAR Msg : TMessage );VIRTUAL;{ 47}
  PROCEDURE WMCHILDACTIVATE ( VAR Msg : TMessage );VIRTUAL;{ 34}
  PROCEDURE WMCHOOSEFONT_GETLOGFONT ( VAR Msg : TMessage );VIRTUAL;{ 1025}
  PROCEDURE WMCHOOSEFONT_SETLOGFONT ( VAR Msg : TMessage );VIRTUAL;{ 1125}
  PROCEDURE WMCHOOSEFONT_SETFLAGS ( VAR Msg : TMessage );VIRTUAL;{ 1126}
  PROCEDURE WMCLEAR ( VAR Msg : TMessage );VIRTUAL;{ 771}
  PROCEDURE WMCOMPACTING ( VAR Msg : TMessage );VIRTUAL;{ 65}
  PROCEDURE WMCOMPAREITEM ( VAR Msg : TMessage );VIRTUAL;{ 57}
  PROCEDURE WMCONTEXTMENU ( VAR Msg : TMessage );VIRTUAL;{ 123}
  PROCEDURE WMCOPY ( VAR Msg : TMessage );VIRTUAL;{ 769}
  PROCEDURE WMCOPYDATA ( VAR Msg : TMessage );VIRTUAL;{ 74}

  PROCEDURE WMCTLCOLOR ( VAR Msg : TMessage );VIRTUAL;
  PROCEDURE WMCTLCOLORBTN ( VAR Msg : TMessage );VIRTUAL;{ 309}
  PROCEDURE WMCTLCOLORDLG ( VAR Msg : TMessage );VIRTUAL;{ 310}
  PROCEDURE WMCTLCOLOREDIT ( VAR Msg : TMessage );VIRTUAL;{ 307}
  PROCEDURE WMCTLCOLORLISTBOX ( VAR Msg : TMessage );VIRTUAL;{ 308}
  PROCEDURE WMCTLCOLORMSGBOX ( VAR Msg : TMessage );VIRTUAL;{ 306}
  PROCEDURE WMCTLCOLORSCROLLBAR ( VAR Msg : TMessage );VIRTUAL;{ 311}
  PROCEDURE WMCTLCOLORSTATIC ( VAR Msg : TMessage );VIRTUAL;{ 312}

  PROCEDURE WMCUT ( VAR Msg : TMessage );VIRTUAL;{ 768}
  PROCEDURE WMDEADCHAR ( VAR Msg : TMessage );VIRTUAL;{ 259}
  PROCEDURE WMDELETEITEM ( VAR Msg : TMessage );VIRTUAL;{ 45}
  PROCEDURE WMDESTROYCLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 775}
  PROCEDURE WMDEVICECHANGE ( VAR Msg : TMessage );VIRTUAL;{ 537}
  PROCEDURE WMDEVMODECHANGE ( VAR Msg : TMessage );VIRTUAL;{ 27}
  PROCEDURE WMDISPLAYCHANGE ( VAR Msg : TMessage );VIRTUAL;{ 126}
  PROCEDURE WMDRAWCLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 776}
  PROCEDURE WMDRAWITEM ( VAR Msg : TMessage );VIRTUAL;{ 43}
  PROCEDURE WMENABLE ( VAR Msg : TMessage );VIRTUAL;{ 10}
  PROCEDURE WMENDSESSION ( VAR Msg : TMessage );VIRTUAL;{ 22}
  PROCEDURE WMENTERIDLE ( VAR Msg : TMessage );VIRTUAL;{ 289}
  PROCEDURE WMENTERMENULOOP ( VAR Msg : TMessage );VIRTUAL;{ 529}
  PROCEDURE WMENTERSIZEMOVE ( VAR Msg : TMessage );VIRTUAL;{ 561}
  PROCEDURE WMERASEBKGND ( VAR Msg : TMessage );VIRTUAL;{ 20}
  PROCEDURE WMEXITMENULOOP ( VAR Msg : TMessage );VIRTUAL;{ 530}
  PROCEDURE WMEXITSIZEMOVE ( VAR Msg : TMessage );VIRTUAL;{ 562}
  PROCEDURE WMFONTCHANGE ( VAR Msg : TMessage );VIRTUAL;{ 29}
  PROCEDURE WMGETDLGCODE ( VAR Msg : TMessage );VIRTUAL;{ 135}
  PROCEDURE WMGETFONT ( VAR Msg : TMessage );VIRTUAL;{ 49}
  PROCEDURE WMGETHOTKEY ( VAR Msg : TMessage );VIRTUAL;{ 51}
  PROCEDURE WMGETICON ( VAR Msg : TMessage );VIRTUAL;{ 127}
  PROCEDURE WMGETTEXT ( VAR Msg : TMessage );VIRTUAL;{ 13}
  PROCEDURE WMGETTEXTLENGTH ( VAR Msg : TMessage );VIRTUAL;{ 14}
  PROCEDURE WMHELP ( VAR Msg : TMessage );VIRTUAL;{ 83}
  PROCEDURE WMHOTKEY ( VAR Msg : TMessage );VIRTUAL;{ 786}
  PROCEDURE WMHSCROLLCLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 782}
  PROCEDURE WMICONERASEBKGND ( VAR Msg : TMessage );VIRTUAL;{ 39}
  PROCEDURE WMIME_CHAR ( VAR Msg : TMessage );VIRTUAL;{ 646}
  PROCEDURE WMIME_COMPOSITION ( VAR Msg : TMessage );VIRTUAL;{ 271}
  PROCEDURE WMIME_COMPOSITIONFULL ( VAR Msg : TMessage );VIRTUAL;{ 644}
  PROCEDURE WMIME_CONTROL ( VAR Msg : TMessage );VIRTUAL;{ 643}
  PROCEDURE WMIME_ENDCOMPOSITION ( VAR Msg : TMessage );VIRTUAL;{ 270}
  PROCEDURE WMIME_KEYDOWN ( VAR Msg : TMessage );VIRTUAL;{ 656}
  PROCEDURE WMIME_KEYUP ( VAR Msg : TMessage );VIRTUAL;{ 657}
  PROCEDURE WMIME_NOTIFY ( VAR Msg : TMessage );VIRTUAL;{ 642}
  PROCEDURE WMIME_SELECT ( VAR Msg : TMessage );VIRTUAL;{ 645}
  PROCEDURE WMIME_SETCONTEXT ( VAR Msg : TMessage );VIRTUAL;{ 641}
  PROCEDURE WMIME_STARTCOMPOSITION ( VAR Msg : TMessage );VIRTUAL;{ 269}
  PROCEDURE WMINITMENU ( VAR Msg : TMessage );VIRTUAL;{ 278}
  PROCEDURE WMINITMENUPOPUP ( VAR Msg : TMessage );VIRTUAL;{ 279}
  PROCEDURE WMINPUTLANGCHANGE ( VAR Msg : TMessage );VIRTUAL;{ 81}
  PROCEDURE WMINPUTLANGCHANGEREQUEST ( VAR Msg : TMessage );VIRTUAL;{ 80}
  PROCEDURE WMKEYUP ( VAR Msg : TMessage );VIRTUAL;{ 257}
  PROCEDURE WMKILLFOCUS ( VAR Msg : TMessage );VIRTUAL;{ 8}
  PROCEDURE WMLBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 515}
  PROCEDURE WMLBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 513}
  PROCEDURE WMLBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 514}
  PROCEDURE WMMBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 521}
  PROCEDURE WMMBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 519}
  PROCEDURE WMMBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 520}
  PROCEDURE WMMDIACTIVATE ( VAR Msg : TMessage );VIRTUAL;{ 546}
  PROCEDURE WMMDICASCADE ( VAR Msg : TMessage );VIRTUAL;{ 551}
  PROCEDURE WMMDICREATE ( VAR Msg : TMessage );VIRTUAL;{ 544}
  PROCEDURE WMMDIDESTROY ( VAR Msg : TMessage );VIRTUAL;{ 545}
  PROCEDURE WMMDIGETACTIVE ( VAR Msg : TMessage );VIRTUAL;{ 553}
  PROCEDURE WMMDIICONARRANGE ( VAR Msg : TMessage );VIRTUAL;{ 552}
  PROCEDURE WMMDIMAXIMIZE ( VAR Msg : TMessage );VIRTUAL;{ 549}
  PROCEDURE WMMDINEXT ( VAR Msg : TMessage );VIRTUAL;{ 548}
  PROCEDURE WMMDIREFRESHMENU ( VAR Msg : TMessage );VIRTUAL;{ 564}
  PROCEDURE WMMDIRESTORE ( VAR Msg : TMessage );VIRTUAL;{ 547}
  PROCEDURE WMMDISETMENU ( VAR Msg : TMessage );VIRTUAL;{ 560}
  PROCEDURE WMMDITILE ( VAR Msg : TMessage );VIRTUAL;{ 550}
  PROCEDURE WMMEASUREITEM ( VAR Msg : TMessage );VIRTUAL;{ 44}
  PROCEDURE WMMENUCHAR ( VAR Msg : TMessage );VIRTUAL;{ 288}
  PROCEDURE WMMENUSELECT ( VAR Msg : TMessage );VIRTUAL;{ 287}
  PROCEDURE WMMOUSEACTIVATE ( VAR Msg : TMessage );VIRTUAL;{ 33}
  PROCEDURE WMMOUSEMOVE ( VAR Msg : TMessage );VIRTUAL;{ 512}
  PROCEDURE WMMOUSEHOVER ( VAR Msg : TMessage );VIRTUAL;{ }
  PROCEDURE WMMOUSELEAVE ( VAR Msg : TMessage );VIRTUAL;{ }
  PROCEDURE WMMOVING ( VAR Msg : TMessage );VIRTUAL;{ 534}
  PROCEDURE WMNCACTIVATE ( VAR Msg : TMessage );VIRTUAL;{ 134}
  PROCEDURE WMNCCALCSIZE ( VAR Msg : TMessage );VIRTUAL;{ 131}
  PROCEDURE WMNCCREATE ( VAR Msg : TMessage );VIRTUAL;{ 129}
  PROCEDURE WMNCDESTROY ( VAR Msg : TMessage );VIRTUAL;{ 130}
  PROCEDURE WMNCHITTEST ( VAR Msg : TMessage );VIRTUAL;{ 132}
  PROCEDURE WMNCLBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 163}
  PROCEDURE WMNCLBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 161}
  PROCEDURE WMNCLBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 162}
  PROCEDURE WMNCMBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 169}
  PROCEDURE WMNCMBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 167}
  PROCEDURE WMNCMBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 168}
  PROCEDURE WMNCMOUSEMOVE ( VAR Msg : TMessage );VIRTUAL;{ 160}
  PROCEDURE WMNCPAINT ( VAR Msg : TMessage );VIRTUAL;{ 133}
  PROCEDURE WMNCRBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 166}
  PROCEDURE WMNCRBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 164}
  PROCEDURE WMNCRBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 165}
  PROCEDURE WMNEXTDLGCTL ( VAR Msg : TMessage );VIRTUAL;{ 40}
  PROCEDURE WMNOTIFYFORMAT ( VAR Msg : TMessage );VIRTUAL;{ 85}
  PROCEDURE WMNULL ( VAR Msg : TMessage );VIRTUAL;{ 0}
  PROCEDURE WMPAINTCLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 777}
  PROCEDURE WMPAINTICON ( VAR Msg : TMessage );VIRTUAL;{ 38}
  PROCEDURE WMPALETTECHANGED ( VAR Msg : TMessage );VIRTUAL;{ 785}
  PROCEDURE WMPALETTEISCHANGING ( VAR Msg : TMessage );VIRTUAL;{ 784}
  PROCEDURE WMPARENTNOTIFY ( VAR Msg : TMessage );VIRTUAL;{ 528}
  PROCEDURE WMPASTE ( VAR Msg : TMessage );VIRTUAL;{ 770}
  PROCEDURE WMPENWINFIRST ( VAR Msg : TMessage );VIRTUAL;{ 896}
  PROCEDURE WMPENWINLAST ( VAR Msg : TMessage );VIRTUAL;{ 911}
  PROCEDURE WMPOWER ( VAR Msg : TMessage );VIRTUAL;{ 72}
  PROCEDURE WMPOWERBROADCAST ( VAR Msg : TMessage );VIRTUAL;{ 536}
  PROCEDURE WMPRINT ( VAR Msg : TMessage );VIRTUAL;{ 791}
  PROCEDURE WMPRINTCLIENT ( VAR Msg : TMessage );VIRTUAL;{ 792}
  PROCEDURE WMPSD_ENVSTAMPRECT ( VAR Msg : TMessage );VIRTUAL;{ 1029}
  PROCEDURE WMPSD_GREEKTEXTRECT ( VAR Msg : TMessage );VIRTUAL;{ 1028}
  PROCEDURE WMPSD_MARGINRECT ( VAR Msg : TMessage );VIRTUAL;{ 1027}
  PROCEDURE WMPSD_MINMARGINRECT ( VAR Msg : TMessage );VIRTUAL;{ 1026}
  PROCEDURE WMPSD_YAFULLPAGERECT ( VAR Msg : TMessage );VIRTUAL;{ 1030}
  PROCEDURE WMQUERYDRAGICON ( VAR Msg : TMessage );VIRTUAL;{ 55}
  PROCEDURE WMQUERYNEWPALETTE ( VAR Msg : TMessage );VIRTUAL;{ 783}
  PROCEDURE WMQUERYOPEN ( VAR Msg : TMessage );VIRTUAL;{ 19}
  PROCEDURE WMQUEUESYNC ( VAR Msg : TMessage );VIRTUAL;{ 35}
  PROCEDURE WMQUIT ( VAR Msg : TMessage );VIRTUAL;{ 18}
  PROCEDURE WMRBUTTONDBLCLK ( VAR Msg : TMessage );VIRTUAL;{ 518}
  PROCEDURE WMRBUTTONDOWN ( VAR Msg : TMessage );VIRTUAL;{ 516}
  PROCEDURE WMRBUTTONUP ( VAR Msg : TMessage );VIRTUAL;{ 517}
  PROCEDURE WMRENDERALLFORMATS ( VAR Msg : TMessage );VIRTUAL;{ 774}
  PROCEDURE WMRENDERFORMAT ( VAR Msg : TMessage );VIRTUAL;{ 773}
  PROCEDURE WMSETCURSOR ( VAR Msg : TMessage );VIRTUAL;{ 32}
  PROCEDURE WMSETFONT ( VAR Msg : TMessage );VIRTUAL;{ 48}
  PROCEDURE WMSETHOTKEY ( VAR Msg : TMessage );VIRTUAL;{ 50}
  PROCEDURE WMSETICON ( VAR Msg : TMessage );VIRTUAL;{ 128}
  PROCEDURE WMSETREDRAW ( VAR Msg : TMessage );VIRTUAL;{ 11}
  PROCEDURE WMSETTEXT ( VAR Msg : TMessage );VIRTUAL;{ 12}
  PROCEDURE WMSHOWWINDOW ( VAR Msg : TMessage );VIRTUAL;{ 24}
  PROCEDURE WMSIZECLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 779}
  PROCEDURE WMSIZING ( VAR Msg : TMessage );VIRTUAL;{ 532}
  PROCEDURE WMSPOOLERSTATUS ( VAR Msg : TMessage );VIRTUAL;{ 42}
  PROCEDURE WMSTYLECHANGED ( VAR Msg : TMessage );VIRTUAL;{ 125}
  PROCEDURE WMSTYLECHANGING ( VAR Msg : TMessage );VIRTUAL;{ 124}
  PROCEDURE WMSYSCHAR ( VAR Msg : TMessage );VIRTUAL;{ 262}
  PROCEDURE WMSYSCOLORCHANGE ( VAR Msg : TMessage );VIRTUAL;{ 21}
  PROCEDURE WMSYSCOMMAND ( VAR Msg : TMessage );VIRTUAL;{ 274}
  PROCEDURE WMSYSDEADCHAR ( VAR Msg : TMessage );VIRTUAL;{ 263}
  PROCEDURE WMSYSKEYDOWN ( VAR Msg : TMessage );VIRTUAL;{ 260}
  PROCEDURE WMSYSKEYUP ( VAR Msg : TMessage );VIRTUAL;{ 261}
  PROCEDURE WMTCARD ( VAR Msg : TMessage );VIRTUAL;{ 82}
  PROCEDURE WMTIMECHANGE ( VAR Msg : TMessage );VIRTUAL;{ 30}
  PROCEDURE WMUNDO ( VAR Msg : TMessage );VIRTUAL;{ 772}
  PROCEDURE WMUSER ( VAR Msg : TMessage );VIRTUAL;{ 1024}
  PROCEDURE WMUSERCHANGED ( VAR Msg : TMessage );VIRTUAL;{ 84}
  PROCEDURE WMVKEYTOITEM ( VAR Msg : TMessage );VIRTUAL;{ 46}
  PROCEDURE WMVSCROLLCLIPBOARD ( VAR Msg : TMessage );VIRTUAL;{ 778}
  PROCEDURE WMWINDOWPOSCHANGED ( VAR Msg : TMessage );VIRTUAL;{ 71}
  PROCEDURE WMWINDOWPOSCHANGING ( VAR Msg : TMessage );VIRTUAL;{ 70}
  PROCEDURE WMWININICHANGE ( VAR Msg : TMessage );VIRTUAL;{ 26}
  PROCEDURE WMKEYLAST ( VAR Msg : TMessage );VIRTUAL;{ 264}
{- automated ends -}
END;

{*************************************}
{ high level main window object }
pWindow = ^TWindow;
TWindow = OBJECT ( TWindowsObject )
    OldWnd : hWnd;
    SaveWindowState,               // automatically save window coords?
    RestoreWindowState : Boolean;  // automatically restore saved window coords?
    CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
    CONSTRUCTOR InitResource ( Owner : pWindowsObject; ResourceID : WinInteger );
    FUNCTION    GetClassName : pChar; VIRTUAL;
    PROCEDURE   Show ( ShowCmd : Integer ); VIRTUAL;
    PROCEDURE   MessageLoop;VIRTUAL;
    PROCEDURE   WmClose ( VAR Msg : TMessage );VIRTUAL;
    PROCEDURE   SetupWindow; Virtual;

    Private
      PROCEDURE   SaveWindow; virtual;
      PROCEDURE   RestoreWindow; virtual;
END;
{*************************************}
{ for showing on the file hints }
THintWindow = OBJECT ( TWindowsObject )
   Showing : Boolean;
   HintDelay : Word;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aCaption : pChar );
   DESTRUCTOR Done; VIRTUAL;
   PROCEDURE SetupWindow; VIRTUAL;
   PROCEDURE DisplaySelf; VIRTUAL;
   PROCEDURE RepaintWindow; VIRTUAL;
   PROCEDURE Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;
END;
{*************************************}
TTextAlignStyles = ( AlignLeft, AlignCenter, AlignRight );

{ windowed object with full bitmap display functionality built in }
PBitmapWindow = ^TBitmapWindow;
TBitmapWindow = OBJECT ( TWindow )
    Bitmap : hBitmap;
    BitmapLeft, BitmapTop,
    BitmapWidth, BitmapHeight : WinInteger;
    LoadBitmapFromResource,
    Stretched : Boolean;
    BitmapResource,
    BitmapFile : TControlStr;
    TextAlignMent : TTextAlignStyles;
    CONSTRUCTOR Init ( Owner : pWindowsObject; aTitle : pChar );
    PROCEDURE   WmClose ( VAR Msg : TMessage ); VIRTUAL;
    PROCEDURE   WMEraseBackGround ( VAR Msg : TMessage ); VIRTUAL;
    PROCEDURE   DrawButton ( VAR Msg : TMessage ); VIRTUAL;
    PROCEDURE   PaintClientArea ( ForeClr, BackClr : WinInteger );VIRTUAL;
    PROCEDURE   DrawBitmap; VIRTUAL;
    PROCEDURE    Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;
    PROCEDURE   SetupWindow; VIRTUAL;
    FUNCTION    LoadBitmapResource ( CONST ResName : String ) : hBitmap; VIRTUAL;
    FUNCTION    LoadBitmapFile ( CONST FileName : String ) : hBitmap; VIRTUAL;
END;

{*************************************}
{ dialog-style main window }
pDialogWindow = ^TDialogWindow;
TDialogWindow = OBJECT ( TBitmapWindow )
    Modeless : Boolean;
    RetValue : Integer;
    CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
    CONSTRUCTOR InitParams ( Owner : pWindowsObject; CONST aTitle : pChar; x, y, w, h : WinInteger );
    FUNCTION    Execute : Integer;
    PROCEDURE   WmClose ( VAR Msg : TMessage );VIRTUAL;
    PROCEDURE   Ok ( VAR Msg : TMessage );VIRTUAL;
    PROCEDURE   Cancel ( VAR Msg : TMessage );VIRTUAL;
    FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
END;
{*************************************}
{ a timer object }
pTimer = ^TTimer;
TTimer = OBJECT ( TWndParent )
   Interval : DWord;
   Enabled,
   Active : Boolean;
   ID : DWord;
   { e.g., Timer.Init (@Self, 14, 1000); Interval is in milliseconds! }
   CONSTRUCTOR Init ( Owner : pWindowsObject; AnID, aTimeOut : DWord );
   DESTRUCTOR Done; VIRTUAL;
   PROCEDURE Show ( ShowCmd : Integer ); VIRTUAL;
   FUNCTION CreateWnd : Boolean; VIRTUAL;
END;

{*************************************}
pApplication = ^TApplication;
TApplication = OBJECT ( TClass )
    hAccTable : THandle;
    Terminated : Boolean;
    OSInfo : TOSVersionInfo; // holds the operating system version information
    IniFile,    // name of application's INI file
    HelpFile,   // name of application's help file
    Title,      // caption OF main window, OR, name OF executable
    ExeDir,     // path OF executable
    ExePath,    // path OF executable + trailing backslash
    ExeName  :  // full path name OF executable
    TControlStr;

    KBHandlerWnd,
    MainWindow : pWindowsObject;
    Status     : WinInteger;
    SleepInterval : Integer; // how long TO yield processing FOR
    CONSTRUCTOR Init  ( CONST aName : pChar );
    PROCEDURE   Run;VIRTUAL;
    PROCEDURE   Terminate;VIRTUAL;
    FUNCTION    IdleAction : Boolean; VIRTUAL;
    PROCEDURE   SetKBHandler ( anObj : pWindowsObject );VIRTUAL;
    PROCEDURE   ProcessMessages;VIRTUAL;
    FUNCTION    ProcessAppMsg ( VAR Msg : TMsg ) : Boolean;VIRTUAL;
    FUNCTION    ProcessDlgMsg ( VAR Msg : TMsg ) : Boolean; VIRTUAL;
    FUNCTION    ProcessAccels ( VAR Msg : TMsg ) : Boolean; VIRTUAL;
    FUNCTION    ProcessMDIAccels ( VAR Message : TMsg ) : Boolean; VIRTUAL;
    FUNCTION    ValidWindow ( anObj : pWindowsObject ) : pWindowsObject;VIRTUAL;
    FUNCTION    MakeWindow ( anObj : pWindowsObject ) : pWindowsObject; VIRTUAL;
    PROCEDURE   InitMainWindow;VIRTUAL;
    PROCEDURE   InitApplication;VIRTUAL;
    PROCEDURE   MessageLoop;VIRTUAL;
    PROCEDURE   ShowException ( CONST E : Exception );
    FUNCTION    Active : Boolean;
    FUNCTION    CanClose : Boolean;
    PROCEDURE   Error ( Code : WinInteger );VIRTUAL;
END;
{*************************************}
{*************************************}
FUNCTION _hInstance : THandle;

 FUNCTION InstanceFromHandle ( Handle : hWnd ) : pWindowsObject;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

 FUNCTION    InstanceFromSelfID ( ID : Word64 ) : pWindowsObject;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

 FUNCTION    ChildFromSelfID ( Parent : pWindowsObject; ID : Word64 ) : pWindowsObject;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

 FUNCTION  FileExpand ( Dest, Name : pChar ) : pChar;
{$ifndef IS_UNIT} FORWARD;{$endif}{IS_UNIT}

 FUNCTION FileSplit ( Path, Dir, Name, Ext : PChar ) : Word;
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

PROCEDURE Delay ( msecs : DWord );
{$ifndef IS_UNIT}FORWARD;{$endif}{IS_UNIT}

{$ifdef __TMT__}CONST{$else}VAR{$endif}
Application : pApplication = NIL;

{*************************************}
{*** colour constants ****************}
CONST
ColorBlack       = $00000000;
ColorWhite       = $00FFFFFF;
ColorCyan        = $00FFFF00;
ColorDarkCyan    = 9868820;
ColorRed         = $000000FF;
ColorDarkRed     = 128;
ColorGreen       = $0000FF00;
ColorYellow      = $0000FFFF;
ColorLightYellow = $00CCFFFF;
ColorDarkYellow  = 100010;
ColorMagenta     = $00FF00FF;
ColorButton      = 13160660;
ColorGray        = $006688FF;
ColorDarkGray    = $00808080;
ColorLightGray   = $00C0C0C0;
ColorPurple      = 13107400;
ColorDarkPurple  = 15761536;
ColorBlue        = $00FF0000;
ColorDarkBlue    = 9830400;

{$ifdef IS_UNIT}
IMPLEMENTATION
USES IniFiles, genutils, cDialogs;
{$endif}{IS_UNIT}

{*************************************}
{*************************************}
{*************************************}
FUNCTION _hInstance : THandle;
BEGIN
   Result := GetModuleHandle ( NIL );
END;

{$ifdef __GPC__}
PROCEDURE FSplit ( CONST Path : String; VAR Dir, Name, Ext : String );
external name '_p_FSplit';

FUNCTION  FExpand ( CONST Path : String ) : TString;
external name '_p_FExpand';

FUNCTION JustPathName ( CONST Path : String ) : TString;
external name '_p_DirFromPath';

FUNCTION ForceExtension ( CONST s, Ext : String ) = Result : TString;
VAR i : WinInteger;
BEGIN
  i := Pos ( '.', s );
  IF i = 0
    THEN Result := s
    ELSE Result := Copy ( s, 1, i - 1 );
  IF Ext [1] <>  '.'THEN Result := Result + '.';
  Result := Result + Ext
END;

FUNCTION FileSplit ( Path, Dir, Name, Ext : PChar ) : Word;
VAR
d, n, e : TString;
BEGIN
   Result := 0;
   FSplit ( StrPas ( Path ), d, n, e );
   Strpcopy ( Dir, d );
   Strpcopy ( Name, n );
   Strpcopy ( Ext, e );
END;

FUNCTION  fileexpand ( dest, name : pChar ) : pChar;
BEGIN
  Strpcopy ( dest, FExpand ( CString2String ( name ) ) );
  Result := Dest;
END;

{$else}
FUNCTION JustPathName ( CONST Path : String ) : TString;
BEGIN
   Result := ExtractFileDir ( Path );
END;

FUNCTION ForceExtension ( CONST s, Ext : String ) : TString;
BEGIN
   Result := ChangeFileExt ( s, '.' + Ext );
END;

FUNCTION  FileExpand ( Dest, Name : pChar ) : pChar;
BEGIN
  Strpcopy ( Dest, ExpandFileName ( StrPas ( Name ) ) );
  Result := Dest;
END;

PROCEDURE FSplit ( CONST Path : String; VAR Dir, Name, Ext : String );
BEGIN
   Dir := ExtractFileDir ( Path );
   Name := ExtractFileName ( Path );
   Ext  := ExtractFileExt ( Path );
END;

FUNCTION FileSplit ( Path, Dir, Name, Ext : PChar ) : Word;
VAR
 d, n, e : String;
BEGIN
   Result := 0;
   FSplit ( StrPas ( Path ), d, n, e );
   Strpcopy ( Dir, d );
   Strpcopy ( Name, n );
   Strpcopy ( Ext, e );
END;
{$endif}{__GPC__}


{*************************************}
{*************************************}
FUNCTION GeneralDefWndProc ( Window : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : LResult;
STDCALL;
{$ifdef __GPC__}FORWARD;
FUNCTION GeneralDefWndProc ( Window : HWnd; Message : UINT; WParam : WPARAM32; LParam : LPARAM32 ) : LResult;
{$endif}
VAR
p : pWindowsObject;
Msg : TMessage;
BEGIN
   Msg.Receiver := Window;
   Msg.Message  := Message;
   Msg.WParam   := WParam;
   Msg.LParam   := LParam;
   Msg.Result   := 0;
   Msg.Sender   := NIL;
   p := InstanceFromHandle ( Window );
   IF Assigned ( p )
   THEN BEGIN
      Msg.Sender := p;
      p^.DefWndProc ( Msg );
      Result := Msg.Result;
      IF Msg.Result <> 0 THEN Exit;
   END;
   Result := DefWindowProc ( Window, Message, WParam, lParam );
END;

{*************************************}
{*************************************}
{*************************************}
{*************************************}
{$ifndef __GPC__}
FUNCTION StrNew ( Src : pChar ) : pChar;
VAR
p : pChar;
BEGIN
   IF ( Assigned ( Src ) ) AND ( Src^ <> #0 )
   THEN BEGIN
       Getmem ( p, Succ ( Strlen ( Src ) ) );
       Strcopy ( p, Src );
       Result := p;
   END ELSE Result := NIL;
END;

PROCEDURE StrDispose ( VAR p : pChar );
VAR
i : WinInteger;
BEGIN
   IF ( Assigned ( p ) ) AND ( p^ <> #0 )
   THEN BEGIN
      i := strlen ( p );
      Freemem ( p );
   END;
   p := NIL;
END;

{$endif}{__GPC__}

CONSTRUCTOR TWndParent.Init;
BEGIN
   INHERITED Init ( Owner );
   Name := 'TWndParent';
   AboutPtr := NIL;
   OnClose := NIL;
   OnClick := NIL;
   OnDblClick := NIL;
   OnEnter := NIL;
   OnChange := NIL;
   OnUpdate := NIL;
   OnExit := NIL;
   OnTimer := NIL;

   OnActivate := NIL;
   OnCreate := NIL;
   OnDestroy := NIL;
   OnHelp := NIL;
   OnHide := NIL;
   OnResize := NIL;
   OnShow  := NIL;
   Hint := '';
   ShowHint := False;
   ShowingHint := False;
   MouseCounter := 0;
   HintWindow := NIL;
   Use3D := False;
   WindowColor := ColorWhite;

   TransferBuffer := NIL;
   Status := 0;
   FromResource := False;
   Visible := True;
   Show_Code := sw_ShowNormal;
   FillChar ( MyWndClass, Sizeof ( MyWndClass ), 0 );
   FillChar ( Attr, Sizeof ( Attr ), 0 );
   FillChar ( Font, Sizeof ( Font ), 0 );
   WITH Font
   DO BEGIN
      StrCopy ( Name, 'Arial' );
      Size := 10;
      Brush := GetStockObject ( White_Brush );
      Pitch := Variable_Pitch OR FF_Roman;
      Color := ColorBlack;
      BackGround := ColorWhite;
      Style := [];
      Handle := 0;
      PixelsPerInch := 10;
      Height := 10;
      FillChar ( lFont, SizeOf ( LFont ), 0 );
      TransparentBackground := False;
   END;

   FindMsg := - 1;
   ActiveControl := NIL;
   Attr.Title := NIL;
   Attr.Style  := WS_OverlappedWindow;

   Parent := Owner;
   Instance := NIL;
   ParentInstance := NIL;
   DefaultProc := NIL;
   SelfID := GetSelfID;

   IncObjectCount;
   Children := New ( pObjectCollection, Init ( 16, 4 ) );
   IF Assigned ( Parent )
   THEN BEGIN
      ParentHandle := Parent^.Handle;
      Parent^.AddChild ( pWindowsObject ( SelfPtr ) ); { add self to parent's child list }
   END;
   ObjectList^.Insert ( pWindowsObject ( SelfPtr ) ); { add self to object list }
END;

CONSTRUCTOR TWndParent.InitResource;
BEGIN
   Init ( Owner );
   Attr.ID := ResourceID;
   FromResource := True;
END;

DESTRUCTOR  TWndParent.Done;
VAR
i : integer;
BEGIN
  IF Font.Handle <> 0 THEN DeleteObject ( Font.Handle );

  ReleaseDC ( Handle, WindowHandleDC );

  IF IsWindow ( Handle ) THEN DestroyWindow ( Handle );

  IF Assigned ( Children )
  THEN BEGIN
     FOR i := Pred ( Children^.Count ) DOWNTO 0
     DO BEGIN
        pWndParent ( Children^.Items^ [i] )^.Done;
        Children^.Items^ [i] := NIL;
     END;

     Dispose ( Children, Done );
     Children := NIL;
  END;

  ObjectList^.Delete ( @Self );
  Status := - 1;

  IF Assigned ( Parent )
  THEN BEGIN
     Parent^.RemoveChild ( pWindowsObject ( @Self ) );
     Parent^.Focus;
  END;

  Instance := NIL;
  ParentInstance := NIL;

  IF Assigned ( Attr.Title )
  THEN BEGIN
     StrDispose ( Attr.Title );
     Attr.Title := NIL;
  END;
  Handle := 0;

  AboutPtr := NIL;
  INHERITED Done;
END;

PROCEDURE TWndParent.SetBackGroundColor ( aColor : WinInteger );
BEGIN
   WindowColor := aColor;
   RepaintWindow;
END;

PROCEDURE TWndParent.SetWindowCoords;
BEGIN
  Attr.X := X;
  Attr.Y := Y;
  Attr.W := W;
  Attr.H := H;
END;

PROCEDURE TWndParent.WindowCoords;
BEGIN
  SetWindowCoords ( X, Y, W, H );
END;

PROCEDURE TWndParent.SetWindow;
BEGIN
  SetWindowPos ( hWindow, 0, X, Y, W, H, SWP_NOZORDER or SWP_NOACTIVATE );
  UpdateWinRect;
END;

PROCEDURE TWndParent.GotoXY;
BEGIN
  SetWindowPos ( Handle, 0, X, Y, Width, Height, swp_NoSize );
  UpdateWinRect;
END;

FUNCTION TWndParent.CreateChildren;
VAR
i : LongWord;
p : pWindowsObject;
b : Boolean;
BEGIN
    Result := True;
    IF HasChildren
    THEN BEGIN
       FOR i := 0 TO ChildCount
       DO BEGIN
          p := ( At ( i ) );
          p^.ParentHandle := Handle;
          b := p^.CreateWnd;
          IF NOT b
          THEN BEGIN
             Result := False
          END
          ELSE BEGIN
            p^.Show ( p^.Show_Code );
          END;
       END;
       IF NOT Assigned ( ActiveControl ) THEN ActiveControl := At ( 0 );
       IF Assigned ( ActiveControl ) THEN ActiveControl^.Focus;
    END;
END;

PROCEDURE  TWndParent.DisplayHint;
VAR
i : DWord;
p : pWndParent;
BEGIN
  MouseCounter := 0;
  IF ( Assigned ( Parent ) ) AND ( Parent^.ShowingHint ) THEN Parent^.CloseHint;
  IF ( ShowHint ) AND ( Hint <> '' ) AND ( NOT ShowingHint )
  THEN BEGIN
     IF HasChildren THEN FOR i := 0 TO Pred ( Children^.Count )
     DO BEGIN
        p := Children^.At ( i );
        IF p^.ShowingHint THEN p^.CloseHint;
     END;
     HintWindow := New ( pHintWindow, Init ( SelfPtr, sChar ( Hint ) ) );
     ShowingHint := True;
     HintWindow^.DisplaySelf;
     CloseHint;
  END;
END;

PROCEDURE   TWndParent.CloseHint;
BEGIN
   IF ( Assigned ( HintWindow ) ) AND ( ShowingHint )
   THEN BEGIN
      Dispose ( HintWindow, Done );
      ShowingHint := False;
      MouseCounter := 0;
   END;
END;

FUNCTION  TWndParent.GetTextLen;
BEGIN
   Result := GetWindowTextLength ( Handle );
END;

FUNCTION    TWndParent.GetTextBuf;
BEGIN
  Result := GetWindowText ( Handle, Buffer, BufSize );
END;

PROCEDURE   TWndParent.GetCaption;
VAR
i : WinInteger;
BEGIN
   IF Assigned ( Attr.Title ) THEN StrDispose ( Attr.Title );
   i := Succ ( GetTextLen );
   GetMem ( Attr.Title, i );
   GetTextBuf ( Attr.Title, i );
   pChar2String ( Attr.Title, Caption );
END;

PROCEDURE   TWndParent.SetCaption;
BEGIN
   IF Assigned ( Attr.Title ) THEN StrDispose ( Attr.Title );
   Attr.Title := StrNew ( aCaption );
   pChar2String ( aCaption, Caption );
   SetWindowText ( Handle, Attr.Title );
END;

PROCEDURE   TWndParent.Hide;
BEGIN
   IF ( Handle <> 0 ) AND ( IsWindow ( Handle ) )
     THEN ShowWindow ( Handle, sw_Hide );
END;

FUNCTION    TWndParent.hWindow : HWnd;
BEGIN
   Result := Handle;
END;

FUNCTION    TWndParent.Register;
BEGIN
  Result := GetClassInfo ( _hInstance, GetClassName, MyWndClass );
END;

FUNCTION    TWndParent.HasChildren;
BEGIN
   Result := Children^.Count > 0;
 //  IF result THEN Showmessageint ( Children^.Count );
END;

FUNCTION    TWndParent.ChildCount;
BEGIN
   Result := Pred ( Children^.Count );
END;

FUNCTION    TWndParent.At;
BEGIN
   Result := NIL;
   IF HasChildren
   THEN BEGIN
      IF I > ChildCount THEN I := 0;
      Result := Children^.At ( I );
   END;
END;

FUNCTION    TWndParent.GetClassName : pChar;
BEGIN
   Result := 'TWndParent';
END;

FUNCTION    TWndParent.CreateWnd;
BEGIN
   Result := False;
   IF Handle = 0
   THEN BEGIN
     IF FromResource
     THEN BEGIN
        Handle := GetDlgItem ( ParentHandle, Attr.ID );
        Result := True;
     END
     ELSE BEGIN
       IF Register
       THEN BEGIN
         Handle :=
           CreateWindowEx (
               Attr.ExStyle,
               GetClassName,
               {$ifndef __GPC__}pChar{$endif} ( Caption ),
               Attr.Style,
               Attr.X,
               Attr.Y,
               Attr.W,
               Attr.H,
               ParentHandle,
               hMenu ( Attr.ID ),
               hInstance,
               NIL );
       END { register }
       ELSE BEGIN
         Status := - 1;
         IF MessageBox ( GetActiveWindow, 'Window Class Registration Error. Continue?', 'Serious Error',
         Mb_IconQuestion + Mb_YesNo ) <> idYes
         THEN BEGIN
           PostQuitMessage ( 0 );
           Halt ( 1 );
         END;
       END; { registration failed }
     END; { not fromresource }
   END; { handle = 0 }

   IF Handle <> 0
   THEN BEGIN
       Result := True;
       Status := 0;
       IF Attr.Menu = 0 THEN Attr.Menu := GetMenu ( Handle );
       Instance := TFarProc ( GetWindowLong ( Handle, GWL_WndProc ) );
       IF ParentHandle <> 0 THEN ParentInstance := TFarProc ( GetWindowLong ( ParentHandle, GWL_WndProc ) );
       DefaultProc := Instance;

       SetupWindow; { call the SetupWindow procedure }

   END { handle <> 0 }
   ELSE BEGIN
       Status := - 1;
       IF MessageBox ( GetActiveWindow, 'Window Creation Error. Continue?', 'Serious Error',
       Mb_IconQuestion + Mb_YesNo ) <> idYes
       THEN BEGIN
         PostQuitMessage ( 0 );
         Halt ( 1 );
       END;
   END; { couldn't create window }
END;

PROCEDURE   TWndParent.Show;
BEGIN
   IF Handle = 0
   THEN BEGIN
      CreateWnd;
   END;

   IF Handle <> 0
   THEN BEGIN
      ShowWindow ( Handle, ShowCmd );
   END;
END;

PROCEDURE   TWndParent.UpdateWinRect;
BEGIN
  IF ( Handle <> 0 ) AND ( IsWindow ( Handle ) )
  THEN BEGIN
     GetWindowRect ( Handle, WindowRect );
     GetClientRect ( Handle, ClientRect );
     WITH Attr
     DO BEGIN
        X := WindowRect.Left;
        Y := WindowRect.Top;
        W := WindowRect.Right - WindowRect.Left;
        H := WindowRect.Bottom - WindowRect.Top;
     END;
  END // no window yet - use the Attr.[foo] coordinates
  ELSE WITH WindowRect
  DO BEGIN
     Left := Attr.X;
     Top := Attr.Y;
     Right := Attr.X + Attr.W;
     Bottom := Attr.Y + Attr.H;
  END;
END;

PROCEDURE   TWndParent.SetupWindow;
BEGIN
  DragAcceptFiles ( Handle, True );
  WindowHandleDC := GetDC ( Handle );

  IF Use3D THEN
  WITH Font
  DO BEGIN
     BackGround := ColorButton;
     Brush := CreateSolidBrush ( ColorButton ); // GetStockObject ( LtGray_Brush );
  END;
  UpdateWinRect;

  IF Caption = '' THEN GetCaption;

  CreateChildren;

  PrepareFont;

  IF MyWndClass.hIcon <> 0 THEN Perform ( WM_SetIcon, 1, MyWndClass.hIcon );

  IF Visible = False THEN Show_Code := sw_Hide
                      ELSE Show_Code := sw_ShowNormal;

  IF Visible
  THEN BEGIN
     IF ( Centred ) THEN CentreWindow ( Handle )
      ELSE
         IF ( Assigned ( Parent ) ) AND ( CentredInParent )
         AND ( IsWindow ( Parent^.Handle ) )
            THEN CentreChildWindow ( Parent^.Handle, Handle );
  END;

END;

PROCEDURE   TWndParent.Focus;
BEGIN
   IF ( Handle <> 0 ) AND ( IsWindow ( Handle ) ) THEN SetFocus ( Handle );
END;

PROCEDURE   TWndParent.AddChild;
BEGIN
   IF ( Assigned ( aChild ) ) AND ( Children^.IndexOf ( aChild ) < 0 )
    THEN BEGIN
       Children^.Insert ( aChild );
    END;
END;

PROCEDURE   TWndParent.RemoveChild;
BEGIN
   Children^.Delete ( aChild );
END;

FUNCTION TWndParent.GetId;
BEGIN
   Result := - 1;
END;

FUNCTION    TWndParent.ChildList;
BEGIN
   Result := At ( ChildCount );
END;

{$ifndef _Delphi_}
FUNCTION    TWndParent.Style;
BEGIN
   Result := Attr.Style;
END;

FUNCTION    TWndParent.Right;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Right;
END;

FUNCTION    TWndParent.Bottom;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Bottom;
END;

FUNCTION    TWndParent.Left;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Left;
END;

FUNCTION    TWndParent.Top;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Top;
END;

FUNCTION    TWndParent.Width;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Right - WindowRect.Left;
END;

FUNCTION    TWndParent.Height;
BEGIN
   UpdateWinRect;
   Result := WindowRect.Bottom - WindowRect.Top;
END;

FUNCTION    TWndParent.Menu;
BEGIN
   Result := Attr.Menu;
END;

FUNCTION    TWndParent.ControlID;
BEGIN
   Result := Attr.ID;
END;

FUNCTION    TWndParent.Color;
BEGIN
   Result := Font.Color;
END;

FUNCTION    TWndParent.BackGround;
BEGIN
   Result := Font.BackGround;
END;

FUNCTION    TWndParent.FontName;
BEGIN
   Result := StrPas ( Font.Name );
END;

FUNCTION    TWndParent.FontSize;
BEGIN
   Result := Font.Size;
END;

FUNCTION    TWndParent.FontStyle;
BEGIN
   Result := Font.Style;
END;

FUNCTION    TWndParent.Brush;
BEGIN
   Result := Font.Brush;
END;

{$endif _Delphi_}

FUNCTION    TWndParent.CanClose;
VAR
i : LongWord;
p : pWndParent;
BEGIN
   Result := True;
   IF HasChildren
   THEN FOR i := 0 TO ChildCount
   DO BEGIN
       p := pWndParent ( At ( i ) );
       IF ( Assigned ( p ) ) AND ( IsWindow ( p^.Handle ) ) AND ( NOT p^.CanClose )
       THEN BEGIN
          Result := False;
          Exit;
       END;
   END;
END;

PROCEDURE  TWndParent.WmClose;
BEGIN
  IF Assigned ( OnClose )
    THEN OnClose ( pWindowsObject ( @Self ), Msg ) ELSE Msg.Result := 0;
  Handle := 0;
END;

PROCEDURE  TWndParent.CloseMe;
VAR
Msg : TMessage;
BEGIN
   FillChar ( Msg, Sizeof ( Msg ), 0 );
   WmClose ( Msg );
END;

FUNCTION    TWndParent.Perform;
BEGIN
   Result := SendMessage ( Handle, Msg, WParam, LParam );
END;

PROCEDURE   TWndParent.RepaintWindow;
BEGIN
  InvalidateRect ( Handle, @ClientRect, False );
  // UpdateWindow ( Handle );
END;

PROCEDURE TWndParent.PaintClientArea ( ForeClr, BackClr : WinInteger );
CONST
  nBand : Integer = 256;
VAR
  I, J, YTop, YBottom : Integer;
  TopRGB, DRGB, aRGB : ARRAY [0..2] OF Integer;
  GemBrush : hBrush;
BEGIN
  TopRGB [0] := GetRValue ( ForeClr );
  TopRGB [1] := GetGValue ( ForeClr );
  TopRGB [2] := GetBValue ( ForeClr );
  DRGB [0]  := GetRValue ( BackClr ) - TopRGB [0];
  DRGB [1]  := GetGValue ( BackClr ) - TopRGB [1];
  DRGB [2]  := GetBValue ( BackClr ) - TopRGB [2];

  FOR I := 0 TO nBand - 1
  DO BEGIN
    yTop := MulDiv ( i + ClientRect.Top, ClientRect.Bottom, nBand );
    yBottom := MulDiv ( i + 1 + ClientRect.Top, ClientRect.Bottom, nBand );
    FOR J := 0 TO 2
    DO BEGIN
      aRGB [J] := TopRGB [J] + MulDiv ( I, drgb [J], nBand - 1 );
    END;
    GemBrush := SelectObject ( WindowDC, CreateSolidBrush ( RGB ( aRGB [0], aRGB [1], aRGB [2] ) ) );
    PatBlt ( WindowDC, ClientRect.Left, ytop, ClientRect.Right, yBottom - ytop, patCopy );
    DeleteObject ( SelectObject ( WindowDC, GemBrush ) );
  END;
  RepaintWindow;
END;

PROCEDURE TWndParent.WriteText;
VAR
OldFont : HFont;
BEGIN
   {defaults = black text, white background}
   IF TCol = 0  THEN TCol   := ColorBlack;
   IF TBack = 0 THEN TBack  := ColorWhite;

   {set text colour}
   SetTextColor ( WindowDC, tCol );

   {set background colour}
   SetBkColor ( WindowDC, tBack );

   OldFont := 0;

   {select the new font into device context}

   IF ( Assigned ( FontP ) ) AND ( FontP^.Handle <> 0 )
   THEN BEGIN
      IF FontP^.TransparentBackground THEN SetBkMode ( WindowDC, Transparent );
      OldFont := SelectObject ( WindowDC, FontP^.Handle );
   END;

   {write the text}
   TextOut ( WindowDC, x, y, {$ifndef __GPC__}pChar{$endif} ( aString ), Length ( aString ) );

   {release the device context}
   IF OldFont <> 0 THEN DeleteObject ( OldFont );
END;

FUNCTION    TWndParent.Canvas;
BEGIN
  Result := WindowHandleDC;
END;

FUNCTION    TWndParent.WindowDC;
BEGIN
  Result := WindowHandleDC;
END;

PROCEDURE TWndParent.PrepareFont;
VAR
aDC : HDC;
TheWnd : HWnd;
BEGIN
  IF ( Strlen ( Font.Name ) = 0 ) OR ( Font.Size = 0 ) THEN Exit;
  IF Assigned ( Parent ) THEN TheWnd := Parent^.Handle ELSE TheWnd := 0;
  aDC := GetDC ( TheWnd );
  FillChar ( Font.lFont, SizeOf ( Font.lFont ), 0 );
  WITH Font.lFont DO
  BEGIN
     StrCopy ( lfFaceName, Font.Name );
     lfQuality := Proof_Quality;
     lfWeight := FW_Normal;
     lfPitchAndFamily := Variable_Pitch OR FF_Roman;
     lfHeight := MulDiv ( Font.Size, GetDeviceCaps ( aDC, LogPixelsY ), 72 );
     lfItalic := Ord ( fsItalic IN Font.Style );
     lfUnderLine := Ord ( fsUnderLine IN Font.Style );
     lfStrikeOut := Ord ( fsStrikeOut IN Font.Style );
     IF fsBold IN Font.Style THEN lfWeight := FW_Bold;
     IF Font.Pitch <> 0 THEN lfPitchAndFamily := Font.Pitch;
     lfClipPrecision := Clip_Default_Precis;
     lfOutPrecision := OUT_TT_PRECIS;
  END;
  ReleaseDC ( TheWnd, aDC );
  AssignFont ( Font );
END;

PROCEDURE TWndParent.AssignFont;
BEGIN
   Font := aFont;
   Font.Handle := CreateFontIndirect ( {$ifdef FPC}@{$endif}Font.lFont );
   IF Font.Handle <> 0
   THEN BEGIN
      SetTextColor ( WindowDC, Font.Color );
      SetBkColor ( WindowDC, Font.BackGround );
      IF Font.TransparentBackground THEN SetBkMode ( WindowDC, Transparent );
      Perform ( WM_SetFont, Font.Handle, 1 );
   END;
END;

FUNCTION TWndParent.SelfPtr;
BEGIN
   Result := pWindowsObject ( @Self );
END;

FUNCTION TWndParent.pSelf;
BEGIN
   Result := SelfPtr;
END;

FUNCTION TWndParent.IsMainWindow;
BEGIN
   Result := ( SelfPtr = MainWindowPtr );
END;

FUNCTION TWndParent.MainWindowPtr;
BEGIN
   IF Assigned ( Application )
     THEN Result := Application^.MainWindow
      ELSE Result := NIL;
END;

PROCEDURE   TWndParent.WmChange;
BEGIN
  Msg.Result := 0;
END;

PROCEDURE   TWndParent.WmUpdate;
BEGIN
  Msg.Result := 0;
END;

PROCEDURE   TWndParent.WmEnter;
BEGIN
  Msg.Result := 0;
END;

PROCEDURE   TWndParent.WmExit;
BEGIN
  Msg.Result := 0;
END;

PROCEDURE   TWndParent.WmDblClick;
BEGIN
  Msg.Result := 0;
END;

PROCEDURE   TWndParent.WmClick;
BEGIN
  Msg.Result := 0;
END;

{*************************************}
CONSTRUCTOR TWindowsObject.Init;
BEGIN
   INHERITED Init ( Owner );
   Name := 'TWindowsObject';
   WITH Attr // some silly defaults
   DO BEGIN
      x := 1;
      y := 1;
      w := 100;
      h := 100;
   END;
END;

CONSTRUCTOR TWindowsObject.InitResource;
BEGIN
   INHERITED InitResource ( Owner, ResourceID );
   Name := 'TWindowsObject';
END;

FUNCTION TWindowsObject.GetClassName : pChar;
BEGIN
   Result := 'twindowsobject';
END;

PROCEDURE TWindowsObject.GetWindowClass ( VAR AWndClass : TWndClass );
BEGIN
 WITH AWndClass
 DO BEGIN
    cbClsExtra    := 0;
    cbWndExtra    := 0;
    hInstance     := _hInstance;
    hIcon         := LoadIcon ( 0, idi_Application );
    hCursor       := LoadCursor ( 0, idc_Arrow );
    hbrBackground := GetStockObject ( white_Brush );
    lpszMenuName  := 'MainMenu';
    lpszClassName := GetClassName;
    style         := cs_HRedraw OR cs_VRedraw;
    lpfnWndProc   := @GeneralDefWndProc;
 END;
END;

PROCEDURE   TWindowsObject.wCloseWindow;
VAR Msg : TMessage;
BEGIN
  IF IsMainWindow
  THEN BEGIN
     IF Application^.CanClose
     THEN BEGIN
       WMClose ( Msg );
     END;
  END
  ELSE IF CanClose
  THEN BEGIN
     WMClose ( Msg );
  END;
END;

PROCEDURE   TWindowsObject.EnableKBHandler;
BEGIN
  { dummy }
END;

PROCEDURE   TWindowsObject.EnableAutoCreate;
BEGIN
  { dummy }
END;

PROCEDURE   TWindowsObject.DisableAutoCreate;
BEGIN
  { dummy }
END;

PROCEDURE   TWindowsObject.EnableTransfer;
BEGIN
  { dummy }
END;

PROCEDURE   TWindowsObject.DisableTransfer;
BEGIN
  { dummy }
END;

PROCEDURE    TWindowsObject.WMFindDialog;
VAR
p : pFindReplace;
Finder : pFindDialog;
w : dword;
BEGIN
   WITH Msg
   DO BEGIN
      p := pFindReplace ( Msg.lParam );
      w := p^.Flags;

      { can we find this object? }
      Finder := pFindDialog ( ChildFromSelfID ( @Self, p^.lCustData ) );

      { yes }
      IF Assigned ( Finder )
      THEN BEGIN
           { the find dialog is ending }
           IF w AND FR_DIALOGTERM <> 0
           THEN BEGIN
              ObjectList^.Delete ( Finder );
              Dispose ( Finder );
              exit;
           END;

           { prepare message record }
           IF w AND FR_FINDNEXT <> 0 THEN Msg.Message := FR_FINDNEXT
              ELSE IF w AND FR_REPLACE <> 0 THEN Msg.Message := FR_REPLACE
                ELSE IF w AND FR_REPLACEALL <> 0 THEN Msg.Message := FR_REPLACEALL
                  ELSE Msg.Message := Message;

            { prepare the FindDialog object's fields }

            Move ( p^, Finder^.FindRec, Sizeof ( p^ ) );
            pChar2String ( p^.lpstrFindWhat, Finder^.FindText );
            pChar2String ( p^.lpstrReplaceWith, Finder^.ReplaceString );

            Finder^.SearchDown := w AND FR_DOWN <> 0;
            Finder^.MatchCase := w AND FR_MATCHCASE <> 0;
            Finder^.MatchWholeWords := w AND FR_WHOLEWORD <> 0;

            Msg.Sender := Finder;
            Msg.Receiver := Finder^.Handle;
            Msg.LParam := w;

            { run the FindDialog's event handler }
            IF Assigned ( Finder^.IsFound ) THEN Finder^.IsFound ( Finder, Msg )
              ELSE IF Assigned ( Finder^.Onclick ) THEN Finder^.OnClick ( Finder, Msg );
      END;
   END;
END;

PROCEDURE  TWindowsObject.DefWndProc;
BEGIN
 WITH Msg
 DO BEGIN

   Result := 0;
   UpdateWinRect;

   { Finddialog hooks }
   IF ( Message = FindMsg )
   THEN BEGIN
      WMFindDialog ( Msg );
      Exit;
   END; { finddialog hooks }

   // Result := DefWindowProc ( Receiver, Message, wParam, lParam );
   { other messages }
   CASE Message OF  { some messages are mapped to methods here }

      wm_Command : WMCommand ( Msg );
      wm_KeyDown : WmKeyDown ( Msg );
      Wm_Create  : WmCreate ( Msg );
      Wm_Size    : WmSize ( Msg );
      Wm_hScroll : WmhScroll ( Msg );
      Wm_vScroll : WmvScroll ( Msg );
      Wm_Move    : WmMove ( Msg );
      wm_Activate : WmActivate ( Msg );
      Wm_Close   : WmClose ( Msg );
      Wm_Paint   : WmPaint ( Msg );
      wm_timer   : WmTimer ( Msg );

      wm_Notify  : WmNotify ( Msg );
      wm_SetFocus : WmSetFocus ( Msg );
      wm_Destroy : WmDestroy ( Msg );
      WM_NCDestroy       : WMNCDestroy ( Msg );
      wm_erasebkgnd      : WMEraseBackGround ( Msg );
      wm_InitDialog      : WMInitDialog ( Msg );
      wm_dropfiles       : WMDropFiles ( Msg );
      WM_GETMINMAXINFO   : WmGETMINMAXINFO ( Msg );
      WM_QueryEndSession : WMQueryEndSession ( Msg );

      {-automated starts -}
      WM_ACTIVATEAPP : WMACTIVATEAPP ( Msg );
      WM_ASKCBFORMATNAME : WMASKCBFORMATNAME ( Msg );
      WM_CANCELJOURNAL : WMCANCELJOURNAL ( Msg );
      WM_CANCELMODE : WMCANCELMODE ( Msg );
      WM_CAPTURECHANGED : WMCAPTURECHANGED ( Msg );
      WM_CHANGECBCHAIN : WMCHANGECBCHAIN ( Msg );
      WM_CHAR : WMCHAR ( Msg );
      WM_CHARTOITEM : WMCHARTOITEM ( Msg );
      WM_CHILDACTIVATE : WMCHILDACTIVATE ( Msg );
      WM_CHOOSEFONT_GETLOGFONT : WMCHOOSEFONT_GETLOGFONT ( Msg );
      WM_CHOOSEFONT_SETLOGFONT : WMCHOOSEFONT_SETLOGFONT ( Msg );
      WM_CHOOSEFONT_SETFLAGS : WMCHOOSEFONT_SETFLAGS ( Msg );
      WM_CLEAR : WMCLEAR ( Msg );
      WM_COMPACTING : WMCOMPACTING ( Msg );
      WM_COMPAREITEM : WMCOMPAREITEM ( Msg );
      WM_CONTEXTMENU : WMCONTEXTMENU ( Msg );
      WM_COPY : WMCOPY ( Msg );
      WM_COPYDATA : WMCOPYDATA ( Msg );

      WM_CTLCOLORBTN : WMCTLCOLORBTN ( Msg );
      WM_CTLCOLORDLG : WMCTLCOLORDLG ( Msg );
      WM_CTLCOLOREDIT : WMCTLCOLOREDIT ( Msg );
      WM_CTLCOLORLISTBOX : WMCTLCOLORLISTBOX ( Msg );
      WM_CTLCOLORMSGBOX : WMCTLCOLORMSGBOX ( Msg );
      WM_CTLCOLORSCROLLBAR : WMCTLCOLORSCROLLBAR ( Msg );
      WM_CTLCOLORSTATIC : WMCTLCOLORSTATIC ( Msg );

      WM_CUT : WMCUT ( Msg );
      WM_DEADCHAR : WMDEADCHAR ( Msg );
      WM_DELETEITEM : WMDELETEITEM ( Msg );
      WM_DESTROYCLIPBOARD : WMDESTROYCLIPBOARD ( Msg );
      WM_DEVICECHANGE : WMDEVICECHANGE ( Msg );
      WM_DEVMODECHANGE : WMDEVMODECHANGE ( Msg );
      WM_DISPLAYCHANGE : WMDISPLAYCHANGE ( Msg );
      WM_DRAWCLIPBOARD : WMDRAWCLIPBOARD ( Msg );
      WM_DRAWITEM : WMDRAWITEM ( Msg );
      WM_ENABLE : WMENABLE ( Msg );
      WM_ENDSESSION : WMENDSESSION ( Msg );
      WM_ENTERIDLE : WMENTERIDLE ( Msg );
      WM_ENTERMENULOOP : WMENTERMENULOOP ( Msg );
      WM_ENTERSIZEMOVE : WMENTERSIZEMOVE ( Msg );
      WM_EXITMENULOOP : WMEXITMENULOOP ( Msg );
      WM_EXITSIZEMOVE : WMEXITSIZEMOVE ( Msg );
      WM_FONTCHANGE : WMFONTCHANGE ( Msg );
      WM_GETDLGCODE : WMGETDLGCODE ( Msg );
      WM_GETFONT : WMGETFONT ( Msg );
      WM_GETHOTKEY : WMGETHOTKEY ( Msg );
      WM_GETICON : WMGETICON ( Msg );
      WM_GETTEXT : WMGETTEXT ( Msg );
      WM_GETTEXTLENGTH : WMGETTEXTLENGTH ( Msg );
      WM_HELP : WMHELP ( Msg );
      WM_HOTKEY : WMHOTKEY ( Msg );
      WM_HSCROLLCLIPBOARD : WMHSCROLLCLIPBOARD ( Msg );
      WM_ICONERASEBKGND : WMICONERASEBKGND ( Msg );
      WM_IME_CHAR : WMIME_CHAR ( Msg );
      WM_IME_COMPOSITION : WMIME_COMPOSITION ( Msg );
      WM_IME_COMPOSITIONFULL : WMIME_COMPOSITIONFULL ( Msg );
      WM_IME_CONTROL : WMIME_CONTROL ( Msg );
      WM_IME_ENDCOMPOSITION : WMIME_ENDCOMPOSITION ( Msg );
      WM_IME_KEYDOWN : WMIME_KEYDOWN ( Msg );
      WM_IME_KEYUP : WMIME_KEYUP ( Msg );
      WM_IME_NOTIFY : WMIME_NOTIFY ( Msg );
      WM_IME_SELECT : WMIME_SELECT ( Msg );
      WM_IME_SETCONTEXT : WMIME_SETCONTEXT ( Msg );
      WM_IME_STARTCOMPOSITION : WMIME_STARTCOMPOSITION ( Msg );
      WM_INITMENU : WMINITMENU ( Msg );
      WM_INITMENUPOPUP : WMINITMENUPOPUP ( Msg );
      WM_INPUTLANGCHANGE : WMINPUTLANGCHANGE ( Msg );
      WM_INPUTLANGCHANGEREQUEST : WMINPUTLANGCHANGEREQUEST ( Msg );
      WM_KEYUP : WMKEYUP ( Msg );
      WM_KILLFOCUS : WMKILLFOCUS ( Msg );
      WM_LBUTTONDBLCLK : WMLBUTTONDBLCLK ( Msg );
      WM_LBUTTONDOWN : WMLBUTTONDOWN ( Msg );
      WM_LBUTTONUP : WMLBUTTONUP ( Msg );
      WM_MBUTTONDBLCLK : WMMBUTTONDBLCLK ( Msg );
      WM_MBUTTONDOWN : WMMBUTTONDOWN ( Msg );
      WM_MBUTTONUP : WMMBUTTONUP ( Msg );
      WM_MDIACTIVATE : WMMDIACTIVATE ( Msg );
      WM_MDICASCADE : WMMDICASCADE ( Msg );
      WM_MDICREATE : WMMDICREATE ( Msg );
      WM_MDIDESTROY : WMMDIDESTROY ( Msg );
      WM_MDIGETACTIVE : WMMDIGETACTIVE ( Msg );
      WM_MDIICONARRANGE : WMMDIICONARRANGE ( Msg );
      WM_MDIMAXIMIZE : WMMDIMAXIMIZE ( Msg );
      WM_MDINEXT : WMMDINEXT ( Msg );
      WM_MDIREFRESHMENU : WMMDIREFRESHMENU ( Msg );
      WM_MDIRESTORE : WMMDIRESTORE ( Msg );
      WM_MDISETMENU : WMMDISETMENU ( Msg );
      WM_MDITILE : WMMDITILE ( Msg );
      WM_MEASUREITEM : WMMEASUREITEM ( Msg );
      WM_MENUCHAR : WMMENUCHAR ( Msg );
      WM_MENUSELECT : WMMENUSELECT ( Msg );
      WM_MOUSEACTIVATE : WMMOUSEACTIVATE ( Msg );
      // WM_MOUSEHOVER : WMMOUSEHOVER ( Msg );
      // WM_MOUSELEAVE : WMMOUSELEAVE ( Msg );
      WM_MOVING : WMMOVING ( Msg );
      WM_NCACTIVATE : WMNCACTIVATE ( Msg );
      WM_NCCALCSIZE : WMNCCALCSIZE ( Msg );
      WM_NCCREATE : WMNCCREATE ( Msg );
      WM_NCHITTEST : WMNCHITTEST ( Msg );
      WM_NCLBUTTONDBLCLK : WMNCLBUTTONDBLCLK ( Msg );
      WM_NCLBUTTONDOWN : WMNCLBUTTONDOWN ( Msg );
      WM_NCLBUTTONUP : WMNCLBUTTONUP ( Msg );
      WM_NCMBUTTONDBLCLK : WMNCMBUTTONDBLCLK ( Msg );
      WM_NCMBUTTONDOWN : WMNCMBUTTONDOWN ( Msg );
      WM_NCMBUTTONUP : WMNCMBUTTONUP ( Msg );
      WM_NCMOUSEMOVE : WMNCMOUSEMOVE ( Msg );
      WM_NCPAINT : WMNCPAINT ( Msg );
      WM_NCRBUTTONDBLCLK : WMNCRBUTTONDBLCLK ( Msg );
      WM_NCRBUTTONDOWN : WMNCRBUTTONDOWN ( Msg );
      WM_NCRBUTTONUP : WMNCRBUTTONUP ( Msg );
      WM_NEXTDLGCTL : WMNEXTDLGCTL ( Msg );
      WM_NOTIFYFORMAT : WMNOTIFYFORMAT ( Msg );
      WM_NULL : WMNULL ( Msg );
      WM_PAINTCLIPBOARD : WMPAINTCLIPBOARD ( Msg );
      WM_PAINTICON : WMPAINTICON ( Msg );
      WM_PALETTECHANGED : WMPALETTECHANGED ( Msg );
      WM_PALETTEISCHANGING : WMPALETTEISCHANGING ( Msg );
      WM_PARENTNOTIFY : WMPARENTNOTIFY ( Msg );
      WM_PASTE : WMPASTE ( Msg );
      WM_PENWINFIRST : WMPENWINFIRST ( Msg );
      WM_PENWINLAST : WMPENWINLAST ( Msg );
      WM_POWER : WMPOWER ( Msg );
      WM_POWERBROADCAST : WMPOWERBROADCAST ( Msg );
      WM_PRINT : WMPRINT ( Msg );
      WM_PRINTCLIENT : WMPRINTCLIENT ( Msg );
      WM_PSD_ENVSTAMPRECT : WMPSD_ENVSTAMPRECT ( Msg );
      WM_PSD_GREEKTEXTRECT : WMPSD_GREEKTEXTRECT ( Msg );
      WM_PSD_MARGINRECT : WMPSD_MARGINRECT ( Msg );
      WM_PSD_MINMARGINRECT : WMPSD_MINMARGINRECT ( Msg );
      WM_PSD_YAFULLPAGERECT : WMPSD_YAFULLPAGERECT ( Msg );
      WM_QUERYDRAGICON : WMQUERYDRAGICON ( Msg );
      WM_QUERYNEWPALETTE : WMQUERYNEWPALETTE ( Msg );
      WM_QUERYOPEN : WMQUERYOPEN ( Msg );
      WM_QUEUESYNC : WMQUEUESYNC ( Msg );
      WM_QUIT : WMQUIT ( Msg );
      WM_RBUTTONDBLCLK : WMRBUTTONDBLCLK ( Msg );
      WM_RBUTTONDOWN : WMRBUTTONDOWN ( Msg );
      WM_RBUTTONUP : WMRBUTTONUP ( Msg );
      WM_RENDERALLFORMATS : WMRENDERALLFORMATS ( Msg );
      WM_RENDERFORMAT : WMRENDERFORMAT ( Msg );
      WM_SETCURSOR : WMSETCURSOR ( Msg );
      WM_SETFONT : WMSETFONT ( Msg );
      WM_SETHOTKEY : WMSETHOTKEY ( Msg );
      WM_SETICON : WMSETICON ( Msg );
      WM_SETREDRAW : WMSETREDRAW ( Msg );
      WM_SETTEXT : WMSETTEXT ( Msg );
      WM_SHOWWINDOW : WMSHOWWINDOW ( Msg );
      WM_SIZECLIPBOARD : WMSIZECLIPBOARD ( Msg );
      WM_SIZING : WMSIZING ( Msg );
      WM_SPOOLERSTATUS : WMSPOOLERSTATUS ( Msg );
      WM_STYLECHANGED : WMSTYLECHANGED ( Msg );
      WM_STYLECHANGING : WMSTYLECHANGING ( Msg );
      WM_SYSCHAR : WMSYSCHAR ( Msg );
      WM_SYSCOLORCHANGE : WMSYSCOLORCHANGE ( Msg );
      WM_SYSCOMMAND : WMSYSCOMMAND ( Msg );
      WM_SYSDEADCHAR : WMSYSDEADCHAR ( Msg );
      WM_SYSKEYDOWN : WMSYSKEYDOWN ( Msg );
      WM_SYSKEYUP : WMSYSKEYUP ( Msg );
      WM_TCARD : WMTCARD ( Msg );
      WM_TIMECHANGE : WMTIMECHANGE ( Msg );
      WM_UNDO : WMUNDO ( Msg );
      WM_USER : WMUSER ( Msg );
      WM_USERCHANGED : WMUSERCHANGED ( Msg );
      WM_VKEYTOITEM : WMVKEYTOITEM ( Msg );
      WM_VSCROLLCLIPBOARD : WMVSCROLLCLIPBOARD ( Msg );
      WM_WINDOWPOSCHANGED : WMWINDOWPOSCHANGED ( Msg );
      WM_WINDOWPOSCHANGING : WMWINDOWPOSCHANGING ( Msg );
      WM_WININICHANGE : WMWININICHANGE ( Msg );
      WM_KEYLAST : WMKEYLAST ( Msg );
      WM_MOUSEMOVE : WMMOUSEMOVE ( Msg );
      {-automated ends -}
   ELSE BEGIN
   END;
   END; {Case Message}
  END; { with Msg }
END;

PROCEDURE  TWindowsObject.WMCommand;
VAR
p : pWindowsObject;
T : TEventHandler;
BEGIN
   Msg.Result := 1;

   { process messages from menus and child controls }
   WITH Msg
   DO BEGIN
     p := InstanceFromHandle ( LParam );
     IF Assigned ( p )
     THEN BEGIN
        Msg.Sender := p;
        WITH p^ DO BEGIN
          CASE Msg.WParamHi OF
           STN_DBLCLK,
           BN_DBLCLK      :
           BEGIN
              WMDblClick ( Msg );
              T := OnDblClick;
           END;

           EN_KILLFOCUS,
           BN_KILLFOCUS   :
           BEGIN
              WMExit ( Msg );
              T := OnExit;
           END;

           EN_Update      :
           BEGIN
              WMUpdate ( Msg );
              T := OnUpdate;
           END;

           EN_Change      :
           BEGIN
              WMChange ( Msg );
              T := OnChange;
           END;

           EN_SetFocus,
           BN_SetFocus    :
           BEGIN
              WMEnter ( Msg );
              T := OnEnter;
           END;

          ELSE BEGIN
              WMClick ( Msg );
              T := OnClick;
          END;
        END; {case}
        END;
        IF Assigned ( T )
        THEN BEGIN
          T ( p, Msg );
          Exit;
        END;
     END;
     DefCommandProc ( Msg );
   END; { with msg }
END;

PROCEDURE   TWindowsObject.DefCommandProc;
VAR
ID : WParam32;
BEGIN
   ID := Msg.WParamLo;
   (* ID := {$ifdef VirtualPascal}Msg.WParam{$else}Msg.WParamLo{$endif}; *)
   WITH Msg.Sender^
   DO BEGIN
      (*
      {$ifdef VirtualPascal}   // FOR some reason things are different IN VP //
        IF ( Name = 'TListBox' ) // kludge FOR Listbox types
        OR ( Name = 'TComboBox' )
        OR ( StrPas ( GetClassName ) = 'ListBox' )
        OR ( StrPas ( GetClassName ) = 'ComboBox' )
        THEN BEGIN
           ID := Msg.WParamHi;
           Msg.WParamHi := Msg.LParamLo;
        END;
      {$endif}
      *)
   END;
   Msg.Result := ProcessCommands ( Msg, ID );
END;

FUNCTION   TWindowsObject.ProcessCommands;
BEGIN
  Result := 1;
  CASE ID OF
       CM_FileExit : CMExit ( Msg );
       CM_HelpAbout : CMHelpAbout ( Msg );
    ELSE Result := 0;
  END;
//  IF ID = CM_FileExit THEN CMExit ( Msg ) { Process the "File, Exit" menu item only }
//    ELSE Result := 0;
END;

FUNCTION    TWindowsObject.Register;
BEGIN
  Result := True;
  IF NOT INHERITED Register
  THEN BEGIN
    GetWindowClass ( MyWndClass );
    Result := RegisterClass ( MyWndClass ) <> 0;
  END;
END;

FUNCTION    TWindowsObject.ChildWithId;
VAR
p : pWindowsObject;
i : LongWord;
BEGIN
   Result := NIL;
   IF NOT HasChildren THEN Exit;
   FOR i := 0 TO ChildCount
   DO BEGIN
      p := pWindowsObject ( At ( i ) );
      IF p^.Attr.ID = ID
      THEN BEGIN
         Result := p;
         Exit;
      END;
   END;
END;

FUNCTION    TWindowsObject.ChildWithHWnd;
VAR
p : pWindowsObject;
i : LongWord;
BEGIN
   Result := NIL;
   IF NOT HasChildren THEN Exit;
   FOR i := 0 TO ChildCount
   DO BEGIN
      p := pWindowsObject ( At ( i ) );
      IF ( Assigned ( p ) ) AND ( p^.Handle = aWnd )
      THEN BEGIN
         Result := p;
         Exit;
      END;
   END;
END;

PROCEDURE  TWindowsObject.WmNotify;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmSetFocus;
BEGIN
   Msg.Result := 1;
   Focus;
END;

PROCEDURE  TWindowsObject.WmCreate;
BEGIN
   Msg.Result := 0;
   IF Assigned ( OnCreate )
     THEN BEGIN
        OnCreate ( SelfPtr, Msg )
     END
        ELSE DefWndProc ( Msg );
END;

PROCEDURE  TWindowsObject.WMDestroy;
BEGIN
   Msg.Result := 1;
   IF Assigned ( OnDestroy ) THEN OnDestroy ( SelfPtr, Msg )
   ELSE BEGIN
     IF IsMainWindow
       THEN PostQuitMessage ( Handle )
         ELSE {DestroyWindow(Handle)}
   END;
END;

PROCEDURE  TWindowsObject.WMQueryEndSession;
BEGIN
  IF IsMainWindow
    THEN Msg.Result := Ord ( Application^.CanClose )
      ELSE Msg.Result := Ord ( CanClose );
END;

FUNCTION    TWindowsObject.CreateMemoryDC;
VAR
aDC : HDC;
BEGIN
  aDC := GetDC ( Handle );
  Result := CreateCompatibleDC ( aDC );
  ReleaseDC ( Handle, aDC );
END;

PROCEDURE   TWindowsObject.CMHelpAbout;
BEGIN
   IF Assigned ( AboutPtr ) THEN
     MessageBox ( Handle, AboutPtr, sChar ( Application^.Title ), 0 );
END;

PROCEDURE  TWindowsObject.CMExit;
BEGIN
  IF IsMainWindow
    THEN wCloseWindow
      ELSE DefCommandProc ( Msg );
END;

FUNCTION   TWindowsObject.Enable;
BEGIN
  IF Handle <> 0
    THEN Result := EnableWindow ( Handle, True )
     ELSE Result := False;
END;

FUNCTION   TWindowsObject.Disable;
BEGIN
  IF Handle <> 0
   THEN Result := EnableWindow ( Handle, False )
     ELSE Result := False;
END;

PROCEDURE ChangeWindowBack ( CONST Wnd : HWND; CONST DC : Hdc; CONST Color : TColorRef );
VAR
  aBrush,
  OldBrush : hBrush;
  t : LTRect;
BEGIN
  aBrush := {GetStockObject} ( Color );
//  UnrealizeObject ( aBrush );
  OldBrush := SelectObject ( DC, aBrush );
  GetClientRect ( Wnd, t );
  WITH t DO PatBlt ( DC, left, top, right - left, bottom - top, PatCopy );
  DeleteObject ( SelectObject ( DC, OldBrush ) );
  SelectObject ( DC, OldBrush );
END;

PROCEDURE   TWindowsObject.WMInitDialog;
BEGIN
   Msg.Result := 0;
   Instance := TFarProc ( GetWindowLong ( Handle, DWL_DLGPROC ) );
   SetupWindow;
END;

PROCEDURE  TWindowsObject.WMEraseBackGround;
BEGIN
  IF BorderStyle = bsDialog
  THEN BEGIN
     ChangeWindowBack ( Handle, hdc ( Msg.wParam ),
                        CreateSolidBrush ( ColorButton ) ); // LtGray_Brush );
     Msg.Result := 1;
  END
  ELSE IF WindowColor <> ColorWhite
  THEN BEGIN
     ChangeWindowBack ( Handle, hdc ( Msg.wParam ), CreateSolidBrush ( WindowColor ) );
     Msg.Result := 1;
  END ELSE Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WMDropFiles;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
END;

PROCEDURE  TWindowsObject.WmPaint;
VAR
t : tpaintstruct;
BEGIN
   BeginPaint ( Handle, t );
   Paint ( t.hdc, t );
   EndPaint ( Handle, t );
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmGetMinMaxInfo;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmKeyDown;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmSize;
BEGIN
   UpdateWinRect;
   Msg.Result := 1;
   IF Assigned ( OnResize )
      THEN OnResize ( SelfPtr, Msg )
          ELSE Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmMove;
BEGIN
   UpdateWinRect;
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WMActivate;
BEGIN
   IF Assigned ( OnActivate )
     THEN begin
     //ShowMessage (Caption);

     OnActivate ( SelfPtr, Msg )
     end
       ELSE Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WmTimer;
BEGIN
   IF Assigned ( OnTimer )
     THEN OnTimer ( SelfPtr, Msg )
       ELSE Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WMHScroll;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WMVScroll;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE  TWindowsObject.WMNCDestroy;
BEGIN
   Msg.Result := 0;
END;

{- automated starts -}
PROCEDURE   TWindowsObject.WMACTIVATEAPP; { 28} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMASKCBFORMATNAME; { 780} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCANCELJOURNAL; { 75} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCANCELMODE; { 31} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCAPTURECHANGED; { 533} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHANGECBCHAIN; { 781} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHAR; { 258} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHARTOITEM; { 47} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHILDACTIVATE; { 34} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHOOSEFONT_GETLOGFONT; { 1025} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHOOSEFONT_SETLOGFONT; { 1125} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCHOOSEFONT_SETFLAGS; { 1126} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCLEAR; { 771} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCOMPACTING; { 65} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCOMPAREITEM; { 57} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCONTEXTMENU; { 123} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCOPY; { 769} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMCOPYDATA; { 74} BEGIN Msg.Result := 0; END;

PROCEDURE   TWindowsObject.WMCTLCOLORBTN;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCTLCOLORDLG;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCTLCOLOREDIT;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCTLCOLORLISTBOX;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCTLCOLORMSGBOX;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCTLCOLORSCROLLBAR;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE TWindowsObject.WMCTLCOLOR;
VAR
p : pWindowsObject;
BEGIN
   p := ChildWithHWnd ( Msg.LParam );
   Msg.Result := 0;
   IF Assigned ( p ) THEN
   WITH p^.Font
   DO BEGIN
      SetTextColor ( Msg.WParam, Color );
      IF p^.WindowColor <> ColorWhite
      THEN BEGIN
         SetBkColor ( Msg.WParam, p^.WindowColor );
         Msg.Result := CreateSolidBrush ( p^.WindowColor );
      END
      ELSE BEGIN
         SetBkColor ( Msg.WParam, BackGround );
         Msg.Result := Brush;
      END;
   END;
END;

PROCEDURE   TWindowsObject.WMCTLCOLORSTATIC;
BEGIN
   WmCtlColor ( Msg );
END;

PROCEDURE   TWindowsObject.WMCUT; { 768} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDEADCHAR; { 259} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDELETEITEM; { 45} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDESTROYCLIPBOARD; { 775} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDEVICECHANGE; { 537} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDEVMODECHANGE; { 27} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDISPLAYCHANGE; { 126} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMDRAWCLIPBOARD; { 776} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMENABLE; { 10} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMENDSESSION; { 22} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMENTERIDLE; { 289} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMENTERMENULOOP; { 529} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMENTERSIZEMOVE; { 561} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMERASEBKGND; { 20} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMEXITMENULOOP; { 530} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMEXITSIZEMOVE; { 562} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMFONTCHANGE; { 29} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETDLGCODE; { 135} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETFONT; { 49} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETHOTKEY; { 51} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETICON; { 127} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETTEXT; { 13} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMGETTEXTLENGTH; { 14} BEGIN Msg.Result := 0; END;

PROCEDURE   TWindowsObject.WMHELP;
BEGIN
   IF Assigned ( OnHelp ) THEN OnHelp ( SelfPtr, Msg )
   ELSE
   Msg.Result := 0;
END;
PROCEDURE   TWindowsObject.WMHOTKEY; { 786} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMHSCROLLCLIPBOARD; { 782} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMICONERASEBKGND; { 39} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_CHAR; { 646} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_COMPOSITION; { 271} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_COMPOSITIONFULL; { 644} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_CONTROL; { 643} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_ENDCOMPOSITION; { 270} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_KEYDOWN; { 656} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_KEYUP; { 657} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_NOTIFY; { 642} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_SELECT; { 645} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_SETCONTEXT; { 641} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMIME_STARTCOMPOSITION; { 269} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMINITMENU; { 278} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMINITMENUPOPUP; { 279} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMINPUTLANGCHANGE; { 81} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMINPUTLANGCHANGEREQUEST; { 80} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMKEYUP; { 257} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMKILLFOCUS; { 8} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMLBUTTONDBLCLK; { 515} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMLBUTTONDOWN; { 513} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMLBUTTONUP; { 514} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMBUTTONDBLCLK; { 521} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMBUTTONDOWN; { 519} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMBUTTONUP; { 520} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIACTIVATE; { 546} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDICASCADE; { 551} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDICREATE; { 544} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIDESTROY; { 545} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIGETACTIVE; { 553} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIICONARRANGE; { 552} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIMAXIMIZE; { 549} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDINEXT; { 548} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIREFRESHMENU; { 564} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDIRESTORE; { 547} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDISETMENU; { 560} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMDITILE; { 550} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMEASUREITEM; { 44} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMENUCHAR; { 288} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMOUSEACTIVATE; { 33} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMOUSEHOVER; BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMMOUSELEAVE; BEGIN Msg.Result := 0; END;

PROCEDURE   TWindowsObject.WMMOUSEMOVE;
BEGIN
   IF ( MouseCounter > 7 ) // don't do this at every mouse move
   then begin
      MouseCounter := 0;
      DisplayHint;
   end else Inc (MouseCounter);
   Msg.Result := 0;
END;

PROCEDURE   TWindowsObject.WMNCHITTEST;
Var
i : DWord;
p : pWndParent;
BEGIN
   Msg.Result := 0;
   If HasChildren then
   for i := 0 to Pred (Children^.Count)
   do begin
      p := Children^.At(i);
      if p^.ShowingHint then p^.CloseHint;
   end;
END;

PROCEDURE   TWindowsObject.WMMOVING; { 534} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCACTIVATE; { 134} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCCALCSIZE; { 131} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCCREATE; { 129} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCLBUTTONDBLCLK; { 163} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCLBUTTONDOWN; { 161} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCLBUTTONUP; { 162} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCMBUTTONDBLCLK; { 169} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCMBUTTONDOWN; { 167} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCMBUTTONUP; { 168} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCMOUSEMOVE; { 160} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCPAINT; { 133} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCRBUTTONDBLCLK; { 166} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCRBUTTONDOWN; { 164} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNCRBUTTONUP; { 165} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNEXTDLGCTL; { 40} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNOTIFYFORMAT; { 85} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMNULL; { 0} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPAINTCLIPBOARD; { 777} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPAINTICON; { 38} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPALETTECHANGED; { 785} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPALETTEISCHANGING; { 784} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPARENTNOTIFY; { 528} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPASTE; { 770} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPENWINFIRST; { 896} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPENWINLAST; { 911} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPOWER; { 72} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPOWERBROADCAST; { 536} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPRINT; { 791} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPRINTCLIENT; { 792} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPSD_ENVSTAMPRECT; { 1029} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPSD_GREEKTEXTRECT; { 1028} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPSD_MARGINRECT; { 1027} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPSD_MINMARGINRECT; { 1026} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMPSD_YAFULLPAGERECT; { 1030} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMQUERYDRAGICON; { 55} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMQUERYNEWPALETTE; { 783} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMQUERYOPEN; { 19} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMQUEUESYNC; { 35} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMQUIT; { 18} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMRBUTTONDBLCLK; { 518} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMRBUTTONDOWN; { 516} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMRBUTTONUP; { 517} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMRENDERALLFORMATS; { 774} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMRENDERFORMAT; { 773} BEGIN Msg.Result := 0; END;

PROCEDURE   TWindowsObject.WMDRAWITEM; { 43}
VAR
pControlWnd : pBitmapWindow;
BEGIN
  Msg.Result := 0;
  WITH PDrawItemStruct ( Msg.lParam )^
  DO Begin
    pControlWnd := pBitmapWindow ( ChildWithID ( CtlID ) );
    Case CtlType of
       ODT_BUTTON :
       Begin
          If Assigned (pControlWnd)
          then begin
              pControlWnd^.DrawButton (Msg);
              Msg.Result := 1;
          end;
       End;
     ELSE
      //Inherited WMDRAWITEM (Msg);
    End; // Case
  End; // with
END;

PROCEDURE TWindowsObject.WMMENUSELECT;
BEGIN
   Msg.Result := 0;
END;

PROCEDURE   TWindowsObject.WMSETCURSOR;
VAR
p : pWindowsObject;
BEGIN
  WITH Msg
  DO BEGIN
    Result := 0;  { default to no processing }
    CASE lParamHi OF
     wm_MouseMove : { trap wm_mousemove }
     BEGIN
       p := ChildWithHWnd ( WParam ); { find the relevant child window }
       IF Assigned ( p )
       THEN BEGIN
          Msg.Sender := p;
          p^.WMMouseMove ( Msg )      { call its wmMouseMove method }
       END
       ELSE BEGIN
          SendMessage ( WParam, lParamHi, 0, 0 );
       END;
     END; { wm_mousemove}
    END; { case }
  END; { with }
END;

PROCEDURE   TWindowsObject.WMSETFONT; { 48} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSETHOTKEY; { 50} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSETICON; { 128} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSETREDRAW; { 11} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSETTEXT; { 12} BEGIN Msg.Result := 0; END;

PROCEDURE   TWindowsObject.WMSHOWWINDOW; { 24}
BEGIN
   Msg.Result := 0;
   IF ( Msg.WParam = 0 ) { hiding }
   THEN BEGIN
      IF Assigned ( OnHide ) THEN OnHide ( SelfPtr, Msg );
   END
   ELSE IF ( Msg.WParam = 1 ) { showing}
   THEN BEGIN
      IF Assigned ( OnShow ) THEN OnShow ( SelfPtr, Msg );
   END;
END;

PROCEDURE   TWindowsObject.WMSIZECLIPBOARD; { 779} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSIZING; { 532} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSPOOLERSTATUS; { 42} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSTYLECHANGED; { 125} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSTYLECHANGING; { 124} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSCHAR; { 262} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSCOLORCHANGE; { 21} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSCOMMAND; { 274} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSDEADCHAR; { 263} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSKEYDOWN; { 260} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMSYSKEYUP; { 261} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMTCARD; { 82} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMTIMECHANGE; { 30} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMUNDO; { 772} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMUSER; { 1024} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMUSERCHANGED; { 84} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMVKEYTOITEM; { 46} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMVSCROLLCLIPBOARD; { 778} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMWINDOWPOSCHANGED; { 71} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMWINDOWPOSCHANGING; { 70} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMWININICHANGE; { 26} BEGIN Msg.Result := 0; END;
PROCEDURE   TWindowsObject.WMKEYLAST; { 264} BEGIN Msg.Result := 0; END;
{- automated ends -}

{*************************************}
{*************************************}
CONSTRUCTOR TWindow.Init;
BEGIN
   Inherited Init ( Owner );
   SaveWindowState := False;
   RestoreWindowState := False;
   Name := 'TWindow';
   IF (aTitle <> Nil)
   THEN BEGIN
      pChar2String ( aTitle, Caption );
      Attr.Title := StrNew ( aTitle );
   END;
   IF IsMainWindow THEN OldWnd := GetActiveWindow;
END;

CONSTRUCTOR TWindow.InitResource;
Begin
   Inherited InitResource ( Owner, ResourceID );
   Name := 'TWindow';
End;

FUNCTION  TWindow.GetClassName;
BEGIN
   Result := 'TWindow';
END;

PROCEDURE TWindow.Show;
BEGIN
   Inherited Show ( ShowCmd );
   IF  ( Not Assigned ( Application ) )
   AND ( Not Assigned ( Parent ) ) THEN MessageLoop;
END;

PROCEDURE   TWindow.SetupWindow;
Begin
   Inherited SetupWindow;
   RestoreWindow;
End;

PROCEDURE   TWindow.SaveWindow;
Var
Ini : TIniFile;
i : Integer;
BEGIN
  If ( SaveWindowState ) and ( IsMainWindow )
  then begin
     i := 0; // normal state
     If IsIconic ( HWindow ) then i := -1 // minimized
     else
     If IsZoomed ( HWindow ) then i := 1; // maximized

     Ini.Create ( Application^.IniFile );
     With Ini
     do begin
        if i = 0 // normal
        then begin
           WriteString ('mainwindow', 'left', IntToStr (Left));
           WriteString ('mainwindow', 'width', IntToStr (Width));
           WriteString ('mainwindow', 'top', IntToStr (Top));
           WriteString ('mainwindow', 'height', IntToStr (Height));
        end;

        WriteString ('mainwindow', 'windowstate', IntToStr (i));

        Done;
     end;
  end;
END;

PROCEDURE   TWindow.RestoreWindow;
Var
Ini : TIniFile;
i : WinInteger;
BEGIN

  If ( RestoreWindowState ) and ( IsMainWindow )
  and ( FileExists ( Application^.IniFile ) )
  then begin
     Ini.Create ( Application^.IniFile );

     With Ini
     do begin
        Attr.x := ReadInteger ('mainwindow', 'left', Attr.x);
        Attr.w := ReadInteger ('mainwindow', 'width', Attr.w);
        Attr.y := ReadInteger ('mainwindow', 'top', Attr.y);
        Attr.h := ReadInteger ('mainwindow', 'height', Attr.h);
        i := ReadInteger ('mainwindow', 'windowstate', 0);

        Done;

        If i < 1 // not maximized
        then begin
           SetWindow ( Attr.X, Attr.Y, Attr.W, Attr.H );
        end;

        Case i of
           0 : CmdShow := sw_ShowNormal;
           1 : CmdShow := sw_ShowMaximized;
          -1 : CmdShow := sw_ShowMinimized;
        end; // case
     end; // with
  end; // if
END;

PROCEDURE   TWindow.WmClose;
BEGIN
  SaveWindow;

  IF Assigned ( OnClose )
  THEN OnClose ( SelfPtr, Msg )
  ELSE BEGIN
    Msg.Result := 1;
    IF Not Assigned ( Parent )
    THEN BEGIN
      IF IsMainWindow
      THEN BEGIN
         SetActiveWindow ( OldWnd );
         SetFocus ( OldWnd );
      END;
      Halt ( 0 );
    END
    ELSE Inherited WmClose ( Msg );
  END;
END;

PROCEDURE TWindow.MessageLoop;
VAR
M : Tmsg;
BEGIN
  WHILE ( 0 = 0 ) DO
  IF PeekMessage ( M, 0, 0, 0, pm_Remove )
  THEN BEGIN
      IF ( M.Message = wm_Quit )
      OR ( Not IsWindow ( Handle ) )
      OR ( Handle = 0 )
      Then Break
      ELSE
      IF ( not IsDialogMessage (0, M ) )
      THEN BEGIN
         TranslateMessage ( M );
         DispatchMessage ( M );
      END;
  END
END;
{*************************************}
CONSTRUCTOR TBitmapWindow.Init;
BEGIN
   Inherited Init ( Owner, aTitle );
   Bitmap := 0;
   BitmapWidth := 0;
   BitmapHeight := 0;
   BitmapLeft := 0;
   BitmapTop := 0;
   Stretched := False;
   LoadBitmapFromResource := True;
   BitmapFile := '';
   BitmapResource := '';
   TextAlignMent := AlignCenter;
END;

PROCEDURE   TBitmapWindow.DrawButton ( VAR Msg : TMessage );
VAR
  pControlWnd : pBitmapWindow;
  MemDC : hDC;
  NewDC : HDC;
  OldBMP : hBitmap;
  OldBrush : hBrush;
  OldPen : hPen;
  R : TRect;
  TextCtl : Cardinal;
  P : PDrawItemStruct;
BEGIN
  P := PDrawItemStruct ( Msg.lParam );
  NewDC := P^.hDC;
  With P^ do
    IF CtlType = ODT_BUTTON
    THEN BEGIN
      pControlWnd := pBitmapWindow (SelfPtr);
      TextCtl := DT_CENTER or DT_VCENTER;

      MemDC := CreateCompatibleDC ( NewDC );
      OldBMP := SelectObject ( MemDC, pControlWnd^.Bitmap );
      WITH pControlWnd^ DO SetRect ( {$ifdef FPC}@{$endif}R, 0, 0, Attr.W, Attr.H );
      IF ( ItemState AND ODS_Disabled ) <> 0
      THEN BEGIN
        OldPen := SelectObject ( NewDC, CreatePen ( PS_SOLID, 1, $00808080 ) );
        OldBrush := SelectObject ( NewDC, GetStockObject ( ltGray_Brush ) );
        RectAngle ( NewDC, 0, 0, pControlWnd^.Attr.W, pControlWnd^.Attr.H );
        SelectObject ( NewDC, OldBrush );
        DeleteObject ( SelectObject ( NewDC, OldPen ) );
      END
      ELSE BEGIN
        IF ( ItemState AND ODS_Selected ) <> 0
        THEN BEGIN
          WITH pControlWnd^
          DO BEGIN
            OldPen := SelectObject ( NewDC, getSTockObject ( Black_Pen ) );
            //Oldbrush := SelectObject ( NewDC, getStockObject ( ltGray_brush ) );
            Oldbrush := SelectObject ( NewDC, GetSysColorBrush ( COLOR_BTNFACE ) );
            Rectangle ( NewDC, 0, 0, Attr.W, Attr.H );

            //StretchBlt (NewDC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0,0,
            //BitmapWidth+3, BitmapHeight+3, srcCopy);
            BitBlt ( NewDC, 5, 5, BitmapWidth + 4, BitmapHeight + 4, MemDC, 0, 0, SrcCopy );

            FrameRect ( NewDC, R, GetStockObject ( Black_brush ) );
            SelectObject ( NewDC, GetStockObject ( White_Pen ) );
            MoveToEx ( NewDC, 1, Attr.H - 2, Nil );
            LineTo ( NewDC, Attr.W - 2, Attr.H - 2 );
            LineTo ( NewDC, Attr.w - 2, 1 );
            SelectObject ( NewDC, CreatePen ( ps_solid, 1, $00808080 ) );
            LineTo ( NewDC, 1, 1 );
            LineTo ( NewDC, 1, Attr.H - 2 );
            Case TextAlignment of
                 AlignLeft : TextCtl := DT_Left;
                 AlignCenter : TextCtl := DT_CENTER or DT_VCENTER;
                 AlignRight : TextCtl := DT_Right;
            end;

            TextCtl := TextCtl OR DT_WordBreak OR DT_ExpandTabs;
            SetRect ( {$ifdef FPC}@{$endif}R, BitmapWidth + 5, 8, Attr.W - 5, Attr.H - 8 );
            SetBkMode ( NewDC, Transparent );
            DrawText ( NewDC, sChar (Caption), - 1, R, TextCtl );
            SelectObject ( NewDC, OldBrush );
            DeleteObject ( SelectObject ( NewDC, OldPen ) );
          END;
        END
        ELSE BEGIN
          WITH pControlWnd^
          DO BEGIN
            OldPen := SelectObject ( NewDC, getStockObject ( Black_Pen ) );
            //Oldbrush := SelectObject ( NewDC, getStockObject ( ltGray_brush ) );
            Oldbrush := SelectObject ( NewDC, GetSysColorBrush ( COLOR_BTNFACE ) );
            Rectangle ( NewDC, 0, 0, Attr.W, Attr.H );

            //StretchBlt (NewDC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0,0,
            //BitmapWidth-3, BitmapHeight-3, srcCopy);

            BitBlt ( NewDC, 3, 3, BitmapWidth + 3, BitmapHeight + 3, MemDC, 0, 0, SrcCopy );

            FrameRect ( NewDC, R, GetStockObject ( Black_brush ) );
            SelectObject ( NewDC, getStockObject ( White_Pen ) );
            MoveToEx ( NewDC, 1, Attr.H - 2, Nil );
            LineTo ( NewDC, 1, 1 );
            LineTo ( NewDC, Attr.w - 2, 1 );
            SelectObject ( NewDC, CreatePen ( ps_solid, 1, $00808080 ) );
            LineTo ( NewDC, Attr.w - 2, Attr.H - 2 );
            LineTo ( NewDC, 1, Attr.H - 2 );
            Case TextAlignment of
                 AlignLeft : TextCtl := DT_Left;
                 AlignCenter : TextCtl := DT_CENTER or DT_VCENTER;
                 AlignRight : TextCtl := DT_Right;
            end;

            TextCtl := TextCtl OR DT_WordBreak OR DT_ExpandTabs;

            SetRect ( {$ifdef FPC}@{$endif}R, BitmapWidth + 3, 6, Attr.W - 5, Attr.H - 8 );
            SetBkMode ( NewDC, Transparent );
            DrawText ( NewDC, sChar (Caption), - 1, R, TextCtl );
            SelectObject ( NewDC, OldBrush );
            DeleteObject ( SelectObject ( NewDC, OldPen ) );
          END;
      END;
    END;
    IF ( ItemState AND ODS_FOCUS ) <> 0
    THEN BEGIN
        WITH pControlWnd^
           DO SetRect ( {$ifdef FPC}@{$endif}R, 3, 3, Attr.W - 3, Attr.H - 3 );
        DrawFocusRect ( NewDC, R );
    END;
    SelectObject ( MemDC, OldBMP );
    DeleteDC ( MemDC );
  END;
END;

PROCEDURE TBitmapWindow.WMEraseBackGround;
Begin
   Inherited WMEraseBackGround (Msg);
   If Bitmap <> 0
   then begin
      If Stretched then Msg.Result := 1; // to stop flashes/flickers
   end;
End;

Procedure  TBitmapWindow.SetupWindow;
Begin
   Inherited SetupWindow;
   If Bitmap = 0
   then begin
      If (LoadBitmapFromResource)
      then begin
         If (BitmapResource <> '') then LoadBitmapResource (BitmapResource);
      end
      else begin
         If (BitmapFile <> '') then LoadBitmapFile (BitmapFile);
      end;
   end;
End;

Function TBitmapWindow.LoadBitmapResource (Const ResName : String) : hBitmap;
Begin
  Result := LoadBitmap (hInstance, {MakeIntResource} (sChar (ResName)));
  If Result <> 0
  then begin
     Bitmap := Result;
     GetBitmapInfo (Bitmap, BitmapWidth, BitmapHeight);
  end;
End;

Function TBitmapWindow.LoadBitmapFile (Const FileName : String) : hBitmap;
Begin
  Result := LoadBitmapFromFile ( FileName, Handle, BitmapWidth, BitmapHeight );
  If Result <> 0
  then begin
     Bitmap := Result;
  end;
End;

PROCEDURE TBitmapWindow.WmClose;
BEGIN
   IF Bitmap <> 0 THEN DeleteObject ( Bitmap );
   Inherited WmClose ( Msg );
END;

PROCEDURE TBitmapWindow.PaintClientArea ( ForeClr, BackClr : WinInteger );
Begin
   If (Bitmap = 0) or ((Bitmap <> 0) and (NOT Stretched))
     then Inherited PaintClientArea ( ForeClr, BackClr );

   DrawBitmap;
End;

PROCEDURE  TBitmapWindow.DrawBitmap;
Begin
 If Bitmap <> 0
 then begin
    //If Stretched then RepaintWindow;
    PaintBitmap ( Canvas, Bitmap, BitmapLeft, BitmapTop, BitmapWidth, BitmapHeight, Handle, Stretched );
 end;
End;

PROCEDURE TBitmapWindow.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
   Inherited Paint (aDC, Info);
   DrawBitmap;
END;

{*************************************}
CONSTRUCTOR TApplication.Init;
BEGIN
   Inherited Init ( NIL );
   KBHandlerWnd := Nil;
   MainWindow := Nil;
   IF ( aName <> Nil ) AND ( Strlen ( aName ) > 0 )
     THEN pChar2String ( aName, Name )
       ELSE Name := 'TApplication';
   Handle := _hInstance;
   ExeName := RunningExe;//ParamStr ( 0 );
   Title   := ExeName;
   ExeDir  := JustPathName ( ExeName );
   ExePath := AddBackSlash ( ExeDir );
   HelpFile := ForceExtension ( ExeName, 'hlp' );
   IniFile := ForceExtension ( ExeName, 'ini' );
   Application := @Self;
   Status := 0;
   hAccTable := 0;
   Terminated := False;
   SleepInterval := -1; // default to no time-yields

   // get operating system information
   OSInfo.dwOSVersionInfoSize := Sizeof ( TOSVERSIONINFO );
   GetVersionEx ( OSInfo );
END;

PROCEDURE TApplication.MessageLoop;
VAR
M : Tmsg;
BEGIN
  WHILE ( 0 = 0 )
  DO BEGIN
    IF PeekMessage ( M, 0, 0, 0, pm_Remove )
    THEN BEGIN
      IF ( M.Message = wm_Quit ) THEN Break
      ELSE
      IF ( not ProcessAppMsg ( M ) )
      THEN BEGIN
         TranslateMessage ( M );
         DispatchMessage ( M );
      END;
    END
    ELSE IF IdleAction THEN WaitMessage;
    // If we want to yield some time slices, then
    // we must set SleepInterval to 0 or higher (don't set it more than 1 )
    IF SleepInterval >= 0 THEN Sleep ( SleepInterval );
  END;
END;

PROCEDURE TApplication.Run;
BEGIN
   InitMainWindow;
   MainWindow := MakeWindow ( MainWindow );
   IF Active
   THEN BEGIN
      Handle := MainWindow^.Handle;
      Title := StrPas ( MainWindow^.Attr.Title );
      Status := 0;
      MainWindow^.Show ( CmdShow );
      MessageLoop;
   END;
END;

PROCEDURE TApplication.Terminate;
BEGIN
   Terminated := True;
   IF IsWindow ( MainWindow^.Handle ) THEN MainWindow^.CloseMe;
   Halt ( 0 );
END;

PROCEDURE TApplication.ProcessMessages;
VAR
  Msg : TMsg;
BEGIN
  IF PeekMessage ( Msg, 0, 0, 0, pm_Remove )
  THEN BEGIN
    IF ( Msg.Message = wm_Quit )
    THEN BEGIN
      Terminated := True;
      PostQuitMessage ( Msg.wParam ); { repost wm_Quit message }
      exit;
    END ELSE
    IF ( NOT Application^.ProcessAppMsg ( Msg ) )
    THEN BEGIN
       TranslateMessage ( Msg );
       DispatchMessage ( Msg )
    END;
  END;
END;

FUNCTION    TApplication.MakeWindow;
BEGIN
   Result := NIL;
   IF ( ValidWindow ( anObj ) <> NIL )
   THEN IF NOT anObj^.CreateWnd
   THEN BEGIN
     Status := - 1;
     Error ( anObj^.Status );
     Dispose ( anObj, Done );
   END
   ELSE BEGIN
       Result := anObj;
   END;
END;

PROCEDURE TApplication.ShowException;
BEGIN
END;

FUNCTION TApplication.Active;
BEGIN
   Result := ( Assigned ( MainWindow ) ) AND ( IsWindow ( MainWindow^.Handle ) );
END;

PROCEDURE TApplication.InitMainWindow;
BEGIN
  MainWindow := New ( pWindow, Init ( NIL, NIL ) );
END;

PROCEDURE TApplication.InitApplication;
BEGIN
END;

FUNCTION    TApplication.IdleAction;
BEGIN
   Result := False;
END;

PROCEDURE TApplication.SetKBHandler;
BEGIN
   KBHandlerWnd := anObj;
END;

FUNCTION    TApplication.ProcessDlgMsg;
BEGIN
  IF ( Assigned ( KBHandlerWnd ) ) AND ( KBHandlerWnd^.Handle <> 0 )
  THEN Result := IsDialogMessage ( KBHandlerWnd^.Handle, Msg )
  ELSE Result := False;
END;

FUNCTION    TApplication.ProcessAccels;
BEGIN
   Result := ( ( hAccTable <> 0 ) AND ( TranslateAccelerator ( MainWindow^.Handle, hAccTable, Msg ) <> 0 ) );
END;

FUNCTION    TApplication.ProcessMDIAccels;
BEGIN
   Result := False;
END;

FUNCTION    TApplication.ProcessAppMsg;
BEGIN
  Result := ( ProcessDlgMsg ( Msg ) OR ProcessMDIAccels ( Msg ) OR ProcessAccels ( Msg ) );
END;

FUNCTION    TApplication.ValidWindow;
BEGIN
   Result := NIL;
   IF  ( Assigned ( anObj ) ) AND ( anObj^.Status >= 0 )
   THEN Result := anObj;
END;

PROCEDURE TApplication.Error;
BEGIN
END;

FUNCTION  TApplication.CanClose;
BEGIN
   Result := MainWindow^.CanClose;
END;

{*************************************}
FUNCTION    InstanceFromHandle ( Handle : hWnd ) : pWindowsObject;
VAR
i : LongWord;
p : pWindowsObject;
BEGIN
   Result := NIL;
   IF ( Handle = 0 ) OR ( NOT IsWindow ( Handle ) ) THEN Exit;
   FOR i := 0 TO Pred ( ObjectList^.Count )
   DO BEGIN
      p := pWindowsObject ( ObjectList^.At ( i ) );
      IF Assigned ( p )
      THEN BEGIN
          IF ( Handle = p^.Handle )
          THEN BEGIN
              Result := p;
              Exit;
          END;
      END;
   END;
END;

{*************************************}
FUNCTION    ChildFromSelfID ( Parent : pWindowsObject; ID : Word64 ) : pWindowsObject;
VAR
i : LongWord;
p : pWindowsObject;
BEGIN
 Result := NIL;
 WITH Parent^
 DO BEGIN
   IF HasChildren THEN
   FOR i := 0 TO Pred ( Children^.Count )
   DO BEGIN
      p := pWindowsObject ( Children^.At ( i ) );
      IF Assigned ( p )
      THEN BEGIN
          IF ( ID = p^.SelfID )
          THEN BEGIN
              Result := p;
              Exit;
          END;
      END;
   END;
 END;
END;

FUNCTION    InstanceFromSelfID ( ID : Word64 ) : pWindowsObject;
VAR
i : LongWord;
p : pWindowsObject;
BEGIN
   Result := NIL;
   FOR i := 0 TO Pred ( ObjectList^.Count )
   DO BEGIN
      p := pWindowsObject ( ObjectList^.At ( i ) );
      IF Assigned ( p )
      THEN BEGIN
          IF ( {Pred} ( ID ) = p^.SelfID )
          THEN BEGIN
              Result := p;
              Exit;
          END;
      END;
   END;
END;

{*************************************}
CONSTRUCTOR TDialogWindow.Init;
BEGIN
    INHERITED Init ( Owner, aTitle );
    Modeless := True;
    RetValue := id_Cancel;
    BorderStyle := bsDialog;
    Attr.Style  := ws_Border OR WS_SysMenu OR DS_CONTROL;
    Attr.ExStyle :=  WS_EX_CONTROLPARENT OR WS_EX_WINDOWEDGE;
END;

CONSTRUCTOR TDialogWindow.InitParams ( Owner : pWindowsObject; CONST aTitle : pChar; x, y, w, h : WinInteger );
BEGIN
    TDialogWindow.Init ( Owner, Atitle );
    Attr.x := x;
    Attr.y := y;
    Attr.w := w;
    Attr.h := h;
END;

FUNCTION TDialogWindow.Execute;
BEGIN
  IF NOT Modeless
     THEN IF Assigned ( Parent )
         THEN Parent^.Disable;
  Show ( Show_Code );
  MessageLoop;
  Result := RetValue;
END;

PROCEDURE   TDialogWindow.WmClose;
BEGIN
   IF NOT Modeless THEN IF Assigned ( Parent ) THEN Parent^.Enable;
   DestroyWindow ( Handle );
   INHERITED WmClose ( Msg );
END;

PROCEDURE   TDialogWindow.Ok ( VAR Msg : TMessage );
BEGIN
   RetValue := id_Ok;
   WmClose ( Msg );
END;

PROCEDURE   TDialogWindow.Cancel ( VAR Msg : TMessage );
BEGIN
   RetValue := id_Cancel;
   WmClose ( Msg );
END;

FUNCTION TDialogWindow.ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;
BEGIN
   Result := 1;
   CASE ID OF
     Id_Ok : Ok ( Msg );
     ID_Cancel : Cancel ( Msg );
     ELSE
      Result := INHERITED ProcessCommands ( Msg, Id );
   END; {case}
END;

{*************************************}
CONSTRUCTOR TTimer.Init;
BEGIN
   INHERITED Init ( Owner );
   Name := 'TTimer';
   Active := False;
   Enabled := False;
   Interval := aTimeOut;
   ID := AnID;
   Parent := Owner;
END;

DESTRUCTOR TTimer.Done;
BEGIN
   IF Active THEN KillTimer ( ParentHandle, ID );
   Active := False;
   INHERITED Done;
END;

PROCEDURE TTimer.Show ( ShowCmd : Integer );
BEGIN
END;

FUNCTION TTimer.CreateWnd : Boolean;
BEGIN
   Result := False;
   IF Assigned ( Parent )
   THEN BEGIN
      IF ( IsWindow ( Parent^.Handle ) )
      THEN BEGIN
         Active := True;
         Enabled := True;
         ParentHandle := Parent^.Handle;
         Handle := SetTimer ( ParentHandle, ID, Interval, NIL );
         Result := True;
      END;
   END;
END;

{*************************************}
CONSTRUCTOR THintWindow.Init ( Owner : pWindowsObject; CONST aCaption : pChar );
VAR
b : Byte;
i : integer;
BEGIN
    INHERITED Init ( Owner );
    pChar2String ( aCaption, Caption );
    HintDelay := 2000;
    Showing := False;
    i := Length ( Caption );
    IF i > 20 THEN b := 7 ELSE b := 8;
    WITH Attr
    DO BEGIN
       H := 20;
       W := i * b;
       style := WS_POPUPWINDOW OR ws_border OR WS_DISABLED;
    END;
    Name := 'THintWindow';
END;

DESTRUCTOR THintWindow.Done;
BEGIN
  Showing := False;
  IF IsCreated
  THEN BEGIN
     IsCreated := False;
     INHERITED Done;
  END;
END;

PROCEDURE THintWindow.RepaintWindow;
BEGIN
   InvalidateRect ( Handle, @ClientRect, False );
   UpdateWindow ( Handle );
END;

PROCEDURE  THintWindow.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
   INHERITED Paint ( aDC, Info );
   PaintClientArea ( ColorLightYellow, ColorLightYellow );
   WriteText ( @Font, 1, 1, ColorBlack, ColorLightYellow, Caption );
END;

PROCEDURE THintWindow.SetupWindow;
BEGIN
  INHERITED SetupWindow;
  FillRect ( Canvas, WindowRect, ColorYellow );
  SetWindowPos ( Handle, 0, Parent^.Left, Parent^.Bottom, Width, Height,
               swp_NoSize OR SWP_NOACTIVATE );
END;

PROCEDURE THintWindow.DisplaySelf;
BEGIN
  Show ( SW_SHOWNOACTIVATE );
  Showing := True;
  Delay ( HintDelay );
  // Done;
END;
{*************************************}
PROCEDURE Breathe;
VAR
Msg : TMsg;
BEGIN
   IF Assigned ( Application )
   THEN Application^.ProcessMessages
    ELSE BEGIN
      WHILE PeekMessage ( Msg, 0, 0, 0, pm_Remove )
      DO BEGIN
         IF Msg.Message = wm_Quit
         THEN BEGIN
           PostQuitMessage ( msg.wParam );
           Exit;
         END;

         IF ( NOT IsDialogMessage ( 0, Msg ) )
         THEN BEGIN
           TranslateMessage ( Msg );
           DispatchMessage ( Msg )
         END;
      END;
    END;
END;

PROCEDURE Delay ( msecs : DWord );
VAR
FirstTickCount : DWord;
BEGIN
  FirstTickCount := GetTickCount;
  REPEAT
     Breathe;
  UNTIL GetTickCount - FirstTickCount >= msecs;
END;


{*************************************}
END.

