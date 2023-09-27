#!/bin/bash
: '
	* AUTEUR : Erwan PECHON ; Mewen PUREN
	* VERSION : 0.1
	* DATE : Sam. 23 Sept. 2023 16:19:42
	* Script qui configure le générateur de projet
'

ligneDossierModele="^dossierModele=\"\$dossierModele\"$"

NouveauProjet=""
while ( test -z "$NouveauProjet" ) ; do
	echo -n "Où est le fichier de création de projet ?(q=annuler,.=dossierActu) : "
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
	fi
	if ( test $( grep "$ligneDossierModele" | wc -l ) -eq 0 ) then
		echo "Le fichier \"$NouveauProjet\" est déjà configuré."
		NouveauProjet=""
	fi
done


dossierModele=""
while ( test -z "$dossierModele" ) ; do
	echo -n "Où est le dossier contenant les modèle de projet ?(q=annuler,.=dossierActu) : "
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
		fi
	else
		echo -e "\tLe dossier \"$reponse\" n'existe pas."
	fi
done
sed -i -e "s/^dossierModele=\"\$dossierModele\"$/dossierModele=\"$( echo "$dossierModele" | sed "s/\//\\\\\//g" )\"/g" $NouveauProjet

echo -n "Qu'elle est le nom de l'auteur par défault ? : "
read auteurDefault
sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $NouveauProjet

for F in `ls $dossierModele/*/Nouveau_objet.sh` ; do
	chmod a+x $F
	sed -i -e "s/^premierAuteur=\"\$premierAuteur\"$/premierAuteur=\"$auteurDefault\"/g" $F
done

for F in `ls $dossierModele/*/Tester.sh` ; do
	chmod a+x $F
done

echo "Fin de la configuration"
