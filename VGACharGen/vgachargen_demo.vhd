library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgachargen_demo is
  port (
    CLOCK_50   : in std_logic; -- Pin 23, 50MHz from the onboard oscilator.
	 VGA_R		: out std_logic; -- pin 106
	 VGA_G		: out std_logic; -- pin 105
	 VGA_B		: out std_logic; -- pin 104
    VGA_HS 		: out std_logic; -- Pin 101
    VGA_VS 		: out std_logic -- Pin 103
  );
end vgachargen_demo;

architecture rtl of vgachargen_demo is
	
	-- Values for 640x480 resolution
	-- Values must be the same as the ones
	-- used in VGA640ctrl
	constant HDATA_BEGIN : integer := 143;
	constant VDATA_BEGIN : integer := 34;

	-- VGA Clock - 25 MHz clock derived from the 50MHz built-in clock
	signal vga_clk : std_logic;

	-- VGA controller signals
	signal rgb_input, rgb_output : std_logic_vector(2 downto 0);
	signal vga_hsync, vga_vsync  : std_logic;
  
	-- output from VGA640ctrl
	signal hpos, vpos : std_logic_vector (9 downto 0);
	signal pix_hpos, pix_vpos : std_logic_vector (9 downto 0);
	
	-- font rom
	signal font_rom_addr: std_logic_vector(10 downto 0);
	signal font_rom_word: std_logic_vector(7 downto 0);
	
	-- video ram
	signal video_char_read_addr: std_logic_vector(11 downto 0);
	signal video_char_read_word: std_logic_vector(7 downto 0);
	-- video ram write signals (not used for now)
	signal video_char_write_enable  : std_logic := '0';
	signal video_char_write_addr: std_logic_vector(11 downto 0);
	signal video_char_write_word: std_logic_vector(7 downto 0);
	
begin

	-- We need 25MHz for the VGA so we divide the input clock by 2
	clk_div2 : process (CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			vga_clk <= not vga_clk;
		end if;
	end process;


	-- instantiate font ROM
	font_rom: entity work.font_rom(Behavioral)
		port map(
			clk => vga_clk,
			addr => font_rom_addr,
			data => font_rom_word
		);

	-- instantiate video char ram
	video_ram: entity work.video_ram(Behavioral)
		port map(
			writeClk => CLOCK_50,
			writeEnable => video_char_write_enable,
			writeAddress => video_char_write_addr,
			writeData => video_char_write_word,
			readClk => vga_clk,
			readAddress => video_char_read_addr,
			readData => video_char_read_word
		);

	-- vga controller unit
	vga_controller : entity work.VGA640ctrl(rtl)
		port map(
			clk     => vga_clk, 		-- in VGA 25MHz clock
			rgb_in  => rgb_input,	-- in pixel : std_logic_vector(2 downto 0)
			rgb_out => rgb_output,	-- out to VGA pin : std_logic_vector(2 downto 0)
			hsync   => vga_hsync,	-- out to VGA pin
			vsync   => vga_vsync,	-- out to VGA pin
			hpos    => hpos,			-- out hpos of the current pixel
			vpos    => vpos			-- out vpos of the current pixel
		);
  
	-- output to VGA pina
	VGA_R <= rgb_output(2);
	VGA_G <= rgb_output(1);
	VGA_B <= rgb_output(0);
	VGA_HS <= vga_hsync;
	VGA_VS <= vga_vsync;
  
	-- the VGA signal position that comes from VGA640ctrl
	-- include the porches, so in order to use ig we need to
	-- remove an offset from signals before use them in the vgachargen
	pix_hpos <= std_logic_vector(unsigned(hpos) - HDATA_BEGIN);
	pix_vpos <= std_logic_vector(unsigned(vpos) - VDATA_BEGIN);
  
	-- vga character generator unit
	character_generator : entity work.vgachargen(Behavioral)
		port map(
			en     => '1',
			hpos  => pix_hpos,								-- current VGA horizontal signal position (0-679)
			vpos => pix_vpos,									-- current VGA vertical signal position (0-439)
			video_ram_data   => video_char_read_word,	-- byte with the ascii code of the char
			font_row_data   => font_rom_word,			-- byte with one row of bits for the current char
			video_ram_addr   => video_char_read_addr,	-- address of the char in video ram (points to the ascii code)
			font_rom_addr   => font_rom_addr,			-- address of the char in the font rom (points to visual bits)
			pixel_rgb    => rgb_input						-- pixel to display
		);
	
  end architecture;
