/**
	* \file src/~~FICHIER~~.c
	* \brief Définition de l'objet ~~OBJET~~.
	* \author ~~AUTEURS~~
	* \version 0.1
	* \date ~~DATE~~
	*
	* L'objet ~~OBJET~~ sert à ~~ACTION~~.
	*
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include <stdlib.h>
#include <stdio.h>

#include "../include/~~FICHIER~~.h"


// CRÉATION(S) DE(S) MACRO(S)


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)
static int unsigned cmpt_~~OBJET~~ = 0;


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)


// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)


// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)


// CRÉATION(S) DE(S) FONCTION(S)
	// Fonctions spéciale d'un objet ~~OBJET~~

	// Methode commune à tout les objets
static void afficher_~~VAROBJET~~( ~~OBJET~~_t *~~VAROBJET~~ ){
	printf("~~OBJET~~{}");
}

static Err_t * detruire_~~VAROBJET~~( ~~OBJET~~_t **~~VAROBJET~~ ){
	//! Suppression des attributs de l'objet ~~OBJET~~

	//! Suppression de l'objet ~~OBJET~~
	free( (*~~VAROBJET~~) );
	(*~~VAROBJET~~) = NULL;

	//! Valider la destruction de l'objet ~~OBJET~~
	cmpt_~~OBJET~~--;
	return(NULL);
}

extern void afficherSurvivant_~~VAROBJET~~(){
	printf("Il reste %i ~~OBJET~~_t.\n",cmpt_~~OBJET~~);
}

extern ~~OBJET~~_t * creer_~~VAROBJET~~(){
	//! Tests des paramètres


	//! Création de l'objet ~~OBJET~~
	~~OBJET~~_t *~~VAROBJET~~ = malloc( sizeof(~~OBJET~~_t) );
	if( !~~VAROBJET~~ ){ // malloc à échouer :
		MSG_ERR( creer_Erreur(E_C_MEMOIRE,E_T_ERROR) , "Impossible de créer un objet de type '~~OBJET~~'");
		return (~~OBJET~~_t*)NULL;
	}

	//! Affecter les attributs à l'objet ~~OBJET~~

	//! Affecter les methodes à l'objet ~~OBJET~~
	~~VAROBJET~~->detruire = (Err_t* (*)(void *))detruire_~~VAROBJET~~;
	~~VAROBJET~~->afficher = (void (*)(void *))afficher_~~VAROBJET~~;

	//! Valider la création de l'objet ~~OBJET~~ et le renvoyer à l'utilisateur.
	cmpt_~~OBJET~~++;
	return ~~VAROBJET~~;
}


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //

