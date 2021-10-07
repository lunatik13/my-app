FROM adoptopenjdk/openjdk11:jdk-11.0.5_10-alpine as builder
WORKDIR /app
COPY . . 
RUN ./mvnw -N io.takari:maven:wrapper && ./mvnw package


FROM alpine:3.10.3
RUN apk add openjdk11
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
