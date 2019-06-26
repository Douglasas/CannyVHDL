library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;

entity normalization_tb is
end entity;

architecture arch of normalization_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix : slogic := to_slogic(0);

  signal valid_o  : std_logic;
  signal pix_o : slogic;
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

  normalization_top_i : normalization_top
  port map (
    valid_i => valid,
    pix_i   => pix,
    clk_i   => clk,
    rstn_i  => rstn,
    valid_o => valid_o,
    pix_o   => pix_o
  );

end architecture;
