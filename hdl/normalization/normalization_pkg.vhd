library ieee;
use ieee.std_logic_1164.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;

package normalization_pkg is

  constant WINDOW_X : integer := 3;
  constant WINDOW_Y : integer := 3;
  constant IMAGE_X  : integer := INPUT_IMAGE_X-4;
  constant IMAGE_Y  : integer := INPUT_IMAGE_Y-4;

  component normalization_top
    port (
      valid_i : in  std_logic;
      pix_i   : in  slogic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      valid_o : out std_logic;
      pix_o   : out slogic
    );
  end component normalization_top;

  component normalization_ctrl
    port (
      full_i  : in  std_logic;
      empty_i : in  std_logic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      read_o  : out std_logic;
      valid_o : out std_logic
    );
  end component normalization_ctrl;


  component normalization_dp
    port (
      read_i  : in  std_logic;
      valid_i : in  std_logic;
      pix_i   : in  slogic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      full_o  : out std_logic;
      empty_o : out std_logic;
      pix_o   : out slogic
    );
  end component normalization_dp;


  component regis
    port (
      enable_i : in  std_logic;
      data_i   : in  slogic;
      clk_i    : in  std_logic;
      rstn_i   : in  std_logic;
      data_o   : out slogic
    );
  end component regis;

end normalization_pkg;
