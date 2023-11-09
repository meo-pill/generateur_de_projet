# Le generateur_de_projet

Ceci est un projet personel, commencé le `Lundi 13 septembre 2021`.
C'est un projet codé en **bash**.
Le **generateur_de_projet** a pour objectif de faciliter le démarrage d'un nouveau projet et de faciliter la création de modèle de projet pour un maximum de personalisation.

## L'équipe

- Chef de projet : Dark-Gouloum
- Groupe : Dark-Gouloum :: meo-pill :: ABTonniere

## Présentation

Le **generateur_de_projet** est un outil de dévelopement simple et très personalisable.

Le **generateur_de_projet** est codé en **langage de script Shell(bash)**.

## Installation

Pour obtenir le dossier, il suffit de faire un clone du répertoire distant, avec la commande:

```sh
git clone https://github.com/meo-pill/generateur_de_projet/
```

Pour installer le projet, il faut obtenir le dossier du projet puis taper les commandes:

```sh
chmod a+x ./generateur_de_projet/ConfigGenerateur.sh ; ./generateur_de_projet/ConfigGenerateur.sh
```

Et enfin, répondez aux questions qui vous seront posées.
Une fois le generateur_de_projet installé et configuré, vous pouvez supprimer le dossier du projet github avec:

```sh
rm -fr ./generateur_de_projet
```

## Lancement

Pour lancer le programme, il suffit d'exécuter la commande suivante:

```sh
<dossier où se trouve le script de génération de projet>/<script de génération de projet>.sh -h
```

Son mode de fonctionnement vous y sera expliqué.
**Note** : Si le script de génération de projet à été mis dans un dossier faisant parti de la variable `$PATH`, La commande `<script de génération de projet>.sh -h` suffira à le lancer de n'importe où.

**Note 2** : Si le dossier de modèle de projet devait être déplacé, supprimé ou que son nom serait changé, le script de génération de projet ne fonctionnera plus jusqu'à ce que vous rétablissiez le modèle de projet, ré-installiez tout le projet où changiez la variable `dossierModele=` dans le script de génération de projet.

**Note 3** : Vous pouvez modifier les modèles de projet tant qu'ils respectent les conventions et l'architecture du projet.

## Architecture du projet

- `<script de génération de projet` : Le script que vous devez appeler pour générer un nouveau projet. Il se chargera d'analyser la plupart des arguments et de les transmettre au bon script de génération pour le langage demandé.
- `$dossierModele` : Le dossier qui contient tout ce qui est utile au bon fonctionnement du script.
- `$dossierModele/question.sh` : Script permettant de poser des questions fermées (oui,non,valider,etc...) à l'utilisateur.
- `$dossierModele/fonction_creation_projet.sh` : Se charge de créer les fonctions communes à tout les générateurs de projet (le commun et les spécialisés), ainsi que de vérifier que le script est bien configuré et utilisé, ainsi qu'une demande d'aide.
- `$dossierModele/verifier_creation_projet.sh` : Se charge de vérifier que le projet soit créable, et créra bien le projet que l'utilisateur voulait. Il se charge aussi de créer le projet avant sa configuration.
- `$dossierModele/GenereProjet_<language>.sh` : Se charge de générer un projet du langage `<language>`, pour ce faire, il analyse les paramètres non-traités, appelle le script `$dossierModele/verifier_creation_projet.sh` et remplace les balises des fichiers de modèle par le contenu désiré par l'utilisateur.
- `$dossierModele/type_<language>` : Le dossier contenant tout les modèles d'un projet utilisant le langage `<language>`.
- `$dossierModele/type_<language>/<nom modèle>.<extension>` : Le modèle d'un projet tenant en 1 seul fichier, qui doit avoir l'extension `<extension>`
- `$dossierModele/type_<language>/<nom modèle>/` : Le modèle d'un projet tenant dans une architecture.

## Convention

- Le script `<script de génération de projet` doit analyser tout les arguments communs à tout les générateurs de projet. Les arguments communs doivent tous être avant les arguments spécialisés. Ce script doit aussi se charger de demander le langage du projet à créer et en appeler le générateur. Il devra aussi transmettre toute les informations au script spécialisé.
- Le script spécialisé doit commencer par tester si la variable `$dossierModele` est vide, et si c'est le cas, afficher une erreur. La deuxième chose que ce script doit faire, c'est de lire tout les tableaux qui lui sont transmis, à l'aide de la ligne `source $F_tab`. Avant de rentrer dans le gros du script, il lui faut charger les fonctions communes à l'aide de `source $dossierModele/fonction_creation_projet.sh`. Son fichier doit finir par la ligne `FIN`.
- Le dossier de modèles d'un langage `$dossierModele/type_<language>` doit contenir tout les modèles de ce langage, ces modèles seront copiés à l'emplacement de la création du projet, puis modifiés par `sed`.
- Les dossiers de modèles de langage `$dossierModele/type_<language>` doivent avoir été compressés par la commande `tar -czvf $dossierModele/type_<language>.tar.gz $dossierModele/type_<language>`.

## Contribuer

Les *pulls requests* sont les bienvenues.
Pour tout changement majeur, ouvrez une *issue* en premier pour discuter de ce que vous aimeriez changer, s'il vous plaît.

Assurez-vous de mettre à jour les tests appropriés, s'il vous plaît.

## Licence

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

## Autres

## Gantt

## Convention de nommage

### Commit

Les commits doivent suivre [ConventionnalCommits](https://www.conventionalcommits.org/en/v1.0.0/) et doivent être écrits en minuscule et en utilisant la convention suivante:

```sh
<type>([<scope>]): <description>
```

Les types de commit sont les suivants :

- feat: Ajout d'une nouvelle fonctionnalité
- fix: Correction d'un bug
- docs: Modification de la documentation
- style: Modification du style du code
- refactor: Modification du code sans changer son comportement
- perf: Modification du code pour améliorer les performances
- test: Ajout de tests ou modification des tests existants
- chore: Modification du build system ou des dépendances
- ci: Modification des fichiers de configuration du CI
- revert: Revert d'un commit précédent
- wip: Work in progress
- merge: Merge d'une branche
- release: Release d'une version
- hotfix: Correction d'un bug critique
- other: Autre
- init: Initialisation du projet
