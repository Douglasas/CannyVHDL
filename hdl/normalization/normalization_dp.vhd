library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;
use work.fifo_pkg.all;

entity normalization_dp is
	port(
		read_i : in std_logic;
		valid_i : in std_logic;
		pix_i : in slogic;

		clk_i : in std_logic;
		rstn_i : in std_logic;

		full_o : out std_logic;
		empty_o : out std_logic;
		pix_o : out slogic
	);
end entity;

architecture arch of normalization_dp is
	signal w_regis_in  : slogic;
  signal w_regis_max : slogic;
  signal w_regis_div : slogic;
  signal w_fifo      : slogic;
	signal w_max_comparison : std_logic;
begin

		u0_regis_in : regis
    port map(
      enable_i => valid_i,
      data_i => pix_i,
      rstn_i => rstn_i,
			clk_i => clk_i,
			data_o => w_regis_in
		);

		u1_regis_max : regis
    port map(
      enable_i => w_max_comparison,
      data_i => w_regis_in,
      rstn_i => rstn_i,
			clk_i => clk_i,
			data_o => w_regis_max
		);

		u2_regis_div : regis
    port map(
      enable_i => '1',
      data_i => w_regis_div,
      rstn_i => rstn_i,
			clk_i => clk_i,
			data_o => pix_o
		);

		u3_fifo : fifo
		generic map(
			FIFO_SIZE => IMAGE_Y * IMAGE_X
		)
		port map(
			data_i  => pix_i,
			write_i => valid_i,
			read_i  => read_i,
			clk_i   => clk_i,
			rstn_i  => rstn_i,
			data_o  => w_fifo,
			full_o  => full_o,
			empty_o => empty_o
		);

		w_max_comparison <= '1' when w_regis_in > w_regis_max else '0';
		w_regis_div <= w_fifo / w_regis_max;

end architecture;
