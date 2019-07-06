library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador is
	port(
		clock 		: in std_logic;
		PC_entrada 	: in std_logic_vector(7 downto 0);
		saidaInstr 	: out std_logic_vector(31 downto 0)
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

	teste_pc <= PC_entrada;
	saidaInstr <= teste_saida;
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