{
***************************************************************************
*                        inifiles.pas
*  (c) Copyright 2003, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements a (somewhat) Delphi(tm)-compatible INIfiles unit
*  and a TIniFiles object, for GNU Pascal
*
*  Supports Win32 and non-Win32 platforms
*
*  For non-Win32, define "__PORTABLE__" below
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     To provide Pascal objects for manipulating Windows INI files
*
*    Objects:
*           TIniFile
*           TMemIniFile (same as TIniFile)
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
*  Version: 1.01
*  Licence: Shareware
*
*  NOTES: this unit is work-in-progress; some things need more work !
***************************************************************************
}
UNIT inifiles;
{$i cwindows.inc}

{ if " __PORTABLE__"is defined, then we do not use the Win32 API
  in this unit. Rather, we use handcrafted routines in
  "windows2.pas"
}
{.$define __PORTABLE__}

INTERFACE

USES
   {$ifdef __PORTABLE__}
   Windows2,
   {$else}
   Messages,
   Windows,
   {$endif}
   SysUtils,
   cClasses;

CONST SectionMarker = '::';  // marker FOR END OF section names

TYPE
pIniFile = ^TIniFile;
TIniFile = OBJECT ( TClass )
   FileName : TString;
   Sections,             {@@@} // holds the names OF all sections
   Values : TStrings;    {@@@} // holds all sections + values

   CONSTRUCTOR  Create ( CONST FName : String );
   CONSTRUCTOR  Init ( CONST FName : String );
   DESTRUCTOR   Done; VIRTUAL;

   FUNCTION  ReadString ( Section, Ident, Default : String ) : TString; VIRTUAL;
   PROCEDURE WriteString ( CONST Section, Ident, Value : String ); VIRTUAL;

   PROCEDURE DeleteKey ( CONST Section, Ident : String ); VIRTUAL;
   PROCEDURE EraseSection ( CONST Section : String ); VIRTUAL;

   PROCEDURE UpdateFile; VIRTUAL;
   PROCEDURE FlushFileCache; VIRTUAL;{@@@}
   PROCEDURE Rename ( CONST fName : String; Reload : Boolean ); VIRTUAL;

   FUNCTION  SectionExists ( Section : String ) : Boolean;VIRTUAL;
   FUNCTION  ValueExists  ( CONST Section, Ident : String ) : Boolean;VIRTUAL;

   FUNCTION  ReadInteger ( CONST Section, Ident : String; Default : Longint ) : Longint; VIRTUAL;
   PROCEDURE WriteInteger ( CONST Section, Ident : String; Value : Longint ); VIRTUAL;

   FUNCTION  ReadBool ( CONST Section, Ident : String; Default : Boolean ) : Boolean ; VIRTUAL;
   PROCEDURE WriteBool ( CONST Section, Ident : String; Value : Boolean ); VIRTUAL;

   FUNCTION  ReadFloat ( CONST Section, Ident : String; Default : Double ) : Double; VIRTUAL;
   PROCEDURE WriteFloat ( CONST Section, Ident : String; Value : Double ); VIRTUAL;

   FUNCTION  ReadDateTime ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime; VIRTUAL;
   PROCEDURE WriteDateTime ( CONST Section, Ident : String; Value : TDateTime ); VIRTUAL;

   FUNCTION  ReadDate ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime; VIRTUAL;
   PROCEDURE WriteDate ( CONST Section, Ident : String; Value : TDateTime ); VIRTUAL;

   FUNCTION  ReadTime ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime; VIRTUAL;
   PROCEDURE WriteTime ( CONST Section, Ident : String; Value : TDateTime ); VIRTUAL;

   PROCEDURE ReadSection ( CONST Section : String; VAR Entries : TStrings ); VIRTUAL;
   PROCEDURE ReadSections ( VAR Entries : TStrings ); VIRTUAL;
   PROCEDURE ReadSectionValues ( CONST Section : String; VAR Entries : TStrings ); VIRTUAL;

   {@@@}
   PROCEDURE ReadSectionNames ( CONST Section : String; VAR Entries : TStrings ); VIRTUAL;
   PROCEDURE ReadSectionData ( CONST Section : String; VAR Entries : TStrings ); VIRTUAL;
   PROCEDURE ReadSectionValuesEx
   ( CONST Section : String; VAR Entries : TStrings;
     ClearEntries, AddSectionNames, GetDataOnly : Boolean ); VIRTUAL;

   //  READ all INI FILE data into "Sections" AND "Values"
   {@@@}
   PROCEDURE ReadAllData; VIRTUAL;

   PRIVATE
   FileNameP : ARRAY [0..259] OF Char;    // PRIVATE filename

END;

TYPE
pMemIniFile = ^TMemIniFile;
TMemIniFile = TIniFile;

IMPLEMENTATION

