#!/bin/bash
if [ $# -ne 1 ]; then echo "Arguments Wrong, it should be master's ip" 
	exit 
fi 

callMysqlAddress ()
{
        echo $(curl -sb -H "Accept: application/json" "http://$2:8500/v1/catalog/service/mysql-cluster") \
        | (jq -r ".[] | select(.ServiceID | contains(\"registrator:$1:3306\"))")
}
docker kill mysql-proxy
docker rm -f mysql-proxy


ETH0IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
SQL_NODES_IP=""
for (( i = 0; i < 3; i++ )); do
	MYSQL_SQL=$(callMysqlAddress mysql_sql${i} $1)
	echo ${MYSQL_SQL}
        if [ ! "${MYSQL_SQL}" ]; then
                break
	fi
	if [[ ${i} == 0 ]]; then
        	#data=$(echo ${MYSQL_SQL} | jq ".[0]")
        	TMP_IP=$(echo ${MYSQL_SQL} | jq -r -c ".ServiceAddress")
        	TMP_PORT=$(echo ${MYSQL_SQL} | jq -r -c ".ServicePort")
        	SQL_NODES_IP=$(echo ${SQL_NODES_IP} ${TMP_IP}:${TMP_PORT})
	else
        	#data=$(echo ${MYSQL_SQL} | jq ".[0]")
        	TMP_IP=$(echo ${MYSQL_SQL} | jq -r -c ".ServiceAddress")
        	TMP_PORT=$(echo ${MYSQL_SQL} | jq -r -c ".ServicePort")
        	SQL_NODES_IP=$(echo ${SQL_NODES_IP}","${TMP_IP}:${TMP_PORT})
        fi
	echo "MYSQL_SQL${i}="${MYSQL_SQL}
done
echo SQL_NODES_IP=${SQL_NODES_IP}
docker run -i --rm -v $(pwd)/mysql-proxy/proxyTmpl:/proxyTmpl -v $(pwd)/mysql-proxy/config:/config \
				  -w /proxyTmpl \
				  -e SQL_NODES_IP=${SQL_NODES_IP} \
				  -e ETH0IP=${ETH0IP} \
				  ubuntu:14.04.1 \
				  /bin/bash /proxyTmpl/start.sh

docker build -t jojo13572001/mysql-proxy mysql-proxy

docker run -id --name mysql-proxy --net=host jojo13572001/mysql-proxy
