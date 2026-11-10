USE ecommerce_db;

-- 1. Departments Table

CREATE TABLE departments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);



-- 2. Roles Table

CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);




-- 3. Permissions Table

CREATE TABLE permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);



-- 4. Users Table

CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),

    email VARCHAR(255) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    department_id BIGINT UNSIGNED NULL,

    profile_picture_url VARCHAR(500),

    status ENUM(
        'Active',
        'Inactive',
        'Suspended',
        'Pending Verification',
        'Hold'
    ) NOT NULL DEFAULT 'Pending Verification',

    email_verified_at DATETIME NULL,

    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL,

    deactivated_at DATETIME NULL,
    deleted_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_users_department
        FOREIGN KEY (department_id) REFERENCES departments(id)
);



-- 5. User Role Mapping Table

CREATE TABLE user_role_mapping (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_role_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    CONSTRAINT fk_user_role_role
        FOREIGN KEY (role_id) REFERENCES roles(id),

    CONSTRAINT uq_user_role
        UNIQUE (user_id, role_id)
);




-- 6. Role Permission Mapping Table

CREATE TABLE role_permission_mapping (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT UNSIGNED NOT NULL,
    permission_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_role_permission_role
        FOREIGN KEY (role_id) REFERENCES roles(id),

    CONSTRAINT fk_role_permission_permission
        FOREIGN KEY (permission_id) REFERENCES permissions(id),

    CONSTRAINT uq_role_permission
        UNIQUE (role_id, permission_id)
);



-- 7. User Sessions Table

CREATE TABLE user_sessions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    refresh_token_hash VARCHAR(255) NOT NULL,

    device_name VARCHAR(255),
    ip_address VARCHAR(45),

    last_active_at DATETIME NULL,
    expires_at DATETIME NOT NULL,
    revoked_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_sessions_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_user_sessions_user_id (user_id),
    INDEX idx_user_sessions_expires_at (expires_at)
);



-- 8. User Password Reset Tokens Table

CREATE TABLE user_password_reset_tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    token_hash VARCHAR(255) NOT NULL,

    expires_at DATETIME NOT NULL,
    used_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_password_reset_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_password_reset_user_id (user_id),
    INDEX idx_password_reset_expires_at (expires_at)
);


-- 9. User Email Verification Tokens Table

CREATE TABLE user_email_verification_tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    token_hash VARCHAR(255) NOT NULL,

    expires_at DATETIME NOT NULL,
    verified_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_email_verification_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_email_verification_user_id (user_id),
    INDEX idx_email_verification_expires_at (expires_at)
);



-- 10. User Login Attempts Table

CREATE TABLE user_login_attempts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NULL,

    email_or_mobile VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45),

    success BOOLEAN NOT NULL DEFAULT FALSE,

    attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_login_attempts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL,

    INDEX idx_login_attempts_user_id (user_id),
    INDEX idx_login_attempts_identifier (email_or_mobile),
    INDEX idx_login_attempts_ip (ip_address),
    INDEX idx_login_attempts_attempted_at (attempted_at)
);




-- 11. User Login History Table

CREATE TABLE user_login_history (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    ip_address VARCHAR(45),
    device_name VARCHAR(255),

    login_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    logout_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_login_history_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_login_history_user_id (user_id),
    INDEX idx_login_history_login_at (login_at)
);



-- 12. User Addresses Table

CREATE TABLE user_addresses (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    address_type ENUM('Home', 'Work', 'Other') NOT NULL DEFAULT 'Home',

    full_name VARCHAR(150) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,

    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    landmark VARCHAR(255),

    country VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_user_addresses_user_id (user_id)
);





-- 13. User Deletion Requests Table

CREATE TABLE user_deletion_requests (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at DATETIME NULL,

    status ENUM(
        'Pending',
        'Approved',
        'Rejected',
        'Completed'
    ) NOT NULL DEFAULT 'Pending',

    CONSTRAINT fk_deletion_requests_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_deletion_requests_user_id (user_id),
    INDEX idx_deletion_requests_status (status)
);




-- 14. User Notifications Table

CREATE TABLE user_notifications (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    notification_type ENUM(
        'Transactional',
        'Promotional'
    ) NOT NULL,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at DATETIME NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_notifications_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_user_notifications_user_id (user_id),
    INDEX idx_user_notifications_is_read (is_read),
    INDEX idx_user_notifications_created_at (created_at)
);




-- 15. User Notification Preferences Table

CREATE TABLE user_notification_preferences (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL UNIQUE,

    email_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    in_app_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    whatsapp_enabled BOOLEAN NOT NULL DEFAULT FALSE,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_notification_preferences_user
        FOREIGN KEY (user_id) REFERENCES users(id)
);





-- 16. Notification Logs Table

CREATE TABLE notification_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,

    channel ENUM(
        'Email',
        'In-App',
        'WhatsApp'
    ) NOT NULL,

    delivery_status ENUM(
        'Pending',
        'Sent',
        'Delivered',
        'Failed'
    ) NOT NULL DEFAULT 'Pending',

    sent_at DATETIME NULL,
    error_message TEXT NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notification_logs_user
        FOREIGN KEY (user_id) REFERENCES users(id),

    INDEX idx_notification_logs_user_id (user_id),
    INDEX idx_notification_logs_channel (channel),
    INDEX idx_notification_logs_delivery_status (delivery_status),
    INDEX idx_notification_logs_created_at (created_at)
);