#!/usr/bin/env bash

# ==============================================================================
# 1. DEFINE VARIABLES
# ==============================================================================
# Uses $1 if you pass a file (e.g. ./audit_log.sh /path/to/file.log)
# Defaults to /var/log/syslog if no argument is passed.
LOG_FILE="${1:-/var/log/syslog}"


# ==============================================================================
# 2. PRE-FLIGHT CHECKS (Defensive Coding)
# ==============================================================================
# Check A: Does the file exist? (-f checks if file exists)
if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log file '$LOG_FILE' not found." >&2
    exit 1
fi

# Check B: Do we have permission to read it? (-r checks read permission)
if [ ! -r "$LOG_FILE" ]; then
    echo "[ERROR] Permission denied: Cannot read '$LOG_FILE'. (Try using sudo)" >&2
    exit 1
fi


# ==============================================================================
# 3. HEADER & SUMMARY BANNER
# ==============================================================================
echo "=================================================="
echo "          SYSTEM LOG SECURITY AUDIT"
echo "  Generated: $(date)"
echo "  Target Log: $LOG_FILE"
echo "=================================================="
echo ""


# ==============================================================================
# 4. CORE EXECUTION PIPELINE
# ==============================================================================
echo "Summary of Errors/Failures Found:"
echo "--------------------------------------------------"

# Command to filter the log file
cut -d ':' -f 5- /var/log/syslog | grep -aiE -w "error|failed" | sed -E 's/[0-9a-f]{4}:[0-9a-f]{2}:[0-9a-f]{2}\.[0-9]//g' | sort | uniq -c

echo "--------------------------------------------------"
echo "Audit complete."
