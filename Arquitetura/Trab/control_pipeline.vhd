library IEEE;
use IEEE.std_logic_1164.all;
use work.p_MI0.all;

entity control_pipeline is
	port 	(
			opcode: in std_logic_vector(5 downto 0);
		 	RegDst: out std_logic; 
			Fwdb: out std_logic; 
			Fwda: out std_logic; 
			MemtoReg: out std_logic; 
			RegWrite: out std_logic; 
			MemRead: out std_logic; 
			MemWrite: out std_logic; 
			Branch: out std_logic; 
			ALUOp: out std_logic_vector(1 downto 0)
		);
end control_pipeline;


architecture arq_control_pipeline of control_pipeline is



    --input [5:0] opcode;
    --output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    --output [1:0] ALUOp;
    --reg    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    --reg    [1:0] ALUOp;

begin
   
    process (opcode)
    begin
        case opcode is
					when R_FORMAT => RegDst <= '1';Fwdb <= '0'; Fwda <= '0'; MemtoReg <= '0'; RegWrite <='1'; MemRead<='0'; MemWrite<='0'; Branch<='0'; ALUOp <= "10"; -- R type
					when LW => RegDst <= '0';Fwdb <= '1'; Fwda <= '0';MemtoReg <= '1'; RegWrite <='1'; MemRead<='1'; MemWrite<='0'; Branch<='0'; ALUOp <= "00"; -- LW
					when SW => RegDst <= 'X'; Fwdb <= '1'; Fwda <= '0';MemtoReg <= 'X'; RegWrite <='0'; MemRead<='0'; MemWrite<='1'; Branch<='0'; ALUOp <= "00"; -- SW
					when BEQ => RegDst <= 'X'; Fwdb <= '0'; Fwda <= '0';MemtoReg <= 'X'; RegWrite <='0'; MemRead<='0'; MemWrite<='0'; Branch<='1'; ALUOp <= "01"; -- BEQ
					when ADDI => RegDst <= '0'; Fwdb <= '1'; Fwda <= '0'; MemtoReg <= '0'; RegWrite <='1'; MemRead<='0'; MemWrite<='0'; Branch<='0'; ALUOp <= "00"; -- ADDI type
					when SWI => RegDst <= '0'; Fwdb <= '1'; Fwda <= '1';MemtoReg <= 'X'; RegWrite <='0'; MemRead<='0'; MemWrite<='1'; Branch<='0'; ALUOp <= "00"; -- SWI type
					when others => RegDst <= '0'; Fwdb <= '0'; Fwda <= '0';MemtoReg <= '0'; RegWrite <='0'; MemRead<='0'; MemWrite<='0'; Branch<='0'; ALUOp <= "00";
				end case;
			end process;

		end arq_control_pipeline;
