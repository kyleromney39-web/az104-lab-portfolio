# 🎯 Module 00: Core Linux Automation & Systems Diagnostics

Core Linux Automation
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

