#!/bin/bash
# scripts/deploy.sh
set -e

echo "🚀 Начало деплоя TradeOS..."

# Проверка переменных окружения
required_vars=(
    "POSTGRES_USER"
    "POSTGRES_PASSWORD"
    "POSTGRES_DB"
    "SECRET_KEY"
    "REDIS_PASSWORD"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Ошибка: переменная $var не установлена"
        exit 1
    fi
done

# Остановка и удаление старых контейнеров
echo "🛑 Остановка старых контейнеров..."
docker-compose -f docker-compose.prod.yml down --remove-orphans

# Сборка образов
echo "🔨 Сборка Docker образов..."
docker-compose -f docker-compose.prod.yml build

# Запуск миграций
echo "📦 Применение миграций..."
docker-compose -f docker-compose.prod.yml run --rm backend \
    alembic upgrade head

# Сборка статических файлов
echo "🎨 Сборка статических файлов..."
docker-compose -f docker-compose.prod.yml run --rm backend \
    python -m app.commands.collect_static

# Запуск приложения
echo "🚀 Запуск приложения..."
docker-compose -f docker-compose.prod.yml up -d

# Ожидание запуска сервисов
echo "⏳ Ожидание запуска сервисов..."
sleep 30

# Проверка здоровья
echo "🏥 Проверка здоровья..."
if curl -f http://localhost/health; then
    echo "✅ Приложение успешно запущено!"
    
    # Очистка старых образов
    echo "🧹 Очистка старых Docker образов..."
    docker image prune -f
    
    # Отправка уведомления
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"✅ TradeOS успешно обновлен на $(hostname)"}' \
            "$SLACK_WEBHOOK"
    fi
else
    echo "❌ Ошибка: приложение не прошло health check"
    exit 1
fi

echo "🎉 Деплой завершен успешно!"
