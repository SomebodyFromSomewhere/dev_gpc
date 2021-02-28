{
***************************************************************************
*                 instdemo.pas
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
*  Last modified: 29 May 2004
*  Version: 1.02
*  Licence: Shareware
*
***************************************************************************
}
PROGRAM instdemo;
{$X+}
{#apptype gui}

{$i cwindows.inc}

USES
{$ifdef __GPC__}
//System,
objmingw;
{$else}
ShlObj,
Messages,
Windows,
SysUtils,
cWindows,
cDialogs,
CustDlgs,
Inifiles,
genutils,
cClasses;
{$endif}

{$R instdemo.res}

CONST
MaxButtons = 1;
id_StartBtn = 500;
id_ExitBtn = 501;

VAR
StretchBitmap,
InstallIcons : Boolean;
BitmapName,
TargetDir,
IconsFolder,
WelcomeMessage,
CopyRightMessage : String [255];
ProgramTitle : TString;
Reg : TIniFile;

Banner : RECORD
  Message : TString;
  FontName : TString;
  Top,
  Left,
  FontSize : Integer;
  FontColor,
  FontShadow,
  FontBackground : Integer;
  UseShadow : Boolean;
END;

// various objects that we need
TextDialog : TMemoDialog;
IconList,
FileList,
FileNames,
FileDests : TStrings;
GroupsDialog : TListBoxDialog;
Finished : Boolean;

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TBitmapWindow ) // we want TO display a bitmap
   LocalFont : TFont;
   FCol, BCol : Integer;
   HiddenButton : TButton;
   BitButton : TBitBtn;
   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow; VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
   PROCEDURE   Paint ( aDC : HDC; VAR Info : TPaintStruct );VIRTUAL;
   PROCEDURE   WMEraseBackGround ( VAR Msg : TMessage ); VIRTUAL;

   // OVERRIDE the writetext method TO use shadow
   PROCEDURE   WriteText ( FontP : pFont; x, y, tCol, tBack : WinInteger; CONST aString : String ); VIRTUAL;

   PROCEDURE StartInstall;
   PROCEDURE TerminateInstall;
END;

TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

FUNCTION BrowseCallbackProc ( WND : hwnd; uMsg : Integer; lParam : integer; lpData : integer ) : integer; STDCALL;
BEGIN
 IF uMsg = BFFM_INITIALIZED
 THEN BEGIN
    SetWindowText ( Wnd, sChar ( ProgramTitle ) );
    CentreChildWindow ( GetParentWindow ( Wnd ), Wnd );
    {SetDlgItemText ( Wnd, id_OK, '&Ok' );
    SetDlgItemText ( Wnd, id_Cancel, 'C&ancel' );}
 END;
 Result := 0;
END;

PROCEDURE  TNewWindow.WMEraseBackGround ( VAR Msg : TMessage );
BEGIN
    INHERITED WMEraseBackGround ( Msg );
    Msg.Result := 1;
END;

PROCEDURE TNewWindow.TerminateInstall;
BEGIN
   IF NOT Finished
   THEN BEGIN
       IF MessageBox
       ( Handle,
       'This installation will now end. Should I terminate it?',
       'Attention', MB_ICONEXCLAMATION + MB_YesNoCancel ) = Id_Yes THEN CloseMe;
   END;
END;

// event handler FOR checkbox
PROCEDURE CheckBoxClick ( Sender : pWindowsObject; VAR Msg : TMessage );
BEGIN
   WITH pCheckBox ( Sender ) ^
   DO BEGIN
       IF Checked THEN InstallIcons := False
        ELSE InstallIcons := True;
   END;
END;

Procedure UPdateDest (Const s: String; Var t : TStrings);
Var
s1 : TString;
i : Word;
begin
  For i := 0 to Pred ( T.Count ) do begin
      s1 := T.Strings ( i );
      ReplaceString ( '$dest', s, s1 );
      T.Replace ( i, s1 );
  end;
end;

