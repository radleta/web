# Pandoc Shortcut

This project provides a convenient way to convert files using Pandoc directly from the Windows File Explorer context menu. By installing the provided scripts, you'll be able to right-click on files and select **"Convert with Pandoc..."** to convert them into different formats.

## Table of Contents

- [Pandoc Shortcut](#pandoc-shortcut)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Uninstallation](#uninstallation)
  - [Notes](#notes)
  - [Troubleshooting](#troubleshooting)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)
  - [Contact](#contact)

## Features

- Adds a context menu item **"Convert with Pandoc..."** for files in Windows Explorer.
- Supports conversion to **docx**, **pdf**, and **html** formats.
- Interactive menu for selecting the output format when converting a file.
- Easy installation and uninstallation scripts.

## Prerequisites

- **Pandoc**: Ensure that Pandoc is installed on your system. Download it from [Pandoc's official website](https://pandoc.org/installing.html).
- **PowerShell**: These scripts require PowerShell to execute.
- **Administrator Privileges**: Modifying the Windows Registry requires administrative rights.

## Installation

1. **Download the Scripts**

   - Download or clone this repository to a local directory on your Windows machine.

2. **Run the Install Script as Administrator**

   - **Open PowerShell as Administrator**:

     - Click on the **Start** menu, search for **PowerShell**.
     - Right-click on **Windows PowerShell** and select **"Run as administrator"**.

   - **Navigate to the Script Directory**:

     ```powershell
     cd path\to\your\scripts\directory
     ```

   - **Run the Install Script**:

     ```powershell
     .\pandoc-shortcut-install.ps1
     ```

     > **Note**: If you encounter an execution policy error, you can temporarily bypass it:

     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
     ```

3. **Verify the Installation**

   - Right-click on any file in Windows Explorer.
   - You should see the **"Convert with Pandoc..."** option in the context menu.

## Usage

1. **Convert a File**

   - **Right-click** on the file you wish to convert.
   - Select **"Convert with Pandoc..."** from the context menu.
   - A PowerShell window will open with an interactive menu.
   - **Use the arrow keys** to select the desired output format (`docx`, `pdf`, `html`) and press **Enter**.
   - The script will convert the file and save the output in the same directory with a timestamped filename.

2. **Output File Naming**

   - The converted file will be named as:

     ```
     original-filename - YYYY-MM-DD HHmm.outputformat
     ```

     For example, converting `document.md` to `pdf` on October 3, 2023, at 14:30 results in:

     ```
     document - 2023-10-03 1430.pdf
     ```

## Uninstallation

1. **Run the Uninstall Script as Administrator**

   - **Open PowerShell as Administrator**:

     - Click on the **Start** menu, search for **PowerShell**.
     - Right-click on **Windows PowerShell** and select **"Run as administrator"**.

   - **Navigate to the Script Directory**:

     ```powershell
     cd path\to\your\scripts\directory
     ```

   - **Run the Uninstall Script**:

     ```powershell
     .\pandoc-shortcut-uninstall.ps1
     ```

2. **Verify the Uninstallation**

   - Right-click on any file in Windows Explorer.
   - The **"Convert with Pandoc..."** option should no longer be present.

## Notes

- **Administrator Rights**: Both installation and uninstallation scripts must be run with administrative privileges to modify the Windows Registry.

- **Execution Policy**: If your system restricts running PowerShell scripts, you can temporarily bypass this restriction:

  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  ```

- **Pandoc Filters**: The conversion command in `pandoc-shortcut.ps1` uses a filter `mermaid-filter.cmd`. Ensure that any necessary Pandoc filters or dependencies are installed and accessible.

- **Customization**: Modify `pandoc-shortcut.ps1` to add more output formats or adjust conversion options as needed.

- **File Types**: The context menu is added for all files (`*`) and specifically for Markdown files (`.md`). Modify the registry paths in the install script to target different file types if desired.

## Troubleshooting

- **Context Menu Not Appearing**:

  - Ensure you ran the install script as an administrator.
  - Restart Windows Explorer or your computer.

- **Conversion Errors**:

  - Verify that Pandoc is installed and added to your system's PATH.
  - Check if the input file is accessible and not corrupted.
  - Ensure required Pandoc filters (like `mermaid-filter.cmd`) are installed.

- **Script Execution Errors**:

  - Check your PowerShell execution policy.
  - Confirm you're running PowerShell as an administrator for install/uninstall scripts.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [Pandoc](https://pandoc.org/) - A universal document converter.
- [PowerShell](https://docs.microsoft.com/powershell/) - A task automation and configuration management framework.

## Contact

For issues or suggestions, please open an issue in the repository or contact the maintainer.
