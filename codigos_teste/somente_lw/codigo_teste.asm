.data
# mesmo conteudo do dados.mif (memória de dados
numero: .word 0x0000000f, 0x0000000f, 0xffffffff, 0x0000003e, 0x00000010, 0x00000011, 0x000000ff

.text
la t0, numero
lw t1, 0(t0)
lw t2, 8(t0)
lw t3, 12(t0)