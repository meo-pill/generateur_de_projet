======== : Variables exporté par 'export' : ========
13:export dossierModele="$dossierModele" # Où ce trouve les Modèles ?
14:export archiveModele="$dossierModele/type_\$language.tar.gz"
16:export questionneur="$dossierModele/question.sh"
20:export indiceParam=1
32:export language="<Le language dont on veut générer un projet>"
34:export languageOpt="" # Une option de language (ex:cls pour classe LaTeX)
35:export extension="<Veuillez redéfinir la variable '\$extension'.>"
37:export nomProjet=""
38:export emplacementProjet=""
41:export premierAuteur="" # Chef du projet
42:export lstAuteur="" # premierAuteur :: auteur2 ; auteur3 ; ... ; auteurN
44:export description="" # Le projet sert à $description
45:export dateCreation=`date +"%d %b %Y" | sed -e "s/^\(.\)/\U\1/" | sed -e "s/\(^[^ ]* [^ ]*\) \(.\)/\1 \U\2/"`
57:export autres_verif=">>>>>Veuillez personaliser la variable 'autres_verif'.<<<<<"
58:export modele="Veuillez le redéfinir avec le nom du modèle de projet (depuis l'archive \$archiveModele)"
272:export F_tab="$dossierModele/mesTableaux.sh"
======== : Tableaux stocké dans '$F_tab' : ========
276:declare -p codeErr >> $F_tab
	24:declare -A codeErr
	25:codeErr["nbParam"]=1
	26:codeErr["param"]=2
	27:codeErr["appel"]=3
	28:codeErr["export"]=4
277:declare -p balises >> $F_tab
	48:declare -A balises
	49:balises["nomProjet"]="~~PROJET~~"
	50:balises["lstAuteur"]="~~AUTEURS~~"
	51:balises["premierAuteur"]="~~CHEF~~"
	52:balises["description"]="~~DESCR~~"
	53:balises["dateCreation"]="~~DATE~~"
	54:balises["language"]="~~LANGUAGE~~"
278:declare -p lstLiens >> $F_tab
	39:lstLiens=()
======== : Fin de l\'exportation des var : ========
