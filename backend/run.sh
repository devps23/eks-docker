source /data/secrets.txt
cat /data/secrets.txt

if [ -z "${DB_HOST}" ]; then
    echo "Environment DB_HOST is missing"
    exit 1
fi

if [ -z "${DB_USER}" ]; then
  echo "Environment DB_USER is missing"
  exit 1
fi

if [ -z "${DB_PASSWORD}" ]; then
    echo "Environment DB_PASSWORD is missing"
    exit 1
fi

# cloning the repo
echo ${project_name}-${component}
git clone https://github.com/devps23/${project_name}-${component}
cd ${project_name}-${component}
if [ ${db_type} == "mysql" ]; then
    #mysql -h ${DB_HOST} -uroot -pExpenseApp@1 <schema/backend.sql
    mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} <schema/backend.sql
fi

# add db_type in values.yaml
# pass db_type dynamically
# here add DB_HOST,DB_USER,DB_PASSWORD  in vault


node /app/index.js
