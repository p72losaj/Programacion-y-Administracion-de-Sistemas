
# ********** EJERCICIO 5 **********

#Script que lee información de la carpeta /proc/ e imprime:
	# Modelo de procesador y Megahercios.
	# Tamaño de caché e identificador de vendedor.
	# Número máximo de hilos de ejecución.
	# Puntos de montaje activos, incluyendo el punto de montaje, el dispositivo y el tipo de dispositivo. Ordenarlos de forma alfabética inversa por punto de montaje.
	# Listado de todas las particiones disponibles, junto con su número de bloques. Ordenarlas de forma alfabética inversa por partición.
#Los ficheros que se consultarán son /proc/cpuinfo, /proc/mounts y /proc/partitions.



#!/bin/bash

#Modelo de procesador
cat /proc/cpuinfo | sed -n -r -e 's/model name[[:blank:]]*: (.+)/Modelo de procesador: \1/p' | head -1

#Megahercios
cat /proc/cpuinfo | sed -n -r -e 's/cpu MHz[[:blank:]]*: (.+)/Megahercios: \1/p' | head -1

#Hilos de ejecución
echo "Número de hilos de ejecución: $(cat /proc/cpuinfo | grep -E 'processor[[:blank:]]*: .+' | wc -l)"

#Tamaño de caché
cat /proc/cpuinfo | sed -n -r -e 's/cache size[[:blank:]]*: (.+)/Tamaño de caché: \1/p' | head -1

#Identificador del vendedor
cat /proc/cpuinfo | sed -n -r -e 's/vendor_id[[:blank:]]*: (.+)/ID vendedor: \1/p' | head -1

echo -e "\n"
echo "Puntos de montaje:"
cat /proc/mounts | sed -r -e 's/([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)/->Punto de montaje: \2, Dispositivo: \1, Tipo de dispositivo: \3/' | sort -r -k2 # -r  --> inverso


echo -e "\n"
echo "Particiones y número de bloques:"
cat /proc/partitions | sed -e '1,2d' | sed -n -r -e 's/ *([[:digit:]]+) *([[:digit:]]+) *([[:digit:]]+) *([[:alnum:]]+)/->Partición: \4, Número de bloques: \3/p' | sort -r -k2


echo -e "\n"

