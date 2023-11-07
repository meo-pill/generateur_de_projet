#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 1.0
	* DATE : Dim.  5 Nov. 2023 13:17:33 CET
	*
	* Script qui sert à générer de nouveaux objet dans le projet.
	* Pour cela, il cree les fichier qui déclarent, définissent et testent un objet.
	*
	* Pour l objet A, ce script générera les fichiers suivant :
	* - ./include/A.$ext_H
	* - ./src/A.$ext_H  ===> ./objet/A.o (Compiler par le Makefile)
	* - ./test/A.$ext_H ===> ./bin/test_A.out (Compiler par le Makefile)
	*
'



# CRÉATION DES VARIABLES GLOBALES
#	# Localisation
dossierActu=`pwd`
dossierProjet=`dirname "$(realpath "$0")"`
dossierModele=".Modele"

#	#	# Fichiers à créer
declare -A dossier
declare -A fichier
declare -A extension
declare -A prefixe
cle="Inc"
dossier["$cle"]="include"
fichier["$cle"]=""
extension["$cle"]="h"
cle="Src"
dossier["$cle"]="src"
fichier["$cle"]=""
extension["$cle"]="c"
cle="Test"
dossier["$cle"]="test"
fichier["$cle"]=""
extension["$cle"]="c"
prefixe["$cle"]="test_"
cle=""

#	# Gestion des paramètres
indiceParam=1
nbParam_min=1

#	# Gestion des erreurs
declare -A codeErr
codeErr["nbParam"]=1
codeErr["param"]=2

#	# Info sur le nouvelle objet
#	#	# Nom de l'objet
nomObjet=""
#	#	# Contributeur en charge du dévellopement de l'objet
premierAuteur="" # Résponsable
lstAuteur="" # premierAuteur :: auteur2 ; auteur3 ; ... ; auteurN
#	#	# Autres infos sur le projet
description="" # Le projet sert à $description
dateCreation=`date +"%a %e %b %Y %H:%M:%S %Z" | sed 's/\<[a-z]/\U&/g'`
#	#	# Fichiers à créer

#	# Qu'elle balises à remplacer dans les fichiers ?
declare -A balises
balises["nomF"]="~~FICHIER~~" # Nom du fichier
balises["nomObjet"]="~~OBJET~~" # Nom de l'objet (première lettre en majuscule)
balises["nomVar"]="~~VAROBJET~~" # Nom de la variable (nom de l'objet, mais commençant par une minuscule)
balises["nomDef"]="~~NOMDEF~~" # Nom de l'objet, mais entierement en majuscule
balises["premierAuteur"]="~~CHEF~~" # Première auteur
balises["lstAuteur"]="~~AUTEURS~~" # PremierAuteur :: auteur2 ; auteur3 ; ... ; auteurN
balises["dateCreation"]="~~DATE~~" # Date de création
balises["description"]="~~DESCR~~" # L'objet sert à $description

#	# Autres



# AIDE UTILISATION
strParam="<nomObjet> [{ -a <auteur> [<auteur>]... a- | -d <description> }]..."
declare -A detail
# Paramètre $1
detail["nomObjet"]="Le nom de l'objet."
# Paramètre 'auteur'
detail["%-a"]="Déclare le début d'une liste d'auteur à ajouter au auteurs déjà mentionner (si il y en à déjà eu)."
detail["auteur"]="L'un des auteurs qui vont participé à l'édition des fichier déclarant, définissent et testant le nouvelle objet."
detail["%a-"]="Déclare la fin d'une liste d'auteur."
# Paramètre 'définition
detail["%-d"]="Annonce la définition de la description."
detail["description"]="Compléter la phrase 'Le projet sert à <description>'."
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

: ' Remplace une balise d un fichier du nouveau projet par un texte donnée.
	paramètre $1 : Le nom de la balise à remplacer par le contenu de la variable éponyme.
	paramètre $2 : La clé du fichier à modifier
	pramètre $3 : Si "/", modifie la chaine à insérer pour que sed marche, malgès la présence de caractère "/".
	pramètre $3 : Si "d", supprime les lignes possédant la balise.
	return -1 en cas d erreur, 1 autrement.
	'
