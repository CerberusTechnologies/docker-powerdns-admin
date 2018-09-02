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
yarn install --pure-lockfile
/app/flask/bin/flask assets build


exec "$@"
