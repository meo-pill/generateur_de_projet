# Vérifier si un fichier existe à la place du projet
F_projet="$nomProjet"
testFichier "F_projet" "$emplacementProjet" "$extension" ; retour=$?
if ( test $retour -eq 1 ) ; then # abandon
	echo "> Abandon"
	exit 0
elif ( test $retour -ne 0 ) ; then # err
	echo "ERREUR sur le test de l'existence d'un fichier nommée '$F_projet'."
	exit -1
fi
if ( test "$extension" != "" ) ; then
	F_projet="$F_projet.$extension"
fi

# Vérifier si le modèle à copier existe
if ( ! test -e "$archiveModele" ) ; then
	echo "L'archive des modèles de projet '$archiveModele' n'existe pas."
	exit -2
fi

# Affichage des informations du projet
echo -e "\n\nCréer un nouveau projet avec les informations suivantes ? :"
echo -e "\t> Language.  = $language"
echo -e "\t> Emplacement= $emplacementProjet"
echo -e "\t> Nom  .  .  = $nomProjet"
echo -en "\t> Liens   .  = "
if ( test ${#lstLiens[*]} -ne 0 ) ; then
	echo -n "'$( echo "${lstLiens[*]}" | sed "s/ /' '/g" )'"
fi
echo ""
echo -e "\t> lstAuteur  = $lstAuteur"
echo -e "\t> Le projet servira à $description."
echo -e "$autres_verif"

# Demande de validation à l'utilisateur
$questionneur :v "Choix" "abandonner"
if ( test $? -eq 0 ) ; then
	echo "Abandon de la création du projet."
	exit 0
fi

# Création du projet
#	# Création du chemin vers le projet
chemin=""
for F in `echo "$emplacementProjet" | tr "/" " "` ; do
	chemin="$chemin/$F"
	# Vérifier si tout les membres du chemin sont des dossiers
	if ( ! test -d "$chemin" ) ; then
		if ( test -e "$chemin" ) ; then
			rm -fv --interactive=never $chemin
		fi
		mkdir $chemin
	fi
done
#	# Copie du modele vers le projet
tar -xvf $archiveModele -C $emplacementProjet ./$modele
mv $emplacementProjet/$modele $emplacementProjet/$F_projet
if ( ! test -e $emplacementProjet/$F_projet ) ; then
	echo "Impossible de créer le projet."
	exit -5
fi

#
# Projet créer
#


