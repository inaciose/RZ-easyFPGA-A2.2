library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux3_1 is
	port( sel    : in std_logic_vector (1 downto 0);
			din0 : in std_logic;
			din1 : in std_logic;
			din2 : in std_logic;
			dout : out std_logic);
end Mux3_1;

architecture Behavioral of Mux3_1 is
begin
	process(sel, din0, din1, din2)
	begin
		if (sel = "00") then
			dout <= din0;
		elsif (sel = "01") then
			dout <= din1;
		else
			dout <= din2;
		end if;
	end process;
end Behavioral;