FUNCTION NewStrP ( CONST s : String ) : pChar;
VAR
p : pChar;
i : Cardinal;
BEGIN
  i := Length ( s );
  Getmem ( p, i );
  Strpcopy ( p, s );
  Result := p;
END;

PROCEDURE FreeStrP ( VAR p : pChar );
BEGIN
   IF Assigned ( p )
   THEN BEGIN
      Freemem ( p );
   END;
   p := NIL;
END;

CONSTRUCTOR TIniFile.Create;
BEGIN
   Init ( FName );
END;

CONSTRUCTOR TIniFile.Init;
BEGIN
   INHERITED Init ( NIL );
   FileName := FName;
   Strpcopy ( FileNameP, FName );
   Sections.Create;
   Values.Create;

   IF FileExists ( FileName )
   THEN BEGIN
      ReadAllData;  // ini FILE exists - READ it
   END
   ELSE BEGIN
      FileClose ( FileCreate ( FileName ) ); // create a new one
   END;
END;

PROCEDURE TIniFile.ReadAllData;
VAR
i : Cardinal;
BEGIN
   Sections.Clear;
   Values.Clear;
   ReadSections ( Sections );
   IF Sections.Count = 0 THEN Exit;
   FOR i := 0 TO Pred ( Sections.Count )
   DO BEGIN
       ReadSectionValuesEx ( Sections.Strings ( i ), Values, False, True, False );
   END;
END;

DESTRUCTOR TIniFile.Done;
BEGIN
   FileName := '';
   Values.Done;
   Sections.Done;
   INHERITED Done;
END;

PROCEDURE TIniFile.Rename ( CONST fName : String; Reload : Boolean );
BEGIN
   FileName := FName;
   Strpcopy ( FileNameP, FName );
   IF Reload THEN ReadAllData;
END;

FUNCTION TIniFile.ReadString ( Section, Ident, Default : String ) : TString;
VAR
p : pChar;
BEGIN
   GetMem ( p, 2048 );
   GetPrivateProfileString (
        {$ifndef __GPC__}sChar{$endif} ( Section ),
        {$ifndef __GPC__}sChar{$endif} ( Ident ),
        {$ifndef __GPC__}sChar{$endif} ( Default ), p, 2048, FileNameP );
   pChar2String ( p, Result );
   Freemem ( p );
END;

PROCEDURE TIniFile.WriteString ( CONST Section, Ident, Value : String );
VAR
s, i, v : pChar;
BEGIN
   IF Length ( Section ) > 0 THEN s := NewStrp ( Section )
      ELSE s := NIL;

   IF Length ( Ident ) > 0 THEN i := NewStrp ( Ident )
      ELSE i := NIL;

   IF Length ( Value ) > 0 THEN v := NewStrp ( Value )
      ELSE v := NIL;

   WritePrivateProfileString  ( s, i, v, FileNameP );

   {
   FreeStrP ( v );
   FreeStrP ( i );
   FreeStrP ( s );
   }
END;

PROCEDURE TIniFile.DeleteKey ( CONST Section, Ident : String );
BEGIN
   WriteString ( Section, Ident, '' );
END;

PROCEDURE TIniFile.EraseSection ( CONST Section : String );
BEGIN
   WriteString ( Section, '', '' );
END;

FUNCTION TIniFile.SectionExists ( Section : String ) : Boolean;
VAR
p : pChar;
BEGIN
   GetMem ( p, 256 );
   GetPrivateProfileString (
      {$ifndef __GPC__}sChar{$endif} ( Section ),
      NIL, NIL, p, 255, FileNameP );
   Result := StrPas ( p ) <> '';
   Freemem ( p );
END;

PROCEDURE TIniFile.ReadSection ( CONST Section : String; VAR Entries : TStrings );
VAR
p : pChar;
i, j : Cardinal;
s : TString;
BEGIN
   Getmem ( p, 2048 );
   j := GetPrivateProfileString (
      {$ifndef __GPC__}sChar{$endif} ( Section ), NIL, NIL, p, 2048, FileNameP );
   s := '';
   Entries.Clear;
   {}
   Entries.Sorted := False;
   {}
   IF j > 0 THEN
   FOR i := 0 TO Pred ( j )
   DO BEGIN
       IF p [i] = #0
       THEN BEGIN
           Entries.Add ( s );
           s := '';
       END ELSE BEGIN
           s := s + p [i];
       END;
   END;
   Freemem ( p );
END;

PROCEDURE TIniFile.ReadSectionNames ( CONST Section : String; VAR Entries : TStrings );
BEGIN
   ReadSection ( Section, Entries );
END;

PROCEDURE TIniFile.ReadSectionValues ( CONST Section : String; VAR Entries : TStrings );
BEGIN
   ReadSectionValuesEx ( Section, Entries, True, False, False );
END;

PROCEDURE TIniFile.ReadSectionData ( CONST Section : String; VAR Entries : TStrings );
BEGIN
   ReadSectionValuesEx ( Section, Entries, True, False, True );
