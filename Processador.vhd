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
	
	-- Se for uma saida que varios blocos podem usar, colocar:
	-- Pode colocar o nome da saida do bloco fonte também.
	-- Sinal de dado: d_<bloco-fonte>
	
	-- Sinais apenas para testar.
	signal teste_pc 				: std_logic_vector(7 downto 0);
	
	signal d_pc_meminstrucao 	: std_logic_vector(7 downto 0);
	signal d_meminstrucao		: std_logic_vector(31 downto 0);
	signal d_xregs_ro1			: std_logic_vector(31 downto 0);
	signal d_xregs_ro2			: std_logic_vector(31 downto 0);
	signal d_ula_saida			: std_logic_vector(31 downto 0);
	signal d_ula_zero				: std_logic;
	signal d_memdados				: std_logic_vector(31 downto 0);
	signal d_mux_memdados		: std_logic_vector(31 downto 0);
	signal d_immgen				: std_logic_vector(31 downto 0);
	signal d_mux_b_ula			: std_logic_vector(31 downto 0);
	
	signal ctrl_alusrc 		: std_logic;
	signal ctrl_memwrite 	: std_logic;
	signal ctrl_aluop 		: Controle_ULA;
	signal ctrl_memtoreg 	: std_logic;
	signal ctrl_branch 		: std_logic;
	
begin
	-- Apenas para debbugar no modelsim.
	teste_pc 		<= PC_entrada;
	
	
	-- Sinais que realmente serão do processador.
--- ------- Conexão entre os componentes -------
	pc: entity work.PC port map (
		entrada 	=> teste_pc,
		saida 	=> d_pc_meminstrucao
	);

	meminstrucao: entity work.meminstrucao port map (
		address 	=> d_pc_meminstrucao,
		clock 	=> clock,
		data 		=> X"00000000",
		wren 		=> '0',	-- instruções já são carregadas em um arquivo.
		q 			=> d_meminstrucao
	);
	
	controle: entity work.Controle port map (
		Opcode => d_meminstrucao(6 downto 0),
		MemtoReg => ctrl_memtoreg,
		MemWrite => ctrl_memwrite,
		ALUSrc => ctrl_alusrc,
		RegWrite => ctrl_regwrite,
		ALUOp => ctrl_aluop
	);
	
	xregs: entity work.XREGS port map (
		clock => clock,
		wren 	=> ctrl_regwrite,
		rst 	=> xregs_rst,
		rs1 	=> d_meminstrucao(19 downto 15),
		rs2 	=> d_meminstrucao(24 downto 20),
		rd 	=> d_meminstrucao(11 downto 7),
		ro1 	=> d_xregs_ro1,
		ro2 	=> d_xregs_ro2,
		data 	=> d_mux_memdados
	);
	
	ula: entity work.ULA port map (
		opcode => ADD_OP, -- MUDAR. Quando adicionar o controle da ULA
		A 		=> d_xregs_ro1,
		B 		=> d_mux_b_ula,
		Z 		=> d_ula_saida,
		zero 	=> d_ula_zero
	);
	
	memdados: entity work.memdados port map (
		address => d_ula_saida(7 downto 0),
		clock => clock,
		data => d_xregs_ro2,
		wren => ctrl_memwrite,
		q	=> d_memdados
	);
	
	mux_mem_dados: entity work.Mux2x1 port map (
		seletor => ctrl_memtoreg,
		A => d_memdados,
		B => d_ula_saida,
		saida => d_mux_memdados
	);
	
	immgen: entity work.ImmGen port map (
		instrucao => d_meminstrucao,
		imm32 => d_immgen
	);
	
	mux_b_ula: entity work.Mux2x1 port map (
		seletor => ctrl_alusrc,
		A => d_xregs_ro2,
		B => d_immgen,
		saida => d_mux_b_ula
	);
	
end comportamento;
