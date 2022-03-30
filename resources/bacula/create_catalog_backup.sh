#!/bin/bash

DB_USER="fcops"
DB_NAME="bacula"
OUTPUT_DIR="/opt/bacula/db/tmp"

# Remove existing dump if any
rm -f "${OUTPUT_DIR}/${DB_NAME}.sql"

# Dump database with compression level 1
/usr/bin/pg_dump -Z1 -U "$DB_USER" -c "$DB_NAME" > "${OUTPUT_DIR}/${DB_NAME}.sql"

# Run start script
/opt/bacula/scripts/slack_job_start_notif.sh
