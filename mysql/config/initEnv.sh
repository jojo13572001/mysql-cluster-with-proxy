#!/bin/bash
/usr/local/mysql/bin/mysqladmin -u root password '1234567' 
sleep 2
/usr/local/mysql/bin/mysql -uroot -p'1234567' mysql < /etc/initSql.sql
