#!/bin/bash


# Lo que hace: Un script que crea los archivos de configuracion necesarios
# en un servidor Apache, y las entradas pertinentes en un servidor BIND

TMPFILE=/tmp/tmpfile.$$

# set -x
function get_os {
  #Me interesa saber qué os está corriendo, para saber como llamar al servicio
if [ $(cat /etc/os-release | grep ^ID=) == ID=debian ] ; then
      OSACTUAL="Debian"
      SERVICIO_WEB="apache2"

      elif [ $(cat /etc/os-release | grep ^ID=) == ID=\"centos\" ]; then
        OSACTUAL="Centos"
        SERVICIO_WEB=httpd

      else OSACTUAL="Other"
fi
}

function apache_status {
  # Acá, consulto el stado del servicio de apache, segun el OS,
  # quizás implemente algo en el dialog con esto
    if ! pgrep -x $SERVICIO_WEB > /dev/null ; then
      echo "Apache status: OFF"
    fi
}

function menu {
    dialog --title "Script Apache Y BIND por Martin Muñoz Codazzi"             \
    --backtitle "Menú Principal" --menu "Mover con las Teclas" 0 0 0           \
    Apache "Solo dar de alta la página en el servidor web"                     \
    BIND "Agrega entrada en BIND" Ambos "Agrega página web y entrada DNS"      \
    2> /tmp/item.$$

    item=`cat /tmp/item.$$`
    rm -f /tmp/item.$$

    case $item in
       Apache) ;;
       BIND) ;;
       Ambos) ;;
       *) break ;;
    esac
}

function crea_apache {
      # quizás llame al archivo AltaApache

}
