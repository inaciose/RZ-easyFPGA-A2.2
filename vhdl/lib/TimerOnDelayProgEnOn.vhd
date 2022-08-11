library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimerOnDelayProgEnOn is
	generic(K : positive := 4);
	port( clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			start : in std_logic;
			target : in std_logic_vector(K-1 downto 0);
			-- outs
			count : out std_logic_vector(K-1 downto 0);
			timerOut : out std_logic);
end TimerOnDelayProgEnOn;

architecture Behavior of TimerOnDelayProgEnOn is
	signal s_count : integer := 0;
	signal s_target : integer := 0;
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				timerOut <= '0';
				s_count <= 0;
				s_target <= 0;
			elsif (enable = '1') then
				if (start = '1') then
					s_target <= to_integer(unsigned(target));
					timerOut <= '0';
				-- this must be done to get timerOut only one cycle
				elsif (s_count = 0) then
					if (s_target /= 0) then
						s_count <= s_count + 1;
					end if;
					timerOut <= '0';
				else
				--elsif (s_target /= 0) then
					if (s_count = (s_target - 0)) then
						timerOut <= '1';
						s_count <= 0;
						s_target <= 0;
					else
						timerOut <= '0';
						s_count <= s_count + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	count <= std_logic_vector(to_unsigned(s_count, K));
end Behavior;