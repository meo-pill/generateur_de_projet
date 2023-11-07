: ' Test du paramètre <~~NOM_PARAM~~> : '
~~NOM_PARAM~~=""
if ( test $# -ge 1 -a "$1" COND_PARAM_FAUX ) then
	aide ${codeErr["param"]} $LINENO "<~~NOM_PARAM~~>" "$1" "RAISON_ERR" -h "~~NOM_PARAM~~"
fi
shift ; indiceParam=`expr $indiceParam + 1`

