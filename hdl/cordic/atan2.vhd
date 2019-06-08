library ieee;
use ieee.std_logic_1164.all;

library work;
use work.slogic_pkg.all;
use work.atan2_pkg.all;

entity atan2 is
  port (
    -- inputs
    numx_i  : in slogic;
    numy_i  : in slogic;
    -- sync
    enable_i : in std_logic;
    clk_i    : in std_logic;
    -- outputs
    angle_o  : out slogic
  );
end entity;

architecture arch of atan2 is
  constant ANGLES_TABLE : slogic_vec(ANGLES_TABLE_SIZE-1 downto 0) := gen_angles_table(ANGLES_TABLE_SIZE);

  signal inputx_r : slogic;
  signal inputy_r : slogic;

  signal angle_w : slogic_vec(0 to ANGLES_TABLE_SIZE);
  signal angle_r : slogic_vec(0 to ANGLES_TABLE_SIZE);
  signal quad_yn_w : std_logic;
  signal quad_yn_r : std_logic_vector(0 to ANGLES_TABLE_SIZE);
  signal numx_w : slogic_vec(0 to ANGLES_TABLE_SIZE);
  signal numy_w : slogic_vec(0 to ANGLES_TABLE_SIZE);
  signal numx_r : slogic_vec(0 to ANGLES_TABLE_SIZE);
  signal numy_r : slogic_vec(0 to ANGLES_TABLE_SIZE);

  signal angle_out_w : slogic;
  signal angle_out_r : slogic;

begin

  -- get inputs
  p_INPUTS : process(clk_i)
  begin
    if enable_i = '1' then
      if rising_edge(clk_i) then
        inputx_r <= numx_i;
        inputy_r <= numy_i;
      end if;
    end if;
  end process;

  -- pre-process
  quad_yn_w <= '1' when inputy_r(MSB+LSB-1) = '1' else '0'; -- y < 0
  numx_w(0) <= -inputx_r when inputx_r(MSB+LSB-1) = '1' else inputx_r; -- x < 0: x = -x
  numy_w(0) <= -inputy_r when inputx_r(MSB+LSB-1) = '1' else inputy_r; -- x < 0: x = -x
  angle_w(0) <= to_slogic(180) when inputx_r(MSB+LSB-1) = '1' else     -- x < 0: a = 180
                to_slogic(360) when inputy_r(MSB+LSB-1) = '1' else     -- y < 0: a = 360
                to_slogic(0);                                          -- a = 0

  p_PRE_PROC : process(clk_i)
  begin
    if enable_i = '1' then
      if rising_edge(clk_i) then
        quad_yn_r(0) <= quad_yn_w;
        numx_r(0)    <= numx_w(0);
        numy_r(0)    <= numy_w(0);
        angle_r(0)   <= angle_w(0);
      end if;
    end if;
  end process;

  -- generate calculations
  gen_MAIN : for i in 1 to ANGLES_TABLE_SIZE generate

    numx_w(i)  <= numx_r(i-1) - shift_right(numy_r(i-1), i-1) when numy_r(i-1)(MSB+LSB-1) = '1' else -- y_prev < 0: sub
                  numx_r(i-1) + shift_right(numy_r(i-1), i-1);                                       -- sum

    numy_w(i)  <= numy_r(i-1) + shift_right(numx_r(i-1), i-1) when numy_r(i-1)(MSB+LSB-1) = '1' else -- y_prev < 0: sum
                  numy_r(i-1) - shift_right(numx_r(i-1), i-1);                                       -- sub

    angle_w(i) <= angle_r(i-1) - ANGLES_TABLE(i-1) when numy_r(i-1)(MSB+LSB-1) = '1' else -- y_prev < 0: sub
                  angle_r(i-1) + ANGLES_TABLE(i-1);                                       -- sum

    p_NUMX : process(clk_i)
    begin
      if enable_i = '1' then
        if rising_edge(clk_i) then
          quad_yn_r(i) <= quad_yn_r(i-1);
          numx_r(i) <= numx_w(i);
          numy_r(i) <= numy_w(i);
          angle_r(i) <= angle_w(i);
        end if;
      end if;
    end process;
  end generate;

  -- output
  angle_out_w <= angle_r(ANGLES_TABLE_SIZE) - to_slogic(360) when quad_yn_r(ANGLES_TABLE_SIZE) = '1' else
                 angle_r(ANGLES_TABLE_SIZE);
  p_OUTPUT : process(clk_i)
  begin
    if enable_i = '1' then
      if rising_edge(clk_i) then
        angle_out_r <= angle_out_w;
      end if;
    end if;
  end process;
  angle_o <= angle_out_r;
end architecture;
