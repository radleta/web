# Git Repo Backup Script
# Purpose: Backup local Git repositories by compressing each repository to a separate archive file.
# Sync location: A folder backed by a cloud provider (like OneDrive) for efficient syncing.
#
# Author: Richard C. Adleta
# Date: 2024-10-06

<#+
.SYNOPSIS
    This script compresses local Git repositories into separate files for backup purposes.
.DESCRIPTION
    The script finds and compresses specified Git repositories and moves the archives to a backup location
    (typically synced with a cloud provider like OneDrive) for efficient synchronization.
    Supports error checking and logging for reliability.
.PARAMETER SourcePath
    Path to the directory containing Git repositories that need to be backed up.
.PARAMETER DestinationPath
    Destination directory to store compressed backup files. Typically, this is a folder backed by a cloud provider.
.PARAMETER EnableLogging
    Boolean flag to enable or disable logging. Default is $true.
    If enabled, logs will be stored in a temporary location unless overridden by LogPath.
.PARAMETER LogPath
    Optional path to a log file for detailed output. Overrides default logging location.
.PARAMETER PreventOverwrite
    Boolean flag to prevent overwriting existing backup files. Default is $true.
.EXAMPLE
    .\Backup-GitRepos.ps1 -SourcePath "C:\Projects\MyRepos" -DestinationPath "C:\Users\YourUser\OneDrive\Backups" -EnableLogging $true -PreventOverwrite $true
.NOTES
    Version: 1.8
#>

[CmdletBinding()]
param (
	[Parameter(Mandatory = $false, HelpMessage = "Throttle limit for parallel processing.")]
	[int]$ThrottleLimit = 4,

	[Parameter(Mandatory = $true, HelpMessage = "Path to the folder containing Git repositories.")]
	[string]$SourcePath,

	[Parameter(Mandatory = $true, HelpMessage = "Destination folder to store the backup.")]
	[string]$DestinationPath,

	[Parameter(Mandatory = $false, HelpMessage = "Enable or disable logging.")]
	[bool]$EnableLogging = $true,

	[Parameter(Mandatory = $false, HelpMessage = "Path to a log file for detailed output.")]
	[string]$LogPath = "",

	[Parameter(Mandatory = $false, HelpMessage = "Prevent overwriting existing backup files.")]
	[bool]$PreventOverwrite = $true
)

# Default log path if not specified and logging is enabled
if ($EnableLogging -and -not $LogPath) {
	$LogPath = Join-Path -Path $env:TEMP -ChildPath "GitBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
	if ($LogPath) {
		Write-Host "Logging is enabled. Log file location: $LogPath" -ForegroundColor Cyan
	}
}

function Write-Log {
	param (
		[string]$Message,
		[string]$LogLevel = "INFO"
	)
	if ($EnableLogging) {
		$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		$logMessage = "$timestamp [$LogLevel] $Message"
		if ($LogPath) {
			$logMessage | Out-File -FilePath $LogPath -Append -Encoding utf8
		}
		Write-Host $logMessage
	}
	else {
		Write-Host $Message
	}
}

# Begin script logic
$errorsOccurred = [System.Collections.Concurrent.ConcurrentBag[string]]::new()

