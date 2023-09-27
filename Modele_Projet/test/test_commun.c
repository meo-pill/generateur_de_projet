/**
	* \file test/test_commun.c
	* \brief Test des notions commune à tous les fichiers du projet.
	* \author Erwan PECHON
	* \version 0.1
	* \date ~~DATE~~
	*
	* Ce fichier sert à tester toutes les librairies, les fonctions, les constantes, etc... qui sont nécessaire dans tous les fichiers.
	*
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include "../include/commun.h"


// CRÉATION(S) DE(S) MACRO(S)


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)


// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)


// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)


// CRÉATION(S) DE(S) FONCTION(S)


// PROGRAMME PRINCIPALE
	/* Programme qui test les notions communes à tous les fichiers du projet. */
int main() {
	// INITIALISATION DE(S) VARIABLE(S)
		/* Création des variables d'états */
	Err_t *err=NULL;
	Err_cause_e codeErr = E_C_OK;
		/* Création des autres variables */

	// INSTRUCTION(S)
	printf("Création d'une erreur...");
	if(!( err=creer_Erreur(E_C_AUTRE,E_T_INFO) )){ // Pas d'objet Err_t de créer :
		MSG_ERR2("À la création d'une erreur");
		codeErr = E_C_AUTRE;
		goto Quit;
	}
	printf("OK\n");
	
	printf("\n\tAffichage d'une erreur.\n");
	MSG_ALERTE("alerte---a","alerte---b","alerte---c","alerte---d")
	MSG_ERR(err,"Tests d'une erreur 1");
	MSG_ERR2("Tests d'une erreur 2");
	MSG_ERR_COMP("Type d'une erreur","Tests d'une erreur 3");
	printf("\n\tFIN Affichage d'une erreur.\n");
	
	printf("\n\tAffichage d'erreur possible.\n");
	err->type = E_T_INFO; err->cause = E_C_OK;
	MSG_ERR(err,"Tests d'une information ok");
	err->type = E_T_WARNING; err->cause = E_C_MEMOIRE;
	MSG_ERR(err,"Tests d'un avertissement sur la memoire");
	err->type = E_T_ERROR; err->cause = E_C_ARGUMENT;
	MSG_ERR(err,"Tests d'une erreur d'argument");
	err->type = E_T_FATAL_ERROR; err->cause = E_C_OBTENIR;
	MSG_ERR(err,"Tests d'une erreur_fatal d'obtention de donnée");
	err->type++ ; err->cause = E_C_AFFICHE;
	MSG_ERR(err,"Tests d'une erreur_inconnue d'affichage");
	err->type = E_T_INFO; err->cause = E_C_AUTRE;
	MSG_ERR(err,"Tests d'une information d'autre type");
	err->cause++;
	MSG_ERR(err,"Tests d'une information inconnue");
	err->cause = E_C_OK;
	printf("\n\tFIN Affichage d'erreur possible.\n");

	// FIN DU PROGRAMME
	codeErr = E_C_OK;
Quit:	/* Destruction des objets */
	FIN_PROG(err,codeErr)
}
	/* Programme qui test les notions communes à tous les fichiers du projet. */
// PROGRAMME PRINCIPALE


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //

