library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity topshell is
	port(	CLOCK_50 : in std_logic;
			KEY		: in	std_logic_vector(4 downto 0);
			LEDG		: out	std_logic_vector(3 downto 0);	
			UART_TXD : out std_logic;
			UART_RXD : in std_logic;
			BEEP		: out std_logic;
			PS2_CLK  : inout std_logic;									-- PIN_119
			PS2_DAT  : inout std_logic;									-- PIN_120
			VGA_R		: out std_logic; -- pin 106
			VGA_G		: out std_logic; -- pin 105
			VGA_B		: out std_logic; -- pin 104
			VGA_HS 	: out std_logic; -- Pin 101
			VGA_VS 	: out std_logic; -- Pin 103
			SEG		: out	std_logic_vector(6 downto 0);		-- pins 124, 126, 132, 129, 125, 121, 128
			DIG		: out	std_logic_vector(3 downto 0)); 	-- pins 137, 136, 135, 133
end topshell;

architecture Shell of topshell is

	signal s_key : std_logic_vector(4 downto 0);
	signal s_ledg : std_logic_vector(3 downto 0) := "0000";
	
	-- signals from de2-115 format to convert to muxed digits
	signal s_hex0 : std_logic_vector(6 downto 0);
	signal s_hex1 : std_logic_vector(6 downto 0);
	signal s_hex2 : std_logic_vector(6 downto 0);
	signal s_hex3 : std_logic_vector(6 downto 0);
	
	-- inexistent inputs
	signal s_sw : std_logic_vector(7 downto 0) := "00000000";
	--signal s_ledr : std_logic_vector(7 downto 0) := "00000000";
	
	--signal s_clk : std_logic := '0';
	signal s_reset : std_logic := '0';
	
begin

	-- sicroniza os inputs
	sync_input : process(CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			s_key <= KEY;
		end if;
	end process;
	
	s_reset <= s_key(4);
	
	-- set switches
	s_sw(0) <= '0';
	s_sw(1) <= '0';
	s_sw(2) <= '0';
	
	-- if led is active high
	LEDG <= not(s_ledg);
	
	-- defaults for inexistent inputs
	--s_sw <= (others => '0');
	--s_sw(0) <= not(s_key(4));
	--s_sw(0) <= '0';
						--SW => s_sw,
						--LEDR => s_ledr,
						--LEDG => s_ledg,		
	
		shelled :
		entity work.Z80_VGA(struct)
			port map(clk => CLOCK_50,
						n_reset => s_reset,
						
						rxd => UART_RXD,
						txd => UART_TXD,
						rts => open,
						
						videoR3 => VGA_R,
						videoG4 => VGA_G,
						videoB3 => VGA_B,	
						hSync	  => VGA_HS,
						vSync	  => VGA_VS,
						
						switch0 => s_sw(0),
						switch1 => s_sw(1),
						switch2 => s_sw(2),

						LED1 => s_ledg(0),
						LED2 => s_ledg(1),
						LED3 => s_ledg(2),
						LED4 => s_ledg(3),
						
						BUZZER => BEEP,
		
						ps2Clk => PS2_CLK,
						ps2Data => PS2_DAT
						--HEX3 => s_hex3,
						--HEX2 => s_hex2,
						--HEX1 => s_hex1,
						--HEX0 => s_hex0
						);
					
						
						
	--display:
	--	entity work.display7smux4d(Behavioral)
	--		port map(clock => CLOCK_50,
	--					reset => '0',
	--					hex0 => s_hex0,
	--					hex1 => s_hex1,
	--					hex2 => s_hex2,
	--					hex3 => s_hex3,
	--					digsel => DIG,
	--					segout => SEG);
						
end Shell;					