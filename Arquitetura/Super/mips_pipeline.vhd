library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_bit.all;
use work.p_MI0.all;

entity mips_pipeline is
	port (
			  clk: in std_logic;
			  reset: in std_logic
		  );
end mips_pipeline;


architecture arq_mips_pipeline of mips_pipeline is


	 -- ********************************************************************
	 --                              Signal Declarations
	 -- ********************************************************************

	 -- IF Signal Declarations

	signal IF_instr,IF_instr4, IF_pc, IF_pc_next, IF_pc4,IF_pc8 : reg32 := (others => '0');

	 -- ID Signal Declarations

	signal ID_instr,ID_instr4, ID_pc4 ,ID_pc8:reg32;  -- pipeline register values from EX
	signal ID_op, ID_funct,ID_op4, ID_funct4: std_logic_vector(5 downto 0);
	signal id_rs, id_rt, id_rd, id_rs4, id_rt4, id_rd4: std_logic_vector(4 downto 0);
	signal ID_immed,ID_immed4: std_logic_vector(15 downto 0);
	signal ID_extend, ID_A, ID_B,ID_extend4, ID_A4, ID_B4,ID_btgt,ID_ALUOut,ID_offset: reg32;
	signal ID_RegWrite, ID_Branch, ID_RegDst, ID_MemtoReg, ID_MemRead, ID_MemWrite, ID_ALUSrc: std_logic; --ID Control Signals	
	signal ID_RegWrite4, ID_Branch4, ID_RegDst4, ID_MemtoReg4, ID_MemRead4, ID_MemWrite4, ID_ALUSrc4: std_logic; --ID4 Control Signals
	signal ID_ALUOp,ID_ALUOp4: std_logic_vector(1 downto 0);
	signal ID_Zero: std_logic;
	signal ID_Operation: std_logic_vector(2 downto 0);
	 -- EX Signals

	signal EX_pc8, EX_extend, EX_A, EX_B,EX_extend4, EX_A4, EX_B4: reg32;
	signal EX_offset,EX_offset4, EX_alub, EX_ALUOut,EX_alub4, EX_ALUOut4: reg32;
	signal EX_rt, EX_rd,EX_rt4, EX_rd4: std_logic_vector(4 downto 0);
	signal EX_RegRd,EX_RegRd4: std_logic_vector(4 downto 0);
	signal EX_funct,EX_funct4: std_logic_vector(5 downto 0);
	signal EX_RegWrite, EX_Branch, EX_RegDst, EX_MemtoReg, EX_ALUSrc: std_logic;  -- EX Control Signals
	signal EX_RegWrite4 ,EX_RegDst4, EX_MemRead4, EX_MemWrite4, EX_ALUSrc4: std_logic;  -- EX4 Control Signals
	signal EX_Zero,EX_Zero4: std_logic;
	signal EX_ALUOp,EX_ALUOp4: std_logic_vector(1 downto 0);
	signal EX_Operation,EX_Operation4: std_logic_vector(2 downto 0);



	 -- MEM Signals

	signal MEM_PCSrc: std_logic;
	signal MEM_RegWrite, MEM_Branch, MEM_Zero: std_logic;
	signal MEM_RegWrite4, MEM_MemRead4, MEM_MemWrite4, MEM_Zero4: std_logic;
	signal MEM_ALUOut,MEM_ALUOut4, MEM_B,MEM_B4: reg32;
	signal MEM_memout4: reg32;
	signal MEM_RegRd,MEM_RegRd4: std_logic_vector(4 downto 0);


	 -- WB Signals

	signal WB_RegWrite,WB_RegWrite4: std_logic;  -- WB Control Signals
	signal WB_memout4, WB_ALUOut,WB_ALUOut4: reg32;
	signal WB_RegRd,WB_RegRd4: std_logic_vector(4 downto 0);



