FROM python:3.11-slim

# Install system dependencies for Prisma and PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev gcc openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the entire forked repository
COPY . /app

# Install the fork in editable mode with proxy dependencies
RUN pip install -e ".[proxy]"

# CRITICAL: Point Python to your pre-generated client
# This allows 'import prisma' to resolve to /app/generated/prisma
ENV PYTHONPATH="/app/generated/prisma:${PYTHONPATH}"

# Optimization for Render's 512MB RAM & read-only filesystem
ENV PRISMA_BINARY_CACHE_DIR=/tmp/prisma_cache
ENV XDG_CACHE_HOME=/tmp/xdg_cache
ENV LITELLM_MIGRATION_DIR=/tmp/migrations
RUN mkdir -p /tmp/prisma_cache /tmp/xdg_cache /tmp/migrations

EXPOSE 4000

# Start the proxy using your fork's CLI
CMD ["python3", "-m", "litellm.proxy.proxy_cli", "--port", "4000", "--config", "config.yaml"]
