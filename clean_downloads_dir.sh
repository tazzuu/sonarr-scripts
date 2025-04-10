#!/bin/bash
set -euo pipefail

# run this in the Downloads directory to deal with cruft and garbage

# delete all samples since they clutter the Manual Import page
find . -type f -iname "*sample*" -delete

# prune empty dirs
find . -type d -empty -delete