library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.gaussian_pkg.all;
use work.sobel_pkg.all;
use work.gradient_pkg.all;
use work.normalization_pkg.all;
use work.theta_pkg.all;
use work.non_max_supress_pkg.all;
use work.threshold_pkg.all;
use work.hysteresis_pkg.all;

entity canny_top is
  port (
    valid_i : in std_logic;
    pix_i   : in slogic;

    clk_i   : in std_logic;
    rstn_i  : in std_logic;

    valid_o : out std_logic;
    pix_o   : out slogic
  );
end entity;

architecture arch of canny_top is

  signal gauss_valid_w : std_logic;
  signal gauss_pix_w   : slogic;

  signal sobel_valid_w : std_logic;
  signal sobel_x_pix_w : slogic;
  signal sobel_y_pix_w : slogic;

  signal d_sobel_valid_w : std_logic;
  signal d_sobel_x_pix_w : slogic;
  signal d_sobel_y_pix_w : slogic;

  signal gradient_valid_w : std_logic;
  signal gradient_pix_w   : slogic;

  signal normalization_valid_w : std_logic;
  signal normalization_pix_w   : slogic;

  signal dly_normalization_valid_w : std_logic;
  signal dly_normalization_pix_w   : slogic;

  signal theta_empty_w : std_logic;
  signal theta_theta_w : slogic;

  signal supress_valid_w : std_logic;
  signal supress_pix_w : slogic;

  signal d_supress_valid_w : std_logic;
  signal d_supress_pix_w : slogic;

  signal threshold_valid_w : std_logic;
  signal threshold_pix_w   : slogic;

  signal hysteresis_valid_w : std_logic;
  signal hysteresis_pix_w   : slogic;
begin

  gaussian_top_i : gaussian_top
  port map (
    valid_i => valid_i,
    pix_i   => pix_i,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => gauss_valid_w,
    pix_o   => gauss_pix_w
  );

  sobel_top_i : sobel_top
  port map (
    valid_i => gauss_valid_w,
    pix_i   => gauss_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => sobel_valid_w,
    x_pix_o => sobel_x_pix_w,
    y_pix_o => sobel_y_pix_w
  );

  p_PIPELINE_SOBEL : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      d_sobel_valid_w <= '0';
    elsif rising_edge(clk_i) then
      d_sobel_valid_w <= sobel_valid_w;
      d_sobel_x_pix_w <= sobel_x_pix_w;
      d_sobel_y_pix_w <= sobel_y_pix_w;
    end if;
  end process;

  -- valid_o <= d_sobel_valid_w;
  -- pix_o <= d_sobel_x_pix_w;

  gradient_top_i : gradient_top
  port map (
    valid_i => d_sobel_valid_w,
    x_pix_i => d_sobel_x_pix_w,
    y_pix_i => d_sobel_y_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => gradient_valid_w,
    pix_o   => gradient_pix_w
  );

  normalization_top_i : normalization_top
  port map (
    valid_i => gradient_valid_w,
    pix_i   => gradient_pix_w,
    clk_i   => clk_i,
    rstn_i  => rstn_i,
    valid_o => normalization_valid_w,
    pix_o   => normalization_pix_w
  );

  p_DLY_NORM : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      dly_normalization_valid_w <= '0';
    elsif rising_edge(clk_i) then
      dly_normalization_valid_w <= normalization_valid_w;
      dly_normalization_pix_w <= normalization_pix_w;
    end if;
  end process;

  theta_top_i : theta_top
  port map (
    valid_i    => d_sobel_valid_w,
    x_pix_i    => d_sobel_x_pix_w,
    y_pix_i    => d_sobel_y_pix_w,
    read_out_i => normalization_valid_w,
    rstn_i     => rstn_i,
    clk_i      => clk_i,
    empty_o    => theta_empty_w,
    theta_o    => theta_theta_w
  );

  non_max_supress_top_i : non_max_supress_top
  port map (
    valid_i     => dly_normalization_valid_w,
    pix_norm_i  => dly_normalization_pix_w,
    pix_theta_i => theta_theta_w,
    rstn_i      => rstn_i,
    clk_i       => clk_i,
    valid_o     => supress_valid_w,
    pix_o       => supress_pix_w
  );

  p_PIPELINE_SUPRESS : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      d_supress_valid_w <= '0';
    elsif rising_edge(clk_i) then
      d_supress_valid_w <= supress_valid_w;
      d_supress_pix_w   <= supress_pix_w;
    end if;
  end process;

  threshold_top_i : threshold_top
  port map (
    valid_i => d_supress_valid_w,
    pix_i   => d_supress_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => threshold_valid_w,
    pix_o   => threshold_pix_w
  );

  hysteresis_top_i : hysteresis_top
  port map (
    valid_i => threshold_valid_w,
    pix_i   => threshold_pix_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    valid_o => hysteresis_valid_w,
    pix_o   => hysteresis_pix_w
  );

  valid_o <= hysteresis_valid_w;
  pix_o <= hysteresis_pix_w;

end architecture;
