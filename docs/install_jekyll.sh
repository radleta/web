#!/bin/bash

# Enable error handling
set -e

# Function to print messages with colors
print_message() {
    COLOR=$1
    MESSAGE=$2
    RESET='\033[0m'
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

# Update and install necessary packages
print_message $YELLOW "Installing required dependencies..."
sudo apt update && sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libncurses5-dev libffi-dev libgdbm-dev

if [ $? -eq 0 ]; then
    print_message $GREEN "Dependencies installed successfully."
else
    print_message $RED "Failed to install dependencies. Exiting..."
    exit 1
fi

# Install rbenv and ruby-build
print_message $YELLOW "Installing rbenv and ruby-build..."
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

if [ $? -eq 0 ]; then
    print_message $GREEN "rbenv installed successfully."
else
    print_message $RED "Failed to install rbenv. Exiting..."
    exit 1
fi

# Configure rbenv in the shell
print_message $YELLOW "Configuring rbenv..."
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# Verify rbenv installation
if type rbenv > /dev/null; then
    print_message $GREEN "rbenv configured successfully."
else
    print_message $RED "Failed to configure rbenv. Exiting..."
    exit 1
fi

# Install Ruby 3.3.5
print_message $YELLOW "Installing Ruby 3.3.5..."
rbenv install 3.3.5

if [ $? -eq 0 ]; then
    print_message $GREEN "Ruby 3.3.5 installed successfully."
else
    print_message $RED "Failed to install Ruby 3.3.5. Exiting..."
    exit 1
fi

# Set Ruby 3.3.5 as the global version
print_message $YELLOW "Setting Ruby 3.3.5 as the global version..."
rbenv global 3.3.5

if [ $? -eq 0 ]; then
    print_message $GREEN "Ruby 3.3.5 set as the global version."
else
    print_message $RED "Failed to set Ruby 3.3.5 as the global version. Exiting..."
    exit 1
fi

# Verify Ruby installation
print_message $YELLOW "Verifying Ruby installation..."
ruby_version=$(ruby -v)
if [[ $ruby_version == *"3.3.5"* ]]; then
    print_message $GREEN "Ruby 3.3.5 installed and verified: $ruby_version"
else
    print_message $RED "Ruby verification failed. Exiting..."
    exit 1
fi

# Set gem configuration to skip documentation
print_message $YELLOW "Configuring gem to skip documentation..."
echo "gem: --no-document" > ~/.gemrc

if [ $? -eq 0 ]; then
    print_message $GREEN "Gem configured successfully."
else
    print_message $RED "Failed to configure gem. Exiting..."
    exit 1
fi

# Install bundler
print_message $YELLOW "Installing Bundler..."
gem install bundler

if [ $? -eq 0 ]; then
    print_message $GREEN "Bundler installed successfully."
else
    print_message $RED "Failed to install Bundler. Exiting..."
    exit 1
fi

# Verify gem installation path
print_message $YELLOW "Checking gem installation path..."
gem_home=$(gem env home)
if [ -d "$gem_home" ]; then
    print_message $GREEN "Gems are being installed in: $gem_home"
else
    print_message $RED "Failed to verify gem installation path. Exiting..."
    exit 1
fi

# Re-source bashrc to make sure environment is updated
print_message $YELLOW "Re-sourcing .bashrc..."
source ~/.bashrc

# Check gems directory
print_message $YELLOW "Listing gems directory..."
if [ -d ~/gems ]; then
    ll ~/gems
else
    print_message $RED "Gems directory not found."
fi

# Install Jekyll
print_message $YELLOW "Installing Jekyll..."
gem install jekyll

if [ $? -eq 0 ]; then
    print_message $GREEN "Jekyll installed successfully."
else
    print_message $RED "Failed to install Jekyll. Exiting..."
    exit 1
fi

print_message $GREEN "Script execution completed successfully."
