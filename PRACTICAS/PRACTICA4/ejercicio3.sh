# Scrip que muestre el número de horas, minutos y segundos que lleva logueado cada usuario, utilizando el comando who y date

#!/bin/bash

if [ $# != 0 ]
then
	echo "La ejecucion del programa es: $0"
	exit 1
fi

OLDIFS=$IFS
IFS=$'\n'

echo " Lista de usuarios conectados, junto con el número de horas, minutos y segundos que llevan conectados: "

for x in $(who)
do
	CONTROL="$(mktemp)"
		
	echo $x > $CONTROL

	user=$(grep -E -o '^[[:alnum:]]*' $CONTROL)
	
	hora=$(grep -E -o '[[:digit:]]*-[[:digit:]]*-[[:digit:]]* [[:digit:]]*:[[:digit:]]*' $CONTROL)
	
	sesion=$(date -d "$hora" +%s)
	rm $CONTROL
	
	actual=$(date +%s)
	
	let diferencia=$actual-$sesion
	
	date -ud @$diferencia +"El usuario $user lleva  %H horas, %M minutos %S segundos conectado."
	
	
done



IFS=$OLDIFS




