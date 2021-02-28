{
***************************************************************************
*                 example7.pas
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
PROGRAM example7;
{#apptype gui}
{$X+}
USES
    Messages,
    Windows,
    Sysutils,
    cClasses,
    Registry,
    Regenv,
    cWindows,
    cDialogs;

TYPE
pNewWindow = ^TNewWindow;
TNewWindow = OBJECT ( TWindow )
   Memo : TMemo;
   sMenu    : TMenu;

   CONSTRUCTOR Init ( Owner : pWindowsObject; CONST aTitle : pChar );
   PROCEDURE   SetupWindow;VIRTUAL;
   FUNCTION    ProcessCommands ( VAR Msg : TMessage; ID : LongWord ) : WinInteger;VIRTUAL;
   PROCEDURE   WMSize ( VAR Msg : TMessage );VIRTUAL;
   PROCEDURE   WMHScroll ( VAR Msg : TMessage );VIRTUAL;
END;

FUNCTION  TNewWindow.ProcessCommands;
BEGIN
  Result := 1;
  CASE ID OF
    CM_HelpAbout  : ShowMessage
    ( 'Sample application showing environment variables read from the Registry.' );
  ELSE
    Result := INHERITED ProcessCommands ( Msg, ID );
  END;
END;

CONSTRUCTOR TNewWindow.Init;
BEGIN
   INHERITED Init ( Owner, aTitle );
   Attr.X := 1;
   Attr.Y := 1;
   Attr.W := 800;
   Attr.H := 600;
   Attr.Style := Attr.Style OR WS_VSCROLL OR WS_HSCROLL;
   Memo.Init ( SelfPtr, 0, '', 1, 1, Attr.W - 15, Attr.H - 50 );

   WITH Memo.Font
   DO BEGIN
       StrCopy ( Name, 'courier' );
       Size := 10;
   END;
   Memo.WordWrap := False;

END;

PROCEDURE TNewWindow.SetupWindow;
VAR
 i : hMenu;
 R : TRegIniFile;
 ts : TStrings;
 p : pChar;
BEGIN
   INHERITED SetupWindow;
   SetCaption ( 'Environments Variables' );

   WITH sMenu
   DO BEGIN
       Init ( @Self );
       i := AddSubMenu ( '&File  ', 0 );
         AddMenuItem ( i, 'E&xit', CM_FileExit, 0 );

       i := AddSubMenu ( '&Help  ', 0 );
         AddMenuItem ( i, '&About', CM_HelpAbout, 0 );
   END;
   GetMem ( p, 1024 * 32 );
   ts.Create;
   R.Init ( RegEnvironKey_User, KEY_ALL_ACCESS );
   WITH R DO BEGIN
        // current user environment
        IF ReadSectionValues ( RegEnvironKey_User, ts )
        THEN BEGIN
           Strcopy ( p, 'User Environment: '#13#10 );
           Strcat ( p, '-----------------'#13#10 );
           StrCat ( p, {$ifndef __GPC__}pChar{$endif} ( ts.Text ) );
           StrCat ( p, #13#10#13#10 );
        END;

        // system environment
        SetRootKey ( HKey_Local_Machine );
        IF ReadSectionValues ( RegEnvironKey_All, ts )
        THEN BEGIN
           Strcat ( p, 'System Environment:'#13#10 );
           Strcat ( p, '-------------------'#13#10 );
           StrCat ( p, {$ifndef __GPC__}pChar{$endif} ( ts.Text ) );
        END;
   END;
   Memo.SetText ( p );
   FreeMem ( p );
   ts.Done;
   R.Done;
END;

PROCEDURE  TNewWindow.WMSize;
VAR
t : TWindowAttr;
BEGIN
  INHERITED WMSize ( Msg );
  WITH T, ClientRect
  DO BEGIN
      X := Left;
      Y := Top;
      W := Right - Left;
      H := Bottom - Top;
  END;
  MoveWindow ( Memo.Handle, t.X, t.Y, t.W - 5, t.H, true );
END;

PROCEDURE    TNewWindow.WMHScroll;
VAR
i, j : integer;
BEGIN
    j := 1;
    i := GetScrollPos ( Handle, SB_Horz );
    CASE Msg.WParamLo OF

           SB_LINERIGHT, SB_PAGERIGHT :
           BEGIN
              i := Succ ( i );
              j := 1;
           END;

           SB_LINELEFT, SB_PAGELEFT :
           BEGIN
              i := Pred ( i );
              j := - 1;
           END;
    END; { case }
    SendMessage ( Memo.Handle, EM_LINESCROLL, j, 0 );
    SetScrollPos ( Handle, SB_Horz, i, True );
    Msg.Result := 0;
END;

TYPE
TNewApplication = OBJECT ( TApplication )
   PROCEDURE InitMainWindow;VIRTUAL;
END;

PROCEDURE TNewApplication.InitMainWindow;
BEGIN
   MainWindow := New ( pNewWindow, Init ( NIL, '' ) );
END;

{ program }
VAR
MyApp : TNewApplication;
BEGIN
  WITH MyApp DO BEGIN
     Init ( '' );
     Run;
     Done;
  END;
END.

