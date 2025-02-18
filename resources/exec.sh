#!/bin/bash

# Cargar las variables de entorno desde el archivo .env
if [ -f /path/to/.env ]; then
    source /path/to/.env
else
    echo ".env file not found"
    exit 1
fi

# Variables
DATE=$(date +'%Y%m%d%H%M%S')
BACKUP_FILE="/tmp/${DB_NAME}_backup_${DATE}.sql"
AWS_BUCKET_PATH="apellido-alumno/database/${DATE}"

# Exportar base de datos (Ejemplo para MySQL)
mysqldump -u $DB_USER_NAME -p$DB_PASSWORD -h $DB_HOST -P $DB_PORT $DB_NAME > $BACKUP_FILE

# Subir el backup a AWS S3
aws s3 cp $BACKUP_FILE s3://$BUCKET_NAME/$AWS_BUCKET_PATH/

# Limpiar el archivo de backup local
rm $BACKUP_FILE
