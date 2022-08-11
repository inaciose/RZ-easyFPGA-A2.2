library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FFDNEnRst is
	generic(N : positive := 8);
	port( reset   : in std_logic;
			clk     : in std_logic;
			enable  : in std_logic;
			dataIn  : in std_logic_vector((N-1) downto 0);
			dataOut : out std_logic_vector((N-1) downto 0));
end FFDNEnRst;

architecture Behavior of FFDNEnRst is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				dataOut <= (others => '0');
			elsif (enable = '1') then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end Behavior;