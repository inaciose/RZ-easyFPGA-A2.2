-- 7486, 74x86, 74LS86, 74HC86
-- Quad 2-Input Exclusive-OR Gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IC7486 is
	port( A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			Y  : out std_logic_vector(3 downto 0));
end IC7486;

architecture Behavioral of IC7486 is
begin
	Y(0) <= A(0) xor B(0);
	Y(1) <= A(1) xor B(1);
	Y(2) <= A(2) xor B(2);
	Y(3) <= A(3) xor B(3);
end Behavioral;
