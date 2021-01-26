#!/bin/bash
# Alta de webs en apache2, Debian
backtitle="Alta de Webs en APACHE/BIND9"

returncode=0

while test $returncode != 1 && test $returncode != 251
do
	exec 3>&1
	DOMINIO=`$DIALOG --title "Crear dominio" --clear    \
		--backtitle "$backtitle" 						\
	    --inputbox "Ingrese el dominio a dar de alta" 0 0 2>&1 1>&3`
	returncode=$?
	exec 3>&-

	if [ $returncode -eq $DIALOG_CANCEL ] ; then
		break
	fi

	DOCUMENTROOT="/var/www/$DOMINIO"
	ERRORLOG="/var/log/apache2/${DOMINIO}_error.log"
	ACCESSLOG="/var/log/apache2/${DOMINIO}_access.log"

	while test $returncode != 1 && test $returncode != 250
	do
		exec 3>&1
		value=`$DIALOG --clear --ok-label "Crear" 		\
		--backtitle "$backtitle" 						\
		--inputmenu "Caracteristicas del Virtual Host"  \
		20 50 10 										\
		"Dominio:"	"$DOMINIO" 							\
		"DocumentRoot:"	"$DOCUMENTROOT" 				\
		"ErrorLog:"	"$ERRORLOG" 						\
		"AccessLog:"	"$ACCESSLOG" 					\
		2>&1 1>&3`
		#Esto hace que $value valga 0,1 o 3, estos números se referencian más abajo
		returncode=$?
		exec 3>&-

		case $returncode in
			#$DIALOG_CANCEL, sería salida =1
			$DIALOG_CANCEL)
			"$DIALOG" \
			--clear \
			--backtitle "$backtitle" \
			--yesno "Realmente desea salir?" 10 30
			case $? in
				$DIALOG_OK)
					break
				;;
				$DIALOG_CANCEL)
					returncode=99
				;;
			esac
			;;
			$DIALOG_OK)
				while test $returncode != 1 && test $returncode != 250
				do
				# Esto seía $value=0 , cuando le damos a "crear"
					"$DIALOG" --clear 					\
					--backtitle "$backtitle"         	\
					--extra-button                   	\
					--extra-label "Avanzados"         	\
					--yesno "Desea crear el VHost? \n\
					$DOMINIO \n\
					DocumentRoot: $DOCUMENTROOT \n\
					ErrorLog: $ERRORLOG \n\
					AccessLog: $ACCESSLOG \n\
					" 0 0

					case "$?" in
						$DIALOG_EXTRA)
							. ./AvanzadosApache.sh
						;;
						$DIALOG_OK)
							#ACA se haría la magia

							"$DIALOG" --clear 					  \
							--backtitle "$backtitle" 			  \
							--yesno "Desea crear otro dominio?" 0 0
							case $? in
								$DIALOG_OK)
									returncode=250
								;;
								$DIALOG_CANCEL)
								    returncode=251
									break
								;;
							esac
						;;
						$DIALOG_CANCEL)
							returncode=25
							break
						;;
					esac
				done
				break
				;;

			$DIALOG_EXTRA)
				# Esto se ejecuta cuando cambiamos algo
				tag=`echo "$value" | sed -e 's/^RENAMED //' -e 's/:.*//'`
				item=`echo "$value" | sed -e 's/^[^:]*:[ ]*//' -e 's/[ ]*$//'`

				case "$tag" in
					Dominio)
						DOMINIO="$item"
						DOCUMENTROOT="/var/www/$item"
						ERRORLOG="/var/log/apache2/${item}_error.log"
						ACCESSLOG="/var/log/apache2/${item}_access.log"
					;;
					DocumentRoot)
						DOCUMENTROOT="$item"
					;;
					ErrorLog)
						ERRORLOG="$item"
					;;
					AccessLog)
						ACCESSLOG="$item"
					;;
				esac
			;;
			$DIALOG_ESC)
			# Esto pasa cuando apretamos ESC
			#echo "ESC pressed."
			returncode=250
			break
			;;

		esac
	done
done
