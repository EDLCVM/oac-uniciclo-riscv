
.text
  jalr  ra, t1, 8    # Salta 2 instrucoes
  add zero,zero,zero # Nao executa
  addi  t0, t0, 2    # t0 = 2
  addi  t1, t1, 3    # t1 = 3
  addi  t3, t3, 1024 # t3 = 1024
  slli  t3, t3, 3    # t3 = 8192, endereço base 0x2000
  add   t2, t0, t1   # t2 = 5
  and   t1, t1, t2   # t1 = 1
  ori   t1, t2, 3    # t1 = 7
  xori  t1, t2, 16   # t1 = 21
  or    t1, t1, t0   # t1 = 23 
  xor   t1, t1, t0   # t1 = 21
  slli  t1, t1, 1    # t1 = 42
  srli  t1, t1, 2    # t1 = 10
  srai  t1, t1, 1    # t1 = 5
  sw    t0, 0(t3)    # 2 armazenado na memória
  lw    t1, 0(t3)    # t1 = 2
  sub   t1, t2, t1   # t1 = 3, t2=5
  slt   t1, t1, t2   # t1 = 1
  slti  t1, t1, -1   # t1 = 0 
  sltu  t1, t1, t2   # t1 = 1
  sltiu t1, t1, 2    # t1 = 1
  beq   t1, t2, naoSaltaBeq 
  bne   t1, t2, saltaBne 
naoSaltaBeq:
  addi  t1, t1, 1    # Não executa
saltaBne:
  addi  t1, t1, 7    # t1 = 8
  blt   t1, t2, naoSaltaBlt
  bge   t1, t2, saltaBge
naoSaltaBlt:
  addi t1, t1, 2     # Nao Executa   
saltaBge:
  addi t1, t1, 2     # t1 = 10   
  jal  saltoJal
  add  t1, t1, t1    # Nao executa
saltoJal:
  addi t1, t1, 6     # t1 = 16
  lui t1, -1
  
