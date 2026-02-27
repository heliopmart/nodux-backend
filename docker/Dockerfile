FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw

RUN ./mvnw dependency:go-offline -B

COPY src ./src
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Criar um usuário não-root por segurança (Senior Move)
RUN addgroup -S nodux && adduser -S nodux -G nodux
USER nodux

# Copia apenas o jar final do estágio de build
COPY --from=build /app/target/*.jar app.jar

# Configurações de performance para ambientes de container
ENV JAVA_OPTS="-XX:+UseParallelGC -XX:MaxRAMPercentage=75.0"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]