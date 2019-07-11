library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.laplacian_pkg.all;

entity laplacian_filter_top is
  port (
    valid_i : in std_logic;
    pix_i   : in slogic;

    clk_i   : in std_logic;
    rstn_i  : in std_logic;

    valid_o : out std_logic;
    pix_o   : out slogic
  );
end entity;

architecture arch of laplacian_filter_top is

  signal valid_input_r : std_logic;
  signal pix_input_r   : slogic;

  signal valid_output_r : std_logic;
  signal pix_output_r   : slogic;

  signal laplacian_valid_w : std_logic;
  signal laplacian_pix_w   : slogic;

begin

  p_INPUT : process(clk_i)
  begin
    if rising_edge(clk_i) then
      valid_input_r <= valid_i;
      pix_input_r   <= pix_i;
    end if;
  end process;

  laplacian_top_i : laplacian_top
  port map (
    valid_i => valid_input_r,
    pix_i   => pix_input_r,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => laplacian_valid_w,
    pix_o   => laplacian_pix_w
  );

  p_OUTPUT : process(clk_i)
  begin
    if rising_edge(clk_i) then
      valid_output_r <= laplacian_valid_w;
      pix_output_r   <= laplacian_pix_w;
    end if;
  end process;

  valid_o <= valid_output_r;
  pix_o <= pix_output_r;

end architecture;
