{
***************************************************************************
*                 cBitmaps.pas
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements some bitmap routines
*
*  It is part of the ObjectMingw object/class library
*
*  The functionality is based almost entirely on Win32 API routines,
*  and so it is not portable, except perhaps via WINE.
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal,
*  and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 08 January  2003
*  Version: 1.00
*  Licence: Shareware
*
***************************************************************************
}
UNIT cbitmaps;
{$i cwindows.inc}

INTERFACE
{$I-}
{$W-}
{$ifdef __GPC__}
  {$gnu_pascal}
{$endif}

USES
{$ifdef __GPC__}
gpc,
{$endif}
cclasses,
Sysutils,
Windows;

FUNCTION LoadBitmapFromFile ( CONST FName : String; Window : hWnd;
                            VAR Width, Height : WinInteger ) : hBitMap;

PROCEDURE PaintBitmap
          ( PaintDC : HDC; BitmapHandle : hBitmap;
          LocX, LocY, Width, Height : WinInteger;
          DisplayWindow : HWnd; StretchBitmap : Boolean );

FUNCTION GetBitmapInfo ( BitmapHandle : hBitmap;
         VAR Width, Height : WinInteger ) : WinInteger;

IMPLEMENTATION

FUNCTION GetBmpColours ( Cnt : Word ) : WinInteger;
BEGIN
  CASE Cnt OF
    1, 4, 8 : Result := 1 SHL Cnt;
    ELSE
     Result := 0;
  END; // CASE
END;

{$ifdef FPC}
TYPE TBITMAPFILEHEADER = PACKED RECORD
     bfType : Word;
     bfSize : DWord;
     bfReserved1 : Word;
     bfReserved2 : Word;
     bfOffBits : DWord;
END;
{$endif}

FUNCTION LoadBitmapFromFile
( CONST FName : String; Window : hWnd;
VAR Width, Height : WinInteger ) : hBitMap;
VAR
  Size : WinInteger;
  DC : HDC;
  BitsMem : pchar;
  BitmapHeader : TBitmapInfoHeader;
  BitMapFileHeader : TBitMapFileHeader;
  BitmapInfo : PBitmapInfo;
  BmpHandle : HBITMAP;
  ImageSize : DWord;
  F : FILE;
  OldMode : Byte;
  i : WinInteger;
BEGIN
  Result := 0;
  assign ( f, FName );
  OldMode := Filemode;
  Filemode := fmOpenRead OR fmShareCompat;
  reset ( f, 1 );
  i := Ioresult;
  Filemode := OldMode;
  IF i <> 0 THEN Exit;

  BlockRead ( F, BitMapFileHeader, SizeOf ( BitMapFileHeader ) );
  BlockRead ( F, BitMapHeader, SizeOf ( BitMapHeader ) );
  ImageSize := WinInteger ( BitMapFileHeader.bfSize ) - SizeOf ( BitMapFileHeader );

  WITH BitmapHeader
  DO BEGIN
     IF biClrUsed = 0 THEN biClrUsed := GetBmpColours ( biBitCount );
     Size := biClrUsed * SizeOf ( TRgbQuad );
  END;

  Getmem ( BitmapInfo, Size + SizeOf ( TBitmapInfoHeader ) );
  WITH BitmapInfo^
  DO BEGIN
     bmiHeader := BitmapHeader;
     BlockRead ( f, bmiColors, Size );
     WITH bmiHeader
     DO BEGIN
        Dec ( ImageSize, SizeOf ( TBitmapInfoHeader ) + Size );
        IF biSizeImage <> 0
        THEN BEGIN
             IF biSizeImage < ImageSize THEN ImageSize := biSizeImage;
        END;
        Getmem ( BitsMem, ImageSize );
        BlockRead ( f, BitsMem^, ImageSize );
        close ( f );
        DC := GetDC ( Window );
        IF DC = 0 THEN Exit;

        // create the bitmap
        BmpHandle := CreateDIBitmap
                    ( DC, BitmapInfo^.bmiHeader, CBM_INIT,
                      BitsMem, BitmapInfo^,
                      DIB_RGB_COLORS );
        IF BmpHandle = 0
        THEN BEGIN
           FreeMem ( BitsMem );
           FreeMem ( BitmapInfo );
           Exit;
        END;
      END;
      ReleaseDC ( Window, DC );
  END;
  Height := BitmapHeader.biHeight;
  Width := BitmapHeader.biWidth;
  FreeMem ( BitsMem );
  FreeMem ( BitmapInfo );
  Result := BmpHandle;
END;

FUNCTION GetBitmapInfo ( BitmapHandle : hBitmap; VAR Width, Height : WinInteger ) : WinInteger;
VAR
  xBitmapSizeInfo : TBitmap;
BEGIN
  Result :=  GetObject ( BitmapHandle, SizeOf ( xBitmapSizeInfo ), @xBitmapSizeInfo );
  IF Result <> 0
  THEN BEGIN
    Width := xBitmapSizeInfo.bmWidth;
    Height := xBitmapSizeInfo.bmHeight;
  END;
END;

PROCEDURE PaintBitmap
( PaintDC : HDC; BitmapHandle : hBitmap;
  LocX, LocY, Width, Height : WinInteger;
  DisplayWindow : HWnd; StretchBitmap : Boolean );
VAR
  MemoryDC : HDC;
  OldBitmapHandle : THandle;
  R : TRect;
  Mode : WinInteger;
BEGIN
  IF BitmapHandle <> 0
  THEN BEGIN
    MemoryDC := CreateCompatibleDC ( PaintDC );
    OldBitmapHandle := SelectObject ( MemoryDC, BitmapHandle );
    GetClientRect ( DisplayWindow, R );
    IF ( StretchBitmap ) THEN GetBitmapInfo ( BitmapHandle, Width, Height );
    Mode := srcCopy;
    IF StretchBitmap
      THEN StretchBlt ( PaintDC, 0, 0, R.Right, R.Bottom,
                        MemoryDC, 0, 0,
                        Width, Height, Mode )
         ELSE BitBlt ( PaintDC, LocX, LocY, Width, Height, MemoryDC, 0, 0, Mode );
    SelectObject ( MemoryDC, OldBitmapHandle );
    DeleteDC ( MemoryDC );
  END;
END;

END.

