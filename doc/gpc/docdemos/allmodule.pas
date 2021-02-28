module AllModule interface;

export
  AllInterface = all;  { Same as `AllInterface = (a, b, Bar);' }

var
  a, b: Integer;

procedure Bar (i: Integer);

end.

module AllModule implementation;

procedure Bar (i: Integer);
begin
  b := a
end;

to begin do
  a := 42;

end.
