#!/bin/bash

# Définir ROOT
ROOT="/home/ubuntu/exam_MAMOU/exam_bash/exam_Bash_MLOps"
LOG_FILE="$ROOT/logs/cron.log"

# Redirection de stdout et stderr vers le fichier de log
exec >> "$LOG_FILE" 2>&1

NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "=============================================="
echo "=== Pipeline cron lancé à $NOW ==="
echo "=============================================="

# Lancer le pipeline via make bash
cd $ROOT
make bash

echo "=== Pipeline cron terminé à $(date "+%Y-%m-%d %H:%M:%S") ==="
