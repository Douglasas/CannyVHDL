library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.comp_sobel_pkg.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity img_sobel_tb is
end entity;

architecture arch of img_sobel_tb is
  constant period : time := 10 ns;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  file fil_in : text;
  file fil_out : text;

  signal cycles_count : integer := 0;

  constant IMG_QT      : integer := 200;
  signal pix_count     : integer := 0;
  constant TOT_IN_PIX  : integer := 481*321;
  constant TOT_OUT_PIX : integer := (481-2)*(321-2);

  signal valid : std_logic := '0';
  signal pix   : slogic    := (others => '0');

  signal valid_o : std_logic;
  signal pix_o : slogic;
begin

  clk <= not clk after period/2;
  rstn <= '1' after period;

  cycles_count <= cycles_count + 1 after period;

  p_INPUT : process
    variable v_line : line;
    variable v_data : slogic;
    variable v_counter : integer := 0;
  begin
    wait for period/2;

    for i in 0 to IMG_QT-1 loop
        file_open(fil_in, "../../dat/dataset/"&integer'image(i)&".dat", READ_MODE);
        report "IN > " & "../../dat/dataset/"&integer'image(i)&".dat";
        valid <= '1';
        while not endfile(fil_in) loop
          readline(fil_in, v_LINE);
          read(v_LINE, v_data);
          pix <= v_data;
          wait for period;
        end loop;
        valid <= '0';
        file_close(fil_in);

        wait until pix_count = TOT_OUT_PIX;
        wait until pix_count = 0;
    end loop;

    wait;
  end process;

  p_RES : process
    variable v_line : line;
  begin
    for i in 0 to IMG_QT-1 loop
      file_open(fil_out, "../../dat/dataset-results/img_sobel_tb/"&integer'image(i)&".dat", WRITE_MODE);
      report "OUT > " & "../../dat/dataset-results/img_sobel_tb/"&integer'image(i)&".dat";
      
      pix_count <= 0;
      wait for period;

      while (pix_count < TOT_OUT_PIX) loop
        wait until rising_edge(clk);
        if valid_o = '1' then
          write(v_line, pix_o);
          writeline(fil_out, v_line);
          pix_count <= pix_count + 1;
        end if;
      end loop;
      file_close(fil_out);
    end loop;
    wait;
  end process;

  comp_sobel_top_i : comp_sobel_top
  port map (
    valid_i => valid,
    pix_i   => pix,
    clk_i   => clk,
    rstn_i  => rstn,
    valid_o => valid_o,
    pix_o   => pix_o
  );

end architecture;
