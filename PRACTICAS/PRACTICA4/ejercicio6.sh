
# Script que muestra el contenido del fichero /etc/passwd (y parte del fichero /etc/group) de forma amigable. 
# Recibirá un único argumento que será un 1 o un 0. 
# Si el argumento es 1, se mostrarán aquellos usuarios cuyo UID sea mayor que 1000.
# Si el argumento es 0, se mostrarán todos los usuarios
# Por cada usuario se imprimirá: 
	# 'logname' del usuario
	# 'UID' del usuario
	# 'groupname' de su grupo primario
	# 'GID' de su grupo primario
	# Información 'gecos'
	# Carpeta personal
	# 'Shell' por defecto
	
#!/bin/bash

if [ $# -ne 1 ]
then
	echo "ERROR:Debe ser ./ejercicio6.sh 1/0 "
	exit 1
fi


if [ $1 == 0 ]
then
	echo " Mostrando todos los usuarios"
	cat /etc/passwd | sed -r -e "s/^(.*):.*:(.*):(.*):(.*):(.*):/Logname:\1\n->UID:\2\n->Grupo:\n->GID:\3\n->gecos:\4\n->Home:\5\n->Shell por defecto:/"
fi
 
if [ $1 == 1 ]
then 
	awk -F: '$3 >= 1000 {print "->Logname: " $1 "\n->UID: " $3 "\n->GID: " $4 "\n->gecos: " $5 "\n->Home: " $6 "\n->Shell por defecto: " $7} ' /etc/passwd
fi

# awk -F: '$3 >= 1000 {print $1}' /etc/passwd
