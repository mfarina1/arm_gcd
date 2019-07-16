.data
	int :		.asciz "%d"
	newline :	.asciz "\n"
	prompt :	.asciz "Enter Two Integers: "
	m :		.space 256 //user-inputted integer
	n : 		.space 256 //user-inputted integer

.global main
.text

main:
	//prints prompt
	ldr x0, = prompt
	bl printf

	//scans in the inputs
	ldr x0, = int
	ldr x1, = m
	bl scanf

	ldr x0, = int
	ldr x1, = n
	bl scanf

	ldr x19, = m
	ldrsw x19, [x19] //dereference
	ldr x20, = n
	ldrsw x20, [x20] 
	
	cbz x19, m_print //for base case, if m is zero

	cbz x20, n_print //if n is zero

	//if m is negative, negate m
	cmp x19, #0
	blt neg_m

	b gcd

	//flushes
	ldr x0, = newline
	bl printf

exit:
	mov x0, #0
	mov x8, #93
	svc #0

m_print:
	mov x1, x20
	ldr x0, = int
	bl printf //just print n
	ldr x0, = newline
	bl printf
	b exit

n_print:
	mov x1, x19
	ldr x0, = int
	bl printf //just print m
	ldr x0, = newline
	bl printf
	b exit
	
neg_m:
	neg x19, x19
	b gcd
neg_n:
	neg x20, x20
	b gcd
	
gcd: 

	//if n is negative, negate n
	cmp x20, #0
	blt neg_n	

	//if m and n are equal
	subs x21, x19, x20
	cbz x21, m_print
	
	//if m is greater than n, return gcd(m-n, n)
	subs x22,x19,x20
	b.ge greater

	//else return gcd(m, n-m)
	b less

greater:
	//for when m > n
	
	//this calculates m - n and saves in m register
	subs x19, x19, x20
	bl gcd
	
less:
	//for when m < n
	
	//this calculates n - m and saves in n register
	subs x20, x20, x19
	bl gcd

	br x30	

recurse:
	//first we store the frame pointer (x29) and link register (x30)
	sub sp, sp, #16
	str x29, [sp, #0]
	str x30, [sp, #8]


	//move our frame pointer
	add x29, sp, #8

	//make room for the index of the stack
	sub sp, sp, #32

	//store it with respect to the frame pointer
	str x19, [x29, #-16]
	str x20, [x29, #-24]

	//branch to original function
	bl gcd

end_recursion:
	//load m and n
	ldr x19, [x29, #16]
	ldr x20, [x29, #24]

	//clear off stack space used to hold index
	add sp, sp, #32

	//load in fp and lr
	ldr x29, [sp, #0]
	ldr x30, [sp, #8]

	//clear off stack space used to hold fp and lr
	add sp, sp, #16

	br x30

