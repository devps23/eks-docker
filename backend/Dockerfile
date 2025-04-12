FROM                  docker.io/redhat/ubi9
RUN                   dnf install -y mysql git
RUN                   mkdir /app
WORKDIR               /app
COPY                  ./ /app/
COPY                  run.sh /app/run.sh
ENTRYPOINT            ["bash","/app/run.sh"]

