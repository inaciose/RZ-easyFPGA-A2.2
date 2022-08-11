library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FFDEnRst is
	port( reset   : in std_logic;
			clk     : in std_logic;
			enable  : in std_logic;
			dataIn  : in std_logic;
			dataOut : out std_logic);
end FFDEnRst;

architecture BehavRAsyn of FFDEnRst is
begin
	process(reset, clk)
	begin
		if (reset = '1') then
			dataOut <= '0';
		elsif (rising_edge(clk)) then
			if (enable = '1') then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end BehavRAsyn;

architecture BehavRSync of FFDEnRst is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				dataOut <= '0';
			elsif (enable = '1') then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end BehavRSync;
