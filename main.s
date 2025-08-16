	.arch armv7-a
	.arch_extension virt
	.arch_extension idiv
	.arch_extension sec
	.arch_extension mp
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	2
	.global	print_matrix
	.arch armv7ve
	.syntax unified
	.arm
	.fpu neon
	.type	print_matrix, %function
print_matrix:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movw	r6, #:lower16:.LC0
	add	r5, r0, #32
	add	r7, r0, #288
	movt	r6, #:upper16:.LC0
.L2:
	sub	r4, r5, #32
.L3:
	ldr	r1, [r4], #4
	mov	r0, r6
	bl	printf
	cmp	r4, r5
	bne	.L3
	add	r5, r4, #32
	mov	r0, #10
	bl	putchar
	cmp	r5, r7
	bne	.L2
	pop	{r4, r5, r6, r7, r8, pc}
	.size	print_matrix, .-print_matrix
	.global	__aeabi_ldivmod
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 184
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movw	r9, #:lower16:.LANCHOR0
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	movt	r9, #:upper16:.LANCHOR0
	mov	r5, r9
	sub	sp, sp, #188
	vstr.64	d3, [sp, #96]	@ int
	vstr.64	d4, [sp, #80]	@ int
	vstr.64	d5, [sp, #64]	@ int
	vstr.64	d6, [sp, #48]	@ int
	vstr.64	d7, [sp, #16]	@ int
	vstr.64	d2, [sp]	@ int
	bl	clock
	add	r3, r9, #32
	vld1.32	{d16-d17}, [r3:128]
	add	r3, r9, #48
	vld1.32	{d18-d19}, [r5:128]!
	vld1.32	{d20-d21}, [r3:128]
	vld1.32	{d22-d23}, [r5:128]
	vabs.s32	q8, q8
	vabs.s32	q10, q10
	vabs.s32	q9, q9
	vabs.s32	q11, q11
	vpaddl.s32	q8, q8
	vpaddl.s32	q10, q10
	vpaddl.s32	q9, q9
	vadd.i64	q8, q8, q10
	vpaddl.s32	q11, q11
	vadd.i64	d16, d17, d16
	vadd.i64	q9, q9, q11
	ldr	r4, .L88+16
	vmov	r2, r3, d16	@ int
	vadd.i64	d18, d19, d18
	vld1.32	{d16-d17}, [r4:128]!
	str	r0, [sp, #116]
	vmov	r0, r1, d18	@ int
	vld1.32	{d18-d19}, [r4:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	cmp	r0, r2
	sbcs	ip, r1, r3
	movlt	r0, r2
	movlt	r1, r3
	vadd.i64	q8, q8, q9
	cmp	r0, #0
	sbcs	r3, r1, #0
	movlt	r1, #0
	movlt	r0, #0
	vadd.i64	d16, d17, d16
	ldr	lr, .L88+20
	vmov	r2, r3, d16	@ int
	vld1.32	{d16-d17}, [lr:128]!
	vld1.32	{d18-d19}, [lr:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	vadd.i64	q8, q8, q9
	cmp	r2, r0
	sbcs	ip, r3, r1
	movlt	r3, r1
	movlt	r2, r0
	vadd.i64	d16, d17, d16
	vmov	r0, r1, d16	@ int
	cmp	r0, r2
	sbcs	ip, r1, r3
	ldr	ip, .L88+24
	movlt	r1, r3
	vld1.32	{d16-d17}, [ip:128]!
	vld1.32	{d18-d19}, [ip:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	vadd.i64	q8, q8, q9
	movlt	r0, r2
	vadd.i64	d16, d17, d16
	vmov	r2, r3, d16	@ int
	cmp	r2, r0
	sbcs	r6, r3, r1
	ldr	r6, .L88+28
	movlt	r2, r0
	vld1.32	{d16-d17}, [r6:128]!
	vld1.32	{d18-d19}, [r6:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	vadd.i64	q8, q8, q9
	ldr	r0, .L88+32
	movlt	r3, r1
	mov	r8, r0
	vadd.i64	d16, d17, d16
	vmov	r10, fp, d16	@ int
	vld1.32	{d16-d17}, [r8:128]!
	vld1.32	{d18-d19}, [r8:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	mov	r1, fp
	vadd.i64	q8, q8, q9
	cmp	r10, r2
	sbcs	r1, r1, r3
	movlt	fp, r3
	movlt	r10, r2
	vadd.i64	d16, d17, d16
	vmov	r2, r3, d16	@ int
	cmp	r2, r10
	sbcs	r1, r3, fp
	ldr	r1, .L88+36
	movlt	r3, fp
	mov	r7, r1
	vld1.32	{d16-d17}, [r7:128]!
	vld1.32	{d18-d19}, [r7:128]
	vabs.s32	q8, q8
	vabs.s32	q9, q9
	vpaddl.s32	q8, q8
	vpaddl.s32	q9, q9
	vadd.i64	q8, q8, q9
	movlt	r2, r10
	vadd.i64	d16, d17, d16
	vmov	r10, fp, d16	@ int
	cmp	r10, r2
	sbcs	r10, fp, r3
	vldr.64	d2, [sp]	@ int
	vstr.64	d16, [sp]	@ int
	strdlt	r2, [sp]
	mov	r2, #1024
	ldrd	r10, [sp]
	mov	r3, #0
	cmp	r2, r10
	sbcs	r3, r3, fp
	vldr.64	d7, [sp, #16]	@ int
	vldr.64	d6, [sp, #48]	@ int
	vldr.64	d5, [sp, #64]	@ int
	vldr.64	d4, [sp, #80]	@ int
	vldr.64	d3, [sp, #96]	@ int
	blt	.L85
	ldr	r10, .L88+40
	vld1.32	{d16-d17}, [ip:128]
	add	r3, r10, #32
	vld1.32	{d22-d23}, [r3:128]
	add	r3, r10, #96
	vld1.32	{d0-d1}, [r3:128]
	vshl.i32	q0, q0, #11
	vstr	d16, [sp, #48]
	vstr	d17, [sp, #56]
	vstr	d0, [sp, #64]
	vstr	d1, [sp, #72]
	vldr	d0, [sp, #48]
	vldr	d1, [sp, #56]
	vld1.32	{d16-d17}, [r6:128]
	vshl.i32	q0, q0, #11
	vstr	d16, [sp, #80]
	vstr	d17, [sp, #88]
	vstr	d0, [sp, #48]
	vstr	d1, [sp, #56]
	vldr	d0, [sp, #80]
	vldr	d1, [sp, #88]
	vld1.32	{d16-d17}, [r0:128]
	vshl.i32	q0, q0, #11
	vstr	d16, [sp, #96]
	vstr	d17, [sp, #104]
	vstr	d0, [sp, #80]
	vstr	d1, [sp, #88]
	vldr	d0, [sp, #96]
	vldr	d1, [sp, #104]
	vld1.32	{d16-d17}, [r8:128]
	vshl.i32	q0, q0, #11
	vstr	d16, [sp, #120]
	vstr	d17, [sp, #128]
	vstr	d0, [sp, #96]
	vstr	d1, [sp, #104]
	vldr	d0, [sp, #120]
	vldr	d1, [sp, #128]
	vld1.32	{d16-d17}, [r1:128]
	vshl.i32	q0, q0, #11
	vst1.64	{d16-d17}, [sp:64]
	vld1.32	{d12-d13}, [lr:128]
	vld1.32	{d16-d17}, [r7:128]
	vstr	d0, [sp, #120]
	vstr	d1, [sp, #128]
	vld1.64	{d0-d1}, [sp:64]
	vstr	d16, [sp, #16]
	vstr	d17, [sp, #24]
	vshl.i32	q0, q0, #11
	vshl.i32	q8, q6, #11
	add	fp, r10, #16
	add	r2, r10, #64
	add	r3, r3, #32
	vld1.32	{d30-d31}, [r9:128]
	vld1.32	{d28-d29}, [r5:128]
	vld1.32	{d26-d27}, [r10:128]
	vld1.32	{d24-d25}, [fp:128]
	vld1.32	{d20-d21}, [r4:128]
	vld1.32	{d18-d19}, [r2:128]
	vld1.32	{d14-d15}, [r3:128]
	vmov	q6, q0  @ v4si
	vldr	d0, [sp, #16]
	vldr	d1, [sp, #24]
	vst1.32	{d16-d17}, [lr:128]
	vldr	d16, [sp, #64]
	vldr	d17, [sp, #72]
	add	r3, r3, #96
	sub	lr, r3, #128
	vst1.32	{d16-d17}, [lr:128]
	vldr	d16, [sp, #48]
	vldr	d17, [sp, #56]
	vst1.32	{d16-d17}, [ip:128]
	vldr	d16, [sp, #80]
	vldr	d17, [sp, #88]
	vshl.i32	q13, q13, #11
	vst1.32	{d16-d17}, [r6:128]
	vldr	d16, [sp, #96]
	vldr	d17, [sp, #104]
	vshl.i32	q14, q14, #11
	vshl.i32	q10, q10, #11
	mov	r2, r3
	vst1.32	{d26-d27}, [r10:128]
	vst1.32	{d16-d17}, [r0:128]
	vshl.i32	q15, q15, #11
	vldr	d16, [sp, #120]
	vldr	d17, [sp, #128]
	vshl.i32	q11, q11, #11
	vshl.i32	q9, q9, #11
	vshl.i32	q7, q7, #11
	vshl.i32	q0, q0, #11
	vst1.32	{d28-d29}, [r5:128]
	vst1.32	{d20-d21}, [r4:128]
	sub	r5, r3, #192
	sub	r4, r3, #160
	sub	ip, r3, #96
	add	r10, r3, #144
	vshl.i32	q12, q12, #11
	vst1.32	{d22-d23}, [r5:128]
	vst1.32	{d14-d15}, [ip:128]
	vst1.32	{d16-d17}, [r8:128]
	vst1.32	{d0-d1}, [r7:128]
	vst1.32	{d30-d31}, [r9:128]
	vst1.32	{d18-d19}, [r4:128]
	vld1.32	{d30-d31}, [r2:128]!
	vld1.32	{d14-d15}, [r10:128]
	add	r8, r3, #32
	add	r7, r3, #48
	add	r6, r3, #64
	add	r5, r3, #80
	add	r4, r3, #96
	vst1.32	{d24-d25}, [fp:128]
	add	lr, r3, #112
	add	ip, r3, #128
	add	fp, r3, #160
	vst1.32	{d12-d13}, [r1:128]
	vld1.32	{d26-d27}, [r8:128]
	vld1.32	{d24-d25}, [r7:128]
	vld1.32	{d22-d23}, [r6:128]
	vld1.32	{d20-d21}, [r5:128]
	vld1.32	{d18-d19}, [r4:128]
	add	r9, r3, #176
	vld1.32	{d28-d29}, [r2:128]
	vld1.32	{d16-d17}, [lr:128]
	vld1.32	{d0-d1}, [ip:128]
	vstr	d14, [sp, #48]
	vstr	d15, [sp, #56]
	vld1.32	{d12-d13}, [fp:128]
	vld1.32	{d14-d15}, [r9:128]
	add	r9, r3, #192
	vstr	d12, [sp, #80]
	vstr	d13, [sp, #88]
	vld1.32	{d12-d13}, [r9:128]
	add	r9, r9, #16
	vstr	d14, [sp, #96]
	vstr	d15, [sp, #104]
	vld1.32	{d14-d15}, [r9:128]
	add	r1, r3, #240
	vstr	d14, [sp, #136]
	vstr	d15, [sp, #144]
	vld1.32	{d14-d15}, [r1:128]
	add	r0, r3, #224
	vstr	d12, [sp, #120]
	vstr	d13, [sp, #128]
	vstr	d14, [sp, #16]
	vstr	d15, [sp, #24]
	vld1.32	{d12-d13}, [r0:128]
	vldr	d14, [sp, #48]
	vldr	d15, [sp, #56]
	vshl.i32	q0, q0, #11
	vst1.64	{d12-d13}, [sp:64]
	vstr	d0, [sp, #64]
	vstr	d1, [sp, #72]
	vldr	d12, [sp, #80]
	vldr	d13, [sp, #88]
	vshl.i32	q0, q7, #11
	vstr	d0, [sp, #48]
	vstr	d1, [sp, #56]
	vshl.i32	q0, q6, #11
	vldr	d12, [sp, #120]
	vldr	d13, [sp, #128]
	vldr	d14, [sp, #96]
	vldr	d15, [sp, #104]
	vshl.i32	q6, q6, #11
	vstr	d0, [sp, #80]
	vstr	d1, [sp, #88]
	vstr	d12, [sp, #120]
	vstr	d13, [sp, #128]
	vshl.i32	q0, q7, #11
	vld1.64	{d12-d13}, [sp:64]
	vldr	d14, [sp, #136]
	vldr	d15, [sp, #144]
	vshl.i32	q8, q8, #11
	vshl.i32	q7, q7, #11
	vshl.i32	q6, q6, #11
	vshl.i32	q15, q15, #11
	vshl.i32	q14, q14, #11
	vshl.i32	q13, q13, #11
	vshl.i32	q12, q12, #11
	vshl.i32	q11, q11, #11
	vshl.i32	q10, q10, #11
	vshl.i32	q9, q9, #11
	vstr	d0, [sp, #96]
	vstr	d1, [sp, #104]
	vstr	d14, [sp, #136]
	vstr	d15, [sp, #144]
	vst1.64	{d12-d13}, [sp:64]
	vldr	d14, [sp, #16]
	vldr	d15, [sp, #24]
	vst1.32	{d30-d31}, [r3:128]
	vst1.32	{d26-d27}, [r8:128]
	vst1.32	{d24-d25}, [r7:128]
	vst1.32	{d22-d23}, [r6:128]
	vst1.32	{d20-d21}, [r5:128]
	vst1.32	{d28-d29}, [r2:128]
	vst1.32	{d18-d19}, [r4:128]
	vst1.32	{d16-d17}, [lr:128]
	vldr	d16, [sp, #64]
	vldr	d17, [sp, #72]
	vst1.32	{d16-d17}, [ip:128]
	vldr	d16, [sp, #48]
	vldr	d17, [sp, #56]
	vst1.32	{d16-d17}, [r10:128]
	vldr	d16, [sp, #80]
	vldr	d17, [sp, #88]
	vst1.32	{d16-d17}, [fp:128]
	vldr	d16, [sp, #96]
	vldr	d17, [sp, #104]
	vldr	d12, [sp, #120]
	vldr	d13, [sp, #128]
	add	r3, r3, #176
	vst1.32	{d16-d17}, [r3:128]
	add	r3, r3, #16
	vst1.32	{d12-d13}, [r3:128]
	vshl.i32	q0, q7, #11
	vld1.64	{d12-d13}, [sp:64]
	vldr	d14, [sp, #136]
	vldr	d15, [sp, #144]
	sub	r9, r9, #464
	add	r3, r3, #16
	vst1.32	{d14-d15}, [r3:128]
	vst1.32	{d12-d13}, [r0:128]
	vst1.32	{d0-d1}, [r1:128]
	mov	r8, r9
	mov	r5, r9
	mov	r4, #0
	mov	r3, r9
	vldr	d12, [sp, #152]
	vldr	d13, [sp, #160]
	vldr	d14, [sp, #168]
	vldr	d15, [sp, #176]
	sub	r6, r6, #64
	add	r7, r9, #32
.L41:
	ldr	r2, [r8]
	cmp	r2, #-2147483648
	beq	.L18
	eor	r3, r2, r2, asr #31
	cmp	r4, #7
	sub	r3, r3, r2, asr #31
	beq	.L19
	ldr	r1, [r7, #192]
	cmp	r1, #-2147483648
	beq	.L86
.L48:
	cmp	r1, #0
	rsblt	r1, r1, #0
.L20:
	cmp	r1, r3
	movle	r1, r3
	ble	.L22
	cmp	r4, #6
	mov	r3, #7
	beq	.L35
.L47:
	ldr	r0, [r7, #160]
	cmp	r0, #-2147483648
	mvneq	r0, #-2147483648
	beq	.L23
	cmp	r0, #0
	rsblt	r0, r0, #0
.L23:
	cmp	r0, r1
	bgt	.L24
	cmp	r4, #5
	beq	.L25
	mov	r0, r1
.L46:
	ldr	r1, [r7, #128]
	cmp	r1, #-2147483648
	mvneq	r1, #-2147483648
	beq	.L26
	cmp	r1, #0
	rsblt	r1, r1, #0
.L26:
	cmp	r0, r1
	blt	.L27
	cmp	r4, #4
	beq	.L25
	mov	r1, r0
.L45:
	ldr	r0, [r7, #96]
	cmp	r0, #-2147483648
	mvneq	r0, #-2147483648
	beq	.L28
	cmp	r0, #0
	rsblt	r0, r0, #0
.L28:
	cmp	r0, r1
	bgt	.L29
	cmp	r4, #3
	beq	.L25
	mov	r0, r1
.L44:
	ldr	r1, [r7, #64]
	cmp	r1, #-2147483648
	mvneq	r1, #-2147483648
	beq	.L30
	cmp	r1, #0
	rsblt	r1, r1, #0
.L30:
	cmp	r0, r1
	blt	.L31
	cmp	r4, #2
	beq	.L25
	mov	r1, r0
.L43:
	ldr	r0, [r7, #32]
	cmp	r0, #-2147483648
	mvneq	r0, #-2147483648
	beq	.L32
	cmp	r0, #0
	rsblt	r0, r0, #0
.L32:
	cmp	r1, r0
	blt	.L33
	cmp	r4, #0
	bne	.L25
	mov	r0, r1
.L42:
	ldr	r1, [r7]
	cmp	r1, #-2147483648
	mvneq	r1, #-2147483648
	beq	.L34
	cmp	r1, #0
	rsblt	r1, r1, #0
.L34:
	cmp	r1, r0
	ble	.L25
	mov	r3, #1
.L35:
	lsl	r3, r3, #5
	add	lr, r9, r3
	mov	r0, lr
	mov	ip, r5
	ldr	r2, .L88+44
	vld1.32	{d30-d31}, [r0:128]!
	add	r3, r2, r3
	vld1.32	{d26-d27}, [ip:128]!
	mov	r2, r3
	mov	r1, r6
	vld1.32	{d22-d23}, [r2:128]!
	vld1.32	{d18-d19}, [r1:128]!
	vld1.32	{d28-d29}, [r0:128]
	vld1.32	{d24-d25}, [ip]
	vld1.32	{d20-d21}, [r2:128]
	vld1.32	{d16-d17}, [r1]
	vst1.32	{d30-d31}, [r5:128]
	vst1.32	{d28-d29}, [ip]
	vst1.32	{d26-d27}, [lr:128]
	vst1.32	{d24-d25}, [r0:128]
	vst1.32	{d22-d23}, [r6:128]
	vst1.32	{d20-d21}, [r1]
	vst1.32	{d18-d19}, [r3:128]
	vst1.32	{d16-d17}, [r2:128]
	ldr	r2, [r8]
.L19:
	cmp	r2, #0
	beq	.L87
.L36:
	asr	r3, r2, #31
	mov	r0, #1024
	mov	r1, #2
	vstr.64	d3, [sp, #96]	@ int
	vstr.64	d4, [sp, #80]	@ int
	vstr.64	d5, [sp, #64]	@ int
	vstr.64	d6, [sp, #48]	@ int
	vstr.64	d7, [sp, #16]	@ int
	vstr.64	d2, [sp]	@ int
	bl	__aeabi_ldivmod
	vldr	d22, [sp, #32]
	lsr	r0, r0, #11
	orr	r0, r0, r1, lsl #21
	vmov.32	d22[0], r0
	mov	lr, r5
	mov	ip, r6
	vldr	d26, [sp, #40]
	vld1.32	{d18-d19}, [lr:128]!
	vld1.32	{d16-d17}, [ip:128]!
	vmov.32	d26[0], r0
	vmov	d7, d22  @ v2si
	vldr.64	d2, [sp]	@ int
	vld1.32	{d20-d21}, [lr]
	vld1.32	{d24-d25}, [ip]
	vmov.32	d12[0], r0
	vmov.32	d13[0], r0
	vmov.32	d2[0], r0
	vmov.32	d11[0], r0
	vmov.32	d14[0], r0
	vmov.32	d15[0], r0
	vstr	d22, [sp, #32]
	vmull.s32	q11, d18, d7[0]
	vmov	d7, d26  @ v2si
	vmull.s32	q15, d19, d12[0]
	vmull.s32	q14, d21, d14[0]
	vmull.s32	q9, d20, d2[0]
	vstr	d26, [sp, #40]
	vmull.s32	q10, d16, d7[0]
	vmull.s32	q13, d17, d13[0]
	vmull.s32	q8, d24, d11[0]
	vmull.s32	q12, d25, d15[0]
	vqrshrn.s64	d30, q15, #11
	vqrshrn.s64	d28, q14, #11
	vqrshrn.s64	d26, q13, #11
	vqrshrn.s64	d24, q12, #11
	vqrshrn.s64	d22, q11, #11
	vqrshrn.s64	d18, q9, #11
	vqrshrn.s64	d20, q10, #11
	vqrshrn.s64	d16, q8, #11
	vmov	d23, d30  @ v2si
	vmov	d19, d28  @ v2si
	vmov	d21, d26  @ v2si
	vmov	d17, d24  @ v2si
	vst1.32	{d22-d23}, [r5:128]
	vst1.32	{d20-d21}, [r6:128]
	vst1.32	{d18-d19}, [lr]
	vst1.32	{d16-d17}, [ip]
	mov	r0, #0
	vldr.64	d7, [sp, #16]	@ int
	vldr.64	d6, [sp, #48]	@ int
	vldr.64	d5, [sp, #64]	@ int
	vldr.64	d4, [sp, #80]	@ int
	vldr.64	d3, [sp, #96]	@ int
	ldr	r1, .L88+44
	add	r10, r4, #1
	sub	r2, r1, #256
.L37:
	cmp	r4, r0
	beq	.L38
	ldr	r3, [r2, r4, lsl #2]
	vld1.32	{d18-d19}, [r5:128]
	vmov.32	d8[0], r3
	vld1.32	{d16-d17}, [r6:128]
	vld1.32	{d20-d21}, [lr]
	vmov.32	d9[0], r3
	vmov.32	d10[0], r3
	vmov.32	d6[0], r3
	vmov.32	d4[0], r3
	vmull.s32	q14, d18, d8[0]
	vmov.32	d7[0], r3
	vmull.s32	q0, d19, d10[0]
	vmull.s32	q12, d21, d4[0]
	vmull.s32	q9, d20, d6[0]
	vmull.s32	q10, d16, d9[0]
	vld1.32	{d22-d23}, [ip]
	vmull.s32	q13, d17, d7[0]
	vmov.32	d5[0], r3
	vqrshrn.s64	d17, q14, #11
	vmov.32	d3[0], r3
	vst1.64	{d20-d21}, [sp:64]
	mov	fp, r2
	mov	r3, r1
	vmull.s32	q15, d23, d3[0]
	vmull.s32	q10, d22, d5[0]
	vstr	d17, [sp, #16]
	vld1.64	{d16-d17}, [sp:64]
	vld1.32	{d28-d29}, [fp]!
	vqrshrn.s64	d22, q15, #11
	vqrshrn.s64	d17, q8, #11
	vqrshrn.s64	d23, q13, #11
	vqrshrn.s64	d16, q10, #11
	vld1.32	{d26-d27}, [r3:128]!
	vqrshrn.s64	d0, q0, #11
	vqrshrn.s64	d18, q9, #11
	vqrshrn.s64	d24, q12, #11
	vldr	d19, [sp, #16]
	vld1.32	{d20-d21}, [fp]
	vmov	d1, d0  @ v2si
	vmov	d30, d17  @ v2si
	vmov	d0, d19  @ v2si
	vmov	d31, d23  @ v2si
	vmov	d19, d24  @ v2si
	vmov	d23, d22  @ v2si
	vmov	d22, d16  @ v2si
	vld1.32	{d16-d17}, [r3]
	vqsub.s32	q14, q14, q0
	vqsub.s32	q9, q10, q9
	vqsub.s32	q13, q13, q15
	vqsub.s32	q8, q8, q11
	add	r0, r0, #1
	cmp	r0, #8
	vst1.32	{d28-d29}, [r2]
	vst1.32	{d26-d27}, [r1:128]
	add	r2, r2, #32
	vst1.32	{d18-d19}, [fp]
	add	r1, r1, #32
	vst1.32	{d16-d17}, [r3]
	bne	.L37
.L40:
	cmp	r10, #8
	mov	r4, r10
	add	r8, r8, #36
	add	r5, r5, #32
	add	r6, r6, #32
	add	r7, r7, #4
	bne	.L41
	bl	clock
	ldr	r3, [sp, #116]
	vldr.64	d17, .L88
	sub	r0, r0, r3
	vmov	s15, r0	@ int
	vcvt.f32.s32	s15, s15
	vcvt.f64.f32	d16, s15
	vldr.64	d18, .L88+8
	vmul.f64	d16, d16, d17
	vdiv.f64	d17, d16, d18
	vcvt.f32.f64	s15, d17
	movw	r0, #:lower16:.LC2
	vcvt.f64.f32	d16, s15
	movt	r0, #:upper16:.LC2
	vmov	r2, r3, d16
	bl	printf
	movw	r0, #:lower16:.LANCHOR0
	movt	r0, #:upper16:.LANCHOR0
	bl	print_matrix
	mov	r0, #10
	bl	putchar
	ldr	r0, .L88+44
	bl	print_matrix
.L85:
	mov	r0, #0
	bl	exit
.L38:
	cmp	r10, #8
	add	r2, r2, #32
	add	r1, r1, #32
	mov	r0, r10
	bne	.L37
	b	.L40
.L22:
	cmp	r4, #6
	movne	r3, r4
	bne	.L47
	b	.L19
.L25:
	cmp	r4, r3
	bne	.L35
	cmp	r2, #0
	bne	.L36
.L87:
	movw	r0, #:lower16:.LC1
	mov	r10, r2
	movt	r0, #:upper16:.LC1
	bl	puts
	mov	r0, r10
	bl	exit
.L24:
	cmp	r4, #5
	mov	r3, #6
	bne	.L46
	b	.L35
.L27:
	cmp	r4, #4
	mov	r3, #5
	bne	.L45
	b	.L35
.L18:
	cmp	r4, #7
	beq	.L36
	ldr	r1, [r7, #192]
	cmp	r1, #-2147483648
	mvneq	r1, #-2147483648
	beq	.L22
	mvn	r3, #-2147483648
	b	.L48
.L29:
	cmp	r4, #3
	mov	r3, #4
	bne	.L44
	b	.L35
.L31:
	cmp	r4, #2
	mov	r3, #3
	bne	.L43
	b	.L35
.L33:
	cmp	r4, #0
	mov	r3, #2
	beq	.L42
	b	.L35
.L86:
	mvn	r1, #-2147483648
	b	.L20
.L89:
	.align	3
.L88:
	.word	0
	.word	1083129856
	.word	0
	.word	1093567616
	.word	.LANCHOR0+64
	.word	.LANCHOR0+96
	.word	.LANCHOR0+128
	.word	.LANCHOR0+160
	.word	.LANCHOR0+192
	.word	.LANCHOR0+224
	.word	.LANCHOR0+32
	.word	.LANCHOR0+256
	.size	main, .-main
	.data
	.align	4
	.set	.LANCHOR0,. + 0
	.type	matrix, %object
	.size	matrix, 256
matrix:
	.word	10
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	1
	.word	11
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	1
	.word	1
	.word	12
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	1
	.word	1
	.word	1
	.word	13
	.word	2
	.word	3
	.word	4
	.word	5
	.word	1
	.word	1
	.word	1
	.word	1
	.word	14
	.word	2
	.word	3
	.word	4
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	15
	.word	2
	.word	3
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	16
	.word	2
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	1
	.word	17
	.type	identity, %object
	.size	identity, 256
identity:
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	1
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"%4d \000"
	.space	3
.LC1:
	.ascii	"Matrix is ill-conditioned (det 0) - Exiting\000"
.LC2:
	.ascii	"Time elapse in ms: %f\012\000"
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
