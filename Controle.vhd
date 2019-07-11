library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;

entity Controle is

	port(
		Opcode 	: in std_logic_vector(6 downto 0);
		Branch,		-- ativo caso seja uma instrução beq
		DatatoReg,
		JalR,			-- ativo caso seja uma instrução jalr
		Jal,			-- ativo caso seja uma instrução jal
		Lui,			-- ativo caso seja uma instrução lui
		MemtoReg,	-- 0 = resultado da ULA, 1 = resultado da memória de dados.
		MemWrite,	-- ativo para escrever na memória de dados
		ALUSrc,		-- 0 = resultado do registrador, 1 = imediato
		RegWrite		-- ativo para permitir escrita no banco de registradores	
		: out std_logic := '0';
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
			ALUOp <= TIPO_R;
			Branch <= '0';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '0';
		
		-- Load Word
		elsif ( opcode = "0000011" ) then
			MemtoReg <= '1';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			ALUOp <= TIPO_LW;
			Branch <= '0';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '0';
			
		-- Tipo I
		elsif ( opcode = "0010011" ) then
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			ALUOp <= TIPO_I;
			Branch <= '0';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '0';
		
		-- Tipo SW
		elsif ( opcode = "0100011" ) then
			MemtoReg <= '0'; -- don't care.
			MemWrite <= '1'; 
			ALUSrc <= '1';
			RegWrite <= '0';
			ALUOp <= TIPO_SW;
			Branch <= '0';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '0';
		
		
		-- Tipo U
		elsif ( opcode = "0110111" ) then
			ALUOp <= TIPO_U;
			MemtoReg <= '0'; -- don't care.
			MemWrite <= '0'; 
			ALUSrc <= '1';
			RegWrite <= '1';
			Branch <= '0';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '1';
		
		
		-- Tipo JAL
		elsif ( opcode = "1101111" ) then
			ALUOp <= TIPO_JUMP;
			MemtoReg <= '0'; -- don't care.
			MemWrite <= '0'; 
			ALUSrc <= '0';
			RegWrite <= '1';
			Branch <= '0';
			DatatoReg <= '1';
			JalR <= '0';
			Jal <= '1';
			Lui <= '0';
			
			
		-- tipo JALR
		elsif ( opcode = "1100111" ) then
			ALUOp <= TIPO_JUMP;
			MemtoReg <= '0'; -- don't care.
			MemWrite <= '0'; 
			ALUSrc <= '1';
			RegWrite <= '1';
			Branch <= '0';
			DatatoReg <= '1';
			JalR <= '1';
			Jal <= '0';
			Lui <= '0';
		
		-- Tipo B
		elsif ( opcode = "1100011"   			-- BEQ
			  or opcode = "1100011"	  			-- BNE
			  or opcode = "1100011"	  			-- BLT
			  or opcode = "1100011" ) then 	-- BGE
			MemtoReg <= '0'; -- don't care.
			MemWrite <= '0'; 
			ALUSrc <= '0';
			RegWrite <= '0';
			ALUOp <= TIPO_B;
			Branch <= '1';
			DatatoReg <= '0';
			JalR <= '0';
			Jal <= '0';
			Lui <= '0';
			
		end if;
		
	end process;
end comportamento;