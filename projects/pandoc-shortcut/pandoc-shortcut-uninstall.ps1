# Define the context menu name
$contextMenuName = "Convert with Pandoc..."

# Registry paths for .md files and all files
$registryPaths = @(
    "HKEY_CLASSES_ROOT\mdfile\shell\$contextMenuName",
    "HKEY_CLASSES_ROOT\*\shell\$contextMenuName"
)

foreach ($regPath in $registryPaths) {
    # Use .NET method to delete the entire registry key
    try {
        Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
    } catch {
        # If the above fails, we can manually delete using .NET
        $parentPath = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey((Split-Path $regPath -Parent), $true)
        if ($parentPath -ne $null) {
            $parentPath.DeleteSubKeyTree((Split-Path $regPath -Leaf), $false)
        }
    }
}

Write-Host "Context menu 'Convert with Pandoc...' has been uninstalled successfully."
