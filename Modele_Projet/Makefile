############# CRÉATION DES VARIABLES GLOBALES #############
# Options de compilation
include Makefile.compilation

default: help
.PHONY: default premierObj objet premierTest test prog all help clear clean mr_proper cleanDoxygen mr_properSuper laugth pull git doxygen testTESTtest

# Nom de fichiers
	# Programme final
PROGRAMME = bin/~~PROJET~~.$(EXT_EXEC)
	# Fichier objet
SOURCE = $(wildcard src/*.$(EXT_SRC)) $(wildcard src/*/*.$(EXT_SRC))
OBJET  = $(SOURCE:src/%.$(EXT_SRC)=obj/%.o)
	# Fichier test
SRCTEST= $(wildcard test/test_*.$(EXT_SRC))
OBJTEST= $(SRCTEST:test/test_%.$(EXT_SRC)=bin/test_%.$(EXT_EXEC))

# Autres




############### COMPILATION DES EXÉCUTABLES ###############
# Programme final
${PROGRAMME}: main.$(EXT_SRC) objet
	$(info ......................................)
	$(info Compilation du programme '$@' :)
	${CC} -o $@ $< ${OBJET} ${FLAGS} ${CLIB} ${LIB}

# Programme test
premierTest: objet
	$(info ......................................)
	$(info .....Compilation des fichier de tests :)
bin/test_commun.$(EXT_EXEC): test/commun.$(EXT_SRC) obj/commun.o
	$(info .)
	$(info Compilation du programme '$@' :)
	${CC} -o $@ $< obj/commun.o ${FLAGS} ${CLIB} ${LIB}
bin/test_%.$(EXT_EXEC): test/test_%.$(EXT_SRC) obj/%.o obj/commun.o $(OBJET)
	$(info .)
	$(info Compilation du programme '$@' :)
	${CC} -o $@ $< ${OBJET} ${FLAGS} ${CLIB} ${LIB}

# Objets
premierObj:
	$(info ......................................)
	$(info .....Compilation des fichiers objets :)
obj/%.o: src/%.$(EXT_SRC) include/%.$(EXT_LIB)
	$(info Compilation de l'objet '$@'.)
	@${CCOBJ} ${FLAGS} $< -o $@ ${CLIB}



################### COMMANDES MAKEFILES ###################
# Commande de lancement des compilation
all: objet test ${PROGRAMME}
prog: mr_proper objet ${PROGRAMME} laugth
test: premierTest ${OBJTEST}
objet: premierObj $(OBJET)

#supression des fichier obsolette
clear:
	$(CLEAR)
clean: clear
	$(info ......................................)
	$(info .....Suppression des fichiers objets :)
	$(RM) $(OBJET) obj/*.o
mr_proper: clean
	$(info ......................................)
	$(info .....Suppression des executables :)
	$(RM) ${PROGRAMME} $(OBJTEST) $(wildcard bin/test_*.$(EXT_EXEC))
cleanDoxygen:
	$(info ......................................)
	$(info .....Suppression de la doc de doxygen :)
	$(RMDIR) docs/Doxygen/html
mr_properSuper: mr_proper cleanDoxygen
	$(info .)
	$(info .)
	$(info Tout à était parfaitement nettoyé)
	$(info .)
	$(info .)

#lancement du programme
laugth:
	$(info ......................................)
	$(info .....Lancement de '${PROGRAMME}' :)
	${PROGRAMME}

#commande git
pull:
	git pull
git:
	git fetch
	git add *
	git commit
	git push

#commande doxygen
DOC=./docs/Doxygen
ERR=$(DOC)/Doxyerr
doc:
	$(RM) $(ERR)
	doxygen $(DOC)/Doxyfile 2> $(ERR)
	$(CMPT_LIGNE_ERR_DEB) $(ERR)
	$(CMPT_LIGNE_ERR_FIN)
	$(OPEN) $(DOC)/html/index.html

#aide makefile
help: clear
	$(info ......................................)
	$(info ....AIDE : )
	$(info Pour la commande 'make', vous pouvez mettre une ou plusieurs options, dans l'ordre où vous voulez les éxécuter)
	$(info La liste suivantes propose les options de la commande 'make' :)
	$(info |--------------------DOC MAKEFILE-----------------------------------------------------------------------------)
	$(info |	- 'help' : Affiche cette aide)
	$(info |--------------------COMMANDES DE COMPILATION PRINCIPALES-----------------------------------------------------)
	$(info |	- 'objet' : Compile tous les fichiers objet nécessaire aux futurs compilation.)
	$(info |	- 'test' : Compile tous les programmes de tests)
	$(info |	- 'prog' : Compile le programme principale puis l'éxécute)
	$(info |	- 'all' : Compile tous les fichiers objets, les tests et le programme principale.)
	$(info |--------------------COMPILATION DES FICHIERS INDIVIDUELLES---------------------------------------------------)
	$(info |	- 'obj/<NOM>.o' : compile le fichier 'src/<NOM>.cpp' dans le fichier binaire 'obj/<NOM>.o'.)
	$(info |		Ce fichier binaire permet de lié toutes les fonctions de l'objet '<NOM>' à un executable.)
	$(info |	- 'bin/test_<NOM>.$(EXT_EXEC)' : compile le programme qui test <NOM>.)
	$(info |	- '${PROGRAMME}' : Compile le programme principale)
	$(info |--------------------NETTOYAGE--------------------------------------------------------------------------------)
	$(info |	- 'clean' : Supprime tous les fichiers objets)
	$(info |	- 'mr_proper' : Supprime tous les fichiers objets et tous les éxecutables)
	$(info |	- 'cleanDoxygen' : Supprime toute la documentation générer par doxygen)
	$(info |	- 'mr_properSuper' : Supprime tous les fichiers objets, les éxecutables et les dossier générer par doxygen)
	$(info |--------------------AUTRES-----------------------------------------------------------------------------------)
	$(info |	- 'laugth' : execute le programme final)
	$(info |	- 'pull' : Récupére le contenu du github, à condition qu'il y est déjà eu un 'git init'.)
	$(info |	- 'git' : envoit ce qu'il faut sur github, à condition qu'il y est déjà eu un 'git init'.)
	$(info |	- 'doc' : Crée la documentation doxygen du projet et l'affiche)
	$(info |-------------------------------------------------------------------------------------------------------------)


testTESTtest: clear
	$(info .)
	$(info Quelques tests :)
	$(info Fin des tests)


###################### FIN MAKEFILE #######################

