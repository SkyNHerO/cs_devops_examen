# Usamos una imagen base de Node.js
FROM node:16

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el package.json y package-lock.json
COPY package*.json ./

# Instalar las dependencias del proyecto
RUN npm install

# Copiar todo el código fuente del proyecto al contenedor
COPY . .

# Exponer el puerto 3000
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["node", "index.js"]
