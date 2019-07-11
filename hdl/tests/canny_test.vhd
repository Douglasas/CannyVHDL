library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;
use work.canny_pkg.all;
use work.tests_pkg.all;

entity canny_test is
  port (
    rstn_i  : in std_logic;
    clk_i   : in std_logic;
    valid_o : out std_logic;
    pix_o   : out slogic
  );
end entity;


architecture arch of canny_test is
  constant BORDERS_LOST : integer := 8;

  signal image_data_rom : slogic_vec(INPUT_IMAGE_X*INPUT_IMAGE_Y-1 downto 0) := IMAGE_DATA;
  signal cnt_r : integer range 0 to INPUT_IMAGE_X*INPUT_IMAGE_Y;
  signal val_cnt_r : integer range 0 to INPUT_IMAGE_X*INPUT_IMAGE_Y;

  type states is (idle, first_pix, running, waiting_last_out);
  signal current_st : states;
  signal next_st : states;

  signal last_pix_in_w  : std_logic;
  signal last_pix_out_w : std_logic;

  signal image_valid_w : std_logic;
  signal image_pix_w   : slogic;
  signal filter_rstn_w : std_logic;

  signal filter_valid_w : std_logic;
  signal filter_pix_w   : slogic;
begin
  p_CURRENT : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      current_st <= idle;
    elsif rising_edge(clk_i) then
      current_st <= next_st;
    end if;
  end process;

  p_NEXT : process(current_st, last_pix_in_w, last_pix_out_w)
  begin
    case (current_st) is
      when idle => next_st <= first_pix;
      when first_pix => next_st <= running;
      when running =>
        if last_pix_in_w = '1' then
          next_st <= waiting_last_out;
        else
          next_st <= running;
        end if;
      when waiting_last_out =>
        if last_pix_out_w = '1' then
          next_st <= first_pix;
        else
          next_st <= waiting_last_out;
        end if;
    end case;
  end process;

  p_COUNTER : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      cnt_r <= 0;
    elsif rising_edge(clk_i) then
      if last_pix_in_w = '1' then
        cnt_r <= 0;
      elsif current_st = first_pix or current_st = running then
        cnt_r <= cnt_r+1;
      end if;
    end if;
  end process;

  last_pix_in_w <= '1' when cnt_r = INPUT_IMAGE_X*INPUT_IMAGE_Y-1 else '0';
  image_valid_w <= '1' when current_st = first_pix or current_st = running else '0';
  filter_rstn_w <= '0' when rstn_i = '0' else '1';
  image_pix_w <= image_data_rom(cnt_r);

  canny_top_i : canny_top
  port map (
    valid_i => image_valid_w,
    pix_i   => image_pix_w,
    clk_i   => clk_i,
    rstn_i  => filter_rstn_w,
    valid_o => filter_valid_w,
    pix_o   => filter_pix_w
  );

  valid_o <= filter_valid_w;
  pix_o <= filter_pix_w;

  p_VALID_COUNTER : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      val_cnt_r <= 0;
    elsif rising_edge(clk_i) then
      if filter_valid_w = '1' then
        if last_pix_out_w = '1' then
          val_cnt_r <= 0;
        else
          val_cnt_r <= val_cnt_r + 1;
        end if;
      end if;
    end if;
  end process;

  last_pix_out_w <= '1' when val_cnt_r = (INPUT_IMAGE_X-BORDERS_LOST)*(INPUT_IMAGE_Y-BORDERS_LOST)-1 else '0';
end architecture;
