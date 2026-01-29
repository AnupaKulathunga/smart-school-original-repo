-- ============================================================
-- Migration 004: ZIP/Archive Upload Fix
-- ============================================================
-- Adds missing MIME types for ZIP and archive files
-- Some browsers send application/octet-stream for binary files
-- ============================================================

-- Add missing MIME types to filetypes table for better archive support
UPDATE `filetypes`
SET `file_mime` = CONCAT(`file_mime`, ', application/octet-stream, application/x-rar-compressed, application/x-7z-compressed, application/gzip')
WHERE `id` = 1
AND `file_mime` NOT LIKE '%application/octet-stream%';

-- Ensure file_extension includes common archive types
UPDATE `filetypes`
SET `file_extension` = CONCAT(`file_extension`, ', scorm')
WHERE `id` = 1
AND `file_extension` NOT LIKE '%scorm%';
