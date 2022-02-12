# EJERCICIO 4

#Script que realiza lo siguiente:
	# Muestra el número de archivos en el directorio actual (sin contar directorios)
	# Muestra una lista ordenada de los usuarios logeados en el sistema en el instante de ejecución, eliminando los repetidos.
	# Imprime el número de veces que aparece un determinado carácter (solicitado al usuario) en nombres de ficheros contenidos en la carpeta actual o en alguna subcarpeta. Si no se indica el carácter en 5 segundos, utiliza la letra 'a'.

#!/bin/bash
echo -e "\n"

# CONTAMOS LOS ARCHIVOS

clear # Limpiamos el texto de la consola

for x in `ls -l`
do
	if [[ -f $x ]]
	then
		let nArchivos+=1 #Contador de archivos
	fi
done

echo "El número de archivos en la carpeta actual es "$nArchivos""
echo "\n"

# MOSTRAMOS LOS USUARIOS LOGUEADOS

echo "Esta sería la lista de usuarios conectados en este momento:"

# who --> muestra información sobre los usuarios que están actualmente logeados
# awk '{print $1}' --> extrae el nombre de login que se le pase (who)
# sort -k1 --> ordena según la columna 1 (nombre_login) que se le pasa por tuberías
# uniq --> evita elementos duplicados entre todos los que se le pasen por tuberías
who | awk '{print $1}' | sort -k1 | uniq

echo "\n"

# CONTAMOS CARACTERES

echo "¿Qué carácter quieres contar?"
read -t5 caracter #Espera durante 5 segundos para leer por teclado

#Si no se introduce ningún carácter, se tomará 'a' por defecto
if [[ -z $caracter ]]
then
	caracter=a
fi

nCaracter=0; # variable que cuenta el numero de caracteres

#Recorremos los ficheros de la carpeta actual y de las subcarpetas
# ls -R --> Lista todo, incluyendo subcarpetas y sus ficheros
for x in `ls -R`
do
if [[ $x =~ $caracter ]] 
	then
		let nCaracter=$nCaracter+1;
	fi

done

echo "El carácter '$caracter' aparece $nCaracter veces en nombres de ficheros o carpetas contenidos en la carpeta actual."


echo -e "\n"



