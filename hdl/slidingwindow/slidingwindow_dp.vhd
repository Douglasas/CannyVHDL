library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.slidingwindow_pkg.all;

entity slidingwindow_dp is
  generic (
    IMAGE_X  : integer;
    IMAGE_Y  : integer;
    WINDOW_X : integer;
    WINDOW_Y : integer
  );
  port (
    -- top inputs
    enable_i : in std_logic;
    pix_i    : in slogic;

    -- ctrl inputs
    col_zero_i : in std_logic;
    col_inc_i  : in std_logic;
    lin_zero_i : in std_logic;
    lin_inc_i  : in std_logic;
    count_clr_i : in std_logic;

    -- sync
    rstn_i   : in std_logic;
    clk_i    : in std_logic;

    -- ctrl outputs
    col_max_o : out std_logic;
    lin_max_o : out std_logic;

    -- top outputs
    valid_o  : out std_logic;
    window_o : out slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0)
  );
end entity;

architecture arch of slidingwindow_dp is
  constant PADY : integer := WINDOW_Y - 1;
  constant PADX : integer := WINDOW_X - 1;

  signal delayed_en_r : std_logic;

  signal col_r      : integer range 0 to IMAGE_X+1;
  signal col_base_w : integer range 0 to IMAGE_X+1;
  signal col_inc_w  : integer range 0 to IMAGE_X+1;

  signal lin_r      : integer range 0 to IMAGE_Y+1;
  signal lin_base_w : integer range 0 to IMAGE_Y+1;
  signal lin_inc_w  : integer range 0 to IMAGE_Y+1;

  signal window_transposed_w : slogic_window(WINDOW_X-1 downto 0, WINDOW_Y-1 downto 0);
begin

  col_base_w <= 0 when col_zero_i = '1' else col_r;
  col_inc_w  <= (col_base_w + 1) when col_inc_i = '1' else col_base_w;

  p_INC_COL : process(clk_i, rstn_i)
  begin
    if enable_i = '1' then
      if rstn_i = '0' then
        col_r <= 0;
      elsif rising_edge(clk_i) then
        col_r <= col_inc_w;
      end if;
    end if;
  end process;

  lin_base_w <= 0 when lin_zero_i = '1' else lin_r;
  lin_inc_w  <= (lin_base_w + 1) when lin_inc_i = '1' else lin_base_w;

  p_INC_LIN : process(clk_i, rstn_i)
  begin
    if enable_i = '1' then
      if rstn_i = '0' then
        lin_r <= 0;
      elsif rising_edge(clk_i) then
        lin_r <= lin_inc_w;
      end if;
    end if;
  end process;

  delayrow_i : delayrow
  generic map (
    IMAGE_X  => IMAGE_X,
    WINDOW_X => WINDOW_X,
    WINDOW_Y => WINDOW_Y
  )
  port map (
    enable_i => enable_i,
    pix_i    => pix_i,
    rstn_i   => rstn_i,
    clk_i    => clk_i,
    window_o => window_transposed_w
  );
  gen_TRANSPOSE_I : for i in 0 to WINDOW_Y-1 generate
    gen_TRANSPOSE_J : for j in 0 to WINDOW_X-1 generate
      window_o(i,j) <= window_transposed_w(j,i);
    end generate;
  end generate;

  p_DELAY_EN : process(clk_i)
  begin
    if rising_edge(clk_i) then
      delayed_en_r <= enable_i;
    end if;
  end process;

  col_max_o <= '1' when col_r >= IMAGE_X-2 else '0';
  lin_max_o <= '1' when lin_r >= IMAGE_Y-1 else '0';

  valid_o <= '1' when col_r >= PADX and lin_r >= PADY and delayed_en_r = '1' and count_clr_i = '0' else '0';

end architecture;
