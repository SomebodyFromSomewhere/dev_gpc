{****************************************************************************
   Include file to sort out compilers/platforms/targets

   Copyright (c) 1997 Balazs Scheidler (bazsi@tas.vein.hu)

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.


   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


 ****************************************************************************

   This include file defines some conditional defines to allow us to select
   the compiler/platform/target in a consequent way.

    OS_XXXX         The operating system used (XXXX may be one of:
                       DOS, OS2, Linux, Windows)
    PPC_XXXX        The compiler used: BP, FPK, Virtual, Speed
    BIT_XX          The number of bits of the target platform: 16 or 32
    PROC_XXXX       The mode of the target processor (Real or Protected)
                    This shouldn't be used, except for i386 specific parts.
    ASM_XXXX        This is the assembler type: BP, ISO-ANSI, FPK

 ****************************************************************************

   Changelog:

     Date       Version        Who        Comments
     02 Jul 97  0.1            Bazsi      Initial implementation
     28 Aug 97  0.2            LdeB       Fixed OS2 platform sort out
     29 Aug 97  0.3            LdeB       Added assembler type change
     29 Aug 97  0.4            LdeB       OS_DOS removed from Windows
     23 Oct 97  0.5            LdeB       Delphi & Speed compilers added
     05 May 98  0.6            LdeB       Virtual pascal 2.0 added
     19 May 98  0.7            LdeB       Delphi2/3 definitions altered
      6 Aug 98  0.8            CEC/LdeB   FPC only support - fixed for Win32
     10 Aug 98  0.9            LdeB       BP_VMTLink def/Undef for object reg.
     27 Aug 98  1.0            LdeB       Fixed Atari etc not $UNDEF OS_DOS.
     25 Oct 98  1.1            pfv        Delphi4
     17 Feb 99  1.2            AAO        GPC, Delphi2
     14 Feb 2002 1.3	       AAO	  GPC, Delphi6
     25 Oct 2002 1.4           AAO        GPC, Delphi7, TMT

 ****************************************************************************

    This is how the IFDEF and UNDEF statements below should translate.


 PLATFORM  SYSTEM    COMPILER  COMP ID      CPU MODE        BITS    ASSEMBLER
 --------  ------    --------  -------      --------        ----    ---------

 DOS      OS_DOS      BP/TP7   PPC_BP       PROC_Real       BIT_16  ASM_BP
                      FPC      PPC_FPC      PROC_Protected  BIT_32  ASM_FPC
                      GPC      GPC_GPC      PROC_Protected  BIT_32

 DPMI     OS_DOS      BP/TP7   PPC_BP       PROC_Protected  BIT_16  ASM_BP
                      GPC      GPC_GPC      PROC_Protected

 LINUX    OS_LINUX    FPC      PPC_FPC      PROC_Protected  BIT_32  ASM_FPC
 LINUX    OS_LINUX    GPC      PPC_GPC      PROC_Protected

 WINDOWS  OS_WINDOWS  BP/TP7   PPC_BP       PROC_Protected  BIT_16  ASM_BP
                      DELPHI   PPC_DELPHI   PROC_Protected  BIT_16  ASM_BP
                      DELPHI2  PPC_DELPHI&2 PROC_Protected  BIT_16  ASM_BP

 WIN95/NT OS_WINDOWS  DELPHI2  PPC_DELPHI&2 PROC_Protected  BIT_32  ASM_BP
                      DELPHI3  PPC_DELPHI&3 PROC_Protected  BIT_32  ASM_BP
                      DELPHI4  PPC_DELPHI&3 PROC_Protected  BIT_32  ASM_BP
                      VIRTUAL  PPC_VIRTUAL  PROC_Protected  BIT_32  ASM_BP
                      GPC      PPC_GPC      PROC_Protected
                      TMT      PPC_TMT      PROC_Protected  BIT_32

 OS2      OS_OS2      BPOS2    PPC_BPOS2    PROC_Protected  BIT_16  ASM_BP
                      VIRTUAL  PPC_VIRTUAL  PROC_Protected  BIT_32  ASM_BP
                      SPEED    PPC_SPEED    PROC_Protected  BIT_32  ASM_BP
                      FPC      PPC_FPC      PROC_Protected  BIT_32  ASM_FPC
                      GPC      PPC_GPC      PROC_Protected
 ****************************************************************************}
{****************************************************************************

FOR ALL COMPILERS BP_VMTLink will be defined but FPC and Delphi3 undefine it

 ****************************************************************************}
{****************************************************************************

FOR FPC THESE ARE THE TRANSLATIONS

  PLATFORM  SYSTEM    COMPILER  HANDLE SIZE      ASM          CPU
 --------  ------    --------  -----------      ----         ---

 DOS      OS_DOS       FPC     16-bit           AT&T         CPU86

 WIN32    OS_WINDOWS   FPC     32-bit           AT&T         ----

 LINUX    OS_LINUX     FPC     32-bit           AT&T         ----

 OS2      OS_OS2       FPC     ?????            AT&T         CPU86

 ATARI    OS_ATARI     FPC     16-bit           Internal     CPU68

 MACOS    OS_MAC       FPC     ?????            Internal     CPU68

 AMIGA    OS_AMIGA     FPC     32-bit           Internal     CPU68

 ****************************************************************************}

