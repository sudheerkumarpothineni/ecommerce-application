const db = require("../../config/database");

const registerCustomer = async (data) => {

    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();

        // Check Duplicate Email or Mobile
        const duplicateQuery = `
            SELECT id, email, mobile_number
            FROM users
            WHERE email = ? OR mobile_number = ?
            LIMIT 1
        `;

        const duplicateParams = [
            data.email,
            data.mobile_number
        ];

        const [existingUsers] = await connection.execute(
            duplicateQuery,
            duplicateParams
        );

        if (existingUsers.length > 0) {
            const existingUser = existingUsers[0];

            if (existingUser.email === data.email) {
                const error = new Error("Email address already registered");
                error.statusCode = 409;
                throw error;
            }

            if (existingUser.mobile_number === data.mobile_number) {
                const error = new Error("Mobile number already registered");
                error.statusCode = 409;
                throw error;
            }
        }

        // Get Customer Department
        const departmentQuery = `
            SELECT id
            FROM departments
            WHERE department_name = ?
            AND status = ?
            LIMIT 1
        `;

        const departmentParams = ["Customer", "Active"];

        const [departments] = await connection.execute(
            departmentQuery,
            departmentParams
        );

        if (departments.length === 0) {
            const error = new Error("Customer department is not configured or inactive");
            error.statusCode = 500;
            throw error;
        }

        const departmentId = departments[0].id;

        // Get Customer Role
        const roleQuery = `
            SELECT id
            FROM roles
            WHERE role_name = ?
            AND status = ?
            LIMIT 1
        `;

        const roleParams = ["Customer", "Active"];

        const [roles] = await connection.execute(
            roleQuery,
            roleParams
        );

        if (roles.length === 0) {
            const error = new Error("Customer role is not configured or inactive");
            error.statusCode = 500;
            throw error;
        }

        const roleId = roles[0].id;

        // Insert User
        const userQuery = `
            INSERT INTO users (
                first_name,
                last_name,
                email,
                mobile_number,
                password,
                department_id,
                status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `;

        const userParams = [
            data.first_name,
            data.last_name,
            data.email,
            data.mobile_number,
            data.password,
            departmentId,
            "Pending Verification"
        ];

        const [userResult] = await connection.execute(
            userQuery,
            userParams
        );

        const userId = userResult.insertId;

        // Insert User Role Mapping
        const mappingQuery = `
            INSERT INTO user_role_mapping (
                user_id,
                role_id
            )
            VALUES (?, ?)
        `;

        const mappingParams = [
            userId,
            roleId
        ];

        await connection.execute(
            mappingQuery,
            mappingParams
        );

        // Commit Transaction
        await connection.commit();

        return {
            user_id: userId,
            first_name: data.first_name,
            last_name: data.last_name,
            email: data.email,
            mobile_number: data.mobile_number,
            status: "Pending Verification"
        };

    } catch (error) {

        await connection.rollback();

        if (error.code === "ER_DUP_ENTRY") {
            const duplicateError = new Error(
                "Email address or mobile number already registered"
            );

            duplicateError.statusCode = 409;
            throw duplicateError;
        }

        throw error;

    } finally {
        connection.release();
    }
};

module.exports = {
    registerCustomer
};