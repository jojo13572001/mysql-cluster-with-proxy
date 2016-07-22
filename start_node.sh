#!/bin/bash
#define parameters which are passed in.
if [ $# -eq 0 ]; then
    echo "Arguments Wrong, it should be [-mgmd|-data|-sql] [idx] [mgmd_num] [data_num] [sql_num] [each IPs...]"
    exit
fi

callMysqlAddress ()
{
        echo $(curl -sb -H "Accept: application/json" "http://$2:8500/v1/catalog/service/mysql-cluster") \
        | (jq -r ".[] | select(.ServiceID | contains(\"registrator:$1:1186\"))")
}

ETH0IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
MYSQL_PASSWORD="'1234567'"

if [ "$1" == "-mgmd" ] && [ $# -eq $((5+$3+$4+$5)) ]; then
    if [ $3 -lt 1 ]; then
         echo "mgmd_node should be greater or equal than 1"
                exit
    elif [ $4 -lt 2 ]; then
                echo "data_node should be greater than 2"
                exit
    elif [ $5 -lt 1 ]; then
                echo "sql_node should be greater or equal than 1"
                exit
    else
	for (( i = 0; i <= $2; i++ )); do
        	echo "Clean mysql_mgmd${i}"
        	docker kill mysql_mgmd${i}
        	docker rm -f mysql_mgmd${i}
	done
	docker rm -f $(sudo docker ps -a -f 'name=mysql_sql' -q)
	docker rm -f $(sudo docker ps -a -f 'name=mysql_data' -q)

	echo "start launch management node"
	bash mysql/sqlTmpl/config.sh $@ > mysql/config/config.ini
	bash mysql/sqlTmpl/my.sh $@ > mysql/config/my.cnf
	docker build -t jojo13572001/mysql-cluster mysql 
	docker run -d --name mysql_mgmd$2 --net=host -p ${ETH0IP}:1186:1186 jojo13572001/mysql-cluster ndb_mgmd
    fi
elif [ "$1" == "-data" ] && [ $# -eq 3 ]; then
	echo "start launch data node"
	docker rm -f $(sudo docker ps -a -f 'name=mysql_sql' -q)
	for (( i = 0; i <= $2; i++ )); do
        	echo "Clean mysql_data${i}"
        	docker kill mysql_data${i}
        	docker rm -f mysql_data${i}
	done
	
	MGMD=$(callMysqlAddress mysql_mgmd0 $3)
	MGMIP=$(echo ${MGMD} | jq -r '.ServiceAddress')
	echo "retrieve ${MGMD} mgmd ip ${MGMIP}"
	echo "generate config for data node"
	docker run -i --rm -w /sqlTmpl -v $(pwd)/mysql/sqlTmpl:/sqlTmpl:ro -v $(pwd)/mysql/config:/config \
                -e MGMIP=${MGMIP} \
                ubuntu:14.04.1 /bin/bash /sqlTmpl/start.sh
	
	docker build -t jojo13572001/mysql-cluster mysql 
	echo Start launch data node MGMIP=${MGMIP}
	docker run -d --name mysql_data$2 --net=host jojo13572001/mysql-cluster ndbd ${MGMIP} 

elif [ "$1" == "-sql" ] && [ $# -eq 3 ]; then
	echo "start launch sql node"
	for (( i = 0; i <= $2; i++ )); do
        	echo "Clean mysql_sql${i}"
        	docker kill mysql_sql${i}
        	docker rm -f mysql_sql${i}
	done
	MGMD=$(callMysqlAddress mysql_mgmd0 $3)
	MGMIP=$(echo ${MGMD} | jq -r '.ServiceAddress')
	echo "retrieve ${MGMD} mgmd ip ${MGMIP}"
	echo "generate config for data node"
	docker run -i --rm -w /sqlTmpl -v $(pwd)/mysql/sqlTmpl:/sqlTmpl:ro -v $(pwd)/mysql/config:/config \
               -e MGMIP=${MGMIP} \
               -e PASSWORD=${MYSQL_PASSWORD} \
               ubuntu:14.04.1 /bin/bash /sqlTmpl/start.sh
	
	docker build -t jojo13572001/mysql-cluster mysql 
	echo Start launch sql node
	docker run -d --name mysql_sql$2 --net=host -p ${ETH0IP}:3306:3306 \
						    jojo13572001/mysql-cluster mysqld ${MGMIP}
	sleep 3
	echo "start init sql node environment"
	sudo docker exec -i mysql_sql$2 /bin/bash "/etc/initEnv.sh" 
else
    echo "Default arguments Wrong, it should be [-mgmd|-data|-sql] [idx] [mgmd_num] [data_num] [sql_num] [each IPs...]"
fi
