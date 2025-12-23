# 7. Integrity Verification

After backup creation:
- A SHA256 checksum is generated
- Stored alongside the encrypted archive

During restore:
- Checksum is recomputed
- Restore is aborted if verification fails

This prevents silent data corruption.
