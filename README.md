# Rungame

Un projet personnel de jeu de course 2D développé avec **Godot Engine**. Ce projet a été conçu dans un but d'apprentissage pour explorer les fonctionnalités du moteur et la logique du Game Design.

## Concept du Jeu
Le joueur contrôle un stickman et doit survivre le plus longtemps possible sur une piste infinie. 
* **Gameplay :** Éviter les obstacles qui apparaissent de manière aléatoire.
* **Difficulté :** La génération procédurale assure une expérience différente à chaque partie.

## État du Projet & Apprentissages
Ce projet m'a permis d'apprendre :
- Le concept des noeuds et des scènes.
- Le langage **GDScript**.
- L'utilisation des **signaux** pour la communication entre objets.
- La logique de **génération aléatoire** (spawning d'obstacles).
- La gestion des collisions.

## Roadmap
Le développement se poursuit avec deux objectifs majeurs :

1.  **Refactoring (State Machine) :** Réécriture du code de déplacement du personnage. L'objectif est d'intégrer une *Machine à États Finis* (Idle, Move, Crash, etc.) pour rendre le code plus modulaire et facile à déboguer.
2.  **Multijoueur Local :** Ajout d'un mode 2 joueurs sur le même écran (Split-screen ou écran partagé) pour augmenter la compétitivité.

## Installation
1. Clonez le dépôt :
   ```git clone https://github.com/lcourseaux0202/rungame```

2. Ouvrez Godot Engine (v4.x recommandé).

3. Importez le projet.

4. Lancez la scène principale avec F5.