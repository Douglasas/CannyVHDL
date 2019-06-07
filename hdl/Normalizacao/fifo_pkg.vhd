library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

package fifo_pkg is

  component fifo
    generic (
      FIFO_SIZE : integer
    );
    port (
      data_i  : in  slogic;
      write_i : in  std_logic;
      read_i  : in  std_logic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      data_o  : out slogic;
      full_o  : out std_logic;
      empty_o : out std_logic
    );
  end component fifo;


end package;