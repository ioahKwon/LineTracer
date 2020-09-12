LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY tb_A6_KJW_PJH_2 IS
END tb_A6_KJW_PJH_2;

ARCHITECTURE behavior OF tb_A6_KJW_PJH_2 IS  
    COMPONENT A6_KJW_PJH_2
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         sen_in : IN  std_logic_vector(6 downto 0);
         Light : OUT  std_logic_vector(6 downto 0);
         Led : OUT  std_logic_vector(6 downto 0);
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
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal sen_in : std_logic_vector(6 downto 0) := (others => '0');
   signal Light : std_logic_vector(6 downto 0);
   signal Led : std_logic_vector(6 downto 0);
   signal L_A : std_logic;
   signal L_nA : std_logic;
   signal L_B : std_logic;
   signal L_nB : std_logic;
   signal R_A : std_logic;
   signal R_nA : std_logic;
   signal R_B : std_logic;
   signal R_nB : std_logic;

   constant clk_period : time := 10 ns;
BEGIN
   uut: A6_KJW_PJH_2 PORT MAP (
          reset => reset,
          clk => clk,
          sen_in => sen_in,
          Light => Light,
          Led => Led,
          L_A => L_A,
          L_nA => L_nA,
          L_B => L_B,
          L_nB => L_nB,
          R_A => R_A,
          R_nA => R_nA,
          R_B => R_B,
          R_nB => R_nB
        );
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   stim_proc: process
   begin		
     reset <= '1';
	  sen_in <= "1110111"; wait for 1 ms;
	  sen_in <= "1100111"; wait for 1 ms;
	  sen_in <= "1111011"; wait for 1 ms;
	  sen_in <= "1101111"; wait for 1 ms;
	  sen_in <= "1110011"; wait for 1 ms;
	  sen_in <= "1011111"; wait for 1 ms;
	  sen_in <= "1111101"; wait for 1 ms;
   end process;
END;
