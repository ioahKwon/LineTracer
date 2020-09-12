library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity A6_KJW_PJH is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           sen_in : in  STD_LOGIC_vector(6 downto 0);
           Light : out  STD_LOGIC_vector(6 downto 0);
           Led : out  STD_LOGIC_vector(6 downto 0);
			  LHz : out std_logic_vector(8 downto 0);
			  RHz : out std_logic_vector(8 downto 0);
           L_A : out  STD_LOGIC;
           L_nA : out  STD_LOGIC;
           L_B : out  STD_LOGIC;
           L_nB : out  STD_LOGIC;
           R_A : out  STD_LOGIC;
           R_nA : out  STD_LOGIC;
           R_B : out  STD_LOGIC;
           R_nB : out  STD_LOGIC);
end A6_KJW_PJH;

  architecture Behavioral of A6_KJW_PJH is
	signal clk_sen : std_logic;
	signal mtl_speed : std_logic_vector (1 downto 0);
	signal mtr_speed : std_logic_vector (1 downto 0);
	signal speed_l : integer range 0 to 40000;
	signal speed_r : integer range 0 to 40000;
	signal motor_lcnt : integer range 0 to 40000;
	signal phase_lclk : std_logic;
	signal motor_rcnt : integer range 0 to 40000;
	signal phase_rclk : std_logic;
	signal phase_lcnt : std_logic_vector (1 downto 0);
	signal phase_lout : std_logic_vector (3 downto 0);
	signal phase_rcnt : std_logic_vector (1 downto 0);
	signal phase_rout : std_logic_vector (3 downto 0);

--적외선 센서를 위한 클럭 분주
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

--발광 센서 출력
	process(clk_sen)
	begin
	for i in 0 to 6 loop
		light(i) <= clk_sen;
	end loop;
	end process;
--LED 출력	
	process(clk_sen, reset)
	begin
		if reset = '0' then LED <= "0000000";
		elsif falling_edge(clk_sen) then LED <= sen_in;
		end if;
	end process;

--	수광센서에 의한 양쪽 모터의 상태	
	process(Reset, clk_sen)
	begin
		if reset = '0' then
			mtl_speed <= "00"; mtr_speed <= "00";
		elsif falling_edge (clk_sen) then
			case sen_in is
				when "1110111" => mtl_speed <= "10";
					mtr_speed <= "10"; --직진
				when "1101111" => mtl_speed <= "01";
					mtr_speed <= "11"; --좌회전
				when "1111011" => mtl_speed <= "11";
					mtr_speed <= "01"; --우회전
				when others => mtl_speed <= "00";
					mtr_speed <= "00";
			end case;
		end if;
	end process;

--왼쪽 모터의 속도	
	process(mtl_speed)
	begin
		case mtl_speed is
			when "00" => speed_l <= 0;
			when "01" => speed_l <= 10100;
			when "10" => speed_l <= 7999;
			when "11" => speed_l <= 6622;
			when others => speed_l <= 0;
		end case;
	end process;

--오른쪽 모터의 속도	
	process(mtr_speed)
	begin
		case mtr_speed is
			when "00" => speed_r <= 0;
			when "01" => speed_r <= 10100;
			when "10" => speed_r <= 7999;
			when "11" => speed_r <= 6622;
			when others => speed_r <= 0;
		end case;
	end process;
	
	-- Hz 설정
   process(mtl_speed)
   begin
      case mtl_speed is
         when "00" => LHz <= "000000000";
         when "01" => LHz <= "011000110";
         when "10" => LHz <= "011111010";
         when "11" => LHz <= "100101110";
         when others => LHZ <= "000000000";
      end case;
   end process;
   
   process(mtr_speed)
   begin
      case mtr_speed is
         when "00" => RHz <= "000000000";
         when "01" => RHz <= "011000110";
         when "10" => RHz <= "011111010";
         when "11" => RHz <= "100101110";
         when others => RHz <= "000000000";
      end case;
   end process;

--왼쪽 모터의 클럭 분주	
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
	
--오른쪽 모터의 클럭 분주	
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

--1상 여자방식 모터 	
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
				when "00" => phase_lout <= "0001";
				when "01" => phase_lout <= "0010";
				when "10" => phase_lout <= "0100";
				when "11" => phase_lout <= "1000";
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
				when "00" => phase_rout <= "0001";
				when "01" => phase_rout <= "0010";
				when "10" => phase_rout <= "0100";
				when "11" => phase_rout <= "1000";
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