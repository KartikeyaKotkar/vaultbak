# 10. Logging Strategy

Logs are written in an append-only format:

```

[YYYY-MM-DD HH:MM:SS] EVENT MESSAGE

```

Examples:
- BACKUP_STARTED
- ARCHIVE_CREATED
- CHECKSUM_OK
- BACKUP_SUCCESS
- RESTORE_SUCCESS

Logs are human-readable and suitable for auditing.
