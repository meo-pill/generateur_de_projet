: " Affiche le message d erreur d un code donné.
	paramètre $1 : Le code de l erreur
	autres paramètres : Les paramètre propre au code de l erreur
	return -1 si erreur de la fonction ; Le nombre de paramètre utilisé autrement (max=254)
	"
affErr() {
	code_sortie=$1
	nbParamUtilise=-1
	shift
	if test "$code_sortie" -eq ${codeErr["nbParam"]}  ; then
		# Test de l'existance d'une condition sur le nombre de paramètre
		if test "$1" = "" ; then
			echo "paramètres de la fonction 'aide' :"
			echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre dont le script à besoin."
			echo -e "\t> Veuillez indiquer la condition sur les paramètre qui vient d'être tester sous forme de string, en 3e paramètre."
			exit 255
		fi
		# Test de l'existance d'un nombre de paramètres
		if test "$2" = "" ; then
			echo "paramètres de la fonction 'aide' :"
			echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre recu."
			echo -e "\t> Veuillez indiquer ce nombre (\$#), en 4e paramètre."
			exit 255
		elif test "$(echo "$2" | grep "[^0-9]")" ; then
			echo "paramètres de la fonction 'aide' :"
			echo -e "\t> Pour une erreur de type 'nbParam', il est attendu que vous indiquiez le nombre de paramètre recu."
			echo -e "\t> Veuillez indiquer ce nombre (\$#), en 4e paramètre, au lieu de '$2'."
			exit 255
		fi
		# Affichage de l'erreur
		echo "Nombre de paramètre incorrect."
		echo -e "\t> $1 ($2 paramètres donnés)"
		# Indiqué le nombre de paramètre utilisé
		nbParamUtilise=2
	elif test "$code_sortie" -eq "${codeErr["param"]}" ; then
		# Test de l'existance du nom du paramètre
		if test "$1" = "" ; then
			echo "paramètres de la fonction 'aide' :"
			echo -e "\t> Pour une erreur de type 'param', il est attendu que vous indiquiez l'utilité du paramètre en question."
			echo -e "\t> Veuillez indiquer ce nom, en 3e paramètre."
			exit 255
		fi
		# Test de l'existance de l'erreur sur le paramètre
		if test "$3" = "" ; then
			echo "paramètres de la fonction 'aide' :"
			echo -e "\t> Pour une erreur de type 'param', il est attendu que vous indiquiez l'erreur sur le paramètre en question."
			echo -e "\t> Veuillez indiquer ce détail, en 5e paramètre."
			exit 255
		fi
		# Affichage de l'erreur
		echo "Le paramètre n°$indiceParam ($2) est incorrect."
		echo -e "\t> Paramètre n°$indiceParam : $1."
		echo -e "\t> $3"
		# Indiqué le nombre de paramètre utilisé
		nbParamUtilise=3
	elif test "$code_sortie" -eq "${codeErr["appel"]}" ; then
		echo "Appel du script '$(basename "$0")' incorrect."
		echo "Ce script doit-être appelé par le script 'Nouveau_projet.sh'."
		nbParamUtilise=0
	elif test "$code_sortie" -eq "${codeErr["export"]}" ; then
		echo "Contenu d'une variable exporter incorrect."
		echo "La varible exporter '$1' devrait contenir $2 au lieu de '$3'."
		nbParamUtilise=3
	else
		affErr_new "$code_sortie" "$@" ;
		nbParamUtilise=$?
		if test "$nbParamUtilise" -eq 254 ; then
			echo "Le code d'erreur '$code_sortie' donnée à la fonction 'aide' est inconnue."
			echo -e "\t> Les ${#codeErr[*]} codes d'erreurs connues sont : ${!codeErr[*]}"
			return 255
		fi
	fi
	return $nbParamUtilise
}
: " Affiche le message d erreur d un code donné.
	paramètre $1 : Le code de l erreur
	autres paramètres : Les paramètre propre au code de l erreur
	return -1 si erreur de la fonction ; Le nombre de paramètre utilisé autrement (max=254)
	"
affErr_new() {
	echo "La fonction 'affErr_new' doit-être redéfinit pour spécialiser pour le script '$0'."
	exit 254
}

