{
***************************************************************************
*   win32.inc  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This file defines some general paaremters for ObjectMingw
*  It is part of the ObjectMingw object/class library
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 3 Aug 2005
*  Version: 1.04
*  Licence: Freeware
*
***************************************************************************
}

{
  define "IS_UNIT" below, if you want to "USE" the units in your program,
  instead of "including" them
}
{$ifdef __GPC__}
    #define sChar {}
    {$define __GNU__}
    {$define IS_UNIT}
    {$define Stdcall attribute(stdcall)}
    {$define WINAPI(X) external name X; Stdcall}
    {$X+}
    {$R-}
    {$implicit-result}

    {$ifdef __CYGWIN32__}
       {$define WIN32}
       {$define POSIX_WIN32}
    {$endif}
    {$ifdef __MSYS__}
       {$define WIN32}
       {$define POSIX_WIN32}
    {$endif}
    {$ifdef __UWIN__}
       {$define WIN32}
       {$define POSIX_WIN32}
    {$endif}
{$else}
    {$define IS_UNIT}

    {$ifdef ver90}
       {$define Old_Delphi}
    {$endif}

    {$ifdef ver100}
       {$define Old_Delphi}
    {$endif}

    {$ifdef VirtualPascal}
       {$define Old_Delphi}
    {$endif}

    {$X+}
    {$H+}
    {$ifdef FPC}
       {$define __GNU__}
    {$else}
      {.$define _Delphi_}
    {$endif}

{$endif}

