const { Sequelize } = require("sequelize");
const {
    SecretsManagerClient,
    GetSecretValueCommand
} = require("@aws-sdk/client-secrets-manager");

const region = process.env.AWS_REGION || process.env.REGION || "ap-south-1";
const secretsManager = new SecretsManagerClient({ region });

async function getDatabaseCredentials(secretId) {
    if (process.env.DB_USERNAME && process.env.DB_PASSWORD) {
        return {
            username: process.env.DB_USERNAME,
            password: process.env.DB_PASSWORD
        };
    }

    if (!secretId) {
        throw new Error("SECRET_ID or local DB_USERNAME/DB_PASSWORD must be configured.");
    }

    const data = await secretsManager.send(
        new GetSecretValueCommand({ SecretId: secretId })
    );

    if (!data.SecretString) {
        throw new Error("The database secret does not contain SecretString.");
    }

    return JSON.parse(data.SecretString);
}

async function connectDB() {
    const credentials = await getDatabaseCredentials(process.env.SECRET_ID);
    const database = process.env.DATABASE || credentials.dbname;
    const host = process.env.HOST || credentials.host;
    const port = Number(process.env.DB_PORT || credentials.port || 3306);

    if (!database || !host) {
        throw new Error("Database name and host must be configured.");
    }

    const db = new Sequelize(
        database,
        credentials.username,
        credentials.password,
        {
            host,
            port,
            dialect: "mysql",
            logging: false,
            dialectOptions: {
                connectTimeout: 25000
            },
            pool: {
                max: 2,
                min: 0,
                acquire: 28000,
                idle: 5000
            }
        }
    );

    await db.authenticate();
    console.log("Database connection established successfully.");

    return db;
}

module.exports = connectDB();
