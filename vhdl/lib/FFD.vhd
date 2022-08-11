library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FFD is
	port( clk     : in std_logic;
			dataIn  : in std_logic;
			dataOut : out std_logic);
end FFD;

architecture Behav of FFD is
begin
	process(clk)
	begin
		if (clk'event and clk = '1') then
			dataOut <= dataIn;
		end if;
	end process;
end Behav;