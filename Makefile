# Makefile
.PHONY: help build up down logs test deploy backup restore monitor

help:
	@echo "Доступные команды:"
	@echo "  make build        - Собрать Docker образы"
	@echo "  make up          - Запустить приложение"
	@echo "  make down        - Остановить приложение"
	@echo "  make logs        - Просмотр логов"
	@echo "  make test        - Запустить тесты"
	@echo "  make deploy      - Деплой в production"
	@echo "  make backup      - Создать backup БД"
	@echo "  make restore     - Восстановить из backup"
	@echo "  make monitor     - Запустить мониторинг"
	@echo "  make clean       - Очистить старые образы"
	@echo "  make shell       - Открыть shell в контейнере"
	@echo "  make migrate     - Применить миграции"
	@echo "  make seed        - Заполнить базу тестовыми данными"
	@echo "  make status      - Показать статус приложения"
	@echo "  make health      - Проверить здоровье сервисов"
	@echo "  make update      - Обновить приложение"
	@echo "  make production-deploy - Полный деплой в production"

build:
	docker-compose -f docker-compose.prod.yml build

up:
	docker-compose -f docker-compose.prod.yml up -d

down:
	docker-compose -f docker-compose.prod.yml down

logs:
	docker-compose -f docker-compose.prod.yml logs -f

test:
	docker-compose -f docker-compose.prod.yml run --rm backend pytest
	docker-compose -f docker-compose.prod.yml run --rm frontend npm test

deploy:
	./scripts/deploy.sh

backup:
	./scripts/backup.sh

restore:
	@read -p "Введите путь к backup файлу: " file && \
	./scripts/restore.sh $$file

monitor:
	docker-compose -f docker-compose.monitoring.yml up -d

clean:
	docker system prune -f
	docker volume prune -f

shell:
	docker-compose -f docker-compose.prod.yml exec backend bash

migrate:
	docker-compose -f docker-compose.prod.yml run --rm backend alembic upgrade head

seed:
	docker-compose -f docker-compose.prod.yml run --rm backend python -m app.commands.seed

status:
	@echo "=== Docker статус ==="
	docker-compose -f docker-compose.prod.yml ps
	@echo ""
	@echo "=== Логи последних 10 запросов ==="
	docker-compose -f docker-compose.prod.yml logs backend --tail=100 | grep "HTTP" | tail -10

cert-renew:
	docker-compose -f docker-compose.prod.yml run --rm certbot renew

health:
	curl -f http://localhost/health || echo "❌ Health check failed"
	curl -f http://localhost:8000/health || echo "❌ Backend health check failed"

update:
	git pull
	make build
	make migrate
	make up

production-deploy:
	git checkout main
	git pull
	make backup
	make build
	make migrate
	make up
	make health
