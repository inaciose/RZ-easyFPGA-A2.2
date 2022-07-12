-- based on the work of fsmiamoto available at:
-- https://github.com/fsmiamoto/EasyFPGA-VGA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA640ctrl_demo is
  port (
    CLOCK_50   : in std_logic; -- Pin 23, 50MHz from the onboard oscilator.
	 VGA_R		: out std_logic; -- pin 106
	 VGA_G		: out std_logic; -- pin 105
	 VGA_B		: out std_logic; -- pin 104
    --rgb   : out std_logic_vector (2 downto 0); -- Pins 106, 105 and 104
    VGA_HS 		: out std_logic; -- Pin 101 (if there is a problem with this pin, set it to user pin in device pin config)
    VGA_VS 		: out std_logic -- Pin 103
  );
end VGA640ctrl_demo;

architecture rtl of VGA640ctrl_demo is

	-- VGA Clock - 25 MHz clock derived from the 50MHz built-in clock
	signal vga_clk : std_logic;

	-- VGA controller signals
	signal rgb_input, rgb_output : std_logic_vector(2 downto 0);
	signal vga_hsync, vga_vsync  : std_logic;
  
	-- output from VGA640ctrl
	signal hpos, vpos            : std_logic_vector (9 downto 0);
	
	--
	-- demo object data
	--
	
	-- color codes (just 2 used)
	constant COLOR_WHITE  : std_logic_vector := "111";
	constant COLOR_YELLOW : std_logic_vector := "110";
	constant COLOR_PURPLE : std_logic_vector := "101";
	constant COLOR_RED    : std_logic_vector := "100";
	constant COLOR_WATER  : std_logic_vector := "011";
	constant COLOR_GREEN  : std_logic_vector := "010";
	constant COLOR_BLUE   : std_logic_vector := "001";
	constant COLOR_BLACK  : std_logic_vector := "000";
	
	-- Values for 640x480 resolution
	-- needed to frame the demo object
	-- should match the values in the VGA640ctrl
	--constant HSYNC_END   : integer := 95;
	constant HDATA_BEGIN : integer := 143;
	constant HDATA_END   : integer := 783;
	--constant HLINE_END   : integer := 799;

	--constant VSYNC_END   : integer := 1;
	constant VDATA_BEGIN : integer := 34;
	constant VDATA_END   : integer := 514;
	--constant VLINE_END   : integer := 524;
	constant H_HALF    : integer := 640 / 2;
	constant V_HALF    : integer := 480 / 2;
	-- object size to display in screen
	constant SQUARE_SIZE  : integer := 30; -- In pixels
	-- object center coordinates (position) in the screen, allowed range and initial value
	signal square_x           : integer range HDATA_BEGIN to HDATA_END := HDATA_BEGIN + H_HALF - SQUARE_SIZE/2;
	signal square_y           : integer range VDATA_BEGIN to VDATA_END := VDATA_BEGIN + V_HALF - SQUARE_SIZE/2;
	
	signal should_draw_square : boolean;
	
begin

	-- We need 25MHz for the VGA so we divide the input clock by 2
	clk_div2 : process (CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			vga_clk <= not vga_clk;
		end if;
	end process;
  
	controller : entity work.VGA640ctrl(rtl)
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

	--
	-- demo object logic
	--
	
	-- check if the demo object pixel is to be displayed
	-- to do it we check if the current VGA pixel position
	--	is in the boundaries of the object, and store the
	-- check result in one signal to select the color to
	-- display that pixel
 	check_pos : entity work.VGA640_chkpos(rtl)
		port map(
			hcur => hpos, 						-- coming from vga controller
			vcur => vpos,						-- coming from vga controller
			hpos => square_x,					-- current object position
			vpos => square_y,					-- current object position
			size => SQUARE_SIZE,				-- object size
			draw => should_draw_square		-- out vpos of the current pixel
		); 
  
	-- select the color to display the current VGA pixel
	select_display_color: process (vga_clk)
	begin
		if (rising_edge(vga_clk)) then
			if (should_draw_square) then
				rgb_input <= COLOR_GREEN;
			else
				rgb_input <= COLOR_BLACK;
			end if;
		end if;
	end process;
  
  end architecture;
