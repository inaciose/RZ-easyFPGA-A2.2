library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgachargenkbd2_demo is
  port (
    CLOCK_50   : in std_logic; -- Pin 23, 50MHz from the onboard oscilator.
	 KEY 			: in	std_logic_vector(4 downto 0);	
	 LEDG 		: out	std_logic_vector(3 downto 0);		 
	 PS2_CLK 	: in std_logic; -- PIN_119
	 PS2_DAT 	: in std_logic; -- PIN_120
	 VGA_R		: out std_logic; -- pin 106
	 VGA_G		: out std_logic; -- pin 105
	 VGA_B		: out std_logic; -- pin 104
    VGA_HS 		: out std_logic; -- Pin 101
    VGA_VS 		: out std_logic; -- Pin 103
	 SEG		: out	std_logic_vector(6 downto 0);		-- pins 124, 126, 132, 129, 125, 121, 128
	 DIG		: out	std_logic_vector(3 downto 0) 	-- pins 137, 136, 135, 133
);
end vgachargenkbd2_demo;

architecture rtl of vgachargenkbd2_demo is
	
	signal s_key : std_logic_vector(4 downto 0);
	signal s_reset : std_logic;
	
	-- signals coming from PS2Kbd decoder
	signal ps2_code : std_logic_vector(7 downto 0);
	signal ps2_has_new_code : std_logic := '0';
	
	signal ascii_code : std_logic_vector(6 downto 0);
	signal ascii_has_new_code : std_logic := '0';
	
	-- signal from register to display last key
	signal s_keycode : std_logic_vector(7 downto 0);
	signal s_asciicode : std_logic_vector(7 downto 0);

	-- memory position for the next char at video memory
	signal char_index: std_logic_vector(11 downto 0);

	
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
	
	-- video attr ram attributes
	signal video_char_attr_word: std_logic_vector(7 downto 0);
	-- video attr ram write signals (not used for now)
	signal video_attr_write_enable  : std_logic := '0';
	signal video_attr_write_addr: std_logic_vector(11 downto 0);
	signal video_attr_write_word: std_logic_vector(7 downto 0);
	
	signal video_char_blink  : std_logic := '0';


	-- signals for muxed hex digits
	signal s_hex0 : std_logic_vector(6 downto 0);
	signal s_hex1 : std_logic_vector(6 downto 0);
	signal s_hex2 : std_logic_vector(6 downto 0);
	signal s_hex3 : std_logic_vector(6 downto 0);
	
