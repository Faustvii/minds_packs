#!/bin/bash

# Extract Minecraft data from JAR file
# Usage: ./extract_minecraft_data.sh <path-to-minecraft.jar>
#
# Typical JAR locations:
#   Linux/Mac: ~/.minecraft/versions/[version]/[version].jar
#   Windows: %APPDATA%\.minecraft\versions\[version]\[version].jar

# Check if JAR file path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-minecraft.jar>"
    echo ""
    echo "Example:"
    echo "  $0 ~/.minecraft/versions/1.21.10/1.21.10.jar"
    exit 1
fi

JAR_FILE="$1"
OUTPUT_DIR="minecraft_data"

# Verify JAR file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "Error: JAR file not found: $JAR_FILE"
    exit 1
fi

echo "======================================================================"
echo "Minecraft Data Extractor"
echo "======================================================================"
echo ""
echo "JAR file: $JAR_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Clean existing minecraft_data directory
if [ -d "$OUTPUT_DIR" ]; then
    echo "Cleaning existing data in $OUTPUT_DIR..."
    rm -rf "$OUTPUT_DIR"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Extract data/minecraft/* and version.json from JAR
echo "Extracting data/minecraft/* and version.json..."
unzip -q "$JAR_FILE" "data/minecraft/*" "version.json" -d "$OUTPUT_DIR" 2>/dev/null

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract data from JAR file"
    exit 1
fi

echo "✓ Extraction complete"
echo ""

# Parse and display Minecraft version from version.json
if [ -f "$OUTPUT_DIR/version.json" ]; then
    VERSION=$(grep '"name"' "$OUTPUT_DIR/version.json" | sed 's/.*"name": *"\([^"]*\)".*/\1/')
    if [ -n "$VERSION" ]; then
        echo "Minecraft version: $VERSION"
        echo ""
    fi
fi

# Display subdirectories in data/minecraft/
if [ -d "$OUTPUT_DIR/data/minecraft" ]; then
    echo "Extracted categories:"
    for dir in "$OUTPUT_DIR/data/minecraft"/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            file_count=$(find "$dir" -type f | wc -l)
            echo "  - $dirname/ ($file_count files)"
        fi
    done
else
    echo "Warning: data/minecraft/ not found in extracted data"
fi

echo ""
echo "======================================================================"
echo "✓ Done! Data extracted to $OUTPUT_DIR/"
echo "======================================================================"
