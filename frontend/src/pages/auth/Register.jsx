
/*
 * File: Register.jsx
 * Purpose: Customer Registration UI, Form Validation and API Integration.
 */

import React, { useState } from "react";
import "./Register.css";
import authApi from "../../services/auth/auth.api";

const Register = () => {
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);

    const [formData, setFormData] = useState({
        first_name: "",
        last_name: "",
        email: "",
        mobile_number: "",
        password: "",
        confirm_password: "",
        terms: false
    });

    const [errors, setErrors] = useState({});
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [serverMessage, setServerMessage] = useState("");
    const [serverMessageType, setServerMessageType] = useState("");

    // Handle Input Changes
    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;

        setFormData((prev) => ({
            ...prev,
            [name]: type === "checkbox" ? checked : value
        }));

        setErrors((prev) => ({
            ...prev,
            [name]: ""
        }));

        setServerMessage("");
        setServerMessageType("");
    };

    // Handle Form Submission
    const handleSubmit = async (e) => {
        e.preventDefault();

        if (isSubmitting) return;

        const firstName = formData.first_name.trim();
        const email = formData.email.trim().toLowerCase();
        const mobile = formData.mobile_number.trim();

        const newErrors = {};

        // First Name Validation
        if (!firstName) {
            newErrors.first_name = "Please enter your first name";
        }

        // Email Validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailRegex.test(email)) {
            newErrors.email = "Please enter a valid email address";
        }

        // Mobile Number Validation
        const mobileRegex = /^\+?[1-9]\d{7,14}$/;

        if (!mobileRegex.test(mobile)) {
            newErrors.mobile_number = "Please enter a valid mobile number";
        }

        // Password Validation
        const passwordRegex =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        if (!passwordRegex.test(formData.password)) {
            newErrors.password =
                "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character";
        }

        // Confirm Password Validation
        if (!formData.confirm_password) {
            newErrors.confirm_password = "Please confirm your password";
        } else if (formData.password !== formData.confirm_password) {
            newErrors.confirm_password = "Passwords do not match";
        }

        // Terms and Conditions Validation
        if (!formData.terms) {
            newErrors.terms = "Please accept Terms and Conditions";
        }

        setErrors(newErrors);
        setServerMessage("");
        setServerMessageType("");

        // Stop Submission If Validation Fails
        if (Object.keys(newErrors).length > 0) {
            return;
        }

        // Prepare Registration Data
        const registrationData = {
            first_name: firstName,
            last_name: formData.last_name.trim(),
            email,
            mobile_number: mobile,
            password: formData.password,
            terms: formData.terms
        };

        try {
            setIsSubmitting(true);

            // Call Registration API
            const result = await authApi.registerCustomer(registrationData);

            setServerMessage(
                result.message || "Registration successful!"
            );

            setServerMessageType("success");

            console.log("Registration Response:", result);

            // Reset Form After Successful Registration
            setFormData({
                first_name: "",
                last_name: "",
                email: "",
                mobile_number: "",
                password: "",
                confirm_password: "",
                terms: false
            });

            setErrors({});
            setShowPassword(false);
            setShowConfirmPassword(false);

        } catch (error) {
            console.error("Registration API Error:", error);

            setServerMessage(
                error.response?.data?.message ||
                "Unable to connect to the server. Please try again."
            );

            setServerMessageType("error");

        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="register-page">

            {/* Left Side - Brand Section */}

            <div className="register-banner">

                <div className="banner-overlay"></div>

                <div className="banner-content">

                    <div className="brand-logo">
                        <span className="brand-icon">✦</span>
                        <span>ÉLORA</span>
                    </div>

                    <div className="banner-text">
                        <span className="banner-tagline">
                            THE ART OF EVERYDAY LIVING
                        </span>

                        <h1>
                            Discover a world
                            <br />
                            of <span>beautiful</span>
                            <br />
                            possibilities.
                        </h1>

                        <p>
                            Find the things you love.
                            Experience shopping in a whole new way.
                        </p>
                    </div>

                    <div className="banner-footer">
                        <span>Curated for your lifestyle.</span>
                        <span>© 2026 ÉLORA</span>
                    </div>

                </div>
            </div>

            {/* Right Side - Registration Form */}

            <div className="register-form-section">

                <div className="register-form-container">

                    <div className="form-top">
                        <span>ALREADY A MEMBER?</span>
                        <a href="/login">Sign In</a>
                    </div>

                    <div className="form-heading">
                        <span className="form-eyebrow">
                            JOIN OUR COMMUNITY
                        </span>

                        <h2>Create your account</h2>

                        <p>
                            Create an account to explore a world
                            of exclusive experiences.
                        </p>
                    </div>

                    <form onSubmit={handleSubmit} noValidate>

                        <div className="form-row">

                            {/* First Name */}

                            <div className="form-group">
                                <label>First Name</label>

                                <input
                                    type="text"
                                    name="first_name"
                                    placeholder="Enter first name"
                                    value={formData.first_name}
                                    onChange={handleChange}
                                />

                                {errors.first_name && (
                                    <span className="error-message">
                                        {errors.first_name}
                                    </span>
                                )}
                            </div>

                            {/* Last Name */}

                            <div className="form-group">
                                <label>Last Name</label>

                                <input
                                    type="text"
                                    name="last_name"
                                    placeholder="Enter last name"
                                    value={formData.last_name}
                                    onChange={handleChange}
                                />
                            </div>

                        </div>

                        {/* Email Address */}

                        <div className="form-group">
                            <label>Email Address</label>

                            <input
                                type="email"
                                name="email"
                                placeholder="you@example.com"
                                value={formData.email}
                                onChange={handleChange}
                            />

                            {errors.email && (
                                <span className="error-message">
                                    {errors.email}
                                </span>
                            )}
                        </div>

                        {/* Mobile Number */}

                        <div className="form-group">
                            <label>Mobile Number</label>

                            <input
                                type="tel"
                                name="mobile_number"
                                placeholder="Enter mobile number"
                                value={formData.mobile_number}
                                onChange={handleChange}
                            />

                            {errors.mobile_number && (
                                <span className="error-message">
                                    {errors.mobile_number}
                                </span>
                            )}
                        </div>

                        {/* Password */}

                        <div className="form-group">
                            <label>Password</label>

                            <div className="password-input">
                                <input
                                    type={showPassword ? "text" : "password"}
                                    name="password"
                                    placeholder="Create a password"
                                    value={formData.password}
                                    onChange={handleChange}
                                />

                                <button
                                    type="button"
                                    className="password-toggle"
                                    onClick={() =>
                                        setShowPassword(!showPassword)
                                    }
                                >
                                    {showPassword ? "Hide" : "Show"}
                                </button>
                            </div>

                            {errors.password && (
                                <span className="error-message">
                                    {errors.password}
                                </span>
                            )}
                        </div>

                        {/* Confirm Password */}

                        <div className="form-group">
                            <label>Confirm Password</label>

                            <div className="password-input">
                                <input
                                    type={
                                        showConfirmPassword
                                            ? "text"
                                            : "password"
                                    }
                                    name="confirm_password"
                                    placeholder="Confirm your password"
                                    value={formData.confirm_password}
                                    onChange={handleChange}
                                />

                                <button
                                    type="button"
                                    className="password-toggle"
                                    onClick={() =>
                                        setShowConfirmPassword(
                                            !showConfirmPassword
                                        )
                                    }
                                >
                                    {showConfirmPassword ? "Hide" : "Show"}
                                </button>
                            </div>

                            {errors.confirm_password && (
                                <span className="error-message">
                                    {errors.confirm_password}
                                </span>
                            )}
                        </div>

                        {/* Terms and Conditions */}

                        <div className="terms-group">
                            <input
                                type="checkbox"
                                name="terms"
                                checked={formData.terms}
                                onChange={handleChange}
                                id="terms"
                            />

                            <label htmlFor="terms">
                                I agree to the{" "}
                                <a href="/terms">Terms & Conditions</a>
                                {" "}and{" "}
                                <a href="/privacy">Privacy Policy</a>.
                            </label>
                        </div>

                        {errors.terms && (
                            <span className="error-message terms-error">
                                {errors.terms}
                            </span>
                        )}

                        {/* Server Response Message */}

                        {serverMessage && (
                            <div className={`server-message ${serverMessageType}`}>
                                {serverMessage}
                            </div>
                        )}

                        {/* Submit Button */}

                        <button
                            type="submit"
                            className="register-button"
                            disabled={isSubmitting}
                        >
                            {isSubmitting
                                ? "Creating Account..."
                                : "Create Account"}

                            {!isSubmitting && <span>→</span>}
                        </button>

                    </form>

                    <div className="form-bottom">
                        <span>YOUR JOURNEY BEGINS HERE</span>
                    </div>

                </div>

            </div>

        </div>
    );
};

export default Register;
