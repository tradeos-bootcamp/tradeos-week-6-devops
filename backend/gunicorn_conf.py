# backend/gunicorn_conf.py
import multiprocessing
import os

# Количество воркеров
workers = int(os.getenv("WORKERS", multiprocessing.cpu_count() * 2 + 1))

# Путь к socket (для Nginx)
bind = os.getenv("BIND", "0.0.0.0:8000")

# Таймауты
timeout = int(os.getenv("TIMEOUT", 30))
keepalive = int(os.getenv("KEEPALIVE", 2))

# Логирование
accesslog = "-"
errorlog = "-"
loglevel = os.getenv("LOG_LEVEL", "info")

# Загрузчик приложения
worker_class = "uvicorn.workers.UvicornWorker"

# Максимальные запросы на воркер
max_requests = 1000
max_requests_jitter = 50

# Graceful shutdown
graceful_timeout = 30

# Preload приложения
preload_app = True
