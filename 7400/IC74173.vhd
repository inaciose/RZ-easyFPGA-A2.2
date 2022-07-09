-- 74173, 74x173, 74LS173, 74HC173
-- 4-BIT D-TYPE REGISTERS WITH 3-STATE OUTPUTS

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC74173 is
	port(clk 		: in  std_logic;
		  clr			: in  std_logic;
		  g1n, g2n	: in  std_logic;
		  mn, nn		: in  std_logic;
		  d			: in  std_logic_vector(3 downto 0);
		  q	 		: out std_logic_vector(3 downto 0));
end IC74173;

architecture Behavioral of IC74173 is
	signal s_q : std_logic_vector(3 downto 0) := (others => 'Z');
begin
	reg_proc : process(clr, clk)
	begin
		if (clr = '1') then
			s_q <= (others => '0');
		elsif (rising_edge(clk)) then
			if (g1n = '0' AND g2n = '0') then
				s_q <= d;
			end if;
		end if;
	end process;
	q <= s_q when (mn = '0' AND nn = '0') else (others => 'Z');
end Behavioral;
