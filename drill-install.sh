#!/bin/bash

DRILL_VERSION=1.14.0
DRILL_CONF_FILENAME=drill-override.conf

root_user=$1
drill_cluster_name=$2
num_zk_servers=$3

function setup_java {
    sudo apt-get update
    sudo apt-get -y install default-jre
    sudo apt-get -y install default-jdk
}

function fetch_and_install_drill {
    sudo mkdir /drill
    cd /drill
    sudo wget http://www-us.apache.org/dist/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz
    sudo tar -xvzf apache-drill-${DRILL_VERSION}.tar.gz
    sudo ln -s apache-drill-${DRILL_VERSION}/ current
    sudo chown -R $root_user /drill
    sudo chown -R $root_user /etc/init.d
}

function configure_drill_cluster {
    cd /drill/current/conf
    echo "drill.exec:{" > $DRILL_CONF_FILENAME
    echo "cluster-id: \"$drill_cluster_name\"," >> $DRILL_CONF_FILENAME
    echo -n "zk.connect: \"" >> $DRILL_CONF_FILENAME
    for (( i=1; i<=$num_zk_servers-1; i++ ))
    do
        echo  -n "zk00$i:2181," >> $DRILL_CONF_FILENAME
    done
    echo "zk00$num_zk_servers:2181\"" >> $DRILL_CONF_FILENAME
    echo "}" >> $DRILL_CONF_FILENAME
}