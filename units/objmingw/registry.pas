{
***************************************************************************
*                 Registry.pas
*  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements a (somewhat) Delphi(tm)-compatible Registry unit
*  for GNU Pascal for Win32.
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     To provide Pascal objects for interacting with the Windows registry
*
*    Objects:
*           TRegistry
*           TRegIniFile
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
*  Last modified: 26 March 2005
*  Version: 1.00
*  Licence: Shareware
*
*  NOTES: this unit is work-in-progress; some things need more work !
***************************************************************************
}
UNIT registry;
{$i cwindows.inc}

INTERFACE

USES
Sysutils,
Windows,
cClasses;

Const
SectionMarker = '::';  // marker FOR END OF section names

TYPE
TReg_CharArray = ARRAY [0.. ( 1024 * 32 ) ] OF Char;
TCharPtr = ^TReg_CharArray;

pRegKeyInfo = ^TRegKeyInfo;
TRegKeyInfo = RECORD
    NumSubKeys,
    MaxSubKeyLen,
    NumValues,
    MaxValueLen,
    MaxDataLen : DWord;
    FileTime : TFileTime;
END;

TRegDataType =
( rdUnknown, rdString, rdExpandString, rdInteger, rdBinary,
 rdBigEndianInteger, rdLink, rdMultiString, rdResourceList );

TRegDataInfo = RECORD
  RegData : TRegDataType;
  RegDataSize : WinInteger;
END;

pRegistry = ^TRegistry;
TRegistry = OBJECT ( TClass )
   Access : Cardinal;
   CurrentKey,
   RootKey : HKey;
   CurrentPath : TControlStr;
   NewKeyCreated,
   LazyWrite : Boolean;
   pTemp : pchar;
   FileName : TControlStr;

   CONSTRUCTOR Create;
   CONSTRUCTOR Init ( lAccess : Cardinal );
   DESTRUCTOR  Done; VIRTUAL;
   FUNCTION    OpenKey ( CONST Key : String; CanCreate : Boolean ) : Boolean;
   FUNCTION    RegistryConnect ( CONST UNCName : String ) : Boolean; VIRTUAL;
   FUNCTION    UnLoadKey ( CONST Key : String ) : Boolean; VIRTUAL;
   FUNCTION    RestoreKey ( CONST Key, aFileName : String ) : Boolean; VIRTUAL;

   FUNCTION    CreateKey ( Key : String ) : Boolean;VIRTUAL;
   PROCEDURE   CloseKey; VIRTUAL;
   FUNCTION    DeleteKey ( Key : String ) : Boolean;
   FUNCTION    SaveKey ( CONST Key, aFileName : String ) : Boolean;VIRTUAL;
   FUNCTION    DeleteValue ( CONST aName : String ) : Boolean;VIRTUAL;
   FUNCTION    RenameValue ( CONST OldName, NewName : String ) : Boolean;VIRTUAL;

   FUNCTION    ValueExists ( CONST aName : String ) : Boolean; VIRTUAL;
   FUNCTION    GetDataType ( CONST ValueName : String ) : TRegDataType;VIRTUAL;
   FUNCTION    GetDataSize ( CONST ValueName : String ) : WinInteger;VIRTUAL;
   FUNCTION    GetDataInfo ( CONST ValueName : String; VAR Value : TRegDataInfo ) : Boolean;VIRTUAL;
   FUNCTION    GetKeyInfo ( VAR Value : TRegKeyInfo ) : Boolean; VIRTUAL;
   FUNCTION    GetKeyNames ( VAR lStrings : TStrings ) : Boolean; VIRTUAL;
   FUNCTION    GetValueNames ( VAR lStrings : TStrings ) : Boolean; VIRTUAL;
   FUNCTION    KeyExists ( CONST Key : String ) : Boolean;VIRTUAL;

   FUNCTION    ReadInteger ( CONST aName : String ) : WinInteger;
   FUNCTION    ReadString ( CONST aName : String ) : TString;
   FUNCTION    ReadFloat ( CONST aName : String ) : Double;
   FUNCTION    ReadBinaryData ( CONST aName : String; VAR Buffer; BufSize : DWord ) : WinInteger;
   FUNCTION    ReadBool ( CONST aName : String ) : Boolean;

   FUNCTION    WriteString ( CONST aName, aValue : String ) : Boolean;
   FUNCTION    WriteBool ( CONST aName : String; Value : Boolean ) : Boolean;
   FUNCTION    WriteInteger ( CONST aName : String; Value : WinInteger ) : Boolean;

   FUNCTION    WriteExpandString ( CONST aName, Value : String ) : Boolean ;VIRTUAL;
   FUNCTION    WriteFloat ( CONST aName : String; Value : Double ) : Boolean; VIRTUAL;
   FUNCTION    WriteDateTime ( CONST aName : String; Value : TDateTime ) : Boolean; VIRTUAL;
   FUNCTION    WriteBinaryData ( CONST aName : String; VAR Buffer; BufSize : WinInteger ) : Boolean; VIRTUAL;

   {@@ normally in TRegIniFile @@}
   FUNCTION    EraseSection ( CONST Section : String ) : Boolean;VIRTUAL;
   FUNCTION    ReadSection ( CONST Section : String; VAR lStrings : TStrings ) : Boolean;VIRTUAL;
   FUNCTION    ReadSections ( VAR lStrings : TStrings ) : Boolean;VIRTUAL;
   FUNCTION    ReadSectionValuesEx ( CONST Section : string; VAR lStrings : TStrings;
                                   ClearEntries, AddSectionNames : Boolean ) : Boolean; VIRTUAL;
   FUNCTION    ReadSectionValues ( CONST Section : string; VAR lStrings : TStrings ) : Boolean;VIRTUAL;

   {@@ Extra @@}
   FUNCTION    ReadStringEx ( CONST Section, Ident, Default : String ) : TString;VIRTUAL;
   FUNCTION    DeleteKeyEx ( CONST Section, Ident : string ) : Boolean;VIRTUAL;
   FUNCTION    ReadBoolEx ( CONST Section, Ident : String; Default : Boolean ) : Boolean;VIRTUAL;
   FUNCTION    ReadIntegerEx ( CONST Section, Ident : String; Default : Longint ) : Longint;VIRTUAL;
   FUNCTION    WriteBoolEx ( CONST Section, Ident : String; Value : Boolean ) : Boolean;VIRTUAL;
   FUNCTION    WriteIntegerEx ( CONST Section, Ident : String; Value : Longint ) : Boolean;VIRTUAL;
   FUNCTION    WriteStringEx ( CONST  Section, Ident, Value : String ) : Boolean;VIRTUAL;

   {@@ helpers @@}
   FUNCTION    OpenRegistryKey ( Key : String ) : Hkey; VIRTUAL;
   PROCEDURE   SetRootKey ( Key : HKey ); VIRTUAL;
   PROCEDURE   SetFileName ( CONST aFileName : String );VIRTUAL;
   FUNCTION    GetRootKey : HKey; VIRTUAL;
   FUNCTION    GetValue ( CONST aName : String; VAR Data; VAR DataSize : DWord ) : WinInteger; VIRTUAL;
   FUNCTION    SetValue ( CONST aName : String; VAR Data; DataType, DataSize : WinInteger ) : Boolean ;VIRTUAL;

