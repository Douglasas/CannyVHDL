library ieee;
use ieee.std_logic_1164.all;

entity slidingwindow_ctrl is
  port (
    -- inputs
    col_max_i : in std_logic;
    lin_max_i : in std_logic;

    -- sync
    enable_i : in std_logic;
    rstn_i   : in std_logic;
    clk_i    : in std_logic;

    -- outputs
    col_zero_o  : out std_logic;
    col_inc_o   : out std_logic;
    lin_zero_o  : out std_logic;
    lin_inc_o   : out std_logic;
    count_clr_o : out std_logic
  );
end entity;

architecture arch of slidingwindow_ctrl is
  type t_sm is (s_idle, s_ccol, s_clin);
  signal current_st : t_sm;
  signal next_st : t_sm;
begin

  p_MAIN : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      current_st <= s_idle;
    elsif rising_edge(clk_i) then
      current_st <= next_st;
    end if;
  end process;

  p_NEXT : process(current_st, enable_i, col_max_i, lin_max_i)
  begin
    case( current_st ) is
      when s_idle =>
        if enable_i = '1' then
          next_st <= s_ccol;
        else
          next_st <= s_idle;
        end if;

      when s_ccol =>
        if col_max_i = '1' then
          next_st <= s_clin;
        else
          next_st <= s_ccol;
        end if;

      when s_clin =>
        if lin_max_i = '1' and col_max_i = '1' then
          next_st <= s_idle;
        else
          next_st <= s_ccol;
        end if;

    end case;
  end process;

  col_zero_o <= '1' when current_st = s_idle or current_st = s_clin else '0';
  col_inc_o  <= '1' when current_st = s_ccol else '0';
  lin_zero_o <= '1' when current_st = s_idle else '0';
  lin_inc_o  <= '1' when current_st = s_clin else '0';
  count_clr_o <= '1' when current_st = s_idle else '0';

end architecture;
