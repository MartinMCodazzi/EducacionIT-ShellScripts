#! /bin/sh


salida=0
while test $salida != 1 && test $salida != 250
do
	exec 3>&1
	OPCIONALES=`$DIALOG --backtitle "Opciones avanzadas $DOMINIO" \
	--title "Opcionales" \
        --menu "Opciones avanzadas dominio apache" 0 0 0 \
        "Usuario"  	"Cambiar el usuario por defecto"	 \
        "Grupo"    	"Cambiar el grupo por defecto"  	 \
        "MPM" 		"Editar modulo MPM"  				 \
        "HTTPS"    	"Habilitar HTTPS"  					 \
        "www"    	"crear alias www.$DOMINIO" 			 \
		2>&1 1>&3`

		exec 3>&-

		case $OPCIONALES in
			Usuario) echo "Usuario está seleccionado";;
			Grupo) echo "Grupo está seleccionado";;
			MPM) echo "MPM está seleccionado";;
			HTTPS) echo "HTTPS está seleccionado";;
			www) echo "WWW está seleccionado";;
			*) salida=250;;
		esac
done
unset salida