PROCEDURE TNewWindow.StartInstall;
VAR
s : String [255];
Check : TCheckBox;
t : TFarProc;
Temp,
Folders : TStrings;
BEGIN

  // get the list OF all start menu folders
  Folders.Create;
  Temp.Create;

  IF GetFolders ( GetShellFolderName ( 'Programs' ), Folders ) > 0
  THEN BEGIN
  END;
  // insert our own icons folder at the top
  Folders.InsertP ( 0, IconsFolder );

  // welcome message
  IF ( WelcomeMessage <> '' ) AND ( FileExists ( WelcomeMessage ) )
  THEN BEGIN
     TextDialog.InitWithFileName ( SelfPtr, 'Welcome', WelcomeMessage );
     WITH TextDialog
     DO BEGIN
        ReadOnly := True;
        StrCopy ( OkBtnCaption, 'Pr&oceed' );
        StrCopy ( CancelBtnCaption, '&Abort' );
        IF Execute <> id_OK
        THEN BEGIN
           Done;
           TerminateInstall;
        END ELSE Done;
     END;
  END;

  // copyright message
  IF ( CopyRightMessage <> '' ) AND ( FileExists ( CopyRightMessage ) )
  THEN BEGIN
     TextDialog.InitWithFileName ( SelfPtr, 'Copyright', CopyRightMessage );
     WITH TextDialog
     DO BEGIN
        ReadOnly := True;
        StrCopy ( OkBtnCaption, 'I d&o agree' );
        StrCopy ( CancelBtnCaption, 'I do NOT &agree' );
        IF Execute <> id_OK
        THEN BEGIN
           Done;
           TerminateInstall;
        END ELSE Done;
     END;
  END;

  // get target directory
  T := SelectFolderBrowseCallbackProc;
  SelectFolderBrowseCallbackProc := @BrowseCallbackProc;
  s := '';
  WHILE s = ''
  DO BEGIN
    s := SelectFolder ( Handle, 'Select folder for installation:' + #0);
    IF s = '' THEN TerminateInstall;
    Temp.AddStrings ( FileList );
    UpdateDest ( s, Temp );
  END;

  SelectFolderBrowseCallbackProc := T;
  TarGetDir := s;

  Showmessage ( 'Target directory=' + TargetDir );

  // select folder FOR start menu icons
  GroupsDialog.Init ( SelfPtr, sChar ( ProgramTitle ), True );
  WITH GroupsDialog
  DO BEGIN
     Prompt := 'Choose the folder for start menu icons';

     // add the list OF folders TO its list OF items
     Items.AddStrings ( Folders );

     // create a checkbox on the dialog, TO see IF we want TO
     // install icons
     Check.Init ( GroupsDialog.SelfPtr, 0, 'Do not create icons', 30,
            GroupsDialog.StartDimensions.Bottom - 65,
            200, 25 );
     Check.OnClick := CheckBoxClick;

     // execute the dialog
     IF Execute = iD_OK
        THEN IconsFolder := Selected
             ELSE IconsFolder := '';

     Done;
  END;

  IF NOT InstallIcons THEN IconsFolder := '';
  IF IconsFolder = '' THEN InstallIcons := False;
  Showmessage ( 'Folder for icons=' + IconsFolder );

  // display the choices, AND exit without doing anything
  GroupsDialog.Init ( SelfPtr, sChar ( ProgramTitle ), False );
  WITH GroupsDialog
  DO BEGIN
     Prompt := 'You are installing these files to these directories';
     Items.AddStrings ( Temp );
     Execute;
     Done;
  END;

  // cleanup
  Folders.Done;
  Temp.Done;
END;

FUNCTION TNewWindow.ProcessCommands;
BEGIN
  Result := 0;
  CASE ID OF
      id_ExitBtn : CloseMe;
      id_StartBtn : StartInstall;
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
   SetCaption ( sChar ( ProgramTitle ) );

   WITH sMenu
   DO BEGIN
       Init ( SelfPtr );
       i := AddSubMenu ( '&File', 0 );
         AddMenuItem ( i, '&Start ...', id_StartBtn, 0 );
         AddMenuItem ( i, 'E&xit', CM_FileExit,
                                  LoadBitmap ( hInstance, 'exitbmp' ) );
   END;

  WITH LocalFont.lFont
  DO BEGIN
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

  // force our window TO show itself right now
  Show ( CmdShow );

  // THEN make the hidden button TO click itself
  HiddenButton.Click;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
  INHERITED Init ( Owner, aTitle );
  CmdShow := sw_Maximize;
  Attr.X := 1;
  Attr.Y := 1;
  Attr.W := 550;
  Attr.H := 400;
  FCol := ColorRed;
  BCol := 0;
  HiddenButton.Init ( SelfPtr, id_StartBtn, 'Start', 4000, 4000, 1, 1 );
  BitButton.Init ( SelfPtr, id_ExitBtn, 'Exit', 'exitbmp', 2, 200, 100, 30 );

  WITH LocalFont
  DO BEGIN
     Strpcopy ( Name, Banner.FontName );
     Size := Banner.FontSize;
     Color := Banner.FontColor;
     BackGround := Banner.FontBackGround;
     TransparentBackground := Banner.UseShadow;
  END;

  // stuff FOR our wallpaper bitmap
  BitmapLeft := 5;
  BitmapTop := 80;
  Stretched := StretchBitmap;
  IF ( BitmapName <> '' ) AND ( FileExists ( BitmapName ) )
  THEN BEGIN
     BitmapFile := BitmapName;
     LoadBitmapFromResource := False;
     BitmapResource := '';
  END
  ELSE BitmapResource := 'install';
END;

PROCEDURE TNewWindow.WriteText ( FontP : pFont; x, y, tCol, tBack : WinInteger; CONST aString : String );
VAR
OldFont : HFont;
BEGIN
   IF ( Banner.UseShadow ) AND ( Banner.FontShadow <> - 1 )
   THEN BEGIN
        OldFont := 0;
        IF ( Assigned ( FontP ) ) AND ( FontP^.Handle <> 0 )
        THEN BEGIN
             IF FontP^.TransparentBackground
                THEN SetBkMode ( WindowDC, Transparent );
             OldFont := SelectObject ( WindowDC, FontP^.Handle );
        END;
        SetTextColor ( WindowDC, Banner.FontShadow );
        TextOut ( WindowDC, x + 2, y + 2, sChar ( aString ), Length ( aString ) );
        IF OldFont <> 0 THEN DeleteObject ( OldFont );
   END;

   INHERITED WriteText ( FontP, x, y, tCol, tBack, aString );
END;

PROCEDURE  TNewWindow.Paint ( aDC : HDC; VAR Info : TPaintStruct );
BEGIN
   INHERITED Paint ( aDC, Info );
   DeleteObject ( LocalFont.Handle );
   LocalFont.Handle := CreateFontIndirect ( {$ifdef FPC}@{$endif}LocalFont.lFont );
   PaintClientArea ( FCol, ColorBlack );
   WriteText ( @LocalFont,
               Banner.Left,
               Banner.Top,
               LocalFont.Color,
               LocalFont.Background,
               Banner.Message );

   BitButton.GotoXY ( 1, Height - ( BitButton.Height ) * 3 );
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, sChar ( ProgramTitle ) ) );
END;

