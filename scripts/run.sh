#!/bin/bash

# PATH complet pour cron + venv
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Répertoire parent
PROJECT_DIR=$(dirname "$(dirname "$(realpath "$0")")")

cd "$PROJECT_DIR"

# Activer le venv
source "$PROJECT_DIR/.venv/bin/activate"

# Exécution de  make bash
/usr/bin/make bash >> "$PROJECT_DIR/logs/cron.log" 2>> "$PROJECT_DIR/logs/cron_error.log"

# Ligne Cron works
echo "Cron works: $(date)" >> "$PROJECT_DIR/logs/cron.log" 2>&1