: " Affiche l aide et un possible message d erreur avant de sortir
	paramètre $1 : Le code erreur (0) si aucune erreur
	paramètre $2 : $LINENO
	autres paramètre : dépendent du code erreur choisit.
	"
aide() {
	: ' Récupérer le code de sortie du script'
	local code_sortie=
	if test $# -eq 0 ; then
		code_sortie=0
	fi
	if test $# -ne 0 ; then
		if test "$(echo "$1" | grep -vE "^[-+]?[0-9]*$")" ; then
			echo "Le 1er paramètre ($1) de la fonction 'aide' devrait-être le code d'erreur s'étant produit."
			exit 255
		fi
		if test "$1" -ge 255 -o "$1" -eq -1 ; then
			echo "Le code d'erreur '255' est résérvé pour les erreurs de la fonction 'aide'."
			echo "Le code d'erreur maximal est '255'."
			echo "Le code d'erreur '$1' n'est donc pas valide."
			exit 255
		fi
		code_sortie=$1
		shift
	fi
	: ' Affichage du message d erreur'
	if test "$code_sortie" != "0" ; then
		# Affiché le fait qu'une erreur soit survenu
		if test $# -lt 1 ; then
			echo "À l'appel de la fonction 'aide', veuillez mettre '\$LINENO' comme 2e paramètre"
			exit 255
		fi
		if test "$(echo "$1" | grep "[^0-9]")" ; then
			echo "À l'appel de la fonction 'aide', veuillez mettre le numéro de ligne ('\$LINENO') comme 2e paramètre, au lieu de '$1'."
			exit 255
		fi
		# séparation des paramètres
		local nomF
		nomF=$(basename "$0")

		echo -n "ERREUR ($nomF:$1) : "
		shift
		# Affiché le message de l'erreur
		affErr "$code_sortie" "$@"
		nbParamUtilise=$?
		if test $nbParamUtilise -eq 255 ; then
			exit 255
		fi
		for (( i=0 ; i<nbParamUtilise ; i++ )) ; do
			shift
		done
		# Fin de la gestion d'erreur
		echo ""
	fi
	: ' Affichage de l aide'
	lang=$(echo "$0" | sed "s/^.*\/[^/]*\/GenereProjet_\([^/]*\)\.sh$/\1/g")
	if test "$0" = "$dossierModele/GenereProjet_$lang.sh" ; then
		nomProgramme="Generateur_$lang.sh"
	else
		nomProgramme="$0"
	fi
	echo "Utilisation : $nomProgramme $strParam"
	echo -e "$detailAide"
	if test "$aideLanguage" = "true" ; then
		export F_tab="$dossierModele/mesTableaux.sh"
		rm -f "$F_tab"
		touch "$F_tab"
		{ declare -p codeErr ; declare -p balises ; declare -p lstLiens ;}  >> "$F_tab"

	fi
	if test "$1" = "-h" ; then
		shift
		while test $# -ne 0 ; do
			if test "$aideLanguage" = "true" -a "$1" = "-l" ; then
				shift
				if test "$1" = "" ; then
					for lang in "${lstLanguage[@]}" ; do
						echo ""
						parametreur="$dossierModele/GenereProjet_$lang.sh"
						chmod a+x "$parametreur"
						$parametreur -h
						chmod 644 "$parametreur"
					done
					aideLanguage="false"
				else
					for lang in "${lstLanguage[@]}" ; do
						if test "$lang" = "$1" ; then
							echo ""
							parametreur="$dossierModele/GenereProjet_$lang.sh"
							chmod a+x "$parametreur"
							$parametreur -h
							chmod 644 "$parametreur"
						fi
					done
				fi
			elif test "${detail["$1"]}" = "" ; then
				echo -e "> Il n'y à pas de paramètres nommée '$1'."
			else
				if test "$( echo "$1" | cut -c1 )" = "%" ; then
					echo -e "\t- $(echo "$1" | cut -c2-) : ${detail["$1"]}"
				else
					echo -e "\t- <$1> : ${detail["$1"]}"
				fi
			fi
			shift
		done
	elif test $# -ne 0 ; then
		echo -n "Trop d'argument donnée à la fonction 'aide' : "
		for arg in "$@" ; do
			echo -n "\"$arg\" "
		done
		echo ""
		exit 255
	else
		for param in ${!detail[*]} ; do
			if test "$( echo "$param" | cut -c1 )" = "%" ; then
				echo -e "\t- $(echo "$param" | cut -c2-) : ${detail["$param"]}"
			else
				echo -e "\t- <$param> : ${detail["$param"]}"
			fi
		done
	fi
	if test "$aideLanguage" = "true" ; then
		rm -f "$F_tab"
	fi
	: ' Sortie du programme'
	if test "$1" = "-n" -a "$code_sortie" -ne -1 -a "$code_sortie" -ne 255 ; then
		return "$code_sortie"
	fi
	exit "$code_sortie"
}
detailAide="\t- -h [<nomParam>]... : Affiche l'aide :\n\t\t> Du script si pas de paramètres.\n\t\t> Des paramètres demandé si des paramètres suivent le '-h'.\n\t\t\t| Les paramètres fixes (ex: -v|contre-ex:<v>) doivent-être précéder d'un '%'.$detailAide"

