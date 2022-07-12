library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgachargen is
  port (
	 en			: in std_logic; 
	 hpos			: in std_logic_vector (9 downto 0);	-- current VGA horizontal signal position
	 vpos			: in std_logic_vector (9 downto 0);	-- current VGA vertical signal position
	 video_ram_data	: in std_logic_vector(7 downto 0);	-- byte with the ascii code of the char
	 font_row_data		: in std_logic_vector(7 downto 0);	-- byte with one row of bits for the current char
	 video_ram_addr	: out std_logic_vector(11 downto 0); -- address of the char in video ram (points to the ascii code)
	 font_rom_addr		: out std_logic_vector(10 downto 0); -- address of the char in the font rom (points to visual bits)
    pixel_rgb 	: out std_logic_vector(2 downto 0)			 -- pixel to display
  );
end vgachargen;

architecture Behavioral of vgachargen is
	signal base_font_addr: std_logic_vector(6 downto 0);
	signal font_row_addr: std_logic_vector(3 downto 0);
	signal bit_addr: std_logic_vector(2 downto 0); -- font row bit index from 0 to 7
	signal font_bit: std_logic;
begin

	-- build tile RAM read address and output it
	video_ram_addr <= vpos(8 downto 4) & hpos(9 downto 3);
	
	-- font ROM interface
	-- the base address in the font rom is the 7bit ascii code we get from video ram position
	base_font_addr <= video_ram_data(6 downto 0);
	-- the current row of the char in font rom
	font_row_addr <= vpos(3 downto 0); 
	-- the full font rom address (7 bits + 4 bits = 11 bits)
	font_rom_addr <= base_font_addr & font_row_addr;

	-- handle the font_row_data to retrive the needed bit
	-- set the index of the required bit from the current font row
	bit_addr <= std_logic_vector(unsigned(hpos(2 downto 0)) - 1);
	--select the current bit from the current font row
	font_bit <= font_row_data(to_integer(unsigned(not bit_addr)));
	
	-- rgb multiplexing
	process(en, font_bit)
	begin
		if en = '0' then
			pixel_rgb <= "000";
		elsif font_bit = '1' then
			pixel_rgb <= "010";
		else
			pixel_rgb <= "000";
		end if;
	end process;
end Behavioral;
