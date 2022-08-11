library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RAM_NxD_2P_1SWR_1SRD is
	generic(	addrBusSize : integer := 5;
				dataBusSize : integer := 8);
	port(	writeClk : in std_logic;
			writeEnable : in std_logic;
			writeAddress : in std_logic_vector((addrBusSize-1) downto 0);
			writeData : in std_logic_vector((dataBusSize-1) downto 0);
			readClk : in std_logic;
			readAddress : in std_logic_vector((addrBusSize-1) downto 0);
			readData : out std_logic_vector((dataBusSize-1) downto 0));
end RAM_NxD_2P_1SWR_1SRD;

architecture Behavioral of RAM_NxD_2P_1SWR_1SRD is
	constant NUM_WORDS : integer := (2 ** addrBusSize);
	subtype TDataWord is std_logic_vector((dataBusSize-1) downto 0);
	type TMemory is array (0 to (NUM_WORDS-1)) of TDataWord;
	signal s_memory : TMemory;
begin
	process(writeClk)
	begin
		if (rising_edge(writeClk)) then
			if (writeEnable = '1') then
				s_memory(to_integer(unsigned(writeAddress))) <= writeData;
			end if;
		end if;
	end process;
	
	process(readClk)
	begin
		if (rising_edge(readClk)) then
			readData <= s_memory(to_integer(unsigned(readAddress)));
		end if;
	end process;	
	
end Behavioral;
