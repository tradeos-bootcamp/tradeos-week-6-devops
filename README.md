# 🚀 TradeOS Bootcamp: Week 6 - DevOps и деплой в production

## 🎯 Цели недели

1. **Настроить** CI/CD пайплайны с GitHub Actions
2. **Создать** multi-stage Docker образы для production
3. **Развернуть** приложение на сервере с Nginx + SSL
4. **Настроить** мониторинг с Prometheus + Grafana
5. **Реализовать** автоматическое тестирование и деплой
6. **Настроить** резервное копирование баз данных

---

## 📁 СТРУКТУРА ПРОЕКТА

```text
tradeos-week-6-devops/
├── backend/                         # Бэкенд приложение
│   ├── Dockerfile.prod              # Production Dockerfile
│   ├── Dockerfile.dev               # Development Dockerfile
│   ├── entrypoint.sh                # Entrypoint script
│   ├── gunicorn_conf.py             # Gunicorn конфигурация
│   └── .dockerignore                # Игнорируемые файлы для Docker
│
├── frontend/                        # Фронтенд приложение
│   ├── Dockerfile.prod              # Production Dockerfile
│   ├── nginx.conf                   # Nginx конфигурация
│   └── .dockerignore
│
├── k8s/                             # Kubernetes манифесты
│   ├── namespace.yaml               # Namespace
│   ├── configmap.yaml               # ConfigMap
│   ├── secrets.yaml                 # Secrets
│   ├── postgres/
│   │   ├── deployment.yaml          # PostgreSQL deployment
│   │   ├── service.yaml             # PostgreSQL service
│   │   └── pvc.yaml                 # Persistent Volume Claim
│   ├── redis/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── backend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── hpa.yaml                 # Horizontal Pod Autoscaler
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── ingress.yaml                 # Ingress с SSL
│
├── monitoring/                      # Мониторинг и логирование
│   ├── prometheus/
│   │   ├── prometheus.yml           # Конфигурация Prometheus
│   │   ├── rules.yml                # Alerting rules
│   │   └── alertmanager.yml         # Alertmanager конфигурация
│   ├── grafana/
│   │   ├── dashboards/              # Grafana дашборды
│   │   │   ├── tradeos-backend.json
│   │   │   ├── tradeos-frontend.json
│   │   │   └── system-metrics.json
│   │   ├── datasources.yml          # Источники данных
│   │   └── dashboard-provider.yml   # Провайдер дашбордов
│   ├── loki/                        # Логирование
│   │   ├── loki-config.yml
│   │   └── promtail-config.yml
│   └── filebeat/                    # Сбор логов
│       └── filebeat.yml
│
├── scripts/                         # Вспомогательные скрипты
│   ├── deploy.sh                    # Скрипт деплоя
│   ├── backup.sh                    # Скрипт резервного копирования
│   ├── restore.sh                   # Скрипт восстановления
│   ├── healthcheck.sh               # Health check скрипт
│   ├── migrate.sh                   # Миграции БД
│   ├── cert-renew.sh                # Обновление SSL сертификатов
│   └── cleanup.sh                   # Очистка старых ресурсов
│
├── .github/workflows/               # GitHub Actions workflows
│   ├── ci.yml                       # Continuous Integration
│   ├── cd.yml                       # Continuous Deployment
│   ├── security-scan.yml            # Security scanning
│   ├── release.yml                  # Release pipeline
│   ├── test.yml                     # Тестирование
│   └── dependabot.yml               # Автоматические обновления
│
├── terraform/                       # Infrastructure as Code
│   ├── main.tf                      # Основная конфигурация
│   ├── variables.tf                 # Переменные
│   ├── outputs.tf                   # Выводы
│   ├── providers.tf                 # Провайдеры
│   └── modules/
│       ├── vpc/                     # VPC модуль
│       ├── ec2/                     # EC2 модуль
│       ├── rds/                     # RDS модуль
│       └── eks/                     # EKS модуль
│
├── ansible/                         # Конфигурация серверов
│   ├── inventory.yml                # Инвентарь
│   ├── playbook.yml                 # Основной playbook
│   ├── roles/
│   │   ├── docker/                  # Установка Docker
│   │   ├── nginx/                   # Установка Nginx
│   │   ├── postgresql/              # Установка PostgreSQL
│   │   ├── redis/                   # Установка Redis
│   │   └── monitoring/              # Установка мониторинга
│   └── vars/
│       └── defaults.yml             # Переменные по умолчанию
│
├── docker-compose.prod.yml          # Production Docker Compose
├── docker-compose.monitoring.yml    # Мониторинг stack
├── docker-compose.test.yml          # Тестовое окружение
│
├── Makefile                         # Управляющие команды
├── .env.example                     # Пример переменных окружения
├── .dockerignore                    # Игнорируемые файлы для Docker
├── .gitignore                       # Игнорируемые файлы Git
├── .pre-commit-config.yaml          # Pre-commit хуки
├── .editorconfig                    # Конфигурация редактора
├── LICENSE                          # Лицензия проекта
└── README.md                        # Этот файл
```

