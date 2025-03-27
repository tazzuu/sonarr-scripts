#!/bin/bash
set -euo pipefail

# dump out the header of each table followed by its contents for easy parsing

# https://stackoverflow.com/questions/22409446/list-all-tables-in-a-db-using-sqlite
# https://sqlite.org/cli.html#querying_the_database_schema

DB="${1:-}"

TABLES_LIST="$(sqlite3 -readonly "${DB}" '.tables' | tr -s ' ' | tr ' ' '\n' | sort -u | grep -v -E '^$')"

for i in $TABLES_LIST; do
echo ">>> $i"
OUTPUT_DIR="tables"
mkdir -p "${OUTPUT_DIR}"
OUTPUT="${OUTPUT_DIR}/table_$i.csv"
OUTPUT_HEAD="${OUTPUT_DIR}/table_${i}_head.csv"
(set -x
sqlite3 -readonly -header -csv "${DB}" "SELECT * FROM $i LIMIT 5" > "$OUTPUT_HEAD"
sqlite3 -readonly -header -csv "${DB}" "SELECT * FROM $i " > "$OUTPUT"
)
done