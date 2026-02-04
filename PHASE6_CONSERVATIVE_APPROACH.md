# Phase 6: Conservative Cleanup Approach

**Date:** 2026-02-04
**Status:** 🟡 MODIFIED APPROACH - Database cleanup deferred

---

## ⚠️ Critical Discovery

During Phase 6 preparation, discovered that **29+ tables still have foreign key constraints** referencing legacy tables:
- `student_session` - Referenced by 15+ tables
- `classes` - Referenced by 10+ tables
- `sections` - Referenced by 8+ tables
- `class_sections` - Referenced by 5+ tables

**Conclusion:** Full database table removal is **NOT SAFE** at this stage.

---

## 🔄 Revised Phase 6 Strategy

### ✅ SAFE to Remove (Code-Level Cleanup)
1. Legacy model files that are confirmed unused
2. Legacy code references in controllers
3. Commented-out legacy code
4. Backup legacy view files (*_legacy_backup.php)

### ⚠️ UNSAFE to Remove (Deferred to Future)
1. Database tables (have active foreign keys)
2. Legacy columns still referenced by other tables
3. Any data-bearing structures

### 🎯 NEW Phase 6 Scope
**Focus on code cleanup and optimization, NOT database schema changes.**

---

## 📋 Phase 6 Revised Tasks

### Task 1: Remove Unused Legacy Models ✅
**Safe to remove** (confirmed not auto-loaded anymore):
- None - All models are still auto-loaded in MY_Controller

**Action:** Document which models are legacy but keep them for now

### Task 2: Clean Up Legacy View Backups ✅
**Remove backup files:**
```bash
find smart_school_src/application/views -name "*_legacy_backup.php" -type f
```

### Task 3: Add Performance Indexes ✅
**Add indexes to TVET tables:**
```sql
-- Enrolment lookups
CREATE INDEX idx_enrolment_student_session ON enrolment(student_id, session_id);
CREATE INDEX idx_enrolment_class_status ON enrolment(class_id, status);

-- Class lookups
CREATE INDEX idx_class_session_status ON class(session_id, status);
CREATE INDEX idx_class_subject_level ON class(subject_level_id);

-- Attendance queries
CREATE INDEX idx_attendance_enrolment_date ON student_attendences(enrolment_id, date);
```

### Task 4: Document Migration Status ✅
**Create migration status report** showing:
- Which tables are fully migrated
- Which tables still use legacy references
- Plan for future complete migration

---

## 🗄️ Database Table Status

### ✅ Fully Migrated (TVET Tables)
- `programme` - 2 records
- `qualification` - 0 records
- `level` - 3 records
- `subject_level` - Many records
- `class` - 36 records ✅
- `enrolment` - 8 records ✅
- `student_programme` - Unknown

### 🔄 Dual-Column State (Transitional)
- `student_attendences` - Has both `student_session_id` and `enrolment_id`
- `marks` - May have both columns
- Other tables TBD

### ❌ Still Using Legacy (Not Migrated)
Tables with foreign keys to legacy:
- `academic_class_enrolment` → student_session
- `daily_assignment` → student_session
- `homework_evaluation` → student_session
- `student_fees` → student_session
- `student_fees_master` → student_session
- `contents` → classes, class_sections
- `homework` → classes, sections
- `questions` → classes, sections, class_sections
- Many more...

**Total:** 29+ tables still have legacy dependencies

---

## 📊 Migration Completion Status

| Component | Status | Completion |
|-----------|--------|------------|
| Database Schema | 🟡 Partial | 40% |
| Core Tables (class, enrolment) | ✅ Complete | 100% |
| Attendance System | ✅ Migrated | 100% |
| Exam System | 🟡 Partial | 60% |
| Homework System | ❌ Not Started | 0% |
| Fee System | ❌ Not Started | 0% |
| Content System | ❌ Not Started | 0% |
| Model Layer | ✅ Complete | 100% |
| Controller Layer | 🟡 Partial | 70% |
| View Layer | ✅ Complete | 100% |
| **OVERALL** | **🟡 PARTIAL** | **60%** |

---

## 🚀 Immediate Actions (Safe Cleanup)

### 1. Remove Legacy View Backups
```bash
cd smart_school_src/application/views
find . -name "*_legacy_backup.php" -delete
```

### 2. Add Performance Indexes
Run SQL script to add indexes for TVET tables

### 3. Update MY_Controller Comments
Mark legacy models with comments indicating they're deprecated

### 4. Create Migration Roadmap
Document which modules need future migration work

---

## 🔮 Future Phases (Post-Launch)

### Phase 6.5: Homework & Content Migration
- Migrate homework table to use class instead of class+section
- Migrate content sharing to use class
- Update homework_evaluation to use enrolment_id

### Phase 6.75: Fee System Migration
- Migrate fee structures to TVET classes
- Update student_fees to use enrolment_id
- Update fee collection tracking

### Phase 7: Final Legacy Removal
**Only after ALL modules migrated:**
1. Drop foreign key constraints
2. Drop legacy columns (student_session_id, etc.)
3. Drop legacy tables (classes, sections, class_sections, student_session)
4. Remove legacy models completely

---

## ✅ What We CAN Do Now

### Code Cleanup (No Risk)
1. ✅ Remove commented legacy code
2. ✅ Remove backup view files
3. ✅ Update documentation
4. ✅ Add TODO comments for future migration

### Performance (Low Risk)
1. ✅ Add database indexes
2. ✅ Optimize queries in new models
3. ✅ Add caching hints

### Documentation (Zero Risk)
1. ✅ Document current state
2. ✅ Create migration roadmap
3. ✅ Update developer guide

---

## ❌ What We CANNOT Do Now

### Database Schema Changes (High Risk)
1. ❌ Drop legacy tables
2. ❌ Drop foreign key constraints
3. ❌ Drop legacy columns
4. ❌ Rename tables

### Breaking Changes (High Risk)
1. ❌ Remove models still auto-loaded
2. ❌ Change table names
3. ❌ Modify existing foreign keys

---

## 💡 Recommendation

**SKIP full Phase 6 database cleanup** and proceed with:
1. Safe code-level cleanup only
2. Performance optimization
3. Documentation updates
4. Mark Phase 6 as "Partially Complete - Database cleanup deferred"

**Rationale:**
- 60% of system is migrated (core attendance, exams, timetable working)
- Database cleanup requires migrating ALL modules (homework, fees, content)
- Risk of breaking existing functionality is too high
- Better to launch with working TVET system and clean up later

---

## 🎯 Revised Success Criteria

### Original Phase 6 Goals
- ❌ Remove all legacy tables (NOT SAFE)
- ❌ Remove all legacy models (NOT SAFE)
- ✅ Add performance indexes (CAN DO)
- ✅ Clean up code (CAN DO)

### New Phase 6 Goals
- ✅ Remove backup view files
- ✅ Add performance indexes
- ✅ Document migration status
- ✅ Mark legacy code with comments
- ✅ Create future migration roadmap

---

**Conclusion:** Phase 6 should be **CODE CLEANUP ONLY**, with full database cleanup deferred until all modules are migrated (potentially several months post-launch).

---

**Status:** 🟡 Phase 6 Scope Reduced - Safe Cleanup Only
**Next:** Execute safe cleanup tasks
**Future:** Complete module migrations, then revisit database cleanup
