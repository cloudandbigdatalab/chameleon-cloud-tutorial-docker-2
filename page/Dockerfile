FROM django

MAINTAINER shawnmaten@gmail.com

RUN apt-get update && apt-get install -y \
  netcat

RUN pip install uwsgi

WORKDIR /container/

COPY test_site/ ./test_site/

COPY uwsgi.ini ./

COPY startup.sh ./

ENTRYPOINT ["./startup.sh"]
