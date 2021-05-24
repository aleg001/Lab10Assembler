@ blink.s
@ D. Thiebaut
@ based on the following C program:
@ http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Assembly_Language_with_the_Raspberry_Pi 
@ #include <wiringPi.h>
@ #include <stdio.h>
@ #include <stdlib.h>
@ 
@ int main (void) {
@   int pin = 27;
@   printf("Raspberry Pi wiringPi blink test\n");
@ 
@   if (wiringPiSetup() == -1) {
@     printf( "Setup didn't work... Aborting." );
@     exit (1);
@   }
@   
@   pinMode(pin, OUTPUT);
@   int i;
@   for ( i=0; i<10; i++ ) {
@     digitalWrite(pin, 1);
@     delay(250);
@ 
@     digitalWrite(pin, 0);
@     delay(250);
@   }
@ 
@   return 0;
@ }
@	
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
