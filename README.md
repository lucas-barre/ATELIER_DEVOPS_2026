Pour installer les dépendances nécessaires aux tests et lancer la validation de votre code dans un nouveau Codespace, exécutez ces commandes :

```bash
pip install -r requirements-dev.txt
ruff check . --fix && pytest