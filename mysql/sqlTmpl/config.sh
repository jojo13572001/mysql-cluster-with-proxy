#!/bin/bash

MGMD_NUM=$3
DATA_NUM=$4
SQL_NUM=$5

args=("$@")

#define the template.
cat  <<EOF
[NDBD DEFAULT]
NoOfReplicas=2
DataMemory=80M
IndexMemory=18M
datadir=/usr/local/mysql/data

[NDB_MGMD DEFAULT]
datadir=/var/lib/mysql-cluster
EOF

for (( i = 1; i <= ${MGMD_NUM}; i++ )); do
cat  << EOF

[NDB_MGMD]
NodeId=${i}
hostname=${args[$((${i}+4))]}
EOF
done

for (( i = 0; i < ${DATA_NUM}; i++ )); do
cat  << EOF

[NDBD]
NodeId=$((10+${i}))
hostname=${args[$((${i}+5+${MGMD_NUM}))]}
EOF
done

for (( i = 0; i < ${SQL_NUM}; i++ )); do
cat  << EOF

[MYSQLD]
NodeId=$((100+${i}))
hostname=${args[$((${i}+5+${MGMD_NUM}+${DATA_NUM}))]}
EOF
done
