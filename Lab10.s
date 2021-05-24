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
 	ldr r0, =0x3F200000
 	bl phys_to_virt
 	mov r7, r0  @ r7 points to that physical page
 	ldr r6, =myloc
 	str r7, [r6] @ save

loop:	
/*----- SELECT FUNCTION GPIO: escritura 001 -----*/
	mov r1,#1					@ #1 SALIDA, #0 ENTRADA
	lsl r1,#18					@ CANTIDAD BITS DE CORRIMIENTO
	str r1,[r0,#4]				@ DESP. P/DIRECCION 3F2000000+DESP, DONDE DESP PUEDE SER #0, #4 U #8

/*----- ACTIVAR/DESACTIVAR PUERTO GPIO -----*/
	@GPIO 16 low, enciende el led
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

 .end

