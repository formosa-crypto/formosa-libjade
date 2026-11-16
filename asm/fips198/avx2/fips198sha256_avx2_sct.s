	.att_syntax
	.text
	.p2align	5
	.global	jade_mac_hmac_sha256_amd64_avx2_final
	.global	jade_mac_hmac_sha256_amd64_avx2_update
	.global	jade_mac_hmac_sha256_amd64_avx2_init
	.global	jade_mac_hmac_sha256_amd64_avx2
	.type	jade_mac_hmac_sha256_amd64_avx2_final, %function
jade_mac_hmac_sha256_amd64_avx2_final:
	movq	%rsp, %rax
	leaq	-288(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 208(%rsp)
	movq	%rbp, 216(%rsp)
	movq	%r12, 224(%rsp)
	movq	%r13, 232(%rsp)
	movq	%r14, 240(%rsp)
	movq	%r15, 248(%rsp)
	movq	%rax, 256(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, %rcx
	movq	(%rcx), %r8
	movq	8(%rcx), %rdx
// declassify_val u64 %r8
// declassify_val u64 %rdx
	orq 	%rax, %r8
	orq 	%rax, %rdx
	movq	$1130421643379, %rcx
	movq	$1, %r9
	cmpq	%rcx, %r8
	je  	.Ljade_mac_hmac_sha256_amd64_avx2_final$1
	movq	$-1, %rcx
	cmove	%rcx, %rax
	jmp 	.Ljade_mac_hmac_sha256_amd64_avx2_final$2
.Ljade_mac_hmac_sha256_amd64_avx2_final$1:
	movq	$-1, %rcx
	cmovne	%rcx, %rax
	leaq	144(%rsp), %r9
	movq	%rsp, %r8
	movq	%rdi, %rcx
	movl	16(%rcx), %r10d
	movl	%r10d, (%r9)
	movl	20(%rcx), %r10d
	movl	%r10d, 4(%r9)
	movl	24(%rcx), %r10d
	movl	%r10d, 8(%r9)
	movl	28(%rcx), %r10d
	movl	%r10d, 12(%r9)
	movl	32(%rcx), %r10d
	movl	%r10d, 16(%r9)
	movl	36(%rcx), %r10d
	movl	%r10d, 20(%r9)
	movl	40(%rcx), %r10d
	movl	%r10d, 24(%r9)
	movl	44(%rcx), %r10d
	movl	%r10d, 28(%r9)
	movq	48(%rcx), %r9
	movq	%r9, (%r8)
	movq	56(%rcx), %r9
	movq	%r9, 8(%r8)
	movq	64(%rcx), %r9
	movq	%r9, 16(%r8)
	movq	72(%rcx), %r9
	movq	%r9, 24(%r8)
	movq	80(%rcx), %r9
	movq	%r9, 32(%r8)
	movq	88(%rcx), %r9
	movq	%r9, 40(%r8)
	movq	96(%rcx), %r9
	movq	%r9, 48(%r8)
	movq	104(%rcx), %r9
	movq	%r9, 56(%r8)
	movl	112(%rdi), %r10d
	movl	%r10d, 176(%rsp)
	movl	116(%rdi), %r10d
	movl	%r10d, 180(%rsp)
	movl	120(%rdi), %r10d
	movl	%r10d, 184(%rsp)
	movl	124(%rdi), %r10d
	movl	%r10d, 188(%rsp)
	movl	128(%rdi), %r10d
	movl	%r10d, 192(%rsp)
	movl	132(%rdi), %r10d
	movl	%r10d, 196(%rsp)
	movl	136(%rdi), %r10d
	movl	%r10d, 200(%rsp)
	movl	140(%rdi), %r10d
	movl	%r10d, 204(%rsp)
	movq	%rdi, 64(%rsp)
	movq	%rsi, 72(%rsp)
	leaq	144(%rsp), %rcx
	movq	%rsp, %r8
	leaq	112(%rsp), %rdi
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.Ljade_mac_hmac_sha256_amd64_avx2_final$4:
	leaq	24(%rsp), %rsp
	movl	176(%rsp), %r10d
	movl	%r10d, (%rcx)
	movl	180(%rsp), %r10d
	movl	%r10d, 4(%rcx)
	movl	184(%rsp), %r10d
	movl	%r10d, 8(%rcx)
	movl	188(%rsp), %r10d
	movl	%r10d, 12(%rcx)
	movl	192(%rsp), %r10d
	movl	%r10d, 16(%rcx)
	movl	196(%rsp), %r10d
	movl	%r10d, 20(%rcx)
	movl	200(%rsp), %r10d
	movl	%r10d, 24(%rcx)
	movl	204(%rsp), %r10d
	movl	%r10d, 28(%rcx)
	movq	112(%rsp), %r9
	movq	%r9, (%r8)
	movq	120(%rsp), %r9
	movq	%r9, 8(%r8)
	movq	128(%rsp), %r9
	movq	%r9, 16(%r8)
	movq	136(%rsp), %r9
	movq	%r9, 24(%r8)
	movq	$96, %rdx
	leaq	80(%rsp), %rdi
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.Ljade_mac_hmac_sha256_amd64_avx2_final$3:
	leaq	24(%rsp), %rsp
	movq	64(%rsp), %rcx
	movq	72(%rsp), %rsi
	orq 	%rax, %rcx
	orq 	%rax, %rsi
	movq	80(%rsp), %r9
	movq	%r9, (%rsi)
	movq	88(%rsp), %r9
	movq	%r9, 8(%rsi)
	movq	96(%rsp), %r9
	movq	%r9, 16(%rsi)
	movq	104(%rsp), %r9
	movq	%r9, 24(%rsi)
	movq	$0, %rax
	movq	%rax, (%rcx)
	movq	%rax, 8(%rcx)
	movq	%rax, 16(%rcx)
	movq	%rax, 24(%rcx)
	movq	%rax, 32(%rcx)
	movq	%rax, 40(%rcx)
	movq	%rax, 48(%rcx)
	movq	%rax, 56(%rcx)
	movq	%rax, 64(%rcx)
	movq	%rax, 72(%rcx)
	movq	%rax, 80(%rcx)
	movq	%rax, 88(%rcx)
	movq	%rax, 96(%rcx)
	movq	%rax, 104(%rcx)
	movq	%rax, 112(%rcx)
	movq	%rax, 120(%rcx)
	movq	%rax, 128(%rcx)
	movq	%rax, 136(%rcx)
	movq	$0, %r9
.Ljade_mac_hmac_sha256_amd64_avx2_final$2:
	movq	%r9, %rax
	movq	208(%rsp), %rbx
	movq	216(%rsp), %rbp
	movq	224(%rsp), %r12
	movq	232(%rsp), %r13
	movq	240(%rsp), %r14
	movq	248(%rsp), %r15
	movq	256(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$896, %rsp
	movq	$896, %rdi
.Ljade_mac_hmac_sha256_amd64_avx2_final$5:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_mac_hmac_sha256_amd64_avx2_final$5
	movq	%rsi, %rsp
	ret
	.type	jade_mac_hmac_sha256_amd64_avx2_update, %function
jade_mac_hmac_sha256_amd64_avx2_update:
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
	movq	%rdx, %r9
	lfence
	movq	$0, %rax
	movq	$1130421643379, %rcx
	leaq	-24(%rsp), %rsp
	call	.L_sha256_ctx_update$1
.Ljade_mac_hmac_sha256_amd64_avx2_update$1:
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
.Ljade_mac_hmac_sha256_amd64_avx2_update$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_mac_hmac_sha256_amd64_avx2_update$2
	movq	%rsi, %rsp
	ret
	.type	jade_mac_hmac_sha256_amd64_avx2_init, %function
jade_mac_hmac_sha256_amd64_avx2_init:
	movq	%rsp, %rax
	leaq	-320(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 264(%rsp)
	movq	%rbp, 272(%rsp)
	movq	%r12, 280(%rsp)
	movq	%r13, 288(%rsp)
	movq	%r14, 296(%rsp)
	movq	%r15, 304(%rsp)
	movq	%rax, 312(%rsp)
	movq	%rdx, %r9
	lfence
	movq	$0, %rax
	movq	%rdi, 128(%rsp)
	leaq	136(%rsp), %rcx
	leaq	-56(%rsp), %rsp
	call	.L_hmac_sha256_keyblock_mem$1
.Ljade_mac_hmac_sha256_amd64_avx2_init$3:
	leaq	56(%rsp), %rsp
	leaq	136(%rsp), %rcx
	movq	$3906369333256140342, %rdx
	movq	$6655295901103053916, %rsi
	movq	(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 64(%rsp)
	movq	%rdi, (%rsp)
	movq	8(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 72(%rsp)
	movq	%rdi, 8(%rsp)
	movq	16(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 80(%rsp)
	movq	%rdi, 16(%rsp)
	movq	24(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 88(%rsp)
	movq	%rdi, 24(%rsp)
	movq	32(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 96(%rsp)
	movq	%rdi, 32(%rsp)
	movq	40(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 104(%rsp)
	movq	%rdi, 40(%rsp)
	movq	48(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 112(%rsp)
	movq	%rdi, 48(%rsp)
	movq	56(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 120(%rsp)
	movq	%rdi, 56(%rsp)
	leaq	232(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %r9d
	movl	%r9d, (%rcx)
	movl	4(%rdx), %r9d
	movl	%r9d, 4(%rcx)
	movl	8(%rdx), %r9d
	movl	%r9d, 8(%rcx)
	movl	12(%rdx), %r9d
	movl	%r9d, 12(%rcx)
	movl	16(%rdx), %r9d
	movl	%r9d, 16(%rcx)
	movl	20(%rdx), %r9d
	movl	%r9d, 20(%rcx)
	movl	24(%rdx), %r9d
	movl	%r9d, 24(%rcx)
	movl	28(%rdx), %r9d
	movl	%r9d, 28(%rcx)
	leaq	232(%rsp), %rcx
	leaq	64(%rsp), %r8
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.Ljade_mac_hmac_sha256_amd64_avx2_init$2:
	leaq	568(%rsp), %rsp
	leaq	200(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %r9d
	movl	%r9d, (%rcx)
	movl	4(%rdx), %r9d
	movl	%r9d, 4(%rcx)
	movl	8(%rdx), %r9d
	movl	%r9d, 8(%rcx)
	movl	12(%rdx), %r9d
	movl	%r9d, 12(%rcx)
	movl	16(%rdx), %r9d
	movl	%r9d, 16(%rcx)
	movl	20(%rdx), %r9d
	movl	%r9d, 20(%rcx)
	movl	24(%rdx), %r9d
	movl	%r9d, 24(%rcx)
	movl	28(%rdx), %r9d
	movl	%r9d, 28(%rcx)
	leaq	200(%rsp), %rcx
	movq	%rsp, %r8
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.Ljade_mac_hmac_sha256_amd64_avx2_init$1:
	leaq	568(%rsp), %rsp
	movq	128(%rsp), %rcx
	orq 	%rax, %rcx
	movq	$1130421643379, %rdx
	movq	$64, %rax
	movq	%rcx, %rdi
	leaq	232(%rsp), %r9
	movq	%rdx, (%rdi)
	movq	%rax, 8(%rdi)
	movl	(%r9), %r10d
	movl	%r10d, 16(%rdi)
	movl	4(%r9), %r10d
	movl	%r10d, 20(%rdi)
	movl	8(%r9), %r10d
	movl	%r10d, 24(%rdi)
	movl	12(%r9), %r10d
	movl	%r10d, 28(%rdi)
	movl	16(%r9), %r10d
	movl	%r10d, 32(%rdi)
	movl	20(%r9), %r10d
	movl	%r10d, 36(%rdi)
	movl	24(%r9), %r10d
	movl	%r10d, 40(%rdi)
	movl	28(%r9), %r10d
	movl	%r10d, 44(%rdi)
	movq	$0, %rax
	movq	%rax, 48(%rdi)
	movq	%rax, 56(%rdi)
	movq	%rax, 64(%rdi)
	movq	%rax, 72(%rdi)
	movq	%rax, 80(%rdi)
	movq	%rax, 88(%rdi)
	movq	%rax, 96(%rdi)
	movq	%rax, 104(%rdi)
	movl	200(%rsp), %r10d
	movl	%r10d, 112(%rcx)
	movl	204(%rsp), %r10d
	movl	%r10d, 116(%rcx)
	movl	208(%rsp), %r10d
	movl	%r10d, 120(%rcx)
	movl	212(%rsp), %r10d
	movl	%r10d, 124(%rcx)
	movl	216(%rsp), %r10d
	movl	%r10d, 128(%rcx)
	movl	220(%rsp), %r10d
	movl	%r10d, 132(%rcx)
	movl	224(%rsp), %r10d
	movl	%r10d, 136(%rcx)
	movl	228(%rsp), %r10d
	movl	%r10d, 140(%rcx)
	movq	264(%rsp), %rbx
	movq	272(%rsp), %rbp
	movq	280(%rsp), %r12
	movq	288(%rsp), %r13
	movq	296(%rsp), %r14
	movq	304(%rsp), %r15
	movq	312(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$1184, %rsp
	movq	$1184, %rdi
.Ljade_mac_hmac_sha256_amd64_avx2_init$4:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_mac_hmac_sha256_amd64_avx2_init$4
	movq	%rsi, %rsp
	ret
	.type	jade_mac_hmac_sha256_amd64_avx2, %function
jade_mac_hmac_sha256_amd64_avx2:
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
	movq	%rdx, %r9
	lfence
	movq	$0, %rax
	leaq	-344(%rsp), %rsp
	call	.L_hmac_sha256_mem$1
.Ljade_mac_hmac_sha256_amd64_avx2$1:
	leaq	344(%rsp), %rsp
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
	subq	$1280, %rsp
	movq	$1280, %rdi
.Ljade_mac_hmac_sha256_amd64_avx2$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_mac_hmac_sha256_amd64_avx2$2
	movq	%rsi, %rsp
	ret
.L_sha256_ctx_update$1:
	movq	%rdi, %rdx
	movq	(%rdx), %r8
	movq	8(%rdx), %rdx
// declassify_val u64 %r8
// declassify_val u64 %rdx
	orq 	%rax, %r8
	orq 	%rax, %rdx
	movq	$1, %r10
	cmpq	%rcx, %r8
	je  	.L_sha256_ctx_update$2
	movq	$-1, %rcx
	cmove	%rcx, %rax
	jmp 	.L_sha256_ctx_update$3
.L_sha256_ctx_update$2:
	movq	$-1, %rcx
	cmovne	%rcx, %rax
	movq	$2305843009213693952, %rcx
	movq	$0, %r8
	movq	%rcx, %r10
	subq	%rdx, %r10
	cmpq	%rcx, %rdx
	cmovb	%r10, %r8
	movq	$2, %r10
	cmpq	%r8, %r9
	jb  	.L_sha256_ctx_update$4
	movq	$-1, %rcx
	cmovb	%rcx, %rax
	jmp 	.L_sha256_ctx_update$3
.L_sha256_ctx_update$4:
	movq	$-1, %rcx
	cmovnb	%rcx, %rax
	leaq	16(%rdi), %rcx
	leaq	48(%rdi), %r8
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_sha256_ctx_update$6:
	leaq	56(%rsp), %rsp
	movq	%rdx, 8(%rdi)
	movq	$0, %r10
.L_sha256_ctx_update$5:
.L_sha256_ctx_update$3:
	ret
.L_hmac_sha256_mem$1:
	movq	%rdi, 144(%rsp)
	movq	%rcx, 152(%rsp)
	movq	%r8, 160(%rsp)
	leaq	200(%rsp), %rcx
	leaq	-56(%rsp), %rsp
	call	.L_hmac_sha256_keyblock_mem$1
.L_hmac_sha256_mem$7:
	leaq	56(%rsp), %rsp
	leaq	200(%rsp), %rcx
	movq	$3906369333256140342, %rdx
	movq	$6655295901103053916, %rsi
	movq	(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 80(%rsp)
	movq	%rdi, 16(%rsp)
	movq	8(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 88(%rsp)
	movq	%rdi, 24(%rsp)
	movq	16(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 96(%rsp)
	movq	%rdi, 32(%rsp)
	movq	24(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 104(%rsp)
	movq	%rdi, 40(%rsp)
	movq	32(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 112(%rsp)
	movq	%rdi, 48(%rsp)
	movq	40(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 120(%rsp)
	movq	%rdi, 56(%rsp)
	movq	48(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 128(%rsp)
	movq	%rdi, 64(%rsp)
	movq	56(%rcx), %r9
	movq	%r9, %rdi
	xorq	%rdx, %r9
	xorq	%rsi, %rdi
	movq	%r9, 136(%rsp)
	movq	%rdi, 72(%rsp)
	leaq	296(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %r9d
	movl	%r9d, (%rcx)
	movl	4(%rdx), %r9d
	movl	%r9d, 4(%rcx)
	movl	8(%rdx), %r9d
	movl	%r9d, 8(%rcx)
	movl	12(%rdx), %r9d
	movl	%r9d, 12(%rcx)
	movl	16(%rdx), %r9d
	movl	%r9d, 16(%rcx)
	movl	20(%rdx), %r9d
	movl	%r9d, 20(%rcx)
	movl	24(%rdx), %r9d
	movl	%r9d, 24(%rcx)
	movl	28(%rdx), %r9d
	movl	%r9d, 28(%rcx)
	leaq	296(%rsp), %rcx
	leaq	80(%rsp), %r8
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_hmac_sha256_mem$6:
	leaq	568(%rsp), %rsp
	leaq	264(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %r9d
	movl	%r9d, (%rcx)
	movl	4(%rdx), %r9d
	movl	%r9d, 4(%rcx)
	movl	8(%rdx), %r9d
	movl	%r9d, 8(%rcx)
	movl	12(%rdx), %r9d
	movl	%r9d, 12(%rcx)
	movl	16(%rdx), %r9d
	movl	%r9d, 16(%rcx)
	movl	20(%rdx), %r9d
	movl	%r9d, 20(%rcx)
	movl	24(%rdx), %r9d
	movl	%r9d, 24(%rcx)
	movl	28(%rdx), %r9d
	movl	%r9d, 28(%rcx)
	leaq	264(%rsp), %rcx
	leaq	16(%rsp), %r8
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_hmac_sha256_mem$5:
	leaq	568(%rsp), %rsp
	movq	152(%rsp), %rsi
	movq	160(%rsp), %r9
	orq 	%rax, %rsi
	orq 	%rax, %r9
	movq	$64, %rdx
	leaq	296(%rsp), %rcx
	leaq	16(%rsp), %r8
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_hmac_sha256_mem$4:
	leaq	56(%rsp), %rsp
	leaq	296(%rsp), %rcx
	leaq	16(%rsp), %r8
	leaq	168(%rsp), %rdi
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.L_hmac_sha256_mem$3:
	leaq	24(%rsp), %rsp
	movl	264(%rsp), %r10d
	movl	%r10d, (%rcx)
	movl	268(%rsp), %r10d
	movl	%r10d, 4(%rcx)
	movl	272(%rsp), %r10d
	movl	%r10d, 8(%rcx)
	movl	276(%rsp), %r10d
	movl	%r10d, 12(%rcx)
	movl	280(%rsp), %r10d
	movl	%r10d, 16(%rcx)
	movl	284(%rsp), %r10d
	movl	%r10d, 20(%rcx)
	movl	288(%rsp), %r10d
	movl	%r10d, 24(%rcx)
	movl	292(%rsp), %r10d
	movl	%r10d, 28(%rcx)
	movq	168(%rsp), %r9
	movq	%r9, (%r8)
	movq	176(%rsp), %r9
	movq	%r9, 8(%r8)
	movq	184(%rsp), %r9
	movq	%r9, 16(%r8)
	movq	192(%rsp), %r9
	movq	%r9, 24(%r8)
	movq	$96, %rdx
	movq	144(%rsp), %rdi
	leaq	296(%rsp), %rcx
	leaq	16(%rsp), %r8
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.L_hmac_sha256_mem$2:
	leaq	24(%rsp), %rsp
	ret
.L_hmac_sha256_keyblock_mem$1:
	cmpq	$64, %r9
	jnbe	.L_hmac_sha256_keyblock_mem$8
	movq	$-1, %rdx
	cmovnbe	%rdx, %rax
	movq	$0, %rdx
	movq	%r9, %r10
	movq	%rdx, %rdi
	negq	%rdi
	andq	$7, %rdi
	cmpq	%rdi, %r10
	cmovb	%r10, %rdi
	subq	%rdi, %r10
	movq	%rdx, %r8
	addq	%rdi, %r8
	jmp 	.L_hmac_sha256_keyblock_mem$15
.L_hmac_sha256_keyblock_mem$16:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%rsi), %rdi
	movb	%dil, (%rcx,%rdx)
	incq	%rdx
	incq	%rsi
.L_hmac_sha256_keyblock_mem$15:
	cmpq	%r8, %rdx
	jb  	.L_hmac_sha256_keyblock_mem$16
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	jmp 	.L_hmac_sha256_keyblock_mem$13
.L_hmac_sha256_keyblock_mem$14:
	movq	$-1, %rdi
	cmovb	%rdi, %rax
	movq	(%rsi), %rdi
	movq	%rdi, (%rcx,%rdx)
	addq	$8, %rdx
	addq	$8, %rsi
	addq	$-8, %r10
.L_hmac_sha256_keyblock_mem$13:
	cmpq	$8, %r10
	jnb 	.L_hmac_sha256_keyblock_mem$14
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movq	%rdx, %r8
	addq	%r10, %r8
	jmp 	.L_hmac_sha256_keyblock_mem$11
.L_hmac_sha256_keyblock_mem$12:
	movq	$-1, %rdi
	cmovnb	%rdi, %rax
	movzbq	(%rsi), %rdi
	movb	%dil, (%rcx,%rdx)
	incq	%rdx
	incq	%rsi
.L_hmac_sha256_keyblock_mem$11:
	cmpq	%r8, %rdx
	jb  	.L_hmac_sha256_keyblock_mem$12
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	movq	%r9, %rdx
	jmp 	.L_hmac_sha256_keyblock_mem$9
.L_hmac_sha256_keyblock_mem$8:
	movq	$-1, %rdx
	cmovbe	%rdx, %rax
	movq	%rcx, 8(%rsp)
	leaq	16(%rsp), %rdi
	leaq	-120(%rsp), %rsp
	call	.L_sha256_mem$1
.L_hmac_sha256_keyblock_mem$10:
	leaq	120(%rsp), %rsp
	movq	8(%rsp), %rcx
	orq 	%rax, %rcx
	movq	16(%rsp), %r9
	movq	%r9, (%rcx)
	movq	24(%rsp), %r9
	movq	%r9, 8(%rcx)
	movq	32(%rsp), %r9
	movq	%r9, 16(%rcx)
	movq	40(%rsp), %r9
	movq	%r9, 24(%rcx)
	movq	$32, %rdx
.L_hmac_sha256_keyblock_mem$9:
	movq	$64, %rsi
	movq	$0, %rdi
	movq	%rdx, %r8
	addq	$7, %r8
	andq	$-8, %r8
	cmpq	%r8, %rsi
	cmovb	%rsi, %r8
	jmp 	.L_hmac_sha256_keyblock_mem$6
.L_hmac_sha256_keyblock_mem$7:
	movq	$-1, %r9
	cmovnb	%r9, %rax
	movb	%dil, (%rcx,%rdx)
	incq	%rdx
.L_hmac_sha256_keyblock_mem$6:
	cmpq	%r8, %rdx
	jb  	.L_hmac_sha256_keyblock_mem$7
	movq	$-1, %r8
	cmovb	%r8, %rax
	jmp 	.L_hmac_sha256_keyblock_mem$4
.L_hmac_sha256_keyblock_mem$5:
	movq	$-1, %r8
	cmovnbe	%r8, %rax
	movq	%rdi, (%rcx,%rdx)
	addq	$8, %rdx
.L_hmac_sha256_keyblock_mem$4:
	movq	%rdx, %r8
	addq	$8, %r8
	cmpq	%rsi, %r8
	jbe 	.L_hmac_sha256_keyblock_mem$5
	movq	$-1, %r8
	cmovbe	%r8, %rax
	jmp 	.L_hmac_sha256_keyblock_mem$2
.L_hmac_sha256_keyblock_mem$3:
	movq	$-1, %r8
	cmovnb	%r8, %rax
	movb	%dil, (%rcx,%rdx)
	incq	%rdx
.L_hmac_sha256_keyblock_mem$2:
	cmpq	%rsi, %rdx
	jb  	.L_hmac_sha256_keyblock_mem$3
	movq	$-1, %rcx
	cmovb	%rcx, %rax
	ret
.L_sha256_mem$1:
	leaq	88(%rsp), %rcx
	leaq	glob_data + 352(%rip), %rdx
	movl	(%rdx), %r8d
	movl	%r8d, (%rcx)
	movl	4(%rdx), %r8d
	movl	%r8d, 4(%rcx)
	movl	8(%rdx), %r8d
	movl	%r8d, 8(%rcx)
	movl	12(%rdx), %r8d
	movl	%r8d, 12(%rcx)
	movl	16(%rdx), %r8d
	movl	%r8d, 16(%rcx)
	movl	20(%rdx), %r8d
	movl	%r8d, 20(%rcx)
	movl	24(%rdx), %r8d
	movl	%r8d, 24(%rcx)
	movl	28(%rdx), %r8d
	movl	%r8d, 28(%rcx)
	leaq	88(%rsp), %rcx
	leaq	16(%rsp), %r8
	movq	$0, %rdx
	movq	%rdi, 80(%rsp)
	leaq	-56(%rsp), %rsp
	call	.L_sha256_absorb_mem$1
.L_sha256_mem$3:
	leaq	56(%rsp), %rsp
	movq	80(%rsp), %rdi
	leaq	-24(%rsp), %rsp
	call	.L_sha256___sha256_finalize$1
.L_sha256_mem$2:
	leaq	24(%rsp), %rsp
	ret
.L_sha256___sha256_finalize$1:
	movq	%rdx, %r10
	andq	$63, %r10
	movq	$128, %r9
	movb	%r9b, (%r8,%r10)
	incq	%r10
	cmpq	$56, %r10
	jnbe	.L_sha256___sha256_finalize$9
	movq	$-1, %rsi
	cmovnbe	%rsi, %rax
	jmp 	.L_sha256___sha256_finalize$10
.L_sha256___sha256_finalize$9:
	movq	$-1, %rsi
	cmovbe	%rsi, %rax
	movq	$64, %rsi
	movq	%r10, %r9
	movq	$0, %r10
	movq	%r9, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rsi
	cmovb	%rsi, %r11
	jmp 	.L_sha256___sha256_finalize$16
.L_sha256___sha256_finalize$17:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r10b, (%r8,%r9)
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
	movq	%r10, (%r8,%r9)
	addq	$8, %r9
.L_sha256___sha256_finalize$14:
	movq	%r9, %r11
	addq	$8, %r11
	cmpq	%rsi, %r11
	jbe 	.L_sha256___sha256_finalize$15
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$12
.L_sha256___sha256_finalize$13:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r10b, (%r8,%r9)
	incq	%r9
.L_sha256___sha256_finalize$12:
	cmpq	%rsi, %r9
	jb  	.L_sha256___sha256_finalize$13
	movq	$-1, %rsi
	cmovb	%rsi, %rax
	movq	%rdi, 8(%rsp)
	movq	%r8, 16(%rsp)
	movq	%rdx, 24(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256___sha256_finalize$11:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rdi
	movq	16(%rsp), %r8
	movq	24(%rsp), %rdx
	orq 	%rax, %rdi
	orq 	%rax, %r8
	orq 	%rax, %rdx
	movq	$0, %r10
.L_sha256___sha256_finalize$10:
	movq	$56, %rsi
	movq	$0, %r9
	movq	%r10, %r11
	addq	$7, %r11
	andq	$-8, %r11
	cmpq	%r11, %rsi
	cmovb	%rsi, %r11
	jmp 	.L_sha256___sha256_finalize$7
.L_sha256___sha256_finalize$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %rax
	movb	%r9b, (%r8,%r10)
	incq	%r10
.L_sha256___sha256_finalize$7:
	cmpq	%r11, %r10
	jb  	.L_sha256___sha256_finalize$8
	movq	$-1, %r11
	cmovb	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$5
.L_sha256___sha256_finalize$6:
	movq	$-1, %r11
	cmovnbe	%r11, %rax
	movq	%r9, (%r8,%r10)
	addq	$8, %r10
.L_sha256___sha256_finalize$5:
	movq	%r10, %r11
	addq	$8, %r11
	cmpq	%rsi, %r11
	jbe 	.L_sha256___sha256_finalize$6
	movq	$-1, %r11
	cmovbe	%r11, %rax
	jmp 	.L_sha256___sha256_finalize$3
.L_sha256___sha256_finalize$4:
	movq	$-1, %r11
	cmovnb	%r11, %rax
	movb	%r9b, (%r8,%r10)
	incq	%r10
.L_sha256___sha256_finalize$3:
	cmpq	%rsi, %r10
	jb  	.L_sha256___sha256_finalize$4
	movq	$-1, %rsi
	cmovb	%rsi, %rax
	shlq	$3, %rdx
	bswapq	%rdx
	movq	%rdx, 56(%r8)
	movq	%rdi, 24(%rsp)
	movq	%r8, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256___sha256_finalize$2:
	leaq	568(%rsp), %rsp
	movq	24(%rsp), %rsi
	movq	16(%rsp), %r8
	orq 	%rax, %rsi
	orq 	%rax, %r8
	movl	(%rcx), %edx
	bswapl	%edx
	movl	%edx, (%rsi)
	movl	4(%rcx), %edx
	bswapl	%edx
	movl	%edx, 4(%rsi)
	movl	8(%rcx), %edx
	bswapl	%edx
	movl	%edx, 8(%rsi)
	movl	12(%rcx), %edx
	bswapl	%edx
	movl	%edx, 12(%rsi)
	movl	16(%rcx), %edx
	bswapl	%edx
	movl	%edx, 16(%rsi)
	movl	20(%rcx), %edx
	bswapl	%edx
	movl	%edx, 20(%rsi)
	movl	24(%rcx), %edx
	bswapl	%edx
	movl	%edx, 24(%rsi)
	movl	28(%rcx), %edx
	bswapl	%edx
	movl	%edx, 28(%rsi)
	ret
.L_sha256_absorb_mem$1:
	movq	%rdx, %r13
	andq	$63, %r13
	addq	%r9, %rdx
	movq	$64, %r10
	subq	%r13, %r10
	cmpq	%r10, %r9
	cmovb	%r9, %r10
	cmpq	$0, %r13
	cmove	%r13, %r10
	subq	%r10, %r9
	movq	%r13, %r11
	movq	%rsi, %rbx
	movq	%r10, %rbp
	movq	%r11, %r14
	negq	%r14
	andq	$7, %r14
	cmpq	%r14, %rbp
	cmovb	%rbp, %r14
	subq	%r14, %rbp
	movq	%r11, %r12
	addq	%r14, %r12
	jmp 	.L_sha256_absorb_mem$18
.L_sha256_absorb_mem$19:
	movq	$-1, %r14
	cmovnb	%r14, %rax
	movzbq	(%rbx), %r14
	movb	%r14b, (%r8,%r11)
	incq	%r11
	incq	%rbx
.L_sha256_absorb_mem$18:
	cmpq	%r12, %r11
	jb  	.L_sha256_absorb_mem$19
	movq	$-1, %r12
	cmovb	%r12, %rax
	jmp 	.L_sha256_absorb_mem$16
.L_sha256_absorb_mem$17:
	movq	$-1, %r12
	cmovb	%r12, %rax
	movq	(%rbx), %r14
	movq	%r14, (%r8,%r11)
	addq	$8, %r11
	addq	$8, %rbx
	addq	$-8, %rbp
.L_sha256_absorb_mem$16:
	cmpq	$8, %rbp
	jnb 	.L_sha256_absorb_mem$17
	movq	$-1, %r12
	cmovnb	%r12, %rax
	movq	%r11, %r12
	addq	%rbp, %r12
	jmp 	.L_sha256_absorb_mem$14
.L_sha256_absorb_mem$15:
	movq	$-1, %rbp
	cmovnb	%rbp, %rax
	movzbq	(%rbx), %r14
	movb	%r14b, (%r8,%r11)
	incq	%r11
	incq	%rbx
.L_sha256_absorb_mem$14:
	cmpq	%r12, %r11
	jb  	.L_sha256_absorb_mem$15
	movq	$-1, %r11
	cmovb	%r11, %rax
	addq	%r10, %r13
	addq	%r10, %rsi
	cmpq	$64, %r13
	je  	.L_sha256_absorb_mem$11
	movq	$-1, %r10
	cmove	%r10, %rax
	jmp 	.L_sha256_absorb_mem$12
.L_sha256_absorb_mem$11:
	movq	$-1, %r10
	cmovne	%r10, %rax
	movq	%rdx, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%r9, 24(%rsp)
	movq	%r8, 32(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress$1
.L_sha256_absorb_mem$13:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rdx
	movq	16(%rsp), %rsi
	movq	24(%rsp), %r9
	movq	32(%rsp), %r8
	orq 	%rax, %rdx
	orq 	%rax, %rsi
	orq 	%rax, %r9
	orq 	%rax, %r8
	movq	$0, %r13
.L_sha256_absorb_mem$12:
	movq	$0, %r11
	movq	%r9, %r10
	shrq	$6, %r10
	cmpq	$0, %r10
	jne 	.L_sha256_absorb_mem$8
	movq	$-1, %r10
	cmovne	%r10, %rax
	jmp 	.L_sha256_absorb_mem$9
.L_sha256_absorb_mem$8:
	movq	$-1, %r11
	cmove	%r11, %rax
	movq	%rdx, 32(%rsp)
	movq	%rsi, 24(%rsp)
	movq	%r9, 16(%rsp)
	movq	%r8, 8(%rsp)
	leaq	-24(%rsp), %rsp
	call	.L_sha256_compress_blocks$1
.L_sha256_absorb_mem$10:
	leaq	24(%rsp), %rsp
	movq	32(%rsp), %rdx
	movq	24(%rsp), %rsi
	movq	16(%rsp), %r9
	movq	8(%rsp), %r8
	orq 	%rax, %rdx
	orq 	%rax, %rsi
	orq 	%rax, %r9
	orq 	%rax, %r8
	movq	%r9, %r11
	shrq	$6, %r11
	shlq	$6, %r11
	movq	$0, %r13
.L_sha256_absorb_mem$9:
	subq	%r11, %r9
	addq	%r11, %rsi
	movq	%r13, %r10
	negq	%r10
	andq	$7, %r10
	cmpq	%r10, %r9
	cmovb	%r9, %r10
	subq	%r10, %r9
	movq	%r13, %r11
	addq	%r10, %r11
	jmp 	.L_sha256_absorb_mem$6
.L_sha256_absorb_mem$7:
	movq	$-1, %r10
	cmovnb	%r10, %rax
	movzbq	(%rsi), %r10
	movb	%r10b, (%r8,%r13)
	incq	%r13
	incq	%rsi
.L_sha256_absorb_mem$6:
	cmpq	%r11, %r13
	jb  	.L_sha256_absorb_mem$7
	movq	$-1, %r10
	cmovb	%r10, %rax
	jmp 	.L_sha256_absorb_mem$4
.L_sha256_absorb_mem$5:
	movq	$-1, %r10
	cmovb	%r10, %rax
	movq	(%rsi), %r10
	movq	%r10, (%r8,%r13)
	addq	$8, %r13
	addq	$8, %rsi
	addq	$-8, %r9
.L_sha256_absorb_mem$4:
	cmpq	$8, %r9
	jnb 	.L_sha256_absorb_mem$5
	movq	$-1, %r10
	cmovnb	%r10, %rax
	movq	%r13, %r11
	addq	%r9, %r11
	jmp 	.L_sha256_absorb_mem$2
.L_sha256_absorb_mem$3:
	movq	$-1, %r9
	cmovnb	%r9, %rax
	movzbq	(%rsi), %r9
	movb	%r9b, (%r8,%r13)
	incq	%r13
	incq	%rsi
.L_sha256_absorb_mem$2:
	cmpq	%r11, %r13
	jb  	.L_sha256_absorb_mem$3
	movq	$-1, %rsi
	cmovb	%rsi, %rax
	ret
.L_sha256_compress_blocks$1:
	jmp 	.L_sha256_compress_blocks$5
.L_sha256_compress_blocks$6:
	movq	$-1, %rdx
	cmovb	%rdx, %rax
	movq	%rsi, 8(%rsp)
	movq	%r10, 16(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_compress_two$1
.L_sha256_compress_blocks$7:
	leaq	568(%rsp), %rsp
	movq	8(%rsp), %rsi
	movq	16(%rsp), %r10
	orq 	%rax, %rsi
	orq 	%rax, %r10
	addq	$128, %rsi
	addq	$-2, %r10
.L_sha256_compress_blocks$5:
	cmpq	$2, %r10
	jnb 	.L_sha256_compress_blocks$6
	movq	$-1, %rdx
	cmovnb	%rdx, %rax
	cmpq	$0, %r10
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
	leaq	glob_data + 32(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	movl	(%rcx), %edx
	movl	4(%rcx), %esi
	movl	8(%rcx), %r8d
	movl	12(%rcx), %r9d
	movl	16(%rcx), %r10d
	movl	20(%rcx), %r11d
	movl	24(%rcx), %ebx
	movl	28(%rcx), %ebp
	movq	%rcx, 544(%rsp)
	movl	%esi, %r12d
	xorl	%r8d, %r12d
	movl	$0, %ecx
	addl	32(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	36(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	40(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	64(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	68(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	96(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	100(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	104(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	128(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	132(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	160(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	164(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	168(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	192(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	196(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	224(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	228(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	232(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	256(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	260(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	288(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	292(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	296(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	320(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	324(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	352(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	356(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	360(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	384(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	388(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	416(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	420(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	424(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	428(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	448(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	452(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	456(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	460(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	480(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	484(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	488(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	492(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	512(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	516(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	520(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	524(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	%r13d, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %r8d
	movl	%r8d, 8(%rcx)
	addl	12(%rcx), %r9d
	movl	%r9d, 12(%rcx)
	addl	16(%rcx), %r10d
	movl	%r10d, 16(%rcx)
	addl	20(%rcx), %r11d
	movl	%r11d, 20(%rcx)
	addl	24(%rcx), %ebx
	movl	%ebx, 24(%rcx)
	addl	28(%rcx), %ebp
	movl	%ebp, 28(%rcx)
	movq	%rcx, 544(%rsp)
	movl	%esi, %r12d
	xorl	%r8d, %r12d
	movl	$0, %ecx
	addl	48(%rsp), %ebp
	addl	%ecx, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	52(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	56(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	60(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	80(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	84(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	88(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	92(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	112(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	116(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	120(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	124(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	144(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	148(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	152(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	156(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	176(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	180(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	184(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	188(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	208(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	212(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	216(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	220(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	240(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	244(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	248(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	252(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	272(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	276(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	280(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	284(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	304(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	308(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	312(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	316(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	336(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	340(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	344(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	348(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	368(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	372(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	376(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	380(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	400(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	404(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	408(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	412(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	432(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	436(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	440(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	444(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	464(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	468(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	472(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	476(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	496(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	500(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	504(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	508(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	528(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	532(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	536(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	540(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	%r13d, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %r8d
	movl	%r8d, 8(%rcx)
	addl	12(%rcx), %r9d
	movl	%r9d, 12(%rcx)
	addl	16(%rcx), %r10d
	movl	%r10d, 16(%rcx)
	addl	20(%rcx), %r11d
	movl	%r11d, 20(%rcx)
	addl	24(%rcx), %ebx
	movl	%ebx, 24(%rcx)
	addl	28(%rcx), %ebp
	movl	%ebp, 28(%rcx)
	ret
.L_sha256_compress_one$1:
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
	movl	8(%rcx), %r8d
	movl	12(%rcx), %r9d
	movl	16(%rcx), %r10d
	movl	20(%rcx), %r11d
	movl	24(%rcx), %ebx
	movl	28(%rcx), %ebp
	movq	%rcx, 544(%rsp)
	movl	%esi, %r12d
	xorl	%r8d, %r12d
	movl	$0, %ecx
	addl	32(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	36(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	40(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	64(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	68(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	96(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	100(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	104(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	128(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	132(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	160(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	164(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	168(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	192(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	196(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	224(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	228(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	232(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	256(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	260(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	288(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	292(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	296(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	320(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	324(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	352(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	356(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	360(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	384(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	388(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	416(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	420(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	424(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	428(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	448(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	452(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	456(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	460(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	480(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	484(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	488(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	492(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	512(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	516(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	520(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	524(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	%r13d, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %r8d
	movl	%r8d, 8(%rcx)
	addl	12(%rcx), %r9d
	movl	%r9d, 12(%rcx)
	addl	16(%rcx), %r10d
	movl	%r10d, 16(%rcx)
	addl	20(%rcx), %r11d
	movl	%r11d, 20(%rcx)
	addl	24(%rcx), %ebx
	movl	%ebx, 24(%rcx)
	addl	28(%rcx), %ebp
	movl	%ebp, 28(%rcx)
	ret
.L_sha256_compress$1:
	leaq	glob_data + 64(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
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
	leaq	glob_data + 32(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 0(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	movl	(%rcx), %edx
	movl	4(%rcx), %esi
	movl	8(%rcx), %r8d
	movl	12(%rcx), %r9d
	movl	16(%rcx), %r10d
	movl	20(%rcx), %r11d
	movl	24(%rcx), %ebx
	movl	28(%rcx), %ebp
	movq	%rcx, 544(%rsp)
	movl	%esi, %r12d
	xorl	%r8d, %r12d
	movl	$0, %ecx
	addl	32(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%ecx, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	36(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	40(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 160(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsp)
	addl	44(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	64(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	68(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	72(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 176(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsp)
	addl	76(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	96(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	100(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	104(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 192(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsp)
	addl	108(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	128(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	132(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	136(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 208(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsp)
	addl	140(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	160(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	164(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	168(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 224(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsp)
	addl	172(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	192(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	196(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	200(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 240(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsp)
	addl	204(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	224(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	228(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	232(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 256(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsp)
	addl	236(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	256(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	260(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	264(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 272(%rip), %ymm6
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsp)
	addl	268(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	288(%rsp), %ebp
	vpalignr	$4, %ymm2, %ymm3, %ymm6
	vpalignr	$4, %ymm4, %ymm5, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm2, %ymm2
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	292(%rsp), %ebx
	vpshufd	$250, %ymm5, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	296(%rsp), %r11d
	vpshufd	$80, %ymm2, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm2, %ymm2
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 288(%rip), %ymm6
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsp)
	addl	300(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	320(%rsp), %r9d
	vpalignr	$4, %ymm3, %ymm4, %ymm6
	vpalignr	$4, %ymm5, %ymm2, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm3, %ymm3
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	324(%rsp), %r8d
	vpshufd	$250, %ymm2, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	328(%rsp), %esi
	vpshufd	$80, %ymm3, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm3, %ymm3
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 304(%rip), %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsp)
	addl	332(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	352(%rsp), %ebp
	vpalignr	$4, %ymm4, %ymm5, %ymm6
	vpalignr	$4, %ymm2, %ymm3, %ymm7
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	vpaddd	%ymm7, %ymm4, %ymm4
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	356(%rsp), %ebx
	vpshufd	$250, %ymm3, %ymm6
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	360(%rsp), %r11d
	vpshufd	$80, %ymm4, %ymm6
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	vpaddd	%ymm8, %ymm4, %ymm4
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	vbroadcasti128	glob_data + 320(%rip), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsp)
	addl	364(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	384(%rsp), %r9d
	vpalignr	$4, %ymm5, %ymm2, %ymm6
	vpalignr	$4, %ymm3, %ymm4, %ymm7
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	vpaddd	%ymm7, %ymm5, %ymm5
	vpsrld	$7, %ymm6, %ymm7
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	vpsrld	$3, %ymm6, %ymm8
	vpslld	$14, %ymm6, %ymm6
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	vpxor	%ymm7, %ymm8, %ymm8
	vpsrld	$11, %ymm7, %ymm7
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	vpslld	$11, %ymm6, %ymm6
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	vpxor	%ymm7, %ymm8, %ymm8
	vpxor	%ymm6, %ymm8, %ymm8
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	388(%rsp), %r8d
	vpshufd	$250, %ymm4, %ymm6
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	vpshufb	%ymm0, %ymm8, %ymm8
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	392(%rsp), %esi
	vpshufd	$80, %ymm5, %ymm6
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	vpsrld	$10, %ymm6, %ymm8
	vpsrlq	$17, %ymm6, %ymm6
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	vpxor	%ymm6, %ymm8, %ymm8
	vpsrlq	$2, %ymm6, %ymm6
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	vpxor	%ymm6, %ymm8, %ymm8
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	vpshufb	%ymm1, %ymm8, %ymm8
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	vpaddd	%ymm8, %ymm5, %ymm5
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	vbroadcasti128	glob_data + 336(%rip), %ymm0
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	addl	396(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	416(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	420(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	424(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	428(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	448(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	452(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	456(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	460(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	480(%rsp), %ebp
	addl	%r13d, %edx
	movl	%r11d, %ecx
	andl	%r10d, %ecx
	rorx	$25, %r10d, %r13d
	rorx	$11, %r10d, %r14d
	addl	%ecx, %ebp
	andnl	%ebx, %r10d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r10d, %r14d
	addl	%ecx, %ebp
	xorl	%r14d, %r13d
	movl	%edx, %ecx
	rorx	$22, %edx, %r14d
	addl	%r13d, %ebp
	xorl	%esi, %ecx
	rorx	$13, %edx, %r13d
	rorx	$2, %edx, %r15d
	addl	%ebp, %r9d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%esi, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %ebp
	addl	484(%rsp), %ebx
	addl	%r13d, %ebp
	movl	%r10d, %r14d
	andl	%r9d, %r14d
	rorx	$25, %r9d, %r13d
	rorx	$11, %r9d, %r12d
	addl	%r14d, %ebx
	andnl	%r11d, %r9d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r9d, %r12d
	addl	%r14d, %ebx
	xorl	%r12d, %r13d
	movl	%ebp, %r12d
	rorx	$22, %ebp, %r14d
	addl	%r13d, %ebx
	xorl	%edx, %r12d
	rorx	$13, %ebp, %r13d
	rorx	$2, %ebp, %r15d
	addl	%ebx, %r8d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%edx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %ebx
	addl	488(%rsp), %r11d
	addl	%r13d, %ebx
	movl	%r9d, %ecx
	andl	%r8d, %ecx
	rorx	$25, %r8d, %r13d
	rorx	$11, %r8d, %r14d
	addl	%ecx, %r11d
	andnl	%r10d, %r8d, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %r8d, %r14d
	addl	%ecx, %r11d
	xorl	%r14d, %r13d
	movl	%ebx, %ecx
	rorx	$22, %ebx, %r14d
	addl	%r13d, %r11d
	xorl	%ebp, %ecx
	rorx	$13, %ebx, %r13d
	rorx	$2, %ebx, %r15d
	addl	%r11d, %esi
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%ebp, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r11d
	addl	492(%rsp), %r10d
	addl	%r13d, %r11d
	movl	%r8d, %r14d
	andl	%esi, %r14d
	rorx	$25, %esi, %r13d
	rorx	$11, %esi, %r12d
	addl	%r14d, %r10d
	andnl	%r9d, %esi, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %esi, %r12d
	addl	%r14d, %r10d
	xorl	%r12d, %r13d
	movl	%r11d, %r12d
	rorx	$22, %r11d, %r14d
	addl	%r13d, %r10d
	xorl	%ebx, %r12d
	rorx	$13, %r11d, %r13d
	rorx	$2, %r11d, %r15d
	addl	%r10d, %edx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%ebx, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r10d
	addl	512(%rsp), %r9d
	addl	%r13d, %r10d
	movl	%esi, %ecx
	andl	%edx, %ecx
	rorx	$25, %edx, %r13d
	rorx	$11, %edx, %r14d
	addl	%ecx, %r9d
	andnl	%r8d, %edx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %edx, %r14d
	addl	%ecx, %r9d
	xorl	%r14d, %r13d
	movl	%r10d, %ecx
	rorx	$22, %r10d, %r14d
	addl	%r13d, %r9d
	xorl	%r11d, %ecx
	rorx	$13, %r10d, %r13d
	rorx	$2, %r10d, %r15d
	addl	%r9d, %ebp
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r11d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %r9d
	addl	516(%rsp), %r8d
	addl	%r13d, %r9d
	movl	%edx, %r14d
	andl	%ebp, %r14d
	rorx	$25, %ebp, %r13d
	rorx	$11, %ebp, %r12d
	addl	%r14d, %r8d
	andnl	%esi, %ebp, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %ebp, %r12d
	addl	%r14d, %r8d
	xorl	%r12d, %r13d
	movl	%r9d, %r12d
	rorx	$22, %r9d, %r14d
	addl	%r13d, %r8d
	xorl	%r10d, %r12d
	rorx	$13, %r9d, %r13d
	rorx	$2, %r9d, %r15d
	addl	%r8d, %ebx
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r10d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %r8d
	addl	520(%rsp), %esi
	addl	%r13d, %r8d
	movl	%ebp, %ecx
	andl	%ebx, %ecx
	rorx	$25, %ebx, %r13d
	rorx	$11, %ebx, %r14d
	addl	%ecx, %esi
	andnl	%edx, %ebx, %ecx
	xorl	%r14d, %r13d
	rorx	$6, %ebx, %r14d
	addl	%ecx, %esi
	xorl	%r14d, %r13d
	movl	%r8d, %ecx
	rorx	$22, %r8d, %r14d
	addl	%r13d, %esi
	xorl	%r9d, %ecx
	rorx	$13, %r8d, %r13d
	rorx	$2, %r8d, %r15d
	addl	%esi, %r11d
	andl	%ecx, %r12d
	xorl	%r14d, %r13d
	xorl	%r9d, %r12d
	xorl	%r15d, %r13d
	addl	%r12d, %esi
	addl	524(%rsp), %edx
	addl	%r13d, %esi
	movl	%ebx, %r14d
	andl	%r11d, %r14d
	rorx	$25, %r11d, %r13d
	rorx	$11, %r11d, %r12d
	addl	%r14d, %edx
	andnl	%ebp, %r11d, %r14d
	xorl	%r12d, %r13d
	rorx	$6, %r11d, %r12d
	addl	%r14d, %edx
	xorl	%r12d, %r13d
	movl	%esi, %r12d
	rorx	$22, %esi, %r14d
	addl	%r13d, %edx
	xorl	%r8d, %r12d
	rorx	$13, %esi, %r13d
	rorx	$2, %esi, %r15d
	addl	%edx, %r10d
	andl	%r12d, %ecx
	xorl	%r14d, %r13d
	xorl	%r8d, %ecx
	xorl	%r15d, %r13d
	addl	%ecx, %edx
	addl	%r13d, %edx
	movq	544(%rsp), %rcx
	orq 	%rax, %rcx
	addl	(%rcx), %edx
	movl	%edx, (%rcx)
	addl	4(%rcx), %esi
	movl	%esi, 4(%rcx)
	addl	8(%rcx), %r8d
	movl	%r8d, 8(%rcx)
	addl	12(%rcx), %r9d
	movl	%r9d, 12(%rcx)
	addl	16(%rcx), %r10d
	movl	%r10d, 16(%rcx)
	addl	20(%rcx), %r11d
	movl	%r11d, 20(%rcx)
	addl	24(%rcx), %ebx
	movl	%ebx, 24(%rcx)
	addl	28(%rcx), %ebp
	movl	%ebp, 28(%rcx)
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
G$SHA224_IV:
	.byte	216, 158,   5, 193,   7, 213, 124,  54,  23, 221, 112,  48,  57,  89,  14, 247
	.byte	 49,  11, 192, 255,  17,  21,  88, 104, 167, 143, 249, 100, 164,  79, 250, 190
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
