FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl unzip chromium chromium-driver && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# Run tests
CMD ["python", "run_tests.py"]
