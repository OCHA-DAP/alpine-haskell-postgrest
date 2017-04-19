#!/bin/sh
OUTPUT=0;
while [ "$OUTPUT" = 0 ]; do
  echo "Checking for PostgreSQL..."
  OUTPUT=`nc -z -v db 5432 2>&1 | grep -c open`;
  sleep 1
done
echo "PostgreSQL is running!"
postgrest $DB_URL -a $DB_USER

