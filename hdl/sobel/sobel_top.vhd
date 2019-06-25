LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.sobel_pkg.all;
use work.slidingwindow_pkg.all;

entity sobel_top is
	port(
	------------input------------
		valid_i : in std_logic;
		pix_i : in slogic;
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

  constant SOBEL_KERNEL_X: slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0) := (
		(to_slogic(-1), to_slogic(0), to_slogic(1)),
		(to_slogic(-2), to_slogic(0), to_slogic(2)),
		(to_slogic(-1), to_slogic(0), to_slogic(1))
	);
	constant SOBEL_KERNEL_Y: slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0) := (
		(to_slogic(1), to_slogic(2), to_slogic(1)),
		(to_slogic(0), to_slogic(0), to_slogic(0)),
		(to_slogic(-1), to_slogic(-2), to_slogic(-1))
	);

	signal window_data_w : slogic_window (WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_mult_x_w : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_mult_y_w : slogic_window	(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal semi_result_x_w : slogic_vec (WINDOW_Y * WINDOW_X downto 0);
	signal semi_result_y_w : slogic_vec (WINDOW_Y * WINDOW_X downto 0);

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
			valid_o  => valid_o,
			window_o => window_data_w
	  );

	g_GENERATE_FOR_i: for i in 0 to WINDOW_X-1 generate
		g_GENERATE_FOR_j: for j in 0 to WINDOW_Y-1 generate
			window_mult_x_w(i,j) <= window_data_w(i,j) * SOBEL_KERNEL_X(i,j);
			window_mult_y_w(i,j) <= window_data_w(i,j) * SOBEL_KERNEL_Y(i,j);
      semi_result_x_w( i*WINDOW_Y + j ) <= window_mult_x_w(i,j);
      semi_result_y_w( i*WINDOW_Y + j ) <= window_mult_y_w(i,j);
	 end generate g_GENERATE_FOR_j;
  end generate g_GENERATE_FOR_i;
  semi_result_x_w(WINDOW_Y*WINDOW_X) <= to_slogic(0);
  semi_result_y_w(WINDOW_Y*WINDOW_X) <= to_slogic(0);

  x_pix_o <= sum_reduce(semi_result_x_w, WINDOW_Y * WINDOW_X + 1);
  y_pix_o <= sum_reduce(semi_result_y_w, WINDOW_Y * WINDOW_X + 1);

end arc;
