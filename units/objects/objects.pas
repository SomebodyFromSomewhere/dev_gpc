{************[ SOURCE FILE OF FREE VISION ]*********************}
{                                                               }
{    System independent clone of objects.pas                    }
{                                                               }
{    Parts Copyright (c) 1992,96 by Florian Klaempfl            }
{    fnklaemp@cip.ft.uni-erlangen.de                            }
{                                                               }
{    Parts Copyright (c) 1996 by Frank ZAGO                     }
{    zago@ecoledoc.ipc.fr                                       }
{                                                               }
{    Parts Copyright (c) 1995 by MH Spiegel                     }
{                                                               }
{    Parts Copyright (c) 1996, 1997 by Leon de Boer             }
{    ldeboer@ibm.net                                            }
{                                                               }
{    Parts Copyright (c) 1999-2004 by Prof Abimbola Olowofoyeku }
{    chiefsoft at bigfoot dot com                               }
{                                                               }
{    Free Vision project coordinator Balazs Scheidler           }
{    bazsi@tas.vein.hu                                          }
{                                                               }
{    Download FV at ftp site                                    }
{    ftp://ftp.tolna.hungary.net/pub/fpk-pascal                 }
{                                                               }
{****************[ THIS CODE IS FREEWARE ]**********************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This sourcecode is distributed "AS IS" without       }
{   warranty, express, implied or statutory, including     }
{   but not limited to any implied warranties of any       }
{   merchantability and fitness for a particular purpose.  }
{   In no event shall anyone involved with the creation    }
{   and production of this product be liable for indirect, }
{   special, or consequential damages, arising out of any  }
{   use thereof or breach of any warranty.                 }
{                                                          }
{**********************************************************}

{*****************[ SUPPORTED PLATFORMS ]******************}
{     16 and 32 Bit compilers                              }
{        DOS      - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - FPC ?.??+               (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{        DPMI     - Turbo Pascal 7.0 +      (16 Bit)       }
{        LINUX    - FPC ?.??+               (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{        WINDOWS  - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - Delphi 1.0+             (16 Bit)       }
{                 - Delphi 3.0+             (32 Bit)       }
{        WIN95    - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - Delphi 3.0+             (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{                 - TMT 3.50+               (32 Bit)       }
{        WIN/NT   - Delphi 3.0+             (32 Bit)       }
{                 - Virtual Pascal 2.0+     (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{                 - TMT 3.50+               (32 Bit)       }
{        WIN2K    - Delphi 3.0+             (32 Bit)       }
{                 - Virtual Pascal 2.0+     (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{                 - TMT 3.50+               (32 Bit)       }
{        WINXP    - Delphi 3.0+             (32 Bit)       }
{                 - Virtual Pascal 2.0+     (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{                 - TMT 3.50+               (32 Bit)       }
{        OS2      - Virtual Pascal 0.3+     (32 Bit)       }
{                 - GPC v2.1                (32 Bit)       }
{        VARIOUS UNICES AND OTHER PLATFORMS                }
{                 - GPC v2.1                (32/64-Bit)    }
{                                                          }
{******************[ REVISION HISTORY ]********************}
{  Version  Date        Fix                                }
{  -------  ---------   ---------------------------------  }
{  1.00     12 Jun 96   First multi platform release       }
{  1.01     20 Jun 96   Fixes to TCollection               }
{  1.02     07 Aug 96   Fixed TStringCollection.Compare    }
{  1.10     18 Jul 97   Windows 95 support added.          }
{  1.11     21 Aug 97   FPC pascal 0.92 implemented        }
{  1.15     26 Aug 97   TXMSStream compatability added     }
{                       TEMSStream compatability added     }
{  1.30     29 Aug 97   Platform.inc sort added.           }
{  1.32     02 Sep 97   RegisterTypes completed.           }
{  1.37     04 Sep 97   TStream.Get & Put completed.       }
{  1.40     04 Sep 97   LongMul & LongDiv added.           }
{  1.45     04 Sep 97   Refined and passed all tests.      }
{                       FPC - bugged on register records!  }
{  1.50     05 May 98   Fixed DOS Access to files, one     }
{                       version for all intel platforms    }
{                       (CEC)                              }
{  1.60     22 Oct 97   Delphi3 32 bit code added.         }
{  1.70     05 Feb 98   Speed pascal code added.           }
{  1.80     05 May 98   Virtual pascal 2.0 compiler added. }
{  1.90     14 Feb 99   GNU Pascal (GPC)2.1 compiler added.}
{                       Delphi 2.0 support fixed           }
{                                                          }
{  2.00     45 Oct 02   Delphi7.0 and TMT Pascal support   }
{                       added.                             }
{                                                          }
{                                                          }
{**********************************************************}

UNIT objects;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$IFNDEF FPC}     { FPC doesn't support these switches in 0.99.5 }
{$ifndef PPC_GPC} { These switches are meaningless/redundant under GPC }
  {$F+} { Force far calls }
  {$A+} { Word Align Data }
  {$O+} { This unit may be overlaid }
  {$G+} { 286 Code optimization - if you're on an 8088 get a real computer }
 {$endif}
  {$B-} { Allow short circuit boolean evaluations }
{$ENDIF}

  {$I-} { Disable IO Checking }
  {$X+} { Extended syntax is ok }
  {$R-} { Disable range checking }
  {$S-} { Disable Stack Checking }

{$ifndef PPC_GPC} { These switches are meaningless under GPC }
  {$E+} { Emulation is on }
  {$N-} { No 80x87 code generation }
{$endif}

{$ifndef PPC_GPC} { GPC doesn't yet support these switches }
  {$Q-} { Disable Overflow Checking }
  {$V-} { Turn off strict VAR strings }
{$endif}

{$ifdef PPC_DELPHI32}
  {$J+}  { rewriteable consts }
{$endif}

{====================================================================}
{$IFDEF PPC_GPC}
  USES
  GPC,
  SYSTEM;
{$endif}

{$IFDEF OS_WINDOWS}                                   { WIN/NT UNITS }
USES
{$ifdef HAS_EXCEPTIONS}
Sysutils,
{$endif}
{$ifdef BIT_32}
Windows;
{$else}
WinTypes, WinProcs;
{$endif}
{ Standard units }
{$ENDIF}

{----- are we using BP-style short strings? -----}
{$IFDEF PPC_GPC}
 {$define NON_BP_STRINGS}
{$else}
  {$ifdef PPC_DELPHI}
    {$ifndef ver80}
      {$IFOPT H+}
       {$define NON_BP_STRINGS}
      {$endif}
    {$endif}
  {$endif}
{$endif}
{***************************************************************************}
{                             PUBLIC CONSTANTS                              }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                          STREAM ERROR STATE MASKS                         }
{---------------------------------------------------------------------------}
CONST
   stOk         =  0;                                 { No stream error }
   stError      = - 1;                                 { Access error }
   stInitError  = - 2;                                 { Initialize error }
   stReadError  = - 3;                                 { Stream read error }
   stWriteError = - 4;                                 { Stream write error }
   stGetError   = - 5;                                 { Get object error }
   stPutError   = - 6;                                 { Put object error }
   stSeekError  = - 7;                                 { Seek error in stream }
   stOpenError  = - 8;                                 { Error opening stream }

{---------------------------------------------------------------------------}
{                        STREAM ACCESS MODE CONSTANTS                       }
{---------------------------------------------------------------------------}
CONST
   stCreate    = $3C00;                               { Create new file }
   stOpenRead  = $3D00;                               { Read access only }
   stOpenWrite = $3D01;                               { Write access only }
   stOpen      = $3D02;                               { Read/write access }

{$IFDEF OS_DOS}                                       { DOS SHARE CONSTANTS }
{---------------------------------------------------------------------------}
{                       NEW FILE SHARE MODE CONSTANTS                       }
{---------------------------------------------------------------------------}
CONST
   fmDenyAll   = $0010;                               { Exclusive file use }
   fmDenyWrite = $0020;                               { Deny write access }
   fmDenyRead  = $0030;                               { Deny read access }
   fmDenyNone  = $0040;                               { Deny no access }
{$ENDIF}

{$IFDEF PPC_GPC}                                      { USE SHARE CONSTANTS also for GPC }
{---------------------------------------------------------------------------}
{                       NEW FILE SHARE MODE CONSTANTS                       }
{---------------------------------------------------------------------------}
CONST
   fmDenyAll   = $0010;                               { Exclusive file use }
   fmDenyWrite = $0020;                               { Deny write access }
   fmDenyRead  = $0030;                               { Deny read access }
   fmDenyNone  = $0040;                               { Deny no access }
{$ENDIF}

{---------------------------------------------------------------------------}
{                          TCollection ERROR CODES                          }
{---------------------------------------------------------------------------}
CONST
   coIndexError = - 1;                                 { Index out of range }
   coOverflow   = - 2;                                 { Overflow }

{---------------------------------------------------------------------------}
{         VMT HEADER CONSTANT - HOPEFULLY WE CAN DROP THIS LATER            }
{---------------------------------------------------------------------------}
{$IFDEF PPC_Virtual}                                  { Virtual is different }
CONST
   vmtHeaderSize = 12;                                { VMT header size }
{$ELSE}
CONST
   vmtHeaderSize = 8;                                 { VMT header size }
{$ENDIF}

{ ******************************* REMARK ****************************** }
{  New data types have been added to this unit to clarify the sizes     }
{  of the data types that are being used. This does not affect the      }
{  functionality of the unit - but it does deal with the problem of     }
{  cases where the assumed sizes are different under different systems  }
{  (e.g., "Word" is not always 16-bit - it is 32-bit under GPC, and     }
{  needs to be redefined here for 16-bit use; and "String" does not     }
{  always mean fixed strings of 255 characters maximum - it could mean  }
{  different things under Delphi or GPC). With the redefinitions that   }
{  follow, any required changes for a platform needs only be made in    }
{  one place.                                                           }
{ ***************** END REMARK *** Prof Abimbola A Olowofoyeku, 14Feb99 }
{$ifdef PPC_GPC}                { new 16-bit word and string types, etc }
 TYPE
    Word16   = Cardinal attribute ( Size=16 );  { normal GPC words are 32-bit }
    Int32    = Integer attribute ( Size=32 );
    Longint  = Integer attribute ( Size=32 );   { normal GPC longints are 64-bit }
    sw_String = TString;
{$else}
 TYPE
    Word16   = Word;                                  { 16-bit word }
    Int32    = Longint;
    sw_String = String;                                { normal string }
{$endif}

CONST
{---------------------------------------------------------------------------}
{                            MAXIUM DATA SIZES                              }
{---------------------------------------------------------------------------}
{$IFDEF BIT_16}                                       { 16 BIT DEFINITION }
   MaxBytes = 65520;                                  { Maximum data size }
{$ENDIF}
{$IFDEF BIT_32}                                       { 32 BIT DEFINITION }
   MaxBytes = 128 * 1024 * 1024;                      { Maximum data size }
{$ENDIF}
{$IFDEF PPC_GPC}                                      { GPC definition: some GPC platforms are 64-bit }
   MaxBytes = 1 SHL ( BitSizeOf ( Pointer ) - 4 );    { maximum data size }
{$ENDIF}

   MaxWords = MaxBytes DIV SizeOf ( Word16 );            { Max word data size }
   MaxPtrs  = MaxBytes DIV SizeOf ( Pointer );           { Max ptr data size }
   MaxCollectionSize = MaxBytes DIV SizeOf ( Pointer );  { Max collection size }

{***************************************************************************}
{                          PUBLIC TYPE DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                               CHARACTER SET                               }
{---------------------------------------------------------------------------}
TYPE
   TCharSet = SET OF Char;                            { Character set }
   PCharSet = ^TCharSet;                              { Character set ptr }

{---------------------------------------------------------------------------}
{                               GENERAL ARRAYS                              }
{---------------------------------------------------------------------------}
TYPE
   TByteArray = ARRAY [0..MaxBytes - 1] OF Byte;      { Byte array }
   PByteArray = ^TByteArray;                          { Byte array pointer }

   TWordArray = ARRAY [0..MaxWords - 1] OF Word16;    { Word array }
   PWordArray = ^TWordArray;                          { Word array pointer }

   TPointerArray = ARRAY [0..MaxPtrs - 1] OF Pointer; { Pointer array }
   PPointerArray = ^TPointerArray;                    { Pointer array ptr }

{---------------------------------------------------------------------------}
{                             POINTER TO STRING                             }
{---------------------------------------------------------------------------}
{$ifndef __GPC__}
TYPE
   PString = ^sw_String;                                 { String pointer }
{$endif}
{---------------------------------------------------------------------------}
{                            DOS FILENAME STRING                            }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF OS_DOS}                                       { DOS/DPMI DEFINE }
   FNameStr = String [79];                             { DOS filename }
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT DEFINE }
   FNameStr = PChar;                                  { Windows filename }
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 DEFINE }
   FNameStr = String;                                 { OS2 filename }
{$ENDIF}
{$IFDEF OS_LINUX}                                     { LINUX DEFINE }
   FNameStr = String;                                 { Linux filename }
{$ENDIF}
{$IFDEF OS_AMIGA}                                     { AMIGA DEFINE }
   FNameStr = String;                                 { Amiga filename }
{$ENDIF}
{$IFDEF OS_ATARI}                                     { ATARI DEFINE }
   FNameStr = String [79];                             { Atari filename }
{$ENDIF}
{$IFDEF OS_MAC}                                       { MACINTOSH DEFINE }
    FNameStr = String;                                { Mac filename }
{$ENDIF}
{$IFDEF PPC_GPC}                                      { GPC DEFINE }
   FNameStr = TString;                                { GPC filename }
{$ENDIF}

{$IFDEF PPC_TMT_DOS}
//   FNameStr = String;                                { TMT DOS filename }
{$ENDIF}

{---------------------------------------------------------------------------}
{                            DOS ASCIIZ FILENAME                            }
{---------------------------------------------------------------------------}
TYPE
   AsciiZ = {$IFDEF PPC_GPC}TStringBuf{$ELSE}ARRAY [0..255] OF Char{$ENDIF};  { Filename array }

{---------------------------------------------------------------------------}
{                        BIT SWITCHED TYPE CONSTANTS                        }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF BIT_16}                                       { 16 BIT DEFINITIONS }
   Sw_Word    = Word;                                 { Standard word }
   Sw_Integer = Integer;                              { Standard integer }
{$ENDIF}

{$IFDEF BIT_32}                                       { 32 BIT DEFINITIONS }
   Sw_Word    = {$ifdef ver90}Integer{$else}Longint{$endif}; { Long integer now }
   Sw_Integer = LongInt;                              { Long integer now }
{$ENDIF}

{$IFDEF PPC_GPC}                                      { GPC DEFINITIONS }
   Sw_Word    = Cardinal;                             { standard GPC word = 32-bit }
   Sw_Integer = Integer;                              { standard GPC integer = 32-bit }
{$ENDIF}

{$ifdef Word_DWord}
  dw_DWord = DWord;
{$else}
  dw_DWord = sw_Word;
{$endif}

{---------------------------------------------------------------------------}
{                           FILE HANDLE SIZE                                }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF OS_DOS}                                       { DOS DEFINITION }
   THandle = Integer;                                 { Handles are 16 bits }
{$ENDIF}
{$IFDEF OS_ATARI}                                     { ATARI DEFINITION }
   THandle = Integer;                                 { Handles are 16 bits }
{$ENDIF}
{$IFDEF OS_LINUX}                                     { LINUX DEFINITIONS }
 { values are words, though the OS calls return 32-bit values }
 { to check (CEC)                                             }
  THandle = LongInt;                                  { Simulated 32 bits }
{$ENDIF}
{$IFDEF OS_AMIGA}                                     { AMIGA DEFINITIONS }
  THandle = LongInt;                                  { Handles are 32 bits }
{$ENDIF}
{$IFDEF OS_WINDOWS}                                   { WIN/NT DEFINITIONS }
  THandle = sw_Integer;                               { Can be either }
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 DEFINITIONS }
  THandle = sw_Integer;                               { Can be either }
{$ENDIF}
{$IFDEF OS_MAC}                                       { MACINTOSH DEFINITIONS }
  THandle = LongInt;                                  { Handles are 32 bits }
{$ENDIF}

{$ifdef PPC_GPC}
   THandle = PtrInt;                                  { GPC - use integer of same size as pointers }
{$endif}

{$IFDEF PPC_TMT_DOS}
//  THandle = LongInt;                                  { Handles are 32 bits }
{$ENDIF}

{***************************************************************************}
{                        PUBLIC RECORD DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                          TYPE CONVERSION RECORDS                          }
{---------------------------------------------------------------------------}
TYPE
{$ifdef PPC_GPC}
   WordRec = PACKED RECORD { 16 bit word to bytes }
     {$ifdef __BYTES_BIG_ENDIAN__}
     Hi, Lo : Byte;
     {$else}
     Lo, Hi : Byte;
     {$endif}
   END;

   LongRec = PACKED RECORD { 32 bit word/integer to 16 bit words }
     {$ifdef __BYTES_BIG_ENDIAN__}
     Hi, Lo : Word16;
     {$else}
     Lo, Hi : Word16;
     {$endif}
   END;

 {$else}
   WordRec = PACKED RECORD
     Lo, Hi : Byte;                                    { Word to bytes }
   END;

   LongRec = PACKED RECORD
     Lo, Hi : Word;                                    { LongInt to words }
   END;

   PtrRec = PACKED RECORD
     Ofs, Seg : Word;                                  { Pointer to words }
   END;
  {$endif}
{---------------------------------------------------------------------------}
{                  TStreamRec RECORD - STREAM OBJECT RECORD                 }
{---------------------------------------------------------------------------}
TYPE
   PStreamRec = ^TStreamRec;                          { Stream record ptr }
   TStreamRec = RECORD
      ObjType : Sw_Word;                               { Object type id }
      {$IFDEF BP_VmtLink}
      VmtLink : Sw_Word;                               { VMT link like BP }
      {$ELSE}
      VmtLink : Pointer;                               { Delphi3/FPC like VMT }
      {$ENDIF}
      Load : Pointer;                                 { Object load code }
      Store : Pointer;                                 { Object store code }
      Next : PStreamRec;                              { Next stream record }
   END;

{***************************************************************************}
{                        PUBLIC OBJECT DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                        TPoint OBJECT - POINT OBJECT                       }
{---------------------------------------------------------------------------}
TYPE
   TPoint = OBJECT
      X, Y : Integer;
   END;
   PPoint = ^TPoint;

{ ******************************* REMARK ****************************** }
{ Delphi 2.0 has a problem with using an object type before its         }
{ definition is complete. I have had to change the TRECT parameters     }
{ here to PRECTs for Delphi 2.0. This introduces a slight incompatibi-  }
{ lity with Delphi 2.0 - but at least the unit will now compile.        }
{ The parameters have been changed to CONST parameters to avoid         }
{ accidentally changing the actual parameters passed as PRECTs.         }
{ **************** END REMARK *** Prof Abimbola A Olowofoyeku, 16Feb99  }
{---------------------------------------------------------------------------}
{                      TRect OBJECT - RECTANGLE OBJECT                      }
{---------------------------------------------------------------------------}
   PRect = ^TRect;
   TRect = OBJECT
         A, B : TPoint;                                { Corner points }
      FUNCTION Empty : Boolean;
      FUNCTION Equals ( CONST R : {$ifdef ver90}PRect{$else}TRect{$endif} ) : Boolean;
      FUNCTION Contains ( CONST P : TPoint ) : Boolean;
      PROCEDURE Copy ( CONST R : {$ifdef ver90}PRect{$else}TRect{$endif} );
      PROCEDURE Union ( CONST R : {$ifdef ver90}PRect{$else}TRect{$endif} );
      PROCEDURE Intersect ( CONST R : {$ifdef ver90}PRect{$else}TRect{$endif} );
      PROCEDURE Move ( ADX, ADY : Integer );
      PROCEDURE Grow ( ADX, ADY : Integer );
      PROCEDURE Assign ( XA, YA, XB, YB : Integer );
   END;

{---------------------------------------------------------------------------}
{                  TObject OBJECT - BASE ANCESTOR OBJECT                    }
{---------------------------------------------------------------------------}
TYPE
   TObject = OBJECT
      CONSTRUCTOR Init;
      PROCEDURE Free;
      DESTRUCTOR Done;                                               VIRTUAL;
   END;
   PObject = ^TObject;

{ ******************************* REMARK ****************************** }
{  Two new virtual methods have been added to the object in the form of }
{  Close and Open. The main use here is in the Disk Based Descendants   }
{  the calls open and close the given file so these objects can be      }
{  used like standard files. Two new fields have also been added to     }
{  speed up seeks on descendants. All existing code will compile and    }
{  work completely normally oblivious to these new methods and fields.  }
{ ****************************** END REMARK *** Leon de Boer, 15May96 * }

{ ******************************* REMARK ****************************** }
{ Delphi 2.0 has a problem with using an object type before its         }
{ definition is complete. I have had to change the TSTREAM parameter    }
{ here to PSTREAM for Delphi 2.0. This introduces a slight incompati-   }
{ bility with Delphi 2.0 - but at least the unit will now compile.      }
{ **************** END REMARK *** Prof Abimbola A Olowofoyeku, 16Feb99  }
{---------------------------------------------------------------------------}
{                 TStream OBJECT - STREAM ANCESTOR OBJECT                   }
{---------------------------------------------------------------------------}
TYPE
   PStream = ^TStream;
   TStream = OBJECT ( TObject )
         Status    : Integer;                         { Stream status }
         ErrorInfo : Integer;                         { Stream error info }
         StreamSize : LongInt;                         { Stream current size }
         Position  : LongInt;                         { Current position }
      CONSTRUCTOR Init;
      FUNCTION Get : PObject;
      FUNCTION StrRead : PChar;
      FUNCTION GetPos : LongInt;                                      VIRTUAL;
      FUNCTION GetSize : LongInt;                                     VIRTUAL;
      FUNCTION ReadStr : PString;
      PROCEDURE Open ( OpenMode : Word16 );                          VIRTUAL;
      PROCEDURE Close;                                               VIRTUAL;
      PROCEDURE Reset;
      PROCEDURE Flush;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Put ( P : PObject );
      PROCEDURE StrWrite ( P : PChar );
      PROCEDURE WriteStr ( P : PString );
      PROCEDURE Seek ( Pos : LongInt );                                 VIRTUAL;
      PROCEDURE Error ( Code, Info : Integer );                         VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Sw_Word );                      VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Sw_Word );                     VIRTUAL;
      PROCEDURE CopyFrom ( {$ifdef ver90}VAR S : PStream{$else}VAR S : TStream{$endif}; Count : LongInt );
   END;

{ ******************************* REMARK ****************************** }
{   A few minor changes to this object and an extra field added called  }
{  FName which holds an AsciiZ array of the filename this allows the    }
{  streams file to be opened and closed like a normal text file. All    }
{  existing code should work without any changes.                       }
{ ****************************** END REMARK *** Leon de Boer, 19May96 * }

{---------------------------------------------------------------------------}
{                TDosStream OBJECT - DOS FILE STREAM OBJECT                 }
{---------------------------------------------------------------------------}
TYPE
   TDosStream = OBJECT ( TStream )
         Handle : THandle;                            { DOS file handle }
         FName : AsciiZ;                              { AsciiZ filename }
         BufferCount : sw_Word;                       { Number of bytes read/written }
      CONSTRUCTOR Init ( FileName : FNameStr; Mode : Word16 );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Close;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Seek ( Pos : LongInt );                                 VIRTUAL;
      PROCEDURE Open ( OpenMode : Word16 );                               VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Sw_Word );                      VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Sw_Word );                     VIRTUAL;
   END;
   PDosStream = ^TDosStream;

{ ******************************* REMARK ****************************** }
{   A few minor changes to this object and an extra field added called  }
{  lastmode which holds the read or write condition last using the      }
{  speed up buffer which helps speed up the flush, position and size    }
{  functions. All existing code should work without any changes.        }
{ ****************************** END REMARK *** Leon de Boer, 19May96 * }

{---------------------------------------------------------------------------}
{                TBufStream OBJECT - BUFFERED DOS FILE STREAM               }
{---------------------------------------------------------------------------}
TYPE
   TBufStream = OBJECT ( TDosStream )
         LastMode : Byte;                              { Last buffer mode }
         BufSize : Sw_Word;                           { Buffer size }
         BufPtr  : Sw_Word;                           { Buffer start }
         BufEnd  : Sw_Word;                           { Buffer end }
         Buffer  : PByteArray;                        { Buffer allocated }
      CONSTRUCTOR Init ( FileName : FNameStr; Mode, Size : Word16 );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Close;                                               VIRTUAL;
      PROCEDURE Flush;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Seek ( Pos : LongInt );                                 VIRTUAL;
      PROCEDURE Open ( OpenMode : Word16 );                               VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Sw_Word );                      VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Sw_Word );                     VIRTUAL;
   END;
   PBufStream = ^TBufStream;

{---------------------------------------------------------------------------}
{                TFileStream OBJECT: Prof A Olowofoyeku, 14May 2001         }
{---------------------------------------------------------------------------}
TFileStream = OBJECT ( TBufStream )
  CONSTRUCTOR Init ( FileName : FNameStr; Mode : Word16 );
  FUNCTION    Size : Longint;
END;


{ ******************************* REMARK ****************************** }
{  All the changes here should be completely transparent to existing    }
{  code. Basically the memory blocks do not have to be base segments    }
{  but this means our list becomes memory blocks rather than segments.  }
{  The stream will also expand like the other standard streams!!        }
{ ****************************** END REMARK *** Leon de Boer, 19May96 * }

{---------------------------------------------------------------------------}
{               TMemoryStream OBJECT - MEMORY STREAM OBJECT                 }
{---------------------------------------------------------------------------}
TYPE
   TMemoryStream = OBJECT ( TStream )
         BlkCount : Sw_Word;                           { Number of segments }
         BlkSize : Word16;                              { Memory block size }
         MemSize : LongInt;                           { Memory alloc size }
         BlkList : PPointerArray;                     { Memory block list }
      CONSTRUCTOR Init ( ALimit : LongInt; ABlockSize : Word16 );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Sw_Word );                      VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Sw_Word );                     VIRTUAL;
      {$ifndef PPC_GPC}PRIVATE{$endif} { GPC doesn't yet support private methods/fields }
      FUNCTION ChangeListSize ( ALimit : Sw_Word ) : Boolean;
   END;
   PMemoryStream = ^TMemoryStream;

{ ******************************* REMARK ****************************** }
{  This object under all but real mode DOS is simple a TMemoryStream    }
{  by another name. Under real mode DOS programs it use XMSOBJ.INC to   }
{  create an XMS memory stream object similar to the standard EMS one.  }
{ ****************************** END REMARK *** Leon de Boer, 14Aug98 * }

{---------------------------------------------------------------------------}
{                  TXmsStream OBJECT - XMS STREAM OBJECT                    }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF PROC_Real}                                    { DOS REAL MODE CODE }
   TXmsStream = OBJECT ( TStream )
         Handle    : Word16;                            { XMS handle number }
         BlocksUsed : Word16;                            { XMS blocks in use }
         MemSize   : LongInt;                         { XMS alloc size }
      CONSTRUCTOR Init ( MinSize, MaxSize : LongInt );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Word16 );                         VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Word16 );                        VIRTUAL;
   END;
{$ELSE}                                               { DPMI/WIN/NT/OS2 CODE }
   TXmsStream = OBJECT ( TMemoryStream )                { Memory stream object }
      CONSTRUCTOR Init ( MinSize, MaxSize : LongInt );
   END;
{$ENDIF}
   PXmsStream = ^TXmsStream;                          { XMS stream pointer }

