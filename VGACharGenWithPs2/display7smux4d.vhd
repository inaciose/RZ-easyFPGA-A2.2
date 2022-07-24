library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display7smux4d is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC; 
			  hex0  : in STD_LOGIC_VECTOR (6 downto 0);
			  hex1  : in STD_LOGIC_VECTOR (6 downto 0);
			  hex2  : in STD_LOGIC_VECTOR (6 downto 0);
			  hex3  : in STD_LOGIC_VECTOR (6 downto 0);
           digsel : out STD_LOGIC_VECTOR (3 downto 0);	-- 4 anode signals to select the digit
           segout : out STD_LOGIC_VECTOR (6 downto 0));	-- cathode patterns for a single 7-segment display
end display7smux4d;

architecture Behavioral of display7smux4d is

	--signal s_nibble: STD_LOGIC_VECTOR (3 downto 0);
	signal s_digen: STD_LOGIC;
	
	signal s_counter: STD_LOGIC_VECTOR (19 downto 0); 	-- for creating a refresh period
	signal s_select: STD_LOGIC_VECTOR(1 downto 0);		-- to select the digit to display/update

begin

	-- Generate refresh period of 10.5ms
	process(clock,reset)
	begin 
		 if(reset='1') then
			  s_counter <= (others => '0');
		 elsif(rising_edge(clock)) then
			  s_counter <= s_counter + 1;
		 end if;
	end process;
	
	-- helper signal to anode activating for the 4 LED displays 
	s_select <= s_counter(19 downto 18);
	
	-- Controller for the 4 LED displays 
	--	just mux hex0 to hex3 during time
	process(s_select, hex0, hex1, hex2, hex3)
	begin
		 case s_select is
		 when "00" =>
			  digsel <= "1110";
			  segout <= hex0;
		 when "01" =>
			  digsel <= "1101";
			  segout <= hex1;
		 when "10" =>
			  digsel <= "1011";
			  segout <= hex2;        
		 when "11" =>
			  digsel <= "0111"; 
			  segout <= hex3;					
		 end case;
	end process;

end Behavioral;