#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 1.0
	* DATE : lun. 30 oct.(10) 2023 18:22:46 ECT
	* Script qui Paramètre le projet à sa création.
'

if ( test "$dossierModele" = "" ) ; then # Définit si générateur paramètrer.
	echo "> La variable \$dossierModele n'est pas définit. Veuillez appeler le script $0 depuis le script Nouveau_projet.sh, afin de bien définir toutes les variables qui en dépendent."
	exit 12
fi

# CRÉATION DES VARIABLES GLOBALES
source $F_tab
#	# Autres
extension="tex"
modele="modele=\"modele.\$extension\""
#	# Ajout de balises
balises["date"]="~~date~~" ; date=`date +"%d/%m/%Y"`
balises["classe"]="~~CLASSE~~" ; classe=""
#	# Gestion des paramètres
nbParam_min=0
nbParam_max=1
strParam="[<classe>]"
declare -A detail
detail["classe"]="Dépent du type de projet LaTeX :"
detail["classe"]="${detail["classe"]}\n\t\t> (pour générer une classe(cls)) : La classe dont on veut hériter."
detail["classe"]="${detail["classe"]}\n\t\t> (pour générer un projet(tex)) : La classe que l'on veut utilisé."
detail["classe"]="${detail["classe"]}\n\t\t> (autrement) : Ne doit pas être utilisé."


# CRÉATION(S) DE(S) FONCTION(S)
source $dossierModele/fonction_creation_projet.sh

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: ' Test de la variable $languageOpt : '
if ( test "$languageOpt" != "" ) then
	case "$languageOpt" in
		"tex") ;;
		"cls") extension="cls" ;;
		"sty") extension="sty" ;;
		*)
			aide ${codeErr["export"]} $LINENO "languageOpt" "un projet (tex) ; une classe (cls) ou une librairie (sty)" "$languageOpt"
			;;
	esac
fi

: ' Tests sur les paramètres : '
if ( test "$1" != "" ) ; then
	classe="$1"
	shift
fi
if ( test $# -ne 0 ) ; then
	aide ${codeErr["nbParam"]} $LINENO "Au plus 1 paramètre attendu" $#
fi

# SCRIPT
if ( test "$extension" = "tex" ) ; then
	if ( test "$classe" = "" ) ; then
		aide ${codeErr["param"]} $LINENO "[<classe>]" "$classe" "Le générateur de projet de LaTeX:tex à besoin d'avoir le nom d'une classe de document en paramètre, afin de l'utilisé." -h "classe"
	fi
	autres_verif="\t> Création d'un projet d'édition de PDF."
else
	if ( test "$extension" = "cls" ) ; then
		if ( test "$classe" = "" ) ; then
			aide ${codeErr["param"]} $LINENO "[<classe>]" "$classe" "Le générateur de projet de LaTeX:cls à besoin d'avoir le nom d'une classe de document en paramètre, afin d'en hériter." -h "classe"
		fi
		autres_verif="\t> Création d'un projet de création de classe."
	else
		if ( test "$classe" != "" ) ; then
			aide ${codeErr["param"]} $LINENO "[<classe>]" "$classe" "Le générateur de projet de LaTeX:$extension n'à pas besoin d'avoir le nom d'une classe de document en paramètre." -h "classe"
		fi
		autres_verif="\t> Création d'un projet de création de bibliothèque."
	fi
fi
eval "$modele"
source $dossierModele/verifier_creation_projet.sh

if ( test "$extension" = "tex" ) ; then
	emplacementProjet="$emplacementProjet/$F_projet"
	cd $emplacementProjet

	# Modification du main
	modifie "nomProjet" "main.$extension"
	modifie "description" "main.$extension"
	modifie "lstAuteur" "main.$extension"
	modifie "dateCreation" "main.$extension"
	modifie "classe" "main.$extension"
	# Modification du Modèle de partie
	modifie "nomProjet" ".Modele/part.$extension"
	# Modification le prélude
	modifie "nomProjet" "Contenu/prelude.$extension"
	modifie "description" "Contenu/prelude.$extension"
	modifie "lstAuteur" "Contenu/prelude.$extension"
	modifie "dateCreation" "Contenu/prelude.$extension"

	echo -e "\n"
	ls -R
	echo -e "\n"
else
	modifie "nomProjet" "$F_projet"
	modifie "description" "$F_projet"
	modifie "lstAuteur" "$F_projet"
	modifie "dateCreation" "$F_projet"
	modifie "date" "$F_projet" "/"
	if ( test "$extension" = "cls" ) ; then
		modifie "classe" "$F_projet"
	fi
fi



# FIN du script
FIN

# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

