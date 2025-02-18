#!/bin/bash
echo "Esperando a que la base de datos esté lista..."

# Verificar que el archivo .env existe
if [ ! -f .env ]; then
    echo "Error: No se encontró el archivo .env"
    exit 1
fi

# Cargar variables del .env
export $(grep -v '^#' .env | xargs -d '\n')

if [ -z "$MY_DATABASE_DRIVER" ]; then
    echo "Error: No se ha definido MY_DATABASE_DRIVER."
    exit 1
fi

if [ "$MY_DATABASE_DRIVER" == "mongo" ]; then
    until mongosh --host "$DB_HOST" --eval "print('Esperando a que levante mongo..')" &>/dev/null; do
        sleep 3
    done

    exec mongosh --host "$DB_HOST" <<EOF
use $DB_NAME
db.usuarios.insertMany($(cat /data/mongo.json))
EOF

    echo "Datos importados correctamente en MongoDB"

elif [ "$MY_DATABASE_DRIVER" == "mysql" ]; then
    until docker exec mysql mysqladmin ping -h"$DB_HOST" --silent; do
        sleep 3
    done

    docker exec -i mysql sh -c "mysql -h '$DB_HOST' -u '$DB_USER_NAME' --password='$DB_PASSWORD' $DB_NAME < /tmp/mysql_data.sql"

    echo "Datos importados correctamente en MySQL"

elif [ "$MY_DATABASE_DRIVER" == "postgres" ]; then
    until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER_NAME"; do
        sleep 3
    done

    PGPASSWORD="$DB_PASSWORD" exec psql -h "$DB_HOST" -U "$DB_USER_NAME" -d "$DB_NAME" -f /data/postgres_data.sql
    echo "Datos importados correctamente en PostgreSQL"

else
    echo "Error: No se ha definido un motor de base de datos válido en MY_DATABASE_DRIVER."
    exit 1
fi

# **********************************************************
# **********************************************************

# #!/bin/bash

# # esperar a la db que finalice de levantarse
# until mongosh --host mongo --eval "print('Esperando a que levante mongo..')" &> /dev/null; do
#     sleep 3
# done

# mongosh --host mongo <<EOF
# use database
# db.usuarios.insertMany($(cat /data/data.json))
# EOF

# echo "Datos importados correctamente"