begin

	-- sicroniza os inputs
	sync_input : process(CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			s_key <= KEY;
		end if;
	end process;
	
	s_reset <= not s_key(4);


	-- We need 25MHz for the VGA so we divide the input clock by 2
	clk_div2 : process (CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			vga_clk <= not vga_clk;
		end if;
	end process;

	keyboard : 
	entity work.keyboard_to_ascii(behavior)
		port map(
			clk      => CLOCK_50,			-- base clock
			ps2_clk          => PS2_CLK,	-- input ps2 clock from kb pin
			ps2_data         => PS2_DAT,  -- input ps2 data from kb pin
			key_code         => ps2_code,	-- output keycode
			key_new => ps2_has_new_code, --output announcing that a valid key is pressed
			ascii_code         => ascii_code,	-- output keycode (7 bits)
			ascii_new => ascii_has_new_code --output announcing that a valid ascci is available
			
		);	

	LEDG(0) <= not ps2_has_new_code;	
	LEDG(1) <= not ps2_has_new_code;	
	LEDG(2) <= not ascii_has_new_code;	
	LEDG(3) <= not ascii_has_new_code;	
		
	-- last key register (with async reset)
	last_key_register : 
	process(CLOCK_50, s_reset)
	begin
		if(s_reset = '1') then
			s_keycode <= (others => '0');
		else
			if (rising_edge(CLOCK_50)) then
				if(ps2_has_new_code = '1') then
					s_keycode <= ps2_code;
				end if;
			end if;
		end if;
	end process;

	-- last ascii register (with async reset)
	last_ascii_register : 
	process(CLOCK_50, s_reset)
	begin
		if(s_reset = '1') then
			s_asciicode <= (others => '0');
		else
			if (rising_edge(CLOCK_50)) then
				if(ascii_has_new_code = '1') then
					s_asciicode <= '0' & ascii_code;
				end if;
			end if;
		end if;
	end process;

	

	-- instantiate position counter
	position_counter: entity work.CntNUpEnRes(Behavioral)
		generic map( N => 12)
		port map(
			clk => ascii_has_new_code,
			reset => s_reset,
			--enable => ascii_has_new_code,
			count => char_index
		);

	video_char_write_addr <= char_index;
	video_char_write_enable <= ascii_has_new_code;
	video_char_write_word <= s_asciicode;

	blink_cursor :
	process(CLOCK_50, s_reset)
	begin
			--video_attr_write_enable <= '0';
			if (rising_edge(CLOCK_50)) then
				if(ascii_has_new_code = '1') then
					video_attr_write_addr <= char_index;
					video_attr_write_enable <= ascii_has_new_code;	
					video_attr_write_word <= "01000000";
				else
					video_attr_write_addr <= std_logic_vector(unsigned(char_index) + 1);
					video_attr_write_enable <= '1';	
					video_attr_write_word <= "01000001";

				end if;
			end if;

	end process;

	
	
	--video_attr_write_addr <= char_index;
	--video_attr_write_enable <= ascii_has_new_code;	
	--video_attr_write_word <= "01000001";
	
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
		
	-- instantiate video char attributes ram
	video_attr_ram: entity work.video_attr_ram(Behavioral)
		port map(
			writeClk => CLOCK_50,
			writeEnable => video_attr_write_enable,
			writeAddress => video_attr_write_addr,
			writeData => video_attr_write_word,
			readClk => vga_clk,
			readAddress => video_char_read_addr,
			readData => video_char_attr_word
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
  
  
  	blink_char:
		entity work.pulse_Lgen(Behavioral)
			generic map(NUMBER_STEPS => 50_000_000)
			port map(reset => s_reset,
						clk => vga_clk,
						blink => video_char_blink);

  
	-- the VGA signal position that comes from VGA640ctrl
	-- include the porches, so in order to use ig we need to
	-- remove an offset from signals before use them in the vgachargen
	pix_hpos <= std_logic_vector(unsigned(hpos) - HDATA_BEGIN);
	pix_vpos <= std_logic_vector(unsigned(vpos) - VDATA_BEGIN);
  
	-- vga character generator unit
	character_generator : entity work.vgachargen(Behavioral)
		port map(
			en     => '1',
			blink     => video_char_blink,
			hpos  => pix_hpos,								-- current VGA horizontal signal position (0-679)
			vpos => pix_vpos,									-- current VGA vertical signal position (0-439)
			video_ram_data   => video_char_read_word,	-- byte with the ascii code of the char
			video_attr_ram_data   => video_char_attr_word,	-- byte with the attributes of current char			
			font_row_data   => font_rom_word,			-- byte with one row of bits for the current char
			video_ram_addr   => video_char_read_addr,	-- address of the char in video ram (points to the ascii code)
			font_rom_addr   => font_rom_addr,			-- address of the char in the font rom (points to visual bits)
			pixel_rgb    => rgb_input						-- pixel to display
		);
	
	
	--
	-- Display on led 7 segments 
	-- 
	
	display0:			
		entity work.dec7SegEn(Behavioral)
			port map(enable => '1',
						binInput => s_keycode(3 downto 0),
						decOut_n => s_hex0);
		
	display1:			
		entity work.dec7SegEn(Behavioral)
			port map(enable => '1',
						binInput => s_keycode(7 downto 4),
						decOut_n => s_hex1);
	
	display2:			
		entity work.dec7SegEn(Behavioral)
			port map(enable => '1',
						binInput => s_asciicode(3 downto 0),
						decOut_n => s_hex2);
						
	display3:			
		entity work.dec7SegEn(Behavioral)
			port map(enable => '1',
						binInput => s_asciicode(7 downto 4),
						decOut_n => s_hex3);
  
  	display:
		entity work.display7smux4d(Behavioral)
			port map(clock => CLOCK_50,
						reset => '0',
						hex0 => s_hex0,
						hex1 => s_hex1,
						hex2 => s_hex2,
						hex3 => s_hex3,
						digsel => DIG,
						segout => SEG);


  
  end architecture;
