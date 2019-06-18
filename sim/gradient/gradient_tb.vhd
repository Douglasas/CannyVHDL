library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.gradient_pkg.all;

entity gradiente_tb is
end entity;

architecture arch of gradiente_tb is
  constant period : time := 10 ns;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix_x : slogic := to_slogic(0);
  signal pix_y : slogic := to_slogic(0);

  signal valid_o  : std_logic;
  signal pix_o : slogic;

begin

  rstn <= '1' after period/2;
  clk <= not clk after period/2;

  process
  begin
    wait for period/2;

    valid <= '1';
    pix_x <= x"00000000";
    pix_y <= x"00000000";

    for i in 0 to 24 loop
      pix_x <= pix_x + to_slogic(1);
      pix_y <= pix_y + to_slogic(1);

      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;

  gradient_inst : gradient_top PORT MAP (
    ------------input------------
    valid_i    => valid,
    x_pix_i    => pix_x,
    y_pix_i    => pix_y,
    ------------sync-------------
    rstn_i      => rstn,
    clk_i       => clk,
    ----------output-------------
    valid_o    => valid_o,
    pix_o       => pix_o
  );
end architecture;
