-- 74283, 74x283, 74LS283, 74HC283
-- 4-Bit Binary Adder with Fast Carry
-- this is not a implementation with fast carry
-- as the real 74283 have

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity IC74283 is
	port( A  : in std_logic_vector(3 downto 0);
			B  : in std_logic_vector(3 downto 0);
			C0 : in std_logic;
			S  : out std_logic_vector(3 downto 0);
			C4 : out std_logic);
end IC74283;

architecture Behavioral of IC74283 is
	signal s_operand0, s_operand1, s_carryin, s_result : unsigned(4 downto 0);
begin
	s_operand0 <= '0' & unsigned(A);
	s_operand1 <= '0' & unsigned(B);
	s_carryin <= "0000" & C0;
	s_result   <= s_operand0 + s_carryin + s_operand1;
	S  <= std_logic_vector(s_result(3 downto 0));
	C4 <= std_logic(s_result(4));
end Behavioral;
