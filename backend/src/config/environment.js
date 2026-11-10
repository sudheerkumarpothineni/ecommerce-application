const dotenv = require("dotenv");

dotenv.config();

const environment = {
    port: process.env.PORT,
    db: {
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        name: process.env.DB_NAME,
        port: process.env.DB_PORT
    },
    jwtSecret: process.env.JWT_SECRET
};

module.exports = environment;