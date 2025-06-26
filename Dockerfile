FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Install curl for network debugging (optional)
RUN apk add --no-cache curl

# Copy gradle wrapper and build files
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle

# Make gradlew executable
RUN chmod +x gradlew

# Download dependencies first (better caching)
RUN ./gradlew dependencies --no-daemon --refresh-dependencies || true

COPY . .

# Build with Flyway disabled - migrations should run separately
RUN ./gradlew clean bootJar --no-daemon -x test -x flywayMigrate -Dspring.flyway.enabled=false

# Use Eclipse Temurin (recommended replacement for OpenJDK)
FROM eclipse-temurin:17-jre-alpine AS runtime

RUN addgroup --system spring && adduser --system spring --ingroup spring

COPY --from=builder --chown=spring:spring /app/build/libs/*.jar app.jar

USER spring:spring

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=prod

ENTRYPOINT ["java", "-jar", "/app.jar"]