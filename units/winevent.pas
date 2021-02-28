{
    $Id: winevent.pp,v 1.2.2.1 2001/01/30 21:52:03 peter Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl
    member of the Free Pascal development team

    Event Handling unit for setting Keyboard and Mouse Handlers

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Amended for GNU Pascal by Prof. A Olowofoyeku (The African Chief)
                              17 April 2004

 **********************************************************************}
UNIT WinEvent;

INTERFACE

  {$define Stdcall attribute(stdcall)}

{
   We need this unit to implement keyboard and mouse,
   because win32 uses only one message queue for mouse and key events
}

    USES
       Windows;

    TYPE
       PTEventProcedure = ^TEventProcedure;
       TEventProcedure = PROCEDURE ( VAR ir : TINPUTRECORD );

    { these procedures must be used to set the event handlers }
    { these doesn't do something, they signal only the        }
    { the upper layer that an event occured, this event       }
    { must be handled with Win32-API function by the upper    }
    { layer                                                   }
    PROCEDURE SetMouseEventHandler ( p : TEventProcedure );
    PROCEDURE SetKeyboardEventHandler ( p : TEventProcedure );
    PROCEDURE SetFocusEventHandler ( p : TEventProcedure );
    PROCEDURE SetMenuEventHandler ( p : TEventProcedure );
    PROCEDURE SetResizeEventHandler ( p : TEventProcedure );
    PROCEDURE SetUnknownEventHandler ( p : TEventProcedure );

    { these procedures must be used to get the event handlers }
    FUNCTION GetMouseEventHandler : pTEventProcedure;
    FUNCTION GetKeyboardEventHandler : pTEventProcedure;
    FUNCTION GetFocusEventHandler : pTEventProcedure;
    FUNCTION GetMenuEventHandler : pTEventProcedure;
    FUNCTION GetResizeEventHandler : pTEventProcedure;
    FUNCTION GetUnknownEventHandler : pTEventProcedure;

  IMPLEMENTATION


  VAR
       { these procedures are called if an event occurs }
       MouseEventHandler : TEventProcedure = NIL;
       KeyboardEventHandler : TEventProcedure = NIL;
       FocusEventHandler : TEventProcedure = NIL;
       MenuEventHandler : TEventProcedure = NIL;
       ResizeEventHandler : TEventProcedure = NIL;
       UnknownEventHandler  : TEventProcedure = NIL;

       { if this counter is zero, the event handler thread is killed }
       InstalledHandlers : Byte = 0;

    VAR
       HandlerChanging : TCriticalSection;
       EventThreadHandle : THandle;
       EventThreadID : DWord;

       { true, if the event handler should be stoped }
       ExitEventHandleThread : boolean;

    FUNCTION SetEventProc ( CONST p : TEventProcedure ) : PTEventProcedure;
    BEGIN
        Result := pTEventProcedure ( @p );
    END;

    FUNCTION GetMouseEventHandler;
      BEGIN
         GetMouseEventHandler := SetEventProc ( MouseEventHandler );
      END;


    FUNCTION GetKeyboardEventHandler;
      BEGIN
         GetKeyboardEventHandler := SetEventProc ( KeyboardEventHandler );
      END;


    FUNCTION GetFocusEventHandler;
      BEGIN
         GetFocusEventHandler := SetEventProc ( FocusEventHandler );
      END;


    FUNCTION GetMenuEventHandler;
      BEGIN
         GetMenuEventHandler := SetEventProc ( MenuEventHandler );
      END;


    FUNCTION GetResizeEventHandler;
      BEGIN
         GetResizeEventHandler := SetEventProc ( ResizeEventHandler );
      END;


    FUNCTION GetUnknownEventHandler;
      BEGIN
         GetUnknownEventHandler := SetEventProc ( UnknownEventHandler );
      END;


    FUNCTION EventHandleThread ( p : pointer ) : DWord;
    STDCALL;
      CONST
        irsize = 10;
      VAR
         ir : ARRAY [0..irsize - 1] OF TInputRecord;
         i, dwRead : DWord;
      BEGIN
         WHILE NOT ( ExitEventHandleThread ) DO
           BEGIN
              { wait for an event }
              WaitForSingleObject ( Std_Input_Handle, INFINITE );
              { guard this code, else it is doomed to crash, if the
                thread is switched between the assigned test and
                the call and the handler is removed
              }
              IF NOT ( ExitEventHandleThread ) THEN
                BEGIN
                   EnterCriticalSection ( HandlerChanging );
                   { read, but don't remove the event }
                   IF ReadConsoleInput ( Std_Input_Handle, ir [0], irsize, dwRead ) THEN
                    BEGIN
                      i := 0;
                      WHILE ( i < dwRead ) DO
                       BEGIN
                       { call the handler }
                       CASE ir [i].EventType OF
                        KEY_EVENT :
                          BEGIN
                             IF assigned ( KeyboardEventHandler ) THEN
                               KeyboardEventHandler ( ir [i] );
                          END;

                        _MOUSE_EVENT :
                          BEGIN
                             IF assigned ( MouseEventHandler ) THEN
                               MouseEventHandler ( ir [i] );
                          END;

                        WINDOW_BUFFER_SIZE_EVENT :
                          BEGIN
                             IF assigned ( ResizeEventHandler ) THEN
                               ResizeEventHandler ( ir [i] );
                          END;

                        MENU_EVENT :
                          BEGIN
                             IF assigned ( MenuEventHandler ) THEN
                               MenuEventHandler ( ir [i] );
                          END;

                        FOCUS_EVENT :
                          BEGIN
                             IF assigned ( FocusEventHandler ) THEN
                               FocusEventHandler ( ir [i] );
                          END;

                        ELSE
                          BEGIN
                             IF assigned ( UnknownEventHandler ) THEN
                               UnknownEventHandler ( ir [i] );
                          END;
                       END;
                       inc ( i );
                      END;
                    END;
                   LeaveCriticalSection ( HandlerChanging );
                END;
           END;
        EventHandleThread := 0;
      END;

    PROCEDURE NewEventHandlerInstalled ( p, oldp : TEventProcedure );
      VAR
         oldcount : Byte;
         ir : TInputRecord;
         written : DWord;
      BEGIN
         oldcount := InstalledHandlers;
         IF Pointer ( @oldp ) <> NIL THEN
           dec ( InstalledHandlers );
         IF Pointer ( @p ) <> NIL THEN
           inc ( InstalledHandlers );
         { start event handler thread }
         IF ( oldcount = 0 ) AND ( InstalledHandlers = 1 ) THEN
           BEGIN
              ExitEventHandleThread := false;
              EventThreadHandle := CreateThread ( NIL, 0, @EventHandleThread,
                NIL, 0, EventThreadID );
           END
         { stop and destroy event handler thread }
         ELSE IF ( oldcount = 1 ) AND ( InstalledHandlers = 0 ) THEN
           BEGIN
              ExitEventHandleThread := true;
              { create a dummy event and sent it to the thread, so
                we can leave WaitForSingleObject }
              ir.EventType := KEY_EVENT;
              { mouse event can be disabled by mouse.inc code
                in DoneMouse
                so use a key event instead PM }
              WriteConsoleInput ( Std_Input_Handle, ir, 1, written );
              { wait, til the thread is ready }
              WaitForSingleObject ( EventThreadHandle, INFINITE );
              CloseHandle ( EventThreadHandle );
           END;
      END;


    PROCEDURE SetMouseEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := MouseEventHandler;
         MouseEventHandler := p;
         NewEventHandlerInstalled ( MouseEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


    PROCEDURE SetKeyboardEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := KeyboardEventHandler;
         KeyboardEventHandler := p;
         NewEventHandlerInstalled ( KeyboardEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


    PROCEDURE SetFocusEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := FocusEventHandler;
         FocusEventHandler := p;
         NewEventHandlerInstalled ( FocusEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


    PROCEDURE SetMenuEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := MenuEventHandler;
         MenuEventHandler := p;
         NewEventHandlerInstalled ( MenuEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


    PROCEDURE SetResizeEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := ResizeEventHandler;
         ResizeEventHandler := p;
         NewEventHandlerInstalled ( ResizeEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


    PROCEDURE SetUnknownEventHandler ( p : TEventProcedure );
      VAR
         oldp : TEventProcedure;
      BEGIN
         EnterCriticalSection ( HandlerChanging );
         oldp := UnknownEventHandler;
         UnknownEventHandler := p;
         NewEventHandlerInstalled ( UnknownEventHandler, oldp );
         LeaveCriticalSection ( HandlerChanging );
      END;


initialization
   InitializeCriticalSection ( HandlerChanging );

FINALIZATION
  { Uninstall all handlers                   }
  { this stops also the event handler thread }
  SetMouseEventHandler ( NIL );
  SetKeyboardEventHandler ( NIL );
  SetFocusEventHandler ( NIL );
  SetMenuEventHandler ( NIL );
  SetResizeEventHandler ( NIL );
  SetUnknownEventHandler ( NIL );
  { delete the critical section object }
  DeleteCriticalSection ( HandlerChanging );

END.

{
  $Log: winevent.pp,v $
  Revision 1.2.2.1  2001/01/30 21:52:03  peter
    * moved api utils to rtl

  Revision 1.2  2001/01/14 22:20:00  peter
    * slightly optimized event handling (merged)

  Revision 1.1  2001/01/13 11:03:59  peter
    * API 2 RTL commit

}
