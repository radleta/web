#!/bin/bash

# Enable error handling
set -e

echo "Fetching the latest pandoc version..."

# Get the latest version tag from GitHub
VERSION=$(curl -Ls -o /dev/null -w '%{url_effective}' https://github.com/jgm/pandoc/releases/latest | rev | cut -d '/' -f1 | rev)

if [ -z "$VERSION" ]; then
    echo "Failed to retrieve the latest pandoc version."
    exit 1
fi

echo "Latest pandoc version is $VERSION."

# Construct the download URL
DEB_URL="https://github.com/jgm/pandoc/releases/download/${VERSION}/pandoc-${VERSION}-1-amd64.deb"

# Download the .deb package
echo "Downloading pandoc ${VERSION}..."
wget -q --show-progress -O "/tmp/pandoc-${VERSION}-1-amd64.deb" "$DEB_URL"

# Install the .deb package
echo "Installing pandoc ${VERSION}..."
sudo dpkg -i "/tmp/pandoc-${VERSION}-1-amd64.deb"

# Fix any missing dependencies
echo "Installing any missing dependencies..."
sudo apt-get install -f -y

# Clean up
echo "Cleaning up..."
rm "/tmp/pandoc-${VERSION}-1-amd64.deb"

echo "Pandoc ${VERSION} has been installed successfully."
