library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

-- Códigos enviados do controle principal para o controle da ULA.
type Controle_ULA is (FUNCT3_FUNCT7, TIPO_JUMP, TIPO_R, TIPO_I, TIPO_LW, TIPO_SW, TIPO_B, TIPO_U);

-- Códigos enviados do controle da ULA para a ULA.
type ULA_OP is (ADD_OP, SUB_OP, AND_OP,   OR_OP,  XOR_OP, SLL_OP, SRL_OP,
                SRA_OP, SLT_OP, SLTU_OP, SGE_OP, SGEU_OP, SEQ_OP, SNE_OP);
					 
-- inserir component aqui.

component Adder
	generic (WSIZE : natural := 32);
	port (
		A, B : in std_logic_vector(WSIZE - 1 downto 0);
		saida : out std_logic_vector(WSIZE - 1 downto 0)
	);
end component;

component PC is
	port(
		clock   :  in std_logic;
		entrada :  in std_logic_vector(7 downto 0) := "00000000";
		saida	  : out std_logic_vector(7 downto 0) := "00000000"
	);
end component;

component memdados is
	port(
		address	:  in std_logic_vector (7 DOWNTO 0);
		clock		:  in std_logic;
		data		:  in std_logic_vector (31 DOWNTO 0);
		wren		:  in std_logic;
		q			: out std_logic_vector (31 DOWNTO 0)
	);
end component;

component meminstrucao is
	port(
		address	:  in std_logic_vector (7 DOWNTO 0);
		clock		:  in std_logic  := '1';
		data		:  in std_logic_vector (31 DOWNTO 0);
		wren		:  in std_logic ;
		q			: out std_logic_vector (31 DOWNTO 0)
	);
end component;

component XREGS is
	generic (WSIZE : natural := 32);
	port (
		clock, wren			:  in std_logic;	
		rs1, rs2, rd		:  in std_logic_vector(4 downto 0);
		data					:  in std_logic_vector(WSIZE - 1 downto 0);
		ro1, ro2				: out std_logic_vector(WSIZE - 1 downto 0));
end component;

component ImmGen is
	port (
		instrucao : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0));
end component;

component ULAControle is
	port (
		funct3		: in std_logic_vector(2 downto 0);
		funct7		: in std_logic_vector(6 downto 0);
		ControleOp 	: in Controle_ULA;
		ALUOp 		: out ULA_OP
	);
end component;

component AdderPC is
	port (
		A, B 		: in std_logic_vector(7 downto 0); 
		saida 	: out std_logic_vector(7 downto 0)
	);
end component;

component Controle is

	port(
		Opcode 	: in std_logic_vector(6 downto 0);
		Branch,		-- ativo caso seja uma instrução beq
		--BranchNE,	-- ativo caso seja uma instrução bne
		--BranchLT		-- ativo caso seja uma instrução blt
		--BranchGE,	-- ativo caso seja uma instrução bge
		--JalR,			-- ativo caso seja uma instrução jalr
		--Jal,			-- ativo caso seja uma instrução jal
		--Lui,			-- ativo caso seja uma instrução lui
		MemtoReg,	-- 0 = resultado da ULA, 1 = resultado da memória de dados.
		MemWrite,	-- ativo para escrever na memória de dados
		ALUSrc,		-- 0 = resultado do registrador, 1 = imediato
		RegWrite		-- ativo para permitir escrita no banco de registradores	
		: out std_logic := '0';
		ALUOp 	: out Controle_ULA
	);

end component;

end riscv_pkg;