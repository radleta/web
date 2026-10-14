#!/bin/bash

# Set encoding to UTF-8 to handle Unicode characters in SCSS/CSS
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RUBYOPT="-E utf-8:utf-8"

# The Vite micro-app is not rebuilt here; run build_vite.sh by hand after building it.

# Build the resume pages into a private directory outside docs/, so a running
# `jekyll serve` (which rewrites _site/ with dev URLs) can't leak into the downloads.
tmp=$(mktemp -d) || exit 1
trap 'rm -rf "${tmp:?}"' EXIT

echo "Building Jekyll site for downloads..."
bundle exec jekyll build --destination "$tmp"

if [ $? -ne 0 ]; then
	echo "Failed to build Jekyll site."
	exit 1
fi

# Define the pages to convert to downloads
echo "Building downloads..."
PAGES=("$tmp/resume/adleta_richard_resume_full.html" "$tmp/resume/adleta_richard_resume_condensed.html")
bash build_downloads.sh "${PAGES[@]}"

if [ $? -ne 0 ]; then
	echo "Failed to build downloads."
	exit 1
fi

# Rebuild the Jekyll site to include the downloads
echo "Rebuilding Jekyll site..."
bundle exec jekyll build

if [ $? -ne 0 ]; then
	echo "Failed to rebuild Jekyll site."
	exit 1
fi

echo "Build complete!"

# Report which downloads differ from the last commit, paths relative to docs/
changed=$(set -o pipefail; { git diff --name-only --relative HEAD -- assets/downloads _data/downloads.yml &&
	git ls-files -o --exclude-standard -- assets/downloads _data/downloads.yml; } | sort -u) || {
	echo "Failed to read download changes from git."
	exit 1
}
if [ -z "$changed" ]; then
	echo "Downloads unchanged."
else
	echo "$(echo "$changed" | wc -l) download files changed; commit them: $(echo "$changed" | paste -sd ' ')"
fi
