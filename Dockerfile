FROM python:3.12

WORKDIR /app

# Install system deps for building lxml from source
# (pre-built wheels cause SIGILL on some CPUs like Celeron N5105)
RUN apt-get update -qq && apt-get install -y -qq \
    libxml2-dev libxslt1-dev gcc g++ && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies (force-source-build lxml to match CPU)
COPY requirements.txt .
RUN pip install --no-cache-dir \
    --no-binary lxml \
    --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip

# Copy app
COPY . .

# Create tmp directory
RUN mkdir -p tmp/uploads tmp/outputs

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
