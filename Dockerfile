FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir hypercorn && \
    apt-get update -qq && apt-get install -y -qq curl && \
    rm -rf /var/lib/apt/lists/*

# Copy app
COPY . .

# Create tmp directory
RUN mkdir -p tmp/uploads tmp/outputs

EXPOSE 8000

CMD ["hypercorn", "app:app", "--bind", "0.0.0.0:8000"]
