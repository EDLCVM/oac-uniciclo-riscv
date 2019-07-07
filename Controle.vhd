library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Controle is

	port(
		Opcode 	: in std_logic_vector(6 downto 0);
		--Branch,		-- ativo caso seja uma instrução beq
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
		: out std_logic;
		ALUOp 	: out Controle_ULA
	);

end Controle;

architecture comportamento of Controle is
begin
	process(opcode)
	begin
		-- Tipo R
		if( opcode = "0110011" ) then
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '1';
			ALUOp <= FUNCT3_FUNCT7;
		
		-- Load Word
		-- elsif ( opcode = "0000011" ) then
			
		-- Tipo I
		elsif ( opcode = "0010011" ) then
			MemtoReg <= '1';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			ALUOp <= TIPO_I;
		
		-- Tipo U
		--elsif ( opcode = "0110111" ) then
		
		-- Tipo J
		--elsif ( opcode = "1101111" ) then
		
		-- Tipo B
		--elsif ( opcode = "1100011" ) then
		end if;
		
	end process;
end comportamento;