---

## 🚀 БЫСТРЫЙ СТАРТ

### Вариант 1: Локальный запуск production окружения

```bash
# 1. Клонировать проект
git clone <репозиторий-week-6> tradeos-week-6-devops
cd tradeos-week-6-devops

# 2. Настроить переменные окружения
cp .env.example .env
# Отредактируйте .env файл

# 3. Запустить production stack
docker-compose -f docker-compose.prod.yml up --build

# 4. Запустить мониторинг (опционально)
docker-compose -f docker-compose.monitoring.yml up -d
```

### Вариант 2: Использование Makefile

```bash
# Показать все команды
make help

# Сборка и запуск
make build
make up

# Деплой на сервер
make deploy

# Мониторинг
make monitor

# Резервное копирование
make backup

# Тестирование
make test
```

### Вариант 3: Развертывание на VPS

```bash
# Использование скрипта деплоя
./scripts/deploy.sh

# Или ручной деплой
make production-deploy
```

---

## 📦 ТЕХНОЛОГИЧЕСКИЙ СТЕК

### **Контейнеризация и оркестрация:**

- 🐳 **Docker** - контейнеризация приложений
- 🐙 **Docker Compose** - оркестрация контейнеров
- ☸️ **Kubernetes** - production оркестрация
- 🔧 **Kustomize** - кастомизация Kubernetes манифестов

### **CI/CD и автоматизация:**

- ⚡ **GitHub Actions** - CI/CD пайплайны
- 🏗️ **Jenkins** (альтернатива) - CI/CD сервер
- 📦 **ArgoCD** - GitOps деплой
- 🔄 **FluxCD** - GitOps (альтернатива)

### **Мониторинг и логирование:**

- 📊 **Prometheus** - сбор метрик
- 📈 **Grafana** - визуализация метрик
- 📝 **Loki** - сбор логов
- 🚨 **Alertmanager** - алерты
- 🔍 **Jaeger** - трассировка

### **Infrastructure as Code:**

- 🏗️ **Terraform** - управление облачной инфраструктурой
- ⚙️ **Ansible** - конфигурация серверов
- 📋 **Packer** - создание образов

### **Базы данных и кэш:**

- 🐘 **PostgreSQL** - основная база данных
- 🧠 **Redis** - кэширование и сессии
- 💾 **TimescaleDB** - для временных рядов (мониторинг)

### **Reverse proxy и SSL:**

- 🌐 **Nginx** - reverse proxy и балансировщик нагрузки
- 🔒 **Traefik** - современный reverse proxy
- 📜 **Certbot/Let's Encrypt** - SSL сертификаты

---

## 🎯 ЗАДАНИЯ НЕДЕЛИ 6

### 🔹 **Часть 1: Production Docker образы (обязательно)**

- [ ] **1.1** Создать multi-stage Dockerfile.prod для бэкенда
- [ ] **1.2** Создать Dockerfile.prod для фронтенда с Nginx
- [ ] **1.3** Настроить Docker Compose для production
- [ ] **1.4** Реализовать health checks для всех сервисов
- [ ] **1.5** Настроить сборку с кэшированием зависимостей

### 🔹 **Часть 2: CI/CD с GitHub Actions (обязательно)**

- [ ] **2.1** Настроить CI pipeline с тестированием
- [ ] **2.2** Реализовать CD pipeline для автоматического деплоя
- [ ] **2.3** Добавить security scanning (SAST, DAST)
- [ ] **2.4** Настроить автоматическое создание релизов
- [ ] **2.5** Реализовать rollback механизм

### 🔹 **Часть 3: Деплой на сервер (обязательно)**

