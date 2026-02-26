# TODO: REFACTORING 


FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY . .

# Consideramos Maven aqui, mas pode ser ./gradlew se optar por Gradle
RUN ./mvnw clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Expondo a porta padrão da API
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]