try {
	# Verify source path exists
	if (-not (Test-Path -Path $SourcePath)) {
		Write-Log "Source path '$SourcePath' does not exist. Please provide a valid path." -LogLevel "ERROR"
		Write-Host "Please provide a valid source path or recheck the input." -ForegroundColor Red
		throw
	}

	# Verify destination path exists
	if (-not (Test-Path -Path $DestinationPath)) {
		Write-Log "Destination path '$DestinationPath' does not exist. Please provide a valid path." -LogLevel "ERROR"
		Write-Host "Please provide a valid destination path or recheck the input." -ForegroundColor Red
		throw
	}

	Write-Log "Starting backup process for Git repositories in '$SourcePath'..." -LogLevel "INFO"
	if ($EnableLogging) { Write-Host "Logs will be recorded at: $LogPath" -ForegroundColor Cyan }

	# Find all local Git repositories

	# Initialize the gitRepos array
	$gitRepos = @()

	# Excluded directories
	$excludedDirectories = @('node_modules', 'vendor', 'bin', 'obj')

	# Check if the root directory is a Git repository
	if (Test-Path -Path (Join-Path -Path $SourcePath -ChildPath ".git")) {
		# Exclude if in the excluded directories list
		if ($excludedDirectories -notcontains (Split-Path -Leaf $SourcePath)) {
			$gitRepos += Get-Item -Path $SourcePath
		}
	}

	# Find all Git repositories in subdirectories
	$gitRepos += Get-ChildItem -Path $SourcePath -Directory -Recurse -Force | Where-Object {
		($_.Attributes -notmatch 'Hidden') -and
		($excludedDirectories -notcontains $_.Name) -and
		(Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git"))
	}

	# Optional: Display found repositories
	foreach ($repo1 in $gitRepos) {
		Write-Host "Found Git repository: $($repo1.FullName)"
	}

	if ($null -eq $gitRepos -or $gitRepos.Count -eq 0) {
		Write-Log "No Git repositories found in the source path '$SourcePath'. Please verify that there are Git repositories to backup." -LogLevel "ERROR"
		Write-Host "No Git repositories found in the source path. Please verify your input." -ForegroundColor Yellow
		throw [System.Management.Automation.RuntimeException] "No Git repositories found."
	}

	# Staging directory for the temporary zip files
	$StagingDir = New-Item -ItemType Directory -Path (Join-Path -Path $env:TEMP -ChildPath "GitBackupStaging_$([guid]::NewGuid())") -Force

	# Load the assembly once before the loop for efficiency
	if (-not ([System.Reflection.Assembly]::GetAssembly([System.IO.Compression.ZipFile]))) {
		Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
	}

	# Compress each Git repo into a separate archive
	foreach ($repo in $gitRepos) {
		try {
			$archiveName = "$($repo.Name)_GitBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
			$stagingArchivePath = Join-Path -Path $StagingDir.FullName -ChildPath $archiveName

			Write-Log "Compressing repository '$($repo.Name)' to staging location '$stagingArchivePath'..." -LogLevel "INFO"

			# Check ensure the path exists
			if (-not (Test-Path -Path $repo.FullName)) {
				Write-Log "Repository path '$($repo.FullName)' does not exist. Skipping compression." -LogLevel "ERROR"
				$errorsOccurred.Add($repo.Name)
				return
			}

			# Load the assembly once before the loop for efficiency
			if (-not ('System.IO.Compression.FileSystem' -as [Type])) {
				Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
			}
			$retryCount = 0
			$maxRetries = 3
			$retryDelaySeconds = 5
			$compressionSuccess = $false
			while (-not $compressionSuccess -and $retryCount -lt $maxRetries) {
				try {
					[System.IO.Compression.ZipFile]::CreateFromDirectory($repo.FullName, $stagingArchivePath)
					$compressionSuccess = $true
					Write-Log "Successfully compressed repository '$($repo.Name)' on attempt $($retryCount + 1)." -LogLevel "INFO"
				}
				catch {
					$retryCount++
					if ($retryCount -lt $maxRetries) {
						Write-Log "Compression failed for repository '$($repo.Name)'. Attempt $retryCount of $maxRetries. Retrying in $retryDelaySeconds seconds..." -LogLevel "WARN"
						Start-Sleep -Seconds $retryDelaySeconds
					}
					else {
						Write-Log "Compression failed for repository '$($repo.Name)' after $maxRetries attempts." -LogLevel "ERROR"
						throw
					}
				}
			}

			# Determine final archive name to avoid overwriting
			$finalArchivePath = Join-Path -Path $DestinationPath -ChildPath $archiveName
			if ($PreventOverwrite -and (Test-Path -Path $finalArchivePath)) {
				$count = 1
				$baseName = "$($repo.Name)_GitBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
				do {
					$finalArchivePath = Join-Path -Path $DestinationPath -ChildPath "${baseName}_$count.zip"
					$count++
				} while (Test-Path -Path $finalArchivePath)
			}

			Write-Log "Moving archive to final destination..." -LogLevel "INFO"
			Move-Item -Path $stagingArchivePath -Destination $finalArchivePath -Force -ErrorAction Stop
			Write-Log "Moved archive to final destination '$finalArchivePath'." -LogLevel "INFO"
		}
		catch {
			Write-Log "An error occurred while processing repository '$($repo.Name)': $($_.Exception.Message)" -LogLevel "ERROR"
			$errorsOccurred.Add($repo.Name)
		}
	}

	if ($errorsOccurred.Count -gt 0) {
		Write-Log "One or more repositories failed to backup. Please review the above error messages." -LogLevel "ERROR"
		Write-Host "Backup incomplete. Please check the log file for more information on which repositories failed." -ForegroundColor Red
		throw
	}
	else {
		Write-Log "Backup completed successfully. Archives saved to '$DestinationPath'." -LogLevel "INFO"
	}
}
catch {
	# Catch and display any error messages
	Write-Log "An unexpected error occurred: $($_.Exception.Message). Please review the log file for more details." -LogLevel "ERROR"
	Write-Host "An unexpected error occurred during the backup process: $($_.Exception.Message). Please check the log file for details." -ForegroundColor Red
}
finally {
	# Clean up the temporary staging directory
	if (Test-Path -Path $StagingDir) {
		Remove-Item -Path $StagingDir -Recurse -Force
	}
	Write-Log "Backup process completed. Temporary files cleaned up." -LogLevel "INFO"
	Write-Log "Summary: Total Repositories Processed: $($gitRepos.Count). Errors Occurred: $($errorsOccurred.Count)." -LogLevel "INFO"
}

# End of script
