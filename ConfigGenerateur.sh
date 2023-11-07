#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 0.1
	* DATE : Sam. 23 Sept. 2023 16:19:42
	* Script qui configure le générateur de projet
'

ligneDossierModele="^dossierModele=\"\$dossierModele\"$" # Pattern permettant à sed de modifier le lien vers les dossier de modèle
dossierActu=`pwd` # Le dossier où se trouve actuellement l'utilisateur, pour ne pas le déplacer.
dossierConfig=`dirname $(realpath $0)` # Le dossier où ce trouve ce script
dossierModele="" # Le dossier où devront ce trouver les modèle de projet
dossierExistant=""
NouveauProjet_orig="Nouveau_projet.sh" # Le nom d'origine du script de création de projet
modele_orig="Modele_Projet" # Le nom d'origine du dossier de modele de projet
questionneur="$dossierConfig/$modele_orig/question.sh" # Le script permettant de pauser des question fermé à l'utilisateur

chmod a+x $questionneur # S'assurer que l'on puisse poser des question à l'utilisateur

: ' Demande un dossier à l utilisateur
	paramètre $1 : Le nom de la variable de retour.
	paramètre $2 : Que faut-il demandé à l utilisateur ?
	paramètre $3 : Le nom de l objet par défault.
	paramètre $4 : "-d" Si l on demande un dossier
	return 0 si tout c est bien passé ; 1 si abandon -1 si erreur
	'
