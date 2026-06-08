FROM python:3.7-slim

RUN useradd -m -u 1000 appuser

WORKDIR /app

COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 5000

# Adaptation : on pointe vers le module 'app'
CMD ["python", "-m", "flask", "--app", "app", "run", "--host=0.0.0.0", "--port=5000"]