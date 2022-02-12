# Utilizando sed, hacer un script que dado el fichero peliculas.txt, haga lo siguiente:

#!/bin/bash

# Recibimos el fichero como argumento
if [ $# -ne 1 ]
then
	echo "Error de argumentos. introduce: ./ejercicio2.sh ficherosPr4/peliculas.txt"
	exit 1	
fi

if [ ! -f $1 ]
then 
	echo "$1 no es un fichero de texto."
	exit 1
fi


#

# Elimine las líneas vacías y los subrayados.
# Fecha de estreno como: |-> Fecha de estreno: XXX
# Director como: |-> Director: XXX
# Reparto como: |-> Reparto: XXX
# Duración como: |-> Duracion: XXX
# Extraiga el título y lo sitúe en una línea independiente como: "Título: XXX"

cat $1 | sed -e '/^$/d' | sed -r -e '/==+/d' | sed -r -e 's/(\(.*\/.*\/.*\)) (.+)/|-> Fecha de estreno: \1/' | sed -r -e 's/Dirigida por (.+)$/|-> Director: \1/' | sed -r -e 's/Reparto: (.+)/|-> Reparto: \1/' | sed -r -e 's/([[:digit:]]h [[:digit:]]*min)/|-> Duración: \1/' | sed -r -e '/^ +.+/d'  | sed -r -e 's/(^[^(|)].*)/Título: \1/'












