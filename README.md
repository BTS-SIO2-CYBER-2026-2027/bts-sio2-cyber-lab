# bts-sio-cyber-lab

> **Nom du template GitHub : `bts-sio-cyber-lab`**

Template GitHub Codespaces pour générer une application Web avec une IA puis l'auditer automatiquement avec OWASP ZAP.

## Principe

L'élève produit **le meilleur prompt possible**. L'application est générée directement dans `app/` par l'assistant IA utilisé dans VS Code. Il n'y a aucune copie ni remplacement manuel.

Un superviseur lancé automatiquement avec le Codespace surveille `app/`. Lorsque le code reste stable quelques secondes et devient exécutable, le laboratoire :

1. installe automatiquement les dépendances détectées ;
2. démarre l'application sur le port `3000` ;
3. attend que `http://127.0.0.1:3000` réponde ;
4. exécute automatiquement un ZAP Baseline Scan ;
5. exécute automatiquement un ZAP Full Scan ;
6. place les rapports dans `reports/`.

Les scripts ZAP refusent les domaines et IP externes : la cible est verrouillée sur `localhost` / `127.0.0.1`.

## Flux élève

```text
Prompt de l'élève
       ↓
Assistant IA dans VS Code
       ↓
Écriture directe dans app/
       ↓
Détection automatique
       ↓
Démarrage de l'application
       ↓
127.0.0.1:3000 répond
       ↓
ZAP Baseline
       ↓
ZAP Full Scan
       ↓
reports/
```

## Stacks détectées automatiquement

Le template sait démarrer automatiquement les cas courants suivants :

- Node.js (`package.json`, script `dev` ou `start`) ;
- Python/Flask (`app.py`) ;
- Python/FastAPI (`main.py`) ;
- PHP (`index.php`).

Pour un autre framework, l'enseignant peut enrichir `scripts/detect-start-command.sh`.

## Diagnostic

Le journal du superviseur est disponible dans :

```text
.lab-state/auto-audit.log
```

Le journal de l'application est disponible dans :

```text
.lab-state/app.log
```
