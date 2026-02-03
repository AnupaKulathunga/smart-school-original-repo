# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Smart School is a comprehensive School Management System built with CodeIgniter 3 (PHP framework). Version 7.1.0.

**Framework**: CodeIgniter 3 (PHP)
**Database**: MySQL 8 (mysqli driver)
**Architecture**: MVC (Model-View-Controller)

## Development Commands

### Docker Development (Recommended)

```bash
# Start all services (web, db, phpmyadmin)
docker-compose up -d

# View logs
docker-compose logs -f web

# Stop services
docker-compose down

# Reset database (destroys all data)
docker-compose down -v && docker-compose up -d

# Execute PHP in container
docker-compose exec web php -v

# Access MySQL CLI
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school
```

**Access URLs:**
- Application: http://localhost:8080
- Admin panel: http://localhost:8080/admin
- phpMyAdmin: http://localhost:8081

**Default Admin Credentials:** admin / admin123

### Database Migrations

SQL migration files are in `smart_school_src/application/migrations/`. They are auto-loaded by Docker on first run via `docker-entrypoint-initdb.d/`. For manual application:

```bash
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < smart_school_src/application/migrations/XXX_migration_name.sql
```

## Directory Structure

```
smart_school_src/
├── application/
│   ├── controllers/admin/   # Admin controllers (extend Admin_Controller)
│   ├── controllers/user/    # Student/parent portal (extend Student_Controller)
│   ├── models/              # Database models (auto-loaded in MY_Controller)
│   ├── views/admin/         # Admin panel views
│   ├── views/user/          # Student portal views
│   ├── core/MY_Controller.php  # Base controllers (MY_Controller, Admin_Controller, Student_Controller)
│   ├── libraries/           # Custom libraries (Auth, Rbac, Smsgateway, etc.)
│   ├── language/            # Multi-language support (80+ languages)
│   ├── migrations/          # SQL migration files
│   └── config/              # Configuration files
├── backend/                 # Frontend assets (CSS, JS, plugins)
└── uploads/                 # User uploaded files
```

## System Architecture

### Controller Hierarchy

Defined in `application/core/MY_Controller.php`:

- **MY_Controller** (extends CI_Controller): Base controller, auto-loads 150+ models and libraries, handles multi-language support
- **Admin_Controller** (extends MY_Controller): Admin panel controllers, handles auth via `$this->auth->is_logged_in()`, loads RBAC library
- **Student_Controller** (extends MY_Controller): Student/parent portal, includes maintenance mode check

All models are auto-loaded in MY_Controller, so use them directly: `$this->student_model->get()`

### Key Libraries

- **Auth**: Authentication and authorization
- **Rbac**: Role-based access control - use `$this->rbac->check_operation_access()` to verify permissions
- **Customlib**: Utility functions
- **Smsgateway**: SMS provider integrations
- **QDMailer**: Email handling

### Multi-Language

Language files: `application/language/[lang_code]/app_files/[module]_lang.php`

Usage: `$this->lang->line('key_name')`

## Configuration

- **Database**: `application/config/database.php` - Docker uses `smart_school` database
- **Environment**: `index.php` line 57 - set `ENVIRONMENT = 'development'` for debugging
- **Base URL**: `application/config/config.php`
- **Logs**: `application/logs/`

**Important**: MySQL SQL_MODE must not contain ONLY_FULL_GROUP_BY (handled in docker-compose.yml)

## Adding New Features

1. **Controller**: `application/controllers/admin/[Name].php` extending `Admin_Controller`
2. **Model**: `application/models/[Name]_model.php` - add to auto-load array in `MY_Controller` if used globally
3. **Views**: `application/views/admin/[module]/` - uses `layout/header.php` and `layout/footer.php`
4. **Permissions**: Use `$this->rbac->check_operation_access()` in controllers

## Development Best Practices

### Thorough Change Implementation

When fixing or modifying something, **always check ALL related places** where the same issue might exist:

1. **View Consistency**: If changing how data is displayed (e.g., list view), check detail/view pages, modals, print views, and export functions
2. **Role-Based Views**: Changes often need to be applied differently for admin vs user (student/parent) views:
   - Admin views: `application/views/admin/`
   - User views: `application/views/user/`
   - Consider what information is appropriate for each role
3. **Related Controllers**: If modifying a controller method, check related methods (list, view, edit, delete, ajax endpoints)
4. **Models**: If changing data structure, check all model methods that use that data

### Information Disclosure

- **Never expose internal IDs to end users**: Employee IDs, database IDs, and internal references should not be shown to students/parents
- **Admin vs Student data visibility**: Admin views can show more detail (employee IDs, internal codes), student views should only show what's necessary (names, dates, content)
- **Sensitive data patterns to watch**:
  - Employee IDs (e.g., `employee_id`)
  - Internal user IDs
  - System configuration values
  - Debug information
