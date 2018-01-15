#!/usr/bin/env bash

#System Config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo yum -y update
sudo yum install -y net-tools

#Epel release
if (yum list installed | grep epel-release.noarch);
then
    echo "epel-relase already installed.";
else
    echo "Installing epel-release....";
    sudo yum install -y epel-release;
fi

#htop
if (yum list installed | grep htop.x86_64);
then
    echo "htop.x86_64 already installed.";
else
    echo "Installing htop.x86_64....";
    sudo yum install -y htop;
fi

#wget
if (yum list installed | grep wget.x86_64);
then
    echo "wget.x86_64 already installed.";
else
    echo "Installing wget.x86_64....";
    sudo yum install -y wget;
fi

#JAVA
if (yum list installed | grep jdk1.8.x86_64);
then
    echo "Java 1.8 is already installed.";
else
    echo "installing java 1.8..........";
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm";
    sudo yum -y localinstall -y jdk-8u151-linux-x64.rpm;
fi

#Elasticsearch
if (yum list installed | grep elasticsearch.noarch);
then
    echo "elasticsearch is already installed.";
else
    echo "installing elasticsearch...........";
    sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch;
    sudo echo "[elasticsearch-5.x]
    name=Elasticsearch repository for 5.x packages
    baseurl=https://artifacts.elastic.co/packages/5.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo;
    sudo yum -y install elasticsearch;
    sudo /bin/systemctl daemon-reload;
    sudo /bin/systemctl enable elasticsearch.service;
    echo "changing elastic to ip to 192.168.56.10";
    #TODO: use AWK to get the ip addr and use a variable instead of static
    sudo sed -i 's/#network.host: 192.168.0.1/network.host: 192.168.56.10/' /etc/elasticsearch/elasticsearch.yml;
    sudo systemctl start elasticsearch.service;
fi
 
#Kibana
if (yum list installed | grep kibana.x86_64);
then
    echo "Kibana is already installed.";
else
    echo "Installing kibana..........";
    sudo yum -y install kibana;
    sudo /bin/systemctl daemon-reload;
    sudo /bin/systemctl enable kibana.service;
     #TODO: use AWK to get the ip addr and use a variable instead of static
    sudo sed -i 's/#server.host: "localhost"/server.host: 192.168.56.10/' /etc/kibana/kibana.yml;
    sudo sed -i 's;#elasticsearch.url: "http://localhost:9200";elasticsearch.url: http://192.168.56.10:9200;' /etc/kibana/kibana.yml;
    sudo systemctl start kibana.service;
fi