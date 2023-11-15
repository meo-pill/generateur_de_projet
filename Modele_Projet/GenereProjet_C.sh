#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 1.0
	* DATE : lun. 30 oct.(10) 2023 18:22:46 ECT
	* Script qui Paramètre le projet à sa création.
'

if test "$dossierModele" = ""; then # Définit si générateur paramètrer.
	echo "> La variable \$dossierModele n'est pas définit. Veuillez appeler le script $0 depuis le script Nouveau_projet.sh, afin de bien définir toutes les variables qui en dépendent."
	exit 12
fi

# CRÉATION DES VARIABLES GLOBALES
# shellcheck source=/dev/null
source "$F_tab"
#	# Autres
extension=""
modele="architecture"
#	# Gestion des paramètres
nbParam_min=0
nbParam_max=1
strParam="[-g]"
declare -A detail
detail["%-g"]="L'option '-g' appel le programme 'gh' afin de créer un nouveau projet github et de le lier à ce projet."

# CRÉATION(S) DE(S) FONCTION(S)
# shellcheck source=/dev/null
source "$dossierModele/fonction_creation_projet.sh"

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: " Test de la variable languageOpt : "
if test "$languageOpt" != ""; then
	if test "$(echo "$languageOpt" | tr "[:lower:]" "[:upper:]")" = "CPP"; then
		archiveModele="$dossierModele/type_CPP.tar.gz"
	elif test "$(echo "$languageOpt" | tr "[:lower:]" "[:upper:]")" != "C"; then
		aide "${codeErr["param"]}" $LINENO "<language>" "$languageOpt" "Le language de programmation C n'à pas de spécialisation $languageOpt." -h "language"
	fi
fi

: ' Tests sur les paramètres : '
github_existe=0
github=""
if test "$1" = "-g"; then
	testGit
	github_existe=1
	shift
fi
if test $# -ne 0; then
	aide "${codeErr["nbParam"]}" $LINENO "de $nbParam_min à $nbParam_max Paramètre attendu" $#
fi

# SCRIPT
echo -en "\t> Github  .  = "
if test $github_existe -eq 1; then
	autres_verif="Création d'un repository"
else
	autres_verif="Pas de repository"
fi
# shellcheck source=/dev/null
source "$dossierModele/verifier_creation_projet.sh"
cd "$emplacementProjet/$F_projet" || exit "${codeErr["cd"]}"

if test $github_existe -eq 1; then
	cp "$dossierModele/gitignore.git" ./.gitignore
fi

#	# Modification des fichiers du projet
#	#	# Le fichier main.c
modifie "lstAuteur" "$F_projet/main.c"
modifie "dateCreation" "$F_projet/main.c"
modifie "nomProjet" "$F_projet/main.c"
#	#	# Les autres fichiers de développement
lstFichierDev=("include/commun.h" "include/attributs_objet.h" "test/test_commun.c" "src/commun.c")
for fichier in "${lstFichierDev[@]}"; do
	modifie "dateCreation" "$F_projet/$fichier"
done
#	#	# Le fichier Doxyfile
doxygen="docs/Doxygen"
modifie "nomProjet" "$F_projet/$doxygen/Doxyfile"
modifie "description" "$F_projet/$doxygen/Doxyfile"
#	#	# La page principale de la doc générer par Doxygen
modifie "nomProjet" "$F_projet/$doxygen/main_page.md"
modifie "description" "$F_projet/$doxygen/main_page.md"
#	#	# Le README
modifie "nomProjet" "$F_projet/docs/README.md"
modifie "description" "$F_projet/docs/README.md"
modifie "lstAuteur" "$F_projet/docs/README.md"
modifie "premierAuteur" "$F_projet/docs/README.md"
modifie "dateCreation" "$F_projet/docs/README.md"
#	#	# Le Makefile
modifie "nomProjet" "$F_projet/Makefile"

#	#	# Github
if test $github_existe -eq 1; then
	gh auth login
	git init
	gh repo create "$nomProjet" --private --source=. --remote=upstream
	github=$(grep "url =" ./.git/config | cut -d= -f2)
	modifie "github" "$F_projet/docs/README/md" "/"

	git add *
	git add .gitignore
	git commit -m "création assister"
	git branch -M master
	git remote add origin "$github"
	git push -u origin master

	echo "> Projet créer à '$github'."
else
	modifie "github" "$F_projet/docs/README.md" "d"
fi

echo -e "\n"
ls -R
echo -e "\n"

# FIN du script
FIN

# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #
