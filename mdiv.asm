global mdiv
mdiv:
	push	rbp					; push the stack
	push	rbx
	sub	rsi, 1					; rsi = n-1
	mov	r9, rdi					; r9 = &x[0]
	mov	rdi, rdx				; rdi = y
	lea	r8, [rsi*8]
	lea	r11, [r9+r8]			; r11 = &x[n--]
	mov	rcx, qword [r11]		; rcx = x[n]
	mov	r10, rcx
	xor	r10, rdx				; r10 = sign of division
	shr	r10, 63
	cmp	rdx, -1					; if y != -1
	jne	.normal_divison
	mov	rax, 0x8000000000000000
	cmp	rcx, rax				; if x[n] != INT64_MIN
	jne	.normal_divison
	mov	rbx, -1					; rbx(remainder) = (-1)
	mov	rax, 0x7fffffffffffffff ; rax = INT64_MAX
	jmp	.load_values
.normal_divison:
	mov	rax, rcx
	cqo
	idiv	rdi
	lea	rax, [rdx+rdi]
	cqo
	idiv	rdi
	mov	rax, rcx
	sub	rax, rdx
	mov	rbx, rdx				; rbx(remainder) = (x[n] % y + y) % y
	cqo
	idiv	rdi					; rax = (x[n] - buf) / y (result in first 64 bits)
.load_values:
	mov	qword [r11], rax		; x[n] = rax
	lea	rbp,  [r9+r8-8]			; rbp = &x[n-1]
	mov	r8d, 1
	test	rsi, rsi			; if n == 0 => jmp .after_loop
	je	.after_loop
.start_loop:
	mov	rdx, qword [rbp]		; rdx = x[n-1]
	mov	ecx, 63					; ecx = 63
	jmp	.inner_loop
.set_one:
	or	rdx, rsi				; x[n] |= 1 << ecx
	sub	ecx, 1
	jb	.set_bits
.inner_loop:
	mov	rax, rdx
	mov	rsi, r8
	shr	rax, cl
	sal	rsi, cl
	and	eax, 1
	lea	rax, [rax+rbx*2]
	mov	rbx, rax				; remainder = (remainder << 1) + ((x[n] >> ecx) & 1)
	sub	rbx, rdi				; remainder -= y
	mov	r11, rbx
	xor	r11, rax				; if remainder - y  doesn't change sign
	jns	.set_one
	cmp	rdi, rax				; if remainder == y
	je	.set_one
	not	rsi
	mov	rbx, rax				; remainder += y
	and	rdx, rsi				; x[n] &= ~(1 << ecx)
	sub	ecx, 1
	jnb	.inner_loop
.set_bits:
	mov	qword [rbp], rdx		; set x[n]
	lea	rax, [rbp-8]			; rax = &x[n-1]
	cmp	r9, rbp					; if &x[n-1] == &x[0]
	je	.after_loop
	mov	rbp, rax				; n--
	jmp	.start_loop
.after_loop:
	test	rbx, rbx			; if buf == 0
	je	.end
	test	r10b, r10b			; if sign < 0
	je	.end
	sub	rbx, rdi				; change sign of remainder
.add_one:
	mov	rax, qword [r9]
	add	r9, 8
	add	rax, 1
	mov	qword [r9-8], rax
	test	rax, rax
	je	.add_one				; adding one until we don't overflow
.end:
	xor rdx, rdx
	sub rdi, rbx
	idiv rdi					; dividing by buf - y, so we triger SIGFPE when we divide min number by -1
	mov	rax, rbx
	pop	rbx						; pop the stack
	pop	rbp
	ret