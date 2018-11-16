# Modify the elements in an array
# Tests lw, slt, sw specifically

# Preconditions: 
#    Array base address stored in register $t0
#    Array size (# of words) stored in register $t1
la 	$t0, my_array		# Store array base address in register (la pseudoinstruction)

# Initialize variables
addi	$t3, $t0, 0		# address of my_array[i] (starts from base address for i=0)

# Python Pseudocode:
#a = [1,3,5,7,9,11,13,15]
#for i in range(len(a)):
#    a[i] += 6
#    if a[i] < 10:
#        a[i] -= 4
#    else:
#        a[i] = a[i] + 7


MAIN:
l.s $f0, 0($t3)
l.s $f1, 4($t3)
add.s $f0, $f0, $f1
s.s $f0, 8($t3)
addi $t3, $t3, 12
l.s $f0, 0($t3)
l.s $f1, 4($t3)
add.s $f0, $f0, $f1
s.s $f0, 8($t3)
addi $t3, $t3, 12
l.s $f0, 0($t3)
l.s $f1, 4($t3)
sub.s $f0, $f0, $f1
s.s $f0, 8($t3)
addi $t3, $t3, 12
l.s $f0, 0($t3)
l.s $f1, 4($t3)
sub.s $f0, $f0, $f1
s.s $f0, 8($t3)
addi $t3, $t3, 12
j LOOPEND

LOOPEND:
j LOOPEND



# Pre-populate array data in memory
.data
my_array: # my_array[0]
0xc1b80000
0xc5af3800
0x00000000	
0x40133333
0x3ecccccd
0x00000000
0x4611b000
0xc1152752
0x00000000
0xc254cccd
0x3f4353f8
0x00000000