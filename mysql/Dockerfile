FROM debian:wheezy

MAINTAINER Henrik Sachse <t3x7m3@posteo.de>


####################################################
# User and group setup
####################################################
ENV MYSQL_USER mysql
ENV MYSQL_GROUP mysql

RUN groupadd mysql && useradd -g mysql mysql


####################################################
# Installation
####################################################
ENV MYSQL_CLUSTER_VERSION 7.4
ENV MYSQL_CLUSTER_MICRO_VERSION 4
ENV MYSQL_CLUSTER_ARCH x86_64

ENV MYSQL_CLUSTER_ARCHIVE_NAME mysql-cluster-gpl-${MYSQL_CLUSTER_VERSION}.${MYSQL_CLUSTER_MICRO_VERSION}-linux-glibc2.5-${MYSQL_CLUSTER_ARCH}
ENV MYSQL_CLUSTER_ARCHIVE ${MYSQL_CLUSTER_ARCHIVE_NAME}.tar.gz

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y perl-modules libaio1 curl

ENV MYSQL_CLUSTER_HOME /usr/local/mysql
ENV MYSQL_CLUSTER_DATA ${MYSQL_CLUSTER_HOME}/data
ENV MYSQL_CLUSTER_LOG /var/lib/mysql-cluster
ENV MYSQL_CLUSTER_CONFIG /etc/mysql-cluster.ini
ENV MYSQL_CLUSTER_INITSQL_SCRIPT /etc/initSql.sql
ENV MYSQL_CLUSTER_INITENV_SCRIPT /etc/initEnv.sh

RUN cd /var/tmp \
    && curl --silent -OL http://dev.mysql.com/get/Downloads/MySQL-Cluster-${MYSQL_CLUSTER_VERSION}/${MYSQL_CLUSTER_ARCHIVE} \
    && mkdir -p ${MYSQL_CLUSTER_HOME} \
    && tar --strip 1 -C ${MYSQL_CLUSTER_HOME} -xzvf ${MYSQL_CLUSTER_ARCHIVE} \
    && rm -v ${MYSQL_CLUSTER_ARCHIVE} \
    && mkdir -p ${MYSQL_CLUSTER_DATA} \
    && chown -R root ${MYSQL_CLUSTER_HOME} \
    && chown -R ${MYSQL_USER} ${MYSQL_CLUSTER_DATA} \
    && chgrp -R ${MYSQL_GROUP} ${MYSQL_CLUSTER_HOME}

RUN cd ${MYSQL_CLUSTER_HOME} \
    && ./scripts/mysql_install_db --user=${MYSQL_USER}

VOLUME ${MYSQL_CLUSTER_LOG}
VOLUME ${MYSQL_CLUSTER_DATA}


####################################################
# Configuration
####################################################
ADD config/my.cnf /etc/my.cnf
ADD config/config.ini ${MYSQL_CLUSTER_CONFIG}
ADD config/initSql.sql ${MYSQL_CLUSTER_INITSQL_SCRIPT}
ADD config/initEnv.sh ${MYSQL_CLUSTER_INITENV_SCRIPT}

EXPOSE 1186 3306


####################################################
# Startup
####################################################
ADD run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
CMD ["ndb_mgm"]