{ ******************************* REMARK ****************************** }
{  This object under all but real mode DOS is simple a TMemoryStream    }
{  by another name. Under real mode DOS programs it use EMSOBJ.INC to   }
{  copy the standard EMS stream object as per Borland's original unit.  }
{ ****************************** END REMARK *** Leon de Boer, 14Aug98 * }

{---------------------------------------------------------------------------}
{                  TEmsStream OBJECT - EMS STREAM OBJECT                    }
{---------------------------------------------------------------------------}
TYPE
{$IFDEF PROC_Real}                                    { DOS REAL MODE CODE }
   TEmsStream = OBJECT ( TStream )
         Handle   : Word16;                             { EMS handle }
         PageCount : Word16;                             { Pages allocated }
         MemSize  : LongInt;                          { EMS alloc size }
      CONSTRUCTOR Init ( MinSize, MaxSize : LongInt );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Truncate;                                            VIRTUAL;
      PROCEDURE Read ( VAR Buf; Count : Word16 );                         VIRTUAL;
      PROCEDURE Write ( VAR Buf; Count : Word16 );                        VIRTUAL;
   END;
{$ELSE}                                               { DPMI/WIN/OS2 CODE }
   TEmsStream = OBJECT ( TMemoryStream )                { Memory stream object }
      CONSTRUCTOR Init ( MinSize, MaxSize : LongInt );
   END;
{$ENDIF}
   PEmsStream = ^TEmsStream;                          { EMS stream pointer }

TYPE
  TItemList = ARRAY [0..MaxCollectionSize - 1] OF Pointer;
  PItemList = ^TItemList;

{ ******************************* REMARK ****************************** }
{    The changes here look worse than they are. The Sw_Integer simply   }
{  switches between Integers and LongInts if switched between 16 and 32 }
{  bit code. All existing code will compile without any changes.        }
{ ****************************** END REMARK *** Leon de Boer, 10May96 * }

{---------------------------------------------------------------------------}
{              TCollection OBJECT - COLLECTION ANCESTOR OBJECT              }
{---------------------------------------------------------------------------}
   TCollection = OBJECT ( TObject )
         Items : PItemList;                            { Item list pointer }
         Count : Sw_Integer;                           { Item count }
         Limit : Sw_Integer;                           { Item limit count }
         Delta : Sw_Integer;                           { Inc delta size }
      CONSTRUCTOR Init ( ALimit, ADelta : Sw_Integer );
      CONSTRUCTOR Load ( VAR S : TStream );
      DESTRUCTOR Done;                                               VIRTUAL;
      FUNCTION At ( Index : Sw_Integer ) : Pointer;
      FUNCTION IndexOf ( Item : Pointer ) : Sw_Integer;                  VIRTUAL;
      FUNCTION GetItem ( VAR S : TStream ) : Pointer;                    VIRTUAL;
      FUNCTION LastThat ( Test : Pointer ) : Pointer;
      FUNCTION FirstThat ( Test : Pointer ) : Pointer;
      PROCEDURE Pack;
      PROCEDURE FreeAll;
      PROCEDURE DeleteAll;
      PROCEDURE Free ( Item : Pointer );
      PROCEDURE Insert ( Item : Pointer );                              VIRTUAL;
      PROCEDURE Delete ( Item : Pointer );                              VIRTUAL;
      PROCEDURE AtFree ( Index : Sw_Integer );
      PROCEDURE FreeItem ( Item : Pointer );                            VIRTUAL;
      PROCEDURE AtDelete ( Index : Sw_Integer );
      PROCEDURE ForEach ( Action : Pointer );
      PROCEDURE SetLimit ( ALimit : Sw_Integer );                       VIRTUAL;
      PROCEDURE Error ( Code, Info : Integer );                         VIRTUAL;
      PROCEDURE AtPut ( Index : Sw_Integer; Item : Pointer );
      PROCEDURE AtInsert ( Index : Sw_Integer; Item : Pointer );        VIRTUAL;
      PROCEDURE Store ( VAR S : TStream );
      PROCEDURE PutItem ( VAR S : TStream; Item : Pointer );             VIRTUAL;
   END;
   PCollection = ^TCollection;

{---------------------------------------------------------------------------}
{          TSortedCollection OBJECT - SORTED COLLECTION ANCESTOR            }
{---------------------------------------------------------------------------}
TYPE
   TSortedCollection = OBJECT ( TCollection )
         Duplicates : Boolean;                         { Duplicates flag }
      CONSTRUCTOR Init ( ALimit, ADelta : Sw_Integer );
      CONSTRUCTOR Load ( VAR S : TStream );
      FUNCTION KeyOf ( Item : Pointer ) : Pointer;                       VIRTUAL;
      FUNCTION IndexOf ( Item : Pointer ) : Sw_Integer;                  VIRTUAL;
      FUNCTION Compare ( Key1, Key2 : Pointer ) : Sw_Integer;            VIRTUAL;
      FUNCTION Search ( Key : Pointer; VAR Index : Sw_Integer ) : Boolean;VIRTUAL;
      PROCEDURE Insert ( Item : Pointer );                              VIRTUAL;
      PROCEDURE Store ( VAR S : TStream );
   END;
   PSortedCollection = ^TSortedCollection;

{---------------------------------------------------------------------------}
{           TStringCollection OBJECT - STRING COLLECTION OBJECT             }
{---------------------------------------------------------------------------}
TYPE
   TStringCollection = OBJECT ( TSortedCollection )
      FUNCTION GetItem ( VAR S : TStream ) : Pointer;                    VIRTUAL;
      FUNCTION Compare ( Key1, Key2 : Pointer ) : Sw_Integer;            VIRTUAL;
      PROCEDURE FreeItem ( Item : Pointer );                            VIRTUAL;
      PROCEDURE PutItem ( VAR S : TStream; Item : Pointer );             VIRTUAL;
   END;
   PStringCollection = ^TStringCollection;

{---------------------------------------------------------------------------}
{             TStrCollection OBJECT - STRING COLLECTION OBJECT              }
{---------------------------------------------------------------------------}
TYPE
   TStrCollection = OBJECT ( TSortedCollection )
      FUNCTION Compare ( Key1, Key2 : Pointer ) : Sw_Integer;            VIRTUAL;
      FUNCTION GetItem ( VAR S : TStream ) : Pointer;                    VIRTUAL;
      PROCEDURE FreeItem ( Item : Pointer );                            VIRTUAL;
      PROCEDURE PutItem ( VAR S : TStream; Item : Pointer );             VIRTUAL;
   END;
   PStrCollection = ^TStrCollection;

{ ******************************* REMARK ****************************** }
{    This is a completely >> NEW << object which holds a collection of  }
{  strings but does not alphabetically sort them. It is a very useful   }
{  object for insert ordered list boxes!                                }
{ ****************************** END REMARK *** Leon de Boer, 15May96 * }

{---------------------------------------------------------------------------}
{        TUnSortedStrCollection - UNSORTED STRING COLLECTION OBJECT         }
{---------------------------------------------------------------------------}
TYPE
   TUnSortedStrCollection = OBJECT ( TStringCollection )
      PROCEDURE Insert ( Item : Pointer );                              VIRTUAL;
   END;
   PUnSortedStrCollection = ^TUnSortedStrCollection;

{---------------------------------------------------------------------------}
{         TResourceCollection OBJECT - RESOURCE COLLECTION OBJECT           }
{---------------------------------------------------------------------------}
TYPE
   TResourceCollection = OBJECT ( TStringCollection )
      FUNCTION KeyOf ( Item : Pointer ) : Pointer;                       VIRTUAL;
      FUNCTION GetItem ( VAR S : TStream ) : Pointer;                    VIRTUAL;
      PROCEDURE FreeItem ( Item : Pointer );                            VIRTUAL;
      PROCEDURE PutItem ( VAR S : TStream; Item : Pointer );             VIRTUAL;
   END;
   PResourceCollection = ^TResourceCollection;

{---------------------------------------------------------------------------}
{                 TResourceFile OBJECT - RESOURCE FILE OBJECT               }
{---------------------------------------------------------------------------}
TYPE
   TResourceFile = OBJECT ( TObject )
         Stream  : PStream;                           { File as a stream }
         Modified : Boolean;                           { Modified flag }
      CONSTRUCTOR Init ( AStream : PStream );
      DESTRUCTOR Done;                                               VIRTUAL;
      FUNCTION Count : Sw_Integer;
      FUNCTION KeyAt ( I : Sw_Integer ) : sw_String;
      FUNCTION Get ( Key : sw_String ) : PObject;
      FUNCTION SwitchTo ( AStream : PStream; Pack : Boolean ) : PStream;
      PROCEDURE Flush;
      PROCEDURE Delete ( Key : sw_String );
      PROCEDURE Put ( Item : PObject; Key : sw_String );
      {$ifndef PPC_GPC}PRIVATE{$endif}
         BasePos : LongInt;                            { Base position }
         IndexPos : LongInt;                           { Index position }
         Index : TResourceCollection;                  { Index collection }
   END;
   PResourceFile = ^TResourceFile;

TYPE
   TStrIndexRec = RECORD Key, Count, Offset : Word16; END;

   TStrIndex = ARRAY [0..9999] OF TStrIndexRec;
   PStrIndex = ^TStrIndex;

{---------------------------------------------------------------------------}
{                 TStringList OBJECT - STRING LIST OBJECT                   }
{---------------------------------------------------------------------------}
   TStringList = OBJECT ( TObject )
      CONSTRUCTOR Load ( VAR S : TStream );
      DESTRUCTOR Done;                                               VIRTUAL;
      FUNCTION Get ( Key : Sw_Word ) : sw_String;
      {$ifndef PPC_GPC}PRIVATE{$endif}
         Stream   : PStream;
         BasePos  : LongInt;
         IndexSize : Sw_Word;
         Index    : PStrIndex;
      PROCEDURE ReadStr ( VAR S : sw_String; Offset, Skip : Sw_Word );
   END;
   PStringList = ^TStringList;

{---------------------------------------------------------------------------}
{                 TStrListMaker OBJECT - RESOURCE FILE OBJECT               }
{---------------------------------------------------------------------------}
TYPE
   TStrListMaker = OBJECT ( TObject )
      CONSTRUCTOR Init ( AStrSize, AIndexSize : Sw_Word );
      DESTRUCTOR Done;                                               VIRTUAL;
      PROCEDURE Put ( Key : Sw_Word; S : sw_String );
      PROCEDURE Store ( VAR S : TStream );
      {$ifndef PPC_GPC}PRIVATE{$endif}
         StrPos   : Sw_Word;
         StrSize  : Sw_Word;
         Strings  : PByteArray;
         IndexPos : Sw_Word;
         IndexSize : Sw_Word;
         Index    : PStrIndex;
         Cur      : TStrIndexRec;
      PROCEDURE CloseCurrent;
   END;
   PStrListMaker = ^TStrListMaker;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        STREAM INTERFACE ROUTINES                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-Abstract-----------------------------------------------------------
Terminates program with a run-time error 211. When implementing
an abstract object type, call Abstract in those virtual methods that
must be overridden in descendant types. This ensures that any
attempt to use instances of the abstract object type will fail.
12Jun96 LdB
---------------------------------------------------------------------}
PROCEDURE Abstract;

