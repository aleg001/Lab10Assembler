@
@ GPIO demonstration code NJM
@ Just calls phys_to_virt (a C program that calls mmap())
@ to map a given physical page to virtual memory
@ Must be run as root of course :) Use at your own risk!
@
/*---------------------------------------------
* PARA EJECUTAR:
* gcc -c phys_to_virt.c
* as -o Lab10.o Lab10.s
* gcc -o Lab10 Lab10.o phys_to_virt.o
* sudo ./Lab10
*---------------------------------------------*/

/* --------------------------------------------
* Lab10
* Fecha: 24/05/21
* Creado por:
* Alejandro Gómez 20347
* Marco Jurado 20308
* Adaptado de archivo led3_ok subido a canvas
 -------------------------------------------*/ 

 .text
 .align 2
 .global main

main:
/*----- EQUIVALENTE A LLAMAR BIBLIOTECAS -----*/
	@ Map GPIO page (0x3F200000) 		@ Referirse a la dirección base para manejo de puertos
	@ to our virtual address space
 	
	//Puertos para 0-9
	ldr r0, =0x3F200000
 	bl phys_to_virt
 	mov r7, r0  @ r7 points to that physical page
 	ldr r6, =myloc
 	str r7, [r6] @ save
	 
	//Puertos para 10-19
	mov r7,#0
	ldr r0, = 0x3F200004
	bl phys_to_virt
	mov r7,r0
	ldr r, =myloc1
	str r7,

	//Puertos para 20-29
	mov r7,#0
	ldr r0, =0x3F200008
 	bl phys_to_virt
 	mov r7, r0  @ r7 points to that physical page
 	ldr r9, =myloc
 	str r7, [r9] @ save
	 

loop:	

/*----- SELECCIONAR FUNCTION GPIO de escritura --> 001 -----*/
	/*
	Puertos GPIO a utilizar:
			
			Puertos 20-29
			GPIO 27 = 13
			GPIO 22 = 15
			GPIO 23 = 16
			GPIO 24 = 18

			Puertos 0-9
			GPIO 5  = 29
			GPIO 6  = 31

			Puertos 10-19
			GPIO 17 = 11
			GPIO 16 = 36
			
			GROUND  = 6
	 */
	 
	//GPIO 17 - segmento A
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]
	
	//GPIO 27 - segmento B
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 22 - segmento F
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 23 - segmento G
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 24 - segmento C
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 5 - segmento E
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 6 - segmento D
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]

	//GPIO 16 - segmento DP
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]


	//GPIO G - Ground
	mov r1,#1					//#1 SALIDA
	lsl r1,#18					// lsl de XX para ir a GPIO no. XX				
	str r1,[r0,#4]				



/*----- Encender y apagar los GPIO-----*/
	@GPIO 16 low, ilumina el led
	mov r1,#1
	lsl r1,#16
	str r1,[r0,#40]				@40 equivale a 0x28 en hex
	
	push {r0}
	bl wait
	pop {r0}
	
	@GPIO 16 low, apaga el led
	str r1,[r0,#28]				@28 equivale a 0x1C en hex
	
	push {r0}
	bl wait
	pop {r0}	
	
	b loop

@ brief pause routine
wait:
	mov r0, #0x4000000 @ big number

sleepLoop:
	subs r0,#1
	bne sleepLoop @ loop delay
	mov pc,lr

 .data
 .align 2
myloc: .word 0
myloc1: .word 0
myloc2: .word 0

 .end

