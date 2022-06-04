library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.all;

entity display7s4dac_test is
	port(	CLOCK_50 : in std_logic;
			SEG		: out	std_logic_vector(6 downto 0);		-- pins 124, 126, 132, 129, 125, 121, 128
			DIG		: out	std_logic_vector(3 downto 0)); 	-- pins 137, 136, 135, 133
end display7s4dac_test;

architecture Shell of display7s4dac_test is
	signal s_display4dig7seg : std_logic_vector(15 downto 0);
begin
				
	s_display4dig7seg <= "0001" & "0101" & "0001" & "0111";

	display:
		entity work.display7s4dac(Behavioral)
			port map(clock => CLOCK_50,
						reset => '0',
						digin => s_display4dig7seg,	
						digen => "0101",
						digsel => DIG,
						segout => SEG);
						
end Shell;
