library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;
use work.fifo_pkg.all;
use work.roberts_filter_pkg.all;

entity roberts_int is
  port (
    write_i : in std_logic;
    read_i  : in std_logic;
    data_i  : in std_logic_vector(7 downto 0);

    rstn_i     : in std_logic;
    clk_i      : in std_logic;
    clk_proc_i : in std_logic;

    empty_o : out std_logic;
    full_o  : out std_logic;
    data_o  : out std_logic_vector(11 downto 0)
  );
end entity;

architecture arch of roberts_int is
  signal write_r      : std_logic;
  signal write_prev_r : std_logic;
  signal write_red_w  : std_logic;
  signal read_r       : std_logic;
  signal read_prev_r  : std_logic;
  signal read_red_w   : std_logic;

  signal input_pix_w : slogic;
  signal pix_valid_r : std_logic;

  signal empty_fifo_in_w : std_logic;
  signal full_fifo_in_w  : std_logic;
  signal data_fifo_in_w : slogic;

  signal filter_valid_w : std_logic;
  signal filter_pix_w : slogic;

  signal empty_fifo_out_w : std_logic;
  signal full_fifo_out_w  : std_logic;
  signal data_fifo_out_w  : slogic;

  signal delayed_read_red_r  : std_logic;
  signal delayed_out_empty_r : std_logic;
  signal delayed_out_full_r  : std_logic;
  signal delayed_out_data_r  : std_logic_vector(11 downto 0);
begin
  p_RED : process(clk_proc_i, rstn_i)
  begin
    if rstn_i = '0' then
      write_prev_r <= '0';
      read_prev_r  <= '0';
      write_r <= '0';
      read_r  <= '0';
    elsif rising_edge(clk_proc_i) then
      write_prev_r <= write_r;
      read_prev_r  <= read_r;
      write_r <= write_i;
      read_r  <= read_i;
    end if;
  end process;

  write_red_w <= '1' when write_prev_r = '0' and write_r = '1' else '0';
  read_red_w  <= '1' when  read_prev_r = '0' and  read_r = '1' else '0';
  input_pix_w(LSB+7 downto LSB)     <= data_i;
  input_pix_w(LSB-1 downto 0)       <= (others => '0');
  input_pix_w(MSB+LSB-1 downto LSB+8) <= (others => '0');

  p_VALID_IN : process(clk_proc_i, rstn_i)
  begin
    if rstn_i = '0' then
      pix_valid_r <= '0';
    elsif rising_edge(clk_proc_i) then
      pix_valid_r <= not empty_fifo_in_w;
    end if;
  end process;

  fifo_input_i : fifo
  generic map (
    FIFO_SIZE => 4--INPUT_IMAGE_X*INPUT_IMAGE_Y
  )
  port map (
    write_i => write_red_w,
    read_i  => not empty_fifo_in_w,
    data_i  => input_pix_w,
    clk_i   => clk_proc_i,
    rstn_i  => rstn_i,
    full_o  => full_fifo_in_w,
    empty_o => empty_fifo_in_w,
    data_o  => data_fifo_in_w
  );

  roberts_filter_i : roberts_filter_top
  port map (
    valid_i => pix_valid_r,
    pix_i   => data_fifo_in_w,
    clk_i   => clk_proc_i,
    rstn_i  => rstn_i,
    valid_o => filter_valid_w,
    pix_o   => filter_pix_w
  );

  fifo_output_i : fifo
  generic map (
    FIFO_SIZE => (INPUT_IMAGE_X-1)*(INPUT_IMAGE_Y-1)
  )
  port map (
    write_i => filter_valid_w,
    read_i  => read_red_w,
    data_i  => filter_pix_w,
    clk_i   => clk_proc_i,
    rstn_i  => rstn_i,
    full_o  => full_fifo_out_w,
    empty_o => empty_fifo_out_w,
    data_o  => data_fifo_out_w
  );

  empty_o <= empty_fifo_out_w;
  full_o  <= full_fifo_out_w;

  p_DELAYED_READ : process(clk_proc_i, rstn_i)
  begin
    if rstn_i = '0' then
      delayed_read_red_r <= '0';
    elsif rising_edge(clk_proc_i) then
      delayed_read_red_r <= read_red_w;
    end if;
  end process;

  p_DELAYED_DATA : process(clk_proc_i, rstn_i)
  begin
    if rstn_i = '0' then
      delayed_out_data_r  <= (others => '0');
    elsif rising_edge(clk_proc_i) then
      if delayed_read_red_r = '1' then
        delayed_out_data_r <= data_fifo_out_w(33 downto 22);
      end if;
    end if;
  end process;

  data_o  <= delayed_out_data_r;

end architecture;
