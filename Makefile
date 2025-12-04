# Makefile portable pour projet Bash MLOps

.PHONY: all collect preprocess train tests init bash

# --- Variables ---
ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VENV := $(ROOT)/.venv
PYTHON := $(VENV)/bin/python3
PIP := $(VENV)/bin/pip
PYTEST := $(VENV)/bin/pytest

LOG_DIR := $(ROOT)/logs
GLOBAL_LOG := $(LOG_DIR)/pipeline.log
DATA_RAW := $(ROOT)/data/raw
DATA_PROCESSED := $(ROOT)/data/processed
MODEL_DIR := $(ROOT)/model
SCRIPTS_DIR := $(ROOT)/scripts

# --- Initialisation des dossiers ---
init:
	@mkdir -p $(LOG_DIR) $(DATA_RAW) $(DATA_PROCESSED) $(MODEL_DIR)
	@touch $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Initialisation terminée ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

# --- Pipeline complète ---
all: init collect preprocess train tests
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète terminée avec succès ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

bash: all
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète lancée via make bash ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

# --- Collecte des données ---
collect:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Lancement de la collecte des données ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && bash $(SCRIPTS_DIR)/collect.sh 2>&1 | tee -a $(GLOBAL_LOG)
	@echo "=== Collecte terminée ===" | tee -a $(GLOBAL_LOG)

# --- Prétraitement des données ---
preprocess:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Prétraitement des données ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && bash $(SCRIPTS_DIR)/preprocessed.sh 2>&1 | tee -a $(GLOBAL_LOG)
	@echo "=== Prétraitement terminé ===" | tee -a $(GLOBAL_LOG)

# --- Entraînement du modèle ---
train:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Entraînement du modèle ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && bash $(SCRIPTS_DIR)/train.sh 2>&1 | tee -a $(GLOBAL_LOG)
	@echo "=== Entraînement terminé ===" | tee -a $(GLOBAL_LOG)

# --- Tests ---
tests:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Début des tests ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && $(PYTEST) -v tests/test_collect.py 2>&1 | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && $(PYTEST) -v tests/test_preprocessed.py 2>&1 | tee -a $(GLOBAL_LOG)
	@cd $(ROOT) && . $(VENV)/bin/activate && $(PYTEST) -v tests/test_model.py 2>&1 | tee -a $(GLOBAL_LOG)
	@echo "=== Fin des tests ===" | tee -a $(GLOBAL_LOG)
