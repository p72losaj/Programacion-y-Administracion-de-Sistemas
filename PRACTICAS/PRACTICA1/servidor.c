/*
Servidor que lee de una cola abierta para lectura una cadena de caracteres y la
imprime por pantalla.

Eniva al cliente por otra cola el numero de bits recibidos
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

void funcionLog(char *);

FILE *fLog = NULL;

int main(int argc, char **argv)
{

	mqd_t servidor, cliente;

	struct mq_attr atributo;

	char buffer[MAX_SIZE], mensaje[MAX_SIZE];

	int x, fin = 0;

	atributo.mq_maxmsg = 10;

	atributo.mq_msgsize = MAX_SIZE;

    char serverQueue[MAX_SIZE], clientQueue[MAX_SIZE];

	sprintf(serverQueue, "%s-%s", SERVER_QUEUE, getenv("USER"));

    printf ("[Servidor]: El nombre de la cola servidor es: %s\n", serverQueue);

    sprintf(mensaje, "[Servidor]: El nombre de la cola servidor es: %s\n", serverQueue );

    funcionLog(mensaje);

    sprintf(clientQueue, "%s-%s", CLIENT_QUEUE, getenv("USER"));

    printf(" [Servidor]: El nombre de la cola client es %s\n", clientQueue);

    sprintf(mensaje, " [Servidor]: El nombre de la cola client es %s\n", clientQueue);

    funcionLog(mensaje);

	servidor = mq_open(serverQueue, O_CREAT | O_RDONLY, 0644, &atributo);

    cliente = mq_open(clientQueue, O_CREAT | O_WRONLY, 0644, &atributo);

	if( servidor == (mqd_t) - 1 || cliente == (mqd_t) - 1 )
	{
   		
   		perror("Error al abrir la cola del servidor");

   		funcionLog("Error al abrir la cola del servidor");

    	exit(-1);

	}

    printf (" [Servidor]: El descriptor de la cola servidor es: %d\n", (int) servidor);

    sprintf( mensaje, " [Servidor]: El descriptor de la cola servidor es: %d\n", (int) servidor );

    printf (" [Servidor]: El descriptor de la cola cliente es: %d\n", (int) cliente);

    sprintf( mensaje, " [Servidor]: El descriptor de la cola cliente es: %d\n", (int) cliente );

    funcionLog( mensaje );

	do
	{
		
		ssize_t bytes;

		bytes = mq_receive( servidor, buffer, MAX_SIZE, NULL );

		if( bytes < 0 )
		{
			
			perror( "Error al recibir el mensaje\n" );
			
			funcionLog( "Error al recibir el mensaje\n" );
			
			exit(-1);
		
		}

		if ( strncmp( buffer, MSG_STOP, strlen( MSG_STOP ) ) == 0 ) fin = 1;

		else 
		{
			
			printf("[Servidor]: Recibido el mensaje del cliente: %s\n", buffer);

			sprintf( mensaje, "[Servidor]: Recibido el mensaje del cliente: %s\n", buffer );

			funcionLog( mensaje );

			x = strlen(buffer);

			for( int i=0; i < x; i++)
			{
				if( buffer[i] == ' ' || buffer[i] == '\n' ) x--;
			}

			sprintf(mensaje, "%d", x);

			if( ( mq_send( cliente, mensaje, MAX_SIZE, 0 ) ) != 0 )
			{
				
				perror( " Error al enviar el mensaje" );
				
				funcionLog( " Error al enviar el mensaje" );
				
				exit(-1);
			
			}

		}

	} while ( !fin );

	if( ( mq_close( servidor ) == (mqd_t) - 1 ) || ( ( mq_close( cliente ) ) == (mqd_t) - 1 ) )
	{
		
		perror( "Error al cerrar la cola del servidor" );
		
		funcionLog( "Error al cerrar la cola del servidor" );
		
		exit(-1);
	
	}

	if( ( mq_unlink( serverQueue ) == ( mqd_t ) -1 ) || ( ( mq_unlink( clientQueue ) ) == ( mqd_t ) -1 ) )
	{
		
		perror( " Error al eliminar la cola del servidor " );
		
		funcionLog( " Error al eliminar la cola del servidor " );

		exit(-1);
	
	}

	return 0;

}


/* Función auxiliar, escritura de un log.*/

void funcionLog(char *mensaje)
{
	
	int resultado;
	
	char nombreFichero[100], mensajeAEscribir[300];
	
	time_t t;

	sprintf( nombreFichero, "log-servidor.txt" );
	
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
	
	if (resultado < 0)	perror("Error escribiendo en el fichero de log");

	fclose(fLog);

	fLog=NULL;

}
