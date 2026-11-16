	.att_syntax
	.text
	.p2align	5
	.global	jade_hash_sha224_amd64_avx2_final
	.global	jade_hash_sha224_amd64_avx2_update
	.global	jade_hash_sha224_amd64_avx2_init
	.global	jade_hash_sha224_amd64_avx2
	.type	jade_hash_sha224_amd64_avx2_final, %function
jade_hash_sha224_amd64_avx2_final:
	movq	%rsp, %rax
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rsi, %r10
	lfence
	movq	$0, %rax
	movq	$1104651839603, %rcx
	movq	%rcx, %rdx
	leaq	-24(%rsp), %rsp
	call	.L_sha224_ctx___sha2_ctx_final$1
.Ljade_hash_sha224_amd64_avx2_final$1:
	leaq	24(%rsp), %rsp
	movq	%r8, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$704, %rsp
	movq	$704, %rdi
.Ljade_hash_sha224_amd64_avx2_final$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha224_amd64_avx2_final$2
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha224_amd64_avx2_update, %function
jade_hash_sha224_amd64_avx2_update:
	movq	%rsp, %rax
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	lfence
	movq	$0, %rax
	movq	$1104651839603, %rcx
	movq	%rcx, %r8
	leaq	-24(%rsp), %rsp
	call	.L_sha256_ctx_update$1
.Ljade_hash_sha224_amd64_avx2_update$1:
	leaq	24(%rsp), %rsp
	movq	%r10, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$768, %rsp
	movq	$768, %rdi
.Ljade_hash_sha224_amd64_avx2_update$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha224_amd64_avx2_update$2
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha224_amd64_avx2_init, %function
jade_hash_sha224_amd64_avx2_init:
	movq	%rsp, %r10
	leaq	-32(%rsp), %rsp
	andq	$-32, %rsp
	lfence
	movq	$0, %rax
	movq	%rsp, %rax
	leaq	glob_data + 352(%rip), %rcx
	movl	(%rcx), %edx
	movl	%edx, (%rax)
	movl	4(%rcx), %edx
	movl	%edx, 4(%rax)
	movl	8(%rcx), %edx
	movl	%edx, 8(%rax)
	movl	12(%rcx), %edx
	movl	%edx, 12(%rax)
	movl	16(%rcx), %edx
	movl	%edx, 16(%rax)
	movl	20(%rcx), %edx
	movl	%edx, 20(%rax)
	movl	24(%rcx), %edx
	movl	%edx, 24(%rax)
	movl	28(%rcx), %edx
	movl	%edx, 28(%rax)
	movq	$1104651839603, %rcx
	movq	$0, %rax
	movq	%rsp, %rdx
	movq	%rcx, (%rdi)
	movq	%rax, 8(%rdi)
	movl	(%rdx), %eax
	movl	%eax, 16(%rdi)
	movl	4(%rdx), %eax
	movl	%eax, 20(%rdi)
	movl	8(%rdx), %eax
	movl	%eax, 24(%rdi)
	movl	12(%rdx), %eax
	movl	%eax, 28(%rdi)
	movl	16(%rdx), %eax
	movl	%eax, 32(%rdi)
	movl	20(%rdx), %eax
	movl	%eax, 36(%rdi)
	movl	24(%rdx), %eax
	movl	%eax, 40(%rdi)
	movl	28(%rdx), %eax
	movl	%eax, 44(%rdi)
	movq	$0, %r9
	movq	%r9, 48(%rdi)
	movq	%r9, 56(%rdi)
	movq	%r9, 64(%rdi)
	movq	%r9, 72(%rdi)
	movq	%r9, 80(%rdi)
	movq	%r9, 88(%rdi)
	movq	%r9, 96(%rdi)
	movq	%r9, 104(%rdi)
	movq	%r10, %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$32, %rsp
	movq	$32, %rdi
.Ljade_hash_sha224_amd64_avx2_init$1:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha224_amd64_avx2_init$1
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha224_amd64_avx2, %function
jade_hash_sha224_amd64_avx2:
	movq	%rsp, %rax
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	lfence
	movq	$0, %rax
	leaq	-120(%rsp), %rsp
	call	.L_sha224_mem$1
