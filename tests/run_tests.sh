#!/bin/bash
# tests/run_tests.sh
# Run this from the project root

set -e

# Setup
echo "--- Setting up test environment ---"
mkdir -p tests/data/source
mkdir -p tests/data/backup
mkdir -p tests/data/restore

# Create dummy files
echo "Hello World" > tests/data/source/file1.txt
echo "Test File 2" > tests/data/source/file2.txt
dd if=/dev/urandom of=tests/data/source/random.bin bs=1K count=10 2>/dev/null

# Create a temporary config
cat > tests/test_config.ini <<EOF
SOURCE_DIR="$(pwd)/tests/data/source"
BACKUP_DIR="$(pwd)/tests/data/backup"
MAX_BACKUPS=3
COMPRESSION=gzip
ENCRYPTION_ENABLED=false
LOG_FILE="$(pwd)/tests/test.log"
EOF

# Make sure bin/vaultbak is executable
chmod +x bin/vaultbak core/*.sh

# Run Backup
echo "--- Running Backup ---"
# We need to force one thing: bin/vaultbak expects global config or default. 
# We can export the variables directly or modify how vaultbak loads config.
# vaultbak loads ~/.vaultbak/config.ini or config/default.ini.
# Let's temporarily swap config/default.ini or just export vars if the script allows.
# looking at bin/vaultbak, it prefers ~/.vaultbak/config.ini then config/default.ini.
# But it also exports vars. If we export vars BEFORE calling it, they might be overridden by the sourcing.
# Actually, if we source the config, it overwrites.
# So let's overwrite config/default.ini temporarily or just pass a different config file if we modified the CLI to accept one.
# The CLI doesn't accept a config file arg yet.
# Let's overwrite config/default.ini for the test.

cp config/default.ini config/default.ini.bak
cp tests/test_config.ini config/default.ini

./bin/vaultbak backup

# Capture the archive name
ARCHIVE=$(ls -t tests/data/backup/backup_*.tar.gz | head -n 1)
echo "Created archive: $ARCHIVE"

# Run Verify
echo "--- Running Verify ---"
./bin/vaultbak verify "$ARCHIVE"

# Run Restore
echo "--- Running Restore ---"
# Restore to a specific folder
./bin/vaultbak restore "$ARCHIVE" "$(pwd)/tests/data/restore"

# Compare
echo "--- Comparing Source and Restore ---"
diff -r tests/data/source tests/data/restore

if [ $? -eq 0 ]; then
    echo "SUCCESS: Restored files match source."
else
    echo "FAILURE: Files do not match."
    exit 1
fi

# Cleanup
# rm config/default.ini
# mv config/default.ini.bak config/default.ini
# rm -rf tests/data

echo "--- Tests Completed Successfully ---"
