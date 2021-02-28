{
  A graphical clock that uses the Graph unit
}
PROGRAM GrClock;
{$X+}
{#apptype gui} { needs to be compiled as a GUI application under GPC }

USES
Dos,
Graph;

{import "Beep" from the Win32 API }
FUNCTION Beep ( Freq, Duration : Word ) : BOOLEAN;
{$ifdef __GPC__}
external name 'Beep'; attribute (stdcall);
{$else}
BEGIN
   WRITE ( #7 );
END;
{$endif}

VAR
   i, Gd, Gm, x, y, r : integer;
   angle4, angle, angle1, angle2, angle3 : integer;
   rad4, rad3, rad, rad1, rad2 : real;
   temp,
   h,
   m,
   s,
   hund : word;
   mi,
   se,
   ho,
   d, NumtoStr : string [255];

BEGIN
     gd := Detect;
     initgraph ( Gd, Gd, '' );
     setbkcolor ( 6 );
     x := 300; y := 250;  { x and y of the center of the circle }
     r := 150;          { radius of the circle }
     circle ( x, y, r );   { draw a circle }
     circle ( x, y, r + 20 ); { draw a circle }

     FOR i := 1 TO 149
     DO BEGIN
       setcolor ( 5 );
       circle ( x, y, i )
     END;

     FOR i := 1 TO 19
     DO BEGIN
        setcolor ( 12 );
        circle ( x, y, r + i );
     END;

     FOR i := 1 TO 12 DO  { draw the lines of the hours }
     BEGIN
        angle3 := i * 30 - 90;   { draw the numbers }
        rad3 := angle3 * pi / 180;
        line ( round ( cos ( rad3 ) * r + x ), round ( sin ( rad3 ) * r + y ), round ( cos ( rad3 ) * ( r + 20 ) + x ), round ( sin ( rad3 ) * ( r + 20 ) + y ) );
        IF i < 10
        THEN BEGIN
           moveto ( round ( cos ( rad3 ) * ( r + 35 ) + x ), round ( sin ( rad3 ) * ( r + 35 ) + y ) );
           Str ( I, d );
           NumToStr := d;
           outtext ( NumToStr )
        END
        ELSE BEGIN
           moveto ( round ( cos ( rad3 ) * ( r + 44 ) + x ), round ( sin ( rad3 ) * ( r + 44 ) + y ) );
           Str ( I, d );
           NumToStr := d;
           outtext ( NumToStr );
        END;
     END;


     setcolor ( 0 );
     FOR i := 1 TO 60
     DO BEGIN
         IF ( i MOD 5 = 0 )
         THEN BEGIN
            angle4 := i * 6 - 90;
            rad4 := angle4 * pi / 180;
            line ( round ( cos ( rad4 ) * ( r ) + x ), round ( sin ( rad4 ) * r + y ), round ( cos ( rad4 ) * ( r + 20 ) + x ), round ( sin ( rad4 ) * ( r + 20 ) + y ) );
         END
         ELSE BEGIN
            angle4 := i * 6 - 90;
            rad4 := angle4 * pi / 180;
            line ( round ( cos ( rad4 ) * ( r ) + x ), round ( sin ( rad4 ) * r + y ), round ( cos ( rad4 ) * ( r + 10 ) + x ), round ( sin ( rad4 ) * ( r + 10 ) + y ) );
         END;
     END;
     setcolor ( 1 );

     REPEAT
      gettime ( h, m, s, hund ); { get the currect time }
      IF temp <> s
      THEN BEGIN
         setcolor ( 5 );
         line ( x, y, round ( cos ( rad ) * ( r - 10 ) + x ), round ( sin ( rad ) * ( r - 10 ) + y ) ); { draw seconds }
         line ( x, y, round ( cos ( rad1 ) * ( r - 30 ) + x ), round ( sin ( rad1 ) * ( r - 30 ) + y ) ); { draw hours }
         line ( x, y, round ( cos ( rad2 ) * ( r - 15 ) + x ), round ( sin ( rad2 ) * ( r - 15 ) + y ) ); { draw minutes }
         setcolor ( 0 );
         moveto ( 0, 0 );   { delete digital clock }
         outtext ( ho );
         outtext ( ':' );
         outtext ( mi );
         outtext ( ':' );
         outtext ( '0' );
         outtext ( se );
         moveto ( 0, 0 );   { delete digital clock }
         outtext ( ho );
         outtext ( ':' );
         outtext ( mi );
         outtext ( ':' );
         outtext ( se );
         angle := 6 * s - 90;  { angle of seconds }
         angle1 := 30 * h + ( m div 15 ) - 90;  { angle of hours }
         angle2 := m * 6 - 90;    { angle of minutes }
         Rad := angle * pi / 180;  { angle to radians }
         Rad1 := angle1 * pi / 180 ; { angle to radians }
         Rad2 := angle2 * pi / 180;   { angle to radians }
         setcolor ( 14 );
         line ( x, y, round ( cos ( rad ) * ( r - 10 ) + x ), round ( sin ( rad ) * ( r - 10 ) + y ) ); { draw seconds }
         line ( x, y, round ( cos ( rad1 ) * ( r - 30 ) + x ), round ( sin ( rad1 ) * ( r - 30 ) + y ) ); { draw hours }
         line ( x, y, round ( cos ( rad2 ) * ( r - 15 ) + x ), round ( sin ( rad2 ) * ( r - 15 ) + y ) ); { draw minutes }
         moveto ( 0, 0 );   { digital clock }
         str ( m, mi );
         str ( s, se );
         str ( h, ho );
         IF s < 10
         THEN BEGIN
           outtext ( ho );
           outtext ( ':' );
           outtext ( mi );
           outtext ( ':' );
           outtext ( '0' );
           outtext ( se );
         END
         ELSE BEGIN
           outtext ( ho );
           outtext ( ':' );
           outtext ( mi );
           outtext ( ':' );
           outtext ( se );
         END;
         temp := s;
         Beep ( 500, 1 );
      END;
    UNTIL keypressed; { draw the clock till key pressed }
    closegraph;
END.

