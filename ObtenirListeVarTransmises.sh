#!/bin/bash

if test "$1" = ""; then
	echo "Veuillez renseigné le nom du fichier à analyser en premier paramètre."
	exit 1
fi
if ! test "$1"; then
	echo "Le fichier à analyser n'existe pas."
	exit 1
fi

sep="========"
sep="eval \"echo \\\"$sep : \$textSep : $sep\\\"\""
reinitTextSep="textSep=\"texte du separateur à définir dans 'textSep'\""
eval "$reinitTextSep"
msgSep="$sep ; $reinitTextSep"

textSep="Variables exporté par 'export'"
eval "$msgSep"
grep -n "^export " "$1"

textSep="Tableaux stocké dans '\\\$F_tab'"
eval "$msgSep"
tab="$(grep -n "^declare -p .* >> \$F_tab$" "$1" | sed "s/F_tab/ F_tab/g" | sed "s/^\(.*\)$/\\\"\1\\\" /g")"
eval "tab=($tab)"
for ((i = 0; i < ${#tab[*]}; i++)); do
	ligne="${tab[$i]}"
	echo "$ligne" | sed "s/\$ F_tab/\$F_tab/g"
	var=$(echo "$ligne" | cut -d\  -f3)
	decl=$(grep -n "^declare -A $var$" "$1")
	if test "$decl" = ""; then
		grep -n "^$var=(.*)$" "$1" | sed "s/^/\t/g"
	else
		echo -e "\t$decl"
		grep -n "^$var\[.*\]=" "$1" | sed "s/^/\t/g"
	fi
done
tab=$(grep -n "^declare -p .* >> \$F_tab$" "$1")

textSep="Fin de l\'exportation des var"
eval "$msgSep"
