#!/bin/bash

# We need to copy the dist output from vite to the assets directory and then copies the .vite/manifest.json file to the data directory.
PROJECTS="vite-react-test"

# function takes the name of the project and assumes the conventional name of the project is the same as the directory name
copy_vite_output() {
    local project_name="$1"
    local vite_dir="../projects/$project_name/dist"
    local vite_manifest_file="../projects/$project_name/dist/.vite/manifest.json"
    local assets_dir="assets/$project_name"

    # Check if the vite directory exists
    if [ -d "$vite_dir" ]; then
        # Create the assets directory if it doesn't exist
        mkdir -p "$assets_dir"

        # Copy the contents of the vite directory to the assets directory
        cp -r "$vite_dir/"* "$assets_dir/"

        echo "Vite output copied to $assets_dir from $vite_dir"

        # Check if the manifest.json file exists
        if [ ! -f "$vite_manifest_file" ]; then
            echo "Manifest file not found at $vite_manifest_file"
            return 1
        fi

        # Create the _data directory if it doesn't exist
        mkdir -p "_data"
        
        # Copy the manifest.json file to the data directory
        cp "$vite_manifest_file" "_data/vite_manifest_$project_name.json"

        echo "Manifest file copied to _data/vite_manifest_$project_name.json"
    else
        echo "Vite directory $vite_dir does not exist."
    fi
}

# Loop through all provided project names
for project in $PROJECTS; do
    copy_vite_output "$project"    
done
