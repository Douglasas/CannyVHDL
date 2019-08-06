library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;

package non_max_supress_pkg is

	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X : integer := INPUT_IMAGE_X-4;
	constant IMAGE_Y : integer := INPUT_IMAGE_Y-4;

  component non_max_supress_top
    port (
      clk_i       : in  std_logic;
      rstn_i      : in  std_logic;
      valid_i     : in  std_logic;
      pix_norm_i  : in  slogic;
      pix_theta_i : in  slogic;
      valid_o     : out std_logic;
      pix_o       : out slogic
    );
  end component non_max_supress_top;

end non_max_supress_pkg;
