#!/bin/bash

apt-get -y update 
apt-get -y upgrade 

sed -i \
  's/^#PermitRootLogin.*/PermitRootLogin yes/' \
  /etc/ssh/sshd_config

systemctl restart sshd


su - root 
mkdir -p /root/.ssh
cd /vagrant
cp id_rsa.pub /root/.ssh/authorized_keys
cp id_rsa /root/.ssh/id_rsa
chmod 600 /root/.ssh/authorized_keys




