FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# WORKDIR /var/www/html
# COPY . /var/www/html/  --this is a best practicse to copy all files and folders in smae structure
COPY index.html /var/www/html/
COPY images /var/www/html/images

EXPOSE 80 82

CMD [ "apache2ctl", "-D", "FOREGROUND" ]
