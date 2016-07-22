#!/bin/bash
apt-get update
apt-get install gettext
#envsubst < my.cnf > ../config/my.cnf
envsubst < initSql.sql > ../config/initSql.sql
envsubst < initEnv.sh > ../config/initEnv.sh
