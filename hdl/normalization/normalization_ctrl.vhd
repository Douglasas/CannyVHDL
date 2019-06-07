library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port(
		clk_i : in std_logic;
		rstn_i : in std_logic;
		full_i : in std_logic;
		empty_i : in std_logic;
		
		read_o : out std_logic;
		valid_o : out std_logic
	);
end fsm;

architecture arch of fsm is

	type t_state is (s_IDLE, s_division, s_last_pix, s_normalize);
	signal atual, proximo : t_state;
	
	begin
		
		u_atual: process(atual, rstn_i, clk_i)
		begin
			if (rstn_i = '0') then
				 atual <= s_IDLE;
			elsif (rising_edge(clk_i)) then
				atual <= proximo;
			end if;
		end process;
		
		u_proximo: process(atual, full_i, empty_i)
		BEGIN
			case atual is
				when s_IDLE =>
					if (full_i = '1') then
						proximo <= s_division;
					else
						proximo <= s_IDLE;
					end if;
				when s_division =>
					proximo <= s_normalize;
				when s_normalize =>
					if (empty_i = '0') then
						proximo <= s_normalize;
					else
						proximo <= s_last_pix;
					end if;
				when s_last_pix =>
					proximo <= s_IDLE;
			end case;
		end process;
		
		read_o <= '1' when (atual = s_division or atual = s_normalize) else '0';
		valid_o <= '1' when (atual = s_normalize or atual = s_last_pix) else '0';

end arch;