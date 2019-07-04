library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.gaussian_pkg.all;
use work.sobel_pkg.all;
use work.prewitt_pkg.all;
use work.gradient_pkg.all;

entity prewitt_filter_top is
  port (
    valid_i : in std_logic;
    pix_i   : in slogic;

    clk_i   : in std_logic;
    rstn_i  : in std_logic;

    valid_o : out std_logic;
    pix_o   : out slogic
  );
end entity;

architecture arch of prewitt_filter_top is

  signal gauss_valid_w : std_logic;
  signal gauss_pix_w   : slogic;

  signal prewitt_valid_w : std_logic;
  signal prewitt_x_pix_w : slogic;
  signal prewitt_y_pix_w : slogic;

  signal gradient_valid_w : std_logic;
  signal gradient_pix_w   : slogic;

begin

  gaussian_top_i : gaussian_top
  port map (
    valid_i => valid_i,
    pix_i   => pix_i,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => gauss_valid_w,
    pix_o   => gauss_pix_w
  );

  prewitt_top_i : sobel_top
  port map (
    valid_i => gauss_valid_w,
    pix_i   => gauss_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => prewitt_valid_w,
    x_pix_o => prewitt_x_pix_w,
    y_pix_o => prewitt_y_pix_w
  );

  gradient_top_i : gradient_top
  port map (
    valid_i => prewitt_valid_w,
    x_pix_i => prewitt_x_pix_w,
    y_pix_i => prewitt_y_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => gradient_valid_w,
    pix_o   => gradient_pix_w
  );

  valid_o <= gradient_valid_w;
  pix_o <= gradient_pix_w;

end architecture;
