-- Basic VGA Controller for the RZ EasyFPGA A2.2 board
-- Based on the work of: Francisco Miamoto

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA640ctrl is
  port (
    clk     : in std_logic;							-- VGA clock 25MHZ
    rgb_in  : in std_logic_vector (2 downto 0); -- pixel to output
	 -- sycronized VGA signals to output to monitor
    rgb_out : out std_logic_vector (2 downto 0); -- Pins 106, 105 and 104
    hsync   : out std_logic;	-- PIN_101
    vsync   : out std_logic;	-- PIN_103
	 -- current VGA signal
    hpos    : out std_logic_vector (9 downto 0);
    vpos    : out std_logic_vector (9 downto 0)
	 
  );
end VGA640ctrl;

architecture rtl of VGA640ctrl is
	-- Values for 640x480 resolution
	constant HSYNC_END   : integer := 95;
	constant HDATA_BEGIN : integer := 143;
	constant HDATA_END   : integer := 783;
	constant HLINE_END   : integer := 799;

	constant VSYNC_END   : integer := 1;
	constant VDATA_BEGIN : integer := 34;
	constant VDATA_END   : integer := 514;
	constant VLINE_END   : integer := 524;

	signal hcount : integer range 0 to HLINE_END := 0;
	signal vcount : integer range 0 to VLINE_END := 0;

	signal should_reset_vcount : boolean;
	signal should_reset_hcount : boolean;
	signal should_output_data  : boolean;

begin
	should_reset_vcount <= vcount = VLINE_END;
	should_reset_hcount <= hcount = HLINE_END;
	should_output_data  <= (hcount >= HDATA_BEGIN) and (hcount < HDATA_END) and (vcount >= VDATA_BEGIN) and (vcount < VDATA_END);

	hsync   <= '1' when hcount > HSYNC_END else '0';
	vsync   <= '1' when vcount > VSYNC_END else '0';
	rgb_out <= rgb_in when should_output_data else (others => '0');
	
	-- Output current VGA signal possitions (including invisible left and right areas
	hpos    <= std_logic_vector(to_unsigned(hcount, 10));
	vpos    <= std_logic_vector(to_unsigned(vcount, 10));
	
	process (clk)
	begin
	 if (rising_edge(clk)) then
		if (should_reset_hcount) then
		  hcount <= 0;
		else
		  hcount <= hcount + 1;
		end if;
	 end if;
	end process;

	process (clk)
	begin
	 if (rising_edge(clk) and should_reset_hcount) then
		if (should_reset_vcount) then
		  vcount <= 0;
		else
		  vcount <= vcount + 1;
		end if;
	 end if;
	end process;
end architecture;
