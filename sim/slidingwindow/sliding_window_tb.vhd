library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity slidingwindow_tb is
end entity;

architecture arch of slidingwindow_tb is
  constant period : time := 10 ns;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix : slogic := to_slogic(0);

  signal valid_o  : std_logic;
  signal window_o : slogic_window(2 downto 0, 2 downto 0);
begin

  rstn <= '1' after period/2;
  clk <= not clk after period/2;

  process
  begin
    wait for period/2;

    valid <= '1';
    pix <= x"00000000";
    for i in 0 to 24 loop
      pix <= pix + to_slogic(1);
      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;

  slidingwindow_top_i : slidingwindow_top
  generic map (
    IMAGE_X  => 5,
    IMAGE_Y  => 5,
    WINDOW_X => 3,
    WINDOW_Y => 3
  )
  port map (
    valid_i  => valid,
    pix_i    => pix,
    rstn_i   => rstn,
    clk_i    => clk,
    valid_o  => valid_o,
    window_o => window_o
  );

end architecture;
