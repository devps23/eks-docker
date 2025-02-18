FROM   docker.io/nginx:1.24
RUN   rm -rf /usr/share/nginx/html/*
RUN   mkdir /usr/share/nginx/html
COPY  run.sh /
ENTRYPOINT ["bash","/run.sh"]

