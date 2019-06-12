LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
library work;
use work.theta_pkg.all;

ENTITY register_desl IS
	generic(
		TAMNHO_REGS : integer ---:= 4
	);
	port(
------------imput----------------
    set_i		:	in std_logic;
	 valid_i		:	in std_logic;
------------sync-----------------
    rstn_i		:	in	std_logic;
    clk_i 		:	in	std_logic; 
-----------output----------------
    regis_out	: 	out std_logic
);
END register_desl;

ARCHITECTURE arc OF register_desl IS
	signal set_entrada	:	std_logic_vector (TAMNHO_REGS-1 downto 0);
	signal saida			: std_logic;
BEGIN
    process(clk_i,rstn_i)
    begin
        if rstn_i = '0' then
            saida <= '0';
        elsif rising_edge(clk_i) then
            if valid_i = '1' then
					     set_entrada(TAMNHO_REGS-1 downto 1) <= set_entrada (TAMNHO_REGS-2 downto 0);
					     set_entrada(0) <= set_i;
					     saida <= set_entrada(TAMNHO_REGS-1);
            end if;
        end if;
    end process;
regis_out <= saida;
END arc;