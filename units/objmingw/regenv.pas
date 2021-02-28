{
***************************************************************************
*                 regenv.pas
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT exports some routines for using environment variables
*  via the Windows registry
*
*  It is part of the ObjectMingw object/class library
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal,
*  and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*
*  Last modified: 08 January  2003
*  Version: 1.00
*  Licence: Shareware
*
***************************************************************************
}
UNIT regenv;
{$i cwindows.inc}

INTERFACE

USES
Messages,
Windows,
cclasses,
Registry;

TYPE
RegEnvironChangeType = ( Replace, AppendTo, PrependTo );
RegEnvironUserType = ( AllUsers, CurrentUser );

// get an environment variable IN the registry
FUNCTION GetRegistryEnv ( CONST EnvName : String;
                               UserType : RegEnvironUserType ) : TString;

// set an environment variable IN the registry
FUNCTION SetRegistryEnv ( CONST EnvName, Value : String;
                               UserType : RegEnvironUserType;
                               Action : RegEnvironChangeType ) : Boolean;

CONST
// key FOR all UserType ( must have administrative rights TO use it )
RegEnvironKey_All = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

// key FOR current user
RegEnvironKey_User = 'Environment';

IMPLEMENTATION

FUNCTION GetRegistryEnv ( CONST EnvName : String; UserType : RegEnvironUserType ) : TString;
VAR
R : TRegistry;
s0 : TString;
h : HKey;
BEGIN
   Result := '';

   h := HKey_Local_Machine;
   s0 := RegEnvironKey_All;

   CASE UserType OF
      AllUsers : ;
      CurrentUser :
      BEGIN
          h := HKEY_CURRENT_USER;
          s0 := RegEnvironKey_User;
      END;
   END;

   R.Create;
   WITH R
   DO BEGIN
      RootKey := h;
      SetRootKey ( h );
      IF OpenKey ( s0, False )
      THEN BEGIN
         IF ValueExists ( EnvName )
         THEN BEGIN
            Result := ReadString ( EnvName );
         END;
      END;
      Destroy;
   END;
END;

FUNCTION SetRegistryEnv ( CONST EnvName, Value : String; UserType : RegEnvironUserType;
                        Action : RegEnvironChangeType ) : Boolean;

CONST p : PChar = 'Environment';

VAR
R : TRegistry;
h : hKey;
s, s0 : TString;
d : dWord;
BEGIN
   Result := False;
   s := GetRegistryEnv ( EnvName, UserType );

   h := HKey_Local_Machine;
   s0 := RegEnvironKey_All;

   CASE Action OF
      Replace : s := Value;
      AppendTo : IF s <> '' THEN s := s + ';' + Value ELSE s := Value;
      PrependTo : IF s <> '' THEN s := Value + ';' + s ELSE s := Value;
   END;

   CASE UserType OF
      AllUsers : ;
      CurrentUser :
      BEGIN
          h := HKEY_CURRENT_USER;
          s0 := RegEnvironKey_User;
      END;
   END;

   R.Create;;
   WITH R
   DO BEGIN
      LazyWrite := False;
      RootKey := h;
      SetRootKey ( h );
      IF OpenKey ( s0, False )
      THEN BEGIN
         Result := WriteExpandString ( EnvName, s );
         CloseKey;
         IF Result
           THEN BEGIN
            // SetEnvironmentVariable ( {$ifndef __GPC__}pChar{$endif} ( EnvName ), {$ifndef __GPC__}pChar{$endif} ( Value ) );
             SendMessageTimeout ( HWND_BROADCAST,
             WM_SETTINGCHANGE, 0, Longint ( p ), SMTO_ABORTIFHUNG, 5000, d );
           END;
      END;
      Destroy;
   END;
END;

END.

