# TradeOS DevOps Week 6

Production-ready DevOps инфраструктура для проекта TradeOS.

## 🎯 Цели проекта

1. **Настроить** CI/CD пайплайны с GitHub Actions
2. **Создать** multi-stage Docker образы для production
3. **Развернуть** приложение на сервере с Nginx + SSL
4. **Настроить** мониторинг с Prometheus + Grafana
5. **Реализовать** автоматическое тестирование и деплой
6. **Настроить** резервное копирование баз данных

## 📁 Структура проекта

```
tradeos-week-6-devops/
├── backend/                    # Бэкенд приложение
├── frontend/                   # Фронтенд приложение
├── k8s/                        # Kubernetes манифесты
├── monitoring/                 # Мониторинг
├── scripts/                    # Вспомогательные скрипты
├── .github/workflows/          # GitHub Actions workflows
├── docker-compose.prod.yml     # Production docker-compose
├── docker-compose.monitoring.yml # Мониторинг stack
├── Makefile                    # Управляющие команды
└── README.md
```

## 🚀 Быстрый старт

### Предварительные требования

- Docker и Docker Compose
- Python 3.11+
- Node.js 18+
- Git

### Локальный запуск

```bash
# Клонировать проект
git clone <repository-url>
cd tradeos-week-6-devops

# Создать .env файл
cp .env.example .env
# Отредактировать .env файл с вашими секретами

# Запустить приложение
make build
make up

# Применить миграции
make migrate
```

### Production деплой

```bash
# Полный production деплой
make production-deploy

# Или вручную
make backup
make build
make migrate
make up
make health
```

## 🛠️ Доступные команды

Смотрите все доступные команды:

```bash
make help
```

Основные команды:
- `make build` - Собрать Docker образы
- `make up` - Запустить приложение
- `make down` - Остановить приложение
- `make deploy` - Деплой в production
- `make backup` - Создать backup БД
- `make monitor` - Запустить мониторинг
- `make health` - Проверить здоровье сервисов

## 🔧 Настройка

### Переменные окружения

Создайте файл `.env` в корне проекта:

```bash
POSTGRES_USER=tradeos_user
POSTGRES_PASSWORD=strong_password
POSTGRES_DB=tradeos_db
SECRET_KEY=your-secret-key-here
REDIS_PASSWORD=redis_password
WORKERS=4
LOG_LEVEL=info
```

### SSL сертификаты

Для production SSL:

1. Установите Certbot
2. Настройте DNS запись для вашего домена
3. Запустите:

```bash
sudo certbot certonly --standalone -d yourdomain.com
```

## 📊 Мониторинг

Запустить стек мониторинга:

```bash
make monitor
```

Доступ к дашбордам:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)

## ☁️ Kubernetes развертывание

Для развертывания в Kubernetes:

```bash
# Применить все манифесты
kubectl apply -f k8s/

# Проверить статус
kubectl get all -n tradeos
```

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте feature ветку
3. Внесите изменения
4. Создайте Pull Request

## 📚 Документация

- [Docker документация](https://docs.docker.com/)
- [Kubernetes документация](https://kubernetes.io/docs/)
- [GitHub Actions документация](https://docs.github.com/actions)
- [Prometheus документация](https://prometheus.io/docs/)
- [Grafana документация](https://grafana.com/docs/)

## 🐛 Поддержка

При возникновении проблем:
1. Проверьте логи: `make logs`
2. Проверьте статус контейнеров: `docker-compose ps`
3. Создайте issue в репозитории

## 📄 Лицензия

MIT
