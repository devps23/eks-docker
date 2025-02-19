FROM mysql:8.0

# Set the root password (the equivalent of `--set-root-pass`)
ENV MYSQL_ROOT_PASSWORD=ExpenseApp@1
ENV MYSQL_DATABASE=transactions
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=ExpenseApp@1

COPY sql.sh /docker-entrypoint-initdb.d/
# Expose MySQL port (default is 3306)
EXPOSE 3306


