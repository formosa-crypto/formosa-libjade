	.att_syntax
	.text
	.p2align	5
	.global	jade_kem_mlkem_mlkem768_amd64_avx2_check_sk
	.global	jade_kem_mlkem_mlkem768_amd64_avx2_check_pk
	.global	jade_kem_mlkem_mlkem768_amd64_avx2_dec
	.global	jade_kem_mlkem_mlkem768_amd64_avx2_enc_derand
	.global	jade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand
	.type	jade_kem_mlkem_mlkem768_amd64_avx2_check_sk, %function
jade_kem_mlkem_mlkem768_amd64_avx2_check_sk:
	movq	%rsp, %rax
	leaq	-96(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 40(%rsp)
	movq	%rbp, 48(%rsp)
	movq	%r12, 56(%rsp)
	movq	%r13, 64(%rsp)
	movq	%r14, 72(%rsp)
	movq	%r15, 80(%rsp)
	movq	%rax, 88(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, 32(%rsp)
	movq	%rsp, %rax
	leaq	1152(%rdi), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_sk$1:
	leaq	248(%rsp), %rsp
	movq	32(%rsp), %rax
	lfence
	movq	$0, %rsi
	vmovdqu	(%rsp), %ymm3
	vmovdqu	2336(%rax), %ymm0
	vpxor	%ymm0, %ymm3, %ymm3
	vptest	%ymm3, %ymm3
	movq	$0, %rax
	movq	$-1, %rcx
	cmovne	%rcx, %rax
// declassify_val u64 %rax
	lfence
	movq	$0, %rsi
	movq	40(%rsp), %rbx
	movq	48(%rsp), %rbp
	movq	56(%rsp), %r12
	movq	64(%rsp), %r13
	movq	72(%rsp), %r14
	movq	80(%rsp), %r15
	movq	88(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$576, %rsp
	movq	$576, %rdi
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_sk$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_sk$2
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem768_amd64_avx2_check_pk, %function
jade_kem_mlkem_mlkem768_amd64_avx2_check_pk:
	movq	%rsp, %r11
	leaq	-2720(%rsp), %rsp
	andq	$-32, %rsp
	lfence
	movq	$0, %rax
	movq	%rdi, 2688(%rsp)
	leaq	1152(%rsp), %r8
	movq	%rdi, %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$6:
	leaq	1664(%rsp), %r8
	leaq	384(%rdi), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$5:
	leaq	2176(%rsp), %r8
	leaq	768(%rdi), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$4:
	movq	%rsp, %rax
	movq	%rax, %rcx
	leaq	1152(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$3:
	leaq	384(%rax), %rcx
	leaq	1664(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$2:
	leaq	768(%rax), %rcx
	leaq	2176(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$1:
	movq	2688(%rsp), %rdx
	lfence
	movq	$0, %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsp), %ymm3
	vmovdqu	(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	32(%rsp), %ymm3
	vmovdqu	32(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	64(%rsp), %ymm3
	vmovdqu	64(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	96(%rsp), %ymm3
	vmovdqu	96(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	128(%rsp), %ymm3
	vmovdqu	128(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	160(%rsp), %ymm3
	vmovdqu	160(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	192(%rsp), %ymm3
	vmovdqu	192(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	224(%rsp), %ymm3
	vmovdqu	224(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	256(%rsp), %ymm3
	vmovdqu	256(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	288(%rsp), %ymm3
	vmovdqu	288(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	320(%rsp), %ymm3
	vmovdqu	320(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	352(%rsp), %ymm3
	vmovdqu	352(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	384(%rsp), %ymm3
	vmovdqu	384(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	416(%rsp), %ymm3
	vmovdqu	416(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	448(%rsp), %ymm3
	vmovdqu	448(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	480(%rsp), %ymm3
	vmovdqu	480(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	512(%rsp), %ymm3
	vmovdqu	512(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	544(%rsp), %ymm3
	vmovdqu	544(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	576(%rsp), %ymm3
	vmovdqu	576(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	608(%rsp), %ymm3
	vmovdqu	608(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	640(%rsp), %ymm3
	vmovdqu	640(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	672(%rsp), %ymm3
	vmovdqu	672(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	704(%rsp), %ymm3
	vmovdqu	704(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	736(%rsp), %ymm3
	vmovdqu	736(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	768(%rsp), %ymm3
	vmovdqu	768(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	800(%rsp), %ymm3
	vmovdqu	800(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	832(%rsp), %ymm3
	vmovdqu	832(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	864(%rsp), %ymm3
	vmovdqu	864(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	896(%rsp), %ymm3
	vmovdqu	896(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	928(%rsp), %ymm3
	vmovdqu	928(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	960(%rsp), %ymm3
	vmovdqu	960(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	992(%rsp), %ymm3
	vmovdqu	992(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1024(%rsp), %ymm3
	vmovdqu	1024(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1056(%rsp), %ymm3
	vmovdqu	1056(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1088(%rsp), %ymm3
	vmovdqu	1088(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1120(%rsp), %ymm3
	vmovdqu	1120(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	movq	$0, %rax
	movq	$-1, %rcx
	cmovne	%rcx, %rax
// declassify_val u64 %rax
	lfence
	movq	$0, %rsi
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$2752, %rsp
	movq	$2752, %rdi
.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$7:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_check_pk$7
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem768_amd64_avx2_dec, %function
jade_kem_mlkem_mlkem768_amd64_avx2_dec:
	movq	%rsp, %rax
	leaq	-14752(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 14696(%rsp)
	movq	%rbp, 14704(%rsp)
	movq	%r12, 14712(%rsp)
	movq	%r13, 14720(%rsp)
	movq	%r14, 14728(%rsp)
	movq	%r15, 14736(%rsp)
	movq	%rax, 14744(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, 14656(%rsp)
	movq	%rsi, 14664(%rsp)
	movq	%rdx, 14672(%rsp)
	movq	%rdx, 14680(%rsp)
	movq	%rsp, %rax
	leaq	1152(%rdx), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$53:
	leaq	248(%rsp), %rsp
	movq	14680(%rsp), %rax
	lfence
	movq	$0, %rsi
	vmovdqu	(%rsp), %ymm3
	vmovdqu	2336(%rax), %ymm0
	vpxor	%ymm0, %ymm3, %ymm3
	vptest	%ymm3, %ymm3
	movq	$0, %rcx
	movq	$-1, %rax
	cmovne	%rax, %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rsi
	movq	14656(%rsp), %rsi
	movq	14664(%rsp), %rdx
	movq	14672(%rsp), %rax
	lfence
	movq	$0, %rdi
	movq	%rcx, 14672(%rsp)
	cmpq	$0, %rcx
	je  	.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$1
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rsi)
	jmp 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$2
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$1:
	movq	%rsi, 14664(%rsp)
	movq	%rdx, 14656(%rsp)
	movq	%rax, 14680(%rsp)
	vmovdqu	2368(%rax), %ymm0
	vmovdqu	%ymm0, 2784(%rsp)
	movq	%rax, %rsi
	leaq	32(%rsp), %rcx
	leaq	3904(%rsp), %rdi
	vpbroadcastd	glob_data + 4596(%rip), %ymm0
	vmovdqu	glob_data + 160(%rip), %ymm1
	vpbroadcastq	glob_data + 4352(%rip), %ymm2
	vpbroadcastd	glob_data + 4592(%rip), %ymm3
	vmovdqu	(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, (%rdi)
	vmovdqu	20(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 32(%rdi)
	vmovdqu	40(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 64(%rdi)
	vmovdqu	60(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 96(%rdi)
	vmovdqu	80(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 128(%rdi)
	vmovdqu	100(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 160(%rdi)
	vmovdqu	120(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 192(%rdi)
	vmovdqu	140(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 224(%rdi)
	vmovdqu	160(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 256(%rdi)
	vmovdqu	180(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 288(%rdi)
	vmovdqu	200(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 320(%rdi)
	vmovdqu	220(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 352(%rdi)
	vmovdqu	240(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 384(%rdi)
	vmovdqu	260(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 416(%rdi)
	vmovdqu	280(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 448(%rdi)
	vmovdqu	300(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 480(%rdi)
	vmovdqu	320(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 512(%rdi)
	vmovdqu	340(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 544(%rdi)
	vmovdqu	360(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 576(%rdi)
	vmovdqu	380(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 608(%rdi)
	vmovdqu	400(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 640(%rdi)
	vmovdqu	420(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 672(%rdi)
	vmovdqu	440(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 704(%rdi)
	vmovdqu	460(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 736(%rdi)
	vmovdqu	480(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 768(%rdi)
	vmovdqu	500(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 800(%rdi)
	vmovdqu	520(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 832(%rdi)
	vmovdqu	540(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 864(%rdi)
	vmovdqu	560(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 896(%rdi)
	vmovdqu	580(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 928(%rdi)
	vmovdqu	600(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 960(%rdi)
	vmovdqu	620(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 992(%rdi)
	vmovdqu	640(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1024(%rdi)
	vmovdqu	660(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1056(%rdi)
	vmovdqu	680(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1088(%rdi)
	vmovdqu	700(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1120(%rdi)
	vmovdqu	720(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1152(%rdi)
	vmovdqu	740(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1184(%rdi)
	vmovdqu	760(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1216(%rdi)
	vmovdqu	780(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1248(%rdi)
	vmovdqu	800(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1280(%rdi)
	vmovdqu	820(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1312(%rdi)
	vmovdqu	840(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1344(%rdi)
	vmovdqu	860(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1376(%rdi)
	vmovdqu	880(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1408(%rdi)
	vmovdqu	900(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1440(%rdi)
	vmovdqu	920(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 1472(%rdi)
	vmovdqu	940(%rdx), %ymm4
	vpermq	$148, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpsrlw	$1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm3
	vpmulhrsw	%ymm0, %ymm3, %ymm3
	vmovdqu	%ymm3, 1504(%rdi)
	leaq	160(%rsp), %rdi
	leaq	960(%rdx), %rdx
	leaq	-24(%rsp), %rsp
	call	.L_i_poly_decompress_dv4$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$52:
	leaq	24(%rsp), %rsp
	leaq	5440(%rsp), %r8
	movq	%rsi, %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$51:
	leaq	5952(%rsp), %r8
	leaq	384(%rsi), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$50:
	leaq	6464(%rsp), %r8
	leaq	768(%rsi), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$49:
	leaq	3904(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$48:
	leaq	4416(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$47:
	leaq	4928(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$46:
	leaq	672(%rsp), %rdx
	leaq	5440(%rsp), %rsi
	leaq	3904(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$45:
	leaq	672(%rsp), %rdx
	leaq	5952(%rsp), %rsi
	leaq	4416(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$44:
	leaq	672(%rsp), %rdx
	leaq	6464(%rsp), %rsi
	leaq	4928(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$43:
	leaq	672(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$42:
	leaq	1184(%rsp), %rdx
	leaq	160(%rsp), %rsi
	leaq	672(%rsp), %rdi
	call	.L_poly_sub$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$41:
	leaq	1184(%rsp), %rdx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdx)
	vmovdqu	32(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rdx)
	vmovdqu	64(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	96(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rdx)
	vmovdqu	128(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rdx)
	vmovdqu	160(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rdx)
	vmovdqu	192(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rdx)
	vmovdqu	224(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rdx)
	vmovdqu	256(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rdx)
	vmovdqu	288(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rdx)
	vmovdqu	320(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rdx)
	vmovdqu	352(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rdx)
	vmovdqu	384(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rdx)
	vmovdqu	416(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rdx)
	vmovdqu	448(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rdx)
	vmovdqu	480(%rdx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rdx)
	leaq	1184(%rsp), %rsi
	call	.L_i_poly_tomsg$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$40:
	vmovdqu	2336(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	leaq	96(%rsp), %rdi
	leaq	32(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A64$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$39:
	leaq	248(%rsp), %rsp
	movq	14680(%rsp), %rax
	lfence
	movq	$0, %rsi
	leaq	1696(%rsp), %rsi
	leaq	32(%rsp), %rcx
	leaq	1152(%rax), %rdx
	leaq	128(%rsp), %r8
	movq	%rsi, 14680(%rsp)
	movq	%r8, 14688(%rsp)
	movq	%rdx, %rax
	leaq	3904(%rsp), %r8
	movq	%rax, %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$38:
	leaq	4416(%rsp), %r8
	leaq	384(%rax), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$37:
	leaq	4928(%rsp), %r8
	leaq	768(%rax), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$36:
	movq	1152(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, (%rsp)
	movq	1160(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 8(%rsp)
	movq	1168(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 16(%rsp)
	movq	1176(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 24(%rsp)
	leaq	1184(%rsp), %rdx
	call	.L_i_poly_frommsg$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$35:
	movq	$1, %rax
	leaq	10048(%rsp), %rdx
	movq	%rsp, %rcx
	leaq	-2424(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$34:
	leaq	2424(%rsp), %rsp
	movq	14688(%rsp), %r8
	lfence
	movq	$0, %rsi
	movb	$0, %bl
	leaq	6976(%rsp), %rax
	leaq	7488(%rsp), %r9
	leaq	8000(%rsp), %r10
	leaq	5440(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$33:
	leaq	600(%rsp), %rsp
	movq	14688(%rsp), %r8
	lfence
	movq	$0, %rsi
	movb	$4, %bl
	leaq	5952(%rsp), %rax
	leaq	6464(%rsp), %r9
	leaq	672(%rsp), %r10
	leaq	8512(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$32:
	leaq	600(%rsp), %rsp
	leaq	6976(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$31:
	leaq	7488(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$30:
	leaq	8000(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$29:
	leaq	8512(%rsp), %rdx
	leaq	10048(%rsp), %rsi
	leaq	6976(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$28:
	leaq	8512(%rsp), %rdx
	leaq	10560(%rsp), %rsi
	leaq	7488(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$27:
	leaq	8512(%rsp), %rdx
	leaq	11072(%rsp), %rsi
	leaq	8000(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$26:
	leaq	9024(%rsp), %rdx
	leaq	11584(%rsp), %rsi
	leaq	6976(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$25:
	leaq	9024(%rsp), %rdx
	leaq	12096(%rsp), %rsi
	leaq	7488(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$24:
	leaq	9024(%rsp), %rdx
	leaq	12608(%rsp), %rsi
	leaq	8000(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$23:
	leaq	9536(%rsp), %rdx
	leaq	13120(%rsp), %rsi
	leaq	6976(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$22:
	leaq	9536(%rsp), %rdx
	leaq	13632(%rsp), %rsi
	leaq	7488(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$21:
	leaq	9536(%rsp), %rdx
	leaq	14144(%rsp), %rsi
	leaq	8000(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$20:
	leaq	160(%rsp), %rdx
	leaq	3904(%rsp), %rsi
	leaq	6976(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$19:
	leaq	160(%rsp), %rdx
	leaq	4416(%rsp), %rsi
	leaq	7488(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$18:
	leaq	160(%rsp), %rdx
	leaq	4928(%rsp), %rsi
	leaq	8000(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$17:
	leaq	8512(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$16:
	leaq	9024(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$15:
	leaq	9536(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$14:
	leaq	160(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$13:
	leaq	8512(%rsp), %rcx
	leaq	5440(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$12:
	leaq	9024(%rsp), %rcx
	leaq	5952(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$11:
	leaq	9536(%rsp), %rcx
	leaq	6464(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$10:
	leaq	160(%rsp), %rcx
	leaq	672(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$9:
	leaq	160(%rsp), %rcx
	leaq	1184(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$8:
	leaq	8512(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	9024(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	9536(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	160(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	movq	14680(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	%rax, %rcx
	leaq	8512(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$7:
	leaq	9024(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$6:
	leaq	9536(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$5:
	leaq	glob_data + 544(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	vpsllw	$3, %ymm0, %ymm1
	vpbroadcastw	glob_data + 4624(%rip), %ymm2
	vpbroadcastw	glob_data + 4622(%rip), %ymm3
	vpbroadcastw	glob_data + 4620(%rip), %ymm4
	vpbroadcastq	glob_data + 4344(%rip), %ymm5
	vpbroadcastq	glob_data + 4336(%rip), %ymm6
	vmovdqu	glob_data + 128(%rip), %ymm7
	vmovdqu	8512(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, (%rcx)
	vpextrd	$0, %xmm11, 16(%rcx)
	vmovdqu	8544(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 20(%rcx)
	vpextrd	$0, %xmm11, 36(%rcx)
	vmovdqu	8576(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 40(%rcx)
	vpextrd	$0, %xmm11, 56(%rcx)
	vmovdqu	8608(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 60(%rcx)
	vpextrd	$0, %xmm11, 76(%rcx)
	vmovdqu	8640(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 80(%rcx)
	vpextrd	$0, %xmm11, 96(%rcx)
	vmovdqu	8672(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 100(%rcx)
	vpextrd	$0, %xmm11, 116(%rcx)
	vmovdqu	8704(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 120(%rcx)
	vpextrd	$0, %xmm11, 136(%rcx)
	vmovdqu	8736(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 140(%rcx)
	vpextrd	$0, %xmm11, 156(%rcx)
	vmovdqu	8768(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 160(%rcx)
	vpextrd	$0, %xmm11, 176(%rcx)
	vmovdqu	8800(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 180(%rcx)
	vpextrd	$0, %xmm11, 196(%rcx)
	vmovdqu	8832(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 200(%rcx)
	vpextrd	$0, %xmm11, 216(%rcx)
	vmovdqu	8864(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 220(%rcx)
	vpextrd	$0, %xmm11, 236(%rcx)
	vmovdqu	8896(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 240(%rcx)
	vpextrd	$0, %xmm11, 256(%rcx)
	vmovdqu	8928(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 260(%rcx)
	vpextrd	$0, %xmm11, 276(%rcx)
	vmovdqu	8960(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 280(%rcx)
	vpextrd	$0, %xmm11, 296(%rcx)
	vmovdqu	8992(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 300(%rcx)
	vpextrd	$0, %xmm11, 316(%rcx)
	vmovdqu	9024(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 320(%rcx)
	vpextrd	$0, %xmm11, 336(%rcx)
	vmovdqu	9056(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 340(%rcx)
	vpextrd	$0, %xmm11, 356(%rcx)
	vmovdqu	9088(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 360(%rcx)
	vpextrd	$0, %xmm11, 376(%rcx)
	vmovdqu	9120(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 380(%rcx)
	vpextrd	$0, %xmm11, 396(%rcx)
	vmovdqu	9152(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 400(%rcx)
	vpextrd	$0, %xmm11, 416(%rcx)
	vmovdqu	9184(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 420(%rcx)
	vpextrd	$0, %xmm11, 436(%rcx)
	vmovdqu	9216(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 440(%rcx)
	vpextrd	$0, %xmm11, 456(%rcx)
	vmovdqu	9248(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 460(%rcx)
	vpextrd	$0, %xmm11, 476(%rcx)
	vmovdqu	9280(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 480(%rcx)
	vpextrd	$0, %xmm11, 496(%rcx)
	vmovdqu	9312(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 500(%rcx)
	vpextrd	$0, %xmm11, 516(%rcx)
	vmovdqu	9344(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 520(%rcx)
	vpextrd	$0, %xmm11, 536(%rcx)
	vmovdqu	9376(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 540(%rcx)
	vpextrd	$0, %xmm11, 556(%rcx)
	vmovdqu	9408(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 560(%rcx)
	vpextrd	$0, %xmm11, 576(%rcx)
	vmovdqu	9440(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 580(%rcx)
	vpextrd	$0, %xmm11, 596(%rcx)
	vmovdqu	9472(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 600(%rcx)
	vpextrd	$0, %xmm11, 616(%rcx)
	vmovdqu	9504(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 620(%rcx)
	vpextrd	$0, %xmm11, 636(%rcx)
	vmovdqu	9536(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 640(%rcx)
	vpextrd	$0, %xmm11, 656(%rcx)
	vmovdqu	9568(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 660(%rcx)
	vpextrd	$0, %xmm11, 676(%rcx)
	vmovdqu	9600(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 680(%rcx)
	vpextrd	$0, %xmm11, 696(%rcx)
	vmovdqu	9632(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 700(%rcx)
	vpextrd	$0, %xmm11, 716(%rcx)
	vmovdqu	9664(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 720(%rcx)
	vpextrd	$0, %xmm11, 736(%rcx)
	vmovdqu	9696(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 740(%rcx)
	vpextrd	$0, %xmm11, 756(%rcx)
	vmovdqu	9728(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 760(%rcx)
	vpextrd	$0, %xmm11, 776(%rcx)
	vmovdqu	9760(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 780(%rcx)
	vpextrd	$0, %xmm11, 796(%rcx)
	vmovdqu	9792(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 800(%rcx)
	vpextrd	$0, %xmm11, 816(%rcx)
	vmovdqu	9824(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 820(%rcx)
	vpextrd	$0, %xmm11, 836(%rcx)
	vmovdqu	9856(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 840(%rcx)
	vpextrd	$0, %xmm11, 856(%rcx)
	vmovdqu	9888(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 860(%rcx)
	vpextrd	$0, %xmm11, 876(%rcx)
	vmovdqu	9920(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 880(%rcx)
	vpextrd	$0, %xmm11, 896(%rcx)
	vmovdqu	9952(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 900(%rcx)
	vpextrd	$0, %xmm11, 916(%rcx)
	vmovdqu	9984(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 920(%rcx)
	vpextrd	$0, %xmm11, 936(%rcx)
	vmovdqu	10016(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm4
	vpmaddwd	%ymm5, %ymm4, %ymm4
	vpsllvd	%ymm6, %ymm4, %ymm4
	vpsrlq	$12, %ymm4, %ymm4
	vpshufb	%ymm7, %ymm4, %ymm4
	vmovdqu	%xmm4, %xmm2
	vextracti128	$1, %ymm4, %xmm3
	vpblendw	$224, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 940(%rcx)
	vpextrd	$0, %xmm3, 956(%rcx)
	leaq	960(%rax), %rcx
	leaq	160(%rsp), %rsi
	call	.L_i_poly_compress_dv4$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$4:
	movq	14656(%rsp), %rax
	movq	14664(%rsp), %rdi
	lfence
	movq	$0, %rsi
	leaq	1696(%rsp), %rcx
	movq	$0, %rdx
	movq	$1, %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rcx), %ymm3
	vmovdqu	(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	32(%rcx), %ymm3
	vmovdqu	32(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	64(%rcx), %ymm3
	vmovdqu	64(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	96(%rcx), %ymm3
	vmovdqu	96(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	128(%rcx), %ymm3
	vmovdqu	128(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	160(%rcx), %ymm3
	vmovdqu	160(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	192(%rcx), %ymm3
	vmovdqu	192(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	224(%rcx), %ymm3
	vmovdqu	224(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	256(%rcx), %ymm3
	vmovdqu	256(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	288(%rcx), %ymm3
	vmovdqu	288(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	320(%rcx), %ymm3
	vmovdqu	320(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	352(%rcx), %ymm3
	vmovdqu	352(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	384(%rcx), %ymm3
	vmovdqu	384(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	416(%rcx), %ymm3
	vmovdqu	416(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	448(%rcx), %ymm3
	vmovdqu	448(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	480(%rcx), %ymm3
	vmovdqu	480(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	512(%rcx), %ymm3
	vmovdqu	512(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	544(%rcx), %ymm3
	vmovdqu	544(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	576(%rcx), %ymm3
	vmovdqu	576(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	608(%rcx), %ymm3
	vmovdqu	608(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	640(%rcx), %ymm3
	vmovdqu	640(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	672(%rcx), %ymm3
	vmovdqu	672(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	704(%rcx), %ymm3
	vmovdqu	704(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	736(%rcx), %ymm3
	vmovdqu	736(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	768(%rcx), %ymm3
	vmovdqu	768(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	800(%rcx), %ymm3
	vmovdqu	800(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	832(%rcx), %ymm3
	vmovdqu	832(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	864(%rcx), %ymm3
	vmovdqu	864(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	896(%rcx), %ymm3
	vmovdqu	896(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	928(%rcx), %ymm3
	vmovdqu	928(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	960(%rcx), %ymm3
	vmovdqu	960(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	992(%rcx), %ymm3
	vmovdqu	992(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1024(%rcx), %ymm3
	vmovdqu	1024(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1056(%rcx), %ymm3
	vmovdqu	1056(%rax), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	cmovne	%rsi, %rdx
	movq	%rdx, 14664(%rsp)
	vmovdqu	(%rax), %ymm4
	vmovdqu	%ymm4, 2816(%rsp)
	vmovdqu	32(%rax), %ymm4
	vmovdqu	%ymm4, 2848(%rsp)
	vmovdqu	64(%rax), %ymm4
	vmovdqu	%ymm4, 2880(%rsp)
	vmovdqu	96(%rax), %ymm4
	vmovdqu	%ymm4, 2912(%rsp)
	vmovdqu	128(%rax), %ymm4
	vmovdqu	%ymm4, 2944(%rsp)
	vmovdqu	160(%rax), %ymm4
	vmovdqu	%ymm4, 2976(%rsp)
	vmovdqu	192(%rax), %ymm4
	vmovdqu	%ymm4, 3008(%rsp)
	vmovdqu	224(%rax), %ymm4
	vmovdqu	%ymm4, 3040(%rsp)
	vmovdqu	256(%rax), %ymm4
	vmovdqu	%ymm4, 3072(%rsp)
	vmovdqu	288(%rax), %ymm4
	vmovdqu	%ymm4, 3104(%rsp)
	vmovdqu	320(%rax), %ymm4
	vmovdqu	%ymm4, 3136(%rsp)
	vmovdqu	352(%rax), %ymm4
	vmovdqu	%ymm4, 3168(%rsp)
	vmovdqu	384(%rax), %ymm4
	vmovdqu	%ymm4, 3200(%rsp)
	vmovdqu	416(%rax), %ymm4
	vmovdqu	%ymm4, 3232(%rsp)
	vmovdqu	448(%rax), %ymm4
	vmovdqu	%ymm4, 3264(%rsp)
	vmovdqu	480(%rax), %ymm4
	vmovdqu	%ymm4, 3296(%rsp)
	vmovdqu	512(%rax), %ymm4
	vmovdqu	%ymm4, 3328(%rsp)
	vmovdqu	544(%rax), %ymm4
	vmovdqu	%ymm4, 3360(%rsp)
	vmovdqu	576(%rax), %ymm4
	vmovdqu	%ymm4, 3392(%rsp)
	vmovdqu	608(%rax), %ymm4
	vmovdqu	%ymm4, 3424(%rsp)
	vmovdqu	640(%rax), %ymm4
	vmovdqu	%ymm4, 3456(%rsp)
	vmovdqu	672(%rax), %ymm4
	vmovdqu	%ymm4, 3488(%rsp)
	vmovdqu	704(%rax), %ymm4
	vmovdqu	%ymm4, 3520(%rsp)
	vmovdqu	736(%rax), %ymm4
	vmovdqu	%ymm4, 3552(%rsp)
	vmovdqu	768(%rax), %ymm4
	vmovdqu	%ymm4, 3584(%rsp)
	vmovdqu	800(%rax), %ymm4
	vmovdqu	%ymm4, 3616(%rsp)
	vmovdqu	832(%rax), %ymm4
	vmovdqu	%ymm4, 3648(%rsp)
	vmovdqu	864(%rax), %ymm4
	vmovdqu	%ymm4, 3680(%rsp)
	vmovdqu	896(%rax), %ymm4
	vmovdqu	%ymm4, 3712(%rsp)
	vmovdqu	928(%rax), %ymm4
	vmovdqu	%ymm4, 3744(%rsp)
	vmovdqu	960(%rax), %ymm4
	vmovdqu	%ymm4, 3776(%rsp)
	vmovdqu	992(%rax), %ymm4
	vmovdqu	%ymm4, 3808(%rsp)
	vmovdqu	1024(%rax), %ymm4
	vmovdqu	%ymm4, 3840(%rsp)
	vmovdqu	1056(%rax), %ymm4
	vmovdqu	%ymm4, 3872(%rsp)
	leaq	2784(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A32__AZCT$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$3:
	leaq	248(%rsp), %rsp
	movq	14664(%rsp), %rdx
	leaq	96(%rsp), %rax
	negq	%rdx
	movq	%rdx, 14664(%rsp)
	vpbroadcastq	14664(%rsp), %ymm0
	vmovdqu	(%rax), %ymm3
	vmovdqu	(%rdi), %ymm1
	vpblendvb	%ymm0, %ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rdi)
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$2:
	movq	14672(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	14696(%rsp), %rbx
	movq	14704(%rsp), %rbp
	movq	14712(%rsp), %r12
	movq	14720(%rsp), %r13
	movq	14728(%rsp), %r14
	movq	14736(%rsp), %r15
	movq	14744(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$19072, %rsp
	movq	$19072, %rdi
.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$54:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_dec$54
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem768_amd64_avx2_enc_derand, %function
jade_kem_mlkem_mlkem768_amd64_avx2_enc_derand:
	movq	%rsp, %rax
	leaq	-13696(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 13640(%rsp)
	movq	%rbp, 13648(%rsp)
	movq	%r12, 13656(%rsp)
	movq	%r13, 13664(%rsp)
	movq	%r14, 13672(%rsp)
	movq	%r15, 13680(%rsp)
	movq	%rax, 13688(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, 13600(%rsp)
	movq	%rsi, 13608(%rsp)
	movq	%rdx, 13616(%rsp)
	movq	%rcx, 13624(%rsp)
	movq	%rdx, 13632(%rsp)
	leaq	2848(%rsp), %r8
	movq	%rdx, %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$45:
	leaq	3360(%rsp), %r8
	leaq	384(%rdx), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$44:
	leaq	3872(%rsp), %r8
	leaq	768(%rdx), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$43:
	leaq	1696(%rsp), %rax
	movq	%rax, %rcx
	leaq	2848(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$42:
	leaq	384(%rax), %rcx
	leaq	3360(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$41:
	leaq	768(%rax), %rcx
	leaq	3872(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$40:
	movq	13632(%rsp), %rdx
	lfence
	movq	$0, %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	1696(%rsp), %ymm3
	vmovdqu	(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1728(%rsp), %ymm3
	vmovdqu	32(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1760(%rsp), %ymm3
	vmovdqu	64(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1792(%rsp), %ymm3
	vmovdqu	96(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1824(%rsp), %ymm3
	vmovdqu	128(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1856(%rsp), %ymm3
	vmovdqu	160(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1888(%rsp), %ymm3
	vmovdqu	192(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1920(%rsp), %ymm3
	vmovdqu	224(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1952(%rsp), %ymm3
	vmovdqu	256(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	1984(%rsp), %ymm3
	vmovdqu	288(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2016(%rsp), %ymm3
	vmovdqu	320(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2048(%rsp), %ymm3
	vmovdqu	352(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2080(%rsp), %ymm3
	vmovdqu	384(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2112(%rsp), %ymm3
	vmovdqu	416(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2144(%rsp), %ymm3
	vmovdqu	448(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2176(%rsp), %ymm3
	vmovdqu	480(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2208(%rsp), %ymm3
	vmovdqu	512(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2240(%rsp), %ymm3
	vmovdqu	544(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2272(%rsp), %ymm3
	vmovdqu	576(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2304(%rsp), %ymm3
	vmovdqu	608(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2336(%rsp), %ymm3
	vmovdqu	640(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2368(%rsp), %ymm3
	vmovdqu	672(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2400(%rsp), %ymm3
	vmovdqu	704(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2432(%rsp), %ymm3
	vmovdqu	736(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2464(%rsp), %ymm3
	vmovdqu	768(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2496(%rsp), %ymm3
	vmovdqu	800(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2528(%rsp), %ymm3
	vmovdqu	832(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2560(%rsp), %ymm3
	vmovdqu	864(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2592(%rsp), %ymm3
	vmovdqu	896(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2624(%rsp), %ymm3
	vmovdqu	928(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2656(%rsp), %ymm3
	vmovdqu	960(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2688(%rsp), %ymm3
	vmovdqu	992(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2720(%rsp), %ymm3
	vmovdqu	1024(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2752(%rsp), %ymm3
	vmovdqu	1056(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2784(%rsp), %ymm3
	vmovdqu	1088(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vmovdqu	2816(%rsp), %ymm3
	vmovdqu	1120(%rdx), %ymm1
	vpxor	%ymm1, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	movq	$0, %rax
	movq	$-1, %rcx
	cmovne	%rcx, %rax
// declassify_val u64 %rax
	lfence
	movq	$0, %rsi
	movq	13600(%rsp), %rsi
	movq	13608(%rsp), %rdi
	movq	13616(%rsp), %rdx
	movq	13624(%rsp), %rcx
	lfence
	movq	$0, %r8
	movq	%rax, 13624(%rsp)
	cmpq	$0, %rax
	je  	.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$1
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rsi)
	vmovdqu	%ymm0, 32(%rsi)
	vmovdqu	%ymm0, 64(%rsi)
	vmovdqu	%ymm0, 96(%rsi)
	vmovdqu	%ymm0, 128(%rsi)
	vmovdqu	%ymm0, 160(%rsi)
	vmovdqu	%ymm0, 192(%rsi)
	vmovdqu	%ymm0, 224(%rsi)
	vmovdqu	%ymm0, 256(%rsi)
	vmovdqu	%ymm0, 288(%rsi)
	vmovdqu	%ymm0, 320(%rsi)
	vmovdqu	%ymm0, 352(%rsi)
	vmovdqu	%ymm0, 384(%rsi)
	vmovdqu	%ymm0, 416(%rsi)
	vmovdqu	%ymm0, 448(%rsi)
	vmovdqu	%ymm0, 480(%rsi)
	vmovdqu	%ymm0, 512(%rsi)
	vmovdqu	%ymm0, 544(%rsi)
	vmovdqu	%ymm0, 576(%rsi)
	vmovdqu	%ymm0, 608(%rsi)
	vmovdqu	%ymm0, 640(%rsi)
	vmovdqu	%ymm0, 672(%rsi)
	vmovdqu	%ymm0, 704(%rsi)
	vmovdqu	%ymm0, 736(%rsi)
	vmovdqu	%ymm0, 768(%rsi)
	vmovdqu	%ymm0, 800(%rsi)
	vmovdqu	%ymm0, 832(%rsi)
	vmovdqu	%ymm0, 864(%rsi)
	vmovdqu	%ymm0, 896(%rsi)
	vmovdqu	%ymm0, 928(%rsi)
	vmovdqu	%ymm0, 960(%rsi)
	vmovdqu	%ymm0, 992(%rsi)
	vmovdqu	%ymm0, 1024(%rsi)
	vmovdqu	%ymm0, 1056(%rsi)
	vmovdqu	%ymm0, (%rdi)
	jmp 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$2
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$1:
	movq	%rsi, 13616(%rsp)
	movq	%rdx, 13608(%rsp)
	movq	%rdi, 13600(%rsp)
	vmovdqu	(%rcx), %ymm1
	vmovdqu	%ymm1, 32(%rsp)
	leaq	64(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$39:
	leaq	248(%rsp), %rsp
	leaq	96(%rsp), %rdi
	leaq	32(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A64$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$38:
	leaq	248(%rsp), %rsp
	movq	13616(%rsp), %rax
	movq	13608(%rsp), %rdx
	lfence
	movq	$0, %rsi
	leaq	32(%rsp), %rcx
	leaq	128(%rsp), %r8
	movq	%rax, 13608(%rsp)
	movq	%r8, 13616(%rsp)
	movq	%rdx, %rax
	leaq	2848(%rsp), %r8
	movq	%rax, %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$37:
	leaq	3360(%rsp), %r8
	leaq	384(%rax), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$36:
	leaq	3872(%rsp), %r8
	leaq	768(%rax), %r9
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$35:
	movq	1152(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, (%rsp)
	movq	1160(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 8(%rsp)
	movq	1168(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 16(%rsp)
	movq	1176(%rdx), %rax
// declassify_val u64 %rax
	movq	%rax, 24(%rsp)
	leaq	160(%rsp), %rdx
	call	.L_i_poly_frommsg$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$34:
	movq	$1, %rax
	leaq	8992(%rsp), %rdx
	movq	%rsp, %rcx
	leaq	-2424(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$33:
	leaq	2424(%rsp), %rsp
	movq	13616(%rsp), %r8
	lfence
	movq	$0, %rsi
	movb	$0, %bl
	leaq	5920(%rsp), %rax
	leaq	6432(%rsp), %r9
	leaq	6944(%rsp), %r10
	leaq	4384(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$32:
	leaq	600(%rsp), %rsp
	movq	13616(%rsp), %r8
	lfence
	movq	$0, %rsi
	movb	$4, %bl
	leaq	4896(%rsp), %rax
	leaq	5408(%rsp), %r9
	leaq	672(%rsp), %r10
	leaq	7456(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$31:
	leaq	600(%rsp), %rsp
	leaq	5920(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$30:
	leaq	6432(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$29:
	leaq	6944(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$28:
	leaq	7456(%rsp), %rdx
	leaq	8992(%rsp), %rsi
	leaq	5920(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$27:
	leaq	7456(%rsp), %rdx
	leaq	9504(%rsp), %rsi
	leaq	6432(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$26:
	leaq	7456(%rsp), %rdx
	leaq	10016(%rsp), %rsi
	leaq	6944(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$25:
	leaq	7968(%rsp), %rdx
	leaq	10528(%rsp), %rsi
	leaq	5920(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$24:
	leaq	7968(%rsp), %rdx
	leaq	11040(%rsp), %rsi
	leaq	6432(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$23:
	leaq	7968(%rsp), %rdx
	leaq	11552(%rsp), %rsi
	leaq	6944(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$22:
	leaq	8480(%rsp), %rdx
	leaq	12064(%rsp), %rsi
	leaq	5920(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$21:
	leaq	8480(%rsp), %rdx
	leaq	12576(%rsp), %rsi
	leaq	6432(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$20:
	leaq	8480(%rsp), %rdx
	leaq	13088(%rsp), %rsi
	leaq	6944(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$19:
	leaq	1184(%rsp), %rdx
	leaq	2848(%rsp), %rsi
	leaq	5920(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$18:
	leaq	1184(%rsp), %rdx
	leaq	3360(%rsp), %rsi
	leaq	6432(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$17:
	leaq	1184(%rsp), %rdx
	leaq	3872(%rsp), %rsi
	leaq	6944(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$16:
	leaq	7456(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$15:
	leaq	7968(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$14:
	leaq	8480(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$13:
	leaq	1184(%rsp), %rdx
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$12:
	leaq	7456(%rsp), %rcx
	leaq	4384(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$11:
	leaq	7968(%rsp), %rcx
	leaq	4896(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$10:
	leaq	8480(%rsp), %rcx
	leaq	5408(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$9:
	leaq	1184(%rsp), %rcx
	leaq	672(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$8:
	leaq	1184(%rsp), %rcx
	leaq	160(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$7:
	leaq	7456(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	7968(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	8480(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	1184(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	movq	13608(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	%rax, %rcx
	leaq	7456(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$6:
	leaq	7968(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$5:
	leaq	8480(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$4:
	leaq	glob_data + 544(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	vpsllw	$3, %ymm0, %ymm1
	vpbroadcastw	glob_data + 4624(%rip), %ymm2
	vpbroadcastw	glob_data + 4622(%rip), %ymm3
	vpbroadcastw	glob_data + 4620(%rip), %ymm4
	vpbroadcastq	glob_data + 4344(%rip), %ymm5
	vpbroadcastq	glob_data + 4336(%rip), %ymm6
	vmovdqu	glob_data + 128(%rip), %ymm7
	vmovdqu	7456(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, (%rcx)
	vpextrd	$0, %xmm11, 16(%rcx)
	vmovdqu	7488(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 20(%rcx)
	vpextrd	$0, %xmm11, 36(%rcx)
	vmovdqu	7520(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 40(%rcx)
	vpextrd	$0, %xmm11, 56(%rcx)
	vmovdqu	7552(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 60(%rcx)
	vpextrd	$0, %xmm11, 76(%rcx)
	vmovdqu	7584(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 80(%rcx)
	vpextrd	$0, %xmm11, 96(%rcx)
	vmovdqu	7616(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 100(%rcx)
	vpextrd	$0, %xmm11, 116(%rcx)
	vmovdqu	7648(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 120(%rcx)
	vpextrd	$0, %xmm11, 136(%rcx)
	vmovdqu	7680(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 140(%rcx)
	vpextrd	$0, %xmm11, 156(%rcx)
	vmovdqu	7712(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 160(%rcx)
	vpextrd	$0, %xmm11, 176(%rcx)
	vmovdqu	7744(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 180(%rcx)
	vpextrd	$0, %xmm11, 196(%rcx)
	vmovdqu	7776(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 200(%rcx)
	vpextrd	$0, %xmm11, 216(%rcx)
	vmovdqu	7808(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 220(%rcx)
	vpextrd	$0, %xmm11, 236(%rcx)
	vmovdqu	7840(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 240(%rcx)
	vpextrd	$0, %xmm11, 256(%rcx)
	vmovdqu	7872(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 260(%rcx)
	vpextrd	$0, %xmm11, 276(%rcx)
	vmovdqu	7904(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 280(%rcx)
	vpextrd	$0, %xmm11, 296(%rcx)
	vmovdqu	7936(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 300(%rcx)
	vpextrd	$0, %xmm11, 316(%rcx)
	vmovdqu	7968(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 320(%rcx)
	vpextrd	$0, %xmm11, 336(%rcx)
	vmovdqu	8000(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 340(%rcx)
	vpextrd	$0, %xmm11, 356(%rcx)
	vmovdqu	8032(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 360(%rcx)
	vpextrd	$0, %xmm11, 376(%rcx)
	vmovdqu	8064(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 380(%rcx)
	vpextrd	$0, %xmm11, 396(%rcx)
	vmovdqu	8096(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 400(%rcx)
	vpextrd	$0, %xmm11, 416(%rcx)
	vmovdqu	8128(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 420(%rcx)
	vpextrd	$0, %xmm11, 436(%rcx)
	vmovdqu	8160(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 440(%rcx)
	vpextrd	$0, %xmm11, 456(%rcx)
	vmovdqu	8192(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 460(%rcx)
	vpextrd	$0, %xmm11, 476(%rcx)
	vmovdqu	8224(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 480(%rcx)
	vpextrd	$0, %xmm11, 496(%rcx)
	vmovdqu	8256(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 500(%rcx)
	vpextrd	$0, %xmm11, 516(%rcx)
	vmovdqu	8288(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 520(%rcx)
	vpextrd	$0, %xmm11, 536(%rcx)
	vmovdqu	8320(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 540(%rcx)
	vpextrd	$0, %xmm11, 556(%rcx)
	vmovdqu	8352(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 560(%rcx)
	vpextrd	$0, %xmm11, 576(%rcx)
	vmovdqu	8384(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 580(%rcx)
	vpextrd	$0, %xmm11, 596(%rcx)
	vmovdqu	8416(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 600(%rcx)
	vpextrd	$0, %xmm11, 616(%rcx)
	vmovdqu	8448(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 620(%rcx)
	vpextrd	$0, %xmm11, 636(%rcx)
	vmovdqu	8480(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 640(%rcx)
	vpextrd	$0, %xmm11, 656(%rcx)
	vmovdqu	8512(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 660(%rcx)
	vpextrd	$0, %xmm11, 676(%rcx)
	vmovdqu	8544(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 680(%rcx)
	vpextrd	$0, %xmm11, 696(%rcx)
	vmovdqu	8576(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 700(%rcx)
	vpextrd	$0, %xmm11, 716(%rcx)
	vmovdqu	8608(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 720(%rcx)
	vpextrd	$0, %xmm11, 736(%rcx)
	vmovdqu	8640(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 740(%rcx)
	vpextrd	$0, %xmm11, 756(%rcx)
	vmovdqu	8672(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 760(%rcx)
	vpextrd	$0, %xmm11, 776(%rcx)
	vmovdqu	8704(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 780(%rcx)
	vpextrd	$0, %xmm11, 796(%rcx)
	vmovdqu	8736(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 800(%rcx)
	vpextrd	$0, %xmm11, 816(%rcx)
	vmovdqu	8768(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 820(%rcx)
	vpextrd	$0, %xmm11, 836(%rcx)
	vmovdqu	8800(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 840(%rcx)
	vpextrd	$0, %xmm11, 856(%rcx)
	vmovdqu	8832(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 860(%rcx)
	vpextrd	$0, %xmm11, 876(%rcx)
	vmovdqu	8864(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 880(%rcx)
	vpextrd	$0, %xmm11, 896(%rcx)
	vmovdqu	8896(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 900(%rcx)
	vpextrd	$0, %xmm11, 916(%rcx)
	vmovdqu	8928(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm8
	vpmaddwd	%ymm5, %ymm8, %ymm8
	vpsllvd	%ymm6, %ymm8, %ymm8
	vpsrlq	$12, %ymm8, %ymm8
	vpshufb	%ymm7, %ymm8, %ymm8
	vmovdqu	%xmm8, %xmm13
	vextracti128	$1, %ymm8, %xmm11
	vpblendw	$224, %xmm11, %xmm13, %xmm13
	vmovdqu	%xmm13, 920(%rcx)
	vpextrd	$0, %xmm11, 936(%rcx)
	vmovdqu	8960(%rsp), %ymm8
	vpmullw	%ymm1, %ymm8, %ymm9
	vpaddw	%ymm2, %ymm8, %ymm10
	vpsllw	$3, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm10, %ymm9, %ymm10
	vpandn	%ymm10, %ymm9, %ymm9
	vpsrlw	$15, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpand	%ymm4, %ymm8, %ymm4
	vpmaddwd	%ymm5, %ymm4, %ymm4
	vpsllvd	%ymm6, %ymm4, %ymm4
	vpsrlq	$12, %ymm4, %ymm4
	vpshufb	%ymm7, %ymm4, %ymm4
	vmovdqu	%xmm4, %xmm2
	vextracti128	$1, %ymm4, %xmm3
	vpblendw	$224, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 940(%rcx)
	vpextrd	$0, %xmm3, 956(%rcx)
	leaq	960(%rax), %rcx
	leaq	1184(%rsp), %rsi
	call	.L_i_poly_compress_dv4$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$3:
	movq	13600(%rsp), %rsi
	lfence
	movq	$0, %rdi
	vmovdqu	96(%rsp), %ymm0
	vmovdqu	%ymm0, (%rsi)
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$2:
	movq	13624(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	13640(%rsp), %rbx
	movq	13648(%rsp), %rbp
	movq	13656(%rsp), %r12
	movq	13664(%rsp), %r13
	movq	13672(%rsp), %r14
	movq	13680(%rsp), %r15
	movq	13688(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$18016, %rsp
	movq	$18016, %rdi
.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$46:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_enc_derand$46
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand, %function
jade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand:
	movq	%rsp, %rax
	leaq	-9504(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 9440(%rsp)
	movq	%rbp, 9448(%rsp)
	movq	%r12, 9456(%rsp)
	movq	%r13, 9464(%rsp)
	movq	%r14, 9472(%rsp)
	movq	%r15, 9480(%rsp)
	movq	%rax, 9488(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdx, 9376(%rsp)
	movq	%rsi, %rax
	movq	%rsi, 9384(%rsp)
	movq	%rdi, 9392(%rsp)
	movq	%rax, 9400(%rsp)
	movq	(%rdx), %rax
	movq	%rax, 32(%rsp)
	movq	8(%rdx), %rax
	movq	%rax, 40(%rsp)
	movq	16(%rdx), %rax
	movq	%rax, 48(%rsp)
	movq	24(%rdx), %rax
	movq	%rax, 56(%rsp)
	movb	$3, 64(%rsp)
	leaq	96(%rsp), %rdi
	leaq	32(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A33$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$32:
	leaq	248(%rsp), %rsp
	movq	96(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, (%rsp)
	movq	128(%rsp), %rax
	movq	%rax, 9408(%rsp)
	movq	104(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 8(%rsp)
	movq	136(%rsp), %rax
	movq	%rax, 9416(%rsp)
	movq	112(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 16(%rsp)
	movq	144(%rsp), %rax
	movq	%rax, 9424(%rsp)
	movq	120(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 24(%rsp)
	movq	152(%rsp), %rax
	movq	%rax, 9432(%rsp)
	movq	$0, %rax
	leaq	4768(%rsp), %rdx
	movq	%rsp, %rcx
	leaq	-2424(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$31:
	leaq	2424(%rsp), %rsp
	movb	$0, %bl
	leaq	1696(%rsp), %rax
	leaq	2208(%rsp), %r9
	leaq	2720(%rsp), %r10
	leaq	160(%rsp), %r11
	leaq	9408(%rsp), %r8
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$30:
	leaq	600(%rsp), %rsp
	movb	$4, %bl
	leaq	672(%rsp), %rax
	leaq	1184(%rsp), %r9
	leaq	3232(%rsp), %r10
	leaq	3744(%rsp), %r11
	leaq	9408(%rsp), %r8
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$29:
	leaq	600(%rsp), %rsp
	leaq	1696(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$28:
	leaq	2208(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$27:
	leaq	2720(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$26:
	leaq	160(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$25:
	leaq	672(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$24:
	leaq	1184(%rsp), %rdx
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$23:
	leaq	3232(%rsp), %rdx
	leaq	4768(%rsp), %rsi
	leaq	1696(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$22:
	leaq	3232(%rsp), %rdx
	leaq	5280(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$21:
	leaq	3232(%rsp), %rdx
	leaq	5792(%rsp), %rsi
	leaq	2720(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$20:
	leaq	3232(%rsp), %rcx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$19:
	leaq	3744(%rsp), %rdx
	leaq	6304(%rsp), %rsi
	leaq	1696(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$18:
	leaq	3744(%rsp), %rdx
	leaq	6816(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$17:
	leaq	3744(%rsp), %rdx
	leaq	7328(%rsp), %rsi
	leaq	2720(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$16:
	leaq	3744(%rsp), %rcx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$15:
	leaq	4256(%rsp), %rdx
	leaq	7840(%rsp), %rsi
	leaq	1696(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$14:
	leaq	4256(%rsp), %rdx
	leaq	8352(%rsp), %rsi
	leaq	2208(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$13:
	leaq	4256(%rsp), %rdx
	leaq	8864(%rsp), %rsi
	leaq	2720(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$12:
	leaq	4256(%rsp), %rcx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$11:
	leaq	3232(%rsp), %rcx
	leaq	160(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$10:
	leaq	3744(%rsp), %rcx
	leaq	672(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$9:
	leaq	4256(%rsp), %rcx
	leaq	1184(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$8:
	leaq	3232(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	3744(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	leaq	4256(%rsp), %rcx
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	movq	9392(%rsp), %rdx
	movq	9400(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	%rax, %rcx
	leaq	1696(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$7:
	leaq	384(%rax), %rcx
	leaq	2208(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$6:
	leaq	768(%rax), %rcx
	leaq	2720(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$5:
	movq	%rdx, %rax
	movq	%rax, %rcx
	leaq	3232(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$4:
	leaq	384(%rax), %rcx
	leaq	3744(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$3:
	leaq	768(%rax), %rcx
	leaq	4256(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$2:
	movq	(%rsp), %rax
	movq	%rax, 1152(%rdx)
	movq	8(%rsp), %rax
	movq	%rax, 1160(%rdx)
	movq	16(%rsp), %rax
	movq	%rax, 1168(%rdx)
	movq	24(%rsp), %rax
	movq	%rax, 1176(%rdx)
	movq	9384(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	(%rdx), %rcx
	movq	%rcx, 1152(%rax)
	movq	8(%rdx), %rcx
	movq	%rcx, 1160(%rax)
	movq	16(%rdx), %rcx
	movq	%rcx, 1168(%rax)
	movq	24(%rdx), %rcx
	movq	%rcx, 1176(%rax)
	movq	32(%rdx), %rcx
	movq	%rcx, 1184(%rax)
	movq	40(%rdx), %rcx
	movq	%rcx, 1192(%rax)
	movq	48(%rdx), %rcx
	movq	%rcx, 1200(%rax)
	movq	56(%rdx), %rcx
	movq	%rcx, 1208(%rax)
	movq	64(%rdx), %rcx
	movq	%rcx, 1216(%rax)
	movq	72(%rdx), %rcx
	movq	%rcx, 1224(%rax)
	movq	80(%rdx), %rcx
	movq	%rcx, 1232(%rax)
	movq	88(%rdx), %rcx
	movq	%rcx, 1240(%rax)
	movq	96(%rdx), %rcx
	movq	%rcx, 1248(%rax)
	movq	104(%rdx), %rcx
	movq	%rcx, 1256(%rax)
	movq	112(%rdx), %rcx
	movq	%rcx, 1264(%rax)
	movq	120(%rdx), %rcx
	movq	%rcx, 1272(%rax)
	movq	128(%rdx), %rcx
	movq	%rcx, 1280(%rax)
	movq	136(%rdx), %rcx
	movq	%rcx, 1288(%rax)
	movq	144(%rdx), %rcx
	movq	%rcx, 1296(%rax)
	movq	152(%rdx), %rcx
	movq	%rcx, 1304(%rax)
	movq	160(%rdx), %rcx
	movq	%rcx, 1312(%rax)
	movq	168(%rdx), %rcx
	movq	%rcx, 1320(%rax)
	movq	176(%rdx), %rcx
	movq	%rcx, 1328(%rax)
	movq	184(%rdx), %rcx
	movq	%rcx, 1336(%rax)
	movq	192(%rdx), %rcx
	movq	%rcx, 1344(%rax)
	movq	200(%rdx), %rcx
	movq	%rcx, 1352(%rax)
	movq	208(%rdx), %rcx
	movq	%rcx, 1360(%rax)
	movq	216(%rdx), %rcx
	movq	%rcx, 1368(%rax)
	movq	224(%rdx), %rcx
	movq	%rcx, 1376(%rax)
	movq	232(%rdx), %rcx
	movq	%rcx, 1384(%rax)
	movq	240(%rdx), %rcx
	movq	%rcx, 1392(%rax)
	movq	248(%rdx), %rcx
	movq	%rcx, 1400(%rax)
	movq	256(%rdx), %rcx
	movq	%rcx, 1408(%rax)
	movq	264(%rdx), %rcx
	movq	%rcx, 1416(%rax)
	movq	272(%rdx), %rcx
	movq	%rcx, 1424(%rax)
	movq	280(%rdx), %rcx
	movq	%rcx, 1432(%rax)
	movq	288(%rdx), %rcx
	movq	%rcx, 1440(%rax)
	movq	296(%rdx), %rcx
	movq	%rcx, 1448(%rax)
	movq	304(%rdx), %rcx
	movq	%rcx, 1456(%rax)
	movq	312(%rdx), %rcx
	movq	%rcx, 1464(%rax)
	movq	320(%rdx), %rcx
	movq	%rcx, 1472(%rax)
	movq	328(%rdx), %rcx
	movq	%rcx, 1480(%rax)
	movq	336(%rdx), %rcx
	movq	%rcx, 1488(%rax)
	movq	344(%rdx), %rcx
	movq	%rcx, 1496(%rax)
	movq	352(%rdx), %rcx
	movq	%rcx, 1504(%rax)
	movq	360(%rdx), %rcx
	movq	%rcx, 1512(%rax)
	movq	368(%rdx), %rcx
	movq	%rcx, 1520(%rax)
	movq	376(%rdx), %rcx
	movq	%rcx, 1528(%rax)
	movq	384(%rdx), %rcx
	movq	%rcx, 1536(%rax)
	movq	392(%rdx), %rcx
	movq	%rcx, 1544(%rax)
	movq	400(%rdx), %rcx
	movq	%rcx, 1552(%rax)
	movq	408(%rdx), %rcx
	movq	%rcx, 1560(%rax)
	movq	416(%rdx), %rcx
	movq	%rcx, 1568(%rax)
	movq	424(%rdx), %rcx
	movq	%rcx, 1576(%rax)
	movq	432(%rdx), %rcx
	movq	%rcx, 1584(%rax)
	movq	440(%rdx), %rcx
	movq	%rcx, 1592(%rax)
	movq	448(%rdx), %rcx
	movq	%rcx, 1600(%rax)
	movq	456(%rdx), %rcx
	movq	%rcx, 1608(%rax)
	movq	464(%rdx), %rcx
	movq	%rcx, 1616(%rax)
	movq	472(%rdx), %rcx
	movq	%rcx, 1624(%rax)
	movq	480(%rdx), %rcx
	movq	%rcx, 1632(%rax)
	movq	488(%rdx), %rcx
	movq	%rcx, 1640(%rax)
	movq	496(%rdx), %rcx
	movq	%rcx, 1648(%rax)
	movq	504(%rdx), %rcx
	movq	%rcx, 1656(%rax)
	movq	512(%rdx), %rcx
	movq	%rcx, 1664(%rax)
	movq	520(%rdx), %rcx
	movq	%rcx, 1672(%rax)
	movq	528(%rdx), %rcx
	movq	%rcx, 1680(%rax)
	movq	536(%rdx), %rcx
	movq	%rcx, 1688(%rax)
	movq	544(%rdx), %rcx
	movq	%rcx, 1696(%rax)
	movq	552(%rdx), %rcx
	movq	%rcx, 1704(%rax)
	movq	560(%rdx), %rcx
	movq	%rcx, 1712(%rax)
	movq	568(%rdx), %rcx
	movq	%rcx, 1720(%rax)
	movq	576(%rdx), %rcx
	movq	%rcx, 1728(%rax)
	movq	584(%rdx), %rcx
	movq	%rcx, 1736(%rax)
	movq	592(%rdx), %rcx
	movq	%rcx, 1744(%rax)
	movq	600(%rdx), %rcx
	movq	%rcx, 1752(%rax)
	movq	608(%rdx), %rcx
	movq	%rcx, 1760(%rax)
	movq	616(%rdx), %rcx
	movq	%rcx, 1768(%rax)
	movq	624(%rdx), %rcx
	movq	%rcx, 1776(%rax)
	movq	632(%rdx), %rcx
	movq	%rcx, 1784(%rax)
	movq	640(%rdx), %rcx
	movq	%rcx, 1792(%rax)
	movq	648(%rdx), %rcx
	movq	%rcx, 1800(%rax)
	movq	656(%rdx), %rcx
	movq	%rcx, 1808(%rax)
	movq	664(%rdx), %rcx
	movq	%rcx, 1816(%rax)
	movq	672(%rdx), %rcx
	movq	%rcx, 1824(%rax)
	movq	680(%rdx), %rcx
	movq	%rcx, 1832(%rax)
	movq	688(%rdx), %rcx
	movq	%rcx, 1840(%rax)
	movq	696(%rdx), %rcx
	movq	%rcx, 1848(%rax)
	movq	704(%rdx), %rcx
	movq	%rcx, 1856(%rax)
	movq	712(%rdx), %rcx
	movq	%rcx, 1864(%rax)
	movq	720(%rdx), %rcx
	movq	%rcx, 1872(%rax)
	movq	728(%rdx), %rcx
	movq	%rcx, 1880(%rax)
	movq	736(%rdx), %rcx
	movq	%rcx, 1888(%rax)
	movq	744(%rdx), %rcx
	movq	%rcx, 1896(%rax)
	movq	752(%rdx), %rcx
	movq	%rcx, 1904(%rax)
	movq	760(%rdx), %rcx
	movq	%rcx, 1912(%rax)
	movq	768(%rdx), %rcx
	movq	%rcx, 1920(%rax)
	movq	776(%rdx), %rcx
	movq	%rcx, 1928(%rax)
	movq	784(%rdx), %rcx
	movq	%rcx, 1936(%rax)
	movq	792(%rdx), %rcx
	movq	%rcx, 1944(%rax)
	movq	800(%rdx), %rcx
	movq	%rcx, 1952(%rax)
	movq	808(%rdx), %rcx
	movq	%rcx, 1960(%rax)
	movq	816(%rdx), %rcx
	movq	%rcx, 1968(%rax)
	movq	824(%rdx), %rcx
	movq	%rcx, 1976(%rax)
	movq	832(%rdx), %rcx
	movq	%rcx, 1984(%rax)
	movq	840(%rdx), %rcx
	movq	%rcx, 1992(%rax)
	movq	848(%rdx), %rcx
	movq	%rcx, 2000(%rax)
	movq	856(%rdx), %rcx
	movq	%rcx, 2008(%rax)
	movq	864(%rdx), %rcx
	movq	%rcx, 2016(%rax)
	movq	872(%rdx), %rcx
	movq	%rcx, 2024(%rax)
	movq	880(%rdx), %rcx
	movq	%rcx, 2032(%rax)
	movq	888(%rdx), %rcx
	movq	%rcx, 2040(%rax)
	movq	896(%rdx), %rcx
	movq	%rcx, 2048(%rax)
	movq	904(%rdx), %rcx
	movq	%rcx, 2056(%rax)
	movq	912(%rdx), %rcx
	movq	%rcx, 2064(%rax)
	movq	920(%rdx), %rcx
	movq	%rcx, 2072(%rax)
	movq	928(%rdx), %rcx
	movq	%rcx, 2080(%rax)
	movq	936(%rdx), %rcx
	movq	%rcx, 2088(%rax)
	movq	944(%rdx), %rcx
	movq	%rcx, 2096(%rax)
	movq	952(%rdx), %rcx
	movq	%rcx, 2104(%rax)
	movq	960(%rdx), %rcx
	movq	%rcx, 2112(%rax)
	movq	968(%rdx), %rcx
	movq	%rcx, 2120(%rax)
	movq	976(%rdx), %rcx
	movq	%rcx, 2128(%rax)
	movq	984(%rdx), %rcx
	movq	%rcx, 2136(%rax)
	movq	992(%rdx), %rcx
	movq	%rcx, 2144(%rax)
	movq	1000(%rdx), %rcx
	movq	%rcx, 2152(%rax)
	movq	1008(%rdx), %rcx
	movq	%rcx, 2160(%rax)
	movq	1016(%rdx), %rcx
	movq	%rcx, 2168(%rax)
	movq	1024(%rdx), %rcx
	movq	%rcx, 2176(%rax)
	movq	1032(%rdx), %rcx
	movq	%rcx, 2184(%rax)
	movq	1040(%rdx), %rcx
	movq	%rcx, 2192(%rax)
	movq	1048(%rdx), %rcx
	movq	%rcx, 2200(%rax)
	movq	1056(%rdx), %rcx
	movq	%rcx, 2208(%rax)
	movq	1064(%rdx), %rcx
	movq	%rcx, 2216(%rax)
	movq	1072(%rdx), %rcx
	movq	%rcx, 2224(%rax)
	movq	1080(%rdx), %rcx
	movq	%rcx, 2232(%rax)
	movq	1088(%rdx), %rcx
	movq	%rcx, 2240(%rax)
	movq	1096(%rdx), %rcx
	movq	%rcx, 2248(%rax)
	movq	1104(%rdx), %rcx
	movq	%rcx, 2256(%rax)
	movq	1112(%rdx), %rcx
	movq	%rcx, 2264(%rax)
	movq	1120(%rdx), %rcx
	movq	%rcx, 2272(%rax)
	movq	1128(%rdx), %rcx
	movq	%rcx, 2280(%rax)
	movq	1136(%rdx), %rcx
	movq	%rcx, 2288(%rax)
	movq	1144(%rdx), %rcx
	movq	%rcx, 2296(%rax)
	movq	1152(%rdx), %rcx
	movq	%rcx, 2304(%rax)
	movq	1160(%rdx), %rcx
	movq	%rcx, 2312(%rax)
	movq	1168(%rdx), %rcx
	movq	%rcx, 2320(%rax)
	movq	1176(%rdx), %rcx
	movq	%rcx, 2328(%rax)
	movq	%rax, 9384(%rsp)
	leaq	2336(%rax), %rax
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$1:
	leaq	248(%rsp), %rsp
	movq	9384(%rsp), %rdx
	movq	9376(%rsp), %rcx
	lfence
	movq	$0, %rsi
	movq	32(%rcx), %rax
	movq	%rax, 2368(%rdx)
	movq	40(%rcx), %rax
	movq	%rax, 2376(%rdx)
	movq	48(%rcx), %rax
	movq	%rax, 2384(%rdx)
	movq	56(%rcx), %rax
	movq	%rax, 2392(%rdx)
	xorl	%eax, %eax
	movq	9440(%rsp), %rbx
	movq	9448(%rsp), %rbp
	movq	9456(%rsp), %r12
	movq	9464(%rsp), %r13
	movq	9472(%rsp), %r14
	movq	9480(%rsp), %r15
	movq	9488(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$13824, %rsp
	movq	$13824, %rdi
.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$33:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand$33
	movq	%rsi, %rsp
	lfence
	ret
.L_gen_matrix_avx2$1:
	movq	%rax, 2400(%rsp)
	leaq	256(%rsp), %rax
	movq	$0, %r8
	movq	%rdx, 2408(%rsp)
	movq	%rcx, 2416(%rsp)
	movq	2400(%rsp), %rsi
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$15:
	leaq	856(%rsp), %rsp
	movq	2408(%rsp), %rdx
	movq	2416(%rsp), %rcx
	lfence
	movq	$0, %rsi
	movq	$8, %r8
	movq	%rdx, 2416(%rsp)
	movq	%rcx, 2408(%rsp)
	leaq	2048(%rdx), %rdx
	movq	2400(%rsp), %rsi
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$14:
	leaq	856(%rsp), %rsp
	movq	2416(%rsp), %rdx
	movq	2408(%rsp), %rcx
	lfence
	movq	$0, %rsi
	movq	%rdx, 2408(%rsp)
	leaq	4096(%rdx), %rdx
	movw	$514, %si
	movq	%rdx, 2416(%rsp)
	movq	%rax, 2400(%rsp)
	movw	%si, 2424(%rsp)
	leaq	32(%rsp), %rax
	leaq	2424(%rsp), %rdx
	call	.L_shake128_absorb_A32_A2$1
.L_gen_matrix_avx2$13:
	movq	2400(%rsp), %rcx
	lfence
	movq	$0, %rsi
	orq 	%rsi, %rcx
	leaq	32(%rsp), %rax
	leaq	-16(%rsp), %rsp
	call	.L_shake128_squeeze3blocks$1
.L_gen_matrix_avx2$12:
	leaq	16(%rsp), %rsp
	movq	2416(%rsp), %rdx
	lfence
	movq	$0, %rsi
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_avx2$11:
	leaq	792(%rsp), %rsp
	movq	2408(%rsp), %rdx
	lfence
	movq	$0, %rsi
	movq	%rdx, %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$10:
	leaq	512(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$9:
	leaq	1024(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$8:
	leaq	1536(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$7:
	leaq	2048(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$6:
	leaq	2560(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$5:
	leaq	3072(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$4:
	leaq	3584(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$3:
	leaq	4096(%rdx), %rcx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$2:
	ret
.L_gen_matrix_sample_four_polynomials$1:
	leaq	glob_data + 4560(%rip), %rdi
	shlq	$4, %rsi
	addq	%rsi, %r8
	movq	(%rdi,%r8), %rsi
	movq	%rsi, 832(%rsp)
	movq	%rax, 840(%rsp)
	movq	%rdx, 848(%rsp)
	leaq	32(%rsp), %rax
	leaq	832(%rsp), %rdx
	leaq	-8(%rsp), %rsp
	call	.L_shake128x4_absorb_A32_A2$1
.L_gen_matrix_sample_four_polynomials$7:
	leaq	8(%rsp), %rsp
	movq	840(%rsp), %rcx
	lfence
	movq	$0, %rsi
	call	.L_shake128x4_squeeze3blocks$1
.L_gen_matrix_sample_four_polynomials$6:
	movq	848(%rsp), %rdx
	lfence
	movq	$0, %rsi
	movq	%rcx, 848(%rsp)
	movq	%rdx, 840(%rsp)
	movq	%rcx, %r8
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$5:
	leaq	792(%rsp), %rsp
	movq	848(%rsp), %rax
	movq	840(%rsp), %rdx
	orq 	%rsi, %rax
	orq 	%rsi, %rdx
	movq	%rax, 840(%rsp)
	movq	%rdx, 848(%rsp)
	leaq	536(%rax), %r8
	leaq	512(%rdx), %rdx
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$4:
	leaq	792(%rsp), %rsp
	movq	840(%rsp), %rax
	movq	848(%rsp), %rdx
	orq 	%rsi, %rax
	orq 	%rsi, %rdx
	movq	%rax, 848(%rsp)
	movq	%rdx, 840(%rsp)
	leaq	1072(%rax), %r8
	leaq	1024(%rdx), %rdx
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$3:
	leaq	792(%rsp), %rsp
	movq	848(%rsp), %rax
	movq	840(%rsp), %rdx
	orq 	%rsi, %rax
	orq 	%rsi, %rdx
	movq	%rax, 840(%rsp)
	movq	%rdx, 848(%rsp)
	leaq	1608(%rax), %r8
	leaq	1536(%rdx), %rdx
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$2:
	leaq	792(%rsp), %rsp
	movq	840(%rsp), %rax
	movq	848(%rsp), %rdx
	orq 	%rsi, %rax
	orq 	%rsi, %rdx
	ret
.L__gen_matrix_fill_polynomial$1:
	movq	%rdx, 768(%rsp)
	leaq	32(%rsp), %rax
	movq	$0, %rdi
	movq	$0, %rdx
	call	.L_gen_matrix_buf_rejection$1
.L__gen_matrix_fill_polynomial$6:
	jmp 	.L__gen_matrix_fill_polynomial$2
.L__gen_matrix_fill_polynomial$3:
	movq	%rax, 776(%rsp)
	movq	%r9, 784(%rsp)
	leaq	-8(%rsp), %rsp
	call	.L_shake128_next_state$1
.L__gen_matrix_fill_polynomial$5:
	leaq	8(%rsp), %rsp
	movq	776(%rsp), %rax
	movq	784(%rsp), %rdi
	lfence
	movq	$0, %rsi
	movq	$336, %rdx
	call	.L_gen_matrix_buf_rejection$1
.L__gen_matrix_fill_polynomial$4:
.L__gen_matrix_fill_polynomial$2:
	cmpq	$256, %r9
	jb  	.L__gen_matrix_fill_polynomial$3
	movq	$-1, %rcx
	cmovb	%rcx, %rsi
	movq	768(%rsp), %rdx
	orq 	%rsi, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdx)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	160(%rax), %ymm0
	vmovdqu	%ymm0, 160(%rdx)
	vmovdqu	192(%rax), %ymm0
	vmovdqu	%ymm0, 192(%rdx)
	vmovdqu	224(%rax), %ymm0
	vmovdqu	%ymm0, 224(%rdx)
	vmovdqu	256(%rax), %ymm0
	vmovdqu	%ymm0, 256(%rdx)
	vmovdqu	288(%rax), %ymm0
	vmovdqu	%ymm0, 288(%rdx)
	vmovdqu	320(%rax), %ymm0
	vmovdqu	%ymm0, 320(%rdx)
	vmovdqu	352(%rax), %ymm0
	vmovdqu	%ymm0, 352(%rdx)
	vmovdqu	384(%rax), %ymm0
	vmovdqu	%ymm0, 384(%rdx)
	vmovdqu	416(%rax), %ymm0
	vmovdqu	%ymm0, 416(%rdx)
	vmovdqu	448(%rax), %ymm0
	vmovdqu	%ymm0, 448(%rdx)
	vmovdqu	480(%rax), %ymm0
	vmovdqu	%ymm0, 480(%rdx)
	ret
.L_gen_matrix_buf_rejection$1:
	vmovdqu	glob_data + 96(%rip), %ymm0
	vmovdqu	glob_data + 32(%rip), %ymm3
	vmovdqu	glob_data + 0(%rip), %ymm1
	vmovdqu	glob_data + 64(%rip), %ymm2
	leaq	glob_data + 2272(%rip), %rcx
	jmp 	.L_gen_matrix_buf_rejection$2
.L_gen_matrix_buf_rejection$3:
	movq	$-1, %r9
	cmovnb	%r9, %rsi
	vpermq	$148, (%r8,%rdx), %ymm4
	vpermq	$148, 24(%r8,%rdx), %ymm5
	vpshufb	%ymm0, %ymm4, %ymm4
	vpshufb	%ymm0, %ymm5, %ymm5
	vpsrlw	$4, %ymm4, %ymm6
	vpsrlw	$4, %ymm5, %ymm7
	vpblendw	$170, %ymm6, %ymm4, %ymm4
	vpblendw	$170, %ymm7, %ymm5, %ymm5
	vpand	%ymm3, %ymm4, %ymm4
	vpand	%ymm3, %ymm5, %ymm5
	vpcmpgtw	%ymm4, %ymm1, %ymm6
	vpcmpgtw	%ymm5, %ymm1, %ymm7
	vpacksswb	%ymm7, %ymm6, %ymm6
	vpmovmskb	%ymm6, %r9d
// declassify_val u64 %r9
	orq 	%rsi, %r9
	movq	%r9, %r10
	andq	$255, %r10
	vmovq	(%rcx,%r10,8), %xmm6
	popcnt	%r10, %r10
	addq	%rdi, %r10
	movq	%r9, %r11
	shrq	$16, %r11
	andq	$255, %r11
	vmovq	(%rcx,%r11,8), %xmm7
	popcnt	%r11, %r11
	addq	%r10, %r11
	movq	%r9, %rbx
	shrq	$8, %rbx
	andq	$255, %rbx
	vmovq	(%rcx,%rbx,8), %xmm8
	popcnt	%rbx, %rbx
	addq	%r11, %rbx
	shrq	$24, %r9
	andq	$255, %r9
	vmovq	(%rcx,%r9,8), %xmm9
	popcnt	%r9, %r9
	addq	%rbx, %r9
	vinserti128	$1, %xmm7, %ymm6, %ymm6
	vinserti128	$1, %xmm9, %ymm8, %ymm8
	vpaddb	%ymm2, %ymm6, %ymm7
	vpunpcklbw	%ymm7, %ymm6, %ymm6
	vpaddb	%ymm2, %ymm8, %ymm7
	vpunpcklbw	%ymm7, %ymm8, %ymm8
	vpshufb	%ymm6, %ymm4, %ymm4
	vpshufb	%ymm8, %ymm5, %ymm5
	vmovdqu	%xmm4, (%rax,%rdi,2)
	vextracti128	$1, %ymm4, (%rax,%r10,2)
	vmovdqu	%xmm5, (%rax,%r11,2)
	vextracti128	$1, %ymm5, (%rax,%rbx,2)
	movq	%r9, %rdi
	addq	$48, %rdx
.L_gen_matrix_buf_rejection$2:
	cmpq	$480, %rdx
	jb  	.L_gen_matrix_buf_rejection$3
	movq	$-1, %r9
	cmovb	%r9, %rsi
	vpermq	$148, (%r8,%rdx), %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm6
	vpblendw	$170, %ymm6, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpcmpgtw	%ymm4, %ymm1, %ymm6
	vpxor	%ymm7, %ymm7, %ymm7
	vpacksswb	%ymm7, %ymm6, %ymm6
	vpmovmskb	%ymm6, %r9d
// declassify_val u64 %r9
	orq 	%rsi, %r9
	movq	%r9, %r10
	andq	$255, %r10
	vmovq	(%rcx,%r10,8), %xmm6
	popcnt	%r10, %r10
	addq	%rdi, %r10
	shrq	$16, %r9
	andq	$255, %r9
	vmovq	(%rcx,%r9,8), %xmm7
	popcnt	%r9, %r9
	addq	%r10, %r9
	vinserti128	$1, %xmm7, %ymm6, %ymm6
	vpaddb	%ymm2, %ymm6, %ymm7
	vpunpcklbw	%ymm7, %ymm6, %ymm6
	vpshufb	%ymm6, %ymm4, %ymm4
	vmovdqu	%xmm4, (%rax,%rdi,2)
	vextracti128	$1, %ymm4, (%rax,%r10,2)
	ret
.L_i_poly_decompress_dv4$1:
	leaq	glob_data + 608(%rip), %r8
	vmovdqu	(%r8), %ymm0
	leaq	glob_data + 192(%rip), %r8
	vmovdqu	(%r8), %ymm1
	vpbroadcastd	glob_data + 4608(%rip), %ymm3
	vpbroadcastd	glob_data + 4604(%rip), %ymm2
	vmovq	(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, (%rdi)
	vmovq	8(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 32(%rdi)
	vmovq	16(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 64(%rdi)
	vmovq	24(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 96(%rdi)
	vmovq	32(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 128(%rdi)
	vmovq	40(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 160(%rdi)
	vmovq	48(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 192(%rdi)
	vmovq	56(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 224(%rdi)
	vmovq	64(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 256(%rdi)
	vmovq	72(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 288(%rdi)
	vmovq	80(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 320(%rdi)
	vmovq	88(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 352(%rdi)
	vmovq	96(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 384(%rdi)
	vmovq	104(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 416(%rdi)
	vmovq	112(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm4
	vpmullw	%ymm2, %ymm4, %ymm4
	vpmulhrsw	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm4, 448(%rdi)
	vmovq	120(%rdx), %xmm4
	vmovdqu	%xmm4, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpand	%ymm3, %ymm4, %ymm3
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmulhrsw	%ymm0, %ymm3, %ymm3
	vmovdqu	%ymm3, 480(%rdi)
	ret
.L_i_poly_compress_dv4$1:
	call	.L_poly_csubq$1
.L_i_poly_compress_dv4$2:
	leaq	glob_data + 544(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	vpbroadcastw	glob_data + 4636(%rip), %ymm3
	vpbroadcastw	glob_data + 4634(%rip), %ymm4
	vpbroadcastw	glob_data + 4632(%rip), %ymm5
	vmovdqu	glob_data + 224(%rip), %ymm1
	vmovdqu	(%rsi), %ymm8
	vmovdqu	32(%rsi), %ymm9
	vmovdqu	64(%rsi), %ymm10
	vmovdqu	96(%rsi), %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm2, %ymm2
	vpand	%ymm4, %ymm8, %ymm8
	vpand	%ymm4, %ymm9, %ymm9
	vpand	%ymm4, %ymm10, %ymm10
	vpand	%ymm4, %ymm2, %ymm2
	vpackuswb	%ymm9, %ymm8, %ymm8
	vpackuswb	%ymm2, %ymm10, %ymm10
	vpmaddubsw	%ymm5, %ymm8, %ymm8
	vpmaddubsw	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm8, %ymm8
	vpermd	%ymm8, %ymm1, %ymm8
	vmovdqu	%ymm8, (%rcx)
	vmovdqu	128(%rsi), %ymm8
	vmovdqu	160(%rsi), %ymm9
	vmovdqu	192(%rsi), %ymm10
	vmovdqu	224(%rsi), %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm2, %ymm2
	vpand	%ymm4, %ymm8, %ymm8
	vpand	%ymm4, %ymm9, %ymm9
	vpand	%ymm4, %ymm10, %ymm10
	vpand	%ymm4, %ymm2, %ymm2
	vpackuswb	%ymm9, %ymm8, %ymm8
	vpackuswb	%ymm2, %ymm10, %ymm10
	vpmaddubsw	%ymm5, %ymm8, %ymm8
	vpmaddubsw	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm8, %ymm8
	vpermd	%ymm8, %ymm1, %ymm8
	vmovdqu	%ymm8, 32(%rcx)
	vmovdqu	256(%rsi), %ymm8
	vmovdqu	288(%rsi), %ymm9
	vmovdqu	320(%rsi), %ymm10
	vmovdqu	352(%rsi), %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm2, %ymm2
	vpand	%ymm4, %ymm8, %ymm8
	vpand	%ymm4, %ymm9, %ymm9
	vpand	%ymm4, %ymm10, %ymm10
	vpand	%ymm4, %ymm2, %ymm2
	vpackuswb	%ymm9, %ymm8, %ymm8
	vpackuswb	%ymm2, %ymm10, %ymm10
	vpmaddubsw	%ymm5, %ymm8, %ymm8
	vpmaddubsw	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm8, %ymm8
	vpermd	%ymm8, %ymm1, %ymm8
	vmovdqu	%ymm8, 64(%rcx)
	vmovdqu	384(%rsi), %ymm8
	vmovdqu	416(%rsi), %ymm9
	vmovdqu	448(%rsi), %ymm10
	vmovdqu	480(%rsi), %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhrsw	%ymm3, %ymm8, %ymm8
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm2, %ymm2
	vpand	%ymm4, %ymm8, %ymm8
	vpand	%ymm4, %ymm9, %ymm9
	vpand	%ymm4, %ymm10, %ymm10
	vpand	%ymm4, %ymm2, %ymm2
	vpackuswb	%ymm9, %ymm8, %ymm4
	vpackuswb	%ymm2, %ymm10, %ymm10
	vpmaddubsw	%ymm5, %ymm4, %ymm4
	vpmaddubsw	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm4, %ymm4
	vpermd	%ymm4, %ymm1, %ymm4
	vmovdqu	%ymm4, 96(%rcx)
	ret
.L_i_poly_tomsg$1:
	call	.L_poly_csubq$1
.L_i_poly_tomsg$2:
	leaq	glob_data + 384(%rip), %rdx
	vmovdqu	(%rdx), %ymm0
	leaq	glob_data + 352(%rip), %rdx
	vmovdqu	(%rdx), %ymm1
	vmovdqu	(%rsi), %ymm4
	vmovdqu	32(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, (%rcx)
	vmovdqu	64(%rsi), %ymm4
	vmovdqu	96(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 4(%rcx)
	vmovdqu	128(%rsi), %ymm4
	vmovdqu	160(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 8(%rcx)
	vmovdqu	192(%rsi), %ymm4
	vmovdqu	224(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 12(%rcx)
	vmovdqu	256(%rsi), %ymm4
	vmovdqu	288(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 16(%rcx)
	vmovdqu	320(%rsi), %ymm4
	vmovdqu	352(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 20(%rcx)
	vmovdqu	384(%rsi), %ymm4
	vmovdqu	416(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 24(%rcx)
	vmovdqu	448(%rsi), %ymm4
	vmovdqu	480(%rsi), %ymm5
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm5, %ymm0, %ymm5
	vpsraw	$15, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm7
	vpxor	%ymm6, %ymm4, %ymm4
	vpxor	%ymm7, %ymm5, %ymm5
	vpsubw	%ymm1, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm5, %ymm5
	vpacksswb	%ymm5, %ymm4, %ymm4
	vpermq	$216, %ymm4, %ymm4
	vpmovmskb	%ymm4, %edx
	movl	%edx, 28(%rcx)
	ret
.L_i_poly_tobytes$1:
	call	.L_poly_csubq$1
.L_i_poly_tobytes$2:
	vmovdqu	(%rsi), %ymm6
	vmovdqu	32(%rsi), %ymm11
	vmovdqu	64(%rsi), %ymm8
	vmovdqu	96(%rsi), %ymm9
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm7
	vmovdqu	192(%rsi), %ymm2
	vmovdqu	224(%rsi), %ymm5
	vpsllw	$12, %ymm11, %ymm0
	vpor	%ymm6, %ymm0, %ymm3
	vpsrlw	$4, %ymm11, %ymm6
	vpsllw	$8, %ymm8, %ymm11
	vpor	%ymm11, %ymm6, %ymm6
	vpsrlw	$8, %ymm8, %ymm11
	vpsllw	$4, %ymm9, %ymm8
	vpor	%ymm8, %ymm11, %ymm4
	vpsllw	$12, %ymm7, %ymm8
	vpor	%ymm1, %ymm8, %ymm1
	vpsrlw	$4, %ymm7, %ymm9
	vpsllw	$8, %ymm2, %ymm11
	vpor	%ymm11, %ymm9, %ymm8
	vpsrlw	$8, %ymm2, %ymm11
	vpsllw	$4, %ymm5, %ymm7
	vpor	%ymm7, %ymm11, %ymm2
	vpslld	$16, %ymm6, %ymm13
	vpblendw	$170, %ymm13, %ymm3, %ymm5
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm6, %ymm3, %ymm3
	vpslld	$16, %ymm1, %ymm6
	vpblendw	$170, %ymm6, %ymm4, %ymm6
	vpsrld	$16, %ymm4, %ymm7
	vpblendw	$170, %ymm1, %ymm7, %ymm1
	vpslld	$16, %ymm2, %ymm13
	vpblendw	$170, %ymm13, %ymm8, %ymm7
	vpsrld	$16, %ymm8, %ymm11
	vpblendw	$170, %ymm2, %ymm11, %ymm2
	vmovsldup	%ymm6, %ymm13
	vpblendd	$170, %ymm13, %ymm5, %ymm4
	vpsrlq	$32, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm5
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm3, %ymm7, %ymm3
	vmovsldup	%ymm2, %ymm13
	vpblendd	$170, %ymm13, %ymm1, %ymm7
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpunpcklqdq	%ymm6, %ymm4, %ymm2
	vpunpckhqdq	%ymm6, %ymm4, %ymm0
	vpunpcklqdq	%ymm5, %ymm7, %ymm6
	vpunpckhqdq	%ymm5, %ymm7, %ymm4
	vpunpcklqdq	%ymm1, %ymm3, %ymm5
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vperm2i128	$32, %ymm6, %ymm2, %ymm13
	vperm2i128	$49, %ymm6, %ymm2, %ymm9
	vperm2i128	$32, %ymm0, %ymm5, %ymm8
	vperm2i128	$49, %ymm0, %ymm5, %ymm0
	vperm2i128	$32, %ymm1, %ymm4, %ymm3
	vperm2i128	$49, %ymm1, %ymm4, %ymm1
	vmovdqu	%ymm13, (%rcx)
	vmovdqu	%ymm8, 32(%rcx)
	vmovdqu	%ymm3, 64(%rcx)
	vmovdqu	%ymm9, 96(%rcx)
	vmovdqu	%ymm0, 128(%rcx)
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	256(%rsi), %ymm6
	vmovdqu	288(%rsi), %ymm11
	vmovdqu	320(%rsi), %ymm8
	vmovdqu	352(%rsi), %ymm9
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	448(%rsi), %ymm2
	vmovdqu	480(%rsi), %ymm5
	vpsllw	$12, %ymm11, %ymm0
	vpor	%ymm6, %ymm0, %ymm3
	vpsrlw	$4, %ymm11, %ymm6
	vpsllw	$8, %ymm8, %ymm11
	vpor	%ymm11, %ymm6, %ymm6
	vpsrlw	$8, %ymm8, %ymm11
	vpsllw	$4, %ymm9, %ymm8
	vpor	%ymm8, %ymm11, %ymm4
	vpsllw	$12, %ymm7, %ymm8
	vpor	%ymm1, %ymm8, %ymm1
	vpsrlw	$4, %ymm7, %ymm9
	vpsllw	$8, %ymm2, %ymm11
	vpor	%ymm11, %ymm9, %ymm8
	vpsrlw	$8, %ymm2, %ymm11
	vpsllw	$4, %ymm5, %ymm7
	vpor	%ymm7, %ymm11, %ymm2
	vpslld	$16, %ymm6, %ymm13
	vpblendw	$170, %ymm13, %ymm3, %ymm5
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm6, %ymm3, %ymm3
	vpslld	$16, %ymm1, %ymm6
	vpblendw	$170, %ymm6, %ymm4, %ymm6
	vpsrld	$16, %ymm4, %ymm7
	vpblendw	$170, %ymm1, %ymm7, %ymm1
	vpslld	$16, %ymm2, %ymm13
	vpblendw	$170, %ymm13, %ymm8, %ymm7
	vpsrld	$16, %ymm8, %ymm11
	vpblendw	$170, %ymm2, %ymm11, %ymm2
	vmovsldup	%ymm6, %ymm13
	vpblendd	$170, %ymm13, %ymm5, %ymm4
	vpsrlq	$32, %ymm5, %ymm5
	vpblendd	$170, %ymm6, %ymm5, %ymm5
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm3, %ymm7, %ymm3
	vmovsldup	%ymm2, %ymm13
	vpblendd	$170, %ymm13, %ymm1, %ymm7
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vpunpcklqdq	%ymm6, %ymm4, %ymm2
	vpunpckhqdq	%ymm6, %ymm4, %ymm6
	vpunpcklqdq	%ymm5, %ymm7, %ymm8
	vpunpckhqdq	%ymm5, %ymm7, %ymm4
	vpunpcklqdq	%ymm1, %ymm3, %ymm5
	vpunpckhqdq	%ymm1, %ymm3, %ymm1
	vperm2i128	$32, %ymm8, %ymm2, %ymm13
	vperm2i128	$49, %ymm8, %ymm2, %ymm9
	vperm2i128	$32, %ymm6, %ymm5, %ymm8
	vperm2i128	$49, %ymm6, %ymm5, %ymm0
	vperm2i128	$32, %ymm1, %ymm4, %ymm3
	vperm2i128	$49, %ymm1, %ymm4, %ymm1
	vmovdqu	%ymm13, 192(%rcx)
	vmovdqu	%ymm8, 224(%rcx)
	vmovdqu	%ymm3, 256(%rcx)
	vmovdqu	%ymm9, 288(%rcx)
	vmovdqu	%ymm0, 320(%rcx)
	vmovdqu	%ymm1, 352(%rcx)
	ret
.L_poly_sub$1:
	vmovdqu	(%rsi), %ymm1
	vmovdqu	(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, (%rdx)
	vmovdqu	32(%rsi), %ymm1
	vmovdqu	32(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 32(%rdx)
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	64(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 64(%rdx)
	vmovdqu	96(%rsi), %ymm1
	vmovdqu	96(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 96(%rdx)
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	128(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rdx)
	vmovdqu	160(%rsi), %ymm1
	vmovdqu	160(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rdx)
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	192(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rdx)
	vmovdqu	224(%rsi), %ymm1
	vmovdqu	224(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rdx)
	vmovdqu	256(%rsi), %ymm1
	vmovdqu	256(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rdx)
	vmovdqu	288(%rsi), %ymm1
	vmovdqu	288(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rdx)
	vmovdqu	320(%rsi), %ymm1
	vmovdqu	320(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rdx)
	vmovdqu	352(%rsi), %ymm1
	vmovdqu	352(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 352(%rdx)
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	384(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 384(%rdx)
	vmovdqu	416(%rsi), %ymm1
	vmovdqu	416(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rdx)
	vmovdqu	448(%rsi), %ymm1
	vmovdqu	448(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 448(%rdx)
	vmovdqu	480(%rsi), %ymm1
	vmovdqu	480(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rdx)
	ret
.L_poly_ntt$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vpbroadcastd	glob_data + 1440(%rip), %ymm2
	vpbroadcastd	glob_data + 1444(%rip), %ymm4
	vmovdqu	(%rdx), %ymm9
	vmovdqu	32(%rdx), %ymm14
	vmovdqu	64(%rdx), %ymm1
	vmovdqu	96(%rdx), %ymm5
	vmovdqu	256(%rdx), %ymm8
	vmovdqu	288(%rdx), %ymm7
	vmovdqu	320(%rdx), %ymm10
	vmovdqu	352(%rdx), %ymm6
	vpmullw	%ymm8, %ymm2, %ymm13
	vpmulhw	%ymm8, %ymm4, %ymm3
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm15
	vpmullw	%ymm10, %ymm2, %ymm11
	vpmulhw	%ymm10, %ymm4, %ymm7
	vpmullw	%ymm6, %ymm2, %ymm12
	vpmulhw	%ymm6, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm13, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm12, %ymm12
	vpsubw	%ymm15, %ymm14, %ymm13
	vpaddw	%ymm14, %ymm15, %ymm14
	vpsubw	%ymm3, %ymm9, %ymm15
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm10, %ymm5, %ymm3
	vpaddw	%ymm5, %ymm10, %ymm5
	vpsubw	%ymm7, %ymm1, %ymm10
	vpaddw	%ymm1, %ymm7, %ymm1
	vpaddw	%ymm15, %ymm6, %ymm7
	vpsubw	%ymm6, %ymm9, %ymm6
	vpaddw	%ymm13, %ymm8, %ymm9
	vpsubw	%ymm8, %ymm14, %ymm8
	vpaddw	%ymm10, %ymm11, %ymm10
	vpsubw	%ymm11, %ymm1, %ymm1
	vpaddw	%ymm3, %ymm12, %ymm3
	vpsubw	%ymm12, %ymm5, %ymm5
	vmovdqu	%ymm6, (%rdx)
	vmovdqu	%ymm8, 32(%rdx)
	vmovdqu	%ymm1, 64(%rdx)
	vmovdqu	%ymm5, 96(%rdx)
	vmovdqu	%ymm7, 256(%rdx)
	vmovdqu	%ymm9, 288(%rdx)
	vmovdqu	%ymm10, 320(%rdx)
	vmovdqu	%ymm3, 352(%rdx)
	vmovdqu	128(%rdx), %ymm9
	vmovdqu	160(%rdx), %ymm6
	vmovdqu	192(%rdx), %ymm1
	vmovdqu	224(%rdx), %ymm5
	vmovdqu	384(%rdx), %ymm8
	vmovdqu	416(%rdx), %ymm7
	vmovdqu	448(%rdx), %ymm10
	vmovdqu	480(%rdx), %ymm13
	vpmullw	%ymm8, %ymm2, %ymm15
	vpmulhw	%ymm8, %ymm4, %ymm3
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm14
	vpmullw	%ymm10, %ymm2, %ymm11
	vpmulhw	%ymm10, %ymm4, %ymm7
	vpmullw	%ymm13, %ymm2, %ymm12
	vpmulhw	%ymm13, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm12, %ymm4
	vpsubw	%ymm14, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm14, %ymm6
	vpsubw	%ymm3, %ymm9, %ymm15
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm10, %ymm5, %ymm3
	vpaddw	%ymm5, %ymm10, %ymm5
	vpsubw	%ymm7, %ymm1, %ymm10
	vpaddw	%ymm1, %ymm7, %ymm1
	vpaddw	%ymm15, %ymm2, %ymm7
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm8
	vpaddw	%ymm10, %ymm11, %ymm6
	vpsubw	%ymm11, %ymm1, %ymm10
	vpaddw	%ymm3, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm5, %ymm13
	vmovdqu	%ymm7, 384(%rdx)
	vmovdqu	%ymm2, 416(%rdx)
	vmovdqu	%ymm6, 448(%rdx)
	vmovdqu	%ymm3, 480(%rdx)
	vpbroadcastd	glob_data + 1448(%rip), %ymm2
	vpbroadcastd	glob_data + 1452(%rip), %ymm5
	vmovdqu	%ymm9, %ymm11
	vmovdqu	%ymm8, %ymm7
	vmovdqu	(%rdx), %ymm9
	vmovdqu	32(%rdx), %ymm6
	vmovdqu	64(%rdx), %ymm12
	vmovdqu	96(%rdx), %ymm4
	vpmullw	%ymm11, %ymm2, %ymm15
	vpmulhw	%ymm11, %ymm5, %ymm3
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm14
	vpmullw	%ymm10, %ymm2, %ymm1
	vpmulhw	%ymm10, %ymm5, %ymm7
	vpmullw	%ymm13, %ymm2, %ymm2
	vpmulhw	%ymm13, %ymm5, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm14, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm14, %ymm6
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm10, %ymm4, %ymm3
	vpaddw	%ymm4, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm12, %ymm5
	vpaddw	%ymm12, %ymm7, %ymm12
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm10
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm1, %ymm5
	vpsubw	%ymm1, %ymm12, %ymm8
	vpaddw	%ymm3, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm4, %ymm3
	vmovdqu	glob_data + 1456(%rip), %ymm2
	vmovdqu	glob_data + 1488(%rip), %ymm4
	vperm2i128	$32, %ymm7, %ymm11, %ymm9
	vperm2i128	$49, %ymm7, %ymm11, %ymm11
	vperm2i128	$32, %ymm10, %ymm6, %ymm12
	vperm2i128	$49, %ymm10, %ymm6, %ymm7
	vperm2i128	$32, %ymm5, %ymm8, %ymm6
	vperm2i128	$49, %ymm5, %ymm8, %ymm14
	vperm2i128	$32, %ymm1, %ymm3, %ymm10
	vperm2i128	$49, %ymm1, %ymm3, %ymm13
	vpmullw	%ymm6, %ymm2, %ymm15
	vpmulhw	%ymm6, %ymm4, %ymm5
	vpmullw	%ymm14, %ymm2, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmullw	%ymm10, %ymm2, %ymm3
	vpmulhw	%ymm10, %ymm4, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm6
	vpmulhw	%ymm13, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm6, %ymm4
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm12, %ymm3
	vpaddw	%ymm5, %ymm4, %ymm13
	vpsubw	%ymm4, %ymm7, %ymm7
	vmovdqu	glob_data + 1520(%rip), %ymm5
	vmovdqu	glob_data + 1552(%rip), %ymm10
	vpunpcklqdq	%ymm1, %ymm11, %ymm9
	vpunpckhqdq	%ymm1, %ymm11, %ymm11
	vpunpcklqdq	%ymm2, %ymm6, %ymm12
	vpunpckhqdq	%ymm2, %ymm6, %ymm4
	vpunpcklqdq	%ymm8, %ymm3, %ymm15
	vpunpckhqdq	%ymm8, %ymm3, %ymm14
	vpunpcklqdq	%ymm13, %ymm7, %ymm2
	vpunpckhqdq	%ymm13, %ymm7, %ymm13
	vpmullw	%ymm15, %ymm5, %ymm6
	vpmulhw	%ymm15, %ymm10, %ymm3
	vpmullw	%ymm14, %ymm5, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmullw	%ymm2, %ymm5, %ymm1
	vpmulhw	%ymm2, %ymm10, %ymm7
	vpmullw	%ymm13, %ymm5, %ymm2
	vpmulhw	%ymm13, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm6, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm10, %ymm4, %ymm3
	vpaddw	%ymm4, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm12, %ymm5
	vpaddw	%ymm12, %ymm7, %ymm12
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm10
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm1, %ymm5
	vpsubw	%ymm1, %ymm12, %ymm8
	vpaddw	%ymm3, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm4, %ymm3
	vmovdqu	glob_data + 1584(%rip), %ymm2
	vmovdqu	glob_data + 1616(%rip), %ymm4
	vmovsldup	%ymm7, %ymm13
	vpblendd	$170, %ymm13, %ymm11, %ymm9
	vpsrlq	$32, %ymm11, %ymm11
	vpblendd	$170, %ymm7, %ymm11, %ymm11
	vmovsldup	%ymm10, %ymm13
	vpblendd	$170, %ymm13, %ymm6, %ymm12
	vpsrlq	$32, %ymm6, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm7
	vmovsldup	%ymm5, %ymm6
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm14
	vmovsldup	%ymm1, %ymm13
	vpblendd	$170, %ymm13, %ymm3, %ymm10
	vpsrlq	$32, %ymm3, %ymm3
	vpblendd	$170, %ymm1, %ymm3, %ymm13
	vpmullw	%ymm6, %ymm2, %ymm15
	vpmulhw	%ymm6, %ymm4, %ymm5
	vpmullw	%ymm14, %ymm2, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmullw	%ymm10, %ymm2, %ymm3
	vpmulhw	%ymm10, %ymm4, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm6
	vpmulhw	%ymm13, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm6, %ymm4
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm12, %ymm3
	vpaddw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm4, %ymm7, %ymm13
	vmovdqu	glob_data + 1648(%rip), %ymm4
	vmovdqu	glob_data + 1680(%rip), %ymm10
	vpslld	$16, %ymm1, %ymm15
	vpblendw	$170, %ymm15, %ymm11, %ymm9
	vpsrld	$16, %ymm11, %ymm7
	vpblendw	$170, %ymm1, %ymm7, %ymm11
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm6, %ymm12
	vpsrld	$16, %ymm6, %ymm7
	vpblendw	$170, %ymm2, %ymm7, %ymm7
	vpslld	$16, %ymm8, %ymm2
	vpblendw	$170, %ymm2, %ymm3, %ymm15
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm14
	vpslld	$16, %ymm5, %ymm2
	vpblendw	$170, %ymm2, %ymm13, %ymm1
	vpsrld	$16, %ymm13, %ymm3
	vpblendw	$170, %ymm5, %ymm3, %ymm6
	vpmullw	%ymm15, %ymm4, %ymm2
	vpmulhw	%ymm15, %ymm10, %ymm5
	vpmullw	%ymm14, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmullw	%ymm1, %ymm4, %ymm3
	vpmulhw	%ymm1, %ymm10, %ymm1
	vpmullw	%ymm6, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm12, %ymm8
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm7, %ymm7
	vmovdqu	glob_data + 1712(%rip), %ymm11
	vmovdqu	glob_data + 1744(%rip), %ymm13
	vmovdqu	glob_data + 1776(%rip), %ymm4
	vmovdqu	glob_data + 1808(%rip), %ymm12
	vpmullw	%ymm8, %ymm11, %ymm15
	vpmulhw	%ymm8, %ymm13, %ymm5
	vpmullw	%ymm7, %ymm11, %ymm8
	vpmulhw	%ymm7, %ymm13, %ymm14
	vpmullw	%ymm10, %ymm4, %ymm11
	vpmulhw	%ymm10, %ymm12, %ymm7
	vpmullw	%ymm3, %ymm4, %ymm4
	vpmulhw	%ymm3, %ymm12, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm14, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm2, %ymm5
	vpaddw	%ymm2, %ymm10, %ymm2
	vpsubw	%ymm7, %ymm1, %ymm10
	vpaddw	%ymm1, %ymm7, %ymm1
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm11
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm2, %ymm5
	vmovdqu	glob_data + 544(%rip), %ymm2
	vpmulhw	%ymm2, %ymm9, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm9, %ymm9
	vpmulhw	%ymm2, %ymm6, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm6, %ymm4
	vpmulhw	%ymm2, %ymm1, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm5, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm5, %ymm6
	vpmulhw	%ymm2, %ymm7, %ymm5
	vpsraw	$10, %ymm5, %ymm5
	vpmullw	%ymm0, %ymm5, %ymm5
	vpsubw	%ymm5, %ymm7, %ymm5
	vpmulhw	%ymm2, %ymm11, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm11, %ymm7
	vpmulhw	%ymm2, %ymm8, %ymm10
	vpsraw	$10, %ymm10, %ymm10
	vpmullw	%ymm0, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm8, %ymm13
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm9, (%rdx)
	vmovdqu	%ymm4, 32(%rdx)
	vmovdqu	%ymm5, 64(%rdx)
	vmovdqu	%ymm7, 96(%rdx)
	vmovdqu	%ymm1, 128(%rdx)
	vmovdqu	%ymm6, 160(%rdx)
	vmovdqu	%ymm13, 192(%rdx)
	vmovdqu	%ymm3, 224(%rdx)
	vpbroadcastd	glob_data + 1840(%rip), %ymm2
	vpbroadcastd	glob_data + 1844(%rip), %ymm5
	vmovdqu	384(%rdx), %ymm8
	vmovdqu	416(%rdx), %ymm7
	vmovdqu	448(%rdx), %ymm11
	vmovdqu	480(%rdx), %ymm13
	vmovdqu	256(%rdx), %ymm9
	vmovdqu	288(%rdx), %ymm6
	vmovdqu	320(%rdx), %ymm12
	vmovdqu	352(%rdx), %ymm4
	vpmullw	%ymm8, %ymm2, %ymm15
	vpmulhw	%ymm8, %ymm5, %ymm3
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm10
	vpmullw	%ymm11, %ymm2, %ymm1
	vpmulhw	%ymm11, %ymm5, %ymm7
	vpmullw	%ymm13, %ymm2, %ymm2
	vpmulhw	%ymm13, %ymm5, %ymm5
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm10, %ymm10
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm5, %ymm4, %ymm3
	vpaddw	%ymm4, %ymm5, %ymm4
	vpsubw	%ymm7, %ymm12, %ymm5
	vpaddw	%ymm12, %ymm7, %ymm12
	vpaddw	%ymm11, %ymm15, %ymm6
	vpsubw	%ymm15, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm7
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm5, %ymm1, %ymm5
	vpsubw	%ymm1, %ymm12, %ymm1
	vpaddw	%ymm3, %ymm2, %ymm3
	vpsubw	%ymm2, %ymm4, %ymm13
	vmovdqu	glob_data + 1848(%rip), %ymm2
	vmovdqu	glob_data + 1880(%rip), %ymm4
	vperm2i128	$32, %ymm6, %ymm11, %ymm9
	vperm2i128	$49, %ymm6, %ymm11, %ymm6
	vperm2i128	$32, %ymm7, %ymm8, %ymm12
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm5, %ymm1, %ymm8
	vperm2i128	$49, %ymm5, %ymm1, %ymm14
	vperm2i128	$32, %ymm3, %ymm13, %ymm1
	vperm2i128	$49, %ymm3, %ymm13, %ymm13
	vpmullw	%ymm8, %ymm2, %ymm15
	vpmulhw	%ymm8, %ymm4, %ymm5
	vpmullw	%ymm14, %ymm2, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmullw	%ymm1, %ymm2, %ymm3
	vpmulhw	%ymm1, %ymm4, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm11
	vpmulhw	%ymm13, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm11, %ymm4
	vpsubw	%ymm14, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm1
	vpaddw	%ymm11, %ymm2, %ymm11
	vpsubw	%ymm2, %ymm9, %ymm12
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm7, %ymm7
	vmovdqu	glob_data + 1912(%rip), %ymm5
	vmovdqu	glob_data + 1944(%rip), %ymm10
	vpunpcklqdq	%ymm11, %ymm12, %ymm9
	vpunpckhqdq	%ymm11, %ymm12, %ymm11
	vpunpcklqdq	%ymm2, %ymm6, %ymm12
	vpunpckhqdq	%ymm2, %ymm6, %ymm4
	vpunpcklqdq	%ymm8, %ymm1, %ymm15
	vpunpckhqdq	%ymm8, %ymm1, %ymm14
	vpunpcklqdq	%ymm3, %ymm7, %ymm2
	vpunpckhqdq	%ymm3, %ymm7, %ymm13
	vpmullw	%ymm15, %ymm5, %ymm6
	vpmulhw	%ymm15, %ymm10, %ymm3
	vpmullw	%ymm14, %ymm5, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmullw	%ymm2, %ymm5, %ymm1
	vpmulhw	%ymm2, %ymm10, %ymm7
	vpmullw	%ymm13, %ymm5, %ymm2
	vpmulhw	%ymm13, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm6, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm10, %ymm4, %ymm3
	vpaddw	%ymm4, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm12, %ymm5
	vpaddw	%ymm12, %ymm7, %ymm12
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm10
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm1, %ymm5
	vpsubw	%ymm1, %ymm12, %ymm8
	vpaddw	%ymm3, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm4, %ymm3
	vmovdqu	glob_data + 1976(%rip), %ymm2
	vmovdqu	glob_data + 2008(%rip), %ymm4
	vmovsldup	%ymm7, %ymm13
	vpblendd	$170, %ymm13, %ymm11, %ymm9
	vpsrlq	$32, %ymm11, %ymm11
	vpblendd	$170, %ymm7, %ymm11, %ymm11
	vmovsldup	%ymm10, %ymm13
	vpblendd	$170, %ymm13, %ymm6, %ymm12
	vpsrlq	$32, %ymm6, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm7
	vmovsldup	%ymm5, %ymm6
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm14
	vmovsldup	%ymm1, %ymm13
	vpblendd	$170, %ymm13, %ymm3, %ymm10
	vpsrlq	$32, %ymm3, %ymm3
	vpblendd	$170, %ymm1, %ymm3, %ymm13
	vpmullw	%ymm6, %ymm2, %ymm15
	vpmulhw	%ymm6, %ymm4, %ymm5
	vpmullw	%ymm14, %ymm2, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmullw	%ymm10, %ymm2, %ymm3
	vpmulhw	%ymm10, %ymm4, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm6
	vpmulhw	%ymm13, %ymm4, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm6, %ymm4
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm11
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm12, %ymm3
	vpaddw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm4, %ymm7, %ymm13
	vmovdqu	glob_data + 2040(%rip), %ymm4
	vmovdqu	glob_data + 2072(%rip), %ymm10
	vpslld	$16, %ymm1, %ymm15
	vpblendw	$170, %ymm15, %ymm11, %ymm9
	vpsrld	$16, %ymm11, %ymm7
	vpblendw	$170, %ymm1, %ymm7, %ymm11
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm6, %ymm12
	vpsrld	$16, %ymm6, %ymm7
	vpblendw	$170, %ymm2, %ymm7, %ymm7
	vpslld	$16, %ymm8, %ymm2
	vpblendw	$170, %ymm2, %ymm3, %ymm15
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm14
	vpslld	$16, %ymm5, %ymm2
	vpblendw	$170, %ymm2, %ymm13, %ymm1
	vpsrld	$16, %ymm13, %ymm3
	vpblendw	$170, %ymm5, %ymm3, %ymm6
	vpmullw	%ymm15, %ymm4, %ymm2
	vpmulhw	%ymm15, %ymm10, %ymm5
	vpmullw	%ymm14, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmullw	%ymm1, %ymm4, %ymm3
	vpmulhw	%ymm1, %ymm10, %ymm1
	vpmullw	%ymm6, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm14, %ymm11, %ymm13
	vpaddw	%ymm11, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm7, %ymm5
	vpaddw	%ymm7, %ymm10, %ymm7
	vpsubw	%ymm1, %ymm12, %ymm10
	vpaddw	%ymm12, %ymm1, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm12, %ymm8
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm7, %ymm7
	vmovdqu	glob_data + 2104(%rip), %ymm11
	vmovdqu	glob_data + 2136(%rip), %ymm13
	vmovdqu	glob_data + 2168(%rip), %ymm4
	vmovdqu	glob_data + 2200(%rip), %ymm12
	vpmullw	%ymm8, %ymm11, %ymm15
	vpmulhw	%ymm8, %ymm13, %ymm5
	vpmullw	%ymm7, %ymm11, %ymm8
	vpmulhw	%ymm7, %ymm13, %ymm14
	vpmullw	%ymm10, %ymm4, %ymm11
	vpmulhw	%ymm10, %ymm12, %ymm7
	vpmullw	%ymm3, %ymm4, %ymm4
	vpmulhw	%ymm3, %ymm12, %ymm10
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm14, %ymm6, %ymm13
	vpaddw	%ymm6, %ymm14, %ymm6
	vpsubw	%ymm5, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm10, %ymm2, %ymm5
	vpaddw	%ymm2, %ymm10, %ymm2
	vpsubw	%ymm7, %ymm1, %ymm10
	vpaddw	%ymm1, %ymm7, %ymm1
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm11
	vpsubw	%ymm8, %ymm6, %ymm6
	vpaddw	%ymm10, %ymm3, %ymm8
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm2, %ymm5
	vmovdqu	glob_data + 544(%rip), %ymm2
	vpmulhw	%ymm2, %ymm9, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm9, %ymm9
	vpmulhw	%ymm2, %ymm6, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm6, %ymm4
	vpmulhw	%ymm2, %ymm1, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm5, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm5, %ymm6
	vpmulhw	%ymm2, %ymm7, %ymm5
	vpsraw	$10, %ymm5, %ymm5
	vpmullw	%ymm0, %ymm5, %ymm5
	vpsubw	%ymm5, %ymm7, %ymm5
	vpmulhw	%ymm2, %ymm11, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm11, %ymm7
	vpmulhw	%ymm2, %ymm8, %ymm10
	vpsraw	$10, %ymm10, %ymm10
	vpmullw	%ymm0, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm8, %ymm13
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm0
	vmovdqu	%ymm9, 256(%rdx)
	vmovdqu	%ymm4, 288(%rdx)
	vmovdqu	%ymm5, 320(%rdx)
	vmovdqu	%ymm7, 352(%rdx)
	vmovdqu	%ymm1, 384(%rdx)
	vmovdqu	%ymm6, 416(%rdx)
	vmovdqu	%ymm13, 448(%rdx)
	vmovdqu	%ymm0, 480(%rdx)
	ret
.L_poly_invntt$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 640(%rip), %ymm10
	vmovdqu	glob_data + 704(%rip), %ymm2
	vmovdqu	glob_data + 672(%rip), %ymm1
	vmovdqu	glob_data + 736(%rip), %ymm4
	vmovdqu	(%rdx), %ymm7
	vmovdqu	32(%rdx), %ymm14
	vmovdqu	64(%rdx), %ymm15
	vmovdqu	96(%rdx), %ymm9
	vmovdqu	128(%rdx), %ymm3
	vmovdqu	160(%rdx), %ymm5
	vmovdqu	192(%rdx), %ymm13
	vmovdqu	224(%rdx), %ymm12
	vpsubw	%ymm15, %ymm7, %ymm6
	vpsubw	%ymm9, %ymm14, %ymm11
	vpsubw	%ymm13, %ymm3, %ymm8
	vpaddw	%ymm7, %ymm15, %ymm7
	vpaddw	%ymm14, %ymm9, %ymm9
	vpmullw	%ymm6, %ymm10, %ymm15
	vpaddw	%ymm3, %ymm13, %ymm3
	vpmullw	%ymm11, %ymm10, %ymm13
	vpsubw	%ymm12, %ymm5, %ymm10
	vpaddw	%ymm5, %ymm12, %ymm5
	vpmullw	%ymm8, %ymm2, %ymm12
	vpmullw	%ymm10, %ymm2, %ymm2
	vpmulhw	%ymm6, %ymm1, %ymm6
	vpmulhw	%ymm11, %ymm1, %ymm11
	vpmulhw	%ymm8, %ymm4, %ymm8
	vpmulhw	%ymm10, %ymm4, %ymm10
	vpmulhw	%ymm15, %ymm0, %ymm15
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm12, %ymm0, %ymm1
	vpmulhw	%ymm2, %ymm0, %ymm2
	vpsubw	%ymm15, %ymm6, %ymm12
	vpsubw	%ymm13, %ymm11, %ymm4
	vpsubw	%ymm1, %ymm8, %ymm13
	vpsubw	%ymm2, %ymm10, %ymm6
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	glob_data + 768(%rip), %ymm2
	vmovdqu	glob_data + 800(%rip), %ymm10
	vpmulhw	%ymm1, %ymm7, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm11
	vpmulhw	%ymm1, %ymm3, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm3, %ymm8
	vpmulhw	%ymm1, %ymm5, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm5, %ymm9
	vpsubw	%ymm8, %ymm7, %ymm15
	vpsubw	%ymm9, %ymm11, %ymm3
	vpsubw	%ymm13, %ymm12, %ymm14
	vpaddw	%ymm7, %ymm8, %ymm5
	vpaddw	%ymm11, %ymm9, %ymm7
	vpmullw	%ymm15, %ymm2, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm6, %ymm4, %ymm9
	vpaddw	%ymm4, %ymm6, %ymm8
	vpmullw	%ymm14, %ymm2, %ymm4
	vpmullw	%ymm9, %ymm2, %ymm6
	vpmulhw	%ymm15, %ymm10, %ymm2
	vpmulhw	%ymm3, %ymm10, %ymm3
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmulhw	%ymm9, %ymm10, %ymm9
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm6, %ymm0, %ymm6
	vpsubw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm4, %ymm14, %ymm4
	vpsubw	%ymm6, %ymm9, %ymm6
	vpslld	$16, %ymm7, %ymm13
	vpblendw	$170, %ymm13, %ymm5, %ymm9
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm7, %ymm5, %ymm11
	vpslld	$16, %ymm8, %ymm13
	vpblendw	$170, %ymm13, %ymm12, %ymm10
	vpsrld	$16, %ymm12, %ymm5
	vpblendw	$170, %ymm8, %ymm5, %ymm14
	vpslld	$16, %ymm3, %ymm13
	vpblendw	$170, %ymm13, %ymm2, %ymm12
	vpsrld	$16, %ymm2, %ymm5
	vpblendw	$170, %ymm3, %ymm5, %ymm13
	vpslld	$16, %ymm6, %ymm2
	vpblendw	$170, %ymm2, %ymm4, %ymm5
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm6, %ymm3, %ymm3
	vmovdqu	glob_data + 832(%rip), %ymm2
	vmovdqu	glob_data + 864(%rip), %ymm4
	vpsubw	%ymm11, %ymm9, %ymm15
	vpsubw	%ymm14, %ymm10, %ymm7
	vpsubw	%ymm13, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm10, %ymm14, %ymm10
	vpmullw	%ymm15, %ymm2, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm7, %ymm2, %ymm13
	vpsubw	%ymm3, %ymm5, %ymm14
	vpaddw	%ymm5, %ymm3, %ymm6
	vpmullw	%ymm8, %ymm2, %ymm3
	vpmullw	%ymm14, %ymm2, %ymm5
	vpmulhw	%ymm15, %ymm4, %ymm2
	vpmulhw	%ymm7, %ymm4, %ymm7
	vpmulhw	%ymm8, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm3, %ymm0, %ymm4
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm7, %ymm3
	vpsubw	%ymm4, %ymm8, %ymm4
	vpsubw	%ymm5, %ymm14, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vmovsldup	%ymm10, %ymm13
	vpblendd	$170, %ymm13, %ymm7, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm10, %ymm7, %ymm11
	vmovsldup	%ymm6, %ymm13
	vpblendd	$170, %ymm13, %ymm12, %ymm10
	vpsrlq	$32, %ymm12, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm14
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm2, %ymm12
	vpsrlq	$32, %ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm13
	vmovsldup	%ymm5, %ymm2
	vpblendd	$170, %ymm2, %ymm4, %ymm2
	vpsrlq	$32, %ymm4, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 896(%rip), %ymm4
	vmovdqu	glob_data + 928(%rip), %ymm5
	vpsubw	%ymm11, %ymm9, %ymm6
	vpsubw	%ymm14, %ymm10, %ymm7
	vpsubw	%ymm13, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm10, %ymm14, %ymm10
	vpmullw	%ymm6, %ymm4, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm7, %ymm4, %ymm13
	vpsubw	%ymm3, %ymm2, %ymm14
	vpaddw	%ymm2, %ymm3, %ymm2
	vpmullw	%ymm8, %ymm4, %ymm3
	vpmullw	%ymm14, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm5, %ymm6
	vpmulhw	%ymm7, %ymm5, %ymm7
	vpmulhw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm14, %ymm5, %ymm14
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm3, %ymm0, %ymm3
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm11, %ymm6, %ymm5
	vpsubw	%ymm13, %ymm7, %ymm6
	vpsubw	%ymm3, %ymm8, %ymm3
	vpsubw	%ymm4, %ymm14, %ymm4
	vpmulhw	%ymm1, %ymm9, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm8
	vpunpcklqdq	%ymm10, %ymm8, %ymm7
	vpunpckhqdq	%ymm10, %ymm8, %ymm8
	vpunpcklqdq	%ymm2, %ymm12, %ymm9
	vpunpckhqdq	%ymm2, %ymm12, %ymm2
	vpunpcklqdq	%ymm6, %ymm5, %ymm12
	vpunpckhqdq	%ymm6, %ymm5, %ymm13
	vpunpcklqdq	%ymm4, %ymm3, %ymm5
	vpunpckhqdq	%ymm4, %ymm3, %ymm3
	vmovdqu	glob_data + 960(%rip), %ymm4
	vmovdqu	glob_data + 992(%rip), %ymm10
	vpsubw	%ymm8, %ymm7, %ymm6
	vpsubw	%ymm2, %ymm9, %ymm11
	vpsubw	%ymm13, %ymm12, %ymm14
	vpaddw	%ymm7, %ymm8, %ymm7
	vpaddw	%ymm9, %ymm2, %ymm2
	vpmullw	%ymm6, %ymm4, %ymm8
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm11, %ymm4, %ymm13
	vpsubw	%ymm3, %ymm5, %ymm9
	vpaddw	%ymm5, %ymm3, %ymm3
	vpmullw	%ymm14, %ymm4, %ymm5
	vpmullw	%ymm9, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm10, %ymm6
	vpmulhw	%ymm11, %ymm10, %ymm11
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmulhw	%ymm9, %ymm10, %ymm9
	vpmulhw	%ymm8, %ymm0, %ymm8
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm8, %ymm6, %ymm6
	vpsubw	%ymm13, %ymm11, %ymm8
	vpsubw	%ymm5, %ymm14, %ymm5
	vpsubw	%ymm4, %ymm9, %ymm10
	vpmulhw	%ymm1, %ymm7, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm7, %ymm4
	vperm2i128	$32, %ymm2, %ymm4, %ymm9
	vperm2i128	$49, %ymm2, %ymm4, %ymm11
	vperm2i128	$32, %ymm3, %ymm12, %ymm2
	vperm2i128	$49, %ymm3, %ymm12, %ymm13
	vperm2i128	$32, %ymm8, %ymm6, %ymm12
	vperm2i128	$49, %ymm8, %ymm6, %ymm3
	vperm2i128	$32, %ymm10, %ymm5, %ymm4
	vperm2i128	$49, %ymm10, %ymm5, %ymm5
	vpbroadcastd	glob_data + 1024(%rip), %ymm6
	vpbroadcastd	glob_data + 1028(%rip), %ymm10
	vpsubw	%ymm11, %ymm9, %ymm15
	vpsubw	%ymm13, %ymm2, %ymm7
	vpsubw	%ymm3, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm2, %ymm13, %ymm2
	vpmullw	%ymm15, %ymm6, %ymm11
	vpaddw	%ymm12, %ymm3, %ymm3
	vpmullw	%ymm7, %ymm6, %ymm13
	vpsubw	%ymm5, %ymm4, %ymm14
	vpaddw	%ymm4, %ymm5, %ymm4
	vpmullw	%ymm8, %ymm6, %ymm5
	vpmullw	%ymm14, %ymm6, %ymm6
	vpmulhw	%ymm15, %ymm10, %ymm15
	vpmulhw	%ymm7, %ymm10, %ymm7
	vpmulhw	%ymm8, %ymm10, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm10
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpmulhw	%ymm6, %ymm0, %ymm6
	vpsubw	%ymm11, %ymm15, %ymm11
	vpsubw	%ymm13, %ymm7, %ymm7
	vpsubw	%ymm5, %ymm8, %ymm5
	vpsubw	%ymm6, %ymm10, %ymm6
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm9
	vmovdqu	%ymm9, (%rdx)
	vmovdqu	%ymm2, 32(%rdx)
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	%ymm4, 96(%rdx)
	vmovdqu	%ymm11, 128(%rdx)
	vmovdqu	%ymm7, 160(%rdx)
	vmovdqu	%ymm5, 192(%rdx)
	vmovdqu	%ymm6, 224(%rdx)
	vmovdqu	glob_data + 1032(%rip), %ymm10
	vmovdqu	glob_data + 1096(%rip), %ymm2
	vmovdqu	glob_data + 1064(%rip), %ymm1
	vmovdqu	glob_data + 1128(%rip), %ymm4
	vmovdqu	256(%rdx), %ymm3
	vmovdqu	288(%rdx), %ymm11
	vmovdqu	320(%rdx), %ymm5
	vmovdqu	352(%rdx), %ymm14
	vmovdqu	384(%rdx), %ymm9
	vmovdqu	416(%rdx), %ymm6
	vmovdqu	448(%rdx), %ymm13
	vmovdqu	480(%rdx), %ymm12
	vpsubw	%ymm5, %ymm3, %ymm15
	vpsubw	%ymm14, %ymm11, %ymm7
	vpsubw	%ymm13, %ymm9, %ymm8
	vpaddw	%ymm3, %ymm5, %ymm3
	vpaddw	%ymm11, %ymm14, %ymm5
	vpmullw	%ymm15, %ymm10, %ymm11
	vpaddw	%ymm9, %ymm13, %ymm9
	vpmullw	%ymm7, %ymm10, %ymm13
	vpsubw	%ymm12, %ymm6, %ymm10
	vpaddw	%ymm6, %ymm12, %ymm6
	vpmullw	%ymm8, %ymm2, %ymm12
	vpmullw	%ymm10, %ymm2, %ymm2
	vpmulhw	%ymm15, %ymm1, %ymm15
	vpmulhw	%ymm7, %ymm1, %ymm7
	vpmulhw	%ymm8, %ymm4, %ymm8
	vpmulhw	%ymm10, %ymm4, %ymm10
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm12, %ymm0, %ymm1
	vpmulhw	%ymm2, %ymm0, %ymm2
	vpsubw	%ymm11, %ymm15, %ymm12
	vpsubw	%ymm13, %ymm7, %ymm4
	vpsubw	%ymm1, %ymm8, %ymm13
	vpsubw	%ymm2, %ymm10, %ymm7
	vmovdqu	glob_data + 544(%rip), %ymm1
	vmovdqu	glob_data + 1160(%rip), %ymm2
	vmovdqu	glob_data + 1192(%rip), %ymm10
	vpmulhw	%ymm1, %ymm3, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm3, %ymm8
	vpmulhw	%ymm1, %ymm5, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm5, %ymm11
	vpmulhw	%ymm1, %ymm9, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm9, %ymm9
	vpmulhw	%ymm1, %ymm6, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm6, %ymm6
	vpsubw	%ymm9, %ymm8, %ymm15
	vpsubw	%ymm6, %ymm11, %ymm3
	vpsubw	%ymm13, %ymm12, %ymm14
	vpaddw	%ymm8, %ymm9, %ymm5
	vpaddw	%ymm11, %ymm6, %ymm6
	vpmullw	%ymm15, %ymm2, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm7, %ymm4, %ymm9
	vpaddw	%ymm4, %ymm7, %ymm8
	vpmullw	%ymm14, %ymm2, %ymm4
	vpmullw	%ymm9, %ymm2, %ymm7
	vpmulhw	%ymm15, %ymm10, %ymm2
	vpmulhw	%ymm3, %ymm10, %ymm3
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmulhw	%ymm9, %ymm10, %ymm9
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm7, %ymm0, %ymm7
	vpsubw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm4, %ymm14, %ymm4
	vpsubw	%ymm7, %ymm9, %ymm7
	vpslld	$16, %ymm6, %ymm13
	vpblendw	$170, %ymm13, %ymm5, %ymm9
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm6, %ymm5, %ymm11
	vpslld	$16, %ymm8, %ymm6
	vpblendw	$170, %ymm6, %ymm12, %ymm6
	vpsrld	$16, %ymm12, %ymm5
	vpblendw	$170, %ymm8, %ymm5, %ymm14
	vpslld	$16, %ymm3, %ymm13
	vpblendw	$170, %ymm13, %ymm2, %ymm12
	vpsrld	$16, %ymm2, %ymm5
	vpblendw	$170, %ymm3, %ymm5, %ymm13
	vpslld	$16, %ymm7, %ymm2
	vpblendw	$170, %ymm2, %ymm4, %ymm5
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm7, %ymm3, %ymm4
	vmovdqu	glob_data + 1224(%rip), %ymm2
	vmovdqu	glob_data + 1256(%rip), %ymm10
	vpsubw	%ymm11, %ymm9, %ymm15
	vpsubw	%ymm14, %ymm6, %ymm3
	vpsubw	%ymm13, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm6, %ymm14, %ymm6
	vpmullw	%ymm15, %ymm2, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm4, %ymm5, %ymm14
	vpaddw	%ymm5, %ymm4, %ymm7
	vpmullw	%ymm8, %ymm2, %ymm4
	vpmullw	%ymm14, %ymm2, %ymm5
	vpmulhw	%ymm15, %ymm10, %ymm2
	vpmulhw	%ymm3, %ymm10, %ymm3
	vpmulhw	%ymm8, %ymm10, %ymm8
	vpmulhw	%ymm14, %ymm10, %ymm14
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm4, %ymm8, %ymm4
	vpsubw	%ymm5, %ymm14, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm8
	vmovsldup	%ymm6, %ymm13
	vpblendd	$170, %ymm13, %ymm8, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm11
	vmovsldup	%ymm7, %ymm6
	vpblendd	$170, %ymm6, %ymm12, %ymm10
	vpsrlq	$32, %ymm12, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm14
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm2, %ymm12
	vpsrlq	$32, %ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm13
	vmovsldup	%ymm5, %ymm2
	vpblendd	$170, %ymm2, %ymm4, %ymm2
	vpsrlq	$32, %ymm4, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 1288(%rip), %ymm4
	vmovdqu	glob_data + 1320(%rip), %ymm5
	vpsubw	%ymm11, %ymm9, %ymm6
	vpsubw	%ymm14, %ymm10, %ymm7
	vpsubw	%ymm13, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm10, %ymm14, %ymm10
	vpmullw	%ymm6, %ymm4, %ymm11
	vpaddw	%ymm12, %ymm13, %ymm12
	vpmullw	%ymm7, %ymm4, %ymm13
	vpsubw	%ymm3, %ymm2, %ymm14
	vpaddw	%ymm2, %ymm3, %ymm2
	vpmullw	%ymm8, %ymm4, %ymm3
	vpmullw	%ymm14, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm5, %ymm6
	vpmulhw	%ymm7, %ymm5, %ymm7
	vpmulhw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm14, %ymm5, %ymm14
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm3, %ymm0, %ymm3
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm11, %ymm6, %ymm5
	vpsubw	%ymm13, %ymm7, %ymm6
	vpsubw	%ymm3, %ymm8, %ymm3
	vpsubw	%ymm4, %ymm14, %ymm7
	vpmulhw	%ymm1, %ymm9, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm9, %ymm4
	vpunpcklqdq	%ymm10, %ymm4, %ymm9
	vpunpckhqdq	%ymm10, %ymm4, %ymm11
	vpunpcklqdq	%ymm2, %ymm12, %ymm10
	vpunpckhqdq	%ymm2, %ymm12, %ymm13
	vpunpcklqdq	%ymm6, %ymm5, %ymm12
	vpunpckhqdq	%ymm6, %ymm5, %ymm4
	vpunpcklqdq	%ymm7, %ymm3, %ymm2
	vpunpckhqdq	%ymm7, %ymm3, %ymm3
	vmovdqu	glob_data + 1352(%rip), %ymm5
	vmovdqu	glob_data + 1384(%rip), %ymm6
	vpsubw	%ymm11, %ymm9, %ymm15
	vpsubw	%ymm13, %ymm10, %ymm7
	vpsubw	%ymm4, %ymm12, %ymm8
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm10
	vpmullw	%ymm15, %ymm5, %ymm11
	vpaddw	%ymm12, %ymm4, %ymm4
	vpmullw	%ymm7, %ymm5, %ymm13
	vpsubw	%ymm3, %ymm2, %ymm14
	vpaddw	%ymm2, %ymm3, %ymm2
	vpmullw	%ymm8, %ymm5, %ymm3
	vpmullw	%ymm14, %ymm5, %ymm5
	vpmulhw	%ymm15, %ymm6, %ymm15
	vpmulhw	%ymm7, %ymm6, %ymm7
	vpmulhw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm14, %ymm6, %ymm14
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm3, %ymm0, %ymm3
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm11, %ymm15, %ymm6
	vpsubw	%ymm13, %ymm7, %ymm7
	vpsubw	%ymm3, %ymm8, %ymm3
	vpsubw	%ymm5, %ymm14, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm8
	vperm2i128	$32, %ymm10, %ymm8, %ymm9
	vperm2i128	$49, %ymm10, %ymm8, %ymm8
	vperm2i128	$32, %ymm2, %ymm4, %ymm10
	vperm2i128	$49, %ymm2, %ymm4, %ymm13
	vperm2i128	$32, %ymm7, %ymm6, %ymm12
	vperm2i128	$49, %ymm7, %ymm6, %ymm4
	vperm2i128	$32, %ymm5, %ymm3, %ymm2
	vperm2i128	$49, %ymm5, %ymm3, %ymm3
	vpbroadcastd	glob_data + 1416(%rip), %ymm5
	vpbroadcastd	glob_data + 1420(%rip), %ymm6
	vpsubw	%ymm8, %ymm9, %ymm15
	vpsubw	%ymm13, %ymm10, %ymm7
	vpsubw	%ymm4, %ymm12, %ymm14
	vpaddw	%ymm9, %ymm8, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm8
	vpmullw	%ymm15, %ymm5, %ymm11
	vpaddw	%ymm12, %ymm4, %ymm4
	vpmullw	%ymm7, %ymm5, %ymm13
	vpsubw	%ymm3, %ymm2, %ymm10
	vpaddw	%ymm2, %ymm3, %ymm2
	vpmullw	%ymm14, %ymm5, %ymm3
	vpmullw	%ymm10, %ymm5, %ymm5
	vpmulhw	%ymm15, %ymm6, %ymm15
	vpmulhw	%ymm7, %ymm6, %ymm7
	vpmulhw	%ymm14, %ymm6, %ymm14
	vpmulhw	%ymm10, %ymm6, %ymm10
	vpmulhw	%ymm11, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm3, %ymm0, %ymm3
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm11, %ymm15, %ymm11
	vpsubw	%ymm13, %ymm7, %ymm7
	vpsubw	%ymm3, %ymm14, %ymm3
	vpsubw	%ymm5, %ymm10, %ymm6
	vpmulhw	%ymm1, %ymm9, %ymm5
	vpsraw	$10, %ymm5, %ymm5
	vpmullw	%ymm0, %ymm5, %ymm5
	vpsubw	%ymm5, %ymm9, %ymm9
	vmovdqu	%ymm11, 384(%rdx)
	vmovdqu	%ymm7, 416(%rdx)
	vmovdqu	%ymm3, 448(%rdx)
	vmovdqu	%ymm6, 480(%rdx)
	vpbroadcastd	glob_data + 1424(%rip), %ymm5
	vpbroadcastd	glob_data + 1428(%rip), %ymm6
	vmovdqu	%ymm2, %ymm7
	vmovdqu	%ymm8, %ymm13
	vmovdqu	(%rdx), %ymm1
	vmovdqu	32(%rdx), %ymm2
	vmovdqu	64(%rdx), %ymm3
	vmovdqu	96(%rdx), %ymm8
	vpsubw	%ymm9, %ymm1, %ymm15
	vpsubw	%ymm13, %ymm2, %ymm11
	vpsubw	%ymm4, %ymm3, %ymm14
	vpaddw	%ymm1, %ymm9, %ymm1
	vpaddw	%ymm2, %ymm13, %ymm2
	vpmullw	%ymm15, %ymm5, %ymm9
	vpaddw	%ymm3, %ymm4, %ymm3
	vpmullw	%ymm11, %ymm5, %ymm13
	vpsubw	%ymm7, %ymm8, %ymm10
	vpaddw	%ymm8, %ymm7, %ymm7
	vpmullw	%ymm14, %ymm5, %ymm4
	vpmullw	%ymm10, %ymm5, %ymm8
	vpmulhw	%ymm15, %ymm6, %ymm15
	vpmulhw	%ymm11, %ymm6, %ymm11
	vpmulhw	%ymm14, %ymm6, %ymm14
	vpmulhw	%ymm10, %ymm6, %ymm10
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm8, %ymm0, %ymm8
	vpsubw	%ymm9, %ymm15, %ymm9
	vpsubw	%ymm13, %ymm11, %ymm11
	vpsubw	%ymm4, %ymm14, %ymm12
	vpsubw	%ymm8, %ymm10, %ymm10
	vmovdqu	glob_data + 480(%rip), %ymm4
	vmovdqu	glob_data + 512(%rip), %ymm8
	vmovdqu	%ymm9, 256(%rdx)
	vmovdqu	%ymm11, 288(%rdx)
	vmovdqu	%ymm12, 320(%rdx)
	vmovdqu	%ymm10, 352(%rdx)
	vpmullw	%ymm1, %ymm4, %ymm10
	vpmulhw	%ymm1, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm1, %ymm9
	vpmullw	%ymm2, %ymm4, %ymm10
	vpmulhw	%ymm2, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm10, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm2
	vpmullw	%ymm3, %ymm4, %ymm10
	vpmulhw	%ymm3, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm10, %ymm3
	vpsubw	%ymm3, %ymm1, %ymm1
	vpmullw	%ymm7, %ymm4, %ymm3
	vpmulhw	%ymm7, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm7, %ymm3
	vmovdqu	%ymm9, (%rdx)
	vmovdqu	%ymm2, 32(%rdx)
	vmovdqu	%ymm1, 64(%rdx)
	vmovdqu	%ymm3, 96(%rdx)
	vmovdqu	384(%rdx), %ymm9
	vmovdqu	416(%rdx), %ymm13
	vmovdqu	448(%rdx), %ymm3
	vmovdqu	480(%rdx), %ymm4
	vmovdqu	128(%rdx), %ymm1
	vmovdqu	160(%rdx), %ymm2
	vmovdqu	192(%rdx), %ymm12
	vmovdqu	224(%rdx), %ymm7
	vpsubw	%ymm9, %ymm1, %ymm15
	vpsubw	%ymm13, %ymm2, %ymm11
	vpsubw	%ymm3, %ymm12, %ymm8
	vpaddw	%ymm1, %ymm9, %ymm1
	vpaddw	%ymm2, %ymm13, %ymm2
	vpmullw	%ymm15, %ymm5, %ymm9
	vpaddw	%ymm12, %ymm3, %ymm3
	vpmullw	%ymm11, %ymm5, %ymm13
	vpsubw	%ymm4, %ymm7, %ymm10
	vpaddw	%ymm7, %ymm4, %ymm7
	vpmullw	%ymm8, %ymm5, %ymm4
	vpmullw	%ymm10, %ymm5, %ymm5
	vpmulhw	%ymm15, %ymm6, %ymm15
	vpmulhw	%ymm11, %ymm6, %ymm11
	vpmulhw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm10, %ymm6, %ymm10
	vpmulhw	%ymm9, %ymm0, %ymm6
	vpmulhw	%ymm13, %ymm0, %ymm9
	vpmulhw	%ymm4, %ymm0, %ymm12
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm6, %ymm15, %ymm4
	vpsubw	%ymm9, %ymm11, %ymm9
	vpsubw	%ymm12, %ymm8, %ymm6
	vpsubw	%ymm5, %ymm10, %ymm10
	vmovdqu	glob_data + 480(%rip), %ymm5
	vmovdqu	glob_data + 512(%rip), %ymm8
	vmovdqu	%ymm4, 384(%rdx)
	vmovdqu	%ymm9, 416(%rdx)
	vmovdqu	%ymm6, 448(%rdx)
	vmovdqu	%ymm10, 480(%rdx)
	vpmullw	%ymm1, %ymm5, %ymm4
	vpmulhw	%ymm1, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm1, %ymm6
	vpmullw	%ymm2, %ymm5, %ymm4
	vpmulhw	%ymm2, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm4, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm2
	vpmullw	%ymm3, %ymm5, %ymm4
	vpmulhw	%ymm3, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpsubw	%ymm3, %ymm1, %ymm1
	vpmullw	%ymm7, %ymm5, %ymm3
	vpmulhw	%ymm7, %ymm8, %ymm5
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm5, %ymm3
	vmovdqu	%ymm6, 128(%rdx)
	vmovdqu	%ymm2, 160(%rdx)
	vmovdqu	%ymm1, 192(%rdx)
	vmovdqu	%ymm3, 224(%rdx)
	ret
.L_poly_getnoise_eta1_4x$1:
	leaq	32(%rsp), %rcx
	leaq	160(%rsp), %rdx
	leaq	288(%rsp), %rsi
	leaq	416(%rsp), %rdi
	movq	%rax, 552(%rsp)
	movq	%r9, 560(%rsp)
	movq	%r10, 568(%rsp)
	movq	%r11, 576(%rsp)
	movb	%bl, 544(%rsp)
	incb	%bl
	movb	%bl, 545(%rsp)
	incb	%bl
	movb	%bl, 546(%rsp)
	incb	%bl
	movb	%bl, 547(%rsp)
	leaq	544(%rsp), %r11
	leaq	-856(%rsp), %rsp
	call	.L_shake256x4_AETA1__A32_A1$1
.L_poly_getnoise_eta1_4x$2:
	leaq	856(%rsp), %rsp
	lfence
	movq	$0, %rax
	movq	552(%rsp), %r8
	movq	560(%rsp), %r9
	movq	568(%rsp), %r10
	movq	576(%rsp), %r11
	movl	$1431655765, 544(%rsp)
	movl	$858993459, 584(%rsp)
	movl	$50529027, 588(%rsp)
	movl	$252645135, 592(%rsp)
	vpbroadcastd	544(%rsp), %ymm0
	vpbroadcastd	584(%rsp), %ymm1
	vpbroadcastd	588(%rsp), %ymm2
	vpbroadcastd	592(%rsp), %ymm3
	vmovdqu	(%rcx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, (%r8)
	vmovdqu	%ymm10, 32(%r8)
	vmovdqu	%ymm5, 64(%r8)
	vmovdqu	%ymm4, 96(%r8)
	vmovdqu	32(%rcx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 128(%r8)
	vmovdqu	%ymm10, 160(%r8)
	vmovdqu	%ymm5, 192(%r8)
	vmovdqu	%ymm4, 224(%r8)
	vmovdqu	64(%rcx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 256(%r8)
	vmovdqu	%ymm10, 288(%r8)
	vmovdqu	%ymm5, 320(%r8)
	vmovdqu	%ymm4, 352(%r8)
	vmovdqu	96(%rcx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm2
	vmovdqu	%xmm10, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxbw	%xmm0, %ymm5
	vmovdqu	%xmm2, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vextracti128	$1, %ymm2, %xmm0
	vpmovsxbw	%xmm0, %ymm2
	vmovdqu	%ymm4, 384(%r8)
	vmovdqu	%ymm10, 416(%r8)
	vmovdqu	%ymm5, 448(%r8)
	vmovdqu	%ymm2, 480(%r8)
	movl	$1431655765, 592(%rsp)
	movl	$858993459, 588(%rsp)
	movl	$50529027, 584(%rsp)
	movl	$252645135, 544(%rsp)
	vpbroadcastd	592(%rsp), %ymm0
	vpbroadcastd	588(%rsp), %ymm1
	vpbroadcastd	584(%rsp), %ymm2
	vpbroadcastd	544(%rsp), %ymm3
	vmovdqu	(%rdx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, (%r9)
	vmovdqu	%ymm10, 32(%r9)
	vmovdqu	%ymm5, 64(%r9)
	vmovdqu	%ymm4, 96(%r9)
	vmovdqu	32(%rdx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 128(%r9)
	vmovdqu	%ymm10, 160(%r9)
	vmovdqu	%ymm5, 192(%r9)
	vmovdqu	%ymm4, 224(%r9)
	vmovdqu	64(%rdx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 256(%r9)
	vmovdqu	%ymm10, 288(%r9)
	vmovdqu	%ymm5, 320(%r9)
	vmovdqu	%ymm4, 352(%r9)
	vmovdqu	96(%rdx), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm2
	vmovdqu	%xmm10, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxbw	%xmm0, %ymm5
	vmovdqu	%xmm2, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vextracti128	$1, %ymm2, %xmm0
	vpmovsxbw	%xmm0, %ymm2
	vmovdqu	%ymm4, 384(%r9)
	vmovdqu	%ymm10, 416(%r9)
	vmovdqu	%ymm5, 448(%r9)
	vmovdqu	%ymm2, 480(%r9)
	movl	$1431655765, 544(%rsp)
	movl	$858993459, 584(%rsp)
	movl	$50529027, 588(%rsp)
	movl	$252645135, 592(%rsp)
	vpbroadcastd	544(%rsp), %ymm0
	vpbroadcastd	584(%rsp), %ymm1
	vpbroadcastd	588(%rsp), %ymm2
	vpbroadcastd	592(%rsp), %ymm3
	vmovdqu	(%rsi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, (%r10)
	vmovdqu	%ymm10, 32(%r10)
	vmovdqu	%ymm5, 64(%r10)
	vmovdqu	%ymm4, 96(%r10)
	vmovdqu	32(%rsi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 128(%r10)
	vmovdqu	%ymm10, 160(%r10)
	vmovdqu	%ymm5, 192(%r10)
	vmovdqu	%ymm4, 224(%r10)
	vmovdqu	64(%rsi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 256(%r10)
	vmovdqu	%ymm10, 288(%r10)
	vmovdqu	%ymm5, 320(%r10)
	vmovdqu	%ymm4, 352(%r10)
	vmovdqu	96(%rsi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm2
	vmovdqu	%xmm10, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxbw	%xmm0, %ymm5
	vmovdqu	%xmm2, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vextracti128	$1, %ymm2, %xmm0
	vpmovsxbw	%xmm0, %ymm2
	vmovdqu	%ymm4, 384(%r10)
	vmovdqu	%ymm10, 416(%r10)
	vmovdqu	%ymm5, 448(%r10)
	vmovdqu	%ymm2, 480(%r10)
	movl	$1431655765, 592(%rsp)
	movl	$858993459, 588(%rsp)
	movl	$50529027, 584(%rsp)
	movl	$252645135, 544(%rsp)
	vpbroadcastd	592(%rsp), %ymm0
	vpbroadcastd	588(%rsp), %ymm1
	vpbroadcastd	584(%rsp), %ymm2
	vpbroadcastd	544(%rsp), %ymm3
	vmovdqu	(%rdi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, (%r11)
	vmovdqu	%ymm10, 32(%r11)
	vmovdqu	%ymm5, 64(%r11)
	vmovdqu	%ymm4, 96(%r11)
	vmovdqu	32(%rdi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 128(%r11)
	vmovdqu	%ymm10, 160(%r11)
	vmovdqu	%ymm5, 192(%r11)
	vmovdqu	%ymm4, 224(%r11)
	vmovdqu	64(%rdi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm4
	vmovdqu	%xmm10, %xmm5
	vpmovsxbw	%xmm5, %ymm8
	vextracti128	$1, %ymm10, %xmm5
	vpmovsxbw	%xmm5, %ymm5
	vmovdqu	%xmm4, %xmm6
	vpmovsxbw	%xmm6, %ymm10
	vextracti128	$1, %ymm4, %xmm6
	vpmovsxbw	%xmm6, %ymm4
	vmovdqu	%ymm8, 256(%r11)
	vmovdqu	%ymm10, 288(%r11)
	vmovdqu	%ymm5, 320(%r11)
	vmovdqu	%ymm4, 352(%r11)
	vmovdqu	96(%rdi), %ymm4
	vpsrlw	$1, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpand	%ymm5, %ymm0, %ymm5
	vpaddb	%ymm5, %ymm4, %ymm4
	vpsrlw	$2, %ymm4, %ymm5
	vpand	%ymm4, %ymm1, %ymm4
	vpand	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm1, %ymm4, %ymm4
	vpsubb	%ymm5, %ymm4, %ymm4
	vpsrlw	$4, %ymm4, %ymm5
	vpand	%ymm4, %ymm3, %ymm4
	vpand	%ymm5, %ymm3, %ymm5
	vpsubb	%ymm2, %ymm4, %ymm4
	vpsubb	%ymm2, %ymm5, %ymm5
	vpunpcklbw	%ymm5, %ymm4, %ymm10
	vpunpckhbw	%ymm5, %ymm4, %ymm2
	vmovdqu	%xmm10, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxbw	%xmm0, %ymm5
	vmovdqu	%xmm2, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vextracti128	$1, %ymm2, %xmm0
	vpmovsxbw	%xmm0, %ymm2
	vmovdqu	%ymm4, 384(%r11)
	vmovdqu	%ymm10, 416(%r11)
	vmovdqu	%ymm5, 448(%r11)
	vmovdqu	%ymm2, 480(%r11)
	ret
.L_i_poly_frommsg$1:
	vmovdqu	glob_data + 416(%rip), %ymm0
	vbroadcasti128	glob_data + 2256(%rip), %ymm2
	vbroadcasti128	glob_data + 2240(%rip), %ymm1
	vmovdqu	(%rcx), %ymm3
	vpshufd	$0, %ymm3, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllw	$12, %ymm4, %ymm6
	vpsllw	$8, %ymm4, %ymm7
	vpsllw	$4, %ymm4, %ymm5
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm4, %ymm4
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm4, %ymm4
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm4, %ymm5, %ymm7
	vpunpckhqdq	%ymm4, %ymm5, %ymm4
	vperm2i128	$32, %ymm7, %ymm8, %ymm5
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm4, %ymm6, %ymm8
	vperm2i128	$49, %ymm4, %ymm6, %ymm4
	vmovdqu	%ymm5, (%rdx)
	vmovdqu	%ymm8, 32(%rdx)
	vmovdqu	%ymm7, 256(%rdx)
	vmovdqu	%ymm4, 288(%rdx)
	vpshufd	$85, %ymm3, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllw	$12, %ymm4, %ymm5
	vpsllw	$8, %ymm4, %ymm7
	vpsllw	$4, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm4, %ymm4
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm4, %ymm4
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm4, %ymm6, %ymm7
	vpunpckhqdq	%ymm4, %ymm6, %ymm4
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm4, %ymm5, %ymm8
	vperm2i128	$49, %ymm4, %ymm5, %ymm4
	vmovdqu	%ymm6, 64(%rdx)
	vmovdqu	%ymm8, 96(%rdx)
	vmovdqu	%ymm7, 320(%rdx)
	vmovdqu	%ymm4, 352(%rdx)
	vpshufd	$170, %ymm3, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllw	$12, %ymm4, %ymm5
	vpsllw	$8, %ymm4, %ymm7
	vpsllw	$4, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm4, %ymm4
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm4, %ymm4
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm4, %ymm6, %ymm7
	vpunpckhqdq	%ymm4, %ymm6, %ymm4
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm4, %ymm5, %ymm8
	vperm2i128	$49, %ymm4, %ymm5, %ymm4
	vmovdqu	%ymm6, 128(%rdx)
	vmovdqu	%ymm8, 160(%rdx)
	vmovdqu	%ymm7, 384(%rdx)
	vmovdqu	%ymm4, 416(%rdx)
	vpshufd	$255, %ymm3, %ymm4
	vpsllvd	%ymm2, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm4, %ymm4
	vpsllw	$12, %ymm4, %ymm5
	vpsllw	$8, %ymm4, %ymm7
	vpsllw	$4, %ymm4, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm4, %ymm4
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm4, %ymm4
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm4, %ymm6, %ymm7
	vpunpckhqdq	%ymm4, %ymm6, %ymm4
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm4, %ymm5, %ymm8
	vperm2i128	$49, %ymm4, %ymm5, %ymm4
	vmovdqu	%ymm6, 192(%rdx)
	vmovdqu	%ymm8, 224(%rdx)
	vmovdqu	%ymm7, 448(%rdx)
	vmovdqu	%ymm4, 480(%rdx)
	ret
.L_poly_frommont$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 576(%rip), %ymm1
	vmovdqu	glob_data + 320(%rip), %ymm2
	vmovdqu	(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, (%rcx)
	vmovdqu	32(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 32(%rcx)
	vmovdqu	64(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 64(%rcx)
	vmovdqu	96(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 96(%rcx)
	vmovdqu	128(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 128(%rcx)
	vmovdqu	160(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 160(%rcx)
	vmovdqu	192(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 192(%rcx)
	vmovdqu	224(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 224(%rcx)
	vmovdqu	256(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 256(%rcx)
	vmovdqu	288(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 288(%rcx)
	vmovdqu	320(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 320(%rcx)
	vmovdqu	352(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 352(%rcx)
	vmovdqu	384(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 384(%rcx)
	vmovdqu	416(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 416(%rcx)
	vmovdqu	448(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 448(%rcx)
	vmovdqu	480(%rcx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm0
	vmovdqu	%ymm0, 480(%rcx)
	ret
.L_i_poly_frombytes$1:
	vmovdqu	glob_data + 448(%rip), %ymm0
	vmovdqu	(%r9), %ymm1
	vmovdqu	32(%r9), %ymm2
	vmovdqu	64(%r9), %ymm8
	vmovdqu	96(%r9), %ymm3
	vmovdqu	128(%r9), %ymm5
	vmovdqu	160(%r9), %ymm7
	vperm2i128	$32, %ymm3, %ymm1, %ymm4
	vperm2i128	$49, %ymm3, %ymm1, %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm6
	vperm2i128	$49, %ymm5, %ymm2, %ymm1
	vperm2i128	$32, %ymm7, %ymm8, %ymm3
	vperm2i128	$49, %ymm7, %ymm8, %ymm5
	vpunpcklqdq	%ymm1, %ymm4, %ymm7
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vpunpcklqdq	%ymm3, %ymm9, %ymm2
	vpunpckhqdq	%ymm3, %ymm9, %ymm8
	vpunpcklqdq	%ymm5, %ymm6, %ymm10
	vpunpckhqdq	%ymm5, %ymm6, %ymm3
	vmovsldup	%ymm8, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm4
	vpsrlq	$32, %ymm7, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vmovsldup	%ymm10, %ymm6
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm10, %ymm1, %ymm7
	vmovsldup	%ymm3, %ymm13
	vpblendd	$170, %ymm13, %ymm2, %ymm1
	vpsrlq	$32, %ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpslld	$16, %ymm7, %ymm13
	vpblendw	$170, %ymm13, %ymm4, %ymm11
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm7, %ymm3, %ymm9
	vpslld	$16, %ymm1, %ymm13
	vpblendw	$170, %ymm13, %ymm5, %ymm13
	vpsrld	$16, %ymm5, %ymm3
	vpblendw	$170, %ymm1, %ymm3, %ymm1
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm6, %ymm3
	vpsrld	$16, %ymm6, %ymm5
	vpblendw	$170, %ymm2, %ymm5, %ymm7
	vpsrlw	$12, %ymm11, %ymm5
	vpsllw	$4, %ymm9, %ymm4
	vpor	%ymm4, %ymm5, %ymm5
	vpand	%ymm11, %ymm0, %ymm2
	vpand	%ymm5, %ymm0, %ymm5
	vpsrlw	$8, %ymm9, %ymm4
	vpsllw	$8, %ymm13, %ymm6
	vpor	%ymm6, %ymm4, %ymm4
	vpand	%ymm4, %ymm0, %ymm4
	vpsrlw	$4, %ymm13, %ymm6
	vpand	%ymm6, %ymm0, %ymm6
	vpsrlw	$12, %ymm1, %ymm8
	vpsllw	$4, %ymm3, %ymm9
	vpor	%ymm9, %ymm8, %ymm8
	vpand	%ymm1, %ymm0, %ymm1
	vpand	%ymm8, %ymm0, %ymm8
	vpsrlw	$8, %ymm3, %ymm9
	vpsllw	$8, %ymm7, %ymm3
	vpor	%ymm3, %ymm9, %ymm9
	vpand	%ymm9, %ymm0, %ymm9
	vpsrlw	$4, %ymm7, %ymm3
	vpand	%ymm3, %ymm0, %ymm3
	vmovdqu	%ymm2, (%r8)
	vmovdqu	%ymm5, 32(%r8)
	vmovdqu	%ymm4, 64(%r8)
	vmovdqu	%ymm6, 96(%r8)
	vmovdqu	%ymm1, 128(%r8)
	vmovdqu	%ymm8, 160(%r8)
	vmovdqu	%ymm9, 192(%r8)
	vmovdqu	%ymm3, 224(%r8)
	vmovdqu	192(%r9), %ymm1
	vmovdqu	224(%r9), %ymm2
	vmovdqu	256(%r9), %ymm3
	vmovdqu	288(%r9), %ymm5
	vmovdqu	320(%r9), %ymm6
	vmovdqu	352(%r9), %ymm7
	vperm2i128	$32, %ymm5, %ymm1, %ymm4
	vperm2i128	$49, %ymm5, %ymm1, %ymm5
	vperm2i128	$32, %ymm6, %ymm2, %ymm13
	vperm2i128	$49, %ymm6, %ymm2, %ymm1
	vperm2i128	$32, %ymm7, %ymm3, %ymm2
	vperm2i128	$49, %ymm7, %ymm3, %ymm7
	vpunpcklqdq	%ymm1, %ymm4, %ymm8
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vpunpcklqdq	%ymm2, %ymm5, %ymm6
	vpunpckhqdq	%ymm2, %ymm5, %ymm5
	vpunpcklqdq	%ymm7, %ymm13, %ymm10
	vpunpckhqdq	%ymm7, %ymm13, %ymm2
	vmovsldup	%ymm5, %ymm13
	vpblendd	$170, %ymm13, %ymm8, %ymm3
	vpsrlq	$32, %ymm8, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vmovsldup	%ymm10, %ymm13
	vpblendd	$170, %ymm13, %ymm1, %ymm5
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm10, %ymm1, %ymm7
	vmovsldup	%ymm2, %ymm13
	vpblendd	$170, %ymm13, %ymm6, %ymm1
	vpsrlq	$32, %ymm6, %ymm6
	vpblendd	$170, %ymm2, %ymm6, %ymm2
	vpslld	$16, %ymm7, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm6
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm7, %ymm3, %ymm9
	vpslld	$16, %ymm1, %ymm13
	vpblendw	$170, %ymm13, %ymm4, %ymm13
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm1, %ymm3, %ymm1
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm5, %ymm3
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm2, %ymm5, %ymm7
	vpsrlw	$12, %ymm6, %ymm5
	vpsllw	$4, %ymm9, %ymm4
	vpor	%ymm4, %ymm5, %ymm5
	vpand	%ymm6, %ymm0, %ymm2
	vpand	%ymm5, %ymm0, %ymm5
	vpsrlw	$8, %ymm9, %ymm4
	vpsllw	$8, %ymm13, %ymm6
	vpor	%ymm6, %ymm4, %ymm4
	vpand	%ymm4, %ymm0, %ymm4
	vpsrlw	$4, %ymm13, %ymm6
	vpand	%ymm6, %ymm0, %ymm6
	vpsrlw	$12, %ymm1, %ymm8
	vpsllw	$4, %ymm3, %ymm9
	vpor	%ymm9, %ymm8, %ymm8
	vpand	%ymm1, %ymm0, %ymm1
	vpand	%ymm8, %ymm0, %ymm8
	vpsrlw	$8, %ymm3, %ymm9
	vpsllw	$8, %ymm7, %ymm3
	vpor	%ymm3, %ymm9, %ymm9
	vpand	%ymm9, %ymm0, %ymm9
	vpsrlw	$4, %ymm7, %ymm3
	vpand	%ymm3, %ymm0, %ymm0
	vmovdqu	%ymm2, 256(%r8)
	vmovdqu	%ymm5, 288(%r8)
	vmovdqu	%ymm4, 320(%r8)
	vmovdqu	%ymm6, 352(%r8)
	vmovdqu	%ymm1, 384(%r8)
	vmovdqu	%ymm8, 416(%r8)
	vmovdqu	%ymm9, 448(%r8)
	vmovdqu	%ymm0, 480(%r8)
	ret
.L_poly_basemul_acc_red$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 576(%rip), %ymm1
	vmovdqu	glob_data + 544(%rip), %ymm2
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	(%rsi), %ymm3
	vmovdqu	32(%rsi), %ymm5
	vmovdqu	(%rdi), %ymm4
	vmovdqu	32(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	(%rdx), %ymm3, %ymm3
	vpaddw	32(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, (%rdx)
	vmovdqu	%ymm4, 32(%rdx)
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	64(%rsi), %ymm3
	vmovdqu	96(%rsi), %ymm5
	vmovdqu	64(%rdi), %ymm4
	vmovdqu	96(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	64(%rdx), %ymm3, %ymm3
	vpaddw	96(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	%ymm4, 96(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	128(%rsi), %ymm3
	vmovdqu	160(%rsi), %ymm5
	vmovdqu	128(%rdi), %ymm4
	vmovdqu	160(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	128(%rdx), %ymm3, %ymm3
	vpaddw	160(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 128(%rdx)
	vmovdqu	%ymm4, 160(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	192(%rsi), %ymm3
	vmovdqu	224(%rsi), %ymm5
	vmovdqu	192(%rdi), %ymm4
	vmovdqu	224(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	192(%rdx), %ymm3, %ymm3
	vpaddw	224(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 192(%rdx)
	vmovdqu	%ymm4, 224(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	256(%rsi), %ymm3
	vmovdqu	288(%rsi), %ymm5
	vmovdqu	256(%rdi), %ymm4
	vmovdqu	288(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	256(%rdx), %ymm3, %ymm3
	vpaddw	288(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 256(%rdx)
	vmovdqu	%ymm4, 288(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	320(%rsi), %ymm3
	vmovdqu	352(%rsi), %ymm5
	vmovdqu	320(%rdi), %ymm4
	vmovdqu	352(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	320(%rdx), %ymm3, %ymm3
	vpaddw	352(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 320(%rdx)
	vmovdqu	%ymm4, 352(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	384(%rsi), %ymm3
	vmovdqu	416(%rsi), %ymm5
	vmovdqu	384(%rdi), %ymm4
	vmovdqu	416(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm9
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm9, %ymm6, %ymm9
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm9, %ymm11, %ymm3
	vpaddw	%ymm10, %ymm8, %ymm4
	vpaddw	384(%rdx), %ymm3, %ymm3
	vpaddw	416(%rdx), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 384(%rdx)
	vmovdqu	%ymm4, 416(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	448(%rsi), %ymm3
	vmovdqu	480(%rsi), %ymm5
	vmovdqu	448(%rdi), %ymm4
	vmovdqu	480(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm5, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm11
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm11, %ymm9
	vpmulhw	%ymm0, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm3, %ymm12
	vpsubw	%ymm9, %ymm12, %ymm9
	vpmulhw	%ymm6, %ymm3, %ymm6
	vpsubw	%ymm1, %ymm6, %ymm1
	vpmulhw	%ymm7, %ymm5, %ymm6
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm4, %ymm5, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm8, %ymm9, %ymm3
	vpaddw	%ymm10, %ymm1, %ymm4
	vpaddw	448(%rdx), %ymm3, %ymm1
	vpaddw	480(%rdx), %ymm4, %ymm3
	vpmulhw	%ymm2, %ymm1, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm4
	vmovdqu	%ymm1, 448(%rdx)
	vmovdqu	%ymm4, 480(%rdx)
	ret
.L_poly_basemul_acc$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 576(%rip), %ymm1
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	(%rdi), %ymm4
	vmovdqu	32(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	(%rdx), %ymm3, %ymm3
	vpaddw	32(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, (%rdx)
	vmovdqu	%ymm4, 32(%rdx)
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	64(%rsi), %ymm2
	vmovdqu	96(%rsi), %ymm3
	vmovdqu	64(%rdi), %ymm4
	vmovdqu	96(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	64(%rdx), %ymm3, %ymm3
	vpaddw	96(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	%ymm4, 96(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	128(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm3
	vmovdqu	128(%rdi), %ymm4
	vmovdqu	160(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	128(%rdx), %ymm3, %ymm3
	vpaddw	160(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 128(%rdx)
	vmovdqu	%ymm4, 160(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	192(%rsi), %ymm2
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	192(%rdi), %ymm4
	vmovdqu	224(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	192(%rdx), %ymm3, %ymm3
	vpaddw	224(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 192(%rdx)
	vmovdqu	%ymm4, 224(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	256(%rsi), %ymm2
	vmovdqu	288(%rsi), %ymm3
	vmovdqu	256(%rdi), %ymm4
	vmovdqu	288(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	256(%rdx), %ymm3, %ymm3
	vpaddw	288(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 256(%rdx)
	vmovdqu	%ymm4, 288(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	320(%rsi), %ymm2
	vmovdqu	352(%rsi), %ymm3
	vmovdqu	320(%rdi), %ymm4
	vmovdqu	352(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	320(%rdx), %ymm3, %ymm3
	vpaddw	352(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 320(%rdx)
	vmovdqu	%ymm4, 352(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	384(%rsi), %ymm2
	vmovdqu	416(%rsi), %ymm3
	vmovdqu	384(%rdi), %ymm4
	vmovdqu	416(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vpaddw	384(%rdx), %ymm3, %ymm3
	vpaddw	416(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm3, 384(%rdx)
	vmovdqu	%ymm4, 416(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	448(%rsi), %ymm2
	vmovdqu	480(%rsi), %ymm3
	vmovdqu	448(%rdi), %ymm4
	vmovdqu	480(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm1
	vpmullw	%ymm7, %ymm9, %ymm8
	vpmullw	%ymm4, %ymm9, %ymm10
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm0
	vpsubw	%ymm6, %ymm0, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm0
	vpsubw	%ymm1, %ymm0, %ymm1
	vpmulhw	%ymm7, %ymm3, %ymm0
	vpsubw	%ymm8, %ymm0, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm0
	vpsubw	%ymm10, %ymm0, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm1, %ymm4
	vpaddw	448(%rdx), %ymm3, %ymm1
	vpaddw	480(%rdx), %ymm4, %ymm4
	vmovdqu	%ymm1, 448(%rdx)
	vmovdqu	%ymm4, 480(%rdx)
	ret
.L_poly_basemul$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	glob_data + 576(%rip), %ymm1
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	(%rdi), %ymm4
	vmovdqu	32(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, (%rdx)
	vmovdqu	%ymm4, 32(%rdx)
	vmovdqu	glob_data + 1712(%rip), %ymm7
	vmovdqu	glob_data + 1744(%rip), %ymm8
	vmovdqu	64(%rsi), %ymm2
	vmovdqu	96(%rsi), %ymm3
	vmovdqu	64(%rdi), %ymm4
	vmovdqu	96(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	%ymm4, 96(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	128(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm3
	vmovdqu	128(%rdi), %ymm4
	vmovdqu	160(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 128(%rdx)
	vmovdqu	%ymm4, 160(%rdx)
	vmovdqu	glob_data + 1776(%rip), %ymm7
	vmovdqu	glob_data + 1808(%rip), %ymm8
	vmovdqu	192(%rsi), %ymm2
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	192(%rdi), %ymm4
	vmovdqu	224(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 192(%rdx)
	vmovdqu	%ymm4, 224(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	256(%rsi), %ymm2
	vmovdqu	288(%rsi), %ymm3
	vmovdqu	256(%rdi), %ymm4
	vmovdqu	288(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 256(%rdx)
	vmovdqu	%ymm4, 288(%rdx)
	vmovdqu	glob_data + 2104(%rip), %ymm7
	vmovdqu	glob_data + 2136(%rip), %ymm8
	vmovdqu	320(%rsi), %ymm2
	vmovdqu	352(%rsi), %ymm3
	vmovdqu	320(%rdi), %ymm4
	vmovdqu	352(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 320(%rdx)
	vmovdqu	%ymm4, 352(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	384(%rsi), %ymm2
	vmovdqu	416(%rsi), %ymm3
	vmovdqu	384(%rdi), %ymm4
	vmovdqu	416(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm4, %ymm9, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm8
	vpmulhw	%ymm0, %ymm12, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpsubw	%ymm8, %ymm5, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm5
	vpsubw	%ymm10, %ymm5, %ymm10
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm9, %ymm4
	vmovdqu	%ymm3, 384(%rdx)
	vmovdqu	%ymm4, 416(%rdx)
	vmovdqu	glob_data + 2168(%rip), %ymm7
	vmovdqu	glob_data + 2200(%rip), %ymm8
	vmovdqu	448(%rsi), %ymm2
	vmovdqu	480(%rsi), %ymm3
	vmovdqu	448(%rdi), %ymm4
	vmovdqu	480(%rdi), %ymm5
	vpmullw	%ymm5, %ymm7, %ymm6
	vpmulhw	%ymm5, %ymm8, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm4, %ymm8, %ymm6
	vpmullw	%ymm5, %ymm8, %ymm1
	vpmullw	%ymm7, %ymm9, %ymm8
	vpmullw	%ymm4, %ymm9, %ymm10
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm4, %ymm2, %ymm0
	vpsubw	%ymm6, %ymm0, %ymm6
	vpmulhw	%ymm5, %ymm2, %ymm0
	vpsubw	%ymm1, %ymm0, %ymm1
	vpmulhw	%ymm7, %ymm3, %ymm0
	vpsubw	%ymm8, %ymm0, %ymm2
	vpmulhw	%ymm4, %ymm3, %ymm0
	vpsubw	%ymm10, %ymm0, %ymm10
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm10, %ymm1, %ymm4
	vmovdqu	%ymm3, 448(%rdx)
	vmovdqu	%ymm4, 480(%rdx)
	ret
.L_poly_csubq$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vmovdqu	(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, (%rsi)
	vmovdqu	32(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 32(%rsi)
	vmovdqu	64(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	96(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 96(%rsi)
	vmovdqu	128(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	160(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 160(%rsi)
	vmovdqu	192(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 192(%rsi)
	vmovdqu	224(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 224(%rsi)
	vmovdqu	256(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 256(%rsi)
	vmovdqu	288(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 288(%rsi)
	vmovdqu	320(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	352(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 352(%rsi)
	vmovdqu	384(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	416(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 416(%rsi)
	vmovdqu	448(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqu	%ymm1, 448(%rsi)
	vmovdqu	480(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm5
	vpand	%ymm0, %ymm5, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rsi)
	ret
.L_poly_add2$1:
	vmovdqu	(%rcx), %ymm1
	vmovdqu	(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	32(%rcx), %ymm1
	vmovdqu	32(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 32(%rcx)
	vmovdqu	64(%rcx), %ymm1
	vmovdqu	64(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 64(%rcx)
	vmovdqu	96(%rcx), %ymm1
	vmovdqu	96(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 96(%rcx)
	vmovdqu	128(%rcx), %ymm1
	vmovdqu	128(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rcx)
	vmovdqu	160(%rcx), %ymm1
	vmovdqu	160(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rcx)
	vmovdqu	192(%rcx), %ymm1
	vmovdqu	192(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rcx)
	vmovdqu	224(%rcx), %ymm1
	vmovdqu	224(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rcx)
	vmovdqu	256(%rcx), %ymm1
	vmovdqu	256(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rcx)
	vmovdqu	288(%rcx), %ymm1
	vmovdqu	288(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rcx)
	vmovdqu	320(%rcx), %ymm1
	vmovdqu	320(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rcx)
	vmovdqu	352(%rcx), %ymm1
	vmovdqu	352(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 352(%rcx)
	vmovdqu	384(%rcx), %ymm1
	vmovdqu	384(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 384(%rcx)
	vmovdqu	416(%rcx), %ymm1
	vmovdqu	416(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rcx)
	vmovdqu	448(%rcx), %ymm1
	vmovdqu	448(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 448(%rcx)
	vmovdqu	480(%rcx), %ymm1
	vmovdqu	480(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rcx)
	ret
.L_shake256x4_AETA1__A32_A1$1:
	leaq	32(%rsp), %rax
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %r9
	jmp 	.L_shake256x4_AETA1__A32_A1$11
.L_shake256x4_AETA1__A32_A1$12:
	vmovdqu	%ymm0, (%rax,%r9)
	addq	$32, %r9
.L_shake256x4_AETA1__A32_A1$11:
	cmpq	$800, %r9
	jb  	.L_shake256x4_AETA1__A32_A1$12
	movq	$0, %r9
	movq	$0, %r10
	jmp 	.L_shake256x4_AETA1__A32_A1$9
.L_shake256x4_AETA1__A32_A1$10:
	vpbroadcastq	(%r8,%r9), %ymm0
	addq	$8, %r9
	vpxor	(%rax,%r10), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r10)
	addq	$32, %r10
.L_shake256x4_AETA1__A32_A1$9:
	cmpq	$128, %r10
	jb  	.L_shake256x4_AETA1__A32_A1$10
	movq	%r11, %r8
	leaq	1(%r11), %r9
	leaq	2(%r11), %r10
	leaq	3(%r11), %r11
	movq	$0, %rbx
	movq	$16, %rbp
	jmp 	.L_shake256x4_AETA1__A32_A1$7
.L_shake256x4_AETA1__A32_A1$8:
	movq	(%r8,%rbx), %r12
	xorq	%r12, (%rax,%rbp,8)
	movq	(%r9,%rbx), %r12
	xorq	%r12, 8(%rax,%rbp,8)
	movq	(%r10,%rbx), %r12
	xorq	%r12, 16(%rax,%rbp,8)
	movq	(%r11,%rbx), %r12
	addq	$8, %rbx
	xorq	%r12, 24(%rax,%rbp,8)
	addq	$4, %rbp
.L_shake256x4_AETA1__A32_A1$7:
	cmpq	$16, %rbp
	jb  	.L_shake256x4_AETA1__A32_A1$8
	movq	$0, %r12
	movzbq	(%r8,%rbx), %r8
	orq 	%r8, %r12
	movq	$31, %r8
	shlq	$8, %r8
	orq 	%r8, %r12
	xorq	%r12, (%rax,%rbp,8)
	movq	$0, %r8
	movzbq	(%r9,%rbx), %r9
	orq 	%r9, %r8
	movq	$31, %r9
	shlq	$8, %r9
	orq 	%r9, %r8
	xorq	%r8, 8(%rax,%rbp,8)
	movq	$0, %r8
	movzbq	(%r10,%rbx), %r9
	orq 	%r9, %r8
	movq	$31, %r9
	shlq	$8, %r9
	orq 	%r9, %r8
	xorq	%r8, 16(%rax,%rbp,8)
	movq	$0, %r8
	movzbq	(%r11,%rbx), %r9
	orq 	%r9, %r8
	movq	$31, %r9
	shlq	$8, %r9
	orq 	%r9, %r8
	xorq	%r8, 24(%rax,%rbp,8)
	movq	$-9223372036854775808, %r8
	movq	%r8, 832(%rsp)
	vpbroadcastq	832(%rsp), %ymm0
	vpxor	512(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 512(%rax)
	movq	$0, %r8
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake256x4_AETA1__A32_A1$6:
	movq	$0, %r9
	jmp 	.L_shake256x4_AETA1__A32_A1$4
.L_shake256x4_AETA1__A32_A1$5:
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
.L_shake256x4_AETA1__A32_A1$4:
	cmpq	$128, %r9
	jb  	.L_shake256x4_AETA1__A32_A1$5
	jmp 	.L_shake256x4_AETA1__A32_A1$2
.L_shake256x4_AETA1__A32_A1$3:
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
.L_shake256x4_AETA1__A32_A1$2:
	cmpq	$128, %r9
	jb  	.L_shake256x4_AETA1__A32_A1$3
	ret
.L_shake256_A32__AZCT$1:
	movq	%rdi, %mm1
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
	movq	128(%rdx,%r8), %rcx
	xorq	%rcx, 128(%rax)
	addq	$136, %r8
	movq	%rdx, %mm2
	movq	%r8, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$9:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	$0, %r9
	jmp 	.L_shake256_A32__AZCT$6
.L_shake256_A32__AZCT$7:
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
	movq	128(%rcx,%rdx), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %rdx
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$8:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	%mm4, %r9
	incq	%r9
.L_shake256_A32__AZCT$6:
	cmpq	$7, %r9
	jb  	.L_shake256_A32__AZCT$7
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	movq	$0, %rcx
	movq	$31, %r8
	shlq	$0, %r8
	orq 	%r8, %rcx
	xorq	%rcx, 32(%rax)
	xorb	$128, 135(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %r9
	jmp 	.L_shake256_A32__AZCT$3
.L_shake256_A32__AZCT$4:
	incq	%r9
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	%mm4, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	movq	128(%rax), %rsi
	movq	%rsi, 128(%rcx,%rdx)
	addq	$136, %rdx
.L_shake256_A32__AZCT$3:
	cmpq	$0, %r9
	jb  	.L_shake256_A32__AZCT$4
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	ret
.L_sha3_256A_APK$1:
	movq	%rax, %mm1
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
	movq	128(%rdx,%r8), %rcx
	xorq	%rcx, 128(%rax)
	addq	$136, %r8
	movq	%rdx, %mm2
	movq	%r8, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$9:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	$0, %r9
	jmp 	.L_sha3_256A_APK$6
.L_sha3_256A_APK$7:
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
	movq	128(%rcx,%rdx), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %rdx
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$8:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	%mm4, %r9
	incq	%r9
.L_sha3_256A_APK$6:
	cmpq	$7, %r9
	jb  	.L_sha3_256A_APK$7
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%rdx), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	movq	$0, %rcx
	movq	$6, %r8
	shlq	$0, %r8
	orq 	%r8, %rcx
	xorq	%rcx, 96(%rax)
	xorb	$128, 135(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %r9
	jmp 	.L_sha3_256A_APK$3
.L_sha3_256A_APK$4:
	incq	%r9
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	%mm4, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	movq	128(%rax), %rsi
	movq	%rsi, 128(%rcx,%rdx)
	addq	$136, %rdx
.L_sha3_256A_APK$3:
	cmpq	$0, %r9
	jb  	.L_sha3_256A_APK$4
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	ret
.L_shake128x4_squeeze3blocks$1:
	movq	%rcx, %rdx
	leaq	536(%rcx), %rsi
	leaq	1072(%rcx), %r10
	leaq	1608(%rcx), %rdi
	movq	$0, %r8
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$16:
	movq	$0, %r9
	jmp 	.L_shake128x4_squeeze3blocks$14
.L_shake128x4_squeeze3blocks$15:
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
	vmovdqu	%ymm4, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	vmovdqu	%ymm0, (%r10,%r8)
	vmovdqu	%ymm14, (%rdi,%r8)
	addq	$32, %r8
.L_shake128x4_squeeze3blocks$14:
	cmpq	$160, %r9
	jb  	.L_shake128x4_squeeze3blocks$15
	jmp 	.L_shake128x4_squeeze3blocks$12
.L_shake128x4_squeeze3blocks$13:
	movq	(%rax,%r9,4), %r11
	movq	%r11, (%rdx,%r8)
	movq	8(%rax,%r9,4), %r11
	movq	%r11, (%rsi,%r8)
	movq	16(%rax,%r9,4), %r11
	movq	%r11, (%r10,%r8)
	movq	24(%rax,%r9,4), %r11
	movq	%r11, (%rdi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L_shake128x4_squeeze3blocks$12:
	cmpq	$168, %r9
	jb  	.L_shake128x4_squeeze3blocks$13
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$11:
	movq	$0, %r9
	jmp 	.L_shake128x4_squeeze3blocks$9
.L_shake128x4_squeeze3blocks$10:
	vmovdqu	(%rax,%r9,4), %ymm9
	vmovdqu	32(%rax,%r9,4), %ymm11
	vmovdqu	64(%rax,%r9,4), %ymm0
	vmovdqu	96(%rax,%r9,4), %ymm14
	addq	$32, %r9
	vperm2i128	$32, %ymm0, %ymm9, %ymm4
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm9, %ymm0
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm4, %ymm2
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vpunpcklqdq	%ymm3, %ymm0, %ymm4
	vpunpckhqdq	%ymm3, %ymm0, %ymm3
	vmovdqu	%ymm2, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	vmovdqu	%ymm4, (%r10,%r8)
	vmovdqu	%ymm3, (%rdi,%r8)
	addq	$32, %r8
.L_shake128x4_squeeze3blocks$9:
	cmpq	$160, %r9
	jb  	.L_shake128x4_squeeze3blocks$10
	jmp 	.L_shake128x4_squeeze3blocks$7
.L_shake128x4_squeeze3blocks$8:
	movq	(%rax,%r9,4), %r11
	movq	%r11, (%rdx,%r8)
	movq	8(%rax,%r9,4), %r11
	movq	%r11, (%rsi,%r8)
	movq	16(%rax,%r9,4), %r11
	movq	%r11, (%r10,%r8)
	movq	24(%rax,%r9,4), %r11
	movq	%r11, (%rdi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L_shake128x4_squeeze3blocks$7:
	cmpq	$168, %r9
	jb  	.L_shake128x4_squeeze3blocks$8
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$6:
	movq	$0, %r9
	jmp 	.L_shake128x4_squeeze3blocks$4
.L_shake128x4_squeeze3blocks$5:
	vmovdqu	(%rax,%r9,4), %ymm9
	vmovdqu	32(%rax,%r9,4), %ymm11
	vmovdqu	64(%rax,%r9,4), %ymm0
	vmovdqu	96(%rax,%r9,4), %ymm14
	addq	$32, %r9
	vperm2i128	$32, %ymm0, %ymm9, %ymm2
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm0, %ymm9, %ymm0
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm2, %ymm4
	vpunpckhqdq	%ymm1, %ymm2, %ymm1
	vpunpcklqdq	%ymm3, %ymm0, %ymm2
	vpunpckhqdq	%ymm3, %ymm0, %ymm3
	vmovdqu	%ymm4, (%rdx,%r8)
	vmovdqu	%ymm1, (%rsi,%r8)
	vmovdqu	%ymm2, (%r10,%r8)
	vmovdqu	%ymm3, (%rdi,%r8)
	addq	$32, %r8
.L_shake128x4_squeeze3blocks$4:
	cmpq	$192, %r9
	jb  	.L_shake128x4_squeeze3blocks$5
	jmp 	.L_shake128x4_squeeze3blocks$2
.L_shake128x4_squeeze3blocks$3:
	movq	(%rax,%r9,4), %r11
	movq	%r11, (%rdx,%r8)
	movq	8(%rax,%r9,4), %r11
	movq	%r11, (%rsi,%r8)
	movq	16(%rax,%r9,4), %r11
	movq	%r11, (%r10,%r8)
	movq	24(%rax,%r9,4), %r11
	movq	%r11, (%rdi,%r8)
	addq	$8, %r9
	addq	$8, %r8
.L_shake128x4_squeeze3blocks$2:
	cmpq	$200, %r9
	jb  	.L_shake128x4_squeeze3blocks$3
	ret
.L_shake128_next_state$1:
	movq	%r8, 8(%rsp)
	leaq	336(%r8), %rax
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake128_next_state$2:
	leaq	200(%rsp), %rsp
	movq	8(%rsp), %r8
	lfence
	movq	$0, %rsi
	orq 	%rsi, %r8
	ret
.L_shake128_squeeze3blocks$1:
	movq	%rcx, 8(%rsp)
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake128_squeeze3blocks$4:
	leaq	200(%rsp), %rsp
	movq	8(%rsp), %rcx
	lfence
	movq	$0, %rsi
	orq 	%rsi, %rcx
	movq	$0, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 128(%rcx,%rdx)
	movq	160(%rax), %rsi
	movq	%rsi, 160(%rcx,%rdx)
	addq	$168, %rdx
	movq	%rcx, 8(%rsp)
	movq	%rdx, 16(%rsp)
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake128_squeeze3blocks$3:
	leaq	200(%rsp), %rsp
	movq	8(%rsp), %rcx
	movq	16(%rsp), %rdx
	lfence
	movq	$0, %rsi
	orq 	%rsi, %rcx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%rdx)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 128(%rcx,%rdx)
	movq	160(%rax), %rsi
	movq	%rsi, 160(%rcx,%rdx)
	addq	$168, %rdx
	movq	%rcx, 16(%rsp)
	movq	%rdx, 8(%rsp)
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake128_squeeze3blocks$2:
	leaq	200(%rsp), %rsp
	movq	16(%rsp), %r8
	movq	8(%rsp), %rdx
	lfence
	movq	$0, %rsi
	orq 	%rsi, %r8
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%r8,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%r8,%rdx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%r8,%rdx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%r8,%rdx)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 128(%r8,%rdx)
	vmovdqu	160(%rax), %ymm0
	vmovdqu	%ymm0, 160(%r8,%rdx)
	movq	192(%rax), %rsi
	movq	%rsi, 192(%r8,%rdx)
	ret
.L_shake128x4_absorb_A32_A2$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %r9
	jmp 	.L_shake128x4_absorb_A32_A2$6
.L_shake128x4_absorb_A32_A2$7:
	vmovdqu	%ymm0, (%rax,%r9)
	addq	$32, %r9
.L_shake128x4_absorb_A32_A2$6:
	cmpq	$800, %r9
	jb  	.L_shake128x4_absorb_A32_A2$7
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L_shake128x4_absorb_A32_A2$4
.L_shake128x4_absorb_A32_A2$5:
	vpbroadcastq	(%rcx,%r8), %ymm0
	addq	$8, %r8
	vpxor	(%rax,%rsi), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L_shake128x4_absorb_A32_A2$4:
	cmpq	$128, %rsi
	jb  	.L_shake128x4_absorb_A32_A2$5
	movq	%rdx, %r9
	leaq	2(%rdx), %rcx
	leaq	4(%rdx), %r8
	leaq	6(%rdx), %rdi
	movq	$0, %rdx
	movq	$16, %rsi
	jmp 	.L_shake128x4_absorb_A32_A2$2
.L_shake128x4_absorb_A32_A2$3:
	movq	(%r9,%rdx), %r10
	xorq	%r10, (%rax,%rsi,8)
	movq	(%rcx,%rdx), %r10
	xorq	%r10, 8(%rax,%rsi,8)
	movq	(%r8,%rdx), %r10
	xorq	%r10, 16(%rax,%rsi,8)
	movq	(%rdi,%rdx), %r10
	addq	$8, %rdx
	xorq	%r10, 24(%rax,%rsi,8)
	addq	$4, %rsi
.L_shake128x4_absorb_A32_A2$2:
	cmpq	$16, %rsi
	jb  	.L_shake128x4_absorb_A32_A2$3
	movq	$0, %r10
	movzwq	(%r9,%rdx), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, (%rax,%rsi,8)
	movq	$0, %r10
	movzwq	(%rcx,%rdx), %r9
	orq 	%r9, %r10
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r10
	xorq	%r10, 8(%rax,%rsi,8)
	movq	$0, %r10
	movzwq	(%r8,%rdx), %r9
	orq 	%r9, %r10
	movq	$31, %r8
	shlq	$16, %r8
	orq 	%r8, %r10
	xorq	%r10, 16(%rax,%rsi,8)
	movq	$0, %r8
	movzwq	(%rdi,%rdx), %r9
	orq 	%r9, %r8
	movq	$31, %r9
	shlq	$16, %r9
	orq 	%r9, %r8
	xorq	%r8, 24(%rax,%rsi,8)
	movq	$-9223372036854775808, %r8
	movq	%r8, 8(%rsp)
	vpbroadcastq	8(%rsp), %ymm0
	vpxor	640(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 640(%rax)
	ret
.L_shake128_absorb_A32_A2$1:
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
	movq	$0, %r8
	movq	$0, %rcx
	movzwq	(%rdx,%r8), %r9
	orq 	%r9, %rcx
	movq	$31, %r8
	shlq	$16, %r8
	orq 	%r8, %rcx
	xorq	%rcx, 32(%rax)
	xorb	$128, 167(%rax)
	ret
.L_sha3_512A_A64$1:
	movq	%rdi, %mm1
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
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rdx,%r8), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %rcx
	movq	$6, %r8
	shlq	$0, %r8
	orq 	%r8, %rcx
	xorq	%rcx, 64(%rax)
	xorb	$128, 71(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %r9
	jmp 	.L_sha3_512A_A64$3
.L_sha3_512A_A64$4:
	incq	%r9
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A64$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %rdx
	movq	%mm4, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%rdx)
	movq	64(%rax), %rsi
	movq	%rsi, 64(%rcx,%rdx)
	addq	$72, %rdx
.L_sha3_512A_A64$3:
	cmpq	$0, %r9
	jb  	.L_sha3_512A_A64$4
	movq	%rcx, %mm2
	movq	%rdx, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A64$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	ret
.L_sha3_512A_A33$1:
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
	vmovdqu	(%rdx,%r8), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	movq	$0, %rcx
	movzbq	32(%rdx,%r8), %r8
	orq 	%r8, %rcx
	movq	$6, %r8
	shlq	$8, %r8
	orq 	%r8, %rcx
	xorq	%rcx, 32(%rax)
	xorb	$128, 71(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %rdx
	movq	$0, %r9
	jmp 	.L_sha3_512A_A33$3
.L_sha3_512A_A33$4:
	incq	%r9
	movq	%rdi, %mm2
	movq	%rdx, %mm3
	movq	%r9, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A33$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %rdx
	movq	%mm4, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
	movq	64(%rax), %rsi
	movq	%rsi, 64(%rdi,%rdx)
	addq	$72, %rdx
.L_sha3_512A_A33$3:
	cmpq	$0, %r9
	jb  	.L_sha3_512A_A33$4
	movq	%rdi, %mm2
	movq	%rdx, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A33$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%rdx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%rdx)
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
	leaq	glob_data + 256(%rip), %r9
	leaq	glob_data + 288(%rip), %r11
	leaq	glob_data + 4368(%rip), %rbx
	movq	$0, %rbp
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
	vpbroadcastq	(%rbx,%rbp,8), %ymm0
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
	vpsrlq	$36, %ymm7, %ymm0
	vpsllq	$28, %ymm7, %ymm7
	vmovdqu	%ymm8, 128(%rax)
	vpor	%ymm0, %ymm7, %ymm7
	vpxor	288(%rax), %ymm9, %ymm0
	vpsrlq	$44, %ymm0, %ymm10
	vpsllq	$20, %ymm0, %ymm0
	vpor	%ymm10, %ymm0, %ymm3
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
	vpsrlq	$63, %ymm5, %ymm0
	vpsllq	$1, %ymm5, %ymm5
	vpxor	%ymm8, %ymm6, %ymm13
	vpor	%ymm0, %ymm5, %ymm5
	vpsrlq	$58, %ymm4, %ymm0
	vpxor	%ymm2, %ymm7, %ymm6
	vpsllq	$6, %ymm4, %ymm4
	vmovdqu	%ymm6, 288(%rax)
	vpxor	608(%rax), %ymm9, %ymm2
	vpor	%ymm0, %ymm4, %ymm4
	vpxor	416(%rax), %ymm11, %ymm0
	vpshufb	(%r9), %ymm2, %ymm2
	vpsrlq	$39, %ymm0, %ymm8
	vpsllq	$25, %ymm0, %ymm0
	vpor	%ymm0, %ymm8, %ymm8
	vpandn	%ymm8, %ymm4, %ymm0
	vpandn	%ymm2, %ymm8, %ymm7
	vpxor	%ymm5, %ymm0, %ymm6
	vpxor	640(%rax), %ymm14, %ymm0
	vpxor	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm6, 320(%rax)
	vpsrlq	$46, %ymm0, %ymm6
	vpsllq	$18, %ymm0, %ymm0
	vpor	%ymm0, %ymm6, %ymm3
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
	vpshufb	(%r11), %ymm5, %ymm5
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
	incq	%rbp
	cmpq	$24, %rbp
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
	movq	%r10, %mm0
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
	leaq	glob_data + 4368(%rip), %rbp
	movq	%mm0, %r13
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
	movq	%mm0, %rsi
	leaq	glob_data + 4368(%rip), %r14
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
	movq	%mm0, %rcx
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
.L_nttunpack$1:
	vmovdqu	(%rcx), %ymm2
	vmovdqu	32(%rcx), %ymm4
	vmovdqu	64(%rcx), %ymm5
	vmovdqu	96(%rcx), %ymm6
	vmovdqu	128(%rcx), %ymm3
	vmovdqu	160(%rcx), %ymm7
	vmovdqu	192(%rcx), %ymm8
	vmovdqu	224(%rcx), %ymm10
	vperm2i128	$32, %ymm3, %ymm2, %ymm1
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vperm2i128	$32, %ymm7, %ymm4, %ymm3
	vperm2i128	$49, %ymm7, %ymm4, %ymm4
	vperm2i128	$32, %ymm8, %ymm5, %ymm7
	vperm2i128	$49, %ymm8, %ymm5, %ymm8
	vperm2i128	$32, %ymm10, %ymm6, %ymm11
	vperm2i128	$49, %ymm10, %ymm6, %ymm13
	vpunpcklqdq	%ymm7, %ymm1, %ymm5
	vpunpckhqdq	%ymm7, %ymm1, %ymm6
	vpunpcklqdq	%ymm8, %ymm2, %ymm7
	vpunpckhqdq	%ymm8, %ymm2, %ymm8
	vpunpcklqdq	%ymm11, %ymm3, %ymm1
	vpunpckhqdq	%ymm11, %ymm3, %ymm3
	vpunpcklqdq	%ymm13, %ymm4, %ymm10
	vpunpckhqdq	%ymm13, %ymm4, %ymm11
	vmovsldup	%ymm1, %ymm2
	vpblendd	$170, %ymm2, %ymm5, %ymm4
	vpsrlq	$32, %ymm5, %ymm2
	vpblendd	$170, %ymm1, %ymm2, %ymm1
	vmovsldup	%ymm3, %ymm2
	vpblendd	$170, %ymm2, %ymm6, %ymm2
	vpsrlq	$32, %ymm6, %ymm5
	vpblendd	$170, %ymm3, %ymm5, %ymm3
	vmovsldup	%ymm10, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm5
	vpsrlq	$32, %ymm7, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm6
	vmovsldup	%ymm11, %ymm13
	vpblendd	$170, %ymm13, %ymm8, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm11, %ymm8, %ymm0
	vpslld	$16, %ymm5, %ymm13
	vpblendw	$170, %ymm13, %ymm4, %ymm9
	vpsrld	$16, %ymm4, %ymm11
	vpblendw	$170, %ymm5, %ymm11, %ymm4
	vpslld	$16, %ymm6, %ymm13
	vpblendw	$170, %ymm13, %ymm1, %ymm5
	vpsrld	$16, %ymm1, %ymm11
	vpblendw	$170, %ymm6, %ymm11, %ymm11
	vpslld	$16, %ymm7, %ymm6
	vpblendw	$170, %ymm6, %ymm2, %ymm6
	vpsrld	$16, %ymm2, %ymm1
	vpblendw	$170, %ymm7, %ymm1, %ymm2
	vpslld	$16, %ymm0, %ymm13
	vpblendw	$170, %ymm13, %ymm3, %ymm10
	vpsrld	$16, %ymm3, %ymm1
	vpblendw	$170, %ymm0, %ymm1, %ymm0
	vmovdqu	%ymm9, (%rcx)
	vmovdqu	%ymm4, 32(%rcx)
	vmovdqu	%ymm5, 64(%rcx)
	vmovdqu	%ymm11, 96(%rcx)
	vmovdqu	%ymm6, 128(%rcx)
	vmovdqu	%ymm2, 160(%rcx)
	vmovdqu	%ymm10, 192(%rcx)
	vmovdqu	%ymm0, 224(%rcx)
	vmovdqu	256(%rcx), %ymm2
	vmovdqu	288(%rcx), %ymm4
	vmovdqu	320(%rcx), %ymm5
	vmovdqu	352(%rcx), %ymm6
	vmovdqu	384(%rcx), %ymm3
	vmovdqu	416(%rcx), %ymm7
	vmovdqu	448(%rcx), %ymm8
	vmovdqu	480(%rcx), %ymm10
	vperm2i128	$32, %ymm3, %ymm2, %ymm1
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vperm2i128	$32, %ymm7, %ymm4, %ymm3
	vperm2i128	$49, %ymm7, %ymm4, %ymm4
	vperm2i128	$32, %ymm8, %ymm5, %ymm7
	vperm2i128	$49, %ymm8, %ymm5, %ymm8
	vperm2i128	$32, %ymm10, %ymm6, %ymm11
	vperm2i128	$49, %ymm10, %ymm6, %ymm13
	vpunpcklqdq	%ymm7, %ymm1, %ymm5
	vpunpckhqdq	%ymm7, %ymm1, %ymm6
	vpunpcklqdq	%ymm8, %ymm2, %ymm7
	vpunpckhqdq	%ymm8, %ymm2, %ymm8
	vpunpcklqdq	%ymm11, %ymm3, %ymm1
	vpunpckhqdq	%ymm11, %ymm3, %ymm3
	vpunpcklqdq	%ymm13, %ymm4, %ymm10
	vpunpckhqdq	%ymm13, %ymm4, %ymm11
	vmovsldup	%ymm1, %ymm2
	vpblendd	$170, %ymm2, %ymm5, %ymm4
	vpsrlq	$32, %ymm5, %ymm2
	vpblendd	$170, %ymm1, %ymm2, %ymm1
	vmovsldup	%ymm3, %ymm2
	vpblendd	$170, %ymm2, %ymm6, %ymm2
	vpsrlq	$32, %ymm6, %ymm5
	vpblendd	$170, %ymm3, %ymm5, %ymm3
	vmovsldup	%ymm10, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm5
	vpsrlq	$32, %ymm7, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm6
	vmovsldup	%ymm11, %ymm13
	vpblendd	$170, %ymm13, %ymm8, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm11, %ymm8, %ymm8
	vpslld	$16, %ymm5, %ymm13
	vpblendw	$170, %ymm13, %ymm4, %ymm9
	vpsrld	$16, %ymm4, %ymm11
	vpblendw	$170, %ymm5, %ymm11, %ymm5
	vpslld	$16, %ymm6, %ymm13
	vpblendw	$170, %ymm13, %ymm1, %ymm0
	vpsrld	$16, %ymm1, %ymm1
	vpblendw	$170, %ymm6, %ymm1, %ymm13
	vpslld	$16, %ymm7, %ymm6
	vpblendw	$170, %ymm6, %ymm2, %ymm4
	vpsrld	$16, %ymm2, %ymm1
	vpblendw	$170, %ymm7, %ymm1, %ymm2
	vpslld	$16, %ymm8, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm6
	vpsrld	$16, %ymm3, %ymm1
	vpblendw	$170, %ymm8, %ymm1, %ymm3
	vmovdqu	%ymm9, 256(%rcx)
	vmovdqu	%ymm5, 288(%rcx)
	vmovdqu	%ymm0, 320(%rcx)
	vmovdqu	%ymm13, 352(%rcx)
	vmovdqu	%ymm4, 384(%rcx)
	vmovdqu	%ymm2, 416(%rcx)
	vmovdqu	%ymm6, 448(%rcx)
	vmovdqu	%ymm3, 480(%rcx)
	ret
	.data
	.p2align	5
glob_data:
G$sample_q:
	.byte	  1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13
	.byte	  1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13
G$sample_mask:
	.byte	255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15
	.byte	255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15
G$sample_ones:
	.byte	  1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1
	.byte	  1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1
G$sample_load_shuffle:
	.byte	  0,   1,   1,   2,   3,   4,   4,   5,   6,   7,   7,   8,   9,  10,  10,  11
	.byte	  4,   5,   5,   6,   7,   8,   8,   9,  10,  11,  11,  12,  13,  14,  14,  15
G$pvc_shufbidx_s_du10:
	.byte	  0,   1,   2,   3,   4,   8,   9,  10,  11,  12, 255, 255, 255, 255, 255, 255
	.byte	  9,  10,  11,  12, 255, 255, 255, 255, 255, 255,   0,   1,   2,   3,   4,   8
G$pvd_shufbdidx_s_du10:
	.byte	  0,   1,   1,   2,   2,   3,   3,   4,   5,   6,   6,   7,   7,   8,   8,   9
	.byte	  2,   3,   3,   4,   4,   5,   5,   6,   7,   8,   8,   9,   9,  10,  10,  11
G$pd_jshufbidx_dv4:
	.byte	  0,   0,   0,   0,   1,   1,   1,   1,   2,   2,   2,   2,   3,   3,   3,   3
	.byte	  4,   4,   4,   4,   5,   5,   5,   5,   6,   6,   6,   6,   7,   7,   7,   7
G$pc_permidx_s_dv4:
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   1,   0,   0,   0,   5,   0,   0,   0
	.byte	  2,   0,   0,   0,   6,   0,   0,   0,   3,   0,   0,   0,   7,   0,   0,   0
G$ROL8:
	.byte	  7,   0,   1,   2,   3,   4,   5,   6,  15,   8,   9,  10,  11,  12,  13,  14
	.byte	 23,  16,  17,  18,  19,  20,  21,  22,  31,  24,  25,  26,  27,  28,  29,  30
G$ROL56:
	.byte	  1,   2,   3,   4,   5,   6,   7,   0,   9,  10,  11,  12,  13,  14,  15,   8
	.byte	 17,  18,  19,  20,  21,  22,  23,  16,  25,  26,  27,  28,  29,  30,  31,  24
G$jdmontx16:
	.byte	 73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5
	.byte	 73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5,  73,   5
G$hhqx16:
	.byte	 64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3
	.byte	 64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3,  64,   3
G$hqx16_m1:
	.byte	128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6
	.byte	128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6, 128,   6
G$hqx16_p1:
	.byte	129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6
	.byte	129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6, 129,   6
G$maskx16:
	.byte	255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15
	.byte	255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15, 255,  15
G$jflox16:
	.byte	161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216
	.byte	161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216, 161, 216
G$jfhix16:
	.byte	161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5
	.byte	161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5, 161,   5
G$jvx16:
	.byte	191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78
	.byte	191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78, 191,  78
G$jqinvx16:
	.byte	  1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243
	.byte	  1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243,   1, 243
G$jqx16:
	.byte	  1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13
	.byte	  1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13,   1,  13
G$jzetas_inv_exp:
	.byte	165, 165, 180, 225,  34,  79,  52,  93,  35,  68,  86, 165, 231,  78, 250,  83
	.byte	123, 199,  37,  43,  55,  58, 136,  24, 129, 126,   5, 196, 159, 247, 184, 176
	.byte	165,   6, 180,   5,  34,   9,  52,   1,  35,  11,  86,   3, 231,   9, 250,   5
	.byte	123,   6,  37,  12,  55,   5, 136,   0, 129,  11,   5,   5, 159,  10, 184,   8
	.byte	 15,  68,  67, 162,  29, 144, 108, 132, 102, 213, 230,  87, 254,  30, 161, 215
	.byte	163, 189, 106, 161,  63, 213, 191,  81, 185, 160, 215,  28, 166, 156, 208, 121
	.byte	 15,   7,  67,   9,  29,   9, 108,   0, 102,   3, 230,   5, 254,   4, 161,   4
	.byte	163,   4, 106,   3,  63,   8, 191,   4, 185,   5, 215,   7, 166,  10, 208,   9
	.byte	251,  69,  92,  94,  41, 239,  65, 190, 213,  49, 228, 113,  64, 201, 142, 203
	.byte	183, 184, 247, 117, 141, 220, 150, 110, 195,  34,  15,  62,  90, 110,  85, 178
	.byte	251,   4,  92,  10,  41,   4,  65,  11, 213,   2, 228,   5,  64,   9, 142,   1
	.byte	183,   3, 247,   0, 141,   5, 150,  12, 195,   9,  15,   1,  90,   0,  85,   3
	.byte	 35,  63,  35,  63, 205, 151, 205, 151, 102, 221, 102, 221,   6, 184,   6, 184
	.byte	161, 221, 161, 221,  37,  41,  37,  41,   8, 161,   8, 161, 169, 109, 169, 109
	.byte	 35,   6,  35,   6, 205,   0, 205,   0, 102,  11, 102,  11,   6,   6,   6,   6
	.byte	161,  10, 161,  10,  37,  10,  37,  10,   8,   9,   8,   9, 169,   2, 169,   2
	.byte	 69, 134,  69, 134,  69, 134,  69, 134, 194,  43, 194,  43, 194,  43, 194,  43
	.byte	178, 250, 178, 250, 178, 250, 178, 250,  63, 214,  63, 214,  63, 214,  63, 214
	.byte	 69,   7,  69,   7,  69,   7,  69,   7, 194,   5, 194,   5, 194,   5, 194,   5
	.byte	178,   4, 178,   4, 178,   4, 178,   4,  63,   9,  63,   9,  63,   9,  63,   9
	.byte	 55,  65,  55,  65,  55,  65,  55,  65,  55,  65,  55,  65,  55,  65,  55,  65
	.byte	226, 145, 226, 145, 226, 145, 226, 145, 226, 145, 226, 145, 226, 145, 226, 145
	.byte	 55,  12,  55,  12,  55,  12,  55,  12,  55,  12,  55,  12,  55,  12,  55,  12
	.byte	226,  11, 226,  11, 226,  11, 226,  11, 226,  11, 226,  11, 226,  11, 226,  11
	.byte	237, 252, 237, 252, 237,   5, 237,   5,  75,  49, 184, 179, 164, 183, 125, 177
	.byte	162, 206,  54,  73, 147, 137, 247, 126, 140, 234, 204, 165, 235,  17, 182, 204
	.byte	152,  84, 154,  55, 182, 203,  83, 212,  75,   0, 184,  11, 164,  11, 125,  10
	.byte	162,   8,  54,   7, 147,   0, 247,   9, 140,   6, 204,   1, 235,   0, 182,  10
	.byte	152,  12, 154,   9, 182,   9,  83,  11, 156,  20,  95,  56, 104, 187,  54,  72
	.byte	 90, 112,   9, 142, 122, 214, 246, 130, 219, 231,  35,  58,  80, 252,  91, 108
	.byte	243, 175, 227, 125, 214,  44,  79,   1, 156,   0,  95,  11, 104,   3,  54,   6
	.byte	 90,   2,   9,   3, 122,   8, 246,   0, 219,   6,  35,   1,  80,  12,  91,  11
	.byte	243,   6, 227,   4, 214,  10,  79,   4,  68, 147, 131, 101, 138,   2,  82, 220
	.byte	154,  48,  64, 193,   8, 152, 253,  49,   8, 158,  26, 175,  46, 177,  13,  92
	.byte	 10, 135,  40, 250, 117,  25,  58,  22,  68,   7, 131,  12, 138,   4,  82,   6
	.byte	154,   2,  64,   1,   8,   0, 253,  10,   8,   6,  26,   1,  46,   7,  13,   5
	.byte	 10,   9,  40,   2, 117,  10,  58,   8, 130, 102, 130, 102,  66, 172,  66, 172
	.byte	 79,   4,  79,   4,  61, 234,  61, 234, 130, 113, 130, 113, 249, 102, 249, 102
	.byte	 45, 188,  45, 188, 196,  22, 196,  22, 130,   0, 130,   0,  66,   6,  66,   6
	.byte	 79,   7,  79,   7,  61,   3,  61,   3, 130,  11, 130,  11, 249,  11, 249,  11
	.byte	 45,   5,  45,   5, 196,  10, 196,  10,  75,  61,  75,  61,  75,  61,  75,  61
	.byte	216,  14, 216,  14, 216,  14, 216,  14, 147, 147, 147, 147, 147, 147, 147, 147
	.byte	171,  81, 171,  81, 171,  81, 171,  81,  75,  12,  75,  12,  75,  12,  75,  12
	.byte	216,   6, 216,   6, 216,   6, 216,   6, 147,  10, 147,  10, 147,  10, 147,  10
	.byte	171,   0, 171,   0, 171,   0, 171,   0, 115,  48, 115,  48, 115,  48, 115,  48
	.byte	115,  48, 115,  48, 115,  48, 115,  48,  44, 203,  44, 203,  44, 203,  44, 203
	.byte	 44, 203,  44, 203,  44, 203,  44, 203, 115,   7, 115,   7, 115,   7, 115,   7
	.byte	115,   7, 115,   7, 115,   7, 115,   7,  44,   7,  44,   7,  44,   7,  44,   7
	.byte	 44,   7,  44,   7,  44,   7,  44,   7, 103, 198, 103, 198, 103,   1, 103,   1
	.byte	140, 235, 140, 235, 140,   7, 140,   7,   0,   0,   0,   0,   0,   0,   0,   0
G$jzetas_exp:
	.byte	 11, 123,  11, 123,  11,  10,  11,  10, 154,  57, 154,  57, 154,  11, 154,  11
	.byte	213,  52, 213,  52, 213,  52, 213,  52, 213,  52, 213,  52, 213,  52, 213,  52
	.byte	142, 207, 142, 207, 142, 207, 142, 207, 142, 207, 142, 207, 142, 207, 142, 207
	.byte	213,   5, 213,   5, 213,   5, 213,   5, 213,   5, 213,   5, 213,   5, 213,   5
	.byte	142,   5, 142,   5, 142,   5, 142,   5, 142,   5, 142,   5, 142,   5, 142,   5
	.byte	 86, 174,  86, 174,  86, 174,  86, 174, 110, 108, 110, 108, 110, 108, 110, 108
	.byte	 41, 241,  41, 241,  41, 241,  41, 241, 182, 194, 182, 194, 182, 194, 182, 194
	.byte	 86,  12,  86,  12,  86,  12,  86,  12, 110,   2, 110,   2, 110,   2, 110,   2
	.byte	 41,   6,  41,   6,  41,   6,  41,   6, 182,   0, 182,   0, 182,   0, 182,   0
	.byte	 61, 233,  61, 233, 212,  67, 212,  67,   8, 153,   8, 153, 127, 142, 127, 142
	.byte	196,  21, 196,  21, 178, 251, 178, 251, 191,  83, 191,  83, 127, 153, 127, 153
	.byte	 61,   2,  61,   2, 212,   7, 212,   7,   8,   1,   8,   1, 127,   1, 127,   1
	.byte	196,   9, 196,   9, 178,   5, 178,   5, 191,   6, 191,   6, 127,  12, 127,  12
	.byte	199, 233, 140, 230, 217,   5, 247, 120, 244, 163, 211,  78, 231,  80, 249,  97
	.byte	  4, 206, 249, 103, 193,  62, 103, 207, 175,  35, 119, 253, 126, 154, 189, 108
	.byte	199,   4, 140,   2, 217,  10, 247,   3, 244,   7, 211,   5, 231,  11, 249,   6
	.byte	  4,   2, 249,  12, 193,  11, 103,  10, 175,   6, 119,   8, 126,   0, 189,   5
	.byte	178, 254,  43, 211,  30, 130,  14,  80, 166, 147, 177,   3, 222, 197,  38,  24
	.byte	 11, 125, 135,  41, 248, 113, 167, 143, 203, 183, 153,  68, 162, 199, 101, 235
	.byte	178,   8,  43,   2,  30,   8,  14,   6, 166,   1, 177,   0, 222,  11,  38,   6
	.byte	 11,  12, 135,   4, 248,   9, 167,  10, 203,   6, 153,   9, 162,   1, 101,  12
	.byte	174,  43,  75,  52, 103, 200, 105, 171,  75,  51,  22, 238,  53,  90, 117,  21
	.byte	 10, 129, 110, 118, 203, 182,  95,  49, 132,  78,  93,  72,  73,  76, 182, 206
	.byte	174,   1,  75,   3, 103,   3, 105,   0,  75,   2,  22,  12,  53,  11, 117,   6
	.byte	 10,   3, 110,  12, 203,   5,  95,   4, 132,   2,  93,   1,  73,   1, 182,  12
	.byte	 20,   3,  20,   3,  20,   7,  20,   7,  31, 110,  31, 110,  31, 110,  31, 110
	.byte	 31, 110,  31, 110,  31, 110,  31, 110, 202, 190, 202, 190, 202, 190, 202, 190
	.byte	202, 190, 202, 190, 202, 190, 202, 190,  31,   1,  31,   1,  31,   1,  31,   1
	.byte	 31,   1,  31,   1,  31,   1,  31,   1, 202,   0, 202,   0, 202,   0, 202,   0
	.byte	202,   0, 202,   0, 202,   0, 202,   0, 194,  41, 194,  41, 194,  41, 194,  41
	.byte	 79,   5,  79,   5,  79,   5,  79,   5,  63, 212,  63, 212,  63, 212,  63, 212
	.byte	188, 121, 188, 121, 188, 121, 188, 121, 194,   3, 194,   3, 194,   3, 194,   3
	.byte	 79,   8,  79,   8,  79,   8,  79,   8,  63,   7,  63,   7,  63,   7,  63,   7
	.byte	188,   5, 188,   5, 188,   5, 188,   5,  88, 146,  88, 146, 249,  94, 249,  94
	.byte	220, 214, 220, 214,  96,  34,  96,  34, 251,  71, 251,  71, 155,  34, 155,  34
	.byte	 52, 104,  52, 104, 222, 192, 222, 192,  88,  10,  88,  10, 249,   3, 249,   3
	.byte	220,   2, 220,   2,  96,   2,  96,   2, 251,   6, 251,   6, 155,   1, 155,   1
	.byte	 52,  12,  52,  12, 222,   6, 222,   6, 172,  77, 167, 145, 242, 193,  62, 221
	.byte	107, 145, 116,  35,  10, 138,  74,  71, 115,  52, 193,  54,  29, 142,  44, 206
	.byte	192,  65, 216,  16, 165, 161,   6, 186, 172,   9, 167,  12, 242,  11,  62,   3
	.byte	107,   0, 116,   7,  10,  12,  74,   9, 115,  11, 193,   3,  29,   7,  44,  10
	.byte	192,   1, 216,   8, 165,   2,   6,   8,  49, 134,  91,  99,  42, 227,  72,  95
	.byte	 66, 174, 194,  42, 151,  94,  94,  66,  96,  40,   3, 225,  27, 168, 155,  42
	.byte	149, 123, 228, 111, 190,  93, 242, 187,  49,   3,  91,   2,  42,   5,  72,   7
	.byte	 66,   8, 194,   4, 151,   9,  94,   8,  96,   8,   3,   8,  27,   7, 155,   9
	.byte	149,  12, 228,   3, 190,   3, 242,   5,  73,  79,  98,   8, 252,  59, 128, 129
	.byte	121, 231, 202, 197, 220, 212, 134,  56,   7, 172,  26, 177, 171,  90, 222, 187
	.byte	205, 162, 223, 176,  77,  30,  92,  90,  73,   4,  98,   2, 252,   7, 128,   1
	.byte	121,  12, 202,   7, 220,   0, 134,   6,   7,   7,  26,   3, 171,   9, 222,   1
	.byte	205,  11, 223,   3,  77,   7,  92,   6,   0,   0,   0,   0,   0,   0,   0,   0
G$pfm_idx_s:
	.byte	  0,   1,   4,   5,   8,   9,  12,  13,   2,   3,   6,   7,  10,  11,  14,  15
G$pfm_shift_s:
	.byte	  3,   0,   0,   0,   2,   0,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0
G$sample_shuffle_table:
	.byte	255, 255, 255, 255, 255, 255, 255, 255,   0, 255, 255, 255, 255, 255, 255, 255
	.byte	  2, 255, 255, 255, 255, 255, 255, 255,   0,   2, 255, 255, 255, 255, 255, 255
	.byte	  4, 255, 255, 255, 255, 255, 255, 255,   0,   4, 255, 255, 255, 255, 255, 255
	.byte	  2,   4, 255, 255, 255, 255, 255, 255,   0,   2,   4, 255, 255, 255, 255, 255
	.byte	  6, 255, 255, 255, 255, 255, 255, 255,   0,   6, 255, 255, 255, 255, 255, 255
	.byte	  2,   6, 255, 255, 255, 255, 255, 255,   0,   2,   6, 255, 255, 255, 255, 255
	.byte	  4,   6, 255, 255, 255, 255, 255, 255,   0,   4,   6, 255, 255, 255, 255, 255
	.byte	  2,   4,   6, 255, 255, 255, 255, 255,   0,   2,   4,   6, 255, 255, 255, 255
	.byte	  8, 255, 255, 255, 255, 255, 255, 255,   0,   8, 255, 255, 255, 255, 255, 255
	.byte	  2,   8, 255, 255, 255, 255, 255, 255,   0,   2,   8, 255, 255, 255, 255, 255
	.byte	  4,   8, 255, 255, 255, 255, 255, 255,   0,   4,   8, 255, 255, 255, 255, 255
	.byte	  2,   4,   8, 255, 255, 255, 255, 255,   0,   2,   4,   8, 255, 255, 255, 255
	.byte	  6,   8, 255, 255, 255, 255, 255, 255,   0,   6,   8, 255, 255, 255, 255, 255
	.byte	  2,   6,   8, 255, 255, 255, 255, 255,   0,   2,   6,   8, 255, 255, 255, 255
	.byte	  4,   6,   8, 255, 255, 255, 255, 255,   0,   4,   6,   8, 255, 255, 255, 255
	.byte	  2,   4,   6,   8, 255, 255, 255, 255,   0,   2,   4,   6,   8, 255, 255, 255
	.byte	 10, 255, 255, 255, 255, 255, 255, 255,   0,  10, 255, 255, 255, 255, 255, 255
	.byte	  2,  10, 255, 255, 255, 255, 255, 255,   0,   2,  10, 255, 255, 255, 255, 255
	.byte	  4,  10, 255, 255, 255, 255, 255, 255,   0,   4,  10, 255, 255, 255, 255, 255
	.byte	  2,   4,  10, 255, 255, 255, 255, 255,   0,   2,   4,  10, 255, 255, 255, 255
	.byte	  6,  10, 255, 255, 255, 255, 255, 255,   0,   6,  10, 255, 255, 255, 255, 255
	.byte	  2,   6,  10, 255, 255, 255, 255, 255,   0,   2,   6,  10, 255, 255, 255, 255
	.byte	  4,   6,  10, 255, 255, 255, 255, 255,   0,   4,   6,  10, 255, 255, 255, 255
	.byte	  2,   4,   6,  10, 255, 255, 255, 255,   0,   2,   4,   6,  10, 255, 255, 255
	.byte	  8,  10, 255, 255, 255, 255, 255, 255,   0,   8,  10, 255, 255, 255, 255, 255
	.byte	  2,   8,  10, 255, 255, 255, 255, 255,   0,   2,   8,  10, 255, 255, 255, 255
	.byte	  4,   8,  10, 255, 255, 255, 255, 255,   0,   4,   8,  10, 255, 255, 255, 255
	.byte	  2,   4,   8,  10, 255, 255, 255, 255,   0,   2,   4,   8,  10, 255, 255, 255
	.byte	  6,   8,  10, 255, 255, 255, 255, 255,   0,   6,   8,  10, 255, 255, 255, 255
	.byte	  2,   6,   8,  10, 255, 255, 255, 255,   0,   2,   6,   8,  10, 255, 255, 255
	.byte	  4,   6,   8,  10, 255, 255, 255, 255,   0,   4,   6,   8,  10, 255, 255, 255
	.byte	  2,   4,   6,   8,  10, 255, 255, 255,   0,   2,   4,   6,   8,  10, 255, 255
	.byte	 12, 255, 255, 255, 255, 255, 255, 255,   0,  12, 255, 255, 255, 255, 255, 255
	.byte	  2,  12, 255, 255, 255, 255, 255, 255,   0,   2,  12, 255, 255, 255, 255, 255
	.byte	  4,  12, 255, 255, 255, 255, 255, 255,   0,   4,  12, 255, 255, 255, 255, 255
	.byte	  2,   4,  12, 255, 255, 255, 255, 255,   0,   2,   4,  12, 255, 255, 255, 255
	.byte	  6,  12, 255, 255, 255, 255, 255, 255,   0,   6,  12, 255, 255, 255, 255, 255
	.byte	  2,   6,  12, 255, 255, 255, 255, 255,   0,   2,   6,  12, 255, 255, 255, 255
	.byte	  4,   6,  12, 255, 255, 255, 255, 255,   0,   4,   6,  12, 255, 255, 255, 255
	.byte	  2,   4,   6,  12, 255, 255, 255, 255,   0,   2,   4,   6,  12, 255, 255, 255
	.byte	  8,  12, 255, 255, 255, 255, 255, 255,   0,   8,  12, 255, 255, 255, 255, 255
	.byte	  2,   8,  12, 255, 255, 255, 255, 255,   0,   2,   8,  12, 255, 255, 255, 255
	.byte	  4,   8,  12, 255, 255, 255, 255, 255,   0,   4,   8,  12, 255, 255, 255, 255
	.byte	  2,   4,   8,  12, 255, 255, 255, 255,   0,   2,   4,   8,  12, 255, 255, 255
	.byte	  6,   8,  12, 255, 255, 255, 255, 255,   0,   6,   8,  12, 255, 255, 255, 255
	.byte	  2,   6,   8,  12, 255, 255, 255, 255,   0,   2,   6,   8,  12, 255, 255, 255
	.byte	  4,   6,   8,  12, 255, 255, 255, 255,   0,   4,   6,   8,  12, 255, 255, 255
	.byte	  2,   4,   6,   8,  12, 255, 255, 255,   0,   2,   4,   6,   8,  12, 255, 255
	.byte	 10,  12, 255, 255, 255, 255, 255, 255,   0,  10,  12, 255, 255, 255, 255, 255
	.byte	  2,  10,  12, 255, 255, 255, 255, 255,   0,   2,  10,  12, 255, 255, 255, 255
	.byte	  4,  10,  12, 255, 255, 255, 255, 255,   0,   4,  10,  12, 255, 255, 255, 255
	.byte	  2,   4,  10,  12, 255, 255, 255, 255,   0,   2,   4,  10,  12, 255, 255, 255
	.byte	  6,  10,  12, 255, 255, 255, 255, 255,   0,   6,  10,  12, 255, 255, 255, 255
	.byte	  2,   6,  10,  12, 255, 255, 255, 255,   0,   2,   6,  10,  12, 255, 255, 255
	.byte	  4,   6,  10,  12, 255, 255, 255, 255,   0,   4,   6,  10,  12, 255, 255, 255
	.byte	  2,   4,   6,  10,  12, 255, 255, 255,   0,   2,   4,   6,  10,  12, 255, 255
	.byte	  8,  10,  12, 255, 255, 255, 255, 255,   0,   8,  10,  12, 255, 255, 255, 255
	.byte	  2,   8,  10,  12, 255, 255, 255, 255,   0,   2,   8,  10,  12, 255, 255, 255
	.byte	  4,   8,  10,  12, 255, 255, 255, 255,   0,   4,   8,  10,  12, 255, 255, 255
	.byte	  2,   4,   8,  10,  12, 255, 255, 255,   0,   2,   4,   8,  10,  12, 255, 255
	.byte	  6,   8,  10,  12, 255, 255, 255, 255,   0,   6,   8,  10,  12, 255, 255, 255
	.byte	  2,   6,   8,  10,  12, 255, 255, 255,   0,   2,   6,   8,  10,  12, 255, 255
	.byte	  4,   6,   8,  10,  12, 255, 255, 255,   0,   4,   6,   8,  10,  12, 255, 255
	.byte	  2,   4,   6,   8,  10,  12, 255, 255,   0,   2,   4,   6,   8,  10,  12, 255
	.byte	 14, 255, 255, 255, 255, 255, 255, 255,   0,  14, 255, 255, 255, 255, 255, 255
	.byte	  2,  14, 255, 255, 255, 255, 255, 255,   0,   2,  14, 255, 255, 255, 255, 255
	.byte	  4,  14, 255, 255, 255, 255, 255, 255,   0,   4,  14, 255, 255, 255, 255, 255
	.byte	  2,   4,  14, 255, 255, 255, 255, 255,   0,   2,   4,  14, 255, 255, 255, 255
	.byte	  6,  14, 255, 255, 255, 255, 255, 255,   0,   6,  14, 255, 255, 255, 255, 255
	.byte	  2,   6,  14, 255, 255, 255, 255, 255,   0,   2,   6,  14, 255, 255, 255, 255
	.byte	  4,   6,  14, 255, 255, 255, 255, 255,   0,   4,   6,  14, 255, 255, 255, 255
	.byte	  2,   4,   6,  14, 255, 255, 255, 255,   0,   2,   4,   6,  14, 255, 255, 255
	.byte	  8,  14, 255, 255, 255, 255, 255, 255,   0,   8,  14, 255, 255, 255, 255, 255
	.byte	  2,   8,  14, 255, 255, 255, 255, 255,   0,   2,   8,  14, 255, 255, 255, 255
	.byte	  4,   8,  14, 255, 255, 255, 255, 255,   0,   4,   8,  14, 255, 255, 255, 255
	.byte	  2,   4,   8,  14, 255, 255, 255, 255,   0,   2,   4,   8,  14, 255, 255, 255
	.byte	  6,   8,  14, 255, 255, 255, 255, 255,   0,   6,   8,  14, 255, 255, 255, 255
	.byte	  2,   6,   8,  14, 255, 255, 255, 255,   0,   2,   6,   8,  14, 255, 255, 255
	.byte	  4,   6,   8,  14, 255, 255, 255, 255,   0,   4,   6,   8,  14, 255, 255, 255
	.byte	  2,   4,   6,   8,  14, 255, 255, 255,   0,   2,   4,   6,   8,  14, 255, 255
	.byte	 10,  14, 255, 255, 255, 255, 255, 255,   0,  10,  14, 255, 255, 255, 255, 255
	.byte	  2,  10,  14, 255, 255, 255, 255, 255,   0,   2,  10,  14, 255, 255, 255, 255
	.byte	  4,  10,  14, 255, 255, 255, 255, 255,   0,   4,  10,  14, 255, 255, 255, 255
	.byte	  2,   4,  10,  14, 255, 255, 255, 255,   0,   2,   4,  10,  14, 255, 255, 255
	.byte	  6,  10,  14, 255, 255, 255, 255, 255,   0,   6,  10,  14, 255, 255, 255, 255
	.byte	  2,   6,  10,  14, 255, 255, 255, 255,   0,   2,   6,  10,  14, 255, 255, 255
	.byte	  4,   6,  10,  14, 255, 255, 255, 255,   0,   4,   6,  10,  14, 255, 255, 255
	.byte	  2,   4,   6,  10,  14, 255, 255, 255,   0,   2,   4,   6,  10,  14, 255, 255
	.byte	  8,  10,  14, 255, 255, 255, 255, 255,   0,   8,  10,  14, 255, 255, 255, 255
	.byte	  2,   8,  10,  14, 255, 255, 255, 255,   0,   2,   8,  10,  14, 255, 255, 255
	.byte	  4,   8,  10,  14, 255, 255, 255, 255,   0,   4,   8,  10,  14, 255, 255, 255
	.byte	  2,   4,   8,  10,  14, 255, 255, 255,   0,   2,   4,   8,  10,  14, 255, 255
	.byte	  6,   8,  10,  14, 255, 255, 255, 255,   0,   6,   8,  10,  14, 255, 255, 255
	.byte	  2,   6,   8,  10,  14, 255, 255, 255,   0,   2,   6,   8,  10,  14, 255, 255
	.byte	  4,   6,   8,  10,  14, 255, 255, 255,   0,   4,   6,   8,  10,  14, 255, 255
	.byte	  2,   4,   6,   8,  10,  14, 255, 255,   0,   2,   4,   6,   8,  10,  14, 255
	.byte	 12,  14, 255, 255, 255, 255, 255, 255,   0,  12,  14, 255, 255, 255, 255, 255
	.byte	  2,  12,  14, 255, 255, 255, 255, 255,   0,   2,  12,  14, 255, 255, 255, 255
	.byte	  4,  12,  14, 255, 255, 255, 255, 255,   0,   4,  12,  14, 255, 255, 255, 255
	.byte	  2,   4,  12,  14, 255, 255, 255, 255,   0,   2,   4,  12,  14, 255, 255, 255
	.byte	  6,  12,  14, 255, 255, 255, 255, 255,   0,   6,  12,  14, 255, 255, 255, 255
	.byte	  2,   6,  12,  14, 255, 255, 255, 255,   0,   2,   6,  12,  14, 255, 255, 255
	.byte	  4,   6,  12,  14, 255, 255, 255, 255,   0,   4,   6,  12,  14, 255, 255, 255
	.byte	  2,   4,   6,  12,  14, 255, 255, 255,   0,   2,   4,   6,  12,  14, 255, 255
	.byte	  8,  12,  14, 255, 255, 255, 255, 255,   0,   8,  12,  14, 255, 255, 255, 255
	.byte	  2,   8,  12,  14, 255, 255, 255, 255,   0,   2,   8,  12,  14, 255, 255, 255
	.byte	  4,   8,  12,  14, 255, 255, 255, 255,   0,   4,   8,  12,  14, 255, 255, 255
	.byte	  2,   4,   8,  12,  14, 255, 255, 255,   0,   2,   4,   8,  12,  14, 255, 255
	.byte	  6,   8,  12,  14, 255, 255, 255, 255,   0,   6,   8,  12,  14, 255, 255, 255
	.byte	  2,   6,   8,  12,  14, 255, 255, 255,   0,   2,   6,   8,  12,  14, 255, 255
	.byte	  4,   6,   8,  12,  14, 255, 255, 255,   0,   4,   6,   8,  12,  14, 255, 255
	.byte	  2,   4,   6,   8,  12,  14, 255, 255,   0,   2,   4,   6,   8,  12,  14, 255
	.byte	 10,  12,  14, 255, 255, 255, 255, 255,   0,  10,  12,  14, 255, 255, 255, 255
	.byte	  2,  10,  12,  14, 255, 255, 255, 255,   0,   2,  10,  12,  14, 255, 255, 255
	.byte	  4,  10,  12,  14, 255, 255, 255, 255,   0,   4,  10,  12,  14, 255, 255, 255
	.byte	  2,   4,  10,  12,  14, 255, 255, 255,   0,   2,   4,  10,  12,  14, 255, 255
	.byte	  6,  10,  12,  14, 255, 255, 255, 255,   0,   6,  10,  12,  14, 255, 255, 255
	.byte	  2,   6,  10,  12,  14, 255, 255, 255,   0,   2,   6,  10,  12,  14, 255, 255
	.byte	  4,   6,  10,  12,  14, 255, 255, 255,   0,   4,   6,  10,  12,  14, 255, 255
	.byte	  2,   4,   6,  10,  12,  14, 255, 255,   0,   2,   4,   6,  10,  12,  14, 255
	.byte	  8,  10,  12,  14, 255, 255, 255, 255,   0,   8,  10,  12,  14, 255, 255, 255
	.byte	  2,   8,  10,  12,  14, 255, 255, 255,   0,   2,   8,  10,  12,  14, 255, 255
	.byte	  4,   8,  10,  12,  14, 255, 255, 255,   0,   4,   8,  10,  12,  14, 255, 255
	.byte	  2,   4,   8,  10,  12,  14, 255, 255,   0,   2,   4,   8,  10,  12,  14, 255
	.byte	  6,   8,  10,  12,  14, 255, 255, 255,   0,   6,   8,  10,  12,  14, 255, 255
	.byte	  2,   6,   8,  10,  12,  14, 255, 255,   0,   2,   6,   8,  10,  12,  14, 255
	.byte	  4,   6,   8,  10,  12,  14, 255, 255,   0,   4,   6,   8,  10,  12,  14, 255
	.byte	  2,   4,   6,   8,  10,  12,  14, 255,   0,   2,   4,   6,   8,  10,  12,  14
G$pvc_sllvdidx_s_du11:
	.byte	 10,   0,   0,   0,   0,   0,   0,   0
G$pvc_shift2_s_du11:
	.byte	  1,   0,   0,   8,   1,   0,   0,   8
G$pvc_sllvdidx_s_du10:
	.byte	 12,   0,   0,   0,   0,   0,   0,   0
G$pvc_shift2_s_du10:
	.byte	  1,   0,   0,   4,   1,   0,   0,   4
G$pvd_sllvdidx_s_du10:
	.byte	  4,   0,   0,   0,   0,   0,   0,   0
G$pc_sllvdidx_s_dv5:
	.byte	 12,   0,   0,   0,   0,   0,   0,   0
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
G$gen_matrix_indexes:
	.byte	  0,   0,   1,   0,   2,   0,   0,   1,   1,   1,   2,   1,   0,   2,   1,   2
	.byte	  0,   0,   0,   1,   0,   2,   1,   0,   1,   1,   1,   2,   2,   0,   2,   1
G$pvd_mask_s_du10:
	.byte	248,  31, 224, 127
G$pvd_q_s_du10:
	.byte	  4,  52,   1,  13
G$pc_shift3_s_dv5:
	.byte	  1,   0,   0,   4
G$pd_shift_s_dv4:
	.byte	  0,   8, 128,   0
G$pd_mask_s_dv4:
	.byte	 15,   0, 240,   0
G$pvc_mask_s_du11:
	.byte	255,   7
G$pvc_shift1_s_du11:
	.byte	  0,  32
G$pvc_off_s_du11:
	.byte	 36,   0
G$pvd_mask_s_du11:
	.byte	240, 127
G$pvc_mask_s_du10:
	.byte	255,   3
G$pvc_shift1_s_du10:
	.byte	  0,  16
G$pvc_off_s_du10:
	.byte	 15,   0
G$pc_shift2_s_dv5:
	.byte	  1,  32
G$pc_shift1_s_dv5:
	.byte	  0,   4
G$pc_mask_s_dv5:
	.byte	 31,   0
G$pc_shift2_s_dv4:
	.byte	  1,  16
G$pc_mask_s_dv4:
	.byte	 15,   0
G$pc_shift1_s_dv4:
	.byte	  0,   2
G$pvc_shufbidx_s_du11:
	.byte	  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10, 255, 255, 255, 255, 255
	.byte	  5,   6,   7,   8,   9,  10, 255, 255, 255, 255,   0,   0,   1,   2,   3,   4
G$pvc_srlvqidx_du11:
	.byte	 10,   0,   0,   0,   0,   0,   0,   0,  30,   0,   0,   0,   0,   0,   0,   0
	.byte	 10,   0,   0,   0,   0,   0,   0,   0,  30,   0,   0,   0,   0,   0,   0,   0
G$pvd_shift_s_du11:
	.byte	 32,   0,   4,   0,   1,   0,  32,   0,   8,   0,   1,   0,  32,   0,   4,   0
	.byte	 32,   0,   4,   0,   1,   0,  32,   0,   8,   0,   1,   0,  32,   0,   4,   0
G$pvd_srlvqidx_s_du11:
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0
G$pvd_srlvdidx_s_du11:
	.byte	  0,   0,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
	.byte	  0,   0,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
G$pvd_shufbidx_s_du11:
	.byte	  0,   1,   1,   2,   2,   3,   4,   5,   5,   6,   6,   7,   8,   9,   9,  10
	.byte	  3,   4,   4,   5,   5,   6,   7,   8,   8,   9,   9,  10,  11,  12,  12,  13
G$pd_shift_s_dv5:
	.byte	  0,   4,  32,   0,   0,   1,   8,   0,  64,   0,   0,   2,  16,   0, 128,   0
	.byte	  0,   4,  32,   0,   0,   1,   8,   0,  64,   0,   0,   2,  16,   0, 128,   0
G$pd_mask_s_dv5:
	.byte	 31,   0, 224,   3, 124,   0, 128,  15, 240,   1,  62,   0, 192,   7, 248,   0
	.byte	 31,   0, 224,   3, 124,   0, 128,  15, 240,   1,  62,   0, 192,   7, 248,   0
G$pd_jshufbidx_dv5:
	.byte	  0,   0,   0,   1,   1,   1,   1,   2,   2,   3,   3,   3,   3,   4,   4,   4
	.byte	  5,   5,   5,   6,   6,   6,   6,   7,   7,   8,   8,   8,   8,   9,   9,   9
G$pc_shufbidx_s_dv5:
	.byte	  0,   1,   2,   3,   4, 255, 255, 255, 255, 255,   8,   9,  10,  11,  12, 255
	.byte	  9,  10,  11,  12, 255,   0,   1,   2,   3,   4, 255, 255, 255, 255, 255,   8
G$cbd_jshufbidx:
	.byte	  0,   1,   2, 255,   3,   4,   5, 255,   6,   7,   8, 255,   9,  10,  11, 255
	.byte	  4,   5,   6, 255,   7,   8,   9, 255,  10,  11,  12, 255,  13,  14,  15, 255
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
G$mqinvx16:
	.byte	251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58
	.byte	251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58, 251,  58
G$jzetas_inv:
	.byte	165,   6,  15,   7, 180,   5,  67,   9,  34,   9,  29,   9,  52,   1, 108,   0
	.byte	 35,  11, 102,   3,  86,   3, 230,   5, 231,   9, 254,   4, 250,   5, 161,   4
	.byte	123,   6, 163,   4,  37,  12, 106,   3,  55,   5,  63,   8, 136,   0, 191,   4
	.byte	129,  11, 185,   5,   5,   5, 215,   7, 159,  10, 166,  10, 184,   8, 208,   9
	.byte	 75,   0, 156,   0, 184,  11,  95,  11, 164,  11, 104,   3, 125,  10,  54,   6
	.byte	162,   8,  90,   2,  54,   7,   9,   3, 147,   0, 122,   8, 247,   9, 246,   0
	.byte	140,   6, 219,   6, 204,   1,  35,   1, 235,   0,  80,  12, 182,  10,  91,  11
	.byte	152,  12, 243,   6, 154,   9, 227,   4, 182,   9, 214,  10,  83,  11,  79,   4
	.byte	251,   4,  92,  10,  41,   4,  65,  11, 213,   2, 228,   5,  64,   9, 142,   1
	.byte	183,   3, 247,   0, 141,   5, 150,  12, 195,   9,  15,   1,  90,   0,  85,   3
	.byte	 68,   7, 131,  12, 138,   4,  82,   6, 154,   2,  64,   1,   8,   0, 253,  10
	.byte	  8,   6,  26,   1,  46,   7,  13,   5,  10,   9,  40,   2, 117,  10,  58,   8
	.byte	 35,   6, 205,   0, 102,  11,   6,   6, 161,  10,  37,  10,   8,   9, 169,   2
	.byte	130,   0,  66,   6,  79,   7,  61,   3, 130,  11, 249,  11,  45,   5, 196,  10
	.byte	 69,   7, 194,   5, 178,   4,  63,   9,  75,  12, 216,   6, 147,  10, 171,   0
	.byte	 55,  12, 226,  11, 115,   7,  44,   7, 237,   5, 103,   1, 246,   2, 161,   5
G$jzetas:
	.byte	237,   8,  11,  10, 154,  11,  20,   7, 213,   5, 142,   5,  31,   1, 202,   0
	.byte	 86,  12, 110,   2,  41,   6, 182,   0, 194,   3,  79,   8,  63,   7, 188,   5
	.byte	 61,   2, 212,   7,   8,   1, 127,   1, 196,   9, 178,   5, 191,   6, 127,  12
	.byte	 88,  10, 249,   3, 220,   2,  96,   2, 251,   6, 155,   1,  52,  12, 222,   6
	.byte	199,   4, 140,   2, 217,  10, 247,   3, 244,   7, 211,   5, 231,  11, 249,   6
	.byte	  4,   2, 249,  12, 193,  11, 103,  10, 175,   6, 119,   8, 126,   0, 189,   5
	.byte	172,   9, 167,  12, 242,  11,  62,   3, 107,   0, 116,   7,  10,  12,  74,   9
	.byte	115,  11, 193,   3,  29,   7,  44,  10, 192,   1, 216,   8, 165,   2,   6,   8
	.byte	178,   8, 174,   1,  43,   2,  75,   3,  30,   8, 103,   3,  14,   6, 105,   0
	.byte	166,   1,  75,   2, 177,   0,  22,  12, 222,  11,  53,  11,  38,   6, 117,   6
	.byte	 11,  12,  10,   3, 135,   4, 110,  12, 248,   9, 203,   5, 167,  10,  95,   4
	.byte	203,   6, 132,   2, 153,   9,  93,   1, 162,   1,  73,   1, 101,  12, 182,  12
	.byte	 49,   3,  73,   4,  91,   2,  98,   2,  42,   5, 252,   7,  72,   7, 128,   1
	.byte	 66,   8, 121,  12, 194,   4, 202,   7, 151,   9, 220,   0,  94,   8, 134,   6
	.byte	 96,   8,   7,   7,   3,   8,  26,   3,  27,   7, 171,   9, 155,   9, 222,   1
	.byte	149,  12, 205,  11, 228,   3, 223,   3, 190,   3,  77,   7, 242,   5,  92,   6
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
