# 4. Technology Choices

### Language
- **Bash / POSIX shell**
  - Available on all target systems
  - No runtime dependencies
  - Ideal for system-level automation

### External Tools Used
- `tar` — archiving
- `gzip` — compression
- `rsync` — snapshot-style incremental backups
- `openssl` — encryption
- `sha256sum` — integrity verification
- `date`, `find`, `stat` — system utilities

All tools are expected to be available by default on most Linux distributions.
