#!/bin/bash
# This is a script to do a health check on system resources and alert if anything is above the threshold

# Script portion for the disk space
# Command saved as a variable to get the disk usage results
DISK_USAGE=$(df -h | grep -w '/' | awk '{print $5}' | tr -d '%')
DISK_LIMIT=90
# Ensure local logs directory exists
mkdir -p logs
LOG_FILE="logs/system_alerts.log"

# This is to compare the 2 variables to print the messages, we use the () for command substitution to run both commands at the same time
if [ $DISK_USAGE -ge $DISK_LIMIT ]; then
	echo "Warning: Disk space is close to being full! Current usage: ${DISK_USAGE}% ($(date))" | tee -a "$LOG_FILE"
else
	echo "Disk space is good and below limit. Current usage: ${DISK_USAGE}% ($(date))" | tee -a "$LOG_FILE"
fi
# Script portion for the memory 
# Commands to get memory data
MEM_TOTAL=$(free -m | grep "Mem" | awk '{print $2}')
MEM_USED=$(free -m | grep "Mem" | awk '{print $3}')
# Command to get  memory percentage
MEM_PERCENT=$(( MEM_USED * 100 / MEM_TOTAL ))
MEM_LIMIT=90

# This is to print out the mssage of about the memory usage
if [ $MEM_PERCENT -ge $MEM_LIMIT ]; then
	echo "Warning: Memory usage is close to max capacity! Current usage: ${MEM_PERCENT}% ($(date))" | tee -a "$LOG_FILE"
else
	echo "Memory usage is good and below limit. Current usage: ${MEM_PERCENT}% ($(date))" | tee -a "$LOG_FILE"
fi