END;

PROCEDURE TIniFile.ReadSectionValuesEx
( CONST Section : String; VAR Entries : TStrings;
ClearEntries, AddSectionNames, GetDataOnly : Boolean );
VAR
L : TStrings;
s, s2 : TString;
i : WinInteger;
BEGIN
  IF ClearEntries THEN Entries.Clear;
  L.Create;
  {}
  L.Sorted := False;
  Entries.Sorted := False;
  {}
  ReadSection ( Section, L );
  FOR i := 0 TO Pred ( L.Count )
  DO BEGIN
      s := L.Strings ( i );
      IF GetDataOnly
       THEN s2 := ReadString ( Section, s, '' )
       ELSE BEGIN
           s2 := s + '=' + ReadString ( Section, s, '' );
           IF AddSectionNames
           THEN BEGIN
              PrependString ( SectionMarker, s2 );      // prepend marker
              PrependString ( Section, s2 );            // prepend section name
           END;
       END;
      Entries.Add ( s2 );
  END;
  L.Done;
END;

PROCEDURE TIniFile.ReadSections ( VAR Entries : TStrings );
VAR
p : pChar;
i, j : WinInteger;
s : TString;
BEGIN
   Getmem ( p, 2048 );
   j := GetPrivateProfileString ( NIL, NIL, NIL, p, 2048, FileNameP );
   IF j < 1 THEN BEGIN // empty FILE
      Entries.Clear;
      Exit;
   END;

   s := '';
   FOR i := 0 TO Pred ( j )
   DO BEGIN
       IF p [i] = #0
       THEN BEGIN
           Entries.Add ( s );
           s := '';
       END ELSE BEGIN
           s := s + p [i];
       END;
   END;
   Freemem ( p );
END;

FUNCTION TIniFile.ValueExists  ( CONST Section, Ident : String ) : Boolean;
BEGIN
   Result := ReadString ( Section, Ident, '' ) <> '';
END;

FUNCTION TIniFile.ReadInteger ( CONST Section, Ident : String; Default : Longint ) : Longint;
VAR
s : TString;
BEGIN
  s := ReadString ( Section, Ident, IntToStr ( Default ) );
  Result := StrToIntDef ( s, Default );
END;

PROCEDURE TIniFile.WriteInteger ( CONST Section, Ident : String; Value : Longint );
BEGIN
   WriteString ( Section, Ident, IntToStr ( Value ) );
END;

FUNCTION  TIniFile.ReadBool ( CONST Section, Ident : String; Default : Boolean ) : Boolean;
BEGIN
   Result := ReadInteger ( Section, Ident, Ord ( Default ) ) <> 0;
END;

PROCEDURE TIniFile.WriteBool ( CONST Section, Ident : String; Value : Boolean );
BEGIN
  WriteInteger ( Section, Ident, Ord ( Value ) );
END;

FUNCTION  TIniFile.ReadFloat ( CONST Section, Ident : String; Default : Double ) : Double;
VAR
s : TString;
BEGIN
  s := ReadString ( Section, Ident, FloatToStr ( Default ) );
  Result := StrToFloat ( s );
END;

PROCEDURE TIniFile.WriteFloat ( CONST Section, Ident : String; Value : Double );
BEGIN
   WriteString ( Section, Ident, FloatToStr ( Value ) );
END;

FUNCTION  TIniFile.ReadDateTime ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime;
BEGIN
   Result := StrToDateTime ( ReadString ( Section, Ident, DateTimeToStr ( Default ) ) );
END;

PROCEDURE TIniFile.WriteDateTime ( CONST Section, Ident : String; Value : TDateTime );
BEGIN
   WriteString ( Section, Ident, DateTimeToStr ( Value ) );
END;

FUNCTION  TIniFile.ReadDate ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime;
BEGIN
   Result := StrToDate ( ReadString ( Section, Ident, DateToStr ( Default ) ) );
END;

PROCEDURE TIniFile.WriteDate ( CONST Section, Ident : String; Value : TDateTime );
BEGIN
   WriteString ( Section, Ident, DateToStr ( Value ) );
END;

FUNCTION  TIniFile.ReadTime ( CONST Section, Ident : String; Default : TDateTime ) : TDateTime;
BEGIN
   Result := StrToTime ( ReadString ( Section, Ident, TimeToStr ( Default ) ) );
END;

PROCEDURE TIniFile.WriteTime ( CONST Section, Ident : String; Value : TDateTime );
BEGIN
   WriteString ( Section, Ident, TimeToStr ( Value ) );
END;

PROCEDURE TIniFile.UpdateFile;
BEGIN
   FlushFileCache;
END;

PROCEDURE TIniFile.FlushFileCache;
BEGIN
   WritePrivateProfileString ( NIL, NIL, NIL, FileNameP );
   ReadAllData; // repopulate data
END;

{********************************}
END.

