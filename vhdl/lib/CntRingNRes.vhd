library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CntRingNRes is
	generic ( N : integer:=4 );
	port ( 
	 CLK: in std_logic; -- clock
	 RESET: in std_logic; -- reset
	 Q_OUT: out std_logic_vector(N-1 downto 0) -- output
	 );
end CntRingNRes;

architecture BehavioralAsyn of CntRingNRes is
	signal not_QN: std_logic;
	signal Q : std_logic_vector(N-1 downto 0):=(others => '0');
begin
	not_QN <= not Q(N-1);
	process(CLK,RESET)
	begin
		if(RESET='1') then -- asynchronous reset
			Q <= (others => '0');
		elsif(rising_edge(CLK)) then
			Q <= Q(N-2 downto 0) & not_QN;
		end if;
	end process;
	Q_OUT <= Q;
end BehavioralAsyn;

architecture BehavioralSyn of CntRingNRes is
	signal not_QN: std_logic;
	signal Q : std_logic_vector(N-1 downto 0):=(others => '0');
begin
	not_QN <= not Q(N-1);
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(RESET='1') then -- synchronous reset
				Q <= (others => '0');
			else		
				Q <= Q(N-2 downto 0) & not_QN;
			end if;
		end if;
	end process;
	Q_OUT <= Q;
end BehavioralSyn;