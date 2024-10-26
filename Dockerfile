# stage1: Build stage
FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
LABEL author="srikanth"
# current working directory
WORKDIR /app
# copy required files into current workdirectory
COPY pom.xml .
COPY src/ /app/src
# build the java code
RUN mvn clean package -DskipTests

# stage2: Runtime stage
FROM eclipse-temurin:17-jre-jammy
USER nobody
# copy jar file from build stage
COPY --from=build --chown=nobody /app/target/*.jar /app/spc.jar
WORKDIR /app
# expose port to access application
EXPOSE 8080
# start the application
ENTRYPOINT [ "java", "-jar", "spc.jar" ]
