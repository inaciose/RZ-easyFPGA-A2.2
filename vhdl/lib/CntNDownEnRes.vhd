library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CntNDownEnRes is
	 generic( N : positive := 4);
	 port(clk 	: in std_logic;
			reset	: in std_logic;
			enable: in std_logic;
			count : out std_logic_vector(N-1 downto 0));
end CntNDownEnRes;

architecture Behavioral of CntNDownEnRes is
	signal s_count : unsigned(N-1 downto 0);
begin
	 process(clk)
	 begin
		 if (rising_edge(clk)) then
			if(reset = '1') then
				s_count <= (others => '0');
			elsif(enable = '1') then
				s_count <= s_count - 1;
			end if;
		 end if;
	 end process;
	 count <= std_logic_vector(s_count);
end Behavioral;
