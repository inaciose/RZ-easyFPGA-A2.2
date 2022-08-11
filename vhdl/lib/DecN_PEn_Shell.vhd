library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DecN_PEn_Shell is
	port(	SW		: 	in	std_logic_vector(2 downto 0);
			LEDG	:	out std_logic_vector(3 downto 0));
end DecN_PEn_Shell;

architecture Shell of DecN_PEn_Shell is
begin
	system_core	:	entity work.DecN_PEn(Behavioral)
						generic map ( N => 2)
						port map(	enable	=> SW(2),
										din	=> SW(1 downto 0),
										dout 	=> LEDG(3 downto 0));

end Shell;