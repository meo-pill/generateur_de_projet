#!/bin/bash
: '
	* AUTEUR : Erwan PECHON
	* VERSION : 1.0
	* DATE : lun. 30 oct.(10) 2023 18:22:46 ECT
	* Script qui Paramètre le projet à sa création.
'

if ( test "$dossierModele" = "" ) ; then # Définit si générateur paramètrer.
	echo "> La variable \$dossierModele n'est pas définit. Veuillez appeler le script $0 depuis le script Nouveau_projet.sh, afin de bien définir toutes les variables qui en dépendent."
	exit 12
fi

# CRÉATION DES VARIABLES GLOBALES
source $F_tab
#	# Autres
extension=sh
modele="script.$extension"
testTypeParam=": ' Test du paramètre <~~NOM_PARAM~~> : '"
testTypeParam="$testTypeParam\n~~NOM_PARAM~~="
testTypeParam="$testTypeParam\nif ( test \$# -ge 1 -a \"\$1\" COND_PARAM_FAUX ) then"
testTypeParam="$testTypeParam\n\taide \${codeErr[\"param\"]} \$LINENO \"<~~NOM_PARAM~~>\" \"\$1\" \"RAISON_ERR\" -h \"~~NOM_PARAM~~\""
testTypeParam="$testTypeParam\nfi"
testTypeParam="$testTypeParam\nshift ; indiceParam=\`expr \$indiceParam + 1\`"
testTypeParam="$testTypeParam\n"

#	# Gestion des paramètres
nbParam_min=0
strParam="[<parametreDuScript>]..."
declare -A detail
detail["parametreDuScript"]="Le nom d'un paramètre, '[' , ']' , '...' , '{' ou '}' avec :"
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t> nom d'un paramètre : composé de lettre majuscule(A-Z) ou minuscule(a-z) et de souligné(_) uniquement."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t> '[',']' : Encadre un groupe de paramètres optionnels([-d])."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t> '{','}' : Encadre un groupe de choix({a|b})."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t> '...' : Permet la répétition du paramètre précédent."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t> '^?[<=>]?nomParam' : Indique l'existence du paramètre 'nomParam' et définit son comportement."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t\t| '^...' : Place un paramètre au contenu fixe."
detail["parametreDuScript"]="${detail["parametreDuScript"]}\n\t\t\t| '^?[<=>]...' : Lie le paramètre avec la variable à gauche (<,=) ou à droite (=,>)."


# CRÉATION(S) DE(S) FONCTION(S)
source $dossierModele/fonction_creation_projet.sh

# VÉRIFIÉ LES PARAMÉTRES (Renvoyer 1 en cas d'erreur)
#	# Bon type de paramètre ? #

: ' Test de la variable $languageOpt : '
if ( test "$languageOpt" = "" ) then
	language="bash"
else
	if ( test -e "/bin/$languageOpt" ) ; then
		language="$languageOpt"
	else
		aide ${codeErr["export"]} $LINENO "languageOpt" "un nom de Shell (ex:zsh)" "$languageOpt"
	fi
fi

: ' Tests sur les paramètres : '
strLstParam=""
lstParam=()
gr_option=0
gr_choix=0
nbParam_max=$#
nbParam_min=$#
rep=0
o="--"
while ( test $# -ne 0 ) ; do
	case $1 in
		"[")
			if ( test $gr_option -eq 1 ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Déjà dans un groupe optionnel." -h "parametreDuScript"
			fi
			gr_option=1
			nbParam_max=`expr $nbParam_max - 1`
			nbParam_min=`expr $nbParam_min - 1`
			;;
		"]")
			if ( test $gr_option -eq 0 ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Pas encore dans un groupe optionnel." -h "parametreDuScript"
			fi
			gr_option=0
			nbParam_max=`expr $nbParam_max - 1`
			nbParam_min=`expr $nbParam_min - 1`
			;;
		"{")
			if ( test $gr_choix -ne 0 ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Déjà dans un groupe de choix." -h "parametreDuScript"
			fi
			if ( test $gr_option -eq 1 ) ; then
				gr_choix=2
				gr_option=0
				strLstParam="$strLstParam [{"
			else
				gr_choix=1
				strLstParam="$strLstParam {"
			fi
			;;
		"}")
			gr_option=0
			strLstParam="${strLstParam%?}"
			if ( test $gr_choix -eq 0 ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Pas encore dans un groupe de choix." -h "parametreDuScript"
			elif ( test $gr_choix -eq 2 ) ; then
				gr_option=1
				gr_choix=0
				strLstParam="$strLstParam }]"
			else
				gr_choix=0
				strLstParam="$strLstParam }"
			fi
			gr_choix=0
			nbParam_max=`expr $nbParam_max - 1`
			nbParam_min=`expr $nbParam_min - 1`
			;;
		"...")
			if ( test $rep -lt 1 ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Pas encore d'option à répéter." -h "parametreDuScript"
			fi
			nbParam_max=-1
			strLstParam="$strLstParam..."
			nbParam_min=`expr $nbParam_min - 1`
			;;
		*)
			if ( test "$1" = "" ) ; then
				echo "> Comande actuelle : $nomProjet.extension $strLstParam"
				aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Le nom d'un paramètre ne peut pas être vide." -h "parametreDuScript"
			fi
			# Faudra-t-il encadrer le nom du paramètre ?
			symb=`echo "$1" | cut -c1`
			enc=1
			if ( test "$symb" = "^" ) ; then
				nomParam=`echo "$1" | cut -c2-`
				symb=`echo "$nomParam" | cut -c1`
				enc=0
			else
				nomParam="$1"
			fi
			# Faudra-t-il lier paramètre à celui de gauche ? de droite ? les deux ?
			case $symb in
				">"|"<"|"=") nomParam=`echo "$nomParam" | cut -c2-` ;;
			esac
			# Faut-t-il encadrer le nom du paramètre ?
			if ( test $enc -eq 1 ) ; then
				if ( test `echo "$nomParam" | grep "[^a-zA-Z0-9_]"` ) ; then
					echo "> Comande actuelle : $nomProjet.extension $strLstParam"
					aide ${codeErr["param"]} $LINENO "parametreDuScript" "...$o $1 $2..." "Le nom d'un paramètre ne peut contenir que des lettres, des chiffres et des underscore." -h "parametreDuScript"
				fi
				lstParam=( ${lstParam[*]} $nomParam )
				nomParam="<$nomParam>"
			else
				nomParam="$nomParam"
			fi
			# Le paramètre fait-il partie d'un groupe optionnel ?
			if ( test $gr_option -eq 1 ) ; then
				case $symb in
					">") nomParam="[$nomParam" ;;
					"<") nomParam="$nomParam]" ;;
					"=") nomParam="$nomParam" ;;
					*) nomParam="[$nomParam]" ;;
				esac
				if ( test $gr_choix -eq 0 ) ; then
					nbParam_min=`expr $nbParam_min - 1`
				fi
			fi
			# Le paramètre fait-il partie d'un groupe de choix ?
			if ( test $gr_choix -ne 0 ) ; then
				case $symb in
					"="|">") nomParam="$nomParam" ;;
					*)
						nomParam="$nomParam |"
						nb_gr_choix=0
						;;
				esac
				nbParam_min=`expr $nbParam_min - 1`
				nbParam_max=`expr $nbParam_max - 1`
			fi
			# Ajouter le nom du paramètre
			strLstParam="$strLstParam $nomParam"
			;;
	esac
	o=$1
	shift ; indiceParam=`expr $indiceParam + 1`
	rep=`expr $rep + 1`
