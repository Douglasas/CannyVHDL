library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;

entity regis is
	port(
    enable_i : in std_logic;
    data_i   : in slogic;

    clk_i    : in std_logic;
		rstn_i   : in std_logic;

    data_o   : out slogic
	);
end entity;

architecture arch of regis is
	signal reg_r : slogic;
begin

	main: process (clk_i, rstn_i)
	begin
    if(rstn_i = '0') then
      reg_r <= (others => '0');
    elsif(enable_i = '1') then
			if (rising_edge(clk_i)) then
				reg_r <= data_i;
			end if;
		end if;

	end process;

	data_o <= reg_r;

end arch;
