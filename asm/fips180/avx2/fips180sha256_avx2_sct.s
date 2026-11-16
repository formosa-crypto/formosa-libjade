	.att_syntax
	.text
	.p2align	5
	.global	jade_hash_sha256_amd64_avx2
	.type	jade_hash_sha256_amd64_avx2, %function
jade_hash_sha256_amd64_avx2:
	movq	%rsp, %rax
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%rax, 40(%rsp)
	movq	%rsi, %r11
	movq	%rdx, %rbx
	lfence
	movq	$0, %rax
	leaq	-120(%rsp), %rsp
	call	.L_sha256_mem$1
.Ljade_hash_sha256_amd64_avx2$1:
	leaq	120(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$864, %rsp
	movq	$864, %rdi
.Ljade_hash_sha256_amd64_avx2$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha256_amd64_avx2$2
	movq	%rsi, %rsp
	ret
.L_sha256_mem$1:
	leaq	88(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %esi
	movl	%esi, (%rcx)
	movl	4(%rdx), %esi
	movl	%esi, 4(%rcx)
	movl	8(%rdx), %esi
	movl	%esi, 8(%rcx)
	movl	12(%rdx), %esi
	movl	%esi, 12(%rcx)
	movl	16(%rdx), %esi
	movl	%esi, 16(%rcx)
	movl	20(%rdx), %esi
	movl	%esi, 20(%rcx)
	movl	24(%rdx), %esi
	movl	%esi, 24(%rcx)
	movl	28(%rdx), %esi
	movl	%esi, 28(%rcx)
	leaq	88(%rsp), %rcx
	leaq	16(%rsp), %rsi
	movq	$0, %rdx
	movq	%rdi, 80(%rsp)
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_sha256_mem$3:
	leaq	56(%rsp), %rsp
	movq	80(%rsp), %r8
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.L_sha256_mem$2:
	leaq	24(%rsp), %rsp
	ret
.L_sha256___sha256_finalize$1:
	movq	%rdx, %r9
	andq	$63, %r9
	movq	$128, %rdi
	movb	%dil, (%rsi,%r9)
	incq	%r9
	cmpq	$56, %r9
	jnbe	.L_sha256___sha256_finalize$9
	movq	$-1, %rdi
	cmovnbe	%rdi, %rax
	jmp 	.L_sha256___sha256_finalize$10
.L_sha256___sha256_finalize$9:
	movq	$-1, %rdi
	cmovbe	%rdi, %rax
	movq	$64, %rdi
	movq	$0, %r10
	movq	%r9, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdi
	cmovb	%rdi, %r11
	jmp 	.L_sha256___sha256_finalize$16
.L_sha256___sha256_finalize$17:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha256___sha256_finalize$16:
	cmpq	%r11, %r9
	jb  	.L_sha256___sha256_finalize$17
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$14
.L_sha256___sha256_finalize$15:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r10, (%rsi,%r9)
	addq	$8, %r9
.L_sha256___sha256_finalize$14:
	movq	%r9, %r11
	addq	$8, %r11
	cmpq	%rdi, %r11
	jbe 	.L_sha256___sha256_finalize$15
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$12
.L_sha256___sha256_finalize$13:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha256___sha256_finalize$12:
	cmpq	%rdi, %r9
	jb  	.L_sha256___sha256_finalize$13
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	%r8, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256___sha256_finalize$11:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %r8
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdx
	orq 	%rax, %r8
	orq 	%rax, %rsi
	orq 	%rax, %rdx
	movq	$0, %r9
.L_sha256___sha256_finalize$10:
	movq	$56, %rdi
	movq	$0, %r10
	movq	%r9, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdi
	cmovb	%rdi, %r11
	jmp 	.L_sha256___sha256_finalize$7
.L_sha256___sha256_finalize$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha256___sha256_finalize$7:
	cmpq	%r11, %r9
	jb  	.L_sha256___sha256_finalize$8
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$5
.L_sha256___sha256_finalize$6:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r10, (%rsi,%r9)
	addq	$8, %r9
.L_sha256___sha256_finalize$5:
	movq	%r9, %r11
	addq	$8, %r11
	cmpq	%rdi, %r11
	jbe 	.L_sha256___sha256_finalize$6
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$3
.L_sha256___sha256_finalize$4:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha256___sha256_finalize$3:
	cmpq	%rdi, %r9
	jb  	.L_sha256___sha256_finalize$4
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	shlq	$3, %rdx
	bswapq	%rdx
	movq	%rdx, 56(%rsi)
	movq	%r8, 24(%rsp)
	movq	%rsi, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256___sha256_finalize$2:
	leaq	568(%rsp), %rsp
	movq	24(%rsp), %rdi
	movq	16(%rsp), %rsi
	orq 	%rax, %rdi
	orq 	%rax, %rsi
	movl	(%rcx), %edx
	bswapl	%edx
	movl	%edx, (%rdi)
	movl	4(%rcx), %edx
	bswapl	%edx
	movl	%edx, 4(%rdi)
	movl	8(%rcx), %edx
	bswapl	%edx
	movl	%edx, 8(%rdi)
	movl	12(%rcx), %edx
	bswapl	%edx
	movl	%edx, 12(%rdi)
	movl	16(%rcx), %edx
	bswapl	%edx
	movl	%edx, 16(%rdi)
	movl	20(%rcx), %edx
	bswapl	%edx
	movl	%edx, 20(%rdi)
	movl	24(%rcx), %edx
	bswapl	%edx
	movl	%edx, 24(%rdi)
	movl	28(%rcx), %edx
	bswapl	%edx
	movl	%edx, 28(%rdi)
	ret
.L_sha256_absorb_mem$1:
	movq	%rdx, %rbp
	andq	$63, %rbp
	addq	%rbx, %rdx
	movq	$64, %rdi
	subq	%rbp, %rdi
	cmpq	%rdi, %rbx
	cmovb	%rbx, %rdi
	cmpq	$0, %rbp
	cmove	%rbp, %rdi
	subq	%rdi, %rbx
	movq	%rbp, %r8
	movq	%r11, %r9
	movq	%rdi, %r10
	movq	%r8, %r12
	negq	%r12
	andq	$7, %r12
	cmpq	%r12, %r10
	cmovb	%r10, %r12
	subq	%r12, %r10
	movq	%r8, %r13
	addq	%r12, %r13
	jmp 	.L_sha256_absorb_mem$18
.L_sha256_absorb_mem$19:
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movzbq	(%r9), %r12
	movb	%r12b, (%rsi,%r8)
	incq	%r8
	incq	%r9
.L_sha256_absorb_mem$18:
	cmpq	%r13, %r8
	jb  	.L_sha256_absorb_mem$19
	movq	$-1, %r12
	cmovb	%r12, %rax
	jmp 	.L_sha256_absorb_mem$16
.L_sha256_absorb_mem$17:
	movq	$-1, %r12
	cmovb	%r12, %rax
	movq	(%r9), %r12
	movq	%r12, (%rsi,%r8)
	addq	$8, %r8
	addq	$8, %r9
	addq	$-8, %r10
.L_sha256_absorb_mem$16:
	cmpq	$8, %r10
	jnb 	.L_sha256_absorb_mem$17
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movq	%r8, %r13
	addq	%r10, %r13
	jmp 	.L_sha256_absorb_mem$14
.L_sha256_absorb_mem$15:
	movq	$-1, %r10
	cmovnb	%r10, %rax
	movzbq	(%r9), %r10
	movb	%r10b, (%rsi,%r8)
	incq	%r8
	incq	%r9
.L_sha256_absorb_mem$14:
	cmpq	%r13, %r8
	jb  	.L_sha256_absorb_mem$15
	movq	$-1, %r8
	cmovb	%r8, %rax
	addq	%rdi, %rbp
	addq	%rdi, %r11
	cmpq	$64, %rbp
	je  	.L_sha256_absorb_mem$11
	movq	$-1, %rdi
	cmove	%rdi, %rax
	jmp 	.L_sha256_absorb_mem$12
.L_sha256_absorb_mem$11:
	movq	$-1, %rdi
	cmovne	%rdi, %rax
	movq	%rdx, 8(%rsp)
	movq	%r11, 16(%rsp)
	movq	%rbx, 24(%rsp)
	movq	%rsi, 32(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256_absorb_mem$13:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rdx
	movq	16(%rsp), %r11
	movq	24(%rsp), %rbx
	movq	32(%rsp), %rsi
	orq 	%rax, %rdx
	orq 	%rax, %r11
	orq 	%rax, %rbx
	orq 	%rax, %rsi
	movq	$0, %rbp
.L_sha256_absorb_mem$12:
	movq	$0, %r8
	movq	%rbx, %rdi
	shrq	$6, %rdi
	cmpq	$0, %rdi
	jne 	.L_sha256_absorb_mem$8
	movq	$-1, %rdi
	cmovne	%rdi, %rax
	jmp 	.L_sha256_absorb_mem$9
.L_sha256_absorb_mem$8:
	movq	$-1, %r8
	cmove	%r8, %rax
	movq	%rdx, 32(%rsp)
	movq	%r11, 24(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	-24(%rsp), %rsp
	call	.L_sha256_compress_blocks$1
.L_sha256_absorb_mem$10:
	leaq	24(%rsp), %rsp
	movq	32(%rsp), %rdx
	movq	24(%rsp), %r11
	movq	16(%rsp), %rbx
	movq	8(%rsp), %rsi
	orq 	%rax, %rdx
	orq 	%rax, %r11
	orq 	%rax, %rbx
	orq 	%rax, %rsi
	movq	%rbx, %r8
	shrq	$6, %r8
	shlq	$6, %r8
	movq	$0, %rbp
.L_sha256_absorb_mem$9:
	subq	%r8, %rbx
	addq	%r8, %r11
	movq	%rbp, %rdi
	negq	%rdi
	andq	$7, %rdi
	cmpq	%rdi, %rbx
	cmovb	%rbx, %rdi
	subq	%rdi, %rbx
	movq	%rbp, %r8
	addq	%rdi, %r8
	jmp 	.L_sha256_absorb_mem$6
.L_sha256_absorb_mem$7:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%r11), %rdi
	movb	%dil, (%rsi,%rbp)
	incq	%rbp
	incq	%r11
.L_sha256_absorb_mem$6:
	cmpq	%r8, %rbp
	jb  	.L_sha256_absorb_mem$7
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	jmp 	.L_sha256_absorb_mem$4
.L_sha256_absorb_mem$5:
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	(%r11), %rdi
	movq	%rdi, (%rsi,%rbp)
	addq	$8, %rbp
	addq	$8, %r11
	addq	$-8, %rbx
.L_sha256_absorb_mem$4:
	cmpq	$8, %rbx
	jnb 	.L_sha256_absorb_mem$5
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movq	%rbp, %r8
	addq	%rbx, %r8
	jmp 	.L_sha256_absorb_mem$2
.L_sha256_absorb_mem$3:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%r11), %rdi
	movb	%dil, (%rsi,%rbp)
	incq	%rbp
	incq	%r11
.L_sha256_absorb_mem$2:
	cmpq	%r8, %rbp
	jb  	.L_sha256_absorb_mem$3
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	ret
.L_sha256_compress_blocks$1:
	jmp 	.L_sha256_compress_blocks$5
.L_sha256_compress_blocks$6:
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	movq	%r11, 8(%rsp)
	movq	%rdi, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress_two$1
.L_sha256_compress_blocks$7:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %r11
	movq	16(%rsp), %rdi
	orq 	%rax, %r11
	orq 	%rax, %rdi
	addq	$128, %r11
	addq	$-2, %rdi
.L_sha256_compress_blocks$5:
	cmpq	$2, %rdi
	jnb 	.L_sha256_compress_blocks$6
	movq	$-1, %rdx
	cmovnb	%rdx, %rax
	cmpq	$0, %rdi
	jne 	.L_sha256_compress_blocks$2
	movq	$-1, %rdx
	cmovne	%rdx, %rax
	jmp 	.L_sha256_compress_blocks$3
.L_sha256_compress_blocks$2:
	movq	$-1, %rdx
	cmove	%rdx, %rax
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress_one$1
.L_sha256_compress_blocks$4:
	leaq	568(%rsp), %rsp
.L_sha256_compress_blocks$3:
	ret
.L_sha256_compress_two$1:
	leaq	glob_data + 64(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	vbroadcasti128	(%r11), %ymm2
	vinserti128	$1, 64(%r11), %ymm2, %ymm2
	vpshufb	%ymm0, %ymm2, %ymm2
	vbroadcasti128	16(%r11), %ymm3
	vinserti128	$1, 80(%r11), %ymm3, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vbroadcasti128	32(%r11), %ymm4
	vinserti128	$1, 96(%r11), %ymm4, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vbroadcasti128	48(%r11), %ymm5
	vinserti128	$1, 112(%r11), %ymm5, %ymm5
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
	leaq	glob_data + 32(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	movl	(%rcx), %edx
	movl	4(%rcx), %esi
	movl	8(%rcx), %edi
	movl	12(%rcx), %r8d
	movl	16(%rcx), %r9d
	movl	20(%rcx), %r10d
	movl	24(%rcx), %r11d
	movl	28(%rcx), %ebx
	movq	%rcx, 544(%rsp)
	movl	%esi, %ecx
	xorl	%edi, %ecx
	movl	$0, %ebp
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ebp, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ebp
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ebp
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ebp
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ebp, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r13d, %ebp
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ecx
	xorl	%r14d, %ebp
	addl	%ecx, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ebp, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	68(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	132(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	196(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	260(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	324(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	388(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	416(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	420(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	424(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	428(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	448(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	452(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	456(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	460(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	480(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	484(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	488(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	492(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	512(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	516(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	520(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	524(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	%ecx, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %edi
	movl	%edi, 8(%rcx)
	addl	12(%rcx), %r8d
	movl	%r8d, 12(%rcx)
	addl	16(%rcx), %r9d
	movl	%r9d, 16(%rcx)
	addl	20(%rcx), %r10d
	movl	%r10d, 20(%rcx)
	addl	24(%rcx), %r11d
	movl	%r11d, 24(%rcx)
	addl	28(%rcx), %ebx
	movl	%ebx, 28(%rcx)
	movq	%rcx, 544(%rsp)
	movl	%esi, %ecx
	xorl	%edi, %ecx
	movl	$0, %ebp
	addl	48(%rsp), %ebx
	addl	%ebp, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ebp
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ebp
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ebp
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ebp, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ebp
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r13d, %ebp
	xorl	%esi, %ecx
	xorl	%r14d, %ebp
	addl	%ecx, %ebx
	addl	52(%rsp), %r11d
	addl	%ebp, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	56(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	60(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	80(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	84(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	88(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	92(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	112(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	116(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	120(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	124(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	144(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	148(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	152(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	156(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	176(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	180(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	184(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	188(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	208(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	212(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	216(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	220(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	240(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	244(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	248(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	252(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	272(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	276(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	280(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	284(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	304(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	308(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	312(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	316(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	336(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	340(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	344(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	348(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	368(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	372(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	376(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	380(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	400(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	404(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	408(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	412(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	432(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	436(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	440(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	444(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	464(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	468(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	472(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	476(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	496(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	500(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	504(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	508(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	528(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	532(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	536(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	540(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	%ecx, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %edi
	movl	%edi, 8(%rcx)
	addl	12(%rcx), %r8d
	movl	%r8d, 12(%rcx)
	addl	16(%rcx), %r9d
	movl	%r9d, 16(%rcx)
	addl	20(%rcx), %r10d
	movl	%r10d, 20(%rcx)
	addl	24(%rcx), %r11d
	movl	%r11d, 24(%rcx)
	addl	28(%rcx), %ebx
	movl	%ebx, 28(%rcx)
	ret
.L_sha256_compress_one$1:
	leaq	glob_data + 64(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	vbroadcasti128	(%r11), %ymm2
	vpshufb	%ymm0, %ymm2, %ymm2
	vbroadcasti128	16(%r11), %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vbroadcasti128	32(%r11), %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vbroadcasti128	48(%r11), %ymm5
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
	leaq	glob_data + 32(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	movl	(%rcx), %edx
	movl	4(%rcx), %esi
	movl	8(%rcx), %edi
	movl	12(%rcx), %r8d
	movl	16(%rcx), %r9d
	movl	20(%rcx), %r10d
	movl	24(%rcx), %r11d
	movl	28(%rcx), %ebx
	movq	%rcx, 544(%rsp)
	movl	%esi, %ecx
	xorl	%edi, %ecx
	movl	$0, %ebp
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ebp, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ebp
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ebp
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ebp
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ebp, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r13d, %ebp
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ecx
	xorl	%r14d, %ebp
	addl	%ecx, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ebp, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	68(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	132(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	196(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	260(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	324(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	388(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	416(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	420(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	424(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	428(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	448(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	452(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	456(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	460(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	480(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	484(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	488(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	492(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	512(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	516(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	520(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	524(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	%ecx, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %edi
	movl	%edi, 8(%rcx)
	addl	12(%rcx), %r8d
	movl	%r8d, 12(%rcx)
	addl	16(%rcx), %r9d
	movl	%r9d, 16(%rcx)
	addl	20(%rcx), %r10d
	movl	%r10d, 20(%rcx)
	addl	24(%rcx), %r11d
	movl	%r11d, 24(%rcx)
	addl	28(%rcx), %ebx
	movl	%ebx, 28(%rcx)
	ret
.L_sha256_compress$1:
	leaq	glob_data + 64(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
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
	leaq	glob_data + 32(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	movl	(%rcx), %edx
	movl	4(%rcx), %esi
	movl	8(%rcx), %edi
	movl	12(%rcx), %r8d
	movl	16(%rcx), %r9d
	movl	20(%rcx), %r10d
	movl	24(%rcx), %r11d
	movl	28(%rcx), %ebx
	movq	%rcx, 544(%rsp)
	movl	%esi, %ecx
	xorl	%edi, %ecx
	movl	$0, %ebp
	addl	32(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ebp, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ebp
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ebp
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ebp
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ebp, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ebp
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r13d, %ebp
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ecx
	xorl	%r14d, %ebp
	addl	%ecx, %ebx
	addl	36(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ebp, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	40(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	64(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	68(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	96(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	100(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	104(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	128(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	132(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	160(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	164(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	168(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	192(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	196(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	224(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	228(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	232(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	256(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	260(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	288(%rsp), %ebx
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	292(%rsp), %r11d
	vpshufd	$250, %ymm5, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	296(%rsp), %r10d
	vpshufd	$80, %ymm2, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	320(%rsp), %r8d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	324(%rsp), %edi
	vpshufd	$250, %ymm2, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	352(%rsp), %ebx
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	356(%rsp), %r11d
	vpshufd	$250, %ymm3, %ymm6
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	360(%rsp), %r10d
	vpshufd	$80, %ymm4, %ymm6
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	384(%rsp), %r8d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	388(%rsp), %edi
	vpshufd	$250, %ymm4, %ymm6
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	416(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	420(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	424(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	428(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	448(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	452(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	456(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	460(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	480(%rsp), %ebx
	addl	%ecx, %edx
	movl	%r10d, %r12d
	andl	%r9d, %r12d
	rorx	$25, %r9d, %ecx
	rorx	$11, %r9d, %r13d
	addl	%r12d, %ebx
	andnl	%r11d, %r9d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r9d, %r13d
	addl	%r12d, %ebx
	xorl	%r13d, %ecx
	movl	%edx, %r12d
	rorx	$22, %edx, %r13d
	addl	%ecx, %ebx
	xorl	%esi, %r12d
	rorx	$13, %edx, %ecx
	rorx	$2, %edx, %r14d
	addl	%ebx, %r8d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%esi, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %ebx
	addl	484(%rsp), %r11d
	addl	%ecx, %ebx
	movl	%r9d, %r13d
	andl	%r8d, %r13d
	rorx	$25, %r8d, %ecx
	rorx	$11, %r8d, %ebp
	addl	%r13d, %r11d
	andnl	%r10d, %r8d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r8d, %ebp
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	movl	%ebx, %ebp
	rorx	$22, %ebx, %r13d
	addl	%ecx, %r11d
	xorl	%edx, %ebp
	rorx	$13, %ebx, %ecx
	rorx	$2, %ebx, %r14d
	addl	%r11d, %edi
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edx, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r11d
	addl	488(%rsp), %r10d
	addl	%ecx, %r11d
	movl	%r8d, %r12d
	andl	%edi, %r12d
	rorx	$25, %edi, %ecx
	rorx	$11, %edi, %r13d
	addl	%r12d, %r10d
	andnl	%r9d, %edi, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edi, %r13d
	addl	%r12d, %r10d
	xorl	%r13d, %ecx
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r13d
	addl	%ecx, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %ecx
	rorx	$2, %r11d, %r14d
	addl	%r10d, %esi
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%ebx, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r10d
	addl	492(%rsp), %r9d
	addl	%ecx, %r10d
	movl	%edi, %r13d
	andl	%esi, %r13d
	rorx	$25, %esi, %ecx
	rorx	$11, %esi, %ebp
	addl	%r13d, %r9d
	andnl	%r8d, %esi, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %esi, %ebp
	addl	%r13d, %r9d
	xorl	%ebp, %ecx
	movl	%r10d, %ebp
	rorx	$22, %r10d, %r13d
	addl	%ecx, %r9d
	xorl	%r11d, %ebp
	rorx	$13, %r10d, %ecx
	rorx	$2, %r10d, %r14d
	addl	%r9d, %edx
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r11d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %r9d
	addl	512(%rsp), %r8d
	addl	%ecx, %r9d
	movl	%esi, %r12d
	andl	%edx, %r12d
	rorx	$25, %edx, %ecx
	rorx	$11, %edx, %r13d
	addl	%r12d, %r8d
	andnl	%edi, %edx, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %edx, %r13d
	addl	%r12d, %r8d
	xorl	%r13d, %ecx
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r13d
	addl	%ecx, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %ecx
	rorx	$2, %r9d, %r14d
	addl	%r8d, %ebx
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r10d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %r8d
	addl	516(%rsp), %edi
	addl	%ecx, %r8d
	movl	%edx, %r13d
	andl	%ebx, %r13d
	rorx	$25, %ebx, %ecx
	rorx	$11, %ebx, %ebp
	addl	%r13d, %edi
	andnl	%esi, %ebx, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %ebx, %ebp
	addl	%r13d, %edi
	xorl	%ebp, %ecx
	movl	%r8d, %ebp
	rorx	$22, %r8d, %r13d
	addl	%ecx, %edi
	xorl	%r9d, %ebp
	rorx	$13, %r8d, %ecx
	rorx	$2, %r8d, %r14d
	addl	%edi, %r11d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%r9d, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edi
	addl	520(%rsp), %esi
	addl	%ecx, %edi
	movl	%ebx, %r12d
	andl	%r11d, %r12d
	rorx	$25, %r11d, %ecx
	rorx	$11, %r11d, %r13d
	addl	%r12d, %esi
	andnl	%edx, %r11d, %r12d
	xorl	%r13d, %ecx
	rorx	$6, %r11d, %r13d
	addl	%r12d, %esi
	xorl	%r13d, %ecx
	movl	%edi, %r12d
	rorx	$22, %edi, %r13d
	addl	%ecx, %esi
	xorl	%r8d, %r12d
	rorx	$13, %edi, %ecx
	rorx	$2, %edi, %r14d
	addl	%esi, %r10d
	andl	%r12d, %ebp
	xorl	%r13d, %ecx
	xorl	%r8d, %ebp
	xorl	%r14d, %ecx
	addl	%ebp, %esi
	addl	524(%rsp), %edx
	addl	%ecx, %esi
	movl	%r11d, %r13d
	andl	%r10d, %r13d
	rorx	$25, %r10d, %ecx
	rorx	$11, %r10d, %ebp
	addl	%r13d, %edx
	andnl	%ebx, %r10d, %r13d
	xorl	%ebp, %ecx
	rorx	$6, %r10d, %ebp
	addl	%r13d, %edx
	xorl	%ebp, %ecx
	movl	%esi, %ebp
	rorx	$22, %esi, %r13d
	addl	%ecx, %edx
	xorl	%edi, %ebp
	rorx	$13, %esi, %ecx
	rorx	$2, %esi, %r14d
	addl	%edx, %r9d
	andl	%ebp, %r12d
	xorl	%r13d, %ecx
	xorl	%edi, %r12d
	xorl	%r14d, %ecx
	addl	%r12d, %edx
	addl	%ecx, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %edi
	movl	%edi, 8(%rcx)
	addl	12(%rcx), %r8d
	movl	%r8d, 12(%rcx)
	addl	16(%rcx), %r9d
	movl	%r9d, 16(%rcx)
	addl	20(%rcx), %r10d
	movl	%r10d, 20(%rcx)
	addl	24(%rcx), %r11d
	movl	%r11d, 24(%rcx)
	addl	28(%rcx), %ebx
	movl	%ebx, 28(%rcx)
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
G$SHA256_IV:
	.byte	103, 230,   9, 106, 133, 174, 103, 187, 114, 243, 110,  60,  58, 245,  79, 165
	.byte	127,  82,  14,  81, 140, 104,   5, 155, 171, 217, 131,  31,  25, 205, 224,  91
G$SHA224_IV:
	.byte	216, 158,   5, 193,   7, 213, 124,  54,  23, 221, 112,  48,  57,  89,  14, 247
	.byte	 49,  11, 192, 255,  17,  21,  88, 104, 167, 143, 249, 100, 164,  79, 250, 190
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
