
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Fix Windows CRLF line endings so mvnw runs on Linux
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw

RUN ./mvnw dependency:go-offline -B --no-transfer-progress

COPY src ./src

RUN ./mvnw clean package -DskipTests -B --no-transfer-progress

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/hospital-0.0.1-SNAPSHOT.jar"]
