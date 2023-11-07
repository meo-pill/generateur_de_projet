#!/bin/bash
: '
	* AUTEUR : ~~AUTEURS~~
	* VERSION : 1.0
	* DATE : ~~DATE~~
	* Script qui Paramètre le projet à sa création.
'

# CRÉATION DES VARIABLES GLOBALES
source $F_tab
#	# Autres
extension=~~EXTENSION~~
#	# Gestion des paramètres
nbParam_min=0
nbParam_max=0
strParam=


# CRÉATION(S) DE(S) FONCTION(S)
source $dossierModele/../fonction_creation_projet.sh

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: ' Test de la variable $languageOpt : '
if ( test "$languageOpt" != "" ) ; then
	~~LANGUAGE_OPT~~
fi

: ' Tests sur les paramètres : '
if ( test $# -ne 0 ) ; then
	aide ${codeErr["nbParam"]} $LINENO "de $nbParam_min à $nbParam_max paramètre(s) attendu" $#
fi


# CRÉER LE PROJET
#autres_verif="\t> <verifParamètre>"
#objACopier="<nomModele>"
source $dossierModele/../verifier_creation_projet.sh


# PARAMÈTRER LE PROJET
#modifie "<nomBalise>" $F_projet


# FIN du script
echo -e "\n\tFIN DU PARAMETRAGE DU PROJET '$(basename "$F_projet")'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #


