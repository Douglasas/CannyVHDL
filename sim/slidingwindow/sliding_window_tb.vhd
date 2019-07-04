library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity slidingwindow_tb is
end entity;

architecture arch of slidingwindow_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix : slogic := to_slogic(0);

  signal valid_1_o  : std_logic;
  signal window_1_o : slogic_window(2 downto 0, 2 downto 0);

  signal valid_2_o  : std_logic;
  signal window_2_o : slogic_window(2 downto 0, 2 downto 0);
begin

  rstn <= '1' after period/2;
  clk <= not clk after period/2;

  process
  begin
    wait for period;
    pix <= (others => '0');
    valid <= '1';
    for i in 0 to 36 loop
      pix <= pix + to_slogic(1);
      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;

  slidingwindow_top_1_i : slidingwindow_top
  generic map (
    IMAGE_X  => 6,
    IMAGE_Y  => 6,
    WINDOW_X => 3,
    WINDOW_Y => 3
  )
  port map (
    valid_i  => valid,
    pix_i    => pix,
    rstn_i   => rstn,
    clk_i    => clk,
    valid_o  => valid_1_o,
    window_o => window_1_o
  );

  slidingwindow_top_2_i : slidingwindow_top
  generic map (
    IMAGE_X  => 4,
    IMAGE_Y  => 4,
    WINDOW_X => 3,
    WINDOW_Y => 3
  )
  port map (
    valid_i  => valid_1_o,
    pix_i    => window_1_o(1,1),
    rstn_i   => rstn,
    clk_i    => clk,
    valid_o  => valid_2_o,
    window_o => window_2_o
  );

end architecture;
