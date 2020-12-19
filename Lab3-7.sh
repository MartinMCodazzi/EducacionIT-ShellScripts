#! /bin/bash

RESULTADO=1

if [[ $1>=2 ]] && [[ $1 <=10 ]] ; then

  for((i=$1;1>1;i--)); do

    RESULTADO= $($Resultado*$i)

  done

fi
echo $RESULTADO
