/*
Cliente que envia por una cola abierta para escritura una cadena de caracteres
recogida por teclado, mientras que el valor de esa cadena sea distinto a la palabra exit
*/


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <mqueue.h>
#include <time.h>
#include <errno.h>
#include "common.h"

//Prototipo de funcion
void funcionLog(char *);
FILE *fLog = NULL;

int main(int argc, char **argv)
{

	ssize_t bytes_read; 

	// Cola del servidor

	mqd_t servidor;
	mqd_t cliente;

	// Intercambio mensajes

	char buffer[MAX_SIZE], mensaje[MAX_SIZE];

    // Nombre colas

    char serverQueue[MAX_SIZE], clientQueue[MAX_SIZE];

	sprintf(serverQueue, "%s-%s", SERVER_QUEUE, getenv("USER"));

    sprintf (mensaje,"[Cliente]: El nombre de la cola server es: %s\n", serverQueue);

    funcionLog(mensaje);

    sprintf(clientQueue, "%s-%s", CLIENT_QUEUE, getenv("USER"));

    printf("[Cliente]: El nombre de la cola client es: %s\n", clientQueue);

    sprintf(mensaje, "[Cliente]: El nombre de la cola client es: %s\n", clientQueue );

    funcionLog(mensaje);

    servidor = mq_open(serverQueue, O_WRONLY);

    cliente = mq_open(clientQueue, O_RDONLY);

	if( servidor == (mqd_t)-1 || cliente == (mqd_t) -1 )
	{
      	perror("Error al abrir las colas");
      	funcionLog("Error al abrir las colas");
      	exit(-1);
	}

    printf ("[Cliente]: El descriptor de la cola server es: %d\n", (int) servidor);

    sprintf(mensaje, "[Cliente]: El descriptor de la cola server es: %d\n", (int) servidor);

    funcionLog(mensaje);

    printf(" [Cliente]: El descriptor de la cola cliente es: %d\n", (int) cliente);

    sprintf(mensaje, " [Cliente]: El descriptor de la cola cliente es: %d\n", (int) cliente);

    funcionLog(mensaje);

	printf("Mandando mensajes al servidor (escribir \"%s\" para parar):\n", MSG_STOP);

	sprintf(mensaje, "Mandando mensajes al servidor (escribir \"%s\" para parar):\n", MSG_STOP);

	do
	{
		
		printf("> ");

		fgets(buffer, MAX_SIZE, stdin);
		
		if(mq_send( servidor, buffer, MAX_SIZE, 0) != 0)
		{
			perror("Error al enviar el mensaje");
			funcionLog("Error al enviar el mensaje");
			exit(-1);
		}

		if( strncmp( buffer, MSG_STOP, strlen(MSG_STOP)) != 0)
		{
			
			bytes_read = mq_receive( cliente, mensaje, MAX_SIZE, NULL);

			if( bytes_read < 0)
			{

				perror("Error al recibir el mensaje");
				
				funcionLog("Error al enviar el mensaje");
				
				exit(-1);
			
			}

			printf(" Recibido el mensaje: %s\n", mensaje);

			funcionLog(" Recibido el mensaje: ");

			funcionLog(mensaje);
		
		}

		
	// Iterar hasta escribir el código de salida
	
	}while (strncmp(buffer, MSG_STOP, strlen(MSG_STOP)));

	if( mq_close(servidor) == (mqd_t)-1 || mq_close(cliente) == (mqd_t)-1)
	{
		
		perror("Error al cerrar la cola del servidor");
		
		funcionLog("Error al cerrar la cola del servidor");

		exit(-1);
	
	}

	return 0;

}


void funcionLog(char *mensaje)
{
	
	int resultado;
	
	char nombreFichero[100], mensajeAEscribir[300];
	
	time_t t;

	sprintf(nombreFichero,"log-cliente.txt");

	if(fLog==NULL)
	{
		fLog = fopen(nombreFichero,"at");
		
		if(fLog==NULL)
		{
			
			perror("Error abriendo el fichero de log");
			
			exit(1);
		
		}
	
	}

	t = time(NULL);
	
	struct tm * p = localtime(&t);
	
	strftime(mensajeAEscribir, 1000, "[%Y-%m-%d, %H:%M:%S]", p);
	
	sprintf(mensajeAEscribir, "%s ==> %s\n", mensajeAEscribir, mensaje);

	resultado = fputs(mensajeAEscribir,fLog);

	if (resultado < 0) perror("Error escribiendo en el fichero de log");

	fclose(fLog);
	
	fLog=NULL;

}
