# Get the full path to the Pandoc.ps1 script
$scriptPath = (Get-Item -Path ".\Pandoc.ps1").FullName

# Escape double quotes in the script path
$escapedScriptPath = $scriptPath.Replace('"', '""')

# Define the context menu name
$contextMenuName = "Convert with Pandoc..."

# Registry paths for .md files and all files
$registryPaths = @(
    "HKCR:\mdfile\shell\$contextMenuName",
    "HKCR:\*\shell\$contextMenuName"
)

foreach ($regPath in $registryPaths) {
    # Create the registry key
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value $contextMenuName
    Set-ItemProperty -Path $regPath -Name "Icon" -Value "C:\Windows\System32\shell32.dll,14"

    # Create the command subkey
    $commandPath = Join-Path $regPath "command"
    New-Item -Path $commandPath -Force | Out-Null

    # Set the command to execute the Pandoc.ps1 script with the selected file as an argument
    $command = "powershell.exe -ExecutionPolicy Bypass -File `"$escapedScriptPath`" `"%1`""
    Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command
}

Write-Host "Context menu 'Convert with Pandoc...' has been installed successfully."
