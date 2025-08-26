# Use Python 3.11 slim como base
FROM python:3.11-slim

# Definir diretório de trabalho
WORKDIR /app

# Instalar dependências do sistema (uma vez só)
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependências Python (uma vez só)
RUN pip install --no-cache-dir \
    fastapi==0.104.1 \
    uvicorn[standard]==0.24.0 \
    playwright==1.40.0

# Instalar Chromium do Playwright (uma vez só)
RUN playwright install chromium && \
    playwright install-deps

# Copiar o código Python
COPY worker.py .

# Expor porta
EXPOSE 8651

# Definir variáveis de ambiente
ENV PYTHONUNBUFFERED=1

# Comando para iniciar a aplicação

CMD ["uvicorn", "worker:app", "--host", "0.0.0.0", "--port", "8651"]