demandeDossier() {
	objet=""
	while ( test "$objet" = "" ) ; do
		: ' Demandé le chemin '
		echo -n "Dans quel dossier peut-on trouver $2 (nomDef=$3) ? (a=abandon,*=[[.|..|~]/]path/to/dir[/nom]) : "
		read reponse
		if ( test "$reponse" == "a" ) then
			echo ">Abandon."
			return 1
		fi

		: ' Obtenir le chemin absolue vers le dossier demandé '
		reponse=`echo "$reponse" | sed "s/^ *//g"`
		if ( test "$( echo "$reponse" | cut -c1 )" = "~" ) ; then # Si relatif par rapport au HOME de l'utilisateur
			reponse="$HOME$( echo "$reponse" | cut -c2- )"
		elif ( test "$( echo "$reponse" | cut -c1 )" != "/" ) ; then # Si relatif par rapport au dossier actuel
			reponse="$dossierActu/$reponse"
		fi
		reponse=`echo "$reponse" | sed "s/\/\.\//\//g"` # Supprimer tout les '/./' de la réponse.
		reponse=`echo "$reponse" | sed "s/\/\.$/\//g"` # Supprimer tout les '/./' de la réponse.
		reponse=`echo "$reponse" | sed "s/\/[^/]*\/\.\.\//\//g"` # Supprimer tout les '/[^/]*/..' de la réponse.
		reponse=`echo "$reponse" | sed "s/\/[^/]*\/\.\.$/\//g"` # Supprimer tout les '/[^/]*/../' de la réponse.
		reponse=`echo "$reponse" | sed 's#/\+$##'` # Supprimer tout les '/' à la fin de la réponse.

		if ( test "$reponse" = "$dossierConfig" ) ; then
			echo "> Merci de ne pas modifier le repository de github."
			echo "> Veuillez en copier le contenu (à l'aide de ce super configurateur) et le personnaliser de manière isolé."
		else
			: ' Séparer le nom de l objet de son chemin '
			nomObjet=`basename "$reponse"`
			cheminObjet=`dirname "$reponse"`

			: ' Obtenir le chemin vers l objet demandé '
			objet=""
			go="go"
			for F in `echo "$cheminObjet" | tr "/" " "` ; do
				objet="$objet/$F"
				# Vérifier si l'on ne passe pas par le dépôt github
				if ( test "$objet" = "$dossierConfig" ) ; then
					echo "> Merci de ne pas modifier le repository de github."
					echo "> Veuillez en copier le contenu (à l'aide de ce super configurateur) et le personnaliser de manière isolé."
					objet=""
					break
				fi
				# Vérifier si tout les membres du chemin existe :
				if ( test "$dossierExistant" = "$objet" ) ; then
					go=""
				elif ( test "$dossierModele" = "$objet" ) ; then
					echo "> Merci de ne pas mettre le générateur de projet dans le dossier des modèles."
					objet=""
					break
				elif ( ! test -e "$objet" -o "$go" = "" ) ; then
					echo "> Le dossier '$objet' n'existe pas."
					echo "> Par conséquent, les dossier fils allant jusqu'à '$reponse' n'existe pas."
					$questionneur :o "Voulez-vous les créer" "annuler" ; retour=$?
					if ( test $retour -eq 0 ) ; then # annuler
						objet=""
						echo "> Annuler."
						break;
					elif ( test $retour -eq 1 ) ; then # oui
						dossierExistant="$objet"
						objet="$cheminObjet"
						break
					else # err
						echo "! ERROR sur la question"
						return -1
					fi
				fi
				# Vérifier si tout les memebres du chemin sont des dossiers
				if ( ! test -d "$objet" -o "$go" = "$go" ) ; then
					echo "> Le fichier '$objet' existe, mais il n'est pas un dossier."
					echo "> Par conséquent, les dossier fils allant jusqu'à '$reponse' n'existe pas."
					$questionneur :o "Voulez-vous l'ÉCRASER" "annuler" ; retour=$?
					if ( test $retour -eq 0 ) ; then # annuler
						objet=""
						echo "> Annuler."
						break;
					elif ( test $retour -eq 1 ) ; then # oui
						dossierExistant="$objet"
						objet="$cheminObjet"
						break
					else # err
						echo "! ERROR sur la question"
						return -1
					fi
				fi
			done

			: ' Vérifié si l objet demandé existe '
			if ( test "$dossierExistant" = "$objet/$nomObjet" ) ; then
				go=""
			fi
			if ( test "$objet/$nomObjet" = "$dossierModele" ) ; then
				echo "> Merci de ne pas mettre le générateur de projet dans le dossier des modèles."
				objet=""
			elif ( test "$objet" != "" ) ; then
				objet="$objet/$nomObjet"
				if ( test -e "$objet" -o "$go" = "" ) ; then
					if ( test -d "$objet" -o "$go" = "" ) ; then
						ajouter=1
						if ( test "$4" = "-d" ) ; then
							ajouter=0
							echo "> Un dossier '$objet' existe déjà."
							$questionneur -P "e=ecrase" ">ecraser" -P "a=ajoute" ">ajouter" "Voulez-vous ajouter le dossier de modèle à l'intérieur ou l'écraser" "annuler" ; retour=$?
							if ( test $retour -eq 0 ) ; then # annuler
								objet=""
								echo "> Annuler."
							elif ( test $retour -eq 2 ) ; then # ajouter
								ajouter=1
							elif ( test $retour -ne 1 ) ; then # err
								echo "! ERROR sur la question"
								return -1
							fi
						fi
						if ( test $ajouter -eq 1 ) ; then
							objet="$objet/$3"
							if ( test -e "$objet" ) ; then
								echo "> Un objet '$objet' existe déjà."
								$questionneur -P "e=ecrase" ">ecraser" "Voulez-vous ÉCRASER l'objet" "annuler" ; retour=$?
								if ( test $retour -eq 0 ) ; then # annuler
									objet=""
									echo "> Annuler."
								elif ( test $retour -ne 1 ) ; then # err
									echo "! ERROR sur la question"
									return -1
								fi
							fi
						fi
					else
						echo "> Le nom '$objet' est déjà pris."
						$questionneur :o "Voulez-vous l'ÉCRASER" "annuler" ; retour=$?
						if ( test $retour -eq 0 ) ; then # abandon
							objet=""
							echo "> Annuler."
						elif ( test $retour -ne 1 ) ; then # err
							echo "! ERROR sur la question"
							return -1
						fi
					fi
				fi
			fi
		fi
		echo ""
	done

	: ' Valider la reception de la réponse '
	eval "$1=\"$objet\""
	echo -e "\n=============================="
	return 0
}

: ' Crée le chemin vers le fichier donnée
	paramètre $1 : Le fichier à créer
	return 0 si tout c est bien passé ; -1 si erreur
	'