{---------------------------------------------------------------------------}
{  Initial assume BORLAND 16 BIT DOS COMPILER - Updated 27Aug98 LdB         }
{---------------------------------------------------------------------------}
{$DEFINE OS_DOS}
{$DEFINE PROC_Real}
{$DEFINE BIT_16}
{$DEFINE PPC_BP}
{$DEFINE ASM_BP}
{$DEFINE BP_VMTLink}

{---------------------------------------------------------------------------}
{  BORLAND 16 BIT DPMI changes protected mode - Updated 27Aug98 LdB         }
{---------------------------------------------------------------------------}
{$IFDEF DPMI}
  {$UNDEF PROC_Real}
  {$DEFINE PROC_Protected}
{$ENDIF}

{---------------------------------------------------------------------------}
{  FPC 32 BIT COMPILER changes ASM, 32 bits etc - Updated 27Aug98 LdB       }
{---------------------------------------------------------------------------}
{$IFDEF FPC}
  {$UNDEF PROC_Real}
  {$DEFINE PROC_Protected}
  {$UNDEF BIT_16}
  {$DEFINE BIT_32}
  {$UNDEF PPC_BP}
  {$DEFINE PPC_FPC}
  {$UNDEF ASM_BP}
  {$DEFINE ASM_FPC}
  {$UNDEF BP_VMTLink}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE NON_BP_STRINGS}
{$ENDIF}

{---------------------------------------------------------------------------}
{  FPC LINUX COMPILER changes operating system - Updated 27Aug98 LdB        }
{  Note: Other linux compilers would need to change other details           }
{---------------------------------------------------------------------------}
{$IFDEF LINUX}
  {$UNDEF OS_DOS}
  {$DEFINE OS_LINUX}
{$ENDIF}

{---------------------------------------------------------------------------}
{  32 BIT WINDOWS COMPILERS changes bit size - Updated 27Aug98 LdB          }
{---------------------------------------------------------------------------}
{$IFDEF WIN32}
  {$IFNDEF WINDOWS}
    {$DEFINE WINDOWS}
  {$ENDIF}
  {$UNDEF BIT_16}
  {$DEFINE BIT_32}
{$ENDIF}

{---------------------------------------------------------------------------}
{  WINDOWS COMPILERS change op system and proc mode - Updated 27Aug98 LdB   }
{---------------------------------------------------------------------------}
{$IFDEF WINDOWS}
  {$UNDEF OS_DOS}
  {$DEFINE OS_WINDOWS}
  {$UNDEF PROC_Real}
  {$DEFINE PROC_Protected}
{$ENDIF}

{---------------------------------------------------------------------------}
{  DELPHI1 COMPILER changes compiler type - Updated 27Aug98 LdB             }
{---------------------------------------------------------------------------}
{$IFDEF VER80}
  {$UNDEF PPC_BP}
  {$DEFINE PPC_DELPHI}
{$ENDIF}

{---------------------------------------------------------------------------}
{  DELPHI2 COMPILER changes compiler type - Updated 16Feb99 AAO             }
{---------------------------------------------------------------------------}
{$IFDEF VER90}
  {$UNDEF PPC_BP}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI2}
  {$DEFINE HAS_EXCEPTIONS}
  {$UNDEF BP_VMTLink}
  {$DEFINE PPC_DELPHI32}
{$ENDIF}

