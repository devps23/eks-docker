FROM          docker.io/nginx:1.24
RUN           apt-get update && apt-get install unzip -y
RUN           rm -rf /usr/share/nginx/html/
WORKDIR       /tmp
ADD           curl -L -o https://expense-artifacts.s3.amazonaws.com/expense-frontend-v2.zip  /tmp/frontend.zip





# docker build -t nginx
# docker create "image-id"
# docker start "container id"