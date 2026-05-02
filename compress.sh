#!/usr/bin/env bash
# Build files.zip from the files/ directory and ensure it's gitignored.

set -euo pipefail

cd "$(dirname "$0")"

if [ ! -d files ]; then
    echo "files/ directory not found" >&2
    exit 1
fi

# Recreate the archive each run so stale entries don't linger.
rm -f files.zip
zip -qr files.zip files

if ! grep -qxF 'files.zip' .gitignore 2>/dev/null; then
    echo 'files.zip' >> .gitignore
fi

echo "Built files.zip ($(du -h files.zip | cut -f1))"
