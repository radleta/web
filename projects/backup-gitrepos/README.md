# Git Repository Backup Script

## Overview

The [Backup-GitRepos.ps1](./Backup-GitRepos.ps1) script is designed to back up local Git repositories by compressing each repository into separate archive files. This backup process can be scheduled to run regularly and is optimized for storing backups in a cloud-synced location (e.g., OneDrive, Google Drive), ensuring safe and secure off-site storage.

This script is highly configurable, with options to control logging, prevent overwriting of backup files, and adjust the behavior when scheduling automatic backups through Windows Task Scheduler.

---

## Features

- **Backup Git Repositories**: Automatically identifies and compresses Git repositories in the source folder, archiving them in a specified destination folder.
- **Cloud Sync Compatibility**: The destination folder can be synced with a cloud provider (e.g., OneDrive, Dropbox, Google Drive) to ensure your backups are stored securely.
- **Error Logging**: Provides detailed logging to track successes and failures in backup operations.
- **Prevents Overwriting**: Optionally ensures that existing backups are not overwritten, preserving previous backup versions.
- **Retry Mechanism**: In case of a failure, the script retries compressing repositories up to three times with a delay between each attempt.

---

## Parameters

| Parameter          | Description                                                                                | Required | Default Value |
| ------------------ | ------------------------------------------------------------------------------------------ | -------- | ------------- |
| `SourcePath`       | Path to the folder containing Git repositories to back up.                                 | Yes      | N/A           |
| `DestinationPath`  | Path to the folder where backups will be stored (preferably synced with a cloud provider). | Yes      | N/A           |
| `EnableLogging`    | Enables logging of script execution.                                                       | No       | `True`        |
| `LogPath`          | Specifies a custom path for log files (optional). If omitted, a temporary path is used.    | No       | `""`          |
| `PreventOverwrite` | Prevents overwriting of existing backup files in the destination folder.                   | No       | `True`        |

---

## Usage

### Example Command

The following command shows how to back up all Git repositories in `C:\Projects\MyRepos` and store the compressed archives in `C:\OneDrive\Backups`. Logging is enabled, and the script is configured to prevent overwriting existing backups.

```powershell
.\Backup-GitRepos.ps1 -SourcePath "C:\Projects\MyRepos" -DestinationPath "C:\OneDrive\Backups" -EnableLogging $true -PreventOverwrite $true
```

### Scheduling with Task Scheduler

To run the script automatically on a regular basis (e.g., every day), you can use **Task Scheduler** on Windows. Here's how to set it up:

#### 1. Open Task Scheduler

1. Press `Windows + S` and type **Task Scheduler**.
2. Open the Task Scheduler application.

#### 2. Create a New Task

1. In Task Scheduler, select **Action > Create Task**.
2. Name the task (e.g., `Git Repos Backup`), and check **Run with highest privileges**.

#### 3. Configure the Trigger

1. Go to the **Triggers** tab and click **New**.
2. Set it to trigger **On a schedule** or **On idle** for backup when the system is not in use.

#### 4. Configure the Action

1. In the **Actions** tab, click **New**.
2. Select **Start a program**, and for **Program/script**, enter:
   ```plaintext
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
   ```
3. In the **Add arguments** field, add the path to the script and the necessary parameters:
   ```plaintext
   -Command "C:\path-to-your-script\Backup-GitRepos.ps1" -SourcePath "C:\Projects\MyRepos" -DestinationPath "C:\OneDrive\Backups" -EnableLogging $true -PreventOverwrite $true
   ```

#### 5. Set Conditions

1. In the **Conditions** tab, check **Start the task only if the computer is idle for X minutes**.
2. Optionally, you can prevent the task from running on battery power.

#### 6. Save and Test

1. Click **OK** and enter your password if prompted.
2. Test the task by right-clicking on it and selecting **Run**.

---

## Logging

If logging is enabled (`-EnableLogging $true`), the script will create a log file at either the specified `LogPath` or a temporary location (e.g., `%TEMP%`). The log will contain timestamps, statuses, and any errors encountered during the backup process.

### Example Log Entry:

```
2024-10-06 10:15:00 - INFO - Starting backup process for Git repositories in 'C:\Projects\MyRepos'
2024-10-06 10:16:15 - INFO - Successfully compressed repository 'MyRepo' to 'C:\OneDrive\Backups\MyRepo_GitBackup_20241006_101530.zip'
2024-10-06 10:18:30 - ERROR - Compression failed for repository 'OtherRepo' after 3 attempts.
2024-10-06 10:19:45 - INFO - Backup completed successfully. Archives saved to 'C:\OneDrive\Backups'.
```

---

## Troubleshooting

### Common Errors

1. **Source or Destination Path Not Found**: Ensure both the `SourcePath` and `DestinationPath` are valid, existing directories.
2. **No Git Repositories Found**: Verify the `SourcePath` contains valid Git repositories. The script looks for `.git` directories to identify repositories.
3. **Compression Failure**: If a repository fails to compress after multiple attempts, check for filesystem permissions or long file path issues.

### Retry Mechanism

If compression of a repository fails, the script will attempt up to three retries, with a delay of 5 seconds between attempts.

---

## Task Scheduler XML Configuration

If you prefer to import an existing Task Scheduler configuration, you can use the following pre-configured XML file [Backup-GitRepos-Task.xml](./Backup-GitRepos-Task.xml).

Import this XML file into Task Scheduler for automatic backups.

---

## Notes

- **Version**: 1.8 (2024-10-06)
- **Administrative Privileges**: If accessing system files or folders, run PowerShell as an administrator.
- **Prevent Overwriting**: The `PreventOverwrite` parameter avoids overwriting backups, useful for maintaining version history.

---

## License

This script is open-source and free to use. Feel free to modify and distribute it as needed.
