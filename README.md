# Ansible Infra Lab

[![CI](https://github.com/eraseredraw/ansible-infra-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/eraseredraw/ansible-infra-lab/actions/workflows/ci.yml)

Публичная лаборатория по Ansible: минимальные воспроизводимые стенды для проверки поведения модулей и всего цикла «плейбук → линт → driven-run → applied».

## Статус репозитория

Это **учебно-проверочный стенд**, а не production-конфигурация. Здесь нет секретов, инвентарь содержит только тестовые адреса, а плейбуки намеренно маленькие — чтобы удобно было ломать и чинить.

Рабочие плейбуки с реальным инвентарём, vault-файлами и ролями лежат в закрытых репозиториях и публично не публикуются. Так что вопрос «почему тут два плейбука» имеет простой ответ: публичный слой — это то, что показывать можно, а не то, что делалось.

## Что здесь проверяется

- Поведение модулей `apt` / `service` / `template` / `linefile` и их идемпотентность через `--check --diff`.
- Реакция на изменения: `notify` → handler `Reload nginx`, а не рестарт сервиса на каждом прогоне.
- Драйвер проверки без целевых хостов: `make syntax` и `make lint` падают на битом YAML до того, как что-то поедет на сервер.
- Пост-факт проверка результата: `uri` + `assert` подтверждают, что шаблон действительно отрендерился на сервере, а не что таск «успешно прошёл».
- Работа с сетевым оборудованием через `community.routeros.api` (отдельный connection-плагин, не SSH).

## Структура

```
inventory.ini               тестовый инвентарь (webservers, mikrotiks)
playbooks/
  setup_nginx.yml           установка Nginx + handler + smoke-test
  configure_mikrotik.yml    базовые настройки MikroTik через RouterOS API
templates/index.html.j2     шаблон, отдаваемый на сервер
Makefile                    syntax / lint / check / test / clean
.github/workflows/ci.yml    yamllint + syntax-check при каждом push
```

## Быстрый старт

```bash
pip install ansible

make check        # синтаксис + ansible-lint, хосты не нужны
make test         # --check --diff против инвентаря (нужны доступные хосты)
make help         # список целей
```

Или руками:

```bash
ansible-playbook --syntax-check -i inventory.ini playbooks/setup_nginx.yml
ansible-playbook --check --diff -i inventory.ini playbooks/setup_nginx.yml
ansible-playbook playbooks/setup_nginx.yml -i inventory.ini
```

Для MikroTik-плейбука нужна коллекция:

```bash
ansible-galaxy collection install community.routeros
```

## Локальный стенд без серверов

Прогонять есть на чем без покупки VDS — Docker подходит для обоих кейсов:

```bash
docker run -d --name nginx-test -p 8080:80  nginx:latest
# затем в inventory.ini: 127.0.0.1 ansible_port=2222 ...
# либо через ssh-сервер в контейнере, либо ansible -c local
```

## Что осознанно не сделано

- Роли и `galaxy`-структура: стенд плоский, роли начинались там, где их нельзя показать.
- `ansible-vault` с реальными секретами: в публичном репозитории секретов быть не должно.
- Метрики/отчёты (`--profile`, callback plugins) — следующий кандидат для этой лаборатории.
- CI: проверка линтом на каждом push выглядит здесь уместно.

## Стек

Ansible · YAML · Jinja2 · Nginx · Linux · MikroTik RouterOS API