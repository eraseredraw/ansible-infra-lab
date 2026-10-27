# Лаборатория: быстрая проверка стенда без ручного ввода команд.
# `make check` — синтаксис + линт, работает даже без доступных хостов.

PLAYBOOKS := $(wildcard playbooks/*.yml)
INVENTORY ?= inventory.ini

.PHONY: help syntax lint check test clean

help:
	@grep -E '^[a-z-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-8s %s\n", $$1, $$2}'

syntax: ## Проверить синтаксис всех плейбуков
	@for pb in $(PLAYBOOKS); do \
		echo "--- syntax: $$pb"; \
		ansible-playbook --syntax-check -i $(INVENTORY) $$pb || exit 1; \
	done

lint: ## Прогнать ansible-lint по плейбукам
	@ansible-lint $(PLAYBOOKS) || echo "ansible-lint not installed: pip install ansible-lint"

check: syntax lint ## Синтаксис + линт (не требует целевых хостов)

test: ## Драй-run против инвентаря (требует доступных хостов)
	@for pb in $(PLAYBOOKS); do \
		echo "--- check mode: $$pb"; \
		ansible-playbook --check --diff -i $(INVENTORY) $$pb || exit 1; \
	done

clean: ## Удалить артефакты Ansible
	@rm -f *.retry
	@find . -name '*.orig' -delete