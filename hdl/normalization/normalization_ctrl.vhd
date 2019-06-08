library ieee;
use ieee.std_logic_1164.all;

entity normalization_ctrl is
	port(
    full_i : in std_logic;
    empty_i : in std_logic;

		clk_i : in std_logic;
		rstn_i : in std_logic;

		read_o : out std_logic;
		valid_o : out std_logic
	);
end normalization_ctrl;

architecture arch of normalization_ctrl is

	type t_state is (s_IDLE, s_read_fifo, s_division, s_last_pix, s_normalize);
	signal current_st, next_st : t_state;

	begin

		u_current_st: process(current_st, rstn_i, clk_i)
		begin
			if (rstn_i = '0') then
				 current_st <= s_IDLE;
			elsif (rising_edge(clk_i)) then
				current_st <= next_st;
			end if;
		end process;

		u_next_st: process(current_st, full_i, empty_i)
		BEGIN
			case current_st is
				when s_IDLE =>
					if (full_i = '1') then
						next_st <= s_read_fifo;
					else
						next_st <= s_IDLE;
					end if;

				when s_read_fifo =>
					next_st <= s_division;

				when s_division =>
					next_st <= s_normalize;

				when s_normalize =>
					if (empty_i = '0') then
						next_st <= s_normalize;
					else
						next_st <= s_last_pix;
					end if;

				when s_last_pix =>
					next_st <= s_IDLE;
			end case;
		end process;

		read_o  <= '1' when (current_st = s_division or current_st = s_normalize or current_st = s_read_fifo) else '0';
		valid_o <= '1' when (current_st = s_normalize or current_st = s_last_pix) else '0';

end arch;
