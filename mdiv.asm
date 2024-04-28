global mdiv
mdiv:
	push	rbp
	push	rbx
	sub	rsi, 1
	mov	r9, rdi
	mov	rdi, rdx
	lea	r8, [rsi*8]
	lea	r11, [r9+r8]
	sub	rsp, 8
	mov	rcx, qword [r11]
	mov	r10, rcx
	xor	r10, rdx
	shr	r10, 63
	cmp	rdx, -1
	jne	.L16
	mov	rax, 0x8000000000000000
	cmp	rcx, rax
	jne	.L16
.L14:
	mov	rax, 0x7fffffffffffffff
	mov	rbx, -1
	jmp	.L2
.L16:
	mov	rax, rcx
	cqo
	idiv	rdi
	lea	rax, [rdx+rdi]
	cqo
	idiv	rdi
	mov	rax, rcx
	sub	rax, rdx
	mov	rbx, rdx
	cqo
	idiv	rdi
.L2:
	mov	qword [r11], rax
	lea	rbp, -8[r9+r8]
	mov	r8d, 1
	test	rsi, rsi
	je	.L9
.L8:
	mov	rdx, qword 0[rbp]
	mov	ecx, 63
	jmp	.L7
.L17:
	or	rdx, rsi
	sub	ecx, 1
	jb	.L30
.L7:
	mov	rax, rdx
	mov	rsi, r8
	shr	rax, cl
	sal	rsi, cl
	and	eax, 1
	lea	rax, [rax+rbx*2]
	mov	rbx, rax
	sub	rbx, rdi
	mov	r11, rbx
	xor	r11, rax
	jns	.L17
	cmp	rdi, rax
	je	.L17
	not	rsi
	mov	rbx, rax
	and	rdx, rsi
	sub	ecx, 1
	jnb	.L7
.L30:
	mov	qword [rbp], rdx
	lea	rax, [rbp-8]
	cmp	r9, rbp
	je	.L9
	mov	rbp, rax
	jmp	.L8
.L9:
	test	rbx, rbx
	je	.L11
	test	r10b, r10b
	je	.L11
	sub	rbx, rdi
.L12:
	mov	rax, qword [r9]
	add	r9, 8
	add	rax, 1
	mov	qword [r9-8], rax
	test	rax, rax
	je	.L12
.L11:
	xor rdx, rdx
	sub rdi, rbx
	idiv rdi
	add	rsp, 8
	mov	rax, rbx
	pop	rbx
	pop	rbp
	ret