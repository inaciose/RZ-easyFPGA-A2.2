library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ShiftRegN is
	generic(N : positive := 8);
	port(	clk 		: in std_logic;
			loadEn 	: in std_logic;
			dataIn 	: in std_logic_vector(N-1 downto 0);
			dirLeft 	: in std_logic;
			dataOut 	: out std_logic_vector(N-1 downto 0));
end ShiftRegN;

architecture Behavioral of ShiftRegN is
	signal s_shiftReg : std_logic_vector(N-1 downto 0);
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (loadEn = '1') then
				s_shiftReg <= dataIn;
			elsif (dirLeft = '1') then
				s_shiftReg <= s_shiftReg(N-2 downto 0) & '0';
			else
				s_shiftReg <= '0' & s_shiftReg(N-1 downto 1);
			end if;
		end if;
	end process;
	dataOut <= s_shiftReg;
end Behavioral;

architecture BehavioralRotate of ShiftRegN is
	signal s_shiftReg : std_logic_vector(N-1 downto 0);
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (loadEn = '1') then
				s_shiftReg <= dataIn;
			elsif (dirLeft = '1') then
				s_shiftReg <= s_shiftReg(N-2 downto 0) & s_shiftReg(N-1);
			else
				s_shiftReg <= s_shiftReg(0) & s_shiftReg(N-1 downto 1);
			end if;
		end if;
	end process;
	dataOut <= s_shiftReg;
end BehavioralRotate;
