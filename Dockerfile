# Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY producer.py .

RUN pip install redis

CMD ["python", "producer.py"]