: " Remplace une balise d un fichier du nouveau projet par un texte donnée.
	paramètre $1 : Le nom de la balise à remplacer par le contenu de la variable éponyme.
	paramètre $2 : Le nom du fichier (à l intérieur de 'emplacementProjet') à modifiée.
	pramètre $3 : Si '/', modifie la chaine à insérer pour que sed marche, malgès la présence de caractère "/".
	pramètre $3 : Si 'd', supprime les lignes possédant la balise.
	return 255 en cas d erreur, 1 autrement.
	"
modifie() {
	text=$(eval "echo \"\$$1\"")
	if test $# -lt 2 ; then
		echo "La fonction 'modifie' prend au moins 2 paramètre :"
		echo -e "\t> \$1 : Que faut-il modifier ?"
		echo -e "\t> \$2 : Quel fichier faut-il modifier ?"
		exit 255
	elif test $# -eq 3 ; then
		if test "$3" = "d" ; then
			text="\d"
		else
			text=$(echo "$text" | sed "s/\//\\\\\\\\\//g")
		fi
	elif test $# -gt 3 ; then
		echo "La fonction 'modifie' prend au plus 3 paramètre :"
		echo -e "\t> \$1 : Que faut-il modifier ?"
		echo -e "\t> \$2 : Quel fichier faut-il modifier ?"
		echo -e "\t> \$3 : Option de modification (/,d)"
		exit 255
	fi
	if test "$text" = "\d" ; then
		Fichier="$emplacementProjet/$2"
		sed -i -e "$( grep -n "${balises["$1"]}" "$Fichier" | cut -d: -f1 )d" "$Fichier"
	else
		sed -i -e "s/${balises["$1"]}/$text/g" "$emplacementProjet/$2"
	fi
}

: "Vérifie si un fichier existe déjà
	paramètre $1 : Le nom de la variable contenant le nom du fichier
	paramètre $2 : Le chemin vers le fichier
	paramètre $3 : L extension du fichier
	==============================
	paramètre $1 : -e
	paramètre $2 : Le nom de la variable contenant le nom du fichier
	"
