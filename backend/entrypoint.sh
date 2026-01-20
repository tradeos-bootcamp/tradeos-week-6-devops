#!/bin/bash
# backend/entrypoint.sh

set -e

# Ожидание базы данных
echo "⏳ Ожидание подключения к PostgreSQL..."
until pg_isready -h postgres -U ${POSTGRES_USER} -d ${POSTGRES_DB}; do
    sleep 1
done
echo "✅ PostgreSQL готов"

# Ожидание Redis
echo "⏳ Ожидание подключения к Redis..."
until redis-cli -h redis -a ${REDIS_PASSWORD} ping | grep -q "PONG"; do
    sleep 1
done
echo "✅ Redis готов"

# Применение миграций
echo "📦 Применение миграций..."
alembic upgrade head

# Сборка статических файлов
echo "🎨 Сборка статических файлов..."
python -m app.commands.collect_static

# Запуск приложения
echo "🚀 Запуск приложения..."
exec "$@"
