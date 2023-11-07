#!/bin/bash
: ' Script servant à poser une question fermé à l utilisateur et à analyser sa réponse
	paramètre $1 : La question à poser à l utilisateur
	paramètre $2 : Un résumer des choix possible
	autres paramètre : Les possibilité de choix à tester
		- un groupe est séparer d un autre par le paramètre "--"
'

# DÉFINITION DES FONCTIONS

: ' Affiche l aide du script et sort. '
aide() {
	if ( test $# -ne 0 -a $1 -eq -1 ) ; then
		echo -e "\n----------------------------------------------\n"
	fi
	echo "Affichage de l'aide :"
	echo -e "\tCe script sert à poser une question fermé à l'utilisateur et à analyser sa réponse."
	echo "Utilisation : $0 [{ <codePredef> | -P \"<lettre>=<nom>\" [\"><poss>\"]...}]... <question> [<poss default>]"
	echo "Avec :"
	echo -ne "\t- <codePredef> : Un code permettant d'activer un choix prédéfinit. Le code doit faire partie de la liste suivant :"
	i=0
	for code in ${!lstStrPredef[*]} ; do
		if ( test `expr $i % 4` -eq 0 ) ; then
			echo -ne "\n\t\t"
		fi
		echo -ne "> '$code'($(echo "${lstStrPredef["$code"]}" | cut -d= -f2))\t"
		i=`expr $i + 1`
	done
	echo ""
	echo -e "\t- <lettre> : une lettre seulement. La réponse minimal pour choisir ce choix."
	echo -e "\t- <nom> : Qu'est-ce que l'utilisateur répond en prenant ce choix ?."
	echo -e "\t- <poss> : Une réponse possible pour choisir ce choix."
	echo -e "\t- <question> : La question posé à l'utilisateur."
	echo -e "\t- <poss default> : Qu'est-ce que l'utilisateur répond en ne prenant aucun choix ?."
	exit $1
}

: ' Ajoute une réponse prédéfinie
	paramètre $1 : Code de la réponse prédéfinie.
	paramètre $2 : Nom de la réponse prédéfinie.
	autre paramètre : Les possibilité de réponse.
	'
reponsePredefinie() {
	repMinimal=`echo $1 | cut -c2-`
	code="$1"
	shift
	nom="$1"
	shift
	lstStrPredef["$code"]="$repMinimal=$nom"
	i=1
	for rep in "$repMinimal" "$nom" $* ; do
		lstPossibilitePredef["$code.$i"]="$rep"
		i=`expr $i + 1`
	done
	return 0
}


# DÉFINITION DES VARIABLES
#	# Gérer les choix prédéfinit
: ' Le tableau de hachage contenant les possibilité prédéfinie
	# lstPossibilitePredef["<code>.0"] = <nombre possibilite>
	# lstPossibilitePredef["<code>.<indice>"] = <possibilite>
	'
declare -A lstPossibilitePredef
: ' Le tableau de hachage contenant les affichage des choix prédéfinie
	# lstStrPredef["<code>"] = "<reponse minimal>=<utilite>"
	'
declare -A lstStrPredef
: ' La liste des code prédéfinie utilisé '
lstPredef=()
#	# Autres
: ' Le tableau de hachage contenant les réponse possible
	# lstChoixPossible["<choix>"] = <code retour>
	'
declare -A lstChoixPossible
: ' La liste des affichage des choix possible. '
strChoixPossible=""
: ' La question à posé. '
question=""
: ' Le choix par défault. '
strChoixDefault=""


# PRÉPARER LES RÉPONSE PRÉDÉFINIE
#	# Quitter
reponsePredefinie ":q" "quitte" "quitter"
#	#	# Annuler
reponsePredefinie ":u" "annule" "annuler" "undo"
#	#	# Accepte
reponsePredefinie ":a" "accepte" "accepter"
#	#	# valider
reponsePredefinie ":v" "valide" "valider"
#	#	# refuser
reponsePredefinie ":r" "refuse" "refuser"
#	#	# oui
reponsePredefinie ":o" "oui" "y" "yes"
#	#	# non
reponsePredefinie ":n" "non" "no"


# ANALYSE DES PARAMÈTRES
#	# Vérifié si demande d'aide
if ( test $# -eq 0 ) ; then
	aide 0
fi
for arg in $* ; do
	if ( test "$arg" = "-h" -o "$arg" = "--help" ) ; then
		aide 0
	fi
done
#	# Ajout des possibilité de demandes et de la question
indiceChoix=1
while ( test $# -ne 0 ) ; do
	if ( test `echo "$1" | cut -c1` = ":" ) ; then
		# Vérifié si le code prédéfinit est déjà utilisé
		for code in ${lstPredef[*]} ; do
			if ( test "$code" = "$1" ) ; then
				echo "Le code prédéfinie '$1' à déjà était utilisé."
				aide -1
			fi
		done
		# Obtenir l'affichage du choix du code prédéfinit
		strChoix="${lstStrPredef["$1"]}"
		# Vérifié si le code prédéfinit existe
		if ( test "$strChoix" = "" ) ; then
			echo "Les paramètre commencant par le symbole ':' devrait être un code pour activer un choix possible prédéfinie."
			aide -1
		fi
		# Afficher le choix du code prédéfinit
		strChoixPossible="$strChoixPossible$strChoix,"
		# Obtenir les choix possible pour ce choix prédéfinit
		for nomChoix in `echo "${!lstPossibilitePredef[*]}" | tr " " "\n" | grep "$1\."` ; do
			choix="${lstPossibilitePredef["$nomChoix"]}"
			if ( test "${lstChoixPossible["$choix"]}" != "" ) ; then
				echo "La réponse possible '$choix' à déjà était ajouter."
				aide -1
			fi
			lstChoixPossible["$choix"]="$indiceChoix"
		done
		# Sauvegardé le fait d'avoir utilisé ce choix prédéfinit
		lstPredef=( $lstPredef $1 )
		# Valider l'utilisation de ce paramètre
		shift
	elif ( test "$1" = "-P" ) ; then
		shift
		if ( test $# -eq 0 ) ; then
			echo "Après une option '-p', il faut donnée au moins le nom du choix et sa réponse minimal."
			aide -1
		fi
		# Obtenir l'affichage du choix du code prédéfinit
		strChoix="$1"
		shift
		# Vérifié l'affichage
		if ( test `echo "$strChoix" | grep -v "="` ) ; then
			echo "L'affichage du choix devrait avoir un symbole '=' pour séparer le choix minimal de son nom."
			aide -1
		fi
		choixMin=`echo "$strChoix" | cut -d= -f1`
		choixNom=`echo "$strChoix" | cut -d= -f2-`
		if ( test `echo "$choixNom" | grep "="` ) ; then
			echo "Le nom du choix ne devrait pas avoir de symbole '=' en son sein."
			aide -1
		fi
		# Afficher le choix du code prédéfinit
		strChoixPossible="$strChoixPossible$strChoix,"
		# Obtenir les choix possible pour ce choix prédéfinit
		if ( test "${lstChoixPossible["$choixMin"]}" != "" ) ; then
			echo "La réponse possible '$choixMin' à déjà était ajouter."
			aide -1
		fi
		lstChoixPossible["$choixMin"]="$indiceChoix"
		if ( test "${lstChoixPossible["$choixNom"]}" != "" ) ; then
			echo "La réponse possible '$choixNom' à déjà était ajouter."
			aide -1
		fi
		lstChoixPossible["$choixNom"]="$indiceChoix"
		while ( test $# -ne 0 -a `echo $1 | cut -c1` = ">" ) ; do
			choix="$(echo $1 | cut -c2-)"
			if ( test "${lstChoixPossible["$choix"]}" != "" ) ; then
				echo "La réponse possible '$choix' à déjà était ajouter."
				aide -1
			fi
			lstChoixPossible["$choix"]="$indiceChoix"
			shift
		done
	else
		if ( test "$question" = "" ) ; then
			question="$1"
		elif ( test "$strChoixDefault" = "" ) ; then
			strChoixDefault="*=$1"
		else
			echo "La question et le choix par défault ont déjà était définie."
			aide -1
		fi
		indiceChoix=`expr $indiceChoix - 1`
		shift
	fi
	indiceChoix=`expr $indiceChoix + 1`
done
#	# Vérifié que La question est était donnée
if ( test "$question" = "" ) ; then
	echo "Aucune question n'à était posé."
	aide -1
fi
#	# Vérifié qu'au moins une possibilité de réponse est était donnée
if ( test "$strChoixDefault" = "" -a "${#lstChoixPossible[*]}" = "0" ) ; then
	echo "L'utilisateur ne peut pas répondre"
	aide -1
fi
#	# Créer la réponse par défault
if ( test "$strChoixDefault" = "" ) ; then
	strChoixDefault="*=rien"
fi


# POSER LA QUESTION
echo -n "$question ?($strChoixPossible$strChoixDefault) : "


# OBTENIR LA RÉPONSE
read choix
monChoix=`echo "$choix" | tr "[[:upper:]]" "[[:lower:]]"`


# ANALYSER LA RÉPONSE
if ( test -z "$choix" ) ; then
	exit 0
fi
reponse="${lstChoixPossible[$choix]}"
if ( ! test -z "$reponse" ) ; then
	exit $reponse
fi
exit 0

