#!/bin/bash

# Enable error handling
set -e

# Determine the Pandoc user data directory
PANDOC_DATA_DIR=$(pandoc --version | grep 'Default user data directory' | awk -F': ' '{print $2}')
if [ -z "$PANDOC_DATA_DIR" ]; then
    # Fallback to default location if Pandoc is older or command fails
    PANDOC_DATA_DIR="$HOME/.local/share/pandoc"
fi

# Ensure the templates directory exists
TEMPLATES_DIR="$PANDOC_DATA_DIR/templates"
mkdir -p "$TEMPLATES_DIR"

# Download the Eisvogel template
EISVOGEL_URL="https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex"

echo "Downloading the Eisvogel template..."
curl -sSL "$EISVOGEL_URL" -o "$TEMPLATES_DIR/eisvogel.latex"

if [ $? -eq 0 ]; then
    echo "Eisvogel template successfully downloaded to $TEMPLATES_DIR"
else
    echo "Failed to download the Eisvogel template."
    exit 1
fi
