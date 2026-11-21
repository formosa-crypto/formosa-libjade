	.att_syntax
	.text
	.p2align	5
	.global	jade_hash_sha256x8_amd64_avx2_final
	.global	jade_hash_sha256x8_amd64_avx2_update
	.global	jade_hash_sha256x8_amd64_avx2_init_from
	.global	jade_hash_sha256x8_amd64_avx2_init
	.global	jade_hash_sha256x8_amd64_avx2
	.type	jade_hash_sha256x8_amd64_avx2_final, %function
jade_hash_sha256x8_amd64_avx2_final:
	movq	%rsp, %rax
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r14, 24(%rsp)
	movq	%rax, 32(%rsp)
	lfence
	movq	$0, %rdx
	leaq	-24(%rsp), %rsp
	call	.L_sha256_x8_ctx_final$1
.Ljade_hash_sha256x8_amd64_avx2_final$1:
	leaq	24(%rsp), %rsp
	movq	%r9, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r14
	movq	32(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$704, %rsp
	movq	$704, %rdi
.Ljade_hash_sha256x8_amd64_avx2_final$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha256x8_amd64_avx2_final$2
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha256x8_amd64_avx2_update, %function
jade_hash_sha256x8_amd64_avx2_update:
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
	movq	%rsi, %r8
	movq	%rdx, %r10
	lfence
	movq	$0, %rdx
	leaq	-24(%rsp), %rsp
	call	.L_sha256_x8_ctx_update$1
.Ljade_hash_sha256x8_amd64_avx2_update$1:
	leaq	24(%rsp), %rsp
	movq	%r9, %rax
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
.Ljade_hash_sha256x8_amd64_avx2_update$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha256x8_amd64_avx2_update$2
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha256x8_amd64_avx2_init_from, %function
jade_hash_sha256x8_amd64_avx2_init_from:
	movq	%rsp, %r10
	andq	$-32, %rsp
	lfence
	movq	$0, %rdx
	call	.L_sha256_x8_ctx_from$1
.Ljade_hash_sha256x8_amd64_avx2_init_from$1:
	movq	%r9, %rax
	movq	%r10, %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$32, %rsp
	movq	$32, %rdi
.Ljade_hash_sha256x8_amd64_avx2_init_from$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha256x8_amd64_avx2_init_from$2
	movq	%rsi, %rsp
	ret
	.type	jade_hash_sha256x8_amd64_avx2_init, %function
jade_hash_sha256x8_amd64_avx2_init:
	lfence
	movq	$0, %rdx
	movq	$1139011577971, %rax
	movq	%rax, (%rdi)
	movq	$0, %rax
	movq	%rax, 8(%rdi)
	leaq	16(%rdi), %r11
	leaq	glob_data + 2080(%rip), %rcx
	movl	(%rcx), %edx
	movl	%edx, (%r11)
	movl	%edx, 4(%r11)
	movl	%edx, 8(%r11)
	movl	%edx, 12(%r11)
	movl	%edx, 16(%r11)
	movl	%edx, 20(%r11)
	movl	%edx, 24(%r11)
	movl	%edx, 28(%r11)
	movl	4(%rcx), %edx
	movl	%edx, 32(%r11)
	movl	%edx, 36(%r11)
	movl	%edx, 40(%r11)
	movl	%edx, 44(%r11)
	movl	%edx, 48(%r11)
	movl	%edx, 52(%r11)
	movl	%edx, 56(%r11)
	movl	%edx, 60(%r11)
	movl	8(%rcx), %edx
	movl	%edx, 64(%r11)
	movl	%edx, 68(%r11)
	movl	%edx, 72(%r11)
	movl	%edx, 76(%r11)
	movl	%edx, 80(%r11)
	movl	%edx, 84(%r11)
	movl	%edx, 88(%r11)
	movl	%edx, 92(%r11)
	movl	12(%rcx), %edx
	movl	%edx, 96(%r11)
	movl	%edx, 100(%r11)
	movl	%edx, 104(%r11)
	movl	%edx, 108(%r11)
	movl	%edx, 112(%r11)
	movl	%edx, 116(%r11)
	movl	%edx, 120(%r11)
	movl	%edx, 124(%r11)
	movl	16(%rcx), %edx
	movl	%edx, 128(%r11)
	movl	%edx, 132(%r11)
	movl	%edx, 136(%r11)
	movl	%edx, 140(%r11)
	movl	%edx, 144(%r11)
	movl	%edx, 148(%r11)
	movl	%edx, 152(%r11)
	movl	%edx, 156(%r11)
	movl	20(%rcx), %edx
	movl	%edx, 160(%r11)
	movl	%edx, 164(%r11)
	movl	%edx, 168(%r11)
	movl	%edx, 172(%r11)
	movl	%edx, 176(%r11)
	movl	%edx, 180(%r11)
	movl	%edx, 184(%r11)
	movl	%edx, 188(%r11)
	movl	24(%rcx), %edx
	movl	%edx, 192(%r11)
	movl	%edx, 196(%r11)
	movl	%edx, 200(%r11)
	movl	%edx, 204(%r11)
	movl	%edx, 208(%r11)
	movl	%edx, 212(%r11)
	movl	%edx, 216(%r11)
	movl	%edx, 220(%r11)
	movl	28(%rcx), %edx
	movl	%edx, 224(%r11)
	movl	%edx, 228(%r11)
	movl	%edx, 232(%r11)
	movl	%edx, 236(%r11)
	movl	%edx, 240(%r11)
	movl	%edx, 244(%r11)
	movl	%edx, 248(%r11)
	movl	%edx, 252(%r11)
	movq	%rax, 272(%rdi)
	movq	%rax, 280(%rdi)
	movq	%rax, 288(%rdi)
	movq	%rax, 296(%rdi)
	movq	%rax, 304(%rdi)
	movq	%rax, 312(%rdi)
	movq	%rax, 320(%rdi)
	movq	%rax, 328(%rdi)
	movq	%rax, 336(%rdi)
	movq	%rax, 344(%rdi)
	movq	%rax, 352(%rdi)
	movq	%rax, 360(%rdi)
	movq	%rax, 368(%rdi)
	movq	%rax, 376(%rdi)
	movq	%rax, 384(%rdi)
	movq	%rax, 392(%rdi)
	movq	%rax, 400(%rdi)
	movq	%rax, 408(%rdi)
	movq	%rax, 416(%rdi)
	movq	%rax, 424(%rdi)
	movq	%rax, 432(%rdi)
	movq	%rax, 440(%rdi)
	movq	%rax, 448(%rdi)
	movq	%rax, 456(%rdi)
	movq	%rax, 464(%rdi)
	movq	%rax, 472(%rdi)
	movq	%rax, 480(%rdi)
	movq	%rax, 488(%rdi)
	movq	%rax, 496(%rdi)
	movq	%rax, 504(%rdi)
	movq	%rax, 512(%rdi)
	movq	%rax, 520(%rdi)
	movq	%rax, 528(%rdi)
	movq	%rax, 536(%rdi)
	movq	%rax, 544(%rdi)
	movq	%rax, 552(%rdi)
	movq	%rax, 560(%rdi)
	movq	%rax, 568(%rdi)
	movq	%rax, 576(%rdi)
	movq	%rax, 584(%rdi)
	movq	%rax, 592(%rdi)
	movq	%rax, 600(%rdi)
	movq	%rax, 608(%rdi)
	movq	%rax, 616(%rdi)
	movq	%rax, 624(%rdi)
	movq	%rax, 632(%rdi)
	movq	%rax, 640(%rdi)
	movq	%rax, 648(%rdi)
	movq	%rax, 656(%rdi)
	movq	%rax, 664(%rdi)
	movq	%rax, 672(%rdi)
	movq	%rax, 680(%rdi)
	movq	%rax, 688(%rdi)
	movq	%rax, 696(%rdi)
	movq	%rax, 704(%rdi)
	movq	%rax, 712(%rdi)
	movq	%rax, 720(%rdi)
	movq	%rax, 728(%rdi)
	movq	%rax, 736(%rdi)
	movq	%rax, 744(%rdi)
	movq	%rax, 752(%rdi)
	movq	%rax, 760(%rdi)
	movq	%rax, 768(%rdi)
	movq	%rax, 776(%rdi)
	ret
	.type	jade_hash_sha256x8_amd64_avx2, %function
jade_hash_sha256x8_amd64_avx2:
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
	movq	%rsi, %r8
	movq	%rdx, %r10
	lfence
	movq	$0, %rdx
	leaq	-824(%rsp), %rsp
	call	.L_sha256_x8_lanes$1
.Ljade_hash_sha256x8_amd64_avx2$1:
	leaq	824(%rsp), %rsp
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
	subq	$1568, %rsp
	movq	$1568, %rdi
.Ljade_hash_sha256x8_amd64_avx2$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_hash_sha256x8_amd64_avx2$2
	movq	%rsi, %rsp
	ret
.L_sha256_x8_ctx_final$1:
	movq	%rdi, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
// declassify_val u64 %rcx
// declassify_val u64 %rax
	orq 	%rdx, %rcx
	orq 	%rdx, %rax
	movq	$1139011577971, %r8
	movq	$1, %r9
	cmpq	%r8, %rcx
	je  	.L_sha256_x8_ctx_final$2
	movq	$-1, %rax
	cmove	%rax, %rdx
	jmp 	.L_sha256_x8_ctx_final$3
.L_sha256_x8_ctx_final$2:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	leaq	16(%rdi), %r11
	leaq	272(%rdi), %rcx
	leaq	-24(%rsp), %rsp
	call	.L_sha256_x8_finalize$1
.L_sha256_x8_ctx_final$4:
	leaq	24(%rsp), %rsp
	movq	$0, %rax
	movq	%rax, (%rdi)
	movq	%rax, 8(%rdi)
	movq	%rax, 16(%rdi)
	movq	%rax, 24(%rdi)
	movq	%rax, 32(%rdi)
	movq	%rax, 40(%rdi)
	movq	%rax, 48(%rdi)
	movq	%rax, 56(%rdi)
	movq	%rax, 64(%rdi)
	movq	%rax, 72(%rdi)
	movq	%rax, 80(%rdi)
	movq	%rax, 88(%rdi)
	movq	%rax, 96(%rdi)
	movq	%rax, 104(%rdi)
	movq	%rax, 112(%rdi)
	movq	%rax, 120(%rdi)
	movq	%rax, 128(%rdi)
	movq	%rax, 136(%rdi)
	movq	%rax, 144(%rdi)
	movq	%rax, 152(%rdi)
	movq	%rax, 160(%rdi)
	movq	%rax, 168(%rdi)
	movq	%rax, 176(%rdi)
	movq	%rax, 184(%rdi)
	movq	%rax, 192(%rdi)
	movq	%rax, 200(%rdi)
	movq	%rax, 208(%rdi)
	movq	%rax, 216(%rdi)
	movq	%rax, 224(%rdi)
	movq	%rax, 232(%rdi)
	movq	%rax, 240(%rdi)
	movq	%rax, 248(%rdi)
	movq	%rax, 256(%rdi)
	movq	%rax, 264(%rdi)
	movq	%rax, 272(%rdi)
	movq	%rax, 280(%rdi)
	movq	%rax, 288(%rdi)
	movq	%rax, 296(%rdi)
	movq	%rax, 304(%rdi)
	movq	%rax, 312(%rdi)
	movq	%rax, 320(%rdi)
	movq	%rax, 328(%rdi)
	movq	%rax, 336(%rdi)
	movq	%rax, 344(%rdi)
	movq	%rax, 352(%rdi)
	movq	%rax, 360(%rdi)
	movq	%rax, 368(%rdi)
	movq	%rax, 376(%rdi)
	movq	%rax, 384(%rdi)
	movq	%rax, 392(%rdi)
	movq	%rax, 400(%rdi)
	movq	%rax, 408(%rdi)
	movq	%rax, 416(%rdi)
	movq	%rax, 424(%rdi)
	movq	%rax, 432(%rdi)
	movq	%rax, 440(%rdi)
	movq	%rax, 448(%rdi)
	movq	%rax, 456(%rdi)
	movq	%rax, 464(%rdi)
	movq	%rax, 472(%rdi)
	movq	%rax, 480(%rdi)
	movq	%rax, 488(%rdi)
	movq	%rax, 496(%rdi)
	movq	%rax, 504(%rdi)
	movq	%rax, 512(%rdi)
	movq	%rax, 520(%rdi)
	movq	%rax, 528(%rdi)
	movq	%rax, 536(%rdi)
	movq	%rax, 544(%rdi)
	movq	%rax, 552(%rdi)
	movq	%rax, 560(%rdi)
	movq	%rax, 568(%rdi)
	movq	%rax, 576(%rdi)
	movq	%rax, 584(%rdi)
	movq	%rax, 592(%rdi)
	movq	%rax, 600(%rdi)
	movq	%rax, 608(%rdi)
	movq	%rax, 616(%rdi)
	movq	%rax, 624(%rdi)
	movq	%rax, 632(%rdi)
	movq	%rax, 640(%rdi)
	movq	%rax, 648(%rdi)
	movq	%rax, 656(%rdi)
	movq	%rax, 664(%rdi)
	movq	%rax, 672(%rdi)
	movq	%rax, 680(%rdi)
	movq	%rax, 688(%rdi)
	movq	%rax, 696(%rdi)
	movq	%rax, 704(%rdi)
	movq	%rax, 712(%rdi)
	movq	%rax, 720(%rdi)
	movq	%rax, 728(%rdi)
	movq	%rax, 736(%rdi)
	movq	%rax, 744(%rdi)
	movq	%rax, 752(%rdi)
	movq	%rax, 760(%rdi)
	movq	%rax, 768(%rdi)
	movq	%rax, 776(%rdi)
	movq	$0, %r9
.L_sha256_x8_ctx_final$3:
	ret
.L_sha256_x8_ctx_update$1:
	movq	%rdi, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
// declassify_val u64 %rcx
// declassify_val u64 %rax
	orq 	%rdx, %rcx
	orq 	%rdx, %rax
	movq	$1139011577971, %rsi
	movq	$1, %r9
	cmpq	%rsi, %rcx
	je  	.L_sha256_x8_ctx_update$2
	movq	$-1, %rax
	cmove	%rax, %rdx
	jmp 	.L_sha256_x8_ctx_update$3
.L_sha256_x8_ctx_update$2:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	movq	$2305843009213693952, %rsi
	movq	$0, %rcx
	movq	%rsi, %r9
	subq	%rax, %r9
	cmpq	%rsi, %rax
	cmovb	%r9, %rcx
	movq	$2, %r9
	cmpq	%rcx, %r10
	jb  	.L_sha256_x8_ctx_update$4
	movq	$-1, %rax
	cmovb	%rax, %rdx
	jmp 	.L_sha256_x8_ctx_update$3
.L_sha256_x8_ctx_update$4:
	movq	$-1, %rcx
	cmovnb	%rcx, %rdx
	leaq	16(%rdi), %r11
	leaq	272(%rdi), %rcx
	leaq	-56(%rsp), %rsp
	call	.L_sha256_x8_absorb_lanes$1
.L_sha256_x8_ctx_update$6:
	leaq	56(%rsp), %rsp
	movq	%rax, 8(%rdi)
	movq	$0, %r9
.L_sha256_x8_ctx_update$5:
.L_sha256_x8_ctx_update$3:
	ret
.L_sha256_x8_ctx_from$1:
	movq	%rsi, %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
// declassify_val u64 %rcx
// declassify_val u64 %rax
	orq 	%rdx, %rcx
	orq 	%rdx, %rax
	movq	$1108946806899, %r8
	movq	$1, %r9
	cmpq	%r8, %rcx
	je  	.L_sha256_x8_ctx_from$2
	movq	$-1, %rax
	cmove	%rax, %rdx
	jmp 	.L_sha256_x8_ctx_from$3
.L_sha256_x8_ctx_from$2:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	movq	$1139011577971, %r8
	movq	%r8, (%rdi)
	movq	%rax, 8(%rdi)
	leaq	16(%rdi), %r11
	leaq	272(%rdi), %rcx
	leaq	16(%rsi), %rdx
	leaq	48(%rsi), %rax
	movl	(%rdx), %esi
	movl	%esi, (%r11)
	movl	%esi, 4(%r11)
	movl	%esi, 8(%r11)
	movl	%esi, 12(%r11)
	movl	%esi, 16(%r11)
	movl	%esi, 20(%r11)
	movl	%esi, 24(%r11)
	movl	%esi, 28(%r11)
	movl	4(%rdx), %esi
	movl	%esi, 32(%r11)
	movl	%esi, 36(%r11)
	movl	%esi, 40(%r11)
	movl	%esi, 44(%r11)
	movl	%esi, 48(%r11)
	movl	%esi, 52(%r11)
	movl	%esi, 56(%r11)
	movl	%esi, 60(%r11)
	movl	8(%rdx), %esi
	movl	%esi, 64(%r11)
	movl	%esi, 68(%r11)
	movl	%esi, 72(%r11)
	movl	%esi, 76(%r11)
	movl	%esi, 80(%r11)
	movl	%esi, 84(%r11)
	movl	%esi, 88(%r11)
	movl	%esi, 92(%r11)
	movl	12(%rdx), %esi
	movl	%esi, 96(%r11)
	movl	%esi, 100(%r11)
	movl	%esi, 104(%r11)
	movl	%esi, 108(%r11)
	movl	%esi, 112(%r11)
	movl	%esi, 116(%r11)
	movl	%esi, 120(%r11)
	movl	%esi, 124(%r11)
	movl	16(%rdx), %esi
	movl	%esi, 128(%r11)
	movl	%esi, 132(%r11)
	movl	%esi, 136(%r11)
	movl	%esi, 140(%r11)
	movl	%esi, 144(%r11)
	movl	%esi, 148(%r11)
	movl	%esi, 152(%r11)
	movl	%esi, 156(%r11)
	movl	20(%rdx), %esi
	movl	%esi, 160(%r11)
	movl	%esi, 164(%r11)
	movl	%esi, 168(%r11)
	movl	%esi, 172(%r11)
	movl	%esi, 176(%r11)
	movl	%esi, 180(%r11)
	movl	%esi, 184(%r11)
	movl	%esi, 188(%r11)
	movl	24(%rdx), %esi
	movl	%esi, 192(%r11)
	movl	%esi, 196(%r11)
	movl	%esi, 200(%r11)
	movl	%esi, 204(%r11)
	movl	%esi, 208(%r11)
	movl	%esi, 212(%r11)
	movl	%esi, 216(%r11)
	movl	%esi, 220(%r11)
	movl	28(%rdx), %esi
	movl	%esi, 224(%r11)
	movl	%esi, 228(%r11)
	movl	%esi, 232(%r11)
	movl	%esi, 236(%r11)
	movl	%esi, 240(%r11)
	movl	%esi, 244(%r11)
	movl	%esi, 248(%r11)
	movl	%esi, 252(%r11)
	movq	(%rax), %rdx
	movq	%rdx, (%rcx)
	movq	%rdx, 64(%rcx)
	movq	%rdx, 128(%rcx)
	movq	%rdx, 192(%rcx)
	movq	%rdx, 256(%rcx)
	movq	%rdx, 320(%rcx)
	movq	%rdx, 384(%rcx)
	movq	%rdx, 448(%rcx)
	movq	8(%rax), %rdx
	movq	%rdx, 8(%rcx)
	movq	%rdx, 72(%rcx)
	movq	%rdx, 136(%rcx)
	movq	%rdx, 200(%rcx)
	movq	%rdx, 264(%rcx)
	movq	%rdx, 328(%rcx)
	movq	%rdx, 392(%rcx)
	movq	%rdx, 456(%rcx)
	movq	16(%rax), %rdx
	movq	%rdx, 16(%rcx)
	movq	%rdx, 80(%rcx)
	movq	%rdx, 144(%rcx)
	movq	%rdx, 208(%rcx)
	movq	%rdx, 272(%rcx)
	movq	%rdx, 336(%rcx)
	movq	%rdx, 400(%rcx)
	movq	%rdx, 464(%rcx)
	movq	24(%rax), %rdx
	movq	%rdx, 24(%rcx)
	movq	%rdx, 88(%rcx)
	movq	%rdx, 152(%rcx)
	movq	%rdx, 216(%rcx)
	movq	%rdx, 280(%rcx)
	movq	%rdx, 344(%rcx)
	movq	%rdx, 408(%rcx)
	movq	%rdx, 472(%rcx)
	movq	32(%rax), %rdx
	movq	%rdx, 32(%rcx)
	movq	%rdx, 96(%rcx)
	movq	%rdx, 160(%rcx)
	movq	%rdx, 224(%rcx)
	movq	%rdx, 288(%rcx)
	movq	%rdx, 352(%rcx)
	movq	%rdx, 416(%rcx)
	movq	%rdx, 480(%rcx)
	movq	40(%rax), %rdx
	movq	%rdx, 40(%rcx)
	movq	%rdx, 104(%rcx)
	movq	%rdx, 168(%rcx)
	movq	%rdx, 232(%rcx)
	movq	%rdx, 296(%rcx)
	movq	%rdx, 360(%rcx)
	movq	%rdx, 424(%rcx)
	movq	%rdx, 488(%rcx)
	movq	48(%rax), %rdx
	movq	%rdx, 48(%rcx)
	movq	%rdx, 112(%rcx)
	movq	%rdx, 176(%rcx)
	movq	%rdx, 240(%rcx)
	movq	%rdx, 304(%rcx)
	movq	%rdx, 368(%rcx)
	movq	%rdx, 432(%rcx)
	movq	%rdx, 496(%rcx)
	movq	56(%rax), %rdx
	movq	%rdx, 56(%rcx)
	movq	%rdx, 120(%rcx)
	movq	%rdx, 184(%rcx)
	movq	%rdx, 248(%rcx)
	movq	%rdx, 312(%rcx)
	movq	%rdx, 376(%rcx)
	movq	%rdx, 440(%rcx)
	movq	%rdx, 504(%rcx)
	movq	$0, %r9
.L_sha256_x8_ctx_from$3:
	ret
.L_sha256_x8_lanes$1:
	leaq	32(%rsp), %r11
	leaq	glob_data + 2080(%rip), %rcx
	movl	(%rcx), %eax
	movl	%eax, (%r11)
	movl	%eax, 4(%r11)
	movl	%eax, 8(%r11)
	movl	%eax, 12(%r11)
	movl	%eax, 16(%r11)
	movl	%eax, 20(%r11)
	movl	%eax, 24(%r11)
	movl	%eax, 28(%r11)
	movl	4(%rcx), %eax
	movl	%eax, 32(%r11)
	movl	%eax, 36(%r11)
	movl	%eax, 40(%r11)
	movl	%eax, 44(%r11)
	movl	%eax, 48(%r11)
	movl	%eax, 52(%r11)
	movl	%eax, 56(%r11)
	movl	%eax, 60(%r11)
	movl	8(%rcx), %eax
	movl	%eax, 64(%r11)
	movl	%eax, 68(%r11)
	movl	%eax, 72(%r11)
	movl	%eax, 76(%r11)
	movl	%eax, 80(%r11)
	movl	%eax, 84(%r11)
	movl	%eax, 88(%r11)
	movl	%eax, 92(%r11)
	movl	12(%rcx), %eax
	movl	%eax, 96(%r11)
	movl	%eax, 100(%r11)
	movl	%eax, 104(%r11)
	movl	%eax, 108(%r11)
	movl	%eax, 112(%r11)
	movl	%eax, 116(%r11)
	movl	%eax, 120(%r11)
	movl	%eax, 124(%r11)
	movl	16(%rcx), %eax
	movl	%eax, 128(%r11)
	movl	%eax, 132(%r11)
	movl	%eax, 136(%r11)
	movl	%eax, 140(%r11)
	movl	%eax, 144(%r11)
	movl	%eax, 148(%r11)
	movl	%eax, 152(%r11)
	movl	%eax, 156(%r11)
	movl	20(%rcx), %eax
	movl	%eax, 160(%r11)
	movl	%eax, 164(%r11)
	movl	%eax, 168(%r11)
	movl	%eax, 172(%r11)
	movl	%eax, 176(%r11)
	movl	%eax, 180(%r11)
	movl	%eax, 184(%r11)
	movl	%eax, 188(%r11)
	movl	24(%rcx), %eax
	movl	%eax, 192(%r11)
	movl	%eax, 196(%r11)
	movl	%eax, 200(%r11)
	movl	%eax, 204(%r11)
	movl	%eax, 208(%r11)
	movl	%eax, 212(%r11)
	movl	%eax, 216(%r11)
	movl	%eax, 220(%r11)
	movl	28(%rcx), %eax
	movl	%eax, 224(%r11)
	movl	%eax, 228(%r11)
	movl	%eax, 232(%r11)
	movl	%eax, 236(%r11)
	movl	%eax, 240(%r11)
	movl	%eax, 244(%r11)
	movl	%eax, 248(%r11)
	movl	%eax, 252(%r11)
	leaq	288(%rsp), %rcx
	movq	$0, %rax
	movq	%rdi, 800(%rsp)
	leaq	32(%rsp), %r11
	leaq	-56(%rsp), %rsp
	call	.L_sha256_x8_absorb_lanes$1
.L_sha256_x8_lanes$3:
	leaq	56(%rsp), %rsp
	movq	800(%rsp), %rsi
	orq 	%rdx, %rsi
	leaq	32(%rsp), %r11
	leaq	-24(%rsp), %rsp
	call	.L_sha256_x8_finalize$1
.L_sha256_x8_lanes$2:
	leaq	24(%rsp), %rsp
	ret
.L_sha256_x8_finalize$1:
	movq	%rax, %r9
	andq	$63, %r9
	movq	%r9, %r8
	movq	$128, %r10
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	addq	$64, %r8
	movb	%r10b, (%rcx,%r8)
	incq	%r9
	cmpq	$56, %r9
	jnbe	.L_sha256_x8_finalize$51
	movq	$-1, %r8
	cmovnbe	%r8, %rdx
	jmp 	.L_sha256_x8_finalize$52
.L_sha256_x8_finalize$51:
	movq	$-1, %r8
	cmovbe	%r8, %rdx
	movq	$64, %r8
	movq	%rcx, %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$100
.L_sha256_x8_finalize$101:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$100:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$101
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$98
.L_sha256_x8_finalize$99:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$98:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$99
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$96
.L_sha256_x8_finalize$97:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$96:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$97
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	64(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$94
.L_sha256_x8_finalize$95:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$94:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$95
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$92
.L_sha256_x8_finalize$93:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$92:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$93
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$90
.L_sha256_x8_finalize$91:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$90:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$91
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	128(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$88
.L_sha256_x8_finalize$89:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$88:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$89
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$86
.L_sha256_x8_finalize$87:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$86:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$87
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$84
.L_sha256_x8_finalize$85:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$84:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$85
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	192(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$82
.L_sha256_x8_finalize$83:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$82:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$83
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$80
.L_sha256_x8_finalize$81:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$80:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$81
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$78
.L_sha256_x8_finalize$79:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$78:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$79
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	256(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$76
.L_sha256_x8_finalize$77:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$76:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$77
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$74
.L_sha256_x8_finalize$75:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$74:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$75
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$72
.L_sha256_x8_finalize$73:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$72:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$73
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	320(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$70
.L_sha256_x8_finalize$71:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$70:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$71
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$68
.L_sha256_x8_finalize$69:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$68:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$69
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$66
.L_sha256_x8_finalize$67:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$66:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$67
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	384(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$64
.L_sha256_x8_finalize$65:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$64:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$65
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$62
.L_sha256_x8_finalize$63:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$62:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$63
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$60
.L_sha256_x8_finalize$61:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$60:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$61
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	448(%rcx), %r10
	movq	$0, %rbp
	movq	%r9, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$58
.L_sha256_x8_finalize$59:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%bpl, (%r10,%r9)
	incq	%r9
.L_sha256_x8_finalize$58:
	cmpq	%r14, %r9
	jb  	.L_sha256_x8_finalize$59
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_finalize$56
.L_sha256_x8_finalize$57:
	movq	$-1, %rbx
	cmovnbe	%rbx, %rdx
	movq	%rbp, (%r10,%r9)
	addq	$8, %r9
.L_sha256_x8_finalize$56:
	movq	%r9, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$57
	movq	$-1, %rbx
	cmovbe	%rbx, %rdx
	jmp 	.L_sha256_x8_finalize$54
.L_sha256_x8_finalize$55:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%bpl, (%r10,%r9)
	incq	%r9
.L_sha256_x8_finalize$54:
	cmpq	%r8, %r9
	jb  	.L_sha256_x8_finalize$55
	movq	$-1, %r8
	cmovb	%r8, %rdx
	movq	%rsi, 8(%rsp)
	movq	%rcx, 16(%rsp)
	movq	%rax, 24(%rsp)
	leaq	-536(%rsp), %rsp
	call	.L_sha256_x8_compress$1
.L_sha256_x8_finalize$53:
	leaq	536(%rsp), %rsp
	movq	8(%rsp), %rsi
	movq	16(%rsp), %rcx
	movq	24(%rsp), %rax
	orq 	%rdx, %rsi
	orq 	%rdx, %rcx
	orq 	%rdx, %rax
	movq	$0, %r9
.L_sha256_x8_finalize$52:
	movq	$56, %r8
	movq	%rcx, %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$49
.L_sha256_x8_finalize$50:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$49:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$50
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$47
.L_sha256_x8_finalize$48:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$47:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$48
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$45
.L_sha256_x8_finalize$46:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$45:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$46
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	64(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$43
.L_sha256_x8_finalize$44:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$43:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$44
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$41
.L_sha256_x8_finalize$42:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$41:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$42
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$39
.L_sha256_x8_finalize$40:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$39:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$40
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	128(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$37
.L_sha256_x8_finalize$38:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$37:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$38
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$35
.L_sha256_x8_finalize$36:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$35:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$36
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$33
.L_sha256_x8_finalize$34:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$33:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$34
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	192(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$31
.L_sha256_x8_finalize$32:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$31:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$32
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$29
.L_sha256_x8_finalize$30:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$29:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$30
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$27
.L_sha256_x8_finalize$28:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$27:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$28
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	256(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$25
.L_sha256_x8_finalize$26:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$25:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$26
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$23
.L_sha256_x8_finalize$24:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$23:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$24
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$21
.L_sha256_x8_finalize$22:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$21:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$22
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	320(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$19
.L_sha256_x8_finalize$20:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$19:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$20
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$17
.L_sha256_x8_finalize$18:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$17:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$18
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$15
.L_sha256_x8_finalize$16:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$15:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$16
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	384(%rcx), %r10
	movq	%r9, %rbx
	movq	$0, %rbp
	movq	%rbx, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$13
.L_sha256_x8_finalize$14:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$13:
	cmpq	%r14, %rbx
	jb  	.L_sha256_x8_finalize$14
	movq	$-1, %r12
	cmovb	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$11
.L_sha256_x8_finalize$12:
	movq	$-1, %r12
	cmovnbe	%r12, %rdx
	movq	%rbp, (%r10,%rbx)
	addq	$8, %rbx
.L_sha256_x8_finalize$11:
	movq	%rbx, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$12
	movq	$-1, %r12
	cmovbe	%r12, %rdx
	jmp 	.L_sha256_x8_finalize$9
.L_sha256_x8_finalize$10:
	movq	$-1, %r12
	cmovnb	%r12, %rdx
	movb	%bpl, (%r10,%rbx)
	incq	%rbx
.L_sha256_x8_finalize$9:
	cmpq	%r8, %rbx
	jb  	.L_sha256_x8_finalize$10
	movq	$-1, %r10
	cmovb	%r10, %rdx
	leaq	448(%rcx), %r10
	movq	$0, %rbp
	movq	%r9, %r14
	addq	$7, %r14
	andq	$-8, %r14
	cmpq	%r14, %r8
	cmovb	%r8, %r14
	jmp 	.L_sha256_x8_finalize$7
.L_sha256_x8_finalize$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%bpl, (%r10,%r9)
	incq	%r9
.L_sha256_x8_finalize$7:
	cmpq	%r14, %r9
	jb  	.L_sha256_x8_finalize$8
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_finalize$5
.L_sha256_x8_finalize$6:
	movq	$-1, %rbx
	cmovnbe	%rbx, %rdx
	movq	%rbp, (%r10,%r9)
	addq	$8, %r9
.L_sha256_x8_finalize$5:
	movq	%r9, %r14
	addq	$8, %r14
	cmpq	%r8, %r14
	jbe 	.L_sha256_x8_finalize$6
	movq	$-1, %rbx
	cmovbe	%rbx, %rdx
	jmp 	.L_sha256_x8_finalize$3
.L_sha256_x8_finalize$4:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%bpl, (%r10,%r9)
	incq	%r9
.L_sha256_x8_finalize$3:
	cmpq	%r8, %r9
	jb  	.L_sha256_x8_finalize$4
	movq	$-1, %r8
	cmovb	%r8, %rdx
	shlq	$3, %rax
	bswapq	%rax
	movq	%rax, 56(%rcx)
	movq	%rax, 120(%rcx)
	movq	%rax, 184(%rcx)
	movq	%rax, 248(%rcx)
	movq	%rax, 312(%rcx)
	movq	%rax, 376(%rcx)
	movq	%rax, 440(%rcx)
	movq	%rax, 504(%rcx)
	movq	%rsi, 24(%rsp)
	movq	%rcx, 16(%rsp)
	leaq	-536(%rsp), %rsp
	call	.L_sha256_x8_compress$1
.L_sha256_x8_finalize$2:
	leaq	536(%rsp), %rsp
	movq	24(%rsp), %rsi
	movq	16(%rsp), %rcx
	orq 	%rdx, %rsi
	orq 	%rdx, %rcx
	movl	(%r11), %eax
	bswapl	%eax
	movl	%eax, (%rsi)
	movl	32(%r11), %eax
	bswapl	%eax
	movl	%eax, 4(%rsi)
	movl	64(%r11), %eax
	bswapl	%eax
	movl	%eax, 8(%rsi)
	movl	96(%r11), %eax
	bswapl	%eax
	movl	%eax, 12(%rsi)
	movl	128(%r11), %eax
	bswapl	%eax
	movl	%eax, 16(%rsi)
	movl	160(%r11), %eax
	bswapl	%eax
	movl	%eax, 20(%rsi)
	movl	192(%r11), %eax
	bswapl	%eax
	movl	%eax, 24(%rsi)
	movl	224(%r11), %eax
	bswapl	%eax
	movl	%eax, 28(%rsi)
	movl	4(%r11), %eax
	bswapl	%eax
	movl	%eax, 32(%rsi)
	movl	36(%r11), %eax
	bswapl	%eax
	movl	%eax, 36(%rsi)
	movl	68(%r11), %eax
	bswapl	%eax
	movl	%eax, 40(%rsi)
	movl	100(%r11), %eax
	bswapl	%eax
	movl	%eax, 44(%rsi)
	movl	132(%r11), %eax
	bswapl	%eax
	movl	%eax, 48(%rsi)
	movl	164(%r11), %eax
	bswapl	%eax
	movl	%eax, 52(%rsi)
	movl	196(%r11), %eax
	bswapl	%eax
	movl	%eax, 56(%rsi)
	movl	228(%r11), %eax
	bswapl	%eax
	movl	%eax, 60(%rsi)
	movl	8(%r11), %eax
	bswapl	%eax
	movl	%eax, 64(%rsi)
	movl	40(%r11), %eax
	bswapl	%eax
	movl	%eax, 68(%rsi)
	movl	72(%r11), %eax
	bswapl	%eax
	movl	%eax, 72(%rsi)
	movl	104(%r11), %eax
	bswapl	%eax
	movl	%eax, 76(%rsi)
	movl	136(%r11), %eax
	bswapl	%eax
	movl	%eax, 80(%rsi)
	movl	168(%r11), %eax
	bswapl	%eax
	movl	%eax, 84(%rsi)
	movl	200(%r11), %eax
	bswapl	%eax
	movl	%eax, 88(%rsi)
	movl	232(%r11), %eax
	bswapl	%eax
	movl	%eax, 92(%rsi)
	movl	12(%r11), %eax
	bswapl	%eax
	movl	%eax, 96(%rsi)
	movl	44(%r11), %eax
	bswapl	%eax
	movl	%eax, 100(%rsi)
	movl	76(%r11), %eax
	bswapl	%eax
	movl	%eax, 104(%rsi)
	movl	108(%r11), %eax
	bswapl	%eax
	movl	%eax, 108(%rsi)
	movl	140(%r11), %eax
	bswapl	%eax
	movl	%eax, 112(%rsi)
	movl	172(%r11), %eax
	bswapl	%eax
	movl	%eax, 116(%rsi)
	movl	204(%r11), %eax
	bswapl	%eax
	movl	%eax, 120(%rsi)
	movl	236(%r11), %eax
	bswapl	%eax
	movl	%eax, 124(%rsi)
	movl	16(%r11), %eax
	bswapl	%eax
	movl	%eax, 128(%rsi)
	movl	48(%r11), %eax
	bswapl	%eax
	movl	%eax, 132(%rsi)
	movl	80(%r11), %eax
	bswapl	%eax
	movl	%eax, 136(%rsi)
	movl	112(%r11), %eax
	bswapl	%eax
	movl	%eax, 140(%rsi)
	movl	144(%r11), %eax
	bswapl	%eax
	movl	%eax, 144(%rsi)
	movl	176(%r11), %eax
	bswapl	%eax
	movl	%eax, 148(%rsi)
	movl	208(%r11), %eax
	bswapl	%eax
	movl	%eax, 152(%rsi)
	movl	240(%r11), %eax
	bswapl	%eax
	movl	%eax, 156(%rsi)
	movl	20(%r11), %eax
	bswapl	%eax
	movl	%eax, 160(%rsi)
	movl	52(%r11), %eax
	bswapl	%eax
	movl	%eax, 164(%rsi)
	movl	84(%r11), %eax
	bswapl	%eax
	movl	%eax, 168(%rsi)
	movl	116(%r11), %eax
	bswapl	%eax
	movl	%eax, 172(%rsi)
	movl	148(%r11), %eax
	bswapl	%eax
	movl	%eax, 176(%rsi)
	movl	180(%r11), %eax
	bswapl	%eax
	movl	%eax, 180(%rsi)
	movl	212(%r11), %eax
	bswapl	%eax
	movl	%eax, 184(%rsi)
	movl	244(%r11), %eax
	bswapl	%eax
	movl	%eax, 188(%rsi)
	movl	24(%r11), %eax
	bswapl	%eax
	movl	%eax, 192(%rsi)
	movl	56(%r11), %eax
	bswapl	%eax
	movl	%eax, 196(%rsi)
	movl	88(%r11), %eax
	bswapl	%eax
	movl	%eax, 200(%rsi)
	movl	120(%r11), %eax
	bswapl	%eax
	movl	%eax, 204(%rsi)
	movl	152(%r11), %eax
	bswapl	%eax
	movl	%eax, 208(%rsi)
	movl	184(%r11), %eax
	bswapl	%eax
	movl	%eax, 212(%rsi)
	movl	216(%r11), %eax
	bswapl	%eax
	movl	%eax, 216(%rsi)
	movl	248(%r11), %eax
	bswapl	%eax
	movl	%eax, 220(%rsi)
	movl	28(%r11), %eax
	bswapl	%eax
	movl	%eax, 224(%rsi)
	movl	60(%r11), %eax
	bswapl	%eax
	movl	%eax, 228(%rsi)
	movl	92(%r11), %eax
	bswapl	%eax
	movl	%eax, 232(%rsi)
	movl	124(%r11), %eax
	bswapl	%eax
	movl	%eax, 236(%rsi)
	movl	156(%r11), %eax
	bswapl	%eax
	movl	%eax, 240(%rsi)
	movl	188(%r11), %eax
	bswapl	%eax
	movl	%eax, 244(%rsi)
	movl	220(%r11), %eax
	bswapl	%eax
	movl	%eax, 248(%rsi)
	movl	252(%r11), %eax
	bswapl	%eax
	movl	%eax, 252(%rsi)
	ret
.L_sha256_x8_absorb_lanes$1:
	movq	%rax, %r9
	andq	$63, %r9
	addq	%r10, %rax
	movq	$64, %rsi
	subq	%r9, %rsi
	cmpq	%rsi, %r10
	cmovb	%r10, %rsi
	cmpq	$0, %r9
	cmove	%r9, %rsi
	movq	(%r8), %r12
	orq 	%rdx, %r12
	movq	%rcx, %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$102
.L_sha256_x8_absorb_lanes$103:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$102:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$103
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$100
.L_sha256_x8_absorb_lanes$101:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$100:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$101
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$98
.L_sha256_x8_absorb_lanes$99:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$98:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$99
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	8(%r8), %r12
	orq 	%rdx, %r12
	leaq	64(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$96
.L_sha256_x8_absorb_lanes$97:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$96:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$97
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$94
.L_sha256_x8_absorb_lanes$95:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$94:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$95
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$92
.L_sha256_x8_absorb_lanes$93:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$92:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$93
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	16(%r8), %r12
	orq 	%rdx, %r12
	leaq	128(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$90
.L_sha256_x8_absorb_lanes$91:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$90:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$91
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$88
.L_sha256_x8_absorb_lanes$89:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$88:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$89
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$86
.L_sha256_x8_absorb_lanes$87:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$86:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$87
	movq	$-1, %r12
	cmovb	%r12, %rdx
	movq	24(%r8), %r12
	orq 	%rdx, %r12
	leaq	192(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$84
.L_sha256_x8_absorb_lanes$85:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$84:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$85
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$82
.L_sha256_x8_absorb_lanes$83:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$82:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$83
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$80
.L_sha256_x8_absorb_lanes$81:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$80:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$81
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	32(%r8), %r12
	orq 	%rdx, %r12
	leaq	256(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$78
.L_sha256_x8_absorb_lanes$79:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$78:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$79
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$76
.L_sha256_x8_absorb_lanes$77:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$76:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$77
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$74
.L_sha256_x8_absorb_lanes$75:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$74:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$75
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	40(%r8), %r12
	orq 	%rdx, %r12
	leaq	320(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$72
.L_sha256_x8_absorb_lanes$73:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$72:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$73
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$70
.L_sha256_x8_absorb_lanes$71:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$70:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$71
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$68
.L_sha256_x8_absorb_lanes$69:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$68:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$69
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	48(%r8), %r12
	orq 	%rdx, %r12
	leaq	384(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$66
.L_sha256_x8_absorb_lanes$67:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$66:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$67
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$64
.L_sha256_x8_absorb_lanes$65:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$64:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$65
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$62
.L_sha256_x8_absorb_lanes$63:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$62:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$63
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	56(%r8), %r12
	orq 	%rdx, %r12
	leaq	448(%rcx), %rbx
	movq	%r9, %rbp
	movq	%rsi, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$60
.L_sha256_x8_absorb_lanes$61:
	movq	$-1, %r15
	cmovnb	%r15, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$60:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$61
	movq	$-1, %r14
	cmovb	%r14, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$58
.L_sha256_x8_absorb_lanes$59:
	movq	$-1, %r14
	cmovb	%r14, %rdx
	movq	(%r12), %r15
	movq	%r15, (%rbx,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$58:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$59
	movq	$-1, %r14
	cmovnb	%r14, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$56
.L_sha256_x8_absorb_lanes$57:
	movq	$-1, %r13
	cmovnb	%r13, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%rbx,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$56:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$57
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	addq	%rsi, %r9
	cmpq	$64, %r9
	je  	.L_sha256_x8_absorb_lanes$53
	movq	$-1, %rbx
	cmove	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$54
.L_sha256_x8_absorb_lanes$53:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%rax, 8(%rsp)
	movq	%r8, 16(%rsp)
	movq	%r10, 24(%rsp)
	movq	%rsi, 32(%rsp)
	movq	%rcx, 40(%rsp)
	leaq	-536(%rsp), %rsp
	call	.L_sha256_x8_compress$1
.L_sha256_x8_absorb_lanes$55:
	leaq	536(%rsp), %rsp
	movq	8(%rsp), %rax
	movq	16(%rsp), %r8
	movq	24(%rsp), %r10
	movq	32(%rsp), %rsi
	movq	40(%rsp), %rcx
	orq 	%rdx, %rax
	orq 	%rdx, %r8
	orq 	%rdx, %r10
	orq 	%rdx, %rsi
	orq 	%rdx, %rcx
	movq	$0, %r9
.L_sha256_x8_absorb_lanes$54:
	movq	%r10, %r13
	subq	%rsi, %r13
	shrq	$6, %r13
	cmpq	$0, %r13
	jne 	.L_sha256_x8_absorb_lanes$50
	movq	$-1, %r11
	cmovne	%r11, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$51
.L_sha256_x8_absorb_lanes$50:
	movq	$-1, %r9
	cmove	%r9, %rdx
	movq	%rax, 40(%rsp)
	movq	%r8, 32(%rsp)
	movq	%r10, 24(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rcx, 8(%rsp)
	leaq	-568(%rsp), %rsp
	call	.L_sha256_x8_compress_lanes$1
.L_sha256_x8_absorb_lanes$52:
	leaq	568(%rsp), %rsp
	movq	40(%rsp), %rax
	movq	32(%rsp), %r8
	movq	24(%rsp), %r10
	movq	16(%rsp), %rsi
	movq	8(%rsp), %rcx
	orq 	%rdx, %rax
	orq 	%rdx, %r8
	orq 	%rdx, %r10
	orq 	%rdx, %rsi
	orq 	%rdx, %rcx
	movq	%r10, %r9
	subq	%rsi, %r9
	shrq	$6, %r9
	shlq	$6, %r9
	addq	%r9, %rsi
	movq	$0, %r9
.L_sha256_x8_absorb_lanes$51:
	subq	%rsi, %r10
	movq	(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	movq	%rcx, %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$48
.L_sha256_x8_absorb_lanes$49:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$48:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$49
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$46
.L_sha256_x8_absorb_lanes$47:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$46:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$47
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$44
.L_sha256_x8_absorb_lanes$45:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$44:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$45
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	8(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	64(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$42
.L_sha256_x8_absorb_lanes$43:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$42:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$43
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$40
.L_sha256_x8_absorb_lanes$41:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$40:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$41
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$38
.L_sha256_x8_absorb_lanes$39:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$38:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$39
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	16(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	128(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$36
.L_sha256_x8_absorb_lanes$37:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$36:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$37
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$34
.L_sha256_x8_absorb_lanes$35:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$34:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$35
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$32
.L_sha256_x8_absorb_lanes$33:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$32:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$33
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	24(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	192(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$30
.L_sha256_x8_absorb_lanes$31:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$30:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$31
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$28
.L_sha256_x8_absorb_lanes$29:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$28:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$29
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$26
.L_sha256_x8_absorb_lanes$27:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$26:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$27
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	32(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	256(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$24
.L_sha256_x8_absorb_lanes$25:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$24:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$25
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$22
.L_sha256_x8_absorb_lanes$23:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$22:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$23
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$20
.L_sha256_x8_absorb_lanes$21:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$20:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$21
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	40(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	320(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$18
.L_sha256_x8_absorb_lanes$19:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$18:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$19
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$16
.L_sha256_x8_absorb_lanes$17:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$16:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$17
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$14
.L_sha256_x8_absorb_lanes$15:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$14:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$15
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	48(%r8), %r12
	orq 	%rdx, %r12
	addq	%rsi, %r12
	leaq	384(%rcx), %r11
	movq	%r9, %rbp
	movq	%r10, %r13
	movq	%rbp, %r15
	negq	%r15
	andq	$7, %r15
	cmpq	%r15, %r13
	cmovb	%r13, %r15
	subq	%r15, %r13
	movq	%rbp, %r14
	addq	%r15, %r14
	jmp 	.L_sha256_x8_absorb_lanes$12
.L_sha256_x8_absorb_lanes$13:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$12:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$13
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$10
.L_sha256_x8_absorb_lanes$11:
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	movq	(%r12), %r15
	movq	%r15, (%r11,%rbp)
	addq	$8, %rbp
	addq	$8, %r12
	addq	$-8, %r13
.L_sha256_x8_absorb_lanes$10:
	cmpq	$8, %r13
	jnb 	.L_sha256_x8_absorb_lanes$11
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%rbp, %r14
	addq	%r13, %r14
	jmp 	.L_sha256_x8_absorb_lanes$8
.L_sha256_x8_absorb_lanes$9:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movzbq	(%r12), %r15
	movb	%r15b, (%r11,%rbp)
	incq	%rbp
	incq	%r12
.L_sha256_x8_absorb_lanes$8:
	cmpq	%r14, %rbp
	jb  	.L_sha256_x8_absorb_lanes$9
	movq	$-1, %r11
	cmovb	%r11, %rdx
	movq	56(%r8), %r8
	orq 	%rdx, %r8
	addq	%rsi, %r8
	leaq	448(%rcx), %r11
	movq	%r8, %rsi
	movq	%r9, %r8
	negq	%r8
	andq	$7, %r8
	cmpq	%r8, %r10
	cmovb	%r10, %r8
	subq	%r8, %r10
	movq	%r9, %r14
	addq	%r8, %r14
	jmp 	.L_sha256_x8_absorb_lanes$6
.L_sha256_x8_absorb_lanes$7:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	movzbq	(%rsi), %r8
	movb	%r8b, (%r11,%r9)
	incq	%r9
	incq	%rsi
.L_sha256_x8_absorb_lanes$6:
	cmpq	%r14, %r9
	jb  	.L_sha256_x8_absorb_lanes$7
	movq	$-1, %r8
	cmovb	%r8, %rdx
	jmp 	.L_sha256_x8_absorb_lanes$4
.L_sha256_x8_absorb_lanes$5:
	movq	$-1, %r8
	cmovb	%r8, %rdx
	movq	(%rsi), %r8
	movq	%r8, (%r11,%r9)
	addq	$8, %r9
	addq	$8, %rsi
	addq	$-8, %r10
.L_sha256_x8_absorb_lanes$4:
	cmpq	$8, %r10
	jnb 	.L_sha256_x8_absorb_lanes$5
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	movq	%r9, %r8
	addq	%r10, %r8
	jmp 	.L_sha256_x8_absorb_lanes$2
.L_sha256_x8_absorb_lanes$3:
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	movzbq	(%rsi), %r10
	movb	%r10b, (%r11,%r9)
	incq	%r9
	incq	%rsi
.L_sha256_x8_absorb_lanes$2:
	cmpq	%r8, %r9
	jb  	.L_sha256_x8_absorb_lanes$3
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	ret
.L_sha256_x8_compress_lanes$1:
	jmp 	.L_sha256_x8_compress_lanes$2
.L_sha256_x8_compress_lanes$3:
	movq	$-1, %rax
	cmove	%rax, %rdx
	movq	(%r8), %rax
	movq	8(%r8), %rcx
	movq	16(%r8), %r9
	movq	24(%r8), %r10
	movq	32(%r8), %rbx
	movq	40(%r8), %rbp
	movq	48(%r8), %r12
	movq	56(%r8), %r14
	orq 	%rdx, %rax
	orq 	%rdx, %rcx
	orq 	%rdx, %r9
	orq 	%rdx, %r10
	orq 	%rdx, %rbx
	orq 	%rdx, %rbp
	orq 	%rdx, %r12
	orq 	%rdx, %r14
	addq	%rsi, %rax
	addq	%rsi, %rcx
	addq	%rsi, %r9
	addq	%rsi, %r10
	addq	%rsi, %rbx
	addq	%rsi, %rbp
	addq	%rsi, %r12
	addq	%rsi, %r14
	leaq	glob_data + 0(%rip), %r15
	vmovdqu	(%r15), %ymm0
	vmovdqu	(%rax), %ymm5
	vmovdqu	(%rcx), %ymm9
	vmovdqu	(%r9), %ymm6
	vmovdqu	(%r10), %ymm3
	vmovdqu	(%rbx), %ymm4
	vmovdqu	(%rbp), %ymm7
	vmovdqu	(%r12), %ymm8
	vmovdqu	(%r14), %ymm10
	vpunpckldq	%ymm9, %ymm5, %ymm1
	vpunpckhdq	%ymm9, %ymm5, %ymm2
	vpunpckldq	%ymm3, %ymm6, %ymm9
	vpunpckhdq	%ymm3, %ymm6, %ymm11
	vpunpckldq	%ymm7, %ymm4, %ymm3
	vpunpckhdq	%ymm7, %ymm4, %ymm4
	vpunpckldq	%ymm10, %ymm8, %ymm7
	vpunpckhdq	%ymm10, %ymm8, %ymm8
	vpunpcklqdq	%ymm9, %ymm1, %ymm5
	vpunpckhqdq	%ymm9, %ymm1, %ymm1
	vpunpcklqdq	%ymm11, %ymm2, %ymm6
	vpunpckhqdq	%ymm11, %ymm2, %ymm2
	vpunpcklqdq	%ymm7, %ymm3, %ymm9
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpunpcklqdq	%ymm8, %ymm4, %ymm7
	vpunpckhqdq	%ymm8, %ymm4, %ymm4
	vperm2i128	$32, %ymm9, %ymm5, %ymm8
	vpshufb	%ymm0, %ymm8, %ymm8
	vperm2i128	$49, %ymm9, %ymm5, %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vperm2i128	$32, %ymm3, %ymm1, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vperm2i128	$49, %ymm3, %ymm1, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vperm2i128	$32, %ymm7, %ymm6, %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vperm2i128	$49, %ymm7, %ymm6, %ymm7
	vpshufb	%ymm0, %ymm7, %ymm7
	vperm2i128	$32, %ymm4, %ymm2, %ymm6
	vpshufb	%ymm0, %ymm6, %ymm6
	vperm2i128	$49, %ymm4, %ymm2, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm8, 32(%rsp)
	vmovdqu	%ymm9, 64(%rsp)
	vmovdqu	%ymm1, 96(%rsp)
	vmovdqu	%ymm6, 128(%rsp)
	vmovdqu	%ymm5, 160(%rsp)
	vmovdqu	%ymm3, 192(%rsp)
	vmovdqu	%ymm7, 224(%rsp)
	vmovdqu	%ymm4, 256(%rsp)
	vmovdqu	32(%rax), %ymm5
	vmovdqu	32(%rcx), %ymm9
	vmovdqu	32(%r9), %ymm6
	vmovdqu	32(%r10), %ymm3
	vmovdqu	32(%rbx), %ymm4
	vmovdqu	32(%rbp), %ymm7
	vmovdqu	32(%r12), %ymm8
	vmovdqu	32(%r14), %ymm10
	vpunpckldq	%ymm9, %ymm5, %ymm1
	vpunpckhdq	%ymm9, %ymm5, %ymm2
	vpunpckldq	%ymm3, %ymm6, %ymm9
	vpunpckhdq	%ymm3, %ymm6, %ymm11
	vpunpckldq	%ymm7, %ymm4, %ymm3
	vpunpckhdq	%ymm7, %ymm4, %ymm4
	vpunpckldq	%ymm10, %ymm8, %ymm7
	vpunpckhdq	%ymm10, %ymm8, %ymm8
	vpunpcklqdq	%ymm9, %ymm1, %ymm5
	vpunpckhqdq	%ymm9, %ymm1, %ymm1
	vpunpcklqdq	%ymm11, %ymm2, %ymm6
	vpunpckhqdq	%ymm11, %ymm2, %ymm2
	vpunpcklqdq	%ymm7, %ymm3, %ymm9
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpunpcklqdq	%ymm8, %ymm4, %ymm7
	vpunpckhqdq	%ymm8, %ymm4, %ymm4
	vperm2i128	$32, %ymm9, %ymm5, %ymm8
	vpshufb	%ymm0, %ymm8, %ymm8
	vperm2i128	$49, %ymm9, %ymm5, %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vperm2i128	$32, %ymm3, %ymm1, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vperm2i128	$49, %ymm3, %ymm1, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vperm2i128	$32, %ymm7, %ymm6, %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vperm2i128	$49, %ymm7, %ymm6, %ymm7
	vpshufb	%ymm0, %ymm7, %ymm7
	vperm2i128	$32, %ymm4, %ymm2, %ymm6
	vpshufb	%ymm0, %ymm6, %ymm6
	vperm2i128	$49, %ymm4, %ymm2, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm8, 288(%rsp)
	vmovdqu	%ymm9, 320(%rsp)
	vmovdqu	%ymm1, 352(%rsp)
	vmovdqu	%ymm6, 384(%rsp)
	vmovdqu	%ymm5, 416(%rsp)
	vmovdqu	%ymm3, 448(%rsp)
	vmovdqu	%ymm7, 480(%rsp)
	vmovdqu	%ymm4, 512(%rsp)
	movq	%r8, 544(%rsp)
	movq	%rsi, 552(%rsp)
	movq	%r13, 560(%rsp)
	leaq	32(%rsp), %rax
	call	.L_sha256_x8_block$1
.L_sha256_x8_compress_lanes$4:
	movq	544(%rsp), %r8
	movq	552(%rsp), %rsi
	movq	560(%rsp), %r13
	orq 	%rdx, %r8
	orq 	%rdx, %rsi
	orq 	%rdx, %r13
	addq	$64, %rsi
	decq	%r13
.L_sha256_x8_compress_lanes$2:
	cmpq	$0, %r13
	jne 	.L_sha256_x8_compress_lanes$3
	movq	$-1, %rax
	cmovne	%rax, %rdx
	ret
.L_sha256_x8_compress$1:
	leaq	glob_data + 0(%rip), %rax
	vmovdqu	(%rax), %ymm0
	vmovdqu	(%rcx), %ymm5
	vmovdqu	64(%rcx), %ymm9
	vmovdqu	128(%rcx), %ymm6
	vmovdqu	192(%rcx), %ymm3
	vmovdqu	256(%rcx), %ymm4
	vmovdqu	320(%rcx), %ymm7
	vmovdqu	384(%rcx), %ymm8
	vmovdqu	448(%rcx), %ymm10
	vpunpckldq	%ymm9, %ymm5, %ymm1
	vpunpckhdq	%ymm9, %ymm5, %ymm2
	vpunpckldq	%ymm3, %ymm6, %ymm9
	vpunpckhdq	%ymm3, %ymm6, %ymm11
	vpunpckldq	%ymm7, %ymm4, %ymm3
	vpunpckhdq	%ymm7, %ymm4, %ymm4
	vpunpckldq	%ymm10, %ymm8, %ymm7
	vpunpckhdq	%ymm10, %ymm8, %ymm8
	vpunpcklqdq	%ymm9, %ymm1, %ymm5
	vpunpckhqdq	%ymm9, %ymm1, %ymm1
	vpunpcklqdq	%ymm11, %ymm2, %ymm6
	vpunpckhqdq	%ymm11, %ymm2, %ymm2
	vpunpcklqdq	%ymm7, %ymm3, %ymm9
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpunpcklqdq	%ymm8, %ymm4, %ymm7
	vpunpckhqdq	%ymm8, %ymm4, %ymm4
	vperm2i128	$32, %ymm9, %ymm5, %ymm8
	vpshufb	%ymm0, %ymm8, %ymm8
	vperm2i128	$49, %ymm9, %ymm5, %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vperm2i128	$32, %ymm3, %ymm1, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vperm2i128	$49, %ymm3, %ymm1, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vperm2i128	$32, %ymm7, %ymm6, %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vperm2i128	$49, %ymm7, %ymm6, %ymm7
	vpshufb	%ymm0, %ymm7, %ymm7
	vperm2i128	$32, %ymm4, %ymm2, %ymm6
	vpshufb	%ymm0, %ymm6, %ymm6
	vperm2i128	$49, %ymm4, %ymm2, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm8, 32(%rsp)
	vmovdqu	%ymm9, 64(%rsp)
	vmovdqu	%ymm1, 96(%rsp)
	vmovdqu	%ymm6, 128(%rsp)
	vmovdqu	%ymm5, 160(%rsp)
	vmovdqu	%ymm3, 192(%rsp)
	vmovdqu	%ymm7, 224(%rsp)
	vmovdqu	%ymm4, 256(%rsp)
	vmovdqu	32(%rcx), %ymm5
	vmovdqu	96(%rcx), %ymm9
	vmovdqu	160(%rcx), %ymm6
	vmovdqu	224(%rcx), %ymm3
	vmovdqu	288(%rcx), %ymm4
	vmovdqu	352(%rcx), %ymm7
	vmovdqu	416(%rcx), %ymm8
	vmovdqu	480(%rcx), %ymm10
	vpunpckldq	%ymm9, %ymm5, %ymm1
	vpunpckhdq	%ymm9, %ymm5, %ymm2
	vpunpckldq	%ymm3, %ymm6, %ymm9
	vpunpckhdq	%ymm3, %ymm6, %ymm11
	vpunpckldq	%ymm7, %ymm4, %ymm3
	vpunpckhdq	%ymm7, %ymm4, %ymm4
	vpunpckldq	%ymm10, %ymm8, %ymm7
	vpunpckhdq	%ymm10, %ymm8, %ymm8
	vpunpcklqdq	%ymm9, %ymm1, %ymm5
	vpunpckhqdq	%ymm9, %ymm1, %ymm1
	vpunpcklqdq	%ymm11, %ymm2, %ymm6
	vpunpckhqdq	%ymm11, %ymm2, %ymm2
	vpunpcklqdq	%ymm7, %ymm3, %ymm9
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpunpcklqdq	%ymm8, %ymm4, %ymm7
	vpunpckhqdq	%ymm8, %ymm4, %ymm4
	vperm2i128	$32, %ymm9, %ymm5, %ymm8
	vpshufb	%ymm0, %ymm8, %ymm8
	vperm2i128	$49, %ymm9, %ymm5, %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vperm2i128	$32, %ymm3, %ymm1, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vperm2i128	$49, %ymm3, %ymm1, %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vperm2i128	$32, %ymm7, %ymm6, %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vperm2i128	$49, %ymm7, %ymm6, %ymm7
	vpshufb	%ymm0, %ymm7, %ymm7
	vperm2i128	$32, %ymm4, %ymm2, %ymm6
	vpshufb	%ymm0, %ymm6, %ymm6
	vperm2i128	$49, %ymm4, %ymm2, %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm8, 288(%rsp)
	vmovdqu	%ymm9, 320(%rsp)
	vmovdqu	%ymm1, 352(%rsp)
	vmovdqu	%ymm6, 384(%rsp)
	vmovdqu	%ymm5, 416(%rsp)
	vmovdqu	%ymm3, 448(%rsp)
	vmovdqu	%ymm7, 480(%rsp)
	vmovdqu	%ymm4, 512(%rsp)
	leaq	32(%rsp), %rax
	call	.L_sha256_x8_block$1
.L_sha256_x8_compress$2:
	ret
.L_sha256_x8_block$1:
	vmovdqu	(%r11), %ymm0
	vmovdqu	32(%r11), %ymm1
	vmovdqu	64(%r11), %ymm6
	vmovdqu	96(%r11), %ymm4
	vmovdqu	128(%r11), %ymm2
	vmovdqu	160(%r11), %ymm3
	vmovdqu	192(%r11), %ymm7
	vmovdqu	224(%r11), %ymm5
	leaq	glob_data + 32(%rip), %rcx
	vpxor	%ymm6, %ymm1, %ymm8
	vmovdqu	(%rax), %ymm9
	vpaddd	(%rcx), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm5
	vpxor	%ymm7, %ymm3, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm5
	vpsrld	$6, %ymm2, %ymm9
	vpslld	$26, %ymm2, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm2, %ymm10
	vpslld	$21, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm2, %ymm10
	vpslld	$7, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm4, %ymm4
	vpsrld	$2, %ymm0, %ymm9
	vpslld	$30, %ymm0, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$13, %ymm0, %ymm10
	vpslld	$19, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$22, %ymm0, %ymm10
	vpslld	$10, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm5
	vpxor	%ymm1, %ymm0, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	32(%rax), %ymm8
	vpaddd	32(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm2, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpxor	%ymm3, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	vpsrld	$6, %ymm4, %ymm8
	vpslld	$26, %ymm4, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm4, %ymm10
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm4, %ymm10
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpsrld	$2, %ymm5, %ymm8
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	vpxor	%ymm0, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	vmovdqu	64(%rax), %ymm9
	vpaddd	64(%rcx), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vpxor	%ymm2, %ymm4, %ymm9
	vpand	%ymm6, %ymm9, %ymm9
	vpxor	%ymm2, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vpsrld	$6, %ymm6, %ymm9
	vpslld	$26, %ymm6, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm6, %ymm10
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm6, %ymm10
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm1, %ymm1
	vpsrld	$2, %ymm7, %ymm9
	vpslld	$30, %ymm7, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$13, %ymm7, %ymm10
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$22, %ymm7, %ymm10
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	96(%rax), %ymm8
	vpaddd	96(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vpxor	%ymm4, %ymm6, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpxor	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vpsrld	$6, %ymm1, %ymm8
	vpslld	$26, %ymm1, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm1, %ymm10
	vpslld	$21, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm1, %ymm10
	vpslld	$7, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm0, %ymm0
	vpsrld	$2, %ymm3, %ymm8
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vpxor	%ymm7, %ymm3, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	128(%rax), %ymm9
	vpaddd	128(%rcx), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm1, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm0, %ymm9
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm2, %ymm5
	vpslld	$30, %ymm2, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm2, %ymm10
	vpslld	$19, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm2, %ymm10
	vpslld	$10, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm3, %ymm2, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm3, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	160(%rax), %ymm8
	vpaddd	160(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpxor	%ymm1, %ymm0, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpsrld	$6, %ymm4, %ymm8
	vpslld	$26, %ymm4, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm4, %ymm10
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm4, %ymm10
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm2, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm2, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	vmovdqu	192(%rax), %ymm9
	vpaddd	192(%rcx), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm1
	vpxor	%ymm0, %ymm4, %ymm9
	vpand	%ymm6, %ymm9, %ymm9
	vpxor	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm1
	vpsrld	$6, %ymm6, %ymm9
	vpslld	$26, %ymm6, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm6, %ymm10
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm6, %ymm10
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm1
	vpsrld	$2, %ymm7, %ymm3
	vpslld	$30, %ymm7, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$13, %ymm7, %ymm10
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$22, %ymm7, %ymm10
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm9, %ymm3
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	224(%rax), %ymm8
	vpaddd	224(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vpxor	%ymm4, %ymm6, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpxor	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vpsrld	$6, %ymm1, %ymm8
	vpslld	$26, %ymm1, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm1, %ymm10
	vpslld	$21, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm1, %ymm10
	vpslld	$7, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm0, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm0
	vpsrld	$2, %ymm3, %ymm2
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm2
	vpxor	%ymm7, %ymm3, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	256(%rax), %ymm9
	vpaddd	256(%rcx), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm1, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm0, %ymm9
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm2, %ymm5
	vpslld	$30, %ymm2, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm2, %ymm10
	vpslld	$19, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm2, %ymm10
	vpslld	$10, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm3, %ymm2, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm3, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	288(%rax), %ymm8
	vpaddd	288(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpxor	%ymm1, %ymm0, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpsrld	$6, %ymm4, %ymm8
	vpslld	$26, %ymm4, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm4, %ymm10
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm4, %ymm10
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm2, %ymm5, %ymm10
	vpand	%ymm10, %ymm9, %ymm8
	vpxor	%ymm2, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	vmovdqu	320(%rax), %ymm8
	vpaddd	320(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vpxor	%ymm0, %ymm4, %ymm8
	vpand	%ymm6, %ymm8, %ymm8
	vpxor	%ymm0, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vpsrld	$6, %ymm6, %ymm8
	vpslld	$26, %ymm6, %ymm9
	vpxor	%ymm9, %ymm8, %ymm8
	vpsrld	$11, %ymm6, %ymm9
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm9, %ymm8, %ymm8
	vpsrld	$25, %ymm6, %ymm9
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm7, %ymm3
	vpslld	$30, %ymm7, %ymm9
	vpxor	%ymm9, %ymm3, %ymm3
	vpsrld	$13, %ymm7, %ymm9
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm9, %ymm3, %ymm3
	vpsrld	$22, %ymm7, %ymm9
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm9, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm1, %ymm3
	vpxor	%ymm5, %ymm7, %ymm1
	vpand	%ymm1, %ymm10, %ymm9
	vpxor	%ymm5, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm9
	vmovdqu	352(%rax), %ymm3
	vpaddd	352(%rcx), %ymm3, %ymm3
	vpaddd	%ymm3, %ymm0, %ymm0
	vpxor	%ymm4, %ymm6, %ymm3
	vpand	%ymm8, %ymm3, %ymm3
	vpxor	%ymm4, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm0, %ymm0
	vpsrld	$6, %ymm8, %ymm3
	vpslld	$26, %ymm8, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$11, %ymm8, %ymm10
	vpslld	$21, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$25, %ymm8, %ymm10
	vpslld	$7, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm2, %ymm10
	vpsrld	$2, %ymm9, %ymm2
	vpslld	$30, %ymm9, %ymm3
	vpxor	%ymm3, %ymm2, %ymm2
	vpsrld	$13, %ymm9, %ymm3
	vpslld	$19, %ymm9, %ymm11
	vpxor	%ymm11, %ymm3, %ymm3
	vpxor	%ymm3, %ymm2, %ymm2
	vpsrld	$22, %ymm9, %ymm3
	vpslld	$10, %ymm9, %ymm11
	vpxor	%ymm11, %ymm3, %ymm3
	vpxor	%ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm0, %ymm0
	vpxor	%ymm7, %ymm9, %ymm2
	vpand	%ymm2, %ymm1, %ymm1
	vpxor	%ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm11
	vmovdqu	384(%rax), %ymm3
	vpaddd	384(%rcx), %ymm3, %ymm3
	vpaddd	%ymm3, %ymm4, %ymm4
	vpxor	%ymm6, %ymm8, %ymm0
	vpand	%ymm10, %ymm0, %ymm0
	vpxor	%ymm6, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm4, %ymm4
	vpsrld	$6, %ymm10, %ymm3
	vpslld	$26, %ymm10, %ymm0
	vpxor	%ymm0, %ymm3, %ymm3
	vpsrld	$11, %ymm10, %ymm0
	vpslld	$21, %ymm10, %ymm1
	vpxor	%ymm1, %ymm0, %ymm0
	vpxor	%ymm0, %ymm3, %ymm3
	vpsrld	$25, %ymm10, %ymm0
	vpslld	$7, %ymm10, %ymm1
	vpxor	%ymm1, %ymm0, %ymm0
	vpxor	%ymm0, %ymm3, %ymm0
	vpaddd	%ymm0, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm5, %ymm0
	vpsrld	$2, %ymm11, %ymm3
	vpslld	$30, %ymm11, %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpsrld	$13, %ymm11, %ymm1
	vpslld	$19, %ymm11, %ymm5
	vpxor	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpsrld	$22, %ymm11, %ymm1
	vpslld	$10, %ymm11, %ymm5
	vpxor	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm3, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm4
	vpxor	%ymm9, %ymm11, %ymm3
	vpand	%ymm3, %ymm2, %ymm1
	vpxor	%ymm9, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovdqu	416(%rax), %ymm2
	vpaddd	416(%rcx), %ymm2, %ymm2
	vpaddd	%ymm2, %ymm6, %ymm6
	vpxor	%ymm8, %ymm10, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpxor	%ymm8, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm6, %ymm6
	vpsrld	$6, %ymm0, %ymm2
	vpslld	$26, %ymm0, %ymm4
	vpxor	%ymm4, %ymm2, %ymm2
	vpsrld	$11, %ymm0, %ymm4
	vpslld	$21, %ymm0, %ymm5
	vpxor	%ymm5, %ymm4, %ymm4
	vpxor	%ymm4, %ymm2, %ymm2
	vpsrld	$25, %ymm0, %ymm4
	vpslld	$7, %ymm0, %ymm5
	vpxor	%ymm5, %ymm4, %ymm4
	vpxor	%ymm4, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm7, %ymm2
	vpsrld	$2, %ymm1, %ymm5
	vpslld	$30, %ymm1, %ymm4
	vpxor	%ymm4, %ymm5, %ymm5
	vpsrld	$13, %ymm1, %ymm4
	vpslld	$19, %ymm1, %ymm7
	vpxor	%ymm7, %ymm4, %ymm4
	vpxor	%ymm4, %ymm5, %ymm5
	vpsrld	$22, %ymm1, %ymm4
	vpslld	$10, %ymm1, %ymm7
	vpxor	%ymm7, %ymm4, %ymm4
	vpxor	%ymm4, %ymm5, %ymm4
	vpaddd	%ymm4, %ymm6, %ymm6
	vpxor	%ymm11, %ymm1, %ymm5
	vpand	%ymm5, %ymm3, %ymm3
	vpxor	%ymm11, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm6, %ymm3
	vmovdqu	448(%rax), %ymm4
	vpaddd	448(%rcx), %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm4
	vpxor	%ymm10, %ymm0, %ymm6
	vpand	%ymm2, %ymm6, %ymm6
	vpxor	%ymm10, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm4
	vpsrld	$6, %ymm2, %ymm7
	vpslld	$26, %ymm2, %ymm6
	vpxor	%ymm6, %ymm7, %ymm7
	vpsrld	$11, %ymm2, %ymm6
	vpslld	$21, %ymm2, %ymm8
	vpxor	%ymm8, %ymm6, %ymm6
	vpxor	%ymm6, %ymm7, %ymm7
	vpsrld	$25, %ymm2, %ymm6
	vpslld	$7, %ymm2, %ymm8
	vpxor	%ymm8, %ymm6, %ymm6
	vpxor	%ymm6, %ymm7, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm9, %ymm4
	vpsrld	$2, %ymm3, %ymm7
	vpslld	$30, %ymm3, %ymm9
	vpxor	%ymm9, %ymm7, %ymm7
	vpsrld	$13, %ymm3, %ymm9
	vpslld	$19, %ymm3, %ymm8
	vpxor	%ymm8, %ymm9, %ymm9
	vpxor	%ymm9, %ymm7, %ymm7
	vpsrld	$22, %ymm3, %ymm9
	vpslld	$10, %ymm3, %ymm8
	vpxor	%ymm8, %ymm9, %ymm9
	vpxor	%ymm9, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm1, %ymm3, %ymm9
	vpand	%ymm9, %ymm5, %ymm5
	vpxor	%ymm1, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovdqu	480(%rax), %ymm8
	vpaddd	480(%rcx), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm10, %ymm8
	vpxor	%ymm0, %ymm2, %ymm6
	vpand	%ymm4, %ymm6, %ymm6
	vpxor	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpsrld	$6, %ymm4, %ymm7
	vpslld	$26, %ymm4, %ymm6
	vpxor	%ymm6, %ymm7, %ymm7
	vpsrld	$11, %ymm4, %ymm6
	vpslld	$21, %ymm4, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpxor	%ymm6, %ymm7, %ymm7
	vpsrld	$25, %ymm4, %ymm6
	vpslld	$7, %ymm4, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpxor	%ymm6, %ymm7, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm11, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	movq	$512, %rsi
	jmp 	.L_sha256_x8_block$2
.L_sha256_x8_block$3:
	movq	$-1, %r8
	cmovnbe	%r8, %rdx
	vmovdqu	32(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	(%rax), %ymm9, %ymm9
	vpaddd	288(%rax), %ymm9, %ymm9
	vmovdqu	448(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, (%rax)
	vpaddd	(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm0, %ymm9
	vpxor	%ymm2, %ymm4, %ymm0
	vpand	%ymm6, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpsrld	$6, %ymm6, %ymm10
	vpslld	$26, %ymm6, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$11, %ymm6, %ymm0
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$25, %ymm6, %ymm0
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm0
	vpsrld	$2, %ymm7, %ymm10
	vpslld	$30, %ymm7, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$13, %ymm7, %ymm1
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$22, %ymm7, %ymm1
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm1
	vpaddd	%ymm1, %ymm9, %ymm1
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	32(%rax), %ymm8, %ymm8
	vpaddd	320(%rax), %ymm8, %ymm8
	vmovdqu	480(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 32(%rax)
	vpaddd	32(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm8
	vpxor	%ymm4, %ymm6, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpxor	%ymm4, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpsrld	$6, %ymm0, %ymm2
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm2
	vpsrld	$2, %ymm1, %ymm3
	vpslld	$30, %ymm1, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$13, %ymm1, %ymm10
	vpslld	$19, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$22, %ymm1, %ymm10
	vpslld	$10, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm8, %ymm3
	vpxor	%ymm7, %ymm1, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovdqu	96(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	64(%rax), %ymm9, %ymm9
	vpaddd	352(%rax), %ymm9, %ymm9
	vmovdqu	(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 64(%rax)
	vpaddd	64(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm0, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm2, %ymm9
	vpslld	$26, %ymm2, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm2, %ymm10
	vpslld	$21, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm2, %ymm10
	vpslld	$7, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm3, %ymm5
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm1, %ymm3, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	128(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	96(%rax), %ymm8, %ymm8
	vpaddd	384(%rax), %ymm8, %ymm8
	vmovdqu	32(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rax)
	vpaddd	96(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpxor	%ymm0, %ymm2, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpxor	%ymm0, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpsrld	$6, %ymm4, %ymm8
	vpslld	$26, %ymm4, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm4, %ymm10
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm4, %ymm10
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	vmovdqu	160(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	128(%rax), %ymm9, %ymm9
	vpaddd	416(%rax), %ymm9, %ymm9
	vmovdqu	64(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 128(%rax)
	vpaddd	128(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm0, %ymm9
	vpxor	%ymm2, %ymm4, %ymm0
	vpand	%ymm6, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpsrld	$6, %ymm6, %ymm10
	vpslld	$26, %ymm6, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$11, %ymm6, %ymm0
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$25, %ymm6, %ymm0
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm0
	vpsrld	$2, %ymm7, %ymm10
	vpslld	$30, %ymm7, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$13, %ymm7, %ymm1
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$22, %ymm7, %ymm1
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm1
	vpaddd	%ymm1, %ymm9, %ymm1
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	192(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	160(%rax), %ymm8, %ymm8
	vpaddd	448(%rax), %ymm8, %ymm8
	vmovdqu	96(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rax)
	vpaddd	160(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm8
	vpxor	%ymm4, %ymm6, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpxor	%ymm4, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpsrld	$6, %ymm0, %ymm2
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm2
	vpsrld	$2, %ymm1, %ymm3
	vpslld	$30, %ymm1, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$13, %ymm1, %ymm10
	vpslld	$19, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$22, %ymm1, %ymm10
	vpslld	$10, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm8, %ymm3
	vpxor	%ymm7, %ymm1, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovdqu	224(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	192(%rax), %ymm9, %ymm9
	vpaddd	480(%rax), %ymm9, %ymm9
	vmovdqu	128(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 192(%rax)
	vpaddd	192(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm0, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm2, %ymm9
	vpslld	$26, %ymm2, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm2, %ymm10
	vpslld	$21, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm2, %ymm10
	vpslld	$7, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm3, %ymm5
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm1, %ymm3, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	256(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	224(%rax), %ymm8, %ymm8
	vpaddd	(%rax), %ymm8, %ymm8
	vmovdqu	160(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rax)
	vpaddd	224(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpxor	%ymm0, %ymm2, %ymm6
	vpand	%ymm4, %ymm6, %ymm6
	vpxor	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpsrld	$6, %ymm4, %ymm10
	vpslld	$26, %ymm4, %ymm6
	vpxor	%ymm6, %ymm10, %ymm10
	vpsrld	$11, %ymm4, %ymm6
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm6, %ymm10, %ymm10
	vpsrld	$25, %ymm4, %ymm6
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm6, %ymm10, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	vmovdqu	288(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	256(%rax), %ymm9, %ymm9
	vpaddd	32(%rax), %ymm9, %ymm9
	vmovdqu	192(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 256(%rax)
	vpaddd	256(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm0, %ymm9
	vpxor	%ymm2, %ymm4, %ymm0
	vpand	%ymm6, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpsrld	$6, %ymm6, %ymm10
	vpslld	$26, %ymm6, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$11, %ymm6, %ymm0
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$25, %ymm6, %ymm0
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm0
	vpsrld	$2, %ymm7, %ymm10
	vpslld	$30, %ymm7, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$13, %ymm7, %ymm1
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$22, %ymm7, %ymm1
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm1
	vpaddd	%ymm1, %ymm9, %ymm1
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	320(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	288(%rax), %ymm8, %ymm8
	vpaddd	64(%rax), %ymm8, %ymm8
	vmovdqu	224(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 288(%rax)
	vpaddd	288(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm8
	vpxor	%ymm4, %ymm6, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpxor	%ymm4, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpsrld	$6, %ymm0, %ymm2
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm2
	vpsrld	$2, %ymm1, %ymm3
	vpslld	$30, %ymm1, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$13, %ymm1, %ymm10
	vpslld	$19, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$22, %ymm1, %ymm10
	vpslld	$10, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm8, %ymm3
	vpxor	%ymm7, %ymm1, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovdqu	352(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	320(%rax), %ymm9, %ymm9
	vpaddd	96(%rax), %ymm9, %ymm9
	vmovdqu	256(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 320(%rax)
	vpaddd	320(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm0, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm2, %ymm9
	vpslld	$26, %ymm2, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm2, %ymm10
	vpslld	$21, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm2, %ymm10
	vpslld	$7, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm3, %ymm5
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm1, %ymm3, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	384(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	352(%rax), %ymm8, %ymm8
	vpaddd	128(%rax), %ymm8, %ymm8
	vmovdqu	288(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 352(%rax)
	vpaddd	352(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpxor	%ymm0, %ymm2, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpxor	%ymm0, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vpsrld	$6, %ymm4, %ymm8
	vpslld	$26, %ymm4, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$11, %ymm4, %ymm10
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpsrld	$25, %ymm4, %ymm10
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	vmovdqu	416(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	384(%rax), %ymm9, %ymm9
	vpaddd	160(%rax), %ymm9, %ymm9
	vmovdqu	320(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 384(%rax)
	vpaddd	384(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm0, %ymm9
	vpxor	%ymm2, %ymm4, %ymm0
	vpand	%ymm6, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpsrld	$6, %ymm6, %ymm10
	vpslld	$26, %ymm6, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$11, %ymm6, %ymm0
	vpslld	$21, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm10
	vpsrld	$25, %ymm6, %ymm0
	vpslld	$7, %ymm6, %ymm11
	vpxor	%ymm11, %ymm0, %ymm0
	vpxor	%ymm0, %ymm10, %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm1, %ymm0
	vpsrld	$2, %ymm7, %ymm10
	vpslld	$30, %ymm7, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$13, %ymm7, %ymm1
	vpslld	$19, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm10
	vpsrld	$22, %ymm7, %ymm1
	vpslld	$10, %ymm7, %ymm11
	vpxor	%ymm11, %ymm1, %ymm1
	vpxor	%ymm1, %ymm10, %ymm1
	vpaddd	%ymm1, %ymm9, %ymm1
	vpxor	%ymm5, %ymm7, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	448(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	416(%rax), %ymm8, %ymm8
	vpaddd	192(%rax), %ymm8, %ymm8
	vmovdqu	352(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 416(%rax)
	vpaddd	416(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm2, %ymm8
	vpxor	%ymm4, %ymm6, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpxor	%ymm4, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpsrld	$6, %ymm0, %ymm2
	vpslld	$26, %ymm0, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$11, %ymm0, %ymm10
	vpslld	$21, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpsrld	$25, %ymm0, %ymm10
	vpslld	$7, %ymm0, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm3, %ymm2
	vpsrld	$2, %ymm1, %ymm3
	vpslld	$30, %ymm1, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$13, %ymm1, %ymm10
	vpslld	$19, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpsrld	$22, %ymm1, %ymm10
	vpslld	$10, %ymm1, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm8, %ymm3
	vpxor	%ymm7, %ymm1, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm7, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovdqu	480(%rax), %ymm9
	vpsrld	$7, %ymm9, %ymm10
	vpslld	$25, %ymm9, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm9, %ymm11
	vpslld	$14, %ymm9, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm9, %ymm9
	vpxor	%ymm9, %ymm10, %ymm9
	vpaddd	448(%rax), %ymm9, %ymm9
	vpaddd	224(%rax), %ymm9, %ymm9
	vmovdqu	384(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovdqu	%ymm9, 448(%rax)
	vpaddd	448(%rcx,%rsi), %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpxor	%ymm6, %ymm0, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpxor	%ymm6, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm4
	vpsrld	$6, %ymm2, %ymm9
	vpslld	$26, %ymm2, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$11, %ymm2, %ymm10
	vpslld	$21, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpsrld	$25, %ymm2, %ymm10
	vpslld	$7, %ymm2, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm4, %ymm9
	vpaddd	%ymm9, %ymm5, %ymm4
	vpsrld	$2, %ymm3, %ymm5
	vpslld	$30, %ymm3, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$13, %ymm3, %ymm10
	vpslld	$19, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpsrld	$22, %ymm3, %ymm10
	vpslld	$10, %ymm3, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm9, %ymm5
	vpxor	%ymm1, %ymm3, %ymm9
	vpand	%ymm9, %ymm8, %ymm8
	vpxor	%ymm1, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	(%rax), %ymm8
	vpsrld	$7, %ymm8, %ymm10
	vpslld	$25, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$18, %ymm8, %ymm11
	vpslld	$14, %ymm8, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpsrld	$3, %ymm8, %ymm11
	vpxor	%ymm11, %ymm10, %ymm8
	vpaddd	480(%rax), %ymm8, %ymm8
	vpaddd	256(%rax), %ymm8, %ymm8
	vmovdqu	416(%rax), %ymm10
	vpsrld	$17, %ymm10, %ymm11
	vpslld	$15, %ymm10, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$19, %ymm10, %ymm12
	vpslld	$13, %ymm10, %ymm13
	vpxor	%ymm13, %ymm12, %ymm12
	vpxor	%ymm12, %ymm11, %ymm11
	vpsrld	$10, %ymm10, %ymm10
	vpxor	%ymm10, %ymm11, %ymm10
	vpaddd	%ymm10, %ymm8, %ymm8
	vmovdqu	%ymm8, 480(%rax)
	vpaddd	480(%rcx,%rsi), %ymm8, %ymm8
	vpaddd	%ymm8, %ymm6, %ymm8
	vpxor	%ymm0, %ymm2, %ymm6
	vpand	%ymm4, %ymm6, %ymm6
	vpxor	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpsrld	$6, %ymm4, %ymm10
	vpslld	$26, %ymm4, %ymm6
	vpxor	%ymm6, %ymm10, %ymm10
	vpsrld	$11, %ymm4, %ymm6
	vpslld	$21, %ymm4, %ymm11
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm6, %ymm10, %ymm10
	vpsrld	$25, %ymm4, %ymm6
	vpslld	$7, %ymm4, %ymm11
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm6, %ymm10, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm8
	vpaddd	%ymm8, %ymm7, %ymm6
	vpsrld	$2, %ymm5, %ymm7
	vpslld	$30, %ymm5, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$13, %ymm5, %ymm10
	vpslld	$19, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpsrld	$22, %ymm5, %ymm10
	vpslld	$10, %ymm5, %ymm11
	vpxor	%ymm11, %ymm10, %ymm10
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vpand	%ymm8, %ymm9, %ymm9
	vpxor	%ymm3, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm7, %ymm7
	addq	$512, %rsi
.L_sha256_x8_block$2:
	cmpq	$1536, %rsi
	jbe 	.L_sha256_x8_block$3
	movq	$-1, %rax
	cmovbe	%rax, %rdx
	vmovdqu	(%r11), %ymm8
	vpaddd	%ymm7, %ymm8, %ymm7
	vmovdqu	%ymm7, (%r11)
	vmovdqu	32(%r11), %ymm7
	vpaddd	%ymm5, %ymm7, %ymm5
	vmovdqu	%ymm5, 32(%r11)
	vmovdqu	64(%r11), %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vmovdqu	%ymm3, 64(%r11)
	vmovdqu	96(%r11), %ymm3
	vpaddd	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm1, 96(%r11)
	vmovdqu	128(%r11), %ymm1
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%r11)
	vmovdqu	160(%r11), %ymm1
	vpaddd	%ymm4, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%r11)
	vmovdqu	192(%r11), %ymm1
	vpaddd	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%r11)
	vmovdqu	224(%r11), %ymm1
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovdqu	%ymm0, 224(%r11)
	ret
	.data
	.p2align	5
glob_data:
G$SHA256_X8_BSWAP:
	.byte	  3,   2,   1,   0,   7,   6,   5,   4,  11,  10,   9,   8,  15,  14,  13,  12
	.byte	  3,   2,   1,   0,   7,   6,   5,   4,  11,  10,   9,   8,  15,  14,  13,  12
G$SHA256_X8_K:
	.byte	152,  47, 138,  66, 152,  47, 138,  66, 152,  47, 138,  66, 152,  47, 138,  66
	.byte	152,  47, 138,  66, 152,  47, 138,  66, 152,  47, 138,  66, 152,  47, 138,  66
	.byte	145,  68,  55, 113, 145,  68,  55, 113, 145,  68,  55, 113, 145,  68,  55, 113
	.byte	145,  68,  55, 113, 145,  68,  55, 113, 145,  68,  55, 113, 145,  68,  55, 113
	.byte	207, 251, 192, 181, 207, 251, 192, 181, 207, 251, 192, 181, 207, 251, 192, 181
	.byte	207, 251, 192, 181, 207, 251, 192, 181, 207, 251, 192, 181, 207, 251, 192, 181
	.byte	165, 219, 181, 233, 165, 219, 181, 233, 165, 219, 181, 233, 165, 219, 181, 233
	.byte	165, 219, 181, 233, 165, 219, 181, 233, 165, 219, 181, 233, 165, 219, 181, 233
	.byte	 91, 194,  86,  57,  91, 194,  86,  57,  91, 194,  86,  57,  91, 194,  86,  57
	.byte	 91, 194,  86,  57,  91, 194,  86,  57,  91, 194,  86,  57,  91, 194,  86,  57
	.byte	241,  17, 241,  89, 241,  17, 241,  89, 241,  17, 241,  89, 241,  17, 241,  89
	.byte	241,  17, 241,  89, 241,  17, 241,  89, 241,  17, 241,  89, 241,  17, 241,  89
	.byte	164, 130,  63, 146, 164, 130,  63, 146, 164, 130,  63, 146, 164, 130,  63, 146
	.byte	164, 130,  63, 146, 164, 130,  63, 146, 164, 130,  63, 146, 164, 130,  63, 146
	.byte	213,  94,  28, 171, 213,  94,  28, 171, 213,  94,  28, 171, 213,  94,  28, 171
	.byte	213,  94,  28, 171, 213,  94,  28, 171, 213,  94,  28, 171, 213,  94,  28, 171
	.byte	152, 170,   7, 216, 152, 170,   7, 216, 152, 170,   7, 216, 152, 170,   7, 216
	.byte	152, 170,   7, 216, 152, 170,   7, 216, 152, 170,   7, 216, 152, 170,   7, 216
	.byte	  1,  91, 131,  18,   1,  91, 131,  18,   1,  91, 131,  18,   1,  91, 131,  18
	.byte	  1,  91, 131,  18,   1,  91, 131,  18,   1,  91, 131,  18,   1,  91, 131,  18
	.byte	190, 133,  49,  36, 190, 133,  49,  36, 190, 133,  49,  36, 190, 133,  49,  36
	.byte	190, 133,  49,  36, 190, 133,  49,  36, 190, 133,  49,  36, 190, 133,  49,  36
	.byte	195, 125,  12,  85, 195, 125,  12,  85, 195, 125,  12,  85, 195, 125,  12,  85
	.byte	195, 125,  12,  85, 195, 125,  12,  85, 195, 125,  12,  85, 195, 125,  12,  85
	.byte	116,  93, 190, 114, 116,  93, 190, 114, 116,  93, 190, 114, 116,  93, 190, 114
	.byte	116,  93, 190, 114, 116,  93, 190, 114, 116,  93, 190, 114, 116,  93, 190, 114
	.byte	254, 177, 222, 128, 254, 177, 222, 128, 254, 177, 222, 128, 254, 177, 222, 128
	.byte	254, 177, 222, 128, 254, 177, 222, 128, 254, 177, 222, 128, 254, 177, 222, 128
	.byte	167,   6, 220, 155, 167,   6, 220, 155, 167,   6, 220, 155, 167,   6, 220, 155
	.byte	167,   6, 220, 155, 167,   6, 220, 155, 167,   6, 220, 155, 167,   6, 220, 155
	.byte	116, 241, 155, 193, 116, 241, 155, 193, 116, 241, 155, 193, 116, 241, 155, 193
	.byte	116, 241, 155, 193, 116, 241, 155, 193, 116, 241, 155, 193, 116, 241, 155, 193
	.byte	193, 105, 155, 228, 193, 105, 155, 228, 193, 105, 155, 228, 193, 105, 155, 228
	.byte	193, 105, 155, 228, 193, 105, 155, 228, 193, 105, 155, 228, 193, 105, 155, 228
	.byte	134,  71, 190, 239, 134,  71, 190, 239, 134,  71, 190, 239, 134,  71, 190, 239
	.byte	134,  71, 190, 239, 134,  71, 190, 239, 134,  71, 190, 239, 134,  71, 190, 239
	.byte	198, 157, 193,  15, 198, 157, 193,  15, 198, 157, 193,  15, 198, 157, 193,  15
	.byte	198, 157, 193,  15, 198, 157, 193,  15, 198, 157, 193,  15, 198, 157, 193,  15
	.byte	204, 161,  12,  36, 204, 161,  12,  36, 204, 161,  12,  36, 204, 161,  12,  36
	.byte	204, 161,  12,  36, 204, 161,  12,  36, 204, 161,  12,  36, 204, 161,  12,  36
	.byte	111,  44, 233,  45, 111,  44, 233,  45, 111,  44, 233,  45, 111,  44, 233,  45
	.byte	111,  44, 233,  45, 111,  44, 233,  45, 111,  44, 233,  45, 111,  44, 233,  45
	.byte	170, 132, 116,  74, 170, 132, 116,  74, 170, 132, 116,  74, 170, 132, 116,  74
	.byte	170, 132, 116,  74, 170, 132, 116,  74, 170, 132, 116,  74, 170, 132, 116,  74
	.byte	220, 169, 176,  92, 220, 169, 176,  92, 220, 169, 176,  92, 220, 169, 176,  92
	.byte	220, 169, 176,  92, 220, 169, 176,  92, 220, 169, 176,  92, 220, 169, 176,  92
	.byte	218, 136, 249, 118, 218, 136, 249, 118, 218, 136, 249, 118, 218, 136, 249, 118
	.byte	218, 136, 249, 118, 218, 136, 249, 118, 218, 136, 249, 118, 218, 136, 249, 118
	.byte	 82,  81,  62, 152,  82,  81,  62, 152,  82,  81,  62, 152,  82,  81,  62, 152
	.byte	 82,  81,  62, 152,  82,  81,  62, 152,  82,  81,  62, 152,  82,  81,  62, 152
	.byte	109, 198,  49, 168, 109, 198,  49, 168, 109, 198,  49, 168, 109, 198,  49, 168
	.byte	109, 198,  49, 168, 109, 198,  49, 168, 109, 198,  49, 168, 109, 198,  49, 168
	.byte	200,  39,   3, 176, 200,  39,   3, 176, 200,  39,   3, 176, 200,  39,   3, 176
	.byte	200,  39,   3, 176, 200,  39,   3, 176, 200,  39,   3, 176, 200,  39,   3, 176
	.byte	199, 127,  89, 191, 199, 127,  89, 191, 199, 127,  89, 191, 199, 127,  89, 191
	.byte	199, 127,  89, 191, 199, 127,  89, 191, 199, 127,  89, 191, 199, 127,  89, 191
	.byte	243,  11, 224, 198, 243,  11, 224, 198, 243,  11, 224, 198, 243,  11, 224, 198
	.byte	243,  11, 224, 198, 243,  11, 224, 198, 243,  11, 224, 198, 243,  11, 224, 198
	.byte	 71, 145, 167, 213,  71, 145, 167, 213,  71, 145, 167, 213,  71, 145, 167, 213
	.byte	 71, 145, 167, 213,  71, 145, 167, 213,  71, 145, 167, 213,  71, 145, 167, 213
	.byte	 81,  99, 202,   6,  81,  99, 202,   6,  81,  99, 202,   6,  81,  99, 202,   6
	.byte	 81,  99, 202,   6,  81,  99, 202,   6,  81,  99, 202,   6,  81,  99, 202,   6
	.byte	103,  41,  41,  20, 103,  41,  41,  20, 103,  41,  41,  20, 103,  41,  41,  20
	.byte	103,  41,  41,  20, 103,  41,  41,  20, 103,  41,  41,  20, 103,  41,  41,  20
	.byte	133,  10, 183,  39, 133,  10, 183,  39, 133,  10, 183,  39, 133,  10, 183,  39
	.byte	133,  10, 183,  39, 133,  10, 183,  39, 133,  10, 183,  39, 133,  10, 183,  39
	.byte	 56,  33,  27,  46,  56,  33,  27,  46,  56,  33,  27,  46,  56,  33,  27,  46
	.byte	 56,  33,  27,  46,  56,  33,  27,  46,  56,  33,  27,  46,  56,  33,  27,  46
	.byte	252, 109,  44,  77, 252, 109,  44,  77, 252, 109,  44,  77, 252, 109,  44,  77
	.byte	252, 109,  44,  77, 252, 109,  44,  77, 252, 109,  44,  77, 252, 109,  44,  77
	.byte	 19,  13,  56,  83,  19,  13,  56,  83,  19,  13,  56,  83,  19,  13,  56,  83
	.byte	 19,  13,  56,  83,  19,  13,  56,  83,  19,  13,  56,  83,  19,  13,  56,  83
	.byte	 84, 115,  10, 101,  84, 115,  10, 101,  84, 115,  10, 101,  84, 115,  10, 101
	.byte	 84, 115,  10, 101,  84, 115,  10, 101,  84, 115,  10, 101,  84, 115,  10, 101
	.byte	187,  10, 106, 118, 187,  10, 106, 118, 187,  10, 106, 118, 187,  10, 106, 118
	.byte	187,  10, 106, 118, 187,  10, 106, 118, 187,  10, 106, 118, 187,  10, 106, 118
	.byte	 46, 201, 194, 129,  46, 201, 194, 129,  46, 201, 194, 129,  46, 201, 194, 129
	.byte	 46, 201, 194, 129,  46, 201, 194, 129,  46, 201, 194, 129,  46, 201, 194, 129
	.byte	133,  44, 114, 146, 133,  44, 114, 146, 133,  44, 114, 146, 133,  44, 114, 146
	.byte	133,  44, 114, 146, 133,  44, 114, 146, 133,  44, 114, 146, 133,  44, 114, 146
	.byte	161, 232, 191, 162, 161, 232, 191, 162, 161, 232, 191, 162, 161, 232, 191, 162
	.byte	161, 232, 191, 162, 161, 232, 191, 162, 161, 232, 191, 162, 161, 232, 191, 162
	.byte	 75, 102,  26, 168,  75, 102,  26, 168,  75, 102,  26, 168,  75, 102,  26, 168
	.byte	 75, 102,  26, 168,  75, 102,  26, 168,  75, 102,  26, 168,  75, 102,  26, 168
	.byte	112, 139,  75, 194, 112, 139,  75, 194, 112, 139,  75, 194, 112, 139,  75, 194
	.byte	112, 139,  75, 194, 112, 139,  75, 194, 112, 139,  75, 194, 112, 139,  75, 194
	.byte	163,  81, 108, 199, 163,  81, 108, 199, 163,  81, 108, 199, 163,  81, 108, 199
	.byte	163,  81, 108, 199, 163,  81, 108, 199, 163,  81, 108, 199, 163,  81, 108, 199
	.byte	 25, 232, 146, 209,  25, 232, 146, 209,  25, 232, 146, 209,  25, 232, 146, 209
	.byte	 25, 232, 146, 209,  25, 232, 146, 209,  25, 232, 146, 209,  25, 232, 146, 209
	.byte	 36,   6, 153, 214,  36,   6, 153, 214,  36,   6, 153, 214,  36,   6, 153, 214
	.byte	 36,   6, 153, 214,  36,   6, 153, 214,  36,   6, 153, 214,  36,   6, 153, 214
	.byte	133,  53,  14, 244, 133,  53,  14, 244, 133,  53,  14, 244, 133,  53,  14, 244
	.byte	133,  53,  14, 244, 133,  53,  14, 244, 133,  53,  14, 244, 133,  53,  14, 244
	.byte	112, 160, 106,  16, 112, 160, 106,  16, 112, 160, 106,  16, 112, 160, 106,  16
	.byte	112, 160, 106,  16, 112, 160, 106,  16, 112, 160, 106,  16, 112, 160, 106,  16
	.byte	 22, 193, 164,  25,  22, 193, 164,  25,  22, 193, 164,  25,  22, 193, 164,  25
	.byte	 22, 193, 164,  25,  22, 193, 164,  25,  22, 193, 164,  25,  22, 193, 164,  25
	.byte	  8, 108,  55,  30,   8, 108,  55,  30,   8, 108,  55,  30,   8, 108,  55,  30
	.byte	  8, 108,  55,  30,   8, 108,  55,  30,   8, 108,  55,  30,   8, 108,  55,  30
	.byte	 76, 119,  72,  39,  76, 119,  72,  39,  76, 119,  72,  39,  76, 119,  72,  39
	.byte	 76, 119,  72,  39,  76, 119,  72,  39,  76, 119,  72,  39,  76, 119,  72,  39
	.byte	181, 188, 176,  52, 181, 188, 176,  52, 181, 188, 176,  52, 181, 188, 176,  52
	.byte	181, 188, 176,  52, 181, 188, 176,  52, 181, 188, 176,  52, 181, 188, 176,  52
	.byte	179,  12,  28,  57, 179,  12,  28,  57, 179,  12,  28,  57, 179,  12,  28,  57
	.byte	179,  12,  28,  57, 179,  12,  28,  57, 179,  12,  28,  57, 179,  12,  28,  57
	.byte	 74, 170, 216,  78,  74, 170, 216,  78,  74, 170, 216,  78,  74, 170, 216,  78
	.byte	 74, 170, 216,  78,  74, 170, 216,  78,  74, 170, 216,  78,  74, 170, 216,  78
	.byte	 79, 202, 156,  91,  79, 202, 156,  91,  79, 202, 156,  91,  79, 202, 156,  91
	.byte	 79, 202, 156,  91,  79, 202, 156,  91,  79, 202, 156,  91,  79, 202, 156,  91
	.byte	243, 111,  46, 104, 243, 111,  46, 104, 243, 111,  46, 104, 243, 111,  46, 104
	.byte	243, 111,  46, 104, 243, 111,  46, 104, 243, 111,  46, 104, 243, 111,  46, 104
	.byte	238, 130, 143, 116, 238, 130, 143, 116, 238, 130, 143, 116, 238, 130, 143, 116
	.byte	238, 130, 143, 116, 238, 130, 143, 116, 238, 130, 143, 116, 238, 130, 143, 116
	.byte	111,  99, 165, 120, 111,  99, 165, 120, 111,  99, 165, 120, 111,  99, 165, 120
	.byte	111,  99, 165, 120, 111,  99, 165, 120, 111,  99, 165, 120, 111,  99, 165, 120
	.byte	 20, 120, 200, 132,  20, 120, 200, 132,  20, 120, 200, 132,  20, 120, 200, 132
	.byte	 20, 120, 200, 132,  20, 120, 200, 132,  20, 120, 200, 132,  20, 120, 200, 132
	.byte	  8,   2, 199, 140,   8,   2, 199, 140,   8,   2, 199, 140,   8,   2, 199, 140
	.byte	  8,   2, 199, 140,   8,   2, 199, 140,   8,   2, 199, 140,   8,   2, 199, 140
	.byte	250, 255, 190, 144, 250, 255, 190, 144, 250, 255, 190, 144, 250, 255, 190, 144
	.byte	250, 255, 190, 144, 250, 255, 190, 144, 250, 255, 190, 144, 250, 255, 190, 144
	.byte	235, 108,  80, 164, 235, 108,  80, 164, 235, 108,  80, 164, 235, 108,  80, 164
	.byte	235, 108,  80, 164, 235, 108,  80, 164, 235, 108,  80, 164, 235, 108,  80, 164
	.byte	247, 163, 249, 190, 247, 163, 249, 190, 247, 163, 249, 190, 247, 163, 249, 190
	.byte	247, 163, 249, 190, 247, 163, 249, 190, 247, 163, 249, 190, 247, 163, 249, 190
	.byte	242, 120, 113, 198, 242, 120, 113, 198, 242, 120, 113, 198, 242, 120, 113, 198
	.byte	242, 120, 113, 198, 242, 120, 113, 198, 242, 120, 113, 198, 242, 120, 113, 198
G$SHA256_IV:
	.byte	103, 230,   9, 106, 133, 174, 103, 187, 114, 243, 110,  60,  58, 245,  79, 165
	.byte	127,  82,  14,  81, 140, 104,   5, 155, 171, 217, 131,  31,  25, 205, 224,  91
G$SHA512_X4_ROR8:
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
G$SHA512_X4_BSWAP:
	.byte	  7,   6,   5,   4,   3,   2,   1,   0,  15,  14,  13,  12,  11,  10,   9,   8
	.byte	  7,   6,   5,   4,   3,   2,   1,   0,  15,  14,  13,  12,  11,  10,   9,   8
G$SHA512_X4_K:
	.byte	 34, 174,  40, 215, 152,  47, 138,  66,  34, 174,  40, 215, 152,  47, 138,  66
	.byte	 34, 174,  40, 215, 152,  47, 138,  66,  34, 174,  40, 215, 152,  47, 138,  66
	.byte	205, 101, 239,  35, 145,  68,  55, 113, 205, 101, 239,  35, 145,  68,  55, 113
	.byte	205, 101, 239,  35, 145,  68,  55, 113, 205, 101, 239,  35, 145,  68,  55, 113
	.byte	 47,  59,  77, 236, 207, 251, 192, 181,  47,  59,  77, 236, 207, 251, 192, 181
	.byte	 47,  59,  77, 236, 207, 251, 192, 181,  47,  59,  77, 236, 207, 251, 192, 181
	.byte	188, 219, 137, 129, 165, 219, 181, 233, 188, 219, 137, 129, 165, 219, 181, 233
	.byte	188, 219, 137, 129, 165, 219, 181, 233, 188, 219, 137, 129, 165, 219, 181, 233
	.byte	 56, 181,  72, 243,  91, 194,  86,  57,  56, 181,  72, 243,  91, 194,  86,  57
	.byte	 56, 181,  72, 243,  91, 194,  86,  57,  56, 181,  72, 243,  91, 194,  86,  57
	.byte	 25, 208,   5, 182, 241,  17, 241,  89,  25, 208,   5, 182, 241,  17, 241,  89
	.byte	 25, 208,   5, 182, 241,  17, 241,  89,  25, 208,   5, 182, 241,  17, 241,  89
	.byte	155,  79,  25, 175, 164, 130,  63, 146, 155,  79,  25, 175, 164, 130,  63, 146
	.byte	155,  79,  25, 175, 164, 130,  63, 146, 155,  79,  25, 175, 164, 130,  63, 146
	.byte	 24, 129, 109, 218, 213,  94,  28, 171,  24, 129, 109, 218, 213,  94,  28, 171
	.byte	 24, 129, 109, 218, 213,  94,  28, 171,  24, 129, 109, 218, 213,  94,  28, 171
	.byte	 66,   2,   3, 163, 152, 170,   7, 216,  66,   2,   3, 163, 152, 170,   7, 216
	.byte	 66,   2,   3, 163, 152, 170,   7, 216,  66,   2,   3, 163, 152, 170,   7, 216
	.byte	190, 111, 112,  69,   1,  91, 131,  18, 190, 111, 112,  69,   1,  91, 131,  18
	.byte	190, 111, 112,  69,   1,  91, 131,  18, 190, 111, 112,  69,   1,  91, 131,  18
	.byte	140, 178, 228,  78, 190, 133,  49,  36, 140, 178, 228,  78, 190, 133,  49,  36
	.byte	140, 178, 228,  78, 190, 133,  49,  36, 140, 178, 228,  78, 190, 133,  49,  36
	.byte	226, 180, 255, 213, 195, 125,  12,  85, 226, 180, 255, 213, 195, 125,  12,  85
	.byte	226, 180, 255, 213, 195, 125,  12,  85, 226, 180, 255, 213, 195, 125,  12,  85
	.byte	111, 137, 123, 242, 116,  93, 190, 114, 111, 137, 123, 242, 116,  93, 190, 114
	.byte	111, 137, 123, 242, 116,  93, 190, 114, 111, 137, 123, 242, 116,  93, 190, 114
	.byte	177, 150,  22,  59, 254, 177, 222, 128, 177, 150,  22,  59, 254, 177, 222, 128
	.byte	177, 150,  22,  59, 254, 177, 222, 128, 177, 150,  22,  59, 254, 177, 222, 128
	.byte	 53,  18, 199,  37, 167,   6, 220, 155,  53,  18, 199,  37, 167,   6, 220, 155
	.byte	 53,  18, 199,  37, 167,   6, 220, 155,  53,  18, 199,  37, 167,   6, 220, 155
	.byte	148,  38, 105, 207, 116, 241, 155, 193, 148,  38, 105, 207, 116, 241, 155, 193
	.byte	148,  38, 105, 207, 116, 241, 155, 193, 148,  38, 105, 207, 116, 241, 155, 193
	.byte	210,  74, 241, 158, 193, 105, 155, 228, 210,  74, 241, 158, 193, 105, 155, 228
	.byte	210,  74, 241, 158, 193, 105, 155, 228, 210,  74, 241, 158, 193, 105, 155, 228
	.byte	227,  37,  79,  56, 134,  71, 190, 239, 227,  37,  79,  56, 134,  71, 190, 239
	.byte	227,  37,  79,  56, 134,  71, 190, 239, 227,  37,  79,  56, 134,  71, 190, 239
	.byte	181, 213, 140, 139, 198, 157, 193,  15, 181, 213, 140, 139, 198, 157, 193,  15
	.byte	181, 213, 140, 139, 198, 157, 193,  15, 181, 213, 140, 139, 198, 157, 193,  15
	.byte	101, 156, 172, 119, 204, 161,  12,  36, 101, 156, 172, 119, 204, 161,  12,  36
	.byte	101, 156, 172, 119, 204, 161,  12,  36, 101, 156, 172, 119, 204, 161,  12,  36
	.byte	117,   2,  43,  89, 111,  44, 233,  45, 117,   2,  43,  89, 111,  44, 233,  45
	.byte	117,   2,  43,  89, 111,  44, 233,  45, 117,   2,  43,  89, 111,  44, 233,  45
	.byte	131, 228, 166, 110, 170, 132, 116,  74, 131, 228, 166, 110, 170, 132, 116,  74
	.byte	131, 228, 166, 110, 170, 132, 116,  74, 131, 228, 166, 110, 170, 132, 116,  74
	.byte	212, 251,  65, 189, 220, 169, 176,  92, 212, 251,  65, 189, 220, 169, 176,  92
	.byte	212, 251,  65, 189, 220, 169, 176,  92, 212, 251,  65, 189, 220, 169, 176,  92
	.byte	181,  83,  17, 131, 218, 136, 249, 118, 181,  83,  17, 131, 218, 136, 249, 118
	.byte	181,  83,  17, 131, 218, 136, 249, 118, 181,  83,  17, 131, 218, 136, 249, 118
	.byte	171, 223, 102, 238,  82,  81,  62, 152, 171, 223, 102, 238,  82,  81,  62, 152
	.byte	171, 223, 102, 238,  82,  81,  62, 152, 171, 223, 102, 238,  82,  81,  62, 152
	.byte	 16,  50, 180,  45, 109, 198,  49, 168,  16,  50, 180,  45, 109, 198,  49, 168
	.byte	 16,  50, 180,  45, 109, 198,  49, 168,  16,  50, 180,  45, 109, 198,  49, 168
	.byte	 63,  33, 251, 152, 200,  39,   3, 176,  63,  33, 251, 152, 200,  39,   3, 176
	.byte	 63,  33, 251, 152, 200,  39,   3, 176,  63,  33, 251, 152, 200,  39,   3, 176
	.byte	228,  14, 239, 190, 199, 127,  89, 191, 228,  14, 239, 190, 199, 127,  89, 191
	.byte	228,  14, 239, 190, 199, 127,  89, 191, 228,  14, 239, 190, 199, 127,  89, 191
	.byte	194, 143, 168,  61, 243,  11, 224, 198, 194, 143, 168,  61, 243,  11, 224, 198
	.byte	194, 143, 168,  61, 243,  11, 224, 198, 194, 143, 168,  61, 243,  11, 224, 198
	.byte	 37, 167,  10, 147,  71, 145, 167, 213,  37, 167,  10, 147,  71, 145, 167, 213
	.byte	 37, 167,  10, 147,  71, 145, 167, 213,  37, 167,  10, 147,  71, 145, 167, 213
	.byte	111, 130,   3, 224,  81,  99, 202,   6, 111, 130,   3, 224,  81,  99, 202,   6
	.byte	111, 130,   3, 224,  81,  99, 202,   6, 111, 130,   3, 224,  81,  99, 202,   6
	.byte	112, 110,  14,  10, 103,  41,  41,  20, 112, 110,  14,  10, 103,  41,  41,  20
	.byte	112, 110,  14,  10, 103,  41,  41,  20, 112, 110,  14,  10, 103,  41,  41,  20
	.byte	252,  47, 210,  70, 133,  10, 183,  39, 252,  47, 210,  70, 133,  10, 183,  39
	.byte	252,  47, 210,  70, 133,  10, 183,  39, 252,  47, 210,  70, 133,  10, 183,  39
	.byte	 38, 201,  38,  92,  56,  33,  27,  46,  38, 201,  38,  92,  56,  33,  27,  46
	.byte	 38, 201,  38,  92,  56,  33,  27,  46,  38, 201,  38,  92,  56,  33,  27,  46
	.byte	237,  42, 196,  90, 252, 109,  44,  77, 237,  42, 196,  90, 252, 109,  44,  77
	.byte	237,  42, 196,  90, 252, 109,  44,  77, 237,  42, 196,  90, 252, 109,  44,  77
	.byte	223, 179, 149, 157,  19,  13,  56,  83, 223, 179, 149, 157,  19,  13,  56,  83
	.byte	223, 179, 149, 157,  19,  13,  56,  83, 223, 179, 149, 157,  19,  13,  56,  83
	.byte	222,  99, 175, 139,  84, 115,  10, 101, 222,  99, 175, 139,  84, 115,  10, 101
	.byte	222,  99, 175, 139,  84, 115,  10, 101, 222,  99, 175, 139,  84, 115,  10, 101
	.byte	168, 178, 119,  60, 187,  10, 106, 118, 168, 178, 119,  60, 187,  10, 106, 118
	.byte	168, 178, 119,  60, 187,  10, 106, 118, 168, 178, 119,  60, 187,  10, 106, 118
	.byte	230, 174, 237,  71,  46, 201, 194, 129, 230, 174, 237,  71,  46, 201, 194, 129
	.byte	230, 174, 237,  71,  46, 201, 194, 129, 230, 174, 237,  71,  46, 201, 194, 129
	.byte	 59,  53, 130,  20, 133,  44, 114, 146,  59,  53, 130,  20, 133,  44, 114, 146
	.byte	 59,  53, 130,  20, 133,  44, 114, 146,  59,  53, 130,  20, 133,  44, 114, 146
	.byte	100,   3, 241,  76, 161, 232, 191, 162, 100,   3, 241,  76, 161, 232, 191, 162
	.byte	100,   3, 241,  76, 161, 232, 191, 162, 100,   3, 241,  76, 161, 232, 191, 162
	.byte	  1,  48,  66, 188,  75, 102,  26, 168,   1,  48,  66, 188,  75, 102,  26, 168
	.byte	  1,  48,  66, 188,  75, 102,  26, 168,   1,  48,  66, 188,  75, 102,  26, 168
	.byte	145, 151, 248, 208, 112, 139,  75, 194, 145, 151, 248, 208, 112, 139,  75, 194
	.byte	145, 151, 248, 208, 112, 139,  75, 194, 145, 151, 248, 208, 112, 139,  75, 194
	.byte	 48, 190,  84,   6, 163,  81, 108, 199,  48, 190,  84,   6, 163,  81, 108, 199
	.byte	 48, 190,  84,   6, 163,  81, 108, 199,  48, 190,  84,   6, 163,  81, 108, 199
	.byte	 24,  82, 239, 214,  25, 232, 146, 209,  24,  82, 239, 214,  25, 232, 146, 209
	.byte	 24,  82, 239, 214,  25, 232, 146, 209,  24,  82, 239, 214,  25, 232, 146, 209
	.byte	 16, 169, 101,  85,  36,   6, 153, 214,  16, 169, 101,  85,  36,   6, 153, 214
	.byte	 16, 169, 101,  85,  36,   6, 153, 214,  16, 169, 101,  85,  36,   6, 153, 214
	.byte	 42,  32, 113,  87, 133,  53,  14, 244,  42,  32, 113,  87, 133,  53,  14, 244
	.byte	 42,  32, 113,  87, 133,  53,  14, 244,  42,  32, 113,  87, 133,  53,  14, 244
	.byte	184, 209, 187,  50, 112, 160, 106,  16, 184, 209, 187,  50, 112, 160, 106,  16
	.byte	184, 209, 187,  50, 112, 160, 106,  16, 184, 209, 187,  50, 112, 160, 106,  16
	.byte	200, 208, 210, 184,  22, 193, 164,  25, 200, 208, 210, 184,  22, 193, 164,  25
	.byte	200, 208, 210, 184,  22, 193, 164,  25, 200, 208, 210, 184,  22, 193, 164,  25
	.byte	 83, 171,  65,  81,   8, 108,  55,  30,  83, 171,  65,  81,   8, 108,  55,  30
	.byte	 83, 171,  65,  81,   8, 108,  55,  30,  83, 171,  65,  81,   8, 108,  55,  30
	.byte	153, 235, 142, 223,  76, 119,  72,  39, 153, 235, 142, 223,  76, 119,  72,  39
	.byte	153, 235, 142, 223,  76, 119,  72,  39, 153, 235, 142, 223,  76, 119,  72,  39
	.byte	168,  72, 155, 225, 181, 188, 176,  52, 168,  72, 155, 225, 181, 188, 176,  52
	.byte	168,  72, 155, 225, 181, 188, 176,  52, 168,  72, 155, 225, 181, 188, 176,  52
	.byte	 99,  90, 201, 197, 179,  12,  28,  57,  99,  90, 201, 197, 179,  12,  28,  57
	.byte	 99,  90, 201, 197, 179,  12,  28,  57,  99,  90, 201, 197, 179,  12,  28,  57
	.byte	203, 138,  65, 227,  74, 170, 216,  78, 203, 138,  65, 227,  74, 170, 216,  78
	.byte	203, 138,  65, 227,  74, 170, 216,  78, 203, 138,  65, 227,  74, 170, 216,  78
	.byte	115, 227,  99, 119,  79, 202, 156,  91, 115, 227,  99, 119,  79, 202, 156,  91
	.byte	115, 227,  99, 119,  79, 202, 156,  91, 115, 227,  99, 119,  79, 202, 156,  91
	.byte	163, 184, 178, 214, 243, 111,  46, 104, 163, 184, 178, 214, 243, 111,  46, 104
	.byte	163, 184, 178, 214, 243, 111,  46, 104, 163, 184, 178, 214, 243, 111,  46, 104
	.byte	252, 178, 239,  93, 238, 130, 143, 116, 252, 178, 239,  93, 238, 130, 143, 116
	.byte	252, 178, 239,  93, 238, 130, 143, 116, 252, 178, 239,  93, 238, 130, 143, 116
	.byte	 96,  47,  23,  67, 111,  99, 165, 120,  96,  47,  23,  67, 111,  99, 165, 120
	.byte	 96,  47,  23,  67, 111,  99, 165, 120,  96,  47,  23,  67, 111,  99, 165, 120
	.byte	114, 171, 240, 161,  20, 120, 200, 132, 114, 171, 240, 161,  20, 120, 200, 132
	.byte	114, 171, 240, 161,  20, 120, 200, 132, 114, 171, 240, 161,  20, 120, 200, 132
	.byte	236,  57, 100,  26,   8,   2, 199, 140, 236,  57, 100,  26,   8,   2, 199, 140
	.byte	236,  57, 100,  26,   8,   2, 199, 140, 236,  57, 100,  26,   8,   2, 199, 140
	.byte	 40,  30,  99,  35, 250, 255, 190, 144,  40,  30,  99,  35, 250, 255, 190, 144
	.byte	 40,  30,  99,  35, 250, 255, 190, 144,  40,  30,  99,  35, 250, 255, 190, 144
	.byte	233, 189, 130, 222, 235, 108,  80, 164, 233, 189, 130, 222, 235, 108,  80, 164
	.byte	233, 189, 130, 222, 235, 108,  80, 164, 233, 189, 130, 222, 235, 108,  80, 164
	.byte	 21, 121, 198, 178, 247, 163, 249, 190,  21, 121, 198, 178, 247, 163, 249, 190
	.byte	 21, 121, 198, 178, 247, 163, 249, 190,  21, 121, 198, 178, 247, 163, 249, 190
	.byte	 43,  83, 114, 227, 242, 120, 113, 198,  43,  83, 114, 227, 242, 120, 113, 198
	.byte	 43,  83, 114, 227, 242, 120, 113, 198,  43,  83, 114, 227, 242, 120, 113, 198
	.byte	156,  97,  38, 234, 206,  62,  39, 202, 156,  97,  38, 234, 206,  62,  39, 202
	.byte	156,  97,  38, 234, 206,  62,  39, 202, 156,  97,  38, 234, 206,  62,  39, 202
	.byte	  7, 194, 192,  33, 199, 184, 134, 209,   7, 194, 192,  33, 199, 184, 134, 209
	.byte	  7, 194, 192,  33, 199, 184, 134, 209,   7, 194, 192,  33, 199, 184, 134, 209
	.byte	 30, 235, 224, 205, 214, 125, 218, 234,  30, 235, 224, 205, 214, 125, 218, 234
	.byte	 30, 235, 224, 205, 214, 125, 218, 234,  30, 235, 224, 205, 214, 125, 218, 234
	.byte	120, 209, 110, 238, 127,  79, 125, 245, 120, 209, 110, 238, 127,  79, 125, 245
	.byte	120, 209, 110, 238, 127,  79, 125, 245, 120, 209, 110, 238, 127,  79, 125, 245
	.byte	186, 111,  23, 114, 170, 103, 240,   6, 186, 111,  23, 114, 170, 103, 240,   6
	.byte	186, 111,  23, 114, 170, 103, 240,   6, 186, 111,  23, 114, 170, 103, 240,   6
	.byte	166, 152, 200, 162, 197, 125,  99,  10, 166, 152, 200, 162, 197, 125,  99,  10
	.byte	166, 152, 200, 162, 197, 125,  99,  10, 166, 152, 200, 162, 197, 125,  99,  10
	.byte	174,  13, 249, 190,   4, 152,  63,  17, 174,  13, 249, 190,   4, 152,  63,  17
	.byte	174,  13, 249, 190,   4, 152,  63,  17, 174,  13, 249, 190,   4, 152,  63,  17
	.byte	 27,  71,  28,  19,  53,  11, 113,  27,  27,  71,  28,  19,  53,  11, 113,  27
	.byte	 27,  71,  28,  19,  53,  11, 113,  27,  27,  71,  28,  19,  53,  11, 113,  27
	.byte	132, 125,   4,  35, 245, 119, 219,  40, 132, 125,   4,  35, 245, 119, 219,  40
	.byte	132, 125,   4,  35, 245, 119, 219,  40, 132, 125,   4,  35, 245, 119, 219,  40
	.byte	147,  36, 199,  64, 123, 171, 202,  50, 147,  36, 199,  64, 123, 171, 202,  50
	.byte	147,  36, 199,  64, 123, 171, 202,  50, 147,  36, 199,  64, 123, 171, 202,  50
	.byte	188, 190, 201,  21,  10, 190, 158,  60, 188, 190, 201,  21,  10, 190, 158,  60
	.byte	188, 190, 201,  21,  10, 190, 158,  60, 188, 190, 201,  21,  10, 190, 158,  60
	.byte	 76,  13,  16, 156, 196, 103,  29,  67,  76,  13,  16, 156, 196, 103,  29,  67
	.byte	 76,  13,  16, 156, 196, 103,  29,  67,  76,  13,  16, 156, 196, 103,  29,  67
	.byte	182,  66,  62, 203, 190, 212, 197,  76, 182,  66,  62, 203, 190, 212, 197,  76
	.byte	182,  66,  62, 203, 190, 212, 197,  76, 182,  66,  62, 203, 190, 212, 197,  76
	.byte	 42, 126, 101, 252, 156,  41, 127,  89,  42, 126, 101, 252, 156,  41, 127,  89
	.byte	 42, 126, 101, 252, 156,  41, 127,  89,  42, 126, 101, 252, 156,  41, 127,  89
	.byte	236, 250, 214,  58, 171, 111, 203,  95, 236, 250, 214,  58, 171, 111, 203,  95
	.byte	236, 250, 214,  58, 171, 111, 203,  95, 236, 250, 214,  58, 171, 111, 203,  95
	.byte	 23,  88,  71,  74, 140,  25,  68, 108,  23,  88,  71,  74, 140,  25,  68, 108
	.byte	 23,  88,  71,  74, 140,  25,  68, 108,  23,  88,  71,  74, 140,  25,  68, 108
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
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
