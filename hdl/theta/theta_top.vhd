LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
use work.slogic_pkg.all;
use work.theta_pkg.all;
use work.fifo_pkg.all;
use work.atan2_pkg.all;

entity theta_top is
port(
-------------input------------------
		valid_i		:	in 	std_logic;
		y_pix_i		:	in		slogic := x"00400000"; 
		x_pix_i		:	in		slogic := x"00400000"; 
		read_out_i	:	in 	std_logic ;
-------------sync-------------------
		rstn_i		:	in		std_logic;
		clk_i			:	in		std_logic;
--------------output---------------
		empty_o		:	out	std_logic;
		theta_o		:	out	slogic
);
end theta_top;

architecture arc of theta_top is 
	signal enable_val_or_ena_w 	: std_logic;
	signal angle_to_fifo_data_i_w	: slogic;
	signal full_o_w					: std_logic;
	signal ena_last					: std_logic;
	
	--------------signal de controle do resgistrador que conta pixel-------------
	signal entrada_regs_cont_pix_w : integer;
	signal saida_regs_cont_pix_w :integer;
	
	--------------signal de controle do resgistrador de ena_last-------------
	signal entrada_regs_ena_last_w :std_logic;
	signal saida_regs_ena_last_w :std_logic;
	
	
	
begin
	cordic_atan2_top_i : atan2
		  port map (
			numx_i	=>	x_pix_i,
			numy_i	=>	y_pix_i,
			enable_i => enable_val_or_ena_w,
			rstn_i	=> rstn_i,
			clk_i    => clk_i,
			angle_o  => angle_to_fifo_data_i_w
			);
			
	fifo_top	:	fifo
			generic map(	
				FIFO_SIZE => SIZE_IMAGE
			 )
			port map	(
			 write_i	=>	saida_regs_ena_last_w,
			 read_i	=>	read_out_i,
			 data_i	=>	angle_to_fifo_data_i_w,
			 clk_i	=>	clk_i,
			 rstn_i	=>	rstn_i,
			 full_o	=>	full_o_w,
			 empty_o	=>	empty_o,
			 data_o	=>	theta_o			
			);

	register1_cont_pix: register1
			generic map(
				TAMNHO_REGS => SIZE_IMAGE
			)
			port map(
			 set_i 		=> entrada_regs_cont_pix_w,
			 valid_i		=> valid_i,
			 rstn_i		=> rstn_i,
			 clk_i		=> clk_i,
			 regi_out	=> saida_regs_cont_pix_w
			);
			
	register1_ena_last: register_desl
			generic map(
				TAMNHO_REGS => REGS_QT
			)
			port map(
			 set_i 		=> valid_i,
			 valid_i		=> '1',
			 rstn_i		=> rstn_i,
			 clk_i		=> clk_i,
			 regis_out	=> saida_regs_ena_last_w
			);

entrada_regs_cont_pix_w <= saida_regs_cont_pix_w + 1;


ena_last <=  '1' when saida_regs_cont_pix_w = SIZE_IMAGE else
				 '0';
						
enable_val_or_ena_w	<= '1' when valid_i = '1' or ena_last = '1' else
							'0';
	
end arc;