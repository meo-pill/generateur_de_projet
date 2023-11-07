#!/bin/~~LANGUAGE~~
: '
	* AUTEUR : ~~AUTEURS~~
	* VERSION : 1.0
	* DATE : ~~DATE~~
	* Script qui sert à ~~DESCR~~.
'


# CRÉATION DES VARIABLES GLOBALES
#	# Gestion des paramètres
indiceParam=1
~~PARAM~~

#	# Gestion des erreurs
declare -A codeErr
codeErr["nbParam"]=1
codeErr["param"]=2

#	# Autres

# AIDE UTILISATION
strParam="$strParam"
declare -A detail
detailAide="\t- -h [<nomParam>]... : Affiche l'aide :\n\t\t> Du script si pas de paramètres.\n\t\t> Des paramètres demandé si des paramètres suivent le '-h'."

# CRÉATION(S) DE(S) FONCTION(S)
: ' Affiche l aide et un possible message d erreur avant de sortir
	paramètre $1 : Le code erreur (0) si aucune erreur
	paramètre $2 : $LINENO
	autres paramètre : dépendent du code erreur choisit.
	'
aide() {
	: ' Récupérer le code de sortie du script'
	local code_sortie=
	if ( test $# -eq 0 ) ; then
		code_sortie=0
	fi
	if ( test $# -ne 0 ) ; then
		if ( test `echo "$1" | grep -vE "^[-+]?[0-9]*$"` ) ; then
			echo "Le 1er paramètre ($1) de la fonction 'aide' devrait-être le code d'erreur s'étant produit."
			exit -1
		fi
		if ( test $1 -ge 255 -o $1 -eq -1 ) ; then
			echo "Le code d'erreur '255' est résérvé pour les erreurs de la fonction 'aide'."
			echo "Le code d'erreur maximal est '255'."
			echo "Le code d'erreur '$1' n'est donc pas valide."
			exit -1
		fi
		code_sortie=$1
		shift
	fi

	: ' Affichage du message d erreur'
	if ( test "$code_sortie" != "0" ) ; then
		# Affiché le fait qu'une erreur soit survenu
		if ( test $# -lt 1 ) ; then
			echo "À l'appel de la fonction 'aide', veuillez mettre '\$LINENO' comme 2e paramètre"
			exit -1
		fi
		if ( test `echo "$1" | grep "[^0-9]"` ) ; then
			echo "À l'appel de la fonction 'aide', veuillez mettre le numéro de ligne ('\$LINENO') comme 2e paramètre, au lieu de '$1'"
			exit -1
		fi
		local nomF=`basename "$0"`
		echo -n "ERREUR ($nomF:$1) : "
		shift
		# Affiché le message de l'erreur
		case $code_sortie in
			${codeErr["nbParam"]})
				# Test de l'existance d'une condition sur le nombre de paramètre
				if ( test "$1" = "" ) ; then
					echo "paramètres de la fonction 'aide' :"
					echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre dont le script à besoin."
					echo -e "\t> Veuillez indiquer la condition sur les paramètre qui vient d'être tester sous forme de string, en 3e paramètre."
					exit -1
				fi
				# Test de l'existance d'un nombre de paramètres
				if ( test "$2" = "" ) ; then
					echo "paramètres de la fonction 'aide' :"
					echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre recu."
					echo -e "\t> Veuillez indiquer ce nombre (\$#), en 4e paramètre."
					exit -1
				elif ( test `echo "$2" | grep "[^0-9]"` ) ; then
					echo "paramètres de la fonction 'aide' :"
					echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre recu."
					echo -e "\t> Veuillez indiquer ce nombre (\$#), en 4e paramètre, au lieu de '$2'."
					exit -1
				fi
				# Affichage de l'erreur
				echo "Nombre de paramètre incorrect."
				echo -e "\t> $1 ($2 paramètres donnés)"
				# Supprimer les paramètres utilisé
				shift
				shift
				;;
			${codeErr["param"]})
				# Test de l'existance du nom du paramètre
				if ( test "$1" = "" ) ; then
					echo "paramètres de la fonction 'aide' :"
					echo -e "\t> Pour une erreur de type 'param', il est attendu que vous indiquiez l'utilité du paramètre en question."
					echo -e "\t> Veuillez indiquer ce nom, en 3e paramètre."
					exit -1
				fi
				# Test de l'existance de l'erreur sur le paramètre
				if ( test "$3" = "" ) ; then
					echo "paramètres de la fonction 'aide' :"
					echo -e "\t> Pour une erreur de type 'param', il est attendu que vous indiquiez l'erreur sur le paramètre en question."
					echo -e "\t> Veuillez indiquer ce détail, en 5e paramètre."
					exit -1
				fi
				# Affichage de l'erreur
				echo "Le paramètre n°$indiceParam ($2) est incorrect."
				echo -e "\t> Paramètre n°$indiceParam : $1."
				echo -e "\t> $3"
				# Supprimer les paramètres utilisé
				shift
				shift
				shift
				;;
			*)
				echo "Paramètre de la fonction 'aide' :"
				echo -e "\t> Le code d'erreur '$code_sortie' est inconnue."
				echo -e "\t> Les ${#codeErr[*]} codes d'erreurs connues sont : ${!codeErr[*]}"
				exit -1
				;;
		esac
		shift
		# Fin de la gestion d'erreur
		echo ""
	fi

	: ' Affichage de l aide'
	lang=`echo "$0" | sed "s/^.*\/[^/]*\/GenereProjet_\([^/]*\)\.sh$/\1/g"`
	if ( test "$0" = "$dossierModele/GenereProjet_$lang.sh" ) ; then
		nomProgramme="Generateur_$lang.sh"
	else
		nomProgramme="$0"
	fi
	echo "Utilisation : $nomProgramme $strParam"
	echo -e "$detailAide"
	if ( test "$1" = "-h" ) ; then
		shift
		while ( test $# -ne 0 ) ; do
			if ( test "${detail["$1"]}" = "" ) ; then
				echo -e "> Il n'y à pas de paramètres nommée '$1'."
			else
				if ( test $( echo "$1" | cut -c1 ) = "%" ) ; then
					echo -e "\t- $(echo "$1" | cut -c2-) : ${detail["$1"]}"
				else
					echo -e "\t- <$1> : ${detail["$1"]}"
				fi
			fi
			shift
		done
	elif ( test $# -ne 0 ) ; then
		echo "Trop d'argument donnée à la fonction 'aide' : "
		for arg in "$@" ; do
			echo -n "\"$arg\" "
		done
		echo ""
		exit -1
	else
		for param in ${!detail[*]} ; do
			if ( test $( echo "$param" | cut -c1 ) = "%" ) ; then
				echo -e "\t- $(echo "$param" | cut -c2-) : ${detail["$param"]}"
			else
				echo -e "\t- <$param> : ${detail["$param"]}"
			fi
		done
	fi

	: ' Sortie du programme'
	exit $code_sortie
}


# VÉRIFIÉ SI IL Y À UNE DEMANDE D'AIDE
for (( i=1 ; i<=$# ; i++ )) ; do
	if ( test $(eval "echo \$$i") = "-h" ) ; then
		for (( ; i!=0 ; i-- )) ; do
			shift
		done
		if ( test $# -eq 0 ) ; then
			aide
		else
			aide 0 -h $*
		fi
	fi
done


# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon nombre de paramètre ? #
~~PARAM~~

#	# Bon type de paramètre ? #

~~PARAM~~


# SCRIPT

# SORTIE
echo -e "\n\tFIN DU SCRIPT '$(basename "$0")'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #


