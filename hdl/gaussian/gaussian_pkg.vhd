library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.slogic_pkg.all;

package gaussian_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X : integer := 5;
	constant IMAGE_Y : integer := 5;
	----------constant----------------
	constant GAUS: slogic_window := (
		(x"00400000", x"00400000", x"00400000"),
		(x"00400000", x"00400000", x"00400000"),
		(x"00400000", x"00400000", x"00400000")
	);
  ------------function-----------------------

function sum_reduct(semi_result_i : slogic_window) return slogic;

component gaussian_top
	port(
		------------input------------
		valid_i : in std_logic;
		pix_i   : in slogic;
		------------sync-------------
		rstn_i : in scomponent gaussian_top
	port(
		------------input------------
		valid_i : in std_logic;
		pix_i   : in slogic;
		------------sync-------------
		rstn_i : in std_logic;
		clk_i  : in std_logic;
		----------output-------------
		valid_o : out std_logic;
		pix_o   : out slogic
	);
end component gaussian_top;td_logic;
		clk_i  : in std_logic;
		----------output-------------
		valid_o : out std_logic;
		pix_o   : out slogic
	);
end component gaussian_top;

end gaussian_pkg;

package body gaussian_pkg is 
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

end gaussian_pkg;
