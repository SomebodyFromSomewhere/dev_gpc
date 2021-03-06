{ GPC demo program for true packed records and arrays, even of
  variable size.

  Copyright (C) 1999-2006 Free Software Foundation, Inc.

  Author: Frank Heckenbach <frank@pascal.gnu.de>

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation, version 2.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; see the file COPYING. If not, write to
  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

  As a special exception, if you incorporate even large parts of the
  code of this demo program into another program with substantially
  different functionality, this does not cause the other program to
  be covered by the GNU General Public License. This exception does
  not however invalidate any other reasons why it might be covered
  by the GNU General Public License. }

program PackingDemo;

var
  n: Integer;
  r: packed record
       Foo: Boolean;    { 1 bit  }
       Bar: (No, Yes);  { 1 bit  }
       Baz: 0 .. 3;     { 2 bits }
       Qux: -1 .. 0;    { 1 bit  }
       Fred: 1 .. 7     { 3 bits }
     end;

begin
  WriteLn ('The packed record r, consisting of a Boolean, an enumeration type and');
  WriteLn ('3 integer subranges occupies only ', SizeOf (r), ' byte in memory.');
  WriteLn;
  repeat
    Write ('Now the size of a packed array of Booleans. How many Booleans? ');
    ReadLn (n)
  until n > 0;
  var a: packed array [1 .. n] of Boolean;
  WriteLn ('A packed array of ', n, ' Booleans occupies ', SizeOf (a), ' byte(s) in memory.')
end.
