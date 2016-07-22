#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Arguments Wrong, it should be master's ip"
    exit
fi

callMysqlAddress ()
{
        echo $(curl -sb -H "Accept: application/json" "http://$2:8500/v1/catalog/service/mysql-cluster") \
        | (jq -r ".[] | select(.ServiceID | contains(\"registrator:$1:1186\"))")
}

MGMD=$(callMysqlAddress mysql_mgmd0 $1)
MGMIP=$(echo ${MGMD} | jq -r '.ServiceAddress')
echo "management node's ip ${MGMIP}"
docker build -t jojo13572001/mysql-cluster mysql

if [ "${MGMIP}" != "" ]; then
	docker run -it --rm --name ndb_mgmc jojo13572001/mysql-cluster ndb_mgm ${MGMIP}
else
	echo "management nodei's ip is wrong!"
fi
