FROM gradle:8-jdk17 AS build

WORKDIR /app

# Copie des fichiers de configuration gradle pour le cache
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties* ./

# Rendre le wrapper exécutable
RUN chmod +x gradlew

# Précharger les dépendances (facultatif mais utile)
RUN ./gradlew dependencies --no-daemon || return 0

# Copier le code source
COPY src ./src

# Construire le jar avec les classes JOOQ déjà générées
RUN ./gradlew clean bootJar -x test --no-daemon

# ===== RUNTIME STAGE =====
FROM openjdk:17-slim AS runtime

WORKDIR /app

# Copier le JAR depuis l'étape de build
COPY --from=build /app/build/libs/*.jar app.jar

# Exposer le port
EXPOSE 8080

# Point d'entrée pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]