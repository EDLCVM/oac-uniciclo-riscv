addi t0,t0,1
addi t1,t1,2
add t0,t0,t0 #2
sll t0,t0,t0 #8
srl t0,t0,t1 #2
and t0,t1,t0 #2
xor t0,t1,t0 #0
or t0,t1,t0 #2
sltu t0,t0,t0 #0
sub t0,t1,t0 #2
