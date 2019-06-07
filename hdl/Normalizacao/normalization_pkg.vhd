library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

package normalization_pkg is
	component fsm
	port(
		clk_i : in std_logic;
		rstn_i : in std_logic;
		full_i : in std_logic;
		empty_i : in std_logic;	
		read_o : out std_logic;
		valid_o : out std_logic
	);	
	end component;

	component datapath
	port(
		clk_i : in std_logic;
		rstn_i : in std_logic;
		read_i : in std_logic;
		valid_i : in std_logic;
		pix_i : in slogic;
		full_o : out std_logic;
		empty_o : out std_logic;
		pix_o : out slogic
	);
	end component;
end normalization_pkg;
