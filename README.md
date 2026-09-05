# NO LOOK

Prototype web mobile d'horreur 3D construit avec Three.js. Aucun paquet à installer : Visual Studio Code utilise le runtime Node déjà fourni avec Codex pour le serveur local.

## Ouvrir dans Visual Studio Code

1. Ouvrir **ce dossier** (`No-look-main`) dans Visual Studio Code.
2. Ouvrir l'onglet **Exécuter et déboguer** (`Ctrl+Maj+D`).
3. Choisir **NO LOOK : déboguer dans Chrome**, puis appuyer sur `F5`.

Visual Studio Code lance `server.mjs`, ouvre `http://localhost:4173` et permet de placer des points d'arrêt dans `index.html`.

## Réglages du jeu

Les valeurs de durée, vitesse, brouillard, danger et emplacements des souvenirs sont regroupées dans `GAME_CONFIG`, au début du script dans `index.html`.

## Commandes

- Mobile : joystick à gauche pour marcher ; glisser à droite pour regarder ; bouton œil pour fermer les yeux.
- Ordinateur : ZQSD/WASD ou flèches pour marcher ; espace pour fermer les yeux ; Échap pour la pause.
