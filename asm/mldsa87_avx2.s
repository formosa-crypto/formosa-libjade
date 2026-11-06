	.att_syntax
	.text
	.p2align	5
	.global	ml_dsa_87_verify
	.global	ml_dsa_87_sign
	.global	ml_dsa_87_keygen
	.type	ml_dsa_87_verify, %function
ml_dsa_87_verify:
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
	movq	(%rsi), %rax
	movq	8(%rsi), %rsi
	lfence
	movq	$0, %r10
	cmpq	$255, %rsi
	jbe 	.Lml_dsa_87_verify$1
	movq	$-1, %r11
	jmp 	.Lml_dsa_87_verify$2
.Lml_dsa_87_verify$1:
	leaq	-97080(%rsp), %rsp
	call	.L__verify_internal$1
.Lml_dsa_87_verify$3:
	leaq	97080(%rsp), %rsp
.Lml_dsa_87_verify$2:
	movq	%r11, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_87_sign, %function
ml_dsa_87_sign:
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
	jbe 	.Lml_dsa_87_sign$1
	movq	$-1, %rax
	jmp 	.Lml_dsa_87_sign$2
.Lml_dsa_87_sign$1:
	leaq	-169880(%rsp), %rsp
	call	.L__sign_internal$1
.Lml_dsa_87_sign$3:
	leaq	169880(%rsp), %rsp
.Lml_dsa_87_sign$2:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_87_keygen, %function
ml_dsa_87_keygen:
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
	leaq	-95768(%rsp), %rsp
	call	.L__keygen_internal$1
