library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity video_attr_ram is
	generic(	addrBusSize : integer := 12;
				dataBusSize : integer := 8);
	port(	writeClk 		: in std_logic;
			writeEnable 	: in std_logic;
			writeAddress 	: in std_logic_vector((addrBusSize-1) downto 0);
			writeData 		: in std_logic_vector((dataBusSize-1) downto 0);
			readClk 			: in std_logic;
			readAddress 	: in std_logic_vector((addrBusSize-1) downto 0);
			readData 		: out std_logic_vector((dataBusSize-1) downto 0));
end video_attr_ram;

architecture Behavioral of video_attr_ram is
	constant NUM_WORDS : integer := (2 ** addrBusSize);
	subtype TDataWord is std_logic_vector((dataBusSize-1) downto 0);
	type TMemory is array (0 to (NUM_WORDS-1)) of TDataWord;
	signal s_memory : TMemory := (

     -- Initial Value of character memory

     -- Line 0
     X"40",X"40",X"42",X"41",X"40",X"81",X"80",X"80",X"40",X"20",X"20",X"50",X"50",X"48",X"48",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 1
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 2
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 3
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 4
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 5
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 6
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 7
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 8
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 9
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 10
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 11
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 12
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 13
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 14
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 15
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 16
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 17
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 18
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 19
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 40
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 21
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 22
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 23
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 24
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 25
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 26
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 27
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 28
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 29
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 30
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     -- Line 31
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
     X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40"
     );

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
