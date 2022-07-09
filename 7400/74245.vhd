-- 74245, 74x245, 74LS245, 74HC245
-- 3-STATE Octal Bus Transceiver

library ieee;
Use ieee.std_logic_1164.all;

entity IC74245 is
port(	G_L, DIR: in std_logic := '1';
		A, B: inout std_logic_vector(7 downto 0));
end IC74245;

architecture behavioral of IC74245 is
begin
	process (G_L, DIR, A,B)
	begin
		if(G_L='0') then
			if(DIR='1') then
				B<=A;
				A<=(others => 'Z');
			elsif (DIR='0') then
				A<=B;
				B<=(others => 'Z');
			else 
				A<=(others => 'Z');
				B<=(others => 'Z');
			end if;
		else
			B<=(others => 'Z');
			A<=(others => 'Z');	
		end if;
end process;
end behavioral;
      
