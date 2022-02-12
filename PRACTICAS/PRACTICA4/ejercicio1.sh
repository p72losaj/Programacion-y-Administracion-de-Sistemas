#Ejercicio 1

# Script que recibe el fichero "peliculas.txt" y ejecuta los comandos adecuados de 'grep' que permiten realizar las siguientes tareas:

#	1. Mostrar aquellas lı́neas que contienen la duración de la pelı́cula 
#	(al principio de la lı́nea, un dı́gito, una “h”, un espacio, dos dı́gitos y la secuencia “min”).

#	2. Mostrar aquellas lı́neas que contienen el paı́s de la pelı́cula (suponemos que siempre aparecerá rodeado de corchetes, p.ej. “[Estados 		Unidos]”).

#	3. Mostrar solo los paises (sin la linea completa)

#	4. Contar las peliculas de 2016 y 2017

#	5. Mostrar todo el fichero pero sin lı́neas vacı́as.

#	6. Mostrar aquellas lı́neas que empiezan por la letra E o por la letra L (haya o no espacios antes de la misma). 

#	7. Mostrar aquellas lı́neas que contengan una letra ’d’, ’l’ o ’t’, una vocal, y la misma letra 
#	(por ejemplo, “soldados”, “lila”, “expectativas”...).

#	8. Todas aquellas lı́neas que tengan, en total, 8 vocales a o más (mayúsculas o minúsculas y no necesariamente seguidas).

#	9. 9. Mostrar aquellas lı́neas que terminan con tres puntos (“...”) y no empiezan por espacio, utilizando el operador de repetición 
#	\{...\} o {...}.

#	10. Utilizar sed para mostrar, entre comillas dobles, las vocales con tilde (mayúsculas o minúsculas).

#!bin/bash

# Comprobamos la lista de argumentos

if [ $# -ne 1 ]
then 
	echo " Error en la lista de argumentos. Introduce lo siguiente: ./ejercicio1.sh <nombre_fichero.txt>"
	exit 1
fi

# Comprobamos el fichero

if [ ! -f "$1" ]
then
	echo " Error. $1 no es un fichero"
	exit 1
fi

# Realizamos los ejercicios

echo "*******"
echo -e "\n1. Lineas con la duracion de la pelicula: "

cat $1 | grep -E '^[[:digit:]]'

#cat $1 | sed -r -n -e 's/([[:digit:]]*)(h) ([[:digit:]]*)(min)/\1\2 \3\4/p' #hora'h' min'min'

# (al principio de la lı́nea, un dı́gito, una “h”, un espacio, dos dı́gitos y la secuencia “min”).
echo "*******"
echo -e "\n2. Lineas con el pais de las peliculas: "
cat $1 | grep -E '\[.+]'
# suponemos que siempre aparecerá rodeado de corchetes
echo "*******"
echo -e "\n3. Solo el pais de las peliculas: "
cat $1 | grep -o -E '\[.+]'
# sin la linea completa
echo "*******"
pelis2016=$(cat $1 | grep -E '[[:digit:]]+/[[:digit:]]+/2016' | wc -l)
pelis2017=$(cat $1 | grep -E '[[:digit:]]+/[[:digit:]]+/2017' | wc -l)
echo -e "\n4) Hay $pelis2016 películas del 2016 y $pelis2017 películas del 2017"
echo "*******"
echo -e "\n5) Eliminar líneas vacías: "
cat $1 | grep -v '.'
cat $1 | grep '.'
#cat $1 | grep -v '^$'
#cat $1 | sed '/./!d'
#cat $1 | sed '/^$/d'
echo "*******"
echo -e "\n6) Líneas que empiezan por la letra E o por la letra L (con o sin espacios antes):"
cat $1 | grep -E '^[[:space:]]*(E|L)' 
echo "*******"
echo -e "\n7) Líneas que contienen d, l o t, una vocal y la misma letra: "
cat $1 | grep -E '([d,l,t])[aeiou]\1'
echo "*******"
echo -e "\n8) Líneas que contienen ocho aes o más: "
cat $1 | grep -E -i '([Aa].*){8,}'
echo "*******"
echo -e "\n9) Líneas que terminan con tres puntos o no empiezan por espacio: "
cat $1 | grep -E '^([^ ]).*(\.{3,3})$'
echo "*******"
echo -e "\n10) Mostrar entre comillas las vocales con tilde: "
cat $1 | sed -r -e 's/([áéíóúÁÉÍÓÚ])/"\1"/g'
echo "*******"



