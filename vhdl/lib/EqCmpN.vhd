library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity EqCmpN is
	generic(N : positive := 8);
	port(din0 : in std_logic_vector((N - 1) downto 0);
		  din1 : in std_logic_vector((N - 1) downto 0);
		  dout : out std_logic);
end EqCmpN;

architecture Behavioral of EqCmpN is
begin
	dout <= '1' when (din0 = din1) else
	'0';
end Behavioral;