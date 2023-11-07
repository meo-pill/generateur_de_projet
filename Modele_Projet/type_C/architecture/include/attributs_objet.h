/**
	* \file include/attribut_objet.h
	* \brief Définition des attributs de tout les objets.
	* \author Erwan PECHON
	* \version 0.1
	* \date ~~DATE~~
	*
	* Ce fichier contient les attributs en commun avec tout les objets.
	* Il faut inclure ce fichier directement dans la définition d'une structure ayant besoin de ces attributs.
	*
	*/

// DÉFINITION(S) DE(S) ATTRIBUTS(S) COMMUN(S) À TOUS LES OBJETS


// DÉFINITION(S) DE(S) MÉTHODE(S) COMMUNE(S) À TOUS LES OBJETS
Err_t* (*detruire)(void*); //!< Methode de destruction de l'objet.
	//!< @param[in,out] - L'addresse du pointeur sur l'objet à détruire.
	//!< @return NULL si il n'y à pas eu d'erreur. Une erreur, si il y en à eu une.
	//!<
	//!< La méthode detruire est commune à tout les objet.
	//!< pour détruire un objet, il faut appeler sa méthode de destruction, et donner l'adresse de son pointeur en paramètre.
	//!<

void (*afficher)(const void*); //!< Methode d'affichage de l'objet.
	//!< @param[in] - L'addresse du pointeur sur l'objet à afficher.
	//!<
	//!< La méthode 'afficher' est commune à tout les objet.
	//!< pour afficher un objet, il faut appeler sa méthode d'affichage, et donner l'adresse de son pointeur en paramètre.
	//!<


// #####-#####-#####-#####-##### FIN PROGRAMMATION #####-#####-#####-#####-##### //
