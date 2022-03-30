#!/bin/bash

DB_USER="fcops"
DB_NAME="bacula"
OUTPUT_DIR="/opt/bacula/db/tmp"

# Remove existing dump if any
rm -f "${OUTPUT_DIR}/${DB_NAME}.sql"
