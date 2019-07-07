.text
                            #                                    1001(9)  xor => 0011(3)
addi t0, zero, 10 	        # 0000 0000 0000 0000 0000 0000 0000 1010
addi t1, t0, 10           # usar valor anterior pra ter certeza que salvou no xregs
andi t2, t0, 0x00000002     # 0000 0000 0000 0000 0000 0000 0000 0010 = 2
ori  t3, t1, 0x00000001     # = 21
xori t4, t0, 0x00000009     # = 3
slli t5, t0, 1		        # t5 = 20
srli t5, t0, 1		        # t5 = 10
srai t5, t5, 1		        # t5 = 5 (falta verifica extens�o de sinal)
slti t2, t2, 4	            # 2 < 4 ? = 1
sltiu t2, t2, 0		        # 1 < 0 ? = 0
