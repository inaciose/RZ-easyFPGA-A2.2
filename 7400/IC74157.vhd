-- 74157, 74x157, 74LS157, 74HC157
-- Quad 2-Line to 1-Line Data Selector/Multiplexer (with enable)

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC74157 is
	port(	G_N  : in std_logic;
			S  : in std_logic;
			A : in std_logic_vector(3 downto 0);
			B : in std_logic_vector(3 downto 0);
			Y : out std_logic_vector(3 downto 0));
end IC74157;

architecture Behavioral of IC74157 is
begin
	process(G_N, S, A, B)
	begin
		if (G_N = '0') then
			if (S = '0') then
				Y <= A;
			else
				Y <= B;
			end if;
		else
			Y <= "0000";
		end if;
	end process;
end Behavioral;
