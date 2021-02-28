{
***************************************************************************
*                 genutils.pas
*  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements some generally useful routines
*
*  It is part of the ObjectMingw object/class library
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal, and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 3 Aug 2005
*  Version: 1.01
*  Licence: Shareware
*
***************************************************************************
}
UNIT genutils;
{$i cwindows.inc}

INTERFACE

USES
Windows, cClasses;

VAR
GetNTCommonFolders : Boolean = False;

// call up a directory browse dialog
FUNCTION SelectFolder ( ParentWnd : hWnd; Caption : String ) : TString;
// callback FOR the above
VAR SelectFolderBrowseCallbackProc : TFarProc = NIL;

// Return the parent window ( IF any ) OF a window
FUNCTION GetParentWindow ( Wnd : HWnd ) : HWnd;

// add a back slash IF NOT there already
FUNCTION AddBackSlash ( CONST s : String ) : TString;

// send a mouse click TO a control IN a window
FUNCTION SendClick ( ParentWnd : HWND; ChildID : Integer ) : Integer;

// centre a child window within the dimensions OF its parent window
PROCEDURE CentreChildWindow ( CONST ParentWnd, ChildWnd : HWnd );

// centre a window within the entire screen
PROCEDURE CentreWindow ( CONST Wnd : HWnd );

// centre a window within the entire screen, according TO the supplied
// fraction ( e.g., 2.0 ) }
PROCEDURE CentreWindowEx ( CONST Wnd : HWnd; CONST Frac : Real );

// get the correct shell folder name FOR something
FUNCTION GetShellFolderName ( Value : String ) : TString;
FUNCTION GetShellFolderNameEx ( Value, aReturn : pChar ) : Longint;

// get all the folders IN the root directory
FUNCTION GetFolders ( CONST RootDir : String; VAR aReturn : TStrings ) : integer;

// convert from screen pixels TO dialog units ( x AND y )
FUNCTION PixelsToDialogUnitsX ( x : Integer ) : Integer;
FUNCTION PixelsToDialogUnitsY ( y : Integer ) : Integer;

// convert from dialog units TO screen pixels ( x AND y )
FUNCTION DialogUnitsXToPixels ( x : integer ) : integer;
FUNCTION DialogUnitsYToPixels ( y : integer ) : integer;

// Looks FOR "SearchFor" IN "TheSearched" AND return its
//  zero - based Index; @@ use WITH care!!!
FUNCTION PCharPos ( SearchFor, TheSearched : pChar ) : Longint;

FUNCTION PCharPos2
( SearchFor, TheSearched : pChar;
 Index : Longint; {start searching from index (zero-based) }
 MatchCase,
 RelativeSearch : Boolean )  { if relativesearch, then count starts from index }
 : Longint;

{$ifdef FPC}
CONST
BFFM_INITIALIZED = 1;
{$endif}

IMPLEMENTATION

USES Messages, Registry, Sysutils, {$ifndef VirtualPascal}ActiveX, {$endif}ShlObj;

{$ifdef VirtualPascal}
CONST
     DROPEFFECT_NONE = 0;
     DROPEFFECT_COPY = 1;
     DROPEFFECT_MOVE = 2;
     DROPEFFECT_LINK = 4;
     DROPEFFECT_SCROLL = $80000000;
     oledll = 'ole32.dll';


FUNCTION CoTaskMemAlloc ( u : Cardinal ) : Pointer; STDCALL;
external oledll name 'CoTaskMemAlloc';

FUNCTION CoTaskMemRealloc ( p : Pointer; u : Cardinal ) : Pointer; STDCALL;
external oledll name 'CoTaskMemRealloc';

PROCEDURE CoTaskMemFree ( p : Pointer ); STDCALL;
external oledll name 'CoTaskMemFree';
{$endif} {VirtualPascal}

FUNCTION PixelsToDialogUnitsX ( x : Integer ) : Integer;
BEGIN
   Result := ( x * 4 ) div LoWord ( GetDialogBaseUnits );
END;

FUNCTION PixelsToDialogUnitsY ( y : Integer ) : Integer;
BEGIN
   Result := ( y * 8 ) div HiWord ( GetDialogBaseUnits );
END;

FUNCTION DialogUnitsXToPixels ( x : integer ) : integer;
BEGIN
  Result := ( x * LoWord ( GetDialogBaseUnits ) ) div 4;
END;

FUNCTION DialogUnitsYToPixels ( y : integer ) : integer;
BEGIN
  Result := ( y * HiWord ( GetDialogBaseUnits ) ) div 8;
END;

