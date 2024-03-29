#!/bin/bash

ZK_VERSION=3.4.12
if [[ -z "${ROOT_USER}" ]]; then
    root_user=$1
else
    root_user="${ROOT_USER}"
fi

if [[ -z "${ZK_SERVER_NUM}" ]]; then
    num_servers=$2
else
    num_servers="${ZK_SERVER_NUM}"
fi

function install_and_configure_java {
    sudo apt-get update
    sudo apt-get -y install default-jdk
    java -XX:+PrintFlagsFinal -Xms1024m -Xmx3072m -Xss1024k -XX:PermSize=384m -XX:MaxPermSize=512m -version
}

function setup_zk_folders {
    sudo mkdir /zookeeper
    sudo mkdir /zookeeper/data
    sudo mkdir /zookeeper/log
}

function install_zookeeper {
    cd /zookeeper
    sudo wget http://www-eu.apache.org/dist/zookeeper/stable/zookeeper-${ZK_VERSION}.tar.gz
    sudo tar -xzvf zookeeper-${ZK_VERSION}.tar.gz
    sudo ln -s zookeeper-${ZK_VERSION}/ current
    sudo chown -R $root_user /zookeeper
    sudo chown -R $root_user /etc/init.d
}

function create_common_zk_configs {
    cd /zookeeper/current/conf
    cat <<'EOF' >> zoo.cfg
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
dataDir=/zookeeper/data
# Log directory
dataLogDir=/zookeeper/log
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
maxClientCnxns=60
EOF
}

function add_cluster_specific_configs {
    cd /zookeeper/current/conf
    for (( i=1; i<=$num_servers; i++ ))
    do
        echo "server.$i=zk00$i:2888:3888" >> zoo.cfg
    done
}

function run_zk_install {
    install_and_configure_java
    setup_zk_folders
    install_zookeeper
    create_common_zk_configs
    add_cluster_specific_configs
}

run_zk_install