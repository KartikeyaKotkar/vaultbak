# 3. System Architecture

`vaultbak` follows a **thin CLI wrapper + modular core scripts** design.

```

vaultbak
├── bin/
│   └── vaultbak          # CLI entrypoint
├── core/
│   ├── backup.sh         # Backup logic
│   ├── restore.sh        # Restore logic
│   ├── verify.sh         # Integrity verification
│   └── rotate.sh         # Old backup cleanup
├── config/
│   └── default.ini       # Default configuration
├── logs/
│   └── vaultbak.log
├── install.sh
├── uninstall.sh
└── README.md

```

Each core operation is isolated into its own script to keep logic simple and testable.
