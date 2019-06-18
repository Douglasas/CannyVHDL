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
	signal window_data_w					: 	slogic_window (WINDOW_X -1 downto 0 , WINDOW_Y -1 downto 0);
	signal center_pix_w					:	slogic;
	signal weak_result_w					:	std_logic;
	signal strong_result_w				: 	std_logic;
	signal control_mutplex_strong_w	:	std_logic;
	signal mutplex_strong_result_w	:	slogic;
	signal mutplex_result_o_w			:	slogic;

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

	  ------------Verifica se o centro e igual a weak---------------
	  center_pix_w <= window_data_w (1,1);
	  weak_result_w <= 	'1' when center_pix_w = WAEK else
								'0' when center_pix_w /= WAEK else
								'0';

	  -----------OR gigante ---------------------
	  strong_result_w <= '1' when window_data_w (0,0) = STRONG else
								'1' when window_data_w (0,1) = STRONG else
								'1' when window_data_w (0,2) = STRONG else
								'1' when window_data_w (1,0) = STRONG else
								'1' when window_data_w (1,2) = STRONG else
								'1' when window_data_w (2,0) = STRONG else
								'1' when window_data_w (2,1) = STRONG else
								'1' when window_data_w (2,2) = STRONG else
								'0';


	  control_mutplex_strong_w <= weak_result_w and strong_result_w;

	  process (control_mutplex_strong_w)
			begin
				case control_mutplex_strong_w is
						when '0' => mutplex_strong_result_w <= x"00000000";
						when '1' => mutplex_strong_result_w <= STRONG;
						when others => mutplex_strong_result_w <=x"00000000";
				end case;
		end process;

		process (weak_result_w, center_pix_w, mutplex_strong_result_w)
			begin
				case weak_result_w is
						when '0' => mutplex_result_o_w <= center_pix_w;
						when '1' => mutplex_result_o_w <= mutplex_strong_result_w;
						  when others => mutplex_result_o_w <= (others => '0');
				end case;
		end process;

		pix_o <= mutplex_result_o_w;
end arc;
