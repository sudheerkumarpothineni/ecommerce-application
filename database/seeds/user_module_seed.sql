USE ecommerce_db;

-- ==========================================
-- 1. DEPARTMENTS
-- ==========================================

INSERT INTO departments (department_name, description)
VALUES
('Administration', 'Administration Department'),
('Sales', 'Sales Department'),
('Technical Support', 'Technical Support Department'),
('Accounts', 'Accounts Department'),
('Customer', 'Customer Department')
ON DUPLICATE KEY UPDATE
description = VALUES(description);


-- ==========================================
-- 2. ROLES
-- ==========================================

INSERT INTO roles (role_name, description)
VALUES
('Super Admin', 'Full application access'),
('Admin', 'Administrative access'),
('Manager', 'Department management access'),
('Employee', 'Employee access'),
('Customer', 'Customer access')
ON DUPLICATE KEY UPDATE
description = VALUES(description);


-- ==========================================
-- 3. PERMISSIONS
-- ==========================================

INSERT INTO permissions (permission_name, description)
VALUES
('CREATE_USER', 'Create new users'),
('VIEW_USER', 'View user details'),
('UPDATE_USER', 'Update user details'),
('DELETE_USER', 'Delete users'),

('CREATE_ROLE', 'Create new roles'),
('VIEW_ROLE', 'View roles'),
('UPDATE_ROLE', 'Update roles'),
('DELETE_ROLE', 'Delete roles'),

('CREATE_PERMISSION', 'Create new permissions'),
('VIEW_PERMISSION', 'View permissions'),
('UPDATE_PERMISSION', 'Update permissions'),
('DELETE_PERMISSION', 'Delete permissions'),

('CREATE_PRODUCT', 'Create products'),
('VIEW_PRODUCT', 'View products'),
('UPDATE_PRODUCT', 'Update products'),
('DELETE_PRODUCT', 'Delete products'),

('CREATE_ORDER', 'Create orders'),
('VIEW_ORDER', 'View orders'),
('UPDATE_ORDER', 'Update orders'),
('DELETE_ORDER', 'Delete orders')
ON DUPLICATE KEY UPDATE
description = VALUES(description);


-- ==========================================
-- 4. SUPER ADMIN - ALL PERMISSIONS
-- ==========================================

INSERT IGNORE INTO role_permission_mapping
(role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name = 'Super Admin';


-- ==========================================
-- 5. ADMIN - ALL PERMISSIONS
-- ==========================================

INSERT IGNORE INTO role_permission_mapping
(role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name = 'Admin';


-- ==========================================
-- 6. MANAGER PERMISSIONS
-- ==========================================

INSERT IGNORE INTO role_permission_mapping
(role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name = 'Manager'
AND p.permission_name IN (
    'VIEW_USER',
    'VIEW_PRODUCT',
    'CREATE_PRODUCT',
    'UPDATE_PRODUCT',
    'VIEW_ORDER',
    'UPDATE_ORDER'
);


-- ==========================================
-- 7. EMPLOYEE PERMISSIONS
-- ==========================================

INSERT IGNORE INTO role_permission_mapping
(role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name = 'Employee'
AND p.permission_name IN (
    'VIEW_PRODUCT',
    'VIEW_ORDER',
    'UPDATE_ORDER'
);


-- ==========================================
-- 8. CUSTOMER PERMISSIONS
-- ==========================================

INSERT IGNORE INTO role_permission_mapping
(role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name = 'Customer'
AND p.permission_name IN (
    'VIEW_PRODUCT',
    'CREATE_ORDER',
    'VIEW_ORDER'
);
