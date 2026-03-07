FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install --no-cache-dir \
    "litellm[proxy]" \
    prisma \
    psycopg2-binary

ENV PORT=7860

EXPOSE 7860

CMD ["sh","-c","litellm --config dev_config.yaml --host 0.0.0.0 --port $PORT"]
