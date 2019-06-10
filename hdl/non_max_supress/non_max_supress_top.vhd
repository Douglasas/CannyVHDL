library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.non_max_supress_pkg.all;
use work.slogic_pkg.all;


entity non_max_supress_top is
port(
	clk_i : in std_logic;
	rstn_i : in std_logic;
	valid_i : in std_logic;
	pix_norm_i : in slogic;
	pix_theta_i : in slogic;
	
	valid_o : out std_logic;
	data_o : out slogic
);
end entity;

architecture arch of non_max_supress_top is

	signal valid_norm_w, valid_theta_w, multiplex_q_w	: std_logic;
	signal and_select_w : boolean;
	signal multiplex_pi_out_w, pix_center_theta_w, exit_multiplex_r_w, exit_multiplex_q_w : slogic;
	signal window_data_norm_w, window_data_theta_w : slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0);
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
		pix_i => multiplex_pi_out_w,
		rstn_i => rstn_i,
		clk_i => clk_i,
		valid_o => valid_theta_w,
		window_o  => window_data_theta_w
	);


	pix_center_theta_w <= window_data_theta_w(1,1);
	valid_o <= valid_norm_w and valid_theta_w;
	
	
	-- Multiplex Pi
	
	multiplex_pi_out_w <= pix_theta_i when pix_theta_i(31) = '0' else
								 pix_center_theta_w + to_slogic(3.14159);
	
	--
	
	
	-- Decoder
	
	exit_decoder_w <= "00" when ((pix_center_theta_w >= to_slogic(0) and pix_center_theta_w < to_slogic(0.3926991)) or
										(pix_center_theta_w >= to_slogic(2.7488936) and pix_center_theta_w < to_slogic(3.14159))) else
							"01" when (pix_center_theta_w >= to_slogic(0.3926991) and pix_center_theta_w < to_slogic(1.178097)) else
							"10" when (pix_center_theta_w >= to_slogic(1.178097) and pix_center_theta_w < to_slogic(1.9634954)) else 
							"11";
	
	-----------
	
	-- Multiplex Q
	
	exit_multiplex_q_w <= window_data_norm_w(1,2) when exit_decoder_w = "00" else
								 window_data_norm_w(2,0) when exit_decoder_w = "01" else
								 window_data_norm_w(2,1) when exit_decoder_w = "10" else
								 window_data_norm_w(0,0);
	
	---
	
	-- Multiplex R
	
	exit_multiplex_r_w <= window_data_norm_w(1,0) when exit_decoder_w = "00" else
								 window_data_norm_w(0,2) when exit_decoder_w = "01" else
								 window_data_norm_w(0,1) when exit_decoder_w = "10" else
								 window_data_norm_w(2,2);
	
	---
	
	-- Seletor AND
	
	and_select_w <= (exit_multiplex_q_w >= window_data_norm_w(1,1)) and (exit_multiplex_r_w >= window_data_norm_w(1,1));
	
	--
	
	-- Multiplex 2x1 saida
	
	data_o <= window_data_norm_w(1,1) when and_select_w = true else
				 x"00000000";
	
	--
	

end arch;