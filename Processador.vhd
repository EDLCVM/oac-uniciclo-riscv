library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador is
	port(
		clock 		: in std_logic;
		clockMem		: in std_logic;

		-- Sinais para ajudar na visualização do que ocorre dentro do processador
		saida_pc		: out std_logic_vector(7 downto 0);
		saidaInstr 	: out std_logic_vector(31 downto 0);
		
		-- Sinais de controle
		ctr_memtoreg,
		ctr_memwrite,
		ctr_alusrc,
		ctr_regwrite : out std_logic;
		ctr_aluop	 : out Controle_ULA;
		ctr_operacao_ULA : out ULA_OP;
		
		saida_adderpc4,
		saida_adderpcimm,
		entrada_xregs_data,
		
		saida_xregs_ro1,
		saida_xregs_ro2,
		saida_genimm32,
		
		entrada_ula_B,
		saida_ula,
		
		saida_mux_memdados 	: out std_logic_vector(31 downto 0);
		
		entrada_xregs_rs1,
		entrada_xregs_rs2,
		entrada_xregs_rd : out std_logic_vector(4 downto 0)
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
	signal d_adder_mux_branch  : std_logic_vector(31 downto 0);
	signal d_entrada_pc			: std_logic_vector(7 downto 0);
	signal d_saida_pc_4			: std_logic_vector(7 downto 0); -- saida dividida por 4

	signal ctrl_regwrite 	: std_logic 		:= '0';
	signal ctrl_alusrc 		: std_logic 		:= '0';
	signal ctrl_memwrite 	: std_logic 		:= '0';
	signal ctrl_aluop 		: Controle_ULA;
	signal ctrl_memtoreg 	: std_logic			:= '0';
	signal ctrl_branch 		: std_logic			:= '0';
	signal ctrl_ctrlula		: ULA_OP;
	
begin

	saida_pc <= d_pc_meminstrucao;
	saidaInstr <= d_meminstrucao;
	
	-- ---------- Sinais que saem do processador para o wave ----------
	-- Controle:
	ctr_memtoreg 	<= ctrl_memtoreg;
	ctr_memwrite 	<= ctrl_memwrite;
	ctr_alusrc		<= ctrl_alusrc;
	ctr_regwrite	<= ctrl_regwrite;
	ctr_aluop		<= ctrl_aluop;
	ctr_operacao_ULA  <= ctrl_ctrlula;
	
	-- Dados
	saida_adderpc4 <= d_adder_mux_branch;
	
			
	-- saida_adderpcimm Não tem esse adder ainda,
	entrada_xregs_data <= d_mux_memdados;
		
	saida_xregs_ro1 <= d_xregs_ro1;
	saida_xregs_ro2 <= d_xregs_ro2;
	saida_genimm32 <= d_immgen;
		
	entrada_ula_B <= d_mux_b_ula;
	saida_ula <= d_ula_saida;
	saida_mux_memdados <= d_mux_memdados;
	
	entrada_xregs_rs1 <= d_meminstrucao(19 downto 15);
	entrada_xregs_rs2 <= d_meminstrucao(24 downto 20);
	
	entrada_xregs_rd <= d_meminstrucao(11 downto 7);
	
	d_saida_pc_4 <= std_logic_vector(unsigned(d_pc_meminstrucao) / 4);
	
--- ------- Conexão entre os componentes -------
	pc: entity work.PC port map (
		clock    => clock,
		entrada 	=> d_entrada_pc,
		saida 	=> d_pc_meminstrucao
	);

	meminstrucao: entity work.meminstrucao port map (
		address 	=> d_saida_pc_4,
		clock 	=> clockMem,
		data 		=> X"00000000",	-- instruções já são carregadas em um arquivo.
		wren 		=> '0',				-- instruções já são carregadas em um arquivo.
		q 			=> d_meminstrucao
	);
	
	controle: entity work.Controle port map (
		Opcode 	=> d_meminstrucao(6 downto 0),
		MemtoReg => ctrl_memtoreg,
		MemWrite => ctrl_memwrite,
		ALUSrc 	=> ctrl_alusrc,
		RegWrite => ctrl_regwrite,
		ALUOp 	=> ctrl_aluop
	);
	
	xregs: entity work.XREGS port map (
		clock => clock,
		wren 	=> ctrl_regwrite,
		rs1 	=> d_meminstrucao(19 downto 15),
		rs2 	=> d_meminstrucao(24 downto 20),
		rd 	=> d_meminstrucao(11 downto 7),
		ro1 	=> d_xregs_ro1,
		ro2 	=> d_xregs_ro2,
		data 	=> d_mux_memdados
	);
	
	ula: entity work.ULA port map (
		opcode 	=> ctrl_ctrlula,
		A 			=> d_xregs_ro1,
		B 			=> d_mux_b_ula,
		Z 			=> d_ula_saida,
		zero 		=> d_ula_zero
	);
	
	memdados: entity work.memdados port map (
		address 	=> d_ula_saida(7 downto 0),
		clock 	=> clockMem,
		data 		=> d_xregs_ro2,
		wren 		=> ctrl_memwrite,
		q			=> d_memdados
	);
	
	mux_mem_dados: entity work.Mux2x1 port map (
		seletor 	=> ctrl_memtoreg,
		A 			=> d_memdados,
		B 			=> d_ula_saida,
		saida 	=> d_mux_memdados
	);
	
	immgen: entity work.ImmGen port map (
		instrucao 	=> d_meminstrucao,
		imm32 		=> d_immgen
	);
	
	controle_ula: entity work.ULAControle port map (
		funct3		=> d_meminstrucao(14 downto 12),
		funct7		=> d_meminstrucao(31 downto 25),
		ControleOp 	=> ctrl_aluop,
		ALUOp 		=> ctrl_ctrlula
	);
	
	adder4_pc: entity work.AdderPC port map (
		A		=> d_pc_meminstrucao,
		B  	=> "00000100", -- 4
		saida => d_adder_mux_branch
	);
	
	mux_b_ula: entity work.Mux2x1 port map (
		seletor 	=> ctrl_alusrc,
		A 			=> d_xregs_ro2,
		B 			=> d_immgen,
		saida 	=> d_mux_b_ula
	);
	
	-- MUDAR quando implementar Branch!
	mux_pc4_branch: entity work.Mux2x1_PC port map (
		seletor => '0',
		A => d_adder_mux_branch,
		B => X"00000000",
		saida => d_entrada_pc
	);
	
end comportamento;
