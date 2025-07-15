# ---- Image de base ------------------------------------------------------
FROM nginx:1.26-alpine

# ---- Copie du site ------------------------------------------------------
COPY . /usr/share/nginx/html

# Nginx écoute déjà sur le port 80 → rien d’autre à faire
