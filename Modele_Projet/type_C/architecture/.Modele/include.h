#ifndef _~~NOMDEF~~_H_
#define _~~NOMDEF~~_H_

/**
	* \file include/~~FICHIER~~.h
	* \brief Déclaration de l'objet ~~OBJET~~.
	* \author ~~AUTEURS~~
	* \version 0.1
	* \date ~~DATE~~
	*
	* L'objet ~~OBJET~~ sert à ~~DESCR~~.
	*
	*/

// INCLUSION(S) DE(S) BIBLIOTHEQUE(S) NÉCÉSSAIRE(S)
#include "commun.h"


// CRÉATION(S) DE(S) MACRO(S)


// CRÉATION(S) DE(S) CONSTANTE(S) NUMÉRIQUE(S)


// CRÉATION(S) D(ES) ÉNUMÉRATION(S)


// CRÉATION(S) D(ES) STRUCTURE(S) ET D(ES) UNIONS(S)
/** \brief La structure ~~OBJET~~_t.
	* \author Erwan PECHON
	*
	* La structure ~~OBJET~~_t sert à ~~DESCR~~.
	*
	*/
typedef struct ~~OBJET~~_s {
#include "attributs_objet.h"
	int var; //!< Une simple variable.
} ~~OBJET~~_t;


// CRÉATION(S) DE(S) CONSTANTE(S) DE STRUCTURE(S)


// CRÉATION(S) DE(S) FONCTION(S)
/**\brief La fonction affichant le nombre d'objet non détruit.
	* \author Erwan PECHON
	*
	* La fonction 'afficherSurvivant_~~OBJET~~' est prévue pour fonctionner dans le fichier 'test/~~OBJET~~.c'.
	* Cette fonction affiche le nombre de ~~OBJET~~ non-détruit, ainsi que le nombre d'objet inclut dans ~~OBJET~~ qui n'ont pas était détruit.
	*
	*/
extern void afficherSurvivant_~~VAROBJET~~();

/**\brief La fonction créant un objet ~~OBJET~~_t.
	* \author ~~AUTEURS~~
	* \param[in,out] utilite
	* \return un pointeur sur un ~~OBJET~~_t.
	*
	* La fonction 'creer_~~OBJET~~' crée un objet ~~OBJET~~.
	*
	*/
extern ~~OBJET~~_t * creer_~~VAROBJET~~();


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //

#endif
