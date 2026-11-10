const authService = require("./auth.service");

const register = async (req, res) => {
    try {
        const result = await authService.register(req.body);

        return res.status(201).json({
            success: true,
            message: "Registration successful. Please verify your email.",
            data: result
        });

    } catch (error) {
        console.error("Registration Controller Error:", error.message);

        return res.status(error.statusCode || 500).json({
            success: false,
            message: error.message || "Internal Server Error"
        });
    }
};

module.exports = {
    register
};