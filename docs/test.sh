#!/bin/bash

# Set encoding to UTF-8 to handle Unicode characters in SCSS/CSS
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RUBYOPT="-E utf-8:utf-8"

# launch the server on a separate process need to bind 0.0.0.0 to allow all IP access
bundle exec jekyll serve --host 0.0.0.0 --port 4000
