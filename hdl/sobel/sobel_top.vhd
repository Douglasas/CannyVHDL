LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.sobel_pkg.all;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity sobel_top is
	port(
	------------input------------
		valid_i_x : in std_logic;
		pix_i_x : in slogic;
		------------sync-------------
		rstn_i : in std_logic;
		clk_i  : in std_logic;
		----------output----------
		valid_o : out std_logic;
		x_pix_o: out slogic;
		y_pix_o: out slogic
	);
end sobel_top;

architecture arc of sobel_top is
	signal window_data_w_x : slogic_window (WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal semi_result_w_x : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal semi_result_w_y : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	
begin
		slidingwindow_top_i : slidingwindow_top
		  generic map (
			IMAGE_X  => IMAGE_X,
			IMAGE_Y  => IMAGE_Y,
			WINDOW_X => WINDOW_X,
			WINDOW_Y => WINDOW_Y
		  )
		  port map (
			valid_i  => valid_i_x,
			pix_i  => pix_i_x,
			rstn_i   => rstn_i,
			clk_i    => clk_i,
			valid_o  => valid_o,
			window_o => window_data_w_x
		  );
	  
	g_GENERATE_FOR_i: for i in 0 to WINDOW_X-1 generate
		g_GENERATE_FOR_j: for j in 0 to WINDOW_Y-1 generate
			semi_result_w_x(i,j) <= window_data_w_x(i,j) * sobel_x(i,j);
			semi_result_w_y(i,j) <= window_data_w_x(i,j) * sobel_y(i,j);
	 end generate g_GENERATE_FOR_j;
  end generate g_GENERATE_FOR_i;
  
  x_pix_o <= sum_reduct(semi_result_w_x);
  y_pix_o <= sum_reduct(semi_result_w_y);

end arc;