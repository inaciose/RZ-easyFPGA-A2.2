library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecN_PEn is 
	generic (N		: natural := 4);	
	
	port (	enable 	: in std_logic;
				din		: in std_logic_vector (N-1 downto 0);
				dout		: out std_logic_vector (2**N-1 downto 0));
end DecN_PEn;

architecture Behavioral of DecN_PEn is
begin 
	dec_proc: process(enable, din)
	begin
		if (enable = '0') then
			dout <= (others => '0');
		else 
			-- set all the outputs to '0' to avoid inferred latches
			dout <= (others => '0');
			-- Set input in correct line
			dout(to_integer(unsigned(din))) <= '1';
		end if;
	end process;
end Behavioral;