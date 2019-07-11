library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Processador_tb is
end Processador_tb;

architecture comportamento of Processador_tb is

component Processador is
	port(
		clock 		: in std_logic;
		clockMem		: in std_logic;

		-- Sinais para ajudar na visualização do que ocorre dentro do processador
		saida_pc		: out std_logic_vector(7 downto 0);
		saidaInstr 	: out std_logic_vector(31 downto 0);
		
		-- Sinais de controle
		ctr_jal,
		ctr_jalr,
		ctr_datatoreg,
		ctr_branch,
		ctr_memtoreg,
		ctr_memwrite,
		ctr_alusrc,
		ctr_regwrite,
		ctr_lui				: out std_logic;
		ctr_aluop	 : out Controle_ULA;
		ctr_operacao_ULA : out ULA_OP;
		
		saida_adderpc4,
		saida_adderpcshiftleft,
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
end component;
	
	signal clock 		: std_logic := '0';
	signal clockMem	: std_logic := '0';
	
	-- sinais pra visualizar internamente o processador
	
	-- ------------------------------------------------
	signal saida_pc		: std_logic_vector(7 downto 0);
	signal saidaInstr 	: std_logic_vector(31 downto 0);
		
	signal 	ctr_branch,
				ctr_memtoreg,
				ctr_memwrite,
				ctr_alusrc,
				ctr_regwrite,
				ctr_jal,
				ctr_jalr,
				ctr_datatoreg,
			   ctr_lui			: std_logic := '0';
	signal 	ctr_aluop	 : Controle_ULA;
	signal 	ctr_operacao_ULA : ULA_OP;
		
	signal 	saida_adderpc4,
				saida_adderpcshiftleft,
				entrada_xregs_data,
				saida_xregs_ro1,
				saida_xregs_ro2,
				saida_genimm32,
				entrada_ula_B,
				saida_ula,
				saida_mux_memdados 	: std_logic_vector(31 downto 0) := X"00000000";
		
	signal 	entrada_xregs_rs1,
				entrada_xregs_rs2,
				entrada_xregs_rd : std_logic_vector(4 downto 0);
	
	begin
		i1 : Processador
		port map (
		clock 					=> clock,
		clockMem					=> clockMem,
		saida_pc					=> saida_pc,
		saidaInstr				=> saidaInstr,
		ctr_branch				=> ctr_branch,
		ctr_jal					=> ctr_jal,
		ctr_jalr					=> ctr_jalr,
		ctr_datatoreg			=> ctr_datatoreg,
		ctr_memtoreg			=> ctr_memtoreg,
		ctr_memwrite			=> ctr_memwrite,
		ctr_alusrc				=> ctr_alusrc,
		ctr_regwrite 			=> ctr_regwrite,
		ctr_aluop	 			=> ctr_aluop,
		ctr_operacao_ULA 		=> ctr_operacao_ULA,
		ctr_lui					=> ctr_lui,
		saida_adderpc4			=> saida_adderpc4,
		saida_adderpcshiftleft 		=> saida_adderpcshiftleft, -- não tem ainda
		entrada_xregs_data	=> entrada_xregs_data,
		
		saida_xregs_ro1 		=> saida_xregs_ro1,
		saida_xregs_ro2		=> saida_xregs_ro2,
		saida_genimm32			=> saida_genimm32,
		entrada_ula_B 			=> entrada_ula_B,
		saida_ula				=> saida_ula,
		
		saida_mux_memdados	=> saida_mux_memdados,
		
		entrada_xregs_rs1 	=> entrada_xregs_rs1,
		entrada_xregs_rs2		=> entrada_xregs_rs2,
		entrada_xregs_rd 		=> entrada_xregs_rd
		);
		
		clock <= '1' after 500 ps when clock = '0' else
					'0' after 500 ps when clock = '1';
		
		clockMem <= '1' after 1 ps when clockMem = '0' else
						'0' after 1 ps when clockMem = '1';

end comportamento;