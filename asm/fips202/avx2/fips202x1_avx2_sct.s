	.att_syntax
	.text
	.p2align	5
	.global	keccak_squeeze
	.global	keccak_absorb
	.global	shake256_init
	.global	shake128_init
	.global	sha3_512_init
	.global	sha3_384_init
	.global	sha3_256_init
	.global	sha3_224_init
	.global	shake256
	.global	shake128
	.global	sha3_512
	.global	sha3_384
	.global	sha3_256
	.global	sha3_224
	.type	keccak_squeeze, %function
keccak_squeeze:
	movq	%rsp, %rax
	leaq	-56(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	lfence
	movq	$0, %rcx
	movq	%rdi, %r8
	cmpq	$0, %rsi
	jbe 	.Lkeccak_squeeze$1
	movq	$-1, %rdx
	cmovbe	%rdx, %rcx
	movq	200(%r8), %rdx
// declassify_val u64 %rdx
	orq 	%rcx, %rdx
	shrq	$16, %rdx
	cmpb	$0, %dl
	je  	.Lkeccak_squeeze$3
	call	.L_finish_updstate$1
.Lkeccak_squeeze$4:
.Lkeccak_squeeze$3:
	call	.L_squeeze_m_updstate$1
.Lkeccak_squeeze$2:
.Lkeccak_squeeze$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	keccak_absorb, %function
keccak_absorb:
	movq	%rsp, %rax
	leaq	-56(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rdi, %rax
	movq	%rdx, %r8
	lfence
	movq	$0, %rcx
	call	.L_absorb_m_updstate$1
.Lkeccak_absorb$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	shake256_init, %function
shake256_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$17, %r10b
	movb	$31, %dl
	call	.L_init_updstate$1
.Lshake256_init$1:
	movq	%r9, %rsp
	ret
	.type	shake128_init, %function
shake128_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$21, %r10b
	movb	$31, %dl
	call	.L_init_updstate$1
.Lshake128_init$1:
	movq	%r9, %rsp
	ret
	.type	sha3_512_init, %function
sha3_512_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$9, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_512_init$1:
	movq	%r9, %rsp
	ret
	.type	sha3_384_init, %function
sha3_384_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$13, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_384_init$1:
	movq	%r9, %rsp
	ret
	.type	sha3_256_init, %function
sha3_256_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$17, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_256_init$1:
	movq	%r9, %rsp
	ret
	.type	sha3_224_init, %function
sha3_224_init:
	movq	%rsp, %r9
	andq	$-8, %rsp
	movq	%rdi, %rax
	lfence
	movq	$0, %rcx
	movb	$18, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_224_init$1:
	movq	%r9, %rsp
	ret
	.type	shake256, %function
shake256:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rsi, %r9
	movq	%rdx, %rsi
	movq	%rcx, %r8
	movq	%rsp, %rax
	movb	$17, %r10b
	movb	$31, %dl
	call	.L_init_updstate$1
.Lshake256$4:
	movq	%rdi, %mm5
	movq	%r9, %mm6
	call	.L_absorb_m_updstate$1
.Lshake256$3:
	call	.L_finish_updstate$1
.Lshake256$2:
	movq	%mm5, %rax
	movq	%mm6, %rsi
	call	.L_squeeze_m_updstate$1
.Lshake256$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
	.type	shake128, %function
shake128:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rsi, %r9
	movq	%rdx, %rsi
	movq	%rcx, %r8
	movq	%rsp, %rax
	movb	$21, %r10b
	movb	$31, %dl
	call	.L_init_updstate$1
.Lshake128$4:
	movq	%rdi, %mm5
	movq	%r9, %mm6
	call	.L_absorb_m_updstate$1
.Lshake128$3:
	call	.L_finish_updstate$1
.Lshake128$2:
	movq	%mm5, %rax
	movq	%mm6, %rsi
	call	.L_squeeze_m_updstate$1
.Lshake128$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
	.type	sha3_512, %function
sha3_512:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rdx, %r8
	movq	%rsp, %rax
	movb	$9, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_512$4:
	movq	%rdi, %mm5
	call	.L_absorb_m_updstate$1
.Lsha3_512$3:
	call	.L_finish_updstate$1
.Lsha3_512$2:
	movq	%mm5, %rax
	movq	$64, %rsi
	call	.L_squeeze_m_updstate$1
.Lsha3_512$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
	.type	sha3_384, %function
sha3_384:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rdx, %r8
	movq	%rsp, %rax
	movb	$13, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_384$4:
	movq	%rdi, %mm5
	call	.L_absorb_m_updstate$1
.Lsha3_384$3:
	call	.L_finish_updstate$1
.Lsha3_384$2:
	movq	%mm5, %rax
	movq	$48, %rsi
	call	.L_squeeze_m_updstate$1
.Lsha3_384$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
	.type	sha3_256, %function
sha3_256:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rdx, %r8
	movq	%rsp, %rax
	movb	$17, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_256$4:
	movq	%rdi, %mm5
	call	.L_absorb_m_updstate$1
.Lsha3_256$3:
	call	.L_finish_updstate$1
.Lsha3_256$2:
	movq	%mm5, %rax
	movq	$32, %rsi
	call	.L_squeeze_m_updstate$1
.Lsha3_256$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
	.type	sha3_224, %function
sha3_224:
	movq	%rsp, %rax
	leaq	-264(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	movq	%rdx, %r8
	movq	%rsp, %rax
	movb	$18, %r10b
	movb	$6, %dl
	call	.L_init_updstate$1
.Lsha3_224$4:
	movq	%rdi, %mm5
	call	.L_absorb_m_updstate$1
.Lsha3_224$3:
	call	.L_finish_updstate$1
.Lsha3_224$2:
	movq	%mm5, %rax
	movq	$28, %rsi
	call	.L_squeeze_m_updstate$1
.Lsha3_224$1:
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	ret
.L_squeeze_m_updstate$1:
	movq	200(%r8), %rdx
// declassify_val u64 %rdx
	lfence
	movq	$0, %rcx
	call	.L_ststatus_data$1
.L_squeeze_m_updstate$9:
	movq	%r8, %rdi
	movq	%r8, %mm0
	cmpq	$0, %r9
	jne 	.L_squeeze_m_updstate$7
	movq	%rax, %mm3
	movq	%rsi, %mm2
	movq	%rdx, %mm1
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_squeeze_m_updstate$8:
	leaq	200(%rsp), %rsp
	movq	%mm3, %rax
	movq	%mm2, %rsi
	movq	%mm1, %rdx
	movq	$0, %r9
.L_squeeze_m_updstate$7:
	addq	%r9, %rsi
	jmp 	.L_squeeze_m_updstate$3
.L_squeeze_m_updstate$4:
	call	.L_dump_m_updstate$1
.L_squeeze_m_updstate$6:
	movq	%rdx, %mm1
	movq	%rsi, %mm2
	movq	%rax, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_squeeze_m_updstate$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %rsi
	movq	%mm3, %rax
	subq	%rdx, %rsi
	movq	$0, %r9
.L_squeeze_m_updstate$3:
	cmpq	%rsi, %rdx
	jb  	.L_squeeze_m_updstate$4
	movq	%rsi, %rdx
	call	.L_dump_m_updstate$1
.L_squeeze_m_updstate$2:
	movq	%mm0, %rax
	movb	%r9b, 200(%rax)
	ret
.L_dump_m_updstate$1:
	movq	%r9, %r8
	andq	$7, %r8
	cmpq	$0, %r8
	je  	.L_dump_m_updstate$12
	movq	%rdx, %r10
	subq	%r9, %r10
	shrq	$3, %r9
	shlq	$3, %r9
	movq	(%rdi,%r9), %r11
	movb	%r8b, %cl
	shlb	$3, %cl
	shrq	%cl, %r11
	movq	%rax, %rcx
	cmpq	$8, %r10
	jnb 	.L_dump_m_updstate$15
	testq	$4, %r10
	je  	.L_dump_m_updstate$19
	movl	%r11d, (%rcx)
	addq	$4, %rcx
	shrq	$32, %r11
.L_dump_m_updstate$19:
	testq	$2, %r10
	je  	.L_dump_m_updstate$18
	movw	%r11w, (%rcx)
	addq	$2, %rcx
	shrq	$16, %r11
.L_dump_m_updstate$18:
	testq	$1, %r10
	je  	.L_dump_m_updstate$16
	movb	%r11b, (%rcx)
	incq	%rcx
.L_dump_m_updstate$17:
	jmp 	.L_dump_m_updstate$16
.L_dump_m_updstate$15:
	movq	%r11, (%rcx)
	addq	$8, %rcx
.L_dump_m_updstate$16:
	addq	%r8, %r10
	cmpq	$8, %r10
	jnb 	.L_dump_m_updstate$13
	movq	%rcx, %rax
	movq	%rdx, %r9
	jmp 	.L_dump_m_updstate$12
.L_dump_m_updstate$13:
	movq	$8, %r10
	subq	%r8, %r10
	addq	%r10, %rax
	addq	$8, %r9
.L_dump_m_updstate$14:
.L_dump_m_updstate$12:
	movq	%r9, %rcx
	jmp 	.L_dump_m_updstate$10
.L_dump_m_updstate$11:
	vmovdqu	(%rdi,%r9), %ymm0
	vmovdqu	%ymm0, (%rax)
	addq	$32, %rax
	movq	%rcx, %r9
.L_dump_m_updstate$10:
	addq	$32, %rcx
	cmpq	%rdx, %rcx
	jbe 	.L_dump_m_updstate$11
	addq	$-16, %rcx
	cmpq	%rdx, %rcx
	jnbe	.L_dump_m_updstate$9
	vmovdqu	(%rdi,%r9), %xmm0
	vmovdqu	%xmm0, (%rax)
	movq	%rcx, %r9
	addq	$16, %rax
.L_dump_m_updstate$9:
	movq	%r9, %rcx
	addq	$8, %rcx
	cmpq	%rdx, %rcx
	jnbe	.L_dump_m_updstate$8
	movq	(%rdi,%r9), %r11
	movq	%r11, (%rax)
	addq	$8, %rax
	movq	%rcx, %r9
.L_dump_m_updstate$8:
	cmpq	%rdx, %r9
	jnb 	.L_dump_m_updstate$2
	movq	%rdx, %r8
	andq	$7, %r8
	movq	(%rdi,%r9), %r11
	cmpq	$8, %r8
	jnb 	.L_dump_m_updstate$3
	testq	$4, %r8
	je  	.L_dump_m_updstate$7
	movl	%r11d, (%rax)
	addq	$4, %rax
	shrq	$32, %r11
.L_dump_m_updstate$7:
	testq	$2, %r8
	je  	.L_dump_m_updstate$6
	movw	%r11w, (%rax)
	addq	$2, %rax
	shrq	$16, %r11
.L_dump_m_updstate$6:
	testq	$1, %r8
	je  	.L_dump_m_updstate$2
	movb	%r11b, (%rax)
	incq	%rax
.L_dump_m_updstate$5:
	jmp 	.L_dump_m_updstate$2
.L_dump_m_updstate$3:
	movq	%r11, (%rax)
	addq	$8, %rax
.L_dump_m_updstate$4:
.L_dump_m_updstate$2:
	movq	%rdx, %r9
	ret
.L_absorb_m_updstate$1:
	movq	200(%rax), %rdx
// declassify_val u64 %rdx
	lfence
	movq	$0, %rcx
	call	.L_ststatus_data$1
.L_absorb_m_updstate$7:
	movq	%rax, %rdi
	movq	%rax, %mm0
	addq	%r9, %r8
	jmp 	.L_absorb_m_updstate$3
.L_absorb_m_updstate$4:
	call	.L_add_m_updstate$1
.L_absorb_m_updstate$6:
	movq	%rdx, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_absorb_m_updstate$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	%mm3, %rsi
	subq	%rdx, %r8
	movq	$0, %r9
.L_absorb_m_updstate$3:
	cmpq	%r8, %rdx
	jbe 	.L_absorb_m_updstate$4
	movq	%r8, %rdx
	movq	%mm0, %r8
	call	.L_add_m_updstate$1
.L_absorb_m_updstate$2:
	movb	%r9b, 200(%r8)
	ret
.L_add_m_updstate$1:
	movq	%r9, %rax
	andq	$7, %rax
	cmpq	$0, %rax
	je  	.L_add_m_updstate$13
	movq	%rdx, %r10
	subq	%r9, %r10
	shrq	$3, %r9
	shlq	$3, %r9
	movq	%rsi, %r11
	cmpq	$8, %r10
	jnb 	.L_add_m_updstate$16
	testq	$4, %r10
	jne 	.L_add_m_updstate$20
	movq	$0, %rbx
	movb	$0, %cl
	jmp 	.L_add_m_updstate$21
.L_add_m_updstate$20:
	movl	(%r11), %ebx
	addq	$4, %r11
	movb	$32, %cl
.L_add_m_updstate$21:
	testq	$2, %r10
	je  	.L_add_m_updstate$19
	movzwq	(%r11), %rbp
	shlq	%cl, %rbp
	addq	%rbp, %rbx
	addq	$2, %r11
	addb	$16, %cl
.L_add_m_updstate$19:
	testq	$1, %r10
	je  	.L_add_m_updstate$17
	movzbq	(%r11), %rbp
	shlq	%cl, %rbp
	addq	%rbp, %rbx
	incq	%r11
.L_add_m_updstate$18:
	jmp 	.L_add_m_updstate$17
.L_add_m_updstate$16:
	movq	(%r11), %rbx
	addq	$8, %r11
.L_add_m_updstate$17:
	addq	%rax, %r10
	movb	%al, %cl
	shlb	$3, %cl
	shlq	%cl, %rbx
	xorq	%rbx, (%rdi,%r9)
	cmpq	$8, %r10
	jnb 	.L_add_m_updstate$14
	movq	%r11, %rsi
	movq	%rdx, %r9
	jmp 	.L_add_m_updstate$13
.L_add_m_updstate$14:
	movq	$8, %r10
	subq	%rax, %r10
	addq	%r10, %rsi
	addq	$8, %r9
.L_add_m_updstate$15:
.L_add_m_updstate$13:
	movq	%r9, %rcx
	jmp 	.L_add_m_updstate$11
.L_add_m_updstate$12:
	vmovdqu	(%rsi), %ymm0
	addq	$32, %rsi
	vpxor	(%rdi,%r9), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	movq	%rcx, %r9
.L_add_m_updstate$11:
	addq	$32, %rcx
	cmpq	%rdx, %rcx
	jbe 	.L_add_m_updstate$12
	addq	$-16, %rcx
	cmpq	%rdx, %rcx
	jnbe	.L_add_m_updstate$10
	vmovdqu	(%rsi), %xmm0
	addq	$16, %rsi
	vpxor	(%rdi,%r9), %xmm0, %xmm0
	vmovdqu	%xmm0, (%rdi,%r9)
	movq	%rcx, %r9
.L_add_m_updstate$10:
	movq	%r9, %rcx
	addq	$8, %rcx
	cmpq	%rdx, %rcx
	jnbe	.L_add_m_updstate$9
	movq	(%rsi), %r11
	addq	$8, %rsi
	xorq	%r11, (%rdi,%r9)
	movq	%rcx, %r9
.L_add_m_updstate$9:
	cmpq	%rdx, %r9
	jnb 	.L_add_m_updstate$2
	movq	%rdx, %r10
	andq	$7, %r10
	cmpq	$8, %r10
	jnb 	.L_add_m_updstate$3
	testq	$4, %r10
	jne 	.L_add_m_updstate$7
	movq	$0, %rax
	movb	$0, %cl
	jmp 	.L_add_m_updstate$8
.L_add_m_updstate$7:
	movl	(%rsi), %eax
	addq	$4, %rsi
	movb	$32, %cl
.L_add_m_updstate$8:
	testq	$2, %r10
	je  	.L_add_m_updstate$6
	movzwq	(%rsi), %r11
	shlq	%cl, %r11
	addq	%r11, %rax
	addq	$2, %rsi
	addb	$16, %cl
.L_add_m_updstate$6:
	testq	$1, %r10
	je  	.L_add_m_updstate$4
	movzbq	(%rsi), %r11
	shlq	%cl, %r11
	addq	%r11, %rax
	incq	%rsi
.L_add_m_updstate$5:
	jmp 	.L_add_m_updstate$4
.L_add_m_updstate$3:
	movq	(%rsi), %rax
	addq	$8, %rsi
.L_add_m_updstate$4:
	xorq	%rax, (%rdi,%r9)
.L_add_m_updstate$2:
	movq	%rdx, %r9
	ret
.L_finish_updstate$1:
	movq	200(%r8), %rdx
// declassify_val u64 %rdx
	lfence
	movq	$0, %rcx
	call	.L_ststatus_data$1
.L_finish_updstate$2:
	xorb	%cl, (%r8,%r9)
	xorb	$128, -1(%r8,%rdx)
	andl	$-16711936, 200(%r8)
	ret
.L_init_updstate$1:
	movq	%rax, %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	%ymm0, 96(%rcx)
	vmovdqu	%ymm0, 128(%rcx)
	vmovdqu	%ymm0, 160(%rcx)
	movq	$0, 192(%rcx)
	movzbq	%dl, %rcx
	shlq	$8, %rcx
	decb	%r10b
	movzbq	%r10b, %rdx
	addq	%rdx, %rcx
	shlq	$8, %rcx
	movq	%rcx, 200(%rax)
	ret
.L_ststatus_data$1:
	movq	%rdx, %r9
	andq	$255, %r9
	shrq	$8, %rdx
	movq	%rdx, %r10
	andq	$255, %r10
	incq	%r10
	shlq	$3, %r10
	movq	$200, %rcx
	cmpq	$200, %r10
	cmovnbe	%rcx, %r10
	movq	$0, %rcx
	cmpq	%r9, %r10
	cmovbe	%rcx, %r9
	shrq	$8, %rdx
	movb	%dl, %cl
	movq	%r10, %rdx
	ret
.L_keccakf1600_opt$1:
	movq	(%rdi), %rax
	movq	80(%rdi), %rbx
	movq	96(%rdi), %rcx
	movq	144(%rdi), %rdx
	movq	152(%rdi), %r12
	movq	160(%rdi), %rsi
	movq	168(%rdi), %r11
	movq	176(%rdi), %r8
	movq	192(%rdi), %r9
	movq	$0, %r10
.L_keccakf1600_opt$2:
	movq	%r12, 8(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%r10, %mm4
	movq	%r11, 24(%rsp)
	movq	120(%rdi), %r14
	xorq	%rsi, %r14
	movq	%rbx, %r10
	xorq	40(%rdi), %r10
	xorq	%r14, %r10
	movq	128(%rdi), %r13
	xorq	%r11, %r13
	movq	88(%rdi), %r14
	movq	48(%rdi), %r11
	xorq	%r11, %r14
	xorq	%r13, %r14
	movq	136(%rdi), %r13
	xorq	%r8, %r13
	movq	%rcx, %rbx
	xorq	56(%rdi), %rbx
	xorq	%r13, %rbx
	movq	%rdx, %r13
	xorq	184(%rdi), %r13
	movq	104(%rdi), %rbp
	xorq	64(%rdi), %rbp
	xorq	%r13, %rbp
	xorq	%r9, %r12
	movq	112(%rdi), %r15
	xorq	72(%rdi), %r15
	xorq	%r12, %r15
	xorq	%rax, %r10
	xorq	8(%rdi), %r14
	xorq	16(%rdi), %rbx
	movq	24(%rdi), %r12
	xorq	%r12, %rbp
	xorq	32(%rdi), %r15
	rorx	$63, %rbp, %r13
	xorq	%r14, %r13
	movq	%r13, 88(%rsp)
	rorx	$63, %r14, %r14
	xorq	%r15, %r14
	movq	%r14, 80(%rsp)
	rorx	$63, %r15, %r15
	xorq	%rbx, %r15
	rorx	$63, %rbx, %rbx
	xorq	%r10, %rbx
	rorx	$63, %r10, %r10
	xorq	%rbp, %r10
	xorq	%r14, %rax
	xorq	%rbx, %r11
	rorx	$20, %r11, %r11
	xorq	%r13, %rcx
	rorx	$21, %rcx, %rcx
	xorq	%r15, %rdx
	rorx	$43, %rdx, %r13
	xorq	%r10, %r9
	rorx	$50, %r9, %r9
	andnq	%rax, %r9, %rdx
	xorq	%r13, %rdx
	movq	%rdx, 48(%rdi)
	andnq	%r13, %rcx, %rdx
	andnq	%r9, %r13, %r13
	xorq	%rcx, %r13
	movq	%r13, 72(%rsp)
	andnq	%rcx, %r11, %rcx
	leaq	glob_data + 0(%rip), %rbp
	movq	%mm4, %r13
	xorq	(%rbp,%r13,8), %rcx
	xorq	%rax, %rcx
	xorq	%r11, %rdx
	movq	%rdx, 56(%rsp)
	andnq	%r11, %rax, %rax
	xorq	%r9, %rax
	movq	%rax, 64(%rsp)
	xorq	%r15, %r12
	rorx	$36, %r12, %rax
	movq	72(%rdi), %rdx
	xorq	%r10, %rdx
	rorx	$44, %rdx, %rdx
	movq	16(%rsp), %r11
	movq	80(%rsp), %rbp
	xorq	%rbp, %r11
	rorx	$61, %r11, %r12
	movq	128(%rdi), %r11
	movq	%rbx, %r9
	xorq	%rbx, %r11
	rorx	$19, %r11, %r13
	movq	88(%rsp), %r11
	xorq	%r11, %r8
	rorx	$3, %r8, %r8
	andnq	%rax, %r8, %r14
	xorq	%r13, %r14
	movq	%r14, 16(%rsp)
	andnq	%r13, %r12, %r14
	andnq	%r8, %r13, %r13
	xorq	%r12, %r13
	movq	%r13, 48(%rsp)
	andnq	%r12, %rdx, %r12
	xorq	%rax, %r12
	movq	%r12, 128(%rdi)
	xorq	%rdx, %r14
	movq	%r14, 24(%rdi)
	andnq	%rdx, %rax, %rdx
	xorq	%r8, %rdx
	movq	%rdx, 72(%rdi)
	movq	8(%rdi), %rdx
	xorq	%rbx, %rdx
	rorx	$63, %rdx, %rdx
	movq	56(%rdi), %r8
	xorq	%r11, %r8
	rorx	$58, %r8, %r8
	movq	104(%rdi), %rax
	xorq	%r15, %rax
	rorx	$39, %rax, %r14
	movq	8(%rsp), %rax
	xorq	%r10, %rax
	rorx	$56, %rax, %rax
	movq	%rbp, %rbx
	xorq	%rbp, %rsi
	rorx	$46, %rsi, %rsi
	andnq	%rdx, %rsi, %r12
	xorq	%rax, %r12
	movq	%r12, 104(%rdi)
	andnq	%rax, %r14, %r12
	andnq	%rsi, %rax, %rax
	xorq	%r14, %rax
	andnq	%r14, %r8, %r14
	xorq	%rdx, %r14
	movq	%r14, 56(%rdi)
	xorq	%r8, %r12
	movq	%r12, 40(%rsp)
	andnq	%r8, %rdx, %rdx
	xorq	%rsi, %rdx
	movq	%rdx, 8(%rsp)
	movq	32(%rdi), %rdx
	xorq	%r10, %rdx
	rorx	$37, %rdx, %r12
	movq	40(%rdi), %r8
	xorq	%rbx, %r8
	rorx	$28, %r8, %r13
	movq	88(%rdi), %rdx
	xorq	%r9, %rdx
	rorx	$54, %rdx, %rsi
	movq	136(%rdi), %rdx
	xorq	%r11, %rdx
	rorx	$49, %rdx, %r14
	movq	184(%rdi), %rdx
	xorq	%r15, %rdx
	rorx	$8, %rdx, %rbp
	andnq	%r12, %rbp, %rdx
	xorq	%r14, %rdx
	andnq	%r14, %rsi, %r8
	andnq	%rbp, %r14, %r14
	xorq	%rsi, %r14
	movq	%r14, 136(%rdi)
	andnq	%rsi, %r13, %rsi
	xorq	%r12, %rsi
	movq	%rsi, 184(%rdi)
	xorq	%r13, %r8
	movq	%r8, 40(%rdi)
	andnq	%r13, %r12, %r12
	xorq	%rbp, %r12
	movq	%r12, 88(%rdi)
	xorq	16(%rdi), %r11
	xorq	64(%rdi), %r15
	xorq	112(%rdi), %r10
	xorq	120(%rdi), %rbx
	xorq	24(%rsp), %r9
	rorx	$2, %r11, %r11
	rorx	$9, %r15, %r13
	rorx	$25, %r10, %r10
	rorx	$23, %rbx, %rbx
	rorx	$62, %r9, %r15
	andnq	%r11, %r15, %r14
	xorq	%rbx, %r14
	movq	%r14, 120(%rdi)
	andnq	%rbx, %r10, %r9
	andnq	%r15, %rbx, %r12
	xorq	%r10, %r12
	andnq	%r10, %r13, %rbp
	xorq	%r11, %rbp
	movq	%rbp, %r10
	movq	%rbp, 112(%rdi)
	xorq	%r13, %r9
	movq	%r9, 24(%rsp)
	andnq	%r13, %r11, %rbx
	xorq	%r15, %rbx
	xorq	56(%rdi), %rsi
	movq	128(%rdi), %r11
	xorq	%r10, %r11
	xorq	%rsi, %r11
	movq	24(%rdi), %rbp
	movq	%rbp, %rsi
	xorq	56(%rsp), %rsi
	movq	%r8, %r13
	xorq	40(%rsp), %r13
	xorq	%rsi, %r13
	movq	48(%rsp), %rsi
	xorq	136(%rdi), %rsi
	movq	%r12, %r10
	xorq	72(%rsp), %r10
	xorq	%rsi, %r10
	movq	104(%rdi), %r8
	xorq	16(%rsp), %r8
	xorq	48(%rdi), %r14
	xorq	%r8, %r14
	movq	64(%rsp), %r8
	xorq	%rbx, %r8
	movq	8(%rsp), %rsi
	xorq	72(%rdi), %rsi
	xorq	%r8, %rsi
	xorq	%rcx, %r11
	xorq	%r9, %r13
	xorq	%rax, %r10
	xorq	%rdx, %r14
	movq	88(%rdi), %r15
	xorq	%r15, %rsi
	rorx	$63, %r14, %r8
	xorq	%r13, %r8
	rorx	$63, %r13, %r9
	xorq	%rsi, %r9
	rorx	$63, %rsi, %rsi
	xorq	%r10, %rsi
	rorx	$63, %r10, %r10
	xorq	%r11, %r10
	rorx	$63, %r11, %r11
	xorq	%r14, %r11
	xorq	%r9, %rcx
	xorq	%r10, %rbp
	rorx	$20, %rbp, %rbp
	xorq	%r8, %rax
	rorx	$21, %rax, %rax
	xorq	%rsi, %rdx
	rorx	$43, %rdx, %rdx
	xorq	%r11, %rbx
	rorx	$50, %rbx, %rbx
	andnq	%rcx, %rbx, %r13
	xorq	%rdx, %r13
	movq	%r13, 24(%rdi)
	andnq	%rdx, %rax, %r13
	andnq	%rbx, %rdx, %rdx
	xorq	%rax, %rdx
	movq	%rdx, 16(%rdi)
	andnq	%rax, %rbp, %rax
	movq	%mm4, %rdx
	leaq	glob_data + 0(%rip), %r14
	xorq	8(%r14,%rdx,8), %rax
	xorq	%rcx, %rax
	movq	%rax, 80(%rsp)
	xorq	%rbp, %r13
	movq	%r13, 8(%rdi)
	andnq	%rbp, %rcx, %rax
	xorq	%rbx, %rax
	movq	%rax, 32(%rdi)
	movq	48(%rdi), %rax
	xorq	%rsi, %rax
	rorx	$36, %rax, %rax
	movq	72(%rdi), %rcx
	xorq	%r11, %rcx
	rorx	$44, %rcx, %rcx
	movq	56(%rdi), %rdx
	xorq	%r9, %rdx
	rorx	$61, %rdx, %rdx
	movq	40(%rdi), %rbx
	xorq	%r10, %rbx
	rorx	$19, %rbx, %rbx
	xorq	%r8, %r12
	rorx	$3, %r12, %r13
	andnq	%rax, %r13, %r12
	xorq	%rbx, %r12
	movq	%r12, 64(%rdi)
	andnq	%rbx, %rdx, %r12
	andnq	%r13, %rbx, %rbx
	xorq	%rdx, %rbx
	movq	%rbx, 56(%rdi)
	andnq	%rdx, %rcx, %rdx
	xorq	%rax, %rdx
	movq	%rdx, 40(%rdi)
	xorq	%rcx, %r12
	movq	%r12, 48(%rdi)
	andnq	%rcx, %rax, %rax
	xorq	%r13, %rax
	movq	%rax, 72(%rdi)
	movq	56(%rsp), %rax
	xorq	%r10, %rax
	rorx	$63, %rax, %rax
	movq	48(%rsp), %rcx
	xorq	%r8, %rcx
	rorx	$58, %rcx, %rdx
	movq	104(%rdi), %rcx
	xorq	%rsi, %rcx
	rorx	$39, %rcx, %r12
	xorq	%r11, %r15
	rorx	$56, %r15, %rcx
	movq	112(%rdi), %r13
	xorq	%r9, %r13
	rorx	$46, %r13, %r13
	andnq	%rax, %r13, %rbx
	xorq	%rcx, %rbx
	movq	%rbx, 104(%rdi)
	andnq	%rcx, %r12, %r14
	andnq	%r13, %rcx, %rcx
	xorq	%r12, %rcx
	andnq	%r12, %rdx, %rbx
	xorq	%rax, %rbx
	xorq	%rdx, %r14
	movq	%r14, 88(%rdi)
	andnq	%rdx, %rax, %rax
	xorq	%r13, %rax
	movq	%rax, 112(%rdi)
	movq	64(%rsp), %rax
	xorq	%r11, %rax
	rorx	$37, %rax, %rbp
	movq	128(%rdi), %rax
	xorq	%r9, %rax
	rorx	$28, %rax, %r14
	movq	40(%rsp), %rdx
	xorq	%r10, %rdx
	rorx	$54, %rdx, %r12
	movq	136(%rdi), %rdx
	xorq	%r8, %rdx
	rorx	$49, %rdx, %r15
	movq	120(%rdi), %rdx
	xorq	%rsi, %rdx
	rorx	$8, %rdx, %rax
	andnq	%rbp, %rax, %rdx
	xorq	%r15, %rdx
	andnq	%r15, %r12, %r13
	andnq	%rax, %r15, %r15
	xorq	%r12, %r15
	movq	%r15, 136(%rdi)
	andnq	%r12, %r14, %r12
	xorq	%rbp, %r12
	movq	%r12, 120(%rdi)
	xorq	%r14, %r13
	movq	%r13, 128(%rdi)
	andnq	%r14, %rbp, %r12
	xorq	%rax, %r12
	xorq	72(%rsp), %r8
	xorq	16(%rsp), %rsi
	xorq	8(%rsp), %r11
	xorq	184(%rdi), %r9
	xorq	24(%rsp), %r10
	rorx	$2, %r8, %rax
	rorx	$9, %rsi, %r14
	rorx	$25, %r11, %rsi
	rorx	$23, %r9, %r8
	rorx	$62, %r10, %r10
	andnq	%rax, %r10, %r9
	xorq	%r8, %r9
	movq	%r9, 184(%rdi)
	andnq	%r8, %rsi, %r11
	andnq	%r10, %r8, %r8
	xorq	%rsi, %r8
	andnq	%rsi, %r14, %rsi
	xorq	%rax, %rsi
	xorq	%r14, %r11
	andnq	%r14, %rax, %r9
	xorq	%r10, %r9
	movq	%mm4, %rax
	addq	$2, %rax
	movq	%rax, %r10
	movq	80(%rsp), %rax
	cmpq	$24, %r10
	jb  	.L_keccakf1600_opt$2
	movq	%rax, (%rdi)
	movq	%rbx, 80(%rdi)
	movq	%rcx, 96(%rdi)
	movq	%rdx, 144(%rdi)
	movq	%r12, 152(%rdi)
	movq	%rsi, 160(%rdi)
	movq	%r11, 168(%rdi)
	movq	%r8, 176(%rdi)
	movq	%r9, 192(%rdi)
	ret
	.data
	.p2align	5
glob_data:
G$KECCAK1600_RC:
	.byte	  1,   0,   0,   0,   0,   0,   0,   0, 130, 128,   0,   0,   0,   0,   0,   0
	.byte	138, 128,   0,   0,   0,   0,   0, 128,   0, 128,   0, 128,   0,   0,   0, 128
	.byte	139, 128,   0,   0,   0,   0,   0,   0,   1,   0,   0, 128,   0,   0,   0,   0
	.byte	129, 128,   0, 128,   0,   0,   0, 128,   9, 128,   0,   0,   0,   0,   0, 128
	.byte	138,   0,   0,   0,   0,   0,   0,   0, 136,   0,   0,   0,   0,   0,   0,   0
	.byte	  9, 128,   0, 128,   0,   0,   0,   0,  10,   0,   0, 128,   0,   0,   0,   0
	.byte	139, 128,   0, 128,   0,   0,   0,   0, 139,   0,   0,   0,   0,   0,   0, 128
	.byte	137, 128,   0,   0,   0,   0,   0, 128,   3, 128,   0,   0,   0,   0,   0, 128
	.byte	  2, 128,   0,   0,   0,   0,   0, 128, 128,   0,   0,   0,   0,   0,   0, 128
	.byte	 10, 128,   0,   0,   0,   0,   0,   0,  10,   0,   0, 128,   0,   0,   0, 128
	.byte	129, 128,   0, 128,   0,   0,   0, 128, 128, 128,   0,   0,   0,   0,   0, 128
	.byte	  1,   0,   0, 128,   0,   0,   0,   0,   8, 128,   0, 128,   0,   0,   0, 128
G$KECCAK_RHOTATES_RIGHT:
	.byte	 61,   0,   0,   0,   0,   0,   0,   0,  46,   0,   0,   0,   0,   0,   0,   0
	.byte	 28,   0,   0,   0,   0,   0,   0,   0,  23,   0,   0,   0,   0,   0,   0,   0
	.byte	 63,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0
	.byte	 36,   0,   0,   0,   0,   0,   0,   0,  37,   0,   0,   0,   0,   0,   0,   0
	.byte	 19,   0,   0,   0,   0,   0,   0,   0,  58,   0,   0,   0,   0,   0,   0,   0
	.byte	  8,   0,   0,   0,   0,   0,   0,   0,  25,   0,   0,   0,   0,   0,   0,   0
	.byte	 54,   0,   0,   0,   0,   0,   0,   0,   3,   0,   0,   0,   0,   0,   0,   0
	.byte	  9,   0,   0,   0,   0,   0,   0,   0,  56,   0,   0,   0,   0,   0,   0,   0
	.byte	 62,   0,   0,   0,   0,   0,   0,   0,  49,   0,   0,   0,   0,   0,   0,   0
	.byte	 39,   0,   0,   0,   0,   0,   0,   0,  44,   0,   0,   0,   0,   0,   0,   0
	.byte	 20,   0,   0,   0,   0,   0,   0,   0,  21,   0,   0,   0,   0,   0,   0,   0
	.byte	 43,   0,   0,   0,   0,   0,   0,   0,  50,   0,   0,   0,   0,   0,   0,   0
G$KECCAK_RHOTATES_LEFT:
	.byte	  3,   0,   0,   0,   0,   0,   0,   0,  18,   0,   0,   0,   0,   0,   0,   0
	.byte	 36,   0,   0,   0,   0,   0,   0,   0,  41,   0,   0,   0,   0,   0,   0,   0
	.byte	  1,   0,   0,   0,   0,   0,   0,   0,  62,   0,   0,   0,   0,   0,   0,   0
	.byte	 28,   0,   0,   0,   0,   0,   0,   0,  27,   0,   0,   0,   0,   0,   0,   0
	.byte	 45,   0,   0,   0,   0,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0,   0
	.byte	 56,   0,   0,   0,   0,   0,   0,   0,  39,   0,   0,   0,   0,   0,   0,   0
	.byte	 10,   0,   0,   0,   0,   0,   0,   0,  61,   0,   0,   0,   0,   0,   0,   0
	.byte	 55,   0,   0,   0,   0,   0,   0,   0,   8,   0,   0,   0,   0,   0,   0,   0
	.byte	  2,   0,   0,   0,   0,   0,   0,   0,  15,   0,   0,   0,   0,   0,   0,   0
	.byte	 25,   0,   0,   0,   0,   0,   0,   0,  20,   0,   0,   0,   0,   0,   0,   0
	.byte	 44,   0,   0,   0,   0,   0,   0,   0,  43,   0,   0,   0,   0,   0,   0,   0
	.byte	 21,   0,   0,   0,   0,   0,   0,   0,  14,   0,   0,   0,   0,   0,   0,   0
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
