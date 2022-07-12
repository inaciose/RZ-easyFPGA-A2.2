-- check if the demo object pixel is to be displayed at 
-- the current VGA position (synched signal position)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA640_chkpos is
  port (
    hcur, vcur : in std_logic_vector (9 downto 0); -- coming from vga controller
	 hpos, vpos : in integer; -- current object position
	 size       : in integer; -- object size
    draw       : out boolean
  );
end VGA640_chkpos;

architecture rtl of VGA640_chkpos is
begin

	draw <= to_integer(unsigned(hcur)) > hpos and to_integer(unsigned(hcur)) < (hpos + size) and to_integer(unsigned(vcur)) > vpos and to_integer(unsigned(vcur)) < (vpos + size);

end rtl;
