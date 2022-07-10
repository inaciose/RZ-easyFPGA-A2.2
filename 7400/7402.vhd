-- 7402, 74x02, 74LS02, 74HC02
-- Quad 2-Input NOR Gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC7402 is
	port( A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			Y  : out std_logic_vector(3 downto 0));
end IC7402;

architecture Behavioral of IC7402 is
begin
	Y(0) <= not(A(0) or B(0));
	Y(1) <= not(A(1) or B(1));
	Y(2) <= not(A(2) or B(2));
	Y(3) <= not(A(3) or B(3));
end Behavioral;
