{
***************************************************************************
*                 cClasses.pas
*  (c) Copyright 2003-2005, Professor Abimbola A Olowofoyeku (The African Chief)
*
*  This UNIT implements some base classes for the ObjectMingw class library
*
*  It is part of the ObjectMingw object/class library
*
*  Purpose:
*     * To provide base Pascal objects for the ObjectMingw class library
*     * To keep a count (in a collection) of all instantiated windowed objects
*
*    Objects:
*      * TBaseClass    (base ancestor for all objects: derived from TObject)
*      * TClass        (ancestor class for ObjectMingw library)
*      * Exception     (non-functional Exception object - GPC only)
*      * TThread       (thread object)
*      * TDataPrinter  (raw data print object)
*      * TStrings      (string collection object)
*      * TStringLists  (same as TStrings)
*
*  It compiles under GNU Pascal, FreePascal, Virtual Pascal,
*  and 32-bit versions of Delphi.
*
*  Author: Professor Abimbola A Olowofoyeku (The African Chief)
*          http://www.greatchief.plus.com
*          chiefsoft [at] bigfoot [dot] com
*
*  Last modified: 24 Oct. 2005
*  Version: 1.04
*  Licence: Shareware
*
*  NOTES: this unit is work-in-progress; some things need more work !
***************************************************************************
}

{$i cwindows.inc}
UNIT cclasses;

INTERFACE

USES
{$ifdef __GPC__}
GPC,
System,
Dosunix,
{$endif}
Sysutils,
{$ifdef WIN32}Windows, {$endif}
Objects;  { for TObject and TCollection, etc. }


{ general string types sizes }
CONST
TAnsiStringLen = 1024 * 128;  { for "ansistring" - really just a big string }
TStringLen     = 1024 * 63;   { should be no bigger than 63k! }
TControlStrLen = 1024 * 1;

TYPE
  oCharSet    = Set OF Char;

 {$ifdef __TMT__}
 AnsiString = String;
 {$endif}

{* assorted data types *}
{$ifdef __GPC__}
  WinInteger  = Integer; { normal (32-bit) integer }
  AnsiString  = String ( TAnsiStringLen ); { big string: amend as required - increase }
                                           { stack if higher than 128k!!}
  TControlStr = String ( TControlStrLen );
  TString = GPC.TString;
  Int64 = GPC.Int64;
  {$ifndef WIN32}
  HWnd = Cardinal;
  Va_List = PChar;
  {$endif}
{$else}{__GPC__}

  {$ifdef Old_Delphi}
    {$ifdef VirtualPascal}
     Integer  = Longint;
    {$endif}
     Int64 = Longint;
     LongWord = Cardinal;
     Word64   = LongWord;
  {$else}
     Word64   = 0 .. High ( Int64 );
  {$endif}

  TString     = AnsiString;
  TControlStr = AnsiString;
  sChar       = pChar; { for type-casting pChars }
  WinInteger  = Longint;
{$endif}{__GPC__}

CONST
MaxCharArraySize =
{$ifdef __GPC__}1 SHL ( BitSizeOf ( Pointer ) - 4 ) {$else}High ( Integer ) {$endif};

CONST
EndOfLineMarker =
{$ifdef __GPC__}
  {$ifdef WIN32}
    "\r\n"
  {$else}
    "\n"
  {$endif}
  ;
{$else}{__GPC__}
   #13#10;
{$endif}{__GPC__}

TYPE
  pInt64 = ^Int64;
  pCharArray  = ^TCharArray;
  TCharArray  = ARRAY [0.. Pred ( MaxCharArraySize ) ] OF Char;

{ global to indicate start state of window of main window }
{$ifndef __GPC__}VAR CmdShow    : WinInteger; {$endif}

{*************************************}
{ base class - derived from TObject so as to be streamable }
TYPE
pClass = ^TClass;

pBaseClass = ^TBaseClass;
TBaseClass = OBJECT ( TObject )
  IsCreated : Boolean;
  SelfID  : Word64;
  Tag : WinInteger;
  Name,
  Caption : TControlStr;
  Handle,
  ParentHandle : hWnd;
  CONSTRUCTOR Init ( Owner : pClass );
  CONSTRUCTOR Create;
  DESTRUCTOR  Done; VIRTUAL;
  DESTRUCTOR  Destroy; VIRTUAL;
END;

TClass = OBJECT ( TBaseClass )
  CONSTRUCTOR Init ( Owner : pClass );
  DESTRUCTOR  Done; VIRTUAL;
END;

{*************************************}
{$ifdef __GPC__}
{ trivial exception object - does nothing much,
  and is not a proper exception handler }
TYPE
pException = ^Exception;
Exception = OBJECT ( TClass )
    Message    : TString;
    HelpContext : Integer;
    CONSTRUCTOR  Init ( CONST Msg : string );
    DESTRUCTOR   Done; VIRTUAL;
END; {* Exception *}
{$endif}
{*************************************}
TYPE
TDuplicates = ( dupIgnore, dupAccept, dupError );

{*************************************}
{ string collection object }
TYPE
pStrings  = ^TStrings;
TStrings  = OBJECT ( TStrCollection )
   Sorted : Boolean;
   fDuplicates : TDuplicates; { @@ Duplicates in Delphi }
   BufferLength : Word64;
   CONSTRUCTOR Create;
   CONSTRUCTOR Init ( ALimit, ADelta : Cardinal );
   DESTRUCTOR  Destroy;
   DESTRUCTOR  Done; VIRTUAL;
   FUNCTION    Add ( CONST s : String ) : WinInteger; VIRTUAL;
   FUNCTION    AddP ( CONST s : pChar ) : WinInteger; VIRTUAL;
   PROCEDURE   Append ( CONST s : String ); VIRTUAL;
   PROCEDURE   AppendP ( CONST s : pChar ); VIRTUAL;
   PROCEDURE   AddStrings ( VAR NewStrings : TStrings ); VIRTUAL;
   FUNCTION    LoadFromString ( CONST s : String ) : WinInteger; VIRTUAL;
   FUNCTION    LoadFromStream ( CONST s : pChar; Separators : oCharset ) : WinInteger; VIRTUAL;

   PROCEDURE   Move ( CurIndex, NewIndex : Cardinal ); VIRTUAL;
   FUNCTION    Strings ( CONST Index : Cardinal ) : TString;
   FUNCTION    pChars ( CONST Index : Cardinal ) : pChar;
   FUNCTION    LoadFromFile ( CONST FName : String ) : WinInteger; VIRTUAL;
   FUNCTION    ReadFromFile ( {CONST }FName : String; AllowBlanks : Boolean ) : WinInteger; VIRTUAL;
   FUNCTION    SaveToFile ( CONST FName : String ) : WinInteger; VIRTUAL;
   PROCEDURE   Sort; VIRTUAL;
   PROCEDURE   Clear; VIRTUAL;
   FUNCTION    Find ( CONST S : string; VAR Index : Integer ) : Boolean; VIRTUAL;

   { @@ renamed methods @@ }
   PROCEDURE   DeleteP ( Index : Cardinal ); VIRTUAL;{ @@ }
   PROCEDURE   InsertP ( Index : Cardinal; CONST S : String ); VIRTUAL;{ @@ }
   FUNCTION    IndexOfP ( CONST S : String ) : Integer; VIRTUAL;{ @@ }

   { return contents as one string }
   FUNCTION    Text : AnsiString; VIRTUAL; { @@ this one is problematic @@ }

   { return contents as one pChar }
   FUNCTION    Buffer : pChar; VIRTUAL;

   { returns the start of the list: always zero }
   FUNCTION    LoopStart : Cardinal;

   { returns the end of the list: (count - 1) }
   FUNCTION    LoopCount : WinInteger;

   { exchange strngs at index1 with index2 }
   PROCEDURE   Exchange ( Index1, Index2 : Cardinal ); VIRTUAL;

   { Replace contents of Dest with contents of Source }
   PROCEDURE   ReAssign ( VAR Source, Dest : TStrings ); VIRTUAL;

   { sort the list from aLo to aHi }
   PROCEDURE   QSort ( aLo, aHi : Cardinal ); VIRTUAL;

   { replace string at index with "s" }
   FUNCTION    Replace ( CONST Index : Cardinal; s : String ) : Boolean; VIRTUAL;

   { break down a string into a TStrings list }
   PROCEDURE   StringToTStrings ( CONST Source : String; VAR Dest : TStrings ); VIRTUAL;

   { case conversion of the whole list: uppercase }
   PROCEDURE   ToUpperAll; VIRTUAL;

   { case conversion of the whole list: lowercase }
   PROCEDURE   ToLowerAll; VIRTUAL;

   { length of the string at index (or -1 if index is invalid) }
   FUNCTION    StringLength ( CONST Index : Cardinal ) : WinInteger;

   { length of all the strings in the list combined }
   FUNCTION    TStringsLength : Cardinal;

   PROCEDURE   SetDuplicates ( TheValue : TDuplicates );
END; {* TStrings *}
{*************************************}

{ At present this is exactly the same as its ancestor }
pStringList = ^TStringList;
TStringList = TStrings; {* TStringList *}
{*************************************}

{$ifdef WIN32}
{ Threads }
TThreadMethod = PROCEDURE ( Sender : pClass );
pThread = ^TThread;
TThread = OBJECT ( TClass )
  Priority : WinInteger;
  Suspended,
  Terminated : Boolean;
  ReturnValue : WinInteger;
  ThreadID : DWORD;
  ThreadRoutine : Pointer;
  CONSTRUCTOR Init ( CreateSuspended : Boolean );
  CONSTRUCTOR InitHandler ( CreateSuspended : Boolean; aProc : Pointer );
  CONSTRUCTOR Create ( CreateSuspended : Boolean );
  DESTRUCTOR  Done; VIRTUAL;
  PROCEDURE   Terminate; VIRTUAL;
  PROCEDURE   Suspend; VIRTUAL;
  PROCEDURE   Resume; VIRTUAL;
  PROCEDURE   Execute; VIRTUAL;
  PROCEDURE   Synchronize ( aMethod : TThreadMethod; Sender : pClass ); VIRTUAL;
  PROCEDURE   AfterConstruction; VIRTUAL;
  PROCEDURE   SetPriority ( aValue : WinInteger ); VIRTUAL;
END;

{ raw print data }
pDataPrinter = ^TDataPrinter;
TDataPrinter = OBJECT ( TClass )
   fHandle : WinInteger;
   CONSTRUCTOR Init ( Port : pChar );
   CONSTRUCTOR Create;
   DESTRUCTOR  Done; VIRTUAL;
   FUNCTION    Active : Boolean; VIRTUAL;
   FUNCTION    Print ( CONST Data; DataSize : DWord ) : DWord; VIRTUAL;
END;

{$endif}

{ helper routines used throughout }
Procedure ReplaceString ( Const tOld, TNew : String; Var Dest : String) ;
FUNCTION  TokenisePChar ( p : pChar; VAR T : TStrings; Marker : oCharSet ) : WinInteger;
FUNCTION  TokeniseString ( Const p : String; VAR T : TStrings; Marker : oCharSet ) : WinInteger;
FUNCTION  LastPos ( ch : char; CONST s : string ) : WinInteger;
PROCEDURE StringToParagraphs ( CONST Source : String; VAR Dest : TStrings );
PROCEDURE ConcatString ( VAR Dest : String; CONST Source : String );
PROCEDURE PrependString ( CONST Source : String; VAR Dest : String );
PROCEDURE ShowMessage ( Msg : String );
PROCEDURE ShowMessageInt ( Msg : Integer );
PROCEDURE pChar2String ( p : pchar; VAR Dest : String );
{$ifdef __GPC__}external name '_p_CopyCString';{$endif}
PROCEDURE ShowLastError ( Id : WinInteger );
FUNCTION  LastError ( Id : WinInteger ) : TString;
FUNCTION  StrNewP ( s : String ) : pChar;
FUNCTION  StrPasEx ( p : pChar ) : AnsiString;
PROCEDURE StrpCat ( Dest : pChar; CONST Source : string );
FUNCTION  TStrings2pChar ( VAR x : TStrings ) : pChar;

{ collection type, etc., to keep count and track of instantiated windowed objects }
{**************************************}
TYPE
pObjectCollection = ^TObjectCollection;
TObjectCollection = OBJECT ( TCollection )
   PROCEDURE FreeItem ( Item : Pointer ); VIRTUAL;
   PROCEDURE Insert ( Item : Pointer ); VIRTUAL;
END;

{
  * globals for dealing with object counts, etc
  * these are private stuff - don't touch them !!!
}
VAR
ObjectList : pObjectCollection;    { collection that tracks object instances }
FUNCTION  GetObjectCount : Word64; { total number of object instances }
PROCEDURE IncObjectCount;          { !!! increment count: don't call this manually !!!}
FUNCTION  GetSelfID : Word64;      { return the next free ID for selfID }

TYPE
pIntCollection = ^TIntCollection;
TIntCollection = OBJECT ( TSortedCollection )
  FUNCTION   Compare ( Key1, Key2 : Pointer ) : WinInteger; VIRTUAL;
  FUNCTION   ValueFound ( CONST x : Int64 ) : WinInteger;
  PROCEDURE  DeleteValue ( CONST x : Int64 );
  PROCEDURE  Add ( CONST x : Int64 );
  FUNCTION   InCollection ( CONST x : Int64 ) : Boolean;
  FUNCTION   Integers ( CONST Index : Word64 ) : Int64;
  PROCEDURE  Clear;
END;

VAR
RunningExe : TString;

{$ifdef __xGPC__}
END;
{$else}
IMPLEMENTATION
{$endif}

TYPE
TextFileType = Text;

VAR
LocalCount : Word64;   { actual count of instances }
LastFreed  : Word64;   { last SELFID that was freed }
IDList : pIntCollection;    { collection that tracks object SelfIDs }

PROCEDURE  TIntCollection.Clear;
VAR
i : LongWord;
BEGIN
  IF Count > 0
  THEN BEGIN
     FOR i := Pred ( Count ) DOWNTO 0
     DO BEGIN
         Freemem ( Items^ [i] );
         AtDelete ( i );
     END;
  END;
END;

FUNCTION TIntCollection.Integers ( CONST Index : Word64 ) : Int64;
VAR
p : pInt64;
BEGIN
   // Result := Int64 ( Items^ [Index]^ );
   p := pInt64 ( At ( Index ) );
   Result := p^;
END;

FUNCTION TIntCollection.InCollection ( CONST x : Int64 ) : Boolean;
BEGIN
   Result := ValueFound ( x ) > 0;
END;

PROCEDURE TIntCollection.DeleteValue ( CONST x : Int64 );
VAR
i : WinInteger;
BEGIN
   i := ValueFound ( x );
   IF i < 0 THEN Exit
   ELSE
     IF i > 0
       THEN AtFree ( i ) // FPC doesn't like to "AtFree (0)"
         else AtDelete (i);
End;

Procedure TIntCollection.Add (Const x : Int64);
Var
p : pInt64;
Begin
   If NOT InCollection (x)
   then begin
      {New} Getmem ( p, Sizeof ( Int64 ) );
      p^ := x;
      Insert (p);
   end;
End;

Function TIntCollection.ValueFound ( Const x : Int64 ) : WinInteger;
Begin
  Result := IndexOf ( pInt64 (@x));
End;

function TIntCollection.Compare;// (Key1, Key2: Pointer): WinInteger;
Begin
   If (pInt64 (Key1)^ > pInt64 (Key2)^) then Result := 1
   else
   If (pInt64 (Key1)^ < pInt64 (Key2)^) then Result := -1
   else
   Result := 0
End;

PROCEDURE TObjectCollection.Insert;
Begin
  Inherited Insert ( Item );
End;

PROCEDURE TObjectCollection.FreeItem;
BEGIN
   IF Assigned ( Item ) THEN pClass ( Item ) ^.Done;
END;

PROCEDURE IncObjectCount;
BEGIN
   Inc ( LocalCount );
END;

FUNCTION  GetObjectCount : Word64;
BEGIN
   Result := LocalCount;
END;

FUNCTION  GetSelfID : Word64;
BEGIN
   If IDList^.Count > 0
   then begin
      Result := IDList^.Integers (0);
      IDList^.DeleteValue (Result);
   end
      else Result := LocalCount;
END;
{*************************************}
{*************************************}
PROCEDURE ShowMessage;
BEGIN
 {$ifdef WIN32}
   MessageBox ( GetActiveWindow, sChar ( Msg ), 'Message', 0 );
 {$else}
   Writeln ( Msg );
 {$endif}
END;

PROCEDURE ShowMessageInt;
BEGIN
   ShowMessage ( InttoStr ( Msg ) );
END;

PROCEDURE ShowLastError ( Id : WinInteger );
VAR
p : ARRAY [0..259] OF char;
v : Va_List;
BEGIN
   v := Nil;
 {$ifdef WIN32}
   FormatMessage ( FORMAT_MESSAGE_FROM_SYSTEM, Nil, id, 0, p, 260, v );
   messagebox ( 0, p, 'Last error', 0 );
 {$endif}
END;

FUNCTION  LastError ( Id : WinInteger ) : TString;
VAR
p : ARRAY [0..259] OF char;
v : Va_List;
BEGIN
  Result := '';
 {$ifndef FPC}v := Nil;{$endif}
 {$ifdef WIN32}
   FormatMessage ( FORMAT_MESSAGE_FROM_SYSTEM, Nil, id, 0, p, 260, v );
   pChar2String ( p, Result );
 {$endif}
END;

PROCEDURE ConcatString ( VAR Dest : String; CONST Source : String );
BEGIN
  Insert ( Source, Dest, Succ ( Length ( Dest ) ) );
END;

PROCEDURE PrependString ( CONST Source : String; VAR Dest : String );
BEGIN
  Insert ( Source, Dest, 1 );
END;

Procedure ReplaceString ( Const tOld, TNew : String; Var Dest : String) ;
Var
i : Longint;
begin
   if tOld = tNew then Exit;
   i := Pos ( tOld, Dest );
   While i > 0 do begin
       Delete ( Dest, i, Length ( tOld ) );
       Insert ( TNew, Dest, i );
       i := Pos ( tOld, Dest );
   end;
end;

Function StrPasEx ( p : pChar ) : AnsiString;
Begin
  {$ifdef __GPC__}
  pChar2String ( p, Result );
  {$else}
  Result := StrPas (p);
  {$endif}
End;

FUNCTION StrNewP ( s : String ) : pChar;
BEGIN
  {$ifdef __TMT__}
  s := s + #0;
  Result := StrNew ( @s [1] );
  {$else}
  Result := StrNew ( {$ifndef __GPC__}pChar{$endif} ( s ) );
  {$endif}
END;

{$ifndef __GPC__}
PROCEDURE pChar2String ( p : pchar; VAR Dest : String );
BEGIN
   Dest := Strpas ( p );
END;
{$endif}

Function TStrings2pChar (Var x : TStrings) : pChar;
Var
i, k: Cardinal;
p : pChar;
Begin
  k := x.TStringsLength;
  If k > 0
  then begin
     GetMem (p, Succ (k) + Succ (x.Count));
     Strcopy (p, '');
     for i := x.LoopStart to x.LoopCount
     do begin
        StrCat (p, x.pChars (i));
        StrCat (p, #10);
     end;
     Result := p;
  end else Result := Nil;
End;

PROCEDURE StrpCat ( Dest : pChar; Const Source : string );
BEGIN
    {$ifdef __TMT__}
    Source := Source + #0;
    StrCat ( Dest, @Source [1] );
    {$else}
    StrCat ( Dest, {$ifndef __GPC__}pchar{$endif} ( source ) );
    {$endif}
END;

PROCEDURE ppConcatString ( VAR Dest : String; Source : pChar );
VAR
dl, sl, l : Cardinal;
BEGIN
  dl := Length ( Dest );
  sl := Strlen ( Source );

  {$ifdef __GPC__}
  L := Min ( sL, Dest.Capacity - dL );
  {$else}
  L := sL;
  {$endif}

  {$ifdef __TMT__}
   Dest [0] := Chr ( dL + L );
  {$else}
  SetLength ( Dest, dL + L );
  {$endif}
  Move ( Source [0], Dest [Succ ( dL ) ], L );
END;

{ a quicksort function for string lists }
PROCEDURE QuickSortMyStr ( VAR A : TStrings; CONST aLo, aHi : WinInteger );
PROCEDURE Sort ( l, r : Cardinal );
VAR
  i, j : Cardinal;
  x : pChar;

BEGIN
  i := l;
  j := r;
  x := a.pChars ( ( l + r ) DIV 2 );

  REPEAT

    WHILE ( StrComp ( a.pChars ( i ), x ) < 0 ) DO Inc ( i );

    If j > 1 then
    WHILE (j > 0) and ( StrComp ( x, a.pChars ( j ) ) < 0 )
    DO Dec ( j );

    IF (i <= j) and (j < A.Count)
    THEN BEGIN
       a.exchange ( j, i );
       Inc ( i );
       Dec ( j );
    END;

  UNTIL (j > A.LoopCount) or (i > j);

  IF (l < j) and (j < A.Count)
  THEN BEGIN
     sort ( l, j );
  END;

  IF (i < r) THEN sort ( i, r );

END;

BEGIN { QuicksortMyStr }
  IF ( aHi > 0 ) AND ( aLo >= 0 ) THEN Sort ( aLo, aHi );
END; {* QuicksortMyStr *}


{ --------------------- TBASECLASS object ---------------------------- }
CONSTRUCTOR TBaseClass.Init;
BEGIN
   Inherited Init;
   Name   := 'TBaseClass';
   Tag := 0;
   Handle := 0;
   SelfID := 0;
   Caption := '';
   ParentHandle := 0;
   IsCreated := True;
END; {* TBaseClass.Init *}

DESTRUCTOR  TBaseClass.Done;
BEGIN
   Caption := '';
   SelfID  := 0;
   Handle  := 0;
   ParentHandle := 0;
   Tag := -1;
   Name := '';
   IsCreated := False;
   Inherited Done;
END; {* TBaseClass.Done *}

CONSTRUCTOR TBaseClass.Create;
BEGIN
  Init ( Nil );
END; {* TBaseClass.Create *}

DESTRUCTOR TBaseClass.Destroy;
BEGIN
  Done;
END; {* TBaseClass.Destroy *}

{ --------------------- TCLASS object ---------------------------- }
CONSTRUCTOR TClass.Init;
BEGIN
   Inherited Init ( Owner );
   Name   := 'TClass';
END; {* TClass.Init *}

DESTRUCTOR  TClass.Done;
BEGIN
   // use a free SELFID for the next object that will be created
   If SelfID <> 0 then IDList^.Add ( SelfID );//LastFreed := SelfID;
   Inherited Done;
END; {* TClass.Done *}

{ --------------------- EXCEPTION object ---------------------------- }
{$ifdef __GPC__}
CONSTRUCTOR Exception.Init;
BEGIN
   Inherited Init ( Nil );
   Name := 'Exception';
   ShowMessage ( Message );
END; {* Exception.Init *}

DESTRUCTOR  Exception.Done;
BEGIN
   Inherited Done;
END; {* Exception.Done *}
{$endif}
{ --------------------- TStrings object ---------------------------- }
CONSTRUCTOR TStrings.Init;
BEGIN
  Inherited Init ( Alimit, ADelta );
  Count := 0;
  fDuplicates := dupAccept;
  Sorted := False;
  BufferLength := 0;
END; {* TStrings.Init *}

CONSTRUCTOR TStrings.Create;
BEGIN
  Init ( 2048, 128 );
END; {* TStrings.Create *}

DESTRUCTOR TStrings.Destroy;
BEGIN
   Done;
END; {* TStrings.Destroy *}

DESTRUCTOR TStrings.Done;
BEGIN
   Clear;
   Inherited Done;
END; {* TStrings.Done *}

FUNCTION  TStrings.LoopCount;
BEGIN
  LoopCount := Pred ( Count );
END; {* TStrings.LoopCount *}

FUNCTION  TStrings.LoopStart;
BEGIN
  LoopStart := 0
END; {* TStrings.LoopStart *}

PROCEDURE   TStrings.SetDuplicates ( TheValue : TDuplicates );
BEGIN
   fDuplicates := TheValue;
END; {* TStrings.SetDuplicates *}

PROCEDURE TStrings.AddStrings;
VAR
i, j, k : Cardinal;
BEGIN
   j := NewStrings.Count;
   k := NewStrings.LoopStart;
   IF j < 1 THEN exit;
   FOR i := k TO Pred ( j )
   DO BEGIN
     {$W-}AddP ( NewStrings.pChars ( i ) );{$W+}
   END;
END; {* TStrings.AddStrings *}

FUNCTION TStrings.Add;
VAR
i : Integer;
b : boolean;
p : pChar;
BEGIN
  i := 0;
  IF ( Count >= Limit ) AND ( Delta < 1 ) THEN Dec ( Count ); {don't exceed max}

  p := StrNewP ( s );
  IF ( Sorted ) AND ( fDuplicates <> dupAccept )
  THEN BEGIN
    b := Search ( p, i );
    IF b THEN BEGIN  { return location of existing }
       Add := i;
       StrDispose ( p );
       exit;
    END;
  END;

  IF Sorted
  THEN BEGIN
      Insert ( p );
      Add := Indexof ( p );
  END ELSE BEGIN
      AtInsert ( Count, p );
      Add := Count;
  END;

END; {* TStrings.Add *}

FUNCTION TStrings.AddP;
VAR
i : Integer;
b : boolean;
p : pChar;

BEGIN
  i := 0;
  IF ( Count >= Limit ) AND ( Delta < 1 ) THEN Dec ( Count ); {don't exceed max}

  IF ( Sorted ) AND ( fDuplicates <> dupAccept )
  THEN BEGIN
    b := Search ( s, i );
    IF b THEN BEGIN  { return location of existing }
       Result := i;
       exit;
    END;
  END;

  p := StrNew ( s );

  IF Sorted
  THEN BEGIN
      Insert ( p );
      Result := Indexof ( p );
  END ELSE BEGIN
      AtInsert ( Count, p );
      Result := Count;
  END;

END; {* TStrings.AddP *}

PROCEDURE TStrings.Append;
BEGIN
   {$W-}Add ( s );{$W+}
END; {* TStrings.Append *}

PROCEDURE TStrings.AppendP;
BEGIN
   {$W-}AddP ( s );{$W+}
END; {* TStrings.AppendP *}

PROCEDURE  TStrings.Move ( CurIndex, NewIndex : Cardinal );
VAR
p : pChar;
BEGIN
   p := StrNew ( pChars ( CurIndex ) );
   AtDelete ( CurIndex );
   AtInsert ( NewIndex, p );
END; {* TStrings.Move *}

PROCEDURE TStrings.InsertP;
BEGIN
  IF ( Count >= Limit ) AND ( Delta < 1 ) THEN Dec ( Count );
  AtInsert ( Index, StrNewP ( s ) );
END; {* TStrings.Insert *}

FUNCTION TStrings.Replace;
BEGIN
  Replace := False;
  IF ( WinInteger ( Index ) >= Count ) THEN exit;
  AtPut ( Index, StrNewP ( s ) );
  Replace := True;
END; {* TStrings.Replace *}

PROCEDURE TStrings.Exchange;
VAR
Item1, Item2 : pChar;
BEGIN
  IF  ( Index1 <> Index2 )
  AND ( WinInteger ( Index1 ) < Count )
  AND ( WinInteger ( Index2 ) < Count )
  THEN BEGIN
     Item1 := pChar ( Items^ [Index1] );
     Item2 := pChar ( Items^ [Index2] );
     Items^ [Index1] := Item2;
     Items^ [Index2] := Item1;
  END;
END; {* TStrings.Exchange *}

PROCEDURE TStrings.DeleteP ( Index : Cardinal );
BEGIN
  IF WinInteger ( Index ) < Count THEN {AtFree}AtDelete ( index );
END; {* TStrings.Delete *}

FUNCTION TStrings.IndexOfP ( CONST S : String ) : Integer;
VAR
i : Integer;
BEGIN
  Result := - 1;
  FOR i := 0 TO Pred ( Count ) DO
  IF StrComp ( pchar ( Items^ [i] ), {$ifndef __GPC__}pchar {$endif} ( S ) ) = 0
  THEN BEGIN
    Result := i;
    Exit;
  END;
END;

FUNCTION TStrings.pChars;
BEGIN
     Result := NIL;
     IF ( WinInteger ( index ) < Count ) THEN Result := pChar ( At ( Index ) );
END; {* TStrings.pChars *}

FUNCTION TStrings.Strings;
VAR
p : pchar;
BEGIN
     p := pChars ( index );
     IF p <> NIL THEN pChar2String ( p, Result ) ELSE Result := '';
END; {* TStrings.Strings *}

FUNCTION TStrings.StringLength;
VAR
p : pchar;
BEGIN
     StringLength := - 1;
     p := pChars ( index );
     IF p <> NIL THEN StringLength := strlen ( p );
END; {* TStrings.StringLength *}

FUNCTION TStrings.TStringsLength;
VAR
i : Cardinal;
j : WinInteger;

BEGIN
    Result := 0;
    IF Count = 0 THEN Exit;
    FOR i := LoopStart TO Loopcount
    DO BEGIN
       j := StringLength ( i );
       IF j > 0 THEN Inc ( Result, j );
    END;
END; {* TStrings.TStringsLength *}


PROCEDURE TStrings.Clear;
VAR
i : Cardinal;
BEGIN
  IF Count > 0
  THEN BEGIN
     DeleteAll;
     (*
     FOR i := Pred ( Count ) DOWNTO 0
     DO BEGIN
         {$ifndef __GNU__}try {$endif}
         StrDispose ( pChar ( Items^ [i] ) );
         {$ifndef __GNU__}except end; {$endif}

         {$ifndef __GNU__}try {$endif}
         AtDelete ( i );
         {$ifndef __GNU__}except end; {$endif}
     END;
     *)
     BufferLength := 0;
  END;
END; {* TStrings.Clear *}

PROCEDURE TStrings.Sort;
BEGIN
  IF Count > 0
  THEN BEGIN
     Sorted := True;
     IF Count > 1 THEN QuickSortMyStr ( Self, LoopStart, LoopCount );
  END;
END; {* TStrings.Sort *}

PROCEDURE TStrings.QSort;
BEGIN
 { some safety checks }
  IF ( aLo < LoopStart ) THEN aLo := LoopStart;
  IF ( aHi < LoopStart ) THEN aHi := LoopStart;
  IF ( WinInteger ( aLo ) > LoopCount ) THEN aLo := LoopCount;
  IF ( WinInteger ( aHi ) > LoopCount ) THEN aHi := LoopCount;

  { sort it }
  QuickSortMyStr ( Self, ( aLo ), ( aHi ) );
END; {* TStrings.QSort *}

FUNCTION  TStrings.LoadFromFile;
BEGIN
   Result := ReadFromFile ( FName, True );
END;

(*
function Msys2DosPath (Const s : String): String;
Var
i : Cardinal;
begin
   Result := s;
   {$ifdef __MSYS__}
   if (Result [1] in ['/', '\'])
   and (Upcase (Result[2]) in ['A'..'Z'])
   and (Pos (':', Result) = 0)
   then begin
     delete (Result, 1, 1);
     insert (':', Result, 2);
   end;
   {$endif}
end;
*)

FUNCTION  TStrings.ReadFromFile;
VAR
i : Cardinal;
OurFile : TextFileType;
s : {$ifdef __GPC__}String ( 1024 * 16 ) {$else}AnsiString{$endif};
b : boolean;
j : Integer;
BEGIN
   Result := - 1;
   IF NOT FileExists ( FName ) THEN Exit;
   {$ifdef __GPC__}AssignDOS{$else}Assign{$endif} ( OurFile, FName );
   Reset ( OurFile );
   IF Ioresult <> 0 THEN exit;
   i := 0;
   WHILE NOT Eof ( OurFile )
   DO BEGIN
       Readln ( OurFile, s );
       IF ioresult <> 0
       THEN BEGIN
           Close ( OurFile );
           j := ioresult;
           Exit;
       END;
       b := true;
       IF NOT AllowBlanks THEN b := Trim ( s ) <> '';
       IF b THEN BEGIN
          IF Add ( s ) < 0 THEN Break;
          IF ( Count > Limit ) AND ( Delta < 1 ) THEN Break;
          inc ( i );
       END;
   END;
   Close ( OurFile );
   j := ioresult;
   Result := i;
END;{* TStrings.ReadFromFile *}

FUNCTION  TStrings.SaveToFile;
VAR
i : Cardinal;
j, k : WinInteger;
OurFile : TextFileType;
BEGIN
   SaveToFile := - 2;
   IF Count < 1 THEN exit;
   SaveToFile := - 1;
   Assign ( OurFile, FName );
   Rewrite ( OurFile );
   IF ioresult <> 0 THEN exit;
   j := 0;
   FOR i := LoopStart TO LoopCount
   DO BEGIN
       Writeln ( OurFile, pChars ( i ) );
       IF ioresult <> 0 THEN BEGIN
           Close ( OurFile );
           k := ioresult;
           Exit;
       END;
       Inc ( j );
   END;
   Close ( OurFile );
   k := ioresult;
   SaveToFile := j;
END;{* TStrings.SaveToFile *}

FUNCTION  TStrings.Buffer;
BEGIN
  Result := TStrings2pChar ( Self );
  BufferLength := StrLen ( Result );
END;{* TStrings.Buffer *}

FUNCTION  TStrings.Text;
VAR
i : Cardinal;
BEGIN
    Result := '';
    IF Count = 0 THEN Exit;
    FOR i := LoopStart TO Loopcount
    DO BEGIN
       ppConcatString ( Result, pChars ( i ) );
       ConcatString ( Result, EndOfLineMarker );
    END;
END;{* TStrings.Text *}

PROCEDURE TStrings.ReAssign ( VAR Source, Dest : TStrings );
BEGIN
  Dest.Clear;
  Dest.AddStrings ( Source );
END;{* TStrings.ReAssign *}

FUNCTION TStrings.Find ( CONST S : string; VAR Index : Integer ) : Boolean;
BEGIN
   Result := False;
   Index := IndexOfP ( s );
   IF Index >= 0 // string already exists
   THEN BEGIN
      Result := True;
      Exit;
   END;
   Index := Add ( s ); // TRY TO add, AND get where index should be
   DeleteP ( Index ); // remove it - but we still return where it should be
END; {* TStrings.Find *}

PROCEDURE TStrings.StringToTStrings ( CONST Source : String; VAR Dest : TStrings );
VAR
cp, Cnt, Len : Cardinal;
S : pChar;
BEGIN
   Dest.Clear;
   Len := Length ( Source );
   IF Len = 0 THEN Exit;
   Cnt := 0;
   GetMem ( s, Len + 4 );
   StrCopy ( s, '' );
   WHILE Cnt < Len DO BEGIN
       Inc ( Cnt );
       cp := 0;
       IF ( Source [Cnt] = #13 ) AND ( Source [Cnt + 1] = #10 )
       THEN BEGIN
           Inc ( Cnt, 1 );
           cp := 2;
       END
       ELSE IF ( Source [Cnt] IN [#13, #10] )
       THEN BEGIN
           // Inc ( Cnt );
           cp := 1;
       END;

       IF ( cp = 0 )
       THEN BEGIN
          StrpCat ( s, Source [Cnt] );
          IF Cnt = Len
          THEN BEGIN
             Dest.AddP ( s );
             Strcopy ( s, '' );
          END;
       END
       ELSE BEGIN
           IF ( Cnt = Len ) AND NOT ( Source [Cnt] IN [#13, #10] )
             THEN StrpCat ( s, Source [Cnt] );
           Dest.AddP ( s );
           StrCopy ( s, '' );
       END;

   END; { while }
   FreeMem ( s );
END; {* TStrings.StringToTStrings *}

FUNCTION TStrings.LoadFromString;
BEGIN
  StringToTStrings ( s, Self );
  Result := Count;
END; {* TStrings.LoadFromString *}

FUNCTION TStrings.LoadFromStream ( CONST s : pChar; Separators : oCharset ) : WinInteger;
BEGIN
  Result := TokenisePChar ( s, Self, Separators );
END; {* TStrings.LoadFromStream *}

PROCEDURE TStrings.ToUpperAll;
VAR i : Cardinal;
BEGIN
  IF Count = 0 THEN exit;
  FOR i := LoopStart TO LoopCount DO StrUpper ( pChar ( Items^ [i] ) );
END; {* TStrings.ToupperAll *}

PROCEDURE TStrings.ToLowerAll;
VAR i : Cardinal;
BEGIN
  IF Count = 0 THEN exit;
  FOR i := LoopStart TO LoopCount DO StrLower ( pChar ( Items^ [i] ) );
END; {* TStrings.ToLowerAll *}

PROCEDURE StringToParagraphs ( CONST Source : String; VAR Dest : TStrings );
VAR
cp, Cnt, Len : Cardinal;
S : pChar;
BEGIN
   Dest.Clear;
   Len := Length ( Source );
   IF Len = 0 THEN Exit;
   Cnt := 0;
   GetMem ( s, Len + 4 );
   StrCopy ( s, '' );
   WHILE Cnt < Len DO BEGIN
       Inc ( Cnt );
       cp := 0;
       IF ( Source [Cnt] = #13 ) AND ( Source [Cnt + 1] = #10 )
       THEN BEGIN
           Inc ( Cnt, 2 );
           cp := 2;
       END
       ELSE IF ( Source [Cnt] IN [#13, #10] )
       THEN BEGIN
           Inc ( Cnt );
           cp := 1;
       END;
       IF cp = 0 THEN StrpCat ( s, Source [Cnt] )
       ELSE BEGIN
           IF ( Cnt = Len ) AND NOT ( Source [Cnt] IN [#13, #10] )
             THEN  StrpCat ( s, Source [Cnt] );

           // we don't want empty paragraphs
           If Trim ( strpas ( s ) ) <> '' then Dest.AddP ( s );

           StrCopy ( s, '' );
       END;
   END; { while }
   FreeMem ( s );
END;

FUNCTION TokenisePChar ( p : pChar; VAR T : TStrings; Marker : oCharSet ) : WinInteger;
VAR
s1 : TString;
i : WinInteger;
BEGIN
   T.Clear;
   Result := - 1;
   IF p = Nil THEN Exit;
   s1 := '';
   Result := 0;
   FOR i := 0 TO Pred ( Strlen ( p ) )
   DO BEGIN
       IF ( p [i] IN Marker )
       THEN BEGIN
          Inc ( Result );
          T.Add ( s1 );
          s1 := '';
       END ELSE ConcatString ( s1, p [i] );
   END;

   IF length ( s1 ) > 0 // ( Result = 0 ) AND ( length ( s ) > 0 )
   THEN BEGIN
      Inc ( Result );
      T.Add ( s1 );
   END;
END;

FUNCTION TokeniseString ( Const p : String; VAR T : TStrings; Marker : oCharSet ) : WinInteger;
VAR
s : TString;
BEGIN
  s := p + #0;
  Result := TokenisePChar ( pChar ( @s [1] ), T, Marker );
END;

FUNCTION LastPos ( ch : char; CONST s : string ) : WinInteger;
VAR i : WinInteger;
BEGIN
   result := 0;
   FOR i := length ( s ) DOWNTO 1 DO
    IF s [i] = ch
    THEN BEGIN
       result := i;
       exit;
    END;
END;

{************************************************************}
{$ifdef WIN32}
// generic handler+dispatcher for TThread //
FUNCTION DefaultThreadHandler ( Sender : pThread ) : DWORD; STDCALL;
{$ifdef __GPC__}FORWARD;FUNCTION DefaultThreadHandler ( Sender : pThread ) : DWORD;{$endif}
BEGIN
  Result := 0;
  If Assigned (Sender) then
  With Sender^
  do begin
     If (Not Terminated)
     then begin
       Execute;
       Result := ReturnValue;
     end;
  end;
END;

CONSTRUCTOR TThread.InitHandler;
Var
j : WinInteger;
BEGIN
  Inherited Init (Nil);
  Name := 'TThread';
  Terminated := False;
  Suspended := CreateSuspended;
  ReturnValue := 0;
  ThreadRoutine := aProc;
  Priority := THREAD_PRIORITY_NORMAL;
  If Suspended then j := CREATE_SUSPENDED else j := 0;
  Handle := CreateThread (Nil, 0, ThreadRoutine, @Self, j, ThreadID);
  If Handle = 0 then Done;
END;

CONSTRUCTOR TThread.Init;
BEGIN
  InitHandler ( CreateSuspended, @DefaultThreadHandler);
END;

CONSTRUCTOR TThread.Create;
BEGIN
   Init (CreateSuspended);
END;

DESTRUCTOR  TThread.Done;
BEGIN
   Terminated := True;
   If IsCreated
   then begin
      If Handle <> 0
      then begin
         ExitThread (Handle);
         CloseHandle (Handle);
         ReturnValue := -1;
      end;
      Inherited Done;
   end;
END;

procedure TThread.Terminate;
BEGIN
   Terminated := True;
END;

procedure TThread.Suspend;
BEGIN
   Suspended := True;
   SuspendThread (Handle);
END;

procedure TThread.Resume;
BEGIN
   Suspended := False;
   ResumeThread (Handle);
END;

Procedure TThread.SetPriority;
BEGIN
   Priority := aValue;
   SetThreadPriority (Handle, Priority);
END;

procedure TThread.Execute;
BEGIN
   SetThreadPriority (Handle, Priority);
   ReturnValue := 0;
END;

procedure TThread.Synchronize;
BEGIN
   aMethod (Sender);
END;

procedure TThread.AfterConstruction;
BEGIN
   SetThreadPriority (Handle, Priority);
   Execute;
END;

Constructor TDataPrinter.Init;
Begin
   Inherited Init ( Nil );
   fHandle := CreateFile
             (Port,
             Generic_Write,
             0,
             Nil,
             OPEN_EXISTING,
             FILE_ATTRIBUTE_NORMAL{$ifndef FPC} or FILE_FLAG_WRITE_THROUGH{$endif},
             0);
End;

Constructor TDataPrinter.Create;
Begin
   Init ( 'prn' );
End;

Destructor TDataPrinter.Done;
Begin
   If Active then begin
      CloseHandle (fHandle);
      fHandle := INVALID_HANDLE_VALUE;
   end;
   Inherited Done;
End;

Function TDataPrinter.Active;
Begin
   Result := (fHandle <> INVALID_HANDLE_VALUE);
End;

Function TDataPrinter.Print (Const Data; DataSize : DWord) : DWord;
Begin
   If Active
   then begin
      WriteFile (fHandle, Data, DataSize, Result, Nil);
      FlushFileBuffers (fHandle);
   end;
End;

{$endif}
{*******************************************************}
{$ifdef __GPC__}
 TO BEGIN DO BEGIN
    {$ifdef WIN32}
    Var x : Array [0 ..259] of char;
    FillChar ( x, sizeof ( x ), #0 );
    GetModuleFileName ( 0, x, sizeof ( x ) );
    RunningExe := x;
    setlength (runningexe, strlen (x));
    CmdShow := sw_Normal; { sw_Normal }
    {$else}
    RunningExe := ParamStr ( 0 );
    CmdShow := 1;
    {$endif}
{$else}
 INITIALIZATION
    RunningExe := ParamStr ( 0 );
{$endif}
    LocalCount := 0;
    LastFreed := 0;
    ObjectList := New ( pObjectCollection, Init ( 512, 32 ) );
    IDList := New ( pIntCollection, Init ( 128, 16 ) );
    {$ifdef WIN32}
    CmdShow := sw_Normal; { sw_Normal }
    {$endif}
{$ifdef __GPC__}
 END;
 TO END DO BEGIN
{$else}
 FINALIZATION
{$endif}
    IDList^.Clear;
    Dispose (IDList, Done);
    Dispose (ObjectList);
{$ifdef __GPC__}
 END;
{$endif}
END.

