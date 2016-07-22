#!/bin/bash
/usr/local/mysql/bin/mysqladmin -u root password ${PASSWORD} 
sleep 2
/usr/local/mysql/bin/mysql -uroot -p${PASSWORD} mysql < /etc/initSql.sql
