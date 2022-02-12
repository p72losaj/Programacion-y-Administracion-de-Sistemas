#Script que realiza lo siguiente:

# 1. Mostrar los argumentos introducidos por línea de comandos, para facilitaros la interpretación del script.
# 2. Mostrar el número total de ficheros que hay en la carpeta que le pasamos en el primer argumento.
# 3. Cada fichero muestra:
# 	su tamaño en bytes y nombre con extensión del fichero (sin la ruta)
# 	Numero de lineas del fichero y tipo del fichero
# Lista ordenada en orden inverso
# 4. Realizar una copia de seguridad en el directorio del 2º argumento. En caso de existir, eliminar el contenido previamente.
# El nombre de los documentos que son copia de seguridad será:nombreOriginal-backup-día-mes-año(comando date para la fecha).


#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Error de argumentos. Introduce los argumentos siguientes: $0 <carpeta> <carpeta copia de seguridad (opcional)>"
	exit 1
fi

for x in $(find $1)
do
	if [[ -f $x ]]
	then
		let nArchivos+=1 #Contador de archivos
	fi
done

echo "Carpeta -> $1"

if [ $# -eq 1 ]
then
	echo "No se hace copia de seguridad"	
fi

echo "-----------------------------------"

echo "El numero total de ficheros es $nArchivos"

echo "-----------------------------------"

enter=0 #Variable para saber si ya se han imprimido los nombres de las columnas (variables)

echo "Tamaño'+'Nombre'+'Lineas'+'Tipo"
echo "-------'+'-------'+'-------'+'--------"
for x in $(find $1)
do
	if [ "$enter" -eq 0 ]
	then
		intro=1
	fi
	tamano=$(stat -c "%s" $x) # muestra el tamano del fichero en bytes
	nombre=$(basename $x) # muestra solo el nombre del fichero sin la ruta
	let lineas=$(stat -c "%U" $x | wc -m)-1
	tipo=$(stat -c "%F" $x)

echo "$tamano+$nombre+$lineas+$tipo"
done | sort -n -r -k1 -t "+" # ordenamos el fichero según el tamano, siendo el delimitador +

if [ $# -eq 2 ] #Caso de realizar copia de seguridad
then
	echo -e "\tCarpeta en la que hacer la copia de seguridad: $2"

	if [ -d $2 ] #Si ya existe esa carpeta, borramos su contenido
	then
		echo "La carpeta para copia $2 ya existe. Borrando archivos anteriores..."
		rm -Rf $2
	fi

	echo "Creando copia de los archivos de $1 en $2..."
	mkdir $2

	#Con el comando find, obtengo los ficheros de las carpetas y subcarpetas del directorio dado, usando -type f para que solo muestre ficheros y no carpetas. 
	#Cada linea es un fichero, el cual almaceno en una variable array para despues en eun bucle hacer la copia

	OLDIFS=$IFS
	IFS=$'\n'
	var=($(find $1 -type f))
	IFS=$OLDIFS

	for i in "${var[@]}"
	do
		aux=$(basename $i) 
		cp $i "$2/$aux-backup-$(date +%d-%m-%Y)"
	done
fi