{---------------------------------------------------------------------------}
{  DELPHI3 COMPILER changes compiler type - Updated 16Feb99 AAO             }
{---------------------------------------------------------------------------}
{$IFDEF VER100}
  {$UNDEF PPC_BP}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI3}
  {$UNDEF BP_VMTLink}
  {$DEFINE PPC_DELPHI32}
{$ENDIF}

{---------------------------------------------------------------------------}
{  DELPHI4 COMPILER changes compiler type - Updated 16Feb99 AAO             }
{---------------------------------------------------------------------------}
{$IFDEF VER120}
  {$UNDEF PPC_BP}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI3}
  {$DEFINE PPC_DELPHI4}
  {$UNDEF BP_VMTLink}
  {$DEFINE PPC_DELPHI32}
  {$DEFINE Word_DWord}
{$ENDIF}

{---------------------------------------------------------------------------}
{  DELPHI5 COMPILER changes compiler type - Updated 14May01 AAO             }
{---------------------------------------------------------------------------}
{$IFDEF VER130}
  {$UNDEF PPC_BP}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI3}
  {$DEFINE PPC_DELPHI4}
  {$DEFINE PPC_DELPHI5}
  {$UNDEF BP_VMTLink}
  {$DEFINE PPC_DELPHI32}
  {$DEFINE Word_DWord}
{$ENDIF}

{---------------------------------------------------------------------------}
{  KYLIX & DELPHI6 COMPILER changes compiler type - Updated 16Jul01 AAO     }
{---------------------------------------------------------------------------}
{$IFDEF VER140}
  {$UNDEF PPC_BP}
  {$UNDEF BP_VMTLink}
  {$UNDEF PROC_Real}
  {$UNDEF ASM_BP}
  {$UNDEF OS_DOS}
  {$UNDEF BIT_16}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI3}
  {$DEFINE PPC_DELPHI4}
  {$DEFINE PPC_DELPHI5}
  {$DEFINE PPC_DELPHI6}
  {$ifdef linux}
    {$DEFINE PPC_KYLIX}
    {$DEFINE OS_LINUX}
    {$UNDEF OS_WINDOWS}
  {$endif}
  {$DEFINE PPC_DELPHI32}
  {$DEFINE Word_DWord}
  {$DEFINE PROC_Protected}
  {$DEFINE BIT_32}

{$ENDIF}

{---------------------------------------------------------------------------}
{  KYLIX & DELPHI7 COMPILER changes compiler type - Updated 21Sep02 AAO     }
{---------------------------------------------------------------------------}
{$IFDEF VER150}
  {$UNDEF PPC_BP}
  {$UNDEF BP_VMTLink}
  {$UNDEF PROC_Real}
  {$UNDEF ASM_BP}
  {$UNDEF OS_DOS}
  {$UNDEF BIT_16}
  {$DEFINE HAS_EXCEPTIONS}
  {$DEFINE PPC_DELPHI}
  {$DEFINE PPC_DELPHI3}
  {$DEFINE PPC_DELPHI4}
  {$DEFINE PPC_DELPHI5}
  {$DEFINE PPC_DELPHI6}
  {$DEFINE PPC_DELPHI7}
  {$ifdef linux}
    {$DEFINE PPC_KYLIX}
    {$DEFINE OS_LINUX}
    {$UNDEF OS_WINDOWS}
  {$endif}
  {$DEFINE PPC_DELPHI32}
  {$DEFINE Word_DWord}
  {$DEFINE PROC_Protected}
  {$DEFINE BIT_32}

{$ENDIF}

{---------------------------------------------------------------------------}
{  OS2 COMPILERS change compiler type and mode - Updated 27Aug98 LdB        }
{  Note: Assumes BPOS2 16BIT OS2 patch except for FPC which undefines this  }
{---------------------------------------------------------------------------}
{$IFDEF OS2}
  {$UNDEF OS_DOS}
  {$DEFINE OS_OS2}
  {$UNDEF PROC_Real}
  {$DEFINE PROC_Protected}
  {$UNDEF PPC_BP}
  {$DEFINE PPC_BPOS2}
  {$IFDEF FPC}
    {$UNDEF PPC_BPOS2}
  {$ENDIF}
{$ENDIF}

