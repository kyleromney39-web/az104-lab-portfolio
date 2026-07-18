# 🎯 Module 00: Core Linux Automation & Systems Diagnostics

## 📋 Overview
This module serves as the automation foundation for my engineering portfolio. It features a suite of foundational Bash scripts designed to handle remote asset downloads, core resource threshold auditing, and baseline network connectivity verification. These utilities leverage native Linux binaries, exit codes, and text-processing tools to deliver lightweight system diagnostics.

### 🛠️ The Automation Toolkit
1. **`bootstrap.sh`**: Simulates a cloud server's startup routine by verifying outbound connectivity and downloading a remote web asset (`index.html`) using `curl`, followed by an asset validation check.
2. **`syscheck.sh`**: Evaluates system storage and memory health. It parses the root filesystem capacity via `df` and processes physical memory consumption using custom shell arithmetic, writing warning alerts to a persistent log file.
3. **`netping.sh`**: Verifies public internet reachability by executing targeted ICMP echo requests to Google Public DNS (`8.8.8.8`), tracking execution exit codes to determine path status.

---

## 🪵 Production Engineering Log: Challenges & Core Solves

Building these utilities exposed several fundamental quirks within the Linux operating system and shell environments. Below is the technical documentation of the engineering hurdles encountered and the architectural choices made to overcome them.

### 🧠 Challenge 1: Native Bash Floating-Point Math Constraints
* **The Problem**: Bash is inherently incapable of handling decimal or floating-point math natively; it truncates division into integers. When calculating live memory consumption percentages (`MEM_USED / MEM_TOTAL`), standard division would result in `0` for any usage under 100%, breaking the logic.
* **The Solve**: Implemented an integer scaling strategy within the mathematical evaluation block: `(( MEM_USED * 100 / MEM_TOTAL ))`. Shifting the decimal place by multiplying the numerator by 100 *before* dividing ensures accurate whole-number percentages directly within native shell arithmetic.

### 🔍 Challenge 2: Stream Filtering and Column Parsing with `awk`
* **The Problem**: Raw system outputs like `df -h` and `free -m` produce complex, multi-row data blocks filled with variable whitespace. Running `awk` across unstructured data risks targeting the wrong columns if system specs drift or change headers.
* **The Solve**: Chained explicit `grep` filters into the command pipeline (`grep -w '/'` for disk data and `grep "Mem"` for memory data). This strips out system noise, flattens the matrix to a single predictable row, and allows `awk` to reliably isolate and extract precise positional columns (like the 5th column for disk utilization and the 2nd/3rd for memory metrics).

### 🔊 Challenge 3: Suppressing Stream Noise and Tracking Sub-Process Outcomes
* **The Problem**: Raw command outputs (like `ping` metrics) print text blocks that clutter the terminal during background operations. Additionally, scripts need a way to programmatically determine if an external operation succeeded or failed without looking at the text display.
* **The Solve**: Utilized file-descriptor redirection (`> /dev/null 2>&1`) to completely silence the standard output and error streams of the `ping` command. To handle automation logic, the script evaluates the conditional shell variable `$?` immediately after execution. Capturing this exit code (`0` for success, non-zero for failure) allows the script to branch into clean, user-friendly logs via `tee -a`.

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
