{A demo with some interesting algoritms, and for Graph.

The sources for this game was found on a site that claims to only have
PD stuff with the below header(which was only reindented), and the webmaster
said that everything he published was sent to him with that purpose. We tried
to contact the authors mentioned below via mail over internet, but that
failed. If there is somebody that claims authorship of these programs,
please mail marco@freepascal.org, and the sources will be removed from our
websites.

------------------------------------------------------------------------

ORIGINAL Header:

created by Randy Ding July 16,1983   <April 21,1992>

Very small FPC fixes by Marco van de Voort (EgaHi to vgahi), and tried
setting the maze dimensions maxx and maxy to a bigger size.
Won't work, you'll have to update all vars to al least word to increase the
complexity of the grid further. I didn't do it, since 200x200 is already
unreadable to me.
}

PROGRAM maze;
{$X+}
{#apptype console}  { for GPC we need both "-mconsole" and "-mwindows" }
{#apptype gui}      { ----- ditto ----- }

USES
 {$ifdef win32}
  WinCrt,
  Windows,
 {$else}
  crt,
 {$endif}
  graph;

CONST
  screenwidth   = 640;
  screenheight  = 480;
  minblockwidth = 2;
  maxx = 200;   { BP: [3 * maxx * maxy] must be less than 65520 (memory segment) }
                { FPC: Normally no problem. ( even if you'd use 1600x1200x3< 6MB)}
  maxy = 200;   { here maxx/maxy about equil to screenwidth/screenheight }
  flistsize = maxx * maxy DIV 2; { flist size (fnum max, about 1/3 of maxx * maxy) }

  background = black;
  gridcolor  = green;
  solvecolor = white;

  rightdir = $01;
  updir    = $02;
  leftdir  = $04;
  downdir  = $08;

  unused   = $00;    { cell types used as flag bits }
  frontier = $10;
{  reserved = $20; }
  tree     = $30;


TYPE
  frec = RECORD
          column, row : byte;
         END;
  farr = ARRAY [1..flistsize] OF frec;

  cellrec = RECORD
              point : word;  { pointer to flist record }
              flags : byte;
            END;
  cellarr = ARRAY [1..maxx, 1..maxy] OF cellrec;

  {
    one byte per cell, flag bits...

    0: right, 1 = barrier removed
    1: top    "
    2: left   "
    3: bottom "
    5,4: 0,0 = unused cell type
         0,1 = frontier "
         1,1 = tree     "
         1,0 = reserved "
    6: (not used)
    7: solve path, 1 = this cell part of solve path
  }


VAR
  flist     : farr;         { list of frontier cells in random order }
  cell      : ^cellarr;      { pointers and flags, on heap }
  fnum,
  width,
  height,
  blockwidth,
  halfblock,
  maxrun    : word;
  runset    : byte;
  ch        : char;

PROCEDURE initbgi;
VAR
  grdriver,
  grmode,
  errcode : integer;
BEGIN
  grdriver := vga;
  grmode   := vgahi;
  initgraph ( grdriver, grmode, 'd:\pp\bp\bgi' );
  errcode := graphresult;
  IF errcode <> grok THEN
  BEGIN
    CloseGraph;
    writeln ( 'Graphics error: ', grapherrormsg ( errcode ) );
    halt ( 1 );
  END;
END;


FUNCTION adjust ( VAR x, y : word; d : byte ) : boolean;
BEGIN                              { take x,y to next cell in direction d }
  CASE d OF                        { returns false if new x,y is off grid }
    rightdir :
    BEGIN
      inc ( x );
      adjust := x <= width;
    END;

    updir :
    BEGIN
      dec ( y );
      adjust := y > 0;
    END;

    leftdir :
    BEGIN
      dec ( x );
      adjust := x > 0;
    END;

    downdir :
    BEGIN
      inc ( y );
      adjust := y <= height;
    END;
  END;
END;


PROCEDURE remove ( x, y : word );      { remove a frontier cell from flist }
VAR
  i : word; { done by moving last entry in flist into it's place }
BEGIN
  i := cell^ [x, y].point;          { old pointer }
  WITH flist [fnum] DO
    cell^ [column, row].point := i;   { move pointer }
  flist [i] := flist [fnum];        { move data }
  dec ( fnum );                    { one less to worry about }
END;


PROCEDURE add ( x, y : word; d : byte );  { add a frontier cell to flist }
VAR
  i : byte;
BEGIN
  i := cell^ [x, y].flags;
  CASE i AND $30 OF   { check cell type }
    unused :
    BEGIN
      cell^ [x, y].flags := i OR frontier;  { change to frontier cell }
      inc ( fnum );                        { have one more to worry about }
      IF fnum > flistsize THEN
      BEGIN     { flist overflow error! }
        dispose ( cell );  { clean up memory }
        closegraph;
        writeln ( 'flist overflow! - To correct, increase "flistsize"' );
        WRITE ( 'hit return to halt program ' );
        readln;
        halt ( 1 );        { exit program }
      END;
      WITH flist [fnum] DO
      BEGIN    { copy data into last entry of flist }
        column := x;
        row    := y;
      END;
      cell^ [x, y].point := fnum; { make the pointer point to the new cell }
      runset := runset OR d;   { indicate that a cell in direction d was }
    END;                      {    added to the flist }

    frontier : runset := runset OR d;     { allready in flist }
  END;
END;


PROCEDURE addfront ( x, y : word );    { change all unused cells around this }
VAR                              {    base cell to frontier cells }
  j, k : word;
  d    : byte;
BEGIN
  remove ( x, y );       { first remove base cell from flist, it is now }
  runset := 0;         {    part of the tree }
  cell^ [x, y].flags := cell^ [x, y].flags OR tree;   { change to tree cell }
  d := $01;            { look in all four directions- $01,$02,$04,$08 }
  WHILE d <= $08 DO
  BEGIN
    j := x;
    k := y;
    IF adjust ( j, k, d ) THEN
      add ( j, k, d );  { add only if still in bounds }
    d := d SHL 1;    { try next direction }
  END;
END;


PROCEDURE remline ( x, y : word; d : byte );  { erase line connecting two blocks }
BEGIN
  setcolor ( background );
  x := ( x - 1 ) * blockwidth;
  y := ( y - 1 ) * blockwidth;
  CASE d OF
    rightdir : line ( x + blockwidth, y + 1, x + blockwidth, y + blockwidth - 1 );
    updir    : line ( x + 1, y, x + blockwidth - 1, y );
    leftdir  : line ( x, y + 1, x, y + blockwidth - 1 );
    downdir  : line ( x + 1, y + blockwidth, x + blockwidth - 1, y + blockwidth );
  END;
END;


{ erase line and update flags to indicate the barrier has been removed }
PROCEDURE rembar ( x, y : word; d : byte );
VAR
  d2 : byte;
BEGIN
  remline ( x, y, d );       { erase line }
  cell^ [x, y].flags := cell^ [x, y].flags OR d; { show barrier removed dir. d }
  d2 := d SHL 2;  { shift left twice to reverse direction }
  IF d2 > $08 THEN
    d2 := d2 SHR 4;  { wrap around }
  IF adjust ( x, y, d ) THEN  { do again from adjacent cell back to base cell }
    cell^ [x, y].flags := cell^ [x, y].flags OR d2;    { skip if out of bounds }
END;


FUNCTION randomdir : byte;  { get a random direction }
BEGIN
  CASE random ( 4 ) OF
    0 : randomdir := rightdir;
    1 : randomdir := updir;
    2 : randomdir := leftdir;
    3 : randomdir := downdir;
  END;
END;


PROCEDURE connect ( x, y : word );    { connect this new branch to the tree }
VAR                             {    in a random direction }
  j, k  : word;
  d     : byte;
  found : boolean;
BEGIN
  found := false;
  WHILE NOT found DO
  BEGIN { loop until we find a tree cell to connect to }
    j := x;
    k := y;
    d := randomdir;
    IF adjust ( j, k, d ) THEN
      found := cell^ [j, k].flags AND $30 = tree;
  END;
  rembar ( x, y, d );   { remove barrier connecting the cells }
END;


PROCEDURE branch ( x, y : word );  { make a new branch of the tree }
VAR
  runnum : word;
  d      : byte;
BEGIN
  runnum := maxrun;      { max number of tree cells to add to a branch }
  connect ( x, y );        { first connect frontier cell to the tree }
  addfront ( x, y );       { convert neighboring unused cells to frontier }
  dec ( runnum );         { number of tree cells left to add to this branch }
  WHILE ( runnum > 0 ) AND ( fnum > 0 ) AND ( runset > 0 ) DO
  BEGIN
    REPEAT
      d := randomdir;
    UNTIL d AND runset > 0;  { pick random direction to known frontier }
    rembar ( x, y, d );          {    and make it part of the tree }
    adjust ( x, y, d );
    addfront ( x, y );      { then pick up the neighboring frontier cells }
    dec ( runnum );
  END;
END;


PROCEDURE drawmaze;
VAR
  x, y, i : word;
BEGIN
  setcolor ( gridcolor );    { draw the grid }
  y := height * blockwidth;
  FOR i := 0 TO width DO
  BEGIN
    x := i * blockwidth;
    line ( x, 0, x, y );
  END;
  x := width * blockwidth;
  FOR i := 0 TO height DO
  BEGIN
    y := i * blockwidth;
    line ( 0, y, x, y );
  END;
  fillchar ( cell^, sizeof ( cell^ ), chr ( 0 ) );    { zero flags }
  fnum   := 0;   { number of frontier cells in flist }
  runset := 0; { directions to known frontier cells from a base cell }
  randomize;
  x := random ( width ) + 1;   { pick random start cell }
  y := random ( height ) + 1;
  add ( x, y, rightdir );       { direction ignored }
  addfront ( x, y );      { start with 1 tree cell and some frontier cells }
  WHILE ( fnum > 0 ) DO
  WITH flist [random ( fnum ) + 1] DO
    branch ( column, row );
END;

PROCEDURE dot ( x, y, colr : word );
BEGIN
  putpixel ( blockwidth * x - halfblock, blockwidth * y - halfblock, colr );
END;

PROCEDURE solve ( x, y, endx, endy : word );
VAR
  j, k : word;
  d    : byte;
BEGIN
  d := rightdir;  { starting from left side of maze going right }
  WHILE ( x <> endx ) OR ( y <> endy ) DO
  BEGIN
    IF d = $01 THEN
      d := $08
    ELSE
      d := d SHR 1; { look right, hug right wall }
    WHILE cell^ [x, y].flags AND d = 0 DO
    BEGIN { look for an opening }
      d := d SHL 1;                            { if no opening, turn left }
      IF d > $08 THEN
        d := d SHR 4;
    END;
    j := x;
    k := y;
    adjust ( x, y, d );         { go in that direction }
    WITH cell^ [j, k] DO
    BEGIN    { turn on dot, off if we were here before }
      flags := ( ( ( ( cell^ [x, y].flags XOR $80 ) XOR flags ) AND $80 ) XOR flags );
      IF flags AND $80 <> 0 THEN
        dot ( j, k, solvecolor )
      ELSE
        dot ( j, k, background );
    END;
  END;
  dot ( endx, endy, solvecolor );    { dot last cell on }
END;

PROCEDURE mansolve ( x, y, endx, endy : word );
VAR
  j, k : word;
  d    : byte;
  ch   : char;
BEGIN
  ch := ' ';
  WHILE ( ( x <> endx ) OR ( y <> endy ) ) AND ( ch <> 'X' ) AND ( ch <> #27 ) DO
  BEGIN
    dot ( x, y, solvecolor );    { dot man on, show where we are in maze }
    ch := upcase ( readkey );
    dot ( x, y, background );    { dot man off after keypress }
    d := 0;
    CASE ch OF
      #0 :
      BEGIN
        ch := readkey;
        CASE ch OF
          #72 : d := updir;
          #75 : d := leftdir;
          #77 : d := rightdir;
          #80 : d := downdir;
        END;
      END;

      'I' : d := updir;
      'J' : d := leftdir;
      'K' : d := rightdir;
      'M' : d := downdir;
    END;

    IF d > 0 THEN
    BEGIN
      j := x;
      k := y;    { move if no wall and still in bounds }
      IF ( cell^ [x, y].flags AND d > 0 ) AND adjust ( j, k, d ) THEN
      BEGIN
        x := j;
        y := k;
      END;
    END;
  END;
END;

PROCEDURE solvemaze;
VAR
  x, y,
  endx,
  endy : word;
BEGIN
  x := 1;                         { pick random start on left side wall }
  y := random ( height ) + 1;
  endx := width;                  { pick random end on right side wall }
  endy := random ( height ) + 1;
  remline ( x, y, leftdir );         { show start and end by erasing line }
  remline ( endx, endy, rightdir );
  mansolve ( x, y, endx, endy );      { try it manually }
  solve ( x, y, endx, endy );         { show how when he gives up }
  WHILE keypressed DO
   readkey;
  readkey;
END;


PROCEDURE getsize;
VAR
  j, k : real;
BEGIN
 {$ifndef win32}
  clrscr;
 {$endif}
  writeln ( '       Mind' );
  writeln ( '       Over' );
  writeln ( '       Maze' );
  writeln;
  writeln ( '   by Randy Ding' );
  writeln;
  writeln ( 'Use I,J,K,M or arrow keys to walk thru maze,' );
  writeln ( 'then hit X when you give up!' );
  REPEAT
    writeln;
    WRITE ( 'Maze size: ', minblockwidth, ' (hard) .. 95 (easy); (0=Quit) ' );
    readln ( blockwidth );
    IF (Blockwidth = 0) OR (Blockwidth > 95) THEN Halt;

  UNTIL ( blockwidth >= minblockwidth ) AND ( blockwidth < 96 );
  writeln;
  WRITE ( 'Maximum branch length: 1 easy .. 50 harder, (0 unlimited) ' );
  readln ( maxrun );
  IF maxrun <= 0 THEN
    maxrun := 65535;  { infinite }
  j := {Real} ( screenwidth ) / blockwidth;
  k := {Real} ( screenheight ) / blockwidth;
  IF j = int ( j ) THEN
    j := j - 1;
  IF k = int ( k ) THEN
    k := k - 1;
  width  := trunc ( j );
  height := trunc ( k );
  IF ( width > maxx ) OR ( height > maxy ) THEN
  BEGIN
    width  := maxx;
    height := maxy;
  END;
  halfblock := blockwidth div 2;
END;

BEGIN
 {$ifdef win32}
  ShowWindow ( GetActiveWindow, 0 );
  Initbgi;
 {$endif}
  REPEAT
    getsize;
    {$ifndef win32}
     initbgi;
    {$endif}
    new ( cell );    { allocate this large array on heap }
    drawmaze;
    solvemaze;
    dispose ( cell );
    {$ifndef win32}
     closegraph;
    {$endif}
    WHILE keypressed DO
      ch := readkey;
    WRITE ( 'another one? ' );
    ch := upcase ( readkey );
  UNTIL ( ch = 'N' ) OR ( ch = #27 );
  {$ifdef win32}
   CloseGraph;
  {$endif}
END.

