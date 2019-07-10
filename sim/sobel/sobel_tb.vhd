library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.sobel_pkg.all;

entity sobel_tb is
end entity;

architecture arch of sobel_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix : slogic := to_slogic(0);

  signal valid_o  : std_logic;
  signal x_pix_o : slogic;
  signal y_pix_o : slogic;
begin

  rstn <= '1' after period/2;
  clk <= not clk after period/2;

  process
  begin
    wait for period/2;

    valid <= '1';
    pix <= (others => '0');
    for i in 0 to 24 loop
      pix <= pix + to_slogic(1);
      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;

  sobel_top_i : sobel_top
  generic map (
    INPUT_IMAGE_X => 5,
    INPUT_IMAGE_Y => 5
  )
  port map (
    valid_i => valid,
    pix_i   => pix,
    rstn_i  => rstn,
    clk_i   => clk,
    valid_o => valid_o,
    x_pix_o => x_pix_o,
    y_pix_o => y_pix_o
  );

end architecture;
