# FROM       docker.io/nginx:1.24
# RUN        apt-get update && apt-get install unzip -y
# RUN        rm -rf /usr/share/nginx/html/*
# RUN        curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
# WORKDIR    /tmp
# RUN        unzip /tmp/frontend.zip
# RUN        mkdir /usr/share/nginx/html
# WORKDIR    /usr/share/nginx/html
# RUN        /tmp/*  -d /usr/share/nginx/html


# In multi satage


FROM         docker.io/nginx:1.24 As build-stage
RUN          rm -rf /usr/share/nginx/html/*
WORKDIR      /usr/share/nginx/html
COPY         frontend/ ./


FROM          redhat/ubi9
RUN           yum install -y nginx && mkdir -p /usr/share/nginx/html && yum clean all
WORKDIR       /usr/share/nginx/html
COPY          --from=build-stage /usr/share/nginx/html/*  /usr/share/nginx/html/
EXPOSE        80
CMD           ["nginx", "-g", "daemon off;"]












