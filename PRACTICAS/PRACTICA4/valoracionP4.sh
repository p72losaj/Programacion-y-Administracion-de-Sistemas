#!/bin/bash

# Apartado a: Utilizando sed, hacer un script que, dado el fichero de texto peliculas.txt,elimine las líneas vacías y los subrayados, extraiga el título de la película y lo sitúe en una línea independiente como “Título: XXX”, la fecha de estreno como “|-> Fecha de estreno:XXX”, formatee el director y el reparto como “|-> Director: XXX” y “|-> Reparto: XXX”,la duración como “|-> Duración: XXX” y la sinopsis como“|->Sinopsis:XXX”.Detrás de cada línea,incluir el número de caracteres de la linea ya formateada. El script recibira el nombre del fichero por la linea de comandos.

if [ $# -ne 1 ]
then
	echo "Error de argumentos. introduce: $0 ficherosPr4/peliculas.txt"
	exit 1	
fi

if [ ! -f $1 ]
then 
	echo "$1 no es un fichero de texto."
	exit 1
fi


echo " Primera parte del ejercicio "

fecha=$(cat $1 | sed -r -e 's/(\(.*\/.*\/.*\)) (.+)/|-> Fecha de estreno: \1/' | wc -l)

director=$(cat $1 | sed -r -e 's/Dirigida por (.+)$/|-> Director: \1/' | wc -l)

reparto=$(cat $1 | sed -r -e 's/Reparto: (.+)/|-> Reparto: \1/' | wc -l )

duracion=$(cat $1 | sed -r -e 's/([[:digit:]]h [[:digit:]]*min)/|-> Duración: \1/' | wc -l)

sinopsis=$(cat $1 | sed -r -e 's/(^ +.+)/|-> Sinopsis: \1/' | wc -l)

titulo=$(cat $1 | sed -r -e 's/(^[^(|)].*)/Título: \1/' | wc -l)

cat $1 | sed -e '/^$/d' | sed -r -e '/==+/d'| sed -r -e 's/(\(.*\/.*\/.*\)) (.+)/|-> Fecha de estreno: \1 ------> '$fecha' /' | sed -r -e 's/Dirigida por (.+)$/|-> Director: \1------> '$director'/' | sed -r -e 's/Reparto: (.+)/|-> Reparto: \1--------> '$reparto' /' | sed -r -e 's/([[:digit:]]h [[:digit:]]*min)/|-> Duración: \1-------> '$duracion' /' | sed -r -e 's/(^ +.+)/|-> Sinopsis: \1----------> '$sinopsis' /' | sed -r -e 's/(^[^(|)].*)/Título: \1--------> '$titulo' /'


# Apartado b: Mostrar de nuevo toda la salida anterior,pero esta vez filtrando mediante grep para que aparezcan solo aquella lineas que contengan una t (mayuscula o minuscula), una vocal y un tercer caracter que sea espacio o m. Si fuese necesario utilizar ficheros temporales,asegurar que el nombre de fichero sea unico. Se deben borrar todos los ficheros temporales necesarios

echo "------------------"

echo " Segunda parte del ejercicio"

cat $1 | sed -e '/^$/d' | sed -r -e '/==+/d'| sed -r -e 's/(\(.*\/.*\/.*\)) (.+)/|-> Fecha de estreno: \1 ------> '$fecha' /' | sed -r -e 's/Dirigida por (.+)$/|-> Director: \1------> '$director'/' | sed -r -e 's/Reparto: (.+)/|-> Reparto: \1--------> '$reparto' /' | sed -r -e 's/([[:digit:]]h [[:digit:]]*min)/|-> Duración: \1-------> '$duracion' /' | sed -r -e 's/(^ +.+)/|-> Sinopsis: \1----------> '$sinopsis' /' | sed -r -e 's/(^[^(|)].*)/Título: \1--------> '$titulo' /' | grep -E '[Tt][aeiouáéíóúAEIOUÁÉÍÓÚ][ m]'




