FROM              node As build-steps
RUN              mkdir /app
WORKDIR          /app
COPY             backend/ /app/
RUN              npm install


FROM             node:20-slim
WORKDIR          /app
COPY             --from=build-steps /app/node_modules/ node_modules
EXPOSE           8080

