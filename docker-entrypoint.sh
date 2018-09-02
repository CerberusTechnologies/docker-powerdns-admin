#!/usr/bin/env sh
set -eo pipefail

RUNDBCONFIG='no'

if [ ! -z $SECRET_KEY ]; then
  sed -i "s|SECRET_KEY = 'We are the world'|SECRET_KEY = '${SECRET_KEY}'|g" /app/config.py
fi

if [ ! -z $PORT ]; then
  sed -i "s|PORT = 9191|PORT = ${PORT}|g" /app/config.py
fi

if [ ! -z $BIND_ADDRESS ]; then
  sed -i "s|BIND_ADDRESS = '127.0.0.1'|BIND_ADDRESS = '${BIND_ADDRESS}'|g" /app/config.py
fi

if [ ! -z $SQLA_DB_USER ]; then
  sed -i "s|SQLA_DB_USER = 'powerdnsadmin'|SQLA_DB_USER = '${SQLA_DB_USER}'|g" /app/config.py
  RUNDBCONFIG='yes'
fi

if [ ! -z $SQLA_DB_PASSWORD ]; then
  sed -i "s|SQLA_DB_PASSWORD = 'powerdnsadminpassword'|SQLA_DB_PASSWORD = '${SQLA_DB_PASSWORD}'|g" /app/config.py
  RUNDBCONFIG='yes'
fi

if [ ! -z $SQLA_DB_HOST ]; then
  sed -i "s|SQLA_DB_HOST = 'mysqlhostorip'|SQLA_DB_HOST = '${SQLA_DB_HOST}'|g" /app/config.py
  RUNDBCONFIG='yes'
fi

if [ ! -z $SQLA_DB_NAME ]; then
  sed -i "s|SQLA_DB_NAME = 'powerdnsadmin'|SQLA_DB_NAME = '${SQLA_DB_NAME}'|g" /app/config.py
  RUNDBCONFIG='yes'
fi

if [ ! -z $LDAP_TYPE ]; then
  sed -i "s|LDAP_TYPE = 'ldap'|LDAP_TYPE = '${LDAP_TYPE}'|g" /app/config.py
fi

. /app/flask/bin/activate

if [ "${RUNDBCONFIG}"="yes" ]; then
  python /app/create_db.py
fi

python /app/run.py
