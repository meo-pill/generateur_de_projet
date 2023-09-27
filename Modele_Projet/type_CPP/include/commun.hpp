#ifndef _COMMUN_HPP_
#define _COMMUN_HPP_

/**
	* \file include/commun.hpp
	* \brief Ajout des librairies commune au projet et déclaration des constante, fonction et classes commune au projet.
	* \author Erwan PECHON
	* \version 0.1
	* \date ~~DATE~~
	*
	* Ce fichier sert à définire toutes les librairies, les fonctions, les constantes, etc... qui sont nécessaire dans tous les fichiers.
	* Définition des donnée commune à tous les fichiers :
	*	+ L'inclusion de librairies commune :
	*		- stdio
	*	+ La gestion des erreurs.
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>


// CRÉATION(S) DE(S) MACRO(S)


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)
/*	// GESTION DES ERREURS //	*/
/** Affiche un message dans le canal d'erreur.
	* /param prefixe Le texte à mettre avant le message d'erreur
	* /param nom Le nom de l'erreur ('WARNING','ERREUR',etc...)
	* /param type Le type d'erreur
	* /param explication L'explication de l'erreur
	*/
#define MSG_ALERTE(prefixe,nom,type,explication){\
	fprintf(stderr, "%s%s : %s(%s:%d) : %s%s.\n", prefixe,nom, __func__,__FILE__,__LINE__, type, explication);\
}

/** Affiche un message dans le canal d'erreur.
	* /param err L'erreur
	* /param explication L'explication de l'erreur
	*/
#define MSG_ERR(err,explication){\
	char *nom=NULL, *type=NULL;\
	analyse_err(err,&type,&nom);\
	MSG_ALERTE("",nom,type,explication);\
	free(nom);\
	free(type);\
}

/** Affiche un message dans le canal d'erreur.
	* /param explication L'explication de l'erreur
	*/
#define MSG_ERR2(explication) MSG_ALERTE("|---> ","SUIVI","Une erreur est survenu lors ",explication);

/** Affiche un message dans le canal d'erreur.
	* /param type Le type d'erreur
	* /param explication L'explication de l'erreur
	*/
#define MSG_ERR_COMP(type,explication) fprintf(stderr, "\t---> %s : %s\n", type,explication);

/** Finit le programme
	* /param err Le pointeur sur une potentielle erreur.
	* /param codeErr Le code d'erreur.
	*/
#define FIN_PROG(err,codeErr){\
	if( err ){\
		if( !codeErr ){\
			codeErr = err->cause;\
		}\
		detruire_Erreur(&err);\
	}\
	afficherSurvivant_Erreur();\
	printf("\n\n\t\tFIN DU TEST\t\t\n\n");\
	return(codeErr);\
}


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)
/** La liste des causes d'erreurs possible.
	*/
typedef enum Err_cause_s {
	E_C_OK = 0,  	//!< La fonction à réussi.
	E_C_MEMOIRE, 	//!< La fonction à échouer à cause d'un manque d'espace mémoire.
	E_C_ARGUMENT,	//!< Mauvais arguments passé en paramètre.
	E_C_OBTENIR, 	//!< Erreur lors d'une demande de donnée
	E_C_AFFICHE, 	//!< Erreur lors d'un affichage.
	E_C_AUTRE    	//!< La fonction à échouer pour une erreur inconnu.
} Err_cause_e;

/** La liste des types d'erreurs possible.
	*/
typedef enum Err_type_s {
	E_T_INFO = 0, //!< Informer l'utilisateur d'un problème ignorable et sans conséquence.
	E_T_WARNING, //!< Avertir l'utilisateur d'un problème ignorable, mais risquant d'avoir des conséquence sur la suite du programme.
	E_T_ERROR, //!< Avertir l'utilisateur d'un problème pouvant causer de nombreuses erreurs.
	E_T_FATAL_ERROR //!< Le programme à crash.
} Err_type_e;


// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)
/** L'erreur qui est survenu.
	*/
typedef struct Err_ts {
	Err_cause_e cause; //!< La cause de l'erreur (OK,MEMOIRE,ARGUMENT,etc...).
	Err_type_e type; //!< Le type de l'erreur (INFO,WARNING,ERROR,etc...)
} Err_t;


// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)


// CRÉATION(S) DE(S) FONCTION(S)
/**\brief La fonction affichant le nombre d'objet non détruit.
	* \author 
	*
	* La fonction 'afficherSurvivant_Erreur' est prévue pour fonctionner dans le fichier 'projet/test/Erreur.c'.
	* Cette fonction affiche le nombre d'Erreur non-détruit, ainsi que le nombre d'objet inclut dans l'Erreur qui n'ont pas était détruit.
	*
	*/
extern void afficherSurvivant_Erreur();

/** \brief Methode de destruction de l'objet.
	* /param err L'addresse du pointeur sur l'objet à détruire.
	*
	* La fonction pour detruire une erreur
	*
	*/
extern void detruire_Erreur( Err_t **err );

/** Analyse une erreur.
	* /param err Un pointeur sur l'erreur à analysé
	* /param type Un pointeur sur le type d'erreur
	* /param nom Un pointeur sur le nom de l'erreur ('WARNING','ERREUR',etc...)
	*/
extern void analyse_err( Err_t *err , char **type , char **nom );

/** Crée une erreur.
	* /param codeErr Le type d'erreur
	* /param nom Le nom de l'erreur
	* /return Une erreur qui devra être détruite avec `free()`.
	*/
extern Err_t* creer_Erreur( Err_cause_e codeErr , Err_type_e nomErr );


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //


#endif
