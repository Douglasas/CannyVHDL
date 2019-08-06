library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;

entity normalization_top is
port(
  valid_i : in std_logic;
  pix_i   : in slogic;

	clk_i   : in std_logic;
	rstn_i  : in std_logic;

	valid_o : out std_logic;
	pix_o   : out slogic
);
end entity;

architecture arch of normalization_top is
  -- from control to datapath (cd)
  signal cd_read_w  : std_logic;
  -- from datapath to control (dc)
	signal dc_full_w  : std_logic;
  signal dc_empty_w : std_logic;
begin
  normalization_ctrl_i : normalization_ctrl
  port map (
    full_i  => dc_full_w,
    empty_i => dc_empty_w,
    clk_i   => clk_i,
    rstn_i  => rstn_i,
    read_o  => cd_read_w
  );

  normalization_dp_i : normalization_dp
  port map (
    read_i  => cd_read_w,
    valid_i => valid_i,
    pix_i   => pix_i,
    clk_i   => clk_i,
    rstn_i  => rstn_i,
    full_o  => dc_full_w,
    empty_o => dc_empty_w,
    valid_o => valid_o,
    pix_o   => pix_o
  );


end arch;
