-- ZIP/Archive Upload Fix for Docker
-- Adds missing MIME types for ZIP and archive files

UPDATE `filetypes`
SET `file_mime` = CONCAT(`file_mime`, ', application/octet-stream, application/x-rar-compressed, application/x-7z-compressed, application/gzip')
WHERE `id` = 1
AND `file_mime` NOT LIKE '%application/octet-stream%';

UPDATE `filetypes`
SET `file_extension` = CONCAT(`file_extension`, ', scorm')
WHERE `id` = 1
AND `file_extension` NOT LIKE '%scorm%';