FUNCTION AddBackSlash ( CONST s : String ) : TString;
BEGIN
   Result := s;
   IF Result [Length ( Result ) ] <> '\' THEN Insert ( '\', Result, Length ( Result ) + 1 );
END;

FUNCTION SendClick ( ParentWnd : HWND; ChildID : Integer ) : Integer;
BEGIN
  SendClick := 0;
  SendDlgItemMessage ( ParentWnd, ChildID, wm_LButtonDown, 0, 0 );
  SendDlgItemMessage ( ParentWnd, ChildID, wm_LButtonUp, 0, 0 );
END;

{ get the name of a shell folder from the registry }
FUNCTION GetShellFolderName ( Value : String ) : TString;
{ possible values :
    'Desktop'       : points to Desktop folder
    'Programs'      : points to where start menu program icons are created
    'Start Menu'    : points to start menu root directory
    'Personal'      : points to "My Documents"
    'Startup'       : points to Startup folder

Under NT, to get the common (as opposed to the current user's)
folders, do the following;
 1. After calling TRegistry.Create,
    Add the following line (before calling "Reg.OpenKey")
      Reg.RootKey := HKey_Local_Machine;\
 2. Use the following values :
    'Common Desktop'       : points to "All Users" Desktop folder
    'Common Programs'      : points to "All Users", where start menu program icons are created
    'Common Start Menu'    : points to "All Users" start menu root directory
    'Common Startup'       : points to "All Users" Startup folder
}

VAR
Reg : tRegistry;
BEGIN
  Result := '';
  Reg.Create;
  { NT, for "Common" (All Users) folders }
  { NB: this is the effect under NT of using the DDE interface to create icons }
  IF GetNTCommonFolders
  THEN BEGIN
     Reg.RootKey := HKey_Local_Machine;
     IF  ( Pos ( 'COMMON ', UpperCase ( Value ) ) <> 1 )
     THEN BEGIN
       Value := 'Common ' + Value;
     END;
  END;

  Reg.Openkey ( 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False );
  Result := Reg.ReadString ( Value );
  Reg.Done;
END;

FUNCTION GetShellFolderNameEx ( Value, aReturn : pChar ) : Longint;
VAR s : TString;
BEGIN
    s := GetShellFolderName ( StrPas ( Value ) );
    Strpcopy ( aReturn, s );
    Result := StrLen ( aReturn );
END;

{ return all the folders in the directory of RootDir }
FUNCTION GetFolders ( CONST RootDir : String; VAR aReturn : TStrings ) : integer;
VAR
t : TSearchRec;
i : integer;
BEGIN
   Result := - 1;
   IF ( RootDir = '' ) THEN Exit;
   aReturn.Clear;
   Result := 0;
   i := FindFirst ( AddBackslash ( RootDir ) + '*.*',
                    faDirectory + faHidden + faReadOnly, T );
   WHILE i = 0
   DO BEGIN
      IF ( T.Attr AND faDirectory <> 0 ) AND ( t.Name [1] <> '.' )
      THEN BEGIN
         Inc ( Result );
         aReturn.Add ( T.Name );
      END;
      i := FindNext ( T );
   END;
   FindClose ( T );
END;

FUNCTION GetFoldersEx ( RootDir : pChar; aReturn : pChar ) : integer;
VAR
T : TStrings;
i : integer;
BEGIN
   t.Create;
   Result := GetFolders ( StrPas ( RootDir ), t );
   IF Result >= 0
   THEN BEGIN
      Strcopy ( aReturn, '' );
      FOR i := 0 TO t.count - 1
      DO BEGIN
         StrCat ( aReturn, pChar ( t.pChars ( i ) ) );
         StrCat ( aReturn, ';' );
      END;
   END;
   t.Done;
END;

PROCEDURE CentreWindowEx ( CONST Wnd : HWnd; CONST Frac : Real );
VAR
  DialogDimensions : TRect;
  X, Y, W, H : WinInteger;
BEGIN
    GetWindowRect ( Wnd, DialogDimensions );
    WITH DialogDimensions
    DO BEGIN
      X := ( GetSystemMetrics ( sm_cxScreen ) - ( right - left ) ) div 2;
      Y := Round ( ( GetSystemMetrics ( sm_cyScreen ) - ( bottom - top ) ) / Frac );
      IF x < 1 THEN x := 1;
      IF y < 1 THEN y := 1;
      W := right - left;
      H := bottom - top;
    END;
    SetWindowPos ( Wnd, 0, X, Y, W, H, swp_NoSize );
END;

PROCEDURE CentreWindow ( CONST Wnd : HWnd );
BEGIN
   CentreWindowEx ( Wnd, 2 );
END;

PROCEDURE CentreChildWindow ( CONST ParentWnd, ChildWnd : HWnd );
VAR
  T,
  DialogDimensions : TRect;
  X, Y, W, H : integer;
BEGIN
    GetWindowRect ( ChildWnd, DialogDimensions );
    GetWindowRect ( ParentWnd, T );
    WITH DialogDimensions
    DO BEGIN
      x := T.Left + ( ( T.Right - T.Left ) div 2 ) - ( ( right - left ) div 2 ) ;
      Y := T.Top + ( ( T.Bottom - T.Top ) div 2 ) - ( ( bottom - top ) div 2 );
      IF x < T.Left THEN x := t.Left;
      IF y < T.Top  THEN y := t.Top;
      W := right - left;
      H := bottom - top;
    END;
    SetWindowPos ( ChildWnd, 0, X, Y, W, H, swp_NoSize );
END;

FUNCTION DefBrowseCallbackProc ( WND : hwnd; uMsg : integer; lParam : integer; lpData : integer ) : integer;
STDCALL;
{$ifdef __GPC__}FORWARD;
FUNCTION DefBrowseCallbackProc ( WND : hwnd; uMsg : integer; lParam : integer; lpData : integer ) : integer;
{$endif}
BEGIN
  IF uMsg = BFFM_INITIALIZED
  THEN BEGIN
     CentreChildWindow ( GetParentWindow ( Wnd ), Wnd );
  END;
  Result := 0;
END;

{$ifndef __GPC__}
CONST BIF_NEWDIALOGSTYLE = 64;
{$endif}
FUNCTION SelectFolder ( ParentWnd : hWnd; Caption : String ) : TString;
VAR
  BrowseInfo : TBrowseInfo;
  buf : ARRAY [0..MAX_PATH] OF char;
  pidList : PItemIDList;
BEGIN
  Result := '';
  buf [0] := #0;
  WITH BrowseInfo
  DO BEGIN
      hwndOwner := ParentWnd;
      pidlRoot  := NIL;
      pszDisplayName := buf; // receives selected
      Caption := Caption + #0;
      lpszTitle := @Caption [1];
      ulFlags := BIF_NEWDIALOGSTYLE;
      lpfn := SelectFolderBrowseCallbackProc;
  END;
  pidList := SHBrowseForFolder ( {$ifdef FPC}@{$endif}BrowseInfo );
  IF ( Assigned ( pidList ) ) AND ( SHGetPathFromIDList ( pidList, buf ) )
  THEN BEGIN
      Result := StrPas ( buf );
      CoTaskMemFree ( pidList );
  END;
END;

FUNCTION GetParentWindow ( Wnd : HWnd ) : HWnd;
BEGIN
   Result := GetWindowLong ( Wnd, GWL_HWNDPARENT );
END;

{*************************************}
{ Looks for "SearchFor" in "TheSearched" and return its
  zero-based Index }
// CASE insensitive "Pos"
FUNCTION iPCharPos ( SearchFor, TheSearched : pChar ) : Longint;
VAR
p : pChar;
BEGIN
  Result := - 1;
  p := StrPos ( strlower ( TheSearched ), strlower ( SearchFor ) );
  IF p <> NIL THEN Result := p - TheSearched;
END;

// find occurrences OF "str2" IN "str1"
FUNCTION StriPos ( Str1, Str2 : pChar ) : pChar;
VAR
p1, p2 : pChar;
BEGIN
  p1 := StrNew ( Str1 );
  p2 := StrNew ( Str2 );
  Result := StrPos ( StrLower ( p1 ), StrLower ( p2 ) );
  StrDispose ( p1 );
  StrDispose ( p2 );
END;

FUNCTION PCharPos ( SearchFor, TheSearched : pChar ) : Longint;
VAR
p : pChar;
BEGIN
  Result := - 1;
  p := StrPos ( TheSearched, SearchFor );
  IF p <> NIL THEN Result := p - TheSearched;
END;

FUNCTION PCharPos2
( SearchFor, TheSearched : pChar;
 Index : Longint; {start searching from index (zero-based) }
 MatchCase,
 RelativeSearch : Boolean )  { if relativesearch, then count starts from index }
 : Longint;
VAR
p : pChar;
BEGIN
  Result := - 1;
  IF MatchCase
     THEN p := StrPos ( @TheSearched [Index], SearchFor )
        ELSE p := StriPos ( @TheSearched [Index], SearchFor );

  IF p <> NIL
  THEN BEGIN
     Result := p - TheSearched;
     IF RelativeSearch THEN Dec ( Result, Index );
  END;
END;

{****************************************************}
BEGIN
   SelectFolderBrowseCallbackProc := @DefBrowseCallbackProc;
END.

