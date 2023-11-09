#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 1.0
	* DATE : lun. 30 oct.(10) 2023 18:22:46 ECT
	* Script qui Paramètre le modèle de projet à sa création.
'

if test "$dossierModele" = ""; then # Définit si générateur paramètrer.
	echo "> La variable \$dossierModele n'est pas définit. Veuillez appeler le script $0 depuis le script Nouveau_projet.sh, afin de bien définir toutes les variables qui en dépendent."
	exit 12
fi

# CRÉATION DES VARIABLES GLOBALES
# shellcheck source=/dev/null
source "$F_tab"
#	# Gestion des paramètres
nbParam_min=1
nbParam_max=3

#	# Info sur le nouveau projet
#	#	# Type du projet
extension=
modele="archiveModele=\"modele_\$typeModele\""
#	#	# Autres infos sur le projet
description="Créer un modèle de projet pour le language '$nomProjet'."
#	#	# Nom et emplacement du projet
emplacementProjet="$dossierModele/type_$nomProjet"
gen="GenereProjet_$nomProjet.sh"
nomProjet=

#	# Qu'elle balises à remplacer dans le projet ?
balises["extension"]="~~EXTENSION~~"
balises["languageOpt"]="~~LANGUAGE_OPT~~"
balises["commentaireLigne"]="~~COM~~"
balises["commentaireBlocDebut"]="~~COM_DEB~~"
balises["commentaireBlocFin"]="~~COM_FIN~~"

#	# Autres
opt_d=1
typeModele=""

# AIDE UTILISATION
strParam="<nomModele> [<extension>] [<commentaire>]"
declare -A detail
detail["nomModele"]="Le nom du modèle à créer."
detail["extension"]="L'extension utilisé par les projets produits par ce modèle."
detail["commentaire"]="Les balises indiquant la présence de commentaire. Si aucun symbole de commentaire donnée, c'est que le modèle de projet est une architecture (comme le C).\n\t\t> Les symbole de commentaire sont donnée selon la forme : '[<commentaireLigne>] [<commentaireBlocDebut> <commentaireBlocFin>]'."
detail["commentaireLigne"]="La balise marquant un début d'un commentaire (limité à une ligne)."
detail["commentaireBlocDebut"]="La balise marquant un début d'un commentaire (sur plusieurs lignes)."
detail["commentaireBlocFin"]="La balise marquant la fin d'un commentaire (sur plusieurs lignes)."

# CRÉATION(S) DE(S) FONCTION(S)
# shellcheck source=/dev/null
source "$dossierModele/fonction_creation_projet.sh"

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: " Test de la variable $languageOpt : "
lstLanguageOpt=""
if test "$languageOpt" != ""; then
	lstLanguageOpt=$(echo "$languageOpt" | sed "s/ /\\\\\\\ /g" | tr ":" " ")
	eval "lstLanguageOpt=( $lstLanguageOpt )"
fi

: ' Tests sur les paramètres : '
if test "$(echo "$1" | grep "[^a-zA-Z0-9_\-]")"; then
	aide "${codeErr["param"]}" $LINENO "<nomModele>" "$1" "Le paramètre \$$indiceParam ne devrait pas contenir d'extension pour le modèle de projet." -h "nomModele"
fi
nomProjet="$1"
shift
indiceParam=$(indiceParam + 1)

if test "$1" != ""; then
	if test "$(echo "$1" | cut -c1)" = "."; then
		aide "${codeErr["param"]}" $LINENO "<extension>" "$1" "Le paramètre \$$indiceParam ne devrait pas commencer par un '.'." -h "extension"
	fi
	extension="$1"
	shift
	indiceParam=$((indiceParam + 1))
fi

if test "$1" != ""; then
	if test "$2" = ""; then
		commentaireLigne="$1"
	else
		if test "$3" = ""; then
			commentaireBlocDebut="$1"
			commentaireBlocFin="$2"
		else
			commentaireLigne="$1"
			commentaireBlocDebut="$2"
			commentaireBlocFin="$3"
			shift
			indiceParam=$((indiceParam + 1))
		fi
		shift
		indiceParam=$((indiceParam + 1))
	fi
	shift
	indiceParam=$((indiceParam + 1))
	opt_d=0
fi

if test $# -ne 0; then
	aide "${codeErr["nbParam"]}" $LINENO "De $nbParam_min à $nbParam_max attendu" $#
fi

# SCRIPT
if test $opt_d -eq 1; then
	autres_verif="\t> Le modèle est une architecture"
	typeModele="architecture"
else
	autres_verif="\t> Le modèle n'est pas une architecture"
	typeModele="fichier"
fi
if test -e "$emplacementProjet.tar.gz"; then
	if test -d "$emplacementProjet"; then
		if test "$(ls -a "$emplacementProjet" | grep -v "^\./$" | grep -vc "^\.\./$")" -eq 0; then
			tar -xvf "$emplacementProjet.tar.gz" -C "$emplacementProjet"
		else
			echo "L'archive $emplacementProjet.tar.gz et le dossier $emplacementProjet existe déjà tout les deux."
			echo "Veuillez vérifier par vous-même si il est possible de modifier le dossier, puis de l'ajouter à l'archive sans problème."
			$questionneur :v "Continuer au risque d'avoir une incompatibilité entre les deux ?" "abandonner"
			retour=$?
			if test $? -eq 0; then
				echo "Abandon de la création du projet."
				exit 0
			fi
		fi
	else
		mkdir "$emplacementProjet"
		tar -xvf "$emplacementProjet.tar.gz" -C "$emplacementProjet"
	fi
fi
if ! test -d "$emplacementProjet"; then
	mkdir "$emplacementProjet"
fi
# shellcheck source=/dev/null
source "$dossierModele/verifier_creation_projet.sh"

#	# Création du générateur
if ! test -e "$dossierModele/$gen"; then
	tar -xvf "$archiveModele" -C "$dossierModele" "./GenereProjet_$typeModele.sh"
	mv "$dossierModele/GenereProjet_$typeModele.sh" "$dossierModele/$gen"
	if test ${#lstLanguageOpt[*]} -eq 0; then
		languageOpt="\taide \${codeErr[\"param\"]} \$LINENO \"<language>\" \"\$languageOpt\" \"Le language de programmation $nomProjet n'à pas d'option de language.\" -h \"language\""
	else
		languageOpt="\tcase \$languageOpt in\n"
		languageOpt="$languageOpt\t\t${lstLanguage[1]}) : ;;\n"
		unset lstLanguageOpt[1]
		lstLanguageOpt=("${lstLanguageOpt[@]}")
		for opt in "${lstLanguageOpt[@]}"; do
			languageOpt="$languageOpt\t\t$opt) <action> ;;\n"
		done
		languageOpt="$languageOpt\t\t*)"
		languageOpt="$languageOpt aide \${codeErr[\"param\"]} \$LINENO \"<language>\" \"\$languageOpt\" \"Le language de programmation $nomProjet n'à pas de spécialisation \$languageOpt.\" -h \"language\""
		languageOpt="$languageOpt ;;\n"
		languageOpt="$languageOpt\tesac"
	fi
	modifie "extension" "../$gen"
	modifie "languageOpt" "../$gen"
fi

#	# Création du modèle
if test $opt_d -eq 1; then
	language="$nomProjet"
	modifie "language" "$F_projet/docs/README.md"
else
	modifie "COM_DEB" "$F_projet"
	modifie "COM_FIN" "$F_projet"
	modifie "COM" "$F_projet"
fi

# FIN du script
FIN

# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #
