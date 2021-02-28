{
 Simple program to test timing functions
}
PROGRAM testtime;

USES
Timing;
{#fast-mode} // tO the Dev+GNU Pascal IDE, this means cut out the stuff and get on with it

PROCEDURE WasteTime;
CONST Max = 50000000;
VAR
J, K : Integer;
X, R : Extended;
BEGIN
  X := 3.74943543234;
  R := 0.999999;
  FOR K := 1 TO 5 DO
   FOR J := 1  TO Max DO X := X * R;
END;

VAR
Time0, Time1 : TimingLong;
Time01, Time11 : Double;

BEGIN
  Writeln;
  Writeln ( '***** Long integer *****' );
  Time0 := GetTimingMicroSecond; // start
  Writeln ( 'Start=', Time0 );

  WasteTime;
  Time1 := GetTimingMicroSecond; // stop

  Writeln ( 'Stop=', Time1 );
  Writeln ( 'Elapsed=', Time1 - Time0, ' microseconds' );

  Writeln;
  Writeln ( '***** Floating point *****' );
  Time01 := FGetTimingMicroSecond; // start
  Writeln ( 'Start=', Time01 );

  WasteTime;
  Time11 := FGetTimingMicroSecond; // stop

  Writeln ( 'Stop=', Time11 );
  Writeln ( 'Elapsed=', Time11 - Time01 : 0 : 12, ' microseconds' );

  Writeln;
  WRITE ( 'Press ENTER to close ... ' );
  Readln;
END.

