library ieee;
use ieee.std_logic_1164.all;
library work;
use work.slogic_pkg.all;

package theta_pkg is
	----------size--------------------
	constant IMAGE_X				: integer := 10;
	constant IMAGE_Y				: integer := 10;
	constant SIZE_IMAGE			: integer := IMAGE_X * IMAGE_Y;
	constant REGS_QT				: integer := 22;
	constant SIZE_REGIS_COMP	: integer := SIZE_IMAGE;

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

  component register1
  	generic(
  		TAMNHO_REGS : integer
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
  end component register1;

  component register_desl
  	generic(
  		TAMNHO_REGS : integer
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
  END component register_desl;

end theta_pkg;
