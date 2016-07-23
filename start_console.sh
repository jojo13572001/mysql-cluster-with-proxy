#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Arguments Wrong, it should be mgmd's ip"
    exit
fi

MGMIP=$1
echo "management node's ip ${MGMIP}"
docker build -t jojo13572001/mysql-cluster mysql

docker run -it --rm --name ndb_mgmc jojo13572001/mysql-cluster ndb_mgm ${MGMIP}
