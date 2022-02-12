
# ********** EJERCICIO 5 **********

#Script que comprime todos los ficheros o directorios introducidos como argumentos en un fichero copia-usuario-fecha.tar.gz, donde usuario es el usuario que está ejecutando el script y fecha es la fecha en segundos desde el 1 de enero de 1970. Este archivo comprimido se moverá al directorio ~/Copia, que habría que crear si no existiera. Al invocar el script, se deberá borrar todos los ficheros de ~/Copia con antigüedad mayor a 200 segundos.


#!/bin/bash
echo -e "\n"



# ----------------------------------
#      CONTROL DE ARGUMENTOS
# ----------------------------------
 
if [ $# -eq 0 ]; #Si no ha introducido ningún argumento
then
	echo "ERROR: Se necesita al menos un fichero o directorio a comprimir"
	echo -e "\n"
	exit 1
fi



# ----------------------------------
#      BORRADO DE ARCHIVOS
# ----------------------------------

#Borramos los archivos del directorio Copia cuya antigüedad sea mayor a 200 segundos
# -type f --> escogemos solo los ficheros
# while read x --> vamos recorriendo todos los ficheros
if [ -d $HOME/Copia ]
then
	find $HOME/Copia/ -type f | while read x
	do
		seg=$(date +%s) #Segundos desde el 1 de enero de 1970
		modif=$(stat -c "%Y" $x) #Última modificación del fichero
	
		diferencia=$(($seg - $modif))
	
		if [ $diferencia -gt 200 ]; #Si la diferencia es mayor a 200 segundos
		then
			rm  $x
			echo "Se ha borrado $x, llevaba $diferencia segundos sin modificarse"
		fi
	done
fi



# ----------------------------------
#     ARRAY DE ARCHIVOS VÁLIDOS
# ----------------------------------

nExist=0 #Variable para contabilizar los ficheros o directorios pasados que sí existen

#Comprimimos los ficheros o directorios y los movemos al directorio Copia. 
# for x --> iteramos sobre la lista de argumentos ($1, $2, $3, ...)
for x
do
	if [ -e $x ];
	then
		fecha=$(date +%s) #Fecha actual
		
		#Si existe, lo pasamos a un array (ignorando los que no existen). Este array será el que comprimamos.
		Array[$nExist]="$x"
		let nExist=$nExist+1
	
	else
		echo "El argumento <$x> no existe."
	fi
done

#Si no se ha introducido ningún argumento válido, termina la ejecución.
if [ $nExist -eq 0 ]
then
	echo "No se ha introducido ningún argumento válido. Terminamos la ejecución."
	exit 1
fi



# ----------------------------------
#          PROCESAMIENTO
# ----------------------------------

#Comprimimos el array
# tar -czf :
	# -c --> Crea un nuevo archivo
	# -z --> Comprime el archivo usando gzip
	# -f --> Nombre del archivo
#Si pusiéramos czvf, v --> Muestra el proceso durante la creación del archivo (Verbose)
tar -czf copia-$USER-$fecha.tar.gz ${Array[*]}
echo "Comprimiendo los archivos..."
		 
#Comprobamos si existe el directorio Copia y, si no, lo creamos. No lo hemos creado antes para asegurarnos que no se queda vacío en el caso en que no se introdujera ningún argumento válido.
if [ ! -e $HOME/Copia ]
then
	echo "Creando la carpeta de copia..."
	mkdir $HOME/Copia
fi

#Movemos el archivo comprimido al directorio Copia		
mv copia-$USER-$fecha.tar.gz $HOME/Copia/ 
	


echo "La copia de seguridad se ha creado correctamente."
echo -e "\n"
	
