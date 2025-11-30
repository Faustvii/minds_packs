#!/usr/bin/env python3
"""
Script to add 'function': 'minds_advancement:add_score' to the rewards section
of all Minecraft advancement JSON files.
"""

import json
import os
from pathlib import Path

def process_advancement_file(file_path):
    """
    Process a single advancement JSON file to add/update the rewards section.

    Args:
        file_path: Path to the JSON file

    Returns:
        True if file was modified, False otherwise
    """
    try:
        # Read the JSON file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Check if rewards section exists
        if 'rewards' not in data:
            # Create rewards section with function
            data['rewards'] = {'function': 'minds_advancement:add_score'}
            modified = True
        else:
            # Rewards section exists, check if function is already there
            if data['rewards'].get('function') != 'minds_advancement:add_score':
                # Add or update the function
                data['rewards']['function'] = 'minds_advancement:add_score'
                modified = True
            else:
                # Already has the correct function
                modified = False

        if modified:
            # Write back to file with proper formatting
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.write('\n')  # Add trailing newline
            print(f"✓ Modified: {file_path}")
            return True
        else:
            print(f"- Skipped (already correct): {file_path}")
            return False

    except json.JSONDecodeError as e:
        print(f"✗ Error parsing JSON in {file_path}: {e}")
        return False
    except Exception as e:
        print(f"✗ Error processing {file_path}: {e}")
        return False

def main():
    # Base directory for advancements
    base_dir = Path(__file__).parent / 'minds_advancements' / 'data' / 'minecraft' / 'advancement'

    if not base_dir.exists():
        print(f"Error: Directory not found: {base_dir}")
        return

    # Find all JSON files recursively
    json_files = list(base_dir.rglob('*.json'))

    if not json_files:
        print(f"No JSON files found in {base_dir}")
        return

    print(f"Found {len(json_files)} JSON files to process\n")

    modified_count = 0
    skipped_count = 0
    error_count = 0

    for json_file in sorted(json_files):
        result = process_advancement_file(json_file)
        if result is True:
            modified_count += 1
        elif result is False:
            skipped_count += 1
        else:
            error_count += 1

    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Total files: {len(json_files)}")
    print(f"  Modified: {modified_count}")
    print(f"  Skipped (already correct): {skipped_count}")
    print(f"  Errors: {error_count}")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
