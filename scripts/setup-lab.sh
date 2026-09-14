#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/reports" "$ROOT/.lab-state"
chmod +x "$ROOT/scripts"/*.sh

echo ""
echo "============================================================"
echo " bts-sio-cyber-lab"
echo "============================================================"
echo "Environnement prêt."
echo "- L'IA doit générer directement l'application dans app/."
echo "- Aucun remplacement manuel n'est nécessaire."
echo "- Le superviseur démarrera l'application et lancera ZAP automatiquement."
echo "- Les rapports seront créés dans reports/."
echo "============================================================"
