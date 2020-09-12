library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity A6_KJW_PJH_2 is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           sen_in : in  STD_LOGIC_vector(6 downto 0);
           Light : out  STD_LOGIC_vector(6 downto 0);
           Led : out  STD_LOGIC_vector(6 downto 0);
           L_A : out  STD_LOGIC;
           L_nA : out  STD_LOGIC;
           L_B : out  STD_LOGIC;
           L_nB : out  STD_LOGIC;
           R_A : out  STD_LOGIC;
           R_nA : out  STD_LOGIC;
           R_B : out  STD_LOGIC;
           R_nB : out  STD_LOGIC);
end A6_KJW_PJH_2;

  architecture Behavioral of A6_KJW_PJH_2 is
	signal clk_sen : std_logic;
	signal mtl_speed : std_logic_vector (1 downto 0);
	signal mtr_speed : std_logic_vector (1 downto 0);
	signal speed_l : integer range 0 to 25000;
	signal speed_r : integer range 0 to 25000;
	signal motor_lcnt : integer range 0 to 25000;
	signal phase_lclk : std_logic;
	signal motor_rcnt : integer range 0 to 25000;
	signal phase_rclk : std_logic;
	signal phase_lcnt : std_logic_vector (2 downto 0);
	signal phase_lout : std_logic_vector (3 downto 0);
	signal phase_rcnt : std_logic_vector (2 downto 0);
	signal phase_rout : std_logic_vector (3 downto 0);

begin
	process(reset, clk)
	variable cnt : integer range 0 to 5000;
	begin
		if reset = '0' then cnt := 0; clk_sen <= '0';
		elsif rising_edge(clk) then
			if cnt = 3999 then cnt := 0; clk_sen <= not clk_sen;
			else cnt := cnt + 1;
			end if;
		end if;
	end process;
	
	process(clk_sen)
	begin
	for i in 0 to 6 loop
		light(i) <= clk_sen;
	end loop;
	end process;
	
	process(clk_sen, reset)
	begin
		if reset = '0' then LED <= "0000000";
		elsif falling_edge(clk_sen) then LED <= sen_in;
		end if;
	end process;
	
	process(Reset, clk_sen)
	begin
		if reset = '0' then
			mtl_speed <= "00"; mtr_speed <= "00";
		elsif falling_edge (clk_sen) then
			case sen_in is
				when "1110111" => mtl_speed <= "11";
					mtr_speed <= "11"; --직진
				when "1100111" => mtl_speed <= "10";
					mtr_speed <= "11"; --느린 좌회전
				when "1101111" => mtl_speed <= "01";
					mtr_speed <= "11"; --빠른 좌회전
				when "1011111" => mtl_speed <= "01";
					mtr_speed <= "11"; --빠른 좌회전
				when "1110011" => mtl_speed <= "11";
					mtr_speed <= "10"; --느린 우회전
				when "1111011" => mtl_speed <= "11";
					mtr_speed <= "01"; --빠른 우회전
				when "1111101" => mtl_speed <= "11";
					mtr_speed <= "01"; --빠른 우회전
				when others => mtl_speed <= "00"; 
					mtr_speed <= "00"; --정지
			end case;
		end if;
	end process;
	
	process(mtl_speed)
	begin
		case mtl_speed is
			when "00" => speed_l <= 0;
			when "01" => speed_l <= 9999;
			when "10" => speed_l <= 4999;
			when "11" => speed_l <= 2999;
			when others => speed_l <= 2999;
		end case;
	end process;
	
	process(mtr_speed)
	begin
		case mtr_speed is
			when "00" => speed_r <= 0;
			when "01" => speed_r <= 9999;
			when "10" => speed_r <= 4999;
			when "11" => speed_r <= 2999;
			when others => speed_r <= 2999;
		end case;
	end process;
	
	process(reset, speed_l, clk, motor_lcnt)
	begin
		if reset = '0' or speed_l = 0 then
			motor_lcnt <= 0;
			phase_lclk <= '0';
		elsif rising_edge (clk) then
			if (motor_lcnt >= speed_l) then
				motor_lcnt <= 0;
				phase_lclk <= not phase_lclk;
			else motor_lcnt <= motor_lcnt + 1;
		   end if;
		end if;
	end process;
	
	process(reset, speed_r, clk, motor_rcnt)
	begin
		if reset = '0' or speed_r = 0 then
			motor_rcnt <= 0;
			phase_rclk <= '0';
		elsif rising_edge (clk) then
			if (motor_rcnt >= speed_r) then
				motor_rcnt <= 0;
				phase_rclk <= not phase_rclk;
			else motor_rcnt <= motor_rcnt + 1;
		   end if;
		end if;
	end process;
	
	process(reset, phase_lclk, phase_lcnt)
	begin
		if reset = '0' then
			phase_lcnt <= (others => '0');
		elsif rising_edge (phase_lclk) then
			phase_lcnt <= phase_lcnt + 1;
		end if;
	end process;
	
	process(reset, phase_lcnt)
	begin
		if reset = '0' then
			phase_lout <= (others => '0');
		else
			case phase_lcnt is
				when "000" => phase_lout <= "0001";
				when "001" => phase_lout <= "0011";
				when "010" => phase_lout <= "0010";
				when "011" => phase_lout <= "0110";
				when "100" => phase_lout <= "0100";
				when "101" => phase_lout <= "1100";
				when "110" => phase_lout <= "1000";
				when "111" => phase_lout <= "1001";
				when others => phase_lout <= "0000";
			end case;
		end if;
	end process;
	
	process(reset, phase_rclk, phase_rcnt)
	begin
		if reset = '0' then
			phase_rcnt <= (others => '0');
		elsif rising_edge (phase_rclk) then
			phase_rcnt <= phase_rcnt + 1;
		end if;
	end process;
	
	process(reset, phase_rcnt)
	begin
		if reset = '0' then
			phase_rout <= (others => '0');
		else
			case phase_rcnt is
				when "000" => phase_rout <= "0001";
				when "001" => phase_rout <= "0011";
				when "010" => phase_rout <= "0010";
				when "011" => phase_rout <= "0110";
				when "100" => phase_rout <= "0100";
				when "101" => phase_rout <= "1100";
				when "110" => phase_rout <= "1000";
				when "111" => phase_rout <= "1001";
				when others => phase_rout <= "0000";
			end case;
		end if;
	end process;
	
	L_A  <= phase_lout(0);
	L_B  <= phase_lout(1);
	L_nA <= phase_lout(2);
	L_nB <= phase_lout(3);
	R_A  <= phase_rout(0);
	R_B  <= phase_rout(1);
	R_nA <= phase_rout(2);
	R_nB <= phase_rout(3);
end;