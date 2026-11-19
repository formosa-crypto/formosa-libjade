	.att_syntax
	.text
	.p2align	5
	.global	keccakx4_squeeze
	.global	keccakx4_absorb
	.global	keccakx4_absorb_bcast
	.global	shake256x4_init
	.global	shake128x4_init
	.global	sha3_512x4_init
	.global	sha3_384x4_init
	.global	sha3_256x4_init
	.global	sha3_224x4_init
	.global	squeeze_m_updstate_avx2x4
	.global	absorb_m_updstate_avx2x4
	.global	absorb_m_bcast_updstate_avx2x4
	.global	finish_updstate_avx2x4
	.global	init_updstate_avx2x4
	.global	ststatus_updstate_avx2x4
	.type	keccakx4_squeeze, %function
keccakx4_squeeze:
	movq	%rsp, %rax
	leaq	-48(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 40(%rsp)
	movq	%r8, %r12
	lfence
	movq	$0, %rax
	movq	%rdi, %r13
	movq	%rdx, %r10
	movq	%rcx, %r8
	movq	%r9, %rdx
	cmpq	$0, %rdx
	jbe 	.Lkeccakx4_squeeze$1
	movq	$-1, %rdi
	cmovbe	%rdi, %rax
	movq	800(%r13), %rcx
// declassify_val u64 %rcx
	orq 	%rax, %rcx
	shrq	$16, %rcx
	cmpb	$0, %cl
	je  	.Lkeccakx4_squeeze$3
	call	.L_finish_updstate_avx2x4$1
.Lkeccakx4_squeeze$4:
.Lkeccakx4_squeeze$3:
	call	.L_squeeze_m_updstate_avx2x4$1
.Lkeccakx4_squeeze$2:
.Lkeccakx4_squeeze$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	ret
	.type	keccakx4_absorb, %function
keccakx4_absorb:
	movq	%rsp, %rax
	leaq	-48(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 40(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, %r11
	movq	%rcx, %r10
	movq	%r9, %r12
	call	.L_absorb_m_updstate_avx2x4$1
.Lkeccakx4_absorb$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	ret
	.type	keccakx4_absorb_bcast, %function
keccakx4_absorb_bcast:
	movq	%rsp, %rax
	leaq	-32(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r13, 16(%rsp)
	movq	%rax, 24(%rsp)
	movq	%rdx, %r8
	lfence
	movq	$0, %rax
	movq	%rdi, %rdx
	call	.L_absorb_m_bcast_updstate_avx2x4$1
.Lkeccakx4_absorb_bcast$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r13
	movq	24(%rsp), %rsp
	ret
	.type	shake256x4_init, %function
shake256x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$17, %sil
	movb	$31, %dl
	call	.L_init_updstate_avx2x4$1
.Lshake256x4_init$1:
	movq	%r10, %rsp
	ret
	.type	shake128x4_init, %function
shake128x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$21, %sil
	movb	$31, %dl
	call	.L_init_updstate_avx2x4$1
.Lshake128x4_init$1:
	movq	%r10, %rsp
	ret
	.type	sha3_512x4_init, %function
sha3_512x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$9, %sil
	movb	$6, %dl
	call	.L_init_updstate_avx2x4$1
.Lsha3_512x4_init$1:
	movq	%r10, %rsp
	ret
	.type	sha3_384x4_init, %function
sha3_384x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$13, %sil
	movb	$6, %dl
	call	.L_init_updstate_avx2x4$1
.Lsha3_384x4_init$1:
	movq	%r10, %rsp
	ret
	.type	sha3_256x4_init, %function
sha3_256x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$17, %sil
	movb	$6, %dl
	call	.L_init_updstate_avx2x4$1
.Lsha3_256x4_init$1:
	movq	%r10, %rsp
	ret
	.type	sha3_224x4_init, %function
sha3_224x4_init:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	movb	$18, %sil
	movb	$6, %dl
	call	.L_init_updstate_avx2x4$1
.Lsha3_224x4_init$1:
	movq	%r10, %rsp
	ret
	.type	squeeze_m_updstate_avx2x4, %function
squeeze_m_updstate_avx2x4:
	movq	%rsp, %rax
	leaq	-48(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 40(%rsp)
	movq	%r8, %r12
	lfence
	movq	$0, %rax
	movq	%rdi, %r13
	movq	%rdx, %r10
	movq	%rcx, %r8
	movq	%r9, %rdx
	call	.L_squeeze_m_updstate_avx2x4$1
.Lsqueeze_m_updstate_avx2x4$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	ret
	.type	absorb_m_updstate_avx2x4, %function
absorb_m_updstate_avx2x4:
	movq	%rsp, %rax
	leaq	-48(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 40(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, %r11
	movq	%rcx, %r10
	movq	%r9, %r12
	call	.L_absorb_m_updstate_avx2x4$1
.Labsorb_m_updstate_avx2x4$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	ret
	.type	absorb_m_bcast_updstate_avx2x4, %function
absorb_m_bcast_updstate_avx2x4:
	movq	%rsp, %rax
	leaq	-32(%rsp), %rsp
	andq	$-8, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r13, 16(%rsp)
	movq	%rax, 24(%rsp)
	movq	%rdx, %r8
	lfence
	movq	$0, %rax
	movq	%rdi, %rdx
	call	.L_absorb_m_bcast_updstate_avx2x4$1
.Labsorb_m_bcast_updstate_avx2x4$1:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r13
	movq	24(%rsp), %rsp
	ret
.L_squeeze_m_updstate_avx2x4$1:
	movq	800(%r13), %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rax
	call	.L_ststatus_data_avx2x4$1
.L_squeeze_m_updstate_avx2x4$9:
	movq	%r13, %rdi
	cmpq	$0, %rax
	jne 	.L_squeeze_m_updstate_avx2x4$7
	call	.L_keccakf1600_avx2x4_nat$1
.L_squeeze_m_updstate_avx2x4$8:
.L_squeeze_m_updstate_avx2x4$7:
	addq	%rax, %rdx
	jmp 	.L_squeeze_m_updstate_avx2x4$3
.L_squeeze_m_updstate_avx2x4$4:
	call	.L_dump_m_updstate_avx2x4$1
.L_squeeze_m_updstate_avx2x4$6:
	call	.L_keccakf1600_avx2x4_nat$1
.L_squeeze_m_updstate_avx2x4$5:
	subq	%r9, %rdx
	movq	$0, %rax
.L_squeeze_m_updstate_avx2x4$3:
	cmpq	%rdx, %r9
	jb  	.L_squeeze_m_updstate_avx2x4$4
	movq	%rdx, %r9
	call	.L_dump_m_updstate_avx2x4$1
.L_squeeze_m_updstate_avx2x4$2:
	movb	%al, 800(%r13)
	ret
.L_dump_m_updstate_avx2x4$1:
	movq	%rax, %r11
	andq	$7, %r11
	cmpq	$0, %r11
	je  	.L_dump_m_updstate_avx2x4$25
	movq	%r9, %rbx
	subq	%rax, %rbx
	shrq	$3, %rax
	shlq	$3, %rax
	movb	%r11b, %cl
	shlb	$3, %cl
	movq	(%rdi,%rax,4), %rbp
	shrq	%cl, %rbp
	movq	%rsi, %r14
	cmpq	$8, %rbx
	jnb 	.L_dump_m_updstate_avx2x4$43
	testq	$4, %rbx
	je  	.L_dump_m_updstate_avx2x4$47
	movl	%ebp, (%r14)
	addq	$4, %r14
	shrq	$32, %rbp
.L_dump_m_updstate_avx2x4$47:
	testq	$2, %rbx
	je  	.L_dump_m_updstate_avx2x4$46
	movw	%bp, (%r14)
	addq	$2, %r14
	shrq	$16, %rbp
.L_dump_m_updstate_avx2x4$46:
	testq	$1, %rbx
	je  	.L_dump_m_updstate_avx2x4$44
	movb	%bpl, (%r14)
.L_dump_m_updstate_avx2x4$45:
	jmp 	.L_dump_m_updstate_avx2x4$44
.L_dump_m_updstate_avx2x4$43:
	movq	%rbp, (%r14)
.L_dump_m_updstate_avx2x4$44:
	movq	8(%rdi,%rax,4), %rbp
	shrq	%cl, %rbp
	movq	%r10, %r14
	cmpq	$8, %rbx
	jnb 	.L_dump_m_updstate_avx2x4$38
	testq	$4, %rbx
	je  	.L_dump_m_updstate_avx2x4$42
	movl	%ebp, (%r14)
	addq	$4, %r14
	shrq	$32, %rbp
.L_dump_m_updstate_avx2x4$42:
	testq	$2, %rbx
	je  	.L_dump_m_updstate_avx2x4$41
	movw	%bp, (%r14)
	addq	$2, %r14
	shrq	$16, %rbp
.L_dump_m_updstate_avx2x4$41:
	testq	$1, %rbx
	je  	.L_dump_m_updstate_avx2x4$39
	movb	%bpl, (%r14)
.L_dump_m_updstate_avx2x4$40:
	jmp 	.L_dump_m_updstate_avx2x4$39
.L_dump_m_updstate_avx2x4$38:
	movq	%rbp, (%r14)
.L_dump_m_updstate_avx2x4$39:
	movq	16(%rdi,%rax,4), %rbp
	shrq	%cl, %rbp
	movq	%r8, %r14
	cmpq	$8, %rbx
	jnb 	.L_dump_m_updstate_avx2x4$33
	testq	$4, %rbx
	je  	.L_dump_m_updstate_avx2x4$37
	movl	%ebp, (%r14)
	addq	$4, %r14
	shrq	$32, %rbp
.L_dump_m_updstate_avx2x4$37:
	testq	$2, %rbx
	je  	.L_dump_m_updstate_avx2x4$36
	movw	%bp, (%r14)
	addq	$2, %r14
	shrq	$16, %rbp
.L_dump_m_updstate_avx2x4$36:
	testq	$1, %rbx
	je  	.L_dump_m_updstate_avx2x4$34
	movb	%bpl, (%r14)
.L_dump_m_updstate_avx2x4$35:
	jmp 	.L_dump_m_updstate_avx2x4$34
.L_dump_m_updstate_avx2x4$33:
	movq	%rbp, (%r14)
.L_dump_m_updstate_avx2x4$34:
	movq	24(%rdi,%rax,4), %rbp
	shrq	%cl, %rbp
	movq	%r12, %rcx
	cmpq	$8, %rbx
	jnb 	.L_dump_m_updstate_avx2x4$28
	testq	$4, %rbx
	je  	.L_dump_m_updstate_avx2x4$32
	movl	%ebp, (%rcx)
	addq	$4, %rcx
	shrq	$32, %rbp
.L_dump_m_updstate_avx2x4$32:
	testq	$2, %rbx
	je  	.L_dump_m_updstate_avx2x4$31
	movw	%bp, (%rcx)
	addq	$2, %rcx
	shrq	$16, %rbp
.L_dump_m_updstate_avx2x4$31:
	testq	$1, %rbx
	je  	.L_dump_m_updstate_avx2x4$29
	movb	%bpl, (%rcx)
.L_dump_m_updstate_avx2x4$30:
	jmp 	.L_dump_m_updstate_avx2x4$29
.L_dump_m_updstate_avx2x4$28:
	movq	%rbp, (%rcx)
.L_dump_m_updstate_avx2x4$29:
	addq	%r11, %rbx
	cmpq	$8, %rbx
	jnb 	.L_dump_m_updstate_avx2x4$26
	movq	%r9, %rax
	jmp 	.L_dump_m_updstate_avx2x4$27
.L_dump_m_updstate_avx2x4$26:
	movq	$8, %rbx
	addq	$8, %rax
.L_dump_m_updstate_avx2x4$27:
	subq	%r11, %rbx
	addq	%rbx, %rsi
	addq	%rbx, %r10
	addq	%rbx, %r8
	addq	%rbx, %r12
.L_dump_m_updstate_avx2x4$25:
	movq	%rax, %rcx
	jmp 	.L_dump_m_updstate_avx2x4$23
.L_dump_m_updstate_avx2x4$24:
	movq	(%rdi,%rax,4), %r11
	movq	%r11, (%rsi)
	movq	8(%rdi,%rax,4), %r11
	movq	%r11, (%r10)
	movq	16(%rdi,%rax,4), %r11
	movq	%r11, (%r8)
	movq	24(%rdi,%rax,4), %r11
	movq	%r11, (%r12)
	movq	%rcx, %rax
	addq	$8, %rsi
	addq	$8, %r10
	addq	$8, %r8
	addq	$8, %r12
.L_dump_m_updstate_avx2x4$23:
	addq	$8, %rcx
	cmpq	%r9, %rcx
	jbe 	.L_dump_m_updstate_avx2x4$24
	cmpq	%r9, %rax
	jnb 	.L_dump_m_updstate_avx2x4$2
	movq	%r9, %r11
	andq	$7, %r11
	movq	(%rdi,%rax,4), %rcx
	cmpq	$8, %r11
	jnb 	.L_dump_m_updstate_avx2x4$18
	testq	$4, %r11
	je  	.L_dump_m_updstate_avx2x4$22
	movl	%ecx, (%rsi)
	addq	$4, %rsi
	shrq	$32, %rcx
.L_dump_m_updstate_avx2x4$22:
	testq	$2, %r11
	je  	.L_dump_m_updstate_avx2x4$21
	movw	%cx, (%rsi)
	addq	$2, %rsi
	shrq	$16, %rcx
.L_dump_m_updstate_avx2x4$21:
	testq	$1, %r11
	je  	.L_dump_m_updstate_avx2x4$19
	movb	%cl, (%rsi)
	incq	%rsi
.L_dump_m_updstate_avx2x4$20:
	jmp 	.L_dump_m_updstate_avx2x4$19
.L_dump_m_updstate_avx2x4$18:
	movq	%rcx, (%rsi)
	addq	$8, %rsi
.L_dump_m_updstate_avx2x4$19:
	movq	8(%rdi,%rax,4), %rcx
	cmpq	$8, %r11
	jnb 	.L_dump_m_updstate_avx2x4$13
	testq	$4, %r11
	je  	.L_dump_m_updstate_avx2x4$17
	movl	%ecx, (%r10)
	addq	$4, %r10
	shrq	$32, %rcx
.L_dump_m_updstate_avx2x4$17:
	testq	$2, %r11
	je  	.L_dump_m_updstate_avx2x4$16
	movw	%cx, (%r10)
	addq	$2, %r10
	shrq	$16, %rcx
.L_dump_m_updstate_avx2x4$16:
	testq	$1, %r11
	je  	.L_dump_m_updstate_avx2x4$14
	movb	%cl, (%r10)
	incq	%r10
.L_dump_m_updstate_avx2x4$15:
	jmp 	.L_dump_m_updstate_avx2x4$14
.L_dump_m_updstate_avx2x4$13:
	movq	%rcx, (%r10)
	addq	$8, %r10
.L_dump_m_updstate_avx2x4$14:
	movq	16(%rdi,%rax,4), %rcx
	cmpq	$8, %r11
	jnb 	.L_dump_m_updstate_avx2x4$8
	testq	$4, %r11
	je  	.L_dump_m_updstate_avx2x4$12
	movl	%ecx, (%r8)
	addq	$4, %r8
	shrq	$32, %rcx
.L_dump_m_updstate_avx2x4$12:
	testq	$2, %r11
	je  	.L_dump_m_updstate_avx2x4$11
	movw	%cx, (%r8)
	addq	$2, %r8
	shrq	$16, %rcx
.L_dump_m_updstate_avx2x4$11:
	testq	$1, %r11
	je  	.L_dump_m_updstate_avx2x4$9
	movb	%cl, (%r8)
	incq	%r8
.L_dump_m_updstate_avx2x4$10:
	jmp 	.L_dump_m_updstate_avx2x4$9
.L_dump_m_updstate_avx2x4$8:
	movq	%rcx, (%r8)
	addq	$8, %r8
.L_dump_m_updstate_avx2x4$9:
	movq	24(%rdi,%rax,4), %rcx
	cmpq	$8, %r11
	jnb 	.L_dump_m_updstate_avx2x4$3
	testq	$4, %r11
	je  	.L_dump_m_updstate_avx2x4$7
	movl	%ecx, (%r12)
	addq	$4, %r12
	shrq	$32, %rcx
.L_dump_m_updstate_avx2x4$7:
	testq	$2, %r11
	je  	.L_dump_m_updstate_avx2x4$6
	movw	%cx, (%r12)
	addq	$2, %r12
	shrq	$16, %rcx
.L_dump_m_updstate_avx2x4$6:
	testq	$1, %r11
	je  	.L_dump_m_updstate_avx2x4$2
	movb	%cl, (%r12)
	incq	%r12
.L_dump_m_updstate_avx2x4$5:
	jmp 	.L_dump_m_updstate_avx2x4$2
.L_dump_m_updstate_avx2x4$3:
	movq	%rcx, (%r12)
	addq	$8, %r12
.L_dump_m_updstate_avx2x4$4:
.L_dump_m_updstate_avx2x4$2:
	movq	%r9, %rax
	ret
.L_absorb_m_updstate_avx2x4$1:
	movq	800(%r11), %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rax
	call	.L_ststatus_data_avx2x4$1
.L_absorb_m_updstate_avx2x4$7:
	movq	%r11, %rdi
	movq	%r11, %mm0
	addq	%rax, %r12
	jmp 	.L_absorb_m_updstate_avx2x4$3
.L_absorb_m_updstate_avx2x4$4:
	movq	%r12, %mm1
	call	.L_add_m_updstate_avx2x4$1
.L_absorb_m_updstate_avx2x4$6:
	movq	%mm1, %r12
	call	.L_keccakf1600_avx2x4_nat$1
.L_absorb_m_updstate_avx2x4$5:
	subq	%r9, %r12
	movq	$0, %rax
.L_absorb_m_updstate_avx2x4$3:
	cmpq	%r12, %r9
	jbe 	.L_absorb_m_updstate_avx2x4$4
	movq	%r12, %r9
	call	.L_add_m_updstate_avx2x4$1
.L_absorb_m_updstate_avx2x4$2:
	movq	%mm0, %rdx
	movb	%al, 800(%rdx)
	ret
.L_add_m_updstate_avx2x4$1:
	movq	%rax, %rbx
	andq	$7, %rbx
	cmpq	$0, %rbx
	je  	.L_add_m_updstate_avx2x4$29
	movq	%r9, %r12
	subq	%rax, %r12
	shrq	$3, %rax
	shlq	$3, %rax
	movb	%bl, %r11b
	shlb	$3, %r11b
	movq	%rsi, %r14
	cmpq	$8, %r12
	jnb 	.L_add_m_updstate_avx2x4$50
	testq	$4, %r12
	jne 	.L_add_m_updstate_avx2x4$54
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$55
.L_add_m_updstate_avx2x4$54:
	movl	(%r14), %ebp
	addq	$4, %r14
	movb	$32, %cl
.L_add_m_updstate_avx2x4$55:
	testq	$2, %r12
	je  	.L_add_m_updstate_avx2x4$53
	movzwq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %r14
	addb	$16, %cl
.L_add_m_updstate_avx2x4$53:
	testq	$1, %r12
	je  	.L_add_m_updstate_avx2x4$51
	movzbq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
.L_add_m_updstate_avx2x4$52:
	jmp 	.L_add_m_updstate_avx2x4$51
.L_add_m_updstate_avx2x4$50:
	movq	(%r14), %rbp
.L_add_m_updstate_avx2x4$51:
	movb	%r11b, %cl
	shlq	%cl, %rbp
	xorq	%rbp, (%rdi,%rax,4)
	movq	%rdx, %r14
	cmpq	$8, %r12
	jnb 	.L_add_m_updstate_avx2x4$44
	testq	$4, %r12
	jne 	.L_add_m_updstate_avx2x4$48
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$49
.L_add_m_updstate_avx2x4$48:
	movl	(%r14), %ebp
	addq	$4, %r14
	movb	$32, %cl
.L_add_m_updstate_avx2x4$49:
	testq	$2, %r12
	je  	.L_add_m_updstate_avx2x4$47
	movzwq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %r14
	addb	$16, %cl
.L_add_m_updstate_avx2x4$47:
	testq	$1, %r12
	je  	.L_add_m_updstate_avx2x4$45
	movzbq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
.L_add_m_updstate_avx2x4$46:
	jmp 	.L_add_m_updstate_avx2x4$45
.L_add_m_updstate_avx2x4$44:
	movq	(%r14), %rbp
.L_add_m_updstate_avx2x4$45:
	movb	%r11b, %cl
	shlq	%cl, %rbp
	xorq	%rbp, 8(%rdi,%rax,4)
	movq	%r10, %r14
	cmpq	$8, %r12
	jnb 	.L_add_m_updstate_avx2x4$38
	testq	$4, %r12
	jne 	.L_add_m_updstate_avx2x4$42
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$43
.L_add_m_updstate_avx2x4$42:
	movl	(%r14), %ebp
	addq	$4, %r14
	movb	$32, %cl
.L_add_m_updstate_avx2x4$43:
	testq	$2, %r12
	je  	.L_add_m_updstate_avx2x4$41
	movzwq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %r14
	addb	$16, %cl
.L_add_m_updstate_avx2x4$41:
	testq	$1, %r12
	je  	.L_add_m_updstate_avx2x4$39
	movzbq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
.L_add_m_updstate_avx2x4$40:
	jmp 	.L_add_m_updstate_avx2x4$39
.L_add_m_updstate_avx2x4$38:
	movq	(%r14), %rbp
.L_add_m_updstate_avx2x4$39:
	movb	%r11b, %cl
	shlq	%cl, %rbp
	xorq	%rbp, 16(%rdi,%rax,4)
	movq	%r8, %r14
	cmpq	$8, %r12
	jnb 	.L_add_m_updstate_avx2x4$32
	testq	$4, %r12
	jne 	.L_add_m_updstate_avx2x4$36
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$37
.L_add_m_updstate_avx2x4$36:
	movl	(%r14), %ebp
	addq	$4, %r14
	movb	$32, %cl
.L_add_m_updstate_avx2x4$37:
	testq	$2, %r12
	je  	.L_add_m_updstate_avx2x4$35
	movzwq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %r14
	addb	$16, %cl
.L_add_m_updstate_avx2x4$35:
	testq	$1, %r12
	je  	.L_add_m_updstate_avx2x4$33
	movzbq	(%r14), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
.L_add_m_updstate_avx2x4$34:
	jmp 	.L_add_m_updstate_avx2x4$33
.L_add_m_updstate_avx2x4$32:
	movq	(%r14), %rbp
.L_add_m_updstate_avx2x4$33:
	movb	%r11b, %cl
	shlq	%cl, %rbp
	xorq	%rbp, 24(%rdi,%rax,4)
	addq	%rbx, %r12
	cmpq	$8, %r12
	jnb 	.L_add_m_updstate_avx2x4$30
	movq	%r9, %rax
	jmp 	.L_add_m_updstate_avx2x4$31
.L_add_m_updstate_avx2x4$30:
	movq	$8, %r12
	addq	$8, %rax
.L_add_m_updstate_avx2x4$31:
	subq	%rbx, %r12
	addq	%r12, %rsi
	addq	%r12, %rdx
	addq	%r12, %r10
	addq	%r12, %r8
.L_add_m_updstate_avx2x4$29:
	movq	%rax, %rcx
	jmp 	.L_add_m_updstate_avx2x4$27
.L_add_m_updstate_avx2x4$28:
	movq	(%rsi), %r11
	xorq	%r11, (%rdi,%rax,4)
	movq	(%rdx), %r11
	xorq	%r11, 8(%rdi,%rax,4)
	movq	(%r10), %r11
	xorq	%r11, 16(%rdi,%rax,4)
	movq	(%r8), %r11
	xorq	%r11, 24(%rdi,%rax,4)
	movq	%rcx, %rax
	addq	$8, %rsi
	addq	$8, %rdx
	addq	$8, %r10
	addq	$8, %r8
.L_add_m_updstate_avx2x4$27:
	addq	$8, %rcx
	cmpq	%r9, %rcx
	jbe 	.L_add_m_updstate_avx2x4$28
	cmpq	%r9, %rax
	jnb 	.L_add_m_updstate_avx2x4$2
	movq	%r9, %r11
	andq	$7, %r11
	cmpq	$8, %r11
	jnb 	.L_add_m_updstate_avx2x4$21
	testq	$4, %r11
	jne 	.L_add_m_updstate_avx2x4$25
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$26
.L_add_m_updstate_avx2x4$25:
	movl	(%rsi), %ebp
	addq	$4, %rsi
	movb	$32, %cl
.L_add_m_updstate_avx2x4$26:
	testq	$2, %r11
	je  	.L_add_m_updstate_avx2x4$24
	movzwq	(%rsi), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %rsi
	addb	$16, %cl
.L_add_m_updstate_avx2x4$24:
	testq	$1, %r11
	je  	.L_add_m_updstate_avx2x4$22
	movzbq	(%rsi), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	incq	%rsi
.L_add_m_updstate_avx2x4$23:
	jmp 	.L_add_m_updstate_avx2x4$22
.L_add_m_updstate_avx2x4$21:
	movq	(%rsi), %rbp
	addq	$8, %rsi
.L_add_m_updstate_avx2x4$22:
	xorq	%rbp, (%rdi,%rax,4)
	cmpq	$8, %r11
	jnb 	.L_add_m_updstate_avx2x4$15
	testq	$4, %r11
	jne 	.L_add_m_updstate_avx2x4$19
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$20
.L_add_m_updstate_avx2x4$19:
	movl	(%rdx), %ebp
	addq	$4, %rdx
	movb	$32, %cl
.L_add_m_updstate_avx2x4$20:
	testq	$2, %r11
	je  	.L_add_m_updstate_avx2x4$18
	movzwq	(%rdx), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %rdx
	addb	$16, %cl
.L_add_m_updstate_avx2x4$18:
	testq	$1, %r11
	je  	.L_add_m_updstate_avx2x4$16
	movzbq	(%rdx), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	incq	%rdx
.L_add_m_updstate_avx2x4$17:
	jmp 	.L_add_m_updstate_avx2x4$16
.L_add_m_updstate_avx2x4$15:
	movq	(%rdx), %rbp
	addq	$8, %rdx
.L_add_m_updstate_avx2x4$16:
	xorq	%rbp, 8(%rdi,%rax,4)
	cmpq	$8, %r11
	jnb 	.L_add_m_updstate_avx2x4$9
	testq	$4, %r11
	jne 	.L_add_m_updstate_avx2x4$13
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$14
.L_add_m_updstate_avx2x4$13:
	movl	(%r10), %ebp
	addq	$4, %r10
	movb	$32, %cl
.L_add_m_updstate_avx2x4$14:
	testq	$2, %r11
	je  	.L_add_m_updstate_avx2x4$12
	movzwq	(%r10), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %r10
	addb	$16, %cl
.L_add_m_updstate_avx2x4$12:
	testq	$1, %r11
	je  	.L_add_m_updstate_avx2x4$10
	movzbq	(%r10), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	incq	%r10
.L_add_m_updstate_avx2x4$11:
	jmp 	.L_add_m_updstate_avx2x4$10
.L_add_m_updstate_avx2x4$9:
	movq	(%r10), %rbp
	addq	$8, %r10
.L_add_m_updstate_avx2x4$10:
	xorq	%rbp, 16(%rdi,%rax,4)
	cmpq	$8, %r11
	jnb 	.L_add_m_updstate_avx2x4$3
	testq	$4, %r11
	jne 	.L_add_m_updstate_avx2x4$7
	movq	$0, %rbx
	movb	$0, %cl
	jmp 	.L_add_m_updstate_avx2x4$8
.L_add_m_updstate_avx2x4$7:
	movl	(%r8), %ebx
	addq	$4, %r8
	movb	$32, %cl
.L_add_m_updstate_avx2x4$8:
	testq	$2, %r11
	je  	.L_add_m_updstate_avx2x4$6
	movzwq	(%r8), %r13
	shlq	%cl, %r13
	addq	%r13, %rbx
	addq	$2, %r8
	addb	$16, %cl
.L_add_m_updstate_avx2x4$6:
	testq	$1, %r11
	je  	.L_add_m_updstate_avx2x4$4
	movzbq	(%r8), %r11
	shlq	%cl, %r11
	addq	%r11, %rbx
	incq	%r8
.L_add_m_updstate_avx2x4$5:
	jmp 	.L_add_m_updstate_avx2x4$4
.L_add_m_updstate_avx2x4$3:
	movq	(%r8), %rbx
	addq	$8, %r8
.L_add_m_updstate_avx2x4$4:
	xorq	%rbx, 24(%rdi,%rax,4)
.L_add_m_updstate_avx2x4$2:
	movq	%r9, %rax
	ret
.L_absorb_m_bcast_updstate_avx2x4$1:
	movq	800(%rdx), %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rax
	call	.L_ststatus_data_avx2x4$1
.L_absorb_m_bcast_updstate_avx2x4$7:
	movq	%rdx, %rdi
	addq	%rax, %r8
	jmp 	.L_absorb_m_bcast_updstate_avx2x4$3
.L_absorb_m_bcast_updstate_avx2x4$4:
	call	.L_add_m_bcast_updstate_avx2x4$1
.L_absorb_m_bcast_updstate_avx2x4$6:
	call	.L_keccakf1600_avx2x4_nat$1
.L_absorb_m_bcast_updstate_avx2x4$5:
	subq	%r9, %r8
	movq	$0, %rax
.L_absorb_m_bcast_updstate_avx2x4$3:
	cmpq	%r8, %r9
	jbe 	.L_absorb_m_bcast_updstate_avx2x4$4
	movq	%r8, %r9
	call	.L_add_m_bcast_updstate_avx2x4$1
.L_absorb_m_bcast_updstate_avx2x4$2:
	movb	%al, 800(%rdx)
	ret
.L_add_m_bcast_updstate_avx2x4$1:
	movq	%rax, %r11
	andq	$7, %r11
	cmpq	$0, %r11
	je  	.L_add_m_bcast_updstate_avx2x4$11
	movq	%r9, %r10
	subq	%rax, %r10
	shrq	$3, %rax
	shlq	$3, %rax
	movq	%rsi, %rbx
	cmpq	$8, %r10
	jnb 	.L_add_m_bcast_updstate_avx2x4$14
	testq	$4, %r10
	jne 	.L_add_m_bcast_updstate_avx2x4$18
	movq	$0, %rbp
	movb	$0, %cl
	jmp 	.L_add_m_bcast_updstate_avx2x4$19
.L_add_m_bcast_updstate_avx2x4$18:
	movl	(%rbx), %ebp
	addq	$4, %rbx
	movb	$32, %cl
.L_add_m_bcast_updstate_avx2x4$19:
	testq	$2, %r10
	je  	.L_add_m_bcast_updstate_avx2x4$17
	movzwq	(%rbx), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	addq	$2, %rbx
	addb	$16, %cl
.L_add_m_bcast_updstate_avx2x4$17:
	testq	$1, %r10
	je  	.L_add_m_bcast_updstate_avx2x4$15
	movzbq	(%rbx), %r13
	shlq	%cl, %r13
	addq	%r13, %rbp
	incq	%rbx
.L_add_m_bcast_updstate_avx2x4$16:
	jmp 	.L_add_m_bcast_updstate_avx2x4$15
.L_add_m_bcast_updstate_avx2x4$14:
	movq	(%rbx), %rbp
	addq	$8, %rbx
.L_add_m_bcast_updstate_avx2x4$15:
	addq	%r11, %r10
	movb	%r11b, %cl
	shlb	$3, %cl
	shlq	%cl, %rbp
	vmovq	%rbp, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vpxor	(%rdi,%rax,4), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi,%rax,4)
	cmpq	$8, %r10
	jnb 	.L_add_m_bcast_updstate_avx2x4$12
	movq	%rbx, %rsi
	movq	%r9, %rax
	jmp 	.L_add_m_bcast_updstate_avx2x4$11
.L_add_m_bcast_updstate_avx2x4$12:
	movq	$8, %r10
	subq	%r11, %r10
	addq	%r10, %rsi
	addq	$8, %rax
.L_add_m_bcast_updstate_avx2x4$13:
.L_add_m_bcast_updstate_avx2x4$11:
	movq	%rax, %rcx
	jmp 	.L_add_m_bcast_updstate_avx2x4$9
.L_add_m_bcast_updstate_avx2x4$10:
	vpbroadcastq	(%rsi), %ymm0
	vpxor	(%rdi,%rax,4), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi,%rax,4)
	movq	%rcx, %rax
	addq	$8, %rsi
.L_add_m_bcast_updstate_avx2x4$9:
	addq	$8, %rcx
	cmpq	%r9, %rcx
	jbe 	.L_add_m_bcast_updstate_avx2x4$10
	cmpq	%r9, %rax
	jnb 	.L_add_m_bcast_updstate_avx2x4$2
	movq	%r9, %r11
	andq	$7, %r11
	cmpq	$8, %r11
	jnb 	.L_add_m_bcast_updstate_avx2x4$3
	testq	$4, %r11
	jne 	.L_add_m_bcast_updstate_avx2x4$7
	movq	$0, %r10
	movb	$0, %cl
	jmp 	.L_add_m_bcast_updstate_avx2x4$8
.L_add_m_bcast_updstate_avx2x4$7:
	movl	(%rsi), %r10d
	addq	$4, %rsi
	movb	$32, %cl
.L_add_m_bcast_updstate_avx2x4$8:
	testq	$2, %r11
	je  	.L_add_m_bcast_updstate_avx2x4$6
	movzwq	(%rsi), %r13
	shlq	%cl, %r13
	addq	%r13, %r10
	addq	$2, %rsi
	addb	$16, %cl
.L_add_m_bcast_updstate_avx2x4$6:
	testq	$1, %r11
	je  	.L_add_m_bcast_updstate_avx2x4$4
	movzbq	(%rsi), %r11
	shlq	%cl, %r11
	addq	%r11, %r10
	incq	%rsi
.L_add_m_bcast_updstate_avx2x4$5:
	jmp 	.L_add_m_bcast_updstate_avx2x4$4
.L_add_m_bcast_updstate_avx2x4$3:
	movq	(%rsi), %r10
	addq	$8, %rsi
.L_add_m_bcast_updstate_avx2x4$4:
	vmovq	%r10, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vpxor	(%rdi,%rax,4), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi,%rax,4)
.L_add_m_bcast_updstate_avx2x4$2:
	movq	%r9, %rax
	ret
	.type	finish_updstate_avx2x4, %function
finish_updstate_avx2x4:
	movq	%rsp, %rax
	leaq	-16(%rsp), %rsp
	andq	$-8, %rsp
	movq	%r13, (%rsp)
	movq	%rax, 8(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, %r13
	call	.L_finish_updstate_avx2x4$1
.Lfinish_updstate_avx2x4$1:
	movq	(%rsp), %r13
	movq	8(%rsp), %rsp
	ret
	.type	init_updstate_avx2x4, %function
init_updstate_avx2x4:
	movq	%rsp, %r10
	andq	$-8, %rsp
	lfence
	movq	$0, %rax
	call	.L_init_updstate_avx2x4$1
.Linit_updstate_avx2x4$1:
	movq	%r10, %rsp
	ret
	.type	ststatus_updstate_avx2x4, %function
ststatus_updstate_avx2x4:
	movq	%rsp, %r10
	andq	$-8, %rsp
	movq	%rdi, %rdx
	lfence
	movq	$0, %rax
	movq	800(%rsi), %rcx
// declassify_val u64 %rcx
	call	.L_ststatus_data_avx2x4$1
.Lststatus_updstate_avx2x4$1:
	movb	%r9b, (%rdx)
	movb	%al, 1(%rdx)
	movb	802(%rsi), %al
	movb	%al, 2(%rdx)
	movq	%r10, %rsp
	ret
.L_finish_updstate_avx2x4$1:
	movq	800(%r13), %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rax
	call	.L_ststatus_data_avx2x4$1
.L_finish_updstate_avx2x4$2:
	movb	%al, %cl
	shrq	$3, %rax
	shlq	$5, %rax
	andb	$7, %cl
	shlb	$3, %cl
	shlq	%cl, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vpxor	(%r13,%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%r13,%rax)
	movq	$1, %rax
	shlq	$63, %rax
	decq	%r9
	shrq	$3, %r9
	shlq	$5, %r9
	vmovq	%rax, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vpxor	(%r13,%r9), %ymm0, %ymm0
	vmovdqu	%ymm0, (%r13,%r9)
	andl	$-16711936, 800(%r13)
	ret
.L_ststatus_data_avx2x4$1:
	movq	%rcx, %rax
	andq	$255, %rax
	shrq	$8, %rcx
	movq	%rcx, %r9
	andq	$255, %r9
	incq	%r9
	shlq	$3, %r9
	movq	$200, %rdi
	cmpq	$200, %r9
	cmovnbe	%rdi, %r9
	movq	$0, %rdi
	cmpq	%rax, %r9
	cmovbe	%rdi, %rax
	shrq	$8, %rcx
	andq	$255, %rcx
	movq	%rcx, %rdi
	ret
.L_init_updstate_avx2x4$1:
	movq	%rdi, %rax
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rcx
	jmp 	.L_init_updstate_avx2x4$2
.L_init_updstate_avx2x4$3:
	vmovdqu	%ymm0, (%rax,%rcx)
	addq	$32, %rcx
.L_init_updstate_avx2x4$2:
	cmpq	$800, %rcx
	jb  	.L_init_updstate_avx2x4$3
	movzbq	%dl, %rdx
	shlq	$8, %rdx
	decb	%sil
	movzbq	%sil, %rax
	addq	%rax, %rdx
	shlq	$8, %rdx
	movq	%rdx, 800(%rdi)
	ret
.L_keccakf1600_avx2x4_nat$1:
	vmovdqu	224(%rdi), %ymm10
	vmovdqu	256(%rdi), %ymm13
	vmovdqu	352(%rdi), %ymm7
	vmovdqu	384(%rdi), %ymm0
	vmovdqu	480(%rdi), %ymm4
	vmovdqu	576(%rdi), %ymm1
	vmovdqu	672(%rdi), %ymm14
	vmovdqu	704(%rdi), %ymm2
	vmovdqu	768(%rdi), %ymm3
	leaq	glob_data + 0(%rip), %rcx
	leaq	glob_data + 32(%rip), %r11
	leaq	glob_data + 64(%rip), %rbx
	movq	$0, %rbp
.L_keccakf1600_avx2x4_nat$2:
	vmovdqu	160(%rdi), %ymm12
	vpxor	640(%rdi), %ymm4, %ymm9
	vmovdqu	%ymm4, 224(%rdi)
	vmovdqu	%ymm10, %ymm4
	vmovdqu	192(%rdi), %ymm8
	vmovdqu	512(%rdi), %ymm6
	vmovdqu	%ymm14, 352(%rdi)
	vpxor	320(%rdi), %ymm12, %ymm11
	vmovdqu	64(%rdi), %ymm10
	vmovdqu	%ymm12, 256(%rdi)
	vpxor	%ymm14, %ymm6, %ymm6
	vmovdqu	32(%rdi), %ymm5
	vmovdqu	448(%rdi), %ymm12
	vmovdqu	%ymm13, 576(%rdi)
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm7, %ymm8, %ymm11
	vpxor	544(%rdi), %ymm2, %ymm8
	vmovdqu	%ymm10, 480(%rdi)
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm4, %ymm11
	vmovdqu	288(%rdi), %ymm14
	vmovdqu	%ymm7, 384(%rdi)
	vpxor	%ymm11, %ymm8, %ymm8
	vpxor	416(%rdi), %ymm13, %ymm11
	vpxor	%ymm5, %ymm6, %ymm6
	vmovdqu	96(%rdi), %ymm7
	vpxor	%ymm10, %ymm8, %ymm8
	vpxor	736(%rdi), %ymm1, %ymm10
	vpxor	%ymm12, %ymm14, %ymm14
	vmovdqu	%ymm12, 672(%rdi)
	vpsrlq	$63, %ymm6, %ymm12
	vpsrlq	$63, %ymm8, %ymm15
	vpxor	(%rdi), %ymm9, %ymm9
	vpxor	%ymm11, %ymm10, %ymm10
	vmovdqu	128(%rdi), %ymm13
	vpxor	%ymm7, %ymm10, %ymm10
	vpxor	608(%rdi), %ymm3, %ymm11
	vmovdqu	%ymm13, 704(%rdi)
	vpxor	%ymm14, %ymm11, %ymm11
	vpsllq	$1, %ymm6, %ymm14
	vpor	%ymm12, %ymm14, %ymm14
	vpsllq	$1, %ymm8, %ymm12
	vpxor	%ymm13, %ymm11, %ymm11
	vpor	%ymm15, %ymm12, %ymm12
	vpsrlq	$63, %ymm10, %ymm13
	vpxor	%ymm11, %ymm14, %ymm14
	vpsllq	$1, %ymm10, %ymm15
	vpxor	%ymm9, %ymm12, %ymm12
	vpor	%ymm13, %ymm15, %ymm15
	vpxor	%ymm5, %ymm12, %ymm5
	vpxor	%ymm6, %ymm15, %ymm15
	vpsrlq	$63, %ymm11, %ymm6
	vpsllq	$1, %ymm11, %ymm11
	vpxor	%ymm2, %ymm15, %ymm2
	vpxor	%ymm4, %ymm15, %ymm4
	vpor	%ymm6, %ymm11, %ymm11
	vpxor	(%rdi), %ymm14, %ymm6
	vpxor	%ymm8, %ymm11, %ymm11
	vpsrlq	$63, %ymm9, %ymm8
	vpsllq	$1, %ymm9, %ymm9
	vpxor	%ymm1, %ymm11, %ymm1
	vpxor	%ymm7, %ymm11, %ymm7
	vpor	%ymm8, %ymm9, %ymm9
	vpxor	%ymm10, %ymm9, %ymm9
	vpxor	192(%rdi), %ymm12, %ymm10
	vpxor	%ymm3, %ymm9, %ymm3
	vpsrlq	$20, %ymm10, %ymm8
	vpsllq	$44, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpxor	%ymm0, %ymm15, %ymm8
	vpbroadcastq	(%rbx,%rbp,8), %ymm0
	vpsrlq	$21, %ymm8, %ymm13
	vpsllq	$43, %ymm8, %ymm8
	vpor	%ymm13, %ymm8, %ymm8
	vpandn	%ymm8, %ymm10, %ymm13
	vpxor	%ymm0, %ymm13, %ymm13
	vpxor	%ymm6, %ymm13, %ymm0
	vpsrlq	$43, %ymm1, %ymm13
	vpsllq	$21, %ymm1, %ymm1
	vmovdqu	%ymm0, (%rdi)
	vpor	%ymm13, %ymm1, %ymm1
	vpandn	%ymm1, %ymm8, %ymm13
	vpxor	%ymm10, %ymm13, %ymm0
	vpsrlq	$50, %ymm3, %ymm13
	vpsllq	$14, %ymm3, %ymm3
	vmovdqu	%ymm0, 32(%rdi)
	vpor	%ymm13, %ymm3, %ymm3
	vpandn	%ymm3, %ymm1, %ymm13
	vpxor	%ymm8, %ymm13, %ymm8
	vmovdqu	%ymm8, 64(%rdi)
	vpandn	%ymm6, %ymm3, %ymm8
	vpandn	%ymm10, %ymm6, %ymm6
	vpxor	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rdi)
	vpxor	%ymm3, %ymm6, %ymm8
	vpsrlq	$36, %ymm7, %ymm3
	vpsllq	$28, %ymm7, %ymm7
	vmovdqu	%ymm8, 128(%rdi)
	vpor	%ymm3, %ymm7, %ymm7
	vpxor	288(%rdi), %ymm9, %ymm3
	vpsrlq	$44, %ymm3, %ymm10
	vpsllq	$20, %ymm3, %ymm3
	vpor	%ymm10, %ymm3, %ymm3
	vpxor	320(%rdi), %ymm14, %ymm10
	vpsrlq	$61, %ymm10, %ymm8
	vpsllq	$3, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpandn	%ymm10, %ymm3, %ymm8
	vpxor	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rdi)
	vpxor	512(%rdi), %ymm12, %ymm8
	vpsrlq	$19, %ymm8, %ymm6
	vpsllq	$45, %ymm8, %ymm8
	vpor	%ymm6, %ymm8, %ymm8
	vpandn	%ymm8, %ymm10, %ymm6
	vpxor	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rdi)
	vpsrlq	$3, %ymm2, %ymm6
	vpsllq	$61, %ymm2, %ymm2
	vpor	%ymm6, %ymm2, %ymm2
	vpandn	%ymm2, %ymm8, %ymm6
	vpxor	%ymm10, %ymm6, %ymm10
	vpandn	%ymm7, %ymm2, %ymm6
	vpandn	%ymm3, %ymm7, %ymm7
	vpsrlq	$63, %ymm5, %ymm3
	vpsllq	$1, %ymm5, %ymm5
	vpxor	%ymm8, %ymm6, %ymm13
	vpor	%ymm3, %ymm5, %ymm5
	vpsrlq	$58, %ymm4, %ymm3
	vpxor	%ymm2, %ymm7, %ymm6
	vpsllq	$6, %ymm4, %ymm4
	vmovdqu	%ymm6, 288(%rdi)
	vpxor	608(%rdi), %ymm9, %ymm2
	vpor	%ymm3, %ymm4, %ymm4
	vpxor	416(%rdi), %ymm11, %ymm3
	vpshufb	(%rcx), %ymm2, %ymm2
	vpsrlq	$39, %ymm3, %ymm8
	vpsllq	$25, %ymm3, %ymm3
	vpor	%ymm3, %ymm8, %ymm8
	vpandn	%ymm8, %ymm4, %ymm3
	vpandn	%ymm2, %ymm8, %ymm7
	vpxor	%ymm5, %ymm3, %ymm6
	vpxor	640(%rdi), %ymm14, %ymm3
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm6, 320(%rdi)
	vpsrlq	$46, %ymm3, %ymm6
	vpsllq	$18, %ymm3, %ymm3
	vpor	%ymm3, %ymm6, %ymm3
	vpandn	%ymm3, %ymm2, %ymm6
	vpxor	%ymm8, %ymm6, %ymm0
	vpandn	%ymm5, %ymm3, %ymm8
	vpandn	%ymm4, %ymm5, %ymm5
	vpxor	%ymm2, %ymm8, %ymm6
	vmovdqu	%ymm6, 416(%rdi)
	vpxor	%ymm3, %ymm5, %ymm6
	vpxor	704(%rdi), %ymm9, %ymm5
	vpxor	672(%rdi), %ymm9, %ymm9
	vmovdqu	%ymm6, 448(%rdi)
	vpsrlq	$37, %ymm5, %ymm3
	vpsllq	$27, %ymm5, %ymm5
	vpor	%ymm5, %ymm3, %ymm3
	vpxor	256(%rdi), %ymm14, %ymm5
	vpxor	224(%rdi), %ymm14, %ymm14
	vpsrlq	$28, %ymm5, %ymm2
	vpsllq	$36, %ymm5, %ymm5
	vpor	%ymm5, %ymm2, %ymm2
	vpxor	384(%rdi), %ymm12, %ymm5
	vpxor	352(%rdi), %ymm12, %ymm12
	vpsrlq	$54, %ymm5, %ymm6
	vpsllq	$10, %ymm5, %ymm5
	vpor	%ymm5, %ymm6, %ymm6
	vpxor	544(%rdi), %ymm15, %ymm5
	vpxor	480(%rdi), %ymm15, %ymm15
	vpandn	%ymm6, %ymm2, %ymm4
	vpsrlq	$49, %ymm5, %ymm8
	vpsllq	$15, %ymm5, %ymm5
	vpxor	%ymm3, %ymm4, %ymm4
	vpor	%ymm5, %ymm8, %ymm8
	vpandn	%ymm8, %ymm6, %ymm5
	vpxor	%ymm2, %ymm5, %ymm5
	vmovdqu	%ymm5, 512(%rdi)
	vpxor	736(%rdi), %ymm11, %ymm5
	vpxor	576(%rdi), %ymm11, %ymm11
	vpshufb	(%r11), %ymm5, %ymm5
	vpandn	%ymm5, %ymm8, %ymm1
	vpxor	%ymm6, %ymm1, %ymm1
	vmovdqu	%ymm1, 544(%rdi)
	vpandn	%ymm3, %ymm5, %ymm1
	vpandn	%ymm2, %ymm3, %ymm3
	vpxor	%ymm5, %ymm3, %ymm3
	vpsrlq	$62, %ymm12, %ymm5
	vpxor	%ymm8, %ymm1, %ymm1
	vmovdqu	%ymm3, 608(%rdi)
	vpsrlq	$2, %ymm15, %ymm3
	vpsllq	$62, %ymm15, %ymm15
	vpor	%ymm15, %ymm3, %ymm3
	vpsrlq	$9, %ymm11, %ymm15
	vpsllq	$55, %ymm11, %ymm11
	vpsllq	$2, %ymm12, %ymm12
	vpor	%ymm11, %ymm15, %ymm11
	vpsrlq	$25, %ymm9, %ymm15
	vpor	%ymm12, %ymm5, %ymm12
	vpsllq	$39, %ymm9, %ymm9
	vpor	%ymm9, %ymm15, %ymm15
	vpandn	%ymm15, %ymm11, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vmovdqu	%ymm9, 640(%rdi)
	vpsrlq	$23, %ymm14, %ymm9
	vpsllq	$41, %ymm14, %ymm14
	vpor	%ymm14, %ymm9, %ymm9
	vpandn	%ymm12, %ymm9, %ymm2
	vpandn	%ymm9, %ymm15, %ymm14
	vpxor	%ymm15, %ymm2, %ymm2
	vpandn	%ymm3, %ymm12, %ymm15
	vpandn	%ymm11, %ymm3, %ymm3
	vpxor	%ymm9, %ymm15, %ymm15
	vpxor	%ymm11, %ymm14, %ymm14
	vpxor	%ymm12, %ymm3, %ymm3
	vmovdqu	%ymm15, 736(%rdi)
	incq	%rbp
	cmpq	$24, %rbp
	jb  	.L_keccakf1600_avx2x4_nat$2
	vmovdqu	%ymm10, 224(%rdi)
	vmovdqu	%ymm13, 256(%rdi)
	vmovdqu	%ymm7, 352(%rdi)
	vmovdqu	%ymm0, 384(%rdi)
	vmovdqu	%ymm4, 480(%rdi)
	vmovdqu	%ymm1, 576(%rdi)
	vmovdqu	%ymm14, 672(%rdi)
	vmovdqu	%ymm2, 704(%rdi)
	vmovdqu	%ymm3, 768(%rdi)
	ret
	.data
	.p2align	5
glob_data:
G$ROL8:
	.byte	  7,   0,   1,   2,   3,   4,   5,   6,  15,   8,   9,  10,  11,  12,  13,  14
	.byte	 23,  16,  17,  18,  19,  20,  21,  22,  31,  24,  25,  26,  27,  28,  29,  30
G$ROL56:
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
	.byte	 17,  18,  19,  20,  21,  22,  23,  16,  25,  26,  27,  28,  29,  30,  31,  24
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
