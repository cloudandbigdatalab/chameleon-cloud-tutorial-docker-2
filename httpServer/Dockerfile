FROM ubuntu
 
MAINTAINER shawnmaten@gmail.com
 
RUN apt-get update && apt-get install -y nginx

COPY demo-site /etc/nginx/sites-available/
 
RUN ln -s /etc/nginx/sites-available/demo-site /etc/nginx/sites-enabled

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
 
CMD /usr/sbin/nginx
