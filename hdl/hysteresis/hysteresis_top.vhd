LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
LIBRARY work;
use work.slogic_pkg.all;
use work.hysteresis_pkg.all;
use work.slidingwindow_pkg.all;

entity hysteresis_top is
	port(
	-----------input----------
		valid_i	:	in std_logic;
		pix_i		:	in slogic;
	------------sync-------------
		rstn_i 	:	in std_logic;
		clk_i  	:	in std_logic;
	----------out------------
		valid_o	:	out std_logic;
		pix_o		:	out slogic

	);
end hysteresis_top;

architecture arc of hysteresis_top is
	constant WEAK		:	slogic := to_slogic(75); -- 01C0 0000 = 7
	constant STRONG	:	slogic := to_slogic(255); -- 0300 0000? = 12  --- 018A 1F00? = 30

	signal window_data_w       : slogic_window (WINDOW_X -1 downto 0 , WINDOW_Y -1 downto 0);
	signal strong_neighbours_w : std_logic;

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
  -----------OR gigante ---------------------
  strong_neighbours_w <= '1' when window_data_w (0,0) = STRONG else
							           '1' when window_data_w (0,1) = STRONG else
							           '1' when window_data_w (0,2) = STRONG else
							           '1' when window_data_w (1,0) = STRONG else
							           '1' when window_data_w (1,2) = STRONG else
							           '1' when window_data_w (2,0) = STRONG else
							           '1' when window_data_w (2,1) = STRONG else
							           '1' when window_data_w (2,2) = STRONG else
							           '0';

  pix_o <= STRONG when window_data_w (1,1) = STRONG else
           STRONG when window_data_w (1,1) = WEAK and strong_neighbours_w = '1' else
           (others => '0');
end arc;
