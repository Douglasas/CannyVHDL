library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;

entity top is
port(
	clk_i : in std_logic;
	rstn_i : in std_logic;
	valid_i : in std_logic;
	pix_i : in slogic;
	valid_o : out std_logic;
	pix_o : out slogic
);	
end entity;

architecture arch of top is

	signal w_full, w_empty, w_read : std_logic;

	begin

	u0_fsm : fsm port map(
		clk_i => clk_i,
		rstn_i => rstn_i,
		full_i => w_full,
		empty_i => w_empty,
		read_o => w_read,
		valid_o => valid_o
	);
	
	u1_dp : datapath port map(
		clk_i => clk_i,
		rstn_i => rstn_i,
		read_i => w_read,
		valid_i => valid_i,
		pix_i => pix_i,
		full_o => w_full,
		empty_o => w_empty,
		pix_o => pix_o
	);

end arch;