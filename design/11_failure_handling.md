# 11. Failure Handling

- All critical commands use exit-code checks
- Backup halts immediately on failure
- Partial backups are cleaned up
- Errors are logged with context

The system prefers **fail-fast over silent failure**.
