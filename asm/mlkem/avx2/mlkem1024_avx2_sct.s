	.att_syntax
	.text
	.p2align	5
	.global	jade_kem_mlkem_mlkem1024_amd64_avx2_check_sk
	.global	jade_kem_mlkem_mlkem1024_amd64_avx2_check_pk
	.global	jade_kem_mlkem_mlkem1024_amd64_avx2_dec
	.global	jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand
	.global	jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand
	.type	jade_kem_mlkem_mlkem1024_amd64_avx2_check_sk, %function
jade_kem_mlkem_mlkem1024_amd64_avx2_check_sk:
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
	leaq	1536(%rdi), %rcx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_sk$1:
	leaq	248(%rsp), %rsp
	movq	32(%rsp), %rax
	lfence
	movq	$0, %rsi
	vmovdqu	(%rsp), %ymm2
	vmovdqu	3104(%rax), %ymm0
	vpxor	%ymm0, %ymm2, %ymm2
	vptest	%ymm2, %ymm2
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
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_sk$2:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_sk$2
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem1024_amd64_avx2_check_pk, %function
jade_kem_mlkem_mlkem1024_amd64_avx2_check_pk:
	movq	%rsp, %r10
	leaq	-3616(%rsp), %rsp
	andq	$-32, %rsp
	lfence
	movq	$0, %rax
	movq	%rdi, 3584(%rsp)
	leaq	1536(%rsp), %rsi
	movq	%rdi, %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$8:
	leaq	2048(%rsp), %rsi
	leaq	384(%rdi), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$7:
	leaq	2560(%rsp), %rsi
	leaq	768(%rdi), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$6:
	leaq	3072(%rsp), %rsi
	leaq	1152(%rdi), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$5:
	movq	%rsp, %rax
	movq	%rax, %rdx
	leaq	1536(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$4:
	leaq	384(%rax), %rdx
	leaq	2048(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$3:
	leaq	768(%rax), %rdx
	leaq	2560(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$2:
	leaq	1152(%rax), %rdx
	leaq	3072(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$1:
	movq	3584(%rsp), %rcx
	lfence
	movq	$0, %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rsp), %ymm2
	vmovdqu	(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	32(%rsp), %ymm2
	vmovdqu	32(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	64(%rsp), %ymm2
	vmovdqu	64(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	96(%rsp), %ymm2
	vmovdqu	96(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	128(%rsp), %ymm2
	vmovdqu	128(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	160(%rsp), %ymm2
	vmovdqu	160(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	192(%rsp), %ymm2
	vmovdqu	192(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	224(%rsp), %ymm2
	vmovdqu	224(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	256(%rsp), %ymm2
	vmovdqu	256(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	288(%rsp), %ymm2
	vmovdqu	288(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	320(%rsp), %ymm2
	vmovdqu	320(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	352(%rsp), %ymm2
	vmovdqu	352(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	384(%rsp), %ymm2
	vmovdqu	384(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	416(%rsp), %ymm2
	vmovdqu	416(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	448(%rsp), %ymm2
	vmovdqu	448(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	480(%rsp), %ymm2
	vmovdqu	480(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	512(%rsp), %ymm2
	vmovdqu	512(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	544(%rsp), %ymm2
	vmovdqu	544(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	576(%rsp), %ymm2
	vmovdqu	576(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	608(%rsp), %ymm2
	vmovdqu	608(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	640(%rsp), %ymm2
	vmovdqu	640(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	672(%rsp), %ymm2
	vmovdqu	672(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	704(%rsp), %ymm2
	vmovdqu	704(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	736(%rsp), %ymm2
	vmovdqu	736(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	768(%rsp), %ymm2
	vmovdqu	768(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	800(%rsp), %ymm2
	vmovdqu	800(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	832(%rsp), %ymm2
	vmovdqu	832(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	864(%rsp), %ymm2
	vmovdqu	864(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	896(%rsp), %ymm2
	vmovdqu	896(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	928(%rsp), %ymm2
	vmovdqu	928(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	960(%rsp), %ymm2
	vmovdqu	960(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	992(%rsp), %ymm2
	vmovdqu	992(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1024(%rsp), %ymm2
	vmovdqu	1024(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1056(%rsp), %ymm2
	vmovdqu	1056(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1088(%rsp), %ymm2
	vmovdqu	1088(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1120(%rsp), %ymm2
	vmovdqu	1120(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1152(%rsp), %ymm2
	vmovdqu	1152(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1184(%rsp), %ymm2
	vmovdqu	1184(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1216(%rsp), %ymm2
	vmovdqu	1216(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1248(%rsp), %ymm2
	vmovdqu	1248(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1280(%rsp), %ymm2
	vmovdqu	1280(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1312(%rsp), %ymm2
	vmovdqu	1312(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1344(%rsp), %ymm2
	vmovdqu	1344(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1376(%rsp), %ymm2
	vmovdqu	1376(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1408(%rsp), %ymm2
	vmovdqu	1408(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1440(%rsp), %ymm2
	vmovdqu	1440(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1472(%rsp), %ymm2
	vmovdqu	1472(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1504(%rsp), %ymm2
	vmovdqu	1504(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	movq	$0, %rax
	movq	$-1, %rcx
	cmovne	%rcx, %rax
// declassify_val u64 %rax
	lfence
	movq	$0, %rsi
	movq	%r10, %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$3648, %rsp
	movq	$3648, %rdi
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$9:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_check_pk$9
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem1024_amd64_avx2_dec, %function
jade_kem_mlkem_mlkem1024_amd64_avx2_dec:
	movq	%rsp, %rax
	leaq	-21344(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 21288(%rsp)
	movq	%rbp, 21296(%rsp)
	movq	%r12, 21304(%rsp)
	movq	%r13, 21312(%rsp)
	movq	%r14, 21320(%rsp)
	movq	%r15, 21328(%rsp)
	movq	%rax, 21336(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, 21248(%rsp)
	movq	%rsi, 21256(%rsp)
	movq	%rdx, 21264(%rsp)
	movq	%rdx, 21272(%rsp)
	movq	%rsp, %rax
	leaq	1536(%rdx), %rcx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$70:
	leaq	248(%rsp), %rsp
	movq	21272(%rsp), %rax
	lfence
	movq	$0, %rsi
	vmovdqu	(%rsp), %ymm2
	vmovdqu	3104(%rax), %ymm0
	vpxor	%ymm0, %ymm2, %ymm2
	vptest	%ymm2, %ymm2
	movq	$0, %rcx
	movq	$-1, %rax
	cmovne	%rax, %rcx
// declassify_val u64 %rcx
	lfence
	movq	$0, %rsi
	movq	21248(%rsp), %rsi
	movq	21256(%rsp), %rdi
	movq	21264(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	%rcx, 21264(%rsp)
	cmpq	$0, %rcx
	je  	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$1
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rsi)
	jmp 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$2
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$1:
	movq	%rsi, 21256(%rsp)
	movq	%rdi, 21248(%rsp)
	movq	%rax, 21272(%rsp)
	vmovdqu	3136(%rax), %ymm0
	vmovdqu	%ymm0, 3264(%rsp)
	movq	%rax, %rcx
	leaq	32(%rsp), %rdx
	leaq	4864(%rsp), %rsi
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 288(%rip), %ymm1
	vmovdqu	glob_data + 256(%rip), %ymm2
	vmovdqu	glob_data + 224(%rip), %ymm3
	vmovdqu	glob_data + 192(%rip), %ymm4
	vpbroadcastw	glob_data + 4842(%rip), %ymm5
	vmovdqu	(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, (%rsi)
	vmovdqu	22(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 32(%rsi)
	vmovdqu	44(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 64(%rsi)
	vmovdqu	66(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 96(%rsi)
	vmovdqu	88(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 128(%rsi)
	vmovdqu	110(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 160(%rsi)
	vmovdqu	132(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 192(%rsi)
	vmovdqu	154(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 224(%rsi)
	vmovdqu	176(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 256(%rsi)
	vmovdqu	198(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 288(%rsi)
	vmovdqu	220(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 320(%rsi)
	vmovdqu	242(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 352(%rsi)
	vmovdqu	264(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 384(%rsi)
	vmovdqu	286(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 416(%rsi)
	vmovdqu	308(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	330(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 480(%rsi)
	vmovdqu	352(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 512(%rsi)
	vmovdqu	374(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 544(%rsi)
	vmovdqu	396(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 576(%rsi)
	vmovdqu	418(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 608(%rsi)
	vmovdqu	440(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 640(%rsi)
	vmovdqu	462(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 672(%rsi)
	vmovdqu	484(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 704(%rsi)
	vmovdqu	506(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 736(%rsi)
	vmovdqu	528(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 768(%rsi)
	vmovdqu	550(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 800(%rsi)
	vmovdqu	572(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 832(%rsi)
	vmovdqu	594(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 864(%rsi)
	vmovdqu	616(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 896(%rsi)
	vmovdqu	638(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 928(%rsi)
	vmovdqu	660(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 960(%rsi)
	vmovdqu	682(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 992(%rsi)
	vmovdqu	704(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1024(%rsi)
	vmovdqu	726(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1056(%rsi)
	vmovdqu	748(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1088(%rsi)
	vmovdqu	770(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1120(%rsi)
	vmovdqu	792(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1152(%rsi)
	vmovdqu	814(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1184(%rsi)
	vmovdqu	836(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1216(%rsi)
	vmovdqu	858(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1248(%rsi)
	vmovdqu	880(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1280(%rsi)
	vmovdqu	902(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1312(%rsi)
	vmovdqu	924(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1344(%rsi)
	vmovdqu	946(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1376(%rsi)
	vmovdqu	968(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1408(%rsi)
	vmovdqu	990(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1440(%rsi)
	vmovdqu	1012(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1472(%rsi)
	vmovdqu	1034(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1504(%rsi)
	vmovdqu	1056(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1536(%rsi)
	vmovdqu	1078(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1568(%rsi)
	vmovdqu	1100(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1600(%rsi)
	vmovdqu	1122(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1632(%rsi)
	vmovdqu	1144(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1664(%rsi)
	vmovdqu	1166(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1696(%rsi)
	vmovdqu	1188(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1728(%rsi)
	vmovdqu	1210(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1760(%rsi)
	vmovdqu	1232(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1792(%rsi)
	vmovdqu	1254(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1824(%rsi)
	vmovdqu	1276(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1856(%rsi)
	vmovdqu	1298(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1888(%rsi)
	vmovdqu	1320(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1920(%rsi)
	vmovdqu	1342(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1952(%rsi)
	vmovdqu	1364(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm6
	vpsrlvq	%ymm3, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpsrlw	$1, %ymm6, %ymm6
	vpand	%ymm5, %ymm6, %ymm6
	vpmulhrsw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, 1984(%rsi)
	vmovdqu	1386(%rdi), %ymm6
	vpermq	$148, %ymm6, %ymm6
	vpshufb	%ymm1, %ymm6, %ymm6
	vpsrlvd	%ymm2, %ymm6, %ymm2
	vpsrlvq	%ymm3, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpsrlw	$1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 2016(%rsi)
	leaq	160(%rsp), %rsi
	leaq	1408(%rdi), %rdi
	leaq	-24(%rsp), %rsp
	call	.L_i_poly_decompress_dv5$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$69:
	leaq	24(%rsp), %rsp
	leaq	6912(%rsp), %rsi
	movq	%rcx, %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$68:
	leaq	7424(%rsp), %rsi
	leaq	384(%rcx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$67:
	leaq	7936(%rsp), %rsi
	leaq	768(%rcx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$66:
	leaq	8448(%rsp), %rsi
	leaq	1152(%rcx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$65:
	leaq	4864(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$64:
	leaq	5376(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$63:
	leaq	5888(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$62:
	leaq	6400(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$61:
	leaq	672(%rsp), %rsi
	leaq	6912(%rsp), %rcx
	leaq	4864(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$60:
	leaq	672(%rsp), %rsi
	leaq	7424(%rsp), %rcx
	leaq	5376(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$59:
	leaq	672(%rsp), %rsi
	leaq	7936(%rsp), %rcx
	leaq	5888(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$58:
	leaq	672(%rsp), %rsi
	leaq	8448(%rsp), %rcx
	leaq	6400(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$57:
	leaq	672(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$56:
	leaq	1184(%rsp), %rsi
	leaq	160(%rsp), %rcx
	leaq	672(%rsp), %rdi
	call	.L_poly_sub$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$55:
	leaq	1184(%rsp), %rsi
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
	vmovdqu	(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	32(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 32(%rsi)
	vmovdqu	64(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	96(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 96(%rsi)
	vmovdqu	128(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 128(%rsi)
	vmovdqu	160(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 160(%rsi)
	vmovdqu	192(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	224(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 224(%rsi)
	vmovdqu	256(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	288(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rsi)
	vmovdqu	320(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	352(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 352(%rsi)
	vmovdqu	384(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	416(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 416(%rsi)
	vmovdqu	448(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 448(%rsi)
	vmovdqu	480(%rsi), %ymm3
	vpmulhw	%ymm1, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm1
	vmovdqu	%ymm1, 480(%rsi)
	leaq	1184(%rsp), %rsi
	call	.L_i_poly_tomsg$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$54:
	vmovdqu	3104(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rsp)
	leaq	96(%rsp), %rdi
	leaq	32(%rsp), %rcx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A64$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$53:
	leaq	248(%rsp), %rsp
	movq	21272(%rsp), %rax
	lfence
	movq	$0, %rdx
	leaq	1696(%rsp), %rsi
	leaq	32(%rsp), %rdx
	leaq	1536(%rax), %rcx
	leaq	128(%rsp), %r8
	movq	%rsi, 21272(%rsp)
	movq	%r8, 21280(%rsp)
	movq	%rcx, %rax
	leaq	4864(%rsp), %rsi
	movq	%rax, %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$52:
	leaq	5376(%rsp), %rsi
	leaq	384(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$51:
	leaq	5888(%rsp), %rsi
	leaq	768(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$50:
	leaq	6400(%rsp), %rsi
	leaq	1152(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$49:
	movq	1536(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, (%rsp)
	movq	1544(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 8(%rsp)
	movq	1552(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 16(%rsp)
	movq	1560(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 24(%rsp)
	leaq	1184(%rsp), %rsi
	call	.L_i_poly_frommsg$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$48:
	movq	$1, %rax
	leaq	13056(%rsp), %rsi
	movq	%rsp, %rcx
	leaq	-2200(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$47:
	leaq	2200(%rsp), %rsp
	movq	21280(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$0, %bl
	leaq	8960(%rsp), %rax
	leaq	9472(%rsp), %r9
	leaq	9984(%rsp), %r10
	leaq	10496(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$46:
	leaq	600(%rsp), %rsp
	movq	21280(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$4, %bl
	leaq	11008(%rsp), %rax
	leaq	11520(%rsp), %r9
	leaq	12032(%rsp), %r10
	leaq	12544(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$45:
	leaq	600(%rsp), %rsp
	movq	21280(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$8, %al
	leaq	672(%rsp), %rdx
	leaq	-184(%rsp), %rsp
	call	.L_poly_getnoise_eta2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$44:
	leaq	184(%rsp), %rsp
	leaq	8960(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$43:
	leaq	9472(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$42:
	leaq	9984(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$41:
	leaq	10496(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$40:
	leaq	6912(%rsp), %rsi
	leaq	13056(%rsp), %rcx
	leaq	8960(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$39:
	leaq	6912(%rsp), %rsi
	leaq	13568(%rsp), %rcx
	leaq	9472(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$38:
	leaq	6912(%rsp), %rsi
	leaq	14080(%rsp), %rcx
	leaq	9984(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$37:
	leaq	6912(%rsp), %rsi
	leaq	14592(%rsp), %rcx
	leaq	10496(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$36:
	leaq	7424(%rsp), %rsi
	leaq	15104(%rsp), %rcx
	leaq	8960(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$35:
	leaq	7424(%rsp), %rsi
	leaq	15616(%rsp), %rcx
	leaq	9472(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$34:
	leaq	7424(%rsp), %rsi
	leaq	16128(%rsp), %rcx
	leaq	9984(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$33:
	leaq	7424(%rsp), %rsi
	leaq	16640(%rsp), %rcx
	leaq	10496(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$32:
	leaq	7936(%rsp), %rsi
	leaq	17152(%rsp), %rcx
	leaq	8960(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$31:
	leaq	7936(%rsp), %rsi
	leaq	17664(%rsp), %rcx
	leaq	9472(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$30:
	leaq	7936(%rsp), %rsi
	leaq	18176(%rsp), %rcx
	leaq	9984(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$29:
	leaq	7936(%rsp), %rsi
	leaq	18688(%rsp), %rcx
	leaq	10496(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$28:
	leaq	8448(%rsp), %rsi
	leaq	19200(%rsp), %rcx
	leaq	8960(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$27:
	leaq	8448(%rsp), %rsi
	leaq	19712(%rsp), %rcx
	leaq	9472(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$26:
	leaq	8448(%rsp), %rsi
	leaq	20224(%rsp), %rcx
	leaq	9984(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$25:
	leaq	8448(%rsp), %rsi
	leaq	20736(%rsp), %rcx
	leaq	10496(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$24:
	leaq	160(%rsp), %rsi
	leaq	4864(%rsp), %rcx
	leaq	8960(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$23:
	leaq	160(%rsp), %rsi
	leaq	5376(%rsp), %rcx
	leaq	9472(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$22:
	leaq	160(%rsp), %rsi
	leaq	5888(%rsp), %rcx
	leaq	9984(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$21:
	leaq	160(%rsp), %rsi
	leaq	6400(%rsp), %rcx
	leaq	10496(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$20:
	leaq	6912(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$19:
	leaq	7424(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$18:
	leaq	7936(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$17:
	leaq	8448(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$16:
	leaq	160(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$15:
	leaq	6912(%rsp), %rdx
	leaq	11008(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$14:
	leaq	7424(%rsp), %rdx
	leaq	11520(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$13:
	leaq	7936(%rsp), %rdx
	leaq	12032(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$12:
	leaq	8448(%rsp), %rdx
	leaq	12544(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$11:
	leaq	160(%rsp), %rdx
	leaq	672(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$10:
	leaq	160(%rsp), %rdx
	leaq	1184(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$9:
	leaq	6912(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	7424(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	7936(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	8448(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	160(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	movq	21272(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	%rax, %rdx
	leaq	6912(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$8:
	leaq	7424(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$7:
	leaq	7936(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$6:
	leaq	8448(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$5:
	vmovdqu	glob_data + 736(%rip), %ymm0
	vpsllw	$3, %ymm0, %ymm1
	vpbroadcastw	glob_data + 4840(%rip), %ymm2
	vpbroadcastw	glob_data + 4838(%rip), %ymm3
	vpbroadcastw	glob_data + 4836(%rip), %ymm5
	vpbroadcastq	glob_data + 4520(%rip), %ymm4
	vpbroadcastq	glob_data + 4512(%rip), %ymm6
	vmovdqu	glob_data + 160(%rip), %ymm7
	vmovdqu	glob_data + 128(%rip), %ymm8
	vmovdqu	6912(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, (%rdx)
	movq	%xmm14, 16(%rdx)
	vmovdqu	6944(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 22(%rdx)
	movq	%xmm14, 38(%rdx)
	vmovdqu	6976(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 44(%rdx)
	movq	%xmm14, 60(%rdx)
	vmovdqu	7008(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 66(%rdx)
	movq	%xmm14, 82(%rdx)
	vmovdqu	7040(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 88(%rdx)
	movq	%xmm14, 104(%rdx)
	vmovdqu	7072(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 110(%rdx)
	movq	%xmm14, 126(%rdx)
	vmovdqu	7104(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 132(%rdx)
	movq	%xmm14, 148(%rdx)
	vmovdqu	7136(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 154(%rdx)
	movq	%xmm14, 170(%rdx)
	vmovdqu	7168(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 176(%rdx)
	movq	%xmm14, 192(%rdx)
	vmovdqu	7200(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 198(%rdx)
	movq	%xmm14, 214(%rdx)
	vmovdqu	7232(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 220(%rdx)
	movq	%xmm14, 236(%rdx)
	vmovdqu	7264(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 242(%rdx)
	movq	%xmm14, 258(%rdx)
	vmovdqu	7296(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 264(%rdx)
	movq	%xmm14, 280(%rdx)
	vmovdqu	7328(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 286(%rdx)
	movq	%xmm14, 302(%rdx)
	vmovdqu	7360(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 308(%rdx)
	movq	%xmm14, 324(%rdx)
	vmovdqu	7392(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 330(%rdx)
	movq	%xmm14, 346(%rdx)
	vmovdqu	7424(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 352(%rdx)
	movq	%xmm14, 368(%rdx)
	vmovdqu	7456(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 374(%rdx)
	movq	%xmm14, 390(%rdx)
	vmovdqu	7488(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 396(%rdx)
	movq	%xmm14, 412(%rdx)
	vmovdqu	7520(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 418(%rdx)
	movq	%xmm14, 434(%rdx)
	vmovdqu	7552(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 440(%rdx)
	movq	%xmm14, 456(%rdx)
	vmovdqu	7584(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 462(%rdx)
	movq	%xmm14, 478(%rdx)
	vmovdqu	7616(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 484(%rdx)
	movq	%xmm14, 500(%rdx)
	vmovdqu	7648(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 506(%rdx)
	movq	%xmm14, 522(%rdx)
	vmovdqu	7680(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 528(%rdx)
	movq	%xmm14, 544(%rdx)
	vmovdqu	7712(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 550(%rdx)
	movq	%xmm14, 566(%rdx)
	vmovdqu	7744(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 572(%rdx)
	movq	%xmm14, 588(%rdx)
	vmovdqu	7776(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 594(%rdx)
	movq	%xmm14, 610(%rdx)
	vmovdqu	7808(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 616(%rdx)
	movq	%xmm14, 632(%rdx)
	vmovdqu	7840(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 638(%rdx)
	movq	%xmm14, 654(%rdx)
	vmovdqu	7872(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 660(%rdx)
	movq	%xmm14, 676(%rdx)
	vmovdqu	7904(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 682(%rdx)
	movq	%xmm14, 698(%rdx)
	vmovdqu	7936(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 704(%rdx)
	movq	%xmm14, 720(%rdx)
	vmovdqu	7968(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 726(%rdx)
	movq	%xmm14, 742(%rdx)
	vmovdqu	8000(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 748(%rdx)
	movq	%xmm14, 764(%rdx)
	vmovdqu	8032(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 770(%rdx)
	movq	%xmm14, 786(%rdx)
	vmovdqu	8064(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 792(%rdx)
	movq	%xmm14, 808(%rdx)
	vmovdqu	8096(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 814(%rdx)
	movq	%xmm14, 830(%rdx)
	vmovdqu	8128(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 836(%rdx)
	movq	%xmm14, 852(%rdx)
	vmovdqu	8160(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 858(%rdx)
	movq	%xmm14, 874(%rdx)
	vmovdqu	8192(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 880(%rdx)
	movq	%xmm14, 896(%rdx)
	vmovdqu	8224(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 902(%rdx)
	movq	%xmm14, 918(%rdx)
	vmovdqu	8256(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 924(%rdx)
	movq	%xmm14, 940(%rdx)
	vmovdqu	8288(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 946(%rdx)
	movq	%xmm14, 962(%rdx)
	vmovdqu	8320(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 968(%rdx)
	movq	%xmm14, 984(%rdx)
	vmovdqu	8352(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 990(%rdx)
	movq	%xmm14, 1006(%rdx)
	vmovdqu	8384(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1012(%rdx)
	movq	%xmm14, 1028(%rdx)
	vmovdqu	8416(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1034(%rdx)
	movq	%xmm14, 1050(%rdx)
	vmovdqu	8448(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1056(%rdx)
	movq	%xmm14, 1072(%rdx)
	vmovdqu	8480(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1078(%rdx)
	movq	%xmm14, 1094(%rdx)
	vmovdqu	8512(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1100(%rdx)
	movq	%xmm14, 1116(%rdx)
	vmovdqu	8544(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1122(%rdx)
	movq	%xmm14, 1138(%rdx)
	vmovdqu	8576(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1144(%rdx)
	movq	%xmm14, 1160(%rdx)
	vmovdqu	8608(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1166(%rdx)
	movq	%xmm14, 1182(%rdx)
	vmovdqu	8640(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1188(%rdx)
	movq	%xmm14, 1204(%rdx)
	vmovdqu	8672(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1210(%rdx)
	movq	%xmm14, 1226(%rdx)
	vmovdqu	8704(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1232(%rdx)
	movq	%xmm14, 1248(%rdx)
	vmovdqu	8736(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1254(%rdx)
	movq	%xmm14, 1270(%rdx)
	vmovdqu	8768(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1276(%rdx)
	movq	%xmm14, 1292(%rdx)
	vmovdqu	8800(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1298(%rdx)
	movq	%xmm14, 1314(%rdx)
	vmovdqu	8832(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1320(%rdx)
	movq	%xmm14, 1336(%rdx)
	vmovdqu	8864(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1342(%rdx)
	movq	%xmm14, 1358(%rdx)
	vmovdqu	8896(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1364(%rdx)
	movq	%xmm14, 1380(%rdx)
	vmovdqu	8928(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vpmaddwd	%ymm4, %ymm3, %ymm3
	vpsllvd	%ymm6, %ymm3, %ymm3
	vpsrldq	$8, %ymm3, %ymm4
	vpsrlvq	%ymm7, %ymm3, %ymm3
	vpsllq	$34, %ymm4, %ymm4
	vpor	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm8, %ymm3, %ymm3
	vmovdqu	%xmm3, %xmm2
	vextracti128	$1, %ymm3, %xmm3
	vpblendvb	%xmm8, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 1386(%rdx)
	movq	%xmm3, 1402(%rdx)
	leaq	1408(%rax), %rdx
	leaq	160(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$4:
	vmovdqu	glob_data + 736(%rip), %ymm0
	vpbroadcastw	glob_data + 4852(%rip), %ymm3
	vpbroadcastw	glob_data + 4854(%rip), %ymm5
	vpbroadcastw	glob_data + 4850(%rip), %ymm4
	vpbroadcastd	glob_data + 4824(%rip), %ymm1
	vpbroadcastq	glob_data + 4552(%rip), %ymm6
	vmovdqu	glob_data + 416(%rip), %ymm8
	vmovdqu	(%rsi), %ymm9
	vmovdqu	32(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, (%rdx)
	movd	%xmm7, 16(%rdx)
	vmovdqu	64(%rsi), %ymm9
	vmovdqu	96(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 20(%rdx)
	movd	%xmm7, 36(%rdx)
	vmovdqu	128(%rsi), %ymm9
	vmovdqu	160(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 40(%rdx)
	movd	%xmm7, 56(%rdx)
	vmovdqu	192(%rsi), %ymm9
	vmovdqu	224(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 60(%rdx)
	movd	%xmm7, 76(%rdx)
	vmovdqu	256(%rsi), %ymm9
	vmovdqu	288(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 80(%rdx)
	movd	%xmm7, 96(%rdx)
	vmovdqu	320(%rsi), %ymm9
	vmovdqu	352(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 100(%rdx)
	movd	%xmm7, 116(%rdx)
	vmovdqu	384(%rsi), %ymm9
	vmovdqu	416(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 120(%rdx)
	movd	%xmm7, 136(%rdx)
	vmovdqu	448(%rsi), %ymm9
	vmovdqu	480(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm3
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm3, %ymm3
	vpmaddubsw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm1, %ymm3, %ymm3
	vpsllvd	%ymm6, %ymm3, %ymm3
	vpsrlvq	%ymm6, %ymm3, %ymm3
	vpshufb	%ymm8, %ymm3, %ymm3
	vmovdqu	%xmm3, %xmm2
	vextracti128	$1, %ymm3, %xmm3
	vpblendvb	%xmm8, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 140(%rdx)
	movd	%xmm3, 156(%rdx)
	movq	21248(%rsp), %rax
	movq	21256(%rsp), %rdi
	lfence
	movq	$0, %rdx
	leaq	1696(%rsp), %rcx
	movq	$0, %rdx
	movq	$1, %rsi
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	(%rcx), %ymm2
	vmovdqu	(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	32(%rcx), %ymm2
	vmovdqu	32(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	64(%rcx), %ymm2
	vmovdqu	64(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	96(%rcx), %ymm2
	vmovdqu	96(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	128(%rcx), %ymm2
	vmovdqu	128(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	160(%rcx), %ymm2
	vmovdqu	160(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	192(%rcx), %ymm2
	vmovdqu	192(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	224(%rcx), %ymm2
	vmovdqu	224(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	256(%rcx), %ymm2
	vmovdqu	256(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	288(%rcx), %ymm2
	vmovdqu	288(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	320(%rcx), %ymm2
	vmovdqu	320(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	352(%rcx), %ymm2
	vmovdqu	352(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	384(%rcx), %ymm2
	vmovdqu	384(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	416(%rcx), %ymm2
	vmovdqu	416(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	448(%rcx), %ymm2
	vmovdqu	448(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	480(%rcx), %ymm2
	vmovdqu	480(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	512(%rcx), %ymm2
	vmovdqu	512(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	544(%rcx), %ymm2
	vmovdqu	544(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	576(%rcx), %ymm2
	vmovdqu	576(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	608(%rcx), %ymm2
	vmovdqu	608(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	640(%rcx), %ymm2
	vmovdqu	640(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	672(%rcx), %ymm2
	vmovdqu	672(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	704(%rcx), %ymm2
	vmovdqu	704(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	736(%rcx), %ymm2
	vmovdqu	736(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	768(%rcx), %ymm2
	vmovdqu	768(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	800(%rcx), %ymm2
	vmovdqu	800(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	832(%rcx), %ymm2
	vmovdqu	832(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	864(%rcx), %ymm2
	vmovdqu	864(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	896(%rcx), %ymm2
	vmovdqu	896(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	928(%rcx), %ymm2
	vmovdqu	928(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	960(%rcx), %ymm2
	vmovdqu	960(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	992(%rcx), %ymm2
	vmovdqu	992(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1024(%rcx), %ymm2
	vmovdqu	1024(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1056(%rcx), %ymm2
	vmovdqu	1056(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1088(%rcx), %ymm2
	vmovdqu	1088(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1120(%rcx), %ymm2
	vmovdqu	1120(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1152(%rcx), %ymm2
	vmovdqu	1152(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1184(%rcx), %ymm2
	vmovdqu	1184(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1216(%rcx), %ymm2
	vmovdqu	1216(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1248(%rcx), %ymm2
	vmovdqu	1248(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1280(%rcx), %ymm2
	vmovdqu	1280(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1312(%rcx), %ymm2
	vmovdqu	1312(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1344(%rcx), %ymm2
	vmovdqu	1344(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1376(%rcx), %ymm2
	vmovdqu	1376(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1408(%rcx), %ymm2
	vmovdqu	1408(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1440(%rcx), %ymm2
	vmovdqu	1440(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1472(%rcx), %ymm2
	vmovdqu	1472(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1504(%rcx), %ymm2
	vmovdqu	1504(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1536(%rcx), %ymm2
	vmovdqu	1536(%rax), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	cmovne	%rsi, %rdx
	movq	%rdx, 21256(%rsp)
	vmovdqu	(%rax), %ymm5
	vmovdqu	%ymm5, 3296(%rsp)
	vmovdqu	32(%rax), %ymm5
	vmovdqu	%ymm5, 3328(%rsp)
	vmovdqu	64(%rax), %ymm5
	vmovdqu	%ymm5, 3360(%rsp)
	vmovdqu	96(%rax), %ymm5
	vmovdqu	%ymm5, 3392(%rsp)
	vmovdqu	128(%rax), %ymm5
	vmovdqu	%ymm5, 3424(%rsp)
	vmovdqu	160(%rax), %ymm5
	vmovdqu	%ymm5, 3456(%rsp)
	vmovdqu	192(%rax), %ymm5
	vmovdqu	%ymm5, 3488(%rsp)
	vmovdqu	224(%rax), %ymm5
	vmovdqu	%ymm5, 3520(%rsp)
	vmovdqu	256(%rax), %ymm5
	vmovdqu	%ymm5, 3552(%rsp)
	vmovdqu	288(%rax), %ymm5
	vmovdqu	%ymm5, 3584(%rsp)
	vmovdqu	320(%rax), %ymm5
	vmovdqu	%ymm5, 3616(%rsp)
	vmovdqu	352(%rax), %ymm5
	vmovdqu	%ymm5, 3648(%rsp)
	vmovdqu	384(%rax), %ymm5
	vmovdqu	%ymm5, 3680(%rsp)
	vmovdqu	416(%rax), %ymm5
	vmovdqu	%ymm5, 3712(%rsp)
	vmovdqu	448(%rax), %ymm5
	vmovdqu	%ymm5, 3744(%rsp)
	vmovdqu	480(%rax), %ymm5
	vmovdqu	%ymm5, 3776(%rsp)
	vmovdqu	512(%rax), %ymm5
	vmovdqu	%ymm5, 3808(%rsp)
	vmovdqu	544(%rax), %ymm5
	vmovdqu	%ymm5, 3840(%rsp)
	vmovdqu	576(%rax), %ymm5
	vmovdqu	%ymm5, 3872(%rsp)
	vmovdqu	608(%rax), %ymm5
	vmovdqu	%ymm5, 3904(%rsp)
	vmovdqu	640(%rax), %ymm5
	vmovdqu	%ymm5, 3936(%rsp)
	vmovdqu	672(%rax), %ymm5
	vmovdqu	%ymm5, 3968(%rsp)
	vmovdqu	704(%rax), %ymm5
	vmovdqu	%ymm5, 4000(%rsp)
	vmovdqu	736(%rax), %ymm5
	vmovdqu	%ymm5, 4032(%rsp)
	vmovdqu	768(%rax), %ymm5
	vmovdqu	%ymm5, 4064(%rsp)
	vmovdqu	800(%rax), %ymm5
	vmovdqu	%ymm5, 4096(%rsp)
	vmovdqu	832(%rax), %ymm5
	vmovdqu	%ymm5, 4128(%rsp)
	vmovdqu	864(%rax), %ymm5
	vmovdqu	%ymm5, 4160(%rsp)
	vmovdqu	896(%rax), %ymm5
	vmovdqu	%ymm5, 4192(%rsp)
	vmovdqu	928(%rax), %ymm5
	vmovdqu	%ymm5, 4224(%rsp)
	vmovdqu	960(%rax), %ymm5
	vmovdqu	%ymm5, 4256(%rsp)
	vmovdqu	992(%rax), %ymm5
	vmovdqu	%ymm5, 4288(%rsp)
	vmovdqu	1024(%rax), %ymm5
	vmovdqu	%ymm5, 4320(%rsp)
	vmovdqu	1056(%rax), %ymm5
	vmovdqu	%ymm5, 4352(%rsp)
	vmovdqu	1088(%rax), %ymm5
	vmovdqu	%ymm5, 4384(%rsp)
	vmovdqu	1120(%rax), %ymm5
	vmovdqu	%ymm5, 4416(%rsp)
	vmovdqu	1152(%rax), %ymm5
	vmovdqu	%ymm5, 4448(%rsp)
	vmovdqu	1184(%rax), %ymm5
	vmovdqu	%ymm5, 4480(%rsp)
	vmovdqu	1216(%rax), %ymm5
	vmovdqu	%ymm5, 4512(%rsp)
	vmovdqu	1248(%rax), %ymm5
	vmovdqu	%ymm5, 4544(%rsp)
	vmovdqu	1280(%rax), %ymm5
	vmovdqu	%ymm5, 4576(%rsp)
	vmovdqu	1312(%rax), %ymm5
	vmovdqu	%ymm5, 4608(%rsp)
	vmovdqu	1344(%rax), %ymm5
	vmovdqu	%ymm5, 4640(%rsp)
	vmovdqu	1376(%rax), %ymm5
	vmovdqu	%ymm5, 4672(%rsp)
	vmovdqu	1408(%rax), %ymm5
	vmovdqu	%ymm5, 4704(%rsp)
	vmovdqu	1440(%rax), %ymm5
	vmovdqu	%ymm5, 4736(%rsp)
	vmovdqu	1472(%rax), %ymm5
	vmovdqu	%ymm5, 4768(%rsp)
	vmovdqu	1504(%rax), %ymm5
	vmovdqu	%ymm5, 4800(%rsp)
	vmovdqu	1536(%rax), %ymm5
	vmovdqu	%ymm5, 4832(%rsp)
	leaq	3264(%rsp), %rcx
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A32__AZCT$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$3:
	leaq	248(%rsp), %rsp
	movq	21256(%rsp), %rdx
	leaq	96(%rsp), %rax
	negq	%rdx
	movq	%rdx, 21256(%rsp)
	vpbroadcastq	21256(%rsp), %ymm0
	vmovdqu	(%rax), %ymm2
	vmovdqu	(%rdi), %ymm1
	vpblendvb	%ymm0, %ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdi)
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$2:
	movq	21264(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	21288(%rsp), %rbx
	movq	21296(%rsp), %rbp
	movq	21304(%rsp), %r12
	movq	21312(%rsp), %r13
	movq	21320(%rsp), %r14
	movq	21328(%rsp), %r15
	movq	21336(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$25440, %rsp
	movq	$25440, %rdi
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$71:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_dec$71
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand, %function
jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand:
	movq	%rsp, %rax
	leaq	-19712(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 19656(%rsp)
	movq	%rbp, 19664(%rsp)
	movq	%r12, 19672(%rsp)
	movq	%r13, 19680(%rsp)
	movq	%r14, 19688(%rsp)
	movq	%r15, 19696(%rsp)
	movq	%rax, 19704(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdi, 19584(%rsp)
	movq	%rsi, 19592(%rsp)
	movq	%rdx, 19600(%rsp)
	movq	%rcx, 19608(%rsp)
	movq	%rdx, 19616(%rsp)
	leaq	3200(%rsp), %rsi
	movq	%rdx, %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$61:
	leaq	3712(%rsp), %rsi
	leaq	384(%rdx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$60:
	leaq	4224(%rsp), %rsi
	leaq	768(%rdx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$59:
	leaq	4736(%rsp), %rsi
	leaq	1152(%rdx), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$58:
	leaq	1664(%rsp), %rax
	movq	%rax, %rdx
	leaq	3200(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$57:
	leaq	384(%rax), %rdx
	leaq	3712(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$56:
	leaq	768(%rax), %rdx
	leaq	4224(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$55:
	leaq	1152(%rax), %rdx
	leaq	4736(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$54:
	movq	19616(%rsp), %rcx
	lfence
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	vmovdqu	1664(%rsp), %ymm2
	vmovdqu	(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1696(%rsp), %ymm2
	vmovdqu	32(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1728(%rsp), %ymm2
	vmovdqu	64(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1760(%rsp), %ymm2
	vmovdqu	96(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1792(%rsp), %ymm2
	vmovdqu	128(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1824(%rsp), %ymm2
	vmovdqu	160(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1856(%rsp), %ymm2
	vmovdqu	192(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1888(%rsp), %ymm2
	vmovdqu	224(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1920(%rsp), %ymm2
	vmovdqu	256(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1952(%rsp), %ymm2
	vmovdqu	288(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	1984(%rsp), %ymm2
	vmovdqu	320(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2016(%rsp), %ymm2
	vmovdqu	352(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2048(%rsp), %ymm2
	vmovdqu	384(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2080(%rsp), %ymm2
	vmovdqu	416(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2112(%rsp), %ymm2
	vmovdqu	448(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2144(%rsp), %ymm2
	vmovdqu	480(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2176(%rsp), %ymm2
	vmovdqu	512(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2208(%rsp), %ymm2
	vmovdqu	544(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2240(%rsp), %ymm2
	vmovdqu	576(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2272(%rsp), %ymm2
	vmovdqu	608(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2304(%rsp), %ymm2
	vmovdqu	640(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2336(%rsp), %ymm2
	vmovdqu	672(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2368(%rsp), %ymm2
	vmovdqu	704(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2400(%rsp), %ymm2
	vmovdqu	736(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2432(%rsp), %ymm2
	vmovdqu	768(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2464(%rsp), %ymm2
	vmovdqu	800(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2496(%rsp), %ymm2
	vmovdqu	832(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2528(%rsp), %ymm2
	vmovdqu	864(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2560(%rsp), %ymm2
	vmovdqu	896(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2592(%rsp), %ymm2
	vmovdqu	928(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2624(%rsp), %ymm2
	vmovdqu	960(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2656(%rsp), %ymm2
	vmovdqu	992(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2688(%rsp), %ymm2
	vmovdqu	1024(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2720(%rsp), %ymm2
	vmovdqu	1056(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2752(%rsp), %ymm2
	vmovdqu	1088(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2784(%rsp), %ymm2
	vmovdqu	1120(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2816(%rsp), %ymm2
	vmovdqu	1152(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2848(%rsp), %ymm2
	vmovdqu	1184(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2880(%rsp), %ymm2
	vmovdqu	1216(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2912(%rsp), %ymm2
	vmovdqu	1248(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2944(%rsp), %ymm2
	vmovdqu	1280(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	2976(%rsp), %ymm2
	vmovdqu	1312(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3008(%rsp), %ymm2
	vmovdqu	1344(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3040(%rsp), %ymm2
	vmovdqu	1376(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3072(%rsp), %ymm2
	vmovdqu	1408(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3104(%rsp), %ymm2
	vmovdqu	1440(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3136(%rsp), %ymm2
	vmovdqu	1472(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vmovdqu	3168(%rsp), %ymm2
	vmovdqu	1504(%rcx), %ymm1
	vpxor	%ymm1, %ymm2, %ymm2
	vpor	%ymm2, %ymm0, %ymm0
	vptest	%ymm0, %ymm0
	movq	$0, %rax
	movq	$-1, %rcx
	cmovne	%rcx, %rax
// declassify_val u64 %rax
	lfence
	movq	$0, %rdx
	movq	19584(%rsp), %rsi
	movq	19592(%rsp), %rdi
	movq	19600(%rsp), %rcx
	movq	19608(%rsp), %rdx
	lfence
	movq	$0, %r8
	movq	%rax, 19608(%rsp)
	cmpq	$0, %rax
	je  	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$1
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
	vmovdqu	%ymm0, 1088(%rsi)
	vmovdqu	%ymm0, 1120(%rsi)
	vmovdqu	%ymm0, 1152(%rsi)
	vmovdqu	%ymm0, 1184(%rsi)
	vmovdqu	%ymm0, 1216(%rsi)
	vmovdqu	%ymm0, 1248(%rsi)
	vmovdqu	%ymm0, 1280(%rsi)
	vmovdqu	%ymm0, 1312(%rsi)
	vmovdqu	%ymm0, 1344(%rsi)
	vmovdqu	%ymm0, 1376(%rsi)
	vmovdqu	%ymm0, 1408(%rsi)
	vmovdqu	%ymm0, 1440(%rsi)
	vmovdqu	%ymm0, 1472(%rsi)
	vmovdqu	%ymm0, 1504(%rsi)
	vmovdqu	%ymm0, 1536(%rsi)
	vmovdqu	%ymm0, (%rdi)
	jmp 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$2
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$1:
	movq	%rsi, 19600(%rsp)
	movq	%rcx, 19592(%rsp)
	movq	%rdi, 19584(%rsp)
	vmovdqu	(%rdx), %ymm2
	vmovdqu	%ymm2, (%rsp)
	leaq	32(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$53:
	leaq	248(%rsp), %rsp
	leaq	64(%rsp), %rdi
	movq	%rsp, %rcx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A64$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$52:
	leaq	248(%rsp), %rsp
	movq	19600(%rsp), %rax
	movq	19592(%rsp), %rcx
	lfence
	movq	$0, %rdx
	movq	%rsp, %rdx
	leaq	96(%rsp), %r8
	movq	%rax, 19592(%rsp)
	movq	%r8, 19600(%rsp)
	movq	%rcx, %rax
	leaq	3200(%rsp), %rsi
	movq	%rax, %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$51:
	leaq	3712(%rsp), %rsi
	leaq	384(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$50:
	leaq	4224(%rsp), %rsi
	leaq	768(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$49:
	leaq	4736(%rsp), %rsi
	leaq	1152(%rax), %r8
	call	.L_i_poly_frombytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$48:
	movq	1536(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 19624(%rsp)
	movq	1544(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 19632(%rsp)
	movq	1552(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 19640(%rsp)
	movq	1560(%rcx), %rax
// declassify_val u64 %rax
	movq	%rax, 19648(%rsp)
	leaq	128(%rsp), %rsi
	call	.L_i_poly_frommsg$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$47:
	movq	$1, %rax
	leaq	11392(%rsp), %rsi
	leaq	19624(%rsp), %rcx
	leaq	-2200(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$46:
	leaq	2200(%rsp), %rsp
	movq	19600(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$0, %bl
	leaq	7296(%rsp), %rax
	leaq	7808(%rsp), %r9
	leaq	8320(%rsp), %r10
	leaq	8832(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$45:
	leaq	600(%rsp), %rsp
	movq	19600(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$4, %bl
	leaq	9344(%rsp), %rax
	leaq	9856(%rsp), %r9
	leaq	10368(%rsp), %r10
	leaq	10880(%rsp), %r11
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$44:
	leaq	600(%rsp), %rsp
	movq	19600(%rsp), %r8
	lfence
	movq	$0, %rdx
	movb	$8, %al
	leaq	640(%rsp), %rdx
	leaq	-184(%rsp), %rsp
	call	.L_poly_getnoise_eta2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$43:
	leaq	184(%rsp), %rsp
	leaq	7296(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$42:
	leaq	7808(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$41:
	leaq	8320(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$40:
	leaq	8832(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$39:
	leaq	5248(%rsp), %rsi
	leaq	11392(%rsp), %rcx
	leaq	7296(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$38:
	leaq	5248(%rsp), %rsi
	leaq	11904(%rsp), %rcx
	leaq	7808(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$37:
	leaq	5248(%rsp), %rsi
	leaq	12416(%rsp), %rcx
	leaq	8320(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$36:
	leaq	5248(%rsp), %rsi
	leaq	12928(%rsp), %rcx
	leaq	8832(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$35:
	leaq	5760(%rsp), %rsi
	leaq	13440(%rsp), %rcx
	leaq	7296(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$34:
	leaq	5760(%rsp), %rsi
	leaq	13952(%rsp), %rcx
	leaq	7808(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$33:
	leaq	5760(%rsp), %rsi
	leaq	14464(%rsp), %rcx
	leaq	8320(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$32:
	leaq	5760(%rsp), %rsi
	leaq	14976(%rsp), %rcx
	leaq	8832(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$31:
	leaq	6272(%rsp), %rsi
	leaq	15488(%rsp), %rcx
	leaq	7296(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$30:
	leaq	6272(%rsp), %rsi
	leaq	16000(%rsp), %rcx
	leaq	7808(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$29:
	leaq	6272(%rsp), %rsi
	leaq	16512(%rsp), %rcx
	leaq	8320(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$28:
	leaq	6272(%rsp), %rsi
	leaq	17024(%rsp), %rcx
	leaq	8832(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$27:
	leaq	6784(%rsp), %rsi
	leaq	17536(%rsp), %rcx
	leaq	7296(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$26:
	leaq	6784(%rsp), %rsi
	leaq	18048(%rsp), %rcx
	leaq	7808(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$25:
	leaq	6784(%rsp), %rsi
	leaq	18560(%rsp), %rcx
	leaq	8320(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$24:
	leaq	6784(%rsp), %rsi
	leaq	19072(%rsp), %rcx
	leaq	8832(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$23:
	leaq	1152(%rsp), %rsi
	leaq	3200(%rsp), %rcx
	leaq	7296(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$22:
	leaq	1152(%rsp), %rsi
	leaq	3712(%rsp), %rcx
	leaq	7808(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$21:
	leaq	1152(%rsp), %rsi
	leaq	4224(%rsp), %rcx
	leaq	8320(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$20:
	leaq	1152(%rsp), %rsi
	leaq	4736(%rsp), %rcx
	leaq	8832(%rsp), %rdi
	call	.L_poly_basemul_acc_red$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$19:
	leaq	5248(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$18:
	leaq	5760(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$17:
	leaq	6272(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$16:
	leaq	6784(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$15:
	leaq	1152(%rsp), %rsi
	call	.L_poly_invntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$14:
	leaq	5248(%rsp), %rdx
	leaq	9344(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$13:
	leaq	5760(%rsp), %rdx
	leaq	9856(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$12:
	leaq	6272(%rsp), %rdx
	leaq	10368(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$11:
	leaq	6784(%rsp), %rdx
	leaq	10880(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$10:
	leaq	1152(%rsp), %rdx
	leaq	640(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$9:
	leaq	1152(%rsp), %rdx
	leaq	128(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$8:
	leaq	5248(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	5760(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	6272(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	6784(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	1152(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	movq	19592(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	%rax, %rdx
	leaq	5248(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$7:
	leaq	5760(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$6:
	leaq	6272(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$5:
	leaq	6784(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$4:
	vmovdqu	glob_data + 736(%rip), %ymm0
	vpsllw	$3, %ymm0, %ymm1
	vpbroadcastw	glob_data + 4840(%rip), %ymm2
	vpbroadcastw	glob_data + 4838(%rip), %ymm3
	vpbroadcastw	glob_data + 4836(%rip), %ymm5
	vpbroadcastq	glob_data + 4520(%rip), %ymm4
	vpbroadcastq	glob_data + 4512(%rip), %ymm6
	vmovdqu	glob_data + 160(%rip), %ymm7
	vmovdqu	glob_data + 128(%rip), %ymm8
	vmovdqu	5248(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, (%rdx)
	movq	%xmm14, 16(%rdx)
	vmovdqu	5280(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 22(%rdx)
	movq	%xmm14, 38(%rdx)
	vmovdqu	5312(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 44(%rdx)
	movq	%xmm14, 60(%rdx)
	vmovdqu	5344(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 66(%rdx)
	movq	%xmm14, 82(%rdx)
	vmovdqu	5376(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 88(%rdx)
	movq	%xmm14, 104(%rdx)
	vmovdqu	5408(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 110(%rdx)
	movq	%xmm14, 126(%rdx)
	vmovdqu	5440(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 132(%rdx)
	movq	%xmm14, 148(%rdx)
	vmovdqu	5472(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 154(%rdx)
	movq	%xmm14, 170(%rdx)
	vmovdqu	5504(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 176(%rdx)
	movq	%xmm14, 192(%rdx)
	vmovdqu	5536(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 198(%rdx)
	movq	%xmm14, 214(%rdx)
	vmovdqu	5568(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 220(%rdx)
	movq	%xmm14, 236(%rdx)
	vmovdqu	5600(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 242(%rdx)
	movq	%xmm14, 258(%rdx)
	vmovdqu	5632(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 264(%rdx)
	movq	%xmm14, 280(%rdx)
	vmovdqu	5664(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 286(%rdx)
	movq	%xmm14, 302(%rdx)
	vmovdqu	5696(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 308(%rdx)
	movq	%xmm14, 324(%rdx)
	vmovdqu	5728(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 330(%rdx)
	movq	%xmm14, 346(%rdx)
	vmovdqu	5760(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 352(%rdx)
	movq	%xmm14, 368(%rdx)
	vmovdqu	5792(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 374(%rdx)
	movq	%xmm14, 390(%rdx)
	vmovdqu	5824(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 396(%rdx)
	movq	%xmm14, 412(%rdx)
	vmovdqu	5856(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 418(%rdx)
	movq	%xmm14, 434(%rdx)
	vmovdqu	5888(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 440(%rdx)
	movq	%xmm14, 456(%rdx)
	vmovdqu	5920(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 462(%rdx)
	movq	%xmm14, 478(%rdx)
	vmovdqu	5952(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 484(%rdx)
	movq	%xmm14, 500(%rdx)
	vmovdqu	5984(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 506(%rdx)
	movq	%xmm14, 522(%rdx)
	vmovdqu	6016(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 528(%rdx)
	movq	%xmm14, 544(%rdx)
	vmovdqu	6048(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 550(%rdx)
	movq	%xmm14, 566(%rdx)
	vmovdqu	6080(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 572(%rdx)
	movq	%xmm14, 588(%rdx)
	vmovdqu	6112(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 594(%rdx)
	movq	%xmm14, 610(%rdx)
	vmovdqu	6144(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 616(%rdx)
	movq	%xmm14, 632(%rdx)
	vmovdqu	6176(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 638(%rdx)
	movq	%xmm14, 654(%rdx)
	vmovdqu	6208(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 660(%rdx)
	movq	%xmm14, 676(%rdx)
	vmovdqu	6240(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 682(%rdx)
	movq	%xmm14, 698(%rdx)
	vmovdqu	6272(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 704(%rdx)
	movq	%xmm14, 720(%rdx)
	vmovdqu	6304(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 726(%rdx)
	movq	%xmm14, 742(%rdx)
	vmovdqu	6336(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 748(%rdx)
	movq	%xmm14, 764(%rdx)
	vmovdqu	6368(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 770(%rdx)
	movq	%xmm14, 786(%rdx)
	vmovdqu	6400(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 792(%rdx)
	movq	%xmm14, 808(%rdx)
	vmovdqu	6432(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 814(%rdx)
	movq	%xmm14, 830(%rdx)
	vmovdqu	6464(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 836(%rdx)
	movq	%xmm14, 852(%rdx)
	vmovdqu	6496(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 858(%rdx)
	movq	%xmm14, 874(%rdx)
	vmovdqu	6528(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 880(%rdx)
	movq	%xmm14, 896(%rdx)
	vmovdqu	6560(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 902(%rdx)
	movq	%xmm14, 918(%rdx)
	vmovdqu	6592(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 924(%rdx)
	movq	%xmm14, 940(%rdx)
	vmovdqu	6624(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 946(%rdx)
	movq	%xmm14, 962(%rdx)
	vmovdqu	6656(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 968(%rdx)
	movq	%xmm14, 984(%rdx)
	vmovdqu	6688(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 990(%rdx)
	movq	%xmm14, 1006(%rdx)
	vmovdqu	6720(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1012(%rdx)
	movq	%xmm14, 1028(%rdx)
	vmovdqu	6752(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1034(%rdx)
	movq	%xmm14, 1050(%rdx)
	vmovdqu	6784(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1056(%rdx)
	movq	%xmm14, 1072(%rdx)
	vmovdqu	6816(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1078(%rdx)
	movq	%xmm14, 1094(%rdx)
	vmovdqu	6848(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1100(%rdx)
	movq	%xmm14, 1116(%rdx)
	vmovdqu	6880(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1122(%rdx)
	movq	%xmm14, 1138(%rdx)
	vmovdqu	6912(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1144(%rdx)
	movq	%xmm14, 1160(%rdx)
	vmovdqu	6944(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1166(%rdx)
	movq	%xmm14, 1182(%rdx)
	vmovdqu	6976(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1188(%rdx)
	movq	%xmm14, 1204(%rdx)
	vmovdqu	7008(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1210(%rdx)
	movq	%xmm14, 1226(%rdx)
	vmovdqu	7040(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1232(%rdx)
	movq	%xmm14, 1248(%rdx)
	vmovdqu	7072(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1254(%rdx)
	movq	%xmm14, 1270(%rdx)
	vmovdqu	7104(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1276(%rdx)
	movq	%xmm14, 1292(%rdx)
	vmovdqu	7136(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1298(%rdx)
	movq	%xmm14, 1314(%rdx)
	vmovdqu	7168(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1320(%rdx)
	movq	%xmm14, 1336(%rdx)
	vmovdqu	7200(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1342(%rdx)
	movq	%xmm14, 1358(%rdx)
	vmovdqu	7232(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpand	%ymm5, %ymm9, %ymm9
	vpmaddwd	%ymm4, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrldq	$8, %ymm9, %ymm10
	vpsrlvq	%ymm7, %ymm9, %ymm9
	vpsllq	$34, %ymm10, %ymm10
	vpor	%ymm10, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm15
	vextracti128	$1, %ymm9, %xmm14
	vpblendvb	%xmm8, %xmm14, %xmm15, %xmm15
	vmovdqu	%xmm15, 1364(%rdx)
	movq	%xmm14, 1380(%rdx)
	vmovdqu	7264(%rsp), %ymm9
	vpmullw	%ymm1, %ymm9, %ymm10
	vpaddw	%ymm2, %ymm9, %ymm11
	vpsllw	$3, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm11
	vpandn	%ymm11, %ymm10, %ymm10
	vpsrlw	$15, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm9, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vpmaddwd	%ymm4, %ymm3, %ymm3
	vpsllvd	%ymm6, %ymm3, %ymm3
	vpsrldq	$8, %ymm3, %ymm4
	vpsrlvq	%ymm7, %ymm3, %ymm3
	vpsllq	$34, %ymm4, %ymm4
	vpor	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm8, %ymm3, %ymm3
	vmovdqu	%xmm3, %xmm2
	vextracti128	$1, %ymm3, %xmm3
	vpblendvb	%xmm8, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 1386(%rdx)
	movq	%xmm3, 1402(%rdx)
	leaq	1408(%rax), %rdx
	leaq	1152(%rsp), %rsi
	call	.L_poly_csubq$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$3:
	vmovdqu	glob_data + 736(%rip), %ymm0
	vpbroadcastw	glob_data + 4852(%rip), %ymm3
	vpbroadcastw	glob_data + 4854(%rip), %ymm5
	vpbroadcastw	glob_data + 4850(%rip), %ymm4
	vpbroadcastd	glob_data + 4824(%rip), %ymm1
	vpbroadcastq	glob_data + 4552(%rip), %ymm6
	vmovdqu	glob_data + 416(%rip), %ymm8
	vmovdqu	(%rsi), %ymm9
	vmovdqu	32(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, (%rdx)
	movd	%xmm7, 16(%rdx)
	vmovdqu	64(%rsi), %ymm9
	vmovdqu	96(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 20(%rdx)
	movd	%xmm7, 36(%rdx)
	vmovdqu	128(%rsi), %ymm9
	vmovdqu	160(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 40(%rdx)
	movd	%xmm7, 56(%rdx)
	vmovdqu	192(%rsi), %ymm9
	vmovdqu	224(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 60(%rdx)
	movd	%xmm7, 76(%rdx)
	vmovdqu	256(%rsi), %ymm9
	vmovdqu	288(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 80(%rdx)
	movd	%xmm7, 96(%rdx)
	vmovdqu	320(%rsi), %ymm9
	vmovdqu	352(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 100(%rdx)
	movd	%xmm7, 116(%rdx)
	vmovdqu	384(%rsi), %ymm9
	vmovdqu	416(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm9
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpmaddwd	%ymm1, %ymm9, %ymm9
	vpsllvd	%ymm6, %ymm9, %ymm9
	vpsrlvq	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm8, %ymm9, %ymm9
	vmovdqu	%xmm9, %xmm2
	vextracti128	$1, %ymm9, %xmm7
	vpblendvb	%xmm8, %xmm7, %xmm2, %xmm2
	vmovdqu	%xmm2, 120(%rdx)
	movd	%xmm7, 136(%rdx)
	vmovdqu	448(%rsi), %ymm9
	vmovdqu	480(%rsi), %ymm10
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhrsw	%ymm3, %ymm9, %ymm9
	vpmulhrsw	%ymm3, %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm3
	vpand	%ymm5, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm3, %ymm3
	vpmaddubsw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm1, %ymm3, %ymm3
	vpsllvd	%ymm6, %ymm3, %ymm3
	vpsrlvq	%ymm6, %ymm3, %ymm3
	vpshufb	%ymm8, %ymm3, %ymm3
	vmovdqu	%xmm3, %xmm2
	vextracti128	$1, %ymm3, %xmm3
	vpblendvb	%xmm8, %xmm3, %xmm2, %xmm2
	vmovdqu	%xmm2, 140(%rdx)
	movd	%xmm3, 156(%rdx)
	movq	19584(%rsp), %rsi
	lfence
	movq	$0, %rdx
	vmovdqu	64(%rsp), %ymm0
	vmovdqu	%ymm0, (%rsi)
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$2:
	movq	19608(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	19656(%rsp), %rbx
	movq	19664(%rsp), %rbp
	movq	19672(%rsp), %r12
	movq	19680(%rsp), %r13
	movq	19688(%rsp), %r14
	movq	19696(%rsp), %r15
	movq	19704(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$23808, %rsp
	movq	$23808, %rdi
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$62:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand$62
	movq	%rsi, %rsp
	lfence
	ret
	.type	jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand, %function
jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand:
	movq	%rsp, %rax
	leaq	-14624(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rbx, 14560(%rsp)
	movq	%rbp, 14568(%rsp)
	movq	%r12, 14576(%rsp)
	movq	%r13, 14584(%rsp)
	movq	%r14, 14592(%rsp)
	movq	%r15, 14600(%rsp)
	movq	%rax, 14608(%rsp)
	lfence
	movq	$0, %rax
	movq	%rdx, 14464(%rsp)
	movq	%rsi, %rax
	movq	%rsi, 14472(%rsp)
	movq	%rdi, 14480(%rsp)
	movq	%rax, 14488(%rsp)
	movq	(%rdx), %rax
	movq	%rax, (%rsp)
	movq	8(%rdx), %rax
	movq	%rax, 8(%rsp)
	movq	16(%rdx), %rax
	movq	%rax, 16(%rsp)
	movq	24(%rdx), %rax
	movq	%rax, 24(%rsp)
	movb	$4, 32(%rsp)
	leaq	64(%rsp), %rdi
	movq	%rsp, %rcx
	leaq	-248(%rsp), %rsp
	call	.L_sha3_512A_A33$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$45:
	leaq	248(%rsp), %rsp
	movq	64(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 14528(%rsp)
	movq	96(%rsp), %rax
	movq	%rax, 14496(%rsp)
	movq	72(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 14536(%rsp)
	movq	104(%rsp), %rax
	movq	%rax, 14504(%rsp)
	movq	80(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 14544(%rsp)
	movq	112(%rsp), %rax
	movq	%rax, 14512(%rsp)
	movq	88(%rsp), %rax
// declassify_val u64 %rax
	movq	%rax, 14552(%rsp)
	movq	120(%rsp), %rax
	movq	%rax, 14520(%rsp)
	movq	$0, %rax
	leaq	6272(%rsp), %rsi
	leaq	14528(%rsp), %rcx
	leaq	-2200(%rsp), %rsp
	call	.L_gen_matrix_avx2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$44:
	leaq	2200(%rsp), %rsp
	movb	$0, %bl
	leaq	2176(%rsp), %rax
	leaq	2688(%rsp), %r9
	leaq	3200(%rsp), %r10
	leaq	3712(%rsp), %r11
	leaq	14496(%rsp), %r8
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$43:
	leaq	600(%rsp), %rsp
	movb	$4, %bl
	leaq	4224(%rsp), %rax
	leaq	4736(%rsp), %r9
	leaq	5248(%rsp), %r10
	leaq	5760(%rsp), %r11
	leaq	14496(%rsp), %r8
	leaq	-600(%rsp), %rsp
	call	.L_poly_getnoise_eta1_4x$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$42:
	leaq	600(%rsp), %rsp
	leaq	2176(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$41:
	leaq	2688(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$40:
	leaq	3200(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$39:
	leaq	3712(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$38:
	leaq	4224(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$37:
	leaq	4736(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$36:
	leaq	5248(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$35:
	leaq	5760(%rsp), %rsi
	call	.L_poly_ntt$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$34:
	leaq	128(%rsp), %rsi
	leaq	6272(%rsp), %rcx
	leaq	2176(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$33:
	leaq	128(%rsp), %rsi
	leaq	6784(%rsp), %rcx
	leaq	2688(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$32:
	leaq	128(%rsp), %rsi
	leaq	7296(%rsp), %rcx
	leaq	3200(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$31:
	leaq	128(%rsp), %rsi
	leaq	7808(%rsp), %rcx
	leaq	3712(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$30:
	leaq	128(%rsp), %rdx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$29:
	leaq	640(%rsp), %rsi
	leaq	8320(%rsp), %rcx
	leaq	2176(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$28:
	leaq	640(%rsp), %rsi
	leaq	8832(%rsp), %rcx
	leaq	2688(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$27:
	leaq	640(%rsp), %rsi
	leaq	9344(%rsp), %rcx
	leaq	3200(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$26:
	leaq	640(%rsp), %rsi
	leaq	9856(%rsp), %rcx
	leaq	3712(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$25:
	leaq	640(%rsp), %rdx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$24:
	leaq	1152(%rsp), %rsi
	leaq	10368(%rsp), %rcx
	leaq	2176(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$23:
	leaq	1152(%rsp), %rsi
	leaq	10880(%rsp), %rcx
	leaq	2688(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$22:
	leaq	1152(%rsp), %rsi
	leaq	11392(%rsp), %rcx
	leaq	3200(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$21:
	leaq	1152(%rsp), %rsi
	leaq	11904(%rsp), %rcx
	leaq	3712(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$20:
	leaq	1152(%rsp), %rdx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$19:
	leaq	1664(%rsp), %rsi
	leaq	12416(%rsp), %rcx
	leaq	2176(%rsp), %rdi
	call	.L_poly_basemul$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$18:
	leaq	1664(%rsp), %rsi
	leaq	12928(%rsp), %rcx
	leaq	2688(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$17:
	leaq	1664(%rsp), %rsi
	leaq	13440(%rsp), %rcx
	leaq	3200(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$16:
	leaq	1664(%rsp), %rsi
	leaq	13952(%rsp), %rcx
	leaq	3712(%rsp), %rdi
	call	.L_poly_basemul_acc$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$15:
	leaq	1664(%rsp), %rdx
	call	.L_poly_frommont$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$14:
	leaq	128(%rsp), %rdx
	leaq	4224(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$13:
	leaq	640(%rsp), %rdx
	leaq	4736(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$12:
	leaq	1152(%rsp), %rdx
	leaq	5248(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$11:
	leaq	1664(%rsp), %rdx
	leaq	5760(%rsp), %rdi
	call	.L_poly_add2$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$10:
	leaq	128(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	640(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	1152(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	leaq	1664(%rsp), %rdx
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 736(%rip), %ymm1
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
	movq	14480(%rsp), %rcx
	movq	14488(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	%rax, %rdx
	leaq	2176(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$9:
	leaq	384(%rax), %rdx
	leaq	2688(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$8:
	leaq	768(%rax), %rdx
	leaq	3200(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$7:
	leaq	1152(%rax), %rdx
	leaq	3712(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$6:
	movq	%rcx, %rax
	movq	%rax, %rdx
	leaq	128(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$5:
	leaq	384(%rax), %rdx
	leaq	640(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$4:
	leaq	768(%rax), %rdx
	leaq	1152(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$3:
	leaq	1152(%rax), %rdx
	leaq	1664(%rsp), %rsi
	call	.L_i_poly_tobytes$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$2:
	movq	14528(%rsp), %rax
	movq	%rax, 1536(%rcx)
	movq	14536(%rsp), %rax
	movq	%rax, 1544(%rcx)
	movq	14544(%rsp), %rax
	movq	%rax, 1552(%rcx)
	movq	14552(%rsp), %rax
	movq	%rax, 1560(%rcx)
	movq	14472(%rsp), %rax
	lfence
	movq	$0, %rdx
	movq	(%rcx), %rsi
	movq	%rsi, 1536(%rax)
	movq	8(%rcx), %rsi
	movq	%rsi, 1544(%rax)
	movq	16(%rcx), %rsi
	movq	%rsi, 1552(%rax)
	movq	24(%rcx), %rsi
	movq	%rsi, 1560(%rax)
	movq	32(%rcx), %rsi
	movq	%rsi, 1568(%rax)
	movq	40(%rcx), %rsi
	movq	%rsi, 1576(%rax)
	movq	48(%rcx), %rsi
	movq	%rsi, 1584(%rax)
	movq	56(%rcx), %rsi
	movq	%rsi, 1592(%rax)
	movq	64(%rcx), %rsi
	movq	%rsi, 1600(%rax)
	movq	72(%rcx), %rsi
	movq	%rsi, 1608(%rax)
	movq	80(%rcx), %rsi
	movq	%rsi, 1616(%rax)
	movq	88(%rcx), %rsi
	movq	%rsi, 1624(%rax)
	movq	96(%rcx), %rsi
	movq	%rsi, 1632(%rax)
	movq	104(%rcx), %rsi
	movq	%rsi, 1640(%rax)
	movq	112(%rcx), %rsi
	movq	%rsi, 1648(%rax)
	movq	120(%rcx), %rsi
	movq	%rsi, 1656(%rax)
	movq	128(%rcx), %rsi
	movq	%rsi, 1664(%rax)
	movq	136(%rcx), %rsi
	movq	%rsi, 1672(%rax)
	movq	144(%rcx), %rsi
	movq	%rsi, 1680(%rax)
	movq	152(%rcx), %rsi
	movq	%rsi, 1688(%rax)
	movq	160(%rcx), %rsi
	movq	%rsi, 1696(%rax)
	movq	168(%rcx), %rsi
	movq	%rsi, 1704(%rax)
	movq	176(%rcx), %rsi
	movq	%rsi, 1712(%rax)
	movq	184(%rcx), %rsi
	movq	%rsi, 1720(%rax)
	movq	192(%rcx), %rsi
	movq	%rsi, 1728(%rax)
	movq	200(%rcx), %rsi
	movq	%rsi, 1736(%rax)
	movq	208(%rcx), %rsi
	movq	%rsi, 1744(%rax)
	movq	216(%rcx), %rsi
	movq	%rsi, 1752(%rax)
	movq	224(%rcx), %rsi
	movq	%rsi, 1760(%rax)
	movq	232(%rcx), %rsi
	movq	%rsi, 1768(%rax)
	movq	240(%rcx), %rsi
	movq	%rsi, 1776(%rax)
	movq	248(%rcx), %rsi
	movq	%rsi, 1784(%rax)
	movq	256(%rcx), %rsi
	movq	%rsi, 1792(%rax)
	movq	264(%rcx), %rsi
	movq	%rsi, 1800(%rax)
	movq	272(%rcx), %rsi
	movq	%rsi, 1808(%rax)
	movq	280(%rcx), %rsi
	movq	%rsi, 1816(%rax)
	movq	288(%rcx), %rsi
	movq	%rsi, 1824(%rax)
	movq	296(%rcx), %rsi
	movq	%rsi, 1832(%rax)
	movq	304(%rcx), %rsi
	movq	%rsi, 1840(%rax)
	movq	312(%rcx), %rsi
	movq	%rsi, 1848(%rax)
	movq	320(%rcx), %rsi
	movq	%rsi, 1856(%rax)
	movq	328(%rcx), %rsi
	movq	%rsi, 1864(%rax)
	movq	336(%rcx), %rsi
	movq	%rsi, 1872(%rax)
	movq	344(%rcx), %rsi
	movq	%rsi, 1880(%rax)
	movq	352(%rcx), %rsi
	movq	%rsi, 1888(%rax)
	movq	360(%rcx), %rsi
	movq	%rsi, 1896(%rax)
	movq	368(%rcx), %rsi
	movq	%rsi, 1904(%rax)
	movq	376(%rcx), %rsi
	movq	%rsi, 1912(%rax)
	movq	384(%rcx), %rsi
	movq	%rsi, 1920(%rax)
	movq	392(%rcx), %rsi
	movq	%rsi, 1928(%rax)
	movq	400(%rcx), %rsi
	movq	%rsi, 1936(%rax)
	movq	408(%rcx), %rsi
	movq	%rsi, 1944(%rax)
	movq	416(%rcx), %rsi
	movq	%rsi, 1952(%rax)
	movq	424(%rcx), %rsi
	movq	%rsi, 1960(%rax)
	movq	432(%rcx), %rsi
	movq	%rsi, 1968(%rax)
	movq	440(%rcx), %rsi
	movq	%rsi, 1976(%rax)
	movq	448(%rcx), %rsi
	movq	%rsi, 1984(%rax)
	movq	456(%rcx), %rsi
	movq	%rsi, 1992(%rax)
	movq	464(%rcx), %rsi
	movq	%rsi, 2000(%rax)
	movq	472(%rcx), %rsi
	movq	%rsi, 2008(%rax)
	movq	480(%rcx), %rsi
	movq	%rsi, 2016(%rax)
	movq	488(%rcx), %rsi
	movq	%rsi, 2024(%rax)
	movq	496(%rcx), %rsi
	movq	%rsi, 2032(%rax)
	movq	504(%rcx), %rsi
	movq	%rsi, 2040(%rax)
	movq	512(%rcx), %rsi
	movq	%rsi, 2048(%rax)
	movq	520(%rcx), %rsi
	movq	%rsi, 2056(%rax)
	movq	528(%rcx), %rsi
	movq	%rsi, 2064(%rax)
	movq	536(%rcx), %rsi
	movq	%rsi, 2072(%rax)
	movq	544(%rcx), %rsi
	movq	%rsi, 2080(%rax)
	movq	552(%rcx), %rsi
	movq	%rsi, 2088(%rax)
	movq	560(%rcx), %rsi
	movq	%rsi, 2096(%rax)
	movq	568(%rcx), %rsi
	movq	%rsi, 2104(%rax)
	movq	576(%rcx), %rsi
	movq	%rsi, 2112(%rax)
	movq	584(%rcx), %rsi
	movq	%rsi, 2120(%rax)
	movq	592(%rcx), %rsi
	movq	%rsi, 2128(%rax)
	movq	600(%rcx), %rsi
	movq	%rsi, 2136(%rax)
	movq	608(%rcx), %rsi
	movq	%rsi, 2144(%rax)
	movq	616(%rcx), %rsi
	movq	%rsi, 2152(%rax)
	movq	624(%rcx), %rsi
	movq	%rsi, 2160(%rax)
	movq	632(%rcx), %rsi
	movq	%rsi, 2168(%rax)
	movq	640(%rcx), %rsi
	movq	%rsi, 2176(%rax)
	movq	648(%rcx), %rsi
	movq	%rsi, 2184(%rax)
	movq	656(%rcx), %rsi
	movq	%rsi, 2192(%rax)
	movq	664(%rcx), %rsi
	movq	%rsi, 2200(%rax)
	movq	672(%rcx), %rsi
	movq	%rsi, 2208(%rax)
	movq	680(%rcx), %rsi
	movq	%rsi, 2216(%rax)
	movq	688(%rcx), %rsi
	movq	%rsi, 2224(%rax)
	movq	696(%rcx), %rsi
	movq	%rsi, 2232(%rax)
	movq	704(%rcx), %rsi
	movq	%rsi, 2240(%rax)
	movq	712(%rcx), %rsi
	movq	%rsi, 2248(%rax)
	movq	720(%rcx), %rsi
	movq	%rsi, 2256(%rax)
	movq	728(%rcx), %rsi
	movq	%rsi, 2264(%rax)
	movq	736(%rcx), %rsi
	movq	%rsi, 2272(%rax)
	movq	744(%rcx), %rsi
	movq	%rsi, 2280(%rax)
	movq	752(%rcx), %rsi
	movq	%rsi, 2288(%rax)
	movq	760(%rcx), %rsi
	movq	%rsi, 2296(%rax)
	movq	768(%rcx), %rsi
	movq	%rsi, 2304(%rax)
	movq	776(%rcx), %rsi
	movq	%rsi, 2312(%rax)
	movq	784(%rcx), %rsi
	movq	%rsi, 2320(%rax)
	movq	792(%rcx), %rsi
	movq	%rsi, 2328(%rax)
	movq	800(%rcx), %rsi
	movq	%rsi, 2336(%rax)
	movq	808(%rcx), %rsi
	movq	%rsi, 2344(%rax)
	movq	816(%rcx), %rsi
	movq	%rsi, 2352(%rax)
	movq	824(%rcx), %rsi
	movq	%rsi, 2360(%rax)
	movq	832(%rcx), %rsi
	movq	%rsi, 2368(%rax)
	movq	840(%rcx), %rsi
	movq	%rsi, 2376(%rax)
	movq	848(%rcx), %rsi
	movq	%rsi, 2384(%rax)
	movq	856(%rcx), %rsi
	movq	%rsi, 2392(%rax)
	movq	864(%rcx), %rsi
	movq	%rsi, 2400(%rax)
	movq	872(%rcx), %rsi
	movq	%rsi, 2408(%rax)
	movq	880(%rcx), %rsi
	movq	%rsi, 2416(%rax)
	movq	888(%rcx), %rsi
	movq	%rsi, 2424(%rax)
	movq	896(%rcx), %rsi
	movq	%rsi, 2432(%rax)
	movq	904(%rcx), %rsi
	movq	%rsi, 2440(%rax)
	movq	912(%rcx), %rsi
	movq	%rsi, 2448(%rax)
	movq	920(%rcx), %rsi
	movq	%rsi, 2456(%rax)
	movq	928(%rcx), %rsi
	movq	%rsi, 2464(%rax)
	movq	936(%rcx), %rsi
	movq	%rsi, 2472(%rax)
	movq	944(%rcx), %rsi
	movq	%rsi, 2480(%rax)
	movq	952(%rcx), %rsi
	movq	%rsi, 2488(%rax)
	movq	960(%rcx), %rsi
	movq	%rsi, 2496(%rax)
	movq	968(%rcx), %rsi
	movq	%rsi, 2504(%rax)
	movq	976(%rcx), %rsi
	movq	%rsi, 2512(%rax)
	movq	984(%rcx), %rsi
	movq	%rsi, 2520(%rax)
	movq	992(%rcx), %rsi
	movq	%rsi, 2528(%rax)
	movq	1000(%rcx), %rsi
	movq	%rsi, 2536(%rax)
	movq	1008(%rcx), %rsi
	movq	%rsi, 2544(%rax)
	movq	1016(%rcx), %rsi
	movq	%rsi, 2552(%rax)
	movq	1024(%rcx), %rsi
	movq	%rsi, 2560(%rax)
	movq	1032(%rcx), %rsi
	movq	%rsi, 2568(%rax)
	movq	1040(%rcx), %rsi
	movq	%rsi, 2576(%rax)
	movq	1048(%rcx), %rsi
	movq	%rsi, 2584(%rax)
	movq	1056(%rcx), %rsi
	movq	%rsi, 2592(%rax)
	movq	1064(%rcx), %rsi
	movq	%rsi, 2600(%rax)
	movq	1072(%rcx), %rsi
	movq	%rsi, 2608(%rax)
	movq	1080(%rcx), %rsi
	movq	%rsi, 2616(%rax)
	movq	1088(%rcx), %rsi
	movq	%rsi, 2624(%rax)
	movq	1096(%rcx), %rsi
	movq	%rsi, 2632(%rax)
	movq	1104(%rcx), %rsi
	movq	%rsi, 2640(%rax)
	movq	1112(%rcx), %rsi
	movq	%rsi, 2648(%rax)
	movq	1120(%rcx), %rsi
	movq	%rsi, 2656(%rax)
	movq	1128(%rcx), %rsi
	movq	%rsi, 2664(%rax)
	movq	1136(%rcx), %rsi
	movq	%rsi, 2672(%rax)
	movq	1144(%rcx), %rsi
	movq	%rsi, 2680(%rax)
	movq	1152(%rcx), %rsi
	movq	%rsi, 2688(%rax)
	movq	1160(%rcx), %rsi
	movq	%rsi, 2696(%rax)
	movq	1168(%rcx), %rsi
	movq	%rsi, 2704(%rax)
	movq	1176(%rcx), %rsi
	movq	%rsi, 2712(%rax)
	movq	1184(%rcx), %rsi
	movq	%rsi, 2720(%rax)
	movq	1192(%rcx), %rsi
	movq	%rsi, 2728(%rax)
	movq	1200(%rcx), %rsi
	movq	%rsi, 2736(%rax)
	movq	1208(%rcx), %rsi
	movq	%rsi, 2744(%rax)
	movq	1216(%rcx), %rsi
	movq	%rsi, 2752(%rax)
	movq	1224(%rcx), %rsi
	movq	%rsi, 2760(%rax)
	movq	1232(%rcx), %rsi
	movq	%rsi, 2768(%rax)
	movq	1240(%rcx), %rsi
	movq	%rsi, 2776(%rax)
	movq	1248(%rcx), %rsi
	movq	%rsi, 2784(%rax)
	movq	1256(%rcx), %rsi
	movq	%rsi, 2792(%rax)
	movq	1264(%rcx), %rsi
	movq	%rsi, 2800(%rax)
	movq	1272(%rcx), %rsi
	movq	%rsi, 2808(%rax)
	movq	1280(%rcx), %rsi
	movq	%rsi, 2816(%rax)
	movq	1288(%rcx), %rsi
	movq	%rsi, 2824(%rax)
	movq	1296(%rcx), %rsi
	movq	%rsi, 2832(%rax)
	movq	1304(%rcx), %rsi
	movq	%rsi, 2840(%rax)
	movq	1312(%rcx), %rsi
	movq	%rsi, 2848(%rax)
	movq	1320(%rcx), %rsi
	movq	%rsi, 2856(%rax)
	movq	1328(%rcx), %rsi
	movq	%rsi, 2864(%rax)
	movq	1336(%rcx), %rsi
	movq	%rsi, 2872(%rax)
	movq	1344(%rcx), %rsi
	movq	%rsi, 2880(%rax)
	movq	1352(%rcx), %rsi
	movq	%rsi, 2888(%rax)
	movq	1360(%rcx), %rsi
	movq	%rsi, 2896(%rax)
	movq	1368(%rcx), %rsi
	movq	%rsi, 2904(%rax)
	movq	1376(%rcx), %rsi
	movq	%rsi, 2912(%rax)
	movq	1384(%rcx), %rsi
	movq	%rsi, 2920(%rax)
	movq	1392(%rcx), %rsi
	movq	%rsi, 2928(%rax)
	movq	1400(%rcx), %rsi
	movq	%rsi, 2936(%rax)
	movq	1408(%rcx), %rsi
	movq	%rsi, 2944(%rax)
	movq	1416(%rcx), %rsi
	movq	%rsi, 2952(%rax)
	movq	1424(%rcx), %rsi
	movq	%rsi, 2960(%rax)
	movq	1432(%rcx), %rsi
	movq	%rsi, 2968(%rax)
	movq	1440(%rcx), %rsi
	movq	%rsi, 2976(%rax)
	movq	1448(%rcx), %rsi
	movq	%rsi, 2984(%rax)
	movq	1456(%rcx), %rsi
	movq	%rsi, 2992(%rax)
	movq	1464(%rcx), %rsi
	movq	%rsi, 3000(%rax)
	movq	1472(%rcx), %rsi
	movq	%rsi, 3008(%rax)
	movq	1480(%rcx), %rsi
	movq	%rsi, 3016(%rax)
	movq	1488(%rcx), %rsi
	movq	%rsi, 3024(%rax)
	movq	1496(%rcx), %rsi
	movq	%rsi, 3032(%rax)
	movq	1504(%rcx), %rsi
	movq	%rsi, 3040(%rax)
	movq	1512(%rcx), %rsi
	movq	%rsi, 3048(%rax)
	movq	1520(%rcx), %rsi
	movq	%rsi, 3056(%rax)
	movq	1528(%rcx), %rsi
	movq	%rsi, 3064(%rax)
	movq	1536(%rcx), %rsi
	movq	%rsi, 3072(%rax)
	movq	1544(%rcx), %rsi
	movq	%rsi, 3080(%rax)
	movq	1552(%rcx), %rsi
	movq	%rsi, 3088(%rax)
	movq	1560(%rcx), %rsi
	movq	%rsi, 3096(%rax)
	movq	%rax, 14472(%rsp)
	leaq	3104(%rax), %rax
	leaq	-248(%rsp), %rsp
	call	.L_sha3_256A_APK$1
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$1:
	leaq	248(%rsp), %rsp
	movq	14472(%rsp), %rdx
	movq	14464(%rsp), %rcx
	lfence
	movq	$0, %rsi
	movq	32(%rcx), %rax
	movq	%rax, 3136(%rdx)
	movq	40(%rcx), %rax
	movq	%rax, 3144(%rdx)
	movq	48(%rcx), %rax
	movq	%rax, 3152(%rdx)
	movq	56(%rcx), %rax
	movq	%rax, 3160(%rdx)
	xorl	%eax, %eax
	movq	14560(%rsp), %rbx
	movq	14568(%rsp), %rbp
	movq	14576(%rsp), %r12
	movq	14584(%rsp), %r13
	movq	14592(%rsp), %r14
	movq	14600(%rsp), %r15
	movq	14608(%rsp), %rsp
	movq	%rsp, %rsi
	vpxor	%ymm2, %ymm2, %ymm2
	andq	$-32, %rsp
	subq	$18720, %rsp
	movq	$18720, %rdi
.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$46:
	subq	$32, %rdi
	vmovdqu	%ymm2, (%rsp,%rdi)
	jne 	.Ljade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand$46
	movq	%rsi, %rsp
	lfence
	ret
.L_gen_matrix_avx2$1:
	movq	%rax, 2176(%rsp)
	leaq	32(%rsp), %rdx
	movq	$0, %r8
	movq	%rsi, 2184(%rsp)
	movq	%rcx, 2192(%rsp)
	movq	2176(%rsp), %rax
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$21:
	leaq	856(%rsp), %rsp
	movq	2184(%rsp), %rsi
	movq	2192(%rsp), %rcx
	lfence
	movq	$0, %r8
	movq	$8, %r8
	movq	%rsi, 2192(%rsp)
	movq	%rcx, 2184(%rsp)
	leaq	2048(%rsi), %rsi
	movq	2176(%rsp), %rax
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$20:
	leaq	856(%rsp), %rsp
	movq	2192(%rsp), %rsi
	movq	2184(%rsp), %rcx
	lfence
	movq	$0, %r8
	movq	$16, %r8
	movq	%rsi, 2184(%rsp)
	movq	%rcx, 2192(%rsp)
	leaq	4096(%rsi), %rsi
	movq	2176(%rsp), %rax
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$19:
	leaq	856(%rsp), %rsp
	movq	2184(%rsp), %rsi
	movq	2192(%rsp), %rcx
	lfence
	movq	$0, %r8
	movq	$24, %r8
	movq	%rsi, 2192(%rsp)
	leaq	6144(%rsi), %rsi
	movq	2176(%rsp), %rax
	leaq	-856(%rsp), %rsp
	call	.L_gen_matrix_sample_four_polynomials$1
.L_gen_matrix_avx2$18:
	leaq	856(%rsp), %rsp
	movq	2192(%rsp), %rsi
	lfence
	movq	$0, %rdx
	movq	%rsi, %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$17:
	leaq	512(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$16:
	leaq	1024(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$15:
	leaq	1536(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$14:
	leaq	2048(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$13:
	leaq	2560(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$12:
	leaq	3072(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$11:
	leaq	3584(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$10:
	leaq	4096(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$9:
	leaq	4608(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$8:
	leaq	5120(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$7:
	leaq	5632(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$6:
	leaq	6144(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$5:
	leaq	6656(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$4:
	leaq	7168(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$3:
	leaq	7680(%rsi), %rdx
	call	.L_nttunpack$1
.L_gen_matrix_avx2$2:
	ret
.L_gen_matrix_sample_four_polynomials$1:
	leaq	glob_data + 4752(%rip), %rdi
	shlq	$5, %rax
	addq	%rax, %r8
	movq	(%rdi,%r8), %rax
	movq	%rax, 832(%rsp)
	movq	%rdx, 840(%rsp)
	movq	%rsi, 848(%rsp)
	leaq	32(%rsp), %rax
	leaq	832(%rsp), %rdi
	leaq	-8(%rsp), %rsp
	call	.L_shake128x4_absorb_A32_A2$1
.L_gen_matrix_sample_four_polynomials$7:
	leaq	8(%rsp), %rsp
	movq	840(%rsp), %rcx
	lfence
	movq	$0, %rdx
	call	.L_shake128x4_squeeze3blocks$1
.L_gen_matrix_sample_four_polynomials$6:
	movq	848(%rsp), %rax
	lfence
	movq	$0, %rsi
	movq	%rcx, 848(%rsp)
	movq	%rax, 840(%rsp)
	movq	%rcx, %r8
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$5:
	leaq	792(%rsp), %rsp
	movq	848(%rsp), %rcx
	movq	840(%rsp), %rax
	orq 	%rsi, %rcx
	orq 	%rsi, %rax
	movq	%rcx, 840(%rsp)
	movq	%rax, 848(%rsp)
	leaq	536(%rcx), %r8
	leaq	512(%rax), %rax
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$4:
	leaq	792(%rsp), %rsp
	movq	840(%rsp), %rcx
	movq	848(%rsp), %rax
	orq 	%rsi, %rcx
	orq 	%rsi, %rax
	movq	%rcx, 848(%rsp)
	movq	%rax, 840(%rsp)
	leaq	1072(%rcx), %r8
	leaq	1024(%rax), %rax
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$3:
	leaq	792(%rsp), %rsp
	movq	848(%rsp), %rcx
	movq	840(%rsp), %rax
	orq 	%rsi, %rcx
	orq 	%rsi, %rax
	movq	%rcx, 840(%rsp)
	movq	%rax, 848(%rsp)
	leaq	1608(%rcx), %r8
	leaq	1536(%rax), %rax
	leaq	-792(%rsp), %rsp
	call	.L__gen_matrix_fill_polynomial$1
.L_gen_matrix_sample_four_polynomials$2:
	leaq	792(%rsp), %rsp
	movq	840(%rsp), %rdx
	movq	848(%rsp), %rax
	orq 	%rsi, %rdx
	orq 	%rsi, %rax
	ret
.L__gen_matrix_fill_polynomial$1:
	movq	%rax, 768(%rsp)
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
	movq	768(%rsp), %rcx
	orq 	%rsi, %rcx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx)
	vmovdqu	128(%rax), %ymm0
	vmovdqu	%ymm0, 128(%rcx)
	vmovdqu	160(%rax), %ymm0
	vmovdqu	%ymm0, 160(%rcx)
	vmovdqu	192(%rax), %ymm0
	vmovdqu	%ymm0, 192(%rcx)
	vmovdqu	224(%rax), %ymm0
	vmovdqu	%ymm0, 224(%rcx)
	vmovdqu	256(%rax), %ymm0
	vmovdqu	%ymm0, 256(%rcx)
	vmovdqu	288(%rax), %ymm0
	vmovdqu	%ymm0, 288(%rcx)
	vmovdqu	320(%rax), %ymm0
	vmovdqu	%ymm0, 320(%rcx)
	vmovdqu	352(%rax), %ymm0
	vmovdqu	%ymm0, 352(%rcx)
	vmovdqu	384(%rax), %ymm0
	vmovdqu	%ymm0, 384(%rcx)
	vmovdqu	416(%rax), %ymm0
	vmovdqu	%ymm0, 416(%rcx)
	vmovdqu	448(%rax), %ymm0
	vmovdqu	%ymm0, 448(%rcx)
	vmovdqu	480(%rax), %ymm0
	vmovdqu	%ymm0, 480(%rcx)
	ret
.L_gen_matrix_buf_rejection$1:
	vmovdqu	glob_data + 96(%rip), %ymm0
	vmovdqu	glob_data + 32(%rip), %ymm5
	vmovdqu	glob_data + 0(%rip), %ymm1
	vmovdqu	glob_data + 64(%rip), %ymm2
	leaq	glob_data + 2464(%rip), %rcx
	jmp 	.L_gen_matrix_buf_rejection$2
.L_gen_matrix_buf_rejection$3:
	movq	$-1, %r9
	cmovnb	%r9, %rsi
	vpermq	$148, (%r8,%rdx), %ymm3
	vpermq	$148, 24(%r8,%rdx), %ymm4
	vpshufb	%ymm0, %ymm3, %ymm3
	vpshufb	%ymm0, %ymm4, %ymm4
	vpsrlw	$4, %ymm3, %ymm6
	vpsrlw	$4, %ymm4, %ymm7
	vpblendw	$170, %ymm6, %ymm3, %ymm3
	vpblendw	$170, %ymm7, %ymm4, %ymm4
	vpand	%ymm5, %ymm3, %ymm3
	vpand	%ymm5, %ymm4, %ymm4
	vpcmpgtw	%ymm3, %ymm1, %ymm6
	vpcmpgtw	%ymm4, %ymm1, %ymm7
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
	vpshufb	%ymm6, %ymm3, %ymm3
	vpshufb	%ymm8, %ymm4, %ymm4
	vmovdqu	%xmm3, (%rax,%rdi,2)
	vextracti128	$1, %ymm3, (%rax,%r10,2)
	vmovdqu	%xmm4, (%rax,%r11,2)
	vextracti128	$1, %ymm4, (%rax,%rbx,2)
	movq	%r9, %rdi
	addq	$48, %rdx
.L_gen_matrix_buf_rejection$2:
	cmpq	$480, %rdx
	jb  	.L_gen_matrix_buf_rejection$3
	movq	$-1, %r9
	cmovb	%r9, %rsi
	vpermq	$148, (%r8,%rdx), %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vpsrlw	$4, %ymm3, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vpcmpgtw	%ymm3, %ymm1, %ymm6
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
	vpshufb	%ymm6, %ymm3, %ymm3
	vmovdqu	%xmm3, (%rax,%rdi,2)
	vextracti128	$1, %ymm3, (%rax,%r10,2)
	ret
.L_i_poly_decompress_dv5$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 384(%rip), %ymm1
	vmovdqu	glob_data + 352(%rip), %ymm5
	vmovdqu	glob_data + 320(%rip), %ymm4
	vmovq	(%rdi), %xmm2
	movw	8(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsi)
	vmovq	10(%rdi), %xmm2
	movw	18(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 32(%rsi)
	vmovq	20(%rdi), %xmm2
	movw	28(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 64(%rsi)
	vmovq	30(%rdi), %xmm2
	movw	38(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 96(%rsi)
	vmovq	40(%rdi), %xmm2
	movw	48(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 128(%rsi)
	vmovq	50(%rdi), %xmm2
	movw	58(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 160(%rsi)
	vmovq	60(%rdi), %xmm2
	movw	68(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 192(%rsi)
	vmovq	70(%rdi), %xmm2
	movw	78(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 224(%rsi)
	vmovq	80(%rdi), %xmm2
	movw	88(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 256(%rsi)
	vmovq	90(%rdi), %xmm2
	movw	98(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 288(%rsi)
	vmovq	100(%rdi), %xmm2
	movw	108(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 320(%rsi)
	vmovq	110(%rdi), %xmm2
	movw	118(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 352(%rsi)
	vmovq	120(%rdi), %xmm2
	movw	128(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 384(%rsi)
	vmovq	130(%rdi), %xmm2
	movw	138(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 416(%rsi)
	vmovq	140(%rdi), %xmm2
	movw	148(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 448(%rsi)
	vmovq	150(%rdi), %xmm2
	movw	158(%rdi), %r8w
	vpinsrw	$4, %r8d, %xmm2, %xmm2
	vmovdqu	%xmm2, 16(%rsp)
	vbroadcasti128	16(%rsp), %ymm2
	vpshufb	%ymm1, %ymm2, %ymm2
	vpand	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	vpmulhrsw	%ymm0, %ymm2, %ymm2
	vmovdqu	%ymm2, 480(%rsi)
	ret
.L_i_poly_tomsg$1:
	call	.L_poly_csubq$1
.L_i_poly_tomsg$2:
	leaq	glob_data + 576(%rip), %rcx
	vmovdqu	(%rcx), %ymm0
	leaq	glob_data + 544(%rip), %rcx
	vmovdqu	(%rcx), %ymm1
	vmovdqu	(%rsi), %ymm3
	vmovdqu	32(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, (%rdx)
	vmovdqu	64(%rsi), %ymm3
	vmovdqu	96(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 4(%rdx)
	vmovdqu	128(%rsi), %ymm3
	vmovdqu	160(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 8(%rdx)
	vmovdqu	192(%rsi), %ymm3
	vmovdqu	224(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 12(%rdx)
	vmovdqu	256(%rsi), %ymm3
	vmovdqu	288(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 16(%rdx)
	vmovdqu	320(%rsi), %ymm3
	vmovdqu	352(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 20(%rdx)
	vmovdqu	384(%rsi), %ymm3
	vmovdqu	416(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 24(%rdx)
	vmovdqu	448(%rsi), %ymm3
	vmovdqu	480(%rsi), %ymm4
	vpsubw	%ymm3, %ymm0, %ymm3
	vpsubw	%ymm4, %ymm0, %ymm4
	vpsraw	$15, %ymm3, %ymm6
	vpsraw	$15, %ymm4, %ymm7
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpsubw	%ymm1, %ymm3, %ymm3
	vpsubw	%ymm1, %ymm4, %ymm4
	vpacksswb	%ymm4, %ymm3, %ymm3
	vpermq	$216, %ymm3, %ymm3
	vpmovmskb	%ymm3, %ecx
	movl	%ecx, 28(%rdx)
	ret
.L_i_poly_tobytes$1:
	call	.L_poly_csubq$1
.L_i_poly_tobytes$2:
	vmovdqu	(%rsi), %ymm4
	vmovdqu	32(%rsi), %ymm5
	vmovdqu	64(%rsi), %ymm8
	vmovdqu	96(%rsi), %ymm7
	vmovdqu	128(%rsi), %ymm1
	vmovdqu	160(%rsi), %ymm6
	vmovdqu	192(%rsi), %ymm2
	vmovdqu	224(%rsi), %ymm12
	vpsllw	$12, %ymm5, %ymm0
	vpor	%ymm4, %ymm0, %ymm3
	vpsrlw	$4, %ymm5, %ymm4
	vpsllw	$8, %ymm8, %ymm5
	vpor	%ymm5, %ymm4, %ymm4
	vpsrlw	$8, %ymm8, %ymm5
	vpsllw	$4, %ymm7, %ymm8
	vpor	%ymm8, %ymm5, %ymm5
	vpsllw	$12, %ymm6, %ymm8
	vpor	%ymm1, %ymm8, %ymm7
	vpsrlw	$4, %ymm6, %ymm1
	vpsllw	$8, %ymm2, %ymm10
	vpor	%ymm10, %ymm1, %ymm1
	vpsrlw	$8, %ymm2, %ymm10
	vpsllw	$4, %ymm12, %ymm6
	vpor	%ymm6, %ymm10, %ymm2
	vpslld	$16, %ymm4, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm6
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm4, %ymm3, %ymm3
	vpslld	$16, %ymm7, %ymm4
	vpblendw	$170, %ymm4, %ymm5, %ymm8
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm7, %ymm5, %ymm4
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm1, %ymm7
	vpsrld	$16, %ymm1, %ymm5
	vpblendw	$170, %ymm2, %ymm5, %ymm2
	vmovsldup	%ymm8, %ymm15
	vpblendd	$170, %ymm15, %ymm6, %ymm1
	vpsrlq	$32, %ymm6, %ymm5
	vpblendd	$170, %ymm8, %ymm5, %ymm5
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm3, %ymm7, %ymm3
	vmovsldup	%ymm2, %ymm15
	vpblendd	$170, %ymm15, %ymm4, %ymm7
	vpsrlq	$32, %ymm4, %ymm4
	vpblendd	$170, %ymm2, %ymm4, %ymm2
	vpunpcklqdq	%ymm6, %ymm1, %ymm4
	vpunpckhqdq	%ymm6, %ymm1, %ymm6
	vpunpcklqdq	%ymm5, %ymm7, %ymm8
	vpunpckhqdq	%ymm5, %ymm7, %ymm1
	vpunpcklqdq	%ymm2, %ymm3, %ymm5
	vpunpckhqdq	%ymm2, %ymm3, %ymm2
	vperm2i128	$32, %ymm8, %ymm4, %ymm15
	vperm2i128	$49, %ymm8, %ymm4, %ymm7
	vperm2i128	$32, %ymm6, %ymm5, %ymm8
	vperm2i128	$49, %ymm6, %ymm5, %ymm0
	vperm2i128	$32, %ymm2, %ymm1, %ymm3
	vperm2i128	$49, %ymm2, %ymm1, %ymm1
	vmovdqu	%ymm15, (%rdx)
	vmovdqu	%ymm8, 32(%rdx)
	vmovdqu	%ymm3, 64(%rdx)
	vmovdqu	%ymm7, 96(%rdx)
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	%ymm1, 160(%rdx)
	vmovdqu	256(%rsi), %ymm4
	vmovdqu	288(%rsi), %ymm3
	vmovdqu	320(%rsi), %ymm8
	vmovdqu	352(%rsi), %ymm7
	vmovdqu	384(%rsi), %ymm1
	vmovdqu	416(%rsi), %ymm6
	vmovdqu	448(%rsi), %ymm2
	vmovdqu	480(%rsi), %ymm12
	vpsllw	$12, %ymm3, %ymm0
	vpor	%ymm4, %ymm0, %ymm0
	vpsrlw	$4, %ymm3, %ymm4
	vpsllw	$8, %ymm8, %ymm3
	vpor	%ymm3, %ymm4, %ymm15
	vpsrlw	$8, %ymm8, %ymm3
	vpsllw	$4, %ymm7, %ymm8
	vpor	%ymm8, %ymm3, %ymm3
	vpsllw	$12, %ymm6, %ymm8
	vpor	%ymm1, %ymm8, %ymm8
	vpsrlw	$4, %ymm6, %ymm1
	vpsllw	$8, %ymm2, %ymm4
	vpor	%ymm4, %ymm1, %ymm1
	vpsrlw	$8, %ymm2, %ymm4
	vpsllw	$4, %ymm12, %ymm6
	vpor	%ymm6, %ymm4, %ymm2
	vpslld	$16, %ymm15, %ymm4
	vpblendw	$170, %ymm4, %ymm0, %ymm4
	vpsrld	$16, %ymm0, %ymm5
	vpblendw	$170, %ymm15, %ymm5, %ymm5
	vpslld	$16, %ymm8, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm6
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm3
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm1, %ymm7
	vpsrld	$16, %ymm1, %ymm8
	vpblendw	$170, %ymm2, %ymm8, %ymm2
	vmovsldup	%ymm6, %ymm15
	vpblendd	$170, %ymm15, %ymm4, %ymm1
	vpsrlq	$32, %ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm4
	vmovsldup	%ymm5, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm5, %ymm7, %ymm5
	vmovsldup	%ymm2, %ymm15
	vpblendd	$170, %ymm15, %ymm3, %ymm7
	vpsrlq	$32, %ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm2
	vpunpcklqdq	%ymm6, %ymm1, %ymm3
	vpunpckhqdq	%ymm6, %ymm1, %ymm6
	vpunpcklqdq	%ymm4, %ymm7, %ymm8
	vpunpckhqdq	%ymm4, %ymm7, %ymm1
	vpunpcklqdq	%ymm2, %ymm5, %ymm4
	vpunpckhqdq	%ymm2, %ymm5, %ymm2
	vperm2i128	$32, %ymm8, %ymm3, %ymm15
	vperm2i128	$49, %ymm8, %ymm3, %ymm7
	vperm2i128	$32, %ymm6, %ymm4, %ymm8
	vperm2i128	$49, %ymm6, %ymm4, %ymm0
	vperm2i128	$32, %ymm2, %ymm1, %ymm3
	vperm2i128	$49, %ymm2, %ymm1, %ymm1
	vmovdqu	%ymm15, 192(%rdx)
	vmovdqu	%ymm8, 224(%rdx)
	vmovdqu	%ymm3, 256(%rdx)
	vmovdqu	%ymm7, 288(%rdx)
	vmovdqu	%ymm0, 320(%rdx)
	vmovdqu	%ymm1, 352(%rdx)
	ret
.L_poly_sub$1:
	vmovdqu	(%rcx), %ymm1
	vmovdqu	(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, (%rsi)
	vmovdqu	32(%rcx), %ymm1
	vmovdqu	32(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 32(%rsi)
	vmovdqu	64(%rcx), %ymm1
	vmovdqu	64(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	96(%rcx), %ymm1
	vmovdqu	96(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 96(%rsi)
	vmovdqu	128(%rcx), %ymm1
	vmovdqu	128(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	160(%rcx), %ymm1
	vmovdqu	160(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rsi)
	vmovdqu	192(%rcx), %ymm1
	vmovdqu	192(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rsi)
	vmovdqu	224(%rcx), %ymm1
	vmovdqu	224(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rsi)
	vmovdqu	256(%rcx), %ymm1
	vmovdqu	256(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rsi)
	vmovdqu	288(%rcx), %ymm1
	vmovdqu	288(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rsi)
	vmovdqu	320(%rcx), %ymm1
	vmovdqu	320(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	352(%rcx), %ymm1
	vmovdqu	352(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 352(%rsi)
	vmovdqu	384(%rcx), %ymm1
	vmovdqu	384(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	416(%rcx), %ymm1
	vmovdqu	416(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rsi)
	vmovdqu	448(%rcx), %ymm1
	vmovdqu	448(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 448(%rsi)
	vmovdqu	480(%rcx), %ymm1
	vmovdqu	480(%rdi), %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rsi)
	ret
.L_poly_ntt$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vpbroadcastd	glob_data + 1632(%rip), %ymm2
	vpbroadcastd	glob_data + 1636(%rip), %ymm4
	vmovdqu	(%rsi), %ymm9
	vmovdqu	32(%rsi), %ymm14
	vmovdqu	64(%rsi), %ymm1
	vmovdqu	96(%rsi), %ymm3
	vmovdqu	256(%rsi), %ymm5
	vmovdqu	288(%rsi), %ymm7
	vmovdqu	320(%rsi), %ymm12
	vmovdqu	352(%rsi), %ymm13
	vpmullw	%ymm5, %ymm2, %ymm6
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm15
	vpmullw	%ymm12, %ymm2, %ymm10
	vpmulhw	%ymm12, %ymm4, %ymm7
	vpmullw	%ymm13, %ymm2, %ymm11
	vpmulhw	%ymm13, %ymm4, %ymm12
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpsubw	%ymm15, %ymm14, %ymm13
	vpaddw	%ymm14, %ymm15, %ymm14
	vpsubw	%ymm5, %ymm9, %ymm15
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm12, %ymm3, %ymm5
	vpaddw	%ymm3, %ymm12, %ymm3
	vpsubw	%ymm7, %ymm1, %ymm12
	vpaddw	%ymm1, %ymm7, %ymm1
	vpaddw	%ymm15, %ymm6, %ymm7
	vpsubw	%ymm6, %ymm9, %ymm6
	vpaddw	%ymm13, %ymm8, %ymm9
	vpsubw	%ymm8, %ymm14, %ymm8
	vpaddw	%ymm12, %ymm10, %ymm12
	vpsubw	%ymm10, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm11, %ymm5
	vpsubw	%ymm11, %ymm3, %ymm3
	vmovdqu	%ymm6, (%rsi)
	vmovdqu	%ymm8, 32(%rsi)
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	%ymm3, 96(%rsi)
	vmovdqu	%ymm7, 256(%rsi)
	vmovdqu	%ymm9, 288(%rsi)
	vmovdqu	%ymm12, 320(%rsi)
	vmovdqu	%ymm5, 352(%rsi)
	vmovdqu	128(%rsi), %ymm9
	vmovdqu	160(%rsi), %ymm14
	vmovdqu	192(%rsi), %ymm1
	vmovdqu	224(%rsi), %ymm3
	vmovdqu	384(%rsi), %ymm5
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	448(%rsi), %ymm12
	vmovdqu	480(%rsi), %ymm13
	vpmullw	%ymm5, %ymm2, %ymm15
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpmullw	%ymm7, %ymm2, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm7
	vpmullw	%ymm12, %ymm2, %ymm10
	vpmulhw	%ymm12, %ymm4, %ymm6
	vpmullw	%ymm13, %ymm2, %ymm11
	vpmulhw	%ymm13, %ymm4, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm4
	vpsubw	%ymm7, %ymm14, %ymm13
	vpaddw	%ymm14, %ymm7, %ymm14
	vpsubw	%ymm5, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm12, %ymm3, %ymm5
	vpaddw	%ymm3, %ymm12, %ymm3
	vpsubw	%ymm6, %ymm1, %ymm12
	vpaddw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm7, %ymm2, %ymm6
	vpsubw	%ymm2, %ymm9, %ymm7
	vpaddw	%ymm13, %ymm8, %ymm9
	vpsubw	%ymm8, %ymm14, %ymm11
	vpaddw	%ymm12, %ymm10, %ymm12
	vpsubw	%ymm10, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm4, %ymm3, %ymm3
	vmovdqu	%ymm6, 384(%rsi)
	vmovdqu	%ymm9, 416(%rsi)
	vmovdqu	%ymm12, 448(%rsi)
	vmovdqu	%ymm5, 480(%rsi)
	vpbroadcastd	glob_data + 1640(%rip), %ymm2
	vpbroadcastd	glob_data + 1644(%rip), %ymm8
	vmovdqu	%ymm7, %ymm10
	vmovdqu	%ymm11, %ymm12
	vmovdqu	%ymm1, %ymm6
	vmovdqu	%ymm3, %ymm11
	vmovdqu	(%rsi), %ymm9
	vmovdqu	32(%rsi), %ymm5
	vmovdqu	64(%rsi), %ymm7
	vmovdqu	96(%rsi), %ymm4
	vpmullw	%ymm10, %ymm2, %ymm15
	vpmulhw	%ymm10, %ymm8, %ymm3
	vpmullw	%ymm12, %ymm2, %ymm14
	vpmulhw	%ymm12, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm2, %ymm1
	vpmulhw	%ymm6, %ymm8, %ymm6
	vpmullw	%ymm11, %ymm2, %ymm2
	vpmulhw	%ymm11, %ymm8, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm14, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm10, %ymm10
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm12, %ymm4, %ymm3
	vpaddw	%ymm4, %ymm12, %ymm5
	vpsubw	%ymm6, %ymm7, %ymm4
	vpaddw	%ymm7, %ymm6, %ymm6
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm12
	vpaddw	%ymm13, %ymm8, %ymm11
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm4, %ymm1, %ymm4
	vpsubw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm3, %ymm2, %ymm10
	vpsubw	%ymm2, %ymm5, %ymm14
	vmovdqu	glob_data + 1648(%rip), %ymm2
	vmovdqu	glob_data + 1680(%rip), %ymm3
	vperm2i128	$32, %ymm7, %ymm12, %ymm9
	vperm2i128	$49, %ymm7, %ymm12, %ymm5
	vperm2i128	$32, %ymm11, %ymm8, %ymm6
	vperm2i128	$49, %ymm11, %ymm8, %ymm11
	vperm2i128	$32, %ymm4, %ymm1, %ymm7
	vperm2i128	$49, %ymm4, %ymm1, %ymm1
	vperm2i128	$32, %ymm10, %ymm14, %ymm12
	vperm2i128	$49, %ymm10, %ymm14, %ymm13
	vpmullw	%ymm7, %ymm2, %ymm15
	vpmulhw	%ymm7, %ymm3, %ymm14
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmulhw	%ymm1, %ymm3, %ymm7
	vpmullw	%ymm12, %ymm2, %ymm4
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm10
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm7, %ymm10
	vpsubw	%ymm14, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm7, %ymm2, %ymm7
	vpsubw	%ymm2, %ymm9, %ymm1
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm6, %ymm3
	vpaddw	%ymm5, %ymm4, %ymm13
	vpsubw	%ymm4, %ymm11, %ymm12
	vmovdqu	glob_data + 1712(%rip), %ymm4
	vmovdqu	glob_data + 1744(%rip), %ymm11
	vpunpcklqdq	%ymm7, %ymm1, %ymm9
	vpunpckhqdq	%ymm7, %ymm1, %ymm14
	vpunpcklqdq	%ymm2, %ymm8, %ymm6
	vpunpckhqdq	%ymm2, %ymm8, %ymm5
	vpunpcklqdq	%ymm10, %ymm3, %ymm7
	vpunpckhqdq	%ymm10, %ymm3, %ymm1
	vpunpcklqdq	%ymm13, %ymm12, %ymm2
	vpunpckhqdq	%ymm13, %ymm12, %ymm13
	vpmullw	%ymm7, %ymm4, %ymm15
	vpmulhw	%ymm7, %ymm11, %ymm3
	vpmullw	%ymm1, %ymm4, %ymm8
	vpmulhw	%ymm1, %ymm11, %ymm10
	vpmullw	%ymm2, %ymm4, %ymm1
	vpmulhw	%ymm2, %ymm11, %ymm7
	vpmullw	%ymm13, %ymm4, %ymm2
	vpmulhw	%ymm13, %ymm11, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm14, %ymm13
	vpaddw	%ymm14, %ymm10, %ymm10
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm12, %ymm5, %ymm3
	vpaddw	%ymm5, %ymm12, %ymm5
	vpsubw	%ymm7, %ymm6, %ymm4
	vpaddw	%ymm6, %ymm7, %ymm6
	vpaddw	%ymm11, %ymm15, %ymm11
	vpsubw	%ymm15, %ymm9, %ymm12
	vpaddw	%ymm13, %ymm8, %ymm7
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm4, %ymm1, %ymm4
	vpsubw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm2, %ymm5, %ymm5
	vmovdqu	glob_data + 1776(%rip), %ymm2
	vmovdqu	glob_data + 1808(%rip), %ymm3
	vmovsldup	%ymm11, %ymm6
	vpblendd	$170, %ymm6, %ymm12, %ymm9
	vpsrlq	$32, %ymm12, %ymm6
	vpblendd	$170, %ymm11, %ymm6, %ymm10
	vmovsldup	%ymm7, %ymm6
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm11
	vmovsldup	%ymm4, %ymm15
	vpblendd	$170, %ymm15, %ymm1, %ymm7
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm4, %ymm1, %ymm14
	vmovsldup	%ymm13, %ymm4
	vpblendd	$170, %ymm4, %ymm5, %ymm12
	vpsrlq	$32, %ymm5, %ymm1
	vpblendd	$170, %ymm13, %ymm1, %ymm13
	vpmullw	%ymm7, %ymm2, %ymm15
	vpmulhw	%ymm7, %ymm3, %ymm5
	vpmullw	%ymm14, %ymm2, %ymm8
	vpmulhw	%ymm14, %ymm3, %ymm14
	vpmullw	%ymm12, %ymm2, %ymm4
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm7
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm7, %ymm4
	vpsubw	%ymm14, %ymm10, %ymm13
	vpaddw	%ymm10, %ymm14, %ymm10
	vpsubw	%ymm5, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm7, %ymm2, %ymm7
	vpsubw	%ymm2, %ymm9, %ymm1
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm6, %ymm12
	vpaddw	%ymm5, %ymm4, %ymm13
	vpsubw	%ymm4, %ymm11, %ymm14
	vmovdqu	glob_data + 1840(%rip), %ymm4
	vmovdqu	glob_data + 1872(%rip), %ymm3
	vpslld	$16, %ymm7, %ymm6
	vpblendw	$170, %ymm6, %ymm1, %ymm9
	vpsrld	$16, %ymm1, %ymm5
	vpblendw	$170, %ymm7, %ymm5, %ymm5
	vpslld	$16, %ymm2, %ymm6
	vpblendw	$170, %ymm6, %ymm8, %ymm6
	vpsrld	$16, %ymm8, %ymm7
	vpblendw	$170, %ymm2, %ymm7, %ymm11
	vpslld	$16, %ymm10, %ymm2
	vpblendw	$170, %ymm2, %ymm12, %ymm7
	vpsrld	$16, %ymm12, %ymm8
	vpblendw	$170, %ymm10, %ymm8, %ymm1
	vpslld	$16, %ymm13, %ymm2
	vpblendw	$170, %ymm2, %ymm14, %ymm12
	vpsrld	$16, %ymm14, %ymm8
	vpblendw	$170, %ymm13, %ymm8, %ymm13
	vpmullw	%ymm7, %ymm4, %ymm2
	vpmulhw	%ymm7, %ymm3, %ymm14
	vpmullw	%ymm1, %ymm4, %ymm8
	vpmulhw	%ymm1, %ymm3, %ymm7
	vpmullw	%ymm12, %ymm4, %ymm10
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm4, %ymm4
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm7, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm7, %ymm10
	vpsubw	%ymm14, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm7, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm10
	vpaddw	%ymm12, %ymm3, %ymm12
	vpsubw	%ymm3, %ymm6, %ymm7
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm11, %ymm14
	vmovdqu	glob_data + 1904(%rip), %ymm4
	vmovdqu	glob_data + 1936(%rip), %ymm6
	vmovdqu	glob_data + 1968(%rip), %ymm11
	vmovdqu	glob_data + 2000(%rip), %ymm13
	vpmullw	%ymm7, %ymm4, %ymm15
	vpmulhw	%ymm7, %ymm6, %ymm5
	vpmullw	%ymm14, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm6, %ymm7
	vpmullw	%ymm12, %ymm11, %ymm4
	vpmulhw	%ymm12, %ymm13, %ymm6
	vpmullw	%ymm3, %ymm11, %ymm11
	vpmulhw	%ymm3, %ymm13, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm11, %ymm4
	vpsubw	%ymm7, %ymm10, %ymm13
	vpaddw	%ymm10, %ymm7, %ymm10
	vpsubw	%ymm5, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm12, %ymm2, %ymm5
	vpaddw	%ymm2, %ymm12, %ymm2
	vpsubw	%ymm6, %ymm1, %ymm12
	vpaddw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm7, %ymm15, %ymm6
	vpsubw	%ymm15, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm7
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm2, %ymm5
	vmovdqu	glob_data + 736(%rip), %ymm2
	vpmulhw	%ymm2, %ymm9, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm9, %ymm4
	vpmulhw	%ymm2, %ymm8, %ymm9
	vpsraw	$10, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpmulhw	%ymm2, %ymm1, %ymm9
	vpsraw	$10, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm5, %ymm9
	vpsraw	$10, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm5, %ymm5
	vpmulhw	%ymm2, %ymm6, %ymm9
	vpsraw	$10, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm6, %ymm11
	vpmulhw	%ymm2, %ymm7, %ymm9
	vpsraw	$10, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm7, %ymm9
	vpmulhw	%ymm2, %ymm10, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm10, %ymm6
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm4, (%rsi)
	vmovdqu	%ymm8, 32(%rsi)
	vmovdqu	%ymm11, 64(%rsi)
	vmovdqu	%ymm9, 96(%rsi)
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	%ymm5, 160(%rsi)
	vmovdqu	%ymm6, 192(%rsi)
	vmovdqu	%ymm2, 224(%rsi)
	vpbroadcastd	glob_data + 2032(%rip), %ymm2
	vpbroadcastd	glob_data + 2036(%rip), %ymm4
	vmovdqu	384(%rsi), %ymm7
	vmovdqu	416(%rsi), %ymm1
	vmovdqu	448(%rsi), %ymm12
	vmovdqu	480(%rsi), %ymm13
	vmovdqu	256(%rsi), %ymm9
	vmovdqu	288(%rsi), %ymm10
	vmovdqu	320(%rsi), %ymm6
	vmovdqu	352(%rsi), %ymm5
	vpmullw	%ymm7, %ymm2, %ymm15
	vpmulhw	%ymm7, %ymm4, %ymm3
	vpmullw	%ymm1, %ymm2, %ymm14
	vpmulhw	%ymm1, %ymm4, %ymm7
	vpmullw	%ymm12, %ymm2, %ymm1
	vpmulhw	%ymm12, %ymm4, %ymm8
	vpmullw	%ymm13, %ymm2, %ymm2
	vpmulhw	%ymm13, %ymm4, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm14, %ymm14
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm7, %ymm10, %ymm13
	vpaddw	%ymm10, %ymm7, %ymm10
	vpsubw	%ymm3, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm12, %ymm5, %ymm3
	vpaddw	%ymm5, %ymm12, %ymm5
	vpsubw	%ymm8, %ymm6, %ymm4
	vpaddw	%ymm6, %ymm8, %ymm6
	vpaddw	%ymm7, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm12
	vpaddw	%ymm13, %ymm14, %ymm8
	vpsubw	%ymm14, %ymm10, %ymm10
	vpaddw	%ymm4, %ymm1, %ymm4
	vpsubw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm2, %ymm5, %ymm14
	vmovdqu	glob_data + 2040(%rip), %ymm2
	vmovdqu	glob_data + 2072(%rip), %ymm3
	vperm2i128	$32, %ymm7, %ymm12, %ymm9
	vperm2i128	$49, %ymm7, %ymm12, %ymm5
	vperm2i128	$32, %ymm8, %ymm10, %ymm6
	vperm2i128	$49, %ymm8, %ymm10, %ymm11
	vperm2i128	$32, %ymm4, %ymm1, %ymm7
	vperm2i128	$49, %ymm4, %ymm1, %ymm1
	vperm2i128	$32, %ymm13, %ymm14, %ymm12
	vperm2i128	$49, %ymm13, %ymm14, %ymm13
	vpmullw	%ymm7, %ymm2, %ymm15
	vpmulhw	%ymm7, %ymm3, %ymm14
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmulhw	%ymm1, %ymm3, %ymm7
	vpmullw	%ymm12, %ymm2, %ymm4
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm10
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm7, %ymm10
	vpsubw	%ymm14, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm1
	vpaddw	%ymm7, %ymm2, %ymm6
	vpsubw	%ymm2, %ymm9, %ymm7
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm11, %ymm12
	vmovdqu	glob_data + 2104(%rip), %ymm4
	vmovdqu	glob_data + 2136(%rip), %ymm11
	vpunpcklqdq	%ymm6, %ymm7, %ymm9
	vpunpckhqdq	%ymm6, %ymm7, %ymm14
	vpunpcklqdq	%ymm2, %ymm8, %ymm6
	vpunpckhqdq	%ymm2, %ymm8, %ymm5
	vpunpcklqdq	%ymm10, %ymm1, %ymm7
	vpunpckhqdq	%ymm10, %ymm1, %ymm1
	vpunpcklqdq	%ymm3, %ymm12, %ymm2
	vpunpckhqdq	%ymm3, %ymm12, %ymm13
	vpmullw	%ymm7, %ymm4, %ymm15
	vpmulhw	%ymm7, %ymm11, %ymm3
	vpmullw	%ymm1, %ymm4, %ymm8
	vpmulhw	%ymm1, %ymm11, %ymm10
	vpmullw	%ymm2, %ymm4, %ymm1
	vpmulhw	%ymm2, %ymm11, %ymm7
	vpmullw	%ymm13, %ymm4, %ymm2
	vpmulhw	%ymm13, %ymm11, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm14, %ymm13
	vpaddw	%ymm14, %ymm10, %ymm10
	vpsubw	%ymm3, %ymm9, %ymm11
	vpaddw	%ymm9, %ymm3, %ymm9
	vpsubw	%ymm12, %ymm5, %ymm3
	vpaddw	%ymm5, %ymm12, %ymm5
	vpsubw	%ymm7, %ymm6, %ymm4
	vpaddw	%ymm6, %ymm7, %ymm6
	vpaddw	%ymm11, %ymm15, %ymm7
	vpsubw	%ymm15, %ymm9, %ymm12
	vpaddw	%ymm13, %ymm8, %ymm11
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm4, %ymm1, %ymm4
	vpsubw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm3, %ymm2, %ymm10
	vpsubw	%ymm2, %ymm5, %ymm14
	vmovdqu	glob_data + 2168(%rip), %ymm2
	vmovdqu	glob_data + 2200(%rip), %ymm3
	vmovsldup	%ymm7, %ymm6
	vpblendd	$170, %ymm6, %ymm12, %ymm9
	vpsrlq	$32, %ymm12, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vmovsldup	%ymm11, %ymm6
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vpsrlq	$32, %ymm8, %ymm7
	vpblendd	$170, %ymm11, %ymm7, %ymm11
	vmovsldup	%ymm4, %ymm15
	vpblendd	$170, %ymm15, %ymm1, %ymm7
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm4, %ymm1, %ymm1
	vmovsldup	%ymm10, %ymm4
	vpblendd	$170, %ymm4, %ymm14, %ymm12
	vpsrlq	$32, %ymm14, %ymm4
	vpblendd	$170, %ymm10, %ymm4, %ymm13
	vpmullw	%ymm7, %ymm2, %ymm15
	vpmulhw	%ymm7, %ymm3, %ymm14
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmulhw	%ymm1, %ymm3, %ymm7
	vpmullw	%ymm12, %ymm2, %ymm4
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm2, %ymm10
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm10, %ymm4
	vpsubw	%ymm7, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm7, %ymm10
	vpsubw	%ymm14, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm7, %ymm2, %ymm7
	vpsubw	%ymm2, %ymm9, %ymm1
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm6, %ymm12
	vpaddw	%ymm5, %ymm4, %ymm13
	vpsubw	%ymm4, %ymm11, %ymm14
	vmovdqu	glob_data + 2232(%rip), %ymm4
	vmovdqu	glob_data + 2264(%rip), %ymm3
	vpslld	$16, %ymm7, %ymm6
	vpblendw	$170, %ymm6, %ymm1, %ymm9
	vpsrld	$16, %ymm1, %ymm5
	vpblendw	$170, %ymm7, %ymm5, %ymm5
	vpslld	$16, %ymm2, %ymm6
	vpblendw	$170, %ymm6, %ymm8, %ymm6
	vpsrld	$16, %ymm8, %ymm7
	vpblendw	$170, %ymm2, %ymm7, %ymm11
	vpslld	$16, %ymm10, %ymm2
	vpblendw	$170, %ymm2, %ymm12, %ymm7
	vpsrld	$16, %ymm12, %ymm8
	vpblendw	$170, %ymm10, %ymm8, %ymm1
	vpslld	$16, %ymm13, %ymm2
	vpblendw	$170, %ymm2, %ymm14, %ymm12
	vpsrld	$16, %ymm14, %ymm8
	vpblendw	$170, %ymm13, %ymm8, %ymm13
	vpmullw	%ymm7, %ymm4, %ymm2
	vpmulhw	%ymm7, %ymm3, %ymm14
	vpmullw	%ymm1, %ymm4, %ymm8
	vpmulhw	%ymm1, %ymm3, %ymm7
	vpmullw	%ymm12, %ymm4, %ymm10
	vpmulhw	%ymm12, %ymm3, %ymm1
	vpmullw	%ymm13, %ymm4, %ymm4
	vpmulhw	%ymm13, %ymm3, %ymm12
	vpmulhw	%ymm0, %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm10, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm7, %ymm5, %ymm13
	vpaddw	%ymm5, %ymm7, %ymm10
	vpsubw	%ymm14, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm12, %ymm11, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm11
	vpsubw	%ymm1, %ymm6, %ymm12
	vpaddw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm7, %ymm2, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm13, %ymm8, %ymm2
	vpsubw	%ymm8, %ymm10, %ymm10
	vpaddw	%ymm12, %ymm3, %ymm12
	vpsubw	%ymm3, %ymm6, %ymm7
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm11, %ymm14
	vmovdqu	glob_data + 2296(%rip), %ymm4
	vmovdqu	glob_data + 2328(%rip), %ymm6
	vmovdqu	glob_data + 2360(%rip), %ymm11
	vmovdqu	glob_data + 2392(%rip), %ymm13
	vpmullw	%ymm7, %ymm4, %ymm15
	vpmulhw	%ymm7, %ymm6, %ymm5
	vpmullw	%ymm14, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm6, %ymm7
	vpmullw	%ymm12, %ymm11, %ymm4
	vpmulhw	%ymm12, %ymm13, %ymm6
	vpmullw	%ymm3, %ymm11, %ymm11
	vpmulhw	%ymm3, %ymm13, %ymm12
	vpmulhw	%ymm0, %ymm15, %ymm15
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm4, %ymm3
	vpmulhw	%ymm0, %ymm11, %ymm4
	vpsubw	%ymm7, %ymm10, %ymm13
	vpaddw	%ymm10, %ymm7, %ymm10
	vpsubw	%ymm5, %ymm9, %ymm7
	vpaddw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm12, %ymm2, %ymm5
	vpaddw	%ymm2, %ymm12, %ymm2
	vpsubw	%ymm6, %ymm1, %ymm12
	vpaddw	%ymm1, %ymm6, %ymm1
	vpaddw	%ymm7, %ymm15, %ymm6
	vpsubw	%ymm15, %ymm9, %ymm7
	vpaddw	%ymm13, %ymm8, %ymm9
	vpsubw	%ymm8, %ymm10, %ymm8
	vpaddw	%ymm12, %ymm3, %ymm10
	vpsubw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm5, %ymm4, %ymm3
	vpsubw	%ymm4, %ymm2, %ymm5
	vmovdqu	glob_data + 736(%rip), %ymm2
	vpmulhw	%ymm2, %ymm7, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm7, %ymm4
	vpmulhw	%ymm2, %ymm8, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmulhw	%ymm2, %ymm1, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm5, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm5, %ymm5
	vpmulhw	%ymm2, %ymm6, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm6, %ymm8
	vpmulhw	%ymm2, %ymm9, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm9, %ymm9
	vpmulhw	%ymm2, %ymm10, %ymm6
	vpsraw	$10, %ymm6, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm10, %ymm6
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm4, 256(%rsi)
	vmovdqu	%ymm7, 288(%rsi)
	vmovdqu	%ymm8, 320(%rsi)
	vmovdqu	%ymm9, 352(%rsi)
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	%ymm5, 416(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm2, 480(%rsi)
	ret
.L_poly_invntt$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 832(%rip), %ymm9
	vmovdqu	glob_data + 896(%rip), %ymm2
	vmovdqu	glob_data + 864(%rip), %ymm1
	vmovdqu	glob_data + 928(%rip), %ymm4
	vmovdqu	(%rsi), %ymm10
	vmovdqu	32(%rsi), %ymm5
	vmovdqu	64(%rsi), %ymm3
	vmovdqu	96(%rsi), %ymm13
	vmovdqu	128(%rsi), %ymm6
	vmovdqu	160(%rsi), %ymm11
	vmovdqu	192(%rsi), %ymm12
	vmovdqu	224(%rsi), %ymm8
	vpsubw	%ymm3, %ymm10, %ymm15
	vpsubw	%ymm13, %ymm5, %ymm7
	vpsubw	%ymm12, %ymm6, %ymm14
	vpaddw	%ymm10, %ymm3, %ymm3
	vpaddw	%ymm5, %ymm13, %ymm5
	vpmullw	%ymm15, %ymm9, %ymm10
	vpaddw	%ymm6, %ymm12, %ymm6
	vpmullw	%ymm7, %ymm9, %ymm13
	vpsubw	%ymm8, %ymm11, %ymm12
	vpaddw	%ymm11, %ymm8, %ymm8
	vpmullw	%ymm14, %ymm2, %ymm9
	vpmullw	%ymm12, %ymm2, %ymm2
	vpmulhw	%ymm15, %ymm1, %ymm15
	vpmulhw	%ymm7, %ymm1, %ymm7
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmulhw	%ymm12, %ymm4, %ymm1
	vpmulhw	%ymm10, %ymm0, %ymm4
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm2, %ymm0, %ymm2
	vpsubw	%ymm4, %ymm15, %ymm12
	vpsubw	%ymm13, %ymm7, %ymm11
	vpsubw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm2, %ymm1, %ymm7
	vmovdqu	glob_data + 736(%rip), %ymm1
	vmovdqu	glob_data + 960(%rip), %ymm2
	vmovdqu	glob_data + 992(%rip), %ymm4
	vpmulhw	%ymm1, %ymm3, %ymm10
	vpsraw	$10, %ymm10, %ymm10
	vpmullw	%ymm0, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm3, %ymm10
	vpmulhw	%ymm1, %ymm5, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm5, %ymm14
	vpmulhw	%ymm1, %ymm6, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm6, %ymm5
	vpmulhw	%ymm1, %ymm8, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm8, %ymm13
	vpsubw	%ymm5, %ymm10, %ymm15
	vpsubw	%ymm13, %ymm14, %ymm3
	vpsubw	%ymm9, %ymm12, %ymm8
	vpaddw	%ymm10, %ymm5, %ymm5
	vpaddw	%ymm14, %ymm13, %ymm6
	vpmullw	%ymm15, %ymm2, %ymm10
	vpaddw	%ymm12, %ymm9, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm7, %ymm11, %ymm14
	vpaddw	%ymm11, %ymm7, %ymm11
	vpmullw	%ymm8, %ymm2, %ymm9
	vpmullw	%ymm14, %ymm2, %ymm7
	vpmulhw	%ymm15, %ymm4, %ymm2
	vpmulhw	%ymm3, %ymm4, %ymm3
	vpmulhw	%ymm8, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmulhw	%ymm10, %ymm0, %ymm4
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm7, %ymm0, %ymm7
	vpsubw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm9, %ymm8, %ymm4
	vpsubw	%ymm7, %ymm14, %ymm8
	vpslld	$16, %ymm6, %ymm15
	vpblendw	$170, %ymm15, %ymm5, %ymm9
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm6, %ymm5, %ymm7
	vpslld	$16, %ymm11, %ymm6
	vpblendw	$170, %ymm6, %ymm12, %ymm10
	vpsrld	$16, %ymm12, %ymm5
	vpblendw	$170, %ymm11, %ymm5, %ymm14
	vpslld	$16, %ymm3, %ymm6
	vpblendw	$170, %ymm6, %ymm2, %ymm6
	vpsrld	$16, %ymm2, %ymm5
	vpblendw	$170, %ymm3, %ymm5, %ymm13
	vpslld	$16, %ymm8, %ymm2
	vpblendw	$170, %ymm2, %ymm4, %ymm5
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm4
	vmovdqu	glob_data + 1024(%rip), %ymm2
	vmovdqu	glob_data + 1056(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm15
	vpsubw	%ymm14, %ymm10, %ymm3
	vpsubw	%ymm13, %ymm6, %ymm8
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm14, %ymm10
	vpmullw	%ymm15, %ymm2, %ymm12
	vpaddw	%ymm6, %ymm13, %ymm6
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm4, %ymm5, %ymm14
	vpaddw	%ymm5, %ymm4, %ymm7
	vpmullw	%ymm8, %ymm2, %ymm4
	vpmullw	%ymm14, %ymm2, %ymm5
	vpmulhw	%ymm15, %ymm11, %ymm2
	vpmulhw	%ymm3, %ymm11, %ymm3
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm12, %ymm0, %ymm11
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
	vmovsldup	%ymm10, %ymm15
	vpblendd	$170, %ymm15, %ymm8, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm10, %ymm8, %ymm11
	vmovsldup	%ymm7, %ymm15
	vpblendd	$170, %ymm15, %ymm6, %ymm10
	vpsrlq	$32, %ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm14
	vmovsldup	%ymm3, %ymm6
	vpblendd	$170, %ymm6, %ymm2, %ymm12
	vpsrlq	$32, %ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm13
	vmovsldup	%ymm5, %ymm2
	vpblendd	$170, %ymm2, %ymm4, %ymm2
	vpsrlq	$32, %ymm4, %ymm3
	vpblendd	$170, %ymm5, %ymm3, %ymm3
	vmovdqu	glob_data + 1088(%rip), %ymm4
	vmovdqu	glob_data + 1120(%rip), %ymm5
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
	vpsubw	%ymm7, %ymm9, %ymm7
	vpunpcklqdq	%ymm10, %ymm7, %ymm9
	vpunpckhqdq	%ymm10, %ymm7, %ymm7
	vpunpcklqdq	%ymm2, %ymm12, %ymm10
	vpunpckhqdq	%ymm2, %ymm12, %ymm13
	vpunpcklqdq	%ymm6, %ymm5, %ymm12
	vpunpckhqdq	%ymm6, %ymm5, %ymm2
	vpunpcklqdq	%ymm4, %ymm3, %ymm5
	vpunpckhqdq	%ymm4, %ymm3, %ymm3
	vmovdqu	glob_data + 1152(%rip), %ymm4
	vmovdqu	glob_data + 1184(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm6
	vpsubw	%ymm13, %ymm10, %ymm8
	vpsubw	%ymm2, %ymm12, %ymm14
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm10
	vpmullw	%ymm6, %ymm4, %ymm7
	vpaddw	%ymm12, %ymm2, %ymm2
	vpmullw	%ymm8, %ymm4, %ymm13
	vpsubw	%ymm3, %ymm5, %ymm12
	vpaddw	%ymm5, %ymm3, %ymm3
	vpmullw	%ymm14, %ymm4, %ymm5
	vpmullw	%ymm12, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm11, %ymm6
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm12, %ymm11, %ymm12
	vpmulhw	%ymm7, %ymm0, %ymm7
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsubw	%ymm13, %ymm8, %ymm8
	vpsubw	%ymm5, %ymm14, %ymm5
	vpsubw	%ymm4, %ymm12, %ymm4
	vpmulhw	%ymm1, %ymm9, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vperm2i128	$32, %ymm10, %ymm7, %ymm9
	vperm2i128	$49, %ymm10, %ymm7, %ymm7
	vperm2i128	$32, %ymm3, %ymm2, %ymm10
	vperm2i128	$49, %ymm3, %ymm2, %ymm13
	vperm2i128	$32, %ymm8, %ymm6, %ymm12
	vperm2i128	$49, %ymm8, %ymm6, %ymm2
	vperm2i128	$32, %ymm4, %ymm5, %ymm3
	vperm2i128	$49, %ymm4, %ymm5, %ymm4
	vpbroadcastd	glob_data + 1216(%rip), %ymm5
	vpbroadcastd	glob_data + 1220(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm6
	vpsubw	%ymm13, %ymm10, %ymm8
	vpsubw	%ymm2, %ymm12, %ymm14
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm7
	vpmullw	%ymm6, %ymm5, %ymm10
	vpaddw	%ymm12, %ymm2, %ymm2
	vpmullw	%ymm8, %ymm5, %ymm13
	vpsubw	%ymm4, %ymm3, %ymm12
	vpaddw	%ymm3, %ymm4, %ymm3
	vpmullw	%ymm14, %ymm5, %ymm4
	vpmullw	%ymm12, %ymm5, %ymm5
	vpmulhw	%ymm6, %ymm11, %ymm6
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm12, %ymm11, %ymm12
	vpmulhw	%ymm10, %ymm0, %ymm10
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm10, %ymm6, %ymm11
	vpsubw	%ymm13, %ymm8, %ymm6
	vpsubw	%ymm4, %ymm14, %ymm4
	vpsubw	%ymm5, %ymm12, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm10
	vmovdqu	%ymm10, (%rsi)
	vmovdqu	%ymm7, 32(%rsi)
	vmovdqu	%ymm2, 64(%rsi)
	vmovdqu	%ymm3, 96(%rsi)
	vmovdqu	%ymm11, 128(%rsi)
	vmovdqu	%ymm6, 160(%rsi)
	vmovdqu	%ymm4, 192(%rsi)
	vmovdqu	%ymm5, 224(%rsi)
	vmovdqu	glob_data + 1224(%rip), %ymm9
	vmovdqu	glob_data + 1288(%rip), %ymm2
	vmovdqu	glob_data + 1256(%rip), %ymm1
	vmovdqu	glob_data + 1320(%rip), %ymm4
	vmovdqu	256(%rsi), %ymm10
	vmovdqu	288(%rsi), %ymm5
	vmovdqu	320(%rsi), %ymm3
	vmovdqu	352(%rsi), %ymm13
	vmovdqu	384(%rsi), %ymm6
	vmovdqu	416(%rsi), %ymm11
	vmovdqu	448(%rsi), %ymm12
	vmovdqu	480(%rsi), %ymm8
	vpsubw	%ymm3, %ymm10, %ymm15
	vpsubw	%ymm13, %ymm5, %ymm7
	vpsubw	%ymm12, %ymm6, %ymm14
	vpaddw	%ymm10, %ymm3, %ymm3
	vpaddw	%ymm5, %ymm13, %ymm5
	vpmullw	%ymm15, %ymm9, %ymm10
	vpaddw	%ymm6, %ymm12, %ymm6
	vpmullw	%ymm7, %ymm9, %ymm13
	vpsubw	%ymm8, %ymm11, %ymm12
	vpaddw	%ymm11, %ymm8, %ymm8
	vpmullw	%ymm14, %ymm2, %ymm9
	vpmullw	%ymm12, %ymm2, %ymm2
	vpmulhw	%ymm15, %ymm1, %ymm15
	vpmulhw	%ymm7, %ymm1, %ymm7
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmulhw	%ymm12, %ymm4, %ymm1
	vpmulhw	%ymm10, %ymm0, %ymm4
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm2, %ymm0, %ymm2
	vpsubw	%ymm4, %ymm15, %ymm12
	vpsubw	%ymm13, %ymm7, %ymm11
	vpsubw	%ymm9, %ymm14, %ymm9
	vpsubw	%ymm2, %ymm1, %ymm7
	vmovdqu	glob_data + 736(%rip), %ymm1
	vmovdqu	glob_data + 1352(%rip), %ymm2
	vmovdqu	glob_data + 1384(%rip), %ymm4
	vpmulhw	%ymm1, %ymm3, %ymm10
	vpsraw	$10, %ymm10, %ymm10
	vpmullw	%ymm0, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm3, %ymm10
	vpmulhw	%ymm1, %ymm5, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm5, %ymm14
	vpmulhw	%ymm1, %ymm6, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm6, %ymm5
	vpmulhw	%ymm1, %ymm8, %ymm3
	vpsraw	$10, %ymm3, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm8, %ymm13
	vpsubw	%ymm5, %ymm10, %ymm15
	vpsubw	%ymm13, %ymm14, %ymm3
	vpsubw	%ymm9, %ymm12, %ymm8
	vpaddw	%ymm10, %ymm5, %ymm5
	vpaddw	%ymm14, %ymm13, %ymm6
	vpmullw	%ymm15, %ymm2, %ymm10
	vpaddw	%ymm12, %ymm9, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm7, %ymm11, %ymm14
	vpaddw	%ymm11, %ymm7, %ymm11
	vpmullw	%ymm8, %ymm2, %ymm9
	vpmullw	%ymm14, %ymm2, %ymm7
	vpmulhw	%ymm15, %ymm4, %ymm2
	vpmulhw	%ymm3, %ymm4, %ymm3
	vpmulhw	%ymm8, %ymm4, %ymm8
	vpmulhw	%ymm14, %ymm4, %ymm14
	vpmulhw	%ymm10, %ymm0, %ymm4
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm7, %ymm0, %ymm7
	vpsubw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm9, %ymm8, %ymm4
	vpsubw	%ymm7, %ymm14, %ymm8
	vpslld	$16, %ymm6, %ymm15
	vpblendw	$170, %ymm15, %ymm5, %ymm9
	vpsrld	$16, %ymm5, %ymm5
	vpblendw	$170, %ymm6, %ymm5, %ymm7
	vpslld	$16, %ymm11, %ymm6
	vpblendw	$170, %ymm6, %ymm12, %ymm10
	vpsrld	$16, %ymm12, %ymm5
	vpblendw	$170, %ymm11, %ymm5, %ymm14
	vpslld	$16, %ymm3, %ymm6
	vpblendw	$170, %ymm6, %ymm2, %ymm6
	vpsrld	$16, %ymm2, %ymm5
	vpblendw	$170, %ymm3, %ymm5, %ymm13
	vpslld	$16, %ymm8, %ymm2
	vpblendw	$170, %ymm2, %ymm4, %ymm5
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm4
	vmovdqu	glob_data + 1416(%rip), %ymm2
	vmovdqu	glob_data + 1448(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm15
	vpsubw	%ymm14, %ymm10, %ymm3
	vpsubw	%ymm13, %ymm6, %ymm8
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm14, %ymm10
	vpmullw	%ymm15, %ymm2, %ymm7
	vpaddw	%ymm6, %ymm13, %ymm12
	vpmullw	%ymm3, %ymm2, %ymm13
	vpsubw	%ymm4, %ymm5, %ymm14
	vpaddw	%ymm5, %ymm4, %ymm6
	vpmullw	%ymm8, %ymm2, %ymm4
	vpmullw	%ymm14, %ymm2, %ymm5
	vpmulhw	%ymm15, %ymm11, %ymm2
	vpmulhw	%ymm3, %ymm11, %ymm3
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm7, %ymm0, %ymm11
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm13, %ymm3, %ymm3
	vpsubw	%ymm4, %ymm8, %ymm4
	vpsubw	%ymm5, %ymm14, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vmovsldup	%ymm10, %ymm15
	vpblendd	$170, %ymm15, %ymm7, %ymm9
	vpsrlq	$32, %ymm7, %ymm7
	vpblendd	$170, %ymm10, %ymm7, %ymm11
	vmovsldup	%ymm6, %ymm15
	vpblendd	$170, %ymm15, %ymm12, %ymm10
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
	vmovdqu	glob_data + 1480(%rip), %ymm4
	vmovdqu	glob_data + 1512(%rip), %ymm5
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
	vpsubw	%ymm7, %ymm9, %ymm7
	vpunpcklqdq	%ymm10, %ymm7, %ymm9
	vpunpckhqdq	%ymm10, %ymm7, %ymm7
	vpunpcklqdq	%ymm2, %ymm12, %ymm10
	vpunpckhqdq	%ymm2, %ymm12, %ymm13
	vpunpcklqdq	%ymm6, %ymm5, %ymm12
	vpunpckhqdq	%ymm6, %ymm5, %ymm2
	vpunpcklqdq	%ymm4, %ymm3, %ymm5
	vpunpckhqdq	%ymm4, %ymm3, %ymm3
	vmovdqu	glob_data + 1544(%rip), %ymm4
	vmovdqu	glob_data + 1576(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm6
	vpsubw	%ymm13, %ymm10, %ymm8
	vpsubw	%ymm2, %ymm12, %ymm14
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm10
	vpmullw	%ymm6, %ymm4, %ymm7
	vpaddw	%ymm12, %ymm2, %ymm2
	vpmullw	%ymm8, %ymm4, %ymm13
	vpsubw	%ymm3, %ymm5, %ymm12
	vpaddw	%ymm5, %ymm3, %ymm3
	vpmullw	%ymm14, %ymm4, %ymm5
	vpmullw	%ymm12, %ymm4, %ymm4
	vpmulhw	%ymm6, %ymm11, %ymm6
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm12, %ymm11, %ymm12
	vpmulhw	%ymm7, %ymm0, %ymm7
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsubw	%ymm13, %ymm8, %ymm8
	vpsubw	%ymm5, %ymm14, %ymm5
	vpsubw	%ymm4, %ymm12, %ymm4
	vpmulhw	%ymm1, %ymm9, %ymm7
	vpsraw	$10, %ymm7, %ymm7
	vpmullw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vperm2i128	$32, %ymm10, %ymm7, %ymm9
	vperm2i128	$49, %ymm10, %ymm7, %ymm7
	vperm2i128	$32, %ymm3, %ymm2, %ymm10
	vperm2i128	$49, %ymm3, %ymm2, %ymm13
	vperm2i128	$32, %ymm8, %ymm6, %ymm12
	vperm2i128	$49, %ymm8, %ymm6, %ymm2
	vperm2i128	$32, %ymm4, %ymm5, %ymm3
	vperm2i128	$49, %ymm4, %ymm5, %ymm4
	vpbroadcastd	glob_data + 1608(%rip), %ymm5
	vpbroadcastd	glob_data + 1612(%rip), %ymm11
	vpsubw	%ymm7, %ymm9, %ymm6
	vpsubw	%ymm13, %ymm10, %ymm8
	vpsubw	%ymm2, %ymm12, %ymm14
	vpaddw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm10, %ymm13, %ymm7
	vpmullw	%ymm6, %ymm5, %ymm10
	vpaddw	%ymm12, %ymm2, %ymm2
	vpmullw	%ymm8, %ymm5, %ymm13
	vpsubw	%ymm4, %ymm3, %ymm12
	vpaddw	%ymm3, %ymm4, %ymm3
	vpmullw	%ymm14, %ymm5, %ymm4
	vpmullw	%ymm12, %ymm5, %ymm5
	vpmulhw	%ymm6, %ymm11, %ymm6
	vpmulhw	%ymm8, %ymm11, %ymm8
	vpmulhw	%ymm14, %ymm11, %ymm14
	vpmulhw	%ymm12, %ymm11, %ymm12
	vpmulhw	%ymm10, %ymm0, %ymm10
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm4, %ymm0, %ymm4
	vpmulhw	%ymm5, %ymm0, %ymm5
	vpsubw	%ymm10, %ymm6, %ymm11
	vpsubw	%ymm13, %ymm8, %ymm6
	vpsubw	%ymm4, %ymm14, %ymm4
	vpsubw	%ymm5, %ymm12, %ymm5
	vpmulhw	%ymm1, %ymm9, %ymm8
	vpsraw	$10, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm9, %ymm10
	vmovdqu	%ymm11, 384(%rsi)
	vmovdqu	%ymm6, 416(%rsi)
	vmovdqu	%ymm4, 448(%rsi)
	vmovdqu	%ymm5, 480(%rsi)
	vpbroadcastd	glob_data + 1616(%rip), %ymm4
	vpbroadcastd	glob_data + 1620(%rip), %ymm5
	vmovdqu	%ymm3, %ymm1
	vmovdqu	%ymm2, %ymm9
	vmovdqu	(%rsi), %ymm2
	vmovdqu	32(%rsi), %ymm3
	vmovdqu	64(%rsi), %ymm6
	vmovdqu	96(%rsi), %ymm11
	vpsubw	%ymm10, %ymm2, %ymm15
	vpsubw	%ymm7, %ymm3, %ymm8
	vpsubw	%ymm9, %ymm6, %ymm14
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm3, %ymm7, %ymm3
	vpmullw	%ymm15, %ymm4, %ymm10
	vpaddw	%ymm6, %ymm9, %ymm6
	vpmullw	%ymm8, %ymm4, %ymm13
	vpsubw	%ymm1, %ymm11, %ymm12
	vpaddw	%ymm11, %ymm1, %ymm7
	vpmullw	%ymm14, %ymm4, %ymm9
	vpmullw	%ymm12, %ymm4, %ymm1
	vpmulhw	%ymm15, %ymm5, %ymm15
	vpmulhw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm14, %ymm5, %ymm14
	vpmulhw	%ymm12, %ymm5, %ymm12
	vpmulhw	%ymm10, %ymm0, %ymm10
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm9
	vpmulhw	%ymm1, %ymm0, %ymm1
	vpsubw	%ymm10, %ymm15, %ymm10
	vpsubw	%ymm13, %ymm8, %ymm8
	vpsubw	%ymm9, %ymm14, %ymm11
	vpsubw	%ymm1, %ymm12, %ymm12
	vmovdqu	glob_data + 672(%rip), %ymm1
	vmovdqu	glob_data + 704(%rip), %ymm9
	vmovdqu	%ymm10, 256(%rsi)
	vmovdqu	%ymm8, 288(%rsi)
	vmovdqu	%ymm11, 320(%rsi)
	vmovdqu	%ymm12, 352(%rsi)
	vpmullw	%ymm2, %ymm1, %ymm8
	vpmulhw	%ymm2, %ymm9, %ymm2
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmullw	%ymm3, %ymm1, %ymm8
	vpmulhw	%ymm3, %ymm9, %ymm3
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm3, %ymm8
	vpmullw	%ymm6, %ymm1, %ymm3
	vpmulhw	%ymm6, %ymm9, %ymm6
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm6, %ymm3
	vpmullw	%ymm7, %ymm1, %ymm6
	vpmulhw	%ymm7, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm6
	vmovdqu	%ymm2, (%rsi)
	vmovdqu	%ymm8, 32(%rsi)
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	%ymm6, 96(%rsi)
	vmovdqu	384(%rsi), %ymm3
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	448(%rsi), %ymm9
	vmovdqu	480(%rsi), %ymm1
	vmovdqu	128(%rsi), %ymm2
	vmovdqu	160(%rsi), %ymm10
	vmovdqu	192(%rsi), %ymm6
	vmovdqu	224(%rsi), %ymm11
	vpsubw	%ymm3, %ymm2, %ymm15
	vpsubw	%ymm7, %ymm10, %ymm14
	vpsubw	%ymm9, %ymm6, %ymm8
	vpaddw	%ymm2, %ymm3, %ymm2
	vpaddw	%ymm10, %ymm7, %ymm3
	vpmullw	%ymm15, %ymm4, %ymm7
	vpaddw	%ymm6, %ymm9, %ymm6
	vpmullw	%ymm14, %ymm4, %ymm13
	vpsubw	%ymm1, %ymm11, %ymm10
	vpaddw	%ymm11, %ymm1, %ymm11
	vpmullw	%ymm8, %ymm4, %ymm9
	vpmullw	%ymm10, %ymm4, %ymm1
	vpmulhw	%ymm15, %ymm5, %ymm15
	vpmulhw	%ymm14, %ymm5, %ymm14
	vpmulhw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm10, %ymm5, %ymm10
	vpmulhw	%ymm7, %ymm0, %ymm4
	vpmulhw	%ymm13, %ymm0, %ymm13
	vpmulhw	%ymm9, %ymm0, %ymm5
	vpmulhw	%ymm1, %ymm0, %ymm1
	vpsubw	%ymm4, %ymm15, %ymm7
	vpsubw	%ymm13, %ymm14, %ymm4
	vpsubw	%ymm5, %ymm8, %ymm5
	vpsubw	%ymm1, %ymm10, %ymm12
	vmovdqu	glob_data + 672(%rip), %ymm1
	vmovdqu	glob_data + 704(%rip), %ymm9
	vmovdqu	%ymm7, 384(%rsi)
	vmovdqu	%ymm4, 416(%rsi)
	vmovdqu	%ymm5, 448(%rsi)
	vmovdqu	%ymm12, 480(%rsi)
	vpmullw	%ymm2, %ymm1, %ymm4
	vpmulhw	%ymm2, %ymm9, %ymm2
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm2, %ymm2
	vpmullw	%ymm3, %ymm1, %ymm4
	vpmulhw	%ymm3, %ymm9, %ymm3
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm5
	vpmullw	%ymm6, %ymm1, %ymm3
	vpmulhw	%ymm6, %ymm9, %ymm4
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm3
	vpmullw	%ymm11, %ymm1, %ymm4
	vpmulhw	%ymm11, %ymm9, %ymm6
	vpmulhw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm6, %ymm4
	vmovdqu	%ymm2, 128(%rsi)
	vmovdqu	%ymm5, 160(%rsi)
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	%ymm4, 224(%rsi)
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
	movq	552(%rsp), %rax
	movq	560(%rsp), %r8
	movq	568(%rsp), %r10
	movq	576(%rsp), %r9
	movl	$1431655765, 544(%rsp)
	movl	$858993459, 584(%rsp)
	movl	$50529027, 588(%rsp)
	movl	$252645135, 592(%rsp)
	vpbroadcastd	544(%rsp), %ymm0
	vpbroadcastd	584(%rsp), %ymm1
	vpbroadcastd	588(%rsp), %ymm2
	vpbroadcastd	592(%rsp), %ymm3
	vmovdqu	(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, (%rax)
	vmovdqu	%ymm11, 32(%rax)
	vmovdqu	%ymm10, 64(%rax)
	vmovdqu	%ymm4, 96(%rax)
	vmovdqu	32(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 128(%rax)
	vmovdqu	%ymm11, 160(%rax)
	vmovdqu	%ymm10, 192(%rax)
	vmovdqu	%ymm4, 224(%rax)
	vmovdqu	64(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 256(%rax)
	vmovdqu	%ymm11, 288(%rax)
	vmovdqu	%ymm10, 320(%rax)
	vmovdqu	%ymm4, 352(%rax)
	vmovdqu	96(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm3
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm11
	vpunpckhbw	%ymm4, %ymm3, %ymm4
	vmovdqu	%xmm11, %xmm0
	vpmovsxbw	%xmm0, %ymm3
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vmovdqu	%xmm4, %xmm0
	vpmovsxbw	%xmm0, %ymm11
	vextracti128	$1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vmovdqu	%ymm3, 384(%rax)
	vmovdqu	%ymm11, 416(%rax)
	vmovdqu	%ymm10, 448(%rax)
	vmovdqu	%ymm4, 480(%rax)
	movl	$1431655765, 592(%rsp)
	movl	$858993459, 588(%rsp)
	movl	$50529027, 584(%rsp)
	movl	$252645135, 544(%rsp)
	vpbroadcastd	592(%rsp), %ymm0
	vpbroadcastd	588(%rsp), %ymm1
	vpbroadcastd	584(%rsp), %ymm2
	vpbroadcastd	544(%rsp), %ymm3
	vmovdqu	(%rdx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, (%r8)
	vmovdqu	%ymm11, 32(%r8)
	vmovdqu	%ymm10, 64(%r8)
	vmovdqu	%ymm4, 96(%r8)
	vmovdqu	32(%rdx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 128(%r8)
	vmovdqu	%ymm11, 160(%r8)
	vmovdqu	%ymm10, 192(%r8)
	vmovdqu	%ymm4, 224(%r8)
	vmovdqu	64(%rdx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 256(%r8)
	vmovdqu	%ymm11, 288(%r8)
	vmovdqu	%ymm10, 320(%r8)
	vmovdqu	%ymm4, 352(%r8)
	vmovdqu	96(%rdx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm3
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm11
	vpunpckhbw	%ymm4, %ymm3, %ymm4
	vmovdqu	%xmm11, %xmm0
	vpmovsxbw	%xmm0, %ymm3
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vmovdqu	%xmm4, %xmm0
	vpmovsxbw	%xmm0, %ymm11
	vextracti128	$1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vmovdqu	%ymm3, 384(%r8)
	vmovdqu	%ymm11, 416(%r8)
	vmovdqu	%ymm10, 448(%r8)
	vmovdqu	%ymm4, 480(%r8)
	movl	$1431655765, 544(%rsp)
	movl	$858993459, 584(%rsp)
	movl	$50529027, 588(%rsp)
	movl	$252645135, 592(%rsp)
	vpbroadcastd	544(%rsp), %ymm0
	vpbroadcastd	584(%rsp), %ymm1
	vpbroadcastd	588(%rsp), %ymm2
	vpbroadcastd	592(%rsp), %ymm3
	vmovdqu	(%rsi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, (%r10)
	vmovdqu	%ymm11, 32(%r10)
	vmovdqu	%ymm10, 64(%r10)
	vmovdqu	%ymm4, 96(%r10)
	vmovdqu	32(%rsi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 128(%r10)
	vmovdqu	%ymm11, 160(%r10)
	vmovdqu	%ymm10, 192(%r10)
	vmovdqu	%ymm4, 224(%r10)
	vmovdqu	64(%rsi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 256(%r10)
	vmovdqu	%ymm11, 288(%r10)
	vmovdqu	%ymm10, 320(%r10)
	vmovdqu	%ymm4, 352(%r10)
	vmovdqu	96(%rsi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm3
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm11
	vpunpckhbw	%ymm4, %ymm3, %ymm4
	vmovdqu	%xmm11, %xmm0
	vpmovsxbw	%xmm0, %ymm3
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vmovdqu	%xmm4, %xmm0
	vpmovsxbw	%xmm0, %ymm11
	vextracti128	$1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vmovdqu	%ymm3, 384(%r10)
	vmovdqu	%ymm11, 416(%r10)
	vmovdqu	%ymm10, 448(%r10)
	vmovdqu	%ymm4, 480(%r10)
	movl	$1431655765, 592(%rsp)
	movl	$858993459, 588(%rsp)
	movl	$50529027, 584(%rsp)
	movl	$252645135, 544(%rsp)
	vpbroadcastd	592(%rsp), %ymm0
	vpbroadcastd	588(%rsp), %ymm1
	vpbroadcastd	584(%rsp), %ymm2
	vpbroadcastd	544(%rsp), %ymm3
	vmovdqu	(%rdi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, (%r9)
	vmovdqu	%ymm11, 32(%r9)
	vmovdqu	%ymm10, 64(%r9)
	vmovdqu	%ymm4, 96(%r9)
	vmovdqu	32(%rdi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 128(%r9)
	vmovdqu	%ymm11, 160(%r9)
	vmovdqu	%ymm10, 192(%r9)
	vmovdqu	%ymm4, 224(%r9)
	vmovdqu	64(%rdi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 256(%r9)
	vmovdqu	%ymm11, 288(%r9)
	vmovdqu	%ymm10, 320(%r9)
	vmovdqu	%ymm4, 352(%r9)
	vmovdqu	96(%rdi), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm3
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm11
	vpunpckhbw	%ymm4, %ymm3, %ymm4
	vmovdqu	%xmm11, %xmm0
	vpmovsxbw	%xmm0, %ymm3
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vmovdqu	%xmm4, %xmm0
	vpmovsxbw	%xmm0, %ymm11
	vextracti128	$1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vmovdqu	%ymm3, 384(%r9)
	vmovdqu	%ymm11, 416(%r9)
	vmovdqu	%ymm10, 448(%r9)
	vmovdqu	%ymm4, 480(%r9)
	ret
.L_poly_getnoise_eta2$1:
	movq	%rdx, 160(%rsp)
	movb	%al, 184(%rsp)
	leaq	32(%rsp), %rdi
	leaq	184(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A128__A32_A1$1
.L_poly_getnoise_eta2$2:
	leaq	248(%rsp), %rsp
	movq	160(%rsp), %rdx
	lfence
	movq	$0, %rsi
	leaq	32(%rsp), %rcx
	movl	$1431655765, 168(%rsp)
	movl	$858993459, 172(%rsp)
	movl	$50529027, 176(%rsp)
	movl	$252645135, 180(%rsp)
	vpbroadcastd	168(%rsp), %ymm0
	vpbroadcastd	172(%rsp), %ymm1
	vpbroadcastd	176(%rsp), %ymm2
	vpbroadcastd	180(%rsp), %ymm3
	vmovdqu	(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, (%rdx)
	vmovdqu	%ymm11, 32(%rdx)
	vmovdqu	%ymm10, 64(%rdx)
	vmovdqu	%ymm4, 96(%rdx)
	vmovdqu	32(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 128(%rdx)
	vmovdqu	%ymm11, 160(%rdx)
	vmovdqu	%ymm10, 192(%rdx)
	vmovdqu	%ymm4, 224(%rdx)
	vmovdqu	64(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm9
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm9, %ymm11
	vpunpckhbw	%ymm4, %ymm9, %ymm4
	vmovdqu	%xmm11, %xmm5
	vpmovsxbw	%xmm5, %ymm9
	vextracti128	$1, %ymm11, %xmm5
	vpmovsxbw	%xmm5, %ymm10
	vmovdqu	%xmm4, %xmm5
	vpmovsxbw	%xmm5, %ymm11
	vextracti128	$1, %ymm4, %xmm5
	vpmovsxbw	%xmm5, %ymm4
	vmovdqu	%ymm9, 256(%rdx)
	vmovdqu	%ymm11, 288(%rdx)
	vmovdqu	%ymm10, 320(%rdx)
	vmovdqu	%ymm4, 352(%rdx)
	vmovdqu	96(%rcx), %ymm9
	vpsrlw	$1, %ymm9, %ymm4
	vpand	%ymm9, %ymm0, %ymm9
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm4, %ymm9, %ymm9
	vpsrlw	$2, %ymm9, %ymm4
	vpand	%ymm9, %ymm1, %ymm9
	vpand	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm1, %ymm9, %ymm9
	vpsubb	%ymm4, %ymm9, %ymm9
	vpsrlw	$4, %ymm9, %ymm4
	vpand	%ymm9, %ymm3, %ymm9
	vpand	%ymm4, %ymm3, %ymm4
	vpsubb	%ymm2, %ymm9, %ymm3
	vpsubb	%ymm2, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm11
	vpunpckhbw	%ymm4, %ymm3, %ymm4
	vmovdqu	%xmm11, %xmm0
	vpmovsxbw	%xmm0, %ymm3
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxbw	%xmm0, %ymm10
	vmovdqu	%xmm4, %xmm0
	vpmovsxbw	%xmm0, %ymm11
	vextracti128	$1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm4
	vmovdqu	%ymm3, 384(%rdx)
	vmovdqu	%ymm11, 416(%rdx)
	vmovdqu	%ymm10, 448(%rdx)
	vmovdqu	%ymm4, 480(%rdx)
	ret
.L_i_poly_frommsg$1:
	vmovdqu	glob_data + 608(%rip), %ymm0
	vbroadcasti128	glob_data + 2448(%rip), %ymm4
	vbroadcasti128	glob_data + 2432(%rip), %ymm1
	vmovdqu	(%rdx), %ymm2
	vpshufd	$0, %ymm2, %ymm3
	vpsllvd	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vpsllw	$12, %ymm3, %ymm6
	vpsllw	$8, %ymm3, %ymm7
	vpsllw	$4, %ymm3, %ymm5
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm3, %ymm3
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm3, %ymm5, %ymm7
	vpunpckhqdq	%ymm3, %ymm5, %ymm3
	vperm2i128	$32, %ymm7, %ymm8, %ymm5
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm3, %ymm6, %ymm8
	vperm2i128	$49, %ymm3, %ymm6, %ymm3
	vmovdqu	%ymm5, (%rsi)
	vmovdqu	%ymm8, 32(%rsi)
	vmovdqu	%ymm7, 256(%rsi)
	vmovdqu	%ymm3, 288(%rsi)
	vpshufd	$85, %ymm2, %ymm3
	vpsllvd	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vpsllw	$12, %ymm3, %ymm5
	vpsllw	$8, %ymm3, %ymm7
	vpsllw	$4, %ymm3, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm3, %ymm3
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm3, %ymm6, %ymm7
	vpunpckhqdq	%ymm3, %ymm6, %ymm3
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm3, %ymm5, %ymm8
	vperm2i128	$49, %ymm3, %ymm5, %ymm3
	vmovdqu	%ymm6, 64(%rsi)
	vmovdqu	%ymm8, 96(%rsi)
	vmovdqu	%ymm7, 320(%rsi)
	vmovdqu	%ymm3, 352(%rsi)
	vpshufd	$170, %ymm2, %ymm3
	vpsllvd	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vpsllw	$12, %ymm3, %ymm5
	vpsllw	$8, %ymm3, %ymm7
	vpsllw	$4, %ymm3, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm3, %ymm3
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm3, %ymm6, %ymm7
	vpunpckhqdq	%ymm3, %ymm6, %ymm3
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm3, %ymm5, %ymm8
	vperm2i128	$49, %ymm3, %ymm5, %ymm3
	vmovdqu	%ymm6, 128(%rsi)
	vmovdqu	%ymm8, 160(%rsi)
	vmovdqu	%ymm7, 384(%rsi)
	vmovdqu	%ymm3, 416(%rsi)
	vpshufd	$255, %ymm2, %ymm3
	vpsllvd	%ymm4, %ymm3, %ymm3
	vpshufb	%ymm1, %ymm3, %ymm3
	vpsllw	$12, %ymm3, %ymm5
	vpsllw	$8, %ymm3, %ymm7
	vpsllw	$4, %ymm3, %ymm6
	vpsraw	$15, %ymm5, %ymm5
	vpsraw	$15, %ymm7, %ymm7
	vpsraw	$15, %ymm6, %ymm6
	vpsraw	$15, %ymm3, %ymm3
	vpand	%ymm0, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm7
	vpand	%ymm0, %ymm6, %ymm6
	vpand	%ymm0, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm5, %ymm8
	vpunpckhqdq	%ymm7, %ymm5, %ymm5
	vpunpcklqdq	%ymm3, %ymm6, %ymm7
	vpunpckhqdq	%ymm3, %ymm6, %ymm3
	vperm2i128	$32, %ymm7, %ymm8, %ymm6
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vperm2i128	$32, %ymm3, %ymm5, %ymm8
	vperm2i128	$49, %ymm3, %ymm5, %ymm3
	vmovdqu	%ymm6, 192(%rsi)
	vmovdqu	%ymm8, 224(%rsi)
	vmovdqu	%ymm7, 448(%rsi)
	vmovdqu	%ymm3, 480(%rsi)
	ret
.L_poly_frommont$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 768(%rip), %ymm1
	vmovdqu	glob_data + 512(%rip), %ymm2
	vmovdqu	(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, (%rdx)
	vmovdqu	32(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 32(%rdx)
	vmovdqu	64(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 64(%rdx)
	vmovdqu	96(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 96(%rdx)
	vmovdqu	128(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 128(%rdx)
	vmovdqu	160(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 160(%rdx)
	vmovdqu	192(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 192(%rdx)
	vmovdqu	224(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 224(%rdx)
	vmovdqu	256(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 256(%rdx)
	vmovdqu	288(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 288(%rdx)
	vmovdqu	320(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 320(%rdx)
	vmovdqu	352(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 352(%rdx)
	vmovdqu	384(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 384(%rdx)
	vmovdqu	416(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 416(%rdx)
	vmovdqu	448(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm5
	vmovdqu	%ymm5, 448(%rdx)
	vmovdqu	480(%rdx), %ymm3
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm1, %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm4, %ymm0
	vmovdqu	%ymm0, 480(%rdx)
	ret
.L_i_poly_frombytes$1:
	vmovdqu	glob_data + 640(%rip), %ymm0
	vmovdqu	(%r8), %ymm1
	vmovdqu	32(%r8), %ymm2
	vmovdqu	64(%r8), %ymm3
	vmovdqu	96(%r8), %ymm4
	vmovdqu	128(%r8), %ymm5
	vmovdqu	160(%r8), %ymm6
	vperm2i128	$32, %ymm4, %ymm1, %ymm7
	vperm2i128	$49, %ymm4, %ymm1, %ymm4
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vperm2i128	$32, %ymm6, %ymm3, %ymm5
	vperm2i128	$49, %ymm6, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm7, %ymm14
	vpunpckhqdq	%ymm2, %ymm7, %ymm1
	vpunpcklqdq	%ymm5, %ymm4, %ymm2
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpunpcklqdq	%ymm3, %ymm8, %ymm7
	vpunpckhqdq	%ymm3, %ymm8, %ymm3
	vmovsldup	%ymm5, %ymm4
	vpblendd	$170, %ymm4, %ymm14, %ymm4
	vpsrlq	$32, %ymm14, %ymm6
	vpblendd	$170, %ymm5, %ymm6, %ymm5
	vmovsldup	%ymm7, %ymm6
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm8
	vmovsldup	%ymm3, %ymm15
	vpblendd	$170, %ymm15, %ymm2, %ymm7
	vpsrlq	$32, %ymm2, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm2
	vpslld	$16, %ymm8, %ymm15
	vpblendw	$170, %ymm15, %ymm4, %ymm10
	vpsrld	$16, %ymm4, %ymm3
	vpblendw	$170, %ymm8, %ymm3, %ymm1
	vpslld	$16, %ymm7, %ymm4
	vpblendw	$170, %ymm4, %ymm5, %ymm15
	vpsrld	$16, %ymm5, %ymm3
	vpblendw	$170, %ymm7, %ymm3, %ymm3
	vpslld	$16, %ymm2, %ymm4
	vpblendw	$170, %ymm4, %ymm6, %ymm5
	vpsrld	$16, %ymm6, %ymm7
	vpblendw	$170, %ymm2, %ymm7, %ymm6
	vpsrlw	$12, %ymm10, %ymm12
	vpsllw	$4, %ymm1, %ymm2
	vpor	%ymm2, %ymm12, %ymm12
	vpand	%ymm10, %ymm0, %ymm2
	vpand	%ymm12, %ymm0, %ymm12
	vpsrlw	$8, %ymm1, %ymm1
	vpsllw	$8, %ymm15, %ymm4
	vpor	%ymm4, %ymm1, %ymm1
	vpand	%ymm1, %ymm0, %ymm1
	vpsrlw	$4, %ymm15, %ymm4
	vpand	%ymm4, %ymm0, %ymm4
	vpsrlw	$12, %ymm3, %ymm7
	vpsllw	$4, %ymm5, %ymm8
	vpor	%ymm8, %ymm7, %ymm7
	vpand	%ymm3, %ymm0, %ymm3
	vpand	%ymm7, %ymm0, %ymm7
	vpsrlw	$8, %ymm5, %ymm8
	vpsllw	$8, %ymm6, %ymm5
	vpor	%ymm5, %ymm8, %ymm8
	vpand	%ymm8, %ymm0, %ymm8
	vpsrlw	$4, %ymm6, %ymm5
	vpand	%ymm5, %ymm0, %ymm5
	vmovdqu	%ymm2, (%rsi)
	vmovdqu	%ymm12, 32(%rsi)
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	%ymm3, 128(%rsi)
	vmovdqu	%ymm7, 160(%rsi)
	vmovdqu	%ymm8, 192(%rsi)
	vmovdqu	%ymm5, 224(%rsi)
	vmovdqu	192(%r8), %ymm1
	vmovdqu	224(%r8), %ymm2
	vmovdqu	256(%r8), %ymm3
	vmovdqu	288(%r8), %ymm4
	vmovdqu	320(%r8), %ymm5
	vmovdqu	352(%r8), %ymm6
	vperm2i128	$32, %ymm4, %ymm1, %ymm7
	vperm2i128	$49, %ymm4, %ymm1, %ymm4
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vperm2i128	$32, %ymm6, %ymm3, %ymm5
	vperm2i128	$49, %ymm6, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm7, %ymm10
	vpunpckhqdq	%ymm2, %ymm7, %ymm1
	vpunpcklqdq	%ymm5, %ymm4, %ymm2
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpunpcklqdq	%ymm3, %ymm8, %ymm5
	vpunpckhqdq	%ymm3, %ymm8, %ymm6
	vmovsldup	%ymm4, %ymm15
	vpblendd	$170, %ymm15, %ymm10, %ymm15
	vpsrlq	$32, %ymm10, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm3
	vmovsldup	%ymm5, %ymm4
	vpblendd	$170, %ymm4, %ymm1, %ymm4
	vpsrlq	$32, %ymm1, %ymm1
	vpblendd	$170, %ymm5, %ymm1, %ymm8
	vmovsldup	%ymm6, %ymm1
	vpblendd	$170, %ymm1, %ymm2, %ymm5
	vpsrlq	$32, %ymm2, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm2
	vpslld	$16, %ymm8, %ymm1
	vpblendw	$170, %ymm1, %ymm15, %ymm7
	vpsrld	$16, %ymm15, %ymm14
	vpblendw	$170, %ymm8, %ymm14, %ymm1
	vpslld	$16, %ymm5, %ymm6
	vpblendw	$170, %ymm6, %ymm3, %ymm6
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm5, %ymm3, %ymm3
	vpslld	$16, %ymm2, %ymm15
	vpblendw	$170, %ymm15, %ymm4, %ymm5
	vpsrld	$16, %ymm4, %ymm8
	vpblendw	$170, %ymm2, %ymm8, %ymm8
	vpsrlw	$12, %ymm7, %ymm12
	vpsllw	$4, %ymm1, %ymm2
	vpor	%ymm2, %ymm12, %ymm12
	vpand	%ymm7, %ymm0, %ymm2
	vpand	%ymm12, %ymm0, %ymm12
	vpsrlw	$8, %ymm1, %ymm1
	vpsllw	$8, %ymm6, %ymm4
	vpor	%ymm4, %ymm1, %ymm1
	vpand	%ymm1, %ymm0, %ymm1
	vpsrlw	$4, %ymm6, %ymm4
	vpand	%ymm4, %ymm0, %ymm4
	vpsrlw	$12, %ymm3, %ymm7
	vpsllw	$4, %ymm5, %ymm6
	vpor	%ymm6, %ymm7, %ymm7
	vpand	%ymm3, %ymm0, %ymm3
	vpand	%ymm7, %ymm0, %ymm7
	vpsrlw	$8, %ymm5, %ymm6
	vpsllw	$8, %ymm8, %ymm5
	vpor	%ymm5, %ymm6, %ymm6
	vpand	%ymm6, %ymm0, %ymm6
	vpsrlw	$4, %ymm8, %ymm5
	vpand	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm2, 256(%rsi)
	vmovdqu	%ymm12, 288(%rsi)
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	%ymm4, 352(%rsi)
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	%ymm7, 416(%rsi)
	vmovdqu	%ymm6, 448(%rsi)
	vmovdqu	%ymm0, 480(%rsi)
	ret
.L_poly_basemul_acc_red$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 768(%rip), %ymm1
	vmovdqu	glob_data + 736(%rip), %ymm2
	vmovdqu	glob_data + 1904(%rip), %ymm7
	vmovdqu	glob_data + 1936(%rip), %ymm9
	vmovdqu	(%rcx), %ymm3
	vmovdqu	32(%rcx), %ymm4
	vmovdqu	(%rdi), %ymm5
	vmovdqu	32(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	(%rsi), %ymm3, %ymm3
	vpaddw	32(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm4, 32(%rsi)
	vmovdqu	glob_data + 1904(%rip), %ymm7
	vmovdqu	glob_data + 1936(%rip), %ymm9
	vmovdqu	64(%rcx), %ymm3
	vmovdqu	96(%rcx), %ymm4
	vmovdqu	64(%rdi), %ymm5
	vmovdqu	96(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	64(%rsi), %ymm3, %ymm3
	vpaddw	96(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	128(%rcx), %ymm3
	vmovdqu	160(%rcx), %ymm4
	vmovdqu	128(%rdi), %ymm5
	vmovdqu	160(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	128(%rsi), %ymm3, %ymm3
	vpaddw	160(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 128(%rsi)
	vmovdqu	%ymm4, 160(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	192(%rcx), %ymm3
	vmovdqu	224(%rcx), %ymm4
	vmovdqu	192(%rdi), %ymm5
	vmovdqu	224(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	192(%rsi), %ymm3, %ymm3
	vpaddw	224(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	%ymm4, 224(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	256(%rcx), %ymm3
	vmovdqu	288(%rcx), %ymm4
	vmovdqu	256(%rdi), %ymm5
	vmovdqu	288(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	256(%rsi), %ymm3, %ymm3
	vpaddw	288(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm4, 288(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	320(%rcx), %ymm3
	vmovdqu	352(%rcx), %ymm4
	vmovdqu	320(%rdi), %ymm5
	vmovdqu	352(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	320(%rsi), %ymm3, %ymm3
	vpaddw	352(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	%ymm4, 352(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	384(%rcx), %ymm3
	vmovdqu	416(%rcx), %ymm4
	vmovdqu	384(%rdi), %ymm5
	vmovdqu	416(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm11, %ymm11
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm11, %ymm12, %ymm11
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm11, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm8, %ymm4
	vpaddw	384(%rsi), %ymm3, %ymm3
	vpaddw	416(%rsi), %ymm4, %ymm5
	vpmulhw	%ymm2, %ymm3, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhw	%ymm2, %ymm5, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm5, %ymm4
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	%ymm4, 416(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	448(%rcx), %ymm3
	vmovdqu	480(%rcx), %ymm4
	vmovdqu	448(%rdi), %ymm5
	vmovdqu	480(%rdi), %ymm6
	vpmullw	%ymm6, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm9, %ymm8
	vpmulhw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm1, %ymm3, %ymm8
	vpmullw	%ymm1, %ymm4, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm10
	vpmullw	%ymm6, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm10, %ymm10
	vpmulhw	%ymm0, %ymm8, %ymm1
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm3, %ymm12
	vpsubw	%ymm10, %ymm12, %ymm10
	vpmulhw	%ymm6, %ymm3, %ymm12
	vpsubw	%ymm1, %ymm12, %ymm1
	vpmulhw	%ymm7, %ymm4, %ymm12
	vpsubw	%ymm8, %ymm12, %ymm8
	vpmulhw	%ymm5, %ymm4, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm8, %ymm10, %ymm3
	vpaddw	%ymm9, %ymm1, %ymm4
	vpaddw	448(%rsi), %ymm3, %ymm1
	vpaddw	480(%rsi), %ymm4, %ymm3
	vpmulhw	%ymm2, %ymm1, %ymm4
	vpsraw	$10, %ymm4, %ymm4
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm4, %ymm1, %ymm1
	vpmulhw	%ymm2, %ymm3, %ymm2
	vpsraw	$10, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm3, %ymm4
	vmovdqu	%ymm1, 448(%rsi)
	vmovdqu	%ymm4, 480(%rsi)
	ret
.L_poly_basemul_acc$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 768(%rip), %ymm1
	vmovdqu	glob_data + 1904(%rip), %ymm7
	vmovdqu	glob_data + 1936(%rip), %ymm9
	vmovdqu	(%rcx), %ymm2
	vmovdqu	32(%rcx), %ymm3
	vmovdqu	(%rdi), %ymm5
	vmovdqu	32(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	(%rsi), %ymm3, %ymm3
	vpaddw	32(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm4, 32(%rsi)
	vmovdqu	glob_data + 1904(%rip), %ymm7
	vmovdqu	glob_data + 1936(%rip), %ymm9
	vmovdqu	64(%rcx), %ymm2
	vmovdqu	96(%rcx), %ymm3
	vmovdqu	64(%rdi), %ymm5
	vmovdqu	96(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	64(%rsi), %ymm3, %ymm3
	vpaddw	96(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	128(%rcx), %ymm2
	vmovdqu	160(%rcx), %ymm3
	vmovdqu	128(%rdi), %ymm5
	vmovdqu	160(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	128(%rsi), %ymm3, %ymm3
	vpaddw	160(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 128(%rsi)
	vmovdqu	%ymm4, 160(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	192(%rcx), %ymm2
	vmovdqu	224(%rcx), %ymm3
	vmovdqu	192(%rdi), %ymm5
	vmovdqu	224(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	192(%rsi), %ymm3, %ymm3
	vpaddw	224(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	%ymm4, 224(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	256(%rcx), %ymm2
	vmovdqu	288(%rcx), %ymm3
	vmovdqu	256(%rdi), %ymm5
	vmovdqu	288(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	256(%rsi), %ymm3, %ymm3
	vpaddw	288(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm4, 288(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	320(%rcx), %ymm2
	vmovdqu	352(%rcx), %ymm3
	vmovdqu	320(%rdi), %ymm5
	vmovdqu	352(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	320(%rsi), %ymm3, %ymm3
	vpaddw	352(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	%ymm4, 352(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	384(%rcx), %ymm2
	vmovdqu	416(%rcx), %ymm3
	vmovdqu	384(%rdi), %ymm5
	vmovdqu	416(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vpaddw	384(%rsi), %ymm3, %ymm3
	vpaddw	416(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	%ymm4, 416(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	448(%rcx), %ymm2
	vmovdqu	480(%rcx), %ymm3
	vmovdqu	448(%rdi), %ymm5
	vmovdqu	480(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm1
	vpmullw	%ymm7, %ymm9, %ymm8
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm0
	vpsubw	%ymm6, %ymm0, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm0
	vpsubw	%ymm1, %ymm0, %ymm1
	vpmulhw	%ymm7, %ymm3, %ymm0
	vpsubw	%ymm8, %ymm0, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm0
	vpsubw	%ymm9, %ymm0, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm1, %ymm4
	vpaddw	448(%rsi), %ymm3, %ymm1
	vpaddw	480(%rsi), %ymm4, %ymm4
	vmovdqu	%ymm1, 448(%rsi)
	vmovdqu	%ymm4, 480(%rsi)
	ret
.L_poly_basemul$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	glob_data + 768(%rip), %ymm1
	vmovdqu	glob_data + 1904(%rip), %ymm6
	vmovdqu	glob_data + 1936(%rip), %ymm7
	vmovdqu	(%rcx), %ymm2
	vmovdqu	32(%rcx), %ymm3
	vmovdqu	(%rdi), %ymm5
	vmovdqu	32(%rdi), %ymm4
	vpmullw	%ymm4, %ymm6, %ymm6
	vpmulhw	%ymm4, %ymm7, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, (%rsi)
	vmovdqu	%ymm4, 32(%rsi)
	vmovdqu	glob_data + 1904(%rip), %ymm7
	vmovdqu	glob_data + 1936(%rip), %ymm9
	vmovdqu	64(%rcx), %ymm2
	vmovdqu	96(%rcx), %ymm3
	vmovdqu	64(%rdi), %ymm5
	vmovdqu	96(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 64(%rsi)
	vmovdqu	%ymm4, 96(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	128(%rcx), %ymm2
	vmovdqu	160(%rcx), %ymm3
	vmovdqu	128(%rdi), %ymm5
	vmovdqu	160(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 128(%rsi)
	vmovdqu	%ymm4, 160(%rsi)
	vmovdqu	glob_data + 1968(%rip), %ymm7
	vmovdqu	glob_data + 2000(%rip), %ymm9
	vmovdqu	192(%rcx), %ymm2
	vmovdqu	224(%rcx), %ymm3
	vmovdqu	192(%rdi), %ymm5
	vmovdqu	224(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 192(%rsi)
	vmovdqu	%ymm4, 224(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	256(%rcx), %ymm2
	vmovdqu	288(%rcx), %ymm3
	vmovdqu	256(%rdi), %ymm5
	vmovdqu	288(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 256(%rsi)
	vmovdqu	%ymm4, 288(%rsi)
	vmovdqu	glob_data + 2296(%rip), %ymm7
	vmovdqu	glob_data + 2328(%rip), %ymm9
	vmovdqu	320(%rcx), %ymm2
	vmovdqu	352(%rcx), %ymm3
	vmovdqu	320(%rdi), %ymm5
	vmovdqu	352(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 320(%rsi)
	vmovdqu	%ymm4, 352(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	384(%rcx), %ymm2
	vmovdqu	416(%rcx), %ymm3
	vmovdqu	384(%rdi), %ymm5
	vmovdqu	416(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm8
	vpmullw	%ymm7, %ymm9, %ymm11
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm8, %ymm10
	vpmulhw	%ymm0, %ymm11, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm12
	vpsubw	%ymm6, %ymm12, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm2
	vpsubw	%ymm10, %ymm2, %ymm10
	vpmulhw	%ymm7, %ymm3, %ymm2
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm5
	vpsubw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm10, %ymm4
	vmovdqu	%ymm3, 384(%rsi)
	vmovdqu	%ymm4, 416(%rsi)
	vmovdqu	glob_data + 2360(%rip), %ymm7
	vmovdqu	glob_data + 2392(%rip), %ymm9
	vmovdqu	448(%rcx), %ymm2
	vmovdqu	480(%rcx), %ymm3
	vmovdqu	448(%rdi), %ymm5
	vmovdqu	480(%rdi), %ymm4
	vpmullw	%ymm4, %ymm7, %ymm6
	vpmulhw	%ymm4, %ymm9, %ymm7
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm1, %ymm3, %ymm9
	vpmullw	%ymm5, %ymm8, %ymm6
	vpmullw	%ymm4, %ymm8, %ymm1
	vpmullw	%ymm7, %ymm9, %ymm8
	vpmullw	%ymm5, %ymm9, %ymm9
	vpmulhw	%ymm0, %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm1, %ymm1
	vpmulhw	%ymm0, %ymm8, %ymm8
	vpmulhw	%ymm0, %ymm9, %ymm9
	vpmulhw	%ymm5, %ymm2, %ymm0
	vpsubw	%ymm6, %ymm0, %ymm6
	vpmulhw	%ymm4, %ymm2, %ymm0
	vpsubw	%ymm1, %ymm0, %ymm1
	vpmulhw	%ymm7, %ymm3, %ymm0
	vpsubw	%ymm8, %ymm0, %ymm2
	vpmulhw	%ymm5, %ymm3, %ymm0
	vpsubw	%ymm9, %ymm0, %ymm9
	vpsubw	%ymm2, %ymm6, %ymm3
	vpaddw	%ymm9, %ymm1, %ymm4
	vmovdqu	%ymm3, 448(%rsi)
	vmovdqu	%ymm4, 480(%rsi)
	ret
.L_poly_csubq$1:
	vmovdqu	glob_data + 800(%rip), %ymm0
	vmovdqu	(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, (%rsi)
	vmovdqu	32(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 32(%rsi)
	vmovdqu	64(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 64(%rsi)
	vmovdqu	96(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 96(%rsi)
	vmovdqu	128(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 128(%rsi)
	vmovdqu	160(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 160(%rsi)
	vmovdqu	192(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 192(%rsi)
	vmovdqu	224(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 224(%rsi)
	vmovdqu	256(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 256(%rsi)
	vmovdqu	288(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 288(%rsi)
	vmovdqu	320(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 320(%rsi)
	vmovdqu	352(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 352(%rsi)
	vmovdqu	384(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 384(%rsi)
	vmovdqu	416(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 416(%rsi)
	vmovdqu	448(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddw	%ymm1, %ymm2, %ymm1
	vmovdqu	%ymm1, 448(%rsi)
	vmovdqu	480(%rsi), %ymm1
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm2
	vpand	%ymm0, %ymm2, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm1
	vmovdqu	%ymm1, 480(%rsi)
	ret
.L_poly_add2$1:
	vmovdqu	(%rdx), %ymm1
	vmovdqu	(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, (%rdx)
	vmovdqu	32(%rdx), %ymm1
	vmovdqu	32(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 32(%rdx)
	vmovdqu	64(%rdx), %ymm1
	vmovdqu	64(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 64(%rdx)
	vmovdqu	96(%rdx), %ymm1
	vmovdqu	96(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 96(%rdx)
	vmovdqu	128(%rdx), %ymm1
	vmovdqu	128(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rdx)
	vmovdqu	160(%rdx), %ymm1
	vmovdqu	160(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rdx)
	vmovdqu	192(%rdx), %ymm1
	vmovdqu	192(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rdx)
	vmovdqu	224(%rdx), %ymm1
	vmovdqu	224(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rdx)
	vmovdqu	256(%rdx), %ymm1
	vmovdqu	256(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rdx)
	vmovdqu	288(%rdx), %ymm1
	vmovdqu	288(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rdx)
	vmovdqu	320(%rdx), %ymm1
	vmovdqu	320(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rdx)
	vmovdqu	352(%rdx), %ymm1
	vmovdqu	352(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 352(%rdx)
	vmovdqu	384(%rdx), %ymm1
	vmovdqu	384(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 384(%rdx)
	vmovdqu	416(%rdx), %ymm1
	vmovdqu	416(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rdx)
	vmovdqu	448(%rdx), %ymm1
	vmovdqu	448(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 448(%rdx)
	vmovdqu	480(%rdx), %ymm1
	vmovdqu	480(%rdi), %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rdx)
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
	movq	$0, %r9
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake256x4_AETA1__A32_A1$6:
	movq	$0, %r8
	jmp 	.L_shake256x4_AETA1__A32_A1$4
.L_shake256x4_AETA1__A32_A1$5:
	vmovdqu	(%rax,%r8,4), %ymm9
	vmovdqu	32(%rax,%r8,4), %ymm11
	vmovdqu	64(%rax,%r8,4), %ymm3
	vmovdqu	96(%rax,%r8,4), %ymm14
	addq	$32, %r8
	vperm2i128	$32, %ymm3, %ymm9, %ymm0
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm9, %ymm2
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm0, %ymm4
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm4, (%rcx,%r9)
	vmovdqu	%ymm1, (%rdx,%r9)
	vmovdqu	%ymm0, (%rsi,%r9)
	vmovdqu	%ymm3, (%rdi,%r9)
	addq	$32, %r9
.L_shake256x4_AETA1__A32_A1$4:
	cmpq	$128, %r8
	jb  	.L_shake256x4_AETA1__A32_A1$5
	jmp 	.L_shake256x4_AETA1__A32_A1$2
.L_shake256x4_AETA1__A32_A1$3:
	movq	(%rax,%r8,4), %r10
	movq	%r10, (%rcx,%r9)
	movq	8(%rax,%r8,4), %r10
	movq	%r10, (%rdx,%r9)
	movq	16(%rax,%r8,4), %r10
	movq	%r10, (%rsi,%r9)
	movq	24(%rax,%r8,4), %r10
	movq	%r10, (%rdi,%r9)
	addq	$8, %r8
	addq	$8, %r9
.L_shake256x4_AETA1__A32_A1$2:
	cmpq	$128, %r8
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
	movq	$0, %r9
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r9), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%r9), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%r9), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %r9
	movq	%rcx, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$9:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	$0, %rdx
	jmp 	.L_shake256_A32__AZCT$6
.L_shake256_A32__AZCT$7:
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r9), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%r9), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%r9), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %r9
	movq	%rcx, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$8:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	%mm4, %rdx
	incq	%rdx
.L_shake256_A32__AZCT$6:
	cmpq	$10, %rdx
	jb  	.L_shake256_A32__AZCT$7
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r9), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	movq	96(%rcx,%r9), %r8
	xorq	%r8, 96(%rax)
	movq	$0, %r8
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r8
	xorq	%r8, 104(%rax)
	xorb	$128, 135(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %r9
	movq	$0, %rdx
	jmp 	.L_shake256_A32__AZCT$3
.L_shake256_A32__AZCT$4:
	incq	%rdx
	movq	%rcx, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%r9)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%r9)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%r9)
	movq	128(%rax), %rsi
	movq	%rsi, 128(%rcx,%r9)
	addq	$136, %r9
.L_shake256_A32__AZCT$3:
	cmpq	$0, %rdx
	jb  	.L_shake256_A32__AZCT$4
	movq	%rcx, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A32__AZCT$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
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
	movq	$0, %r9
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r9), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%r9), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%r9), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %r9
	movq	%rcx, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$9:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	$0, %rdx
	jmp 	.L_sha3_256A_APK$6
.L_sha3_256A_APK$7:
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%r9), %ymm0
	vpxor	64(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rax)
	vmovdqu	96(%rcx,%r9), %ymm0
	vpxor	96(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 96(%rax)
	movq	128(%rcx,%r9), %r8
	xorq	%r8, 128(%rax)
	addq	$136, %r9
	movq	%rcx, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$8:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	%mm4, %rdx
	incq	%rdx
.L_sha3_256A_APK$6:
	cmpq	$10, %rdx
	jb  	.L_sha3_256A_APK$7
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	64(%rcx,%r9), %r8
	xorq	%r8, 64(%rax)
	movq	$0, %r8
	movq	$6, %r9
	shlq	$0, %r9
	orq 	%r9, %r8
	xorq	%r8, 72(%rax)
	xorb	$128, 135(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %r9
	movq	$0, %rdx
	jmp 	.L_sha3_256A_APK$3
.L_sha3_256A_APK$4:
	incq	%rdx
	movq	%rcx, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%r9)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rcx,%r9)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rcx,%r9)
	movq	128(%rax), %rsi
	movq	%rsi, 128(%rcx,%r9)
	addq	$136, %r9
.L_sha3_256A_APK$3:
	cmpq	$0, %rdx
	jb  	.L_sha3_256A_APK$4
	movq	%rcx, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_256A_APK$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	ret
.L_shake128x4_squeeze3blocks$1:
	movq	%rcx, %rdx
	leaq	536(%rcx), %rsi
	leaq	1072(%rcx), %rdi
	leaq	1608(%rcx), %r8
	movq	$0, %r9
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$16:
	movq	$0, %r10
	jmp 	.L_shake128x4_squeeze3blocks$14
.L_shake128x4_squeeze3blocks$15:
	vmovdqu	(%rax,%r10,4), %ymm9
	vmovdqu	32(%rax,%r10,4), %ymm11
	vmovdqu	64(%rax,%r10,4), %ymm3
	vmovdqu	96(%rax,%r10,4), %ymm14
	addq	$32, %r10
	vperm2i128	$32, %ymm3, %ymm9, %ymm0
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm9, %ymm2
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm0, %ymm4
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm4, (%rdx,%r9)
	vmovdqu	%ymm1, (%rsi,%r9)
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	%ymm3, (%r8,%r9)
	addq	$32, %r9
.L_shake128x4_squeeze3blocks$14:
	cmpq	$160, %r10
	jb  	.L_shake128x4_squeeze3blocks$15
	jmp 	.L_shake128x4_squeeze3blocks$12
.L_shake128x4_squeeze3blocks$13:
	movq	(%rax,%r10,4), %r11
	movq	%r11, (%rdx,%r9)
	movq	8(%rax,%r10,4), %r11
	movq	%r11, (%rsi,%r9)
	movq	16(%rax,%r10,4), %r11
	movq	%r11, (%rdi,%r9)
	movq	24(%rax,%r10,4), %r11
	movq	%r11, (%r8,%r9)
	addq	$8, %r10
	addq	$8, %r9
.L_shake128x4_squeeze3blocks$12:
	cmpq	$168, %r10
	jb  	.L_shake128x4_squeeze3blocks$13
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$11:
	movq	$0, %r10
	jmp 	.L_shake128x4_squeeze3blocks$9
.L_shake128x4_squeeze3blocks$10:
	vmovdqu	(%rax,%r10,4), %ymm0
	vmovdqu	32(%rax,%r10,4), %ymm11
	vmovdqu	64(%rax,%r10,4), %ymm3
	vmovdqu	96(%rax,%r10,4), %ymm14
	addq	$32, %r10
	vperm2i128	$32, %ymm3, %ymm0, %ymm4
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm4, %ymm2
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vpunpcklqdq	%ymm3, %ymm0, %ymm4
	vpunpckhqdq	%ymm3, %ymm0, %ymm3
	vmovdqu	%ymm2, (%rdx,%r9)
	vmovdqu	%ymm1, (%rsi,%r9)
	vmovdqu	%ymm4, (%rdi,%r9)
	vmovdqu	%ymm3, (%r8,%r9)
	addq	$32, %r9
.L_shake128x4_squeeze3blocks$9:
	cmpq	$160, %r10
	jb  	.L_shake128x4_squeeze3blocks$10
	jmp 	.L_shake128x4_squeeze3blocks$7
.L_shake128x4_squeeze3blocks$8:
	movq	(%rax,%r10,4), %r11
	movq	%r11, (%rdx,%r9)
	movq	8(%rax,%r10,4), %r11
	movq	%r11, (%rsi,%r9)
	movq	16(%rax,%r10,4), %r11
	movq	%r11, (%rdi,%r9)
	movq	24(%rax,%r10,4), %r11
	movq	%r11, (%r8,%r9)
	addq	$8, %r10
	addq	$8, %r9
.L_shake128x4_squeeze3blocks$7:
	cmpq	$168, %r10
	jb  	.L_shake128x4_squeeze3blocks$8
	call	.L_keccakf1600_avx2x4_nat$1
.L_shake128x4_squeeze3blocks$6:
	movq	$0, %r10
	jmp 	.L_shake128x4_squeeze3blocks$4
.L_shake128x4_squeeze3blocks$5:
	vmovdqu	(%rax,%r10,4), %ymm9
	vmovdqu	32(%rax,%r10,4), %ymm11
	vmovdqu	64(%rax,%r10,4), %ymm3
	vmovdqu	96(%rax,%r10,4), %ymm14
	addq	$32, %r10
	vperm2i128	$32, %ymm3, %ymm9, %ymm0
	vperm2i128	$32, %ymm14, %ymm11, %ymm1
	vperm2i128	$49, %ymm3, %ymm9, %ymm2
	vperm2i128	$49, %ymm14, %ymm11, %ymm3
	vpunpcklqdq	%ymm1, %ymm0, %ymm4
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm4, (%rdx,%r9)
	vmovdqu	%ymm1, (%rsi,%r9)
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	%ymm3, (%r8,%r9)
	addq	$32, %r9
.L_shake128x4_squeeze3blocks$4:
	cmpq	$192, %r10
	jb  	.L_shake128x4_squeeze3blocks$5
	jmp 	.L_shake128x4_squeeze3blocks$2
.L_shake128x4_squeeze3blocks$3:
	movq	(%rax,%r10,4), %r11
	movq	%r11, (%rdx,%r9)
	movq	8(%rax,%r10,4), %r11
	movq	%r11, (%rsi,%r9)
	movq	16(%rax,%r10,4), %r11
	movq	%r11, (%rdi,%r9)
	movq	24(%rax,%r10,4), %r11
	movq	%r11, (%r8,%r9)
	addq	$8, %r10
	addq	$8, %r9
.L_shake128x4_squeeze3blocks$2:
	cmpq	$200, %r10
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
	movq	$0, %rdx
	orq 	%rdx, %r8
	ret
.L_shake128x4_absorb_A32_A2$1:
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.L_shake128x4_absorb_A32_A2$6
.L_shake128x4_absorb_A32_A2$7:
	vmovdqu	%ymm0, (%rax,%rdx)
	addq	$32, %rdx
.L_shake128x4_absorb_A32_A2$6:
	cmpq	$800, %rdx
	jb  	.L_shake128x4_absorb_A32_A2$7
	movq	$0, %r9
	movq	$0, %r10
	jmp 	.L_shake128x4_absorb_A32_A2$4
.L_shake128x4_absorb_A32_A2$5:
	vpbroadcastq	(%rcx,%r9), %ymm0
	addq	$8, %r9
	vpxor	(%rax,%r10), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax,%r10)
	addq	$32, %r10
.L_shake128x4_absorb_A32_A2$4:
	cmpq	$128, %r10
	jb  	.L_shake128x4_absorb_A32_A2$5
	movq	%rdi, %r8
	leaq	2(%rdi), %rdx
	leaq	4(%rdi), %rsi
	leaq	6(%rdi), %rdi
	movq	$0, %r9
	movq	$16, %rcx
	jmp 	.L_shake128x4_absorb_A32_A2$2
.L_shake128x4_absorb_A32_A2$3:
	movq	(%r8,%r9), %r10
	xorq	%r10, (%rax,%rcx,8)
	movq	(%rdx,%r9), %r10
	xorq	%r10, 8(%rax,%rcx,8)
	movq	(%rsi,%r9), %r10
	xorq	%r10, 16(%rax,%rcx,8)
	movq	(%rdi,%r9), %r10
	addq	$8, %r9
	xorq	%r10, 24(%rax,%rcx,8)
	addq	$4, %rcx
.L_shake128x4_absorb_A32_A2$2:
	cmpq	$16, %rcx
	jb  	.L_shake128x4_absorb_A32_A2$3
	movq	$0, %r10
	movzwq	(%r8,%r9), %r8
	orq 	%r8, %r10
	movq	$31, %r8
	shlq	$16, %r8
	orq 	%r8, %r10
	xorq	%r10, (%rax,%rcx,8)
	movq	$0, %r8
	movzwq	(%rdx,%r9), %rdx
	orq 	%rdx, %r8
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r8
	xorq	%r8, 8(%rax,%rcx,8)
	movq	$0, %r8
	movzwq	(%rsi,%r9), %rdx
	orq 	%rdx, %r8
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r8
	xorq	%r8, 16(%rax,%rcx,8)
	movq	$0, %r10
	movzwq	(%rdi,%r9), %rdx
	orq 	%rdx, %r10
	movq	$31, %rdx
	shlq	$16, %rdx
	orq 	%rdx, %r10
	xorq	%r10, 24(%rax,%rcx,8)
	movq	$-9223372036854775808, %r8
	movq	%r8, 8(%rsp)
	vpbroadcastq	8(%rsp), %ymm0
	vpxor	640(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 640(%rax)
	ret
.L_shake256_A128__A32_A1$1:
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
	movq	$0, %r9
	vmovdqu	(%r8,%r9), %ymm0
	vpxor	(%rcx), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rcx)
	leaq	32(%rsp), %rcx
	movq	$0, %r9
	movq	$0, %r8
	movzbq	(%rax,%r9), %rdx
	orq 	%rdx, %r8
	movq	$31, %rdx
	shlq	$8, %rdx
	orq 	%rdx, %r8
	xorq	%r8, 32(%rcx)
	xorb	$128, 135(%rcx)
	leaq	32(%rsp), %rax
	movq	$0, %r9
	movq	$0, %rdx
	jmp 	.L_shake256_A128__A32_A1$3
.L_shake256_A128__A32_A1$4:
	incq	%rdx
	movq	%rdi, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A1$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r9)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%r9)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%r9)
	movq	128(%rax), %rsi
	movq	%rsi, 128(%rdi,%r9)
	addq	$136, %r9
.L_shake256_A128__A32_A1$3:
	cmpq	$0, %rdx
	jb  	.L_shake256_A128__A32_A1$4
	movq	%rdi, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_shake256_A128__A32_A1$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r9)
	vmovdqu	64(%rax), %ymm0
	vmovdqu	%ymm0, 64(%rdi,%r9)
	vmovdqu	96(%rax), %ymm0
	vmovdqu	%ymm0, 96(%rdi,%r9)
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
	movq	$0, %r9
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%r9), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	movq	$0, %r8
	movq	$6, %rdx
	shlq	$0, %rdx
	orq 	%rdx, %r8
	xorq	%r8, 64(%rax)
	xorb	$128, 71(%rax)
	movq	%mm1, %rcx
	leaq	32(%rsp), %rax
	movq	$0, %r9
	movq	$0, %rdx
	jmp 	.L_sha3_512A_A64$3
.L_sha3_512A_A64$4:
	incq	%rdx
	movq	%rcx, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A64$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rcx
	movq	%mm3, %r9
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rcx,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rcx,%r9)
	movq	64(%rax), %rsi
	movq	%rsi, 64(%rcx,%r9)
	addq	$72, %r9
.L_sha3_512A_A64$3:
	cmpq	$0, %rdx
	jb  	.L_sha3_512A_A64$4
	movq	%rcx, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A64$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r9)
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
	movq	$0, %r9
	vmovdqu	(%rcx,%r9), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	movq	$0, %r8
	movzbq	32(%rcx,%r9), %rdx
	orq 	%rdx, %r8
	movq	$6, %rdx
	shlq	$8, %rdx
	orq 	%rdx, %r8
	xorq	%r8, 32(%rax)
	xorb	$128, 71(%rax)
	leaq	32(%rsp), %rax
	movq	$0, %r9
	movq	$0, %rdx
	jmp 	.L_sha3_512A_A33$3
.L_sha3_512A_A33$4:
	incq	%rdx
	movq	%rdi, %mm2
	movq	%r9, %mm3
	movq	%rdx, %mm4
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A33$5:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	movq	%mm4, %rdx
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r9)
	movq	64(%rax), %rsi
	movq	%rsi, 64(%rdi,%r9)
	addq	$72, %r9
.L_sha3_512A_A33$3:
	cmpq	$0, %rdx
	jb  	.L_sha3_512A_A33$4
	movq	%rdi, %mm2
	movq	%r9, %mm3
	leaq	-200(%rsp), %rsp
	call	.L_keccakf1600_opt$1
.L_sha3_512A_A33$2:
	leaq	200(%rsp), %rsp
	movq	%mm2, %rdi
	movq	%mm3, %r9
	vmovdqu	(%rax), %ymm0
	vmovdqu	%ymm0, (%rdi,%r9)
	vmovdqu	32(%rax), %ymm0
	vmovdqu	%ymm0, 32(%rdi,%r9)
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
	leaq	glob_data + 448(%rip), %r10
	leaq	glob_data + 480(%rip), %r11
	leaq	glob_data + 4560(%rip), %rbx
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
	vpshufb	(%r10), %ymm2, %ymm2
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
	leaq	glob_data + 4560(%rip), %rbp
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
	leaq	glob_data + 4560(%rip), %r14
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
	vmovdqu	(%rdx), %ymm2
	vmovdqu	32(%rdx), %ymm4
	vmovdqu	64(%rdx), %ymm5
	vmovdqu	96(%rdx), %ymm6
	vmovdqu	128(%rdx), %ymm3
	vmovdqu	160(%rdx), %ymm7
	vmovdqu	192(%rdx), %ymm8
	vmovdqu	224(%rdx), %ymm10
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
	vpunpcklqdq	%ymm11, %ymm3, %ymm2
	vpunpckhqdq	%ymm11, %ymm3, %ymm3
	vpunpcklqdq	%ymm13, %ymm4, %ymm10
	vpunpckhqdq	%ymm13, %ymm4, %ymm4
	vmovsldup	%ymm2, %ymm1
	vpblendd	$170, %ymm1, %ymm5, %ymm12
	vpsrlq	$32, %ymm5, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vmovsldup	%ymm3, %ymm2
	vpblendd	$170, %ymm2, %ymm6, %ymm2
	vpsrlq	$32, %ymm6, %ymm5
	vpblendd	$170, %ymm3, %ymm5, %ymm3
	vmovsldup	%ymm10, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm5
	vpsrlq	$32, %ymm7, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm6
	vmovsldup	%ymm4, %ymm15
	vpblendd	$170, %ymm15, %ymm8, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpslld	$16, %ymm5, %ymm15
	vpblendw	$170, %ymm15, %ymm12, %ymm10
	vpsrld	$16, %ymm12, %ymm8
	vpblendw	$170, %ymm5, %ymm8, %ymm8
	vpslld	$16, %ymm6, %ymm15
	vpblendw	$170, %ymm15, %ymm1, %ymm5
	vpsrld	$16, %ymm1, %ymm14
	vpblendw	$170, %ymm6, %ymm14, %ymm9
	vpslld	$16, %ymm7, %ymm1
	vpblendw	$170, %ymm1, %ymm2, %ymm0
	vpsrld	$16, %ymm2, %ymm14
	vpblendw	$170, %ymm7, %ymm14, %ymm6
	vpslld	$16, %ymm4, %ymm1
	vpblendw	$170, %ymm1, %ymm3, %ymm7
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm4, %ymm3, %ymm2
	vmovdqu	%ymm10, (%rdx)
	vmovdqu	%ymm8, 32(%rdx)
	vmovdqu	%ymm5, 64(%rdx)
	vmovdqu	%ymm9, 96(%rdx)
	vmovdqu	%ymm0, 128(%rdx)
	vmovdqu	%ymm6, 160(%rdx)
	vmovdqu	%ymm7, 192(%rdx)
	vmovdqu	%ymm2, 224(%rdx)
	vmovdqu	256(%rdx), %ymm2
	vmovdqu	288(%rdx), %ymm4
	vmovdqu	320(%rdx), %ymm5
	vmovdqu	352(%rdx), %ymm6
	vmovdqu	384(%rdx), %ymm3
	vmovdqu	416(%rdx), %ymm7
	vmovdqu	448(%rdx), %ymm8
	vmovdqu	480(%rdx), %ymm10
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
	vpunpcklqdq	%ymm11, %ymm3, %ymm2
	vpunpckhqdq	%ymm11, %ymm3, %ymm3
	vpunpcklqdq	%ymm13, %ymm4, %ymm10
	vpunpckhqdq	%ymm13, %ymm4, %ymm4
	vmovsldup	%ymm2, %ymm1
	vpblendd	$170, %ymm1, %ymm5, %ymm12
	vpsrlq	$32, %ymm5, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	vmovsldup	%ymm3, %ymm2
	vpblendd	$170, %ymm2, %ymm6, %ymm2
	vpsrlq	$32, %ymm6, %ymm5
	vpblendd	$170, %ymm3, %ymm5, %ymm3
	vmovsldup	%ymm10, %ymm6
	vpblendd	$170, %ymm6, %ymm7, %ymm5
	vpsrlq	$32, %ymm7, %ymm6
	vpblendd	$170, %ymm10, %ymm6, %ymm6
	vmovsldup	%ymm4, %ymm15
	vpblendd	$170, %ymm15, %ymm8, %ymm7
	vpsrlq	$32, %ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vpslld	$16, %ymm5, %ymm15
	vpblendw	$170, %ymm15, %ymm12, %ymm10
	vpsrld	$16, %ymm12, %ymm8
	vpblendw	$170, %ymm5, %ymm8, %ymm5
	vpslld	$16, %ymm6, %ymm15
	vpblendw	$170, %ymm15, %ymm1, %ymm0
	vpsrld	$16, %ymm1, %ymm8
	vpblendw	$170, %ymm6, %ymm8, %ymm6
	vpslld	$16, %ymm7, %ymm1
	vpblendw	$170, %ymm1, %ymm2, %ymm8
	vpsrld	$16, %ymm2, %ymm14
	vpblendw	$170, %ymm7, %ymm14, %ymm9
	vpslld	$16, %ymm4, %ymm1
	vpblendw	$170, %ymm1, %ymm3, %ymm7
	vpsrld	$16, %ymm3, %ymm3
	vpblendw	$170, %ymm4, %ymm3, %ymm2
	vmovdqu	%ymm10, 256(%rdx)
	vmovdqu	%ymm5, 288(%rdx)
	vmovdqu	%ymm0, 320(%rdx)
	vmovdqu	%ymm6, 352(%rdx)
	vmovdqu	%ymm8, 384(%rdx)
	vmovdqu	%ymm9, 416(%rdx)
	vmovdqu	%ymm7, 448(%rdx)
	vmovdqu	%ymm2, 480(%rdx)
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
	.byte	  0,   0,   1,   0,   2,   0,   3,   0,   0,   1,   1,   1,   2,   1,   3,   1
	.byte	  0,   2,   1,   2,   2,   2,   3,   2,   0,   3,   1,   3,   2,   3,   3,   3
	.byte	  0,   0,   0,   1,   0,   2,   0,   3,   1,   0,   1,   1,   1,   2,   1,   3
	.byte	  2,   0,   2,   1,   2,   2,   2,   3,   3,   0,   3,   1,   3,   2,   3,   3
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
