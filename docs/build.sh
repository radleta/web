#!/bin/bash

# Step 1: Build the Jekyll site
echo "Building Jekyll site..."
bundle exec jekyll build

if [ $? -ne 0 ]; then
	echo "Failed to build Jekyll site."
	exit 1
fi

# Step 2: Define the pages to convert to downloads
echo "Building downloads..."
PAGES=("_site/resume/adleta_richard_resume_full.html" "_site/resume/adleta_richard_resume_condensed.html")
bash build_downloads.sh "${PAGES[@]}"

if [ $? -ne 0 ]; then
	echo "Failed to build downloads."
	exit 1
fi

# Step 3: Rebuild the Jekyll site to include the downloads
echo "Rebuilding Jekyll site..."
bundle exec jekyll build

echo "Build complete!"