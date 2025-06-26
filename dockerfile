FROM gradle:8-jdk17 AS build

WORKDIR /app

# Copier les fichiers de configuration Gradle
COPY build.gradle settings.gradle gradle.properties* ./
COPY gradle/ gradle/
COPY gradlew ./

# Rendre le wrapper exécutable
RUN chmod +x gradlew

# Télécharger les dépendances (cache)
RUN ./gradlew dependencies --no-daemon

# Copier le code source
COPY src/ src/

# Construire l'application
RUN ./gradlew clean build -x test --no-daemon

# ===== RUNTIME STAGE =====
FROM openjdk:17-slim AS runtime

WORKDIR /app

# Copier le JAR depuis l'étape de build
COPY --from=build /app/build/libs/*.jar app.jar

# Exposer le port
EXPOSE 8080

# Point d'entrée pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]