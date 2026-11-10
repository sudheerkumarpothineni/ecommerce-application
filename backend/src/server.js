const environment = require("./config/environment");
const app = require("./app");
const db = require("./config/database");

const PORT = environment.port || 5000;

const startServer = async () => {
    try {
        const connection = await db.getConnection();

        console.log("MySQL Database Connected Successfully");

        connection.release();

        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`);
        });

    } catch (error) {
        console.error("Database Connection Failed:", error.message);
        process.exit(1);
    }
};

startServer();