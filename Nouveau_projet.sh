#!/bin/bash
: '
	* AUTEUR : Erwan PECHON :: Mewen PUREN
	* VERSION : 2.0
	* DATE : 31 oct. 2023
	* Script qui sert à créer un nouveau projet dans un language donnée.
'



# CRÉATION DES VARIABLES GLOBALES
#	# Localisation
dossierActu=`pwd`
export dossierModele="$dossierModele" # Où ce trouve les Modèles ?
export archiveModele="$dossierModele/type_\$language.tar.gz"
parametreur="$dossierModele/GenereProjet_\$language.sh"
export questionneur="$dossierModele/question.sh"
chmod a+x $questionneur

#	# Gestion des paramètres
export indiceParam=1
nbParam_min=2

#	# Gestion des erreurs
declare -A codeErr
codeErr["nbParam"]=1
codeErr["param"]=2
codeErr["appel"]=3
codeErr["export"]=4
codeErr["cd"]=12

#	# Info sur le nouveau projet
#	#	# Type du projet
export language="<Le language dont on veut générer un projet>"
lstLanguage=( `ls $dossierModele | grep -E "^GenereProjet_.*\.sh|^type_.*\.tar\.gz" | cut -d_ -f2- | cut -d. -f1 | sort -u | tr "\n" "\t"` )
export languageOpt="" # Une option de language (ex:cls pour classe LaTeX)
export extension="<Veuillez redéfinir la variable '\$extension'.>"
#	#	# Nom et emplacement du projet
export nomProjet=""
export emplacementProjet=""
lstLiens=()
#	#	# Contributeur du projet
export premierAuteur="" # Chef du projet
export lstAuteur="" # premierAuteur :: auteur2 ; auteur3 ; ... ; auteurN
#	#	# Autres infos sur le projet
export description="" # Le projet sert à $description
export dateCreation=`date +"%a %e %b %Y %H:%M:%S %Z" | sed 's/\<[a-z]/\U&/g'`

#	# Qu'elle balises à remplacer dans le projet ?
declare -A balises
balises["nomProjet"]="~~PROJET~~"
balises["lstAuteur"]="~~AUTEURS~~"
balises["premierAuteur"]="~~CHEF~~"
balises["description"]="~~DESCR~~"
balises["dateCreation"]="~~DATE~~"
balises["language"]="~~LANGUAGE~~"

#	# Autres
export autres_verif=">>>>>Veuillez personaliser la variable 'autres_verif'.<<<<<"
export modele="Veuillez redéfinir \$modele avec le nom du modèle de projet (depuis l'archive \$archiveModele)"



# AIDE UTILISATION
strParam="[<emplacementProjet>/]<nomProjet> <language> [{ -a <auteur> [<auteur>]... a- | -d <description> | {-l|-s} <lien> }]... [--] [<autres>]..."
detailAide="\n\t\t> L'aide d'un language donnée si <nomParam> est '-l <nomLanguage>'.\n\t\t> L'aide de tout les language si <nomParam est '-l \"\"'."
aideLanguage="true"
declare -A detail
# Paramètre $1
detail["emplacementProjet"]="Le dossier où créer le projet."
detail["nomProjet"]="Le nom du projet."
# Paramètre $2
detail["language"]="Le language principale du projet à créer, à choisir dans la liste suivante : ${lstLanguage[*]}.\n\t\t> Une spécialisation du language peut-être fait en l'appelant avec '<language>:<spe>' (par exemple : 'Shell:zsh')."
# Paramètre 'auteur'
detail["%-a"]="Déclare le début d'une liste d'auteur à ajouter au auteurs déjà mentionner (si il y en à déjà eu)."
detail["auteur"]="Un auteur du projet."
detail["%a-"]="Déclare la fin d'une liste d'auteur."
# Paramètre 'définition
detail["%-d"]="Annonce la définition de la description."
detail["description"]="Compléter la phrase 'Le projet sert à <description>'."
detail["%-l"]="Crée un lien physique vers le projet. Permet d'avoir plusieurs accès au projet."
detail["%-s"]="Crée un lien symbolique vers le projet. Permet d'avoir plusieurs accès au projet."
detail["lien"]="Nom du lien (et chemin) vers le projet."
detail["--"]="Explicite la fin des options du script général et explicite le début des options du générateur spécialiser."
detail["autres"]="Les paramètres à transmettre au générateur de projet du language cible."



# CRÉATION(S) DE(S) FONCTION(S)
source "$dossierModele/fonction_creation_projet.sh"



# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon nombre de paramètre ? #
if ( test $# -lt $nbParam_min ) ; then
	aide ${codeErr["nbParam"]} $LINENO "Au moins $nbParam_min paramètres attendu" $#
fi
#	# Bon type de paramètre ? #

: ' Test du paramètre [<emplacementProjet>/]<nomProjet> : '
echo -e "> Lecture de l'emplacement du projet\n"
if ( test $( echo "$1" | grep "[^a-zA-Z0-9_/.\-]" ) ) then
	aide ${codeErr["param"]} $LINENO "[<emplacementProjet>/]<nomProjet>" "$1" "Le paramètre \$$indiceParam contient des caractère interdit pour un emplacement de projet." -h "emplacementProjet" "nomProjet"
fi
emplacementProjet=$(dirname "$1")
nomProjet=`basename "$1"`
shift ; indiceParam=`expr $indiceParam + 1`

: ' Test du paramètre <emplacementProjet> : '
if ( test "$emplacementProjet" != "" ) ; then
	: ' Obtenir le chemin absolue vers le dossier demandé '
	emplacementProjet=`echo "$emplacementProjet" | sed "s/^ *//g"` # Supprimer les espaces au début
	if ( test "$( echo "$emplacementProjet" | cut -c1 )" = "~" ) ; then # Si relatif par rapport au HOME de l'utilisateur
		emplacementProjet="$HOME$( echo "$emplacementProjet" | cut -c2- )"
	elif ( test "$( echo "$emplacementProjet" | cut -c1 )" != "/" ) ; then # Si relatif par rapport au dossier actuel
		emplacementProjet="$dossierActu/$emplacementProjet"
	fi
	emplacementProjet=`echo "$emplacementProjet" | sed "s/\/\.\//\//g"` # Supprimer tout les '/./' de la réponse.
	emplacementProjet=`echo "$emplacementProjet" | sed "s/\/\.$/\//g"` # Supprimer tout les '/./' de la réponse.
	emplacementProjet=`echo "$emplacementProjet" | sed "s/\/[^/]*\/\.\.\//\//g"` # Supprimer tout les '/[^/]*/../' de la réponse.
	emplacementProjet=`echo "$emplacementProjet" | sed "s/\/[^/]*\/\.\.$/\//g"` # Supprimer tout les '/[^/]*/../' de la réponse.
	emplacementProjet=`echo "$emplacementProjet" | sed 's#/\+$##'` # Supprimer tout les '/' à la fin de la réponse.

	: ' Obtenir le chemin vers l objet demandé '
	chemin=""
	for F in `echo "$emplacementProjet" | tr "/" " "` ; do
		chemin="$chemin/$F"
		# Vérifier si tout les membres du chemin existe :
		if ( ! test -e "$chemin" ) ; then
			echo "Le dossier '$chemin' n'existe pas."
			echo "Par conséquent, les dossier fils allant jusqu'à '$emplacementProjet' n'existe pas."
			$questionneur :o "Voulez-vous les créer" "abandon" ; retour=$?
			if ( test $retour -eq 0 ) ; then # annuler
				echo "> Abandon."
				exit 0
			elif ( test $retour -eq 1 ) ; then # o
				break
			else # err
				echo "ERROR sur la question"
				exit -1
			fi
		fi
		# Vérifier si tout les membres du chemin sont des dossiers
		if ( ! test -d "$chemin" ) ; then
			echo "Le fichier '$chemin' existe, mais il n'est pas un dossier."
			echo "Par conséquent, les dossier fils allant jusqu'à '$emplacementProjet' n'existe pas."
			$questionneur :o "Voulez-vous l'ÉCRASER" "abandon" ; retour=$?
			if ( test $retour -eq 0 ) ; then # annuler
				echo "> Abandon."
				exit 0
			elif ( test $retour -eq 1 ) ; then # o
				break
			else # err
				echo "ERROR sur la question"
				exit -1
			fi
		fi
		# Vérifier si l'on ne passe pas par les modèles
		if ( test "$chemin" = "$dossierModele" ) ; then
			echo "Merci de ne pas créer de projet dans les modèles de projet."
			echo "Veuillez en copier le contenu (à l'aide de ce super générateur) et travailler ailleurs."
			exit -1
		fi
	done
	chemin=""
fi

: ' Test du paramètre <nomProjet> : '
echo -e "> Lecture du nom du projet\n"
if ( test $( echo "$nomProjet" | grep "[^a-zA-Z0-9_\-]" ) ) then
	aide ${codeErr["param"]} $LINENO "<nomProjet>" "$1" "Le paramètre \$$indiceParam ne devrait pas contenir d'extension pour le projet." -h "nomProjet"
fi

: ' Test du paramètre <language> : '
echo -e "> Lecture du language du projet\n"
if ( test $# -ge 1 ) ; then
	language=`echo "$1" | cut -d: -f1`
	for lang in ${lstLanguage[*]} ; do
		if ( test "$language" = "$lang" ) ; then
			languageOpt="1"
			break
		fi
	done
	if ( test $languageOpt -eq 1 ) ; then
		languageOpt=`echo "$1" | cut -d: -f2-`
	else
		aide ${codeErr["param"]} $LINENO "<language>" "$1" "Le paramètre \$$indiceParam ne contient pas un language connue." -h "language"
	fi
	if ( test "$languageOpt" = "$language" ) ; then
		languageOpt=""
	fi
fi
shift ; indiceParam=`expr $indiceParam + 1`

: ' Test des paramètres commun à tous les générateurs de projets : '
while ( test $# -ne 0 ) ; do
	case "$1" in
		"-a") #Test des paramètres optionnels informant sur le ou les auteurs du documents. :
			echo -e "> Lecture des auteurs du projet\n"
			shift ; indiceParam=`expr $indiceParam + 1`
			if ( test $# -lt 2 ) then
				aide ${codeErr["param"]} $LINENO "-a <auteur> a-" "-a $*" "-a doit être suivit par au moins 1 <auteur> et ce finir par a-." -h "auteur"
			fi
			if ( test "$premierAuteur" = "" ) ; then
				premierAuteur="$1"
				shift ; indiceParam=`expr $indiceParam + 1`
			fi
			while ( test $# -ne 0 -a "$1" != "a-" ) ; do
				if ( test "$lstAuteur" = "" ) ; then
					lstAuteur="$1"
				else
					lstAuteur="$lstAuteur ; $1"
				fi
				shift ; indiceParam=`expr $indiceParam + 1`
			done
			if ( test $# -eq 0 ) ; then
				aide ${codeErr["param"]} $LINENO "-a <auteur> a-" "a-" "-a doit ce finir par a-." -h "auteur"
			fi
			;;
		"-d") #Test du paramètre optionnel <description> :
			echo -e "> Lecture de la description du projet\n"
			shift ; indiceParam=`expr $indiceParam + 1`
			if ( test -z "$description" ) then
				description="$1"
			else
				aide ${codeErr["param"]} $LINENO "<description>" "$1" "La description à déjà était renseigné." -h "description"
			fi
			;;
		"-s"|"-l") # Test du paramètre optionnel <lien> :
			echo -e "> Lecture d'un lien sur le projet\n"
			typeLien="$1"
			shift ; indiceParam=`expr $indiceParam + 1`
			# Obtenir le nom du lien
			nouv_lien="$1"
			if ( test -d "$nouv_lien" ) ; then # Si le lien indiquer existe
				nouv_lien="$(realpath "$nouv_lien")/$nomProjet"
			fi
			# Vérifier si le lien existe
			testFichier "-e" "nouv_lien" ; retour=$?
			if ( test $retour -eq 0 ) ; then # ok
				if ( test "$typeLien" = "-s" ) then
					nouv_lien="s:$nouv_lien"
				else
					nouv_lien="l:$nouv_lien"
				fi
				lstLiens=( ${lstLiens[*]} "$nouv_lien" )
			elif ( test $retour -eq 1 ) ; then # abandon
				echo "Abandon de la création du lien"
			else # err
				echo "ERREUR sur le test de l'existence d'un fichier nommée '$nouv_lien'."
				exit -1
			fi
			;;
		*) # Obtention de la liste des paramètres du script
			break
			;;
	esac
	shift ; indiceParam=`expr $indiceParam + 1`
done
if ( test -z "$description" ) then
	description="faireQuelqueChoseDeSuperUtileMaisJeNeSaisPasEncoreQuoi"
fi
if ( test -z "$premierAuteur" ) then
	premierAuteur="Erwan PECHON"
fi
if ( test -z "$lstAuteur" ) then
	lstAuteur="$premierAuteur"
else
	lstAuteur="$premierAuteur :: $lstAuteur"
fi

echo -e "> Fin de la lecture des paramètres commun d'un projet\n"
if ( test "$1" = "--" ) ; then
	shift ; indiceParam=`expr $indiceParam + 1`
fi
echo -e "> Accès au générateur spécialiser pour la création de ce type de projet\n"



# SCRIPT
# Accéder au dossier de modèle
eval "parametreur=\"$parametreur\""
eval "archiveModele=\"$archiveModele\""
# Créer le fichier de sauvegarde des tableau
export F_tab="$dossierModele/mesTableaux.sh"
rm -f $F_tab
touch $F_tab
# Sauvegarde des tableaux
declare -p codeErr >> $F_tab
declare -p balises >> $F_tab
declare -p lstLiens >> $F_tab
# Activation des script
chmod a+x $parametreur
# Création du projet
$parametreur "$@" ; retour=$?
echo -e "> Le générateur de projet spécialiser semble avoir fini de travailler\n"
if ( test $retour -ne 0 ) ; then
	echo "Une erreur est survenu durant le déroulement du script spécialiser pour un projet en $language."
	exit $retour
fi
# Désactivation des script
chmod 644 $questionneur
chmod 644 $parametreur


# SORTIE
cd $dossierActu
rm -f $F_tab
echo -e "\n\tFIN DU SCRIPT '$(basename "$0")'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #


