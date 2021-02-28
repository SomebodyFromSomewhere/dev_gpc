{
  $Id: winhello.pp,v 1.1 1998/12/20 22:23:54 peter Exp $
  Copyright (c) 1996 by Charlie Calvert
  Modifications by Florian Klaempfl

  Standard Windows API application written in Object Pascal.
  No VCL code included. This is all done on the Windows API
  level.

  Amended by Professor Abimbola Olowofoyeku on 12 April 2004
}

{$X+}
{$APPTYPE GUI}
{.$MODE DELPHI}
program WinHello;

Uses
  Messages,
  Sysutils,
  {$ifndef FPC}
  commctrl,
  commdlg,
  {$endif}
  Windows;

{$ifdef __GPC__}
    {$ifndef Stdcall}
    {$define Stdcall attribute(stdcall)}
    {$endif}
{$endif}


const
  AppName = 'WinHello';
  TheMsg =
  {$ifdef __GPC__}
  'Hello world by GNU Pascal';
  {$else}
  'Hello world by Free Pascal';
  {$endif}

function WindowProc(Window: HWnd; AMessage, WParam,
                    LParam: Longint): Longint;
                    Stdcall;
                    //export;

  var
     dc : hdc;
     ps : paintstruct;
     r : trect;

begin
  WindowProc := 0;

  case AMessage of
    wm_paint:
      begin
         dc:=BeginPaint(Window,{$ifdef FPC}@{$endif}ps);
         GetClientRect(Window,{$ifdef FPC}@{$endif}r);
         DrawText(
         dc,
         TheMsg,
         -1,
         {$ifdef FPC}@{$endif}r,
           DT_SINGLELINE or DT_CENTER or DT_VCENTER);
         EndPaint(Window,ps);
         Exit;
      end;
    wm_Destroy:
      begin
         PostQuitMessage(0);
         Exit;
      end;
  end;

  WindowProc := DefWindowProc(Window, AMessage, WParam, LParam);
end;

 { Register the Window Class }
function WinRegister: Boolean;
var
  WindowClass: WndClass;
begin
  WindowClass.Style := cs_hRedraw or cs_vRedraw;
  WindowClass.lpfnWndProc := TFarProc(@WindowProc);
  WindowClass.cbClsExtra := 0;
  WindowClass.cbWndExtra := 0;
  WindowClass.hInstance := MainInstance;
  WindowClass.hIcon := LoadIcon(0, idi_Application);
  WindowClass.hCursor := LoadCursor(0, idc_Arrow);
  WindowClass.hbrBackground := GetStockObject(WHITE_BRUSH);
  WindowClass.lpszMenuName := nil;
  WindowClass.lpszClassName := AppName;

  Result := RegisterClass(WindowClass) <> 0;
end;

 { Create the Window Class }
function WinCreate: HWnd;
var
  hWindow: HWnd;
begin
  hWindow := CreateWindow(AppName, 'Hello world program',
              ws_OverlappedWindow, cw_UseDefault, cw_UseDefault,
              cw_UseDefault, cw_UseDefault, 0, 0, MainInstance, nil);

  if hWindow <> 0 then begin
    ShowWindow(hWindow, sw_Normal);
    UpdateWindow(hWindow);
  end;

  Result := hWindow;
end;


var
  AMessage: Msg;
  hWindow: HWnd;

begin
  if not WinRegister then begin
    MessageBox(0, 'Register failed', nil, mb_Ok);
    Exit;
  end;
  hWindow := WinCreate;
  if longint(hWindow) = 0 then begin
    MessageBox(0, 'WinCreate failed', nil, mb_Ok);
    Exit;
  end;

  while GetMessage({$ifdef FPC}@{$endif}AMessage, 0, 0, 0) do begin
    TranslateMessage(AMessage);
    DispatchMessage(AMessage);
  end;
  Halt(AMessage.wParam);
end.

{
  $Log: winhello.pp,v $
  Revision 1.1  1998/12/20 22:23:54  peter
    * new name

}
