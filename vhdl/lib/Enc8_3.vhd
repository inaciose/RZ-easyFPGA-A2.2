library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Enc8_3 is
     port(	din  : in std_logic_vector(7 downto 0);
				dout : out std_logic_vector(2 downto 0));
end Enc8_3;

architecture Behavioral of Enc8_3 is

signal s_dout : unsigned(2 downto 0);

begin

	s_dout <= 	"111" when (din(7) = '1') else
					"110" when (din(6) = '1') else
					"101" when (din(5) = '1') else
					"100" when (din(4) = '1') else
					"011" when (din(3) = '1') else
					"010" when (din(2) = '1') else
					"001" when (din(1) = '1') else
					"000";
	dout <= std_logic_vector(s_dout(2 downto 0));

end Behavioral;