- [ ] **3.1** Настроить Nginx как reverse proxy
- [ ] **3.2** Настроить SSL с Let's Encrypt
- [ ] **3.3** Реализовать автоматическое обновление SSL
- [ ] **3.4** Настроить firewall и безопасность
- [ ] **3.5** Реализовать blue-green деплой

### 🔹 **Часть 4: Мониторинг (обязательно)**

- [ ] **4.1** Настроить Prometheus для сбора метрик
- [ ] **4.2** Создать Grafana дашборды
- [ ] **4.3** Настроить алерты в Alertmanager
- [ ] **4.4** Реализовать сбор логов с Loki
- [ ] **4.5** Настроить трассировку с Jaeger

### 🔹 **Часть 5: Резервное копирование (обязательно)**

- [ ] **5.1** Реализовать автоматическое backup БД
- [ ] **5.2** Настроить хранение бэкапов в S3/MinIO
- [ ] **5.3** Реализовать восстановление из backup
- [ ] **5.4** Настроить политику хранения бэкапов
- [ ] **5.5** Реализовать мониторинг бэкапов

### 🔹 **Часть 6: Kubernetes (дополнительно)**

- [ ] **6.1** Создать Kubernetes манифесты
- [ ] **6.2** Настроить Ingress с SSL
- [ ] **6.3** Реализовать Horizontal Pod Autoscaling
- [ ] **6.4** Настроить ConfigMaps и Secrets
- [ ] **6.5** Реализовать GitOps с ArgoCD

### 🔹 **Часть 7: Infrastructure as Code (дополнительно)**

- [ ] **7.1** Создать Terraform конфигурацию для облака
- [ ] **7.2** Настроить Ansible для конфигурации серверов
- [ ] **7.3** Реализовать модульную структуру
- [ ] **7.4** Настроить remote state management
- [ ] **7.5** Реализовать pipeline для инфраструктуры

---

## ✅ КРИТЕРИИ ПРОВЕРКИ (25 баллов)

### **Обязательные требования (15 баллов):**

- [ ] **3 балла** - Production Docker образы (multi-stage)
- [ ] **3 балла** - CI/CD пайплайны с GitHub Actions
- [ ] **3 балла** - Деплой на сервер с Nginx + SSL
- [ ] **3 балла** - Резервное копирование и восстановление
- [ ] **3 балла** - Базовая конфигурация мониторинга

### **Дополнительные задачи (до 10 баллов):**

- [ ] **2 балла** - Kubernetes манифесты для всех сервисов
- [ ] **2 балла** - Продвинутый мониторинг (Prometheus + Grafana)
- [ ] **2 балла** - Автоматическое обновление SSL сертификатов
- [ ] **2 балла** - Blue-green или canary деплой
- [ ] **2 балла** - Infrastructure as Code (Terraform)

**Проходной балл:** 15/25

---

## 🐳 DOCKER КОНФИГУРАЦИЯ

### Backend Dockerfile.prod

```dockerfile
# Multi-stage build для оптимизации размера образа
FROM python:3.11-slim AS builder

WORKDIR /app

# Установка системных зависимостей для сборки
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование и установка Python зависимостей
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Production образ
FROM python:3.11-slim

# Установка runtime зависимостей
RUN apt-get update && apt-get install -y \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Создание не-root пользователя
RUN groupadd -r tradeos && useradd -r -g tradeos tradeos

WORKDIR /app

# Копирование зависимостей из builder stage
COPY --from=builder /root/.local /home/tradeos/.local
COPY --from=builder /app/requirements.txt .

# Копирование кода приложения
COPY . .

# Настройка прав
RUN chown -R tradeos:tradeos /app
USER tradeos

# Путь к Python пакетам
ENV PATH=/home/tradeos/.local/bin:$PATH
ENV PYTHONPATH=/app

# Настройка переменных окружения
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Entrypoint
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

# Запуск Gunicorn
CMD ["gunicorn", "-c", "gunicorn_conf.py", "app.main:app"]
```

### Frontend Dockerfile.prod

