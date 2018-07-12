#!/bin/sh
OUTPUT=0;
while [ "$OUTPUT" = 0 ]; do
  echo "Checking for PostgreSQL..."
  OUTPUT=`nc -z -v db 5432 2>&1 | grep -c open`;
  sleep 1
done
echo "PostgreSQL is running!"
echo "db-uri = \"$DB_URL\"" > /root/postgrest.conf
echo "db-schema = \"$DB_USER\"" >> /root/postgrest.conf
echo "db-anon-role = \"$DB_USER\"" >> /root/postgrest.conf

postgrest /root/postgrest.conf

