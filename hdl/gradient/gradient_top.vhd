------gradiente_top
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;
use work.gradient_pkg.all;

entity gradient_top is
	port(
		------------input------------
		valid_i     : in std_logic;
    x_pix_i     : in slogic;
    y_pix_i     : in slogic;
		------------sync-------------
		rstn_i      : in std_logic;
		clk_i       : in std_logic;
		----------output-------------
    valid_o     : out std_logic;
		pix_o       : out slogic
	);
end gradient_top;

architecture arch of gradient_top is
  signal r_fila   : std_logic_vector(QT_SQRT_CYCLES-1 downto 0);
  signal w_radical   : STD_LOGIC_VECTOR (2*(MSB+LSB)-1 DOWNTO 0);
  signal w_remainder : STD_LOGIC_VECTOR (MSB+LSB DOWNTO 0);
  signal w_sqrt_res  : STD_LOGIC_VECTOR(MSB+LSB-1 downto 0);
begin

  p_SHIFT : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      r_fila <= (others => '0');
    elsif (rising_edge(clk_i)) then
      r_fila <= r_fila(QT_SQRT_CYCLES-2 downto 0) & valid_i;
    end if;
  end process;

  valid_o <= r_fila(QT_SQRT_CYCLES-1);

  w_radical <= std_logic_vector((signed(x_pix_i) * signed(x_pix_i)) + (signed(y_pix_i) * signed(y_pix_i)));
  sqrtip_inst : sqrtip
  port map (
    clk	      => clk_i,
    ena	      => '1',
    radical	  => w_radical,
    q	        => w_sqrt_res,
    remainder => w_remainder
  );

  pix_o <= slogic(w_sqrt_res);

end arch ; -- arch
