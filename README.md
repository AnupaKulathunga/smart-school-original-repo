# Smart School Management System

**Version**: 7.1.0
**Platform**: CodeIgniter 3 (PHP)
**License**: CodeCanyon Extended License
**Copyright**: © QDOCS

## About This Repository

This repository contains a development-ready version of Smart School Management System. It's configured to allow developers to:
- Clone and run fresh installations
- Collaborate on custom development
- Version control customizations
- Deploy to multiple environments

**IMPORTANT**: This is a CodeCanyon premium product. Ensure you have proper licensing for your use case.

---

## Quick Start

### 1. Clone Repository

```bash
git clone <repository-url>
cd Smart-School-Git-Repo
```

### 2. Set File Permissions

```bash
chmod -R 755 smart_school_src/application/config/
chmod -R 755 smart_school_src/uploads/
chmod -R 755 smart_school_src/backup/
chmod -R 755 smart_school_src/temp/
chmod -R 755 smart_school_src/backend/captcha_images/
chmod -R 755 smart_school_src/application/logs/
```

### 3. Run Web Installer

Navigate to: `http://yourdomain.com/install` or `http://localhost/smart_school_src/install`

The installer will:
1. **Check Requirements** - PHP version, extensions, permissions
2. **Database Setup** - Enter credentials, installer creates `database.php`
3. **Import Database** - Automatically imports schema and default data
4. **Create Admin** - Set admin email and password
5. **Configure System** - Updates config files automatically

**IMPORTANT**: The installer will:
- **Create** `application/config/database.php` with your credentials
- **Modify** `application/config/config.php` (sets installed = true)
- **Modify** `application/config/autoload.php` (adds required libraries)

These local modifications are intentional and should not be committed.

### 4. Set File Permissions

```bash
chmod -R 755 smart_school_src/uploads/
chmod -R 755 smart_school_src/backup/
chmod -R 755 smart_school_src/temp/
chmod -R 755 smart_school_src/backend/captcha_images/
chmod -R 755 smart_school_src/application/logs/
chmod -R 755 smart_school_src/application/config/
```

### 4. Delete Install Directory (After Installation)

For security, remove the installer:
```bash
rm -rf smart_school_src/application/controllers/install/
```

Or use the provided delete button in the installer final step.

### 5. Manage Local Configuration Changes

After installation, config files will be modified locally. Tell git to ignore these changes:

```bash
git update-index --skip-worktree smart_school_src/application/config/config.php
git update-index --skip-worktree smart_school_src/application/config/autoload.php
```

Now `git status` won't show these as modified. Your local installation remains intact when pulling updates.

**See `INSTALLER_WORKFLOW.md` for complete details on managing post-installation changes.**

---

## System Requirements

- **PHP**: 8.1 or higher
- **MySQL**: 5.5 or higher (MySQL 8 supported)
- **Web Server**: Apache with mod_rewrite OR Nginx
- **PHP Extensions**:
  - MBString
  - MySQLi
  - Fileinfo
  - GD (for image processing)
  - CURL (for payment gateways)

**MySQL Configuration**:
- Ensure `SQL_MODE` does NOT contain `ONLY_FULL_GROUP_BY`

---

## What's Included in Repository

### ✅ Included (Tracked in Git)

- **Application Code**: All controllers, models, views, libraries
- **Configuration Templates**: `database.php.example`
- **Default Assets**: Core logos, placeholders, sample images
- **Frontend Assets**: All CSS, JS, third-party plugins (89MB)
- **Database Schema**: `install/database.sql`
- **Documentation**: Setup guides and architecture docs
- **Multi-language Files**: 80+ language packs

### ❌ Excluded (NOT Tracked in Git)

- **Database.php**: Created during installation
- **User Uploads**: Student photos, documents, receipts, homework
- **Runtime Files**: Logs, cache, temporary files, backups
- **Generated Captchas**: Dynamic security images
- **Vendor Dependencies**: Some Composer-managed libraries
- **Local Configurations**: Environment-specific settings

---

## Default Images & Core Assets

The repository includes **32 core/default images** needed for minimal functionality:

- Placeholder images (`no_image.png`)
- Default avatars (male/female for students, staff, teachers)
- Sample ID card templates (backgrounds, logos, signatures)
- Default vehicle image
- Admin panel logos
- Login background images
- Certificate templates
- Print header/footer templates

**All user-generated content is excluded** to keep repository clean and protect privacy.

---

## Environment Configuration

### Development Mode

Edit `smart_school_src/index.php` line 57:
```php
define('ENVIRONMENT', 'development');
```

This will:
- Show detailed errors
- Enable database debugging
- Display helpful error messages

