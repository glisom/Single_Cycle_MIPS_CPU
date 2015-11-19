	addi	$t0, $zero, 5
	addi	$t1, $zero, 7
start:	sw	$t0,  0($sp)
	sw	$t1, -4($sp)
	lw	$s0,  0($sp)
	lw	$s1, -4($sp)
	beq	$s0, $s1, Else
	add	$s3, $s0, $s1
	j	Exit
Else:	sub	$s3, $s0, $s1
Exit:	add	$s0, $s0, $s3
	or	$s1, $s1, $s3
	addi	$t0, $t0,  3
	addi	$t1, $t1,  3
	addi	$sp, $sp, -8
        j	start
