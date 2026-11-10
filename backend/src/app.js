const express = require("express");
const cors = require("cors");

const authRoutes = require("./modules/auth/auth.routes");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.status(200).json({
        success: true,
        message: "E-commerce API is running"
    });
});

// Customer Registration Route
app.use("/api/auth", authRoutes);

module.exports = app;