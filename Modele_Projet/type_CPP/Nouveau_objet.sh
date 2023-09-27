#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 1.0
	* DATE : Ven. 22 Sept. 2023 15:41:58
	* Script qui sert à creer les fichier qui déclarent, définissent et testent un objet.
	*
	* Pour l objet A, ce script générera les fichiers suivant :
	* - ./include/A.c
	* - ./src/A.c  ===> ./objet/A.o (Compiler par le Makefile)
	* - ./test/A.c ===> ./bin/test_A.exe (Compiler par le Makefile)
	*
'


# CRÉATION DES VARIABLES GLOBALES
#	# Gestion du nombre de paramètre
nbParam_min=1
#	# Informations sur l'objet à creer.
nomObjet=""
premierAuteur="Jean Eude"
lstAuteur=""
dateCreation=`date +"%d %b %Y" | sed -e "s/^\(.\)/\U\1/" | sed -e "s/\(^[^ ]* [^ ]*\) \(.\)/\1 \U\2/"`
action="faireQuelqueChoseDeSuperUtileMaisJeNeSaisPasEncoreQuoi"
#	# Fichier à créer
Src="src"
Inc="include"
Test="test"
Mod=".Modele"


# CONSIGNE D'UTILISATION
Usage="Usage : $0 [-h] [ -a [<auteur>]... a- ] <nomObjet> [<action>]"
Detail_auteur="\t- <auteur> : Le nom de l'un des auteur de cette objet.\n\t\t+Le premier nom donnée est le responsable du développement de cette objet.\n\t\t+La liste des auteurs est délimité par les balises '-a' et 'a-'."
Detail_nomObjet="\t- <nomObjet> : Le nom du nouvelle objet à créer.\n\t\t+Doit commencer par une majuscule.\n\t\t+Ne doit avoir que des lettre, des nombres, et des underscore('_')."
Detail_action="\t- <action> : L'objet sert à <action>."
Detail="$Usage\n-h : Affiche cette aide.\n$Detail_auteur\n$Detail_nomObjet\n$Detail_action"
if ( test "$1" == "-h" ) then
	echo -e "$Detail"
	exit 1
fi


# CRÉATION(S) DE(S) FONCTION(S)
: ' Fonction qui écrase les ancien fichier si nécéssaire.
	* paramètre $1 : le nom de l objet
	* return : 0=supprimer ; 1=annuler ; *=erreur
	'
supprimer(){
	if ( test $# -ne 1 ) then
		echo "fonction supprimer() : $# paramètre reçu au lieu de 2."
		return 128
	fi
	F="$Src/$1.cpp"
	if ( test -e $F ) then
		rm -vi $F
	fi
	if ( test -e $F ) then
		return 1
	fi

	F="$Inc/$1.hpp"
	if ( test -e $F ) then
		rm -vi $F
	fi
	if ( test -e $F ) then
		return 1
	fi

	F="$Test/$1.cpp"
	if ( test -e $F ) then
		rm -vi $F
	fi
	if ( test -e $F ) then
		return 1
	fi

	return 0
}

: ' Fonction qui demande à l utilisateur que faire si un fichier existe déjà.
	* paramètre $1 : le nom du fichier
	* paramètre $2 : une proposition d un nouveau nom de fichier
	* return : 0=supprimer ; 1=annuler ; *=erreur
	'
demandeDoublon(){
	echo "Le fichier $1 existe déjà, que voulez-vous faire ?"
		echo -e "\t1) L'écraser"
		echo -e "\t2) Changer le nom du fichier pour $2"
		echo -e "\t3) Changer le nom du fichier"
		echo -e "\t4) Abandonner"
	echo -n "Choix : "
	read choix
	for i in `seq 1 4` ; do
		if ( test $1 = "$i" ) then
			return $i
		fi
	done
	return 0
	
}

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
Error="Nombre de paramètres incorrect : "

# Bon nombre de paramètre ? #
if ( test $# -lt $nbParam_min ) then
	echo "$Error Au moins $nbParam_min attendu ($# param donnés)"
	echo -e "$Detail"
	exit 1
fi

# Bon type de paramètre ? #
##Test du paramètre !!!!! <?????> :
#?????=""
#if ( test $# -ge 1 -a $1 ***** ) then
#	echo "Erreur sur le paramètre !!!!! <?????> ($1)."
#	echo -e "$Usage\n$Detail_?????"
#	exit 2
#fi
#shift

#Test des paramètres optionnels informant sur le ou les auteurs du documents. :
if ( test $# -ge 1 -a $1 == "-a" ) then
	shift
	premierAuteur=""
	while ( test $# -ge 1 -a "$1" != "a-" ) ; do
		if ( test -z "$premierAuteur" ) then
			premierAuteur="$1"
		else
			if ( test -z "$lstAuteur" ) then
				lstAuteur="$1"
			else
				lstAuteur="$lstAuteur ; $1"
			fi
		fi
		shift
	done
	if ( test $# -ge 1 -a $1 != "a-" ) then
		echo "Erreur sur les paramètres optionnels informant sur les auteurs de l'objet. Le dernier paramètre de la liste d'auteur doit-être '-a' ($1)."
		echo -e "$Usage\n$Detail_auteur"
		exit 2
	fi
	shift
fi
# ATTENTION : taille de ce paramètre inconnue

# Fin des paramètres optionnels
if ( test $# -lt 1 ) then
	echo "$Error il faut encore au moins 1 paramètre ($# paramètres restant)"
	echo "Impossible d'obtenir le nom de l'objet."
	echo -e "$Detail"
	exit 1
fi

#Test du paramètre <nomObjet> :
if ( test $( echo "$1" | grep -v "^[[:upper:]]" ) ) then
	echo "Erreur sur le paramètre <nomObjet> ($1)."
	echo "Le paramètre <nomObjet> devrait commencé par une lettre majuscule."
	echo -e "$Usage\n$Detail_nomObjet"
	exit 2
fi
if ( test $( echo "$1" | grep "[^a-zA-Z0-9_]" ) ) then
	echo "Erreur sur le paramètre <nomObjet> ($1)."
	echo "Le paramètre <nomObjet> contient des caractère interdit pour un nom de classe."
	echo -e "$Usage\n$Detail_nomObjet"
	exit 2
fi
nomObjet=$1
shift

#Test du paramètre <action> :
if ( test $# -ne 0 ) then
	action="$1"
	shift
fi

if ( test $# -ne 0 ) then
	echo "$Error trop de paramètre ($# paramètres restant)"
	echo "Tout les paramètres aurait déjà dût servir."
	echo -e "$Detail"
	exit 1
fi


# SCRIPT
#	# Nommage des fichiers déclarant, définissant et testant un <nomObjet>.
nomF="$nomObjet"
nomF2=""
FExisteQuestion=""
FExiste=0
suppr=0
i=1

continu=1
while ( test $continu -eq 1 ) ; do
	continu=0
	fichier="$Inc/$nomF.hpp"
	while ( test -e $fichier ) ; do
		nomF2="$nomF"_"$i"
		demandeDoublon $fichier "$Inc/$nomF2.hpp"
		case $? in
			1) supprimer $nom ;;
			2) nom=$nom2 ; i=expr`$i + 1` ;;
			3) echo -n "Nouveau nom : " ; read nom ; i=1 ;;
			4) echo "Abandon de la création du fichier" ; exit 2 ;;
			*) echo "Je ne connais pas cette possibilité"
		esac
		fichier="$Inc/$nomF.hpp"
	done
	
	fichier="$src/$nomF.cpp"
	while ( test -e $fichier ) ; do
		continu=1
		nomF2="$nomF"_"$i"
		demandeDoublon $fichier "$src/$nomF2.cpp"
		case $? in
			1) supprimer $nom ;;
			2) nom=$nom2 ; i=expr`$i + 1` ;;
			3) echo -n "Nouveau nom : " ; read nom ; i=1 ;;
			4) echo "Abandon de la création du fichier" ; exit 2 ;;
			*) echo "Je ne connais pas cette possibilité"
		esac
		fichier="$src/$nomF.cpp"
	done
	
	fichier="$test/$nomF.cpp"
	while ( test -e $fichier ) ; do
		continu=1
		nomF2="$nomF"_"$i"
		demandeDoublon $fichier "$test/$nomF2.cpp"
		case $? in
			1) supprimer $nom ;;
			2) nom=$nom2 ; i=expr`$i + 1` ;;
			3) echo -n "Nouveau nom : " ; read nom ; i=1 ;;
			4) echo "Abandon de la création du fichier" ; exit 2 ;;
			*) echo "Je ne connais pas cette possibilité"
		esac
		fichier="$test/$nomF.cpp"
	done
