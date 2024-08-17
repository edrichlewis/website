FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

WORKDIR /var/www/html

CMD [ "apache2ctl", "-D", "FOREGROUND" ]
