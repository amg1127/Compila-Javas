#!/bin/bash

maisvelho () {
    if [ -e "$1" ]; then
        if [ -e "$2" ]; then
            modtime1="`stat -c %Y \"$1\"`"
            modtime2="`stat -c %Y \"$2\"`"
            test $modtime1 -lt $modtime2
            return $?
        else
	    return 1
	fi
    else
        return 0
    fi
}

if false; then
    # Uma forma eh rodar e imediatamente executar
    for fonte in *.java; do
        if [ -e "$fonte" ]; then
	    binario="`basename \"$fonte\" '.java'`"
	    classe="${binario}.class"
	    if ! maisvelho "$fonte" "$classe"; then
                echo "Compilando '$fonte'..."
                if ! javac "$fonte"; then
                    echo "Compilacao de '$fonte' falhou!"
                fi
            fi
	    if maisvelho "$fonte" "$classe"; then
	        echo "Executando '$classe'..."
		java "$binario"
	    fi
        fi
    done
else
    # Uma outra forma eh compilar tudo de uma vez so e depois rodar
    for fonte in *.java; do
        if [ -e "$fonte" ]; then
            binario="`basename \"$fonte\" '.java'`"
            classe="${binario}.class"
	    if ! maisvelho "$fonte" "$classe"; then
                echo "Compilando '$fonte'..."
                if ! javac "$fonte"; then
                    echo "Compilacao de '$fonte' falhou!"
                fi
            fi
	fi
    done
    for fonte in *.java; do
        if [ -e "$fonte" ]; then
            binario="`basename \"$fonte\" '.java'`"
	    classe="${binario}.class"
            if [ -e "${binario}.class" ]; then
                if maisvelho "$fonte" "$classe"; then
	            echo "Executando '$classe'..."
	            java "$binario"
	        fi
            fi
        fi
    done
fi
