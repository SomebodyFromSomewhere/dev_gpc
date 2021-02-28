REM ***** sample batch file to set up GPC GNU Pascal for Mingw *****
@echo off
set prompt=GPC-mingw: $p$g
set PATH=c:\dev_gpc\bin;%PATH%
set C_INCLUDE_PATH=c:\dev_gpc\include
set GCC_BASE=3.4.5
set GPC_EXEC_PREFIX=c:\dev_gpc\libexec\gcc\mingw32
set LIBRARY_PATH=c:\dev_gpc\lib;c:\dev_gpc\lib\gcc\mingw32\%GCC_BASE%
set GPC_UNIT_PATH=c:\dev_gpc\lib\gcc\mingw32\%GCC_BASE%\units;c:\dev_gpc\units;c:\dev_gpc\units\winapi;c:\dev_gpc\units\objects;c:\dev_gpc\units\sysutils;c:\dev_gpc\units\objmingw
