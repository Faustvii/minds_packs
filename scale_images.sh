#!/bin/bash

# Create scaled directory if it doesn't exist
mkdir -p scaled

# Define scale sizes (multiplier -> dimensions)
declare -A sizes=(
    ["1x1"]="32x32"
    ["1x2"]="32x64"
    ["1x3"]="32x96"
    ["1x4"]="32x128"

    ["2x1"]="64x32"
    ["2x2"]="64x64"
    ["2x3"]="64x96"
    ["2x4"]="64x128"

    ["3x1"]="96x32"
    ["3x2"]="96x64"
    ["3x3"]="96x96"
    ["3x4"]="96x128"

    ["4x1"]="128x32"
    ["4x2"]="128x64"
    ["4x3"]="128x96"
    ["4x4"]="128x128"
)

# Source directories to process
source_dirs=("2x2" "2x4" "4x2" "4x4")

# Process each source directory
for source_dir in "${source_dirs[@]}"; do
    [ -d "$source_dir" ] || continue

    echo "Processing directory: $source_dir"

    # Get the dimensions for this directory
    dimensions="${sizes[$source_dir]}"
    output_dir="scaled/${source_dir}"

    # Create output directory
    mkdir -p "$output_dir"

    # Process each image file in the directory
    for file in "$source_dir"/*; do
        # Skip if not a file
        [ -f "$file" ] || continue

        # Get just the filename without path
        filename=$(basename "$file")

        # Get lowercase filename
        lowercase_name=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

        # Scale image
        magick "$file" -resize "$dimensions" "$output_dir/$lowercase_name"
        echo "  Created: $output_dir/$lowercase_name ($dimensions)"
    done
done

echo "Scaling complete!"
