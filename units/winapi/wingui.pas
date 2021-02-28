{//////////////////////////////////////////////////////////////////////////}
{//                                                                      //}
{//                         WINGUI.PAS                                   //}
{//                                                                      //}
{//          SAMPLE WIN32 GUI PROGRAM, USING ONLY WinAPI CALLS.          //}
{//                                                                      //}
{//   Copyright (C) 1998-2007 Free Software Foundation, Inc.             //}
{//                                                                      //}
{//   Author: Prof. Abimbola Olowofoyeku <chiefsoft at bigfoot dot com>  //}
{//                                                                      //}
{//  This test program is released as part of the GNU Pascal project,    //}
{//  for the SOLE purpose of testing the WIN32 API TRANSLATIONS.         //}
{//                                                                      //}
{//  This program is a free program; you can redistribute and/or modify  //}
{//  it under the terms of the GNU Lesser General Public License,        //}
{//  version 2.1, as published by the Free Software Foundation.          //}
{//                                                                      //}
{//  This program is distributed in the hope that it will be useful,     //}
{//  but WITHOUT ANY WARRANTY; without even the implied warranty of      //}
{//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       //}
{//  GNU Library General Public License for more details.                //}
{//                                                                      //}
{//  You should have received a copy of the GNU Lesser General Public    //}
{//  License along with this program (see the file COPYING);             //}
{//  if not, write to the Free Software Foundation, Inc., 675 Mass Ave,  //}
{//  Cambridge, MA 02139, USA.                                           //}
{//                                                                      //}
{//  April 2001 - Prof A Olowofoyeku:                                    //}
{//               http://www.greatchief.plus.com                         //}
{//////////////////////////////////////////////////////////////////////////}
{
   Can be compiled with:
           * Delphi
           * Virtual Pascal
           * GNU Pascal
           * Free Pascal
           * TMT Pascal
}

PROGRAM test0;
{$ifdef VirtualPascal}
  {$pmtype pm}  { GUI program }
{$endif} {VirtualPascal}

{$ifdef FPC} {$MODE Delphi} {$endif}


USES
{$ifndef FPC}
Messages,
{$endif}
Windows;


{.$i windows.inc}

{$ifdef __GPC__}
   {$X+}
   {$W-}
   {.$R-}
   {$ifndef STDCALL}{$define STDCALL attribute(stdcall)}{$endif}
{$endif}

VAR
OldWnd : HWnd;

{ menu handles }
CONST
id_Exit  = 105;  { exit }
id_Help  = 300;  { help  }
id_About = 301;  { About box }
id_Separator = 0;

FUNCTION DefaultWindowProc ( Window : HWnd;
Message : Uint; WParam : WParam32; LParam : LParam32 ) : LResult; STDCALL;
BEGIN
  DefaultWindowProc := 0;
  CASE Message OF
    Wm_Close :
    BEGIN
       SetActiveWindow ( OldWnd );
       Halt ( 0 );
    END;

    wm_Command : { menu choices }
      BEGIN
         CASE WParam  OF  { choice ID is sent in WParam }

            id_Exit  :
            BEGIN
              SetActiveWindow ( OldWnd );
              Halt ( 0 );
            END;

            id_About :
                MessageBox ( Window,
                'Win32 Pure API Test Program (c) 2002-2007 Prof A Olowofoyeku (The African Chief)',
                'About Chief''s Test Program', mb_Ok );

            id_Help  : WinExec ( 'winhelp', sw_Normal );

         END; { Case WParam }
      DefaultWindowProc := 1;
      Exit;
    END; { Wm_Command }
  END; {Case Message}

  { call the Windows default window procedure }
  DefaultWindowProc := DefWindowProc ( Window, Message, WParam, lParam );
END; { DefaultWindowProc }

{ loop to keep the window alive and allow messages to be processed }
PROCEDURE MessageLoop;
VAR
M : Tmsg;
BEGIN
  WHILE ( 0 = 0 ) DO
  IF PeekMessage ( M, 0, 0, 0, pm_Remove )
  THEN BEGIN
      IF M.Message = wm_Quit THEN Break
      ELSE BEGIN
          TranslateMessage ( M );
          DispatchMessage ( M );
      END;
  END;
END; { MessageLoop }

{  main function; registers and creates a window and calls the message loop }
{ Example number one }
FUNCTION  WindowCreate : HWnd;
VAR
wnd : Hwnd;
OldProc : TFarProc;
x, y, w, h : longint;
xWindClass : TWndClass;
MainMenu,
FileMenu,
EditMenu,
HelpMenu : HMenu;

BEGIN
   WindowCreate := 0;
   WITH xWindClass
   DO BEGIN
      lpfnWndProc   := @DefaultWindowProc;
      style         := CS_HREDRAW OR CS_VREDRAW;
      cbClsExtra    := 0;
      cbWndExtra    := 1;
      lpszClassName := 'African_Chief';
      hIcon         := LoadIcon ( hInstance, 'MainIcon' );
      hCursor       := LoadCursor ( 0, idc_Arrow );
      hbrBackground := GetStockObject ( white_Brush );
      lpszMenuName  := 'MainMenu';
   END;
   xWindClass.hInstance :=  hInstance;

   IF RegisterClass ( xWindClass ) = 0
   THEN BEGIN
      MessageBox ( 0, 'Window Class Registration Error', 'Chief Error', Mb_ok );
      PostQuitMessage ( 0 );
      Halt ( 1 );
   END;

   { window coordinates }
   x := 1;
   y := 1;
   w := 600;
   h := 400;

   { try to create the window }
   Wnd := CreateWindow ( xWindClass.lpszClassName,
                      'Welcome to Chief''s API-only Win32 Program',
                      WS_OVERLAPPEDWINDOW,
                      x,
                      y,
                      w,
                      h,
                      0 { Parent Window},
                      0 { Menu handle},
                      xWindClass.HInstance,
                      NIL );

    WindowCreate := Wnd;

    IF Wnd = 0 THEN BEGIN
      MessageBox ( 0,
      'Window Creation Error', 'Chief Error', Mb_ok );
      PostQuitMessage ( 0 );
      Halt ( 1 );
    END;

    { save the old window procedure }
    OldProc := tFarProc ( GetWindowLong ( Wnd, GWL_WndProc ) );

   { now let's have some menus }
   { main menu }
    MainMenu := GetMenu ( Wnd );
    IF MainMenu = 0 THEN MainMenu := CreateMenu;

    SetMenu ( Wnd, MainMenu );

   { file menu }
    FileMenu := CreateMenu;
        AppendMenu ( MainMenu, mf_PopUp OR mf_Enabled, FileMenu, '&File' );
        AppendMenu ( FileMenu, mf_Enabled, 100, '&New ...' );
        AppendMenu ( FileMenu, mf_Enabled, 101, '&Open ...' );
        AppendMenu ( FileMenu, mf_Enabled, 102, '&Save' );
        AppendMenu ( FileMenu, mf_Enabled, 103, 'Save &As ...' );
        AppendMenu ( FileMenu, mf_Enabled, 104, '&Close' );
        AppendMenu ( FileMenu, mf_Separator, id_Separator, '' ); { separator }
        AppendMenu ( FileMenu, mf_Enabled, id_Exit, 'E&xit' );

   { edit menu }
    EditMenu := CreateMenu;
        AppendMenu ( MainMenu, mf_PopUp OR mf_Enabled, EditMenu, '&Edit' );
        AppendMenu ( EditMenu, mf_Enabled, 200, '&Copy' );
        AppendMenu ( EditMenu, mf_Enabled, 201, 'C&ut' );
        AppendMenu ( EditMenu, mf_Enabled, 202, '&Paste' );
        AppendMenu ( EditMenu, mf_Enabled, 203, '&Undo' );

   { help menu }
    HelpMenu := CreateMenu;
        AppendMenu ( MainMenu, mf_PopUp OR mf_Enabled, HelpMenu, '&Help' );
        AppendMenu ( HelpMenu, mf_Enabled, id_Help, '&Contents' );
        AppendMenu ( HelpMenu, mf_Separator, id_Separator, '' ); { separator }
        AppendMenu ( HelpMenu, mf_Enabled, id_About, '&About ...' );

    { redraw the menu bar }
    DrawMenuBar ( Wnd );

    { display the window }
    ShowWindow ( Wnd, sw_Show );

    { call the message loop }
    MessageLoop;
END; { WindowCreate }

{ program }
BEGIN
  OldWnd := GetActiveWindow;
  WindowCreate;
END.

