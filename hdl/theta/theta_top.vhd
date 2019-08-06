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
		valid_i		 : in std_logic;
		y_pix_i		 : in slogic;
		x_pix_i		 : in slogic;
		read_out_i : in std_logic;
-------------sync-------------------
		rstn_i		 : in std_logic;
		clk_i			 : in std_logic;
--------------output---------------
		empty_o		 : out std_logic;
		theta_o		 : out slogic
);
end theta_top;

architecture arc of theta_top is
  signal fifo_valid_r   : std_logic_vector(QT_CYCLES_ATAN2-1 downto 0);
  signal fifo_full_w    : std_logic;
	signal theta_result_w : slogic;
begin

  p_UPD_VALID_FIFO : process(clk_i, rstn_i)
  begin
    if rstn_i = '0' then
      fifo_valid_r <= (others => '0');
    elsif rising_edge(clk_i) then
      fifo_valid_r <= fifo_valid_r(QT_CYCLES_ATAN2-2 downto 0) & valid_i;
    end if;
  end process;

	cordic_atan2_top_i : atan2
  port map (
  	numx_i   => x_pix_i,
  	numy_i   => y_pix_i,
  	enable_i => '1',
  	clk_i    => clk_i,
  	angle_o  => theta_result_w
	);

  fifo_i : fifo
  generic map (
    FIFO_SIZE => IMAGE_X * IMAGE_Y
  )
  port map (
    write_i => fifo_valid_r(QT_CYCLES_ATAN2-1),
    read_i  => read_out_i,
    data_i  => theta_result_w,
    rstn_i  => rstn_i,
    clk_i   => clk_i,
    full_o  => fifo_full_w,
    empty_o => empty_o,
    data_o  => theta_o
  );


end arc;
