library ieee;
use ieee.std_logic_1164.all;

library work;
use work.main_pkg.all;
use work.slogic_pkg.all;
use work.atan2_pkg.all;

package theta_pkg is
	----------size--------------------
	constant IMAGE_X         : integer := INPUT_IMAGE_X-4;
	constant IMAGE_Y         : integer := INPUT_IMAGE_Y-4;
	constant QT_CYCLES_ATAN2 : integer := ANGLES_TABLE_SIZE+2;

  component theta_top is
  	port(
      -------------input------------------
  		valid_i		:	in 	std_logic;
  		y_pix_i		:	in		slogic;
  		x_pix_i		:	in		slogic;
  		read_out_i	:	in 	std_logic;
      -------------sync-------------------
  		rstn_i		:	in		std_logic;
  		clk_i			:	in		std_logic;
      --------------output---------------
  		empty_o		:	out	std_logic;
  		theta_o		:	out	slogic
		);
	end component theta_top;

end theta_pkg;
