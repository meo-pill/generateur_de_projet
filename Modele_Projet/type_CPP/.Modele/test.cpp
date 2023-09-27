/**
	* \file test/test_~~FICHIER~~.cpp
	* \brief Test de l'objet ~~OBJET~~.
	* \author ~~AUTEURS~~
	* \version 0.1
	* \date ~~DATE~~
	*
	* L'objet modele sert à ~~ACTION~~.
	*
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include <iostream>

#include "../include/~~FICHIER~~.hpp"


// CRÉATION(S) DE(S) MACRO(S)


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)


// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)


// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)


// CRÉATION(S) DE(S) FONCTION(S)


// PROGRAMME PRINCIPALE
	/* Programme qui test l'objet ~~OBJET~~. */
int main() {
	// INITIALISATION DE(S) VARIABLE(S)
		/* Création des variables d'états */
	Err_t *err=NULL;
	Err_cause_e codeErr = E_C_OK;
		/* Création d'un pointeur sur l'objet à tester */
	~~OBJET~~_t *~~VAROBJET~~ = NULL;
		/* Création des autres variables */

	// INSTRUCTION(S)
	printf("Création de l'objet ~~VAROBJET~~...");
	if(!( ~~VAROBJET~~=creer_~~VAROBJET~~() )){ // Pas d'objet modele de créer :
		MSG_ERR2("À la création de l'objet ~~OBJET~~");
		codeErr = E_C_AUTRE;
		goto Quit;
	}
	~~VAROBJET~~->afficher( ~~VAROBJET~~ );
	printf("OK\n");

	// FIN DU PROGRAMME
	codeErr = E_C_OK;
Quit:	/* Destruction des objets */
	if(( err=(~~VAROBJET~~->detruire(&~~VAROBJET~~)) )){
		MSG_ERR2("de la destruction de l'objet ~~VAROBJET~~");
		if( err->type > E_T_ERROR ){
			return err->cause;
		}
	}
	afficherSurvivant_~~VAROBJET~~();
	FIN_PROG(err,codeErr)
}
	/* Programme qui test l'objet ~~OBJET~~. */
// PROGRAMME PRINCIPALE


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //

