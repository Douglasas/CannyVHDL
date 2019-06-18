library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

package non_max_supress_pkg is
	
	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X : integer := 5;
	constant IMAGE_Y : integer := 5;
	
	component slidingwindow_top
	generic (
		IMAGE_X  : integer;
		IMAGE_Y  : integer;
		WINDOW_X : integer;
		WINDOW_Y : integer
	);
	port(
		valid_i  : in  std_logic;
		pix_i    : in  slogic;
		rstn_i   : in  std_logic;
		clk_i    : in  std_logic;
		valid_o  : out std_logic;
		window_o : out slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0)
	);
	end component slidingwindow_top;
	
	
end non_max_supress_pkg;