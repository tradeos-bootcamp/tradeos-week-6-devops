#!/bin/bash
# scripts/backup.sh
set -e

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/tradeos_backup_$DATE.sql.gz"

echo "💾 Начало резервного копирования..."

# Создание директории для бэкапов
mkdir -p "$BACKUP_DIR"

# Резервное копирование PostgreSQL
echo "📦 Резервное копирование базы данных..."
docker-compose -f docker-compose.prod.yml exec -T postgres \
    pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$BACKUP_FILE"

# Проверка успешности бэкапа
if [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo "✅ Резервная копия создана: $BACKUP_FILE"
    
    # Удаление старых бэкапов (оставляем последние 30)
    echo "🧹 Очистка старых бэкапов..."
    find "$BACKUP_DIR" -name "tradeos_backup_*.sql.gz" -type f | sort -r | tail -n +31 | xargs rm -f
    
    # Синхронизация с удаленным хранилищем (опционально)
    if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$S3_BUCKET" ]; then
        echo "☁️ Загрузка в S3..."
        aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/backups/"
    fi
else
    echo "❌ Ошибка при создании резервной копии"
    exit 1
fi

echo "🎉 Резервное копирование завершено!"
