library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.slogic_pkg.all;

package gradient_pkg is
	----------size--------------------
	constant WINDOW_X : integer := 3;
	constant WINDOW_Y : integer := 3;
	constant IMAGE_X : integer := 220;
	constant IMAGE_Y : integer := 220;
	----------Constants----------------
	constant QT_SQRT_CYCLES : integer := 10;

  component gradient_top
    port (
      valid_i : in  std_logic;
      x_pix_i : in  slogic;
      y_pix_i : in  slogic;
      rstn_i  : in  std_logic;
      clk_i   : in  std_logic;
      valid_o : out std_logic;
      pix_o   : out slogic
    );
  end component gradient_top;

  component sqrtip
    port (
      ena		    : in std_logic;
      radical		: in std_logic_vector (2*(MSB+LSB)-1 DOWNTO 0);
      clk		    : in std_logic;
      q	        : out std_logic_vector (MSB+LSB-1 DOWNTO 0);
      remainder : out std_logic_vector (MSB+LSB DOWNTO 0)
    );
  end component;

end gradient_pkg;
