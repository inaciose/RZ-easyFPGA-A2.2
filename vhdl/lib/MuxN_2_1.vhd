-- mux 2_1 de narramentos de N bits

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MuxN_2_1 is
	generic (N : natural := 8);
	port(	sel  : in std_logic;
			din0 : in std_logic_vector(N-1 downto 0);
			din1 : in std_logic_vector(N-1 downto 0);
			dout : out std_logic_vector(N-1 downto 0));
end MuxN_2_1;

architecture Behavioral of MuxN_2_1 is
begin
	process(sel, din0, din1)
	begin
		if (sel = '0') then
			dout <= din0;
		else
			dout <= din1;
		end if;
	end process;
end Behavioral;