#!/bin/bash

#if [ $# -ne 1 ]
#  then
#    echo "Arguments Number Wrong, it should be ["master" | master's ip(client)]"
#    exit
#fi

ETH0IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
: <<'END'
SWARM_NAME=swarm
CONSUL_NAME=consul
REGISTRATOR_NAME=registrator
  Clean up
echo "start clean containers"
containers=( ${SWARM_NAME} ${REGISTRATOR_NAME} ${CONSUL_NAME} )
for c in ${containers[@]}; do
        docker kill ${c} 
        docker rm ${c} 
done
END

echo "start install docker"
apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
touch /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get purge lxc-docker
apt-get install linux-image-extra-$(uname -r)
apt-get install apparmor
apt-get install -y docker-engine=1.11.1-0~trusty
echo "setup docker"
sudo cp docker /etc/default/docker
service docker restart

: <<'END'
echo "install json parser jq"
sudo wget http://stedolan.github.io/jq/download/linux64/jq
sudo chmod +x ./jq
sudo cp jq /usr/bin
sudo rm -rf ./jq

if [ $1 = "master" ]; then
	echo launch consul  master
	sudo docker run -d --name=${CONSUL_NAME} --net=host gliderlabs/consul-server -advertise ${ETH0IP} -bootstrap

	echo launch swarm master
	sudo docker run -d -p 2376:2375 --name=${SWARM_NAME} ${SWARM_NAME} manage consul://${ETH0IP}:8500/v1/kv/swarm

else

	echo "start swarm agents"
	sudo docker run -d --name ${SWARM_NAME} --restart=always swarm join --advertise=${ETH0IP}:2375 consul://${MASTERIP}:8500/v1/kv/swarm
	echo "start consul registrator"
	sudo docker run -d --name=${REGISTRATOR_NAME} -h ${REGISTRATOR_NAME} --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator -ip ${ETH0IP} consul://$1:8500

fi
END

#echo "install docker compose"
#curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
#chmod +x /usr/local/bin/docker-compose
