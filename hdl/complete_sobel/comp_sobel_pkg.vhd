library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

package comp_sobel_pkg is
  component comp_sobel_top
  port (
    valid_i : in  std_logic;
    pix_i   : in  slogic;
    clk_i   : in  std_logic;
    rstn_i  : in  std_logic;
    valid_o : out std_logic;
    pix_o   : out slogic
  );
  end component comp_sobel_top;
end package;
