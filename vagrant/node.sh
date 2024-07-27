#!/bin/bash

apt-get -y update 
apt-get -y upgrade 

apt-get -y install socat conntrack ipset

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

swapon --show
swapoff -a

sed -i '/^\/dev\/mapper\/debian--12--vg-swap_1/s/^/#/' /etc/fstab




