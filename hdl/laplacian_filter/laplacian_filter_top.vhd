library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.gaussian_pkg.all;
use work.laplacian_pkg.all;

entity laplacian_filter_top is
  port (
    valid_i : in std_logic;
    pix_i   : in slogic;

    clk_i   : in std_logic;
    rstn_i  : in std_logic;

    valid_o : out std_logic;
    pix_o   : out slogic
  );
end entity;

architecture arch of laplacian_filter_top is

  signal gauss_valid_w : std_logic;
  signal gauss_pix_w   : slogic;

  signal laplacian_valid_w : std_logic;
  signal laplacian_pix_w   : slogic;

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

  laplacian_top_i : laplacian_top
  port map (
    valid_i => gauss_valid_w,
    pix_i   => gauss_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => laplacian_valid_w,
    pix_o   => laplacian_pix_w
  );

  valid_o <= laplacian_valid_w;
  pix_o <= laplacian_pix_w;

end architecture;
