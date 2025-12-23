# vaultbak

`vaultbak` is a plug-and-play local backup and restore utility designed for Linux-based systems (including WSL).
It focuses on simplicity, reliability, and zero external dependencies, using standard Unix tools.

## Structure

- `bin/`: CLI entrypoint
- `core/`: Logic scripts (backup, restore, verify, rotate)
- `config/`: Configuration files
- `logs/`: Operation logs

## Usage

```bash
./bin/vaultbak backup
```
