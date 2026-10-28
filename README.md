# Linux Shell Automation & SRE Engine (Lab 1)

[![Linux](https://img.shields.io/badge/OS-Linux%20%2F%20POSIX-orange?logo=linux)](https://kernel.org)
[![Bash](https://img.shields.io/badge/Shell-Bash%205.x-4EAA25?logo=gnu-bash)](https://gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-grade collection of POSIX and Bash automation engines for site reliability engineering, disk threshold monitoring, automated rotating backups with SHA-256 cryptographic verification, and Slack/Discord webhook alerts.

---

## 🌟 Capabilities

1. **SRE Health Audit:** Monitors CPU, Memory, and Root Disk usage against strict configurable thresholds and posts alerts to Slack/Teams webhooks on threshold breach.
2. **Rotating Backups with Cryptographic Verification:** Compresses designated paths, generates `.sha256` integrity files, and prunes older archives using strict N-day retention policies.
3. **Log Parser & Attacker IP Extractor:** Analyzes web server access logs to uncover 4xx/5xx spikes, scan attempts, and automated scrapers.

---

## 🚀 Usage

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run SRE health check
./scripts/health-monitor.sh

# Run backup cycle with 7-day retention
./scripts/backup-rotation.sh /var/log /tmp/backups 7
```

---

## 👤 Author
- **Engineer:** Rahul Motvani (DevOps / SRE / DevSecOps)
- **GitHub:** [github.com/rahulmotvani0-sketch](https://github.com/rahulmotvani0-sketch)
