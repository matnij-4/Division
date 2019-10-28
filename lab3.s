# Mips program made to do simple divisions and made by Mattias Nilsson, Matnij-4

        .text
        .set noreorder


main:	

	ori	$a0, $zero, 12		# 12 Divided by 3
	bal	div
	ori 	$a1, $zero, 3

	
	ori	$a0, $zero, 25		# 25 Divided by 4
	bal	div
	ori 	$a1, $zero, 4
	

	ori	$a0, $zero, 19		# 19 Divided by Zero
	bal	div
	ori 	$a1, $zero, 0

end:	b	end
	nop

	


div:  # ++++++++++ Divition function +++++++++

	        
        

	or	$t0, $zero, $a0		# Load the values to t registers.
	or	$t1, $zero, $a1

	beq	$a1, $zero, overf	# Cheack it you are trying to divide by zero.
	nop	
	
	or	$t2, $zero, $zero	# How many times it can be divided.


loop:	sub	$t4, $t0, $t1		# See if the next one will be less then zero.

	bltz	$t4, exit		#jump out if it smaller. Then return the values of t2 and t0.
	nop


	sub	$t0, $t0, $t1		# subtract the value onces.

	addi	$t2, $t2, 1		# Add it onces.

	b	loop			# Keept the loop going.
	nop
	


overf:	
	ori	$a1, $zero, 0xff	# Set a1 t0 0xff to make a oveflow in the kernal.	
	syscall				# Division by zero was detected. Sends it to Kernal.






exit:	or	$v0, $t2, $zero		# Retunr v0

	or	$v1, $t0, $zero		# Retunr v1

	jr	$31			# Jump back.
	nop








        .section .kdata


# Fourth section: kernel code.

        .section .ktext , "xa"
        .set noreorder

	mfc0	$k0, $13		#loads Exception Program Counter
	nop
	
	sll	$k0, $k0, 25		#removes bits 31:6
	srl 	$k0, $k0, 27		#removes bits 1:0
	ori	$k1, $zero, 8		#initalize comparator
	bne	$k0, $k1, kernel_loop	#branch if s0 != 8
	nop
	
	ori	$k1, $zero, 0xff	#initalize comparator
	bne	$a1, $k1, return	#branch if v0 != 0xff
	nop

	lui $t0, 0x7FFF			# Will create and overflow.
	ori $t0, $t0, 0xFFFF		# This will Chrash the program.
	addi $t0, $t0, 1		# arithmetic Overflow.




return:	mfc0	$k0, $14		#loads EPC register
	nop
	addiu	$k0, $k0, 4		#one instruction after syscall
	jr	$k0			#jumps to that instruction
	rfe				#switch to user mode	# return the power to the user
	


kernel_loop:




        b 	kernel_loop		# loop if the call is not syscall
        nop


















