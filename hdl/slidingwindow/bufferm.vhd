library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

entity bufferm is
  generic (
    BUFFER_SIZE : integer
  );
  port (
    enable_i  : in std_logic;
    pix_i     : in slogic;

    clk_i     : in std_logic;

    pix_vec_o : out slogic_vec
  );
end entity;

architecture arch of bufferm is
  signal buf_r : slogic_vec(BUFFER_SIZE-1 downto 0);
begin

  p_SHIFT_0 : process(clk_i)
  begin
    if enable_i = '1' then
      if rising_edge(clk_i) then
        buf_r(0) <= pix_i;
      end if;
    end if;
  end process;

  shift_f : for i in BUFFER_SIZE-1 downto 1 generate

    p_SHIFT : process(clk_i)
    begin
      if enable_i = '1' then
        if rising_edge(clk_i) then
          buf_r(i) <= buf_r(i-1);
        end if;
      end if;
    end process;

  end generate;

  pix_vec_o <= buf_r;
end architecture;
