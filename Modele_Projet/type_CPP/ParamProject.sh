#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 1.0
	* DATE : Ven. 22 Sept. 2023 19:34:41
	* Script qui Paramètre le projet à sa copie puis s auto-supprime.
'


# CRÉATION DES VARIABLES GLOBALES
#	# Gestion du nombre de paramètre
nbParam_min=1
#	# Informations sur le projet à paramètrer.
nomProjet=""
lstAuteur=""
premierAuteur=""
description=""
github=""
github_existe=0
dateCreation=`date +"%d %b %Y" | sed -e "s/^\(.\)/\U\1/" | sed -e "s/\(^[^ ]* [^ ]*\) \(.\)/\1 \U\2/"`
dossierActu=`pwd`
fichierParam=`basename "$0"`
dossierProjet=`realpath "$0"`
dossierProjet=`dirname "$dossierProjet"`


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

defAuteur=0
while ( test $# -ne 0 ) ; do
	case "$1" in
		"-a") #Test des paramètres optionnels informant sur le ou les auteurs du documents. :
			shift
			if ( test $# -lt 2 ) then
				echo "$Error Au moins 2 paramétre attendu après un '-a' ($# param restant)"
				echo -e "$Detail"
				exit 1
			fi
			premierAuteur="$1"
			shift
			lstAuteur="$1"
			shift
			;;
		"-g") #Test du paramètre optionnel <git> :
			shift
			if (test "$github_existe" == "1") then
				echo "Erreur sur le paramètre optionnel <git> (-g)."
				echo "Le lien vers le dépot github du projet à déjà était renseigné."
				echo -e "$Usage\n$Detail_git"
				exit 2
			else
				github_existe=1
			fi
			;;
		*) #Test du paramètre optionnel <description> :
			if ( test -z "$description" ) then
				description="$1"
				shift
			else
				echo "Erreur sur le paramètre optionnel <description> ($1)."
				echo "La description du projet à déjà était renseigné. ($description)"
				echo -e "$Usage\n$Detail_description"
				exit 2
			fi
	esac
done
if ( test -z "$description" ) then
	description="faireQuelqueChoseDeSuperUtileMaisJeNeSaisPasEncoreQuoi"
fi


# SCRIPT
#	# Préparation des donnée à injecter dans les fichiers du projet à paramètrer.
# nomProjet # ==> ~~PROJET~~
# dateCreation # ==> ~~DATE~~
# description # ==> ~~description~~
# premierAuteur # ==> ~~CHEF~~
# github # ==> ~~ADRESSE_GIT~~
# lstAuteur # ==> ~~AUTEURS~~
cd $dossierProjet

#	# Modification des fichiers du projet à paramètrer.
#	#	# Le fichier main.c
fichier="./main.c"
sed -i -e "s/~~AUTEURS~~/$lstAuteur/g" $fichier
sed -i -e "s/~~DATE~~/$dateCreation/g" $fichier
sed -i -e "s/~~PROJET~~/$nomProjet/g" $fichier

#	#	# Les autres fichiers de développement
lstFichierDev=( "./include/commun.h" "./include/attributs_objet.h" "./test/commun.c" "./src/commun.c" )
for fichier in ${lstFichierDev[*]} ; do
	sed -i -e "s/~~DATE~~/$dateCreation/g" $fichier
done

#	#	# Le fichier Doxyfile
fichier="./docs/Doxygen/Doxyfile"
sed -i -e "s/~~PROJET~~/$nomProjet/g" $fichier
sed -i -e "s/~~ACTION~~/$description/g" $fichier

#	#	# La page principale de la doc générer par Doxygen
fichier="./docs/Doxygen/main_page.md"
sed -i -e "s/~~PROJET~~/$nomProjet/g" $fichier
sed -i -e "s/~~ACTION~~/$description/g" $fichier

#	#	# Le README
fichier="./docs/README.md"
sed -i -e "s/~~PROJET~~/$nomProjet/g" $fichier
sed -i -e "s/~~DATE~~/$dateCreation/g" $fichier
sed -i -e "s/~~ACTION~~/$description/g" $fichier
sed -i -e "s/~~CHEF~~/$premierAuteur/g" $fichier
sed -i -e "s/~~AUTEURS~~/$lstAuteur/g" $fichier
if (test "$github_existe" == "1") then
	gh auth login
	git init
	gh repo create $nomProjet --private --source=. --remote=upstream
	github=`grep "url =" ./.git/config | cut -d= -f2`
	sed -i -e "s/~~ADRESSE_GIT~~/$( echo "$github" | sed "s/\//\\\\\//g" )/g" $fichier
else
	sed -i -e "$( grep -n "~~ADRESSE_GIT~~" $fichier | cut -d: -f1 )d" $fichier
fi

#	#	# Le Makefile
fichier="./Makefile"
sed -i -e "s/~~PROJET~~/$nomProjet/g" $fichier


# FIN
if (test "$github_existe" == "1") then
	git add *
	git add .gitignore
	git commit -m "création assister"
	git branch -M master
	git remote add origin $github
	git push -u origin master
fi
clear
ls -R
echo -e "\n\tFIN DU PARAMETRAGE DU DOSSIER '$(basename "$dossierProjet")'."
cd $dossierActu
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

