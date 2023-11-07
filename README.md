# generateur_de_projet
Permet de générer un projet en langage C.
# Le generateur_de_projet
Ceci est un projet personel, commencé le 'Lundi 13 septembre 2021'.
C'est un projet codé en **bash**.
Le **generateur_de_projet** a pour objectif de facilité le démarrage d'un nouveau projet et de facilité la création de modèle de projet pour un maximum de personalisation.

## L'équipe :
- Chef de projet : Dark-Gouloum
- Groupe : Dark-Gouloum :: meo-pill

## Présentation
Le **generateur_de_projet** est un outil de dévelopement simple et très personalisable.

Le **generateur_de_projet** est codé en **langage de script Shell(bash)**.

## Installation
Pour obtenir le dossier, il suffit de faire un clone du répertoire distant, avec la commande `git clone https://github.com/meo-pill/generateur_de_projet/`.
Pour installer le projet, il faut obtenir le dossier du projet, puis, taper les commandes `chmod a+x ./generateur_de_projet/ConfigGenerateur.sh ; ./generateur_de_projet/ConfigGenerateur.sh` et enfin, répondre aux question qui vous seront poser.
Une fois le generateur_de_projet installer et configurer, vous pouver supprimer le dossier du projet github avec `rm -fr ./generateur_de_projet`.

## Lancement
Pour lancer le programme, il suffit d'exécuter la commandes suivantes: `<dossier où se trouve le script de génération de projet>/<script de génération de projet>.sh -h` et son mode de fonctionnement vous y sera expliqué.
**Note** : Si le script de génération de projet à était mis dans un dossier faisant parti de la variable `$PATH`, La commande `<script de génération de projet>.sh -h` suffira à le lancer de n'importe où.
**Note 2** : Si le dossier de modèle de projet devait-être déplacer, supprimer ou que son nom serait changé, le script de génération de projet ne fonctionnerait plus j'usqu'à ce que vous rétablissier le modèle de projet, ré-installiez tout le projet où changiez la variable `dossierModele=` dans le script de génération de projet.
**Note 3** : Vous pouver modifié les modèle de projet tant qu'ils respecte les conventions et l'architecture du projet.

## Architecture du projet
- `<script de génération de projet` : Le script que vous devez appelez pour générer un nouveau projet. Il se chargera d'analyser la plupart des argument et de les transmettre au bon script de génération pour le language demandé.
- `$dossierModele` : Le dossier qui contient tout ce qui est utile au bon fonctionnement du script.
- `$dossierModele/question.sh` : Est le script permettant de poser des question fermer (oui,non,valider,etc...) à l'utilisateur.
- `$dossierModele/fonction_creation_projet.sh` : Se charge de créer les fonctions commune à tout les générateur de projet (le commun et les spécialiser), ainsi que de vérifier que le script est bien configuré et utilisé, ainsi qu'une demande d'aide.
- `$dossierModele/verifier_creation_projet.sh` : Se charge de vérifier que le projet soit créable, et créra bien le projet que l'utilisateur voulait. Il se charge aussi de créer le projet avant sa configuration.
- `$dossierModele/GenereProjet_<language>.sh` : Se charge de générer un projet du language `<language>`, pour ce faire, il analyse les paramètres non-traité, appele le script `$dossierModele/verifier_creation_projet.sh` et remplace les balises des fichier de modèle par le contenu ddésirer par l'utilisateur.
- `$dossierModele/type_<language>` : Le dossier contenant tout les modèle d'un projet utilisant le language `<language>`.
- `$dossierModele/type_<language>/<nom modèle>.<extension>` : Le modèle d'un projet tenant en 1 seul fichier, qui doit avoir l'extension `<extension>`
- `$dossierModele/type_<language>/<nom modèle>/` : Le modèle d'un projet tenant dans une architecture.

## Convention
- Le script `<script de génération de projet` doit analyser tout les argument commun à tout les générateur de projet. Les arguments commun doivent tous être avant les arguments spécialiser. Ce script doit aussi se charger de demandé la language du projet à créer et en appeler le générateur. Il devra aussi transmettre toutes les information au script spécialiser.
- Le script spécialiser doit commencé par tester si la variable `$dossierModele` est vide, et si c'est le cas, affiché une erreur. La deuxième chose que ce script doit faire, c'est de lire tout les tableaux qui lui sont transmis, à l'aide de la ligne `source $F_tab`. Avant de rentrer dans le gros du script, il lui faut charger les fonction commune à l'aide de `source $dossierModele/fonction_creation_projet.sh`. Soit fichier doit finir par la ligne `FIN`.
- Le dossier de modèles d'un language `$dossierModele/type_<language>` doit contenir tout les modèle de ce language, ces modèles seront copiè à l'emplacement de la création du projet, puis modifiè par sed.
- Les dossiers de modèles de language `$dossierModele/type_<language>` doivent avoir était comprasser par la commande `tar -czvf $dossierModele/type_<language>.tar.gz $dossierModele/type_<language>`.


## Contribuer
Les *pulls requests* sont les bienvenues.
Pour tout changement majeur, ouvrez une *issue* en premier pour discuter de ce que vous aimeriez changer, s'il vous plaît.

Assurez-vous de mettre à jour les tests appropriés, s'il vous plaît.

## Licence
[The Unlicense](https://choosealicense.com/licenses/unlicense/)

## Autres

## Gantt