{-RegisterObjects----------------------------------------------------
Registers the three standard objects TCollection, TStringCollection
and TStrCollection.
02Sep97 LdB
---------------------------------------------------------------------}
PROCEDURE RegisterObjects;

{-RegisterType-------------------------------------------------------
Registers the given object type with Free Vision's streams, creating
a list of known objects. Streams can only store and return these known
object types. Each registered object needs a unique stream registration
record, of type TStreamRec.
02Sep97 LdB
---------------------------------------------------------------------}
PROCEDURE RegisterType ( VAR S : TStreamRec );

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    GENERAL FUNCTION INTERFACE ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-LongMul------------------------------------------------------------
Returns the long integer value of X * Y integer values.
10Feb98 LdB
---------------------------------------------------------------------}
FUNCTION LongMul ( X, Y : Integer ) : LongInt;

{-LongDiv------------------------------------------------------------
Returns the integer value of long integer X divided by integer Y.
10Feb98 LdB
---------------------------------------------------------------------}
FUNCTION LongDiv ( X : LongInt; Y : Integer ) : Integer;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    DYNAMIC STRING INTERFACE ROUTINES                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-NewStr-------------------------------------------------------------
Allocates a dynamic string into memory. If S is nil, NewStr returns
a nil pointer, otherwise NewStr allocates Length(S)+1 bytes of memory
containing a copy of S, and returns a pointer to the string.
12Jun96 LdB; ** use GPC rtl routine (16Feb99 AAO)
---------------------------------------------------------------------}
FUNCTION NewStr ( {$ifdef PPC_GPC}CONST{$endif} S : sw_String ) : PString;
{$ifdef PPC_GPC} external name ('_p_NewString');{$endif}

{-DisposeStr---------------------------------------------------------
Disposes of a PString allocated by the function NewStr.
12Jun96 LdB; ** use GPC rtl routine (16Feb99 AAO)
---------------------------------------------------------------------}
PROCEDURE DisposeStr ( P : PString );
{$ifdef PPC_GPC} external name '_p_Dispose';{$endif}

{***************************************************************************}
{                         PUBLIC INITIALIZED VARIABLES                      }
{***************************************************************************}

CONST
{---------------------------------------------------------------------------}
{              INITIALIZED DOS/DPMI/WIN/OS2 PUBLIC VARIABLES                }
{---------------------------------------------------------------------------}
   StreamError : Pointer = Nil;                        { Stream error ptr }

   { I question if this is needed any more????? Ldb 14Aug98 }
   DosStreamError : Word16 = $0;                         { Dos stream error }


{$IFNDEF PPC_FPC}

{ Florian please FIX THIS!!!!! }

{---------------------------------------------------------------------------}
{                        STREAM REGISTRATION RECORDS                        }
{---------------------------------------------------------------------------}
{$ifdef PPC_GPC}
 {$W-}
{$endif}

{$ifndef BIT_16}
VAR
{$else}
CONST
{$endif} { BIT_16}
RCollection : TStreamRec = (
     ObjType : 50;
     {$IFDEF BP_VMTLink}
     VmtLink : Ofs ( TypeOf ( TCollection ) ^ );
     {$ELSE}
     VmtLink : TypeOf ( TCollection );
     {$ENDIF}
     Load : @TCollection.Load;
     Store : @TCollection.Store );

RStringCollection : TStreamRec = (
     ObjType : 51;
     {$IFDEF BP_VMTLink}
     VmtLink : Ofs ( TypeOf ( TStringCollection ) ^ );
     {$ELSE}
     VmtLink : TypeOf ( TStringCollection );
     {$ENDIF}
     Load : @TStringCollection.Load;
     Store : @TStringCollection.Store );

RStrCollection : TStreamRec = (
     ObjType : 69;
     {$IFDEF BP_VMTLink}
     VmtLink : Ofs ( TypeOf ( TStrCollection ) ^ );
     {$ELSE}
     VmtLink : TypeOf ( TStrCollection );
     {$ENDIF}
     Load :    @TStrCollection.Load;
     Store :   @TStrCollection.Store );

RStringList : TStreamRec = (
     ObjType : 52;
     {$IFDEF BP_VMTLink}
     VmtLink : Ofs ( TypeOf ( TStringList ) ^ );
     {$ELSE}
     VmtLink : TypeOf ( TStringList );
     {$ENDIF}
     Load : @TStringList.Load;
     Store : Nil );

RStrListMaker : TStreamRec = (
     ObjType : 52;
     {$IFDEF BP_VMTLink}
     VmtLink : Ofs ( TypeOf ( TStrListMaker ) ^ );
     {$ELSE}
     VmtLink : TypeOf ( TStrListMaker );
     {$ENDIF}
     Load : Nil;
     Store : @TStrListMaker.Store );
{$ENDIF}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
{$IFNDEF PROC_Real}                                   { NOT DOS REAL CODE }
  {$DEFINE NewExeFormat}                              { New format EXE }
{$ENDIF}

{$IFDEF OS_OS2}                                       { OS2 COMPILERS }

  {$IFDEF PPC_Virtual}                                { VIRTUAL PASCAL UNITS }
  USES OS2Base;                                       { Standard unit }
  {$ENDIF}

  {$IFDEF PPC_Speed}                                  { SPEED PASCAL UNITS }
  USES BseDos, Os2Def;                                { Standard units }
  {$ENDIF}

  {$IFDEF PPC_BPOS2}                                  { C'T PATCH TO BP UNITS }
  USES DosTypes, DosProcs;                            { Standard units }

  TYPE FILEFINDBUF = TFILEFINDBUF;                    { Type correction }
  {$ENDIF}
{$ENDIF}

{***************************************************************************}
{                        PRIVATE DEFINED CONSTANTS                          }
{***************************************************************************}

{***************************************************************************}
{                      PRIVATE INITIALIZED VARIABLES                        }
{***************************************************************************}

{---------------------------------------------------------------------------}
{               INITIALIZED DOS/DPMI/WIN/OS2 PRIVATE VARIABLES              }
{---------------------------------------------------------------------------}
CONST
   StreamTypes : PStreamRec = Nil;                     { Stream types reg }

{***************************************************************************}
{                          PRIVATE INTERNAL ROUTINES                        }
{***************************************************************************}

{$IFDEF PROC_Real}                                    { DOS REAL MODE CODE }
{$I EMSOBJ.INC}                                       { Include EMS routines }
{$I XMSOBJ.INC}                                       { Include XMS routines }
{$ENDIF}

{$IFNDEF PPC_FPC}                                     { NON FPC COMPILERS }
  {$IFDEF PPC_GPC}
    {$I filegpc.inc}                                    { GPC File handling procs }
  {$else}{GPC}
    {$IFDEF PPC_TMT_DOS}
     {$i filetmt.inc}
    {$else}{TMT}
     {$I fileobj.inc}                                    { File handling procs }
    {$endif}{TMT}
  {$endif}{GPC}
{$ENDIF}{FPC}

{$IFDEF PPC_FPC}                                      { FPC COMPILER }
  {$i filefpc.inc}                                    { Platform routines }
{$IFDEF CPU86}                                        { Intel CPU }
{.$I386_ATT}                                          { Include definitions }
{$ENDIF}
{$ENDIF}

TYPE
  FramePointer = word;
  VoidConstructor = FUNCTION ( VmtOfs : Word; Obj : pointer ) : pointer;
  PointerConstructor = FUNCTION ( Param1 : pointer; VmtOfs : Word; Obj : pointer ) : pointer;
  VoidMethod = FUNCTION ( Obj : pointer ) : pointer;
  PointerMethod = FUNCTION ( Param1 : pointer; Obj : pointer ) : pointer;

{$ifdef Ver70}
FUNCTION PreviousFramePointer : FramePointer; assembler;
ASM
        mov     ax, ss : [bp]
END;


FUNCTION CallPointerLocal ( Func : pointer; Frame : FramePointer; Param1 : pointer ) : pointer; assembler;
ASM
        mov     ax, word ptr Param1
        mov     dx, word ptr Param1 + 2
        push    dx
        push    ax
{$IFDEF Windows}
        MOV     AX, [Frame]
        AND     AL, 0FEH
        PUSH    AX
{$ELSE}
        push    [Frame]
{$ENDIF}
        call    dword ptr Func
END;
{$endif}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     PRIVATE INTERNAL WIN/NT ROUTINES                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{$ifdef WIN32}
{$ifndef PPC_GPC}
{.$IFDEF PPC_DELPHI32}                                  { DELPHI 32-bit CODE }
{---------------------------------------------------------------------------}
{  MemAvail -> Platforms WIN/NT - Updated 14Aug98 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION MemAvail : LongInt;
VAR Ms : TMemoryStatus;
BEGIN
   GlobalMemoryStatus ( Ms );                            { Get memory status }
   MemAvail := Ms.dwAvailPhys;                        { Available memory }
END;

{---------------------------------------------------------------------------}
{  MaxAvail -> Platforms WIN/NT - Updated 14Aug98 LdB                       }
{---------------------------------------------------------------------------}
FUNCTION MaxAvail : LongInt;
VAR Ms : TMemoryStatus;
BEGIN
   GlobalMemoryStatus ( Ms );                            { Get memory status }
   MaxAvail := Ms.dwTotalPhys;                        { Max total memory }
END;
{$ENDIF}
{$ENDIF}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{              PRIVATE INTERNAL DOS/DPMI/WIN/NT/OS2 ROUTINES                }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterError -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Jun96 LdB     }
{---------------------------------------------------------------------------}
PROCEDURE RegisterError;
BEGIN
   RunError ( 212 );                                     { Register error }
END;

{***************************************************************************}
{                               OBJECT METHODS                              }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TRect OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
PROCEDURE CheckEmpty ( VAR Rect : TRect );
BEGIN
   WITH Rect
   DO BEGIN
     IF ( A.X >= B.X ) OR ( A.Y >= B.Y )
     THEN BEGIN                                       { Zero or reversed }
       A.X := 0;                                      { Clear a.x }
       A.Y := 0;                                      { Clear a.y }
       B.X := 0;                                      { Clear b.x }
       B.Y := 0;                                      { Clear b.y }
     END;
   END;
END;

{--TRect--------------------------------------------------------------------}
{  Empty -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TRect.Empty : Boolean;
BEGIN
   Empty := ( A.X >= B.X ) OR ( A.Y >= B.Y );             { Empty result }
END;

{--TRect--------------------------------------------------------------------}
{  Equals -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17Feb99 AAO            }
{---------------------------------------------------------------------------}
FUNCTION TRect.Equals;
BEGIN
   Equals := ( A.X = R{$ifdef ver90}^{$endif}.A.X ) AND ( A.Y = R{$ifdef ver90}^{$endif}.A.Y )
   AND ( B.X = R{$ifdef ver90}^{$endif}.B.X ) AND ( B.Y = R{$ifdef ver90}^{$endif}.B.Y );                 { Equals result }
END;

{--TRect--------------------------------------------------------------------}
{  Contains -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB          }
{---------------------------------------------------------------------------}
FUNCTION TRect.Contains ( CONST P : TPoint ) : Boolean;
BEGIN
   Contains := ( P.X >= A.X ) AND ( P.X < B.X ) AND
     ( P.Y >= A.Y ) AND ( P.Y < B.Y );                    { Contains result }
END;

{--TRect--------------------------------------------------------------------}
{  Copy -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO              }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Copy;
BEGIN
   A := R{$ifdef ver90}^{$endif}.A;                   { Copy point a }
   B := R{$ifdef ver90}^{$endif}.B;                   { Copy point b }
END;

{--TRect--------------------------------------------------------------------}
{  Union -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO             }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Union;
BEGIN
   IF ( R{$ifdef ver90}^{$endif}.A.X < A.X ) THEN A.X := R{$ifdef ver90}^{$endif}.A.X;  { Take if smaller }
   IF ( R{$ifdef ver90}^{$endif}.A.Y < A.Y ) THEN A.Y := R{$ifdef ver90}^{$endif}.A.Y;  { Take if smaller }
   IF ( R{$ifdef ver90}^{$endif}.B.X > B.X ) THEN B.X := R{$ifdef ver90}^{$endif}.B.X;  { Take if larger }
   IF ( R{$ifdef ver90}^{$endif}.B.Y > B.Y ) THEN B.Y := R{$ifdef ver90}^{$endif}.B.Y;  { Take if larger }
END;

{--TRect--------------------------------------------------------------------}
{  Intersect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO         }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Intersect;
BEGIN
   IF ( R{$ifdef ver90}^{$endif}.A.X > A.X ) THEN A.X := R{$ifdef ver90}^{$endif}.A.X;  { Take if larger }
   IF ( R{$ifdef ver90}^{$endif}.A.Y > A.Y ) THEN A.Y := R{$ifdef ver90}^{$endif}.A.Y;  { Take if larger }
   IF ( R{$ifdef ver90}^{$endif}.B.X < B.X ) THEN B.X := R{$ifdef ver90}^{$endif}.B.X;  { Take if smaller }
   IF ( R{$ifdef ver90}^{$endif}.B.Y < B.Y ) THEN B.Y := R{$ifdef ver90}^{$endif}.B.Y;  { Take if smaller }
   CheckEmpty ( Self );                    { Check if empty }
END;

{--TRect--------------------------------------------------------------------}
{  Move -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Move ( ADX, ADY : Integer );
BEGIN
   Inc ( A.X, ADX );                                     { Adjust A.X }
   Inc ( A.Y, ADY );                                     { Adjust A.Y }
   Inc ( B.X, ADX );                                     { Adjust B.X }
   Inc ( B.Y, ADY );                                     { Adjust B.Y }
END;

{--TRect--------------------------------------------------------------------}
{  Grow -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Grow ( ADX, ADY : Integer );
BEGIN
   Dec ( A.X, ADX );                                     { Adjust A.X }
   Dec ( A.Y, ADY );                                     { Adjust A.Y }
   Inc ( B.X, ADX );                                     { Adjust B.X }
   Inc ( B.Y, ADY );                                     { Adjust B.Y }
   CheckEmpty ( Self );                                  { Check if empty }
END;

{--TRect--------------------------------------------------------------------}
{  Assign -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TRect.Assign ( XA, YA, XB, YB : Integer );
BEGIN
   A.X := XA;                                         { Hold A.X value }
   A.Y := YA;                                         { Hold A.Y value }
   B.X := XB;                                         { Hold B.X value }
   B.Y := YB;                                         { Hold B.Y value }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TObject OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

TYPE
   DummyObject = OBJECT ( TObject )                     { Internal object }
     Data : RECORD END;                                { Helps size VMT link }
   END;

{ ******************************* REMARK ****************************** }
{ I Prefer this code because it self sizes VMT link rather than using a }
{ fixed record structure thus it should work on all compilers without a }
{ specific record to match each compiler.                               }
{ ****************************** END REMARK *** Leon de Boer, 10May96 * }

{ ******************************* REMARK ****************************** }
{ Under GPC we cannot call FillChar to set the fields to null in the    }
{ constructor, because this trashes fields like strings, files, etc. So }
{ all TObject descendants *must* initialize all their fields explicitly.}
{ ****************************** END REMARK *** 14May01 AAO *********** }

{--TObject------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19Feb99 AAO              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TObject.Init;
{$ifndef PPC_GPC}
TYPE
IntPointer = Longint;

VAR
LinkSize : IntPointer;
Dummy : DummyObject;
{$endif}
BEGIN
  {$ifndef PPC_GPC}
  LinkSize := IntPointer ( @Dummy.Data ) - IntPointer ( @Dummy );  { Calc VMT link size }
  FillChar ( Pointer ( IntPointer ( @Self ) + LinkSize ) ^, SizeOf ( Self ) - LinkSize, #0 ); { Clear data fields }
  {$endif}
END;

{--TObject------------------------------------------------------------------}
{  Free -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TObject.Free;
BEGIN
   Dispose ( PObject ( @Self ), Done );                     { Dispose of self }
END;

{--TObject------------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TObject.Done;
BEGIN                                                 { Abstract method }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TStream OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStream------------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 02May04 AAO               }
{---------------------------------------------------------------------------}
CONSTRUCTOR TStream.Init;
BEGIN
   Inherited Init;
   Status := 0;
   ErrorInfo := 0;
   StreamSize := 0;
   Position  := 0;
END;

{--TStream------------------------------------------------------------------}
{  Get -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14Aug98 LdB               }
{---------------------------------------------------------------------------}

FUNCTION TStream.Get : PObject;
VAR ObjType : Sw_Word; P : PStreamRec;
{$ifdef PPC_GPC}
TYPE LoadPtr = FUNCTION ( VAR Self : TObject; VAR S : TStream ) : Boolean;
VAR Temp : TObject;
BEGIN
   Read ( ObjType, SizeOf ( ObjType ) );                    { Read object type }
   IF ( ObjType <> 0 ) THEN BEGIN                       { Object registered }
{@@??} P := StreamTypes;                              { Current reg list }
       SetType ( Temp, P^.VMTLink );                    { Determine the size }
       GetMem ( Result, SizeOf ( Temp ) );                { Allocate memory }
       SetType ( Result^, P^.VMTLink );                 { Assign the VMT field }
       IF LoadPtr ( P^.Load ) ( Result^, Self ) THEN        { Call constructor }
          Get := Result                               { Success }
       ELSE BEGIN
         FreeMem ( Result, SizeOf ( Temp ) );             { `Fail' called }
         Get := Nil                                   { Return `Nil' }
       END;
   END;
END;
{$else} {PPC_GPC}
TYPE LoadPtr = FUNCTION ( VAR S : TStream; Link : Sw_Word; Iv : Pointer ) : PObject;
BEGIN
   Read ( ObjType, SizeOf ( ObjType ) );                    { Read object type }
   IF ( ObjType <> 0 ) THEN BEGIN                       { Object registered }
     P := StreamTypes;                                { Current reg list }
     WHILE ( P <> Nil ) AND ( P^.ObjType <> ObjType )     { Find object type OR }
       DO P := P^.Next;                               { Find end of chain }
     IF ( P = Nil ) THEN BEGIN                          { Not registered }
       Error ( stGetError, ObjType );                    { Obj not registered }
       Get := Nil;                                    { Return nil pointer }
     END ELSE
       {$IFDEF BP_VMTLink}                            { BP like VMT link }
       Get := LoadPtr ( P^.Load ) ( Self, P^.VMTLink, Nil ) { Call constructor }
       {$ELSE}                                        { FPC/DELPHI VMT link }
       Get := LoadPtr ( P^.Load ) ( Self,
         Sw_Word ( P^.VMTLink^ ), Nil )                   { Call constructor }
       {$ENDIF}
   END ELSE Get := Nil;                               { Return nil pointer }
END;
{$endif}

{--TStream------------------------------------------------------------------}
{  StrRead -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStream.StrRead : PChar;
VAR W : Word16; P : PChar;
BEGIN
   Read ( W, SizeOf ( W ) );                                { Read string length }
   IF ( W = 0 ) THEN StrRead := Nil ELSE BEGIN          { Check for empty }
     GetMem ( P, W + 1 );                                { Allocate memory }
     IF ( P <> Nil ) THEN BEGIN                         { Check allocate okay }
       Read ( P [0], W );                                 { Read the data }
       P [W] := #0;                                    { Terminate with #0 }
     END;
     StrRead := P;                                    { PChar returned }
   END;
END;

{--TStream------------------------------------------------------------------}
{  ReadStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May01 AAO           }
{---------------------------------------------------------------------------}
{ ******************************* REMARK ****************************** }
{  The original code assumed that a string's capacity is always 1 byte  }
{  in size. This is not correct for most 32-bit platforms. Thus, I have }
{  here used "Int32" for the string capacity storage. This causes a     }
{  problem with stream files written with 16-bit BP programs. Thus in   }
{  order to have full BP 16-bit compatibility (for existing files) I    }
{  have defined FULL_BP_COMPAT. For people with compilers that can have }
{  strings longer than 255 characters and who do not care to read files }
{  written with 16-bit BP programs using Streams, you should undefine   }
{  this so that your strings can be of any size that you want.          }
{ ***************** END REMARK *** Prof Abimbola A Olowofoyeku, 14Feb99 }
{$ifndef PPC_GPC}
  {$define FULL_BP_COMPAT}
{$endif}
FUNCTION TStream.ReadStr : PString;
VAR B : {$ifdef FULL_BP_COMPAT}Byte{$else}Int32{$endif};
P : PString;
BEGIN
   Read ( B, Sizeof ( B ) );                                { Read string length }
   IF ( B > 0 ) THEN BEGIN
    {$ifdef PPC_GPC}
     // New ( P, B );                                    { Allocate memory }
     GetMem ( P, B + 1 );                                { Allocate memory }
    {$else}
     GetMem ( P, B + 1 );                                { Allocate memory }
    {$endif}
    IF ( P <> Nil ) THEN BEGIN                          { Check allocate okay }
       {$IFDEF NON_BP_STRINGS}
       SetLength ( P^, B );                              { Hold new length }
       {$else}
         P^ [0] := Chr ( B );                             { Hold new length }
       {$ENDIF}
       Read ( P^ [1], B );                                { Read string data }
    END;
    ReadStr := P;                                     { Return string ptr }
   END ELSE ReadStr := Nil;
END;

{--TStream------------------------------------------------------------------}
{  GetPos -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB            }
{---------------------------------------------------------------------------}
FUNCTION TStream.GetPos : LongInt;
BEGIN
   IF ( Status = stOk ) THEN GetPos := Position         { Return position }
     ELSE GetPos := - 1;                               { Stream in error }
END;

{--TStream------------------------------------------------------------------}
{  GetSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStream.GetSize : LongInt;
BEGIN
   IF ( Status = stOk ) THEN GetSize := StreamSize      { Return stream size }
     ELSE GetSize := - 1;                              { Stream in error }
END;

{--TStream------------------------------------------------------------------}
{  Close -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Close;
BEGIN                                                 { Abstract method }
END;

{--TStream------------------------------------------------------------------}
{  Reset -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Reset;
BEGIN
   Status := 0;                                       { Clear status }
   ErrorInfo := 0;                                    { Clear error info }
END;

{--TStream------------------------------------------------------------------}
{  Flush -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Flush;
BEGIN                                                 { Abstract method }
END;

{--TStream------------------------------------------------------------------}
{  Truncate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Truncate;
BEGIN
   Abstract;                                          { Abstract error }
END;

{--TStream------------------------------------------------------------------}
{  Get -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14Aug98 LdB               }
{---------------------------------------------------------------------------}
{$ifdef PPC_GPC}{$W-}{$endif}
PROCEDURE TStream.Put ( P : PObject );
TYPE StorePtr = PROCEDURE ( VAR S : TStream; AnObject : PObject );
VAR
ObjType : Sw_Word;
Link : Sw_Word;
Q : PStreamRec;
VmtPtr : ^Sw_Word;
BEGIN
   Q := Nil;   { remove Delphi 3 warning }
   VmtPtr := Pointer ( P );                              { Xfer object to ptr }
   Link := VmtPtr^;                                   { VMT link }
   ObjType := 0;                                      { Set objtype to zero }
   IF ( P <> Nil ) AND ( Link <> 0 ) THEN BEGIN           { We have a VMT link }
     Q := StreamTypes;                                { Current reg list }
     {$IFDEF BP_VMTLink}                              { BP like VMT link }
     WHILE ( Q <> Nil ) AND ( Q^.VMTLink <> Link )        { Find link match OR }
     {$ELSE}                                          { FPC/DELHI3 VMT link }
     {$ifdef PPC_GPC} {$local borland-pascal} {$endif}
     WHILE ( Q <> Nil )
     AND ( sw_Word ( Q^.VMTLink^ ) <> Link )                 { Find link match OR }
     {$ifdef PPC_GPC} {$endlocal} {$endif}
     {$ENDIF}
       DO Q := Q^.Next;                               { Find end of chain }
     IF ( Q = Nil ) THEN BEGIN                          { End of chain found }
       Error ( stPutError, 0 );                          { Not registered error }
       Exit;                                          { Now exit }
     END ELSE ObjType := Q^.ObjType;                  { Update object type }
   END;
   Write ( ObjType, SizeOf ( ObjType ) );                   { Write object type }
   IF ( ObjType <> 0 ) THEN                             { Registered object }
     StorePtr ( Q^.Store ) ( Self, P );                     { Store object }
END;
{$ifdef PPC_GPC}{$W+}{$endif}

{--TStream------------------------------------------------------------------}
{  Seek -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Seek ( Pos : LongInt );
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status }
     IF ( Pos < 0 ) THEN Pos := 0;                      { Remove negatives }
     IF ( Pos <= StreamSize ) THEN Position := Pos      { If valid set pos }
       ELSE Error ( stSeekError, Pos );                  { Position error }
   END;
END;

{--TStream------------------------------------------------------------------}
{  StrWrite -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TStream.StrWrite ( P : PChar );
VAR W : Word16; Q : PByteArray;
BEGIN
   W := 0;                                            { Preset zero size }
   Q := PByteArray ( P );                                { Transfer type }
   IF ( Q <> Nil ) THEN WHILE ( Q^ [W] <> 0 ) DO Inc ( W );   { PChar length }
   Write ( W, SizeOf ( W ) );                               { Store length }
   IF ( P <> Nil ) THEN Write ( P [0], W );                 { Write data }
END;

{--TStream------------------------------------------------------------------}
{  WriteStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19Feb99 AAO          }
{---------------------------------------------------------------------------}
PROCEDURE TStream.WriteStr ( P : PString );
VAR
EmptyString : String [1] = '';
i : {$ifdef FULL_BP_COMPAT}Byte{$else}Int32{$endif};
BEGIN
  IF ( p = nil ) THEN i := 1 ELSE i := Length ( p^ ) {$ifndef PPC_GPC} + 1{$endif};
 {$ifdef PPC_GPC}
  Write ( i, Sizeof ( i ) );                      { write string length }
 {$endif}
  IF ( p <> nil )
  THEN Write ( p^{$ifdef PPC_GPC} [1]{$endif}, i ) { write string }
  ELSE Write ( EmptyString, i );                        { Write empty string }
END;

{--TStream------------------------------------------------------------------}
{  Open -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Open ( OpenMode : Word16 );
BEGIN                                                 { Abstract method }
END;

{--TStream------------------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Error ( Code, Info : Integer );
TYPE TErrorProc = PROCEDURE ( VAR S : TStream );
BEGIN
   Status := Code;                                    { Hold error code }
   ErrorInfo := Info;                                 { Hold error info }
   IF ( StreamError <> Nil ) THEN
     TErrorProc ( StreamError ) ( Self );                   { Call error ptr }
END;

{--TStream------------------------------------------------------------------}
{  Read -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Read ( VAR Buf; Count : Sw_Word );
BEGIN
   Abstract;                                          { Abstract error }
END;

{--TStream------------------------------------------------------------------}
{  Write -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStream.Write ( VAR Buf; Count : Sw_Word );
BEGIN
   Abstract;                                          { Abstract error }
END;

{--TStream------------------------------------------------------------------}
{  CopyFrom -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TStream.CopyFrom ( {$ifdef ver90}VAR S : PStream{$else}VAR S : TStream{$endif}; Count : LongInt );
VAR W : Word16; Buffer : ARRAY [0..1023] OF Byte;
BEGIN
   WHILE ( Count > 0 ) DO BEGIN
     IF ( Count > SizeOf ( Buffer ) ) THEN                 { To much data }
       W := SizeOf ( Buffer ) ELSE W := Count;           { Size to transfer }
     S.Read ( Buffer, W );                               { Read from stream }
     Write ( Buffer, W );                                { Write to stream }
     Dec ( Count, W );                                   { Dec write count }
   END;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TDosStream OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TDosStream---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TDosStream.Init ( FileName : FNameStr; Mode : Word16 );
VAR Success : Integer; {$IFDEF OS_OS2} Info : FILEFINDBUF; {$ENDIF}
BEGIN
   Inherited Init;                                    { Call ancestor }
   BufferCount := 0;
   {$IFDEF OS_WINDOWS}                                { WIN CODE }
   {$ifdef Win32}CharToOEM{$else}AnsiToOEM{$endif} ( FileName, FName );                        { Ansi to OEM }
   {$ELSE}                                            { DOS/DPMI/OS2 CODE }
   FileName := FileName + #0;                           { Make asciiz }
   Move ( FileName [1], FName, Length ( FileName ) );        { Create asciiz name }
   {$ENDIF}
   Handle := FileOpen ( FName, Mode );                   { Open the file }
   IF ( Handle <> 0 ) THEN BEGIN                        { Handle valid }
     Success := SetFilePos ( Handle, 0, 2, StreamSize ); { Locate end of file }
     IF ( Success = 0 ) THEN
       Success := SetFilePos ( Handle, 0, 0, Position ); { Reset to file start }
   END ELSE Success := 103;                           { Open file failed }
   IF ( Handle = 0 ) OR ( Success <> 0 ) THEN BEGIN       { Open failed }
     Handle := - 1;                                    { Reset invalid handle }
     Error ( stInitError, Success );                     { Call stream error }
   END;
END;

{--TDosStream---------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TDosStream.Done;
BEGIN
   IF ( Handle <> - 1 ) THEN FileClose ( Handle );          { Close the file }
   BufferCount := 0;
   Inherited Done;                                    { Call ancestor }
END;

{--TDosStream---------------------------------------------------------------}
{  Close -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Close;
BEGIN
   IF ( Handle <> - 1 ) THEN FileClose ( Handle );          { Close the file }
   Position := 0;                                     { Zero the position }
   Handle := - 1;                                      { Handle now invalid }
   BufferCount := 0;
END;

{--TDosStream---------------------------------------------------------------}
{  Truncate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Truncate;
VAR Success : Integer;
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     Success := SetFileSize ( Handle, Position );        { Truncate file }
     IF ( Success = 0 ) THEN StreamSize := Position     { Adjust size }
       ELSE Error ( stError, Success );                  { Identify error }
   END;
END;

{--TDosStream---------------------------------------------------------------}
{  Seek -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Seek ( Pos : LongInt );
VAR Success : Integer; Li : LongInt;
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     IF ( Pos < 0 ) THEN Pos := 0;                      { Negatives removed }
     IF ( Handle = - 1 ) THEN Success := 103 ELSE        { File not open }
       Success := SetFilePos ( Handle, Pos, 0, Li );     { Set file position }
     IF ( ( Success = - 1 ) OR ( Li <> Pos ) ) THEN BEGIN    { We have an error }
       IF ( Success = - 1 ) THEN Error ( stSeekError, 0 )   { General seek error }
         ELSE Error ( stSeekError, Success );            { Specific seek error }
     END ELSE Position := Li;                         { Adjust position }
   END;
END;

{--TDosStream---------------------------------------------------------------}
{  Open -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Open ( OpenMode : Word16 );
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     IF ( Handle = - 1 ) THEN BEGIN                      { File not open }
       Handle := FileOpen ( FName, OpenMode );           { Open the file }
       Position := 0;                                 { Reset position }
       IF ( Handle = 0 ) THEN BEGIN                       { File open failed }
         Handle := - 1;                                { Reset handle }
         Error ( stOpenError, 103 );                     { Call stream error }
       END;
     END ELSE Error ( stOpenError, 104 );                { File already open }
   END;
END;

{--TDosStream---------------------------------------------------------------}
{  Read -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB; 24Sep99 AAO }
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Read ( VAR Buf; Count : Sw_Word );
VAR Success : Integer; W, BytesMoved : dw_DWord; P : PByteArray;
BEGIN
   IF ( Position + Count > StreamSize ) THEN            { Insufficient data }
     Error ( stReadError, 0 );                           { Read beyond end!!! }
   IF ( Handle = - 1 ) THEN Error ( stReadError, 103 );     { File not open }
   P := @Buf;                                         { Transfer address }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     W := Count;                                      { Transfer read size }
     {$IFNDEF OS_OS2}                                 { DOS/DPMI/WIN/NT }
     IF ( Count > $FFFE ) THEN W := $FFFE;              { Cant read >64K bytes }
     {$ENDIF}
     Success := FileRead ( Handle, P^, W, BytesMoved );  { Read from file }
     BufferCount := BytesMoved;
     IF ( ( Success <> 0 ) OR ( BytesMoved <> W ) )         { Error was detected }
     THEN BEGIN
       BytesMoved := 0;                               { Clear bytes moved }
       IF ( Success <> 0 ) THEN
         Error ( stReadError, Success )                  { Specific read error }
         ELSE Error ( stReadError, 0 );                  { Non specific error }
     END;
     Inc ( Position, BytesMoved );                       { Adjust position }
     P := Pointer ( LongInt ( P ) + {.$ifdef PPC_GPC}Longint{.$endif} ( BytesMoved ) ); { Adjust buffer ptr }
     Dec ( Count, BytesMoved );                          { Adjust count left }
   END;
   IF ( Count <> 0 ) THEN FillChar ( P^, Count, #0 );      { Error clear buffer }
END;

{--TDosStream---------------------------------------------------------------}
{  Write -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16May96 LdB; 24Sep99 AAO}
{---------------------------------------------------------------------------}
PROCEDURE TDosStream.Write ( VAR Buf; Count : Sw_Word );
VAR Success : Integer; W, BytesMoved : dw_DWord; P : PByteArray;
BEGIN
   IF ( Handle = - 1 ) THEN Error ( stWriteError, 103 );    { File not open }
   P := @Buf;                                         { Transfer address }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     W := Count;                                      { Transfer read size }
     {$IFNDEF OS_OS2}                                 { DOS/DPMI/WIN/NT }
     IF ( Count > $FFFF ) THEN W := $FFFF;              { Cant read >64K bytes }
     {$ENDIF}
     Success := FileWrite ( Handle, P^, W, BytesMoved ); { Write to file }
     BufferCount := BytesMoved;
     IF ( ( Success <> 0 ) OR ( BytesMoved <> W ) )         { Error was detected }
     THEN BEGIN
       BytesMoved := 0;                               { Clear bytes moved }
       IF ( Success <> 0 ) THEN
         Error ( stWriteError, Success )                 { Specific write error }
         ELSE Error ( stWriteError, 0 );                 { Non specific error }
     END;
     Inc ( Position, BytesMoved );                       { Adjust position }
     P := Pointer ( LongInt ( P ) + {.$ifdef PPC_GPC}Longint{.$endif} ( BytesMoved ) ); { Transfer address }
     Dec ( Count, BytesMoved );                          { Adjust count left }
     IF ( Position > StreamSize ) THEN                  { File expanded }
       StreamSize := Position;                        { Adjust stream size }
   END;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TBufStream OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TBufStream---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TBufStream.Init ( FileName : FNameStr; Mode, Size : Word16 );
BEGIN
   Inherited Init ( FileName, Mode );                    { Call ancestor }
   BufSize := Size;                                   { Hold buffer size }
   IF ( Size <> 0 ) THEN GetMem ( Buffer, Size );          { Allocate buffer }
   IF ( Buffer = Nil ) THEN Error ( stInitError, 0 );      { Buffer allocate fail }
END;

{--TBufStream---------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TBufStream.Done;
BEGIN
   Flush;                                             { Flush the file }
   Inherited Done;                                    { Call ancestor }
   IF ( Buffer <> Nil ) THEN FreeMem ( Buffer, BufSize );  { Release buffer }
END;

{--TBufStream---------------------------------------------------------------}
{  Close -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Close;
BEGIN
   Flush;                                             { Flush the buffer }
   Inherited Close;                                   { Call ancestor }
END;

{--TBufStream---------------------------------------------------------------}
{  Flush -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Flush;
VAR
Success : Integer;
W : dw_DWord;
BEGIN
   IF ( LastMode = 2 ) AND ( BufPtr <> 0 ) THEN BEGIN     { Must update file }
     IF ( Handle = - 1 ) THEN Success := 103             { File is not open }
       ELSE Success := FileWrite ( Handle, Buffer^,
         BufPtr, W );                                  { Write to file }
     IF ( Success <> 0 ) OR ( W <> BufPtr ) THEN          { We have an error }
       IF ( Success = 0 ) THEN Error ( stWriteError, 0 )   { Unknown write error }
         ELSE Error ( stError, Success );                { Specific write error }
   END;
   BufPtr := 0;                                       { Reset buffer ptr }
   BufEnd := 0;                                       { Reset buffer end }
END;

{--TBufStream---------------------------------------------------------------}
{  Truncate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Truncate;
BEGIN
   Flush;                                             { Flush buffer }
   Inherited Truncate;                                { Truncate file }
END;

{--TBufStream---------------------------------------------------------------}
{  Seek -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Seek ( Pos : LongInt );
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     IF ( Position <> Pos ) THEN BEGIN                  { Move required }
       Flush;                                         { Flush the buffer }
       Inherited Seek ( Pos );                           { Call ancestor }
     END;
   END;
END;

{--TBufStream---------------------------------------------------------------}
{  Open -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Open ( OpenMode : Word16 );
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     BufPtr := 0;                                     { Clear buffer start }
     BufEnd := 0;                                     { Clear buffer end }
     Inherited Open ( OpenMode );                        { Call ancestor }
   END;
END;

{--TBufStream---------------------------------------------------------------}
{  Read -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB; 24Sep99 AAO }
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Read ( VAR Buf; Count : Sw_Word );
VAR Success : Integer; W, Bw : dw_dWord; P : PByteArray;
BEGIN
   IF ( Position + Count > StreamSize ) THEN            { Read pas stream end }
       Error ( stReadError, 0 );                           { Call stream error }
   IF ( Handle = - 1 ) THEN Error ( stReadError, 103 );     { File not open }
   P := @Buf;                                         { Transfer address }
   IF ( LastMode = 2 ) THEN Flush;                      { Flush write buffer }
   LastMode := 1;                                     { Now set read mode }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     IF ( BufPtr = BufEnd ) THEN BEGIN                  { Buffer is empty }
       IF ( Position + BufSize > StreamSize ) THEN
         Bw := StreamSize - Position                  { Amount of file left }
         ELSE Bw := BufSize;                          { Full buffer size }
       Success := FileRead ( Handle, Buffer^, Bw, W );   { Read from file }
       IF ( ( Success <> 0 ) OR ( Bw <> W ) ) THEN BEGIN    { Error was detected }
         IF ( Success <> 0 ) THEN
           Error ( stReadError, Success )                { Specific read error }
           ELSE Error ( stReadError, 0 );                { Non specific error }
       END ELSE BEGIN
         BufPtr := 0;                                 { Reset BufPtr }
         BufEnd := W;                                 { End of buffer }
       END;
     END;
     IF ( Status = stOk ) THEN BEGIN                    { Status still okay }
       W := BufEnd - BufPtr;                          { Space in buffer }
       IF ( Count < W ) THEN W := Count;                { Set transfer size }
       Move ( Buffer^ [BufPtr], P^, W );                  { Data from buffer }
       Dec ( Count, W );                                 { Reduce count }
       Inc ( BufPtr, W );                                { Advance buffer ptr }
       P := Pointer ( LongInt ( P ) + {$ifdef PPC_GPC}Longint{$endif} ( W ) ); { Transfer address }
       Inc ( Position, W );                              { Advance position }
     END;
   END;
   IF ( Status <> stOk ) AND ( Count > 0 ) THEN
     FillChar ( P^, Count, #0 );                         { Error clear buffer }
END;

{--TBufStream---------------------------------------------------------------}
{  Write -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 17May96 LdB; 24Sep99 AAO}
{---------------------------------------------------------------------------}
PROCEDURE TBufStream.Write ( VAR Buf; Count : Sw_Word );
VAR Success : Integer; W : dw_DWord; P : PByteArray;
BEGIN
   IF ( Handle = - 1 ) THEN Error ( stWriteError, 103 );    { File not open }
   IF ( LastMode = 1 ) THEN Flush;                      { Flush read buffer }
   LastMode := 2;                                     { Now set write mode }
   P := @Buf;                                         { Transfer address }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     IF ( BufPtr = BufSize ) THEN BEGIN                 { Buffer is full }
       Success := FileWrite ( Handle, Buffer^, BufSize,
         W );                                          { Write to file }
       IF ( Success <> 0 ) OR ( W <> BufSize ) THEN       { We have an error }
         IF ( Success = 0 ) THEN Error ( stWriteError, 0 )   { Unknown write error }
           ELSE Error ( stError, Success );              { Specific write error }
       BufPtr := 0;                                   { Reset BufPtr }
     END;
     IF ( Status = stOk ) THEN BEGIN                    { Status still okay }
       W := BufSize - BufPtr;                         { Space in buffer }
       IF ( Count < W ) THEN W := Count;                { Transfer size }
       Move ( P^, Buffer^ [BufPtr], W );                  { Data to buffer }
       Dec ( Count, W );                                 { Reduce count }
       Inc ( BufPtr, W );                                { Advance buffer ptr }
       P := Pointer ( LongInt ( P ) + {$ifdef PPC_GPC}Longint{$endif} ( W ) ); { Transfer address }
       Inc ( Position, W );                              { Advance position }
       IF ( Position > StreamSize ) THEN                { File has expanded }
         StreamSize := Position;                      { Update new size }
     END;
   END;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TFileStream OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
CONSTRUCTOR TFileStream.Init;
BEGIN
   Inherited Init ( FileName, Mode, 8192 );
END;

FUNCTION TFileStream.Size;
BEGIN
   Size := GetSize;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TMemoryStream OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMemoryStream------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TMemoryStream.Init ( ALimit : LongInt; ABlockSize : Word16 );
VAR W : Word16;
BEGIN
   Inherited Init;                                    { Call ancestor }
   IF ( ABlockSize = 0 ) THEN BlkSize := 8192 ELSE      { Default blocksize }
     BlkSize := ABlockSize;                           { Set blocksize }
   IF ( ALimit = 0 ) THEN W := 1 ELSE                   { At least 1 block }
     W := ( ALimit + BlkSize - 1 ) DIV BlkSize;         { Blocks needed }
   IF NOT ChangeListSize ( W ) THEN                      { Try allocate blocks }
      Error ( stInitError, 0 );                          { Initialize error }
END;

{--TMemoryStream------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TMemoryStream.Done;
BEGIN
   ChangeListSize ( 0 );                                 { Release all memory }
   Inherited Done;                                    { Call ancestor }
END;

{--TMemoryStream------------------------------------------------------------}
{  Truncate -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TMemoryStream.Truncate;
VAR W : Word16;
BEGIN
   IF ( Status = stOk ) THEN BEGIN                      { Check status okay }
     IF ( Position = 0 ) THEN W := 1 ELSE               { At least one block }
       W := ( Position + BlkSize - 1 ) DIV BlkSize;     { Blocks needed }
     IF ChangeListSize ( W ) THEN StreamSize := Position { Set stream size }
       ELSE Error ( stError, 0 );                        { Error truncating }
   END;
END;

{--TMemoryStream------------------------------------------------------------}
{  Read -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TMemoryStream.Read ( VAR Buf; Count : Sw_Word );
VAR W, CurBlock, BlockPos : Word16; Li : LongInt; P, Q : PByteArray;
BEGIN
   IF ( Position + Count > StreamSize ) THEN            { Insufficient data }
     Error ( stReadError, 0 );                           { Read beyond end!!! }
   P := @Buf;                                         { Transfer address }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     CurBlock := Position DIV BlkSize;                { Current block }
     { * REMARK * - Do not shorten this, result can be > 64K }
     Li := CurBlock;                                  { Transfer current block }
     Li := Li * BlkSize;                              { Current position }
     { * REMARK END * - Leon de Boer }
     BlockPos := Position - Li;                       { Current position }
     W := BlkSize - BlockPos;                         { Current block space }
     IF ( W > Count ) THEN W := Count;                  { Adjust read size }
     Q := Pointer ( LongInt ( BlkList^ [CurBlock] ) +
       BlockPos );                                     { Calc pointer }
     Move ( Q^, P^, W );                                 { Move data to buffer }
     Inc ( Position, W );                                { Adjust position }
     P := Pointer ( LongInt ( P ) + W );                    { Transfer address }
     Dec ( Count, W );                                   { Adjust count left }
   END;
   IF ( Count <> 0 ) THEN FillChar ( P^, Count, #0 );      { Error clear buffer }
END;

{--TMemoryStream------------------------------------------------------------}
{  Write -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TMemoryStream.Write ( VAR Buf; Count : Sw_Word );
VAR W, CurBlock, BlockPos : Word16; Li : LongInt; P, Q : PByteArray;
BEGIN
   IF ( Position + Count > MemSize ) THEN BEGIN         { Expansion needed }
     IF ( Position + Count = 0 ) THEN W := 1 ELSE       { At least 1 block }
       W := ( Position + Count + BlkSize - 1 ) DIV BlkSize;   { Blocks needed }
     IF NOT ChangeListSize ( W ) THEN
       Error ( stWriteError, 0 );                        { Expansion failed!!! }
   END;
   P := @Buf;                                         { Transfer address }
   WHILE ( Count > 0 ) AND ( Status = stOk ) DO BEGIN     { Check status & count }
     CurBlock := Position DIV BlkSize;                { Current segment }
     { * REMARK * - Do not shorten this, result can be > 64K }
     Li := CurBlock;                                  { Transfer current block }
     Li := Li * BlkSize;                              { Current position }
     { * REMARK END * - Leon de Boer }
     BlockPos := Position - Li;                       { Current position }
     W := BlkSize - BlockPos;                         { Current block space }
     IF ( W > Count ) THEN W := Count;                  { Adjust write size }
     Q := Pointer ( LongInt ( BlkList^ [CurBlock] ) +
       BlockPos );                                     { Calc pointer }
     Move ( P^, Q^, W );                                 { Transfer data }
     Inc ( Position, W );                                { Adjust position }
     P := Pointer ( LongInt ( P ) + W );                    { Transfer address }
     Dec ( Count, W );                                   { Adjust count left }
     IF ( Position > StreamSize ) THEN                  { File expanded }
       StreamSize := Position;                        { Adjust stream size }
   END;
END;

{***************************************************************************}
{                      TMemoryStream PRIVATE METHODS                        }
{***************************************************************************}

{--TMemoryStream------------------------------------------------------------}
{  ChangeListSize -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19May96 LdB    }
{---------------------------------------------------------------------------}
FUNCTION TMemoryStream.ChangeListSize ( ALimit : Sw_Word ) : Boolean;
VAR I, W : Word16; Li : LongInt; P : PPointerArray;
BEGIN
   Li := 0;  { Delphi 3 gives a warning if this is not defined }
   IF ( ALimit <> BlkCount ) THEN BEGIN                 { Change is needed }
     ChangeListSize := False;                         { Preset failure }
     IF ( ALimit > MaxPtrs ) THEN Exit;                 { To many blocks req }
     IF ( ALimit <> 0 ) THEN BEGIN                      { Create segment list }
       Li := ALimit * SizeOf ( Pointer );                { Block array size }
       IF ( MaxAvail > Li ) THEN BEGIN
         GetMem ( P, Li );                               { Allocate memory }
         FillChar ( P^, Li, #0 );                        { Clear the memory }
       END ELSE Exit;                                 { Insufficient memory }
       IF ( BlkCount <> 0 ) AND ( BlkList <> Nil ) THEN   { Current list valid }
         IF ( BlkCount <= ALimit ) THEN Move ( BlkList^,
           P^, BlkCount * SizeOf ( Pointer ) ) ELSE       { Move whole old list }
           Move ( BlkList^, P^, Li );                    { Move partial list }
     END ELSE P := Nil;                               { No new block list }
     IF ( ALimit < BlkCount ) THEN                      { Shrink stream size }
       FOR W := BlkCount - 1 DOWNTO ALimit DO
         FreeMem ( BlkList^ [W], BlkSize );               { Release memory block }
     IF ( P <> Nil ) AND ( ALimit > BlkCount ) THEN BEGIN { Expand stream size }
       FOR W := BlkCount TO ALimit - 1 DO BEGIN
         IF ( MaxAvail < BlkSize ) THEN BEGIN           { Check enough memory }
           FOR I := BlkCount TO W - 1 DO
             FreeMem ( P^ [I], BlkSize );                 { Free mem allocated }
           FreeMem ( P, Li );                            { Release memory }
           Exit;                                      { Now exit }
         END ELSE GetMem ( P^ [W], BlkSize );             { Allocate memory }
       END;
     END;
     IF ( BlkCount <> 0 ) AND ( BlkList <> Nil ) THEN
       FreeMem ( BlkList, BlkCount * SizeOf ( Pointer ) );  { Release old list }
     BlkList := P;                                    { Hold new block list }
     BlkCount := ALimit;                              { Hold new count }
     { * REMARK * - Do not shorten this, result can be > 64K }
     MemSize := BlkCount;                             { Block count }
     MemSize := MemSize * BlkSize;                    { Current position }
     { * REMARK END * - Leon de Boer }
   END;
   ChangeListSize := True;                            { Successful }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TXmsStream OBJECT ANCESTOR                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TXmsStream---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Feb97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TXmsStream.Init ( MinSize, MaxSize : LongInt );
{$IFDEF PROC_Real}                                    { DOS REAL MODE CODE }
VAR Success : Integer; MinBlk, MaxBlk : Word16;
BEGIN
   Inherited Init;                                    { Call ancestor }
   IF ( XMS_MemAvail >= MaxSize ) THEN BEGIN            { Sufficient memory }
     IF ( MaxSize = 0 ) THEN MaxBlk := 1 ELSE           { At least one block }
       MaxBlk := ( MaxSize + 1023 ) DIV 1024;           { Max blocks needed }
     IF ( MinSize = 0 ) THEN MinBlk := 1 ELSE           { At least one block }
       MinBlk := ( MinSize + 1023 ) DIV 1024;           { Min blocks needed }
     Handle := XMS_GetMem ( MaxBlk );                    { Allocate XMS blocks }
     IF ( Handle <> 0 ) THEN BEGIN
       Success := 0;                                  { Preset success }
       BlocksUsed := MaxBlk;                          { Blocks used }
       IF ( MaxBlk <> MinBlk ) THEN                     { Sizes differ }
         IF ( XMS_ResizeMem ( MaxBlk, MinBlk, Handle ) = 0 ) { Resize to minimum }
           THEN BlocksUsed := MinBlk;                 { Hold block size }
       { * REMARK * - Do not shorten this, result can be > 64K }
       MemSize := BlocksUsed;
       MemSize := MemSize * 1024;
       { * REMARK END * - Leon de Boer }
     END ELSE Success := 303;                         { Failed to allocate }
   END ELSE Success := 300;                           { Insufficent XMS }
   IF ( Handle = 0 ) OR ( Success <> 0 ) THEN             { XMS failed }
     Error ( stInitError, Success );                     { Call stream error }
END;
{$ELSE}                                               { ALL OTHER OP SYSTEMS }
BEGIN
   Inherited Init ( MaxSize, 16384 );                    { For compatability }
END;
{$ENDIF}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TEmsStream OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TEmsStream---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 28Feb97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TEmsStream.Init ( MinSize, MaxSize : LongInt );
{$IFDEF PROC_Real}                                    { DOS REAL MODE CODE }
VAR Success : Integer; MinPg, MaxPg : Word16;
BEGIN
   Inherited Init;                                    { Call ancestor }
   IF ( EMS_MemAvail >= MaxSize ) THEN BEGIN            { Sufficient memory }
     IF ( MaxSize = 0 ) THEN MaxPg := 1 ELSE            { At least one page }
       MaxPg := ( MaxSize + 16383 ) DIV 16384;          { Max pages needed }
     IF ( MinSize = 0 ) THEN MinPg := 1 ELSE            { At least one page }
       MinPg := ( MinSize + 16383 ) DIV 16384;          { Min pages needed }
     Handle := EMS_GetMem ( MaxPg );                     { Allocate EMS pages }
     IF ( Handle <> 0 ) THEN BEGIN
       Success := 0;                                  { Preset success }
       PageCount := MaxPg;                            { Pages used }
       IF ( MaxPg <> MinPg ) THEN                       { Sizes differ }
         IF ( EMS_ResizeMem ( MinPg, Handle ) = 0 )          { Resize to minimum }
           THEN PageCount := MinPg;                   { Hold new page count }
       { * REMARK * - Do not shorten this, result can be > 64K }
       MemSize := PageCount;
       MemSize := MemSize * 16384;
       { * REMARK END * - Leon de Boer }
     END ELSE Success := 403;                         { Failed to allocate }
   END ELSE Success := 400;                           { Insufficent EMS }
   IF ( Handle = 0 ) OR ( Success <> 0 ) THEN             { EMS failed }
     Error ( stInitError, Success );                     { Call stream error }
END;
{$ELSE}                                               { ALL OTHER OS SYSTEMS }
BEGIN
   Inherited Init ( MaxSize, 16384 );                    { For compatability }
END;
{$ENDIF}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TCollection OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TCollection--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May01 AAO              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TCollection.Init ( ALimit, ADelta : Sw_Integer );
BEGIN
   Inherited Init;                                    { Call ancestor }
   Items := Nil;
   Count := 0;
   Limit := 0;
   Delta := ADelta;                                   { Set increment }
   SetLimit ( ALimit );                               { Set limit }
END;

{--TCollection--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TCollection.Load ( VAR S : TStream );
VAR C, I : Sw_Integer;
BEGIN
   S.Read ( Count, Sizeof ( Count ) );                      { Read count }
   S.Read ( Limit, Sizeof ( Limit ) );                      { Read limit }
   S.Read ( Delta, Sizeof ( Delta ) );                      { Read delta }
   Items := Nil;                                      { Clear item pointer }
   C := Count;                                        { Hold count }
   I := Limit;                                        { Hold limit }
   Count := 0;                                        { Clear count }
   Limit := 0;                                        { Clear limit }
   SetLimit ( I );                                       { Set requested limit }
   Count := C;                                        { Set count }
   FOR I := 0 TO C - 1 DO AtPut ( I, GetItem ( S ) );         { Get each item }
END;

{--TCollection--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May01 AAO              }
{---------------------------------------------------------------------------}
DESTRUCTOR TCollection.Done;
BEGIN
   FreeAll;                                           { Free all items }
   SetLimit ( 0 );                                    { Release all memory }
   Items := Nil;
   Count := 0;
   Limit := 0;
END;

{--TCollection--------------------------------------------------------------}
{  At -> Platforms DOS/DPMI/WIN/NT/OS2 -Updated 22May96 LdB                 }
{---------------------------------------------------------------------------}
FUNCTION TCollection.At ( Index : Sw_Integer ) : Pointer;
BEGIN
   IF ( Index < 0 ) OR ( Index >= Count ) THEN BEGIN      { Invalid index }
     Error ( coIndexError, Index );                      { Call error }
     At := Nil;                                       { Return nil }
   END ELSE At := Items^ [Index];                      { Return item }
END;

{--TCollection--------------------------------------------------------------}
{  IndexOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TCollection.IndexOf ( Item : Pointer ) : Sw_Integer;
VAR I : Sw_Integer;
BEGIN
   IF ( Count > 0 ) THEN BEGIN                          { Count is positive }
     FOR I := 0 TO Count - 1 DO                         { For each item }
       IF ( Items^ [I] = Item ) THEN BEGIN               { Look for match }
         IndexOf := I;                                { Return index }
         Exit;                                        { Now exit }
       END;
   END;
   IndexOf := - 1;                                     { Return index }
END;

{--TCollection--------------------------------------------------------------}
{  GetItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TCollection.GetItem ( VAR S : TStream ) : Pointer;
BEGIN
   GetItem := S.Get;                                  { Item off stream }
END;

{---------------------------------------------------------------------------}
{                          FUNCTION POINTER DEFINED                         }
{---------------------------------------------------------------------------}
TYPE
  {$IFDEF PPC_Virtual}                                  { VP is different }
     FuncPtr = FUNCTION ( Item : Pointer ) : Boolean;
  {$ELSE} {$IFDEF PPC_GPC}                              { So is GPC }
     FuncPtr = FUNCTION ( Item : Pointer ) : Boolean;
  {$ELSE}                                               { All others }
     FuncPtr = FUNCTION ( Item : Pointer; _EBP : Sw_Word ) : Boolean;
  {$ENDIF} {$ENDIF}

{--TCollection--------------------------------------------------------------}
{  LastThat -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO          }
{---------------------------------------------------------------------------}
FUNCTION TCollection.LastThat ( Test : Pointer ) : Pointer;
{$IFDEF BIT_16}                                       { 16 BIT CODE }
VAR I : Integer; Hold_BP : Sw_Word;
BEGIN
   ASM
     MOV AX, [BP];                                    { Load AX from BP }
     {$IFDEF OS_WINDOWS}
     AND AL, 0FEH;                                    { Windows make even }
     {$ENDIF}
     {$IFDEF OS_OS2}
     AND AL, 0FEH;                                    { OS2 make even }
     {$ENDIF}
     MOV [Hold_BP], AX;                               { Hold value }
   END;
   FOR I := Count DOWNTO 1 DO BEGIN                   { Down from last item }
     IF FuncPtr ( Test ) ( Items^ [I - 1], Hold_BP )           { Test each item }
     THEN BEGIN
       LastThat := Items^ [I - 1];                       { Return item }
       Exit;                                          { Now exit }
     END;
   END;
   LastThat := Nil;                                   { None passed test }
END;
{$ENDIF}
{$IFDEF PPC_GPC}
VAR
i : Integer;
fP : FuncPtr;
BEGIN
   LastThat := Nil;
   IF ( @Test = Nil ) THEN Exit;
   fp := FuncPtr ( Test );
   FOR i := Count DOWNTO 1 DO
   BEGIN
      IF fP ( Items^ [i - 1] )
      THEN BEGIN
         LastThat := Items^ [i - 1];
         Exit;
      END;
   END;
 END; {@@}
{$ENDIF} {PPC_GPC}

{$IFDEF BIT_32}                                       { 32 BIT CODE }
   {$IFDEF PPC_FPC}                                   { FPC COMPILER CODE }
   VAR I : LongInt; P : FuncPtr; Hold_EBP : Sw_Word;
   BEGIN
     ASM
     {$IFDEF CPU86}                                   { Intel processor }
       MOVL ( %EBP ), %EAX;                             { Load EBP }
       MOVL %EAX, Hold_EBP;                           { Store to local }
     {$ENDIF}
     {$IFDEF CPU68}                                   { 68x??? processor }
       move.l ( a6 ), d0;                               { Load EBP }
       move.l d0, Hold_EBP;                           { Store to local }
     {$ENDIF}
     END;

     P := FuncPtr ( Test );                              { Set function ptr }
     FOR I := Count DOWNTO 1 DO BEGIN                 { Down from last item }
       BEGIN                                          { Test each item }
         LastThat := Items^ [I - 1];                     { Return item }
         Exit;                                        { Now exit }
       END;
     END;
     LastThat := Nil;                                 { None passed test }
   END;
   {$ELSE}                                            { OTHER COMPILERS }
ASSEMBLER;{$IFDEF PPC_VIRTUAL} {$FRAME-} {$ENDIF}
   ASM
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     PUSH EBP;                                        { Preserve EBP }
     PUSH ESI;                                        { Preserve ESI }
     {$ENDIF}
     MOV EAX, Self;                                   { Pointer to self }
     MOV ECX, [EAX].TCollection.Count;                { Load count }
     JECXZ @@Exit;                                    { Exit if count=0 }
     MOV EAX, [EAX].TCollection.Items;                { Get items ptr }
     LEA ESI, [EAX + ECX * 4];                            { Addr of last item+4 }
     MOV EBX, Test;                                   { Address of test }
   @@1 :
     SUB ESI, 4;                                      { Previous item }
     PUSH EBX;                                        { Save test addr }
     PUSH ESI;                                        { Save item ptr }
     PUSH ECX;                                        { Save count }
     MOV EAX, [ESI];                                  { Item to test }
     PUSH EAX;                                        { Push item }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     PUSH EBP;                                        { Save base pointer }
     {$ENDIF}
     CALL EBX;                                        { Call test function }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     POP EBP;                                         { Recover base pointer }
     POP ECX;                                         { Pull back item ptr }
     {$ENDIF}
     POP ECX;                                         { Recover count }
     POP ESI;                                         { Recover item ptr }
     POP EBX;                                         { Recover test addr }
     TEST AL, AL;                                     { Test for true }
     JNZ @@2;                                         { Branch if true }
     LOOP @@1;                                        { Loop back again }
     JMP @@Exit;                                      { None passed test }
   @@2 :
     MOV ECX, [ESI];                                  { Xfer successful item }
   @@Exit :
     MOV EAX, ECX;                                    { Return item }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     POP ESI;                                         { Recover ESI register }
     POP EBP;                                         { Recover EBP register }
     {$ENDIF}
   END;
   {$ENDIF}
{$ENDIF}

{--TCollection--------------------------------------------------------------}
{  FirstThat -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO         }
{---------------------------------------------------------------------------}
FUNCTION TCollection.FirstThat ( Test : Pointer ) : Pointer;
{$IFDEF BIT_16}                                       { 16 BIT CODE }
VAR I : Integer; Hold_BP : Sw_Word;
BEGIN
   ASM
     MOV AX, [BP];                                    { Load AX from BP }
     {$IFDEF OS_WINDOWS}
     AND AL, 0FEH;                                    { Windows make even }
     {$ENDIF}
     {$IFDEF OS_OS2}
     AND AL, 0FEH;                                    { OS2 make even }
     {$ENDIF}
     MOV [Hold_BP], AX;                               { Hold value }
   END;
   FOR I := 1 TO Count DO BEGIN                       { Up from first item }
     IF FuncPtr ( Test ) ( Items^ [I - 1], Hold_BP )           { Test each item }
     THEN BEGIN
       FirstThat := Items^ [I - 1];                      { Return item }
       Exit;                                          { Now exit }
     END;
   END;
   FirstThat := Nil;                                  { None passed test }
END;
{$ENDIF}
{$IFDEF PPC_GPC}
VAR
i : Integer;
fP : FuncPtr;
BEGIN
   FirstThat := Nil;
   IF ( @Test = Nil ) THEN Exit;
   fp := FuncPtr ( Test );
   FOR i := 1 TO Count DO
   BEGIN
      IF fP ( Items^ [i - 1] )
      THEN BEGIN
         FirstThat := Items^ [i - 1];
         Exit;
      END;
   END;
 END; {@@}
{$ENDIF}  {PPC_GPC}


{$IFDEF BIT_32}                                       { 32 BIT CODE }
   {$IFDEF PPC_FPC}                                   { FPC COMPILER CODE }
   VAR I : LongInt; P : FuncPtr; Hold_EBP : Sw_Word;
   BEGIN
     ASM
     {$IFDEF CPU86}                                   { Intel processor }
       MOVL ( %EBP ), %EAX;                             { Load EBP }
       MOVL %EAX, Hold_EBP;                           { Store to local }
     {$ENDIF}
     {$IFDEF CPU68}                                   { 68x??? processor }
       move.l ( a6 ), d0;                               { Load EBP }
       move.l d0, Hold_EBP;                           { Store to local }
     {$ENDIF}
     END;
     P := FuncPtr ( Test );                              { Set function ptr }
     FOR I := 1 TO Count DO BEGIN                     { Up from first item }
       BEGIN                                          { Test each item }
         FirstThat := Items^ [I - 1];                    { Return item }
         Exit;                                        { Now exit }
       END;
     END;
     FirstThat := Nil;                                { None passed test }
   END;
   {$ELSE}                                            { OTHER COMPILERS }

   ASSEMBLER; {$IFDEF PPC_VIRTUAL} {$FRAME-} {$ENDIF}
   ASM
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     PUSH EBP;                                        { Preserve EBP }
     PUSH ESI;                                        { Preserve ESI }
     {$ENDIF}
     MOV EAX, Self;                                   { Pointer to self }
     MOV ECX, [EAX].TCollection.Count;                { Load count }
     JECXZ @@Exit;                                    { Exit if count=0 }
     MOV EBX, Test;                                   { Load test addr }
     MOV ESI, [EAX].TCollection.Items;                { Load items pointer }
   @@1 :
     PUSH EBX;                                        { Save test addr }
     PUSH ESI;                                        { Save item ptr }
     PUSH ECX;                                        { Save count }
     MOV EAX, [ESI];                                  { Item to test }
     PUSH EAX;                                        { Push item }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     PUSH EBP;                                        { Save base pointer }
     {$ENDIF}
     CALL EBX;                                        { Call test function }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     POP EBP;                                         { Recover base pointer }
     POP ECX;                                         { Pull back item ptr }
     {$ENDIF}
     POP ECX;                                         { Recover count }
     POP ESI;                                         { Recover item ptr }
     POP EBX;                                         { Recover test addr }
     TEST AL, AL;                                     { Test for true }
     JNZ @@2;                                         { Branch if true }
     ADD ESI, 4;                                      { Next item }
     LOOP @@1;                                        { Loop back again }
     JMP @@Exit;                                      { None passed test }
   @@2 :
     MOV ECX, [ESI];                                  { Xfer successful item }
   @@Exit :
     MOV EAX, ECX;                                    { Return item }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     POP ESI;                                         { Recover ESI register }
     POP EBP;                                         { Recover EBP register }
     {$ENDIF}
   END;
   {$ENDIF}
{$ENDIF}

{--TCollection--------------------------------------------------------------}
{  Pack -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Pack;
VAR I, J : Sw_Integer;
BEGIN
   I := 0;                                            { Initialize dest }
   J := 0;                                            { Intialize test }
   WHILE ( I < Count ) AND ( J < Limit ) DO BEGIN         { Check fully packed }
     IF ( Items^ [J] <> Nil ) THEN BEGIN                 { Found a valid item }
       IF ( I <> J ) THEN BEGIN
         Items^ [I] := Items^ [J];                      { Transfer item }
         Items^ [J] := Nil;                            { Now clear old item }
       END;
       Inc ( I );                                        { One item packed }
     END;
     Inc ( J );                                          { Next item to test }
   END;
   IF ( I < Count ) THEN Count := I;                    { New packed count }
END;

{--TCollection--------------------------------------------------------------}
{  FreeAll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24Apr99 AAO           }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.FreeAll;
VAR I : Sw_Integer;
BEGIN
   FOR I := Pred ( Count ) DOWNTO 0 DO FreeItem ( At ( I ) ); { Release each item }
   Count := 0;                                   { Clear item count }
END;

{--TCollection--------------------------------------------------------------}
{  DeleteAll -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB         }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.DeleteAll;
BEGIN
   Count := 0;                                        { Clear item count }
END;

{--TCollection--------------------------------------------------------------}
{  Free -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Free ( Item : Pointer );
BEGIN
   Delete ( Item );                                      { Delete from list }
   FreeItem ( Item );                                    { Free the item }
END;

{--TCollection--------------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Insert ( Item : Pointer );
BEGIN
   AtInsert ( Count, Item );                             { Insert item }
END;

{--TCollection--------------------------------------------------------------}
{  Delete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Delete ( Item : Pointer );
BEGIN
   AtDelete ( IndexOf ( Item ) );                           { Delete from list }
END;

{--TCollection--------------------------------------------------------------}
{  AtFree -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.AtFree ( Index : Sw_Integer );
VAR Item : Pointer;
BEGIN
   Item := At ( Index );                                 { Retreive item ptr }
   AtDelete ( Index );                                   { Delete item }
   FreeItem ( Item );                                    { Free the item }
END;

{--TCollection--------------------------------------------------------------}
{  FreeItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24Apr99 AAO          }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.FreeItem ( Item : Pointer );
VAR P : PObject;
BEGIN
   P := PObject ( Item );                                { Convert pointer }
   IF Assigned ( Item )
   THEN BEGIN
       { p^.Done; @@ causes crash! }
     {$ifdef PPC_DELPHI} TRY {$endif}
       If Indexof (Item) > -1
       then begin
         Dispose ( p );
       end;
     {$ifdef PPC_DELPHI} EXCEPT END; {$endif}
   END;
END;

{--TCollection--------------------------------------------------------------}
{  AtDelete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.AtDelete ( Index : Sw_Integer );
BEGIN
   IF ( Index >= 0 ) AND ( Index < Count ) THEN BEGIN     { Valid index }
     Dec ( Count );                                      { One less item }
     IF ( Count > Index ) THEN Move ( Items^ [Index + 1],
      Items^ [Index], ( Count - Index ) * Sizeof ( Pointer ) );  { Shuffle items down }
   END ELSE Error ( coIndexError, Index );               { Index error }
END;

{---------------------------------------------------------------------------}
{                         PROCEDURE POINTER DEFINED                         }
{---------------------------------------------------------------------------}
TYPE
 {$ifdef PPC_GPC}
   ProcPtr = PROCEDURE ( Item : Pointer );
 {$else}
   ProcPtr = PROCEDURE ( Item : Pointer; _EBP : Sw_Word );
 {$endif}

{--TCollection--------------------------------------------------------------}
{  ForEach -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO           }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.ForEach ( Action : Pointer );
{$IFDEF BIT_16}                                       { 16 BIT CODE }
VAR I : LongInt; Hold_BP : Sw_Word;
BEGIN
   ASM
   {$IFDEF BIT_16}                                    { 16 BIT CODE }
     MOV AX, [BP];                                    { Load AX from BP }
     {$IFDEF OS_WINDOWS}
     AND AL, 0FEH;                                    { Windows make even }
     {$ENDIF}
     {$IFDEF OS_OS2}
     AND AL, 0FEH;                                    { OS2 make even }
     {$ENDIF}
     MOV [Hold_BP], AX;                               { Hold value }
   {$ENDIF}
   END;
   FOR I := 1 TO Count DO                             { Up from first item }
     ProcPtr ( Action ) ( Items^ [I - 1], Hold_BP );           { Call with each item }
END;
{$ENDIF}
{$IFDEF PPC_GPC}
  VAR
  i : Integer;
  fP : ProcPtr;
 BEGIN
   IF ( @Action = Nil ) THEN Exit;
   fp := ProcPtr ( Action );
   FOR i := 1 TO Count DO fP ( Items^ [i - 1] );
 END; {@@}
{$ENDIF}  {PPC_GPC}
{$IFDEF BIT_32}                                       { 32 BIT CODE }
   {$IFDEF PPC_FPC}                                   { FPC COMPILER CODE }
   VAR I : LongInt; Hold_EBP : Sw_Word; P : ProcPtr;
   BEGIN
     ASM
     {$IFDEF CPU86}                                   { Intel processor }
       MOVL ( %EBP ), %EAX;                             { Load EBP }
       MOVL %EAX, Hold_EBP;                           { Store to local }
     {$ENDIF}
     {$IFDEF CPU68}                                   { 68x??? processor }
       move.l ( a6 ), d0;                               { Load EBP }
       move.l d0, Hold_EBP;                           { Store to local }
     {$ENDIF}
     END;
     P := ProcPtr ( Action );                            { Set procedure ptr }
     FOR I := 1 TO Count DO                           { Up from first item }
       P ( Items^ [I - 1], Hold_EBP );                      { Call with each item }
   END;
   {$ELSE}                                            { OTHER COMPILERS }
   ASSEMBLER; {$IFDEF PPC_VIRTUAL} {$FRAME-} {$ENDIF}
   ASM
     MOV EAX, Self;                                   { Pointer to self }
     MOV ECX, [EAX].TCollection.Count;                { Load count }
     JECXZ @@Exit;                                    { Exit if count=0 }
     MOV EBX, Action;                                 { Action ptr to EBX }
     MOV EAX, [EAX].TCollection.Items;                { Get item pointer }
   @@1 :
     PUSH EBX;                                        { Save action ptr }
     PUSH EAX;                                        { Save item ptr }
     PUSH ECX;                                        { Save loop count }
     MOV EAX, [EAX];                                  { Item to test }
     PUSH EAX;                                        { Push item to stack }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3 COMPILER }
     PUSH EBP;                                        { Save base pointer }
     {$ENDIF}
     CALL EBX;                                        { Call the procdure }
     {$IFDEF PPC_DELPHI3}
     POP EBP;                                         { Recover base pointer }
     POP EAX;                                         { Pull back item }
     {$ENDIF}
     POP ECX;                                         { Recover the count }
     POP EAX;                                         { Recover the item ptr }
     POP EBX;                                         { Recover action ptr }
     ADD EAX, 4;                                      { Move to next item }
     LOOP @@1;                                        { Loop for all items }
   @@Exit :
   END;
   {$ENDIF}
{$ENDIF}

{--TCollection--------------------------------------------------------------}
{  SetLimit -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.SetLimit ( ALimit : Sw_Integer );
VAR AItems : PItemList;
BEGIN

   IF ( ALimit < Count ) THEN ALimit := Count;          { Stop underflow }
   IF ( ALimit > MaxCollectionSize ) THEN
     ALimit := MaxCollectionSize;                     { Stop overflow }

   IF ( ALimit <> Limit )
   THEN BEGIN                    { Limits differ }
     IF ( ALimit = 0 ) THEN AItems := Nil
     ELSE BEGIN    { Alimit=0 nil entry }
       GetMem ( AItems, ALimit * SizeOf ( Pointer ) );      { Allocate memory }
       IF ( AItems <> Nil ) THEN FillChar ( AItems^,
         ALimit * SizeOf ( Pointer ), #0 );               { Clear the memory }
     END;

     IF ( AItems <> Nil ) OR ( ALimit = 0 )
     THEN BEGIN        { Check success }

       IF ( AItems <> Nil ) AND ( Items <> Nil ) THEN      { Check both valid }
         Move ( Items^, AItems^, Count * SizeOf ( Pointer ) );{ Move existing items }

       IF ( Limit <> 0 )
       AND ( Items <> Nil ) THEN        { Check old allocation }
        FreeMem ( Items, Limit * SizeOf ( Pointer ) );     { Release memory }
       Items := AItems;                               { Update items }
       Limit := ALimit;                               { Set limits }
     END;
   END;
END;

{--TCollection--------------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Error ( Code, Info : Integer );
BEGIN
   RunError ( 212 - Code );                              { Run error }
END;

{--TCollection--------------------------------------------------------------}
{  AtPut -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.AtPut ( Index : Sw_Integer; Item : Pointer );
BEGIN
   IF ( Index >= 0 ) AND ( Index < Count ) THEN           { Index valid }
     Items^ [Index] := Item                            { Put item in index }
     ELSE Error ( coIndexError, Index );                 { Index error }
END;

{--TCollection--------------------------------------------------------------}
{  AtInsert -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.AtInsert ( Index : Sw_Integer; Item : Pointer );
VAR I : Sw_Integer;
BEGIN
   IF ( Index >= 0 ) AND ( Index <= Count )
   THEN BEGIN    { Valid index }
     IF ( Count = Limit ) THEN SetLimit ( Limit + Delta );     { Expand size if able }
     IF ( Limit > Count )
     THEN BEGIN
       IF ( Index < Count ) THEN BEGIN                  { Not last item }
         FOR I := Count DOWNTO Index DO               { Start from back }
           If I > 0  then {this line added 23/Feb/2005}
           Items^ [I] := Items^ [I - 1];                  { Move each item }
       END;
       Items^ [Index] := Item;                         { Put item in list }
       Inc ( Count );                                    { Inc count }
     END ELSE Error ( coOverflow, Index );               { Expand failed }
   END ELSE Error ( coIndexError, Index );               { Index error }
END;

{--TCollection--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.Store ( VAR S : TStream );

   PROCEDURE DoPutItem ( P : Pointer ); {$IFNDEF FPC} {$IFNDEF PPC_GPC}FAR;{$ENDIF}{$ENDIF}
   BEGIN
     PutItem ( S, P );                                   { Put item on stream }
   END;

BEGIN
   S.Write ( Count, Sizeof ( Count ) );                     { Write count }
   S.Write ( Limit, Sizeof ( Limit ) );                     { Write limit }
   S.Write ( Delta, Sizeof ( Delta ) );                     { Write delta }
   ForEach ( @DoPutItem );                               { Each item to stream }
END;

{--TCollection--------------------------------------------------------------}
{  PutItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TCollection.PutItem ( VAR S : TStream; Item : Pointer );
BEGIN
   S.Put ( Item );                                       { Put item on stream }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TSortedCollection OBJECT METHODS                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TSortedCollection--------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TSortedCollection.Init ( ALimit, ADelta : Sw_Integer );
BEGIN
   Inherited Init ( ALimit, ADelta );                    { Call ancestor }
   Duplicates := False;                               { Clear flag }
END;

{--TSortedCollection--------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TSortedCollection.Load ( VAR S : TStream );
BEGIN
   Inherited Load ( S );                                 { Call ancestor }
   S.Read ( Duplicates, SizeOf ( Duplicates ) );            { Read duplicate flag }
END;

{--TSortedCollection--------------------------------------------------------}
{  KeyOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TSortedCollection.KeyOf ( Item : Pointer ) : Pointer;
BEGIN
   KeyOf := Item;                                     { Return item as key }
END;

{--TSortedCollection--------------------------------------------------------}
{  IndexOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TSortedCollection.IndexOf ( Item : Pointer ) : Sw_Integer;
VAR I, J : Sw_Integer;
BEGIN
   J := - 1;                                           { Preset result }
   IF Search ( KeyOf ( Item ), I ) THEN BEGIN               { Search for item }
     IF Duplicates THEN                               { Duplicates allowed }
       WHILE ( I < Count ) AND ( Item <> Items^ [I] ) DO
         Inc ( I );                                      { Count duplicates }
     IF ( I < Count ) THEN J := I;                      { Index result }
   END;
   IndexOf := J;                                      { Return result }
END;

{--TSortedCollection--------------------------------------------------------}
{  Compare -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
{$ifdef PPC_GPC}{$W-}{$endif}
FUNCTION TSortedCollection.Compare ( Key1, Key2 : Pointer ) : Sw_Integer;
BEGIN
   Compare := 0;
   Abstract;                                          { Abstract method }
END;
{$ifdef PPC_GPC}{$W+}{$endif}

{--TSortedCollection--------------------------------------------------------}
{  Search -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB            }
{---------------------------------------------------------------------------}
FUNCTION TSortedCollection.Search ( Key : Pointer; VAR Index : Sw_Integer ) : Boolean;
VAR L, H, I, C : Sw_Integer;
BEGIN
   Search := False;                                   { Preset failure }
   L := 0;                                            { Start count }
   H := Count - 1;                                    { End count }
   WHILE ( L <= H ) DO BEGIN
     I := ( L + H ) SHR 1;                              { Mid point }
     C := Compare ( KeyOf ( Items^ [I] ), Key );             { Compare with key }
     IF ( C < 0 ) THEN L := I + 1 ELSE BEGIN            { Item to left }
       H := I - 1;                                    { Item to right }
       IF C = 0 THEN BEGIN                            { Item match found }
         Search := True;                              { Result true }
         IF NOT Duplicates THEN L := I;               { Force kick out }
       END;
     END;
   END;
   Index := L;                                        { Return result }
END;

{--TSortedCollection--------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TSortedCollection.Insert ( Item : Pointer );
VAR I : Sw_Integer;
BEGIN
   IF NOT Search ( KeyOf ( Item ), I ) OR Duplicates THEN   { Item valid }
     AtInsert ( I, Item );                               { Insert the item }
END;

{--TSortedCollection--------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TSortedCollection.Store ( VAR S : TStream );
BEGIN
   TCollection.Store ( S );                              { Call ancestor }
   S.Write ( Duplicates, SizeOf ( Duplicates ) );           { Write duplicate flag }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TStringCollection OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStringCollection--------------------------------------------------------}
{  GetItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStringCollection.GetItem ( VAR S : TStream ) : Pointer;
BEGIN
   GetItem := S.ReadStr;                              { Get new item }
END;

{--TStringCollection--------------------------------------------------------}
{  Compare -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 21Aug97 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStringCollection.Compare ( Key1, Key2 : Pointer ) : Sw_Integer;
VAR I, J : Integer; P1, P2 : PString;
BEGIN
   P1 := PString ( Key1 );                               { String 1 pointer }
   P2 := PString ( Key2 );                               { String 2 pointer }
   IF ( Length ( P1^ ) < Length ( P2^ ) ) THEN J := Length ( P1^ )
     ELSE J := Length ( P2^ );                           { Shortest length }
   I := 1;                                            { First character }
   WHILE ( I < J ) AND ( P1^ [I] = P2^ [I] ) DO Inc ( I );         { Scan till fail }
   IF ( I = J ) THEN BEGIN                                { Possible match }
   { * REMARK * - Bug fix   21 August 1997 }
     IF ( P1^ [I] < P2^ [I] ) THEN Compare := - 1 ELSE       { String1 < String2 }
       IF ( P1^ [I] > P2^ [I] ) THEN Compare := 1 ELSE      { String1 > String2 }
       IF ( Length ( P1^ ) > Length ( P2^ ) ) THEN Compare := 1 { String1 > String2 }
         ELSE IF ( Length ( P1^ ) < Length ( P2^ ) ) THEN       { String1 < String2 }
           Compare := - 1 ELSE Compare := 0;           { String1 = String2 }
   { * REMARK END * - Leon de Boer }
   END ELSE IF ( P1^ [I] < P2^ [I] ) THEN Compare := - 1     { String1 < String2 }
     ELSE Compare := 1;                               { String1 > String2 }
END;

{--TStringCollection--------------------------------------------------------}
{  FreeItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TStringCollection.FreeItem ( Item : Pointer );
BEGIN
   DisposeStr ( Item );                                  { Dispose item }
END;

{--TStringCollection--------------------------------------------------------}
{  PutItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22May96 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TStringCollection.PutItem ( VAR S : TStream; Item : Pointer );
BEGIN
   S.WriteStr ( Item );                                  { Write string }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TStrCollection OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStrCollection-----------------------------------------------------------}
{  Compare -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStrCollection.Compare ( Key1, Key2 : Pointer ) : Sw_Integer;
VAR I, J : Sw_Integer; P1, P2 : PByteArray;
BEGIN
   P1 := PByteArray ( Key1 );                            { PChar 1 pointer }
   P2 := PByteArray ( Key2 );                            { PChar 2 pointer }
   I := 0;                                            { Preset no size }
   IF ( P1 <> Nil ) THEN WHILE ( P1^ [I] <> 0 ) DO Inc ( I ); { PChar 1 length }
   J := 0;                                            { Preset no size }
   IF ( P2 <> Nil ) THEN WHILE ( P2^ [J] <> 0 ) DO Inc ( J ); { PChar 2 length }
   IF ( I < J ) THEN J := I;                            { Shortest length }
   I := 0;                                            { First character }
   WHILE ( I < J ) AND ( P1^ [I] = P2^ [I] ) DO Inc ( I );     { Scan till fail }
   IF ( P1^ [I] = P2^ [I] ) THEN Compare := 0 ELSE        { Strings matched }
     IF ( P1^ [I] < P2^ [I] ) THEN Compare := - 1 ELSE     { String1 < String2 }
        Compare := 1;                                 { String1 > String2 }
END;

{--TStrCollection-----------------------------------------------------------}
{  GetItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May96 LdB           }
{---------------------------------------------------------------------------}
FUNCTION TStrCollection.GetItem ( VAR S : TStream ) : Pointer;
BEGIN
   GetItem := S.StrRead;                              { Get string item }
END;

{--TStrCollection-----------------------------------------------------------}
{  FreeItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 16Feb99 AAO          }
{---------------------------------------------------------------------------}
PROCEDURE TStrCollection.FreeItem ( Item : Pointer );
VAR I : Sw_Integer; P : PByteArray;
BEGIN
 IF ( Item <> Nil ) THEN BEGIN                        { Item is valid }
     P := PByteArray ( Item );                           { Create byte pointer }
     I := 0;                                          { Preset no size }
     WHILE ( P^ [I] <> 0 ) DO Inc ( I );                    { Find PChar end }
     {.$ifndef PPC_DELPHI}
     FreeMem ( Item, I + 1 );                              { Release memory }
     {.$endif}
 END;
END;

{--TStrCollection-----------------------------------------------------------}
{  PutItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May96 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TStrCollection.PutItem ( VAR S : TStream; Item : Pointer );
BEGIN
   S.StrWrite ( Item );                                  { Write the string }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                   TUnSortedStrCollection OBJECT METHODS                   }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TUnSortedCollection------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TUnSortedStrCollection.Insert ( Item : Pointer );
BEGIN
   AtInsert ( Count, Item );                             { Insert - NO sorting }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TResourceItem RECORD                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
TYPE
   TResourceItem = RECORD
      Posn : LongInt;                                  { Resource position }
      Size : LongInt;                                  { Resource size }
      Key : sw_String;                                { Resource key }
   END;
   PResourceItem = ^TResourceItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    TResourceCollection OBJECT METHODS                     }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TResourceCollection------------------------------------------------------}
{  KeyOf -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24May96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TResourceCollection.KeyOf ( Item : Pointer ) : Pointer;
BEGIN
   KeyOf := @PResourceItem ( Item ) ^.Key;                { Pointer to key }
END;

{--TResourceCollection------------------------------------------------------}
{  GetItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May01 AAO           }
{---------------------------------------------------------------------------}
FUNCTION TResourceCollection.GetItem ( VAR S : TStream ) : Pointer;
VAR B : Byte; Pos, Size : LongInt; P : PResourceItem; {Ts: sw_String;}
BEGIN
   S.Read ( Pos, SizeOf ( Pos ) );                          { Read position }
   S.Read ( Size, SizeOf ( Size ) );                        { Read size }
   S.Read ( B, 1 );                                      { Read key length }
   GetMem ( P, B + ( SizeOf ( TResourceItem ) -
     SizeOf ( {TS}sw_String ) + 1 ) );                     { Allocate min memory }
   IF ( P <> Nil ) THEN BEGIN                             { If allocate works }
     P^.Posn := Pos;                                  { Xfer position }
     P^.Size := Size;                                 { Xfer size }
     {$IFDEF NON_BP_STRINGS}
     SetLength ( P^.Key, B );                            { Xfer string length }
     {$ELSE}
       P^.Key [0] := Chr ( B );                           { Xfer string length }
     {$ENDIF}
     S.Read ( P^.Key [1], B );                            { Xfer string data }
   END;
   GetItem := P;                                      { Return pointer }
END;

{--TResourceCollection------------------------------------------------------}
{  FreeItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24May96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TResourceCollection.FreeItem ( Item : Pointer );
{VAR S: sw_String;}
BEGIN
   IF ( Item <> Nil ) THEN FreeMem ( Item,
     SizeOf ( TResourceItem ) - SizeOf ( {S}sw_String ) +
     Length ( PResourceItem ( Item ) ^.Key ) + 1 );           { Release memory }
END;

{--TResourceCollection------------------------------------------------------}
{  PutItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 24May96 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TResourceCollection.PutItem ( VAR S : TStream; Item : Pointer );
{VAR Ts: sw_String;}
BEGIN
   IF ( Item <> Nil ) THEN S.Write ( PResourceItem ( Item ) ^,
    SizeOf ( TResourceItem ) - SizeOf ( {Ts}sw_String ) +
    Length ( PResourceItem ( Item ) ^.Key ) + 1 );            { Write to stream }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                  PRIVATE RESOURCE MANAGER CONSTANTS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{$ifdef BIT_16}
CONST
{$else}
VAR
{$endif}
   RStreamMagic : LongInt = $52504246;                 { 'FBPR' }
   RStreamBackLink : LongInt = $4C424246;              { 'FBBL' }

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    PRIVATE RESOURCE MANAGER TYPES                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
TYPE
{$IFDEF NewExeFormat}                                 { New EXE format }
   TExeHeader = RECORD
     eHdrSize :   Word16;
     eMinAbove :  Word16;
     eMaxAbove :  Word16;
     eInitSS :    Word16;
     eInitSP :    Word16;
     eCheckSum :  Word16;
     eInitPC :    Word16;
     eInitCS :    Word16;
     eRelocOfs :  Word16;
     eOvlyNum :   Word16;
     eRelocTab :  Word16;
     eSpace :     ARRAY [1..30] OF Byte;
     eNewHeader : Word16;
   END;
{$ENDIF}

   THeader = RECORD
     Signature : Word16;
     CASE Integer OF
       0 : (
         LastCount : Word16;
         PageCount : Word16;
         ReloCount : Word16 );
       1 : (
         InfoType : Word16;
         InfoSize : Longint );
   END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TResourceFile OBJECT METHODS                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TResourceFile------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TResourceFile.Init ( AStream : PStream );
VAR Found, Stop : Boolean; Header : THeader;
    {$IFDEF NewExeFormat} ExeHeader : TExeHeader; {$ENDIF}
BEGIN
   TObject.Init;                                      { Initialize object }
   Found := False;                                    { Preset false }
   IF ( Stream <> Nil ) THEN BEGIN
     Stream := AStream;                               { Hold stream }
     BasePos := Stream^.GetPos;                       { Get position }
     REPEAT
       Stop := True;                                  { Preset stop }
       IF ( BasePos <= Stream^.GetSize - SizeOf ( THeader ) )
       THEN BEGIN                                     { Valid file header }
         Stream^.Seek ( BasePos );                       { Seek to position }
         Stream^.Read ( Header, SizeOf ( THeader ) );       { Read header }
         CASE Header.Signature OF
         {$IFDEF NewExeFormat}                        { New format file }
           $5A4D : BEGIN
             Stream^.Read ( ExeHeader, SizeOf ( TExeHeader ) );
             BasePos := ExeHeader.eNewHeader;         { Hold position }
             Stop := False;                           { Clear stop flag }
           END;
           $454E : BEGIN
             BasePos := Stream^.GetSize - 8;          { Hold position }
             Stop := False;                           { Clear stop flag }
           END;
           $4246 : BEGIN
             Stop := False;                           { Clear stop flag }
             CASE Header.Infotype OF
               $5250 : BEGIN                           { Found Resource }
                   Found := True;                     { Found flag is true }
                   Stop := True;                      { Set stop flag }
                 END;
               $4C42 : Dec ( BasePos, Header.InfoSize - 8 );{ Found BackLink }
               $4648 : Dec ( BasePos, SizeOf ( THeader ) * 2 );{ Found HelpFile }
               ELSE Stop := True;                     { Set stop flag }
             END;
           END;
           $424E : IF Header.InfoType = $3230          { Found Debug Info }
           THEN BEGIN
             Dec ( BasePos, Header.InfoSize );           { Adjust position }
             Stop := False;                           { Clear stop flag }
           END;
         {$ELSE}
           $5A4D : BEGIN
             Inc ( BasePos, LongInt ( Header.PageCount ) * 512
               - (  - Header.LastCount AND 511 ) );        { Calc position }
             Stop := False;                           { Clear stop flag }
           END;
           $4246 : IF Header.InfoType = $5250 THEN     { Header was found }
             Found := True ELSE BEGIN
               Inc ( BasePos, Header.InfoSize + 8 );     { Adjust position }
               Stop := False;                         { Clear stop flag }
             END;
         {$ENDIF}
         END;
       END;
     UNTIL Stop;                                      { Until flag is set }
   END;
   IF Found THEN BEGIN                                { Resource was found }
     Stream^.Seek ( BasePos + SizeOf ( LongInt ) * 2 );     { Seek to position }
     Stream^.Read ( IndexPos, SizeOf ( LongInt ) );         { Read index position }
     Stream^.Seek ( BasePos + IndexPos );                { Seek to resource }
     Index.Load ( Stream^ );                             { Load resource }
   END ELSE BEGIN
     IndexPos := SizeOf ( LongInt ) * 3;                 { Set index position }
     Index.Init ( 0, 8 );                                { Set index }
   END;
END;

{--TResourceFile------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TResourceFile.Done;
BEGIN
   Flush;                                             { Flush the file }
   Index.Done;                                        { Dispose of index }
   IF ( Stream <> Nil ) THEN Dispose ( Stream, Done );     { Dispose of stream }
END;

{--TResourceFile------------------------------------------------------------}
{  Count -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TResourceFile.Count : Sw_Integer;
BEGIN
   Count := Index.Count;                              { Return index count }
END;

{--TResourceFile------------------------------------------------------------}
{  KeyAt -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TResourceFile.KeyAt ( I : Sw_Integer ) : sw_String;
BEGIN
   KeyAt := PResourceItem ( Index.At ( I ) ) ^.Key;          { Return key }
END;

{--TResourceFile------------------------------------------------------------}
{  Get -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TResourceFile.Get ( Key : sw_String ) : PObject;
VAR I : Sw_Integer;
BEGIN
   IF ( Stream = Nil ) OR ( NOT Index.Search ( @Key, I ) )   { No match on key }
   THEN Get := Nil ELSE BEGIN
     Stream^.Seek ( BasePos +
       PResourceItem ( Index.At ( I ) ) ^.Posn );             { Seek to position }
     Get := Stream^.Get;                              { Get item }
   END;
END;

{--TResourceFile------------------------------------------------------------}
{  SwitchTo -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB          }
{---------------------------------------------------------------------------}
FUNCTION TResourceFile.SwitchTo ( AStream : PStream; Pack : Boolean ) : PStream;
VAR NewBasePos : LongInt;

   PROCEDURE DoCopyResource ( Item : PResourceItem );{$IFDEF PPC_BP}FAR;{$ENDIF}
   BEGIN
     Stream^.Seek ( BasePos + Item^.Posn );              { Move stream position }
     Item^.Posn := AStream^.GetPos - NewBasePos;      { Hold new position }
     AStream^.CopyFrom ( Stream{$ifndef ver90}^{$endif}, Item^.Size );          { Copy the item }
   END;

BEGIN
   SwitchTo := Stream;                                { Preset return }
   IF ( AStream <> Nil ) AND ( Stream <> Nil ) THEN BEGIN { Both streams valid }
     NewBasePos := AStream^.GetPos;                   { Get position }
     IF Pack THEN BEGIN
       AStream^.Seek ( NewBasePos + SizeOf ( LongInt ) * 3 ); { Seek to position }
       Index.ForEach ( @DoCopyResource );                { Copy each resource }
       IndexPos := AStream^.GetPos - NewBasePos;      { Hold index position }
     END ELSE BEGIN
       Stream^.Seek ( BasePos );                         { Seek to position }
       AStream^.CopyFrom ( Stream{$ifndef ver90}^{$endif}, IndexPos );          { Copy the resource }
     END;
     Stream := AStream;                               { Hold new stream }
     BasePos := NewBasePos;                           { New base position }
     Modified := True;                                { Set modified flag }
   END;
END;

{--TResourceFile------------------------------------------------------------}
{  Flush -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TResourceFile.Flush;
VAR ResSize : LongInt; LinkSize : LongInt;
BEGIN
   IF ( Modified ) AND ( Stream <> Nil ) THEN BEGIN       { We have modification }
     Stream^.Seek ( BasePos + IndexPos );                { Seek to position }
     Index.Store ( Stream^ );                            { Store the item }
     ResSize := Stream^.GetPos - BasePos;             { Hold position }
     LinkSize := ResSize + SizeOf ( LongInt ) * 2;       { Hold link size }
     Stream^.Write ( RStreamBackLink, SizeOf ( LongInt ) ); { Write link back }
     Stream^.Write ( LinkSize, SizeOf ( LongInt ) );        { Write link size }
     Stream^.Seek ( BasePos );                           { Move stream position }
     Stream^.Write ( RStreamMagic, SizeOf ( LongInt ) );    { Write number }
     Stream^.Write ( ResSize, SizeOf ( LongInt ) );         { Write record size }
     Stream^.Write ( IndexPos, SizeOf ( LongInt ) );        { Write index position }
     Stream^.Flush;                                   { Flush the stream }
   END;
   Modified := False;                                 { Clear modified flag }
END;

{--TResourceFile------------------------------------------------------------}
{  Delete -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TResourceFile.Delete ( Key : sw_String );
VAR I : Sw_Integer;
BEGIN
   IF Index.Search ( @Key, I ) THEN BEGIN                { Search for key }
     Index.Free ( Index.At ( I ) );                         { Delete from index }
     Modified := True;                                { Set modified flag }
   END;
END;

{--TResourceFile------------------------------------------------------------}
{  Put -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 18Jun96 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TResourceFile.Put ( Item : PObject; Key : sw_String );
VAR I : Sw_Integer; P : PResourceItem;
BEGIN
   IF ( Stream = Nil ) THEN Exit;                       { Stream not valid }
   IF Index.Search ( @Key, I ) THEN P := Index.At ( I )     { Search for item }
   ELSE BEGIN
     GetMem ( P, Length ( Key ) + ( SizeOf ( TResourceItem ) -
       SizeOf ( Key ) + 1 ) );                             { Allocate memory }
     IF ( P <> Nil ) THEN BEGIN
       P^.Key := Key;                                 { Store key }
       Index.AtInsert ( I, P );                          { Insert item }
     END;
   END;
   IF ( P <> Nil ) THEN BEGIN
     P^.Posn := IndexPos;                             { Set index position }
     Stream^.Seek ( BasePos + IndexPos );                { Seek file position }
     Stream^.Put ( Item );                               { Put item on stream }
     IndexPos := Stream^.GetPos - BasePos;            { Hold index position }
     P^.Size := IndexPos - P^.Posn;                   { Calc size }
     Modified := True;                                { Set modified flag }
   END;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TStringList OBJECT METHODS                       }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStringList--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TStringList.Load ( VAR S : TStream );
VAR Size : Word16;
BEGIN
   Stream := @S;                                      { Hold stream pointer }
   S.Read ( Size, SizeOf ( Word16 ) );                      { Read size }
   BasePos := S.GetPos;                               { Hold position }
   S.Seek ( BasePos + Size );                            { Seek to position }
   S.Read ( IndexSize, SizeOf ( Integer ) );                { Read index size }
   GetMem ( Index, IndexSize * SizeOf ( TStrIndexRec ) );   { Allocate memory }
   S.Read ( Index^, IndexSize * SizeOf ( TStrIndexRec ) );  { Read indexes }
END;

{--TStringList--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TStringList.Done;
BEGIN
   FreeMem ( Index, IndexSize * SizeOf ( TStrIndexRec ) );  { Release memory }
END;

{--TStringList--------------------------------------------------------------}
{  Get -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TStringList.Get ( Key : Sw_Word ) : sw_String;
VAR I : Word16; S : sw_String;
BEGIN
   S := '';                                           { Preset empty string }
   IF ( IndexSize > 0 ) THEN BEGIN                      { We must have strings }
     I := 0;                                          { First entry }
     WHILE ( I < IndexSize ) AND ( S = '' ) DO BEGIN
       IF ( ( Key - Index^ [I].Key ) < Index^ [I].Count )   { Diff less than count }
         THEN ReadStr ( S, Index^ [I].Offset,
           Key - Index^ [I].Key );                        { Read the string }
       Inc ( I );                                        { Next entry }
     END;
   END;
   Get := S;                                          { Return empty string }
END;

{***************************************************************************}
{                       TStringList PRIVATE METHODS                         }
{***************************************************************************}

{--TStringList--------------------------------------------------------------}
{  ReadStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May01 AAO           }
{---------------------------------------------------------------------------}
PROCEDURE TStringList.ReadStr ( VAR S : sw_String; Offset, Skip : Sw_Word );
VAR B : Byte;
BEGIN
   Stream^.Seek ( BasePos + Offset );                    { Seek to position }
   Inc ( Skip );                                         { Adjust skip }
   REPEAT
     Stream^.Read ( B, 1 );                              { Read string size }
     {$IFDEF NON_BP_STRINGS}
     SetLength ( S, B );                                 { Xfer string length }
     {$ELSE}
      S [0] := Chr ( B );                                 { Xfer string size }
     {$ENDIF}
     Stream^.Read ( S [1], B );                           { Read string data }
     Dec ( Skip );                                       { One string read }
   UNTIL ( Skip = 0 );
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                         TStrListMaker OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStrListMaker------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TStrListMaker.Init ( AStrSize, AIndexSize : Sw_Word );
BEGIN
   Inherited Init;                                    { Call ancestor }
   StrSize := AStrSize;                               { Hold size }
   IndexSize := AIndexSize;                           { Hold index size }
   GetMem ( Strings, AStrSize );                         { Allocate memory }
   GetMem ( Index, AIndexSize * SizeOf ( TStrIndexRec ) );  { Allocate memory }
END;

{--TStrListMaker------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TStrListMaker.Done;
BEGIN
   FreeMem ( Index, IndexSize * SizeOf ( TStrIndexRec ) );  { Free index memory }
   FreeMem ( Strings, StrSize );                         { Free data memory }
END;

{--TStrListMaker------------------------------------------------------------}
{  Put -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TStrListMaker.Put ( Key : Sw_Word; S : sw_String );
BEGIN
   IF ( Cur.Count = 16 ) OR ( Key <> Cur.Key + Cur.Count )
     THEN CloseCurrent;                               { Close current }
   IF ( Cur.Count = 0 ) THEN BEGIN
     Cur.Key := Key;                                  { Set key }
     Cur.Offset := StrPos;                            { Set offset }
   END;
   Inc ( Cur.Count );                                    { Inc count }
   Move ( S, Strings^ [StrPos], Length ( S ) + 1 );          { Move string data }
   Inc ( StrPos, Length ( S ) + 1 );                        { Adjust position }
END;

{--TStrListMaker------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TStrListMaker.Store ( VAR S : TStream );
BEGIN
   CloseCurrent;                                      { Close all current }
   S.Write ( StrPos, SizeOf ( Word16 ) );                   { Write position }
   S.Write ( Strings^, StrPos );                         { Write string data }
   S.Write ( IndexPos, SizeOf ( Word16 ) );                 { Write index position }
   S.Write ( Index^, IndexPos * SizeOf ( TStrIndexRec ) );  { Write indexes }
END;

{***************************************************************************}
{                      TStrListMaker PRIVATE METHODS                        }
{***************************************************************************}

{--TStrListMaker------------------------------------------------------------}
{  CloseCurrent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Jun97 LdB      }
{---------------------------------------------------------------------------}
PROCEDURE TStrListMaker.CloseCurrent;
BEGIN
   IF ( Cur.Count <> 0 ) THEN BEGIN
     Index^ [IndexPos] := Cur;                         { Hold index position }
     Inc ( IndexPos );                                   { Next index }
     Cur.Count := 0;                                  { Adjust count }
   END;
END;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        STREAM INTERFACE ROUTINES                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  Abstract -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Jun96 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE Abstract;
BEGIN
   RunError ( 211 );                                     { Abstract error }
END;

{---------------------------------------------------------------------------}
{  RegisterObjects -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 02Sep97 LdB   }
{---------------------------------------------------------------------------}
PROCEDURE RegisterObjects;
BEGIN
   {$IFNDEF PPC_FPC}
   RegisterType ( RCollection );                         { Register object }
   RegisterType ( RStringCollection );                   { Register object }
   RegisterType ( RStrCollection );                      { Register object }
   {$ENDIF}
END;

{---------------------------------------------------------------------------}
{  RegisterType -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 02Sep97 LdB      }
{---------------------------------------------------------------------------}
PROCEDURE RegisterType ( VAR S : TStreamRec );
VAR P : PStreamRec;
{$ifdef PPC_GPC}{$W-}{$endif}
BEGIN
   P := StreamTypes;                                  { Current reg list }
   WHILE ( P <> Nil ) AND ( P^.ObjType <> S.ObjType )
     DO P := P^.Next;                                 { Find end of chain }
   IF ( P = Nil ) AND ( S.ObjType <> 0 ) THEN BEGIN   { Valid end found }
     S.Next := StreamTypes;                           { Chain the list }
     StreamTypes := @S;                               { We are now first }
   END ELSE RegisterError;                            { Register the error }
END;
{$ifdef PPC_GPC}{$W+}{$endif}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    GENERAL FUNCTION INTERFACE ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  LongMul -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 19Feb99 AAO           }
{---------------------------------------------------------------------------}
FUNCTION LongMul ( X, Y : Integer ) : LongInt;
BEGIN
    LongMul := Longint ( X ) * Y;                            { Multiply integers }
END;

{---------------------------------------------------------------------------}
{  LongDiv -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10Feb98 LdB           }
{---------------------------------------------------------------------------}
FUNCTION LongDiv ( X : LongInt; Y : Integer ) : Integer;
BEGIN
   LongDiv := Integer ( X DIV Y );                       { Divide longint }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                    DYNAMIC STRING INTERFACE ROUTINES                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{$ifndef PPC_GPC}
{---------------------------------------------------------------------------}
{  NewStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Jun96 LdB            }
{---------------------------------------------------------------------------}
FUNCTION NewStr ( S : sw_String ) : PString;
VAR P : PString;
BEGIN
   IF ( S = '' ) THEN P := Nil ELSE BEGIN               { Empty returns nil }
     GetMem ( P, Length ( S ) + 1 );                        { Allocate memory }
     IF ( P <> Nil ) THEN P^ := S;                      { Transfer string }
   END;
   NewStr := P;                                       { Return result }
END;
{---------------------------------------------------------------------------}
{  DisposeStr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Jun96 LdB        }
{---------------------------------------------------------------------------}
PROCEDURE DisposeStr ( P : PString );
BEGIN
   IF ( P <> Nil ) THEN FreeMem ( P, Length ( P^ ) + 1 );     { Release memory }
END;
{$endif} {PPC_GPC}

PROCEDURE SetStr ( VAR p : pString; CONST s : STRING );
BEGIN
  IF p <> NIL THEN
    FreeMem ( P, Length ( P^ ) + 1 );
  GetMem ( p, LENGTH ( s ) + 1 );
  pSTRING ( p ) ^ := s
END;

END.