modifie() {
	text=$(eval "echo \"\$$1\"")
	if ( test $# -lt 2 ) ; then
		echo "La fonction 'modifie' prend au moins 2 paramètre :"
		echo -e "\t> \$1 : Que faut-il modifier ?"
		echo -e "\t> \$2 : Quel fichier faut-il modifier ?"
		exit -1
	elif ( test $# -eq 3 ) ; then
		if ( test "$3" = "d" ) ; then
			text="\d"
		else
			text=`echo "$text" | sed "s/\//\\\\\\\\\//g"`
		fi
	elif ( test $# -gt 3 ) ; then
		echo "La fonction 'modifie' prend au plus 3 paramètre :"
		echo -e "\t> \$1 : Que faut-il modifier ?"
		echo -e "\t> \$2 : Quel fichier faut-il modifier ?"
		echo -e "\t> \$3 : Option de modification (/,d)"
		exit -1
	fi
	Fichier="$dossierProjet/${dossier["$2"]}/${prefixe["$2"]}$nomF.${extension["$2"]}"
	if ( test "$text" = "\d" ) ; then
		sed -i -e "$( grep -n "${balises["$1"]}" $Fichier | cut -d: -f1 )d" $Fichier
	else
		sed -i -e "s/${balises["$1"]}/$text/g" $Fichier
	fi
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
if ( test $# -lt $nbParam_min ) ; then
	aide ${codeErr["nbParam"]} $LINENO "Au moins $nbParam_min paramètres attendu" $#
fi

#	# Bon type de paramètre ? #
 : ' Test du paramètre <nomObjet> : '
echo -e "> Lecture du nom de l'objet\n"
if ( test $( echo "$1" | grep -v "^[[:upper:]]" ) ) then
	echo "Erreur sur le paramètre <nomObjet> ($1)."
	echo "Le paramètre <nomObjet> devrait commencé par une lettre majuscule."
	echo -e "$Usage\n$Detail_nomObjet"
	exit 2
fi
if ( test $( echo "$1" | grep "[^a-zA-Z0-9_]" ) ) then
	echo "Erreur sur le paramètre <nomObjet> ($1)."
	echo "Le paramètre <nomObjet> contient des caractère interdit pour un nom de classe."
	echo -e "$Usage\n$Detail_nomObjet"
	exit 2
fi
nomObjet="$1"
shift ; indiceParam=`expr $indiceParam + 1`

 : ' Test des autres paramètres : '
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
		*)
			aide ${codeErr["param"]} $LINENO "paramètre inconnue" "$1" "Je ne sais pas comment traiter le paramètre n°$indiceParam."
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



# SCRIPT
#	# Créer les 3 fichiers de l'objet
#	#	# Vérifier que le nom des fichiers soit disponibles
nom="$nomObjet"
nomF="$nom"
i=2
modifie=1
while ( test $modifie -ne 0 ) ; do
	modifie=0
	for cle in ${!dossier[*]} ; do
		ext=${extension["$cle"]}
		rep=${dossier["$cle"]}
		pre=${prefixe["$cle"]}
		F="$dossierProjet/$rep/$pre_$nomF.$ext"
		while ( test -e "$F" ) ; do
			nom2="$nom"_"$i"
			modifie=1
			echo "Le fichier '$F' existe déjà, que voulez-vous faire ?"
			echo -e "\t1) L'écraser"
			echo -e "\t2) Changer le nom du fichier pour '$nom2.$ext'"
			echo -e "\t3) Changer le nom du fichier"
			echo -e "\t4) Abandonner"
			echo -n "Choix : "
			read choix
			case "$choix" in
				1)
					echo -n "rm : supprimer '$F' ?(oOyY=oui,*=non) : "
					read retour
					case $(echo "$retour" | tr "[[:upper:]]" "[[:lower:]]") in
						"o"|"y"|"oui"|"yes")
							modifie=2
							;;
						*)
							echo "> Annuler suppression"
							modifie=0
							;;
					esac
					;;
				2)
					nomF="$nom2"
					i=`expr $i + 1`
					;;
				3) nouveauNom=""
					while ( test "$nouveauNom" = "" ) ; do
						echo -n "Entrer le nouveau nom du fichier (:a=annuler,*=nom) : "
						read nouveauNom
						if ( test "$nouveauNom" = ":a" ) ; then
							nouveauNom=""
							echo "> Annuler"
							modifie=0
							break
						elif ( test $( echo "$nouveauNom" | grep -v "^[[:upper:]]" ) ) then
							nouveauNom=""
							echo "Erreur sur le nouveau nom ($nouveauNom)."
							echo "Le nouveau nom devrait commencé par une lettre majuscule."
						elif ( test $( echo "$nouveauNom" | grep "[^a-zA-Z0-9_]" ) ) then
							nouveauNom=""
							echo "Erreur sur le nouveau nom ($nouveauNom)."
							echo "Le nouveau nom contient des caractère interdit pour un nom de classe."
						fi
					done
					if ( test "$nouveauNom" != "" ) ; then
						nom="$nouveauNom"
						nomF="$nom"
						i=2
					fi
					;;
				4)
					echo "> Abandon de la création du fichier"
					modifie=0
					exit 0
					;;
				*)
					echo "Je ne connais pas cette possibilité ($choix)"
					modifie=0
					;;
			esac
			if ( test $modifie -eq 1 ) ; then
				F="$dossierProjet/$rep/$pre$nomF.$ext"
			elif ( test $modifie -eq 2 ) ; then
				break
			fi
		done
		if ( test $modifie -eq 1 ) then
			break
		fi
	done
