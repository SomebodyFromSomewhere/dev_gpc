program TrapsOfTypeCastsDemo;

{ Declare a real type and an integer type of the same size, and some
  variables of these types we will need. }

type
  RealType = ShortReal;
  IntegerType = Integer (BitSizeOf (RealType));

var
  i, i1, i2, i3, i4, i5: IntegerType;
  r, r1, r2, r3, r4: RealType;

begin

  { First part: Casting integer into real types. }

  { Start with some integer value }
  i := 42;

  { First attempt to cast. Here, an lvalue is casted, so this must
    be a variable type cast. Therefore, the bit pattern of the value
    of i is transferred unchanged into r1 which results in a silly
    value of r1. }
  IntegerType (r1) := i;

  { Second try. Here we cast an expression -- though a trivial one --,
    rather than a variable. So this can only be a value type cast.
    Therefore, the numeric value is preserved, i.e. r2 = 42.0 . }
  r2 := RealType (i + 0);

  { Third way. In this last example, a variable is casted, and the
    result is used as an expression, not as an lvalue. So this
    could be either a value or variable type cast. However, there
    is a rule that value type casting is preferred if possible.
    So r3 will contain the correct numeric value, too. }
  r3 := RealType (i);

  { Of course, you do not need any casts at all here. A simple
    assignment will work because of the automatic conversion from
    integer to real types. So r4 will also get the correct result. }
  r4 := i;

  { Now the more difficult part: Casting real into integer types. }

  { Start with some real value. }
  r := 41.9;

  { Like the first attempt above, this one does a variable type cast,
    preserving bit patterns, and leaving a silly value in i1. }
  { RealType (i1) := r; }

  { The second try from above does not work, because an expression of
    type real is to be casted into an integer which is not allowed. }
  { i2 := IntegerType (r + 0); }

  { Third way. This looks just like the third way in the first part
    which was a value type cast.
    But -- surprise! Since value type casting is not possible from
    real into integer, this really does a variable type casting,
    and the value of i3 is silly again! This difference in behaviour
    shows some of the hidden traps in type casting. }
  i3 := IntegerType (r);

  { As often, it is possible to avoid type casts altogether and
    convert real types into integers easily by other means, i.e. by
    using the built-in functions ``Round'' or ``Trunc'', depending
    on the mode of rounding one wants. }
  i4 := Round (r); { 42 }
  i5 := Trunc (r); { 41 }

end.
