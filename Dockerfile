FROM python:3.11-slim

# set working directory
WORKDIR /app

# copy repo files
COPY . /app

# install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# upgrade pip
RUN pip install --upgrade pip

# install litellm and required packages
RUN pip install --no-cache-dir \
    litellm \
    prisma \
    psycopg2-binary \
    fastapi \
    uvicorn

# environment port
ENV PORT=4000

# expose port
EXPOSE 4000

# start litellm proxy
CMD ["sh","-c","litellm --config dev_config.yaml --host 0.0.0.0 --port $PORT"]