END;

// TYPE
pRegIniFile = ^TRegIniFile;
TRegIniFile = OBJECT ( TRegistry )
   CONSTRUCTOR Create ( CONST aFileName : string );
   CONSTRUCTOR Init ( CONST aFileName : string; AAccess : Cardinal );
   FUNCTION    WriteString ( CONST  Section, Ident, Value : String ) : Boolean; VIRTUAL;
   FUNCTION    DeleteKey ( CONST Section, Ident : string ) : Boolean;VIRTUAL;
   FUNCTION    ReadBool ( CONST Section, Ident : String; Default : Boolean ) : Boolean;VIRTUAL;
   FUNCTION    ReadInteger ( CONST Section, Ident : String; Default : Longint ) : Longint;VIRTUAL;
   FUNCTION    ReadString ( CONST Section, Ident, Default : String ) : TString;VIRTUAL;
   FUNCTION    WriteBool ( CONST Section, Ident : String; Value : Boolean ) : Boolean;VIRTUAL;
   {$W-}
   FUNCTION    WriteInteger ( CONST Section, Ident : String; Value : Longint ) : Boolean; VIRTUAL;
END;

IMPLEMENTATION

CONST
MaxSizeChar = 2047;    // maximum size OF character arrays FOR reading from registry


FUNCTION AbsoluteKey ( CONST Key : String ) : boolean;
BEGIN
   Result := ( Key <> '' ) AND ( Key [1] = '\' );
END;

CONSTRUCTOR TRegistry.Create;
BEGIN
   Init ( KEY_ALL_ACCESS );
END;

CONSTRUCTOR TRegistry.Init ( lAccess : Cardinal );
BEGIN
   INHERITED Init ( NIL );

   Ptemp := AllocMem ( 1024 );
   IF lAccess = 0
     THEN Access := KEY_ALL_ACCESS
       ELSE Access := lAccess;

   RootKey := HKEY_CURRENT_USER;

   LazyWrite := True;

   SetFileName ( '' );
END;

DESTRUCTOR TRegistry.Done;
BEGIN
   Dispose ( PTemp );
   INHERITED Done;
END;

PROCEDURE TRegistry.SetRootKey ( Key : HKey );
BEGIN
   IF ( Key <> RootKey ) AND ( Key <> 0 )
   THEN BEGIN
      CloseKey;
      RootKey := Key;
      CurrentKey := RootKey;
      IF FileName <> '' THEN OpenKey ( FileName, False );
   END;
END;

PROCEDURE TRegistry.SetFileName ( CONST aFileName : String );
BEGIN
   IF ( aFileName <> '' ) AND ( AnsiCompareText ( FileName, aFileName ) <> 0 )
   THEN BEGIN
      CloseKey;
      FileName := aFileName;
      OpenKey ( FileName, False );
   END ELSE FileName := aFileName;
END;

FUNCTION TRegistry.GetRootKey : HKey;
BEGIN
   Result := RootKey;
END;

FUNCTION TRegistry.OpenRegistryKey ( Key : String ) : Hkey;
VAR
k : HKey;
BEGIN
    Result := 0;
    IF AbsoluteKey ( Key ) THEN Delete ( Key, 1, 1 );
    strpcopy ( pTemp, Key );
    IF RegOpenKeyEx ( RootKey, pTemp, 0, Access, k ) = Error_Success THEN Result := k
    ELSE BEGIN
       IF RegOpenKey ( RootKey, pTemp, k ) = Error_Success THEN Result := k;
    END;
END;

FUNCTION TRegistry.OpenKey ( CONST Key : String; CanCreate : Boolean ) : Boolean;
VAR
k : HKey;
BEGIN
    Result := False;
    NewKeyCreated := False;
    k := OpenRegistryKey ( Key );
    IF k = 0
    THEN BEGIN
       IF NOT CanCreate THEN Exit;
       IF CreateKey ( Key ) THEN k := CurrentKey;
    END;

    Result := k <> 0;

    IF Result
    THEN BEGIN
       CurrentKey := k;
       CurrentPath := Key;
    END;
END;

FUNCTION TRegistry.RegistryConnect ( CONST UNCName : String ) : Boolean;
VAR
k : hKey;
BEGIN
  Strpcopy ( pTemp, UNCName );
  Result := RegConnectRegistry ( pTemp, RootKey, k ) = Error_Success;
  IF Result THEN RootKey := k;
END;

FUNCTION TRegistry.UnLoadKey ( CONST Key : String ) : Boolean;
BEGIN
  Strpcopy ( pTemp, Key );
  Result := RegUnloadKey ( RootKey, pTemp ) = Error_Success;
END;

FUNCTION TRegistry.RestoreKey ( CONST Key, aFileName : String ) : Boolean;
VAR
h : HKey;
BEGIN
  h := OpenRegistryKey ( Key );
  IF h <> 0 THEN BEGIN
     Strpcopy ( pTemp, aFileName );
     Result := RegRestoreKey ( h, pTemp, 0 ) = Error_Success;
  END ELSE Result := False;
END;

FUNCTION TRegistry.RenameValue ( CONST OldName, NewName : String ) : Boolean;
VAR
p : TCharPtr;
i : WinInteger;
j : DWord;
BEGIN
   Result := False;
   IF ( ValueExists ( NewName ) ) OR ( NOT ValueExists ( OldName ) ) THEN Exit;
   New ( p );
   j := Sizeof ( p^ );
   strcopy ( p^, '' );
   i := GetValue ( OldName, p, j );
   DeleteValue ( OldName );
   SetValue ( NewName, p^, i, j );
   Result := ValueExists ( NewName );
   Dispose ( p );
END;

FUNCTION TRegistry.CreateKey ( Key : String ) : Boolean;
VAR
i : WinInteger;
j : DWord;
k : HKey;
BEGIN
   IF AbsoluteKey ( Key ) THEN Delete ( Key, 1, 1 );
   strpcopy ( pTemp, Key );
   i := RegCreateKeyEx ( RootKey, PTemp, 0, NIL,
                       REG_OPTION_NON_VOLATILE, Access, NIL, k, @j );
   Result := i = Error_Success;
   IF Result
   THEN BEGIN
      CurrentKey := k;
      CurrentPath := Key;
      NewKeyCreated := j = REG_CREATED_NEW_KEY;
   END;
END;

PROCEDURE TRegistry.CloseKey;
BEGIN
   IF ( CurrentKey = 0 ) OR ( CurrentKey = RootKey ) THEN Exit;
   IF LazyWrite THEN RegCloseKey ( CurrentKey ) ELSE RegFlushKey ( CurrentKey );
   CurrentKey := 0;
   CurrentPath := '';
   NewKeyCreated := False;
END;

FUNCTION TRegistry.SaveKey ( CONST Key, aFileName : String ) : Boolean;
VAR
h : Hkey;
i : WinInteger;
BEGIN
   Result := False;
   h := OpenRegistryKey ( Key );
   IF h <> 0 THEN BEGIN
      Strpcopy ( pTemp, aFileName );
      i := RegSaveKey ( h, pTemp, NIL );
      Result := i = Error_Success;
      RegCloseKey ( h );
   END;
END;

FUNCTION TRegistry.DeleteKey ( Key : String ) : Boolean;
BEGIN
   IF AbsoluteKey ( Key ) THEN Delete ( Key, 1, 1 );
   strpcopy ( pTemp, Key );
   Result := RegDeleteKey ( RootKey, pTemp ) = Error_Success;
END;

FUNCTION  TRegistry.DeleteValue ( CONST aName : String ) : Boolean;
BEGIN
   Result := False;
   IF NOT ValueExists ( aName ) THEN Exit;
   Strpcopy ( pTemp, aName );
   Result := RegDeleteValue ( CurrentKey, pTemp ) = Error_Success;
END;

FUNCTION TRegistry.GetValue ( CONST aName : String; VAR Data; VAR DataSize : DWord ) : WinInteger;
VAR
i : WinInteger;
j : DWord;
k : HKey;
s, s2 : TString;
BEGIN
   Result := - 1;
   s := aName;
   s2 := CurrentPath;
   IF AbsoluteKey ( s ) THEN Delete ( s, 1, 1 );
   IF Pos ( '\', s ) > 0
   THEN BEGIN
      s2 := ExtractFileDir ( s );
      s := ExtractFileName ( s );
   END;

   strpcopy ( pTemp, s2 );
   IF RegOpenKey ( RootKey, pTemp, k ) = Error_Success
   THEN BEGIN
       strpcopy ( pTemp, s );
       i := RegQueryValueEx ( k, pTemp, NIL, @j, @Data, @DataSize );
       IF i = Error_Success
       THEN BEGIN
          Result := j;
       END ELSE BEGIN
           // Showlasterror ( i );
       END;
       RegCloseKey ( k );
   END;
  CurrentPath := s2;
END;

FUNCTION TRegistry.SetValue ( CONST aName : String; VAR Data;
         DataType, DataSize : WinInteger ) : Boolean;
VAR
i : WinInteger;
k : HKey;
s, s2 : TControlStr;
BEGIN
   Result := False;
   s := aName;
   s2 := CurrentPath;
   IF AbsoluteKey ( s ) THEN Delete ( s, 1, 1 );
   IF Pos ( '\', s ) > 0
   THEN BEGIN
      s2 := ExtractFileDir ( s );
      s := ExtractFileName ( s );
   END;

   strpcopy ( pTemp, s2 );
   IF RegOpenKey ( RootKey, pTemp, k ) = Error_Success
   THEN BEGIN
       strpcopy ( pTemp, s );
       CASE DataType OF
          3, 4, 5, 8 :  // numeric values
          i := RegSetValueEx ( k, pTemp, 0, DataType, @Data, DataSize );
       ELSE
          i := RegSetValueEx ( k, pTemp, 0, DataType,
               {$ifdef FPC}pByte{$else}PChar{$endif} ( Data ), DataSize );
       END;
       Result := i = Error_Success;
       RegCloseKey ( k );
   END;
  CurrentPath := s2;
END;

FUNCTION TRegistry.ReadString ( CONST aName : String ) : TString;
VAR
len : DWord;
p   : ARRAY [0..MaxSizeChar] OF char;
BEGIN
   Result := '';
   strcopy ( p, '' );
   len := sizeof ( p );
   {IF }GetValue ( Aname, p, len ) { = Reg_SZ THEN};
   pChar2String ( p, Result );
END;

FUNCTION TRegistry.ReadStringEx ( CONST Section, Ident, Default : String ) : TString;
BEGIN
    Result := Default;
    IF OpenKey ( Section, False ) THEN Result := ReadString ( Ident );
END;

FUNCTION TRegistry.ReadInteger ( CONST aName : String ) : WinInteger;
VAR
p, i : WinInteger;
len : DWord;
BEGIN
   len := Sizeof ( p );
   i := GetValue ( Aname, p, len );
   IF ( i = Reg_DWord ) OR ( i = REG_DWORD_BIG_ENDIAN )
     THEN Result := p
       ELSE Result := - 1;
END;

FUNCTION TRegistry.ReadBool ( CONST aName : String ) : Boolean;
BEGIN
   Result := ReadInteger ( aName ) = 1;
END;

FUNCTION TRegistry.ReadFloat ( CONST aName : String ) : Double;
VAR
i : WinInteger;
len : DWord;
p : Double;
BEGIN
   len := Sizeof ( p );
   i := GetValue ( Aname, p, len );
   IF ( i = Reg_Binary )
     THEN Result := p
       ELSE Result := - 1;
END;

FUNCTION TRegistry.ReadBinaryData ( CONST aName : String; VAR Buffer; BufSize : DWord ) : WinInteger;
VAR
i : WinInteger;
len : DWord;
BEGIN
   len := BufSize;
   i := GetValue ( Aname, Buffer, len );
   IF ( i = Reg_Binary ) AND ( len = BufSize )
     THEN Result := len
       ELSE Result := - 1;
END;

FUNCTION TRegistry.ValueExists ( CONST aName : String ) : Boolean;
VAR
len : DWord;
p : ARRAY [0..MaxSizeChar] OF Char;
BEGIN
   len := Sizeof ( p );
   Result := GetValue ( Aname, p, len ) > 0;
END;

FUNCTION TRegistry.GetDataType ( CONST ValueName : String ) : TRegDataType;
VAR
len : DWord;
p : ARRAY [0..MaxSizeChar] OF Char;
BEGIN
   Result := rdUnknown;
   len := Sizeof ( p );
   CASE GetValue ( ValueName, p, len ) OF
      REG_NONE : Result := rdUnknown;
      REG_SZ : Result := rdString;
      REG_EXPAND_SZ : Result := rdExpandString;
      REG_BINARY : Result := rdBinary;
      REG_DWORD : Result := rdInteger;
      REG_DWORD_BIG_ENDIAN : Result := rdBigEndianInteger;
      REG_LINK : Result := rdLink;
      REG_MULTI_SZ : Result := rdMultiString;
      REG_RESOURCE_LIST : Result := rdResourceList;
   END; // CASE
END;

FUNCTION TRegistry.GetDataSize ( CONST ValueName : String ) : WinInteger;
VAR
i : WinInteger;
len : DWord;
p : ARRAY [0..MaxSizeChar] OF Char;
BEGIN
   Result := - 1;
   len := sizeof ( p );
   i := GetValue ( ValueName, p, len );
   IF i > 0 THEN Result := len;
END;

FUNCTION TRegistry.GetDataInfo ( CONST ValueName : String; VAR Value : TRegDataInfo ) : Boolean;
BEGIN
   Value.RegData := GetDataType ( ValueName );
   Result := Value.RegData <> rdUnknown;
   IF Result THEN Value.RegDataSize := GetDataSize ( ValueName );
END;

FUNCTION TRegistry.GetKeyNames ( VAR lStrings : TStrings ) : Boolean;
VAR
T : TRegKeyInfo;
i : WinInteger;
p : pChar;
BEGIN
   lStrings.Clear;
   IF GetKeyInfo ( T ) THEN
   WITH T DO BEGIN
      GetMem ( p, Succ ( MaxSubKeyLen ) );
      FOR i := 0 TO Pred ( NumSubKeys )
      DO BEGIN
          RegEnumKey ( CurrentKey, i, p, Succ ( MaxSubKeyLen ) );
          lStrings.AddP ( p );
      END;
      FreeMem ( p );
   END;
   Result := lStrings.Count > 0;
END;

FUNCTION TRegistry.GetValueNames ( VAR lStrings : TStrings ) : Boolean;
VAR
T : TRegKeyInfo;
i : WinInteger;
j : DWord;
p : pChar;
BEGIN
   lStrings.Clear;
   IF GetKeyInfo ( T ) THEN
   WITH T DO BEGIN
      GetMem ( p, Succ ( MaxValueLen ) );
      FOR i := 0 TO Pred ( NumValues )
      DO BEGIN
          Strcopy ( p, '' );
          j := Succ ( MaxValueLen );
          RegEnumValue ( CurrentKey, i, p, j, NIL, NIL, NIL, NIL );
          IF Strlen ( p ) > 0 THEN lStrings.AddP ( p );
      END;
      FreeMem ( p );
   END;
   Result := lStrings.Count > 0;
END;

FUNCTION TRegistry.GetKeyInfo ( VAR Value : TRegKeyInfo ) : Boolean;
BEGIN
  FillChar ( Value, sizeof ( Value ), 0 );
  Result := RegQueryInfoKey
            ( CurrentKey,
             NIL,
             NIL,
             NIL,
             @Value.NumSubKeys,
             @Value.MaxSubKeyLen,
             NIL,
             @Value.NumValues,
             @Value.MaxValueLen,
             @Value.MaxDataLen,
             NIL,
             pFileTime ( @Value.FileTime ) ) = Error_Success;
END;

FUNCTION TRegistry.KeyExists ( CONST Key : String ) : Boolean;
VAR
h : HKey;
s : TString;
BEGIN
   h := CurrentKey;
   s := CurrentPath;
   Result := OpenKey ( Key, False );
   IF Result THEN RegCloseKey ( CurrentKey );
   CurrentKey := h;
   CurrentPath := s;
END;

FUNCTION TRegistry.WriteString ( CONST aName, aValue : String ) : Boolean;
VAR
p : pChar;
BEGIN
    p := StrNewP ( aValue );
    Result := SetValue ( aName, p, Reg_SZ, Length ( aValue ) );
    StrDispose ( p );
END;

FUNCTION TRegistry.WriteExpandString ( CONST aName, Value : String ) : Boolean;
VAR
p : pChar;
BEGIN
    p := StrNewP ( Value );
    Result := SetValue ( aName, p, REG_EXPAND_SZ, Length ( Value ) );
    StrDispose ( p );
END;

FUNCTION TRegistry.WriteInteger ( CONST aName : String; Value : WinInteger ) : Boolean;
BEGIN
    Result := SetValue ( aName, Value, Reg_DWord, Sizeof ( Value ) );
END;

FUNCTION TRegistry.WriteBool ( CONST aName : String; Value : Boolean ) : Boolean;
BEGIN
    Result := WriteInteger ( aName, Ord ( Value ) );
END;

FUNCTION TRegistry.WriteFloat ( CONST aName : String; Value : Double ) : Boolean;
BEGIN
    Result := SetValue ( aName, Value, Reg_Binary, Sizeof ( Value ) );
END;

FUNCTION TRegistry.WriteDateTime ( CONST aName : String; Value : TDateTime ) : Boolean;
BEGIN
    Result := SetValue ( aName, Value, Reg_Binary, Sizeof ( Value ) );
END;

FUNCTION  TRegistry.WriteBinaryData ( CONST aName : String; VAR Buffer; BufSize : WinInteger ) : Boolean;
BEGIN
    Result := SetValue ( aName, Buffer, Reg_Binary, BufSize );
END;

FUNCTION TRegistry.ReadSection ( CONST Section : String; VAR lStrings : TStrings ) : Boolean;
BEGIN
  Result := False;
  IF OpenKey ( Section, False ) THEN Result := GetValueNames ( lStrings );
END;

FUNCTION TRegistry.ReadSections ( VAR lStrings : TStrings ) : Boolean;
BEGIN
  Result := GetKeyNames ( lStrings );
END;

FUNCTION TRegistry.EraseSection ( CONST Section : String ) : Boolean;
BEGIN
   Result := DeleteKey ( Section );
END;

FUNCTION TRegistry.ReadSectionValuesEx ( CONST Section : string; VAR lStrings : TStrings;
         ClearEntries, AddSectionNames : Boolean ) : Boolean;
VAR
s, s2 : TString;
ss : TStrings;
i : DWord;
BEGIN
   IF ClearEntries THEN lStrings.Clear;
   ss.Create;

   IF NOT ReadSection ( Section, ss )
   THEN BEGIN
      ss.Done;
      Result := False;
      Exit;
   END ELSE BEGIN
      Result := True;
      // OpenKey ( Section, False );
   END;

   FOR i := 0 TO Pred ( ss.Count )
   DO BEGIN
      s2 := '';
      s := ss.Strings ( i );
      s2 := s + '=' + ReadStringEx ( Section, s, '' );
      IF AddSectionNames
      THEN BEGIN
         PrependString ( SectionMarker, s2 );      // prepend marker
         PrependString ( Section, s2 );            // prepend section name
      END;
      IF s2 <> '' THEN lStrings.Add ( s2 );
   END;
   ss.Done;
END;

FUNCTION TRegistry.ReadSectionValues ( CONST Section : string; VAR lStrings : TStrings ) : Boolean;
BEGIN
   Result := ReadSectionValuesEx ( Section, lStrings, True, False );
END;

FUNCTION TRegistry.DeleteKeyEx ( CONST Section, Ident : string ) : Boolean;
BEGIN
   Result := False;
   IF OpenKey ( Section, False ) THEN Result := DeleteKey ( Ident );
END;

FUNCTION TRegistry.ReadBoolEx ( CONST Section, Ident : String; Default : Boolean ) : Boolean;
BEGIN
   Result := Default;
   IF OpenKey ( Section, False ) THEN Result := ReadBool ( Ident );
END;

FUNCTION TRegistry.ReadIntegerEx ( CONST Section, Ident : String; Default : Longint ) : Longint;
BEGIN
   Result := Default;
   IF OpenKey ( Section, False ) THEN Result := ReadInteger ( Ident );
END;

FUNCTION TRegistry.WriteBoolEx ( CONST Section, Ident : String; Value : Boolean ) : Boolean;
BEGIN
   Result := False;
   IF OpenKey ( Section, True ) THEN Result := WriteBool ( Ident, Value );
END;

FUNCTION TRegistry.WriteIntegerEx ( CONST Section, Ident : String; Value : Longint ) : Boolean;
BEGIN
   Result := False;
   IF OpenKey ( Section, True ) THEN Result := WriteInteger ( Ident, Value );
END;

FUNCTION TRegistry.WriteStringEx ( CONST  Section, Ident, Value : String ) : Boolean;
BEGIN
   Result := False;
   IF OpenKey ( Section, True ) THEN Result := WriteString ( Ident, Value );
END;

{**********************************************************}
{****************** TRegINIFile ***************************}
CONSTRUCTOR TRegIniFile.Create ( CONST aFileName : string );
BEGIN
   Init ( aFileName, KEY_ALL_ACCESS );
END;

CONSTRUCTOR TRegIniFile.Init ( CONST aFileName : string; AAccess : Cardinal );
BEGIN
   INHERITED Init ( aAccess );
   SetFileName ( aFileName );
END;

FUNCTION TRegIniFile.ReadString ( CONST Section, Ident, Default : String ) : TString;
BEGIN
    Result := ReadStringEx ( Section, Ident, Default );
END;

FUNCTION TRegIniFile.DeleteKey ( CONST Section, Ident : string ) : Boolean;
BEGIN
   Result := DeleteKeyEx ( Section, Ident );
END;

FUNCTION TRegIniFile.ReadBool ( CONST Section, Ident : String; Default : Boolean ) : Boolean;
BEGIN
   Result := ReadBoolEx ( Section, Ident, Default );
END;

FUNCTION TRegIniFile.ReadInteger ( CONST Section, Ident : String; Default : Longint ) : Longint;
BEGIN
   Result := ReadIntegerEx ( Section, Ident, Default );
END;

FUNCTION TRegIniFile.WriteBool ( CONST Section, Ident : String; Value : Boolean ) : Boolean;
BEGIN
   Result := WriteBoolEx ( Section, Ident, Value );
END;

FUNCTION TRegIniFile.WriteInteger ( CONST Section, Ident : String; Value : Longint ) : Boolean;
BEGIN
   Result := WriteIntegerEx ( Section, Ident, Value );
END;

FUNCTION TRegIniFile.WriteString ( CONST  Section, Ident, Value : String ) : Boolean;
BEGIN
   Result := WriteStringEx ( Section, Ident, Value );
END;

{********************************************************}
END.

