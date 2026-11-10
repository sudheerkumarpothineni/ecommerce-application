// Common Axios Instance for all API requests

import axios from "axios";

const axiosInstance = axios.create({
    baseURL: "http://localhost:5000/api",
    headers: {
        "Content-Type": "application/json"
    },
    timeout: 10000
});

export default axiosInstance;