# 🎯 Module 00: Core Linux Automation & Systems Diagnostics

## Core Linux Automation
This directory contains a set of lightweight, native Bash scripts designed to handle system health checks and network diagnostics without relying on heavy, third-party monitoring tools.

🛠️ Included Utilities
bootstrap.sh – Simulates a cloud startup routine, using curl to download and validate remote web assets.

syscheck.sh – Monitors storage and memory thresholds utilizing native shell arithmetic.

netping.sh – A quick network diagnostics utility that evaluates outbound public internet reachability.

💡 Engineering Challenges & Solutions
Building these utilities was a great reminder that even simple automation throws fun, real-world hurdles at you. Here is how specific system constraints were addressed in the codebase:

1. Handling Bash Math Constraints
Bash doesn't do floating-point decimal division out of the box, which normally breaks things when attempting to calculate memory utilization percentages. To get accurate whole numbers, the scripts multiply the numerator by 100 before running the division. This ensures the system outputs accurate whole-number metrics instead of truncating the decimal straight to zero.

2. Parsing Shifting Log Headers
Raw outputs from commands like df -h and free -m can be tough to parse reliably because headers and columns move depending on the system environment. To isolate the data cleanly, grep filters are used to flatten the output into a single predictable row first, making it easy for awk to accurately grab the exact positional columns needed.

3. Managing Stream Noise & Log Multiplexing
To keep network timeout errors from cluttering the terminal output, standard error and standard output redirection (2>&1) are used to quiet raw errors. The clean output is then piped through tee -a to split the data stream to writing persistent alerts to a local log folder while still displaying real-time output on the screen.

📂 Portability & Logs
All scripts are optimized using relative paths to ensure complete portability across different environments.

The resource and network scripts will automatically verify, create, and append data to a local directory structure:

logs/system_alerts.log

logs/ping_results.log

This allows the repository to be cloned and executed immediately on any standard Linux distribution without breaking due to hardcoded home directory dependencies.

---

## ⚙️ Deployment & Execution Baselines

To run these diagnostics utilities on any standard enterprise Linux node, execute the following permission updates and commands:

```bash
# 1. Clone the repository down to the local host
git clone [https://github.com/kyleromney39-web/az104-lab-portfolio.git](https://github.com/kyleromney39-web/az104-lab-portfolio.git)

# 2. Change directory into the automation core
cd az104-lab-portfolio/00-core-linux-automation

# 3. Elevate execution privileges on the script assets
chmod +x bootstrap.sh syscheck.sh netping.sh

# 4. Execute the system monitor utility
./syscheck.sh

---

## 📜 `audit_log.sh`

This is a Bash script I made that searches through system log files to find error messages and count how many times they happened.

### What it does:
* **Checks the file first:** Makes sure the log file actually exists and that you have permission to read it before trying to run the main commands.
* **Flexible file input:** You can pass in any log file you want to check. If you don't pass one in, it automatically defaults to `/var/log/syslog`.
* **Simple pipeline:** Uses `cut`, `grep`, `sort`, and `uniq` to pull out error lines and show a clean list of how many times each error popped up.

---

## 💡 What I Learned & Challenges

### 1. Why I chose `cut` instead of `awk`
* **The Problem:** When I tried using `awk`, the column numbers kept changing and doesn't line up due to different naming. e.g "service Failed" compared to "service-log-failed" "Failed" is in column 2 while "failed" is in column 1. 
* **The Solution:** I switched to `cut -d ':' -f 5-`. Splitting on the colon made it much easier to chop off the timestamp at the beginning without messing up the actual message text.

### 2. Stopping the script early if something is wrong
* **The Problem:** If I ran the script on a file that didn't exist or one that needed `sudo` access, Bash printed out messy errors and tried running the rest of the commands anyway.
* **The Solution:** I added `if` statements using `-f` (to check if the file exists) and `-r` (to check if it's readable). If a check fails, it prints a clear error message and stops the script right away using `exit 1`.

---

## 🤖 How I Used AI

I used AI to help build the basic starter structure for the script (like the layout for the parameter defaults and `if` checks). 

Getting help with the basic script outline saved time so I could focus on:
* Building and testing the `cut | grep | sort` pipeline commands.
* Learning how file permissions and exit codes work in Linux.
* Practicing my Git workflow using branches, commits, and pull requests.