.Ljade_hash_sha224_amd64_avx2$1:
	leaq	120(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$864, %rsp
	movq	$864, %rdi
.Ljade_hash_sha224_amd64_avx2$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha224_amd64_avx2$2
	movq	%rsi, %rsp
	ret
.L_sha224_ctx___sha2_ctx_final$1:
	movq	%rdi, %rcx
	movq	(%rcx), %rsi
	movq	8(%rcx), %rcx
// declassify_val u64 %rsi
// declassify_val u64 %rcx
	orq 	%rax, %rsi
	orq 	%rax, %rcx
	movq	$1, %r8
	cmpq	%rdx, %rsi
	je  	.L_sha224_ctx___sha2_ctx_final$2
	movq	$-1, %rcx
	cmove	%rcx, %rax
	jmp 	.L_sha224_ctx___sha2_ctx_final$3
.L_sha224_ctx___sha2_ctx_final$2:
	movq	$-1, %rdx
	cmovne	%rdx, %rax
	leaq	16(%rdi), %rbp
	leaq	48(%rdi), %r8
	leaq	-24(%rsp), %rsp
	call	.L_sha224___sha256_finalize$1
.L_sha224_ctx___sha2_ctx_final$4:
	leaq	24(%rsp), %rsp
	movq	$0, %r9
	movq	%r9, (%rdi)
	movq	%r9, 8(%rdi)
	movq	%r9, 16(%rdi)
	movq	%r9, 24(%rdi)
	movq	%r9, 32(%rdi)
	movq	%r9, 40(%rdi)
	movq	%r9, 48(%rdi)
	movq	%r9, 56(%rdi)
	movq	%r9, 64(%rdi)
	movq	%r9, 72(%rdi)
	movq	%r9, 80(%rdi)
	movq	%r9, 88(%rdi)
	movq	%r9, 96(%rdi)
	movq	%r9, 104(%rdi)
	movq	$0, %r8
.L_sha224_ctx___sha2_ctx_final$3:
	ret
.L_sha256_ctx_update$1:
	movq	%rdi, %rcx
	movq	(%rcx), %r9
	movq	8(%rcx), %rcx
// declassify_val u64 %r9
// declassify_val u64 %rcx
	orq 	%rax, %r9
	orq 	%rax, %rcx
	movq	$1, %r10
	cmpq	%r8, %r9
	je  	.L_sha256_ctx_update$2
	movq	$-1, %rcx
	cmove	%rcx, %rax
	jmp 	.L_sha256_ctx_update$3
.L_sha256_ctx_update$2:
	movq	$-1, %r8
	cmovne	%r8, %rax
	movq	$2305843009213693952, %r8
	movq	$0, %r9
	movq	%r8, %r10
	subq	%rcx, %r10
	cmpq	%r8, %rcx
	cmovb	%r10, %r9
	movq	$2, %r10
	cmpq	%r9, %rdx
	jb  	.L_sha256_ctx_update$4
	movq	$-1, %rcx
	cmovb	%rcx, %rax
	jmp 	.L_sha256_ctx_update$3
.L_sha256_ctx_update$4:
	movq	$-1, %r8
	cmovnb	%r8, %rax
	leaq	16(%rdi), %rbp
	leaq	48(%rdi), %r8
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_sha256_ctx_update$6:
	leaq	56(%rsp), %rsp
	movq	%rcx, 8(%rdi)
	movq	$0, %r10
.L_sha256_ctx_update$5:
.L_sha256_ctx_update$3:
	ret
.L_sha224_mem$1:
	leaq	88(%rsp), %rcx
	leaq	glob_data + 352(%rip), %r8
	movl	(%r8), %r9d
	movl	%r9d, (%rcx)
	movl	4(%r8), %r9d
	movl	%r9d, 4(%rcx)
	movl	8(%r8), %r9d
	movl	%r9d, 8(%rcx)
	movl	12(%r8), %r9d
	movl	%r9d, 12(%rcx)
	movl	16(%r8), %r9d
	movl	%r9d, 16(%rcx)
	movl	20(%r8), %r9d
	movl	%r9d, 20(%rcx)
	movl	24(%r8), %r9d
	movl	%r9d, 24(%rcx)
	movl	28(%r8), %r9d
	movl	%r9d, 28(%rcx)
	leaq	88(%rsp), %rbp
	leaq	16(%rsp), %r8
	movq	$0, %rcx
	movq	%rdi, 80(%rsp)
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_sha224_mem$3:
	leaq	56(%rsp), %rsp
	movq	80(%rsp), %r10
	leaq	-24(%rsp), %rsp
	call	.L_sha224___sha256_finalize$1
.L_sha224_mem$2:
	leaq	24(%rsp), %rsp
	ret
.L_sha224___sha256_finalize$1:
	movq	%rcx, %rsi
	andq	$63, %rsi
	movq	$128, %rdx
	movb	%dl, (%r8,%rsi)
	incq	%rsi
	cmpq	$56, %rsi
	jnbe	.L_sha224___sha256_finalize$9
	movq	$-1, %rdx
	cmovnbe	%rdx, %rax
	jmp 	.L_sha224___sha256_finalize$10
.L_sha224___sha256_finalize$9:
	movq	$-1, %rdx
	cmovbe	%rdx, %rax
	movq	$64, %rdx
	movq	$0, %r9
	movq	%rsi, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdx
	cmovb	%rdx, %r11
	jmp 	.L_sha224___sha256_finalize$16
.L_sha224___sha256_finalize$17:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r9b, (%r8,%rsi)
	incq	%rsi
.L_sha224___sha256_finalize$16:
	cmpq	%r11, %rsi
	jb  	.L_sha224___sha256_finalize$17
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha224___sha256_finalize$14
.L_sha224___sha256_finalize$15:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r9, (%r8,%rsi)
	addq	$8, %rsi
.L_sha224___sha256_finalize$14:
	movq	%rsi, %r11
	addq	$8, %r11
	cmpq	%rdx, %r11
	jbe 	.L_sha224___sha256_finalize$15
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha224___sha256_finalize$12
.L_sha224___sha256_finalize$13:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r9b, (%r8,%rsi)
	incq	%rsi
.L_sha224___sha256_finalize$12:
	cmpq	%rdx, %rsi
	jb  	.L_sha224___sha256_finalize$13
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	movq	%r10, 8(%rsp)
	movq	%r8, 16(%rsp)
	movq	%rcx, 24(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha224___sha256_finalize$11:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %r10
	movq	16(%rsp), %r8
	movq	24(%rsp), %rcx
	orq 	%rax, %r10
	orq 	%rax, %r8
	orq 	%rax, %rcx
	movq	$0, %rsi
.L_sha224___sha256_finalize$10:
	movq	$56, %rdx
	movq	$0, %r9
	movq	%rsi, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdx
	cmovb	%rdx, %r11
	jmp 	.L_sha224___sha256_finalize$7
.L_sha224___sha256_finalize$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r9b, (%r8,%rsi)
	incq	%rsi
.L_sha224___sha256_finalize$7:
	cmpq	%r11, %rsi
	jb  	.L_sha224___sha256_finalize$8
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha224___sha256_finalize$5
.L_sha224___sha256_finalize$6:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r9, (%r8,%rsi)
	addq	$8, %rsi
.L_sha224___sha256_finalize$5:
	movq	%rsi, %r11
	addq	$8, %r11
	cmpq	%rdx, %r11
	jbe 	.L_sha224___sha256_finalize$6
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha224___sha256_finalize$3
.L_sha224___sha256_finalize$4:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r9b, (%r8,%rsi)
	incq	%rsi
.L_sha224___sha256_finalize$3:
	cmpq	%rdx, %rsi
	jb  	.L_sha224___sha256_finalize$4
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	shlq	$3, %rcx
	bswapq	%rcx
	movq	%rcx, 56(%r8)
	movq	%r10, 24(%rsp)
	movq	%r8, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha224___sha256_finalize$2:
	leaq	568(%rsp), %rsp
	movq	24(%rsp), %r10
	movq	16(%rsp), %r8
	orq 	%rax, %r10
	orq 	%rax, %r8
	movl	(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, (%r10)
	movl	4(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 4(%r10)
	movl	8(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 8(%r10)
	movl	12(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 12(%r10)
	movl	16(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 16(%r10)
	movl	20(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 20(%r10)
	movl	24(%rbp), %ecx
	bswapl	%ecx
	movl	%ecx, 24(%r10)
	ret
.L_sha256_absorb_mem$1:
	movq	%rcx, %r13
	andq	$63, %r13
	addq	%rdx, %rcx
	movq	$64, %r9
	subq	%r13, %r9
	cmpq	%r9, %rdx
	cmovb	%rdx, %r9
	cmpq	$0, %r13
	cmove	%r13, %r9
	subq	%r9, %rdx
	movq	%r13, %r10
	movq	%rsi, %r11
	movq	%r9, %rbx
	movq	%r10, %r14
	negq	%r14
	andq	$7, %r14
	cmpq	%r14, %rbx
	cmovb	%rbx, %r14
	subq	%r14, %rbx
	movq	%r10, %r12
	addq	%r14, %r12
	jmp 	.L_sha256_absorb_mem$18
.L_sha256_absorb_mem$19:
	movq	$-1, %r14
	cmovnb	%r14, %rax
	movzbq	(%r11), %r14
	movb	%r14b, (%r8,%r10)
	incq	%r10
	incq	%r11
.L_sha256_absorb_mem$18:
	cmpq	%r12, %r10
	jb  	.L_sha256_absorb_mem$19
	movq	$-1, %r12
	cmovb	%r12, %rax
	jmp 	.L_sha256_absorb_mem$16
.L_sha256_absorb_mem$17:
	movq	$-1, %r12
	cmovb	%r12, %rax
	movq	(%r11), %r14
	movq	%r14, (%r8,%r10)
	addq	$8, %r10
	addq	$8, %r11
	addq	$-8, %rbx
.L_sha256_absorb_mem$16:
	cmpq	$8, %rbx
	jnb 	.L_sha256_absorb_mem$17
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movq	%r10, %r12
	addq	%rbx, %r12
	jmp 	.L_sha256_absorb_mem$14
.L_sha256_absorb_mem$15:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movzbq	(%r11), %r14
	movb	%r14b, (%r8,%r10)
	incq	%r10
	incq	%r11
.L_sha256_absorb_mem$14:
	cmpq	%r12, %r10
	jb  	.L_sha256_absorb_mem$15
	movq	$-1, %r10
	cmovb	%r10, %rax
	addq	%r9, %r13
	addq	%r9, %rsi
	cmpq	$64, %r13
	je  	.L_sha256_absorb_mem$11
	movq	$-1, %r9
	cmove	%r9, %rax
	jmp 	.L_sha256_absorb_mem$12
.L_sha256_absorb_mem$11:
	movq	$-1, %r9
	cmovne	%r9, %rax
	movq	%rcx, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%r8, 32(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256_absorb_mem$13:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rcx
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdx
	movq	32(%rsp), %r8
	orq 	%rax, %rcx
	orq 	%rax, %rsi
	orq 	%rax, %rdx
	orq 	%rax, %r8
	movq	$0, %r13
.L_sha256_absorb_mem$12:
	movq	$0, %r10
	movq	%rdx, %r9
	shrq	$6, %r9
	cmpq	$0, %r9
	jne 	.L_sha256_absorb_mem$8
	movq	$-1, %r9
	cmovne	%r9, %rax
	jmp 	.L_sha256_absorb_mem$9
.L_sha256_absorb_mem$8:
	movq	$-1, %r10
	cmove	%r10, %rax
	movq	%rcx, 32(%rsp)
	movq	%rsi, 24(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%r8, 8(%rsp)
	leaq	-24(%rsp), %rsp
	call	.L_sha256_compress_blocks$1
.L_sha256_absorb_mem$10:
	leaq	24(%rsp), %rsp
	movq	32(%rsp), %rcx
	movq	24(%rsp), %rsi
	movq	16(%rsp), %rdx
	movq	8(%rsp), %r8
	orq 	%rax, %rcx
	orq 	%rax, %rsi
	orq 	%rax, %rdx
	orq 	%rax, %r8
	movq	%rdx, %r10
	shrq	$6, %r10
	shlq	$6, %r10
	movq	$0, %r13
.L_sha256_absorb_mem$9:
	subq	%r10, %rdx
	addq	%r10, %rsi
	movq	%r13, %r9
	negq	%r9
	andq	$7, %r9
	cmpq	%r9, %rdx
	cmovb	%rdx, %r9
	subq	%r9, %rdx
	movq	%r13, %r11
	addq	%r9, %r11
	jmp 	.L_sha256_absorb_mem$6
.L_sha256_absorb_mem$7:
	movq	$-1, %r9
	cmovnb	%r9, %rax
	movzbq	(%rsi), %r9
	movb	%r9b, (%r8,%r13)
	incq	%r13
	incq	%rsi
.L_sha256_absorb_mem$6:
	cmpq	%r11, %r13
	jb  	.L_sha256_absorb_mem$7
	movq	$-1, %r9
	cmovb	%r9, %rax
	jmp 	.L_sha256_absorb_mem$4
.L_sha256_absorb_mem$5:
	movq	$-1, %r9
	cmovb	%r9, %rax
	movq	(%rsi), %r9
	movq	%r9, (%r8,%r13)
	addq	$8, %r13
	addq	$8, %rsi
	addq	$-8, %rdx
.L_sha256_absorb_mem$4:
	cmpq	$8, %rdx
	jnb 	.L_sha256_absorb_mem$5
	movq	$-1, %r9
	cmovnb	%r9, %rax
	movq	%r13, %r11
	addq	%rdx, %r11
	jmp 	.L_sha256_absorb_mem$2
.L_sha256_absorb_mem$3:
	movq	$-1, %rdx
	cmovnb	%rdx, %rax
	movzbq	(%rsi), %rdx
	movb	%dl, (%r8,%r13)
	incq	%r13
	incq	%rsi
.L_sha256_absorb_mem$2:
	cmpq	%r11, %r13
	jb  	.L_sha256_absorb_mem$3
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	ret
.L_sha256_compress_blocks$1:
	jmp 	.L_sha256_compress_blocks$5
.L_sha256_compress_blocks$6:
	movq	$-1, %rcx
	cmovb	%rcx, %rax
	movq	%rsi, 8(%rsp)
	movq	%r9, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress_two$1
.L_sha256_compress_blocks$7:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rsi
	movq	16(%rsp), %r9
	orq 	%rax, %rsi
	orq 	%rax, %r9
	addq	$128, %rsi
	addq	$-2, %r9
.L_sha256_compress_blocks$5:
	cmpq	$2, %r9
	jnb 	.L_sha256_compress_blocks$6
	movq	$-1, %rcx
	cmovnb	%rcx, %rax
	cmpq	$0, %r9
	jne 	.L_sha256_compress_blocks$2
	movq	$-1, %rcx
	cmovne	%rcx, %rax
	jmp 	.L_sha256_compress_blocks$3
.L_sha256_compress_blocks$2:
	movq	$-1, %rcx
	cmove	%rcx, %rax
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress_one$1
.L_sha256_compress_blocks$4:
	leaq	568(%rsp), %rsp
.L_sha256_compress_blocks$3:
	ret
.L_sha256_compress_two$1:
	leaq	glob_data + 64(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	vbroadcasti128	(%rsi), %ymm2
	vinserti128	$1, 64(%rsi), %ymm2, %ymm2
	vpshufb	%ymm0, %ymm2, %ymm2
	vbroadcasti128	16(%rsi), %ymm3
	vinserti128	$1, 80(%rsi), %ymm3, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vbroadcasti128	32(%rsi), %ymm4
	vinserti128	$1, 96(%rsi), %ymm4, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vbroadcasti128	48(%rsi), %ymm5
	vinserti128	$1, 112(%rsi), %ymm5, %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vbroadcasti128	glob_data + 96(%rip), %ymm0
	vpaddd	%ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm0
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm0
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 128(%rsp)
	leaq	glob_data + 32(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	leaq	glob_data + 0(%rip), %rcx
	vmovdqu	(%rcx), %ymm1
	movl	(%rbp), %ecx
	movl	4(%rbp), %edx
	movl	8(%rbp), %esi
	movl	12(%rbp), %r8d
	movl	16(%rbp), %r9d
	movl	20(%rbp), %r10d
	movl	24(%rbp), %r11d
	movl	28(%rbp), %ebx
	movq	%rbp, 544(%rsp)
	movl	%edx, %r12d
	xorl	%esi, %r12d
	movl	$0, %r14d
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	68(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	72(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	132(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	136(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	196(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	200(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	260(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	264(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	324(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	328(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	388(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	392(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	416(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	420(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	424(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	428(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	448(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	452(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	456(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	460(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	480(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	484(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	488(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	492(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	512(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	516(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	520(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	524(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	%r14d, %ecx
	movq	544(%rsp), %rbp
	orq 	%rax, %rbp
	addl	(%rbp), %ecx
	movl	%ecx, (%rbp)
	addl	4(%rbp), %edx
	movl	%edx, 4(%rbp)
	addl	8(%rbp), %esi
	movl	%esi, 8(%rbp)
	addl	12(%rbp), %r8d
	movl	%r8d, 12(%rbp)
	addl	16(%rbp), %r9d
	movl	%r9d, 16(%rbp)
	addl	20(%rbp), %r10d
	movl	%r10d, 20(%rbp)
	addl	24(%rbp), %r11d
	movl	%r11d, 24(%rbp)
	addl	28(%rbp), %ebx
	movl	%ebx, 28(%rbp)
	movq	%rbp, 544(%rsp)
	movl	%edx, %r12d
	xorl	%esi, %r12d
	movl	$0, %r14d
	addl	48(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	52(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	56(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	60(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	80(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	84(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	88(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	92(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	112(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	116(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	120(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	124(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	144(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	148(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	152(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	156(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	176(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	180(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	184(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	188(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	208(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	212(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	216(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	220(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	240(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	244(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	248(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	252(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	272(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	276(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	280(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	284(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	304(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	308(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	312(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	316(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	336(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	340(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	344(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	348(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	368(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	372(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	376(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	380(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	400(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	404(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	408(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	412(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	432(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	436(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	440(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	444(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	464(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	468(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	472(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	476(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	496(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	500(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	504(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	508(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	528(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	532(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	536(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	540(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	%r14d, %ecx
	movq	544(%rsp), %rbp
	orq 	%rax, %rbp
	addl	(%rbp), %ecx
	movl	%ecx, (%rbp)
	addl	4(%rbp), %edx
	movl	%edx, 4(%rbp)
	addl	8(%rbp), %esi
	movl	%esi, 8(%rbp)
	addl	12(%rbp), %r8d
	movl	%r8d, 12(%rbp)
	addl	16(%rbp), %r9d
	movl	%r9d, 16(%rbp)
	addl	20(%rbp), %r10d
	movl	%r10d, 20(%rbp)
	addl	24(%rbp), %r11d
	movl	%r11d, 24(%rbp)
	addl	28(%rbp), %ebx
	movl	%ebx, 28(%rbp)
	ret
.L_sha256_compress_one$1:
	leaq	glob_data + 64(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	vbroadcasti128	(%rsi), %ymm2
	vpshufb	%ymm0, %ymm2, %ymm2
	vbroadcasti128	16(%rsi), %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vbroadcasti128	32(%rsi), %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vbroadcasti128	48(%rsi), %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vbroadcasti128	glob_data + 96(%rip), %ymm0
	vpaddd	%ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm0
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm0
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 128(%rsp)
	leaq	glob_data + 32(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	leaq	glob_data + 0(%rip), %rcx
	vmovdqu	(%rcx), %ymm1
	movl	(%rbp), %ecx
	movl	4(%rbp), %edx
	movl	8(%rbp), %esi
	movl	12(%rbp), %r8d
	movl	16(%rbp), %r9d
	movl	20(%rbp), %r10d
	movl	24(%rbp), %r11d
	movl	28(%rbp), %ebx
	movq	%rbp, 544(%rsp)
	movl	%edx, %r12d
	xorl	%esi, %r12d
	movl	$0, %r14d
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	68(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	72(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	132(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	136(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	196(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	200(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	260(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	264(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	324(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	328(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	388(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	392(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	416(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	420(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	424(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	428(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	448(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	452(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	456(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	460(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	480(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	484(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	488(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	492(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	512(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	516(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	520(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	524(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	%r14d, %ecx
	movq	544(%rsp), %rbp
	orq 	%rax, %rbp
	addl	(%rbp), %ecx
	movl	%ecx, (%rbp)
	addl	4(%rbp), %edx
	movl	%edx, 4(%rbp)
	addl	8(%rbp), %esi
	movl	%esi, 8(%rbp)
	addl	12(%rbp), %r8d
	movl	%r8d, 12(%rbp)
	addl	16(%rbp), %r9d
	movl	%r9d, 16(%rbp)
	addl	20(%rbp), %r10d
	movl	%r10d, 20(%rbp)
	addl	24(%rbp), %r11d
	movl	%r11d, 24(%rbp)
	addl	28(%rbp), %ebx
	movl	%ebx, 28(%rbp)
	ret
.L_sha256_compress$1:
	leaq	glob_data + 64(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	vbroadcasti128	(%r8), %ymm2
	vpshufb	%ymm0, %ymm2, %ymm2
	vbroadcasti128	16(%r8), %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vbroadcasti128	32(%r8), %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vbroadcasti128	48(%r8), %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vbroadcasti128	glob_data + 96(%rip), %ymm0
	vpaddd	%ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm0
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm0
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 128(%rsp)
	leaq	glob_data + 32(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	leaq	glob_data + 0(%rip), %rcx
	vmovdqu	(%rcx), %ymm1
	movl	(%rbp), %ecx
	movl	4(%rbp), %edx
	movl	8(%rbp), %esi
	movl	12(%rbp), %r8d
	movl	16(%rbp), %r9d
	movl	20(%rbp), %r10d
	movl	24(%rbp), %r11d
	movl	28(%rbp), %ebx
	movq	%rbp, 544(%rsp)
	movl	%edx, %r12d
	xorl	%esi, %r12d
	movl	$0, %r14d
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	68(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	72(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	132(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	136(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	196(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	200(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	260(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	264(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	324(%rsp), %esi
	vpshufd	$250, %ymm2, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	328(%rsp), %edx
	vpshufd	$80, %ymm3, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	388(%rsp), %esi
	vpshufd	$250, %ymm4, %ymm6
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	392(%rsp), %edx
	vpshufd	$80, %ymm5, %ymm6
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	416(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	420(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	424(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	428(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	448(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	452(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	456(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	460(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	480(%rsp), %ebx
	addl	%r14d, %ecx
	movl	%r10d, %r13d
	andl	%r9d, %r13d
	rorx	$25, %r9d, %r15d
	rorx	$11, %r9d, %ebp
	addl	%r13d, %ebx
	andnl	%r11d, %r9d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r9d, %ebp
	addl	%r13d, %ebx
	xorl	%ebp, %r15d
	movl	%ecx, %ebp
	rorx	$22, %ecx, %r13d
	addl	%r15d, %ebx
	xorl	%edx, %ebp
	rorx	$13, %ecx, %r14d
	rorx	$2, %ecx, %r15d
	addl	%ebx, %r8d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%edx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %ebx
	addl	484(%rsp), %r11d
	addl	%r14d, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %r15d
	rorx	$11, %r8d, %r12d
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r8d, %r12d
	addl	%r13d, %r11d
	xorl	%r12d, %r15d
	movl	%ebx, %r12d
	rorx	$22, %ebx, %r13d
	addl	%r15d, %r11d
	xorl	%ecx, %r12d
	rorx	$13, %ebx, %r14d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%ecx, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r11d
	addl	488(%rsp), %r10d
	addl	%r14d, %r11d
	movl	%r8d, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %r15d
	rorx	$11, %esi, %ebp
	addl	%r13d, %r10d
	andnl	%r9d, %esi, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %esi, %ebp
	addl	%r13d, %r10d
	xorl	%ebp, %r15d
	movl	%r11d, %ebp
	rorx	$22, %r11d, %r13d
	addl	%r15d, %r10d
	xorl	%ebx, %ebp
	rorx	$13, %r11d, %r14d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%ebx, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r10d
	addl	492(%rsp), %r9d
	addl	%r14d, %r10d
	movl	%esi, %r13d
	andl	%edx, %r13d
	rorx	$25, %edx, %r15d
	rorx	$11, %edx, %r12d
	addl	%r13d, %r9d
	andnl	%r8d, %edx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %edx, %r12d
	addl	%r13d, %r9d
	xorl	%r12d, %r15d
	movl	%r10d, %r12d
	rorx	$22, %r10d, %r13d
	addl	%r15d, %r9d
	xorl	%r11d, %r12d
	rorx	$13, %r10d, %r14d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ecx
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r11d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %r9d
	addl	512(%rsp), %r8d
	addl	%r14d, %r9d
	movl	%edx, %r13d
	andl	%ecx, %r13d
	rorx	$25, %ecx, %r15d
	rorx	$11, %ecx, %ebp
	addl	%r13d, %r8d
	andnl	%esi, %ecx, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %ecx, %ebp
	addl	%r13d, %r8d
	xorl	%ebp, %r15d
	movl	%r9d, %ebp
	rorx	$22, %r9d, %r13d
	addl	%r15d, %r8d
	xorl	%r10d, %ebp
	rorx	$13, %r9d, %r14d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r10d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %r8d
	addl	516(%rsp), %esi
	addl	%r14d, %r8d
	movl	%ecx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %r15d
	rorx	$11, %ebx, %r12d
	addl	%r13d, %esi
	andnl	%edx, %ebx, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %ebx, %r12d
	addl	%r13d, %esi
	xorl	%r12d, %r15d
	movl	%r8d, %r12d
	rorx	$22, %r8d, %r13d
	addl	%r15d, %esi
	xorl	%r9d, %r12d
	rorx	$13, %r8d, %r14d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%r9d, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %esi
	addl	520(%rsp), %edx
	addl	%r14d, %esi
	movl	%ebx, %r13d
	andl	%r11d, %r13d
	rorx	$25, %r11d, %r15d
	rorx	$11, %r11d, %ebp
	addl	%r13d, %edx
	andnl	%ecx, %r11d, %r13d
	xorl	%ebp, %r15d
	rorx	$6, %r11d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %r15d
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%r15d, %edx
	xorl	%r8d, %ebp
	rorx	$13, %esi, %r14d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%ebp, %r12d
	xorl	%r13d, %r14d
	xorl	%r8d, %r12d
	xorl	%r15d, %r14d
	addl	%r12d, %edx
	addl	524(%rsp), %ecx
	addl	%r14d, %edx
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %r15d
	rorx	$11, %r10d, %r12d
	addl	%r13d, %ecx
	andnl	%ebx, %r10d, %r13d
	xorl	%r12d, %r15d
	rorx	$6, %r10d, %r12d
	addl	%r13d, %ecx
	xorl	%r12d, %r15d
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%r15d, %ecx
	xorl	%esi, %r12d
	rorx	$13, %edx, %r14d
	rorx	$2, %edx, %r15d
	addl	%ecx, %r9d
	andl	%r12d, %ebp
	xorl	%r13d, %r14d
	xorl	%esi, %ebp
	xorl	%r15d, %r14d
	addl	%ebp, %ecx
	addl	%r14d, %ecx
	movq	544(%rsp), %rbp
	orq 	%rax, %rbp
	addl	(%rbp), %ecx
	movl	%ecx, (%rbp)
	addl	4(%rbp), %edx
	movl	%edx, 4(%rbp)
	addl	8(%rbp), %esi
	movl	%esi, 8(%rbp)
	addl	12(%rbp), %r8d
	movl	%r8d, 12(%rbp)
	addl	16(%rbp), %r9d
	movl	%r9d, 16(%rbp)
	addl	20(%rbp), %r10d
	movl	%r10d, 20(%rbp)
	addl	24(%rbp), %r11d
	movl	%r11d, 24(%rbp)
	addl	28(%rbp), %ebx
	movl	%ebx, 28(%rbp)
	ret
	.data
	.p2align	5
glob_data:
G$SHA256_AVX2_HI:
	.byte	255, 255, 255, 255, 255, 255, 255, 255,   0,   1,   2,   3,   8,   9,  10,  11
	.byte	255, 255, 255, 255, 255, 255, 255, 255,   0,   1,   2,   3,   8,   9,  10,  11
G$SHA256_AVX2_LO:
	.byte	  0,   1,   2,   3,   8,   9,  10,  11, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   8,   9,  10,  11, 255, 255, 255, 255, 255, 255, 255, 255
G$SHA256_AVX2_BSWAP:
	.byte	  3,   2,   1,   0,   7,   6,   5,   4,  11,  10,   9,   8,  15,  14,  13,  12
	.byte	  3,   2,   1,   0,   7,   6,   5,   4,  11,  10,   9,   8,  15,  14,  13,  12
G$SHA256_K:
	.byte	152,  47, 138,  66, 145,  68,  55, 113, 207, 251, 192, 181, 165, 219, 181, 233
	.byte	 91, 194,  86,  57, 241,  17, 241,  89, 164, 130,  63, 146, 213,  94,  28, 171
	.byte	152, 170,   7, 216,   1,  91, 131,  18, 190, 133,  49,  36, 195, 125,  12,  85
	.byte	116,  93, 190, 114, 254, 177, 222, 128, 167,   6, 220, 155, 116, 241, 155, 193
	.byte	193, 105, 155, 228, 134,  71, 190, 239, 198, 157, 193,  15, 204, 161,  12,  36
	.byte	111,  44, 233,  45, 170, 132, 116,  74, 220, 169, 176,  92, 218, 136, 249, 118
	.byte	 82,  81,  62, 152, 109, 198,  49, 168, 200,  39,   3, 176, 199, 127,  89, 191
	.byte	243,  11, 224, 198,  71, 145, 167, 213,  81,  99, 202,   6, 103,  41,  41,  20
	.byte	133,  10, 183,  39,  56,  33,  27,  46, 252, 109,  44,  77,  19,  13,  56,  83
	.byte	 84, 115,  10, 101, 187,  10, 106, 118,  46, 201, 194, 129, 133,  44, 114, 146
	.byte	161, 232, 191, 162,  75, 102,  26, 168, 112, 139,  75, 194, 163,  81, 108, 199
	.byte	 25, 232, 146, 209,  36,   6, 153, 214, 133,  53,  14, 244, 112, 160, 106,  16
	.byte	 22, 193, 164,  25,   8, 108,  55,  30,  76, 119,  72,  39, 181, 188, 176,  52
	.byte	179,  12,  28,  57,  74, 170, 216,  78,  79, 202, 156,  91, 243, 111,  46, 104
	.byte	238, 130, 143, 116, 111,  99, 165, 120,  20, 120, 200, 132,   8,   2, 199, 140
	.byte	250, 255, 190, 144, 235, 108,  80, 164, 247, 163, 249, 190, 242, 120, 113, 198
G$SHA224_IV:
	.byte	216, 158,   5, 193,   7, 213, 124,  54,  23, 221, 112,  48,  57,  89,  14, 247
	.byte	 49,  11, 192, 255,  17,  21,  88, 104, 167, 143, 249, 100, 164,  79, 250, 190
G$SHA512_256_IV:
	.byte	 44, 247,  43, 252, 148,  33,  49,  34, 194, 100,  76, 200, 163,  95,  85, 159
	.byte	 81, 177,  83, 111, 107, 184, 147,  35, 189, 234,  64,  89,  25, 119,  56, 150
	.byte	227, 255, 142, 168, 226,  62,  40, 150, 146,  57, 134,  83,  37,  30,  94, 190
	.byte	170, 184, 133,  44, 252, 153,   1,  43, 162,  44, 197, 129, 220,  45, 183,  14
G$SHA512_224_IV:
	.byte	162,  77,  84,  25, 200,  55,  61, 140, 214, 212, 220, 137, 102, 153, 225, 115
	.byte	130, 156, 255,  50, 174, 183, 250,  29, 207, 159,  47,  88,  20, 213, 157, 103
	.byte	168,  77, 212, 123, 105,  43, 109,  15,  66, 137, 196,   4, 115, 111, 227, 119
	.byte	200,  54,  29, 106, 168, 133, 157,  63, 161, 146, 214, 145, 173, 230,  18,  17
G$SHA384_IV:
	.byte	216, 158,   5, 193,  93, 157, 187, 203,   7, 213, 124,  54,  42,  41, 154,  98
	.byte	 23, 221, 112,  48,  90,   1,  89, 145,  57,  89,  14, 247, 216, 236,  47,  21
	.byte	 49,  11, 192, 255, 103,  38,  51, 103,  17,  21,  88, 104, 135,  74, 180, 142
	.byte	167, 143, 249, 100,  13,  46,  12, 219, 164,  79, 250, 190,  29,  72, 181,  71
G$SHA512_IV:
	.byte	  8, 201, 188, 243, 103, 230,   9, 106,  59, 167, 202, 132, 133, 174, 103, 187
	.byte	 43, 248, 148, 254, 114, 243, 110,  60, 241,  54,  29,  95,  58, 245,  79, 165
	.byte	209, 130, 230, 173, 127,  82,  14,  81,  31, 108,  62,  43, 140, 104,   5, 155
	.byte	107, 189,  65, 251, 171, 217, 131,  31, 121,  33, 126,  19,  25, 205, 224,  91
G$SHA512_AVX2_BSWAP:
	.byte	  7,   6,   5,   4,   3,   2,   1,   0,  15,  14,  13,  12,  11,  10,   9,   8
	.byte	  7,   6,   5,   4,   3,   2,   1,   0,  15,  14,  13,  12,  11,  10,   9,   8
G$SHA512_K:
	.byte	 34, 174,  40, 215, 152,  47, 138,  66, 205, 101, 239,  35, 145,  68,  55, 113
	.byte	 47,  59,  77, 236, 207, 251, 192, 181, 188, 219, 137, 129, 165, 219, 181, 233
	.byte	 56, 181,  72, 243,  91, 194,  86,  57,  25, 208,   5, 182, 241,  17, 241,  89
	.byte	155,  79,  25, 175, 164, 130,  63, 146,  24, 129, 109, 218, 213,  94,  28, 171
	.byte	 66,   2,   3, 163, 152, 170,   7, 216, 190, 111, 112,  69,   1,  91, 131,  18
	.byte	140, 178, 228,  78, 190, 133,  49,  36, 226, 180, 255, 213, 195, 125,  12,  85
	.byte	111, 137, 123, 242, 116,  93, 190, 114, 177, 150,  22,  59, 254, 177, 222, 128
	.byte	 53,  18, 199,  37, 167,   6, 220, 155, 148,  38, 105, 207, 116, 241, 155, 193
	.byte	210,  74, 241, 158, 193, 105, 155, 228, 227,  37,  79,  56, 134,  71, 190, 239
	.byte	181, 213, 140, 139, 198, 157, 193,  15, 101, 156, 172, 119, 204, 161,  12,  36
	.byte	117,   2,  43,  89, 111,  44, 233,  45, 131, 228, 166, 110, 170, 132, 116,  74
	.byte	212, 251,  65, 189, 220, 169, 176,  92, 181,  83,  17, 131, 218, 136, 249, 118
	.byte	171, 223, 102, 238,  82,  81,  62, 152,  16,  50, 180,  45, 109, 198,  49, 168
	.byte	 63,  33, 251, 152, 200,  39,   3, 176, 228,  14, 239, 190, 199, 127,  89, 191
	.byte	194, 143, 168,  61, 243,  11, 224, 198,  37, 167,  10, 147,  71, 145, 167, 213
	.byte	111, 130,   3, 224,  81,  99, 202,   6, 112, 110,  14,  10, 103,  41,  41,  20
	.byte	252,  47, 210,  70, 133,  10, 183,  39,  38, 201,  38,  92,  56,  33,  27,  46
	.byte	237,  42, 196,  90, 252, 109,  44,  77, 223, 179, 149, 157,  19,  13,  56,  83
	.byte	222,  99, 175, 139,  84, 115,  10, 101, 168, 178, 119,  60, 187,  10, 106, 118
	.byte	230, 174, 237,  71,  46, 201, 194, 129,  59,  53, 130,  20, 133,  44, 114, 146
	.byte	100,   3, 241,  76, 161, 232, 191, 162,   1,  48,  66, 188,  75, 102,  26, 168
	.byte	145, 151, 248, 208, 112, 139,  75, 194,  48, 190,  84,   6, 163,  81, 108, 199
	.byte	 24,  82, 239, 214,  25, 232, 146, 209,  16, 169, 101,  85,  36,   6, 153, 214
	.byte	 42,  32, 113,  87, 133,  53,  14, 244, 184, 209, 187,  50, 112, 160, 106,  16
	.byte	200, 208, 210, 184,  22, 193, 164,  25,  83, 171,  65,  81,   8, 108,  55,  30
	.byte	153, 235, 142, 223,  76, 119,  72,  39, 168,  72, 155, 225, 181, 188, 176,  52
	.byte	 99,  90, 201, 197, 179,  12,  28,  57, 203, 138,  65, 227,  74, 170, 216,  78
	.byte	115, 227,  99, 119,  79, 202, 156,  91, 163, 184, 178, 214, 243, 111,  46, 104
	.byte	252, 178, 239,  93, 238, 130, 143, 116,  96,  47,  23,  67, 111,  99, 165, 120
	.byte	114, 171, 240, 161,  20, 120, 200, 132, 236,  57, 100,  26,   8,   2, 199, 140
	.byte	 40,  30,  99,  35, 250, 255, 190, 144, 233, 189, 130, 222, 235, 108,  80, 164
	.byte	 21, 121, 198, 178, 247, 163, 249, 190,  43,  83, 114, 227, 242, 120, 113, 198
	.byte	156,  97,  38, 234, 206,  62,  39, 202,   7, 194, 192,  33, 199, 184, 134, 209
	.byte	 30, 235, 224, 205, 214, 125, 218, 234, 120, 209, 110, 238, 127,  79, 125, 245
	.byte	186, 111,  23, 114, 170, 103, 240,   6, 166, 152, 200, 162, 197, 125,  99,  10
	.byte	174,  13, 249, 190,   4, 152,  63,  17,  27,  71,  28,  19,  53,  11, 113,  27
	.byte	132, 125,   4,  35, 245, 119, 219,  40, 147,  36, 199,  64, 123, 171, 202,  50
	.byte	188, 190, 201,  21,  10, 190, 158,  60,  76,  13,  16, 156, 196, 103,  29,  67
	.byte	182,  66,  62, 203, 190, 212, 197,  76,  42, 126, 101, 252, 156,  41, 127,  89
	.byte	236, 250, 214,  58, 171, 111, 203,  95,  23,  88,  71,  74, 140,  25,  68, 108
G$SHA256_IV:
	.byte	103, 230,   9, 106, 133, 174, 103, 187, 114, 243, 110,  60,  58, 245,  79, 165
	.byte	127,  82,  14,  81, 140, 104,   5, 155, 171, 217, 131,  31,  25, 205, 224,  91
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
