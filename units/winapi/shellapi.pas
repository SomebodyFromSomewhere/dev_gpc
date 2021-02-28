{**************************************************************************}
{                  shellapi.pas                                            }
{                                                                          }
{ This UNIT implements a partial shellapi unit for GNU Pascal for Win32.   }
{ Copyright (C) 1998-2003 Free Software Foundation, Inc.                   }
{                                                                          }
{ Author: Prof. Abimbola Olowofoyeku <african_chief@bigfoot.com>           }
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
{                                                                          }
{  v1.00, 20 Oct.  2002 - Prof. Abimbola Olowofoyeku (The African Chief)   }
{                         http://www.bigfoot.com/~African_Chief/           }
{                                                                          }
{**************************************************************************}

UNIT shellapi;

INTERFACE

CONST ABE_LEFT = 0;
CONST ABE_TOP = 1;
CONST ABE_RIGHT = 2;
CONST ABE_BOTTOM = 3;
CONST SEE_MASK_CLASSNAME = 1;
CONST SEE_MASK_CLASSKEY = 3;
CONST SEE_MASK_IDLIST = 4;
CONST SEE_MASK_INVOKEIDLIST = 12;
CONST SEE_MASK_ICON = 16;
CONST SEE_MASK_HOTKEY = 32;
CONST SEE_MASK_NOCLOSEPROCESS = 64;
CONST SEE_MASK_CONNECTNETDRV = 128;
CONST SEE_MASK_FLAG_DDEWAIT = 256;
CONST SEE_MASK_DOENVSUBST = 512;
CONST SEE_MASK_FLAG_NO_UI = 1024;
CONST SEE_MASK_UNICODE = 65536;
CONST ABM_NEW = 0;
CONST ABM_REMOVE = 1;
CONST ABM_QUERYPOS = 2;
CONST ABM_SETPOS = 3;
CONST ABM_GETSTATE = 4;
CONST ABM_GETTASKBARPOS = 5;
CONST ABM_ACTIVATE = 6;
CONST ABM_GETAUTOHIDEBAR = 7;
CONST ABM_SETAUTOHIDEBAR = 8;
CONST ABM_WINDOWPOSCHANGED = 9;
CONST ABN_STATECHANGE = 0;
CONST ABN_POSCHANGED = 1;
CONST ABN_FULLSCREENAPP = 2;
CONST ABN_WINDOWARRANGE = 3;
CONST NIM_ADD = 0;
CONST NIM_MODIFY = 1;
CONST NIM_DELETE = 2;
CONST NIF_MESSAGE = 1;
CONST NIF_ICON = 2;
CONST NIF_TIP = 4;
CONST SE_ERR_FNF = 2;
CONST SE_ERR_PNF = 3;
CONST SE_ERR_ACCESSDENIED = 5;
CONST SE_ERR_OOM = 8;
CONST SE_ERR_DLLNOTFOUND = 32;
CONST SE_ERR_SHARE = 26;
CONST SE_ERR_ASSOCINCOMPLETE = 27;
CONST SE_ERR_DDETIMEOUT = 28;
CONST SE_ERR_DDEFAIL = 29;
CONST SE_ERR_DDEBUSY = 30;
CONST SE_ERR_NOASSOC = 31;
CONST FO_MOVE = 1;
CONST FO_COPY = 2;
CONST FO_DELETE = 3;
CONST FO_RENAME = 4;
CONST FOF_MULTIDESTFILES = 1;
CONST FOF_CONFIRMMOUSE = 2;
CONST FOF_SILENT = 4;
CONST FOF_RENAMEONCOLLISION = 8;
CONST FOF_NOCONFIRMATION = 16;
CONST FOF_WANTMAPPINGHANDLE = 32;
CONST FOF_ALLOWUNDO = 64;
CONST FOF_FILESONLY = 128;
CONST FOF_SIMPLEPROGRESS = 256;
CONST FOF_NOCONFIRMMKDIR = 512;
CONST FOF_NOERRORUI = 1024;
CONST PO_DELETE = 19;
CONST PO_RENAME = 20;
CONST PO_PORTCHANGE = 32;
CONST PO_REN_PORT = 52;
CONST SHGFI_ICON = 256;
CONST SHGFI_DISPLAYNAME = 512;
CONST SHGFI_TYPENAME = 1024;
CONST SHGFI_ATTRIBUTES = 2048;
CONST SHGFI_ICONLOCATION = 4096;
CONST SHGFI_EXETYPE = 8192;
CONST SHGFI_SYSICONINDEX = 16384;
CONST SHGFI_LINKOVERLAY = 32768;
CONST SHGFI_SELECTED = 65536;
CONST SHGFI_ATTR_SPECIFIED = 131072;
CONST SHGFI_LARGEICON = 0;
CONST SHGFI_SMALLICON = 1;
CONST SHGFI_OPENICON = 2;
CONST SHGFI_SHELLICONSIZE = 4;
CONST SHGFI_PIDL = 8;
CONST SHGFI_USEFILEATTRIBUTES = 16;

IMPLEMENTATION

END.

