#! /bin/bash

STR1=$1
STR2=$2




if [[ -z $STR1 ]] || [[ -z $STR2 ]]; then
        echo "Alguna de las cadenas están vacías"
        
  elif [ $STR1 == $STR2 ]; then
        echo "Las cadenas son iguales"

  else echo "Las cadenas son distintas"

fi
