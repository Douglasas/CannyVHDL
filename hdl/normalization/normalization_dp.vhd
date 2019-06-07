library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.slogic_pkg.all;
use work.fifo_pkg.all;

entity datapath is
	port(
		clk_i : in std_logic;
		rstn_i : in std_logic;
		read_i : in std_logic;
		valid_i : in std_logic;
		pix_i : in slogic;
		full_o : out std_logic;
		empty_o : out std_logic;
		pix_o : out slogic
	);
end entity;

architecture arch of datapath is

	component regis 
	port(
		clk_i : in std_logic;
		rstn_i : in std_logic;
		enable_i : in std_logic;
		data_i : in slogic;
		data_o : out slogic
	);
	end component;
	
	component fifo
    generic (
      FIFO_SIZE : integer
    );
    port (
      data_i  : in  slogic;
      write_i : in  std_logic;
      read_i  : in  std_logic;
      clk_i   : in  std_logic;
      rstn_i  : in  std_logic;
      data_o  : out slogic;
      full_o  : out std_logic;
      empty_o : out std_logic
    );
  end component fifo;
	
	signal w_regis_in, w_regis_max, w_regis_div, w_fifo : slogic;
	signal w_max_comparition : std_logic;
	
	begin
	
		u0_regis_in : regis port map(
			clk_i => clk_i,
			rstn_i => rstn_i,
			enable_i => valid_i,
			data_i => pix_i,
			data_o => w_regis_in
		);
		
		u1_regis_max : regis port map(
			clk_i => clk_i,
			rstn_i => rstn_i,
			enable_i => w_max_comparition,
			data_i => w_regis_in,
			data_o => w_regis_max
		);
		
		u2_regis_div : regis port map(
			clk_i => clk_i,
			rstn_i => rstn_i,
			enable_i => '1',
			data_i => w_regis_div,
			data_o => pix_o
		);
		
		u3_fifo : fifo 
		generic map(
			FIFO_SIZE => 32
		)
		port map(
			data_i => pix_i,
			write_i => valid_i,
			read_i => read_i,
			clk_i => clk_i,
			rstn_i => rstn_i,
			data_o => w_fifo,
			full_o => full_o,
			empty_o => empty_o
		);
		
		w_max_comparition <= '1' when w_regis_in > w_regis_max else '0';
		w_regis_div <= w_fifo / w_regis_max;
	
end architecture;