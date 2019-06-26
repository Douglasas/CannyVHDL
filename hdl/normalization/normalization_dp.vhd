library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.normalization_pkg.all;
use work.fifo_pkg.all;

entity normalization_dp is
	port(
		read_i : in std_logic;
		valid_i : in std_logic;
		pix_i : in slogic;

		clk_i : in std_logic;
		rstn_i : in std_logic;

    full_o : out std_logic;
		empty_o : out std_logic;

    valid_o : out std_logic;
		pix_o   : out slogic
	);
end entity;

architecture arch of normalization_dp is
	signal w_regis_in  : slogic;
  signal w_regis_max : slogic;
  signal w_fifo_data : slogic;
	signal w_max_comparison : std_logic;

  signal w_fifo_emtpy : std_logic;
  signal w_fifo_read : std_logic;

  signal w_numer : std_logic_vector(MSB+2*LSB-1 downto 0);
  signal w_denom : std_logic_vector(MSB+2*LSB-1 downto 0);

  signal w_quotient : std_logic_vector(MSB+2*LSB-1 downto 0);
  signal w_remain   : std_logic_vector(MSB+2*LSB-1 downto 0);
  signal r_valid_fifo : std_logic_vector(QT_DIV_CYCLES downto 0);
begin

		u0_regis_in : regis
    port map(
      enable_i => valid_i,
      data_i => pix_i,
      rstn_i => rstn_i,
			clk_i => clk_i,
			data_o => w_regis_in
		);

    w_max_comparison <= '1' when w_regis_in > w_regis_max else '0';
		u1_regis_max : regis
    port map(
      enable_i => w_max_comparison,
      data_i => w_regis_in,
      rstn_i => rstn_i,
			clk_i => clk_i,
			data_o => w_regis_max
		);

    w_fifo_read <= '1' when read_i = '1' and w_fifo_emtpy = '0' else '0';
    empty_o <= w_fifo_emtpy;

		u3_fifo : fifo
		generic map(
			FIFO_SIZE => IMAGE_Y * IMAGE_X
		)
		port map(
			data_i  => pix_i,
			write_i => valid_i,
			read_i  => w_fifo_read,
			clk_i   => clk_i,
			rstn_i  => rstn_i,
			data_o  => w_fifo_data,
			full_o  => full_o,
			empty_o => w_fifo_emtpy
		);

    p_VALID_FIFO : process(clk_i, rstn_i)
    begin
      if rstn_i = '0' then
        r_valid_fifo <= (others => '0');
      elsif rising_edge(clk_i) then
        r_valid_fifo <= r_valid_fifo(QT_DIV_CYCLES-1 downto 0) & w_fifo_read;
      end if;
    end process;
    valid_o <= r_valid_fifo(QT_DIV_CYCLES);

    w_numer <= std_logic_vector(shift_left(resize(signed(w_fifo_data), MSB+2*LSB), LSB));
    w_denom <= std_logic_vector(resize(signed(w_regis_max), MSB+2*LSB));

    div_inst : div PORT MAP (
  		clken    => '1',
  		clock    => clk_i,
      numer    => w_numer,
  		denom    => w_denom,
  		quotient => w_quotient,
  		remain   => w_remain
  	);
    pix_o <= slogic(resize(signed(w_quotient), MSB+LSB));

end architecture;
