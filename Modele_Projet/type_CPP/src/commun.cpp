/**
	* \file src/commun.c
	* \brief Définition des donnée commune à tous les fichiers.
	* \author Erwan PECHON
	* \version 0.1
	* \date ~~DATE~~
	*
	* Ce fichier sert à définire toutes les librairies, les fonctions, les constantes, etc... qui sont nécessaire dans tous les fichiers.
	* Définition des donnée commune à tous les fichiers :
	*	+ L'inclusion de librairies commune :
	*		- stdio
	*	+ La gestion des erreurs.
	*
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include "../include/commun.h"


// CRÉATION(S) DE(S) MACRO(S)
/** Fais planter le programme après avoir indiqué ce qui à causé une erreur lors de la gestion d'une erreur.
	* /param type Un c_string affichant le type d'Erreur survenu (MEMOIRE,PARAMETRE,etc...)
	* /param cause Un c_string affichant une explication de ce qui à causé cette sur-erreur.
	*/
#define ERREUR_ERREUR(type,cause){\
	MSG_ALERTE("","FATAL_ERROR",type,cause);\
	assert( 0 && "Impossible de gérer les erreurs du programme." );\
}

/** Stocke une chaîne de caractère constante dans une variable pointé par retour.
	* /param retour Un pointeur sur la variable où stocké la chaîne de caractère.
	* /param raison La chaîne de caractère constante à stocké dans la variable pointé par retour.
	*/
#define EXPLIQUE_ERR(retour,raison){\
	*retour = malloc( sizeof(char) * (strlen(raison)+5) );\
	if( !(*retour) ) ERREUR_ERREUR("E_MEMOIRE","Pas assez de mémoire pour affiché la raison de l'erreur.");\
	strcpy( *retour , raison );\
}


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)
static int unsigned cmpt_Erreur = 0;


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)

// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)

// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)

// CRÉATION(S) DE(S) FONCTION(S)
extern void afficherSurvivant_Erreur(){
	printf("Il reste %i Err_t.\n",cmpt_Erreur);
}

/** Analyse la cause d'une erreur
	* /param err Le code de la cause de l'erreur à analysé
	* /param **retour Un poiteur sur la variable où stocké la chaîne de caractère à affiché.
	*/
static void analyse_cause_err( Err_cause_e err , char **retour ){
	if( retour == NULL ){
		ERREUR_ERREUR("E_ARGUMENT","retour devrait pointé sur une variable à modifié.");
	} else if( *retour != NULL ){
		ERREUR_ERREUR("E_ARGUMENT","La variable à modifié, pointé par retour, ne devrait pas déjà contenir  une chaîne de caractère.");
	}
	switch( err ){
		case E_C_OK :
			EXPLIQUE_ERR( retour , "Tout c'est bien passé." );
			break;
		case E_C_MEMOIRE :
			EXPLIQUE_ERR( retour , "Débordement mémoire : " );
			break;
		case E_C_ARGUMENT :
			EXPLIQUE_ERR( retour , "Un argument est non-valide : " );
			break;
		case E_C_OBTENIR :
			EXPLIQUE_ERR( retour , "La donné n'est pas initialisé : " );
			break;
		case E_C_AFFICHE :
			EXPLIQUE_ERR( retour , "Erreur à l'affichage : " );
			break;
		case E_C_AUTRE :
			EXPLIQUE_ERR( retour , "-> " );
			break;
		default :
			EXPLIQUE_ERR( retour , "Code erreur inconnu, veuillez l'ajouter." );
			break;
	}
}

/** Analyse le type d'une erreur
	* /param type Le code du type de l'erreur à analysé
	* /param **retour Un poiteur sur la variable où stocké la chaîne de caractère à affiché.
	*/
static void analyse_type_err( Err_type_e type , char **retour ){
	if( retour == NULL ){
		ERREUR_ERREUR("E_ARGUMENT","retour devrait pointé sur une variable à modifié.");
	} else if( *retour != NULL ){
		ERREUR_ERREUR("E_ARGUMENT","La variable à modifié, pointé par retour, ne devrait pas déjà contenir  une chaîne de caractère.");
	}
	switch( type ){
		case E_T_INFO        : // Informer l'utilisateur d'un problème ignorable et sans conséquence.
			EXPLIQUE_ERR( retour , "INFORMATION" );
			break;
		case E_T_WARNING     : // Avertir l'utilisateur d'un problème ignorable, mais risquant d'avoir des conséquence sur la suite du programme.
			EXPLIQUE_ERR( retour , "AVERTISSEMENT" );
			break;
		case E_T_ERROR       : // Avertir l'utilisateur d'un problème pouvant causer de nombreuses erreurs.
			EXPLIQUE_ERR( retour , "ERREUR" );
			break;
		case E_T_FATAL_ERROR : // Le programme à crash.
			EXPLIQUE_ERR( retour , "ERREUR FATAL" );
			break;
		default : // Type d'erreur inconnu
			EXPLIQUE_ERR( retour , "UNK" );
			break;
	}
}

extern void analyse_err( Err_t *err , char **cause , char **type ){
	//! Analyser la cause de l'erreur (MEMOIRE,ARGUMENT,etc...)
	analyse_cause_err( err->cause , cause );
	//! Analyser le type d'erreur (INFO,WARNING,ERROR,FATAL_ERROR,etc...)
	analyse_type_err( err->type , type );
}

extern Err_t* creer_Erreur( Err_cause_e codeErr , Err_type_e nomErr ){
	//! Création de l'objet Err_t
	Err_t *err = malloc( sizeof(Err_t) );
	if( !err ){ // Si l'objet Err_t n'à pas put être créer :
		MSG_ALERTE("","FATAL_ERROR","E_MEMOIRE","Une errreur n'à pas put être créer.");
		// Faire planter le programme de force, à l'aide d'une assertion.
		assert( 0 && "Impossible de gérer les erreurs du programme du à un manque de mémoire." );
	}
	//! Paramètrer l'erreur, pour pouvoir l'utiliser.
	err->cause = codeErr;
	err->type = nomErr;
	//! Valider la création de l'Erreur et la renvoyer à l'utilisateur
	cmpt_Erreur++;
	return err;
}

extern void detruire_Erreur( Err_t **err ){
	//! Suppression de l'objet Err_t
	free( (*err) );
	(*err) = NULL;

	//! Valider la destruction de l'Erreur.
	cmpt_Erreur--;
}

// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //
