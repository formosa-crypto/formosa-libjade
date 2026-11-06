	.att_syntax
	.text
	.p2align	5
	.global	ml_dsa_44_verify
	.global	ml_dsa_44_sign
	.global	ml_dsa_44_keygen
	.type	ml_dsa_44_verify, %function
ml_dsa_44_verify:
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
	jbe 	.Lml_dsa_44_verify$1
	movq	$-1, %r11
	jmp 	.Lml_dsa_44_verify$2
.Lml_dsa_44_verify$1:
	leaq	-37464(%rsp), %rsp
	call	.L__verify_internal$1
.Lml_dsa_44_verify$3:
	leaq	37464(%rsp), %rsp
.Lml_dsa_44_verify$2:
	movq	%r11, %rax
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_44_sign, %function
ml_dsa_44_sign:
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
	jbe 	.Lml_dsa_44_sign$1
	movq	$-1, %rax
	jmp 	.Lml_dsa_44_sign$2
.Lml_dsa_44_sign$1:
	leaq	-80376(%rsp), %rsp
	call	.L__sign_internal$1
.Lml_dsa_44_sign$3:
	leaq	80376(%rsp), %rsp
.Lml_dsa_44_sign$2:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
	.type	ml_dsa_44_keygen, %function
ml_dsa_44_keygen:
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
	leaq	-34328(%rsp), %rsp
	call	.L__keygen_internal$1
.Lml_dsa_44_keygen$1:
	leaq	34328(%rsp), %rsp
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	40(%rsp), %r15
	movq	48(%rsp), %rsp
	ret
.L__verify_internal$1:
	movq	%rax, 37360(%rsp)
	movq	%rsi, 37368(%rsp)
	movq	%rdx, 37376(%rsp)
	movq	%rcx, 37384(%rsp)
	leaq	12768(%rsp), %rax
	leaq	8672(%rsp), %rcx
	leaq	32(%r8), %rdx
	movq	%rax, %r10
	movq	%rdx, %rsi
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r11
	jmp 	.L__verify_internal$257
.L__verify_internal$258:
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$2, %r9
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$16, %r9
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%r10,%r11)
	addq	$32, %r11
.L__verify_internal$257:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$258
	leaq	1024(%rax), %r10
	leaq	576(%rdx), %rsi
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r11
	jmp 	.L__verify_internal$255
.L__verify_internal$256:
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$2, %r9
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$16, %r9
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%r10,%r11)
	addq	$32, %r11
.L__verify_internal$255:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$256
	leaq	2048(%rax), %r10
	leaq	1152(%rdx), %rsi
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r11
	jmp 	.L__verify_internal$253
.L__verify_internal$254:
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$2, %r9
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$16, %r9
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%r10,%r11)
	addq	$32, %r11
.L__verify_internal$253:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$254
	leaq	3072(%rax), %rax
	leaq	1728(%rdx), %rsi
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r9
	movq	$0, %r11
	jmp 	.L__verify_internal$251
.L__verify_internal$252:
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$2, %r9
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r9), %xmm3
	addq	$16, %r9
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%r11)
	addq	$32, %r11
.L__verify_internal$251:
	cmpq	$1024, %r11
	jb  	.L__verify_internal$252
	leaq	2336(%r8), %rax
	lfence
	movq	$0, %rdx
	movq	$0, %r11
	movq	$0, %r12
	movq	$0, %rsi
	jmp 	.L__verify_internal$233
.L__verify_internal$234:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%rsi, %r9
	shlq	$8, %r9
	movq	$0, %r10
	jmp 	.L__verify_internal$249
.L__verify_internal$250:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movq	%r9, %rbx
	addq	%r10, %rbx
	movl	$0, (%rcx,%rbx,4)
	incq	%r10
.L__verify_internal$249:
	cmpq	$256, %r10
	jb  	.L__verify_internal$250
	movq	$-1, %r10
	cmovb	%r10, %rdx
	movzbq	80(%rax,%rsi), %r10
	orq 	%rdx, %r10
	cmpq	%r12, %r10
	jb  	.L__verify_internal$237
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	cmpq	$80, %r10
	jnbe	.L__verify_internal$239
	movq	$-1, %rbx
	cmovnbe	%rbx, %rdx
	movq	%r12, %rbx
	jmp 	.L__verify_internal$241
.L__verify_internal$242:
	movq	$-1, %rbp
	cmovne	%rbp, %rdx
	movzbq	(%rax,%rbx), %rbp
	orq 	%rdx, %rbp
	cmpq	%r12, %rbx
	jnbe	.L__verify_internal$245
	movq	$-1, %r13
	cmovnbe	%r13, %rdx
	jmp 	.L__verify_internal$246
.L__verify_internal$245:
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	movzbq	-1(%rax,%rbx), %r13
	orq 	%rdx, %r13
	cmpq	%r13, %rbp
	jbe 	.L__verify_internal$247
	movq	$-1, %r13
	cmovbe	%r13, %rdx
	jmp 	.L__verify_internal$246
.L__verify_internal$247:
	movq	$-1, %r11
	cmovnbe	%r11, %rdx
	movq	$1, %r11
.L__verify_internal$248:
.L__verify_internal$246:
	cmpq	$0, %r11
	je  	.L__verify_internal$243
	movq	$-1, %rbp
	cmove	%rbp, %rdx
	jmp 	.L__verify_internal$241
.L__verify_internal$243:
	movq	$-1, %r13
	cmovne	%r13, %rdx
	movq	%r9, %r13
	addq	%rbp, %r13
	movl	$1, (%rcx,%r13,4)
	incq	%rbx
.L__verify_internal$244:
.L__verify_internal$241:
	cmpq	%r10, %rbx
	setnb	%bpl
	orb 	%r11b, %bpl
	cmpb	$0, %bpl
	je  	.L__verify_internal$242
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$238
.L__verify_internal$239:
	movq	$-1, %r9
	cmovbe	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$240:
	jmp 	.L__verify_internal$238
.L__verify_internal$237:
	movq	$-1, %r9
	cmovnb	%r9, %rdx
	movq	$1, %r11
.L__verify_internal$238:
	cmpq	$0, %r11
	je  	.L__verify_internal$235
	movq	$-1, %r9
	cmove	%r9, %rdx
	jmp 	.L__verify_internal$233
.L__verify_internal$235:
	movq	$-1, %r9
	cmovne	%r9, %rdx
	movq	%r10, %r12
	incq	%rsi
.L__verify_internal$236:
.L__verify_internal$233:
	cmpq	$4, %rsi
	setnb	%r9b
	orb 	%r11b, %r9b
	cmpb	$0, %r9b
	je  	.L__verify_internal$234
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$227
.L__verify_internal$228:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	movzbq	(%rax,%r12), %rcx
	orq 	%rdx, %rcx
	cmpq	$0, %rcx
	jne 	.L__verify_internal$231
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	jmp 	.L__verify_internal$232
.L__verify_internal$231:
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	movq	$1, %r11
.L__verify_internal$232:
	cmpq	$0, %r11
	je  	.L__verify_internal$229
	movq	$-1, %rcx
	cmove	%rcx, %rdx
	jmp 	.L__verify_internal$227
.L__verify_internal$229:
	movq	$-1, %rcx
	cmovne	%rcx, %rdx
	incq	%r12
.L__verify_internal$230:
.L__verify_internal$227:
	cmpq	$80, %r12
	setnb	%cl
	orb 	%r11b, %cl
	cmpb	$0, %cl
	je  	.L__verify_internal$228
	negq	%r11
	leaq	12768(%rsp), %rax
	movq	$0, %rcx
	movq	%rax, %r10
	movq	$130993, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$225
