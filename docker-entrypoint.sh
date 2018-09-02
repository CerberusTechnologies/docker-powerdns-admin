#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

DB_MIGRATION_DIR='/app/migrations'

if [ ! -d "${DB_MIGRATION_DIR}" ]; then
  /app/flask/bin/flask db init --directory ${DB_MIGRATION_DIR}
  /app/flask/bin/flask db migrate -m "Init DB" --directory ${DB_MIGRATION_DIR}
  /app/flask/bin/flask db upgrade --directory ${DB_MIGRATION_DIR}
  ./init_data.py

else
  set +e
  /app/flask/bin/flask db migrate -m "Upgrade DB Schema" --directory ${DB_MIGRATION_DIR}
  /app/flask/bin/flask db upgrade --directory ${DB_MIGRATION_DIR}
  set -e
fi
chown -R www-data:www-data /powerdns-admin/app/static
chown -R www-data:www-data /powerdns-admin/node_modules
su -s /bin/bash -c 'yarn install --pure-lockfile' www-data

chown -R www-data:www-data /powerdns-admin/logs
su -s /bin/bash -c '/app/flask/bin/flask assets build' www-data
