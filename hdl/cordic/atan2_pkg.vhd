library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.slogic_pkg.all;

package atan2_pkg is
  ------ constants ------
  constant ANGLES_TABLE_SIZE : integer := 20; -- also (cycles-2)
  ------ functions ------
  function gen_angles_table(SIZE : integer) return slogic_vec;
  
  component atan2
  port (
    -- inputs
    numx_i  : in slogic;
    numy_i  : in slogic;
    -- sync
    enable_i : in std_logic;
    clk_i    : in std_logic;
	 rstn_i	 :	in	std_logic;
    -- outputs
    angle_o  : out slogic
  );
  end component atan2;
  
end package;

package body atan2_pkg is

  function gen_angles_table(SIZE : integer) return slogic_vec is
    variable angles_table_v : slogic_vec(SIZE-1 downto 0);
    variable num_v : real;
  begin
    num_v := 1.0;
    for i in 0 to SIZE-1 loop
      angles_table_v(i) := to_slogic(arctan(num_v) * 180.0 / MATH_PI);
      num_v := num_v / 2.0;
    end loop;
    return angles_table_v;
  end function;

end atan2_pkg;
