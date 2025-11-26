#!/bin/bash

# Les variables que l'on va utiliser dans le script  collect

#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
RAW_DIR="$ROOT/data/raw"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/collect.logs"
PYTHON="$ROOT/.venv/bin/python3"

DATE=$(date +"%Y%m%d_%H%M")
OUTPUT_FILE="$RAW_DIR/sales_$DATE.csv"
MASTER_FILE="$RAW_DIR/sales_data.csv"
MODELS=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")


echo "=============================================="
echo "=== Début de la collecte des données ==="
echo "=============================================="
echo "=== Début de la collecte ===" | tee -a "$LOG_FILE"

# Création du fichier master si nécessaire en cas d'absence ou supprission
if [ ! -f "$MASTER_FILE" ]; then
    echo "timestamp,model,sales" > "$MASTER_FILE"
fi

# Nouveau fichier du jour horodaté à la date du lancement du script
echo "timestamp,model,sales" > "$OUTPUT_FILE"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

log "Début de la collecte"

# --- Collecte simulée ---
for model in "${MODELS[@]}"; do
    sales=$((RANDOM % 20 + 1))
    echo "$(date +"%Y-%m-%d %H:%M:%S"),$model,$sales" >> "$OUTPUT_FILE"
done

# Fusion dans le master avec le fichier du jour 
tail -n +2 "$OUTPUT_FILE" >> "$MASTER_FILE"

# Compter lignes et colonnes pour le log
LINE_COUNT=$(wc -l < "$MASTER_FILE")
COLUMN_COUNT=$(head -n 1 "$MASTER_FILE" | awk -F',' '{print NF}')

echo "Fichier CSV chargé avec $LINE_COUNT lignes et $COLUMN_COUNT colonnes" | tee -a "$LOG_FILE"

log "Fin de la collecte"

echo "=== Collecte terminée avec succès ===" | tee -a "$LOG_FILE"
echo "=============================================="
echo "=== Fin du module de collecte ==="
echo "=============================================="
