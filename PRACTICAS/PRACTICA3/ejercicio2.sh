
# ********** EJERCICIO 2 *********

#Script que recibe un directorio y un número de bytes (opcional). 
#Busca los ficheros del directorio cuyo tamaño en bytes sea igual o mayor al indicado (si no se ha indicado ninguno, se tomarán 0 bytes). 

#De cada fichero mostrará:
	# Nombre del fichero (sin ruta)
	# Número de caracteres del nombre del usuario propietario
	# Fecha de creación (se utilizará la de modificación) y del último acceso
	# Tamaño en bytes y número de bloques que ocupa en memoria
	# Cadena de permisos
	# Un 1 si es ejecutable o un 0 si no lo es

# Separará estos campos por ";" y la salida se ordenará por tamaño (de menor a mayor). 

#Si redirigimos la salida a un archivo .csv, se debería poder abrir con LibreOffice (elegir como separador el punto y coma).

#!/bin/bash

# Control de argumentos

if [ $# -eq 0 ] || [ $# -ge 3 ];
then
	echo "ERROR: Debe introducir $0 <nombre_directorio> y, si lo desea, una cantidad de bytes"
	echo -e "\n"
	exit 1
	
#Si solo se ha introducido un parámetro (nombre del directorio), la cantidad de bytes será 0 y se deberán tener en cuenta todos los ficheros del directorio.

#Si se han introducido dos parámetros, el segundo será la cantidad de bytes y se tendrán en cuenta solo los ficheros cuyo tamaño sea igual o superior a esa cantidad de bytes

else
	if [ $# -eq 1 ];
	then
		tam=0
	else
		tam=$2
fi

# Procesamiento 

intro=0 #Variable para saber si ya se han imprimido los nombres de las columnas (variables)

#Buscamos los ficheros cuyo tamaño sea igual o superior al indicado. 
#Escribiendo una c detrás de la variable donde se guardará el número de bytes indicamos que este número se corresponderá específicamente con bytes. 
#Si no pusiéramos nada, el número indicado actuaría, por defecto, como cantidad de bloques.

for x in $(find $1 -size "$tam"c -or -size +"$tam"c)
do
	if [ "$intro" -eq 0 ]
	then
		echo -e "\n"
		echo "Nombre; LongitudUsuario; FechaModificacion; FechaAcceso; Tamaño; Bloques; Permisos; Ejecutable"
		intro=1
	fi
		
	if [ -x $x ]; # -x --> si es ejecutable
	then
		ejecutable=1 #Imprimimos un 1 si lo es
	else
		ejecutable=0 #Imprimimos un 0 si no lo es
	fi
	
	nombre=$(basename $x) # basename --> muestra solo el nombre (sin ruta)
	
	# wc -m --> muestra la cantidad de caracteres de la cadena que se le pase. Mediante tuberías, le pasamos el nombre del propietario. 	 		Como también cuenta el \n, debemos restarle 1
	# let --> guarda el valor total de la resta en longtudUsuario, así permitimos que imprima, por ejemplo, 8 en lugar de 9-1.

	let longitudUsuario=$(stat -c "%U" $x | wc -m)-1
	
	# stat -c " " $x --> muestra del fichero $x (consultar man):
	# "%U" --> nombre del usuario propietario
		
	fechaModificacion=$(stat -c "%y" $x) # "%y" --> última fecha de modificación
	fechaAcceso=$(stat -c "%x" $x)       # "%x" --> última fecha de acceso
	tamano=$(stat -c "%s" $x)            # "%s" --> tamaño en bytes
	nBloques=$(stat -c "%b" $x)          # "%b" --> cantidad de bloques
	permisos=$(stat -c "%A" $x)          # "%A" --> permisos
	
	echo "$nombre; $longitudUsuario; $fechaModificacion; $fechaAcceso; $tamano; $nBloques; $permisos; $ejecutable"

# sort:
# -n --> ordena de menor a mayor
# -k5 --> indica que ordena según lo introducido en la columna 5 -> $tamano
# -t ";" --> indica que el carácter separador de las columnas es el punto y coma
done | sort -n -k5 -t ";"
fi

echo -e "\n"


