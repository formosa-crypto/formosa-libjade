	.att_syntax
	.text
	.p2align	5
	.global	ml_dsa_87_verify
	.global	ml_dsa_87_sign
	.global	ml_dsa_87_keygen
	.type	ml_dsa_87_verify, %function
ml_dsa_87_verify:
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
	movq	$0, %r9
	movq	(%rsi), %rax
	movq	8(%rsi), %rsi
	lfence
	movq	$0, %r9
	cmpq	$255, %rsi
	jbe 	.Lml_dsa_87_verify$1
	movq	$-1, %r11
	jmp 	.Lml_dsa_87_verify$2
.Lml_dsa_87_verify$1:
	leaq	-97304(%rsp), %rsp
	call	.L__verify_internal$1
.Lml_dsa_87_verify$3:
	leaq	97304(%rsp), %rsp
.Lml_dsa_87_verify$2:
	movq	%r11, %rax
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
	subq	$99488, %rsp
	movq	$99488, %rdi
.Lml_dsa_87_verify$4:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Lml_dsa_87_verify$4
	movq	%rsi, %rsp
	lfence
	ret
	.type	ml_dsa_87_sign, %function
ml_dsa_87_sign:
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
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$170592, %rsp
	movq	$170592, %rdi
.Lml_dsa_87_sign$4:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Lml_dsa_87_sign$4
	movq	%rsi, %rsp
	lfence
	ret
	.type	ml_dsa_87_keygen, %function
ml_dsa_87_keygen:
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
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$96320, %rsp
	movq	$96320, %rdi
.Lml_dsa_87_keygen$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Lml_dsa_87_keygen$2
	movq	%rsi, %rsp
	lfence
	ret
.L__verify_internal$1:
	movq	%rax, 97216(%rsp)
	movq	%rsi, 97224(%rsp)
	movq	%rdx, 97232(%rsp)
	movq	%rcx, 97240(%rsp)
	leaq	8128(%rsp), %rax
	leaq	15296(%rsp), %rcx
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
	jmp 	.L__verify_internal$680
.L__verify_internal$681:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$680:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$681
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
	jmp 	.L__verify_internal$678
.L__verify_internal$679:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$678:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$679
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
	jmp 	.L__verify_internal$676
.L__verify_internal$677:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$676:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$677
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
	jmp 	.L__verify_internal$674
.L__verify_internal$675:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$674:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$675
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
	jmp 	.L__verify_internal$672
.L__verify_internal$673:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$672:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$673
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
	jmp 	.L__verify_internal$670
.L__verify_internal$671:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rsi,%r11)
	addq	$32, %r11
.L__verify_internal$670:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$671
	leaq	6144(%rax), %rax
	leaq	3840(%rdx), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r11
	jmp 	.L__verify_internal$668
.L__verify_internal$669:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r11)
	addq	$32, %r11
.L__verify_internal$668:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$669
	leaq	4544(%r8), %rax
	lfence
	movq	$0, %rdx
	movq	$0, %r11
	movq	$0, %r12
	movq	$0, %rsi
	jmp 	.L__verify_internal$652
.L__verify_internal$653:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%rsi, %r9
	shlq	$8, %r9
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx,%r9,4)
	vmovdqu	%ymm0, 32(%rcx,%r9,4)
	vmovdqu	%ymm0, 64(%rcx,%r9,4)
	vmovdqu	%ymm0, 96(%rcx,%r9,4)
	vmovdqu	%ymm0, 128(%rcx,%r9,4)
	vmovdqu	%ymm0, 160(%rcx,%r9,4)
	vmovdqu	%ymm0, 192(%rcx,%r9,4)
	vmovdqu	%ymm0, 224(%rcx,%r9,4)
	vmovdqu	%ymm0, 256(%rcx,%r9,4)
	vmovdqu	%ymm0, 288(%rcx,%r9,4)
	vmovdqu	%ymm0, 320(%rcx,%r9,4)
	vmovdqu	%ymm0, 352(%rcx,%r9,4)
	vmovdqu	%ymm0, 384(%rcx,%r9,4)
	vmovdqu	%ymm0, 416(%rcx,%r9,4)
	vmovdqu	%ymm0, 448(%rcx,%r9,4)
	vmovdqu	%ymm0, 480(%rcx,%r9,4)
	vmovdqu	%ymm0, 512(%rcx,%r9,4)
	vmovdqu	%ymm0, 544(%rcx,%r9,4)
	vmovdqu	%ymm0, 576(%rcx,%r9,4)
	vmovdqu	%ymm0, 608(%rcx,%r9,4)
	vmovdqu	%ymm0, 640(%rcx,%r9,4)
	vmovdqu	%ymm0, 672(%rcx,%r9,4)
	vmovdqu	%ymm0, 704(%rcx,%r9,4)
	vmovdqu	%ymm0, 736(%rcx,%r9,4)
	vmovdqu	%ymm0, 768(%rcx,%r9,4)
	vmovdqu	%ymm0, 800(%rcx,%r9,4)
	vmovdqu	%ymm0, 832(%rcx,%r9,4)
	vmovdqu	%ymm0, 864(%rcx,%r9,4)
	vmovdqu	%ymm0, 896(%rcx,%r9,4)
	vmovdqu	%ymm0, 928(%rcx,%r9,4)
	vmovdqu	%ymm0, 960(%rcx,%r9,4)
	vmovdqu	%ymm0, 992(%rcx,%r9,4)
	movzbq	75(%rax,%rsi), %r10
	orq 	%rdx, %r10
	cmpq	%r12, %r10
	jb  	.L__verify_internal$656
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	cmpq	$75, %r10
	jnbe	.L__verify_internal$658
	movq	$-1, %rbx
	cmovnbe	%rbx, %rdx
	movq	%r12, %rbx
	jmp 	.L__verify_internal$660
.L__verify_internal$661:
	movq	$-1, %rbp
	cmovne	%rbp, %rdx
	movzbq	(%rax,%rbx), %rbp
	orq 	%rdx, %rbp
	cmpq	%r12, %rbx
	jnbe	.L__verify_internal$664
	movq	$-1, %r13
	cmovnbe	%r13, %rdx
	jmp 	.L__verify_internal$665
.L__verify_internal$664:
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	movzbq	-1(%rax,%rbx), %r13
	orq 	%rdx, %r13
	cmpq	%r13, %rbp
	jbe 	.L__verify_internal$666
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	jmp 	.L__verify_internal$665
.L__verify_internal$666:
	movq	$-1, %r11
	cmovnbe	%r11, %rdx
	movq	$1, %r11
.L__verify_internal$667:
.L__verify_internal$665:
	cmpq	$0, %r11
	je  	.L__verify_internal$662
	movq	$-1, %rbp
	cmove	%rbp, %rdx
	jmp 	.L__verify_internal$660
.L__verify_internal$662:
	movq	$-1, %r13
	cmovne	%r13, %rdx
	movq	%r9, %r13
	addq	%rbp, %r13
	movl	$1, (%rcx,%r13,4)
	incq	%rbx
.L__verify_internal$663:
.L__verify_internal$660:
	cmpq	%r10, %rbx
	setnb	%bpl
	orb 	%r11b, %bpl
	cmpb	$0, %bpl
	je  	.L__verify_internal$661
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$657
.L__verify_internal$658:
	movq	$-1, %r9
	cmovbe	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$659:
	jmp 	.L__verify_internal$657
.L__verify_internal$656:
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$657:
	cmpq	$0, %r11
	je  	.L__verify_internal$654
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$652
.L__verify_internal$654:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%r10, %r12
	incq	%rsi
.L__verify_internal$655:
.L__verify_internal$652:
	cmpq	$8, %rsi
	setnb	%r9b
	orb 	%r11b, %r9b
	cmpb	$0, %r9b
	je  	.L__verify_internal$653
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$646
.L__verify_internal$647:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	movzbq	(%rax,%r12), %rcx
	orq 	%rdx, %rcx
	cmpq	$0, %rcx
	jne 	.L__verify_internal$650
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	jmp 	.L__verify_internal$651
.L__verify_internal$650:
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	movq	$1, %r11
.L__verify_internal$651:
	cmpq	$0, %r11
	je  	.L__verify_internal$648
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$646
.L__verify_internal$648:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	incq	%r12
.L__verify_internal$649:
.L__verify_internal$646:
	cmpq	$75, %r12
	setnb	%cl
	orb 	%r11b, %cl
	cmpb	$0, %cl
	je  	.L__verify_internal$647
	negq	%r11
	leaq	8128(%rsp), %rax
	movq	$0, %rcx
	movq	%rax, %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$644
.L__verify_internal$645:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$644:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$645
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	1024(%rax), %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$642
.L__verify_internal$643:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$642:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$643
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	2048(%rax), %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$640
.L__verify_internal$641:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$640:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$641
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	3072(%rax), %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$638
.L__verify_internal$639:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$638:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$639
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	4096(%rax), %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$636
.L__verify_internal$637:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$636:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$637
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	5120(%rax), %rsi
	movq	$524167, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$634
.L__verify_internal$635:
	vmovdqu	(%rsi,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$634:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$635
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	6144(%rax), %rax
	movq	$524167, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %r9
	jmp 	.L__verify_internal$632
.L__verify_internal$633:
	vmovdqu	(%rax,%r9), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %r9
.L__verify_internal$632:
	cmpq	$1024, %r9
	jb  	.L__verify_internal$633
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
	movq	%r8, 97248(%rsp)
	movq	%rdi, 97256(%rsp)
	vmovdqu	(%rdi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	leaq	352(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	vmovdqu	%ymm0, 128(%rax)
	vmovdqu	%ymm0, 160(%rax)
	movq	$0, 192(%rax)
	movq	%rdi, %mm4
	movw	$0, 97264(%rsp)
	movw	$1, 97266(%rsp)
	movw	$2, 97268(%rsp)
	movw	$3, 97270(%rsp)
	movq	%mm4, %rax
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$631:
	leaq	40(%rsp), %rsp
	movq	%rax, %mm5
	movq	%mm5, %rax
	movq	$0, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$630:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4192(%rsp), %rax
	leaq	3328(%rsp), %rcx
	leaq	2464(%rsp), %rdx
	leaq	1600(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$628
.L__verify_internal$629:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$628:
	cmpq	$160, %r9
	jb  	.L__verify_internal$629
	jmp 	.L__verify_internal$626
.L__verify_internal$627:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$626:
	cmpq	$168, %r9
	jb  	.L__verify_internal$627
	movq	%mm5, %rax
	movq	$136, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$625:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4360(%rsp), %rax
	leaq	3496(%rsp), %rcx
	leaq	2632(%rsp), %rdx
	leaq	1768(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$623
.L__verify_internal$624:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$623:
	cmpq	$160, %r9
	jb  	.L__verify_internal$624
	jmp 	.L__verify_internal$621
.L__verify_internal$622:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$621:
	cmpq	$168, %r9
	jb  	.L__verify_internal$622
	movq	%mm5, %rax
	movq	$272, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$620:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4528(%rsp), %rax
	leaq	3664(%rsp), %rcx
	leaq	2800(%rsp), %rdx
	leaq	1936(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$618
.L__verify_internal$619:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$618:
	cmpq	$160, %r9
	jb  	.L__verify_internal$619
	jmp 	.L__verify_internal$616
.L__verify_internal$617:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$616:
	cmpq	$168, %r9
	jb  	.L__verify_internal$617
	movq	%mm5, %rax
	movq	$408, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$615:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4696(%rsp), %rax
	leaq	3832(%rsp), %rcx
	leaq	2968(%rsp), %rdx
	leaq	2104(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$613
.L__verify_internal$614:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$613:
	cmpq	$160, %r9
	jb  	.L__verify_internal$614
	jmp 	.L__verify_internal$611
.L__verify_internal$612:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$611:
	cmpq	$168, %r9
	jb  	.L__verify_internal$612
	movq	%mm5, %rax
	movq	$544, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$610:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4864(%rsp), %rax
	leaq	4000(%rsp), %rcx
	leaq	3136(%rsp), %rdx
	leaq	2272(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$608
.L__verify_internal$609:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$608:
	cmpq	$160, %r9
	jb  	.L__verify_internal$609
	jmp 	.L__verify_internal$606
.L__verify_internal$607:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$606:
	cmpq	$168, %r9
	jb  	.L__verify_internal$607
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	39872(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$605:
	movq	%r8, %r10
	leaq	40896(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$604:
	movq	%r8, %r11
	leaq	41920(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$603:
	movq	%r8, %rbx
	leaq	42944(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$602:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$595
	cmpq	$256, %r11
	jb  	.L__verify_internal$597
	cmpq	$256, %rbx
	jb  	.L__verify_internal$599
	cmpq	$256, %r8
	jnb 	.L__verify_internal$581
	movl	$0, %edi
.L__verify_internal$601:
	jmp 	.L__verify_internal$581
.L__verify_internal$599:
	movl	$0, %edi
.L__verify_internal$600:
	jmp 	.L__verify_internal$581
.L__verify_internal$597:
	movl	$0, %edi
.L__verify_internal$598:
	jmp 	.L__verify_internal$581
.L__verify_internal$595:
	movl	$0, %edi
.L__verify_internal$596:
	jmp 	.L__verify_internal$581
.L__verify_internal$582:
	movq	%r10, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$594:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97296(%rsp), %r12
	leaq	39872(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$593:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	40896(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$592:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	41920(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$591:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	42944(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$590:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$583
	cmpq	$256, %r11
	jb  	.L__verify_internal$585
	cmpq	$256, %rbx
	jb  	.L__verify_internal$587
	cmpq	$256, %r8
	jnb 	.L__verify_internal$581
	movl	$0, %edi
.L__verify_internal$589:
	jmp 	.L__verify_internal$581
.L__verify_internal$587:
	movl	$0, %edi
.L__verify_internal$588:
	jmp 	.L__verify_internal$581
.L__verify_internal$585:
	movl	$0, %edi
.L__verify_internal$586:
	jmp 	.L__verify_internal$581
.L__verify_internal$583:
	movl	$0, %edi
.L__verify_internal$584:
.L__verify_internal$581:
	cmpl	$1, %edi
	jne 	.L__verify_internal$582
	movw	$4, 97264(%rsp)
	movw	$5, 97266(%rsp)
	movw	$6, 97268(%rsp)
	movw	$256, 97270(%rsp)
	movq	%mm4, %rax
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$580:
	leaq	40(%rsp), %rsp
	movq	%rax, %mm5
	movq	%mm5, %rax
	movq	$680, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$579:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4192(%rsp), %rax
	leaq	3328(%rsp), %rcx
	leaq	2464(%rsp), %rdx
	leaq	1600(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$577
.L__verify_internal$578:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$577:
	cmpq	$160, %r9
	jb  	.L__verify_internal$578
	jmp 	.L__verify_internal$575
.L__verify_internal$576:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$575:
	cmpq	$168, %r9
	jb  	.L__verify_internal$576
	movq	%mm5, %rax
	movq	$816, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$574:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4360(%rsp), %rax
	leaq	3496(%rsp), %rcx
	leaq	2632(%rsp), %rdx
	leaq	1768(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$572
.L__verify_internal$573:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$572:
	cmpq	$160, %r9
	jb  	.L__verify_internal$573
	jmp 	.L__verify_internal$570
.L__verify_internal$571:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$570:
	cmpq	$168, %r9
	jb  	.L__verify_internal$571
	movq	%mm5, %rax
	movq	$952, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$569:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4528(%rsp), %rax
	leaq	3664(%rsp), %rcx
	leaq	2800(%rsp), %rdx
	leaq	1936(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$567
.L__verify_internal$568:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$567:
	cmpq	$160, %r9
	jb  	.L__verify_internal$568
	jmp 	.L__verify_internal$565
.L__verify_internal$566:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$565:
	cmpq	$168, %r9
	jb  	.L__verify_internal$566
	movq	%mm5, %rax
	movq	$1088, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$564:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4696(%rsp), %rax
	leaq	3832(%rsp), %rcx
	leaq	2968(%rsp), %rdx
	leaq	2104(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$562
.L__verify_internal$563:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$562:
	cmpq	$160, %r9
	jb  	.L__verify_internal$563
	jmp 	.L__verify_internal$560
.L__verify_internal$561:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$560:
	cmpq	$168, %r9
	jb  	.L__verify_internal$561
	movq	%mm5, %rax
	movq	$1224, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$559:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4864(%rsp), %rax
	leaq	4000(%rsp), %rcx
	leaq	3136(%rsp), %rdx
	leaq	2272(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$557
.L__verify_internal$558:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$557:
	cmpq	$160, %r9
	jb  	.L__verify_internal$558
	jmp 	.L__verify_internal$555
.L__verify_internal$556:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$555:
	cmpq	$168, %r9
	jb  	.L__verify_internal$556
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	43968(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$554:
	movq	%r8, %r10
	leaq	44992(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$553:
	movq	%r8, %r11
	leaq	46016(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$552:
	movq	%r8, %rbx
	leaq	47040(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$551:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$544
	cmpq	$256, %r11
	jb  	.L__verify_internal$546
	cmpq	$256, %rbx
	jb  	.L__verify_internal$548
	cmpq	$256, %r8
	jnb 	.L__verify_internal$530
	movl	$0, %edi
.L__verify_internal$550:
	jmp 	.L__verify_internal$530
.L__verify_internal$548:
	movl	$0, %edi
.L__verify_internal$549:
	jmp 	.L__verify_internal$530
.L__verify_internal$546:
	movl	$0, %edi
.L__verify_internal$547:
	jmp 	.L__verify_internal$530
.L__verify_internal$544:
	movl	$0, %edi
.L__verify_internal$545:
	jmp 	.L__verify_internal$530
.L__verify_internal$531:
	movq	%r10, 97296(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%rbx, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$543:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %r11
	movq	97280(%rsp), %rbx
	movq	97272(%rsp), %r12
	leaq	43968(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$542:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	44992(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$541:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	46016(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$540:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	47040(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$539:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$532
	cmpq	$256, %r11
	jb  	.L__verify_internal$534
	cmpq	$256, %rbx
	jb  	.L__verify_internal$536
	cmpq	$256, %r8
	jnb 	.L__verify_internal$530
	movl	$0, %edi
.L__verify_internal$538:
	jmp 	.L__verify_internal$530
.L__verify_internal$536:
	movl	$0, %edi
.L__verify_internal$537:
	jmp 	.L__verify_internal$530
.L__verify_internal$534:
	movl	$0, %edi
.L__verify_internal$535:
	jmp 	.L__verify_internal$530
.L__verify_internal$532:
	movl	$0, %edi
.L__verify_internal$533:
.L__verify_internal$530:
	cmpl	$1, %edi
	jne 	.L__verify_internal$531
	movw	$257, 97264(%rsp)
	movw	$258, 97266(%rsp)
	movw	$259, 97268(%rsp)
	movw	$260, 97270(%rsp)
	movq	%mm4, %rax
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$529:
	leaq	40(%rsp), %rsp
	movq	%rax, %mm5
	movq	%mm5, %rax
	movq	$1360, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$528:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4192(%rsp), %rax
	leaq	3328(%rsp), %rcx
	leaq	2464(%rsp), %rdx
	leaq	1600(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$526
.L__verify_internal$527:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$526:
	cmpq	$160, %r9
	jb  	.L__verify_internal$527
	jmp 	.L__verify_internal$524
.L__verify_internal$525:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$524:
	cmpq	$168, %r9
	jb  	.L__verify_internal$525
	movq	%mm5, %rax
	movq	$1496, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$523:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4360(%rsp), %rax
	leaq	3496(%rsp), %rcx
	leaq	2632(%rsp), %rdx
	leaq	1768(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$521
.L__verify_internal$522:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$521:
	cmpq	$160, %r9
	jb  	.L__verify_internal$522
	jmp 	.L__verify_internal$519
.L__verify_internal$520:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$519:
	cmpq	$168, %r9
	jb  	.L__verify_internal$520
	movq	%mm5, %rax
	movq	$1632, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$518:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4528(%rsp), %rax
	leaq	3664(%rsp), %rcx
	leaq	2800(%rsp), %rdx
	leaq	1936(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$516
.L__verify_internal$517:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$516:
	cmpq	$160, %r9
	jb  	.L__verify_internal$517
	jmp 	.L__verify_internal$514
.L__verify_internal$515:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$514:
	cmpq	$168, %r9
	jb  	.L__verify_internal$515
	movq	%mm5, %rax
	movq	$1768, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$513:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4696(%rsp), %rax
	leaq	3832(%rsp), %rcx
	leaq	2968(%rsp), %rdx
	leaq	2104(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$511
.L__verify_internal$512:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$511:
	cmpq	$160, %r9
	jb  	.L__verify_internal$512
	jmp 	.L__verify_internal$509
.L__verify_internal$510:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$509:
	cmpq	$168, %r9
	jb  	.L__verify_internal$510
	movq	%mm5, %rax
	movq	$1904, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$508:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4864(%rsp), %rax
	leaq	4000(%rsp), %rcx
	leaq	3136(%rsp), %rdx
	leaq	2272(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$506
.L__verify_internal$507:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$506:
	cmpq	$160, %r9
	jb  	.L__verify_internal$507
	jmp 	.L__verify_internal$504
.L__verify_internal$505:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$504:
	cmpq	$168, %r9
	jb  	.L__verify_internal$505
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	48064(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$503:
	movq	%r8, %r10
	leaq	49088(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$502:
	movq	%r8, %rbx
	leaq	50112(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$501:
	movq	%r8, %r11
	leaq	51136(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$500:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$493
	cmpq	$256, %rbx
	jb  	.L__verify_internal$495
	cmpq	$256, %r11
	jb  	.L__verify_internal$497
	cmpq	$256, %r8
	jnb 	.L__verify_internal$479
	movl	$0, %edi
.L__verify_internal$499:
	jmp 	.L__verify_internal$479
.L__verify_internal$497:
	movl	$0, %edi
.L__verify_internal$498:
	jmp 	.L__verify_internal$479
.L__verify_internal$495:
	movl	$0, %edi
.L__verify_internal$496:
	jmp 	.L__verify_internal$479
.L__verify_internal$493:
	movl	$0, %edi
.L__verify_internal$494:
	jmp 	.L__verify_internal$479
.L__verify_internal$480:
	movq	%r10, 97272(%rsp)
	movq	%rbx, 97280(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$492:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %rbx
	movq	97288(%rsp), %r11
	movq	97296(%rsp), %r12
	leaq	48064(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$491:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	49088(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$490:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	50112(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$489:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	51136(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$488:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$481
	cmpq	$256, %rbx
	jb  	.L__verify_internal$483
	cmpq	$256, %r11
	jb  	.L__verify_internal$485
	cmpq	$256, %r8
	jnb 	.L__verify_internal$479
	movl	$0, %edi
.L__verify_internal$487:
	jmp 	.L__verify_internal$479
.L__verify_internal$485:
	movl	$0, %edi
.L__verify_internal$486:
	jmp 	.L__verify_internal$479
.L__verify_internal$483:
	movl	$0, %edi
.L__verify_internal$484:
	jmp 	.L__verify_internal$479
.L__verify_internal$481:
	movl	$0, %edi
.L__verify_internal$482:
.L__verify_internal$479:
	cmpl	$1, %edi
	jne 	.L__verify_internal$480
	movw	$261, 97264(%rsp)
	movw	$262, 97266(%rsp)
	movw	$512, 97268(%rsp)
	movw	$513, 97270(%rsp)
	movq	%mm4, %rax
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$478:
	leaq	40(%rsp), %rsp
	movq	%rax, %mm4
	movq	%mm4, %rax
	movq	$2040, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$477:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4192(%rsp), %rax
	leaq	3328(%rsp), %rcx
	leaq	2464(%rsp), %rdx
	leaq	1600(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$475
.L__verify_internal$476:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$475:
	cmpq	$160, %r9
	jb  	.L__verify_internal$476
	jmp 	.L__verify_internal$473
.L__verify_internal$474:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$473:
	cmpq	$168, %r9
	jb  	.L__verify_internal$474
	movq	%mm4, %rax
	movq	$2176, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$472:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4360(%rsp), %rax
	leaq	3496(%rsp), %rcx
	leaq	2632(%rsp), %rdx
	leaq	1768(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$470
.L__verify_internal$471:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$470:
	cmpq	$160, %r9
	jb  	.L__verify_internal$471
	jmp 	.L__verify_internal$468
.L__verify_internal$469:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$468:
	cmpq	$168, %r9
	jb  	.L__verify_internal$469
	movq	%mm4, %rax
	movq	$2312, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$467:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4528(%rsp), %rax
	leaq	3664(%rsp), %rcx
	leaq	2800(%rsp), %rdx
	leaq	1936(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$465
.L__verify_internal$466:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$465:
	cmpq	$160, %r9
	jb  	.L__verify_internal$466
	jmp 	.L__verify_internal$463
.L__verify_internal$464:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$463:
	cmpq	$168, %r9
	jb  	.L__verify_internal$464
	movq	%mm4, %rax
	movq	$2448, %r8
	leaq	352(%rsp), %rcx
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	128(%rax,%r8), %rax
	xorq	%rax, 128(%rcx)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$462:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4696(%rsp), %rax
	leaq	3832(%rsp), %rcx
	leaq	2968(%rsp), %rdx
	leaq	2104(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$460
.L__verify_internal$461:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$460:
	cmpq	$160, %r9
	jb  	.L__verify_internal$461
	jmp 	.L__verify_internal$458
.L__verify_internal$459:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$458:
	cmpq	$168, %r9
	jb  	.L__verify_internal$459
	movq	%mm4, %rax
	movq	$2584, %r8
	leaq	352(%rsp), %rcx
	movq	(%rax,%r8), %rax
	xorq	%rax, (%rcx)
	movq	$0, %rax
	movq	$31, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %rax
	xorq	%rax, 8(%rcx)
	leaq	352(%rsp), %rax
	xorb	$128, 135(%rax)
	leaq	800(%rsp), %rax
	leaq	352(%rsp), %rcx
	leaq	-1240(%rsp), %rsp
	call	.L_keccakf1600_x4_x1_nat_opt$1
.L__verify_internal$457:
	leaq	1240(%rsp), %rsp
	movq	$0, %r8
	leaq	4864(%rsp), %rax
	leaq	4000(%rsp), %rcx
	leaq	3136(%rsp), %rdx
	leaq	2272(%rsp), %rsi
	leaq	800(%rsp), %rdi
	movq	$0, %r9
	jmp 	.L__verify_internal$455
.L__verify_internal$456:
	vmovdqu	(%rdi,%r9,4), %ymm11
	vmovdqu	32(%rdi,%r9,4), %ymm13
	vmovdqu	64(%rdi,%r9,4), %ymm5
	vmovdqu	96(%rdi,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rax,%r8)
	vmovdqu	%ymm2, (%rcx,%r8)
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	addq	$32, %r8
.L__verify_internal$455:
	cmpq	$160, %r9
	jb  	.L__verify_internal$456
	jmp 	.L__verify_internal$453
.L__verify_internal$454:
	movq	(%rdi,%r9,4), %r10
	movq	%r10, (%rax,%r8)
	movq	8(%rdi,%r9,4), %r10
	movq	%r10, (%rcx,%r8)
	movq	16(%rdi,%r9,4), %r10
	movq	%r10, (%rdx,%r8)
	movq	24(%rdi,%r9,4), %r10
	movq	%r10, (%rsi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L__verify_internal$453:
	cmpq	$168, %r9
	jb  	.L__verify_internal$454
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	52160(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$452:
	movq	%r8, %rbx
	leaq	53184(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$451:
	movq	%r8, %r11
	leaq	54208(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$450:
	movq	%r8, %r10
	leaq	55232(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$449:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$442
	cmpq	$256, %r11
	jb  	.L__verify_internal$444
	cmpq	$256, %r10
	jb  	.L__verify_internal$446
	cmpq	$256, %r8
	jnb 	.L__verify_internal$428
	movl	$0, %edi
.L__verify_internal$448:
	jmp 	.L__verify_internal$428
.L__verify_internal$446:
	movl	$0, %edi
.L__verify_internal$447:
	jmp 	.L__verify_internal$428
.L__verify_internal$444:
	movl	$0, %edi
.L__verify_internal$445:
	jmp 	.L__verify_internal$428
.L__verify_internal$442:
	movl	$0, %edi
.L__verify_internal$443:
	jmp 	.L__verify_internal$428
.L__verify_internal$429:
	movq	%rbx, 97296(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%r10, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$441:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %r11
	movq	97280(%rsp), %r10
	movq	97272(%rsp), %r12
	leaq	52160(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$440:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	53184(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$439:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	54208(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$438:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	55232(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$437:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$430
	cmpq	$256, %r11
	jb  	.L__verify_internal$432
	cmpq	$256, %r10
	jb  	.L__verify_internal$434
	cmpq	$256, %r8
	jnb 	.L__verify_internal$428
	movl	$0, %edi
.L__verify_internal$436:
	jmp 	.L__verify_internal$428
.L__verify_internal$434:
	movl	$0, %edi
.L__verify_internal$435:
	jmp 	.L__verify_internal$428
.L__verify_internal$432:
	movl	$0, %edi
.L__verify_internal$433:
	jmp 	.L__verify_internal$428
.L__verify_internal$430:
	movl	$0, %edi
.L__verify_internal$431:
.L__verify_internal$428:
	cmpl	$1, %edi
	jne 	.L__verify_internal$429
	movw	$514, 97264(%rsp)
	movw	$515, 97266(%rsp)
	movw	$516, 97268(%rsp)
	movw	$517, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$427:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$426:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$425:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$424:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$423:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$422:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	56256(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$421:
	movq	%r8, %r10
	leaq	57280(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$420:
	movq	%r8, %r11
	leaq	58304(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$419:
	movq	%r8, %rbx
	leaq	59328(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$418:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$411
	cmpq	$256, %r11
	jb  	.L__verify_internal$413
	cmpq	$256, %rbx
	jb  	.L__verify_internal$415
	cmpq	$256, %r8
	jnb 	.L__verify_internal$397
	movl	$0, %edi
.L__verify_internal$417:
	jmp 	.L__verify_internal$397
.L__verify_internal$415:
	movl	$0, %edi
.L__verify_internal$416:
	jmp 	.L__verify_internal$397
.L__verify_internal$413:
	movl	$0, %edi
.L__verify_internal$414:
	jmp 	.L__verify_internal$397
.L__verify_internal$411:
	movl	$0, %edi
.L__verify_internal$412:
	jmp 	.L__verify_internal$397
.L__verify_internal$398:
	movq	%r10, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$410:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97296(%rsp), %r12
	leaq	56256(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$409:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	57280(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$408:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	58304(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$407:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	59328(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$406:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$399
	cmpq	$256, %r11
	jb  	.L__verify_internal$401
	cmpq	$256, %rbx
	jb  	.L__verify_internal$403
	cmpq	$256, %r8
	jnb 	.L__verify_internal$397
	movl	$0, %edi
.L__verify_internal$405:
	jmp 	.L__verify_internal$397
.L__verify_internal$403:
	movl	$0, %edi
.L__verify_internal$404:
	jmp 	.L__verify_internal$397
.L__verify_internal$401:
	movl	$0, %edi
.L__verify_internal$402:
	jmp 	.L__verify_internal$397
.L__verify_internal$399:
	movl	$0, %edi
.L__verify_internal$400:
.L__verify_internal$397:
	cmpl	$1, %edi
	jne 	.L__verify_internal$398
	movw	$518, 97264(%rsp)
	movw	$768, 97266(%rsp)
	movw	$769, 97268(%rsp)
	movw	$770, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$396:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$395:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$394:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$393:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$392:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$391:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	60352(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$390:
	movq	%r8, %r10
	leaq	61376(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$389:
	movq	%r8, %r11
	leaq	62400(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$388:
	movq	%r8, %rbx
	leaq	63424(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$387:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$380
	cmpq	$256, %r11
	jb  	.L__verify_internal$382
	cmpq	$256, %rbx
	jb  	.L__verify_internal$384
	cmpq	$256, %r8
	jnb 	.L__verify_internal$366
	movl	$0, %edi
.L__verify_internal$386:
	jmp 	.L__verify_internal$366
.L__verify_internal$384:
	movl	$0, %edi
.L__verify_internal$385:
	jmp 	.L__verify_internal$366
.L__verify_internal$382:
	movl	$0, %edi
.L__verify_internal$383:
	jmp 	.L__verify_internal$366
.L__verify_internal$380:
	movl	$0, %edi
.L__verify_internal$381:
	jmp 	.L__verify_internal$366
.L__verify_internal$367:
	movq	%r10, 97296(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%rbx, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$379:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %r11
	movq	97280(%rsp), %rbx
	movq	97272(%rsp), %r12
	leaq	60352(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$378:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	61376(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$377:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	62400(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$376:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	63424(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$375:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$368
	cmpq	$256, %r11
	jb  	.L__verify_internal$370
	cmpq	$256, %rbx
	jb  	.L__verify_internal$372
	cmpq	$256, %r8
	jnb 	.L__verify_internal$366
	movl	$0, %edi
.L__verify_internal$374:
	jmp 	.L__verify_internal$366
.L__verify_internal$372:
	movl	$0, %edi
.L__verify_internal$373:
	jmp 	.L__verify_internal$366
.L__verify_internal$370:
	movl	$0, %edi
.L__verify_internal$371:
	jmp 	.L__verify_internal$366
.L__verify_internal$368:
	movl	$0, %edi
.L__verify_internal$369:
.L__verify_internal$366:
	cmpl	$1, %edi
	jne 	.L__verify_internal$367
	movw	$771, 97264(%rsp)
	movw	$772, 97266(%rsp)
	movw	$773, 97268(%rsp)
	movw	$774, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$365:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$364:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$363:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$362:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$361:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$360:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	64448(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$359:
	movq	%r8, %r10
	leaq	65472(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$358:
	movq	%r8, %r11
	leaq	66496(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$357:
	movq	%r8, %rbx
	leaq	67520(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$356:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$349
	cmpq	$256, %r11
	jb  	.L__verify_internal$351
	cmpq	$256, %rbx
	jb  	.L__verify_internal$353
	cmpq	$256, %r8
	jnb 	.L__verify_internal$335
	movl	$0, %edi
.L__verify_internal$355:
	jmp 	.L__verify_internal$335
.L__verify_internal$353:
	movl	$0, %edi
.L__verify_internal$354:
	jmp 	.L__verify_internal$335
.L__verify_internal$351:
	movl	$0, %edi
.L__verify_internal$352:
	jmp 	.L__verify_internal$335
.L__verify_internal$349:
	movl	$0, %edi
.L__verify_internal$350:
	jmp 	.L__verify_internal$335
.L__verify_internal$336:
	movq	%r10, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$348:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97296(%rsp), %r12
	leaq	64448(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$347:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	65472(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$346:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	66496(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$345:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	67520(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$344:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$337
	cmpq	$256, %r11
	jb  	.L__verify_internal$339
	cmpq	$256, %rbx
	jb  	.L__verify_internal$341
	cmpq	$256, %r8
	jnb 	.L__verify_internal$335
	movl	$0, %edi
.L__verify_internal$343:
	jmp 	.L__verify_internal$335
.L__verify_internal$341:
	movl	$0, %edi
.L__verify_internal$342:
	jmp 	.L__verify_internal$335
.L__verify_internal$339:
	movl	$0, %edi
.L__verify_internal$340:
	jmp 	.L__verify_internal$335
.L__verify_internal$337:
	movl	$0, %edi
.L__verify_internal$338:
.L__verify_internal$335:
	cmpl	$1, %edi
	jne 	.L__verify_internal$336
	movw	$1024, 97264(%rsp)
	movw	$1025, 97266(%rsp)
	movw	$1026, 97268(%rsp)
	movw	$1027, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$334:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$333:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$332:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$331:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$330:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$329:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	68544(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$328:
	movq	%r8, %rbx
	leaq	69568(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$327:
	movq	%r8, %r11
	leaq	70592(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$326:
	movq	%r8, %r10
	leaq	71616(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$325:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$318
	cmpq	$256, %r11
	jb  	.L__verify_internal$320
	cmpq	$256, %r10
	jb  	.L__verify_internal$322
	cmpq	$256, %r8
	jnb 	.L__verify_internal$304
	movl	$0, %edi
.L__verify_internal$324:
	jmp 	.L__verify_internal$304
.L__verify_internal$322:
	movl	$0, %edi
.L__verify_internal$323:
	jmp 	.L__verify_internal$304
.L__verify_internal$320:
	movl	$0, %edi
.L__verify_internal$321:
	jmp 	.L__verify_internal$304
.L__verify_internal$318:
	movl	$0, %edi
.L__verify_internal$319:
	jmp 	.L__verify_internal$304
.L__verify_internal$305:
	movq	%rbx, 97296(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%r10, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$317:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %r11
	movq	97280(%rsp), %r10
	movq	97272(%rsp), %r12
	leaq	68544(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$316:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	69568(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$315:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	70592(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$314:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	71616(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$313:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$306
	cmpq	$256, %r11
	jb  	.L__verify_internal$308
	cmpq	$256, %r10
	jb  	.L__verify_internal$310
	cmpq	$256, %r8
	jnb 	.L__verify_internal$304
	movl	$0, %edi
.L__verify_internal$312:
	jmp 	.L__verify_internal$304
.L__verify_internal$310:
	movl	$0, %edi
.L__verify_internal$311:
	jmp 	.L__verify_internal$304
.L__verify_internal$308:
	movl	$0, %edi
.L__verify_internal$309:
	jmp 	.L__verify_internal$304
.L__verify_internal$306:
	movl	$0, %edi
.L__verify_internal$307:
.L__verify_internal$304:
	cmpl	$1, %edi
	jne 	.L__verify_internal$305
	movw	$1028, 97264(%rsp)
	movw	$1029, 97266(%rsp)
	movw	$1030, 97268(%rsp)
	movw	$1280, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$303:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$302:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$301:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$300:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$299:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$298:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	72640(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$297:
	movq	%r8, %rbx
	leaq	73664(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$296:
	movq	%r8, %r11
	leaq	74688(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$295:
	movq	%r8, %r10
	leaq	75712(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$294:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$287
	cmpq	$256, %r11
	jb  	.L__verify_internal$289
	cmpq	$256, %r10
	jb  	.L__verify_internal$291
	cmpq	$256, %r8
	jnb 	.L__verify_internal$273
	movl	$0, %edi
.L__verify_internal$293:
	jmp 	.L__verify_internal$273
.L__verify_internal$291:
	movl	$0, %edi
.L__verify_internal$292:
	jmp 	.L__verify_internal$273
.L__verify_internal$289:
	movl	$0, %edi
.L__verify_internal$290:
	jmp 	.L__verify_internal$273
.L__verify_internal$287:
	movl	$0, %edi
.L__verify_internal$288:
	jmp 	.L__verify_internal$273
.L__verify_internal$274:
	movq	%rbx, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%r10, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$286:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %r10
	movq	97296(%rsp), %r12
	leaq	72640(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$285:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	73664(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$284:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	74688(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$283:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	75712(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$282:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$275
	cmpq	$256, %r11
	jb  	.L__verify_internal$277
	cmpq	$256, %r10
	jb  	.L__verify_internal$279
	cmpq	$256, %r8
	jnb 	.L__verify_internal$273
	movl	$0, %edi
.L__verify_internal$281:
	jmp 	.L__verify_internal$273
.L__verify_internal$279:
	movl	$0, %edi
.L__verify_internal$280:
	jmp 	.L__verify_internal$273
.L__verify_internal$277:
	movl	$0, %edi
.L__verify_internal$278:
	jmp 	.L__verify_internal$273
.L__verify_internal$275:
	movl	$0, %edi
.L__verify_internal$276:
.L__verify_internal$273:
	cmpl	$1, %edi
	jne 	.L__verify_internal$274
	movw	$1281, 97264(%rsp)
	movw	$1282, 97266(%rsp)
	movw	$1283, 97268(%rsp)
	movw	$1284, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$272:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$271:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$270:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$269:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$268:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$267:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	76736(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$266:
	movq	%r8, %rbx
	leaq	77760(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$265:
	movq	%r8, %r11
	leaq	78784(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$264:
	movq	%r8, %r10
	leaq	79808(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$263:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$256
	cmpq	$256, %r11
	jb  	.L__verify_internal$258
	cmpq	$256, %r10
	jb  	.L__verify_internal$260
	cmpq	$256, %r8
	jnb 	.L__verify_internal$242
	movl	$0, %edi
.L__verify_internal$262:
	jmp 	.L__verify_internal$242
.L__verify_internal$260:
	movl	$0, %edi
.L__verify_internal$261:
	jmp 	.L__verify_internal$242
.L__verify_internal$258:
	movl	$0, %edi
.L__verify_internal$259:
	jmp 	.L__verify_internal$242
.L__verify_internal$256:
	movl	$0, %edi
.L__verify_internal$257:
	jmp 	.L__verify_internal$242
.L__verify_internal$243:
	movq	%rbx, 97296(%rsp)
	movq	%r11, 97288(%rsp)
	movq	%r10, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$255:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %r11
	movq	97280(%rsp), %r10
	movq	97272(%rsp), %r12
	leaq	76736(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$254:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	77760(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$253:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	78784(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$252:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	79808(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$251:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__verify_internal$244
	cmpq	$256, %r11
	jb  	.L__verify_internal$246
	cmpq	$256, %r10
	jb  	.L__verify_internal$248
	cmpq	$256, %r8
	jnb 	.L__verify_internal$242
	movl	$0, %edi
.L__verify_internal$250:
	jmp 	.L__verify_internal$242
.L__verify_internal$248:
	movl	$0, %edi
.L__verify_internal$249:
	jmp 	.L__verify_internal$242
.L__verify_internal$246:
	movl	$0, %edi
.L__verify_internal$247:
	jmp 	.L__verify_internal$242
.L__verify_internal$244:
	movl	$0, %edi
.L__verify_internal$245:
.L__verify_internal$242:
	cmpl	$1, %edi
	jne 	.L__verify_internal$243
	movw	$1285, 97264(%rsp)
	movw	$1286, 97266(%rsp)
	movw	$1536, 97268(%rsp)
	movw	$1537, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$241:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$240:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$239:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$238:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$237:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$236:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	80832(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$235:
	movq	%r8, %r10
	leaq	81856(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$234:
	movq	%r8, %r11
	leaq	82880(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$233:
	movq	%r8, %rbx
	leaq	83904(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$232:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$225
	cmpq	$256, %r11
	jb  	.L__verify_internal$227
	cmpq	$256, %rbx
	jb  	.L__verify_internal$229
	cmpq	$256, %r8
	jnb 	.L__verify_internal$211
	movl	$0, %edi
.L__verify_internal$231:
	jmp 	.L__verify_internal$211
.L__verify_internal$229:
	movl	$0, %edi
.L__verify_internal$230:
	jmp 	.L__verify_internal$211
.L__verify_internal$227:
	movl	$0, %edi
.L__verify_internal$228:
	jmp 	.L__verify_internal$211
.L__verify_internal$225:
	movl	$0, %edi
.L__verify_internal$226:
	jmp 	.L__verify_internal$211
.L__verify_internal$212:
	movq	%r10, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$224:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97296(%rsp), %r12
	leaq	80832(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$223:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	81856(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$222:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	82880(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$221:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	83904(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$220:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$213
	cmpq	$256, %r11
	jb  	.L__verify_internal$215
	cmpq	$256, %rbx
	jb  	.L__verify_internal$217
	cmpq	$256, %r8
	jnb 	.L__verify_internal$211
	movl	$0, %edi
.L__verify_internal$219:
	jmp 	.L__verify_internal$211
.L__verify_internal$217:
	movl	$0, %edi
.L__verify_internal$218:
	jmp 	.L__verify_internal$211
.L__verify_internal$215:
	movl	$0, %edi
.L__verify_internal$216:
	jmp 	.L__verify_internal$211
.L__verify_internal$213:
	movl	$0, %edi
.L__verify_internal$214:
.L__verify_internal$211:
	cmpl	$1, %edi
	jne 	.L__verify_internal$212
	movw	$1538, 97264(%rsp)
	movw	$1539, 97266(%rsp)
	movw	$1540, 97268(%rsp)
	movw	$1541, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$210:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$209:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$208:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$207:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$206:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$205:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	84928(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$204:
	movq	%r8, %r10
	leaq	85952(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$203:
	movq	%r8, %rbx
	leaq	86976(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$202:
	movq	%r8, %r11
	leaq	88000(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$201:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$194
	cmpq	$256, %rbx
	jb  	.L__verify_internal$196
	cmpq	$256, %r11
	jb  	.L__verify_internal$198
	cmpq	$256, %r8
	jnb 	.L__verify_internal$180
	movl	$0, %edi
.L__verify_internal$200:
	jmp 	.L__verify_internal$180
.L__verify_internal$198:
	movl	$0, %edi
.L__verify_internal$199:
	jmp 	.L__verify_internal$180
.L__verify_internal$196:
	movl	$0, %edi
.L__verify_internal$197:
	jmp 	.L__verify_internal$180
.L__verify_internal$194:
	movl	$0, %edi
.L__verify_internal$195:
	jmp 	.L__verify_internal$180
.L__verify_internal$181:
	movq	%r10, 97296(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%r8, 97272(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$193:
	movq	97296(%rsp), %r8
	movq	97288(%rsp), %rbx
	movq	97280(%rsp), %r11
	movq	97272(%rsp), %r12
	leaq	84928(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$192:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	85952(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$191:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	86976(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$190:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	88000(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$189:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$182
	cmpq	$256, %rbx
	jb  	.L__verify_internal$184
	cmpq	$256, %r11
	jb  	.L__verify_internal$186
	cmpq	$256, %r8
	jnb 	.L__verify_internal$180
	movl	$0, %edi
.L__verify_internal$188:
	jmp 	.L__verify_internal$180
.L__verify_internal$186:
	movl	$0, %edi
.L__verify_internal$187:
	jmp 	.L__verify_internal$180
.L__verify_internal$184:
	movl	$0, %edi
.L__verify_internal$185:
	jmp 	.L__verify_internal$180
.L__verify_internal$182:
	movl	$0, %edi
.L__verify_internal$183:
.L__verify_internal$180:
	cmpl	$1, %edi
	jne 	.L__verify_internal$181
	movw	$1542, 97264(%rsp)
	movw	$1792, 97266(%rsp)
	movw	$1793, 97268(%rsp)
	movw	$1794, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$179:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$178:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$177:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$176:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$175:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$174:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	89024(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$173:
	movq	%r8, %r10
	leaq	90048(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$172:
	movq	%r8, %r11
	leaq	91072(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$171:
	movq	%r8, %rbx
	leaq	92096(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$170:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$163
	cmpq	$256, %r11
	jb  	.L__verify_internal$165
	cmpq	$256, %rbx
	jb  	.L__verify_internal$167
	cmpq	$256, %r8
	jnb 	.L__verify_internal$149
	movl	$0, %edi
.L__verify_internal$169:
	jmp 	.L__verify_internal$149
.L__verify_internal$167:
	movl	$0, %edi
.L__verify_internal$168:
	jmp 	.L__verify_internal$149
.L__verify_internal$165:
	movl	$0, %edi
.L__verify_internal$166:
	jmp 	.L__verify_internal$149
.L__verify_internal$163:
	movl	$0, %edi
.L__verify_internal$164:
	jmp 	.L__verify_internal$149
.L__verify_internal$150:
	movq	%r10, 97272(%rsp)
	movq	%r11, 97280(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97296(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$162:
	movq	97272(%rsp), %r8
	movq	97280(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97296(%rsp), %r12
	leaq	89024(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$161:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	90048(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$160:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	91072(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$159:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	92096(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$158:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$151
	cmpq	$256, %r11
	jb  	.L__verify_internal$153
	cmpq	$256, %rbx
	jb  	.L__verify_internal$155
	cmpq	$256, %r8
	jnb 	.L__verify_internal$149
	movl	$0, %edi
.L__verify_internal$157:
	jmp 	.L__verify_internal$149
.L__verify_internal$155:
	movl	$0, %edi
.L__verify_internal$156:
	jmp 	.L__verify_internal$149
.L__verify_internal$153:
	movl	$0, %edi
.L__verify_internal$154:
	jmp 	.L__verify_internal$149
.L__verify_internal$151:
	movl	$0, %edi
.L__verify_internal$152:
.L__verify_internal$149:
	cmpl	$1, %edi
	jne 	.L__verify_internal$150
	movw	$1795, 97264(%rsp)
	movw	$1796, 97266(%rsp)
	movw	$1797, 97268(%rsp)
	movw	$1798, 97270(%rsp)
	leaq	32(%rsp), %rsi
	leaq	800(%rsp), %rcx
	leaq	97264(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$148:
	leaq	40(%rsp), %rsp
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$147:
	leaq	800(%rsp), %rax
	leaq	4360(%rsp), %rcx
	leaq	3496(%rsp), %rdx
	leaq	2632(%rsp), %rsi
	leaq	1768(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$146:
	leaq	800(%rsp), %rax
	leaq	4528(%rsp), %rcx
	leaq	3664(%rsp), %rdx
	leaq	2800(%rsp), %rsi
	leaq	1936(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$145:
	leaq	800(%rsp), %rax
	leaq	4696(%rsp), %rcx
	leaq	3832(%rsp), %rdx
	leaq	2968(%rsp), %rsi
	leaq	2104(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$144:
	leaq	800(%rsp), %rax
	leaq	4864(%rsp), %rcx
	leaq	4000(%rsp), %rdx
	leaq	3136(%rsp), %rsi
	leaq	2272(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$143:
	movq	$0, %rax
	movq	%rax, 5032(%rsp)
	movq	%rax, 4168(%rsp)
	movq	%rax, 3304(%rsp)
	movq	%rax, 2440(%rsp)
	leaq	93120(%rsp), %rax
	leaq	4192(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$142:
	movq	%r8, %r10
	leaq	94144(%rsp), %rax
	leaq	3328(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$141:
	movq	%r8, %r11
	leaq	95168(%rsp), %rax
	leaq	2464(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$140:
	movq	%r8, %rbx
	leaq	96192(%rsp), %rax
	leaq	1600(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$139:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$132
	cmpq	$256, %r11
	jb  	.L__verify_internal$134
	cmpq	$256, %rbx
	jb  	.L__verify_internal$136
	cmpq	$256, %r8
	jnb 	.L__verify_internal$118
	movl	$0, %edi
.L__verify_internal$138:
	jmp 	.L__verify_internal$118
.L__verify_internal$136:
	movl	$0, %edi
.L__verify_internal$137:
	jmp 	.L__verify_internal$118
.L__verify_internal$134:
	movl	$0, %edi
.L__verify_internal$135:
	jmp 	.L__verify_internal$118
.L__verify_internal$132:
	movl	$0, %edi
.L__verify_internal$133:
	jmp 	.L__verify_internal$118
.L__verify_internal$119:
	movq	%r10, 97264(%rsp)
	movq	%r11, 97296(%rsp)
	movq	%rbx, 97288(%rsp)
	movq	%r8, 97280(%rsp)
	leaq	800(%rsp), %rax
	leaq	4192(%rsp), %rcx
	leaq	3328(%rsp), %rdx
	leaq	2464(%rsp), %rsi
	leaq	1600(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$131:
	movq	97264(%rsp), %r8
	movq	97296(%rsp), %r11
	movq	97288(%rsp), %rbx
	movq	97280(%rsp), %r12
	leaq	93120(%rsp), %rcx
	leaq	4192(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$130:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	94144(%rsp), %rcx
	leaq	3328(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$129:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	95168(%rsp), %rcx
	leaq	2464(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$128:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	96192(%rsp), %rcx
	leaq	1600(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$127:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__verify_internal$120
	cmpq	$256, %r11
	jb  	.L__verify_internal$122
	cmpq	$256, %rbx
	jb  	.L__verify_internal$124
	cmpq	$256, %r8
	jnb 	.L__verify_internal$118
	movl	$0, %edi
.L__verify_internal$126:
	jmp 	.L__verify_internal$118
.L__verify_internal$124:
	movl	$0, %edi
.L__verify_internal$125:
	jmp 	.L__verify_internal$118
.L__verify_internal$122:
	movl	$0, %edi
.L__verify_internal$123:
	jmp 	.L__verify_internal$118
.L__verify_internal$120:
	movl	$0, %edi
.L__verify_internal$121:
.L__verify_internal$118:
	cmpl	$1, %edi
	jne 	.L__verify_internal$119
	leaq	8128(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__verify_internal$117:
	leaq	39872(%rsp), %rax
	leaq	8128(%rsp), %rcx
	leaq	23488(%rsp), %rsi
	movq	%rax, %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$115
.L__verify_internal$116:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$115:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$116
	leaq	24512(%rsp), %rsi
	leaq	7168(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$113
.L__verify_internal$114:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$113:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$114
	leaq	25536(%rsp), %rsi
	leaq	14336(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$111
.L__verify_internal$112:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$111:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$112
	leaq	26560(%rsp), %rsi
	leaq	21504(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$109
.L__verify_internal$110:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$109:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$110
	leaq	27584(%rsp), %rsi
	leaq	28672(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$107
.L__verify_internal$108:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$107:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$108
	leaq	28608(%rsp), %rsi
	leaq	35840(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$105
.L__verify_internal$106:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$105:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$106
	leaq	29632(%rsp), %rsi
	leaq	43008(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$103
.L__verify_internal$104:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$103:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$104
	leaq	30656(%rsp), %rsi
	leaq	50176(%rax), %rdx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$101
.L__verify_internal$102:
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
	vmovdqu	5120(%rdx,%r8), %ymm4
	vmovdqu	5120(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdx,%r8), %ymm4
	vmovdqu	6144(%rcx,%r8), %ymm5
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
.L__verify_internal$101:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$102
	movq	97248(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	5056(%rsp), %rax
	movq	%r8, %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__verify_internal$99
.L__verify_internal$100:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__verify_internal$99:
	cmpq	$1024, %rsi
	jb  	.L__verify_internal$100
	movq	%rax, 97280(%rsp)
	leaq	576(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__verify_internal$98:
	leaq	576(%rsp), %rcx
	leaq	192(%rsp), %rdx
	call	.Lshake256_squeezeblock$1
.L__verify_internal$97:
	movq	97280(%rsp), %rcx
	movq	192(%rsp), %rdx
	movq	$8, %r8
	lfence
	movq	$0, %rdi
	movq	$196, %rsi
	jmp 	.L__verify_internal$90
.L__verify_internal$91:
	movq	$-1, %rax
	cmovnb	%rax, %rdi
	jmp 	.L__verify_internal$92
.L__verify_internal$93:
	movq	$-1, %rax
	cmovbe	%rax, %rdi
.L__verify_internal$92:
	cmpq	$136, %r8
	jnb 	.L__verify_internal$94
	movq	$-1, %rax
	cmovnb	%rax, %rdi
	jmp 	.L__verify_internal$95
.L__verify_internal$94:
	movq	%rsi, 97280(%rsp)
	movq	%rdx, 97288(%rsp)
	movq	%rcx, 97296(%rsp)
	leaq	576(%rsp), %rcx
	leaq	192(%rsp), %rdx
	call	.Lshake256_squeezeblock$1
.L__verify_internal$96:
	movq	97280(%rsp), %rsi
	movq	97288(%rsp), %rdx
	movq	97296(%rsp), %rcx
	movq	$0, %r8
	lfence
	movq	$0, %rdi
.L__verify_internal$95:
	movzbq	192(%rsp,%r8), %rax
// declassify_val u64 %rax
	orq 	%rdi, %rax
	incq	%r8
	cmpq	%rsi, %rax
	jnbe	.L__verify_internal$93
	movq	$-1, %r9
	cmovnbe	%r9, %rdi
	movl	(%rcx,%rax,4), %r9d
	movl	%r9d, (%rcx,%rsi,4)
	movl	%edx, %r9d
	andl	$1, %r9d
	shll	$1, %r9d
	movl	$1, %r10d
	subl	%r9d, %r10d
	movl	%r10d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__verify_internal$90:
	cmpq	$256, %rsi
	jb  	.L__verify_internal$91
	leaq	5056(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$89:
	movq	97256(%rsp), %rdi
	lfence
	movq	$0, %rax
	leaq	32(%rdi), %rax
	leaq	5056(%rsp), %rcx
	movq	%rcx, %mm0
	leaq	7104(%rsp), %r10
	movq	%rax, %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$88:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$86
.L__verify_internal$87:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$86:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$87
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$85:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$84:
	leaq	31680(%rsp), %rcx
	leaq	23488(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$83:
	leaq	31680(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$82:
	leaq	31680(%rsp), %r9
	leaq	15296(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$81:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	320(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$80:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$78
.L__verify_internal$79:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$78:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$79
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$77:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$76:
	leaq	32704(%rsp), %rcx
	leaq	24512(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$75:
	leaq	32704(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$74:
	leaq	32704(%rsp), %r9
	leaq	16320(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$73:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	640(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$72:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$70
.L__verify_internal$71:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$70:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$71
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$69:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$68:
	leaq	33728(%rsp), %rcx
	leaq	25536(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$67:
	leaq	33728(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$66:
	leaq	33728(%rsp), %r9
	leaq	17344(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$65:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	960(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$64:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$62
.L__verify_internal$63:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$62:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$63
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$61:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$60:
	leaq	34752(%rsp), %rcx
	leaq	26560(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$59:
	leaq	34752(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$58:
	leaq	34752(%rsp), %r9
	leaq	18368(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$57:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	1280(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$56:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$54
.L__verify_internal$55:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$54:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$55
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$53:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$52:
	leaq	35776(%rsp), %rcx
	leaq	27584(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$51:
	leaq	35776(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$50:
	leaq	35776(%rsp), %r9
	leaq	19392(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$49:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	1600(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$48:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$46
.L__verify_internal$47:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$46:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$47
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$45:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$44:
	leaq	36800(%rsp), %rcx
	leaq	28608(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$43:
	leaq	36800(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$42:
	leaq	36800(%rsp), %r9
	leaq	20416(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$41:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	1920(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$40:
	leaq	7104(%rsp), %rcx
	movq	$0, %r8
	jmp 	.L__verify_internal$38
.L__verify_internal$39:
	vmovdqu	(%rcx,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.L__verify_internal$38:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$39
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$37:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$36:
	leaq	37824(%rsp), %rcx
	leaq	29632(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$35:
	leaq	37824(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$34:
	leaq	37824(%rsp), %r9
	leaq	21440(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$33:
	leaq	2072(%rsp), %rsp
	leaq	7104(%rsp), %r10
	leaq	2240(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$32:
	leaq	7104(%rsp), %rax
	movq	$0, %r8
	jmp 	.L__verify_internal$30
.L__verify_internal$31:
	vmovdqu	(%rax,%r8), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__verify_internal$30:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$31
	leaq	7104(%rsp), %rsi
	call	.Lpolynomial__ntt$1
.L__verify_internal$29:
	movq	%mm0, %rcx
	leaq	6080(%rsp), %r10
	leaq	7104(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$28:
	leaq	38848(%rsp), %rcx
	leaq	30656(%rsp), %rdx
	leaq	6080(%rsp), %r10
	call	.Lpolynomial__subtract_to_intt_range$1
.L__verify_internal$27:
	leaq	38848(%rsp), %rsi
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$26:
	leaq	38848(%rsp), %r9
	leaq	22464(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_32$1
.L__verify_internal$25:
	leaq	2072(%rsp), %rsp
	leaq	31680(%rsp), %rax
	leaq	6080(%rsp), %rdx
	movq	%rax, %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$23
.L__verify_internal$24:
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
.L__verify_internal$23:
	cmpq	$128, %r8
	jb  	.L__verify_internal$24
	leaq	6208(%rsp), %rdx
	leaq	1024(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$21
.L__verify_internal$22:
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
.L__verify_internal$21:
	cmpq	$128, %r8
	jb  	.L__verify_internal$22
	leaq	6336(%rsp), %rdx
	leaq	2048(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$19
.L__verify_internal$20:
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
.L__verify_internal$19:
	cmpq	$128, %r8
	jb  	.L__verify_internal$20
	leaq	6464(%rsp), %rdx
	leaq	3072(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$17
.L__verify_internal$18:
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
.L__verify_internal$17:
	cmpq	$128, %r8
	jb  	.L__verify_internal$18
	leaq	6592(%rsp), %rdx
	leaq	4096(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$15
.L__verify_internal$16:
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
.L__verify_internal$15:
	cmpq	$128, %r8
	jb  	.L__verify_internal$16
	leaq	6720(%rsp), %rdx
	leaq	5120(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$13
.L__verify_internal$14:
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
.L__verify_internal$13:
	cmpq	$128, %r8
	jb  	.L__verify_internal$14
	leaq	6848(%rsp), %rdx
	leaq	6144(%rax), %rcx
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$11
.L__verify_internal$12:
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
.L__verify_internal$11:
	cmpq	$128, %r8
	jb  	.L__verify_internal$12
	leaq	6976(%rsp), %rdx
	leaq	7168(%rax), %rax
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm1
	movq	$0, %r9
	movq	$0, %r8
	jmp 	.L__verify_internal$9
.L__verify_internal$10:
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
.L__verify_internal$9:
	cmpq	$128, %r8
	jb  	.L__verify_internal$10
	movq	97216(%rsp), %rcx
	movq	97224(%rsp), %rdx
	movq	97232(%rsp), %rdi
	movq	97240(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	64(%rsp), %rax
	leaq	352(%rsp), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__verify_internal$8:
	leaq	344(%rsp), %rsp
	leaq	128(%rsp), %rax
	leaq	64(%rsp), %rcx
	leaq	6080(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__verify_internal$7:
	leaq	248(%rsp), %rsp
	movq	97248(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	128(%rsp), %rcx
	movq	$0, %r9
	vmovdqu	(%rcx,%r9), %xmm0
	vmovdqu	(%r8,%r9), %xmm1
	vpcmpeqb	%xmm1, %xmm0, %xmm0
	addq	$16, %r9
	jmp 	.L__verify_internal$5
.L__verify_internal$6:
	vmovdqu	(%rcx,%r9), %xmm1
	vmovdqu	(%r8,%r9), %xmm2
	vpcmpeqb	%xmm2, %xmm1, %xmm1
	vpand	%xmm1, %xmm0, %xmm0
	addq	$16, %r9
.L__verify_internal$5:
	cmpq	$64, %r9
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
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$670:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$669:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$668:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$667:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$666:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$665:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	112160(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$664:
	movq	%r8, %r10
	leaq	113184(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$663:
	movq	%r8, %r11
	leaq	114208(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$662:
	movq	%r8, %rbx
	leaq	115232(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$661:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$654
	cmpq	$256, %r11
	jb  	.L__sign_internal$656
	cmpq	$256, %rbx
	jb  	.L__sign_internal$658
	cmpq	$256, %r8
	jnb 	.L__sign_internal$640
	movl	$0, %edi
.L__sign_internal$660:
	jmp 	.L__sign_internal$640
.L__sign_internal$658:
	movl	$0, %edi
.L__sign_internal$659:
	jmp 	.L__sign_internal$640
.L__sign_internal$656:
	movl	$0, %edi
.L__sign_internal$657:
	jmp 	.L__sign_internal$640
.L__sign_internal$654:
	movl	$0, %edi
.L__sign_internal$655:
	jmp 	.L__sign_internal$640
.L__sign_internal$641:
	movq	%r10, 169584(%rsp)
	movq	%r11, 169592(%rsp)
	movq	%rbx, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$653:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %r11
	movq	169600(%rsp), %rbx
	movq	169608(%rsp), %r12
	leaq	112160(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$652:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	113184(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$651:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	114208(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$650:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	115232(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$649:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$642
	cmpq	$256, %r11
	jb  	.L__sign_internal$644
	cmpq	$256, %rbx
	jb  	.L__sign_internal$646
	cmpq	$256, %r8
	jnb 	.L__sign_internal$640
	movl	$0, %edi
.L__sign_internal$648:
	jmp 	.L__sign_internal$640
.L__sign_internal$646:
	movl	$0, %edi
.L__sign_internal$647:
	jmp 	.L__sign_internal$640
.L__sign_internal$644:
	movl	$0, %edi
.L__sign_internal$645:
	jmp 	.L__sign_internal$640
.L__sign_internal$642:
	movl	$0, %edi
.L__sign_internal$643:
.L__sign_internal$640:
	cmpl	$1, %edi
	jne 	.L__sign_internal$641
	movw	$4, 169576(%rsp)
	movw	$5, 169578(%rsp)
	movw	$6, 169580(%rsp)
	movw	$256, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$639:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$638:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$637:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$636:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$635:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$634:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	116256(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$633:
	movq	%r8, %r11
	leaq	117280(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$632:
	movq	%r8, %rbx
	leaq	118304(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$631:
	movq	%r8, %r10
	leaq	119328(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$630:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$623
	cmpq	$256, %rbx
	jb  	.L__sign_internal$625
	cmpq	$256, %r10
	jb  	.L__sign_internal$627
	cmpq	$256, %r8
	jnb 	.L__sign_internal$609
	movl	$0, %edi
.L__sign_internal$629:
	jmp 	.L__sign_internal$609
.L__sign_internal$627:
	movl	$0, %edi
.L__sign_internal$628:
	jmp 	.L__sign_internal$609
.L__sign_internal$625:
	movl	$0, %edi
.L__sign_internal$626:
	jmp 	.L__sign_internal$609
.L__sign_internal$623:
	movl	$0, %edi
.L__sign_internal$624:
	jmp 	.L__sign_internal$609
.L__sign_internal$610:
	movq	%r11, 169608(%rsp)
	movq	%rbx, 169600(%rsp)
	movq	%r10, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$622:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %rbx
	movq	169592(%rsp), %r10
	movq	169584(%rsp), %r12
	leaq	116256(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$621:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	117280(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$620:
	movq	%r8, %rbx
	movq	%r10, %r8
	leaq	118304(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$619:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	119328(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$618:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$611
	cmpq	$256, %rbx
	jb  	.L__sign_internal$613
	cmpq	$256, %r10
	jb  	.L__sign_internal$615
	cmpq	$256, %r8
	jnb 	.L__sign_internal$609
	movl	$0, %edi
.L__sign_internal$617:
	jmp 	.L__sign_internal$609
.L__sign_internal$615:
	movl	$0, %edi
.L__sign_internal$616:
	jmp 	.L__sign_internal$609
.L__sign_internal$613:
	movl	$0, %edi
.L__sign_internal$614:
	jmp 	.L__sign_internal$609
.L__sign_internal$611:
	movl	$0, %edi
.L__sign_internal$612:
.L__sign_internal$609:
	cmpl	$1, %edi
	jne 	.L__sign_internal$610
	movw	$257, 169576(%rsp)
	movw	$258, 169578(%rsp)
	movw	$259, 169580(%rsp)
	movw	$260, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$608:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$607:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$606:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$605:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$604:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$603:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	120352(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$602:
	movq	%r8, %rbx
	leaq	121376(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$601:
	movq	%r8, %r11
	leaq	122400(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$600:
	movq	%r8, %r10
	leaq	123424(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$599:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$592
	cmpq	$256, %r11
	jb  	.L__sign_internal$594
	cmpq	$256, %r10
	jb  	.L__sign_internal$596
	cmpq	$256, %r8
	jnb 	.L__sign_internal$578
	movl	$0, %edi
.L__sign_internal$598:
	jmp 	.L__sign_internal$578
.L__sign_internal$596:
	movl	$0, %edi
.L__sign_internal$597:
	jmp 	.L__sign_internal$578
.L__sign_internal$594:
	movl	$0, %edi
.L__sign_internal$595:
	jmp 	.L__sign_internal$578
.L__sign_internal$592:
	movl	$0, %edi
.L__sign_internal$593:
	jmp 	.L__sign_internal$578
.L__sign_internal$579:
	movq	%rbx, 169584(%rsp)
	movq	%r11, 169592(%rsp)
	movq	%r10, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$591:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %r11
	movq	169600(%rsp), %r10
	movq	169608(%rsp), %r12
	leaq	120352(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$590:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	121376(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$589:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	122400(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$588:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	123424(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$587:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$580
	cmpq	$256, %r11
	jb  	.L__sign_internal$582
	cmpq	$256, %r10
	jb  	.L__sign_internal$584
	cmpq	$256, %r8
	jnb 	.L__sign_internal$578
	movl	$0, %edi
.L__sign_internal$586:
	jmp 	.L__sign_internal$578
.L__sign_internal$584:
	movl	$0, %edi
.L__sign_internal$585:
	jmp 	.L__sign_internal$578
.L__sign_internal$582:
	movl	$0, %edi
.L__sign_internal$583:
	jmp 	.L__sign_internal$578
.L__sign_internal$580:
	movl	$0, %edi
.L__sign_internal$581:
.L__sign_internal$578:
	cmpl	$1, %edi
	jne 	.L__sign_internal$579
	movw	$261, 169576(%rsp)
	movw	$262, 169578(%rsp)
	movw	$512, 169580(%rsp)
	movw	$513, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$577:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$576:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$575:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$574:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$573:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$572:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	124448(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$571:
	movq	%r8, %rbx
	leaq	125472(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$570:
	movq	%r8, %r11
	leaq	126496(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$569:
	movq	%r8, %r10
	leaq	127520(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$568:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$561
	cmpq	$256, %r11
	jb  	.L__sign_internal$563
	cmpq	$256, %r10
	jb  	.L__sign_internal$565
	cmpq	$256, %r8
	jnb 	.L__sign_internal$547
	movl	$0, %edi
.L__sign_internal$567:
	jmp 	.L__sign_internal$547
.L__sign_internal$565:
	movl	$0, %edi
.L__sign_internal$566:
	jmp 	.L__sign_internal$547
.L__sign_internal$563:
	movl	$0, %edi
.L__sign_internal$564:
	jmp 	.L__sign_internal$547
.L__sign_internal$561:
	movl	$0, %edi
.L__sign_internal$562:
	jmp 	.L__sign_internal$547
.L__sign_internal$548:
	movq	%rbx, 169608(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r10, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$560:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %r11
	movq	169592(%rsp), %r10
	movq	169584(%rsp), %r12
	leaq	124448(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$559:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	125472(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$558:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	126496(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$557:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	127520(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$556:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$549
	cmpq	$256, %r11
	jb  	.L__sign_internal$551
	cmpq	$256, %r10
	jb  	.L__sign_internal$553
	cmpq	$256, %r8
	jnb 	.L__sign_internal$547
	movl	$0, %edi
.L__sign_internal$555:
	jmp 	.L__sign_internal$547
.L__sign_internal$553:
	movl	$0, %edi
.L__sign_internal$554:
	jmp 	.L__sign_internal$547
.L__sign_internal$551:
	movl	$0, %edi
.L__sign_internal$552:
	jmp 	.L__sign_internal$547
.L__sign_internal$549:
	movl	$0, %edi
.L__sign_internal$550:
.L__sign_internal$547:
	cmpl	$1, %edi
	jne 	.L__sign_internal$548
	movw	$514, 169576(%rsp)
	movw	$515, 169578(%rsp)
	movw	$516, 169580(%rsp)
	movw	$517, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$546:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$545:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$544:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$543:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$542:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$541:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	128544(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$540:
	movq	%r8, %r11
	leaq	129568(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$539:
	movq	%r8, %rbx
	leaq	130592(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$538:
	movq	%r8, %r10
	leaq	131616(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$537:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$530
	cmpq	$256, %rbx
	jb  	.L__sign_internal$532
	cmpq	$256, %r10
	jb  	.L__sign_internal$534
	cmpq	$256, %r8
	jnb 	.L__sign_internal$516
	movl	$0, %edi
.L__sign_internal$536:
	jmp 	.L__sign_internal$516
.L__sign_internal$534:
	movl	$0, %edi
.L__sign_internal$535:
	jmp 	.L__sign_internal$516
.L__sign_internal$532:
	movl	$0, %edi
.L__sign_internal$533:
	jmp 	.L__sign_internal$516
.L__sign_internal$530:
	movl	$0, %edi
.L__sign_internal$531:
	jmp 	.L__sign_internal$516
.L__sign_internal$517:
	movq	%r11, 169584(%rsp)
	movq	%rbx, 169592(%rsp)
	movq	%r10, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$529:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %rbx
	movq	169600(%rsp), %r10
	movq	169608(%rsp), %r12
	leaq	128544(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$528:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	129568(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$527:
	movq	%r8, %rbx
	movq	%r10, %r8
	leaq	130592(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$526:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	131616(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$525:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$518
	cmpq	$256, %rbx
	jb  	.L__sign_internal$520
	cmpq	$256, %r10
	jb  	.L__sign_internal$522
	cmpq	$256, %r8
	jnb 	.L__sign_internal$516
	movl	$0, %edi
.L__sign_internal$524:
	jmp 	.L__sign_internal$516
.L__sign_internal$522:
	movl	$0, %edi
.L__sign_internal$523:
	jmp 	.L__sign_internal$516
.L__sign_internal$520:
	movl	$0, %edi
.L__sign_internal$521:
	jmp 	.L__sign_internal$516
.L__sign_internal$518:
	movl	$0, %edi
.L__sign_internal$519:
.L__sign_internal$516:
	cmpl	$1, %edi
	jne 	.L__sign_internal$517
	movw	$518, 169576(%rsp)
	movw	$768, 169578(%rsp)
	movw	$769, 169580(%rsp)
	movw	$770, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$515:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$514:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$513:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$512:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$511:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$510:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	132640(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$509:
	movq	%r8, %rbx
	leaq	133664(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$508:
	movq	%r8, %r11
	leaq	134688(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$507:
	movq	%r8, %r10
	leaq	135712(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$506:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$499
	cmpq	$256, %r11
	jb  	.L__sign_internal$501
	cmpq	$256, %r10
	jb  	.L__sign_internal$503
	cmpq	$256, %r8
	jnb 	.L__sign_internal$485
	movl	$0, %edi
.L__sign_internal$505:
	jmp 	.L__sign_internal$485
.L__sign_internal$503:
	movl	$0, %edi
.L__sign_internal$504:
	jmp 	.L__sign_internal$485
.L__sign_internal$501:
	movl	$0, %edi
.L__sign_internal$502:
	jmp 	.L__sign_internal$485
.L__sign_internal$499:
	movl	$0, %edi
.L__sign_internal$500:
	jmp 	.L__sign_internal$485
.L__sign_internal$486:
	movq	%rbx, 169608(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r10, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$498:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %r11
	movq	169592(%rsp), %r10
	movq	169584(%rsp), %r12
	leaq	132640(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$497:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	133664(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$496:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	134688(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$495:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	135712(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$494:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$487
	cmpq	$256, %r11
	jb  	.L__sign_internal$489
	cmpq	$256, %r10
	jb  	.L__sign_internal$491
	cmpq	$256, %r8
	jnb 	.L__sign_internal$485
	movl	$0, %edi
.L__sign_internal$493:
	jmp 	.L__sign_internal$485
.L__sign_internal$491:
	movl	$0, %edi
.L__sign_internal$492:
	jmp 	.L__sign_internal$485
.L__sign_internal$489:
	movl	$0, %edi
.L__sign_internal$490:
	jmp 	.L__sign_internal$485
.L__sign_internal$487:
	movl	$0, %edi
.L__sign_internal$488:
.L__sign_internal$485:
	cmpl	$1, %edi
	jne 	.L__sign_internal$486
	movw	$771, 169576(%rsp)
	movw	$772, 169578(%rsp)
	movw	$773, 169580(%rsp)
	movw	$774, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$484:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$483:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$482:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$481:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$480:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$479:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	136736(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$478:
	movq	%r8, %r10
	leaq	137760(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$477:
	movq	%r8, %rbx
	leaq	138784(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$476:
	movq	%r8, %r11
	leaq	139808(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$475:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$468
	cmpq	$256, %rbx
	jb  	.L__sign_internal$470
	cmpq	$256, %r11
	jb  	.L__sign_internal$472
	cmpq	$256, %r8
	jnb 	.L__sign_internal$454
	movl	$0, %edi
.L__sign_internal$474:
	jmp 	.L__sign_internal$454
.L__sign_internal$472:
	movl	$0, %edi
.L__sign_internal$473:
	jmp 	.L__sign_internal$454
.L__sign_internal$470:
	movl	$0, %edi
.L__sign_internal$471:
	jmp 	.L__sign_internal$454
.L__sign_internal$468:
	movl	$0, %edi
.L__sign_internal$469:
	jmp 	.L__sign_internal$454
.L__sign_internal$455:
	movq	%r10, 169584(%rsp)
	movq	%rbx, 169592(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$467:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %rbx
	movq	169600(%rsp), %r11
	movq	169608(%rsp), %r12
	leaq	136736(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$466:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	137760(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$465:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	138784(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$464:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	139808(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$463:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$456
	cmpq	$256, %rbx
	jb  	.L__sign_internal$458
	cmpq	$256, %r11
	jb  	.L__sign_internal$460
	cmpq	$256, %r8
	jnb 	.L__sign_internal$454
	movl	$0, %edi
.L__sign_internal$462:
	jmp 	.L__sign_internal$454
.L__sign_internal$460:
	movl	$0, %edi
.L__sign_internal$461:
	jmp 	.L__sign_internal$454
.L__sign_internal$458:
	movl	$0, %edi
.L__sign_internal$459:
	jmp 	.L__sign_internal$454
.L__sign_internal$456:
	movl	$0, %edi
.L__sign_internal$457:
.L__sign_internal$454:
	cmpl	$1, %edi
	jne 	.L__sign_internal$455
	movw	$1024, 169576(%rsp)
	movw	$1025, 169578(%rsp)
	movw	$1026, 169580(%rsp)
	movw	$1027, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$453:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$452:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$451:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$450:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$449:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$448:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	140832(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$447:
	movq	%r8, %r10
	leaq	141856(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$446:
	movq	%r8, %r11
	leaq	142880(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$445:
	movq	%r8, %rbx
	leaq	143904(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$444:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$437
	cmpq	$256, %r11
	jb  	.L__sign_internal$439
	cmpq	$256, %rbx
	jb  	.L__sign_internal$441
	cmpq	$256, %r8
	jnb 	.L__sign_internal$423
	movl	$0, %edi
.L__sign_internal$443:
	jmp 	.L__sign_internal$423
.L__sign_internal$441:
	movl	$0, %edi
.L__sign_internal$442:
	jmp 	.L__sign_internal$423
.L__sign_internal$439:
	movl	$0, %edi
.L__sign_internal$440:
	jmp 	.L__sign_internal$423
.L__sign_internal$437:
	movl	$0, %edi
.L__sign_internal$438:
	jmp 	.L__sign_internal$423
.L__sign_internal$424:
	movq	%r10, 169608(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%rbx, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$436:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %r11
	movq	169592(%rsp), %rbx
	movq	169584(%rsp), %r12
	leaq	140832(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$435:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	141856(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$434:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	142880(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$433:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	143904(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$432:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$425
	cmpq	$256, %r11
	jb  	.L__sign_internal$427
	cmpq	$256, %rbx
	jb  	.L__sign_internal$429
	cmpq	$256, %r8
	jnb 	.L__sign_internal$423
	movl	$0, %edi
.L__sign_internal$431:
	jmp 	.L__sign_internal$423
.L__sign_internal$429:
	movl	$0, %edi
.L__sign_internal$430:
	jmp 	.L__sign_internal$423
.L__sign_internal$427:
	movl	$0, %edi
.L__sign_internal$428:
	jmp 	.L__sign_internal$423
.L__sign_internal$425:
	movl	$0, %edi
.L__sign_internal$426:
.L__sign_internal$423:
	cmpl	$1, %edi
	jne 	.L__sign_internal$424
	movw	$1028, 169576(%rsp)
	movw	$1029, 169578(%rsp)
	movw	$1030, 169580(%rsp)
	movw	$1280, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$422:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$421:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$420:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$419:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$418:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$417:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	144928(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$416:
	movq	%r8, %r10
	leaq	145952(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$415:
	movq	%r8, %rbx
	leaq	146976(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$414:
	movq	%r8, %r11
	leaq	148000(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$413:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$406
	cmpq	$256, %rbx
	jb  	.L__sign_internal$408
	cmpq	$256, %r11
	jb  	.L__sign_internal$410
	cmpq	$256, %r8
	jnb 	.L__sign_internal$392
	movl	$0, %edi
.L__sign_internal$412:
	jmp 	.L__sign_internal$392
.L__sign_internal$410:
	movl	$0, %edi
.L__sign_internal$411:
	jmp 	.L__sign_internal$392
.L__sign_internal$408:
	movl	$0, %edi
.L__sign_internal$409:
	jmp 	.L__sign_internal$392
.L__sign_internal$406:
	movl	$0, %edi
.L__sign_internal$407:
	jmp 	.L__sign_internal$392
.L__sign_internal$393:
	movq	%r10, 169584(%rsp)
	movq	%rbx, 169592(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$405:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %rbx
	movq	169600(%rsp), %r11
	movq	169608(%rsp), %r12
	leaq	144928(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$404:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	145952(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$403:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	146976(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$402:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	148000(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$401:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$394
	cmpq	$256, %rbx
	jb  	.L__sign_internal$396
	cmpq	$256, %r11
	jb  	.L__sign_internal$398
	cmpq	$256, %r8
	jnb 	.L__sign_internal$392
	movl	$0, %edi
.L__sign_internal$400:
	jmp 	.L__sign_internal$392
.L__sign_internal$398:
	movl	$0, %edi
.L__sign_internal$399:
	jmp 	.L__sign_internal$392
.L__sign_internal$396:
	movl	$0, %edi
.L__sign_internal$397:
	jmp 	.L__sign_internal$392
.L__sign_internal$394:
	movl	$0, %edi
.L__sign_internal$395:
.L__sign_internal$392:
	cmpl	$1, %edi
	jne 	.L__sign_internal$393
	movw	$1281, 169576(%rsp)
	movw	$1282, 169578(%rsp)
	movw	$1283, 169580(%rsp)
	movw	$1284, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$391:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$390:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$389:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$388:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$387:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$386:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	149024(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$385:
	movq	%r8, %rbx
	leaq	150048(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$384:
	movq	%r8, %r11
	leaq	151072(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$383:
	movq	%r8, %r10
	leaq	152096(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$382:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$375
	cmpq	$256, %r11
	jb  	.L__sign_internal$377
	cmpq	$256, %r10
	jb  	.L__sign_internal$379
	cmpq	$256, %r8
	jnb 	.L__sign_internal$361
	movl	$0, %edi
.L__sign_internal$381:
	jmp 	.L__sign_internal$361
.L__sign_internal$379:
	movl	$0, %edi
.L__sign_internal$380:
	jmp 	.L__sign_internal$361
.L__sign_internal$377:
	movl	$0, %edi
.L__sign_internal$378:
	jmp 	.L__sign_internal$361
.L__sign_internal$375:
	movl	$0, %edi
.L__sign_internal$376:
	jmp 	.L__sign_internal$361
.L__sign_internal$362:
	movq	%rbx, 169608(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r10, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$374:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %r11
	movq	169592(%rsp), %r10
	movq	169584(%rsp), %r12
	leaq	149024(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$373:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	150048(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$372:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	151072(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$371:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	152096(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$370:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__sign_internal$363
	cmpq	$256, %r11
	jb  	.L__sign_internal$365
	cmpq	$256, %r10
	jb  	.L__sign_internal$367
	cmpq	$256, %r8
	jnb 	.L__sign_internal$361
	movl	$0, %edi
.L__sign_internal$369:
	jmp 	.L__sign_internal$361
.L__sign_internal$367:
	movl	$0, %edi
.L__sign_internal$368:
	jmp 	.L__sign_internal$361
.L__sign_internal$365:
	movl	$0, %edi
.L__sign_internal$366:
	jmp 	.L__sign_internal$361
.L__sign_internal$363:
	movl	$0, %edi
.L__sign_internal$364:
.L__sign_internal$361:
	cmpl	$1, %edi
	jne 	.L__sign_internal$362
	movw	$1285, 169576(%rsp)
	movw	$1286, 169578(%rsp)
	movw	$1536, 169580(%rsp)
	movw	$1537, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$360:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$359:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$358:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$357:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$356:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$355:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	153120(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$354:
	movq	%r8, %r10
	leaq	154144(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$353:
	movq	%r8, %r11
	leaq	155168(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$352:
	movq	%r8, %rbx
	leaq	156192(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$351:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$344
	cmpq	$256, %r11
	jb  	.L__sign_internal$346
	cmpq	$256, %rbx
	jb  	.L__sign_internal$348
	cmpq	$256, %r8
	jnb 	.L__sign_internal$330
	movl	$0, %edi
.L__sign_internal$350:
	jmp 	.L__sign_internal$330
.L__sign_internal$348:
	movl	$0, %edi
.L__sign_internal$349:
	jmp 	.L__sign_internal$330
.L__sign_internal$346:
	movl	$0, %edi
.L__sign_internal$347:
	jmp 	.L__sign_internal$330
.L__sign_internal$344:
	movl	$0, %edi
.L__sign_internal$345:
	jmp 	.L__sign_internal$330
.L__sign_internal$331:
	movq	%r10, 169584(%rsp)
	movq	%r11, 169592(%rsp)
	movq	%rbx, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$343:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %r11
	movq	169600(%rsp), %rbx
	movq	169608(%rsp), %r12
	leaq	153120(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$342:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	154144(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$341:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	155168(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$340:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	156192(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$339:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$332
	cmpq	$256, %r11
	jb  	.L__sign_internal$334
	cmpq	$256, %rbx
	jb  	.L__sign_internal$336
	cmpq	$256, %r8
	jnb 	.L__sign_internal$330
	movl	$0, %edi
.L__sign_internal$338:
	jmp 	.L__sign_internal$330
.L__sign_internal$336:
	movl	$0, %edi
.L__sign_internal$337:
	jmp 	.L__sign_internal$330
.L__sign_internal$334:
	movl	$0, %edi
.L__sign_internal$335:
	jmp 	.L__sign_internal$330
.L__sign_internal$332:
	movl	$0, %edi
.L__sign_internal$333:
.L__sign_internal$330:
	cmpl	$1, %edi
	jne 	.L__sign_internal$331
	movw	$1538, 169576(%rsp)
	movw	$1539, 169578(%rsp)
	movw	$1540, 169580(%rsp)
	movw	$1541, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$329:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$328:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$327:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$326:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$325:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$324:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	157216(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$323:
	movq	%r8, %r11
	leaq	158240(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$322:
	movq	%r8, %rbx
	leaq	159264(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$321:
	movq	%r8, %r10
	leaq	160288(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$320:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$313
	cmpq	$256, %rbx
	jb  	.L__sign_internal$315
	cmpq	$256, %r10
	jb  	.L__sign_internal$317
	cmpq	$256, %r8
	jnb 	.L__sign_internal$299
	movl	$0, %edi
.L__sign_internal$319:
	jmp 	.L__sign_internal$299
.L__sign_internal$317:
	movl	$0, %edi
.L__sign_internal$318:
	jmp 	.L__sign_internal$299
.L__sign_internal$315:
	movl	$0, %edi
.L__sign_internal$316:
	jmp 	.L__sign_internal$299
.L__sign_internal$313:
	movl	$0, %edi
.L__sign_internal$314:
	jmp 	.L__sign_internal$299
.L__sign_internal$300:
	movq	%r11, 169608(%rsp)
	movq	%rbx, 169600(%rsp)
	movq	%r10, 169592(%rsp)
	movq	%r8, 169584(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$312:
	movq	169608(%rsp), %r8
	movq	169600(%rsp), %rbx
	movq	169592(%rsp), %r10
	movq	169584(%rsp), %r12
	leaq	157216(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$311:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	158240(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$310:
	movq	%r8, %rbx
	movq	%r10, %r8
	leaq	159264(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$309:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	160288(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$308:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__sign_internal$301
	cmpq	$256, %rbx
	jb  	.L__sign_internal$303
	cmpq	$256, %r10
	jb  	.L__sign_internal$305
	cmpq	$256, %r8
	jnb 	.L__sign_internal$299
	movl	$0, %edi
.L__sign_internal$307:
	jmp 	.L__sign_internal$299
.L__sign_internal$305:
	movl	$0, %edi
.L__sign_internal$306:
	jmp 	.L__sign_internal$299
.L__sign_internal$303:
	movl	$0, %edi
.L__sign_internal$304:
	jmp 	.L__sign_internal$299
.L__sign_internal$301:
	movl	$0, %edi
.L__sign_internal$302:
.L__sign_internal$299:
	cmpl	$1, %edi
	jne 	.L__sign_internal$300
	movw	$1542, 169576(%rsp)
	movw	$1792, 169578(%rsp)
	movw	$1793, 169580(%rsp)
	movw	$1794, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$298:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$297:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$296:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$295:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$294:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$293:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	161312(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$292:
	movq	%r8, %r10
	leaq	162336(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$291:
	movq	%r8, %rbx
	leaq	163360(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$290:
	movq	%r8, %r11
	leaq	164384(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$289:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$282
	cmpq	$256, %rbx
	jb  	.L__sign_internal$284
	cmpq	$256, %r11
	jb  	.L__sign_internal$286
	cmpq	$256, %r8
	jnb 	.L__sign_internal$268
	movl	$0, %edi
.L__sign_internal$288:
	jmp 	.L__sign_internal$268
.L__sign_internal$286:
	movl	$0, %edi
.L__sign_internal$287:
	jmp 	.L__sign_internal$268
.L__sign_internal$284:
	movl	$0, %edi
.L__sign_internal$285:
	jmp 	.L__sign_internal$268
.L__sign_internal$282:
	movl	$0, %edi
.L__sign_internal$283:
	jmp 	.L__sign_internal$268
.L__sign_internal$269:
	movq	%r10, 169584(%rsp)
	movq	%rbx, 169592(%rsp)
	movq	%r11, 169600(%rsp)
	movq	%r8, 169608(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$281:
	movq	169584(%rsp), %r8
	movq	169592(%rsp), %rbx
	movq	169600(%rsp), %r11
	movq	169608(%rsp), %r12
	leaq	161312(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$280:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	162336(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$279:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	163360(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$278:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	164384(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$277:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$270
	cmpq	$256, %rbx
	jb  	.L__sign_internal$272
	cmpq	$256, %r11
	jb  	.L__sign_internal$274
	cmpq	$256, %r8
	jnb 	.L__sign_internal$268
	movl	$0, %edi
.L__sign_internal$276:
	jmp 	.L__sign_internal$268
.L__sign_internal$274:
	movl	$0, %edi
.L__sign_internal$275:
	jmp 	.L__sign_internal$268
.L__sign_internal$272:
	movl	$0, %edi
.L__sign_internal$273:
	jmp 	.L__sign_internal$268
.L__sign_internal$270:
	movl	$0, %edi
.L__sign_internal$271:
.L__sign_internal$268:
	cmpl	$1, %edi
	jne 	.L__sign_internal$269
	movw	$1795, 169576(%rsp)
	movw	$1796, 169578(%rsp)
	movw	$1797, 169580(%rsp)
	movw	$1798, 169582(%rsp)
	leaq	32(%rsp), %rsi
	leaq	3456(%rsp), %rcx
	leaq	169576(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$267:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$266:
	leaq	3456(%rsp), %rax
	leaq	7016(%rsp), %rcx
	leaq	6152(%rsp), %rdx
	leaq	5288(%rsp), %rsi
	leaq	4424(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$265:
	leaq	3456(%rsp), %rax
	leaq	7184(%rsp), %rcx
	leaq	6320(%rsp), %rdx
	leaq	5456(%rsp), %rsi
	leaq	4592(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$264:
	leaq	3456(%rsp), %rax
	leaq	7352(%rsp), %rcx
	leaq	6488(%rsp), %rdx
	leaq	5624(%rsp), %rsi
	leaq	4760(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$263:
	leaq	3456(%rsp), %rax
	leaq	7520(%rsp), %rcx
	leaq	6656(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$262:
	movq	$0, %rax
	movq	%rax, 7688(%rsp)
	movq	%rax, 6824(%rsp)
	movq	%rax, 5960(%rsp)
	movq	%rax, 5096(%rsp)
	leaq	165408(%rsp), %rax
	leaq	6848(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$261:
	movq	%r8, %r10
	leaq	166432(%rsp), %rax
	leaq	5984(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$260:
	movq	%r8, %r11
	leaq	167456(%rsp), %rax
	leaq	5120(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$259:
	movq	%r8, %rbx
	leaq	168480(%rsp), %rax
	leaq	4256(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$258:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$251
	cmpq	$256, %r11
	jb  	.L__sign_internal$253
	cmpq	$256, %rbx
	jb  	.L__sign_internal$255
	cmpq	$256, %r8
	jnb 	.L__sign_internal$237
	movl	$0, %edi
.L__sign_internal$257:
	jmp 	.L__sign_internal$237
.L__sign_internal$255:
	movl	$0, %edi
.L__sign_internal$256:
	jmp 	.L__sign_internal$237
.L__sign_internal$253:
	movl	$0, %edi
.L__sign_internal$254:
	jmp 	.L__sign_internal$237
.L__sign_internal$251:
	movl	$0, %edi
.L__sign_internal$252:
	jmp 	.L__sign_internal$237
.L__sign_internal$238:
	movq	%r10, 169576(%rsp)
	movq	%r11, 169608(%rsp)
	movq	%rbx, 169600(%rsp)
	movq	%r8, 169592(%rsp)
	leaq	3456(%rsp), %rax
	leaq	6848(%rsp), %rcx
	leaq	5984(%rsp), %rdx
	leaq	5120(%rsp), %rsi
	leaq	4256(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$250:
	movq	169576(%rsp), %r8
	movq	169608(%rsp), %r11
	movq	169600(%rsp), %rbx
	movq	169592(%rsp), %r12
	leaq	165408(%rsp), %rcx
	leaq	6848(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$249:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	166432(%rsp), %rcx
	leaq	5984(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$248:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	167456(%rsp), %rcx
	leaq	5120(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$247:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	168480(%rsp), %rcx
	leaq	4256(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$246:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__sign_internal$239
	cmpq	$256, %r11
	jb  	.L__sign_internal$241
	cmpq	$256, %rbx
	jb  	.L__sign_internal$243
	cmpq	$256, %r8
	jnb 	.L__sign_internal$237
	movl	$0, %edi
.L__sign_internal$245:
	jmp 	.L__sign_internal$237
.L__sign_internal$243:
	movl	$0, %edi
.L__sign_internal$244:
	jmp 	.L__sign_internal$237
.L__sign_internal$241:
	movl	$0, %edi
.L__sign_internal$242:
	jmp 	.L__sign_internal$237
.L__sign_internal$239:
	movl	$0, %edi
.L__sign_internal$240:
.L__sign_internal$237:
	cmpl	$1, %edi
	jne 	.L__sign_internal$238
	movq	169536(%rsp), %rsi
	movq	169544(%rsp), %rcx
	movq	169552(%rsp), %rdx
	movq	169560(%rsp), %rdi
	movq	169568(%rsp), %r8
	lfence
	movq	$0, %r11
	orq 	%r11, %rsi
	movq	%rsi, 169568(%rsp)
	leaq	64(%rsp), %rax
	leaq	64(%rsi), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__sign_internal$236:
	leaq	344(%rsp), %rsp
	movq	169528(%rsp), %rdx
	movq	169568(%rsp), %rsi
	lfence
	movq	$0, %rdi
	orq 	%rdi, %rdx
	orq 	%rdi, %rsi
	movq	%rsi, 169568(%rsp)
	leaq	32(%rsi), %rax
	leaq	64(%rsp), %rcx
	leaq	128(%rsp), %rdi
	leaq	-152(%rsp), %rsp
	call	.Lderive_seed_for_mask$1
.L__sign_internal$235:
	leaq	152(%rsp), %rsp
	movq	169568(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rsi
	leaq	9760(%rsp), %rcx
	leaq	128(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rcx, %rax
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$234:
	movq	%mm0, %rdx
	leaq	1024(%rcx), %rax
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$233:
	movq	%mm0, %rdx
	leaq	2048(%rcx), %rax
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$232:
	movq	%mm0, %rdx
	leaq	3072(%rcx), %rax
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$231:
	movq	%mm0, %rdx
	leaq	4096(%rcx), %rax
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$230:
	movq	%mm0, %rdx
	leaq	5120(%rcx), %rax
	leaq	480(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$229:
	movq	%mm0, %rdx
	leaq	6144(%rcx), %rax
	leaq	576(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$228:
	leaq	38432(%rsp), %rcx
	leaq	800(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rcx, %rax
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$227:
	movq	%mm0, %rdx
	leaq	1024(%rcx), %rax
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$226:
	movq	%mm0, %rdx
	leaq	2048(%rcx), %rax
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$225:
	movq	%mm0, %rdx
	leaq	3072(%rcx), %rax
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$224:
	movq	%mm0, %rdx
	leaq	4096(%rcx), %rax
	leaq	384(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$223:
	movq	%mm0, %rdx
	leaq	5120(%rcx), %rax
	leaq	480(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$222:
	movq	%mm0, %rdx
	leaq	6144(%rcx), %rax
	leaq	576(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$221:
	movq	%mm0, %rdx
	leaq	7168(%rcx), %rax
	leaq	672(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$220:
	leaq	46624(%rsp), %rax
	leaq	1568(%rsi), %rdx
	movq	%rax, %r10
	movq	%rdx, %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$217
.L__sign_internal$218:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$219:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$217:
	cmpq	$403, %r9
	jb  	.L__sign_internal$218
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$216:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	1024(%rax), %r10
	leaq	416(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$213
.L__sign_internal$214:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$215:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$213:
	cmpq	$403, %r9
	jb  	.L__sign_internal$214
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$212:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	2048(%rax), %r10
	leaq	832(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$209
.L__sign_internal$210:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$211:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$209:
	cmpq	$403, %r9
	jb  	.L__sign_internal$210
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$208:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	3072(%rax), %r10
	leaq	1248(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$205
.L__sign_internal$206:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$207:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$205:
	cmpq	$403, %r9
	jb  	.L__sign_internal$206
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$204:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	4096(%rax), %r10
	leaq	1664(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$201
.L__sign_internal$202:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$203:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$201:
	cmpq	$403, %r9
	jb  	.L__sign_internal$202
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$200:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	5120(%rax), %r10
	leaq	2080(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$197
.L__sign_internal$198:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$199:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$197:
	cmpq	$403, %r9
	jb  	.L__sign_internal$198
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$196:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	6144(%rax), %r10
	leaq	2496(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$193
.L__sign_internal$194:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$195:
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$193:
	cmpq	$403, %r9
	jb  	.L__sign_internal$194
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$192:
	vmovdqu	%ymm2, (%r10,%r8)
	leaq	7168(%rax), %rax
	leaq	2912(%rdx), %rcx
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$189
.L__sign_internal$190:
	vmovdqu	(%rcx,%r9), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$191:
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
	addq	$13, %r9
.L__sign_internal$189:
	cmpq	$403, %r9
	jb  	.L__sign_internal$190
	vmovdqu	400(%rcx), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$188:
	vmovdqu	%ymm2, (%rax,%r8)
// declassify_mem 8192 [RSP + 46624]
	leaq	16928(%rsp), %rcx
	leaq	9760(%rsp), %rax
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
	leaq	17952(%rsp), %rcx
	leaq	10784(%rsp), %rax
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
	leaq	18976(%rsp), %rcx
	leaq	11808(%rsp), %rax
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
	leaq	20000(%rsp), %rcx
	leaq	12832(%rsp), %rax
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
	leaq	21024(%rsp), %rcx
	leaq	13856(%rsp), %rax
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
	leaq	22048(%rsp), %rcx
	leaq	14880(%rsp), %rax
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
	leaq	23072(%rsp), %rcx
	leaq	15904(%rsp), %rax
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
	leaq	54816(%rsp), %rcx
	leaq	38432(%rsp), %rax
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
	leaq	95776(%rsp), %rcx
	leaq	46624(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	55840(%rsp), %rcx
	leaq	39456(%rsp), %rax
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
	leaq	97824(%rsp), %rcx
	leaq	47648(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	56864(%rsp), %rcx
	leaq	40480(%rsp), %rax
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
	leaq	99872(%rsp), %rcx
	leaq	48672(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	57888(%rsp), %rcx
	leaq	41504(%rsp), %rax
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
	leaq	101920(%rsp), %rcx
	leaq	49696(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	58912(%rsp), %rcx
	leaq	42528(%rsp), %rax
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
	leaq	103968(%rsp), %rcx
	leaq	50720(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	59936(%rsp), %rcx
	leaq	43552(%rsp), %rax
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
	leaq	106016(%rsp), %rcx
	leaq	51744(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	60960(%rsp), %rcx
	leaq	44576(%rsp), %rax
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
	leaq	108064(%rsp), %rcx
	leaq	52768(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 992(%rcx)
	vmovdqu	%ymm2, 2016(%rcx)
	leaq	61984(%rsp), %rcx
	leaq	45600(%rsp), %rax
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
	leaq	110112(%rsp), %rcx
	leaq	53792(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 1024(%rcx)
	vmovdqu	32(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	%ymm2, 1056(%rcx)
	vmovdqu	64(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	%ymm2, 1088(%rcx)
	vmovdqu	96(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	%ymm2, 1120(%rcx)
	vmovdqu	128(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	%ymm2, 1152(%rcx)
	vmovdqu	160(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	%ymm2, 1184(%rcx)
	vmovdqu	192(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	%ymm2, 1216(%rcx)
	vmovdqu	224(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	%ymm2, 1248(%rcx)
	vmovdqu	256(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	%ymm2, 1280(%rcx)
	vmovdqu	288(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	%ymm2, 1312(%rcx)
	vmovdqu	320(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	%ymm2, 1344(%rcx)
	vmovdqu	352(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	%ymm2, 1376(%rcx)
	vmovdqu	384(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	%ymm2, 1408(%rcx)
	vmovdqu	416(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	%ymm2, 1440(%rcx)
	vmovdqu	448(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	%ymm2, 1472(%rcx)
	vmovdqu	480(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	vmovdqu	%ymm2, 1504(%rcx)
	vmovdqu	512(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 512(%rcx)
	vmovdqu	%ymm2, 1536(%rcx)
	vmovdqu	544(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 544(%rcx)
	vmovdqu	%ymm2, 1568(%rcx)
	vmovdqu	576(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 576(%rcx)
	vmovdqu	%ymm2, 1600(%rcx)
	vmovdqu	608(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 608(%rcx)
	vmovdqu	%ymm2, 1632(%rcx)
	vmovdqu	640(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rcx)
	vmovdqu	%ymm2, 1664(%rcx)
	vmovdqu	672(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 672(%rcx)
	vmovdqu	%ymm2, 1696(%rcx)
	vmovdqu	704(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 704(%rcx)
	vmovdqu	%ymm2, 1728(%rcx)
	vmovdqu	736(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 736(%rcx)
	vmovdqu	%ymm2, 1760(%rcx)
	vmovdqu	768(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 768(%rcx)
	vmovdqu	%ymm2, 1792(%rcx)
	vmovdqu	800(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 800(%rcx)
	vmovdqu	%ymm2, 1824(%rcx)
	vmovdqu	832(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 832(%rcx)
	vmovdqu	%ymm2, 1856(%rcx)
	vmovdqu	864(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 864(%rcx)
	vmovdqu	%ymm2, 1888(%rcx)
	vmovdqu	896(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 896(%rcx)
	vmovdqu	%ymm2, 1920(%rcx)
	vmovdqu	928(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 928(%rcx)
	vmovdqu	%ymm2, 1952(%rcx)
	vmovdqu	960(%rax), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm1
	vmovdqu	%ymm1, 960(%rcx)
	vmovdqu	%ymm2, 1984(%rcx)
	vmovdqu	992(%rax), %ymm2
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
	leaq	128(%rsp), %rax
	movw	169860(%rsp), %dx
	leaq	3456(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$187:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	2752(%rsp), %rcx
	leaq	2048(%rsp), %rdx
	leaq	1344(%rsp), %rsi
	leaq	640(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$186:
	leaq	3456(%rsp), %rax
	leaq	2888(%rsp), %rcx
	leaq	2184(%rsp), %rdx
	leaq	1480(%rsp), %rsi
	leaq	776(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$185:
	leaq	3456(%rsp), %rax
	leaq	3024(%rsp), %rcx
	leaq	2320(%rsp), %rdx
	leaq	1616(%rsp), %rsi
	leaq	912(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$184:
	leaq	3456(%rsp), %rax
	leaq	3160(%rsp), %rcx
	leaq	2456(%rsp), %rdx
	leaq	1752(%rsp), %rsi
	leaq	1048(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$183:
	leaq	3456(%rsp), %rax
	leaq	3296(%rsp), %rcx
	leaq	2592(%rsp), %rdx
	leaq	1888(%rsp), %rsi
	leaq	1184(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$182:
	leaq	31264(%rsp), %rax
	leaq	2752(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$180
.L__sign_internal$181:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$180:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$181
	leaq	32288(%rsp), %rax
	leaq	2048(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$178
.L__sign_internal$179:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$178:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$179
	leaq	33312(%rsp), %rax
	leaq	1344(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$176
.L__sign_internal$177:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$176:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$177
	leaq	34336(%rsp), %rax
	leaq	640(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$174
.L__sign_internal$175:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$174:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$175
	addw	$4, 169860(%rsp)
	leaq	128(%rsp), %rax
	movw	169860(%rsp), %dx
	leaq	3456(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$173:
	leaq	40(%rsp), %rsp
	leaq	3456(%rsp), %rax
	leaq	2752(%rsp), %rcx
	leaq	2048(%rsp), %rdx
	leaq	1344(%rsp), %rsi
	leaq	640(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$172:
	leaq	3456(%rsp), %rax
	leaq	2888(%rsp), %rcx
	leaq	2184(%rsp), %rdx
	leaq	1480(%rsp), %rsi
	leaq	776(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$171:
	leaq	3456(%rsp), %rax
	leaq	3024(%rsp), %rcx
	leaq	2320(%rsp), %rdx
	leaq	1616(%rsp), %rsi
	leaq	912(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$170:
	leaq	3456(%rsp), %rax
	leaq	3160(%rsp), %rcx
	leaq	2456(%rsp), %rdx
	leaq	1752(%rsp), %rsi
	leaq	1048(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$169:
	leaq	3456(%rsp), %rax
	leaq	3296(%rsp), %rcx
	leaq	2592(%rsp), %rdx
	leaq	1888(%rsp), %rsi
	leaq	1184(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$168:
	leaq	35360(%rsp), %rax
	leaq	2752(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$166
.L__sign_internal$167:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$166:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$167
	leaq	36384(%rsp), %rax
	leaq	2048(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$164
.L__sign_internal$165:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$164:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$165
	leaq	37408(%rsp), %rax
	leaq	1344(%rsp), %r9
	movq	$524288, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$1048575, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r10
	movq	$0, %r8
	jmp 	.L__sign_internal$162
.L__sign_internal$163:
	vmovdqu	(%r9,%r10), %xmm3
	addq	$4, %r10
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%r9,%r10), %xmm3
	addq	$16, %r10
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8736(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 8768(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r8)
	addq	$32, %r8
.L__sign_internal$162:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$163
	movq	$0, %r8
	jmp 	.L__sign_internal$160
.L__sign_internal$161:
	addq	$32, %r8
.L__sign_internal$160:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$161
	addw	$3, 169860(%rsp)
	movw	169860(%rsp), %ax
	movq	$0, %r9
	jmp 	.L__sign_internal$158
.L__sign_internal$159:
	vmovdqu	31264(%rsp,%r9), %ymm0
	vmovdqu	%ymm0, 24096(%rsp,%r9)
	addq	$32, %r9
.L__sign_internal$158:
	cmpq	$7168, %r9
	jb  	.L__sign_internal$159
	leaq	24096(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__sign_internal$157:
	leaq	112160(%rsp), %rcx
	leaq	24096(%rsp), %rdx
	leaq	71200(%rsp), %rsi
	movq	%rcx, %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$155
.L__sign_internal$156:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$155:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$156
	leaq	72224(%rsp), %rsi
	leaq	7168(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$153
.L__sign_internal$154:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$153:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$154
	leaq	73248(%rsp), %rsi
	leaq	14336(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$151
.L__sign_internal$152:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$151:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$152
	leaq	74272(%rsp), %rsi
	leaq	21504(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$149
.L__sign_internal$150:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$149:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$150
	leaq	75296(%rsp), %rsi
	leaq	28672(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$147
.L__sign_internal$148:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$147:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$148
	leaq	76320(%rsp), %rsi
	leaq	35840(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$145
.L__sign_internal$146:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$145:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$146
	leaq	77344(%rsp), %rsi
	leaq	43008(%rcx), %rdi
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$143
.L__sign_internal$144:
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
	vmovdqu	5120(%rdi,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rdi,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$143:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$144
	leaq	78368(%rsp), %rsi
	leaq	50176(%rcx), %rcx
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$141
.L__sign_internal$142:
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
	vmovdqu	5120(%rcx,%r8), %ymm4
	vmovdqu	5120(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%rcx,%r8), %ymm4
	vmovdqu	6144(%rdx,%r8), %ymm5
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
.L__sign_internal$141:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$142
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %r9
	vmovq	%r9, %xmm0
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
	movq	$4097, %rsi
	vmovq	%rsi, %xmm0
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
// declassify_mem 64 [RSP + 192]
	leaq	7712(%rsp), %rax
	leaq	192(%rsp), %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__sign_internal$113
.L__sign_internal$114:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__sign_internal$113:
	cmpq	$1024, %rsi
	jb  	.L__sign_internal$114
	movq	%rax, 169560(%rsp)
	leaq	416(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__sign_internal$112:
	leaq	416(%rsp), %rcx
	leaq	256(%rsp), %rdx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$111:
	movq	169560(%rsp), %rcx
	movq	256(%rsp), %rdx
	movq	$8, %r8
	lfence
	movq	$0, %rdi
	movq	$196, %rsi
	jmp 	.L__sign_internal$104
.L__sign_internal$105:
	movq	$-1, %rax
	cmovnb	%rax, %rdi
	jmp 	.L__sign_internal$106
.L__sign_internal$107:
	movq	$-1, %rax
	cmovbe	%rax, %rdi
.L__sign_internal$106:
	cmpq	$136, %r8
	jnb 	.L__sign_internal$108
	movq	$-1, %rax
	cmovnb	%rax, %rdi
	jmp 	.L__sign_internal$109
.L__sign_internal$108:
	movq	%rsi, 169560(%rsp)
	movq	%rdx, 169552(%rsp)
	movq	%rcx, 169544(%rsp)
	leaq	416(%rsp), %rcx
	leaq	256(%rsp), %rdx
	call	.Lshake256_squeezeblock$1
.L__sign_internal$110:
	movq	169560(%rsp), %rsi
	movq	169552(%rsp), %rdx
	movq	169544(%rsp), %rcx
	movq	$0, %r8
	lfence
	movq	$0, %rdi
.L__sign_internal$109:
	movzbq	256(%rsp,%r8), %rax
// declassify_val u64 %rax
	orq 	%rdi, %rax
	incq	%r8
	cmpq	%rsi, %rax
	jnbe	.L__sign_internal$107
	movq	$-1, %r9
	cmovnbe	%r9, %rdi
	movl	(%rcx,%rax,4), %r9d
	movl	%r9d, (%rcx,%rsi,4)
	movl	%edx, %r9d
	andl	$1, %r9d
	shll	$1, %r9d
	movl	$1, %r10d
	subl	%r9d, %r10d
	movl	%r10d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__sign_internal$104:
	cmpq	$256, %rsi
	jb  	.L__sign_internal$105
	movw	169860(%rsp), %ax
// declassify_mem 1024 [RSP + 7712]
	leaq	7712(%rsp), %rcx
	lfence
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	movq	$60, %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$98
.L__sign_internal$99:
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	vmovdqu	(%rcx,%r8), %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm1
	vpackssdw	%ymm1, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpacksswb	%ymm1, %ymm1, %ymm1
	vpmovmskb	%ymm1, %r10d
	movl	%r10d, %r10d
	andq	$255, %r10
	orq 	%rdx, %r10
	jmp 	.L__sign_internal$102
.L__sign_internal$103:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	movl	%r11d, 169616(%rsp,%rsi,4)
	incq	%rsi
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$102:
	cmpq	$0, %r10
	jne 	.L__sign_internal$103
	movq	$-1, %r10
	cmovne	%r10, %rdx
	vpcmpgtd	%ymm2, %ymm0, %ymm1
	vpackssdw	%ymm1, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpacksswb	%ymm1, %ymm1, %ymm1
	vpmovmskb	%ymm1, %r10d
	movl	%r10d, %r10d
	andq	$255, %r10
	orq 	%rdx, %r10
	jmp 	.L__sign_internal$100
.L__sign_internal$101:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	decq	%rdi
	movl	%r11d, 169616(%rsp,%rdi,4)
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$100:
	cmpq	$0, %r10
	jne 	.L__sign_internal$101
	movq	$-1, %r10
	cmovne	%r10, %rdx
	addq	$8, %r9
	addq	$32, %r8
.L__sign_internal$98:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$99
	movq	$-1, %rcx
	cmovb	%rcx, %rdx
	movl	%esi, 169856(%rsp)
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
	vmovdqu	glob_data + 8512(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
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
	vmovdqu	glob_data + 8512(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
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
	vmovdqu	glob_data + 8512(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %rbp
	jmp 	.L__sign_internal$53
.L__sign_internal$54:
	vmovdqu	(%rbx,%rbp), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm2, %ymm2
	vmovdqu	(%r11,%rbp), %ymm3
	vpaddd	%ymm2, %ymm3, %ymm2
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
	movq	$0, %rdx
	orq 	%rdx, %rdi
	cmpq	$0, 169568(%rsp)
	je  	.L__sign_internal$2
	movq	$0, %rsi
	jmp 	.L__sign_internal$42
.L__sign_internal$43:
	movb	$0, (%rdi,%rsi)
	incq	%rsi
.L__sign_internal$42:
	cmpq	$4627, %rsi
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	movq	$524288, %r10
	vmovq	%r10, %xmm0
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
	leaq	6144(%rax), %rax
	movq	$524288, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$13
.L__sign_internal$14:
	vmovdqu	(%rax,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits20$1
.L__sign_internal$15:
	vmovdqu	%xmm12, (%rsi,%r8)
	addq	$10, %r8
	vmovdqu	%xmm11, (%rsi,%r8)
	addq	$10, %r8
	addq	$32, %r9
.L__sign_internal$13:
	cmpq	$992, %r9
	jb  	.L__sign_internal$14
	vmovdqu	(%rax,%r9), %ymm2
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
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rax
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
	vmovdqu	(%rcx,%r8), %ymm2
	vpcmpeqd	%ymm0, %ymm2, %ymm1
	vpackssdw	%ymm1, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpacksswb	%ymm1, %ymm1, %ymm1
	vpmovmskb	%ymm1, %r11d
	movl	%r11d, %r11d
	andq	$255, %r11
	xorq	$255, %r11
	orq 	%rdx, %r11
	jmp 	.L__sign_internal$8
.L__sign_internal$9:
	movq	$-1, %rbx
	cmove	%rbx, %rdx
	tzcntq	%r11, %r14
	addq	%r10, %r14
	cmpq	$75, %rax
	jb  	.L__sign_internal$10
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L__sign_internal$11
.L__sign_internal$10:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
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
	cmovne	%r11, %rdx
	addq	$8, %r10
	addq	$32, %r8
.L__sign_internal$6:
	cmpq	%r9, %r8
	jb  	.L__sign_internal$7
	movq	$-1, %r8
	cmovb	%r8, %rdx
	movb	%al, 4619(%rdi,%rsi)
	incq	%rsi
.L__sign_internal$4:
	cmpq	$8, %rsi
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
	leaq	64(%rsp), %r9
	movb	$8, 95768(%rsp)
	movb	$7, 95769(%rsp)
	leaq	95768(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A128__A32_A2$1
.L__keygen_internal$646:
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
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$645:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$644:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$643:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$642:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$641:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$640:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	38368(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$639:
	movq	%r8, %r10
	leaq	39392(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$638:
	movq	%r8, %r11
	leaq	40416(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$637:
	movq	%r8, %rbx
	leaq	41440(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$636:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$629
	cmpq	$256, %r11
	jb  	.L__keygen_internal$631
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$633
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$615
	movl	$0, %edi
.L__keygen_internal$635:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$633:
	movl	$0, %edi
.L__keygen_internal$634:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$631:
	movl	$0, %edi
.L__keygen_internal$632:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$629:
	movl	$0, %edi
.L__keygen_internal$630:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$616:
	movq	%r10, 95736(%rsp)
	movq	%r11, 95744(%rsp)
	movq	%rbx, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$628:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %r11
	movq	95752(%rsp), %rbx
	movq	95760(%rsp), %r12
	leaq	38368(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$627:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	39392(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$626:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	40416(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$625:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	41440(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$624:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$617
	cmpq	$256, %r11
	jb  	.L__keygen_internal$619
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$621
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$615
	movl	$0, %edi
.L__keygen_internal$623:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$621:
	movl	$0, %edi
.L__keygen_internal$622:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$619:
	movl	$0, %edi
.L__keygen_internal$620:
	jmp 	.L__keygen_internal$615
.L__keygen_internal$617:
	movl	$0, %edi
.L__keygen_internal$618:
.L__keygen_internal$615:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$616
	movw	$4, 95728(%rsp)
	movw	$5, 95730(%rsp)
	movw	$6, 95732(%rsp)
	movw	$256, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$614:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$613:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$612:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$611:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$610:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$609:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	42464(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$608:
	movq	%r8, %r10
	leaq	43488(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$607:
	movq	%r8, %r11
	leaq	44512(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$606:
	movq	%r8, %rbx
	leaq	45536(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$605:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$598
	cmpq	$256, %r11
	jb  	.L__keygen_internal$600
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$602
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$584
	movl	$0, %edi
.L__keygen_internal$604:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$602:
	movl	$0, %edi
.L__keygen_internal$603:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$600:
	movl	$0, %edi
.L__keygen_internal$601:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$598:
	movl	$0, %edi
.L__keygen_internal$599:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$585:
	movq	%r10, 95760(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$597:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %r11
	movq	95744(%rsp), %rbx
	movq	95736(%rsp), %r12
	leaq	42464(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$596:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	43488(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$595:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	44512(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$594:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	45536(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$593:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$586
	cmpq	$256, %r11
	jb  	.L__keygen_internal$588
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$590
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$584
	movl	$0, %edi
.L__keygen_internal$592:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$590:
	movl	$0, %edi
.L__keygen_internal$591:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$588:
	movl	$0, %edi
.L__keygen_internal$589:
	jmp 	.L__keygen_internal$584
.L__keygen_internal$586:
	movl	$0, %edi
.L__keygen_internal$587:
.L__keygen_internal$584:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$585
	movw	$257, 95728(%rsp)
	movw	$258, 95730(%rsp)
	movw	$259, 95732(%rsp)
	movw	$260, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$583:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$582:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$581:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$580:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$579:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$578:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	46560(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$577:
	movq	%r8, %r10
	leaq	47584(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$576:
	movq	%r8, %rbx
	leaq	48608(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$575:
	movq	%r8, %r11
	leaq	49632(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$574:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$567
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$569
	cmpq	$256, %r11
	jb  	.L__keygen_internal$571
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$553
	movl	$0, %edi
.L__keygen_internal$573:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$571:
	movl	$0, %edi
.L__keygen_internal$572:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$569:
	movl	$0, %edi
.L__keygen_internal$570:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$567:
	movl	$0, %edi
.L__keygen_internal$568:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$554:
	movq	%r10, 95736(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$566:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %rbx
	movq	95752(%rsp), %r11
	movq	95760(%rsp), %r12
	leaq	46560(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$565:
	movq	%r8, %r10
	movq	%rbx, %r8
	leaq	47584(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$564:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	48608(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$563:
	movq	%r8, %r11
	movq	%r12, %r8
	leaq	49632(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$562:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$555
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$557
	cmpq	$256, %r11
	jb  	.L__keygen_internal$559
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$553
	movl	$0, %edi
.L__keygen_internal$561:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$559:
	movl	$0, %edi
.L__keygen_internal$560:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$557:
	movl	$0, %edi
.L__keygen_internal$558:
	jmp 	.L__keygen_internal$553
.L__keygen_internal$555:
	movl	$0, %edi
.L__keygen_internal$556:
.L__keygen_internal$553:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$554
	movw	$261, 95728(%rsp)
	movw	$262, 95730(%rsp)
	movw	$512, 95732(%rsp)
	movw	$513, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$552:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$551:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$550:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$549:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$548:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$547:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	50656(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$546:
	movq	%r8, %rbx
	leaq	51680(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$545:
	movq	%r8, %r11
	leaq	52704(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$544:
	movq	%r8, %r10
	leaq	53728(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$543:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$536
	cmpq	$256, %r11
	jb  	.L__keygen_internal$538
	cmpq	$256, %r10
	jb  	.L__keygen_internal$540
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$522
	movl	$0, %edi
.L__keygen_internal$542:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$540:
	movl	$0, %edi
.L__keygen_internal$541:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$538:
	movl	$0, %edi
.L__keygen_internal$539:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$536:
	movl	$0, %edi
.L__keygen_internal$537:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$523:
	movq	%rbx, 95760(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%r10, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$535:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %r11
	movq	95744(%rsp), %r10
	movq	95736(%rsp), %r12
	leaq	50656(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$534:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	51680(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$533:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	52704(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$532:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	53728(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$531:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$524
	cmpq	$256, %r11
	jb  	.L__keygen_internal$526
	cmpq	$256, %r10
	jb  	.L__keygen_internal$528
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$522
	movl	$0, %edi
.L__keygen_internal$530:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$528:
	movl	$0, %edi
.L__keygen_internal$529:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$526:
	movl	$0, %edi
.L__keygen_internal$527:
	jmp 	.L__keygen_internal$522
.L__keygen_internal$524:
	movl	$0, %edi
.L__keygen_internal$525:
.L__keygen_internal$522:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$523
	movw	$514, 95728(%rsp)
	movw	$515, 95730(%rsp)
	movw	$516, 95732(%rsp)
	movw	$517, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$521:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$520:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$519:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$518:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$517:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$516:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	54752(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$515:
	movq	%r8, %r10
	leaq	55776(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$514:
	movq	%r8, %r11
	leaq	56800(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$513:
	movq	%r8, %rbx
	leaq	57824(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$512:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$505
	cmpq	$256, %r11
	jb  	.L__keygen_internal$507
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$509
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$491
	movl	$0, %edi
.L__keygen_internal$511:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$509:
	movl	$0, %edi
.L__keygen_internal$510:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$507:
	movl	$0, %edi
.L__keygen_internal$508:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$505:
	movl	$0, %edi
.L__keygen_internal$506:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$492:
	movq	%r10, 95736(%rsp)
	movq	%r11, 95744(%rsp)
	movq	%rbx, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$504:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %r11
	movq	95752(%rsp), %rbx
	movq	95760(%rsp), %r12
	leaq	54752(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$503:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	55776(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$502:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	56800(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$501:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	57824(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$500:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$493
	cmpq	$256, %r11
	jb  	.L__keygen_internal$495
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$497
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$491
	movl	$0, %edi
.L__keygen_internal$499:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$497:
	movl	$0, %edi
.L__keygen_internal$498:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$495:
	movl	$0, %edi
.L__keygen_internal$496:
	jmp 	.L__keygen_internal$491
.L__keygen_internal$493:
	movl	$0, %edi
.L__keygen_internal$494:
.L__keygen_internal$491:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$492
	movw	$518, 95728(%rsp)
	movw	$768, 95730(%rsp)
	movw	$769, 95732(%rsp)
	movw	$770, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$490:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$489:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$488:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$487:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$486:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$485:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	58848(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$484:
	movq	%r8, %r10
	leaq	59872(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$483:
	movq	%r8, %r11
	leaq	60896(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$482:
	movq	%r8, %rbx
	leaq	61920(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$481:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$474
	cmpq	$256, %r11
	jb  	.L__keygen_internal$476
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$478
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$460
	movl	$0, %edi
.L__keygen_internal$480:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$478:
	movl	$0, %edi
.L__keygen_internal$479:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$476:
	movl	$0, %edi
.L__keygen_internal$477:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$474:
	movl	$0, %edi
.L__keygen_internal$475:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$461:
	movq	%r10, 95760(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$473:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %r11
	movq	95744(%rsp), %rbx
	movq	95736(%rsp), %r12
	leaq	58848(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$472:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	59872(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$471:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	60896(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$470:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	61920(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$469:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$462
	cmpq	$256, %r11
	jb  	.L__keygen_internal$464
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$466
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$460
	movl	$0, %edi
.L__keygen_internal$468:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$466:
	movl	$0, %edi
.L__keygen_internal$467:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$464:
	movl	$0, %edi
.L__keygen_internal$465:
	jmp 	.L__keygen_internal$460
.L__keygen_internal$462:
	movl	$0, %edi
.L__keygen_internal$463:
.L__keygen_internal$460:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$461
	movw	$771, 95728(%rsp)
	movw	$772, 95730(%rsp)
	movw	$773, 95732(%rsp)
	movw	$774, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$459:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$458:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$457:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$456:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$455:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$454:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	62944(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$453:
	movq	%r8, %r10
	leaq	63968(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$452:
	movq	%r8, %r11
	leaq	64992(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$451:
	movq	%r8, %rbx
	leaq	66016(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$450:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$443
	cmpq	$256, %r11
	jb  	.L__keygen_internal$445
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$447
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$429
	movl	$0, %edi
.L__keygen_internal$449:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$447:
	movl	$0, %edi
.L__keygen_internal$448:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$445:
	movl	$0, %edi
.L__keygen_internal$446:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$443:
	movl	$0, %edi
.L__keygen_internal$444:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$430:
	movq	%r10, 95736(%rsp)
	movq	%r11, 95744(%rsp)
	movq	%rbx, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$442:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %r11
	movq	95752(%rsp), %rbx
	movq	95760(%rsp), %r12
	leaq	62944(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$441:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	63968(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$440:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	64992(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$439:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	66016(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$438:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$431
	cmpq	$256, %r11
	jb  	.L__keygen_internal$433
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$435
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$429
	movl	$0, %edi
.L__keygen_internal$437:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$435:
	movl	$0, %edi
.L__keygen_internal$436:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$433:
	movl	$0, %edi
.L__keygen_internal$434:
	jmp 	.L__keygen_internal$429
.L__keygen_internal$431:
	movl	$0, %edi
.L__keygen_internal$432:
.L__keygen_internal$429:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$430
	movw	$1024, 95728(%rsp)
	movw	$1025, 95730(%rsp)
	movw	$1026, 95732(%rsp)
	movw	$1027, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$428:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$427:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$426:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$425:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$424:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$423:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	67040(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$422:
	movq	%r8, %r10
	leaq	68064(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$421:
	movq	%r8, %r11
	leaq	69088(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$420:
	movq	%r8, %rbx
	leaq	70112(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$419:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$412
	cmpq	$256, %r11
	jb  	.L__keygen_internal$414
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$416
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$398
	movl	$0, %edi
.L__keygen_internal$418:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$416:
	movl	$0, %edi
.L__keygen_internal$417:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$414:
	movl	$0, %edi
.L__keygen_internal$415:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$412:
	movl	$0, %edi
.L__keygen_internal$413:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$399:
	movq	%r10, 95760(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$411:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %r11
	movq	95744(%rsp), %rbx
	movq	95736(%rsp), %r12
	leaq	67040(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$410:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	68064(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$409:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	69088(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$408:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	70112(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$407:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$400
	cmpq	$256, %r11
	jb  	.L__keygen_internal$402
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$404
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$398
	movl	$0, %edi
.L__keygen_internal$406:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$404:
	movl	$0, %edi
.L__keygen_internal$405:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$402:
	movl	$0, %edi
.L__keygen_internal$403:
	jmp 	.L__keygen_internal$398
.L__keygen_internal$400:
	movl	$0, %edi
.L__keygen_internal$401:
.L__keygen_internal$398:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$399
	movw	$1028, 95728(%rsp)
	movw	$1029, 95730(%rsp)
	movw	$1030, 95732(%rsp)
	movw	$1280, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$397:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$396:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$395:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$394:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$393:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$392:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	71136(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$391:
	movq	%r8, %r11
	leaq	72160(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$390:
	movq	%r8, %rbx
	leaq	73184(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$389:
	movq	%r8, %r10
	leaq	74208(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$388:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$381
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$383
	cmpq	$256, %r10
	jb  	.L__keygen_internal$385
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$367
	movl	$0, %edi
.L__keygen_internal$387:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$385:
	movl	$0, %edi
.L__keygen_internal$386:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$383:
	movl	$0, %edi
.L__keygen_internal$384:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$381:
	movl	$0, %edi
.L__keygen_internal$382:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$368:
	movq	%r11, 95736(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r10, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$380:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %rbx
	movq	95752(%rsp), %r10
	movq	95760(%rsp), %r12
	leaq	71136(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$379:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	72160(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$378:
	movq	%r8, %rbx
	movq	%r10, %r8
	leaq	73184(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$377:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	74208(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$376:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$369
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$371
	cmpq	$256, %r10
	jb  	.L__keygen_internal$373
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$367
	movl	$0, %edi
.L__keygen_internal$375:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$373:
	movl	$0, %edi
.L__keygen_internal$374:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$371:
	movl	$0, %edi
.L__keygen_internal$372:
	jmp 	.L__keygen_internal$367
.L__keygen_internal$369:
	movl	$0, %edi
.L__keygen_internal$370:
.L__keygen_internal$367:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$368
	movw	$1281, 95728(%rsp)
	movw	$1282, 95730(%rsp)
	movw	$1283, 95732(%rsp)
	movw	$1284, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$366:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$365:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$364:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$363:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$362:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$361:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	75232(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$360:
	movq	%r8, %r11
	leaq	76256(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$359:
	movq	%r8, %rbx
	leaq	77280(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$358:
	movq	%r8, %r10
	leaq	78304(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$357:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$350
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$352
	cmpq	$256, %r10
	jb  	.L__keygen_internal$354
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$336
	movl	$0, %edi
.L__keygen_internal$356:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$354:
	movl	$0, %edi
.L__keygen_internal$355:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$352:
	movl	$0, %edi
.L__keygen_internal$353:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$350:
	movl	$0, %edi
.L__keygen_internal$351:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$337:
	movq	%r11, 95760(%rsp)
	movq	%rbx, 95752(%rsp)
	movq	%r10, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$349:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %rbx
	movq	95744(%rsp), %r10
	movq	95736(%rsp), %r12
	leaq	75232(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$348:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	76256(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$347:
	movq	%r8, %rbx
	movq	%r10, %r8
	leaq	77280(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$346:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	78304(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$345:
	movl	$1, %edi
	cmpq	$256, %r11
	jb  	.L__keygen_internal$338
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$340
	cmpq	$256, %r10
	jb  	.L__keygen_internal$342
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$336
	movl	$0, %edi
.L__keygen_internal$344:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$342:
	movl	$0, %edi
.L__keygen_internal$343:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$340:
	movl	$0, %edi
.L__keygen_internal$341:
	jmp 	.L__keygen_internal$336
.L__keygen_internal$338:
	movl	$0, %edi
.L__keygen_internal$339:
.L__keygen_internal$336:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$337
	movw	$1285, 95728(%rsp)
	movw	$1286, 95730(%rsp)
	movw	$1536, 95732(%rsp)
	movw	$1537, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$335:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$334:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$333:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$332:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$331:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$330:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	79328(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$329:
	movq	%r8, %rbx
	leaq	80352(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$328:
	movq	%r8, %r11
	leaq	81376(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$327:
	movq	%r8, %r10
	leaq	82400(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$326:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$319
	cmpq	$256, %r11
	jb  	.L__keygen_internal$321
	cmpq	$256, %r10
	jb  	.L__keygen_internal$323
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$305
	movl	$0, %edi
.L__keygen_internal$325:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$323:
	movl	$0, %edi
.L__keygen_internal$324:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$321:
	movl	$0, %edi
.L__keygen_internal$322:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$319:
	movl	$0, %edi
.L__keygen_internal$320:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$306:
	movq	%rbx, 95736(%rsp)
	movq	%r11, 95744(%rsp)
	movq	%r10, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$318:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %r11
	movq	95752(%rsp), %r10
	movq	95760(%rsp), %r12
	leaq	79328(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$317:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	80352(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$316:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	81376(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$315:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	82400(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$314:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$307
	cmpq	$256, %r11
	jb  	.L__keygen_internal$309
	cmpq	$256, %r10
	jb  	.L__keygen_internal$311
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$305
	movl	$0, %edi
.L__keygen_internal$313:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$311:
	movl	$0, %edi
.L__keygen_internal$312:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$309:
	movl	$0, %edi
.L__keygen_internal$310:
	jmp 	.L__keygen_internal$305
.L__keygen_internal$307:
	movl	$0, %edi
.L__keygen_internal$308:
.L__keygen_internal$305:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$306
	movw	$1538, 95728(%rsp)
	movw	$1539, 95730(%rsp)
	movw	$1540, 95732(%rsp)
	movw	$1541, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$304:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$303:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$302:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$301:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$300:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$299:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	83424(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$298:
	movq	%r8, %r10
	leaq	84448(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$297:
	movq	%r8, %r11
	leaq	85472(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$296:
	movq	%r8, %rbx
	leaq	86496(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$295:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$288
	cmpq	$256, %r11
	jb  	.L__keygen_internal$290
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$292
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$274
	movl	$0, %edi
.L__keygen_internal$294:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$292:
	movl	$0, %edi
.L__keygen_internal$293:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$290:
	movl	$0, %edi
.L__keygen_internal$291:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$288:
	movl	$0, %edi
.L__keygen_internal$289:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$275:
	movq	%r10, 95760(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rbx, 95744(%rsp)
	movq	%r8, 95736(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$287:
	movq	95760(%rsp), %r8
	movq	95752(%rsp), %r11
	movq	95744(%rsp), %rbx
	movq	95736(%rsp), %r12
	leaq	83424(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$286:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	84448(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$285:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	85472(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$284:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	86496(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$283:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$276
	cmpq	$256, %r11
	jb  	.L__keygen_internal$278
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$280
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$274
	movl	$0, %edi
.L__keygen_internal$282:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$280:
	movl	$0, %edi
.L__keygen_internal$281:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$278:
	movl	$0, %edi
.L__keygen_internal$279:
	jmp 	.L__keygen_internal$274
.L__keygen_internal$276:
	movl	$0, %edi
.L__keygen_internal$277:
.L__keygen_internal$274:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$275
	movw	$1542, 95728(%rsp)
	movw	$1792, 95730(%rsp)
	movw	$1793, 95732(%rsp)
	movw	$1794, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$273:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$272:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$271:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$270:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$269:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$268:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	87520(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$267:
	movq	%r8, %rbx
	leaq	88544(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$266:
	movq	%r8, %r11
	leaq	89568(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$265:
	movq	%r8, %r10
	leaq	90592(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$264:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$257
	cmpq	$256, %r11
	jb  	.L__keygen_internal$259
	cmpq	$256, %r10
	jb  	.L__keygen_internal$261
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$243
	movl	$0, %edi
.L__keygen_internal$263:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$261:
	movl	$0, %edi
.L__keygen_internal$262:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$259:
	movl	$0, %edi
.L__keygen_internal$260:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$257:
	movl	$0, %edi
.L__keygen_internal$258:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$244:
	movq	%rbx, 95736(%rsp)
	movq	%r11, 95744(%rsp)
	movq	%r10, 95752(%rsp)
	movq	%r8, 95760(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$256:
	movq	95736(%rsp), %r8
	movq	95744(%rsp), %r11
	movq	95752(%rsp), %r10
	movq	95760(%rsp), %r12
	leaq	87520(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$255:
	movq	%r8, %rbx
	movq	%r11, %r8
	leaq	88544(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$254:
	movq	%r8, %r11
	movq	%r10, %r8
	leaq	89568(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$253:
	movq	%r8, %r10
	movq	%r12, %r8
	leaq	90592(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$252:
	movl	$1, %edi
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$245
	cmpq	$256, %r11
	jb  	.L__keygen_internal$247
	cmpq	$256, %r10
	jb  	.L__keygen_internal$249
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$243
	movl	$0, %edi
.L__keygen_internal$251:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$249:
	movl	$0, %edi
.L__keygen_internal$250:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$247:
	movl	$0, %edi
.L__keygen_internal$248:
	jmp 	.L__keygen_internal$243
.L__keygen_internal$245:
	movl	$0, %edi
.L__keygen_internal$246:
.L__keygen_internal$243:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$244
	movw	$1795, 95728(%rsp)
	movw	$1796, 95730(%rsp)
	movw	$1797, 95732(%rsp)
	movw	$1798, 95734(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rcx
	leaq	95728(%rsp), %rdx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$242:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$241:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$240:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$239:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$238:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$237:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	91616(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$236:
	movq	%r8, %r10
	leaq	92640(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$235:
	movq	%r8, %r11
	leaq	93664(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$234:
	movq	%r8, %rbx
	leaq	94688(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$233:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$226
	cmpq	$256, %r11
	jb  	.L__keygen_internal$228
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$230
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$212
	movl	$0, %edi
.L__keygen_internal$232:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$230:
	movl	$0, %edi
.L__keygen_internal$231:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$228:
	movl	$0, %edi
.L__keygen_internal$229:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$226:
	movl	$0, %edi
.L__keygen_internal$227:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$213:
	movq	%r10, 95728(%rsp)
	movq	%r11, 95760(%rsp)
	movq	%rbx, 95752(%rsp)
	movq	%r8, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$225:
	movq	95728(%rsp), %r8
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rbx
	movq	95744(%rsp), %r12
	leaq	91616(%rsp), %rcx
	leaq	4736(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$224:
	movq	%r8, %r10
	movq	%r11, %r8
	leaq	92640(%rsp), %rcx
	leaq	3872(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$223:
	movq	%r8, %r11
	movq	%rbx, %r8
	leaq	93664(%rsp), %rcx
	leaq	3008(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$222:
	movq	%r8, %rbx
	movq	%r12, %r8
	leaq	94688(%rsp), %rcx
	leaq	2144(%rsp), %rax
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$221:
	movl	$1, %edi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$214
	cmpq	$256, %r11
	jb  	.L__keygen_internal$216
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$218
	cmpq	$256, %r8
	jnb 	.L__keygen_internal$212
	movl	$0, %edi
.L__keygen_internal$220:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$218:
	movl	$0, %edi
.L__keygen_internal$219:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$216:
	movl	$0, %edi
.L__keygen_internal$217:
	jmp 	.L__keygen_internal$212
.L__keygen_internal$214:
	movl	$0, %edi
.L__keygen_internal$215:
.L__keygen_internal$212:
	cmpl	$1, %edi
	jne 	.L__keygen_internal$213
	leaq	96(%rsp), %rax
	movw	$0, %dx
	leaq	1344(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$211:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$210:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$209:
	leaq	6624(%rsp), %rbx
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$208:
	movq	%r12, %r10
	leaq	7648(%rsp), %rbx
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$207:
	movq	%r12, %r11
	leaq	8672(%rsp), %rbx
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$206:
	movq	%r12, %rdx
	leaq	9696(%rsp), %rbx
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$205:
	movq	%r12, %rsi
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$198
	cmpq	$256, %r11
	jb  	.L__keygen_internal$200
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$202
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$180
	movq	$0, %rdi
.L__keygen_internal$204:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$202:
	movq	$0, %rdi
.L__keygen_internal$203:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$200:
	movq	$0, %rdi
.L__keygen_internal$201:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$198:
	movq	$0, %rdi
.L__keygen_internal$199:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$181:
	movq	%r10, 95744(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rdx, 95760(%rsp)
	movq	%rsi, 95728(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$197:
	movq	95744(%rsp), %r10
	movq	95752(%rsp), %r11
	movq	95760(%rsp), %rdx
	movq	95728(%rsp), %rsi
	lfence
	movq	$0, %rax
	cmpq	$256, %r10
	jnb 	.L__keygen_internal$195
	movq	%r10, %rbx
	leaq	6624(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$196:
	movq	%rbx, %r10
.L__keygen_internal$195:
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$193
	movq	%r11, %rbx
	leaq	7648(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$194:
	movq	%rbx, %r11
.L__keygen_internal$193:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$191
	movq	%rdx, %rbx
	leaq	8672(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$192:
	movq	%rbx, %rdx
.L__keygen_internal$191:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$189
	movq	%rsi, %rbx
	leaq	9696(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$190:
	movq	%rbx, %rsi
.L__keygen_internal$189:
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$182
	cmpq	$256, %r11
	jb  	.L__keygen_internal$184
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$186
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$180
	movq	$0, %rdi
.L__keygen_internal$188:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$186:
	movq	$0, %rdi
.L__keygen_internal$187:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$184:
	movq	$0, %rdi
.L__keygen_internal$185:
	jmp 	.L__keygen_internal$180
.L__keygen_internal$182:
	movq	$0, %rdi
.L__keygen_internal$183:
.L__keygen_internal$180:
	cmpq	$1, %rdi
	jne 	.L__keygen_internal$181
	leaq	96(%rsp), %rax
	movw	$4, %dx
	leaq	1344(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$179:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$178:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$177:
	leaq	10720(%rsp), %rbx
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$176:
	movq	%r12, %r10
	leaq	11744(%rsp), %rbx
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$175:
	movq	%r12, %r11
	leaq	12768(%rsp), %rbx
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$174:
	movq	%r12, %rdx
	leaq	13792(%rsp), %rbx
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$173:
	movq	%r12, %rsi
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$166
	cmpq	$256, %r11
	jb  	.L__keygen_internal$168
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$170
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$148
	movq	$0, %rdi
.L__keygen_internal$172:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$170:
	movq	$0, %rdi
.L__keygen_internal$171:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$168:
	movq	$0, %rdi
.L__keygen_internal$169:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$166:
	movq	$0, %rdi
.L__keygen_internal$167:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$149:
	movq	%r10, 95728(%rsp)
	movq	%r11, 95760(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%rsi, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$165:
	movq	95728(%rsp), %r10
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rdx
	movq	95744(%rsp), %rsi
	lfence
	movq	$0, %rax
	cmpq	$256, %r10
	jnb 	.L__keygen_internal$163
	movq	%r10, %rbx
	leaq	10720(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$164:
	movq	%rbx, %r10
.L__keygen_internal$163:
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$161
	movq	%r11, %rbx
	leaq	11744(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$162:
	movq	%rbx, %r11
.L__keygen_internal$161:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$159
	movq	%rdx, %rbx
	leaq	12768(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$160:
	movq	%rbx, %rdx
.L__keygen_internal$159:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$157
	movq	%rsi, %rbx
	leaq	13792(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$158:
	movq	%rbx, %rsi
.L__keygen_internal$157:
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$150
	cmpq	$256, %r11
	jb  	.L__keygen_internal$152
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$154
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$148
	movq	$0, %rdi
.L__keygen_internal$156:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$154:
	movq	$0, %rdi
.L__keygen_internal$155:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$152:
	movq	$0, %rdi
.L__keygen_internal$153:
	jmp 	.L__keygen_internal$148
.L__keygen_internal$150:
	movq	$0, %rdi
.L__keygen_internal$151:
.L__keygen_internal$148:
	cmpq	$1, %rdi
	jne 	.L__keygen_internal$149
	leaq	96(%rsp), %rax
	movw	$8, %dx
	leaq	1344(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$147:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$146:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$145:
	leaq	14816(%rsp), %rbx
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$144:
	movq	%r12, %r10
	leaq	15840(%rsp), %rbx
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$143:
	movq	%r12, %r11
	leaq	16864(%rsp), %rbx
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$142:
	movq	%r12, %rdx
	leaq	17888(%rsp), %rbx
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$141:
	movq	%r12, %rsi
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$134
	cmpq	$256, %r11
	jb  	.L__keygen_internal$136
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$138
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$116
	movq	$0, %rdi
.L__keygen_internal$140:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$138:
	movq	$0, %rdi
.L__keygen_internal$139:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$136:
	movq	$0, %rdi
.L__keygen_internal$137:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$134:
	movq	$0, %rdi
.L__keygen_internal$135:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$117:
	movq	%r10, 95744(%rsp)
	movq	%r11, 95752(%rsp)
	movq	%rdx, 95760(%rsp)
	movq	%rsi, 95728(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$133:
	movq	95744(%rsp), %r10
	movq	95752(%rsp), %r11
	movq	95760(%rsp), %rdx
	movq	95728(%rsp), %rsi
	lfence
	movq	$0, %rax
	cmpq	$256, %r10
	jnb 	.L__keygen_internal$131
	movq	%r10, %rbx
	leaq	14816(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$132:
	movq	%rbx, %r10
.L__keygen_internal$131:
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$129
	movq	%r11, %rbx
	leaq	15840(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$130:
	movq	%rbx, %r11
.L__keygen_internal$129:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$127
	movq	%rdx, %rbx
	leaq	16864(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$128:
	movq	%rbx, %rdx
.L__keygen_internal$127:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$125
	movq	%rsi, %rbx
	leaq	17888(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$126:
	movq	%rbx, %rsi
.L__keygen_internal$125:
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$118
	cmpq	$256, %r11
	jb  	.L__keygen_internal$120
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$122
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$116
	movq	$0, %rdi
.L__keygen_internal$124:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$122:
	movq	$0, %rdi
.L__keygen_internal$123:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$120:
	movq	$0, %rdi
.L__keygen_internal$121:
	jmp 	.L__keygen_internal$116
.L__keygen_internal$118:
	movq	$0, %rdi
.L__keygen_internal$119:
.L__keygen_internal$116:
	cmpq	$1, %rdi
	jne 	.L__keygen_internal$117
	leaq	96(%rsp), %rax
	movw	$12, %dx
	leaq	1344(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$115:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$114:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$113:
	leaq	18912(%rsp), %rbx
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$112:
	movq	%r12, %r10
	leaq	19936(%rsp), %rbx
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$111:
	movq	%r12, %r11
	leaq	20960(%rsp), %rbx
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$110:
	movq	%r12, %rdx
	leaq	5600(%rsp), %rbx
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$109:
	movq	%r12, %rsi
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$102
	cmpq	$256, %r11
	jb  	.L__keygen_internal$104
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$106
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$84
	movq	$0, %rdi
.L__keygen_internal$108:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$106:
	movq	$0, %rdi
.L__keygen_internal$107:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$104:
	movq	$0, %rdi
.L__keygen_internal$105:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$102:
	movq	$0, %rdi
.L__keygen_internal$103:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$85:
	movq	%r10, 95728(%rsp)
	movq	%r11, 95760(%rsp)
	movq	%rdx, 95752(%rsp)
	movq	%rsi, 95744(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$101:
	movq	95728(%rsp), %r10
	movq	95760(%rsp), %r11
	movq	95752(%rsp), %rdx
	movq	95744(%rsp), %rsi
	lfence
	movq	$0, %rax
	cmpq	$256, %r10
	jnb 	.L__keygen_internal$99
	movq	%r10, %rbx
	leaq	18912(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$100:
	movq	%rbx, %r10
.L__keygen_internal$99:
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$97
	movq	%r11, %rbx
	leaq	19936(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$98:
	movq	%rbx, %r11
.L__keygen_internal$97:
	cmpq	$256, %rdx
	jnb 	.L__keygen_internal$95
	movq	%rdx, %rbx
	leaq	20960(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$96:
	movq	%rbx, %rdx
.L__keygen_internal$95:
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$93
	movq	%rsi, %rbx
	leaq	5600(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$94:
	movq	%rbx, %rsi
.L__keygen_internal$93:
	movq	$1, %rdi
	cmpq	$256, %r10
	jb  	.L__keygen_internal$86
	cmpq	$256, %r11
	jb  	.L__keygen_internal$88
	cmpq	$256, %rdx
	jb  	.L__keygen_internal$90
	cmpq	$256, %rsi
	jnb 	.L__keygen_internal$84
	movq	$0, %rdi
.L__keygen_internal$92:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$90:
	movq	$0, %rdi
.L__keygen_internal$91:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$88:
	movq	$0, %rdi
.L__keygen_internal$89:
	jmp 	.L__keygen_internal$84
.L__keygen_internal$86:
	movq	$0, %rdi
.L__keygen_internal$87:
.L__keygen_internal$84:
	cmpq	$1, %rdi
	jne 	.L__keygen_internal$85
	movq	95712(%rsp), %rdi
	movq	95720(%rsp), %rsi
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
	leaq	128(%rsi), %rdx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$83:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	96(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$82:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	192(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$81:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	288(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$80:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	384(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$79:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	480(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$78:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	576(%rdx), %rax
	leaq	6144(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$77:
	leaq	24(%rsp), %rsp
	leaq	13792(%rsp), %rcx
	leaq	800(%rsi), %rdx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$76:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	96(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$75:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	192(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$74:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	288(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$73:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	384(%rdx), %rax
	leaq	4096(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$72:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	480(%rdx), %rax
	leaq	5120(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$71:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	576(%rdx), %rax
	leaq	6144(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$70:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	672(%rdx), %rax
	leaq	7168(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$69:
	leaq	24(%rsp), %rsp
	movq	%rsi, 95720(%rsp)
	leaq	6624(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__keygen_internal$68:
	leaq	38368(%rsp), %rax
	leaq	6624(%rsp), %rcx
	leaq	13792(%rsp), %rdx
	leaq	21984(%rsp), %rsi
	movq	%rax, %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$66
.L__keygen_internal$67:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$66:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$67
	leaq	23008(%rsp), %rsi
	leaq	7168(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$64
.L__keygen_internal$65:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$64:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$65
	leaq	24032(%rsp), %rsi
	leaq	14336(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$62
.L__keygen_internal$63:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$62:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$63
	leaq	25056(%rsp), %rsi
	leaq	21504(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$60
.L__keygen_internal$61:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$60:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$61
	leaq	26080(%rsp), %rsi
	leaq	28672(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$58
.L__keygen_internal$59:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$58:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$59
	leaq	27104(%rsp), %rsi
	leaq	35840(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$56
.L__keygen_internal$57:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$56:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$57
	leaq	28128(%rsp), %rsi
	leaq	43008(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$54
.L__keygen_internal$55:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$54:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$55
	leaq	29152(%rsp), %rsi
	leaq	50176(%rax), %r8
	vmovdqu	glob_data + 8544(%rip), %ymm0
	vmovdqu	glob_data + 9184(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$52
.L__keygen_internal$53:
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
	vmovdqu	5120(%r8,%r9), %ymm4
	vmovdqu	5120(%rcx,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm6, %ymm5
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm3, %ymm3
	vmovdqu	6144(%r8,%r9), %ymm4
	vmovdqu	6144(%rcx,%r9), %ymm5
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
.L__keygen_internal$52:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$53
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
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
	leaq	7168(%rax), %rax
	vmovdqu	glob_data + 9152(%rip), %ymm0
	movq	$1, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$19
.L__keygen_internal$20:
	vmovdqu	(%rax,%r8), %ymm2
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
	leaq	13792(%rsp), %r10
	movq	%r10, %mm0
	movq	%rax, %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$18:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	320(%rax), %rcx
	leaq	1024(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$17:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	640(%rax), %rcx
	leaq	2048(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$16:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	960(%rax), %rcx
	leaq	3072(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$15:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	1280(%rax), %rcx
	leaq	4096(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$14:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	1600(%rax), %rcx
	leaq	5120(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$13:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	1920(%rax), %rcx
	leaq	6144(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$12:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	2240(%rax), %rcx
	leaq	7168(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$11:
	leaq	24(%rsp), %rsp
// declassify_mem 2592 [RDI]
	movq	%rdi, %rcx
	movq	95720(%rsp), %rsi
	lfence
	movq	$0, %rdx
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
	movq	$0, %rdx
	orq 	%rdx, %rdi
	orq 	%rdx, %rsi
	leaq	1568(%rsi), %rax
	leaq	21984(%rsp), %r10
	movq	%r10, %mm0
	movq	%rax, %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$9:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	416(%rax), %rcx
	leaq	1024(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$8:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	832(%rax), %rcx
	leaq	2048(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$7:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	1248(%rax), %rcx
	leaq	3072(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$6:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	1664(%rax), %rcx
	leaq	4096(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$5:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	2080(%rax), %rcx
	leaq	5120(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$4:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	2496(%rax), %rcx
	leaq	6144(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$3:
	leaq	24(%rsp), %rsp
	movq	%mm0, %r10
	leaq	2912(%rax), %rcx
	leaq	7168(%r10), %r10
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$2:
	leaq	24(%rsp), %rsp
	ret
.Lerror_4x__rejection_sample_one_block$1:
	lfence
	movq	$0, %rdi
	movq	$0, %r8
	movq	$0, %rbp
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$3:
	movq	$-1, %r9
	cmove	%r9, %rdi
	movzbl	(%rcx,%r8), %r9d
	andl	$15, %r9d
// declassify_val u32 %r9d
	orl 	%edi, %r9d
	cmpl	$15, %r9d
	jb  	.Lerror_4x__rejection_sample_one_block$12
	movq	$-1, %r9
	cmovb	%r9, %rdi
	jmp 	.Lerror_4x__rejection_sample_one_block$13
.Lerror_4x__rejection_sample_one_block$12:
	movq	$-1, %r12
	cmovnb	%r12, %rdi
	movl	%r9d, %r12d
	imull	$205, %r12d, %r12d
	shrl	$10, %r12d
	imull	$5, %r12d, %r12d
	subl	%r12d, %r9d
	addl	$-2, %r9d
	negl	%r9d
	movl	%r9d, (%rax,%rbx,4)
	incq	%rbx
.Lerror_4x__rejection_sample_one_block$13:
	cmpq	$256, %rbx
	jb  	.Lerror_4x__rejection_sample_one_block$8
	movq	$-1, %r9
	cmovb	%r9, %rdi
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$8:
	movq	$-1, %r9
	cmovnb	%r9, %rdi
	movzbl	(%rcx,%r8), %r9d
	shrl	$4, %r9d
// declassify_val u32 %r9d
	orl 	%edi, %r9d
	cmpl	$15, %r9d
	jb  	.Lerror_4x__rejection_sample_one_block$10
	movq	$-1, %r9
	cmovb	%r9, %rdi
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$10:
	movq	$-1, %r12
	cmovnb	%r12, %rdi
	movl	%r9d, %r12d
	imull	$205, %r12d, %r12d
	shrl	$10, %r12d
	imull	$5, %r12d, %r12d
	subl	%r12d, %r9d
	addl	$-2, %r9d
	negl	%r9d
	movl	%r9d, (%rax,%rbx,4)
	incq	%rbx
.Lerror_4x__rejection_sample_one_block$11:
.Lerror_4x__rejection_sample_one_block$9:
	incq	%r8
	cmpq	$136, %r8
	jnb 	.Lerror_4x__rejection_sample_one_block$4
	movq	$-1, %r9
	cmovnb	%r9, %rdi
	cmpq	$256, %rbx
	jnb 	.Lerror_4x__rejection_sample_one_block$6
	movq	$-1, %r9
	cmovnb	%r9, %rdi
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$6:
	movq	$-1, %r9
	cmovb	%r9, %rdi
	movq	$1, %rbp
.Lerror_4x__rejection_sample_one_block$7:
	jmp 	.Lerror_4x__rejection_sample_one_block$2
.Lerror_4x__rejection_sample_one_block$4:
	movq	$-1, %r9
	cmovb	%r9, %rdi
	movq	$1, %rbp
.Lerror_4x__rejection_sample_one_block$5:
.Lerror_4x__rejection_sample_one_block$2:
	cmpq	$1, %rbp
	jne 	.Lerror_4x__rejection_sample_one_block$3
	ret
.Lerror_4x__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %r13
	movq	$2, %rsi
	vmovq	%rsi, %xmm0
	vpbroadcastb	%xmm0, %ymm0
	movq	$15, %rsi
	vmovq	%rsi, %xmm1
	vpbroadcastb	%xmm1, %ymm1
	movq	$0, %r12
	movq	$0, %r8
	movq	$0, %rdi
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$19:
	movq	$-1, %r9
	cmove	%r9, %r13
	vmovdqu	(%rcx,%r8), %xmm2
	movq	$15, %rsi
	vmovq	%rsi, %xmm5
	vpbroadcastb	%xmm5, %ymm5
	vpmovzxbw	%xmm2, %ymm2
	vpsllw	$4, %ymm2, %ymm3
	vpor	%ymm3, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpsubb	%ymm1, %ymm2, %ymm3
	vpmovmskb	%ymm3, %eax
	vpsubb	%ymm2, %ymm0, %ymm2
	vextracti128	$0, %ymm2, %xmm3
// declassify_val u64 %rax
	orq 	%r13, %rax
	movq	%rax, %rbp
	andq	$255, %rbp
	shrq	$8, %rax
	leaq	glob_data + 9232(%rip), %r9
	movq	%rbp, %rsi
	shlq	$3, %rsi
	vmovq	(%r9,%rsi), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %rsi
	vmovq	%rsi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %rsi
	vmovq	%rsi, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rbx,%r12)
	popcnt	%rbp, %rsi
	shlq	$2, %rsi
	addq	%rsi, %r12
	addq	$4, %r8
	cmpq	$992, %r12
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$24
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$24:
	movq	$-1, %rsi
	cmovnb	%rsi, %r13
	vpsrldq	$8, %xmm3, %xmm3
	movq	%rax, %rsi
	andq	$255, %rsi
	shrq	$8, %rax
	leaq	glob_data + 9232(%rip), %r9
	movq	%rsi, %rbp
	shlq	$3, %rbp
	vmovq	(%r9,%rbp), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %r9
	vmovq	%r9, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %r9
	vmovq	%r9, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rbx,%r12)
	popcnt	%rsi, %rsi
	shlq	$2, %rsi
	addq	%rsi, %r12
	addq	$4, %r8
	cmpq	$992, %r12
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$26
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$26:
	movq	$-1, %rsi
	cmovnb	%rsi, %r13
	vextracti128	$1, %ymm2, %xmm3
	movq	%rax, %rbp
	andq	$255, %rbp
	shrq	$8, %rax
	leaq	glob_data + 9232(%rip), %r9
	movq	%rbp, %rsi
	shlq	$3, %rsi
	vmovq	(%r9,%rsi), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %rsi
	vmovq	%rsi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %rsi
	vmovq	%rsi, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rbx,%r12)
	popcnt	%rbp, %rsi
	shlq	$2, %rsi
	addq	%rsi, %r12
	addq	$4, %r8
	cmpq	$992, %r12
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$28
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$28:
	movq	$-1, %rsi
	cmovnb	%rsi, %r13
	vpsrldq	$8, %xmm3, %xmm3
	andq	$255, %rax
	leaq	glob_data + 9232(%rip), %r9
	movq	%rax, %rsi
	shlq	$3, %rsi
	vmovq	(%r9,%rsi), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %rsi
	vmovq	%rsi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %rsi
	vmovq	%rsi, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rbx,%r12)
	popcnt	%rax, %rax
	shlq	$2, %rax
	addq	%rax, %r12
	addq	$4, %r8
.Lerror_4x__rejection_sample_multiple_blocks$29:
.Lerror_4x__rejection_sample_multiple_blocks$27:
.Lerror_4x__rejection_sample_multiple_blocks$25:
	cmpq	$992, %r12
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$20
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %r8
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$22
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$22:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rdi
.Lerror_4x__rejection_sample_multiple_blocks$23:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$20:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rdi
.Lerror_4x__rejection_sample_multiple_blocks$21:
.Lerror_4x__rejection_sample_multiple_blocks$18:
	cmpq	$1, %rdi
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$19
	movq	$-1, %rax
	cmovne	%rax, %r13
	shrq	$2, %r12
	cmpq	$256, %r12
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$14
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$14:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$272, %r8
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$16
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$16:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movq	$0, %rdi
.Lerror_4x__rejection_sample_multiple_blocks$17:
.Lerror_4x__rejection_sample_multiple_blocks$15:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$3:
	movq	$-1, %rax
	cmove	%rax, %r13
	movzbl	(%rcx,%r8), %r9d
	andl	$15, %r9d
// declassify_val u32 %r9d
	orl 	%r13d, %r9d
	cmpl	$15, %r9d
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$12
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$13
.Lerror_4x__rejection_sample_multiple_blocks$12:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movl	%r9d, %eax
	imull	$205, %eax, %eax
	shrl	$10, %eax
	imull	$5, %eax, %eax
	subl	%eax, %r9d
	addl	$-2, %r9d
	negl	%r9d
	movl	%r9d, (%rbx,%r12,4)
	incq	%r12
.Lerror_4x__rejection_sample_multiple_blocks$13:
	cmpq	$256, %r12
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$8
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$8:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movzbl	(%rcx,%r8), %r9d
	shrl	$4, %r9d
// declassify_val u32 %r9d
	orl 	%r13d, %r9d
	cmpl	$15, %r9d
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$10
	movq	$-1, %rax
	cmovb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$10:
	movq	$-1, %rax
	cmovnb	%rax, %r13
	movl	%r9d, %eax
	imull	$205, %eax, %eax
	shrl	$10, %eax
	imull	$5, %eax, %eax
	subl	%eax, %r9d
	addl	$-2, %r9d
	negl	%r9d
	movl	%r9d, (%rbx,%r12,4)
	incq	%r12
.Lerror_4x__rejection_sample_multiple_blocks$11:
.Lerror_4x__rejection_sample_multiple_blocks$9:
	incq	%r8
	cmpq	$272, %r8
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$4
	movq	$-1, %rax
	cmovnb	%rax, %r13
	cmpq	$256, %r12
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$6
	movq	$-1, %rax
	cmovnb	%rax, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$6:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rdi
.Lerror_4x__rejection_sample_multiple_blocks$7:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$4:
	movq	$-1, %rax
	cmovb	%rax, %r13
	movq	$1, %rdi
.Lerror_4x__rejection_sample_multiple_blocks$5:
.Lerror_4x__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rdi
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$3
	ret
.Lt1__decode_polynomial$1:
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r8
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
	vmovdqu	%ymm2, (%r10,%r8)
	addq	$32, %r8
.Lt1__decode_polynomial$2:
	cmpq	$992, %r8
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
	vmovdqu	%ymm2, (%r10,%r8)
	ret
.Lt1__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lt1__encode_polynomial$3
.Lt1__encode_polynomial$4:
	vmovdqu	(%r10,%r9), %ymm2
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$5:
	vmovdqu	%xmm0, (%rcx,%r8)
	addq	$10, %r8
	addq	$32, %r9
.Lt1__encode_polynomial$3:
	cmpq	$992, %r9
	jb  	.Lt1__encode_polynomial$4
	vmovdqu	(%r10,%r9), %ymm2
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
	vmovdqu	glob_data + 160(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm0
	vmovdqu	glob_data + 192(%rip), %ymm2
	vpsllvd	%ymm2, %ymm0, %ymm0
	vpsrlq	$12, %ymm0, %ymm0
	vpermq	$8, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	vmovdqu	glob_data + 9216(%rip), %xmm1
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
	vmovdqu	glob_data + 9152(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	ret
.Lt0__encode_polynomial$1:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lt0__encode_polynomial$3
.Lt0__encode_polynomial$4:
	vmovdqu	(%r10,%r9), %ymm2
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$5:
	vmovdqu	%xmm0, (%rcx,%r8)
	addq	$13, %r8
	addq	$32, %r9
.Lt0__encode_polynomial$3:
	cmpq	$992, %r9
	jb  	.Lt0__encode_polynomial$4
	vmovdqu	(%r10,%r9), %ymm2
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
	vmovdqu	glob_data + 9152(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	vmovdqu	glob_data + 320(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm0
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
.Lpolynomial__subtract_to_intt_range$1:
	vmovdqu	glob_data + 9184(%rip), %ymm1
	vpaddd	%ymm1, %ymm1, %ymm0
	movq	$0, %r8
	jmp 	.Lpolynomial__subtract_to_intt_range$2
.Lpolynomial__subtract_to_intt_range$3:
	vmovdqu	(%rdx,%r8), %ymm2
	vmovdqu	(%r10,%r8), %ymm3
	vpsubd	%ymm3, %ymm2, %ymm2
	vpsrad	$31, %ymm2, %ymm3
	vpand	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm1, %ymm2, %ymm2
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.Lpolynomial__subtract_to_intt_range$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__subtract_to_intt_range$3
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
	movq	$0, %rdi
	lfence
	movq	$0, %rdx
	movb	$0, %r9b
	cmpq	$256, %r8
	jnb 	.Lmatrix_A__rejection_sample_one_block$10
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$10:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movb	$1, %r9b
.Lmatrix_A__rejection_sample_one_block$11:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$3:
	movq	$-1, %rsi
	cmove	%rsi, %rdx
	movzbl	(%rax,%rdi), %r9d
	incq	%rdi
	movzbl	(%rax,%rdi), %ebp
	incq	%rdi
	movzbl	(%rax,%rdi), %esi
	incq	%rdi
	shll	$8, %ebp
	orl 	%ebp, %r9d
	shll	$16, %esi
	orl 	%esi, %r9d
	andl	$8388607, %r9d
// declassify_val u32 %r9d
	orl 	%edx, %r9d
	cmpl	$8380417, %r9d
	jb  	.Lmatrix_A__rejection_sample_one_block$8
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_one_block$9
.Lmatrix_A__rejection_sample_one_block$8:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	movl	%r9d, (%rcx,%r8,4)
	incq	%r8
.Lmatrix_A__rejection_sample_one_block$9:
	movb	$0, %r9b
	cmpq	$256, %r8
	jnb 	.Lmatrix_A__rejection_sample_one_block$4
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	cmpq	$168, %rdi
	jnb 	.Lmatrix_A__rejection_sample_one_block$6
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$6:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movb	$1, %r9b
.Lmatrix_A__rejection_sample_one_block$7:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$4:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movb	$1, %r9b
.Lmatrix_A__rejection_sample_one_block$5:
.Lmatrix_A__rejection_sample_one_block$2:
	cmpb	$1, %r9b
	jne 	.Lmatrix_A__rejection_sample_one_block$3
	ret
.Lmatrix_A__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %rdx
	leaq	glob_data + 9232(%rip), %rsi
	movl	$-2004318072, %edi
	movq	$0, %r8
	movq	$0, %r9
	vmovdqu	glob_data + 9184(%rip), %ymm1
	vmovdqu	glob_data + 448(%rip), %ymm0
	vmovdqu	glob_data + 480(%rip), %ymm2
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$15:
	movq	$-1, %rbp
	cmovnb	%rbp, %rdx
	vmovdqu	(%rcx,%r9), %ymm3
	vpermq	$148, %ymm3, %ymm10
	vpshufb	%ymm0, %ymm10, %ymm10
	vpand	%ymm2, %ymm10, %ymm3
	addq	$24, %r9
	vpcmpgtd	%ymm3, %ymm1, %ymm4
	vpmovmskb	%ymm4, %ebp
// declassify_val u32 %ebp
	orl 	%edx, %ebp
	pext	%edi, %ebp, %ebp
	movl	%ebp, %ebp
	vmovq	(%rsi,%rbp,8), %xmm4
	vpmovzxbd	%xmm4, %ymm4
	vpermd	%ymm3, %ymm4, %ymm3
	vmovdqu	%ymm3, (%rax,%r8)
	popcnt	%rbp, %rbp
	shlq	$2, %rbp
	addq	%rbp, %r8
.Lmatrix_A__rejection_sample_multiple_blocks$14:
	cmpq	$768, %r9
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$15
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	shrq	$2, %r8
	movq	$1, %rdi
	cmpq	$256, %r8
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$10
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$10:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	cmpq	$838, %r9
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$12
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$12:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	movq	$0, %rdi
.Lmatrix_A__rejection_sample_multiple_blocks$13:
.Lmatrix_A__rejection_sample_multiple_blocks$11:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$3:
	movq	$-1, %rsi
	cmove	%rsi, %rdx
	movzbl	(%rcx,%r9), %esi
	incq	%r9
	movzbl	(%rcx,%r9), %edi
	incq	%r9
	movzbl	(%rcx,%r9), %ebp
	incq	%r9
	shll	$8, %edi
	orl 	%edi, %esi
	shll	$16, %ebp
	orl 	%ebp, %esi
	andl	$8388607, %esi
// declassify_val u32 %esi
	orl 	%edx, %esi
	cmpl	$8380417, %esi
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$8
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$9
.Lmatrix_A__rejection_sample_multiple_blocks$8:
	movq	$-1, %rdi
	cmovnb	%rdi, %rdx
	movl	%esi, (%rax,%r8,4)
	incq	%r8
.Lmatrix_A__rejection_sample_multiple_blocks$9:
	movq	$0, %rdi
	cmpq	$256, %r8
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$4
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	cmpq	$838, %r9
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$6
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$6:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %rdi
.Lmatrix_A__rejection_sample_multiple_blocks$7:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$4:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %rdi
.Lmatrix_A__rejection_sample_multiple_blocks$5:
.Lmatrix_A__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rdi
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$3
	ret
.Lshake256_squeezeblock4x$1:
	call	.L_keccakf1600_avx2x4_nat$1
.Lshake256_squeezeblock4x$6:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lshake256_squeezeblock4x$4
.Lshake256_squeezeblock4x$5:
	vmovdqu	(%rax,%r9,4), %ymm11
	vmovdqu	32(%rax,%r9,4), %ymm13
	vmovdqu	64(%rax,%r9,4), %ymm5
	vmovdqu	96(%rax,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	%ymm1, (%rdi,%r8)
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
	vmovdqu	(%rax,%r9,4), %ymm11
	vmovdqu	32(%rax,%r9,4), %ymm13
	vmovdqu	64(%rax,%r9,4), %ymm5
	vmovdqu	96(%rax,%r9,4), %ymm1
	addq	$32, %r9
	vperm2i128	$32, %ymm5, %ymm11, %ymm0
	vperm2i128	$32, %ymm1, %ymm13, %ymm2
	vperm2i128	$49, %ymm5, %ymm11, %ymm3
	vperm2i128	$49, %ymm1, %ymm13, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm4
	vpunpckhqdq	%ymm2, %ymm0, %ymm2
	vpunpcklqdq	%ymm1, %ymm3, %ymm0
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vmovdqu	%ymm4, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	%ymm1, (%rdi,%r8)
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
	vmovdqu	%ymm0, (%rcx,%rsi)
	addq	$32, %rsi
.Lshake256_absorb_66_4x$6:
	cmpq	$800, %rsi
	jb  	.Lshake256_absorb_66_4x$7
	movq	$0, %r8
	movq	$0, %rdi
	jmp 	.Lshake256_absorb_66_4x$4
.Lshake256_absorb_66_4x$5:
	vpbroadcastq	(%rax,%r8), %ymm0
	addq	$8, %r8
	vpxor	(%rcx,%rdi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx,%rdi)
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
	leaq	16(%rsp), %rax
	leaq	24(%rsp), %rdx
	leaq	32(%rsp), %rsi
	movq	$0, %r8
	movq	$32, %rdi
	jmp 	.Lshake256_absorb_66_4x$2
.Lshake256_absorb_66_4x$3:
	movq	(%r9,%r8), %r10
	xorq	%r10, (%rcx,%rdi,8)
	movq	(%rax,%r8), %r10
	xorq	%r10, 8(%rcx,%rdi,8)
	movq	(%rdx,%r8), %r10
	xorq	%r10, 16(%rcx,%rdi,8)
	movq	(%rsi,%r8), %r10
	addq	$8, %r8
	xorq	%r10, 24(%rcx,%rdi,8)
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
	xorq	%r10, (%rcx,%rdi,8)
	movq	$0, %r10
	movzwq	(%rax,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rcx,%rdi,8)
	movq	$0, %r10
	movzwq	(%rdx,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r10
	xorq	%r10, 16(%rcx,%rdi,8)
	movq	$0, %r10
	movzwq	(%rsi,%r8), %r9
	orq 	%r9, %r10
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r10
	xorq	%r10, 24(%rcx,%rdi,8)
	movq	$-9223372036854775808, %r9
	movq	%r9, 40(%rsp)
	vpbroadcastq	40(%rsp), %ymm0
	vpxor	512(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rcx)
	ret
.Lshake128_absorb_34_4x$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %r9
	jmp 	.Lshake128_absorb_34_4x$6
.Lshake128_absorb_34_4x$7:
	vmovdqu	%ymm0, (%rcx,%r9)
	addq	$32, %r9
.Lshake128_absorb_34_4x$6:
	cmpq	$800, %r9
	jb  	.Lshake128_absorb_34_4x$7
	movq	$0, %r8
	movq	$0, %rdi
	jmp 	.Lshake128_absorb_34_4x$4
.Lshake128_absorb_34_4x$5:
	vpbroadcastq	(%rsi,%r8), %ymm0
	addq	$8, %r8
	vpxor	(%rcx,%rdi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx,%rdi)
	addq	$32, %rdi
.Lshake128_absorb_34_4x$4:
	cmpq	$128, %rdi
	jb  	.Lshake128_absorb_34_4x$5
	movw	(%rdx), %r9w
	movw	%r9w, 8(%rsp)
	movw	2(%rdx), %r9w
	movw	%r9w, 16(%rsp)
	movw	4(%rdx), %r9w
	movw	%r9w, 24(%rsp)
	movw	6(%rdx), %r9w
	movw	%r9w, 32(%rsp)
	leaq	8(%rsp), %rdx
	leaq	16(%rsp), %rsi
	leaq	24(%rsp), %rdi
	leaq	32(%rsp), %r8
	movq	$0, %r9
	movq	$16, %r10
	jmp 	.Lshake128_absorb_34_4x$2
.Lshake128_absorb_34_4x$3:
	movq	(%rdx,%r9), %r11
	xorq	%r11, (%rcx,%r10,8)
	movq	(%rsi,%r9), %r11
	xorq	%r11, 8(%rcx,%r10,8)
	movq	(%rdi,%r9), %r11
	xorq	%r11, 16(%rcx,%r10,8)
	movq	(%r8,%r9), %r11
	addq	$8, %r9
	xorq	%r11, 24(%rcx,%r10,8)
	addq	$4, %r10
.Lshake128_absorb_34_4x$2:
	cmpq	$16, %r10
	jb  	.Lshake128_absorb_34_4x$3
	movq	$0, %r11
	movzwq	(%rdx,%r9), %rdx
	orq 	%rdx, %r11
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r11
	xorq	%r11, (%rcx,%r10,8)
	movq	$0, %r11
	movzwq	(%rsi,%r9), %rdx
	orq 	%rdx, %r11
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r11
	xorq	%r11, 8(%rcx,%r10,8)
	movq	$0, %r11
	movzwq	(%rdi,%r9), %rdx
	orq 	%rdx, %r11
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r11
	xorq	%r11, 16(%rcx,%r10,8)
	movq	$0, %r11
	movzwq	(%r8,%r9), %rdx
	orq 	%rdx, %r11
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r11
	xorq	%r11, 24(%rcx,%r10,8)
	movq	$-9223372036854775808, %r9
	movq	%r9, 40(%rsp)
	vpbroadcastq	40(%rsp), %ymm0
	vpxor	640(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 640(%rcx)
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
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	$0, %rsi
	jmp 	.L__derive_commitment_hash$6
.L__derive_commitment_hash$7:
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rdx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rdx,%r8), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rdx,%r8), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rdx,%r8), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %r8
	movq	%rdx, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$8:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	%mm4, %rsi
	incq	%rsi
.L__derive_commitment_hash$6:
	cmpq	$7, %rsi
	jb  	.L__derive_commitment_hash$7
	movq	$0, %r10
	movq	$31, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %r10
	xorq	%r10, (%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rdx
	leaq	32(%rsp), %rax
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__derive_commitment_hash$3
.L__derive_commitment_hash$4:
	incq	%rsi
	movq	%rdx, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdx,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdx,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdx,%r8)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdx,%r8)
	addq	$136, %r8
.L__derive_commitment_hash$3:
	cmpq	$0, %rsi
	jb  	.L__derive_commitment_hash$4
	movq	%rdx, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L__derive_commitment_hash$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rcx
	movq	%mm2, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%r8)
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
	movq	$0, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r8), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%r8), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%r8), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %r8
	movq	%rcx, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$9:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	$0, %rsi
	jmp 	.Lhash_verification_key$6
.Lhash_verification_key$7:
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rdx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rdx,%r8), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rdx,%r8), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rdx,%r8), %r10
	xorq	%r10, 128(%rax)
	addq	$136, %r8
	movq	%rdx, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$8:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	%mm4, %rsi
	incq	%rsi
.Lhash_verification_key$6:
	cmpq	$18, %rsi
	jb  	.Lhash_verification_key$7
	movq	(%rdx,%r8), %r10
	xorq	%r10, (%rax)
	movq	$0, %r10
	movq	$31, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %r10
	xorq	%r10, 8(%rax)
	xorb	$128, 135(%rax)
	movq	%mm0, %rdx
	leaq	32(%rsp), %rax
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.Lhash_verification_key$3
.Lhash_verification_key$4:
	incq	%rsi
	movq	%rdx, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdx
	movq	%mm2, %r8
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdx,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdx,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdx,%r8)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdx,%r8)
	addq	$136, %r8
.Lhash_verification_key$3:
	cmpq	$0, %rsi
	jb  	.Lhash_verification_key$4
	movq	%rdx, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lhash_verification_key$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rsi
	movq	%mm2, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rsi,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsi,%r8)
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
	leaq	32(%rsp), %rdx
	movq	$0, %r8
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rdx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %r10
	movzwq	64(%rdx,%r8), %rdx
	orq 	%rdx, %r10
	xorq	%r10, 64(%rax)
	movq	$66, %r10
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
	movq	$0, %r8
	vmovdqu	(%rax,%r8), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax,%r8), %ymm0
	vpxor	32(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax,%r8), %ymm0
	vpxor	64(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax,%r8), %ymm0
	vpxor	96(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	movq	$0, %rax
	movq	$31, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %rax
	xorq	%rax, 128(%rcx)
	xorb	$128, 135(%rcx)
	leaq	32(%rsp), %rax
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L_shake256_A64__A128$3
.L_shake256_A64__A128$4:
	incq	%rsi
	movq	%rdi, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %r8
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%r8)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdi,%r8)
	addq	$136, %r8
.L_shake256_A64__A128$3:
	cmpq	$0, %rsi
	jb  	.L_shake256_A64__A128$4
	movq	%rdi, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A64__A128$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r8)
	ret
.L_shake256_A128__A32_A2$1:
	leaq	32(%rsp), %rdi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, 32(%rdi)
	vmovdqu	%ymm0, 64(%rdi)
	vmovdqu	%ymm0, 96(%rdi)
	vmovdqu	%ymm0, 128(%rdi)
	vmovdqu	%ymm0, 160(%rdi)
	movq	$0, 192(%rdi)
	leaq	32(%rsp), %rdi
	movq	$0, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vpxor	(%rdi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi)
	leaq	32(%rsp), %rcx
	movq	$0, %r8
	movq	$0, %r10
	movzwq	(%rax,%r8), %rdx
	orq 	%rdx, %r10
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r10
	xorq	%r10, 32(%rcx)
	xorb	$128, 135(%rcx)
	leaq	32(%rsp), %rax
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L_shake256_A128__A32_A2$3
.L_shake256_A128__A32_A2$4:
	incq	%rsi
	movq	%r9, %mm1
	movq	%r8, %mm2
	movq	%rsi, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$5:
	leaq	200(%rsp), %rsp
	movq	%mm1, %r9
	movq	%mm2, %r8
	movq	%mm4, %rsi
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%r9,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%r9,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%r9,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%r9,%r8)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%r9,%r8)
	addq	$136, %r8
.L_shake256_A128__A32_A2$3:
	cmpq	$0, %rsi
	jb  	.L_shake256_A128__A32_A2$4
	movq	%r9, %mm1
	movq	%r8, %mm2
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A2$2:
	leaq	200(%rsp), %rsp
	movq	%mm1, %rdi
	movq	%mm2, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%r8)
	ret
.Lshake256_squeezeblock$1:
	movq	%rcx, %rax
	movq	%rcx, %mm0
	movq	%rdx, %mm1
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.Lshake256_squeezeblock$2:
	leaq	200(%rsp), %rsp
	movq	%mm0, %rax
	movq	%mm1, %rdx
	movq	$0, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdx,%r8)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdx,%r8)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdx,%r8)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdx,%r8)
	movq	128(%rax), %rcx
	movq	%rcx, 128(%rdx,%r8)
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
	movq	$0, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %r10
	movq	$31, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %r10
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
	movq	$0, %r9
	addq	%rbx, %rsi
	jmp 	.LA64___squeeze_state$3
.LA64___squeeze_state$4:
	call	.LA64___dump_updstate$1
.LA64___squeeze_state$6:
	movq	%rdi, %mm2
	movq	%rsi, %mm0
	movq	%r9, %mm1
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.LA64___squeeze_state$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm0, %rsi
	movq	%mm1, %r9
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
	movq	%rbx, %r8
	andq	$7, %r8
	cmpq	$0, %r8
	je  	.LA64___dump_updstate$12
	movq	%rdi, %r10
	subq	%rbx, %r10
	shrq	$3, %rbx
	shlq	$3, %rbx
	movq	(%rax,%rbx), %r11
	movb	%r8b, %cl
	shlb	$3, %cl
	shrq	%cl, %r11
	movq	%r9, %rcx
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
	addq	%r8, %r10
	cmpq	$8, %r10
	jnb 	.LA64___dump_updstate$13
	movq	%rcx, %r9
	movq	%rdi, %rbx
	jmp 	.LA64___dump_updstate$12
.LA64___dump_updstate$13:
	movq	$8, %r10
	subq	%r8, %r10
	addq	%r10, %r9
	addq	$8, %rbx
.LA64___dump_updstate$14:
.LA64___dump_updstate$12:
	movq	%rbx, %rcx
	jmp 	.LA64___dump_updstate$10
.LA64___dump_updstate$11:
	vmovdqu	(%rax,%rbx), %ymm0
	vmovdqu	%ymm0, (%rdx,%r9)
	addq	$32, %r9
	movq	%rcx, %rbx
.LA64___dump_updstate$10:
	addq	$32, %rcx
	cmpq	%rdi, %rcx
	jbe 	.LA64___dump_updstate$11
	addq	$-16, %rcx
	cmpq	%rdi, %rcx
	jnbe	.LA64___dump_updstate$9
	vmovdqu	(%rax,%rbx), %xmm0
	vmovdqu	%xmm0, (%rdx,%r9)
	movq	%rcx, %rbx
	addq	$16, %r9
.LA64___dump_updstate$9:
	movq	%rbx, %rcx
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	jnbe	.LA64___dump_updstate$8
	movq	(%rax,%rbx), %r11
	movq	%r11, (%rdx,%r9)
	addq	$8, %r9
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
	movl	%r11d, (%rdx,%r9)
	addq	$4, %r9
	shrq	$32, %r11
.LA64___dump_updstate$7:
	testq	$2, %r10
	je  	.LA64___dump_updstate$6
	movw	%r11w, (%rdx,%r9)
	addq	$2, %r9
	shrq	$16, %r11
.LA64___dump_updstate$6:
	testq	$1, %r10
	je  	.LA64___dump_updstate$2
	movb	%r11b, (%rdx,%r9)
	incq	%r9
.LA64___dump_updstate$5:
	jmp 	.LA64___dump_updstate$2
.LA64___dump_updstate$3:
	movq	%r11, (%rdx,%r9)
	addq	$8, %r9
.LA64___dump_updstate$4:
.LA64___dump_updstate$2:
	movq	%rdi, %r10
	ret
.L_finish_state$1:
	xorb	%al, (%rcx,%r10)
	xorb	$128, -1(%rcx,%rdi)
	ret
.L_absorb_m_state$1:
	addq	%r10, %rsi
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
	movq	$0, %r10
.L_absorb_m_state$3:
	cmpq	%rsi, %rdi
	jbe 	.L_absorb_m_state$4
	movq	%rsi, %rdi
	call	.L_add_m_updstate$1
.L_absorb_m_state$2:
	ret
.L_add_m_updstate$1:
	movq	%r10, %r8
	andq	$7, %r8
	cmpq	$0, %r8
	je  	.L_add_m_updstate$13
	movq	%rdi, %r9
	subq	%r10, %r9
	shrq	$3, %r10
	shlq	$3, %r10
	movq	%rdx, %r11
	cmpq	$8, %r9
	jnb 	.L_add_m_updstate$16
	testq	$4, %r9
	jne 	.L_add_m_updstate$20
	movq	$0, %rbx
	movb	$0, %cl
	jmp 	.L_add_m_updstate$21
.L_add_m_updstate$20:
	movl	(%r11), %ebx
	addq	$4, %r11
	movb	$32, %cl
.L_add_m_updstate$21:
	testq	$2, %r9
	je  	.L_add_m_updstate$19
	movzwq	(%r11), %rbp
	shlq	%cl, %rbp
	addq	%rbp, %rbx
	addq	$2, %r11
	addb	$16, %cl
.L_add_m_updstate$19:
	testq	$1, %r9
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
	addq	%r8, %r9
	movb	%r8b, %cl
	shlb	$3, %cl
	shlq	%cl, %rbx
	xorq	%rbx, (%rax,%r10)
	cmpq	$8, %r9
	jnb 	.L_add_m_updstate$14
	movq	%r11, %rdx
	movq	%rdi, %r10
	jmp 	.L_add_m_updstate$13
.L_add_m_updstate$14:
	movq	$8, %r9
	subq	%r8, %r9
	addq	%r9, %rdx
	addq	$8, %r10
.L_add_m_updstate$15:
.L_add_m_updstate$13:
	movq	%r10, %rcx
	jmp 	.L_add_m_updstate$11
.L_add_m_updstate$12:
	vmovdqu	(%rdx), %ymm0
	addq	$32, %rdx
	vpxor	(%rax,%r10), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r10)
	movq	%rcx, %r10
.L_add_m_updstate$11:
	addq	$32, %rcx
	cmpq	%rdi, %rcx
	jbe 	.L_add_m_updstate$12
	addq	$-16, %rcx
	cmpq	%rdi, %rcx
	jnbe	.L_add_m_updstate$10
	vmovdqu	(%rdx), %xmm0
	addq	$16, %rdx
	vpxor	(%rax,%r10), %xmm0, %xmm0
	vmovdqu	%xmm0, (%rax,%r10)
	movq	%rcx, %r10
.L_add_m_updstate$10:
	movq	%r10, %rcx
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	jnbe	.L_add_m_updstate$9
	movq	(%rdx), %r11
	addq	$8, %rdx
	xorq	%r11, (%rax,%r10)
	movq	%rcx, %r10
.L_add_m_updstate$9:
	cmpq	%rdi, %r10
	jnb 	.L_add_m_updstate$2
	movq	%rdi, %r9
	andq	$7, %r9
	cmpq	$8, %r9
	jnb 	.L_add_m_updstate$3
	testq	$4, %r9
	jne 	.L_add_m_updstate$7
	movq	$0, %r11
	movb	$0, %cl
	jmp 	.L_add_m_updstate$8
.L_add_m_updstate$7:
	movl	(%rdx), %r11d
	addq	$4, %rdx
	movb	$32, %cl
.L_add_m_updstate$8:
	testq	$2, %r9
	je  	.L_add_m_updstate$6
	movzwq	(%rdx), %r8
	shlq	%cl, %r8
	addq	%r8, %r11
	addq	$2, %rdx
	addb	$16, %cl
.L_add_m_updstate$6:
	testq	$1, %r9
	je  	.L_add_m_updstate$4
	movzbq	(%rdx), %r8
	shlq	%cl, %r8
	addq	%r8, %r11
	incq	%rdx
.L_add_m_updstate$5:
	jmp 	.L_add_m_updstate$4
.L_add_m_updstate$3:
	movq	(%rdx), %r11
	addq	$8, %rdx
.L_add_m_updstate$4:
	xorq	%r11, (%rax,%r10)
.L_add_m_updstate$2:
	movq	%rdi, %r10
	ret
.L_keccakf1600_x4_x1_nat_opt$1:
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movq	(%rcx), %r10
	movq	%r10, 832(%rsp)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	movq	8(%rcx), %r10
	movq	%r10, 840(%rsp)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rsp)
	movq	16(%rcx), %r10
	movq	%r10, 848(%rsp)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 128(%rsp)
	movq	24(%rcx), %r10
	movq	%r10, 856(%rsp)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 160(%rsp)
	movq	32(%rcx), %r10
	movq	%r10, 864(%rsp)
	vmovdqu	160(%rax), %ymm0
	vmovdqu	%ymm0, 192(%rsp)
	movq	40(%rcx), %r10
	movq	%r10, 872(%rsp)
	vmovdqu	192(%rax), %ymm0
	vmovdqu	%ymm0, 224(%rsp)
	movq	48(%rcx), %r10
	movq	%r10, 880(%rsp)
	vmovdqu	224(%rax), %ymm0
	vmovdqu	%ymm0, 256(%rsp)
	movq	56(%rcx), %r10
	movq	%r10, 888(%rsp)
	vmovdqu	256(%rax), %ymm0
	vmovdqu	%ymm0, 288(%rsp)
	movq	64(%rcx), %r10
	movq	%r10, 896(%rsp)
	vmovdqu	288(%rax), %ymm0
	vmovdqu	%ymm0, 320(%rsp)
	movq	72(%rcx), %r10
	movq	%r10, 904(%rsp)
	vmovdqu	320(%rax), %ymm0
	vmovdqu	%ymm0, 352(%rsp)
	movq	80(%rcx), %r10
	movq	%r10, 912(%rsp)
	vmovdqu	352(%rax), %ymm0
	vmovdqu	%ymm0, 384(%rsp)
	movq	88(%rcx), %r10
	movq	%r10, 920(%rsp)
	vmovdqu	384(%rax), %ymm0
	vmovdqu	%ymm0, 416(%rsp)
	movq	96(%rcx), %r10
	movq	%r10, 928(%rsp)
	vmovdqu	416(%rax), %ymm0
	vmovdqu	%ymm0, 448(%rsp)
	movq	104(%rcx), %r10
	movq	%r10, 936(%rsp)
	vmovdqu	448(%rax), %ymm0
	vmovdqu	%ymm0, 480(%rsp)
	movq	112(%rcx), %r10
	movq	%r10, 944(%rsp)
	vmovdqu	480(%rax), %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	movq	120(%rcx), %r10
	movq	%r10, 952(%rsp)
	vmovdqu	512(%rax), %ymm0
	vmovdqu	%ymm0, 544(%rsp)
	movq	128(%rcx), %r10
	movq	%r10, 960(%rsp)
	vmovdqu	544(%rax), %ymm0
	vmovdqu	%ymm0, 576(%rsp)
	movq	136(%rcx), %r10
	movq	%r10, 968(%rsp)
	vmovdqu	576(%rax), %ymm0
	vmovdqu	%ymm0, 608(%rsp)
	movq	144(%rcx), %r10
	movq	%r10, 976(%rsp)
	vmovdqu	608(%rax), %ymm0
	vmovdqu	%ymm0, 640(%rsp)
	movq	152(%rcx), %r10
	movq	%r10, 984(%rsp)
	vmovdqu	640(%rax), %ymm0
	vmovdqu	%ymm0, 672(%rsp)
	movq	160(%rcx), %r10
	movq	%r10, 992(%rsp)
	vmovdqu	672(%rax), %ymm0
	vmovdqu	%ymm0, 704(%rsp)
	movq	168(%rcx), %r10
	movq	%r10, 1000(%rsp)
	vmovdqu	704(%rax), %ymm0
	vmovdqu	%ymm0, 736(%rsp)
	movq	176(%rcx), %r10
	movq	%r10, 1008(%rsp)
	vmovdqu	736(%rax), %ymm0
	vmovdqu	%ymm0, 768(%rsp)
	movq	184(%rcx), %r10
	movq	%r10, 1016(%rsp)
	vmovdqu	768(%rax), %ymm0
	vmovdqu	%ymm0, 800(%rsp)
	movq	192(%rcx), %r10
	movq	%r10, 1024(%rsp)
	movq	%rax, %mm0
	movq	%rcx, %mm1
	leaq	32(%rsp), %rax
	vmovdqu	224(%rax), %ymm12
	vmovdqu	256(%rax), %ymm14
	vmovdqu	352(%rax), %ymm9
	vmovdqu	384(%rax), %ymm0
	vmovdqu	480(%rax), %ymm6
	vmovdqu	576(%rax), %ymm3
	vmovdqu	672(%rax), %ymm1
	vmovdqu	704(%rax), %ymm4
	vmovdqu	768(%rax), %ymm5
	leaq	832(%rsp), %rdx
	movq	(%rdx), %rax
	movq	80(%rdx), %r11
	movq	96(%rdx), %rcx
	movq	144(%rdx), %rsi
	movq	152(%rdx), %rbx
	movq	160(%rdx), %r10
	movq	168(%rdx), %r12
	movq	176(%rdx), %r8
	movq	192(%rdx), %r9
	movq	$0, %rdi
.L_keccakf1600_x4_x1_nat_opt$2:
	movq	%rdi, %rdx
	vmovdqu	192(%rsp), %ymm2
	vpxor	672(%rsp), %ymm6, %ymm11
	vmovdqu	%ymm6, 256(%rsp)
	vmovdqu	%ymm12, %ymm6
	vmovdqu	224(%rsp), %ymm10
	vmovdqu	544(%rsp), %ymm8
	vmovdqu	%ymm1, 384(%rsp)
	vpxor	352(%rsp), %ymm2, %ymm13
	vmovdqu	96(%rsp), %ymm12
	vmovdqu	%ymm2, 288(%rsp)
	vpxor	%ymm1, %ymm8, %ymm8
	vmovdqu	64(%rsp), %ymm7
	vmovdqu	480(%rsp), %ymm2
	vmovdqu	%ymm14, 608(%rsp)
	vpxor	%ymm13, %ymm11, %ymm11
	vpxor	%ymm9, %ymm10, %ymm13
	vpxor	576(%rsp), %ymm4, %ymm10
	vmovdqu	%ymm12, 512(%rsp)
	vpxor	%ymm13, %ymm8, %ymm8
	vpxor	%ymm0, %ymm6, %ymm13
	vmovdqu	320(%rsp), %ymm1
	vmovdqu	%ymm9, 416(%rsp)
	vpxor	%ymm13, %ymm10, %ymm10
	vpxor	448(%rsp), %ymm14, %ymm13
	vpxor	%ymm7, %ymm8, %ymm8
	vmovdqu	128(%rsp), %ymm9
	vpxor	%ymm12, %ymm10, %ymm10
	vpxor	768(%rsp), %ymm3, %ymm12
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm2, 704(%rsp)
	vpsrlq	$63, %ymm8, %ymm2
	vpsrlq	$63, %ymm10, %ymm15
	vpxor	32(%rsp), %ymm11, %ymm11
	vpxor	%ymm13, %ymm12, %ymm12
	vmovdqu	160(%rsp), %ymm14
	vpxor	%ymm9, %ymm12, %ymm12
	vpxor	640(%rsp), %ymm5, %ymm13
	vmovdqu	%ymm14, 736(%rsp)
	vpxor	%ymm1, %ymm13, %ymm13
	vpsllq	$1, %ymm8, %ymm1
	vpor	%ymm2, %ymm1, %ymm1
	vpsllq	$1, %ymm10, %ymm2
	vpxor	%ymm14, %ymm13, %ymm13
	vpor	%ymm15, %ymm2, %ymm2
	vpsrlq	$63, %ymm12, %ymm14
	vpxor	%ymm13, %ymm1, %ymm1
	vpsllq	$1, %ymm12, %ymm15
	vpxor	%ymm11, %ymm2, %ymm2
	vpor	%ymm14, %ymm15, %ymm15
	vpxor	%ymm7, %ymm2, %ymm7
	vpxor	%ymm8, %ymm15, %ymm15
	vpsrlq	$63, %ymm13, %ymm8
	vpsllq	$1, %ymm13, %ymm13
	vpxor	%ymm4, %ymm15, %ymm4
	vpxor	%ymm6, %ymm15, %ymm6
	vpor	%ymm8, %ymm13, %ymm13
	vpxor	32(%rsp), %ymm1, %ymm8
	vpxor	%ymm10, %ymm13, %ymm13
	vpsrlq	$63, %ymm11, %ymm10
	vpsllq	$1, %ymm11, %ymm11
	vpxor	%ymm3, %ymm13, %ymm3
	vpxor	%ymm9, %ymm13, %ymm9
	vpor	%ymm10, %ymm11, %ymm11
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	224(%rsp), %ymm2, %ymm12
	vpxor	%ymm5, %ymm11, %ymm5
	vpsrlq	$20, %ymm12, %ymm10
	vpsllq	$44, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpxor	%ymm0, %ymm15, %ymm10
	leaq	glob_data + 11280(%rip), %rbp
	vpbroadcastq	(%rbp,%rdx,8), %ymm0
	vpsrlq	$21, %ymm10, %ymm14
	vpsllq	$43, %ymm10, %ymm10
	vpor	%ymm14, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm14
	vpxor	%ymm0, %ymm14, %ymm14
	vpxor	%ymm8, %ymm14, %ymm0
	vpsrlq	$43, %ymm3, %ymm14
	vpsllq	$21, %ymm3, %ymm3
	vmovdqu	%ymm0, 32(%rsp)
	vpor	%ymm14, %ymm3, %ymm3
	vpandn	%ymm3, %ymm10, %ymm14
	vpxor	%ymm12, %ymm14, %ymm0
	vpsrlq	$50, %ymm5, %ymm14
	vpsllq	$14, %ymm5, %ymm5
	vmovdqu	%ymm0, 64(%rsp)
	vpor	%ymm14, %ymm5, %ymm5
	vpandn	%ymm5, %ymm3, %ymm14
	vpxor	%ymm10, %ymm14, %ymm10
	vmovdqu	%ymm10, 96(%rsp)
	vpandn	%ymm8, %ymm5, %ymm10
	vpandn	%ymm12, %ymm8, %ymm8
	vpxor	%ymm3, %ymm10, %ymm10
	vmovdqu	%ymm10, 128(%rsp)
	vpxor	%ymm5, %ymm8, %ymm10
	vpsrlq	$36, %ymm9, %ymm5
	vpsllq	$28, %ymm9, %ymm9
	vmovdqu	%ymm10, 160(%rsp)
	vpor	%ymm5, %ymm9, %ymm9
	vpxor	320(%rsp), %ymm11, %ymm5
	vpsrlq	$44, %ymm5, %ymm12
	vpsllq	$20, %ymm5, %ymm5
	vpor	%ymm12, %ymm5, %ymm5
	vpxor	352(%rsp), %ymm1, %ymm12
	vpsrlq	$61, %ymm12, %ymm10
	vpsllq	$3, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpandn	%ymm12, %ymm5, %ymm10
	vpxor	%ymm9, %ymm10, %ymm10
	vmovdqu	%ymm10, 192(%rsp)
	vpxor	544(%rsp), %ymm2, %ymm10
	vpsrlq	$19, %ymm10, %ymm8
	vpsllq	$45, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rsp)
	vpsrlq	$3, %ymm4, %ymm8
	vpsllq	$61, %ymm4, %ymm4
	vpor	%ymm8, %ymm4, %ymm4
	vpandn	%ymm4, %ymm10, %ymm8
	vpxor	%ymm12, %ymm8, %ymm12
	vpandn	%ymm9, %ymm4, %ymm8
	vpandn	%ymm5, %ymm9, %ymm9
	vpsrlq	$63, %ymm7, %ymm5
	vpsllq	$1, %ymm7, %ymm7
	vpxor	%ymm10, %ymm8, %ymm14
	vpor	%ymm5, %ymm7, %ymm7
	vpsrlq	$58, %ymm6, %ymm5
	vpxor	%ymm4, %ymm9, %ymm8
	vpsllq	$6, %ymm6, %ymm6
	vmovdqu	%ymm8, 320(%rsp)
	vpxor	640(%rsp), %ymm11, %ymm4
	vpor	%ymm5, %ymm6, %ymm6
	vpxor	448(%rsp), %ymm13, %ymm5
	vpshufb	glob_data + 512(%rip), %ymm4, %ymm4
	vpsrlq	$39, %ymm5, %ymm10
	vpsllq	$25, %ymm5, %ymm5
	vpor	%ymm5, %ymm10, %ymm10
	vpandn	%ymm10, %ymm6, %ymm5
	vpandn	%ymm4, %ymm10, %ymm9
	vpxor	%ymm7, %ymm5, %ymm8
	vpxor	672(%rsp), %ymm1, %ymm5
	vpxor	%ymm6, %ymm9, %ymm9
	vmovdqu	%ymm8, 352(%rsp)
	vpsrlq	$46, %ymm5, %ymm8
	vpsllq	$18, %ymm5, %ymm5
	vpor	%ymm5, %ymm8, %ymm5
	vpandn	%ymm5, %ymm4, %ymm8
	vpxor	%ymm10, %ymm8, %ymm0
	vpandn	%ymm7, %ymm5, %ymm10
	vpandn	%ymm6, %ymm7, %ymm7
	vpxor	%ymm4, %ymm10, %ymm8
	vmovdqu	%ymm8, 448(%rsp)
	vpxor	%ymm5, %ymm7, %ymm8
	vpxor	736(%rsp), %ymm11, %ymm7
	vpxor	704(%rsp), %ymm11, %ymm11
	vmovdqu	%ymm8, 480(%rsp)
	vpsrlq	$37, %ymm7, %ymm5
	vpsllq	$27, %ymm7, %ymm7
	vpor	%ymm7, %ymm5, %ymm5
	vpxor	288(%rsp), %ymm1, %ymm7
	vpxor	256(%rsp), %ymm1, %ymm1
	vpsrlq	$28, %ymm7, %ymm4
	vpsllq	$36, %ymm7, %ymm7
	vpor	%ymm7, %ymm4, %ymm4
	vpxor	416(%rsp), %ymm2, %ymm7
	vpxor	384(%rsp), %ymm2, %ymm2
	vpsrlq	$54, %ymm7, %ymm8
	vpsllq	$10, %ymm7, %ymm7
	vpor	%ymm7, %ymm8, %ymm8
	vpxor	576(%rsp), %ymm15, %ymm7
	vpxor	512(%rsp), %ymm15, %ymm15
	vpandn	%ymm8, %ymm4, %ymm6
	vpsrlq	$49, %ymm7, %ymm10
	vpsllq	$15, %ymm7, %ymm7
	vpxor	%ymm5, %ymm6, %ymm6
	vpor	%ymm7, %ymm10, %ymm10
	vpandn	%ymm10, %ymm8, %ymm7
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm7, 544(%rsp)
	vpxor	768(%rsp), %ymm13, %ymm7
	vpxor	608(%rsp), %ymm13, %ymm13
	vpshufb	glob_data + 544(%rip), %ymm7, %ymm7
	vpandn	%ymm7, %ymm10, %ymm3
	vpxor	%ymm8, %ymm3, %ymm3
	vmovdqu	%ymm3, 576(%rsp)
	vpandn	%ymm5, %ymm7, %ymm3
	vpandn	%ymm4, %ymm5, %ymm5
	vpxor	%ymm7, %ymm5, %ymm5
	vpsrlq	$62, %ymm2, %ymm7
	vpxor	%ymm10, %ymm3, %ymm3
	vmovdqu	%ymm5, 640(%rsp)
	vpsrlq	$2, %ymm15, %ymm5
	vpsllq	$62, %ymm15, %ymm15
	vpor	%ymm15, %ymm5, %ymm5
	vpsrlq	$9, %ymm13, %ymm15
	vpsllq	$55, %ymm13, %ymm13
	vpsllq	$2, %ymm2, %ymm2
	vpor	%ymm13, %ymm15, %ymm13
	vpsrlq	$25, %ymm11, %ymm15
	vpor	%ymm2, %ymm7, %ymm2
	vpsllq	$39, %ymm11, %ymm11
	vpor	%ymm11, %ymm15, %ymm15
	vpandn	%ymm15, %ymm13, %ymm11
	vpxor	%ymm5, %ymm11, %ymm11
	vmovdqu	%ymm11, 672(%rsp)
	vpsrlq	$23, %ymm1, %ymm11
	vpsllq	$41, %ymm1, %ymm1
	vpor	%ymm1, %ymm11, %ymm11
	vpandn	%ymm2, %ymm11, %ymm4
	vpandn	%ymm11, %ymm15, %ymm1
	vpxor	%ymm15, %ymm4, %ymm4
	vpandn	%ymm5, %ymm2, %ymm15
	vpandn	%ymm13, %ymm5, %ymm5
	vpxor	%ymm11, %ymm15, %ymm15
	vpxor	%ymm13, %ymm1, %ymm1
	vpxor	%ymm2, %ymm5, %ymm5
	vmovdqu	%ymm15, 768(%rsp)
	incq	%rdx
	movq	%rdx, %mm2
	movq	%rbx, 1032(%rsp)
	movq	%r11, 1040(%rsp)
	movq	%rdi, %mm3
	movq	%r12, 1048(%rsp)
	movq	952(%rsp), %rdx
	xorq	%r10, %rdx
	movq	%r11, %rdi
	xorq	872(%rsp), %rdi
	xorq	%rdx, %rdi
	movq	960(%rsp), %rdx
	xorq	%r12, %rdx
	movq	920(%rsp), %r14
	movq	880(%rsp), %r11
	xorq	%r11, %r14
	xorq	%rdx, %r14
	movq	968(%rsp), %rdx
	xorq	%r8, %rdx
	movq	%rcx, %rbp
	xorq	888(%rsp), %rbp
	xorq	%rdx, %rbp
	movq	%rsi, %r13
	xorq	1016(%rsp), %r13
	movq	936(%rsp), %rdx
	xorq	896(%rsp), %rdx
	xorq	%r13, %rdx
	xorq	%r9, %rbx
	movq	944(%rsp), %r15
	xorq	904(%rsp), %r15
	xorq	%rbx, %r15
	xorq	%rax, %rdi
	xorq	840(%rsp), %r14
	xorq	848(%rsp), %rbp
	movq	856(%rsp), %rbx
	xorq	%rbx, %rdx
	xorq	864(%rsp), %r15
	rorx	$63, %rdx, %r13
	xorq	%r14, %r13
	movq	%r13, 1112(%rsp)
	rorx	$63, %r14, %r12
	xorq	%r15, %r12
	movq	%r12, 1104(%rsp)
	rorx	$63, %r15, %r14
	xorq	%rbp, %r14
	rorx	$63, %rbp, %rbp
	xorq	%rdi, %rbp
	rorx	$63, %rdi, %rdi
	xorq	%rdx, %rdi
	xorq	%r12, %rax
	xorq	%rbp, %r11
	movq	%rbp, %r12
	rorx	$20, %r11, %r11
	xorq	%r13, %rcx
	rorx	$21, %rcx, %rcx
	xorq	%r14, %rsi
	rorx	$43, %rsi, %rdx
	xorq	%rdi, %r9
	rorx	$50, %r9, %r9
	andnq	%rax, %r9, %rsi
	xorq	%rdx, %rsi
	movq	%rsi, 880(%rsp)
	andnq	%rdx, %rcx, %rsi
	andnq	%r9, %rdx, %rdx
	xorq	%rcx, %rdx
	movq	%rdx, 1096(%rsp)
	andnq	%rcx, %r11, %rdx
	leaq	glob_data + 11280(%rip), %rcx
	movq	%mm3, %r15
	xorq	(%rcx,%r15,8), %rdx
	xorq	%rax, %rdx
	xorq	%r11, %rsi
	movq	%rsi, 1080(%rsp)
	andnq	%r11, %rax, %rcx
	xorq	%r9, %rcx
	movq	%rcx, 1088(%rsp)
	xorq	%r14, %rbx
	rorx	$36, %rbx, %r11
	movq	904(%rsp), %rsi
	xorq	%rdi, %rsi
	rorx	$44, %rsi, %rsi
	movq	1040(%rsp), %rax
	movq	1104(%rsp), %rcx
	xorq	%rcx, %rax
	rorx	$61, %rax, %rbx
	movq	960(%rsp), %rax
	movq	%r12, %r9
	xorq	%r12, %rax
	rorx	$19, %rax, %r13
	movq	1112(%rsp), %rax
	xorq	%rax, %r8
	rorx	$3, %r8, %r8
	andnq	%r11, %r8, %rbp
	xorq	%r13, %rbp
	movq	%rbp, 1040(%rsp)
	andnq	%r13, %rbx, %rbp
	andnq	%r8, %r13, %r13
	xorq	%rbx, %r13
	movq	%r13, 1072(%rsp)
	andnq	%rbx, %rsi, %rbx
	xorq	%r11, %rbx
	movq	%rbx, 960(%rsp)
	xorq	%rsi, %rbp
	movq	%rbp, 856(%rsp)
	andnq	%rsi, %r11, %rsi
	xorq	%r8, %rsi
	movq	%rsi, 904(%rsp)
	movq	840(%rsp), %rsi
	xorq	%r12, %rsi
	rorx	$63, %rsi, %rsi
	movq	888(%rsp), %r8
	xorq	%rax, %r8
	rorx	$58, %r8, %r8
	movq	936(%rsp), %r11
	xorq	%r14, %r11
	rorx	$39, %r11, %rbx
	movq	1032(%rsp), %r11
	xorq	%rdi, %r11
	rorx	$56, %r11, %r13
	movq	%rcx, %r11
	xorq	%rcx, %r10
	rorx	$46, %r10, %r10
	andnq	%rsi, %r10, %rcx
	xorq	%r13, %rcx
	movq	%rcx, 936(%rsp)
	andnq	%r13, %rbx, %r12
	andnq	%r10, %r13, %rcx
	xorq	%rbx, %rcx
	andnq	%rbx, %r8, %rbx
	xorq	%rsi, %rbx
	movq	%rbx, 888(%rsp)
	xorq	%r8, %r12
	movq	%r12, 1064(%rsp)
	andnq	%r8, %rsi, %rsi
	xorq	%r10, %rsi
	movq	%rsi, 1032(%rsp)
	movq	864(%rsp), %rsi
	xorq	%rdi, %rsi
	rorx	$37, %rsi, %rbx
	movq	872(%rsp), %r8
	xorq	%r11, %r8
	rorx	$28, %r8, %r12
	movq	920(%rsp), %r10
	xorq	%r9, %r10
	rorx	$54, %r10, %r10
	movq	968(%rsp), %rsi
	xorq	%rax, %rsi
	rorx	$49, %rsi, %r13
	movq	1016(%rsp), %rsi
	xorq	%r14, %rsi
	rorx	$8, %rsi, %rbp
	andnq	%rbx, %rbp, %rsi
	xorq	%r13, %rsi
	andnq	%r13, %r10, %r8
	andnq	%rbp, %r13, %r13
	xorq	%r10, %r13
	movq	%r13, 968(%rsp)
	andnq	%r10, %r12, %r10
	xorq	%rbx, %r10
	movq	%r10, 1016(%rsp)
	xorq	%r12, %r8
	movq	%r8, 872(%rsp)
	andnq	%r12, %rbx, %rbx
	xorq	%rbp, %rbx
	movq	%rbx, 920(%rsp)
	xorq	848(%rsp), %rax
	xorq	896(%rsp), %r14
	xorq	944(%rsp), %rdi
	movq	%r11, %rbx
	xorq	952(%rsp), %rbx
	xorq	1048(%rsp), %r9
	rorx	$2, %rax, %r11
	rorx	$9, %r14, %r13
	rorx	$25, %rdi, %rbp
	rorx	$23, %rbx, %rax
	rorx	$62, %r9, %r14
	andnq	%r11, %r14, %rdi
	xorq	%rax, %rdi
	movq	%rdi, 952(%rsp)
	andnq	%rax, %rbp, %r9
	andnq	%r14, %rax, %rax
	xorq	%rbp, %rax
	andnq	%rbp, %r13, %rbx
	xorq	%r11, %rbx
	movq	%rbx, %rbp
	movq	%rbx, 944(%rsp)
	xorq	%r13, %r9
	movq	%r9, 1048(%rsp)
	andnq	%r13, %r11, %r11
	xorq	%r14, %r11
	movq	%mm2, %rbx
	vmovdqu	192(%rsp), %ymm2
	vpxor	672(%rsp), %ymm6, %ymm11
	vmovdqu	%ymm6, 256(%rsp)
	vmovdqu	%ymm12, %ymm6
	vmovdqu	224(%rsp), %ymm10
	vmovdqu	544(%rsp), %ymm8
	vmovdqu	%ymm1, 384(%rsp)
	vpxor	352(%rsp), %ymm2, %ymm13
	vmovdqu	96(%rsp), %ymm12
	vmovdqu	%ymm2, 288(%rsp)
	vpxor	%ymm1, %ymm8, %ymm8
	vmovdqu	64(%rsp), %ymm7
	vmovdqu	480(%rsp), %ymm2
	vmovdqu	%ymm14, 608(%rsp)
	vpxor	%ymm13, %ymm11, %ymm11
	vpxor	%ymm9, %ymm10, %ymm13
	vpxor	576(%rsp), %ymm4, %ymm10
	vmovdqu	%ymm12, 512(%rsp)
	vpxor	%ymm13, %ymm8, %ymm8
	vpxor	%ymm0, %ymm6, %ymm13
	vmovdqu	320(%rsp), %ymm1
	vmovdqu	%ymm9, 416(%rsp)
	vpxor	%ymm13, %ymm10, %ymm10
	vpxor	448(%rsp), %ymm14, %ymm13
	vpxor	%ymm7, %ymm8, %ymm8
	vmovdqu	128(%rsp), %ymm9
	vpxor	%ymm12, %ymm10, %ymm10
	vpxor	768(%rsp), %ymm3, %ymm12
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm2, 704(%rsp)
	vpsrlq	$63, %ymm8, %ymm2
	vpsrlq	$63, %ymm10, %ymm15
	vpxor	32(%rsp), %ymm11, %ymm11
	vpxor	%ymm13, %ymm12, %ymm12
	vmovdqu	160(%rsp), %ymm14
	vpxor	%ymm9, %ymm12, %ymm12
	vpxor	640(%rsp), %ymm5, %ymm13
	vmovdqu	%ymm14, 736(%rsp)
	vpxor	%ymm1, %ymm13, %ymm13
	vpsllq	$1, %ymm8, %ymm1
	vpor	%ymm2, %ymm1, %ymm1
	vpsllq	$1, %ymm10, %ymm2
	vpxor	%ymm14, %ymm13, %ymm13
	vpor	%ymm15, %ymm2, %ymm2
	vpsrlq	$63, %ymm12, %ymm14
	vpxor	%ymm13, %ymm1, %ymm1
	vpsllq	$1, %ymm12, %ymm15
	vpxor	%ymm11, %ymm2, %ymm2
	vpor	%ymm14, %ymm15, %ymm15
	vpxor	%ymm7, %ymm2, %ymm7
	vpxor	%ymm8, %ymm15, %ymm15
	vpsrlq	$63, %ymm13, %ymm8
	vpsllq	$1, %ymm13, %ymm13
	vpxor	%ymm4, %ymm15, %ymm4
	vpxor	%ymm6, %ymm15, %ymm6
	vpor	%ymm8, %ymm13, %ymm13
	vpxor	32(%rsp), %ymm1, %ymm8
	vpxor	%ymm10, %ymm13, %ymm13
	vpsrlq	$63, %ymm11, %ymm10
	vpsllq	$1, %ymm11, %ymm11
	vpxor	%ymm3, %ymm13, %ymm3
	vpxor	%ymm9, %ymm13, %ymm9
	vpor	%ymm10, %ymm11, %ymm11
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	224(%rsp), %ymm2, %ymm12
	vpxor	%ymm5, %ymm11, %ymm5
	vpsrlq	$20, %ymm12, %ymm10
	vpsllq	$44, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpxor	%ymm0, %ymm15, %ymm10
	leaq	glob_data + 11280(%rip), %r12
	vpbroadcastq	(%r12,%rbx,8), %ymm0
	vpsrlq	$21, %ymm10, %ymm14
	vpsllq	$43, %ymm10, %ymm10
	vpor	%ymm14, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm14
	vpxor	%ymm0, %ymm14, %ymm14
	vpxor	%ymm8, %ymm14, %ymm0
	vpsrlq	$43, %ymm3, %ymm14
	vpsllq	$21, %ymm3, %ymm3
	vmovdqu	%ymm0, 32(%rsp)
	vpor	%ymm14, %ymm3, %ymm3
	vpandn	%ymm3, %ymm10, %ymm14
	vpxor	%ymm12, %ymm14, %ymm0
	vpsrlq	$50, %ymm5, %ymm14
	vpsllq	$14, %ymm5, %ymm5
	vmovdqu	%ymm0, 64(%rsp)
	vpor	%ymm14, %ymm5, %ymm5
	vpandn	%ymm5, %ymm3, %ymm14
	vpxor	%ymm10, %ymm14, %ymm10
	vmovdqu	%ymm10, 96(%rsp)
	vpandn	%ymm8, %ymm5, %ymm10
	vpandn	%ymm12, %ymm8, %ymm8
	vpxor	%ymm3, %ymm10, %ymm10
	vmovdqu	%ymm10, 128(%rsp)
	vpxor	%ymm5, %ymm8, %ymm10
	vpsrlq	$36, %ymm9, %ymm5
	vpsllq	$28, %ymm9, %ymm9
	vmovdqu	%ymm10, 160(%rsp)
	vpor	%ymm5, %ymm9, %ymm9
	vpxor	320(%rsp), %ymm11, %ymm5
	vpsrlq	$44, %ymm5, %ymm12
	vpsllq	$20, %ymm5, %ymm5
	vpor	%ymm12, %ymm5, %ymm5
	vpxor	352(%rsp), %ymm1, %ymm12
	vpsrlq	$61, %ymm12, %ymm10
	vpsllq	$3, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpandn	%ymm12, %ymm5, %ymm10
	vpxor	%ymm9, %ymm10, %ymm10
	vmovdqu	%ymm10, 192(%rsp)
	vpxor	544(%rsp), %ymm2, %ymm10
	vpsrlq	$19, %ymm10, %ymm8
	vpsllq	$45, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 224(%rsp)
	vpsrlq	$3, %ymm4, %ymm8
	vpsllq	$61, %ymm4, %ymm4
	vpor	%ymm8, %ymm4, %ymm4
	vpandn	%ymm4, %ymm10, %ymm8
	vpxor	%ymm12, %ymm8, %ymm12
	vpandn	%ymm9, %ymm4, %ymm8
	vpandn	%ymm5, %ymm9, %ymm9
	vpsrlq	$63, %ymm7, %ymm5
	vpsllq	$1, %ymm7, %ymm7
	vpxor	%ymm10, %ymm8, %ymm14
	vpor	%ymm5, %ymm7, %ymm7
	vpsrlq	$58, %ymm6, %ymm5
	vpxor	%ymm4, %ymm9, %ymm8
	vpsllq	$6, %ymm6, %ymm6
	vmovdqu	%ymm8, 320(%rsp)
	vpxor	640(%rsp), %ymm11, %ymm4
	vpor	%ymm5, %ymm6, %ymm6
	vpxor	448(%rsp), %ymm13, %ymm5
	vpshufb	glob_data + 512(%rip), %ymm4, %ymm4
	vpsrlq	$39, %ymm5, %ymm10
	vpsllq	$25, %ymm5, %ymm5
	vpor	%ymm5, %ymm10, %ymm10
	vpandn	%ymm10, %ymm6, %ymm5
	vpandn	%ymm4, %ymm10, %ymm9
	vpxor	%ymm7, %ymm5, %ymm8
	vpxor	672(%rsp), %ymm1, %ymm5
	vpxor	%ymm6, %ymm9, %ymm9
	vmovdqu	%ymm8, 352(%rsp)
	vpsrlq	$46, %ymm5, %ymm8
	vpsllq	$18, %ymm5, %ymm5
	vpor	%ymm5, %ymm8, %ymm5
	vpandn	%ymm5, %ymm4, %ymm8
	vpxor	%ymm10, %ymm8, %ymm0
	vpandn	%ymm7, %ymm5, %ymm10
	vpandn	%ymm6, %ymm7, %ymm7
	vpxor	%ymm4, %ymm10, %ymm8
	vmovdqu	%ymm8, 448(%rsp)
	vpxor	%ymm5, %ymm7, %ymm8
	vpxor	736(%rsp), %ymm11, %ymm7
	vpxor	704(%rsp), %ymm11, %ymm11
	vmovdqu	%ymm8, 480(%rsp)
	vpsrlq	$37, %ymm7, %ymm5
	vpsllq	$27, %ymm7, %ymm7
	vpor	%ymm7, %ymm5, %ymm5
	vpxor	288(%rsp), %ymm1, %ymm7
	vpxor	256(%rsp), %ymm1, %ymm1
	vpsrlq	$28, %ymm7, %ymm4
	vpsllq	$36, %ymm7, %ymm7
	vpor	%ymm7, %ymm4, %ymm4
	vpxor	416(%rsp), %ymm2, %ymm7
	vpxor	384(%rsp), %ymm2, %ymm2
	vpsrlq	$54, %ymm7, %ymm8
	vpsllq	$10, %ymm7, %ymm7
	vpor	%ymm7, %ymm8, %ymm8
	vpxor	576(%rsp), %ymm15, %ymm7
	vpxor	512(%rsp), %ymm15, %ymm15
	vpandn	%ymm8, %ymm4, %ymm6
	vpsrlq	$49, %ymm7, %ymm10
	vpsllq	$15, %ymm7, %ymm7
	vpxor	%ymm5, %ymm6, %ymm6
	vpor	%ymm7, %ymm10, %ymm10
	vpandn	%ymm10, %ymm8, %ymm7
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm7, 544(%rsp)
	vpxor	768(%rsp), %ymm13, %ymm7
	vpxor	608(%rsp), %ymm13, %ymm13
	vpshufb	glob_data + 544(%rip), %ymm7, %ymm7
	vpandn	%ymm7, %ymm10, %ymm3
	vpxor	%ymm8, %ymm3, %ymm3
	vmovdqu	%ymm3, 576(%rsp)
	vpandn	%ymm5, %ymm7, %ymm3
	vpandn	%ymm4, %ymm5, %ymm5
	vpxor	%ymm7, %ymm5, %ymm5
	vpsrlq	$62, %ymm2, %ymm7
	vpxor	%ymm10, %ymm3, %ymm3
	vmovdqu	%ymm5, 640(%rsp)
	vpsrlq	$2, %ymm15, %ymm5
	vpsllq	$62, %ymm15, %ymm15
	vpor	%ymm15, %ymm5, %ymm5
	vpsrlq	$9, %ymm13, %ymm15
	vpsllq	$55, %ymm13, %ymm13
	vpsllq	$2, %ymm2, %ymm2
	vpor	%ymm13, %ymm15, %ymm13
	vpsrlq	$25, %ymm11, %ymm15
	vpor	%ymm2, %ymm7, %ymm2
	vpsllq	$39, %ymm11, %ymm11
	vpor	%ymm11, %ymm15, %ymm15
	vpandn	%ymm15, %ymm13, %ymm11
	vpxor	%ymm5, %ymm11, %ymm11
	vmovdqu	%ymm11, 672(%rsp)
	vpsrlq	$23, %ymm1, %ymm11
	vpsllq	$41, %ymm1, %ymm1
	vpor	%ymm1, %ymm11, %ymm11
	vpandn	%ymm2, %ymm11, %ymm4
	vpandn	%ymm11, %ymm15, %ymm1
	vpxor	%ymm15, %ymm4, %ymm4
	vpandn	%ymm5, %ymm2, %ymm15
	vpandn	%ymm13, %ymm5, %ymm5
	vpxor	%ymm11, %ymm15, %ymm15
	vpxor	%ymm13, %ymm1, %ymm1
	vpxor	%ymm2, %ymm5, %ymm5
	vmovdqu	%ymm15, 768(%rsp)
	xorq	888(%rsp), %r10
	movq	960(%rsp), %rbx
	xorq	%rbp, %rbx
	xorq	%r10, %rbx
	movq	856(%rsp), %rbp
	movq	%rbp, %r10
	xorq	1080(%rsp), %r10
	movq	%r8, %r13
	xorq	1064(%rsp), %r13
	xorq	%r10, %r13
	movq	1072(%rsp), %r8
	xorq	968(%rsp), %r8
	movq	%rax, %r10
	xorq	1096(%rsp), %r10
	xorq	%r8, %r10
	movq	936(%rsp), %r8
	xorq	1040(%rsp), %r8
	movq	%rdi, %r14
	xorq	880(%rsp), %r14
	xorq	%r8, %r14
	movq	1088(%rsp), %r8
	xorq	%r11, %r8
	movq	1032(%rsp), %rdi
	xorq	904(%rsp), %rdi
	xorq	%r8, %rdi
	xorq	%rdx, %rbx
	xorq	%r9, %r13
	xorq	%rcx, %r10
	xorq	%rsi, %r14
	movq	920(%rsp), %r15
	xorq	%r15, %rdi
	rorx	$63, %r14, %r8
	xorq	%r13, %r8
	rorx	$63, %r13, %r9
	xorq	%rdi, %r9
	rorx	$63, %rdi, %rdi
	xorq	%r10, %rdi
	rorx	$63, %r10, %r10
	xorq	%rbx, %r10
	rorx	$63, %rbx, %r13
	xorq	%r14, %r13
	xorq	%r9, %rdx
	xorq	%r10, %rbp
	rorx	$20, %rbp, %rbp
	xorq	%r8, %rcx
	rorx	$21, %rcx, %rcx
	xorq	%rdi, %rsi
	rorx	$43, %rsi, %rbx
	xorq	%r13, %r11
	rorx	$50, %r11, %r11
	andnq	%rdx, %r11, %rsi
	xorq	%rbx, %rsi
	movq	%rsi, 856(%rsp)
	andnq	%rbx, %rcx, %rsi
	andnq	%r11, %rbx, %rbx
	xorq	%rcx, %rbx
	movq	%rbx, 848(%rsp)
	andnq	%rcx, %rbp, %rcx
	movq	%mm3, %r14
	leaq	glob_data + 11280(%rip), %rbx
	xorq	8(%rbx,%r14,8), %rcx
	xorq	%rdx, %rcx
	movq	%rcx, 1104(%rsp)
	xorq	%rbp, %rsi
	movq	%rsi, 840(%rsp)
	andnq	%rbp, %rdx, %rcx
	xorq	%r11, %rcx
	movq	%rcx, 864(%rsp)
	movq	880(%rsp), %rcx
	xorq	%rdi, %rcx
	rorx	$36, %rcx, %rcx
	movq	904(%rsp), %rdx
	xorq	%r13, %rdx
	rorx	$44, %rdx, %rdx
	movq	888(%rsp), %rsi
	xorq	%r9, %rsi
	rorx	$61, %rsi, %rsi
	movq	872(%rsp), %r11
	xorq	%r10, %r11
	rorx	$19, %r11, %r11
	xorq	%r8, %rax
	rorx	$3, %rax, %rax
	andnq	%rcx, %rax, %rbx
	xorq	%r11, %rbx
	movq	%rbx, 896(%rsp)
	andnq	%r11, %rsi, %rbx
	andnq	%rax, %r11, %r11
	xorq	%rsi, %r11
	movq	%r11, 888(%rsp)
	andnq	%rsi, %rdx, %rsi
	xorq	%rcx, %rsi
	movq	%rsi, 872(%rsp)
	xorq	%rdx, %rbx
	movq	%rbx, 880(%rsp)
	andnq	%rdx, %rcx, %rcx
	xorq	%rax, %rcx
	movq	%rcx, 904(%rsp)
	movq	1080(%rsp), %rax
	xorq	%r10, %rax
	rorx	$63, %rax, %rax
	movq	1072(%rsp), %rcx
	xorq	%r8, %rcx
	rorx	$58, %rcx, %rdx
	movq	936(%rsp), %rsi
	xorq	%rdi, %rsi
	rorx	$39, %rsi, %rsi
	xorq	%r13, %r15
	rorx	$56, %r15, %r11
	movq	944(%rsp), %rcx
	xorq	%r9, %rcx
	rorx	$46, %rcx, %rbx
	andnq	%rax, %rbx, %rcx
	xorq	%r11, %rcx
	movq	%rcx, 936(%rsp)
	andnq	%r11, %rsi, %r12
	andnq	%rbx, %r11, %rcx
	xorq	%rsi, %rcx
	andnq	%rsi, %rdx, %r11
	xorq	%rax, %r11
	xorq	%rdx, %r12
	movq	%r12, 920(%rsp)
	andnq	%rdx, %rax, %rax
	xorq	%rbx, %rax
	movq	%rax, 944(%rsp)
	movq	1088(%rsp), %rax
	xorq	%r13, %rax
	rorx	$37, %rax, %rax
	movq	960(%rsp), %rdx
	xorq	%r9, %rdx
	rorx	$28, %rdx, %rdx
	movq	1064(%rsp), %rsi
	xorq	%r10, %rsi
	rorx	$54, %rsi, %rbx
	movq	968(%rsp), %rsi
	xorq	%r8, %rsi
	rorx	$49, %rsi, %r15
	movq	952(%rsp), %rsi
	xorq	%rdi, %rsi
	rorx	$8, %rsi, %rbp
	andnq	%rax, %rbp, %rsi
	xorq	%r15, %rsi
	andnq	%r15, %rbx, %r12
	andnq	%rbp, %r15, %r15
	xorq	%rbx, %r15
	movq	%r15, 968(%rsp)
	andnq	%rbx, %rdx, %rbx
	xorq	%rax, %rbx
	movq	%rbx, 952(%rsp)
	xorq	%rdx, %r12
	movq	%r12, 960(%rsp)
	andnq	%rdx, %rax, %rbx
	xorq	%rbp, %rbx
	xorq	1096(%rsp), %r8
	xorq	1040(%rsp), %rdi
	xorq	1032(%rsp), %r13
	xorq	1016(%rsp), %r9
	xorq	1048(%rsp), %r10
	rorx	$2, %r8, %rax
	rorx	$9, %rdi, %rdx
	rorx	$25, %r13, %rdi
	rorx	$23, %r9, %r8
	rorx	$62, %r10, %r15
	andnq	%rax, %r15, %r10
	xorq	%r8, %r10
	movq	%r10, 1016(%rsp)
	andnq	%r8, %rdi, %r12
	andnq	%r15, %r8, %r8
	xorq	%rdi, %r8
	andnq	%rdi, %rdx, %r10
	xorq	%rax, %r10
	xorq	%rdx, %r12
	andnq	%rdx, %rax, %r9
	xorq	%r15, %r9
	movq	%mm3, %rdx
	addq	$2, %rdx
	movq	%rdx, %rdi
	movq	1104(%rsp), %rax
	cmpq	$24, %rdi
	jb  	.L_keccakf1600_x4_x1_nat_opt$2
	leaq	32(%rsp), %rdi
	vmovdqu	%ymm12, 224(%rdi)
	vmovdqu	%ymm14, 256(%rdi)
	vmovdqu	%ymm9, 352(%rdi)
	vmovdqu	%ymm0, 384(%rdi)
	vmovdqu	%ymm6, 480(%rdi)
	vmovdqu	%ymm3, 576(%rdi)
	vmovdqu	%ymm1, 672(%rdi)
	vmovdqu	%ymm4, 704(%rdi)
	vmovdqu	%ymm5, 768(%rdi)
	leaq	832(%rsp), %rdx
	movq	%rax, (%rdx)
	movq	%r11, 80(%rdx)
	movq	%rcx, 96(%rdx)
	movq	%rsi, 144(%rdx)
	movq	%rbx, 152(%rdx)
	movq	%r10, 160(%rdx)
	movq	%r12, 168(%rdx)
	movq	%r8, 176(%rdx)
	movq	%r9, 192(%rdx)
	movq	%mm0, %rax
	movq	%mm1, %rcx
	vmovdqu	32(%rsp), %ymm0
	vmovdqu	%ymm0, (%rax)
	movq	832(%rsp), %r10
	movq	%r10, (%rcx)
	vmovdqu	64(%rsp), %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	840(%rsp), %r10
	movq	%r10, 8(%rcx)
	vmovdqu	96(%rsp), %ymm0
	vmovdqu	%ymm0, 64(%rax)
	movq	848(%rsp), %r10
	movq	%r10, 16(%rcx)
	vmovdqu	128(%rsp), %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	856(%rsp), %r10
	movq	%r10, 24(%rcx)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	%ymm0, 128(%rax)
	movq	864(%rsp), %r10
	movq	%r10, 32(%rcx)
	vmovdqu	192(%rsp), %ymm0
	vmovdqu	%ymm0, 160(%rax)
	movq	872(%rsp), %r10
	movq	%r10, 40(%rcx)
	vmovdqu	224(%rsp), %ymm0
	vmovdqu	%ymm0, 192(%rax)
	movq	880(%rsp), %r10
	movq	%r10, 48(%rcx)
	vmovdqu	256(%rsp), %ymm0
	vmovdqu	%ymm0, 224(%rax)
	movq	888(%rsp), %r10
	movq	%r10, 56(%rcx)
	vmovdqu	288(%rsp), %ymm0
	vmovdqu	%ymm0, 256(%rax)
	movq	896(%rsp), %r10
	movq	%r10, 64(%rcx)
	vmovdqu	320(%rsp), %ymm0
	vmovdqu	%ymm0, 288(%rax)
	movq	904(%rsp), %r10
	movq	%r10, 72(%rcx)
	vmovdqu	352(%rsp), %ymm0
	vmovdqu	%ymm0, 320(%rax)
	movq	912(%rsp), %r10
	movq	%r10, 80(%rcx)
	vmovdqu	384(%rsp), %ymm0
	vmovdqu	%ymm0, 352(%rax)
	movq	920(%rsp), %r10
	movq	%r10, 88(%rcx)
	vmovdqu	416(%rsp), %ymm0
	vmovdqu	%ymm0, 384(%rax)
	movq	928(%rsp), %r10
	movq	%r10, 96(%rcx)
	vmovdqu	448(%rsp), %ymm0
	vmovdqu	%ymm0, 416(%rax)
	movq	936(%rsp), %r10
	movq	%r10, 104(%rcx)
	vmovdqu	480(%rsp), %ymm0
	vmovdqu	%ymm0, 448(%rax)
	movq	944(%rsp), %r10
	movq	%r10, 112(%rcx)
	vmovdqu	512(%rsp), %ymm0
	vmovdqu	%ymm0, 480(%rax)
	movq	952(%rsp), %r10
	movq	%r10, 120(%rcx)
	vmovdqu	544(%rsp), %ymm0
	vmovdqu	%ymm0, 512(%rax)
	movq	960(%rsp), %r10
	movq	%r10, 128(%rcx)
	vmovdqu	576(%rsp), %ymm0
	vmovdqu	%ymm0, 544(%rax)
	movq	968(%rsp), %r10
	movq	%r10, 136(%rcx)
	vmovdqu	608(%rsp), %ymm0
	vmovdqu	%ymm0, 576(%rax)
	movq	976(%rsp), %r10
	movq	%r10, 144(%rcx)
	vmovdqu	640(%rsp), %ymm0
	vmovdqu	%ymm0, 608(%rax)
	movq	984(%rsp), %r10
	movq	%r10, 152(%rcx)
	vmovdqu	672(%rsp), %ymm0
	vmovdqu	%ymm0, 640(%rax)
	movq	992(%rsp), %r10
	movq	%r10, 160(%rcx)
	vmovdqu	704(%rsp), %ymm0
	vmovdqu	%ymm0, 672(%rax)
	movq	1000(%rsp), %r10
	movq	%r10, 168(%rcx)
	vmovdqu	736(%rsp), %ymm0
	vmovdqu	%ymm0, 704(%rax)
	movq	1008(%rsp), %r10
	movq	%r10, 176(%rcx)
	vmovdqu	768(%rsp), %ymm0
	vmovdqu	%ymm0, 736(%rax)
	movq	1016(%rsp), %r10
	movq	%r10, 184(%rcx)
	vmovdqu	800(%rsp), %ymm0
	vmovdqu	%ymm0, 768(%rax)
	movq	1024(%rsp), %r10
	movq	%r10, 192(%rcx)
	ret
.L_keccakf1600_avx2x4_nat$1:
	vmovdqu	224(%rax), %ymm12
	vmovdqu	256(%rax), %ymm14
	vmovdqu	352(%rax), %ymm9
	vmovdqu	384(%rax), %ymm0
	vmovdqu	480(%rax), %ymm6
	vmovdqu	576(%rax), %ymm3
	vmovdqu	672(%rax), %ymm1
	vmovdqu	704(%rax), %ymm4
	vmovdqu	768(%rax), %ymm5
	leaq	glob_data + 512(%rip), %r8
	leaq	glob_data + 544(%rip), %r9
	leaq	glob_data + 11280(%rip), %r10
	movq	$0, %r11
.L_keccakf1600_avx2x4_nat$2:
	vmovdqu	160(%rax), %ymm2
	vpxor	640(%rax), %ymm6, %ymm11
	vmovdqu	%ymm6, 224(%rax)
	vmovdqu	%ymm12, %ymm6
	vmovdqu	192(%rax), %ymm10
	vmovdqu	512(%rax), %ymm8
	vmovdqu	%ymm1, 352(%rax)
	vpxor	320(%rax), %ymm2, %ymm13
	vmovdqu	64(%rax), %ymm12
	vmovdqu	%ymm2, 256(%rax)
	vpxor	%ymm1, %ymm8, %ymm8
	vmovdqu	32(%rax), %ymm7
	vmovdqu	448(%rax), %ymm2
	vmovdqu	%ymm14, 576(%rax)
	vpxor	%ymm13, %ymm11, %ymm11
	vpxor	%ymm9, %ymm10, %ymm13
	vpxor	544(%rax), %ymm4, %ymm10
	vmovdqu	%ymm12, 480(%rax)
	vpxor	%ymm13, %ymm8, %ymm8
	vpxor	%ymm0, %ymm6, %ymm13
	vmovdqu	288(%rax), %ymm1
	vmovdqu	%ymm9, 384(%rax)
	vpxor	%ymm13, %ymm10, %ymm10
	vpxor	416(%rax), %ymm14, %ymm13
	vpxor	%ymm7, %ymm8, %ymm8
	vmovdqu	96(%rax), %ymm9
	vpxor	%ymm12, %ymm10, %ymm10
	vpxor	736(%rax), %ymm3, %ymm12
	vpxor	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm2, 672(%rax)
	vpsrlq	$63, %ymm8, %ymm2
	vpsrlq	$63, %ymm10, %ymm15
	vpxor	(%rax), %ymm11, %ymm11
	vpxor	%ymm13, %ymm12, %ymm12
	vmovdqu	128(%rax), %ymm14
	vpxor	%ymm9, %ymm12, %ymm12
	vpxor	608(%rax), %ymm5, %ymm13
	vmovdqu	%ymm14, 704(%rax)
	vpxor	%ymm1, %ymm13, %ymm13
	vpsllq	$1, %ymm8, %ymm1
	vpor	%ymm2, %ymm1, %ymm1
	vpsllq	$1, %ymm10, %ymm2
	vpxor	%ymm14, %ymm13, %ymm13
	vpor	%ymm15, %ymm2, %ymm2
	vpsrlq	$63, %ymm12, %ymm14
	vpxor	%ymm13, %ymm1, %ymm1
	vpsllq	$1, %ymm12, %ymm15
	vpxor	%ymm11, %ymm2, %ymm2
	vpor	%ymm14, %ymm15, %ymm15
	vpxor	%ymm7, %ymm2, %ymm7
	vpxor	%ymm8, %ymm15, %ymm15
	vpsrlq	$63, %ymm13, %ymm8
	vpsllq	$1, %ymm13, %ymm13
	vpxor	%ymm4, %ymm15, %ymm4
	vpxor	%ymm6, %ymm15, %ymm6
	vpor	%ymm8, %ymm13, %ymm13
	vpxor	(%rax), %ymm1, %ymm8
	vpxor	%ymm10, %ymm13, %ymm13
	vpsrlq	$63, %ymm11, %ymm10
	vpsllq	$1, %ymm11, %ymm11
	vpxor	%ymm3, %ymm13, %ymm3
	vpxor	%ymm9, %ymm13, %ymm9
	vpor	%ymm10, %ymm11, %ymm11
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	192(%rax), %ymm2, %ymm12
	vpxor	%ymm5, %ymm11, %ymm5
	vpsrlq	$20, %ymm12, %ymm10
	vpsllq	$44, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpxor	%ymm0, %ymm15, %ymm10
	vpbroadcastq	(%r10,%r11,8), %ymm0
	vpsrlq	$21, %ymm10, %ymm14
	vpsllq	$43, %ymm10, %ymm10
	vpor	%ymm14, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm14
	vpxor	%ymm0, %ymm14, %ymm14
	vpxor	%ymm8, %ymm14, %ymm0
	vpsrlq	$43, %ymm3, %ymm14
	vpsllq	$21, %ymm3, %ymm3
	vmovdqu	%ymm0, (%rax)
	vpor	%ymm14, %ymm3, %ymm3
	vpandn	%ymm3, %ymm10, %ymm14
	vpxor	%ymm12, %ymm14, %ymm0
	vpsrlq	$50, %ymm5, %ymm14
	vpsllq	$14, %ymm5, %ymm5
	vmovdqu	%ymm0, 32(%rax)
	vpor	%ymm14, %ymm5, %ymm5
	vpandn	%ymm5, %ymm3, %ymm14
	vpxor	%ymm10, %ymm14, %ymm10
	vmovdqu	%ymm10, 64(%rax)
	vpandn	%ymm8, %ymm5, %ymm10
	vpandn	%ymm12, %ymm8, %ymm8
	vpxor	%ymm3, %ymm10, %ymm10
	vmovdqu	%ymm10, 96(%rax)
	vpxor	%ymm5, %ymm8, %ymm10
	vpsrlq	$36, %ymm9, %ymm5
	vpsllq	$28, %ymm9, %ymm9
	vmovdqu	%ymm10, 128(%rax)
	vpor	%ymm5, %ymm9, %ymm9
	vpxor	288(%rax), %ymm11, %ymm5
	vpsrlq	$44, %ymm5, %ymm12
	vpsllq	$20, %ymm5, %ymm5
	vpor	%ymm12, %ymm5, %ymm5
	vpxor	320(%rax), %ymm1, %ymm12
	vpsrlq	$61, %ymm12, %ymm10
	vpsllq	$3, %ymm12, %ymm12
	vpor	%ymm10, %ymm12, %ymm12
	vpandn	%ymm12, %ymm5, %ymm10
	vpxor	%ymm9, %ymm10, %ymm10
	vmovdqu	%ymm10, 160(%rax)
	vpxor	512(%rax), %ymm2, %ymm10
	vpsrlq	$19, %ymm10, %ymm8
	vpsllq	$45, %ymm10, %ymm10
	vpor	%ymm8, %ymm10, %ymm10
	vpandn	%ymm10, %ymm12, %ymm8
	vpxor	%ymm5, %ymm8, %ymm8
	vmovdqu	%ymm8, 192(%rax)
	vpsrlq	$3, %ymm4, %ymm8
	vpsllq	$61, %ymm4, %ymm4
	vpor	%ymm8, %ymm4, %ymm4
	vpandn	%ymm4, %ymm10, %ymm8
	vpxor	%ymm12, %ymm8, %ymm12
	vpandn	%ymm9, %ymm4, %ymm8
	vpandn	%ymm5, %ymm9, %ymm9
	vpsrlq	$63, %ymm7, %ymm5
	vpsllq	$1, %ymm7, %ymm7
	vpxor	%ymm10, %ymm8, %ymm14
	vpor	%ymm5, %ymm7, %ymm7
	vpsrlq	$58, %ymm6, %ymm5
	vpxor	%ymm4, %ymm9, %ymm8
	vpsllq	$6, %ymm6, %ymm6
	vmovdqu	%ymm8, 288(%rax)
	vpxor	608(%rax), %ymm11, %ymm4
	vpor	%ymm5, %ymm6, %ymm6
	vpxor	416(%rax), %ymm13, %ymm5
	vpshufb	(%r8), %ymm4, %ymm4
	vpsrlq	$39, %ymm5, %ymm10
	vpsllq	$25, %ymm5, %ymm5
	vpor	%ymm5, %ymm10, %ymm10
	vpandn	%ymm10, %ymm6, %ymm5
	vpandn	%ymm4, %ymm10, %ymm9
	vpxor	%ymm7, %ymm5, %ymm8
	vpxor	640(%rax), %ymm1, %ymm5
	vpxor	%ymm6, %ymm9, %ymm9
	vmovdqu	%ymm8, 320(%rax)
	vpsrlq	$46, %ymm5, %ymm8
	vpsllq	$18, %ymm5, %ymm5
	vpor	%ymm5, %ymm8, %ymm5
	vpandn	%ymm5, %ymm4, %ymm8
	vpxor	%ymm10, %ymm8, %ymm0
	vpandn	%ymm7, %ymm5, %ymm10
	vpandn	%ymm6, %ymm7, %ymm7
	vpxor	%ymm4, %ymm10, %ymm8
	vmovdqu	%ymm8, 416(%rax)
	vpxor	%ymm5, %ymm7, %ymm8
	vpxor	704(%rax), %ymm11, %ymm7
	vpxor	672(%rax), %ymm11, %ymm11
	vmovdqu	%ymm8, 448(%rax)
	vpsrlq	$37, %ymm7, %ymm5
	vpsllq	$27, %ymm7, %ymm7
	vpor	%ymm7, %ymm5, %ymm5
	vpxor	256(%rax), %ymm1, %ymm7
	vpxor	224(%rax), %ymm1, %ymm1
	vpsrlq	$28, %ymm7, %ymm4
	vpsllq	$36, %ymm7, %ymm7
	vpor	%ymm7, %ymm4, %ymm4
	vpxor	384(%rax), %ymm2, %ymm7
	vpxor	352(%rax), %ymm2, %ymm2
	vpsrlq	$54, %ymm7, %ymm8
	vpsllq	$10, %ymm7, %ymm7
	vpor	%ymm7, %ymm8, %ymm8
	vpxor	544(%rax), %ymm15, %ymm7
	vpxor	480(%rax), %ymm15, %ymm15
	vpandn	%ymm8, %ymm4, %ymm6
	vpsrlq	$49, %ymm7, %ymm10
	vpsllq	$15, %ymm7, %ymm7
	vpxor	%ymm5, %ymm6, %ymm6
	vpor	%ymm7, %ymm10, %ymm10
	vpandn	%ymm10, %ymm8, %ymm7
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm7, 512(%rax)
	vpxor	736(%rax), %ymm13, %ymm7
	vpxor	576(%rax), %ymm13, %ymm13
	vpshufb	(%r9), %ymm7, %ymm7
	vpandn	%ymm7, %ymm10, %ymm3
	vpxor	%ymm8, %ymm3, %ymm3
	vmovdqu	%ymm3, 544(%rax)
	vpandn	%ymm5, %ymm7, %ymm3
	vpandn	%ymm4, %ymm5, %ymm5
	vpxor	%ymm7, %ymm5, %ymm5
	vpsrlq	$62, %ymm2, %ymm7
	vpxor	%ymm10, %ymm3, %ymm3
	vmovdqu	%ymm5, 608(%rax)
	vpsrlq	$2, %ymm15, %ymm5
	vpsllq	$62, %ymm15, %ymm15
	vpor	%ymm15, %ymm5, %ymm5
	vpsrlq	$9, %ymm13, %ymm15
	vpsllq	$55, %ymm13, %ymm13
	vpsllq	$2, %ymm2, %ymm2
	vpor	%ymm13, %ymm15, %ymm13
	vpsrlq	$25, %ymm11, %ymm15
	vpor	%ymm2, %ymm7, %ymm2
	vpsllq	$39, %ymm11, %ymm11
	vpor	%ymm11, %ymm15, %ymm15
	vpandn	%ymm15, %ymm13, %ymm11
	vpxor	%ymm5, %ymm11, %ymm11
	vmovdqu	%ymm11, 640(%rax)
	vpsrlq	$23, %ymm1, %ymm11
	vpsllq	$41, %ymm1, %ymm1
	vpor	%ymm1, %ymm11, %ymm11
	vpandn	%ymm2, %ymm11, %ymm4
	vpandn	%ymm11, %ymm15, %ymm1
	vpxor	%ymm15, %ymm4, %ymm4
	vpandn	%ymm5, %ymm2, %ymm15
	vpandn	%ymm13, %ymm5, %ymm5
	vpxor	%ymm11, %ymm15, %ymm15
	vpxor	%ymm13, %ymm1, %ymm1
	vpxor	%ymm2, %ymm5, %ymm5
	vmovdqu	%ymm15, 736(%rax)
	incq	%r11
	cmpq	$24, %r11
	jb  	.L_keccakf1600_avx2x4_nat$2
	vmovdqu	%ymm12, 224(%rax)
	vmovdqu	%ymm14, 256(%rax)
	vmovdqu	%ymm9, 352(%rax)
	vmovdqu	%ymm0, 384(%rax)
	vmovdqu	%ymm6, 480(%rax)
	vmovdqu	%ymm3, 576(%rax)
	vmovdqu	%ymm1, 672(%rax)
	vmovdqu	%ymm4, 704(%rax)
	vmovdqu	%ymm5, 768(%rax)
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
	movq	128(%rax), %rbx
	xorq	%r11, %rbx
	movq	88(%rax), %r14
	movq	48(%rax), %r11
	xorq	%r11, %r14
	xorq	%rbx, %r14
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
	leaq	glob_data + 11280(%rip), %rbp
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
	andnq	%r14, %r8, %rbp
	xorq	%rsi, %rbp
	movq	%rbp, 56(%rax)
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
	andnq	%r10, %r13, %rbx
	xorq	%r11, %rbx
	movq	%rbx, %r10
	movq	%rbx, 112(%rax)
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
	leaq	glob_data + 11280(%rip), %r14
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
	rorx	$39, %rdx, %rbx
	xorq	%r11, %r15
	rorx	$56, %r15, %rdx
	movq	112(%rax), %r13
	xorq	%r9, %r13
	rorx	$46, %r13, %r13
	andnq	%rcx, %r13, %r12
	xorq	%rdx, %r12
	movq	%r12, 104(%rax)
	andnq	%rdx, %rbx, %r12
	andnq	%r13, %rdx, %rdx
	xorq	%rbx, %rdx
	andnq	%rbx, %rsi, %rbx
	xorq	%rcx, %rbx
	xorq	%rsi, %r12
	movq	%r12, 88(%rax)
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
	vmovdqu	(%rsi), %ymm10
	vmovdqu	32(%rsi), %ymm8
	vmovdqu	64(%rsi), %ymm0
	vmovdqu	96(%rsi), %ymm1
	vmovdqu	128(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm3
	vmovdqu	192(%rsi), %ymm4
	vmovdqu	224(%rsi), %ymm5
	vmovdqu	glob_data + 5568(%rip), %ymm6
	vmovdqu	glob_data + 1600(%rip), %ymm7
	vpshufd	$216, %ymm10, %ymm10
	vpshufd	$216, %ymm8, %ymm11
	vmovshdup	%ymm6, %ymm8
	vmovshdup	%ymm7, %ymm9
	vpunpcklqdq	%ymm11, %ymm10, %ymm12
	vpunpckhqdq	%ymm11, %ymm10, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm11, %ymm10
	vpunpckhqdq	%ymm6, %ymm11, %ymm7
	vpshufd	$216, %ymm10, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 5600(%rip), %ymm8
	vmovdqu	glob_data + 1632(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm1, %ymm11, %ymm12
	vpunpckhqdq	%ymm1, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm1
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm8, %ymm1, %ymm8
	vpmuldq	%ymm0, %ymm12, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm0
	vpunpcklqdq	%ymm0, %ymm11, %ymm1
	vpunpckhqdq	%ymm0, %ymm11, %ymm8
	vpshufd	$216, %ymm1, %ymm0
	vpshufd	$216, %ymm8, %ymm1
	vmovdqu	glob_data + 5632(%rip), %ymm8
	vmovdqu	glob_data + 1664(%rip), %ymm9
	vpshufd	$216, %ymm2, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm3, %ymm11, %ymm12
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm3
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm8
	vpmuldq	%ymm2, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm2
	vpunpcklqdq	%ymm2, %ymm11, %ymm3
	vpunpckhqdq	%ymm2, %ymm11, %ymm8
	vpshufd	$216, %ymm3, %ymm2
	vpshufd	$216, %ymm8, %ymm3
	vmovdqu	glob_data + 5664(%rip), %ymm8
	vmovdqu	glob_data + 1696(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm5, %ymm11, %ymm12
	vpunpckhqdq	%ymm5, %ymm11, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm11
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm4, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm11, %ymm9
	vpmuldq	%ymm10, %ymm12, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpunpcklqdq	%ymm4, %ymm5, %ymm10
	vpunpckhqdq	%ymm4, %ymm5, %ymm5
	vpshufd	$216, %ymm10, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 5056(%rip), %ymm8
	vmovdqu	glob_data + 1088(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm12
	vpunpckhqdq	%ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm11, %ymm6
	vpunpckhqdq	%ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 5088(%rip), %ymm12
	vmovdqu	glob_data + 1120(%rip), %ymm9
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm11
	vpsubd	%ymm8, %ymm11, %ymm1
	vpaddd	%ymm8, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm12, %ymm1, %ymm8
	vpmuldq	%ymm12, %ymm10, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm11, %ymm0
	vpunpckhqdq	%ymm1, %ymm11, %ymm1
	vmovdqu	glob_data + 5120(%rip), %ymm12
	vmovdqu	glob_data + 1152(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm11
	vpsubd	%ymm8, %ymm11, %ymm3
	vpaddd	%ymm8, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm12, %ymm3, %ymm8
	vpmuldq	%ymm12, %ymm10, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm11, %ymm2
	vpunpckhqdq	%ymm3, %ymm11, %ymm3
	vmovdqu	glob_data + 5152(%rip), %ymm11
	vmovdqu	glob_data + 1184(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpsubd	%ymm8, %ymm5, %ymm10
	vpaddd	%ymm8, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4544(%rip), %ymm8
	vmovdqu	glob_data + 576(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm12
	vperm2i128	$49, %ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm11, %ymm6
	vperm2i128	$49, %ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 4576(%rip), %ymm12
	vmovdqu	glob_data + 608(%rip), %ymm9
	vperm2i128	$32, %ymm1, %ymm0, %ymm8
	vperm2i128	$49, %ymm1, %ymm0, %ymm11
	vpsubd	%ymm8, %ymm11, %ymm1
	vpaddd	%ymm8, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm12, %ymm1, %ymm8
	vpmuldq	%ymm12, %ymm10, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm11, %ymm8
	vmovdqu	glob_data + 4608(%rip), %ymm12
	vmovdqu	glob_data + 640(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm11
	vpsubd	%ymm0, %ymm11, %ymm3
	vpaddd	%ymm0, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm12, %ymm3, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm2
	vperm2i128	$49, %ymm0, %ymm11, %ymm3
	vmovdqu	glob_data + 4640(%rip), %ymm11
	vmovdqu	glob_data + 672(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm0
	vperm2i128	$49, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm5, %ymm4
	vperm2i128	$49, %ymm0, %ymm5, %ymm5
	vpbroadcastd	glob_data + 11688(%rip), %ymm11
	vpbroadcastd	glob_data + 11568(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11692(%rip), %ymm11
	vpbroadcastd	glob_data + 11572(%rip), %ymm9
	vpsubd	%ymm1, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm1, %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm8, %ymm8
	vpbroadcastd	glob_data + 11696(%rip), %ymm11
	vpbroadcastd	glob_data + 11576(%rip), %ymm9
	vpsubd	%ymm2, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm2, %ymm1
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm2
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpbroadcastd	glob_data + 11700(%rip), %ymm11
	vpbroadcastd	glob_data + 11580(%rip), %ymm9
	vpsubd	%ymm4, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm4, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpbroadcastd	glob_data + 11656(%rip), %ymm11
	vpbroadcastd	glob_data + 11536(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm12, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm6, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm12, %ymm4, %ymm4
	vpsubq	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm8, %ymm6
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm11, %ymm6, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11660(%rip), %ymm6
	vpbroadcastd	glob_data + 11540(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm3, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vmovdqu	%ymm10, (%rsi)
	vmovdqu	%ymm7, 32(%rsi)
	vmovdqu	%ymm4, 64(%rsi)
	vmovdqu	%ymm0, 96(%rsi)
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	%ymm2, 160(%rsi)
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	%ymm5, 224(%rsi)
	vmovdqu	256(%rsi), %ymm10
	vmovdqu	288(%rsi), %ymm8
	vmovdqu	320(%rsi), %ymm0
	vmovdqu	352(%rsi), %ymm1
	vmovdqu	384(%rsi), %ymm2
	vmovdqu	416(%rsi), %ymm3
	vmovdqu	448(%rsi), %ymm4
	vmovdqu	480(%rsi), %ymm5
	vmovdqu	glob_data + 5696(%rip), %ymm6
	vmovdqu	glob_data + 1728(%rip), %ymm7
	vpshufd	$216, %ymm10, %ymm10
	vpshufd	$216, %ymm8, %ymm11
	vmovshdup	%ymm6, %ymm8
	vmovshdup	%ymm7, %ymm9
	vpunpcklqdq	%ymm11, %ymm10, %ymm12
	vpunpckhqdq	%ymm11, %ymm10, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm11, %ymm10
	vpunpckhqdq	%ymm6, %ymm11, %ymm7
	vpshufd	$216, %ymm10, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 5728(%rip), %ymm8
	vmovdqu	glob_data + 1760(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm1, %ymm11, %ymm12
	vpunpckhqdq	%ymm1, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm1
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm8, %ymm1, %ymm8
	vpmuldq	%ymm0, %ymm12, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm0
	vpunpcklqdq	%ymm0, %ymm11, %ymm1
	vpunpckhqdq	%ymm0, %ymm11, %ymm8
	vpshufd	$216, %ymm1, %ymm0
	vpshufd	$216, %ymm8, %ymm1
	vmovdqu	glob_data + 5760(%rip), %ymm8
	vmovdqu	glob_data + 1792(%rip), %ymm9
	vpshufd	$216, %ymm2, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm3, %ymm11, %ymm12
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm3
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm8
	vpmuldq	%ymm2, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm2
	vpunpcklqdq	%ymm2, %ymm11, %ymm3
	vpunpckhqdq	%ymm2, %ymm11, %ymm8
	vpshufd	$216, %ymm3, %ymm2
	vpshufd	$216, %ymm8, %ymm3
	vmovdqu	glob_data + 5792(%rip), %ymm8
	vmovdqu	glob_data + 1824(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm5, %ymm11, %ymm12
	vpunpckhqdq	%ymm5, %ymm11, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm11
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm4, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm11, %ymm9
	vpmuldq	%ymm10, %ymm12, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpunpcklqdq	%ymm4, %ymm5, %ymm10
	vpunpckhqdq	%ymm4, %ymm5, %ymm5
	vpshufd	$216, %ymm10, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 5184(%rip), %ymm8
	vmovdqu	glob_data + 1216(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm12
	vpunpckhqdq	%ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm11, %ymm6
	vpunpckhqdq	%ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 5216(%rip), %ymm8
	vmovdqu	glob_data + 1248(%rip), %ymm9
	vpunpcklqdq	%ymm1, %ymm0, %ymm12
	vpunpckhqdq	%ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm1, %ymm11, %ymm0
	vpunpckhqdq	%ymm1, %ymm11, %ymm1
	vmovdqu	glob_data + 5248(%rip), %ymm8
	vmovdqu	glob_data + 1280(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm12
	vpunpckhqdq	%ymm3, %ymm2, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm2
	vpmuldq	%ymm8, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpunpcklqdq	%ymm3, %ymm11, %ymm2
	vpunpckhqdq	%ymm3, %ymm11, %ymm3
	vmovdqu	glob_data + 5280(%rip), %ymm8
	vmovdqu	glob_data + 1312(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm12
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm10
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm8, %ymm4, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4672(%rip), %ymm8
	vmovdqu	glob_data + 704(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm12
	vperm2i128	$49, %ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm11, %ymm6
	vperm2i128	$49, %ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 4704(%rip), %ymm8
	vmovdqu	glob_data + 736(%rip), %ymm9
	vperm2i128	$32, %ymm1, %ymm0, %ymm12
	vperm2i128	$49, %ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm11, %ymm8
	vmovdqu	glob_data + 4736(%rip), %ymm12
	vmovdqu	glob_data + 768(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm11
	vpsubd	%ymm0, %ymm11, %ymm3
	vpaddd	%ymm0, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm12, %ymm3, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm2
	vperm2i128	$49, %ymm0, %ymm11, %ymm3
	vmovdqu	glob_data + 4768(%rip), %ymm11
	vmovdqu	glob_data + 800(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm0
	vperm2i128	$49, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm5, %ymm4
	vperm2i128	$49, %ymm0, %ymm5, %ymm5
	vpbroadcastd	glob_data + 11704(%rip), %ymm11
	vpbroadcastd	glob_data + 11584(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11708(%rip), %ymm11
	vpbroadcastd	glob_data + 11588(%rip), %ymm9
	vpsubd	%ymm1, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm1, %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm8, %ymm8
	vpbroadcastd	glob_data + 11712(%rip), %ymm11
	vpbroadcastd	glob_data + 11592(%rip), %ymm9
	vpsubd	%ymm2, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm2, %ymm1
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm2
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpbroadcastd	glob_data + 11716(%rip), %ymm11
	vpbroadcastd	glob_data + 11596(%rip), %ymm9
	vpsubd	%ymm4, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm4, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpbroadcastd	glob_data + 11664(%rip), %ymm11
	vpbroadcastd	glob_data + 11544(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm12, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm6, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm12, %ymm4, %ymm4
	vpsubq	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm8, %ymm6
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm11, %ymm6, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11668(%rip), %ymm6
	vpbroadcastd	glob_data + 11548(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm3, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vmovdqu	%ymm10, 256(%rsi)
	vmovdqu	%ymm7, 288(%rsi)
	vmovdqu	%ymm4, 320(%rsi)
	vmovdqu	%ymm0, 352(%rsi)
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	%ymm2, 416(%rsi)
	vmovdqu	%ymm3, 448(%rsi)
	vmovdqu	%ymm5, 480(%rsi)
	vmovdqu	512(%rsi), %ymm10
	vmovdqu	544(%rsi), %ymm8
	vmovdqu	576(%rsi), %ymm0
	vmovdqu	608(%rsi), %ymm1
	vmovdqu	640(%rsi), %ymm2
	vmovdqu	672(%rsi), %ymm3
	vmovdqu	704(%rsi), %ymm4
	vmovdqu	736(%rsi), %ymm5
	vmovdqu	glob_data + 5824(%rip), %ymm6
	vmovdqu	glob_data + 1856(%rip), %ymm7
	vpshufd	$216, %ymm10, %ymm10
	vpshufd	$216, %ymm8, %ymm11
	vmovshdup	%ymm6, %ymm8
	vmovshdup	%ymm7, %ymm9
	vpunpcklqdq	%ymm11, %ymm10, %ymm12
	vpunpckhqdq	%ymm11, %ymm10, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm11, %ymm10
	vpunpckhqdq	%ymm6, %ymm11, %ymm7
	vpshufd	$216, %ymm10, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 5856(%rip), %ymm8
	vmovdqu	glob_data + 1888(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm1, %ymm11, %ymm12
	vpunpckhqdq	%ymm1, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm1
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm8, %ymm1, %ymm8
	vpmuldq	%ymm0, %ymm12, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm0
	vpunpcklqdq	%ymm0, %ymm11, %ymm1
	vpunpckhqdq	%ymm0, %ymm11, %ymm8
	vpshufd	$216, %ymm1, %ymm0
	vpshufd	$216, %ymm8, %ymm1
	vmovdqu	glob_data + 5888(%rip), %ymm8
	vmovdqu	glob_data + 1920(%rip), %ymm9
	vpshufd	$216, %ymm2, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm3, %ymm11, %ymm12
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm3
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm8
	vpmuldq	%ymm2, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm2
	vpunpcklqdq	%ymm2, %ymm11, %ymm3
	vpunpckhqdq	%ymm2, %ymm11, %ymm8
	vpshufd	$216, %ymm3, %ymm2
	vpshufd	$216, %ymm8, %ymm3
	vmovdqu	glob_data + 5920(%rip), %ymm8
	vmovdqu	glob_data + 1952(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm5, %ymm11, %ymm12
	vpunpckhqdq	%ymm5, %ymm11, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm11
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm4, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm11, %ymm9
	vpmuldq	%ymm10, %ymm12, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpunpcklqdq	%ymm4, %ymm5, %ymm10
	vpunpckhqdq	%ymm4, %ymm5, %ymm5
	vpshufd	$216, %ymm10, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 5312(%rip), %ymm8
	vmovdqu	glob_data + 1344(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm12
	vpunpckhqdq	%ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm11, %ymm6
	vpunpckhqdq	%ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 5344(%rip), %ymm8
	vmovdqu	glob_data + 1376(%rip), %ymm9
	vpunpcklqdq	%ymm1, %ymm0, %ymm12
	vpunpckhqdq	%ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm1, %ymm11, %ymm0
	vpunpckhqdq	%ymm1, %ymm11, %ymm1
	vmovdqu	glob_data + 5376(%rip), %ymm8
	vmovdqu	glob_data + 1408(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm12
	vpunpckhqdq	%ymm3, %ymm2, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm2
	vpmuldq	%ymm8, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpunpcklqdq	%ymm3, %ymm11, %ymm2
	vpunpckhqdq	%ymm3, %ymm11, %ymm3
	vmovdqu	glob_data + 5408(%rip), %ymm8
	vmovdqu	glob_data + 1440(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm12
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm10
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm8, %ymm4, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4800(%rip), %ymm8
	vmovdqu	glob_data + 832(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm12
	vperm2i128	$49, %ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm11, %ymm6
	vperm2i128	$49, %ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 4832(%rip), %ymm8
	vmovdqu	glob_data + 864(%rip), %ymm9
	vperm2i128	$32, %ymm1, %ymm0, %ymm12
	vperm2i128	$49, %ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm11, %ymm8
	vmovdqu	glob_data + 4864(%rip), %ymm12
	vmovdqu	glob_data + 896(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm11
	vpsubd	%ymm0, %ymm11, %ymm3
	vpaddd	%ymm0, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm12, %ymm3, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm2
	vperm2i128	$49, %ymm0, %ymm11, %ymm3
	vmovdqu	glob_data + 4896(%rip), %ymm11
	vmovdqu	glob_data + 928(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm0
	vperm2i128	$49, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm5, %ymm4
	vperm2i128	$49, %ymm0, %ymm5, %ymm5
	vpbroadcastd	glob_data + 11720(%rip), %ymm11
	vpbroadcastd	glob_data + 11600(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11724(%rip), %ymm11
	vpbroadcastd	glob_data + 11604(%rip), %ymm9
	vpsubd	%ymm1, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm1, %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm8, %ymm8
	vpbroadcastd	glob_data + 11728(%rip), %ymm11
	vpbroadcastd	glob_data + 11608(%rip), %ymm9
	vpsubd	%ymm2, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm2, %ymm1
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm2
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpbroadcastd	glob_data + 11732(%rip), %ymm11
	vpbroadcastd	glob_data + 11612(%rip), %ymm9
	vpsubd	%ymm4, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm4, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpbroadcastd	glob_data + 11672(%rip), %ymm11
	vpbroadcastd	glob_data + 11552(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm12, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm6, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm12, %ymm4, %ymm4
	vpsubq	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm8, %ymm6
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm11, %ymm6, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11676(%rip), %ymm6
	vpbroadcastd	glob_data + 11556(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm3, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vmovdqu	%ymm10, 512(%rsi)
	vmovdqu	%ymm7, 544(%rsi)
	vmovdqu	%ymm4, 576(%rsi)
	vmovdqu	%ymm0, 608(%rsi)
	vmovdqu	%ymm1, 640(%rsi)
	vmovdqu	%ymm2, 672(%rsi)
	vmovdqu	%ymm3, 704(%rsi)
	vmovdqu	%ymm5, 736(%rsi)
	vmovdqu	768(%rsi), %ymm10
	vmovdqu	800(%rsi), %ymm8
	vmovdqu	832(%rsi), %ymm0
	vmovdqu	864(%rsi), %ymm1
	vmovdqu	896(%rsi), %ymm2
	vmovdqu	928(%rsi), %ymm3
	vmovdqu	960(%rsi), %ymm4
	vmovdqu	992(%rsi), %ymm5
	vmovdqu	glob_data + 5952(%rip), %ymm6
	vmovdqu	glob_data + 1984(%rip), %ymm7
	vpshufd	$216, %ymm10, %ymm10
	vpshufd	$216, %ymm8, %ymm11
	vmovshdup	%ymm6, %ymm8
	vmovshdup	%ymm7, %ymm9
	vpunpcklqdq	%ymm11, %ymm10, %ymm12
	vpunpckhqdq	%ymm11, %ymm10, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm6, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm11, %ymm10
	vpunpckhqdq	%ymm6, %ymm11, %ymm7
	vpshufd	$216, %ymm10, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 5984(%rip), %ymm8
	vmovdqu	glob_data + 2016(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm1, %ymm11, %ymm12
	vpunpckhqdq	%ymm1, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm1
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm8, %ymm1, %ymm8
	vpmuldq	%ymm0, %ymm12, %ymm0
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm0, %ymm1, %ymm0
	vpunpcklqdq	%ymm0, %ymm11, %ymm1
	vpunpckhqdq	%ymm0, %ymm11, %ymm8
	vpshufd	$216, %ymm1, %ymm0
	vpshufd	$216, %ymm8, %ymm1
	vmovdqu	glob_data + 6016(%rip), %ymm8
	vmovdqu	glob_data + 2048(%rip), %ymm9
	vpshufd	$216, %ymm2, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm3, %ymm11, %ymm12
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm3
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm8
	vpmuldq	%ymm2, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm2
	vpunpcklqdq	%ymm2, %ymm11, %ymm3
	vpunpckhqdq	%ymm2, %ymm11, %ymm8
	vpshufd	$216, %ymm3, %ymm2
	vpshufd	$216, %ymm8, %ymm3
	vmovdqu	glob_data + 6048(%rip), %ymm8
	vmovdqu	glob_data + 2080(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm4
	vmovshdup	%ymm9, %ymm10
	vpunpcklqdq	%ymm5, %ymm11, %ymm12
	vpunpckhqdq	%ymm5, %ymm11, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm11
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm8
	vpmuldq	%ymm4, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm11, %ymm9
	vpmuldq	%ymm10, %ymm12, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpunpcklqdq	%ymm4, %ymm5, %ymm10
	vpunpckhqdq	%ymm4, %ymm5, %ymm5
	vpshufd	$216, %ymm10, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 5440(%rip), %ymm8
	vmovdqu	glob_data + 1472(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm12
	vpunpckhqdq	%ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm11, %ymm6
	vpunpckhqdq	%ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 5472(%rip), %ymm8
	vmovdqu	glob_data + 1504(%rip), %ymm9
	vpunpcklqdq	%ymm1, %ymm0, %ymm12
	vpunpckhqdq	%ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm1, %ymm11, %ymm0
	vpunpckhqdq	%ymm1, %ymm11, %ymm1
	vmovdqu	glob_data + 5504(%rip), %ymm8
	vmovdqu	glob_data + 1536(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm12
	vpunpckhqdq	%ymm3, %ymm2, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm2
	vpmuldq	%ymm8, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpunpcklqdq	%ymm3, %ymm11, %ymm2
	vpunpckhqdq	%ymm3, %ymm11, %ymm3
	vmovdqu	glob_data + 5536(%rip), %ymm8
	vmovdqu	glob_data + 1568(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm12
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpsubd	%ymm12, %ymm5, %ymm10
	vpaddd	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm8, %ymm4, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4928(%rip), %ymm8
	vmovdqu	glob_data + 960(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm12
	vperm2i128	$49, %ymm7, %ymm6, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm11, %ymm6
	vperm2i128	$49, %ymm7, %ymm11, %ymm7
	vmovdqu	glob_data + 4960(%rip), %ymm8
	vmovdqu	glob_data + 992(%rip), %ymm9
	vperm2i128	$32, %ymm1, %ymm0, %ymm12
	vperm2i128	$49, %ymm1, %ymm0, %ymm11
	vpsubd	%ymm12, %ymm11, %ymm10
	vpaddd	%ymm12, %ymm11, %ymm11
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm11, %ymm8
	vmovdqu	glob_data + 4992(%rip), %ymm12
	vmovdqu	glob_data + 1024(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm11
	vpsubd	%ymm0, %ymm11, %ymm3
	vpaddd	%ymm0, %ymm11, %ymm11
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm12, %ymm3, %ymm0
	vpmuldq	%ymm12, %ymm10, %ymm2
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm11, %ymm2
	vperm2i128	$49, %ymm0, %ymm11, %ymm3
	vmovdqu	glob_data + 5024(%rip), %ymm11
	vmovdqu	glob_data + 1056(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm0
	vperm2i128	$49, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm0, %ymm5, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm4, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm5, %ymm4
	vperm2i128	$49, %ymm0, %ymm5, %ymm5
	vpbroadcastd	glob_data + 11736(%rip), %ymm11
	vpbroadcastd	glob_data + 11616(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11740(%rip), %ymm11
	vpbroadcastd	glob_data + 11620(%rip), %ymm9
	vpsubd	%ymm1, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm1, %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm1, %ymm8, %ymm8
	vpbroadcastd	glob_data + 11744(%rip), %ymm11
	vpbroadcastd	glob_data + 11624(%rip), %ymm9
	vpsubd	%ymm2, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm2, %ymm1
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm2
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm2, %ymm2
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpbroadcastd	glob_data + 11748(%rip), %ymm11
	vpbroadcastd	glob_data + 11628(%rip), %ymm9
	vpsubd	%ymm4, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm4, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpbroadcastd	glob_data + 11680(%rip), %ymm11
	vpbroadcastd	glob_data + 11560(%rip), %ymm9
	vpsubd	%ymm6, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm12, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm6, %ymm7
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm12, %ymm4, %ymm4
	vpsubq	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm0, %ymm8, %ymm6
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm11, %ymm6, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11684(%rip), %ymm6
	vpbroadcastd	glob_data + 11564(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm11
	vpaddd	%ymm3, %ymm1, %ymm1
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm8, %ymm8
	vpsubq	%ymm12, %ymm3, %ymm3
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm3, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm5, %ymm11
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm6, %ymm11, %ymm8
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vmovdqu	%ymm10, 768(%rsi)
	vmovdqu	%ymm7, 800(%rsi)
	vmovdqu	%ymm4, 832(%rsi)
	vmovdqu	%ymm0, 864(%rsi)
	vmovdqu	%ymm1, 896(%rsi)
	vmovdqu	%ymm2, 928(%rsi)
	vmovdqu	%ymm3, 960(%rsi)
	vmovdqu	%ymm5, 992(%rsi)
	vmovdqu	(%rsi), %ymm2
	vmovdqu	128(%rsi), %ymm7
	vmovdqu	256(%rsi), %ymm0
	vmovdqu	384(%rsi), %ymm5
	vmovdqu	512(%rsi), %ymm6
	vmovdqu	640(%rsi), %ymm8
	vmovdqu	768(%rsi), %ymm1
	vmovdqu	896(%rsi), %ymm3
	vpbroadcastd	glob_data + 11640(%rip), %ymm11
	vpbroadcastd	glob_data + 11520(%rip), %ymm9
	vpsubd	%ymm2, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11644(%rip), %ymm11
	vpbroadcastd	glob_data + 11524(%rip), %ymm9
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm0, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm7
	vpbroadcastd	glob_data + 11648(%rip), %ymm11
	vpbroadcastd	glob_data + 11528(%rip), %ymm9
	vpsubd	%ymm6, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11652(%rip), %ymm11
	vpbroadcastd	glob_data + 11532(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm1, %ymm8
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm9
	vpbroadcastd	glob_data + 11632(%rip), %ymm11
	vpbroadcastd	glob_data + 11512(%rip), %ymm10
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm1
	vmovshdup	%ymm12, %ymm5
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm11, %ymm5, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm12
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm12, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm4, %ymm3
	vmovshdup	%ymm12, %ymm7
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm7, %ymm5
	vpmuldq	%ymm10, %ymm12, %ymm11
	vpmuldq	%ymm10, %ymm7, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11636(%rip), %ymm12
	vpbroadcastd	glob_data + 11516(%rip), %ymm7
	vpsubd	%ymm6, %ymm8, %ymm11
	vpaddd	%ymm8, %ymm6, %ymm10
	vmovshdup	%ymm11, %ymm8
	vpmuldq	%ymm12, %ymm11, %ymm6
	vpmuldq	%ymm12, %ymm8, %ymm5
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm11, %ymm6, %ymm6
	vpsubq	%ymm8, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vpsubd	%ymm0, %ymm9, %ymm6
	vpaddd	%ymm9, %ymm0, %ymm11
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm12, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11472(%rip), %ymm6
	vpbroadcastd	glob_data + 11476(%rip), %ymm7
	vpbroadcastd	glob_data + 11480(%rip), %ymm8
	vpbroadcastd	glob_data + 11484(%rip), %ymm9
	vpsubd	%ymm1, %ymm10, %ymm12
	vpaddd	%ymm10, %ymm1, %ymm10
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm1
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm1, %ymm1
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm1
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm10, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm10
	vpsubd	%ymm3, %ymm11, %ymm12
	vpaddd	%ymm11, %ymm3, %ymm11
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm3, %ymm3
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm13, %ymm3, %ymm3
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm8, %ymm11, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm11, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm11
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm5, %ymm5
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm13, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm14
	vpmuldq	%ymm8, %ymm2, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm2, %ymm12, %ymm2
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm13, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm0, %ymm12
	vpaddd	%ymm0, %ymm4, %ymm0
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm4
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm6
	vpmuldq	%ymm7, %ymm14, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm6
	vmovshdup	%ymm0, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm0, %ymm4, %ymm0
	vpsubq	%ymm8, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vmovdqu	%ymm10, (%rsi)
	vmovdqu	%ymm11, 128(%rsi)
	vmovdqu	%ymm2, 256(%rsi)
	vmovdqu	%ymm0, 384(%rsi)
	vmovdqu	%ymm1, 512(%rsi)
	vmovdqu	%ymm3, 640(%rsi)
	vmovdqu	%ymm5, 768(%rsi)
	vmovdqu	%ymm6, 896(%rsi)
	vmovdqu	32(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm7
	vmovdqu	288(%rsi), %ymm0
	vmovdqu	416(%rsi), %ymm5
	vmovdqu	544(%rsi), %ymm6
	vmovdqu	672(%rsi), %ymm8
	vmovdqu	800(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm3
	vpbroadcastd	glob_data + 11640(%rip), %ymm11
	vpbroadcastd	glob_data + 11520(%rip), %ymm9
	vpsubd	%ymm2, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11644(%rip), %ymm11
	vpbroadcastd	glob_data + 11524(%rip), %ymm9
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm0, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm7
	vpbroadcastd	glob_data + 11648(%rip), %ymm11
	vpbroadcastd	glob_data + 11528(%rip), %ymm9
	vpsubd	%ymm6, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11652(%rip), %ymm11
	vpbroadcastd	glob_data + 11532(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm1, %ymm8
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm9
	vpbroadcastd	glob_data + 11632(%rip), %ymm11
	vpbroadcastd	glob_data + 11512(%rip), %ymm10
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm1
	vmovshdup	%ymm12, %ymm5
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm11, %ymm5, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm12
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm12, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm4, %ymm3
	vmovshdup	%ymm12, %ymm7
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm7, %ymm5
	vpmuldq	%ymm10, %ymm12, %ymm11
	vpmuldq	%ymm10, %ymm7, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11636(%rip), %ymm12
	vpbroadcastd	glob_data + 11516(%rip), %ymm7
	vpsubd	%ymm6, %ymm8, %ymm11
	vpaddd	%ymm8, %ymm6, %ymm10
	vmovshdup	%ymm11, %ymm6
	vpmuldq	%ymm12, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm6, %ymm8
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm0, %ymm9, %ymm6
	vpaddd	%ymm9, %ymm0, %ymm11
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm12, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11472(%rip), %ymm6
	vpbroadcastd	glob_data + 11476(%rip), %ymm7
	vpbroadcastd	glob_data + 11480(%rip), %ymm8
	vpbroadcastd	glob_data + 11484(%rip), %ymm9
	vpsubd	%ymm1, %ymm10, %ymm12
	vpaddd	%ymm10, %ymm1, %ymm10
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm1
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm1, %ymm1
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm1
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm10, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm10
	vpsubd	%ymm3, %ymm11, %ymm12
	vpaddd	%ymm11, %ymm3, %ymm11
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm3, %ymm3
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm13, %ymm3, %ymm3
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm8, %ymm11, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm11, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm11
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm5, %ymm5
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm13, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm14
	vpmuldq	%ymm8, %ymm2, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm2, %ymm12, %ymm2
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm13, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm0, %ymm12
	vpaddd	%ymm0, %ymm4, %ymm0
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm4
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm6
	vpmuldq	%ymm7, %ymm14, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm6
	vmovshdup	%ymm0, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm0, %ymm4, %ymm0
	vpsubq	%ymm8, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vmovdqu	%ymm10, 32(%rsi)
	vmovdqu	%ymm11, 160(%rsi)
	vmovdqu	%ymm2, 288(%rsi)
	vmovdqu	%ymm0, 416(%rsi)
	vmovdqu	%ymm1, 544(%rsi)
	vmovdqu	%ymm3, 672(%rsi)
	vmovdqu	%ymm5, 800(%rsi)
	vmovdqu	%ymm6, 928(%rsi)
	vmovdqu	64(%rsi), %ymm2
	vmovdqu	192(%rsi), %ymm7
	vmovdqu	320(%rsi), %ymm0
	vmovdqu	448(%rsi), %ymm5
	vmovdqu	576(%rsi), %ymm6
	vmovdqu	704(%rsi), %ymm8
	vmovdqu	832(%rsi), %ymm1
	vmovdqu	960(%rsi), %ymm3
	vpbroadcastd	glob_data + 11640(%rip), %ymm11
	vpbroadcastd	glob_data + 11520(%rip), %ymm9
	vpsubd	%ymm2, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11644(%rip), %ymm11
	vpbroadcastd	glob_data + 11524(%rip), %ymm9
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm0, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm7
	vpbroadcastd	glob_data + 11648(%rip), %ymm11
	vpbroadcastd	glob_data + 11528(%rip), %ymm9
	vpsubd	%ymm6, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11652(%rip), %ymm11
	vpbroadcastd	glob_data + 11532(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm1, %ymm8
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm9
	vpbroadcastd	glob_data + 11632(%rip), %ymm11
	vpbroadcastd	glob_data + 11512(%rip), %ymm10
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm1
	vmovshdup	%ymm12, %ymm5
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm11, %ymm5, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm12
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm12, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm4, %ymm3
	vmovshdup	%ymm12, %ymm7
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm7, %ymm5
	vpmuldq	%ymm10, %ymm12, %ymm11
	vpmuldq	%ymm10, %ymm7, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11636(%rip), %ymm12
	vpbroadcastd	glob_data + 11516(%rip), %ymm7
	vpsubd	%ymm6, %ymm8, %ymm11
	vpaddd	%ymm8, %ymm6, %ymm10
	vmovshdup	%ymm11, %ymm6
	vpmuldq	%ymm12, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm6, %ymm8
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm0, %ymm9, %ymm6
	vpaddd	%ymm9, %ymm0, %ymm11
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm12, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11472(%rip), %ymm6
	vpbroadcastd	glob_data + 11476(%rip), %ymm7
	vpbroadcastd	glob_data + 11480(%rip), %ymm8
	vpbroadcastd	glob_data + 11484(%rip), %ymm9
	vpsubd	%ymm1, %ymm10, %ymm12
	vpaddd	%ymm10, %ymm1, %ymm10
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm1
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm1, %ymm1
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm1
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm10, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm10
	vpsubd	%ymm3, %ymm11, %ymm12
	vpaddd	%ymm11, %ymm3, %ymm11
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm3, %ymm3
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm13, %ymm3, %ymm3
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm8, %ymm11, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm11, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm11
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm5, %ymm5
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm13, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm14
	vpmuldq	%ymm8, %ymm2, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm2, %ymm12, %ymm2
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm13, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm0, %ymm12
	vpaddd	%ymm0, %ymm4, %ymm0
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm4
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm6
	vpmuldq	%ymm7, %ymm14, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm6
	vmovshdup	%ymm0, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm0, %ymm4, %ymm0
	vpsubq	%ymm8, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vmovdqu	%ymm10, 64(%rsi)
	vmovdqu	%ymm11, 192(%rsi)
	vmovdqu	%ymm2, 320(%rsi)
	vmovdqu	%ymm0, 448(%rsi)
	vmovdqu	%ymm1, 576(%rsi)
	vmovdqu	%ymm3, 704(%rsi)
	vmovdqu	%ymm5, 832(%rsi)
	vmovdqu	%ymm6, 960(%rsi)
	vmovdqu	96(%rsi), %ymm2
	vmovdqu	224(%rsi), %ymm7
	vmovdqu	352(%rsi), %ymm0
	vmovdqu	480(%rsi), %ymm5
	vmovdqu	608(%rsi), %ymm6
	vmovdqu	736(%rsi), %ymm8
	vmovdqu	864(%rsi), %ymm1
	vmovdqu	992(%rsi), %ymm3
	vpbroadcastd	glob_data + 11640(%rip), %ymm11
	vpbroadcastd	glob_data + 11520(%rip), %ymm9
	vpsubd	%ymm2, %ymm7, %ymm10
	vpaddd	%ymm7, %ymm2, %ymm2
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11644(%rip), %ymm11
	vpbroadcastd	glob_data + 11524(%rip), %ymm9
	vpsubd	%ymm0, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm0, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm7
	vpbroadcastd	glob_data + 11648(%rip), %ymm11
	vpbroadcastd	glob_data + 11528(%rip), %ymm9
	vpsubd	%ymm6, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm8, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11652(%rip), %ymm11
	vpbroadcastd	glob_data + 11532(%rip), %ymm9
	vpsubd	%ymm1, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm1, %ymm8
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm9
	vpbroadcastd	glob_data + 11632(%rip), %ymm11
	vpbroadcastd	glob_data + 11512(%rip), %ymm10
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm1
	vmovshdup	%ymm12, %ymm5
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm11, %ymm5, %ymm3
	vpmuldq	%ymm10, %ymm12, %ymm12
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm12, %ymm2, %ymm2
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm7, %ymm12
	vpaddd	%ymm7, %ymm4, %ymm3
	vmovshdup	%ymm12, %ymm7
	vpmuldq	%ymm11, %ymm12, %ymm4
	vpmuldq	%ymm11, %ymm7, %ymm5
	vpmuldq	%ymm10, %ymm12, %ymm11
	vpmuldq	%ymm10, %ymm7, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm7, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpbroadcastd	glob_data + 11636(%rip), %ymm12
	vpbroadcastd	glob_data + 11516(%rip), %ymm7
	vpsubd	%ymm6, %ymm8, %ymm11
	vpaddd	%ymm8, %ymm6, %ymm10
	vmovshdup	%ymm11, %ymm6
	vpmuldq	%ymm12, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm6, %ymm8
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm6, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vpsubd	%ymm0, %ymm9, %ymm6
	vpaddd	%ymm9, %ymm0, %ymm11
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm12, %ymm6, %ymm0
	vpmuldq	%ymm12, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm7, %ymm0, %ymm0
	vpbroadcastd	glob_data + 11472(%rip), %ymm6
	vpbroadcastd	glob_data + 11476(%rip), %ymm7
	vpbroadcastd	glob_data + 11480(%rip), %ymm8
	vpbroadcastd	glob_data + 11484(%rip), %ymm9
	vpsubd	%ymm1, %ymm10, %ymm12
	vpaddd	%ymm10, %ymm1, %ymm10
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm1
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm1, %ymm1
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm1
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm10, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm10
	vpsubd	%ymm3, %ymm11, %ymm12
	vpaddd	%ymm11, %ymm3, %ymm11
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm3
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm3, %ymm3
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm13, %ymm3, %ymm3
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm8, %ymm11, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm11, %ymm12, %ymm12
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm12, %ymm12
	vpblendd	$170, %ymm13, %ymm12, %ymm11
	vpsubd	%ymm2, %ymm5, %ymm12
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm5
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	%ymm7, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm12, %ymm5, %ymm5
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm13, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm14
	vpmuldq	%ymm8, %ymm2, %ymm12
	vpmuldq	%ymm8, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm14, %ymm14
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm14, %ymm14
	vpsubq	%ymm2, %ymm12, %ymm2
	vpsubq	%ymm14, %ymm13, %ymm13
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm13, %ymm2, %ymm2
	vpsubd	%ymm4, %ymm0, %ymm12
	vpaddd	%ymm0, %ymm4, %ymm0
	vmovshdup	%ymm12, %ymm14
	vpmuldq	%ymm6, %ymm12, %ymm4
	vpmuldq	%ymm6, %ymm14, %ymm13
	vpmuldq	%ymm7, %ymm12, %ymm6
	vpmuldq	%ymm7, %ymm14, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm6
	vmovshdup	%ymm0, %ymm12
	vpmuldq	%ymm8, %ymm0, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm0, %ymm4, %ymm0
	vpsubq	%ymm8, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm4, %ymm0, %ymm0
	vmovdqu	%ymm10, 96(%rsi)
	vmovdqu	%ymm11, 224(%rsi)
	vmovdqu	%ymm2, 352(%rsi)
	vmovdqu	%ymm0, 480(%rsi)
	vmovdqu	%ymm1, 608(%rsi)
	vmovdqu	%ymm3, 736(%rsi)
	vmovdqu	%ymm5, 864(%rsi)
	vmovdqu	%ymm6, 992(%rsi)
	ret
.Lpolynomial__ntt$1:
	vmovdqu	(%rsi), %ymm1
	vmovdqu	128(%rsi), %ymm9
	vmovdqu	256(%rsi), %ymm2
	vmovdqu	384(%rsi), %ymm3
	vmovdqu	512(%rsi), %ymm11
	vmovdqu	640(%rsi), %ymm10
	vmovdqu	768(%rsi), %ymm4
	vmovdqu	896(%rsi), %ymm6
	vpbroadcastd	glob_data + 11488(%rip), %ymm8
	vpbroadcastd	glob_data + 11492(%rip), %ymm7
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm5
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm0
	vpaddd	%ymm5, %ymm1, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm1
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm1
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm12, %ymm4
	vpsubq	%ymm10, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm4
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm3, %ymm6
	vpaddd	%ymm10, %ymm3, %ymm10
	vpbroadcastd	glob_data + 11496(%rip), %ymm8
	vpbroadcastd	glob_data + 11500(%rip), %ymm7
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm3
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm2, %ymm3, %ymm2
	vpsubq	%ymm12, %ymm13, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm5, %ymm2
	vpaddd	%ymm3, %ymm5, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm10
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm9, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm11
	vpbroadcastd	glob_data + 11504(%rip), %ymm8
	vpbroadcastd	glob_data + 11508(%rip), %ymm7
	vmovshdup	%ymm4, %ymm9
	vpmuldq	%ymm8, %ymm4, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm9, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm4
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm6
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovdqu	glob_data + 6080(%rip), %ymm8
	vmovdqu	glob_data + 2112(%rip), %ymm9
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm8, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm7
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 6112(%rip), %ymm8
	vmovdqu	glob_data + 2144(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm5
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovdqu	glob_data + 6144(%rip), %ymm11
	vmovdqu	glob_data + 2176(%rip), %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm11, %ymm1, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm1
	vpaddd	%ymm10, %ymm0, %ymm0
	vmovdqu	glob_data + 6176(%rip), %ymm11
	vmovdqu	glob_data + 2208(%rip), %ymm9
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm11, %ymm6, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm4, %ymm6
	vpaddd	%ymm10, %ymm4, %ymm4
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm7, 128(%rsi)
	vmovdqu	%ymm2, 256(%rsi)
	vmovdqu	%ymm5, 384(%rsi)
	vmovdqu	%ymm0, 512(%rsi)
	vmovdqu	%ymm1, 640(%rsi)
	vmovdqu	%ymm4, 768(%rsi)
	vmovdqu	%ymm6, 896(%rsi)
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	160(%rsi), %ymm9
	vmovdqu	288(%rsi), %ymm0
	vmovdqu	416(%rsi), %ymm2
	vmovdqu	544(%rsi), %ymm11
	vmovdqu	672(%rsi), %ymm10
	vmovdqu	800(%rsi), %ymm4
	vmovdqu	928(%rsi), %ymm6
	vpbroadcastd	glob_data + 11488(%rip), %ymm8
	vpbroadcastd	glob_data + 11492(%rip), %ymm7
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm1
	vpmuldq	%ymm8, %ymm12, %ymm5
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm1
	vpaddd	%ymm5, %ymm3, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm3
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm13, %ymm3, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm3
	vpaddd	%ymm10, %ymm9, %ymm11
	vmovshdup	%ymm4, %ymm9
	vpmuldq	%ymm8, %ymm4, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm4, %ymm12, %ymm4
	vpsubq	%ymm9, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm4
	vpaddd	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm6
	vpaddd	%ymm10, %ymm2, %ymm7
	vpbroadcastd	glob_data + 11496(%rip), %ymm8
	vpbroadcastd	glob_data + 11500(%rip), %ymm9
	vmovshdup	%ymm0, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm2
	vpmuldq	%ymm8, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm0, %ymm2, %ymm0
	vpsubq	%ymm10, %ymm13, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm10
	vpsubd	%ymm10, %ymm5, %ymm0
	vpaddd	%ymm10, %ymm5, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm8, %ymm7, %ymm5
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm7, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm11, %ymm10
	vpaddd	%ymm5, %ymm11, %ymm11
	vpbroadcastd	glob_data + 11504(%rip), %ymm8
	vpbroadcastd	glob_data + 11508(%rip), %ymm7
	vmovshdup	%ymm4, %ymm9
	vpmuldq	%ymm8, %ymm4, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm9, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm4
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm6
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 6080(%rip), %ymm8
	vmovdqu	glob_data + 2112(%rip), %ymm9
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm8, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm2, %ymm7
	vpaddd	%ymm5, %ymm2, %ymm2
	vmovdqu	glob_data + 6112(%rip), %ymm8
	vmovdqu	glob_data + 2144(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm5
	vpaddd	%ymm10, %ymm0, %ymm0
	vmovdqu	glob_data + 6144(%rip), %ymm11
	vmovdqu	glob_data + 2176(%rip), %ymm9
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm11, %ymm3, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm8, %ymm3
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm10
	vpsubd	%ymm10, %ymm1, %ymm3
	vpaddd	%ymm10, %ymm1, %ymm1
	vmovdqu	glob_data + 6176(%rip), %ymm11
	vmovdqu	glob_data + 2208(%rip), %ymm9
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm11, %ymm6, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm4, %ymm6
	vpaddd	%ymm10, %ymm4, %ymm4
	vmovdqu	%ymm2, 32(%rsi)
	vmovdqu	%ymm7, 160(%rsi)
	vmovdqu	%ymm0, 288(%rsi)
	vmovdqu	%ymm5, 416(%rsi)
	vmovdqu	%ymm1, 544(%rsi)
	vmovdqu	%ymm3, 672(%rsi)
	vmovdqu	%ymm4, 800(%rsi)
	vmovdqu	%ymm6, 928(%rsi)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	192(%rsi), %ymm9
	vmovdqu	320(%rsi), %ymm2
	vmovdqu	448(%rsi), %ymm3
	vmovdqu	576(%rsi), %ymm11
	vmovdqu	704(%rsi), %ymm10
	vmovdqu	832(%rsi), %ymm4
	vmovdqu	960(%rsi), %ymm6
	vpbroadcastd	glob_data + 11488(%rip), %ymm8
	vpbroadcastd	glob_data + 11492(%rip), %ymm7
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm5
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm0
	vpaddd	%ymm5, %ymm1, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm1
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm1
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm12, %ymm4
	vpsubq	%ymm10, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm4
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm3, %ymm6
	vpaddd	%ymm10, %ymm3, %ymm10
	vpbroadcastd	glob_data + 11496(%rip), %ymm8
	vpbroadcastd	glob_data + 11500(%rip), %ymm7
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm3
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm2, %ymm3, %ymm2
	vpsubq	%ymm12, %ymm13, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm5, %ymm2
	vpaddd	%ymm3, %ymm5, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm10
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm9, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm11
	vpbroadcastd	glob_data + 11504(%rip), %ymm8
	vpbroadcastd	glob_data + 11508(%rip), %ymm7
	vmovshdup	%ymm4, %ymm9
	vpmuldq	%ymm8, %ymm4, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm9, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm4
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm6
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovdqu	glob_data + 6080(%rip), %ymm8
	vmovdqu	glob_data + 2112(%rip), %ymm9
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm8, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm7
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 6112(%rip), %ymm8
	vmovdqu	glob_data + 2144(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm5
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovdqu	glob_data + 6144(%rip), %ymm11
	vmovdqu	glob_data + 2176(%rip), %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm11, %ymm1, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm1
	vpaddd	%ymm10, %ymm0, %ymm0
	vmovdqu	glob_data + 6176(%rip), %ymm11
	vmovdqu	glob_data + 2208(%rip), %ymm9
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm11, %ymm6, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm4, %ymm6
	vpaddd	%ymm10, %ymm4, %ymm4
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	%ymm7, 192(%rsi)
	vmovdqu	%ymm2, 320(%rsi)
	vmovdqu	%ymm5, 448(%rsi)
	vmovdqu	%ymm0, 576(%rsi)
	vmovdqu	%ymm1, 704(%rsi)
	vmovdqu	%ymm4, 832(%rsi)
	vmovdqu	%ymm6, 960(%rsi)
	vmovdqu	96(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm9
	vmovdqu	352(%rsi), %ymm2
	vmovdqu	480(%rsi), %ymm3
	vmovdqu	608(%rsi), %ymm11
	vmovdqu	736(%rsi), %ymm10
	vmovdqu	864(%rsi), %ymm4
	vmovdqu	992(%rsi), %ymm6
	vpbroadcastd	glob_data + 11488(%rip), %ymm8
	vpbroadcastd	glob_data + 11492(%rip), %ymm7
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm0
	vpmuldq	%ymm8, %ymm12, %ymm5
	vpmuldq	%ymm7, %ymm11, %ymm11
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm0
	vpaddd	%ymm5, %ymm1, %ymm5
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm1
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm1
	vpaddd	%ymm10, %ymm9, %ymm9
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm8, %ymm4, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm12, %ymm4
	vpsubq	%ymm10, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm4
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm3, %ymm6
	vpaddd	%ymm10, %ymm3, %ymm10
	vpbroadcastd	glob_data + 11496(%rip), %ymm8
	vpbroadcastd	glob_data + 11500(%rip), %ymm7
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm3
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm2, %ymm3, %ymm2
	vpsubq	%ymm12, %ymm13, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm3
	vpsubd	%ymm3, %ymm5, %ymm2
	vpaddd	%ymm3, %ymm5, %ymm3
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm10
	vpsubq	%ymm7, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm9, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm11
	vpbroadcastd	glob_data + 11504(%rip), %ymm8
	vpbroadcastd	glob_data + 11508(%rip), %ymm7
	vmovshdup	%ymm4, %ymm9
	vpmuldq	%ymm8, %ymm4, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm9, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm4
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm6
	vpaddd	%ymm5, %ymm1, %ymm1
	vmovdqu	glob_data + 6080(%rip), %ymm8
	vmovdqu	glob_data + 2112(%rip), %ymm9
	vmovshdup	%ymm11, %ymm12
	vpmuldq	%ymm8, %ymm11, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm11, %ymm11
	vpmuldq	%ymm9, %ymm12, %ymm8
	vpmuldq	glob_data + 9184(%rip), %ymm11, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm8, %ymm8
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm8, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm3, %ymm7
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 6112(%rip), %ymm8
	vmovdqu	glob_data + 2144(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm10
	vpsubd	%ymm10, %ymm2, %ymm5
	vpaddd	%ymm10, %ymm2, %ymm2
	vmovdqu	glob_data + 6144(%rip), %ymm11
	vmovdqu	glob_data + 2176(%rip), %ymm9
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm11, %ymm1, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm1, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm1, %ymm8, %ymm1
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm1
	vpaddd	%ymm10, %ymm0, %ymm0
	vmovdqu	glob_data + 6176(%rip), %ymm11
	vmovdqu	glob_data + 2208(%rip), %ymm9
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm11, %ymm6, %ymm8
	vpmuldq	%ymm11, %ymm10, %ymm13
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm8, %ymm6
	vpsubq	%ymm9, %ymm13, %ymm8
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm8, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm4, %ymm6
	vpaddd	%ymm10, %ymm4, %ymm4
	vmovdqu	%ymm3, 96(%rsi)
	vmovdqu	%ymm7, 224(%rsi)
	vmovdqu	%ymm2, 352(%rsi)
	vmovdqu	%ymm5, 480(%rsi)
	vmovdqu	%ymm0, 608(%rsi)
	vmovdqu	%ymm1, 736(%rsi)
	vmovdqu	%ymm4, 864(%rsi)
	vmovdqu	%ymm6, 992(%rsi)
	vmovdqu	(%rsi), %ymm5
	vmovdqu	32(%rsi), %ymm9
	vmovdqu	64(%rsi), %ymm10
	vmovdqu	96(%rsi), %ymm6
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm2
	vmovdqu	192(%rsi), %ymm0
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	glob_data + 6208(%rip), %ymm8
	vmovdqu	glob_data + 2240(%rip), %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm5, %ymm4
	vpaddd	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm6
	vpaddd	%ymm10, %ymm9, %ymm10
	vmovdqu	glob_data + 6240(%rip), %ymm8
	vmovdqu	glob_data + 2272(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm0, %ymm12, %ymm0
	vpsubq	%ymm9, %ymm13, %ymm13
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm13, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vpmuldq	%ymm8, %ymm3, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm12, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm3
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 6464(%rip), %ymm11
	vmovdqu	glob_data + 2496(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm7
	vpaddd	%ymm9, %ymm5, %ymm10
	vmovdqu	glob_data + 6496(%rip), %ymm8
	vmovdqu	glob_data + 2528(%rip), %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovdqu	glob_data + 6528(%rip), %ymm8
	vmovdqu	glob_data + 2560(%rip), %ymm9
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm2, %ymm6, %ymm2
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm2
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovdqu	glob_data + 6560(%rip), %ymm8
	vmovdqu	glob_data + 2592(%rip), %ymm9
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm6, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm0, %ymm3
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovdqu	glob_data + 6976(%rip), %ymm11
	vmovdqu	glob_data + 3008(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm10, %ymm6
	vperm2i128	$49, %ymm7, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 7008(%rip), %ymm11
	vmovdqu	glob_data + 3040(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7040(%rip), %ymm11
	vmovdqu	glob_data + 3072(%rip), %ymm9
	vperm2i128	$32, %ymm2, %ymm1, %ymm8
	vperm2i128	$49, %ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm2, %ymm1
	vperm2i128	$49, %ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7072(%rip), %ymm11
	vmovdqu	glob_data + 3104(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 7488(%rip), %ymm11
	vmovdqu	glob_data + 3520(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm9
	vpsubd	%ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm9, %ymm6
	vpunpckhqdq	%ymm7, %ymm9, %ymm7
	vmovdqu	glob_data + 7520(%rip), %ymm11
	vmovdqu	glob_data + 3552(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7552(%rip), %ymm11
	vmovdqu	glob_data + 3584(%rip), %ymm9
	vpunpcklqdq	%ymm2, %ymm1, %ymm8
	vpunpckhqdq	%ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7584(%rip), %ymm11
	vmovdqu	glob_data + 3616(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 8000(%rip), %ymm8
	vmovdqu	glob_data + 4032(%rip), %ymm9
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm11
	vmovshdup	%ymm8, %ymm12
	vmovshdup	%ymm9, %ymm7
	vpunpcklqdq	%ymm11, %ymm10, %ymm6
	vpunpckhqdq	%ymm11, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm7, %ymm14, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm9
	vpsubq	%ymm7, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm13, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm8, %ymm6
	vpunpckhqdq	%ymm7, %ymm8, %ymm7
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 8032(%rip), %ymm6
	vmovdqu	glob_data + 4064(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm4
	vpunpcklqdq	%ymm5, %ymm11, %ymm8
	vpunpckhqdq	%ymm5, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm4, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm6, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 8064(%rip), %ymm6
	vmovdqu	glob_data + 4096(%rip), %ymm9
	vpshufd	$216, %ymm1, %ymm11
	vpshufd	$216, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm1
	vpunpcklqdq	%ymm2, %ymm11, %ymm8
	vpunpckhqdq	%ymm2, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm1, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm1, %ymm2, %ymm1
	vpsubq	%ymm6, %ymm13, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8096(%rip), %ymm6
	vmovdqu	glob_data + 4128(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm0
	vpunpcklqdq	%ymm3, %ymm11, %ymm8
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm3
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm0, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm0, %ymm3, %ymm0
	vpsubq	%ymm6, %ymm13, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm6
	vmovdqu	%ymm10, (%rsi)
	vmovdqu	%ymm7, 32(%rsi)
	vmovdqu	%ymm4, 64(%rsi)
	vmovdqu	%ymm5, 96(%rsi)
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	%ymm2, 160(%rsi)
	vmovdqu	%ymm0, 192(%rsi)
	vmovdqu	%ymm6, 224(%rsi)
	vmovdqu	256(%rsi), %ymm5
	vmovdqu	288(%rsi), %ymm9
	vmovdqu	320(%rsi), %ymm10
	vmovdqu	352(%rsi), %ymm6
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm2
	vmovdqu	448(%rsi), %ymm0
	vmovdqu	480(%rsi), %ymm3
	vmovdqu	glob_data + 6272(%rip), %ymm8
	vmovdqu	glob_data + 2304(%rip), %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm5, %ymm4
	vpaddd	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm6
	vpaddd	%ymm10, %ymm9, %ymm10
	vmovdqu	glob_data + 6304(%rip), %ymm8
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm0, %ymm12, %ymm0
	vpsubq	%ymm9, %ymm13, %ymm13
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm13, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vpmuldq	%ymm8, %ymm3, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm12, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm3
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 6592(%rip), %ymm11
	vmovdqu	glob_data + 2624(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm7
	vpaddd	%ymm9, %ymm5, %ymm10
	vmovdqu	glob_data + 6624(%rip), %ymm8
	vmovdqu	glob_data + 2656(%rip), %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovdqu	glob_data + 6656(%rip), %ymm8
	vmovdqu	glob_data + 2688(%rip), %ymm9
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm2, %ymm6, %ymm2
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm2
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovdqu	glob_data + 6688(%rip), %ymm8
	vmovdqu	glob_data + 2720(%rip), %ymm9
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm6, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm0, %ymm3
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovdqu	glob_data + 7104(%rip), %ymm11
	vmovdqu	glob_data + 3136(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm10, %ymm6
	vperm2i128	$49, %ymm7, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 7136(%rip), %ymm11
	vmovdqu	glob_data + 3168(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7168(%rip), %ymm11
	vmovdqu	glob_data + 3200(%rip), %ymm9
	vperm2i128	$32, %ymm2, %ymm1, %ymm8
	vperm2i128	$49, %ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm2, %ymm1
	vperm2i128	$49, %ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7200(%rip), %ymm11
	vmovdqu	glob_data + 3232(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 7616(%rip), %ymm11
	vmovdqu	glob_data + 3648(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm9
	vpsubd	%ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm9, %ymm6
	vpunpckhqdq	%ymm7, %ymm9, %ymm7
	vmovdqu	glob_data + 7648(%rip), %ymm11
	vmovdqu	glob_data + 3680(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7680(%rip), %ymm11
	vmovdqu	glob_data + 3712(%rip), %ymm9
	vpunpcklqdq	%ymm2, %ymm1, %ymm8
	vpunpckhqdq	%ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7712(%rip), %ymm11
	vmovdqu	glob_data + 3744(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 8128(%rip), %ymm8
	vmovdqu	glob_data + 4160(%rip), %ymm9
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm11
	vmovshdup	%ymm8, %ymm12
	vmovshdup	%ymm9, %ymm7
	vpunpcklqdq	%ymm11, %ymm10, %ymm6
	vpunpckhqdq	%ymm11, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm7, %ymm14, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm9
	vpsubq	%ymm7, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm13, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm8, %ymm6
	vpunpckhqdq	%ymm7, %ymm8, %ymm7
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 8160(%rip), %ymm6
	vmovdqu	glob_data + 4192(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm4
	vpunpcklqdq	%ymm5, %ymm11, %ymm8
	vpunpckhqdq	%ymm5, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm4, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm6, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 8192(%rip), %ymm6
	vmovdqu	glob_data + 4224(%rip), %ymm9
	vpshufd	$216, %ymm1, %ymm11
	vpshufd	$216, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm1
	vpunpcklqdq	%ymm2, %ymm11, %ymm8
	vpunpckhqdq	%ymm2, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm1, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm1, %ymm2, %ymm1
	vpsubq	%ymm6, %ymm13, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8224(%rip), %ymm6
	vmovdqu	glob_data + 4256(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm0
	vpunpcklqdq	%ymm3, %ymm11, %ymm8
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm3
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm0, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm0, %ymm3, %ymm0
	vpsubq	%ymm6, %ymm13, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm6
	vmovdqu	%ymm10, 256(%rsi)
	vmovdqu	%ymm7, 288(%rsi)
	vmovdqu	%ymm4, 320(%rsi)
	vmovdqu	%ymm5, 352(%rsi)
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	%ymm2, 416(%rsi)
	vmovdqu	%ymm0, 448(%rsi)
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	512(%rsi), %ymm5
	vmovdqu	544(%rsi), %ymm9
	vmovdqu	576(%rsi), %ymm10
	vmovdqu	608(%rsi), %ymm6
	vmovdqu	640(%rsi), %ymm1
	vmovdqu	672(%rsi), %ymm2
	vmovdqu	704(%rsi), %ymm0
	vmovdqu	736(%rsi), %ymm3
	vmovdqu	glob_data + 6336(%rip), %ymm8
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm5, %ymm4
	vpaddd	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm6
	vpaddd	%ymm10, %ymm9, %ymm10
	vmovdqu	glob_data + 6368(%rip), %ymm8
	vmovdqu	glob_data + 2400(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm0, %ymm12, %ymm0
	vpsubq	%ymm9, %ymm13, %ymm13
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm13, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vpmuldq	%ymm8, %ymm3, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm12, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm3
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 6720(%rip), %ymm11
	vmovdqu	glob_data + 2752(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm7
	vpaddd	%ymm9, %ymm5, %ymm10
	vmovdqu	glob_data + 6752(%rip), %ymm8
	vmovdqu	glob_data + 2784(%rip), %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovdqu	glob_data + 6784(%rip), %ymm8
	vmovdqu	glob_data + 2816(%rip), %ymm9
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm2, %ymm6, %ymm2
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm2
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovdqu	glob_data + 6816(%rip), %ymm8
	vmovdqu	glob_data + 2848(%rip), %ymm9
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm6, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm0, %ymm3
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovdqu	glob_data + 7232(%rip), %ymm11
	vmovdqu	glob_data + 3264(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm10, %ymm6
	vperm2i128	$49, %ymm7, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 7264(%rip), %ymm11
	vmovdqu	glob_data + 3296(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7296(%rip), %ymm11
	vmovdqu	glob_data + 3328(%rip), %ymm9
	vperm2i128	$32, %ymm2, %ymm1, %ymm8
	vperm2i128	$49, %ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm2, %ymm1
	vperm2i128	$49, %ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7328(%rip), %ymm11
	vmovdqu	glob_data + 3360(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 7744(%rip), %ymm11
	vmovdqu	glob_data + 3776(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm9
	vpsubd	%ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm9, %ymm6
	vpunpckhqdq	%ymm7, %ymm9, %ymm7
	vmovdqu	glob_data + 7776(%rip), %ymm11
	vmovdqu	glob_data + 3808(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7808(%rip), %ymm11
	vmovdqu	glob_data + 3840(%rip), %ymm9
	vpunpcklqdq	%ymm2, %ymm1, %ymm8
	vpunpckhqdq	%ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7840(%rip), %ymm11
	vmovdqu	glob_data + 3872(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 8256(%rip), %ymm8
	vmovdqu	glob_data + 4288(%rip), %ymm9
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm11
	vmovshdup	%ymm8, %ymm12
	vmovshdup	%ymm9, %ymm7
	vpunpcklqdq	%ymm11, %ymm10, %ymm6
	vpunpckhqdq	%ymm11, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm7, %ymm14, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm9
	vpsubq	%ymm7, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm13, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm8, %ymm6
	vpunpckhqdq	%ymm7, %ymm8, %ymm7
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 8288(%rip), %ymm6
	vmovdqu	glob_data + 4320(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm4
	vpunpcklqdq	%ymm5, %ymm11, %ymm8
	vpunpckhqdq	%ymm5, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm4, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm6, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 8320(%rip), %ymm6
	vmovdqu	glob_data + 4352(%rip), %ymm9
	vpshufd	$216, %ymm1, %ymm11
	vpshufd	$216, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm1
	vpunpcklqdq	%ymm2, %ymm11, %ymm8
	vpunpckhqdq	%ymm2, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm1, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm1, %ymm2, %ymm1
	vpsubq	%ymm6, %ymm13, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8352(%rip), %ymm6
	vmovdqu	glob_data + 4384(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm0
	vpunpcklqdq	%ymm3, %ymm11, %ymm8
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm3
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm0, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm0, %ymm3, %ymm0
	vpsubq	%ymm6, %ymm13, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm6
	vmovdqu	%ymm10, 512(%rsi)
	vmovdqu	%ymm7, 544(%rsi)
	vmovdqu	%ymm4, 576(%rsi)
	vmovdqu	%ymm5, 608(%rsi)
	vmovdqu	%ymm1, 640(%rsi)
	vmovdqu	%ymm2, 672(%rsi)
	vmovdqu	%ymm0, 704(%rsi)
	vmovdqu	%ymm6, 736(%rsi)
	vmovdqu	768(%rsi), %ymm5
	vmovdqu	800(%rsi), %ymm9
	vmovdqu	832(%rsi), %ymm10
	vmovdqu	864(%rsi), %ymm6
	vmovdqu	896(%rsi), %ymm1
	vmovdqu	928(%rsi), %ymm2
	vmovdqu	960(%rsi), %ymm0
	vmovdqu	992(%rsi), %ymm3
	vmovdqu	glob_data + 6400(%rip), %ymm8
	vmovdqu	glob_data + 2432(%rip), %ymm7
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm4
	vpmuldq	%ymm8, %ymm12, %ymm13
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm7, %ymm12, %ymm12
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm12, %ymm12
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm12, %ymm13, %ymm13
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm13, %ymm4, %ymm10
	vpsubd	%ymm10, %ymm5, %ymm4
	vpaddd	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm12
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm12, %ymm6
	vpsubq	%ymm10, %ymm8, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm10
	vpsubd	%ymm10, %ymm9, %ymm6
	vpaddd	%ymm10, %ymm9, %ymm10
	vmovdqu	glob_data + 6432(%rip), %ymm8
	vmovdqu	glob_data + 2464(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm13
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm0, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm0, %ymm12, %ymm0
	vpsubq	%ymm9, %ymm13, %ymm13
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm13, %ymm0, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm0
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovshdup	%ymm3, %ymm9
	vpmuldq	%ymm8, %ymm3, %ymm12
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm12, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm3
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 6848(%rip), %ymm11
	vmovdqu	glob_data + 2880(%rip), %ymm9
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm9
	vpsubd	%ymm9, %ymm5, %ymm7
	vpaddd	%ymm9, %ymm5, %ymm10
	vmovdqu	glob_data + 6880(%rip), %ymm8
	vmovdqu	glob_data + 2912(%rip), %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm8, %ymm6, %ymm5
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm6, %ymm5, %ymm5
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm9
	vpsubd	%ymm9, %ymm4, %ymm5
	vpaddd	%ymm9, %ymm4, %ymm4
	vmovdqu	glob_data + 6912(%rip), %ymm8
	vmovdqu	glob_data + 2944(%rip), %ymm9
	vmovshdup	%ymm2, %ymm12
	vpmuldq	%ymm8, %ymm2, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm2, %ymm6, %ymm2
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm8, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm2
	vpaddd	%ymm9, %ymm1, %ymm1
	vmovdqu	glob_data + 6944(%rip), %ymm8
	vmovdqu	glob_data + 2976(%rip), %ymm9
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm8, %ymm3, %ymm6
	vpmuldq	%ymm8, %ymm12, %ymm8
	vpmuldq	%ymm9, %ymm3, %ymm3
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm3, %ymm3
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm3, %ymm6, %ymm3
	vpsubq	%ymm9, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm9
	vpsubd	%ymm9, %ymm0, %ymm3
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovdqu	glob_data + 7360(%rip), %ymm11
	vmovdqu	glob_data + 3392(%rip), %ymm9
	vperm2i128	$32, %ymm7, %ymm10, %ymm6
	vperm2i128	$49, %ymm7, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm8
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 7392(%rip), %ymm11
	vmovdqu	glob_data + 3424(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7424(%rip), %ymm11
	vmovdqu	glob_data + 3456(%rip), %ymm9
	vperm2i128	$32, %ymm2, %ymm1, %ymm8
	vperm2i128	$49, %ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm2, %ymm1
	vperm2i128	$49, %ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7456(%rip), %ymm11
	vmovdqu	glob_data + 3488(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 7872(%rip), %ymm11
	vmovdqu	glob_data + 3904(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm6
	vpmuldq	%ymm11, %ymm12, %ymm7
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm6, %ymm6
	vpsubq	%ymm9, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm7
	vpaddd	%ymm7, %ymm8, %ymm9
	vpsubd	%ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm9, %ymm6
	vpunpckhqdq	%ymm7, %ymm9, %ymm7
	vmovdqu	glob_data + 7904(%rip), %ymm11
	vmovdqu	glob_data + 3936(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm4
	vpmuldq	%ymm11, %ymm12, %ymm5
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm4, %ymm4
	vpsubq	%ymm9, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 7936(%rip), %ymm11
	vmovdqu	glob_data + 3968(%rip), %ymm9
	vpunpcklqdq	%ymm2, %ymm1, %ymm8
	vpunpckhqdq	%ymm2, %ymm1, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm1
	vpmuldq	%ymm11, %ymm12, %ymm2
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm9, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vmovdqu	glob_data + 7968(%rip), %ymm11
	vmovdqu	glob_data + 4000(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm10
	vmovshdup	%ymm10, %ymm12
	vpmuldq	%ymm11, %ymm10, %ymm0
	vpmuldq	%ymm11, %ymm12, %ymm3
	vpmuldq	%ymm9, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm12, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm9
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm9, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 8384(%rip), %ymm8
	vmovdqu	glob_data + 4416(%rip), %ymm9
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm11
	vmovshdup	%ymm8, %ymm12
	vmovshdup	%ymm9, %ymm7
	vpunpcklqdq	%ymm11, %ymm10, %ymm6
	vpunpckhqdq	%ymm11, %ymm10, %ymm10
	vmovshdup	%ymm10, %ymm14
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm7, %ymm14, %ymm10
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm7
	vpmuldq	glob_data + 9184(%rip), %ymm10, %ymm9
	vpsubq	%ymm7, %ymm8, %ymm8
	vpsubq	%ymm9, %ymm13, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm8
	vpsubd	%ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm7, %ymm8, %ymm6
	vpunpckhqdq	%ymm7, %ymm8, %ymm7
	vpshufd	$216, %ymm6, %ymm10
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 8416(%rip), %ymm6
	vmovdqu	glob_data + 4448(%rip), %ymm9
	vpshufd	$216, %ymm4, %ymm11
	vpshufd	$216, %ymm5, %ymm5
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm4
	vpunpcklqdq	%ymm5, %ymm11, %ymm8
	vpunpckhqdq	%ymm5, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm5
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm4, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm4
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm4, %ymm5, %ymm4
	vpsubq	%ymm6, %ymm13, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm8, %ymm5
	vpsubd	%ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vpshufd	$216, %ymm4, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 8448(%rip), %ymm6
	vmovdqu	glob_data + 4480(%rip), %ymm9
	vpshufd	$216, %ymm1, %ymm11
	vpshufd	$216, %ymm2, %ymm2
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm1
	vpunpcklqdq	%ymm2, %ymm11, %ymm8
	vpunpckhqdq	%ymm2, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm2
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm1, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm1
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm1, %ymm2, %ymm1
	vpsubq	%ymm6, %ymm13, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm2
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm2, %ymm1
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8480(%rip), %ymm6
	vmovdqu	glob_data + 4512(%rip), %ymm9
	vpshufd	$216, %ymm0, %ymm11
	vpshufd	$216, %ymm3, %ymm3
	vmovshdup	%ymm6, %ymm12
	vmovshdup	%ymm9, %ymm0
	vpunpcklqdq	%ymm3, %ymm11, %ymm8
	vpunpckhqdq	%ymm3, %ymm11, %ymm11
	vmovshdup	%ymm11, %ymm14
	vpmuldq	%ymm6, %ymm11, %ymm3
	vpmuldq	%ymm12, %ymm14, %ymm13
	vpmuldq	%ymm9, %ymm11, %ymm6
	vpmuldq	%ymm0, %ymm14, %ymm9
	vpmuldq	glob_data + 9184(%rip), %ymm6, %ymm0
	vpmuldq	glob_data + 9184(%rip), %ymm9, %ymm6
	vpsubq	%ymm0, %ymm3, %ymm0
	vpsubq	%ymm6, %ymm13, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm6
	vmovdqu	%ymm10, 768(%rsi)
	vmovdqu	%ymm7, 800(%rsi)
	vmovdqu	%ymm4, 832(%rsi)
	vmovdqu	%ymm5, 864(%rsi)
	vmovdqu	%ymm1, 896(%rsi)
	vmovdqu	%ymm2, 928(%rsi)
	vmovdqu	%ymm0, 960(%rsi)
	vmovdqu	%ymm6, 992(%rsi)
	ret
.Lpolynomial__conditionally_add_modulus$1:
	vmovdqu	glob_data + 9184(%rip), %ymm1
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %r8
	jmp 	.Lpolynomial__conditionally_add_modulus$2
.Lpolynomial__conditionally_add_modulus$3:
	vmovdqu	(%rcx,%r8), %ymm2
	vpcmpgtd	%ymm2, %ymm0, %ymm5
	vpand	%ymm5, %ymm1, %ymm3
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rcx,%r8)
	addq	$32, %r8
.Lpolynomial__conditionally_add_modulus$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__conditionally_add_modulus$3
	ret
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1:
	movq	$0, %r8
	jmp 	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$3:
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm1, %ymm5
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm5, %ymm4, %ymm1
	vpmuldq	glob_data + 8544(%rip), %ymm0, %ymm2
	vpmuldq	glob_data + 8544(%rip), %ymm1, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm2, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm1, %ymm1
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%r8)
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vmovshdup	%ymm0, %ymm4
	vmovshdup	%ymm1, %ymm5
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm5, %ymm4, %ymm1
	vpmuldq	glob_data + 8544(%rip), %ymm0, %ymm2
	vpmuldq	glob_data + 8544(%rip), %ymm1, %ymm5
	vpmuldq	glob_data + 9184(%rip), %ymm2, %ymm2
	vpmuldq	glob_data + 9184(%rip), %ymm5, %ymm5
	vpsubq	%ymm2, %ymm0, %ymm0
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
	vmovdqu	glob_data + 8576(%rip), %ymm1
	leaq	1056(%rsp), %rdx
	leaq	32(%rsp), %rsi
	call	.Lpolynomial__decompose_gamma2_32$1
.Lpolynomial__use_hints_gamma2_32$4:
	movq	$0, %r8
	jmp 	.Lpolynomial__use_hints_gamma2_32$2
.Lpolynomial__use_hints_gamma2_32$3:
	vmovdqu	1056(%rsp,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vpcmpeqd	%ymm0, %ymm2, %ymm4
	vpor	%ymm4, %ymm2, %ymm2
	vpsignd	%ymm2, %ymm3, %ymm3
	vmovdqu	32(%rsp,%r8), %ymm2
	vpaddd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r9,%r8)
	addq	$32, %r8
.Lpolynomial__use_hints_gamma2_32$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__use_hints_gamma2_32$3
	ret
.Lpolynomial__decompose_gamma2_32$1:
	vmovdqu	glob_data + 9184(%rip), %ymm2
	vpsrld	$1, %ymm2, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vmovdqu	glob_data + 8576(%rip), %ymm5
	vmovdqu	glob_data + 8608(%rip), %ymm6
	vmovdqu	glob_data + 8640(%rip), %ymm7
	vmovdqu	glob_data + 8672(%rip), %ymm8
	vmovdqu	glob_data + 8704(%rip), %ymm9
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
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	glob_data + 8800(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm2
	vpsrlq	$12, %ymm2, %ymm2
	vmovdqu	glob_data + 8832(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vextracti128	$0, %ymm2, %xmm12
	vextracti128	$1, %ymm2, %xmm11
	ret
.Lerror_polynomial__decode_eta2$1:
	movq	$7, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$2, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqu	glob_data + 9024(%rip), %ymm2
	vpbroadcastd	(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, (%rax)
	vpbroadcastd	3(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 32(%rax)
	vpbroadcastd	6(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 64(%rax)
	vpbroadcastd	9(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 96(%rax)
	vpbroadcastd	12(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 128(%rax)
	vpbroadcastd	15(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 160(%rax)
	vpbroadcastd	18(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 192(%rax)
	vpbroadcastd	21(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 224(%rax)
	vpbroadcastd	24(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 256(%rax)
	vpbroadcastd	27(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 288(%rax)
	vpbroadcastd	30(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 320(%rax)
	vpbroadcastd	33(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 352(%rax)
	vpbroadcastd	36(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 384(%rax)
	vpbroadcastd	39(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 416(%rax)
	vpbroadcastd	42(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 448(%rax)
	vpbroadcastd	45(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 480(%rax)
	vpbroadcastd	48(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 512(%rax)
	vpbroadcastd	51(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 544(%rax)
	vpbroadcastd	54(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 576(%rax)
	vpbroadcastd	57(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 608(%rax)
	vpbroadcastd	60(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 640(%rax)
	vpbroadcastd	63(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 672(%rax)
	vpbroadcastd	66(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 704(%rax)
	vpbroadcastd	69(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 736(%rax)
	vpbroadcastd	72(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 768(%rax)
	vpbroadcastd	75(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 800(%rax)
	vpbroadcastd	78(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 832(%rax)
	vpbroadcastd	81(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 864(%rax)
	vpbroadcastd	84(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 896(%rax)
	vpbroadcastd	87(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm10
	vmovdqu	%ymm10, 928(%rax)
	vpbroadcastd	90(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, 960(%rax)
	vmovdqu	glob_data + 9056(%rip), %ymm2
	vpbroadcastd	92(%rdx), %ymm10
	vpsrlvd	%ymm2, %ymm10, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, 992(%rax)
	ret
.Lerror_polynomial__encode_eta2$1:
	movq	$2, %r9
	vmovq	%r9, %xmm0
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
	vmovdqu	glob_data + 8864(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm1, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8896(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8928(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8960(%rip), %ymm1
	vpmaddwd	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8992(%rip), %ymm1
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
	vmovdqu	glob_data + 8864(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm1, %ymm3, %ymm3
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpermq	$216, %ymm2, %ymm2
	vmovdqu	glob_data + 8896(%rip), %ymm1
	vpshufb	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8928(%rip), %ymm1
	vpmaddubsw	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8960(%rip), %ymm1
	vpmaddwd	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 8992(%rip), %ymm1
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
	.byte	  0,   1,   2, 255,   3,   4,   5, 255,   6,   7,   8, 255,   9,  10,  11, 255
	.byte	  4,   5,   6, 255,   7,   8,   9, 255,  10,  11,  12, 255,  13,  14,  15, 255
	.byte	255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0
	.byte	255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0, 255, 255, 127,   0
G$ROL8:
	.byte	  7,   0,   1,   2,   3,   4,   5,   6,  15,   8,   9,  10,  11,  12,  13,  14
	.byte	 23,  16,  17,  18,  19,  20,  21,  22,  31,  24,  25,  26,  27,  28,  29,  30
G$ROL56:
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
	.byte	 17,  18,  19,  20,  21,  22,  23,  16,  25,  26,  27,  28,  29,  30,  31,  24
G$ZETAS_TO_INVERT_LAYER_2_QINV:
	.byte	 45, 239,  58, 199,  45, 239,  58, 199,  45, 239,  58, 199,  45, 239,  58, 199
	.byte	 84,  29, 202, 153,  84,  29, 202, 153,  84,  29, 202, 153,  84,  29, 202, 153
	.byte	 48, 252,  94, 199,  48, 252,  94, 199,  48, 252,  94, 199,  48, 252,  94, 199
	.byte	 52,   5, 226, 166,  52,   5, 226, 166,  52,   5, 226, 166,  52,   5, 226, 166
	.byte	 83, 152, 197, 137,  83, 152, 197, 137,  83, 152, 197, 137,  83, 152, 197, 137
	.byte	118,  79, 253, 238, 118,  79, 253, 238, 118,  79, 253, 238, 118,  79, 253, 238
	.byte	154,  91, 123, 158, 154,  91, 123, 158, 154,  91, 123, 158, 154,  91, 123, 158
	.byte	168,  99, 129,  88, 168,  99, 129,  88, 168,  99, 129,  88, 168,  99, 129,  88
	.byte	140, 243, 169, 120, 140, 243, 169, 120, 140, 243, 169, 120, 140, 243, 169, 120
	.byte	 92,  20, 115,  52,  92,  20, 115,  52,  92,  20, 115,  52,  92,  20, 115,  52
	.byte	 23,  54,  34,  59,  23,  54,  34,  59,  23,  54,  34,  59,  23,  54,  34,  59
	.byte	 63, 100,  61, 141,  63, 100,  61, 141,  63, 100,  61, 141,  63, 100,  61, 141
	.byte	 89, 207,  48, 109,  89, 207,  48, 109,  89, 207,  48, 109,  89, 207,  48, 109
	.byte	 30,  62, 249,  24,  30,  62, 249,  24,  30,  62, 249,  24,  30,  62, 249,  24
	.byte	214, 170,  65, 202, 214, 170,  65, 202, 214, 170,  65, 202, 214, 170,  65, 202
	.byte	 61, 178, 173, 151,  61, 178, 173, 151,  61, 178, 173, 151,  61, 178, 173, 151
	.byte	 93, 101,  35, 190,  93, 101,  35, 190,  93, 101,  35, 190,  93, 101,  35, 190
	.byte	156,  86, 247, 156, 156,  86, 247, 156, 156,  86, 247, 156, 156,  86, 247, 156
	.byte	 77,  10, 197, 122,  77,  10, 197, 122,  77,  10, 197, 122,  77,  10, 197, 122
	.byte	  0,   4, 182, 192,   0,   4, 182, 192,   0,   4, 182, 192,   0,   4, 182, 192
	.byte	 65,  94,  28, 107,  65,  94,  28, 107,  65,  94,  28, 107,  65,  94,  28, 107
	.byte	150,  74, 137, 222, 150,  74, 137, 222, 150,  74, 137, 222, 150,  74, 137, 222
	.byte	124,  14, 161, 227, 124,  14, 161, 227, 124,  14, 161, 227, 124,  14, 161, 227
	.byte	133, 181, 245, 243, 133, 181, 245, 243, 133, 181, 245, 243, 133, 181, 245, 243
	.byte	175, 158, 145, 220, 175, 158, 145, 220, 175, 158, 145, 220, 175, 158, 145, 220
	.byte	212, 199, 211, 142, 212, 199, 211, 142, 212, 199, 211, 142, 212, 199, 211, 142
	.byte	 44, 176, 206, 191,  44, 176, 206, 191,  44, 176, 206, 191,  44, 176, 206, 191
	.byte	  3,   5,   7,  95,   3,   5,   7,  95,   3,   5,   7,  95,   3,   5,   7,  95
	.byte	197, 126, 142, 109, 197, 126, 142, 109, 197, 126, 142, 109, 197, 126, 142, 109
	.byte	205, 148,  72, 172, 205, 148,  72, 172, 205, 148,  72, 172, 205, 148,  72, 172
	.byte	 32, 118, 197, 158,  32, 118, 197, 158,  32, 118, 197, 158,  32, 118, 197, 158
	.byte	103,  42, 246, 145, 103,  42, 246, 145, 103,  42, 246, 145, 103,  42, 246, 145
G$ZETAS_TO_INVERT_LAYER_1_QINV:
	.byte	217, 183, 181, 202, 217, 183, 181, 202, 156,  71, 184,  58, 156,  71, 184,  58
	.byte	 87, 128,  83,  68,  87, 128,  83,  68, 162,  46, 166, 116, 162,  46, 166, 116
	.byte	  2,  72, 234,  71,   2,  72, 234,  71, 224, 208,   3,  10, 224, 208,   3,  10
	.byte	 68,  25,  28, 225,  68,  25,  28, 225,  37,  62,  88, 245,  37,  62,  88, 245
	.byte	146, 183,   6,  14, 146, 183,   6,  14, 224,  74,  89, 185, 224,  74,  89, 185
	.byte	  5, 179, 244,  19,   5, 179, 244,  19, 147, 156, 237, 105, 147, 156, 237, 105
	.byte	246, 127, 226,  84, 246, 127, 226,  84,   8, 200, 202,  84,   8, 200, 202,  84
	.byte	194, 118,   8, 174, 194, 118,   8, 174, 108, 100, 144, 214, 108, 100, 144, 214
	.byte	  8, 232, 236, 152,   8, 232, 236, 152, 223, 167, 120,  37, 223, 167, 120,  37
	.byte	161, 184, 159, 166, 161, 184, 159, 166, 108, 245, 209, 136, 108, 245, 209, 136
	.byte	192, 105,   6, 237, 192, 105,   6, 237, 126, 158, 207, 180, 126, 158, 207, 180
	.byte	 72,  57,  66, 163,  72,  57,  66, 163, 202, 107,  64,  40, 202, 107,  64,  40
	.byte	 90, 167,  39,  72,  90, 167,  39,  72, 190, 246, 198, 127, 190, 246, 198, 127
	.byte	 68,  77, 182,  39,  68,  77, 182,  39,   0, 173, 160, 149,   0, 173, 160, 149
	.byte	136,  69, 224,  68, 136,  69, 224,  68, 240,  10,  98, 201, 240,  10,  98, 201
	.byte	 23, 164,  10,  73,  23, 164,  10,  73, 233,  27, 202,  78, 233,  27, 202,  78
	.byte	 98, 108, 118, 156,  98, 108, 118, 156, 212,  21, 207, 248, 212,  21, 207, 248
	.byte	 99, 165,  72,  99,  99, 165,  72,  99, 221, 203, 245, 202, 221, 203, 245, 202
	.byte	247, 233, 170,  97, 247, 233, 170,  97,  19, 161, 143, 106,  19, 161, 143, 106
	.byte	 59,   6,  71, 195,  59,   6,  71, 195, 130,   2,  70, 127, 130,   2,  70, 127
	.byte	  9,  84, 219, 101,   9,  84, 219, 101,  75,   4, 209, 250,  75,   4, 209, 250
	.byte	109,  90, 199, 180, 109,  90, 199, 180, 163,  23,  71,  17, 163,  23,  71,  17
	.byte	159,  78, 125,  90, 159,  78, 125,  90, 133, 158,  65, 241, 133, 158,  65, 241
	.byte	 56, 198, 231, 220,  56, 198, 231, 220, 242,  80,  82, 209, 242,  80,  82, 209
	.byte	202,  47, 251, 128, 202,  47, 251, 128, 174, 146,  37,  91, 174, 146,  37,  91
	.byte	224, 144, 228,  33, 224, 144, 228,  33, 128,  82,  31, 170, 128,  82,  31, 170
	.byte	246, 124, 143, 116, 246, 124, 143, 116, 114, 215,  11, 194, 114, 215,  11, 194
	.byte	114, 240, 207, 196, 114, 240, 207, 196, 117, 111,  91, 179, 117, 111,  91, 179
	.byte	187,  47,  95,   8, 187,  47,  95,   8, 238, 201, 114,  98, 238, 201, 114,  98
	.byte	199,  21,  90,  95, 199,  21,  90,  95,  93, 118,  53, 128,  93, 118,  53, 128
	.byte	 25, 184,  84, 138,  25, 184,  84, 138, 129, 204, 248, 216, 129, 204, 248, 216
	.byte	207, 193, 129,  80, 207, 193, 129,  80, 229, 166,  32, 162, 229, 166,  32, 162
G$ZETAS_TO_INVERT_LAYER_0_QINV:
	.byte	206, 233,  87,  22, 182, 214, 201, 223, 223,  22,  71, 115,  78,   3, 105, 121
	.byte	104,  94, 226,  23, 202,  85, 245, 197,  44,  79,  33, 148,  80, 138,  65,   9
	.byte	169,   5, 255,  11,  42, 220, 157, 166,   9,  61, 254,  66, 221,  51, 245, 183
	.byte	  5, 184, 113,  52, 147,  44,  21,  92, 175, 193, 147, 160, 100, 167, 191,  66
	.byte	219, 223,  64,  46, 218,  69, 183, 251, 104,  38, 234,  16, 174,  60, 122, 240
	.byte	 51, 134,  53, 151, 152, 142, 185, 229, 208,  76, 180,  33,  69,  29,  34, 161
	.byte	 14, 244, 136,  23, 231,  21,  87, 239, 192,  29, 188, 163,  21, 161, 221,  41
	.byte	244, 155, 111, 249, 247, 164,  64, 153,  57, 229,  92,   0,  60,  33, 249, 133
	.byte	 61,  44, 236, 102, 103, 129, 116, 220, 113,  29,  92, 203,   8, 170,  89,  49
	.byte	154, 119,  12, 194, 165, 252,  32, 205,  28, 252, 133, 177, 190,  44, 103, 134
	.byte	167, 115, 226, 122, 187,  52,  26, 233, 143,  92,  15, 164, 183,  83,  28, 175
	.byte	152, 104,  70, 129, 152, 221, 208,  79, 139, 125,  86,  10,  88,  70, 172,  92
	.byte	 31,  62,  10,  56, 216,  16,  36,  22,  87, 177, 142,  42, 248, 127, 229, 179
	.byte	 18, 108,  73,  36,  27, 241, 123, 240,  12,  74,  22, 195,  52,  57,  30,  45
	.byte	207, 216, 205,  83, 232,  29, 223, 239, 173, 165,  32,  62, 120,  37, 136,  72
	.byte	231, 187,   8,  36,   5, 132,  23, 238, 153,  96, 176, 191,  83, 217, 150,  49
	.byte	110, 205, 143,  66, 131, 210,   2,  25,  47,  13,  16, 106,  62,  30, 149, 132
	.byte	199, 230, 108,  57, 228, 157, 181, 193,  27,  65, 182,  58, 190, 104,   3,  14
	.byte	166, 182, 196,  67,  75, 107,   6,  40, 144, 219,  59, 179, 145,  88, 186,   2
	.byte	 63, 101,  68, 237, 137, 112,  99,  41, 190, 212, 170, 251,  24, 133, 105, 164
	.byte	 70,  26,  97,   0,  81,  16, 176, 217, 113, 109,  65, 117,  58, 186,  31, 218
	.byte	132, 137,  67, 175,  28,  97,  97, 158, 153,  49, 220, 185, 229, 254, 135, 141
	.byte	 36, 153,  39,  97, 199,  92,  51,   8,  27,  16, 194,  52,  65, 237,   2, 189
	.byte	 59,  96,  84, 110, 231,  82,  17, 183,  12, 225,  37,  54,  25,  89, 168, 126
	.byte	194,  97,   1,  75, 146, 133, 166,   7, 134, 175,  33, 115, 132, 128,  47, 174
	.byte	214, 188, 146, 236, 125,  89, 121, 108, 246,  26,  47, 104,  33,  32, 122,  51
	.byte	252, 134, 215, 114,   4, 215, 223, 120,  90, 191, 247,  74, 230, 160,  42, 225
	.byte	138, 162,  56, 207, 131, 239, 119,  60,  26, 158, 223, 230,  94, 126, 217,   0
	.byte	222,   5, 139, 113,  86, 123,  88, 100,  93,  59,  33, 121, 240,  36, 139, 236
	.byte	252,  34,  38,  70, 160,  72, 222, 120, 135,   5,  86, 253, 245, 178, 226, 219
	.byte	 34, 228,  77, 171, 159, 139, 206,   1, 248,  65, 121,  44, 212, 216,  61,  81
	.byte	251, 157,  97,  54, 114,  63, 187, 174,  90,  63,  31,  59, 147,  74, 242, 255
G$LAYER_5_ZETAS_QINV:
	.byte	 68,  30, 204,  97,  68,  30, 204,  97,  68,  30, 204,  97,  68,  30, 204,  97
	.byte	 68,  30, 204,  97,  68,  30, 204,  97,  68,  30, 204,  97,  68,  30, 204,  97
	.byte	 24,  33,  23,  88,  24,  33,  23,  88,  24,  33,  23,  88,  24,  33,  23,  88
	.byte	 24,  33,  23,  88,  24,  33,  23,  88,  24,  33,  23,  88,  24,  33,  23,  88
	.byte	 40, 161,  23,  96,  40, 161,  23,  96,  40, 161,  23,  96,  40, 161,  23,  96
	.byte	 40, 161,  23,  96,  40, 161,  23,  96,  40, 161,  23,  96,  40, 161,  23,  96
	.byte	 36, 158, 203,  97,  36, 158, 203,  97,  36, 158, 203,  97,  36, 158, 203,  97
	.byte	 36, 158, 203,  97,  36, 158, 203,  97,  36, 158, 203,  97,  36, 158, 203,  97
G$LAYER_4_ZETAS_QINV:
	.byte	 43,  62,  97,  18,  43,  62,  97,  18,  43,  62,  97,  18,  43,  62,  97,  18
	.byte	 43,  62,  97,  18,  43,  62,  97,  18,  43,  62,  97,  18,  43,  62,  97,  18
	.byte	 43,  73, 201, 147,  43,  73, 201, 147,  43,  73, 201, 147,  43,  73, 201, 147
	.byte	 43,  73, 201, 147,  43,  73, 201, 147,  43,  73, 201, 147,  43,  73, 201, 147
	.byte	173,  36,  16, 174, 173,  36,  16, 174, 173,  36,  16, 174, 173,  36,  16, 174
	.byte	173,  36,  16, 174, 173,  36,  16, 174, 173,  36,  16, 174, 173,  36,  16, 174
	.byte	127, 244, 239, 190, 127, 244, 239, 190, 127, 244, 239, 190, 127, 244, 239, 190
	.byte	127, 244, 239, 190, 127, 244, 239, 190, 127, 244, 239, 190, 127, 244, 239, 190
	.byte	117,  58, 254, 140, 117,  58, 254, 140, 117,  58, 254, 140, 117,  58, 254, 140
	.byte	117,  58, 254, 140, 117,  58, 254, 140, 117,  58, 254, 140, 117,  58, 254, 140
	.byte	  9,  27, 181,  30,   9,  27, 181,  30,   9,  27, 181,  30,   9,  27, 181,  30
	.byte	  9,  27, 181,  30,   9,  27, 181,  30,   9,  27, 181,  30,   9,  27, 181,  30
	.byte	 73, 154, 248, 238,  73, 154, 248, 238,  73, 154, 248, 238,  73, 154, 248, 238
	.byte	 73, 154, 248, 238,  73, 154, 248, 238,  73, 154, 248, 238,  73, 154, 248, 238
	.byte	 39, 197,  77,  37,  39, 197,  77,  37,  39, 197,  77,  37,  39, 197,  77,  37
	.byte	 39, 197,  77,  37,  39, 197,  77,  37,  39, 197,  77,  37,  39, 197,  77,  37
G$LAYER_3_ZETAS_QINV:
	.byte	 88, 150, 244, 102,  88, 150, 244, 102,  88, 150, 244, 102,  88, 150, 244, 102
	.byte	 88, 150, 244, 102,  88, 150, 244, 102,  88, 150, 244, 102,  88, 150, 244, 102
	.byte	112, 160,  29, 124, 112, 160,  29, 124, 112, 160,  29, 124, 112, 160,  29, 124
	.byte	112, 160,  29, 124, 112, 160,  29, 124, 112, 160,  29, 124, 112, 160,  29, 124
	.byte	164,   5, 164, 174, 164,   5, 164, 174, 164,   5, 164, 174, 164,   5, 164, 174
	.byte	164,   5, 164, 174, 164,   5, 164, 174, 164,   5, 164, 174, 164,   5, 164, 174
	.byte	136, 183,  39,  51, 136, 183,  39,  51, 136, 183,  39,  51, 136, 183,  39,  51
	.byte	136, 183,  39,  51, 136, 183,  39,  51, 136, 183,  39,  51, 136, 183,  39,  51
	.byte	144, 157, 169, 107, 144, 157, 169, 107, 144, 157, 169, 107, 144, 157, 169, 107
	.byte	144, 157, 169, 107, 144, 157, 169, 107, 144, 157, 169, 107, 144, 157, 169, 107
	.byte	160, 234,  66,  13, 160, 234,  66,  13, 160, 234,  66,  13, 160, 234,  66,  13
	.byte	160, 234,  66,  13, 160, 234,  66,  13, 160, 234,  66,  13, 160, 234,  66,  13
	.byte	104, 249,  84, 235, 104, 249,  84, 235, 104, 249,  84, 235, 104, 249,  84, 235
	.byte	104, 249,  84, 235, 104, 249,  84, 235, 104, 249,  84, 235, 104, 249,  84, 235
	.byte	123,  51, 207,  40, 123,  51, 207,  40, 123,  51, 207,  40, 123,  51, 207,  40
	.byte	123,  51, 207,  40, 123,  51, 207,  40, 123,  51, 207,  40, 123,  51, 207,  40
	.byte	214, 109, 154,  98, 214, 109, 154,  98, 214, 109, 154,  98, 214, 109, 154,  98
	.byte	214, 109, 154,  98, 214, 109, 154,  98, 214, 109, 154,  98, 214, 109, 154,  98
	.byte	231, 250, 161, 203, 231, 250, 161, 203, 231, 250, 161, 203, 231, 250, 161, 203
	.byte	231, 250, 161, 203, 231, 250, 161, 203, 231, 250, 161, 203, 231, 250, 161, 203
	.byte	247, 132,   9, 181, 247, 132,   9, 181, 247, 132,   9, 181, 247, 132,   9, 181
	.byte	247, 132,   9, 181, 247, 132,   9, 181, 247, 132,   9, 181, 247, 132,   9, 181
	.byte	152, 252,  96, 211, 152, 252,  96, 211, 152, 252,  96, 211, 152, 252,  96, 211
	.byte	152, 252,  96, 211, 152, 252,  96, 211, 152, 252,  96, 211, 152, 252,  96, 211
	.byte	 53, 112, 161,  19,  53, 112, 161,  19,  53, 112, 161,  19,  53, 112, 161,  19
	.byte	 53, 112, 161,  19,  53, 112, 161,  19,  53, 112, 161,  19,  53, 112, 161,  19
	.byte	 34, 244, 131, 109,  34, 244, 131, 109,  34, 244, 131, 109,  34, 244, 131, 109
	.byte	 34, 244, 131, 109,  34, 244, 131, 109,  34, 244, 131, 109,  34, 244, 131, 109
	.byte	  1,  82, 253, 169,   1,  82, 253, 169,   1,  82, 253, 169,   1,  82, 253, 169
	.byte	  1,  82, 253, 169,   1,  82, 253, 169,   1,  82, 253, 169,   1,  82, 253, 169
	.byte	197, 229,  60, 186, 197, 229,  60, 186, 197, 229,  60, 186, 197, 229,  60, 186
	.byte	197, 229,  60, 186, 197, 229,  60, 186, 197, 229,  60, 186, 197, 229,  60, 186
G$LAYER_2_ZETAS_QINV:
	.byte	103,  42, 246, 145, 103,  42, 246, 145, 103,  42, 246, 145, 103,  42, 246, 145
	.byte	 32, 118, 197, 158,  32, 118, 197, 158,  32, 118, 197, 158,  32, 118, 197, 158
	.byte	205, 148,  72, 172, 205, 148,  72, 172, 205, 148,  72, 172, 205, 148,  72, 172
	.byte	197, 126, 142, 109, 197, 126, 142, 109, 197, 126, 142, 109, 197, 126, 142, 109
	.byte	  3,   5,   7,  95,   3,   5,   7,  95,   3,   5,   7,  95,   3,   5,   7,  95
	.byte	 44, 176, 206, 191,  44, 176, 206, 191,  44, 176, 206, 191,  44, 176, 206, 191
	.byte	212, 199, 211, 142, 212, 199, 211, 142, 212, 199, 211, 142, 212, 199, 211, 142
	.byte	175, 158, 145, 220, 175, 158, 145, 220, 175, 158, 145, 220, 175, 158, 145, 220
	.byte	133, 181, 245, 243, 133, 181, 245, 243, 133, 181, 245, 243, 133, 181, 245, 243
	.byte	124,  14, 161, 227, 124,  14, 161, 227, 124,  14, 161, 227, 124,  14, 161, 227
	.byte	150,  74, 137, 222, 150,  74, 137, 222, 150,  74, 137, 222, 150,  74, 137, 222
	.byte	 65,  94,  28, 107,  65,  94,  28, 107,  65,  94,  28, 107,  65,  94,  28, 107
	.byte	  0,   4, 182, 192,   0,   4, 182, 192,   0,   4, 182, 192,   0,   4, 182, 192
	.byte	 77,  10, 197, 122,  77,  10, 197, 122,  77,  10, 197, 122,  77,  10, 197, 122
	.byte	156,  86, 247, 156, 156,  86, 247, 156, 156,  86, 247, 156, 156,  86, 247, 156
	.byte	 93, 101,  35, 190,  93, 101,  35, 190,  93, 101,  35, 190,  93, 101,  35, 190
	.byte	 61, 178, 173, 151,  61, 178, 173, 151,  61, 178, 173, 151,  61, 178, 173, 151
	.byte	214, 170,  65, 202, 214, 170,  65, 202, 214, 170,  65, 202, 214, 170,  65, 202
	.byte	 30,  62, 249,  24,  30,  62, 249,  24,  30,  62, 249,  24,  30,  62, 249,  24
	.byte	 89, 207,  48, 109,  89, 207,  48, 109,  89, 207,  48, 109,  89, 207,  48, 109
	.byte	 63, 100,  61, 141,  63, 100,  61, 141,  63, 100,  61, 141,  63, 100,  61, 141
	.byte	 23,  54,  34,  59,  23,  54,  34,  59,  23,  54,  34,  59,  23,  54,  34,  59
	.byte	 92,  20, 115,  52,  92,  20, 115,  52,  92,  20, 115,  52,  92,  20, 115,  52
	.byte	140, 243, 169, 120, 140, 243, 169, 120, 140, 243, 169, 120, 140, 243, 169, 120
	.byte	168,  99, 129,  88, 168,  99, 129,  88, 168,  99, 129,  88, 168,  99, 129,  88
	.byte	154,  91, 123, 158, 154,  91, 123, 158, 154,  91, 123, 158, 154,  91, 123, 158
	.byte	118,  79, 253, 238, 118,  79, 253, 238, 118,  79, 253, 238, 118,  79, 253, 238
	.byte	 83, 152, 197, 137,  83, 152, 197, 137,  83, 152, 197, 137,  83, 152, 197, 137
	.byte	 52,   5, 226, 166,  52,   5, 226, 166,  52,   5, 226, 166,  52,   5, 226, 166
	.byte	 48, 252,  94, 199,  48, 252,  94, 199,  48, 252,  94, 199,  48, 252,  94, 199
	.byte	 84,  29, 202, 153,  84,  29, 202, 153,  84,  29, 202, 153,  84,  29, 202, 153
	.byte	 45, 239,  58, 199,  45, 239,  58, 199,  45, 239,  58, 199,  45, 239,  58, 199
G$LAYER_1_ZETAS_QINV:
	.byte	229, 166,  32, 162, 229, 166,  32, 162, 207, 193, 129,  80, 207, 193, 129,  80
	.byte	129, 204, 248, 216, 129, 204, 248, 216,  25, 184,  84, 138,  25, 184,  84, 138
	.byte	 93, 118,  53, 128,  93, 118,  53, 128, 199,  21,  90,  95, 199,  21,  90,  95
	.byte	238, 201, 114,  98, 238, 201, 114,  98, 187,  47,  95,   8, 187,  47,  95,   8
	.byte	117, 111,  91, 179, 117, 111,  91, 179, 114, 240, 207, 196, 114, 240, 207, 196
	.byte	114, 215,  11, 194, 114, 215,  11, 194, 246, 124, 143, 116, 246, 124, 143, 116
	.byte	128,  82,  31, 170, 128,  82,  31, 170, 224, 144, 228,  33, 224, 144, 228,  33
	.byte	174, 146,  37,  91, 174, 146,  37,  91, 202,  47, 251, 128, 202,  47, 251, 128
	.byte	242,  80,  82, 209, 242,  80,  82, 209,  56, 198, 231, 220,  56, 198, 231, 220
	.byte	133, 158,  65, 241, 133, 158,  65, 241, 159,  78, 125,  90, 159,  78, 125,  90
	.byte	163,  23,  71,  17, 163,  23,  71,  17, 109,  90, 199, 180, 109,  90, 199, 180
	.byte	 75,   4, 209, 250,  75,   4, 209, 250,   9,  84, 219, 101,   9,  84, 219, 101
	.byte	130,   2,  70, 127, 130,   2,  70, 127,  59,   6,  71, 195,  59,   6,  71, 195
	.byte	 19, 161, 143, 106,  19, 161, 143, 106, 247, 233, 170,  97, 247, 233, 170,  97
	.byte	221, 203, 245, 202, 221, 203, 245, 202,  99, 165,  72,  99,  99, 165,  72,  99
	.byte	212,  21, 207, 248, 212,  21, 207, 248,  98, 108, 118, 156,  98, 108, 118, 156
	.byte	233,  27, 202,  78, 233,  27, 202,  78,  23, 164,  10,  73,  23, 164,  10,  73
	.byte	240,  10,  98, 201, 240,  10,  98, 201, 136,  69, 224,  68, 136,  69, 224,  68
	.byte	  0, 173, 160, 149,   0, 173, 160, 149,  68,  77, 182,  39,  68,  77, 182,  39
	.byte	190, 246, 198, 127, 190, 246, 198, 127,  90, 167,  39,  72,  90, 167,  39,  72
	.byte	202, 107,  64,  40, 202, 107,  64,  40,  72,  57,  66, 163,  72,  57,  66, 163
	.byte	126, 158, 207, 180, 126, 158, 207, 180, 192, 105,   6, 237, 192, 105,   6, 237
	.byte	108, 245, 209, 136, 108, 245, 209, 136, 161, 184, 159, 166, 161, 184, 159, 166
	.byte	223, 167, 120,  37, 223, 167, 120,  37,   8, 232, 236, 152,   8, 232, 236, 152
	.byte	108, 100, 144, 214, 108, 100, 144, 214, 194, 118,   8, 174, 194, 118,   8, 174
	.byte	  8, 200, 202,  84,   8, 200, 202,  84, 246, 127, 226,  84, 246, 127, 226,  84
	.byte	147, 156, 237, 105, 147, 156, 237, 105,   5, 179, 244,  19,   5, 179, 244,  19
	.byte	224,  74,  89, 185, 224,  74,  89, 185, 146, 183,   6,  14, 146, 183,   6,  14
	.byte	 37,  62,  88, 245,  37,  62,  88, 245,  68,  25,  28, 225,  68,  25,  28, 225
	.byte	224, 208,   3,  10, 224, 208,   3,  10,   2,  72, 234,  71,   2,  72, 234,  71
	.byte	162,  46, 166, 116, 162,  46, 166, 116,  87, 128,  83,  68,  87, 128,  83,  68
	.byte	156,  71, 184,  58, 156,  71, 184,  58, 217, 183, 181, 202, 217, 183, 181, 202
G$LAYER_0_ZETAS_QINV:
	.byte	147,  74, 242, 255,  90,  63,  31,  59, 114,  63, 187, 174, 251, 157,  97,  54
	.byte	212, 216,  61,  81, 248,  65, 121,  44, 159, 139, 206,   1,  34, 228,  77, 171
	.byte	245, 178, 226, 219, 135,   5,  86, 253, 160,  72, 222, 120, 252,  34,  38,  70
	.byte	240,  36, 139, 236,  93,  59,  33, 121,  86, 123,  88, 100, 222,   5, 139, 113
	.byte	 94, 126, 217,   0,  26, 158, 223, 230, 131, 239, 119,  60, 138, 162,  56, 207
	.byte	230, 160,  42, 225,  90, 191, 247,  74,   4, 215, 223, 120, 252, 134, 215, 114
	.byte	 33,  32, 122,  51, 246,  26,  47, 104, 125,  89, 121, 108, 214, 188, 146, 236
	.byte	132, 128,  47, 174, 134, 175,  33, 115, 146, 133, 166,   7, 194,  97,   1,  75
	.byte	 25,  89, 168, 126,  12, 225,  37,  54, 231,  82,  17, 183,  59,  96,  84, 110
	.byte	 65, 237,   2, 189,  27,  16, 194,  52, 199,  92,  51,   8,  36, 153,  39,  97
	.byte	229, 254, 135, 141, 153,  49, 220, 185,  28,  97,  97, 158, 132, 137,  67, 175
	.byte	 58, 186,  31, 218, 113, 109,  65, 117,  81,  16, 176, 217,  70,  26,  97,   0
	.byte	 24, 133, 105, 164, 190, 212, 170, 251, 137, 112,  99,  41,  63, 101,  68, 237
	.byte	145,  88, 186,   2, 144, 219,  59, 179,  75, 107,   6,  40, 166, 182, 196,  67
	.byte	190, 104,   3,  14,  27,  65, 182,  58, 228, 157, 181, 193, 199, 230, 108,  57
	.byte	 62,  30, 149, 132,  47,  13,  16, 106, 131, 210,   2,  25, 110, 205, 143,  66
	.byte	 83, 217, 150,  49, 153,  96, 176, 191,   5, 132,  23, 238, 231, 187,   8,  36
	.byte	120,  37, 136,  72, 173, 165,  32,  62, 232,  29, 223, 239, 207, 216, 205,  83
	.byte	 52,  57,  30,  45,  12,  74,  22, 195,  27, 241, 123, 240,  18, 108,  73,  36
	.byte	248, 127, 229, 179,  87, 177, 142,  42, 216,  16,  36,  22,  31,  62,  10,  56
	.byte	 88,  70, 172,  92, 139, 125,  86,  10, 152, 221, 208,  79, 152, 104,  70, 129
	.byte	183,  83,  28, 175, 143,  92,  15, 164, 187,  52,  26, 233, 167, 115, 226, 122
	.byte	190,  44, 103, 134,  28, 252, 133, 177, 165, 252,  32, 205, 154, 119,  12, 194
	.byte	  8, 170,  89,  49, 113,  29,  92, 203, 103, 129, 116, 220,  61,  44, 236, 102
	.byte	 60,  33, 249, 133,  57, 229,  92,   0, 247, 164,  64, 153, 244, 155, 111, 249
	.byte	 21, 161, 221,  41, 192,  29, 188, 163, 231,  21,  87, 239,  14, 244, 136,  23
	.byte	 69,  29,  34, 161, 208,  76, 180,  33, 152, 142, 185, 229,  51, 134,  53, 151
	.byte	174,  60, 122, 240, 104,  38, 234,  16, 218,  69, 183, 251, 219, 223,  64,  46
	.byte	100, 167, 191,  66, 175, 193, 147, 160, 147,  44,  21,  92,   5, 184, 113,  52
	.byte	221,  51, 245, 183,   9,  61, 254,  66,  42, 220, 157, 166, 169,   5, 255,  11
	.byte	 80, 138,  65,   9,  44,  79,  33, 148, 202,  85, 245, 197, 104,  94, 226,  23
	.byte	 78,   3, 105, 121, 223,  22,  71, 115, 182, 214, 201, 223, 206, 233,  87,  22
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
G$error_polynomial__ETA2_DECODING_SHIFTS:
	.byte	  0,   0,   0,   0,   3,   0,   0,   0,   6,   0,   0,   0,   9,   0,   0,   0
	.byte	 12,   0,   0,   0,  15,   0,   0,   0,  18,   0,   0,   0,  21,   0,   0,   0
	.byte	  8,   0,   0,   0,  11,   0,   0,   0,  14,   0,   0,   0,  17,   0,   0,   0
	.byte	 20,   0,   0,   0,  23,   0,   0,   0,  26,   0,   0,   0,  29,   0,   0,   0
G$error_polynomial__ETA4_DECODING_SHIFTS:
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   8,   0,   0,   0,  12,   0,   0,   0
	.byte	 16,   0,   0,   0,  20,   0,   0,   0,  24,   0,   0,   0,  28,   0,   0,   0
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
G$COMPACTION_INDEX_TABLE:
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
G$INVERSE_NTT_LAYER_7_CONSTANTS:
	.byte	223,  85, 195, 255, 223,  53, 255, 246, 250, 163,   0,   0, 250, 227, 127, 255
G$LAYERS_7_6_ZETAS:
	.byte	247, 100,   0,   0, 247,  68,  31, 109,   2,  49, 216, 255,   2, 113, 248, 140
	.byte	  3,  21, 248, 255,   3, 117,  24, 141
G$ZETAS_TO_INVERT_LAYER_6_QINV:
	.byte	  3, 117,  24, 141,   2, 113, 248, 140
G$ZETAS_TO_INVERT_LAYER_5_QINV:
	.byte	 36, 158, 203,  97,  40, 161,  23,  96,  24,  33,  23,  88,  68,  30, 204,  97
G$ZETAS_TO_INVERT_LAYER_4_QINV:
	.byte	 39, 197,  77,  37,  73, 154, 248, 238,   9,  27, 181,  30, 117,  58, 254, 140
	.byte	127, 244, 239, 190, 173,  36,  16, 174,  43,  73, 201, 147,  43,  62,  97,  18
G$ZETAS_TO_INVERT_LAYER_3_QINV:
	.byte	197, 229,  60, 186,   1,  82, 253, 169,  34, 244, 131, 109,  53, 112, 161,  19
	.byte	152, 252,  96, 211, 247, 132,   9, 181, 231, 250, 161, 203, 214, 109, 154,  98
	.byte	123,  51, 207,  40, 104, 249,  84, 235, 160, 234,  66,  13, 144, 157, 169, 107
	.byte	136, 183,  39,  51, 164,   5, 164, 174, 112, 160,  29, 124,  88, 150, 244, 102
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