creationChemin() {
	chemin=""
	creation=0
	for F in $(dirname "$1" | tr "/" " ") ; do
		chemin="$chemin/$F"
		if ( ! test -d "$chemin" ) ; then
			if ( test $creation -eq 0 ) ; then
				echo -n "Création : '$F"
				creation=1
			else
				echo -n "/$F"
			fi
			mkdir "$chemin"
		fi
		if ( ! test -d "$chemin" ) ; then
			echo "Une erreur c'est produite pendant la création du dossier '$chemin'."
			exit -1
		fi
	done
	if ( test $creation -ne 0 ) ; then
		echo "'."
	fi
	if ( test -e "$1" ) ; then
		rm -rf $1
	fi
}


# CHERCHER L'ENDROIT OÙ IMPLANTER LES MODÈLE DE PROJET
dossierModele=""
demandeDossier "dossierModele" "le dossier contenant les modèles de projets" "$modele_orig" "-d" ; retour=$?
if ( test $retour -ne 0 ) ; then
	exit $?
fi
echo -e "Le dossier contenant les modèle de projet est donc '$dossierModele'.\n"

NouveauProjet=""
demandeDossier "NouveauProjet" "le script de génération de projet" "$NouveauProjet_orig" ; retour=$?
if ( test $retour -ne 0 ) ; then
	exit $?
fi
echo -e "Liage du script de génération de projet '$NouveauProjet' et du dossier contenant les modèle de projet '$dossierModele'.\n"


# OBTENIR LE NOM DE L'AUTEUR PAR DÉFAULT
echo -n "Qu'elle est le nom de l'auteur par défault ? : "
read auteurDefault
echo -e "Bonjour '$auteurDefault'.\n"


# VALIDER LES INFORMATIONS
echo -e "\n\nConfigurer le générateur de projet avec les paramètres suivant :"
echo -e "\t- Créer le dossier Modèle : $dossierModele"
echo -e "\t- Créer le script de génération : $NouveauProjet"
echo -e "\t- Auteur par défault : $auteurDefault"
$questionneur :v "Est-ce que ces paramètre de configuration vous conviennent" "abandonner" ; retour=$?
if ( test $retour -eq 0 ) ; then # abandon
	echo "Abandonner"
	exit 0
elif ( test $retour -eq 1 ) ; then # v
	echo -e "Début de la configuration du générateur.\n"
else # erreur
	echo "ERROR sur la question"
	exit -1
fi

# CONFIGURÉ UN NOUVEAU MODÈLE DE PROJET
#	# Créer le chemin vers les modèles de projet à configurer
creationChemin $dossierModele
#	# Copié le dossier modéle vers les modèles à configurer
echo -e "> Installation du dossier contenant tout les modèles de projet.\n"
cp -r $dossierConfig/$modele_orig $dossierModele

#	# Créer le chemin vers le script de génération de projet
creationChemin $NouveauProjet
#	# Copié le modéle vers le script à configurer
echo -e "> Installation du générateur de projet.\n"
cp -r $dossierConfig/$NouveauProjet_orig $NouveauProjet

#	# Modifié les fichier de tous les sous modèles en accord avec les paramètres précédent
#	#	# Modifié l'auteur par défault
echo -e "> Modification des fichier de création d'objet (pour les modèle d'architecture)\n"
for F in `ls $dossierModele/type_*/*/Nouveau_objet.sh` ; do
	chmod a+x $F
	sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $F
done
#	# Modifié le script de création de projet
echo -e "> Modification du générateur de projet\n"
#	#	# Modifié l'emplacement du modèle de projet qui lui est associé
sed -i -e "s/^\(export dossierModele=\)\"\$dossierModele\"/\1\"$( echo "$dossierModele" | sed "s/\//\\\\\//g" )\"/g" $NouveauProjet
#	#	# Modifié l'auteur par défault
sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $NouveauProjet

# Comprésser les modèles
echo "> Rangement des modèles de projet"
for lang in `ls $dossierModele | grep -E "^type_" | cut -d_ -f2- | cut -d. -f1` ; do
	echo -e "\t- Rangement des modèle de '$lang'."
	tar -czf $dossierModele/type_$lang.tar.gz -C $dossierModele/type_$lang .
	rm -rf $dossierModele/type_$lang
done
echo ""


chmod a+x $NouveauProjet
echo "Fin de la configuration"


