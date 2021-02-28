{******************************************************************
*
*   Pascal unit to simulate two WinAPI ini file routines
*   Supports GNU Pascal, Delphi, FreePascal
*   (c)2005 Professor Abimbola A Olowofoyeku (The African Chief)
*   http://www.greatchief.plus.com
*
*   updated 26 Mar 2005
*******************************************************************
}
UNIT windows2;
{$X+}
{$H+}
INTERFACE

USES
Sysutils,
cClasses;


FUNCTION GetPrivateProfileString (
  SectionName,
  KeyName : PChar;
  aDef : PChar;
  ReturnedString : PChar;
  Size : Integer;
  FileName : PChar ) : Integer;

FUNCTION WritePrivateProfileString (
  SectionName,
  KeyName,
  Str,
  FileName : PChar ) : Boolean;

IMPLEMENTATION
TYPE
MyWin_Str = String {$ifdef __GPC__} ( 512 ) {$endif};

CONST
SectMark = #254;
EndMark = #255;
DelMark = #32;
EntryMark = '===';
Equal = '=';
Sq1 = '[';
Sq2 = ']';

// CASE insensitve "pos"
FUNCTION iPos ( CONST sub, s : String ) : Integer;
BEGIN
   Result := Pos ( UpperCase ( sub ), UpperCase ( s ) );
END;

FUNCTION isSection ( CONST s : String ) : Boolean;
BEGIN
  Result := ( s <> '' ) AND ( Pos ( Sq1, s ) = 1 ) AND ( Pos ( Sq2, s ) > 2 );
END;

FUNCTION isKey ( CONST s : String ) : Boolean;
BEGIN
  Result := ( s <> '' ) AND  ( s [1] <> ';' ) AND ( Pos ( Equal, s ) > 1 );
END;

FUNCTION GetPrivateProfileString (
  SectionName,
  KeyName : PChar;
  aDef : PChar;
  ReturnedString : PChar;
  Size : Integer;
  FileName : PChar ) : Integer;

CONST pS = 1024 * 64; // 64k buffer

VAR
Sections,
Keys,
List : TStringLists;
s, key : MyWin_Str;
i : Integer;
p : pChar;

BEGIN
  Result := 0;
  If Assigned ( aDef )
  THEN BEGIN
     Strlen ( aDef );
     StrLcopy ( ReturnedString, aDef, Size );
  END;

  IF NOT Assigned ( FileName ) THEN Exit;
  s := StrPas ( FileName );
  IF NOT FileExists ( s ) THEN Exit;

  List.Create;
  i := List.LoadFromFile ( s );
  IF i < 1
  THEN BEGIN
     List.Done;
     Exit;
  END;

  // get section names
  Sections.Create;
  FOR i := 0 TO List.LoopCount
  DO BEGIN
     s := List.Strings ( i );
     IF IsSection ( s ) THEN Sections.Add ( s );
  END;

  // SectionName = NIL := return section names
  IF NOT Assigned ( SectionName )
  THEN BEGIN
     Getmem ( p, pS );
     Strcopy ( p, '' );
     FOR i := 0 TO Sections.LoopCount
     DO BEGIN
         s := Sections.Strings ( i );
         ReplaceString ( Sq1, '', s );
         ReplaceString ( Sq2, EndMark, s );
         Strpcat ( p, s );
     END;
     StrLCopy ( ReturnedString, p, Size );
     Freemem ( p, pS );
     Result := Strlen ( ReturnedString );

    // separate WITH NULLs
    FOR i := 0 TO Pred ( Strlen ( ReturnedString ) ) DO
      IF ReturnedString [i] = EndMark
        THEN ReturnedString [i] := #0;

     List.Done;
     Sections.Done;
     Exit;
  END;

  // get keynames
  Keys.Create;
  FOR i := 0 TO List.LoopCount
  DO BEGIN
     s := List.Strings ( i );
     IF IsSection ( s ) THEN Key := s
      ELSE IF IsKey ( s )
       THEN Keys.Add ( Key + SectMark + s );
  END;

  // KeyName = NIL = = return key names
  IF NOT Assigned ( KeyName )
  THEN BEGIN
    Getmem ( p, pS );
    Strcopy ( p, '' );
    FOR i := 0 TO Keys.LoopCount
    DO BEGIN
       s := Keys.Strings ( i );
       IF Pos ( StrPas ( SectionName ), s ) > 0
       THEN BEGIN
          Delete ( s, 1, Pos ( SectMark, s ) );
          Delete ( s, Pos ( Equal, s ), Length ( s ) );
          s := s + EndMark;
          Strpcat ( p, s );
       END;
    END;

    // return length
    StrLCopy ( ReturnedString, p, Size );
    Freemem ( p, pS );
    Result := Strlen ( ReturnedString );

    // separate WITH NULLs
    IF Strlen ( ReturnedString ) > 0 THEN
    FOR i := 0 TO Pred ( Strlen ( ReturnedString ) ) DO
      IF ReturnedString [i] = EndMark
        THEN ReturnedString [i] := #0;

    List.Done;
    Sections.Done;
    Keys.Done;
    Exit;
  END;

  // IF we get here, THEN SectionName <> NIL AND KeyName <> NIL
  // search FOR matching sectioname + keyname
    FOR i := 0 TO Keys.LoopCount
    DO BEGIN
       s := UpperCase ( Keys.Strings ( i ) );
       IF
       ( iPos ( StrPas ( SectionName ), s ) > 0 )
       AND
       ( iPos ( StrPas ( KeyName ) + Equal, s ) > 0 )
       THEN BEGIN
          s := Keys.Strings ( i );
          key := s;
          Delete ( s, 1, Pos ( SectMark, s ) ); // remove section
          Delete ( s, Pos ( Equal, s ), Length ( s ) ); // remove value
          IF AnsiCompareText ( s, StrPas ( KeyName ) ) = 0
          THEN BEGIN
             Delete ( Key, 1, Pos ( Equal, Key ) );
             Key := Key + #0;
             StrLCopy ( ReturnedString, pChar ( @key [1] ), Size );
             Result := Strlen ( ReturnedString );
             Break;
          END;
       END;
    END;

  // cleanup
    List.Done;
    Sections.Done;
    Keys.Done;
