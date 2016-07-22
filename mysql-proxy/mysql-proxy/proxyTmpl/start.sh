#!/bin/bash
apt-get update
apt-get install gettext
envsubst < mysql-proxy.conf > ../config/mysql-proxy.conf
