# Use the official OpenJDK image from Docker Hub as a base image
FROM openjdk:21-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Set the active Spring profile to 'prod'
ENV SPRING_PROFILES_ACTIVE=prod

# Copy the JAR file from your local system into the container
COPY target/account-0.0.1-SNAPSHOT.jar /app/account.jar

# Expose the port that your Spring Boot application runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "account.jar"]