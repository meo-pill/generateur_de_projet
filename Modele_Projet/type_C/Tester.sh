#!/bin/bash
: '
* AUTEUR : Erwan PECHON
* VERSION : 0.1
* DATE : Ven. 22 Sept. 2023 15:13:54
* Script qui sert à lancer les différent programmes de tests du projet.
'


# CRÉATION DES VARIABLES GLOBALES
dossierActu=`pwd`
dossierProjet=`realpath "$0"`
dossierProjet=`dirname "$dossierProjet"`

nbParam_min=1

val=1
gdb=-1
com=-1

lstTest="for F in \$(ls $dossierProjet/bin/test_*[^.]\.out | tr \"\\\n\" \"\\\t\") ; do basename \"\$F\" ; done"

# CONSIGNE D'UTILISATION
Usage="Usage : $0 [-nc|-gc] [--no_valgrind|--debug] [--compile] <classe>..."
Detail_noValgrind="\t- -n ou --no_valgrind : Si présent désactive valgrind."
Detail_gdb="\t- -g ou --debug : Si présent désactive valgrind, et active gdb."
Detail_compile="\t- -c ou --compile : Si présent, lance un 'make all' avant de tester les programmes."
Detail_classe="\t- <classe> : Lance le programme test_<classe>, si il existe."
Detail="$Usage\n-h : Affiche cette aide.\n$Detail_noValgrind\n$Detail_compile\n$Detail_classe"
if ( test "$1" == "-h" ) then
	echo ""
	echo "Affichage de l'aide :"
	echo -e "$Detail"
	echo ""
	echo -ne "Liste des classes actuellement disponible. (faite make all pour mettre à jour.) : \n\t>"
	echo "$(eval "$lstTest")" | tr "\n" "\t"
	echo ""
	exit 0
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
		"--debug") gdb=`expr $gdb * -1`; shift ;;
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
	"-gc")
		gdb=`expr $gdb * -1`;
		com=`expr $com * -1`;
		shift ;;
	"-cg")
		gdb=`expr $gdb * -1`;
		com=`expr $com * -1`;
		shift ;;
		# Si un seul des paramètres réduit :
		"-n") val=`expr $val * -1`; shift ;;
		"-n") gdb=`expr $gdb * -1`; shift ;;
		"-c") com=`expr $com * -1`; shift ;;
		# Sinon
		*) stop = 1
esac
done

#Test des paramètres optionnels debug :
if ( test "$gdb" -ne -1 ) then
	val=0
	gdb=1
else #Test des paramètres optionnels no_valgrind :
	if ( test "$val" -ne -1 ) then
		val=1
		gdb=0
	else
		val=0
		gdb=0
	fi
fi

#Test des paramètres optionnels compile :
if ( test "$com" -ne -1 ) then
	com=1
else
	com=0
fi

#Lecture des paramètres classe :
lstExec=()
execAll=-1
if ( test $# -eq 1 -a "$1" == "*" ) then
	execAll=1
	shift
else
	while ( test $# -ne 0 ) ; do
		lstExec=( ${lstExec[*]} ./bin/test_$1 )
		shift
	done
fi
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
#Compiler
if ( test $com -eq 1 ) then
	make clean all
else
	if ( test $execAll -eq -1 ) then
		rm -vf ${lstExecutable[*]}
		make ${lstExecutable[*]}
	fi
fi
if ( test $execAll -ne -1 ) then
	lstExec=()
	for F in `echo "$(eval "$lstTest")" | tr "\n" "\t"` ; do
		lstExec=( ${lstExec[*]} ./bin/test_$F )
	done
fi
#Executer les programmes demandé.
Fval="$dossierProjet/valgrind.log"
Fval2="$dossierProjet/valgrind-2.log"
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
		if ( test $gdb -eq 1 ) then
			gdb $File
		else
			$File
		fi
	fi
done

echo -e "\n\n\t\tFIN DES TESTS\n\n"
echo -ne "Liste des classes actuellement disponible. (faite make all pour mettre à jour.) : \n\t>"
echo "$(eval "$lstTest")" | tr "\n" "\t"
echo -e "\n\n"
ls

# FIN
echo -e "\n\tFIN DU SCRIPT '$0'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

