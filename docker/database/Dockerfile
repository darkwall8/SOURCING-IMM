# Utiliser l'image officielle PostgreSQL
FROM postgres:15

# Variables d'environnement
ENV POSTGRES_USER FTD
ENV POSTGRES_PASSWORD FTD_DEV237
ENV POSTGRES_DB sourcing

# Copier le script d'initialisation
COPY docker/database/init.sql /docker-entrypoint-initdb.d/

# Exposer le port PostgreSQL
EXPOSE 5432

# Définir le répertoire de travail
WORKDIR /var/lib/postgresql/data