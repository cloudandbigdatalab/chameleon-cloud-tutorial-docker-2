MAINTAINER shawnmaten@gmail.com

FROM django

RUN pip install uwsgi

WORKDIR /container_files/

COPY test_site/

COPY uwsgi.ini

CMD uwsgi uwsgi.ini
