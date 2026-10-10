# ── Stage 1: Build ──────────────────────────────────────
# Uses official Maven image — Maven is pre-installed, no wget needed
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml first so dependency layer is cached
COPY pom.xml ./
RUN mvn dependency:go-offline -B --no-transfer-progress

# Copy source and build the jar
COPY src ./src
RUN mvn clean package -DskipTests -B --no-transfer-progress

# ── Stage 2: Run ────────────────────────────────────────
# Uses slim JRE — smaller final image
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

COPY --from=build /app/target/hospital-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