VAR
MyApp : TNewApplication;
s, s1 : String [255];
BEGIN
 Finished := False;
 ProgramTitle := 'Object Mingw Installer';
 IconsFolder := 'Object MingW';
 TargetDir := 'C:\Object MingW';
 InstallIcons := True;
 StretchBitmap := False;
 BitmapName := '';

 WITH Banner
 DO BEGIN
    Message := 'ObjectMingW Demo Installer';
    FontName := 'Times New Roman';
    FontSize := 30;
    FontColor := ColorCyan;
    FontBackground := ColorBlue;
    FontShadow := ColorBlue;
    UseShadow := True;
    Top := 1;
    Left := 1;
    WelcomeMessage := '';
    CopyRightMessage := '';
 END;

 WITH MyApp
 DO BEGIN
     Init ( sChar ( ProgramTitle ) );
     Reg.Create ( AddBackSlash ( Application^.Exedir ) + 'instdemo.ini' );

     // get stuff from inf FILE
     WITH Reg
     DO BEGIN

        // PROGRAM details
        s1 := 'Program';
        ProgramTitle := ReadString ( s1, 'ProgramTitle', ProgramTitle );
        WelcomeMessage := ReadString ( s1, 'Welcome', WelcomeMessage );
        CopyRightMessage := ReadString ( s1, 'Copyright', CopyRightMessage );

        s := ExtractFileDir ( WelcomeMessage );
        IF s [1] IN [' ', '.']
           THEN WelcomeMessage := AddBackSlash ( Application^.Exedir ) + WelcomeMessage;

        s := ExtractFileDir ( CopyRightMessage );
        IF s [1] IN [' ', '.']
           THEN CopyRightMessage := AddBackSlash ( Application^.Exedir ) + CopyRightMessage;

        // banner details
        s1 := 'Banner';
        WITH Banner
        DO BEGIN
           Message := ReadString ( s1, 'Banner.Message', Banner.Message );
           FontName := ReadString ( s1, 'Banner.FontName', Banner.FontName );
           FontSize := ReadInteger ( s1, 'Banner.FontSize', Banner.FontSize );
           FontColor := ReadInteger ( s1, 'Banner.FontColor', Banner.FontColor );
           FontBackground := ReadInteger ( s1, 'Banner.FontBackground', Banner.FontBackground );
           FontShadow := ReadInteger ( s1, 'Banner.FontShadow', Banner.FontShadow );
           UseShadow := ReadBool ( s1, 'Banner.UseShadow', Banner.UseShadow );
           Top := ReadInteger ( s1, 'Banner.Top', Banner.Top );
           Left := ReadInteger ( s1, 'Banner.Left', Banner.Left );
        END;

        // Bitmap
        s1 := 'Bitmap';
        StretchBitmap := ReadBool ( s1, 'Bitmap.Stretched', False );
        BitmapName := ReadString ( s1, 'Bitmap.FileName', '' );

        // directories
        s1 := 'Directories';
        TargetDir := ReadString ( s1, 'Target', TargetDir );
        IconsFolder := ReadString ( s1, 'IconFolder', IconsFolder );

        // Icons
        s1 := 'Icons';
        IconList.Create;
        ReadSectionValues ( s1, IconList );

        // Files
        s1 := 'Files';
        FileList.Create;
        FileNames.Create;
        FileDests.Create;
        ReadSectionValues ( s1, FileList ); // names + dest dir
        ReadSectionNames ( s1, FileNames ); // names only
        ReadSectionData ( s1, FileDests );  // dest dirs only
     END;

     // run the application
     Run;

     // cleanup
     FileDests.Done;
     FileNames.Done;
     FileList.Done;
     IconList.Done;

     // close
     Done;
  END;
END.

