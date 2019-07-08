.data
numero: .word

.text
addi t0, zero, 25
sw t0, 0(zero)
lw t1, 0(zero)
add t2, t1, t0		# 50