#!/bin/bash
set -e

echo "Installing LaTeX..."

sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

if [ $? -eq 0 ]; then
	echo "LaTeX has been installed successfully."
else
	echo "Failed to install LaTeX."
	exit 1
fi
