# Multi-stage build setup (https://docs.docker.com/develop/develop-images/multistage-build/)

# Stage 1 (to create a "build" image, ~140MB)
FROM openjdk:8-jdk-alpine3.7 AS builder
RUN java -version

COPY . /app
WORKDIR /app
RUN apk --no-cache add maven && mvn --version
RUN mvn package

# Stage 2 (to create a downsized "container executable", ~87MB)
FROM openjdk:8-jre-alpine3.7
WORKDIR /root/
COPY --from=builder /app/target/my-app-1.0-SNAPSHOT.jar .

EXPOSE 8123
ENTRYPOINT ["java", "-jar", "./my-app-1.0-SNAPSHOT.jar"]
