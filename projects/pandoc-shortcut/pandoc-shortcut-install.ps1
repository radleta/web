# Get the full path to the pandoc-shortcut.ps1 script
$scriptPath = (Get-Item -Path ".\pandoc-shortcut.ps1").FullName

# Escape double quotes in the script path
$escapedScriptPath = $scriptPath.Replace('"', '""')

# Define the context menu name
$contextMenuName = "Convert with Pandoc..."

# Registry paths for .md files and all files
$registryPaths = @(
    "HKEY_CLASSES_ROOT\mdfile\shell\$contextMenuName",
    "HKEY_CLASSES_ROOT\*\shell\$contextMenuName"
)

foreach ($regPath in $registryPaths) {
    # Create the registry key using .NET method
    [Microsoft.Win32.Registry]::SetValue("$regPath", "", $contextMenuName, [Microsoft.Win32.RegistryValueKind]::String)

    # Set the icon property using .NET method
    [Microsoft.Win32.Registry]::SetValue("$regPath", "Icon", "C:\Windows\System32\shell32.dll,14", [Microsoft.Win32.RegistryValueKind]::String)

    # Create the command subkey and set the command to execute the Pandoc.ps1 script
    $commandPath = "$regPath\command"
    $command = "powershell.exe -ExecutionPolicy Bypass -File `"$escapedScriptPath`" `"%1`""
    [Microsoft.Win32.Registry]::SetValue("$commandPath", "", $command, [Microsoft.Win32.RegistryValueKind]::String)
}

Write-Host "Context menu 'Convert with Pandoc...' has been installed successfully."
