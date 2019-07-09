.text

addi t1, zero, 8
jal t0, teste_jal
add zero, zero, zero
add zero, zero, zero
teste_jal:
add zero, t0, zero    # verifica se escreveu
add zero, zero, zero
jalr t0, t1, 0x18
add zero, zero, zero
add zero, t0, zero
