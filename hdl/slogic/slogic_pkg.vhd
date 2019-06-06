library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package slogic_package is

  ---------------- Size Constants -------------
  constant MSB : integer := 10;
  constant LSB : integer := 22;

  --------------------- Type declaration --------------------
  subtype slogic is std_logic_vector(MSB+LSB-1 downto 0);

  -------------------- Functions -----------------
  function "*" (A : slogic; B : slogic) return slogic;
  function "+" (A : slogic; B : slogic) return slogic;
  function to_slogic(I : integer) return slogic;

  ----------------- Constants -------------
  constant S_MAXVALUE : slogic := '0' & (MSB+LSB-2 downto 0 => '1');
  constant S_MINVALUE : slogic := '1' & (MSB+LSB-2 downto 0 => '0');
  signal test : signed(2*(MSB+LSB)-1 downto 0);

end slogic_package;

package body slogic_package is
  ------------------------------------slogic operations---------------------------------
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

  ---- converts integer without decimal part to slogic
  function to_slogic (I : integer) return slogic is
  begin
    return slogic(shift_left(to_signed(I, MSB+LSB), LSB));
  end function;

end slogic_package;
