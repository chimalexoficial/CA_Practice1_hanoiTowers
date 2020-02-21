#Pedro Javier Herrera Soto
#Arturo Alexis Salgado Ramirez

.data
.text
main:
	addi $s0, $zero, 8 #total disks, user input
	addi $a1, $zero, 268500992 #memory position for tower A, asigning value by adding the wanted direction plus the vlaue 0 
	addi $a2, $zero, 268501024 #memory position for tower B, asigning value by adding the wanted direction plus the vlaue 0
	addi $a3, $zero, 268501056 #memory position for tower C, asigning value by adding the wanted direction plus the vlaue 0
	
	add $t0, $zero, $s0 #setting the registry t0 by adding the value of the regstry s0(the one used to store user input)
	jal initialize #put all the disks in tower A by calling the initialize funcion 
	
	addi $a0, $zero, 268501472 #pointers to towers , it uses the stack pointer in order to control the tower pointers by changing the pointed direction
	sw $a1, 0($a0)#tower 1 pointer , controls the discs in a tower
	sw $a2, 4($a0)#tower 2 pointer, controls the discs in b tower
	sw $a3, 8($a0)#tower 3 pointer, controls the discs in c tower
	addi $a1, $zero, 268501472#memory position for tower A pointer
	addi $a2, $zero, 268501476#memory position for tower B pointer
	addi $a3, $zero, 268501480#memory position for tower C pointer
	
	sw $s0, 4($sp)#first push to stack, size
	sw $a1, 8($sp)#first push to stack, tower A
	sw $a2, 12($sp)#first push to stack, tower B
	sw $a3, 16($sp)#first push to stack , tower C
	
	jal hanoi #calling the function that starts hanoi algorithm
		
	j end
		
initialize:
	sw $t0, 0($a1) #add disk to tower A
	addi $t0, $t0, -1 #change disk value , it decreases with every disc inserted in tower a until it reaches 0 
	addi $a1, $a1, 4 #change memory position, uodating the pointer after the new disc is inserted
	bne $t0,0,initialize#do it until the disk value is zero, it is like a for loop to iterate until the value of discs is 0
	
	jr $ra	
	
hanoi:	
	sw $ra, 0($sp)#push to stack, return address
	lw $t0, 4($sp)#obtain size of the amount of discs currently in the tower
	lw $s1, 8($sp)#obtain source tower, 
	lw $s2, 12($sp)#obtain auxiliar tower, this tower is used for swaping the discs
	lw $s3, 16($sp)#obtain destination tower, moving the stack pointer 4 units in order to get to the address of the destiation tower
	
	addi $t0, $t0, -1#change size and decrease it when a disc is removed, until the size get to 0
	beq $t0,0, return#if size is zero then stop and exits recurtion

	addi $sp, $sp, -20#push stack, moves the direction of wich you are reding and writting 
			
	sw $t0, 4($sp)#push to stack new size
	sw $s1, 8($sp)#push to stack source as source
	sw $s3, 12($sp)#push to stack destination as auxiliar
	sw $s2, 16($sp)#push to stack auxiliar as destination
	
	jal hanoi	
	
	addi $sp, $sp, 20#pop stack, the opposite operation it also moves the direction 
	
	jal movedisk	
	
	lw $t0, 4($sp)#obtain size, this load word instruction is loading the value of the sp to the registry t0
	lw $s1, 8($sp)#obtain source tower ,this load word instruction is loadingg the value of the sp to the registry s1
	lw $s2, 12($sp)#obtain auxiliar tower,this load word instruction is loading the value of the sp to the registry s2
	lw $s3, 16($sp)#obtain destination tower, this load word instruction is loading the value of the sp to the registry s3
	
	addi $t0, $t0, -1#change size
	addi $sp, $sp, -20#push stack, push stack, moves the direction of wich you are reding and writting 
	sw $t0, 4($sp)#push to stack new size
	sw $s2, 8($sp)#push to stack auxiliary as source
	sw $s1, 12($sp)#push to stack source as auxiliar
	sw $s3, 16($sp)#push to stack destination as destination
    	
	jal hanoi
		
	addi $sp, $sp, 20# pop stack, moves the direction of wich you are reding and writting 
	
	lw $t5, 0($sp)	#obtain return address, by loading the value of sp to the t5 registry
	jr $t5
	
movedisk:
	lw $t1, 8($sp)#obtain pointer position for source tower by loading the value of sp plus displacement in memory to t1
	lw $t3, 0($t1)#obtain source tower position
	lw $t2, 16($sp)#obtain pointer position for destination tower
	lw $t4, 0($t2)#obtain destination tower position
	
	addi $t3, $t3, -4 #change source tower position to match with the position of the last disk
	lw $t5, 0($t3)#obtain the value of the disk by loading the value of sp  in memory to t5
	
	sw $zero, 0($t3)#erase the disk from the tower by assigning 0 to the t3 registry
	sw $t5, 0($t4)#put the disk in the new tower by assigning t4 to the t5 registry
	
	addi $t4, $t4, 4#change destination tower position to match with the position of the last disk
	
	sw $t3, 0($t1)#update the source tower pointer by assigning t1 to the t3 registry
	sw $t4, 0($t2)#update the destination tower pointer by assigning t2 to the t4 registry
	
	jr $ra		
	
return:
	jal movedisk
	lw $t5, 0($sp)#obtain return address
	jr $t5
	
end:
