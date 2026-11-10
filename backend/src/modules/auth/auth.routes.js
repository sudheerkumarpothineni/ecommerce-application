const express = require("express");
const authController = require("./auth.controller");

const router = express.Router();

// Customer Registration API
router.post("/register", authController.register);

module.exports = router;