# Rungame

Un projet personnel de jeu de course 2D développé avec **Godot Engine**. Ce projet a été conçu en premier lieu dans un but d'apprentissage pour explorer les fonctionnalités du moteur et la logique du Game Design.
Désormais ce projet est devenu mon passe-temps et pourquoi pas un futur jeu commercialisé.

## Concept du Jeu
Le joueur contrôle un petit stickman qui court à toute allure à travers des niveaux générés aléatoirement. 
A la fin de chacun d'entre eux, il pourra acheter des améliorations aux moyens d'orbes récupérées dans les niveaux parcourus.

Un mode multijoueur est aussi à disposition, prenant en charge 2 joueurs pour l'instant, dans lequel les deux joueurs s'affrontent pour déterminer qui est le plus rapide. 
Pareil, à la fin de chacun des niveaux, les joueurs peuvent choisir à tour de rôle une carte d'amélioration (le perdant choisit en premier).

## Contrôles

Joueur 1 :
- ↑ : Sauter
- → : Booster
- ↓ : Chute rapide

Joueur 2 :
- Z : Sauter
- D : Booster
- S : Chute rapide

## Roadmap
Le développement se poursuit avec ces objectifs majeurs :

1. Augmentation de la taille du contenu :
   - plus de skins (13 terminés / 28 prévus actuellement)
   - plus de sections de niveaux (10 terminées / ~100 voulues)
   - plus de cartes d'améliorations (18 terminées / 35 prévues actuellement)

2. Ajout d'une **Jukebox** pour laisser au joueur le choix complet de sa playlist en jeu

3. Ajout d'un mode multijoueur en LAN

4. Ajout de contrôles manettes, avec une interface complètement adaptée à ce support et un menu de configuration des touches

5. Refonte des menus

6. Intégration d'effets sonores et musiques faits par moi-même (actuellement tous les sons proviennent d'Internet)

7. Trouvé un meilleur nom pour le jeu (parce que *Rungame*... on souffle quoi)

## Installation
1. Clonez le dépôt :
   ```git clone https://github.com/lcourseaux0202/rungame```

2. Ouvrez Godot Engine (v4.x recommandé).

3. Importez le projet.

4. Lancez la scène principale avec F5.