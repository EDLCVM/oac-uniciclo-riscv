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
	
	if ( ControleOp = TIPO_R ) then
	
		if (funct7="0000000" and funct3="000") then
			ALUOp <= ADD_OP;
			
		elsif(funct7="0100000" and funct3="000") then
			ALUOP <= SUB_OP;
			
		elsif(funct7="0000000" and funct3="111") then
			ALUOP <= AND_OP;
			
		elsif(funct7="0000000" and funct3="110") then
			ALUOP <= OR_OP;
			
		elsif(funct7="0000000" and funct3="100") then
			ALUOP <= XOR_OP;
			
		elsif(funct7="0000000" and funct3="001") then
			ALUOP <= SLL_OP;	

		elsif(funct7="0000000" and funct3="101") then
			ALUOP <= SRL_OP;			
			
		elsif(funct7="0000000" and funct3="011") then
			ALUOP <= SLTU_OP;
			
		end if;
	end if;
	
	if ( ControleOp = TIPO_LW ) then
		ALUOp <= ADD_OP;
	end if;
		
	if ( ControleOp = TIPO_I ) then
		case funct3 is
			-- addi
			when "000" =>
				ALUOp <= ADD_OP;
					
			-- ANDI
			when "111" =>
				ALUOp <= AND_OP;
				
			-- ORI
			when "110" =>
				ALUOp <= OR_OP;
					
			-- XORI
			when "100" =>
				ALUOp <= XOR_OP;

			-- SLLI
			when "001" =>
				ALUOp <= SLL_OP;
				
			-- SRLI / SRAI
			when "101" =>
				if ( funct7(6 downto 1) = "000000") then
						ALUOp <= SRL_OP;
				else
					ALUOp <= SRA_OP;
				end if;

			-- SLTI
			when "010" =>
				ALUOp <= SLT_OP;
				
			-- SLTIU
			when "011" =>
				ALUOp <= SLTU_OP;
				
			when others =>
				ALUOp <= ADD_OP;

			end case;
		end if;
		
		-- Tipo B
		if ( ControleOp = TIPO_B ) then
			case funct3 is
				-- BEQ
				when "000" =>
					ALUOP <= SEQ_OP;
			
				-- BNE
				when "001" =>
					ALUOP <= SNE_OP;
			
				-- BLT
				when "100" =>
					ALUOp <= SLT_OP;
			
				-- BGE
				when "101" =>
					ALUOP <= SGE_OP;
		
				when others =>
					ALUOP <= ADD_OP;
			end case;
		end if;
		
		if ( ControleOp = TIPO_JUMP ) then
			ALUOp <= ADD_OP;
		end if;
		
	end process;
end comportamento;