.equ PH_CFG1, 0x01C20900
.equ PH_CFG2, 0x01C20904

.equ PH_PULL0, 0x01C20918
.equ PH_PULL1, 0x01C2091C

.equ PH_DAT, 0x01C2090C

.global main

main:
	ldr r0,= PH_CFG1
	ldr r1,=0x10000000
	str r1, [r0]
	
	ldr r0,=PH_CFG2
	ldr r1,=0x00000001
	str r1, [r0]
	
	ldr r0,=PH_PULL0
	ldr r1,=0x55555555
	str r1, [r0]

ledloop:
	ldr r0,=PH_DAT
	ldr r1,=0x000f0000
	str r1, [r0]

	bl delay

	ldr r0,=PH_DAT
	ldr r1,=0x0000f000
	str r1, [r0]
	
	bl delay
	b ledloop

delay:
	ldr r3,=0xfffff

delay1:
	sub r3,r3,#1
	cmp r3,#0x0
	bne delay1
	mov pc,lr
