# Get the input file from the arguments
param (
    [string]$inputfile
)

# Function to display interactive menu and handle arrow key selection
function Show-Menu {
    param (
        [string[]]$options
    )

    $selectedIndex = 0
    $key = $null

    # Display the menu and wait for user input
    while ($key.Key -ne "Enter") {
        Clear-Host
        Write-Host "Use the arrow keys to select the output format and press Enter:"

        # Display the options
        for ($i = 0; $i -lt $options.Length; $i++) {
            if ($i -eq $selectedIndex) {
                Write-Host ">> $($options[$i])" -ForegroundColor Yellow
            }
            else {
                Write-Host "   $($options[$i])"
            }
        }

        # Wait for key input
        $key = [System.Console]::ReadKey($true)

        # Handle up/down arrow key
        switch ($key.Key) {
            "UpArrow" {
                $selectedIndex = if ($selectedIndex -gt 0) { $selectedIndex - 1 } else { $options.Length - 1 }
            }
            "DownArrow" {
                $selectedIndex = if ($selectedIndex -lt $options.Length - 1) { $selectedIndex + 1 } else { 0 }
            }
        }
    }

    return $options[$selectedIndex]
}

# Check if the input file was passed as an argument
if (-not $inputfile) {
    Write-Host "Error: No input file provided."
    pause
    exit 1
}

# Check if the input file exists
if (-not (Test-Path $inputfile)) {
    Write-Host "Error: Input file not found."
    pause
    exit 1
}

# Define available output formats
$outputFormats = @("docx", "pdf", "html")

# Show the interactive menu and get the selected format
$outputformat = Show-Menu -options $outputFormats

# Validate the output format
if (-not $outputformat) {
    Write-Host "No valid output format selected."
    pause
    exit 1
}

# Get the current timestamp in yyyy-MM-dd HHmm format
$datestamp = Get-Date -Format "yyyy-MM-dd HHmm"

# Generate the output file name
$outputfile = "$([System.IO.Path]::GetFileNameWithoutExtension($inputfile)) - $datestamp.$outputformat"

# Execute the Pandoc command
$pandocCmd = "pandoc -F mermaid-filter.cmd `"$inputfile`" -o `"$outputfile`""
Invoke-Expression $pandocCmd

# Output the result to the user
Write-Host "Converted $inputfile to $outputfile"

# Keep the window open after script execution
Write-Host "Press Enter to exit..."
[void][System.Console]::ReadLine()
