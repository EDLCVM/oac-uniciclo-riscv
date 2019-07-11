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
		ctr_branch,
		ctr_memtoreg,
		ctr_memwrite,
		ctr_alusrc,
		ctr_regwrite,
		ctr_jal,
		ctr_jalr,
		ctr_datatoreg,
		ctr_lui				: out std_logic := '0';
		ctr_aluop	 		: out Controle_ULA;
		ctr_operacao_ULA 	: out ULA_OP;
		
		saida_adderpc4,
		saida_adderpcshiftleft,
		entrada_xregs_data,
		
		saida_xregs_ro1,
		saida_xregs_ro2,
		saida_genimm32,
		
		entrada_ula_A,
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
	
	signal d_pc_meminstrucao 			: std_logic_vector(7 downto 0);
	signal d_meminstrucao				: std_logic_vector(31 downto 0);
	signal d_xregs_ro1					: std_logic_vector(31 downto 0);
	signal d_xregs_ro2					: std_logic_vector(31 downto 0);
	signal d_ula_saida					: std_logic_vector(31 downto 0);
	signal d_ula_zero						: std_logic;
	signal d_memdados						: std_logic_vector(31 downto 0);
	signal d_mux_memdados				: std_logic_vector(31 downto 0);
	signal d_immgen						: std_logic_vector(31 downto 0);
	signal d_mux_b_ula					: std_logic_vector(31 downto 0);
	signal d_mux_lui                 : std_logic_vector(31 downto 0);
	signal d_adder_mux_branch  		: std_logic_vector(31 downto 0);
	signal d_entrada_pc					: std_logic_vector(7 downto 0);
	signal d_saida_pc_4					: std_logic_vector(7 downto 0); -- saida dividida por 4
	signal d_saida_adder_pc_offset 	: std_logic_vector(31 downto 0);
	signal d_pc_32_bits					: std_logic_vector(31 downto 0);
	signal d_mux_xreg_dado				: std_logic_vector(31 downto 0);
	signal d_ula_not_0bit				: std_logic_vector(31 downto 0);
	signal d_mux_pc4_branch_pcoffset	: std_logic_vector(31 downto 0);
	signal d_mux_pc4branch_jalr		: std_logic_vector(31 downto 0);
	signal d_entrada_xregs_data		: std_logic_vector(31 downto 0);
	signal d_mux_pc4_xregs				: std_logic_vector(31 downto 0);
	
	signal ctrl_jalr_jal			: std_logic;
	signal ctrl_regwrite 		: std_logic 		:= '0';
	signal ctrl_alusrc 			: std_logic 		:= '0';
	signal ctrl_memwrite 		: std_logic 		:= '0';
	signal ctrl_aluop 			: Controle_ULA;
	signal ctrl_memtoreg 		: std_logic			:= '0';
	signal ctrl_branch 			: std_logic			:= '0';
	signal ctrl_ctrlula			: ULA_OP;
	signal ctrl_seletor_mux_pc : std_logic;
	signal ctrl_jal,
			 ctrl_jalr,
			 ctrl_lui,
			 ctrl_datatoreg		: std_logic;
	
