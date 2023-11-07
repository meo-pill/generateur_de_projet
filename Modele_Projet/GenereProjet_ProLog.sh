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
extension="pl"
modele="script.$extension"
#	# Gestion des paramètres
nbParam=0
strParam=""
autres_verif=""


# CRÉATION(S) DE(S) FONCTION(S)
source $dossierModele/fonction_creation_projet.sh

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: ' Test de la variable $languageOpt : '
if ( test "$languageOpt" != "" ) then
	aide ${codeErr["param"]} $LINENO "<language>" "$languageOpt" "Le language de programmation ProLog n'à pas d'option de language." -h "language"
fi

: ' Tests sur les paramètres : '
if ( test $# -ne 0 ) ; then
	aide ${codeErr["nbParam"]} $LINENO "Pas de paramètres attendu" $#
fi

# SCRIPT
source $dossierModele/verifier_creation_projet.sh

#	# Modification des fichiers du projet
modifie "nomProjet" $F_projet
modifie "lstAuteur" $F_projet
modifie "description" $F_projet
modifie "dateCreation" $F_projet

# FIN du script
FIN

# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

