#!/bin/bash
set -euo pipefail

# removes the first two words from all the file names

# INPUT:
# Bob Dole Movie 1.mp4
# Gene Simmons Movie 2.mp4

# OUTPUT
# Movie 1.mp4
# Movie 2.mp4


# HINT: make a hardlink mirror of the directory first so you can preserve the old names
# cp -al movies-dir movies-dir2


INPUT_DIR="$1"
INPUT_DIR="$(readlink -f "$INPUT_DIR")"


find "$INPUT_DIR" -maxdepth 1 -mindepth 1 -type d | while read -r file; do
    filename=$(basename "$file")
    new_name="$(echo "$filename" | cut -d ' ' -f 3-)"
    new_path="$(dirname "$file")/$new_name"
    if [ ! -e "$new_path" ]; then
        mv "$file" "$new_path"
    fi
done