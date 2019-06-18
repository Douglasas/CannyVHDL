LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.theta_pkg.all;

ENTITY register1 IS
	generic(
		TAMNHO_REGS : integer ---:= 4
	);
	port(
------------imput----------------
    set_i		:	in integer;
	 valid_i		:	in std_logic;
------------sync-----------------
    rstn_i		:	in	std_logic;
    clk_i 		:	in	std_logic; 
-----------output----------------
    regi_out	: 	out integer
);
END register1;

ARCHITECTURE arc OF register1 IS
	signal reg_r : integer;
BEGIN
    process(clk_i,rstn_i)
    begin
        if rstn_i = '0' then
            reg_r <= 0;
        elsif rising_edge(clk_i) then
            if valid_i = '1' then
                reg_r <= set_i;
            end if;
        end if;
    end process;
    regi_out <= reg_r;
END arc;