#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 0.1
	* DATE : Sam. 23 Sept. 2023 16:19:42
	* Script qui configure le générateur de projet
'

ligneDossierModele="^dossierModele=\"\$dossierModele\"$"
dossierActu=`pwd`
dossierConfig=`dirname $(realpath $0)`

dossierModele=""
while ( test -z "$dossierModele" ) ; do
	echo -n "Qu'elle est le dossier contenant les modèle de projet ?(q=annuler,.=dossierActu) : "
	read reponse
	if ( test "$reponse" == "q" ) then
		echo "Abandon."
		exit 0
	fi
	if ( test -d "$reponse" ) then
		if ( test -d "$reponse/type_C" ) then
			dossierModele=`realpath "$reponse"`
		else
			echo -e "\tLe dossier \"$reponse\" existe, mais ne contient pas de dossier de projet type (doit contenir au moins le dossier type de projet en C)."
   			exit 1
		fi
	else
		echo -e "\tLe dossier \"$reponse\" n'existe pas."
   		echo "Voulez-vous importer le dossier contenant les modèle de projet depuis github ?(oO=oui) : "
      		read reponse
      		if ( test "$reponse" == "o" -o  "$reponse" == "O" -o "$reponse" == "y" -o  "$reponse" == "Y" ) then
	 		if ( test -d "$dossierConfig/.git" -a -d "$dossierConfig/Modele_Projet" ) then
				if ( test -d "$dossierConfig/Modele_Projet" ) then
     					cp -r $dossierConfig/Modele_Projet $reponse
					dossierModele=`realpath "$reponse"`
     				else
					echo -e "\tLe dossier \"$dossierConfig/Modele_Projet\" existe, mais ne contient pas de dossier de projet type (Veuillez faire un 'git pull' pour le récupérer)."
     					exit 1
				fi
    			else
				echo -e "\tLe dossier \"$dossierConfig\" n'est pas rattaché au dépot github contenant les modèle de projet."
    				exit 1
       			fi
	  	else
    			echo "Impossible de continuer."
       			exit 1
	 	fi
	fi
done
echo -e "Le dossier contenant les modèle de projet est donc '$dossierModele'.\n"

NouveauProjet=""
while ( test -z "$NouveauProjet" ) ; do
	echo -n "Dans qu'elle dossier se trouve le fichier de création de projet ?(q=annuler,.=dossierActu) : "
	read reponse
	if ( test "$reponse" == "q" ) then
		echo "Abandon."
		exit 0
	fi
	reponse="$reponse/Nouveau_projet.sh"
	if ( test -e "$reponse" ) then
		NouveauProjet="$reponse"
	else
		echo -e "\tLe script \"$reponse\" n'existe pas."
  		exit 1
	fi
	if ( test $( grep "$ligneDossierModele" | wc -l ) -eq 0 ) then
		echo "Le fichier \"$NouveauProjet\" est déjà configuré."
		NouveauProjet=""
  		exit 1
	fi
done
echo -e "Liage du script de génération de projet '$NouveauProjet' et du dossier contenant les modèle de projet '$dossierModele'.\n"

echo -n "Qu'elle est le nom de l'auteur par défault ? : "
read auteurDefault
echo -e "Bonjour '$auteurDefault'.\n"

echo -n "Valider les informations renseigné jusque là et procéder à la configuration du générateur ?(oO=oui) : "
read reponse
if ( test "$reponse" != "o" -a "$reponse" != "O" -a "$reponse" != "y" -a "$reponse" != "Y" ) then
	echo "Abandon."
	exit 0
fi
echo -e "Début de la configuration du générateur.\n"

for F in `ls $dossierModele/*/Nouveau_objet.sh` ; do
	chmod a+x $F
	sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $F
done

for F in `ls $dossierModele/*/Tester.sh` ; do
	chmod a+x $F
done

sed -i -e "s/^dossierModele=\"\$dossierModele\"$/dossierModele=\"$( echo "$dossierModele" | sed "s/\//\\\\\//g" )\"/g" $NouveauProjet
sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $NouveauProjet

echo "Fin de la configuration"
