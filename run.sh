#!/bin/bash
ETH0IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
MASTERIP=172.31.13.64

if [ $# -ne 1 ]; then
    echo "Arguments Wrong, it should be [-mgmd|-data|-sql|-clean]"
    exit
fi

if [ "$1" == "-mgmd" ]; then
	bash start_node.sh -mgmd 0 1 2 1 ${ETH0IP} 172.31.15.42 172.31.14.144 172.31.2.226
	#bash start_node.sh -mgmd 0 1 2 1 ${ETH0IP} ${ETH0IP} ${ETH0IP} ${ETH0IP} 
elif [ "$1" == "-data0" ]; then
	bash start_node.sh -data 0 ${MASTERIP} 
elif [ "$1" == "-data1" ]; then
	bash start_node.sh -data 1 ${MASTERIP} 
elif [ "$1" == "-sql" ]; then
	bash start_node.sh -sql 0 ${MASTERIP} 
elif [ "$1" == "-clean" ]; then
	docker rm -f $(sudo docker ps -a -f 'name=mysql_mgm' -q)
	docker rm -f $(sudo docker ps -a -f 'name=mysql_sql' -q)
	docker rm -f $(sudo docker ps -a -f 'name=mysql_data' -q)
else 
    echo "Arguments Wrong, it should be [-mgmd|-data|-sql|-clean] [index]"
fi