begin -- BEGIN MIPS_PIPELINE ARCHITECTURE

	 -- ********************************************************************
	 --                              IF Stage
	 -- ********************************************************************

	 -- IF Hardware

	PC: entity work.reg port map (clk, reset, IF_pc_next, IF_pc); 

	PC4: entity work.add32 port map (IF_pc, x"00000004", IF_pc4);

	PC8: entity work.add32 port map (IF_pc4, x"00000004", IF_pc8);

	MX2: entity work.mux2 port map (MEM_PCSrc, IF_pc8, ID_btgt, IF_pc_next); --PC receberá Branch ou PC + 8

	ROM_INST: entity work.rom32 port map (IF_pc, IF_instr); --Decodifica R-Type ou Branch

	ROM_INST4: entity work.rom32 port map (IF_pc4, IF_instr4); --Decodifica LW ou SW

	IF_s: process(clk)
	begin     			-- IF/ID Pipeline Register
		if rising_edge(clk) then
			if reset = '1' then
				ID_instr <= (others => '0');
				ID_instr4<= (others => '0');
				ID_pc8  <= (others => '0');
			else
				ID_instr <= IF_instr;
				ID_instr4 <= IF_instr4;
				ID_pc8  <=  ID_pc8;
			end if;
		end if;
	end process;



	 -- ********************************************************************
	 --                              ID Stage
	 -- ********************************************************************

	ID_op <= ID_instr(31 downto 26);
	ID_rs <= ID_instr(25 downto 21);
	ID_rt <= ID_instr(20 downto 16);
	ID_rd <= ID_instr(15 downto 11);
	ID_immed <= ID_instr(15 downto 0);

	ID_op4 <= ID_instr4(31 downto 26);
	ID_rs4 <= ID_instr4(25 downto 21);
	ID_rt4 <= ID_instr4(20 downto 16);
	ID_rd4 <= ID_instr4(15 downto 11);
	ID_immed4 <= ID_instr4(15 downto 0);

	REG_FILE: entity work.reg_bank port map ( clk, reset, WB_RegWrite, WB_RegWrite4,ID_rs, ID_rt, WB_RegRd, ID_rs4, ID_rt4, WB_RegRd4,ID_A, ID_B,ID_A4, ID_B4,WB_ALUOut,
														 	WB_memout4);


	 -- sign-extender
	EXT: process(ID_immed)
	begin
		if ID_immed(15) = '1' then
			ID_extend <= x"FFFF" & ID_immed(15 downto 0);
		else
			ID_extend <= x"0000" & ID_immed(15 downto 0);
		end if;
	end process;

	 -- sign-extender2
	EXT4: process(ID_immed4)
	begin
		if ID_immed4(15) = '1' then
			ID_extend4 <= x"FFFF" & ID_immed4(15 downto 0);
		else
			ID_extend4 <= x"0000" & ID_immed4(15 downto 0);
		end if;
	end process;


	CTRL: entity work.control_pipeline port map (ID_op, ID_RegDst, ID_ALUSrc, ID_RegWrite, ID_MemRead, ID_MemWrite, ID_Branch, ID_ALUOp);

	CTRL4: entity work.control_pipeline port map (ID_op4, ID_RegDst4, ID_ALUSrc4, ID_RegWrite4, ID_MemRead4, ID_MemWrite4, ID_Branch4, ID_ALUOp4);
		--Branch estágio ID
	ID_funct <= ID_extend(5 downto 0);  

	ALU_h_ID: entity work.alu port map (ID_Operation, ID_A, ID_B, ID_ALUOut, ID_Zero);

	ALU_c_ID: entity work.alu_ctl port map (ID_ALUOp, ID_funct, ID_Operation);


	 -- branch offset shifter
	SIGN_EXT: entity work.shift_left port map (ID_extend, 2, ID_offset);

	BRANCH_ADD: entity work.add32 port map (ID_pc8, ID_offset, ID_btgt);

	MEM_PCSrc <= ID_Branch and ID_Zero;

	ID_EX_pip: process(clk)		    -- ID/EX Pipeline Register
	begin
		if rising_edge(clk) then
			if reset = '1' then
				EX_RegDst   <= '0';
				EX_ALUOp    <= (others => '0');
				EX_ALUSrc   <= '0';
				EX_Branch   <= '0';
				EX_RegWrite <= '0';

				EX_RegDst4   <= '0';
				EX_ALUSrc4   <= '0';
				EX_MemRead4  <= '0';
				EX_MemWrite4 <= '0';
				EX_RegWrite4 <= '0';

				EX_pc8      <= (others => '0');
				EX_A        <= (others => '0');
				EX_B        <= (others => '0');
				EX_extend   <= (others => '0');
				EX_rt       <= (others => '0');
				EX_rd       <= (others => '0');

				EX_ALUOp4   <= (others => '0');				
				EX_A4        <= (others => '0');
				EX_B4       <= (others => '0');
				EX_extend4   <= (others => '0');
				EX_rt4       <= (others => '0');
				EX_rd4       <= (others => '0');

			else 
				EX_RegDst   <= ID_RegDst;
				EX_ALUOp    <= ID_ALUOp;
				EX_ALUSrc   <= ID_ALUSrc;
				EX_Branch   <= ID_Branch;
				EX_RegWrite <= ID_RegWrite;
			
				EX_RegDst4   <= ID_RegDst4;
				EX_ALUOp4    <= ID_ALUOp4;
				EX_ALUSrc4   <= ID_ALUSrc4;
				EX_MemRead4  <= ID_MemRead4;
				EX_MemWrite4 <= ID_MemWrite4;
				EX_RegWrite4 <= ID_RegWrite4;

				EX_pc8      <= ID_pc8;
				EX_A        <= ID_A;
				EX_B        <= ID_B;
				EX_extend   <= ID_extend;
				EX_rt       <= ID_rt;
				EX_rd       <= ID_rd;
	
				EX_A4        <= ID_A4;
				EX_B4        <= ID_B4;
				EX_extend4   <= ID_extend4;
				EX_rt4       <= ID_rt4;
				EX_rd4       <= ID_rd4;
			end if;
		end if;
	end process;

	 -- ********************************************************************
	 --                              EX Stage
	 -- ********************************************************************



	EX_funct <= EX_extend(5 downto 0);  


	ALU_MUX_A: entity work.mux2 port map (EX_ALUSrc, EX_B, EX_extend, EX_alub);

	ALU_h: entity work.alu port map (EX_Operation, EX_A, EX_alub, EX_ALUOut, EX_Zero);

	DEST_MUX2: entity work.mux2 generic map (5) port map (EX_RegDst, EX_rt, EX_rd, EX_RegRd);

	ALU_c: entity work.alu_ctl port map (EX_ALUOp, EX_funct, EX_Operation);

	ALU4_MUX_A: entity work.mux2 port map (EX_ALUSrc4, EX_B4, EX_extend4, EX_alub4);

	ALU4_h: entity work.alu port map (EX_Operation4, EX_A4, EX_alub4, EX_ALUOut4, EX_Zero4);

	DEST4_MUX2: entity work.mux2 generic map (5) port map (EX_RegDst4, EX_rt4, EX_rd4, EX_RegRd4);

	ALU4_c: entity work.alu_ctl port map (EX_ALUOp4, EX_funct4, EX_Operation4);


	EX_MEM_pip: process (clk)		    -- EX/MEM Pipeline Register
	begin
		if rising_edge(clk) then
			if reset = '1' then

				MEM_Branch   <= '0';
				MEM_RegWrite <= '0';
				MEM_Zero     <= '0';

				MEM_MemRead4  <= '0';
				MEM_MemWrite4 <= '0';
				MEM_RegWrite4 <= '0';
				MEM_Zero4     <= '0';
			
				MEM_ALUOut   <= (others => '0');
				MEM_B        <= (others => '0');
				MEM_RegRd    <= (others => '0');

				MEM_ALUOut4   <= (others => '0');
				MEM_B4        <= (others => '0');
				MEM_RegRd4    <= (others => '0');

			else
				MEM_Branch   <= EX_Branch;
				MEM_RegWrite <= EX_RegWrite;
				MEM_Zero     <= EX_Zero;

				MEM_MemRead4  <= EX_MemRead4;
				MEM_MemWrite4 <= EX_MemWrite4;
				MEM_RegWrite4 <= EX_RegWrite4;
				MEM_Zero4     <= EX_Zero4;

				MEM_ALUOut   <= EX_ALUOut;
				MEM_B        <= EX_B;
				MEM_RegRd    <= EX_RegRd;
				
				MEM_ALUOut4   <= EX_ALUOut4;
				MEM_B4        <= EX_B4;
				MEM_RegRd4    <= EX_RegRd4;
			end if;
		end if;
	end process;

	 -- ********************************************************************
	 --                              MEM Stage
	 -- ********************************************************************

	MEM_ACCESS: entity work.mem32 port map (clk, MEM_MemRead4, MEM_MemWrite4, MEM_ALUOut4, MEM_B4, MEM_memout4);


	MEM_WB_pip: process (clk)		-- MEM/WB Pipeline Register
	begin
		if rising_edge(clk) then
			if reset = '1' then
				WB_RegWrite <= '0';
				WB_ALUOut   <= (others => '0');
				WB_RegRd    <= (others => '0');

				WB_RegWrite4 <= '0';
				WB_ALUOut4   <= (others => '0');
				WB_memout4   <= (others => '0');
				WB_RegRd4    <= (others => '0');
			else
				WB_RegWrite <= MEM_RegWrite;
				WB_ALUOut   <= MEM_ALUOut;
				WB_RegRd    <= MEM_RegRd;

				WB_RegWrite4 <= MEM_RegWrite4;
				WB_ALUOut4   <= MEM_ALUOut4;
				WB_memout4   <= MEM_memout4;
				WB_RegRd4    <= MEM_RegRd4;
			end if;
		end if;
	end process;       

	 -- ********************************************************************
	 --                              WB Stage
	 -- ********************************************************************


--REG_FILE: reg_bank port map (clk, reset, WB_RegWrite, ID_rs, ID_rt, WB_RegRd, ID_A, ID_B, WB_wd); *instance is the same of that in the ID stage


end arq_mips_pipeline;

