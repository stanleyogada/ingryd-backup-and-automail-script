# INGRYD-BACKUP-&-AUTOMAIL-SCRIPT

# Bash Project: System Automation Script

This collection of Bash scripts is designed to automate various system-related tasks, including creating backups, generating system metrics reports, and backing up Oracle schemas. The project consists of three individual scripts, each serving a specific purpose.

## Prerequisites

Before running the scripts, ensure the following prerequisites are met:

1. **File Permissions:**
   - Give execute permissions to the main script.
     ```bash
     chmod 700 main.sh
     ```

2. **Crontab Configuration:**
   - Edit the crontab document to schedule the script execution.
     ```bash
     crontab -e
     ```
   - Add the following line to run the script every Sunday at 2 PM.
     ```bash
     0 14 * * 0 /path/to/main.sh
     ```

3. **Directory Setup:**
   - Create a directory for your scripts and place the main script in it.
     ```bash
     mkdir $HOME/week6_scripts
     touch $HOME/week6_scripts/main.sh && chmod 777 $HOME/week6_scripts/main.sh
     ```

4. **Update PATH:**
   - Add the script directory to the $PATH environment variable in your .bashrc file.
     ```bash
     echo "PATH=\$PATH:$HOME/week6_scripts" >> $HOME/.bashrc && PATH=\$PATH:$HOME/week6_scripts
     ```

### Usage

Run the script manually.

```bash
./main.sh
```


## 1. Backup Script

### Description

- Creates backups of important files found in `$HOME/ingrydDocs` to a regular backup destination.
- If the backup destination does not exist, it is created before performing the backup.
- All backups are compressed.
- If the files in the source directory have not changed since the last backup, the script skips the backup.

## 2. System Metrics Report

### Description

- Reports on key system metrics, including CPU usage, memory usage, disk space, and network statistics.
- The report is tabular and covers metrics for the past week.

## 3. Oracle Schema Backup

### Description

- Backs up an Oracle Schema specified at runtime to a remote destination.
- The entire script should run on the Oracle command line.


## 4. Final Report and Email

### Description

- Generates a final report that tabulates preceding details and emails the report to `martin.mato@ingrydacademy.com`.
- Requires the installation of `mutt` for email functionality.


## Note

- Ensure all necessary prerequisites are met before running the scripts.
- Monitor the script outputs for any errors or warnings.
- Customize the scripts and parameters based on your specific requirements.

Feel free to contribute to this Bash project or raise issues if you encounter any problems. Happy scripting!
