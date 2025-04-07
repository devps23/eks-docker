FROM                   docker.io/nginx:1.26
RUN                    rm -rf /usr/share/nginx/html/* && /etc/nginx/default.d/expense.conf
COPY                   ./  /usr/share/nginx/html/
COPY                   expense.conf  /etc/nginx/default.d/expense.conf




