#!/bin/bash

DIALOG=dialog
DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_HELP=2
DIALOG_EXTRA=3
DIALOG_ESC=255

backtitle="Administrador Apache/BIND"
salidamenu=0

while test $salidamenu != 1 && test $salidamenu != 250
do
    exec 3>&1
    MENU=`$DIALOG --title "Menu principal"                \
     --backtitle "$backtitle"                             \
     --cancel-label "Salir"                               \
     --menu "Bienvenido, elija lo que desea hacer" 0 0 0  \
     "AltaWeb" "Dar de alta una página/dominio"           \
     "BajaWeb" "Dar de baja una página/dominio"           \
     "ModWeb"  "Modificar paametros página/dominio"       \
     "AltaDNS" "Da de alta un dominio al DNS"             \
     "BajaDNS" "Da de baja un dominio al DNS"             \
      2>&1 1>&3`
    salidamenu=$? #Esto lo hago porque salir da exitcode 1
    exec 3>&-

    case $MENU in
        AltaWeb)  . ./AltaApache.sh;;
        BajaWeb);;
        ModWeb);;
        AltaDNS);;
        BajaDNS);;

    esac
done
