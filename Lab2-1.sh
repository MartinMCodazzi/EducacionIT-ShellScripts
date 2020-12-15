#!/bin/bash

if [[ $1 -gt $2 ]] && [[ $1 -gt $3 ]] ; then
        MAYOR= $1
    elif [ $2 -gt $3 ]; then
        MAYOR=$2
    else
        MAYOR=$3
fi

echo "El Mayor número ingresado es $MAYOR"
