FROM debian:wheezy

MAINTAINER Bean <jojo13572001@yahoo.com.tw>


####################################################
# User and group setup
####################################################


####################################################
# Installation
####################################################
ENV MYSQL_PROXY_CONFIG /etc/mysql-proxy/mysql-proxy.conf
ENV MYSQL_PROXY_DEFAULT /etc/default/mysql-proxy 

RUN apt-get -y update 
RUN apt-get install -y mysql-proxy 
RUN mkdir -p /etc/mysql-proxy
RUN mkdir -p /var/log
RUN touch /var/log/mysql-proxy.log

####################################################
# Configuration
####################################################
ADD config/mysql-proxy.conf ${MYSQL_PROXY_CONFIG}
ADD config/mysql-proxy ${MYSQL_PROXY_DEFAULT}

#EXPOSE 3306


####################################################
# Startup
####################################################
ADD run.sh /run.sh
RUN chmod 660 ${MYSQL_PROXY_CONFIG}
RUN chmod +x /run.sh
ENTRYPOINT ["/bin/bash","/run.sh"]
