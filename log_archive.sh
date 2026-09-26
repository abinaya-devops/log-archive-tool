#!/bin/bash
LOG_DIR="$1"
echo "You entered: $LOG_DIR"
if [ -z "$1" ]; then
    echo "Usage: $0 <log-directory>"
    exit 1
fi
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist"
    exit 1
fi
ARCHIVE_DIR="./archives"
mkdir -p "$ARCHIVE_DIR"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
ARCHIVE_NAME="log_archive_$TIMESTAMP.tar.gz"
tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" -C "$LOG_DIR" . 2>/dev/null
if [ -s "$ARCHIVE_DIR/$ARCHIVE_NAME" ]; then
    LOG_FILE="$ARCHIVE_DIR/archive_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Archived $LOG_DIR to $ARCHIVE_NAME" >> "$LOG_FILE"
    echo "Archive created succesfully: $ARCHIVE_NAME"
else
    echo "Error: Archive creation failed"
    exit 1
fi
