# Makefile pour le projet Bash MLOps

.PHONY: all collect preprocess train tests init

VENV = . /home/ubuntu/exam_MAMOU/exam_bash/.venv/bin/activate
GLOBAL_LOG = logs/pipeline.log


init:
	@mkdir -p logs ./data/raw ./data/processed model
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Initialisation terminée ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@touch $(GLOBAL_LOG)

all: init collect preprocess train tests
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète terminée avec succès ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

collect:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Démarrage du Pipeline avec succès ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Lancement de la collecte des données ===" | tee -a $(GLOBAL_LOG)
	$(VENV) && bash ./scripts/collect.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Collecte terminée ===" | tee -a $(GLOBAL_LOG)

preprocess:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Prétraitement des données ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	$(VENV) && bash ./scripts/preprocessed.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Prétraitement terminé ===" | tee -a $(GLOBAL_LOG)

train:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Entraînement du modèle ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	$(VENV) && bash ./scripts/train.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Entraînement terminé ===" | tee -a $(GLOBAL_LOG)

tests:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Début des tests ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	$(VENV) && pytest -v tests/test_collect.py | tee -a $(GLOBAL_LOG)
	$(VENV) && pytest -v tests/test_preprocessed.py | tee -a $(GLOBAL_LOG)
	$(VENV) && pytest -v tests/test_model.py | tee -a $(GLOBAL_LOG)
	@echo "=== Fin des tests ===" | tee -a $(GLOBAL_LOG)
