LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.slogic_pkg.all;
use work.gaussian_pkg.all;
use work.slidingwindow_pkg.all;

entity gaussian_top is
	port(
		------------input------------
		valid_i : in std_logic;
		pix_i   : in slogic;
		------------sync-------------
		rstn_i : in std_logic;
		clk_i  : in std_logic;
		----------output-------------
		valid_o : out std_logic;
		pix_o   : out slogic
	);
end gaussian_top;

architecture arc of gaussian_top is

  ----------constant----------------
	constant GAUS: slogic_window (WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0) := gen_gauss_kernel(WINDOW_X);

	signal window_data_w : slogic_window(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_mult_w : slogic_window(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);

  signal sw_valid_w : std_logic;

  signal d_valid_r : std_logic;

  signal semi_result_w         : slogic_vec(15 downto 0);
	signal partial_semi_result_w : slogic_vec(7 downto 0);

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
		valid_o  => sw_valid_w,
		window_o => window_data_w
	  );

  g_GENERATE_FOR_i: for i in 0 to WINDOW_Y-1 generate
    g_GENERATE_FOR_j: for j in 0 to WINDOW_X-1 generate
			window_mult_w(i,j) <= window_data_w(i,j) * GAUS(i,j);
      semi_result_w( i*WINDOW_Y + j ) <= window_mult_w(i,j);
    end generate;
  end generate;
	semi_result_w( 15 downto WINDOW_Y * WINDOW_X ) <= (others => to_slogic(0));

  p_PARTIAL_SUM : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      d_valid_r <= '0';
    elsif rising_edge(clk_i) then
      d_valid_r <= sw_valid_w;
      partial_semi_result_w <= partial_sum_reduce(semi_result_w, 16, 8);
    end if;
  end process;

  valid_o <= d_valid_r;
	pix_o <= sum_reduce(partial_semi_result_w, 8);

end arc;
