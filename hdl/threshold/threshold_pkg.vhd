library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;

package threshold_pkg is

	component threshold_top is
		port(
		-----------input----------
			valid_i	: 	in	std_logic;
			pix_i		:	in slogic;
		------------sync-------------
			rstn_i : in std_logic;
			clk_i  : in std_logic;
		----------out------------
			valid_o	:	out std_logic;
			pix_o		:	out slogic

		);
	end component threshold_top;

end threshold_pkg;
