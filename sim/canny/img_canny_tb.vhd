library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.canny_pkg.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity img_canny_tb is
end entity;

architecture arch of img_canny_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  file fil_in : text;
  file fil_out : text;

  signal valid : std_logic;
  signal pix   : slogic := (others => '0');
  signal valid_o : std_logic;
  signal pix_o : slogic;
begin

  clk <= not clk after period/2;
  rstn <= '1' after period/2;

  p_MAIN : process
    variable v_line : line;
    variable v_data : slogic;
  begin
    wait for period/2;

    -- pix <= (others => '0');
    -- valid <= '1';
    -- for i in 0 to 36 loop
    --   pix <= pix + to_slogic(1);
    --   wait for period;
    -- end loop;
    -- valid <= '0';

    file_open(fil_in, "../dat/img.dat", READ_MODE);
    valid <= '1';
    while not endfile(fil_in) loop
      readline(fil_in, v_LINE);
      read(v_LINE, v_data);
      pix <= v_data;
      wait for period;
    end loop;
    valid <= '0';
    
    wait;
  end process;

  p_RES : process
    variable v_line : line;
  begin
    file_open(fil_out, "../dat/canny_out.dat", WRITE_MODE);

    while true loop
      wait until rising_edge(clk);
      if valid_o = '1' then
        write(v_line, pix_o);
        writeline(fil_out, v_line);
      end if;
    end loop;
    wait;
  end process;

  canny_top_i : canny_top
  port map (
    valid_i => valid,
    pix_i   => pix,
    clk_i   => clk,
    rstn_i  => rstn,
    valid_o => valid_o,
    pix_o   => pix_o
  );

end architecture;
