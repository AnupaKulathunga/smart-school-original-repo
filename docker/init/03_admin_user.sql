-- Create Super Admin user for Docker development
-- Login: admin@admin.com / Admin@123

INSERT INTO `staff` (`employee_id`, `name`, `surname`, `dob`, `gender`, `email`, `password`, `is_active`)
VALUES ('9000', 'Super', 'Admin', '2020-01-01', 'Male', 'admin@admin.com', '$2y$12$VZaTq91yEx6tAIhx6vGaOe0LLQTWw9wn/lQBqvoamzTD7t8/GmO.2', 1);

SET @admin_id = LAST_INSERT_ID();

INSERT INTO `staff_roles` (`staff_id`, `role_id`, `is_active`)
VALUES (@admin_id, 7, 1);

-- Create a default session
INSERT INTO `sessions` (`session`, `is_active`, `created_at`)
VALUES ('2024-25', 'no', NOW());

INSERT INTO `sessions` (`session`, `is_active`, `created_at`)
VALUES ('2025-26', 'yes', NOW());