done
Src="$Src/$nomF.cpp"
Inc="$Inc/$nomF.hpp"
Test="$Test/test_$nomF.cpp"

#	# Création des fichiers.
cp "$Mod/src.c" $Src
cp "$Mod/include.h" $Inc
cp "$Mod/test.c" $Test

#	# Préparation des donnée à injecter dans les fichiers créer.
# nomF # ==> ~~FICHIER~~
# nomObjet # ==> ~~OBJET~~
# dateCreation # ==> ~~DATE~~
# action # ==> ~~ACTION~~
# lstAuteur # ==> ~~AUTEURS~~
nomVar=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~VAROBJET~~
nomDef=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/_\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | tr "[a-z]" "[A-Z]"` # ==> ~~NOMDEF~~

#	# Modification des fichiers créer.
#	#	# Le fichier source
sed -i -e "s/~~FICHIER~~/$nomF/g" $Src
sed -i -e "s/~~OBJET~~/$nomObjet/g" $Src
sed -i -e "s/~~AUTEURS~~/$premierAuteur :: $lstAuteur/g" $Src
sed -i -e "s/~~DATE~~/$dateCreation/g" $Src
sed -i -e "s/~~ACTION~~/$action/g" $Src
sed -i -e "s/~~VAROBJET~~/$nomVar/g" $Src

#	#	# Le fichier d'en-tête
sed -i -e "s/~~NOMDEF~~/$nomDef/g" $Inc
sed -i -e "s/~~FICHIER~~/$nomF/g" $Inc
sed -i -e "s/~~OBJET~~/$nomObjet/g" $Inc
sed -i -e "s/~~AUTEURS~~/$premierAuteur :: $lstAuteur/g" $Inc
sed -i -e "s/~~DATE~~/$dateCreation/g" $Inc
sed -i -e "s/~~ACTION~~/$action/g" $Inc
sed -i -e "s/~~VAROBJET~~/$nomVar/g" $Inc

#	#	# Le fichier de test
sed -i -e "s/~~FICHIER~~/$nomF/g" $Test
sed -i -e "s/~~OBJET~~/$nomObjet/g" $Test
sed -i -e "s/~~AUTEURS~~/$premierAuteur :: $lstAuteur/g" $Test
sed -i -e "s/~~DATE~~/$dateCreation/g" $Test
sed -i -e "s/~~ACTION~~/$action/g" $Test
sed -i -e "s/~~VAROBJET~~/$nomVar/g" $Test

# FIN
clear
ls *
echo -e "\n\n\t\tLes fichier $Src, $Inc et $Test ont était crée.\n\n"
echo -e "\n\tFIN DU SCRIPT '$0'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

