{
 **************************************************************************
                 testobj.pas
     * simple test program for the objects unit
     * shows some collections
 **************************************************************************
}
PROGRAM testobj;

USES Sysutils, Objects;

TYPE
pinteger = ^integer;
pfoo = ^foo;
foo = RECORD
  bar : integer;
  fuu : string [8];
END;

pStaff = ^TStaff;
TStaff = RECORD
   Name : String [64];
   Address : String [255];
   Age : Byte;
   ID : Cardinal;
   Telephone : String [12];
END;

TBaseCollection = OBJECT ( TCollection )
   PROCEDURE Clear; VIRTUAL;
   FUNCTION  IsValidID ( CONST Index : Cardinal ) : Boolean; VIRTUAL;
END;

{ trivial integer collection }
TIntCollection = OBJECT ( TBaseCollection )
   PROCEDURE Add ( CONST i : integer );
   FUNCTION  Values ( CONST index : Cardinal ) : Integer;
   PROCEDURE Replace ( CONST Index : Cardinal; CONST Value : Integer );
END;

{ trivial Staff collection }
TStaffCollection = OBJECT ( TIntCollection )
   PROCEDURE Add ( CONST i : TStaff );
   PROCEDURE Add2 ( CONST iName, iAddress : String; iAge : Byte; iID : Cardinal;
                   CONST iTelePhone : String );
   FUNCTION  Values ( CONST index : Cardinal ) : TStaff;
   PROCEDURE Replace ( CONST Index : Cardinal; CONST Value : TStaff );
END;

{  helper routines }
FUNCTION intnew ( CONST i : integer ) : pinteger;
BEGIN
   getmem ( result, sizeof ( i ) );
   result^ := i;
END;

FUNCTION foonew ( CONST f : foo ) : pfoo;
BEGIN
   getmem ( result, sizeof ( foo ) );
   result^ := f;
END;

{ TStaffCollection }
PROCEDURE TStaffCollection.Add ( CONST i : TStaff );
VAR p : pStaff;
BEGIN
   New ( p );
   p^ := i;
   Insert ( p );
END;

PROCEDURE TStaffCollection.Add2;
VAR t : TStaff;
BEGIN
   WITH t DO BEGIN
        Name := iName;
        Address := iAddress;
        Age := iAge;
        ID := iID;
        Telephone := iTelephone;
   END;
   Add ( t );
END;

FUNCTION  TStaffCollection.Values;
BEGIN
   IF IsValidID ( Index ) THEN Result := pStaff ( At ( Index ) ) ^
     ELSE
      WITH Result DO BEGIN
         Name := '';
         Address := '';
         Age := 0;
         ID := 0;
         Telephone := '';
      END;
END;

PROCEDURE TStaffCollection.Replace;
BEGIN
   IF IsValidID ( Index ) THEN pStaff ( Items^ [Index] ) ^ := Value;
END;

{ TIntCollection }
PROCEDURE TIntCollection.Add;
BEGIN
   Insert ( intnew ( i ) );
END;

FUNCTION  TIntCollection.Values;
BEGIN
   IF IsValidID ( Index ) THEN Result := pinteger ( At ( Index ) ) ^
     ELSE Result := MaxInt;
END;

PROCEDURE TIntCollection.Replace;
BEGIN
   IF IsValidID ( Index ) THEN pinteger ( Items^ [Index] ) ^ := Value;
END;

{ TBaseCollection }
FUNCTION  TBaseCollection.IsValidID;
BEGIN
   Result := ( Count > 0 ) AND ( Index < Count );
END;

PROCEDURE TBaseCollection.Clear;
BEGIN
   FreeAll;
END;

{--------------------}
VAR
t : tcollection;
ts : TStaffCollection;
ti : TIntCollection;
i : integer;
s : string [4];
f : foo;
BEGIN

 { string collection }
 t.init ( 16, 4 );
 FOR i := 1 TO 16
 DO BEGIN
    s := chr ( i + 64 ) + #0;
    t.insert ( strnew ( @s [1] ) );
 END;

 Writeln ( 'Our test string collection has ', t.count, ' items ' );
 FOR i := 0 TO pred ( t.count )
 DO BEGIN
    Writeln ( Succ ( i ), '. ', pchar ( t.at ( i ) ) );
 END;
 t.done;

 { integer collection #1 }
 t.init ( 16, 4 );
 FOR i := 1 TO 16
 DO BEGIN
    t.insert ( intnew ( i * i ) );
 END;

 Writeln ( 'Our test integer collection (#1) has ', t.count, ' items ' );
 FOR i := 0 TO pred ( t.count )
 DO BEGIN
    Writeln ( Succ ( i ), '. ', pinteger ( t.at ( i ) ) ^ );
 END;
 t.done;

 { integer collection #2 }
 ti.init ( 16, 4 );
 FOR i := 1 TO 16 DO ti.Add ( i * i * i );
 ti.Replace ( 0, 1024 * 16 );
 Writeln ( 'Our test integer collection (#2) has ', ti.count, ' items ' );
 FOR i := 0 TO pred ( ti.count )
     DO Writeln ( Succ ( i ), '. ', ti.Values ( i ) );
 ti.done;

 { record collection }
 t.init ( 16, 4 );
 FOR i := 1 TO 16
 DO BEGIN
    WITH f DO BEGIN
        bar := i * 16;
        str ( bar, fuu );
    END;
    t.insert ( foonew ( f ) );
 END;

 Writeln ( 'Our test record collection has ', t.count, ' items ' );
 FOR i := 0 TO pred ( t.count )
 DO BEGIN
    Writeln ( Succ ( i ), '. ', pfoo ( t.at ( i ) ) ^.fuu, ' (', pfoo ( t.at ( i ) ) ^.bar * i, ')' );
 END;
 t.done;

 { staff collection }
 WITH ts DO BEGIN
   Init ( 16, 4 );
   Add2 ( 'African Chief', 'England', 16, 4000, '+44 1234 5678 00' );
   Add2 ( 'Adam Smith', 'England', 250, 4001, '+44 9876 5432 10' );
   Add2 ( 'Da Vinci', 'Italy', 250, 4002, '+33 3333 3333 33' );
   Writeln ( 'Our staff collection has ', Count, ' item(s) ' );
   FOR i := 0 TO pred ( Count )
     DO Writeln ( Succ ( i ), '. ', Values ( i ) .Name );
   Done;
 END;

 {  sizes }
 {$ifdef __GPC__}
 Writeln;
 Writeln ( 'Maximum data structures size = ', MaxBytes, ' bytes' );
 Writeln ( 'Maximum collections size =     ', MaxCollectionSize, ' items' );
 {$endif}
END.

