#!/bin/bash

# Если папка данных пуста, инициализируем БД
if [ ! -f /pgdata/PG_VERSION ]; then
  echo "$DB_PASS" > /tmp/pgpass
  /opt/pgpro/1c-17/bin/initdb --auth-host=md5 --pwfile=/tmp/pgpass --pgdata=/pgdata
  rm -f /tmp/pgpass

  # Разрешаем внешние подключения
  echo "listen_addresses = '*'" >> /pgdata/postgresql.conf
fi

# Запуск PostgreSQL от имени пользователя postgres
exec /opt/pgpro/1c-17/bin/postgres -D /pgdata
