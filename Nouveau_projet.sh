#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 1.2
	* DATE : Sam. 23 Sept. 2023 16:19:42
	* Script qui créer un nouveau projet et le paramètrer.
'


# CRÉATION DES VARIABLES GLOBALES
#	# Gestion du nombre de paramètre
nbParam_min=1
#	# Informations sur le modele de projet.
modelProjet="$HOME/.config/Modele_Projet"
#	# Informations sur le projet à creer.
nomProjet=""
premierAuteur="Mewen PUREN"
lstAuteur=""
description=""
github=""
defAuteur=0


# CONSIGNE D'UTILISATION
Usage="Usage : $0 <nomProjet> [{ [-a [<auteur>]... a-] | [<description>] | [-g] }]..."
Detail_nomProjet="\t- <nomProjet> : Le nom du projet à paramètrer.\n\t\t+Ne doit avoir que des lettre, des nombres, et des underscore('_')."
Detail_auteur="\t- <auteur> : Le nom de l'un des auteur de cette objet.\n\t\t+Le premier nom donnée est le responsable du développement de cette objet.\n\t\t+La liste des auteurs est délimité par les balises '-a' et 'a-'."
Detail_description="\t- <description> : Le projet sert à <description>."
Detail_git="\t- -g : création d'un dépot github 'https://github.com/<pseudo-git>/<nomProjet>' nécesite l'instalation de gh"
Detail="$Usage\n-h : Affiche cette aide.\n$Detail_nomProjet\n$Detail_auteur\n$Detail_description\n$Detail_git"
if ( test "$1" == "-h" ) then
	echo -e "$Detail"
	exit 1
fi


# CRÉATION(S) DE(S) FONCTION(S)


# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
Error="nombre de paramètres incorrect : "

# Bon nomProjetbre de paramètre ? #
if ( test $# -lt $nbParam_min ) then
	echo "$Error Au moins $nbParam_min attendu ($# param donnés)"
	echo -e "$Detail"
	exit 1
fi

# Bon type de paramètre ? #
##Test du paramètre !!!!! <?????> :
#?????=""
#if ( test $# -ge 1 -a "$1" ***** ) then
#	echo "Erreur sur le paramètre !!!!! <?????> ($1)."
#	echo -e "$Usage\n$Detail_?????"
#	exit 2
#fi
#shift

#Test du paramètre <nomProjet> :
if ( test $( echo "$1" | grep "[^a-zA-Z0-9_\-]" ) ) then
	echo "Erreur sur le paramètre <nomProjet> ($1)."
	echo "Le paramètre <nomProjet> contient des caractère interdit pour un nom de projet."
	echo -e "$Usage\n$Detail_nomObjet"
	exit 2
fi
nomProjet="$1"
shift

#Test du paramètre <nomDossier> :
nom="$nomProjet"
nomD="$nom"
while ( test -e $nomD ) ; do
	nomD2="$nom"_"$i"
	echo "Le dossier $dossier existe déjà, que voulez-vous faire ?"
		echo -e "\t1) L'écraser"
		echo -e "\t2) Changer le nom du dossier pour $nomD2"
		echo -e "\t3) Changer le nom du dossier"
		echo -e "\t4) Abandonner"
	echo -n "Choix : "
	read choix
	case $choix in
		"1") # Supprimer l'ancien dossier
			ls -R $nomD
			echo -n "rmdir : supprimer DÉFINITIVEMENT '$nomD' du type dossier et TOUT son contenu ?(entrer '$nomD' pour supprimer) "
			read choix
			if ( test "$choix" == "$nomD" ) then
				rm -vfr $nomD
			fi
			;;
		"2") nom="$nomD2" ; i=expr`$i + 1` ;;
		"3") # Changer le nom du dossier
			echo -n "Nouveau nom : "
			read nomT
			if ( test $( echo "$nomT" | grep "[^a-zA-Z0-9_\-]" ) ) then
				echo "Le nom '$nomT' n'est pas valide. Il ne doit contenir que des lettre, des chiffres et des underscore."
			else
				nom="$nomT"
				i=1
			fi
			;;
		"4") echo "Abandon de la création du dossier" ; exit 2 ;;
		*) echo "Je ne connais pas cette possibilité"
	esac
	nomD="$nom"
done

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
		"-g") #Test du paramètre optionnel <git> :
			shift
			if ( test -z "$github" ) then
				if ( test $(which gh)) then
					github="-g"
				else
					echo "Erreur sur le paramètre optionnel <git> (-g)."
					echo "il faut avoir \"gh\" d'installer."
					echo "Entrez la commande 'apt-get install gh' en mode super-utilisateur avant de réessayer."
					echo -e "$Usage\n$Detail_git"
					exit 2
				fi
			else
				echo "Erreur sur le paramètre optionnel <git> (-g)."
				echo "Le lien vers le dépot github du projet à déjà était renseigné."
				echo -e "$Usage\n$Detail_git"
				exit 2
			fi
			;;
		*) #Test du paramètre optionnel <description> :
			if ( test -z "$description" ) then
				description="$1"
				shift
			else
				echo "Erreur sur le paramètre optionnel <description> ($1)."
				echo "La description du projet à déjà était renseigné."
				echo -e "$Usage\n$Detail_description"
				exit 2
			fi
	esac
done


# SCRIPT
cp -r "$modelProjet" "./$nomD"
chmod a+x "./$nomD/ParamProject.sh"
./$nomD/ParamProject.sh "$nomProjet" -a "$premierAuteur" "$premierAuteur$lstAuteur" $github "$description"
sortie=$?
if ( test "$sortie" != "0" ) then
	echo "Une erreur c'est produite durant le paramètrage du projet. Veuillez finir le paramètrage par vous même."
	echo "Le script pour paramètrer le projet est : './$nomD/ParamProject.sh -h'"
	exit $sortie
fi
rm -vf "./$nomD/ParamProject.sh"
echo -e "\n\tFIN DU SRIPT '$0'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

