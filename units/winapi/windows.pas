{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                         WINDOWS.PAS                                      }
{                                                                          }
{                   WIN32 API IMPORT UNIT FOR GPC                          }
{                                                                          }
{ Copyright (C) 1998-2003 Free Software Foundation, Inc.                   }
{                                                                          }
{ Author: Prof. Abimbola Olowofoyeku                                       }
{          http://www.greatchief.plus.com                                  }
{          chiefsoft [at] bigfoot [dot] com                                }
{                                                                          }
{    This library is released as part of the GNU Pascal project.           }
{                                                                          }
{ This library is free software; you can redistribute it and/or            }
{ modify it under the terms of the GNU Lesser General Public               }
{ License as published by the Free Software Foundation; either             }
{ version 2.1 of the License, or (at your option) any later version.       }
{                                                                          }
{ This library is distributed in the hope that it will be useful,          }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        }
{ Lesser General Public License for more details.                          }
{                                                                          }
{ You should have received a copy of the GNU Lesser General Public         }
{ License along with this library; if not, write to the Free Software      }
{ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA }
{                                                                          }
{    As a special exception, if you link this file with files compiled     }
{    with a GNU compiler to produce an executable, this does not cause     }
{    the resulting executable to be covered by the GNU Library General     }
{    Public License. This exception does not however invalidate any other  }
{    reasons why the executable file might be covered by the GNU Library   }
{    General Public License.                                               }
{                                                                          }
{  v1.00, April 2002 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                      http://www.greatchief.plus.com/                     }
{  v1.01, Dec.  2002 - Prof. Abimbola Olowofoyeku (The African Chief)      }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}
{$R-}

{$ifndef WINDOWS_UNIT}
{$define WINDOWS_UNIT}

UNIT windows;

INTERFACE
USES messages;
     {$i wintypes.pas}
     {$i winprocs.pas}
{$endif} {WINDOWS_UNIT}

