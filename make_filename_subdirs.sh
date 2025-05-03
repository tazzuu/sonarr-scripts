#!/bin/bash
set -euo pipefail

# move files into subdirs based on the filename without extensions

# input:
# foo.mp4
# foo.srt

# output:
# foo/foo.mp4
# foo/foo.srt

INPUT_DIR="$1"
INPUT_DIR="$(readlink -f "$INPUT_DIR")"

find "$INPUT_DIR" -type f | while read -r file; do
    new_dir="${file%.*}"
    echo "file: $file new_dir: $new_dir"

    if [ ! -e "$new_dir" ]; then
        mkdir -p "$new_dir"
    fi

    if [ -d "$new_dir" ]; then
        mv "$file" "$new_dir/"
    fi

done
