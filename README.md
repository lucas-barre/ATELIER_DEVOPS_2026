# Conteneurisation / NGROK

L'objectif était de réussir une pipeline avec la création automatique d'une démo directement accessible en ligne pendant 2 minutes. 

## Explication du Dockerfile : 

-> Importation d'une image légère de Python
FROM python:3.12-slim
 
-> Environnement de travail dans le container
WORKDIR /app

-> On y déplace tous les fichiers nécessaires 
COPY . .

-> On demande à pip de nous installer `flask` et `python-dotenv`
RUN pip install --no-cache-dir flask python-dotenv 

-> Le port choisi est le `5000` 
EXPOSE 5000 

-> Réalisation de la commande pour lancer le projet 
CMD ["python", "-m", "flask", "--app", "__init__", "run", "--host=0.0.0.0", "--port=5000"]

## Explication du workflow `build-and-expose`: 

-> Sur les push directement sur Github, on déclenche ces jobs
on: [push] 

-> Build du Docker image et lancement
- name: Build Docker image
   run: docker build -t flask-app .

- name: Run container (detached)
   run: docker run -d --name flask-app -p 5000:5000 flask-app

-> Gestion de Ngrok
- name: Install Ngrok
   run: sudo snap install ngrok
- name: Start Ngrok tunnel
   env:
      NGROK_AUTHTOKEN: ${{ secrets.NGROK_AUTHTOKEN }}
      # Stocké dans le repository
   run: |
      nohup ngrok http 5000 &> /tmp/ngrok.log &
      for i in $(seq 1 10); do
      curl -s http://localhost:4040/api/tunnels | grep -q "public_url" && break
      sleep 2
      done
      # Lancement du tunnel

- name: Print public URL
   run: |
      for i in {1..15}; do
      URL=$(curl -s http://localhost:4040/api/tunnels | python3 -c "import sys,json; data=json.load(sys.stdin); print(data['tunnels'][0]['public_url'])" 2>/dev/null)
      if [ -n "$URL" ]; then
         echo "======================================"
         echo "  URL PUBLIQUE : $URL"
         echo "  Lien exercices : $URL/exercices/"
         echo "======================================"
         exit 0
      fi
      echo "En attente du tunnel..."
      sleep 2
      done
      echo "Erreur : Impossible de récupérer l'URL publique."
      exit 1
      # Montre l'url publique du tunnel

- name: Keep tunnel open (120s)
   run: sleep 120

- name: Stop container
   if: always()
   run: docker stop flask-app || true