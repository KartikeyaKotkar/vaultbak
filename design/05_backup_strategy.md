# 5. Backup Strategy

### Backup Type
- **Snapshot-based incremental backups** using `rsync --link-dest`
- Each backup appears as a full backup
- Unchanged files are hard-linked to save space

### Backup Flow
1. Load configuration
2. Create timestamped backup directory
3. Run `rsync` from source to destination
4. Archive snapshot using `tar`
5. Compress archive
6. Encrypt archive
7. Generate SHA256 checksum
8. Write logs
9. Rotate old backups
