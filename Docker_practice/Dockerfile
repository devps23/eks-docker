FROM          docker.io/nginx:1.24
RUN           apt-get update && apt-get install unzip -y
RUN           rm -rf /usr/share/nginx/html/
WORKDIR       /tmp
RUN           curl -L -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/expense-frontend-v2.zip
RUN           mkdir -p /usr/share/nginx/html
WORKDIR       /usr/share/nginx/html
RUN           unzip /tmp/frontend.zip -d /usr/share/nginx/html





# docker build -t nginx
# docker create "image-id"
# docker start "container id"