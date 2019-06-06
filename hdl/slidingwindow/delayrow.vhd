library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity delayrow is
  generic (
    IMAGE_X  : integer;
    WINDOW_X : integer;
    WINDOW_Y : integer
  );
  port (
    enable_i : in std_logic;
    pix_i    : in slogic;

    rstn_i : in std_logic;
    clk_i : in std_logic;

    window_o : out slogic_window(WINDOW_Y-1 downto 0,WINDOW_X-1 downto 0)
  );
end entity;

architecture arch of delayrow is

  signal buf_w : slogic_vec(WINDOW_Y-2 downto 0);

  type slogic_vecs is array(WINDOW_Y-1 downto 0) of slogic_vec(WINDOW_X-1 downto 0);
  signal vecs_w : slogic_vecs;

begin

  f_OUTPUT_I : for i in WINDOW_Y-1 downto 0 generate
    f_OUTPUT_J : for j in WINDOW_X-1 downto 0 generate
      window_o(i,j) <= vecs_w(i)(j);
    end generate;
  end generate;

  bufferm_0 : bufferm
  generic map (
    BUFFER_SIZE => WINDOW_X
  )
  port map (
    enable_i  => enable_i,
    pix_i     => pix_i,
    clk_i     => clk_i,
    pix_vec_o => vecs_w(0)
  );

  f_DATA : for i in WINDOW_Y-1 downto 1 generate
    bufferm_i : bufferm
    generic map (
      BUFFER_SIZE => WINDOW_X
    )
    port map (
      enable_i  => enable_i,
      pix_i     => buf_w(i-1),
      clk_i     => clk_i,
      pix_vec_o => vecs_w(i)
    );
  end generate;

  f_BUFF : for i in 0 to WINDOW_Y-2 generate
    buffers_i : buffers
      generic map (
      BUFFER_SIZE => IMAGE_X - WINDOW_X
    )
    port map (
      enable_i  => enable_i,
      pix_i  => vecs_w(i)(WINDOW_X-1),
      clk_i  => clk_i,
      pix_o  => buf_w(i)
    );
  end generate;

end architecture;
