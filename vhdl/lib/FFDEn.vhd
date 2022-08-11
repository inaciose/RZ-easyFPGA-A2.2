library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FFDEn is
	port( clk     : in std_logic;
			enable  : in std_logic;
			dataIn  : in std_logic;
			dataOut : out std_logic);
end FFDEn;

architecture Behav of FFDEn is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (enable = '1') then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end Behav;