source /data/secrets.txt
cat /data/secrets.txt

if [ -z "${DB_HOST}" ]; then
    echo "Environment DB_HOST is missing"
    exit 1
fi

#mysql -h ${DB_HOST} -uroot -pExpenseApp@1 <schema/backend.sql
mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} <schema/backend.sql

node /app/index.js
