FROM postgres:15

ENV POSTGRES_DB=sourcing
ENV POSTGRES_USER=ftd
ENV POSTGRES_PASSWORD=FTD_DEV237

COPY sourcing.dump /docker-entrypoint-initdb.d/sourcing.dump
