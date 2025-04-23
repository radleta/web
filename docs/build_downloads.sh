#!/bin/bash

# Output directory
OUTPUT_DIR="assets/downloads"
YML_FILE="_data/downloads.yml"

# Supported output formats
FORMATS=("md" "pdf" "docx" "odt" "epub" "json")

# Ensure the output directory exists
mkdir -p $OUTPUT_DIR

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null
then
    echo "Pandoc is not installed. Please install it to proceed."
    exit 1
fi

# Clear the YAML file before starting
echo "# Generated downloads YAML file" > $YML_FILE

# Function to convert a file to all specified formats
convert_file() {
    local input_file="$1"
    local base_name=$(basename "$input_file" .html)  # Get the file name without extension

    # Start YAML entry for this document as a key
    echo "$base_name:" >> $YML_FILE
    echo "  title: \"$base_name\"" >> $YML_FILE
    echo "  formats:" >> $YML_FILE

    for format in "${FORMATS[@]}"; do
        output_file="${OUTPUT_DIR}/${base_name}.${format}"
        # if the format is json, then we just copy the file from the _data/resume.json
        if [ "$format" == "json" ]; then
            cp "_data/resume.json" "$output_file"        
        # if the format is pdf, use the eisvogel template
        elif [ "$format" == "pdf" ]; then
            pandoc "$input_file" -o "$output_file" --template eisvogel
        else
            pandoc "$input_file" -o "$output_file"
        fi
        if [ $? -eq 0 ]; then
            echo "Successfully generated ${output_file}"
            # Add the output file path under the appropriate format in YAML
            echo "    - format: \"$format\"" >> $YML_FILE
            echo "      path: \"$output_file\"" >> $YML_FILE
        else
            echo "Failed to generate ${output_file}"
        fi
    done
}

# If no files are provided, exit with a message
if [[ $# -eq 0 ]]; then
    echo "No files provided. Please specify the Markdown files you want to convert."
    exit 1
fi

# Loop over all provided files and convert them
for file in "$@"; do
    if [[ -f $file ]]; then
        echo "Converting $file..."
        convert_file "$file"
    else
        echo "File $file not found."
    fi
done

echo "Conversion complete!"
echo "YAML file generated at $YML_FILE"
