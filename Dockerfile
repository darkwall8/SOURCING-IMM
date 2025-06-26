FROM gradle:8.5-jdk17 AS build

WORKDIR /app

# Copier les fichiers de configuration Gradle
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties* ./
COPY src ./src

# Construire l'application
RUN gradle clean build -x test

# Étape 2: Image de runtime
FROM openjdk:17-jre-slim

WORKDIR /app

# Créer un utilisateur non-root pour la sécurité
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Copier le JAR depuis l'étape de build
COPY --from=build /app/build/libs/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Variables d'environnement par défaut
ENV SPRING_PROFILES_ACTIVE=docker

# Point d'entrée
ENTRYPOINT ["java", "-jar", "/app/app.jar"]