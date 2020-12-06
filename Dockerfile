FROM linode/lamp

MAINTAINER lamp(ubuntu14+apache2.4.7+mysql5.5.62+PHP5.5.9) <mysql_password:Admin2015>

ENV DEBIAN_FRONTEND noninteractive
ADD ./source /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade && apt-get -y install vim unzip php-pear php5-mysql curl libcurl3 libcurl3-dev php5-curl php5-gd
COPY web/* /var/www/example.com/public_html/
WORKDIR /var/www/example.com/
RUN chmod 777 -R public_html
RUN service apache2 start && service mysql start

