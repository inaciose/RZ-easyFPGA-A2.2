library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ROM_8x4 is
	port(address : in std_logic_vector(2 downto 0);
	dataOut : out std_logic_vector(3 downto 0));
end ROM_8x4;
architecture Behavioral of ROM_8x4 is
	subtype TDataWord is std_logic_vector(3 downto 0);
	type TROM is array (0 to 7) of TDataWord;
	constant c_memory: TROM := ("0000", "0001", "0010", "0100",
	"1000", "1111", "1010", "0101");
begin
	dataOut <= c_memory(to_integer(unsigned(address)));
end Behavioral;