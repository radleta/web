# Define the context menu name
$contextMenuName = "Convert with Pandoc..."

# Registry paths for .md files and all files
$registryPaths = @(
    "HKCR:\mdfile\shell\$contextMenuName",
    "HKCR:\*\shell\$contextMenuName"
)

foreach ($regPath in $registryPaths) {
    # Remove the registry key
    Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Context menu 'Convert with Pandoc...' has been uninstalled successfully."
