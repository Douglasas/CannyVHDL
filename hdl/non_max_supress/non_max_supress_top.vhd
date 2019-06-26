library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;
use work.non_max_supress_pkg.all;

entity non_max_supress_top is
port(
	valid_i : in std_logic;
	pix_norm_i : in slogic;
	pix_theta_i : in slogic;

  rstn_i : in std_logic;
  clk_i : in std_logic;

	valid_o : out std_logic;
	pix_o   : out slogic
);
end entity;

architecture arch of non_max_supress_top is

	signal valid_norm_w  : std_logic;
  signal valid_theta_w : std_logic;

  signal pix_center_theta_w : slogic;
  signal exit_multiplex_r_w : slogic;
  signal exit_multiplex_q_w : slogic;

	signal window_data_norm_w  : slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0);
  signal window_data_theta_w : slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0);

	signal exit_decoder_w : std_logic_vector(1 downto 0);

	begin

	slidingwindow_norm : slidingwindow_top
	generic map(
		IMAGE_X  =>	IMAGE_X,
		IMAGE_Y  => IMAGE_Y,
		WINDOW_X	=> WINDOW_X,
		WINDOW_Y => WINDOW_Y
	)
	port map(
		valid_i => valid_i,
		pix_i => pix_norm_i,
		rstn_i => rstn_i,
		clk_i => clk_i,
		valid_o => valid_norm_w,
		window_o => window_data_norm_w
	);

	slidingwindow_theta : slidingwindow_top
	generic map(
		IMAGE_X  =>	IMAGE_X,
		IMAGE_Y  => IMAGE_Y,
		WINDOW_X	=> WINDOW_X,
		WINDOW_Y => WINDOW_Y
	)
	port map(
		valid_i => valid_i,
		pix_i => pix_theta_i,
		rstn_i => rstn_i,
		clk_i => clk_i,
		valid_o => valid_theta_w,
		window_o  => window_data_theta_w
	);

  valid_o <= valid_norm_w and valid_theta_w;
  -- Multiplex Negative number
  pix_center_theta_w <= window_data_theta_w(1,1) when window_data_theta_w(1,1)(MSB+LSB-1) = '0' else
                        window_data_theta_w(1,1) + to_slogic(180);

  -- Decoder
	exit_decoder_w <= "00" when ((pix_center_theta_w >= to_slogic(0) and pix_center_theta_w < to_slogic(22.5)) or
										          (pix_center_theta_w >= to_slogic(157.5) and pix_center_theta_w < to_slogic(180))) else
							      "01" when (pix_center_theta_w >= to_slogic(22.5) and pix_center_theta_w < to_slogic(67.5)) else
							      "10" when (pix_center_theta_w >= to_slogic(67.5) and pix_center_theta_w < to_slogic(112.5)) else
							      "11";

	-- Multiplex Q
	exit_multiplex_q_w <= window_data_norm_w(1,2) when exit_decoder_w = "00" else
								        window_data_norm_w(2,0) when exit_decoder_w = "01" else
								        window_data_norm_w(2,1) when exit_decoder_w = "10" else
								        window_data_norm_w(0,0);

	-- Multiplex R
	exit_multiplex_r_w <= window_data_norm_w(1,0) when exit_decoder_w = "00" else
								        window_data_norm_w(0,2) when exit_decoder_w = "01" else
								        window_data_norm_w(0,1) when exit_decoder_w = "10" else
								        window_data_norm_w(2,2);

-- Multiplex 2x1 saida
	pix_o <= window_data_norm_w(1,1) when
            window_data_norm_w(1,1) >= exit_multiplex_q_w
          and
            window_data_norm_w(1,1) >= exit_multiplex_r_w
          else (others => '0');

end arch;
