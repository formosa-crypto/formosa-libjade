	.att_syntax
	.text
	.p2align	5
	.global	jade_hash_sha512_amd64_avx2
	.type	jade_hash_sha512_amd64_avx2, %function
jade_hash_sha512_amd64_avx2:
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
	leaq	-216(%rsp), %rsp
	call	.L_sha512_mem$1
.Ljade_hash_sha512_amd64_avx2$1:
	leaq	216(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$1728, %rsp
	movq	$1728, %rdi
.Ljade_hash_sha512_amd64_avx2$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha512_amd64_avx2$2
	movq	%rsi, %rsp
	ret
.L_sha512_mem$1:
	leaq	152(%rsp), %rcx
	leaq	glob_data + 672(%rip), %rdx
	movq	(%rdx), %rsi
	movq	%rsi, (%rcx)
	movq	8(%rdx), %rsi
	movq	%rsi, 8(%rcx)
	movq	16(%rdx), %rsi
	movq	%rsi, 16(%rcx)
	movq	24(%rdx), %rsi
	movq	%rsi, 24(%rcx)
	movq	32(%rdx), %rsi
	movq	%rsi, 32(%rcx)
	movq	40(%rdx), %rsi
	movq	%rsi, 40(%rcx)
	movq	48(%rdx), %rsi
	movq	%rsi, 48(%rcx)
	movq	56(%rdx), %rsi
	movq	%rsi, 56(%rcx)
	leaq	152(%rsp), %rcx
	leaq	16(%rsp), %rsi
	movq	$0, %rdx
	movq	%rdi, 144(%rsp)
	leaq	-56(%rsp), %rsp
	call	.L_sha512_absorb_mem$1
.L_sha512_mem$3:
	leaq	56(%rsp), %rsp
	movq	144(%rsp), %r8
	leaq	-24(%rsp), %rsp
	call	.L_sha512___sha512_finalize$1
.L_sha512_mem$2:
	leaq	24(%rsp), %rsp
	ret
.L_sha512___sha512_finalize$1:
	movq	%rdx, %r9
	andq	$127, %r9
	movq	$128, %rdi
	movb	%dil, (%rsi,%r9)
	incq	%r9
	cmpq	$112, %r9
	jnbe	.L_sha512___sha512_finalize$9
	movq	$-1, %rdi
	cmovnbe	%rdi, %rax
	jmp 	.L_sha512___sha512_finalize$10
.L_sha512___sha512_finalize$9:
	movq	$-1, %rdi
	cmovbe	%rdi, %rax
	movq	$128, %rdi
	movq	$0, %r10
	movq	%r9, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdi
	cmovb	%rdi, %r11
	jmp 	.L_sha512___sha512_finalize$16
.L_sha512___sha512_finalize$17:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha512___sha512_finalize$16:
	cmpq	%r11, %r9
	jb  	.L_sha512___sha512_finalize$17
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha512___sha512_finalize$14
.L_sha512___sha512_finalize$15:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r10, (%rsi,%r9)
	addq	$8, %r9
.L_sha512___sha512_finalize$14:
	movq	%r9, %r11
	addq	$8, %r11
	cmpq	%rdi, %r11
	jbe 	.L_sha512___sha512_finalize$15
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha512___sha512_finalize$12
.L_sha512___sha512_finalize$13:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha512___sha512_finalize$12:
	cmpq	%rdi, %r9
	jb  	.L_sha512___sha512_finalize$13
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	%r8, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	leaq	-1336(%rsp), %rsp
	call	.L_sha512_compress$1
.L_sha512___sha512_finalize$11:
	leaq	1336(%rsp), %rsp
	movq	8(%rsp), %r8
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdx
	orq 	%rax, %r8
	orq 	%rax, %rsi
	orq 	%rax, %rdx
	movq	$0, %r9
.L_sha512___sha512_finalize$10:
	movq	$112, %rdi
	movq	$0, %r10
	movq	%r9, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rdi
	cmovb	%rdi, %r11
	jmp 	.L_sha512___sha512_finalize$7
.L_sha512___sha512_finalize$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha512___sha512_finalize$7:
	cmpq	%r11, %r9
	jb  	.L_sha512___sha512_finalize$8
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha512___sha512_finalize$5
.L_sha512___sha512_finalize$6:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r10, (%rsi,%r9)
	addq	$8, %r9
.L_sha512___sha512_finalize$5:
	movq	%r9, %r11
	addq	$8, %r11
	cmpq	%rdi, %r11
	jbe 	.L_sha512___sha512_finalize$6
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha512___sha512_finalize$3
.L_sha512___sha512_finalize$4:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r10b, (%rsi,%r9)
	incq	%r9
.L_sha512___sha512_finalize$3:
	cmpq	%rdi, %r9
	jb  	.L_sha512___sha512_finalize$4
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	%rdx, %rdi
	shrq	$61, %rdi
	bswapq	%rdi
	movq	%rdi, 112(%rsi)
	shlq	$3, %rdx
	bswapq	%rdx
	movq	%rdx, 120(%rsi)
	movq	%r8, 24(%rsp)
	movq	%rsi, 16(%rsp)
	leaq	-1336(%rsp), %rsp
	call	.L_sha512_compress$1
.L_sha512___sha512_finalize$2:
	leaq	1336(%rsp), %rsp
	movq	24(%rsp), %rdi
	movq	16(%rsp), %rsi
	orq 	%rax, %rdi
	orq 	%rax, %rsi
	movq	(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, (%rdi)
	movq	8(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 8(%rdi)
	movq	16(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 16(%rdi)
	movq	24(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 24(%rdi)
	movq	32(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 32(%rdi)
	movq	40(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 40(%rdi)
	movq	48(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 48(%rdi)
	movq	56(%rcx), %rdx
	bswapq	%rdx
	movq	%rdx, 56(%rdi)
	ret
.L_sha512_absorb_mem$1:
	movq	%rdx, %rbp
	andq	$127, %rbp
	addq	%rbx, %rdx
	movq	$128, %rdi
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
	jmp 	.L_sha512_absorb_mem$18
.L_sha512_absorb_mem$19:
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movzbq	(%r9), %r12
	movb	%r12b, (%rsi,%r8)
	incq	%r8
	incq	%r9
.L_sha512_absorb_mem$18:
	cmpq	%r13, %r8
	jb  	.L_sha512_absorb_mem$19
	movq	$-1, %r12
	cmovb	%r12, %rax
	jmp 	.L_sha512_absorb_mem$16
.L_sha512_absorb_mem$17:
	movq	$-1, %r12
	cmovb	%r12, %rax
	movq	(%r9), %r12
	movq	%r12, (%rsi,%r8)
	addq	$8, %r8
	addq	$8, %r9
	addq	$-8, %r10
.L_sha512_absorb_mem$16:
	cmpq	$8, %r10
	jnb 	.L_sha512_absorb_mem$17
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movq	%r8, %r13
	addq	%r10, %r13
	jmp 	.L_sha512_absorb_mem$14
.L_sha512_absorb_mem$15:
	movq	$-1, %r10
	cmovnb	%r10, %rax
	movzbq	(%r9), %r10
	movb	%r10b, (%rsi,%r8)
	incq	%r8
	incq	%r9
.L_sha512_absorb_mem$14:
	cmpq	%r13, %r8
	jb  	.L_sha512_absorb_mem$15
	movq	$-1, %r8
	cmovb	%r8, %rax
	addq	%rdi, %rbp
	addq	%rdi, %r11
	cmpq	$128, %rbp
	je  	.L_sha512_absorb_mem$11
	movq	$-1, %rdi
	cmove	%rdi, %rax
	jmp 	.L_sha512_absorb_mem$12
.L_sha512_absorb_mem$11:
	movq	$-1, %rdi
	cmovne	%rdi, %rax
	movq	%rdx, 8(%rsp)
	movq	%r11, 16(%rsp)
	movq	%rbx, 24(%rsp)
	movq	%rsi, 32(%rsp)
	leaq	-1336(%rsp), %rsp
	call	.L_sha512_compress$1
.L_sha512_absorb_mem$13:
	leaq	1336(%rsp), %rsp
	movq	8(%rsp), %rdx
	movq	16(%rsp), %r11
	movq	24(%rsp), %rbx
	movq	32(%rsp), %rsi
	orq 	%rax, %rdx
	orq 	%rax, %r11
	orq 	%rax, %rbx
	orq 	%rax, %rsi
	movq	$0, %rbp
.L_sha512_absorb_mem$12:
	movq	$0, %r8
	movq	%rbx, %rdi
	shrq	$7, %rdi
	cmpq	$0, %rdi
	jne 	.L_sha512_absorb_mem$8
	movq	$-1, %rdi
	cmovne	%rdi, %rax
	jmp 	.L_sha512_absorb_mem$9
.L_sha512_absorb_mem$8:
	movq	$-1, %r8
	cmove	%r8, %rax
	movq	%rdx, 32(%rsp)
	movq	%r11, 24(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	-24(%rsp), %rsp
	call	.L_sha512_compress_blocks$1
.L_sha512_absorb_mem$10:
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
	shrq	$7, %r8
	shlq	$7, %r8
	movq	$0, %rbp
.L_sha512_absorb_mem$9:
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
	jmp 	.L_sha512_absorb_mem$6
.L_sha512_absorb_mem$7:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%r11), %rdi
	movb	%dil, (%rsi,%rbp)
	incq	%rbp
	incq	%r11
.L_sha512_absorb_mem$6:
	cmpq	%r8, %rbp
	jb  	.L_sha512_absorb_mem$7
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	jmp 	.L_sha512_absorb_mem$4
.L_sha512_absorb_mem$5:
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	(%r11), %rdi
	movq	%rdi, (%rsi,%rbp)
	addq	$8, %rbp
	addq	$8, %r11
	addq	$-8, %rbx
.L_sha512_absorb_mem$4:
	cmpq	$8, %rbx
	jnb 	.L_sha512_absorb_mem$5
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movq	%rbp, %r8
	addq	%rbx, %r8
	jmp 	.L_sha512_absorb_mem$2
.L_sha512_absorb_mem$3:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%r11), %rdi
	movb	%dil, (%rsi,%rbp)
	incq	%rbp
	incq	%r11
.L_sha512_absorb_mem$2:
	cmpq	%r8, %rbp
	jb  	.L_sha512_absorb_mem$3
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	ret
.L_sha512_compress_blocks$1:
	jmp 	.L_sha512_compress_blocks$5
.L_sha512_compress_blocks$6:
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	movq	%r11, 8(%rsp)
	movq	%rdi, 16(%rsp)
	leaq	-1336(%rsp), %rsp
	call	.L_sha512_compress_two$1
.L_sha512_compress_blocks$7:
	leaq	1336(%rsp), %rsp
	movq	8(%rsp), %r11
	movq	16(%rsp), %rdi
	orq 	%rax, %r11
	orq 	%rax, %rdi
	addq	$256, %r11
	addq	$-2, %rdi
.L_sha512_compress_blocks$5:
	cmpq	$2, %rdi
	jnb 	.L_sha512_compress_blocks$6
	movq	$-1, %rdx
	cmovnb	%rdx, %rax
	cmpq	$0, %rdi
	jne 	.L_sha512_compress_blocks$2
	movq	$-1, %rdx
	cmovne	%rdx, %rax
	jmp 	.L_sha512_compress_blocks$3
.L_sha512_compress_blocks$2:
	movq	$-1, %rdx
	cmove	%rdx, %rax
	leaq	-1336(%rsp), %rsp
	call	.L_sha512_compress_one$1
.L_sha512_compress_blocks$4:
	leaq	1336(%rsp), %rsp
.L_sha512_compress_blocks$3:
	ret
.L_sha512_compress_two$1:
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm4
	vbroadcasti128	(%r11), %ymm5
	vinserti128	$1, 128(%r11), %ymm5, %ymm5
	vpshufb	%ymm4, %ymm5, %ymm5
	vbroadcasti128	16(%r11), %ymm6
	vinserti128	$1, 144(%r11), %ymm6, %ymm6
	vpshufb	%ymm4, %ymm6, %ymm6
	vbroadcasti128	32(%r11), %ymm7
	vinserti128	$1, 160(%r11), %ymm7, %ymm7
	vpshufb	%ymm4, %ymm7, %ymm7
	vbroadcasti128	48(%r11), %ymm0
	vinserti128	$1, 176(%r11), %ymm0, %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vbroadcasti128	64(%r11), %ymm1
	vinserti128	$1, 192(%r11), %ymm1, %ymm1
	vpshufb	%ymm4, %ymm1, %ymm1
	vbroadcasti128	80(%r11), %ymm2
	vinserti128	$1, 208(%r11), %ymm2, %ymm2
	vpshufb	%ymm4, %ymm2, %ymm2
	vbroadcasti128	96(%r11), %ymm3
	vinserti128	$1, 224(%r11), %ymm3, %ymm3
	vpshufb	%ymm4, %ymm3, %ymm3
	vbroadcasti128	112(%r11), %ymm8
	vinserti128	$1, 240(%r11), %ymm8, %ymm8
	vpshufb	%ymm4, %ymm8, %ymm4
	vbroadcasti128	glob_data + 32(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 32(%rsp)
	vbroadcasti128	glob_data + 48(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 64(%rsp)
	vbroadcasti128	glob_data + 64(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rsp)
	vbroadcasti128	glob_data + 80(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 128(%rsp)
	vbroadcasti128	glob_data + 96(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 192(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 256(%rsp)
	movq	(%rcx), %rdx
	movq	8(%rcx), %rsi
	movq	16(%rcx), %rdi
	movq	24(%rcx), %r8
	movq	32(%rcx), %r9
	movq	40(%rcx), %r10
	movq	48(%rcx), %r11
	movq	56(%rcx), %rbx
	movq	%rcx, 1312(%rsp)
	movq	%rsi, %rcx
	xorq	%rdi, %rcx
	movq	$0, %rbp
	addq	32(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rbp, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rbp
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rbp
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rbp
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rbp, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rbp
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rcx
	xorq	%r13, %rbp
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rcx
	xorq	%r14, %rbp
	addq	%rcx, %rbx
	addq	40(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rbp, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 160(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 288(%rsp)
	addq	64(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	72(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 176(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 320(%rsp)
	addq	96(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	104(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 192(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 352(%rsp)
	addq	128(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	136(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 208(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 384(%rsp)
	addq	160(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	168(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 224(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 416(%rsp)
	addq	192(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	200(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 240(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 448(%rsp)
	addq	224(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	232(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 256(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 480(%rsp)
	addq	256(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	264(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 272(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 512(%rsp)
	addq	288(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	296(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 288(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 544(%rsp)
	addq	320(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	328(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 304(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 576(%rsp)
	addq	352(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	360(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 320(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 608(%rsp)
	addq	384(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	392(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 336(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 640(%rsp)
	addq	416(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	424(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 352(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 672(%rsp)
	addq	448(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	456(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 368(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 704(%rsp)
	addq	480(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	488(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 384(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 736(%rsp)
	addq	512(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	520(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 400(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 768(%rsp)
	addq	544(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	552(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 416(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 800(%rsp)
	addq	576(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	584(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 432(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 832(%rsp)
	addq	608(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	616(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 448(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 864(%rsp)
	addq	640(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	648(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 464(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 896(%rsp)
	addq	672(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	680(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 480(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 928(%rsp)
	addq	704(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	712(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 496(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 960(%rsp)
	addq	736(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	744(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 512(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 992(%rsp)
	addq	768(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	776(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 528(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1024(%rsp)
	addq	800(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	808(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 544(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 1056(%rsp)
	addq	832(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	840(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 560(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 1088(%rsp)
	addq	864(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	872(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 576(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 1120(%rsp)
	addq	896(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	904(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 592(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 1152(%rsp)
	addq	928(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	936(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 608(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 1184(%rsp)
	addq	960(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	968(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 624(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 1216(%rsp)
	addq	992(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1000(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 640(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 1248(%rsp)
	addq	1024(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1032(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 656(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1280(%rsp)
	addq	1056(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1064(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1088(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1096(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1120(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1128(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1152(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1160(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	1184(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1192(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1216(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1224(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1248(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1256(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1280(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1288(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	%rcx, %rdx
	movq	1312(%rsp), %rcx
	orq 	%rax, %rcx
	addq	(%rcx), %rdx
	movq	%rdx, (%rcx)
	addq	8(%rcx), %rsi
	movq	%rsi, 8(%rcx)
	addq	16(%rcx), %rdi
	movq	%rdi, 16(%rcx)
	addq	24(%rcx), %r8
	movq	%r8, 24(%rcx)
	addq	32(%rcx), %r9
	movq	%r9, 32(%rcx)
	addq	40(%rcx), %r10
	movq	%r10, 40(%rcx)
	addq	48(%rcx), %r11
	movq	%r11, 48(%rcx)
	addq	56(%rcx), %rbx
	movq	%rbx, 56(%rcx)
	movq	%rcx, 1312(%rsp)
	movq	%rsi, %rcx
	xorq	%rdi, %rcx
	movq	$0, %rbp
	addq	48(%rsp), %rbx
	addq	%rbp, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rbp
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rbp
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rbp
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rbp, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rbp
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rcx
	xorq	%r13, %rbp
	xorq	%rsi, %rcx
	xorq	%r14, %rbp
	addq	%rcx, %rbx
	addq	56(%rsp), %r11
	addq	%rbp, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	80(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	88(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	112(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	120(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	144(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	152(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	176(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	184(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	208(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	216(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	240(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	248(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	272(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	280(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	304(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	312(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	336(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	344(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	368(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	376(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	400(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	408(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	432(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	440(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	464(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	472(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	496(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	504(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	528(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	536(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	560(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	568(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	592(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	600(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	624(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	632(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	656(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	664(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	688(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	696(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	720(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	728(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	752(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	760(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	784(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	792(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	816(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	824(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	848(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	856(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	880(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	888(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	912(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	920(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	944(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	952(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	976(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	984(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1008(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1016(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1040(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1048(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	1072(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1080(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1104(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1112(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1136(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1144(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1168(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1176(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	1200(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1208(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1232(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1240(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1264(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1272(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1296(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1304(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	%rcx, %rdx
	movq	1312(%rsp), %rcx
	orq 	%rax, %rcx
	addq	(%rcx), %rdx
	movq	%rdx, (%rcx)
	addq	8(%rcx), %rsi
	movq	%rsi, 8(%rcx)
	addq	16(%rcx), %rdi
	movq	%rdi, 16(%rcx)
	addq	24(%rcx), %r8
	movq	%r8, 24(%rcx)
	addq	32(%rcx), %r9
	movq	%r9, 32(%rcx)
	addq	40(%rcx), %r10
	movq	%r10, 40(%rcx)
	addq	48(%rcx), %r11
	movq	%r11, 48(%rcx)
	addq	56(%rcx), %rbx
	movq	%rbx, 56(%rcx)
	ret
.L_sha512_compress_one$1:
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm4
	vbroadcasti128	(%r11), %ymm5
	vpshufb	%ymm4, %ymm5, %ymm5
	vbroadcasti128	16(%r11), %ymm6
	vpshufb	%ymm4, %ymm6, %ymm6
	vbroadcasti128	32(%r11), %ymm7
	vpshufb	%ymm4, %ymm7, %ymm7
	vbroadcasti128	48(%r11), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vbroadcasti128	64(%r11), %ymm1
	vpshufb	%ymm4, %ymm1, %ymm1
	vbroadcasti128	80(%r11), %ymm2
	vpshufb	%ymm4, %ymm2, %ymm2
	vbroadcasti128	96(%r11), %ymm3
	vpshufb	%ymm4, %ymm3, %ymm3
	vbroadcasti128	112(%r11), %ymm8
	vpshufb	%ymm4, %ymm8, %ymm4
	vbroadcasti128	glob_data + 32(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 32(%rsp)
	vbroadcasti128	glob_data + 48(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 64(%rsp)
	vbroadcasti128	glob_data + 64(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rsp)
	vbroadcasti128	glob_data + 80(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 128(%rsp)
	vbroadcasti128	glob_data + 96(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 192(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 256(%rsp)
	movq	(%rcx), %rdx
	movq	8(%rcx), %rsi
	movq	16(%rcx), %rdi
	movq	24(%rcx), %r8
	movq	32(%rcx), %r9
	movq	40(%rcx), %r10
	movq	48(%rcx), %r11
	movq	56(%rcx), %rbx
	movq	%rcx, 1312(%rsp)
	movq	%rsi, %rcx
	xorq	%rdi, %rcx
	movq	$0, %rbp
	addq	32(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rbp, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rbp
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rbp
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rbp
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rbp, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rbp
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rcx
	xorq	%r13, %rbp
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rcx
	xorq	%r14, %rbp
	addq	%rcx, %rbx
	addq	40(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rbp, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 160(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 288(%rsp)
	addq	64(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	72(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 176(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 320(%rsp)
	addq	96(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	104(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 192(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 352(%rsp)
	addq	128(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	136(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 208(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 384(%rsp)
	addq	160(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	168(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 224(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 416(%rsp)
	addq	192(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	200(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 240(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 448(%rsp)
	addq	224(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	232(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 256(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 480(%rsp)
	addq	256(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	264(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 272(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 512(%rsp)
	addq	288(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	296(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 288(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 544(%rsp)
	addq	320(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	328(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 304(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 576(%rsp)
	addq	352(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	360(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 320(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 608(%rsp)
	addq	384(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	392(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 336(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 640(%rsp)
	addq	416(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	424(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 352(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 672(%rsp)
	addq	448(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	456(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 368(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 704(%rsp)
	addq	480(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	488(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 384(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 736(%rsp)
	addq	512(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	520(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 400(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 768(%rsp)
	addq	544(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	552(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 416(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 800(%rsp)
	addq	576(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	584(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 432(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 832(%rsp)
	addq	608(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	616(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 448(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 864(%rsp)
	addq	640(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	648(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 464(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 896(%rsp)
	addq	672(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	680(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 480(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 928(%rsp)
	addq	704(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	712(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 496(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 960(%rsp)
	addq	736(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	744(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 512(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 992(%rsp)
	addq	768(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	776(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 528(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1024(%rsp)
	addq	800(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	808(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 544(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 1056(%rsp)
	addq	832(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	840(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 560(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 1088(%rsp)
	addq	864(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	872(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 576(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 1120(%rsp)
	addq	896(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	904(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 592(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 1152(%rsp)
	addq	928(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	936(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 608(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 1184(%rsp)
	addq	960(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	968(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 624(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 1216(%rsp)
	addq	992(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1000(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 640(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 1248(%rsp)
	addq	1024(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1032(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 656(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1280(%rsp)
	addq	1056(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1064(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1088(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1096(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1120(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1128(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1152(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1160(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	1184(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1192(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1216(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1224(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1248(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1256(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1280(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1288(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	%rcx, %rdx
	movq	1312(%rsp), %rcx
	orq 	%rax, %rcx
	addq	(%rcx), %rdx
	movq	%rdx, (%rcx)
	addq	8(%rcx), %rsi
	movq	%rsi, 8(%rcx)
	addq	16(%rcx), %rdi
	movq	%rdi, 16(%rcx)
	addq	24(%rcx), %r8
	movq	%r8, 24(%rcx)
	addq	32(%rcx), %r9
	movq	%r9, 32(%rcx)
	addq	40(%rcx), %r10
	movq	%r10, 40(%rcx)
	addq	48(%rcx), %r11
	movq	%r11, 48(%rcx)
	addq	56(%rcx), %rbx
	movq	%rbx, 56(%rcx)
	ret
.L_sha512_compress$1:
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm4
	vbroadcasti128	(%rsi), %ymm5
	vpshufb	%ymm4, %ymm5, %ymm5
	vbroadcasti128	16(%rsi), %ymm6
	vpshufb	%ymm4, %ymm6, %ymm6
	vbroadcasti128	32(%rsi), %ymm7
	vpshufb	%ymm4, %ymm7, %ymm7
	vbroadcasti128	48(%rsi), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vbroadcasti128	64(%rsi), %ymm1
	vpshufb	%ymm4, %ymm1, %ymm1
	vbroadcasti128	80(%rsi), %ymm2
	vpshufb	%ymm4, %ymm2, %ymm2
	vbroadcasti128	96(%rsi), %ymm3
	vpshufb	%ymm4, %ymm3, %ymm3
	vbroadcasti128	112(%rsi), %ymm8
	vpshufb	%ymm4, %ymm8, %ymm4
	vbroadcasti128	glob_data + 32(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 32(%rsp)
	vbroadcasti128	glob_data + 48(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 64(%rsp)
	vbroadcasti128	glob_data + 64(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rsp)
	vbroadcasti128	glob_data + 80(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 128(%rsp)
	vbroadcasti128	glob_data + 96(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rsp)
	vbroadcasti128	glob_data + 112(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 192(%rsp)
	vbroadcasti128	glob_data + 128(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rsp)
	vbroadcasti128	glob_data + 144(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 256(%rsp)
	movq	(%rcx), %rdx
	movq	8(%rcx), %rsi
	movq	16(%rcx), %rdi
	movq	24(%rcx), %r8
	movq	32(%rcx), %r9
	movq	40(%rcx), %r10
	movq	48(%rcx), %r11
	movq	56(%rcx), %rbx
	movq	%rcx, 1312(%rsp)
	movq	%rsi, %rcx
	xorq	%rdi, %rcx
	movq	$0, %rbp
	addq	32(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rbp, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rbp
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rbp
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rbp
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rbp, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rbp
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rcx
	xorq	%r13, %rbp
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rcx
	xorq	%r14, %rbp
	addq	%rcx, %rbx
	addq	40(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rbp, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 160(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 288(%rsp)
	addq	64(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	72(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 176(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 320(%rsp)
	addq	96(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	104(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 192(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 352(%rsp)
	addq	128(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	136(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 208(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 384(%rsp)
	addq	160(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	168(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 224(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 416(%rsp)
	addq	192(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	200(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 240(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 448(%rsp)
	addq	224(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	232(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 256(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 480(%rsp)
	addq	256(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	264(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 272(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 512(%rsp)
	addq	288(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	296(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 288(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 544(%rsp)
	addq	320(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	328(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 304(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 576(%rsp)
	addq	352(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	360(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 320(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 608(%rsp)
	addq	384(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	392(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 336(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 640(%rsp)
	addq	416(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	424(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 352(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 672(%rsp)
	addq	448(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	456(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 368(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 704(%rsp)
	addq	480(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	488(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 384(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 736(%rsp)
	addq	512(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	520(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 400(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 768(%rsp)
	addq	544(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	552(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 416(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 800(%rsp)
	addq	576(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	584(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 432(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 832(%rsp)
	addq	608(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	616(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 448(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 864(%rsp)
	addq	640(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	648(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 464(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 896(%rsp)
	addq	672(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	680(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 480(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 928(%rsp)
	addq	704(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	712(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 496(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 960(%rsp)
	addq	736(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	744(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 512(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 992(%rsp)
	addq	768(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	776(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 528(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1024(%rsp)
	addq	800(%rsp), %rbx
	vpalignr	$8, %ymm5, %ymm6, %ymm8
	vpalignr	$8, %ymm1, %ymm2, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm5, %ymm5
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	808(%rsp), %r11
	vpsrlq	$6, %ymm4, %ymm10
	vpsllq	$3, %ymm4, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm4, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm5, %ymm5
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 544(%rip), %ymm8
	vpaddq	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 1056(%rsp)
	addq	832(%rsp), %r10
	vpalignr	$8, %ymm6, %ymm7, %ymm8
	vpalignr	$8, %ymm2, %ymm3, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm6, %ymm6
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	840(%rsp), %r9
	vpsrlq	$6, %ymm5, %ymm10
	vpsllq	$3, %ymm5, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm5, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm6, %ymm6
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 560(%rip), %ymm8
	vpaddq	%ymm6, %ymm8, %ymm8
	vmovdqu	%ymm8, 1088(%rsp)
	addq	864(%rsp), %r8
	vpalignr	$8, %ymm7, %ymm0, %ymm8
	vpalignr	$8, %ymm3, %ymm4, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm7, %ymm7
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	872(%rsp), %rdi
	vpsrlq	$6, %ymm6, %ymm10
	vpsllq	$3, %ymm6, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm6, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm7, %ymm7
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 576(%rip), %ymm8
	vpaddq	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 1120(%rsp)
	addq	896(%rsp), %rsi
	vpalignr	$8, %ymm0, %ymm1, %ymm8
	vpalignr	$8, %ymm4, %ymm5, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm0, %ymm0
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	904(%rsp), %rdx
	vpsrlq	$6, %ymm7, %ymm10
	vpsllq	$3, %ymm7, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm7, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm0, %ymm0
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 592(%rip), %ymm8
	vpaddq	%ymm0, %ymm8, %ymm8
	vmovdqu	%ymm8, 1152(%rsp)
	addq	928(%rsp), %rbx
	vpalignr	$8, %ymm1, %ymm2, %ymm8
	vpalignr	$8, %ymm5, %ymm6, %ymm9
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	vpaddq	%ymm9, %ymm1, %ymm1
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	936(%rsp), %r11
	vpsrlq	$6, %ymm0, %ymm10
	vpsllq	$3, %ymm0, %ymm8
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	vpsrlq	$19, %ymm0, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	vpaddq	%ymm10, %ymm1, %ymm1
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	vbroadcasti128	glob_data + 608(%rip), %ymm8
	vpaddq	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 1184(%rsp)
	addq	960(%rsp), %r10
	vpalignr	$8, %ymm2, %ymm3, %ymm8
	vpalignr	$8, %ymm6, %ymm7, %ymm9
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	vpaddq	%ymm9, %ymm2, %ymm2
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	968(%rsp), %r9
	vpsrlq	$6, %ymm1, %ymm10
	vpsllq	$3, %ymm1, %ymm8
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	vpsrlq	$19, %ymm1, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	vpaddq	%ymm10, %ymm2, %ymm2
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	vbroadcasti128	glob_data + 624(%rip), %ymm8
	vpaddq	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 1216(%rsp)
	addq	992(%rsp), %r8
	vpalignr	$8, %ymm3, %ymm4, %ymm8
	vpalignr	$8, %ymm7, %ymm0, %ymm9
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	vpaddq	%ymm9, %ymm3, %ymm3
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1000(%rsp), %rdi
	vpsrlq	$6, %ymm2, %ymm10
	vpsllq	$3, %ymm2, %ymm8
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	vpsrlq	$19, %ymm2, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	vpaddq	%ymm10, %ymm3, %ymm3
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	vbroadcasti128	glob_data + 640(%rip), %ymm8
	vpaddq	%ymm3, %ymm8, %ymm8
	vmovdqu	%ymm8, 1248(%rsp)
	addq	1024(%rsp), %rsi
	vpalignr	$8, %ymm4, %ymm5, %ymm8
	vpalignr	$8, %ymm0, %ymm1, %ymm9
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	vpaddq	%ymm9, %ymm4, %ymm4
	vpsrlq	$1, %ymm8, %ymm9
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	vpsrlq	$7, %ymm8, %ymm10
	vpsllq	$56, %ymm8, %ymm8
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	vpsrlq	$7, %ymm9, %ymm9
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	vpxor	%ymm8, %ymm10, %ymm10
	vpsllq	$7, %ymm8, %ymm8
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1032(%rsp), %rdx
	vpsrlq	$6, %ymm3, %ymm10
	vpsllq	$3, %ymm3, %ymm8
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	vpsrlq	$19, %ymm3, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	vpsllq	$42, %ymm8, %ymm8
	vpxor	%ymm9, %ymm10, %ymm10
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	vpsrlq	$42, %ymm9, %ymm9
	vpxor	%ymm8, %ymm10, %ymm10
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	vpxor	%ymm9, %ymm10, %ymm10
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	vpaddq	%ymm10, %ymm4, %ymm4
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	vbroadcasti128	glob_data + 656(%rip), %ymm8
	vpaddq	%ymm4, %ymm8, %ymm8
	vmovdqu	%ymm8, 1280(%rsp)
	addq	1056(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1064(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1088(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1096(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1120(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1128(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1152(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1160(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	1184(%rsp), %rbx
	addq	%rcx, %rdx
	movq	%r10, %r12
	andq	%r9, %r12
	rorx	$41, %r9, %rcx
	rorx	$18, %r9, %r13
	addq	%r12, %rbx
	andnq	%r11, %r9, %r12
	xorq	%r13, %rcx
	rorx	$14, %r9, %r13
	addq	%r12, %rbx
	xorq	%r13, %rcx
	movq	%rdx, %r12
	rorx	$39, %rdx, %r13
	addq	%rcx, %rbx
	xorq	%rsi, %r12
	rorx	$34, %rdx, %rcx
	rorx	$28, %rdx, %r14
	addq	%rbx, %r8
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rsi, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rbx
	addq	1192(%rsp), %r11
	addq	%rcx, %rbx
	movq	%r9, %r13
	andq	%r8, %r13
	rorx	$41, %r8, %rcx
	rorx	$18, %r8, %rbp
	addq	%r13, %r11
	andnq	%r10, %r8, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r8, %rbp
	addq	%r13, %r11
	xorq	%rbp, %rcx
	movq	%rbx, %rbp
	rorx	$39, %rbx, %r13
	addq	%rcx, %r11
	xorq	%rdx, %rbp
	rorx	$34, %rbx, %rcx
	rorx	$28, %rbx, %r14
	addq	%r11, %rdi
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdx, %r12
	xorq	%r14, %rcx
	addq	%r12, %r11
	addq	1216(%rsp), %r10
	addq	%rcx, %r11
	movq	%r8, %r12
	andq	%rdi, %r12
	rorx	$41, %rdi, %rcx
	rorx	$18, %rdi, %r13
	addq	%r12, %r10
	andnq	%r9, %rdi, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdi, %r13
	addq	%r12, %r10
	xorq	%r13, %rcx
	movq	%r11, %r12
	rorx	$39, %r11, %r13
	addq	%rcx, %r10
	xorq	%rbx, %r12
	rorx	$34, %r11, %rcx
	rorx	$28, %r11, %r14
	addq	%r10, %rsi
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%rbx, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r10
	addq	1224(%rsp), %r9
	addq	%rcx, %r10
	movq	%rdi, %r13
	andq	%rsi, %r13
	rorx	$41, %rsi, %rcx
	rorx	$18, %rsi, %rbp
	addq	%r13, %r9
	andnq	%r8, %rsi, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rsi, %rbp
	addq	%r13, %r9
	xorq	%rbp, %rcx
	movq	%r10, %rbp
	rorx	$39, %r10, %r13
	addq	%rcx, %r9
	xorq	%r11, %rbp
	rorx	$34, %r10, %rcx
	rorx	$28, %r10, %r14
	addq	%r9, %rdx
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r11, %r12
	xorq	%r14, %rcx
	addq	%r12, %r9
	addq	1248(%rsp), %r8
	addq	%rcx, %r9
	movq	%rsi, %r12
	andq	%rdx, %r12
	rorx	$41, %rdx, %rcx
	rorx	$18, %rdx, %r13
	addq	%r12, %r8
	andnq	%rdi, %rdx, %r12
	xorq	%r13, %rcx
	rorx	$14, %rdx, %r13
	addq	%r12, %r8
	xorq	%r13, %rcx
	movq	%r9, %r12
	rorx	$39, %r9, %r13
	addq	%rcx, %r8
	xorq	%r10, %r12
	rorx	$34, %r9, %rcx
	rorx	$28, %r9, %r14
	addq	%r8, %rbx
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r10, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %r8
	addq	1256(%rsp), %rdi
	addq	%rcx, %r8
	movq	%rdx, %r13
	andq	%rbx, %r13
	rorx	$41, %rbx, %rcx
	rorx	$18, %rbx, %rbp
	addq	%r13, %rdi
	andnq	%rsi, %rbx, %r13
	xorq	%rbp, %rcx
	rorx	$14, %rbx, %rbp
	addq	%r13, %rdi
	xorq	%rbp, %rcx
	movq	%r8, %rbp
	rorx	$39, %r8, %r13
	addq	%rcx, %rdi
	xorq	%r9, %rbp
	rorx	$34, %r8, %rcx
	rorx	$28, %r8, %r14
	addq	%rdi, %r11
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%r9, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdi
	addq	1280(%rsp), %rsi
	addq	%rcx, %rdi
	movq	%rbx, %r12
	andq	%r11, %r12
	rorx	$41, %r11, %rcx
	rorx	$18, %r11, %r13
	addq	%r12, %rsi
	andnq	%rdx, %r11, %r12
	xorq	%r13, %rcx
	rorx	$14, %r11, %r13
	addq	%r12, %rsi
	xorq	%r13, %rcx
	movq	%rdi, %r12
	rorx	$39, %rdi, %r13
	addq	%rcx, %rsi
	xorq	%r8, %r12
	rorx	$34, %rdi, %rcx
	rorx	$28, %rdi, %r14
	addq	%rsi, %r10
	andq	%r12, %rbp
	xorq	%r13, %rcx
	xorq	%r8, %rbp
	xorq	%r14, %rcx
	addq	%rbp, %rsi
	addq	1288(%rsp), %rdx
	addq	%rcx, %rsi
	movq	%r11, %r13
	andq	%r10, %r13
	rorx	$41, %r10, %rcx
	rorx	$18, %r10, %rbp
	addq	%r13, %rdx
	andnq	%rbx, %r10, %r13
	xorq	%rbp, %rcx
	rorx	$14, %r10, %rbp
	addq	%r13, %rdx
	xorq	%rbp, %rcx
	movq	%rsi, %rbp
	rorx	$39, %rsi, %r13
	addq	%rcx, %rdx
	xorq	%rdi, %rbp
	rorx	$34, %rsi, %rcx
	rorx	$28, %rsi, %r14
	addq	%rdx, %r9
	andq	%rbp, %r12
	xorq	%r13, %rcx
	xorq	%rdi, %r12
	xorq	%r14, %rcx
	addq	%r12, %rdx
	addq	%rcx, %rdx
	movq	1312(%rsp), %rcx
	orq 	%rax, %rcx
	addq	(%rcx), %rdx
	movq	%rdx, (%rcx)
	addq	8(%rcx), %rsi
	movq	%rsi, 8(%rcx)
	addq	16(%rcx), %rdi
	movq	%rdi, 16(%rcx)
	addq	24(%rcx), %r8
	movq	%r8, 24(%rcx)
	addq	32(%rcx), %r9
	movq	%r9, 32(%rcx)
	addq	40(%rcx), %r10
	movq	%r10, 40(%rcx)
	addq	48(%rcx), %r11
	movq	%r11, 48(%rcx)
	addq	56(%rcx), %rbx
	movq	%rbx, 56(%rcx)
	ret
	.data
	.p2align	5
glob_data:
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
G$SHA512_IV:
	.byte	  8, 201, 188, 243, 103, 230,   9, 106,  59, 167, 202, 132, 133, 174, 103, 187
	.byte	 43, 248, 148, 254, 114, 243, 110,  60, 241,  54,  29,  95,  58, 245,  79, 165
	.byte	209, 130, 230, 173, 127,  82,  14,  81,  31, 108,  62,  43, 140, 104,   5, 155
	.byte	107, 189,  65, 251, 171, 217, 131,  31, 121,  33, 126,  19,  25, 205, 224,  91
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
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
