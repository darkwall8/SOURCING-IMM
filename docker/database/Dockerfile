# Étendre l'image officielle PostgreSQL
FROM postgres:15-alpine

# Variables par défaut
ENV POSTGRES_USER=FTD
ENV POSTGRES_PASSWORD=FTD_DEV237
ENV POSTGRES_DB=sourcing

# Ajouter le script d'init
COPY init.sql /docker-entrypoint-initdb.d/init.sql
