--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Banco de registradores - 31 registradores de uso geral - reg(0): cte 0
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;   
use work.p_MI0.all;

entity reg_bank is
       port( ck, rst, wreg,wreg4 :    in std_logic;
             AdRs, AdRt, adRD : in std_logic_vector( 4 downto 0);--Registradores de PC -> R-Type
							 AdRs4, AdRt4, adRD4 : in std_logic_vector( 4 downto 0);--Registradores de PC -> SW/LW
             RA, RB: out reg32;
             RA4, RB4: out reg32;  
		 		 RW,RW2 : in reg32 --WB_aluout e WB_memout
           );
end reg_bank;

architecture reg_bank of reg_bank is
   type bank is array(0 to 31) of reg32;
   signal reg: bank;                            
   signal wen,wen2 : reg32;
begin            

    g1: for i in 0 to 31 generate        

			wen(i) <= '1' when (i/=0 and adRD=i and wreg='1') else '0'; --sinal de escrita para instrução R
			wen2(i)<= '1'when	 (i/=0 and adRD4=i and wreg4='1')  else '0'; --sinal de escrita para instrução LW/SW



         
        rx: entity work.reg32b_ce
			port map(ck=>ck, rst=>rst, ce=>wen(i),ce2=>wen2(i), D=>RW,D2=>Rw2, Q=>reg(i));                   
        
                

    end generate g1;      

    RA <= reg(CONV_INTEGER(AdRs));    -- seleção do fonte 1.0  

    RB <= reg(CONV_INTEGER(AdRt));    -- seleção do fonte 2.0 
   
    RA4 <= reg(CONV_INTEGER(AdRs4));    -- seleção do fonte 1.4  

    RB4 <= reg(CONV_INTEGER(AdRt4));    -- seleção do fonte 2.4
end reg_bank;
