library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.threshold_pkg.all;
use work.slogic_pkg.all;

entity threshold_top is
  
  port (
	-----------input----------
		valid_i	:	in std_logic;
		pix_i		:	in slogic;
	------------sync-------------
		rstn_i 	:	in std_logic;
		clk_i  	:	in std_logic;
	----------out------------
		valid_o	:	out std_logic;
		pix_o		:	out slogic
  );
end threshold_top;

architecture arch_threshold_top of threshold_top is

	--signal window_data_w					: 	slogic_window (WINDOW_X -1 downto 0 , WINDOW_Y -1 downto 0);
	signal valid_w							:	std_logic;
	
	signal pix_i_high						:	slogic;
	signal pix_i_low						:	slogic;
	
	signal pix_i_high_result			:	std_logic;
	signal pix_i_low_result				:	std_logic;
	signal and_result						:	std_logic;
	signal exit_multiplex				:	slogic;

begin -- the logic
	
	-- Valid_i to valid_o
	valid_o <= valid_i;
	
	-- Comparacao
	--- high_THRESHOLD
	pix_i_high <= pix_i;
	process (pix_i_high)
	begin
		if pix_i_high >= to_slogic(HIGH_THRESHOLD) then
			pix_i_high_result  <= '1';
		else
			pix_i_high_result  <= '0';
      end if;
	end process;
	---low_THRESHOLD
	pix_i_low <= pix_i;
	process (pix_i_low)
	begin
		if pix_i_low >= to_slogic(LOW_THRESHOLD) then
			pix_i_low_result  <= '1';
		else
			pix_i_low_result  <= '0';
      end if;
	end process;

	--- AND  
	and_result <= (not pix_i_high_result) and pix_i_low_result;
	
	--- Multiplex 4X1
	exit_multiplex <= x"00000000" when (and_result = '0' and pix_i_high_result = '0')else
							STRONG when (and_result = '0' and pix_i_high_result = '1') else
							WEAK when (and_result = '1' and pix_i_high_result = '0') else
							x"00000000";
	
end arch_threshold_top;