testFichier() {
	: ' Définir les variables '
	quitte="eval \"\$nomVar=\\\"\$nom\\\"\" ; return 0"
	nomVar=""
	chemin=""
	nom=""
	ext=""

	: ' Lire les paramètres '
	if test "$1" = "-e" ; then
		quitte="eval \"\$nomVar=\\\"\$chemin/\$nom\$ext\\\"\" ; return 0"
		shift
		# Obtenir le nom
		nomVar=$1 ; shift
		eval "nom=\"\$$nomVar\""
		# Séparer le nom
		chemin=$(dirname "$nom")
		nom=$(basename "$nom")
		ext=$(echo "$nom" | cut -d. -f2-)
		if test "$ext" = "$nom" ; then
			ext=""
		else
			ext=".$ext"
		fi
	else
		nomVar=$1 ; shift
		chemin="$1" ; shift
		eval "nom=\"\$$nomVar\""
		ext="$1" ; shift
		if test "$ext" != "" ; then
			ext=".$ext"
		fi
	fi
	: ' Obtenir le nom de la variable où se trouve le nom du fichier '
	shift

	: ' Tester l existance du fichier '
	i=2
	nomF="$chemin/$nom$ext"
	while test -e "$nomF" ; do
		nom2="$nom"_"$i"
		echo "Le fichier '$nomF' existe déjà. Que voulez-vous faire ?"
		echo -e "\t1) Supprimer '$nomF'."
		echo -e "\t2) Renommer '$nom' en '$nom2'."
		echo -e "\t3) Renommer '$nom' autrement."
		echo -e "\t4) Abandonner."
		echo -n "Choix : "
		read -r choix
		case "$choix" in
			1)
				$questionneur :v :o :a "rm : supprimer '$nomF' ?" "annuler" ; retour=$?
				case $retour in
					"0") echo "> Annuler suppression" ;;
					"1"|"2"|"3")
						eval "$quitte"
						break
						;;
					*)
						echo "ERREUR sur a question."
						exit 255
						;;
				esac
				;;
			2)
				nom="$nom2"
				nomF="$chemin/$nom$ext"
				i=$((i + 1))
				;;
			3) nouveauNom=""
				while test "$nouveauNom" = "" ; do
					echo -n "Entrer le nouveau nom du fichier (:a=abandon,*=nom) : "
					read -r nouveauNom
					if test "$nouveauNom" = ":a" ; then
						echo "> Abandon"
						return 1
					elif test "$( echo "$nouveauNom" | grep "[^a-zA-Z0-9_\-]" )" ; then
						echo "Le nouveau nom contient des caractère interdit pour un nom de fichier."
						nouveauNom=""
					fi
				done
				nom="$nouveauNom"
				nomF="$chemin/$nom$ext"
				i=2
				;;
			4) echo "Abandonner" ; return 1 ;;
			*) echo "Je ne connais pas cette possibilité." ;;
		esac
	done

	: ' Valider et sortir '
	eval "$quitte"
}

: ' Test si un paramètre github est correct
	return -1 en cas d erreur, 0 autrement.
	'
testGit() {
	detail["github"]="detail[\"github\"]=\"création d'un dépot github 'https://github.com/<pseudo-git>/<nomProjet>' nécesite l'instalation de gh\";github=\"\""
	balises["github"]="~~ADRESSE_GIT~~"
	if test -z "$github" ; then
		if ! test "$(which gh)" ; then
			aide "${codeErr["param"]}" $LINENO "-g" "-g" "Le paramètre '-g' nécéssite d'avoir 'gh' d'installer sur la machine. Entrez la commande 'apt-get install gh' en mode super-utilisateur pour l'installer, puis réessayer." -h "github"
			return 255
		fi
	else
		aide "${codeErr["param"]}" $LINENO "-g" "-g" "Le paramètre '-g' à déjà était utilisé." -h "github"
		return 255
	fi
	return 0
}

: ' Fini une génération de projet.
	'
FIN() {
	echo -e "> Création des liens vers le projet.\n"
	for lien in "${lstLiens[@]}" ; do
		typeLien=$(echo "$lien" | cut -d: -f1)
		lien=$(echo "$lien" | cut -d: -f2-)
		# Création du lien
		if test "$typeLien" = "s" ; then
			ln -s "$emplacementProjet/$F_projet" "$lien"
		else
			ln "$emplacementProjet/$F_projet" "$lien"
		fi
	done
	echo -e "\n\tFIN DU PARAMETRAGE DU SCRIPT '$(basename "$F_projet")'."
	exit 0
}


# Est-ce qu'une demande d'aide à était faite ?
if test "$1" = "-h" ; then
	shift
	if test $# -eq 0 ; then
		aide
	else
		aide 0 -h "$@"
	fi
fi

# Est-ce que Toutes les variables important ont était définit ?
if ! test -v strParam ; then
	echo "Veuillez définir le contenu de \$strParam dans le script $0."
	exit 254
fi

