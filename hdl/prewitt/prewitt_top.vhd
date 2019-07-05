LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.prewitt_pkg.all;
use work.slidingwindow_pkg.all;

entity prewitt_top is
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
end prewitt_top;

architecture arc of prewitt_top is

	signal window_data_w   : slogic_window(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_comp_x_w : slogic_window(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal window_comp_y_w : slogic_window(WINDOW_Y-1 downto 0, WINDOW_X-1 downto 0);
	signal semi_result_x_w : slogic_vec(15 downto 0);
	signal semi_result_y_w : slogic_vec(15 downto 0);

  constant PREWITT_KERNEL_X: slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0) := (
		(to_slogic(-1), to_slogic(0), to_slogic(1)),
		(to_slogic(-1), to_slogic(0), to_slogic(1)),
		(to_slogic(-1), to_slogic(0), to_slogic(1))
	);
	constant PREWITT_KERNEL_Y: slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0) := (
		(to_slogic(-1), to_slogic(-1), to_slogic(-1)),
		(to_slogic(0), to_slogic(0), to_slogic(0)),
		(to_slogic(1), to_slogic(1), to_slogic(1))
	);

  signal valid_w : std_logic;
  signal x_pix_w : slogic;
  signal y_pix_w : slogic;

  signal valid_r : std_logic;
  signal x_pix_r : slogic;
  signal y_pix_r : slogic;

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

	-- g_GENERATE_FOR_i: for i in 0 to WINDOW_X-1 generate
  --   g_GENERATE_FOR_j: for j in 0 to WINDOW_Y-1 generate
  --     g_COMP_X : if j = 0 generate
  --       window_comp_x_w(i,j) <= to_slogic(-1)*window_data_w(i,j);
  --     elsif j = WINDOW_X-1 generate
  --       window_comp_x_w(i,j) <= window_data_w(i,j);
  --     else generate
  --       window_comp_x_w(i,j) <= (others => '0');
  --     end generate;
  --
  --
  --     g_COMP_Y : if i = 0 generate
  --       window_comp_y_w(i,j) <= to_slogic(-1)*window_data_w(i,j);
  --     elsif i = WINDOW_Y-1 generate
  --       window_comp_y_w(i,j) <= window_data_w(i,j);
  --     else generate
  --       window_comp_y_w(i,j) <= (others => '0');
  --     end generate;
  --
  --     semi_result_x_w( i*WINDOW_Y + j ) <= window_comp_x_w(i,j);
  --     semi_result_y_w( i*WINDOW_Y + j ) <= window_comp_y_w(i,j);
  --
  --   end generate g_GENERATE_FOR_j;
  -- end generate g_GENERATE_FOR_i;

  g_GENERATE_FOR_i: for i in 0 to WINDOW_X-1 generate
		g_GENERATE_FOR_j: for j in 0 to WINDOW_Y-1 generate
			window_comp_x_w(i,j) <= window_data_w(i,j) * PREWITT_KERNEL_X(i,j);
			window_comp_y_w(i,j) <= window_data_w(i,j) * PREWITT_KERNEL_Y(i,j);
      semi_result_x_w( i*WINDOW_Y + j ) <= window_comp_x_w(i,j);
      semi_result_y_w( i*WINDOW_Y + j ) <= window_comp_y_w(i,j);
	 end generate g_GENERATE_FOR_j;
  end generate g_GENERATE_FOR_i;

  semi_result_x_w(15 downto WINDOW_Y*WINDOW_X) <= (others => to_slogic(0));
  semi_result_y_w(15 downto WINDOW_Y*WINDOW_X) <= (others => to_slogic(0));

  x_pix_w <= sum_reduce(semi_result_x_w, 16);
  y_pix_w <= sum_reduce(semi_result_y_w, 16);

  p_OUT : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      valid_r <= '0';
    elsif rising_edge(clk_i) then
      valid_r <= valid_w;
      x_pix_r <= x_pix_w;
      y_pix_r <= y_pix_w;
    end if;
  end process;

  valid_o <= valid_r;
  x_pix_o <= x_pix_r;
  y_pix_o <= y_pix_r;

end arc;
