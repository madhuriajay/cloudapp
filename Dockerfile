FROM eclipse-temurin:17-jdk
COPY cloudapp-1.0.1.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]