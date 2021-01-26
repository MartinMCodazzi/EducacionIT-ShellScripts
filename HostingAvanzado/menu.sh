#/bin/bash

. ./funciones.sh
. ./variables.sh

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
     "TestApache" "Testeo de archivos de configuracion"   \
     "RecargaApache" "Recarga la configuración del apache"\
     "ModWeb"  "Modificar paametros página/dominio"       \
     "AltaDNS" "Da de alta un dominio al DNS"             \
     "BajaDNS" "Da de baja un dominio al DNS"             \
      2>&1 1>&3`
    salidamenu=$? #Esto lo hago porque salir da exitcode 1
    exec 3>&-

    case $MENU in
        AltaWeb) . ./AltaApache.sh;;
        BajaWeb) . ./BajaApache.sh;;
        TestApache) Test_apache;;
        RecargaApache)recargar_apache;;
        ModWeb)nodis;;
        AltaDNS);;
        BajaDNS);;

    esac
done
clear
echo "CHAU"
