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

  constant HIGH_THRESHOLD : slogic := to_slogic(38);
	constant LOW_THRESHOLD 	: slogic := to_slogic(2);
	constant WEAK           : slogic := to_slogic(75);
	constant STRONG         : slogic := to_slogic(255);

begin

	valid_o <= valid_i;

  pix_o <= STRONG when pix_i >= HIGH_THRESHOLD else
           WEAK   when pix_i >= LOW_THRESHOLD else
           (others => '0');

end arch_threshold_top;
