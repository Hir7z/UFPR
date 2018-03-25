#Test prog.asm - Edit your MIPS assembly here
#PS.: Some instructions below are not implemented in the processor datapath yet. 
#     You will have to implement, for example: addi, andi, ldi, jal, j, jr. Uncomment 
#     them only when their datapath structures and controls are available.
addi $1,$0,1
addi $2,$0,2
#swi $1,3
#swi $5,4
#lw  $3,4
#lw $8,4
#nop
#beq $1,$2,-2
#nop
addi $3,$0,3
addi $4,$0,4
add $4,$4,$1
add $4,$4,$2
add $4,$4,$3
#sw $1,6
#swi $2,3
#lw $2,6
#add $3,$2,$1
#add $4,$3,$2
#add $5,$4,$1
#add $4,$1,$1
