library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.fifo_pkg.all;

entity fifo is
  generic (
    FIFO_SIZE      : integer
  );
  port (
    write_i     : in std_logic;
    read_i      : in std_logic;
    data_i      : in slogic;

    clk_i       : in std_logic;
    rstn_i      : in std_logic;

    full_o      : out std_logic;
    empty_o     : out std_logic;
    data_o      : out slogic
  );
end fifo;

architecture arch_fifo of fifo is

  signal fifo_r  : slogic_vec(FIFO_SIZE-1 downto 0);

  signal first_addr_r  : integer range 0 to FIFO_SIZE-1;
  signal insert_addr_r : integer range 0 to FIFO_SIZE-1;
  signal size_r        : integer range 0 to FIFO_SIZE;

  signal next_first_addr_w : integer range 0 to FIFO_SIZE-1;
  signal next_insert_addr_w  : integer range 0 to FIFO_SIZE-1;

  signal equal_addrs_w : std_logic;
  signal full_w        : std_logic;
  signal empty_w       : std_logic;
begin

  next_first_addr_w  <= first_addr_r+1  when first_addr_r  /= FIFO_SIZE-1 else 0;
  next_insert_addr_w <= insert_addr_r+1 when insert_addr_r /= FIFO_SIZE-1 else 0;

  p_MAIN : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      first_addr_r  <= 0;
      insert_addr_r <= 0;
      size_r        <= 0;

    elsif rising_edge(clk_i) then

      if read_i = '1' and empty_w = '0' then
        data_o <= fifo_r(first_addr_r);
        first_addr_r <= next_first_addr_w;
        size_r <= size_r - 1;
      end if;

      if write_i = '1' and full_w = '0' then
        fifo_r(insert_addr_r) <= data_i;
        insert_addr_r <= next_insert_addr_w;
        size_r <= size_r + 1;
      end if;

    end if;
  end process;

  empty_w       <= '1' when size_r = 0         else '0';
  full_w        <= '1' when size_r = FIFO_SIZE else '0';

  empty_o <= empty_w;
  full_o  <= full_w;

end arch_fifo;

