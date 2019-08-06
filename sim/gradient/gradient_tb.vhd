library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.slogic_pkg.all;
use work.gradient_pkg.all;

entity gradiente_tb is
end entity;

architecture arch of gradiente_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk  : std_logic := '1';

  signal valid : std_logic := '0';
  signal pix_x : slogic;
  signal pix_y : slogic;

  signal valid_o  : std_logic;
  signal pix_o : slogic;

  signal real_pix_x : real := 0.0;
  signal real_pix_y : real := 25.0;
  signal real_pix_o : real;
begin

  rstn <= '1' after period/2;
  clk <= not clk after period/2;

  process
  begin
    wait for period/2;

    valid <= '1';
    real_pix_x <= 0.0;
    real_pix_y <= 24.0;

    for i in 0 to 24 loop
      real_pix_x <= real_pix_x + 1.0;
      real_pix_y <= real_pix_y - 1.0;

      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;

  pix_x <= to_slogic(real_pix_x);
  pix_y <= to_slogic(real_pix_y);
  real_pix_o <= real(to_integer(signed(pix_o))) / (2.0**LSB);

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
