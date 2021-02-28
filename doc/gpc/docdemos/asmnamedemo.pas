program AsmnameDemo;

{ Make two variables aliases of each other by using `asmname'.
  This is not good style. If you must have aliases for any reason,
  `absolute' declaration may be the lesser evil ... }
var
  Foo: Integer; asmname 'Foo_Bar';
  Bar: Integer; asmname 'Foo_Bar';

{ A function from the C library }
function PutS (Str: CString): Integer; asmname 'puts'; external;

var
  Result: Integer;
begin
  Result := PutS ('Hello World!');
  WriteLn ('puts wrote ', Result, ' characters (including a newline).');
  Foo := 42;
  WriteLn ('Foo = ', Foo);
  Bar := 17;
  WriteLn ('Setting Bar to 17.');
  WriteLn ('Now, Foo = ', Foo, '!!!')
end.
