# Lynis — System Security Auditor

## What it does

Lynis scans your system and reports security findings with a priority score.
It checks: open ports, service configurations, file permissions, SSH settings,
kernel parameters, installed packages, and more.

The output is a readable report — no security expertise required to understand it.

## Who should use it

- Anyone who wants to know the security state of their system
- Useful after a fresh install or major upgrade (e.g., Debian 12 → 13)
- Recommended if the machine handles sensitive data (API keys, databases, credentials)

Not mandatory for a development machine, but it catches things manual audits miss.

## Install

```bash
sudo apt install lynis
```

## Run a full audit

```bash
sudo lynis audit system
```

The scan takes 2–5 minutes. Output goes to the terminal and to `/var/log/lynis.log`.

## Reading the report

At the end of the scan you'll see a **Hardening Index** (0–100) and three sections:

| Section | Meaning |
|---------|---------|
| Suggestions | Low priority — good to do, not urgent |
| Warnings | Medium priority — review and decide |
| Critical | High priority — act on these |

Each finding includes a test ID (e.g., `AUTH-9262`) you can look up at:
`https://cisofy.com/lynis/controls/<TEST-ID>/`

## Typical findings on a desktop

- SSH: `PermitRootLogin` not explicitly set
- Kernel: some sysctl hardening options not enabled
- File permissions: world-readable files in `/etc`
- Services: unnecessary daemons still running

Most findings on a personal development machine are low priority.

## Re-run periodically

```bash
# Quick re-audit after making changes
sudo lynis audit system --quick
```

## Output location

```
/var/log/lynis.log       # Full log
/var/log/lynis-report.dat  # Machine-readable report
```
