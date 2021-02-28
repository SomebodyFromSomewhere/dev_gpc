(***********************************************************************
*                    build_units.pas
*             Part of the Dev+GNU Pascal package
*
*  This program does nothing - except provide an easy way to build all the
*  units that come with this package.
* 
*  !!!! DO NOT ATTEMPT TO RUN THIS PROGRAM AFTER COMPILING IT !!!!
*  YOU SHOULD DELETE THE EXECUTABLE AS SOON AS THE UNITS HAVE BEEN BUILT
*
*  If you build this program with the Dev+GNU Pascal IDE to build this program, 
*  you may find a number of "errors" reported. You can safely ignore them if these
*  "errors" are only compiler warnings. In this instance, the IDE reports them
*  as errors simply because of the "#no_link" directive below.
*
*  If you do not use the Dev+GNU Pascal IDE to build this program, then you
*  must supply "-c" at the command line (so that the units being built will
*  not be linked) - otherwise you will get numerous linker errors. This is
*  what the {#no_link} directive below) does - but that directive is only
*  understood by the Dev-Pascal IDE (from v1.93.4 onwards).
*
*   (c)2004-2007, Professor A Olowofoyeku (The African Chief)
*
****************************************************************************
*)
Program build_units;
{#no_link}  // this means "do not link" - we don't really want an EXE to be created

{$R-}
{$X+}

USES
crt,
dos,
dosunix,
fileutils,
gmp,
gpc,
gpcutil,
heapmon,
intl,
md5,
overlay,
//pipe,
ports,
printer,
regex,
strings,
stringutils,
system,
tfdd,
trap,
turbo3,
wincrt,
windos,

messages,
windows,
objects,
sysutils,

activex,
commctrl,
commdlg,
ole2,
richedit,
shellapi,
shlobj,
winsock,
genutils,
inifiles,
regenv,
registry,
mmsystem,
timing,

{$ifdef __GPC__}
objmingw,
{$endif}
cbitmaps,
cclasses,

cwindows,
cdialogs,

graph,
grx;

begin 
{ to try and stop things going awry with the printer if people try to run this program }
  Assign (Output, 'build.foo');
  Rewrite (Output);
  Writeln (Output, ParamStr (0));
end.
