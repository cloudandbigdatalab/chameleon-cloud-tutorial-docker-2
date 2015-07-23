#!/bin/bash
until nc -z db $DB_PORT_5432_TCP_PORT; do
    echo "$(date) - still trying to connect to db"
    sleep 1
done
python ./test_site/manage.py migrate
uwsgi uwsgi.ini