done

# SCRIPT
autres_verif="\t> Liste des noms de paramètres :"
if ( test ${#lstParam[*]} -ne 0 ) ; then
	autres_verif="$autres_verif <$( echo "${lstParam[*]}" | sed "s/ /> </g" )>"
fi
autres_verif="$autres_verif\n\t> Utilisation : $emplacementProjet/$nomProjet.$extension $strLstParam"
source $dossierModele/verifier_creation_projet.sh

#	# Modification du fichier de script du projet à paramètrer.
sed -i -e "s/^\(strParam=\)\"\$strParam\"/\1\"$strLstParam\"/g" $emplacementProjet/$F_projet
: ' Modification des balises basiques '
for balise in ${!balises[*]} ; do
	modifie $balise $F_projet
done


: ' Modification des balises PARAM '
balise="~~PARAM~~"
: '	Modification des variables de PARAM	'
text=""
if ( test $nbParam_min -eq $nbParam_max ) then
	text="nbParam=$nbParam_min"
else
	text="nbParam_min=$nbParam_min"
	if ( test $nbParam_max -ge 0 ) then
		text="$text\nnbParam_max=$nbParam_max"
	fi
fi
sed -i -e "0,/$balise/s/$balise/$text/" $emplacementProjet/$F_projet

: '	Modification de la vérification du nombre de PARAM	'
text=""
ajAide="aide \${codeErr[\"nbParam\"]} \$LINENO"
if ( test $nbParam_min -eq $nbParam_max ) then
	explParam="\$nbParam paramètres attendu"
	text="if ( test \$# -ne \$nbParam ) ; then\n\t$ajAide \"$explParam\" \$#\nfi"
else
	explParam="Au moins \$nbParam_min paramètres attendu"
	text="if ( test \$# -lt \$nbParam_min ) ; then\n\t$ajAide \"$explParam\" \$#"
	if ( test $nbParam_max -ge 0 ) then
		explParam="Au plus \$nbParam_max paramètres attendu"
		text="$text\nelif ( test \$# -gt \$nbParam_max ) ; then\n\t$ajAide \"$explParam\" \$#"
	fi
	text="$text\nfi"
fi
sed -i -e "0,/$balise/s/$balise/$text/" $emplacementProjet/$F_projet

: '	Modification de la vérification du type de PARAM	'
for param in ${lstParam[*]} ; do
	numLigne=`grep -nE "^$balise$" $emplacementProjet/$F_projet | cut -d: -f1`
	numLigne=`expr $numLigne - 1`
	sed -i "$numLigne i\ $testTypeParam" $emplacementProjet/$F_projet
	sed -i "s/~~NOM_PARAM~~/$param/g" $emplacementProjet/$F_projet
	numLigne=`grep -nE "^detailAide=\"" $emplacementProjet/$F_projet | cut -d: -f1`
	sed -i "$numLigne,$numLigne i\detail[\"$param\"]=\"\"" $emplacementProjet/$F_projet
done
sed -i "/^$balise$/d" $emplacementProjet/$F_projet


# FIN du script
chmod a+x $emplacementProjet/$F_projet
FIN

# #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### #

