FROM                       docker.io/bitnami/mysql
ENV                        MYSQL_ROOT_PASSWORD=ExpenseApp@1
ENV                        MYSQL_DATABASE=transactions
ENV                        MYSQL_USER=root
ENV                        MYSQL_PASSWORD=ExpenseApp@1
RUN                        mkdir /app
WORKDIR                    /app
COPY                       set_mysql_pass.sh  /app/set_mysql_pass.sh
ENTRYPOINT                 ["bash","/app/set_mysql_pass.sh"]



# by default mysql-server exists in  bitnami/mysql
# RUN                        apt-get update && apt-get install -y mysql-server