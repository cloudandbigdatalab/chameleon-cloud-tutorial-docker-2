FROM django

MAINTAINER shawnmaten@gmail.com

RUN pip install uwsgi

WORKDIR /container/

COPY test_site/ ./test_site/

COPY uwsgi.ini ./

CMD python ./test_site/manage.py migrate && uwsgi uwsgi.ini