```dockerfile
# Сборка приложения
FROM node:18-alpine AS builder

WORKDIR /app

# Установка зависимостей
COPY package*.json ./
RUN npm ci --only=production

# Копирование исходного кода
COPY . .

# Сборка проекта
RUN npm run build

# Production nginx
FROM nginx:alpine

# Копирование nginx конфигурации
COPY nginx.conf /etc/nginx/nginx.conf

# Копирование собранного приложения
COPY --from=builder /app/dist /usr/share/nginx/html

# Настройка прав
RUN chown -R nginx:nginx /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:80 || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

## ⚡ GITHUB ACTIONS WORKFLOWS

### CI Pipeline (.github/workflows/ci.yml)

```yaml
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_password
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      run: |
        cd backend
        pip install -r requirements.txt
        pip install pytest pytest-cov black flake8
    
    - name: Lint with flake8
      run: |
        cd backend
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
    
    - name: Run backend tests
      run: |
        cd backend
        pytest --cov=app --cov-report=xml --cov-report=html
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./backend/coverage.xml
        flags: unittests

  docker-build:
    needs: test
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
    
    - name: Build and push backend image
      uses: docker/build-push-action@v5
      with:
        context: ./backend
        file: ./backend/Dockerfile.prod
        push: ${{ github.event_name != 'pull_request' }}
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
```

### CD Pipeline (.github/workflows/cd.yml)

```yaml
name: CD Pipeline

on:
  push:
    branches: [ main ]
    tags: [ 'v*.*.*' ]
  workflow_dispatch:

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    permissions:
      contents: read
      packages: write
      id-token: write
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure SSH
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan -H ${{ secrets.SERVER_HOST }} >> ~/.ssh/known_hosts
    
    - name: Create .env file
      run: |
        echo "POSTGRES_USER=${{ secrets.POSTGRES_USER }}" > .env
        echo "POSTGRES_PASSWORD=${{ secrets.POSTGRES_PASSWORD }}" >> .env
        echo "POSTGRES_DB=${{ secrets.POSTGRES_DB }}" >> .env
        echo "SECRET_KEY=${{ secrets.SECRET_KEY }}" >> .env
        echo "REDIS_PASSWORD=${{ secrets.REDIS_PASSWORD }}" >> .env
        echo "WORKERS=${{ secrets.WORKERS }}" >> .env
        cat .env
    
    - name: Copy files to server
      run: |
        scp -r .env docker-compose.prod.yml backend/ frontend/ scripts/ \
          ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_HOST }}:/opt/tradeos
    
    - name: Deploy on server
      run: |
        ssh ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_HOST }} << 'EOF'
          cd /opt/tradeos
          
          # Pull latest images
          docker-compose -f docker-compose.prod.yml pull
          
          # Backup database before update
          ./scripts/backup.sh
          
          # Migrate database
          docker-compose -f docker-compose.prod.yml run --rm backend \
            alembic upgrade head
          
          # Restart services
          docker-compose -f docker-compose.prod.yml up -d --force-recreate
          
          # Cleanup old images
          docker image prune -f
          
          # Health check
          sleep 30
          curl -f http://localhost/health || exit 1
        EOF
    
    - name: Create GitHub Release
      if: startsWith(github.ref, 'refs/tags/')
      uses: softprops/action-gh-release@v1
      with:
        generate_release_notes: true
```

---

## 🐧 KUBERNETES МАНИФЕСТЫ

### Backend Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: tradeos
  labels:
    app: tradeos
    component: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: tradeos
      component: backend
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: tradeos
        component: backend
    spec:
      containers:
      - name: backend
        image: ghcr.io/tradeos-bootcamp/tradeos-backend:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: tradeos-config
              key: DATABASE_URL
        - name: SECRET_KEY
          valueFrom:
            secretKeyRef:
              name: tradeos-secrets
              key: SECRET_KEY
        - name: REDIS_URL
          valueFrom:
            configMapKeyRef:
              name: tradeos-config
              key: REDIS_URL
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: tradeos-config
              key: LOG_LEVEL
        - name: WORKERS
          valueFrom:
            configMapKeyRef:
              name: tradeos-config
              key: WORKERS
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
        startupProbe:
          httpGet:
            path: /health
            port: 8000
          failureThreshold: 30
          periodSeconds: 10
```

### Ingress с SSL

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tradeos-ingress
  namespace: tradeos
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - tradeos.example.com
    secretName: tradeos-tls
  rules:
  - host: tradeos.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend
            port:
              number: 8000
```

---

## 📊 МОНИТОРИНГ

### Prometheus конфигурация

```yaml
# monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'tradeos-backend'
    metrics_path: /metrics
    static_configs:
      - targets: ['backend:8000']
    scrape_interval: 10s
