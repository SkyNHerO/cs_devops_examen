const { MongoClient, ObjectId } = require('mongodb');

class MongoDriver {
    constructor(config) {
        this.config = config;
    }

    async connect() {
        const uri = `mongodb://${this.config.DB_USER_NAME}:${this.config.DB_PASSWORD}@${this.config.DB_HOST}:${this.config.DB_PORT}/?authSource=admin`;

        this.client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

        try {
            await this.client.connect();
            console.log('✅ Conectado a MongoDB');

            this.db = this.client.db(this.config.DB_NAME);
            this.collection = this.db.collection('usuarios');

        } catch (error) {
            console.error('❌ Error conectando a MongoDB:', error);
        }
    }

    async getAllUsers() {
        return await this.collection.find().toArray();
    }

    async getUserById(id) {
        return await this.collection.findOne({ _id: new ObjectId(id) });
    }

    async createUser(user) {
        await this.collection.insertOne(user);

        console.log('usuario Creado mongo');
    }      
}

module.exports = MongoDriver;