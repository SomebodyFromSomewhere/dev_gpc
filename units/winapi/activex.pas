{**************************************************************************}
{
*                            activex.pas
*
*  This UNIT implements a partial activex unit for GNU Pascal for Win32.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 15 April 2003
*  Version: 1.00
*
*  This file is FREEWARE
}
{**************************************************************************}


UNIT activex;

{$ifdef __GPC__}{$i win32.inc}{$endif}

INTERFACE

CONST
     DROPEFFECT_NONE = 0;
     DROPEFFECT_COPY = 1;
     DROPEFFECT_MOVE = 2;
     DROPEFFECT_LINK = 4;
     DROPEFFECT_SCROLL = $80000000;

FUNCTION CoTaskMemAlloc ( u : Cardinal ) : Pointer;
{$ifdef __GPC__}WINAPI ( 'CoTaskMemAlloc' );{$else}STDCALL;{$endif}

FUNCTION CoTaskMemRealloc ( p : Pointer; u : Cardinal ) : Pointer;
{$ifdef __GPC__}WINAPI ( 'CoTaskMemRealloc' );{$else}STDCALL;{$endif}

PROCEDURE CoTaskMemFree ( p : Pointer );
{$ifdef __GPC__}WINAPI ( 'CoTaskMemFree' );{$else}STDCALL;{$endif}

IMPLEMENTATION

{$ifdef __GPC__}
  {$l ole32}
{$else}
  CONST oledll = 'ole32.dll';
  FUNCTION  CoTaskMemAlloc;   external oledll name 'CoTaskMemAlloc';
  FUNCTION  CoTaskMemRealloc; external oledll name 'CoTaskMemRealloc';
  PROCEDURE CoTaskMemFree;    external oledll name 'CoTaskMemFree';
{$endif}
END.

