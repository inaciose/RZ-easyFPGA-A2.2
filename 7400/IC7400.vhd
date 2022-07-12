-- 7400, 74x00, 74LS00, 74HC00
-- Quad 2-Input NAND Gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC7400 is
	port( A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			Y  : out std_logic_vector(3 downto 0));
end IC7400;

architecture Behavioral of IC7400 is
begin
	Y(0) <= not(A(0) AND B(0));
	Y(1) <= not(A(1) AND B(1));
	Y(2) <= not(A(2) AND B(2));
	Y(3) <= not(A(3) AND B(3));
end Behavioral;
