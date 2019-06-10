library ieee;
use ieee.std_logic_1164.all;
library work;
use work.slogic_pkg.all;

package hysteresis_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X 	: integer := 5;
	constant IMAGE_Y 	: integer := 5;
	----------constant----------------
	constant WAEK		:	slogic  := x"018A1F00"; -- 01C0 0000 = 7 
	constant STRONG	:	slogic := x"03000000"; -- 0300 0000? = 12  --- 018A 1F00? = 30

	component hysteresis_top is
		port(
		-----------input----------
			valid_i	: in	std_logic;
			pix_i		:	in slogic;
		------------sync-------------
			rstn_i : in std_logic;
			clk_i  : in std_logic;
		----------out------------
			valid_o	:	out std_logic;
			pix_o		:	out slogic
		
		);
	end component hysteresis_top;

end hysteresis_pkg;
