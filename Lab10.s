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
* Adaptado de archivo pruebaa subido a canvas
 -------------------------------------------*/ 


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
	 
@ To assemble, link, and run:
@
@  as -o blink.o blink.s 
@  gcc -o blink2 blink.o -lwiringPi 
@  sudo ./blink2 
@ ---------------------------------------
@ Description: 
@ blink 10 times pin 36 
@ ---------------------------------------

@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4	
Intro: 	 .asciz  "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
pin:	 .int	27
i:	 	 .int	0
delayMs: .int	250
OUTPUT	 =	1
	
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	
main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment

	bl	wiringPiSetup			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa

@  pinMode(pin, OUTPUT)		;
init:
	ldr	r0, =pin				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar

@   for ( i=0; i<10; i++ ) { 	
	ldr	r4, =i					// carga valor de contador en 10
	ldr	r4, [r4]
	mov	r5, #10
forLoop:						// inicio de ciclo 
	cmp	r4, r5
	bgt	done					// si el ciclo se ha completado 10 veces
								// entonces termina programa
@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO
	
@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@       digitalWrite(pin, 0) 	;
	ldr	r0, =pin				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 0 en pin para desactivar puerto GPIO

@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

	add	r4, #1					// incrementa contador
	b	forLoop					// repite ciclo
	
done:	
        pop 	{ip, pc}	@ pop return address into pc
