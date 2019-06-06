library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

package slidingwindow_pkg is

  component slidingwindow_top
    generic (
      IMAGE_X  : integer;
      IMAGE_Y  : integer;
      WINDOW_X : integer;
      WINDOW_Y : integer
    );
    port (
      valid_i  : in  std_logic;
      pix_i    : in  slogic;
      rstn_i   : in  std_logic;
      clk_i    : in  std_logic;
      valid_o  : out std_logic;
      window_o : out slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0)
    );
  end component slidingwindow_top;



  component slidingwindow_ctrl
    port (
      col_max_i  : in  std_logic;
      lin_max_i  : in  std_logic;
      enable_i   : in  std_logic;
      rstn_i     : in  std_logic;
      clk_i      : in  std_logic;
      col_zero_o : out std_logic;
      col_inc_o  : out std_logic;
      lin_zero_o : out std_logic;
      lin_inc_o  : out std_logic
    );
  end component slidingwindow_ctrl;

  component slidingwindow_dp
    generic (
      IMAGE_X  : integer;
      IMAGE_Y  : integer;
      WINDOW_X : integer;
      WINDOW_Y : integer
    );
    port (
      enable_i   : in  std_logic;
      pix_i      : in  slogic;
      col_zero_i : in  std_logic;
      col_inc_i  : in  std_logic;
      lin_zero_i : in  std_logic;
      lin_inc_i  : in  std_logic;
      rstn_i     : in  std_logic;
      clk_i      : in  std_logic;
      col_max_o  : out std_logic;
      lin_max_o  : out std_logic;
      valid_o    : out std_logic;
      window_o   : out slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0)
    );
  end component slidingwindow_dp;

  component delayrow
    generic (
      IMAGE_X  : integer;
      WINDOW_X : integer;
      WINDOW_Y : integer
    );
    port (
      enable_i : in  std_logic;
      pix_i    : in  slogic;
      rstn_i   : in  std_logic;
      clk_i    : in  std_logic;
      window_o : out slogic_window
    );
  end component delayrow;

  component buffers
    generic (
      BUFFER_SIZE : integer
    );
    port (
      enable_i : in  std_logic;
      pix_i    : in  slogic;
      clk_i    : in  std_logic;
      pix_o    : out slogic
    );
  end component buffers;

  component bufferm
    generic (
      BUFFER_SIZE : integer
    );
    port (
      enable_i  : in  std_logic;
      pix_i     : in  slogic;
      clk_i     : in  std_logic;
      pix_vec_o : out slogic_vec
    );
  end component bufferm;

end package;