END;

FUNCTION IsEmptyList ( VAR L : TStringLists ) : Boolean;
VAR
i : Cardinal;
BEGIN
   Result := True;
   IF L.Count = 0 THEN Exit;
   FOR i := 0 TO L.LoopCount DO
     IF ( Trim ( L.Strings ( i ) ) <> '' )
     THEN BEGIN
        Result := False;
        Exit;
     END;
   L.Clear;
END;

FUNCTION WritePrivateProfileString (
  SectionName,
  KeyName,
  Str,
  FileName : PChar ) : Boolean;

VAR
CurrSec,
Sections,
Keys,
List : TStringLists;
s, key : MyWin_Str;
i, j : Integer;
Found : Boolean;

BEGIN
  Result := False;
  s := Strpas ( FileName );

  List.Create;

  // no FILE - create one
  IF ( NOT FileExists ( s ) )
  OR
  (
  ( FileExists ( s ) )
  AND
  (
  ( List.LoadFromFile ( s ) < 1 ) ) OR ( IsEmptyList ( List ) )
  )
  THEN BEGIN
     IF Assigned ( SectionName ) THEN
     WITH List
     DO BEGIN
        Add ( Sq1 + Strpas ( SectionName ) + Sq2 );
        IF ( Assigned ( KeyName ) ) AND ( Assigned ( Str ) )
           THEN Add ( Strpas ( KeyName ) + Equal + StrPas ( Str ) );
        Result := SaveToFile ( s ) > 0;
     END;
     List.Done;
     Exit;
  END;

  // get section names
  Sections.Create;
  FOR i := 0 TO List.LoopCount
  DO BEGIN
     s := List.Strings ( i );
     IF IsSection ( s ) THEN Sections.Add ( s );
  END;

  // check whether section exists
  Found := False;
  FOR i := 0 TO Sections.LoopCount
  DO BEGIN
     Found := AnsiCompareText ( Sq1 + Strpas ( SectionName ) + Sq2,
              Sections.Strings ( i ) ) = 0;
     IF Found THEN Break;
  END;

  // NOT found = create a new section AND quit
  IF NOT Found
  THEN BEGIN
     Sections.Done;
     WITH List
     DO BEGIN
        IF Assigned ( SectionName )
        THEN BEGIN
           Add ( Sq1 + Strpas ( SectionName ) + Sq2 );
           IF ( Assigned ( KeyName ) ) AND ( Assigned ( Str ) )
              THEN Add ( Strpas ( KeyName ) + Equal + StrPas ( Str ) );
           Result := SaveToFile ( Strpas ( FileName ) ) > 0;
        END;
        Done;
        Exit;
     END;
  END;

  // IF we get here, THEN the section was found
  // get keynames
  Keys.Create;
  FOR i := 0 TO List.LoopCount
  DO BEGIN
     s := List.Strings ( i );
     IF IsSection ( s ) THEN Key := s
      ELSE IF IsKey ( s )
       THEN BEGIN
          Keys.Add ( Key + SectMark + s + EntryMark + IntToStr ( i ) ); // marked entry
       END;
  END;

  // delete the whole section
  IF ( NOT Assigned ( KeyName ) ) OR ( Strlen ( KeyName ) = 0 )
  THEN BEGIN
     FOR i := 0 TO Keys.LoopCount
     DO BEGIN
         s := Keys.Strings ( i );
         j := Pos ( SectMark, s );

         // find matching section
         IF AnsiCompareText ( Copy ( s, 1, Pred ( j ) ), Sq1 + Strpas ( SectionName ) + Sq2 ) = 0
         THEN BEGIN
            Delete ( s, 1, Pos ( EntryMark, s ) + 2 );
            j := StrToInt ( s );
            List.Replace ( j, DelMark );
         END;
     END;

     FOR i := 0 TO List.LoopCount
     DO BEGIN
         s := List.Strings ( i );
         IF AnsiCompareText ( s, Sq1 + Strpas ( SectionName ) + Sq2 ) = 0
         THEN BEGIN
             List.Replace ( i, DelMark );
             Break;
         END;
     END;

     FOR i := 0 TO List.LoopCount  DO
       IF List.Strings ( i ) = DelMark
         THEN BEGIN
            List.AtDelete ( i );
            {List.AtFree (i);}
         END;

     Result := List.SaveToFile ( Strpas ( FileName ) ) > 0;

     List.Done;
     Sections.Done;
     Keys.Done;
     Exit;
  END;

  // IF we get here, THEN KeyName IS assigned
  // find AND store the relevant section
  CurrSec.Create;
  FOR i := 0 TO Keys.LoopCount
  DO BEGIN
     s := Keys.Strings ( i );
     s := Trim ( s );
     IF Pos ( Sq1 + UpperCase ( Strpas ( SectionName ) ) + Sq2, UpperCase ( s ) ) > 0
     THEN CurrSec.Add ( s );
  END;

  // new section
  IF ( CurrSec.Count < 1 )
  THEN BEGIN
     CurrSec.Done;
     WITH List DO BEGIN
        Add ( Sq1 + Strpas ( SectionName ) + Sq2 );
        IF ( Assigned ( KeyName ) ) AND ( Assigned ( Str ) )
        THEN Add ( Strpas ( KeyName ) + Equal + StrPas ( Str ) );
        Result := SaveToFile ( Strpas ( FileName ) ) > 0;
     END;
     List.Done;
     Sections.Done;
     Keys.Done;
     Exit;
  END;

  // find matching key
  FOR i := 0 TO CurrSec.LoopCount
  DO BEGIN
     s := CurrSec.Strings ( i );
     j := Pos ( SectMark, s );
     Key := s;
     Delete ( s, 1, j );
     Delete ( s, Pos ( Equal, s ), Length ( s ) );

     // find matching key
     IF AnsiCompareText ( s, Strpas ( KeyName ) ) = 0
     THEN BEGIN
           Delete ( Key, 1, Pos ( EntryMark, Key ) + 2 );
           j := StrToInt ( Key );
           IF ( Assigned ( Str ) ) AND ( Strlen ( Str ) > 0 )
           THEN BEGIN // replace the key's value
               s := s + Equal + Strpas (Str);
               List.Replace (j, s);
           end
           else begin // delete the key
               List.Replace (j, DelMark);
               List.AtDelete (j);
           end;
          Result := List.SaveToFile (Strpas (FileName)) > 0;
          CurrSec.Done;
          List.Done;
          Sections.Done;
          Keys.Done;
          Exit;
     end; // matching key
  end;// for

  // if we get here, it is a new key
  CurrSec.Done;
  If (Assigned (Str)) and (Strlen (Str) > 0)
  then begin
    For i := 0 to List.LoopCount
    do begin
       s := List.Strings (i);
       If AnsiCompareText (s, Sq1 + Strpas (SectionName) + Sq2) = 0
       then begin
          List.InsertP (Succ (i), StrPas (KeyName) + Equal + StrPas (Str));
          Break;
       end;
    end; // for
  end; // if
  Result := List.SaveToFile (Strpas (FileName)) > 0;
  List.Done;
  Sections.Done;
  Keys.Done;
end;

//* ------------------------------
end.

