Readme for Chief's Installer Lite
---------------------------------
This is just a small primer for using the installation package. Full
documentation for the installer can be found in thes files:
	a.  utils\chief.hlp
	b.  utils\chiefpro.hlp

CONFIGURATION
-------------
This version of Chief's Installer Lite (freeware) is bundled
with Dev+GNU Pascal. If you did not install this through the
Dev+GNU Pascal Windows installation program, AND your Dev+GNU
Pascal is not installed in "c:\dev_gpc", then you MUST
take these steps BEFORE using Chief's Installer Lite for the
first time:

1. Open utils\chiefpro.ini in notepad or other text editor

2. Supply the correct paths for the file names in these entries:
[chieflite32]
$#1=c:\dev_gpc\installer\bin\setup.exe
$#2=c:\dev_gpc\installer\bin\setupinf.inf
$#3=c:\dev_gpc\installer\bin\uninstal.exe
$#4=c:\dev_gpc\installer\bin\install.exe
$#5=c:\dev_gpc\installer\utils\winstl32.dll
$#6=c:\dev_gpc\installer\bin\winstalc.dll

3. Save the edited chiefpro.ini that has the correct paths for the
   file names


AUTO-RECOGNISED FILES
---------------------
The "samples" directory contains 4 files that are automatically
recognised and used by the installer (at install time) if they are
found. You can edit them, and then add them to your project, on your
Disk #1 setting. These files are:

winstall.cpr -  a custom "copyright" message for your program
winstall.wel -  a custom "welcome" message for your program
winstall.txt -  a custom "Readme" file for your program
winstall.msg -  custom splash messages during program installation

After adding them to your project, you must do the following (in the
Installer IDE "Project Files" tab):
	a. set the "Target Directory" to "$CHIEF"
	b. set the "Opt #" to "-1"
in each case, do not add the quotation marks.


LANGUAGE FILES
--------------
In the "language" directory there are two files containing string
tables for the installer and the uninstaller. You can use these to
provide different language support for your program installation.
For this purpose, they must be renamed to have a ".lng" extension
and added to your project. After adding them to your project, you
must do the following (in the Installer IDE "Project Files" tab):
	a. set the "Target Directory" to "$CHIEF"
	b. set the "Opt #" to "-1"
in each case, do not add the quotation marks.


------------------------
April 2004,
Prof. Abimbola A Olowofoyeku (The African Chief)

