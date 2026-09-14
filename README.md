# bts-sio-cyber-lab

> **Template GitHub Codespaces pour BTS SIO : génération d'une application Web avec une IA, puis audit automatique avec OWASP ZAP.**

## Objectif pédagogique

Vous devez produire **le meilleur prompt possible**. Vous pouvez demander à l'IA une application robuste, des bonnes pratiques de développement et des mesures de sécurité.

Le but du laboratoire n'est pas de vous piéger avec un mauvais prompt. Il est de vérifier une idée essentielle : **même avec un prompt sérieux et une application qui semble fonctionner, le code généré par une IA doit être compris, testé et audité.**

Vous ne devez donc pas seulement constater que l'application fonctionne. Vous devez être capable d'expliquer le code produit, d'identifier les faiblesses détectées et de les corriger.

## Comment fonctionne le laboratoire ?

```text
Navigateur de l'élève
        │
        │ URL Codespaces : *.app.github.dev
        ▼
┌────────────────────────── GitHub Codespace ──────────────────────────┐
│                                                                      │
│     Assistant IA (Copilot / autre)                                  │
│                 │                                                    │
│                 │ génère le code directement                        │
│                 ▼                                                    │
│              app/                                                    │
│                 │                                                    │
│                 ▼                                                    │
│        Application Web générée                                       │
│          127.0.0.1:3000                                              │
│                 ▲                                                    │
│                 │ cible locale uniquement                            │
│                 │                                                    │
│         OWASP ZAP automatique                                        │
│                 │                                                    │
│        ┌────────┴─────────┐                                          │
│        ▼                  ▼                                          │
│  Baseline Scan        Full Scan                                      │
│  (passif)             (actif)                                        │
│        └────────┬─────────┘                                          │
│                 ▼                                                    │
│             reports/                                                 │
│        rapports HTML + JSON                                          │
│        RESUME_SECURITE.md                                             │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### Explication du schéma

L'adresse en `*.app.github.dev` sert uniquement à **afficher votre application dans votre navigateur**. Elle est créée par GitHub Codespaces pour vous permettre d'accéder au port 3000 du Codespace.

À l'intérieur du Codespace, l'application fonctionne sur :

```text
http://127.0.0.1:3000
```

OWASP ZAP analyse **cette adresse locale**. Les scripts du laboratoire refusent volontairement les domaines Internet et les autres adresses IP. Vous ne devez donc pas choisir manuellement une cible de scan.

Le **Baseline Scan** réalise principalement une exploration et une analyse passive. Le **Full Scan** réalise ensuite des tests actifs contre votre propre application de laboratoire.

Les résultats sont enregistrés automatiquement dans `reports/`. Le fichier `RESUME_SECURITE.md` est également généré automatiquement pour vous donner une première synthèse des alertes par niveau de risque. Vous devez cependant consulter les rapports HTML et le code source : le résumé ne remplace pas votre analyse.

## Déroulement pour l'élève

```text
Votre prompt
    ↓
IA dans VS Code
    ↓
Création automatique de l'application dans app/
    ↓
Détection du code par le laboratoire
    ↓
Démarrage automatique sur le port 3000
    ↓
ZAP Baseline Scan
    ↓
ZAP Full Scan
    ↓
Rapports + RESUME_SECURITE.md
    ↓
Analyse du code
    ↓
Correction
    ↓
Nouveau scan automatique
```

Aucune copie manuelle de l'application n'est nécessaire. L'assistant IA écrit directement dans `app/` et le superviseur du laboratoire surveille ce dossier.

## Que devez-vous analyser ?

Dans `reports/`, vous trouverez notamment :

```text
zap-baseline-AAAAmmjj-HHMMSS.html
zap-baseline-AAAAmmjj-HHMMSS.json
zap-full-AAAAmmjj-HHMMSS.html
zap-full-AAAAmmjj-HHMMSS.json
RESUME_SECURITE.md
```

Commencez par `RESUME_SECURITE.md`, puis ouvrez les rapports HTML complets. Pour chaque alerte importante, recherchez ensuite la partie du code qui peut l'expliquer.

Une alerte ZAP n'est pas une preuve suffisante à elle seule : il peut exister des faux positifs, et certaines failles ne sont pas détectables automatiquement. **Votre compréhension du code reste indispensable.**

## Stacks détectées automatiquement

Le template sait démarrer automatiquement les cas courants suivants :

- Node.js (`package.json`, script `dev` ou `start`) ;
- Python/Flask (`app.py`) ;
- Python/FastAPI (`main.py`) ;
- PHP (`index.php`).

Pour un autre framework, l'enseignant peut enrichir `scripts/detect-start-command.sh`.

## Diagnostic

Le journal du superviseur se trouve dans :

```text
.lab-state/auto-audit.log
```

Le journal de l'application se trouve dans :

```text
.lab-state/app.log
```

Pour vérifier l'état de l'application depuis le terminal du Codespace :

```bash
curl -I http://127.0.0.1:3000
```

Pour lister les rapports générés :

```bash
find reports -maxdepth 1 -type f -printf '%f\n' | sort
```
