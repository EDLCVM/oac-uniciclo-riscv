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
		
		-- Sinais de dados
		saida_pc		: out std_logic_vector(7 downto 0);
		
		saida_mux_memdados,
		saida_ula	: out std_logic_vector(31 downto 0);
		entrada_ula_op : out ULA_OP;
		entrada_ula_A,
	   entrada_ula_B		: out std_logic_vector(31 downto 0);
		sinal_ctrl_alusrc	: out std_logic;
		saida_genimm32		: out std_logic_vector(31 downto 0);
		entrada_dado_xregs : out std_logic_vector(31 downto 0);
		entrada_xregs_rd 	: out std_logic_vector(4 downto 0)
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
	
	signal d_pc_meminstrucao 	: std_logic_vector(7 downto 0) 	:= X"00";
	signal d_meminstrucao		: std_logic_vector(31 downto 0) 	:= X"00000000";
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
	
	signal ctrl_regwrite 	: std_logic 		:= '0';
	signal ctrl_alusrc 		: std_logic 		:= '0';
	signal ctrl_memwrite 	: std_logic 		:= '0';
	signal ctrl_aluop 		: Controle_ULA;
	signal ctrl_memtoreg 	: std_logic			:= '0';
	signal ctrl_branch 		: std_logic			:= '0';
	signal ctrl_ctrlula		: ULA_OP;
	
begin	

	saida_ula <= d_ula_saida;

	-- Sinais que realmente serão do processador.
	saida_mux_memdados <= d_mux_memdados;
	
	saida_pc <= d_pc_meminstrucao;
	
	saidaInstr <= d_meminstrucao;
	
	entrada_ula_op <= ctrl_ctrlula;
	
	entrada_ula_A <= d_xregs_ro1;
	entrada_ula_B <= d_mux_b_ula;
	
	sinal_ctrl_alusrc	<= ctrl_alusrc;
	
	saida_genimm32 <= d_immgen;
	
	entrada_dado_xregs <= d_mux_memdados;
	
	entrada_xregs_rd <= d_meminstrucao(11 downto 7);
	

--- ------- Conexão entre os componentes -------
	pc: entity work.PC port map (
		entrada 	=> d_entrada_pc,
		saida 	=> d_pc_meminstrucao
	);

	meminstrucao: entity work.meminstrucao port map (
		address 	=> d_pc_meminstrucao,
		clock 	=> clock,
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
		clock 	=> clock,
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