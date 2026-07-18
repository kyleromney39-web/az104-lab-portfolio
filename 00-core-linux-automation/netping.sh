#!/bin/bash
# This script checks if critical network services such as the public DNS and public internet are successful.

# Commands for pinging the google DNS for internet and public DNS reachability.
ping -c 4 8.8.8.8 > /dev/null 2>&1
PING_STATUS=$?
# Logs file path (directory path must exist first, file will auto-create)
# Ensure local logs directory exists
mkdir -p logs
PING_LOGS="logs/ping_results.log"

if [ $PING_STATUS -eq 0 ]; then
	echo "Ping succeeded to reach Google Public DNS! ($(date))" | tee -a "$PING_LOGS"
else
	echo "Ping failed to reach Google Public DNS, check network settings! ($(date))" | tee -a "$PING_LOGS"
fi
