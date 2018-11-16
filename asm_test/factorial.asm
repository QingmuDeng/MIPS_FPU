addi $t0, $zero, 5
addi $sp, $zero, 0x00003ffc

MAIN:
add $a0, $t0, $zero
jal FACTORIAL
move $a0, $zero
j END

END:
j END	

FACTORIAL:
beq $a0, 1, ELSE
#else
addi $sp, $sp, -8
sw $ra, 4($sp)
sw $a0, 0($sp)
addi $a0, $a0, -1
jal FACTORIAL
#load stored value of n
lw $a0, 0($sp)
mult $v0, $a0
mflo $v0
#load next address
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra

#if equal
ELSE:
addi $v0, $zero, 1
jr $ra
