#!/bin/bash

# Dossier du script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."

# Dossiers de données et logs
RAW_DIR="$ROOT/data/raw"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/collect.logs"

# Créer les dossiers si absents
mkdir -p "$RAW_DIR" "$LOG_DIR"

# Python du venv
PYTHON="$ROOT/exam_Bash_MLOps/.venv/bin/python3"

DATE=$(date +"%Y%m%d_%H%M")
OUTPUT_FILE="$RAW_DIR/sales_$DATE.csv"
MASTER_FILE="$RAW_DIR/sales_data.csv"
MODELS=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")

echo "==============================================" | tee -a "$LOG_FILE"
echo "=== Début de la collecte des données ==="  | tee -a "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"

# Création du fichier master si nécessaire
if [ ! -f "$MASTER_FILE" ]; then
    echo "timestamp,model,sales" > "$MASTER_FILE"
fi

# Nouveau fichier horodaté
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

# Fusion dans le master
tail -n +2 "$OUTPUT_FILE" >> "$MASTER_FILE"

# Comptage lignes/colonnes
LINE_COUNT=$(wc -l < "$MASTER_FILE")
COLUMN_COUNT=$(head -n 1 "$MASTER_FILE" | awk -F',' '{print NF}')

echo "Fichier CSV chargé avec $LINE_COUNT lignes et $COLUMN_COUNT colonnes" | tee -a "$LOG_FILE"

log "Fin de la collecte"

echo "==============================================" | tee -a "$LOG_FILE"
echo "=== Fin du module de collecte ===" | tee -a "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"
