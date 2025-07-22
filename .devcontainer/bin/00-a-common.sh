#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEFAULT_LOG_FILE="$SCRIPT_DIR/installation.log"

# Function to log messages with a timestamp to stdout and a file.
# Usage: logit "Your log message here" [optional_log_file]
logit() {
    local message="$1"
    local log_file="${DEFAULT_LOG_FILE}" # Use provided file or default (not '2')

    # Get current timestamp
    # ISO 8601 format: YYYY-MM-DD HH:MM:SS
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Construct the full log entry
    local log_entry="[$timestamp] $message"

    # Echo to stdout and tee to the log file (appending)
    echo "$log_entry" | tee -a "$log_file"
}
