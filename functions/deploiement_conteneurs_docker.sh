#!/bin/bash
# functions/deploiement_conteneurs_docker.sh
# Lance docker compose pour démarrer les conteneurs mowgli

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$SCRIPT_DIR/functions/utils.sh" ] && source "$SCRIPT_DIR/functions/utils.sh"

deploiement_conteneurs() {
  local target_dir="$HOME/mowgli-docker"
  local compose_file="$target_dir/docker-compose.yml"

  echo "-> Déploiement des conteneurs Docker..."

  # Vérifie que Docker est bien installé
  if ! command -v docker >/dev/null 2>&1; then
    echo "[ERREUR] Docker n'est pas installé. Lancez d'abord l'option D)."
    return 1
  fi

  # Vérifie que le dépôt est bien cloné
  if [ ! -d "$target_dir" ]; then
    echo "[ERREUR] Le dossier $target_dir n'existe pas. Clonez le dépôt avec l'option C)."
    return 1
  fi

  # Vérifie que le fichier docker-compose existe
  if [ ! -f "$compose_file" ]; then
    echo "[ERREUR] Aucun fichier docker-compose.yml trouvé dans $target_dir"
    return 1
  fi

  # Sauvegarde (si modification future)
  sauvegarder_fichier "$compose_file"

  cd "$target_dir" || return 1

  echo "�� Pull des images Docker (si nécessaire)..."
  docker compose pull

  echo "�� Démarrage des conteneurs en arrière-plan..."
  docker compose up -d

  echo "✅ Conteneurs en cours d’exécution :"
  docker compose ps

  cd - > /dev/null || return 0

  pause_ou_touche
}
