# Ansible Infrastructure Lab

Этот репозиторий демонстрирует навыки автоматизации инфраструктуры с использованием **Ansible**. Он включает примеры настройки веб-серверов и сетевого оборудования.

## 🚀 Возможности
- Автоматическая установка и настройка **Nginx** на Linux-серверах.
- Пример интеграции с сетевым оборудованием (**MikroTik**).
- Чистая структура проекта с разделением инвентаря и плейбуков.

## 📂 Структура проекта
```text
.
├── inventory.ini          # Файл инвентаризации хостов
├── playbooks/             # Директория с плейбуками
│   ├── setup_nginx.yml    # Установка и настройка Nginx
│   └── configure_mikrotik.yml # Настройка MikroTik (пример)
└── README.md
```

## 🛠️ Как использовать

### 1. Подготовка
Убедитесь, что у вас установлен Python и Ansible:
```bash
pip install ansible
```

### 2. Настройка инвентаря
Отредактируйте файл `inventory.ini`, указав IP-адреса ваших тестовых машин и данные для подключения:
```ini
[webservers]
192.168.1.10 ansible_user=admin ansible_ssh_pass=your_password

[mikrotiks]
192.168.1.1 ansible_user=admin ansible_connection=local
```

### 3. Запуск плейбуков
Для установки Nginx:
```bash
ansible-playbook playbooks/setup_nginx.yml -i inventory.ini
```

## 🧪 Тестирование
После запуска плейбука `setup_nginx.yml` вы можете проверить работу сервера, открыв в браузере адрес вашего хоста из группы `[webservers]`. Вы должны увидеть страницу с надписью "Managed by Ansible".

## 📚 Стек технологий
- **Ansible**: Инструмент автоматизации.
- **Linux (Ubuntu/CentOS)**: Целевые ОС для веб-серверов.
- **Nginx**: Веб-сервер.
- **MikroTik RouterOS**: Пример сетевого устройства.