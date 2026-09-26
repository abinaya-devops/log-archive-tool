# 📦 Log Archive Tool

A Bash script to archive log files from any Linux directory, with automatic timestamping and a run history log.

Project #2 from my [roadmap.sh DevOps Projects](https://roadmap.sh/devops/projects) learning journey.

## 🌱 My DevOps Learning Journey

I'm a BCA graduate learning Cloud & DevOps hands-on, working my way through the roadmap.sh project track one step at a time — building real, working tools instead of just reading theory.

- ✅ **Project 1: Server Performance Stats** — a Bash script to report CPU, memory, disk usage, and top processes on any Linux server.
- ✅ **Project 2: Log Archive Tool** (this repo) — a Bash script to compress and archive log directories with timestamps and a run history.
- 🔜 More projects coming as I keep progressing through the roadmap — Nginx Log Analyser next.

Each project has helped me get more comfortable with real Linux systems, shell scripting, file permissions, and thinking like an engineer rather than just running commands I don't fully understand. I'm documenting each one here so I (and anyone else learning) can look back and see the progress.

## 📋 What It Does

The script `log_archive.sh` takes a log directory as input and:
- Compresses all files in that directory into a single `.tar.gz` archive
- Names the archive using the current date and time (e.g. `log_archive_20260925190835.tar.gz`)
- Stores all archives in an `archives/` folder
- Records every archive operation (what, when) in `archives/archive_log.txt`, so there's a full history of every run

## 🚀 How to Use

    chmod +x log_archive.sh
    ./log_archive.sh /var/log

Replace `/var/log` with any directory you want to archive.

## 📄 Script

![Script code](screenshots/script_code.png)

## 📂 Sample Output

![Sample output showing successful archive creation and also log_archive_tool script](screenshots/output_sample.png)

Log file entry (`archives/archive_log.txt`):

    2026-09-25 19:08:36 - Archived /var/log to log_archive_20260925190835.tar.gz

## ⚠️ A Real Issue I Ran Into: Permission Denied

While testing this on `/var/log`, I got warnings like:

    tar: ./btmp: Cannot open: Permission denied
    tar: ./private: Cannot open: Permission denied
    tar: ./chrony: Cannot open: Permission denied

**Why this happens:** files like `btmp`, `private`, and `chrony` are system-level log files that only the `root` user is allowed to read. My regular user account doesn't have permission to open them, so `tar` skips them and warns me — but it still successfully archives every other file it *can* access.

**Two ways to handle it:**
1. **Leave it as-is** (what I did) — the script still works correctly; it just skips restricted files. This is expected, normal behavior on any real Linux system, not a bug.
2. **Run with elevated permissions** if you specifically need those restricted files included too:

       sudo ./log_archive.sh /var/log

   This runs the script as `root`, so it can read every file — but be careful with `sudo`, since it gives the script full system access.

I chose to keep the script running as a normal user by default, since that's the safer and more realistic way these tools are used in production — you don't want every log tool needing root access unless it truly needs it.

## 🛠️ How It Works

1. Validates that a directory argument was provided
2. Checks the directory actually exists
3. Creates an `archives/` folder if it doesn't exist
4. Builds a timestamped filename using `date +%Y%m%d%H%M%S`
5. Compresses the directory using `tar -czf`
6. Verifies the archive file was actually created and isn't empty (`-s` check) before logging success — this was a fix I made after discovering `tar`'s exit code isn't reliable when some files are skipped due to permissions
7. Appends a line to `archive_log.txt` recording the operation

## 📚 Skills Demonstrated

- Bash scripting (arguments, conditionals, variables, exit codes)
- Linux file permissions and `sudo`
- `tar` compression and archiving
- Logging and error handling
- Debugging real-world command behavior (not just following a tutorial blindly)