{---------------------------------------------------------------------------}
{  VIRTUAL PASCAL changes compiler type/32 bit - Updated 27Feb99 AAO        }
{  Note: VP2 can compile win 32 code so changes op system as needed         }
{---------------------------------------------------------------------------}
{$IFDEF VirtualPascal}
  {$UNDEF BIT_16}
  {$DEFINE BIT_32}
  {$DEFINE PPC_DELPHI}   { can use Delphi syntax (e.g., for exceptions)  }
  {$DEFINE HAS_EXCEPTIONS}
  {$IFDEF OS2}
    {$DEFINE VP_OS2}
    {$UNDEF OS_WINDOWS}
  {$endif}

  {$IFDEF PPC_BPOS2}
    {$UNDEF PPC_BPOS2}
  {$ENDIF}
  {$DEFINE PPC_VIRTUAL}
  {$IFDEF WIN32}
    {$UNDEF PPC_BP}
    {$UNDEF OS_OS2}
    {$DEFINE OS_WINDOWS}
  {$ENDIF}
{$ENDIF}

{---------------------------------------------------------------------------}
{  SPEED COMPILER changes compiler type/32 bit  - Updated 27Aug98 LdB       }
{---------------------------------------------------------------------------}
{$IFDEF Speed}
  {$UNDEF BIT_16}
  {$DEFINE BIT_32}
  {$UNDEF PPC_BPOS2}
  {$DEFINE PPC_SPEED}
{$ENDIF}

{---------------------------------------------------------------------------}
{  FPC AMIGA COMPILER changes op system and CPU type - Updated 27Aug98 LdB  }
{---------------------------------------------------------------------------}
{$IFDEF AMIGA}
  {$UNDEF OS_DOS}
  {$DEFINE OS_AMIGA}
  {$IFDEF CPU86}
    {$UNDEF CPU86}
  {$ENDIF}
  {$IFNDEF CPU68}
    {$DEFINE CPU68}
  {$ENDIF}
{$ENDIF}

{---------------------------------------------------------------------------}
{  FPC ATARI COMPILER changes op system and CPU type - Updated 27Aug98 LdB  }
{---------------------------------------------------------------------------}
{$IFDEF ATARI}
  {$UNDEF OS_DOS}
  {$DEFINE OS_ATARI}
  {$IFDEF CPU86}
    {$UNDEF CPU86}
  {$ENDIF}
  {$IFNDEF CPU68}
    {$DEFINE CPU68}
  {$ENDIF}
{$ENDIF}

{---------------------------------------------------------------------------}
{  FPC MAC COMPILER changes op system and CPU type - Updated 27Aug98 LdB    }
{---------------------------------------------------------------------------}
{$IFDEF MACOS}
  {$UNDEF OS_DOS}
  {$DEFINE OS_MAC}
  {$IFDEF CPU86}
    {$UNDEF CPU86}
  {$ENDIF}
  {$IFNDEF CPU68}
    {$DEFINE CPU68}
  {$ENDIF}
{$ENDIF}



{---------------------------------------------------------------------------}
{  GNU PASCAL (GPC) 32/64-BIT COMPILER changes - Updated 12Feb99 AAO        }
{---------------------------------------------------------------------------}
{$IFDEF __GPC__}
  {$UNDEF PROC_Real}
  {$UNDEF BIT_16}
  {$UNDEF BIT_32}
  {$UNDEF PPC_BP}
  {$UNDEF ASM_BP}
  {$UNDEF BP_VMTLink}
  {$UNDEF OS_DOS}
  {$UNDEF OS_WINDOWS}

  {$DEFINE PROC_Protected}
  {$DEFINE OS_ANY}
  {$DEFINE PPC_GPC}
{$ENDIF}


{---------------------------------------------------------------------------}
{  TMT PASCAL 32-BIT COMPILER changes - Updated 25Oct02 AAO                 }
{---------------------------------------------------------------------------}
{$IFDEF __TMT__}
  {$UNDEF PPC_BP}
  {$UNDEF BP_VMTLink}
  {$UNDEF PROC_Real}
  {$UNDEF ASM_BP}
  {$UNDEF OS_DOS}
  {$UNDEF BIT_16}
  {$DEFINE PPC_TMT}
  {$DEFINE Word_DWord}
  {$DEFINE PROC_Protected}
  {$DEFINE BIT_32}
     {$IFDEF __WIN32__}
       {$DEFINE OS_WINDOWS}
       {$DEFINE PPC_TMT_WIN}
     {$ELSE}
       {$DEFINE PPC_TMT_DOS}
       {$DEFINE OS_DOS}
     {$ENDIF}  
{$ENDIF}