.L__verify_internal$226:
	vmovdqu	(%r10,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$225:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$226
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	1024(%rax), %r10
	movq	$130993, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$223
.L__verify_internal$224:
	vmovdqu	(%r10,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$223:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$224
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	2048(%rax), %r10
	movq	$130993, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$221
.L__verify_internal$222:
	vmovdqu	(%r10,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$221:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$222
	vptest	%ymm1, %ymm1
	setne	%dl
	movzbq	%dl, %rdx
	orq 	%rdx, %rcx
	leaq	3072(%rax), %rax
	movq	$130993, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	movq	$0, %rdx
	jmp 	.L__verify_internal$219
.L__verify_internal$220:
	vmovdqu	(%rax,%rdx), %ymm2
	vpabsd	%ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm2
	vpor	%ymm2, %ymm1, %ymm1
	addq	$32, %rdx
.L__verify_internal$219:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$220
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
	movq	%r8, 37392(%rsp)
	movq	%rdi, 37400(%rsp)
	vmovdqu	(%rdi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 37408(%rsp)
	movw	$1, 37410(%rsp)
	movw	$2, 37412(%rsp)
	movw	$3, 37414(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	37408(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$218:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$217:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$216:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$215:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$214:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$213:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	20960(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$212:
	movq	%rdi, %rbx
	leaq	21984(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$211:
	movq	%rdi, %rbp
	leaq	23008(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$210:
	movq	%rdi, %r12
	leaq	24032(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$209:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$202
	cmpq	$256, %rbp
	jb  	.L__verify_internal$204
	cmpq	$256, %r12
	jb  	.L__verify_internal$206
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$188
	movl	$0, %ecx
.L__verify_internal$208:
	jmp 	.L__verify_internal$188
.L__verify_internal$206:
	movl	$0, %ecx
.L__verify_internal$207:
	jmp 	.L__verify_internal$188
.L__verify_internal$204:
	movl	$0, %ecx
.L__verify_internal$205:
	jmp 	.L__verify_internal$188
.L__verify_internal$202:
	movl	$0, %ecx
.L__verify_internal$203:
	jmp 	.L__verify_internal$188
.L__verify_internal$189:
	movq	%rbx, 37416(%rsp)
	movq	%rbp, 37424(%rsp)
	movq	%r12, 37432(%rsp)
	movq	%rdi, 37440(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$201:
	movq	37416(%rsp), %rax
	movq	37424(%rsp), %rbp
	movq	37432(%rsp), %r12
	movq	37440(%rsp), %r11
	leaq	20960(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$200:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	21984(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$199:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	23008(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$198:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	24032(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$197:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$190
	cmpq	$256, %rbp
	jb  	.L__verify_internal$192
	cmpq	$256, %r12
	jb  	.L__verify_internal$194
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$188
	movl	$0, %ecx
.L__verify_internal$196:
	jmp 	.L__verify_internal$188
.L__verify_internal$194:
	movl	$0, %ecx
.L__verify_internal$195:
	jmp 	.L__verify_internal$188
.L__verify_internal$192:
	movl	$0, %ecx
.L__verify_internal$193:
	jmp 	.L__verify_internal$188
.L__verify_internal$190:
	movl	$0, %ecx
.L__verify_internal$191:
.L__verify_internal$188:
	cmpl	$1, %ecx
	jne 	.L__verify_internal$189
	movw	$256, 37408(%rsp)
	movw	$257, 37410(%rsp)
	movw	$258, 37412(%rsp)
	movw	$259, 37414(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	37408(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$187:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$186:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$185:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$184:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$183:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$182:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	25056(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$181:
	movq	%rdi, %rbx
	leaq	26080(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$180:
	movq	%rdi, %rbp
	leaq	27104(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$179:
	movq	%rdi, %r12
	leaq	28128(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$178:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$171
	cmpq	$256, %rbp
	jb  	.L__verify_internal$173
	cmpq	$256, %r12
	jb  	.L__verify_internal$175
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$157
	movl	$0, %ecx
.L__verify_internal$177:
	jmp 	.L__verify_internal$157
.L__verify_internal$175:
	movl	$0, %ecx
.L__verify_internal$176:
	jmp 	.L__verify_internal$157
.L__verify_internal$173:
	movl	$0, %ecx
.L__verify_internal$174:
	jmp 	.L__verify_internal$157
.L__verify_internal$171:
	movl	$0, %ecx
.L__verify_internal$172:
	jmp 	.L__verify_internal$157
.L__verify_internal$158:
	movq	%rbx, 37440(%rsp)
	movq	%rbp, 37432(%rsp)
	movq	%r12, 37424(%rsp)
	movq	%rdi, 37416(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$170:
	movq	37440(%rsp), %rax
	movq	37432(%rsp), %rbp
	movq	37424(%rsp), %r12
	movq	37416(%rsp), %r11
	leaq	25056(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$169:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	26080(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$168:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	27104(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$167:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	28128(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$166:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$159
	cmpq	$256, %rbp
	jb  	.L__verify_internal$161
	cmpq	$256, %r12
	jb  	.L__verify_internal$163
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$157
	movl	$0, %ecx
.L__verify_internal$165:
	jmp 	.L__verify_internal$157
.L__verify_internal$163:
	movl	$0, %ecx
.L__verify_internal$164:
	jmp 	.L__verify_internal$157
.L__verify_internal$161:
	movl	$0, %ecx
.L__verify_internal$162:
	jmp 	.L__verify_internal$157
.L__verify_internal$159:
	movl	$0, %ecx
.L__verify_internal$160:
.L__verify_internal$157:
	cmpl	$1, %ecx
	jne 	.L__verify_internal$158
	movw	$512, 37408(%rsp)
	movw	$513, 37410(%rsp)
	movw	$514, 37412(%rsp)
	movw	$515, 37414(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	37408(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$156:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$155:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$154:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$153:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$152:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$151:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	29152(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$150:
	movq	%rdi, %rbx
	leaq	30176(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$149:
	movq	%rdi, %rbp
	leaq	31200(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$148:
	movq	%rdi, %r12
	leaq	32224(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$147:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$140
	cmpq	$256, %rbp
	jb  	.L__verify_internal$142
	cmpq	$256, %r12
	jb  	.L__verify_internal$144
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$126
	movl	$0, %ecx
.L__verify_internal$146:
	jmp 	.L__verify_internal$126
.L__verify_internal$144:
	movl	$0, %ecx
.L__verify_internal$145:
	jmp 	.L__verify_internal$126
.L__verify_internal$142:
	movl	$0, %ecx
.L__verify_internal$143:
	jmp 	.L__verify_internal$126
.L__verify_internal$140:
	movl	$0, %ecx
.L__verify_internal$141:
	jmp 	.L__verify_internal$126
.L__verify_internal$127:
	movq	%rbx, 37416(%rsp)
	movq	%rbp, 37424(%rsp)
	movq	%r12, 37432(%rsp)
	movq	%rdi, 37440(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$139:
	movq	37416(%rsp), %rax
	movq	37424(%rsp), %rbp
	movq	37432(%rsp), %r12
	movq	37440(%rsp), %r11
	leaq	29152(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$138:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	30176(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$137:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	31200(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$136:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	32224(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$135:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$128
	cmpq	$256, %rbp
	jb  	.L__verify_internal$130
	cmpq	$256, %r12
	jb  	.L__verify_internal$132
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$126
	movl	$0, %ecx
.L__verify_internal$134:
	jmp 	.L__verify_internal$126
.L__verify_internal$132:
	movl	$0, %ecx
.L__verify_internal$133:
	jmp 	.L__verify_internal$126
.L__verify_internal$130:
	movl	$0, %ecx
.L__verify_internal$131:
	jmp 	.L__verify_internal$126
.L__verify_internal$128:
	movl	$0, %ecx
.L__verify_internal$129:
.L__verify_internal$126:
	cmpl	$1, %ecx
	jne 	.L__verify_internal$127
	movw	$768, 37408(%rsp)
	movw	$769, 37410(%rsp)
	movw	$770, 37412(%rsp)
	movw	$771, 37414(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	37408(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__verify_internal$125:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$124:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$123:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$122:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$121:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$120:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	33248(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$119:
	movq	%rdi, %rbx
	leaq	34272(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$118:
	movq	%rdi, %rbp
	leaq	35296(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$117:
	movq	%rdi, %r12
	leaq	36320(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__verify_internal$116:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$109
	cmpq	$256, %rbp
	jb  	.L__verify_internal$111
	cmpq	$256, %r12
	jb  	.L__verify_internal$113
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$95
	movl	$0, %ecx
.L__verify_internal$115:
	jmp 	.L__verify_internal$95
.L__verify_internal$113:
	movl	$0, %ecx
.L__verify_internal$114:
	jmp 	.L__verify_internal$95
.L__verify_internal$111:
	movl	$0, %ecx
.L__verify_internal$112:
	jmp 	.L__verify_internal$95
.L__verify_internal$109:
	movl	$0, %ecx
.L__verify_internal$110:
	jmp 	.L__verify_internal$95
.L__verify_internal$96:
	movq	%rbx, 37408(%rsp)
	movq	%rbp, 37440(%rsp)
	movq	%r12, 37432(%rsp)
	movq	%rdi, 37424(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__verify_internal$108:
	movq	37408(%rsp), %rax
	movq	37440(%rsp), %rbp
	movq	37432(%rsp), %r12
	movq	37424(%rsp), %r11
	leaq	33248(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$107:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	34272(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$106:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	35296(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$105:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	36320(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__verify_internal$104:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__verify_internal$97
	cmpq	$256, %rbp
	jb  	.L__verify_internal$99
	cmpq	$256, %r12
	jb  	.L__verify_internal$101
	cmpq	$256, %rdi
	jnb 	.L__verify_internal$95
	movl	$0, %ecx
.L__verify_internal$103:
	jmp 	.L__verify_internal$95
.L__verify_internal$101:
	movl	$0, %ecx
.L__verify_internal$102:
	jmp 	.L__verify_internal$95
.L__verify_internal$99:
	movl	$0, %ecx
.L__verify_internal$100:
	jmp 	.L__verify_internal$95
.L__verify_internal$97:
	movl	$0, %ecx
.L__verify_internal$98:
.L__verify_internal$95:
	cmpl	$1, %ecx
	jne 	.L__verify_internal$96
	leaq	12768(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__verify_internal$94:
	leaq	20960(%rsp), %rax
	leaq	12768(%rsp), %rcx
	leaq	16864(%rsp), %rdx
	movq	%rax, %rsi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$92
.L__verify_internal$93:
	vmovdqu	(%rsi,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rsi,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rsi,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rsi,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
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
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$92:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$93
	leaq	17888(%rsp), %rdx
	leaq	4096(%rax), %rsi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$90
.L__verify_internal$91:
	vmovdqu	(%rsi,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rsi,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rsi,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rsi,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
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
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$90:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$91
	leaq	18912(%rsp), %rdx
	leaq	8192(%rax), %rsi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$88
.L__verify_internal$89:
	vmovdqu	(%rsi,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rsi,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rsi,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rsi,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
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
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$88:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$89
	leaq	19936(%rsp), %rdx
	leaq	12288(%rax), %rsi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__verify_internal$86
.L__verify_internal$87:
	vmovdqu	(%rsi,%r8), %ymm2
	vmovdqu	(%rcx,%r8), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%rsi,%r8), %ymm4
	vmovdqu	1024(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rsi,%r8), %ymm4
	vmovdqu	2048(%rcx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rsi,%r8), %ymm4
	vmovdqu	3072(%rcx,%r8), %ymm5
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
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__verify_internal$86:
	cmpq	$1024, %r8
	jb  	.L__verify_internal$87
	movq	37392(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	5600(%rsp), %rax
	movq	%r8, %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__verify_internal$84
.L__verify_internal$85:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__verify_internal$84:
	cmpq	$1024, %rsi
	jb  	.L__verify_internal$85
	movq	%rax, 37424(%rsp)
	leaq	352(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__verify_internal$83:
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__verify_internal$82:
	movq	37424(%rsp), %rcx
	movq	192(%rsp), %rdx
	movq	$8, %rdi
	lfence
	movq	$0, %r9
	movq	$217, %rsi
	jmp 	.L__verify_internal$75
.L__verify_internal$76:
	movq	$-1, %rax
	cmovnb	%rax, %r9
	jmp 	.L__verify_internal$77
.L__verify_internal$78:
	movq	$-1, %rax
	cmovbe	%rax, %r9
.L__verify_internal$77:
	cmpq	$136, %rdi
	jnb 	.L__verify_internal$79
	movq	$-1, %rax
	cmovnb	%rax, %r9
	jmp 	.L__verify_internal$80
.L__verify_internal$79:
	movq	%rsi, 37424(%rsp)
	movq	%rdx, 37432(%rsp)
	movq	%rcx, 37440(%rsp)
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__verify_internal$81:
	movq	37424(%rsp), %rsi
	movq	37432(%rsp), %rdx
	movq	37440(%rsp), %rcx
	movq	$0, %rdi
	lfence
	movq	$0, %r9
.L__verify_internal$80:
	movzbq	192(%rsp,%rdi), %rax
// declassify_val u64 %rax
	orq 	%r9, %rax
	incq	%rdi
	cmpq	%rsi, %rax
	jnbe	.L__verify_internal$78
	movq	$-1, %r8
	cmovnbe	%r8, %r9
	movl	(%rcx,%rax,4), %r8d
	movl	%r8d, (%rcx,%rsi,4)
	movl	%edx, %r8d
	andl	$1, %r8d
	shll	$1, %r8d
	movl	$1, %r10d
	subl	%r8d, %r10d
	movl	%r10d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__verify_internal$75:
	cmpq	$256, %rsi
	jb  	.L__verify_internal$76
	leaq	5600(%rsp), %r10
	call	.Lpolynomial__ntt$1
.L__verify_internal$74:
	movq	37400(%rsp), %rdi
	lfence
	movq	$0, %rax
	leaq	32(%rdi), %rax
	leaq	5600(%rsp), %rcx
	movq	%rcx, %mm0
	leaq	7648(%rsp), %rdi
	movq	%rax, %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$73:
	leaq	7648(%rsp), %r10
	movq	$0, %rdx
	jmp 	.L__verify_internal$71
.L__verify_internal$72:
	vmovdqu	(%r10,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%rdx)
	addq	$32, %rdx
.L__verify_internal$71:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$72
	leaq	7648(%rsp), %r10
	call	.Lpolynomial__ntt$1
.L__verify_internal$70:
	movq	%mm0, %rcx
	leaq	6624(%rsp), %r10
	leaq	7648(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$69:
	leaq	12768(%rsp), %rcx
	leaq	16864(%rsp), %rdx
	leaq	6624(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$68:
	leaq	12768(%rsp), %r8
	call	.Lpolynomial__reduce32$1
.L__verify_internal$67:
	leaq	12768(%rsp), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$66:
	leaq	12768(%rsp), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$65:
	leaq	12768(%rsp), %r8
	leaq	8672(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_88$1
.L__verify_internal$64:
	leaq	2072(%rsp), %rsp
	leaq	7648(%rsp), %rdi
	leaq	320(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$63:
	leaq	7648(%rsp), %r10
	movq	$0, %rdx
	jmp 	.L__verify_internal$61
.L__verify_internal$62:
	vmovdqu	(%r10,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%rdx)
	addq	$32, %rdx
.L__verify_internal$61:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$62
	leaq	7648(%rsp), %r10
	call	.Lpolynomial__ntt$1
.L__verify_internal$60:
	movq	%mm0, %rcx
	leaq	6624(%rsp), %r10
	leaq	7648(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$59:
	leaq	13792(%rsp), %rcx
	leaq	17888(%rsp), %rdx
	leaq	6624(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$58:
	leaq	13792(%rsp), %r8
	call	.Lpolynomial__reduce32$1
.L__verify_internal$57:
	leaq	13792(%rsp), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$56:
	leaq	13792(%rsp), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$55:
	leaq	13792(%rsp), %r8
	leaq	9696(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_88$1
.L__verify_internal$54:
	leaq	2072(%rsp), %rsp
	leaq	7648(%rsp), %rdi
	leaq	640(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$53:
	leaq	7648(%rsp), %r10
	movq	$0, %rdx
	jmp 	.L__verify_internal$51
.L__verify_internal$52:
	vmovdqu	(%r10,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r10,%rdx)
	addq	$32, %rdx
.L__verify_internal$51:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$52
	leaq	7648(%rsp), %r10
	call	.Lpolynomial__ntt$1
.L__verify_internal$50:
	movq	%mm0, %rcx
	leaq	6624(%rsp), %r10
	leaq	7648(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$49:
	leaq	14816(%rsp), %rcx
	leaq	18912(%rsp), %rdx
	leaq	6624(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$48:
	leaq	14816(%rsp), %r8
	call	.Lpolynomial__reduce32$1
.L__verify_internal$47:
	leaq	14816(%rsp), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$46:
	leaq	14816(%rsp), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$45:
	leaq	14816(%rsp), %r8
	leaq	10720(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_88$1
.L__verify_internal$44:
	leaq	2072(%rsp), %rsp
	leaq	7648(%rsp), %rdi
	leaq	960(%rax), %rcx
	call	.Lt1__decode_polynomial$1
.L__verify_internal$43:
	leaq	7648(%rsp), %rax
	movq	$0, %rdx
	jmp 	.L__verify_internal$41
.L__verify_internal$42:
	vmovdqu	(%rax,%rdx), %ymm2
	vpslld	$13, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rax,%rdx)
	addq	$32, %rdx
.L__verify_internal$41:
	cmpq	$1024, %rdx
	jb  	.L__verify_internal$42
	leaq	7648(%rsp), %r10
	call	.Lpolynomial__ntt$1
.L__verify_internal$40:
	movq	%mm0, %rcx
	leaq	6624(%rsp), %r10
	leaq	7648(%rsp), %rdx
	call	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$1
.L__verify_internal$39:
	leaq	15840(%rsp), %rcx
	leaq	19936(%rsp), %rdx
	leaq	6624(%rsp), %r10
	call	.Lpolynomial__subtract$1
.L__verify_internal$38:
	leaq	15840(%rsp), %r8
	call	.Lpolynomial__reduce32$1
.L__verify_internal$37:
	leaq	15840(%rsp), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.L__verify_internal$36:
	leaq	15840(%rsp), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__verify_internal$35:
	leaq	15840(%rsp), %r8
	leaq	11744(%rsp), %rcx
	leaq	-2072(%rsp), %rsp
	call	.Lpolynomial__use_hints_gamma2_88$1
.L__verify_internal$34:
	leaq	2072(%rsp), %rsp
	leaq	12768(%rsp), %rax
	leaq	576(%rsp), %rdx
	movq	%rax, %rcx
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__verify_internal$31
.L__verify_internal$32:
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$33:
	vmovdqu	%xmm1, (%rdx,%rsi)
	vmovdqu	%xmm0, 12(%rdx,%rsi)
	addq	$24, %rsi
.L__verify_internal$31:
	cmpq	$168, %rsi
	jb  	.L__verify_internal$32
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$30:
	vmovdqu	%xmm1, (%rdx,%rsi)
	addq	$12, %rsi
	vmovdqu	%xmm0, 37344(%rsp)
	movq	$0, %r8
	jmp 	.L__verify_internal$28
.L__verify_internal$29:
	movb	37344(%rsp,%r8), %cl
	movb	%cl, (%rdx,%rsi)
	incq	%rsi
	incq	%r8
.L__verify_internal$28:
	cmpq	$12, %r8
	jb  	.L__verify_internal$29
	leaq	768(%rsp), %rdx
	leaq	1024(%rax), %rcx
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__verify_internal$25
.L__verify_internal$26:
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$27:
	vmovdqu	%xmm1, (%rdx,%rsi)
	vmovdqu	%xmm0, 12(%rdx,%rsi)
	addq	$24, %rsi
.L__verify_internal$25:
	cmpq	$168, %rsi
	jb  	.L__verify_internal$26
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$24:
	vmovdqu	%xmm1, (%rdx,%rsi)
	addq	$12, %rsi
	vmovdqu	%xmm0, 37344(%rsp)
	movq	$0, %r8
	jmp 	.L__verify_internal$22
.L__verify_internal$23:
	movb	37344(%rsp,%r8), %cl
	movb	%cl, (%rdx,%rsi)
	incq	%rsi
	incq	%r8
.L__verify_internal$22:
	cmpq	$12, %r8
	jb  	.L__verify_internal$23
	leaq	960(%rsp), %rdx
	leaq	2048(%rax), %rcx
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__verify_internal$19
.L__verify_internal$20:
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$21:
	vmovdqu	%xmm1, (%rdx,%rsi)
	vmovdqu	%xmm0, 12(%rdx,%rsi)
	addq	$24, %rsi
.L__verify_internal$19:
	cmpq	$168, %rsi
	jb  	.L__verify_internal$20
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$18:
	vmovdqu	%xmm1, (%rdx,%rsi)
	addq	$12, %rsi
	vmovdqu	%xmm0, 37344(%rsp)
	movq	$0, %r8
	jmp 	.L__verify_internal$16
.L__verify_internal$17:
	movb	37344(%rsp,%r8), %cl
	movb	%cl, (%rdx,%rsi)
	incq	%rsi
	incq	%r8
.L__verify_internal$16:
	cmpq	$12, %r8
	jb  	.L__verify_internal$17
	leaq	1152(%rsp), %rdx
	leaq	3072(%rax), %rcx
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__verify_internal$13
.L__verify_internal$14:
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$15:
	vmovdqu	%xmm1, (%rdx,%rsi)
	vmovdqu	%xmm0, 12(%rdx,%rsi)
	addq	$24, %rsi
.L__verify_internal$13:
	cmpq	$168, %rsi
	jb  	.L__verify_internal$14
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__verify_internal$12:
	vmovdqu	%xmm1, (%rdx,%rsi)
	addq	$12, %rsi
	vmovdqu	%xmm0, 37344(%rsp)
	movq	$0, %r8
	jmp 	.L__verify_internal$10
.L__verify_internal$11:
	movb	37344(%rsp,%r8), %cl
	movb	%cl, (%rdx,%rsi)
	incq	%rsi
	incq	%r8
.L__verify_internal$10:
	cmpq	$12, %r8
	jb  	.L__verify_internal$11
	movq	37400(%rsp), %rcx
	lfence
	movq	$0, %rax
	leaq	64(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__verify_internal$9:
	leaq	248(%rsp), %rsp
	movq	37360(%rsp), %rcx
	movq	37368(%rsp), %rdx
	movq	37376(%rsp), %rdi
	movq	37384(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	128(%rsp), %rax
	leaq	64(%rsp), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__verify_internal$8:
	leaq	344(%rsp), %rsp
	leaq	32(%rsp), %rax
	leaq	128(%rsp), %rcx
	leaq	576(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__verify_internal$7:
	leaq	248(%rsp), %rsp
	movq	37392(%rsp), %r8
	lfence
	movq	$0, %rax
	leaq	32(%rsp), %rcx
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
	cmpq	$32, %rdx
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
	movq	%rdi, 80112(%rsp)
	movq	%r9, 80120(%rsp)
	movq	%rsi, 80128(%rsp)
	movq	%rax, 80136(%rsp)
	movq	%rdx, 80144(%rsp)
	movq	%rcx, 80152(%rsp)
	movq	%r8, 80160(%rsp)
// declassify_mem 32 [RSI]
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 80168(%rsp)
	movw	$1, 80170(%rsp)
	movw	$2, 80172(%rsp)
	movw	$3, 80174(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4160(%rsp), %rax
	leaq	80168(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$308:
	leaq	40(%rsp), %rsp
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$307:
	leaq	4160(%rsp), %rax
	leaq	7720(%rsp), %rcx
	leaq	6856(%rsp), %rdx
	leaq	5992(%rsp), %rsi
	leaq	5128(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$306:
	leaq	4160(%rsp), %rax
	leaq	7888(%rsp), %rcx
	leaq	7024(%rsp), %rdx
	leaq	6160(%rsp), %rsi
	leaq	5296(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$305:
	leaq	4160(%rsp), %rax
	leaq	8056(%rsp), %rcx
	leaq	7192(%rsp), %rdx
	leaq	6328(%rsp), %rsi
	leaq	5464(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$304:
	leaq	4160(%rsp), %rax
	leaq	8224(%rsp), %rcx
	leaq	7360(%rsp), %rdx
	leaq	6496(%rsp), %rsi
	leaq	5632(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$303:
	movq	$0, %rax
	movq	%rax, 8392(%rsp)
	movq	%rax, 7528(%rsp)
	movq	%rax, 6664(%rsp)
	movq	%rax, 5800(%rsp)
	leaq	63712(%rsp), %rax
	leaq	7552(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$302:
	movq	%rdi, %rbx
	leaq	64736(%rsp), %rax
	leaq	6688(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$301:
	movq	%rdi, %rbp
	leaq	65760(%rsp), %rax
	leaq	5824(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$300:
	movq	%rdi, %r12
	leaq	66784(%rsp), %rax
	leaq	4960(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$299:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$292
	cmpq	$256, %rbp
	jb  	.L__sign_internal$294
	cmpq	$256, %r12
	jb  	.L__sign_internal$296
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$278
	movl	$0, %ecx
.L__sign_internal$298:
	jmp 	.L__sign_internal$278
.L__sign_internal$296:
	movl	$0, %ecx
.L__sign_internal$297:
	jmp 	.L__sign_internal$278
.L__sign_internal$294:
	movl	$0, %ecx
.L__sign_internal$295:
	jmp 	.L__sign_internal$278
.L__sign_internal$292:
	movl	$0, %ecx
.L__sign_internal$293:
	jmp 	.L__sign_internal$278
.L__sign_internal$279:
	movq	%rbx, 80176(%rsp)
	movq	%rbp, 80184(%rsp)
	movq	%r12, 80192(%rsp)
	movq	%rdi, 80200(%rsp)
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$291:
	movq	80176(%rsp), %rax
	movq	80184(%rsp), %rbp
	movq	80192(%rsp), %r12
	movq	80200(%rsp), %r11
	leaq	63712(%rsp), %r10
	leaq	7552(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$290:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	64736(%rsp), %r10
	leaq	6688(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$289:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	65760(%rsp), %r10
	leaq	5824(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$288:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	66784(%rsp), %r10
	leaq	4960(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$287:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$280
	cmpq	$256, %rbp
	jb  	.L__sign_internal$282
	cmpq	$256, %r12
	jb  	.L__sign_internal$284
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$278
	movl	$0, %ecx
.L__sign_internal$286:
	jmp 	.L__sign_internal$278
.L__sign_internal$284:
	movl	$0, %ecx
.L__sign_internal$285:
	jmp 	.L__sign_internal$278
.L__sign_internal$282:
	movl	$0, %ecx
.L__sign_internal$283:
	jmp 	.L__sign_internal$278
.L__sign_internal$280:
	movl	$0, %ecx
.L__sign_internal$281:
.L__sign_internal$278:
	cmpl	$1, %ecx
	jne 	.L__sign_internal$279
	movw	$256, 80168(%rsp)
	movw	$257, 80170(%rsp)
	movw	$258, 80172(%rsp)
	movw	$259, 80174(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4160(%rsp), %rax
	leaq	80168(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$277:
	leaq	40(%rsp), %rsp
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$276:
	leaq	4160(%rsp), %rax
	leaq	7720(%rsp), %rcx
	leaq	6856(%rsp), %rdx
	leaq	5992(%rsp), %rsi
	leaq	5128(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$275:
	leaq	4160(%rsp), %rax
	leaq	7888(%rsp), %rcx
	leaq	7024(%rsp), %rdx
	leaq	6160(%rsp), %rsi
	leaq	5296(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$274:
	leaq	4160(%rsp), %rax
	leaq	8056(%rsp), %rcx
	leaq	7192(%rsp), %rdx
	leaq	6328(%rsp), %rsi
	leaq	5464(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$273:
	leaq	4160(%rsp), %rax
	leaq	8224(%rsp), %rcx
	leaq	7360(%rsp), %rdx
	leaq	6496(%rsp), %rsi
	leaq	5632(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$272:
	movq	$0, %rax
	movq	%rax, 8392(%rsp)
	movq	%rax, 7528(%rsp)
	movq	%rax, 6664(%rsp)
	movq	%rax, 5800(%rsp)
	leaq	67808(%rsp), %rax
	leaq	7552(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$271:
	movq	%rdi, %rbx
	leaq	68832(%rsp), %rax
	leaq	6688(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$270:
	movq	%rdi, %rbp
	leaq	69856(%rsp), %rax
	leaq	5824(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$269:
	movq	%rdi, %r12
	leaq	70880(%rsp), %rax
	leaq	4960(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$268:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$261
	cmpq	$256, %rbp
	jb  	.L__sign_internal$263
	cmpq	$256, %r12
	jb  	.L__sign_internal$265
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$247
	movl	$0, %ecx
.L__sign_internal$267:
	jmp 	.L__sign_internal$247
.L__sign_internal$265:
	movl	$0, %ecx
.L__sign_internal$266:
	jmp 	.L__sign_internal$247
.L__sign_internal$263:
	movl	$0, %ecx
.L__sign_internal$264:
	jmp 	.L__sign_internal$247
.L__sign_internal$261:
	movl	$0, %ecx
.L__sign_internal$262:
	jmp 	.L__sign_internal$247
.L__sign_internal$248:
	movq	%rbx, 80200(%rsp)
	movq	%rbp, 80192(%rsp)
	movq	%r12, 80184(%rsp)
	movq	%rdi, 80176(%rsp)
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$260:
	movq	80200(%rsp), %rax
	movq	80192(%rsp), %rbp
	movq	80184(%rsp), %r12
	movq	80176(%rsp), %r11
	leaq	67808(%rsp), %r10
	leaq	7552(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$259:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	68832(%rsp), %r10
	leaq	6688(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$258:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	69856(%rsp), %r10
	leaq	5824(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$257:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	70880(%rsp), %r10
	leaq	4960(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$256:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$249
	cmpq	$256, %rbp
	jb  	.L__sign_internal$251
	cmpq	$256, %r12
	jb  	.L__sign_internal$253
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$247
	movl	$0, %ecx
.L__sign_internal$255:
	jmp 	.L__sign_internal$247
.L__sign_internal$253:
	movl	$0, %ecx
.L__sign_internal$254:
	jmp 	.L__sign_internal$247
.L__sign_internal$251:
	movl	$0, %ecx
.L__sign_internal$252:
	jmp 	.L__sign_internal$247
.L__sign_internal$249:
	movl	$0, %ecx
.L__sign_internal$250:
.L__sign_internal$247:
	cmpl	$1, %ecx
	jne 	.L__sign_internal$248
	movw	$512, 80168(%rsp)
	movw	$513, 80170(%rsp)
	movw	$514, 80172(%rsp)
	movw	$515, 80174(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4160(%rsp), %rax
	leaq	80168(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$246:
	leaq	40(%rsp), %rsp
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$245:
	leaq	4160(%rsp), %rax
	leaq	7720(%rsp), %rcx
	leaq	6856(%rsp), %rdx
	leaq	5992(%rsp), %rsi
	leaq	5128(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$244:
	leaq	4160(%rsp), %rax
	leaq	7888(%rsp), %rcx
	leaq	7024(%rsp), %rdx
	leaq	6160(%rsp), %rsi
	leaq	5296(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$243:
	leaq	4160(%rsp), %rax
	leaq	8056(%rsp), %rcx
	leaq	7192(%rsp), %rdx
	leaq	6328(%rsp), %rsi
	leaq	5464(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$242:
	leaq	4160(%rsp), %rax
	leaq	8224(%rsp), %rcx
	leaq	7360(%rsp), %rdx
	leaq	6496(%rsp), %rsi
	leaq	5632(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$241:
	movq	$0, %rax
	movq	%rax, 8392(%rsp)
	movq	%rax, 7528(%rsp)
	movq	%rax, 6664(%rsp)
	movq	%rax, 5800(%rsp)
	leaq	71904(%rsp), %rax
	leaq	7552(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$240:
	movq	%rdi, %rbx
	leaq	72928(%rsp), %rax
	leaq	6688(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$239:
	movq	%rdi, %rbp
	leaq	73952(%rsp), %rax
	leaq	5824(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$238:
	movq	%rdi, %r12
	leaq	74976(%rsp), %rax
	leaq	4960(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$237:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$230
	cmpq	$256, %rbp
	jb  	.L__sign_internal$232
	cmpq	$256, %r12
	jb  	.L__sign_internal$234
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$216
	movl	$0, %ecx
.L__sign_internal$236:
	jmp 	.L__sign_internal$216
.L__sign_internal$234:
	movl	$0, %ecx
.L__sign_internal$235:
	jmp 	.L__sign_internal$216
.L__sign_internal$232:
	movl	$0, %ecx
.L__sign_internal$233:
	jmp 	.L__sign_internal$216
.L__sign_internal$230:
	movl	$0, %ecx
.L__sign_internal$231:
	jmp 	.L__sign_internal$216
.L__sign_internal$217:
	movq	%rbx, 80176(%rsp)
	movq	%rbp, 80184(%rsp)
	movq	%r12, 80192(%rsp)
	movq	%rdi, 80200(%rsp)
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$229:
	movq	80176(%rsp), %rax
	movq	80184(%rsp), %rbp
	movq	80192(%rsp), %r12
	movq	80200(%rsp), %r11
	leaq	71904(%rsp), %r10
	leaq	7552(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$228:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	72928(%rsp), %r10
	leaq	6688(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$227:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	73952(%rsp), %r10
	leaq	5824(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$226:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	74976(%rsp), %r10
	leaq	4960(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$225:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$218
	cmpq	$256, %rbp
	jb  	.L__sign_internal$220
	cmpq	$256, %r12
	jb  	.L__sign_internal$222
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$216
	movl	$0, %ecx
.L__sign_internal$224:
	jmp 	.L__sign_internal$216
.L__sign_internal$222:
	movl	$0, %ecx
.L__sign_internal$223:
	jmp 	.L__sign_internal$216
.L__sign_internal$220:
	movl	$0, %ecx
.L__sign_internal$221:
	jmp 	.L__sign_internal$216
.L__sign_internal$218:
	movl	$0, %ecx
.L__sign_internal$219:
.L__sign_internal$216:
	cmpl	$1, %ecx
	jne 	.L__sign_internal$217
	movw	$768, 80168(%rsp)
	movw	$769, 80170(%rsp)
	movw	$770, 80172(%rsp)
	movw	$771, 80174(%rsp)
	leaq	32(%rsp), %rsi
	leaq	4160(%rsp), %rax
	leaq	80168(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__sign_internal$215:
	leaq	40(%rsp), %rsp
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$214:
	leaq	4160(%rsp), %rax
	leaq	7720(%rsp), %rcx
	leaq	6856(%rsp), %rdx
	leaq	5992(%rsp), %rsi
	leaq	5128(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$213:
	leaq	4160(%rsp), %rax
	leaq	7888(%rsp), %rcx
	leaq	7024(%rsp), %rdx
	leaq	6160(%rsp), %rsi
	leaq	5296(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$212:
	leaq	4160(%rsp), %rax
	leaq	8056(%rsp), %rcx
	leaq	7192(%rsp), %rdx
	leaq	6328(%rsp), %rsi
	leaq	5464(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$211:
	leaq	4160(%rsp), %rax
	leaq	8224(%rsp), %rcx
	leaq	7360(%rsp), %rdx
	leaq	6496(%rsp), %rsi
	leaq	5632(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$210:
	movq	$0, %rax
	movq	%rax, 8392(%rsp)
	movq	%rax, 7528(%rsp)
	movq	%rax, 6664(%rsp)
	movq	%rax, 5800(%rsp)
	leaq	76000(%rsp), %rax
	leaq	7552(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$209:
	movq	%rdi, %rbx
	leaq	77024(%rsp), %rax
	leaq	6688(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$208:
	movq	%rdi, %rbp
	leaq	78048(%rsp), %rax
	leaq	5824(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$207:
	movq	%rdi, %r12
	leaq	79072(%rsp), %rax
	leaq	4960(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__sign_internal$206:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$199
	cmpq	$256, %rbp
	jb  	.L__sign_internal$201
	cmpq	$256, %r12
	jb  	.L__sign_internal$203
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$185
	movl	$0, %ecx
.L__sign_internal$205:
	jmp 	.L__sign_internal$185
.L__sign_internal$203:
	movl	$0, %ecx
.L__sign_internal$204:
	jmp 	.L__sign_internal$185
.L__sign_internal$201:
	movl	$0, %ecx
.L__sign_internal$202:
	jmp 	.L__sign_internal$185
.L__sign_internal$199:
	movl	$0, %ecx
.L__sign_internal$200:
	jmp 	.L__sign_internal$185
.L__sign_internal$186:
	movq	%rbx, 80168(%rsp)
	movq	%rbp, 80200(%rsp)
	movq	%r12, 80192(%rsp)
	movq	%rdi, 80184(%rsp)
	leaq	4160(%rsp), %rax
	leaq	7552(%rsp), %rcx
	leaq	6688(%rsp), %rdx
	leaq	5824(%rsp), %rsi
	leaq	4960(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__sign_internal$198:
	movq	80168(%rsp), %rax
	movq	80200(%rsp), %rbp
	movq	80192(%rsp), %r12
	movq	80184(%rsp), %r11
	leaq	76000(%rsp), %r10
	leaq	7552(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$197:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	77024(%rsp), %r10
	leaq	6688(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$196:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	78048(%rsp), %r10
	leaq	5824(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$195:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	79072(%rsp), %r10
	leaq	4960(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__sign_internal$194:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__sign_internal$187
	cmpq	$256, %rbp
	jb  	.L__sign_internal$189
	cmpq	$256, %r12
	jb  	.L__sign_internal$191
	cmpq	$256, %rdi
	jnb 	.L__sign_internal$185
	movl	$0, %ecx
.L__sign_internal$193:
	jmp 	.L__sign_internal$185
.L__sign_internal$191:
	movl	$0, %ecx
.L__sign_internal$192:
	jmp 	.L__sign_internal$185
.L__sign_internal$189:
	movl	$0, %ecx
.L__sign_internal$190:
	jmp 	.L__sign_internal$185
.L__sign_internal$187:
	movl	$0, %ecx
.L__sign_internal$188:
.L__sign_internal$185:
	cmpl	$1, %ecx
	jne 	.L__sign_internal$186
	movq	80128(%rsp), %rsi
	movq	80136(%rsp), %rcx
	movq	80144(%rsp), %rdx
	movq	80152(%rsp), %rdi
	movq	80160(%rsp), %r8
	lfence
	movq	$0, %r9
	orq 	%r9, %rsi
	movq	%rsi, 80160(%rsp)
	leaq	64(%rsp), %rax
	leaq	64(%rsi), %rsi
	leaq	-344(%rsp), %rsp
	call	.L__derive_message_representative$1
.L__sign_internal$184:
	leaq	344(%rsp), %rsp
	movq	80120(%rsp), %rdx
	movq	80160(%rsp), %rsi
	lfence
	movq	$0, %r9
	orq 	%r9, %rdx
	orq 	%r9, %rsi
	movq	%rsi, 80160(%rsp)
	leaq	32(%rsi), %rax
	leaq	64(%rsp), %rcx
	leaq	128(%rsp), %rdi
	leaq	-152(%rsp), %rsp
	call	.Lderive_seed_for_mask$1
.L__sign_internal$183:
	leaq	152(%rsp), %rsp
	movq	80160(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rsi
	leaq	10464(%rsp), %rax
	leaq	128(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rax, %r10
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$182:
	movq	%mm0, %rdx
	leaq	1024(%rax), %r10
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$181:
	movq	%mm0, %rdx
	leaq	2048(%rax), %r10
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$180:
	movq	%mm0, %rdx
	leaq	3072(%rax), %r10
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$179:
	leaq	14560(%rsp), %rax
	leaq	512(%rsi), %rdx
	movq	%rdx, %mm0
	movq	%rax, %r10
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$178:
	movq	%mm0, %rdx
	leaq	1024(%rax), %r10
	leaq	96(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$177:
	movq	%mm0, %rdx
	leaq	2048(%rax), %r10
	leaq	192(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$176:
	movq	%mm0, %rdx
	leaq	3072(%rax), %r10
	leaq	288(%rdx), %rdx
	call	.Lerror_polynomial__decode_eta2$1
.L__sign_internal$175:
	leaq	18656(%rsp), %rax
	leaq	896(%rsi), %rdx
	movq	%rax, %rcx
	movq	%rdx, %rsi
	movq	$0, %r11
	movq	$0, %r8
	jmp 	.L__sign_internal$172
.L__sign_internal$173:
	vmovdqu	(%rsi,%r8), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$174:
	vmovdqu	%ymm2, (%rcx,%r11)
	addq	$32, %r11
	addq	$13, %r8
.L__sign_internal$172:
	cmpq	$403, %r8
	jb  	.L__sign_internal$173
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$171:
	vmovdqu	%ymm2, (%rcx,%r11)
	leaq	1024(%rax), %rcx
	leaq	416(%rdx), %rsi
	movq	$0, %r11
	movq	$0, %r8
	jmp 	.L__sign_internal$168
.L__sign_internal$169:
	vmovdqu	(%rsi,%r8), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$170:
	vmovdqu	%ymm2, (%rcx,%r11)
	addq	$32, %r11
	addq	$13, %r8
.L__sign_internal$168:
	cmpq	$403, %r8
	jb  	.L__sign_internal$169
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$167:
	vmovdqu	%ymm2, (%rcx,%r11)
	leaq	2048(%rax), %rcx
	leaq	832(%rdx), %rsi
	movq	$0, %r11
	movq	$0, %r8
	jmp 	.L__sign_internal$164
.L__sign_internal$165:
	vmovdqu	(%rsi,%r8), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$166:
	vmovdqu	%ymm2, (%rcx,%r11)
	addq	$32, %r11
	addq	$13, %r8
.L__sign_internal$164:
	cmpq	$403, %r8
	jb  	.L__sign_internal$165
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$163:
	vmovdqu	%ymm2, (%rcx,%r11)
	leaq	3072(%rax), %rax
	leaq	1248(%rdx), %rsi
	movq	$0, %rcx
	movq	$0, %r8
	jmp 	.L__sign_internal$160
.L__sign_internal$161:
	vmovdqu	(%rsi,%r8), %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$162:
	vmovdqu	%ymm2, (%rax,%rcx)
	addq	$32, %rcx
	addq	$13, %r8
.L__sign_internal$160:
	cmpq	$403, %r8
	jb  	.L__sign_internal$161
	vmovdqu	400(%rsi), %xmm0
	vpsrldq	$3, %xmm0, %xmm0
	call	.Lt0__bytestream_to_coefficients$1
.L__sign_internal$159:
	vmovdqu	%ymm2, (%rax,%rcx)
// declassify_mem 4096 [RSP + 18656]
	leaq	22752(%rsp), %rcx
	leaq	10464(%rsp), %rax
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
	leaq	23776(%rsp), %rcx
	leaq	11488(%rsp), %rax
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
	leaq	24800(%rsp), %rcx
	leaq	12512(%rsp), %rax
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
	leaq	25824(%rsp), %rcx
	leaq	13536(%rsp), %rax
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
	leaq	10464(%rsp), %rcx
	leaq	14560(%rsp), %rax
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
	leaq	55520(%rsp), %rcx
	leaq	18656(%rsp), %rax
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
	leaq	11488(%rsp), %rcx
	leaq	15584(%rsp), %rax
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
	leaq	57568(%rsp), %rcx
	leaq	19680(%rsp), %rax
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
	leaq	12512(%rsp), %rcx
	leaq	16608(%rsp), %rax
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
	leaq	59616(%rsp), %rcx
	leaq	20704(%rsp), %rax
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
	leaq	13536(%rsp), %rcx
	leaq	17632(%rsp), %rax
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
	leaq	61664(%rsp), %rcx
	leaq	21728(%rsp), %rax
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
	movq	$1, 80160(%rsp)
	jmp 	.L__sign_internal$32
.L__sign_internal$33:
	movq	%rdx, 80120(%rsp)
	movw	%ax, 80368(%rsp)
	leaq	128(%rsp), %rcx
	movw	80368(%rsp), %dx
	leaq	4160(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__sign_internal$158:
	leaq	40(%rsp), %rsp
	leaq	4160(%rsp), %rax
	leaq	2688(%rsp), %rcx
	leaq	1984(%rsp), %rdx
	leaq	1280(%rsp), %rsi
	leaq	576(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$157:
	leaq	4160(%rsp), %rax
	leaq	2824(%rsp), %rcx
	leaq	2120(%rsp), %rdx
	leaq	1416(%rsp), %rsi
	leaq	712(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$156:
	leaq	4160(%rsp), %rax
	leaq	2960(%rsp), %rcx
	leaq	2256(%rsp), %rdx
	leaq	1552(%rsp), %rsi
	leaq	848(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$155:
	leaq	4160(%rsp), %rax
	leaq	3096(%rsp), %rcx
	leaq	2392(%rsp), %rdx
	leaq	1688(%rsp), %rsi
	leaq	984(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$154:
	leaq	4160(%rsp), %rax
	leaq	3232(%rsp), %rcx
	leaq	2528(%rsp), %rdx
	leaq	1824(%rsp), %rsi
	leaq	1120(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__sign_internal$153:
	leaq	39136(%rsp), %rax
	leaq	2688(%rsp), %rsi
	movq	$131072, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %rdi
	vmovq	%rdi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r8
	movq	$0, %rcx
	jmp 	.L__sign_internal$151
.L__sign_internal$152:
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$2, %r8
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$16, %r8
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%rcx)
	addq	$32, %rcx
.L__sign_internal$151:
	cmpq	$1024, %rcx
	jb  	.L__sign_internal$152
	leaq	40160(%rsp), %rax
	leaq	1984(%rsp), %rsi
	movq	$131072, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %rdi
	vmovq	%rdi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r8
	movq	$0, %rcx
	jmp 	.L__sign_internal$149
.L__sign_internal$150:
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$2, %r8
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$16, %r8
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%rcx)
	addq	$32, %rcx
.L__sign_internal$149:
	cmpq	$1024, %rcx
	jb  	.L__sign_internal$150
	leaq	41184(%rsp), %rax
	leaq	1280(%rsp), %rsi
	movq	$131072, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %rdi
	vmovq	%rdi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r8
	movq	$0, %rcx
	jmp 	.L__sign_internal$147
.L__sign_internal$148:
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$2, %r8
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$16, %r8
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%rcx)
	addq	$32, %rcx
.L__sign_internal$147:
	cmpq	$1024, %rcx
	jb  	.L__sign_internal$148
	leaq	42208(%rsp), %rax
	leaq	576(%rsp), %rsi
	movq	$131072, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$262143, %rdi
	vmovq	%rdi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r8
	movq	$0, %rcx
	jmp 	.L__sign_internal$145
.L__sign_internal$146:
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$2, %r8
	vinserti128	$0, %xmm3, %ymm2, %ymm2
	vmovdqu	(%rsi,%r8), %xmm3
	addq	$16, %r8
	vinserti128	$1, %xmm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4928(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 4960(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	%ymm2, (%rax,%rcx)
	addq	$32, %rcx
.L__sign_internal$145:
	cmpq	$1024, %rcx
	jb  	.L__sign_internal$146
	addw	$4, 80368(%rsp)
	movw	80368(%rsp), %ax
	movq	$0, %r9
	jmp 	.L__sign_internal$143
.L__sign_internal$144:
	vmovdqu	39136(%rsp,%r9), %ymm0
	vmovdqu	%ymm0, 35040(%rsp,%r9)
	addq	$32, %r9
.L__sign_internal$143:
	cmpq	$4096, %r9
	jb  	.L__sign_internal$144
	leaq	35040(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__sign_internal$142:
	leaq	63712(%rsp), %rcx
	leaq	35040(%rsp), %rdx
	leaq	43232(%rsp), %rsi
	movq	%rcx, %rdi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$140
.L__sign_internal$141:
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
.L__sign_internal$140:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$141
	leaq	44256(%rsp), %rsi
	leaq	4096(%rcx), %rdi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
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
	leaq	45280(%rsp), %rsi
	leaq	8192(%rcx), %rdi
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
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
	leaq	46304(%rsp), %rsi
	leaq	12288(%rcx), %rcx
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r8
	jmp 	.L__sign_internal$134
.L__sign_internal$135:
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
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%rcx,%r8), %ymm4
	vmovdqu	2048(%rdx,%r8), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%rcx,%r8), %ymm4
	vmovdqu	3072(%rdx,%r8), %ymm5
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
.L__sign_internal$134:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$135
	leaq	43232(%rsp), %rdx
	call	.Lcolumn_vector__reduce32$1
.L__sign_internal$133:
	leaq	43232(%rsp), %rdx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__sign_internal$132:
	leaq	43232(%rsp), %rcx
	leaq	51424(%rsp), %rdx
	leaq	47328(%rsp), %rsi
	movq	%rcx, %r8
	call	.Lpolynomial__decompose_gamma2_88$1
.L__sign_internal$131:
	leaq	52448(%rsp), %rdx
	leaq	48352(%rsp), %rsi
	leaq	1024(%rcx), %r8
	call	.Lpolynomial__decompose_gamma2_88$1
.L__sign_internal$130:
	leaq	53472(%rsp), %rdx
	leaq	49376(%rsp), %rsi
	leaq	2048(%rcx), %r8
	call	.Lpolynomial__decompose_gamma2_88$1
.L__sign_internal$129:
	leaq	54496(%rsp), %rdx
	leaq	50400(%rsp), %rsi
	leaq	3072(%rcx), %r8
	call	.Lpolynomial__decompose_gamma2_88$1
.L__sign_internal$128:
	leaq	47328(%rsp), %rcx
	leaq	3392(%rsp), %rdx
	movq	%rcx, %rsi
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$125
.L__sign_internal$126:
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$127:
	vmovdqu	%xmm1, (%rdx,%r11)
	vmovdqu	%xmm0, 12(%rdx,%r11)
	addq	$24, %r11
.L__sign_internal$125:
	cmpq	$168, %r11
	jb  	.L__sign_internal$126
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$124:
	vmovdqu	%xmm1, (%rdx,%r11)
	addq	$12, %r11
	vmovdqu	%xmm0, 80096(%rsp)
	movq	$0, %r8
	jmp 	.L__sign_internal$122
.L__sign_internal$123:
	movb	80096(%rsp,%r8), %sil
	movb	%sil, (%rdx,%r11)
	incq	%r11
	incq	%r8
.L__sign_internal$122:
	cmpq	$12, %r8
	jb  	.L__sign_internal$123
	leaq	3584(%rsp), %rdx
	leaq	1024(%rcx), %rsi
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$119
.L__sign_internal$120:
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$121:
	vmovdqu	%xmm1, (%rdx,%r11)
	vmovdqu	%xmm0, 12(%rdx,%r11)
	addq	$24, %r11
.L__sign_internal$119:
	cmpq	$168, %r11
	jb  	.L__sign_internal$120
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$118:
	vmovdqu	%xmm1, (%rdx,%r11)
	addq	$12, %r11
	vmovdqu	%xmm0, 80096(%rsp)
	movq	$0, %r8
	jmp 	.L__sign_internal$116
.L__sign_internal$117:
	movb	80096(%rsp,%r8), %sil
	movb	%sil, (%rdx,%r11)
	incq	%r11
	incq	%r8
.L__sign_internal$116:
	cmpq	$12, %r8
	jb  	.L__sign_internal$117
	leaq	3776(%rsp), %rdx
	leaq	2048(%rcx), %rsi
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.L__sign_internal$113
.L__sign_internal$114:
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$115:
	vmovdqu	%xmm1, (%rdx,%r11)
	vmovdqu	%xmm0, 12(%rdx,%r11)
	addq	$24, %r11
.L__sign_internal$113:
	cmpq	$168, %r11
	jb  	.L__sign_internal$114
	vmovdqu	(%rsi,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rsi,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$112:
	vmovdqu	%xmm1, (%rdx,%r11)
	addq	$12, %r11
	vmovdqu	%xmm0, 80096(%rsp)
	movq	$0, %r8
	jmp 	.L__sign_internal$110
.L__sign_internal$111:
	movb	80096(%rsp,%r8), %sil
	movb	%sil, (%rdx,%r11)
	incq	%r11
	incq	%r8
.L__sign_internal$110:
	cmpq	$12, %r8
	jb  	.L__sign_internal$111
	leaq	3968(%rsp), %rdx
	leaq	3072(%rcx), %rcx
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.L__sign_internal$107
.L__sign_internal$108:
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	addq	$32, %r8
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$109:
	vmovdqu	%xmm1, (%rdx,%rsi)
	vmovdqu	%xmm0, 12(%rdx,%rsi)
	addq	$24, %rsi
.L__sign_internal$107:
	cmpq	$168, %rsi
	jb  	.L__sign_internal$108
	vmovdqu	(%rcx,%r8), %ymm0
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm1
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm2
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm3
	call	.Lcommitment__coefficients_to_bytestream_bits6$1
.L__sign_internal$106:
	vmovdqu	%xmm1, (%rdx,%rsi)
	addq	$12, %rsi
	vmovdqu	%xmm0, 80096(%rsp)
	movq	$0, %r8
	jmp 	.L__sign_internal$104
.L__sign_internal$105:
	movb	80096(%rsp,%r8), %cl
	movb	%cl, (%rdx,%rsi)
	incq	%rsi
	incq	%r8
.L__sign_internal$104:
	cmpq	$12, %r8
	jb  	.L__sign_internal$105
	movw	%ax, 80368(%rsp)
	leaq	32(%rsp), %rax
	leaq	64(%rsp), %rcx
	leaq	3392(%rsp), %rdx
	leaq	-248(%rsp), %rsp
	call	.L__derive_commitment_hash$1
.L__sign_internal$103:
	leaq	248(%rsp), %rsp
	leaq	8416(%rsp), %rax
	leaq	32(%rsp), %rcx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	jmp 	.L__sign_internal$101
.L__sign_internal$102:
	vmovdqu	%ymm0, (%rax,%rsi)
	addq	$32, %rsi
.L__sign_internal$101:
	cmpq	$1024, %rsi
	jb  	.L__sign_internal$102
	movq	%rax, 80152(%rsp)
	leaq	352(%rsp), %rax
	call	.Lshake256_absorb_commitment_hash$1
.L__sign_internal$100:
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__sign_internal$99:
	movq	80152(%rsp), %rcx
	movq	192(%rsp), %rdx
	movq	$8, %rdi
	lfence
	movq	$0, %r9
	movq	$217, %rsi
	jmp 	.L__sign_internal$92
.L__sign_internal$93:
	movq	$-1, %rax
	cmovnb	%rax, %r9
	jmp 	.L__sign_internal$94
.L__sign_internal$95:
	movq	$-1, %rax
	cmovbe	%rax, %r9
.L__sign_internal$94:
	cmpq	$136, %rdi
	jnb 	.L__sign_internal$96
	movq	$-1, %rax
	cmovnb	%rax, %r9
	jmp 	.L__sign_internal$97
.L__sign_internal$96:
	movq	%rsi, 80152(%rsp)
	movq	%rdx, 80144(%rsp)
	movq	%rcx, 80136(%rsp)
	leaq	352(%rsp), %rcx
	leaq	192(%rsp), %r8
	call	.Lshake256_squeezeblock$1
.L__sign_internal$98:
	movq	80152(%rsp), %rsi
	movq	80144(%rsp), %rdx
	movq	80136(%rsp), %rcx
	movq	$0, %rdi
	lfence
	movq	$0, %r9
.L__sign_internal$97:
	movzbq	192(%rsp,%rdi), %rax
// declassify_val u64 %rax
	orq 	%r9, %rax
	incq	%rdi
	cmpq	%rsi, %rax
	jnbe	.L__sign_internal$95
	movq	$-1, %r8
	cmovnbe	%r8, %r9
	movl	(%rcx,%rax,4), %r8d
	movl	%r8d, (%rcx,%rsi,4)
	movl	%edx, %r8d
	andl	$1, %r8d
	shll	$1, %r8d
	movl	$1, %r10d
	subl	%r8d, %r10d
	movl	%r10d, (%rcx,%rax,4)
	shrq	$1, %rdx
	incq	%rsi
.L__sign_internal$92:
	cmpq	$256, %rsi
	jb  	.L__sign_internal$93
	movw	80368(%rsp), %ax
// declassify_mem 1024 [RSP + 8416]
	leaq	8416(%rsp), %rcx
	lfence
	movq	$0, %rdx
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rsi
	movq	$39, %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$86
.L__sign_internal$87:
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	vmovdqu	(%rcx,%r8), %ymm2
	vpinsrq	$0, %rdx, %xmm1, %xmm1
	vpinsrq	$1, %rdx, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$90
.L__sign_internal$91:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	movl	%r11d, 80208(%rsp,%rsi,4)
	incq	%rsi
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$90:
	cmpq	$0, %r10
	jne 	.L__sign_internal$91
	movq	$-1, %r10
	cmovne	%r10, %rdx
	vpcmpgtd	%ymm2, %ymm0, %ymm1
	vmovmskps	%ymm1, %r10d
	movl	%r10d, %r10d
	jmp 	.L__sign_internal$88
.L__sign_internal$89:
	movq	$-1, %r11
	cmove	%r11, %rdx
	tzcntq	%r10, %r11
	addq	%r9, %r11
	decq	%rdi
	movl	%r11d, 80208(%rsp,%rdi,4)
	movq	%r10, %r11
	decq	%r11
	andq	%r11, %r10
.L__sign_internal$88:
	cmpq	$0, %r10
	jne 	.L__sign_internal$89
	movq	$-1, %r10
	cmovne	%r10, %rdx
	addq	$8, %r9
	addq	$32, %r8
.L__sign_internal$86:
	cmpq	$1024, %r8
	jb  	.L__sign_internal$87
	movq	$-1, %rcx
	cmovb	%rcx, %rdx
	movl	%esi, 80364(%rsp)
	movq	$0, %rcx
	leaq	22752(%rsp), %rdx
	leaq	80208(%rsp), %rsi
	leaq	39136(%rsp), %rdi
	leaq	30944(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$73
.L__sign_internal$74:
	leaq	(%rdx,%r9,4), %rcx
	leaq	(%rdi,%r9,4), %r10
	leaq	(%r8,%r9,4), %r11
	leaq	9440(%rsp), %rbx
	lfence
	movq	$0, %r13
	movl	156(%rsi), %ebp
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
	jmp 	.L__sign_internal$84
.L__sign_internal$85:
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
.L__sign_internal$84:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$85
	movq	$-1, %r14
	cmovb	%r14, %r13
	jmp 	.L__sign_internal$82
.L__sign_internal$83:
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
.L__sign_internal$82:
	cmpq	$39, %r12
	jb  	.L__sign_internal$83
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
	jmp 	.L__sign_internal$80
.L__sign_internal$81:
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
.L__sign_internal$80:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$81
	movq	$-1, %rbp
	cmovb	%rbp, %r13
	jmp 	.L__sign_internal$78
.L__sign_internal$79:
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
.L__sign_internal$78:
	cmpq	$39, %r12
	jb  	.L__sign_internal$79
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
	leaq	9440(%rsp), %rcx
	vmovdqu	glob_data + 4704(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$130993, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$76
.L__sign_internal$77:
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
.L__sign_internal$76:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$77
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$73:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$75
	movq	$1024, %r9
.L__sign_internal$75:
	cmpq	$1024, %r9
	jb  	.L__sign_internal$74
	leaq	26848(%rsp), %rdx
	leaq	51424(%rsp), %rsi
	leaq	10464(%rsp), %rdi
	leaq	80208(%rsp), %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$60
.L__sign_internal$61:
	leaq	9440(%rsp), %rcx
	leaq	(%rdi,%r9,4), %r10
	lfence
	movq	$0, %r11
	movl	156(%r8), %ebp
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
	jmp 	.L__sign_internal$71
.L__sign_internal$72:
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
.L__sign_internal$71:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$72
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$69
.L__sign_internal$70:
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
.L__sign_internal$69:
	cmpq	$39, %r12
	jb  	.L__sign_internal$70
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
	jmp 	.L__sign_internal$67
.L__sign_internal$68:
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
.L__sign_internal$67:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$68
	movq	$-1, %rbx
	cmovb	%rbx, %r11
	jmp 	.L__sign_internal$65
.L__sign_internal$66:
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
.L__sign_internal$65:
	cmpq	$39, %r12
	jb  	.L__sign_internal$66
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
	leaq	9440(%rsp), %r11
	vmovdqu	glob_data + 4704(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$95153, %rbx
	vmovq	%rbx, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbx
	jmp 	.L__sign_internal$63
.L__sign_internal$64:
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
.L__sign_internal$63:
	cmpq	$1024, %rbx
	jb  	.L__sign_internal$64
	vptest	%ymm3, %ymm3
	setne	%cl
	movzbq	%cl, %rcx
	addq	$256, %r9
.L__sign_internal$60:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$62
	movq	$1024, %r9
.L__sign_internal$62:
	cmpq	$1024, %r9
	jb  	.L__sign_internal$61
	leaq	14560(%rsp), %rdx
	leaq	26848(%rsp), %rsi
	leaq	55520(%rsp), %rdi
	leaq	80208(%rsp), %r8
	movq	$0, 80136(%rsp)
	movq	$0, %r9
	cmpq	$0, %rcx
	je  	.L__sign_internal$39
	movq	$1024, %r9
.L__sign_internal$59:
	jmp 	.L__sign_internal$39
.L__sign_internal$40:
	lfence
	movq	$0, %r11
	leaq	9440(%rsp), %r10
	leaq	(%rdi,%r9,8), %rbx
	movl	156(%r8), %ebp
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
	jmp 	.L__sign_internal$57
.L__sign_internal$58:
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
.L__sign_internal$57:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$58
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$55
.L__sign_internal$56:
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
.L__sign_internal$55:
	cmpq	$39, %r12
	jb  	.L__sign_internal$56
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
	jmp 	.L__sign_internal$53
.L__sign_internal$54:
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
.L__sign_internal$53:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$54
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$51
.L__sign_internal$52:
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
.L__sign_internal$51:
	cmpq	$39, %r12
	jb  	.L__sign_internal$52
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
	jmp 	.L__sign_internal$49
.L__sign_internal$50:
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
.L__sign_internal$49:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$50
	movq	$-1, %r13
	cmovb	%r13, %r11
	jmp 	.L__sign_internal$47
.L__sign_internal$48:
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
.L__sign_internal$47:
	cmpq	$39, %r12
	jb  	.L__sign_internal$48
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
	jmp 	.L__sign_internal$45
.L__sign_internal$46:
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
.L__sign_internal$45:
	cmpq	%rbp, %r12
	jb  	.L__sign_internal$46
	movq	$-1, %rbp
	cmovb	%rbp, %r11
	jmp 	.L__sign_internal$43
.L__sign_internal$44:
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
.L__sign_internal$43:
	cmpq	$39, %r12
	jb  	.L__sign_internal$44
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
	leaq	9440(%rsp), %rbx
	vmovdqu	glob_data + 4704(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$95231, %rbp
	vmovq	%rbp, %xmm2
	vpbroadcastd	%xmm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	movq	$0, %rbp
	jmp 	.L__sign_internal$41
.L__sign_internal$42:
	vmovdqu	(%rbx,%rbp), %ymm4
	vpaddd	%ymm0, %ymm4, %ymm5
	vpsrad	$23, %ymm5, %ymm5
	vpmulld	%ymm1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm4
	vmovdqu	(%r11,%rbp), %ymm6
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, (%r10,%rbp)
	vpabsd	%ymm4, %ymm4
	vpcmpgtd	%ymm2, %ymm4, %ymm4
	vpor	%ymm4, %ymm3, %ymm3
	addq	$32, %rbp
.L__sign_internal$41:
	cmpq	$1024, %rbp
	jb  	.L__sign_internal$42
	vptest	%ymm3, %ymm3
	setne	%r10b
	movzbq	%r10b, %r10
	orq 	%r10, 80136(%rsp)
	addq	$256, %r9
.L__sign_internal$39:
	cmpq	$1024, %r9
	jb  	.L__sign_internal$40
	movq	80136(%rsp), %rdx
	movq	%rdx, 80136(%rsp)
	leaq	14560(%rsp), %rdx
	leaq	47328(%rsp), %rsi
	leaq	18656(%rsp), %rdi
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.L__sign_internal$34
.L__sign_internal$35:
	leaq	(%rdi,%r9,4), %r10
	leaq	(%rdx,%r9,4), %r11
	leaq	(%rsi,%r9,4), %rbx
	movq	$95232, %rbp
	vmovq	%rbp, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$-95232, %rbp
	vmovq	%rbp, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %rbp
	movq	$0, %r12
	jmp 	.L__sign_internal$37
.L__sign_internal$38:
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
.L__sign_internal$37:
	cmpq	$1024, %r12
	jb  	.L__sign_internal$38
	addq	%rbp, %r8
	addq	$256, %r9
	cmpq	$80, %r8
	setnbe	%r10b
	movzbq	%r10b, %r10
	orq 	%r10, %rcx
.L__sign_internal$34:
// declassify_val u64 %rcx
	lfence
	movq	$0, %r10
	cmpq	$0, %rcx
	je  	.L__sign_internal$36
	movq	$1024, %r9
.L__sign_internal$36:
	cmpq	$1024, %r9
	jb  	.L__sign_internal$35
// declassify_val u64 %rcx
	movq	80136(%rsp), %rdx
	orq 	%rdx, %rcx
	movq	80120(%rsp), %rdx
	lfence
	movq	$0, %rsi
	movq	%rcx, 80160(%rsp)
	xorq	$1, %rcx
	movzwl	%ax, %esi
	xorl	$65528, %esi
	testl	%esi, %esi
	sete	%sil
	movzbq	%sil, %rsi
	orq 	%rsi, %rdx
	orq 	%rdx, %rcx
.L__sign_internal$32:
	cmpq	$0, %rcx
	je  	.L__sign_internal$33
	movq	80112(%rsp), %rdi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	cmpq	$0, 80160(%rsp)
	je  	.L__sign_internal$2
	movq	$0, %rsi
	jmp 	.L__sign_internal$30
.L__sign_internal$31:
	movb	$0, (%rdi,%rsi)
	incq	%rsi
.L__sign_internal$30:
	cmpq	$2420, %rsi
	jb  	.L__sign_internal$31
	jmp 	.L__sign_internal$3
.L__sign_internal$2:
// declassify_mem 4096 [RSP + 18656]
// declassify_mem 32 [RSP + 32]
// declassify_mem 4096 [RSP + 30944]
	leaq	32(%rsp), %rcx
	leaq	30944(%rsp), %r10
	leaq	18656(%rsp), %rax
	movq	$0, %rsi
	jmp 	.L__sign_internal$28
.L__sign_internal$29:
	vmovdqu	(%rcx,%rsi), %xmm0
	vmovdqu	%xmm0, (%rdi,%rsi)
	addq	$16, %rsi
.L__sign_internal$28:
	cmpq	$32, %rsi
	jb  	.L__sign_internal$29
	leaq	32(%rdi), %rdx
	movq	%rdx, %rcx
	movq	%r10, %r8
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r9
	movq	$0, %rsi
	jmp 	.L__sign_internal$25
.L__sign_internal$26:
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$27:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, (%rcx,%rsi)
	addq	$9, %rsi
	addq	$32, %r9
.L__sign_internal$25:
	cmpq	$992, %r9
	jb  	.L__sign_internal$26
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$24:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, 80096(%rsp)
// declassify_mem 16 [RSP + 80096]
	movb	80096(%rsp), %r8b
	movb	%r8b, (%rcx,%rsi)
	movb	80097(%rsp), %r8b
	movb	%r8b, 1(%rcx,%rsi)
	movb	80098(%rsp), %r8b
	movb	%r8b, 2(%rcx,%rsi)
	movb	80099(%rsp), %r8b
	movb	%r8b, 3(%rcx,%rsi)
	movb	80100(%rsp), %r8b
	movb	%r8b, 4(%rcx,%rsi)
	movb	80101(%rsp), %r8b
	movb	%r8b, 5(%rcx,%rsi)
	movb	80102(%rsp), %r8b
	movb	%r8b, 6(%rcx,%rsi)
	movb	80103(%rsp), %r8b
	movb	%r8b, 7(%rcx,%rsi)
	movb	80104(%rsp), %r8b
	movb	%r8b, 8(%rcx,%rsi)
	leaq	576(%rdx), %rcx
	leaq	1024(%r10), %r8
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r9
	movq	$0, %rsi
	jmp 	.L__sign_internal$21
.L__sign_internal$22:
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$23:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, (%rcx,%rsi)
	addq	$9, %rsi
	addq	$32, %r9
.L__sign_internal$21:
	cmpq	$992, %r9
	jb  	.L__sign_internal$22
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$20:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, 80096(%rsp)
// declassify_mem 16 [RSP + 80096]
	movb	80096(%rsp), %r8b
	movb	%r8b, (%rcx,%rsi)
	movb	80097(%rsp), %r8b
	movb	%r8b, 1(%rcx,%rsi)
	movb	80098(%rsp), %r8b
	movb	%r8b, 2(%rcx,%rsi)
	movb	80099(%rsp), %r8b
	movb	%r8b, 3(%rcx,%rsi)
	movb	80100(%rsp), %r8b
	movb	%r8b, 4(%rcx,%rsi)
	movb	80101(%rsp), %r8b
	movb	%r8b, 5(%rcx,%rsi)
	movb	80102(%rsp), %r8b
	movb	%r8b, 6(%rcx,%rsi)
	movb	80103(%rsp), %r8b
	movb	%r8b, 7(%rcx,%rsi)
	movb	80104(%rsp), %r8b
	movb	%r8b, 8(%rcx,%rsi)
	leaq	1152(%rdx), %rcx
	leaq	2048(%r10), %r8
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r9
	movq	$0, %rsi
	jmp 	.L__sign_internal$17
.L__sign_internal$18:
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$19:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, (%rcx,%rsi)
	addq	$9, %rsi
	addq	$32, %r9
.L__sign_internal$17:
	cmpq	$992, %r9
	jb  	.L__sign_internal$18
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$16:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, 80096(%rsp)
// declassify_mem 16 [RSP + 80096]
	movb	80096(%rsp), %r8b
	movb	%r8b, (%rcx,%rsi)
	movb	80097(%rsp), %r8b
	movb	%r8b, 1(%rcx,%rsi)
	movb	80098(%rsp), %r8b
	movb	%r8b, 2(%rcx,%rsi)
	movb	80099(%rsp), %r8b
	movb	%r8b, 3(%rcx,%rsi)
	movb	80100(%rsp), %r8b
	movb	%r8b, 4(%rcx,%rsi)
	movb	80101(%rsp), %r8b
	movb	%r8b, 5(%rcx,%rsi)
	movb	80102(%rsp), %r8b
	movb	%r8b, 6(%rcx,%rsi)
	movb	80103(%rsp), %r8b
	movb	%r8b, 7(%rcx,%rsi)
	movb	80104(%rsp), %r8b
	movb	%r8b, 8(%rcx,%rsi)
	leaq	1728(%rdx), %rcx
	leaq	3072(%r10), %r8
	movq	$131072, %r9
	vmovq	%r9, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r9
	movq	$0, %rsi
	jmp 	.L__sign_internal$13
.L__sign_internal$14:
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$15:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, (%rcx,%rsi)
	addq	$9, %rsi
	addq	$32, %r9
.L__sign_internal$13:
	cmpq	$992, %r9
	jb  	.L__sign_internal$14
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lgamma1__coefficients_to_bytestream_bits18$1
.L__sign_internal$12:
	vmovdqu	%xmm1, (%rcx,%rsi)
	addq	$9, %rsi
	vmovdqu	%xmm11, 80096(%rsp)
// declassify_mem 16 [RSP + 80096]
	movb	80096(%rsp), %r8b
	movb	%r8b, (%rcx,%rsi)
	movb	80097(%rsp), %r8b
	movb	%r8b, 1(%rcx,%rsi)
	movb	80098(%rsp), %r8b
	movb	%r8b, 2(%rcx,%rsi)
	movb	80099(%rsp), %r8b
	movb	%r8b, 3(%rcx,%rsi)
	movb	80100(%rsp), %r8b
	movb	%r8b, 4(%rcx,%rsi)
	movb	80101(%rsp), %r8b
	movb	%r8b, 5(%rcx,%rsi)
	movb	80102(%rsp), %r8b
	movb	%r8b, 6(%rcx,%rsi)
	movb	80103(%rsp), %r8b
	movb	%r8b, 7(%rcx,%rsi)
	movb	80104(%rsp), %r8b
	movb	%r8b, 8(%rcx,%rsi)
	movq	$0, %rcx
	movq	%rcx, 2336(%rdi)
	movq	%rcx, 2344(%rdi)
	movq	%rcx, 2352(%rdi)
	movq	%rcx, 2360(%rdi)
	movq	%rcx, 2368(%rdi)
	movq	%rcx, 2376(%rdi)
	movq	%rcx, 2384(%rdi)
	movq	%rcx, 2392(%rdi)
	movq	%rcx, 2400(%rdi)
	movq	%rcx, 2408(%rdi)
	movb	$0, 2416(%rdi)
	movb	$0, 2417(%rdi)
	movb	$0, 2418(%rdi)
	movb	$0, 2419(%rdi)
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
	vmovdqu	(%rax,%r8), %ymm2
	vpinsrq	$0, %rdx, %xmm1, %xmm1
	vpinsrq	$1, %rdx, %xmm1, %xmm1
	vinserti128	$1, %xmm1, %ymm1, %ymm1
	vpor	%ymm1, %ymm2, %ymm2
	vpcmpeqd	%ymm0, %ymm2, %ymm1
	vmovmskps	%ymm1, %r11d
	movl	%r11d, %r11d
	xorq	$255, %r11
	jmp 	.L__sign_internal$8
.L__sign_internal$9:
	movq	$-1, %rbx
	cmove	%rbx, %rdx
	tzcntq	%r11, %r14
	addq	%r10, %r14
	cmpq	$80, %rcx
	jb  	.L__sign_internal$10
	movq	$-1, %rbx
	cmovb	%rbx, %rdx
	jmp 	.L__sign_internal$11
.L__sign_internal$10:
	movq	$-1, %rbx
	cmovnb	%rbx, %rdx
	movb	%r14b, 2336(%rdi,%rcx)
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
	movb	%cl, 2416(%rdi,%rsi)
	incq	%rsi
.L__sign_internal$4:
	cmpq	$4, %rsi
	jb  	.L__sign_internal$5
.L__sign_internal$3:
	lfence
	movq	$0, %rax
	movq	80160(%rsp), %rax
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
.Lcommitment__coefficients_to_bytestream_bits6$1:
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpackusdw	%ymm3, %ymm2, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vmovdqu	glob_data + 0(%rip), %ymm3
	vpmaddubsw	%ymm3, %ymm0, %ymm0
	vmovdqu	glob_data + 32(%rip), %ymm3
	vpmaddwd	%ymm3, %ymm0, %ymm0
	vmovdqu	glob_data + 64(%rip), %ymm3
	vpermd	%ymm0, %ymm3, %ymm0
	vmovdqu	glob_data + 96(%rip), %ymm3
	vpshufb	%ymm3, %ymm0, %ymm0
	vmovdqu	%xmm0, %xmm1
	vextracti128	$1, %ymm0, %xmm0
	ret
.L__keygen_internal$1:
	movq	%rdi, 34272(%rsp)
	movq	%rsi, 34280(%rsp)
	leaq	64(%rsp), %rdi
	movb	$4, 34328(%rsp)
	movb	$4, 34329(%rsp)
	leaq	34328(%rsp), %rax
	leaq	-248(%rsp), %rsp
	call	.L_shake256_A128__A32_A2$1
.L__keygen_internal$234:
	leaq	248(%rsp), %rsp
// declassify_mem 32 [RSP + 64]
	leaq	64(%rsp), %rsi
	vmovdqu	(%rsi), %ymm0
	vmovdqu	%ymm0, 32(%rsp)
	movw	$0, 34288(%rsp)
	movw	$1, 34290(%rsp)
	movw	$2, 34292(%rsp)
	movw	$3, 34294(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	34288(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$233:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$232:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$231:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$230:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$229:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$228:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	17888(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$227:
	movq	%rdi, %rbx
	leaq	18912(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$226:
	movq	%rdi, %rbp
	leaq	19936(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$225:
	movq	%rdi, %r12
	leaq	20960(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$224:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$217
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$219
	cmpq	$256, %r12
	jb  	.L__keygen_internal$221
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$203
	movl	$0, %ecx
.L__keygen_internal$223:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$221:
	movl	$0, %ecx
.L__keygen_internal$222:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$219:
	movl	$0, %ecx
.L__keygen_internal$220:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$217:
	movl	$0, %ecx
.L__keygen_internal$218:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$204:
	movq	%rbx, 34296(%rsp)
	movq	%rbp, 34304(%rsp)
	movq	%r12, 34312(%rsp)
	movq	%rdi, 34320(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$216:
	movq	34296(%rsp), %rax
	movq	34304(%rsp), %rbp
	movq	34312(%rsp), %r12
	movq	34320(%rsp), %r11
	leaq	17888(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$215:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	18912(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$214:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	19936(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$213:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	20960(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$212:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$205
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$207
	cmpq	$256, %r12
	jb  	.L__keygen_internal$209
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$203
	movl	$0, %ecx
.L__keygen_internal$211:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$209:
	movl	$0, %ecx
.L__keygen_internal$210:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$207:
	movl	$0, %ecx
.L__keygen_internal$208:
	jmp 	.L__keygen_internal$203
.L__keygen_internal$205:
	movl	$0, %ecx
.L__keygen_internal$206:
.L__keygen_internal$203:
	cmpl	$1, %ecx
	jne 	.L__keygen_internal$204
	movw	$256, 34288(%rsp)
	movw	$257, 34290(%rsp)
	movw	$258, 34292(%rsp)
	movw	$259, 34294(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	34288(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$202:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$201:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$200:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$199:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$198:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$197:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	21984(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$196:
	movq	%rdi, %rbx
	leaq	23008(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$195:
	movq	%rdi, %rbp
	leaq	24032(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$194:
	movq	%rdi, %r12
	leaq	25056(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$193:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$186
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$188
	cmpq	$256, %r12
	jb  	.L__keygen_internal$190
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$172
	movl	$0, %ecx
.L__keygen_internal$192:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$190:
	movl	$0, %ecx
.L__keygen_internal$191:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$188:
	movl	$0, %ecx
.L__keygen_internal$189:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$186:
	movl	$0, %ecx
.L__keygen_internal$187:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$173:
	movq	%rbx, 34320(%rsp)
	movq	%rbp, 34312(%rsp)
	movq	%r12, 34304(%rsp)
	movq	%rdi, 34296(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$185:
	movq	34320(%rsp), %rax
	movq	34312(%rsp), %rbp
	movq	34304(%rsp), %r12
	movq	34296(%rsp), %r11
	leaq	21984(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$184:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	23008(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$183:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	24032(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$182:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	25056(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$181:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$174
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$176
	cmpq	$256, %r12
	jb  	.L__keygen_internal$178
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$172
	movl	$0, %ecx
.L__keygen_internal$180:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$178:
	movl	$0, %ecx
.L__keygen_internal$179:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$176:
	movl	$0, %ecx
.L__keygen_internal$177:
	jmp 	.L__keygen_internal$172
.L__keygen_internal$174:
	movl	$0, %ecx
.L__keygen_internal$175:
.L__keygen_internal$172:
	cmpl	$1, %ecx
	jne 	.L__keygen_internal$173
	movw	$512, 34288(%rsp)
	movw	$513, 34290(%rsp)
	movw	$514, 34292(%rsp)
	movw	$515, 34294(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	34288(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$171:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$170:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$169:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$168:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$167:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$166:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	26080(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$165:
	movq	%rdi, %rbx
	leaq	27104(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$164:
	movq	%rdi, %rbp
	leaq	28128(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$163:
	movq	%rdi, %r12
	leaq	29152(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$162:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$155
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$157
	cmpq	$256, %r12
	jb  	.L__keygen_internal$159
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$141
	movl	$0, %ecx
.L__keygen_internal$161:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$159:
	movl	$0, %ecx
.L__keygen_internal$160:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$157:
	movl	$0, %ecx
.L__keygen_internal$158:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$155:
	movl	$0, %ecx
.L__keygen_internal$156:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$142:
	movq	%rbx, 34296(%rsp)
	movq	%rbp, 34304(%rsp)
	movq	%r12, 34312(%rsp)
	movq	%rdi, 34320(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$154:
	movq	34296(%rsp), %rax
	movq	34304(%rsp), %rbp
	movq	34312(%rsp), %r12
	movq	34320(%rsp), %r11
	leaq	26080(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$153:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	27104(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$152:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	28128(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$151:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	29152(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$150:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$143
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$145
	cmpq	$256, %r12
	jb  	.L__keygen_internal$147
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$141
	movl	$0, %ecx
.L__keygen_internal$149:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$147:
	movl	$0, %ecx
.L__keygen_internal$148:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$145:
	movl	$0, %ecx
.L__keygen_internal$146:
	jmp 	.L__keygen_internal$141
.L__keygen_internal$143:
	movl	$0, %ecx
.L__keygen_internal$144:
.L__keygen_internal$141:
	cmpl	$1, %ecx
	jne 	.L__keygen_internal$142
	movw	$768, 34288(%rsp)
	movw	$769, 34290(%rsp)
	movw	$770, 34292(%rsp)
	movw	$771, 34294(%rsp)
	leaq	32(%rsp), %rsi
	leaq	1344(%rsp), %rax
	leaq	34288(%rsp), %rcx
	leaq	-40(%rsp), %rsp
	call	.Lshake128_absorb_34_4x$1
.L__keygen_internal$140:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$139:
	leaq	1344(%rsp), %rax
	leaq	4904(%rsp), %rcx
	leaq	4040(%rsp), %rdx
	leaq	3176(%rsp), %rsi
	leaq	2312(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$138:
	leaq	1344(%rsp), %rax
	leaq	5072(%rsp), %rcx
	leaq	4208(%rsp), %rdx
	leaq	3344(%rsp), %rsi
	leaq	2480(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$137:
	leaq	1344(%rsp), %rax
	leaq	5240(%rsp), %rcx
	leaq	4376(%rsp), %rdx
	leaq	3512(%rsp), %rsi
	leaq	2648(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$136:
	leaq	1344(%rsp), %rax
	leaq	5408(%rsp), %rcx
	leaq	4544(%rsp), %rdx
	leaq	3680(%rsp), %rsi
	leaq	2816(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$135:
	movq	$0, %rax
	movq	%rax, 5576(%rsp)
	movq	%rax, 4712(%rsp)
	movq	%rax, 3848(%rsp)
	movq	%rax, 2984(%rsp)
	leaq	30176(%rsp), %rax
	leaq	4736(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$134:
	movq	%rdi, %rbx
	leaq	31200(%rsp), %rax
	leaq	3872(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$133:
	movq	%rdi, %rbp
	leaq	32224(%rsp), %rax
	leaq	3008(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$132:
	movq	%rdi, %r12
	leaq	33248(%rsp), %rax
	leaq	2144(%rsp), %rcx
	call	.Lmatrix_A__rejection_sample_multiple_blocks$1
.L__keygen_internal$131:
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$124
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$126
	cmpq	$256, %r12
	jb  	.L__keygen_internal$128
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$110
	movl	$0, %ecx
.L__keygen_internal$130:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$128:
	movl	$0, %ecx
.L__keygen_internal$129:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$126:
	movl	$0, %ecx
.L__keygen_internal$127:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$124:
	movl	$0, %ecx
.L__keygen_internal$125:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$111:
	movq	%rbx, 34288(%rsp)
	movq	%rbp, 34320(%rsp)
	movq	%r12, 34312(%rsp)
	movq	%rdi, 34304(%rsp)
	leaq	1344(%rsp), %rax
	leaq	4736(%rsp), %rcx
	leaq	3872(%rsp), %rdx
	leaq	3008(%rsp), %rsi
	leaq	2144(%rsp), %rdi
	call	.Lshake128_squeezeblock4x$1
.L__keygen_internal$123:
	movq	34288(%rsp), %rax
	movq	34320(%rsp), %rbp
	movq	34312(%rsp), %r12
	movq	34304(%rsp), %r11
	leaq	30176(%rsp), %r10
	leaq	4736(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$122:
	movq	%rax, %rbx
	movq	%rbp, %rax
	leaq	31200(%rsp), %r10
	leaq	3872(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$121:
	movq	%rax, %rbp
	movq	%r12, %rax
	leaq	32224(%rsp), %r10
	leaq	3008(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$120:
	movq	%rax, %r12
	movq	%r11, %rax
	leaq	33248(%rsp), %r10
	leaq	2144(%rsp), %r8
	call	.Lmatrix_A__rejection_sample_one_block$1
.L__keygen_internal$119:
	movq	%rax, %rdi
	movl	$1, %ecx
	cmpq	$256, %rbx
	jb  	.L__keygen_internal$112
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$114
	cmpq	$256, %r12
	jb  	.L__keygen_internal$116
	cmpq	$256, %rdi
	jnb 	.L__keygen_internal$110
	movl	$0, %ecx
.L__keygen_internal$118:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$116:
	movl	$0, %ecx
.L__keygen_internal$117:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$114:
	movl	$0, %ecx
.L__keygen_internal$115:
	jmp 	.L__keygen_internal$110
.L__keygen_internal$112:
	movl	$0, %ecx
.L__keygen_internal$113:
.L__keygen_internal$110:
	cmpl	$1, %ecx
	jne 	.L__keygen_internal$111
	leaq	96(%rsp), %rcx
	movw	$0, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$109:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$108:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$107:
	leaq	5600(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$106:
	movq	%rdi, %r11
	leaq	6624(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$105:
	movq	%rdi, %rbp
	leaq	7648(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$104:
	movq	%rdi, %r12
	leaq	8672(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$103:
	movq	%rdi, %rbx
	movq	$1, %rcx
	cmpq	$256, %r11
	jb  	.L__keygen_internal$96
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$98
	cmpq	$256, %r12
	jb  	.L__keygen_internal$100
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$78
	movq	$0, %rcx
.L__keygen_internal$102:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$100:
	movq	$0, %rcx
.L__keygen_internal$101:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$98:
	movq	$0, %rcx
.L__keygen_internal$99:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$96:
	movq	$0, %rcx
.L__keygen_internal$97:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$79:
	movq	%r11, 34304(%rsp)
	movq	%rbp, 34312(%rsp)
	movq	%r12, 34320(%rsp)
	movq	%rbx, 34288(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$95:
	movq	34304(%rsp), %r11
	movq	34312(%rsp), %rbp
	movq	34320(%rsp), %r12
	movq	34288(%rsp), %rbx
	lfence
	movq	$0, %rax
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$93
	movq	%r11, %r9
	leaq	5600(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$94:
	movq	%r9, %r11
.L__keygen_internal$93:
	cmpq	$256, %rbp
	jnb 	.L__keygen_internal$91
	movq	%rbp, %r9
	leaq	6624(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$92:
	movq	%r9, %rbp
.L__keygen_internal$91:
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$89
	movq	%r12, %r9
	leaq	7648(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$90:
	movq	%r9, %r12
.L__keygen_internal$89:
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$87
	movq	%rbx, %r9
	leaq	8672(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$88:
	movq	%r9, %rbx
.L__keygen_internal$87:
	movq	$1, %rcx
	cmpq	$256, %r11
	jb  	.L__keygen_internal$80
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$82
	cmpq	$256, %r12
	jb  	.L__keygen_internal$84
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$78
	movq	$0, %rcx
.L__keygen_internal$86:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$84:
	movq	$0, %rcx
.L__keygen_internal$85:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$82:
	movq	$0, %rcx
.L__keygen_internal$83:
	jmp 	.L__keygen_internal$78
.L__keygen_internal$80:
	movq	$0, %rcx
.L__keygen_internal$81:
.L__keygen_internal$78:
	cmpq	$1, %rcx
	jne 	.L__keygen_internal$79
	leaq	96(%rsp), %rcx
	movw	$4, %dx
	leaq	1344(%rsp), %rax
	leaq	-40(%rsp), %rsp
	call	.Lshake256_absorb_66_4x$1
.L__keygen_internal$77:
	leaq	40(%rsp), %rsp
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$76:
	leaq	1344(%rsp), %rax
	leaq	1192(%rsp), %rcx
	leaq	904(%rsp), %rdx
	leaq	616(%rsp), %rsi
	leaq	328(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$75:
	leaq	9696(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$74:
	movq	%rdi, %r11
	leaq	10720(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$73:
	movq	%rdi, %rbp
	leaq	11744(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$72:
	movq	%rdi, %r12
	leaq	12768(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_multiple_blocks$1
.L__keygen_internal$71:
	movq	%rdi, %rbx
	movq	$1, %rcx
	cmpq	$256, %r11
	jb  	.L__keygen_internal$64
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$66
	cmpq	$256, %r12
	jb  	.L__keygen_internal$68
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$46
	movq	$0, %rcx
.L__keygen_internal$70:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$68:
	movq	$0, %rcx
.L__keygen_internal$69:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$66:
	movq	$0, %rcx
.L__keygen_internal$67:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$64:
	movq	$0, %rcx
.L__keygen_internal$65:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$47:
	movq	%r11, 34288(%rsp)
	movq	%rbp, 34320(%rsp)
	movq	%r12, 34312(%rsp)
	movq	%rbx, 34304(%rsp)
	leaq	1344(%rsp), %rax
	leaq	1056(%rsp), %rcx
	leaq	768(%rsp), %rdx
	leaq	480(%rsp), %rsi
	leaq	192(%rsp), %rdi
	call	.Lshake256_squeezeblock4x$1
.L__keygen_internal$63:
	movq	34288(%rsp), %r11
	movq	34320(%rsp), %rbp
	movq	34312(%rsp), %r12
	movq	34304(%rsp), %rbx
	lfence
	movq	$0, %rdx
	cmpq	$256, %r11
	jnb 	.L__keygen_internal$61
	movq	%r11, %r9
	leaq	9696(%rsp), %rax
	leaq	1056(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$62:
	movq	%r9, %r11
.L__keygen_internal$61:
	cmpq	$256, %rbp
	jnb 	.L__keygen_internal$59
	movq	%rbp, %r9
	leaq	10720(%rsp), %rax
	leaq	768(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$60:
	movq	%r9, %rbp
.L__keygen_internal$59:
	cmpq	$256, %r12
	jnb 	.L__keygen_internal$57
	movq	%r12, %r9
	leaq	11744(%rsp), %rax
	leaq	480(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$58:
	movq	%r9, %r12
.L__keygen_internal$57:
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$55
	movq	%rbx, %r9
	leaq	12768(%rsp), %rax
	leaq	192(%rsp), %rcx
	call	.Lerror_4x__rejection_sample_one_block$1
.L__keygen_internal$56:
	movq	%r9, %rbx
.L__keygen_internal$55:
	movq	$1, %rcx
	cmpq	$256, %r11
	jb  	.L__keygen_internal$48
	cmpq	$256, %rbp
	jb  	.L__keygen_internal$50
	cmpq	$256, %r12
	jb  	.L__keygen_internal$52
	cmpq	$256, %rbx
	jnb 	.L__keygen_internal$46
	movq	$0, %rcx
.L__keygen_internal$54:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$52:
	movq	$0, %rcx
.L__keygen_internal$53:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$50:
	movq	$0, %rcx
.L__keygen_internal$51:
	jmp 	.L__keygen_internal$46
.L__keygen_internal$48:
	movq	$0, %rcx
.L__keygen_internal$49:
.L__keygen_internal$46:
	cmpq	$1, %rcx
	jne 	.L__keygen_internal$47
	movq	34272(%rsp), %rdi
	movq	34280(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	orq 	%rdx, %rsi
	vmovdqu	64(%rsp), %ymm0
	vmovdqu	%ymm0, (%rsi)
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	%ymm0, 32(%rsi)
	leaq	5600(%rsp), %rax
	leaq	128(%rsi), %rcx
	movq	%rax, %mm0
	movq	%rcx, %rdx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$45:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	96(%rcx), %rdx
	leaq	1024(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$44:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	192(%rcx), %rdx
	leaq	2048(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$43:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	288(%rcx), %rdx
	leaq	3072(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$42:
	leaq	24(%rsp), %rsp
	leaq	9696(%rsp), %rax
	leaq	512(%rsi), %rcx
	movq	%rax, %mm0
	movq	%rcx, %rdx
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$41:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	96(%rcx), %rdx
	leaq	1024(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$40:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	192(%rcx), %rdx
	leaq	2048(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$39:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rax
	leaq	288(%rcx), %rdx
	leaq	3072(%rax), %rax
	leaq	-24(%rsp), %rsp
	call	.Lerror_polynomial__encode_eta2$1
.L__keygen_internal$38:
	leaq	24(%rsp), %rsp
	movq	%rsi, 34280(%rsp)
	leaq	5600(%rsp), %rcx
	call	.Lrow_vector__ntt$1
.L__keygen_internal$37:
	leaq	17888(%rsp), %rdx
	leaq	5600(%rsp), %rax
	leaq	9696(%rsp), %rcx
	leaq	13792(%rsp), %rsi
	movq	%rdx, %r8
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$35
.L__keygen_internal$36:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rax,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rax,%r9), %ymm5
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
.L__keygen_internal$35:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$36
	leaq	14816(%rsp), %rsi
	leaq	4096(%rdx), %r8
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$33
.L__keygen_internal$34:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rax,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rax,%r9), %ymm5
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
.L__keygen_internal$33:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$34
	leaq	15840(%rsp), %rsi
	leaq	8192(%rdx), %r8
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$31
.L__keygen_internal$32:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	(%rax,%r9), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%r9), %ymm4
	vmovdqu	1024(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%r9), %ymm4
	vmovdqu	2048(%rax,%r9), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%r9), %ymm4
	vmovdqu	3072(%rax,%r9), %ymm5
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
.L__keygen_internal$31:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$32
	leaq	16864(%rsp), %rsi
	leaq	12288(%rdx), %r8
	vmovdqu	glob_data + 4736(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %rdx
	jmp 	.L__keygen_internal$29
.L__keygen_internal$30:
	vmovdqu	(%r8,%rdx), %ymm2
	vmovdqu	(%rax,%rdx), %ymm3
	vmovshdup	%ymm2, %ymm4
	vmovshdup	%ymm3, %ymm5
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	%ymm5, %ymm4, %ymm3
	vmovdqu	1024(%r8,%rdx), %ymm4
	vmovdqu	1024(%rax,%rdx), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	2048(%r8,%rdx), %ymm4
	vmovdqu	2048(%rax,%rdx), %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm5, %ymm7
	vpmuldq	%ymm5, %ymm4, %ymm5
	vpmuldq	%ymm7, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpaddq	%ymm4, %ymm3, %ymm3
	vmovdqu	3072(%r8,%rdx), %ymm4
	vmovdqu	3072(%rax,%rdx), %ymm5
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
	vmovdqu	%ymm2, (%rsi,%rdx)
	addq	$32, %rdx
.L__keygen_internal$29:
	cmpq	$1024, %rdx
	jb  	.L__keygen_internal$30
	leaq	13792(%rsp), %rdx
	call	.Lcolumn_vector__reduce32$1
.L__keygen_internal$28:
	leaq	13792(%rsp), %rdx
	call	.Lcolumn_vector__invert_ntt_montgomery$1
.L__keygen_internal$27:
	leaq	13792(%rsp), %rsi
	movq	%rsi, %mm0
	movq	%rcx, %mm1
	leaq	5600(%rsp), %r10
	call	.Lpolynomial__add$1
.L__keygen_internal$26:
	movq	%mm0, %rcx
	movq	%mm1, %rax
	leaq	6624(%rsp), %r10
	leaq	1024(%rcx), %rsi
	leaq	1024(%rax), %rcx
	call	.Lpolynomial__add$1
.L__keygen_internal$25:
	movq	%mm0, %rcx
	movq	%mm1, %rax
	leaq	7648(%rsp), %r10
	leaq	2048(%rcx), %rsi
	leaq	2048(%rax), %rcx
	call	.Lpolynomial__add$1
.L__keygen_internal$24:
	movq	%mm0, %rcx
	movq	%mm1, %rax
	leaq	8672(%rsp), %r10
	leaq	3072(%rcx), %rsi
	leaq	3072(%rax), %rcx
	call	.Lpolynomial__add$1
.L__keygen_internal$23:
	leaq	5600(%rsp), %rax
	movq	%rax, %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$22:
	leaq	1024(%rax), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$21:
	leaq	2048(%rax), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$20:
	leaq	3072(%rax), %r8
	call	.Lpolynomial__conditionally_add_modulus$1
.L__keygen_internal$19:
	leaq	5600(%rsp), %rax
	leaq	9696(%rsp), %rcx
	leaq	13792(%rsp), %rdx
	movq	%rax, %r8
	vmovdqu	glob_data + 5312(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$17
.L__keygen_internal$18:
	vmovdqu	(%r8,%r9), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r9)
	vmovdqu	%ymm2, (%rdx,%r9)
	addq	$32, %r9
.L__keygen_internal$17:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$18
	leaq	10720(%rsp), %rcx
	leaq	14816(%rsp), %rdx
	leaq	1024(%rax), %r8
	vmovdqu	glob_data + 5312(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$15
.L__keygen_internal$16:
	vmovdqu	(%r8,%r9), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r9)
	vmovdqu	%ymm2, (%rdx,%r9)
	addq	$32, %r9
.L__keygen_internal$15:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$16
	leaq	11744(%rsp), %rcx
	leaq	15840(%rsp), %rdx
	leaq	2048(%rax), %r8
	vmovdqu	glob_data + 5312(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r9
	jmp 	.L__keygen_internal$13
.L__keygen_internal$14:
	vmovdqu	(%r8,%r9), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r9)
	vmovdqu	%ymm2, (%rdx,%r9)
	addq	$32, %r9
.L__keygen_internal$13:
	cmpq	$1024, %r9
	jb  	.L__keygen_internal$14
	leaq	12768(%rsp), %rcx
	leaq	16864(%rsp), %rdx
	leaq	3072(%rax), %rax
	vmovdqu	glob_data + 5312(%rip), %ymm0
	movq	$1, %r9
	vmovq	%r9, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	movq	$0, %r8
	jmp 	.L__keygen_internal$11
.L__keygen_internal$12:
	vmovdqu	(%rax,%r8), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm3
	vpsubd	%ymm1, %ymm3, %ymm3
	vpsrad	$13, %ymm3, %ymm3
	vpslld	$13, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm3, (%rcx,%r8)
	vmovdqu	%ymm2, (%rdx,%r8)
	addq	$32, %r8
.L__keygen_internal$11:
	cmpq	$1024, %r8
	jb  	.L__keygen_internal$12
	leaq	32(%rdi), %rdx
	leaq	9696(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$10:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	320(%rdx), %rax
	leaq	1024(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$9:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	640(%rdx), %rax
	leaq	2048(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$8:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	960(%rdx), %rax
	leaq	3072(%rcx), %rcx
	leaq	-24(%rsp), %rsp
	call	.Lt1__encode_polynomial$1
.L__keygen_internal$7:
	leaq	24(%rsp), %rsp
// declassify_mem 1312 [RDI]
	movq	%rdi, %rcx
	movq	34280(%rsp), %rsi
	lfence
	movq	$0, %rdx
	leaq	64(%rsi), %rax
	movq	%rdi, 34280(%rsp)
	movq	%rsi, 34272(%rsp)
	leaq	-248(%rsp), %rsp
	call	.Lhash_verification_key$1
.L__keygen_internal$6:
	leaq	248(%rsp), %rsp
	movq	34280(%rsp), %rdi
	movq	34272(%rsp), %rsi
	lfence
	movq	$0, %rdx
	orq 	%rdx, %rdi
	orq 	%rdx, %rsi
	leaq	896(%rsi), %rdx
	leaq	13792(%rsp), %rcx
	movq	%rcx, %mm0
	movq	%rdx, %rax
	movq	%rcx, %r8
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$5:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	416(%rdx), %rax
	leaq	1024(%rcx), %r8
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$4:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	832(%rdx), %rax
	leaq	2048(%rcx), %r8
	leaq	-24(%rsp), %rsp
	call	.Lt0__encode_polynomial$1
.L__keygen_internal$3:
	leaq	24(%rsp), %rsp
	movq	%mm0, %rcx
	leaq	1248(%rdx), %rax
	leaq	3072(%rcx), %r8
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
	cmpl	$15, %edi
	jb  	.Lerror_4x__rejection_sample_one_block$12
	movq	$-1, %r8
	cmovb	%r8, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$13
.Lerror_4x__rejection_sample_one_block$12:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	movl	%edi, %r8d
	imull	$205, %r8d, %r8d
	shrl	$10, %r8d
	imull	$5, %r8d, %r8d
	subl	%r8d, %edi
	addl	$-2, %edi
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
	cmpl	$15, %edi
	jb  	.Lerror_4x__rejection_sample_one_block$10
	movq	$-1, %rdi
	cmovb	%rdi, %rdx
	jmp 	.Lerror_4x__rejection_sample_one_block$9
.Lerror_4x__rejection_sample_one_block$10:
	movq	$-1, %r8
	cmovnb	%r8, %rdx
	movl	%edi, %r8d
	imull	$205, %r8d, %r8d
	shrl	$10, %r8d
	imull	$5, %r8d, %r8d
	subl	%r8d, %edi
	addl	$-2, %edi
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
	movq	$2, %rdi
	vmovq	%rdi, %xmm0
	vpbroadcastb	%xmm0, %ymm0
	movq	$15, %rdi
	vmovq	%rdi, %xmm1
	vpbroadcastb	%xmm1, %ymm1
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$0, %rbx
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$19:
	movq	$-1, %r9
	cmove	%r9, %r13
	vmovdqu	(%rcx,%rsi), %xmm2
	movq	$15, %r9
	vmovq	%r9, %xmm3
	vpbroadcastb	%xmm3, %ymm3
	vpmovzxbw	%xmm2, %ymm2
	vpsllw	$4, %ymm2, %ymm4
	vpor	%ymm4, %ymm2, %ymm2
	vpand	%ymm3, %ymm2, %ymm2
	vpsubb	%ymm1, %ymm2, %ymm3
	vpmovmskb	%ymm3, %edx
	vpsubb	%ymm2, %ymm0, %ymm2
	vextracti128	$0, %ymm2, %xmm3
// declassify_val u64 %rdx
	orq 	%r13, %rdx
	movq	%rdx, %r9
	andq	$255, %r9
	shrq	$8, %rdx
	leaq	glob_data + 5648(%rip), %r8
	movq	%r9, %r10
	shlq	$3, %r10
	vmovq	(%r8,%r10), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %r8
	vmovq	%r8, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rax,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rsi
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$24
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$24:
	movq	$-1, %r8
	cmovnb	%r8, %r13
	vpsrldq	$8, %xmm3, %xmm3
	movq	%rdx, %r9
	andq	$255, %r9
	shrq	$8, %rdx
	leaq	glob_data + 5648(%rip), %r8
	movq	%r9, %r10
	shlq	$3, %r10
	vmovq	(%r8,%r10), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm10
	movq	$-6560, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm10, %ymm4
	movq	$5, %r8
	vmovq	%r8, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm10, %ymm4
	vmovdqu	%ymm4, (%rax,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rsi
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$26
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$26:
	movq	$-1, %r10
	cmovnb	%r10, %r13
	vextracti128	$1, %ymm2, %xmm3
	movq	%rdx, %r9
	andq	$255, %r9
	shrq	$8, %rdx
	leaq	glob_data + 5648(%rip), %r8
	movq	%r9, %r10
	shlq	$3, %r10
	vmovq	(%r8,%r10), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %r8
	vmovq	%r8, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rax,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	addq	$4, %rsi
	cmpq	$992, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$28
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$25
.Lerror_4x__rejection_sample_multiple_blocks$28:
	movq	$-1, %r8
	cmovnb	%r8, %r13
	vpsrldq	$8, %xmm3, %xmm3
	andq	$255, %rdx
	leaq	glob_data + 5648(%rip), %r8
	movq	%rdx, %r10
	shlq	$3, %r10
	vmovq	(%r8,%r10), %xmm4
	vpshufb	%xmm4, %xmm3, %xmm4
	vpmovsxbd	%xmm4, %ymm2
	movq	$-6560, %r8
	vmovq	%r8, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpmulhrsw	%ymm4, %ymm2, %ymm4
	movq	$5, %r8
	vmovq	%r8, %xmm5
	vpbroadcastd	%xmm5, %ymm5
	vpmullw	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm2, %ymm4
	vmovdqu	%ymm4, (%rax,%rdi)
	popcnt	%rdx, %rdx
	shlq	$2, %rdx
	addq	%rdx, %rdi
	addq	$4, %rsi
.Lerror_4x__rejection_sample_multiple_blocks$29:
.Lerror_4x__rejection_sample_multiple_blocks$27:
.Lerror_4x__rejection_sample_multiple_blocks$25:
	cmpq	$992, %rdi
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$20
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	cmpq	$256, %rsi
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$22
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$22:
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	movq	$1, %rbx
.Lerror_4x__rejection_sample_multiple_blocks$23:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$18
.Lerror_4x__rejection_sample_multiple_blocks$20:
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	movq	$1, %rbx
.Lerror_4x__rejection_sample_multiple_blocks$21:
.Lerror_4x__rejection_sample_multiple_blocks$18:
	cmpq	$1, %rbx
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$19
	movq	$-1, %rdx
	cmovne	%rdx, %r13
	shrq	$2, %rdi
	cmpq	$256, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$14
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$14:
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	cmpq	$272, %rsi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$16
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$16:
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	movq	$0, %rbx
.Lerror_4x__rejection_sample_multiple_blocks$17:
.Lerror_4x__rejection_sample_multiple_blocks$15:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$3:
	movq	$-1, %rdx
	cmove	%rdx, %r13
	movzbl	(%rcx,%rsi), %edx
	andl	$15, %edx
// declassify_val u32 %edx
	orl 	%r13d, %edx
	cmpl	$15, %edx
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$12
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$13
.Lerror_4x__rejection_sample_multiple_blocks$12:
	movq	$-1, %r8
	cmovnb	%r8, %r13
	movl	%edx, %r8d
	imull	$205, %r8d, %r8d
	shrl	$10, %r8d
	imull	$5, %r8d, %r8d
	subl	%r8d, %edx
	addl	$-2, %edx
	negl	%edx
	movl	%edx, (%rax,%rdi,4)
	incq	%rdi
.Lerror_4x__rejection_sample_multiple_blocks$13:
	cmpq	$256, %rdi
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$8
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$8:
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	movzbl	(%rcx,%rsi), %edx
	shrl	$4, %edx
// declassify_val u32 %edx
	orl 	%r13d, %edx
	cmpl	$15, %edx
	jb  	.Lerror_4x__rejection_sample_multiple_blocks$10
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$9
.Lerror_4x__rejection_sample_multiple_blocks$10:
	movq	$-1, %r8
	cmovnb	%r8, %r13
	movl	%edx, %r8d
	imull	$205, %r8d, %r8d
	shrl	$10, %r8d
	imull	$5, %r8d, %r8d
	subl	%r8d, %edx
	addl	$-2, %edx
	negl	%edx
	movl	%edx, (%rax,%rdi,4)
	incq	%rdi
.Lerror_4x__rejection_sample_multiple_blocks$11:
.Lerror_4x__rejection_sample_multiple_blocks$9:
	incq	%rsi
	cmpq	$272, %rsi
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$4
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	cmpq	$256, %rdi
	jnb 	.Lerror_4x__rejection_sample_multiple_blocks$6
	movq	$-1, %rdx
	cmovnb	%rdx, %r13
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$6:
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	movq	$1, %rbx
.Lerror_4x__rejection_sample_multiple_blocks$7:
	jmp 	.Lerror_4x__rejection_sample_multiple_blocks$2
.Lerror_4x__rejection_sample_multiple_blocks$4:
	movq	$-1, %rdx
	cmovb	%rdx, %r13
	movq	$1, %rbx
.Lerror_4x__rejection_sample_multiple_blocks$5:
.Lerror_4x__rejection_sample_multiple_blocks$2:
	cmpq	$1, %rbx
	jne 	.Lerror_4x__rejection_sample_multiple_blocks$3
	ret
.Lt1__decode_polynomial$1:
	vpxor	%ymm2, %ymm2, %ymm2
	movq	$0, %r8
	movq	$0, %rsi
	jmp 	.Lt1__decode_polynomial$2
.Lt1__decode_polynomial$3:
	vmovdqu	(%rcx,%r8), %xmm0
	addq	$10, %r8
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 192(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 224(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	glob_data + 160(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdi,%rsi)
	addq	$32, %rsi
.Lt1__decode_polynomial$2:
	cmpq	$992, %rsi
	jb  	.Lt1__decode_polynomial$3
	vmovdqu	304(%rcx), %xmm0
	vpsrldq	$6, %xmm0, %xmm0
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 192(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 224(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vpand	glob_data + 160(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, (%rdi,%rsi)
	ret
.Lt1__encode_polynomial$1:
	movq	$0, %rsi
	movq	$0, %r8
	jmp 	.Lt1__encode_polynomial$3
.Lt1__encode_polynomial$4:
	vmovdqu	(%rcx,%r8), %ymm2
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$5:
	vmovdqu	%xmm0, (%rax,%rsi)
	addq	$10, %rsi
	addq	$32, %r8
.Lt1__encode_polynomial$3:
	cmpq	$992, %r8
	jb  	.Lt1__encode_polynomial$4
	vmovdqu	(%rcx,%r8), %ymm2
	call	.Lt1__coefficients_to_bytestream$1
.Lt1__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %cl
	movb	%cl, (%rax,%rsi)
	movb	17(%rsp), %cl
	movb	%cl, 1(%rax,%rsi)
	movb	18(%rsp), %cl
	movb	%cl, 2(%rax,%rsi)
	movb	19(%rsp), %cl
	movb	%cl, 3(%rax,%rsi)
	movb	20(%rsp), %cl
	movb	%cl, 4(%rax,%rsi)
	movb	21(%rsp), %cl
	movb	%cl, 5(%rax,%rsi)
	movb	22(%rsp), %cl
	movb	%cl, 6(%rax,%rsi)
	movb	23(%rsp), %cl
	movb	%cl, 7(%rax,%rsi)
	movb	24(%rsp), %cl
	movb	%cl, 8(%rax,%rsi)
	movb	25(%rsp), %cl
	movb	%cl, 9(%rax,%rsi)
	ret
.Lt1__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 256(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm0
	vpsrlq	$22, %ymm0, %ymm0
	vmovdqu	glob_data + 288(%rip), %ymm3
	vpermd	%ymm0, %ymm3, %ymm0
	vmovdqu	glob_data + 320(%rip), %ymm3
	vpsllvd	%ymm3, %ymm0, %ymm0
	vpsrlq	$12, %ymm0, %ymm0
	vpermq	$8, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	vmovdqu	glob_data + 5376(%rip), %xmm1
	vpshufb	%xmm1, %xmm0, %xmm0
	ret
.Lt0__bytestream_to_coefficients$1:
	vpxor	%ymm2, %ymm2, %ymm2
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$1, %xmm0, %ymm2, %ymm2
	vmovdqu	glob_data + 352(%rip), %ymm3
	vpshufb	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 384(%rip), %ymm3
	vpsrlvd	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 416(%rip), %ymm3
	vpand	%ymm3, %ymm2, %ymm2
	vmovdqu	glob_data + 5312(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	ret
.Lt0__encode_polynomial$1:
	movq	$0, %rcx
	movq	$0, %r9
	jmp 	.Lt0__encode_polynomial$3
.Lt0__encode_polynomial$4:
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$5:
	vmovdqu	%xmm0, (%rax,%rcx)
	addq	$13, %rcx
	addq	$32, %r9
.Lt0__encode_polynomial$3:
	cmpq	$992, %r9
	jb  	.Lt0__encode_polynomial$4
	vmovdqu	(%r8,%r9), %ymm2
	call	.Lt0__coefficients_to_bytestream$1
.Lt0__encode_polynomial$2:
	vmovdqu	%xmm0, 16(%rsp)
	movb	16(%rsp), %r8b
	movb	%r8b, (%rax,%rcx)
	movb	17(%rsp), %r8b
	movb	%r8b, 1(%rax,%rcx)
	movb	18(%rsp), %r8b
	movb	%r8b, 2(%rax,%rcx)
	movb	19(%rsp), %r8b
	movb	%r8b, 3(%rax,%rcx)
	movb	20(%rsp), %r8b
	movb	%r8b, 4(%rax,%rcx)
	movb	21(%rsp), %r8b
	movb	%r8b, 5(%rax,%rcx)
	movb	22(%rsp), %r8b
	movb	%r8b, 6(%rax,%rcx)
	movb	23(%rsp), %r8b
	movb	%r8b, 7(%rax,%rcx)
	movb	24(%rsp), %r8b
	movb	%r8b, 8(%rax,%rcx)
	movb	25(%rsp), %r8b
	movb	%r8b, 9(%rax,%rcx)
	movb	26(%rsp), %r8b
	movb	%r8b, 10(%rax,%rcx)
	movb	27(%rsp), %r8b
	movb	%r8b, 11(%rax,%rcx)
	movb	28(%rsp), %r8b
	movb	%r8b, 12(%rax,%rcx)
	ret
.Lt0__coefficients_to_bytestream$1:
	vmovdqu	glob_data + 5312(%rip), %ymm3
	vpsubd	%ymm2, %ymm3, %ymm2
	vmovdqu	glob_data + 448(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm0
	vpsrlq	$19, %ymm0, %ymm0
	vmovdqu	glob_data + 480(%rip), %ymm3
	vpermd	%ymm0, %ymm3, %ymm0
	vmovdqu	glob_data + 512(%rip), %ymm3
	vpsllvd	%ymm3, %ymm0, %ymm0
	vpsrlq	$6, %ymm0, %ymm0
	vpsrldq	$8, %ymm0, %ymm1
	vpsllq	$52, %ymm1, %ymm1
	vpaddq	%ymm1, %ymm0, %ymm0
	vmovdqu	glob_data + 544(%rip), %ymm3
	vpsrlvq	%ymm3, %ymm0, %ymm0
	vextracti128	$0, %ymm0, %xmm0
	ret
.Lcolumn_vector__invert_ntt_montgomery$1:
	movq	%rdx, %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$5:
	leaq	1024(%rdx), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$4:
	leaq	2048(%rdx), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$3:
	leaq	3072(%rdx), %r10
	call	.Lpolynomial__invert_ntt_montgomery$1
.Lcolumn_vector__invert_ntt_montgomery$2:
	ret
.Lcolumn_vector__reduce32$1:
	movq	%rdx, %r8
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$5:
	leaq	1024(%rdx), %r8
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$4:
	leaq	2048(%rdx), %r8
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$3:
	leaq	3072(%rdx), %r8
	call	.Lpolynomial__reduce32$1
.Lcolumn_vector__reduce32$2:
	ret
.Lrow_vector__ntt$1:
	movq	%rcx, %r10
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$5:
	leaq	1024(%rcx), %r10
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$4:
	leaq	2048(%rcx), %r10
	call	.Lpolynomial__ntt$1
.Lrow_vector__ntt$3:
	leaq	3072(%rcx), %r10
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
	movq	$0, %rdx
	jmp 	.Lpolynomial__add$2
.Lpolynomial__add$3:
	vmovdqu	(%rsi,%rdx), %ymm0
	vmovdqu	(%rcx,%rdx), %ymm1
	vpaddd	%ymm1, %ymm0, %ymm4
	vmovdqu	%ymm4, (%r10,%rdx)
	addq	$32, %rdx
.Lpolynomial__add$2:
	cmpq	$1024, %rdx
	jb  	.Lpolynomial__add$3
	ret
.Lmatrix_A__rejection_sample_one_block$1:
	movq	$0, %rdi
	lfence
	movq	$0, %r9
	movb	$0, %cl
	cmpq	$256, %rax
	jnb 	.Lmatrix_A__rejection_sample_one_block$10
	movq	$-1, %rdx
	cmovnb	%rdx, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$10:
	movq	$-1, %rcx
	cmovb	%rcx, %r9
	movb	$1, %cl
.Lmatrix_A__rejection_sample_one_block$11:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$3:
	movq	$-1, %rcx
	cmove	%rcx, %r9
	movzbl	(%r8,%rdi), %ecx
	incq	%rdi
	movzbl	(%r8,%rdi), %edx
	incq	%rdi
	movzbl	(%r8,%rdi), %esi
	incq	%rdi
	shll	$8, %edx
	orl 	%edx, %ecx
	shll	$16, %esi
	orl 	%esi, %ecx
	andl	$8388607, %ecx
// declassify_val u32 %ecx
	orl 	%r9d, %ecx
	cmpl	$8380417, %ecx
	jb  	.Lmatrix_A__rejection_sample_one_block$8
	movq	$-1, %rcx
	cmovb	%rcx, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$9
.Lmatrix_A__rejection_sample_one_block$8:
	movq	$-1, %rdx
	cmovnb	%rdx, %r9
	movl	%ecx, (%r10,%rax,4)
	incq	%rax
.Lmatrix_A__rejection_sample_one_block$9:
	movb	$0, %cl
	cmpq	$256, %rax
	jnb 	.Lmatrix_A__rejection_sample_one_block$4
	movq	$-1, %rdx
	cmovnb	%rdx, %r9
	cmpq	$168, %rdi
	jnb 	.Lmatrix_A__rejection_sample_one_block$6
	movq	$-1, %rdx
	cmovnb	%rdx, %r9
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$6:
	movq	$-1, %rcx
	cmovb	%rcx, %r9
	movb	$1, %cl
.Lmatrix_A__rejection_sample_one_block$7:
	jmp 	.Lmatrix_A__rejection_sample_one_block$2
.Lmatrix_A__rejection_sample_one_block$4:
	movq	$-1, %rcx
	cmovb	%rcx, %r9
	movb	$1, %cl
.Lmatrix_A__rejection_sample_one_block$5:
.Lmatrix_A__rejection_sample_one_block$2:
	cmpb	$1, %cl
	jne 	.Lmatrix_A__rejection_sample_one_block$3
	ret
.Lmatrix_A__rejection_sample_multiple_blocks$1:
	lfence
	movq	$0, %rdx
	leaq	glob_data + 5392(%rip), %rsi
	movq	$0, %rdi
	movq	$0, %r8
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r9
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$15:
	movq	$-1, %r9
	cmove	%r9, %rdx
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	glob_data + 576(%rip), %ymm2
	vpermd	%ymm0, %ymm2, %ymm2
	vmovdqu	glob_data + 608(%rip), %ymm0
	vpshufb	%ymm0, %ymm2, %ymm2
	vmovdqu	glob_data + 640(%rip), %ymm0
	vpand	%ymm0, %ymm2, %ymm0
	addq	$24, %r8
	vpcmpgtd	%ymm0, %ymm1, %ymm2
	vpinsrq	$0, %rdx, %xmm3, %xmm3
	vpinsrq	$1, %rdx, %xmm3, %xmm3
	vinserti128	$1, %xmm3, %ymm3, %ymm3
	vpor	%ymm3, %ymm2, %ymm2
	vmovmskps	%ymm2, %r9d
// declassify_val u64 %r9
	vextracti128	$0, %ymm0, %xmm2
	movq	%r9, %r10
	andq	$15, %r10
	movq	%r10, %r11
	shlq	$4, %r11
	vmovdqu	(%rsi,%r11), %xmm4
	vpshufb	%xmm4, %xmm2, %xmm2
	vmovdqu	%xmm2, (%rax,%rdi)
	popcnt	%r10, %r10
	shlq	$2, %r10
	addq	%r10, %rdi
	vextracti128	$1, %ymm0, %xmm0
	shrq	$4, %r9
	movq	%r9, %r11
	shlq	$4, %r11
	vmovdqu	(%rsi,%r11), %xmm4
	vpshufb	%xmm4, %xmm0, %xmm0
	vmovdqu	%xmm0, (%rax,%rdi)
	popcnt	%r9, %r9
	shlq	$2, %r9
	addq	%r9, %rdi
	movq	$0, %r9
	cmpq	$992, %rdi
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$16
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	cmpq	$840, %r8
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$18
	movq	$-1, %r10
	cmovnb	%r10, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$18:
	movq	$-1, %r9
	cmovb	%r9, %rdx
	movq	$1, %r9
.Lmatrix_A__rejection_sample_multiple_blocks$19:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$14
.Lmatrix_A__rejection_sample_multiple_blocks$16:
	movq	$-1, %r9
	cmovb	%r9, %rdx
	movq	$1, %r9
.Lmatrix_A__rejection_sample_multiple_blocks$17:
.Lmatrix_A__rejection_sample_multiple_blocks$14:
	cmpq	$1, %r9
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$15
	movq	$-1, %rsi
	cmovne	%rsi, %rdx
	shrq	$2, %rdi
	movq	$1, %r9
	cmpq	$256, %rdi
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$10
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$10:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	cmpq	$838, %r8
	jb  	.Lmatrix_A__rejection_sample_multiple_blocks$12
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$12:
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	movq	$0, %r9
.Lmatrix_A__rejection_sample_multiple_blocks$13:
.Lmatrix_A__rejection_sample_multiple_blocks$11:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$3:
	movq	$-1, %rsi
	cmove	%rsi, %rdx
	movzbl	(%rcx,%r8), %esi
	incq	%r8
	movzbl	(%rcx,%r8), %r10d
	incq	%r8
	movzbl	(%rcx,%r8), %r9d
	incq	%r8
	shll	$8, %r10d
	orl 	%r10d, %esi
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
	movq	$0, %r9
	cmpq	$256, %rdi
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$4
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	cmpq	$838, %r8
	jnb 	.Lmatrix_A__rejection_sample_multiple_blocks$6
	movq	$-1, %rsi
	cmovnb	%rsi, %rdx
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$6:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %r9
.Lmatrix_A__rejection_sample_multiple_blocks$7:
	jmp 	.Lmatrix_A__rejection_sample_multiple_blocks$2
.Lmatrix_A__rejection_sample_multiple_blocks$4:
	movq	$-1, %rsi
	cmovb	%rsi, %rdx
	movq	$1, %r9
.Lmatrix_A__rejection_sample_multiple_blocks$5:
.Lmatrix_A__rejection_sample_multiple_blocks$2:
	cmpq	$1, %r9
	jne 	.Lmatrix_A__rejection_sample_multiple_blocks$3
	ret
.Lshake256_squeezeblock4x$1:
	call	.L_keccakf1600_avx2x4_nat$1
.Lshake256_squeezeblock4x$6:
	movq	$0, %r8
	movq	$0, %r9
	jmp 	.Lshake256_squeezeblock4x$4
.Lshake256_squeezeblock4x$5:
	vmovdqu	(%rax,%r9,4), %ymm0
	vmovdqu	32(%rax,%r9,4), %ymm1
	vmovdqu	64(%rax,%r9,4), %ymm2
	vmovdqu	96(%rax,%r9,4), %ymm3
	addq	$32, %r9
	vperm2i128	$32, %ymm2, %ymm0, %ymm4
	vperm2i128	$32, %ymm3, %ymm1, %ymm5
	vperm2i128	$49, %ymm2, %ymm0, %ymm2
	vperm2i128	$49, %ymm3, %ymm1, %ymm3
	vpunpcklqdq	%ymm5, %ymm4, %ymm0
	vpunpckhqdq	%ymm5, %ymm4, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm4
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vmovdqu	%ymm0, (%rcx,%r8)
	vmovdqu	%ymm1, (%rdx,%r8)
	vmovdqu	%ymm4, (%rsi,%r8)
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
	movq	$-9223372036854775808, %rcx
	movq	%rcx, 40(%rsp)
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
	movw	(%rcx), %si
	movw	%si, 8(%rsp)
	movw	2(%rcx), %si
	movw	%si, 16(%rsp)
	movw	4(%rcx), %si
	movw	%si, 24(%rsp)
	movw	6(%rcx), %cx
	movw	%cx, 32(%rsp)
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
	movq	$-9223372036854775808, %rcx
	movq	%rcx, 40(%rsp)
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
	cmpq	$8, %rsi
	jb  	.Lhash_verification_key$7
	vmovdqu	(%rcx,%rdx), %ymm0
	vpxor	(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, (%rax)
	vmovdqu	32(%rcx,%rdx), %ymm0
	vpxor	32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rax)
	vmovdqu	64(%rcx,%rdx), %xmm0
	vpxor	64(%rax), %xmm0, %xmm0
	vmovdqu	%xmm0, 64(%rax)
	movq	80(%rcx,%rdx), %r10
	xorq	%r10, 80(%rax)
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 88(%rax)
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
	movq	$0, %r10
	movq	$31, %r9
	shlq	$0, %r9
	orq 	%r9, %r10
	xorq	%r10, 32(%rax)
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
	leaq	glob_data + 672(%rip), %r8
	leaq	glob_data + 704(%rip), %r9
	leaq	glob_data + 7696(%rip), %r10
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
	leaq	glob_data + 7696(%rip), %rbp
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
	leaq	glob_data + 7696(%rip), %r14
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
	vmovdqu	(%r10), %ymm2
	vmovdqu	32(%r10), %ymm8
	vmovdqu	64(%r10), %ymm4
	vmovdqu	96(%r10), %ymm5
	vmovdqu	128(%r10), %ymm6
	vmovdqu	160(%r10), %ymm7
	vmovdqu	192(%r10), %ymm0
	vmovdqu	224(%r10), %ymm1
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm5
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm2
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm2, %ymm9, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm2
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm2, %ymm9, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm7
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm7, %ymm9, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm8
	movl	glob_data + 7944(%rip), %esi
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm9
	vpsubd	%ymm2, %ymm3, %ymm0
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	movl	glob_data + 7948(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm9
	vpsubd	%ymm4, %ymm5, %ymm2
	vpaddd	%ymm5, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm5
	movl	glob_data + 7952(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm9
	vpsubd	%ymm7, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm6, %ymm2, %ymm2
	movl	glob_data + 7956(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm1, %ymm1
	vmovshdup	%ymm9, %ymm8
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7912(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm3, %ymm4, %ymm9
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	movl	glob_data + 7916(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	vmovdqu	%ymm3, (%r10)
	vmovdqu	%ymm0, 32(%r10)
	vmovdqu	%ymm4, 64(%r10)
	vmovdqu	%ymm5, 96(%r10)
	vmovdqu	%ymm1, 128(%r10)
	vmovdqu	%ymm2, 160(%r10)
	vmovdqu	%ymm7, 192(%r10)
	vmovdqu	%ymm6, 224(%r10)
	vmovdqu	256(%r10), %ymm2
	vmovdqu	288(%r10), %ymm8
	vmovdqu	320(%r10), %ymm4
	vmovdqu	352(%r10), %ymm5
	vmovdqu	384(%r10), %ymm6
	vmovdqu	416(%r10), %ymm7
	vmovdqu	448(%r10), %ymm0
	vmovdqu	480(%r10), %ymm1
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7960(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7964(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 7968(%rip), %esi
	vmovd	%esi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 7972(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7920(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7924(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 256(%r10)
	vmovdqu	%ymm2, 288(%r10)
	vmovdqu	%ymm5, 320(%r10)
	vmovdqu	%ymm6, 352(%r10)
	vmovdqu	%ymm0, 384(%r10)
	vmovdqu	%ymm1, 416(%r10)
	vmovdqu	%ymm7, 448(%r10)
	vmovdqu	%ymm4, 480(%r10)
	vmovdqu	512(%r10), %ymm2
	vmovdqu	544(%r10), %ymm8
	vmovdqu	576(%r10), %ymm4
	vmovdqu	608(%r10), %ymm5
	vmovdqu	640(%r10), %ymm6
	vmovdqu	672(%r10), %ymm7
	vmovdqu	704(%r10), %ymm0
	vmovdqu	736(%r10), %ymm1
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7976(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7980(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 7984(%rip), %esi
	vmovd	%esi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 7988(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7928(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7932(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 512(%r10)
	vmovdqu	%ymm2, 544(%r10)
	vmovdqu	%ymm5, 576(%r10)
	vmovdqu	%ymm6, 608(%r10)
	vmovdqu	%ymm0, 640(%r10)
	vmovdqu	%ymm1, 672(%r10)
	vmovdqu	%ymm7, 704(%r10)
	vmovdqu	%ymm4, 736(%r10)
	vmovdqu	768(%r10), %ymm2
	vmovdqu	800(%r10), %ymm8
	vmovdqu	832(%r10), %ymm4
	vmovdqu	864(%r10), %ymm5
	vmovdqu	896(%r10), %ymm6
	vmovdqu	928(%r10), %ymm7
	vmovdqu	960(%r10), %ymm0
	vmovdqu	992(%r10), %ymm1
	vmovdqu	glob_data + 2144(%rip), %ymm3
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm8, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpshufd	$216, %ymm8, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vmovdqu	glob_data + 2176(%rip), %ymm8
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpshufd	$216, %ymm8, %ymm4
	vpshufd	$216, %ymm5, %ymm5
	vmovdqu	glob_data + 2208(%rip), %ymm8
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpunpcklqdq	%ymm7, %ymm6, %ymm8
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpshufd	$216, %ymm8, %ymm6
	vpshufd	$216, %ymm7, %ymm7
	vmovdqu	glob_data + 2240(%rip), %ymm8
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpshufd	$216, %ymm8, %ymm0
	vpshufd	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 1632(%rip), %ymm8
	vpunpcklqdq	%ymm3, %ymm2, %ymm9
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1664(%rip), %ymm8
	vpunpcklqdq	%ymm5, %ymm4, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm4
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1696(%rip), %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm7
	vmovshdup	%ymm10, %ymm6
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm6
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 1728(%rip), %ymm8
	vpunpcklqdq	%ymm1, %ymm0, %ymm9
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm1
	vmovshdup	%ymm10, %ymm9
	vmovshdup	%ymm8, %ymm0
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm0, %ymm9, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm1, %ymm0
	vpunpckhqdq	%ymm8, %ymm1, %ymm1
	vmovdqu	glob_data + 1120(%rip), %ymm8
	vperm2i128	$32, %ymm3, %ymm2, %ymm9
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vpsubd	%ymm9, %ymm2, %ymm10
	vpaddd	%ymm9, %ymm2, %ymm3
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 1152(%rip), %ymm8
	vperm2i128	$32, %ymm5, %ymm4, %ymm9
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm9, %ymm4, %ymm10
	vpaddd	%ymm9, %ymm4, %ymm5
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm4
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 1184(%rip), %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsubd	%ymm9, %ymm6, %ymm10
	vpaddd	%ymm9, %ymm6, %ymm6
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm8, %ymm9
	vpmuldq	%ymm8, %ymm10, %ymm8
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm6, %ymm7
	vperm2i128	$49, %ymm8, %ymm6, %ymm6
	vmovdqu	glob_data + 1216(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm0, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpsubd	%ymm9, %ymm0, %ymm1
	vpaddd	%ymm9, %ymm0, %ymm0
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	vperm2i128	$32, %ymm8, %ymm0, %ymm1
	vperm2i128	$49, %ymm8, %ymm0, %ymm0
	movl	glob_data + 7992(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm2, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm2, %ymm3
	vmovshdup	%ymm9, %ymm2
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7996(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm4, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm4, %ymm5
	vmovshdup	%ymm9, %ymm4
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm4, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm8
	movl	glob_data + 8000(%rip), %esi
	vmovd	%esi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm6, %ymm9
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovshdup	%ymm9, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm9
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm4, %ymm9, %ymm4
	movl	glob_data + 8004(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm1, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm1, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	glob_data + 7936(%rip), %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm3, %ymm5, %ymm9
	vpaddd	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm6, %ymm8, %ymm6
	movl	glob_data + 7940(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm7, %ymm0, %ymm9
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm4, %ymm8, %ymm4
	vmovdqu	%ymm3, 768(%r10)
	vmovdqu	%ymm2, 800(%r10)
	vmovdqu	%ymm5, 832(%r10)
	vmovdqu	%ymm6, 864(%r10)
	vmovdqu	%ymm0, 896(%r10)
	vmovdqu	%ymm1, 928(%r10)
	vmovdqu	%ymm7, 960(%r10)
	vmovdqu	%ymm4, 992(%r10)
	vmovdqu	(%r10), %ymm2
	vmovdqu	128(%r10), %ymm8
	vmovdqu	256(%r10), %ymm0
	vmovdqu	384(%r10), %ymm1
	vmovdqu	512(%r10), %ymm3
	vmovdqu	640(%r10), %ymm4
	vmovdqu	768(%r10), %ymm5
	vmovdqu	896(%r10), %ymm6
	movl	glob_data + 7896(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm7
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7900(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm0, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm0, %ymm1
	vmovshdup	%ymm9, %ymm0
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm0, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm8
	movl	glob_data + 7904(%rip), %esi
	vmovd	%esi, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpsubd	%ymm3, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm3, %ymm9
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm10, %ymm0
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	movl	glob_data + 7908(%rip), %esi
	vmovd	%esi, %xmm4
	vpbroadcastd	%xmm4, %ymm3
	vpsubd	%ymm5, %ymm6, %ymm4
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm4, %ymm3, %ymm6
	movl	glob_data + 7888(%rip), %esi
	vmovd	%esi, %xmm4
	vpbroadcastd	%xmm4, %ymm4
	vpsubd	%ymm7, %ymm1, %ymm3
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovshdup	%ymm3, %ymm7
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7892(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm11, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	$-3975713, %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm7
	movl	$41978, %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	vpsubd	%ymm1, %ymm9, %ymm11
	vpaddd	%ymm9, %ymm1, %ymm8
	vmovshdup	%ymm11, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm11, %ymm1
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm1, %ymm1
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm9, %ymm1, %ymm1
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm10, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm4
	vmovshdup	%ymm0, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm0, %ymm0
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm6, %ymm0, %ymm6
	vmovdqu	%ymm8, (%r10)
	vmovdqu	%ymm9, 128(%r10)
	vmovdqu	%ymm3, 256(%r10)
	vmovdqu	%ymm6, 384(%r10)
	vmovdqu	%ymm1, 512(%r10)
	vmovdqu	%ymm2, 640(%r10)
	vmovdqu	%ymm5, 768(%r10)
	vmovdqu	%ymm4, 896(%r10)
	vmovdqu	32(%r10), %ymm2
	vmovdqu	160(%r10), %ymm8
	vmovdqu	288(%r10), %ymm0
	vmovdqu	416(%r10), %ymm1
	vmovdqu	544(%r10), %ymm3
	vmovdqu	672(%r10), %ymm4
	vmovdqu	800(%r10), %ymm5
	vmovdqu	928(%r10), %ymm6
	movl	glob_data + 7896(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm2, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm2, %ymm7
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm2, %ymm8, %ymm2
	movl	glob_data + 7900(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm0, %ymm1, %ymm9
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7904(%rip), %esi
	vmovd	%esi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm3, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm3, %ymm9
	vmovshdup	%ymm10, %ymm4
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm3, %ymm4, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm4
	movl	glob_data + 7908(%rip), %esi
	vmovd	%esi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm5, %ymm6, %ymm3
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm6
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm6
	movl	glob_data + 7888(%rip), %esi
	vmovd	%esi, %xmm1
	vpbroadcastd	%xmm1, %ymm3
	vpsubd	%ymm7, %ymm0, %ymm1
	vpaddd	%ymm0, %ymm7, %ymm0
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm3, %ymm10
	vpmuldq	%ymm3, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm3
	movl	glob_data + 7892(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm4
	movl	$-3975713, %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm0, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm0, %ymm8
	vmovshdup	%ymm9, %ymm0
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm0, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm9, %ymm9
	vpsubq	%ymm12, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm9
	vpblendd	$170, %ymm0, %ymm9, %ymm0
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm10, %ymm2, %ymm2
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm1, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm3, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm6, %ymm3, %ymm6
	vmovdqu	%ymm8, 32(%r10)
	vmovdqu	%ymm9, 160(%r10)
	vmovdqu	%ymm1, 288(%r10)
	vmovdqu	%ymm6, 416(%r10)
	vmovdqu	%ymm0, 544(%r10)
	vmovdqu	%ymm2, 672(%r10)
	vmovdqu	%ymm5, 800(%r10)
	vmovdqu	%ymm4, 928(%r10)
	vmovdqu	64(%r10), %ymm0
	vmovdqu	192(%r10), %ymm8
	vmovdqu	320(%r10), %ymm1
	vmovdqu	448(%r10), %ymm3
	vmovdqu	576(%r10), %ymm2
	vmovdqu	704(%r10), %ymm4
	vmovdqu	832(%r10), %ymm5
	vmovdqu	960(%r10), %ymm6
	movl	glob_data + 7896(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm10, %ymm0
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	glob_data + 7900(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm1, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm1, %ymm3
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7904(%rip), %esi
	vmovd	%esi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm2, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm2, %ymm9
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	movl	glob_data + 7908(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm5, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm6
	movl	glob_data + 7888(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm7, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm7, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm3
	vpmuldq	%ymm4, %ymm10, %ymm10
	vpmuldq	%ymm3, %ymm7, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7892(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm7, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	$-3975713, %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm8
	vmovshdup	%ymm9, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm2
	vpmuldq	%ymm12, %ymm11, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm1, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm8, 64(%r10)
	vmovdqu	%ymm9, 192(%r10)
	vmovdqu	%ymm3, 320(%r10)
	vmovdqu	%ymm6, 448(%r10)
	vmovdqu	%ymm2, 576(%r10)
	vmovdqu	%ymm0, 704(%r10)
	vmovdqu	%ymm5, 832(%r10)
	vmovdqu	%ymm4, 960(%r10)
	vmovdqu	96(%r10), %ymm0
	vmovdqu	224(%r10), %ymm8
	vmovdqu	352(%r10), %ymm1
	vmovdqu	480(%r10), %ymm3
	vmovdqu	608(%r10), %ymm2
	vmovdqu	736(%r10), %ymm4
	vmovdqu	864(%r10), %ymm5
	vmovdqu	992(%r10), %ymm6
	movl	glob_data + 7896(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm9
	vpsubd	%ymm0, %ymm8, %ymm10
	vpaddd	%ymm8, %ymm0, %ymm7
	vmovshdup	%ymm10, %ymm0
	vmovshdup	%ymm9, %ymm8
	vpmuldq	%ymm9, %ymm10, %ymm9
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm9, %ymm8
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm0, %ymm8, %ymm0
	movl	glob_data + 7900(%rip), %esi
	vmovd	%esi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vpsubd	%ymm1, %ymm3, %ymm9
	vpaddd	%ymm3, %ymm1, %ymm3
	vmovshdup	%ymm9, %ymm1
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm9, %ymm8
	vpmuldq	%ymm10, %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm1
	vpsubq	%ymm11, %ymm9, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm8
	movl	glob_data + 7904(%rip), %esi
	vmovd	%esi, %xmm1
	vpbroadcastd	%xmm1, %ymm1
	vpsubd	%ymm2, %ymm4, %ymm10
	vpaddd	%ymm4, %ymm2, %ymm9
	vmovshdup	%ymm10, %ymm2
	vmovshdup	%ymm1, %ymm12
	vpmuldq	%ymm1, %ymm10, %ymm1
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm1
	movl	glob_data + 7908(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm5, %ymm6, %ymm2
	vpaddd	%ymm6, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm6
	vmovshdup	%ymm4, %ymm10
	vpmuldq	%ymm4, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm6, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm4, %ymm2, %ymm6
	movl	glob_data + 7888(%rip), %esi
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm4
	vpsubd	%ymm7, %ymm3, %ymm10
	vpaddd	%ymm3, %ymm7, %ymm2
	vmovshdup	%ymm10, %ymm7
	vmovshdup	%ymm4, %ymm3
	vpmuldq	%ymm4, %ymm10, %ymm10
	vpmuldq	%ymm3, %ymm7, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	movl	glob_data + 7892(%rip), %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm9, %ymm5, %ymm10
	vpaddd	%ymm5, %ymm9, %ymm8
	vmovshdup	%ymm10, %ymm5
	vmovshdup	%ymm7, %ymm9
	vpmuldq	%ymm7, %ymm10, %ymm10
	vpmuldq	%ymm9, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm9, %ymm7, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm1
	movl	$-3975713, %esi
	vmovd	%esi, %xmm6
	vpbroadcastd	%xmm6, %ymm6
	movl	$41978, %esi
	vmovd	%esi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vpsubd	%ymm2, %ymm8, %ymm9
	vpaddd	%ymm8, %ymm2, %ymm8
	vmovshdup	%ymm9, %ymm11
	vmovshdup	%ymm6, %ymm12
	vpmuldq	%ymm6, %ymm9, %ymm2
	vpmuldq	%ymm12, %ymm11, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm2, %ymm2
	vpsubq	%ymm12, %ymm9, %ymm9
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm9, %ymm2, %ymm2
	vmovshdup	%ymm8, %ymm9
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm8, %ymm8
	vpmuldq	%ymm12, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm0, %ymm0
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm10, %ymm0, %ymm0
	vmovshdup	%ymm9, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
	vpsubq	%ymm11, %ymm5, %ymm5
	vpsubq	%ymm12, %ymm10, %ymm10
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm10, %ymm5, %ymm5
	vmovshdup	%ymm3, %ymm10
	vmovshdup	%ymm7, %ymm12
	vpmuldq	%ymm7, %ymm3, %ymm3
	vpmuldq	%ymm12, %ymm10, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm12
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm12, %ymm12
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
	vpmuldq	glob_data + 4736(%rip), %ymm10, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm10, %ymm10
	vpsubq	%ymm11, %ymm4, %ymm4
	vmovshdup	%ymm10, %ymm10
	vpblendd	$170, %ymm4, %ymm10, %ymm4
	vmovshdup	%ymm1, %ymm6
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm6, %ymm1, %ymm6
	vmovdqu	%ymm8, 96(%r10)
	vmovdqu	%ymm9, 224(%r10)
	vmovdqu	%ymm3, 352(%r10)
	vmovdqu	%ymm6, 480(%r10)
	vmovdqu	%ymm2, 608(%r10)
	vmovdqu	%ymm0, 736(%r10)
	vmovdqu	%ymm5, 864(%r10)
	vmovdqu	%ymm4, 992(%r10)
	ret
.Lpolynomial__ntt$1:
	vmovdqu	(%r10), %ymm1
	vmovdqu	128(%r10), %ymm3
	vmovdqu	256(%r10), %ymm5
	vmovdqu	384(%r10), %ymm7
	vmovdqu	512(%r10), %ymm0
	vmovdqu	640(%r10), %ymm2
	vmovdqu	768(%r10), %ymm4
	vmovdqu	896(%r10), %ymm6
	movq	$25847, %rsi
	vmovq	%rsi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm3, %ymm8
	vpaddd	%ymm9, %ymm3, %ymm9
	movq	$-518909, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2272(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2304(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, (%r10)
	vmovdqu	%ymm9, 128(%r10)
	vmovdqu	%ymm5, 256(%r10)
	vmovdqu	%ymm6, 384(%r10)
	vmovdqu	%ymm0, 512(%r10)
	vmovdqu	%ymm2, 640(%r10)
	vmovdqu	%ymm7, 768(%r10)
	vmovdqu	%ymm8, 896(%r10)
	vmovdqu	32(%r10), %ymm1
	vmovdqu	160(%r10), %ymm3
	vmovdqu	288(%r10), %ymm5
	vmovdqu	416(%r10), %ymm7
	vmovdqu	544(%r10), %ymm0
	vmovdqu	672(%r10), %ymm2
	vmovdqu	800(%r10), %ymm4
	vmovdqu	928(%r10), %ymm6
	movq	$25847, %rsi
	vmovq	%rsi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2272(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2304(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 32(%r10)
	vmovdqu	%ymm9, 160(%r10)
	vmovdqu	%ymm5, 288(%r10)
	vmovdqu	%ymm6, 416(%r10)
	vmovdqu	%ymm0, 544(%r10)
	vmovdqu	%ymm2, 672(%r10)
	vmovdqu	%ymm7, 800(%r10)
	vmovdqu	%ymm8, 928(%r10)
	vmovdqu	64(%r10), %ymm1
	vmovdqu	192(%r10), %ymm3
	vmovdqu	320(%r10), %ymm5
	vmovdqu	448(%r10), %ymm7
	vmovdqu	576(%r10), %ymm0
	vmovdqu	704(%r10), %ymm2
	vmovdqu	832(%r10), %ymm4
	vmovdqu	960(%r10), %ymm6
	movq	$25847, %rsi
	vmovq	%rsi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2272(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2304(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 64(%r10)
	vmovdqu	%ymm9, 192(%r10)
	vmovdqu	%ymm5, 320(%r10)
	vmovdqu	%ymm6, 448(%r10)
	vmovdqu	%ymm0, 576(%r10)
	vmovdqu	%ymm2, 704(%r10)
	vmovdqu	%ymm7, 832(%r10)
	vmovdqu	%ymm8, 960(%r10)
	vmovdqu	96(%r10), %ymm1
	vmovdqu	224(%r10), %ymm3
	vmovdqu	352(%r10), %ymm5
	vmovdqu	480(%r10), %ymm7
	vmovdqu	608(%r10), %ymm0
	vmovdqu	736(%r10), %ymm2
	vmovdqu	864(%r10), %ymm4
	vmovdqu	992(%r10), %ymm6
	movq	$25847, %rsi
	vmovq	%rsi, %xmm8
	vpbroadcastd	%xmm8, %ymm8
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm5, %ymm8, %ymm5
	vpsubd	%ymm5, %ymm7, %ymm6
	vpaddd	%ymm5, %ymm7, %ymm8
	movq	$-2608894, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm9, %ymm5
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm8, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm3, %ymm8
	vpaddd	%ymm7, %ymm3, %ymm9
	movq	$-518909, %rsi
	vmovq	%rsi, %xmm7
	vpbroadcastd	%xmm7, %ymm7
	vmovshdup	%ymm4, %ymm10
	vmovshdup	%ymm7, %ymm3
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm6, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm4, %ymm4
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm4, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm2, %ymm4
	vpaddd	%ymm6, %ymm2, %ymm2
	vmovdqu	glob_data + 2272(%rip), %ymm6
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm9, %ymm9
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm9, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm6, %ymm1, %ymm1
	vmovdqu	glob_data + 2304(%rip), %ymm6
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm8, %ymm8
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm10, %ymm8, %ymm7
	vpsubq	%ymm11, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm5
	vmovdqu	glob_data + 2336(%rip), %ymm7
	vmovshdup	%ymm2, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm7
	vpsubd	%ymm7, %ymm0, %ymm2
	vpaddd	%ymm7, %ymm0, %ymm0
	vmovdqu	glob_data + 2368(%rip), %ymm7
	vmovshdup	%ymm4, %ymm8
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm8, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm7, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm7
	vmovdqu	%ymm1, 96(%r10)
	vmovdqu	%ymm9, 224(%r10)
	vmovdqu	%ymm5, 352(%r10)
	vmovdqu	%ymm6, 480(%r10)
	vmovdqu	%ymm0, 608(%r10)
	vmovdqu	%ymm2, 736(%r10)
	vmovdqu	%ymm7, 864(%r10)
	vmovdqu	%ymm8, 992(%r10)
	vmovdqu	(%r10), %ymm1
	vmovdqu	32(%r10), %ymm2
	vmovdqu	64(%r10), %ymm0
	vmovdqu	96(%r10), %ymm3
	vmovdqu	128(%r10), %ymm4
	vmovdqu	160(%r10), %ymm5
	vmovdqu	192(%r10), %ymm6
	vmovdqu	224(%r10), %ymm8
	vmovdqu	glob_data + 2400(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm8
	vmovdqu	glob_data + 2656(%rip), %ymm5
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm9
	vmovdqu	glob_data + 2688(%rip), %ymm1
	vmovshdup	%ymm3, %ymm5
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm1
	vpaddd	%ymm5, %ymm0, %ymm10
	vmovdqu	glob_data + 2720(%rip), %ymm0
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm8, %ymm0
	vpmuldq	%ymm3, %ymm5, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm8, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm3
	vpaddd	%ymm5, %ymm4, %ymm0
	vmovdqu	glob_data + 2752(%rip), %ymm4
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm6, %ymm4
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3168(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3264(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm2
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3680(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3776(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm2, %ymm8
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm2
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
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	glob_data + 4288(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	%ymm8, (%r10)
	vmovdqu	%ymm9, 32(%r10)
	vmovdqu	%ymm1, 64(%r10)
	vmovdqu	%ymm4, 96(%r10)
	vmovdqu	%ymm0, 128(%r10)
	vmovdqu	%ymm3, 160(%r10)
	vmovdqu	%ymm7, 192(%r10)
	vmovdqu	%ymm6, 224(%r10)
	vmovdqu	256(%r10), %ymm0
	vmovdqu	288(%r10), %ymm2
	vmovdqu	320(%r10), %ymm1
	vmovdqu	352(%r10), %ymm4
	vmovdqu	384(%r10), %ymm5
	vmovdqu	416(%r10), %ymm6
	vmovdqu	448(%r10), %ymm7
	vmovdqu	480(%r10), %ymm8
	vmovdqu	glob_data + 2464(%rip), %ymm9
	vmovshdup	%ymm1, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm0, %ymm0
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm0, %ymm4, %ymm9
	vpsubd	%ymm9, %ymm2, %ymm4
	vpaddd	%ymm9, %ymm2, %ymm2
	vmovdqu	glob_data + 2496(%rip), %ymm9
	vmovshdup	%ymm7, %ymm0
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	%ymm10, %ymm0, %ymm0
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm8, %ymm8
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm8, %ymm8
	vpblendd	$170, %ymm7, %ymm8, %ymm7
	vpsubd	%ymm7, %ymm6, %ymm8
	vpaddd	%ymm7, %ymm6, %ymm6
	vmovdqu	glob_data + 2784(%rip), %ymm7
	vmovshdup	%ymm2, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm9, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm7, %ymm2, %ymm9
	vpsubd	%ymm9, %ymm1, %ymm7
	vpaddd	%ymm9, %ymm1, %ymm9
	vmovdqu	glob_data + 2816(%rip), %ymm1
	vmovshdup	%ymm4, %ymm2
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm4, %ymm1
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm4, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm2, %ymm2
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm2, %ymm1, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm1
	vpaddd	%ymm4, %ymm3, %ymm10
	vmovdqu	glob_data + 2848(%rip), %ymm3
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm3, %ymm12
	vpmuldq	%ymm3, %ymm6, %ymm3
	vpmuldq	%ymm12, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm4, %ymm3, %ymm3
	vpsubq	%ymm11, %ymm2, %ymm2
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm2, %ymm3, %ymm4
	vpsubd	%ymm4, %ymm5, %ymm3
	vpaddd	%ymm4, %ymm5, %ymm2
	vmovdqu	glob_data + 2880(%rip), %ymm4
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm4, %ymm6
	vpmuldq	%ymm4, %ymm8, %ymm4
	vpmuldq	%ymm6, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm0, %ymm5
	vpaddd	%ymm4, %ymm0, %ymm0
	vmovdqu	glob_data + 3296(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3360(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm2, %ymm8
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm2
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3392(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm0, %ymm8
	vperm2i128	$49, %ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm5
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm0
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 3808(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 3872(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm2, %ymm8
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm3, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm3
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm2
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3904(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm0, %ymm8
	vpunpckhqdq	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm5, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm5
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm0
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
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	glob_data + 4416(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm0, %ymm7
	vpunpckhqdq	%ymm5, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	%ymm8, 256(%r10)
	vmovdqu	%ymm9, 288(%r10)
	vmovdqu	%ymm1, 320(%r10)
	vmovdqu	%ymm4, 352(%r10)
	vmovdqu	%ymm2, 384(%r10)
	vmovdqu	%ymm3, 416(%r10)
	vmovdqu	%ymm7, 448(%r10)
	vmovdqu	%ymm6, 480(%r10)
	vmovdqu	512(%r10), %ymm1
	vmovdqu	544(%r10), %ymm2
	vmovdqu	576(%r10), %ymm0
	vmovdqu	608(%r10), %ymm3
	vmovdqu	640(%r10), %ymm4
	vmovdqu	672(%r10), %ymm5
	vmovdqu	704(%r10), %ymm6
	vmovdqu	736(%r10), %ymm8
	vmovdqu	glob_data + 2528(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2560(%rip), %ymm7
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	%ymm8, 512(%r10)
	vmovdqu	%ymm9, 544(%r10)
	vmovdqu	%ymm1, 576(%r10)
	vmovdqu	%ymm4, 608(%r10)
	vmovdqu	%ymm0, 640(%r10)
	vmovdqu	%ymm3, 672(%r10)
	vmovdqu	%ymm7, 704(%r10)
	vmovdqu	%ymm6, 736(%r10)
	vmovdqu	768(%r10), %ymm1
	vmovdqu	800(%r10), %ymm2
	vmovdqu	832(%r10), %ymm0
	vmovdqu	864(%r10), %ymm3
	vmovdqu	896(%r10), %ymm4
	vmovdqu	928(%r10), %ymm5
	vmovdqu	960(%r10), %ymm6
	vmovdqu	992(%r10), %ymm8
	vmovdqu	glob_data + 2592(%rip), %ymm7
	vmovshdup	%ymm0, %ymm9
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm0, %ymm0
	vpmuldq	%ymm10, %ymm9, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm9, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm3, %ymm3
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm3, %ymm3
	vpblendd	$170, %ymm7, %ymm3, %ymm7
	vpsubd	%ymm7, %ymm2, %ymm3
	vpaddd	%ymm7, %ymm2, %ymm9
	vmovdqu	glob_data + 2624(%rip), %ymm7
	vmovshdup	%ymm6, %ymm2
	vmovshdup	%ymm7, %ymm10
	vpmuldq	%ymm7, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm8, %ymm7, %ymm7
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm7, %ymm7
	vpblendd	$170, %ymm6, %ymm7, %ymm7
	vpsubd	%ymm7, %ymm5, %ymm6
	vpaddd	%ymm7, %ymm5, %ymm8
	vmovdqu	glob_data + 3040(%rip), %ymm5
	vmovshdup	%ymm9, %ymm7
	vmovshdup	%ymm5, %ymm10
	vpmuldq	%ymm5, %ymm9, %ymm5
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm5, %ymm5
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm5, %ymm5
	vpblendd	$170, %ymm7, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm9
	vmovdqu	glob_data + 3072(%rip), %ymm1
	vmovshdup	%ymm3, %ymm5
	vmovshdup	%ymm1, %ymm10
	vpmuldq	%ymm1, %ymm3, %ymm1
	vpmuldq	%ymm10, %ymm5, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm10, %ymm1, %ymm1
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm3, %ymm1, %ymm5
	vpsubd	%ymm5, %ymm0, %ymm1
	vpaddd	%ymm5, %ymm0, %ymm10
	vmovdqu	glob_data + 3104(%rip), %ymm0
	vmovshdup	%ymm8, %ymm5
	vmovshdup	%ymm0, %ymm3
	vpmuldq	%ymm0, %ymm8, %ymm0
	vpmuldq	%ymm3, %ymm5, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm8, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm3
	vpaddd	%ymm5, %ymm4, %ymm0
	vmovdqu	glob_data + 3136(%rip), %ymm4
	vmovshdup	%ymm6, %ymm5
	vmovshdup	%ymm4, %ymm8
	vpmuldq	%ymm4, %ymm6, %ymm4
	vpmuldq	%ymm8, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm6, %ymm4, %ymm4
	vpsubq	%ymm11, %ymm5, %ymm5
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm5, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm5
	vpaddd	%ymm4, %ymm2, %ymm2
	vmovdqu	glob_data + 3552(%rip), %ymm6
	vperm2i128	$32, %ymm7, %ymm9, %ymm4
	vperm2i128	$49, %ymm7, %ymm9, %ymm8
	vmovshdup	%ymm8, %ymm7
	vmovshdup	%ymm6, %ymm9
	vpmuldq	%ymm6, %ymm8, %ymm6
	vpmuldq	%ymm9, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm8, %ymm8
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
	vpsubq	%ymm8, %ymm6, %ymm6
	vpsubq	%ymm11, %ymm7, %ymm7
	vmovshdup	%ymm6, %ymm6
	vpblendd	$170, %ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm6
	vperm2i128	$32, %ymm6, %ymm7, %ymm4
	vperm2i128	$49, %ymm6, %ymm7, %ymm6
	vmovdqu	glob_data + 3584(%rip), %ymm8
	vperm2i128	$32, %ymm1, %ymm10, %ymm7
	vperm2i128	$49, %ymm1, %ymm10, %ymm1
	vmovshdup	%ymm1, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm8, %ymm8
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm8, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm8
	vpsubd	%ymm1, %ymm7, %ymm7
	vperm2i128	$32, %ymm7, %ymm8, %ymm1
	vperm2i128	$49, %ymm7, %ymm8, %ymm7
	vmovdqu	glob_data + 3616(%rip), %ymm9
	vperm2i128	$32, %ymm3, %ymm0, %ymm8
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm3, %ymm0
	vperm2i128	$49, %ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 3648(%rip), %ymm9
	vperm2i128	$32, %ymm5, %ymm2, %ymm8
	vperm2i128	$49, %ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vperm2i128	$32, %ymm8, %ymm5, %ymm2
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4064(%rip), %ymm9
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vmovshdup	%ymm4, %ymm6
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm4, %ymm4
	vpmuldq	%ymm10, %ymm6, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm4, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm4, %ymm4
	vpsubq	%ymm10, %ymm6, %ymm6
	vmovshdup	%ymm4, %ymm4
	vpblendd	$170, %ymm6, %ymm4, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm9
	vpsubd	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovdqu	glob_data + 4096(%rip), %ymm9
	vpunpcklqdq	%ymm7, %ymm1, %ymm8
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm7
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm7, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm1, %ymm1
	vpsubq	%ymm10, %ymm7, %ymm7
	vmovshdup	%ymm1, %ymm1
	vpblendd	$170, %ymm7, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm8, %ymm7
	vpsubd	%ymm1, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm7, %ymm1
	vpunpckhqdq	%ymm8, %ymm7, %ymm7
	vmovdqu	glob_data + 4128(%rip), %ymm9
	vpunpcklqdq	%ymm3, %ymm0, %ymm8
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm9, %ymm3
	vpmuldq	%ymm9, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm0, %ymm0
	vpsubq	%ymm10, %ymm3, %ymm3
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm3, %ymm0, %ymm0
	vpaddd	%ymm0, %ymm8, %ymm3
	vpsubd	%ymm0, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm3, %ymm0
	vpunpckhqdq	%ymm8, %ymm3, %ymm3
	vmovdqu	glob_data + 4160(%rip), %ymm9
	vpunpcklqdq	%ymm5, %ymm2, %ymm8
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm9, %ymm10
	vpmuldq	%ymm9, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpsubq	%ymm9, %ymm2, %ymm2
	vpsubq	%ymm10, %ymm5, %ymm5
	vmovshdup	%ymm2, %ymm2
	vpblendd	$170, %ymm5, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm5
	vpsubd	%ymm2, %ymm8, %ymm8
	vpunpcklqdq	%ymm8, %ymm5, %ymm2
	vpunpckhqdq	%ymm8, %ymm5, %ymm5
	vmovdqu	glob_data + 4576(%rip), %ymm8
	vpshufd	$216, %ymm4, %ymm9
	vpshufd	$216, %ymm6, %ymm6
	vpunpcklqdq	%ymm6, %ymm9, %ymm4
	vpunpckhqdq	%ymm6, %ymm9, %ymm6
	vmovshdup	%ymm6, %ymm9
	vmovshdup	%ymm8, %ymm10
	vpmuldq	%ymm8, %ymm6, %ymm6
	vpmuldq	%ymm10, %ymm9, %ymm8
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm9
	vpmuldq	glob_data + 4736(%rip), %ymm8, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm9, %ymm9
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	glob_data + 4608(%rip), %ymm6
	vpshufd	$216, %ymm1, %ymm1
	vpshufd	$216, %ymm7, %ymm7
	vpunpcklqdq	%ymm7, %ymm1, %ymm4
	vpunpckhqdq	%ymm7, %ymm1, %ymm1
	vmovshdup	%ymm1, %ymm7
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm1, %ymm1
	vpmuldq	%ymm10, %ymm7, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm1, %ymm10
	vpmuldq	glob_data + 4736(%rip), %ymm6, %ymm11
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm11, %ymm11
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
	vmovdqu	glob_data + 4640(%rip), %ymm6
	vpshufd	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm3, %ymm3
	vpunpcklqdq	%ymm3, %ymm0, %ymm7
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vmovshdup	%ymm0, %ymm10
	vmovshdup	%ymm6, %ymm3
	vpmuldq	%ymm6, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm10, %ymm3
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm3, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	glob_data + 4672(%rip), %ymm6
	vpshufd	$216, %ymm2, %ymm2
	vpshufd	$216, %ymm5, %ymm5
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm2, %ymm5
	vmovshdup	%ymm6, %ymm10
	vpmuldq	%ymm6, %ymm2, %ymm2
	vpmuldq	%ymm10, %ymm5, %ymm5
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm6
	vpmuldq	glob_data + 4736(%rip), %ymm5, %ymm10
	vpmuldq	glob_data + 5344(%rip), %ymm6, %ymm6
	vpmuldq	glob_data + 5344(%rip), %ymm10, %ymm10
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
	vmovdqu	%ymm8, 768(%r10)
	vmovdqu	%ymm9, 800(%r10)
	vmovdqu	%ymm1, 832(%r10)
	vmovdqu	%ymm4, 864(%r10)
	vmovdqu	%ymm0, 896(%r10)
	vmovdqu	%ymm3, 928(%r10)
	vmovdqu	%ymm7, 960(%r10)
	vmovdqu	%ymm6, 992(%r10)
	ret
.Lpolynomial__reduce32$1:
	vmovdqu	glob_data + 4704(%rip), %ymm0
	vmovdqu	glob_data + 5344(%rip), %ymm1
	movq	$0, %r9
	jmp 	.Lpolynomial__reduce32$2
.Lpolynomial__reduce32$3:
	vmovdqu	(%r8,%r9), %ymm2
	vpaddd	%ymm0, %ymm2, %ymm4
	vpsrad	$23, %ymm4, %ymm4
	vpmulld	%ymm1, %ymm4, %ymm4
	vpsubd	%ymm4, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r8,%r9)
	addq	$32, %r9
.Lpolynomial__reduce32$2:
	cmpq	$1024, %r9
	jb  	.Lpolynomial__reduce32$3
	ret
.Lpolynomial__conditionally_add_modulus$1:
	vmovdqu	glob_data + 5344(%rip), %ymm1
	vpxor	%ymm0, %ymm0, %ymm0
	movq	$0, %rdx
	jmp 	.Lpolynomial__conditionally_add_modulus$2
.Lpolynomial__conditionally_add_modulus$3:
	vmovdqu	(%r8,%rdx), %ymm2
	vpcmpgtd	%ymm2, %ymm0, %ymm3
	vpand	%ymm3, %ymm1, %ymm3
	vpaddd	%ymm3, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r8,%rdx)
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
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%r8)
	addq	$32, %r8
	vmovdqu	(%rcx,%r8), %ymm0
	vmovdqu	(%rdx,%r8), %ymm1
	vmovshdup	%ymm0, %ymm2
	vmovshdup	%ymm1, %ymm3
	vpmuldq	%ymm1, %ymm0, %ymm0
	vpmuldq	%ymm3, %ymm2, %ymm2
	vpmuldq	glob_data + 4736(%rip), %ymm0, %ymm4
	vpmuldq	glob_data + 4736(%rip), %ymm2, %ymm5
	vpmuldq	glob_data + 5344(%rip), %ymm4, %ymm4
	vpmuldq	glob_data + 5344(%rip), %ymm5, %ymm5
	vpsubq	%ymm4, %ymm0, %ymm0
	vpsubq	%ymm5, %ymm2, %ymm2
	vmovshdup	%ymm0, %ymm0
	vpblendd	$170, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm0, (%r10,%r8)
	addq	$32, %r8
.Lpolynomial__pointwise_montgomery_multiply_and_reduce$2:
	cmpq	$1024, %r8
	jb  	.Lpolynomial__pointwise_montgomery_multiply_and_reduce$3
	ret
.Lpolynomial__use_hints_gamma2_88$1:
	vmovdqu	glob_data + 4896(%rip), %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	leaq	1056(%rsp), %rdx
	leaq	32(%rsp), %rsi
	call	.Lpolynomial__decompose_gamma2_88$1
.Lpolynomial__use_hints_gamma2_88$4:
	movq	$0, %rdx
	jmp 	.Lpolynomial__use_hints_gamma2_88$2
.Lpolynomial__use_hints_gamma2_88$3:
	vmovdqu	1056(%rsp,%rdx), %ymm2
	vmovdqu	32(%rsp,%rdx), %ymm3
	vmovdqu	(%rcx,%rdx), %ymm4
	vpcmpgtd	%ymm1, %ymm2, %ymm2
	vpblendvb	%ymm2, %ymm1, %ymm4, %ymm5
	vpslld	$1, %ymm5, %ymm5
	vpsubd	%ymm5, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm3, %ymm2
	vpblendvb	%ymm2, %ymm0, %ymm2, %ymm2
	vpcmpgtd	%ymm0, %ymm2, %ymm4
	vpblendvb	%ymm4, %ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%r8,%rdx)
	addq	$32, %rdx
.Lpolynomial__use_hints_gamma2_88$2:
	cmpq	$1024, %rdx
	jb  	.Lpolynomial__use_hints_gamma2_88$3
	ret
.Lpolynomial__decompose_gamma2_88$1:
	vmovdqu	glob_data + 5344(%rip), %ymm2
	vpsrld	$1, %ymm2, %ymm3
	vmovdqu	glob_data + 4768(%rip), %ymm4
	vmovdqu	glob_data + 4800(%rip), %ymm5
	vmovdqu	glob_data + 4832(%rip), %ymm6
	vmovdqu	glob_data + 4864(%rip), %ymm7
	vmovdqu	glob_data + 4896(%rip), %ymm8
	vpxor	%ymm9, %ymm9, %ymm9
	movq	$0, %r9
	jmp 	.Lpolynomial__decompose_gamma2_88$2
.Lpolynomial__decompose_gamma2_88$3:
	vmovdqu	(%r8,%r9), %ymm10
	vpcmpgtd	%ymm10, %ymm9, %ymm11
	vpand	%ymm2, %ymm11, %ymm11
	vpaddd	%ymm11, %ymm10, %ymm10
	vpaddd	%ymm6, %ymm10, %ymm11
	vpsrld	$7, %ymm11, %ymm11
	vpmulhuw	%ymm4, %ymm11, %ymm11
	vpmulhrsw	%ymm7, %ymm11, %ymm11
	vpsubd	%ymm11, %ymm8, %ymm12
	vpcmpgtd	%ymm12, %ymm9, %ymm12
	vpandn	%ymm11, %ymm12, %ymm11
	vpmulld	%ymm5, %ymm11, %ymm12
	vpsubd	%ymm12, %ymm10, %ymm12
	vpcmpgtd	%ymm3, %ymm12, %ymm10
	vpand	%ymm2, %ymm10, %ymm10
	vpsubd	%ymm10, %ymm12, %ymm12
	vmovdqu	%ymm12, (%rdx,%r9)
	vmovdqu	%ymm11, (%rsi,%r9)
	addq	$32, %r9
.Lpolynomial__decompose_gamma2_88$2:
	cmpq	$1024, %r9
	jb  	.Lpolynomial__decompose_gamma2_88$3
	ret
.Lgamma1__coefficients_to_bytestream_bits18$1:
	vpsubd	%ymm2, %ymm0, %ymm2
	vmovdqu	glob_data + 4992(%rip), %ymm3
	vpsllvd	%ymm3, %ymm2, %ymm2
	vpsrlq	$14, %ymm2, %ymm2
	vpsrldq	$8, %ymm2, %ymm1
	vpsllq	$36, %ymm1, %ymm1
	vpaddq	%ymm1, %ymm2, %ymm2
	vmovdqu	glob_data + 5024(%rip), %ymm3
	vpsrlvq	%ymm3, %ymm2, %ymm2
	vextracti128	$0, %ymm2, %xmm1
	vextracti128	$1, %ymm2, %xmm11
	ret
.Lerror_polynomial__decode_eta2$1:
	movq	$0, %r8
	movq	$0, %rcx
	jmp 	.Lerror_polynomial__decode_eta2$2
.Lerror_polynomial__decode_eta2$3:
	movzbl	(%rdx,%r8), %r11d
	movzbl	1(%rdx,%r8), %edi
	movzbl	2(%rdx,%r8), %r9d
	movl	%r11d, %ebx
	andl	$7, %ebx
	movl	$2, %ebp
	subl	%ebx, %ebp
	movl	%ebp, (%r10,%rcx,4)
	movl	%r11d, %ebx
	shrl	$3, %ebx
	andl	$7, %ebx
	movl	$2, %ebp
	subl	%ebx, %ebp
	movl	%ebp, 4(%r10,%rcx,4)
	shrl	$6, %r11d
	leal	(%r11,%rdi,4), %r11d
	andl	$7, %r11d
	movl	$2, %ebp
	subl	%r11d, %ebp
	movl	%ebp, 8(%r10,%rcx,4)
	movl	%edi, %r11d
	shrl	$1, %r11d
	andl	$7, %r11d
	movl	$2, %ebp
	subl	%r11d, %ebp
	movl	%ebp, 12(%r10,%rcx,4)
	movl	%edi, %r11d
	shrl	$4, %r11d
	andl	$7, %r11d
	movl	$2, %ebp
	subl	%r11d, %ebp
	movl	%ebp, 16(%r10,%rcx,4)
	shrl	$7, %edi
	leal	(%rdi,%r9,2), %edi
	andl	$7, %edi
	movl	$2, %r11d
	subl	%edi, %r11d
	movl	%r11d, 20(%r10,%rcx,4)
	movl	%r9d, %edi
	shrl	$2, %edi
	andl	$7, %edi
	movl	$2, %r11d
	subl	%edi, %r11d
	movl	%r11d, 24(%r10,%rcx,4)
	shrl	$5, %r9d
	andl	$7, %r9d
	movl	$2, %edi
	subl	%r9d, %edi
	movl	%edi, 28(%r10,%rcx,4)
	addq	$8, %rcx
	addq	$3, %r8
.Lerror_polynomial__decode_eta2$2:
	cmpq	$96, %r8
	jb  	.Lerror_polynomial__decode_eta2$3
	ret
.Lerror_polynomial__encode_eta2$1:
	movq	$2, %r8
	vmovq	%r8, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$0, %r8
	movq	$0, %r11
	jmp 	.Lerror_polynomial__encode_eta2$4
.Lerror_polynomial__encode_eta2$5:
	vmovdqu	(%rax,%r8), %ymm1
	vpsubd	%ymm1, %ymm0, %ymm1
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm3
	vpsubd	%ymm3, %ymm0, %ymm3
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm4
	vpsubd	%ymm4, %ymm0, %ymm4
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm5
	vpsubd	%ymm5, %ymm0, %ymm5
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm6
	vpsubd	%ymm6, %ymm0, %ymm6
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm7
	vpsubd	%ymm7, %ymm0, %ymm7
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm8
	addq	$32, %r8
	vpackusdw	%ymm2, %ymm1, %ymm1
	vpackusdw	%ymm4, %ymm3, %ymm2
	vpackusdw	%ymm6, %ymm5, %ymm3
	vpackusdw	%ymm8, %ymm7, %ymm4
	vpackuswb	%ymm2, %ymm1, %ymm1
	vpackuswb	%ymm4, %ymm3, %ymm2
	vmovdqu	glob_data + 5056(%rip), %ymm3
	vpmaddubsw	%ymm3, %ymm1, %ymm1
	vpmaddubsw	%ymm3, %ymm2, %ymm2
	vpackuswb	%ymm2, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vmovdqu	glob_data + 5088(%rip), %ymm3
	vpshufb	%ymm3, %ymm1, %ymm1
	vmovdqu	glob_data + 5120(%rip), %ymm3
	vpmaddubsw	%ymm3, %ymm1, %ymm1
	vmovdqu	glob_data + 5152(%rip), %ymm3
	vpmaddwd	%ymm3, %ymm1, %ymm1
	vmovdqu	glob_data + 5184(%rip), %ymm3
	vpshufb	%ymm3, %ymm1, %ymm1
	vmovdqu	%xmm1, (%rdx,%r11)
	vextracti128	$1, %ymm1, 12(%rdx,%r11)
	addq	$24, %r11
.Lerror_polynomial__encode_eta2$4:
	cmpq	$72, %r11
	jb  	.Lerror_polynomial__encode_eta2$5
	vmovdqu	(%rax,%r8), %ymm1
	vpsubd	%ymm1, %ymm0, %ymm1
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm2
	vpsubd	%ymm2, %ymm0, %ymm2
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm3
	vpsubd	%ymm3, %ymm0, %ymm3
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm4
	vpsubd	%ymm4, %ymm0, %ymm4
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm5
	vpsubd	%ymm5, %ymm0, %ymm5
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm6
	vpsubd	%ymm6, %ymm0, %ymm6
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm7
	vpsubd	%ymm7, %ymm0, %ymm7
	addq	$32, %r8
	vmovdqu	(%rax,%r8), %ymm8
	vpsubd	%ymm8, %ymm0, %ymm8
	vpackusdw	%ymm2, %ymm1, %ymm0
	vpackusdw	%ymm4, %ymm3, %ymm1
	vpackusdw	%ymm6, %ymm5, %ymm2
	vpackusdw	%ymm8, %ymm7, %ymm3
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpackuswb	%ymm3, %ymm2, %ymm1
	vmovdqu	glob_data + 5056(%rip), %ymm3
	vpmaddubsw	%ymm3, %ymm0, %ymm0
	vpmaddubsw	%ymm3, %ymm1, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vmovdqu	glob_data + 5088(%rip), %ymm3
	vpshufb	%ymm3, %ymm0, %ymm0
	vmovdqu	glob_data + 5120(%rip), %ymm3
	vpmaddubsw	%ymm3, %ymm0, %ymm0
	vmovdqu	glob_data + 5152(%rip), %ymm3
	vpmaddwd	%ymm3, %ymm0, %ymm0
	vmovdqu	glob_data + 5184(%rip), %ymm3
	vpshufb	%ymm3, %ymm0, %ymm0
	vmovdqu	%xmm0, (%rdx,%r11)
	addq	$12, %r11
	vextracti128	$1, %ymm0, 16(%rsp)
	movq	$0, %r8
	jmp 	.Lerror_polynomial__encode_eta2$2
.Lerror_polynomial__encode_eta2$3:
	movb	16(%rsp,%r8), %al
	movb	%al, (%rdx,%r11)
	incq	%r11
	incq	%r8
.Lerror_polynomial__encode_eta2$2:
	cmpq	$12, %r8
	jb  	.Lerror_polynomial__encode_eta2$3
	ret
	.data
	.p2align	5
glob_data:
G$commitment__ENCODING_CONSTANTS_TABLE_bits6:
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64,   1,  64
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16,   1,   0,   0,  16
	.byte	  0,   0,   0,   0,   4,   0,   0,   0,   1,   0,   0,   0,   5,   0,   0,   0
	.byte	  2,   0,   0,   0,   6,   0,   0,   0,   3,   0,   0,   0,   7,   0,   0,   0
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
	.byte	  0,   1,   2,   4,   5,   6,   8,   9,  10,  12,  13,  14, 255, 255, 255, 255
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
	.ident	"Jasmin Compiler 2026.09.0"
	.section	".note.GNU-stack", "", %progbits
