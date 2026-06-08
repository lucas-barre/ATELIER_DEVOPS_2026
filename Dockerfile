# Utilisation de l'image 'slim' basée sur Debian :
# - Plus légère que l'image standard (réduction de la surface d'attaque).
# - Inclut la 'glibc' (indispensable pour la compatibilité des bibliothèques C).
# - Plus stable et prévisible pour les déploiements de production que 'alpine'.

FROM python:3.12-slim

RUN useradd -m -u 1000 appuser

WORKDIR /app

COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 5000

CMD ["python", "-m", "flask", "--app", "app", "run", "--host=0.0.0.0", "--port=5000"]