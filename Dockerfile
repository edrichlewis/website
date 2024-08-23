FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# WORKDIR /var/www/html
COPY index.html /var/www/html/

EXPOSE 80 82

CMD [ "apache2ctl", "-D", "FOREGROUND" ]
