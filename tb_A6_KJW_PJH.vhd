
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_A6_KJW_PJH IS
END tb_A6_KJW_PJH;
 
ARCHITECTURE behavior OF tb_A6_KJW_PJH IS  
    COMPONENT A6_KJW_PJH
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         sen_in : IN  std_logic_vector(6 downto 0);
         Light : OUT  std_logic_vector(6 downto 0);
         Led : OUT  std_logic_vector(6 downto 0);
         LHz : OUT std_logic_vector(8 downto 0);
			RHz : OUT std_logic_vector(8 downto 0);
			L_A : OUT  std_logic;
         L_nA : OUT  std_logic;
         L_B : OUT  std_logic;
         L_nB : OUT  std_logic;
         R_A : OUT  std_logic;
         R_nA : OUT  std_logic;
         R_B : OUT  std_logic;
         R_nB : OUT  std_logic
        );
    END COMPONENT;
	 
   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal sen_in : std_logic_vector(6 downto 0) := (others => '0');

 	--Outputs
   signal Light : std_logic_vector(6 downto 0);
   signal Led : std_logic_vector(6 downto 0);
   signal LHz : std_logic_vector(8 downto 0);
	signal RHz : std_logic_vector(8 downto 0);
	signal L_A : std_logic;
   signal L_nA : std_logic;
   signal L_B : std_logic;
   signal L_nB : std_logic;
   signal R_A : std_logic;
   signal R_nA : std_logic;
   signal R_B : std_logic;
   signal R_nB : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: A6_KJW_PJH PORT MAP (
          reset => reset,
          clk => clk,
          sen_in => sen_in,
          Light => Light,
          Led => Led,
			 LHz => LHz,
			 RHz => RHz,
          L_A => L_A,
          L_nA => L_nA,
          L_B => L_B,
          L_nB => L_nB,
          R_A => R_A,
          R_nA => R_nA,
          R_B => R_B,
          R_nB => R_nB
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      Sen_in <= "1110111"; wait for 2 ms;
      Sen_in <= "1111011"; wait for 2 ms;
      Sen_in <= "1110111"; wait for 2 ms;
      Sen_in <= "1101111"; wait for 2 ms;
      Sen_in <= "1110111"; wait for 2 ms;
      Sen_in <= "0000000"; wait;
   end process;
END;
