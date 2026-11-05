	.att_syntax
	.text
	.p2align	5
	.global	ml_dsa_65_verify
	.global	ml_dsa_65_sign
	.global	ml_dsa_65_keygen
	.type	ml_dsa_65_verify, %function
ml_dsa_65_verify:
	movq	%rsp, %rax
	leaq	-56(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	lfence
	movq	$0, %r9
	movq	(%rsi), %rax
	movq	8(%rsi), %rsi
	lfence
	movq	$0, %r9
	cmpq	$255, %rsi
	jbe 	.Lml_dsa_65_verify$1
	movq	$-1, %r11
	jmp 	.Lml_dsa_65_verify$2
.Lml_dsa_65_verify$1:
	leaq	-63096(%rsp), %rsp
	call	.L__verify_internal$1
.Lml_dsa_65_verify$3:
	leaq	63096(%rsp), %rsp
.Lml_dsa_65_verify$2:
	movq	%r11, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_65_sign, %function
ml_dsa_65_sign:
	movq	%rsp, %rax
	leaq	-56(%rsp), %rsp
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
	movq	(%rdx), %rax
	movq	8(%rdx), %rdx
	lfence
	movq	$0, %r10
	cmpq	$255, %rdx
	jbe 	.Lml_dsa_65_sign$1
	movq	$-1, %rax
	jmp 	.Lml_dsa_65_sign$2
.Lml_dsa_65_sign$1:
	leaq	-117336(%rsp), %rsp
	call	.L__sign_internal$1
.Lml_dsa_65_sign$3:
	leaq	117336(%rsp), %rsp
.Lml_dsa_65_sign$2:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_65_keygen, %function
ml_dsa_65_keygen:
	movq	%rsp, %rax
	leaq	-56(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, (%rsp)
	movq	%rbp, 8(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r14, 32(%rsp)
	movq	%r15, 40(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rdx, %rcx
	lfence
	movq	$0, %rax
	leaq	-61976(%rsp), %rsp
	call	.L__keygen_internal$1
.Lml_dsa_65_keygen$1:
	leaq	61976(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
.L__verify_internal$1:
	movq	%rax, 63008(%rsp)
	movq	%rsi, 63016(%rsp)
	movq	%rdx, 63024(%rsp)
	movq	%rcx, 63032(%rsp)
	leaq	8736(%rsp), %rax
	leaq	13856(%rsp), %rcx
	leaq	48(%r8), %rdx
	movq	%rax, %rsi
	movq	%rdx, %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$397
.L__verify_internal$398:
	vmovdqu	(%r9,%r10), %xmm2
	addq	$4, %r10
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r10), %xmm2
	addq	$16, %r10
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$397:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$398
	leaq	1024(%rax), %rsi
	leaq	640(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$395
.L__verify_internal$396:
	vmovdqu	(%r9,%r10), %xmm2
	addq	$4, %r10
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r10), %xmm2
	addq	$16, %r10
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$395:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$396
	leaq	2048(%rax), %rsi
	leaq	1280(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$393
.L__verify_internal$394:
	vmovdqu	(%r9,%r10), %xmm2
	addq	$4, %r10
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r10), %xmm2
	addq	$16, %r10
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$393:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$394
	leaq	3072(%rax), %rsi
	leaq	1920(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$391
.L__verify_internal$392:
	vmovdqu	(%r9,%r10), %xmm2
	addq	$4, %r10
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r10), %xmm2
	addq	$16, %r10
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$391:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$392
	leaq	4096(%rax), %rax
	leaq	2560(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$389
.L__verify_internal$390:
	vmovdqu	(%r9,%r10), %xmm2
	addq	$4, %r10
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r10), %xmm2
	addq	$16, %r10
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
.L__verify_internal$389:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$390
	leaq	3248(%r8), %rax
	lfence
	movq	$0, %rdx
	movq	$0, %r11
	movq	$0, %r12
	movq	$0, %rsi
	jmp 	.L__verify_internal$371
.L__verify_internal$372:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%rsi, %r9
	shlq	$8, %r9
	movq	$0, %r10
	jmp 	.L__verify_internal$387
.L__verify_internal$388:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%r9, %rbx
	addq	%r10, %rbx
	movl	$0, (%rcx,%rbx,4)
	incq	%r10
.L__verify_internal$387:
	cmpq	$256, %r10
	jb  	.L__verify_internal$388
	movq	$-1, %r10
	cmovb	%r10, %rdx
	movzbq	55(%rax,%rsi), %r10
	orq 	%rdx, %r10
	cmpq	%r12, %r10
	jb  	.L__verify_internal$375
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	cmpq	$55, %r10
	jnbe	.L__verify_internal$377
	movq	$-1, %rbx
	cmovnbe	%rbx, %rdx
	movq	%r12, %rbx
	jmp 	.L__verify_internal$379
.L__verify_internal$380:
	movq	$-1, %rbp
	cmovne	%rbp, %rdx
	movzbq	(%rax,%rbx), %rbp
	orq 	%rdx, %rbp
	cmpq	%r12, %rbx
	jnbe	.L__verify_internal$383
	movq	$-1, %r13
	cmovnbe	%r13, %rdx
	jmp 	.L__verify_internal$384
.L__verify_internal$383:
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	movzbq	-1(%rax,%rbx), %r13
	orq 	%rdx, %r13
	cmpq	%r13, %rbp
	jbe 	.L__verify_internal$385
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	jmp 	.L__verify_internal$384
.L__verify_internal$385:
	movq	$-1, %r11
	cmovnbe	%r11, %rdx
	movq	$1, %r11
.L__verify_internal$386:
.L__verify_internal$384:
	cmpq	$0, %r11
	je  	.L__verify_internal$381
	movq	$-1, %rbp
	cmove	%rbp, %rdx
	jmp 	.L__verify_internal$379
.L__verify_internal$381:
	movq	$-1, %r13
	cmovne	%r13, %rdx
	movq	%r9, %r13
	addq	%rbp, %r13
	movl	$1, (%rcx,%r13,4)
	incq	%rbx
.L__verify_internal$382:
.L__verify_internal$379:
	cmpq	%r10, %rbx
	setnb	%bpl
	orb 	%r11b, %bpl
	cmpb	$0, %bpl
	je  	.L__verify_internal$380
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$376
.L__verify_internal$377:
	movq	$-1, %r9
	cmovbe	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$378:
	jmp 	.L__verify_internal$376
.L__verify_internal$375:
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$376:
	cmpq	$0, %r11
	je  	.L__verify_internal$373
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$371
.L__verify_internal$373:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%r10, %r12
	incq	%rsi
.L__verify_internal$374:
.L__verify_internal$371:
	cmpq	$6, %rsi
	setnb	%r9b
	orb 	%r11b, %r9b
	cmpb	$0, %r9b
	je  	.L__verify_internal$372
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$365
.L__verify_internal$366:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	movzbq	(%rax,%r12), %rcx
	orq 	%rdx, %rcx
	cmpq	$0, %rcx
	jne 	.L__verify_internal$369
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	jmp 	.L__verify_internal$370
.L__verify_internal$369:
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	movq	$1, %r11
.L__verify_internal$370:
	cmpq	$0, %r11
	je  	.L__verify_internal$367
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$365
.L__verify_internal$367:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	incq	%r12
.L__verify_internal$368:
.L__verify_internal$365:
	cmpq	$55, %r12
	setnb	%cl
	orb 	%r11b, %cl
	cmpb	$0, %cl
	je  	.L__verify_internal$366
	negq	%r11
	leaq	8736(%rsp), %rax
	movq	$0, %rcx
	movq	%rax, %rsi
	movq	$524091, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$363
.L__verify_internal$364:
	vmovdqu	(%rsi,%rdx), %ymm10
	vpabsd	%ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$363:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$364
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	1024(%rax), %rsi
	movq	$524091, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$361
.L__verify_internal$362:
	vmovdqu	(%rsi,%rdx), %ymm10
	vpabsd	%ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$361:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$362
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	2048(%rax), %rsi
	movq	$524091, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$359
.L__verify_internal$360:
	vmovdqu	(%rsi,%rdx), %ymm10
	vpabsd	%ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$359:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$360
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	3072(%rax), %rsi
	movq	$524091, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$357
.L__verify_internal$358:
	vmovdqu	(%rsi,%rdx), %ymm10
	vpabsd	%ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$357:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$358
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	4096(%rax), %rax
	movq	$524091, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$355
.L__verify_internal$356:
	vmovdqu	(%rax,%rdx), %ymm10
	vpabsd	%ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$355:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$356
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
// declassify_val u64 %rcx
	orq 	%rcx, %r11
	lfence
	movq	$0, %rax
	cmpq	$0, %r11
	jne 	.L__verify_internal$2
	movq	%r8, 63040(%rsp)
	movq	%rdi, 63048(%rsp)
	vmovdqu	(%rdi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 63056(%rsp)
	movw	$1, 63058(%rsp)
	movw	$2, 63060(%rsp)
	movw	$3, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$354:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$353:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$352:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$351:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$350:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$349:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	32288(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$348:
	movq	%rdi, %r11
	leaq	33312(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$347:
	movq	%rdi, %rbx
	leaq	34336(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$346:
	movq	%rdi, %r10
	leaq	35360(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$345:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$338
	cmpq	$256, %rbx
	jb  	.L__verify_internal$340
	cmpq	$256, %r10
	jb  	.L__verify_internal$342
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$324
	movl	$0, %esi
.L__verify_internal$344:
	jmp 	.L__verify_internal$324
.L__verify_internal$342:
	movl	$0, %esi
.L__verify_internal$343:
	jmp 	.L__verify_internal$324
.L__verify_internal$340:
	movl	$0, %esi
.L__verify_internal$341:
	jmp 	.L__verify_internal$324
.L__verify_internal$338:
	movl	$0, %esi
.L__verify_internal$339:
	jmp 	.L__verify_internal$324
.L__verify_internal$325:
	movq	%r11, 63064(%rsp)
	movq	%rbx, 63072(%rsp)
	movq	%r10, 63080(%rsp)
	movq	%rdi, 63088(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$337:
	movq	63064(%rsp), %rdi
	movq	63072(%rsp), %rbx
	movq	63080(%rsp), %r10
	movq	63088(%rsp), %r12
	leaq	32288(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$336:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	33312(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$335:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	34336(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$334:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	35360(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$333:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$326
	cmpq	$256, %rbx
	jb  	.L__verify_internal$328
	cmpq	$256, %r10
	jb  	.L__verify_internal$330
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$324
	movl	$0, %esi
.L__verify_internal$332:
	jmp 	.L__verify_internal$324
.L__verify_internal$330:
	movl	$0, %esi
.L__verify_internal$331:
	jmp 	.L__verify_internal$324
.L__verify_internal$328:
	movl	$0, %esi
.L__verify_internal$329:
	jmp 	.L__verify_internal$324
.L__verify_internal$326:
	movl	$0, %esi
.L__verify_internal$327:
.L__verify_internal$324:
	cmpl	$1, %esi
	jne 	.L__verify_internal$325
	movw	$4, 63056(%rsp)
	movw	$256, 63058(%rsp)
	movw	$257, 63060(%rsp)
	movw	$258, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$323:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$322:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$321:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$320:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$319:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$318:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	36384(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$317:
	movq	%rdi, %r10
	leaq	37408(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$316:
	movq	%rdi, %rbx
	leaq	38432(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$315:
	movq	%rdi, %r11
	leaq	39456(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$314:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$307
	cmpq	$256, %rbx
	jb  	.L__verify_internal$309
	cmpq	$256, %r11
	jb  	.L__verify_internal$311
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$293
	movl	$0, %esi
.L__verify_internal$313:
	jmp 	.L__verify_internal$293
.L__verify_internal$311:
	movl	$0, %esi
.L__verify_internal$312:
	jmp 	.L__verify_internal$293
.L__verify_internal$309:
	movl	$0, %esi
.L__verify_internal$310:
	jmp 	.L__verify_internal$293
.L__verify_internal$307:
	movl	$0, %esi
.L__verify_internal$308:
	jmp 	.L__verify_internal$293
.L__verify_internal$294:
	movq	%r10, 63088(%rsp)
	movq	%rbx, 63080(%rsp)
	movq	%r11, 63072(%rsp)
	movq	%rdi, 63064(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$306:
	movq	63088(%rsp), %rdi
	movq	63080(%rsp), %rbx
	movq	63072(%rsp), %r11
	movq	63064(%rsp), %r12
	leaq	36384(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$305:
	movq	%rdi, %r10
	movq	%rbx, %rdi
	leaq	37408(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$304:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	38432(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$303:
	movq	%rdi, %r11
	movq	%r12, %rdi
	leaq	39456(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$302:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$295
	cmpq	$256, %rbx
	jb  	.L__verify_internal$297
	cmpq	$256, %r11
	jb  	.L__verify_internal$299
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$293
	movl	$0, %esi
.L__verify_internal$301:
	jmp 	.L__verify_internal$293
.L__verify_internal$299:
	movl	$0, %esi
.L__verify_internal$300:
	jmp 	.L__verify_internal$293
.L__verify_internal$297:
	movl	$0, %esi
.L__verify_internal$298:
	jmp 	.L__verify_internal$293
.L__verify_internal$295:
	movl	$0, %esi
.L__verify_internal$296:
.L__verify_internal$293:
	cmpl	$1, %esi
	jne 	.L__verify_internal$294
	movw	$259, 63056(%rsp)
	movw	$260, 63058(%rsp)
	movw	$512, 63060(%rsp)
	movw	$513, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$292:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$291:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$290:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$289:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$288:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$287:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	40480(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$286:
	movq	%rdi, %r10
	leaq	41504(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$285:
	movq	%rdi, %r11
	leaq	42528(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$284:
	movq	%rdi, %rbx
	leaq	43552(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$283:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$276
	cmpq	$256, %r11
	jb  	.L__verify_internal$278
	cmpq	$256, %rbx
	jb  	.L__verify_internal$280
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$262
	movl	$0, %esi
.L__verify_internal$282:
	jmp 	.L__verify_internal$262
.L__verify_internal$280:
	movl	$0, %esi
.L__verify_internal$281:
	jmp 	.L__verify_internal$262
.L__verify_internal$278:
	movl	$0, %esi
.L__verify_internal$279:
	jmp 	.L__verify_internal$262
.L__verify_internal$276:
	movl	$0, %esi
.L__verify_internal$277:
	jmp 	.L__verify_internal$262
.L__verify_internal$263:
	movq	%r10, 63064(%rsp)
	movq	%r11, 63072(%rsp)
	movq	%rbx, 63080(%rsp)
	movq	%rdi, 63088(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$275:
	movq	63064(%rsp), %rdi
	movq	63072(%rsp), %r11
	movq	63080(%rsp), %rbx
	movq	63088(%rsp), %r12
	leaq	40480(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$274:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	41504(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$273:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	42528(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$272:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	43552(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$271:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$264
	cmpq	$256, %r11
	jb  	.L__verify_internal$266
	cmpq	$256, %rbx
	jb  	.L__verify_internal$268
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$262
	movl	$0, %esi
.L__verify_internal$270:
	jmp 	.L__verify_internal$262
.L__verify_internal$268:
	movl	$0, %esi
.L__verify_internal$269:
	jmp 	.L__verify_internal$262
.L__verify_internal$266:
	movl	$0, %esi
.L__verify_internal$267:
	jmp 	.L__verify_internal$262
.L__verify_internal$264:
	movl	$0, %esi
.L__verify_internal$265:
.L__verify_internal$262:
	cmpl	$1, %esi
	jne 	.L__verify_internal$263
	movw	$514, 63056(%rsp)
	movw	$515, 63058(%rsp)
	movw	$516, 63060(%rsp)
	movw	$768, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$261:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$260:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$259:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$258:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$257:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$256:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	44576(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$255:
	movq	%rdi, %rbx
	leaq	45600(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$254:
	movq	%rdi, %r11
	leaq	46624(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$253:
	movq	%rdi, %r10
	leaq	47648(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$252:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$245
	cmpq	$256, %r11
	jb  	.L__verify_internal$247
	cmpq	$256, %r10
	jb  	.L__verify_internal$249
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$231
	movl	$0, %esi
.L__verify_internal$251:
	jmp 	.L__verify_internal$231
.L__verify_internal$249:
	movl	$0, %esi
.L__verify_internal$250:
	jmp 	.L__verify_internal$231
.L__verify_internal$247:
	movl	$0, %esi
.L__verify_internal$248:
	jmp 	.L__verify_internal$231
.L__verify_internal$245:
	movl	$0, %esi
.L__verify_internal$246:
	jmp 	.L__verify_internal$231
.L__verify_internal$232:
	movq	%rbx, 63088(%rsp)
	movq	%r11, 63080(%rsp)
	movq	%r10, 63072(%rsp)
	movq	%rdi, 63064(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$244:
	movq	63088(%rsp), %rdi
	movq	63080(%rsp), %r11
	movq	63072(%rsp), %r10
	movq	63064(%rsp), %r12
	leaq	44576(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$243:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	45600(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$242:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	46624(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$241:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	47648(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$240:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$233
	cmpq	$256, %r11
	jb  	.L__verify_internal$235
	cmpq	$256, %r10
	jb  	.L__verify_internal$237
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$231
	movl	$0, %esi
.L__verify_internal$239:
	jmp 	.L__verify_internal$231
.L__verify_internal$237:
	movl	$0, %esi
.L__verify_internal$238:
	jmp 	.L__verify_internal$231
.L__verify_internal$235:
	movl	$0, %esi
.L__verify_internal$236:
	jmp 	.L__verify_internal$231
.L__verify_internal$233:
	movl	$0, %esi
.L__verify_internal$234:
.L__verify_internal$231:
	cmpl	$1, %esi
	jne 	.L__verify_internal$232
	movw	$769, 63056(%rsp)
	movw	$770, 63058(%rsp)
	movw	$771, 63060(%rsp)
	movw	$772, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$230:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$229:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$228:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$227:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$226:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$225:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	48672(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$224:
	movq	%rdi, %r10
	leaq	49696(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$223:
	movq	%rdi, %r11
	leaq	50720(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$222:
	movq	%rdi, %rbx
	leaq	51744(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$221:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$214
	cmpq	$256, %r11
	jb  	.L__verify_internal$216
	cmpq	$256, %rbx
	jb  	.L__verify_internal$218
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$200
	movl	$0, %esi
.L__verify_internal$220:
	jmp 	.L__verify_internal$200
.L__verify_internal$218:
	movl	$0, %esi
.L__verify_internal$219:
	jmp 	.L__verify_internal$200
.L__verify_internal$216:
	movl	$0, %esi
.L__verify_internal$217:
	jmp 	.L__verify_internal$200
.L__verify_internal$214:
	movl	$0, %esi
.L__verify_internal$215:
	jmp 	.L__verify_internal$200
.L__verify_internal$201:
	movq	%r10, 63064(%rsp)
	movq	%r11, 63072(%rsp)
	movq	%rbx, 63080(%rsp)
	movq	%rdi, 63088(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$213:
	movq	63064(%rsp), %rdi
	movq	63072(%rsp), %r11
	movq	63080(%rsp), %rbx
	movq	63088(%rsp), %r12
	leaq	48672(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$212:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	49696(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$211:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	50720(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$210:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	51744(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$209:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$202
	cmpq	$256, %r11
	jb  	.L__verify_internal$204
	cmpq	$256, %rbx
	jb  	.L__verify_internal$206
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$200
	movl	$0, %esi
.L__verify_internal$208:
	jmp 	.L__verify_internal$200
.L__verify_internal$206:
	movl	$0, %esi
.L__verify_internal$207:
	jmp 	.L__verify_internal$200
.L__verify_internal$204:
	movl	$0, %esi
.L__verify_internal$205:
	jmp 	.L__verify_internal$200
.L__verify_internal$202:
	movl	$0, %esi
.L__verify_internal$203:
.L__verify_internal$200:
	cmpl	$1, %esi
	jne 	.L__verify_internal$201
	movw	$1024, 63056(%rsp)
	movw	$1025, 63058(%rsp)
	movw	$1026, 63060(%rsp)
	movw	$1027, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$199:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$198:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$197:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$196:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$195:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$194:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	52768(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$193:
	movq	%rdi, %r11
	leaq	53792(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$192:
	movq	%rdi, %rbx
	leaq	54816(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$191:
	movq	%rdi, %r10
	leaq	55840(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$190:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$183
	cmpq	$256, %rbx
	jb  	.L__verify_internal$185
	cmpq	$256, %r10
	jb  	.L__verify_internal$187
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$169
	movl	$0, %esi
.L__verify_internal$189:
	jmp 	.L__verify_internal$169
.L__verify_internal$187:
	movl	$0, %esi
.L__verify_internal$188:
	jmp 	.L__verify_internal$169
.L__verify_internal$185:
	movl	$0, %esi
.L__verify_internal$186:
	jmp 	.L__verify_internal$169
.L__verify_internal$183:
	movl	$0, %esi
.L__verify_internal$184:
	jmp 	.L__verify_internal$169
.L__verify_internal$170:
	movq	%r11, 63088(%rsp)
	movq	%rbx, 63080(%rsp)
	movq	%r10, 63072(%rsp)
	movq	%rdi, 63064(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$182:
	movq	63088(%rsp), %rdi
	movq	63080(%rsp), %rbx
	movq	63072(%rsp), %r10
	movq	63064(%rsp), %r12
	leaq	52768(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$181:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	53792(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$180:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	54816(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$179:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	55840(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$178:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$171
	cmpq	$256, %rbx
	jb  	.L__verify_internal$173
	cmpq	$256, %r10
	jb  	.L__verify_internal$175
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$169
	movl	$0, %esi
.L__verify_internal$177:
	jmp 	.L__verify_internal$169
.L__verify_internal$175:
	movl	$0, %esi
.L__verify_internal$176:
	jmp 	.L__verify_internal$169
.L__verify_internal$173:
	movl	$0, %esi
.L__verify_internal$174:
	jmp 	.L__verify_internal$169
.L__verify_internal$171:
	movl	$0, %esi
.L__verify_internal$172:
.L__verify_internal$169:
	cmpl	$1, %esi
	jne 	.L__verify_internal$170
	movw	$1028, 63056(%rsp)
	movw	$1280, 63058(%rsp)
	movw	$1281, 63060(%rsp)
	movw	$1282, 63062(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$168:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$167:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$166:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$165:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$164:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$163:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	56864(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$162:
	movq	%rdi, %r11
	leaq	57888(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$161:
	movq	%rdi, %rbx
	leaq	58912(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$160:
	movq	%rdi, %r10
	leaq	59936(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$159:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$152
	cmpq	$256, %rbx
	jb  	.L__verify_internal$154
	cmpq	$256, %r10
	jb  	.L__verify_internal$156
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$138
	movl	$0, %esi
.L__verify_internal$158:
	jmp 	.L__verify_internal$138
.L__verify_internal$156:
	movl	$0, %esi
.L__verify_internal$157:
	jmp 	.L__verify_internal$138
.L__verify_internal$154:
	movl	$0, %esi
.L__verify_internal$155:
	jmp 	.L__verify_internal$138
.L__verify_internal$152:
	movl	$0, %esi
.L__verify_internal$153:
	jmp 	.L__verify_internal$138
.L__verify_internal$139:
	movq	%r11, 63064(%rsp)
	movq	%rbx, 63072(%rsp)
	movq	%r10, 63080(%rsp)
	movq	%rdi, 63088(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$151:
	movq	63064(%rsp), %rdi
	movq	63072(%rsp), %rbx
	movq	63080(%rsp), %r10
	movq	63088(%rsp), %r12
	leaq	56864(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$150:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	57888(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$149:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	58912(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$148:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	59936(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$147:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__verify_internal$140
	cmpq	$256, %rbx
	jb  	.L__verify_internal$142
	cmpq	$256, %r10
	jb  	.L__verify_internal$144
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$138
	movl	$0, %esi
.L__verify_internal$146:
	jmp 	.L__verify_internal$138
.L__verify_internal$144:
	movl	$0, %esi
.L__verify_internal$145:
	jmp 	.L__verify_internal$138
.L__verify_internal$142:
	movl	$0, %esi
.L__verify_internal$143:
	jmp 	.L__verify_internal$138
.L__verify_internal$140:
	movl	$0, %esi
.L__verify_internal$141:
.L__verify_internal$138:
	cmpl	$1, %esi
	jne 	.L__verify_internal$139
	movw	$1283, 63056(%rsp)
	movw	$1284, 63058(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1408(%rsp), %rax
	leaq	63056(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$137:
	leaq	40(%rsp), %rsp
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$136:
	leaq	1408(%rsp), %rax
	leaq	4968(%rsp), %rcx
	leaq	4104(%rsp), %rdx
	leaq	3240(%rsp), %rsi
	leaq	2376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$135:
	leaq	1408(%rsp), %rax
	leaq	5136(%rsp), %rcx
	leaq	4272(%rsp), %rdx
	leaq	3408(%rsp), %rsi
	leaq	2544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$134:
	leaq	1408(%rsp), %rax
	leaq	5304(%rsp), %rcx
	leaq	4440(%rsp), %rdx
	leaq	3576(%rsp), %rsi
	leaq	2712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$133:
	leaq	1408(%rsp), %rax
	leaq	5472(%rsp), %rcx
	leaq	4608(%rsp), %rdx
	leaq	3744(%rsp), %rsi
	leaq	2880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$132:
	movq	$0, %rax
	movq	%rax, 5640(%rsp)
	movq	%rax, 4776(%rsp)
	movq	%rax, 3912(%rsp)
	movq	%rax, 3048(%rsp)
	leaq	60960(%rsp), %rax
	leaq	4800(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$131:
	movq	%rdi, %r10
	leaq	61984(%rsp), %rax
	leaq	3936(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$130:
	movq	%rdi, %r11
	leaq	5664(%rsp), %rax
	leaq	3072(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$129:
	movq	%rdi, %rbx
	leaq	6688(%rsp), %rax
	leaq	2208(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$128:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$121
	cmpq	$256, %r11
	jb  	.L__verify_internal$123
	cmpq	$256, %rbx
	jb  	.L__verify_internal$125
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$107
	movl	$0, %esi
.L__verify_internal$127:
	jmp 	.L__verify_internal$107
.L__verify_internal$125:
	movl	$0, %esi
.L__verify_internal$126:
	jmp 	.L__verify_internal$107
.L__verify_internal$123:
	movl	$0, %esi
.L__verify_internal$124:
	jmp 	.L__verify_internal$107
.L__verify_internal$121:
	movl	$0, %esi
.L__verify_internal$122:
	jmp 	.L__verify_internal$107
.L__verify_internal$108:
	movq	%r10, 63056(%rsp)
	movq	%r11, 63088(%rsp)
	movq	%rbx, 63080(%rsp)
	movq	%rdi, 63072(%rsp)
	leaq	1408(%rsp), %rax
	leaq	4800(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	leaq	3072(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$120:
	movq	63056(%rsp), %rdi
	movq	63088(%rsp), %r11
	movq	63080(%rsp), %rbx
	movq	63072(%rsp), %r12
	leaq	60960(%rsp), %rcx
	leaq	4800(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$119:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	61984(%rsp), %rcx
	leaq	3936(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$118:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	5664(%rsp), %rcx
	leaq	3072(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$117:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	6688(%rsp), %rcx
	leaq	2208(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$116:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__verify_internal$109
	cmpq	$256, %r11
	jb  	.L__verify_internal$111
	cmpq	$256, %rbx
	jb  	.L__verify_internal$113
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$107
	movl	$0, %esi
.L__verify_internal$115:
	jmp 	.L__verify_internal$107
.L__verify_internal$113:
	movl	$0, %esi
.L__verify_internal$114:
	jmp 	.L__verify_internal$107
.L__verify_internal$111:
	movl	$0, %esi
.L__verify_internal$112:
	jmp 	.L__verify_internal$107
.L__verify_internal$109:
	movl	$0, %esi
.L__verify_internal$110:
.L__verify_internal$107:
	cmpl	$1, %esi
	jne 	.L__verify_internal$108
	leaq	8736(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__verify_internal$106:
	leaq	32288(%rsp), %rax
	leaq	8736(%rsp), %rcx
	leaq	20000(%rsp), %rsi
	movq	%rax, %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$104
.L__verify_internal$105:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$104:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$105
	leaq	21024(%rsp), %rsi
	leaq	5120(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$102
.L__verify_internal$103:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$102:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$103
	leaq	22048(%rsp), %rsi
	leaq	10240(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$100
.L__verify_internal$101:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$100:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$101
	leaq	23072(%rsp), %rsi
	leaq	15360(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$98
.L__verify_internal$99:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$98:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$99
	leaq	24096(%rsp), %rsi
	leaq	20480(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$96
.L__verify_internal$97:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$96:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$97
	leaq	25120(%rsp), %rsi
	leaq	25600(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$94
.L__verify_internal$95:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%r8), %ymm4
	vmovdqu	4096(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$94:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$95
	movq	63040(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	6688(%rsp), %rax
	movq	%r8, %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__verify_internal$92
.L__verify_internal$93:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__verify_internal$92:
	cmpq	$1024, %rsi
	jb  	.L__verify_internal$93
	movq	%rax, 63072(%rsp)
	leaq	416(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__verify_internal$91:
	leaq	416(%rsp), %rdx
	leaq	256(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__verify_internal$90:
	movq	63072(%rsp), %rcx
	movq	256(%rsp), %rdx
	movq	$8, %rdi
	lfence
	movq	$0, %r11
	movq	$207, %rsi
	jmp 	.L__verify_internal$83
.L__verify_internal$84:
	movq	$-1, %rax
	cmovnb	%rax, %r11
	jmp 	.L__verify_internal$85
.L__verify_internal$86:
	movq	$-1, %rax
	cmovbe	%rax, %r11
.L__verify_internal$85:
	cmpq	$136, %rdi
	jnb 	.L__verify_internal$87
	movq	$-1, %rax
	cmovnb	%rax, %r11
	jmp 	.L__verify_internal$88
.L__verify_internal$87:
	movq	%rsi, 63072(%rsp)
	movq	%rdx, 63080(%rsp)
	movq	%rcx, 63088(%rsp)
	leaq	416(%rsp), %rdx
	leaq	256(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__verify_internal$89:
	movq	63072(%rsp), %rsi
	movq	63080(%rsp), %rdx
	movq	63088(%rsp), %rcx
	movq	$0, %rdi
	lfence
	movq	$0, %r11
.L__verify_internal$88:
	movzbq	256(%rsp,%rdi), %rax
// declassify_val u64 %rax
	orq 	%r11, %rax
	incq	%rdi
	cmpq	%rsi, %rax
	jnbe	.L__verify_internal$86
	movq	$-1, %r8
	cmovnbe	%r8, %r11
	movl	(%rcx,%rax,4), %r8d
	movl	%r8d, (%rcx,%rsi,4)
	movl	%edx, %r8d
	andl	$1, %r8d
	shll	$1, %r8d
	movl	$1, %r9d
	subl	%r8d, %r9d
	movl	%r9d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__verify_internal$83:
	cmpq	$256, %rsi
	jb  	.L__verify_internal$84
	leaq	6688(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$82:
	movq	63048(%rsp), %rdi
	lfence
	movq	$0, %rax
	leaq	32(%rdi), %rax
	leaq	6688(%rsp), %rcx
	movq	%rcx, %mm0
	leaq	7712(%rsp), %rcx
	movq	%rax, %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$81:
	leaq	7712(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$79
.L__verify_internal$80:
	vmovdqu	(%rcx,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$79:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$80
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$78:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$77:
	leaq	26144(%rsp), %rcx
	leaq	20000(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$76:
	leaq	26144(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$75:
	leaq	26144(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$74:
	leaq	26144(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$73:
	leaq	26144(%rsp), %r9
	leaq	13856(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$72:
	leaq	2072(%rsp), %rsp
	leaq	7712(%rsp), %rcx
	leaq	320(%rax), %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$71:
	leaq	7712(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$69
.L__verify_internal$70:
	vmovdqu	(%rcx,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$69:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$70
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$68:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$67:
	leaq	27168(%rsp), %rcx
	leaq	21024(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$66:
	leaq	27168(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$65:
	leaq	27168(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$64:
	leaq	27168(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$63:
	leaq	27168(%rsp), %r9
	leaq	14880(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$62:
	leaq	2072(%rsp), %rsp
	leaq	7712(%rsp), %rcx
	leaq	640(%rax), %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$61:
	leaq	7712(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$59
.L__verify_internal$60:
	vmovdqu	(%rcx,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$59:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$60
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$58:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$57:
	leaq	28192(%rsp), %rcx
	leaq	22048(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$56:
	leaq	28192(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$55:
	leaq	28192(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$54:
	leaq	28192(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$53:
	leaq	28192(%rsp), %r9
	leaq	15904(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$52:
	leaq	2072(%rsp), %rsp
	leaq	7712(%rsp), %rcx
	leaq	960(%rax), %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$51:
	leaq	7712(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$49
.L__verify_internal$50:
	vmovdqu	(%rcx,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$49:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$50
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$48:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$47:
	leaq	29216(%rsp), %rcx
	leaq	23072(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$46:
	leaq	29216(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$45:
	leaq	29216(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$44:
	leaq	29216(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$43:
	leaq	29216(%rsp), %r9
	leaq	16928(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$42:
	leaq	2072(%rsp), %rsp
	leaq	7712(%rsp), %rcx
	leaq	1280(%rax), %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$41:
	leaq	7712(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$39
.L__verify_internal$40:
	vmovdqu	(%rcx,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$39:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$40
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$38:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$37:
	leaq	30240(%rsp), %rcx
	leaq	24096(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$36:
	leaq	30240(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$35:
	leaq	30240(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$34:
	leaq	30240(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$33:
	leaq	30240(%rsp), %r9
	leaq	17952(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$32:
	leaq	2072(%rsp), %rsp
	leaq	7712(%rsp), %rcx
	leaq	1600(%rax), %rdx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$31:
	leaq	7712(%rsp), %rax
	movq	$0, %rdx
	jmp 	.L__verify_internal$29
.L__verify_internal$30:
	vmovdqu	(%rax,%rdx), %ymm10
	vpslld	$13, %ymm10, %ymm10
	vmovdqu	%ymm10, (%rax,%rdx)
	addq	$32, %rdx
.L__verify_internal$29:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$30
	leaq	7712(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$28:
	movq	%mm0, %rcx
	leaq	5664(%rsp), %r10
	leaq	7712(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$27:
	leaq	31264(%rsp), %rcx
	leaq	25120(%rsp), %rdx
	leaq	5664(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$26:
	leaq	31264(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$25:
	leaq	31264(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$24:
	leaq	31264(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$23:
	leaq	31264(%rsp), %r9
	leaq	18976(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$22:
	leaq	2072(%rsp), %rsp
	leaq	26144(%rsp), %rax
	leaq	640(%rsp), %rdx
	movq	%rax, %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$20
.L__verify_internal$21:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$20:
	cmpq	$128, %r11
	jb  	.L__verify_internal$21
	leaq	768(%rsp), %rdx
	leaq	1024(%rax), %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$18
.L__verify_internal$19:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$18:
	cmpq	$128, %r11
	jb  	.L__verify_internal$19
	leaq	896(%rsp), %rdx
	leaq	2048(%rax), %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$16
.L__verify_internal$17:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$16:
	cmpq	$128, %r11
	jb  	.L__verify_internal$17
	leaq	1024(%rsp), %rdx
	leaq	3072(%rax), %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$14
.L__verify_internal$15:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$14:
	cmpq	$128, %r11
	jb  	.L__verify_internal$15
	leaq	1152(%rsp), %rdx
	leaq	4096(%rax), %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$12
.L__verify_internal$13:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$12:
	cmpq	$128, %r11
	jb  	.L__verify_internal$13
	leaq	1280(%rsp), %rdx
	leaq	5120(%rax), %rax
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__verify_internal$10
.L__verify_internal$11:
	vmovdqu	(%rax,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__verify_internal$10:
	cmpq	$128, %r11
	jb  	.L__verify_internal$11
	movq	63048(%rsp), %rcx
	lfence
	movq	$0, %rax
	leaq	128(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__verify_internal$9:
	leaq	248(%rsp), %rsp
	movq	63008(%rsp), %rcx
	movq	63016(%rsp), %rdx
	movq	63024(%rsp), %rdi
	movq	63032(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	192(%rsp), %rax
	leaq	128(%rsp), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__verify_internal$8:
	leaq	344(%rsp), %rsp
	leaq	64(%rsp), %rax
	leaq	192(%rsp), %rcx
	leaq	640(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__verify_internal$7:
	leaq	248(%rsp), %rsp
	movq	63040(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	64(%rsp), %rcx
	movq	$0, %rdx
	vmovdqu	(%rcx,%rdx), %xmm0
	vmovdqu	(%r8,%rdx), %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm0
	addq	$16, %rdx
	jmp 	.L__verify_internal$5
.L__verify_internal$6:
	vmovdqu	(%rcx,%rdx), %xmm1
	vmovdqu	(%r8,%rdx), %xmm2
	vpcmpeqb	%xmm2, %xmm1, %xmm1
	vpand	%xmm1, %xmm0, %xmm0
	addq	$16, %rdx
.L__verify_internal$5:
	cmpq	$48, %rdx
	jb  	.L__verify_internal$6
	vpmovmskb	%xmm0, %eax
// declassify_val u64 %rax
	lfence
	movq	$0, %rcx
	cmpq	$65535, %rax
	je  	.L__verify_internal$3
	movq	$-1, %r11
	jmp 	.L__verify_internal$2
.L__verify_internal$3:
	movq	$0, %r11
.L__verify_internal$4:
.L__verify_internal$2:
	ret
.L__sign_internal$1:
	movq	%rdi, 117040(%rsp)
	movq	%r9, 117048(%rsp)
	movq	%rsi, 117056(%rsp)
	movq	%rax, 117064(%rsp)
	movq	%rdx, 117072(%rsp)
	movq	%rcx, 117080(%rsp)
	movq	%r8, 117088(%rsp)
// declassify_mem 32 [RSI]
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 117096(%rsp)
	movw	$1, 117098(%rsp)
	movw	$2, 117100(%rsp)
	movw	$3, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$449:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$448:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$447:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$446:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$445:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$444:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	86304(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$443:
	movq	%rdi, %r11
	leaq	87328(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$442:
	movq	%rdi, %rbx
	leaq	88352(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$441:
	movq	%rdi, %r10
	leaq	89376(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$440:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__sign_internal$433
	cmpq	$256, %rbx
	jb  	.L__sign_internal$435
	cmpq	$256, %r10
	jb  	.L__sign_internal$437
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$419
	movl	$0, %esi
.L__sign_internal$439:
	jmp 	.L__sign_internal$419
.L__sign_internal$437:
	movl	$0, %esi
.L__sign_internal$438:
	jmp 	.L__sign_internal$419
.L__sign_internal$435:
	movl	$0, %esi
.L__sign_internal$436:
	jmp 	.L__sign_internal$419
.L__sign_internal$433:
	movl	$0, %esi
.L__sign_internal$434:
	jmp 	.L__sign_internal$419
.L__sign_internal$420:
	movq	%r11, 117104(%rsp)
	movq	%rbx, 117112(%rsp)
	movq	%r10, 117120(%rsp)
	movq	%rdi, 117128(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$432:
	movq	117104(%rsp), %rdi
	movq	117112(%rsp), %rbx
	movq	117120(%rsp), %r10
	movq	117128(%rsp), %r12
	leaq	86304(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$431:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	87328(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$430:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	88352(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$429:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	89376(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$428:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__sign_internal$421
	cmpq	$256, %rbx
	jb  	.L__sign_internal$423
	cmpq	$256, %r10
	jb  	.L__sign_internal$425
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$419
	movl	$0, %esi
.L__sign_internal$427:
	jmp 	.L__sign_internal$419
.L__sign_internal$425:
	movl	$0, %esi
.L__sign_internal$426:
	jmp 	.L__sign_internal$419
.L__sign_internal$423:
	movl	$0, %esi
.L__sign_internal$424:
	jmp 	.L__sign_internal$419
.L__sign_internal$421:
	movl	$0, %esi
.L__sign_internal$422:
.L__sign_internal$419:
	cmpl	$1, %esi
	jne 	.L__sign_internal$420
	movw	$4, 117096(%rsp)
	movw	$256, 117098(%rsp)
	movw	$257, 117100(%rsp)
	movw	$258, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$418:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$417:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$416:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$415:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$414:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$413:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	90400(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$412:
	movq	%rdi, %rbx
	leaq	91424(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$411:
	movq	%rdi, %r11
	leaq	92448(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$410:
	movq	%rdi, %r10
	leaq	93472(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$409:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$402
	cmpq	$256, %r11
	jb  	.L__sign_internal$404
	cmpq	$256, %r10
	jb  	.L__sign_internal$406
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$388
	movl	$0, %esi
.L__sign_internal$408:
	jmp 	.L__sign_internal$388
.L__sign_internal$406:
	movl	$0, %esi
.L__sign_internal$407:
	jmp 	.L__sign_internal$388
.L__sign_internal$404:
	movl	$0, %esi
.L__sign_internal$405:
	jmp 	.L__sign_internal$388
.L__sign_internal$402:
	movl	$0, %esi
.L__sign_internal$403:
	jmp 	.L__sign_internal$388
.L__sign_internal$389:
	movq	%rbx, 117128(%rsp)
	movq	%r11, 117120(%rsp)
	movq	%r10, 117112(%rsp)
	movq	%rdi, 117104(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$401:
	movq	117128(%rsp), %rdi
	movq	117120(%rsp), %r11
	movq	117112(%rsp), %r10
	movq	117104(%rsp), %r12
	leaq	90400(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$400:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	91424(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$399:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	92448(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$398:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	93472(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$397:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$390
	cmpq	$256, %r11
	jb  	.L__sign_internal$392
	cmpq	$256, %r10
	jb  	.L__sign_internal$394
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$388
	movl	$0, %esi
.L__sign_internal$396:
	jmp 	.L__sign_internal$388
.L__sign_internal$394:
	movl	$0, %esi
.L__sign_internal$395:
	jmp 	.L__sign_internal$388
.L__sign_internal$392:
	movl	$0, %esi
.L__sign_internal$393:
	jmp 	.L__sign_internal$388
.L__sign_internal$390:
	movl	$0, %esi
.L__sign_internal$391:
.L__sign_internal$388:
	cmpl	$1, %esi
	jne 	.L__sign_internal$389
	movw	$259, 117096(%rsp)
	movw	$260, 117098(%rsp)
	movw	$512, 117100(%rsp)
	movw	$513, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$387:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$386:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$385:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$384:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$383:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$382:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	94496(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$381:
	movq	%rdi, %r10
	leaq	95520(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$380:
	movq	%rdi, %rbx
	leaq	96544(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$379:
	movq	%rdi, %r11
	leaq	97568(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$378:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$371
	cmpq	$256, %rbx
	jb  	.L__sign_internal$373
	cmpq	$256, %r11
	jb  	.L__sign_internal$375
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$357
	movl	$0, %esi
.L__sign_internal$377:
	jmp 	.L__sign_internal$357
.L__sign_internal$375:
	movl	$0, %esi
.L__sign_internal$376:
	jmp 	.L__sign_internal$357
.L__sign_internal$373:
	movl	$0, %esi
.L__sign_internal$374:
	jmp 	.L__sign_internal$357
.L__sign_internal$371:
	movl	$0, %esi
.L__sign_internal$372:
	jmp 	.L__sign_internal$357
.L__sign_internal$358:
	movq	%r10, 117104(%rsp)
	movq	%rbx, 117112(%rsp)
	movq	%r11, 117120(%rsp)
	movq	%rdi, 117128(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$370:
	movq	117104(%rsp), %rdi
	movq	117112(%rsp), %rbx
	movq	117120(%rsp), %r11
	movq	117128(%rsp), %r12
	leaq	94496(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$369:
	movq	%rdi, %r10
	movq	%rbx, %rdi
	leaq	95520(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$368:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	96544(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$367:
	movq	%rdi, %r11
	movq	%r12, %rdi
	leaq	97568(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$366:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$359
	cmpq	$256, %rbx
	jb  	.L__sign_internal$361
	cmpq	$256, %r11
	jb  	.L__sign_internal$363
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$357
	movl	$0, %esi
.L__sign_internal$365:
	jmp 	.L__sign_internal$357
.L__sign_internal$363:
	movl	$0, %esi
.L__sign_internal$364:
	jmp 	.L__sign_internal$357
.L__sign_internal$361:
	movl	$0, %esi
.L__sign_internal$362:
	jmp 	.L__sign_internal$357
.L__sign_internal$359:
	movl	$0, %esi
.L__sign_internal$360:
.L__sign_internal$357:
	cmpl	$1, %esi
	jne 	.L__sign_internal$358
	movw	$514, 117096(%rsp)
	movw	$515, 117098(%rsp)
	movw	$516, 117100(%rsp)
	movw	$768, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$356:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$355:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$354:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$353:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$352:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$351:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	98592(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$350:
	movq	%rdi, %r10
	leaq	99616(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$349:
	movq	%rdi, %r11
	leaq	100640(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$348:
	movq	%rdi, %rbx
	leaq	101664(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$347:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$340
	cmpq	$256, %r11
	jb  	.L__sign_internal$342
	cmpq	$256, %rbx
	jb  	.L__sign_internal$344
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$326
	movl	$0, %esi
.L__sign_internal$346:
	jmp 	.L__sign_internal$326
.L__sign_internal$344:
	movl	$0, %esi
.L__sign_internal$345:
	jmp 	.L__sign_internal$326
.L__sign_internal$342:
	movl	$0, %esi
.L__sign_internal$343:
	jmp 	.L__sign_internal$326
.L__sign_internal$340:
	movl	$0, %esi
.L__sign_internal$341:
	jmp 	.L__sign_internal$326
.L__sign_internal$327:
	movq	%r10, 117128(%rsp)
	movq	%r11, 117120(%rsp)
	movq	%rbx, 117112(%rsp)
	movq	%rdi, 117104(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$339:
	movq	117128(%rsp), %rdi
	movq	117120(%rsp), %r11
	movq	117112(%rsp), %rbx
	movq	117104(%rsp), %r12
	leaq	98592(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$338:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	99616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$337:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	100640(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$336:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	101664(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$335:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$328
	cmpq	$256, %r11
	jb  	.L__sign_internal$330
	cmpq	$256, %rbx
	jb  	.L__sign_internal$332
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$326
	movl	$0, %esi
.L__sign_internal$334:
	jmp 	.L__sign_internal$326
.L__sign_internal$332:
	movl	$0, %esi
.L__sign_internal$333:
	jmp 	.L__sign_internal$326
.L__sign_internal$330:
	movl	$0, %esi
.L__sign_internal$331:
	jmp 	.L__sign_internal$326
.L__sign_internal$328:
	movl	$0, %esi
.L__sign_internal$329:
.L__sign_internal$326:
	cmpl	$1, %esi
	jne 	.L__sign_internal$327
	movw	$769, 117096(%rsp)
	movw	$770, 117098(%rsp)
	movw	$771, 117100(%rsp)
	movw	$772, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$325:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$324:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$323:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$322:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$321:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$320:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	102688(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$319:
	movq	%rdi, %rbx
	leaq	103712(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$318:
	movq	%rdi, %r11
	leaq	104736(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$317:
	movq	%rdi, %r10
	leaq	105760(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$316:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$309
	cmpq	$256, %r11
	jb  	.L__sign_internal$311
	cmpq	$256, %r10
	jb  	.L__sign_internal$313
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$295
	movl	$0, %esi
.L__sign_internal$315:
	jmp 	.L__sign_internal$295
.L__sign_internal$313:
	movl	$0, %esi
.L__sign_internal$314:
	jmp 	.L__sign_internal$295
.L__sign_internal$311:
	movl	$0, %esi
.L__sign_internal$312:
	jmp 	.L__sign_internal$295
.L__sign_internal$309:
	movl	$0, %esi
.L__sign_internal$310:
	jmp 	.L__sign_internal$295
.L__sign_internal$296:
	movq	%rbx, 117104(%rsp)
	movq	%r11, 117112(%rsp)
	movq	%r10, 117120(%rsp)
	movq	%rdi, 117128(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$308:
	movq	117104(%rsp), %rdi
	movq	117112(%rsp), %r11
	movq	117120(%rsp), %r10
	movq	117128(%rsp), %r12
	leaq	102688(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$307:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	103712(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$306:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	104736(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$305:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	105760(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$304:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$297
	cmpq	$256, %r11
	jb  	.L__sign_internal$299
	cmpq	$256, %r10
	jb  	.L__sign_internal$301
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$295
	movl	$0, %esi
.L__sign_internal$303:
	jmp 	.L__sign_internal$295
.L__sign_internal$301:
	movl	$0, %esi
.L__sign_internal$302:
	jmp 	.L__sign_internal$295
.L__sign_internal$299:
	movl	$0, %esi
.L__sign_internal$300:
	jmp 	.L__sign_internal$295
.L__sign_internal$297:
	movl	$0, %esi
.L__sign_internal$298:
.L__sign_internal$295:
	cmpl	$1, %esi
	jne 	.L__sign_internal$296
	movw	$1024, 117096(%rsp)
	movw	$1025, 117098(%rsp)
	movw	$1026, 117100(%rsp)
	movw	$1027, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$294:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$293:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$292:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$291:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$290:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$289:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	106784(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$288:
	movq	%rdi, %r10
	leaq	107808(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$287:
	movq	%rdi, %rbx
	leaq	108832(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$286:
	movq	%rdi, %r11
	leaq	109856(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$285:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$278
	cmpq	$256, %rbx
	jb  	.L__sign_internal$280
	cmpq	$256, %r11
	jb  	.L__sign_internal$282
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$264
	movl	$0, %esi
.L__sign_internal$284:
	jmp 	.L__sign_internal$264
.L__sign_internal$282:
	movl	$0, %esi
.L__sign_internal$283:
	jmp 	.L__sign_internal$264
.L__sign_internal$280:
	movl	$0, %esi
.L__sign_internal$281:
	jmp 	.L__sign_internal$264
.L__sign_internal$278:
	movl	$0, %esi
.L__sign_internal$279:
	jmp 	.L__sign_internal$264
.L__sign_internal$265:
	movq	%r10, 117128(%rsp)
	movq	%rbx, 117120(%rsp)
	movq	%r11, 117112(%rsp)
	movq	%rdi, 117104(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$277:
	movq	117128(%rsp), %rdi
	movq	117120(%rsp), %rbx
	movq	117112(%rsp), %r11
	movq	117104(%rsp), %r12
	leaq	106784(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$276:
	movq	%rdi, %r10
	movq	%rbx, %rdi
	leaq	107808(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$275:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	108832(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$274:
	movq	%rdi, %r11
	movq	%r12, %rdi
	leaq	109856(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$273:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$266
	cmpq	$256, %rbx
	jb  	.L__sign_internal$268
	cmpq	$256, %r11
	jb  	.L__sign_internal$270
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$264
	movl	$0, %esi
.L__sign_internal$272:
	jmp 	.L__sign_internal$264
.L__sign_internal$270:
	movl	$0, %esi
.L__sign_internal$271:
	jmp 	.L__sign_internal$264
.L__sign_internal$268:
	movl	$0, %esi
.L__sign_internal$269:
	jmp 	.L__sign_internal$264
.L__sign_internal$266:
	movl	$0, %esi
.L__sign_internal$267:
.L__sign_internal$264:
	cmpl	$1, %esi
	jne 	.L__sign_internal$265
	movw	$1028, 117096(%rsp)
	movw	$1280, 117098(%rsp)
	movw	$1281, 117100(%rsp)
	movw	$1282, 117102(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$263:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$262:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$261:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$260:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$259:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$258:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	110880(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$257:
	movq	%rdi, %r10
	leaq	111904(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$256:
	movq	%rdi, %r11
	leaq	112928(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$255:
	movq	%rdi, %rbx
	leaq	113952(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$254:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$247
	cmpq	$256, %r11
	jb  	.L__sign_internal$249
	cmpq	$256, %rbx
	jb  	.L__sign_internal$251
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$233
	movl	$0, %esi
.L__sign_internal$253:
	jmp 	.L__sign_internal$233
.L__sign_internal$251:
	movl	$0, %esi
.L__sign_internal$252:
	jmp 	.L__sign_internal$233
.L__sign_internal$249:
	movl	$0, %esi
.L__sign_internal$250:
	jmp 	.L__sign_internal$233
.L__sign_internal$247:
	movl	$0, %esi
.L__sign_internal$248:
	jmp 	.L__sign_internal$233
.L__sign_internal$234:
	movq	%r10, 117104(%rsp)
	movq	%r11, 117112(%rsp)
	movq	%rbx, 117120(%rsp)
	movq	%rdi, 117128(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$246:
	movq	117104(%rsp), %rdi
	movq	117112(%rsp), %r11
	movq	117120(%rsp), %rbx
	movq	117128(%rsp), %r12
	leaq	110880(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$245:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	111904(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$244:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	112928(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$243:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	113952(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$242:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$235
	cmpq	$256, %r11
	jb  	.L__sign_internal$237
	cmpq	$256, %rbx
	jb  	.L__sign_internal$239
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$233
	movl	$0, %esi
.L__sign_internal$241:
	jmp 	.L__sign_internal$233
.L__sign_internal$239:
	movl	$0, %esi
.L__sign_internal$240:
	jmp 	.L__sign_internal$233
.L__sign_internal$237:
	movl	$0, %esi
.L__sign_internal$238:
	jmp 	.L__sign_internal$233
.L__sign_internal$235:
	movl	$0, %esi
.L__sign_internal$236:
.L__sign_internal$233:
	cmpl	$1, %esi
	jne 	.L__sign_internal$234
	movw	$1283, 117096(%rsp)
	movw	$1284, 117098(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4224(%rsp), %rax
	leaq	117096(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$232:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$231:
	leaq	4224(%rsp), %rax
	leaq	7784(%rsp), %rcx
	leaq	6920(%rsp), %rdx
	leaq	6056(%rsp), %rsi
	leaq	5192(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$230:
	leaq	4224(%rsp), %rax
	leaq	7952(%rsp), %rcx
	leaq	7088(%rsp), %rdx
	leaq	6224(%rsp), %rsi
	leaq	5360(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$229:
	leaq	4224(%rsp), %rax
	leaq	8120(%rsp), %rcx
	leaq	7256(%rsp), %rdx
	leaq	6392(%rsp), %rsi
	leaq	5528(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$228:
	leaq	4224(%rsp), %rax
	leaq	8288(%rsp), %rcx
	leaq	7424(%rsp), %rdx
	leaq	6560(%rsp), %rsi
	leaq	5696(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$227:
	movq	$0, %rax
	movq	%rax, 8456(%rsp)
	movq	%rax, 7592(%rsp)
	movq	%rax, 6728(%rsp)
	movq	%rax, 5864(%rsp)
	leaq	114976(%rsp), %rax
	leaq	7616(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$226:
	movq	%rdi, %r10
	leaq	116000(%rsp), %rax
	leaq	6752(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$225:
	movq	%rdi, %rbx
	leaq	8480(%rsp), %rax
	leaq	5888(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$224:
	movq	%rdi, %r11
	leaq	9504(%rsp), %rax
	leaq	5024(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$223:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$216
	cmpq	$256, %rbx
	jb  	.L__sign_internal$218
	cmpq	$256, %r11
	jb  	.L__sign_internal$220
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$202
	movl	$0, %esi
.L__sign_internal$222:
	jmp 	.L__sign_internal$202
.L__sign_internal$220:
	movl	$0, %esi
.L__sign_internal$221:
	jmp 	.L__sign_internal$202
.L__sign_internal$218:
	movl	$0, %esi
.L__sign_internal$219:
	jmp 	.L__sign_internal$202
.L__sign_internal$216:
	movl	$0, %esi
.L__sign_internal$217:
	jmp 	.L__sign_internal$202
.L__sign_internal$203:
	movq	%r10, 117096(%rsp)
	movq	%rbx, 117128(%rsp)
	movq	%r11, 117120(%rsp)
	movq	%rdi, 117112(%rsp)
	leaq	4224(%rsp), %rax
	leaq	7616(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	leaq	5888(%rsp), %rsi
	leaq	5024(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$215:
	movq	117096(%rsp), %rdi
	movq	117128(%rsp), %rbx
	movq	117120(%rsp), %r11
	movq	117112(%rsp), %r12
	leaq	114976(%rsp), %rcx
	leaq	7616(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$214:
	movq	%rdi, %r10
	movq	%rbx, %rdi
	leaq	116000(%rsp), %rcx
	leaq	6752(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$213:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	8480(%rsp), %rcx
	leaq	5888(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$212:
	movq	%rdi, %r11
	movq	%r12, %rdi
	leaq	9504(%rsp), %rcx
	leaq	5024(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$211:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__sign_internal$204
	cmpq	$256, %rbx
	jb  	.L__sign_internal$206
	cmpq	$256, %r11
	jb  	.L__sign_internal$208
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$202
	movl	$0, %esi
.L__sign_internal$210:
	jmp 	.L__sign_internal$202
.L__sign_internal$208:
	movl	$0, %esi
.L__sign_internal$209:
	jmp 	.L__sign_internal$202
.L__sign_internal$206:
	movl	$0, %esi
.L__sign_internal$207:
	jmp 	.L__sign_internal$202
.L__sign_internal$204:
	movl	$0, %esi
.L__sign_internal$205:
.L__sign_internal$202:
	cmpl	$1, %esi
	jne 	.L__sign_internal$203
	movq	117056(%rsp), %rsi
	movq	117064(%rsp), %rcx
	movq	117072(%rsp), %rdx
	movq	117080(%rsp), %rdi
	movq	117088(%rsp), %r8
	lfence
	movq	$0, %r11
	orq 	%r11, %rsi
	movq	%rsi, 117088(%rsp)
	leaq	128(%rsp), %rax
	leaq	64(%rsi), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__sign_internal$201:
	leaq	344(%rsp), %rsp
	movq	117048(%rsp), %rdx
	movq	117088(%rsp), %rsi
	lfence
	movq	$0, %r11
	orq 	%r11, %rdx
	orq 	%r11, %rsi
	movq	%rsi, 117088(%rsp)
	leaq	32(%rsi), %rax
	leaq	128(%rsp), %rcx
	leaq	192(%rsp), %rdi
	leaq	-152(%rsp), %rsp
	call	.Lderive_seed_for_mask$1
.L__sign_internal$200:
	leaq	152(%rsp), %rsp
	movq	117088(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rsi
	leaq	10528(%rsp), %rcx
	leaq	128(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rcx, %rax
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$199:
	movq	%mm0, %rdx
	leaq	1024(%rcx), %rax
	leaq	128(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$198:
	movq	%mm0, %rdx
	leaq	2048(%rcx), %rax
	leaq	256(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$197:
	movq	%mm0, %rdx
	leaq	3072(%rcx), %rax
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$196:
	movq	%mm0, %rdx
	leaq	4096(%rcx), %rax
	leaq	512(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$195:
	leaq	31008(%rsp), %rcx
	leaq	768(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rcx, %rax
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$194:
	movq	%mm0, %rdx
	leaq	1024(%rcx), %rax
	leaq	128(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$193:
	movq	%mm0, %rdx
	leaq	2048(%rcx), %rax
	leaq	256(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$192:
	movq	%mm0, %rdx
	leaq	3072(%rcx), %rax
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$191:
	movq	%mm0, %rdx
	leaq	4096(%rcx), %rax
	leaq	512(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$190:
	movq	%mm0, %rdx
	leaq	5120(%rcx), %rax
	leaq	640(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta4$1
.L__sign_internal$189:
	leaq	37152(%rsp), %rax
	leaq	1536(%rsi), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$186
.L__sign_internal$187:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$188:
	vmovdqu	%ymm10, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$186:
	cmpq	$403, %r10
	jb  	.L__sign_internal$187
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$185:
	vmovdqu	%ymm10, (%rcx,%r8)
	leaq	1024(%rax), %rcx
	leaq	416(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$182
.L__sign_internal$183:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$184:
	vmovdqu	%ymm10, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$182:
	cmpq	$403, %r10
	jb  	.L__sign_internal$183
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$181:
	vmovdqu	%ymm10, (%rcx,%r8)
	leaq	2048(%rax), %rcx
	leaq	832(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$178
.L__sign_internal$179:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$180:
	vmovdqu	%ymm10, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$178:
	cmpq	$403, %r10
	jb  	.L__sign_internal$179
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$177:
	vmovdqu	%ymm10, (%rcx,%r8)
	leaq	3072(%rax), %rcx
	leaq	1248(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$174
.L__sign_internal$175:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$176:
	vmovdqu	%ymm10, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$174:
	cmpq	$403, %r10
	jb  	.L__sign_internal$175
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$173:
	vmovdqu	%ymm10, (%rcx,%r8)
	leaq	4096(%rax), %rcx
	leaq	1664(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$170
.L__sign_internal$171:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$172:
	vmovdqu	%ymm10, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$170:
	cmpq	$403, %r10
	jb  	.L__sign_internal$171
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$169:
	vmovdqu	%ymm10, (%rcx,%r8)
	leaq	5120(%rax), %rax
	leaq	2080(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$166
.L__sign_internal$167:
	vmovdqu	(%rsi,%r10), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$168:
	vmovdqu	%ymm10, (%rax,%r8)
	addq	$32, %r8
	addq	$13, %r10
.L__sign_internal$166:
	cmpq	$403, %r10
	jb  	.L__sign_internal$167
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$165:
	vmovdqu	%ymm10, (%rax,%r8)
// declassify_mem 6144 [RSP + 37152]
	leaq	15648(%rsp), %rcx
	leaq	10528(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	16672(%rsp), %rcx
	leaq	11552(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	17696(%rsp), %rcx
	leaq	12576(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	18720(%rsp), %rcx
	leaq	13600(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	19744(%rsp), %rcx
	leaq	14624(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	43296(%rsp), %rcx
	leaq	31008(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	74016(%rsp), %rcx
	leaq	37152(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	leaq	44320(%rsp), %rcx
	leaq	32032(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	76064(%rsp), %rcx
	leaq	38176(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	leaq	45344(%rsp), %rcx
	leaq	33056(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	78112(%rsp), %rcx
	leaq	39200(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	leaq	46368(%rsp), %rcx
	leaq	34080(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	80160(%rsp), %rcx
	leaq	40224(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	leaq	47392(%rsp), %rcx
	leaq	35104(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	82208(%rsp), %rcx
	leaq	41248(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	leaq	48416(%rsp), %rcx
	leaq	36128(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm1
	vmovdqu	32(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rax), %ymm1
	vmovdqu	96(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rax), %ymm1
	vmovdqu	288(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rax), %ymm1
	vmovdqu	352(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rax), %ymm1
	vmovdqu	416(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rax), %ymm1
	vmovdqu	480(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rax), %ymm1
	vmovdqu	544(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rax), %ymm1
	vmovdqu	608(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rax), %ymm1
	vmovdqu	672(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rax), %ymm1
	vmovdqu	736(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rax), %ymm1
	vmovdqu	800(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rax), %ymm1
	vmovdqu	864(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rax), %ymm1
	vmovdqu	928(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rax), %ymm1
	vmovdqu	992(%rax), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	84256(%rsp), %rcx
	leaq	42272(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm10, 1024(%rcx)
	vmovdqu	32(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm10, 1056(%rcx)
	vmovdqu	64(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm10, 1088(%rcx)
	vmovdqu	96(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm10, 1120(%rcx)
	vmovdqu	128(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm10, 1152(%rcx)
	vmovdqu	160(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 1184(%rcx)
	vmovdqu	192(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm10, 1216(%rcx)
	vmovdqu	224(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm10, 1248(%rcx)
	vmovdqu	256(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm10, 1280(%rcx)
	vmovdqu	288(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm10, 1312(%rcx)
	vmovdqu	320(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm10, 1344(%rcx)
	vmovdqu	352(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm10, 1376(%rcx)
	vmovdqu	384(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm10, 1408(%rcx)
	vmovdqu	416(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm10, 1440(%rcx)
	vmovdqu	448(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm10, 1472(%rcx)
	vmovdqu	480(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm10, 1504(%rcx)
	vmovdqu	512(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 512(%rcx)
	vmovdqu	%ymm10, 1536(%rcx)
	vmovdqu	544(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 544(%rcx)
	vmovdqu	%ymm10, 1568(%rcx)
	vmovdqu	576(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 576(%rcx)
	vmovdqu	%ymm10, 1600(%rcx)
	vmovdqu	608(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 608(%rcx)
	vmovdqu	%ymm10, 1632(%rcx)
	vmovdqu	640(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 640(%rcx)
	vmovdqu	%ymm10, 1664(%rcx)
	vmovdqu	672(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 672(%rcx)
	vmovdqu	%ymm10, 1696(%rcx)
	vmovdqu	704(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 704(%rcx)
	vmovdqu	%ymm10, 1728(%rcx)
	vmovdqu	736(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 736(%rcx)
	vmovdqu	%ymm10, 1760(%rcx)
	vmovdqu	768(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 768(%rcx)
	vmovdqu	%ymm10, 1792(%rcx)
	vmovdqu	800(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 800(%rcx)
	vmovdqu	%ymm10, 1824(%rcx)
	vmovdqu	832(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 832(%rcx)
	vmovdqu	%ymm10, 1856(%rcx)
	vmovdqu	864(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 864(%rcx)
	vmovdqu	%ymm10, 1888(%rcx)
	vmovdqu	896(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 896(%rcx)
	vmovdqu	%ymm10, 1920(%rcx)
	vmovdqu	928(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 928(%rcx)
	vmovdqu	%ymm10, 1952(%rcx)
	vmovdqu	960(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rcx)
	vmovdqu	%ymm10, 1984(%rcx)
	vmovdqu	992(%rax), %ymm10
	vpsubd	%ymm10, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rcx)
	vmovdqu	%ymm10, 2016(%rcx)
	movw	$0, %ax
	movq	$0, %rcx
	movq	$0, %rdx
	movq	$1, 117088(%rsp)
	jmp 	.L__sign_internal$36
.L__sign_internal$37:
	movq	%rdx, 117048(%rsp)
	movw	%ax, 117336(%rsp)
	leaq	192(%rsp), %rcx
	movw	117336(%rsp), %dx
	leaq	4224(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$164:
	leaq	40(%rsp), %rsp
	leaq	4224(%rsp), %rax
	leaq	2752(%rsp), %rcx
	leaq	2048(%rsp), %rdx
	leaq	1344(%rsp), %rsi
	leaq	640(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$163:
	leaq	4224(%rsp), %rax
	leaq	2888(%rsp), %rcx
	leaq	2184(%rsp), %rdx
	leaq	1480(%rsp), %rsi
	leaq	776(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$162:
	leaq	4224(%rsp), %rax
	leaq	3024(%rsp), %rcx
	leaq	2320(%rsp), %rdx
	leaq	1616(%rsp), %rsi
	leaq	912(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$161:
	leaq	4224(%rsp), %rax
	leaq	3160(%rsp), %rcx
	leaq	2456(%rsp), %rdx
	leaq	1752(%rsp), %rsi
	leaq	1048(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$160:
	leaq	4224(%rsp), %rax
	leaq	3296(%rsp), %rcx
	leaq	2592(%rsp), %rdx
	leaq	1888(%rsp), %rsi
	leaq	1184(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$159:
	leaq	25888(%rsp), %rax
	leaq	2752(%rsp), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$157
.L__sign_internal$158:
	vmovdqu	(%r9,%r8), %xmm2
	addq	$4, %r8
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r8), %xmm2
	addq	$16, %r8
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
.L__sign_internal$157:
	cmpq	$1024, %r11
	jb  	.L__sign_internal$158
	leaq	26912(%rsp), %rax
	leaq	2048(%rsp), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$155
.L__sign_internal$156:
	vmovdqu	(%r9,%r8), %xmm2
	addq	$4, %r8
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r8), %xmm2
	addq	$16, %r8
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
.L__sign_internal$155:
	cmpq	$1024, %r11
	jb  	.L__sign_internal$156
	leaq	27936(%rsp), %rax
	leaq	1344(%rsp), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$153
.L__sign_internal$154:
	vmovdqu	(%r9,%r8), %xmm2
	addq	$4, %r8
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r8), %xmm2
	addq	$16, %r8
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
.L__sign_internal$153:
	cmpq	$1024, %r11
	jb  	.L__sign_internal$154
	leaq	28960(%rsp), %rax
	leaq	640(%rsp), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$151
.L__sign_internal$152:
	vmovdqu	(%r9,%r8), %xmm2
	addq	$4, %r8
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r8), %xmm2
	addq	$16, %r8
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
.L__sign_internal$151:
	cmpq	$1024, %r11
	jb  	.L__sign_internal$152
	addw	$4, 117336(%rsp)
	leaq	29984(%rsp), %rdi
	leaq	192(%rsp), %rax
	movw	117336(%rsp), %cx
	movq	%rdi, 117080(%rsp)
	leaq	416(%rsp), %rdx
	leaq	-8(%rsp), %rsp
	call	.Lshake256_absorb_66$1
.L__sign_internal$150:
	leaq	8(%rsp), %rsp
	leaq	416(%rsp), %rdx
	leaq	640(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$149:
	leaq	416(%rsp), %rdx
	leaq	776(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$148:
	leaq	416(%rsp), %rdx
	leaq	912(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$147:
	leaq	416(%rsp), %rdx
	leaq	1048(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$146:
	leaq	416(%rsp), %rdx
	leaq	1184(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$145:
	movq	117080(%rsp), %rdi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	leaq	640(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$143
.L__sign_internal$144:
	vmovdqu	(%r9,%r8), %xmm2
	addq	$4, %r8
	vinserti128	$0, %xmm2, %ymm10, %ymm10
	vmovdqu	(%r9,%r8), %xmm2
	addq	$16, %r8
	vinserti128	$1, %xmm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4800(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 4832(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rdi,%r11)
	addq	$32, %r11
.L__sign_internal$143:
	cmpq	$1024, %r11
	jb  	.L__sign_internal$144
	incw	117336(%rsp)
	movw	117336(%rsp), %ax
	movq	$0, %r9
	jmp 	.L__sign_internal$141
.L__sign_internal$142:
	vmovdqu	25888(%rsp,%r9), %ymm0
	vmovdqu	%ymm0, 20768(%rsp,%r9)
	addq	$32, %r9
.L__sign_internal$141:
	cmpq	$5120, %r9
	jb  	.L__sign_internal$142
	leaq	20768(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__sign_internal$140:
	leaq	86304(%rsp), %rcx
	leaq	20768(%rsp), %rdx
	leaq	55584(%rsp), %rsi
	movq	%rcx, %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$138
.L__sign_internal$139:
	vmovdqu	(%rdi,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdi,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$138:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$139
	leaq	56608(%rsp), %rsi
	leaq	5120(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$136
.L__sign_internal$137:
	vmovdqu	(%rdi,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdi,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$136:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$137
	leaq	57632(%rsp), %rsi
	leaq	10240(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$134
.L__sign_internal$135:
	vmovdqu	(%rdi,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdi,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$134:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$135
	leaq	58656(%rsp), %rsi
	leaq	15360(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$132
.L__sign_internal$133:
	vmovdqu	(%rdi,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdi,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$132:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$133
	leaq	59680(%rsp), %rsi
	leaq	20480(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$130
.L__sign_internal$131:
	vmovdqu	(%rdi,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdi,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$130:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$131
	leaq	60704(%rsp), %rsi
	leaq	25600(%rcx), %rcx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$128
.L__sign_internal$129:
	vmovdqu	(%rcx,%r8), %ymm2
	vmovdqu	(%rdx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rcx,%r8), %ymm4
	vmovdqu	1024(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%rcx,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%rcx,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%rcx,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.L__sign_internal$128:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$129
	leaq	55584(%rsp), %rcx
	call	.Lcolumn_vector__reduce32$1
.L__sign_internal$127:
	leaq	55584(%rsp), %rcx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__sign_internal$126:
	leaq	55584(%rsp), %rcx
	leaq	67872(%rsp), %rdx
	leaq	61728(%rsp), %rsi
	movq	%rcx, %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$125:
	leaq	68896(%rsp), %rdx
	leaq	62752(%rsp), %rsi
	leaq	1024(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$124:
	leaq	69920(%rsp), %rdx
	leaq	63776(%rsp), %rsi
	leaq	2048(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$123:
	leaq	70944(%rsp), %rdx
	leaq	64800(%rsp), %rsi
	leaq	3072(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$122:
	leaq	71968(%rsp), %rdx
	leaq	65824(%rsp), %rsi
	leaq	4096(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$121:
	leaq	72992(%rsp), %rdx
	leaq	66848(%rsp), %rsi
	leaq	5120(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$120:
	leaq	61728(%rsp), %rcx
	leaq	3456(%rsp), %rdx
	movq	%rcx, %rsi
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$118
.L__sign_internal$119:
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$118:
	cmpq	$128, %r11
	jb  	.L__sign_internal$119
	leaq	3584(%rsp), %rdx
	leaq	1024(%rcx), %rsi
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$116
.L__sign_internal$117:
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$116:
	cmpq	$128, %r11
	jb  	.L__sign_internal$117
	leaq	3712(%rsp), %rdx
	leaq	2048(%rcx), %rsi
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$114
.L__sign_internal$115:
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$114:
	cmpq	$128, %r11
	jb  	.L__sign_internal$115
	leaq	3840(%rsp), %rdx
	leaq	3072(%rcx), %rsi
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$112
.L__sign_internal$113:
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$112:
	cmpq	$128, %r11
	jb  	.L__sign_internal$113
	leaq	3968(%rsp), %rdx
	leaq	4096(%rcx), %rsi
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$110
.L__sign_internal$111:
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$110:
	cmpq	$128, %r11
	jb  	.L__sign_internal$111
	leaq	4096(%rsp), %rdx
	leaq	5120(%rcx), %rcx
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$108
.L__sign_internal$109:
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm2, %ymm5, %ymm4
	vpackusdw	%ymm7, %ymm6, %ymm5
	vpackusdw	%ymm9, %ymm8, %ymm2
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.L__sign_internal$108:
	cmpq	$128, %r11
	jb  	.L__sign_internal$109
	movw	%ax, 117336(%rsp)
	leaq	64(%rsp), %rax
	leaq	128(%rsp), %rcx
	leaq	3456(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__sign_internal$107:
	leaq	248(%rsp), %rsp
// declassify_mem 48 [RSP + 64]
	leaq	9504(%rsp), %rax
	leaq	64(%rsp), %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__sign_internal$105
.L__sign_internal$106:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__sign_internal$105:
	cmpq	$1024, %rsi
	jb  	.L__sign_internal$106
	movq	%rax, 117080(%rsp)
	leaq	416(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__sign_internal$104:
	leaq	416(%rsp), %rdx
	leaq	256(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$103:
	movq	117080(%rsp), %rcx
	movq	256(%rsp), %rdx
	movq	$8, %rdi
	lfence
	movq	$0, %r11
	movq	$207, %rsi
	jmp 	.L__sign_internal$96
.L__sign_internal$97:
	movq	$-1, %rax
	cmovnb	%rax, %r11
	jmp 	.L__sign_internal$98
.L__sign_internal$99:
	movq	$-1, %rax
	cmovbe	%rax, %r11
.L__sign_internal$98:
	cmpq	$136, %rdi
	jnb 	.L__sign_internal$100
	movq	$-1, %rax
	cmovnb	%rax, %r11
	jmp 	.L__sign_internal$101
.L__sign_internal$100:
	movq	%rsi, 117080(%rsp)
	movq	%rdx, 117072(%rsp)
	movq	%rcx, 117064(%rsp)
	leaq	416(%rsp), %rdx
	leaq	256(%rsp), %rcx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$102:
	movq	117080(%rsp), %rsi
	movq	117072(%rsp), %rdx
	movq	117064(%rsp), %rcx
	movq	$0, %rdi
	lfence
	movq	$0, %r11
.L__sign_internal$101:
	movzbq	256(%rsp,%rdi), %rax
// declassify_val u64 %rax
	orq 	%r11, %rax
	incq	%rdi
	cmpq	%rsi, %rax
	jnbe	.L__sign_internal$99
	movq	$-1, %r8
	cmovnbe	%r8, %r11
	movl	(%rcx,%rax,4), %r8d
	movl	%r8d, (%rcx,%rsi,4)
	movl	%edx, %r8d
	andl	$1, %r8d
	shll	$1, %r8d
	movl	$1, %r9d
	subl	%r8d, %r9d
	movl	%r9d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__sign_internal$96:
	cmpq	$256, %rsi
	jb  	.L__sign_internal$97
	movw	117336(%rsp), %ax
// declassify_mem 1024 [RSP + 9504]
	leaq	9504(%rsp), %rcx
	lfence
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	movq	$49, %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$90
.L__sign_internal$91:
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	vmovdqu	(%rcx,%r8), %ymm10
	vpinsrq	$0, %rdx, %xmm1, %xmm1
	vpinsrq	$1, %rdx, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm10, %ymm10
	vpcmpgtd	%ymm0, %ymm10, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$94
.L__sign_internal$95:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	movl	%r11d, 117136(%rsp,%rsi,4)
	incq	%rsi
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$94:
	cmpq	$0, %r10
	jne 	.L__sign_internal$95
	movq	$-1, %r10
	cmovne	%r10, %rdx
	vpcmpgtd	%ymm10, %ymm0, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$92
.L__sign_internal$93:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	decq	%rdi
	movl	%r11d, 117136(%rsp,%rdi,4)
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$92:
	cmpq	$0, %r10
	jne 	.L__sign_internal$93
	movq	$-1, %r10
	cmovne	%r10, %rdx
	addq	$8, %r9
	addq	$32, %r8
.L__sign_internal$90:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$91
	movq	$-1, %rcx
	cmovb	%rcx, %rdx
	movl	%esi, 117332(%rsp)
	movq	$0, %rcx
	leaq	15648(%rsp), %rdx
	leaq	117136(%rsp), %rsi
	leaq	25888(%rsp), %rdi
	leaq	10528(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$77
.L__sign_internal$78:
	leaq	(%rdx,%r9,4), %rcx
	leaq	(%rdi,%r9,4), %r10
	leaq	(%r8,%r9,4), %r11
	leaq	8480(%rsp), %rbx
	lfence
	movq	$0, %rbp
	movl	196(%rsi), %r12d
	orq 	%rbp, %r12
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$88
.L__sign_internal$89:
	movq	$-1, %r14
	cmovnb	%r14, %rbp
	movl	(%rsi,%r13,4), %r14d
	orq 	%rbp, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$88:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$89
	movq	$-1, %r14
	cmovb	%r14, %rbp
	jmp 	.L__sign_internal$86
.L__sign_internal$87:
	movq	$-1, %r14
	cmovnb	%r14, %rbp
	movl	(%rsi,%r13,4), %r14d
	orq 	%rbp, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$86:
	cmpq	$49, %r13
	jb  	.L__sign_internal$87
	movq	$-1, %r13
	cmovb	%r13, %rbp
	vmovdqu	%xmm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, (%rbx)
	vextracti128	$1, %ymm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 32(%rbx)
	vmovdqu	%xmm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 64(%rbx)
	vextracti128	$1, %ymm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 96(%rbx)
	vmovdqu	%xmm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 128(%rbx)
	vextracti128	$1, %ymm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 160(%rbx)
	vmovdqu	%xmm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 192(%rbx)
	vextracti128	$1, %ymm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 224(%rbx)
	vmovdqu	%xmm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 256(%rbx)
	vextracti128	$1, %ymm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 288(%rbx)
	vmovdqu	%xmm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 320(%rbx)
	vextracti128	$1, %ymm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 352(%rbx)
	vmovdqu	%xmm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 384(%rbx)
	vextracti128	$1, %ymm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 416(%rbx)
	vmovdqu	%xmm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 448(%rbx)
	vextracti128	$1, %ymm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 480(%rbx)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$84
.L__sign_internal$85:
	movq	$-1, %r14
	cmovnb	%r14, %rbp
	movl	(%rsi,%r13,4), %r14d
	orq 	%rbp, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rcx,%r15), %ymm8
	vpaddw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$84:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$85
	movq	$-1, %r12
	cmovb	%r12, %rbp
	jmp 	.L__sign_internal$82
.L__sign_internal$83:
	movq	$-1, %r12
	cmovnb	%r12, %rbp
	movl	(%rsi,%r13,4), %r14d
	orq 	%rbp, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rcx,%r15), %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$82:
	cmpq	$49, %r13
	jb  	.L__sign_internal$83
	movq	$-1, %rcx
	cmovb	%rcx, %rbp
	vmovdqu	%xmm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 512(%rbx)
	vextracti128	$1, %ymm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 544(%rbx)
	vmovdqu	%xmm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 576(%rbx)
	vextracti128	$1, %ymm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 608(%rbx)
	vmovdqu	%xmm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 640(%rbx)
	vextracti128	$1, %ymm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 672(%rbx)
	vmovdqu	%xmm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 704(%rbx)
	vextracti128	$1, %ymm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 736(%rbx)
	vmovdqu	%xmm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 768(%rbx)
	vextracti128	$1, %ymm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 800(%rbx)
	vmovdqu	%xmm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 832(%rbx)
	vextracti128	$1, %ymm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 864(%rbx)
	vmovdqu	%xmm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 896(%rbx)
	vextracti128	$1, %ymm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 928(%rbx)
	vmovdqu	%xmm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 960(%rbx)
	vextracti128	$1, %ymm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 992(%rbx)
	leaq	8480(%rsp), %rcx
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$524091, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$80
.L__sign_internal$81:
	vmovdqu	(%rcx,%rbx), %ymm4
	vmovdqu	(%r10,%rbx), %ymm5
	vpaddd	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm0, %ymm4, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm4
	vmovdqu	%ymm4, (%r11,%rbx)
	vpabsd	%ymm4, %ymm4
	vpcmpgtd	%ymm2, %ymm4, %ymm4
	vpor	%ymm4, %ymm3, %ymm3
	addq	$32, %rbx
.L__sign_internal$80:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$81
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$77:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$79
	movq	$1280, %r9
.L__sign_internal$79:
	cmpq	$1280, %r9
	jb  	.L__sign_internal$78
	leaq	49440(%rsp), %rdx
	leaq	67872(%rsp), %rsi
	leaq	43296(%rsp), %rdi
	leaq	117136(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$64
.L__sign_internal$65:
	leaq	8480(%rsp), %rcx
	leaq	(%rdi,%r9,4), %r10
	lfence
	movq	$0, %r11
	movl	196(%r8), %r12d
	orq 	%r11, %r12
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$75
.L__sign_internal$76:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$75:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$76
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$73
.L__sign_internal$74:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$73:
	cmpq	$49, %r13
	jb  	.L__sign_internal$74
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	vmovdqu	%xmm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, (%rcx)
	vextracti128	$1, %ymm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 32(%rcx)
	vmovdqu	%xmm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 64(%rcx)
	vextracti128	$1, %ymm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 96(%rcx)
	vmovdqu	%xmm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 128(%rcx)
	vextracti128	$1, %ymm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 160(%rcx)
	vmovdqu	%xmm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 192(%rcx)
	vextracti128	$1, %ymm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 224(%rcx)
	vmovdqu	%xmm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 256(%rcx)
	vextracti128	$1, %ymm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 288(%rcx)
	vmovdqu	%xmm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 320(%rcx)
	vextracti128	$1, %ymm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 352(%rcx)
	vmovdqu	%xmm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 384(%rcx)
	vextracti128	$1, %ymm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 416(%rcx)
	vmovdqu	%xmm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 448(%rcx)
	vextracti128	$1, %ymm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 480(%rcx)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$71
.L__sign_internal$72:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%r10,%r15), %ymm8
	vpaddw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$71:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$72
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$69
.L__sign_internal$70:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$1, %r15
	vmovdqu	(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%r10,%r15), %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$69:
	cmpq	$49, %r13
	jb  	.L__sign_internal$70
	movq	$-1, %r10
	cmovb	%r10, %r11
	vmovdqu	%xmm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 512(%rcx)
	vextracti128	$1, %ymm0, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 544(%rcx)
	vmovdqu	%xmm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 576(%rcx)
	vextracti128	$1, %ymm1, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 608(%rcx)
	vmovdqu	%xmm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 640(%rcx)
	vextracti128	$1, %ymm2, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 672(%rcx)
	vmovdqu	%xmm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 704(%rcx)
	vextracti128	$1, %ymm3, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 736(%rcx)
	vmovdqu	%xmm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 768(%rcx)
	vextracti128	$1, %ymm4, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 800(%rcx)
	vmovdqu	%xmm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 832(%rcx)
	vextracti128	$1, %ymm5, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 864(%rcx)
	vmovdqu	%xmm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 896(%rcx)
	vextracti128	$1, %ymm6, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 928(%rcx)
	vmovdqu	%xmm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 960(%rcx)
	vextracti128	$1, %ymm7, %xmm8
	vpmovsxwd	%xmm8, %ymm8
	vmovdqu	%ymm8, 992(%rcx)
	leaq	(%rdx,%r9,4), %rcx
	leaq	(%rsi,%r9,4), %r10
	leaq	8480(%rsp), %r11
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$261691, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$67
.L__sign_internal$68:
	vmovdqu	(%r10,%rbx), %ymm4
	vmovdqu	(%r11,%rbx), %ymm5
	vpsubd	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm0, %ymm4, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm4
	vmovdqu	%ymm4, (%rcx,%rbx)
	vpabsd	%ymm4, %ymm4
	vpcmpgtd	%ymm2, %ymm4, %ymm4
	vpor	%ymm4, %ymm3, %ymm3
	addq	$32, %rbx
.L__sign_internal$67:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$68
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$64:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$66
	movq	$1536, %r9
.L__sign_internal$66:
	cmpq	$1536, %r9
	jb  	.L__sign_internal$65
	leaq	31008(%rsp), %rdx
	leaq	49440(%rsp), %rsi
	leaq	74016(%rsp), %rdi
	leaq	117136(%rsp), %r8
	movq	$0, %r9
	cmpq	$0, %rcx
	je  	.L__sign_internal$43
	movq	$1536, %r9
.L__sign_internal$63:
	jmp 	.L__sign_internal$43
.L__sign_internal$44:
	lfence
	movq	$0, %r11
	leaq	8480(%rsp), %r10
	leaq	(%rdi,%r9,8), %rbx
	movl	196(%r8), %r12d
	orq 	%r11, %r12
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$61
.L__sign_internal$62:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$61:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$62
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$59
.L__sign_internal$60:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$256, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$59:
	cmpq	$49, %r13
	jb  	.L__sign_internal$60
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	vmovdqu	%ymm0, (%r10)
	vmovdqu	%ymm1, 32(%r10)
	vmovdqu	%ymm2, 64(%r10)
	vmovdqu	%ymm3, 96(%r10)
	vmovdqu	%ymm4, 128(%r10)
	vmovdqu	%ymm5, 160(%r10)
	vmovdqu	%ymm6, 192(%r10)
	vmovdqu	%ymm7, 224(%r10)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$57
.L__sign_internal$58:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$320, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$57:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$58
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$55
.L__sign_internal$56:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$320, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$55:
	cmpq	$49, %r13
	jb  	.L__sign_internal$56
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	vmovdqu	%ymm0, 256(%r10)
	vmovdqu	%ymm1, 288(%r10)
	vmovdqu	%ymm2, 320(%r10)
	vmovdqu	%ymm3, 352(%r10)
	vmovdqu	%ymm4, 384(%r10)
	vmovdqu	%ymm5, 416(%r10)
	vmovdqu	%ymm6, 448(%r10)
	vmovdqu	%ymm7, 480(%r10)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$53
.L__sign_internal$54:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$53:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$54
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$51
.L__sign_internal$52:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$384, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$51:
	cmpq	$49, %r13
	jb  	.L__sign_internal$52
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	vmovdqu	%ymm0, 512(%r10)
	vmovdqu	%ymm1, 544(%r10)
	vmovdqu	%ymm2, 576(%r10)
	vmovdqu	%ymm3, 608(%r10)
	vmovdqu	%ymm4, 640(%r10)
	vmovdqu	%ymm5, 672(%r10)
	vmovdqu	%ymm6, 704(%r10)
	vmovdqu	%ymm7, 736(%r10)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r13
	jmp 	.L__sign_internal$49
.L__sign_internal$50:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$448, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpaddd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$49:
	cmpq	%r12, %r13
	jb  	.L__sign_internal$50
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$47
.L__sign_internal$48:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r13,4), %r14d
	orq 	%r11, %r14
	movq	$448, %r15
	subq	%r14, %r15
	shlq	$2, %r15
	vmovdqu	(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm0
	vmovdqu	32(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm1, %ymm1
	vmovdqu	64(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm2, %ymm2
	vmovdqu	96(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm3, %ymm3
	vmovdqu	128(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm4, %ymm4
	vmovdqu	160(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm5, %ymm5
	vmovdqu	192(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm6, %ymm6
	vmovdqu	224(%rbx,%r15), %ymm8
	vpsubd	%ymm8, %ymm7, %ymm7
	incq	%r13
.L__sign_internal$47:
	cmpq	$49, %r13
	jb  	.L__sign_internal$48
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	vmovdqu	%ymm0, 768(%r10)
	vmovdqu	%ymm1, 800(%r10)
	vmovdqu	%ymm2, 832(%r10)
	vmovdqu	%ymm3, 864(%r10)
	vmovdqu	%ymm4, 896(%r10)
	vmovdqu	%ymm5, 928(%r10)
	vmovdqu	%ymm6, 960(%r10)
	vmovdqu	%ymm7, 992(%r10)
	leaq	(%rdx,%r9,4), %r10
	leaq	(%rsi,%r9,4), %r11
	leaq	8480(%rsp), %rbx
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %rbp
	jmp 	.L__sign_internal$45
.L__sign_internal$46:
	vmovdqu	(%rbx,%rbp), %ymm3
	vpaddd	%ymm0, %ymm3, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm3
	vmovdqu	(%r11,%rbp), %ymm2
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%rbp)
	addq	$32, %rbp
.L__sign_internal$45:
	cmpq	$1024, %rbp
	jb  	.L__sign_internal$46
	addq	$256, %r9
.L__sign_internal$43:
	cmpq	$1536, %r9
	jb  	.L__sign_internal$44
	leaq	31008(%rsp), %rdx
	leaq	61728(%rsp), %rsi
	leaq	37152(%rsp), %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$38
.L__sign_internal$39:
	leaq	(%rdi,%r9,4), %r10
	leaq	(%rdx,%r9,4), %r11
	leaq	(%rsi,%r9,4), %rbx
	movq	$261888, %rbp
	vmovq	%rbp, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$-261888, %rbp
	vmovq	%rbp, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %rbp
	movq	$0, %r12
	jmp 	.L__sign_internal$41
.L__sign_internal$42:
	vmovdqu	(%r11,%r12), %ymm2
	vmovdqu	(%rbx,%r12), %ymm3
	vpabsd	%ymm2, %ymm4
	vpcmpgtd	%ymm0, %ymm4, %ymm4
	vpcmpeqd	%ymm1, %ymm2, %ymm2
	vpsignd	%ymm3, %ymm2, %ymm2
	vpor	%ymm2, %ymm4, %ymm2
	vpmovmskb	%ymm2, %r13d
	shrl	$3, %r13d
	andl	$286331153, %r13d
	imull	$286331153, %r13d, %r13d
	shrl	$28, %r13d
	movl	%r13d, %r13d
	vpsrld	$31, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%r12)
	addq	%r13, %rbp
	addq	$32, %r12
.L__sign_internal$41:
	cmpq	$1024, %r12
	jb  	.L__sign_internal$42
	addq	%rbp, %r8
	addq	$256, %r9
	cmpq	$55, %r8
	setnbe	%r10b
	movzbq	%r10b, %r10
	orq 	%r10, %rcx
.L__sign_internal$38:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$40
	movq	$1536, %r9
.L__sign_internal$40:
	cmpq	$1536, %r9
	jb  	.L__sign_internal$39
// declassify_val u64 %rcx
	movq	117048(%rsp), %rdx
	lfence
	movq	$0, %rsi
	movq	%rcx, 117088(%rsp)
	xorq	$1, %rcx
	movzwl	%ax, %esi
	xorl	$65530, %esi
	testl	%esi, %esi
	sete	%sil
	movzbq	%sil, %rsi
	orq 	%rsi, %rdx
	orq 	%rdx, %rcx
.L__sign_internal$36:
	cmpq	$0, %rcx
	je  	.L__sign_internal$37
	movq	117040(%rsp), %rdi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	cmpq	$0, 117088(%rsp)
	je  	.L__sign_internal$2
	movq	$0, %rsi
	jmp 	.L__sign_internal$34
.L__sign_internal$35:
	movb	$0, (%rdi,%rsi)
	incq	%rsi
.L__sign_internal$34:
	cmpq	$3309, %rsi
	jb  	.L__sign_internal$35
	jmp 	.L__sign_internal$3
.L__sign_internal$2:
// declassify_mem 6144 [RSP + 37152]
// declassify_mem 48 [RSP + 64]
// declassify_mem 5120 [RSP + 10528]
	leaq	64(%rsp), %rdx
	leaq	10528(%rsp), %rcx
	leaq	37152(%rsp), %rax
	movq	$0, %rsi
	jmp 	.L__sign_internal$32
.L__sign_internal$33:
	vmovdqu	(%rdx,%rsi), %xmm0
	vmovdqu	%xmm0, (%rdi,%rsi)
	addq	$16, %rsi
.L__sign_internal$32:
	cmpq	$48, %rsi
	jb  	.L__sign_internal$33
	leaq	48(%rdi), %rdx
	movq	%rdx, %rsi
	movq	%rcx, %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$29
.L__sign_internal$30:
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$31:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$29:
	cmpq	$992, %r10
	jb  	.L__sign_internal$30
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$28:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 117024(%rsp)
// declassify_mem 16 [RSP + 117024]
	movb	117024(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	117025(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	117026(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	117027(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	117028(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	117029(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	117030(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	117031(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	117032(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	117033(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	640(%rdx), %rsi
	leaq	1024(%rcx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$25
.L__sign_internal$26:
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$27:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$25:
	cmpq	$992, %r10
	jb  	.L__sign_internal$26
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$24:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 117024(%rsp)
// declassify_mem 16 [RSP + 117024]
	movb	117024(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	117025(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	117026(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	117027(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	117028(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	117029(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	117030(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	117031(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	117032(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	117033(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	1280(%rdx), %rsi
	leaq	2048(%rcx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$21
.L__sign_internal$22:
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$23:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$21:
	cmpq	$992, %r10
	jb  	.L__sign_internal$22
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$20:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 117024(%rsp)
// declassify_mem 16 [RSP + 117024]
	movb	117024(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	117025(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	117026(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	117027(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	117028(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	117029(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	117030(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	117031(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	117032(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	117033(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	1920(%rdx), %rsi
	leaq	3072(%rcx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$17
.L__sign_internal$18:
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$19:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$17:
	cmpq	$992, %r10
	jb  	.L__sign_internal$18
	vmovdqu	(%r9,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$16:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 117024(%rsp)
// declassify_mem 16 [RSP + 117024]
	movb	117024(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	117025(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	117026(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	117027(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	117028(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	117029(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	117030(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	117031(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	117032(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	117033(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	2560(%rdx), %rsi
	leaq	4096(%rcx), %rcx
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$13
.L__sign_internal$14:
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$15:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$13:
	cmpq	$992, %r10
	jb  	.L__sign_internal$14
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$12:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 117024(%rsp)
// declassify_mem 16 [RSP + 117024]
	movb	117024(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	117025(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	117026(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	117027(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	117028(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	117029(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	117030(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	117031(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	117032(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	117033(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	movq	$0, %rcx
	movq	%rcx, 3248(%rdi)
	movq	%rcx, 3256(%rdi)
	movq	%rcx, 3264(%rdi)
	movq	%rcx, 3272(%rdi)
	movq	%rcx, 3280(%rdi)
	movq	%rcx, 3288(%rdi)
	movq	%rcx, 3296(%rdi)
	movb	$0, 3304(%rdi)
	movb	$0, 3305(%rdi)
	movb	$0, 3306(%rdi)
	movb	$0, 3307(%rdi)
	movb	$0, 3308(%rdi)
	lfence
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rcx
	movq	$0, %rsi
	jmp 	.L__sign_internal$4
.L__sign_internal$5:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	movq	%rsi, %r8
	shlq	$10, %r8
	movq	%r8, %r9
	addq	$1024, %r9
	movq	$0, %r10
	jmp 	.L__sign_internal$6
.L__sign_internal$7:
	movq	$-1, %r11
	cmovnb	%r11, %rdx
	vmovdqu	(%rax,%r8), %ymm10
	vpinsrq	$0, %rdx, %xmm1, %xmm1
	vpinsrq	$1, %rdx, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm10, %ymm10
	vpcmpeqd	%ymm0, %ymm10, %ymm1
	vmovmskps	%ymm1, %r11d
	movl	%r11d, %r11d
	xorq	$255, %r11
	jmp 	.L__sign_internal$8
.L__sign_internal$9:
	movq	$-1, %rbx
	cmove	%rbx, %rdx
	tzcntq	%r11, %r14
	addq	%r10, %r14
	cmpq	$55, %rcx
	jb  	.L__sign_internal$10
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L__sign_internal$11
.L__sign_internal$10:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%r14b, 3248(%rdi,%rcx)
	incq	%rcx
.L__sign_internal$11:
	movq	%r11, %r14
	decq	%r14
	andq	%r14, %r11
.L__sign_internal$8:
	cmpq	$0, %r11
	jne 	.L__sign_internal$9
	movq	$-1, %r11
	cmovne	%r11, %rdx
	addq	$8, %r10
	addq	$32, %r8
.L__sign_internal$6:
	cmpq	%r9, %r8
	jb  	.L__sign_internal$7
	movq	$-1, %r8
	cmovb	%r8, %rdx
	movb	%cl, 3303(%rdi,%rsi)
	incq	%rsi
.L__sign_internal$4:
	cmpq	$6, %rsi
	jb  	.L__sign_internal$5
.L__sign_internal$3:
	lfence
	movq	$0, %rax
	movq	117088(%rsp), %rax
	shlq	$63, %rax
	sarq	$63, %rax
	ret
.Lderive_seed_for_mask$1:
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	vmovdqu	(%rdx), %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	vmovdqu	(%rcx), %ymm0
	vmovdqu	%ymm0, 96(%rsp)
	vmovdqu	32(%rcx), %ymm0
	vmovdqu	%ymm0, 128(%rsp)
	leaq	32(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A64__A128$1
.Lderive_seed_for_mask$2:
	leaq	248(%rsp), %rsp
	ret
.L__keygen_internal$1:
	movq	%rdi, 61920(%rsp)
	movq	%rsi, 61928(%rsp)
	leaq	64(%rsp), %rdi
	movb	$6, 61976(%rsp)
	movb	$5, 61977(%rsp)
	leaq	61976(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A128__A32_A2$1
.L__keygen_internal$409:
	leaq	248(%rsp), %rsp
// declassify_mem 32 [RSP + 64]
	leaq	64(%rsp), %rsi
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 61936(%rsp)
	movw	$1, 61938(%rsp)
	movw	$2, 61940(%rsp)
	movw	$3, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$408:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$407:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$406:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$405:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$404:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$403:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	30176(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$402:
	movq	%rdi, %r11
	leaq	31200(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$401:
	movq	%rdi, %rbx
	leaq	32224(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$400:
	movq	%rdi, %r10
	leaq	33248(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$399:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$392
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$394
	cmpq	$256, %r10
	jb  	.L__keygen_internal$396
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$378
	movl	$0, %esi
.L__keygen_internal$398:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$396:
	movl	$0, %esi
.L__keygen_internal$397:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$394:
	movl	$0, %esi
.L__keygen_internal$395:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$392:
	movl	$0, %esi
.L__keygen_internal$393:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$379:
	movq	%r11, 61944(%rsp)
	movq	%rbx, 61952(%rsp)
	movq	%r10, 61960(%rsp)
	movq	%rdi, 61968(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$391:
	movq	61944(%rsp), %rdi
	movq	61952(%rsp), %rbx
	movq	61960(%rsp), %r10
	movq	61968(%rsp), %r12
	leaq	30176(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$390:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	31200(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$389:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	32224(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$388:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	33248(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$387:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$380
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$382
	cmpq	$256, %r10
	jb  	.L__keygen_internal$384
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$378
	movl	$0, %esi
.L__keygen_internal$386:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$384:
	movl	$0, %esi
.L__keygen_internal$385:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$382:
	movl	$0, %esi
.L__keygen_internal$383:
	jmp 	.L__keygen_internal$378
.L__keygen_internal$380:
	movl	$0, %esi
.L__keygen_internal$381:
.L__keygen_internal$378:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$379
	movw	$4, 61936(%rsp)
	movw	$256, 61938(%rsp)
	movw	$257, 61940(%rsp)
	movw	$258, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$377:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$376:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$375:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$374:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$373:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$372:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	34272(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$371:
	movq	%rdi, %rbx
	leaq	35296(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$370:
	movq	%rdi, %r11
	leaq	36320(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$369:
	movq	%rdi, %r10
	leaq	37344(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$368:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$361
	cmpq	$256, %r11
	jb  	.L__keygen_internal$363
	cmpq	$256, %r10
	jb  	.L__keygen_internal$365
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$347
	movl	$0, %esi
.L__keygen_internal$367:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$365:
	movl	$0, %esi
.L__keygen_internal$366:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$363:
	movl	$0, %esi
.L__keygen_internal$364:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$361:
	movl	$0, %esi
.L__keygen_internal$362:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$348:
	movq	%rbx, 61968(%rsp)
	movq	%r11, 61960(%rsp)
	movq	%r10, 61952(%rsp)
	movq	%rdi, 61944(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$360:
	movq	61968(%rsp), %rdi
	movq	61960(%rsp), %r11
	movq	61952(%rsp), %r10
	movq	61944(%rsp), %r12
	leaq	34272(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$359:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	35296(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$358:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	36320(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$357:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	37344(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$356:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$349
	cmpq	$256, %r11
	jb  	.L__keygen_internal$351
	cmpq	$256, %r10
	jb  	.L__keygen_internal$353
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$347
	movl	$0, %esi
.L__keygen_internal$355:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$353:
	movl	$0, %esi
.L__keygen_internal$354:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$351:
	movl	$0, %esi
.L__keygen_internal$352:
	jmp 	.L__keygen_internal$347
.L__keygen_internal$349:
	movl	$0, %esi
.L__keygen_internal$350:
.L__keygen_internal$347:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$348
	movw	$259, 61936(%rsp)
	movw	$260, 61938(%rsp)
	movw	$512, 61940(%rsp)
	movw	$513, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$346:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$345:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$344:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$343:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$342:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$341:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	38368(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$340:
	movq	%rdi, %rbx
	leaq	39392(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$339:
	movq	%rdi, %r11
	leaq	40416(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$338:
	movq	%rdi, %r10
	leaq	41440(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$337:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$330
	cmpq	$256, %r11
	jb  	.L__keygen_internal$332
	cmpq	$256, %r10
	jb  	.L__keygen_internal$334
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$316
	movl	$0, %esi
.L__keygen_internal$336:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$334:
	movl	$0, %esi
.L__keygen_internal$335:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$332:
	movl	$0, %esi
.L__keygen_internal$333:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$330:
	movl	$0, %esi
.L__keygen_internal$331:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$317:
	movq	%rbx, 61944(%rsp)
	movq	%r11, 61952(%rsp)
	movq	%r10, 61960(%rsp)
	movq	%rdi, 61968(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$329:
	movq	61944(%rsp), %rdi
	movq	61952(%rsp), %r11
	movq	61960(%rsp), %r10
	movq	61968(%rsp), %r12
	leaq	38368(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$328:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	39392(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$327:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	40416(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$326:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	41440(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$325:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$318
	cmpq	$256, %r11
	jb  	.L__keygen_internal$320
	cmpq	$256, %r10
	jb  	.L__keygen_internal$322
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$316
	movl	$0, %esi
.L__keygen_internal$324:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$322:
	movl	$0, %esi
.L__keygen_internal$323:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$320:
	movl	$0, %esi
.L__keygen_internal$321:
	jmp 	.L__keygen_internal$316
.L__keygen_internal$318:
	movl	$0, %esi
.L__keygen_internal$319:
.L__keygen_internal$316:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$317
	movw	$514, 61936(%rsp)
	movw	$515, 61938(%rsp)
	movw	$516, 61940(%rsp)
	movw	$768, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$315:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$314:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$313:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$312:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$311:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$310:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	42464(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$309:
	movq	%rdi, %r10
	leaq	43488(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$308:
	movq	%rdi, %r11
	leaq	44512(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$307:
	movq	%rdi, %rbx
	leaq	45536(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$306:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$299
	cmpq	$256, %r11
	jb  	.L__keygen_internal$301
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$303
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$285
	movl	$0, %esi
.L__keygen_internal$305:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$303:
	movl	$0, %esi
.L__keygen_internal$304:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$301:
	movl	$0, %esi
.L__keygen_internal$302:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$299:
	movl	$0, %esi
.L__keygen_internal$300:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$286:
	movq	%r10, 61968(%rsp)
	movq	%r11, 61960(%rsp)
	movq	%rbx, 61952(%rsp)
	movq	%rdi, 61944(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$298:
	movq	61968(%rsp), %rdi
	movq	61960(%rsp), %r11
	movq	61952(%rsp), %rbx
	movq	61944(%rsp), %r12
	leaq	42464(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$297:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	43488(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$296:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	44512(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$295:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	45536(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$294:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$287
	cmpq	$256, %r11
	jb  	.L__keygen_internal$289
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$291
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$285
	movl	$0, %esi
.L__keygen_internal$293:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$291:
	movl	$0, %esi
.L__keygen_internal$292:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$289:
	movl	$0, %esi
.L__keygen_internal$290:
	jmp 	.L__keygen_internal$285
.L__keygen_internal$287:
	movl	$0, %esi
.L__keygen_internal$288:
.L__keygen_internal$285:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$286
	movw	$769, 61936(%rsp)
	movw	$770, 61938(%rsp)
	movw	$771, 61940(%rsp)
	movw	$772, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$284:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$283:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$282:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$281:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$280:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$279:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	46560(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$278:
	movq	%rdi, %r10
	leaq	47584(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$277:
	movq	%rdi, %rbx
	leaq	48608(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$276:
	movq	%rdi, %r11
	leaq	49632(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$275:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$268
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$270
	cmpq	$256, %r11
	jb  	.L__keygen_internal$272
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$254
	movl	$0, %esi
.L__keygen_internal$274:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$272:
	movl	$0, %esi
.L__keygen_internal$273:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$270:
	movl	$0, %esi
.L__keygen_internal$271:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$268:
	movl	$0, %esi
.L__keygen_internal$269:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$255:
	movq	%r10, 61944(%rsp)
	movq	%rbx, 61952(%rsp)
	movq	%r11, 61960(%rsp)
	movq	%rdi, 61968(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$267:
	movq	61944(%rsp), %rdi
	movq	61952(%rsp), %rbx
	movq	61960(%rsp), %r11
	movq	61968(%rsp), %r12
	leaq	46560(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$266:
	movq	%rdi, %r10
	movq	%rbx, %rdi
	leaq	47584(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$265:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	48608(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$264:
	movq	%rdi, %r11
	movq	%r12, %rdi
	leaq	49632(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$263:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$256
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$258
	cmpq	$256, %r11
	jb  	.L__keygen_internal$260
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$254
	movl	$0, %esi
.L__keygen_internal$262:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$260:
	movl	$0, %esi
.L__keygen_internal$261:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$258:
	movl	$0, %esi
.L__keygen_internal$259:
	jmp 	.L__keygen_internal$254
.L__keygen_internal$256:
	movl	$0, %esi
.L__keygen_internal$257:
.L__keygen_internal$254:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$255
	movw	$1024, 61936(%rsp)
	movw	$1025, 61938(%rsp)
	movw	$1026, 61940(%rsp)
	movw	$1027, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$253:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$252:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$251:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$250:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$249:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$248:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	50656(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$247:
	movq	%rdi, %r10
	leaq	51680(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$246:
	movq	%rdi, %r11
	leaq	52704(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$245:
	movq	%rdi, %rbx
	leaq	53728(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$244:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$237
	cmpq	$256, %r11
	jb  	.L__keygen_internal$239
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$241
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$223
	movl	$0, %esi
.L__keygen_internal$243:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$241:
	movl	$0, %esi
.L__keygen_internal$242:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$239:
	movl	$0, %esi
.L__keygen_internal$240:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$237:
	movl	$0, %esi
.L__keygen_internal$238:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$224:
	movq	%r10, 61968(%rsp)
	movq	%r11, 61960(%rsp)
	movq	%rbx, 61952(%rsp)
	movq	%rdi, 61944(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$236:
	movq	61968(%rsp), %rdi
	movq	61960(%rsp), %r11
	movq	61952(%rsp), %rbx
	movq	61944(%rsp), %r12
	leaq	50656(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$235:
	movq	%rdi, %r10
	movq	%r11, %rdi
	leaq	51680(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$234:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	52704(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$233:
	movq	%rdi, %rbx
	movq	%r12, %rdi
	leaq	53728(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$232:
	movl	$1, %esi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$225
	cmpq	$256, %r11
	jb  	.L__keygen_internal$227
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$229
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$223
	movl	$0, %esi
.L__keygen_internal$231:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$229:
	movl	$0, %esi
.L__keygen_internal$230:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$227:
	movl	$0, %esi
.L__keygen_internal$228:
	jmp 	.L__keygen_internal$223
.L__keygen_internal$225:
	movl	$0, %esi
.L__keygen_internal$226:
.L__keygen_internal$223:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$224
	movw	$1028, 61936(%rsp)
	movw	$1280, 61938(%rsp)
	movw	$1281, 61940(%rsp)
	movw	$1282, 61942(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$222:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$221:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$220:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$219:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$218:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$217:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	54752(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$216:
	movq	%rdi, %rbx
	leaq	55776(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$215:
	movq	%rdi, %r11
	leaq	56800(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$214:
	movq	%rdi, %r10
	leaq	57824(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$213:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$206
	cmpq	$256, %r11
	jb  	.L__keygen_internal$208
	cmpq	$256, %r10
	jb  	.L__keygen_internal$210
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$192
	movl	$0, %esi
.L__keygen_internal$212:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$210:
	movl	$0, %esi
.L__keygen_internal$211:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$208:
	movl	$0, %esi
.L__keygen_internal$209:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$206:
	movl	$0, %esi
.L__keygen_internal$207:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$193:
	movq	%rbx, 61944(%rsp)
	movq	%r11, 61952(%rsp)
	movq	%r10, 61960(%rsp)
	movq	%rdi, 61968(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$205:
	movq	61944(%rsp), %rdi
	movq	61952(%rsp), %r11
	movq	61960(%rsp), %r10
	movq	61968(%rsp), %r12
	leaq	54752(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$204:
	movq	%rdi, %rbx
	movq	%r11, %rdi
	leaq	55776(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$203:
	movq	%rdi, %r11
	movq	%r10, %rdi
	leaq	56800(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$202:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	57824(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$201:
	movl	$1, %esi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$194
	cmpq	$256, %r11
	jb  	.L__keygen_internal$196
	cmpq	$256, %r10
	jb  	.L__keygen_internal$198
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$192
	movl	$0, %esi
.L__keygen_internal$200:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$198:
	movl	$0, %esi
.L__keygen_internal$199:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$196:
	movl	$0, %esi
.L__keygen_internal$197:
	jmp 	.L__keygen_internal$192
.L__keygen_internal$194:
	movl	$0, %esi
.L__keygen_internal$195:
.L__keygen_internal$192:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$193
	movw	$1283, 61936(%rsp)
	movw	$1284, 61938(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	61936(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$191:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$190:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$189:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$188:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$187:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$186:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	58848(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$185:
	movq	%rdi, %r11
	leaq	59872(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$184:
	movq	%rdi, %rbx
	leaq	60896(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$183:
	movq	%rdi, %r10
	leaq	5600(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$182:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$175
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$177
	cmpq	$256, %r10
	jb  	.L__keygen_internal$179
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$161
	movl	$0, %esi
.L__keygen_internal$181:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$179:
	movl	$0, %esi
.L__keygen_internal$180:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$177:
	movl	$0, %esi
.L__keygen_internal$178:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$175:
	movl	$0, %esi
.L__keygen_internal$176:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$162:
	movq	%r11, 61936(%rsp)
	movq	%rbx, 61968(%rsp)
	movq	%r10, 61960(%rsp)
	movq	%rdi, 61952(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$174:
	movq	61936(%rsp), %rdi
	movq	61968(%rsp), %rbx
	movq	61960(%rsp), %r10
	movq	61952(%rsp), %r12
	leaq	58848(%rsp), %rcx
	leaq	4736(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$173:
	movq	%rdi, %r11
	movq	%rbx, %rdi
	leaq	59872(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$172:
	movq	%rdi, %rbx
	movq	%r10, %rdi
	leaq	60896(%rsp), %rcx
	leaq	3008(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$171:
	movq	%rdi, %r10
	movq	%r12, %rdi
	leaq	5600(%rsp), %rcx
	leaq	2144(%rsp), %rdx
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$170:
	movl	$1, %esi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$163
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$165
	cmpq	$256, %r10
	jb  	.L__keygen_internal$167
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$161
	movl	$0, %esi
.L__keygen_internal$169:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$167:
	movl	$0, %esi
.L__keygen_internal$168:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$165:
	movl	$0, %esi
.L__keygen_internal$166:
	jmp 	.L__keygen_internal$161
.L__keygen_internal$163:
	movl	$0, %esi
.L__keygen_internal$164:
.L__keygen_internal$161:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$162
	leaq	96(%rsp), %rcx
	movw	$0, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$160:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$159:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$158:
	leaq	6624(%rsp), %r12
	leaq	1056(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$157:
	movq	%r9, %rbx
	leaq	7648(%rsp), %r12
	leaq	768(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$156:
	movq	%r9, %rbp
	leaq	8672(%rsp), %r12
	leaq	480(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$155:
	movq	%r9, %r11
	leaq	9696(%rsp), %r12
	leaq	192(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$154:
	movq	%r9, %r12
	movq	$1, %rsi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$147
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$149
	cmpq	$256, %r11
	jb  	.L__keygen_internal$151
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$129
	movq	$0, %rsi
.L__keygen_internal$153:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$151:
	movq	$0, %rsi
.L__keygen_internal$152:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$149:
	movq	$0, %rsi
.L__keygen_internal$150:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$147:
	movq	$0, %rsi
.L__keygen_internal$148:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$130:
	movq	%rbx, 61952(%rsp)
	movq	%rbp, 61960(%rsp)
	movq	%r11, 61968(%rsp)
	movq	%r12, 61936(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$146:
	movq	61952(%rsp), %rbx
	movq	61960(%rsp), %rbp
	movq	61968(%rsp), %r11
	movq	61936(%rsp), %r12
	lfence
	movq	$0, %rsi
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$144
	movq	%rbx, %r9
	leaq	6624(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$145:
	movq	%r9, %rbx
.L__keygen_internal$144:
	cmpq	$256, %rbp
	jnb 	.L__keygen_internal$142
	movq	%rbp, %r9
	leaq	7648(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$143:
	movq	%r9, %rbp
.L__keygen_internal$142:
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$140
	movq	%r11, %r9
	leaq	8672(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$141:
	movq	%r9, %r11
.L__keygen_internal$140:
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$138
	movq	%r12, %r9
	leaq	9696(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$139:
	movq	%r9, %r12
.L__keygen_internal$138:
	movq	$1, %rsi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$131
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$133
	cmpq	$256, %r11
	jb  	.L__keygen_internal$135
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$129
	movq	$0, %rsi
.L__keygen_internal$137:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$135:
	movq	$0, %rsi
.L__keygen_internal$136:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$133:
	movq	$0, %rsi
.L__keygen_internal$134:
	jmp 	.L__keygen_internal$129
.L__keygen_internal$131:
	movq	$0, %rsi
.L__keygen_internal$132:
.L__keygen_internal$129:
	cmpq	$1, %rsi
	jne 	.L__keygen_internal$130
	leaq	96(%rsp), %rcx
	movw	$4, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$128:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$127:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$126:
	leaq	10720(%rsp), %r12
	leaq	1056(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$125:
	movq	%r9, %r11
	leaq	11744(%rsp), %r12
	leaq	768(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$124:
	movq	%r9, %rbx
	leaq	12768(%rsp), %r12
	leaq	480(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$123:
	movq	%r9, %rbp
	leaq	13792(%rsp), %r12
	leaq	192(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$122:
	movq	%r9, %r12
	movq	$1, %rsi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$115
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$117
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$119
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$97
	movq	$0, %rsi
.L__keygen_internal$121:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$119:
	movq	$0, %rsi
.L__keygen_internal$120:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$117:
	movq	$0, %rsi
.L__keygen_internal$118:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$115:
	movq	$0, %rsi
.L__keygen_internal$116:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$98:
	movq	%r11, 61936(%rsp)
	movq	%rbx, 61968(%rsp)
	movq	%rbp, 61960(%rsp)
	movq	%r12, 61952(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$114:
	movq	61936(%rsp), %r11
	movq	61968(%rsp), %rbx
	movq	61960(%rsp), %rbp
	movq	61952(%rsp), %r12
	lfence
	movq	$0, %rax
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$112
	movq	%r11, %r9
	leaq	10720(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$113:
	movq	%r9, %r11
.L__keygen_internal$112:
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$110
	movq	%rbx, %r9
	leaq	11744(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$111:
	movq	%r9, %rbx
.L__keygen_internal$110:
	cmpq	$256, %rbp
	jnb 	.L__keygen_internal$108
	movq	%rbp, %r9
	leaq	12768(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$109:
	movq	%r9, %rbp
.L__keygen_internal$108:
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$106
	movq	%r12, %r9
	leaq	13792(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$107:
	movq	%r9, %r12
.L__keygen_internal$106:
	movq	$1, %rsi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$99
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$101
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$103
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$97
	movq	$0, %rsi
.L__keygen_internal$105:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$103:
	movq	$0, %rsi
.L__keygen_internal$104:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$101:
	movq	$0, %rsi
.L__keygen_internal$102:
	jmp 	.L__keygen_internal$97
.L__keygen_internal$99:
	movq	$0, %rsi
.L__keygen_internal$100:
.L__keygen_internal$97:
	cmpq	$1, %rsi
	jne 	.L__keygen_internal$98
	leaq	96(%rsp), %rcx
	movw	$8, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$96:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$95:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$94:
	leaq	14816(%rsp), %r12
	leaq	1056(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$93:
	movq	%r9, %r11
	leaq	15840(%rsp), %r12
	leaq	768(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$92:
	movq	%r9, %rbx
	leaq	16864(%rsp), %r12
	leaq	480(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$91:
	movq	%r9, %rbp
	leaq	5600(%rsp), %r12
	leaq	192(%rsp), %r10
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$90:
	movq	%r9, %r12
	movq	$1, %rsi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$83
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$85
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$87
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$65
	movq	$0, %rsi
.L__keygen_internal$89:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$87:
	movq	$0, %rsi
.L__keygen_internal$88:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$85:
	movq	$0, %rsi
.L__keygen_internal$86:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$83:
	movq	$0, %rsi
.L__keygen_internal$84:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$66:
	movq	%r11, 61952(%rsp)
	movq	%rbx, 61960(%rsp)
	movq	%rbp, 61968(%rsp)
	movq	%r12, 61936(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$82:
	movq	61952(%rsp), %r11
	movq	61960(%rsp), %rbx
	movq	61968(%rsp), %rbp
	movq	61936(%rsp), %r12
	lfence
	movq	$0, %rax
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$80
	movq	%r11, %r9
	leaq	14816(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$81:
	movq	%r9, %r11
.L__keygen_internal$80:
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$78
	movq	%rbx, %r9
	leaq	15840(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$79:
	movq	%r9, %rbx
.L__keygen_internal$78:
	cmpq	$256, %rbp
	jnb 	.L__keygen_internal$76
	movq	%rbp, %r9
	leaq	16864(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$77:
	movq	%r9, %rbp
.L__keygen_internal$76:
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$74
	movq	%r12, %r9
	leaq	5600(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$75:
	movq	%r9, %r12
.L__keygen_internal$74:
	movq	$1, %rsi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$67
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$69
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$71
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$65
	movq	$0, %rsi
.L__keygen_internal$73:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$71:
	movq	$0, %rsi
.L__keygen_internal$72:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$69:
	movq	$0, %rsi
.L__keygen_internal$70:
	jmp 	.L__keygen_internal$65
.L__keygen_internal$67:
	movq	$0, %rsi
.L__keygen_internal$68:
.L__keygen_internal$65:
	cmpq	$1, %rsi
	jne 	.L__keygen_internal$66
	movq	61920(%rsp), %rdi
	movq	61928(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	orq 	%rdx, %rsi
	vmovdqu	64(%rsp), %ymm0
	vmovdqu	%ymm0, (%rsi)
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	%ymm0, 32(%rsi)
	leaq	6624(%rsp), %rcx
	leaq	128(%rsi), %rax
	movq	%rcx, %mm0
	movq	%rax, %rdx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$64:
	movq	%mm0, %rcx
	leaq	128(%rax), %rdx
	leaq	1024(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$63:
	movq	%mm0, %rcx
	leaq	256(%rax), %rdx
	leaq	2048(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$62:
	movq	%mm0, %rcx
	leaq	384(%rax), %rdx
	leaq	3072(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$61:
	movq	%mm0, %rcx
	leaq	512(%rax), %rdx
	leaq	4096(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$60:
	leaq	11744(%rsp), %rcx
	leaq	768(%rsi), %rax
	movq	%rcx, %mm0
	movq	%rax, %rdx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$59:
	movq	%mm0, %rcx
	leaq	128(%rax), %rdx
	leaq	1024(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$58:
	movq	%mm0, %rcx
	leaq	256(%rax), %rdx
	leaq	2048(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$57:
	movq	%mm0, %rcx
	leaq	384(%rax), %rdx
	leaq	3072(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$56:
	movq	%mm0, %rcx
	leaq	512(%rax), %rdx
	leaq	4096(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$55:
	movq	%mm0, %rcx
	leaq	640(%rax), %rdx
	leaq	5120(%rcx), %rcx
	call	.Lerror_polynomial__encode_eta4$1
.L__keygen_internal$54:
	movq	%rsi, 61928(%rsp)
	leaq	6624(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__keygen_internal$53:
	leaq	30176(%rsp), %rax
	leaq	6624(%rsp), %rcx
	leaq	11744(%rsp), %rdx
	leaq	17888(%rsp), %rsi
	movq	%rax, %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$51
.L__keygen_internal$52:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$51:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$52
	leaq	18912(%rsp), %rsi
	leaq	5120(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$49
.L__keygen_internal$50:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$49:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$50
	leaq	19936(%rsp), %rsi
	leaq	10240(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$47
.L__keygen_internal$48:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$47:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$48
	leaq	20960(%rsp), %rsi
	leaq	15360(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$45
.L__keygen_internal$46:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$45:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$46
	leaq	21984(%rsp), %rsi
	leaq	20480(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$43
.L__keygen_internal$44:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$43:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$44
	leaq	23008(%rsp), %rsi
	leaq	25600(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$41
.L__keygen_internal$42:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rcx,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r9)
	addq	$32, %r9
.L__keygen_internal$41:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$42
	leaq	17888(%rsp), %rcx
	call	.Lcolumn_vector__reduce32$1
.L__keygen_internal$40:
	leaq	17888(%rsp), %rcx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__keygen_internal$39:
	leaq	17888(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %mm1
	leaq	24032(%rsp), %rax
	call	.Lpolynomial__add$1
.L__keygen_internal$38:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	25056(%rsp), %rax
	leaq	1024(%rcx), %rcx
	leaq	1024(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$37:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	26080(%rsp), %rax
	leaq	2048(%rcx), %rcx
	leaq	2048(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$36:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	27104(%rsp), %rax
	leaq	3072(%rcx), %rcx
	leaq	3072(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$35:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	28128(%rsp), %rax
	leaq	4096(%rcx), %rcx
	leaq	4096(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$34:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	29152(%rsp), %rax
	leaq	5120(%rcx), %rcx
	leaq	5120(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$33:
	leaq	24032(%rsp), %rax
	movq	%rax, %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$32:
	leaq	1024(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$31:
	leaq	2048(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$30:
	leaq	3072(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$29:
	leaq	4096(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$28:
	leaq	5120(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$27:
	leaq	24032(%rsp), %rax
	leaq	11744(%rsp), %rcx
	leaq	17888(%rsp), %rdx
	movq	%rax, %rsi
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$25
.L__keygen_internal$26:
	vmovdqu	(%rsi,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$25:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$26
	leaq	12768(%rsp), %rcx
	leaq	18912(%rsp), %rdx
	leaq	1024(%rax), %rsi
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$23
.L__keygen_internal$24:
	vmovdqu	(%rsi,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$23:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$24
	leaq	13792(%rsp), %rcx
	leaq	19936(%rsp), %rdx
	leaq	2048(%rax), %rsi
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$21
.L__keygen_internal$22:
	vmovdqu	(%rsi,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$21:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$22
	leaq	14816(%rsp), %rcx
	leaq	20960(%rsp), %rdx
	leaq	3072(%rax), %rsi
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$19
.L__keygen_internal$20:
	vmovdqu	(%rsi,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$19:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$20
	leaq	15840(%rsp), %rcx
	leaq	21984(%rsp), %rdx
	leaq	4096(%rax), %rsi
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$17
.L__keygen_internal$18:
	vmovdqu	(%rsi,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$17:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$18
	leaq	16864(%rsp), %rcx
	leaq	23008(%rsp), %rdx
	leaq	5120(%rax), %rax
	vmovdqu	glob_data + 5024(%rip), %ymm0
	movq	$1, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$15
.L__keygen_internal$16:
	vmovdqu	(%rax,%r8), %ymm10
	vpaddd	%ymm0, %ymm10, %ymm2
	vpsubd	%ymm1, %ymm2, %ymm2
	vpsrad	$13, %ymm2, %ymm2
	vpslld	$13, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm10, %ymm3
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm3, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$15:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$16
	leaq	32(%rdi), %rdx
	leaq	11744(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$14:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	320(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$13:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	640(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$12:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	960(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$11:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	1280(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$10:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	1600(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$9:
	leaq	24(%rsp), %rsp
// declassify_mem 1952 [RDI]
	movq	%rdi, %rcx
	movq	61928(%rsp), %rsi
	lfence
	movq	$0, %rdx
	leaq	64(%rsi), %rax
	movq	%rdi, 61928(%rsp)
	movq	%rsi, 61920(%rsp)
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__keygen_internal$8:
	leaq	248(%rsp), %rsp
	movq	61928(%rsp), %rdi
	movq	61920(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	orq 	%rdx, %rsi
	leaq	1536(%rsi), %rdx
	leaq	17888(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$7:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	416(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$6:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	832(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$5:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	1248(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$4:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	1664(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$3:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	2080(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$2:
	leaq	24(%rsp), %rsp
	ret
.Lerror_4x__rejection_sample_one_block$1:
	lfence
	movq	$0, %rdx
	movq	$0, %rsi
	movq	$0, %r10
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$3:
	movq	$-1, %rdi
	cmove	%rdi, %rdx
	movzbl	(%rcx,%rsi), %edi
	andl	$15, %edi
// declassify_val u32 %edi
	orl 	%edx, %edi
	cmpl	$9, %edi
	jb  	.Lerror_4x__rejection_sample_one_block$12
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$13
.Lerror_4x__rejection_sample_one_block$12:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	addl	$-4, %edi
	negl	%edi
	movl	%edi, (%rax,%r9,4)
	incq	%r9
.Lerror_4x__rejection_sample_one_block$13:
	cmpq	$256, %r9
	jb  	.Lerror_4x__rejection_sample_one_block$8
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$8:
	movq	$-1, %rdi
	cmovnb	%rdi, %rdx
	movzbl	(%rcx,%rsi), %edi
	shrl	$4, %edi
// declassify_val u32 %edi
	orl 	%edx, %edi
	cmpl	$9, %edi
	jb  	.Lerror_4x__rejection_sample_one_block$10
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$10:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	addl	$-4, %edi
	negl	%edi
	movl	%edi, (%rax,%r9,4)
	incq	%r9
.Lerror_4x__rejection_sample_one_block$11:
.Lerror_4x__rejection_sample_one_block$9:
	incq	%rsi
	cmpq	$136, %rsi
	jnb 	.Lerror_4x__rejection_sample_one_block$4
	movq	$-1, %rdi
	cmovnb	%rdi, %rdx
	cmpq	$256, %r9
	jnb 	.Lerror_4x__rejection_sample_one_block$6
	movq	$-1, %rdi
	cmovnb	%rdi, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$6:
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	movq	$1, %r10
.Lerror_4x__rejection_sample_one_block$7:
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$4:
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	movq	$1, %r10
.Lerror_4x__rejection_sample_one_block$5:
.Lerror_4x__rejection_sample_one_block$2:
	cmpq	$1, %r10
	jne 	.Lerror_4x__rejection_sample_one_block$3
	ret
.Lerror_4x__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %r13
	movq	$4, %rax
	vmovq	%rax, %xmm0
	vpbroadcastb	%xmm0, %ymm0
	movq	$9, %rax
	vmovq	%rax, %xmm1
	vpbroadcastb	%xmm1, %ymm1
	movq	$0, %rdi
	movq	$0, %rdx
	movq	$0, %r8
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$19:
	movq	$-1, %r9
	cmove	%r9, %r13
	vmovdqu	(%r10,%rdx), %xmm2
	movq	$15, %rax
	vmovq	%rax, %xmm5
	vpbroadcastb	%xmm5, %ymm5
	vpmovzxbw	%xmm2, %ymm10
	vpsllw	$4, %ymm10, %ymm2
	vpor	%ymm2, %ymm10, %ymm10
	vpand	%ymm5, %ymm10, %ymm10
	vpsubb	%ymm1, %ymm10, %ymm2
	vpmovmskb	%ymm2, %eax
	vpsubb	%ymm10, %ymm0, %ymm10
	vextracti128	$0, %ymm10, %xmm2
// declassify_val u64 %rax
	orq 	%r13, %rax
	movq	%rax, %r9
	andq	$255, %r9
	shrq	$8, %rax
	leaq	glob_data + 5360(%rip), %rsi
	movq	%r9, %rcx
	shlq	$3, %rcx
	vmovq	(%rsi,%rcx), %xmm3
	vpshufb	%xmm3, %xmm2, %xmm3
	vpmovsxbd	%xmm3, %ymm3
	vmovdqu	%ymm3, (%r12,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rdx
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$24
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$24:
	movq	$-1, %rcx
	cmovnb	%rcx, %r13
	vpsrldq	$8, %xmm2, %xmm2
	movq	%rax, %r9
	andq	$255, %r9
	shrq	$8, %rax
	leaq	glob_data + 5360(%rip), %rsi
	movq	%r9, %rcx
	shlq	$3, %rcx
	vmovq	(%rsi,%rcx), %xmm3
	vpshufb	%xmm3, %xmm2, %xmm3
	vpmovsxbd	%xmm3, %ymm3
	vmovdqu	%ymm3, (%r12,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rdx
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$26
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$26:
	movq	$-1, %rcx
	cmovnb	%rcx, %r13
	vextracti128	$1, %ymm10, %xmm2
	movq	%rax, %r9
	andq	$255, %r9
	shrq	$8, %rax
	leaq	glob_data + 5360(%rip), %rsi
	movq	%r9, %rcx
	shlq	$3, %rcx
	vmovq	(%rsi,%rcx), %xmm3
	vpshufb	%xmm3, %xmm2, %xmm3
	vpmovsxbd	%xmm3, %ymm3
	vmovdqu	%ymm3, (%r12,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rdx
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$28
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$28:
	movq	$-1, %rcx
	cmovnb	%rcx, %r13
	vpsrldq	$8, %xmm2, %xmm2
	andq	$255, %rax
	leaq	glob_data + 5360(%rip), %rsi
	movq	%rax, %rcx
	shlq	$3, %rcx
	vmovq	(%rsi,%rcx), %xmm3
	vpshufb	%xmm3, %xmm2, %xmm3
	vpmovsxbd	%xmm3, %ymm3
	vmovdqu	%ymm3, (%r12,%rdi)
	popcnt	%rax, %rax
	shlq	$2, %rax
	addq	%rax, %rdi
	addq	$4, %rdx
.Lerror_4x__rejection_sample_multiple_blocks$29:
.Lerror_4x__rejection_sample_multiple_blocks$27:
.Lerror_4x__rejection_sample_multiple_blocks$25:
	cmpq	$992, %rdi
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$20
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %rdx
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$22
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$22:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %r8
.Lerror_4x__rejection_sample_multiple_blocks$23:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$20:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %r8
.Lerror_4x__rejection_sample_multiple_blocks$21:
.Lerror_4x__rejection_sample_multiple_blocks$18:
	cmpq	$1, %r8
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$19
	movq	$-1, %rax
	cmovne	%rax, %r13
	movq	%rdi, %r9
	shrq	$2, %r9
	cmpq	$256, %r9
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$14
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$14:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$272, %rdx
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$16
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$16:
	movq	$-1, %rcx
	cmovnb	%rcx, %r13
	movq	$0, %r8
.Lerror_4x__rejection_sample_multiple_blocks$17:
.Lerror_4x__rejection_sample_multiple_blocks$15:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$3:
	movq	$-1, %rax
	cmove	%rax, %r13
	movzbl	(%r10,%rdx), %edi
	andl	$15, %edi
// declassify_val u32 %edi
	orl 	%r13d, %edi
	cmpl	$9, %edi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$12
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$13
.Lerror_4x__rejection_sample_multiple_blocks$12:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	addl	$-4, %edi
	negl	%edi
	movl	%edi, (%r12,%r9,4)
	incq	%r9
.Lerror_4x__rejection_sample_multiple_blocks$13:
	cmpq	$256, %r9
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$8
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$8:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movzbl	(%r10,%rdx), %edi
	shrl	$4, %edi
// declassify_val u32 %edi
	orl 	%r13d, %edi
	cmpl	$9, %edi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$10
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$10:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	addl	$-4, %edi
	negl	%edi
	movl	%edi, (%r12,%r9,4)
	incq	%r9
.Lerror_4x__rejection_sample_multiple_blocks$11:
.Lerror_4x__rejection_sample_multiple_blocks$9:
	incq	%rdx
	cmpq	$272, %rdx
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$4
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %r9
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$6
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$6:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %r8
.Lerror_4x__rejection_sample_multiple_blocks$7:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$4:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %r8
.Lerror_4x__rejection_sample_multiple_blocks$5:
.Lerror_4x__rejection_sample_multiple_blocks$2:
	cmpq	$1, %r8
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$3
	ret
.Lt1__decode_polynomial$1:
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.Lt1__decode_polynomial$2
.Lt1__decode_polynomial$3:
	vmovdqu	(%rdx,%r8), %xmm0
	addq	$10, %r8
	vinserti128	$0, %xmm0, %ymm10, %ymm10
	vinserti128	$1, %xmm0, %ymm10, %ymm10
	vmovdqu	glob_data + 64(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 96(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	glob_data + 32(%rip), %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%r11)
	addq	$32, %r11
.Lt1__decode_polynomial$2:
	cmpq	$992, %r11
	jb  	.Lt1__decode_polynomial$3
	vmovdqu	304(%rdx), %xmm0
	vpsrldq	$6, %xmm0, %xmm0
	vinserti128	$0, %xmm0, %ymm10, %ymm10
	vinserti128	$1, %xmm0, %ymm10, %ymm10
	vmovdqu	glob_data + 64(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 96(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	glob_data + 32(%rip), %ymm10, %ymm10
	vmovdqu	%ymm10, (%rcx,%r11)
	ret
.Lt1__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.Lt1__encode_polynomial$3
.Lt1__encode_polynomial$4:
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$5:
	vmovdqu	%xmm0, (%rax,%r8)
	addq	$10, %r8
	addq	$32, %r10
.Lt1__encode_polynomial$3:
	cmpq	$992, %r10
	jb  	.Lt1__encode_polynomial$4
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %r9b
	movb	%r9b, (%rax,%r8)
	movb	17(%rsp), %r9b
	movb	%r9b, 1(%rax,%r8)
	movb	18(%rsp), %r9b
	movb	%r9b, 2(%rax,%r8)
	movb	19(%rsp), %r9b
	movb	%r9b, 3(%rax,%r8)
	movb	20(%rsp), %r9b
	movb	%r9b, 4(%rax,%r8)
	movb	21(%rsp), %r9b
	movb	%r9b, 5(%rax,%r8)
	movb	22(%rsp), %r9b
	movb	%r9b, 6(%rax,%r8)
	movb	23(%rsp), %r9b
	movb	%r9b, 7(%rax,%r8)
	movb	24(%rsp), %r9b
	movb	%r9b, 8(%rax,%r8)
	movb	25(%rsp), %r9b
	movb	%r9b, 9(%rax,%r8)
	ret
.Lt1__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 128(%rip), %ymm2
	vpsllvd	%ymm2, %ymm10, %ymm0
	vpsrlq	$22, %ymm0, %ymm0
	vmovdqu	glob_data + 160(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm0
	vmovdqu	glob_data + 192(%rip), %ymm2
	vpsllvd	%ymm2, %ymm0, %ymm0
	vpsrlq	$12, %ymm0, %ymm0
	vpermq	$8, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	vmovdqu	glob_data + 5088(%rip), %xmm1
	vpshufb	%xmm1, %xmm0, %xmm0
	ret
.Lt0__bytestream_to_coefficients$1:
	vpxor	%ymm10, %ymm10, %ymm10
	vinserti128	$0, %xmm0, %ymm10, %ymm10
	vinserti128	$1, %xmm0, %ymm10, %ymm10
	vmovdqu	glob_data + 224(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 256(%rip), %ymm2
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 288(%rip), %ymm1
	vpand	%ymm1, %ymm10, %ymm10
	vmovdqu	glob_data + 5024(%rip), %ymm2
	vpsubd	%ymm10, %ymm2, %ymm10
	ret
.Lt0__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.Lt0__encode_polynomial$3
.Lt0__encode_polynomial$4:
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$5:
	vmovdqu	%xmm0, (%rax,%r8)
	addq	$13, %r8
	addq	$32, %r10
.Lt0__encode_polynomial$3:
	cmpq	$992, %r10
	jb  	.Lt0__encode_polynomial$4
	vmovdqu	(%rcx,%r10), %ymm10
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %r9b
	movb	%r9b, (%rax,%r8)
	movb	17(%rsp), %r9b
	movb	%r9b, 1(%rax,%r8)
	movb	18(%rsp), %r9b
	movb	%r9b, 2(%rax,%r8)
	movb	19(%rsp), %r9b
	movb	%r9b, 3(%rax,%r8)
	movb	20(%rsp), %r9b
	movb	%r9b, 4(%rax,%r8)
	movb	21(%rsp), %r9b
	movb	%r9b, 5(%rax,%r8)
	movb	22(%rsp), %r9b
	movb	%r9b, 6(%rax,%r8)
	movb	23(%rsp), %r9b
	movb	%r9b, 7(%rax,%r8)
	movb	24(%rsp), %r9b
	movb	%r9b, 8(%rax,%r8)
	movb	25(%rsp), %r9b
	movb	%r9b, 9(%rax,%r8)
	movb	26(%rsp), %r9b
	movb	%r9b, 10(%rax,%r8)
	movb	27(%rsp), %r9b
	movb	%r9b, 11(%rax,%r8)
	movb	28(%rsp), %r9b
	movb	%r9b, 12(%rax,%r8)
	ret
.Lt0__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 5024(%rip), %ymm2
	vpsubd	%ymm10, %ymm2, %ymm10
	vmovdqu	glob_data + 320(%rip), %ymm2
	vpsllvd	%ymm2, %ymm10, %ymm0
	vpsrlq	$19, %ymm0, %ymm0
	vmovdqu	glob_data + 352(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm0
	vmovdqu	glob_data + 384(%rip), %ymm2
	vpsllvd	%ymm2, %ymm0, %ymm0
	vpsrlq	$6, %ymm0, %ymm0
	vpsrldq	$8, %ymm0, %ymm1
	vpsllq	$52, %ymm1, %ymm1
	vpaddq	%ymm1, %ymm0, %ymm0
	vmovdqu	glob_data + 416(%rip), %ymm2
	vpsrlvq	%ymm2, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	ret
.Lcolumn_vector__invert_ntt_montgomery$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$7:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$6:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$5:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$4:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$3:
	leaq	5120(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$2:
	ret
.Lcolumn_vector__reduce32$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$7:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$6:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$5:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$4:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$3:
	leaq	5120(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$2:
	ret
.Lrow_vector__ntt$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$6:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$5:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$4:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$3:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$2:
	ret
.Lpolynomial__subtract$1:
	movq	$0, %r8
	jmp 	.Lpolynomial__subtract$2
.Lpolynomial__subtract$3:
	vmovdqu	(%rdx,%r8), %ymm0
	vmovdqu	(%r10,%r8), %ymm1
	vpsubd	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx,%r8)
	addq	$32, %r8
.Lpolynomial__subtract$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__subtract$3
	ret
.Lpolynomial__add$1:
	movq	$0, %r8
	jmp 	.Lpolynomial__add$2
.Lpolynomial__add$3:
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vpaddd	%ymm1, %ymm0, %ymm4
	vmovdqu	%ymm4, (%rax,%r8)
	addq	$32, %r8
.Lpolynomial__add$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__add$3
	ret
.Lmatrix_A__rejection_sample_one_block$1:
	movq	$0, %rax
	lfence
	movq	$0, %rbp
	movb	$0, %r8b
	cmpq	$256, %rdi
	jnb 	.Lmatrix_A__rejection_sample_one_block$10
	movq	$-1, %rsi
	cmovnb	%rsi, %rbp
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$10:
	movq	$-1, %rsi
	cmovb	%rsi, %rbp
	movb	$1, %r8b
.Lmatrix_A__rejection_sample_one_block$11:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$3:
	movq	$-1, %rsi
	cmove	%rsi, %rbp
	movzbl	(%rdx,%rax), %esi
	incq	%rax
	movzbl	(%rdx,%rax), %r8d
	incq	%rax
	movzbl	(%rdx,%rax), %r9d
	incq	%rax
	shll	$8, %r8d
	orl 	%r8d, %esi
	shll	$16, %r9d
	orl 	%r9d, %esi
	andl	$8388607, %esi
// declassify_val u32 %esi
	orl 	%ebp, %esi
	cmpl	$8380417, %esi
	jb  	.Lmatrix_A__rejection_sample_one_block$8
	movq	$-1, %rsi
	cmovb	%rsi, %rbp
	jmp 	.Lmatrix_A__rejection_sample_one_block$9
.Lmatrix_A__rejection_sample_one_block$8:
	movq	$-1, %r8
	cmovnb	%r8, %rbp
	movl	%esi, (%rcx,%rdi,4)
	incq	%rdi
.Lmatrix_A__rejection_sample_one_block$9:
	movb	$0, %r8b
	cmpq	$256, %rdi
	jnb 	.Lmatrix_A__rejection_sample_one_block$4
	movq	$-1, %rsi
	cmovnb	%rsi, %rbp
	cmpq	$168, %rax
	jnb 	.Lmatrix_A__rejection_sample_one_block$6
	movq	$-1, %rsi
	cmovnb	%rsi, %rbp
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$6:
	movq	$-1, %rsi
	cmovb	%rsi, %rbp
	movb	$1, %r8b
.Lmatrix_A__rejection_sample_one_block$7:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$4:
	movq	$-1, %r9
	cmovb	%r9, %rbp
	movb	$1, %r8b
.Lmatrix_A__rejection_sample_one_block$5:
.Lmatrix_A__rejection_sample_one_block$2:
	cmpb	$1, %r8b
	jne 	.Lmatrix_A__rejection_sample_one_block$3
	ret
.Lmatrix_A__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %rdx
	leaq	glob_data + 5104(%rip), %rsi
	movq	$0, %rdi
	movq	$0, %r8
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %rbp
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$15:
	movq	$-1, %r9
	cmove	%r9, %rdx
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	glob_data + 448(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm10
	vmovdqu	glob_data + 480(%rip), %ymm2
	vpshufb	%ymm2, %ymm10, %ymm10
	vmovdqu	glob_data + 512(%rip), %ymm2
	vpand	%ymm2, %ymm10, %ymm0
	addq	$24, %r8
	vpcmpgtd	%ymm0, %ymm1, %ymm2
	vpinsrq	$0, %rdx, %xmm3, %xmm3
	vpinsrq	$1, %rdx, %xmm3, %xmm3
	vinserti128	$1, %xmm3, %ymm3, %ymm3
	vpor	%ymm3, %ymm2, %ymm2
	vmovmskps	%ymm2, %r9d
// declassify_val u64 %r9
	vextracti128	$0, %ymm0, %xmm2
	movq	%r9, %rbp
	andq	$15, %rbp
	movq	%rbp, %r12
	shlq	$4, %r12
	vmovdqu	(%rsi,%r12), %xmm3
	vpshufb	%xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, (%rax,%rdi)
	popcnt	%rbp, %rbp
	shlq	$2, %rbp
	addq	%rbp, %rdi
	vextracti128	$1, %ymm0, %xmm0
	movq	%r9, %rbp
	shrq	$4, %rbp
	movq	%rbp, %r9
	shlq	$4, %r9
	vmovdqu	(%rsi,%r9), %xmm3
	vpshufb	%xmm3, %xmm0, %xmm0
	vmovdqu	%xmm0, (%rax,%rdi)
	popcnt	%rbp, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	movq	$0, %rbp
	cmpq	$992, %rdi
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$16
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	cmpq	$840, %r8
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$18
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$18:
	movq	$-1, %r9
	cmovb	%r9, %rdx
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$19:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$16:
	movq	$-1, %r9
	cmovb	%r9, %rdx
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$17:
.Lmatrix_A__rejection_sample_multiple_blocks$14:
	cmpq	$1, %rbp
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$15
	movq	$-1, %rsi
	cmovne	%rsi, %rdx
	shrq	$2, %rdi
	movq	$1, %rsi
	cmpq	$256, %rdi
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$10
	movq	$-1, %r9
	cmovb	%r9, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$10:
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	cmpq	$838, %r8
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$12
	movq	$-1, %r9
	cmovb	%r9, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$12:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	movq	$0, %rsi
.Lmatrix_A__rejection_sample_multiple_blocks$13:
.Lmatrix_A__rejection_sample_multiple_blocks$11:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$3:
	movq	$-1, %rsi
	cmove	%rsi, %rdx
	movzbl	(%rcx,%r8), %esi
	incq	%r8
	movzbl	(%rcx,%r8), %ebp
	incq	%r8
	movzbl	(%rcx,%r8), %r9d
	incq	%r8
	shll	$8, %ebp
	orl 	%ebp, %esi
	shll	$16, %r9d
	orl 	%r9d, %esi
	andl	$8388607, %esi
// declassify_val u32 %esi
	orl 	%edx, %esi
	cmpl	$8380417, %esi
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$8
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$9
.Lmatrix_A__rejection_sample_multiple_blocks$8:
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	movl	%esi, (%rax,%rdi,4)
	incq	%rdi
.Lmatrix_A__rejection_sample_multiple_blocks$9:
	movq	$0, %rsi
	cmpq	$256, %rdi
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$4
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	cmpq	$838, %r8
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$6
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$6:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %rsi
.Lmatrix_A__rejection_sample_multiple_blocks$7:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$4:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %rsi
.Lmatrix_A__rejection_sample_multiple_blocks$5:
.Lmatrix_A__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rsi
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$3
	ret
.Lshake256_squeezeblock4x$1:
	call	.L_keccakf1600_avx2x4_nat$1
.Lshake256_squeezeblock4x$6:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lshake256_squeezeblock4x$4
.Lshake256_squeezeblock4x$5:
	vmovdqu	(%rax,%r9,4), %ymm9
	vmovdqu	32(%rax,%r9,4), %ymm11
	vmovdqu	64(%rax,%r9,4), %ymm3
	vmovdqu	96(%rax,%r9,4), %ymm14
	addq	$32, %r9
	vperm2i128	$32, %ymm3, %ymm9, %ymm0
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm9, %ymm2
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm0, %ymm4
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm4, (%rcx,%r8)
	vmovdqu	%ymm1, (%rdx,%r8)
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	%ymm3, (%rdi,%r8)
	addq	$32, %r8
.Lshake256_squeezeblock4x$4:
	cmpq	$128, %r9
	jb  	.Lshake256_squeezeblock4x$5
	jmp 	.Lshake256_squeezeblock4x$2
.Lshake256_squeezeblock4x$3:
	movq	(%rax,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	8(%rax,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	16(%rax,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	movq	24(%rax,%r9,4), %r10
	movq	%r10, (%rdi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.Lshake256_squeezeblock4x$2:
	cmpq	$136, %r9
	jb  	.Lshake256_squeezeblock4x$3
	ret
.Lshake128_squeezeblock4x$1:
	call	.L_keccakf1600_avx2x4_nat$1
.Lshake128_squeezeblock4x$6:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lshake128_squeezeblock4x$4
.Lshake128_squeezeblock4x$5:
	vmovdqu	(%rax,%r9,4), %ymm9
	vmovdqu	32(%rax,%r9,4), %ymm11
	vmovdqu	64(%rax,%r9,4), %ymm3
	vmovdqu	96(%rax,%r9,4), %ymm14
	addq	$32, %r9
	vperm2i128	$32, %ymm3, %ymm9, %ymm0
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm9, %ymm2
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm0, %ymm4
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm4, (%rcx,%r8)
	vmovdqu	%ymm1, (%rdx,%r8)
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	%ymm3, (%rdi,%r8)
	addq	$32, %r8
.Lshake128_squeezeblock4x$4:
	cmpq	$160, %r9
	jb  	.Lshake128_squeezeblock4x$5
	jmp 	.Lshake128_squeezeblock4x$2
.Lshake128_squeezeblock4x$3:
	movq	(%rax,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	8(%rax,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	16(%rax,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	movq	24(%rax,%r9,4), %r10
	movq	%r10, (%rdi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.Lshake128_squeezeblock4x$2:
	cmpq	$168, %r9
	jb  	.Lshake128_squeezeblock4x$3
	ret
.Lshake256_absorb_66_4x$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.Lshake256_absorb_66_4x$6
.Lshake256_absorb_66_4x$7:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.Lshake256_absorb_66_4x$6:
	cmpq	$800, %rsi
	jb  	.Lshake256_absorb_66_4x$7
	movq	$0, %r8
	movq	$0, %rdi
	jmp 	.Lshake256_absorb_66_4x$4
.Lshake256_absorb_66_4x$5:
	vpbroadcastq	(%rcx,%r8), %ymm0
	addq	$8, %r8
	vpxor	(%rax,%rdi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%rdi)
	addq	$32, %rdi
.Lshake256_absorb_66_4x$4:
	cmpq	$256, %rdi
	jb  	.Lshake256_absorb_66_4x$5
	movw	%dx, 8(%rsp)
	incw	%dx
	movw	%dx, 16(%rsp)
	incw	%dx
	movw	%dx, 24(%rsp)
	incw	%dx
	movw	%dx, 32(%rsp)
	leaq	8(%rsp), %r9
	leaq	16(%rsp), %rcx
	leaq	24(%rsp), %rdx
	leaq	32(%rsp), %rsi
	movq	$0, %r8
	movq	$32, %rdi
	jmp 	.Lshake256_absorb_66_4x$2
.Lshake256_absorb_66_4x$3:
	movq	(%r9,%r8), %r10
	xorq	%r10, (%rax,%rdi,8)
	movq	(%rcx,%r8), %r10
	xorq	%r10, 8(%rax,%rdi,8)
	movq	(%rdx,%r8), %r10
	xorq	%r10, 16(%rax,%rdi,8)
	movq	(%rsi,%r8), %r10
	addq	$8, %r8
	xorq	%r10, 24(%rax,%rdi,8)
	addq	$4, %rdi
.Lshake256_absorb_66_4x$2:
	cmpq	$32, %rdi
	jb  	.Lshake256_absorb_66_4x$3
	movq	$0, %r10
	movzwq	(%r9,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rcx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rdx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 16(%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rsi,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 24(%rax,%rdi,8)
	movq	$-9223372036854775808, %r9
	movq	%r9, 40(%rsp)
	vpbroadcastq	40(%rsp), %ymm0
	vpxor	512(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rax)
	ret
.Lshake128_absorb_34_4x$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %r9
	jmp 	.Lshake128_absorb_34_4x$6
.Lshake128_absorb_34_4x$7:
	vmovdqu	%ymm0, (%rax,%r9)
	addq	$32, %r9
.Lshake128_absorb_34_4x$6:
	cmpq	$800, %r9
	jb  	.Lshake128_absorb_34_4x$7
	movq	$0, %rdx
	movq	$0, %rdi
	jmp 	.Lshake128_absorb_34_4x$4
.Lshake128_absorb_34_4x$5:
	vpbroadcastq	(%rsi,%rdx), %ymm0
	addq	$8, %rdx
	vpxor	(%rax,%rdi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%rdi)
	addq	$32, %rdi
.Lshake128_absorb_34_4x$4:
	cmpq	$128, %rdi
	jb  	.Lshake128_absorb_34_4x$5
	movw	(%rcx), %r9w
	movw	%r9w, 8(%rsp)
	movw	2(%rcx), %r9w
	movw	%r9w, 16(%rsp)
	movw	4(%rcx), %r9w
	movw	%r9w, 24(%rsp)
	movw	6(%rcx), %r9w
	movw	%r9w, 32(%rsp)
	leaq	8(%rsp), %r9
	leaq	16(%rsp), %rcx
	leaq	24(%rsp), %rdx
	leaq	32(%rsp), %rsi
	movq	$0, %r8
	movq	$16, %rdi
	jmp 	.Lshake128_absorb_34_4x$2
.Lshake128_absorb_34_4x$3:
	movq	(%r9,%r8), %r10
	xorq	%r10, (%rax,%rdi,8)
	movq	(%rcx,%r8), %r10
	xorq	%r10, 8(%rax,%rdi,8)
	movq	(%rdx,%r8), %r10
	xorq	%r10, 16(%rax,%rdi,8)
	movq	(%rsi,%r8), %r10
	addq	$8, %r8
	xorq	%r10, 24(%rax,%rdi,8)
	addq	$4, %rdi
.Lshake128_absorb_34_4x$2:
	cmpq	$16, %rdi
	jb  	.Lshake128_absorb_34_4x$3
	movq	$0, %r10
	movzwq	(%r9,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rcx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rdx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 16(%rax,%rdi,8)
	movq	$0, %r10
	movzwq	(%rsi,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 24(%rax,%rdi,8)
	movq	$-9223372036854775808, %r9
	movq	%r9, 40(%rsp)
	vpbroadcastq	40(%rsp), %ymm0
	vpxor	640(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 640(%rax)
	ret
.L__derive_commitment_hash$1:
	movq	%rax, %mm0
	leaq	32(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	vmovdqu	%ymm0, 128(%rax)
	vmovdqu	%ymm0, 160(%rax)
	movq	$0, 192(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %r8
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	32(%rdx,%r8), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	64(%rdx,%r8), %r10
	xorq	%r10, 128(%rax)
	addq	$72, %r8
	movq	%rdx, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$9:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	$0, %rsi
	jmp 	.L__derive_commitment_hash$6
.L__derive_commitment_hash$7:
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%rdx), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%rdx), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%rdx), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %rdx
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$8:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	incq	%rsi
.L__derive_commitment_hash$6:
	cmpq	$5, %rsi
	jb  	.L__derive_commitment_hash$7
	vmovdqu	(%rcx,%rdx), %xmm0
	vpxor	(%rax), %xmm0, %xmm0
	vmovdqu	%xmm0, (%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 16(%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %rsi
	jmp 	.L__derive_commitment_hash$3
.L__derive_commitment_hash$4:
	incq	%rsi
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	movq	128(%rax), %rdi
	movq	%rdi, 128(%rcx,%rdx)
	addq	$136, %rdx
.L__derive_commitment_hash$3:
	cmpq	$0, %rsi
	jb  	.L__derive_commitment_hash$4
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %xmm0
	vmovdqu	%xmm0, 32(%rcx,%rdx)
	ret
.Lhash_verification_key$1:
	movq	%rax, %mm0
	leaq	32(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	vmovdqu	%ymm0, 128(%rax)
	vmovdqu	%ymm0, 160(%rax)
	movq	$0, 192(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%rdx), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%rdx), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%rdx), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %rdx
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$9:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	$0, %rsi
	jmp 	.Lhash_verification_key$6
.Lhash_verification_key$7:
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%rdx), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%rdx), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%rdx), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %rdx
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$8:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	incq	%rsi
.Lhash_verification_key$6:
	cmpq	$13, %rsi
	jb  	.Lhash_verification_key$7
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %xmm0
	vpxor	32(%rax), %xmm0, %xmm0
	vmovdqu	%xmm0, 32(%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 48(%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %rsi
	jmp 	.Lhash_verification_key$3
.Lhash_verification_key$4:
	incq	%rsi
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	movq	128(%rax), %rdi
	movq	%rdi, 128(%rcx,%rdx)
	addq	$136, %rdx
.Lhash_verification_key$3:
	cmpq	$0, %rsi
	jb  	.Lhash_verification_key$4
	movq	%rcx, %mm1
	movq	%rdx, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rsi
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rsi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsi,%rdx)
	ret
.L__derive_message_representative$1:
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	vmovdqu	32(%rsi), %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	movb	$0, 96(%rsp)
	movb	%dl, 97(%rsp)
	movq	%rax, %mm0
	movq	%rcx, %mm3
	movq	%rdx, %mm4
	movq	%rdi, %mm1
	movq	%r8, %mm2
	leaq	128(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	vmovdqu	%ymm0, 128(%rax)
	vmovdqu	%ymm0, 160(%rax)
	movq	$0, 192(%rax)
	leaq	128(%rsp), %rax
	leaq	32(%rsp), %rcx
	movq	$0, %rdx
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %r10
	movzwq	64(%rcx,%rdx), %r9
	orq 	%r9, %r10
	xorq	%r10, 64(%rax)
	movq	$66, %r8
	movq	%mm3, %rdx
	movq	%mm4, %rsi
	movq	$136, %rdi
	leaq	128(%rsp), %rax
	call	.L_absorb_m_state$1
.L__derive_message_representative$5:
	movq	%mm1, %rdx
	movq	%mm2, %rsi
	movq	$136, %rdi
	leaq	128(%rsp), %rax
	call	.L_absorb_m_state$1
.L__derive_message_representative$4:
	movq	$136, %rdi
	movb	$31, %al
	leaq	128(%rsp), %rdx
	call	.L_finish_state$1
.L__derive_message_representative$3:
	movq	$0, %rbx
	movq	$64, %rsi
	movq	%mm0, %rdx
	leaq	128(%rsp), %rax
	call	.LA64___squeeze_state$1
.L__derive_message_representative$2:
	ret
.L_shake256_A64__A128$1:
	leaq	32(%rsp), %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	%ymm0, 32(%rdx)
	vmovdqu	%ymm0, 64(%rdx)
	vmovdqu	%ymm0, 96(%rdx)
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	%ymm0, 160(%rdx)
	movq	$0, 192(%rdx)
	leaq	32(%rsp), %rdx
	movq	$0, %r8
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rdx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rdx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rdx)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 128(%rdx)
	xorb	$128, 135(%rdx)
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %rsi
	jmp 	.L_shake256_A64__A128$3
.L_shake256_A64__A128$4:
	incq	%rsi
	movq	%rdi, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%rdx)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdi,%rdx)
	addq	$136, %rdx
.L_shake256_A64__A128$3:
	cmpq	$0, %rsi
	jb  	.L_shake256_A64__A128$4
	movq	%rdi, %mm1
	movq	%rdx, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	ret
.L_shake256_A128__A32_A2$1:
	leaq	32(%rsp), %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	%ymm0, 32(%rdx)
	vmovdqu	%ymm0, 64(%rdx)
	vmovdqu	%ymm0, 96(%rdx)
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	%ymm0, 160(%rdx)
	movq	$0, 192(%rdx)
	leaq	32(%rsp), %rdx
	movq	$0, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vpxor	(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	leaq	32(%rsp), %rdx
	movq	$0, %r8
	movq	$0, %r10
	movzwq	(%rax,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 32(%rdx)
	xorb	$128, 135(%rdx)
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %rsi
	jmp 	.L_shake256_A128__A32_A2$3
.L_shake256_A128__A32_A2$4:
	incq	%rsi
	movq	%rdi, %mm1
	movq	%rdx, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %rdx
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%rdx)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdi,%rdx)
	addq	$136, %rdx
.L_shake256_A128__A32_A2$3:
	cmpq	$0, %rsi
	jb  	.L_shake256_A128__A32_A2$4
	movq	%rdi, %mm1
	movq	%rdx, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%rdx)
	ret
.Lshake256_squeezeblock$1:
	movq	%rdx, %rax
	movq	%rdx, %mm0
	movq	%rcx, %mm1
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lshake256_squeezeblock$2:
	leaq	200(%rsp), %rsp
	movq	%mm0, %rax
	movq	%mm1, %rcx
	movq	$0, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	movq	128(%rax), %rdi
	movq	%rdi, 128(%rcx,%rdx)
	ret
.Lshake256_absorb_commitment_hash$1:
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	vmovdqu	%ymm0, 128(%rax)
	vmovdqu	%ymm0, 160(%rax)
	movq	$0, 192(%rax)
	movq	$0, %rdx
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %xmm0
	vpxor	32(%rax), %xmm0, %xmm0
	vmovdqu	%xmm0, 32(%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 48(%rax)
	xorb	$128, 135(%rax)
	ret
.Lshake256_absorb_66$1:
	movw	%cx, 8(%rsp)
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	%ymm0, 32(%rdx)
	vmovdqu	%ymm0, 64(%rdx)
	vmovdqu	%ymm0, 96(%rdx)
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	%ymm0, 160(%rdx)
	movq	$0, 192(%rdx)
	movq	$0, %r8
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rdx)
	leaq	8(%rsp), %rcx
	movq	$0, %r8
	movq	$0, %r10
	movzwq	(%rcx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 64(%rdx)
	xorb	$128, 135(%rdx)
	ret
.LA64___squeeze_state$1:
	cmpq	$0, %rbx
	jne 	.LA64___squeeze_state$7
	movq	%rdx, %mm1
	movq	%rsi, %mm0
	movq	%rdi, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.LA64___squeeze_state$8:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm0, %rsi
	movq	%mm2, %rdi
	movq	$0, %rbx
.LA64___squeeze_state$7:
	movq	$0, %r8
	addq	%rbx, %rsi
	jmp 	.LA64___squeeze_state$3
.LA64___squeeze_state$4:
	call	.LA64___dump_updstate$1
.LA64___squeeze_state$6:
	movq	%rdi, %mm2
	movq	%rsi, %mm0
	movq	%r8, %mm1
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.LA64___squeeze_state$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm0, %rsi
	movq	%mm1, %r8
	movq	%mm4, %rdx
	subq	%rdi, %rsi
	movq	$0, %rbx
.LA64___squeeze_state$3:
	cmpq	%rsi, %rdi
	jb  	.LA64___squeeze_state$4
	movq	%rsi, %rdi
	call	.LA64___dump_updstate$1
.LA64___squeeze_state$2:
	ret
.LA64___dump_updstate$1:
	movq	%rbx, %r9
	andq	$7, %r9
	cmpq	$0, %r9
	je  	.LA64___dump_updstate$12
	movq	%rdi, %r10
	subq	%rbx, %r10
	shrq	$3, %rbx
	shlq	$3, %rbx
	movq	(%rax,%rbx), %r11
	movb	%r9b, %cl
	shlb	$3, %cl
	shrq	%cl, %r11
	movq	%r8, %rcx
	cmpq	$8, %r10
	jnb 	.LA64___dump_updstate$15
	testq	$4, %r10
	je  	.LA64___dump_updstate$19
	movl	%r11d, (%rdx,%rcx)
	addq	$4, %rcx
	shrq	$32, %r11
.LA64___dump_updstate$19:
	testq	$2, %r10
	je  	.LA64___dump_updstate$18
	movw	%r11w, (%rdx,%rcx)
	addq	$2, %rcx
	shrq	$16, %r11
.LA64___dump_updstate$18:
	testq	$1, %r10
	je  	.LA64___dump_updstate$16
	movb	%r11b, (%rdx,%rcx)
	incq	%rcx
.LA64___dump_updstate$17:
	jmp 	.LA64___dump_updstate$16
.LA64___dump_updstate$15:
	movq	%r11, (%rdx,%rcx)
	addq	$8, %rcx
.LA64___dump_updstate$16:
	addq	%r9, %r10
	cmpq	$8, %r10
	jnb 	.LA64___dump_updstate$13
	movq	%rcx, %r8
	movq	%rdi, %rbx
	jmp 	.LA64___dump_updstate$12
.LA64___dump_updstate$13:
	movq	$8, %r10
	subq	%r9, %r10
	addq	%r10, %r8
	addq	$8, %rbx
.LA64___dump_updstate$14:
.LA64___dump_updstate$12:
	movq	%rbx, %rcx
	jmp 	.LA64___dump_updstate$10
.LA64___dump_updstate$11:
	vmovdqu	(%rax,%rbx), %ymm0
	vmovdqu	%ymm0, (%rdx,%r8)
	addq	$32, %r8
	movq	%rcx, %rbx
.LA64___dump_updstate$10:
	addq	$32, %rcx
	cmpq	%rdi, %rcx
	jbe 	.LA64___dump_updstate$11
	addq	$-16, %rcx
	cmpq	%rdi, %rcx
	jnbe	.LA64___dump_updstate$9
	vmovdqu	(%rax,%rbx), %xmm0
	vmovdqu	%xmm0, (%rdx,%r8)
	movq	%rcx, %rbx
	addq	$16, %r8
.LA64___dump_updstate$9:
	movq	%rbx, %rcx
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	jnbe	.LA64___dump_updstate$8
	movq	(%rax,%rbx), %r11
	movq	%r11, (%rdx,%r8)
	addq	$8, %r8
	movq	%rcx, %rbx
.LA64___dump_updstate$8:
	cmpq	%rdi, %rbx
	jnb 	.LA64___dump_updstate$2
	movq	%rdi, %r10
	andq	$7, %r10
	movq	(%rax,%rbx), %r11
	cmpq	$8, %r10
	jnb 	.LA64___dump_updstate$3
	testq	$4, %r10
	je  	.LA64___dump_updstate$7
	movl	%r11d, (%rdx,%r8)
	addq	$4, %r8
	shrq	$32, %r11
.LA64___dump_updstate$7:
	testq	$2, %r10
	je  	.LA64___dump_updstate$6
	movw	%r11w, (%rdx,%r8)
	addq	$2, %r8
	shrq	$16, %r11
.LA64___dump_updstate$6:
	testq	$1, %r10
	je  	.LA64___dump_updstate$2
	movb	%r11b, (%rdx,%r8)
	incq	%r8
.LA64___dump_updstate$5:
	jmp 	.LA64___dump_updstate$2
.LA64___dump_updstate$3:
	movq	%r11, (%rdx,%r8)
	addq	$8, %r8
.LA64___dump_updstate$4:
.LA64___dump_updstate$2:
	movq	%rdi, %rcx
	ret
.L_finish_state$1:
	xorb	%al, (%rdx,%r8)
	xorb	$128, -1(%rdx,%rdi)
	ret
.L_absorb_m_state$1:
	addq	%r8, %rsi
	jmp 	.L_absorb_m_state$3
.L_absorb_m_state$4:
	call	.L_add_m_updstate$1
.L_absorb_m_state$6:
	movq	%rdi, %mm4
	movq	%rsi, %mm5
	movq	%rdx, %mm6
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_absorb_m_state$5:
	leaq	200(%rsp), %rsp
	movq	%mm4, %rdi
	movq	%mm5, %rsi
	movq	%mm6, %rdx
	subq	%rdi, %rsi
	movq	$0, %r8
.L_absorb_m_state$3:
	cmpq	%rsi, %rdi
	jbe 	.L_absorb_m_state$4
	movq	%rsi, %rdi
	call	.L_add_m_updstate$1
.L_absorb_m_state$2:
	ret
.L_add_m_updstate$1:
	movq	%r8, %r9
	andq	$7, %r9
	cmpq	$0, %r9
	je  	.L_add_m_updstate$13
	movq	%rdi, %r10
	subq	%r8, %r10
	shrq	$3, %r8
	shlq	$3, %r8
	movq	%rdx, %r11
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
	addq	%r9, %r10
	movb	%r9b, %cl
	shlb	$3, %cl
	shlq	%cl, %rbx
	xorq	%rbx, (%rax,%r8)
	cmpq	$8, %r10
	jnb 	.L_add_m_updstate$14
	movq	%r11, %rdx
	movq	%rdi, %r8
	jmp 	.L_add_m_updstate$13
.L_add_m_updstate$14:
	movq	$8, %r10
	subq	%r9, %r10
	addq	%r10, %rdx
	addq	$8, %r8
.L_add_m_updstate$15:
.L_add_m_updstate$13:
	movq	%r8, %rcx
	jmp 	.L_add_m_updstate$11
.L_add_m_updstate$12:
	vmovdqu	(%rdx), %ymm0
	addq	$32, %rdx
	vpxor	(%rax,%r8), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r8)
	movq	%rcx, %r8
.L_add_m_updstate$11:
	addq	$32, %rcx
	cmpq	%rdi, %rcx
	jbe 	.L_add_m_updstate$12
	addq	$-16, %rcx
	cmpq	%rdi, %rcx
	jnbe	.L_add_m_updstate$10
	vmovdqu	(%rdx), %xmm0
	addq	$16, %rdx
	vpxor	(%rax,%r8), %xmm0, %xmm0
	vmovdqu	%xmm0, (%rax,%r8)
	movq	%rcx, %r8
.L_add_m_updstate$10:
	movq	%r8, %rcx
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	jnbe	.L_add_m_updstate$9
	movq	(%rdx), %r11
	addq	$8, %rdx
	xorq	%r11, (%rax,%r8)
	movq	%rcx, %r8
.L_add_m_updstate$9:
	cmpq	%rdi, %r8
	jnb 	.L_add_m_updstate$2
	movq	%rdi, %r10
	andq	$7, %r10
	cmpq	$8, %r10
	jnb 	.L_add_m_updstate$3
	testq	$4, %r10
	jne 	.L_add_m_updstate$7
	movq	$0, %r11
	movb	$0, %cl
	jmp 	.L_add_m_updstate$8
.L_add_m_updstate$7:
	movl	(%rdx), %r11d
	addq	$4, %rdx
	movb	$32, %cl
.L_add_m_updstate$8:
	testq	$2, %r10
	je  	.L_add_m_updstate$6
	movzwq	(%rdx), %r9
	shlq	%cl, %r9
	addq	%r9, %r11
	addq	$2, %rdx
	addb	$16, %cl
.L_add_m_updstate$6:
	testq	$1, %r10
	je  	.L_add_m_updstate$4
	movzbq	(%rdx), %r9
	shlq	%cl, %r9
	addq	%r9, %r11
	incq	%rdx
.L_add_m_updstate$5:
	jmp 	.L_add_m_updstate$4
.L_add_m_updstate$3:
	movq	(%rdx), %r11
	addq	$8, %rdx
.L_add_m_updstate$4:
	xorq	%r11, (%rax,%r8)
.L_add_m_updstate$2:
	movq	%rdi, %r8
	ret
.L_keccakf1600_avx2x4_nat$1:
	vmovdqu	224(%rax), %ymm10
	vmovdqu	256(%rax), %ymm13
	vmovdqu	352(%rax), %ymm7
	vmovdqu	384(%rax), %ymm0
	vmovdqu	480(%rax), %ymm4
	vmovdqu	576(%rax), %ymm1
	vmovdqu	672(%rax), %ymm14
	vmovdqu	704(%rax), %ymm2
	vmovdqu	768(%rax), %ymm3
	leaq	glob_data + 544(%rip), %r8
	leaq	glob_data + 576(%rip), %r9
	leaq	glob_data + 7408(%rip), %r10
	movq	$0, %r11
.L_keccakf1600_avx2x4_nat$2:
	vmovdqu	160(%rax), %ymm12
	vpxor	640(%rax), %ymm4, %ymm9
	vmovdqu	%ymm4, 224(%rax)
	vmovdqu	%ymm10, %ymm4
	vmovdqu	192(%rax), %ymm8
	vmovdqu	512(%rax), %ymm6
	vmovdqu	%ymm14, 352(%rax)
	vpxor	320(%rax), %ymm12, %ymm11
	vmovdqu	64(%rax), %ymm10
	vmovdqu	%ymm12, 256(%rax)
	vpxor	%ymm14, %ymm6, %ymm6
	vmovdqu	32(%rax), %ymm5
	vmovdqu	448(%rax), %ymm12
	vmovdqu	%ymm13, 576(%rax)
	vpxor	%ymm11, %ymm9, %ymm9
	vpxor	%ymm7, %ymm8, %ymm11
	vpxor	544(%rax), %ymm2, %ymm8
	vmovdqu	%ymm10, 480(%rax)
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm4, %ymm11
	vmovdqu	288(%rax), %ymm14
	vmovdqu	%ymm7, 384(%rax)
	vpxor	%ymm11, %ymm8, %ymm8
	vpxor	416(%rax), %ymm13, %ymm11
	vpxor	%ymm5, %ymm6, %ymm6
	vmovdqu	96(%rax), %ymm7
	vpxor	%ymm10, %ymm8, %ymm8
	vpxor	736(%rax), %ymm1, %ymm10
	vpxor	%ymm12, %ymm14, %ymm14
	vmovdqu	%ymm12, 672(%rax)
	vpsrlq	$63, %ymm6, %ymm12
	vpsrlq	$63, %ymm8, %ymm15
	vpxor	(%rax), %ymm9, %ymm9
	vpxor	%ymm11, %ymm10, %ymm10
	vmovdqu	128(%rax), %ymm13
	vpxor	%ymm7, %ymm10, %ymm10
	vpxor	608(%rax), %ymm3, %ymm11
	vmovdqu	%ymm13, 704(%rax)
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
	vpxor	(%rax), %ymm14, %ymm6
	vpxor	%ymm8, %ymm11, %ymm11
	vpsrlq	$63, %ymm9, %ymm8
	vpsllq	$1, %ymm9, %ymm9
	vpxor	%ymm1, %ymm11, %ymm1
	vpxor	%ymm7, %ymm11, %ymm7
	vpor	%ymm8, %ymm9, %ymm9
	vpxor	%ymm10, %ymm9, %ymm9
	vpxor	192(%rax), %ymm12, %ymm10
	vpxor	%ymm3, %ymm9, %ymm3
	vpsrlq	$20, %ymm10, %ymm8
	vpsllq	$44, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpxor	%ymm0, %ymm15, %ymm8
	vpbroadcastq	(%r10,%r11,8), %ymm0
	vpsrlq	$21, %ymm8, %ymm13
	vpsllq	$43, %ymm8, %ymm8
	vpor	%ymm13, %ymm8, %ymm8
	vpandn	%ymm8, %ymm10, %ymm13
	vpxor	%ymm0, %ymm13, %ymm13
	vpxor	%ymm6, %ymm13, %ymm0
	vpsrlq	$43, %ymm1, %ymm13
	vpsllq	$21, %ymm1, %ymm1
	vmovdqu	%ymm0, (%rax)
	vpor	%ymm13, %ymm1, %ymm1
	vpandn	%ymm1, %ymm8, %ymm13
	vpxor	%ymm10, %ymm13, %ymm0
	vpsrlq	$50, %ymm3, %ymm13
	vpsllq	$14, %ymm3, %ymm3
	vmovdqu	%ymm0, 32(%rax)
	vpor	%ymm13, %ymm3, %ymm3
	vpandn	%ymm3, %ymm1, %ymm13
	vpxor	%ymm8, %ymm13, %ymm8
	vmovdqu	%ymm8, 64(%rax)
	vpandn	%ymm6, %ymm3, %ymm8
	vpandn	%ymm10, %ymm6, %ymm6
	vpxor	%ymm1, %ymm8, %ymm8
	vmovdqu	%ymm8, 96(%rax)
	vpxor	%ymm3, %ymm6, %ymm8
	vpsrlq	$36, %ymm7, %ymm3
	vpsllq	$28, %ymm7, %ymm7
	vmovdqu	%ymm8, 128(%rax)
	vpor	%ymm3, %ymm7, %ymm7
	vpxor	288(%rax), %ymm9, %ymm3
	vpsrlq	$44, %ymm3, %ymm10
	vpsllq	$20, %ymm3, %ymm3
	vpor	%ymm10, %ymm3, %ymm3
	vpxor	320(%rax), %ymm14, %ymm10
	vpsrlq	$61, %ymm10, %ymm8
	vpsllq	$3, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpandn	%ymm10, %ymm3, %ymm8
	vpxor	%ymm7, %ymm8, %ymm8
	vmovdqu	%ymm8, 160(%rax)
	vpxor	512(%rax), %ymm12, %ymm8
	vpsrlq	$19, %ymm8, %ymm6
	vpsllq	$45, %ymm8, %ymm8
	vpor	%ymm6, %ymm8, %ymm8
	vpandn	%ymm8, %ymm10, %ymm6
	vpxor	%ymm3, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rax)
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
	vmovdqu	%ymm6, 288(%rax)
	vpxor	608(%rax), %ymm9, %ymm2
	vpor	%ymm3, %ymm4, %ymm4
	vpxor	416(%rax), %ymm11, %ymm3
	vpshufb	(%r8), %ymm2, %ymm2
	vpsrlq	$39, %ymm3, %ymm8
	vpsllq	$25, %ymm3, %ymm3
	vpor	%ymm3, %ymm8, %ymm8
	vpandn	%ymm8, %ymm4, %ymm3
	vpandn	%ymm2, %ymm8, %ymm7
	vpxor	%ymm5, %ymm3, %ymm6
	vpxor	640(%rax), %ymm14, %ymm3
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm6, 320(%rax)
	vpsrlq	$46, %ymm3, %ymm6
	vpsllq	$18, %ymm3, %ymm3
	vpor	%ymm3, %ymm6, %ymm3
	vpandn	%ymm3, %ymm2, %ymm6
	vpxor	%ymm8, %ymm6, %ymm0
	vpandn	%ymm5, %ymm3, %ymm8
	vpandn	%ymm4, %ymm5, %ymm5
	vpxor	%ymm2, %ymm8, %ymm6
	vmovdqu	%ymm6, 416(%rax)
	vpxor	%ymm3, %ymm5, %ymm6
	vpxor	704(%rax), %ymm9, %ymm5
	vpxor	672(%rax), %ymm9, %ymm9
	vmovdqu	%ymm6, 448(%rax)
	vpsrlq	$37, %ymm5, %ymm3
	vpsllq	$27, %ymm5, %ymm5
	vpor	%ymm5, %ymm3, %ymm3
	vpxor	256(%rax), %ymm14, %ymm5
	vpxor	224(%rax), %ymm14, %ymm14
	vpsrlq	$28, %ymm5, %ymm2
	vpsllq	$36, %ymm5, %ymm5
	vpor	%ymm5, %ymm2, %ymm2
	vpxor	384(%rax), %ymm12, %ymm5
	vpxor	352(%rax), %ymm12, %ymm12
	vpsrlq	$54, %ymm5, %ymm6
	vpsllq	$10, %ymm5, %ymm5
	vpor	%ymm5, %ymm6, %ymm6
	vpxor	544(%rax), %ymm15, %ymm5
	vpxor	480(%rax), %ymm15, %ymm15
	vpandn	%ymm6, %ymm2, %ymm4
	vpsrlq	$49, %ymm5, %ymm8
	vpsllq	$15, %ymm5, %ymm5
	vpxor	%ymm3, %ymm4, %ymm4
	vpor	%ymm5, %ymm8, %ymm8
	vpandn	%ymm8, %ymm6, %ymm5
	vpxor	%ymm2, %ymm5, %ymm5
	vmovdqu	%ymm5, 512(%rax)
	vpxor	736(%rax), %ymm11, %ymm5
	vpxor	576(%rax), %ymm11, %ymm11
	vpshufb	(%r9), %ymm5, %ymm5
	vpandn	%ymm5, %ymm8, %ymm1
	vpxor	%ymm6, %ymm1, %ymm1
	vmovdqu	%ymm1, 544(%rax)
	vpandn	%ymm3, %ymm5, %ymm1
	vpandn	%ymm2, %ymm3, %ymm3
	vpxor	%ymm5, %ymm3, %ymm3
	vpsrlq	$62, %ymm12, %ymm5
	vpxor	%ymm8, %ymm1, %ymm1
	vmovdqu	%ymm3, 608(%rax)
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
	vmovdqu	%ymm9, 640(%rax)
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
	vmovdqu	%ymm15, 736(%rax)
	incq	%r11
	cmpq	$24, %r11
	jb  	.L_keccakf1600_avx2x4_nat$2
	vmovdqu	%ymm10, 224(%rax)
	vmovdqu	%ymm13, 256(%rax)
	vmovdqu	%ymm7, 352(%rax)
	vmovdqu	%ymm0, 384(%rax)
	vmovdqu	%ymm4, 480(%rax)
	vmovdqu	%ymm1, 576(%rax)
	vmovdqu	%ymm14, 672(%rax)
	vmovdqu	%ymm2, 704(%rax)
	vmovdqu	%ymm3, 768(%rax)
	ret
.L_keccakf1600_opt$1:
	movq	(%rax), %rcx
	movq	80(%rax), %rbx
	movq	96(%rax), %rdx
	movq	144(%rax), %rsi
	movq	152(%rax), %r12
	movq	160(%rax), %rdi
	movq	168(%rax), %r11
	movq	176(%rax), %r8
	movq	192(%rax), %r9
	movq	$0, %r10
.L_keccakf1600_opt$2:
	movq	%r12, 8(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%r10, %mm3
	movq	%r11, 24(%rsp)
	movq	120(%rax), %r14
	xorq	%rdi, %r14
	movq	%rbx, %r10
	xorq	40(%rax), %r10
	xorq	%r14, %r10
	movq	128(%rax), %r13
	xorq	%r11, %r13
	movq	88(%rax), %r14
	movq	48(%rax), %r11
	xorq	%r11, %r14
	xorq	%r13, %r14
	movq	136(%rax), %r13
	xorq	%r8, %r13
	movq	%rdx, %rbx
	xorq	56(%rax), %rbx
	xorq	%r13, %rbx
	movq	%rsi, %r13
	xorq	184(%rax), %r13
	movq	104(%rax), %rbp
	xorq	64(%rax), %rbp
	xorq	%r13, %rbp
	xorq	%r9, %r12
	movq	112(%rax), %r15
	xorq	72(%rax), %r15
	xorq	%r12, %r15
	xorq	%rcx, %r10
	xorq	8(%rax), %r14
	xorq	16(%rax), %rbx
	movq	24(%rax), %r12
	xorq	%r12, %rbp
	xorq	32(%rax), %r15
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
	xorq	%r14, %rcx
	xorq	%rbx, %r11
	rorx	$20, %r11, %r11
	xorq	%r13, %rdx
	rorx	$21, %rdx, %rdx
	xorq	%r15, %rsi
	rorx	$43, %rsi, %r13
	xorq	%r10, %r9
	rorx	$50, %r9, %r9
	andnq	%rcx, %r9, %rsi
	xorq	%r13, %rsi
	movq	%rsi, 48(%rax)
	andnq	%r13, %rdx, %rsi
	andnq	%r9, %r13, %r13
	xorq	%rdx, %r13
	movq	%r13, 72(%rsp)
	andnq	%rdx, %r11, %rdx
	leaq	glob_data + 7408(%rip), %rbp
	movq	%mm3, %r13
	xorq	(%rbp,%r13,8), %rdx
	xorq	%rcx, %rdx
	xorq	%r11, %rsi
	movq	%rsi, 56(%rsp)
	andnq	%r11, %rcx, %rcx
	xorq	%r9, %rcx
	movq	%rcx, 64(%rsp)
	xorq	%r15, %r12
	rorx	$36, %r12, %rcx
	movq	72(%rax), %rsi
	xorq	%r10, %rsi
	rorx	$44, %rsi, %rsi
	movq	16(%rsp), %r11
	movq	80(%rsp), %rbp
	xorq	%rbp, %r11
	rorx	$61, %r11, %r12
	movq	128(%rax), %r11
	movq	%rbx, %r9
	xorq	%rbx, %r11
	rorx	$19, %r11, %r13
	movq	88(%rsp), %r11
	xorq	%r11, %r8
	rorx	$3, %r8, %r8
	andnq	%rcx, %r8, %r14
	xorq	%r13, %r14
	movq	%r14, 16(%rsp)
	andnq	%r13, %r12, %r14
	andnq	%r8, %r13, %r13
	xorq	%r12, %r13
	movq	%r13, 48(%rsp)
	andnq	%r12, %rsi, %r12
	xorq	%rcx, %r12
	movq	%r12, 128(%rax)
	xorq	%rsi, %r14
	movq	%r14, 24(%rax)
	andnq	%rsi, %rcx, %rsi
	xorq	%r8, %rsi
	movq	%rsi, 72(%rax)
	movq	8(%rax), %rsi
	xorq	%rbx, %rsi
	rorx	$63, %rsi, %rsi
	movq	56(%rax), %r8
	xorq	%r11, %r8
	rorx	$58, %r8, %r8
	movq	104(%rax), %rcx
	xorq	%r15, %rcx
	rorx	$39, %rcx, %r14
	movq	8(%rsp), %rcx
	xorq	%r10, %rcx
	rorx	$56, %rcx, %rcx
	movq	%rbp, %rbx
	xorq	%rbp, %rdi
	rorx	$46, %rdi, %rdi
	andnq	%rsi, %rdi, %r12
	xorq	%rcx, %r12
	movq	%r12, 104(%rax)
	andnq	%rcx, %r14, %r12
	andnq	%rdi, %rcx, %rcx
	xorq	%r14, %rcx
	andnq	%r14, %r8, %r14
	xorq	%rsi, %r14
	movq	%r14, 56(%rax)
	xorq	%r8, %r12
	movq	%r12, 40(%rsp)
	andnq	%r8, %rsi, %rsi
	xorq	%rdi, %rsi
	movq	%rsi, 8(%rsp)
	movq	32(%rax), %rsi
	xorq	%r10, %rsi
	rorx	$37, %rsi, %r12
	movq	40(%rax), %r8
	xorq	%rbx, %r8
	rorx	$28, %r8, %r13
	movq	88(%rax), %rdi
	xorq	%r9, %rdi
	rorx	$54, %rdi, %rdi
	movq	136(%rax), %rsi
	xorq	%r11, %rsi
	rorx	$49, %rsi, %r14
	movq	184(%rax), %rsi
	xorq	%r15, %rsi
	rorx	$8, %rsi, %rbp
	andnq	%r12, %rbp, %rsi
	xorq	%r14, %rsi
	andnq	%r14, %rdi, %r8
	andnq	%rbp, %r14, %r14
	xorq	%rdi, %r14
	movq	%r14, 136(%rax)
	andnq	%rdi, %r13, %rdi
	xorq	%r12, %rdi
	movq	%rdi, 184(%rax)
	xorq	%r13, %r8
	movq	%r8, 40(%rax)
	andnq	%r13, %r12, %r12
	xorq	%rbp, %r12
	movq	%r12, 88(%rax)
	xorq	16(%rax), %r11
	xorq	64(%rax), %r15
	xorq	112(%rax), %r10
	xorq	120(%rax), %rbx
	xorq	24(%rsp), %r9
	rorx	$2, %r11, %r11
	rorx	$9, %r15, %r13
	rorx	$25, %r10, %r10
	rorx	$23, %rbx, %rbx
	rorx	$62, %r9, %r15
	andnq	%r11, %r15, %r14
	xorq	%rbx, %r14
	movq	%r14, 120(%rax)
	andnq	%rbx, %r10, %r9
	andnq	%r15, %rbx, %r12
	xorq	%r10, %r12
	andnq	%r10, %r13, %rbp
	xorq	%r11, %rbp
	movq	%rbp, %r10
	movq	%rbp, 112(%rax)
	xorq	%r13, %r9
	movq	%r9, 24(%rsp)
	andnq	%r13, %r11, %rbx
	xorq	%r15, %rbx
	xorq	56(%rax), %rdi
	movq	128(%rax), %r11
	xorq	%r10, %r11
	xorq	%rdi, %r11
	movq	24(%rax), %rbp
	movq	%rbp, %rdi
	xorq	56(%rsp), %rdi
	movq	%r8, %r13
	xorq	40(%rsp), %r13
	xorq	%rdi, %r13
	movq	48(%rsp), %rdi
	xorq	136(%rax), %rdi
	movq	%r12, %r10
	xorq	72(%rsp), %r10
	xorq	%rdi, %r10
	movq	104(%rax), %r8
	xorq	16(%rsp), %r8
	xorq	48(%rax), %r14
	xorq	%r8, %r14
	movq	64(%rsp), %r8
	xorq	%rbx, %r8
	movq	8(%rsp), %rdi
	xorq	72(%rax), %rdi
	xorq	%r8, %rdi
	xorq	%rdx, %r11
	xorq	%r9, %r13
	xorq	%rcx, %r10
	xorq	%rsi, %r14
	movq	88(%rax), %r15
	xorq	%r15, %rdi
	rorx	$63, %r14, %r8
	xorq	%r13, %r8
	rorx	$63, %r13, %r9
	xorq	%rdi, %r9
	rorx	$63, %rdi, %rdi
	xorq	%r10, %rdi
	rorx	$63, %r10, %r10
	xorq	%r11, %r10
	rorx	$63, %r11, %r11
	xorq	%r14, %r11
	xorq	%r9, %rdx
	xorq	%r10, %rbp
	rorx	$20, %rbp, %rbp
	xorq	%r8, %rcx
	rorx	$21, %rcx, %rcx
	xorq	%rdi, %rsi
	rorx	$43, %rsi, %rsi
	xorq	%r11, %rbx
	rorx	$50, %rbx, %rbx
	andnq	%rdx, %rbx, %r13
	xorq	%rsi, %r13
	movq	%r13, 24(%rax)
	andnq	%rsi, %rcx, %r13
	andnq	%rbx, %rsi, %rsi
	xorq	%rcx, %rsi
	movq	%rsi, 16(%rax)
	andnq	%rcx, %rbp, %rcx
	movq	%mm3, %rsi
	leaq	glob_data + 7408(%rip), %r14
	xorq	8(%r14,%rsi,8), %rcx
	xorq	%rdx, %rcx
	movq	%rcx, 80(%rsp)
	xorq	%rbp, %r13
	movq	%r13, 8(%rax)
	andnq	%rbp, %rdx, %rcx
	xorq	%rbx, %rcx
	movq	%rcx, 32(%rax)
	movq	48(%rax), %rcx
	xorq	%rdi, %rcx
	rorx	$36, %rcx, %rcx
	movq	72(%rax), %rdx
	xorq	%r11, %rdx
	rorx	$44, %rdx, %rdx
	movq	56(%rax), %rsi
	xorq	%r9, %rsi
	rorx	$61, %rsi, %rsi
	movq	40(%rax), %rbx
	xorq	%r10, %rbx
	rorx	$19, %rbx, %rbx
	xorq	%r8, %r12
	rorx	$3, %r12, %r13
	andnq	%rcx, %r13, %r12
	xorq	%rbx, %r12
	movq	%r12, 64(%rax)
	andnq	%rbx, %rsi, %r12
	andnq	%r13, %rbx, %rbx
	xorq	%rsi, %rbx
	movq	%rbx, 56(%rax)
	andnq	%rsi, %rdx, %rsi
	xorq	%rcx, %rsi
	movq	%rsi, 40(%rax)
	xorq	%rdx, %r12
	movq	%r12, 48(%rax)
	andnq	%rdx, %rcx, %rcx
	xorq	%r13, %rcx
	movq	%rcx, 72(%rax)
	movq	56(%rsp), %rcx
	xorq	%r10, %rcx
	rorx	$63, %rcx, %rcx
	movq	48(%rsp), %rdx
	xorq	%r8, %rdx
	rorx	$58, %rdx, %rsi
	movq	104(%rax), %rdx
	xorq	%rdi, %rdx
	rorx	$39, %rdx, %r12
	xorq	%r11, %r15
	rorx	$56, %r15, %rdx
	movq	112(%rax), %r13
	xorq	%r9, %r13
	rorx	$46, %r13, %r13
	andnq	%rcx, %r13, %rbx
	xorq	%rdx, %rbx
	movq	%rbx, 104(%rax)
	andnq	%rdx, %r12, %r14
	andnq	%r13, %rdx, %rdx
	xorq	%r12, %rdx
	andnq	%r12, %rsi, %rbx
	xorq	%rcx, %rbx
	xorq	%rsi, %r14
	movq	%r14, 88(%rax)
	andnq	%rsi, %rcx, %rcx
	xorq	%r13, %rcx
	movq	%rcx, 112(%rax)
	movq	64(%rsp), %rcx
	xorq	%r11, %rcx
	rorx	$37, %rcx, %rbp
	movq	128(%rax), %rcx
	xorq	%r9, %rcx
	rorx	$28, %rcx, %r14
	movq	40(%rsp), %rsi
	xorq	%r10, %rsi
	rorx	$54, %rsi, %r12
	movq	136(%rax), %rsi
	xorq	%r8, %rsi
	rorx	$49, %rsi, %r15
	movq	120(%rax), %rsi
	xorq	%rdi, %rsi
	rorx	$8, %rsi, %rcx
	andnq	%rbp, %rcx, %rsi
	xorq	%r15, %rsi
	andnq	%r15, %r12, %r13
	andnq	%rcx, %r15, %r15
	xorq	%r12, %r15
	movq	%r15, 136(%rax)
	andnq	%r12, %r14, %r12
	xorq	%rbp, %r12
	movq	%r12, 120(%rax)
	xorq	%r14, %r13
	movq	%r13, 128(%rax)
	andnq	%r14, %rbp, %r12
	xorq	%rcx, %r12
	xorq	72(%rsp), %r8
	xorq	16(%rsp), %rdi
	xorq	8(%rsp), %r11
	xorq	184(%rax), %r9
	xorq	24(%rsp), %r10
	rorx	$2, %r8, %rcx
	rorx	$9, %rdi, %r14
	rorx	$25, %r11, %rdi
	rorx	$23, %r9, %r8
	rorx	$62, %r10, %r10
	andnq	%rcx, %r10, %r9
	xorq	%r8, %r9
	movq	%r9, 184(%rax)
	andnq	%r8, %rdi, %r11
	andnq	%r10, %r8, %r8
	xorq	%rdi, %r8
	andnq	%rdi, %r14, %rdi
	xorq	%rcx, %rdi
	xorq	%r14, %r11
	andnq	%r14, %rcx, %r9
	xorq	%r10, %r9
	movq	%mm3, %rcx
	addq	$2, %rcx
	movq	%rcx, %r10
	movq	80(%rsp), %rcx
	cmpq	$24, %r10
	jb  	.L_keccakf1600_opt$2
	movq	%rcx, (%rax)
	movq	%rbx, 80(%rax)
	movq	%rdx, 96(%rax)
	movq	%rsi, 144(%rax)
	movq	%r12, 152(%rax)
	movq	%rdi, 160(%rax)
	movq	%r11, 168(%rax)
	movq	%r8, 176(%rax)
	movq	%r9, 192(%rax)
	ret
.Lpolynomial__invert_ntt_montgomery$1:
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm8
	vmovdqu	64(%rsi), %ymm4
	vmovdqu	96(%rsi), %ymm5
	vmovdqu	128(%rsi), %ymm6
	vmovdqu	160(%rsi), %ymm7
	vmovdqu	192(%rsi), %ymm0
	vmovdqu	224(%rsi), %ymm1
	vmovdqu	glob_data + 1632(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm9
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm8
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm8, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpshufd	$216, %ymm8, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 1664(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1696(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpshufd	$216, %ymm8, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 1728(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpshufd	$216, %ymm8, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 1120(%rip), %ymm8
	vpunpcklqdq	%ymm3, %ymm2, %ymm9
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1152(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1184(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm11, %ymm6
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1216(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm11
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 608(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 640(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 672(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 704(%rip), %ymm7
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm7
	vperm2i128	$32, %ymm7, %ymm0, %ymm1
	vperm2i128	$49, %ymm7, %ymm0, %ymm7
	movl	glob_data + 7656(%rip), %r8d
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm9
	vpsubd	%ymm2, %ymm3, %ymm0
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm2
	movl	glob_data + 7660(%rip), %r8d
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm9
	vpsubd	%ymm4, %ymm5, %ymm0
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm4
	movl	glob_data + 7664(%rip), %r8d
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm9
	vpsubd	%ymm8, %ymm6, %ymm0
	vpaddd	%ymm6, %ymm8, %ymm6
	vmovshdup	%ymm0, %ymm8
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7668(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm9
	vpaddd	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	movl	glob_data + 7624(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm4, %ymm9
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	movl	glob_data + 7628(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm6, %ymm6
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm1, %ymm9, %ymm1
	vpsubd	%ymm0, %ymm7, %ymm9
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm2, 32(%rsi)
	vmovdqu	%ymm5, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	%ymm6, 128(%rsi)
	vmovdqu	%ymm0, 160(%rsi)
	vmovdqu	%ymm1, 192(%rsi)
	vmovdqu	%ymm7, 224(%rsi)
	vmovdqu	256(%rsi), %ymm2
	vmovdqu	288(%rsi), %ymm8
	vmovdqu	320(%rsi), %ymm4
	vmovdqu	352(%rsi), %ymm5
	vmovdqu	384(%rsi), %ymm6
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	448(%rsi), %ymm0
	vmovdqu	480(%rsi), %ymm1
	vmovdqu	glob_data + 1760(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm9
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm8
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm8, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpshufd	$216, %ymm8, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 1792(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1824(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpshufd	$216, %ymm8, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 1856(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpshufd	$216, %ymm8, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 1248(%rip), %ymm8
	vpunpcklqdq	%ymm3, %ymm2, %ymm9
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1280(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1312(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm11, %ymm6
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1344(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm11
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 736(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 768(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 800(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 832(%rip), %ymm7
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm7
	vperm2i128	$32, %ymm7, %ymm0, %ymm1
	vperm2i128	$49, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7672(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm2, %ymm9, %ymm2
	movl	glob_data + 7676(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm7
	movl	glob_data + 7680(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm6, %ymm4
	vpaddd	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm4
	movl	glob_data + 7684(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm1, %ymm9, %ymm1
	movl	glob_data + 7632(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm9
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm6, %ymm9, %ymm6
	movl	glob_data + 7636(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm8, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm8, %ymm0
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm8, %ymm9, %ymm8
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm2, 288(%rsi)
	vmovdqu	%ymm5, 320(%rsi)
	vmovdqu	%ymm6, 352(%rsi)
	vmovdqu	%ymm0, 384(%rsi)
	vmovdqu	%ymm1, 416(%rsi)
	vmovdqu	%ymm8, 448(%rsi)
	vmovdqu	%ymm4, 480(%rsi)
	vmovdqu	512(%rsi), %ymm2
	vmovdqu	544(%rsi), %ymm8
	vmovdqu	576(%rsi), %ymm4
	vmovdqu	608(%rsi), %ymm5
	vmovdqu	640(%rsi), %ymm6
	vmovdqu	672(%rsi), %ymm7
	vmovdqu	704(%rsi), %ymm0
	vmovdqu	736(%rsi), %ymm1
	vmovdqu	glob_data + 1888(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm9
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm8
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm8, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpshufd	$216, %ymm8, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 1920(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1952(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpshufd	$216, %ymm8, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 1984(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpshufd	$216, %ymm8, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 1376(%rip), %ymm8
	vpunpcklqdq	%ymm3, %ymm2, %ymm9
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1408(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1440(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm11, %ymm6
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1472(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm11
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 864(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 896(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 928(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 960(%rip), %ymm7
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm7
	vperm2i128	$32, %ymm7, %ymm0, %ymm1
	vperm2i128	$49, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7688(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm2, %ymm9, %ymm2
	movl	glob_data + 7692(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm7
	movl	glob_data + 7696(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm6, %ymm4
	vpaddd	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm4
	movl	glob_data + 7700(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm1, %ymm9, %ymm1
	movl	glob_data + 7640(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm9
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm6, %ymm9, %ymm6
	movl	glob_data + 7644(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm8, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm8, %ymm0
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm8, %ymm9, %ymm8
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	vmovdqu	%ymm3, 512(%rsi)
	vmovdqu	%ymm2, 544(%rsi)
	vmovdqu	%ymm5, 576(%rsi)
	vmovdqu	%ymm6, 608(%rsi)
	vmovdqu	%ymm0, 640(%rsi)
	vmovdqu	%ymm1, 672(%rsi)
	vmovdqu	%ymm8, 704(%rsi)
	vmovdqu	%ymm4, 736(%rsi)
	vmovdqu	768(%rsi), %ymm2
	vmovdqu	800(%rsi), %ymm8
	vmovdqu	832(%rsi), %ymm4
	vmovdqu	864(%rsi), %ymm5
	vmovdqu	896(%rsi), %ymm6
	vmovdqu	928(%rsi), %ymm7
	vmovdqu	960(%rsi), %ymm0
	vmovdqu	992(%rsi), %ymm1
	vmovdqu	glob_data + 2016(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm9
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm8
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm8, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpshufd	$216, %ymm8, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 2048(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 2080(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpshufd	$216, %ymm8, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 2112(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpshufd	$216, %ymm8, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 1504(%rip), %ymm8
	vpunpcklqdq	%ymm3, %ymm2, %ymm9
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1536(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1568(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm11, %ymm6
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1600(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm11
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 992(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1024(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1056(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm11
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 1088(%rip), %ymm7
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm7
	vperm2i128	$32, %ymm7, %ymm0, %ymm1
	vperm2i128	$49, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7704(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm2, %ymm9, %ymm2
	movl	glob_data + 7708(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm7
	movl	glob_data + 7712(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm6, %ymm4
	vpaddd	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm4
	movl	glob_data + 7716(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm1, %ymm9, %ymm1
	movl	glob_data + 7648(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm9
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm6, %ymm9, %ymm6
	movl	glob_data + 7652(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm8, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm8, %ymm0
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm8, %ymm9, %ymm8
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	vmovdqu	%ymm3, 768(%rsi)
	vmovdqu	%ymm2, 800(%rsi)
	vmovdqu	%ymm5, 832(%rsi)
	vmovdqu	%ymm6, 864(%rsi)
	vmovdqu	%ymm0, 896(%rsi)
	vmovdqu	%ymm1, 928(%rsi)
	vmovdqu	%ymm8, 960(%rsi)
	vmovdqu	%ymm4, 992(%rsi)
	vmovdqu	(%rsi), %ymm2
	vmovdqu	128(%rsi), %ymm6
	vmovdqu	256(%rsi), %ymm0
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	512(%rsi), %ymm3
	vmovdqu	640(%rsi), %ymm4
	vmovdqu	768(%rsi), %ymm8
	vmovdqu	896(%rsi), %ymm5
	movl	glob_data + 7608(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm2, %ymm6
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm2, %ymm9, %ymm2
	movl	glob_data + 7612(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm0, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm1, %ymm9, %ymm7
	movl	glob_data + 7616(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm11
	vpaddd	%ymm4, %ymm3, %ymm9
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm11, %ymm1
	vpmuldq	%ymm10, %ymm4, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm4
	movl	glob_data + 7620(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm8, %ymm5, %ymm3
	vpaddd	%ymm5, %ymm8, %ymm5
	vmovshdup	%ymm3, %ymm8
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm8
	movl	glob_data + 7600(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm3
	vpsubd	%ymm6, %ymm0, %ymm1
	vpaddd	%ymm0, %ymm6, %ymm0
	vmovshdup	%ymm1, %ymm6
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpsubd	%ymm2, %ymm7, %ymm6
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm7
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm6, %ymm3
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm3
	movl	glob_data + 7604(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm9, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm9, %ymm9
	vmovshdup	%ymm11, %ymm5
	vmovshdup	%ymm6, %ymm7
	vpmuldq	%ymm6, %ymm11, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm7, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm5, %ymm10, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm11
	vpaddd	%ymm8, %ymm4, %ymm10
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm6, %ymm7
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm7, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm7
	movl	$41978, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm0, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm0, %ymm8
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm9, %ymm8, %ymm8
	vpsubd	%ymm2, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm2, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm10, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm1, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm10, %ymm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm11
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm11, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm11, %ymm7
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm4
	vmovshdup	%ymm3, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm3
	vmovdqu	%ymm8, (%rsi)
	vmovdqu	%ymm9, 128(%rsi)
	vmovdqu	%ymm1, 256(%rsi)
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	%ymm0, 512(%rsi)
	vmovdqu	%ymm2, 640(%rsi)
	vmovdqu	%ymm5, 768(%rsi)
	vmovdqu	%ymm4, 896(%rsi)
	vmovdqu	32(%rsi), %ymm0
	vmovdqu	160(%rsi), %ymm7
	vmovdqu	288(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vmovdqu	544(%rsi), %ymm3
	vmovdqu	672(%rsi), %ymm4
	vmovdqu	800(%rsi), %ymm6
	vmovdqu	928(%rsi), %ymm5
	movl	glob_data + 7608(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm9
	vpsubd	%ymm0, %ymm7, %ymm11
	vpaddd	%ymm7, %ymm0, %ymm8
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7612(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm1, %ymm2, %ymm9
	vpaddd	%ymm2, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm2, %ymm7, %ymm7
	movl	glob_data + 7616(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm9
	vpsubd	%ymm3, %ymm4, %ymm2
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm2
	movl	glob_data + 7620(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm6, %ymm5, %ymm4
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	movl	glob_data + 7600(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm1, %ymm11
	vpaddd	%ymm1, %ymm8, %ymm4
	vmovshdup	%ymm11, %ymm1
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm11, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm8, %ymm8
	vpsubd	%ymm0, %ymm7, %ymm1
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	movl	glob_data + 7604(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm3, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm3, %ymm9
	vmovshdup	%ymm11, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm11, %ymm3
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm2, %ymm6, %ymm5
	vpaddd	%ymm6, %ymm2, %ymm10
	vmovshdup	%ymm5, %ymm2
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm2, %ymm5, %ymm2
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm5
	movl	$41978, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm4, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm4, %ymm9
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm4
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm0, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm0, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm8, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm8, %ymm3
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm8
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm1, %ymm2, %ymm11
	vpaddd	%ymm2, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm2
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm11, %ymm5
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm2, %ymm5, %ymm2
	vmovshdup	%ymm1, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vmovdqu	%ymm7, 32(%rsi)
	vmovdqu	%ymm9, 160(%rsi)
	vmovdqu	%ymm3, 288(%rsi)
	vmovdqu	%ymm5, 416(%rsi)
	vmovdqu	%ymm4, 544(%rsi)
	vmovdqu	%ymm0, 672(%rsi)
	vmovdqu	%ymm8, 800(%rsi)
	vmovdqu	%ymm2, 928(%rsi)
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	192(%rsi), %ymm7
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	448(%rsi), %ymm2
	vmovdqu	576(%rsi), %ymm3
	vmovdqu	704(%rsi), %ymm4
	vmovdqu	832(%rsi), %ymm6
	vmovdqu	960(%rsi), %ymm5
	movl	glob_data + 7608(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm9
	vpsubd	%ymm0, %ymm7, %ymm11
	vpaddd	%ymm7, %ymm0, %ymm8
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7612(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm1, %ymm2, %ymm9
	vpaddd	%ymm2, %ymm1, %ymm2
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm1, %ymm1
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm1, %ymm7, %ymm7
	movl	glob_data + 7616(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm9
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm9, %ymm1
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm4, %ymm1, %ymm1
	movl	glob_data + 7620(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm6, %ymm5, %ymm4
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	movl	glob_data + 7600(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm2, %ymm4
	vpaddd	%ymm2, %ymm8, %ymm2
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm8, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm7, %ymm8
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	movl	glob_data + 7604(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm3, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm3, %ymm9
	vmovshdup	%ymm11, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm11, %ymm3
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm1, %ymm6, %ymm5
	vpaddd	%ymm6, %ymm1, %ymm10
	vmovshdup	%ymm5, %ymm1
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm12, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm1, %ymm5, %ymm1
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm5
	movl	$41978, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm2, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm9
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm0, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm0, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm4, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm4, %ymm3
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm4
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm10, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm8, %ymm1, %ymm11
	vpaddd	%ymm1, %ymm8, %ymm1
	vmovshdup	%ymm11, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm11, %ymm5
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm7, 64(%rsi)
	vmovdqu	%ymm9, 192(%rsi)
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm2, 576(%rsi)
	vmovdqu	%ymm0, 704(%rsi)
	vmovdqu	%ymm4, 832(%rsi)
	vmovdqu	%ymm5, 960(%rsi)
	vmovdqu	96(%rsi), %ymm0
	vmovdqu	224(%rsi), %ymm7
	vmovdqu	352(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vmovdqu	608(%rsi), %ymm3
	vmovdqu	736(%rsi), %ymm4
	vmovdqu	864(%rsi), %ymm6
	vmovdqu	992(%rsi), %ymm5
	movl	glob_data + 7608(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm9
	vpsubd	%ymm0, %ymm7, %ymm11
	vpaddd	%ymm7, %ymm0, %ymm8
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm11, %ymm0
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	movl	glob_data + 7612(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm1, %ymm2, %ymm9
	vpaddd	%ymm2, %ymm1, %ymm2
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm1, %ymm1
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm1, %ymm7, %ymm7
	movl	glob_data + 7616(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm9
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm9, %ymm1
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm4, %ymm1, %ymm1
	movl	glob_data + 7620(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm6, %ymm5, %ymm4
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	movl	glob_data + 7600(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm9
	vpsubd	%ymm8, %ymm2, %ymm4
	vpaddd	%ymm2, %ymm8, %ymm2
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm8, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm7, %ymm8
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	movl	glob_data + 7604(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm3, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm3, %ymm9
	vmovshdup	%ymm11, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm11, %ymm3
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm1, %ymm6, %ymm5
	vpaddd	%ymm6, %ymm1, %ymm10
	vmovshdup	%ymm5, %ymm1
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm12, %ymm1, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm1, %ymm1
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm1, %ymm5, %ymm1
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm5
	movl	$41978, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm2, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm2, %ymm9
	vmovshdup	%ymm11, %ymm7
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm0, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm0, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm4, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm4, %ymm3
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm5, %ymm12
	vpmuldq	%ymm5, %ymm11, %ymm4
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm10, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm8, %ymm1, %ymm11
	vpaddd	%ymm1, %ymm8, %ymm1
	vmovshdup	%ymm11, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm11, %ymm5
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm7, 96(%rsi)
	vmovdqu	%ymm9, 224(%rsi)
	vmovdqu	%ymm3, 352(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	%ymm2, 608(%rsi)
	vmovdqu	%ymm0, 736(%rsi)
	vmovdqu	%ymm4, 864(%rsi)
	vmovdqu	%ymm5, 992(%rsi)
	ret
.Lpolynomial__ntt$1:
	vmovdqu	(%rsi), %ymm1
	vmovdqu	128(%rsi), %ymm3
	vmovdqu	256(%rsi), %ymm8
	vmovdqu	384(%rsi), %ymm9
	vmovdqu	512(%rsi), %ymm0
	vmovdqu	640(%rsi), %ymm2
	vmovdqu	768(%rsi), %ymm6
	vmovdqu	896(%rsi), %ymm5
	movq	$25847, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm4
	vpsubd	%ymm4, %ymm1, %ymm0
	vpaddd	%ymm4, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm2
	vpaddd	%ymm4, %ymm3, %ymm4
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm8, %ymm6
	vpaddd	%ymm3, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm5
	vpsubd	%ymm5, %ymm9, %ymm3
	vpaddd	%ymm5, %ymm9, %ymm5
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm9, %ymm8, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm8
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm6, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm4, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm0, %ymm4
	vpaddd	%ymm6, %ymm0, %ymm0
	vmovshdup	%ymm3, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm3
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm7
	vmovdqu	glob_data + 2176(%rip), %ymm1
	vmovshdup	%ymm5, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm5, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm8, %ymm1
	vmovdqu	glob_data + 2208(%rip), %ymm5
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm2
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm5
	vmovshdup	%ymm3, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm7, (%rsi)
	vmovdqu	%ymm9, 128(%rsi)
	vmovdqu	%ymm1, 256(%rsi)
	vmovdqu	%ymm6, 384(%rsi)
	vmovdqu	%ymm0, 512(%rsi)
	vmovdqu	%ymm2, 640(%rsi)
	vmovdqu	%ymm4, 768(%rsi)
	vmovdqu	%ymm5, 896(%rsi)
	vmovdqu	32(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm3
	vmovdqu	288(%rsi), %ymm6
	vmovdqu	416(%rsi), %ymm8
	vmovdqu	544(%rsi), %ymm0
	vmovdqu	672(%rsi), %ymm2
	vmovdqu	800(%rsi), %ymm5
	vmovdqu	928(%rsi), %ymm9
	movq	$25847, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm4
	vpsubd	%ymm4, %ymm1, %ymm0
	vpaddd	%ymm4, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm2
	vpaddd	%ymm4, %ymm3, %ymm4
	vmovshdup	%ymm5, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm5
	vpsubd	%ymm5, %ymm6, %ymm3
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm8, %ymm6
	vpaddd	%ymm9, %ymm8, %ymm9
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm5, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm8
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm3, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm4
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm3
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm7
	vmovdqu	glob_data + 2176(%rip), %ymm1
	vmovshdup	%ymm5, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm5, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm8, %ymm1
	vmovdqu	glob_data + 2208(%rip), %ymm5
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm2
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm5
	vmovshdup	%ymm3, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm7, 32(%rsi)
	vmovdqu	%ymm9, 160(%rsi)
	vmovdqu	%ymm1, 288(%rsi)
	vmovdqu	%ymm6, 416(%rsi)
	vmovdqu	%ymm0, 544(%rsi)
	vmovdqu	%ymm2, 672(%rsi)
	vmovdqu	%ymm4, 800(%rsi)
	vmovdqu	%ymm5, 928(%rsi)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	192(%rsi), %ymm3
	vmovdqu	320(%rsi), %ymm6
	vmovdqu	448(%rsi), %ymm8
	vmovdqu	576(%rsi), %ymm0
	vmovdqu	704(%rsi), %ymm2
	vmovdqu	832(%rsi), %ymm5
	vmovdqu	960(%rsi), %ymm9
	movq	$25847, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm4
	vpsubd	%ymm4, %ymm1, %ymm0
	vpaddd	%ymm4, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm2
	vpaddd	%ymm4, %ymm3, %ymm4
	vmovshdup	%ymm5, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm5
	vpsubd	%ymm5, %ymm6, %ymm3
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm8, %ymm6
	vpaddd	%ymm9, %ymm8, %ymm9
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm5, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm8
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm3, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm4
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm3
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm7
	vmovdqu	glob_data + 2176(%rip), %ymm1
	vmovshdup	%ymm5, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm5, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm8, %ymm1
	vmovdqu	glob_data + 2208(%rip), %ymm5
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm2
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm5
	vmovshdup	%ymm3, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm7, 64(%rsi)
	vmovdqu	%ymm9, 192(%rsi)
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm0, 576(%rsi)
	vmovdqu	%ymm2, 704(%rsi)
	vmovdqu	%ymm4, 832(%rsi)
	vmovdqu	%ymm5, 960(%rsi)
	vmovdqu	96(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	352(%rsi), %ymm6
	vmovdqu	480(%rsi), %ymm8
	vmovdqu	608(%rsi), %ymm0
	vmovdqu	736(%rsi), %ymm2
	vmovdqu	864(%rsi), %ymm5
	vmovdqu	992(%rsi), %ymm9
	movq	$25847, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm4
	vpsubd	%ymm4, %ymm1, %ymm0
	vpaddd	%ymm4, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm2
	vpaddd	%ymm4, %ymm3, %ymm4
	vmovshdup	%ymm5, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm5, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm5
	vpsubd	%ymm5, %ymm6, %ymm3
	vpaddd	%ymm5, %ymm6, %ymm5
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm8, %ymm6
	vpaddd	%ymm9, %ymm8, %ymm9
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm5, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm8
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm7
	vmovshdup	%ymm3, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm4
	vpaddd	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm3
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm7
	vmovdqu	glob_data + 2176(%rip), %ymm1
	vmovshdup	%ymm5, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm5, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm8, %ymm1
	vmovdqu	glob_data + 2208(%rip), %ymm5
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm2
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm5
	vmovshdup	%ymm3, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm7, 96(%rsi)
	vmovdqu	%ymm9, 224(%rsi)
	vmovdqu	%ymm1, 352(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	%ymm0, 608(%rsi)
	vmovdqu	%ymm2, 736(%rsi)
	vmovdqu	%ymm4, 864(%rsi)
	vmovdqu	%ymm5, 992(%rsi)
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm3
	vmovdqu	128(%rsi), %ymm4
	vmovdqu	160(%rsi), %ymm6
	vmovdqu	192(%rsi), %ymm5
	vmovdqu	224(%rsi), %ymm8
	vmovdqu	glob_data + 2272(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm3
	vpaddd	%ymm9, %ymm2, %ymm9
	vmovdqu	glob_data + 2304(%rip), %ymm7
	vmovshdup	%ymm5, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm2, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm2
	vpaddd	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm6, %ymm5
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 2528(%rip), %ymm7
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm7
	vpaddd	%ymm9, %ymm1, %ymm8
	vmovdqu	glob_data + 2560(%rip), %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm1
	vpaddd	%ymm3, %ymm0, %ymm9
	vmovdqu	glob_data + 2592(%rip), %ymm3
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm3
	vpaddd	%ymm6, %ymm4, %ymm0
	vmovdqu	glob_data + 2624(%rip), %ymm6
	vmovshdup	%ymm5, %ymm4
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm4, %ymm5, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3040(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm8, %ymm4
	vperm2i128	$49, %ymm7, %ymm8, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3072(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm9, %ymm7
	vperm2i128	$49, %ymm1, %ymm9, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3104(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3136(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm2
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3552(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm9
	vpsubd	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 3584(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 3616(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3648(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm2, %ymm8
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm2
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4064(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm9
	vpshufd	$216, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovshdup	%ymm6, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm4
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm6, %ymm9
	vmovdqu	glob_data + 4096(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm7
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm1
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm6, %ymm6
	vmovdqu	glob_data + 4128(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm8, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm0
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm10
	vmovdqu	glob_data + 4160(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm12, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm3
	vpsubd	%ymm2, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm2
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm2, %ymm5
	vpshufd	$216, %ymm3, %ymm2
	vmovdqu	%ymm4, (%rsi)
	vmovdqu	%ymm9, 32(%rsi)
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	%ymm6, 96(%rsi)
	vmovdqu	%ymm0, 128(%rsi)
	vmovdqu	%ymm10, 160(%rsi)
	vmovdqu	%ymm5, 192(%rsi)
	vmovdqu	%ymm2, 224(%rsi)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vmovdqu	320(%rsi), %ymm0
	vmovdqu	352(%rsi), %ymm3
	vmovdqu	384(%rsi), %ymm4
	vmovdqu	416(%rsi), %ymm6
	vmovdqu	448(%rsi), %ymm5
	vmovdqu	480(%rsi), %ymm8
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm9, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm6, %ymm7
	vpaddd	%ymm9, %ymm6, %ymm10
	vmovdqu	glob_data + 2656(%rip), %ymm6
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm12, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm8
	vmovdqu	glob_data + 2688(%rip), %ymm1
	vmovshdup	%ymm3, %ymm2
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm1
	vpaddd	%ymm3, %ymm0, %ymm11
	vmovdqu	glob_data + 2720(%rip), %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm10, %ymm0
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm3
	vpaddd	%ymm6, %ymm4, %ymm0
	vmovdqu	glob_data + 2752(%rip), %ymm6
	vmovshdup	%ymm7, %ymm2
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm7, %ymm4
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm2, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm5, %ymm6
	vpaddd	%ymm4, %ymm5, %ymm2
	vmovdqu	glob_data + 3168(%rip), %ymm5
	vperm2i128	$32, %ymm9, %ymm8, %ymm4
	vperm2i128	$49, %ymm9, %ymm8, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm8, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm4, %ymm7
	vpsubd	%ymm5, %ymm4, %ymm8
	vperm2i128	$32, %ymm8, %ymm7, %ymm4
	vperm2i128	$49, %ymm8, %ymm7, %ymm5
	vmovdqu	glob_data + 3200(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm11, %ymm7
	vperm2i128	$49, %ymm1, %ymm11, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3232(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3264(%rip), %ymm9
	vperm2i128	$32, %ymm6, %ymm2, %ymm8
	vperm2i128	$49, %ymm6, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm6
	vperm2i128	$32, %ymm6, %ymm9, %ymm2
	vperm2i128	$49, %ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 3680(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpaddd	%ymm5, %ymm8, %ymm9
	vpsubd	%ymm5, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm9, %ymm4
	vpunpckhqdq	%ymm8, %ymm9, %ymm5
	vmovdqu	glob_data + 3712(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 3744(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3776(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm2, %ymm8
	vpunpckhqdq	%ymm6, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm2
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 4192(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm9
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm9, %ymm4
	vpunpckhqdq	%ymm5, %ymm9, %ymm5
	vmovshdup	%ymm5, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm4, %ymm8
	vpsubd	%ymm5, %ymm4, %ymm4
	vpunpcklqdq	%ymm4, %ymm8, %ymm5
	vpunpckhqdq	%ymm4, %ymm8, %ymm8
	vpshufd	$216, %ymm5, %ymm4
	vpshufd	$216, %ymm8, %ymm9
	vmovdqu	glob_data + 4224(%rip), %ymm5
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm7
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm5
	vpsubd	%ymm1, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm5, %ymm1
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 4256(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm8, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm0
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm10
	vmovdqu	glob_data + 4288(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm2, %ymm7
	vpunpckhqdq	%ymm6, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm12, %ymm6, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm12
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm3
	vpsubd	%ymm2, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm3, %ymm2
	vpunpckhqdq	%ymm6, %ymm3, %ymm3
	vpshufd	$216, %ymm2, %ymm8
	vpshufd	$216, %ymm3, %ymm2
	vmovdqu	%ymm4, 256(%rsi)
	vmovdqu	%ymm9, 288(%rsi)
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	%ymm5, 352(%rsi)
	vmovdqu	%ymm0, 384(%rsi)
	vmovdqu	%ymm10, 416(%rsi)
	vmovdqu	%ymm8, 448(%rsi)
	vmovdqu	%ymm2, 480(%rsi)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vmovdqu	576(%rsi), %ymm0
	vmovdqu	608(%rsi), %ymm3
	vmovdqu	640(%rsi), %ymm4
	vmovdqu	672(%rsi), %ymm6
	vmovdqu	704(%rsi), %ymm5
	vmovdqu	736(%rsi), %ymm8
	vmovdqu	glob_data + 2400(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2432(%rip), %ymm7
	vmovshdup	%ymm5, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm2, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm2
	vpaddd	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm6, %ymm5
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 2784(%rip), %ymm7
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm7
	vpaddd	%ymm9, %ymm1, %ymm8
	vmovdqu	glob_data + 2816(%rip), %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm1
	vpaddd	%ymm3, %ymm0, %ymm9
	vmovdqu	glob_data + 2848(%rip), %ymm3
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm3
	vpaddd	%ymm6, %ymm4, %ymm0
	vmovdqu	glob_data + 2880(%rip), %ymm6
	vmovshdup	%ymm5, %ymm4
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm4, %ymm5, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3296(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm8, %ymm4
	vperm2i128	$49, %ymm7, %ymm8, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3328(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm9, %ymm7
	vperm2i128	$49, %ymm1, %ymm9, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3360(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3392(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm2
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3808(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm9
	vpsubd	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 3840(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 3872(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3904(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm2, %ymm8
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm2
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4320(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm9
	vpshufd	$216, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovshdup	%ymm6, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm4
	vpunpcklqdq	%ymm4, %ymm8, %ymm6
	vpunpckhqdq	%ymm4, %ymm8, %ymm8
	vpshufd	$216, %ymm6, %ymm4
	vpshufd	$216, %ymm8, %ymm9
	vmovdqu	glob_data + 4352(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm7
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm1
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm6, %ymm6
	vmovdqu	glob_data + 4384(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm8, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm0
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm10
	vmovdqu	glob_data + 4416(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm12, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm3
	vpsubd	%ymm2, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm2
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm2, %ymm5
	vpshufd	$216, %ymm3, %ymm2
	vmovdqu	%ymm4, 512(%rsi)
	vmovdqu	%ymm9, 544(%rsi)
	vmovdqu	%ymm1, 576(%rsi)
	vmovdqu	%ymm6, 608(%rsi)
	vmovdqu	%ymm0, 640(%rsi)
	vmovdqu	%ymm10, 672(%rsi)
	vmovdqu	%ymm5, 704(%rsi)
	vmovdqu	%ymm2, 736(%rsi)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vmovdqu	832(%rsi), %ymm0
	vmovdqu	864(%rsi), %ymm3
	vmovdqu	896(%rsi), %ymm4
	vmovdqu	928(%rsi), %ymm6
	vmovdqu	960(%rsi), %ymm5
	vmovdqu	992(%rsi), %ymm8
	vmovdqu	glob_data + 2464(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2496(%rip), %ymm7
	vmovshdup	%ymm5, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm2, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm2
	vpaddd	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm6, %ymm5
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 2912(%rip), %ymm7
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm10, %ymm8, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm7
	vpaddd	%ymm9, %ymm1, %ymm8
	vmovdqu	glob_data + 2944(%rip), %ymm1
	vmovshdup	%ymm3, %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm3
	vpsubd	%ymm3, %ymm0, %ymm1
	vpaddd	%ymm3, %ymm0, %ymm9
	vmovdqu	glob_data + 2976(%rip), %ymm3
	vmovshdup	%ymm6, %ymm10
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm3
	vpaddd	%ymm6, %ymm4, %ymm0
	vmovdqu	glob_data + 3008(%rip), %ymm6
	vmovshdup	%ymm5, %ymm4
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm5, %ymm5
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm4, %ymm5, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3424(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm8, %ymm4
	vperm2i128	$49, %ymm7, %ymm8, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3456(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm9, %ymm7
	vperm2i128	$49, %ymm1, %ymm9, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3488(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3520(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm2
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3936(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm9
	vpsubd	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 3968(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 4000(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm12
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 4032(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm2, %ymm8
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm2
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4448(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm9
	vpshufd	$216, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovshdup	%ymm6, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm4
	vpunpcklqdq	%ymm4, %ymm8, %ymm6
	vpunpckhqdq	%ymm4, %ymm8, %ymm8
	vpshufd	$216, %ymm6, %ymm4
	vpshufd	$216, %ymm8, %ymm9
	vmovdqu	glob_data + 4480(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm7
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm1
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm6, %ymm6
	vmovdqu	glob_data + 4512(%rip), %ymm8
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm8, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm0
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm10
	vmovdqu	glob_data + 4544(%rip), %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm12, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5056(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5056(%rip), %ymm5, %ymm5
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm3
	vpsubd	%ymm2, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm3, %ymm2
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vpshufd	$216, %ymm2, %ymm5
	vpshufd	$216, %ymm3, %ymm2
	vmovdqu	%ymm4, 768(%rsi)
	vmovdqu	%ymm9, 800(%rsi)
	vmovdqu	%ymm1, 832(%rsi)
	vmovdqu	%ymm6, 864(%rsi)
	vmovdqu	%ymm0, 896(%rsi)
	vmovdqu	%ymm10, 928(%rsi)
	vmovdqu	%ymm5, 960(%rsi)
	vmovdqu	%ymm2, 992(%rsi)
	ret
.Lpolynomial__reduce32$1:
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5056(%rip), %ymm1
	movq	$0, %r8
	jmp 	.Lpolynomial__reduce32$2
.Lpolynomial__reduce32$3:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsrad	$23, %ymm3, %ymm3
	vpmulld	%ymm1, %ymm3, %ymm3
	vpsubd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.Lpolynomial__reduce32$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__reduce32$3
	ret
.Lpolynomial__conditionally_add_modulus$1:
	vmovdqu	glob_data + 5056(%rip), %ymm1
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.Lpolynomial__conditionally_add_modulus$2
.Lpolynomial__conditionally_add_modulus$3:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpcmpgtd	%ymm2, %ymm0, %ymm5
	vpand	%ymm5, %ymm1, %ymm3
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.Lpolynomial__conditionally_add_modulus$2:
	cmpq	$1024, %rdx
	jb  	.Lpolynomial__conditionally_add_modulus$3
	ret
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1:
	movq	$0, %r8
	jmp 	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$3:
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm1, %ymm5
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm5, %ymm2, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm5
	vpmuldq	glob_data + 5056(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5056(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%r8)
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm1, %ymm5
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm5, %ymm2, %ymm1
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm5
	vpmuldq	glob_data + 5056(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5056(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%r8)
	addq	$32, %r8
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$3
	ret
.Lpolynomial__use_hints_gamma2_32$1:
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	glob_data + 4640(%rip), %ymm1
	leaq	1056(%rsp), %rdx
	leaq	32(%rsp), %rsi
	call	.Lpolynomial__decompose_gamma2_32$1
.Lpolynomial__use_hints_gamma2_32$4:
	movq	$0, %rdx
	jmp 	.Lpolynomial__use_hints_gamma2_32$2
.Lpolynomial__use_hints_gamma2_32$3:
	vmovdqu	1056(%rsp,%rdx), %ymm2
	vmovdqu	(%rcx,%rdx), %ymm3
	vpcmpeqd	%ymm0, %ymm2, %ymm4
	vpor	%ymm4, %ymm2, %ymm2
	vpsignd	%ymm2, %ymm3, %ymm3
	vmovdqu	32(%rsp,%rdx), %ymm2
	vpaddd	%ymm3, %ymm2, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vmovdqu	%ymm10, (%r9,%rdx)
	addq	$32, %rdx
.Lpolynomial__use_hints_gamma2_32$2:
	cmpq	$1024, %rdx
	jb  	.Lpolynomial__use_hints_gamma2_32$3
	ret
.Lpolynomial__decompose_gamma2_32$1:
	vmovdqu	glob_data + 5056(%rip), %ymm2
	vpsrld	$1, %ymm2, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vmovdqu	glob_data + 4640(%rip), %ymm5
	vmovdqu	glob_data + 4672(%rip), %ymm6
	vmovdqu	glob_data + 4704(%rip), %ymm7
	vmovdqu	glob_data + 4736(%rip), %ymm8
	vmovdqu	glob_data + 4768(%rip), %ymm9
	movq	$0, %r8
	jmp 	.Lpolynomial__decompose_gamma2_32$2
.Lpolynomial__decompose_gamma2_32$3:
	vmovdqu	(%r9,%r8), %ymm10
	vpcmpgtd	%ymm10, %ymm4, %ymm11
	vpand	%ymm2, %ymm11, %ymm11
	vpaddd	%ymm11, %ymm10, %ymm10
	vpaddd	%ymm8, %ymm10, %ymm11
	vpsrld	$7, %ymm11, %ymm11
	vpmulhuw	%ymm6, %ymm11, %ymm11
	vpmulhrsw	%ymm9, %ymm11, %ymm11
	vpand	%ymm5, %ymm11, %ymm11
	vpmulld	%ymm7, %ymm11, %ymm12
	vpsubd	%ymm12, %ymm10, %ymm12
	vpcmpgtd	%ymm3, %ymm12, %ymm10
	vpand	%ymm2, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm12, %ymm12
	vmovdqu	%ymm12, (%rdx,%r8)
	vmovdqu	%ymm11, (%rsi,%r8)
	addq	$32, %r8
.Lpolynomial__decompose_gamma2_32$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__decompose_gamma2_32$3
	ret
.Lgamma1__coefficients_to_bytestream_bits20$1:
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	glob_data + 4864(%rip), %ymm2
	vpsllvd	%ymm2, %ymm10, %ymm2
	vpsrlq	$12, %ymm2, %ymm2
	vmovdqu	glob_data + 4896(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vextracti128	$0, %ymm2, %xmm12
	vextracti128	$1, %ymm2, %xmm11
	ret
.Lerror_polynomial__decode_eta4$1:
	movq	$15, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$4, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqu	glob_data + 4960(%rip), %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpxor	%ymm10, %ymm10, %ymm10
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.Lerror_polynomial__decode_eta4$2
.Lerror_polynomial__decode_eta4$3:
	vmovdqu	(%rdx,%r8), %xmm4
	movq	$0, %rdi
	jmp 	.Lerror_polynomial__decode_eta4$4
.Lerror_polynomial__decode_eta4$5:
	vinserti128	$0, %xmm4, %ymm10, %ymm10
	vinserti128	$1, %xmm4, %ymm10, %ymm10
	vpshufb	%ymm2, %ymm10, %ymm10
	vpsrlvd	%ymm3, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax,%r11)
	addq	$32, %r11
	vpsrldq	$4, %xmm4, %xmm4
	incq	%rdi
.Lerror_polynomial__decode_eta4$4:
	cmpq	$4, %rdi
	jb  	.Lerror_polynomial__decode_eta4$5
	addq	$16, %r8
.Lerror_polynomial__decode_eta4$2:
	cmpq	$128, %r8
	jb  	.Lerror_polynomial__decode_eta4$3
	ret
.Lerror_polynomial__encode_eta4$1:
	movq	$4097, %r10
	vmovq	%r10, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	movq	$4, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vmovdqu	glob_data + 4992(%rip), %ymm2
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.Lerror_polynomial__encode_eta4$2
.Lerror_polynomial__encode_eta4$3:
	vmovdqu	(%rcx,%r8), %ymm3
	vpsubd	%ymm3, %ymm1, %ymm3
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm4
	vpsubd	%ymm4, %ymm1, %ymm4
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm5
	vpsubd	%ymm5, %ymm1, %ymm5
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm6
	vpsubd	%ymm6, %ymm1, %ymm6
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm7
	vpsubd	%ymm7, %ymm1, %ymm7
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm8
	vpsubd	%ymm8, %ymm1, %ymm8
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm9
	vpsubd	%ymm9, %ymm1, %ymm9
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm10
	vpsubd	%ymm10, %ymm1, %ymm10
	addq	$32, %r8
	vpackusdw	%ymm4, %ymm3, %ymm3
	vpackusdw	%ymm6, %ymm5, %ymm4
	vpackusdw	%ymm8, %ymm7, %ymm5
	vpackusdw	%ymm10, %ymm9, %ymm6
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpackuswb	%ymm6, %ymm5, %ymm4
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpackuswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpshufb	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx,%r11)
	addq	$32, %r11
.Lerror_polynomial__encode_eta4$2:
	cmpq	$128, %r11
	jb  	.Lerror_polynomial__encode_eta4$3
	ret
	.data
	.p2align	5
glob_data:
G$commitment__ENCODING_SHUFFLES_bits4:
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
G$t1__mask:
	.byte	255,   3,   0,   0, 255,   3,   0,   0, 255,   3,   0,   0, 255,   3,   0,   0
	.byte	255,   3,   0,   0, 255,   3,   0,   0, 255,   3,   0,   0, 255,   3,   0,   0
G$t1__DECODING_TABLE:
	.byte	  0,   1, 255, 255,   1,   2, 255, 255,   2,   3, 255, 255,   3,   4, 255, 255
	.byte	  5,   6, 255, 255,   6,   7, 255, 255,   7,   8, 255, 255,   8,   9, 255, 255
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   4,   0,   0,   0,   6,   0,   0,   0
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   4,   0,   0,   0,   6,   0,   0,   0
G$t1__ENCODING_SHIFTS_TABLE:
	.byte	 22,   0,   0,   0,   0,   0,   0,   0,  22,   0,   0,   0,   0,   0,   0,   0
	.byte	 22,   0,   0,   0,   0,   0,   0,   0,  22,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	.byte	  4,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	.byte	 12,   0,   0,   0,   0,   0,   0,   0,  12,   0,   0,   0,   0,   0,   0,   0
	.byte	 12,   0,   0,   0,   0,   0,   0,   0,  12,   0,   0,   0,   0,   0,   0,   0
G$t0__DECODING_TABLE:
	.byte	  0,   1, 255, 255,   1,   2,   3, 255,   3,   4, 255, 255,   4,   5,   6, 255
	.byte	  6,   7,   8, 255,   8,   9, 255, 255,   9,  10,  11, 255,  11,  12, 255, 255
	.byte	  0,   0,   0,   0,   5,   0,   0,   0,   2,   0,   0,   0,   7,   0,   0,   0
	.byte	  4,   0,   0,   0,   1,   0,   0,   0,   6,   0,   0,   0,   3,   0,   0,   0
	.byte	255,  31,   0,   0, 255,  31,   0,   0, 255,  31,   0,   0, 255,  31,   0,   0
	.byte	255,  31,   0,   0, 255,  31,   0,   0, 255,  31,   0,   0, 255,  31,   0,   0
G$t0__ENCODING_SHIFTS_TABLE:
	.byte	 19,   0,   0,   0,   0,   0,   0,   0,  19,   0,   0,   0,   0,   0,   0,   0
	.byte	 19,   0,   0,   0,   0,   0,   0,   0,  19,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   4,   0,   0,   0,   6,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	.byte	  6,   0,   0,   0,   0,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0,   0
	.byte	  6,   0,   0,   0,   0,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,  12,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
G$matrix_A__DECODING_TABLE:
	.byte	  0,   0,   0,   0,   1,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0
	.byte	  3,   0,   0,   0,   4,   0,   0,   0,   5,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   1,   2, 255,   3,   4,   5, 255,   6,   7,   8, 255,   9,  10,  11, 255
	.byte	  0,   1,   2, 255,   3,   4,   5, 255,   6,   7,   8, 255,   9,  10,  11, 255
	.byte	255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0
	.byte	255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0
G$ROL8:
	.byte	  7,   0,   1,   2,   3,   4,   5,   6,  15,   8,   9,  10,  11,  12,  13,  14
	.byte	 23,  16,  17,  18,  19,  20,  21,  22,  31,  24,  25,  26,  27,  28,  29,  30
G$ROL56:
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
	.byte	 17,  18,  19,  20,  21,  22,  23,  16,  25,  26,  27,  28,  29,  30,  31,  24
G$ZETAS_TO_INVERT_LAYER_2:
	.byte	 45,  79, 213, 255,  45,  79, 213, 255,  45,  79, 213, 255,  45,  79, 213, 255
	.byte	 84, 157,  31,   0,  84, 157,  31,   0,  84, 157,  31,   0,  84, 157,  31,   0
	.byte	 48, 252, 216, 255,  48, 252, 216, 255,  48, 252, 216, 255,  48, 252, 216, 255
	.byte	 52, 133,  59,   0,  52, 133,  59,   0,  52, 133,  59,   0,  52, 133,  59,   0
	.byte	 83,  56,  59,   0,  83,  56,  59,   0,  83,  56,  59,   0,  83,  56,  59,   0
	.byte	118, 143,  14,   0, 118, 143,  14,   0, 118, 143,  14,   0, 118, 143,  14,   0
	.byte	154,  27,   8,   0, 154,  27,   8,   0, 154,  27,   8,   0, 154,  27,   8,   0
	.byte	168,  99,  12,   0, 168,  99,  12,   0, 168,  99,  12,   0, 168,  99,  12,   0
	.byte	140, 115,  56,   0, 140, 115,  56,   0, 140, 115,  56,   0, 140, 115,  56,   0
	.byte	 92, 148, 231, 255,  92, 148, 231, 255,  92, 148, 231, 255,  92, 148, 231, 255
	.byte	 23,  86, 223, 255,  23,  86, 223, 255,  23,  86, 223, 255,  23,  86, 223, 255
	.byte	 63, 132,  53,   0,  63, 132,  53,   0,  63, 132,  53,   0,  63, 132,  53,   0
	.byte	 89, 175, 197, 255,  89, 175, 197, 255,  89, 175, 197, 255,  89, 175, 197, 255
	.byte	 30, 126,  53,   0,  30, 126,  53,   0,  30, 126,  53,   0,  30, 126,  53,   0
	.byte	214, 234, 230, 255, 214, 234, 230, 255, 214, 234, 230, 255, 214, 234, 230, 255
	.byte	 61,  18, 230, 255,  61,  18, 230, 255,  61,  18, 230, 255,  61,  18, 230, 255
	.byte	 93, 197, 247, 255,  93, 197, 247, 255,  93, 197, 247, 255,  93, 197, 247, 255
	.byte	156, 214,  35,   0, 156, 214,  35,   0, 156, 214,  35,   0, 156, 214,  35,   0
	.byte	 77, 106, 251, 255,  77, 106, 251, 255,  77, 106, 251, 255,  77, 106, 251, 255
	.byte	  0,   4,  54,   0,   0,   4,  54,   0,   0,   4,  54,   0,   0,   4,  54,   0
	.byte	 65,  62, 212, 255,  65,  62, 212, 255,  65,  62, 212, 255,  65,  62, 212, 255
	.byte	150, 138,  54,   0, 150, 138,  54,   0, 150, 138,  54,   0, 150, 138,  54,   0
	.byte	124, 142, 209, 255, 124, 142, 209, 255, 124, 142, 209, 255, 124, 142, 209, 255
	.byte	133,  21, 197, 255, 133,  21, 197, 255, 133,  21, 197, 255, 133,  21, 197, 255
	.byte	175, 190,  59,   0, 175, 190,  59,   0, 175, 190,  59,   0, 175, 190,  59,   0
	.byte	212,  71, 217, 255, 212,  71, 217, 255, 212,  71, 217, 255, 212,  71, 217, 255
	.byte	 44,  48, 201, 255,  44,  48, 201, 255,  44,  48, 201, 255,  44,  48, 201, 255
	.byte	  3, 165, 230, 255,   3, 165, 230, 255,   3, 165, 230, 255,   3, 165, 230, 255
	.byte	197, 222,  53,   0, 197, 222,  53,   0, 197, 222,  53,   0, 197, 222,  53,   0
	.byte	205, 244,  46,   0, 205, 244,  46,   0, 205, 244,  46,   0, 205, 244,  46,   0
	.byte	 32, 118,   1,   0,  32, 118,   1,   0,  32, 118,   1,   0,  32, 118,   1,   0
	.byte	103,  74,  41,   0, 103,  74,  41,   0, 103,  74,  41,   0, 103,  74,  41,   0
G$ZETAS_TO_INVERT_LAYER_1:
	.byte	217, 151,  58,   0, 217, 151,  58,   0, 156, 199, 196, 255, 156, 199, 196, 255
	.byte	 87, 160, 200, 255,  87, 160, 200, 255, 162, 238, 209, 255, 162, 238, 209, 255
	.byte	  2,   8, 234, 255,   2,   8, 234, 255, 224, 208, 231, 255, 224, 208, 231, 255
	.byte	 68, 153, 243, 255,  68, 153, 243, 255,  37, 158,  19,   0,  37, 158,  19,   0
	.byte	146, 119,  20,   0, 146, 119,  20,   0, 224,  74, 253, 255, 224,  74, 253, 255
	.byte	  5,  19,  20,   0,   5,  19,  20,   0, 147,  60, 219, 255, 147,  60, 219, 255
	.byte	246, 191, 227, 255, 246, 191, 227, 255,   8, 200, 201, 255,   8, 200, 201, 255
	.byte	194,  54,  48,   0, 194,  54,  48,   0, 108, 228,   2,   0, 108, 228,   2,   0
	.byte	  8, 232, 235, 255,   8, 232, 235, 255, 223, 199, 252, 255, 223, 199, 252, 255
	.byte	161, 152,  11,   0, 161, 152,  11,   0, 108, 117,  36,   0, 108, 117,  36,   0
	.byte	192, 105, 206, 255, 192, 105, 206, 255, 126, 222, 255, 255, 126, 222, 255, 255
	.byte	 72,  57,  25,   0,  72,  57,  25,   0, 202,  43, 199, 255, 202,  43, 199, 255
	.byte	 90, 103,  60,   0,  90, 103,  60,   0, 190,  54, 239, 255, 190,  54, 239, 255
	.byte	 68, 205,  13,   0,  68, 205,  13,   0,   0, 173,   0,   0,   0, 173,   0,   0
	.byte	136,  69,  47,   0, 136,  69,  47,   0, 240,  10,   4,   0, 240,  10,   4,   0
	.byte	 23, 196,   7,   0,  23, 196,   7,   0, 233, 251, 204, 255, 233, 251, 204, 255
	.byte	 98,  44, 234, 255,  98,  44, 234, 255, 212, 149,  20,   0, 212, 149,  20,   0
	.byte	 99,  69,  28,   0,  99,  69,  28,   0, 221,  43, 250, 255, 221,  43, 250, 255
	.byte	247,   9, 236, 255, 247,   9, 236, 255,  19,  65, 237, 255,  19,  65, 237, 255
	.byte	 59, 166, 255, 255,  59, 166, 255, 255, 130, 194, 245, 255, 130, 194, 245, 255
	.byte	  9,  52, 218, 255,   9,  52, 218, 255,  75, 164, 199, 255,  75, 164, 199, 255
	.byte	109, 186, 249, 255, 109, 186, 249, 255, 163, 183, 210, 255, 163, 183, 210, 255
	.byte	159, 110,  41,   0, 159, 110,  41,   0, 133, 254, 240, 255, 133, 254, 240, 255
	.byte	 56, 198,  32,   0,  56, 198,  32,   0, 242,  16,  52,   0, 242,  16,  52,   0
	.byte	202, 239,   1,   0, 202, 239,   1,   0, 174, 210, 207, 255, 174, 210, 207, 255
	.byte	224, 144, 200, 255, 224, 144, 200, 255, 128,  82, 207, 255, 128,  82, 207, 255
	.byte	246, 188, 240, 255, 246, 188, 240, 255, 114, 151,  29,   0, 114, 151,  29,   0
	.byte	114, 176, 193, 255, 114, 176, 193, 255, 117, 207, 236, 255, 117, 207, 236, 255
	.byte	187, 207, 231, 255, 187, 207, 231, 255, 238,   9,  53,   0, 238,   9,  53,   0
	.byte	199,  53,  33,   0, 199,  53,  33,   0,  93, 214, 233, 255,  93, 214, 233, 255
	.byte	 25, 152, 209, 255,  25, 152, 209, 255, 129, 172, 232, 255, 129, 172, 232, 255
	.byte	207, 225, 199, 255, 207, 225, 199, 255, 229,   6, 196, 255, 229,   6, 196, 255
G$ZETAS_TO_INVERT_LAYER_0:
	.byte	206,  41,  30,   0, 182,  22, 243, 255, 223,  54, 235, 255,  78,  67, 255, 255
	.byte	104,  94,  21,   0, 202,  21,  60,   0,  44, 207,  59,   0,  80, 138, 247, 255
	.byte	169, 229, 201, 255,  42, 156,  24,   0,   9,  29, 221, 255, 221, 147, 249, 255
	.byte	  5,  24, 241, 255, 147, 204,   2,   0, 175, 225, 221, 255, 100,  39, 211, 255
	.byte	219, 127, 197, 255, 218,   5, 252, 255, 104,  38,  29,   0, 174, 124, 228, 255
	.byte	 51,  38, 239, 255, 152, 142, 230, 255, 208,  76,  26,   0,  69, 125, 249, 255
	.byte	 14,  52,   7,   0, 231,  53,  26,   0, 192,  29,   4,   0,  21,   1,  59,   0
	.byte	244,  27, 241, 255, 247, 196,  33,   0,  57, 197,  53,   0,  60, 161, 209, 255
	.byte	 61, 140, 228, 255, 103, 161, 199, 255, 113, 253,  45,   0,   8, 170,  24,   0
	.byte	154,  55,  25,   0, 165,  92,  12,   0,  28, 124,   2,   0, 190, 108, 207, 255
	.byte	167, 147, 237, 255, 187, 212,   2,   0, 143, 124, 253, 255, 183, 115,  37,   0
	.byte	152, 104,  51,   0, 152, 221,  29,   0, 139,  29,  37,   0,  88,  70, 225, 255
	.byte	 31,  94, 198, 255, 216,  16,   9,   0,  87, 209, 227, 255, 248, 127, 230, 255
	.byte	 18,  44, 199, 255,  27, 145, 216, 255,  12, 202, 212, 255,  52, 185, 247, 255
	.byte	207, 248,  51,   0, 232,  29,  34,   0, 173,   5, 235, 255, 120,  37, 217, 255
	.byte	231, 219,  11,   0,   5, 228,  22,   0, 153,  64,  29,   0,  83, 121, 236, 255
	.byte	110,  13, 226, 255, 131, 114,  50,   0,  47,  45, 234, 255,  62,  94, 205, 255
	.byte	199,   6,  20,   0, 228,  29, 249, 255,  27, 225,  18,   0, 190, 168, 235, 255
	.byte	166, 246, 239, 255,  75,  11,  29,   0, 144, 219, 201, 255, 145,  56,  40,   0
	.byte	 63, 133,  28,   0, 137,  80, 210, 255, 190,  20,  19,   0,  24, 133, 198, 255
	.byte	 70,  90,  24,   0,  81, 240,  37,   0, 113,  77,  19,   0,  58, 122, 216, 255
	.byte	132,   9,  19,   0,  28, 225,  61,   0, 153,  17,  41,   0, 229,  94,  43,   0
	.byte	 36,  25,   3,   0, 199, 124,  26,   0,  27, 176,  62,   0,  65, 205, 218, 255
	.byte	 59,   0, 205, 255, 231, 114,  52,   0,  12,  97,   4,   0,  25,  57,   5,   0
	.byte	194,  33, 201, 255, 146,  69, 244, 255, 134, 239,  48,   0, 132,   0,  31,   0
	.byte	214, 252, 247, 255, 125, 185, 201, 255, 246,  90, 208, 255,  33,   0, 246, 255
	.byte	252,   6, 248, 255,   4,  87, 255, 255,  90, 127,  12,   0, 230, 224,  13,   0
	.byte	138,  98, 231, 255, 131, 143,   7,   0,  26,  94,  28,   0,  94, 190,  13,   0
	.byte	222,  69, 207, 255,  86, 187, 237, 255,  93, 155,  53,   0, 240,  36, 237, 255
	.byte	252, 162, 198, 255, 160,  72, 202, 255, 135,  37,  37,   0, 245,  18,   4,   0
	.byte	 34, 164, 201, 255, 159, 171, 218, 255, 248,  65,  58,   0, 212,  88,  35,   0
	.byte	251,  61,  34,   0, 114, 255, 204, 255,  90, 255,  51,   0, 147, 234,  31,   0
G$LAYER_5_ZETAS:
	.byte	 68, 158,   3,   0,  68, 158,   3,   0,  68, 158,   3,   0,  68, 158,   3,   0
	.byte	 68, 158,   3,   0,  68, 158,   3,   0,  68, 158,   3,   0,  68, 158,   3,   0
	.byte	 24,  33, 244, 255,  24,  33, 244, 255,  24,  33, 244, 255,  24,  33, 244, 255
	.byte	 24,  33, 244, 255,  24,  33, 244, 255,  24,  33, 244, 255,  24,  33, 244, 255
	.byte	 40, 161, 242, 255,  40, 161, 242, 255,  40, 161, 242, 255,  40, 161, 242, 255
	.byte	 40, 161, 242, 255,  40, 161, 242, 255,  40, 161, 242, 255,  40, 161, 242, 255
	.byte	 36,  30,   7,   0,  36,  30,   7,   0,  36,  30,   7,   0,  36,  30,   7,   0
	.byte	 36,  30,   7,   0,  36,  30,   7,   0,  36,  30,   7,   0,  36,  30,   7,   0
G$LAYER_4_ZETAS:
	.byte	 43, 222,  27,   0,  43, 222,  27,   0,  43, 222,  27,   0,  43, 222,  27,   0
	.byte	 43, 222,  27,   0,  43, 222,  27,   0,  43, 222,  27,   0,  43, 222,  27,   0
	.byte	 43, 233,  35,   0,  43, 233,  35,   0,  43, 233,  35,   0,  43, 233,  35,   0
	.byte	 43, 233,  35,   0,  43, 233,  35,   0,  43, 233,  35,   0,  43, 233,  35,   0
	.byte	173, 132, 250, 255, 173, 132, 250, 255, 173, 132, 250, 255, 173, 132, 250, 255
	.byte	173, 132, 250, 255, 173, 132, 250, 255, 173, 132, 250, 255, 173, 132, 250, 255
	.byte	127,  20, 224, 255, 127,  20, 224, 255, 127,  20, 224, 255, 127,  20, 224, 255
	.byte	127,  20, 224, 255, 127,  20, 224, 255, 127,  20, 224, 255, 127,  20, 224, 255
	.byte	117, 154,  47,   0, 117, 154,  47,   0, 117, 154,  47,   0, 117, 154,  47,   0
	.byte	117, 154,  47,   0, 117, 154,  47,   0, 117, 154,  47,   0, 117, 154,  47,   0
	.byte	  9, 251, 211, 255,   9, 251, 211, 255,   9, 251, 211, 255,   9, 251, 211, 255
	.byte	  9, 251, 211, 255,   9, 251, 211, 255,   9, 251, 211, 255,   9, 251, 211, 255
	.byte	 73, 122,  47,   0,  73, 122,  47,   0,  73, 122,  47,   0,  73, 122,  47,   0
	.byte	 73, 122,  47,   0,  73, 122,  47,   0,  73, 122,  47,   0,  73, 122,  47,   0
	.byte	 39, 229,  40,   0,  39, 229,  40,   0,  39, 229,  40,   0,  39, 229,  40,   0
	.byte	 39, 229,  40,   0,  39, 229,  40,   0,  39, 229,  40,   0,  39, 229,  40,   0
G$LAYER_3_ZETAS:
	.byte	 88, 150,  41,   0,  88, 150,  41,   0,  88, 150,  41,   0,  88, 150,  41,   0
	.byte	 88, 150,  41,   0,  88, 150,  41,   0,  88, 150,  41,   0,  88, 150,  41,   0
	.byte	112, 160,  15,   0, 112, 160,  15,   0, 112, 160,  15,   0, 112, 160,  15,   0
	.byte	112, 160,  15,   0, 112, 160,  15,   0, 112, 160,  15,   0, 112, 160,  15,   0
	.byte	164, 133, 239, 255, 164, 133, 239, 255, 164, 133, 239, 255, 164, 133, 239, 255
	.byte	164, 133, 239, 255, 164, 133, 239, 255, 164, 133, 239, 255, 164, 133, 239, 255
	.byte	136, 183,  54,   0, 136, 183,  54,   0, 136, 183,  54,   0, 136, 183,  54,   0
	.byte	136, 183,  54,   0, 136, 183,  54,   0, 136, 183,  54,   0, 136, 183,  54,   0
	.byte	144, 157, 247, 255, 144, 157, 247, 255, 144, 157, 247, 255, 144, 157, 247, 255
	.byte	144, 157, 247, 255, 144, 157, 247, 255, 144, 157, 247, 255, 144, 157, 247, 255
	.byte	160, 234, 238, 255, 160, 234, 238, 255, 160, 234, 238, 255, 160, 234, 238, 255
	.byte	160, 234, 238, 255, 160, 234, 238, 255, 160, 234, 238, 255, 160, 234, 238, 255
	.byte	104, 249,  39,   0, 104, 249,  39,   0, 104, 249,  39,   0, 104, 249,  39,   0
	.byte	104, 249,  39,   0, 104, 249,  39,   0, 104, 249,  39,   0, 104, 249,  39,   0
	.byte	123, 211, 223, 255, 123, 211, 223, 255, 123, 211, 223, 255, 123, 211, 223, 255
	.byte	123, 211, 223, 255, 123, 211, 223, 255, 123, 211, 223, 255, 123, 211, 223, 255
	.byte	214, 173, 223, 255, 214, 173, 223, 255, 214, 173, 223, 255, 214, 173, 223, 255
	.byte	214, 173, 223, 255, 214, 173, 223, 255, 214, 173, 223, 255, 214, 173, 223, 255
	.byte	231,  26, 197, 255, 231,  26, 197, 255, 231,  26, 197, 255, 231,  26, 197, 255
	.byte	231,  26, 197, 255, 231,  26, 197, 255, 231,  26, 197, 255, 231,  26, 197, 255
	.byte	247, 164, 234, 255, 247, 164, 234, 255, 247, 164, 234, 255, 247, 164, 234, 255
	.byte	247, 164, 234, 255, 247, 164, 234, 255, 247, 164, 234, 255, 247, 164, 234, 255
	.byte	152, 252, 205, 255, 152, 252, 205, 255, 152, 252, 205, 255, 152, 252, 205, 255
	.byte	152, 252, 205, 255, 152, 252, 205, 255, 152, 252, 205, 255, 152, 252, 205, 255
	.byte	 53, 208,  26,   0,  53, 208,  26,   0,  53, 208,  26,   0,  53, 208,  26,   0
	.byte	 53, 208,  26,   0,  53, 208,  26,   0,  53, 208,  26,   0,  53, 208,  26,   0
	.byte	 34, 180, 255, 255,  34, 180, 255, 255,  34, 180, 255, 255,  34, 180, 255, 255
	.byte	 34, 180, 255, 255,  34, 180, 255, 255,  34, 180, 255, 255,  34, 180, 255, 255
	.byte	  1,  50,  61,   0,   1,  50,  61,   0,   1,  50,  61,   0,   1,  50,  61,   0
	.byte	  1,  50,  61,   0,   1,  50,  61,   0,   1,  50,  61,   0,   1,  50,  61,   0
	.byte	197,  69,   4,   0, 197,  69,   4,   0, 197,  69,   4,   0, 197,  69,   4,   0
	.byte	197,  69,   4,   0, 197,  69,   4,   0, 197,  69,   4,   0, 197,  69,   4,   0
G$LAYER_2_ZETAS:
	.byte	103,  74,  41,   0, 103,  74,  41,   0, 103,  74,  41,   0, 103,  74,  41,   0
	.byte	 32, 118,   1,   0,  32, 118,   1,   0,  32, 118,   1,   0,  32, 118,   1,   0
	.byte	205, 244,  46,   0, 205, 244,  46,   0, 205, 244,  46,   0, 205, 244,  46,   0
	.byte	197, 222,  53,   0, 197, 222,  53,   0, 197, 222,  53,   0, 197, 222,  53,   0
	.byte	  3, 165, 230, 255,   3, 165, 230, 255,   3, 165, 230, 255,   3, 165, 230, 255
	.byte	 44,  48, 201, 255,  44,  48, 201, 255,  44,  48, 201, 255,  44,  48, 201, 255
	.byte	212,  71, 217, 255, 212,  71, 217, 255, 212,  71, 217, 255, 212,  71, 217, 255
	.byte	175, 190,  59,   0, 175, 190,  59,   0, 175, 190,  59,   0, 175, 190,  59,   0
	.byte	133,  21, 197, 255, 133,  21, 197, 255, 133,  21, 197, 255, 133,  21, 197, 255
	.byte	124, 142, 209, 255, 124, 142, 209, 255, 124, 142, 209, 255, 124, 142, 209, 255
	.byte	150, 138,  54,   0, 150, 138,  54,   0, 150, 138,  54,   0, 150, 138,  54,   0
	.byte	 65,  62, 212, 255,  65,  62, 212, 255,  65,  62, 212, 255,  65,  62, 212, 255
	.byte	  0,   4,  54,   0,   0,   4,  54,   0,   0,   4,  54,   0,   0,   4,  54,   0
	.byte	 77, 106, 251, 255,  77, 106, 251, 255,  77, 106, 251, 255,  77, 106, 251, 255
	.byte	156, 214,  35,   0, 156, 214,  35,   0, 156, 214,  35,   0, 156, 214,  35,   0
	.byte	 93, 197, 247, 255,  93, 197, 247, 255,  93, 197, 247, 255,  93, 197, 247, 255
	.byte	 61,  18, 230, 255,  61,  18, 230, 255,  61,  18, 230, 255,  61,  18, 230, 255
	.byte	214, 234, 230, 255, 214, 234, 230, 255, 214, 234, 230, 255, 214, 234, 230, 255
	.byte	 30, 126,  53,   0,  30, 126,  53,   0,  30, 126,  53,   0,  30, 126,  53,   0
	.byte	 89, 175, 197, 255,  89, 175, 197, 255,  89, 175, 197, 255,  89, 175, 197, 255
	.byte	 63, 132,  53,   0,  63, 132,  53,   0,  63, 132,  53,   0,  63, 132,  53,   0
	.byte	 23,  86, 223, 255,  23,  86, 223, 255,  23,  86, 223, 255,  23,  86, 223, 255
	.byte	 92, 148, 231, 255,  92, 148, 231, 255,  92, 148, 231, 255,  92, 148, 231, 255
	.byte	140, 115,  56,   0, 140, 115,  56,   0, 140, 115,  56,   0, 140, 115,  56,   0
	.byte	168,  99,  12,   0, 168,  99,  12,   0, 168,  99,  12,   0, 168,  99,  12,   0
	.byte	154,  27,   8,   0, 154,  27,   8,   0, 154,  27,   8,   0, 154,  27,   8,   0
	.byte	118, 143,  14,   0, 118, 143,  14,   0, 118, 143,  14,   0, 118, 143,  14,   0
	.byte	 83,  56,  59,   0,  83,  56,  59,   0,  83,  56,  59,   0,  83,  56,  59,   0
	.byte	 52, 133,  59,   0,  52, 133,  59,   0,  52, 133,  59,   0,  52, 133,  59,   0
	.byte	 48, 252, 216, 255,  48, 252, 216, 255,  48, 252, 216, 255,  48, 252, 216, 255
	.byte	 84, 157,  31,   0,  84, 157,  31,   0,  84, 157,  31,   0,  84, 157,  31,   0
	.byte	 45,  79, 213, 255,  45,  79, 213, 255,  45,  79, 213, 255,  45,  79, 213, 255
G$LAYER_1_ZETAS:
	.byte	229,   6, 196, 255, 229,   6, 196, 255, 207, 225, 199, 255, 207, 225, 199, 255
	.byte	129, 172, 232, 255, 129, 172, 232, 255,  25, 152, 209, 255,  25, 152, 209, 255
	.byte	 93, 214, 233, 255,  93, 214, 233, 255, 199,  53,  33,   0, 199,  53,  33,   0
	.byte	238,   9,  53,   0, 238,   9,  53,   0, 187, 207, 231, 255, 187, 207, 231, 255
	.byte	117, 207, 236, 255, 117, 207, 236, 255, 114, 176, 193, 255, 114, 176, 193, 255
	.byte	114, 151,  29,   0, 114, 151,  29,   0, 246, 188, 240, 255, 246, 188, 240, 255
	.byte	128,  82, 207, 255, 128,  82, 207, 255, 224, 144, 200, 255, 224, 144, 200, 255
	.byte	174, 210, 207, 255, 174, 210, 207, 255, 202, 239,   1,   0, 202, 239,   1,   0
	.byte	242,  16,  52,   0, 242,  16,  52,   0,  56, 198,  32,   0,  56, 198,  32,   0
	.byte	133, 254, 240, 255, 133, 254, 240, 255, 159, 110,  41,   0, 159, 110,  41,   0
	.byte	163, 183, 210, 255, 163, 183, 210, 255, 109, 186, 249, 255, 109, 186, 249, 255
	.byte	 75, 164, 199, 255,  75, 164, 199, 255,   9,  52, 218, 255,   9,  52, 218, 255
	.byte	130, 194, 245, 255, 130, 194, 245, 255,  59, 166, 255, 255,  59, 166, 255, 255
	.byte	 19,  65, 237, 255,  19,  65, 237, 255, 247,   9, 236, 255, 247,   9, 236, 255
	.byte	221,  43, 250, 255, 221,  43, 250, 255,  99,  69,  28,   0,  99,  69,  28,   0
	.byte	212, 149,  20,   0, 212, 149,  20,   0,  98,  44, 234, 255,  98,  44, 234, 255
	.byte	233, 251, 204, 255, 233, 251, 204, 255,  23, 196,   7,   0,  23, 196,   7,   0
	.byte	240,  10,   4,   0, 240,  10,   4,   0, 136,  69,  47,   0, 136,  69,  47,   0
	.byte	  0, 173,   0,   0,   0, 173,   0,   0,  68, 205,  13,   0,  68, 205,  13,   0
	.byte	190,  54, 239, 255, 190,  54, 239, 255,  90, 103,  60,   0,  90, 103,  60,   0
	.byte	202,  43, 199, 255, 202,  43, 199, 255,  72,  57,  25,   0,  72,  57,  25,   0
	.byte	126, 222, 255, 255, 126, 222, 255, 255, 192, 105, 206, 255, 192, 105, 206, 255
	.byte	108, 117,  36,   0, 108, 117,  36,   0, 161, 152,  11,   0, 161, 152,  11,   0
	.byte	223, 199, 252, 255, 223, 199, 252, 255,   8, 232, 235, 255,   8, 232, 235, 255
	.byte	108, 228,   2,   0, 108, 228,   2,   0, 194,  54,  48,   0, 194,  54,  48,   0
	.byte	  8, 200, 201, 255,   8, 200, 201, 255, 246, 191, 227, 255, 246, 191, 227, 255
	.byte	147,  60, 219, 255, 147,  60, 219, 255,   5,  19,  20,   0,   5,  19,  20,   0
	.byte	224,  74, 253, 255, 224,  74, 253, 255, 146, 119,  20,   0, 146, 119,  20,   0
	.byte	 37, 158,  19,   0,  37, 158,  19,   0,  68, 153, 243, 255,  68, 153, 243, 255
	.byte	224, 208, 231, 255, 224, 208, 231, 255,   2,   8, 234, 255,   2,   8, 234, 255
	.byte	162, 238, 209, 255, 162, 238, 209, 255,  87, 160, 200, 255,  87, 160, 200, 255
	.byte	156, 199, 196, 255, 156, 199, 196, 255, 217, 151,  58,   0, 217, 151,  58,   0
G$LAYER_0_ZETAS:
	.byte	147, 234,  31,   0,  90, 255,  51,   0, 114, 255, 204, 255, 251,  61,  34,   0
	.byte	212,  88,  35,   0, 248,  65,  58,   0, 159, 171, 218, 255,  34, 164, 201, 255
	.byte	245,  18,   4,   0, 135,  37,  37,   0, 160,  72, 202, 255, 252, 162, 198, 255
	.byte	240,  36, 237, 255,  93, 155,  53,   0,  86, 187, 237, 255, 222,  69, 207, 255
	.byte	 94, 190,  13,   0,  26,  94,  28,   0, 131, 143,   7,   0, 138,  98, 231, 255
	.byte	230, 224,  13,   0,  90, 127,  12,   0,   4,  87, 255, 255, 252,   6, 248, 255
	.byte	 33,   0, 246, 255, 246,  90, 208, 255, 125, 185, 201, 255, 214, 252, 247, 255
	.byte	132,   0,  31,   0, 134, 239,  48,   0, 146,  69, 244, 255, 194,  33, 201, 255
	.byte	 25,  57,   5,   0,  12,  97,   4,   0, 231, 114,  52,   0,  59,   0, 205, 255
	.byte	 65, 205, 218, 255,  27, 176,  62,   0, 199, 124,  26,   0,  36,  25,   3,   0
	.byte	229,  94,  43,   0, 153,  17,  41,   0,  28, 225,  61,   0, 132,   9,  19,   0
	.byte	 58, 122, 216, 255, 113,  77,  19,   0,  81, 240,  37,   0,  70,  90,  24,   0
	.byte	 24, 133, 198, 255, 190,  20,  19,   0, 137,  80, 210, 255,  63, 133,  28,   0
	.byte	145,  56,  40,   0, 144, 219, 201, 255,  75,  11,  29,   0, 166, 246, 239, 255
	.byte	190, 168, 235, 255,  27, 225,  18,   0, 228,  29, 249, 255, 199,   6,  20,   0
	.byte	 62,  94, 205, 255,  47,  45, 234, 255, 131, 114,  50,   0, 110,  13, 226, 255
	.byte	 83, 121, 236, 255, 153,  64,  29,   0,   5, 228,  22,   0, 231, 219,  11,   0
	.byte	120,  37, 217, 255, 173,   5, 235, 255, 232,  29,  34,   0, 207, 248,  51,   0
	.byte	 52, 185, 247, 255,  12, 202, 212, 255,  27, 145, 216, 255,  18,  44, 199, 255
	.byte	248, 127, 230, 255,  87, 209, 227, 255, 216,  16,   9,   0,  31,  94, 198, 255
	.byte	 88,  70, 225, 255, 139,  29,  37,   0, 152, 221,  29,   0, 152, 104,  51,   0
	.byte	183, 115,  37,   0, 143, 124, 253, 255, 187, 212,   2,   0, 167, 147, 237, 255
	.byte	190, 108, 207, 255,  28, 124,   2,   0, 165,  92,  12,   0, 154,  55,  25,   0
	.byte	  8, 170,  24,   0, 113, 253,  45,   0, 103, 161, 199, 255,  61, 140, 228, 255
	.byte	 60, 161, 209, 255,  57, 197,  53,   0, 247, 196,  33,   0, 244,  27, 241, 255
	.byte	 21,   1,  59,   0, 192,  29,   4,   0, 231,  53,  26,   0,  14,  52,   7,   0
	.byte	 69, 125, 249, 255, 208,  76,  26,   0, 152, 142, 230, 255,  51,  38, 239, 255
	.byte	174, 124, 228, 255, 104,  38,  29,   0, 218,   5, 252, 255, 219, 127, 197, 255
	.byte	100,  39, 211, 255, 175, 225, 221, 255, 147, 204,   2,   0,   5,  24, 241, 255
	.byte	221, 147, 249, 255,   9,  29, 221, 255,  42, 156,  24,   0, 169, 229, 201, 255
	.byte	 80, 138, 247, 255,  44, 207,  59,   0, 202,  21,  60,   0, 104,  94,  21,   0
	.byte	 78,  67, 255, 255, 223,  54, 235, 255, 182,  22, 243, 255, 206,  41,  30,   0
G$TWO_POW_22_VECTOR:
	.byte	  0,   0,  64,   0,   0,   0,  64,   0,   0,   0,  64,   0,   0,   0,  64,   0
	.byte	  0,   0,  64,   0,   0,   0,  64,   0,   0,   0,  64,   0,   0,   0,  64,   0
G$INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR:
	.byte	  1,  32, 128,   3,   1,  32, 128,   3,   1,  32, 128,   3,   1,  32, 128,   3
	.byte	  1,  32, 128,   3,   1,  32, 128,   3,   1,  32, 128,   3,   1,  32, 128,   3
G$polynomial__CONSTANTS_TABLE_gamma2_32:
	.byte	 15,   0,   0,   0,  15,   0,   0,   0,  15,   0,   0,   0,  15,   0,   0,   0
	.byte	 15,   0,   0,   0,  15,   0,   0,   0,  15,   0,   0,   0,  15,   0,   0,   0
	.byte	  1,   4,   0,   0,   1,   4,   0,   0,   1,   4,   0,   0,   1,   4,   0,   0
	.byte	  1,   4,   0,   0,   1,   4,   0,   0,   1,   4,   0,   0,   1,   4,   0,   0
	.byte	  0, 254,   7,   0,   0, 254,   7,   0,   0, 254,   7,   0,   0, 254,   7,   0
	.byte	  0, 254,   7,   0,   0, 254,   7,   0,   0, 254,   7,   0,   0, 254,   7,   0
	.byte	127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0
	.byte	127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0
	.byte	  0,   2,   0,   0,   0,   2,   0,   0,   0,   2,   0,   0,   0,   2,   0,   0
	.byte	  0,   2,   0,   0,   0,   2,   0,   0,   0,   2,   0,   0,   0,   2,   0,   0
G$gamma1__DECODING_SHIFTS_TABLE_bits20:
	.byte	  0,   1,   2, 255,   2,   3,   4, 255,   5,   6,   7, 255,   7,   8,   9, 255
	.byte	  6,   7,   8, 255,   8,   9,  10, 255,  11,  12,  13, 255,  13,  14,  15, 255
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0,   0,   4,   0,   0,   0
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0,   0,   4,   0,   0,   0
G$gamma1__ENCODING_SHIFTS_TABLE_bits20:
	.byte	 12,   0,   0,   0,   0,   0,   0,   0,  12,   0,   0,   0,   0,   0,   0,   0
	.byte	 12,   0,   0,   0,   0,   0,   0,   0,  12,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   1,   2,   3,   4,   8,   9,  10,  11,  12, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   4,   8,   9,  10,  11,  12, 255, 255, 255, 255, 255, 255
G$error_polynomial__SHIFTS:
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0,   0,   4,   0,   0,   0
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0,   0,   4,   0,   0,   0
G$error_polynomial__DECODING_SHUFFLES:
	.byte	  0, 255, 255, 255,   0, 255, 255, 255,   1, 255, 255, 255,   1, 255, 255, 255
	.byte	  2, 255, 255, 255,   2, 255, 255, 255,   3, 255, 255, 255,   3, 255, 255, 255
G$error_polynomial__ENCODING_SHUFFLES:
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
G$HALF_OF_BITS_IN_T0_VECTOR:
	.byte	  0,  16,   0,   0,   0,  16,   0,   0,   0,  16,   0,   0,   0,  16,   0,   0
	.byte	  0,  16,   0,   0,   0,  16,   0,   0,   0,  16,   0,   0,   0,  16,   0,   0
G$MODULUS_VECTOR:
	.byte	  1, 224, 127,   0,   1, 224, 127,   0,   1, 224, 127,   0,   1, 224, 127,   0
	.byte	  1, 224, 127,   0,   1, 224, 127,   0,   1, 224, 127,   0,   1, 224, 127,   0
G$t1__SHUFFLE_TO_GROUP:
	.byte	  0,   1,   2,   3,   4,   8,   9,  10,  11,  12, 255, 255, 255, 255, 255, 255
G$matrix_A__SHUFFLE_TABLE:
	.byte	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  4,   5,   6,   7, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   4,   5,   6,   7, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  8,   9,  10,  11, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   8,   9,  10,  11, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  4,   5,   6,   7,   8,   9,  10,  11, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11, 255, 255, 255, 255
	.byte	 12,  13,  14,  15, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,  12,  13,  14,  15, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  4,   5,   6,   7,  12,  13,  14,  15, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   4,   5,   6,   7,  12,  13,  14,  15, 255, 255, 255, 255
	.byte	  8,   9,  10,  11,  12,  13,  14,  15, 255, 255, 255, 255, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   8,   9,  10,  11,  12,  13,  14,  15, 255, 255, 255, 255
	.byte	  4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15, 255, 255, 255, 255
	.byte	  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15
G$ERROR_VECTOR_SHUFFLE_TABLE:
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	.byte	  1,   0,   0,   0,   0,   0,   0,   0,   0,   1,   0,   0,   0,   0,   0,   0
	.byte	  2,   0,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0
	.byte	  1,   2,   0,   0,   0,   0,   0,   0,   0,   1,   2,   0,   0,   0,   0,   0
	.byte	  3,   0,   0,   0,   0,   0,   0,   0,   0,   3,   0,   0,   0,   0,   0,   0
	.byte	  1,   3,   0,   0,   0,   0,   0,   0,   0,   1,   3,   0,   0,   0,   0,   0
	.byte	  2,   3,   0,   0,   0,   0,   0,   0,   0,   2,   3,   0,   0,   0,   0,   0
	.byte	  1,   2,   3,   0,   0,   0,   0,   0,   0,   1,   2,   3,   0,   0,   0,   0
	.byte	  4,   0,   0,   0,   0,   0,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0
	.byte	  1,   4,   0,   0,   0,   0,   0,   0,   0,   1,   4,   0,   0,   0,   0,   0
	.byte	  2,   4,   0,   0,   0,   0,   0,   0,   0,   2,   4,   0,   0,   0,   0,   0
	.byte	  1,   2,   4,   0,   0,   0,   0,   0,   0,   1,   2,   4,   0,   0,   0,   0
	.byte	  3,   4,   0,   0,   0,   0,   0,   0,   0,   3,   4,   0,   0,   0,   0,   0
	.byte	  1,   3,   4,   0,   0,   0,   0,   0,   0,   1,   3,   4,   0,   0,   0,   0
	.byte	  2,   3,   4,   0,   0,   0,   0,   0,   0,   2,   3,   4,   0,   0,   0,   0
	.byte	  1,   2,   3,   4,   0,   0,   0,   0,   0,   1,   2,   3,   4,   0,   0,   0
	.byte	  5,   0,   0,   0,   0,   0,   0,   0,   0,   5,   0,   0,   0,   0,   0,   0
	.byte	  1,   5,   0,   0,   0,   0,   0,   0,   0,   1,   5,   0,   0,   0,   0,   0
	.byte	  2,   5,   0,   0,   0,   0,   0,   0,   0,   2,   5,   0,   0,   0,   0,   0
	.byte	  1,   2,   5,   0,   0,   0,   0,   0,   0,   1,   2,   5,   0,   0,   0,   0
	.byte	  3,   5,   0,   0,   0,   0,   0,   0,   0,   3,   5,   0,   0,   0,   0,   0
	.byte	  1,   3,   5,   0,   0,   0,   0,   0,   0,   1,   3,   5,   0,   0,   0,   0
	.byte	  2,   3,   5,   0,   0,   0,   0,   0,   0,   2,   3,   5,   0,   0,   0,   0
	.byte	  1,   2,   3,   5,   0,   0,   0,   0,   0,   1,   2,   3,   5,   0,   0,   0
	.byte	  4,   5,   0,   0,   0,   0,   0,   0,   0,   4,   5,   0,   0,   0,   0,   0
	.byte	  1,   4,   5,   0,   0,   0,   0,   0,   0,   1,   4,   5,   0,   0,   0,   0
	.byte	  2,   4,   5,   0,   0,   0,   0,   0,   0,   2,   4,   5,   0,   0,   0,   0
	.byte	  1,   2,   4,   5,   0,   0,   0,   0,   0,   1,   2,   4,   5,   0,   0,   0
	.byte	  3,   4,   5,   0,   0,   0,   0,   0,   0,   3,   4,   5,   0,   0,   0,   0
	.byte	  1,   3,   4,   5,   0,   0,   0,   0,   0,   1,   3,   4,   5,   0,   0,   0
	.byte	  2,   3,   4,   5,   0,   0,   0,   0,   0,   2,   3,   4,   5,   0,   0,   0
	.byte	  1,   2,   3,   4,   5,   0,   0,   0,   0,   1,   2,   3,   4,   5,   0,   0
	.byte	  6,   0,   0,   0,   0,   0,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0
	.byte	  1,   6,   0,   0,   0,   0,   0,   0,   0,   1,   6,   0,   0,   0,   0,   0
	.byte	  2,   6,   0,   0,   0,   0,   0,   0,   0,   2,   6,   0,   0,   0,   0,   0
	.byte	  1,   2,   6,   0,   0,   0,   0,   0,   0,   1,   2,   6,   0,   0,   0,   0
	.byte	  3,   6,   0,   0,   0,   0,   0,   0,   0,   3,   6,   0,   0,   0,   0,   0
	.byte	  1,   3,   6,   0,   0,   0,   0,   0,   0,   1,   3,   6,   0,   0,   0,   0
	.byte	  2,   3,   6,   0,   0,   0,   0,   0,   0,   2,   3,   6,   0,   0,   0,   0
	.byte	  1,   2,   3,   6,   0,   0,   0,   0,   0,   1,   2,   3,   6,   0,   0,   0
	.byte	  4,   6,   0,   0,   0,   0,   0,   0,   0,   4,   6,   0,   0,   0,   0,   0
	.byte	  1,   4,   6,   0,   0,   0,   0,   0,   0,   1,   4,   6,   0,   0,   0,   0
	.byte	  2,   4,   6,   0,   0,   0,   0,   0,   0,   2,   4,   6,   0,   0,   0,   0
	.byte	  1,   2,   4,   6,   0,   0,   0,   0,   0,   1,   2,   4,   6,   0,   0,   0
	.byte	  3,   4,   6,   0,   0,   0,   0,   0,   0,   3,   4,   6,   0,   0,   0,   0
	.byte	  1,   3,   4,   6,   0,   0,   0,   0,   0,   1,   3,   4,   6,   0,   0,   0
	.byte	  2,   3,   4,   6,   0,   0,   0,   0,   0,   2,   3,   4,   6,   0,   0,   0
	.byte	  1,   2,   3,   4,   6,   0,   0,   0,   0,   1,   2,   3,   4,   6,   0,   0
	.byte	  5,   6,   0,   0,   0,   0,   0,   0,   0,   5,   6,   0,   0,   0,   0,   0
	.byte	  1,   5,   6,   0,   0,   0,   0,   0,   0,   1,   5,   6,   0,   0,   0,   0
	.byte	  2,   5,   6,   0,   0,   0,   0,   0,   0,   2,   5,   6,   0,   0,   0,   0
	.byte	  1,   2,   5,   6,   0,   0,   0,   0,   0,   1,   2,   5,   6,   0,   0,   0
	.byte	  3,   5,   6,   0,   0,   0,   0,   0,   0,   3,   5,   6,   0,   0,   0,   0
	.byte	  1,   3,   5,   6,   0,   0,   0,   0,   0,   1,   3,   5,   6,   0,   0,   0
	.byte	  2,   3,   5,   6,   0,   0,   0,   0,   0,   2,   3,   5,   6,   0,   0,   0
	.byte	  1,   2,   3,   5,   6,   0,   0,   0,   0,   1,   2,   3,   5,   6,   0,   0
	.byte	  4,   5,   6,   0,   0,   0,   0,   0,   0,   4,   5,   6,   0,   0,   0,   0
	.byte	  1,   4,   5,   6,   0,   0,   0,   0,   0,   1,   4,   5,   6,   0,   0,   0
	.byte	  2,   4,   5,   6,   0,   0,   0,   0,   0,   2,   4,   5,   6,   0,   0,   0
	.byte	  1,   2,   4,   5,   6,   0,   0,   0,   0,   1,   2,   4,   5,   6,   0,   0
	.byte	  3,   4,   5,   6,   0,   0,   0,   0,   0,   3,   4,   5,   6,   0,   0,   0
	.byte	  1,   3,   4,   5,   6,   0,   0,   0,   0,   1,   3,   4,   5,   6,   0,   0
	.byte	  2,   3,   4,   5,   6,   0,   0,   0,   0,   2,   3,   4,   5,   6,   0,   0
	.byte	  1,   2,   3,   4,   5,   6,   0,   0,   0,   1,   2,   3,   4,   5,   6,   0
	.byte	  7,   0,   0,   0,   0,   0,   0,   0,   0,   7,   0,   0,   0,   0,   0,   0
	.byte	  1,   7,   0,   0,   0,   0,   0,   0,   0,   1,   7,   0,   0,   0,   0,   0
	.byte	  2,   7,   0,   0,   0,   0,   0,   0,   0,   2,   7,   0,   0,   0,   0,   0
	.byte	  1,   2,   7,   0,   0,   0,   0,   0,   0,   1,   2,   7,   0,   0,   0,   0
	.byte	  3,   7,   0,   0,   0,   0,   0,   0,   0,   3,   7,   0,   0,   0,   0,   0
	.byte	  1,   3,   7,   0,   0,   0,   0,   0,   0,   1,   3,   7,   0,   0,   0,   0
	.byte	  2,   3,   7,   0,   0,   0,   0,   0,   0,   2,   3,   7,   0,   0,   0,   0
	.byte	  1,   2,   3,   7,   0,   0,   0,   0,   0,   1,   2,   3,   7,   0,   0,   0
	.byte	  4,   7,   0,   0,   0,   0,   0,   0,   0,   4,   7,   0,   0,   0,   0,   0
	.byte	  1,   4,   7,   0,   0,   0,   0,   0,   0,   1,   4,   7,   0,   0,   0,   0
	.byte	  2,   4,   7,   0,   0,   0,   0,   0,   0,   2,   4,   7,   0,   0,   0,   0
	.byte	  1,   2,   4,   7,   0,   0,   0,   0,   0,   1,   2,   4,   7,   0,   0,   0
	.byte	  3,   4,   7,   0,   0,   0,   0,   0,   0,   3,   4,   7,   0,   0,   0,   0
	.byte	  1,   3,   4,   7,   0,   0,   0,   0,   0,   1,   3,   4,   7,   0,   0,   0
	.byte	  2,   3,   4,   7,   0,   0,   0,   0,   0,   2,   3,   4,   7,   0,   0,   0
	.byte	  1,   2,   3,   4,   7,   0,   0,   0,   0,   1,   2,   3,   4,   7,   0,   0
	.byte	  5,   7,   0,   0,   0,   0,   0,   0,   0,   5,   7,   0,   0,   0,   0,   0
	.byte	  1,   5,   7,   0,   0,   0,   0,   0,   0,   1,   5,   7,   0,   0,   0,   0
	.byte	  2,   5,   7,   0,   0,   0,   0,   0,   0,   2,   5,   7,   0,   0,   0,   0
	.byte	  1,   2,   5,   7,   0,   0,   0,   0,   0,   1,   2,   5,   7,   0,   0,   0
	.byte	  3,   5,   7,   0,   0,   0,   0,   0,   0,   3,   5,   7,   0,   0,   0,   0
	.byte	  1,   3,   5,   7,   0,   0,   0,   0,   0,   1,   3,   5,   7,   0,   0,   0
	.byte	  2,   3,   5,   7,   0,   0,   0,   0,   0,   2,   3,   5,   7,   0,   0,   0
	.byte	  1,   2,   3,   5,   7,   0,   0,   0,   0,   1,   2,   3,   5,   7,   0,   0
	.byte	  4,   5,   7,   0,   0,   0,   0,   0,   0,   4,   5,   7,   0,   0,   0,   0
	.byte	  1,   4,   5,   7,   0,   0,   0,   0,   0,   1,   4,   5,   7,   0,   0,   0
	.byte	  2,   4,   5,   7,   0,   0,   0,   0,   0,   2,   4,   5,   7,   0,   0,   0
	.byte	  1,   2,   4,   5,   7,   0,   0,   0,   0,   1,   2,   4,   5,   7,   0,   0
	.byte	  3,   4,   5,   7,   0,   0,   0,   0,   0,   3,   4,   5,   7,   0,   0,   0
	.byte	  1,   3,   4,   5,   7,   0,   0,   0,   0,   1,   3,   4,   5,   7,   0,   0
	.byte	  2,   3,   4,   5,   7,   0,   0,   0,   0,   2,   3,   4,   5,   7,   0,   0
	.byte	  1,   2,   3,   4,   5,   7,   0,   0,   0,   1,   2,   3,   4,   5,   7,   0
	.byte	  6,   7,   0,   0,   0,   0,   0,   0,   0,   6,   7,   0,   0,   0,   0,   0
	.byte	  1,   6,   7,   0,   0,   0,   0,   0,   0,   1,   6,   7,   0,   0,   0,   0
	.byte	  2,   6,   7,   0,   0,   0,   0,   0,   0,   2,   6,   7,   0,   0,   0,   0
	.byte	  1,   2,   6,   7,   0,   0,   0,   0,   0,   1,   2,   6,   7,   0,   0,   0
	.byte	  3,   6,   7,   0,   0,   0,   0,   0,   0,   3,   6,   7,   0,   0,   0,   0
	.byte	  1,   3,   6,   7,   0,   0,   0,   0,   0,   1,   3,   6,   7,   0,   0,   0
	.byte	  2,   3,   6,   7,   0,   0,   0,   0,   0,   2,   3,   6,   7,   0,   0,   0
	.byte	  1,   2,   3,   6,   7,   0,   0,   0,   0,   1,   2,   3,   6,   7,   0,   0
	.byte	  4,   6,   7,   0,   0,   0,   0,   0,   0,   4,   6,   7,   0,   0,   0,   0
	.byte	  1,   4,   6,   7,   0,   0,   0,   0,   0,   1,   4,   6,   7,   0,   0,   0
	.byte	  2,   4,   6,   7,   0,   0,   0,   0,   0,   2,   4,   6,   7,   0,   0,   0
	.byte	  1,   2,   4,   6,   7,   0,   0,   0,   0,   1,   2,   4,   6,   7,   0,   0
	.byte	  3,   4,   6,   7,   0,   0,   0,   0,   0,   3,   4,   6,   7,   0,   0,   0
	.byte	  1,   3,   4,   6,   7,   0,   0,   0,   0,   1,   3,   4,   6,   7,   0,   0
	.byte	  2,   3,   4,   6,   7,   0,   0,   0,   0,   2,   3,   4,   6,   7,   0,   0
	.byte	  1,   2,   3,   4,   6,   7,   0,   0,   0,   1,   2,   3,   4,   6,   7,   0
	.byte	  5,   6,   7,   0,   0,   0,   0,   0,   0,   5,   6,   7,   0,   0,   0,   0
	.byte	  1,   5,   6,   7,   0,   0,   0,   0,   0,   1,   5,   6,   7,   0,   0,   0
	.byte	  2,   5,   6,   7,   0,   0,   0,   0,   0,   2,   5,   6,   7,   0,   0,   0
	.byte	  1,   2,   5,   6,   7,   0,   0,   0,   0,   1,   2,   5,   6,   7,   0,   0
	.byte	  3,   5,   6,   7,   0,   0,   0,   0,   0,   3,   5,   6,   7,   0,   0,   0
	.byte	  1,   3,   5,   6,   7,   0,   0,   0,   0,   1,   3,   5,   6,   7,   0,   0
	.byte	  2,   3,   5,   6,   7,   0,   0,   0,   0,   2,   3,   5,   6,   7,   0,   0
	.byte	  1,   2,   3,   5,   6,   7,   0,   0,   0,   1,   2,   3,   5,   6,   7,   0
	.byte	  4,   5,   6,   7,   0,   0,   0,   0,   0,   4,   5,   6,   7,   0,   0,   0
	.byte	  1,   4,   5,   6,   7,   0,   0,   0,   0,   1,   4,   5,   6,   7,   0,   0
	.byte	  2,   4,   5,   6,   7,   0,   0,   0,   0,   2,   4,   5,   6,   7,   0,   0
	.byte	  1,   2,   4,   5,   6,   7,   0,   0,   0,   1,   2,   4,   5,   6,   7,   0
	.byte	  3,   4,   5,   6,   7,   0,   0,   0,   0,   3,   4,   5,   6,   7,   0,   0
	.byte	  1,   3,   4,   5,   6,   7,   0,   0,   0,   1,   3,   4,   5,   6,   7,   0
	.byte	  2,   3,   4,   5,   6,   7,   0,   0,   0,   2,   3,   4,   5,   6,   7,   0
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   0,   1,   2,   3,   4,   5,   6,   7
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
G$ZETAS_TO_INVERT_LAYER_6:
	.byte	  3,  21, 248, 255,   2,  49, 216, 255
G$ZETAS_TO_INVERT_LAYER_5:
	.byte	 36,  30,   7,   0,  40, 161, 242, 255,  24,  33, 244, 255,  68, 158,   3,   0
G$ZETAS_TO_INVERT_LAYER_4:
	.byte	 39, 229,  40,   0,  73, 122,  47,   0,   9, 251, 211, 255, 117, 154,  47,   0
	.byte	127,  20, 224, 255, 173, 132, 250, 255,  43, 233,  35,   0,  43, 222,  27,   0
G$ZETAS_TO_INVERT_LAYER_3:
	.byte	197,  69,   4,   0,   1,  50,  61,   0,  34, 180, 255, 255,  53, 208,  26,   0
	.byte	152, 252, 205, 255, 247, 164, 234, 255, 231,  26, 197, 255, 214, 173, 223, 255
	.byte	123, 211, 223, 255, 104, 249,  39,   0, 160, 234, 238, 255, 144, 157, 247, 255
	.byte	136, 183,  54,   0, 164, 133, 239, 255, 112, 160,  15,   0,  88, 150,  41,   0
G$commitment__ENCODING_CONSTANTS_TABLE_bits6:
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   1,   0,   0,   0,   5,   0,   0,   0
	.byte	  2,   0,   0,   0,   6,   0,   0,   0,   3,   0,   0,   0,   7,   0,   0,   0
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
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
G$polynomial__CONSTANTS_TABLE_gamma2_88:
	.byte	 11,  44,   0,   0,  11,  44,   0,   0,  11,  44,   0,   0,  11,  44,   0,   0
	.byte	 11,  44,   0,   0,  11,  44,   0,   0,  11,  44,   0,   0,  11,  44,   0,   0
	.byte	  0, 232,   2,   0,   0, 232,   2,   0,   0, 232,   2,   0,   0, 232,   2,   0
	.byte	  0, 232,   2,   0,   0, 232,   2,   0,   0, 232,   2,   0,   0, 232,   2,   0
	.byte	127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0
	.byte	127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0, 127,   0,   0,   0
	.byte	128,   0,   0,   0, 128,   0,   0,   0, 128,   0,   0,   0, 128,   0,   0,   0
	.byte	128,   0,   0,   0, 128,   0,   0,   0, 128,   0,   0,   0, 128,   0,   0,   0
	.byte	 43,   0,   0,   0,  43,   0,   0,   0,  43,   0,   0,   0,  43,   0,   0,   0
	.byte	 43,   0,   0,   0,  43,   0,   0,   0,  43,   0,   0,   0,  43,   0,   0,   0
G$gamma1__DECODING_SHIFTS_TABLE_bits18:
	.byte	  0,   1,   2, 255,   2,   3,   4, 255,   4,   5,   6, 255,   6,   7,   8, 255
	.byte	  7,   8,   9, 255,   9,  10,  11, 255,  11,  12,  13, 255,  13,  14,  15, 255
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   4,   0,   0,   0,   6,   0,   0,   0
	.byte	  0,   0,   0,   0,   2,   0,   0,   0,   4,   0,   0,   0,   6,   0,   0,   0
G$gamma1__ENCODING_SHIFTS_TABLE_bits18:
	.byte	 14,   0,   0,   0,   0,   0,   0,   0,  14,   0,   0,   0,   0,   0,   0,   0
	.byte	 14,   0,   0,   0,   0,   0,   0,   0,  14,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,  28,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,  28,   0,   0,   0,   0,   0,   0,   0
G$error_polynomial__ETA2_ENCODING_CONSTANTS:
	.byte	  1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8
	.byte	  1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8,   1,   8
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
	.byte	  0,   1,   8,   9,   2,   3,  10,  11,   4,   5,  12,  13,   6,   7,  14,  15
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
