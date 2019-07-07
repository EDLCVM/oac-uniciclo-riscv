library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity ULAControle is
	port (
		funct3		: in std_logic_vector(2 downto 0);
		funct7		: in std_logic_vector(6 downto 0);
		ControleOp 	: in Controle_ULA;
		ALUOp 		: out ULA_OP
	);
end ULAControle;

architecture comportamento of ULAControle is
begin
	process(ControleOp, funct3, funct7)
	begin
		if (ControleOp = TIPO_R and funct7="0000000" and funct3="000") then
			ALUOp <= ADD_OP;
			
		elsif(ControleOp = TIPO_R and funct7="0100000" and funct3="000") then
			ALUOP <= SUB_OP;
			
		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="111") then
			ALUOP <= AND_OP;
			
		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="110") then
			ALUOP <= OR_OP;
			
		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="100") then
			ALUOP <= XOR_OP;
			
		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="001") then
			ALUOP <= SLL_OP;	

		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="101") then
			ALUOP <= SRL_OP;			
			
		elsif(ControleOp = TIPO_R and funct7="0000000" and funct3="011") then
			ALUOP <= SLTU_OP;			
		
			
			
		end if;
	end process;
end comportamento;