done

#	#	# Demandé à l'utilisateur de valider la création des fichiers
echo -e "\n\nCréer un nouvelle objet avec les informations suivantes ? :"
echo -e "\t> nom de l'objet   = "
echo -e "\t> nom des fichiers = "
echo -e "\t> lstAuteur  = $lstAuteur"
echo -e "\t> L'objet servira à $description."
echo -n "Valider la création de l'objet ?(oOyY=oui,*=non) : "
read choix
case $(echo "$choix" | tr "[[:upper:]]" "[[:lower:]]") in
	"o"|"y"|"oui"|"yes") : ;;
	*)
		echo "> Abandon"
		exit 0
		;;
esac

#	#	# Création des variables manquantee
nomVar=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~VAROBJET~~

nomDef=`echo "$nomObjet" | sed "s/^\(.\)/\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/_\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | sed "s/\([A-Z]\)/_\l\1/"` # ==> ~~NOMDEF~~
nomDef=`echo "$nomDef" | tr "[a-z]" "[A-Z]"` # ==> ~~NOMDEF~~


#	#	# Créer les trois fichiers
for cle in ${!fichier[*]} ; do
	F="$dossierProjet/${dossier["$cle"]}/${prefixe["$cle"]}$nomF.${extension["$cle"]}"
	fichier["cle"]=$F
	if ( test -e $F ) ; then
		rm -f $F
	fi
	if ( test -e $F ) ; then
		echo "Erreur lors de la suppression de l'ancien fichier $F."
	fi
	cp $dossierProjet/$dossierModele/${dossier["$cle"]}.${extension["$cle"]} $F
	if ( ! test -e $F ) ; then
		echo "Erreur lors de la création du fichier $F."
	fi

	# Remplacer les balises
	modifie "nomF" $cle
	modifie "nomObjet" $cle
	modifie "nomVar" $cle
	modifie "lstAuteur" $cle
	modifie "dateCreation" $cle
	modifie "description" $cle
done
modifie "nomDef" Inc



# SORTIE
echo -e "\n"
ls -R $dossierProjet
echo -e "\n"
cd $dossierActu
echo -e "\n\tFIN DU PARAMETRAGE DU SCRIPT '$(basename "$nomObjet")'."
exit 0


# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #


