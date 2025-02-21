# Stage 1
FROM              maven AS build-steps
WORKDIR           /app
COPY              ./  /app/
RUN               mvn clean package
RUN               mv target/shipping-1.0.jar shipping.jar

# In stage 1 replace the name shipping-1.0.jar as shipping.jar


FROM                openjdk:17-jdk
WORKDIR             /app
COPY               --from=build-steps /app/shipping.jar  /app/shipping.jar
COPY                run.sh  /app/
ENTRYPOINT         ["bash","/app/run.sh"]





