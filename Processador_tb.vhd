library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador_tb is
end Processador_tb;

architecture comportamento of Processador_tb is

component Processador is
	port(
		clock 					: in std_logic;
		saidaInstr 				: out std_logic_vector(31 downto 0);
		xregs_rst				: in std_logic;
		saida_mux_memdados 	: out std_logic_vector(31 downto 0)
	);
end component;
	
	signal clock 		: std_logic := '0';
	
	-- sinais pra visualizar internamente o processador
	
	-- ------------------------------------------------
	
	signal saidaInstr : std_logic_vector(31 downto 0);
	signal saida_memdados : std_logic_vector(31 downto 0);
	
	begin
		i1 : Processador
		port map (
			clock 					=> clock,
			saidaInstr 				=> saidaInstr,
			saida_mux_memdados 	=> saida_memdados,
			xregs_rst	=> '0' -- Mudar depois
		);
		
		clock <= '1' after 2 ps when clock = '0' else
					'0' after 2 ps when clock = '1';
		
		init: process
			begin
			
			wait for 4 ps;
			wait for 4 ps;
			wait for 4 ps;
			wait for 4 ps;
			wait for 4 ps;
			
		end process init;

end comportamento;