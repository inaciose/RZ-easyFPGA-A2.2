library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Entidade sem portos
entity CntNDownEnRes_tb is
	generic(N : positive := 4);
end CntNDownEnRes_tb;

architecture Stimulus of CntNDownEnRes_tb is
	-- Sinais para ligar às entradas da UUT
	signal s_reset  : std_logic;
	signal s_clk 	 : std_logic;
	signal s_enable : std_logic;

	-- Sinal para ligar às saídas da UUT
	signal s_count : std_logic_vector(N-1 downto 0);
begin
	-- Instanciação da Unit Under Test (UUT)
	uut: entity work.CntNDownEnRes(Behavioral)
	generic map(N => 4)
	port map(reset => s_reset,
				clk => s_clk,
				enable => s_enable,
				count => s_count);
	--Process stim
	stim_proc : process
	begin
		s_reset  <= '1';
		s_enable <= '0';
		wait for 75 ns;
		s_reset  <= '0';
		s_enable <= '1';
		wait for 525 ns;
		s_enable <= '0';
		wait for 225 ns;		
	end process;
	
	stim_clk : process
	begin
		s_clk <= '0';
		wait for 50 ns;
		s_clk <= '1';
		wait for 50 ns;
	end process;
end Stimulus;