begin

	saida_pc <= d_pc_meminstrucao;
	saidaInstr <= d_meminstrucao;
	
	-- ---------- Sinais que saem do processador para o wave ----------
	-- Controle:
	ctr_branch     <= ctrl_branch;
	ctr_memtoreg 	<= ctrl_memtoreg;
	ctr_memwrite 	<= ctrl_memwrite;
	ctr_alusrc		<= ctrl_alusrc;
	ctr_regwrite	<= ctrl_regwrite;
	ctr_aluop		<= ctrl_aluop;
	ctr_operacao_ULA  <= ctrl_ctrlula;
	ctr_jal 			<= ctrl_jal;
	ctr_jalr 		<= ctrl_jalr;
	ctr_lui      	<= ctrl_lui;
	ctr_datatoreg 	<= ctrl_datatoreg;
	
	-- Dados
	saida_adderpc4 <= d_adder_mux_branch;
	
			
	-- saida_adderpcimm Não tem esse adder ainda,
	entrada_xregs_data <= d_mux_xreg_dado;
		
	saida_xregs_ro1 <= d_xregs_ro1;
	saida_xregs_ro2 <= d_xregs_ro2;
	saida_genimm32 <= d_immgen;
	
	entrada_ula_B <= d_mux_b_ula;
	saida_ula <= d_ula_saida;
	d_ula_not_0bit <= std_logic_vector((d_ula_saida and "11111111111111111111111111111110"));
	saida_mux_memdados <= d_memdados;
	
	entrada_xregs_rs1 <= d_meminstrucao(19 downto 15);
	entrada_xregs_rs2 <= d_meminstrucao(24 downto 20);
	
	entrada_xregs_rd <= d_meminstrucao(11 downto 7);
	
	d_saida_pc_4 <= std_logic_vector(unsigned(d_pc_meminstrucao) / 4);
	d_entrada_xregs_data <= std_logic_vector(unsigned(d_xregs_ro2) / 4);
	
	d_pc_32_bits <= std_logic_vector(resize(unsigned(d_pc_meminstrucao), 32));
	
	saida_adderpcshiftleft <= d_saida_adder_pc_offset;
	
	ctrl_seletor_mux_pc <= ctrl_branch and d_ula_saida(0);
	
	ctrl_jalr_jal <= ctrl_jal or ctrl_jalr;
	
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
		Branch	=> ctrl_branch,
		MemtoReg => ctrl_memtoreg,
		MemWrite => ctrl_memwrite,
		ALUSrc 	=> ctrl_alusrc,
		RegWrite => ctrl_regwrite,
		ALUOp 	=> ctrl_aluop,
		JalR		=> ctrl_jalr,
		Jal		=> ctrl_jal,
		DatatoReg => ctrl_datatoreg,
		Lui      => ctrl_lui
	);
	
	xregs: entity work.XREGS port map (
		clock => clock,
		wren 	=> ctrl_regwrite,
		rs1 	=> d_meminstrucao(19 downto 15),
		rs2 	=> d_meminstrucao(24 downto 20),
		rd 	=> d_meminstrucao(11 downto 7),
		ro1 	=> d_xregs_ro1,
		ro2 	=> d_xregs_ro2,
		data 	=> d_mux_pc4_xregs
	);
	
	ula: entity work.ULA port map (
		opcode 	=> ctrl_ctrlula,
		A 			=> d_xregs_ro1,
		B 			=> d_mux_b_ula,
		Z 			=> d_ula_saida,
		zero 		=> d_ula_zero
	);
	
	memdados: entity work.memdados port map (
		address 	=> d_ula_saida(9 downto 2),
		clock 	=> clockMem,
		data 		=> d_xregs_ro2,
		wren 		=> ctrl_memwrite,
		q			=> d_memdados
	);
	
	mux_mem_dados: entity work.Mux2x1 port map (
		seletor 	=> ctrl_memtoreg,
		A 			=> d_ula_saida,
		B 			=> d_memdados,
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
	
	mux_lui: entity work.Mux2x1 port map (
		seletor 	=> ctrl_lui,
		A 			=> d_mux_memdados,
		B 			=> d_immgen,
		saida 	=> d_mux_lui
	);
	
	mux_pc4_xregs: entity work.Mux2x1 port map (
		seletor => ctrl_jalr_jal,
		A => d_mux_lui,
		B => d_adder_mux_branch,
		saida => d_mux_pc4_xregs
	);
	
	mux_pc4_branch: entity work.Mux2x1 port map (
		seletor => ctrl_seletor_mux_pc,
		A => d_adder_mux_branch,
		B => d_saida_adder_pc_offset,
		saida => d_mux_pc4branch_jalr
	);
	
	adderpc_shiftleft: entity work.Adder port map (
		A => d_pc_32_bits,
		B => d_immgen,
		saida => d_saida_adder_pc_offset
	);
	
	mux_xreg_dado: entity work.Mux2x1 port map (
		seletor => ctrl_datatoreg,
		A => d_mux_memdados,
		B => d_adder_mux_branch,
		saida => d_mux_xreg_dado
	);
	
	mux_pc4branch_jalr: entity work.Mux2x1 port map (
		seletor => ctrl_jalr,
		A => d_mux_pc4branch_jalr,
		B => d_ula_not_0bit,
		saida => d_mux_pc4_branch_pcoffset
	);
	
	mux_pc4_branch_pcoffset: entity work.Mux2x1_PC port map (
		seletor => ctrl_jal,
		A => d_mux_pc4_branch_pcoffset,
		B => d_saida_adder_pc_offset,
		saida => d_entrada_pc
	);
end comportamento;
