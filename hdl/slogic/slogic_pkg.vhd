library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package slogic_pkg is

  ---------------- Size Constants -------------
  constant MSB : integer := 10;
  constant LSB : integer := 14;

  --------------------- Type declaration --------------------
  subtype slogic is std_logic_vector(MSB+LSB-1 downto 0);
  type slogic_vec is array(natural range <>) of slogic;
  type slogic_window is array(natural range <>, natural range <>) of slogic;

  -------------------- Functions -----------------
  function to_slogic(I : integer) return slogic;
  function to_slogic(R : real) return slogic; -- not for execution
  function "*" (A : slogic; B : slogic) return slogic;
  function "/" (A : slogic; B : slogic) return slogic;
  function "+" (A : slogic; B : slogic) return slogic;
  function "-" (A : slogic; B : slogic) return slogic;
  function "-" (A : slogic) return slogic;
  function absolute (A : slogic) return slogic;
  function shift_left (A : slogic; QT : integer) return slogic;
  function shift_right (A : slogic; QT : integer) return slogic;
  function "<" (A : slogic; B : slogic) return boolean;
  function "<=" (A : slogic; B : slogic) return boolean;
  function ">" (A : slogic; B : slogic) return boolean;
  function ">=" (A : slogic; B : slogic) return boolean;
  function or_reduce(A : slogic_vec) return slogic;
  function sum_reduce(A : slogic_vec; SIZE : integer) return slogic;
  function partial_sum_reduce(A : slogic_vec; SIZE : integer; STOP_POINT : integer) return slogic_vec;

  ----------------- Constants -------------
  constant S_MAXVALUE : slogic := (MSB+LSB-1 => '0', others => '1');
  constant S_MINVALUE : slogic := (MSB+LSB-1 => '1', others => '0');

end slogic_pkg;

package body slogic_pkg is
  ------------------------------------slogic operations---------------------------------

  ---- converts integer without decimal part to slogic
  function to_slogic (I : integer) return slogic is
  begin
    return slogic(shift_left(to_signed(I, MSB+LSB), LSB));
  end function;

  ---- converts real number to slogic
  function to_slogic(R : real) return slogic is
  begin
    return slogic(to_signed(integer(round(R * (2.0**LSB))), MSB+LSB));
  end function;

  ---- performs a fixed point multiplication
  function "*" (A : slogic; B : slogic) return slogic is
    variable v_MULT    : signed(2*(MSB+LSB)-1 downto 0);
    variable v_RESULT  : signed(2*(MSB+LSB)-1 downto 0);
  begin
    v_MULT := signed(A) * signed(B);

    -- check overflow
    -- if shift_right(v_MULT, LSB) > resize(signed(S_MAXVALUE), 2*MSB+LSB) then
    --   return S_MAXVALUE;
    -- end if;
    --
    -- -- check underflow
    -- if shift_right(v_MULT, LSB) < resize(signed(S_MINVALUE), 2*MSB+LSB) then
    --   return S_MINVALUE;
    -- end if;

    -- round value

    -- if v_MULT(LSB-1) = '1' then
    --   v_RESULT := v_RESULT + 1 * 2**LSB;
    -- end if;
    v_RESULT := shift_right(v_MULT, LSB);
    return slogic(resize(v_RESULT, MSB+LSB));
  end function;

  function "+" (A : slogic; B : slogic) return slogic is
    variable v_SUM : signed(MSB+LSB downto 0);
  begin
    return slogic(signed(A)+signed(B));
    --v_SUM := resize(signed(A), MSB+LSB+1) + resize(signed(B), MSB+LSB+1);

    -- check overflow
    -- if signed(v_SUM) > resize(signed(S_MAXVALUE), 2*(MSB+LSB)) then
    --   return S_MAXVALUE;
    -- end if;
    -- -- check underflow
    -- if signed(v_SUM) < resize(signed(S_MINVALUE), 2*(MSB+LSB)) then
    --   return S_MINVALUE;
    -- end if;
    --return slogic(resize(v_SUM, MSB+LSB));
  end function;

  function "-" (A : slogic; B : slogic) return slogic is
    variable v_SUB : signed(MSB+LSB downto 0);
  begin
    v_SUB := resize(signed(A), MSB+LSB+1) - resize(signed(B), MSB+LSB+1);
    return slogic(resize(v_SUB, MSB+LSB));
  end function;

  function "-" (A : slogic) return slogic is
  begin
    return slogic(-signed(A));
  end function;

  function absolute (A : slogic) return slogic is
  begin
    return slogic(abs(signed(A)));
  end function;

  function shift_left (A : slogic; QT : integer) return slogic is
  begin
    return slogic(shift_left(signed(A), QT));
  end function;

  function shift_right (A : slogic; QT : integer) return slogic is
  begin
    return slogic(shift_right(signed(A), QT));
  end function;

  function "/" (A : slogic; B : slogic) return slogic is
    variable v_RES : signed(MSB+2*LSB-1 downto 0);
  begin
    v_RES := shift_left(resize(signed(A), MSB+2*LSB), LSB) / resize(signed(B), MSB+2*LSB);

    -- check overflow
    -- if signed(v_SUM) > resize(signed(S_MAXVALUE), 2*(MSB+LSB)) then
    --   return S_MAXVALUE;
    -- end if;
    -- -- check underflow
    -- if signed(v_SUM) < resize(signed(S_MINVALUE), 2*(MSB+LSB)) then
    --   return S_MINVALUE;
    -- end if;
    return slogic(resize(v_RES, MSB+LSB));
  end function;

  function "<" (A : slogic; B : slogic) return boolean is
  begin
    return (signed(A) < signed(B));
  end function;

  function "<=" (A : slogic; B : slogic) return boolean is
  begin
    return (signed(A) <= signed(B));
  end function;

  function ">" (A : slogic; B : slogic) return boolean is
  begin
    return (signed(A) > signed(B));
  end function;

  function ">=" (A : slogic; B : slogic) return boolean is
  begin
    return (signed(A) >= signed(B));
  end function;

  -- make the implementation of or_reduce for slogic
  function or_reduce(A : slogic_vec) return slogic is
    variable acc : slogic := (others => '0');
  begin
    for i in A'range loop
      acc := acc or A(i);
    end loop;
    return acc;
  end function;

  -- make a parallel implementation of add_reduce for slogic --- SIZE must be multiple of 2
  function sum_reduce(A : slogic_vec; SIZE : integer) return slogic is
    variable result : slogic_vec(SIZE/2-1 downto 0);
  begin
    if SIZE = 1 then
      return A(0);
    else
      for i in 0 to SIZE/2-1 loop
        result(i) := A(2*i) + A(2*i+1);
      end loop;
      return sum_reduce(result, SIZE/2);
    end if;
  end function;

  -- make a partial parallel implementation of add_reduce for slogic
  function partial_sum_reduce(A : slogic_vec; SIZE : integer; STOP_POINT : integer) return slogic_vec is
    variable result : slogic_vec(SIZE/2-1 downto 0);
  begin
    if SIZE = STOP_POINT then
      return A;
    else
      for i in 0 to SIZE/2-1 loop
        result(i) := A(2*i) + A(2*i+1);
      end loop;
      return partial_sum_reduce(result, SIZE/2, STOP_POINT);
    end if;
  end function;

end slogic_pkg;
