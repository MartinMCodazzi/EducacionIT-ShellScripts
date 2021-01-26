#!/usr/bin/env bash


backtitle="Baja_de_WEBS"
salidabaja=0

NUMERO_WEBS_ACTIVAS=`ls /etc/apache2/sites-enabled | wc -l`
WEBS_ACTIVAS=`ls /etc/apache2/sites-enabled`


while [[ $NUMERO_WEBS_ACTIVAS -gt 0 ]] && [[ $salidabaja != 1 ]] ; do


    WEBS=`for i in ${WEBS_ACTIVAS[@]}; do
        echo $i | sed 's/.conf//g'
        echo '-'
    done`

    exec 3>&1
    BAJAWEB=`$DIALOG --backtitle $backtitle                    \
        --title "Webs Activas, seleccione la web a desactivar" \
        --column-separator '-'                                 \
        --cancel-label "Atras"                                 \
        --menu "Webs activas en Apache" 0 0 0                  \
        $(echo $WEBS)                                          \
        2>&1 1>&3`
    salidabaja=$?
    #esto se pone porque el boton atras, sale con exitcode 1
    exec 3>&-

    case $salidabaja in
        $DIALOG_OK)
            "$DIALOG" --backtitle $backtitle                             \
                --title "Seguro?"                                        \
                --defaultno                                              \
                --yesno "Seguro desea dar de baja la web ${BAJAWEB} ?" 0 0

            case $? in
                $DIALOG_OK)
                    baja_web $BAJAWEB
                ;;

                $DIALOG_CANCEL)
                    msg_sincambios $backtitle
                ;;
            esac
        ;;

        $DIALOG_CANCEL);;
    esac

    WEBS_ACTIVAS=`ls /etc/apache2/sites-enabled`
    NUMERO_WEBS_ACTIVAS=`$WEBS_ACTIVAS | wc -l`

done

if [[ $NUMERO_WEBS_ACTIVAS -eq 0 ]] ; then
    $DIALOG --backtitle $backtitle                          \
    --pause 'No hay webs para dar de baja. Volviendo al menú principal' 12 35 5

fi
