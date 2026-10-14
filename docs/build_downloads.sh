#!/bin/bash

# Output directory
OUTPUT_DIR="assets/downloads"
YML_FILE="_data/downloads.yml"

# Supported output formats
FORMATS=("md" "pdf" "docx" "odt" "epub" "json")

# Pin every value pandoc and pdfTeX would take from the clock, so the same
# input gives the same bytes and git shows a download only when it changed.
export SOURCE_DATE_EPOCH=1767225600

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null
then
    echo "Pandoc is not installed. Please install it to proceed."
    exit 1
fi

# If no files are provided, exit with a message
if [[ $# -eq 0 ]]; then
    echo "No files provided. Please specify the HTML files you want to convert."
    exit 1
fi

# Every format is written here first and copied into place only when all succeed.
stage=$(mktemp -d) || exit 1
trap 'rm -rf "${stage:?}"' EXIT
mkdir -p "$stage/$OUTPUT_DIR" "$stage/_data"
STAGE_YML="$stage/$YML_FILE"

echo "# Generated downloads YAML file" > "$STAGE_YML"

# Function to convert a file to all specified formats; returns non-zero on the first failure
convert_file() {
    local input_file="$1"
    local base_name=$(basename "$input_file" .html)  # Get the file name without extension

    # Start YAML entry for this document as a key
    echo "$base_name:" >> "$STAGE_YML"
    echo "  title: \"$base_name\"" >> "$STAGE_YML"
    echo "  formats:" >> "$STAGE_YML"

    for format in "${FORMATS[@]}"; do
        output_file="${OUTPUT_DIR}/${base_name}.${format}"
        staged_file="$stage/$output_file"
        # if the format is json, then we just copy the file from the _data/resume.json
        if [ "$format" == "json" ]; then
            cp "_data/resume.json" "$staged_file"
        # if the format is pdf, use the eisvogel template; an empty trailer ID keeps the PDF reproducible
        elif [ "$format" == "pdf" ]; then
            pandoc "$input_file" -o "$staged_file" --template eisvogel -V 'header-includes=\pdftrailerid{}'
        elif [ "$format" == "epub" ]; then
            pandoc "$input_file" -o "$staged_file" --metadata "identifier=https://www.richardadleta.com/${output_file}"
        else
            pandoc "$input_file" -o "$staged_file"
        fi
        if [ $? -ne 0 ]; then
            echo "Failed to generate ${output_file}"
            return 1
        fi
        echo "Successfully generated ${output_file}"
        # Add the output file path under the appropriate format in YAML
        echo "    - format: \"$format\"" >> "$STAGE_YML"
        echo "      path: \"$output_file\"" >> "$STAGE_YML"

        # second pass to strip the {#richard-adleta---senior-software-architect--full-stack-engineer} from markdown files
        if [ "$format" == "md" ]; then
            sed -i 's/{#richard-adleta---senior-software-architect--full-stack-engineer}//g' "$staged_file"
        fi
    done
}

# Loop over all provided files and convert them
for file in "$@"; do
    if [[ ! -f $file ]]; then
        echo "File $file not found."
        exit 1
    fi
    echo "Converting $file..."
    convert_file "$file" || exit 1
done

# Every format succeeded: copy the staged files into place
mkdir -p "$OUTPUT_DIR"
cp "$stage/$OUTPUT_DIR/"* "$OUTPUT_DIR/" && cp "$STAGE_YML" "$YML_FILE" || exit 1

echo "Conversion complete!"
echo "YAML file generated at $YML_FILE"