### Production Mode (Default)

```php
define('ENVIRONMENT', 'production');
```

This will:
- Hide error messages
- Disable debug output
- Optimize for performance

---

## Access URLs

After installation:

- **Frontend**: `http://yourdomain.com/`
- **Admin Panel**: `http://yourdomain.com/admin`
- **Student Portal**: `http://yourdomain.com/user`
- **Online Admission**: `http://yourdomain.com/online_admission`

**Default Admin Credentials** (set during installation):
- Email: (as provided during install)
- Password: (as provided during install)

---

## Directory Structure

```
smart_school_src/
├── application/          # Application logic (MVC)
│   ├── controllers/     # Controllers (Admin, User, etc.)
│   ├── models/          # Database models
│   ├── views/           # Template files
│   ├── libraries/       # Custom libraries
│   ├── config/          # Configuration files
│   └── language/        # Multi-language support
├── system/              # CodeIgniter core
├── backend/             # Frontend assets (CSS, JS, plugins)
├── uploads/             # File uploads (default images tracked)
├── backup/              # Database backups (excluded)
└── index.php            # Application entry point
```

---

## Development Workflow

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Test thoroughly in development environment

4. Commit with descriptive messages:
   ```bash
   git add .
   git commit -m "Add: Description of changes"
   ```

5. Push and create pull request:
   ```bash
   git push origin feature/your-feature-name
   ```

### Database Changes

If you modify database structure:
1. Update `install/database.sql`
2. Create migration script in `application/migrations/`
3. Document changes in commit message

### Adding New Config Files

For sensitive configs (API keys, credentials):
1. Add actual file to `.gitignore`
2. Create `.example` template with placeholders
3. Document in README

---

## Deployment

### Fresh Installation

1. Clone repository
2. Copy `database.php.example` to `database.php`
3. Run web installer or import SQL
4. Set file permissions
5. Delete install directory

### Updating Existing Installation

1. Backup database and files
2. Pull latest changes
3. Run update scripts (if any in `smart_school_update_*/`)
4. Check for config changes
5. Clear cache if needed

---

## CodeCanyon License Compliance

**Important**: This is a premium CodeCanyon product.

- **Extended License**: Required for SaaS or multi-client use
- **Regular License**: Single end product for one client
- **Purchase Code**: Needed for support and updates
- **License File**: Configure in admin panel after installation

**Do NOT**:
- Redistribute without proper license
- Remove copyright notices
- Share purchase code publicly

**License Management**:
- License configuration: Admin Panel → Settings → License
- Update license: `application/config/license.php` (configured in admin)

---

## Troubleshooting

### Installation Issues

**"Database connection failed"**
- Check database credentials in `database.php`
- Ensure MySQL server is running
- Verify database exists

**"Permission denied"**
- Run chmod commands for uploads, logs, config directories
- Ensure web server has write access

**"SQL_MODE error"**
```bash
# Add to MySQL config
sql_mode=""
# OR remove ONLY_FULL_GROUP_BY from SQL_MODE
```

### Post-Installation Issues

**"Page not found"**
- Ensure mod_rewrite is enabled (Apache)
- Check `.htaccess` exists in root
- Verify base_url in `config.php`

**"Blank page"**
- Enable development mode to see errors
- Check logs in `application/logs/`
- Verify PHP version (8.1+)

---

## Documentation

- **Installation Guide**: `documentation/index.html`
- **Architecture Guide**: `CLAUDE.md`
- **Official Documentation**: https://smart-school.in/articles
- **Support**: support@qdocs.net

---

## Security Best Practices

🔒 **Before Going Live**:

1. ✅ Change default admin password
2. ✅ Set `ENVIRONMENT` to 'production'
3. ✅ Delete `install/` directory
4. ✅ Set proper file permissions (755 for directories, 644 for files)
5. ✅ Enable HTTPS/SSL
6. ✅ Configure backup strategy
7. ✅ Keep CodeIgniter and dependencies updated
8. ✅ Configure firewall rules
9. ✅ Enable CSRF protection in `config.php`
10. ✅ Review user permissions and roles

---

## Support & Updates

- **Official Website**: https://smart-school.in
- **Support Email**: support@qdocs.net
- **Documentation**: https://smart-school.in/articles
- **Updates**: Check CodeCanyon for new versions

---

## Credits

**Developed by**: QDOCS
**Website**: https://qdocs.in
**Product Page**: CodeCanyon

---

## Version History

- **v7.1.0**: Current version
- See `CHANGELOG.md` or CodeCanyon for full history

---

**Note**: This README is for developers setting up the system. End-user documentation is available in the `documentation/` folder and online at smart-school.in.
