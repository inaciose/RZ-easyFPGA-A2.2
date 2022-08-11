library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity AdderN_cout is
	generic(N : positive := 4);
	port( operand0 : in std_logic_vector(N-1 downto 0);
			operand1 : in std_logic_vector(N-1 downto 0);
			result   : out std_logic_vector(N - 1 downto 0);
			carryOut : out std_logic);
end AdderN_cout;
architecture Behavioral of AdderN_cout is
	signal s_operand0, s_operand1, s_result : unsigned(N downto 0);
begin
	s_operand0 <= '0' & unsigned(operand0);
	s_operand1 <= '0' & unsigned(operand1);
	s_result   <= s_operand0 + s_operand1;
	result     <= std_logic_vector(s_result(N - 1 downto 0));
	carryOut   <= std_logic(s_result(N));
end Behavioral;