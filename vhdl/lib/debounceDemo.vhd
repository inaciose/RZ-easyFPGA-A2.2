library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.all;

entity debounceDemo is
	port(	CLOCK_50 : in std_logic;
			KEY		: in	std_logic_vector(1 downto 0);
			LEDG		: out std_logic_vector(1 downto 0));
end debounceDemo;

architecture Shell of debounceDemo is

--signal s_startStop : std_logic;
begin
	debounce_KEY0:
		entity work.DebounceUnit(Behavioral)
			generic map(kHzClkFreq => 50_000,
							mSecMinInWidth => 100,
							inPolarity => '0',
							outPolarity => '1')
			port map(refClk => CLOCK_50,
						dirtyIn => KEY(0),
						pulsedOut => LEDG(0));
end Shell;					

						--pulsedOut => s_startStop);
