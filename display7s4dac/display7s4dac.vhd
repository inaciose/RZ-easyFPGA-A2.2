library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display7s4dac is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC; 
			  digin : in STD_LOGIC_VECTOR (15 downto 0);		-- hex/bcd codes to display in the 4 digits
			  digen : in STD_LOGIC_VECTOR (3 downto 0);		-- 4 anode signals to enable/disable the digit
           digsel : out STD_LOGIC_VECTOR (3 downto 0);	-- 4 anode signals to select the digit
           segout : out STD_LOGIC_VECTOR (6 downto 0));	-- cathode patterns for a single 7-segment display
end display7s4dac;

architecture Behavioral of display7s4dac is

	signal s_nibble: STD_LOGIC_VECTOR (3 downto 0);
	signal s_digen: STD_LOGIC;
	
	signal s_counter: STD_LOGIC_VECTOR (19 downto 0); 	-- for creating a refresh period
	signal s_select: STD_LOGIC_VECTOR(1 downto 0);		-- to select the digit to display/update

begin

	-- Generate cathode patterns to one 7-segment LED display 
	process(s_nibble, s_digen)
	begin
		if(s_digen = '0') then
			segout <= "1111111"; -- ""
		else
			case s_nibble is
				when "0000" => segout <= "1000000"; -- "0"     
				when "0001" => segout <= "1111001"; -- "1" 
				when "0010" => segout <= "0100100"; -- "2" 
				when "0011" => segout <= "0110000"; -- "3" 
				when "0100" => segout <= "0011001"; -- "4" 
				when "0101" => segout <= "0010010"; -- "5" 
				when "0110" => segout <= "0000010"; -- "6" 
				when "0111" => segout <= "1111000"; -- "7" 
				when "1000" => segout <= "0000000"; -- "8"     
				when "1001" => segout <= "0010000"; -- "9" 
				when "1010" => segout <= "0001000"; -- a
				when "1011" => segout <= "0000011"; -- b
				when "1100" => segout <= "1000110"; -- C
				when "1101" => segout <= "0100001"; -- d
				when "1110" => segout <= "0000110"; -- E
				when "1111" => segout <= "0001110"; -- F
			end case;
		end if;	 
	end process;
	
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
	process(s_select, digin, digen)
	begin
		 case s_select is
		 when "00" =>
			  digsel <= "0111"; -- activate HEX3 and Deactivate HEX2, HEX1, HEX0
			  s_digen <= digen(3); -- set enable/disable for HEX3
			  s_nibble <= digin(15 downto 12);-- the first nibble of the 16-bit set
		 when "01" =>
			  digsel <= "1011";
			  s_digen <= digen(2);
			  s_nibble <= digin(11 downto 8);
		 when "10" =>
			  digsel <= "1101";
			  s_digen <= digen(1);
			  s_nibble <= digin(7 downto 4);        
		 when "11" =>
			  digsel <= "1110"; 
			  -- the fourth hex digit of the 16-bit set
			  s_digen <= digen(0);
			  -- activate LED4 and Deactivate LED2, LED3, LED1
			  s_nibble <= digin(3 downto 0);
					
		 end case;
	end process;

end Behavioral;
