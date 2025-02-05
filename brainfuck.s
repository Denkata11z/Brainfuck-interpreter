.global brainfuck
.data
arr: .zero 30000

.text
format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

here: .asciz "here\n"
outputc: .asciz "%c"
outputd: .asciz "%d\n"


brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	subq $16,%rsp
	movq %r12,-16(%rbp) #remembers the string
	
	subq $16, %rsp
	movq %r13,-32(%rbp) # the instruction pointer

	subq $16,%rsp
	movq %r14,-48(%rbp) # the pointer in the array

	leaq arr,%r14 #load the first element of the array

	movq %rdi,%r12 # copy the string in r12
	movq $0,%r13 # start from the beginning


#print 

	movq %r12, %rsi
	movq $format_str, %rdi
	call printf
	movq $0, %rax
	
#print
	
loop:
	movq $0, %rcx
	movb (%r12, %r13),%cl #extract the character
	
	cmpq $0,%rcx #terminate the process
	je afterloop

	cmpq $'>', %rcx
	je incdatapointer

	cmpq $'<', %rcx
	je decdatapointer

	cmpq $'+', %rcx
	je incval

	cmpq $'-', %rcx
	je decval

	cmpq $'.', %rcx
	je printsth

	cmpq $',', %rcx
	je readsth

	cmpq $'[', %rcx
	je leftbracket

	cmpq $']', %rcx
	je rightbracket

	#neither
	jmp endofiteration

incdatapointer:

addq $'1', %r14
jmp endofiteration

decdatapointer:

subq $'1', %r14
jmp endofiteration

incval:

incq (%r14)
jmp endofiteration

decval:
decq (%r14)
jmp endofiteration

printsth:

movq (%r14),%rsi
movq $0,%rax
movq $outputc, %rdi
call printf
/*
//printing with syscall
movq $1, %rdi			
movq $1, %rax			
movq (%r14), %rsi 		
movq $1, %rdx 			
syscall 					
*/


jmp endofiteration

readsth:

movq $0,%rax
leaq -64(%rbp),%rsi #read the value on the top of the array
movq $outputc,%rdi
call scanf

movq -64(%rbp),%rax
movq %rax,(%r14)

/*
 movq $0, %rdi			# make sure %rdi is empty
 movq $0, %rax			# code 0: sys_read
 movq (%r14), %rdi 		# where to read the value
 movq $outputc, %rsi		# format string
 movq $0, %rdx 			# prepare parameters
 syscall 				
*/
jmp endofiteration

leftbracket:

movq (%r14),%rax

cmpq $0,%rax
jne endofiteration #if the value at the pointer is non zero - just move forward

#now we should find its closing bracket
movq $1,%rax
	
	loopfind:
	cmpq $0,%rax
	jle loop # in order not to skip a character
	
	incq %r13
	movq $0, %rcx
	movb (%r12, %r13),%cl 

	cmpq $'[', %rcx
	je lefty 

	cmpq $']',%rcx
	jne loopfind

righty:
	decq %rax
	jmp loopfind
lefty:
	incq %rax
	jmp loopfind

jmp endofiteration # never reached

rightbracket:

movq (%r14),%rax

cmpq $0,%rax
je endofiteration #if the value at the pointer is non zero - just move forward

#now we should find its opening bracket
movq $1,%rax
	
	loopfind2:
	cmpq $0,%rax
	jle loop #not to skip a character
	
	decq %r13
	movq $0, %rcx
	movb (%r12, %r13),%cl 

	cmpq $'[', %rcx
	je lefty2 

	cmpq $']',%rcx
	jne loopfind2

righty2:
	incq %rax
	jmp loopfind2
lefty2:
	decq %rax
	jmp loopfind2

jmp loop # never reached

jmp endofiteration

endofiteration:
	incq %r13 # move to the next character
	jmp loop

afterloop:

epilogue: 
	movq -16(%rbp),%r12 #restore its initial values
	movq -32(%rbp),%r13 #restore its initial values
	movq -48(%rbp),%r14
	movq %rbp, %rsp
	popq %rbp
	ret
