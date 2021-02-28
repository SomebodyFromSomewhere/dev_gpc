{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                          WIN32.INC                                       }
{                                                                          }
{                SOME GENERAL WIN32 DEFINITIONS FOR GPC                    }
{                                                                          }
{   Author: Prof. Abimbola Olowofoyeku                                     }
{          http://www.greatchief.plus.com                                  }
{          chiefsoft [at] bigfoot [dot] com                                }
{                                                                          }
{   This file is FREEWARE.                                                 }
{                                                                          }
{   Undefine "IS_UNIT" below, if you want to "include"                     }
{   the units in your program, instead of "USEing" them                    }
{                                                                          }
{  Last modified: 15 April 2003                                            }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}

{$ifdef __GPC__}
    {$X+}
  {$ifndef Win32_Inc}
    {$define Win32_Inc}
    {$define IS_UNIT}
    {$define Stdcall attribute(stdcall)}
    {$if __GPC_RELEASE__ < 20030209}
       {$define WINAPI(X) asmname X; Stdcall}
    {$else}
       {$define WINAPI(X) external name X; Stdcall}
    {$endif}
  {$endif} {Win32_Inc}
{$else}{ __GPC__}
    {$define IS_UNIT}
{$endif}{ __GPC__}

