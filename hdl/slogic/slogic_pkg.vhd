library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package slogic_pkg is

  ---------------- Size Constants -------------
  constant MSB : integer := 10;
  constant LSB : integer := 22;

  --------------------- Type declaration --------------------
  subtype slogic is std_logic_vector(MSB+LSB-1 downto 0);
  type slogic_vec is array(natural range <>) of slogic;
  type slogic_window is array(natural range <>, natural range <>) of slogic;

  -------------------- Functions -----------------
  function to_slogic(I : integer) return slogic;
  function "*" (A : slogic; B : slogic) return slogic;
  function "+" (A : slogic; B : slogic) return slogic;
  function sum_reduce(A : slogic_vec; SIZE : integer) return slogic;

  ----------------- Constants -------------
  constant S_MAXVALUE : slogic := '0' & (MSB+LSB-2 downto 0 => '1');
  constant S_MINVALUE : slogic := '1' & (MSB+LSB-2 downto 0 => '0');
  signal test : signed(2*(MSB+LSB)-1 downto 0);

end slogic_pkg;

package body slogic_pkg is
  ------------------------------------slogic operations---------------------------------

  ---- converts integer without decimal part to slogic
  function to_slogic (I : integer) return slogic is
  begin
    return slogic(shift_left(to_signed(I, MSB+LSB), LSB));
  end function;

  ---- performs a fixed point multiplication
  function "*" (A : slogic; B : slogic) return slogic is
    variable v_MULT    : signed(2*(MSB+LSB)-1 downto 0) := (others => '0');
    variable v_RESULT  : signed(MSB+LSB-1 downto 0);
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
    -- if (std_logic_vector(v_MULT(LSB-1 downto 0)) >= '1' & (LSB-2 downto 0 => '0')) then
    --   v_RESULT := resize(shift_right(v_MULT, LSB) + 1, MSB+LSB);
    --   return slogic(v_RESULT);
    -- end if;
    v_RESULT := resize(shift_right(v_MULT, LSB), MSB+LSB);
    return slogic(v_RESULT);
  end function;


  function "+" (A : slogic; B : slogic) return slogic is
    variable v_SUM : std_logic_vector(MSB+LSB downto 0);
  begin
    v_SUM := std_logic_vector( resize(unsigned(A), MSB+LSB+1) + resize(unsigned(B), MSB+LSB+1) );

    -- check overflow
    -- if signed(v_SUM) > resize(signed(S_MAXVALUE), 2*(MSB+LSB)) then
    --   return S_MAXVALUE;
    -- end if;
    -- -- check underflow
    -- if signed(v_SUM) < resize(signed(S_MINVALUE), 2*(MSB+LSB)) then
    --   return S_MINVALUE;
    -- end if;
    return slogic(resize(signed(v_SUM), MSB+LSB));
  end function;

  -- make a parallel implementation of add_reduce for slogic --- SIZE must be multiple of 2
  function sum_reduce(A : slogic_vec; SIZE : integer) return slogic is
    variable acc : slogic := (others => '0');
	 --type t_LAYERS is array() of slogic_vector();
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

end slogic_pkg;
