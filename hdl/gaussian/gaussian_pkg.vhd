library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.slogic_pkg.all;

package gaussian_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 5;
	constant WINDOW_Y : integer := 5;
	constant IMAGE_X : integer := 220;
	constant IMAGE_Y : integer := 220;

  ------------function-----------------------
  function gen_gauss_kernel(SIZE : integer; SIGMA : integer := 1) return slogic_window;
  -- function sum_reduct(semi_result_i : slogic_window) return slogic;

  component gaussian_top
    port (
      valid_i : in  std_logic;
      pix_i   : in  slogic;
      rstn_i  : in  std_logic;
      clk_i   : in  std_logic;
      valid_o : out std_logic;
      pix_o   : out slogic
    );
  end component gaussian_top;

end gaussian_pkg;

package body gaussian_pkg is

  function gen_gauss_kernel(SIZE : integer; SIGMA : integer := 1) return slogic_window is
    constant normal : real := 1.0 / (2.0 * MATH_PI * (real(SIGMA) ** 2));
    variable gauss_kernel : slogic_window(SIZE-1 downto 0, SIZE-1 downto 0);
    type real_window is array(SIZE-1 downto 0, SIZE-1 downto 0) of real;
    variable real_gauss_kernel : real_window;
    variable size_v : integer;
    variable x : real;
    variable y : real;
    variable g : real_window;
  begin
    size_v := integer(floor(real(SIZE) / 2.0));
    for i in 0 to SIZE-1 loop
      for j in 0 to SIZE-1 loop
        x := real(i - size_v);
        y := real(j - size_v);
        g(i,j) := exp(-((x ** 2 + y ** 2) / (2.0 * (real(SIGMA) ** 2.0) ))) * normal;
        report "gauss[" & integer'image(i) & ", " & integer'image(j) & "] = " & real'image(g(i,j));
        gauss_kernel(i,j) := to_slogic(g(i,j));
      end loop;
    end loop;
    return gauss_kernel;
  end function;

	-- function sum_reduct(semi_result_i: slogic_window ) return slogic is
	--    variable res_v : slogic;
  -- begin
  --   res_v := (others => '0' );
  -- 	for i in semi_result_i'range loop
  -- 		for j in semi_result_i'range loop
  -- 			res_v := res_v + semi_result_i(i,j);
  -- 		end loop;
  -- 	end loop;
  -- 	return res_v;
  -- end function;

end gaussian_pkg;
