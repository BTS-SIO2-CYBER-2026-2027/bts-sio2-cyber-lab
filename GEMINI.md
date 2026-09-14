# Contexte projet pour Gemini — bts-sio-cyber-lab

Pour toute génération ou modification d'application demandée dans ce dépôt :

- écris directement tous les fichiers de l'application dans `app/` ;
- rends l'application exécutable sur le port `3000` ;
- privilégie une structure automatiquement détectable par le laboratoire (`package.json`, `app.py`, `main.py` ou `index.php`) ;
- ne demande jamais à l'utilisateur de déplacer/copier manuellement le projet ;
- ne modifie pas `.lab.env`, `scripts/`, `.devcontainer/` ni les contrôles de sécurité ZAP ;
- applique réellement les exigences de sécurité demandées par l'élève, sans introduire intentionnellement de vulnérabilité ;
- n'affirme pas que le résultat est sûr sans audit.

Le laboratoire surveille `app/`, lance automatiquement l'application et déclenche OWASP ZAP lorsque le code devient exécutable.
