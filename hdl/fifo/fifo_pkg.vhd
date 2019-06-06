library ieee;
use ieee.std_logic_1164.all;

package fifo_pkg is
  
  type fifo_t is array (natural range <>) of std_logic_vector(31 downto 0);

  component fifo
    generic (
      DATA_SIZE      : integer := 32;
      FIFO_SIZE      : integer := 32;
      FIFO_ADDR_SIZE : integer := 5
    );
    port (
      data_i  : in  std_logic_vector (DATA_SIZE-1 downto 0);
      write_i : in  std_logic;
      read_i  : in  std_logic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      data_o  : out std_logic_vector (DATA_SIZE-1 downto 0);
      full_o  : out std_logic;
      empty_o : out std_logic
    );
  end component fifo;

end package;
