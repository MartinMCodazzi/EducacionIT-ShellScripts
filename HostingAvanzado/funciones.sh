#!/bin/bash

DIALOG=dialog
DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_HELP=2
DIALOG_EXTRA=3
DIALOG_ESC=255

USUARIO=httpd
GRUPO=httpd
DOCROOT=
PUERTO=
# case $? in
#     $DIALOG_OK);;
#     $DIALOG_CANCEL);;
# esac

# $DIALOG --backtitle ""   \
#     --clear              \
#     --msgbox "" 0 0
function msg_exito {
    $DIALOG                                            \
        --clear                                        \
        --msgbox "Tarea completada con éxito." 0 0
}

function msg_sincambios {
    $DIALOG --backtitle $1                    \
        --clear                               \
        --msgbox "No se ha modificado nada" 0 0
}

function valid_ip {
    ## Esto no es mío, pero está muy bueno ##
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# function validar_ip {
#
#
# }

function puerto {
    exec 3>&1
    PUERTO=`$DIALOG --backtitle "Opciones Avanzadas - Puerto"   \
        --clear                                                 \
        --inputbox "Ingrese el nuevo puerto" 0 0 \
        2>&1 1>&3`
        local localvar=$?
        exec 3>&-
}

function nodis {
    $DIALOG --backtitle "Menu Principal "   \
        --clear                             \
        --msgbox "Módulo en construcción" 0 0
}

function recargar_apache {
    apache_configtest
    $DIALOG --backtitle "Recarga servicio apache"               \
        --clear                                                 \
        --cancel-label "Más tarde"                              \
        --yesno "Desea recargar el servicio de apache ahora?" 0 0

    case $? in
        $DIALOG_OK)
            systemctl reload apache2.service
                case $? in
                    $DIALOG_OK)
                        $DIALOG --backtitle "Recarga servicio apache"        \
                            --clear                                          \
                            --msgbox "Servidor APACHE recargado con éxito" 0 0
                    ;;
                    *)
                    $DIALOG --backtitle "Recarga servicio apache"              \
                        --clear                                                \
                        --title "##### CUIDADO #####"                          \
                        --msgbox "No se recargó correctamente, tiene permisos? \
                        ejecute un configtest desde el menú principal" 0 0
                    ;;
                esac
        ;;
        $DIALOG_CANCEL)
            $DIALOG --backtitle "Recarga servicio apache"                      \
                --clear                                                        \
                --title "No se recargó el servicio"                            \
                --msgbox "Debe recargar el servicio de Apache para que los cambios surtan efecto" 0 0
        ;;
    esac

}

function baja_web {
    rm -f "/etc/apache2/sites-enabled/${1}.conf"
    case $? in
        $DIALOG_OK)
                msg_exito
                recargar_apache #Esta funcion está definida en el menu
        ;;
        *)"$DIALOG" --backtitle $2                             \
            --clear                                            \
            --msgbox "###ERROR ELIMINANDO EL ARCHIVO###        \
            Tiene permisos?" 0 0
        ;;
    esac

}
