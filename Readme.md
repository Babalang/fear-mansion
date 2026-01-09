# Fear Mansion

Fear Mansion est un projet développé avec le moteur de jeu **Godot Engine**. C'est un jeu d'horreur en VR dans lequel le joueur doit s'échapper d'un manoir occupé par un animatronique que l'on doit éviter.

## Structure du projet

### Répertoires principaux

- **Objects/** : Contient divers objets 3D et ressources utilisés dans le jeu.
- **Audio/** : Contient les ressources audio utilisées.
- **fonts/** : L'ensemble des polices utilisées.
- **MansionFBX/** : Les versions du FBX du manoir.
- **materials/** : Les matériaux des assets.
- **Scenes/** : Les différentes scènes présentent dans le jeu.
- **Scripts/** : Les scripts et autres programmes.
- **Shaders/** : Les différents shaders utilisés comme matériaux.
- **Textures/** et **Themes/** : Les thèmes et textures.
- **Blueprints/** : Contient des scènes et scripts essentiels pour le fonctionnement du jeu.

## Fonctionnalités principales

- **XR Support** : Le projet utilise les outils XR de Godot (`godot-xr-tools`) pour intégrer des fonctionnalités de réalité virtuelle (VR), comme indiqué dans le fichier `project.godot`.
- **Objets interactifs** : Une variété d'objets et de scènes interactives sont inclus, comme des digicodes, des clés, et des meubles.
- **Immersion** : Le projet plonge l'utilisateur dans l'obscurité pour une sensation d'angoisse constante, il peut éclairer son environnement avec une lampe, et écouter les bruits environnant.

## Plugins utilisés

- **Godot XR Tools** : Un plugin pour gérer les interactions VR, les paramètres utilisateur et les retours haptiques (rumble).

## Configuration requise

- **Godot Engine** : Version 4.5 ou supérieure (mentionné dans `config/features`).
- **Réalité virtuelle** : Le projet supporte OpenXR pour les expériences VR, développé avec meta Quest 3/3S.

## Installation et exécution

1. Clonez ou téléchargez ce dépôt.
2. Ouvrez le projet dans **Godot Engine**.
3. Lancez la scène principale définie dans `project.godot`.
---

## Auteurs
DUPUIS Thibaut et LANGOUET Bastian

## Remerciement
Les artistes du manoir et bêta-testeurs : LANGOUET Julie et DESHAMS Amélien