#!/bin/bash
/etc/init.d/mysql-proxy start
tail -f /var/log/mysql-proxy.log
