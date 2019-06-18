------gradiente_top
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.slogic_pkg.all;


entity gradientecontrol is
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
        --ready_o     : out std_logic;
		pix_o       : out slogic
	);
end gradientecontrol;

architecture arch of gradientecontrol is
    signal r_fila   : std_logic_vector(9 downto 0); 
    signal w_soma   : slogic;
    signal w_enable : std_logic:= '1';
    signal w_radical   : STD_LOGIC_VECTOR (2*(MSB+LSB)-1 DOWNTO 0);
    signal w_remainder : STD_LOGIC_VECTOR (32 DOWNTO 0);
    signal w_sqrt_res  : STD_LOGIC_VECTOR(MSB+LSB-1 downto 0);
    
    component sqrtip
	PORT
	(
		clk		: IN STD_LOGIC ;
		ena		: IN STD_LOGIC ;
		radical		: IN STD_LOGIC_VECTOR (2*(MSB+LSB)-1 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (MSB+LSB-1 DOWNTO 0);
		remainder		: OUT STD_LOGIC_VECTOR (32 DOWNTO 0)
	);
END component;

    begin

        w_radical <= std_logic_vector((signed(x_pix_i) * signed(x_pix_i)) + (signed(y_pix_i) * signed(y_pix_i)));
        
        valid_o <= r_fila(9);


        sqrtip_inst : sqrtip PORT MAP (
            clk	            => clk_i,
            ena	            => w_enable,
            radical	        => w_radical,
            q	            => w_sqrt_res,
            remainder	    => w_remainder
        );

        p_SHIFT : process(clk_i)
        begin
            if (rising_edge(clk_i)) then
                r_fila <= r_fila(8 downto 0) & valid_i;
            end if;
        end process; -- p_atual
        
        pix_o <= slogic(w_sqrt_res);
   
end arch ; -- arch
