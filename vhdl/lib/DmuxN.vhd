library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DmuxN is 
	generic (N		: natural := 4
	);	
	
	port (	din	: in std_logic;
				sel	: in std_logic_vector (N-1 downto 0);
				dout	: out std_logic_vector (2**N-1 downto 0)
	);
end DmuxN;

architecture Behavioral of DmuxN is

begin 

	demux_pr: process(sel, din)
	begin
		-- set all the outputs to '0' to avoid inferred latches
		dout <= (others => '0');
		-- Set input in correct line
		dout(to_integer(unsigned(sel))) <= din;
	end process;

end Behavioral;