// Authentication Module API Services

import axiosInstance from "../api/axiosInstance";

// Customer Registration API
const registerCustomer = async (registrationData) => {
    const response = await axiosInstance.post(
        "/auth/register",
        registrationData
    );

    return response.data;
};

const authApi = {
    registerCustomer
};

export default authApi;