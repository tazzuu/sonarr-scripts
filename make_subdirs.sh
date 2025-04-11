#!/bin/bash
set -euo pipefail

# put all the files in subdirs by first character
# so we can do Interactive Manual Import easier

find . -maxdepth 1 -mindepth 1 ! -ipath "*_UNPACK_*" ! -name ".*" | while read filename ; do

# skip if its this script
if [ "$filename" == "$0" ]; then
break
fi

name="$(basename "$filename")"
firstChar="${name:0:1}"
nameLength="${#name}"

# check if filename greater than 1 character
if [ "${nameLength}" -gt 1 ]; then
echo "$firstChar - $nameLength - $name"
mkdir -p "$firstChar"
mv "${name}" "${firstChar}/"
fi

done
