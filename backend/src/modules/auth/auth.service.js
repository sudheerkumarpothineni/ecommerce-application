const bcrypt = require("bcrypt");
const authModel = require("./auth.model");

const register = async (data) => {

    const firstName = (data.first_name || "").trim();
    const lastName = (data.last_name || "").trim();
    const email = (data.email || "").trim().toLowerCase();
    const mobile = (data.mobile_number || "").trim();
    const password = data.password || "";

    // Terms and Conditions Validation
    if (data.terms !== true) {
        const error = new Error(
            "Please accept Terms and Conditions"
        );
        error.statusCode = 400;
        throw error;
    }

    // First Name Validation
    if (!firstName) {
        const error = new Error("First name is required");
        error.statusCode = 400;
        throw error;
    }

    // Email Validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailRegex.test(email)) {
        const error = new Error("Please enter a valid email address");
        error.statusCode = 400;
        throw error;
    }

    // Mobile Number Validation
    const mobileRegex = /^\+?[1-9]\d{7,14}$/;

    if (!mobileRegex.test(mobile)) {
        const error = new Error("Please enter a valid mobile number");
        error.statusCode = 400;
        throw error;
    }

    // Password Validation
    const passwordRegex =
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

    if (!passwordRegex.test(password)) {
        const error = new Error(
            "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character"
        );
        error.statusCode = 400;
        throw error;
    }

    // Hash Password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Prepare Registration Data
    const registrationData = {
        first_name: firstName,
        last_name: lastName || null,
        email,
        mobile_number: mobile,
        password: hashedPassword
    };

    // Register Customer
    return await authModel.registerCustomer(registrationData);
};

module.exports = {
    register
};