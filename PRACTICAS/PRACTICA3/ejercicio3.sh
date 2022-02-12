# EJERCICIO 3 

#Script que clasifica los ficheros de una carpeta según su tamaño en pequeños, medianos y grandes. El primer argumento será la carpeta a procesor (obligatorio) y los otros dos argumentos (opcionales) serán el numero de elementos a incluir en la carpeta pequenos y grandes (sus valores por defecto serán 4). Se crearán tres subcarpetas (pequenos, medianos y grandes) donde copiaremos los ficheros clasificados. Se comprobará si ya existen las carpetas, en cuyo caso se borrarán para volver a crearse.


#!/bin/bash
 
# CONTROL DE ARGUMENTOS

tam1=1 # numero de elementos en la carpeta pequenos
tam2=1 # numero de elementos en la carpeta grande

if [ $# -eq 0 ] || [ $# -ge 4 ];
then
	echo "ERROR: Debe introducir $0 <nombre_directorio> y, si lo desea, <numero de elementos carpeta pequeña> y/o <numero de elementos carpeta grande>."
	exit 1
else
	
	if [ $# -eq 1 ]; # numero de elementos por defecto de las carpetas pequeña y grande
	then
		p=4
		g=4
		else
			if [ $# -eq 2 ]; # numero de elementos de las carpetas pequeña por usuario
			then
				p=$2
				g=4
			fi

			if [ $# -eq 3 ]; # numero de elementos de las carpetas pequeña y grande por usuario
			then
				p=$2
				g=$3
			fi
	fi 

	#Comprobamos si ya existen las carpetas, en cuyo caso las borraremos

	if [ -e pequenos ] && [ -e medianos ] && [ -e grandes ] # -e comprueba la existencia
	then
		echo "Borrando las carpetas pequenos, medianos y grandes..." 
		# -d --> borramos los directorios
		# -r --> borramos recursivamente todo lo que contengan
		rm -d -r pequenos
		rm -d -r medianos
		rm -d -r grandes
	fi

	# Obtenemos el numero total de archivos en la carpeta
	
	total=0

	for x in $(find $1)
	do
		let total=$total+1
	done
	
	let suma=p+g

	if [ $total -lt $suma ]
	then
		echo "Los valores son incorrectos, no hay suficientes archivos"
		exit 1
	fi

	#Ahora creamos las nuevas carpetas de salida donde se copiarán los ficheros clasificados por tamaño
	echo "Creando las carpetas pequenos, medianos y grandes..." 
	mkdir pequenos
	mkdir medianos
	mkdir grandes

	echo "Copiando los archivos..."

	#Clasificamos los ficheros

	for x in $(find $1)
	do

		# numero de elementos de la carpeta pequeños sea correcto y el elemento a introducir sea un fichero

		if [ $tam1 -le $p ] && [ -f $x ]
		then
			cp $x pequenos # Copiamos el fichero en la carpeta pequenos
			let tam1=$tam1+1
		else
			# Si la carpeta pequenos tiene introducidos sus elementos, entonces introducimos los ficheros en la carpeta grandes

			if [ $tam1 -gt $p ] && [ $tam2 -le $g ] && [ -f $x ]
			then
				cp $x grandes # copiamos el fichero en la carpeta grandes
				let tam2=$tam2+1
			else
				# guardamos el resto de los ficheros en la carpeta medianos
				if [ -f $x ];
				then
					cp $x medianos
				fi
			fi
		fi
	
		
	done

fi


