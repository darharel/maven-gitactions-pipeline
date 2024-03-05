FROM maven:latest AS build
ARG VERSION=1.0.0
COPY pom.xml /app/ 
WORKDIR /app
COPY src/ /app/src

RUN mvn versions:set -DnewVersion=$VERSION -DgenerateBackupPoms=false
RUN mvn -B -DskpTests package

FROMsapmachine:21-jre-headless-ubuntu
ARG VERSION=1.0.0
COPY --from=build /app/target/my-app-$VERSION.jar /app/my-app.jar
WORKDIR /app
ENTRYPOINT ["java"]
CMD ["-jar", "my-app.jar"]