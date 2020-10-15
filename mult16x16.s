# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
####################
# Start of your code
#load first 8 bits of a to t2
		add 	t2, t3, x0
		andi    t2, t2, 0xff
#multiply first 8 bits of a with b
		mul		t2, t4, t2
		and		t2, t2, t0
#load last 4 bits of a to t5
        srli	t5, t3, 8
#multiply last 4 bits of a with b
		mul		t5, t4, t5
		and		t5, t5, t0
#shift the result of the last multiplacation and add the results of t5 and t2	
		slli	t5, t5, 8
		add 	t6, t2, t5


# End of your code
####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


