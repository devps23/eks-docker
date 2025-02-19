FROM         redhat/ubi9:latest
RUN          dnf install -y mysql unzip npm
WORKDIR     /tmp
ADD         https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip /tmp/backend.zip
RUN         mkdir /app
WORKDIR     /app
RUN         unzip /tmp/backend.zip -d /app
RUN         npm install
COPY        backend.service /etc/systemd/system/backend.service
ENV         MYSQL_ROOT_PASSWORD=ExpenseApp@1
COPY        backend.sql /docker-entrypoint-initdb.d/
COPY        run.sh /
ENTRYPOINT  ["bash","/run.sh"]


# if container status exited then we can use
# docker run -it --entrypoint bash e8cf17a5737b(image id)
# docker run -it --entrypoint sh my-image
# docker rm $(docker ps -aq)
# docker stop $(docker ps -aq)




