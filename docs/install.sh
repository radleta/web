#!/bin/bash
set -e

# Install jekyll
bash install_jekyll.sh

# Install pandoc
bash install_pandoc.sh

# Install LaTeX
bash install_latex.sh

# Install the Eisvogel template
bash install_pandoc_eisvogel.sh