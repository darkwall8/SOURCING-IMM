# Étape 1 : Build de l'application avec Gradle
FROM gradle:8.4-jdk17 AS build

WORKDIR /app

# Copier les fichiers de configuration Gradle en premier pour le cache
COPY build.gradle .
COPY settings.gradle .
COPY gradle gradle
COPY gradle.properties* ./

# Télécharger les dépendances pour accélérer les builds futurs
RUN gradle build -x test || return 0

# Copier le code source
COPY src ./src

# Construire le JAR (sans exécuter les tests)
RUN gradle clean build -x test

# Étape 2 : Image de runtime avec Eclipse Temurin (remplace openjdk obsolète)
FROM eclipse-temurin:17-jre

WORKDIR /app

# Créer un utilisateur non-root
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Copier le JAR généré
COPY --from=build /app/build/libs/*.jar app.jar

# Exposer le port utilisé par Spring Boot
EXPOSE 8080

# Définir un profil actif par défaut
ENV SPRING_PROFILES_ACTIVE=docker

# Démarrer l'application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
