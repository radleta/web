# Git Repository Backup Script

## Overview

This PowerShell script `Backup-GitRepos.ps1` is designed to back up local Git repositories by compressing each repository into a separate archive file. The script can be configured to run on a regular basis and is optimized to store backups in a location synced with a cloud provider (e.g., OneDrive) for seamless and secure remote storage.

The script is configurable, with options to enable logging, and prevent overwriting backups of repositories.

---

## Features

- **Backup Git Repositories**: Automatically locates Git repositories in the source folder, compresses them, and stores the backups in the destination folder.
- **Cloud Sync Ready**: The destination folder can be any location synced with a cloud service (e.g., OneDrive, Google Drive) for off-site backups.
- **Error Logging**: Enables logging to track the success and failure of backup operations.
- **Prevents Overwriting**: Optionally avoids overwriting existing backups to preserve previous versions.

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

The following example shows how to execute the script to back up all Git repositories in `C:\Projects\MyRepos` and store the backups in `C:\OneDrive\Backups`, with logging enabled and no overwriting of existing backups.

```powershell
.\Backup-GitRepos.ps1 -SourcePath "C:\Projects\MyRepos" -DestinationPath "C:\OneDrive\Backups" -EnableLogging $true -PreventOverwrite $true
```

---

## Setting Up the Script to Run Automatically

To set up the script to run on Windows 11, especially when the system is idle (e.g., to avoid performance interruptions during active use), follow these steps:

### 1. Open Task Scheduler

1. Press `Windows + S` and type "Task Scheduler".
2. Open the Task Scheduler application.

### 2. Create a New Task

1. In Task Scheduler, select **Action > Create Task**.
2. Name your task (e.g., `Git Repos Backup`) and ensure **Run with highest privileges** is checked.

### 3. Configure Trigger

1. Click on the **Triggers** tab and select **New**.
2. Set the task to start **On idle** (you can also set it to start at a specific time or daily).

### 4. Configure Action

1. In the **Actions** tab, click **New**.
2. Select **Start a program** and in the **Program/script** field, enter:
   ```plaintext
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
   ```
3. In the **Add arguments** field, provide the path to your script along with the parameters:
   ```plaintext
   -File "D:\path-to-your-script\Backup-GitRepos.ps1" -SourcePath "C:\Projects\MyRepos" -DestinationPath "C:\OneDrive\Backups" -EnableLogging $true -PreventOverwrite $true
   ```

### 5. Set Conditions

1. In the **Conditions** tab, check **Start the task only if the computer is idle for X minutes** and adjust to your preferences.
2. Optionally, you can also configure the task to not run if the computer is on battery power.

### 6. Save and Test

1. Click **OK**, enter your password if prompted, and you're done!
2. Test the task by right-clicking on it in Task Scheduler and selecting **Run**.

---

## Logging

If logging is enabled (`-EnableLogging $true`), the script will create a log file either in the specified `LogPath` or in a default temporary directory if `LogPath` is not specified. The log will contain the timestamp and status of each backup operation.

Example log entry:

```
2024-10-06 10:15:00 - Starting backup of repository MyRepo
2024-10-06 10:15:30 - Successfully backed up MyRepo to C:\OneDrive\Backups\MyRepo.zip
```

---

## Notes

- The script version is **1.8** as of 2024-10-06.
- Make sure to run PowerShell with administrative privileges if accessing system files or folders.
- The `PreventOverwrite` parameter ensures that existing backup files are not overwritten, which is useful for preserving older versions.

---

## License

This script is open-source and free to use. Modify and distribute as needed.
