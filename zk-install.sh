#!/bin/bash
sudo apt-get update
sudo apt-get -y install default-jdk
java -XX:+PrintFlagsFinal -Xms1024m -Xmx3072m -Xss1024k -XX:PermSize=384m -XX:MaxPermSize=512m -version | grep -iE 'HeapSize|PermSize|ThreadStackSize'