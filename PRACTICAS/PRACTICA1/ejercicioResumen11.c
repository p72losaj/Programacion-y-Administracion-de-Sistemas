/*

Un proceso genera 2 numeros aleatorios
El otro recibe la suma de los numeros aleatorios

*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>
#include <errno.h> 
#include <string.h> 



int main() 
{
	
	pid_t rf;

	int flag, status;
	
	float resultado; // control de errores
	
	float numeroAleatorio;
	
	int fileDes[2];
	
	int i=0;

	float suma = 0.0;

	// Creamos la tubería

	resultado = pipe(fileDes);

	if(resultado==-1)
	{
		printf("\nERROR al crear la tubería.\n");
		exit(1);
	}
	
	rf = fork();

	switch (rf)
	{
		case -1:
			printf ("No se ha podido crear el proceso hijo...\n");
			exit(EXIT_FAILURE);
		case 0:
			printf ("[HIJO]: Mi PID es %d y el PID de mi padre es %d\n", getpid(), getppid());
			close(fileDes[1]);
			//Recibimos un mensaje a través de la cola

			resultado = read( fileDes[0], &suma, sizeof(int));
				
			if(resultado != sizeof(int))
			{
				printf("\n[HIJO]: ERROR al leer de la tubería...\n");
				exit(EXIT_FAILURE);
			}
			// Imprimimos el campo que viene en la tubería
			printf("[HIJO]: Suma %f de la tubería.\n", suma);		
			// Cerrar el extremo que he usado
			printf("[HIJO]: Tubería cerrada ...\n");
			close(fileDes[0]);
			break;

		default:
			printf ("[PADRE]: Mi PID es %d y el PID de mi hijo es %d \n", getpid(), rf);
			
			close(fileDes[0]);
			
			srand48(time(NULL)); // Semilla de los números aleatorios establecida a la hora actual
			
			for(i=0; i<2; i++)
			{			
				// Rellenamos los campos del mensaje que vamos a enviar
				numeroAleatorio = drand48()/(10.00-5.00)+ 5.00; //Número aleatorio entre 10 y 5

				printf(" [PADRE]. Numero aleatorio generado: %f\n", numeroAleatorio);

				suma += numeroAleatorio;
				
			}

			printf("[PADRE]: Escribo la suma %f en la tubería...\n", suma);
				
			// Mandamos el mensaje
			resultado = write( fileDes[1], &suma, sizeof(float));
				
			if(resultado != sizeof(float))
			{
				printf("\n[PADRE]: ERROR al escribir en la tubería...\n");
				exit(EXIT_FAILURE);
			}
			
			// Cerrar el extremo que he usado
			close(fileDes[1]);
			printf("[PADRE]: Tubería cerrada...\n");
			
			/*Espera del padre a los hijos*/
	        while ( (flag=wait(&status)) > 0 ) 
	        {
		        if (WIFEXITED(status)) {
			        printf("Proceso Padre, Hijo con PID %ld finalizado, status = %d\n", (long int)flag, WEXITSTATUS(status));
		        } 
		        else if (WIFSIGNALED(status)) {  //Para seniales como las de finalizar o matar
			        printf("Proceso Padre, Hijo con PID %ld finalizado al recibir la señal %d\n", (long int)flag, WTERMSIG(status));
		        } 		
	        }
	        if (flag==(pid_t)-1 && errno==ECHILD)
	        {
		        printf("Proceso Padre %d, no hay mas hijos que esperar. Valor de errno = %d, definido como: %s\n", getpid(), errno, strerror(errno));
	        }
	        else
	        {
		        printf("Error en la invocacion de wait o waitpid. Valor de errno = %d, definido como: %s\n", errno, strerror(errno));
		        exit(EXIT_FAILURE);
	        }			 
	}
	exit(EXIT_SUCCESS);
}