FROM django

MAINTAINER shawnmaten@gmail.com

RUN pip install uwsgi psycopg2

WORKDIR /container/

COPY test_site/ ./test_site/

COPY uwsgi.ini ./

CMD uwsgi uwsgi.ini
