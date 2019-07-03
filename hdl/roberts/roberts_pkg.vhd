library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;

package roberts_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 2;
	constant WINDOW_Y : integer := 2;
	constant IMAGE_X : integer := INPUT_IMAGE_X-2;
	constant IMAGE_Y : integer := INPUT_IMAGE_Y-2;

  component roberts_top
  port (
    valid_i : in  std_logic;
    pix_i   : in  slogic;
    rstn_i  : in  std_logic;
    clk_i   : in  std_logic;
    valid_o : out std_logic;
    x_pix_o : out slogic;
    y_pix_o : out slogic
  );
  end component roberts_top;

end roberts_pkg;
