library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.gaussian_pkg.all;
--------------- libery de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;

entity img_gaus_tb is
end entity;

architecture arch of img_gaus_tb is
  constant period : time := 10 ps;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  file fil_in : text;
  file fil_out : text;

  signal valid : std_logic;
  signal pix   : slogic;
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
    file_open(fil_out, "../dat/img_out.dat", WRITE_MODE);

    while true loop
      wait until rising_edge(clk);
      if valid_o = '1' then
        write(v_line, pix_o);
        writeline(fil_out, v_line);
      end if;
    end loop;
    wait;
  end process;

  gaussian_top_i : gaussian_top
  port map (
    valid_i => valid,
    pix_i   => pix,
    rstn_i  => rstn,
    clk_i   => clk,
    valid_o => valid_o,
    pix_o   => pix_o
  );

end architecture;
