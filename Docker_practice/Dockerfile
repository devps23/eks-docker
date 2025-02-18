FROM   nginx:1.24.0
RUN apt-get update && apt-get install -y dnf
RUN   dnf install nginx -y
RUN   rm -rf /usr/share/nginx/html
RUN   mkdir /usr/share/nginx/html
COPY  run.sh /
ENTRYPOINT ["bash","/run.sh"]

