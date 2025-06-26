FROM gradle:8-jdk17 AS build

WORKDIR /app

# Copier les fichiers de configuration Gradle
COPY build.gradle settings.gradle gradle.properties* ./
COPY gradle/ gradle/
COPY gradlew ./

# Rendre le wrapper exécutable
RUN chmod +x gradlew

# Test de base pour vérifier Gradle
RUN ./gradlew --version

# Télécharger les dépendances avec logs
RUN ./gradlew dependencies --info --no-daemon

# Copier le code source
COPY src/ src/

# Build en excluant Flyway et JOOQ (déjà fait en local)
RUN ./gradlew clean build -x test -x flywayMigrate -x generateJooq --no-daemon

# ===== RUNTIME STAGE =====
FROM openjdk:17-slim AS runtime

WORKDIR /app

# Copier le JAR depuis l'étape de build
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]