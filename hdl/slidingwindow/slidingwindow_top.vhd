library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity slidingwindow_top is
  generic (
    IMAGE_X  : integer;
    IMAGE_Y  : integer;
    WINDOW_X : integer;
    WINDOW_Y : integer
  );
  port (
    valid_i  : in std_logic;
    pix_i    : in slogic;

    rstn_i   : in std_logic;
    clk_i    : in std_logic;

    valid_o  : out std_logic;
    window_o : out slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0)
  );
end entity;

architecture arch of slidingwindow_top is
  -- from control to datapath (cd)
  signal cd_col_zero_w : std_logic;
  signal cd_col_inc_w  : std_logic;
  signal cd_lin_zero_w : std_logic;
  signal cd_lin_inc_w  : std_logic;
  -- from datapath to control (dc)
  signal dc_col_max_w  : std_logic;
  signal dc_lin_max_w  : std_logic;
begin

  slidingwindow_ctrl_i : slidingwindow_ctrl
  port map (
    col_max_i  => dc_col_max_w,
    lin_max_i  => dc_lin_max_w,

    enable_i   => valid_i,
    rstn_i     => rstn_i,
    clk_i      => clk_i,

    col_zero_o => cd_col_zero_w,
    col_inc_o  => cd_col_inc_w,
    lin_zero_o => cd_lin_zero_w,
    lin_inc_o  => cd_lin_inc_w
  );

  slidingwindow_dp_i : slidingwindow_dp
  generic map (
    IMAGE_X  => IMAGE_X,
    IMAGE_Y  => IMAGE_Y,
    WINDOW_X => WINDOW_X,
    WINDOW_Y => WINDOW_Y
  )
  port map (
    pix_i      => pix_i,
    col_zero_i => cd_col_zero_w,
    col_inc_i  => cd_col_inc_w,
    lin_zero_i => cd_lin_zero_w,
    lin_inc_i  => cd_lin_inc_w,

    enable_i   => valid_i,
    rstn_i     => rstn_i,
    clk_i      => clk_i,

    col_max_o  => dc_col_max_w,
    lin_max_o  => dc_lin_max_w,
    
    valid_o    => valid_o,
    window_o   => window_o
  );

end architecture;
