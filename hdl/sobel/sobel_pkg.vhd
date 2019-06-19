library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;

package sobel_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X : integer := INPUT_IMAGE_X-2;
	constant IMAGE_Y : integer := INPUT_IMAGE_Y-2;
  ------------function-----------------------
  function sum_reduct(semi_result_i : slogic_window) return slogic;

  component sobel_top
    port (
      valid_i : in  std_logic;
      pix_i   : in  slogic;
      rstn_i  : in  std_logic;
      clk_i   : in  std_logic;
      valid_o : out std_logic;
      x_pix_o : out slogic;
      y_pix_o : out slogic
    );
  end component sobel_top;
end sobel_pkg;

package body sobel_pkg is
		function sum_reduct(semi_result_i: slogic_window ) return slogic is
		variable res_v : slogic;

begin
  res_v := (others => '0' );
		for i in semi_result_i'range loop
			for j in semi_result_i'range loop
				res_v := res_v + semi_result_i(i,j);
			end loop;
		end loop;
		return res_v;
	end function;

end sobel_pkg;
