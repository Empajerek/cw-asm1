global mdiv
mdiv:
	mov	r11, rdi
	lea	rdi, -1[rsi]
	push	rbp
	mov	r8, rdx
	lea	r9, 0[0+rdi*8]
	push	rbx
	lea	r10, [r11+r9]
	mov	rcx, qword [r10]
	mov	rax, rcx
	mov	rbx, rcx
	xor	rbx, rdx
	cqo
	idiv	r8
	lea	rax, [rdx+r8]
	cqo
	idiv	r8
	mov	rax, rcx
	sub	rax, rdx
	mov	rsi, rdx
	cqo
	idiv	r8
	mov	qword [r10], rax
	test	rdi, rdi
	je	.L2
	lea	r10, -8[r11+r9]
	mov	r9d, 1
.L6:
	mov	rdi, qword [r10]
	mov	ecx, 63
.L5:
	mov	rax, rdi
	shr	rax, cl
	and	eax, 1
	lea	rax, [rax+rsi*2]
	mov	rsi, r9
	cqo
	sal	rsi, cl
	idiv	r8
	mov	rbp, rsi
	or	rsi, rdi
	not	rbp
	and	rbp, rdi
	mov	rdi, rbp
	test	rax, rax
	cmovne	rdi, rsi
	mov	rsi, rdx
	sub	ecx, 1
	jnb	.L5
	mov	qword [r10], rdi
	lea	rax, -8[r10]
	cmp	r11, r10
	je	.L2
	mov	r10, rax
	jmp	.L6
.L2:
	test	rbx, rbx
	jns	.L1
	test	rsi, rsi
	je	.L1
	sub	rsi, r8
.L8:
	mov	rax, qword [r11]
	add	r11, 8
	add	rax, 1
	mov	qword -8[r11], rax
	test	rax, rax
	je	.L8
.L1:
	mov	rax, rsi
	pop	rbx
	pop	rbp
	ret
