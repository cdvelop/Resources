# rkhunter — Rootkit Hunter

## What it does

rkhunter checks whether your system has been compromised. It looks for:

- Known rootkits and backdoors
- System binaries that have been replaced or modified (e.g., `ls`, `ps`, `netstat`)
- Suspicious network ports opened by malware
- Hidden files and processes

## Who should use it

Use rkhunter if:
- Your machine was exposed to untrusted networks
- You installed software from unverified sources
- You suspect something unusual is happening (unexpected CPU usage, network traffic, etc.)

For a standard development machine on a home/office LAN with trusted software sources,
rkhunter is optional. Lynis is a better first step.

## Install

```bash
sudo apt install rkhunter
```

## Run a check

```bash
sudo rkhunter --check
```

Press Enter when prompted to continue between sections.

For non-interactive mode:

```bash
sudo rkhunter --check --skip-keypress
```

## Update the database first

Before the first run, update the malware signatures:

```bash
sudo rkhunter --update
```

## Understanding the output

| Result | Meaning |
|--------|---------|
| `[ OK ]` | No issue found |
| `[ Warning ]` | Something looks suspicious — investigate |
| `[ Not found ]` | Tool or file missing (usually harmless) |

Warnings are not always real threats. Common false positives:
- Modified system binaries after a `apt upgrade` (expected — run `--propupd` after upgrades)
- Prelink or debsums differences

## After a system upgrade

After `apt upgrade`, update rkhunter's file property database to avoid false positives:

```bash
sudo rkhunter --propupd
```

## Logs

```
/var/log/rkhunter.log
```
