library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Mux4_1 is
	port(	inPort	:	in std_logic_vector(3 downto 0);
			selPort	:	in std_logic_vector(1 downto 0);
			outPort	:	out std_logic);
end Mux4_1;

architecture Behavioral of Mux4_1 is
begin
	
	outPort <=	inPort(0) when (selPort = "00") else
					inPort(1) when (selPort = "01") else
					inPort(2) when (selPort = "10") else
					inPort(3) when (selPort = "11");

end Behavioral;