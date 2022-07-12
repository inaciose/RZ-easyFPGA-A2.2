-- 7404, 74x04, 74LS04, 74HC04
-- Hex Inverting Gates

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC7404 is
	port( A  : in std_logic_vector(3 downto 0);
			Y  : out std_logic_vector(3 downto 0));
end IC7404;

architecture Behavioral of IC7404 is
begin
	Y(0) <= not(A(0));
	Y(1) <= not(A(1));
	Y(2) <= not(A(2));
	Y(3) <= not(A(3));
end Behavioral;
