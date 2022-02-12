#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>

void menu();
void mostrarGrupo();

int main(int argc, char* argv[])
{

    char* login;    //usuario
    struct passwd *pw;  // informacion usuario
    struct group *gr;   // informacion grupo
    if(argc == 1)
    {
    	// Caso de error al obtener el el usuario o su informacion

        if ( (login = getenv("USER")) == NULL || (pw = getpwnam(login)) == NULL) menu();

		else
		{

	        printf("Nombre: %s\n", pw->pw_gecos); // Nombre del usuario

       		printf("Login: %s\n", pw->pw_name);	// login del usuario

	        printf("Password: %s\n", pw->pw_passwd); // Contraseña del usuario

        	printf("UID: %d\n", pw->pw_uid); // Numero identificativo del usuario

	        printf("Home: %s\n", pw->pw_dir); // Direccion del usuario

        	printf("Shell: %s\n", pw->pw_shell);

	        printf("Numero de grupo principal: %d\n", pw->pw_gid);  

        	gr = getgrgid(pw->pw_gid); // Obtenemos el grupo del usuario

	        printf("Nombre del grupo principal: %s\n", gr->gr_name); // grupo principal del usuario

		}
    }

    else
    {
        int c; // Comprueba si se han obtenido los comandos posibles
        
        // Estructura de los comandos posibles

        static struct option long_options[] =
        {
            
            {"username", required_argument, 0, 'u' },
            {"bactive", no_argument, 0, 'b' },
            {"useruid", no_argument, 0, 'i' },
            {"groupname", required_argument, 0, 'g' },
            {"groupuid", required_argument, 0, 'd' },
            {"allgroups", required_argument, 0, 's' },
            {"allinfo", required_argument, 0, 'a'},

            /* Necesario para indicar el final de las opciones */

            {0, 0, 0, 0} // los 4 ceros es otra opción de argumentos

        };

        // Comandos sin argumentos requeridos

        int bflag=0, hflag=0, sflag = 0;

        // Comandos con argumentos requeridos

        char *ivalue=NULL, *uvalue=NULL,*gvalue=NULL, *dvalue=NULL, *avalue=NULL;

        // Opcion del argumento

        int option_index=0;

        // Comprobamos los comandos introducidos

        while((c=getopt_long(argc,argv,"h,s,b,g:d:a:u:i:",long_options,&option_index))!=-1)
        {
            switch(c)
            {
                
                // Caso de error

                if(c==-1)
                {
                	printf(" Error al obtener el comando\n");
                	break;
                } 

                // Ayuda
					
				case 'h':
					
					hflag = 1;
			
				break;
            
            	// Informacion del usuario correspondiente a su estructura passwd.

            	case 'u':
                	
                	uvalue=optarg;
            
            	break;

            	// Informacion del grupo actual

                case 'b':
                    
                    bflag=1;
                
                break;
                
                // Informacion del usuario correspondiente a su estructura passwd.

                case 'i':

                    ivalue=optarg;
                
                break;
                
                // Información del usuario correspondiente a su estructura group.

                case 'g':
                    
                    gvalue = optarg;
                    
                break;
                
                // Información del usuario correspondiente a su estructura group.

                case 'd':
                    
                    dvalue = optarg;
                    
                break;
                
                // Mostrar todos los grupos del sistema, junto a su identificador

                case 's':
                    
                    sflag = 1;
				
				break;
                
                // Mostrar toda la informacion de un usuario

                case 'a':
                    
                    avalue = optarg;
                
                break;
                
                // Caso de duda

                case '?':
                    
                    menu();   
                
                break;
                
                // Caso de no cumplirse nada de lo anterior

                default:
                    abort();
            
            }
           
        } // while

        // Errores de argumentos unidos

        if( (uvalue!=NULL) && (ivalue!=NULL))
        {
        	printf(" No se pueden activar estas 2 opciones a la vez: -u -i\n");
        	menu();
        } // if

        if( (uvalue!=NULL) && (avalue!=NULL))
        {
        	printf(" No se pueden activar estas 2 opciones a la vez: -u -a\n");
        	menu();
        } // if

        if( (ivalue!=NULL) && (avalue!=NULL))
        {
        	printf(" No se pueden activar estas 2 opciones a la vez: -i -a\n");
        	menu();
        } // if

        if( (gvalue != NULL ) && (dvalue != NULL))
        {
        	printf(" No se pueden activar estas 2 opciones a la vez: -g -d\n");
        	menu();
        } // if

		if(bflag==1)
		{
			if( (login = getenv("USER"))==NULL || (pw = getpwnam(login))==NULL) menu();
			
			printf(" Numero del grupo principal: %d\n", pw->pw_gid);
			
			printf(" Nombre del grupo principal: %s\n", pw->pw_name);
		
		} // if

		if(sflag==1)
		{
            
            char * line = NULL;
            
            size_t len = 0;
            
            ssize_t read;
            
            char* token;
            
            char delimitador[] = ":";
            
            FILE * fp;
            
            fp = fopen("/etc/group", "r");

            if (fp == NULL) exit(EXIT_FAILURE);

            while ((read = getline(&line, &len, fp)) != -1) 
            {
                
                token = strtok(line, delimitador);
                
                gr = getgrnam(token);
                
                printf(" Nombre del grupo : %s. Identificador = %d\n", gr->gr_name, gr->gr_gid);
                
            }//while

            if(line) free(fp);
		
		}//if

        if(uvalue!=NULL)
        {
            
			if ( (login = uvalue) ==NULL || ( pw = getpwnam(login))==NULL )
			{
				
				printf(" Error al introducir el nombre del usuario\n");
				
				menu();
			
			} // if

			printf("Nombre: %s\n", pw->pw_gecos); 
		    
		    printf("Login: %s\n", pw->pw_name);
            
            printf("Password: %s\n", pw->pw_passwd);
		    
		    printf("UID: %d\n", pw->pw_uid);
		    
		    printf("Home: %s\n", pw->pw_dir);
		    
		    printf("Shell: %s\n", pw->pw_shell);
		    
		    printf("Numero de grupo principal: %d\n", pw->pw_gid);

        } // if

        if(avalue!=NULL)
		{
			if( (login=avalue)==NULL || (pw=getpwnam(login))==NULL)
			{
					
				printf(" Error al introducir el nombre del usuario\n");
					
				menu();
				
			} // if

			printf(" Nombre: %s\n", pw->pw_gecos);
				
			printf(" Login: %s\n", pw->pw_name);
				
			printf(" Password: %s\n", pw->pw_passwd);
				
			printf(" UID: %d\n", pw->pw_uid);
				
			printf(" Home: %s\n", pw->pw_dir);
				
			printf(" Shell: %s\n", pw->pw_shell);
				
			printf(" Numero del grupo principal: %d\n", pw->pw_gid);
				
			gr = getgrgid(pw->pw_gid);
				
			printf(" Nombre del grupo principal: %s\n", gr->gr_name);
			
		} // if

		if(gvalue!=NULL)
		{
			
			if( (login = gvalue)==NULL || (pw = getpwnam(login))==NULL)
			{
				
				printf(" Error al introducir el grupo\n");
				
				menu();
			
			} // if	
			
				printf(" Numero de grupo principal: %d\n", pw->pw_gid);
				
				gr = getgrgid(pw->pw_gid);
				
				printf(" Nombre de grupo principal: %s\n", gr->gr_name);
			
		} // if

		if(ivalue!=NULL)
		{
			
			if( (pw = getpwuid(atoi(ivalue)))==NULL)
			{
				
				printf(" Error al introducir el identificador del usuario\n");
				
				menu();
			
			} // if

			printf(" Nombre: %s\n", pw->pw_gecos);
			
			printf(" Login: %s\n", pw->pw_name);
			
			printf(" Password: %s\n", pw->pw_passwd);
			
			printf(" UID: %d\n", pw->pw_uid);
			
			printf(" Home: %s\n", pw->pw_dir);
			
			printf(" Shell: %s\n", pw->pw_shell);
			
			printf(" Numero de grupo principal: %d\n", pw->pw_gid);

		} // if

		if( dvalue != NULL)
		{
			
			if( (gr = getgrgid(atoi(dvalue)))==NULL)
			{
				
				printf(" Error al introducir el identificador del grupo\n");
				
				menu();
			
			} // if
			
			printf(" Nombre del grupo: %s\n", gr -> gr_name);
			
			printf(" Numero de grupo: %d\n", gr->gr_gid);

		} // if

		if(hflag==1) menu();
		

	    if (optind < argc)
	    {

	        printf("Argumentos ARGV que no son opciones: ");
	        
	        while (optind < argc) printf("%s ", argv[optind++]);
	        
	        menu();

	    } // if

	} // while

    exit(0);

} // main


void menu()
{
	
	printf(" Uso del programa: a.out [opciones]\n");
	
	printf(" Opciones: \n");
	
	printf(" -h, --help\t Imprimir esta ayuda\n");
	
	printf(" -u, --username\t Nombre de usuario\n");
	
	printf(" -i, --useruid\t Identificador de Usuario\n");
	
	printf(" -g, --groupname\t Nombre de grupo\n");
	
	printf(" -d, --groupuid\t Identificador de grupo\n");
	
	printf(" -s, --allgroups\t Muestra info de todos los grupos del sistema\n");
	
	printf(" -a, --allinfo\t Nombre de usuario\n");
	
	printf(" -b, --bactive\t Muestra info grupo Usuario Actual\n");
	
	exit(-1);

} // menu