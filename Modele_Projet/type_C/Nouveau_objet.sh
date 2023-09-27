#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 1.0
	* DATE : Ven. 22 Sept. 2023 15:41:58
	* Script qui sert à creer les fichier qui déclarent, définissent et testent un objet.
	*
	* Pour l objet A, ce script générera les fichiers suivant :
	* - ./include/A.$ext_H
	* - ./src/A.$ext_H  ===> ./objet/A.o (Compiler par le Makefile)
	* - ./test/A.$ext_H ===> ./bin/test_A.out (Compiler par le Makefile)
	*
'


# CRÉATION DES VARIABLES GLOBALES
#	# Gestion du nombre de paramètre
nbParam_min=1
#	# Informations sur l'objet à creer.
nomObjet=""
premierAuteur="$premierAuteur"
lstAuteur=""
defAuteur=0
dateCreation=`date +"%d %b %Y" | sed -e "s/^\(.\)/\U\1/" | sed -e "s/\(^[^ ]* [^ ]*\) \(.\)/\1 \U\2/"`
action=""
#	# Fichier à créer
Src="src"
Inc="include"
Test="test"
Mod=".Modele"
ext_H="h"
ext_C="c"
preTest="test_"


# CONSIGNE D'UTILISATION
Usage="Usage : $0 [-h] <nomObjet> [{ [-a [<auteur>]... a-] | [<action>] }]..."
Detail_nomObjet="\t- <nomObjet> : Le nom du nouvelle objet à créer.\n\t\t+Doit commencer par une majuscule.\n\t\t+Ne doit avoir que des lettre, des nombres, et des underscore('_')."
Detail_auteur="\t- <auteur> : Le nom de l'un des auteur de cette objet.\n\t\t+Le premier nom donnée est le responsable du développement de cette objet.\n\t\t+La liste des auteurs est délimité par les balises '-a' et 'a-'."
Detail_action="\t- <action> : L'objet sert à <action>."
Detail="$Usage\n-h : Affiche cette aide.\n$Detail_nomObjet\n$Detail_auteur\n$Detail_action"
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
	F="$Src/$1.$ext_C"
	if ( test -e $F ) then
		rm -vi $F
	fi
	if ( test -e $F ) then
		return 1
	fi

	F="$Inc/$1.$ext_H"
	if ( test -e $F ) then
		rm -vi $F
	fi
	if ( test -e $F ) then
		return 1
	fi

	F="$Test/$1.$ext_C"
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
	echo "Le fichier '$1' existe déjà, que voulez-vous faire ?"
		echo -e "\t1) L'écraser"
		echo -e "\t2) Changer le nom du fichier pour '$2'"
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
nomObjet="$1"
shift

while ( test $# -ne 0 ) ; do
	case "$1" in
		"-a") #Test des paramètres optionnels informant sur le ou les auteurs du documents. :
			shift
			if ( test $defAuteur -eq 0 ) then
				premierAuteur=""
				defAuteur=1
			fi
			while ( test $# -ne 0 -a "$1" != "a-" ) ; do
				if ( test -z "$premierAuteur" ) then
					premierAuteur="$1"
				else
					if ( test -z "$lstAuteur" ) then
						lstAuteur=" :: $1"
					else
						lstAuteur="$lstAuteur ; $1"
					fi
				fi
				shift
			done
			if ( test $# -eq 0 ) then
				echo "Erreur sur les paramètres optionnels informant sur les auteurs de l'objet. Le dernier paramètre de la liste d'auteur doit-être 'a-' ($1)."
				echo -e "$Usage\n$Detail_auteur"
				exit 2
			fi
			shift
			;;
		*) #Test du paramètre optionnel <action> :
			if ( test -z "$action" ) then
				action="$1"
				shift
			else
				echo "Erreur sur le paramètre optionnel <action> ($1)."
				echo "L'utilité de l'objet à déjà était renseigné."
				echo -e "$Usage\n$Detail_action"
				exit 2
			fi
	esac
done
lstAuteur="$premierAuteur$lstAuteur"
if ( test -z "$action" ) then
	action="faireQuelqueChoseDeSuperUtileMaisJeNeSaisPasEncoreQuoi"
 fi

# SCRIPT
#	# Nommage des fichiers déclarant, définissant et testant un <nomObjet>.
nom="$nomObjet"
nomF="$nom"
i=1
modifie=1
while ( test $modifie -eq 1 ) ; do
	modifie=0
	nomF2="$nom"_"$i"
	for rep in "$Inc" "$Src" "$Test" ; do
		ext="$ext_C"
		if ( test "$rep" == "$Inc" ) then
			ext="$ext_H"
		fi
		F="$rep/$nomF.$ext"
		while ( test $modifie -eq 0 -a -e "$F" ) ; do
			modifie=1
			demandeDoublon $F "$rep/$nomF2.$ext"
			case $? in
				1) supprimer $nomF ;;
				2) nomF="$nomF2" ; i=expr`$i + 1` ;;
				3) # Changer le nom du fichier
					echo -n "Nouveau nom : "
					read nomT
					if ( test $( echo "$nomT" | grep -v "^[[:upper:]]" ) ) then
						echo "Le nom '$nomT' n'est pas valide. Il doit commencer par une lettre majuscule."
					else if ( test $( echo "$1" | grep "[^a-zA-Z0-9_]" ) ) then
						echo "Le nom '$nomT' n'est pas valide. Il ne doit contenir que des lettre, des chiffres et des underscore."
					else
						nom="$nomT"
						nomF="$nom"
						i=1
					fi
					fi
					;;
				4) echo "Abandon de la création du fichier" ; exit 2 ;;
				*) echo "Je ne connais pas cette possibilité"
			esac
			F="$rep/$nomF.$ext"
		done
		if ( test $modifie -ne 0 ) then
			break
		fi
	done
done
F_Src="$Src/$nomF.$ext_C"
F_Inc="$Inc/$nomF.$ext_H"
F_Test="$Test/$preTest$nomF.$ext_C"

#	# Création des fichiers.
cp "$Mod/$Src.$ext_C" $F_Src
cp "$Mod/$Inc.$ext_H" $F_Inc
cp "$Mod/$Test.$ext_C" $F_Test

#	# Préparation des donnée à injecter dans les fichiers créer.
# nomF # ==> ~~FICHIER~~
# nomObjet # ==> ~~OBJET~~
# dateCreation # ==> ~~DATE~~
# action # ==> ~~ACTION~~
# lstAuteur # ==> ~~AUTEURS~~
# premierAuteur # ==> ~~CHEF~~
nomVar=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~VAROBJET~~

nomDef=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/_\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | tr "[a-z]" "[A-Z]"` # ==> ~~NOMDEF~~

#	# Modification des fichiers créer.
for F in "$F_Inc" "$F_Src" "$F_Test" ; do
	sed -i -e "s/~~FICHIER~~/$nomF/g" $F
	sed -i -e "s/~~OBJET~~/$nomObjet/g" $F
	sed -i -e "s/~~AUTEURS~~/$lstAuteur/g" $F
	sed -i -e "s/~~DATE~~/$dateCreation/g" $F
	sed -i -e "s/~~ACTION~~/$action/g" $F
	sed -i -e "s/~~VAROBJET~~/$nomVar/g" $F
done

# FIN
clear
ls *
echo -e "\n\n\t\tLes fichier '$F_Src', '$F_Inc' et '$F_Test' ont était crée.\n\n"
echo -e "\n\tFIN DU SCRIPT '$0'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

