#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 0.1
	* DATE : Ven. 22 Sept. 2023 15:13:54
	* Script qui sert à lancer les différent programmes de tests du projet.
'


# CRÉATION DES VARIABLES GLOBALES
nbParam_min=1
val=1
com=-1


# CONSIGNE D'UTILISATION
Usage="Usage : $0 [-nc] [--no_valgrind] [--compile] <classe>..."
Detail_noValgrind="\t- -n ou --no_valgrind : Si présent désactive valgrind."
Detail_compile="\t- -c ou --compile : Si présent, lance un 'make all' avant de tester les programmes."
Detail_classe="\t- <classe> : Lance le programme test_<classe>, si il existe."
Detail="$Usage\n-h : Affiche cette aide.\n$Detail_noValgrind\n$Detail_compile\n$Detail_classe"
if ( test $1 == -h ) then
	echo -e "$Detail"
	exit 1
fi


# CRÉATION(S) DE(S) FONCTION(S)


# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
Error="Nombre de paramètres incorrect : "

# Bon nombre de paramètre ? #
if ( test $# -lt $nbParam_min ) then
	echo "$Error Au moins $nbParam_min attendu ($# param donnés)"
	echo -e "$Detail"
	exit 1
fi

# Bon type de paramètre ? #
#Test des paramètres optionnels no_valgrind et compile :
stop = 0
while ( test $stop -eq 0 -a $# -lt $nbParam_min ) ; do
	case $1 in
		# Si grand paramètre :
		"--no_valgrind") val=`expr $val * -1`; shift ;;
		"--compile") com=`expr $com * -1`; shift ;;
		# Si deux des paramètres réduit :
		"-nc")
			val=`expr $val * -1`;
			com=`expr $com * -1`;
			shift ;;
		"-cn")
			com=`expr $com * -1`;
			val=`expr $val * -1`;
			shift ;;
		# Si un seul des paramètres réduit :
		"-n") val=`expr $val * -1`; shift ;;
		"-c") com=`expr $com * -1`; shift ;;
		# Sinon
		*) stop = 1
	esac
done

#Test des paramètres optionnels no_valgrind :
if ( test $val -eq -1 ) then
	val=0
fi

#Test des paramètres optionnels compile :
if ( test $com -eq -1 ) then
	com=0
fi

#Lecture des paramètres classe :
lstExec=()
while ( test $# -ne 0 ) ; do
	lstExec=( ${lstExec[*]} ./bin/test_$1 )
	shift
done
# ATTENTION : nombre de repetition de ce paramètre inconnue

##Test du paramètre !!!!! <?????> :
#?????=""
#if ( test $# -ge 1 -a $1 ***** ) then
#	echo "Erreur sur le paramètre !!!!! <?????> ($1)."
#	echo -e "$Usage\n$Detail_?????"
#	exit 2
#fi
#shift


# SCRIPT
clear
#Rafraichir les éxecutable à tester
rm -vf ${lstExecutable[*]}
#Compiler
if ( test $com -eq 1 ) then
	make clean all
else
	make ${lstExecutable[*]}
fi
#Executer les programmes demandé.
Fval="valgrind.log"
Fval2="valgrind-2.log"
if (test $val -eq 1 ) then
	rm -f $Fval $Fval2
	touch $Fval
fi
for File in ${lstExec[*]} ; do
	echo -e "\n\nAppuyer sur ENTRÉE pour lancer le test sur '$File' :"
	read V
	if (test $val -eq 1 ) then
		touch $Fval2
		valgrind --leak-check=full --show-reachable=yes -s --track-origins=yes --log-file="$Fval2" $File
		echo "#########################################" >> $Fval
		echo "#####     $File     #####" >> $Fval
		echo "#########################################" >> $Fval
		cat $Fval2 >> $Fval
		echo "#########################################" >> $Fval
		echo "#####   FIN $File   #####" >> $Fval
		echo "#########################################" >> $Fval
		rm -f $Fval2
	else
		$File
	fi
done

echo -e "\n\n\t\tFIN DES TESTS\n\n"
ls ./bin/test_*[^.]? | cut -c12-
echo -e "\n\n"
ls

# FIN
echo -e "\n\tFIN DU SCRIPT '$0'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

