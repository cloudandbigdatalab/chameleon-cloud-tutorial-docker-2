FROM django

MAINTAINER shawnmaten@gmail.com

RUN pip install uwsgi

WORKDIR /container/

COPY test_site/

COPY uwsgi.ini

CMD uwsgi uwsgi.ini