```

### Alerting rules

```yaml
# monitoring/prometheus/rules.yml
groups:
  - name: tradeos_alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} for service {{ $labels.service }}"

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down"
          description: "Service {{ $labels.instance }} has been down for more than 1 minute"
```

---

## 🛠 СКРИПТЫ

### Скрипт деплоя (scripts/deploy.sh)

```bash
#!/bin/bash

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
else
    echo "❌ Ошибка: приложение не прошло health check"
    exit 1
fi

echo "🎉 Деплой завершен успешно!"
```

### Скрипт резервного копирования (scripts/backup.sh)

```bash
#!/bin/bash

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
    
    echo "🎉 Резервное копирование завершено!"
else
    echo "❌ Ошибка при создании резервной копии"
    exit 1
fi
```

---

## 📋 MAKEFILE КОМАНДЫ

```makefile
.PHONY: help build up down logs test deploy backup restore monitor

help:
 @echo "Доступные команды:"
 @echo "  make build          - Собрать Docker образы"
 @echo "  make up             - Запустить приложение"
 @echo "  make down           - Остановить приложение"
 @echo "  make logs           - Просмотр логов"
 @echo "  make test           - Запустить тесты"
 @echo "  make deploy         - Деплой на production сервер"
 @echo "  make backup         - Создать backup БД"
 @echo "  make restore        - Восстановить из backup"
 @echo "  make monitor        - Запустить мониторинг"
 @echo "  make k8s-apply      - Применить Kubernetes манифесты"
 @echo "  make k8s-delete     - Удалить Kubernetes ресурсы"
 @echo "  make terraform-init - Инициализировать Terraform"
 @echo "  make terraform-apply - Применить Terraform конфигурацию"
 @echo "  make ansible-deploy - Развернуть с помощью Ansible"
 @echo "  make clean          - Очистить старые образы и volumes"
 @echo "  make cert-renew     - Обновить SSL сертификаты"
 @echo "  make health         - Проверить здоровье сервисов"

build:
 docker-compose -f docker-compose.prod.yml build

up:
 docker-compose -f docker-compose.prod.yml up -d

down:
 docker-compose -f docker-compose.prod.yml down

logs:
 docker-compose -f docker-compose.prod.yml logs -f

test:
 docker-compose -f docker-compose.test.yml run --rm backend pytest

deploy:
 ./scripts/deploy.sh

backup:
 ./scripts/backup.sh

restore:
 @read -p "Введите путь к backup файлу: " file && \
  ./scripts/restore.sh $$file

monitor:
 docker-compose -f docker-compose.monitoring.yml up -d

k8s-apply:
 kubectl apply -f k8s/

k8s-delete:
 kubectl delete -f k8s/

terraform-init:
 cd terraform && terraform init

terraform-apply:
 cd terraform && terraform apply -auto-approve

ansible-deploy:
 ansible-playbook -i ansible/inventory.yml ansible/playbook.yml

clean:
 docker system prune -f
 docker volume prune -f

cert-renew:
 ./scripts/cert-renew.sh

health:
 curl -f http://localhost/health || echo "❌ Health check failed"
 curl -f http://localhost:8000/health || echo "❌ Backend health check failed"

production-deploy:
 git checkout main
 git pull
 make backup
 make build
 make up
 make health

status:
 @echo "=== Docker статус ==="
 docker-compose -f docker-compose.prod.yml ps
 @echo ""
 @echo "=== Дисковое пространство ==="
 df -h
 @echo ""
 @echo "=== Использование памяти ==="
 free -h
```

---

## 🔒 БЕЗОПАСНОСТЬ

### Best practices

1. **Не хранить секреты в коде** - использовать .env и Kubernetes Secrets
2. **Использовать non-root пользователей** в Docker контейнерах
3. **Регулярно обновлять зависимости** - security patches
4. **Сканировать образы на уязвимости** - Trivy, Snyk
5. **Использовать HTTPS везде** - SSL/TLS для всего трафика
6. **Настроить firewall** - минимально необходимые порты
7. **Регулярные бэкапы** и тестирование восстановления
8. **Мониторинг безопасности** - intrusion detection

### Security scanning

```bash
# Сканирование Docker образов
docker scan <image-name>

# Сканирование зависимостей
