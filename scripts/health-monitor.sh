#!/usr/bin/env bash
set -euo pipefail

# Configuration
CPU_THRESHOLD=80
MEM_THRESHOLD=85
DISK_THRESHOLD=90
ALERT_WEBHOOK="${ALERT_WEBHOOK_URL:-}"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
HOSTNAME=$(hostname)

echo "[$TIMESTAMP] Running System SRE Health Audit on $HOSTNAME..."

# 1. CPU Usage Check
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int($1)}')
CPU_USAGE=$((100 - CPU_IDLE))

# 2. Memory Usage Check
MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", ($3/$2) * 100)}')

# 3. Disk Usage Check (Root Partition)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "  -> CPU Usage:    ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
echo "  -> Memory Usage: ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)"
echo "  -> Disk Usage:   ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"

ALERT_TRIGGERED=false
ALERT_MSG="🚨 *DevOps Alert from $HOSTNAME* [$TIMESTAMP]\n"

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    ALERT_TRIGGERED=true
    ALERT_MSG="${ALERT_MSG}⚠️ High CPU Usage: ${CPU_USAGE}%\n"
fi

if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ]; then
    ALERT_TRIGGERED=true
    ALERT_MSG="${ALERT_MSG}⚠️ High Memory Usage: ${MEM_USAGE}%\n"
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    ALERT_TRIGGERED=true
    ALERT_MSG="${ALERT_MSG}⚠️ High Disk Usage: ${DISK_USAGE}%\n"
fi

if [ "$ALERT_TRIGGERED" = true ]; then
    echo "[$TIMESTAMP] CRITICAL THRESHOLD BREACHED!"
    if [ -n "$ALERT_WEBHOOK" ]; then
        curl -s -X POST -H 'Content-type: application/json' --data "{\"text\":\"$ALERT_MSG\"}" "$ALERT_WEBHOOK" || true
    fi
    exit 1
else
    echo "[$TIMESTAMP] All metrics within healthy operational limits."
fi
