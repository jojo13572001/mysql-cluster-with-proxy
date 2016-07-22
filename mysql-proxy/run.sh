#!/bin/bash
if [ $# -eq 0 ]; then echo "Arguments Wrong, it should be sql node's ip" 
	exit 
fi 

docker kill mysql-proxy
docker rm -f mysql-proxy
args=("$@")

ETH0IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

SQL_NODES_IP=""
for (( i = 0; i < $#; i++ )); do
        if [ ${i} -eq 0 ]; then
        SQL_NODES_IP=${args[${i}]}":3306"
        else
        SQL_NODES_IP=${SQL_NODES_IP}","${args[${i}]}":3306"
        fi
done

docker run -i --rm -v $(pwd)/mysql-proxy/proxyTmpl:/proxyTmpl -v $(pwd)/mysql-proxy/config:/config \
				  -w /proxyTmpl \
				  -e SQL_NODES_IP=${SQL_NODES_IP} \
				  -e ETH0IP=${ETH0IP} \
				  ubuntu:14.04.1 \
				  /bin/bash /proxyTmpl/start.sh

docker build -t jojo13572001/mysql-proxy mysql-proxy

docker run -id --name mysql-proxy --net=host jojo13572001/mysql-proxy
