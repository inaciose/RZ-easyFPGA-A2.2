-- 7408, 74x08, 74LS08, 74HC08
-- Quad 2-Input AND Gates

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC7408 is
	port( A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			Y  : out std_logic_vector(3 downto 0));
end IC7408;

architecture Behavioral of IC7408 is
begin
	Y(0) <= A(0) and B(0);
	Y(1) <= A(1) and B(1);
	Y(2) <= A(2) and B(2);
	Y(3) <= A(3) and B(3);
end Behavioral;
