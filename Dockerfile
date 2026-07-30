FROM python:3.12-slim

WORKDIR /app

# Install dependencies (minimal — avoid uvloop/httptools C extensions that cause SIGILL)
COPY requirements.txt .
RUN pip install --no-cache-dir \
    fastapi==0.115.0 \
    uvicorn==0.30.0 \
    python-multipart==0.0.9 \
    pillow==10.4.0 \
    lxml==5.2.0 \
    cssutils==2.11.1 \
    aiofiles==24.1.0 \
    jinja2==3.1.4 && \
    apt-get update -qq && apt-get install -y -qq curl && \
    rm -rf /var/lib/apt/lists/*

# Copy app
COPY . .

# Create tmp directory
RUN mkdir -p tmp/uploads tmp/outputs

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--loop", "asyncio", "--http", "h11", "--no-server-header"]
