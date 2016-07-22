#/bin/bash
MGMD_NUM=$3
args=("$@")

for (( i = 1; i <= ${MGMD_NUM}; i++ )); do
	if [ ${i} -eq 1 ]; then
	MGMIP=${args[$((${i}+4))]}
	else
	MGMIP=${MGMIP}","${args[$((${i}+4))]}
	fi
done
cat  << EOF
[MYSQLD]
ndbcluster                     
ndb-connectstring=${MGMIP} 
EOF

# Options for ndbd process:
cat  << EOF

[MYSQL_CLUSTER]
ndb-connectstring=${MGMIP}
EOF
