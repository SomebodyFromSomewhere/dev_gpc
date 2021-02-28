{
    $Id: mouse.inc,v 1.1.2.5 2002/09/17 11:35:28 pierre Exp $
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

VAR
  CurrentMouseDriver : TMouseDriver;
  MouseInitialized : Boolean;

  // Mouse queue event mechanism
  PendingMouseEvent  : ARRAY [0..MouseEventBufSize - 1] OF TMouseEvent;
  PendingMouseHead,
  PendingMouseTail   : PMouseEvent;
  PendingMouseEvents : byte;
  LastMouseEvent : TMouseEvent;

PROCEDURE ClearMouseEventQueue;

BEGIN
  PendingMouseHead := @PendingMouseEvent;
  PendingMouseTail := @PendingMouseEvent;
  PendingMouseEvents := 0;
  FillChar ( LastMouseEvent, sizeof ( TMouseEvent ), 0 );
END;


PROCEDURE InitMouse;

BEGIN
 IF NOT MouseInitialized THEN
   BEGIN
   IF Assigned ( CurrentMouseDriver.InitDriver ) THEN
     CurrentMouseDriver.InitDriver;
   ClearMouseEventQueue;
   MouseInitialized := True;
   END;
END;

PROCEDURE DoneMouse;

BEGIN
 IF MouseInitialized THEN
   BEGIN
   IF Assigned ( CurrentMouseDriver.DoneDriver ) THEN
     CurrentMouseDriver.DoneDriver;
   ClearMouseEventQueue;
   MouseInitialized := False;
   END;
END;

FUNCTION DetectMouse : byte;

BEGIN
  IF Assigned ( CurrentMouseDriver.DetectMouse ) THEN
    DetectMouse := CurrentMouseDriver.DetectMouse
  ELSE
    DetectMouse := 0;
END;

PROCEDURE ShowMouse;

BEGIN
  IF Assigned ( CurrentMouseDriver.ShowMouse ) THEN
    CurrentMouseDriver.ShowMouse;
END;

PROCEDURE HideMouse;

BEGIN
  IF Assigned ( CurrentMouseDriver.HideMouse ) THEN
    CurrentMouseDriver.HideMouse;
END;

FUNCTION GetMouseX;

BEGIN
  IF Assigned ( CurrentMouseDriver.GetMouseX ) THEN
    GetMouseX := CurrentMouseDriver.GetMouseX
  ELSE
    GetMouseX := 0;
END;

FUNCTION GetMouseY;

BEGIN
  IF Assigned ( CurrentMouseDriver.GetMouseY ) THEN
    GetMouseY := CurrentMouseDriver.GetMouseY
  ELSE
    GetMouseY := 0;
END;

FUNCTION GetMouseButtons;

BEGIN
  IF Assigned ( CurrentMouseDriver.GetMouseButtons ) THEN
    GetMouseButtons := CurrentMouseDriver.GetMouseButtons
  ELSE
    GetMouseButtons := 0;
END;

PROCEDURE SetMouseXY;

BEGIN
  IF Assigned ( CurrentMouseDriver.SetMouseXY ) THEN
    CurrentMouseDriver.SetMouseXY ( X, Y )
END;

PROCEDURE GetPendingEvent ( VAR MouseEvent : TMouseEvent );

BEGIN
  MouseEvent := PendingMouseHead^;
  inc ( PendingMouseHead );
  IF longint ( PendingMouseHead ) = longint ( @PendingMouseEvent ) + sizeof ( PendingMouseEvent ) THEN
   PendingMouseHead := @PendingMouseEvent;
  dec ( PendingMouseEvents );
  IF ( ( LastMouseEvent.x <> MouseEvent.x ) OR
     ( LastMouseEvent.y <> MouseEvent.y ) ) AND
     ( LastMouseEvent.Buttons = MouseEvent.Buttons ) THEN
    MouseEvent.Action := MouseActionMove;
  IF ( LastMouseEvent.Buttons <> MouseEvent.Buttons ) AND
     ( MouseEvent.Action <> MouseActionDown ) AND
     ( MouseEvent.Action <> MouseActionUp ) THEN
     BEGIN
       IF ( LastMouseEvent.Buttons < MouseEvent.Buttons ) THEN
         MouseEvent.Action := MouseActionDown
       ELSE
        MouseEvent.Action := MouseActionUp;
     END;
  LastMouseEvent := MouseEvent;
END;

PROCEDURE GetMouseEvent ( VAR MouseEvent : TMouseEvent );

BEGIN
  IF CurrentMouseDriver.UseDefaultQueue THEN
    BEGIN
    IF ( PendingMouseEvents > 0 ) THEN
      GetPendingEvent ( MouseEvent )
    ELSE
      FillChar ( MouseEvent, sizeof ( MouseEvent ), 0 );
    END
  ELSE
    IF Assigned ( CurrentMouseDriver.GetMouseEvent ) THEN
      BEGIN
      CurrentMouseDriver.GetMouseEvent ( MouseEvent );
      LastMouseEvent := MouseEvent;
      END
    ELSE
      FillChar ( MouseEvent, sizeof ( TMouseEvent ), 0 );
END;

PROCEDURE PutMouseEvent ( CONST MouseEvent : TMouseEvent );
BEGIN
  IF CurrentMouseDriver.UseDefaultQueue THEN
    BEGIN
    PendingMouseTail^ := MouseEvent;
    inc ( PendingMouseTail );
    IF longint ( PendingMouseTail ) = longint ( @PendingMouseEvent ) + sizeof ( PendingMouseEvent ) THEN
      PendingMouseTail := @PendingMouseEvent;
    inc ( PendingMouseEvents );
    END
  ELSE
    IF Assigned ( CurrentMouseDriver.PutMouseEvent ) THEN
      CurrentMouseDriver.PutMouseEvent ( MouseEvent );
END;

FUNCTION PollMouseEvent ( VAR MouseEvent : TMouseEvent ) : boolean;

BEGIN
  IF ( CurrentMouseDriver.UseDefaultQueue ) AND
     ( PendingMouseEvents > 0 ) THEN
    BEGIN
    MouseEvent := PendingMouseHead^;
    PollMouseEvent := true;
    END
  ELSE
    IF Assigned ( CurrentMouseDriver.PollMouseEvent ) THEN
      BEGIN
      PollMouseEvent := CurrentMouseDriver.PollMouseEvent ( MouseEvent );
      // Put it IN queue, so next poll / get will be faster.
      // Only IF an event was found PM
      // IF PollMouseEvent THEN
      //  PutMouseEvent ( MouseEvent );
      // This IS all wrong, because the Event might already
      // have been pushed IN the Event ARRAY.
      END
    ELSE
      PollMouseEvent := false;
END;

PROCEDURE SetMouseDriver ( CONST Driver : TMouseDriver );

BEGIN
  IF NOT MouseInitialized THEN
    CurrentMouseDriver := Driver;
END;


PROCEDURE GetMouseDriver ( VAR Driver : TMouseDriver );

BEGIN
  Driver := CurrentMouseDriver;
END;

{
  $Log: mouse.inc,v $
  Revision 1.1.2.5  2002/09/17 11:35:28  pierre
    * In GetMouseEvent, only modify Action field if not already set.

  Revision 1.1.2.4  2001/09/23 23:32:25  pierre
   * avoid to call PutMouseEvent on any event in PollMouseEvent as it might already be in the Event Array

  Revision 1.1.2.3  2001/09/23 23:26:38  pierre
   * avoid to call PutMouseEvent on empty events

  Revision 1.1.2.2  2001/09/23 23:21:32  pierre
   * avoid some cases with functions returning in undefined state

  Revision 1.1.2.1  2001/09/21 23:53:48  michael
  + Added mouse driver support.

}
