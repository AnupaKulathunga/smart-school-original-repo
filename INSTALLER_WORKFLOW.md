# Installer Workflow Guide
# Smart School Management System

## Overview

This repository is configured to support the **installer mechanism**. Developers pull the code in "pre-install" state and run the web installer to set up the application.

---

## Pre-Install State (What's in Git)

When you clone this repository, you get:

```
✅ config.php         → installed = false
✅ autoload.php       → minimal libraries array
❌ database.php       → NOT in git (will be created)
✅ database.sql       → Schema file
✅ install/           → Web installer
```

**This is the "fresh install" state** - ready for the installer to configure.

---

## Installer Workflow

### Step 1: Developer Clones Repository

```bash
git clone <repo-url>
cd Smart-School-Git-Repo
```

### Step 2: Set File Permissions

```bash
chmod -R 755 smart_school_src/application/config/
chmod -R 755 smart_school_src/uploads/
chmod -R 755 smart_school_src/backup/
chmod -R 755 smart_school_src/temp/
chmod -R 755 smart_school_src/application/logs/
chmod -R 755 smart_school_src/backend/captcha_images/
```

### Step 3: Access Installer

Navigate to: `http://yourdomain.com/install` or `http://localhost/smart_school_src/install`

### Step 4: Installer Process

The installer will:

1. **Check Requirements**
   - PHP version (8.1+)
   - MySQL connection
   - Required PHP extensions
   - File permissions

2. **Database Configuration** (Step 2)
   - You enter database credentials
   - Installer **CREATES** `application/config/database.php`
   - Tests database connection

3. **Database Import** (Step 3)
   - Imports `install/database.sql`
   - Creates all tables
   - Adds default data
   - Creates admin user with credentials you provide

4. **Configuration Updates**
   - **MODIFIES** `config.php`: Sets `installed = true`
   - **MODIFIES** `config.php`: Sets `base_url` to your domain
   - **MODIFIES** `autoload.php`: Updates library list
   - These are **local modifications** to tracked files

5. **Completion**
   - Shows success message
   - Button to delete install directory

### Step 5: Delete Install Directory

For security:
```bash
rm -rf smart_school_src/application/controllers/install/
```

Or click the "Delete Install Directory" button in the installer.

### Step 6: Application Ready!

Access the application:
- Admin Panel: `http://yourdomain.com/admin`
- Login with credentials created during installation

---

## Post-Install State (Local)

After running the installer, your local files will be:

```
✅ config.php         → installed = true (MODIFIED)
✅ autoload.php       → full libraries array (MODIFIED)
✅ database.php       → exists with your credentials (NOT tracked)
❌ install/           → deleted for security
```

---

## Important: Local Modifications After Install

### What Gets Modified by Installer

The installer modifies these **tracked files**:

1. **`application/config/config.php`**
   ```php
   // BEFORE (in git):
   $config['installed'] = false;
   $config['base_url'] = '';

   // AFTER (local):
   $config['installed'] = true;
   $config['base_url'] = 'http://yourdomain.com/';
   ```

2. **`application/config/autoload.php`**
   ```php
   // BEFORE (in git):
   $autoload['libraries'] = array('database', 'session', 'form_validation');

   // AFTER (local):
   $autoload['libraries'] = array('email','session', 'form_validation', 'upload', 'pagination','Customlib');
   ```

### These Local Changes are INTENTIONAL

✅ Each developer has their own installation
✅ Local configs match their environment
✅ These changes should NOT be committed back

---

## Managing Local Modifications in Git

After installation, you'll have uncommitted changes to tracked files. Here's how to handle them:

### Option 1: Tell Git to Ignore Local Changes (Recommended)

After successful installation:

```bash
# Tell git to ignore future changes to these files
git update-index --skip-worktree smart_school_src/application/config/config.php
git update-index --skip-worktree smart_school_src/application/config/autoload.php

# Now git status won't show these as modified
git status
```

