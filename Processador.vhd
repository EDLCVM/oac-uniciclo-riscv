library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador is
	port(
		clock 		: in std_logic;
		saidaInstr 	: out std_logic_vector(31 downto 0);
		
		-- Sinais para ajudar na visualização do que ocorre dentro do processador
		-- Sinais de controle
		ctrl_memtoreg,
		ctrl_memwrite,
		ctrl_alusrc,
		ctrl_regwrite 	: out std_logic;
		
		ALUOp 			: out Controle_ULA;
		
		-- Sinais de dados
		entrada_xregs_r1,
		entrada_xregs_r2,
		entrada_xregs_rd,
		entrada_A_ULA,
		entrada_B_ULA,
		saida_meminstrucao,
		saida_ULA,
		saida_memdados,
		saida_mux_memdados : out std_logic_vector(31 downto 0)
		
	);
end Processador;

architecture comportamento of Processador is

	-- Sinais:
	-- Estrutura de codificação.
	-- Sinal de controle: ctr_<nome>
	-- Sinal de dado: d_<bloco-fonte>_<bloco-destino>
	
	signal teste_pc 				: std_logic_vector(7 downto 0);
	signal d_pc_meminstrucao 	: std_logic_vector(7 downto 0);
	signal teste_saida			: std_logic_vector(31 downto 0);
begin

--- ------- Conexão entre os componentes -------
	pc: entity work.PC port map (
		entrada => teste_pc,
		saida => d_pc_meminstrucao
	);

	meminstrucao: entity work.meminstrucao port map (
		address => teste_pc,
		clock => clock,
		data => X"00000000",
		wren => '0',
		q => teste_saida
	);
	
end comportamento;