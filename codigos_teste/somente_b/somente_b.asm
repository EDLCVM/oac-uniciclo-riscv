.text
addi t0, zero, 5
add zero, zero, zero
beq zero, zero, teste_beq
add zero, zero, zero
teste_beq:
bne t0, zero, teste_bne
add zero, zero, zero
add zero, zero, zero
teste_bne:
blt zero, t0, teste_blt
add zero, zero, zero
add zero, zero, zero
teste_blt:
bgt t0, zero, teste_bgt_1
add zero, zero, zero
teste_bgt_1:
bgt zero, zero, teste_bgt_2
add zero, zero, zero
teste_bgt_2:
addi t0, t0, 5