**To undo** (if you need to commit changes to these files):
```bash
git update-index --no-skip-worktree smart_school_src/application/config/config.php
git update-index --no-skip-worktree smart_school_src/application/config/autoload.php
```

### Option 2: Keep Seeing Changes (Manual Management)

Just be aware that `git status` will always show:
```
modified:   smart_school_src/application/config/config.php
modified:   smart_school_src/application/config/autoload.php
```

**Don't commit these changes** unless you're updating the pre-install state.

---

## Developer Workflow After Pull

When another developer pulls the repository:

```bash
# 1. Pull latest code
git pull origin main

# 2. Their local config.php and autoload.php remain unchanged
#    (if they used --skip-worktree)

# 3. New files are pulled, but installed state is preserved

# 4. They continue working with their local installation
```

---

## Resetting to Fresh Install State

If you want to start over with a fresh installation:

```bash
# 1. Remove skip-worktree (if set)
git update-index --no-skip-worktree smart_school_src/application/config/config.php
git update-index --no-skip-worktree smart_school_src/application/config/autoload.php

# 2. Reset to git version (pre-install state)
git checkout smart_school_src/application/config/config.php
git checkout smart_school_src/application/config/autoload.php

# 3. Remove database.php
rm smart_school_src/application/config/database.php

# 4. Drop and recreate database
mysql -u root -p -e "DROP DATABASE your_database; CREATE DATABASE your_database;"

# 5. Run installer again
# Navigate to: http://yourdomain.com/install
```

---

## Production Deployment

For production:

```bash
# 1. Clone repository on production server
git clone <repo-url> /var/www/html/smartschool
cd /var/www/html/smartschool

# 2. Set permissions
chmod -R 755 smart_school_src/uploads/
chmod -R 755 smart_school_src/backup/
# ... etc

# 3. Run installer via web browser
# Navigate to: https://yourdomain.com/install

# 4. Delete install directory
rm -rf smart_school_src/application/controllers/install/

# 5. Set production environment
# Edit: smart_school_src/index.php
# Line 57: define('ENVIRONMENT', 'production');

# 6. Ignore local config changes
git update-index --skip-worktree smart_school_src/application/config/config.php
git update-index --skip-worktree smart_school_src/application/config/autoload.php
```

---

## Updating Production

When pulling updates to production:

```bash
# Local config files are preserved (if using --skip-worktree)
git pull origin main

# If there are config conflicts:
git stash                    # Stash local changes
git pull origin main         # Pull updates
git stash pop                # Restore local changes

# Run any database migrations if needed
# Check smart_school_update_*/ directories
```

---

## FAQ

### Q: Why not exclude config.php and autoload.php from git?

**A:** Because they contain the **pre-install defaults** needed for the installer to work. The installer expects these files to exist in a specific state.

### Q: What if I need to update the pre-install state of config.php?

**A:**
1. Remove `--skip-worktree`
2. Reset to pre-install state
3. Make your changes
4. Commit to git
5. Other devs pull and re-run installer

### Q: Can I manually import database.sql instead of using installer?

**A:** Yes, but you must also:
1. Manually create `database.php`
2. Manually update `config.php` (set installed = true)
3. Manually update `autoload.php` (add all libraries)
4. Create admin user in database

Using the installer is **much easier and recommended**.

### Q: What if installer fails midway?

**A:**
1. Check logs: `application/logs/`
2. Reset to pre-install state (see above)
3. Drop database and recreate
4. Try installer again

### Q: Do I need to run installer on every git pull?

**No!** Only run installer once per environment:
- Each developer runs it once on their local machine
- Run it once on staging server
- Run it once on production server
- After that, just pull code updates

---

## Summary

✅ **Clone repo** → Get pre-install state
✅ **Run installer** → Creates configs, imports DB
✅ **Use `--skip-worktree`** → Ignore local config changes
✅ **Pull updates** → Local configs preserved
✅ **Delete install dir** → Security best practice

**The installer mechanism works perfectly!** Each developer gets a fresh installation that matches their environment.

---

**Questions?** Check `README.md` and `GIT_SETUP_PLAN.md` for more details.
