# Ejercicio 1
# Scrip que cuenta los ficheros con extensión .c .h del directorio como argumento.
# Los muestra ordenados según el número de caracteres (mayor a menor).
# Indica el número de líneas y caracteres que tienen

# Transformamos el fichero en ejecutable: chmod u+x ejercicio1.sh

#!/bin/bash

echo -e "\n"

# Control de argumentos

if [ $# -ne 1 ];

then 

	echo "Error: Debe introducir $0 <nombre_directorio>"
	echo -e "\n"
	exit 1
fi

# Contamos los archivos

c=0;
h=0;

# Buscamos los archivos .c y .h

for x in $(find $1 -name "*.c")
do
	let c=$c+1; # Aumentamos el numero de archivos .c
done


for x in $(find $1 -name "*.h")
do
	let h=$h+1; # Aumentamos el numero de archivos .h
done


#Imprimimos la cantidad de archivos .c y .h por pantalla

echo "Tenemos $c ficheros con extensión .c y $h con extensión .h"
echo -e "\n"

# Imprimimos los archivos

#Buscamos los archivos con extensión .c o .h

for x in $(find $1 -name "*.c" && find -name "*.h")
do
	echo "El fichero $x tiene $(cat $x | wc -l) líneas y $(cat $x | wc -m) caracteres"
# sort -nr --> Se utiliza para ordenar
# -k8 --> le indica a sort que ordene según lo introducido en la columna 8 -> el número de caracteres

# Ordena de menor a mayor

# done | sort -n -k8 

# Ordena de mayor a menor

done | sort -nr -k8
echo -e "\n"