.Lml_dsa_87_keygen$1:
	leaq	95768(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
.L__verify_internal$1:
	movq	%rax, 96992(%rsp)
	movq	%rsi, 97000(%rsp)
	movq	%rdx, 97008(%rsp)
	movq	%rcx, 97016(%rsp)
	leaq	7904(%rsp), %rax
	leaq	15072(%rsp), %rcx
	leaq	64(%r8), %rdx
	movq	%rax, %rsi
	movq	%rdx, %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$619
.L__verify_internal$620:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$619:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$620
	leaq	1024(%rax), %rsi
	leaq	640(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$617
.L__verify_internal$618:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$617:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$618
	leaq	2048(%rax), %rsi
	leaq	1280(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$615
.L__verify_internal$616:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$615:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$616
	leaq	3072(%rax), %rsi
	leaq	1920(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$613
.L__verify_internal$614:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$613:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$614
	leaq	4096(%rax), %rsi
	leaq	2560(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$611
.L__verify_internal$612:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$611:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$612
	leaq	5120(%rax), %rsi
	leaq	3200(%rdx), %r9
	movq	$524288, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %r10
	vmovq	%r10, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$609
.L__verify_internal$610:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$609:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$610
	leaq	6144(%rax), %rsi
	leaq	3840(%rdx), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$607
.L__verify_internal$608:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$607:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$608
	leaq	4544(%r8), %rax
	lfence
	movq	$0, %r9
	movq	$0, %r11
	movq	$0, %r12
	movq	$0, %rdx
	jmp 	.L__verify_internal$589
.L__verify_internal$590:
	movq	$-1, %rsi
	cmovne	%rsi, %r9
	movq	%rdx, %rsi
	shlq	$8, %rsi
	movq	$0, %r10
	jmp 	.L__verify_internal$605
.L__verify_internal$606:
	movq	$-1, %rbx
	cmovnb	%rbx, %r9
	movq	%rsi, %rbx
	addq	%r10, %rbx
	movl	$0, (%rcx,%rbx,4)
	incq	%r10
.L__verify_internal$605:
	cmpq	$256, %r10
	jb  	.L__verify_internal$606
	movq	$-1, %r10
	cmovb	%r10, %r9
	movzbq	75(%rax,%rdx), %r10
	orq 	%r9, %r10
	cmpq	%r12, %r10
	jb  	.L__verify_internal$593
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	cmpq	$75, %r10
	jnbe	.L__verify_internal$595
	movq	$-1, %rbx
	cmovnbe	%rbx, %r9
	movq	%r12, %rbx
	jmp 	.L__verify_internal$597
.L__verify_internal$598:
	movq	$-1, %rbp
	cmovne	%rbp, %r9
	movzbq	(%rax,%rbx), %rbp
	orq 	%r9, %rbp
	cmpq	%r12, %rbx
	jnbe	.L__verify_internal$601
	movq	$-1, %r13
	cmovnbe	%r13, %r9
	jmp 	.L__verify_internal$602
.L__verify_internal$601:
	movq	$-1, %r13
	cmovbe	%r13, %r9
	movzbq	-1(%rax,%rbx), %r13
	orq 	%r9, %r13
	cmpq	%r13, %rbp
	jbe 	.L__verify_internal$603
	movq	$-1, %r13
	cmovbe	%r13, %r9
	jmp 	.L__verify_internal$602
.L__verify_internal$603:
	movq	$-1, %r11
	cmovnbe	%r11, %r9
	movq	$1, %r11
.L__verify_internal$604:
.L__verify_internal$602:
	cmpq	$0, %r11
	je  	.L__verify_internal$599
	movq	$-1, %rbp
	cmove	%rbp, %r9
	jmp 	.L__verify_internal$597
.L__verify_internal$599:
	movq	$-1, %r13
	cmovne	%r13, %r9
	movq	%rsi, %r13
	addq	%rbp, %r13
	movl	$1, (%rcx,%r13,4)
	incq	%rbx
.L__verify_internal$600:
.L__verify_internal$597:
	cmpq	%r10, %rbx
	setnb	%bpl
	orb 	%r11b, %bpl
	cmpb	$0, %bpl
	je  	.L__verify_internal$598
	movq	$-1, %rsi
	cmove	%rsi, %r9
	jmp 	.L__verify_internal$594
.L__verify_internal$595:
	movq	$-1, %rsi
	cmovbe	%rsi, %r9
	movq	$1, %r11
.L__verify_internal$596:
	jmp 	.L__verify_internal$594
.L__verify_internal$593:
	movq	$-1, %rsi
	cmovnb	%rsi, %r9
	movq	$1, %r11
.L__verify_internal$594:
	cmpq	$0, %r11
	je  	.L__verify_internal$591
	movq	$-1, %rsi
	cmove	%rsi, %r9
	jmp 	.L__verify_internal$589
.L__verify_internal$591:
	movq	$-1, %rsi
	cmovne	%rsi, %r9
	movq	%r10, %r12
	incq	%rdx
.L__verify_internal$592:
.L__verify_internal$589:
	cmpq	$8, %rdx
	setnb	%sil
	orb 	%r11b, %sil
	cmpb	$0, %sil
	je  	.L__verify_internal$590
	movq	$-1, %rcx
	cmove	%rcx, %r9
	jmp 	.L__verify_internal$583
.L__verify_internal$584:
	movq	$-1, %rcx
	cmovne	%rcx, %r9
	movzbq	(%rax,%r12), %rcx
	orq 	%r9, %rcx
	cmpq	$0, %rcx
	jne 	.L__verify_internal$587
	movq	$-1, %rcx
	cmovne	%rcx, %r9
	jmp 	.L__verify_internal$588
.L__verify_internal$587:
	movq	$-1, %rcx
	cmove	%rcx, %r9
	movq	$1, %r11
.L__verify_internal$588:
	cmpq	$0, %r11
	je  	.L__verify_internal$585
	movq	$-1, %rcx
	cmove	%rcx, %r9
	jmp 	.L__verify_internal$583
.L__verify_internal$585:
	movq	$-1, %rcx
	cmovne	%rcx, %r9
	incq	%r12
.L__verify_internal$586:
.L__verify_internal$583:
	cmpq	$75, %r12
	setnb	%cl
	orb 	%r11b, %cl
	cmpb	$0, %cl
	je  	.L__verify_internal$584
	negq	%r11
	leaq	7904(%rsp), %rax
	movq	$0, %rcx
	movq	%rax, %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$581
.L__verify_internal$582:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$581:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$582
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	1024(%rax), %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$579
.L__verify_internal$580:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$579:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$580
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	2048(%rax), %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$577
.L__verify_internal$578:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$577:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$578
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	3072(%rax), %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$575
.L__verify_internal$576:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$575:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$576
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	4096(%rax), %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$573
.L__verify_internal$574:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$573:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$574
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	5120(%rax), %rsi
	movq	$524167, %r10
	vmovq	%r10, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$571
.L__verify_internal$572:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$571:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$572
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	6144(%rax), %rsi
	movq	$524167, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$569
.L__verify_internal$570:
	vmovdqu	(%rsi,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$569:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$570
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
	movq	%r8, 97024(%rsp)
	movq	%rdi, 97032(%rsp)
	vmovdqu	(%rdi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 97040(%rsp)
	movw	$1, 97042(%rsp)
	movw	$2, 97044(%rsp)
	movw	$3, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$568:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$567:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$566:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$565:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$564:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$563:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	39648(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$562:
	movq	%r11, %rax
	leaq	40672(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$561:
	movq	%r11, %rcx
	leaq	41696(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$560:
	movq	%r11, %rdx
	leaq	42720(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$559:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$552
	cmpq	$256, %rcx
	jb  	.L__verify_internal$554
	cmpq	$256, %rdx
	jb  	.L__verify_internal$556
	cmpq	$256, %r11
	jnb 	.L__verify_internal$538
	movl	$0, %esi
.L__verify_internal$558:
	jmp 	.L__verify_internal$538
.L__verify_internal$556:
	movl	$0, %esi
.L__verify_internal$557:
	jmp 	.L__verify_internal$538
.L__verify_internal$554:
	movl	$0, %esi
.L__verify_internal$555:
	jmp 	.L__verify_internal$538
.L__verify_internal$552:
	movl	$0, %esi
.L__verify_internal$553:
	jmp 	.L__verify_internal$538
.L__verify_internal$539:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$551:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	39648(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$550:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	40672(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$549:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	41696(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$548:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	42720(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$547:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$540
	cmpq	$256, %rcx
	jb  	.L__verify_internal$542
	cmpq	$256, %rdx
	jb  	.L__verify_internal$544
	cmpq	$256, %r11
	jnb 	.L__verify_internal$538
	movl	$0, %esi
.L__verify_internal$546:
	jmp 	.L__verify_internal$538
.L__verify_internal$544:
	movl	$0, %esi
.L__verify_internal$545:
	jmp 	.L__verify_internal$538
.L__verify_internal$542:
	movl	$0, %esi
.L__verify_internal$543:
	jmp 	.L__verify_internal$538
.L__verify_internal$540:
	movl	$0, %esi
.L__verify_internal$541:
.L__verify_internal$538:
	cmpl	$1, %esi
	jne 	.L__verify_internal$539
	movw	$4, 97040(%rsp)
	movw	$5, 97042(%rsp)
	movw	$6, 97044(%rsp)
	movw	$256, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$537:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$536:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$535:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$534:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$533:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$532:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	43744(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$531:
	movq	%r11, %rax
	leaq	44768(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$530:
	movq	%r11, %rcx
	leaq	45792(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$529:
	movq	%r11, %rdx
	leaq	46816(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$528:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$521
	cmpq	$256, %rcx
	jb  	.L__verify_internal$523
	cmpq	$256, %rdx
	jb  	.L__verify_internal$525
	cmpq	$256, %r11
	jnb 	.L__verify_internal$507
	movl	$0, %esi
.L__verify_internal$527:
	jmp 	.L__verify_internal$507
.L__verify_internal$525:
	movl	$0, %esi
.L__verify_internal$526:
	jmp 	.L__verify_internal$507
.L__verify_internal$523:
	movl	$0, %esi
.L__verify_internal$524:
	jmp 	.L__verify_internal$507
.L__verify_internal$521:
	movl	$0, %esi
.L__verify_internal$522:
	jmp 	.L__verify_internal$507
.L__verify_internal$508:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$520:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	43744(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$519:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	44768(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$518:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	45792(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$517:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	46816(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$516:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$509
	cmpq	$256, %rcx
	jb  	.L__verify_internal$511
	cmpq	$256, %rdx
	jb  	.L__verify_internal$513
	cmpq	$256, %r11
	jnb 	.L__verify_internal$507
	movl	$0, %esi
.L__verify_internal$515:
	jmp 	.L__verify_internal$507
.L__verify_internal$513:
	movl	$0, %esi
.L__verify_internal$514:
	jmp 	.L__verify_internal$507
.L__verify_internal$511:
	movl	$0, %esi
.L__verify_internal$512:
	jmp 	.L__verify_internal$507
.L__verify_internal$509:
	movl	$0, %esi
.L__verify_internal$510:
.L__verify_internal$507:
	cmpl	$1, %esi
	jne 	.L__verify_internal$508
	movw	$257, 97040(%rsp)
	movw	$258, 97042(%rsp)
	movw	$259, 97044(%rsp)
	movw	$260, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$506:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$505:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$504:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$503:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$502:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$501:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	47840(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$500:
	movq	%r11, %rax
	leaq	48864(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$499:
	movq	%r11, %rcx
	leaq	49888(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$498:
	movq	%r11, %rdx
	leaq	50912(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$497:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$490
	cmpq	$256, %rcx
	jb  	.L__verify_internal$492
	cmpq	$256, %rdx
	jb  	.L__verify_internal$494
	cmpq	$256, %r11
	jnb 	.L__verify_internal$476
	movl	$0, %esi
.L__verify_internal$496:
	jmp 	.L__verify_internal$476
.L__verify_internal$494:
	movl	$0, %esi
.L__verify_internal$495:
	jmp 	.L__verify_internal$476
.L__verify_internal$492:
	movl	$0, %esi
.L__verify_internal$493:
	jmp 	.L__verify_internal$476
.L__verify_internal$490:
	movl	$0, %esi
.L__verify_internal$491:
	jmp 	.L__verify_internal$476
.L__verify_internal$477:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$489:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	47840(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$488:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	48864(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$487:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	49888(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$486:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	50912(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$485:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$478
	cmpq	$256, %rcx
	jb  	.L__verify_internal$480
	cmpq	$256, %rdx
	jb  	.L__verify_internal$482
	cmpq	$256, %r11
	jnb 	.L__verify_internal$476
	movl	$0, %esi
.L__verify_internal$484:
	jmp 	.L__verify_internal$476
.L__verify_internal$482:
	movl	$0, %esi
.L__verify_internal$483:
	jmp 	.L__verify_internal$476
.L__verify_internal$480:
	movl	$0, %esi
.L__verify_internal$481:
	jmp 	.L__verify_internal$476
.L__verify_internal$478:
	movl	$0, %esi
.L__verify_internal$479:
.L__verify_internal$476:
	cmpl	$1, %esi
	jne 	.L__verify_internal$477
	movw	$261, 97040(%rsp)
	movw	$262, 97042(%rsp)
	movw	$512, 97044(%rsp)
	movw	$513, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$475:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$474:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$473:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$472:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$471:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$470:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	51936(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$469:
	movq	%r11, %rax
	leaq	52960(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$468:
	movq	%r11, %rcx
	leaq	53984(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$467:
	movq	%r11, %rdx
	leaq	55008(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$466:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$459
	cmpq	$256, %rcx
	jb  	.L__verify_internal$461
	cmpq	$256, %rdx
	jb  	.L__verify_internal$463
	cmpq	$256, %r11
	jnb 	.L__verify_internal$445
	movl	$0, %esi
.L__verify_internal$465:
	jmp 	.L__verify_internal$445
.L__verify_internal$463:
	movl	$0, %esi
.L__verify_internal$464:
	jmp 	.L__verify_internal$445
.L__verify_internal$461:
	movl	$0, %esi
.L__verify_internal$462:
	jmp 	.L__verify_internal$445
.L__verify_internal$459:
	movl	$0, %esi
.L__verify_internal$460:
	jmp 	.L__verify_internal$445
.L__verify_internal$446:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$458:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	51936(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$457:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	52960(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$456:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	53984(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$455:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	55008(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$454:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$447
	cmpq	$256, %rcx
	jb  	.L__verify_internal$449
	cmpq	$256, %rdx
	jb  	.L__verify_internal$451
	cmpq	$256, %r11
	jnb 	.L__verify_internal$445
	movl	$0, %esi
.L__verify_internal$453:
	jmp 	.L__verify_internal$445
.L__verify_internal$451:
	movl	$0, %esi
.L__verify_internal$452:
	jmp 	.L__verify_internal$445
.L__verify_internal$449:
	movl	$0, %esi
.L__verify_internal$450:
	jmp 	.L__verify_internal$445
.L__verify_internal$447:
	movl	$0, %esi
.L__verify_internal$448:
.L__verify_internal$445:
	cmpl	$1, %esi
	jne 	.L__verify_internal$446
	movw	$514, 97040(%rsp)
	movw	$515, 97042(%rsp)
	movw	$516, 97044(%rsp)
	movw	$517, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$444:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$443:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$442:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$441:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$440:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$439:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	56032(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$438:
	movq	%r11, %rax
	leaq	57056(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$437:
	movq	%r11, %rcx
	leaq	58080(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$436:
	movq	%r11, %rdx
	leaq	59104(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$435:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$428
	cmpq	$256, %rcx
	jb  	.L__verify_internal$430
	cmpq	$256, %rdx
	jb  	.L__verify_internal$432
	cmpq	$256, %r11
	jnb 	.L__verify_internal$414
	movl	$0, %esi
.L__verify_internal$434:
	jmp 	.L__verify_internal$414
.L__verify_internal$432:
	movl	$0, %esi
.L__verify_internal$433:
	jmp 	.L__verify_internal$414
.L__verify_internal$430:
	movl	$0, %esi
.L__verify_internal$431:
	jmp 	.L__verify_internal$414
.L__verify_internal$428:
	movl	$0, %esi
.L__verify_internal$429:
	jmp 	.L__verify_internal$414
.L__verify_internal$415:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$427:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	56032(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$426:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	57056(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$425:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	58080(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$424:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	59104(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$423:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$416
	cmpq	$256, %rcx
	jb  	.L__verify_internal$418
	cmpq	$256, %rdx
	jb  	.L__verify_internal$420
	cmpq	$256, %r11
	jnb 	.L__verify_internal$414
	movl	$0, %esi
.L__verify_internal$422:
	jmp 	.L__verify_internal$414
.L__verify_internal$420:
	movl	$0, %esi
.L__verify_internal$421:
	jmp 	.L__verify_internal$414
.L__verify_internal$418:
	movl	$0, %esi
.L__verify_internal$419:
	jmp 	.L__verify_internal$414
.L__verify_internal$416:
	movl	$0, %esi
.L__verify_internal$417:
.L__verify_internal$414:
	cmpl	$1, %esi
	jne 	.L__verify_internal$415
	movw	$518, 97040(%rsp)
	movw	$768, 97042(%rsp)
	movw	$769, 97044(%rsp)
	movw	$770, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$413:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$412:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$411:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$410:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$409:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$408:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	60128(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$407:
	movq	%r11, %rax
	leaq	61152(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$406:
	movq	%r11, %rcx
	leaq	62176(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$405:
	movq	%r11, %rdx
	leaq	63200(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$404:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$397
	cmpq	$256, %rcx
	jb  	.L__verify_internal$399
	cmpq	$256, %rdx
	jb  	.L__verify_internal$401
	cmpq	$256, %r11
	jnb 	.L__verify_internal$383
	movl	$0, %esi
.L__verify_internal$403:
	jmp 	.L__verify_internal$383
.L__verify_internal$401:
	movl	$0, %esi
.L__verify_internal$402:
	jmp 	.L__verify_internal$383
.L__verify_internal$399:
	movl	$0, %esi
.L__verify_internal$400:
	jmp 	.L__verify_internal$383
.L__verify_internal$397:
	movl	$0, %esi
.L__verify_internal$398:
	jmp 	.L__verify_internal$383
.L__verify_internal$384:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$396:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	60128(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$395:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	61152(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$394:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	62176(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$393:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	63200(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$392:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$385
	cmpq	$256, %rcx
	jb  	.L__verify_internal$387
	cmpq	$256, %rdx
	jb  	.L__verify_internal$389
	cmpq	$256, %r11
	jnb 	.L__verify_internal$383
	movl	$0, %esi
.L__verify_internal$391:
	jmp 	.L__verify_internal$383
.L__verify_internal$389:
	movl	$0, %esi
.L__verify_internal$390:
	jmp 	.L__verify_internal$383
.L__verify_internal$387:
	movl	$0, %esi
.L__verify_internal$388:
	jmp 	.L__verify_internal$383
.L__verify_internal$385:
	movl	$0, %esi
.L__verify_internal$386:
.L__verify_internal$383:
	cmpl	$1, %esi
	jne 	.L__verify_internal$384
	movw	$771, 97040(%rsp)
	movw	$772, 97042(%rsp)
	movw	$773, 97044(%rsp)
	movw	$774, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$382:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$381:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$380:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$379:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$378:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$377:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	64224(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$376:
	movq	%r11, %rax
	leaq	65248(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$375:
	movq	%r11, %rcx
	leaq	66272(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$374:
	movq	%r11, %rdx
	leaq	67296(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$373:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$366
	cmpq	$256, %rcx
	jb  	.L__verify_internal$368
	cmpq	$256, %rdx
	jb  	.L__verify_internal$370
	cmpq	$256, %r11
	jnb 	.L__verify_internal$352
	movl	$0, %esi
.L__verify_internal$372:
	jmp 	.L__verify_internal$352
.L__verify_internal$370:
	movl	$0, %esi
.L__verify_internal$371:
	jmp 	.L__verify_internal$352
.L__verify_internal$368:
	movl	$0, %esi
.L__verify_internal$369:
	jmp 	.L__verify_internal$352
.L__verify_internal$366:
	movl	$0, %esi
.L__verify_internal$367:
	jmp 	.L__verify_internal$352
.L__verify_internal$353:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$365:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	64224(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$364:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	65248(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$363:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	66272(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$362:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	67296(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$361:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$354
	cmpq	$256, %rcx
	jb  	.L__verify_internal$356
	cmpq	$256, %rdx
	jb  	.L__verify_internal$358
	cmpq	$256, %r11
	jnb 	.L__verify_internal$352
	movl	$0, %esi
.L__verify_internal$360:
	jmp 	.L__verify_internal$352
.L__verify_internal$358:
	movl	$0, %esi
.L__verify_internal$359:
	jmp 	.L__verify_internal$352
.L__verify_internal$356:
	movl	$0, %esi
.L__verify_internal$357:
	jmp 	.L__verify_internal$352
.L__verify_internal$354:
	movl	$0, %esi
.L__verify_internal$355:
.L__verify_internal$352:
	cmpl	$1, %esi
	jne 	.L__verify_internal$353
	movw	$1024, 97040(%rsp)
	movw	$1025, 97042(%rsp)
	movw	$1026, 97044(%rsp)
	movw	$1027, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$351:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$350:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$349:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$348:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$347:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$346:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	68320(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$345:
	movq	%r11, %rax
	leaq	69344(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$344:
	movq	%r11, %rcx
	leaq	70368(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$343:
	movq	%r11, %rdx
	leaq	71392(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$342:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$335
	cmpq	$256, %rcx
	jb  	.L__verify_internal$337
	cmpq	$256, %rdx
	jb  	.L__verify_internal$339
	cmpq	$256, %r11
	jnb 	.L__verify_internal$321
	movl	$0, %esi
.L__verify_internal$341:
	jmp 	.L__verify_internal$321
.L__verify_internal$339:
	movl	$0, %esi
.L__verify_internal$340:
	jmp 	.L__verify_internal$321
.L__verify_internal$337:
	movl	$0, %esi
.L__verify_internal$338:
	jmp 	.L__verify_internal$321
.L__verify_internal$335:
	movl	$0, %esi
.L__verify_internal$336:
	jmp 	.L__verify_internal$321
.L__verify_internal$322:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$334:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	68320(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$333:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	69344(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$332:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	70368(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$331:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	71392(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$330:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$323
	cmpq	$256, %rcx
	jb  	.L__verify_internal$325
	cmpq	$256, %rdx
	jb  	.L__verify_internal$327
	cmpq	$256, %r11
	jnb 	.L__verify_internal$321
	movl	$0, %esi
.L__verify_internal$329:
	jmp 	.L__verify_internal$321
.L__verify_internal$327:
	movl	$0, %esi
.L__verify_internal$328:
	jmp 	.L__verify_internal$321
.L__verify_internal$325:
	movl	$0, %esi
.L__verify_internal$326:
	jmp 	.L__verify_internal$321
.L__verify_internal$323:
	movl	$0, %esi
.L__verify_internal$324:
.L__verify_internal$321:
	cmpl	$1, %esi
	jne 	.L__verify_internal$322
	movw	$1028, 97040(%rsp)
	movw	$1029, 97042(%rsp)
	movw	$1030, 97044(%rsp)
	movw	$1280, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$320:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$319:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$318:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$317:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$316:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$315:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	72416(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$314:
	movq	%r11, %rax
	leaq	73440(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$313:
	movq	%r11, %rcx
	leaq	74464(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$312:
	movq	%r11, %rdx
	leaq	75488(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$311:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$304
	cmpq	$256, %rcx
	jb  	.L__verify_internal$306
	cmpq	$256, %rdx
	jb  	.L__verify_internal$308
	cmpq	$256, %r11
	jnb 	.L__verify_internal$290
	movl	$0, %esi
.L__verify_internal$310:
	jmp 	.L__verify_internal$290
.L__verify_internal$308:
	movl	$0, %esi
.L__verify_internal$309:
	jmp 	.L__verify_internal$290
.L__verify_internal$306:
	movl	$0, %esi
.L__verify_internal$307:
	jmp 	.L__verify_internal$290
.L__verify_internal$304:
	movl	$0, %esi
.L__verify_internal$305:
	jmp 	.L__verify_internal$290
.L__verify_internal$291:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$303:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	72416(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$302:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	73440(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$301:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	74464(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$300:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	75488(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$299:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$292
	cmpq	$256, %rcx
	jb  	.L__verify_internal$294
	cmpq	$256, %rdx
	jb  	.L__verify_internal$296
	cmpq	$256, %r11
	jnb 	.L__verify_internal$290
	movl	$0, %esi
.L__verify_internal$298:
	jmp 	.L__verify_internal$290
.L__verify_internal$296:
	movl	$0, %esi
.L__verify_internal$297:
	jmp 	.L__verify_internal$290
.L__verify_internal$294:
	movl	$0, %esi
.L__verify_internal$295:
	jmp 	.L__verify_internal$290
.L__verify_internal$292:
	movl	$0, %esi
.L__verify_internal$293:
.L__verify_internal$290:
	cmpl	$1, %esi
	jne 	.L__verify_internal$291
	movw	$1281, 97040(%rsp)
	movw	$1282, 97042(%rsp)
	movw	$1283, 97044(%rsp)
	movw	$1284, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$289:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$288:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$287:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$286:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$285:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$284:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	76512(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$283:
	movq	%r11, %rax
	leaq	77536(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$282:
	movq	%r11, %rcx
	leaq	78560(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$281:
	movq	%r11, %rdx
	leaq	79584(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$280:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$273
	cmpq	$256, %rcx
	jb  	.L__verify_internal$275
	cmpq	$256, %rdx
	jb  	.L__verify_internal$277
	cmpq	$256, %r11
	jnb 	.L__verify_internal$259
	movl	$0, %esi
.L__verify_internal$279:
	jmp 	.L__verify_internal$259
.L__verify_internal$277:
	movl	$0, %esi
.L__verify_internal$278:
	jmp 	.L__verify_internal$259
.L__verify_internal$275:
	movl	$0, %esi
.L__verify_internal$276:
	jmp 	.L__verify_internal$259
.L__verify_internal$273:
	movl	$0, %esi
.L__verify_internal$274:
	jmp 	.L__verify_internal$259
.L__verify_internal$260:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$272:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	76512(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$271:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	77536(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$270:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	78560(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$269:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	79584(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$268:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$261
	cmpq	$256, %rcx
	jb  	.L__verify_internal$263
	cmpq	$256, %rdx
	jb  	.L__verify_internal$265
	cmpq	$256, %r11
	jnb 	.L__verify_internal$259
	movl	$0, %esi
.L__verify_internal$267:
	jmp 	.L__verify_internal$259
.L__verify_internal$265:
	movl	$0, %esi
.L__verify_internal$266:
	jmp 	.L__verify_internal$259
.L__verify_internal$263:
	movl	$0, %esi
.L__verify_internal$264:
	jmp 	.L__verify_internal$259
.L__verify_internal$261:
	movl	$0, %esi
.L__verify_internal$262:
.L__verify_internal$259:
	cmpl	$1, %esi
	jne 	.L__verify_internal$260
	movw	$1285, 97040(%rsp)
	movw	$1286, 97042(%rsp)
	movw	$1536, 97044(%rsp)
	movw	$1537, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$258:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$257:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$256:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$255:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$254:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$253:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	80608(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$252:
	movq	%r11, %rax
	leaq	81632(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$251:
	movq	%r11, %rcx
	leaq	82656(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$250:
	movq	%r11, %rdx
	leaq	83680(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$249:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$242
	cmpq	$256, %rcx
	jb  	.L__verify_internal$244
	cmpq	$256, %rdx
	jb  	.L__verify_internal$246
	cmpq	$256, %r11
	jnb 	.L__verify_internal$228
	movl	$0, %esi
.L__verify_internal$248:
	jmp 	.L__verify_internal$228
.L__verify_internal$246:
	movl	$0, %esi
.L__verify_internal$247:
	jmp 	.L__verify_internal$228
.L__verify_internal$244:
	movl	$0, %esi
.L__verify_internal$245:
	jmp 	.L__verify_internal$228
.L__verify_internal$242:
	movl	$0, %esi
.L__verify_internal$243:
	jmp 	.L__verify_internal$228
.L__verify_internal$229:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$241:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	80608(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$240:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	81632(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$239:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	82656(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$238:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	83680(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$237:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$230
	cmpq	$256, %rcx
	jb  	.L__verify_internal$232
	cmpq	$256, %rdx
	jb  	.L__verify_internal$234
	cmpq	$256, %r11
	jnb 	.L__verify_internal$228
	movl	$0, %esi
.L__verify_internal$236:
	jmp 	.L__verify_internal$228
.L__verify_internal$234:
	movl	$0, %esi
.L__verify_internal$235:
	jmp 	.L__verify_internal$228
.L__verify_internal$232:
	movl	$0, %esi
.L__verify_internal$233:
	jmp 	.L__verify_internal$228
.L__verify_internal$230:
	movl	$0, %esi
.L__verify_internal$231:
.L__verify_internal$228:
	cmpl	$1, %esi
	jne 	.L__verify_internal$229
	movw	$1538, 97040(%rsp)
	movw	$1539, 97042(%rsp)
	movw	$1540, 97044(%rsp)
	movw	$1541, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$227:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$226:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$225:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$224:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$223:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$222:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	84704(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$221:
	movq	%r11, %rax
	leaq	85728(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$220:
	movq	%r11, %rcx
	leaq	86752(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$219:
	movq	%r11, %rdx
	leaq	87776(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$218:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$211
	cmpq	$256, %rcx
	jb  	.L__verify_internal$213
	cmpq	$256, %rdx
	jb  	.L__verify_internal$215
	cmpq	$256, %r11
	jnb 	.L__verify_internal$197
	movl	$0, %esi
.L__verify_internal$217:
	jmp 	.L__verify_internal$197
.L__verify_internal$215:
	movl	$0, %esi
.L__verify_internal$216:
	jmp 	.L__verify_internal$197
.L__verify_internal$213:
	movl	$0, %esi
.L__verify_internal$214:
	jmp 	.L__verify_internal$197
.L__verify_internal$211:
	movl	$0, %esi
.L__verify_internal$212:
	jmp 	.L__verify_internal$197
.L__verify_internal$198:
	movq	%rax, 97072(%rsp)
	movq	%rcx, 97064(%rsp)
	movq	%rdx, 97056(%rsp)
	movq	%r11, 97048(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$210:
	movq	97072(%rsp), %r11
	movq	97064(%rsp), %rcx
	movq	97056(%rsp), %rdx
	movq	97048(%rsp), %r12
	leaq	84704(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$209:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	85728(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$208:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	86752(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$207:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	87776(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$206:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$199
	cmpq	$256, %rcx
	jb  	.L__verify_internal$201
	cmpq	$256, %rdx
	jb  	.L__verify_internal$203
	cmpq	$256, %r11
	jnb 	.L__verify_internal$197
	movl	$0, %esi
.L__verify_internal$205:
	jmp 	.L__verify_internal$197
.L__verify_internal$203:
	movl	$0, %esi
.L__verify_internal$204:
	jmp 	.L__verify_internal$197
.L__verify_internal$201:
	movl	$0, %esi
.L__verify_internal$202:
	jmp 	.L__verify_internal$197
.L__verify_internal$199:
	movl	$0, %esi
.L__verify_internal$200:
.L__verify_internal$197:
	cmpl	$1, %esi
	jne 	.L__verify_internal$198
	movw	$1542, 97040(%rsp)
	movw	$1792, 97042(%rsp)
	movw	$1793, 97044(%rsp)
	movw	$1794, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$196:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$195:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$194:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$193:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$192:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$191:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	88800(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$190:
	movq	%r11, %rax
	leaq	89824(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$189:
	movq	%r11, %rcx
	leaq	90848(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$188:
	movq	%r11, %rdx
	leaq	91872(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$187:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$180
	cmpq	$256, %rcx
	jb  	.L__verify_internal$182
	cmpq	$256, %rdx
	jb  	.L__verify_internal$184
	cmpq	$256, %r11
	jnb 	.L__verify_internal$166
	movl	$0, %esi
.L__verify_internal$186:
	jmp 	.L__verify_internal$166
.L__verify_internal$184:
	movl	$0, %esi
.L__verify_internal$185:
	jmp 	.L__verify_internal$166
.L__verify_internal$182:
	movl	$0, %esi
.L__verify_internal$183:
	jmp 	.L__verify_internal$166
.L__verify_internal$180:
	movl	$0, %esi
.L__verify_internal$181:
	jmp 	.L__verify_internal$166
.L__verify_internal$167:
	movq	%rax, 97048(%rsp)
	movq	%rcx, 97056(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97072(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$179:
	movq	97048(%rsp), %r11
	movq	97056(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97072(%rsp), %r12
	leaq	88800(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$178:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	89824(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$177:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	90848(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$176:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	91872(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$175:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$168
	cmpq	$256, %rcx
	jb  	.L__verify_internal$170
	cmpq	$256, %rdx
	jb  	.L__verify_internal$172
	cmpq	$256, %r11
	jnb 	.L__verify_internal$166
	movl	$0, %esi
.L__verify_internal$174:
	jmp 	.L__verify_internal$166
.L__verify_internal$172:
	movl	$0, %esi
.L__verify_internal$173:
	jmp 	.L__verify_internal$166
.L__verify_internal$170:
	movl	$0, %esi
.L__verify_internal$171:
	jmp 	.L__verify_internal$166
.L__verify_internal$168:
	movl	$0, %esi
.L__verify_internal$169:
.L__verify_internal$166:
	cmpl	$1, %esi
	jne 	.L__verify_internal$167
	movw	$1795, 97040(%rsp)
	movw	$1796, 97042(%rsp)
	movw	$1797, 97044(%rsp)
	movw	$1798, 97046(%rsp)
	leaq	32(%rsp), %rsi
	leaq	576(%rsp), %rax
	leaq	97040(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$165:
	leaq	40(%rsp), %rsp
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$164:
	leaq	576(%rsp), %rax
	leaq	4136(%rsp), %rcx
	leaq	3272(%rsp), %rdx
	leaq	2408(%rsp), %rsi
	leaq	1544(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$163:
	leaq	576(%rsp), %rax
	leaq	4304(%rsp), %rcx
	leaq	3440(%rsp), %rdx
	leaq	2576(%rsp), %rsi
	leaq	1712(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$162:
	leaq	576(%rsp), %rax
	leaq	4472(%rsp), %rcx
	leaq	3608(%rsp), %rdx
	leaq	2744(%rsp), %rsi
	leaq	1880(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$161:
	leaq	576(%rsp), %rax
	leaq	4640(%rsp), %rcx
	leaq	3776(%rsp), %rdx
	leaq	2912(%rsp), %rsi
	leaq	2048(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$160:
	movq	$0, %rax
	movq	%rax, 4808(%rsp)
	movq	%rax, 3944(%rsp)
	movq	%rax, 3080(%rsp)
	movq	%rax, 2216(%rsp)
	leaq	92896(%rsp), %rsi
	leaq	3968(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$159:
	movq	%r11, %rax
	leaq	93920(%rsp), %rsi
	leaq	3104(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$158:
	movq	%r11, %rcx
	leaq	94944(%rsp), %rsi
	leaq	2240(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$157:
	movq	%r11, %rdx
	leaq	95968(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$156:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$149
	cmpq	$256, %rcx
	jb  	.L__verify_internal$151
	cmpq	$256, %rdx
	jb  	.L__verify_internal$153
	cmpq	$256, %r11
	jnb 	.L__verify_internal$135
	movl	$0, %esi
.L__verify_internal$155:
	jmp 	.L__verify_internal$135
.L__verify_internal$153:
	movl	$0, %esi
.L__verify_internal$154:
	jmp 	.L__verify_internal$135
.L__verify_internal$151:
	movl	$0, %esi
.L__verify_internal$152:
	jmp 	.L__verify_internal$135
.L__verify_internal$149:
	movl	$0, %esi
.L__verify_internal$150:
	jmp 	.L__verify_internal$135
.L__verify_internal$136:
	movq	%rax, 97040(%rsp)
	movq	%rcx, 97072(%rsp)
	movq	%rdx, 97064(%rsp)
	movq	%r11, 97056(%rsp)
	leaq	576(%rsp), %rax
	leaq	3968(%rsp), %rcx
	leaq	3104(%rsp), %rdx
	leaq	2240(%rsp), %rsi
	leaq	1376(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$148:
	movq	97040(%rsp), %r11
	movq	97072(%rsp), %rcx
	movq	97064(%rsp), %rdx
	movq	97056(%rsp), %r12
	leaq	92896(%rsp), %rsi
	leaq	3968(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$147:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	93920(%rsp), %rsi
	leaq	3104(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$146:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	94944(%rsp), %rsi
	leaq	2240(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$145:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	95968(%rsp), %rsi
	leaq	1376(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$144:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__verify_internal$137
	cmpq	$256, %rcx
	jb  	.L__verify_internal$139
	cmpq	$256, %rdx
	jb  	.L__verify_internal$141
	cmpq	$256, %r11
	jnb 	.L__verify_internal$135
	movl	$0, %esi
.L__verify_internal$143:
	jmp 	.L__verify_internal$135
.L__verify_internal$141:
	movl	$0, %esi
.L__verify_internal$142:
	jmp 	.L__verify_internal$135
.L__verify_internal$139:
	movl	$0, %esi
.L__verify_internal$140:
	jmp 	.L__verify_internal$135
.L__verify_internal$137:
	movl	$0, %esi
.L__verify_internal$138:
.L__verify_internal$135:
	cmpl	$1, %esi
	jne 	.L__verify_internal$136
	leaq	7904(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__verify_internal$134:
	leaq	39648(%rsp), %rax
	leaq	7904(%rsp), %rcx
	leaq	23264(%rsp), %rsi
	movq	%rax, %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$132
.L__verify_internal$133:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$132:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$133
	leaq	24288(%rsp), %rsi
	leaq	7168(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$130
.L__verify_internal$131:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$130:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$131
	leaq	25312(%rsp), %rsi
	leaq	14336(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$128
.L__verify_internal$129:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$128:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$129
	leaq	26336(%rsp), %rsi
	leaq	21504(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$126
.L__verify_internal$127:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$126:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$127
	leaq	27360(%rsp), %rsi
	leaq	28672(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$124
.L__verify_internal$125:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$124:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$125
	leaq	28384(%rsp), %rsi
	leaq	35840(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$122
.L__verify_internal$123:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$122:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$123
	leaq	29408(%rsp), %rsi
	leaq	43008(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$120
.L__verify_internal$121:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$120:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$121
	leaq	30432(%rsp), %rsi
	leaq	50176(%rax), %rdx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__verify_internal$118
.L__verify_internal$119:
	vmovdqu	(%rdx,%rdi), %ymm2
	vmovdqu	(%rcx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rdx,%rdi), %ymm4
	vmovdqu	1024(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdx,%rdi), %ymm4
	vmovdqu	2048(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdx,%rdi), %ymm4
	vmovdqu	3072(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdx,%rdi), %ymm4
	vmovdqu	4096(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdx,%rdi), %ymm4
	vmovdqu	5120(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%rdi), %ymm4
	vmovdqu	6144(%rcx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__verify_internal$118:
	cmpq	$1024, %rdi
	jb  	.L__verify_internal$119
	movq	97024(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	4832(%rsp), %rax
	movq	%r8, %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.L__verify_internal$116
.L__verify_internal$117:
	vmovdqu	%ymm0, (%rax,%rdx)
	addq	$32, %rdx
.L__verify_internal$116:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$117
	movq	%rax, 97056(%rsp)
	leaq	352(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__verify_internal$115:
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__verify_internal$114:
	movq	97056(%rsp), %rcx
	movq	192(%rsp), %rsi
	movq	$8, %r10
	lfence
	movq	$0, %r8
	movq	$196, %rdx
	jmp 	.L__verify_internal$107
.L__verify_internal$108:
	movq	$-1, %rax
	cmovnb	%rax, %r8
	jmp 	.L__verify_internal$109
.L__verify_internal$110:
	movq	$-1, %rax
	cmovbe	%rax, %r8
.L__verify_internal$109:
	cmpq	$136, %r10
	jnb 	.L__verify_internal$111
	movq	$-1, %rax
	cmovnb	%rax, %r8
	jmp 	.L__verify_internal$112
.L__verify_internal$111:
	movq	%rdx, 97056(%rsp)
	movq	%rsi, 97064(%rsp)
	movq	%rcx, 97072(%rsp)
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__verify_internal$113:
	movq	97056(%rsp), %rdx
	movq	97064(%rsp), %rsi
	movq	97072(%rsp), %rcx
	movq	$0, %r10
	lfence
	movq	$0, %r8
.L__verify_internal$112:
	movzbq	192(%rsp,%r10), %rax
// declassify_val u64 %rax
	orq 	%r8, %rax
	incq	%r10
	cmpq	%rdx, %rax
	jnbe	.L__verify_internal$110
	movq	$-1, %rdi
	cmovnbe	%rdi, %r8
	movl	(%rcx,%rax,4), %edi
	movl	%edi, (%rcx,%rdx,4)
	movl	%esi, %edi
	andl	$1, %edi
	shll	$1, %edi
	movl	$1, %r9d
	subl	%edi, %r9d
	movl	%r9d, (%rcx,%rax,4)
	shrq	$1, %rsi
	incq	%rdx
.L__verify_internal$107:
	cmpq	$256, %rdx
	jb  	.L__verify_internal$108
	leaq	4832(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$106:
	movq	97032(%rsp), %rdi
	lfence
	movq	$0, %rax
	leaq	32(%rdi), %rax
	leaq	4832(%rsp), %rcx
	movq	%rcx, %mm0
	leaq	6880(%rsp), %r8
	movq	%rax, %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$105:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$103
.L__verify_internal$104:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$103:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$104
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$102:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$101:
	leaq	31456(%rsp), %rcx
	leaq	23264(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$100:
	leaq	31456(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$99:
	leaq	31456(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$98:
	leaq	31456(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$97:
	leaq	31456(%rsp), %r9
	leaq	15072(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$96:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	320(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$95:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$93
.L__verify_internal$94:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$93:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$94
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$92:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$91:
	leaq	32480(%rsp), %rcx
	leaq	24288(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$90:
	leaq	32480(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$89:
	leaq	32480(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$88:
	leaq	32480(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$87:
	leaq	32480(%rsp), %r9
	leaq	16096(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$86:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	640(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$85:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$83
.L__verify_internal$84:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$83:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$84
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$82:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$81:
	leaq	33504(%rsp), %rcx
	leaq	25312(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$80:
	leaq	33504(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$79:
	leaq	33504(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$78:
	leaq	33504(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$77:
	leaq	33504(%rsp), %r9
	leaq	17120(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$76:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	960(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$75:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$73
.L__verify_internal$74:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$73:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$74
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$72:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$71:
	leaq	34528(%rsp), %rcx
	leaq	26336(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$70:
	leaq	34528(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$69:
	leaq	34528(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$68:
	leaq	34528(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$67:
	leaq	34528(%rsp), %r9
	leaq	18144(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$66:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	1280(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$65:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$63
.L__verify_internal$64:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$63:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$64
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$62:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$61:
	leaq	35552(%rsp), %rcx
	leaq	27360(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$60:
	leaq	35552(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$59:
	leaq	35552(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$58:
	leaq	35552(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$57:
	leaq	35552(%rsp), %r9
	leaq	19168(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$56:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	1600(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$55:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$53
.L__verify_internal$54:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$53:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$54
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$52:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$51:
	leaq	36576(%rsp), %rcx
	leaq	28384(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$50:
	leaq	36576(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$49:
	leaq	36576(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$48:
	leaq	36576(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$47:
	leaq	36576(%rsp), %r9
	leaq	20192(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$46:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	1920(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$45:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$43
.L__verify_internal$44:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$43:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$44
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$42:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$41:
	leaq	37600(%rsp), %rcx
	leaq	29408(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$40:
	leaq	37600(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$39:
	leaq	37600(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$38:
	leaq	37600(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$37:
	leaq	37600(%rsp), %r9
	leaq	21216(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$36:
	leaq	2072(%rsp), %rsp
	leaq	6880(%rsp), %r8
	leaq	2240(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$35:
	leaq	6880(%rsp), %rcx
	movq	$0, %rdx
	jmp 	.L__verify_internal$33
.L__verify_internal$34:
	vmovdqu	(%rcx,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%rdx)
	addq	$32, %rdx
.L__verify_internal$33:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$34
	leaq	6880(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$32:
	movq	%mm0, %rcx
	leaq	5856(%rsp), %r10
	leaq	6880(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$31:
	leaq	38624(%rsp), %rcx
	leaq	30432(%rsp), %rdx
	leaq	5856(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$30:
	leaq	38624(%rsp), %rsi
	call	.Lpolynomial__reduce32$1
.L__verify_internal$29:
	leaq	38624(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$28:
	leaq	38624(%rsp), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$27:
	leaq	38624(%rsp), %r9
	leaq	22240(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$26:
	leaq	2072(%rsp), %rsp
	leaq	31456(%rsp), %rax
	leaq	5856(%rsp), %rdx
	movq	%rax, %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$24
.L__verify_internal$25:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$24:
	cmpq	$128, %r8
	jb  	.L__verify_internal$25
	leaq	5984(%rsp), %rdx
	leaq	1024(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$22
.L__verify_internal$23:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$22:
	cmpq	$128, %r8
	jb  	.L__verify_internal$23
	leaq	6112(%rsp), %rdx
	leaq	2048(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$20
.L__verify_internal$21:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$20:
	cmpq	$128, %r8
	jb  	.L__verify_internal$21
	leaq	6240(%rsp), %rdx
	leaq	3072(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$18
.L__verify_internal$19:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$18:
	cmpq	$128, %r8
	jb  	.L__verify_internal$19
	leaq	6368(%rsp), %rdx
	leaq	4096(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$16
.L__verify_internal$17:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$16:
	cmpq	$128, %r8
	jb  	.L__verify_internal$17
	leaq	6496(%rsp), %rdx
	leaq	5120(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$14
.L__verify_internal$15:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$14:
	cmpq	$128, %r8
	jb  	.L__verify_internal$15
	leaq	6624(%rsp), %rdx
	leaq	6144(%rax), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$12
.L__verify_internal$13:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$12:
	cmpq	$128, %r8
	jb  	.L__verify_internal$13
	leaq	6752(%rsp), %rdx
	leaq	7168(%rax), %rax
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$10
.L__verify_internal$11:
	vmovdqu	(%rax,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rax,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$10:
	cmpq	$128, %r8
	jb  	.L__verify_internal$11
	movq	97032(%rsp), %rcx
	lfence
	movq	$0, %rax
	leaq	64(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__verify_internal$9:
	leaq	248(%rsp), %rsp
	movq	96992(%rsp), %rcx
	movq	97000(%rsp), %rdx
	movq	97008(%rsp), %rdi
	movq	97016(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	128(%rsp), %rax
	leaq	64(%rsp), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__verify_internal$8:
	leaq	344(%rsp), %rsp
	leaq	64(%rsp), %rax
	leaq	128(%rsp), %rcx
	leaq	5856(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__verify_internal$7:
	leaq	248(%rsp), %rsp
	movq	97024(%rsp), %r8
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
	cmpq	$64, %rdx
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
	movq	%rdi, 169520(%rsp)
	movq	%r9, 169528(%rsp)
	movq	%rsi, 169536(%rsp)
	movq	%rax, 169544(%rsp)
	movq	%rdx, 169552(%rsp)
	movq	%rcx, 169560(%rsp)
	movq	%r8, 169568(%rsp)
// declassify_mem 32 [RSI]
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 169576(%rsp)
	movw	$1, 169578(%rsp)
	movw	$2, 169580(%rsp)
	movw	$3, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$671:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$670:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$669:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$668:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$667:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$666:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	112160(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$665:
	movq	%r11, %rax
	leaq	113184(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$664:
	movq	%r11, %rcx
	leaq	114208(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$663:
	movq	%r11, %rdx
	leaq	115232(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$662:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$655
	cmpq	$256, %rcx
	jb  	.L__sign_internal$657
	cmpq	$256, %rdx
	jb  	.L__sign_internal$659
	cmpq	$256, %r11
	jnb 	.L__sign_internal$641
	movl	$0, %esi
.L__sign_internal$661:
	jmp 	.L__sign_internal$641
.L__sign_internal$659:
	movl	$0, %esi
.L__sign_internal$660:
	jmp 	.L__sign_internal$641
.L__sign_internal$657:
	movl	$0, %esi
.L__sign_internal$658:
	jmp 	.L__sign_internal$641
.L__sign_internal$655:
	movl	$0, %esi
.L__sign_internal$656:
	jmp 	.L__sign_internal$641
.L__sign_internal$642:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$654:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	112160(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$653:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	113184(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$652:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	114208(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$651:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	115232(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$650:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$643
	cmpq	$256, %rcx
	jb  	.L__sign_internal$645
	cmpq	$256, %rdx
	jb  	.L__sign_internal$647
	cmpq	$256, %r11
	jnb 	.L__sign_internal$641
	movl	$0, %esi
.L__sign_internal$649:
	jmp 	.L__sign_internal$641
.L__sign_internal$647:
	movl	$0, %esi
.L__sign_internal$648:
	jmp 	.L__sign_internal$641
.L__sign_internal$645:
	movl	$0, %esi
.L__sign_internal$646:
	jmp 	.L__sign_internal$641
.L__sign_internal$643:
	movl	$0, %esi
.L__sign_internal$644:
.L__sign_internal$641:
	cmpl	$1, %esi
	jne 	.L__sign_internal$642
	movw	$4, 169576(%rsp)
	movw	$5, 169578(%rsp)
	movw	$6, 169580(%rsp)
	movw	$256, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$640:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$639:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$638:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$637:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$636:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$635:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	116256(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$634:
	movq	%r11, %rax
	leaq	117280(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$633:
	movq	%r11, %rcx
	leaq	118304(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$632:
	movq	%r11, %rdx
	leaq	119328(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$631:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$624
	cmpq	$256, %rcx
	jb  	.L__sign_internal$626
	cmpq	$256, %rdx
	jb  	.L__sign_internal$628
	cmpq	$256, %r11
	jnb 	.L__sign_internal$610
	movl	$0, %esi
.L__sign_internal$630:
	jmp 	.L__sign_internal$610
.L__sign_internal$628:
	movl	$0, %esi
.L__sign_internal$629:
	jmp 	.L__sign_internal$610
.L__sign_internal$626:
	movl	$0, %esi
.L__sign_internal$627:
	jmp 	.L__sign_internal$610
.L__sign_internal$624:
	movl	$0, %esi
.L__sign_internal$625:
	jmp 	.L__sign_internal$610
.L__sign_internal$611:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$623:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	116256(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$622:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	117280(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$621:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	118304(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$620:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	119328(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$619:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$612
	cmpq	$256, %rcx
	jb  	.L__sign_internal$614
	cmpq	$256, %rdx
	jb  	.L__sign_internal$616
	cmpq	$256, %r11
	jnb 	.L__sign_internal$610
	movl	$0, %esi
.L__sign_internal$618:
	jmp 	.L__sign_internal$610
.L__sign_internal$616:
	movl	$0, %esi
.L__sign_internal$617:
	jmp 	.L__sign_internal$610
.L__sign_internal$614:
	movl	$0, %esi
.L__sign_internal$615:
	jmp 	.L__sign_internal$610
.L__sign_internal$612:
	movl	$0, %esi
.L__sign_internal$613:
.L__sign_internal$610:
	cmpl	$1, %esi
	jne 	.L__sign_internal$611
	movw	$257, 169576(%rsp)
	movw	$258, 169578(%rsp)
	movw	$259, 169580(%rsp)
	movw	$260, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$609:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$608:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$607:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$606:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$605:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$604:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	120352(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$603:
	movq	%r11, %rax
	leaq	121376(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$602:
	movq	%r11, %rcx
	leaq	122400(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$601:
	movq	%r11, %rdx
	leaq	123424(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$600:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$593
	cmpq	$256, %rcx
	jb  	.L__sign_internal$595
	cmpq	$256, %rdx
	jb  	.L__sign_internal$597
	cmpq	$256, %r11
	jnb 	.L__sign_internal$579
	movl	$0, %esi
.L__sign_internal$599:
	jmp 	.L__sign_internal$579
.L__sign_internal$597:
	movl	$0, %esi
.L__sign_internal$598:
	jmp 	.L__sign_internal$579
.L__sign_internal$595:
	movl	$0, %esi
.L__sign_internal$596:
	jmp 	.L__sign_internal$579
.L__sign_internal$593:
	movl	$0, %esi
.L__sign_internal$594:
	jmp 	.L__sign_internal$579
.L__sign_internal$580:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$592:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	120352(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$591:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	121376(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$590:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	122400(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$589:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	123424(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$588:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$581
	cmpq	$256, %rcx
	jb  	.L__sign_internal$583
	cmpq	$256, %rdx
	jb  	.L__sign_internal$585
	cmpq	$256, %r11
	jnb 	.L__sign_internal$579
	movl	$0, %esi
.L__sign_internal$587:
	jmp 	.L__sign_internal$579
.L__sign_internal$585:
	movl	$0, %esi
.L__sign_internal$586:
	jmp 	.L__sign_internal$579
.L__sign_internal$583:
	movl	$0, %esi
.L__sign_internal$584:
	jmp 	.L__sign_internal$579
.L__sign_internal$581:
	movl	$0, %esi
.L__sign_internal$582:
.L__sign_internal$579:
	cmpl	$1, %esi
	jne 	.L__sign_internal$580
	movw	$261, 169576(%rsp)
	movw	$262, 169578(%rsp)
	movw	$512, 169580(%rsp)
	movw	$513, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$578:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$577:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$576:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$575:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$574:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$573:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	124448(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$572:
	movq	%r11, %rax
	leaq	125472(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$571:
	movq	%r11, %rcx
	leaq	126496(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$570:
	movq	%r11, %rdx
	leaq	127520(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$569:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$562
	cmpq	$256, %rcx
	jb  	.L__sign_internal$564
	cmpq	$256, %rdx
	jb  	.L__sign_internal$566
	cmpq	$256, %r11
	jnb 	.L__sign_internal$548
	movl	$0, %esi
.L__sign_internal$568:
	jmp 	.L__sign_internal$548
.L__sign_internal$566:
	movl	$0, %esi
.L__sign_internal$567:
	jmp 	.L__sign_internal$548
.L__sign_internal$564:
	movl	$0, %esi
.L__sign_internal$565:
	jmp 	.L__sign_internal$548
.L__sign_internal$562:
	movl	$0, %esi
.L__sign_internal$563:
	jmp 	.L__sign_internal$548
.L__sign_internal$549:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$561:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	124448(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$560:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	125472(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$559:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	126496(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$558:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	127520(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$557:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$550
	cmpq	$256, %rcx
	jb  	.L__sign_internal$552
	cmpq	$256, %rdx
	jb  	.L__sign_internal$554
	cmpq	$256, %r11
	jnb 	.L__sign_internal$548
	movl	$0, %esi
.L__sign_internal$556:
	jmp 	.L__sign_internal$548
.L__sign_internal$554:
	movl	$0, %esi
.L__sign_internal$555:
	jmp 	.L__sign_internal$548
.L__sign_internal$552:
	movl	$0, %esi
.L__sign_internal$553:
	jmp 	.L__sign_internal$548
.L__sign_internal$550:
	movl	$0, %esi
.L__sign_internal$551:
.L__sign_internal$548:
	cmpl	$1, %esi
	jne 	.L__sign_internal$549
	movw	$514, 169576(%rsp)
	movw	$515, 169578(%rsp)
	movw	$516, 169580(%rsp)
	movw	$517, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$547:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$546:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$545:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$544:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$543:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$542:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	128544(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$541:
	movq	%r11, %rax
	leaq	129568(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$540:
	movq	%r11, %rcx
	leaq	130592(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$539:
	movq	%r11, %rdx
	leaq	131616(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$538:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$531
	cmpq	$256, %rcx
	jb  	.L__sign_internal$533
	cmpq	$256, %rdx
	jb  	.L__sign_internal$535
	cmpq	$256, %r11
	jnb 	.L__sign_internal$517
	movl	$0, %esi
.L__sign_internal$537:
	jmp 	.L__sign_internal$517
.L__sign_internal$535:
	movl	$0, %esi
.L__sign_internal$536:
	jmp 	.L__sign_internal$517
.L__sign_internal$533:
	movl	$0, %esi
.L__sign_internal$534:
	jmp 	.L__sign_internal$517
.L__sign_internal$531:
	movl	$0, %esi
.L__sign_internal$532:
	jmp 	.L__sign_internal$517
.L__sign_internal$518:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$530:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	128544(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$529:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	129568(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$528:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	130592(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$527:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	131616(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$526:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$519
	cmpq	$256, %rcx
	jb  	.L__sign_internal$521
	cmpq	$256, %rdx
	jb  	.L__sign_internal$523
	cmpq	$256, %r11
	jnb 	.L__sign_internal$517
	movl	$0, %esi
.L__sign_internal$525:
	jmp 	.L__sign_internal$517
.L__sign_internal$523:
	movl	$0, %esi
.L__sign_internal$524:
	jmp 	.L__sign_internal$517
.L__sign_internal$521:
	movl	$0, %esi
.L__sign_internal$522:
	jmp 	.L__sign_internal$517
.L__sign_internal$519:
	movl	$0, %esi
.L__sign_internal$520:
.L__sign_internal$517:
	cmpl	$1, %esi
	jne 	.L__sign_internal$518
	movw	$518, 169576(%rsp)
	movw	$768, 169578(%rsp)
	movw	$769, 169580(%rsp)
	movw	$770, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$516:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$515:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$514:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$513:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$512:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$511:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	132640(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$510:
	movq	%r11, %rax
	leaq	133664(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$509:
	movq	%r11, %rcx
	leaq	134688(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$508:
	movq	%r11, %rdx
	leaq	135712(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$507:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$500
	cmpq	$256, %rcx
	jb  	.L__sign_internal$502
	cmpq	$256, %rdx
	jb  	.L__sign_internal$504
	cmpq	$256, %r11
	jnb 	.L__sign_internal$486
	movl	$0, %esi
.L__sign_internal$506:
	jmp 	.L__sign_internal$486
.L__sign_internal$504:
	movl	$0, %esi
.L__sign_internal$505:
	jmp 	.L__sign_internal$486
.L__sign_internal$502:
	movl	$0, %esi
.L__sign_internal$503:
	jmp 	.L__sign_internal$486
.L__sign_internal$500:
	movl	$0, %esi
.L__sign_internal$501:
	jmp 	.L__sign_internal$486
.L__sign_internal$487:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$499:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	132640(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$498:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	133664(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$497:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	134688(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$496:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	135712(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$495:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$488
	cmpq	$256, %rcx
	jb  	.L__sign_internal$490
	cmpq	$256, %rdx
	jb  	.L__sign_internal$492
	cmpq	$256, %r11
	jnb 	.L__sign_internal$486
	movl	$0, %esi
.L__sign_internal$494:
	jmp 	.L__sign_internal$486
.L__sign_internal$492:
	movl	$0, %esi
.L__sign_internal$493:
	jmp 	.L__sign_internal$486
.L__sign_internal$490:
	movl	$0, %esi
.L__sign_internal$491:
	jmp 	.L__sign_internal$486
.L__sign_internal$488:
	movl	$0, %esi
.L__sign_internal$489:
.L__sign_internal$486:
	cmpl	$1, %esi
	jne 	.L__sign_internal$487
	movw	$771, 169576(%rsp)
	movw	$772, 169578(%rsp)
	movw	$773, 169580(%rsp)
	movw	$774, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$485:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$484:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$483:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$482:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$481:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$480:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	136736(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$479:
	movq	%r11, %rax
	leaq	137760(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$478:
	movq	%r11, %rcx
	leaq	138784(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$477:
	movq	%r11, %rdx
	leaq	139808(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$476:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$469
	cmpq	$256, %rcx
	jb  	.L__sign_internal$471
	cmpq	$256, %rdx
	jb  	.L__sign_internal$473
	cmpq	$256, %r11
	jnb 	.L__sign_internal$455
	movl	$0, %esi
.L__sign_internal$475:
	jmp 	.L__sign_internal$455
.L__sign_internal$473:
	movl	$0, %esi
.L__sign_internal$474:
	jmp 	.L__sign_internal$455
.L__sign_internal$471:
	movl	$0, %esi
.L__sign_internal$472:
	jmp 	.L__sign_internal$455
.L__sign_internal$469:
	movl	$0, %esi
.L__sign_internal$470:
	jmp 	.L__sign_internal$455
.L__sign_internal$456:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$468:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	136736(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$467:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	137760(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$466:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	138784(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$465:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	139808(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$464:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$457
	cmpq	$256, %rcx
	jb  	.L__sign_internal$459
	cmpq	$256, %rdx
	jb  	.L__sign_internal$461
	cmpq	$256, %r11
	jnb 	.L__sign_internal$455
	movl	$0, %esi
.L__sign_internal$463:
	jmp 	.L__sign_internal$455
.L__sign_internal$461:
	movl	$0, %esi
.L__sign_internal$462:
	jmp 	.L__sign_internal$455
.L__sign_internal$459:
	movl	$0, %esi
.L__sign_internal$460:
	jmp 	.L__sign_internal$455
.L__sign_internal$457:
	movl	$0, %esi
.L__sign_internal$458:
.L__sign_internal$455:
	cmpl	$1, %esi
	jne 	.L__sign_internal$456
	movw	$1024, 169576(%rsp)
	movw	$1025, 169578(%rsp)
	movw	$1026, 169580(%rsp)
	movw	$1027, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$454:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$453:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$452:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$451:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$450:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$449:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	140832(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$448:
	movq	%r11, %rax
	leaq	141856(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$447:
	movq	%r11, %rcx
	leaq	142880(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$446:
	movq	%r11, %rdx
	leaq	143904(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$445:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$438
	cmpq	$256, %rcx
	jb  	.L__sign_internal$440
	cmpq	$256, %rdx
	jb  	.L__sign_internal$442
	cmpq	$256, %r11
	jnb 	.L__sign_internal$424
	movl	$0, %esi
.L__sign_internal$444:
	jmp 	.L__sign_internal$424
.L__sign_internal$442:
	movl	$0, %esi
.L__sign_internal$443:
	jmp 	.L__sign_internal$424
.L__sign_internal$440:
	movl	$0, %esi
.L__sign_internal$441:
	jmp 	.L__sign_internal$424
.L__sign_internal$438:
	movl	$0, %esi
.L__sign_internal$439:
	jmp 	.L__sign_internal$424
.L__sign_internal$425:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$437:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	140832(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$436:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	141856(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$435:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	142880(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$434:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	143904(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$433:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$426
	cmpq	$256, %rcx
	jb  	.L__sign_internal$428
	cmpq	$256, %rdx
	jb  	.L__sign_internal$430
	cmpq	$256, %r11
	jnb 	.L__sign_internal$424
	movl	$0, %esi
.L__sign_internal$432:
	jmp 	.L__sign_internal$424
.L__sign_internal$430:
	movl	$0, %esi
.L__sign_internal$431:
	jmp 	.L__sign_internal$424
.L__sign_internal$428:
	movl	$0, %esi
.L__sign_internal$429:
	jmp 	.L__sign_internal$424
.L__sign_internal$426:
	movl	$0, %esi
.L__sign_internal$427:
.L__sign_internal$424:
	cmpl	$1, %esi
	jne 	.L__sign_internal$425
	movw	$1028, 169576(%rsp)
	movw	$1029, 169578(%rsp)
	movw	$1030, 169580(%rsp)
	movw	$1280, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$423:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$422:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$421:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$420:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$419:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$418:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	144928(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$417:
	movq	%r11, %rax
	leaq	145952(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$416:
	movq	%r11, %rcx
	leaq	146976(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$415:
	movq	%r11, %rdx
	leaq	148000(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$414:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$407
	cmpq	$256, %rcx
	jb  	.L__sign_internal$409
	cmpq	$256, %rdx
	jb  	.L__sign_internal$411
	cmpq	$256, %r11
	jnb 	.L__sign_internal$393
	movl	$0, %esi
.L__sign_internal$413:
	jmp 	.L__sign_internal$393
.L__sign_internal$411:
	movl	$0, %esi
.L__sign_internal$412:
	jmp 	.L__sign_internal$393
.L__sign_internal$409:
	movl	$0, %esi
.L__sign_internal$410:
	jmp 	.L__sign_internal$393
.L__sign_internal$407:
	movl	$0, %esi
.L__sign_internal$408:
	jmp 	.L__sign_internal$393
.L__sign_internal$394:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$406:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	144928(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$405:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	145952(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$404:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	146976(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$403:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	148000(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$402:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$395
	cmpq	$256, %rcx
	jb  	.L__sign_internal$397
	cmpq	$256, %rdx
	jb  	.L__sign_internal$399
	cmpq	$256, %r11
	jnb 	.L__sign_internal$393
	movl	$0, %esi
.L__sign_internal$401:
	jmp 	.L__sign_internal$393
.L__sign_internal$399:
	movl	$0, %esi
.L__sign_internal$400:
	jmp 	.L__sign_internal$393
.L__sign_internal$397:
	movl	$0, %esi
.L__sign_internal$398:
	jmp 	.L__sign_internal$393
.L__sign_internal$395:
	movl	$0, %esi
.L__sign_internal$396:
.L__sign_internal$393:
	cmpl	$1, %esi
	jne 	.L__sign_internal$394
	movw	$1281, 169576(%rsp)
	movw	$1282, 169578(%rsp)
	movw	$1283, 169580(%rsp)
	movw	$1284, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$392:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$391:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$390:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$389:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$388:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$387:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	149024(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$386:
	movq	%r11, %rax
	leaq	150048(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$385:
	movq	%r11, %rcx
	leaq	151072(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$384:
	movq	%r11, %rdx
	leaq	152096(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$383:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$376
	cmpq	$256, %rcx
	jb  	.L__sign_internal$378
	cmpq	$256, %rdx
	jb  	.L__sign_internal$380
	cmpq	$256, %r11
	jnb 	.L__sign_internal$362
	movl	$0, %esi
.L__sign_internal$382:
	jmp 	.L__sign_internal$362
.L__sign_internal$380:
	movl	$0, %esi
.L__sign_internal$381:
	jmp 	.L__sign_internal$362
.L__sign_internal$378:
	movl	$0, %esi
.L__sign_internal$379:
	jmp 	.L__sign_internal$362
.L__sign_internal$376:
	movl	$0, %esi
.L__sign_internal$377:
	jmp 	.L__sign_internal$362
.L__sign_internal$363:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$375:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	149024(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$374:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	150048(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$373:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	151072(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$372:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	152096(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$371:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$364
	cmpq	$256, %rcx
	jb  	.L__sign_internal$366
	cmpq	$256, %rdx
	jb  	.L__sign_internal$368
	cmpq	$256, %r11
	jnb 	.L__sign_internal$362
	movl	$0, %esi
.L__sign_internal$370:
	jmp 	.L__sign_internal$362
.L__sign_internal$368:
	movl	$0, %esi
.L__sign_internal$369:
	jmp 	.L__sign_internal$362
.L__sign_internal$366:
	movl	$0, %esi
.L__sign_internal$367:
	jmp 	.L__sign_internal$362
.L__sign_internal$364:
	movl	$0, %esi
.L__sign_internal$365:
.L__sign_internal$362:
	cmpl	$1, %esi
	jne 	.L__sign_internal$363
	movw	$1285, 169576(%rsp)
	movw	$1286, 169578(%rsp)
	movw	$1536, 169580(%rsp)
	movw	$1537, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$361:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$360:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$359:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$358:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$357:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$356:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	153120(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$355:
	movq	%r11, %rax
	leaq	154144(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$354:
	movq	%r11, %rcx
	leaq	155168(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$353:
	movq	%r11, %rdx
	leaq	156192(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$352:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$345
	cmpq	$256, %rcx
	jb  	.L__sign_internal$347
	cmpq	$256, %rdx
	jb  	.L__sign_internal$349
	cmpq	$256, %r11
	jnb 	.L__sign_internal$331
	movl	$0, %esi
.L__sign_internal$351:
	jmp 	.L__sign_internal$331
.L__sign_internal$349:
	movl	$0, %esi
.L__sign_internal$350:
	jmp 	.L__sign_internal$331
.L__sign_internal$347:
	movl	$0, %esi
.L__sign_internal$348:
	jmp 	.L__sign_internal$331
.L__sign_internal$345:
	movl	$0, %esi
.L__sign_internal$346:
	jmp 	.L__sign_internal$331
.L__sign_internal$332:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$344:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	153120(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$343:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	154144(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$342:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	155168(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$341:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	156192(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$340:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$333
	cmpq	$256, %rcx
	jb  	.L__sign_internal$335
	cmpq	$256, %rdx
	jb  	.L__sign_internal$337
	cmpq	$256, %r11
	jnb 	.L__sign_internal$331
	movl	$0, %esi
.L__sign_internal$339:
	jmp 	.L__sign_internal$331
.L__sign_internal$337:
	movl	$0, %esi
.L__sign_internal$338:
	jmp 	.L__sign_internal$331
.L__sign_internal$335:
	movl	$0, %esi
.L__sign_internal$336:
	jmp 	.L__sign_internal$331
.L__sign_internal$333:
	movl	$0, %esi
.L__sign_internal$334:
.L__sign_internal$331:
	cmpl	$1, %esi
	jne 	.L__sign_internal$332
	movw	$1538, 169576(%rsp)
	movw	$1539, 169578(%rsp)
	movw	$1540, 169580(%rsp)
	movw	$1541, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$330:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$329:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$328:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$327:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$326:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$325:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	157216(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$324:
	movq	%r11, %rax
	leaq	158240(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$323:
	movq	%r11, %rcx
	leaq	159264(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$322:
	movq	%r11, %rdx
	leaq	160288(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$321:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$314
	cmpq	$256, %rcx
	jb  	.L__sign_internal$316
	cmpq	$256, %rdx
	jb  	.L__sign_internal$318
	cmpq	$256, %r11
	jnb 	.L__sign_internal$300
	movl	$0, %esi
.L__sign_internal$320:
	jmp 	.L__sign_internal$300
.L__sign_internal$318:
	movl	$0, %esi
.L__sign_internal$319:
	jmp 	.L__sign_internal$300
.L__sign_internal$316:
	movl	$0, %esi
.L__sign_internal$317:
	jmp 	.L__sign_internal$300
.L__sign_internal$314:
	movl	$0, %esi
.L__sign_internal$315:
	jmp 	.L__sign_internal$300
.L__sign_internal$301:
	movq	%rax, 169608(%rsp)
	movq	%rcx, 169600(%rsp)
	movq	%rdx, 169592(%rsp)
	movq	%r11, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$313:
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rcx
	movq	169592(%rsp), %rdx
	movq	169584(%rsp), %r12
	leaq	157216(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$312:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	158240(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$311:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	159264(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$310:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	160288(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$309:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$302
	cmpq	$256, %rcx
	jb  	.L__sign_internal$304
	cmpq	$256, %rdx
	jb  	.L__sign_internal$306
	cmpq	$256, %r11
	jnb 	.L__sign_internal$300
	movl	$0, %esi
.L__sign_internal$308:
	jmp 	.L__sign_internal$300
.L__sign_internal$306:
	movl	$0, %esi
.L__sign_internal$307:
	jmp 	.L__sign_internal$300
.L__sign_internal$304:
	movl	$0, %esi
.L__sign_internal$305:
	jmp 	.L__sign_internal$300
.L__sign_internal$302:
	movl	$0, %esi
.L__sign_internal$303:
.L__sign_internal$300:
	cmpl	$1, %esi
	jne 	.L__sign_internal$301
	movw	$1542, 169576(%rsp)
	movw	$1792, 169578(%rsp)
	movw	$1793, 169580(%rsp)
	movw	$1794, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$299:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$298:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$297:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$296:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$295:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$294:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	161312(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$293:
	movq	%r11, %rax
	leaq	162336(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$292:
	movq	%r11, %rcx
	leaq	163360(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$291:
	movq	%r11, %rdx
	leaq	164384(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$290:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$283
	cmpq	$256, %rcx
	jb  	.L__sign_internal$285
	cmpq	$256, %rdx
	jb  	.L__sign_internal$287
	cmpq	$256, %r11
	jnb 	.L__sign_internal$269
	movl	$0, %esi
.L__sign_internal$289:
	jmp 	.L__sign_internal$269
.L__sign_internal$287:
	movl	$0, %esi
.L__sign_internal$288:
	jmp 	.L__sign_internal$269
.L__sign_internal$285:
	movl	$0, %esi
.L__sign_internal$286:
	jmp 	.L__sign_internal$269
.L__sign_internal$283:
	movl	$0, %esi
.L__sign_internal$284:
	jmp 	.L__sign_internal$269
.L__sign_internal$270:
	movq	%rax, 169584(%rsp)
	movq	%rcx, 169592(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$282:
	movq	169584(%rsp), %r11
	movq	169592(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169608(%rsp), %r12
	leaq	161312(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$281:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	162336(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$280:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	163360(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$279:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	164384(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$278:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$271
	cmpq	$256, %rcx
	jb  	.L__sign_internal$273
	cmpq	$256, %rdx
	jb  	.L__sign_internal$275
	cmpq	$256, %r11
	jnb 	.L__sign_internal$269
	movl	$0, %esi
.L__sign_internal$277:
	jmp 	.L__sign_internal$269
.L__sign_internal$275:
	movl	$0, %esi
.L__sign_internal$276:
	jmp 	.L__sign_internal$269
.L__sign_internal$273:
	movl	$0, %esi
.L__sign_internal$274:
	jmp 	.L__sign_internal$269
.L__sign_internal$271:
	movl	$0, %esi
.L__sign_internal$272:
.L__sign_internal$269:
	cmpl	$1, %esi
	jne 	.L__sign_internal$270
	movw	$1795, 169576(%rsp)
	movw	$1796, 169578(%rsp)
	movw	$1797, 169580(%rsp)
	movw	$1798, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rax
	leaq	169576(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$268:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$267:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$266:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$265:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$264:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$263:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	165408(%rsp), %rsi
	leaq	6848(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$262:
	movq	%r11, %rax
	leaq	166432(%rsp), %rsi
	leaq	5984(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$261:
	movq	%r11, %rcx
	leaq	167456(%rsp), %rsi
	leaq	5120(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$260:
	movq	%r11, %rdx
	leaq	168480(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$259:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$252
	cmpq	$256, %rcx
	jb  	.L__sign_internal$254
	cmpq	$256, %rdx
	jb  	.L__sign_internal$256
	cmpq	$256, %r11
	jnb 	.L__sign_internal$238
	movl	$0, %esi
.L__sign_internal$258:
	jmp 	.L__sign_internal$238
.L__sign_internal$256:
	movl	$0, %esi
.L__sign_internal$257:
	jmp 	.L__sign_internal$238
.L__sign_internal$254:
	movl	$0, %esi
.L__sign_internal$255:
	jmp 	.L__sign_internal$238
.L__sign_internal$252:
	movl	$0, %esi
.L__sign_internal$253:
	jmp 	.L__sign_internal$238
.L__sign_internal$239:
	movq	%rax, 169576(%rsp)
	movq	%rcx, 169608(%rsp)
	movq	%rdx, 169600(%rsp)
	movq	%r11, 169592(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$251:
	movq	169576(%rsp), %r11
	movq	169608(%rsp), %rcx
	movq	169600(%rsp), %rdx
	movq	169592(%rsp), %r12
	leaq	165408(%rsp), %rsi
	leaq	6848(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$250:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	166432(%rsp), %rsi
	leaq	5984(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$249:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	167456(%rsp), %rsi
	leaq	5120(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$248:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	168480(%rsp), %rsi
	leaq	4256(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$247:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__sign_internal$240
	cmpq	$256, %rcx
	jb  	.L__sign_internal$242
	cmpq	$256, %rdx
	jb  	.L__sign_internal$244
	cmpq	$256, %r11
	jnb 	.L__sign_internal$238
	movl	$0, %esi
.L__sign_internal$246:
	jmp 	.L__sign_internal$238
.L__sign_internal$244:
	movl	$0, %esi
.L__sign_internal$245:
	jmp 	.L__sign_internal$238
.L__sign_internal$242:
	movl	$0, %esi
.L__sign_internal$243:
	jmp 	.L__sign_internal$238
.L__sign_internal$240:
	movl	$0, %esi
.L__sign_internal$241:
.L__sign_internal$238:
	cmpl	$1, %esi
	jne 	.L__sign_internal$239
	movq	169536(%rsp), %rsi
	movq	169544(%rsp), %rcx
	movq	169552(%rsp), %rdx
	movq	169560(%rsp), %rdi
	movq	169568(%rsp), %r8
	lfence
	movq	$0, %r9
	orq 	%r9, %rsi
	movq	%rsi, 169568(%rsp)
	leaq	64(%rsp), %rax
	leaq	64(%rsi), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__sign_internal$237:
	leaq	344(%rsp), %rsp
	movq	169528(%rsp), %rdx
	movq	169568(%rsp), %rsi
	lfence
	movq	$0, %r8
	orq 	%r8, %rdx
	orq 	%r8, %rsi
	movq	%rsi, 169568(%rsp)
	leaq	32(%rsi), %rax
	leaq	64(%rsp), %rcx
	leaq	128(%rsp), %rsi
	leaq	-152(%rsp), %rsp
	call	.Lderive_seed_for_mask$1
.L__sign_internal$236:
	leaq	152(%rsp), %rsp
	movq	169568(%rsp), %rsi
	lfence
	movq	$0, %r8
	orq 	%r8, %rsi
	leaq	9760(%rsp), %rax
	leaq	128(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rax, %rcx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$235:
	movq	%mm0, %rdx
	leaq	1024(%rax), %rcx
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$234:
	movq	%mm0, %rdx
	leaq	2048(%rax), %rcx
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$233:
	movq	%mm0, %rdx
	leaq	3072(%rax), %rcx
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$232:
	movq	%mm0, %rdx
	leaq	4096(%rax), %rcx
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$231:
	movq	%mm0, %rdx
	leaq	5120(%rax), %rcx
	leaq	480(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$230:
	movq	%mm0, %rdx
	leaq	6144(%rax), %rcx
	leaq	576(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$229:
	leaq	38432(%rsp), %rax
	leaq	800(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rax, %rcx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$228:
	movq	%mm0, %rdx
	leaq	1024(%rax), %rcx
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$227:
	movq	%mm0, %rdx
	leaq	2048(%rax), %rcx
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$226:
	movq	%mm0, %rdx
	leaq	3072(%rax), %rcx
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$225:
	movq	%mm0, %rdx
	leaq	4096(%rax), %rcx
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$224:
	movq	%mm0, %rdx
	leaq	5120(%rax), %rcx
	leaq	480(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$223:
	movq	%mm0, %rdx
	leaq	6144(%rax), %rcx
	leaq	576(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$222:
	movq	%mm0, %rdx
	leaq	7168(%rax), %rcx
	leaq	672(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$221:
	leaq	46624(%rsp), %rax
	leaq	1568(%rsi), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$218
.L__sign_internal$219:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$220:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$218:
	cmpq	$403, %r9
	jb  	.L__sign_internal$219
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$217:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	1024(%rax), %rcx
	leaq	416(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$214
.L__sign_internal$215:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$216:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$214:
	cmpq	$403, %r9
	jb  	.L__sign_internal$215
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$213:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	2048(%rax), %rcx
	leaq	832(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$210
.L__sign_internal$211:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$212:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$210:
	cmpq	$403, %r9
	jb  	.L__sign_internal$211
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$209:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	3072(%rax), %rcx
	leaq	1248(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$206
.L__sign_internal$207:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$208:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$206:
	cmpq	$403, %r9
	jb  	.L__sign_internal$207
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$205:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	4096(%rax), %rcx
	leaq	1664(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$202
.L__sign_internal$203:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$204:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$202:
	cmpq	$403, %r9
	jb  	.L__sign_internal$203
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$201:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	5120(%rax), %rcx
	leaq	2080(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$198
.L__sign_internal$199:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$200:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$198:
	cmpq	$403, %r9
	jb  	.L__sign_internal$199
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$197:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	6144(%rax), %rcx
	leaq	2496(%rdx), %rsi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$194
.L__sign_internal$195:
	vmovdqu	(%rsi,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$196:
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$194:
	cmpq	$403, %r9
	jb  	.L__sign_internal$195
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$193:
	vmovdqu	%ymm2, (%rcx,%r8)
	leaq	7168(%rax), %rax
	leaq	2912(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$190
.L__sign_internal$191:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$192:
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$190:
	cmpq	$403, %r9
	jb  	.L__sign_internal$191
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$189:
	vmovdqu	%ymm2, (%rax,%r8)
// declassify_mem 8192 [RSP + 46624]
	leaq	16928(%rsp), %rcx
	leaq	9760(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	17952(%rsp), %rcx
	leaq	10784(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	18976(%rsp), %rcx
	leaq	11808(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	20000(%rsp), %rcx
	leaq	12832(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	21024(%rsp), %rcx
	leaq	13856(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	22048(%rsp), %rcx
	leaq	14880(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	23072(%rsp), %rcx
	leaq	15904(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	54816(%rsp), %rcx
	leaq	38432(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	95776(%rsp), %rcx
	leaq	46624(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	55840(%rsp), %rcx
	leaq	39456(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	97824(%rsp), %rcx
	leaq	47648(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	56864(%rsp), %rcx
	leaq	40480(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	99872(%rsp), %rcx
	leaq	48672(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	57888(%rsp), %rcx
	leaq	41504(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	101920(%rsp), %rcx
	leaq	49696(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	58912(%rsp), %rcx
	leaq	42528(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	103968(%rsp), %rcx
	leaq	50720(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	59936(%rsp), %rcx
	leaq	43552(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	106016(%rsp), %rcx
	leaq	51744(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	60960(%rsp), %rcx
	leaq	44576(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	108064(%rsp), %rcx
	leaq	52768(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	61984(%rsp), %rcx
	leaq	45600(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx)
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 32(%rcx)
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 96(%rcx)
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	288(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 128(%rcx)
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 192(%rcx)
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 256(%rcx)
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	576(%rsi), %ymm1
	vmovdqu	608(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 288(%rcx)
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 320(%rcx)
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	704(%rsi), %ymm1
	vmovdqu	736(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 352(%rcx)
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 384(%rcx)
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	864(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 448(%rcx)
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	960(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm2
	vpackssdw	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm2
	vmovdqu	%ymm2, 480(%rcx)
	vmovdqu	%ymm1, 992(%rcx)
	leaq	110112(%rsp), %rcx
	leaq	53792(%rsp), %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rsi), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	movw	$0, %ax
	movq	$0, %rcx
	movq	$0, %rdx
	movq	$1, 169568(%rsp)
	jmp 	.L__sign_internal$44
.L__sign_internal$45:
	movq	%rdx, 169528(%rsp)
	movw	%ax, 169860(%rsp)
	leaq	128(%rsp), %rcx
	movw	169860(%rsp), %dx
	leaq	3456(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$188:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	2752(%rsp), %rcx
	leaq	2048(%rsp), %rdx
	leaq	1344(%rsp), %rsi
	leaq	640(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$187:
	leaq	3456(%rsp), %rax
	leaq	2888(%rsp), %rcx
	leaq	2184(%rsp), %rdx
	leaq	1480(%rsp), %rsi
	leaq	776(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$186:
	leaq	3456(%rsp), %rax
	leaq	3024(%rsp), %rcx
	leaq	2320(%rsp), %rdx
	leaq	1616(%rsp), %rsi
	leaq	912(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$185:
	leaq	3456(%rsp), %rax
	leaq	3160(%rsp), %rcx
	leaq	2456(%rsp), %rdx
	leaq	1752(%rsp), %rsi
	leaq	1048(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$184:
	leaq	3456(%rsp), %rax
	leaq	3296(%rsp), %rcx
	leaq	2592(%rsp), %rdx
	leaq	1888(%rsp), %rsi
	leaq	1184(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$183:
	leaq	31264(%rsp), %rcx
	leaq	2752(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$181
.L__sign_internal$182:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$181:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$182
	leaq	32288(%rsp), %rcx
	leaq	2048(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$179
.L__sign_internal$180:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$179:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$180
	leaq	33312(%rsp), %rcx
	leaq	1344(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$177
.L__sign_internal$178:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$177:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$178
	leaq	34336(%rsp), %rcx
	leaq	640(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$175
.L__sign_internal$176:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$175:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$176
	addw	$4, 169860(%rsp)
	leaq	128(%rsp), %rcx
	movw	169860(%rsp), %dx
	leaq	3456(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$174:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	2752(%rsp), %rcx
	leaq	2048(%rsp), %rdx
	leaq	1344(%rsp), %rsi
	leaq	640(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$173:
	leaq	3456(%rsp), %rax
	leaq	2888(%rsp), %rcx
	leaq	2184(%rsp), %rdx
	leaq	1480(%rsp), %rsi
	leaq	776(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$172:
	leaq	3456(%rsp), %rax
	leaq	3024(%rsp), %rcx
	leaq	2320(%rsp), %rdx
	leaq	1616(%rsp), %rsi
	leaq	912(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$171:
	leaq	3456(%rsp), %rax
	leaq	3160(%rsp), %rcx
	leaq	2456(%rsp), %rdx
	leaq	1752(%rsp), %rsi
	leaq	1048(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$170:
	leaq	3456(%rsp), %rax
	leaq	3296(%rsp), %rcx
	leaq	2592(%rsp), %rdx
	leaq	1888(%rsp), %rsi
	leaq	1184(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$169:
	leaq	35360(%rsp), %rcx
	leaq	2752(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$167
.L__sign_internal$168:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$167:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$168
	leaq	36384(%rsp), %rcx
	leaq	2048(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$165
.L__sign_internal$166:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$165:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$166
	leaq	37408(%rsp), %rcx
	leaq	1344(%rsp), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$163
.L__sign_internal$164:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4800(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4832(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__sign_internal$163:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$164
	movq	$0, %r8
	jmp 	.L__sign_internal$161
.L__sign_internal$162:
	addq	$32, %r8
.L__sign_internal$161:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$162
	addw	$3, 169860(%rsp)
	movw	169860(%rsp), %ax
	movq	$0, %r9
	jmp 	.L__sign_internal$159
.L__sign_internal$160:
	vmovdqu	31264(%rsp,%r9), %ymm0
	vmovdqu	%ymm0, 24096(%rsp,%r9)
	addq	$32, %r9
.L__sign_internal$159:
	cmpq	$7168, %r9
	jb  	.L__sign_internal$160
	leaq	24096(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__sign_internal$158:
	leaq	112160(%rsp), %rcx
	leaq	24096(%rsp), %rdx
	leaq	71200(%rsp), %rsi
	movq	%rcx, %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$156
.L__sign_internal$157:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$156:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$157
	leaq	72224(%rsp), %rsi
	leaq	7168(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$154
.L__sign_internal$155:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$154:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$155
	leaq	73248(%rsp), %rsi
	leaq	14336(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$152
.L__sign_internal$153:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$152:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$153
	leaq	74272(%rsp), %rsi
	leaq	21504(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$150
.L__sign_internal$151:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$150:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$151
	leaq	75296(%rsp), %rsi
	leaq	28672(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$148
.L__sign_internal$149:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$148:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$149
	leaq	76320(%rsp), %rsi
	leaq	35840(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$146
.L__sign_internal$147:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$146:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$147
	leaq	77344(%rsp), %rsi
	leaq	43008(%rcx), %rdi
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$144
.L__sign_internal$145:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rdi,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rdi,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rdi,%r8), %ymm4
	vmovdqu	4096(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__sign_internal$144:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$145
	leaq	78368(%rsp), %rsi
	leaq	50176(%rcx), %rcx
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rdi
	jmp 	.L__sign_internal$142
.L__sign_internal$143:
	vmovdqu	(%rcx,%rdi), %ymm2
	vmovdqu	(%rdx,%rdi), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rcx,%rdi), %ymm4
	vmovdqu	1024(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rcx,%rdi), %ymm4
	vmovdqu	2048(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rcx,%rdi), %ymm4
	vmovdqu	3072(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%rcx,%rdi), %ymm4
	vmovdqu	4096(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%rcx,%rdi), %ymm4
	vmovdqu	5120(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%rcx,%rdi), %ymm4
	vmovdqu	6144(%rdx,%rdi), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm0, %ymm2, %ymm4
	vpmuldq	%ymm0, %ymm3, %ymm5
	vpmuldq	%ymm1, %ymm4, %ymm4
	vpmuldq	%ymm1, %ymm5, %ymm5
	vpsubq	%ymm4, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%rdi)
	addq	$32, %rdi
.L__sign_internal$142:
	cmpq	$1024, %rdi
	jb  	.L__sign_internal$143
	leaq	71200(%rsp), %rcx
	call	.Lcolumn_vector__reduce32$1
.L__sign_internal$141:
	leaq	71200(%rsp), %rcx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__sign_internal$140:
	leaq	71200(%rsp), %rcx
	leaq	87584(%rsp), %rdx
	leaq	79392(%rsp), %rsi
	movq	%rcx, %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$139:
	leaq	88608(%rsp), %rdx
	leaq	80416(%rsp), %rsi
	leaq	1024(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$138:
	leaq	89632(%rsp), %rdx
	leaq	81440(%rsp), %rsi
	leaq	2048(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$137:
	leaq	90656(%rsp), %rdx
	leaq	82464(%rsp), %rsi
	leaq	3072(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$136:
	leaq	91680(%rsp), %rdx
	leaq	83488(%rsp), %rsi
	leaq	4096(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$135:
	leaq	92704(%rsp), %rdx
	leaq	84512(%rsp), %rsi
	leaq	5120(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$134:
	leaq	93728(%rsp), %rdx
	leaq	85536(%rsp), %rsi
	leaq	6144(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$133:
	leaq	94752(%rsp), %rdx
	leaq	86560(%rsp), %rsi
	leaq	7168(%rcx), %r9
	call	.Lpolynomial__decompose_gamma2_32$1
.L__sign_internal$132:
	leaq	79392(%rsp), %rcx
	leaq	8736(%rsp), %rdx
	movq	%rcx, %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$130
.L__sign_internal$131:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$130:
	cmpq	$128, %r8
	jb  	.L__sign_internal$131
	leaq	8864(%rsp), %rdx
	leaq	1024(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$128
.L__sign_internal$129:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$128:
	cmpq	$128, %r8
	jb  	.L__sign_internal$129
	leaq	8992(%rsp), %rdx
	leaq	2048(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$126
.L__sign_internal$127:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$126:
	cmpq	$128, %r8
	jb  	.L__sign_internal$127
	leaq	9120(%rsp), %rdx
	leaq	3072(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$124
.L__sign_internal$125:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$124:
	cmpq	$128, %r8
	jb  	.L__sign_internal$125
	leaq	9248(%rsp), %rdx
	leaq	4096(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$122
.L__sign_internal$123:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$122:
	cmpq	$128, %r8
	jb  	.L__sign_internal$123
	leaq	9376(%rsp), %rdx
	leaq	5120(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$120
.L__sign_internal$121:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$120:
	cmpq	$128, %r8
	jb  	.L__sign_internal$121
	leaq	9504(%rsp), %rdx
	leaq	6144(%rcx), %rsi
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$118
.L__sign_internal$119:
	vmovdqu	(%rsi,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rsi,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$118:
	cmpq	$128, %r8
	jb  	.L__sign_internal$119
	leaq	9632(%rsp), %rdx
	leaq	7168(%rcx), %rcx
	movq	$4097, %r8
	vmovq	%r8, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__sign_internal$116
.L__sign_internal$117:
	vmovdqu	(%rcx,%r9), %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__sign_internal$116:
	cmpq	$128, %r8
	jb  	.L__sign_internal$117
	movw	%ax, 169860(%rsp)
	leaq	192(%rsp), %rax
	leaq	64(%rsp), %rcx
	leaq	8736(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__sign_internal$115:
	leaq	248(%rsp), %rsp
	leaq	7712(%rsp), %rax
	leaq	192(%rsp), %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.L__sign_internal$113
.L__sign_internal$114:
	vmovdqu	%ymm0, (%rax,%rdx)
	addq	$32, %rdx
.L__sign_internal$113:
	cmpq	$1024, %rdx
	jb  	.L__sign_internal$114
	movq	%rax, 169560(%rsp)
	leaq	416(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__sign_internal$112:
	leaq	416(%rsp), %rcx
	leaq	256(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__sign_internal$111:
	movq	169560(%rsp), %rcx
	movq	256(%rsp), %rsi
	movq	$8, %r10
	lfence
	movq	$0, %r8
	movq	$196, %rdx
	jmp 	.L__sign_internal$104
.L__sign_internal$105:
	movq	$-1, %rax
	cmovnb	%rax, %r8
	jmp 	.L__sign_internal$106
.L__sign_internal$107:
	movq	$-1, %rax
	cmovbe	%rax, %r8
.L__sign_internal$106:
	cmpq	$136, %r10
	jnb 	.L__sign_internal$108
	movq	$-1, %rax
	cmovnb	%rax, %r8
	jmp 	.L__sign_internal$109
.L__sign_internal$108:
	movq	%rdx, 169560(%rsp)
	movq	%rsi, 169552(%rsp)
	movq	%rcx, 169544(%rsp)
	leaq	416(%rsp), %rcx
	leaq	256(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__sign_internal$110:
	movq	169560(%rsp), %rdx
	movq	169552(%rsp), %rsi
	movq	169544(%rsp), %rcx
	movq	$0, %r10
	lfence
	movq	$0, %r8
.L__sign_internal$109:
	movzbq	256(%rsp,%r10), %rax
// declassify_val u64 %rax
	orq 	%r8, %rax
	incq	%r10
	cmpq	%rdx, %rax
	jnbe	.L__sign_internal$107
	movq	$-1, %rdi
	cmovnbe	%rdi, %r8
	movl	(%rcx,%rax,4), %edi
	movl	%edi, (%rcx,%rdx,4)
	movl	%esi, %edi
	andl	$1, %edi
	shll	$1, %edi
	movl	$1, %r9d
	subl	%edi, %r9d
	movl	%r9d, (%rcx,%rax,4)
	shrq	$1, %rsi
	incq	%rdx
.L__sign_internal$104:
	cmpq	$256, %rdx
	jb  	.L__sign_internal$105
	movw	169860(%rsp), %ax
// declassify_mem 1024 [RSP + 7712]
	leaq	7712(%rsp), %rcx
	lfence
	movq	$0, %r8
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	movq	$60, %rsi
	movq	$0, %rdi
	movq	$0, %r9
	jmp 	.L__sign_internal$98
.L__sign_internal$99:
	movq	$-1, %r10
	cmovnb	%r10, %r8
	vmovdqu	(%rcx,%rdi), %ymm2
	vpinsrq	$0, %r8, %xmm1, %xmm1
	vpinsrq	$1, %r8, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$102
.L__sign_internal$103:
	movq	$-1, %r11
	cmove	%r11, %r8
	tzcntq	%r10, %r11
	addq	%r9, %r11
	movl	%r11d, 169616(%rsp,%rdx,4)
	incq	%rdx
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$102:
	cmpq	$0, %r10
	jne 	.L__sign_internal$103
	movq	$-1, %r10
	cmovne	%r10, %r8
	vpcmpgtd	%ymm2, %ymm0, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$100
.L__sign_internal$101:
	movq	$-1, %r11
	cmove	%r11, %r8
	tzcntq	%r10, %r11
	addq	%r9, %r11
	decq	%rsi
	movl	%r11d, 169616(%rsp,%rsi,4)
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$100:
	cmpq	$0, %r10
	jne 	.L__sign_internal$101
	movq	$-1, %r10
	cmovne	%r10, %r8
	addq	$8, %r9
	addq	$32, %rdi
.L__sign_internal$98:
	cmpq	$1024, %rdi
	jb  	.L__sign_internal$99
	movq	$-1, %rcx
	cmovb	%rcx, %r8
	movl	%edx, 169856(%rsp)
	movq	$0, %rcx
	leaq	16928(%rsp), %rdx
	leaq	169616(%rsp), %rsi
	leaq	31264(%rsp), %rdi
	leaq	9760(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$85
.L__sign_internal$86:
	leaq	(%rdx,%r9,4), %rcx
	leaq	(%rdi,%r9,4), %r10
	leaq	(%r8,%r9,4), %r11
	leaq	8736(%rsp), %rbx
	lfence
	movq	$0, %r13
	movl	240(%rsi), %ebp
	orq 	%r13, %rbp
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r12
	jmp 	.L__sign_internal$96
.L__sign_internal$97:
	movq	$-1, %r14
	cmovnb	%r14, %r13
	movl	(%rsi,%r12,4), %r14d
	orq 	%r13, %r14
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
	incq	%r12
.L__sign_internal$96:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$97
	movq	$-1, %r14
	cmovb	%r14, %r13
	jmp 	.L__sign_internal$94
.L__sign_internal$95:
	movq	$-1, %r14
	cmovnb	%r14, %r13
	movl	(%rsi,%r12,4), %r14d
	orq 	%r13, %r14
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
	incq	%r12
.L__sign_internal$94:
	cmpq	$60, %r12
	jb  	.L__sign_internal$95
	movq	$-1, %r12
	cmovb	%r12, %r13
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
	movq	$0, %r12
	jmp 	.L__sign_internal$92
.L__sign_internal$93:
	movq	$-1, %r14
	cmovnb	%r14, %r13
	movl	(%rsi,%r12,4), %r14d
	orq 	%r13, %r14
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
	incq	%r12
.L__sign_internal$92:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$93
	movq	$-1, %rbp
	cmovb	%rbp, %r13
	jmp 	.L__sign_internal$90
.L__sign_internal$91:
	movq	$-1, %rbp
	cmovnb	%rbp, %r13
	movl	(%rsi,%r12,4), %r14d
	orq 	%r13, %r14
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
	incq	%r12
.L__sign_internal$90:
	cmpq	$60, %r12
	jb  	.L__sign_internal$91
	movq	$-1, %rcx
	cmovb	%rcx, %r13
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
	leaq	8736(%rsp), %rcx
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$524167, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$88
.L__sign_internal$89:
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
.L__sign_internal$88:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$89
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$85:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$87
	movq	$1792, %r9
.L__sign_internal$87:
	cmpq	$1792, %r9
	jb  	.L__sign_internal$86
	leaq	63008(%rsp), %rdx
	leaq	87584(%rsp), %rsi
	leaq	54816(%rsp), %rdi
	leaq	169616(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$72
.L__sign_internal$73:
	leaq	8736(%rsp), %rcx
	leaq	(%rdi,%r9,4), %r10
	lfence
	movq	$0, %r11
	movl	240(%r8), %ebp
	orq 	%r11, %rbp
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r12
	jmp 	.L__sign_internal$83
.L__sign_internal$84:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$83:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$84
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$81
.L__sign_internal$82:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$81:
	cmpq	$60, %r12
	jb  	.L__sign_internal$82
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
	movq	$0, %r12
	jmp 	.L__sign_internal$79
.L__sign_internal$80:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$79:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$80
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$77
.L__sign_internal$78:
	movq	$-1, %rbx
	cmovnb	%rbx, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$77:
	cmpq	$60, %r12
	jb  	.L__sign_internal$78
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
	leaq	8736(%rsp), %r11
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$261767, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$75
.L__sign_internal$76:
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
.L__sign_internal$75:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$76
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$72:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$74
	movq	$2048, %r9
.L__sign_internal$74:
	cmpq	$2048, %r9
	jb  	.L__sign_internal$73
	leaq	38432(%rsp), %rdx
	leaq	63008(%rsp), %rsi
	leaq	95776(%rsp), %rdi
	leaq	169616(%rsp), %r8
	movq	$0, %r9
	cmpq	$0, %rcx
	je  	.L__sign_internal$51
	movq	$2048, %r9
.L__sign_internal$71:
	jmp 	.L__sign_internal$51
.L__sign_internal$52:
	lfence
	movq	$0, %r11
	leaq	8736(%rsp), %r10
	leaq	(%rdi,%r9,8), %rbx
	movl	240(%r8), %ebp
	orq 	%r11, %rbp
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpxor	%ymm5, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	movq	$0, %r12
	jmp 	.L__sign_internal$69
.L__sign_internal$70:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$69:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$70
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$67
.L__sign_internal$68:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$67:
	cmpq	$60, %r12
	jb  	.L__sign_internal$68
	movq	$-1, %r12
	cmovb	%r12, %r11
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
	movq	$0, %r12
	jmp 	.L__sign_internal$65
.L__sign_internal$66:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$65:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$66
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$63
.L__sign_internal$64:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$63:
	cmpq	$60, %r12
	jb  	.L__sign_internal$64
	movq	$-1, %r12
	cmovb	%r12, %r11
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
	movq	$0, %r12
	jmp 	.L__sign_internal$61
.L__sign_internal$62:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$61:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$62
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$59
.L__sign_internal$60:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$59:
	cmpq	$60, %r12
	jb  	.L__sign_internal$60
	movq	$-1, %r12
	cmovb	%r12, %r11
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
	movq	$0, %r12
	jmp 	.L__sign_internal$57
.L__sign_internal$58:
	movq	$-1, %r13
	cmovnb	%r13, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$57:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$58
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$55
.L__sign_internal$56:
	movq	$-1, %rbp
	cmovnb	%rbp, %r11
	movl	(%r8,%r12,4), %r14d
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
	incq	%r12
.L__sign_internal$55:
	cmpq	$60, %r12
	jb  	.L__sign_internal$56
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
	leaq	8736(%rsp), %rbx
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rbp
	jmp 	.L__sign_internal$53
.L__sign_internal$54:
	vmovdqu	(%rbx,%rbp), %ymm3
	vpaddd	%ymm0, %ymm3, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm3
	vmovdqu	(%r11,%rbp), %ymm2
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%rbp)
	addq	$32, %rbp
.L__sign_internal$53:
	cmpq	$1024, %rbp
	jb  	.L__sign_internal$54
	addq	$256, %r9
.L__sign_internal$51:
	cmpq	$2048, %r9
	jb  	.L__sign_internal$52
	leaq	38432(%rsp), %rdx
	leaq	79392(%rsp), %rsi
	leaq	46624(%rsp), %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$46
.L__sign_internal$47:
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
	jmp 	.L__sign_internal$49
.L__sign_internal$50:
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
.L__sign_internal$49:
	cmpq	$1024, %r12
	jb  	.L__sign_internal$50
	addq	%rbp, %r8
	addq	$256, %r9
	cmpq	$75, %r8
	setnbe	%r10b
	movzbq	%r10b, %r10
	orq 	%r10, %rcx
.L__sign_internal$46:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$48
	movq	$2048, %r9
.L__sign_internal$48:
	cmpq	$2048, %r9
	jb  	.L__sign_internal$47
// declassify_val u64 %rcx
	movq	169528(%rsp), %rdx
	lfence
	movq	$0, %rsi
	movq	%rcx, 169568(%rsp)
	xorq	$1, %rcx
	movzwl	%ax, %esi
	xorl	$65527, %esi
	testl	%esi, %esi
	sete	%sil
	movzbq	%sil, %rsi
	orq 	%rsi, %rdx
	orq 	%rdx, %rcx
.L__sign_internal$44:
	cmpq	$0, %rcx
	je  	.L__sign_internal$45
	movq	169520(%rsp), %rdi
	lfence
	movq	$0, %r8
	orq 	%r8, %rdi
	cmpq	$0, 169568(%rsp)
	je  	.L__sign_internal$2
	movq	$0, %rdx
	jmp 	.L__sign_internal$42
.L__sign_internal$43:
	movb	$0, (%rdi,%rdx)
	incq	%rdx
.L__sign_internal$42:
	cmpq	$4627, %rdx
	jb  	.L__sign_internal$43
	jmp 	.L__sign_internal$3
.L__sign_internal$2:
// declassify_mem 8192 [RSP + 46624]
// declassify_mem 64 [RSP + 192]
// declassify_mem 7168 [RSP + 9760]
	leaq	192(%rsp), %rdx
	leaq	9760(%rsp), %rax
	leaq	46624(%rsp), %rcx
	movq	$0, %rsi
	jmp 	.L__sign_internal$40
.L__sign_internal$41:
	vmovdqu	(%rdx,%rsi), %xmm0
	vmovdqu	%xmm0, (%rdi,%rsi)
	addq	$16, %rsi
.L__sign_internal$40:
	cmpq	$64, %rsi
	jb  	.L__sign_internal$41
	leaq	64(%rdi), %rdx
	movq	%rdx, %rsi
	movq	%rax, %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$37
.L__sign_internal$38:
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$39:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$37:
	cmpq	$992, %r10
	jb  	.L__sign_internal$38
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$36:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	640(%rdx), %rsi
	leaq	1024(%rax), %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$33
.L__sign_internal$34:
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$35:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r10
.L__sign_internal$33:
	cmpq	$992, %r10
	jb  	.L__sign_internal$34
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$32:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	1280(%rdx), %rsi
	leaq	2048(%rax), %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$29
.L__sign_internal$30:
	vmovdqu	(%r9,%r10), %ymm2
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
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$28:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	1920(%rdx), %rsi
	leaq	3072(%rax), %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$25
.L__sign_internal$26:
	vmovdqu	(%r9,%r10), %ymm2
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
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$24:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	2560(%rdx), %rsi
	leaq	4096(%rax), %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$21
.L__sign_internal$22:
	vmovdqu	(%r9,%r10), %ymm2
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
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$20:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	3200(%rdx), %rsi
	leaq	5120(%rax), %r9
	movq	$524288, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$17
.L__sign_internal$18:
	vmovdqu	(%r9,%r10), %ymm2
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
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$16:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	leaq	3840(%rdx), %rsi
	leaq	6144(%rax), %r9
	movq	$524288, %rax
	vmovq	%rax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r10
	jmp 	.L__sign_internal$13
.L__sign_internal$14:
	vmovdqu	(%r9,%r10), %ymm2
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
	vmovdqu	(%r9,%r10), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$12:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, 169504(%rsp)
// declassify_mem 16 [RSP + 169504]
	movb	169504(%rsp), %r9b
	movb	%r9b, (%rsi,%r8)
	movb	169505(%rsp), %r9b
	movb	%r9b, 1(%rsi,%r8)
	movb	169506(%rsp), %r9b
	movb	%r9b, 2(%rsi,%r8)
	movb	169507(%rsp), %r9b
	movb	%r9b, 3(%rsi,%r8)
	movb	169508(%rsp), %r9b
	movb	%r9b, 4(%rsi,%r8)
	movb	169509(%rsp), %r9b
	movb	%r9b, 5(%rsi,%r8)
	movb	169510(%rsp), %r9b
	movb	%r9b, 6(%rsi,%r8)
	movb	169511(%rsp), %r9b
	movb	%r9b, 7(%rsi,%r8)
	movb	169512(%rsp), %r9b
	movb	%r9b, 8(%rsi,%r8)
	movb	169513(%rsp), %r9b
	movb	%r9b, 9(%rsi,%r8)
	movq	$0, %rax
	movq	%rax, 4544(%rdi)
	movq	%rax, 4552(%rdi)
	movq	%rax, 4560(%rdi)
	movq	%rax, 4568(%rdi)
	movq	%rax, 4576(%rdi)
	movq	%rax, 4584(%rdi)
	movq	%rax, 4592(%rdi)
	movq	%rax, 4600(%rdi)
	movq	%rax, 4608(%rdi)
	movq	%rax, 4616(%rdi)
	movb	$0, 4624(%rdi)
	movb	$0, 4625(%rdi)
	movb	$0, 4626(%rdi)
	lfence
	movq	$0, %r8
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rax
	movq	$0, %rdx
	jmp 	.L__sign_internal$4
.L__sign_internal$5:
	movq	$-1, %rsi
	cmovnb	%rsi, %r8
	movq	%rdx, %rsi
	shlq	$10, %rsi
	movq	%rsi, %r9
	addq	$1024, %r9
	movq	$0, %r10
	jmp 	.L__sign_internal$6
.L__sign_internal$7:
	movq	$-1, %r11
	cmovnb	%r11, %r8
	vmovdqu	(%rcx,%rsi), %ymm2
	vpinsrq	$0, %r8, %xmm1, %xmm1
	vpinsrq	$1, %r8, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm2, %ymm2
	vpcmpeqd	%ymm0, %ymm2, %ymm1
	vmovmskps	%ymm1, %r11d
	movl	%r11d, %r11d
	xorq	$255, %r11
	jmp 	.L__sign_internal$8
.L__sign_internal$9:
	movq	$-1, %rbx
	cmove	%rbx, %r8
	tzcntq	%r11, %r14
	addq	%r10, %r14
	cmpq	$75, %rax
	jb  	.L__sign_internal$10
	movq	$-1, %rbx
	cmovb	%rbx, %r8
	jmp 	.L__sign_internal$11
.L__sign_internal$10:
	movq	$-1, %rbx
	cmovnb	%rbx, %r8
	movb	%r14b, 4544(%rdi,%rax)
	incq	%rax
.L__sign_internal$11:
	movq	%r11, %r14
	decq	%r14
	andq	%r14, %r11
.L__sign_internal$8:
	cmpq	$0, %r11
	jne 	.L__sign_internal$9
	movq	$-1, %r11
	cmovne	%r11, %r8
	addq	$8, %r10
	addq	$32, %rsi
.L__sign_internal$6:
	cmpq	%r9, %rsi
	jb  	.L__sign_internal$7
	movq	$-1, %rsi
	cmovb	%rsi, %r8
	movb	%al, 4619(%rdi,%rdx)
	incq	%rdx
.L__sign_internal$4:
	cmpq	$8, %rdx
	jb  	.L__sign_internal$5
.L__sign_internal$3:
	lfence
	movq	$0, %rax
	movq	169568(%rsp), %rax
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
	movq	%rdi, 95712(%rsp)
	movq	%rsi, 95720(%rsp)
	leaq	64(%rsp), %rdi
	movb	$8, 95768(%rsp)
	movb	$7, 95769(%rsp)
	leaq	95768(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A128__A32_A2$1
.L__keygen_internal$647:
	leaq	248(%rsp), %rsp
// declassify_mem 32 [RSP + 64]
	leaq	64(%rsp), %rsi
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 95728(%rsp)
	movw	$1, 95730(%rsp)
	movw	$2, 95732(%rsp)
	movw	$3, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$646:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$645:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$644:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$643:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$642:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$641:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	38368(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$640:
	movq	%r11, %rax
	leaq	39392(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$639:
	movq	%r11, %rcx
	leaq	40416(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$638:
	movq	%r11, %rdx
	leaq	41440(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$637:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$630
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$632
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$634
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$616
	movl	$0, %esi
.L__keygen_internal$636:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$634:
	movl	$0, %esi
.L__keygen_internal$635:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$632:
	movl	$0, %esi
.L__keygen_internal$633:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$630:
	movl	$0, %esi
.L__keygen_internal$631:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$617:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$629:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	38368(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$628:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	39392(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$627:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	40416(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$626:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	41440(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$625:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$618
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$620
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$622
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$616
	movl	$0, %esi
.L__keygen_internal$624:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$622:
	movl	$0, %esi
.L__keygen_internal$623:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$620:
	movl	$0, %esi
.L__keygen_internal$621:
	jmp 	.L__keygen_internal$616
.L__keygen_internal$618:
	movl	$0, %esi
.L__keygen_internal$619:
.L__keygen_internal$616:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$617
	movw	$4, 95728(%rsp)
	movw	$5, 95730(%rsp)
	movw	$6, 95732(%rsp)
	movw	$256, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$615:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$614:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$613:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$612:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$611:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$610:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	42464(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$609:
	movq	%r11, %rax
	leaq	43488(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$608:
	movq	%r11, %rcx
	leaq	44512(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$607:
	movq	%r11, %rdx
	leaq	45536(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$606:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$599
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$601
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$603
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$585
	movl	$0, %esi
.L__keygen_internal$605:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$603:
	movl	$0, %esi
.L__keygen_internal$604:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$601:
	movl	$0, %esi
.L__keygen_internal$602:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$599:
	movl	$0, %esi
.L__keygen_internal$600:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$586:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$598:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	42464(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$597:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	43488(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$596:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	44512(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$595:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	45536(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$594:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$587
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$589
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$591
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$585
	movl	$0, %esi
.L__keygen_internal$593:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$591:
	movl	$0, %esi
.L__keygen_internal$592:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$589:
	movl	$0, %esi
.L__keygen_internal$590:
	jmp 	.L__keygen_internal$585
.L__keygen_internal$587:
	movl	$0, %esi
.L__keygen_internal$588:
.L__keygen_internal$585:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$586
	movw	$257, 95728(%rsp)
	movw	$258, 95730(%rsp)
	movw	$259, 95732(%rsp)
	movw	$260, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$584:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$583:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$582:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$581:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$580:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$579:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	46560(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$578:
	movq	%r11, %rax
	leaq	47584(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$577:
	movq	%r11, %rcx
	leaq	48608(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$576:
	movq	%r11, %rdx
	leaq	49632(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$575:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$568
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$570
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$572
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$554
	movl	$0, %esi
.L__keygen_internal$574:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$572:
	movl	$0, %esi
.L__keygen_internal$573:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$570:
	movl	$0, %esi
.L__keygen_internal$571:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$568:
	movl	$0, %esi
.L__keygen_internal$569:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$555:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$567:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	46560(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$566:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	47584(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$565:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	48608(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$564:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	49632(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$563:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$556
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$558
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$560
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$554
	movl	$0, %esi
.L__keygen_internal$562:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$560:
	movl	$0, %esi
.L__keygen_internal$561:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$558:
	movl	$0, %esi
.L__keygen_internal$559:
	jmp 	.L__keygen_internal$554
.L__keygen_internal$556:
	movl	$0, %esi
.L__keygen_internal$557:
.L__keygen_internal$554:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$555
	movw	$261, 95728(%rsp)
	movw	$262, 95730(%rsp)
	movw	$512, 95732(%rsp)
	movw	$513, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$553:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$552:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$551:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$550:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$549:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$548:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	50656(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$547:
	movq	%r11, %rax
	leaq	51680(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$546:
	movq	%r11, %rcx
	leaq	52704(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$545:
	movq	%r11, %rdx
	leaq	53728(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$544:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$537
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$539
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$541
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$523
	movl	$0, %esi
.L__keygen_internal$543:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$541:
	movl	$0, %esi
.L__keygen_internal$542:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$539:
	movl	$0, %esi
.L__keygen_internal$540:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$537:
	movl	$0, %esi
.L__keygen_internal$538:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$524:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$536:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	50656(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$535:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	51680(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$534:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	52704(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$533:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	53728(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$532:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$525
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$527
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$529
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$523
	movl	$0, %esi
.L__keygen_internal$531:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$529:
	movl	$0, %esi
.L__keygen_internal$530:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$527:
	movl	$0, %esi
.L__keygen_internal$528:
	jmp 	.L__keygen_internal$523
.L__keygen_internal$525:
	movl	$0, %esi
.L__keygen_internal$526:
.L__keygen_internal$523:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$524
	movw	$514, 95728(%rsp)
	movw	$515, 95730(%rsp)
	movw	$516, 95732(%rsp)
	movw	$517, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$522:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$521:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$520:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$519:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$518:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$517:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	54752(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$516:
	movq	%r11, %rax
	leaq	55776(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$515:
	movq	%r11, %rcx
	leaq	56800(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$514:
	movq	%r11, %rdx
	leaq	57824(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$513:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$506
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$508
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$510
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$492
	movl	$0, %esi
.L__keygen_internal$512:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$510:
	movl	$0, %esi
.L__keygen_internal$511:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$508:
	movl	$0, %esi
.L__keygen_internal$509:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$506:
	movl	$0, %esi
.L__keygen_internal$507:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$493:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$505:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	54752(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$504:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	55776(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$503:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	56800(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$502:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	57824(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$501:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$494
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$496
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$498
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$492
	movl	$0, %esi
.L__keygen_internal$500:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$498:
	movl	$0, %esi
.L__keygen_internal$499:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$496:
	movl	$0, %esi
.L__keygen_internal$497:
	jmp 	.L__keygen_internal$492
.L__keygen_internal$494:
	movl	$0, %esi
.L__keygen_internal$495:
.L__keygen_internal$492:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$493
	movw	$518, 95728(%rsp)
	movw	$768, 95730(%rsp)
	movw	$769, 95732(%rsp)
	movw	$770, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$491:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$490:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$489:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$488:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$487:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$486:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	58848(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$485:
	movq	%r11, %rax
	leaq	59872(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$484:
	movq	%r11, %rcx
	leaq	60896(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$483:
	movq	%r11, %rdx
	leaq	61920(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$482:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$475
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$477
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$479
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$461
	movl	$0, %esi
.L__keygen_internal$481:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$479:
	movl	$0, %esi
.L__keygen_internal$480:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$477:
	movl	$0, %esi
.L__keygen_internal$478:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$475:
	movl	$0, %esi
.L__keygen_internal$476:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$462:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$474:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	58848(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$473:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	59872(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$472:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	60896(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$471:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	61920(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$470:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$463
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$465
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$467
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$461
	movl	$0, %esi
.L__keygen_internal$469:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$467:
	movl	$0, %esi
.L__keygen_internal$468:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$465:
	movl	$0, %esi
.L__keygen_internal$466:
	jmp 	.L__keygen_internal$461
.L__keygen_internal$463:
	movl	$0, %esi
.L__keygen_internal$464:
.L__keygen_internal$461:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$462
	movw	$771, 95728(%rsp)
	movw	$772, 95730(%rsp)
	movw	$773, 95732(%rsp)
	movw	$774, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$460:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$459:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$458:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$457:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$456:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$455:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	62944(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$454:
	movq	%r11, %rax
	leaq	63968(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$453:
	movq	%r11, %rcx
	leaq	64992(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$452:
	movq	%r11, %rdx
	leaq	66016(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$451:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$444
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$446
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$448
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$430
	movl	$0, %esi
.L__keygen_internal$450:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$448:
	movl	$0, %esi
.L__keygen_internal$449:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$446:
	movl	$0, %esi
.L__keygen_internal$447:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$444:
	movl	$0, %esi
.L__keygen_internal$445:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$431:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$443:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	62944(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$442:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	63968(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$441:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	64992(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$440:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	66016(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$439:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$432
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$434
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$436
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$430
	movl	$0, %esi
.L__keygen_internal$438:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$436:
	movl	$0, %esi
.L__keygen_internal$437:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$434:
	movl	$0, %esi
.L__keygen_internal$435:
	jmp 	.L__keygen_internal$430
.L__keygen_internal$432:
	movl	$0, %esi
.L__keygen_internal$433:
.L__keygen_internal$430:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$431
	movw	$1024, 95728(%rsp)
	movw	$1025, 95730(%rsp)
	movw	$1026, 95732(%rsp)
	movw	$1027, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$429:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$428:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$427:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$426:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$425:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$424:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	67040(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$423:
	movq	%r11, %rax
	leaq	68064(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$422:
	movq	%r11, %rcx
	leaq	69088(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$421:
	movq	%r11, %rdx
	leaq	70112(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$420:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$413
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$415
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$417
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$399
	movl	$0, %esi
.L__keygen_internal$419:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$417:
	movl	$0, %esi
.L__keygen_internal$418:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$415:
	movl	$0, %esi
.L__keygen_internal$416:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$413:
	movl	$0, %esi
.L__keygen_internal$414:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$400:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$412:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	67040(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$411:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	68064(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$410:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	69088(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$409:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	70112(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$408:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$401
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$403
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$405
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$399
	movl	$0, %esi
.L__keygen_internal$407:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$405:
	movl	$0, %esi
.L__keygen_internal$406:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$403:
	movl	$0, %esi
.L__keygen_internal$404:
	jmp 	.L__keygen_internal$399
.L__keygen_internal$401:
	movl	$0, %esi
.L__keygen_internal$402:
.L__keygen_internal$399:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$400
	movw	$1028, 95728(%rsp)
	movw	$1029, 95730(%rsp)
	movw	$1030, 95732(%rsp)
	movw	$1280, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$398:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$397:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$396:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$395:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$394:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$393:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	71136(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$392:
	movq	%r11, %rax
	leaq	72160(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$391:
	movq	%r11, %rcx
	leaq	73184(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$390:
	movq	%r11, %rdx
	leaq	74208(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$389:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$382
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$384
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$386
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$368
	movl	$0, %esi
.L__keygen_internal$388:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$386:
	movl	$0, %esi
.L__keygen_internal$387:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$384:
	movl	$0, %esi
.L__keygen_internal$385:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$382:
	movl	$0, %esi
.L__keygen_internal$383:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$369:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$381:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	71136(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$380:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	72160(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$379:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	73184(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$378:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	74208(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$377:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$370
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$372
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$374
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$368
	movl	$0, %esi
.L__keygen_internal$376:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$374:
	movl	$0, %esi
.L__keygen_internal$375:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$372:
	movl	$0, %esi
.L__keygen_internal$373:
	jmp 	.L__keygen_internal$368
.L__keygen_internal$370:
	movl	$0, %esi
.L__keygen_internal$371:
.L__keygen_internal$368:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$369
	movw	$1281, 95728(%rsp)
	movw	$1282, 95730(%rsp)
	movw	$1283, 95732(%rsp)
	movw	$1284, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$367:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$366:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$365:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$364:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$363:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$362:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	75232(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$361:
	movq	%r11, %rax
	leaq	76256(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$360:
	movq	%r11, %rcx
	leaq	77280(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$359:
	movq	%r11, %rdx
	leaq	78304(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$358:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$351
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$353
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$355
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$337
	movl	$0, %esi
.L__keygen_internal$357:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$355:
	movl	$0, %esi
.L__keygen_internal$356:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$353:
	movl	$0, %esi
.L__keygen_internal$354:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$351:
	movl	$0, %esi
.L__keygen_internal$352:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$338:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$350:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	75232(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$349:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	76256(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$348:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	77280(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$347:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	78304(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$346:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$339
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$341
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$343
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$337
	movl	$0, %esi
.L__keygen_internal$345:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$343:
	movl	$0, %esi
.L__keygen_internal$344:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$341:
	movl	$0, %esi
.L__keygen_internal$342:
	jmp 	.L__keygen_internal$337
.L__keygen_internal$339:
	movl	$0, %esi
.L__keygen_internal$340:
.L__keygen_internal$337:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$338
	movw	$1285, 95728(%rsp)
	movw	$1286, 95730(%rsp)
	movw	$1536, 95732(%rsp)
	movw	$1537, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$336:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$335:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$334:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$333:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$332:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$331:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	79328(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$330:
	movq	%r11, %rax
	leaq	80352(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$329:
	movq	%r11, %rcx
	leaq	81376(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$328:
	movq	%r11, %rdx
	leaq	82400(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$327:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$320
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$322
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$324
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$306
	movl	$0, %esi
.L__keygen_internal$326:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$324:
	movl	$0, %esi
.L__keygen_internal$325:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$322:
	movl	$0, %esi
.L__keygen_internal$323:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$320:
	movl	$0, %esi
.L__keygen_internal$321:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$307:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$319:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	79328(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$318:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	80352(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$317:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	81376(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$316:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	82400(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$315:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$308
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$310
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$312
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$306
	movl	$0, %esi
.L__keygen_internal$314:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$312:
	movl	$0, %esi
.L__keygen_internal$313:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$310:
	movl	$0, %esi
.L__keygen_internal$311:
	jmp 	.L__keygen_internal$306
.L__keygen_internal$308:
	movl	$0, %esi
.L__keygen_internal$309:
.L__keygen_internal$306:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$307
	movw	$1538, 95728(%rsp)
	movw	$1539, 95730(%rsp)
	movw	$1540, 95732(%rsp)
	movw	$1541, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$305:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$304:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$303:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$302:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$301:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$300:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	83424(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$299:
	movq	%r11, %rax
	leaq	84448(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$298:
	movq	%r11, %rcx
	leaq	85472(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$297:
	movq	%r11, %rdx
	leaq	86496(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$296:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$289
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$291
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$293
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$275
	movl	$0, %esi
.L__keygen_internal$295:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$293:
	movl	$0, %esi
.L__keygen_internal$294:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$291:
	movl	$0, %esi
.L__keygen_internal$292:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$289:
	movl	$0, %esi
.L__keygen_internal$290:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$276:
	movq	%rax, 95760(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95744(%rsp)
	movq	%r11, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$288:
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rcx
	movq	95744(%rsp), %rdx
	movq	95736(%rsp), %r12
	leaq	83424(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$287:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	84448(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$286:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	85472(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$285:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	86496(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$284:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$277
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$279
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$281
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$275
	movl	$0, %esi
.L__keygen_internal$283:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$281:
	movl	$0, %esi
.L__keygen_internal$282:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$279:
	movl	$0, %esi
.L__keygen_internal$280:
	jmp 	.L__keygen_internal$275
.L__keygen_internal$277:
	movl	$0, %esi
.L__keygen_internal$278:
.L__keygen_internal$275:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$276
	movw	$1542, 95728(%rsp)
	movw	$1792, 95730(%rsp)
	movw	$1793, 95732(%rsp)
	movw	$1794, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$274:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$273:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$272:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$271:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$270:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$269:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	87520(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$268:
	movq	%r11, %rax
	leaq	88544(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$267:
	movq	%r11, %rcx
	leaq	89568(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$266:
	movq	%r11, %rdx
	leaq	90592(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$265:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$258
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$260
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$262
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$244
	movl	$0, %esi
.L__keygen_internal$264:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$262:
	movl	$0, %esi
.L__keygen_internal$263:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$260:
	movl	$0, %esi
.L__keygen_internal$261:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$258:
	movl	$0, %esi
.L__keygen_internal$259:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$245:
	movq	%rax, 95736(%rsp)
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$257:
	movq	95736(%rsp), %r11
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %r12
	leaq	87520(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$256:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	88544(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$255:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	89568(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$254:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	90592(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$253:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$246
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$248
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$250
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$244
	movl	$0, %esi
.L__keygen_internal$252:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$250:
	movl	$0, %esi
.L__keygen_internal$251:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$248:
	movl	$0, %esi
.L__keygen_internal$249:
	jmp 	.L__keygen_internal$244
.L__keygen_internal$246:
	movl	$0, %esi
.L__keygen_internal$247:
.L__keygen_internal$244:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$245
	movw	$1795, 95728(%rsp)
	movw	$1796, 95730(%rsp)
	movw	$1797, 95732(%rsp)
	movw	$1798, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	95728(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$243:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$242:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$241:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$240:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$239:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$238:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	91616(%rsp), %rsi
	leaq	4736(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$237:
	movq	%r11, %rax
	leaq	92640(%rsp), %rsi
	leaq	3872(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$236:
	movq	%r11, %rcx
	leaq	93664(%rsp), %rsi
	leaq	3008(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$235:
	movq	%r11, %rdx
	leaq	94688(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$234:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$227
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$229
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$231
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$213
	movl	$0, %esi
.L__keygen_internal$233:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$231:
	movl	$0, %esi
.L__keygen_internal$232:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$229:
	movl	$0, %esi
.L__keygen_internal$230:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$227:
	movl	$0, %esi
.L__keygen_internal$228:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$214:
	movq	%rax, 95728(%rsp)
	movq	%rcx, 95760(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r11, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$226:
	movq	95728(%rsp), %r11
	movq	95760(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95744(%rsp), %r12
	leaq	91616(%rsp), %rsi
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$225:
	movq	%r11, %rax
	movq	%rcx, %r11
	leaq	92640(%rsp), %rsi
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$224:
	movq	%r11, %rcx
	movq	%rdx, %r11
	leaq	93664(%rsp), %rsi
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$223:
	movq	%r11, %rdx
	movq	%r12, %r11
	leaq	94688(%rsp), %rsi
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$222:
	movl	$1, %esi
	cmpq	$256, %rax
	jb  	.L__keygen_internal$215
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$217
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$219
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$213
	movl	$0, %esi
.L__keygen_internal$221:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$219:
	movl	$0, %esi
.L__keygen_internal$220:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$217:
	movl	$0, %esi
.L__keygen_internal$218:
	jmp 	.L__keygen_internal$213
.L__keygen_internal$215:
	movl	$0, %esi
.L__keygen_internal$216:
.L__keygen_internal$213:
	cmpl	$1, %esi
	jne 	.L__keygen_internal$214
	leaq	96(%rsp), %rcx
	movw	$0, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$212:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$211:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$210:
	leaq	6624(%rsp), %rdi
	leaq	1056(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$209:
	movq	%r11, %rcx
	leaq	7648(%rsp), %rdi
	leaq	768(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$208:
	movq	%r11, %rdx
	leaq	8672(%rsp), %rdi
	leaq	480(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$207:
	movq	%r11, %rsi
	leaq	9696(%rsp), %rdi
	leaq	192(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$206:
	movq	%r11, %r8
	movq	$1, %rax
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$199
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$201
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$203
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$181
	movq	$0, %rax
.L__keygen_internal$205:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$203:
	movq	$0, %rax
.L__keygen_internal$204:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$201:
	movq	$0, %rax
.L__keygen_internal$202:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$199:
	movq	$0, %rax
.L__keygen_internal$200:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$182:
	movq	%rcx, 95744(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%rsi, 95760(%rsp)
	movq	%r8, 95728(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$198:
	movq	95744(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95760(%rsp), %rsi
	movq	95728(%rsp), %r8
	lfence
	movq	$0, %r10
	cmpq	$256, %rcx
	jnb 	.L__keygen_internal$196
	movq	%rcx, %r11
	leaq	6624(%rsp), %rax
	leaq	1056(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$197:
	movq	%r11, %rcx
.L__keygen_internal$196:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$194
	movq	%rdx, %r11
	leaq	7648(%rsp), %rax
	leaq	768(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$195:
	movq	%r11, %rdx
.L__keygen_internal$194:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$192
	movq	%rsi, %r11
	leaq	8672(%rsp), %rax
	leaq	480(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$193:
	movq	%r11, %rsi
.L__keygen_internal$192:
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$190
	movq	%r8, %r11
	leaq	9696(%rsp), %rax
	leaq	192(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$191:
	movq	%r11, %r8
.L__keygen_internal$190:
	movq	$1, %rax
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$183
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$185
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$187
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$181
	movq	$0, %rax
.L__keygen_internal$189:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$187:
	movq	$0, %rax
.L__keygen_internal$188:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$185:
	movq	$0, %rax
.L__keygen_internal$186:
	jmp 	.L__keygen_internal$181
.L__keygen_internal$183:
	movq	$0, %rax
.L__keygen_internal$184:
.L__keygen_internal$181:
	cmpq	$1, %rax
	jne 	.L__keygen_internal$182
	leaq	96(%rsp), %rcx
	movw	$4, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$180:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$179:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$178:
	leaq	10720(%rsp), %rdi
	leaq	1056(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$177:
	movq	%r11, %rsi
	leaq	11744(%rsp), %rdi
	leaq	768(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$176:
	movq	%r11, %rcx
	leaq	12768(%rsp), %rdi
	leaq	480(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$175:
	movq	%r11, %rdx
	leaq	13792(%rsp), %rdi
	leaq	192(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$174:
	movq	%r11, %r8
	movq	$1, %rax
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$167
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$169
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$171
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$149
	movq	$0, %rax
.L__keygen_internal$173:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$171:
	movq	$0, %rax
.L__keygen_internal$172:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$169:
	movq	$0, %rax
.L__keygen_internal$170:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$167:
	movq	$0, %rax
.L__keygen_internal$168:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$150:
	movq	%rsi, 95728(%rsp)
	movq	%rcx, 95760(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%r8, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$166:
	movq	95728(%rsp), %rsi
	movq	95760(%rsp), %rcx
	movq	95752(%rsp), %rdx
	movq	95744(%rsp), %r8
	lfence
	movq	$0, %rax
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$164
	movq	%rsi, %r11
	leaq	10720(%rsp), %rax
	leaq	1056(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$165:
	movq	%r11, %rsi
.L__keygen_internal$164:
	cmpq	$256, %rcx
	jnb 	.L__keygen_internal$162
	movq	%rcx, %r11
	leaq	11744(%rsp), %rax
	leaq	768(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$163:
	movq	%r11, %rcx
.L__keygen_internal$162:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$160
	movq	%rdx, %r11
	leaq	12768(%rsp), %rax
	leaq	480(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$161:
	movq	%r11, %rdx
.L__keygen_internal$160:
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$158
	movq	%r8, %r11
	leaq	13792(%rsp), %rax
	leaq	192(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$159:
	movq	%r11, %r8
.L__keygen_internal$158:
	movq	$1, %rax
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$151
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$153
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$155
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$149
	movq	$0, %rax
.L__keygen_internal$157:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$155:
	movq	$0, %rax
.L__keygen_internal$156:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$153:
	movq	$0, %rax
.L__keygen_internal$154:
	jmp 	.L__keygen_internal$149
.L__keygen_internal$151:
	movq	$0, %rax
.L__keygen_internal$152:
.L__keygen_internal$149:
	cmpq	$1, %rax
	jne 	.L__keygen_internal$150
	leaq	96(%rsp), %rcx
	movw	$8, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$148:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$147:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$146:
	leaq	14816(%rsp), %rdi
	leaq	1056(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$145:
	movq	%r11, %rsi
	leaq	15840(%rsp), %rdi
	leaq	768(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$144:
	movq	%r11, %rcx
	leaq	16864(%rsp), %rdi
	leaq	480(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$143:
	movq	%r11, %rdx
	leaq	17888(%rsp), %rdi
	leaq	192(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$142:
	movq	%r11, %r8
	movq	$1, %rax
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$135
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$137
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$139
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$117
	movq	$0, %rax
.L__keygen_internal$141:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$139:
	movq	$0, %rax
.L__keygen_internal$140:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$137:
	movq	$0, %rax
.L__keygen_internal$138:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$135:
	movq	$0, %rax
.L__keygen_internal$136:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$118:
	movq	%rsi, 95744(%rsp)
	movq	%rcx, 95752(%rsp)
	movq	%rdx, 95760(%rsp)
	movq	%r8, 95728(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$134:
	movq	95744(%rsp), %rsi
	movq	95752(%rsp), %rcx
	movq	95760(%rsp), %rdx
	movq	95728(%rsp), %r8
	lfence
	movq	$0, %rax
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$132
	movq	%rsi, %r11
	leaq	14816(%rsp), %rax
	leaq	1056(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$133:
	movq	%r11, %rsi
.L__keygen_internal$132:
	cmpq	$256, %rcx
	jnb 	.L__keygen_internal$130
	movq	%rcx, %r11
	leaq	15840(%rsp), %rax
	leaq	768(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$131:
	movq	%r11, %rcx
.L__keygen_internal$130:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$128
	movq	%rdx, %r11
	leaq	16864(%rsp), %rax
	leaq	480(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$129:
	movq	%r11, %rdx
.L__keygen_internal$128:
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$126
	movq	%r8, %r11
	leaq	17888(%rsp), %rax
	leaq	192(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$127:
	movq	%r11, %r8
.L__keygen_internal$126:
	movq	$1, %rax
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$119
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$121
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$123
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$117
	movq	$0, %rax
.L__keygen_internal$125:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$123:
	movq	$0, %rax
.L__keygen_internal$124:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$121:
	movq	$0, %rax
.L__keygen_internal$122:
	jmp 	.L__keygen_internal$117
.L__keygen_internal$119:
	movq	$0, %rax
.L__keygen_internal$120:
.L__keygen_internal$117:
	cmpq	$1, %rax
	jne 	.L__keygen_internal$118
	leaq	96(%rsp), %rcx
	movw	$12, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$116:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$115:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$114:
	leaq	18912(%rsp), %rdi
	leaq	1056(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$113:
	movq	%r11, %rcx
	leaq	19936(%rsp), %rdi
	leaq	768(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$112:
	movq	%r11, %rdx
	leaq	20960(%rsp), %rdi
	leaq	480(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$111:
	movq	%r11, %rsi
	leaq	5600(%rsp), %rdi
	leaq	192(%rsp), %rbx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$110:
	movq	%r11, %r8
	movq	$1, %rax
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$103
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$105
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$107
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$85
	movq	$0, %rax
.L__keygen_internal$109:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$107:
	movq	$0, %rax
.L__keygen_internal$108:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$105:
	movq	$0, %rax
.L__keygen_internal$106:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$103:
	movq	$0, %rax
.L__keygen_internal$104:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$86:
	movq	%rcx, 95728(%rsp)
	movq	%rdx, 95760(%rsp)
	movq	%rsi, 95752(%rsp)
	movq	%r8, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$102:
	movq	95728(%rsp), %rcx
	movq	95760(%rsp), %rdx
	movq	95752(%rsp), %rsi
	movq	95744(%rsp), %r8
	lfence
	movq	$0, %rax
	cmpq	$256, %rcx
	jnb 	.L__keygen_internal$100
	movq	%rcx, %r11
	leaq	18912(%rsp), %rax
	leaq	1056(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$101:
	movq	%r11, %rcx
.L__keygen_internal$100:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$98
	movq	%rdx, %r11
	leaq	19936(%rsp), %rax
	leaq	768(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$99:
	movq	%r11, %rdx
.L__keygen_internal$98:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$96
	movq	%rsi, %r11
	leaq	20960(%rsp), %rax
	leaq	480(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$97:
	movq	%r11, %rsi
.L__keygen_internal$96:
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$94
	movq	%r8, %r11
	leaq	5600(%rsp), %rax
	leaq	192(%rsp), %rdi
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$95:
	movq	%r11, %r8
.L__keygen_internal$94:
	movq	$1, %rax
	cmpq	$256, %rcx
	jb  	.L__keygen_internal$87
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$89
	cmpq	$256, %rsi
	jb  	.L__keygen_internal$91
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$85
	movq	$0, %rax
.L__keygen_internal$93:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$91:
	movq	$0, %rax
.L__keygen_internal$92:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$89:
	movq	$0, %rax
.L__keygen_internal$90:
	jmp 	.L__keygen_internal$85
.L__keygen_internal$87:
	movq	$0, %rax
.L__keygen_internal$88:
.L__keygen_internal$85:
	cmpq	$1, %rax
	jne 	.L__keygen_internal$86
	movq	95712(%rsp), %rdi
	movq	95720(%rsp), %rsi
	lfence
	movq	$0, %r8
	orq 	%r8, %rdi
	orq 	%r8, %rsi
	vmovdqu	64(%rsp), %ymm0
	vmovdqu	%ymm0, (%rsi)
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	%ymm0, 32(%rsi)
	leaq	6624(%rsp), %rcx
	leaq	128(%rsi), %rdx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$84:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	96(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$83:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	192(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$82:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	288(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$81:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	384(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$80:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	480(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$79:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	576(%rdx), %rax
	leaq	6144(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$78:
	leaq	24(%rsp), %rsp
	leaq	13792(%rsp), %rcx
	leaq	800(%rsi), %rdx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$77:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	96(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$76:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	192(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$75:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	288(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$74:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	384(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$73:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	480(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$72:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	576(%rdx), %rax
	leaq	6144(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$71:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	672(%rdx), %rax
	leaq	7168(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$70:
	leaq	24(%rsp), %rsp
	movq	%rsi, 95720(%rsp)
	leaq	6624(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__keygen_internal$69:
	leaq	38368(%rsp), %rax
	leaq	6624(%rsp), %rcx
	leaq	13792(%rsp), %rdx
	leaq	21984(%rsp), %rsi
	movq	%rax, %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$67
.L__keygen_internal$68:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$67:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$68
	leaq	23008(%rsp), %rsi
	leaq	7168(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$65
.L__keygen_internal$66:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$65:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$66
	leaq	24032(%rsp), %rsi
	leaq	14336(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$63
.L__keygen_internal$64:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$63:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$64
	leaq	25056(%rsp), %rsi
	leaq	21504(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$61
.L__keygen_internal$62:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$61:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$62
	leaq	26080(%rsp), %rsi
	leaq	28672(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$59
.L__keygen_internal$60:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$59:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$60
	leaq	27104(%rsp), %rsi
	leaq	35840(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$57
.L__keygen_internal$58:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$57:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$58
	leaq	28128(%rsp), %rsi
	leaq	43008(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$55
.L__keygen_internal$56:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$55:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$56
	leaq	29152(%rsp), %rsi
	leaq	50176(%rax), %r8
	vmovdqu	glob_data + 4608(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$53
.L__keygen_internal$54:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	4096(%r8,%r9), %ymm4
	vmovdqu	4096(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
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
.L__keygen_internal$53:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$54
	leaq	21984(%rsp), %rcx
	call	.Lcolumn_vector__reduce32$1
.L__keygen_internal$52:
	leaq	21984(%rsp), %rcx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__keygen_internal$51:
	leaq	21984(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %mm1
	leaq	30176(%rsp), %rax
	call	.Lpolynomial__add$1
.L__keygen_internal$50:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	31200(%rsp), %rax
	leaq	1024(%rcx), %rcx
	leaq	1024(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$49:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	32224(%rsp), %rax
	leaq	2048(%rcx), %rcx
	leaq	2048(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$48:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	33248(%rsp), %rax
	leaq	3072(%rcx), %rcx
	leaq	3072(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$47:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	34272(%rsp), %rax
	leaq	4096(%rcx), %rcx
	leaq	4096(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$46:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	35296(%rsp), %rax
	leaq	5120(%rcx), %rcx
	leaq	5120(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$45:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	36320(%rsp), %rax
	leaq	6144(%rcx), %rcx
	leaq	6144(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$44:
	movq	%mm0, %rcx
	movq	%mm1, %rdx
	leaq	37344(%rsp), %rax
	leaq	7168(%rcx), %rcx
	leaq	7168(%rdx), %rdx
	call	.Lpolynomial__add$1
.L__keygen_internal$43:
	leaq	30176(%rsp), %rax
	movq	%rax, %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$42:
	leaq	1024(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$41:
	leaq	2048(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$40:
	leaq	3072(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$39:
	leaq	4096(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$38:
	leaq	5120(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$37:
	leaq	6144(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$36:
	leaq	7168(%rax), %rcx
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$35:
	leaq	30176(%rsp), %rax
	leaq	13792(%rsp), %rcx
	leaq	21984(%rsp), %rdx
	movq	%rax, %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$33
.L__keygen_internal$34:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$33:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$34
	leaq	14816(%rsp), %rcx
	leaq	23008(%rsp), %rdx
	leaq	1024(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$31
.L__keygen_internal$32:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$31:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$32
	leaq	15840(%rsp), %rcx
	leaq	24032(%rsp), %rdx
	leaq	2048(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$29
.L__keygen_internal$30:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$29:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$30
	leaq	16864(%rsp), %rcx
	leaq	25056(%rsp), %rdx
	leaq	3072(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$27
.L__keygen_internal$28:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$27:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$28
	leaq	17888(%rsp), %rcx
	leaq	26080(%rsp), %rdx
	leaq	4096(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$25
.L__keygen_internal$26:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$25:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$26
	leaq	18912(%rsp), %rcx
	leaq	27104(%rsp), %rdx
	leaq	5120(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$23
.L__keygen_internal$24:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$23:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$24
	leaq	19936(%rsp), %rcx
	leaq	28128(%rsp), %rdx
	leaq	6144(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %r8
	vmovq	%r8, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$21
.L__keygen_internal$22:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$21:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$22
	leaq	20960(%rsp), %rcx
	leaq	29152(%rsp), %rdx
	leaq	7168(%rax), %rsi
	vmovdqu	glob_data + 5184(%rip), %ymm0
	movq	$1, %rax
	vmovq	%rax, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$19
.L__keygen_internal$20:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$19:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$20
	leaq	32(%rdi), %rax
	leaq	13792(%rsp), %r8
	movq	%r8, %mm0
	movq	%rax, %rcx
	movq	%r8, %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$18:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	320(%rax), %rcx
	leaq	1024(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$17:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	640(%rax), %rcx
	leaq	2048(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$16:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	960(%rax), %rcx
	leaq	3072(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$15:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	1280(%rax), %rcx
	leaq	4096(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$14:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	1600(%rax), %rcx
	leaq	5120(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$13:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	1920(%rax), %rcx
	leaq	6144(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$12:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	2240(%rax), %rcx
	leaq	7168(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$11:
	leaq	24(%rsp), %rsp
// declassify_mem 2592 [RDI]
	movq	%rdi, %rcx
	movq	95720(%rsp), %rsi
	lfence
	movq	$0, %r8
	leaq	64(%rsi), %rax
	movq	%rdi, 95720(%rsp)
	movq	%rsi, 95712(%rsp)
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__keygen_internal$10:
	leaq	248(%rsp), %rsp
	movq	95720(%rsp), %rdi
	movq	95712(%rsp), %rsi
	lfence
	movq	$0, %r8
	orq 	%r8, %rdi
	orq 	%r8, %rsi
	leaq	1568(%rsi), %rax
	leaq	21984(%rsp), %rdx
	movq	%rdx, %mm0
	movq	%rax, %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$9:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	416(%rax), %rcx
	leaq	1024(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$8:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	832(%rax), %rcx
	leaq	2048(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$7:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	1248(%rax), %rcx
	leaq	3072(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$6:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	1664(%rax), %rcx
	leaq	4096(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$5:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	2080(%rax), %rcx
	leaq	5120(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$4:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	2496(%rax), %rcx
	leaq	6144(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$3:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rdx
	leaq	2912(%rax), %rcx
	leaq	7168(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$2:
	leaq	24(%rsp), %rsp
	ret
.Lerror_4x__rejection_sample_one_block$1:
	lfence
	movq	$0, %r9
	movq	$0, %r10
	movq	$0, %rbp
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$3:
	movq	$-1, %rbx
	cmove	%rbx, %r9
	movzbl	(%rdi,%r10), %ebx
	andl	$15, %ebx
// declassify_val u32 %ebx
	orl 	%r9d, %ebx
	cmpl	$15, %ebx
	jb  	.Lerror_4x__rejection_sample_one_block$12
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	jmp 	.Lerror_4x__rejection_sample_one_block$13
.Lerror_4x__rejection_sample_one_block$12:
	movq	$-1, %r12
	cmovnb	%r12, %r9
	movl	%ebx, %r12d
	imull	$205, %r12d, %r12d
	shrl	$10, %r12d
	imull	$5, %r12d, %r12d
	subl	%r12d, %ebx
	addl	$-2, %ebx
	negl	%ebx
	movl	%ebx, (%rax,%r11,4)
	incq	%r11
.Lerror_4x__rejection_sample_one_block$13:
	cmpq	$256, %r11
	jb  	.Lerror_4x__rejection_sample_one_block$8
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %r9
	movzbl	(%rdi,%r10), %ebx
	shrl	$4, %ebx
// declassify_val u32 %ebx
	orl 	%r9d, %ebx
	cmpl	$15, %ebx
	jb  	.Lerror_4x__rejection_sample_one_block$10
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$10:
	movq	$-1, %r12
	cmovnb	%r12, %r9
	movl	%ebx, %r12d
	imull	$205, %r12d, %r12d
	shrl	$10, %r12d
	imull	$5, %r12d, %r12d
	subl	%r12d, %ebx
	addl	$-2, %ebx
	negl	%ebx
	movl	%ebx, (%rax,%r11,4)
	incq	%r11
.Lerror_4x__rejection_sample_one_block$11:
.Lerror_4x__rejection_sample_one_block$9:
	incq	%r10
	cmpq	$136, %r10
	jnb 	.Lerror_4x__rejection_sample_one_block$4
	movq	$-1, %rbx
	cmovnb	%rbx, %r9
	cmpq	$256, %r11
	jnb 	.Lerror_4x__rejection_sample_one_block$6
	movq	$-1, %rbx
	cmovnb	%rbx, %r9
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$6:
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	movq	$1, %rbp
.Lerror_4x__rejection_sample_one_block$7:
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$4:
	movq	$-1, %rbx
	cmovb	%rbx, %r9
	movq	$1, %rbp
.Lerror_4x__rejection_sample_one_block$5:
.Lerror_4x__rejection_sample_one_block$2:
	cmpq	$1, %rbp
	jne 	.Lerror_4x__rejection_sample_one_block$3
	ret
.Lerror_4x__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %r13
	movq	$2, %rax
	vmovq	%rax, %xmm0
	vpbroadcastb	%xmm0, %ymm0
	movq	$15, %rax
	vmovq	%rax, %xmm1
	vpbroadcastb	%xmm1, %ymm1
	movq	$0, %r11
	movq	$0, %r10
	movq	$0, %rbp
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$19:
	movq	$-1, %rax
	cmove	%rax, %r13
	vmovdqu	(%rbx,%r10), %xmm2
	movq	$15, %rax
	vmovq	%rax, %xmm5
	vpbroadcastb	%xmm5, %ymm5
	vpmovzxbw	%xmm2, %ymm2
	vpsllw	$4, %ymm2, %ymm3
	vpor	%ymm3, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpsubb	%ymm1, %ymm2, %ymm3
	vpmovmskb	%ymm3, %r9d
	vpsubb	%ymm2, %ymm0, %ymm2
	vextracti128	$0, %ymm2, %xmm3
// declassify_val u64 %r9
	orq 	%r13, %r9
	movq	%r9, %r8
	andq	$255, %r8
	shrq	$8, %r9
	leaq	glob_data + 5520(%rip), %rax
	movq	%r8, %r12
	shlq	$3, %r12
	vmovq	(%rax,%r12), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %rax
	vmovq	%rax, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %rax
	vmovq	%rax, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rdi,%r11)
	popcnt	%r8, %r8
	shlq	$2, %r8
	addq	%r8, %r11
	addq	$4, %r10
	cmpq	$992, %r11
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$24
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$24:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	vpsrldq	$8, %xmm3, %xmm3
	movq	%r9, %r12
	andq	$255, %r12
	shrq	$8, %r9
	leaq	glob_data + 5520(%rip), %rax
	movq	%r12, %r8
	shlq	$3, %r8
	vmovq	(%rax,%r8), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %rax
	vmovq	%rax, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %rax
	vmovq	%rax, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rdi,%r11)
	popcnt	%r12, %r8
	shlq	$2, %r8
	addq	%r8, %r11
	addq	$4, %r10
	cmpq	$992, %r11
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$26
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$26:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	vextracti128	$1, %ymm2, %xmm3
	movq	%r9, %r8
	andq	$255, %r8
	shrq	$8, %r9
	leaq	glob_data + 5520(%rip), %r12
	movq	%r8, %rax
	shlq	$3, %rax
	vmovq	(%r12,%rax), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %rax
	vmovq	%rax, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %rax
	vmovq	%rax, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rdi,%r11)
	popcnt	%r8, %r8
	shlq	$2, %r8
	addq	%r8, %r11
	addq	$4, %r10
	cmpq	$992, %r11
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$28
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$28:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	vpsrldq	$8, %xmm3, %xmm3
	andq	$255, %r9
	leaq	glob_data + 5520(%rip), %r8
	movq	%r9, %rax
	shlq	$3, %rax
	vmovq	(%r8,%rax), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %rax
	vmovq	%rax, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %rax
	vmovq	%rax, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rdi,%r11)
	popcnt	%r9, %r8
	shlq	$2, %r8
	addq	%r8, %r11
	addq	$4, %r10
.Lerror_4x__rejection_sample_multiple_blocks$29:
.Lerror_4x__rejection_sample_multiple_blocks$27:
.Lerror_4x__rejection_sample_multiple_blocks$25:
	cmpq	$992, %r11
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$20
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %r10
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$22
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$22:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rbp
.Lerror_4x__rejection_sample_multiple_blocks$23:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$20:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rbp
.Lerror_4x__rejection_sample_multiple_blocks$21:
.Lerror_4x__rejection_sample_multiple_blocks$18:
	cmpq	$1, %rbp
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$19
	movq	$-1, %rax
	cmovne	%rax, %r13
	shrq	$2, %r11
	cmpq	$256, %r11
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$14
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$14:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$272, %r10
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$16
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$16:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movq	$0, %rbp
.Lerror_4x__rejection_sample_multiple_blocks$17:
.Lerror_4x__rejection_sample_multiple_blocks$15:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$3:
	movq	$-1, %rax
	cmove	%rax, %r13
	movzbl	(%rbx,%r10), %r8d
	andl	$15, %r8d
// declassify_val u32 %r8d
	orl 	%r13d, %r8d
	cmpl	$15, %r8d
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$12
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$13
.Lerror_4x__rejection_sample_multiple_blocks$12:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movl	%r8d, %eax
	imull	$205, %eax, %eax
	shrl	$10, %eax
	imull	$5, %eax, %eax
	subl	%eax, %r8d
	addl	$-2, %r8d
	negl	%r8d
	movl	%r8d, (%rdi,%r11,4)
	incq	%r11
.Lerror_4x__rejection_sample_multiple_blocks$13:
	cmpq	$256, %r11
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$8
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$8:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movzbl	(%rbx,%r10), %r8d
	shrl	$4, %r8d
// declassify_val u32 %r8d
	orl 	%r13d, %r8d
	cmpl	$15, %r8d
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$10
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$10:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movl	%r8d, %eax
	imull	$205, %eax, %eax
	shrl	$10, %eax
	imull	$5, %eax, %eax
	subl	%eax, %r8d
	addl	$-2, %r8d
	negl	%r8d
	movl	%r8d, (%rdi,%r11,4)
	incq	%r11
.Lerror_4x__rejection_sample_multiple_blocks$11:
.Lerror_4x__rejection_sample_multiple_blocks$9:
	incq	%r10
	cmpq	$272, %r10
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$4
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %r11
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$6
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$6:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rbp
.Lerror_4x__rejection_sample_multiple_blocks$7:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$4:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rbp
.Lerror_4x__rejection_sample_multiple_blocks$5:
.Lerror_4x__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rbp
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$3
	ret
.Lt1__decode_polynomial$1:
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r11
	jmp 	.Lt1__decode_polynomial$2
.Lt1__decode_polynomial$3:
	vmovdqu	(%rcx,%r9), %xmm0
	addq	$10, %r9
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 64(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 96(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	glob_data + 32(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, (%r8,%r11)
	addq	$32, %r11
.Lt1__decode_polynomial$2:
	cmpq	$992, %r11
	jb  	.Lt1__decode_polynomial$3
	vmovdqu	304(%rcx), %xmm0
	vpsrldq	$6, %xmm0, %xmm0
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 64(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 96(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	glob_data + 32(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, (%r8,%r11)
	ret
.Lt1__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lt1__encode_polynomial$3
.Lt1__encode_polynomial$4:
	vmovdqu	(%rdx,%r9), %ymm2
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$5:
	vmovdqu	%xmm0, (%rcx,%r8)
	addq	$10, %r8
	addq	$32, %r9
.Lt1__encode_polynomial$3:
	cmpq	$992, %r9
	jb  	.Lt1__encode_polynomial$4
	vmovdqu	(%rdx,%r9), %ymm2
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %r9b
	movb	%r9b, (%rcx,%r8)
	movb	17(%rsp), %r9b
	movb	%r9b, 1(%rcx,%r8)
	movb	18(%rsp), %r9b
	movb	%r9b, 2(%rcx,%r8)
	movb	19(%rsp), %r9b
	movb	%r9b, 3(%rcx,%r8)
	movb	20(%rsp), %r9b
	movb	%r9b, 4(%rcx,%r8)
	movb	21(%rsp), %r9b
	movb	%r9b, 5(%rcx,%r8)
	movb	22(%rsp), %r9b
	movb	%r9b, 6(%rcx,%r8)
	movb	23(%rsp), %r9b
	movb	%r9b, 7(%rcx,%r8)
	movb	24(%rsp), %r9b
	movb	%r9b, 8(%rcx,%r8)
	movb	25(%rsp), %r9b
	movb	%r9b, 9(%rcx,%r8)
	ret
.Lt1__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 128(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm0
	vpsrlq	$22, %ymm0, %ymm0
	vmovdqu	glob_data + 160(%rip), %ymm3
	vpermd	%ymm0, %ymm3, %ymm0
	vmovdqu	glob_data + 192(%rip), %ymm3
	vpsllvd	%ymm3, %ymm0, %ymm0
	vpsrlq	$12, %ymm0, %ymm0
	vpermq	$8, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	vmovdqu	glob_data + 5248(%rip), %xmm1
	vpshufb	%xmm1, %xmm0, %xmm0
	ret
.Lt0__bytestream_to_coefficients$1:
	vpxor	%ymm2, %ymm2, %ymm2
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 224(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 256(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 288(%rip), %ymm1
	vpand	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5184(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	ret
.Lt0__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lt0__encode_polynomial$3
.Lt0__encode_polynomial$4:
	vmovdqu	(%rdx,%r9), %ymm2
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$5:
	vmovdqu	%xmm0, (%rcx,%r8)
	addq	$13, %r8
	addq	$32, %r9
.Lt0__encode_polynomial$3:
	cmpq	$992, %r9
	jb  	.Lt0__encode_polynomial$4
	vmovdqu	(%rdx,%r9), %ymm2
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %r9b
	movb	%r9b, (%rcx,%r8)
	movb	17(%rsp), %r9b
	movb	%r9b, 1(%rcx,%r8)
	movb	18(%rsp), %r9b
	movb	%r9b, 2(%rcx,%r8)
	movb	19(%rsp), %r9b
	movb	%r9b, 3(%rcx,%r8)
	movb	20(%rsp), %r9b
	movb	%r9b, 4(%rcx,%r8)
	movb	21(%rsp), %r9b
	movb	%r9b, 5(%rcx,%r8)
	movb	22(%rsp), %r9b
	movb	%r9b, 6(%rcx,%r8)
	movb	23(%rsp), %r9b
	movb	%r9b, 7(%rcx,%r8)
	movb	24(%rsp), %r9b
	movb	%r9b, 8(%rcx,%r8)
	movb	25(%rsp), %r9b
	movb	%r9b, 9(%rcx,%r8)
	movb	26(%rsp), %r9b
	movb	%r9b, 10(%rcx,%r8)
	movb	27(%rsp), %r9b
	movb	%r9b, 11(%rcx,%r8)
	movb	28(%rsp), %r9b
	movb	%r9b, 12(%rcx,%r8)
	ret
.Lt0__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 5184(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	vmovdqu	glob_data + 320(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm0
	vpsrlq	$19, %ymm0, %ymm0
	vmovdqu	glob_data + 352(%rip), %ymm3
	vpermd	%ymm0, %ymm3, %ymm0
	vmovdqu	glob_data + 384(%rip), %ymm3
	vpsllvd	%ymm3, %ymm0, %ymm0
	vpsrlq	$6, %ymm0, %ymm0
	vpsrldq	$8, %ymm0, %ymm1
	vpsllq	$52, %ymm1, %ymm1
	vpaddq	%ymm1, %ymm0, %ymm0
	vmovdqu	glob_data + 416(%rip), %ymm3
	vpsrlvq	%ymm3, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	ret
.Lcolumn_vector__invert_ntt_montgomery$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$9:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$8:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$7:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$6:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$5:
	leaq	5120(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$4:
	leaq	6144(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$3:
	leaq	7168(%rcx), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$2:
	ret
.Lcolumn_vector__reduce32$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$9:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$8:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$7:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$6:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$5:
	leaq	5120(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$4:
	leaq	6144(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$3:
	leaq	7168(%rcx), %rsi
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$2:
	ret
.Lrow_vector__ntt$1:
	movq	%rcx, %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$8:
	leaq	1024(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$7:
	leaq	2048(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$6:
	leaq	3072(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$5:
	leaq	4096(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$4:
	leaq	5120(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$3:
	leaq	6144(%rcx), %rsi
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$2:
	ret
.Lpolynomial__subtract$1:
	movq	$0, %rsi
	jmp 	.Lpolynomial__subtract$2
.Lpolynomial__subtract$3:
	vmovdqu	(%rdx,%rsi), %ymm0
	vmovdqu	(%r10,%rsi), %ymm1
	vpsubd	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx,%rsi)
	addq	$32, %rsi
.Lpolynomial__subtract$2:
	cmpq	$1024, %rsi
	jb  	.Lpolynomial__subtract$3
	ret
.Lpolynomial__add$1:
	movq	$0, %rsi
	jmp 	.Lpolynomial__add$2
.Lpolynomial__add$3:
	vmovdqu	(%rcx,%rsi), %ymm0
	vmovdqu	(%rdx,%rsi), %ymm1
	vpaddd	%ymm1, %ymm0, %ymm4
	vmovdqu	%ymm4, (%rax,%rsi)
	addq	$32, %rsi
.Lpolynomial__add$2:
	cmpq	$1024, %rsi
	jb  	.Lpolynomial__add$3
	ret
.Lmatrix_A__rejection_sample_one_block$1:
	movq	$0, %rdi
	lfence
	movq	$0, %r9
	movb	$0, %bpl
	cmpq	$256, %r11
	jnb 	.Lmatrix_A__rejection_sample_one_block$10
	movq	$-1, %r10
	cmovnb	%r10, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$10:
	movq	$-1, %r10
	cmovb	%r10, %r9
	movb	$1, %bpl
.Lmatrix_A__rejection_sample_one_block$11:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$3:
	movq	$-1, %r10
	cmove	%r10, %r9
	movzbl	(%r8,%rdi), %r10d
	incq	%rdi
	movzbl	(%r8,%rdi), %ebx
	incq	%rdi
	movzbl	(%r8,%rdi), %ebp
	incq	%rdi
	shll	$8, %ebx
	orl 	%ebx, %r10d
	shll	$16, %ebp
	orl 	%ebp, %r10d
	andl	$8388607, %r10d
// declassify_val u32 %r10d
	orl 	%r9d, %r10d
	cmpl	$8380417, %r10d
	jb  	.Lmatrix_A__rejection_sample_one_block$8
	movq	$-1, %r10
	cmovb	%r10, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$9
.Lmatrix_A__rejection_sample_one_block$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %r9
	movl	%r10d, (%rsi,%r11,4)
	incq	%r11
.Lmatrix_A__rejection_sample_one_block$9:
	movb	$0, %bpl
	cmpq	$256, %r11
	jnb 	.Lmatrix_A__rejection_sample_one_block$4
	movq	$-1, %r10
	cmovnb	%r10, %r9
	cmpq	$168, %rdi
	jnb 	.Lmatrix_A__rejection_sample_one_block$6
	movq	$-1, %r10
	cmovnb	%r10, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$6:
	movq	$-1, %r10
	cmovb	%r10, %r9
	movb	$1, %bpl
.Lmatrix_A__rejection_sample_one_block$7:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$4:
	movq	$-1, %r10
	cmovb	%r10, %r9
	movb	$1, %bpl
.Lmatrix_A__rejection_sample_one_block$5:
.Lmatrix_A__rejection_sample_one_block$2:
	cmpb	$1, %bpl
	jne 	.Lmatrix_A__rejection_sample_one_block$3
	ret
.Lmatrix_A__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %r8
	leaq	glob_data + 5264(%rip), %r10
	movq	$0, %r11
	movq	$0, %r9
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %rbp
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$15:
	movq	$-1, %rbx
	cmove	%rbx, %r8
	vmovdqu	(%rdi,%r9), %ymm0
	vmovdqu	glob_data + 448(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm2
	vmovdqu	glob_data + 480(%rip), %ymm0
	vpshufb	%ymm0, %ymm2, %ymm2
	vmovdqu	glob_data + 512(%rip), %ymm0
	vpand	%ymm0, %ymm2, %ymm0
	addq	$24, %r9
	vpcmpgtd	%ymm0, %ymm1, %ymm2
	vpinsrq	$0, %r8, %xmm3, %xmm3
	vpinsrq	$1, %r8, %xmm3, %xmm3
	vinserti128	$1, %xmm3, %ymm3, %ymm3
	vpor	%ymm3, %ymm2, %ymm2
	vmovmskps	%ymm2, %ebx
// declassify_val u64 %rbx
	vextracti128	$0, %ymm0, %xmm2
	movq	%rbx, %rbp
	andq	$15, %rbp
	movq	%rbp, %r12
	shlq	$4, %r12
	vmovdqu	(%r10,%r12), %xmm4
	vpshufb	%xmm4, %xmm2, %xmm2
	vmovdqu	%xmm2, (%rsi,%r11)
	popcnt	%rbp, %rbp
	shlq	$2, %rbp
	addq	%rbp, %r11
	vextracti128	$1, %ymm0, %xmm0
	shrq	$4, %rbx
	movq	%rbx, %r12
	shlq	$4, %r12
	vmovdqu	(%r10,%r12), %xmm4
	vpshufb	%xmm4, %xmm0, %xmm0
	vmovdqu	%xmm0, (%rsi,%r11)
	popcnt	%rbx, %rbx
	shlq	$2, %rbx
	addq	%rbx, %r11
	movq	$0, %rbp
	cmpq	$992, %r11
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$16
	movq	$-1, %rbx
	cmovnb	%rbx, %r8
	cmpq	$840, %r9
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$18
	movq	$-1, %rbx
	cmovnb	%rbx, %r8
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$18:
	movq	$-1, %rbx
	cmovb	%rbx, %r8
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$19:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$16:
	movq	$-1, %rbx
	cmovb	%rbx, %r8
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$17:
.Lmatrix_A__rejection_sample_multiple_blocks$14:
	cmpq	$1, %rbp
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$15
	movq	$-1, %r10
	cmovne	%r10, %r8
	shrq	$2, %r11
	movq	$1, %rbp
	cmpq	$256, %r11
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$10
	movq	$-1, %r10
	cmovb	%r10, %r8
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$10:
	movq	$-1, %r10
	cmovnb	%r10, %r8
	cmpq	$838, %r9
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$12
	movq	$-1, %r10
	cmovb	%r10, %r8
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$12:
	movq	$-1, %r10
	cmovnb	%r10, %r8
	movq	$0, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$13:
.Lmatrix_A__rejection_sample_multiple_blocks$11:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$3:
	movq	$-1, %r10
	cmove	%r10, %r8
	movzbl	(%rdi,%r9), %r10d
	incq	%r9
	movzbl	(%rdi,%r9), %ebx
	incq	%r9
	movzbl	(%rdi,%r9), %ebp
	incq	%r9
	shll	$8, %ebx
	orl 	%ebx, %r10d
	shll	$16, %ebp
	orl 	%ebp, %r10d
	andl	$8388607, %r10d
// declassify_val u32 %r10d
	orl 	%r8d, %r10d
	cmpl	$8380417, %r10d
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$8
	movq	$-1, %r10
	cmovb	%r10, %r8
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$9
.Lmatrix_A__rejection_sample_multiple_blocks$8:
	movq	$-1, %rbx
	cmovnb	%rbx, %r8
	movl	%r10d, (%rsi,%r11,4)
	incq	%r11
.Lmatrix_A__rejection_sample_multiple_blocks$9:
	movq	$0, %rbp
	cmpq	$256, %r11
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$4
	movq	$-1, %r10
	cmovnb	%r10, %r8
	cmpq	$838, %r9
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$6
	movq	$-1, %r10
	cmovnb	%r10, %r8
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$6:
	movq	$-1, %r10
	cmovb	%r10, %r8
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$7:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$4:
	movq	$-1, %r10
	cmovb	%r10, %r8
	movq	$1, %rbp
.Lmatrix_A__rejection_sample_multiple_blocks$5:
.Lmatrix_A__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rbp
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
	vpunpckhqdq	%ymm3, %ymm2, %ymm14
	vmovdqu	%ymm4, (%rcx,%r8)
	vmovdqu	%ymm1, (%rdx,%r8)
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	%ymm14, (%rdi,%r8)
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
	movq	$0, %rsi
	movq	$0, %r8
	jmp 	.Lshake256_absorb_66_4x$4
.Lshake256_absorb_66_4x$5:
	vpbroadcastq	(%rcx,%rsi), %ymm0
	addq	$8, %rsi
	vpxor	(%rax,%r8), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r8)
	addq	$32, %r8
.Lshake256_absorb_66_4x$4:
	cmpq	$256, %r8
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
	movq	$0, %rdi
	movq	$32, %r8
	jmp 	.Lshake256_absorb_66_4x$2
.Lshake256_absorb_66_4x$3:
	movq	(%r9,%rdi), %r10
	xorq	%r10, (%rax,%r8,8)
	movq	(%rcx,%rdi), %r10
	xorq	%r10, 8(%rax,%r8,8)
	movq	(%rdx,%rdi), %r10
	xorq	%r10, 16(%rax,%r8,8)
	movq	(%rsi,%rdi), %r10
	addq	$8, %rdi
	xorq	%r10, 24(%rax,%r8,8)
	addq	$4, %r8
.Lshake256_absorb_66_4x$2:
	cmpq	$32, %r8
	jb  	.Lshake256_absorb_66_4x$3
	movq	$0, %r10
	movzwq	(%r9,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rcx,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rdx,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 16(%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rsi,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 24(%rax,%r8,8)
	movq	$-9223372036854775808, %r9
	movq	%r9, 40(%rsp)
	vpbroadcastq	40(%rsp), %ymm0
	vpxor	512(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rax)
	ret
.Lshake128_absorb_34_4x$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.Lshake128_absorb_34_4x$6
.Lshake128_absorb_34_4x$7:
	vmovdqu	%ymm0, (%rax,%rdx)
	addq	$32, %rdx
.Lshake128_absorb_34_4x$6:
	cmpq	$800, %rdx
	jb  	.Lshake128_absorb_34_4x$7
	movq	$0, %rdx
	movq	$0, %r8
	jmp 	.Lshake128_absorb_34_4x$4
.Lshake128_absorb_34_4x$5:
	vpbroadcastq	(%rsi,%rdx), %ymm0
	addq	$8, %rdx
	vpxor	(%rax,%r8), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r8)
	addq	$32, %r8
.Lshake128_absorb_34_4x$4:
	cmpq	$128, %r8
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
	movq	$0, %rdi
	movq	$16, %r8
	jmp 	.Lshake128_absorb_34_4x$2
.Lshake128_absorb_34_4x$3:
	movq	(%r9,%rdi), %r10
	xorq	%r10, (%rax,%r8,8)
	movq	(%rcx,%rdi), %r10
	xorq	%r10, 8(%rax,%r8,8)
	movq	(%rdx,%rdi), %r10
	xorq	%r10, 16(%rax,%r8,8)
	movq	(%rsi,%rdi), %r10
	addq	$8, %rdi
	xorq	%r10, 24(%rax,%r8,8)
	addq	$4, %r8
.Lshake128_absorb_34_4x$2:
	cmpq	$16, %r8
	jb  	.Lshake128_absorb_34_4x$3
	movq	$0, %r10
	movzwq	(%r9,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rcx,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rdx,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 16(%rax,%r8,8)
	movq	$0, %r10
	movzwq	(%rsi,%rdi), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 24(%rax,%r8,8)
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
	movq	$0, %rsi
	vmovdqu	(%rcx,%rsi), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rsi), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %rsi
	vmovdqu	(%rdx,%rsi), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	32(%rdx,%rsi), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	64(%rdx,%rsi), %r10
	xorq	%r10, 128(%rax)
	addq	$72, %rsi
	movq	%rdx, %mm1
	movq	%rsi, %mm2
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
	cmpq	$7, %rsi
	jb  	.L__derive_commitment_hash$7
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rsi
	movq	$0, %rdx
	jmp 	.L__derive_commitment_hash$3
.L__derive_commitment_hash$4:
	incq	%rdx
	movq	%rcx, %mm1
	movq	%rsi, %mm2
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rsi
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rsi)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rsi)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rsi)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rsi)
	movq	128(%rax), %rdi
	movq	%rdi, 128(%rcx,%rsi)
	addq	$136, %rsi
.L__derive_commitment_hash$3:
	cmpq	$0, %rdx
	jb  	.L__derive_commitment_hash$4
	movq	%rcx, %mm1
	movq	%rsi, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
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
	cmpq	$18, %rsi
	jb  	.Lhash_verification_key$7
	movq	(%rcx,%rdx), %r10
	xorq	%r10, (%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rsi
	movq	$0, %rdx
	jmp 	.Lhash_verification_key$3
.Lhash_verification_key$4:
	incq	%rdx
	movq	%rcx, %mm1
	movq	%rsi, %mm2
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rsi
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rsi)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rsi)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rsi)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rsi)
	movq	128(%rax), %rdi
	movq	%rdi, 128(%rcx,%rsi)
	addq	$136, %rsi
.Lhash_verification_key$3:
	cmpq	$0, %rdx
	jb  	.Lhash_verification_key$4
	movq	%rcx, %mm1
	movq	%rsi, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
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
	leaq	128(%rsp), %rcx
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
	leaq	32(%rsp), %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	%ymm0, 96(%rcx)
	vmovdqu	%ymm0, 128(%rcx)
	vmovdqu	%ymm0, 160(%rcx)
	movq	$0, 192(%rcx)
	leaq	32(%rsp), %rcx
	movq	$0, %rdx
	vmovdqu	(%rax,%rdx), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%rdx), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%rdx), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%rdx), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 128(%rcx)
	xorb	$128, 135(%rcx)
	leaq	32(%rsp), %rax
	movq	$0, %rdi
	movq	$0, %rdx
	jmp 	.L_shake256_A64__A128$3
.L_shake256_A64__A128$4:
	incq	%rdx
	movq	%rsi, %mm1
	movq	%rdi, %mm2
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rsi
	movq	%mm2, %rdi
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rsi,%rdi)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsi,%rdi)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rsi,%rdi)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rsi,%rdi)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rsi,%rdi)
	addq	$136, %rdi
.L_shake256_A64__A128$3:
	cmpq	$0, %rdx
	jb  	.L_shake256_A64__A128$4
	movq	%rsi, %mm1
	movq	%rdi, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rsi
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rsi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsi,%rdx)
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
	movq	$0, %rsi
	vmovdqu	(%rcx,%rsi), %ymm0
	vpxor	(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdx)
	leaq	32(%rsp), %rcx
	movq	$0, %rdx
	movq	$0, %r10
	movzwq	(%rax,%rdx), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 32(%rcx)
	xorb	$128, 135(%rcx)
	leaq	32(%rsp), %rax
	movq	$0, %rsi
	movq	$0, %rdx
	jmp 	.L_shake256_A128__A32_A2$3
.L_shake256_A128__A32_A2$4:
	incq	%rdx
	movq	%rdi, %mm1
	movq	%rsi, %mm2
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %rsi
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rsi)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rsi)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%rsi)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%rsi)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdi,%rsi)
	addq	$136, %rsi
.L_shake256_A128__A32_A2$3:
	cmpq	$0, %rdx
	jb  	.L_shake256_A128__A32_A2$4
	movq	%rdi, %mm1
	movq	%rsi, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rsi
	movq	%mm2, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rsi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsi,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rsi,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rsi,%rdx)
	ret
.Lshake256_squeezeblock$1:
	movq	%rcx, %rax
	movq	%rcx, %mm0
	movq	%r8, %mm1
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lshake256_squeezeblock$2:
	leaq	200(%rsp), %rsp
	movq	%mm0, %rax
	movq	%mm1, %r8
	movq	$0, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%r8,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%r8,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%r8,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%r8,%rdx)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%r8,%rdx)
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
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 64(%rax)
	xorb	$128, 135(%rax)
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
	xorb	%al, (%rcx,%r8)
	xorb	$128, -1(%rcx,%rdi)
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
	movq	$0, %r9
	movb	$0, %cl
	jmp 	.L_add_m_updstate$8
.L_add_m_updstate$7:
	movl	(%rdx), %r9d
	addq	$4, %rdx
	movb	$32, %cl
.L_add_m_updstate$8:
	testq	$2, %r10
	je  	.L_add_m_updstate$6
	movzwq	(%rdx), %r11
	shlq	%cl, %r11
	addq	%r11, %r9
	addq	$2, %rdx
	addb	$16, %cl
.L_add_m_updstate$6:
	testq	$1, %r10
	je  	.L_add_m_updstate$4
	movzbq	(%rdx), %r11
	shlq	%cl, %r11
	addq	%r11, %r9
	incq	%rdx
.L_add_m_updstate$5:
	jmp 	.L_add_m_updstate$4
.L_add_m_updstate$3:
	movq	(%rdx), %r9
	addq	$8, %rdx
.L_add_m_updstate$4:
	xorq	%r9, (%rax,%r8)
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
	leaq	glob_data + 7568(%rip), %r10
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
	leaq	glob_data + 7568(%rip), %rbp
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
	leaq	glob_data + 7568(%rip), %r14
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm5
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1696(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm2
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm2, %ymm9, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1152(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1184(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm10, %ymm6
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1216(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm0
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm0, %ymm9, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 608(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm2
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm2, %ymm9, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 640(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 672(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm6, %ymm7
	vperm2i128	$49, %ymm8, %ymm6, %ymm6
	vmovdqu	glob_data + 704(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm8
	movl	glob_data + 7816(%rip), %r8d
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	movl	glob_data + 7820(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm9
	vpsubd	%ymm4, %ymm5, %ymm2
	vpaddd	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	movl	glob_data + 7824(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm9
	vpsubd	%ymm7, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm2
	movl	glob_data + 7828(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7784(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm3, %ymm4, %ymm9
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	vpsubd	%ymm0, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	movl	glob_data + 7788(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm2, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm0, 32(%rsi)
	vmovdqu	%ymm4, 64(%rsi)
	vmovdqu	%ymm5, 96(%rsi)
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	%ymm2, 160(%rsi)
	vmovdqu	%ymm7, 192(%rsi)
	vmovdqu	%ymm6, 224(%rsi)
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1824(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1280(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1312(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm10, %ymm6
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1344(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm0
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm0, %ymm9, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 736(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 768(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 800(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm6, %ymm7
	vperm2i128	$49, %ymm8, %ymm6, %ymm6
	vmovdqu	glob_data + 832(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7832(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7836(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 7840(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 7844(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7792(%rip), %r8d
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
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7796(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm2, 288(%rsi)
	vmovdqu	%ymm5, 320(%rsi)
	vmovdqu	%ymm6, 352(%rsi)
	vmovdqu	%ymm0, 384(%rsi)
	vmovdqu	%ymm1, 416(%rsi)
	vmovdqu	%ymm7, 448(%rsi)
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 1952(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1408(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1440(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm10, %ymm6
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1472(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm0
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm0, %ymm9, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 864(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 896(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 928(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm6, %ymm7
	vperm2i128	$49, %ymm8, %ymm6, %ymm6
	vmovdqu	glob_data + 960(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7848(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7852(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 7856(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 7860(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7800(%rip), %r8d
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
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7804(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 512(%rsi)
	vmovdqu	%ymm2, 544(%rsi)
	vmovdqu	%ymm5, 576(%rsi)
	vmovdqu	%ymm6, 608(%rsi)
	vmovdqu	%ymm0, 640(%rsi)
	vmovdqu	%ymm1, 672(%rsi)
	vmovdqu	%ymm7, 704(%rsi)
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 2080(%rip), %ymm8
	vpshufd	$216, %ymm6, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1536(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1568(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm10, %ymm6
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1600(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm0
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm0, %ymm9, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 992(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1024(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1056(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm6, %ymm7
	vperm2i128	$49, %ymm8, %ymm6, %ymm6
	vmovdqu	glob_data + 1088(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7864(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7868(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 7872(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 7876(%rip), %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7808(%rip), %r8d
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
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7812(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm7, %ymm9, %ymm7
	vpsubd	%ymm4, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 768(%rsi)
	vmovdqu	%ymm2, 800(%rsi)
	vmovdqu	%ymm5, 832(%rsi)
	vmovdqu	%ymm6, 864(%rsi)
	vmovdqu	%ymm0, 896(%rsi)
	vmovdqu	%ymm1, 928(%rsi)
	vmovdqu	%ymm7, 960(%rsi)
	vmovdqu	%ymm4, 992(%rsi)
	vmovdqu	(%rsi), %ymm2
	vmovdqu	128(%rsi), %ymm8
	vmovdqu	256(%rsi), %ymm0
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	512(%rsi), %ymm3
	vmovdqu	640(%rsi), %ymm4
	vmovdqu	768(%rsi), %ymm5
	vmovdqu	896(%rsi), %ymm6
	movl	glob_data + 7768(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm7
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7772(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm0, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm0, %ymm1
	vmovshdup	%ymm9, %ymm0
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	movl	glob_data + 7776(%rip), %r8d
	vmovd	%r8d, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpsubd	%ymm3, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm3, %ymm9
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm10, %ymm0
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	movl	glob_data + 7780(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm3
	vpsubd	%ymm5, %ymm6, %ymm4
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm6
	movl	glob_data + 7760(%rip), %r8d
	vmovd	%r8d, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm1, %ymm3
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovshdup	%ymm3, %ymm7
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm3
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7764(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm0, %ymm6, %ymm8
	vpaddd	%ymm6, %ymm0, %ymm10
	vmovshdup	%ymm8, %ymm0
	vmovshdup	%ymm7, %ymm6
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm7
	movl	$41978, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm1, %ymm8
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm11, %ymm1
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm3, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm10, %ymm11
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm10, %ymm5
	vpmuldq	%ymm12, %ymm11, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm4, %ymm0, %ymm10
	vpaddd	%ymm0, %ymm4, %ymm0
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm10, %ymm7
	vpmuldq	%ymm12, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm6, %ymm0, %ymm6
	vmovdqu	%ymm8, (%rsi)
	vmovdqu	%ymm9, 128(%rsi)
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm6, 384(%rsi)
	vmovdqu	%ymm1, 512(%rsi)
	vmovdqu	%ymm2, 640(%rsi)
	vmovdqu	%ymm5, 768(%rsi)
	vmovdqu	%ymm4, 896(%rsi)
	vmovdqu	32(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm8
	vmovdqu	288(%rsi), %ymm0
	vmovdqu	416(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm3
	vmovdqu	672(%rsi), %ymm4
	vmovdqu	800(%rsi), %ymm5
	vmovdqu	928(%rsi), %ymm6
	movl	glob_data + 7768(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm7
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7772(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm0, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7776(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm3, %ymm9
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm4
	movl	glob_data + 7780(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm5, %ymm6, %ymm3
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm6
	movl	glob_data + 7760(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm3
	vpsubd	%ymm7, %ymm0, %ymm1
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm3, %ymm8
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	%ymm8, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm3
	movl	glob_data + 7764(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm10, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm4, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm4, %ymm10
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm7, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm6, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm4
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm0, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm0, %ymm8
	vmovshdup	%ymm9, %ymm0
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm0, %ymm9, %ymm0
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm9, %ymm8, %ymm8
	vpsubd	%ymm2, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm2, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm10, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm1, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm10, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm5
	vpmuldq	%ymm12, %ymm11, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm10, %ymm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm10
	vpmuldq	%ymm12, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm3, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vmovdqu	%ymm8, 32(%rsi)
	vmovdqu	%ymm9, 160(%rsi)
	vmovdqu	%ymm1, 288(%rsi)
	vmovdqu	%ymm6, 416(%rsi)
	vmovdqu	%ymm0, 544(%rsi)
	vmovdqu	%ymm2, 672(%rsi)
	vmovdqu	%ymm5, 800(%rsi)
	vmovdqu	%ymm4, 928(%rsi)
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	192(%rsi), %ymm8
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	448(%rsi), %ymm3
	vmovdqu	576(%rsi), %ymm2
	vmovdqu	704(%rsi), %ymm4
	vmovdqu	832(%rsi), %ymm5
	vmovdqu	960(%rsi), %ymm6
	movl	glob_data + 7768(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm10, %ymm0
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	glob_data + 7772(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm1, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm1, %ymm3
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7776(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm2, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm2, %ymm9
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	movl	glob_data + 7780(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm5, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm6
	movl	glob_data + 7760(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm7, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm7, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm3
	vpmuldq	%ymm4, %ymm10, %ymm10
	vpmuldq	%ymm3, %ymm7, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm10, %ymm7
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm3, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7764(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm10, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm1, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm10
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm7, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm6, %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm7, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm8
	vmovshdup	%ymm9, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm2
	vpmuldq	%ymm12, %ymm11, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm9, %ymm8, %ymm8
	vpsubd	%ymm0, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm0, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm3, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm10, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm5
	vpmuldq	%ymm12, %ymm11, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm4, %ymm1, %ymm10
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm10
	vpmuldq	%ymm12, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm1, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm8, 64(%rsi)
	vmovdqu	%ymm9, 192(%rsi)
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm2, 576(%rsi)
	vmovdqu	%ymm0, 704(%rsi)
	vmovdqu	%ymm5, 832(%rsi)
	vmovdqu	%ymm4, 960(%rsi)
	vmovdqu	96(%rsi), %ymm0
	vmovdqu	224(%rsi), %ymm8
	vmovdqu	352(%rsi), %ymm1
	vmovdqu	480(%rsi), %ymm3
	vmovdqu	608(%rsi), %ymm2
	vmovdqu	736(%rsi), %ymm4
	vmovdqu	864(%rsi), %ymm5
	vmovdqu	992(%rsi), %ymm6
	movl	glob_data + 7768(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm10, %ymm0
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	glob_data + 7772(%rip), %r8d
	vmovd	%r8d, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm1, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm1, %ymm3
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7776(%rip), %r8d
	vmovd	%r8d, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm2, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm2, %ymm9
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	movl	glob_data + 7780(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm5, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm6
	movl	glob_data + 7760(%rip), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm7, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm7, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm3
	vpmuldq	%ymm4, %ymm10, %ymm10
	vpmuldq	%ymm3, %ymm7, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm10, %ymm7
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm3, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm0
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7764(%rip), %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm10, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm5
	vpsubd	%ymm1, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm10
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm7, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	%ymm6, %ymm1, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm7, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	$-3975713, %r8d
	vmovd	%r8d, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %r8d
	vmovd	%r8d, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm8
	vmovshdup	%ymm9, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm2
	vpmuldq	%ymm12, %ymm11, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm9, %ymm8, %ymm8
	vpsubd	%ymm0, %ymm10, %ymm11
	vpaddd	%ymm10, %ymm0, %ymm9
	vmovshdup	%ymm11, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm10, %ymm9, %ymm9
	vpsubd	%ymm3, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm10, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm5
	vpmuldq	%ymm12, %ymm11, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm10, %ymm3, %ymm3
	vpsubd	%ymm4, %ymm1, %ymm10
	vpaddd	%ymm1, %ymm4, %ymm1
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm10
	vpmuldq	%ymm12, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm1, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm8, 96(%rsi)
	vmovdqu	%ymm9, 224(%rsi)
	vmovdqu	%ymm3, 352(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	%ymm2, 608(%rsi)
	vmovdqu	%ymm0, 736(%rsi)
	vmovdqu	%ymm5, 864(%rsi)
	vmovdqu	%ymm4, 992(%rsi)
	ret
.Lpolynomial__ntt$1:
	vmovdqu	(%rsi), %ymm1
	vmovdqu	128(%rsi), %ymm3
	vmovdqu	256(%rsi), %ymm5
	vmovdqu	384(%rsi), %ymm7
	vmovdqu	512(%rsi), %ymm0
	vmovdqu	640(%rsi), %ymm2
	vmovdqu	768(%rsi), %ymm4
	vmovdqu	896(%rsi), %ymm6
	movq	$25847, %r8
	vmovq	%r8, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm2
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm4
	vpaddd	%ymm9, %ymm5, %ymm9
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm5
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm8
	vpaddd	%ymm9, %ymm3, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm3, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm3
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm7
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2176(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2208(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, (%rsi)
	vmovdqu	%ymm9, 128(%rsi)
	vmovdqu	%ymm5, 256(%rsi)
	vmovdqu	%ymm6, 384(%rsi)
	vmovdqu	%ymm0, 512(%rsi)
	vmovdqu	%ymm2, 640(%rsi)
	vmovdqu	%ymm7, 768(%rsi)
	vmovdqu	%ymm8, 896(%rsi)
	vmovdqu	32(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm3
	vmovdqu	288(%rsi), %ymm5
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	544(%rsi), %ymm0
	vmovdqu	672(%rsi), %ymm2
	vmovdqu	800(%rsi), %ymm4
	vmovdqu	928(%rsi), %ymm6
	movq	$25847, %r8
	vmovq	%r8, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm2
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm4
	vpaddd	%ymm9, %ymm5, %ymm9
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm5
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm3, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm3
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm7
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2176(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2208(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 32(%rsi)
	vmovdqu	%ymm9, 160(%rsi)
	vmovdqu	%ymm5, 288(%rsi)
	vmovdqu	%ymm6, 416(%rsi)
	vmovdqu	%ymm0, 544(%rsi)
	vmovdqu	%ymm2, 672(%rsi)
	vmovdqu	%ymm7, 800(%rsi)
	vmovdqu	%ymm8, 928(%rsi)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	192(%rsi), %ymm3
	vmovdqu	320(%rsi), %ymm5
	vmovdqu	448(%rsi), %ymm7
	vmovdqu	576(%rsi), %ymm0
	vmovdqu	704(%rsi), %ymm2
	vmovdqu	832(%rsi), %ymm4
	vmovdqu	960(%rsi), %ymm6
	movq	$25847, %r8
	vmovq	%r8, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm2
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm4
	vpaddd	%ymm9, %ymm5, %ymm9
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm5
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm3, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm3
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm7
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2176(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2208(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	%ymm9, 192(%rsi)
	vmovdqu	%ymm5, 320(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm0, 576(%rsi)
	vmovdqu	%ymm2, 704(%rsi)
	vmovdqu	%ymm7, 832(%rsi)
	vmovdqu	%ymm8, 960(%rsi)
	vmovdqu	96(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	352(%rsi), %ymm5
	vmovdqu	480(%rsi), %ymm7
	vmovdqu	608(%rsi), %ymm0
	vmovdqu	736(%rsi), %ymm2
	vmovdqu	864(%rsi), %ymm4
	vmovdqu	992(%rsi), %ymm6
	movq	$25847, %r8
	vmovq	%r8, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm9, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm2
	vpaddd	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm9, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm4
	vpaddd	%ymm9, %ymm5, %ymm9
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm5, %ymm9, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm5
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %r8
	vmovq	%r8, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm3, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm3
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm4
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm7
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2144(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2176(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2208(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2240(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 96(%rsi)
	vmovdqu	%ymm9, 224(%rsi)
	vmovdqu	%ymm5, 352(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	%ymm0, 608(%rsi)
	vmovdqu	%ymm2, 736(%rsi)
	vmovdqu	%ymm7, 864(%rsi)
	vmovdqu	%ymm8, 992(%rsi)
	vmovdqu	(%rsi), %ymm1
	vmovdqu	32(%rsi), %ymm2
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm3
	vmovdqu	128(%rsi), %ymm4
	vmovdqu	160(%rsi), %ymm5
	vmovdqu	192(%rsi), %ymm6
	vmovdqu	224(%rsi), %ymm8
	vmovdqu	glob_data + 2272(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2304(%rip), %ymm7
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm2, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm2
	vpaddd	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm8
	vmovdqu	glob_data + 2528(%rip), %ymm5
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm9
	vmovdqu	glob_data + 2560(%rip), %ymm1
	vmovshdup	%ymm3, %ymm5
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm1
	vpaddd	%ymm5, %ymm0, %ymm10
	vmovdqu	glob_data + 2592(%rip), %ymm0
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm8, %ymm0
	vpmuldq	%ymm3, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm8, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm3
	vpaddd	%ymm5, %ymm4, %ymm0
	vmovdqu	glob_data + 2624(%rip), %ymm4
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm6, %ymm4
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3040(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm8, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3072(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm10, %ymm7
	vperm2i128	$49, %ymm1, %ymm10, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm4
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm4, %ymm8
	vpshufd	$216, %ymm6, %ymm9
	vmovdqu	glob_data + 4096(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm1, %ymm4
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm7
	vpsubd	%ymm1, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm7, %ymm1
	vpunpckhqdq	%ymm6, %ymm7, %ymm4
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm4, %ymm4
	vmovdqu	glob_data + 4128(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm3, %ymm0
	vpunpckhqdq	%ymm6, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 4160(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm5, %ymm2
	vpunpckhqdq	%ymm6, %ymm5, %ymm5
	vpshufd	$216, %ymm2, %ymm7
	vpshufd	$216, %ymm5, %ymm6
	vmovdqu	%ymm8, (%rsi)
	vmovdqu	%ymm9, 32(%rsi)
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	%ymm0, 128(%rsi)
	vmovdqu	%ymm3, 160(%rsi)
	vmovdqu	%ymm7, 192(%rsi)
	vmovdqu	%ymm6, 224(%rsi)
	vmovdqu	256(%rsi), %ymm0
	vmovdqu	288(%rsi), %ymm2
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	352(%rsi), %ymm4
	vmovdqu	384(%rsi), %ymm5
	vmovdqu	416(%rsi), %ymm6
	vmovdqu	448(%rsi), %ymm7
	vmovdqu	480(%rsi), %ymm8
	vmovdqu	glob_data + 2336(%rip), %ymm9
	vmovshdup	%ymm1, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm1
	vpsubd	%ymm1, %ymm0, %ymm3
	vpaddd	%ymm1, %ymm0, %ymm1
	vmovshdup	%ymm4, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm0, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm4
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 2368(%rip), %ymm9
	vmovshdup	%ymm7, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	%ymm10, %ymm0, %ymm0
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm0, %ymm0
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm0, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm0
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpsubd	%ymm7, %ymm6, %ymm8
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 2656(%rip), %ymm7
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm7
	vpaddd	%ymm9, %ymm1, %ymm9
	vmovdqu	glob_data + 2688(%rip), %ymm1
	vmovshdup	%ymm4, %ymm2
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm4, %ymm1
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm1
	vpaddd	%ymm4, %ymm3, %ymm10
	vmovdqu	glob_data + 2720(%rip), %ymm3
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm4, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm5, %ymm3
	vpaddd	%ymm4, %ymm5, %ymm2
	vmovdqu	glob_data + 2752(%rip), %ymm4
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm4, %ymm6
	vpmuldq	%ymm4, %ymm8, %ymm4
	vpmuldq	%ymm6, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm5
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovdqu	glob_data + 3168(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm8, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3200(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm10, %ymm7
	vperm2i128	$49, %ymm1, %ymm10, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3232(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm8
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3264(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm0, %ymm8
	vperm2i128	$49, %ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm5
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm0
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3680(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm9
	vpsubd	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 3712(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 3744(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3776(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm0, %ymm8
	vpunpckhqdq	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm5
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm0
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4192(%rip), %ymm8
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm4
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm4, %ymm8
	vpshufd	$216, %ymm6, %ymm9
	vmovdqu	glob_data + 4224(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm1, %ymm4
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm7
	vpsubd	%ymm1, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm7, %ymm1
	vpunpckhqdq	%ymm6, %ymm7, %ymm4
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm4, %ymm4
	vmovdqu	glob_data + 4256(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm3
	vpsubd	%ymm2, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm3, %ymm2
	vpunpckhqdq	%ymm6, %ymm3, %ymm3
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 4288(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm0, %ymm7
	vpunpckhqdq	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm5
	vpsubd	%ymm0, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm5, %ymm0
	vpunpckhqdq	%ymm6, %ymm5, %ymm5
	vpshufd	$216, %ymm0, %ymm7
	vpshufd	$216, %ymm5, %ymm6
	vmovdqu	%ymm8, 256(%rsi)
	vmovdqu	%ymm9, 288(%rsi)
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	%ymm4, 352(%rsi)
	vmovdqu	%ymm2, 384(%rsi)
	vmovdqu	%ymm3, 416(%rsi)
	vmovdqu	%ymm7, 448(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	512(%rsi), %ymm1
	vmovdqu	544(%rsi), %ymm2
	vmovdqu	576(%rsi), %ymm0
	vmovdqu	608(%rsi), %ymm3
	vmovdqu	640(%rsi), %ymm4
	vmovdqu	672(%rsi), %ymm5
	vmovdqu	704(%rsi), %ymm6
	vmovdqu	736(%rsi), %ymm8
	vmovdqu	glob_data + 2400(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2432(%rip), %ymm7
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm2, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm2
	vpaddd	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm8
	vmovdqu	glob_data + 2784(%rip), %ymm5
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm9
	vmovdqu	glob_data + 2816(%rip), %ymm1
	vmovshdup	%ymm3, %ymm5
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm1
	vpaddd	%ymm5, %ymm0, %ymm10
	vmovdqu	glob_data + 2848(%rip), %ymm0
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm8, %ymm0
	vpmuldq	%ymm3, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm8, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm3
	vpaddd	%ymm5, %ymm4, %ymm0
	vmovdqu	glob_data + 2880(%rip), %ymm4
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm6, %ymm4
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3296(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm8, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3328(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm10, %ymm7
	vperm2i128	$49, %ymm1, %ymm10, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm4
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm4, %ymm8
	vpshufd	$216, %ymm6, %ymm9
	vmovdqu	glob_data + 4352(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm1, %ymm4
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm7
	vpsubd	%ymm1, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm7, %ymm1
	vpunpckhqdq	%ymm6, %ymm7, %ymm4
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm4, %ymm4
	vmovdqu	glob_data + 4384(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm3, %ymm0
	vpunpckhqdq	%ymm6, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 4416(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm5, %ymm2
	vpunpckhqdq	%ymm6, %ymm5, %ymm5
	vpshufd	$216, %ymm2, %ymm7
	vpshufd	$216, %ymm5, %ymm6
	vmovdqu	%ymm8, 512(%rsi)
	vmovdqu	%ymm9, 544(%rsi)
	vmovdqu	%ymm1, 576(%rsi)
	vmovdqu	%ymm4, 608(%rsi)
	vmovdqu	%ymm0, 640(%rsi)
	vmovdqu	%ymm3, 672(%rsi)
	vmovdqu	%ymm7, 704(%rsi)
	vmovdqu	%ymm6, 736(%rsi)
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	800(%rsi), %ymm2
	vmovdqu	832(%rsi), %ymm0
	vmovdqu	864(%rsi), %ymm3
	vmovdqu	896(%rsi), %ymm4
	vmovdqu	928(%rsi), %ymm5
	vmovdqu	960(%rsi), %ymm6
	vmovdqu	992(%rsi), %ymm8
	vmovdqu	glob_data + 2464(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2496(%rip), %ymm7
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm2, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm4, %ymm2
	vpaddd	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm7
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm8
	vmovdqu	glob_data + 2912(%rip), %ymm5
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm9
	vmovdqu	glob_data + 2944(%rip), %ymm1
	vmovshdup	%ymm3, %ymm5
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm1
	vpaddd	%ymm5, %ymm0, %ymm10
	vmovdqu	glob_data + 2976(%rip), %ymm0
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm8, %ymm0
	vpmuldq	%ymm3, %ymm5, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm8, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm3
	vpaddd	%ymm5, %ymm4, %ymm0
	vmovdqu	glob_data + 3008(%rip), %ymm4
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm6, %ymm4
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3424(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm8, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3456(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm10, %ymm7
	vperm2i128	$49, %ymm1, %ymm10, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 5216(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm6, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm8
	vpsubd	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm8, %ymm4
	vpunpckhqdq	%ymm6, %ymm8, %ymm6
	vpshufd	$216, %ymm4, %ymm8
	vpshufd	$216, %ymm6, %ymm9
	vmovdqu	glob_data + 4480(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm1, %ymm4
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4608(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm4, %ymm7
	vpsubd	%ymm1, %ymm4, %ymm6
	vpunpcklqdq	%ymm6, %ymm7, %ymm1
	vpunpckhqdq	%ymm6, %ymm7, %ymm4
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm4, %ymm4
	vmovdqu	glob_data + 4512(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm3
	vpsubd	%ymm0, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm3, %ymm0
	vpunpckhqdq	%ymm6, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 4544(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4608(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5216(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5216(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm5
	vpsubd	%ymm2, %ymm7, %ymm6
	vpunpcklqdq	%ymm6, %ymm5, %ymm2
	vpunpckhqdq	%ymm6, %ymm5, %ymm5
	vpshufd	$216, %ymm2, %ymm7
	vpshufd	$216, %ymm5, %ymm6
	vmovdqu	%ymm8, 768(%rsi)
	vmovdqu	%ymm9, 800(%rsi)
	vmovdqu	%ymm1, 832(%rsi)
	vmovdqu	%ymm4, 864(%rsi)
	vmovdqu	%ymm0, 896(%rsi)
	vmovdqu	%ymm3, 928(%rsi)
	vmovdqu	%ymm7, 960(%rsi)
	vmovdqu	%ymm6, 992(%rsi)
	ret
.Lpolynomial__reduce32$1:
	vmovdqu	glob_data + 4576(%rip), %ymm0
	vmovdqu	glob_data + 5216(%rip), %ymm1
	movq	$0, %r8
	jmp 	.Lpolynomial__reduce32$2
.Lpolynomial__reduce32$3:
	vmovdqu	(%rsi,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm4
	vpsrad	$23, %ymm4, %ymm4
	vpmulld	%ymm1, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$32, %r8
.Lpolynomial__reduce32$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__reduce32$3
	ret
.Lpolynomial__conditionally_add_modulus$1:
	vmovdqu	glob_data + 5216(%rip), %ymm1
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
	movq	$0, %rsi
	jmp 	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$3:
	vmovdqu	(%rcx,%rsi), %ymm0
	vmovdqu	(%rdx,%rsi), %ymm1
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%rsi)
	addq	$32, %rsi
	vmovdqu	(%rcx,%rsi), %ymm0
	vmovdqu	(%rdx,%rsi), %ymm1
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	glob_data + 4608(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4608(%rip), %ymm2, %ymm5
	vpmuldq	glob_data + 5216(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5216(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%rsi)
	addq	$32, %rsi
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2:
	cmpq	$1024, %rsi
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
	vpaddd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r9,%rdx)
	addq	$32, %rdx
.Lpolynomial__use_hints_gamma2_32$2:
	cmpq	$1024, %rdx
	jb  	.Lpolynomial__use_hints_gamma2_32$3
	ret
.Lpolynomial__decompose_gamma2_32$1:
	vmovdqu	glob_data + 5216(%rip), %ymm2
	vpsrld	$1, %ymm2, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vmovdqu	glob_data + 4640(%rip), %ymm5
	vmovdqu	glob_data + 4672(%rip), %ymm6
	vmovdqu	glob_data + 4704(%rip), %ymm7
	vmovdqu	glob_data + 4736(%rip), %ymm8
	vmovdqu	glob_data + 4768(%rip), %ymm9
	movq	$0, %rdi
	jmp 	.Lpolynomial__decompose_gamma2_32$2
.Lpolynomial__decompose_gamma2_32$3:
	vmovdqu	(%r9,%rdi), %ymm10
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
	vmovdqu	%ymm12, (%rdx,%rdi)
	vmovdqu	%ymm11, (%rsi,%rdi)
	addq	$32, %rdi
.Lpolynomial__decompose_gamma2_32$2:
	cmpq	$1024, %rdi
	jb  	.Lpolynomial__decompose_gamma2_32$3
	ret
.Lgamma1__coefficients_to_bytestream_bits20$1:
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	glob_data + 4864(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm2
	vpsrlq	$12, %ymm2, %ymm2
	vmovdqu	glob_data + 4896(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vextracti128	$0, %ymm2, %xmm12
	vextracti128	$1, %ymm2, %xmm11
	ret
.Lerror_polynomial__decode_eta2$1:
	movq	$0, %r9
	movq	$0, %rdi
	jmp 	.Lerror_polynomial__decode_eta2$2
.Lerror_polynomial__decode_eta2$3:
	movzbl	(%rdx,%r9), %r11d
	movzbl	1(%rdx,%r9), %r8d
	movzbl	2(%rdx,%r9), %r10d
	movl	%r11d, %ebx
	andl	$7, %ebx
	movl	$2, %ebp
	subl	%ebx, %ebp
	movl	%ebp, (%rcx,%rdi,4)
	movl	%r11d, %ebx
	shrl	$3, %ebx
	andl	$7, %ebx
	movl	$2, %ebp
	subl	%ebx, %ebp
	movl	%ebp, 4(%rcx,%rdi,4)
	shrl	$6, %r11d
	leal	(%r11,%r8,4), %r11d
	andl	$7, %r11d
	movl	$2, %ebx
	subl	%r11d, %ebx
	movl	%ebx, 8(%rcx,%rdi,4)
	movl	%r8d, %r11d
	shrl	$1, %r11d
	andl	$7, %r11d
	movl	$2, %ebx
	subl	%r11d, %ebx
	movl	%ebx, 12(%rcx,%rdi,4)
	movl	%r8d, %r11d
	shrl	$4, %r11d
	andl	$7, %r11d
	movl	$2, %ebx
	subl	%r11d, %ebx
	movl	%ebx, 16(%rcx,%rdi,4)
	shrl	$7, %r8d
	leal	(%r8,%r10,2), %r8d
	andl	$7, %r8d
	movl	$2, %r11d
	subl	%r8d, %r11d
	movl	%r11d, 20(%rcx,%rdi,4)
	movl	%r10d, %r8d
	shrl	$2, %r8d
	andl	$7, %r8d
	movl	$2, %r11d
	subl	%r8d, %r11d
	movl	%r11d, 24(%rcx,%rdi,4)
	shrl	$5, %r10d
	andl	$7, %r10d
	movl	$2, %r8d
	subl	%r10d, %r8d
	movl	%r8d, 28(%rcx,%rdi,4)
	addq	$8, %rdi
	addq	$3, %r9
.Lerror_polynomial__decode_eta2$2:
	cmpq	$96, %r9
	jb  	.Lerror_polynomial__decode_eta2$3
	ret
.Lerror_polynomial__encode_eta2$1:
	movq	$2, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.Lerror_polynomial__encode_eta2$4
.Lerror_polynomial__encode_eta2$5:
	vmovdqu	(%rcx,%r9), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	vpsubd	%ymm3, %ymm0, %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	vpsubd	%ymm4, %ymm0, %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	vpsubd	%ymm5, %ymm0, %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	vpsubd	%ymm6, %ymm0, %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	vpsubd	%ymm7, %ymm0, %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	vpsubd	%ymm9, %ymm0, %ymm9
	addq	$32, %r9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vmovdqu	glob_data + 4928(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm1, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 4992(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5024(%rip), %ymm1
	vpmaddwd	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5056(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%xmm2, (%rax,%r8)
	vextracti128	$1, %ymm2, 12(%rax,%r8)
	addq	$24, %r8
.Lerror_polynomial__encode_eta2$4:
	cmpq	$72, %r8
	jb  	.Lerror_polynomial__encode_eta2$5
	vmovdqu	(%rcx,%r9), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm3
	vpsubd	%ymm3, %ymm0, %ymm3
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm4
	vpsubd	%ymm4, %ymm0, %ymm4
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm5
	vpsubd	%ymm5, %ymm0, %ymm5
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm6
	vpsubd	%ymm6, %ymm0, %ymm6
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm7
	vpsubd	%ymm7, %ymm0, %ymm7
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm8
	addq	$32, %r9
	vmovdqu	(%rcx,%r9), %ymm9
	vpsubd	%ymm9, %ymm0, %ymm9
	vpackusdw	%ymm3, %ymm2, %ymm2
	vpackusdw	%ymm5, %ymm4, %ymm3
	vpackusdw	%ymm7, %ymm6, %ymm4
	vpackusdw	%ymm9, %ymm8, %ymm5
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm4, %ymm3
	vmovdqu	glob_data + 4928(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm1, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 4992(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5024(%rip), %ymm1
	vpmaddwd	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5056(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	%xmm2, (%rax,%r8)
	addq	$12, %r8
	vextracti128	$1, %ymm2, 16(%rsp)
	movq	$0, %r9
	jmp 	.Lerror_polynomial__encode_eta2$2
.Lerror_polynomial__encode_eta2$3:
	movb	16(%rsp,%r9), %cl
	movb	%cl, (%rax,%r8)
	incq	%r8
	incq	%r9
.Lerror_polynomial__encode_eta2$2:
	cmpq	$12, %r9
	jb  	.Lerror_polynomial__encode_eta2$3
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
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
