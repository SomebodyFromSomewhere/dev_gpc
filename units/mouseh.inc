{
    $Id: mouseh.inc,v 1.1.2.2 2001/09/21 23:53:48 michael Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Amended for GNU Pascal by Prof. A Olowofoyeku (The African Chief)
                              17 April 2004

 **********************************************************************}

CONST
  { We have an errorcode base of 1030 }
  errMouseBase                    = 1030;
  errMouseInitError               = errMouseBase + 0;
  errMouseNotImplemented          = errMouseBase + 1;

TYPE
  PMouseEvent = ^TMouseEvent;
  TMouseEvent = PACKED RECORD { 8 bytes }
    buttons : word;
    x, y     : word;
    Action  : word;
  END;

CONST
  MouseActionDown = $0001;                         { Mouse down event }
  MouseActionUp   = $0002;                         { Mouse up event }
  MouseActionMove = $0004;                         { Mouse move event }

  MouseLeftButton   = $01;                         { Left mouse button }
  MouseRightButton  = $02;                         { Right mouse button }
  MouseMiddleButton = $04;                         { Middle mouse button }

  MouseEventBufSize = 16;                { Size of event queue }

VAR
  MouseIntFlag : Byte;                                { Mouse in int flag }
  MouseButtons : Byte;                                { Mouse button state }
  MouseWhereX,
  MouseWhereY  : Word;                                { Mouse position }

TYPE
  TMouseDriver = RECORD
    UseDefaultQueue : Boolean;
    InitDriver : PROCEDURE;
    DoneDriver : PROCEDURE;
    DetectMouse : FUNCTION : Byte;
    ShowMouse : PROCEDURE;
    HideMouse : PROCEDURE;
    GetMouseX : FUNCTION : Word;
    GetMouseY : FUNCTION : Word;
    GetMouseButtons : FUNCTION : Word;
    SetMouseXY : PROCEDURE ( x, y : word );
    GetMouseEvent : PROCEDURE ( VAR MouseEvent : TMouseEvent );
    PollMouseEvent : FUNCTION ( VAR MouseEvent : TMouseEvent ) : boolean;
    PutMouseEvent : PROCEDURE ( CONST MouseEvent : TMouseEvent );
  END;

PROCEDURE InitMouse;
{ Initialize the mouse interface }

PROCEDURE DoneMouse;
{ Deinitialize the mouse interface }

FUNCTION DetectMouse : byte;
{ Detect if a mouse is present, returns the amount of buttons or 0
  if no mouse is found }

PROCEDURE ShowMouse;
{ Show the mouse cursor }

PROCEDURE HideMouse;
{ Hide the mouse cursor }

FUNCTION GetMouseX : word;
{ Return the current X position of the mouse }

FUNCTION GetMouseY : word;
{ Return the current Y position of the mouse }

FUNCTION GetMouseButtons : word;
{ Return the current button state of the mouse }

PROCEDURE SetMouseXY ( x, y : word );
{ Place the mouse cursor on x,y }

PROCEDURE GetMouseEvent ( VAR MouseEvent : TMouseEvent );
{ Returns the last Mouseevent, and waits for one if not available }

PROCEDURE PutMouseEvent ( CONST MouseEvent : TMouseEvent );
{ Adds the given MouseEvent to the input queue. Please note that depending on
  the implementation this can hold only one value (NO FIFOs etc) }

FUNCTION PollMouseEvent ( VAR MouseEvent : TMouseEvent ) : boolean;
{ Checks if a Mouseevent is available, and returns it if one is found. If no
  event is pending, it returns 0 }

PROCEDURE SetMouseDriver ( CONST Driver : TMouseDriver );
{ Sets the mouse driver. }

PROCEDURE GetMouseDriver ( VAR Driver : TMouseDriver );
{ Returns the currently active mouse driver }

{
  $Log: mouseh.inc,v $
  Revision 1.1.2.2  2001/09/21 23:53:48  michael
  + Added mouse driver support.

  Revision 1.1.2.1  2001/01/30 22:21:22  peter
    * move api to rtl

  Revision 1.1  2001/01/13 11:13:12  peter
    * API 2 RTL

}
