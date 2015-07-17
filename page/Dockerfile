MAINTAINER shawnmaten@gmail.com

FROM django

RUN pip install uwsgi

WORKDIR test-site

CMD uwsgi --ini test-site.ini
