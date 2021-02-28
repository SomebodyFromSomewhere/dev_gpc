{
    $Id: mouse.pp,v 1.2.2.4 2001/09/21 23:53:48 michael Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl
    member of the Free Pascal development team

    Mouse unit for linux

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Amended for GNU Pascal by Prof. A Olowofoyeku (The African Chief)
                              17 April 2004

 **********************************************************************}
UNIT Mouse;

INTERFACE

USES
   Windows,
   Winevent;

{$i mouseh.inc}

IMPLEMENTATION

{$i mouse.inc}

VAR
   ChangeMouseEvents : TCriticalSection;

PROCEDURE MouseEventHandler ( VAR ir : TINPUTRECORD );

  VAR
     e : TMouseEvent;

  BEGIN
          EnterCriticalSection ( ChangeMouseEvents );
          e.x := ir.Event.MouseEvent.dwMousePosition.x;
          e.y := ir.Event.MouseEvent.dwMousePosition.y;
          e.buttons := 0;
          e.action := 0;
          IF ( ir.Event.MouseEvent.dwButtonState AND FROM_LEFT_1ST_BUTTON_PRESSED <> 0 ) THEN
            e.buttons := e.buttons OR MouseLeftButton;
          IF ( ir.Event.MouseEvent.dwButtonState AND FROM_LEFT_2ND_BUTTON_PRESSED <> 0 ) THEN
            e.buttons := e.buttons OR MouseMiddleButton;
          IF ( ir.Event.MouseEvent.dwButtonState AND RIGHTMOST_BUTTON_PRESSED <> 0 ) THEN
            e.buttons := e.buttons OR MouseRightButton;

          { can we compress the events? }
          IF ( PendingMouseEvents > 0 ) AND
            ( e.buttons = PendingMouseTail^.buttons ) AND
            ( e.action = PendingMouseTail^.action ) THEN
            BEGIN
               PendingMouseTail^.x := e.x;
               PendingMouseTail^.y := e.y;
            END
          ELSE
            BEGIN
               PutMouseEvent ( e );
               // this should be done IN PutMouseEvent, now it IS PM
               // inc ( PendingMouseEvents );
            END;
          LeaveCriticalSection ( ChangeMouseEvents );
  END;

PROCEDURE SysInitMouse;

VAR
   mode : dword;

BEGIN
  // enable mouse events
  GetConsoleMode ( StdInputHandle, mode );
  mode := mode OR ENABLE_MOUSE_INPUT;
  SetConsoleMode ( StdInputHandle, mode );

  PendingMouseHead := @PendingMouseEvent;
  PendingMouseTail := @PendingMouseEvent;
  PendingMouseEvents := 0;
  FillChar ( LastMouseEvent, sizeof ( TMouseEvent ), 0 );
  InitializeCriticalSection ( ChangeMouseEvents );
  SetMouseEventHandler ( MouseEventHandler );
  ShowMouse;
END;


PROCEDURE SysDoneMouse;
VAR
   mode : dword;
BEGIN
  HideMouse;
  // disable mouse events
  GetConsoleMode ( StdInputHandle, mode );
  mode := mode AND ( NOT ENABLE_MOUSE_INPUT );
  SetConsoleMode ( StdInputHandle, mode );

  SetMouseEventHandler ( NIL );
  DeleteCriticalSection ( ChangeMouseEvents );
END;


FUNCTION SysDetectMouse : byte;
VAR
  num : dword;
BEGIN
  GetNumberOfConsoleMouseButtons ( num );
  SysDetectMouse := num;
END;


PROCEDURE SysGetMouseEvent ( VAR MouseEvent : TMouseEvent );

VAR
   b : byte;

BEGIN
  REPEAT
    EnterCriticalSection ( ChangeMouseEvents );
    b := PendingMouseEvents;
    LeaveCriticalSection ( ChangeMouseEvents );
    IF b > 0 THEN
      break
    ELSE
      sleep ( 50 );
  UNTIL false;
  EnterCriticalSection ( ChangeMouseEvents );
  MouseEvent := PendingMouseHead^;
  inc ( PendingMouseHead );
  IF longint ( PendingMouseHead ) = longint ( @PendingMouseEvent ) + sizeof ( PendingMouseEvent ) THEN
   PendingMouseHead := @PendingMouseEvent;
  dec ( PendingMouseEvents );
  IF ( LastMouseEvent.x <> MouseEvent.x ) OR ( LastMouseEvent.y <> MouseEvent.y ) THEN
   MouseEvent.Action := MouseActionMove;
  IF ( LastMouseEvent.Buttons <> MouseEvent.Buttons ) THEN
   BEGIN
     IF ( LastMouseEvent.Buttons = 0 ) THEN
      MouseEvent.Action := MouseActionDown
     ELSE
      MouseEvent.Action := MouseActionUp;
   END;
  LastMouseEvent := MouseEvent;
  LeaveCriticalSection ( ChangeMouseEvents );
END;


FUNCTION SysPollMouseEvent ( VAR MouseEvent : TMouseEvent ) : boolean;
BEGIN
  EnterCriticalSection ( ChangeMouseEvents );
  IF PendingMouseEvents > 0 THEN
   BEGIN
     MouseEvent := PendingMouseHead^;
     SysPollMouseEvent := true;
   END
  ELSE
   SysPollMouseEvent := false;
  LeaveCriticalSection ( ChangeMouseEvents );
END;


PROCEDURE SysPutMouseEvent ( CONST MouseEvent : TMouseEvent );
BEGIN
  IF PendingMouseEvents < MouseEventBufSize THEN
   BEGIN
     PendingMouseTail^ := MouseEvent;
     inc ( PendingMouseTail );
     IF longint ( PendingMouseTail ) = longint ( @PendingMouseEvent ) + sizeof ( PendingMouseEvent ) THEN
      PendingMouseTail := @PendingMouseEvent;
      { why isn't this done here ?
        so the win32 version do this by hand:}
       inc ( PendingMouseEvents );
   END;
END;

VAR
  SysMouseDriver : TMouseDriver = (
    UseDefaultQueue : False;
    InitDriver      : SysInitMouse;
    DoneDriver      : SysDoneMouse;
    DetectMouse     : SysDetectMouse;
    ShowMouse       : NIL;
    HideMouse       : NIL;
    GetMouseX       : NIL;
    GetMouseY       : NIL;
    GetMouseButtons : NIL;
    SetMouseXY      : NIL;
    GetMouseEvent   : SysGetMouseEvent;
    PollMouseEvent  : SysPollMouseEvent;
    PutMouseEvent   : SysPutMouseEvent
  );

BEGIN
  SetMouseDriver ( SysMouseDriver );
END.
{
  $Log: mouse.pp,v $
  Revision 1.2.2.4  2001/09/21 23:53:48  michael
  + Added mouse driver support.

  Revision 1.2.2.3  2001/08/05 12:24:37  peter
    * fixed for new input_record

  Revision 1.2.2.2  2001/04/10 20:33:04  peter
    * remove some warnings

  Revision 1.2.2.1  2001/01/30 21:52:03  peter
    * moved api utils to rtl

  Revision 1.2  2001/01/14 22:20:00  peter
    * slightly optimized event handling (merged)

  Revision 1.1  2001/01/13 11:03:59  peter
    * API 2 RTL commit

}
