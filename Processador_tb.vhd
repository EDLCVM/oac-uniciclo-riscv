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
		clockMem					: in std_logic;
		saidaInstr 				: out std_logic_vector(31 downto 0);

		saida_pc		: out std_logic_vector(7 downto 0);
		saida_mux_memdados,
		saida_ula	: out std_logic_vector(31 downto 0);
		entrada_ula_op : out ULA_OP;
		
		entrada_ula_A,
	   entrada_ula_B		: out std_logic_vector(31 downto 0);
		sinal_ctrl_alusrc	: out std_logic;
		saida_genimm32		: out std_logic_vector(31 downto 0);
		entrada_dado_xregs : out std_logic_vector(31 downto 0);
		entrada_xregs_rd  : out std_logic_vector(4 downto 0)
	);
end component;
	
	signal clock 		: std_logic := '0';
	signal clockMem	: std_logic := '0';
	
	-- sinais pra visualizar internamente o processador
	
	-- ------------------------------------------------
	
	signal saidaInstr 		: std_logic_vector(31 downto 0);
	signal saida_memdados 	: std_logic_vector(31 downto 0);
	signal saida_pc			: std_logic_vector(7 downto 0);
	signal saida_ula 			: std_logic_vector(31 downto 0);
	signal entrada_ula_op 	: ULA_OP;
	signal entrada_ula_A,
			 entrada_ula_B		: std_logic_vector(31 downto 0);
	signal sinal_ctrl_alusrc : std_logic;
	signal saida_genimm32	: std_logic_vector(31 downto 0);
	signal entrada_dado_xregs	: std_logic_vector(31 downto 0);
	signal entrada_xregs_rd : std_logic_vector(4 downto 0);
	
	begin
		i1 : Processador
		port map (
			clock 					=> clock,
			clockMem					=> clockMem,
			saidaInstr 				=> saidaInstr,
			saida_mux_memdados 	=> saida_memdados,
			saida_pc 				=> saida_pc,
			saida_ula 				=> saida_ula,
			entrada_ula_op			=> entrada_ula_op,
			entrada_ula_A 			=> entrada_ula_A,
			entrada_ula_B			=> entrada_ula_B,
			sinal_ctrl_alusrc		=> sinal_ctrl_alusrc,
			saida_genimm32			=> saida_genimm32,
			entrada_dado_xregs	=> entrada_dado_xregs,
			entrada_xregs_rd		=> entrada_xregs_rd
		);
		
		clock <= '1' after 4 ps when clock = '0' else
					'0' after 4 ps when clock = '1';
		
		clockMem <= '1' after 1 ps when clockMem = '0' else
						'0' after 1 ps when clockMem = '1';

end comportamento;