library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity fifo is
  generic (
    DATA_SIZE      : integer := 32;
    FIFO_SIZE      : integer := 32;
    FIFO_ADDR_SIZE : integer := 5
  );
  port (
    data_i      : in std_logic_vector (DATA_SIZE-1 downto 0);
    write_i     : in std_logic;
    read_i      : in std_logic;

    clk_i       : in std_logic;
    rstn_i      : in std_logic;

    data_o      : out std_logic_vector (DATA_SIZE-1 downto 0);
    full_o      : out std_logic;
    empty_o     : out std_logic
  );
end fifo;

architecture arch_fifo of fifo is
  signal fifo_r  : fifo_t(QUEUE_SIZE-1 downto 0)(DATA_SIZE-1 downto 0);
  signal full_w  : std_logic;
  signal empty_w : std_logic;

  signal start_addr_r : std_logic_vector(FIFO_ADDR_SIZE-1 downto 0);
  signal end_addr_r   : std_logic_vector(FIFO_ADDR_SIZE-1 downto 0);
begin
  p_MAIN : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      fifo_r       <= (others => (others => '0'));
      start_addr_r <= (others => '0');
      end_addr_r   <= (others => '0');

    elsif rising_edge(clk_i) then
      if read_i = '1' and empty_w = '0' then
        data_o <= fifo_r(to_integer(unsigned(start_addr_r)));
        start_addr_r <= start_addr_r + 1;
      end if;

      if write_i = '1' and full_w = '0' then
        fifo_r(to_integer(unsigned(end_addr_r))) <= data_i;
        end_addr_r <= end_addr_r + 1;
      end if;

    end if;
  end process;

  empty_w <= '1' when start_addr_r = end_addr_r else '0';
  full_w <= '1' when start_addr_r-1 = end_addr_r else '0';

  empty_o <= empty_w;
  full_o  <= full_w;

end arch_fifo;
