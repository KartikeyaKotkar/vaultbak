# vaultbak

**Zero-dependency local backups. Done right.**

`vaultbak` is a lightweight, plug-and-play backup and restore utility for Linux-based systems (including WSL). It uses standard Unix tools you already have—`rsync`, `tar`, `gzip`, and `openssl`—to create encrypted, versioned snapshots of your data with a single command.

No cloud. No databases. No complexity. Just reliable backups.

---

## Features

- **One-command backups** — Run `vaultbak backup` and walk away.
- **Encrypted archives** — AES-256-CBC encryption via OpenSSL (optional).
- **Integrity verification** — SHA256 checksums for every archive.
- **Automatic rotation** — Old backups are pruned to save disk space.
- **Incremental snapshots** — Only changed files are copied, saving time and bandwidth.

---

## Quick Start

1.  **Configure** — Edit `config/default.ini` to set your source and backup directories.

    ```ini
    SOURCE_DIR=/path/to/your/data
    BACKUP_DIR=/path/to/backups
    ```

2.  **Backup** — Create a snapshot.

    ```bash
    ./bin/vaultbak backup
    ```

3.  **Verify** — Check archive integrity.

    ```bash
    ./bin/vaultbak verify /path/to/backups/backup_YYYYMMDD_HHMMSS.tar.gz
    ```

4.  **Restore** — Recover your data.

    ```bash
    ./bin/vaultbak restore /path/to/archive.tar.gz /destination/folder
    ```

---

## Project Structure

```
vaultbak/
├── bin/vaultbak          # CLI entrypoint
├── core/
│   ├── backup.sh         # Backup logic
│   ├── restore.sh        # Restore logic
│   ├── verify.sh         # Integrity verification
│   └── rotate.sh         # Automatic cleanup
├── config/
│   └── default.ini       # Default configuration
├── logs/                 # Operation logs
├── install.sh
└── uninstall.sh
```

---

## Configuration

Configuration is loaded from `~/.vaultbak/config.ini` or falls back to `config/default.ini`.

| Option                | Description                                      |
|-----------------------|--------------------------------------------------|
| `SOURCE_DIR`          | Directory to back up.                            |
| `BACKUP_DIR`          | Where to store backup archives.                  |
| `MAX_BACKUPS`         | Number of backups to retain before rotation.     |
| `COMPRESSION`         | Compression type (default: `gzip`).              |
| `ENCRYPTION_ENABLED`  | Enable encryption (`true`/`false`).              |
| `ENCRYPTION_KEY_PATH` | Path to the encryption key file.                 |

---

## Requirements

All tools are expected to be available on most Linux distributions by default:

- `bash`
- `rsync`
- `tar`
- `gzip`
- `openssl`
- `sha256sum`

---

## License

MIT
