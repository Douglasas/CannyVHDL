LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.roberts_pkg.all;
use work.slidingwindow_pkg.all;

entity roberts_top is
	port(
	------------input------------
		valid_i : in std_logic;
		pix_i : in slogic;
		------------sync-------------
		rstn_i : in std_logic;
		clk_i  : in std_logic;
		----------output----------
		valid_o : out std_logic;
		x_pix_o : out slogic;
		y_pix_o : out slogic
	);
end roberts_top;

architecture arch of roberts_top is

  signal valid_w       : std_logic;
	signal window_data_w : slogic_window (WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_mult_x_w : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_mult_y_w : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal semi_result_x_w : slogic_vec (WINDOW_Y * WINDOW_X-1 downto 0);
	signal semi_result_y_w : slogic_vec (WINDOW_Y * WINDOW_X-1 downto 0);

begin
	slidingwindow_top_i : slidingwindow_top
  generic map (
		IMAGE_X  => IMAGE_X,
		IMAGE_Y  => IMAGE_Y,
		WINDOW_X => WINDOW_X,
		WINDOW_Y => WINDOW_Y
  )
  port map (
		valid_i  => valid_i,
		pix_i    => pix_i,
		rstn_i   => rstn_i,
		clk_i    => clk_i,
		valid_o  => valid_w,
		window_o => window_data_w
  );
  valid_o <= valid_w;

	window_mult_x_w(0,0) <= window_data_w(0,0);
  window_mult_x_w(0,1) <= to_slogic(0);
  window_mult_x_w(1,0) <= to_slogic(0);
  window_mult_x_w(1,1) <= -window_data_w(1,1);

  window_mult_y_w(0,0) <= to_slogic(0);
  window_mult_y_w(0,1) <= window_data_w(0,1);
  window_mult_y_w(1,0) <= -window_data_w(1,0);
  window_mult_y_w(1,1) <= to_slogic(0);

  g_GENERATE_FOR_i: for i in 0 to WINDOW_X-1 generate
	  g_GENERATE_FOR_j: for j in 0 to WINDOW_Y-1 generate
      semi_result_x_w( i*WINDOW_Y + j ) <= window_mult_x_w(i,j);
      semi_result_y_w( i*WINDOW_Y + j ) <= window_mult_y_w(i,j);
    end generate g_GENERATE_FOR_j;
  end generate g_GENERATE_FOR_i;

  x_pix_o <= sum_reduce(semi_result_x_w, WINDOW_Y * WINDOW_X);
  y_pix_o <= sum_reduce(semi_result_y_w, WINDOW_Y * WINDOW_X);

end arch;
